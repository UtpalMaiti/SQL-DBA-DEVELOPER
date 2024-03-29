/****** Scripting replication configuration. Script Date: 7/4/2020 8:32:04 PM ******/
/****** Please Note: For security reasons, all password parameters were scripted with either NULL or an empty string. ******/

/****** Begin: Script to be run at Publisher ******/

/****** Installing the server as a Distributor. Script Date: 7/4/2020 8:32:04 PM ******/
use master
exec sp_adddistributor @distributor = N'SQLSCHOOL\SQLSERVER_1', @password = N''
GO

-- Adding the agent profiles
-- Updating the agent profile defaults
exec sp_MSupdate_agenttype_default @profile_id = 1
GO
exec sp_MSupdate_agenttype_default @profile_id = 2
GO
exec sp_MSupdate_agenttype_default @profile_id = 4
GO
exec sp_MSupdate_agenttype_default @profile_id = 6
GO
exec sp_MSupdate_agenttype_default @profile_id = 11
GO

-- Adding the distribution databases
use master
exec sp_adddistributiondb @database = N'distribution', @data_folder = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLSERVER_1\MSSQL\Data', @data_file = N'distribution.MDF', @data_file_size = 13, @log_folder = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLSERVER_1\MSSQL\Data', @log_file = N'distribution.LDF', @log_file_size = 9, @min_distretention = 0, @max_distretention = 72, @history_retention = 48, @deletebatchsize_xact = 5000, @deletebatchsize_cmd = 2000, @security_mode = 1
GO

-- Adding the distribution publishers
exec sp_adddistpublisher @publisher = N'SQLSCHOOL\SQLSERVER_1', @distribution_db = N'distribution', @security_mode = 1, @working_directory = N'E:', @trusted = N'false', @thirdparty_flag = 0, @publisher_type = N'MSSQLSERVER'
GO

exec sp_addsubscriber @subscriber = N'SQLSCHOOL\SQLSERVER_2', @type = 0, @description = N''
GO
exec sp_addsubscriber @subscriber = N'SQLSCHOOL\SQLSERVER_3', @type = 0, @description = N''
GO


/****** End: Script to be run at Publisher ******/


-- Enabling the replication database
use master
exec sp_replicationdboption @dbname = N'PRODUCT DATABASE', @optname = N'publish', @value = N'true'
GO

exec [PRODUCT DATABASE].sys.sp_addlogreader_agent @job_login = null, @job_password = null, @publisher_security_mode = 1
GO
exec [PRODUCT DATABASE].sys.sp_addqreader_agent @job_login = null, @job_password = null, @frompublisher = 1
GO
-- Adding the snapshot publication
use [PRODUCT DATABASE]
exec sp_addpublication @publication = N'SNAPSHOT_PUBLICATION', @description = N'Snapshot publication of database ''PRODUCT DATABASE'' from Publisher ''SQLSCHOOL\SQLSERVER_1''.', @sync_method = N'native', @retention = 0, @allow_push = N'true', @allow_pull = N'true', @allow_anonymous = N'true', @enabled_for_internet = N'false', @snapshot_in_defaultfolder = N'true', @compress_snapshot = N'false', @ftp_port = 21, @ftp_login = N'anonymous', @allow_subscription_copy = N'false', @add_to_active_directory = N'false', @repl_freq = N'snapshot', @status = N'active', @independent_agent = N'true', @immediate_sync = N'true', @allow_sync_tran = N'false', @autogen_sync_procs = N'false', @allow_queued_tran = N'false', @allow_dts = N'false', @replicate_ddl = 1
GO


