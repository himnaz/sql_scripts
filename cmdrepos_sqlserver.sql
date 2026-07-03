http://technet.microsoft.com/en-gb/sqlserver/bb671430  -- SQL Server 2008 r2 documentation

http://www.bictt.com/blogs/bictt.php/2014/05/22/getting-sql-information-from-scom -- example retrieving sql information from scom using powershell

-------------------------SQL Jargon---------------------------------------------
heap table -- a normal table
clustered index or clustered table -- index organised tables
row locator

storage engine
relational engine

Signal Wait Time -- this is the amount of time a worker spends time in a runnable list, a high signal wait time reflects CPU starvation
service time

page life expectancy  -- This is the amount of time a page remains in the memory a lower page life expectancy is a sign for memory problems. 
deadlock monitor 
lazy writer
extended event engine


SQL Server Error Log
Event Viewer Logs

PerfMon -- now called as Reliability and Performance Monitor
Windows Event Logs
Profiler
SQLDiag
Database Tuning Advisor  -- mainly for tuning sql queries individually or drom a trace file

parameter sniffing-- this happens when query is parameterized the optimi


In-Place Upgrade  -- The instance and all the databases are upgraded. Use the SQL server Installation center and follow the upgrade option

Side by Side Upgrade  -- Install a fresh instance of the SQL Server and restore the databases one by one. The restore proces will upgrade the database.

Patching or Service Pack upgrade  -- 

Hot fixes and Cumulative updates  -- Only apply if there is a specific need.

bulked logged recovery model  -- does not recored transaction logs for Select INTo, BULK INSERT and bcp data imports

Backup types -- FULL, DIFFERENTIAL

COPY_ONLY
WITH CHECKSUM       -- Checks the checksum when loading,off loading of the pages
WITH PHYSICAL_ONLY  -- checks only the physical corruption
REPAIR_REBUILD
REPAIR_ALLOW_DATA_LOSS


TBALESAMPLE

remember UPGRADE ADVISOR  -- in the SQL Server installation

Included Column Index  == Covered Index  -- Index Fast Full Scan
Filtered Index  == Index with a where condition
Indexed Views  ==


Primary FileGroup  --- Only one for a database
Secondry Filegroup --- More than one for a database

CDC -- is introduced in 2008
Change Tracking
---------------------------------Session Level settings---------------------------------------
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED   -- if this line is included in as first command it will make all tables in the select statement NOLOCK

Blocked Object 5:1:1688   5 -- Database Id   , 1 -- data_file_id  , 1688 -- page_number

-------------------------------Modification Details-------------------------------------------
select * from sys.tables where modify_date >DATEADD(DAY,-1,CURRENT_TIMESTAMP)
--------------------------INFPRMATION SCHEMA--------------------------

SELECT * FROM INFORMATION_SCHEMA.TABLES  -- database context
SELECT * FROM INFORMATION_SCHEMA.COLUMNS


--------------------------Begin connecting to Enterprice manager------------


ServerName,PortNumber -- e.g. ENTAAP369P,3120

--------------------------Begin Server Property-----------------------------

-- get current machine name and instance name
  SELECT SERVERPROPERTY('MachineName'), SERVERPROPERTY ('InstanceName')
  select SERVERPROPERTY('InstanceDefaultLogPath')
  select SERVERPROPERTY('InstanceDefaultDataPath')
  

--------------------------End Server Property-----------------------------
---------------------------
grant exec on xp_readerrorlog to [OPD\A55334]   ---- to view the error logs
GRANT ALTER TRACE TO [OPD\A55334]  --- to run reports


-----------------------------
-------------------------Begin SQL Server Global Variables ---------------------
select @@ServerName



@@CONNECTIONS 
@@MAX_CONNECTIONS 
@@CPU_BUSY     ---  SELECT @@CPU_BUSY * CAST(@@TIMETICKS AS FLOAT) AS 'CPU microseconds',GETDATE() AS 'As of';
@@ERROR   
@@IDENTITY 
@@IDLE 
@@IO_BUSY --- SELECT @@IO_BUSY*@@TIMETICKS AS 'IO microseconds', GETDATE() AS 'as of';
@@LANGID   
@@LANGUAGE 
@@MAXCHARLEN 
@@PACK_RECEIVED   
@@PACK_SENT 
@@PACKET_ERRORS 
@@ROWCOUNT   
@@SERVERNAME  
@@SPID 
@@TEXTSIZE  
@@TIMETICKS --- The number of microseconds per tick. The amount of time per tick is machine dependent.
@@TOTAL_ERRORS 
@@TOTAL_READ / @@TOTAL_WRITE 
@@TRANCOUNT 
@@VERSION 


-------------------------End SQL Server Global Variables------------------------


-------------------------Begin Dynamic Managment View---------------------------
sys.dm_os_memory_nodes  -- infor about the memory nodes
sys.dm_os_nodes
sys.dm_os_shedulers  -- information about the schedulers
sys.dm_os_workers  -- Information about the workers assigned to the schedulers
sys.dm_os_tasks
sys.dm_os_threads
sys.dm_os_waiting_tasks -- currently waiting tasks assigned to the wait list

select session_id,execution_context_id,wait_duration_ms,wait_type,resource_description,blocking_session_id from sys.dm_os_waiting_tasks where session_id > 50 order by session_id -- here I am eleminating all system processes by only selecting session_id > 50 and ms refers to milliseconds
select * from sys.dm_exec_requests where session_id > 50 order by session_id   ------------- sys.dm_exec_requests  --- the task in the runnable list waiting on the CPU time

sys.dm_os_wait_stats  -- cumulative wait stats for the whole instance. wait_time in this table equal to resource wait time plus signal wait time
Select count(*) from sys.dm_os_performance_counters   -- 




select c.node_id,c.memory_node_id,m.memory_node_id,c.node_state_desc,c.cpu_affinity_mask,m.virtual_address_space_reserved_kb from sys.dm_os_nodes as c inner join sys.dn_os_memory_nodes as m on c.node_id = m.memory_node_id


SELECT is_enabled,[path],max_size,max_files FROM Sys.dm_os_server_diagnostics_log_configurations   --- location of the error log
-------------------------End Dynamic Managment View---------------------------


