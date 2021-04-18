# SQL Server

## Getting Started

- Get SQL Server version.

```bash
docker exec -it \
    $(docker ps --filter "name=sqlserver" --quiet)  \
     /opt/mssql-tools/bin/sqlcmd \
    -S localhost -U 'SA' -P "${SQLSERVER_SA_USER_PASSWORD}" \
    -Q 'SELECT @@VERSION'
```

```text
Microsoft SQL Server 2019 (RTM-CU10) (KB5001090) - 15.0.4123.1 (X64)
        Mar 22 2021 18:10:24
        Copyright (C) 2019 Microsoft Corporation
        Developer Edition (64-bit) on Linux (Ubuntu 20.04.2 LTS) <X64>
```

### Insert Data

```bash
docker exec -it \
    $(docker ps --filter "name=sqlserver" --quiet)  \
     /opt/mssql-tools/bin/sqlcmd \
    -S localhost -U 'SA' -P "${SQLSERVER_SA_USER_PASSWORD}" \
    -i "InsertRandomData.sql"
```

```bash
docker exec -it \
    $(docker ps --filter "name=sqlserver" --quiet)  \
     /opt/mssql-tools/bin/sqlcmd \
    -S localhost -U 'SA' -P "${SQLSERVER_SA_USER_PASSWORD}" \
    -Q "INSERT INTO AcmeSchema.AcmeTable (RandomString, RandomDateTime) VALUES (N'ABCD1234', N'1970-01-01T00:00:00.00Z');"
```

### List Data

```bash
docker exec -it \
    $(docker ps --filter "name=sqlserver" --quiet)  \
     /opt/mssql-tools/bin/sqlcmd \
    -S localhost -U 'SA' -P "${SQLSERVER_SA_USER_PASSWORD}" \
    -Q 'SELECT TOP (50) * FROM AcmeSchema.AcmeTable;'
```

### List Users

```bash
docker exec -it \
    $(docker ps --filter "name=sqlserver" --quiet)  \
     /opt/mssql-tools/bin/sqlcmd \
    -S localhost -U 'SA' -P "${SQLSERVER_SA_USER_PASSWORD}" \
    -Q 'SELECT * FROM master.sys.database_principals WHERE name LIKE "v-root%";'
```

### List Databases

```bash
docker exec -it \
    $(docker ps --filter "name=sqlserver" --quiet)  \
     /opt/mssql-tools/bin/sqlcmd \
    -S localhost -U 'SA' -P "${SQLSERVER_SA_USER_PASSWORD}" \
    -Q 'SELECT name FROM master.sys.databases;'
```

```text
name
--------------------------------------------------------------------------------------------------------------------------------
master
tempdb
model
msdb
```

- Optional: [Restore SQL Server Database in a Linux Container](https://docs.microsoft.com/en-us/sql/linux/tutorial-restore-backup-in-sql-server-container).

## Adminer (SQL Server)

```text
System: MS SQL (Beta)
Server: sqlserver
Username: sa
Password: CHANGEME
Database: master
```
