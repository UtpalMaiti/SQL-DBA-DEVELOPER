-- PHASE 3: PROGRAMMING:  TO AUTOMATE THE VALIDATION AND INSERT DATA INTO TABLES.

/*
PHASE 3  OF THE BANKING PROJECT FOR SQL SERVER T-SQL DEVELOPERS (T-SQL PLAN A, B,C, D):	 
				HOW TO INSERT DATA INTO ABOVE TABLES WITH BELOW CONDITIONS :
								* CONDITIONAL & DYNAMIC
								* AUTOMATED TRANSACTION BEHAVIOUR USING TRIGGERS		

				ESTIMATED TIME : 25 - 30 HOURS

				CLUE:
					WE CANNOT INSERT DATA INTO A VIEW IF THE VIEW IS BUILT ON MULTIPLE BASE TABLES.
					SOLUTION :  CREATE VIEW TO INCLUDE A JOIN OF RELEVANT QUERIES
								THEN DEFINE A TRIGGER ON THE VIEW
								THEN DEFINE A STORED PROCEDURE TO INSERT DATA INTO THE VIEW.																																	9 PM TO 12 AM
									
				PLEASE MAIL ME YOUR SOLUTION FOR ATLEAST FIRST 5 TABLES.  */		
								 

use Bankingdb
go

IF EXISTS (SELECT * FROM SYS.objects WHERE name='vwBankDetails')
   DROP VIEW vwBankDetails
GO

CREATE  VIEW vwBankDetails
AS
SELECT A.bankDetails AS [Bank Name]
FROM  dbo.synBank A (READPAST)

GO

INSERT INTO vwBankDetails VALUES ('HDFC')
GO

SELECT * FROM synBank

/*
This view has been designed to ADD a brand new branch to Bank 
To help in insertion also designed the INSTEAD OFF TRIGGER.

*/
IF EXISTS (SELECT * FROM SYS.objects WHERE name='vwBranchDetails')
   DROP VIEW vwBranchDetails
GO


CREATE VIEW vwBranchDetails
AS
SELECT A.bankDetails AS [Bank Name],B.brBranchName AS [Branch Name],
B.brBranchIFSC AS [IFSC],
B.brBranchPhone1 AS [Phone 1],B.brBranchPhone2 AS [Phone 2],B.brBranchFax AS [Fax],
B.brBranchemail AS [Email],
C.btTypeCode AS [Branch Type Code],C.btTypeDesc AS [Branch Type],D.addLine1 AS [Address 1],
D.addLine2 AS [Address 2],D.addCity AS [City],D.addState AS [State],D.addCountry AS [Country],
D.addPostCode AS [Post Code]
FROM  dbo.synBank A (READPAST)
INNER JOIN dbo.synBranch B (READPAST)ON A.bankId=B.brBankId_fk
INNER JOIN dbo.synBranchType C (READPAST) ON B.brBranchTypeCode_fk=C.btId
INNER JOIN dbo.synAddress D (READPAST) ON B.brAddress_fk=D.addId

GO

CREATE TRIGGER TRIGGER_vwBranchDetails
ON vwBranchDetails
INSTEAD OF INSERT
AS
BEGIN
BEGIN TRANSACTION T1
	BEGIN TRY
		--INSERT ADDRESS
		INSERT INTO dbo.synAddress  ( addLine1 ,  addLine2 , addCity , addPostCode , addState , addCountry  )
		SELECT [Address 1],[Address 2],[City],[Post Code],[State],[Country] FROM INSERTED

		--Get Address ID inserted above
		DECLARE @ADDRESSID BIGINT
		SET @ADDRESSID=@@IDENTITY
    END TRY 
	BEGIN CATCH 
		BEGIN
				SELECT 'Branch Address Insertion Failed due to data issue.Check Input values'
				ROLLBACK TRANSACTION  --If Insertion fails rollback
		END
	END CATCH


	BEGIN TRANSACTION T2
    BEGIN TRY
		BEGIN
				--INSERT Branch Type
				INSERT INTO dbo.synBranchType  ( btTypeCode, btTypeDesc )
				SELECT [Branch Type Code],[Branch Name] FROM INSERTED

				--Get Branch ID inserted above
				DECLARE @BranchTypeID BIGINT
				SET @BranchTypeID=@@IDENTITY
		END
	END TRY 
	BEGIN CATCH
		BEGIN
				SELECT 'Branch Type Insertion Failed due to data issue.Check Input Values'
				ROLLBACK TRANSACTION  --If Insertion fails, rollback
		END
	END CATCH

	

	BEGIN TRANSACTION T3
	BEGIN TRY 
		DECLARE @BankID BIGINT
		SET @BankID=(SELECT TOP 1 bankId FROM dbo.synBank WHERE bankDetails IN (SELECT [Bank Name] FROM Inserted))

		--Insert Branch
		INSERT INTO dbo.synBranch  ( brBankId_fk ,  brAddress_fk , brBranchTypeCode_fk , brBranchName ,  brBranchPhone1 ,  brBranchPhone2 ,  brBranchFax , brBranchemail ,  brBranchIFSC) 
		SELECT @BankID,@ADDRESSID,@BranchTypeID,[Branch Name],[Phone 1],[Phone 2],Fax,Email,IFSC FROM INSERTED

		IF @@TRANCOUNT > 0				-- TO REPORT THE NUMBER OF OPEN TRANSACTIONS
			COMMIT TRANSACTION T1
		IF @@TRANCOUNT > 0
			COMMIT TRANSACTION T2
		IF @@TRANCOUNT > 0
			COMMIT TRANSACTION T3
    END TRY
	BEGIN CATCH
		BEGIN
				SELECT 'Branch details Insertion Failed due to data issue.Check Input values'
				ROLLBACK TRANSACTION	-- If Insertion fails rollback
				;THROW					-- TO REPORT THE REASON FOR ERROR. ACTUAL ERROR MESSAGE. 
		END
	END CATCH

