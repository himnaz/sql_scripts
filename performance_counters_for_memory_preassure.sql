SELECT object_name, counter_name, cntr_value, cntr_type
FROM sys.dm_os_performance_counters
WHERE ([object_name] LIKE '%Buffer Manager%' or [object_name] LIKE '%Memory Manager%')
AND [counter_name] in ('Lazy writes/sec','Free list stalls/sec','Page life expectancy','Memory Grants Pending')