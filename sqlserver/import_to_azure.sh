#!/usr/bin/env bash

set -o errexit
set -o xtrace

[[ -z "${SQL_SERVER_USER_NAME}" ]] && echo "\${SQL_SERVER_USER_NAME} environment variable is not available."
echo "\${SQL_SERVER_USER_NAME}:${SQL_SERVER_USER_NAME}";

[[ -z "${SQL_SERVER_USER_PASSWORD}" ]] && echo "\${SQL_SERVER_USER_PASSWORD} environment variable is not available."
echo "\${SQL_SERVER_USER_PASSWORD}:${SQL_SERVER_USER_PASSWORD}";

/usr/local/bin/sqlcmd \
    -S "${SQL_SERVER_NAME}" \
    -U "${SQL_SERVER_USER_NAME}" \
    -P "${SQL_SERVER_USER_PASSWORD}" \
    -Q 'SELECT @@VERSION'

/usr/local/bin/sqlcmd \
    -S "${SQL_SERVER_NAME}" \
    -U "${SQL_SERVER_USER_NAME}" \
    -P "${SQL_SERVER_USER_PASSWORD}" \
    -Q 'CREATE DATABASE IF NOT EXISTS HashiCorp;'

/usr/local/bin/sqlcmd \
    -S "${SQL_SERVER_NAME}" \
    -U "${SQL_SERVER_USER_NAME}" \
    -P "${SQL_SERVER_USER_PASSWORD}" \
    -d 'HashiCorp' \
    -i CreateHashiCorpTable.sql

/usr/local/bin/bcp \
    Projects in projects.csv \
    -S "${SQL_SERVER_NAME}" \
    -U "${SQL_SERVER_USER_NAME}" \
    -P "${SQL_SERVER_USER_PASSWORD}" \
    -d 'HashiCorp' \
    -c \
    -t ','

# Ignore the errors. Import works.
#
# Starting copy...
# SQLState = 22005, NativeError = 0
# Error = [Microsoft][ODBC Driver 17 for SQL Server]Invalid character value for cast specification

# 8 rows copied.
# Network packet size (bytes): 4096
# Clock Time (ms.) Total     : 53     Average : (150.9 rows per sec.)

/usr/local/bin/sqlcmd \
    -S "${SQL_SERVER_NAME}" \
    -U "${SQL_SERVER_USER_NAME}" \
    -P "${SQL_SERVER_USER_PASSWORD}" \
    -d 'HashiCorp' \
    -Q 'SELECT TOP (50) * FROM Projects;'

# /usr/local/bin/sqlcmd \
#     -S "${SQL_SERVER_NAME}" \
#     -U "${SQL_SERVER_USER_NAME}" \
#     -P "${SQL_SERVER_USER_PASSWORD}" \
#     -i "InsertRandomData.sql"
