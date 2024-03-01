
USE [DB_OBJECTS] 

create table Reservation1
(
Aircraft_Code varchar(10), 
No_of_Seats int, 
Class_Code varchar(10)
)

create table Reservation2
(
Aircraft_Code varchar(10), 
No_of_Seats int, 
Class_Code varchar(10)
)

-- REQ 1:	WHENEVER WE INSERT DATA INTO 1ST TABLE, SAME DATA SHOULD BE AUTO INSERTED TO 2ND TABLE?
CREATE OR ALTER TRIGGER trigAddOp
ON Reservation1
FOR								-- IN ADDITION TO
INSERT 
AS
INSERT INTO Reservation2 SELECT * FROM INSERTED ;
SELECT * FROM INSERTED;
SELECT * FROM deleted;


SELECT * FROM Reservation1
SELECT * FROM Reservation2

INSERT INTO Reservation1 VALUES ('AI101', 21, 'ECO')
INSERT INTO Reservation1 VALUES ('AI102', 22, 'ECO')	

SELECT * FROM Reservation1
SELECT * FROM Reservation2



-- REQ 2:	RESERVATIONS ONCE APPROVED CANNOT BE MODIFIED / CANCELLED.  [MEANS: MAKE YOUR TABLE AS READ ONLY]?
CREATE or ALTER TRIGGER trigAltOp
ON Reservation1
INSTEAD OF							-- IN PLACE OF
UPDATE, DELETE 
AS
PRINT 'MODIFICATIONS ARE NOT PERMITTED ON THE TABLE. CONTACT YOUR ADMIN.';
SELECT * FROM INSERTED;
SELECT * FROM deleted;


DELETE FROM Reservation1
SELECT * FROM Reservation1				-- 2 ROWS

ROLLBACK


-- HOW TO DISABLE A TRIGGER?						-- ONLY DB ADMINS CAN PERFORM THIS OPERATIONS
DISABLE TRIGGER trigAltOp ON Reservation1

DELETE FROM Reservation1
SELECT * FROM Reservation1				-- 0 ROWS


-- HOW TO ENABLE A TRIGGER?						-- ONLY DB ADMINS CAN PERFORM THIS OPERATIONS
ENABLE TRIGGER trigAltOp ON Reservation1



-- TO AUDIT THE TRIGGERS IN A DATABASE:
SELECT * FROM SYS.TRIGGERS 

DROP TRIGGER trigAltOp


-- ANY DATABASE OBJECT THAT CAN BE CREATED WITH "ON" KEYWORD BEFORE THE TABLE NAME CAN BE DISABLED.
-- WHAT ARE THE DATABASE OBJECTS CAN BE BE DISABLED?

-- JOINS ARE A MECHANISM TO COMPARE & REPORT DATA.  THEY ARE NOT OBJECTS. 

EXEC SP_DEPENDS 'Reservation1'

CREATE VIEW VW_TEST AS SELECT * FROM Reservation1

CREATE PROC USPTEST AS SELECT * FROM Reservation1

EXEC SP_DEPENDS 'Reservation1'

-- CAUTION 1	:	 WHENEVER WE RENAME THE TABLE, THE DEPENDANT OBJECTS SHOULD ALSO BE MODIFIFED WITH NEW NAME
-- CAUTION 2	:	 WHENEVER WE DROP THE TABLE, THE DEPENDANT OBJECTS BECOME "ORPHAN"



-- ITEM 1:	EXAMPLES FOR AUTOCOMMIT TRANSACTIONS. means AUTO SAVE.  UNCONDITIONAL COMMITS. 
INSERT INTO Reservation1 VALUES ('AI101', 21, 'ECO')
INSERT INTO Reservation1 VALUES ('AI102', 22, 'ECO')	
		
-- ITEM 2:	EXAMPLES FOR EXPLICIT TRANSACTIONS  : USED FOR CONDITIONAL COMMITS.
BEGIN TRANSACTION T1
INSERT INTO Reservation1 VALUES ('AI103', 21, 'ECO')
INSERT INTO Reservation1 VALUES ('AI104', 22, 'ECO')
IF @@ERROR = 0		-- THIS "GLOBAL VARIABLE" (PREDEFINED VARIABLE) REPORTS ERROR NUMBER OF PREVIOUS STATEMENT
COMMIT				-- To SAVE the above two rows in the table	[CTRL + S]
ELSE			
ROLLBACK			-- To UNDO the save of above two rows		[CTRL + Z]

-- ITEM #3: 	EXAMPLE FOR IMPLICIT TRANSACTIONS
SET IMPLICIT_TRANSACTIONS ON	-- TO ENABLE IMPLICIT TRANSACTIONS. START TRANSACTION AUTOMATICALLY	
INSERT INTO Reservation1 VALUES ('AI105', 21, 'ECO')
INSERT INTO Reservation1 VALUES ('AI106', 23, 'ECO')
IF @@ERROR = 0	
COMMIT
ELSE			
ROLLBACK

SET IMPLICIT_TRANSACTIONS OFF	-- TO DISABLE IMPLICIT TRANSACTIONS. This is a session level setting.


TRUNCATE TABLE Reservation1
SELECT * FROM Reservation1			-- 0 ROWS

INSERT INTO Reservation1 VALUES ('EMI1', 21, 'ECO')			-- TRANSACTION 1
INSERT INTO Reservation1 VALUES ('EMI2', 22, 'ECO')			-- TRANSACTION 2
INSERT INTO Reservation1 VALUES ('EMI3', 21, 'ECO')			-- TRANSACTION 3
INSERT INTO Reservation1 VALUES ('EMI4', 22, 'ECO')			-- TRANSACTION 4

SELECT * FROM Reservation1			-- 4 ROWS


-- ITEM #4: OPEN TRANSACTIONS : TRANSACTIONS WHICH ARE STARTED BUT NOT COMMITTED NOR ROLLEDBACK.  
-- IMPACT OF OPEN TRANSACTIONS : QUERY BLOCKING. MEANS, THE QUERY FOR OTHER SESSIONS RUN FOREVER.
BEGIN TRANSACTION T1
INSERT INTO Reservation1 VALUES ('EMI5', 21, 'ECO')
INSERT INTO Reservation1 VALUES ('EMI6', 22, 'ECO')

/*
GO TO FILE > NEW > QUERY IN CURRENT CONNECTION > THEN PASTE BELOW QUERY : 
SELECT * FROM Reservation1			-- WE OBSERVE QUERY BLOCKING. MEANS, QUERY RUNS FOREVER.

-- SOLUTION TO AVOID QUERY BLOCKING : USE "LOCK HINTS"		:		NOLOCK   &	READPAST

SELECT * FROM Reservation1			-- QUERY BLOCKING. MEANS : THE QUERY RUNS FOREVER.

SELECT * FROM Reservation1 WITH (NOLOCK)		-- NO QUERY BLOCKING BUT DIRTY READS. UNCOMMITED READS
SELECT * FROM Reservation1 WITH (READPAST)		-- NO QUERY BLOCKING AND NO DIRTY READS. COMMITED READS  **

*/


-- HOW TO RESOLVE QUERY BLOCKING?
COMMIT 


