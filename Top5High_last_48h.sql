declare @Q nvarchar(max)
	, @i int=1
while @i <= 4
begin
	set @Q=N'/*Exclude myself GUID:b398db32-1176-4fb8-9a06-2da9cb6eb680*/
	SELECT top 5
		  '''+(	case @i 
				when 1 then 'High logical reads'
				when 2 then 'Avg High logical reads'
				when 3 then 'High metric IO'
				when 4 then 'High Last Elapse Time'
				else 'no order'
				end)+N'''[Ranking]
		, qp.query_plan
		, high_io.execution_count * high_io.last_elapsed_time/1000/1000[metricDur]
		, high_io.total_logical_reads / high_io.execution_count[metricIO]
		, (high_io.execution_count*high_io.last_elapsed_time/1000/1000) + (high_io.total_logical_reads/high_io.execution_count)[metric]
		, SUBSTRING(q.TEXT, (high_io.statement_start_offset/2)+1,((CASE high_io.statement_end_offset WHEN -1 THEN DATALENGTH(q.TEXT) ELSE
		  high_io.statement_end_offset END - high_io.statement_start_offset)/2)+1)[Qy]
		, case when DB_NAME(q.dbid) IS NOT NULL then DB_NAME(q.dbid) else ''*AdHoc/PrepStm*'' end[database_name]
		, case when OBJECT_NAME(q.objectid, q.dbid) IS NOT NULL then OBJECT_NAME(q.objectid, q.dbid) else ''*AdHoc/PrepStm*'' end[object_name]
		, high_io.total_logical_reads[total_logical_reads]
		, high_io.total_logical_reads / high_io.execution_count[avg_logical_reads]
		, high_io.execution_count
		, high_io.last_elapsed_time/1000[last_elapsed_time_ms]
		, high_io.creation_time
		, high_io.last_execution_time
		, high_io.plan_generation_num -- Recompiles
		, cp.refcounts -- Number of cache objects that are referencing this cache object.
		, cp.cacheobjtype
		, cp.objtype
		, cp.size_in_bytes
		, q.encrypted 
		-- ,high_io.plan_handle
		FROM sys.dm_exec_query_stats AS high_io 
		INNER JOIN sys.dm_exec_cached_plans cp ON cp.plan_handle = high_io.plan_handle
		CROSS APPLY sys.dm_exec_sql_text(high_io.plan_handle) AS q 
		CROSS APPLY sys.dm_exec_query_plan (high_io.plan_handle) AS qp
		where DB_NAME(q.dbid) not in (''dba_database'',''msdb'',''distribution'') and qp.query_plan is not NULL
		-- and (execution_count )>19
		-- and OBJECT_NAME(q.objectid, q.dbid) LIKE ''%xr%''
		and high_io.last_execution_time >= dateadd(hour,-48,getdate())
		and q.TEXT not like ''%b398db32-1176-4fb8-9a06-2da9cb6eb680%''
		'+(	case @i 
				when 1 then 'ORDER BY high_io.total_logical_reads DESC'
				when 2 then 'ORDER BY high_io.last_elapsed_time*high_io.total_logical_reads/execution_count DESC'
				when 3 then 'ORDER BY metricIO DESC'
				when 4 then 'ORDER BY high_io.last_elapsed_time DESC'
				else '-- no order'
				end)+N'
	'
	exec (@Q)
	set @i=@i+1
end