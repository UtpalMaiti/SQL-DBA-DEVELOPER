
USE [DB_OBJECTS]

SELECT * INTO TESTTABLE FROM SYSMESSAGES	-- CREATES TABLE, INSERTS DATA

INSERT INTO TESTTABLE SELECT * FROM TESTTABLE

SELECT * FROM SYS.DM_EXEC_QUERY_STATS			-- DYNAMIC MANAGEMENT VIEW

SELECT * FROM SYS.DM_EXEC_SQL_TEXT(0x03000200FD4A12A4C0F2DA00ADAB000001000000000000000000000000000000000000000000000000000000) -- DMF
-- DYNAMIC MANAGEMENT FUNCTION

SELECT  TOP 10 TEXT, total_worker_time / execution_count as AVG_EXEC_TIME, DBID	,DB_NAME(DBID)		-- TIME IN MILLI SECONDS
FROM SYS.DM_EXEC_QUERY_STATS
CROSS APPLY						-- THIS IS SIMILAR TO CROSS JOIN
SYS.DM_EXEC_SQL_TEXT (PLAN_HANDLE)
ORDER BY  AVG_EXEC_TIME DESC 
