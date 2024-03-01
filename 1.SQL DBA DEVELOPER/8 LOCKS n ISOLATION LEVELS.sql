/*  
ISOLATION LEVELS ARE A MECHANISM TO CONTROL THE DEGREE OF DEPENDANCY BETWEEN 
TRANSACTIONS. THESE ISOLATION LEVELS OPERATE AND CAN BE CONTROLLED AT SESSION LEVEL. 
*/

USE TRANTEST
GO

-- ISOLATION LEVEL #1: READ COMMITTED ISOLATION LEVEL  [default isolation level for every session]
-- WRITERS BLOCK READERS [OTHER SESSIONS THAT HAVE OPEN TRANSACTIONS WITH DMLs]
SET TRANSACTION ISOLATION LEVEL READ COMMITTED		-- WE CAN READ COMMITTED DATA IF THERE ARE NO PENDING COMMITS
SELECT * FROM [Product]								-- BLOCKING. REASON : DUE TO LOCK WAITS

-- ISOLATION LEVEL #2: READ UNCOMMITTED ISOLATION LEVEL
-- WRITERS DO NOT BLOCK READERS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	-- WE CAN READ COMMITTED & UNCOMITED DATA EVEN IF THERE ARE PENDING COMMITS
SELECT * FROM [Product]								-- NO BLOCKING BUT DIRTY READS. MEANS : NO LOCK WAITS

-- ISOLATION LEVEL #3: SERIALIZABLE ISOLATION LEVEL
-- READERS (SELECT)  BLOCK WRITERS (INSERTS, UPDATES, DELETES). 
-- WRITERS (INSERTS, UPDATES, DELETES) BLOCK READERS  (SELECT).
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
SELECT * FROM [Product]					-- BLOCKING


-- ISOLATION LEVEL #4: SNAPSHOT ISOLATION LEVEL
-- READERS DO NOT BLOCK WRITERS. WRITERS DO NOT BLOCK READERS.
-- OFFERS BETTER PERFORMANCE, USES TEMPDB FOR "PAGE VERSIONING". EACH PAGE LOADED TO TEMPDB. 
-- OPEN TRANSACTION DATA IS OPERATED ON TEMPDB.

ALTER DATABASE TRANTEST SET ALLOW_SNAPSHOT_ISOLATION  ON
USE TRANTEST
GO
SET TRANSACTION ISOLATION LEVEL SNAPSHOT
SELECT * FROM Product					-- NO BLOCKING AND NO DIRTY READS


-- ISOLATION LEVEL #5: REPEATABLE READ ISOLATION LEVEL
-- APPLICABLE FOR REPEATED READS (SELECTS) WITHIN A TRANSACTION. 
-- "S" LOCKS ARE HELD UNTIL END OF TRANSACTION.
-- ISSUE : "PHANTOM READS".  SAME QUERY RESULTS IN DIFFERENT OUTPUT AT DIFFERENT TIMES WITHIN A SINGLE TRANSACTION.
-- APPLICABLE FOR REPORTING SOLUTIONS : SSRS, POWER BI, TABLEU, QLICKVIEW ...

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION T1
SELECT * FROM Product		-- LOCKS ARE ALLOCATED AT START OF THE TRANSACTION
-- FEW DML / DDL OPERATIONS
SELECT * FROM Product		-- LOCKS ARE REUSED
-- FEW DML / DDL OPERATIONS
SELECT * FROM Product		-- LOCKS ARE REUSED
COMMIT TRANSACTION T1		-- LOCKS ARE RELEASED AT END OF THE TRANSACTION


-- ISOLATION LEVEL #6: READ COMMITTED SNAPSHOT ISOLATION LEVEL
-- APPLICABLE FOR SUCH SCENARIOS WITH FREQUENT DML OPERATIONS WITHIN A TRANSACTION.
-- SHARED LOCKS ARE RELEASED IMMEDIATELY AFTER THE SELECT QUERY BUT "ROW VERSION" MAINTAINED IN TEMPDB
SET TRANSACTION ISOLATION LEVEL READ_COMMITTED_SNAPSHOT

SELECT * FROM Product	-- NO BLOCKING, NO DIRTY READS. NO PHANTOM READS.  
						-- LESSER TEMPDB SPACE FOR ROW VERSIONING.


						
						/*********  WHEN TO USE WHICH ISOLATON LEVEL ********/

-- 1. READ COMMITTED :			Used for Data Access, Data Modification Environments
-- 2. READ UNCOMITTED:			Used in Testing and Audit Environments
-- 3. SERIALIZABLE :			Used in Mission Critical Operations, Payment Gateways
-- 4. SNAPSHOT :				Used for DML operations on smaller tables 
-- 5. REPEATABLE READ :			Used IN REPORTING ENVIRONMENTS  
-- 6. READ COMITTED SNAPSHOT:	USED FOR DML OPERATIONS IN REAL-TIME OLTP DATABASES



/*
ACTIVITY MONITOR	
DMVs & DMFs

INDEXES
STATISTICS

PARTITIONS
COMPRESSIONS

INDEX FRAGMENTATION
DATABASE MAINTENANCE PLANS

TUNING TOOLS
	PROFILER
	DTA 
QUERY COSTS
	IO COST
	CPU COST
	OPERATOR COST
	SUB TREE COST

LOCKS
ISOLATION LEVELS */
