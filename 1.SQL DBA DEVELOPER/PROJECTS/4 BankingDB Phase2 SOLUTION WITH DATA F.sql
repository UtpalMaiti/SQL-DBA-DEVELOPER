-- STEP 1: CHECK IF DATABASE EXISTS. IF EXISTS, DROP THE DATABASE:

IF EXISTS (SELECT * FROM SYS.DATABASES WHERE NAME = 'BankingDB')
	DROP DATABASE BankingDB
	

-- STEP 2: CREATE DATABASE
CREATE DATABASE BankingDB

 

-- STEP 3: CONNECT TO ABOVE CREATED DATABASE
USE Bankingdb
GO


-- STEP 4: CREATE SCHEMAS IN THE DATABASE TO ORGANIZE THE TABLES

CREATE SCHEMA BANK
GO
CREATE SCHEMA ACCOUNT
GO
CREATE SCHEMA TRANSACTIONS	
GO


-- STEP 5: CREATE TABLES USING ABOVE DEFINED SCHEMAS AND FILEGROUPS
CREATE TABLE BANK.tblBank
(	
	bankId	    BIGINT IDENTITY(1000,1) PRIMARY KEY,
	bankDetails	VARCHAR(50)
) 	

INSERT INTO BANK.tblBank (bankDetails) VALUES ('State Bank of India')
INSERT INTO BANK.tblBank (bankDetails) VALUES ('State Bank of Mysore')
INSERT INTO BANK.tblBank (bankDetails) VALUES ('State Bank of Hyderbad')
INSERT INTO BANK.tblBank (bankDetails) VALUES ('ICICI')
INSERT INTO BANK.tblBank (bankDetails) VALUES ('Punjab Nationnal Bank')
INSERT INTO BANK.tblBank (bankDetails) VALUES ('HDFC')
INSERT INTO BANK.tblBank (bankDetails) VALUES ('IDBI')
INSERT INTO BANK.tblBank (bankDetails) VALUES ('Karnataka Bank')
INSERT INTO BANK.tblBank (bankDetails) VALUES ('Syndicate Bank')
INSERT INTO BANK.tblBank (bankDetails) VALUES ('Canara Bank')
INSERT INTO BANK.tblBank (bankDetails) VALUES ('Citi Bank')
INSERT INTO BANK.tblBank (bankDetails) VALUES ('Wells Fargo')
INSERT INTO BANK.tblBank (bankDetails) VALUES ('Discover')
INSERT INTO BANK.tblBank (bankDetails) VALUES ('TCF')



CREATE TABLE BANK.tbladdAddress
(	
	addId	    BIGINT IDENTITY(1000,1) PRIMARY KEY, 
	addLine1	VARCHAR(100),
	addLine2	VARCHAR(50),
	addCity	    VARCHAR(50),
	addPostCode	VARCHAR(15),
	addState	VARCHAR(50), 
	addCountry	VARCHAR(50)
)


INSERT INTO BANK.tbladdAddress (addLine1,addLine2,addCity,addPostCode,addState,addCountry) VALUES('9730 37th Place North','Apt#204','Plymouth','55441','MN','USA')
INSERT INTO BANK.tbladdAddress (addLine1,addLine2,addCity,addPostCode,addState,addCountry) VALUES('Kombettu House','Padavu, Ujirpade Post Balnad','Puttur','574203','Karnataka','India')
INSERT INTO BANK.tbladdAddress (addLine1,addLine2,addCity,addPostCode,addState,addCountry) VALUES('302, Sai Manor Towers','X Roads, SR Nagar','Hyderabad','574038','Andra Pradesh','India')






CREATE TABLE BANK.tblbtBranchType
(	
	btId	BIGINT IDENTITY(1000,1) PRIMARY KEY,
	btTypeCode	VARCHAR(4) ,
	btTypeDesc	VARCHAR(100)

) 


INSERT INTO BANK.tblbtBranchType (btTypeCode,btTypeDesc) VALUES ('LU','Large Urban')
INSERT INTO BANK.tblbtBranchType (btTypeCode,btTypeDesc) VALUES ('SR','Small Rural')
INSERT INTO BANK.tblbtBranchType (btTypeCode,btTypeDesc) VALUES ('HO','Head Office')



CREATE TABLE BANK.tblbrBranch
(
brID				BIGINT IDENTITY (1000,1) PRIMARY KEY,
brBankId_fk			BIGINT references BANK.tblBank (bankId),
brAddress_fk		BIGINT references BANK.tbladdAddress (addId),
brBranchTypeCode_fk	BIGINT references BANK.tblbtBranchType (btId),
brBranchName		VARCHAR(100),
brBranchPhone1		VARCHAR(20),
brBranchPhone2		VARCHAR(20),
brBranchFax			VARCHAR(20),
brBranchemail		VARCHAR(50),
brBranchIFSC		VARCHAR(20)
)



ALTER TABLE BANK.tblbrBranch ADD CONSTRAINT FK_brBankId FOREIGN KEY (brBankId_fk) 
REFERENCES BANK.tblBank (bankId)

ALTER TABLE BANK.tblbrBranch ADD CONSTRAINT FK_brAddress FOREIGN KEY (brAddress_fk) 
REFERENCES BANK.tbladdAddress (addId)

ALTER TABLE BANK.tblbrBranch ADD CONSTRAINT FK_brBranchTypeCode FOREIGN KEY (brBranchTypeCode_fk) 
REFERENCES BANK.tblbtBranchType (btId)