END

GO

--INSERT DATA TO VIEW
INSERT INTO vwBranchDetails VALUES ('State Bank of Mysore','Mangalore Corporation','SBM0405','0824 247561','0824 247562','0824 247563','manglorecorporation@sbm.com','MT','Mortgage','KS Rao road','Opp Passport Seva Kendra, Balmatta','Mangalore','Karnataka','India','576001')
GO

INSERT INTO vwBranchDetails VALUES ('State Bank of Mysore2','Mangalore Corporation2','SBM0406','0824 247561','0824 247562','0824 247563','manglorecorporation@sbm.com','MT','Mortgage','KS Rao road','Opp Passport Seva Kendra, Balmatta','Mangalore','Karnataka','India','576001')

GO


--Check Insertion
SELECT * FROM dbo.vwBranchDetails

SELECT * FROM BANK.tblBank						-- NO CHANGE. DATA ALREADY EXISTS
SELECT * FROM BANK.tblbtBranchType				-- VERIFY THE DATA INSERT FROM ABOVE.


 
/*
Created stored Procedure to help in insertion of Branch to a Bank through UI [.NET, JAVA, PERL, HTML, PYTHON, R ......]
*/

IF EXISTS (SELECT * FROM SYS.objects WHERE name='spInsertBranchDetails')
   DROP PROCEDURE spInsertBranchDetails
GO

/* 
 ///////////////////////////////////////////////////////////////////////////////////////////
 *       
 *   File Name              :  spInsertBranchDetails
 *   Project Title          :  Banking
 *   Author(s)              :  SQL School
 *   Purpose                :  Procedure to insert bank BRanch and its details.
 *   Date Created           :  28/October/2019
 *
 *   MODIFICATION HISTORY   :  
 *   Purpose                :  
 *   Date Modified          :          
 *   Author                 :    
 * ///////////////////////////////////////////////////////////////////////////////////////////

 */

CREATE PROCEDURE spInsertBranchDetails
(
@BankName VARCHAR(50),@BranchName VARCHAR(100),@IFSC VARCHAR(20),
@Phone1 VARCHAR(20) ,@Phone2 VARCHAR(20) ,@Fax VARCHAR(20)  ,@Email VARCHAR(50)  ,
@BranchTypeCode VARCHAR(10) ,@BranchTypeDesc VARCHAR(100),
@AddLine1 VARCHAR(100) ,@AddLine2 VARCHAR(50) ,
@City VARCHAR(50),@State VARCHAR(50) ,@Country VARCHAR(50),@PostCode VARCHAR(15) 
)
AS
BEGIN
--Insert the Data through view which contains trigger
INSERT INTO vwBranchDetails VALUES 
(@BankName,@BranchName ,@IFSC ,
@Phone1 ,@Phone2 ,@Fax,@Email  ,
@BranchTypeCode ,@BranchTypeDesc ,@AddLine1  ,@AddLine2  ,
@City ,@State  ,@Country ,@PostCode)
END



/*
--Check Insert through SP
EXEC spInsertBranchDetails @BankName='State Bank of Mysore',@BranchName='Bangalore Corporation',@IFSC='SBM0406',@Phone1='080 247561',@Phone2='080 247562',@Fax='080 247563',
@Email='banglorecorporation@sbm.com',@BranchTypeCode='HL',@BranchTypeDesc='Home Loan',@AddLine1='Rajkumar road',@AddLine2='57th Main, Malleshwaram',@City='Bangalore',@State='Karnataka',@Country='India',@PostCode='574001'

--For Failure due to truncation of Branch Type code
EXEC spInsertBranchDetails @BankName='State Bank of Mysore',@BranchName='Bangalore Corporation',@IFSC='SBM0406',@Phone1='080 247561',@Phone2='080 247562',@Fax='080 247563',
@Email='banglorecorporation@sbm.com',@BranchTypeCode='HLIDQS',@BranchTypeDesc='Home Loan',@AddLine1='Rajkumar road',@AddLine2='57th Main, Malleshwaram',@City='Bangalore',@State='Karnataka',@Country='India',@PostCode='574001'

--Check Insertion
SELECT * FROM vwBranchDetails

*/

