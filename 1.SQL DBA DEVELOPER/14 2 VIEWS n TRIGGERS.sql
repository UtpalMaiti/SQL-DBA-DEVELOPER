use [DB_OBJECTS] 
go

-- SCENARIO : YOU WERE GIVEN TWO TABLES. FLIGHT AND RESERVATIONS. YOU NEED TO INSERT DATA TOGETHER.
CREATE TABLE FLIGHT
(	CRAFT_CODE VARCHAR(30),
	SOURCE VARCHAR(30),
	DESTINATION VARCHAR(30)
)

CREATE TABLE RESERVATIONS
(	CRAFT_CODE VARCHAR(30),
	NO_OF_SEATS INT,
	CLASS VARCHAR(30)
)


-- REQ:   YOU NEED TO INSERT DATA INTO ABOVE TABLES TOGETHER.
CREATE VIEW VW_FLIGHT_RESERVATIONS
AS
SELECT 
R.CRAFT_CODE, R.NO_OF_SEATS, R.CLASS, 
F.SOURCE, F.DESTINATION 
FROM RESERVATIONS  AS R 
INNER JOIN 
FLIGHT  AS F 
ON R.CRAFT_CODE = F.CRAFT_CODE


SELECT * FROM VW_FLIGHT_RESERVATIONS

-- IN GENERAL, WHENEVER WE INSERT DATA INTO A VIEW IT GETS INSERTED INTO THE BASE TABLE.

-- BUT IF A VIEW IS BUILT ON MORE THAN ONE TABLE THEN INSERT STATEMENTS WILL NOT WORK DIRECTLY.
INSERT INTO VW_FLIGHT_RESERVATIONS VALUES ('EMI01', 11, 'ECO', 'CITY1', 'CITY2')  -- ERROR

-- SOLUTION: -- UPDATABLE VIEWS :   VIEWS DEFINED WITH TRIGGERS
CREATE TRIGGER TrigDataInsert
ON VW_FLIGHT_RESERVATIONS
INSTEAD OF INSERT 
AS
BEGIN
	DECLARE @CRAFT_CODE VARCHAR(30), @NO_OF_SEATS VARCHAR(30), @CLASS VARCHAR(30),
		    @SOURCE VARCHAR(30), @DESTINATION VARCHAR(30)
	
	SELECT @CRAFT_CODE = CRAFT_CODE FROM INSERTED;
	SELECT @NO_OF_SEATS = NO_OF_SEATS FROM INSERTED;
	SELECT @CLASS = CLASS FROM INSERTED;
	SELECT @SOURCE = SOURCE FROM INSERTED;
	SELECT @DESTINATION = DESTINATION FROM INSERTED;
	 
	INSERT INTO FLIGHT			VALUES (@CRAFT_CODE, @SOURCE,  @DESTINATION)
	INSERT INTO RESERVATIONS	VALUES (@CRAFT_CODE, @NO_OF_SEATS, @CLASS)
END 


-- HOW TO TEST ABOVE TRIGGER?
INSERT INTO VW_FLIGHT_RESERVATIONS VALUES ('EMI01', 11, 'ECO', 'CITY1', 'CITY2')	-- NO ERROR
INSERT INTO VW_FLIGHT_RESERVATIONS VALUES ('EMI02', 22, 'ECO', 'CITY2', 'CITY3')	-- NO ERROR

SELECT * FROM FLIGHT
SELECT * FROM RESERVATIONS



-- HOW TO ENSURE DYNAMIC DATA INSERTS?
-- SOLUTION : USING STORED PROCEDURES
CREATE PROCEDURE usp_insert_data 
@CRAFT_CODE VARCHAR(30), @NO_OF_SEATS VARCHAR(30), @CLASS VARCHAR(30), @SOURCE VARCHAR(30), @DESTINATION VARCHAR(30)
AS
	INSERT INTO VW_FLIGHT_RESERVATIONS VALUES (@CRAFT_CODE, @NO_OF_SEATS, @CLASS, @SOURCE, @DESTINATION)


-- PROCEDURE TO VIEW
	-- VIEW TO TRIGGER [UPDATABLE VIEW  =  VIEW DEFINED WITH A TRIGGER FOR DATA DISTRBUTION]
		-- TRIGGER TO BASE TABLES


EXECUTE usp_insert_data 'EMI03', 33, 'ECO', 'CITY3', 'CITY4'

EXECUTE usp_insert_data 'EMI04', 44, 'ECO', 'CITY4', 'CITY5'

SELECT * FROM FLIGHT
SELECT * FROM RESERVATIONS

-- STORED PROCEDURE TO VIEW			>>		VIEW TO TRIGGER				>>>	 TRIGGER TO ACTUAL TABLES. 



-- ALTERNATIVE TO ABOVE TRIGGER:
CREATE TRIGGER TrigDataInsert
ON VW_FLIGHT_RESERVATIONS
INSTEAD OF INSERT 
AS
BEGIN
	BEGIN TRY
	BEGIN TRANSACTION
	DECLARE @CRAFT_CODE VARCHAR(30), @NO_OF_SEATS VARCHAR(30), @CLASS VARCHAR(30)
		    @SOURCE VARCHAR(30), @DESTINATION VARCHAR(30)
	
	SELECT @CRAFT_CODE = CRAFT_CODE FROM INSERTED;
	SELECT @NO_OF_SEATS = NO_OF_SEATS FROM INSERTED;
	SELECT @CLASS = CLASS FROM INSERTED;
	SELECT @SOURCE = SOURCE FROM INSERTED;
	SELECT @DESTINATION = DESTINATION FROM INSERTED;
	 
	INSERT INTO FLIGHT			VALUES (@CRAFT_CODE, @SOURCE,  @DESTINATION)
	INSERT INTO RESERVATIONS	VALUES (@CRAFT_CODE, @NO_OF_SEATS, @CLASS)
	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
	ROLLBACK
	END CATCH
END 


EXECUTE usp_insert_data 'EMI05', 55, 'ECO', 'CITY4', 'CITY5'

SELECT * FROM FLIGHT
SELECT * FROM RESERVATIONS


-->		PARAMETERS	TO PROCEDURE   >>>  TO VIEW  >>  TO TRIGGER >>> TRANSACTION >>>  TRY..CATCH >>> BASE TABLES


-- TASK 1:  WRITE A QUERY TO REPORT LIST OF ALL RESERVATIONS FOR A GIVEN FLIGHT?
-- TASK 2:  WRITE A PROCEDURE TO REPORT LIST OF AL SUCH FLIGHTS WITH MORE THAN GIVEN COUNT OF RESERVATIONS?
-- TASK 3:  WRITE A PROCEDURE TO VALIDATE AND INSERT DATA INTO RESERVATIONS IN SUCH A WAY THE MINIMUM SEATS SHOULD BE 10
-- TASK 4:  WRITE A PROCEDURE TO VALIDATE AND INSERT DATA INTO FLIGHT TABLE IN SUCH A WAY SOURCE CITY AND DESTINATION CITY ARE DIFFERENT.










