-- sqlcmd -S <servername>\<instancename> -i <database_users.sql>
-- or interactive mode
-- sqlcmd -S <servername>\<instancename> 
-- >:r database_users.sql

SELECT * FROM sys.database_principals where type in ('U','S');
go