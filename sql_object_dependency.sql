SELECT *
 FROM information_schema.routines ISR
 WHERE CHARINDEX('dbo.mstt_Agents', ISR.ROUTINE_DEFINITION) > 0
 GO

sp_depends 'dbo.mstt_Agents'
 GO


 SELECT referencing_schema_name, referencing_entity_name,
 referencing_id, referencing_class_desc, is_caller_dependent
 FROM sys.dm_sql_referencing_entities ('dbo.mstt_Agents', 'OBJECT');
 GO
