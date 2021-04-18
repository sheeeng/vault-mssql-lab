# vault-mssql-lab

A small lab for playing with Hashicorp Vault and SQL Server

Blog posting using this repo:
https://www.hindenes.com/2017-07-07_Automating-SQL-Server-credential-rotation-using-Hashicorp-Vault-b71792d9c227/

## Getting Started

```bash
docker compose up
docker compose down --remove-orphans --rmi local --volumes
```

### Vault

This section supplements this [guide](https://learn.hashicorp.com/tutorials/vault/database-secrets).


```bash
docker exec -it \
    $(docker ps --filter "name=vault" --quiet)  \
    sh -c "VAULT_ADDR='http://127.0.0.1:8200' vault operator init"
```

```text
Unseal Key 1: Wu0o/OiGSs8o0tyOKUReXLMdo7V3YhKFAEqk1e9mmpaZ
Unseal Key 2: Fd3uYte9Zhy0Mh++JcC4Z2KOAAtH3G31l+dJF54BmgwK
Unseal Key 3: ghgyVO0w+61XffpNu/l95PymRc7Fnnon2t6RykXftL85
Unseal Key 4: FDPQVXsgzjojgTFHJQK7CMhqhwZ863FooMThTBhWPlFo
Unseal Key 5: NDMEmpbR0n5tCeRqc+4y8Irn9guVr7toisNraUypB6l+

Initial Root Token: s.wTDI7WJ05eF3qTs9QzorgD65

Vault initialized with 5 key shares and a key threshold of 3. Please securely
distribute the key shares printed above. When the Vault is re-sealed,
restarted, or stopped, you must supply at least 3 of these keys to unseal it
before it can start servicing requests.

Vault does not store the generated master key. Without at least 3 key to
reconstruct the master key, Vault will remain permanently sealed!

It is possible to generate new unseal keys, provided you have a quorum of
existing unseal keys shares. See "vault operator rekey" for more information.
```

```bash
docker exec -it \
    $(docker ps --filter "name=vault" --quiet)  \
    sh -c "VAULT_ADDR='http://127.0.0.1:8200' \
    vault operator unseal Wu0o/OiGSs8o0tyOKUReXLMdo7V3YhKFAEqk1e9mmpaZ"
docker exec -it \
    $(docker ps --filter "name=vault" --quiet)  \
    sh -c "VAULT_ADDR='http://127.0.0.1:8200' \
    vault operator unseal Fd3uYte9Zhy0Mh++JcC4Z2KOAAtH3G31l+dJF54BmgwK"
docker exec -it \
    $(docker ps --filter "name=vault" --quiet)  \
    sh -c "VAULT_ADDR='http://127.0.0.1:8200' \
    vault operator unseal ghgyVO0w+61XffpNu/l95PymRc7Fnnon2t6RykXftL85"
```

```bash
docker exec -it \
    $(docker ps --filter "name=vault" --quiet)  \
    sh -c "VAULT_ADDR='http://127.0.0.1:8200' \
    vault login s.wTDI7WJ05eF3qTs9QzorgD65"
```

```bash
docker exec -it \
    $(docker ps --filter "name=vault" --quiet)  \
    sh -c "VAULT_ADDR='http://127.0.0.1:8200' \
    vault secrets enable database"
```

```bash
docker exec -it \
    $(docker ps --filter "name=vault" --quiet)  \
    sh -c "\
    VAULT_ADDR='http://127.0.0.1:8200' \
    vault write database/config/sqlserver \
        plugin_name=mssql-database-plugin \
        connection_url='sqlserver://{{username}}:{{password}}@sqlserver:1433' \
        allowed_roles='readonly' \
        username='SA' \
        password='5fbR(DKr' \
        "
```

```bash
docker exec -it \
    $(docker ps --filter "name=vault" --quiet)  \
    sh -c "VAULT_ADDR='http://127.0.0.1:8200' \
    vault policy write administrative administrative-policies.hcl"
docker exec -it \
    $(docker ps --filter "name=vault" --quiet)  \
    sh -c "VAULT_ADDR='http://127.0.0.1:8200' \
    vault policy write readonly readonly-policies.hcl"
```

```bash
docker exec -it \
    $(docker ps --filter "name=sqlserver" --quiet)  \
     /opt/mssql-tools/bin/sqlcmd \
    -S localhost -U 'SA' -P "${SQLSERVER_SA_USER_PASSWORD}" \
    -Q 'CREATE DATABASE AcmeDatabase;'
```

```bash
docker exec -it \
    $(docker ps --filter "name=vault" --quiet)  \
    sh -c "\
    VAULT_ADDR='http://127.0.0.1:8200' \
    vault write database/roles/readonly \
      db_name=sqlserver \
      creation_statements=@readonly.sql \
      default_ttl=10m \
      max_ttl=20m \
      "
```

```bash
docker exec -it \
    $(docker ps --filter "name=vault" --quiet)  \
    sh -c "\
    VAULT_ADDR='http://127.0.0.1:8200' \
    vault read database/creds/readonly \
    "
```

```text
Key                Value
---                -----
lease_id           database/creds/readonly/nVOZWqRQmNOjM7AvscfZhwYA
lease_duration     10m
lease_renewable    true
password           XgB5JgXRTVn-FSTUwqqU
username           v-root-readonly-s1hzEDnj0TOY2Ku713z0-1618774260
```

```bash
docker exec -it \
    $(docker ps --filter "name=vault" --quiet)  \
    sh -c "\
    VAULT_ADDR='http://127.0.0.1:8200' \
    vault list -format=json sys/leases/lookup/database/creds/readonly \
    " | jq -r ".[]"
```
