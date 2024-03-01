CREATE DATABASE DB_OBJECTS

USE DB_OBJECTS

CREATE SCHEMA SCHEMA1


CREATE TABLE SCHEMA1.EMPLOYEE_TABLE		
(
EMP_ID	 INT,	EMP_FNAME	VARCHAR (30),	 EMP_CNTRY	CHAR(50), EMP_SAL	BIGINT		
)		
				
INSERT 	 SCHEMA1.EMPLOYEE_TABLE  VALUES  (1001, 'AMIN',  'CANADA', 45678) , ('1002', 'JOHN', 'CANADA', 643643)	
INSERT   SCHEMA1.EMPLOYEE_TABLE	 VALUES   (1003, 'SAI', 'INDIA', 36363), (1004, 'SAISHA', 'INDIA',20000)		
INSERT   SCHEMA1.EMPLOYEE_TABLE	 VALUES   (1005, 'SAISH', 'INDIA', 43643),   (1006, 'ADAM', 'USA', NULL) 
  
SELECT * FROM SCHEMA1.EMPLOYEE_TABLE



-- VIEWS :		DATABASE OBJECTS USED TO STORE SELECT QUERY
-- FUNCTIONS :	DATABASE OBJECTS USED TO STORE SELECT QUERIES & DML QUERIES
-- PROCEDURES :	DATABASE OBJECTS USED TO STORE SELECT QUERIES, DML QUERIES & DDL QUERIES.

-- TRIGGERS :	DATABASE OBJECTS USED TO STORE SELECT QUERIES, DML QUERIES, DDL QUERIES. AUTO EXECUTION.


-- EXAMPLE FOR VIEWS:	USED FOR STATIC QUERY STORE
CREATE VIEW VW_CANADA_EMPLOYEES  AS  SELECT * FROM SCHEMA1.EMPLOYEE_TABLE WHERE EMP_CNTRY = 'CANADA'
CREATE VIEW VW_INDIA_EMPLOYEES  AS  SELECT * FROM SCHEMA1.EMPLOYEE_TABLE WHERE EMP_CNTRY = 'INDIA'

SELECT * FROM VW_CANADA_EMPLOYEES
SELECT * FROM VW_INDIA_EMPLOYEES


-- EXAMPLE FOR PROCEDURES:	USED FOR DYNAMIC QUERY STORE
CREATE PROCEDURE usp_Report_Employees @Country	VARCHAR(30)   	-- @Country IS A PARAMETER. MEANS, INPUT VALUE 
AS 
SELECT * FROM SCHEMA1.EMPLOYEE_TABLE WHERE EMP_CNTRY = @Country

EXECUTE	usp_Report_Employees	'CANADA'
EXECUTE	usp_Report_Employees	'INDIA'


-- EXAMPLE FOR FUNCTION:	USED FOR DYNAMIC QUERY STORE
CREATE FUNCTION udf_Report_Employees (@Country	VARCHAR(30))   	-- @Country IS A PARAMETER. MEANS, INPUT VALUE 
RETURNS table		-- table IS A DATA TYPE
AS 
RETURN ( SELECT * FROM SCHEMA1.EMPLOYEE_TABLE WHERE EMP_CNTRY = @Country )

SELECT * FROM udf_Report_Employees ('CANADA')
SELECT * FROM udf_Report_Employees ('INDIA')


-- IMPORTANT SYSTEM VIEWS
SELECT * FROM SYS.DATABASES		-- TO REPORT LIST OF ALL DATABASES IN THE SERVER
SELECT * FROM SYS.SCHEMAS		-- TO REPORT LIST OF ALL SCHEMAS IN THE DATABASE
SELECT * FROM SYS.TABLES		-- TO REPORT LIST OF ALL TABLES IN THE DATABASE
SELECT * FROM SYS.COLUMNS		-- TO REPORT LIST OF ALL COLUMNS IN THE DATABASE
SELECT * FROM SYS.VIEWS			-- TO REPORT LIST OF ALL VIEWS IN THE DATABASE
SELECT * FROM SYS.PROCEDURES	-- TO REPORT LIST OF ALL PROCEDURES IN THE DATABASE
SELECT * FROM SYS.OBJECTS		-- TO REPORT LIST OF ALL OBJECTS (SCHEMAS, VIEWS, FUNCTIONS, KEYS..) IN DATABASE

-- IMPORTANT SYSTEM PROCEDURES
EXECUTE SP_HELPDB							-- TO REPORT LIST OF ALL DATABASES IN THE SERVER 
EXECUTE SP_HELPDB  'DB_OBJECTS'				-- TO REPORT METADATA OR PROPERTIES OF THE GIVEN DATABASE

EXECUTE SP_HELP								-- TO REPORT LIST OF ALL OBJECTS IN THE DATABASE 
EXECUTE SP_HELP  'VW_CANADA_EMPLOYEES'		-- TO REPORT METADATA OR PROPERTIES OF THE GIVEN OBJECT

EXECUTE SP_HELPTEXT 'VW_CANADA_EMPLOYEES'	-- TO REPORT DEFINITION OF THE VIEW OR PROCEDURE OR FUNCTION
EXECUTE SP_RECOMPILE 'usp_Report_Employees'	-- TO FORCE RECOMPILATION OF SP DURING ITS NEXT EXECUTION

EXEC	SP_PKEYS	'TABLENAME'				-- TO REPORT PRIMARY KEY COLUMNS FOR THE TABLE
EXEC	SP_HELPINDEX 'TABLENAME'			-- TO REPORT LIST OF INDEXES FOR THE TABLE


-- IMPORTANT SYSTEM FUNCTIONS
SELECT GETDATE()			-- TO REPORT CURRENT DATE & TIME

SELECT DB_NAME()			-- TO REPORT CURRENTLY CONNECTED DATABASE NAME
SELECT DB_ID()				-- TO REPORT ID OF THE CURRENTLY CONNECTED DATABASE

SELECT OBJECT_ID('udf_Report_Employees')		-- TO REPORT ID OF THE GIVEN OBJECT
SELECT OBJECT_NAME(661577395)					-- TO REPORT NAME OF THE GIVEN OBJECT

SELECT SCHEMA_NAME()		-- TO REPORT CURRENT SCHEMA NAME (DEFAULT : DBO)

SELECT @@SERVERNAME			-- TO REPORT NAME OF THE CURRENTLY CONNECTED SERVER
SELECT @@VERSION			-- TO REPORT VERSION & EDITION OF THE CURRENTLY CONNECTED SERVER


