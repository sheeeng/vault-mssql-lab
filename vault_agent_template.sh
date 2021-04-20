#!/bin/bash

vault write project-acme/database/roles/project-acme-role \
    db_name=acme-sql-server \
    creation_statements=" \
        CREATE LOGIN [{{name}}] WITH PASSWORD = '{{password}}'; \
        USE HashiCorp; \
        CREATE USER [{{name}}] FOR LOGIN [{{name}}]; \
        GRANT SELECT,UPDATE,INSERT,DELETE TO [{{name}}]; \
        " \
    default_ttl="2m" \
    max_ttl="4m"

docker-compose \
    --file docker-compose-vault-agent-template.yml \
    up
