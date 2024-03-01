CREATE DATABASE BANKING_PROJECT
GO
USE BANKING_PROJECT
GO
CREATE SCHEMA BANK
GO 
CREATE SCHEMA ACCOUNT
GO
CREATE SCHEMA TRANSACTIONS
GO
DROP TABLE BANK.tblBank
CREATE TABLE BANK.tblBank(
bankId BIGINT PRIMARY KEY identity(1000,1),
bankDetails VARCHAR(50)
);
GO
CREATE TABLE BANK.tbladdAddress(
addId BIGINT PRIMARY KEY,
addLine1 VARCHAR(100),
addLine2 VARCHAR(50),
addPostCode VARCHAR(15),
addState VARCHAR(50),
addCountry VARCHAR(50)
);
GO

CREATE TABLE BANK.tblbtBranchType(
btId BIGINT PRIMARY KEY identity(1000,1),
btTypeCode VARCHAR(4),
btTypeDesc VARCHAR(100)
);
GO

--DROP TABLE if exists BANK.tbladdAddress;

--DROP TABLE BANK.tbladdAddress

GO
CREATE TABLE BANK.tblbrBranch(
brID BIGINT PRIMARY KEY identity(1000,1),
brAddress_fk BIGINT foreign key references BANK.tbladdAddress(addId) on delete cascade,
brBankId_fk BIGINT foreign key references BANK.tblBank(bankId) on delete cascade,
brBranchTypeCode_fk BIGINT foreign key references BANK.tblbtBranchType(btId) on delete cascade,
brBranchName VARCHAR(100),
brBranchPhone1 VARCHAR(20),
brBranchPhone2 VARCHAR(20),
brBranchFax VARCHAR(20),
brBranchemail VARCHAR(50),
brBranchIFSC VARCHAR(20)
);

GO
CREATE TABLE BANK.tblcstCustomer(
cstID BIGINT PRIMARY KEY identity(1000,1),
cstAddID_fk BIGINT foreign key references BANK.tbladdAddress(addId) ,
cstBranchId_fk BIGINT foreign key references BANK.tblbrBranch(brID) on delete cascade,
cstFirstName VARCHAR(50),
cstLastName VARCHAR(50),
cstMiddleName VARCHAR(20),
cstDOB DATE,
cstSince datetime,
cstPhone1 VARCHAR(20),
cstPhone2 VARCHAR(20),
cstFax VARCHAR(20),
cstGender VARCHAR(10),
cstemail VARCHAR(50)
);

GO
CREATE TABLE [ACCOUNT].tblaccAccountType(
accTypeID BIGINT PRIMARY KEY identity(1000,1),
accTypeCode VARCHAR(10) ,
accTypeDesc VARCHAR(100) 
);

GO
CREATE TABLE [ACCOUNT].tblaccAccountStatus(
accStatusID BIGINT PRIMARY KEY identity(1000,1),
accStatusCode VARCHAR(10) ,
accStatusDesc VARCHAR(50) 
);

GO
CREATE TABLE [ACCOUNT].tblaccAccount(
accNumber BIGINT PRIMARY KEY identity(1000,1),
accStatusCode_fk BIGINT foreign key references [ACCOUNT].tblaccAccountStatus(accStatusID) on delete cascade ,
accTypeCode_fk BIGINT foreign key references [ACCOUNT].tblaccAccountType(accTypeID) on delete cascade ,
accCustomerId_fk BIGINT foreign key references BANK.tblcstCustomer(cstID) on delete cascade ,
accBalance DECIMAL(26,4) DEFAULT 0 
);

GO
CREATE TABLE [TRANSACTIONS].tbltranTransactionType(
tranCodeID BIGINT PRIMARY KEY identity(1000,1),
tranTypeDesc VARCHAR(50)
)

SELECT NEWID()

