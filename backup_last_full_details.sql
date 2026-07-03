--msdb..backupset.type
--D = Database
--I = Differential database
--L = Log
--F = File or filegroup
--G =Differential file
--P = Partial
--Q = Differential partial 

--msdb.dbo.backupmediafamily.device_type
-- 2 = disk backup
-- 7 = Tape backup


SELECT  
   A.[Server],
   B.database_name,  
   B.backup_set_id,
   A.last_db_backup_date,  
   B.backup_start_date,
   B.backup_finish_date,  
   B.expiration_date, 
   B.backup_size,
   B.compressed_backup_size,  
   B.logical_device_name,  
   B.physical_device_name,   
   B.backupset_name, 
   B.description 
FROM 
   ( 
   SELECT   
       CONVERT(CHAR(100), SERVERPROPERTY('Servername')) AS Server, 
       msdb.dbo.backupset.database_name,  
       MAX(msdb.dbo.backupset.backup_finish_date) AS last_db_backup_date 
   FROM    msdb.dbo.backupmediafamily  
       INNER JOIN msdb.dbo.backupset ON msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id  
   WHERE   msdb..backupset.type = 'D' 
   GROUP BY 
       msdb.dbo.backupset.database_name  
   ) AS A 
    
   LEFT JOIN  

   ( 
   SELECT   
   CONVERT(CHAR(100), SERVERPROPERTY('Servername')) AS Server, 
   msdb.dbo.backupset.database_name,  
   msdb.dbo.backupset.backup_start_date,  
   msdb.dbo.backupset.backup_finish_date, 
   msdb.dbo.backupset.expiration_date, 
   msdb.dbo.backupset.backup_size,  
   msdb.dbo.backupset.compressed_backup_size,
   msdb.dbo.backupmediafamily.logical_device_name,  
   msdb.dbo.backupmediafamily.physical_device_name,   
   msdb.dbo.backupset.name AS backupset_name, 
   msdb.dbo.backupset.description, 
   msdb.dbo.backupset.backup_set_id
FROM   msdb.dbo.backupmediafamily  
   INNER JOIN msdb.dbo.backupset ON msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id  
WHERE  msdb..backupset.type = 'D' 
   ) AS B 
   ON A.[server] = B.[server] AND A.[database_name] = B.[database_name] AND A.[last_db_backup_date] = B.[backup_finish_date] 
ORDER BY  
   A.database_name 