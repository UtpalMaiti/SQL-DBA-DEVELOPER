--HOW TO MEASURE FRAGMENTATION?
SELECT  *  FROM SYS.DM_DB_INDEX_PHYSICAL_STATS (null, null, null, null, null)

SELECT DB_ID('PRODUCT DATABASE')			-- 5

USE [PRODUCT DATABASE]
SELECT OBJECT_ID('PRODUCTS_DATA')		-- 613577224

SELECT  *  FROM SYS.DM_DB_INDEX_PHYSICAL_STATS (5, 613577224, null, null, null)

-- IDENTIFY THE INDEX NAME:
SP_HELPINDEX 'PRODUCTS_DATA'			-- PK__PRODUCTS__A15E99B30B194540

-- REORGANIZE:
ALTER INDEX PK__PRODUCTS__A15E99B3ED7E6C30 ON PRODUCTS_DATA REORGANIZE

-- REBUILD:
ALTER INDEX PK__PRODUCTS__A15E99B3ED7E6C30 ON PRODUCTS_DATA REBUILD

-- HOW TO REBUILD AN INDEX?		IF FRAGMENTATION >= 30%
-- REBUILD : TO RECEATE THE COMPLETE INDEX. INVOLVES RESORTING OR ALL INDEX PAGES. COSTLY.
ALTER INDEX PK__PRODUCTS__A15E99B3ED7E6C30 ON PRODUCTS_DATA REBUILD			
ALTER INDEX PK__PRODUCTS__A15E99B3ED7E6C30 ON PRODUCTS_DATA REBUILD WITH (RESUMABLE = OFF)
ALTER INDEX PK__PRODUCTS__A15E99B3ED7E6C30 ON PRODUCTS_DATA REBUILD WITH (RESUMABLE = ON)

-- RESUMABLE INDEXES: SUCH INDEXES THAT CAN BE PAUSED DURING REBUILD. RESUMED AFTERWARDS.
ALTER INDEX PK__PRODUCTS__A15E99B3ED7E6C30 ON PRODUCTS_DATA PAUSE
ALTER INDEX PK__PRODUCTS__A15E99B3ED7E6C30 ON PRODUCTS_DATA RESUME

-- WE NEED TO SCHEDULE TIMELY REORGANIZE OF ALL INDEXES IN ALL TABLES ACROSS ALL DATABASES.
-- FOR THIS AUTOMATION, WE NEED TO USE "DATABASE MAINTENANCE PLANS"

--PARTITIONS
--COMPRESSIONS

--INDEXES
--STATISTICS

--INDEX REBUILD
--INDEX REORGANIZE *

--MAINTENANCE PLANS
--EXECUTION PLAN ANALYSIS

--TUNING TOOLS
--LOCKS, ISOLATION LEVELS 