CREATE TABLE [TRANSACTIONS].tbltranTransaction(
tranID BIGINT PRIMARY KEY identity(1000,1),
tranCode VARCHAR(50) DEFAULT NEWID(),
tranAccountNumber_fk BIGINT foreign key references [ACCOUNT].tblaccAccount(accNumber) on delete cascade ,
tranCode_fk BIGINT foreign key references [TRANSACTIONS].tbltranTransactionType(tranCodeID) on delete cascade ,
tranDateTime datetime DEFAULT GETDATE(),
tranTransactionAmount DECIMAL(26,4) DEFAULT 0 ,
tranMerchant VARCHAR(50),
tranDescription VARCHAR(50),
RunningBalance DECIMAL(26,4) DEFAULT NULL 
);
GO
--empid int identity(1,1)

--alter table BANK.tblBank alter column [bankId] BIGINT identity(1000,1)
--alter table BANK.tblBank add identity(1000,1) ([bankId])
--add primary key (empid)
--ALTER TABLE 

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

SELECT * FROM BANK.tblBank

GO

--alter table BANK.tblBank DROP COLUMN addCity  
alter table BANK.tbladdAddress Add addCity VARCHAR(50) 

INSERT INTO BANK.tbladdAddress (addLine1,addLine2,addCity,addPostCode,addState,addCountry) VALUES('9730 37th Place North','Apt#204','Plymouth','55441','MN','USA')
INSERT INTO BANK.tbladdAddress (addLine1,addLine2,addCity,addPostCode,addState,addCountry) VALUES('Kombettu House','Padavu, Ujirpade Post Balnad','Puttur','574203','Karnataka','India')
INSERT INTO BANK.tbladdAddress (addLine1,addLine2,addCity,addPostCode,addState,addCountry) VALUES('302, Sai Manor Towers','X Roads, SR Nagar','Hyderabad','574038','Andra Pradesh','India')

SELECT * FROM BANK.tbladdAddress

go

INSERT INTO BANK.tblbtBranchType (btTypeCode,btTypeDesc) VALUES ('LU','Large Urban')
INSERT INTO BANK.tblbtBranchType (btTypeCode,btTypeDesc) VALUES ('SR','Small Rural')
INSERT INTO BANK.tblbtBranchType (btTypeCode,btTypeDesc) VALUES ('HO','Head Office')

SELECT * FROM BANK.tblbtBranchType

GO

INSERT INTO Bank.tblbrBranch(brAddress_fk,brBankId_fk,brBranchTypeCode_fk,brBranchName,brBranchPhone1,brBranchPhone2,brBranchFax,brBranchemail,brBranchIFSC) VALUES (1000,1011,1001,'Golden Valley','1 323 416 4705','1 323 416 4095','1 763 954 1522','wellsfargogv@wellsfargo.com','WFGV1015')
INSERT INTO Bank.tblbrBranch(brAddress_fk,brBankId_fk,brBranchTypeCode_fk,brBranchName,brBranchPhone1,brBranchPhone2,brBranchFax,brBranchemail,brBranchIFSC) VALUES (1001,1007,1002,'Mangalore','91 824 247623','91 824 247624','91 824 247625','banker25@karnatakabank.com','KBIN05267')
INSERT INTO Bank.tblbrBranch(brAddress_fk,brBankId_fk,brBranchTypeCode_fk,brBranchName,brBranchPhone1,brBranchPhone2,brBranchFax,brBranchemail,brBranchIFSC) VALUES (1002,1000,1000,'Puttur Market','91 8251 249246','91 8251 249247','91 8251 249244','sbi.04270@sbi.co.in','SBIN004270')

SELECT * FROM Bank.tblbrBranch

GO

