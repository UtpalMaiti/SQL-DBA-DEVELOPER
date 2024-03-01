SELECT 
PRODUCTS_DATA.EnglishProductName,
SUM(SALES_DATA.SalesAmount)   AS TotalSales
FROM SALES_DATA 
INNER JOIN
PRODUCTS_DATA
ON
SALES_DATA.ProductKey = PRODUCTS_DATA.ProductKey
GROUP BY PRODUCTS_DATA.EnglishProductName


CREATE VIEW VW_SALES_DATA
AS
SELECT 
PRODUCTS_DATA.EnglishProductName,
SUM(SALES_DATA.SalesAmount)   AS TotalSales
FROM SALES_DATA 
INNER JOIN
PRODUCTS_DATA
ON
SALES_DATA.ProductKey = PRODUCTS_DATA.ProductKey
GROUP BY PRODUCTS_DATA.EnglishProductName



CREATE PROCEDURE SP_SALES_DATA (@ProductKey INT)
AS
SELECT 
PRODUCTS_DATA.EnglishProductName,
SUM(SALES_DATA.SalesAmount)   AS TotalSales
FROM SALES_DATA 
INNER JOIN
PRODUCTS_DATA
ON
SALES_DATA.ProductKey = PRODUCTS_DATA.ProductKey
WHERE
PRODUCTS_DATA.ProductKey > @ProductKey
GROUP BY PRODUCTS_DATA.EnglishProductName


EXEC SP_SALES_DATA 100



CREATE FUNCTION FN_SALES_DATA (@ProductKey INT)
RETURNS TABLE
AS
RETURN
(
SELECT 
PRODUCTS_DATA.EnglishProductName,
SUM(SALES_DATA.SalesAmount)   AS TotalSales
FROM SALES_DATA 
INNER JOIN
PRODUCTS_DATA
ON
SALES_DATA.ProductKey = PRODUCTS_DATA.ProductKey
WHERE
PRODUCTS_DATA.ProductKey > @ProductKey
GROUP BY PRODUCTS_DATA.EnglishProductName
)



SELECT * FROM FN_SALES_DATA(100)


CREATE TRIGGER TRIGGER_PROD_UPDATES
ON PRODUCTS_DATA
FOR UPDATE
AS
PRINT 'GIVEN UPDATES ARE SUCCESSFUL.'


UPDATE PRODUCTS_DATA SET [StandardCost] = [StandardCost] + 0.1



-- CLONE AN EXISTING TABLE:
SELECT * INTO PRODUCTS_DATA2 FROM PRODUCTS_DATA


-- VERIFY THE NUMBER OF PARTITIONS FOR PRODUCTS_DATA TABLE
SELECT * FROM SYS.PARTITIONS WHERE OBJECT_ID = OBJECT_ID('PRODUCTS_DATA2')	-- 1 PARTITION


-- REQUIREMENT:	HOW TO PARTITION THE DATABASE BASED ON PRODUCT CLASS?
SELECT	* FROM PRODUCTS_DATA2
SELECT	CLASS FROM PRODUCTS_DATA2
SELECT	DISTINCT CLASS FROM PRODUCTS_DATA2		-- OUTPUT IS AUTO SORTED, BUT NULL IS LISTED FIRST


CREATE PARTITION FUNCTION PART_FUN_CLASS (NCHAR(2))
AS RANGE RIGHT
FOR VALUES ('H', 'L', 'M')			-- LISTED IN ALPHABETICAL ORDER


/*
(1,100,200)
LEFT	:	ALL VALUES UPTO 1	=	PARTITION 1
			2 TO 100			=	PARTITION 2
			101 TO 200			=	PARTITION 3
			ALL VALUES ABOVE 200=	PARTITION 4


RIGHT	:	ALL VALUES < 1		=	PARTITION 1
			1 TO 99				=	PARTITION 2
			100 TO 199			=	PARTITION 3
			ALL VALUES FROM 200	=	PARTITION 4
*/



CREATE PARTITION SCHEME PART_SCHEME_CLASS  
AS PARTITION PART_FUN_CLASS
ALL TO ('PRIMARY')



-- HOW TO PARTITION AN EXISTING TABLE?
SP_HELP 'PRODUCTS_DATA2'				-- INDEITFY THE CLUSTERED INDEX
SELECT * FROM SYS.PARTITIONS WHERE OBJECT_ID = OBJECT_ID('PRODUCTS_DATA2')				-- 1 PARTITION

CREATE CLUSTERED INDEX CLUS_IND_PROD_DATA2 ON PRODUCTS_DATA2(PRODUCTKEY) ON PART_SCHEME_CLASS(CLASS)

SELECT * FROM SYS.PARTITIONS WHERE OBJECT_ID = OBJECT_ID('PRODUCTS_DATA2')				-- 4 PARTITIONS

