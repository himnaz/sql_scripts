set nocount on
go
set ansi_warnings off
GO

declare @force_continue char(1)

--------------------------------------------------------------
-- SET PARAMETERS
--------------------------------------------------------------
-- force_continue = continue with user sessions
-- normally the presence of user connections would indicate
-- that the databases are still need to no need to run the
-- rest of the report
-- set to Y to continue with user sessions connected
--------------------------------------------------------------
set @force_continue='N'
--------------------------------------------------------------
print '--------------------------'
print 'Installation Date         '
print '--------------------------'
SELECT	[createdate] AS 'SQL Install Date'
FROM	[syslogins]
WHERE	[sid] = 0x010100000000000512000000 --NT AUTHORITY\SYSTEM


print '--------------------------'
print 'Checking for user sessions'
print '--------------------------'

if object_id ( 'tempdb..##sqlsession_list__tmp_Z9QA') is not null 
begin
	drop table ##sqlsession_list__tmp_Z9QA
end

select db_name(dbid) as [dbname], count(*) as [session count] 
into ##sqlsession_list__tmp_Z9QA
from sysprocesses
where dbid > 4
and db_name(dbid) != 'SQLDBADB'
group by db_name(dbid)

If exists (select * from [##sqlsession_list__tmp_Z9QA])
begin
	select * from [##sqlsession_list__tmp_Z9QA]
end
else
begin
	print 'NO user sessions'
end

if (@force_continue='Y')
begin
	delete from [##sqlsession_list__tmp_Z9QA]
end
go


if (object_id('tempdb..#templist') is not null) 
begin
	drop table #templist
end

----------------------------------------------------------------------------------------------------
if ( select count(*) from [##sqlsession_list__tmp_Z9QA] ) = 0   
begin

	print ''
	print '------------------------------------------------'
	print 'Checking for databases created in the last year '
	print '------------------------------------------------'

	select convert(varchar(32),name) as [dbname], crdate as [create date] 
	into #templist
	from sysdatabases
	where name != 'tempdb'
	and crdate > getdate()-365

	If ((select count(*) from #templist) = 0)
	begin
		print 'NO new databases in the last year'
	end
	else
	begin
		select * from #templist
	end
	drop table #templist

end

go


----------------------------------------------------------------------------------------------------
if ( select count(*) from [##sqlsession_list__tmp_Z9QA] ) = 0   
begin

	print ''
	print '--------------------------------------------'
	print 'Checking for login changes in the last year '
	print '--------------------------------------------'

	select convert(varchar(32),name) as [name], createdate as [create date], updatedate as [update date] 
	into #templist
	from syslogins
	where updatedate > getdate()-365
	or createdate > getdate()-365

	If ((select count(*) from #templist) = 0)
	begin
		print 'NO login changes in the last year'
	end
	else
	begin
		select * from #templist
	end
	drop table #templist

end
go

----------------------------------------------------------------------------------------------------
if ( select count(*) from [##sqlsession_list__tmp_Z9QA] ) = 0   
begin

	print ''
	print '----------------------------------------------------'
	print 'Checking for database user changes in the last year '
	print '----------------------------------------------------'

	declare @name sysname
	declare @str varchar(512)
	declare dbc cursor for 
	select name from master..sysdatabases 
	where dbid > 4
	and name != 'SQLDBADB'
	and databasepropertyex(name, 'status')  = 'ONLINE'

	create table ##temp_dbu__list_BV3Q
	(
	[dbname] sysname,
	[login] sysname,
	[dbuser] sysname,
	[createdate] datetime,
	[modifydate] datetime
	)

	open dbc

	fetch dbc into @name
	while (@@fetch_status = 0)
	begin
	
		set @str='insert into ##temp_dbu__list_BV3Q select ''' + @name + ''', l.name, u.name, u.createdate, u.updatedate from ['+@name+'].dbo.sysusers u join syslogins l on l.sid = u.sid where hasdbaccess=1 and (u.createdate > getdate()-365 or u.updatedate > getdate()-365)'
		exec (@str)
		--print @str
		fetch dbc into @name

	end

	close dbc
	deallocate dbc


	If ((select count(*) from [##temp_dbu__list_BV3Q]) = 0)
	begin
		print 'NO database user changes in the last year'
	end
	else
	begin
		select 
		convert(varchar(32), dbname) as dbname, 
		convert(varchar(32), [login]) as [login],
		convert(varchar(32), [dbuser]) as [dbuser],
		createdate,
		modifydate
		from [##temp_dbu__list_BV3Q]
		order by 1,2
	end

	drop table ##temp_dbu__list_BV3Q

end

go

----------------------------------------------------------------------------------------------------
if ( select count(*) from [##sqlsession_list__tmp_Z9QA] ) = 0   
begin

	print ''
	print '------------------------------------------------------'
	print 'Checking for database object created in the last year '
	print '------------------------------------------------------'

	declare @name sysname
	declare @str varchar(512)
	declare dbc cursor for 
	select name from master..sysdatabases 
	where dbid > 4
	and name != 'SQLDBADB'
	and databasepropertyex(name, 'status')  = 'ONLINE'

	create table ##temp_obj__list_BV2P
	(
	[dbname] sysname,
	[name] sysname,
	[createdate] datetime
	)

	open dbc

	fetch dbc into @name
	while (@@fetch_status = 0)
	begin
	
		set @str='use ['+@name+'];insert into ##temp_obj__list_BV2P select db_name(), name, crdate from ['+@name+'].dbo.sysobjects where objectproperty(id, ''ismsshipped'') = 0 and crdate > getdate()-365'
		--print @str
		exec (@str)
		
		fetch dbc into @name

	end

	close dbc
	deallocate dbc


	If ((select count(*) from [##temp_obj__list_BV2P]) = 0)
	begin
		print 'NO database object changes in the last year'
	end
	else
	begin
		select 
		convert(varchar(32), dbname) as dbname, 
		convert(varchar(32), [name]) as [objectname],
		createdate
		from [##temp_obj__list_BV2P]
		order by 1,2
	end

	drop table ##temp_obj__list_BV2P

end

go

----------------------------------------------------------------------------------------------------
if ( select count(*) from [##sqlsession_list__tmp_Z9QA] ) = 0   
begin

	print ''
	print '-------------------------------------------------------------'
	print 'Checking for database tables accessed since the last restart '
	print '-------------------------------------------------------------'

	declare @name sysname
	declare @str varchar(1024)
	
	declare @sql varchar(1024)

	declare @days int
	select @days=datediff(d, create_date, getdate())  
	from sys.databases
	where name = 'tempdb'

	set @sql=
	';with cte_tabs as ' + 
	'( ' +
	'select object_name(object_id) as [tablename], ' +
	'last_user_seek, last_user_scan, last_user_lookup, last_user_update from sys.dm_db_index_usage_stats ' +
	'where database_id = db_id() ' + 
	'and OBJECTPROPERTY(object_id, ''ismsshipped'')= 0 ' +
	') ' +
	', ' +
	'cte_last_access as ' +
	'( ' +
	'select tablename, last_user_seek as [last_acc]	  from cte_tabs union ' +
	'select tablename, last_user_scan as [last_acc]	  from cte_tabs union ' +
	'select tablename, last_user_lookup as [last_acc] from cte_tabs union ' +
	'select tablename, last_user_update as [last_acc] from cte_tabs ' +	 
	') ' +
	'insert into ##temp_obj__list_BV2P ' +
	'select db_name(), tablename, max(last_acc) as [last_access] ' + 
	'from cte_last_access  ' +
	'where last_acc is not null  ' +
	'group by tablename ' 



	declare dbc cursor for 
	select name from master..sysdatabases 
	where dbid > 4
	and name != 'SQLDBADB'
	and databasepropertyex(name, 'status')  = 'ONLINE'

	create table ##temp_obj__list_BV2P
	(
	[dbname] sysname,
	[name] sysname,
	[last_access] datetime
	)

	open dbc

	fetch dbc into @name
	while (@@fetch_status = 0)
	begin
	
		set @str='use ['+@name+']; ' + @sql
		exec (@str)
		
		fetch dbc into @name

	end

	close dbc
	deallocate dbc


	If ((select count(*) from [##temp_obj__list_BV2P]) = 0)
	begin
		set @str='NO database object access in the last ' + convert(varchar(8), @days) + ' days'
		print @str
	end
	else
	begin
		select 
		convert(varchar(32), dbname) as dbname, 
		convert(varchar(32), [name]) as [objectname],
		last_access
		from [##temp_obj__list_BV2P]
		order by 1,2
	end

	drop table ##temp_obj__list_BV2P

end

go

----------------------------------------------------------------------------------------------------
if ( select count(*) from [##sqlsession_list__tmp_Z9QA] ) = 0   
begin

	print ''
	print '---------------------------------------------------'
	print 'Checking for sqlagent job changes in the last year '
	print '---------------------------------------------------'

	select convert(varchar(32),name) as [name], date_created as [create date], date_modified as [modified date]
	into #templist
	from msdb..sysjobs
	where 
	( 	 date_created > getdate()-365
	  or date_modified > getdate()-365
	)
	and name not in 
	( 
	'DECOM_AUDIT_TRC', 
	'DECOM_AUDIT_TRC_START',
	'SIEM_AUDIT_TRC',
	'SIEM_AUDIT_CHECK_TRC',
	'SIEM_AUDIT_TRC_START'
	 )
	
	
	If ((select count(*) from #templist) = 0)
	begin
		print 'NO sqlagent job changes in the last year'
	end
	else
	begin
		select * from #templist order by 1
	end
	drop table #templist

end
go

----------------------------------------------------------------------------------------------------
if ( select count(*) from [##sqlsession_list__tmp_Z9QA] ) = 0   
begin

	print ''
	print '------------------------------------------------------------'
	print 'Checking for sqlagent jobs scheduled against user databases '
	print '------------------------------------------------------------'

	
	select distinct 
	convert(varchar(32),j.name) as [job name], 
	convert(varchar(32),js.step_name) as [step name], 
	convert(varchar(32),js.database_name) as [database name] 
	into #templist
	from msdb..sysjobs j 
	join msdb..sysjobsteps js
	on j.job_id = js.job_id
	where enabled=1
	and  db_id(database_name) > 4
	and database_name not in ('SQLDBADB', 'distribution') 
	
	If ((select count(*) from #templist) = 0)
	begin
		print 'NO sqlagent jobs scheduled against user databases'
	end
	else
	begin
		select * from #templist order by 1,2
	end
	drop table #templist

end
go

----------------------------------------------------------------------------------------------------
if ( select count(*) from [##sqlsession_list__tmp_Z9QA] ) = 0   
begin


	print ''
	print '--------------------------------------------'
	print 'Checking backup history for DB size changes '
	print '--------------------------------------------'
	select 
	convert(varchar(32),d.name) as [dbname], 
	first_backup_date, 
	convert(decimal(10,1),(_first.file_size)/1024.0) as [first_size_mb], 
	last_backup_date, 
	convert(decimal(10,1),(_last.file_size)/1024.0) as [last_size_mb],
	datediff(d, first_backup_date, last_backup_date) as [days],
	convert(decimal(12,3),(_last.file_size-_first.file_size)/1024.0) as [mb change]
	into #templist 
	from
	sysdatabases d
	left join
	(
		select b.database_name,  lb.first_backup_date, sum(bf.file_size) as file_size 
		from msdb..backupset b
		join msdb..backupfile bf
		on bf.backup_set_id = b.backup_set_id
		join
		(
		select database_name, min(backup_finish_date) as first_backup_date from msdb..backupset 
		where type = 'D'
		and backup_start_date > getdate()-(365*2)
		group by database_name
		) lb
		on lb.database_name = b.database_name
		and lb.first_backup_date = b.backup_finish_date
		group by b.database_name,  lb.first_backup_date
	) _first
	on d.name = _first.database_name
	left join
	(
		select b.database_name,  lb.last_backup_date, sum(bf.file_size) as file_size 
		from msdb..backupset b
		join msdb..backupfile bf
		on bf.backup_set_id = b.backup_set_id
		join 
		(
		select database_name, max(backup_finish_date) as last_backup_date from msdb..backupset 
		where type = 'D'
		and backup_start_date > getdate()-365
		group by database_name
		) lb
		on lb.database_name = b.database_name
		and lb.last_backup_date = b.backup_finish_date
		group by b.database_name,  lb.last_backup_date
	) _last
	on _first.database_name = _last.database_name
	where d.name not in ( 'master', 'model', 'msdb', 'tempdb', 'sqldbadb' )
	
	select * from #templist
	order by 7 desc, 1

	drop table #templist

end

----------------------------------------------------------------------------------------------------
drop table ##sqlsession_list__tmp_Z9QA
go