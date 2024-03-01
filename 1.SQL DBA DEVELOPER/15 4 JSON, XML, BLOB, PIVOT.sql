USE [DB_OBJECTS]
GO

 CREATE TABLE SheepCountingWords
    (
    Number INT NOT NULL,
    Word VARCHAR(40) NOT NULL
    );

 
-- java script object notation. used by web developers and cloud admins, for data transfer

INSERT INTO  SheepCountingWords
SELECT  Number, Word 
FROM 	OpenJson	(	'[					
				{"number": 11,  "word": "Yan-a-dik"}, 
				{"number": 12,  "word": "Tan-a-dik"}, 
				{"number": 13,  "word": "Tethera-dik"}, 
				{"number": 14,  "word": "Pethera-dik"}, 
				{"number": 15,  "word": "Bumfit"}, 
				{"number": 16,  "word": "Yan-a-bumtit"}, 
				{"number": 17,  "word": "Tan-a-bumfit"}, 
				{"number": 18,  "word": "Tethera-bumfit"}, 
				{"number": 19,  "word": "Pethera-bumfit"}, 
				{"number": 20,  "word": "Figgot"}
				]'
		) WITH (Number INT '$.number', Word VARCHAR(30) '$.word')

SELECT * FROM SheepCountingWords



select * from SheepCountingWords FOR XML AUTO	-- HORIZONTAL, TAG NAME = TABLE NAME. single table
select * from SheepCountingWords FOR XML PATH	-- VERTICAL, TAG NAME = "ROW". FOR WEB REPORTING
select * from SheepCountingWords FOR XML RAW	-- HORIZONTAL, TAG NAME = "ROW". join of multiple tables


-- BLOB : BINARY LARGE OBJECT DATA
CREATE TABLE tblStore
(
id int identity,
content varbinary(max)			-- THIS COLUMN CAN STORE UPTO 2 GB DATA PER VALUE. 
)

INSERT INTO tblStore(content) 
SELECT bulkcolumn FROM OPENROWSET(BULK 'E:\AzureBI-Training.pdf', SINGLE_BLOB) AS SubQuery


SELECT * FROM tblStore	-- WE USE CAST()  AND CONVERT()  TO REPORT DATA IN TEXT FORMAT. 



/* 
PIVOT OPERATION
PIVOT IS A MECHANISM TO CONVERT UNIQUE COLUMN VALUES TO COLUMNS. 
EX: 'SalesYear' COLUMN VALUES ARE : 2014, 2015, 2016, 2017.   */

CREATE TABLE #ServiceSales (ServiceType VARCHAR(80), SalesYear INT, NoOfLeads int);
 
INSERT #ServiceSales VALUES 	('SQL SEVER TRAINING', 2014, 1200),
	('SQL SEVER TRAINING', 2015, 1900),('SQL SEVER TRAINING', 2016, 2300);
INSERT #ServiceSales VALUES	('SQL DBA TRAINING', 2014, 4000),
	('SQL DBA TRAINING', 2015, 5500), ('SQL DBA TRAINING', 2016, 5900);
INSERT #ServiceSales VALUES	('MSBI TRAINING', 2014, 900),
	('MSBI TRAINING', 2015, 1800),   ('MSBI TRAINING', 2016, 2300)
INSERT #ServiceSales VALUES	('POWER BI TRAINING',2016,150),('POWER BI TRAINING',2017,100);
INSERT #ServiceSales VALUES	('CASE STUDIES n PROJECTS', 2015, 1000),
	('CASE STUDIES n PROJECTS', 2016, 2800),('CASE STUDIES n PROJECTS', 2017, 4000);

SELECT * FROM #ServiceSales				-- denormalized

SELECT * FROM #ServiceSales
PIVOT ( sum(NoOfLeads) FOR SalesYear IN ([2014])) as PivotQuery 

SELECT * FROM #ServiceSales
PIVOT ( sum(NoOfLeads) FOR SalesYear IN ([2014], [2015])) as PivotQuery 

SELECT * FROM #ServiceSales
PIVOT ( sum(NoOfLeads) FOR SalesYear IN ([2014], [2015], [2016])) as PivotQuery 

SELECT * FROM #ServiceSales
PIVOT ( sum(NoOfLeads) FOR SalesYear IN ([2014], [2015], [2016], [2017])) as PivotQuery		-- normalized

SELECT  * FROM #ServiceSales
PIVOT ( sum(NoOfLeads) FOR SalesYear IN ([2014], [2015], [2016], [2017])) as PivotQuery		-- normalized


-- SCALAR FUNCTIONS
-- TABLE VALUED FUNCTIONS  [INLINE, MULTILINE]
-- OPENJSON()
-- OPENROWSET()
-- PIVOT