INSERT INTO Bank.tblbrBranch(brAddress_fk,brBankId_fk,brBranchTypeCode_fk,brBranchName,brBranchPhone1,brBranchPhone2,brBranchFax,brBranchemail,brBranchIFSC) VALUES (1000,1011,1001,'Golden Valley','1 323 416 4705','1 323 416 4095','1 763 954 1522','wellsfargogv@wellsfargo.com','WFGV1015')
INSERT INTO Bank.tblbrBranch(brAddress_fk,brBankId_fk,brBranchTypeCode_fk,brBranchName,brBranchPhone1,brBranchPhone2,brBranchFax,brBranchemail,brBranchIFSC) VALUES (1001,1007,1002,'Mangalore','91 824 247623','91 824 247624','91 824 247625','banker25@karnatakabank.com','KBIN05267')
INSERT INTO Bank.tblbrBranch(brAddress_fk,brBankId_fk,brBranchTypeCode_fk,brBranchName,brBranchPhone1,brBranchPhone2,brBranchFax,brBranchemail,brBranchIFSC) VALUES (1002,1000,1000,'Puttur Market','91 8251 249246','91 8251 249247','91 8251 249244','sbi.04270@sbi.co.in','SBIN004270')






CREATE TABLE BANK.tblcstCustomer
(	
	cstId	         BIGINT  IDENTITY (1000,1),
	cstAddId_fk	     BIGINT,
	cstBranchId_fk	 BIGINT,
	cstFirstName	 VARCHAR(50),
	cstLastName	     VARCHAR(50),
	CstMiddleName	 VARCHAR(50),
	cstDOB	         DATE,
	cstSince	     DATETIME,
	cstPhone1	     VARCHAR(20),
	cstPhone2	     VARCHAR(20),
	cstFax	         VARCHAR(20),
	cstGender	     VARCHAR(10),
	cstemail	     VARCHAR(50)
)

ALTER TABLE BANK.tblcstCustomer ADD CONSTRAINT PK_cstId PRIMARY KEY (cstId)
ALTER TABLE BANK.tblcstCustomer ADD CONSTRAINT FK_cstAddId FOREIGN KEY (cstAddId_fk) REFERENCES BANK.tbladdAddress (addId)
ALTER TABLE BANK.tblcstCustomer ADD CONSTRAINT FK_cstBranchId FOREIGN KEY (cstBranchId_fk) REFERENCES BANK.tblbrBranch (brID)

INSERT INTO BANK.tblcstCustomer (cstAddId_fk,cstBranchId_fk,cstFirstName,cstLastName,CstMiddleName,cstDOB,cstSince,cstPhone1,cstPhone2,cstFax,cstGender,cstemail) VALUES (1001,1002,'Gaurao','Tarpe','','25-Dec-1986','2000','91 824 247623','','','Male','y')
INSERT INTO BANK.tblcstCustomer (cstAddId_fk,cstBranchId_fk,cstFirstName,cstLastName,CstMiddleName,cstDOB,cstSince,cstPhone1,cstPhone2,cstFax,cstGender,cstemail) VALUES (1002,1002,'Chaithra','Kunjathaya','Nithin','19-Jan-1990','2005','91 8251 249246','','','Female','y')
INSERT INTO BANK.tblcstCustomer (cstAddId_fk,cstBranchId_fk,cstFirstName,cstLastName,CstMiddleName,cstDOB,cstSince,cstPhone1,cstPhone2,cstFax,cstGender,cstemail) VALUES (1001,1001,'Adarsh','Hegde','','19-Jan-1990','2015','91 8251 249246','','','Male','y')
INSERT INTO BANK.tblcstCustomer (cstAddId_fk,cstBranchId_fk,cstFirstName,cstLastName,CstMiddleName,cstDOB,cstSince,cstPhone1,cstPhone2,cstFax,cstGender,cstemail) VALUES (1000,1002,'Nithin','Kumar','','9-Nov-1985','1996','1 323 416 4705','','','Male','y')
INSERT INTO BANK.tblcstCustomer (cstAddId_fk,cstBranchId_fk,cstFirstName,cstLastName,CstMiddleName,cstDOB,cstSince,cstPhone1,cstPhone2,cstFax,cstGender,cstemail) VALUES (1000,1002,'Nathan','Kamas','','10-Nov-1985','1996','1 323 416 4705','','','Male','y')





CREATE TABLE ACCOUNT.tblaccAccountType
( 
accTypeId BIGINT IDENTITY (1000,1),
accTypeCode VARCHAR(10),
accTypeDesc VARCHAR(100)
)

ALTER TABLE ACCOUNT.tblaccAccountType ADD CONSTRAINT PK_accTypeId 
PRIMARY KEY (accTypeId)


INSERT INTO ACCOUNT.tblaccAccountType VALUES ('CHK','Checking')
INSERT INTO ACCOUNT.tblaccAccountType VALUES ('SAV','Saving')
INSERT INTO ACCOUNT.tblaccAccountType VALUES ('CUR','Current')
INSERT INTO ACCOUNT.tblaccAccountType VALUES ('LN','Loan')




CREATE TABLE ACCOUNT.tblaccAccountStatus
( 
accStatusId BIGINT IDENTITY (1000,1),
accStatusCode VARCHAR(10),
accStatusDesc VARCHAR(50)
)

ALTER TABLE ACCOUNT.tblaccAccountStatus ADD CONSTRAINT 
PK_accStatusId PRIMARY KEY (accStatusId)

INSERT INTO ACCOUNT.tblaccAccountStatus VALUES ('A','Active')
INSERT INTO ACCOUNT.tblaccAccountStatus VALUES ('C','Closed')


CREATE TABLE ACCOUNT.tblaccAccount
( 
accNumber BIGINT IDENTITY (20000,1),
accStatusCode_fk BIGINT,
accTypeCode_fk BIGINT,
accCustomerId_fk BIGINT,
accBalance DECIMAL(26,4)
) 