exec sp_addpublication_snapshot @publication = N'SNAPSHOT_PUBLICATION', @frequency_type = 4, @frequency_interval = 1, @frequency_relative_interval = 1, @frequency_recurrence_factor = 0, @frequency_subday = 4, @frequency_subday_interval = 1, @active_start_time_of_day = 0, @active_end_time_of_day = 235959, @active_start_date = 0, @active_end_date = 0, @job_login = null, @job_password = null, @publisher_security_mode = 1
exec sp_grant_publication_access @publication = N'SNAPSHOT_PUBLICATION', @login = N'sa'
GO
exec sp_grant_publication_access @publication = N'SNAPSHOT_PUBLICATION', @login = N'NT AUTHORITY\SYSTEM'
GO
exec sp_grant_publication_access @publication = N'SNAPSHOT_PUBLICATION', @login = N'SQLSCHOOL\SQL_SCHOOL'
GO
exec sp_grant_publication_access @publication = N'SNAPSHOT_PUBLICATION', @login = N'NT SERVICE\SQLAgent$SQLSERVER_1'
GO
exec sp_grant_publication_access @publication = N'SNAPSHOT_PUBLICATION', @login = N'NT Service\MSSQL$SQLSERVER_1'
GO
exec sp_grant_publication_access @publication = N'SNAPSHOT_PUBLICATION', @login = N'NT SERVICE\Winmgmt'
GO
exec sp_grant_publication_access @publication = N'SNAPSHOT_PUBLICATION', @login = N'NT SERVICE\SQLWriter'
GO
exec sp_grant_publication_access @publication = N'SNAPSHOT_PUBLICATION', @login = N'SAA'
GO
exec sp_grant_publication_access @publication = N'SNAPSHOT_PUBLICATION', @login = N'LOGINFORSAM'
GO
exec sp_grant_publication_access @publication = N'SNAPSHOT_PUBLICATION', @login = N'distributor_admin'
GO

-- Adding the snapshot articles
use [PRODUCT DATABASE]
exec sp_addarticle @publication = N'SNAPSHOT_PUBLICATION', @article = N'CUSTOMERS_DATA', @source_owner = N'dbo', @source_object = N'CUSTOMERS_DATA', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'CUSTOMERS_DATA', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'SQL', @del_cmd = N'SQL', @upd_cmd = N'SQL', @filter_clause = N'[CustomerKey] >11001'

-- Adding the article filter
exec sp_articlefilter @publication = N'SNAPSHOT_PUBLICATION', @article = N'CUSTOMERS_DATA', @filter_name = N'FLTR_CUSTOMERS_DATA_1__52', @filter_clause = N'[CustomerKey] >11001', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1

-- Adding the article synchronization object
exec sp_articleview @publication = N'SNAPSHOT_PUBLICATION', @article = N'CUSTOMERS_DATA', @view_name = N'SYNC_CUSTOMERS_DATA_1__52', @filter_clause = N'[CustomerKey] >11001', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
GO
use [PRODUCT DATABASE]
exec sp_addarticle @publication = N'SNAPSHOT_PUBLICATION', @article = N'PRODUCTS_DATA', @source_owner = N'dbo', @source_object = N'PRODUCTS_DATA', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'PRODUCTS_DATA', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'SQL', @del_cmd = N'SQL', @upd_cmd = N'SQL'
GO
use [PRODUCT DATABASE]
exec sp_addarticle @publication = N'SNAPSHOT_PUBLICATION', @article = N'SALES_DATA', @source_owner = N'dbo', @source_object = N'SALES_DATA', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'none', @destination_table = N'SALES_DATA', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'SQL', @del_cmd = N'SQL', @upd_cmd = N'SQL'
GO
use [PRODUCT DATABASE]
exec sp_addarticle @publication = N'SNAPSHOT_PUBLICATION', @article = N'TIME_DATA', @source_owner = N'dbo', @source_object = N'TIME_DATA', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'TIME_DATA', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'SQL', @del_cmd = N'SQL', @upd_cmd = N'SQL'
GO

