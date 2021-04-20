#!/usr/bin/env bash

set -o errexit
# set -o xtrace

# Wait for the SQL Server.
sleep 10s

[[ -z "${SQL_SERVER_USER_NAME}" ]] && echo "\${SQL_SERVER_USER_NAME} environment variable is not available."
echo "\${SQL_SERVER_USER_NAME}:${SQL_SERVER_USER_NAME}";

[[ -z "${SQL_SERVER_USER_PASSWORD}" ]] && echo "\${SQL_SERVER_USER_PASSWORD} environment variable is not available."
echo "\${SQL_SERVER_USER_PASSWORD}:${SQL_SERVER_USER_PASSWORD}";

/opt/mssql-tools/bin/sqlcmd \
    -S 'localhost' \
    -U "${SQL_SERVER_USER_NAME}" \
    -P "${SQL_SERVER_USER_PASSWORD}" \
    -Q 'SELECT @@VERSION'

/opt/mssql-tools/bin/sqlcmd \
    -S 'localhost' \
    -U "${SQL_SERVER_USER_NAME}" \
    -P "${SQL_SERVER_USER_PASSWORD}" \
    -d 'master' \
    -i CreateHashiCorpTable.sql

/opt/mssql-tools/bin/bcp \
    Projects in /usr/src/app/projects.csv \
    -S 'localhost' \
    -U "${SQL_SERVER_USER_NAME}" \
    -P "${SQL_SERVER_USER_PASSWORD}" \
    -d 'HashiCorp' \
    -c \
    -t ','

/opt/mssql-tools/bin/sqlcmd \
    -S 'localhost' \
    -U "${SQL_SERVER_USER_NAME}" \
    -P "${SQL_SERVER_USER_PASSWORD}" \
    -Q 'SELECT TOP (50) * FROM HashiCorp.dbo.Projects;'

/opt/mssql-tools/bin/sqlcmd \
    -S 'localhost' \
    -U "${SQL_SERVER_USER_NAME}" \
    -P "${SQL_SERVER_USER_PASSWORD}" \
    -i "InsertRandomData.sql"