ALTER TABLE ACCOUNT.tblaccAccount ADD CONSTRAINT PK_accNumber PRIMARY KEY (accNumber)
ALTER TABLE ACCOUNT.tblaccAccount ADD CONSTRAINT FK_accStatusCode 
FOREIGN KEY (accStatusCode_fk) REFERENCES ACCOUNT.tblaccAccountStatus (accStatusId)
ALTER TABLE ACCOUNT.tblaccAccount ADD CONSTRAINT FK_accTypeCode 
FOREIGN KEY (accTypeCode_fk) REFERENCES ACCOUNT.tblaccAccountType (accTypeId)
ALTER TABLE ACCOUNT.tblaccAccount ADD CONSTRAINT FK_accCustomerId 
FOREIGN KEY (accCustomerId_fk) REFERENCES BANK.tblcstCustomer (cstId)

INSERT INTO ACCOUNT.tblaccAccount  (accStatusCode_fk,accTypeCode_fk,accCustomerId_fk,accBalance) VALUES (1000,1001,1000,10000)
INSERT INTO ACCOUNT.tblaccAccount  (accStatusCode_fk,accTypeCode_fk,accCustomerId_fk,accBalance) VALUES (1001,1000,1001,200000.9897)
INSERT INTO ACCOUNT.tblaccAccount  (accStatusCode_fk,accTypeCode_fk,accCustomerId_fk,accBalance) VALUES (1001,1001,1002,30000.456)
INSERT INTO ACCOUNT.tblaccAccount  (accStatusCode_fk,accTypeCode_fk,accCustomerId_fk,accBalance) VALUES (1001,1002,1003,5000)
INSERT INTO ACCOUNT.tblaccAccount  (accStatusCode_fk,accTypeCode_fk,accCustomerId_fk,accBalance) VALUES (1001,1000,1004,500)



CREATE TABLE TRANSACTIONS.tbltranTransactionType
( 
tranCodeID BIGINT IDENTITY (1000,1),
tranTypeDesc VARCHAR(50)
) 

ALTER TABLE TRANSACTIONS.tbltranTransactionType ADD CONSTRAINT 
PK_tranCodeID PRIMARY KEY (tranCodeID) 

INSERT INTO TRANSACTIONS.tbltranTransactionType(tranTypeDesc) VALUES ('Deposit')
INSERT INTO TRANSACTIONS.tbltranTransactionType(tranTypeDesc) VALUES ('Withdrawal')

SELECT * FROM TRANSACTIONS.tbltranTransactionType

CREATE TABLE TRANSACTIONS.tbltranTransaction
( 
tranID BIGINT IDENTITY 
(1000,1),
tranCode VARCHAR(50),
tranAccountNumber_fk BIGINT,
tranCode_fk BIGINT,
tranDatetime DateTime,
tranTransactionAmount Decimal(26,4),
tranMerchant VARCHAR(50),
tranDescription VARCHAR(50),
RunningBalance DECIMAL(26,4) DEFAULT NULL
) 

ALTER TABLE TRANSACTIONS.tbltranTransaction ADD CONSTRAINT PK_tranID PRIMARY KEY (tranID) 
ALTER TABLE TRANSACTIONS.tbltranTransaction ADD CONSTRAINT 
FK_tranAccountNumber FOREIGN KEY (tranAccountNumber_fk) REFERENCES ACCOUNT.tblaccAccount (accNumber)
ALTER TABLE TRANSACTIONS.tbltranTransaction ADD CONSTRAINT 
FK_tranCode FOREIGN KEY (tranCode_fk) REFERENCES TRANSACTIONS.tbltranTransactionType (tranCodeID)
ALTER TABLE TRANSACTIONS.tbltranTransaction ADD CONSTRAINT DF_tranDatetime DEFAULT GETDATE() FOR tranDatetime 
ALTER TABLE TRANSACTIONS.tbltranTransaction ADD CONSTRAINT DF_tranCode DEFAULT NEWID() FOR tranCode

INSERT INTO TRANSACTIONS.tbltranTransaction (tranAccountNumber_fk,tranCode_fk,tranTransactionAmount,tranMerchant,tranDescription) VALUES (20000,1000,20500.456,'Self','Self Deposit')
INSERT INTO TRANSACTIONS.tbltranTransaction (tranAccountNumber_fk,tranCode_fk,tranTransactionAmount,tranMerchant,tranDescription) VALUES (20001,1001,200000,'Discover','Withdrawal')
INSERT INTO TRANSACTIONS.tbltranTransaction (tranAccountNumber_fk,tranCode_fk,tranTransactionAmount,tranMerchant,tranDescription) VALUES (20000,1001,13.45,'','Cheque #5001')
INSERT INTO TRANSACTIONS.tbltranTransaction (tranAccountNumber_fk,tranCode_fk,tranTransactionAmount,tranMerchant,tranDescription) VALUES (20001,1000,2500,'Self','Self Deposit')
INSERT INTO TRANSACTIONS.tbltranTransaction (tranAccountNumber_fk,tranCode_fk,tranTransactionAmount,tranMerchant,tranDescription) VALUES (20001,1000,25000,'Discover','Withdrawal')
INSERT INTO TRANSACTIONS.tbltranTransaction (tranAccountNumber_fk,tranCode_fk,tranTransactionAmount,tranMerchant,tranDescription) VALUES (20001,1001,200000,'Discover','Withdrawal')
INSERT INTO TRANSACTIONS.tbltranTransaction (tranAccountNumber_fk,tranCode_fk,tranTransactionAmount,tranMerchant,tranDescription) VALUES (20003,1000,20500.456,'Self','Self Deposit')
INSERT INTO TRANSACTIONS.tbltranTransaction (tranAccountNumber_fk,tranCode_fk,tranTransactionAmount,tranMerchant,tranDescription) VALUES (20004,1001,200000,'Discover','Withdrawal')
INSERT INTO TRANSACTIONS.tbltranTransaction (tranAccountNumber_fk,tranCode_fk,tranTransactionAmount,tranMerchant,tranDescription) VALUES (20001,1000,20500.456,'Self','Self Deposit')
INSERT INTO TRANSACTIONS.tbltranTransaction (tranAccountNumber_fk,tranCode_fk,tranTransactionAmount,tranMerchant,tranDescription) VALUES (20003,1001,25000,'Discover','Withdrawal')

