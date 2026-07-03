--https://www.sqlshack.com/sql-server-lock-issues-when-using-a-ddl-including-select-into-clause-in-long-running-transactions/

SELECT Operation, Context, AllocUnitName, COUNT(*) OpCount
FROM fn_dblog(null,null) 
WHERE [Transaction ID] = @transactionid
GROUP BY Operation, Context, AllocUnitName 