/*
This view has been designed to view Customer Details

*/
IF EXISTS (SELECT * FROM SYS.objects WHERE name='vwCustomerDetails')
   DROP VIEW vwCustomerDetails
GO

--IF NOT EXISTS (SELECT * FROM SYS.objects WHERE name='vwCustomerDetails')
--BEGIN

--CREATE VIEW vwCustomerDetails WITH SCHEMABINDING
--AS
--SELECT cstFirstName AS [First Name],	
--cstLastName AS [Last Name],	CstMiddleName AS [Middle Name],	cstDOB AS [DOB],
--cstSince AS [Customer Since],cstPhone1 AS [Phone 1],cstPhone2 AS [Phone 2],
--	cstFax AS [FAX],cstGender AS [Gender],cstemail AS [Email],
--D.addLine1 AS [Address 1],D.addLine2 AS [Address 2],D.addCity AS [City],
--D.addState AS [State],D.addCountry AS [Country],D.addPostCode AS [Post Code]	
--FROM BANK.tblcstCustomer C (READPAST)
--INNER JOIN BANK.tbladdAddress D (READPAST) ON C.cstAddId_fk=D.addId
--INNER JOIN BANK.tblbrBranch B (READPAST)  ON C.cstBranchId_fk=B.brID

--END

GO

/*
--View the details
 SELECT * FROM vwCustomerDetails
*/

/*
Created stored Procedure to help in insertion of Branch to a Bank through UI
*/

IF EXISTS (SELECT * FROM SYS.objects WHERE name='spInsertCustomer')
   DROP PROCEDURE spInsertCustomer
GO

/* 
 ///////////////////////////////////////////////////////////////////////////////////////////
 *       
 *   File Name              :  spInsertCustomer
 *   Project Title          :  Banking
 *   Author(s)              :  SQL School
 *   Purpose                :  Procedure to insert bank customer to a Branch.
 *   Date Created           :  28/October/2018
 *
 *   MODIFICATION HISTORY   :  
 *   Purpose                :  
 *   Date Modified          :          
 *   Author                 :    
 * ///////////////////////////////////////////////////////////////////////////////////////////

 */

CREATE PROCEDURE spInsertCustomer
(
 @BranchName VARCHAR(100),@FirstName VARCHAR(50),@LastName VARCHAR(50),@MiddleName VARCHAR(50),
 @DOB DATE,@CustomerSince DATETIME,@Phone1 VARCHAR(20) ,@Phone2 VARCHAR(20) ,@Fax VARCHAR(20),
 @Gender VARCHAR(20),@Email VARCHAR(50)
,@AddLine1 VARCHAR(100) ,@AddLine2 VARCHAR(50) ,@City VARCHAR(50),@State VARCHAR(50) ,
@Country VARCHAR(50),@PostCode VARCHAR(50) 
)
AS
BEGIN
		BEGIN TRANSACTION 
		BEGIN TRY
				--Get BRanch ID inserted above
				DECLARE @BranchTypeID BIGINT
				SET @BranchTypeID=@@IDENTITY
				--INSERT ADDRESS
				INSERT INTO dbo.synAddress  ( addLine1 ,  addLine2 , addCity , addPostCode , addState , addCountry  ) VALUES (@AddLine1,@AddLine2,@City,@PostCode,@State,@Country)
				--Get Address ID inserted above
				DECLARE @ADDRESSID BIGINT
				SET @ADDRESSID=@@IDENTITY				-- THIS REPORTS THE LATEST IDENTITY VALUE
		END TRY
		BEGIN CATCH
				SELECT 'Customer Address Insertion Failed due to data issue.Check Input values'
				ROLLBACK TRANSACTION					--If Insertion fails rollback
		END CATCH

		BEGIN TRY

			DECLARE @BRANCHID BIGINT
			SET @BRANCHID=(
							SELECT TOP 1 brID FROM dbo.synBRANCH 
							WHERE  brBranchName IN (@BranchName)
						  )

			--Insert Customer
			 INSERT INTO dbo.synCustomer  ( cstAddId_fk , cstBranchId_fk , 
			 cstFirstName , cstLastName ,  CstMiddleName ,  cstDOB ,  cstSince ,  
			 cstPhone1 ,  cstPhone2 , cstFax ,  cstGender ,  cstemail )
			 VALUES   
			 (@ADDRESSID,@BRANCHID, @FirstName ,@LastName ,@MiddleName ,@DOB ,
			 @CustomerSince ,@Phone1  ,@Phone2  ,@Fax,@Gender,@Email)

			IF @@TRANCOUNT > 0
		    COMMIT TRANSACTION

		END TRY
		BEGIN CATCH
				SELECT 'Customer details Insertion Failed due to data issue.Check Input values'
				ROLLBACK TRANSACTION  --If Insertion fails rollback
				;THROW
		END CATCH