----------------------------------Database Object Management--------------------------------------------

sys.dm_db_index_usage_stats  ---  dispalys the index that are not used rarely used and duplicate
--------------------------------------------------------------------------------------------------------
------------------------
DBCC SQLPERF("sys.dm_os_latch_stats" , CLEAR)
DBCC SQLPERF(LOGSPACE)   -- gives the percentage of the log file usage
DBCC SQLPERF("sys.dm_os_wait_stats",CLEAR)  -- This clears the data in the DMV. 
DBCC SHOW_STATISTICS("Person.Address",PK_Address_AddressID);  you can also view the statistics of a table from SSMC by expanding the table and its index branch of the tree


DBCC INPUTBUFFER(spid)  -- (usefull when getting the sql statement after executing sp_who2)

DBCC SHOWFILESTATS  -- dispalys datafile usage details

DBCC PAGE  -- Displays the contents of the page

--The follwoing 3 dbcc is a remedy for clearing out bloated plan cache
DBCC FREEPROCCACHE  -- Empties the procedure cache (both ad-hoc and and parameterised plan are flushed)
DBCC FREESYSTEMCACHE('SQL Plans')   -- clears out the ad-hoc and prepared plans leaving out the stored procedure plans
DBCC FLUSHPROCINDB  -- Flushes plans in a specified db

DBCC TRACEON
DBCC TRACEON (3604) -- The number 3604 prints the output on the screen
dbcc shrinkfile('mscrm_log',1024)   -- if you run the  "checkpoint  " before running this it will be quicker. (1024 is in MB)

DBCC TRACESTATUS(-1) -- Displaying the Global trace values. You can set the globa trace values in the SQL Configuration Manager e.g. "-T1117;-T1118"

====================================================================Transaction Logs==============================================
dbcc opentran
DBCC LOGINFO    -- gives information about virtual log files in a transaction log
SELECT * FROM sys.dm_tran_database_transactions   -- displays the details of the current transaction
DBCC SQLPERF(logspace)   -- displays transaction log usage details
use RSA_D4P_PROD  checkpoint
dbcc shrinkfile('RSA_D4P_PROD_log3',1024)

===========================================================================================================
Note :-- Checking when DBCC CHECKDB ran last successfully run DBCCC TRACEON(3604); then run DBCC PAGE (dbname,1,9,3)
DBCC CHECKDB ('DB Name') WITH NO_INFOMSGS
DBCC CHECKDB ('DB Name') WITH PHYSICAL_ONLY
DBCC CHECKDB('DB Name', REPAIR_REBUILD)  -- If the minimum repair level is REPAIR_REBUILD you have been lucky. 
DBCC CHECKDB('DB Name', REPAIR_ALLOW_DATA_LOSS)  -- If you want to allow data loss

----------------
select software_vendor_id,name.user_name,backup_start_date,type from msdb..backupset
SELECT SERVERPROPERTY('productversion'), SERVERPROPERTY ('productlevel'), SERVERPROPERTY ('edition')  -- SQL Server version 2008
SELECT SERVERPROPERTY('productversion'), SERVERPROPERTY ('productlevel'), SERVERPROPERTY ('edition') -- 2005

select getdate();
EXEC sp_spaceused @TableName   -- finds the space used by the table @TableName

============================Statistics==================================
exec sp_msforeachtable "UPDATE STATISTICS ? WITH FULLSCAN"  -- updates the statistics every table with fullscan in the schema that is executed.
exec sp_updatestats    -- this updates all the existing satistics where necessary

EXEC sp_configure
SELECT name FROM sys.sysdatabases
select * from sys.tables
select * from sys.views
select * from sys.columns where object_id = 
select * from msdb..sysjobs
select * from msdb.dbo.sysjobactivity  -- sql 2005 upwards
select * from msdb..sysjobschedules
select * from msdb..sysjobsteps
SELECT * FROM sys.partitions WHERE OBJECT_NAME(OBJECT_ID)='Sales' ORDER BY [index_id], [partition_number] -- getting the partition details of the table Sales


select * from msdb.dbo.sysjobsteps
SELECT * FROM sys.configurations ORDER BY name ;  -- This will list all the system configuration values similar to sp_configure 'show advanced options', 1;
select * from sys.configurations
----------------------Restore History------------------------------------------------------------------------------------

select * from msdb..restorehistory
-------------------CREATE ALTER SYNTAX---------------------------------------------------------------------------------------------------------------------------

ALTER DATABASE [dbname] SET PARAMETERISAZION FORCED

ALTER TABLE Tbl_SPG_Funds ALTER COLUMN Seq Decimal(2,0)not null
ALTER INDEX index_name ON table_name DISABLE  -- When you execute this data is removed from the index but metadata is preserved for non clustered index
ALTER INDEX index_name ON table_name REBUILD  -- This enables the disabled index, Updates statistics, eleminates non leaf node fragmentaion
ALTER INDEX index_name ON table_name REORGANIZE  -- removes leaf level fragmentation, doesnt remove non leaf level, it very low impact
CREATE INDEX index_name ON table_name WITH (DROP_EXISTING=on);
CREATE CLUSTERED INDEX index_name ON table_name WITH (DROP_EXISTING=on);  -- advantage is non clustered indexes are built only once. Used for adding new columns or moving index to another file system

CREATE STATISTICS [test] ON [dbo].[address]([Candidate_id], [Address1], [Address2], [Address3], [Postcode])
UPDATE STATISTICS
UPDATE STATISTICS Production.Product(Products)   WITH FULLSCAN, NORECOMPUTE;  -- The following example updates the Products statistics in the Product table, forces a full scan of all rows in the Product table, and turns off automatic statistics for the Products statistics.
update statistics wfmuser.wm_schedule_days  -- this query computes the statisrics of the table wm_schedule_days
UPDATE STATISTICS dbo.DC_BIL_PolicyTerm(DC_IX_BIL_PolicyTerm_PrimaryAccountId_PolicyReference)   WITH FULLSCAN, NORECOMPUTE; 




CREATE LOGIN fred WITH PASSWORD = 'kdfgdjfdjkdf';  -- This creates a SQL Login


