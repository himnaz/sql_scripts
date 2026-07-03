SELECT  
    scheduler_id,  
    cpu_id,  
    parent_node_id,  
    current_tasks_count,  
    runnable_tasks_count,  
    current_workers_count,  
    active_workers_count,  
    work_queue_count , [status]
  FROM sys.dm_os_schedulers
  where scheduler_id < 128;
  
  
  select [parent_node_id], [scheduler_id], [cpu_id], [status], [is_online] from sys.dm_os_schedulers
where scheduler_id < 1024

