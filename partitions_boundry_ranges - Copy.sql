SELECT OBJECT_NAME(p.object_id) AS TableName
 ,i.index_id
 , prv_left.value AS LowerBoundaryValue
 , prv_right.value AS UpperBoundaryValue
 ,ds.name
, CASE pf.boundary_value_on_right
 WHEN 1
 THEN 'RIGHT'
 ELSE 'LEFT'
 END AS PartitionFunctionRange
 , p.partition_number AS PartitionNumber
 , p.rows AS Rows
 --In case the table has multiple indexes
 , ROW_NUMBER() OVER (PARTITION BY prv_left.value, prv_right.value, p.rows
 ORDER BY i.index_id,prv_left.value , prv_right.value 
 ) AS row_num
 FROM sys.partitions AS p
 INNER JOIN sys.indexes AS i
 ON i.object_id = p.object_id
 AND i.index_id = p.index_id
 INNER JOIN sys.data_spaces AS ds
 ON ds.data_space_id = i.data_space_id
 INNER JOIN sys.partition_schemes AS ps
 ON ps.data_space_id = ds.data_space_id
 INNER JOIN sys.partition_functions AS pf
 ON pf.function_id = ps.function_id
 LEFT OUTER JOIN sys.partition_range_values AS prv_left
 ON ps.function_id = prv_left.function_id
 AND prv_left.boundary_id = p.partition_number - 1
 LEFT OUTER JOIN sys.partition_range_values AS prv_right
 ON ps.function_id = prv_right.function_id
 AND prv_right.boundary_id = p.partition_number
 WHERE ds.name = 'PQVPartitionSc'