select * from TRANSACTIONS.tbltranTransaction


-- SYNONYMS ARE PERMENANT ALTERNATE NAMES TO TABLES / ANY DATABASE OBJECTS
CREATE SYNONYM synBank                  FOR BANK.tblBank
CREATE SYNONYM synAddress				FOR BANK.tbladdAddress
CREATE SYNONYM synBranchType			FOR BANK.tblbtBranchType
CREATE SYNONYM synBranch				FOR BANK.tblbrBranch
CREATE SYNONYM synCustomer				FOR BANK.tblcstCustomer
CREATE SYNONYM synAccountType			FOR ACCOUNT.tblaccAccountType
CREATE SYNONYM synAccountStatus			FOR ACCOUNT.tblaccAccountStatus
CREATE SYNONYM synAccount				FOR ACCOUNT.tblaccAccount
CREATE SYNONYM synTransactionType		FOR TRANSACTIONS.tbltranTransactionType  
CREATE SYNONYM synTransaction			FOR TRANSACTIONS.tbltranTransaction

select * from TRANSACTIONS.tbltranTransactionType
SELECT * FROM synTransactionType

/*
-- Phase 2: Write T-SQL Queries for below requirement:

-- 1. CREATE FUNCTION TO GET ACCOUNT STATEMENT FOR A GIVEN CUSTOMER ?
-- 2. List all Banks and their Branches with total number of Accounts in each Branch
-- 3. List total number of Customers for each Branch
-- 4. Find all Customer Accounts that does not have any Transaction
-- 5. Rank the Customers for each Bank & Branch based on number of Transactions. 
--   Customer with maximum number of Transaction gets 1 Rank (Position)
-- 6. MONTHLY STATEMENT transactions for a given month for a given customer id
-- 7. LIST OF ALL CUSTOMERS WITH ACCOUNTS, NO TRANSACTIONS
-- 8. LIST OF ALL ZIP CODES WITH MISSING CUSTOMER ADDRESS
-- 9. LIST OF ALL CUSTOMERS WITH ACCOUNTS BASED ON ACCOUNT STATUS & TYPES WITHOUT ANY TRANSACTIONS
-- 10. LIST OF ALL BANKS BASED ON CUSTOMERS AND TRANSACTION AMOUNTS

*/

USE BankingDB
GO


-- 1. CREATE FUNCTION TO REPORT ACCOUNT STATEMENT FOR A GIVEN CUSTOMER ?
CREATE FUNCTION FN_ACC_STATEMENT ( @CSTID BIGINT )
RETURNS TABLE
AS
RETURN
(
	SELECT * FROM ACCOUNT.tblaccAccount		-- JOIN OF MULTIPLE TABLES ACCROSS MULTIPLE SCHEMAS, BASED ON RELATION
	INNER JOIN
	bank.tblcstCustomer
	on accCustomerId_fk=cstId 
	WHERE 
	cstId=@CSTID
)
 
 GO
SELECT * FROM FN_ACC_STATEMENT(1001)



--  2. List all Banks and their Branches with total number of Accounts in each Branch
select bankId, bankDetails, brBranchTypeCode_fk,
count(accNumber) as total_account
from 
bank.tblBank
right outer join
bank.tblbrBranch
on bankId=brBankId_fk 
right outer join
bank.tblcstCustomer
on brID=cstBranchId_fk 
inner join
account.tblaccAccount
on accCustomerId_fk=cstId  
group by brBranchTypeCode_fk, bankId, bankDetails




-- 3. List total number of Customers for each Branch
select 
brid, brBranchName, count(cstid) as total_cust from
bank.tblbrBranch 
LEFT OUTER join		--INCLUDES ALL SUCH BRANCHES WITH CUSTOMERS AND WITHOUT CUSTOMERS AS WELL
bank.tblcstCustomer 
on
brID=cstBranchid_fk
group by brid, brBranchName






-- 4. Find all Customer Accounts that does not have any Transaction
SELECT C.cstId, C.cstFirstName + '   ' + C.cstLastName AS CUST_NAME, 
A.accNumber, A.accTypeCode_fk, T.RunningBalance, 
convert(int, isnull(T.tranTransactionAmount,0))
FROM bank.tblcstCustomer AS C 
left outer JOIN
ACCOUNT.tblaccAccount AS A
on A.accCustomerId_fk=C.cstId 
LEFT OUTER JOIN transactions.tbltranTransaction  AS T
on A.accNumber=T.tranAccountNumber_fk
where 
tranID is null

-- coalesce


--5. Rank the Customers for each Bank & Branch based on number of Transactions. 
--   Customers with maximum number of Transactions gets 1 Rank (Position)
SELECT 
C.cstId, C.cstFirstName +' '+ C.cstLastName as CustName, 
B.BankDetails, BR.brBranchName, count(T.tranID) AS No_of_Transactions, 
DENSE_RANK() OVER(ORDER BY count(T.tranID) DESC) AS Position
FROM TRANSACTIONS.tbltranTransaction AS T
LEFT OUTER JOIN
ACCOUNT.tblaccAccount AS A
ON
T.tranAccountNumber_fk = A.accNumber
LEFT OUTER JOIN
BANK.tblcstCustomer AS C
ON C.cstId = accCustomerId_fk
LEFT OUTER JOIN
BANK.tblbrBranch AS BR
ON BR.brID = C.cstBranchId_fk
LEFT OUTER JOIN
BANK.tblBank AS B
ON B.bankId = BR.brBankId_fk
GROUP BY C.cstId,C.cstFirstName + ' ' +  C.cstLastName,B.bankDetails, BR.brBranchName
GO




