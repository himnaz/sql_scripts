select
    r.session_id,
    r.blocking_session_id,
    s.login_name,
    c.client_net_address,
    s.host_name,
    s.program_name,
    st.text,
	qp.query_plan,
	r.dop,
	r.status,
	r.wait_type,
	r.wait_time,
	r.last_wait_type,
	r.percent_complete,
	r.estimated_completion_time,
	r.cpu_time,
	r.total_elapsed_time,
	r.reads,
	r.writes,
	r.logical_reads
from sys.dm_exec_requests  r with(NOLOCK)
inner join sys.dm_exec_sessions s with(NOLOCK)
on r.session_id = s.session_id
left join sys.dm_exec_connections c with(NOLOCK)
on r.session_id = c.session_id
outer apply sys.dm_exec_sql_text(r.sql_handle) st
outer apply sys.dm_exec_query_plan(r.plan_handle) qp
where r.session_id > 50

--select * from sys.dm_exec_requests
-----
--select * from sys.sysprocesses where spid = 

--select * from sys.dm_os_waiting_tasks

--dbcc inputbuffer(83)

--sp_who2

--kill 83