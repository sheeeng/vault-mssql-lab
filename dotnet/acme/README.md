# Use .NET Core (C#) to Query a Database

See the [example](https://docs.microsoft.com/en-us/azure/azure-sql/database/connect-query-dotnet-core).

## Prerequisites

- Use [direnv](https://direnv.net/). Create a [.envrc](.envrc) file with the following content.

```bash
source_env_if_exists ${HOME}/.envrc

export VAULT_ADDR="https://localhost:8200"
export VAULT_TOKEN="s.ABCDEGHIJKLMNO1234567890"

export SQL_SERVER_USER_NAME='SA'
export SQL_SERVER_USER_PASSWORD='CHANGEME'
export SQL_SERVER_NAME="127.0.0.1"
export SQL_DATABASE_NAME="master"
```

## Generate Data

```bash
sqlcmd \
    -S "${SQL_SERVER_NAME}" \
    -U "${SQL_SERVER_USER_NAME}" \
    -P "${SQL_SERVER_USER_PASSWORD}" \
    -d "${SQL_DATABASE_NAME}" \
    -i "CreateTestData.sql"
```

## Drop Table

```bash
sqlcmd \
    -S "${SQL_SERVER_NAME}" \
    -U "${SQL_SERVER_USER_NAME}" \
    -P "${SQL_SERVER_USER_PASSWORD}" \
    -d "${SQL_DATABASE_NAME}" \
    -Q "DROP TABLE TestSchema.AcmeTable; DROP SCHEMA TestSchema;"
```

## Optional

[Debug](https://opensource.com/article/20/6/debug-go-delve) using Delve library.

```bash
go get -u -v github.com/go-delve/delve/cmd/dlv
ls -aln $GOPATH/bin/dlv
```

[Test](https://docs.microsoft.com/en-us/azure/azure-sql/database/connect-query-go) connection string using Go.

```bash
go get -u -v github.com/denisenkom/go-mssqldb
go install -v github.com/denisenkom/go-mssqldb@latest
```

Install the tools.

```bash
brew tap microsoft/mssql-release https://github.com/Microsoft/homebrew-mssql-release
brew update
brew install msodbcsql mssql-tools
```