--6. Total Sum of DEBITS & CREDITS for each Customer. 
CREATE VIEW VW_TRANSACTIONDETAILS 
AS
	SELECT  
	T.tranAccountNumber_fk,A.accCustomerId_fk,TT.tranTypeDesc, 
	ISNULL(sum(T.tranTransactionAmount),0) AS [Total Transaction Amount]
	FROM TRANSACTIONS.tbltranTransaction AS T
	INNER JOIN
	TRANSACTIONS.tbltranTransactionType AS TT
	ON
	T.tranCode_fk = TT.tranCodeID
	INNER JOIN
	ACCOUNT.tblaccAccount AS A
	ON
	A.accNumber = T.tranAccountNumber_fk
	GROUP BY T.tranAccountNumber_fk,A.accCustomerId_fk,TT.tranTypeDesc
GO

SELECT * FROM VW_TRANSACTIONDETAILS


SELECT * FROM VW_TRANSACTIONDETAILS
PIVOT
( sum([Total Transaction Amount]) --- Column Alias Name works in Pivot 
  FOR  tranTypeDesc IN (Deposit, Withdrawal)
) as PivotQuery
GO



-- 7. LIST OF ALL CUSTOMERS WITH ACCOUNTS, NO TRANSACTIONS
SELECT C.* FROM BANK.tblcstCustomer AS C
INNER JOIN							-- HERE, WE REPORT MATCHING DATA
ACCOUNT.tblaccAccount
ON accCustomerId_fk=cstId
LEFT OUTER JOIN						-- HERE, WE REPORT MATCHING AND MISSING DATA
TRANSACTIONS.tbltranTransaction
ON accNumber=tranAccountNumber_fk
WHERE tranAccountNumber_fk IS NULL	-- HERE, WE FILTER FOR ONLY MISSING DATA



--8. LIST OF ALL CUSTOMERS WITH ACCOUNTS BASED ON ACCOUNT STATUS
SELECT cstId, tblcstCustomer.cstFirstName + ' ' + tblcstCustomer.cstLastName AS FullName, 
accStatusCode,accNumber, accStatusDesc
FROM BANK.tblcstCustomer
LEFT OUTER JOIN
ACCOUNT.tblaccAccount
ON accCustomerId_fk=cstId
LEFT OUTER JOIN
account.tblaccAccountStatus
ON accStatusCode_fk=accStatusId
where accStatusCode_fk is not null
order by accStatusCode, FullName



-- 9. LIST OF ALL CUSTOMERS WITH ACCOUNTS BASED ON ACCOUNT STATUS & TYPES WITHOUT ANY TRANSACTIONS
SELECT 
C.cstId, C.cstFirstName, C.cstLastName, 
A.accNumber, ACS.accStatusDesc,ACT.accTypeDesc,
ISNULL(CONVERT(VARCHAR,T.tranAccountNumber_fk),'No Transactions') AS 'TRANSACTION ACC NUMBER'
FROM ACCOUNT.tblaccAccount AS A
LEFT OUTER JOIN
TRANSACTIONS.tbltranTransaction AS T
ON
A.accNumber = T.tranAccountNumber_fk
INNER JOIN
BANK.tblcstCustomer AS C
ON A.accCustomerId_fk = C.cstId
INNER JOIN
ACCOUNT.tblaccAccountStatus AS ACS
ON  A.accStatusCode_fk = ACS.accStatusId
INNER JOIN
ACCOUNT.tblaccAccountType AS ACT
ON A.accTypeCode_fk = ACT.accTypeId
WHERE T.tranID IS NULL
GO




-- 10. LIST OF ALL BANKS BASED ON CUSTOMERS AND TRANSACTION AMOUNTS
SELECT 
cstId, cstFirstName, cstLastName,bankDetails, brBranchName, accNumber, 
ISNULL(CONVERT(VARCHAR,tranTransactionAmount),'No Transactions') AS "Transaction Amount"
FROM bank.tblBank 
LEFT OUTER  JOIN
bank.tblbrBranch
on bankId=brBankId_fk
LEFT JOIN
bank.tblcstCustomer 
ON brID=cstBranchId_fk 
LEFT JOIN
account.tblaccAccount
on accCustomerId_fk=cstId
LEFT OUTER JOIN
TRANSACTIONS.tbltranTransaction
ON accNumber=tranAccountNumber_fk
WHERE cstId IS NOT NULL AND accNumber IS NOT NULL
--ORDER BY cstId, tranTransactionAmount




/*
PHASE 3  OF THE BANKING PROJECT FOR SQL SERVER T-SQL DEVELOPERS (T-SQL PLAN A,B,C):	 
				HOW TO INSERT DATA INTO ABOVE TABLES WITH BELOW CONDITIONS :
								* CONDITIONAL & DYNAMIC
								* AUTOMATED TRANSACTION BEHAVIOUR USING TRIGGERS		





				FOR THIS PHASE 3, PLEASE PRACTICE VIEWS, TRIGGERS, TRANSACTIONS WITH PROCEDURES
					WE CANNOT INSERT DATA INTO A VIEW IF THE VIEW IS BUILT ON MULTIPLE BASE TABLES.
					SOLUTION :  DEFINE A TRIGER ON THE VIEW
								THEN DEFINE AN SP TO INSERT DATA INTO THE VIEW USING TRIGGER.																																	
									
				PLEASE MAIL ME YOUR SOLUTION FOR ATLEAST FIRST 5 TABLES.  */
								
								 