END



/*
--Check Insert through SP
EXEC spInsertCustomer @BranchName='Golden Valley',@FirstName='Tom',@LastName='Keen',@MiddleName='Ruth',@DOB='09-11-1985',@CustomerSince=NULL,@Phone1='080 247561',@Phone2='080 247562',@Fax='080 247563',@Gender='Male'
,@Email='Tkeen@hotmail.com',@AddLine1='GV road',@AddLine2='57th BLVD',@City='Crystal',@State='Minnesota',@Country='USA',@PostCode='574001'

--For Failure due to invalid  inputdata for customer Details
EXEC spInsertCustomer @BranchName='Golden Valley',@FirstName='Tom',@LastName='Keen',@MiddleName='Ruth',@DOB='09-11-1985',@CustomerSince=NULL,@Phone1='080 247561',@Phone2='080 247562',@Fax='080 247563',@Gender='Male85098609870965'
,@Email='Tkeen@hotmail.com',@AddLine1='GV road',@AddLine2='57th BLVD',@City='Crystal',@State='Minnesota',@Country='USA',@PostCode='574001'

--For Failure due to invalid  inputdata for customer Address Details
EXEC spInsertCustomer @BranchName='Golden Valley',@FirstName='Tom',@LastName='Keen',@MiddleName='Ruth',@DOB='09-11-1985',@CustomerSince=NULL,@Phone1='080 247561',@Phone2='080 247562',@Fax='080 247563',@Gender='Male'
,@Email='Tkeen@hotmail.com',@AddLine1='GV road',@AddLine2='57th BLVD',@City='Crystal',@State='Minnesota',@Country='USA',@PostCode='57400147690965876878657-50687005985907'

*/

/*
This view has been designed to view Account Details of customer

*/
IF EXISTS (SELECT * FROM SYS.objects WHERE name='vwCustomerAccountDetails')
   DROP VIEW vwCustomerAccountDetails
GO

--CREATE VIEW vwCustomerAccountDetails
--WITH SCHEMABINDING
--AS
--SELECT cstId AS [Customer Id],cstFirstName AS [First Name],	
--cstLastName AS [Last Name],	CstMiddleName AS [Middle Name],	
--cstDOB AS [DOB],cstSince AS [Customer Since],cstPhone1 AS [Phone 1],
--cstPhone2 AS [Phone 2],	cstFax AS [FAX],cstGender AS [Gender],cstemail AS [Email],
--E.addLine1 AS [Address 1],E.addLine2 AS [Address 2],E.addCity AS [City],
--E.addState AS [State],E.addCountry AS [Country],E.addPostCode AS [Post Code],
--D.accNumber AS [Account Number],D.accBalance AS [Account Balance],
--B.accStatusDesc AS [Account Status],A.accTypeDesc AS [Account Type]
--FROM BANK.tblcstCustomer C (READPAST)
--INNER JOIN ACCOUNT.tblaccAccount D (READPAST) ON C.cstId=D.accCustomerId_fk
--INNER JOIN ACCOUNT.tblaccAccountStatus B (READPAST)  ON D.accStatusCode_fk=B.accStatusId
--INNER JOIN ACCOUNT.tblaccAccountType  A (READPAST)  ON D.accTypeCode_fk=A.accTypeId
--INNER JOIN BANK.tbladdAddress E (READPAST) ON C.cstAddId_fk=E.addId
--GO

/*
--View the details
 SELECT * FROM vwCustomerAccountDetails

*/

/*
Created stored Procedure to help creation of customer Account. Assuming in UI first a customer record will be created and then selecting the Customer they create the account.
Customer ID coulmn in above view can be used in Front end to pass the value of selected customer. Also account status and Type will be selected.
*/

IF EXISTS (SELECT * FROM SYS.objects WHERE name='spCreateAccount')
   DROP PROCEDURE spCreateAccount
GO

/* 
 ///////////////////////////////////////////////////////////////////////////////////////////
 *       
 *   File Name              :  spCreateAccount
 *   Project Title          :  Banking
 *   Author(s)              :  SQL School
 *   Purpose                :  Procedure to create account to Customer selected by Rep.
 *   Date Created           :  28/October/2018
 *
 *   MODIFICATION HISTORY   :  
 *   Purpose                :  
 *   Date Modified          :          
 *   Author                 :    
 * ///////////////////////////////////////////////////////////////////////////////////////////

 */

