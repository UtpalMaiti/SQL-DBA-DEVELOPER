
USE TRANTEST
GO

-- HOW TO MONITOR LOCKS?
EXEC SP_LOCK 

-- HOW TO MONITOR QUERY BLOCKING?
SELECT * FROM SYSPROCESSES WHERE BLOCKED <> 0    -- kpid : kernel process id

EXEC SP_LOCK			-- ANY LOCK WAIT RESULTS IN BLOCKING

EXEC SP_WHO2			-- USED TO REPORT THE DETAILS FOR EACH SESSION (CONNECTION)


-- GIVEN A SESSION ID, HOW TO KNOW TYPE OF QUERIES / OPERATIONS SUBMITTED AS INPUT ?
DBCC INPUTBUFFER(55)

KILL 55

SELECT @@TRANCOUNT		-- TO KNOW THE NUMBER OF OPEN TRANSACTIONS IN THE CURRENT SESSION
DBCC OPENTRAN()			-- TO KNOW THE DETAILS OF OPEN TRANSACTIONS IN THE CURRENT DATABASE



