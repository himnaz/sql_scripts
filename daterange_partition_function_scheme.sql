DECLARE @DatePartitionFunction nvarchar(max) = 
    N'CREATE PARTITION FUNCTION DatePartitionFunction (datetime2) 
    AS RANGE RIGHT FOR VALUES (';  

DECLARE @DatePartitionScheme nvarchar(max) = 
    N'CREATE PARTITION SCHEME DatePartitionScheme AS PARTITION DatePartitionFunction TO (';  	
	
DECLARE @i datetime2 = '20070101';  
DECLARE @filegrp nvarchar(max) = 'filegroup_name'; 
DECLARE @filegrpincr numeric = 1;   
WHILE @i < '20110101'  
BEGIN  
SET @DatePartitionScheme += '''' + @filegrp + CAST(@filegrpincr as nvarchar(3)) + '''' + N', ';  
SET @DatePartitionFunction += '''' + CAST(@i as nvarchar(10)) + '''' + N', ';
SET @i = DATEADD(MM, 1, @i);
SET @filegrpincr += 1;    
END  
SET @DatePartitionFunction += '''' + CAST(@i as nvarchar(10))+ '''' + N');'; 
SET @DatePartitionScheme += '''' + @filegrp + CAST(@filegrpincr as nvarchar(3)) + '''' + N');';   
SELECT @DatePartitionFunction
SELECT @DatePartitionScheme
-- Uncomment the following line
--EXEC sp_executesql @DatePartitionFunction;  
GO