CREATE PROCEDURE spCreateAccount
(
 @CustomerID BIGINT,@accStatus VARCHAR(50),@accType VARCHAR(100),@OpeningBalance DECIMAL(26,4)
)
AS
BEGIN
		SET NOCOUNT ON

		DECLARE @AccStatusID BIGINT
		DECLARE @AccTypeId BIGINT
		DECLARE @InsCustomerID BIGINT

		select @InsCustomerID = cstId from dbo.synCustomer (READPAST)
		where cstId = @CustomerID
		
		SELECT @AccStatusID=accStatusId FROM dbo.synAccountStatus (READPAST) 
		WHERE accStatusDesc=@accStatus

		SELECT @AccTypeId=accTypeId FROM dbo.synAccountType (READPAST) 
		WHERE accTypeDesc=@accType

		BEGIN TRANSACTION 
		BEGIN TRY

				--INSERT ADDRESS
				INSERT INTO dbo.synAccount  ( accStatusCode_fk , accTypeCode_fk , accCustomerId_fk , accBalance )
				VALUES (@AccStatusID,@AccTypeId,@CustomerID,@OpeningBalance)

				COMMIT TRANSACTION

		END TRY
		BEGIN CATCH
				SELECT 'Account creation Failed.Check Input values'
				ROLLBACK TRANSACTION  --If Insertion fails rollback
		END CATCH

END







/*
DECLARE @CustomerId BIGINT
SET @CustomerId=(SELECT TOP 1 cstid FROM syncustomer (READPAST))
EXEC spCreateAccount @CustomerId, @accStatus='Active',@accType='Current',@OpeningBalance=1000

SELECT * FROM vwCustomerAccountDetails

*/


 
IF EXISTS (SELECT * FROM SYS.objects WHERE name='vwAccountTransactions')
   DROP VIEW vwAccountTransactions
GO

--CREATE VIEW vwAccountTransactions
--AS
--	SELECT [Account number],[Transaction Description],[Transaction Date],[Transaction Reference],
--	ISNULL([Deposit],0) AS [Credit],ISNULL([Withdrawal],0) AS [Debit],RunningBalance
--	FROM 
--	(
--		SELECT  D.accNumber AS [Account number],T.tranDescription AS [Transaction Description],
--		T.tranDatetime AS [Transaction Date],T.tranCode AS [Transaction Reference],TP.tranTypeDesc AS [Transaction Type],
--		T.tranTransactionAmount AS [Amount],T.RunningBalance
--		FROM dbo.synAccount D (READPAST)  
--		INNER JOIN dbo.synTransaction T (READPAST) ON D.accNumber=T.tranAccountNumber_fk
--		INNER JOIN dbo.synTransactionType TP (READPAST) ON T.tranCode_fk=TP.tranCodeID
--	) AS Summary
--	PIVOT
--	(
--	MIN([Amount])
--	FOR [Transaction Type] IN ([Deposit] ,[Withdrawal])
--	) AS P

--GO

/*
--View the details
 SELECT * FROM  vwAccountTransactions
*/

 /*
 CREATE FOR Trigger to update the Account Balance in accounts table and also update the running balnce in Transaction table.
 
 */
IF EXISTS (SELECT * FROM SYS.objects WHERE name='TRIGGER_UpdateAccountBalance')
  DROP TRIGGER [TRANSACTIONS].[TRIGGER_UpdateAccountBalance]
GO
 

CREATE TRIGGER TRIGGER_UpdateAccountBalance 
ON TRANSACTIONS.tbltranTransaction
FOR  INSERT
AS
BEGIN
    DECLARE @AMOUNT DECIMAL (26,4),@AccNumber BIGINT,@TranType BIGINT
	SELECT @AccNumber=tranAccountNumber_fk, @AMOUNT=tranTransactionAmount,@TranType=tranCode_fk FROM Inserted

	--Update the account balance in account table based on Transaction Type
	IF @TranType=1000 
		UPDATE ACCOUNt.tblaccAccount SET accBalance=accBalance + @AMOUNT 
		WHERE accNumber IN (SELECT tranAccountNumber_fk FROM Inserted)
	ELSE 
		UPDATE ACCOUNt.tblaccAccount SET accBalance=accBalance - @AMOUNT WHERE accNumber 
		IN (SELECT tranAccountNumber_fk FROM Inserted)

	--UPdate the running Balance in Transactions table

	UPDATE T SET RunningBalance=accBalance 
	FROM dbo.synTransaction T 
	INNER JOIN Inserted I ON T.tranID=I.tranID
	INNER JOIN dbo.synAccount A ON I.tranAccountNumber_fk=A.accNumber
END

/*
Created stored Procedure to help in performing a transaction.Account number and type of transaction are the main required fields.
*/

IF EXISTS (SELECT * FROM SYS.objects WHERE name='spPerformTrnasaction')
   DROP PROCEDURE spPerformTrnasaction
GO

/* 
 ///////////////////////////////////////////////////////////////////////////////////////////
 *       
 *   File Name              :  spPerformTrnasaction
 *   Project Title          :  Banking
 *   Author(s)              :  SQL School
 *   Purpose                :  Procedure to perform the transaction selected by user.
 *   Date Created           :  28/October/2018
 *
 *   MODIFICATION HISTORY   :  
 *   Purpose                :  
 *   Date Modified          :          
 *   Author                 :    
 * ///////////////////////////////////////////////////////////////////////////////////////////

 */