ALTER DATABASE SET [dbname] SET PARAMETERISATION FORCED;
alter database WSS_ContentAbbeyP add file ( name = 'WSS_ContentAbbeyP_Data_9', filename='S:\INST1746\DATA\WSS_ContentGeobanP_Data_9.NDF', size= 20480, maxsize=92160, filegrowth=64)
ALTER DATABASE [WSS_ContentAbbeyP] MODIFY FILE ( NAME = N'WSS_ContentAbbeyP_Data_8', FILEGROWTH = 0, size=101376)
ALTER LOGIN [NewClassic_srm_system] WITH PASSWORD=N'Og76jsfhohjo9P'

USE master;
GRANT ALTER TRACE TO AN\C0224512;
grant execute on SCHEMA::dbo to "AN\AN-OMRT-Support";


CREATE PARTITION FUNCTION policyBYMonths(DATETIME) AS RANGE RIGHT FOR VALUES ('2019-02-01', '2019-03-01','2019-04-01');
CREATE PARTITION SCHEME [policyByMOnthsScheme] AS PARTITION policyBYMonths TO ([part_left1], [part_left2], [part_left3], [primary])
SELECT $PARTITION.part_function(policyid_numeric) AS Partition,  COUNT(*) AS [COUNT] FROM policies   GROUP BY $PARTITION.part_function(policyid_numeric)  ORDER BY Partition ;  ----- policyid_numeric is the partitioned column, part_function is the name of the partition function
SELECT $PARTITION.part_function(policyid_numeric) AS Partition, * FROM policies   where $PARTITION.part_function(policyid_numeric)  = 2

SELECT o.name objectname ,
i.name indexname ,
partition_id ,
partition_number ,
[rows]
FROM sys.partitions p
INNER JOIN sys.objects o ON o.object_id = p.object_id
INNER JOIN sys.indexes i ON i.object_id = p.object_id
AND p.index_id = i.index_id
WHERE o.name = 'DatePartitionTable';

---------------------------------END CREATE ALTER----------------------------------------------------------------------------------------------------------

--------------------------Begin Job------------------------------------------------------
---exec msdb..sp_update_job @job_id = 0xC0923E436928064EA33B46B2A47BFF61 , @enabled = 0   --disables a job
---exec msdb..sp_update_job @job_name = 'Job Name', @enabled = 0
exec msdb.dbo.sp_help_jobstep @job_name = 'Your job name' 

select 'exec msdb..sp_update_job @job_name = '+''''+name+''''+', @enabled = 0;' from msdb..sysjobs where enabled = 1


select b.name,a.job_id,a.next_run_date,a.next_run_time
from msdb..sysjobschedules a,msdb..sysjobs b
where a.job_id = b.job_id
and      b.enabled = 1
--and b.job_id = '9E57A095-8117-4047-8D9D-0D7D92708F73'
--group by b.name,a.job_id
order by a.next_run_date,a.next_run_time

--------------------------End Job--------------------------------------------------------

--------------------------Begin SQL Server command line executions-----------------------

bcp RSA_D4P_PROD.D4P.Coverage format nul -x -f Coverage-n.xml -n -T -S lwukwiptv15\ins1,11433

bcp RSA_D4P_PROD.D4P.Coverage format nul -x -f c:\app\rsa_work\Coverage-n.xml -n -T -S lwukwiptv15\ins1,11433

bcp "select top 100 * from [RSA_D4P_PROD].D4P.Coverage " queryout "Coverage.bcp" -N -S lwukwiptv15\ins1,11433 -T -E 

bcp "select top 100 * from [RSA_D4P_PROD].D4P.Coverage " queryout "C:\app\RSA_work\bcp_export_stats\Coverage.bcp" -f c:\app\rsa_work\Coverage-n.xml  -S lwukwiptv15\ins1,11433 -T -E 
bcp [test].dbo.Coverage in "c:\app\rsa_work\Coverage.bcp" -f "c:\app\rsa_work\Coverage-n.xml" -S 192.168.1.27,1433 -U sa -P Zamih3029 -E -b 10000
bcp [test].dbo.Coverage in "c:\app\rsa_work\Coverage.bcp" -f "c:\app\rsa_work\Coverage-n.xml" -S 192.168.1.27,1433 -U sa -P Zamih3029 -E -b 10000


c:\bcp master..syslogins out c:\temp\syslogin.dat -N -S EU-LON01-SQL01 -T

bcp "[ComplaintsU].dbo.MIRO_DAILY" format nul -x -f c:\changes\miro_daily.xml -n -S entaap225s.anstr.xadstr.anplc.co.uk\inst50 -T -- export format file

bcp "select * from [MyDatabase].dbo.Customer " queryout "Customer.bcp" -N -S localhost -T -E   -- to export a table

bcp [MyDatabase].dbo.Customer in "Customer.bcp" -N -S localhost -T -E -b 10000  -- to import a table

bcp [TestDB].dbo.MIRO_DAILY in C:\temp\miro_daily.bcp -f C:\temp\miro_daily.Xml -S SRVSRVCIVWSK03\INST80 -T -b 10000  -- import table with format file


bcp "select * from [IC_Warehouse_StagingP].dbo.Flash_Master_History " queryout "c:\changes\Customer.bcp" -N -S ENTAAP2883P\INST2883 -T -E

bcp "[IC_Warehouse_StagingP].dbo.Flash_Master_History" out "c:\changes\Customer01.bcp" -n -S ENTAAP2883P\INST2883 -T  -- Martins version

bcp "[Gasper].dbo.TRANSACTION_TYPE" out c:\changes\gasper\table_data\TRANSACTION_TYPE.txt -c -t, -T -S ENTAAP1749U\inst1749

bcp DBName..vieter out c:\test003.txt -c -T -t"\",\"" -r"\"\n\"" -S SERVER   -- to wrap the fields with quotes and end of line deliniter



--------------------------End SQL Server command line executions-----------------------

-----------------------------------------------------------------------------------
select * from sys.database_permissions
select * from sys.database_principals
select min(login_time) from sys.sysprocessess