INSERT INTO BANK.tblcstCustomer (cstAddId_fk,cstBranchId_fk,cstFirstName,cstLastName,CstMiddleName,cstDOB,cstSince,cstPhone1,cstPhone2,cstFax,cstGender,cstemail) VALUES (1000,1000,'Nithin','Kumar','','9-Nov-1985','1996','1 323 416 4705','','','Male','x')
INSERT INTO BANK.tblcstCustomer (cstAddId_fk,cstBranchId_fk,cstFirstName,cstLastName,CstMiddleName,cstDOB,cstSince,cstPhone1,cstPhone2,cstFax,cstGender,cstemail) VALUES (1001,1001,'Gaurao','Tarpe','','25-Dec-1986','2000','91 824 247623','','','Male','y')
INSERT INTO BANK.tblcstCustomer (cstAddId_fk,cstBranchId_fk,cstFirstName,cstLastName,CstMiddleName,cstDOB,cstSince,cstPhone1,cstPhone2,cstFax,cstGender,cstemail) VALUES (1002,1002,'Chaithra','Kunjathaya','Nithin','19-Jan-1990','2005','91 8251 249246','','','Female','y')
INSERT INTO BANK.tblcstCustomer (cstAddId_fk,cstBranchId_fk,cstFirstName,cstLastName,CstMiddleName,cstDOB,cstSince,cstPhone1,cstPhone2,cstFax,cstGender,cstemail) VALUES (1001,1001,'Adarsh','Hegde','','19-Jan-1990','2015','91 8251 249246','','','Male','y')
INSERT INTO BANK.tblcstCustomer (cstAddId_fk,cstBranchId_fk,cstFirstName,cstLastName,CstMiddleName,cstDOB,cstSince,cstPhone1,cstPhone2,cstFax,cstGender,cstemail) VALUES (1000,1002,'Nithin','Kumar','','9-Nov-1985','1996','1 323 416 4705','','','Male','y')
INSERT INTO BANK.tblcstCustomer (cstAddId_fk,cstBranchId_fk,cstFirstName,cstLastName,CstMiddleName,cstDOB,cstSince,cstPhone1,cstPhone2,cstFax,cstGender,cstemail) VALUES (1000,1000,'Nathan','Kamas','','10-Nov-1985','1996','1 323 416 4705','','','Male','y')

SELECT * FROM BANK.tblcstCustomer

DBCC CHECKIDENT ('BANK.tblcstCustomer', RESEED, 20000)  

DELETE  BANK.tblcstCustomer
TRUNCATE TABLE BANK.tblcstCustomer

GO

--SET IDENTITY_INSERT ACCOUNT.tblaccAccountType ON


INSERT INTO ACCOUNT.tblaccAccountType VALUES ('CHK','Checking')
INSERT INTO ACCOUNT.tblaccAccountType VALUES ('SAV','Saving')
INSERT INTO ACCOUNT.tblaccAccountType VALUES ('CUR','Current')
INSERT INTO ACCOUNT.tblaccAccountType VALUES ('LN','Loan')

go

INSERT INTO ACCOUNT.tblaccAccountStatus VALUES ('A','Active')
INSERT INTO ACCOUNT.tblaccAccountStatus VALUES ('C','Closed')
GO

INSERT INTO ACCOUNT.tblaccAccount  (accStatusCode_fk,accTypeCode_fk,accCustomerId_fk,accBalance) VALUES (1000,1001,1001,10000)
INSERT INTO ACCOUNT.tblaccAccount  (accStatusCode_fk,accTypeCode_fk,accCustomerId_fk,accBalance) VALUES (1001,1000,1003,200000.9897)
INSERT INTO ACCOUNT.tblaccAccount  (accStatusCode_fk,accTypeCode_fk,accCustomerId_fk,accBalance) VALUES (1001,1001,1002,30000.456)
INSERT INTO ACCOUNT.tblaccAccount  (accStatusCode_fk,accTypeCode_fk,accCustomerId_fk,accBalance) VALUES (1001,1000,11003,5000)
INSERT INTO ACCOUNT.tblaccAccount  (accStatusCode_fk,accTypeCode_fk,accCustomerId_fk,accBalance) VALUES (1001,1000,11004,500)
INSERT INTO ACCOUNT.tblaccAccount  (accStatusCode_fk,accTypeCode_fk,accCustomerId_fk,accBalance) VALUES (1001,1000,21004,50000)

DBCC CHECKIDENT ('ACCOUNT.tblaccAccount', RESEED, 19999)  

DELETE  ACCOUNT.tblaccAccount
TRUNCATE TABLE ACCOUNT.tblaccAccount