*/			

SP_HELP [VW_Bank_Branch_Btype_Add]
ALTER VIEW [VW_Bank_Branch_Btype_Add] AS 
SELECT 
[brBankId_fk],
[brAddress_fk],
[brBranchTypeCode_fk],
[brBranchName],
[brBranchPhone1],
[brBranchPhone2],
[brBranchFax],
[brBranchemail],
[brBranchIFSC]
FROM [BANK].[tblbrBranch] BB 


SELECT * FROM [dbo].[VW_Bank_Branch_Btype_Add]

CREATE TRIGGER TR_Insert_VW_Bank_Branch_Btype_Add
ON [VW_Bank_Branch_Btype_Add]
INSTEAD OF INSERT 
AS
BEGIN
BEGIN TRY
	BEGIN TRANSACTION
	DECLARE 
	--@bankId bigint, 
	--@bankDetails VARCHAR(50),

	--@btId bigint, 
	--@btTypeCode VARCHAR(30),
	--@btTypeDesc VARCHAR(30),

	--@addId bigint,
	--@addLine1 VARCHAR(100),
	--@addLine2 VARCHAR(50),
	--@addCity VARCHAR(50),
	--@addPostCode VARCHAR(50),
	--@addState VARCHAR(50),
	--@addCountry VARCHAR(50),

	--@brID bigint,
	@brBankId_fk bigint,
	@brAddress_fk bigint,
	@brBranchTypeCode_fk bigint,
	@brBranchName VARCHAR(100),
	@brBranchPhone1 VARCHAR(50),
	@brBranchPhone2 VARCHAR(50),
	@brBranchFax VARCHAR(50),
	@brBranchemail VARCHAR(50),
	@brBranchIFSC VARCHAR(50);

	SELECT 
		@brBankId_fk = brBankId_fk,
		@brAddress_fk = brAddress_fk, 
		@brBranchTypeCode_fk = brBranchTypeCode_fk,
		@brBranchName = brBranchName, 
		@brBranchPhone1 = brBranchPhone1,
		@brBranchPhone2 = brBranchPhone2,
		@brBranchFax = brBranchFax,
		@brBranchemail = brBranchemail,
		@brBranchIFSC = brBranchIFSC
		FROM INSERTED;

	 IF  NOT EXISTS( SELECT * FROM [BANK].[tblBank] WHERE [bankId]=@brBankId_fk AND  [bankId] is not null)
		BEGIN
			ROLLBACK;
			PRINT 'Bank Master Record is not Present yet!';
			RETURN;
		END

	IF  NOT EXISTS( SELECT * FROM [BANK].[tblbtBranchType] WHERE [btId]=@brBranchTypeCode_fk AND  [btId] is not null)
		BEGIN
			ROLLBACK;
			PRINT 'Bank Branch Type  record is not Present yet!';
			RETURN;
		END

	IF  NOT EXISTS( SELECT * FROM [BANK].[tbladdAddress] WHERE [addId]=@brAddress_fk AND  [addId] is not null)
	BEGIN
		ROLLBACK;
		PRINT 'Bank Address record is not Present yet!';
		RETURN;
	END

	--IF  NOT EXISTS( SELECT * FROM [BANK].[tblbrBranch] WHERE [brID]=@addId AND  [brID] is not null)
	--BEGIN
	--	ROLLBACK;
	--	PRINT 'Branch Master record is not Present yet!';
	--	RETURN;
	--END

	INSERT INTO [BANK].[tblbrBranch] ([brBankId_fk],[brAddress_fk],[brBranchTypeCode_fk],[brBranchName],[brBranchPhone1],[brBranchPhone2],[brBranchFax],[brBranchemail],[brBranchIFSC])
	VALUES(@brBankId_fk,@brAddress_fk,@brBranchTypeCode_fk,@brBranchName,@brBranchPhone1,@brBranchPhone2,@brBranchFax,@brBranchemail,@brBranchIFSC);
	
		COMMIT TRANSACTION
		PRINT 'Record is Inserted SuccessFully'
	END TRY
		BEGIN CATCH
			ROLLBACK
		PRINT 'An Error Occured';
		SELECT @@ERROR AS ERROR;

		END CATCH
END


SELECT * FROM [BANK].[tblBank]
SELECT * FROM [BANK].[tbladdAddress]
SELECT * FROM [BANK].[tblbrBranch]
SELECT * FROM [BANK].[tblbtBranchType]

SELECT * FROM [dbo].[VW_Bank_Branch_Btype_Add]

SP_HELP [VW_Bank_Branch_Btype_Add]


INSERT INTO [dbo].[VW_Bank_Branch_Btype_Add] VALUES (1000,1000,1000,'HOWRAH','123456789','9874563210','FAX','MAIL','14785KJHG')
INSERT INTO [dbo].[VW_Bank_Branch_Btype_Add] VALUES (111000,1000,1000,'HOWRAH','123456789','9874563210','FAX','MAIL','14785KJHG') --not allowed
INSERT INTO [dbo].[VW_Bank_Branch_Btype_Add] VALUES (1000,1000000,1000,'HOWRAH','123456789','9874563210','FAX','MAIL','14785KJHG') --not allowed
INSERT INTO [dbo].[VW_Bank_Branch_Btype_Add] VALUES (1000,1000000,10,'HOWRAH','123456789','9874563210','FAX','MAIL','14785KJHG') --not allowed




--Example 2
CREATE VIEW [VW_FactTransaction]
AS 
SELECT * FROM 
[TRANSACTIONS].[tbltranTransaction] 

ALTER VIEW [VW_FactTransaction_ACCOUNT] AS 
SELECT * FROM 
[ACCOUNT].[tblaccAccount] A
INNER JOIN 
[TRANSACTIONS].[tbltranTransaction] T ON T.[tranAccountNumber_fk]=A.[accNumber]

