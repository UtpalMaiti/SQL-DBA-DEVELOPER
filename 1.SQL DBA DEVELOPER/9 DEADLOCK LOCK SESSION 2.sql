USE tempdb
GO

CREATE TABLE tblInventory  
(
  ID INT NOT NULL PRIMARY KEY,
  TitleTag NVARCHAR(100) NOT NULL,
  Measure INT NOT NULL DEFAULT 0
)

INSERT tblInventory VALUES
  (113, 'BUSN PROFILES', 100),  (114, 'PB CHAPTER BKS', 100),
  (115, 'BEG READER HC', 100),  (116, 'Literature', 100);

SELECT * FROM tblInventory			-- 4 ROWS


SET DEADLOCK_PRIORITY HIGH	-- MEANS: CURRENT SESSION CAN BE DEADLOCK WINNER INCASE OF ANY DEADLOCK.


BEGIN TRAN T2
UPDATE tblInventory SET Measure = 1000
UPDATE tblOrders SET Measure = 10000
COMMIT TRAN T2

-- TILL HERE :  T2 IS BLOCKED BY T1

-- NOW EXECUTE THE REMAINING PART OF T1