select distinct db_name(dbid),* from sysprocesses where db_name(dbid) = 'tmspe'


use AGENCYTIME
deny showplan to "DOMAIN\rnayak";

use AGENCYTIME  -- This only works in the Microsoft Dynamics
execute as user = 'DOMAIN\rnayak';
select * from fn_my_permission(NULL, 'SERVER');
select * from fn_my_permission(NULL, 'DATABASE');

---------------------------------Begin Exec-----------------------------------------

exec sp_updatestats [[@resample =] 'resample']
EXEC sp_spaceused @TableName   -- finds the space used by the table @TableName
sp_helpstats 'Person.Contact'
EXEC sp_helpstats  @objname = 'Sales.Customer',  @results = 'ALL';  


sp_who2  -- gives cpu, memory and blocking information for the connected users.

sp_who 'AN\C0810503'

sp_WhoisActive  -- Similar to sp_who2 but more advanced
sp_whoisactive @get_plans=1
sp_whoisactive @get_plans=1 @get_additional_info=1
sp_whoisactive @help=1
sp_whoisactive @get_task_info=1, @show_sleeping_spids=0
sp_whoisactive @get_task_info=1, @show_sleeping_spids=0, @get_plans=1


sp_helpserver  -- lists all the linked servers in the SQL Server instance
sp_helpindex -- lists the indexes available for a table "EXECUTE sp_helpindex Employee"
sp_readerrorlog 1,1,'listening','server'  -- find out what the sql server ports that database. This will only work if the prot is fixed.

sp_validatelogins  --- Check for any invalid login in the database

sp_help_revlogins  -- first you need to create this sp in the master database and run it separately to crete the script for to create the logins in the other side

kill spid;

-----------------------------------Begin Fixing Orphaned Users--------------------------------------------------------

EXEC sp_change_users_login 'Report';  -- This will produce a report of the users in the current database and their security identifiers (SIDs).

EXEC sp_change_users_login 'Auto_Fix', 'pmart_user'   -- Select the database to run and give the user which is pmart_user
EXEC sp_change_users_login 'Auto_Fix', 'McAfee_ePO',NULL, 'ThSNtYV0k5WYo3'

------------------------------------------------------------------------------------
--------------------
use YourDatabase

go

sp_changedbowner @loginame = 'sa'

go



------


---------------------------------Begin Setting Configuration-------------------

sp_configure 'min server', 512

GO
sp_configure 'max server', 512

sp_configure 'Optimize for ad hoc workloads',1
---------------------------------End Setting Configuration-------------------



---------------------------------Begin enabling OLE Automation----------------------
sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
sp_configure 'Ole Automation Procedures', 1;
GO
RECONFIGURE;
GO
sp_configure 'Agent XPs', 1;
GO
RECONFIGURE;
GO
sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
-------------------------------End OLE Automation--------------------------------------

-------------------------------Begin Changing the SQL Server Query Timeout-------------

USE master
EXEC sp_configure  'show advanced option', '1'
/*
Here is the message:
Configuration option 'show advanced options' changed from 0 to 1. 
Run the RECONFIGURE command to install.
*/  

RECONFIGURE with override
EXEC sp_configure

--XXXX  change to query timeout value  (example '800')
sp_configure 'remote Query Timeout', 'XXXX'

-------------------------------End Changing the SQL Server Query Timeout---------------

-------------------------------Begin Saving DTS packages to a file---------------------------
DECLARE @TARGETDIR varchar(1000)
SET 	@TARGETDIR = 'C:\temp\partners_dts\'

SELECT	distinct  
	'DTSRUN.EXE /S '
	+ CONVERT(varchar(200), SERVERPROPERTY('servername')) 
	+ ' /E ' 
	+ ' /N '
	+ '"' + name  + '"'
	+ ' /F '
	+ '"' + @TARGETDIR + name + '.dts"'
	+ ' /!X'
FROM	msdb.dbo.sysdtspackages P

-------------------------------End Saving DTS packages to a file-----------------------------



-------------------------------Begin Generate DTS run scripts---------------------------
DECLARE @TARGETDIR varchar(1000)
SET 	@TARGETDIR = 'C:\temp\partners_dts\'

SELECT	distinct  
	'DTSRUN.EXE /S '
	+ CONVERT(varchar(200), SERVERPROPERTY('servername')) 
	+ ' /E ' 
	+ ' /N '
	+ '"' + name  + '"'
--	+ ' /F '
--	+ '"' + @TARGETDIR + name + '.dts"'
--	+ ' /!X'
FROM	msdb.dbo.sysdtspackages P

-------------------------------End Generate DTS run scripts-----------------------------

select name,filename, size*8/1024,fileproperty(name,'spaceused')*8/1024 from sysfiles -- 2008 version on wards version to check the space used percentage
select db_name(database_id),name,physical_name, size*8/1024,fileproperty(name,'spaceused')*8/1024 from sys.master_files  -- 2005 on wards version to check the space used percentage

select * from sys.master_files

select * into mynewtable from oldtable

script to find the primary keys of the tables.

USE AGENCYTIME;
GO
select count(*) from
(
select distinct TableName from
(
SELECT i.name AS IndexName,
OBJECT_NAME(ic.OBJECT_ID) AS TableName,
COL_NAME(ic.OBJECT_ID,ic.column_id) AS ColumnName
FROM sys.indexes AS i
INNER JOIN sys.index_columns AS ic
ON i.OBJECT_ID = ic.OBJECT_ID
AND i.index_id = ic.index_id
WHERE i.is_primary_key = 1
) a
) b

---------------------------------Begin Date manupulations-------------------------------

SELECT CONVERT(varchar(12),GETDATE(), 101)  -- 06/29/2009  

SELECT CONVERT(varchar(12),GETDATE(), 110)  -- 06-29-2009  

SELECT CONVERT(varchar(12),GETDATE(), 100)  -- Jun 29 2009  

SELECT CONVERT(varchar(12),GETDATE(), 107)  -- Jun 29, 2009  

   

-- Year first  

SELECT CONVERT(varchar(12),GETDATE(), 102)  -- 2009.06.29  

SELECT CONVERT(varchar(12),GETDATE(), 111)  -- 2009/06/29  

