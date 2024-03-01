/*
CTE		:	 COMMON TABLE EXPRESSION
			 USED TO STORE THE QUERY AND ITS RESULT IN MEMORY.
			 FOR FASTER DATA ACCESS AND FASTER DML OPERATIONS.

REAL-WORLD USE:	CTEs ARE USED TO AVOID SELF JOINS AND SUB QUERIES.
*/
USE [DB_OBJECTS];
GO
-- DROP TABLE tbltest
CREATE TABLE tbltest
(
ID_COL INT,
Value_Col INT default 100,
RANK_Col INT
)

INSERT INTO tbltest VALUES (1,100, null)
INSERT INTO tbltest VALUES (2,100, null)
INSERT INTO tbltest VALUES (3,200, null)
INSERT INTO tbltest VALUES (4,200, null)
INSERT INTO tbltest VALUES (5,300, null)
INSERT INTO tbltest VALUES (6,300, null)
INSERT INTO tbltest VALUES (7,300, null)
INSERT INTO tbltest VALUES (16,300, null)
INSERT INTO tbltest VALUES (27,300, null)

SELECT * FROM tbltest




-- EXAMPLE 1:
WITH CTE
AS
(
SELECT * FROM tbltest			-- PHASE 1:		THIS QUERY OUTPUT IS STORED IN MEMORY
)
SELECT * FROM CTE				-- PHASE 2:		WE ARE READING FROM THIS MEMORY COPY


-- EXAMPLE 2:
WITH CTE
AS
(
SELECT * FROM tbltest
)
INSERT INTO CTE VALUES (77,77,77)		-- INSTEAD OF INSERTING INTO TABLE, WE ARE INSERTING INTO CTE		



SELECT * FROM tbltest



truncate table tbltest

INSERT INTO tbltest VALUES (1,100, null)
INSERT INTO tbltest VALUES (2,100, null)
INSERT INTO tbltest VALUES (3,200, null)
INSERT INTO tbltest VALUES (4,200, null)
INSERT INTO tbltest VALUES (5,300, null)
INSERT INTO tbltest VALUES (6,300, null)
INSERT INTO tbltest VALUES (7,300, null)
INSERT INTO tbltest VALUES (16,300, null)
INSERT INTO tbltest VALUES (27,300, null)

select * from tbltest

-- REQ : HOW TO UPDATE RANK_COL WITH UNIQUE SEQUENCE VALUES?

SELECT *, ROW_NUMBER() OVER (ORDER BY VALUE_COL) AS SEQUENCE FROM tbltest


UPDATE tbltest 
SET RANK_COL = SUBQUERY.SEQUENCE
FROM
(
SELECT *, ROW_NUMBER() OVER (ORDER BY VALUE_COL) AS SEQUENCE FROM tbltest
) AS SUBQUERY
INNER JOIN tbltest
ON
SUBQUERY.ID_COL = tbltest.ID_COL AND SUBQUERY.VALUE_COL = tbltest.VALUE_COL

SELECT * FROM tbltest

-- QUERY AVOIDING SELF JOINS & SUB QUERIES:
WITH CTE 
AS
(
SELECT *, ROW_NUMBER() OVER (ORDER BY VALUE_COL) AS SEQUENCE FROM tbltest
)
UPDATE CTE SET RANK_COL = SEQUENCE





-- RECURSION :  A MECHANISM TO CALL AN OBJECT INSIDE ITSELF.
-- RECURSIVE CTE : A CTE CALLS THE SAME CTE INSIDE IT.
-- EVERY CTE HAS AN "ANCHOR" ELEMENT TO START THE LOOP. AND A "TERMINATION" CONDITION.

SELECT DATENAME(DW,0)		--	DW : DAY OF THE WEEK
SELECT DATENAME(DW,1)	
SELECT DATENAME(DW,2)

SELECT DATENAME(DW,1)	
UNION ALL
SELECT DATENAME(DW,2)



WITH CTE  (n, WEEKDAY)
AS
(
SELECT 0, DATENAME(DW, 0)					-- ANCHOR ELEMENT
UNION ALL
SELECT n+1, DATENAME(DW, n+1) FROM CTE		--Loop
WHERE
N <= 5										--Termination				
)
SELECT * FROM CTE 	




CREATE PROC USP_REPORT_DAYS 
AS
WITH CTE (n, WEEKDAY)
AS
(
SELECT 0, DATENAME(DW,0)
UNION ALL
SELECT n+1, DATENAME(DW,n+1) FROM CTE WHERE n <=5
) SELECT * FROM CTE 


EXEC USP_REPORT_DAYS



;WITH CTE (n, WeekDayName,MonthNames)
AS
(
SELECT 0, DATENAME(DW,0),DATENAME(D,0)
UNION ALL
SELECT n+1, DATENAME(DW,n+1),DATENAME(D,n+1) FROM CTE WHERE n <=5
) 
SELECT * FROM CTE 
