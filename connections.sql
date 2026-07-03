-- sqlcmd -S <servername>\<instancename> -i <connections.sql>
-- or interactive mode
-- sqlcmd -S <servername>\<instancename> 
-- >:r connections.sql


select * from sys.dm_exec_connections
go