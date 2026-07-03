CREATE PARTITION FUNCTION DatePartitionFunction (datetime2)       AS RANGE RIGHT FOR VALUES ('2007-01-01', '2007-02-01', '2007-03-01', '2007-04-01', '2007-05-01', '2007-06-01', '2007-07-01', '2007-08-01', '2007-09-01', '2007-10-01', '2007-11-01', '2007-12-01', '2008-01-01', '2008-02-01', '2008-03-01', '2008-04-01', '2008-05-01', '2008-06-01', '2008-07-01', '2008-08-01', '2008-09-01', '2008-10-01', '2008-11-01', '2008-12-01', '2009-01-01', '2009-02-01', '2009-03-01', '2009-04-01', '2009-05-01', '2009-06-01', '2009-07-01', '2009-08-01', '2009-09-01', '2009-10-01', '2009-11-01', '2009-12-01', '2010-01-01', '2010-02-01', '2010-03-01', '2010-04-01', '2010-05-01', '2010-06-01', '2010-07-01', '2010-08-01', '2010-09-01', '2010-10-01', '2010-11-01', '2010-12-01', '2011-01-01');

CREATE PARTITION SCHEME DatePartitionScheme  AS PARTITION DatePartitionFunction ('filegroup_name1', 'filegroup_name2', 'filegroup_name3', 'filegroup_name4', 'filegroup_name5', 'filegroup_name6', 'filegroup_name7', 'filegroup_name8', 'filegroup_name9', 'filegroup_name10', 'filegroup_name11', 'filegroup_name12', 'filegroup_name13', 'filegroup_name14', 'filegroup_name15', 'filegroup_name16', 'filegroup_name17', 'filegroup_name18', 'filegroup_name19', 'filegroup_name20', 'filegroup_name21', 'filegroup_name22', 'filegroup_name23', 'filegroup_name24', 'filegroup_name25', 'filegroup_name26', 'filegroup_name27', 'filegroup_name28', 'filegroup_name29', 'filegroup_name30', 'filegroup_name31', 'filegroup_name32', 'filegroup_name33', 'filegroup_name34', 'filegroup_name35', 'filegroup_name36', 'filegroup_name37', 'filegroup_name38', 'filegroup_name39', 'filegroup_name40', 'filegroup_name41', 'filegroup_name42', 'filegroup_name43', 'filegroup_name44', 'filegroup_name45', 'filegroup_name46', 'filegroup_name47', 'filegroup_name48', 'filegroup_name49');

CREATE PARTITION FUNCTION DatePartitionFunction (datetime2)       AS RANGE RIGHT FOR VALUES ('2007-01-01', '2007-02-01')

CREATE PARTITION SCHEME DatePartitionScheme  AS PARTITION DatePartitionFunction TO ('part_left1','part_left2','part_left3')

ALTER PARTITION SCHEME DatePartitionScheme NEXT USED 'part_left4';

ALTER PARTITION FUNCTION DatePartitionFunction () SPLIT RANGE ('2007-03-01');  

drop partition function DatePartitionFunction

drop partition scheme DatePartitionScheme

CREATE TABLE DatePartitionTable 
(col1 int 
,col2 datetime2
PRIMARY KEY (col1,col2)
)  
    ON DatePartitionScheme (col2) ;  


USE [test]
GO

/****** Object:  Table [dbo].[DatePartitionTable]    Script Date: 10/01/2020 12:40:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


drop table DatePartitionTableHistory
CREATE TABLE [dbo].[DatePartitionTableHistory](
	[col1] [int] NOT NULL,
	[col2] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[col1] ASC,
	[col2] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
) ON DatePartitionScheme (col2) ;  
GO

drop table DatePartitionTableHistory



	drop table DatePartitionTable
	insert into DatePartitionTable values (1,'2006-12-01')
	insert into DatePartitionTable values (1,'2007-01-03')
	insert into DatePartitionTable values (1,'2007-02-03')
	insert into DatePartitionTable values (1,'2007-03-03')



	select * from DatePartitionTable


	select * from DatePartitionTable where col2 > '2007-02-01'

	SELECT $PARTITION.DatePartitionFunction(col2) AS Partition,  COUNT(*) AS [COUNT] FROM DatePartitionTable   GROUP BY $PARTITION.DatePartitionFunction(col2)  ORDER BY Partition ; 
	
	SELECT $PARTITION.DatePartitionFunction(col2) AS Partition,  COUNT(*) AS [COUNT] FROM DatePartitionTableHistory   GROUP BY $PARTITION.DatePartitionFunction(col2)  ORDER BY Partition ;  

SELECT $PARTITION.DatePartitionFunction(col2) AS Partition, * FROM DatePartitionTable   where $PARTITION.DatePartitionFunction(col2)  = 3


ALTER TABLE [DatePartitionTable] SWITCH PARTITION 1 TO [DatePartitionTableHistory] PARTITION 1