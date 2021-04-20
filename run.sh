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

cd ProjectAcme

dotnet restore

VAULT_SECRET_ID=$(cat vault-agent/secret-id) dotnet run
