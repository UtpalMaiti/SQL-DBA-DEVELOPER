--Create User ora8pm Identified by tiger; 
--Grant Connect to ora8pm
--Grant Resource to ora8pm;
-- Alter User <username> Identified by <New Password>;
--Alter User ora8pm Identified by ora8pm;
--      Select * from Dba_Users;    

--syntax:
--  Drop User <username> [CASCADE];
--example: 
--    Drop User ora8pm;    --  inside DBA user only to execute
--    Drop user ora8pm Cascade;      --  inside DBA user only to execute