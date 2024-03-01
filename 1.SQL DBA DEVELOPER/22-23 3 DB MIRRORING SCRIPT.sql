SELECT * INTO MIRROR_TEST FROM SYSMESSAGES 

/*
SERVER1:		FULL BACKUP, LOG BACKUP
SERVER2:		RESTORE FULL, LOG. IN RESTORING STATE

SERVER1:		RIGHT CLICK DATABASE > TASKS > MIRROR > CONFIGURE SECURITY
				START MIRRORING.
				SERVER 1:	PRINCIPAL
				SERVER 2:	MIRROR

				STOP SERVER1. THEN AUTOMATED FAILOVER OCCURS
				SERVER 2:	PRINCIPAL. PERFORM OPERATIONS.
				BRING SERVER1 ONLINE
				SERVER 2:	PRINCIPAL
				SERVER 1:	MIRROR

FROM SERVER 2:	RIGHT CLICK PRINCIPAL DATABASE > TASKS > MIRROR > FAILOVER  [MANUAL]
				SERVER 1:	PRINCIPAL. VERIFY THE CHANGES 
				SERVER 2:	MIRROR
				
				STOP SERVER3. THEN AUTOMATED FAILOVER WILL NOT HAPPEN
				STOP SERVER1. THEN WE CANNOT PERFORM MANUAL FAILOVER.
							  SO, WE NEED TO USE T-SQL SCRIPTS AND GET DATABASE ONLINE.
FROM SERVER 2:  STEP 1:	DISABLE DATABASE MIRRORING  
						FROM SERVER 2:	ALTER DATABASE [PROD_DATABASE] SET PARTNER OFF
				STEP 2:	GET DATABASE ONLINE
					    RESTORE DATABASE [PROD_DATABASE] WITH RECOVERY 