--CREATE PROCEDURE spPerformTrnasaction
--(
-- @AccountNumber BIGINT, @TransactionType VARCHAR(50),@Amount DECIMAL(26,4),@Merchant VARCHAR(50)=NULL,@Description VARCHAR(50)=NULL
--)
--AS
--BEGIN
--		SET NOCOUNT ON

--		DECLARE @TranCode BIGINT
--		SELECT @TranCode=tranCodeID FROM dbo.synTransactionType (READPAST) WHERE tranTypeDesc=@TransactionType

--		DECLARE @AccountBalance  DECIMAL(26,4)
--		SELECT @AccountBalance=accBalance FROM dbo.synAccount (READPAST) WHERE accNumber=@AccountNumber

--		IF 
--(( @TransactionType='Withdrawal' AND (@Amount < @AccountBalance )) OR @TransactionType='Deposit')
--			BEGIN 
--							BEGIN TRANSACTION 
--							BEGIN TRY

--							--INSERT ADDRESS
--							INSERT INTO dbo.synTransaction  ( tranAccountNumber_fk , tranCode_fk , tranTransactionAmount , tranMerchant ,  tranDescription )
--							VALUES  ( @AccountNumber,@TranCode,@Amount, @Merchant,@Description)
				
--							COMMIT TRANSACTION
--							DECLARE @TransactionId BIGINT
--							SELECT @TransactionId=@@IDENTITY

--							DECLARE @TranID VARCHAR(100)
--							SELECT @TranID =CAST(tranCode AS VARCHAR(50)) FROM dbo.synTransaction 
--							(READPAST) WHERE tranID=@TransactionId

--							SELECT 'Transaction Successful. Transaction Number for your reference is - '  +   @TranID

--					END TRY
--					BEGIN CATCH
--						SELECT 'Transaction Failed. Please try again.'
--						ROLLBACK TRANSACTION  --If Insertion fails rollback
--					END CATCH
--		   END
--		   ELSE
--				SELECT 'Insufficent Balance. Transaction Declined'
--END

/*
SELECT * FROM vwAccountTransactions ORDER BY [Account Number],[TRANSACTION DATE] DESC 

EXEC spPerformTrnasaction  @AccountNumber=20000, @TransactionType ='Withdrawal',@Amount =250000
EXEC spPerformTrnasaction  @AccountNumber=20001, @TransactionType ='Deposit',@Amount =250000,@Merchant =NULL,@Description=NULL
EXEC spPerformTrnasaction  @AccountNumber=30001, @TransactionType ='Deposit',@Amount =250000,@Merchant ='Old Navy Visa',@Description='Payment Gateway'

*/







/*
CREATE FUNCTION TO GET ACCOUNT Statement for a CUSTOMER

*/
 
 IF EXISTS (SELECT * FROM SYS.objects WHERE name='fnGetAccountStatement')
   DROP FUNCTION fnGetAccountStatement
GO

 CREATE FUNCTION fnGetAccountStatement (@AccountNumber BIGINT, @StartDate DateTime,@EndDate DateTime)
 RETURNS @Temp TABLE 
 (
 [Account number] BIGINT ,
 [Transaction Description] VARCHAR(50),
 [Transaction Date] DateTime,
 [Transaction Reference] VARCHAR(50) ,
 [Credit] DECIMAL(26,4),
 [Withdrawal] DECIMAL(26,4),
 [RunningBalance] DECIMAL(26,4)
 )
 AS
 BEGIN
     IF DATEDIFF(MM,@StartDate,@EndDate) < 6 --Maximum statement returned is for six Months
	 INSERT INTO @Temp
	 SELECT * FROM vwAccountTransactions 
	 WHERE [Account number]=@AccountNumber
	 AND [Transaction Date] BETWEEN @StartDate AND DATEADD(DD,1,@EndDate)

	RETURN
 END

 /*
 SELECT * FROM vwAccountTransactions ORDER BY [Account Number],[TRANSACTION DATE] DESC 
 SELECT * FROM fnGetAccountStatement(20001,'2017-01-30','2017-10-30')
 SELECT * FROM fnGetAccountStatement(20001,'2017-06-30','2017-11-30') 	 ORDER BY  [Transaction Date] DESC 
 */

 /*
 Simple Example For Scalar valued Fucntion
 */
-- IF EXISTS (SELECT * FROM SYS.objects WHERE name='fnGetAccountStatus')
--   DROP FUNCTION fnGetAccountStatus
--GO
--CREATE FUNCTION fnGetAccountStatus (@AccountNumber BIGINT)
--RETURNS  VARCHAR(100)
--AS
--BEGIN

--	DECLARE @Status VARCHAR(100)
--	SELECT @Status=accStatusDesc
--	FROM dbo.synAccount (READPAST) 
--	INNER JOIN dbo.synAccountStatus (READPAST) ON accStatusCode_fk=accStatusId
--	WHERE accNumber=@AccountNumber

