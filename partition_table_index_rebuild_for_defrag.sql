select 'ALTER INDEX [' + i.name + '] ON [D4P].[' + t.name + '] REBUILD PARTITION = ' + str(p.partition_number) + ' WITH (ONLINE= ON);'
from sys.partitions p with(nolock) inner join sys.indexes i ON p.OBJECT_ID = i.object_id
inner join sys.tables t on p.OBJECT_ID = t.object_id
where t.name = 'MotorQuoteCoverage'
and rows > 0



select 'ALTER INDEX [' + i.name + '] ON [D4P].[' + t.name + '] REBUILD PARTITION = ' + str(p.partition_number) + ' WITH (ONLINE= ON);'
from sys.partitions p with(nolock) inner join sys.indexes i ON p.OBJECT_ID = i.object_id
inner join sys.tables t on p.OBJECT_ID = t.object_id
where t.name = 'MotorPolicyCoverage'
and rows > 0

select 'ALTER INDEX [' + i.name + '] ON [D4P].[' + t.name + '] REBUILD PARTITION = ' + str(p.partition_number) + ' WITH (ONLINE= ON);'
from sys.partitions p with(nolock) inner join sys.indexes i ON p.OBJECT_ID = i.object_id
inner join sys.tables t on p.OBJECT_ID = t.object_id
where t.name = 'HomeQuoteCoverage'
and rows > 0



select 'ALTER INDEX [' + i.name + '] ON [D4P].[' + t.name + '] REBUILD PARTITION = ' + str(p.partition_number) + ' WITH (ONLINE= ON);'
from sys.partitions p with(nolock) inner join sys.indexes i ON p.OBJECT_ID = i.object_id
inner join sys.tables t on p.OBJECT_ID = t.object_id
where t.name = 'HomePolicyCoverage'
and rows > 0





select *
from sys.partitions p with(nolock) inner join sys.indexes i ON p.OBJECT_ID = i.object_id
inner join sys.tables t on p.OBJECT_ID = t.object_id
where t.name = 'MotorPolicyCoverage'
and rows > 0