



------------------------dtu calculator--------------
https://docs.microsoft.com/en-us/answers/questions/565224/dtu-calculation.html

avg_dtu_percent = MAX(avg_cpu_percent, avg_data_io_percent, avg_log_write_percent)

http://dtucalculator.azurewebsites.net/

SELECT 
 end_time AS [EndTime]
  , (SELECT Max(v) FROM (VALUES (avg_cpu_percent), (avg_data_io_percent), (avg_log_write_percent)) AS value(v)) AS [AvgDTU_Percent]  
  , ((dtu_limit)*((SELECT Max(v) FROM (VALUES (avg_cpu_percent), (avg_data_io_percent), (avg_log_write_percent)) AS value(v))/100.00)) AS [AvgDTUsUsed]
  , dtu_limit AS [DTULimit]
FROM sys.dm_db_resource_stats