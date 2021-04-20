#!/usr/bin/env bash

set -o errexit
# set -o xtrace

/usr/src/app/import.sh & /opt/mssql/bin/sqlservr