--	RETURN @Status

--END

/*
SELECT * FROM vwCustomerAccountDetails
SELECT dbo.fnGetAccountStatus (40002)

*/

--Some exmaples of Relational Queries
--These can be converted into views or functions based  on needs.



GO
--Complete Relation for tables specified
SELECT A.bankDetails AS Bank,B.brBranchName AS [Branch Name],C.btTypeDesc AS 'Branch Type',D.addCity AS [Branch City],E.cstFirstName + ' ' +E.cstLastName AS 'Customer Name',
F.addCity AS [Customer City],G.accNumber AS [Acount number],G.accBalance AS [Account Balance],H.accTypeDesc AS 'Account Type',I.accStatusDesc AS 'Account Status',J.tranCode AS 'Transaction Reference',J.tranTransactionAmount AS 'Transaction Amount',J.tranDatetime AS 'Transaction Date'
,K.tranTypeDesc AS 'Transaction Type'
FROM  dbo.synBank A
INNER JOIN dbo.synBranch B ON A.bankId=B.brBankId_fk
INNER JOIN dbo.synBranchType C ON B.brBranchTypeCode_fk=C.btId
INNER JOIN dbo.synAddress D ON B.brAddress_fk=D.addId
INNER JOIN dbo.synCustomer E ON B.brID=E.cstBranchId_fk
INNER JOIN dbo.synAddress F ON E.cstAddId_fk=F.addId
INNER JOIN dbo.synAccount G ON  E.cstid=G.accCustomerId_fk
INNER JOIN dbo.synAccountType H ON G.accTypeCode_fk=H.accTypeId
INNER JOIN dbo.synAccountStatus I ON G.accStatusCode_fk=I.accStatusId
INNER JOIN dbo.synTransaction J ON G.accNumber=J.tranAccountNumber_fk
INNER JOIN dbo.synTransactionType K ON J.tranCode_fk=K.tranCodeID
ORDER BY 1,2,3

-- List all bank and their branches with total number of accounts in each Branch
SELECT A.BankDetails,ISNULL(B.brBranchName,'') AS Branch ,
ISNULL(COUNT(D.accNumber),0) AS NumberOfAccounts
FROM synBank A
LEFT JOIN synBranch B ON A.BankID=B.brBankId_fk
LEFT JOIN synCustomer C ON B.brID = C.cstBranchId_fk
LEFT JOIN synAccount D ON C.cstId= D.accCustomerId_fk
GROUP BY A.BankDetails,B.brBranchName
ORDER BY NumberOfAccounts DESC 

-- List total number of customers for each branch
SELECT A.brBranchName,COUNT(cstid)
FROM synBranch A 
INNER JOIN synCustomer B ON A.brID=B.cstBranchId_fk
GROUP BY A.brBranchName

-- Find all customer accounts that does not have any transaction
SELECT A.cstFirstName + ' ' +A.cstLastName,B.accNumber
FROM syncustomer A 
INNER JOIN synAccount B ON A.cstID=B.accCustomerId_fk
LEFT JOIN syntransaction C ON B.accNumber=C.tranAccountNumber_fk

WHERE C.TranId IS NULL


--OR using subquery as below

SELECT A.cstFirstName + ' ' +A.cstLastName,B.accNumber
FROM syncustomer A 
INNER JOIN synAccount B ON A.cstID=B.accCustomerId_fk
WHERE B.accNumber NOT IN (SELECT  tranAccountNumber_fk FROM dbo.synTransaction)


-- Rank the customers for each Bank & Branch based on number of transactions. 
-- Customer with maximum number of transaction gets 1 Rank(Position)
--Rank() skips the rank sequence when 2 rows have same value where as Dense_Rank() does not skip the rank sequence
SELECT 
A.bankDetails AS [Bank Name],
B.brBranchName AS 'Branch Name',
C.cstFirstName + ' '+c.cstLastName AS 'Customer Name',
D.accNumber AS 'Account Number'
,COUNT(tranID) AS 'Transaction Count',
RANK() OVER ( PARTITION BY   B.brBranchName ORDER BY COUNT(ISNULL(tranID,0)) DESC) AS [Position(Rank)]
,DENSE_RANK() OVER ( PARTITION BY B.brBranchName ORDER BY COUNT(ISNULL(tranID,0)) DESC) AS [Position(Dense Rank)]
FROM dbo.synBank A
INNER JOIN dbo.synBranch B ON A.bankId=B.brBankId_fk
INNER JOIN dbo.synCustomer C ON B.brID=C.cstBranchId_fk
INNER JOIN dbo.synAccount D ON C.cstid=D.accCustomerId_fk
LEFT JOIN dbo.synTransaction E ON D.accNumber=E.tranAccountNumber_fk --Here left join will ensure all customer records are listed. If not then customers without transaction will be omitted.
GROUP BY A.bankDetails,B.brBranchName,C.cstFirstName + ' '+c.cstLastName,D.accNumber
ORDER BY A.bankDetails ,B.brBranchName 