SP_HELP [VW_FactTransaction]
SP_HELP [VW_FactTransaction_ACCOUNT]

SELECT * FROM [TRANSACTIONS].[tbltranTransaction] 
SELECT * FROM [TRANSACTIONS].[tbltranTransactionType]
SELECT * FROM [ACCOUNT].[tblaccAccount]
SELECT * FROM [ACCOUNT].[tblaccAccountStatus]
SELECT * FROM [ACCOUNT].[tblaccAccountType]
SELECT * FROM [BANK].[tblcstCustomer]

--INSERT INTO [TRANSACTIONS].[tbltranTransaction] ([tranAccountNumber_fk],[tranCode_fk],[tranTransactionAmount],[tranMerchant],[tranDescription])
INSERT INTO [VW_FactTransaction] ([tranAccountNumber_fk],[tranCode_fk],[tranTransactionAmount],[tranMerchant],[tranDescription])



ALTER TRIGGER [tIGGER_FactTransaction]
ON [dbo].[VW_FactTransaction]
INSTEAD OF INSERT 
AS
BEGIN
BEGIN TRY
	BEGIN TRANSACTION
	DECLARE 
	@tranAccountNumber_fk bigint,
	@tranCode_fk bigint,
	@tranTransactionAmount bigint,
	@tranMerchant VARCHAR(100),
	@tranDescription VARCHAR(50)

	SELECT 
		@tranAccountNumber_fk = tranAccountNumber_fk,
		@tranCode_fk = tranCode_fk, 
		@tranTransactionAmount = tranTransactionAmount,
		@tranMerchant = tranMerchant, 
		@tranDescription = tranDescription
		FROM INSERTED;

	 IF  NOT EXISTS( SELECT * FROM [ACCOUNT].[tblaccAccount] WHERE [accNumber]=@tranAccountNumber_fk AND  [accNumber] is not null)
		BEGIN
			ROLLBACK;
			PRINT 'Account Number not found ,Contact to Bank';
			RETURN;
		END

	IF  NOT EXISTS( SELECT * FROM [TRANSACTIONS].[tbltranTransactionType] WHERE [tranCodeID]=@tranCode_fk AND  [tranCodeID] is not null)
		BEGIN
			ROLLBACK;
			PRINT 'Transaction Type  record is not Present yet!';
			RETURN;
		END

	--IF  NOT EXISTS( SELECT * FROM [BANK].[tbladdAddress] WHERE [addId]=@brAddress_fk AND  [addId] is not null)
	--BEGIN
	--	ROLLBACK;
	--	PRINT 'Bank Address record is not Present yet!';
	--	RETURN;
	--END


	DECLARE @isActiv BIT = 0,@accBalance bigint= 0 ,@accType VARCHAR(10)='CHK';

	select TOP(1) @isActiv=CASE WHEN  ASS.accStatusId = 1000 THEN 1
								WHEN  ASS.accStatusId <> 1000 THEN 0
								ELSE NULL
								END, 
				 @accBalance=ISNULL(A.[accBalance],0),
				 @accType=TRIM(ATT.accTypeCode)
	FROM  [ACCOUNT].[tblaccAccount] A
	inner join [ACCOUNT].[tblaccAccountStatus] ASS  ON A.accStatusCode_fk=ASS.accStatusId
	INNER JOIN [ACCOUNT].[tblaccAccountType] ATT ON A.accTypeCode_fk=ATT.accTypeId
	WHERE A.accNumber IN (@tranAccountNumber_fk)
	select @isActiv;


 --select TOP(1) CASE WHEN  ASS.accStatusId = 1000 THEN 1
	--							WHEN  ASS.accStatusId <> 1000 THEN 0
	--							ELSE NULL
	--							END, 
	--			 ISNULL(A.[accBalance],0),
	--			 TRIM(ATT.accTypeCode)
	--FROM  [ACCOUNT].[tblaccAccount] A
	--inner join [ACCOUNT].[tblaccAccountStatus] ASS  ON A.accStatusCode_fk=ASS.accStatusId
	--INNER JOIN [ACCOUNT].[tblaccAccountType] ATT ON A.accTypeCode_fk=ATT.accTypeId
	--WHERE A.accNumber IN (20000)
	--select @isActiv;



	IF @isActiv <>1
		BEGIN
			ROLLBACK;
			PRINT 'User is not Activated yet,';
			RETURN;
		END

		IF @accType='CHK'
			BEGIN
		  ROLLBACK;
		  PRINT 'It is for Checking Purpose .Trans are not allowed';
		  return;
			END
		ELSE IF @accType='SAV' OR @accType='CUR'
			BEGIN
					
						IF @tranCode_fk =1000 --Deposit
							BEGIN
											
								UPDATE [ACCOUNT].[tblaccAccount] SET [accBalance]=(@accBalance+ABS(@tranTransactionAmount)) WHERE [accNumber]=@tranAccountNumber_fk;

									INSERT INTO [TRANSACTIONS].[tbltranTransaction]
									(
									[tranCode],
									[tranAccountNumber_fk],
									[tranCode_fk],
									[tranDatetime],
									[tranTransactionAmount],
									[tranMerchant],
									[tranDescription],
									[RunningBalance]
									)
										 VALUES 
										 (
										 NEWID(),
										 @tranAccountNumber_fk,
										 @tranCode_fk,
										 GETDATE(),
										 ABS(@tranTransactionAmount),
										 @tranMerchant,
										 @tranDescription,
										 (@accBalance+ABS(@tranTransactionAmount))
										 )

										 PRINT 'BALANCE UPDATED sUccess Fully'
								
							END
						ELSE IF @tranCode_fk = 1001 --Withdrawal
							BEGIN

								IF  ABS(@tranTransactionAmount) <=@accBalance 
									BEGIN

									UPDATE [ACCOUNT].[tblaccAccount] SET [accBalance]=(@accBalance-ABS(@tranTransactionAmount)) WHERE [accNumber]=@tranAccountNumber_fk;

									INSERT INTO [TRANSACTIONS].[tbltranTransaction]([tranCode],[tranAccountNumber_fk],[tranCode_fk],
									[tranDatetime],
									[tranTransactionAmount],[tranMerchant],[tranDescription],[RunningBalance])
										 VALUES (NEWID(),@tranAccountNumber_fk,@tranCode_fk,GETDATE(),ABS(@tranTransactionAmount),@tranMerchant,@tranDescription,(@accBalance-ABS(@tranTransactionAmount)))

										 PRINT 'BALANCE UPDATED sUccess Fully'
									END
								ELSE 
								    BEGIN
									ROLLBACK;
									PRINT 'You have Insufficient Balance'
									return
									END
							
							END

			END
		ELSE IF @accType='LN'
			BEGIN

				IF @tranCode_fk =1000 --Deposit
							BEGIN
											
								ROLLBACK;
							PRINT 'lOAD Account Deposite is not Alloweded';
							RETURN;
								
							END
				ELSE IF @tranCode_fk = 1001 --Withdrawal
							BEGIN

								IF  ABS(@tranTransactionAmount) <=@accBalance 
									BEGIN

									PRINT ABS(@tranTransactionAmount)
									print @accBalance
									print @accBalance-ABS(@tranTransactionAmount)

									UPDATE [ACCOUNT].[tblaccAccount] SET [accBalance]=(@accBalance-ABS(@tranTransactionAmount)) WHERE [accNumber]=@tranAccountNumber_fk;

									INSERT INTO [TRANSACTIONS].[tbltranTransaction]([tranCode],[tranAccountNumber_fk],[tranCode_fk],
									[tranDatetime],
									[tranTransactionAmount],[tranMerchant],[tranDescription],[RunningBalance])
										 VALUES (NEWID(),@tranAccountNumber_fk,@tranCode_fk,GETDATE(),ABS(@tranTransactionAmount),@tranMerchant,@tranDescription,(@accBalance-ABS(@tranTransactionAmount)))

										 PRINT 'BALANCE UPDATED sUccess Fully'
									END
								ELSE 
								    BEGIN
									ROLLBACK;
									PRINT 'You have Insufficient Balance'
									return
									END
							
							END

		
			END
		ELSE
			BEGIN 
			ROLLBACK;
			print 'Could not find User Type.'
			END

		
		COMMIT TRANSACTION
		PRINT 'Record is Inserted SuccessFully'
	END TRY
		BEGIN CATCH
			ROLLBACK
		PRINT 'An Error Occured';
		SELECT @@ERROR AS ERROR,ERROR_LINE(),ERROR_MESSAGE(),ERROR_NUMBER(),ERROR_PROCEDURE(),ERROR_SEVERITY(),ERROR_STATE(),@@PACKET_ERRORS,@@TOTAL_ERRORS;

		END CATCH

