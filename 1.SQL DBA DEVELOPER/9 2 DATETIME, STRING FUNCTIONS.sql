SELECT GETDATE()									-- REPORTS CURRENT DATE & TIME

SELECT CONVERT(VARCHAR(30), GETDATE(), 101)			-- mm/dd/yyyy   (STYLES)
SELECT CONVERT(VARCHAR(40), GETDATE(), 102)			-- yyyy.mm.dd
SELECT CONVERT(VARCHAR(20), GETDATE(), 103)			-- dd/mm/yyyy
SELECT CONVERT(VARCHAR(35), GETDATE(), 104)			-- dd.mm.yyyy
SELECT CONVERT(VARCHAR(30), GETDATE(), 105)			-- dd-mm-yyyy
SELECT CONVERT(VARCHAR(30), GETDATE(), 106)			-- dd MON YYYY
SELECT CONVERT(VARCHAR(30), GETDATE(), 107)			-- MON dd, YYYY

SELECT CONVERT(VARCHAR(30), GETDATE(), 108)			-- TIME 

SELECT CONVERT(VARCHAR(30), GETDATE(), 109)			-- DATE & TIME

SELECT YEAR(GETDATE())
SELECT MONTH(GETDATE())
SELECT DAY(GETDATE())

SELECT DATEDIFF(d, '2019-12-12', '2020-12-12') 		-- REPORTS DIFFERENCE IN DAYS
SELECT DATEADD(d, 60, '2020-01-31')					-- ADDS n NUMBER OF DAYS TO EXISTING DATE


SELECT REPLACE('SQL SERVER', 'SQL','SEQUEL')	-- REPLACE TEXT IN A GIVEN STRING
SELECT REVERSE('SQL SERVER')					-- REVERSE THE TEXT
SELECT LEN('SQL SERVER')						-- REPORTS NUMBER OF CHARACTERS
SELECT UPPER('SQL Server')						-- REPORTS UPPER CASE TEXT
SELECT LOWER('SQL Server')						-- REPORTS LOWER CASE TEXT
SELECT SUBSTRING('SQL Server', 5, 3)			-- REPORTS 3 CHARACTERS FROM 5TH POSITION
SELECT LEFT('SQL Server', 3)					-- REPORTS STARTING 3 CHARACTERS FROM STRING
SELECT RIGHT('SQL Server', 7)					-- REPORTS LAST 7 CHARACTERS FROM STRING
SELECT ltrim ('  SQLserver')					-- TRUNCATE EXTRA SPACES BEFORE THE TEXT 
SELECT Rtrim ('SQLserver    ')					-- TRUNCATE EXTRA SPACES AFTER THE TEXT
SELECT CHARINDEX('d' , 'Indigo Montoya');  		-- REPORT POSITION OF CHARACTER
SELECT STUFF('ABCDE', 3, 2, ' ')				-- FROM 3RD POSITION, REPLACE 2 CHARACTERS WITH SPACE
SELECT STUFF('SQLSERVER', 3, 1, 'L ')			-- FROM 3RD POSITION, REPLACE 1 CHARACTER WITH 'L '

SELECT VALUE FROM STRING_SPLIT('SQL Server T-SQL Queries', ' ');

