USE [master];
CREATE LOGIN [{{name}}] WITH PASSWORD='{{password}}', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF;

USE [master];
CREATE USER [{{name}}] FOR LOGIN [{{name}}];ALTER ROLE [db_datareader] ADD MEMBER [{{name}}];
