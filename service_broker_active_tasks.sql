SELECT * FROM sys.conversation_endpoints   with (NOLOCK)

SELECT count(*) FROM sys.conversation_endpoints   with (NOLOCK)

select * from sys.service_broker_endpoints   with (NOLOCK)

select * from sys.dm_broker_activated_tasks   with (NOLOCK)

select * from sys.service_queues   with (NOLOCK)

select * from sys.dm_os_performance_counters   with(NOLOCK) where object_name like '%Broker Statistics%'

select * from sys.transmission_queue  with (NOLOCK)

select * from dbo.PNQQueue  with (NOLOCK)

select count(*) from dbo.PNQQueue  with (NOLOCK)

select * from dbo.PNQSourceQueue  with (NOLOCK)

select count(*) from dbo.PNQSourceQueue  with (NOLOCK)

select count(*) from dbo.PNQTargetQueue  with (NOLOCK)


select * from sys.conversation_endpoints   with (NOLOCK) where conversation_handle = '81191211-A429-EB11-80E0-1AC6C490054C'

dbcc inputbuffer(48)

sp_who2

kill 60

SELECT count(*), getDate()
  FROM [PNQ].[PNQ].[account_by_data] with (NOLOCK)

  SELECT count(*), getDate()
  FROM [PNQ].[PNQ].[XML_Store] with (NOLOCK)

  select * from ExecutionLog order by ingestiondate desc
  select * from ExecutionLog where Msg != 0 order by ingestiondate desc

  select * from err.error_table;

  SELECT * FROM sys.endpoints;

SELECT conversation_handle, is_initiator, s.name as 'local service',
far_service, sc.name 'contract', state_desc
FROM sys.conversation_endpoints ce with (NOLOCK)
LEFT JOIN sys.services s with (NOLOCK)
ON ce.service_id = s.service_id
LEFT JOIN sys.service_contracts sc with (NOLOCK)
ON ce.service_contract_id = sc.service_contract_id;

select Q.name as queuename, i.name as internalname
from sys.service_queues as Q
	join sys.internal_tables as I
		on q.object_id = i.parent_object_id


select * from sys.dm_broker_queue_monitors m with (nolock) 
join sys.service_queues q with (nolock) on m.queue_id = q.object_id