-- Adding the snapshot subscriptions
use [PRODUCT DATABASE]
exec sp_addsubscription @publication = N'SNAPSHOT_PUBLICATION', @subscriber = N'SQLSCHOOL\SQLSERVER_2', @destination_db = N'SNAPSHOT_REPLICA1', @subscription_type = N'Push', @sync_type = N'automatic', @article = N'all', @update_mode = N'read only', @subscriber_type = 0
exec sp_addpushsubscription_agent @publication = N'SNAPSHOT_PUBLICATION', @subscriber = N'SQLSCHOOL\SQLSERVER_2', @subscriber_db = N'SNAPSHOT_REPLICA1', @job_login = null, @job_password = null, @subscriber_security_mode = 1, @frequency_type = 64, @frequency_interval = 1, @frequency_relative_interval = 1, @frequency_recurrence_factor = 0, @frequency_subday = 4, @frequency_subday_interval = 5, @active_start_time_of_day = 0, @active_end_time_of_day = 235959, @active_start_date = 0, @active_end_date = 0, @dts_package_location = N'Distributor'
GO
use [PRODUCT DATABASE]
exec sp_addsubscription @publication = N'SNAPSHOT_PUBLICATION', @subscriber = N'SQLSCHOOL\SQLSERVER_3', @destination_db = N'SNAPSHOT_REPLICA2', @subscription_type = N'Push', @sync_type = N'automatic', @article = N'all', @update_mode = N'read only', @subscriber_type = 0
exec sp_addpushsubscription_agent @publication = N'SNAPSHOT_PUBLICATION', @subscriber = N'SQLSCHOOL\SQLSERVER_3', @subscriber_db = N'SNAPSHOT_REPLICA2', @job_login = null, @job_password = null, @subscriber_security_mode = 1, @frequency_type = 64, @frequency_interval = 1, @frequency_relative_interval = 1, @frequency_recurrence_factor = 0, @frequency_subday = 4, @frequency_subday_interval = 5, @active_start_time_of_day = 0, @active_end_time_of_day = 235959, @active_start_date = 0, @active_end_date = 0, @dts_package_location = N'Distributor'
GO

-- Adding the transactional publication
use [PRODUCT DATABASE]
exec sp_addpublication @publication = N'TRANSACTIONAL_PUBLICATION', @description = N'Transactional publication of database ''PRODUCT DATABASE'' from Publisher ''SQLSCHOOL\SQLSERVER_1''.', @sync_method = N'concurrent', @retention = 0, @allow_push = N'true', @allow_pull = N'true', @allow_anonymous = N'true', @enabled_for_internet = N'false', @snapshot_in_defaultfolder = N'true', @compress_snapshot = N'false', @ftp_port = 21, @ftp_login = N'anonymous', @allow_subscription_copy = N'false', @add_to_active_directory = N'false', @repl_freq = N'continuous', @status = N'active', @independent_agent = N'true', @immediate_sync = N'true', @allow_sync_tran = N'false', @autogen_sync_procs = N'false', @allow_queued_tran = N'false', @allow_dts = N'false', @replicate_ddl = 1, @allow_initialize_from_backup = N'false', @enabled_for_p2p = N'false', @enabled_for_het_sub = N'false'
GO


exec sp_addpublication_snapshot @publication = N'TRANSACTIONAL_PUBLICATION', @frequency_type = 1, @frequency_interval = 0, @frequency_relative_interval = 0, @frequency_recurrence_factor = 0, @frequency_subday = 0, @frequency_subday_interval = 0, @active_start_time_of_day = 0, @active_end_time_of_day = 235959, @active_start_date = 0, @active_end_date = 0, @job_login = null, @job_password = null, @publisher_security_mode = 1
exec sp_grant_publication_access @publication = N'TRANSACTIONAL_PUBLICATION', @login = N'sa'
GO
exec sp_grant_publication_access @publication = N'TRANSACTIONAL_PUBLICATION', @login = N'NT AUTHORITY\SYSTEM'
GO
exec sp_grant_publication_access @publication = N'TRANSACTIONAL_PUBLICATION', @login = N'SQLSCHOOL\SQL_SCHOOL'
GO
exec sp_grant_publication_access @publication = N'TRANSACTIONAL_PUBLICATION', @login = N'NT SERVICE\SQLAgent$SQLSERVER_1'
GO
exec sp_grant_publication_access @publication = N'TRANSACTIONAL_PUBLICATION', @login = N'NT Service\MSSQL$SQLSERVER_1'
GO
exec sp_grant_publication_access @publication = N'TRANSACTIONAL_PUBLICATION', @login = N'NT SERVICE\Winmgmt'
GO
exec sp_grant_publication_access @publication = N'TRANSACTIONAL_PUBLICATION', @login = N'NT SERVICE\SQLWriter'
GO
exec sp_grant_publication_access @publication = N'TRANSACTIONAL_PUBLICATION', @login = N'SAA'
GO
exec sp_grant_publication_access @publication = N'TRANSACTIONAL_PUBLICATION', @login = N'LOGINFORSAM'
GO
exec sp_grant_publication_access @publication = N'TRANSACTIONAL_PUBLICATION', @login = N'distributor_admin'
GO