SELECT * FROM ACCOUNT.tblaccAccount
go

INSERT INTO TRANSACTIONS.tbltranTransactionType(tranTypeDesc) VALUES ('Deposit')
INSERT INTO TRANSACTIONS.tbltranTransactionType(tranTypeDesc) VALUES ('Withdrawal')

go

INSERT INTO TRANSACTIONS.tbltranTransaction (tranAccountNumber_fk,tranCode_fk,tranTransactionAmount,tranMerchant,tranDescription) VALUES (20001,1000,20500.456,'Self','Self Deposit')
INSERT INTO TRANSACTIONS.tbltranTransaction (tranAccountNumber_fk,tranCode_fk,tranTransactionAmount,tranMerchant,tranDescription) VALUES (20000,1001,200000,'Discover','Withdrawal')
INSERT INTO TRANSACTIONS.tbltranTransaction (tranAccountNumber_fk,tranCode_fk,tranTransactionAmount,tranMerchant,tranDescription) VALUES (20002,1001,13.45,'','Cheque #5001')
INSERT INTO TRANSACTIONS.tbltranTransaction (tranAccountNumber_fk,tranCode_fk,tranTransactionAmount,tranMerchant,tranDescription) VALUES (20001,1000,2500,'Self','Self Deposit')
INSERT INTO TRANSACTIONS.tbltranTransaction (tranAccountNumber_fk,tranCode_fk,tranTransactionAmount,tranMerchant,tranDescription) VALUES (20000,1000,25000,'Discover','Withdrawal')
INSERT INTO TRANSACTIONS.tbltranTransaction (tranAccountNumber_fk,tranCode_fk,tranTransactionAmount,tranMerchant,tranDescription) VALUES (20002,1000,1300.45,'','Cheque #5001')
INSERT INTO TRANSACTIONS.tbltranTransaction (tranAccountNumber_fk,tranCode_fk,tranTransactionAmount,tranMerchant,tranDescription) VALUES (20001,1000,20500.456,'Self','Self Deposit')
INSERT INTO TRANSACTIONS.tbltranTransaction (tranAccountNumber_fk,tranCode_fk,tranTransactionAmount,tranMerchant,tranDescription) VALUES (20000,1001,200000,'Discover','Withdrawal')
INSERT INTO TRANSACTIONS.tbltranTransaction (tranAccountNumber_fk,tranCode_fk,tranTransactionAmount,tranMerchant,tranDescription) VALUES (20002,1001,13.45,'','Cheque #5001')
INSERT INTO TRANSACTIONS.tbltranTransaction (tranAccountNumber_fk,tranCode_fk,tranTransactionAmount,tranMerchant,tranDescription) VALUES (20001,1000,20500.456,'Self','Self Deposit')
INSERT INTO TRANSACTIONS.tbltranTransaction (tranAccountNumber_fk,tranCode_fk,tranTransactionAmount,tranMerchant,tranDescription) VALUES (20001,1000,20500.456,'Self','Self Deposit')
INSERT INTO TRANSACTIONS.tbltranTransaction (tranAccountNumber_fk,tranCode_fk,tranTransactionAmount,tranMerchant,tranDescription) VALUES (20000,1001,200000,'Discover','Withdrawal')
INSERT INTO TRANSACTIONS.tbltranTransaction (tranAccountNumber_fk,tranCode_fk,tranTransactionAmount,tranMerchant,tranDescription) VALUES (30001,1000,20500.456,'Self','Self Deposit')
INSERT INTO TRANSACTIONS.tbltranTransaction (tranAccountNumber_fk,tranCode_fk,tranTransactionAmount,tranMerchant,tranDescription) VALUES (30002,1000,20500.456,'Self','Self Deposit')
INSERT INTO TRANSACTIONS.tbltranTransaction (tranAccountNumber_fk,tranCode_fk,tranTransactionAmount,tranMerchant,tranDescription) VALUES (40002,1001,25000,'Discover','Withdrawal')


SELECT * FROM TRANSACTIONS.tbltranTransaction