SELECT CONVERT(varchar(12),GETDATE(), 112)  -- 20090629  

   

-- Day first  

SELECT CONVERT(varchar(12),GETDATE(), 103)  -- 29/06/2009  

SELECT CONVERT(varchar(12),GETDATE(), 105)  -- 29-06-2009  

SELECT CONVERT(varchar(12),GETDATE(), 104)  -- 29.06.2009  

SELECT CONVERT(varchar(12),GETDATE(), 106)  -- 29 Jun 2009  

   

-- Time only  

SELECT CONVERT(varchar(12),GETDATE(), 108)  -- 07:26:16  

SELECT CONVERT(varchar(12),GETDATE(), 114)  -- 07:27:11:203  

   

-- Date Only No Time (SQL 2008) [thank you John]  

SELECT Cast(GetDate() AS date);  -- 08/12/2011 


---------------------------------End Date manupulations-------------------------------

---------------------------------Begin Date Convert-----------------------------------

Declare @d datetime 
select @d = getdate()  
select @d as OriginalDate, 
convert(varchar,@d,100) as ConvertedDate, 
100 as FormatValue, 
'mon dd yyyy hh:miAM (or PM)' as OutputFormat 
union all 
select @d,convert(varchar,@d,101),101,'mm/dd/yy' 
union all 
select @d,convert(varchar,@d,102),102,'yy.mm.dd' 
union all 
select @d,convert(varchar,@d,103),103,'dd/mm/yy' 
union all 
select @d,convert(varchar,@d,104),104,'dd.mm.yy' 
union all 
select @d,convert(varchar,@d,105),105,'dd-mm-yy' 
union all 
select @d,convert(varchar,@d,106),106,'dd mon yy' 
union all 
select @d,convert(varchar,@d,107),107,'Mon dd, yy' 
union all 
select @d,convert(varchar,@d,108),108,'hh:mm:ss' 
union all 
select @d,convert(varchar,@d,109),109,'mon dd yyyy hh:mi:ss:mmmAM (or PM)' 
union all 
select @d,convert(varchar,@d,110),110,'mm-dd-yy' 
union all 
select @d,convert(varchar,@d,111),111,'yy/mm/dd' 
union all 
select @d,convert(varchar,@d,112),112,'yymmdd' 
union all 
select @d,convert(varchar,@d,113),113,'dd mon yyyy hh:mm:ss:mmm(24h)' 
union all 
select @d,convert(varchar,@d,114),114,'hh:mi:ss:mmm(24h)' 
union all 
select @d,convert(varchar,@d,120),120,'yyyy-mm-dd hh:mi:ss(24h)' 
union all 
select @d,convert(varchar,@d,121),121,'yyyy-mm-dd hh:mi:ss.mmm(24h)' 
union all 
select @d,convert(varchar,@d,126),126,'yyyy-mm-dd Thh:mm:ss:mmm(no spaces)' 



SELECT getdate(),DATEADD(ww, DATEDIFF(ww,0,GETDATE()), 0)
union all
SELECT getdate()+12,DATEADD(ww, DATEDIFF(ww,0,GETDATE()+12), 0)
union all
SELECT convert(datetime,convert(varchar,getdate(),101))+13,DATEADD(ww, DATEDIFF(ww,0,convert(datetime,convert(varchar,getdate(),101))+13), 0)
union all
SELECT convert(datetime,convert(varchar,getdate(),101)),DATEADD(ww, DATEDIFF(ww,0,convert(datetime,convert(varchar,getdate(),101))), 0)
union all
select convert(datetime,'2010-12-31 23:59:59.000')


---------------------------------End Date Convert-----------------------------------

---------------------------------Begin Checking the default date format of the SQL Server and changing------------------------

select name,alias,dateformat from syslanguages
where langid = (select value from master..sysconfigures where comment = 'default language');


exec sp_configure 'default language'

-----------------------------End Checking the default date format of the SQL Server and changing------------------------



-----------------------------Begin Creating a database trigger----------------------------------------------------------

Am going to create a DDL trigger at the Database level. However, these can also be developed at the SERVER level. The scope of this article 
is to define a trigger at the database level. Create the following DDL trigger in the database whose objects needs to be tracked for changes. 

CREATE TRIGGER [Admin_Backup_Objects]
ON DATABASE
FOR create_procedure, alter_procedure, drop_procedure,
create_table, alter_table, drop_table,
create_function, alter_function, drop_function
AS

SET NOCOUNT ON

DECLARE @data XML
SET @data = EVENTDATA()

INSERT INTO dbo.AdministratorLog(databasename, eventtype,objectname, objecttype, sqlcommand, loginname)
VALUES(
@data.value('(/EVENT_INSTANCE/DatabaseName)[1]', 'varchar(256)'),
@data.value('(/EVENT_INSTANCE/EventType)[1]', 'varchar(50)'),  -- value is case-sensitive
@data.value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(256)'), 
@data.value('(/EVENT_INSTANCE/ObjectType)[1]', 'varchar(25)'), 
@data.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'varchar(max)'), 
@data.value('(/EVENT_INSTANCE/LoginName)[1]', 'varchar(256)')
)


-----------------------------End Creating a database trigger----------------------------------------------------------

-----------------------------Begin Clearing the Wiat statistics dynamic view -----------------------------------------

-- This is necessary when you want to performance monitor a query. Before executing it clear this view and check the wait events that occure when the query is being run, which will give an 
-- indication where its long waiting times are and corresponding resource its waiting for.
DBCC SQLPERF ('sys.dm_os_wait_stats', CLEAR);
GO
------------------------------End  Clearing the Wiat statistics dynamic view -----------------------------------------


-----------------------------Begin Wait Categories in SQL Server------------------------------------------------------
Resource waits 
Resource waits occur when a worker requests access to a resource that is not available because the resource is being used by some 
other worker or is not yet available. Examples of resource
waits are locks, latches, network and disk I/O waits. Lock and latch waits are waits on synchronization objects

Queue waits 
Queue waits occur when a worker is idle, waiting for work to be assigned. Queue waits are most typically seen with system background tasks 
such as the deadlock monitor and deleted record 
cleanup tasks. These tasks will wait for work requests to be placed into a work queue. Queue waits may also periodically become active even 
if no new packets have been put on the queue.

