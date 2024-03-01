-- STEP 1: CHECK IF DATABASE EXISTS. IF EXISTS, DROP THE DATABASE:

IF EXISTS (SELECT * FROM SYS.DATABASES WHERE NAME = 'BankingDB')
	DROP DATABASE BankingDB
	

-- STEP 2: CREATE DATABASE 
CREATE DATABASE BankingDB


-- STEP 3: CONNECT TO ABOVE CREATED DATABASE
USE BankingDB
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

ALTER TABLE ACCOUNT.tblaccAccountStatus ALTER COLUMN accStatusId BIGINT NOT NULL
ALTER TABLE ACCOUNT.tblaccAccountStatus ADD CONSTRAINT PK_accStatusId PRIMARY KEY (accStatusId)

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



CREATE TABLE TRANSACTIONS.tbltranTransaction
( 
tranID BIGINT IDENTITY (1000,1),
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

SELECT * FROM BANK.tblBank				-- accessing the table using schema
SELECT * FROM synBank					-- accessing the table using synonym


-- NEXT: VERIFY THE TABLES AND RELATIONS USING "DATABASE DIAGRAMS"

------------------------  PHASE 2 REQUIREMENT :: QUERIES & SUB QUERIES --------------		
-- SEND ME YOUR SOLUTIONS (.SQL FILE) FOR BELOW QUERY REQUIREMENTS:

SELECT * FROM  [ACCOUNT].[tblaccAccount]
SELECT * FROM  [TRANSACTIONS].[tbltranTransaction]
SELECT * FROM  [ACCOUNT].[tblaccAccount]
SELECT * FROM  [ACCOUNT].[tblaccAccount]
SELECT * FROM  [ACCOUNT].[tblaccAccount]

-- 1. CREATE FUNCTION TO GET ACCOUNT STATEMENT FOR A GIVEN CUSTOMER ?
CREATE FUNCTION UDF_ACCOUNT_STATEMENT(@cstID BIGINT=0)
returns  TABLE 
AS
return
(
SELECT 
T.tranID,
T.tranDateTime,
T.tranTransactionAmount,
T.tranMerchant,
T.[tranDescription],
TT.tranTypeDesc,
A.accNumber,
--A.accBalance,
C.cstID,
C.cstFirstName
FROM [TRANSACTIONS].[tbltranTransaction] T
LEFT OUTER LOOP JOIN [TRANSACTIONS].[tbltranTransactionType] TT ON  T.tranCode_fk=TT.tranCodeID
LEFT OUTER LOOP JOIN [ACCOUNT].[tblaccAccount] A ON  T.tranAccountNumber_fk=A.accNumber
LEFT OUTER LOOP JOIN [BANK].[tblcstCustomer] C ON  C.cstID=A.accCustomerId_fk
WHERE C.cstID IN (@cstID)
)

SELECT * FROM UDF_ACCOUNT_STATEMENT(20009) ORDER BY tranID DESC,tranDateTime DESC

-- 2. List all Banks and their Branches with total number of Accounts in each Branch

SELECT 
B.[bankId],
B.[bankDetails],
BB.[brBranchName],
--A.[accNumber],
COUNT([brBranchName]) AS TotalNumberOfAc
FROM [BANK].[tblBank] B
LEFT OUTER LOOP JOIN [BANK].[tblbrBranch] BB ON B.bankId=BB.brBankId_fk
LEFT OUTER LOOP JOIN [BANK].[tblcstCustomer] C ON C.cstBranchId_fk=BB.brID
INNER LOOP JOIN [ACCOUNT].[tblaccAccount] A ON A.accCustomerId_fk=C.cstID
GROUP BY  B.[bankId],B.[bankDetails],BB.[brBranchName]
--,A.[accNumber]
ORDER BY  B.[bankId]

-- 3. List total number of Customers for each Branch

SELECT 
BB.[brBranchName],
--A.[accNumber],
COUNT([brBranchName]) AS TotalNumberOfAc
FROM [BANK].[tblbrBranch] BB
LEFT OUTER LOOP JOIN [BANK].[tblcstCustomer] C ON C.cstBranchId_fk=BB.brID
INNER  LOOP JOIN [ACCOUNT].[tblaccAccount] A ON A.accCustomerId_fk=C.cstID
GROUP BY  BB.[brBranchName]
--,A.[accNumber]



-- 4. Find all Customer Accounts that does not have any Transaction

SELECT 
C.[cstID],
C.[cstFirstName],
A.accNumber
FROM [BANK].[tblcstCustomer] C
INNER  LOOP JOIN [ACCOUNT].[tblaccAccount] A ON C.cstID=A.accCustomerId_fk
WHERE   A.accNumber NOT IN (SELECT DISTINCT [tranAccountNumber_fk] FROM [TRANSACTIONS].[tbltranTransaction] T)
 
--SELECT DISTINCT [tranAccountNumber_fk] FROM [TRANSACTIONS].[tbltranTransaction] T

-- 5. Rank the Customers for each Bank & Branch based on number of Transactions. 

WITH CTE AS(
SELECT 
B.[bankId],
B.[bankDetails],
BB.[brBranchName],
C.cstID,
--T.tranID,
--A.[accNumber],
COUNT(*) AS TotalNumberOfTran
FROM [BANK].[tblBank] B
LEFT OUTER LOOP JOIN [BANK].[tblbrBranch] BB ON B.bankId=BB.brBankId_fk
LEFT OUTER LOOP JOIN [BANK].[tblcstCustomer] C ON C.cstBranchId_fk=BB.brID
INNER LOOP JOIN [ACCOUNT].[tblaccAccount] A ON A.accCustomerId_fk=C.cstID
INNER LOOP JOIN [TRANSACTIONS].[tbltranTransaction] T ON A.accNumber=T.tranAccountNumber_fk
GROUP BY  B.[bankId],B.[bankDetails],BB.[brBranchName],C.cstID
--,T.tranID
--,A.[accNumber]

)
SELECT * ,
dense_Rank()over(Partition by [bankDetails],[brBranchName] order by [bankDetails] desc,[brBranchName] desc,TotalNumberOfTran desc) as DenseRank_num,
Rank()over(Partition by [bankDetails],[brBranchName] order by [bankDetails] desc,[brBranchName] desc,TotalNumberOfTran desc) as Rank_num,
ROW_number()over(Partition by [bankDetails],[brBranchName] order by [bankDetails],[brBranchName],TotalNumberOfTran desc) as Row_num
FROM CTE
--ORDER BY DenseRank_num

--   Customer with maximum number of Transaction gets 1 Rank (Position)

-- 6. MONTHLY STATEMENT transactions for a given month for a given customer id

DECLARE @SelectedYear int=2020,@MonthName varchar(20)='April', @CustomerID bigint=20009
SELECT 
T.tranID,
T.tranDateTime,
T.tranTransactionAmount,
T.tranMerchant,
T.[tranDescription],
TT.tranTypeDesc,
A.accNumber,
--A.accBalance,
C.cstID,
C.cstFirstName
FROM [TRANSACTIONS].[tbltranTransaction] T
LEFT OUTER LOOP JOIN [TRANSACTIONS].[tbltranTransactionType] TT ON  T.tranCode_fk=TT.tranCodeID
LEFT OUTER LOOP JOIN [ACCOUNT].[tblaccAccount] A ON  T.tranAccountNumber_fk=A.accNumber
LEFT OUTER LOOP JOIN [BANK].[tblcstCustomer] C ON  C.cstID=A.accCustomerId_fk
WHERE C.cstID IN (@CustomerID) and YEAR(T.tranDateTime)=@SelectedYear AND 
--MONTH(T.tranDateTime)=0
DATENAME(month,T.tranDateTime)=@MonthName
ORDER BY T.tranID DESC,T.tranDateTime DESC

-- 7. LIST OF ALL CUSTOMERS WITH ACCOUNTS, NO TRANSACTIONS

SELECT 
C.[cstID],
C.[cstFirstName],
A.accNumber
FROM [BANK].[tblcstCustomer] C
left outer  LOOP JOIN [ACCOUNT].[tblaccAccount] A ON C.cstID=A.accCustomerId_fk
WHERE   A.accNumber NOT IN (SELECT DISTINCT [tranAccountNumber_fk] FROM [TRANSACTIONS].[tbltranTransaction] T)

-- 8. LIST OF ALL ZIP CODES WITH MISSING CUSTOMER ADDRESS


SELECT 
DISTINCT
[addPostCode]
FROM [BANK].[tbladdAddress] AD
LEFT OUTER LOOP JOIN [BANK].[tblcstCustomer] C ON AD.addId=C.cstAddID_fk
WHERE AD.addLine1 IS NULL OR AD.addLine2 IS NULL



-- 9. LIST OF ALL CUSTOMERS WITH ACCOUNTS BASED ON ACCOUNT STATUS & TYPES WITHOUT ANY TRANSACTIONS

SELECT 
C.[cstID],
C.[cstFirstName],
ATT.accTypeDesc,
A.accNumber,
ASS.accStatusDesc
FROM [BANK].[tblcstCustomer] C
left outer  LOOP JOIN [ACCOUNT].[tblaccAccount] A ON C.cstID=A.accCustomerId_fk
INNER  LOOP JOIN [ACCOUNT].[tblaccAccountType] ATT ON A.accTypeCode_fk=ATT.accTypeID
INNER   LOOP JOIN [ACCOUNT].[tblaccAccountStatus] ASS ON A.accStatusCode_fk=ASS.accStatusID
WHERE   A.accNumber NOT IN (SELECT DISTINCT [tranAccountNumber_fk] FROM [TRANSACTIONS].[tbltranTransaction] T)


-- 10. LIST OF ALL BANKS BASED ON CUSTOMERS AND TRANSACTION AMOUNTS

SELECT 
B.bankDetails,
C.cstID,
C.cstFirstName,
T.tranTransactionAmount,
T.tranID
FROM [BANK].[tblBank] B
LEFT OUTER LOOP JOIN [BANK].[tblbrBranch] BB ON B.bankId=BB.brBankId_fk
LEFT OUTER LOOP JOIN [BANK].[tblcstCustomer] C ON C.cstBranchId_fk=BB.brID
INNER LOOP JOIN [ACCOUNT].[tblaccAccount] A ON A.accCustomerId_fk=C.cstID
INNER LOOP JOIN [TRANSACTIONS].[tbltranTransaction] T ON A.accNumber=T.tranAccountNumber_fk

--SELECT YEAR('2020-04-20 19:32:27.943'),DATENAME(month,GETATE())
--SELECT * FROM [BANK].[tblBank] B
--SELECT * FROM [BANK].[tblbrBranch] BB
--SELECT * FROM [BANK].[tblbtBranchType] BT
--SELECT * FROM [TRANSACTIONS].[tbltranTransaction] T
--SELECT * FROM [ACCOUNT].[tblaccAccount] A
--SELECT * FROM [BANK].[tblcstCustomer] C
--SELECT * FROM [BANK].[tbladdAddress] AD


-- Please mail me your answers. IN REPLY TO YOUR ANSWERS, I SHALL MAIL YOU MY ANSWERS
--THEN : YOU SHALL REVISE STORED PROCEDURES, TRANSACTIONS, TRIGGERS, VIEWS, INDEXED VIEWS : FOR PHASE 3

	
	