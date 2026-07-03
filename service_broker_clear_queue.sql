DECLARE @ConversationHandle UNIQUEIDENTIFIER

WHILE (1=1)

       BEGIN

      


       WAITFOR

       (

              RECEIVE TOP (1)

              @ConversationHandle = conversation_handle

              FROM PNQQueue

       ), TIMEOUT 1000;

 

       IF @@ROWCOUNT = 0

       BEGIN

              PRINT 'No Record In Queue'

              BREAK;

       END

END