External waits 
External waits occur when a SQL Server worker is waiting for an external event, such as an extended stored procedure call or a linked server 
query, to finish. When you diagnose blocking 
issues, remember that external waits do not always imply that the worker is idle, because the worker may actively be running some external code. 

-----------------------------End Wait Categories in SQL Server--------------------------------------------------------

-----------------------------Default primary key creates a clustered index in the primary key----------------
create table dbo.client (
  clientcode int primary key
  ,surname
  ,lastname
  ,ssn char(11)
) go
---------------------------------------------------------------------------------------------------------------

----------------------------Non clustered index primary key----------------------------------------------------
create table dbo.client (
  clientcode int primary key nonclustered
  ,surname
  ,lastname
  ,ssn char(11)
) go

create unique clustered index cixClientSSN on dbo.client(ssn)
go

NOTE :- if a cluster index is disabled access to the table isprevented until index is re-enabled via REBUILD or CREATE WITH DROP_EXISTING command
NOTE :- if a cluster index is dropped table is converted to heap and all the non clustered indexes are rebuiltusing the row id
NOTE :- if a cluster index is created the table is recreated with a b tree IOT and all the non clustered indexes are converted to contain index key in the leaf node

--------------------------------------------------------------------------------------------------------------
------------------------HASH JOIN HINT-------------------------------
SELECT p.Name, pr.ProductReviewID
FROM Production.Product AS p
LEFT OUTER HASH JOIN Production.ProductReview AS pr
ON p.ProductID = pr.ProductID
ORDER BY ProductReviewID DESC;


------------------------LOOP JOIN HINT-------------------------------
DELETE FROM Sales.SalesPersonQuotaHistory 
FROM Sales.SalesPersonQuotaHistory AS spqh
    INNER LOOP JOIN Sales.SalesPerson AS sp
    ON spqh.SalesPersonID = sp.SalesPersonID
WHERE sp.SalesYTD > 2500000.00;

------------------------MERGE JOIN HINT-----------------------------

SELECT poh.PurchaseOrderID, poh.OrderDate, pod.ProductID, pod.DueDate, poh.VendorID 
FROM Purchasing.PurchaseOrderHeader AS poh
INNER MERGE JOIN Purchasing.PurchaseOrderDetail AS pod 
    ON poh.PurchaseOrderID = pod.PurchaseOrderID;

--------------------------------------------------------------------------------


-------------------------------------------------Begin Table Partitioning---------------------------------------------------------------

1st Step create a partition function

CREATE PARTITION FUNCTION myPartitionFunction (int) AS RANGE LEFT FOR VALUES (4000,10000);

2nd Step create a partition scheme

CREATE PARTITION SCHEME myPartitionScheme AS PARTITION myPartitionFunction TO (FILEGROUP1,FILEGROUP2,FILEGROUP3);  -- FILEGROUPs are datafiles in the database. FILEGROUP3 inserts values over 10000

3rd Step create the partition table

CREATE TABLE myPartitionTable (field1 int NOT NULL, field2 int NOT NULL) on myPartitionScheme(field1);
-------------------------------------------------End Table Partitioning-----------------------------------------------------------------

-------------------------------------------------Begin Finding the Index Fragmantation Percentages--------------------------------------------

SELECT ps.database_id, ps.OBJECT_ID,
ps.index_id, b.name,
ps.avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, NULL) AS ps
INNER JOIN sys.indexes AS b ON ps.OBJECT_ID = b.OBJECT_ID
AND ps.index_id = b.index_id
WHERE ps.database_id = DB_ID()
ORDER BY ps.OBJECT_ID
GO


select stats.index_id,name,avg_fragmentation_in_percent
from sys.dm_db_index_physical_stats(DB_ID(N'wfmP'),NULL,NULL,NULL,NULL) as stats INNER JOIN sys.indexes as b
on stats.object_id = b.object_id and stats.index_id = b.index_id
order by avg_fragmentation_in_percent desc

----------------------------------------------End Finding the Index Fragmantation Percentages--------------------------------------------

----------------------------------------------Top 5 execution plans---------------------------------------------------------------------

select top 5 total_worker_time/execution_count as avg_cpu_time,
substring(st.text, (qs.statement_start_offset/2) + 1,
((case statement_end_offset 
when -1 
      then datalength(st.text) 
else 
      qs.statement_end_offset 
end 
- qs.statement_start_offset)/2) + 1) as statement_text
, plan_handle, query_plan
from sys.dm_exec_query_stats qs
cross apply sys.dm_exec_sql_text(qs.sql_handle) st
cross apply sys.dm_exec_text_query_plan(qs.plan_handle, qs.statement_start_offset, qs.statement_end_offset) 
order by total_worker_time/execution_count desc;
go



select top 5 total_worker_time/execution_count as avg_cpu_time,
substring(st.text, (qs.statement_start_offset/2) + 1,
((case statement_end_offset 
when -1 
      then datalength(st.text) 
else 
      qs.statement_end_offset 
end 
- qs.statement_start_offset)/2) + 1) as statement_text
, plan_handle
, query_plan
,qs.creation_time
,qs.last_execution_time
,qs.execution_count
,qs.total_worker_time
,qs.last_worker_time
,qs.min_worker_time
,qs.max_worker_time
,qs.total_physical_reads
,qs.last_physical_reads
,qs.min_physical_reads
,qs.max_physical_reads
,qs.total_logical_writes
,qs.last_logical_writes
,qs.min_logical_writes
,qs.max_logical_writes
,qs.total_logical_reads
,qs.last_logical_reads
,qs.min_logical_reads
,qs.max_logical_reads
,qs.total_clr_time
,qs.last_clr_time
,qs.min_clr_time
,qs.max_clr_time
,qs.total_elapsed_time
,qs.last_elapsed_time
,qs.min_elapsed_time
,qs.max_elapsed_time
from sys.dm_exec_query_stats qs
cross apply sys.dm_exec_sql_text(qs.sql_handle) st
cross apply sys.dm_exec_text_query_plan(qs.plan_handle, qs.statement_start_offset, qs.statement_end_offset) 
order by qs.last_execution_time desc,total_worker_time/execution_count desc;
go

