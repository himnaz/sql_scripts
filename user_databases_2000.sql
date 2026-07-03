--sqlcmd -S ENTAAP271P\INST6 -i user_databases_2000.sql

use master
go
select name,status from sysdatabases where name not in ('master','msdb','model','tempdb','SQLDBADB')
go