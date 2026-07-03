-- sqlcmd -S <servername>\<instancename> -i <instance_users.sql>
-- or interactive mode
-- sqlcmd -S <servername>\<instancename> 
-- >:r instance_users.sql

SELECT principal_id,name,type,default_database_name FROM sys.server_principals where type in ('U','S');
go
