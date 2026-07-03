select name,type_desc,is_disabled from sys.server_principals 
where type in ('S','U')
and name not in ('sa','NT AUTHORITY\SYSTEM')