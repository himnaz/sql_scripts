-- sqlcmd -S <servername>\<instancename> -i <top5sql_historical.sql>
-- or interactive mode
-- sqlcmd -S <servername>\<instancename> 
-- >:r top5sql_historical.sql

select top 5 total_worker_time/execution_count as avg_cpu_time,
substring(st.text, (qs.statement_start_offset/2) + 1,
((case statement_end_offset 
when -1 
      then datalength(st.text) 
else 
      qs.statement_end_offset 
end 
- qs.statement_start_offset)/2) + 1) as statement_text
, plan_handle, query_plan
from sys.dm_exec_query_stats qs
cross apply sys.dm_exec_sql_text(qs.sql_handle) st
cross apply sys.dm_exec_text_query_plan(qs.plan_handle, qs.statement_start_offset, qs.statement_end_offset) 
order by total_worker_time/execution_count desc;
go