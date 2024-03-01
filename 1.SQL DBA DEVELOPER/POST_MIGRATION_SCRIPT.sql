
-- ON THE TARGET DATABASE, AFTER MIGRATION: 

-- TESTING DATA:
SELECT * FROM PRODUCTS_DATA2

-- TESTING PARTITIONS:
SELECT * FROM SYS.PARTITIONS WHERE OBJECT_ID = OBJECT_ID('PRODUCTS_DATA2')	

-- TESTING TRIGGERS:
UPDATE PRODUCTS_DATA SET [StandardCost] = [StandardCost] + 0.1


SELECT * FROM SYS.partition_schemes
SELECT * FROM SYS.partition_functions


-- HOW TO MANAGE or EDIT PARTITIONS?
-- OPTION 1: PARTITION SPLIT
-- OPTION 2: PARTITION MERGE

-- PARTITION SPLIT  : A MECHANISM TO ADD NEW PARTITIONS TO EXISTING LIST. TABLE DATA IS AUTOMATICALLY REARRANGED.
ALTER PARTITION SCHEME PART_SCHEME_CLASS   NEXT USED [PRIMARY] 
ALTER PARTITION FUNCTION  PART_FUN_CLASS()	SPLIT RANGE ('X')


-- PARTITION MERGE : A MECHANISM TO REDUCE (COMBINE THE DATA FROM) EXISTING PARTITIONS. 
-- TABLE DATA AUTOMATICALLY REARRANGED.

SELECT * FROM SYS.PARTITIONS WHERE OBJECT_ID = OBJECT_ID('PRODUCTS_DATA2')	

ALTER PARTITION FUNCTION  PART_FUN_CLASS() MERGE RANGE ('L')							H				M
ALTER PARTITION FUNCTION  PART_FUN_CLASS() MERGE RANGE ('M')
ALTER PARTITION FUNCTION  PART_FUN_CLASS() MERGE RANGE ('H')


-- ITEM #15: HOW TO VERIFY ABOVE PARTITION MERGE?
SELECT * FROM SYS.PARTITIONS WHERE OBJECT_ID = OBJECT_ID('PRODUCTS_DATA2')				 

SELECT * FROM PRODUCTS_DATA2