----------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------Begin Plan Cache SQL statements and execution plans-----------------------------------------------

select st.text, qp.query_plan, cp.cacheobjtype, cp.objtype, cp.plan_handle 
from sys.dm_exec_cached_plans cp
cross apply sys.dm_exec_sql_text(cp.plan_handle) st
cross apply sys.dm_exec_query_plan(cp.plan_handle) qp
go


select sum(cast(cp.size_in_bytes as bigint))/1024/1024 as [size of single use sql plans in MB]
from sys.dm_exec_cached_plans cp
where cp.usecounts = 1 and objtype in ('Adhoc','Prepared')


perfmon counters

SQL Server SQL Statistics:SQL Compilations/Sec
SQL Server SQL Statistics:SQL Re-Compilations/Sec
SQL Server SQL Statistics:Batch Requests/Sec

initial compilations = SQL Compilations/Sec - SQL Re-Compilations/Sec
plan re-use = (Batch Requests/Sec - initial compilations)/Batch Requests/Sec



Waits event
RESOURCE_SEMAPHORE_QUERY_COMPILE


sp_recompile 'wfmuser.wm_schedule_days'


--------------------------------------------------End Plan Cache SQL statements and execution plans-----------------------------------------------

--------------------------------------------------Begin Extended Event Example--------------------------------------------------------------------

sqlserver.sp_statement_completed
sqlserver.sql_statement_completed
sqlserver.page_split  -- index page splits or fragmantation
sqlserver.long_io_detected
sqlserver.lock_deadlock
sqlserver.error_reported


SELECT * FROM sys.dm_xe_sessions  -- has all the created events

CREATE EVENT SESSION sessionWaits ON SERVER ADD EVENT sqlos.wait_info(WHERE  sqlserver.session_id = 53 AND duration > 0);

ADD TARGET package0.asyncronous_file_target(SET FILENAME='E:\temp\waitstats.xml',METADATAFILE='E:\temp\waitstats.xem');

ALTER EVENT SESSION sessionWaits  ON SERVER STATE=START;
ALTER EVENT SESSION [FileTargetDemo]  ON SERVER STATE=STOP;
DROP EVENT SESSION [FileTargetDemo] ON SERVER

Now use the function sys.fn_xe_file_target_read_file('E:\temp\waitstats.xml','E:\temp\waitstats.xem',null,null) to convert into a view as shown below

create view dbo.read_xe_file as
select object_name as event, CONVERT(xml, event_data) as data
from sys.fn_xe_file_target_read_file('E:\temp\waitstats.xml', 'E:\temp\waitstats.xem', null, null)
go
 

create view dbo.xe_file_table as
select 
      event
      , data.value('(/event/data/text)[1]','nvarchar(50)') as 'wait_type'
      , data.value('(/event/data/value)[3]','int') as 'duration'
      , data.value('(/event/data/value)[6]','int') as 'signal_duration'
from dbo.read_xe_file
go

 
--- without creating a view
select
      wait_type
      , sum(duration) as 'total_duration'
      , sum(signal_duration) as 'total_signal_duration'
from dbo.xe_file_table
group by wait_type
order by sum(duration) desc
go


select
      wait_type
      , sum(duration) as 'total_duration'
      , sum(signal_duration) as 'total_signal_duration'
from 
(
select 
      event
      , data.value('(/event/data/text)[1]','nvarchar(50)') as 'wait_type'
      , data.value('(/event/data/value)[3]','int') as 'duration'
      , data.value('(/event/data/value)[6]','int') as 'signal_duration'
from 
(select object_name as event, CONVERT(xml, event_data) as data
from sys.fn_xe_file_target_read_file('d:\dba\xe\SessionWaits_0_130737543098410000.etl', 'd:\dba\xe\SessionWaits_0_130737543098410000.mta', null, null)
) a
) b
group by wait_type
order by sum(duration) desc

--------------------------------------------------End Extended Event Example------------------------------------------------------


--------------------------------------------------Begin Plan Guide----------------------------------------------------------------

********************This creates a plan guide for sp
CREATE PROCEDURE Sales.GetSalesOrderByCountry (@Country_region nvarchar(60))
AS
BEGIN
    SELECT *
    FROM Sales.SalesOrderHeader AS h, Sales.Customer AS c, 
        Sales.SalesTerritory AS t
    WHERE h.CustomerID = c.CustomerID
        AND c.TerritoryID = t.TerritoryID
        AND CountryRegionCode = @Country_region
END;

sp_create_plan_guide    
@name = N'Guide1',
@stmt = N'SELECT *FROM Sales.SalesOrderHeader AS h,
        Sales.Customer AS c,
        Sales.SalesTerritory AS t
        WHERE h.CustomerID = c.CustomerID 
            AND c.TerritoryID = t.TerritoryID
            AND CountryRegionCode = @Country_region',
@type = N'OBJECT',
@module_or_batch = N'Sales.GetSalesOrderByCountry',
@params = NULL,
@hints = N'OPTION (OPTIMIZE FOR (@Country_region = N''US''))';



************************plan guide for a sql statement
SELECT TOP 1 * FROM Sales.SalesOrderHeader ORDER BY OrderDate DESC;

sp_create_plan_guide 
@name = N'Guide2', 
@stmt = N'SELECT TOP 1 * FROM Sales.SalesOrderHeader ORDER BY OrderDate DESC',
@type = N'SQL',
@module_or_batch = NULL, 
@params = NULL, 
@hints = N'OPTION (MAXDOP 1)';

************************plan guide for a parametrised query

EXEC sp_create_plan_guide 
    @name = N'TemplateGuide1',
    @stmt = N'SELECT * FROM AdventureWorks2012.Sales.SalesOrderHeader AS h
              INNER JOIN AdventureWorks2012.Sales.SalesOrderDetail AS d 
                  ON h.SalesOrderID = d.SalesOrderID
              WHERE h.SalesOrderID = @0',
    @type = N'TEMPLATE',
    @module_or_batch = NULL,
    @params = N'@0 int',
    @hints = N'OPTION(PARAMETERIZATION FORCED)';


