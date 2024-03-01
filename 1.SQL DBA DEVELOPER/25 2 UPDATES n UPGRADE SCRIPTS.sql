SELECT @@VERSION 

SELECT SERVERPROPERTY('ProductLevel')

SELECT  
SERVERPROPERTY('ProductVersion ') AS ProductVersion,  
SERVERPROPERTY('ProductLevel') AS ProductLevel,  
SERVERPROPERTY('ResourceVersion') AS ResourceVersion,  
SERVERPROPERTY('ResourceLastUpdateDateTime') AS ResourceLastUpdateDateTime,  
SERVERPROPERTY('Collation') AS Collation;


SELECT name, physical_name AS current_file_location  
FROM sys.master_files  
WHERE database_id IN (DB_ID('master'), DB_ID('model'), DB_ID('msdb'), DB_ID('tempdb'));

