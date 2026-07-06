SELECT 
 so.name,
 so2.name,
 sd.is_updated
 from sysobjects so
 inner join sys.sql_dependencies sd on so.id = sd.object_id
 inner join sysobjects so2 on sd.referenced_major_id = so2.id
where so.xtype = 'p' -- procedure
 and 
is_updated = 1 -- proc updates table, or at least, I think that's what this means 


SELECT referencing_schema_name, referencing_entity_name,
 referencing_id, referencing_class_desc, is_caller_dependent
 FROM sys.dm_sql_referencing_entities ('dbo.mstt_Agents', 'OBJECT');
 GO

SELECT *
 FROM information_schema.routines ISR
 WHERE CHARINDEX('dbo.mstt_Agents', ISR.ROUTINE_DEFINITION) > 0
 GO

sp_depends 'dbo.mstt_Agents'
 GO
