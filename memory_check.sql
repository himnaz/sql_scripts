select name, value, value_in_use, minimum, maximum, physical_memory_in_bytes/1024/1024 as physical_server_mb
from sys.configurations 
cross join sys.dm_os_sys_info 
where name in ( 'min server memory (MB)', 'max server memory (MB)' )
go