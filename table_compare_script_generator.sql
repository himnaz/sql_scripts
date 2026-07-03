select 'select column_name,DATA_TYPE from [INFORMATION_SCHEMA].[COLUMNS] where TABLE_NAME = ' + '''' + table_name + '''' from [INFORMATION_SCHEMA].[TABLES] 
  where table_schema = 'Earnix' 
  and table_name not in ('MAP_CASS_MSSQL_CONFIG','Retrigger_Load_Request','Batch_Master_Table')
  order by table_name asc