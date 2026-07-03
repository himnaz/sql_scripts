Select OBJECT_NAME(object_id),Name as IndexName,
STATS_DATE ( object_id , index_id ) as IndexCreatedDate
From sys.indexes
WHERE object_id = OBJECT_ID('D4P.M_Convictions')


SELECT name AS Stats,
STATS_DATE(object_id, stats_id) AS LastStatsUpdate
FROM sys.stats
WHERE object_id = OBJECT_ID('D4P.M_Convictions')
and left(name,4)!='_WA_';