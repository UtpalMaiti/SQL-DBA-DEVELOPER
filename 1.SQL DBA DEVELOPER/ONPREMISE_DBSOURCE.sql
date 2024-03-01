CREATE DATABASE TEST_ON_PREMDB
GO

USE TEST_ON_PREMDB

USE [AZUREBI]


CREATE TABLE EMP_INFO			
(
EMP_ID		INT PRIMARY KEY,	
EMP_FNAME	VARCHAR (30) UNIQUE,	 
EMP_CNTRY	CHAR(50), 
EMP_SAL		BIGINT		
)	

			
INSERT 	 EMP_INFO VALUES	(1001, 'AMIN',  'CANADA', 45678) ,	('1002', 'JOHN', 'CANADA', 643643)	
INSERT   EMP_INFO VALUES	(1003, 'SAI', 'INDIA', 36363),		(1004, 'SAISHA', 'INDIA',20000)		
INSERT   EMP_INFO VALUES	(1005, 'SAISH', 'INDIA', 43643),	(1006, 'ADAM', 'USA', NULL)   

SELECT * FROM EMP_INFO 
SELECT * FROM EMP_INFO WHERE EMP_CNTRY = 'CANADA'

CREATE VIEW VW_CANADA_EMP
AS
SELECT * FROM EMP_INFO WHERE EMP_CNTRY = 'CANADA'


CREATE PROCEDURE USP_EMP ( @COUNTRY VARCHAR(30) )
AS
SELECT * FROM EMP_INFO WHERE EMP_CNTRY = @COUNTRY

CREATE FUNCTION UDF_EMP ( @COUNTRY VARCHAR(30) )
RETURNS table												-- table IS A DATA TYPE
AS
RETURN (SELECT * FROM EMP_INFO WHERE EMP_CNTRY = @COUNTRY)

CREATE TRIGGER TRIG_ADD_OP
ON EMP_INFO
FOR INSERT 
AS
PRINT 'GIVEN OPERATION IS SUCCESSFUL'


CREATE INDEX INDX1 ON EMP_INFO (EMP_ID)
CREATE INDEX INDX2 ON EMP_INFO (EMP_CNTRY)

