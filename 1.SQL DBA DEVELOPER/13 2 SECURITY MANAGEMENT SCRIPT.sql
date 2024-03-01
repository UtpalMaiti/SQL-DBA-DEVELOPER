CREATE DATABASE PRODUCT_DATABASE
USE PRODUCT_DATABASE
CREATE TABLE PRODUCT_TABLE1 (PRODID INT, PRODINFO FLOAT)
CREATE TABLE PRODUCT_TABLE2 (PRODID INT, PRODINFO FLOAT)


CREATE DATABASE SALE_DATABASE
USE SALE_DATABASE
CREATE TABLE SALES_TABLE1 (SALEID INT, SALEINFO FLOAT)
CREATE TABLE SALES_TABLE2 (SALEID INT, SALEINFO FLOAT)


-- ITEM #1: HOW TO CREATE NEW LOGIN?				FOR SERVER LEVEL CONNECTION
USE MASTER 
CREATE LOGIN LOGINFORJOHN WITH PASSWORD = 'ADMIN#123$'
CREATE LOGIN LOGINFORSAM WITH PASSWORD = 'ADMIN#123$'  MUST_CHANGE, CHECK_POLICY=ON, CHECK_EXPIRATION = ON  -- 60 days


-- ITEM #2: HOW TO CREATE USERS FOR ABOVE LOGINS?	FOR DATABASE LEVEL CONNECTION
USE PRODUCT_DATABASE 
GO
CREATE USER JOHN_USER FOR LOGIN LOGINFORJOHN
CREATE USER SAM_USER FOR LOGIN LOGINFORSAM


USE SALE_DATABASE
GO
CREATE USER JOHNUSER FOR LOGIN LOGINFORJOHN
CREATE USER SAMUSER FOR LOGIN LOGINFORSAM


-- ITEM #3: HOW TO ASSIGN SERVER LEVEL PERMISSIONS FOR SAM LOGIN?
ALTER SERVER ROLE SYSADMIN ADD MEMBER LOGINFORSAM

-- ITEM #4: HOW TO ASSIGN DATABASE LEVEL PERMISSIONS FOR SAM USER?
ALTER ROLE DB_OWNER ADD MEMBER SAMUSER


-- ITEM #5: HOW TO ASSIGN OBJECT LEVEL PERMISSIONS FOR SAM USER?
GRANT SELECT ON SALES_TABLE1 TO JOHNUSER
GRANT CONTROL ON SALES_TABLE1 TO JOHNUSER	-- DDL + DML + SELECT
GRANT TAKE OWNERSHIP ON SALES_TABLE1 TO JOHNUSER WITH GRANT OPTION -- PREVILIGE TO PROVIDE SAME PERMISSION TO OTHER USERS


-- ITEM #6: HOW TO ASSIGN COLUMN LEVEL PERMISSIONS FOR SAM USER?
GRANT SELECT ON SALES_TABLE1(SALEID) TO JOHNUSER


-- ITEM #7: HOW TO ASSIGN SCHEMA LEVEL PERMISSIONS FOR SAM USER?					GROUP OF OBJECTS
GRANT EXECUTE ON SCHEMA::DBO  TO JOHNUSER


-- ITEM #8: HOW TO ASSIGN OBJECT LEVEL PERMISSIONS FOR A GROUP OF USERS?			GROUP OF USERS
CREATE ROLE ROLE_FOR_COMMONPERMISSIONS

ALTER ROLE ROLE_FOR_COMMONPERMISSIONS ADD MEMBER JOHNUSER
ALTER ROLE ROLE_FOR_COMMONPERMISSIONS ADD MEMBER SAMUSER

GRANT SELECT ON SALES_TABLE1 TO ROLE_FOR_COMMONPERMISSIONS
DENY INSERT ON SALES_TABLE2 TO ROLE_FOR_COMMONPERMISSIONS





-- ITEM #9: SECURITY AUDITS
	SELECT * FROM SYSLOGINS						-- REPORTS LOGINS
	SELECT * FROM SYS.server_principals   		-- REPORTS LOGINS & SERVER ROLES
	
	SELECT * FROM SYSUSERS						-- REPORTS USERS
	SELECT * FROM SYS.database_principals 		-- REPORTS USERS & DATABASE ROLES

	SELECT * FROM SYS.DATABASE_PERMISSIONS


-- HOW TO FIND THE LIST OF PERMISSIONS FOR A GIVEN DATABASE USER?
SELECT * FROM SYS.DATABASE_PERMISSIONS AS A
INNER JOIN													-- TO REPORT MATCHING DATA
SYS.database_principals  AS B
ON
A.grantee_principal_id = B.principal_id
WHERE NAME = 'JOHNUSER'


-- HOW TO FIND ORPHAN USERS [USERS WITHOUT LOGINS]?		SUCH USERS WHOSE LOGIN IS MISSING. MEANS, USERS WITHOUT LOGINS.
SELECT dp.type_desc, dp.SID, dp.name AS user_name  
FROM [SALE_DATABASE].sys.database_principals AS dp  
LEFT OUTER JOIN sys.server_principals AS sp					-- TO REPORT MATCHING AND MISSING DATA
ON dp.SID = sp.SID  
WHERE sp.SID IS NULL  AND authentication_type_desc = 'INSTANCE';




USE PRODUCT_DATABASE

-- ITEM #10: HOW TO DEFINE DATA LEVEL SECURITY?									DATA ENCRYPTION
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Pass@word1'
CREATE CERTIFICATE CERT_ENCR WITH SUBJECT = 'CERTIFICATE FOR DATA ENCRYPTION'


-- How to use above certificates and store passwords in sql server ?
CREATE TABLE person (userid varchar(30), pass nvarchar(max))


CREATE PROC USP_ENCRYPTPASSWORDS (@user varchar(30), @pass varchar(18))
AS
	INSERT INTO person VALUES ( @user, ENCRYPTBYCERT(CERT_ID('CERT_ENCR'), @pass))

	
EXEC USP_ENCRYPTPASSWORDS 'USER01', 'PASS@1'
EXEC USP_ENCRYPTPASSWORDS 'USER02', 'PASS@2'

SELECT * FROM person								-- DECRYPTBYCERT()


-- NEXT:
-- DATABASE MIGRATIONS
		-- STEP 1:	FROM SOURCE	SERVER	:	ESTABLISH DOWNTIME, PERFORM DB BACKUP
											EXPORT THE LOGINS TO AN RPT FILE

		-- STEP 2:	FROM DESTINATION	:	CREATE A CREDENTIAL
											CREATE A PROXY USING ABOVE CREDENTIAL
											MAP THIS PROXY TO SSIS JOB SUBSYSTEM

		-- STEP 3:	FROM SOURCE	SERVER	:	LAUNCH COPY DATABASE WIZARD [CDW]
											IT DOES COLD BACKUP, MIGRATE THE DB
											TRANSFER LOGINS
											SCHEDULE DB MIGRATION JOB  [ONTIME]

		--STEP 4:	FROM DESTINATION	:	PERFORM HEALTH CHECK  [DBCC]
											IDENTIFY ORPHAN USERS, IF ANY
											RESOLVE LOGINS FOR ORPHAN USERS
											 	
