select database_name,max(backup_start_date),max(backup_finish_date) from msdb..backupset 
where type='D'
group by database_name
GO