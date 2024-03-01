/*
STATISTICS ARE DATABASE OBJECTS USED TO STORE COLUMN ADDRESS INFORMATION.
PURPOSE: FOR FASTER, EASIER COLUMN ACCESS. 

ADVANTAGE OF STATISTICS:
	ASSUME YOU USE COL2 IN A QUERY CONDITION. THIS AUTO CREATES ONE STATISTICS ON THIS COLUMN.
	THEN THE NEXT TIME WE USE COL2 IN THE QUERIES, THE ABOVE CREATED STATISTICS ARE AUTO DETECTED, USED
	BY QO FOR ANALYSING THE BEST EXECUTION PLAN. 
*/
	
use tempdb
go

CREATE TABLE TEST_TABLE (COL1 INT PRIMARY KEY, COL2 INT)
INSERT INTO TEST_TABLE VALUES (1001, 10), (1002, 10), (1003, 10), (1004, 10)

-- TO MONITOR STATISTICS OF A TABLE:
SELECT * FROM SYS.STATS WHERE OBJECT_ID = OBJECT_ID('TEST_TABLE')	-- 1 STATISTICS	

SELECT * FROM TEST_TABLE WHERE COL2 = 10		-- STATISTICS ARE AUTO CREATED.
SELECT * FROM SYS.STATS WHERE OBJECT_ID = OBJECT_ID('TEST_TABLE')	-- 2 STATISTICS	

/*
MAINTENENCE OF STATISTICS: 	FOR EFFICIENT USE OF STATISTICS BY QUERY OPTIMIZER, WE NEED TO ENSURE THE STATS ARE UPTO DATE.
		OPTION 1:	MANUAL / ON-DEMAND UPDATE OF STATISTICS FOR A SPECIFIC TABLE
		OPTION 2:	AUTOMATED UPDATE OF STATISTICS FOR ALL TABLES IN ALL DATABASES IN THE SERVER : MAINTENANCE PLANS

*/

-- COMMAND TO UPDATE THE STATISTICS ON A TABLE MANUALLY:
UPDATE STATISTICS TEST_TABLE WITH FULLSCAN			-- EVERY PAGE FOR THIS TABLE IS SCANNED, UPDATED