--------------------------------------------------End Plan Guide----------------------------------------------------------------


--------------------------------------------------Begin Merge SQl Server data files---------------------------------------------

USE DataBaseName
GO

DBCC SHRINKFILE(LogicalNameOfFileToRemove, EMPTYFILE)
ALTER DATABASE DataBaseName REMOVE FILE LogicalNameOfFileToRemove

--------------------------------------------------End Merge SQl Server data files---------------------------------------------

--------------------------------------------------Begin Grant Needed to view activity monitor---------------------------------
grant VIEW SERVER STATE to [AN\C0203733]
grant VIEW ANY DEFINITION to [SANUK\C0203733]

--- Grant for Bulk insert
grant ADMINISTER BULK OPERATIONS to [AN\C0203733]
--------------------------------------------------end Grant Needed to view activity monitor---------------------------------

--------------------------------------------------Begin Powershell example---------------------------------------------------
Add-PSSnapin SqlServerCmdletSnapin100  -- needed for running Invoke-SQlCmd
Add-PSSnapin SqlServerProviderSnapin100 -- needed for running Invoke-SQlCmd

Invoke-SQLCmd -Query "select getdate()" -Database master -ServerInstance ENTAAP504P\INST80 | Out-GridView
Invoke-SQLCmd -Query "select * from sys.master_files" -Database master -ServerInstance ENTAAP504P\INST80 | Out-GridView
--------------------------------------------------end Powershell example---------------------------------------------------


-------------------------------------------------Begin listing SQL Server Error Log---------------------------------------
grant execute on xp_readerrorlog to "AN\C0224512"

master..xp_readerrorlog 0   (current log)
master..xp_readerrorlog 1   (next oldest log)

-------------------------------------------------End listing SQL Server Error Log---------------------------------------


-------------------------------------------------Begin Trusted Connection Example---------------------------------------------

"PROVIDER=SQLOLEDB;SERVER=SQLMULPVWSK15\INST80;DATABASE=SwitcherBp;Trusted_Connection=Yes;" 

-------------------------------------------------End Trusted Connection Example---------------------------------------------

-------------------------------------------------Begin Biztalk Version Script------------------------------------------------

USE [BizTalkMgmtDb]            
             
SELECT DatabaseMajor,DatabaseMinor,ProductBuildNumber, ProductRevision 
FROM dbo.BizTalkDBVersion;
-------------------------------------------------End Biztalk Version Script------------------------------------------------

-------------------------------------------------Begin Changing the password policy of SQL Server Account ----------------------

USE Master
GO
ALTER LOGIN test_must_change WITH PASSWORD = ‘samepassword’
GO
ALTER LOGIN test_must_change WITH
      CHECK_POLICY = OFF,
      CHECK_EXPIRATION = OFF;
-------------------------------------------------End Changing the password policy of SQL Server Account ----------------------

------------------------ Begin tran --------------------

begin tran

SELECT COUNT(*) FROM dbo.Flash_Master_History WHERE CurrMTDVal>999999999999999 AND CurrMTDVol=0;
UPDATE dbo.Flash_Master_History SET CurrMTDVol = 999999999 WHERE CurrMTDVal>999999999999999 AND CurrMTDVol = 0;
SELECT COUNT(*) FROM dbo.Flash_Master_History WHERE CurrMTDVal>999999999999999 AND CurrMTDVol=0;

-----------------------------End tran -----------------------

-----------------------------Begin SQl Query Examples-------------------------

select COUNT(1) from Reservation (nolock)
select COUNT(1) from Reservation (readuncommitted)
-----------------------------End SQl Query Examples-------------------------

-----------------------------Begin List Database Files-----------------------
exec sqldbadb..sp_dbfilelist @filename='R', @autogrow='Y'
exec sqldbadb..sp_dbfilelist @databasename='WSS_ContentAbbeyP'
-----------------------------End List Database Files-----------------------
select 'select ' + '''' + name + '''' + ' tab_name, count(*) row_count from wfmuser.'+name+';' from sys.tables
---------------------------



------------------------------SQL Server 2016 feature  Querystore-------------------------

    a plan store for persisting the execution plan information.
    a runtime stats store for persisting the execution statistics information.
    a wait stats store for persisting wait statistics information.

ALTER DATABASE AdventureWorks2012 SET QUERY_STORE = ON;  
ALTER DATABASE <db_name> SET QUERY_STORE CLEAR;     --- clears all the spaced used in the query store
ALTER DATABASE <database_name> SET QUERY_STORE (MAX_STORAGE_SIZE_MB = <new_size>);  
ALTER DATABASE <database name> SET QUERY_STORE (OPERATION_MODE = READ_WRITE,CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30),DATA_FLUSH_INTERVAL_SECONDS = 3000,MAX_STORAGE_SIZE_MB = 500,INTERVAL_LENGTH_MINUTES = 15,SIZE_BASED_CLEANUP_MODE = AUTO,QUERY_CAPTURE_MODE = AUTO,MAX_PLANS_PER_QUERY = 1000,WAIT_STATS_CAPTURE_MODE = ON ); 

Dynamic views
sys.database_query_store_options (Transact-SQL)
sys.query_context_settings (Transact-SQL)
sys.query_store_plan (Transact-SQL)
sys.query_store_query (Transact-SQL)
sys.query_store_query_text (Transact-SQL)
sys.query_store_runtime_stats (Transact-SQL)
sys.query_store_wait_stats (Transact-SQL)
sys.query_store_runtime_stats_interval (Transact-SQL)


--------------------------SQL Server certificates -----------------------

SELECT * FROM sys.certificates;

BACKUP certificate ##MS_SQLAuthenticatorCertificate## to file 'c:\temp\authenticationCertificate.cer'


-------------------------------------Killing a Index REORGANIZE or REBUILD job------------------

Yes, you can stop a reorganize and it won't cause a big rollback like you are talking about. You will be left with where the operation left off 
(that's a good thing). It's a rebuild that would have the rollback behavior.

Index rebuild with online will also not rollback for long if you kill the job

------------------------------------------------------