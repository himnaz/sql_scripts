DECLARE @db_id SMALLINT;  
DECLARE @object_id INT;  
  
SET @db_id = DB_ID(N'RSA_D4P_PROD');  
SET @object_id = OBJECT_ID(N'RSA_D4P_PROD.Earnix.Earnix_Response_Motor_VehicleDetails');  
  
IF @db_id IS NULL  
BEGIN;  
    PRINT N'Invalid database';  
END;  
ELSE IF @object_id IS NULL  
BEGIN;  
    PRINT N'Invalid object';  
END;  
ELSE  
BEGIN;  
    SELECT OBJECT_NAME ( pstat.object_id, pstat.database_id ) table_name,i.name index_name,* FROM sys.dm_db_index_physical_stats(@db_id, NULL, NULL, NULL , 'LIMITED') pstat
	INNER JOIN sys.indexes AS i with(nolock) ON i.object_id = pstat.object_id AND i.index_id = pstat.index_id;  
END;  
GO  