-- Adding the transactional articles
use [PRODUCT DATABASE]
exec sp_addarticle @publication = N'TRANSACTIONAL_PUBLICATION', @article = N'CUSTOMERS_DATA', @source_owner = N'dbo', @source_object = N'CUSTOMERS_DATA', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'CUSTOMERS_DATA', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboCUSTOMERS_DATA]', @del_cmd = N'CALL [sp_MSdel_dboCUSTOMERS_DATA]', @upd_cmd = N'SCALL [sp_MSupd_dboCUSTOMERS_DATA]'
GO
use [PRODUCT DATABASE]
exec sp_addarticle @publication = N'TRANSACTIONAL_PUBLICATION', @article = N'PRODUCTS_DATA', @source_owner = N'dbo', @source_object = N'PRODUCTS_DATA', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'PRODUCTS_DATA', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboPRODUCTS_DATA]', @del_cmd = N'CALL [sp_MSdel_dboPRODUCTS_DATA]', @upd_cmd = N'SCALL [sp_MSupd_dboPRODUCTS_DATA]'
GO
use [PRODUCT DATABASE]
exec sp_addarticle @publication = N'TRANSACTIONAL_PUBLICATION', @article = N'TIME_DATA', @source_owner = N'dbo', @source_object = N'TIME_DATA', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'TIME_DATA', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboTIME_DATA]', @del_cmd = N'CALL [sp_MSdel_dboTIME_DATA]', @upd_cmd = N'SCALL [sp_MSupd_dboTIME_DATA]'
GO
use [PRODUCT DATABASE]
exec sp_addarticle @publication = N'TRANSACTIONAL_PUBLICATION', @article = N'View_1', @source_owner = N'dbo', @source_object = N'View_1', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'View_1', @destination_owner = N'dbo', @status = 16
GO

-- Adding the transactional subscriptions
use [PRODUCT DATABASE]
exec sp_addsubscription @publication = N'TRANSACTIONAL_PUBLICATION', @subscriber = N'SQLSCHOOL\SQLSERVER_2', @destination_db = N'TRANSACTIONAL_REPLICA1', @subscription_type = N'Push', @sync_type = N'automatic', @article = N'all', @update_mode = N'read only', @subscriber_type = 0
exec sp_addpushsubscription_agent @publication = N'TRANSACTIONAL_PUBLICATION', @subscriber = N'SQLSCHOOL\SQLSERVER_2', @subscriber_db = N'TRANSACTIONAL_REPLICA1', @job_login = null, @job_password = null, @subscriber_security_mode = 1, @frequency_type = 64, @frequency_interval = 1, @frequency_relative_interval = 1, @frequency_recurrence_factor = 0, @frequency_subday = 4, @frequency_subday_interval = 5, @active_start_time_of_day = 0, @active_end_time_of_day = 235959, @active_start_date = 0, @active_end_date = 0, @dts_package_location = N'Distributor'
GO
use [PRODUCT DATABASE]
exec sp_addsubscription @publication = N'TRANSACTIONAL_PUBLICATION', @subscriber = N'SQLSCHOOL\SQLSERVER_3', @destination_db = N'TRANSACTIONAL_REPLICA2', @subscription_type = N'Push', @sync_type = N'automatic', @article = N'all', @update_mode = N'read only', @subscriber_type = 0
exec sp_addpushsubscription_agent @publication = N'TRANSACTIONAL_PUBLICATION', @subscriber = N'SQLSCHOOL\SQLSERVER_3', @subscriber_db = N'TRANSACTIONAL_REPLICA2', @job_login = null, @job_password = null, @subscriber_security_mode = 1, @frequency_type = 64, @frequency_interval = 1, @frequency_relative_interval = 1, @frequency_recurrence_factor = 0, @frequency_subday = 4, @frequency_subday_interval = 5, @active_start_time_of_day = 0, @active_end_time_of_day = 235959, @active_start_date = 0, @active_end_date = 0, @dts_package_location = N'Distributor'
GO



