

CREATE TABLE empDetails
(
EmpID int PRIMARY KEY,
EmpName varchar(30),
EmpManagerID int REFERENCES empDetails(EmpID)			-- SELF REFERECING KEYS. A TABLE RELATES TO ITSELF.
)

CREATE TABLE empDetailsChar
(
EmpID char(5) PRIMARY KEY,
EmpName varchar(30),
EmpManagerID char REFERENCES empDetails(EmpID)			-- SELF REFERECING KEYS. A TABLE RELATES TO ITSELF.
)


--TASK 1:  WRITE A QUERY TO REPORT SUCH MANAGER(S) THAT HAVE MAXIMUM NUMBER OF EMPLOYEES? 

drop table if exists #mgrGroupby
DECLARE @maxvalue int =0;	
SELECT EmpManagerID,COUNT(EmpManagerID) AS Temployee 
into #mgrGroupby  FROM  [dbo].[empDetails]  GROUP BY EmpManagerID

--SELECT MAX(Temployee) as maxTemployee   FROM #mgrGroupby 

SELECT 
E.[EmpID],
E.[EmpName],
E.[EmpManagerID],
M.EmpName AS [MANAGE_NAME]
FROM [dbo].[empDetails] E 
INNER JOIN [dbo].[empDetails] M ON E.EmpManagerID=M.EmpID
WHERE e.EmpID IN 
(
SELECT EmpManagerID from #mgrGroupby WHERE Temployee=(SELECT MAX(Temployee) as maxTemployee   FROM #mgrGroupby )
)

--TASK 2:  HOW TO REPORT LIST OF ALL EMPLOYEES WHOSE MANAGER IS JOHN?

SELECT * FROM [dbo].[empDetails]

SELECT 
E.[EmpID],
E.[EmpName],
E.[EmpManagerID],
M.EmpName AS [ManageName]
FROM [dbo].[empDetails] E 
INNER JOIN [dbo].[empDetails] M ON E.EmpManagerID=M.EmpID
WHERE M.EmpName IN('JOHN')


--TASK 3:  HOW TO REPORT LIST OF ALL EMPLOYEES FOR A GIVEN MANAGER? IN THIS CASE, MANAGER NAME IS GIVEN AT RUN TIME.


CREATE FUNCTION [dbo].[UDF_GetEMPInfoByManageName] (@ManageName VARCHAR(9))
RETURNS table										-- here, table is a data type
AS 
RETURN ( 
SELECT 
E.[EmpID],
E.[EmpName],
E.[EmpManagerID],
M.EmpName AS [ManageName]
FROM [dbo].[empDetails] E 
INNER JOIN [dbo].[empDetails] M ON E.EmpManagerID=M.EmpID
WHERE M.EmpName IN(@ManageName)
)

SELECT * FROM  UDF_GetEMPInfoByManageName('JOHN')



--TASK 4:  HOW TO REPORT THE NUMBER OF EMPLOYEES REPORTING TO EACH MANAGER?

SELECT 
M.EmpName AS [MANAGE_NAME],
COUNT(ISNULL(M.EmpName,0)) AS EmpReportCount
FROM [dbo].[empDetails] E 
INNER LOOP JOIN [dbo].[empDetails] M ON E.EmpManagerID=M.EmpID
GROUP BY M.EmpName
order by EmpReportCount desc


--TASK 5:	 GIVEN A TABLE, HOW TO FIND IF A TABLE HAS SELF REFERENCING KEYS?

SP_HELP [empDetails]

--sp_help sp_help

--TASK 6:	 GIVEN A TABLE, HOW DO YOU FIND THE NUMBER OF CANDIDATE KEYS?
--		OPTION 1:	SOLUTION USING GUI

-- Ans: GO TO TABLE >> EXPAND TABLE >>UNDER THE COLUMNs AND KEYS SECTION  

--		OPTION 2:	SOLUTION USING SQL SCRIPT

SP_HELP [empDetails]

EXEC SP_PKEYS	[empDetails]						-- TO REPORT PRIMARY KEY INFORMATION OF THE GIVEN TABLE

--TASK 7:	 GIVEN A TABLE, HOW DO YOU FIND THE NUMBER OF FOREIGN KEYS? LIST ALL POSSIBLE OPTIONS.

-- Ans: GO TO TABLE >> EXPAND TABLE >>UNDER THE COLUMNs AND KEYS SECTION  

SELECT * FROM sys.sysobjects WHERE  TYPE  LIKE 'F'

SELECT * FROM SYS.FOREIGN_KEYS			-- TO REPORT LIST OF ALL FOREIGN_KEYS FROM USER TABLES IN THE DATABASE
	
SP_HELP [empDetails]


--TASK 8:	 WHAT ARE THE CONDITIONS TO DEFINE A FOREIGN KEY ON A TABLE?

--1. Source table must have a Primary key  NAD DATA TYPE MUST MATCH WITH FOREIGN Key

	FOREIGN KEY		: This is used to reference / link one table to another  table.
			SUCH DATABASES THAT CONTAINS RELATIONS ARE "RDB"


--TASK 9:	 WHAT ARE THE DIFFERENCES BETWEEN PRIMARY KEY AND UNIQUE KEY?

4.	PRIMARY KEY		: This column does not allow duplicates, Does not allow null value ,By Default It creates a Cluster Index While applying PRIMARY KEY
3.	UNIQUE KEY		: This column does not allow duplicates. Allows up to 1 null value .By Default It creates a Non Cluster Index While applying UNIQUE KEY


--TASK 10: CAN WE DEFINE PRIMARY KEY ON CHARACTER COLUMNS?

Ans:Yes

CREATE TABLE empDetailsChar2
(
EmpID char(5) PRIMARY KEY,
EmpName varchar(30)
)