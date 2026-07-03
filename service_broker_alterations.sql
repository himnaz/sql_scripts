ALTER QUEUE PNQQueue MOVE TO [NewFilegroup]


--The following example makes the ExpenseQueue queue unavailable to receive messages.
ALTER QUEUE PNQQueue WITH STATUS = OFF ;  

ALTER QUEUE ExpenseQueue WITH ACTIVATION (MAX_QUEUE_READERS = 7) ;  

--The following example changes the stored procedure that Service Broker starts. The stored procedure executes as the user SecurityAccount.
ALTER QUEUE ExpenseQueue  
    WITH ACTIVATION (  
        PROCEDURE_NAME = AdventureWorks2012.dbo.new_stored_proc ,  
        EXECUTE AS 'SecurityAccount') ;  