END 


--testing 
INSERT INTO [VW_FactTransaction] ([tranAccountNumber_fk],[tranCode_fk],[tranTransactionAmount],[tranMerchant],[tranDescription])
values(20000,1000,50000,'Self','Self Deposite');


CREATE PROC UDP_DoingTransaction(@tranAccountNumber_fk BIGINT ,@tranCode_fk BIGINT ,@tranTransactionAmount BIGINT ,@tranMerchant VARCHAR(50),@tranDescription VARCHAR(30))
AS 
BEGIN
BEGIN TRY
	BEGIN TRANSACTION

INSERT INTO [VW_FactTransaction] ([tranAccountNumber_fk],[tranCode_fk],[tranTransactionAmount],[tranMerchant],[tranDescription])
values(@tranAccountNumber_fk,@tranCode_fk,@tranTransactionAmount,@tranMerchant,@tranDescription);



		COMMIT TRANSACTION

	END TRY
		BEGIN CATCH
			ROLLBACK
		PRINT 'An Error Occured';
		SELECT @@ERROR AS ERROR,ERROR_LINE(),ERROR_MESSAGE(),ERROR_NUMBER(),ERROR_PROCEDURE(),ERROR_SEVERITY(),ERROR_STATE(),@@PACKET_ERRORS,@@TOTAL_ERRORS;

		END CATCH

END

UPDATE  [TRANSACTIONS].[tbltranTransaction] SET [RunningBalance]=0

--testing
exec UDP_DoingTransaction '20000','1000','500000','Self','Self Deposite';

exec UDP_DoingTransaction


SELECT * FROM [TRANSACTIONS].[tbltranTransaction] 
SELECT * FROM [TRANSACTIONS].[tbltranTransactionType]
SELECT * FROM [ACCOUNT].[tblaccAccount]
SELECT * FROM [ACCOUNT].[tblaccAccountStatus]
SELECT * FROM [ACCOUNT].[tblaccAccountType]
SELECT * FROM [BANK].[tblcstCustomer]


--CREATE FUNCTION CheckingAcStatus(@accNumber bigint=0)
--Returns  bit
--as
--Return 
--BEGIN

--DECLARE @isActiv BIT = 0 ;

--select TOP(1) @isActiv=CASE WHEN  ASS.accStatusId = 1000 THEN 1
--		ELSE 0
--		END
--FROM  [ACCOUNT].[tblaccAccount] A
--inner join [ACCOUNT].[tblaccAccountStatus] ASS  ON A.accStatusCode_fk=ASS.accStatusId
--WHERE A.accNumber IN (20002)
--select @isActiv;

--return @isActiv;
--END








