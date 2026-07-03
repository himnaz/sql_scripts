select total_worker_time/execution_count as avg_cpu_time,
substring(st.text, (qs.statement_start_offset/2) + 1,
((case statement_end_offset 
when -1 
      then datalength(st.text) 
else 
      qs.statement_end_offset 
end 
- qs.statement_start_offset)/2) + 1) as statement_text
, plan_handle
, query_plan
,qs.creation_time
,qs.last_execution_time
,qs.execution_count
,qs.total_worker_time
,qs.last_worker_time
,qs.min_worker_time
,qs.max_worker_time
,qs.total_physical_reads
,qs.last_physical_reads
,qs.min_physical_reads
,qs.max_physical_reads
,qs.total_logical_writes
,qs.last_logical_writes
,qs.min_logical_writes
,qs.max_logical_writes
,qs.total_logical_reads
,qs.last_logical_reads
,qs.min_logical_reads
,qs.max_logical_reads
,qs.total_clr_time
,qs.last_clr_time
,qs.min_clr_time
,qs.max_clr_time
,qs.total_elapsed_time
,qs.last_elapsed_time
,qs.min_elapsed_time
,qs.max_elapsed_time
from sys.dm_exec_query_stats qs
cross apply sys.dm_exec_sql_text(qs.sql_handle) st
cross apply sys.dm_exec_text_query_plan(qs.plan_handle, qs.statement_start_offset, qs.statement_end_offset) 
order by qs.last_execution_time desc,total_worker_time/execution_count desc;
go