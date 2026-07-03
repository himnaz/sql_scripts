select
    r.session_id,
    s.login_name,
	st.text,
	qp.query_plan,
	r.blocking_session_id,
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
	r.logical_reads,
	s.login_time,
    c.client_net_address,
    s.host_name,
    s.program_name
from sys.dm_exec_requests (nolock) r
inner join sys.dm_exec_sessions (nolock) s
on r.session_id = s.session_id
left join sys.dm_exec_connections c
on r.session_id = c.session_id
outer apply sys.dm_exec_sql_text(r.sql_handle) st
outer apply sys.dm_exec_query_plan(r.plan_handle) qp
where r.session_id > 50