--Using Joins & Subqueries
SELECT  CASE WHEN DEBIT.[Customer Name] IS NULL THEN  CREDIT.[Customer Name] ELSE DEBIT.[Customer Name] END AS [Customer Name]
,CASE WHEN DEBIT.[AcountNumber] IS NULL THEN  CREDIT.[AcountNumber] ELSE DEBIT.[AcountNumber] END AS AcountNumber
, ISNULL(TotalCredit,0) AS TotalCredit,ISNULL(TotalDebit,0) AS TotalDebit
 FROM 
(
	SELECT A.cstid,A.cstFirstName + ' ' + A.cstLastName AS [Customer Name],	B.accNumber AS AcountNumber,
	SUM(C.tranTransactionAmount) AS TotalCredit
	FROM dbo.synCustomer A  
	INNER JOIN dbo.synAccount B  ON A.cstId=B.accCustomerId_fk
	INNER JOIN dbo.synTransaction   C ON B.accNumber=C.tranAccountNumber_fk
	INNER JOIN dbo.synTransactionType  D ON C.tranCode_fk=D.tranCodeID
	WHERE D.tranTypeDesc='Deposit'
	GROUP BY A.cstid,A.cstFirstName + ' ' + A.cstLastName,B.accNumber
)AS CREDIT
FULL OUTER  JOIN 
(
	SELECT A.cstid,A.cstFirstName + ' ' + A.cstLastName AS [Customer Name],	B.accNumber AS AcountNumber,
	SUM(C.tranTransactionAmount) AS TotalDebit
	FROM dbo.synCustomer A  
	INNER JOIN dbo.synAccount B  ON A.cstId=B.accCustomerId_fk
	INNER JOIN dbo.synTransaction   C ON B.accNumber=C.tranAccountNumber_fk
	INNER JOIN dbo.synTransactionType  D ON C.tranCode_fk=D.tranCodeID
	WHERE D.tranTypeDesc='Withdrawal'
	GROUP BY A.cstid,A.cstFirstName + ' ' + A.cstLastName,B.accNumber
) AS DEBIT
ON CREDIT.CSTID=DEBIT.CSTID
ORDER BY 1

/*
Resultset

Customer Name			AcountNumber		TotalCredit		TotalDebit
Adarsh Hegde			30001				41000.9120		0.0000
Chaithra Kunjathaya		20001				64001.3680		0.0000
Gaurao Tarpe			20002				1300.4500		40.3500
Nathan Kamas			40002				0.0000			25000.0000
SQL School			30002				20500.4560		0.0000
SQL School			20000				25000.0000		800000.0000

*/

--Above can also be accomplished using PIVOT--Just using it as I have used it in past in my project.

SELECT
[Customer Name],AcountNumber,
ISNULL([Deposit],0) AS TotalCredit,ISNULL([Withdrawal],0) AS TotalDebit
FROM
(
    SELECT A.cstid,A.cstFirstName + ' ' + A.cstLastName AS [Customer Name],B.accNumber AS AcountNumber,D.tranTypeDesc AS TransactionType,C.tranTransactionAmount  AS TransactionAmount
	FROM dbo.synCustomer A  
	INNER JOIN dbo.synAccount B  ON A.cstId=B.accCustomerId_fk
	INNER JOIN dbo.synTransaction   C ON B.accNumber=C.tranAccountNumber_fk
	INNER JOIN dbo.synTransactionType  D ON C.tranCode_fk=D.tranCodeID
)AS TempTrnasactions
PIVOT
(
SUM(TransactionAmount) 
FOR TransactionType IN ([Deposit],[Withdrawal])
) AS P
ORDER BY 1



-- PROJECT LEVEL INTERVIEW QUESTIONS : FOR DESIGN, DEVELOPMENT
-- INTERVIEW QUESTIONS FOR ALL CONCEPTS IN T-SQL MODULE CURRICULUM
-- SAMPLE RESUME POINTS
-- DOCs @ LICENSING & PRICING



/*
WHEN TO USE WHICH OBJECT?
		VIEWS				TO STORE QUERIES

		PROCEDURES			TO STORE QUERIES (STATIC, DYNAMIC)
							FOR DATA VALIDATIONS
							FOR DYNAMIC SQL STATEMENTS


		FUNCTIONS			TO STORE QUERIES (STATIC, DYNAMIC)
							TO GENERATE NEW DATA
							TO NORMALIZE EXISTING DATA
							FOR IMPLEMENTING DYNAMIC JOINS

		TRIGERS				TO STORE QUERIES (STATIC)
							FOR DATA ROUTING AND DATA DISTRIBUTIONS

		SCHEMAS				TO GROUP TABLES

		SYNONYMS			TO CREATE PERMENANT ALTERNATE NAMES FOR TABLES, OTHER DB OBJECTS
*/






