SELECT p.name AS PackageName,
              o.name AS EventName,
              c.column_id,
              c.column_type,
              c.name ColumnName,
              c.column_value,
              c.description
FROM sys.dm_xe_objects o
       INNER JOIN sys.dm_xe_packages p
              ON o.package_guid = p.guid
       INNER JOIN sys.dm_xe_object_columns c
              ON o.name = c.object_name
WHERE o.object_type = 'event'
  --AND c.column_type = 'readonly'
  AND (p.capabilities IS NULL OR p.capabilities <> 1)
  AND o.name in ('sql_statement_completed')
ORDER BY PackageName, EventName, column_type, column_id;
