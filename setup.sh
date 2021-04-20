#!/usr/bin/env bash

set -o errexit
# set -o xtrace

GIT_TOP_DIRECTORY="$(git rev-parse --show-toplevel)"
SCRIPT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# ----------------------------------------------------------------------

# https://stackoverflow.com/a/31397073
# mktemp --directory "${TMPDIR:-/tmp}/zombie.XXXXXXXXX"
TEMPORARY_DIRECTORY="$(mktemp --directory --tmpdir=${PWD})"

function cleanUp {
    rm \
        --recursive \
        --verbose \
        "${TEMPORARY_DIRECTORY}"
}
trap cleanUp EXIT

# ----------------------------------------------------------------------

[[ -z "${VAULT_ADDR}" ]] && echo "\${VAULT_ADDR} environment variable is not available."
echo "\${VAULT_ADDR}:${VAULT_ADDR}";

[[ -z "${VAULT_TOKEN}" ]] && echo "\${VAULT_TOKEN} environment variable is not available."
echo "\${VAULT_TOKEN}:${VAULT_TOKEN}";

VAULT_MASTER_KEYS=(
    "${VAULT_MASTER_KEY_1}"
    "${VAULT_MASTER_KEY_2}"
    "${VAULT_MASTER_KEY_3}"
    )
for key in "${VAULT_MASTER_KEYS[@]}"
do
	vault operator unseal "${key}"
done

vault login ${VAULT_TOKEN}

vault secrets enable -path='project-acme/database' database || true
vault secrets enable -path='project-acme/secrets' -version=2 kv || true

vault kv put project-acme/secrets/static 'password=Testing!123'

vault write project-acme/database/config/acme-sql-server \
        plugin_name=mssql-database-plugin \
        connection_url='sqlserver://{{username}}:{{password}}@sqlserver:1433' \
        allowed_roles="project-acme-role" \
        username="${SQL_SERVER_USER_NAME}" \
        password="${SQL_SERVER_USER_PASSWORD}"

vault write project-acme/database/roles/project-acme-role \
    db_name=acme-sql-server \
    creation_statements=" \
        CREATE LOGIN [{{name}}] WITH PASSWORD = '{{password}}'; \
        USE HashiCorp; \
        CREATE USER [{{name}}] FOR LOGIN [{{name}}]; \
        GRANT SELECT,UPDATE,INSERT,DELETE TO [{{name}}]; \
        " \
    default_ttl="10m" \
    max_ttl="20m"

vault policy write project-acme ./project-role-policy.hcl

vault auth enable approle || true
vault write auth/approle/role/project-acme-role \
    role_id="project-acme-role" \
    token_policies="project-acme" \
    token_ttl=10m \
    token_max_ttl=20m \
    secret_id_num_uses=5

echo "project-acme-role" > "${SCRIPT_DIRECTORY}/ProjectAcme/vault-agent/role-id"
vault write -force -field=secret_id auth/approle/role/project-acme-role/secret-id > "${SCRIPT_DIRECTORY}/ProjectAcme/vault-agent/secret-id"
