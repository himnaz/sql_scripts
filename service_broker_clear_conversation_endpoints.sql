DECLARE @sql NVARCHAR(MAX)
       ,@far_service NVARCHAR(256) = N'PNQService';

WHILE EXISTS (
                 SELECT COUNT(*)
                 FROM   sys.conversation_endpoints
                 WHERE  far_service = @far_service
             )
BEGIN
    SET @sql = N'';
    SELECT TOP 1000 @sql = @sql + N'END CONVERSATION ''' + CAST(conversation_handle AS NVARCHAR(50)) + N''' WITH CLEANUP;
'
    FROM   sys.conversation_endpoints
    WHERE  far_service = @far_service;

    --PRINT @sql;
    EXEC sys.sp_executesql @stmt = @sql;

    --RETURN;
END;
GO


declare @h uniqueidentifier, @count int = 0;
begin transaction;
while (1=1)
begin
	set @h = null;
	select top(1) @h = conversation_handle
		from sys.conversation_endpoints
		where state_desc = N'CLOSED'
		and security_timestamp = '1900-01-01 00:00:00.000'
		and lifetime > dateadd(month, 1, getutcdate())
	if (@h is null)
	begin
		break
	end
	end conversation @h with cleanup;
	set @count += 1;
	if (@count > 1000)
	begin
		commit;
		set @count = 0;
		begin transaction;
	end
end
commit