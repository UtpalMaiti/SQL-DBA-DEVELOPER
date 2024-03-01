USE [DB_OBJECTS]
GO

SELECT * FROM [DB_OBJECTS]

CREATE STATISTICS STATS1 ON SALES_DATA(SALESAMOUNT)

UPDATE STATISTICS SALES_DATA

-- TO REPORT LIST OF STATISTICS IN ENTIRE DATABASE : 
SELECT * FROM SYS.STATS

-- TO REPORT LIST OF STATISTICS IN A SPECIFIC TABLE: 
SELECT * FROM SYS.STATS WHERE OBJECT_ID = OBJECT_ID('SALES_DATA')

