/****** Object:  Index [im_index_data_G]    Script Date: 07/14/2017 09:42:46 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[im_index_data]') AND name = N'im_index_data_G')
DROP INDEX [im_index_data_G] ON [dbo].[im_index_data] WITH ( ONLINE = OFF )
GO

/****** Object:  Index [im_index_data_G]    Script Date: 07/14/2017 09:42:46 ******/
CREATE NONCLUSTERED INDEX [im_index_data_G] ON [dbo].[im_index_data] 
(
	[client_name] ASC
)
INCLUDE ( [link_id]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

/****** Object:  Index [im_index_data_H]    Script Date: 07/14/2017 09:43:28 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[im_index_data]') AND name = N'im_index_data_H')
DROP INDEX [im_index_data_H] ON [dbo].[im_index_data] WITH ( ONLINE = OFF )
GO

/****** Object:  Index [im_index_data_H]    Script Date: 07/14/2017 09:43:28 ******/
CREATE NONCLUSTERED INDEX [im_index_data_H] ON [dbo].[im_index_data] 
(
	[field_value] ASC,
	[client_name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO

--
-- This portion of the script alters im_info.doc_id to int identity(1,1)
--
-- Do not run the update if im_info.doc_id is already an identity
IF NOT EXISTS(SELECT * FROM sys.identity_columns 
	WHERE object_id = OBJECT_ID('[dbo].[im_info]') AND name = 'doc_id')
BEGIN

	SET NOCOUNT ON

	-- Turn on the setting that automatically rolls back if there are errors
	SET XACT_ABORT ON

	-- Start a transaction so that either all of this works or none of it does
	BEGIN TRANSACTION

	-- Drop the foreign keys that reference im_info.doc_id
	ALTER TABLE [dbo].[im_index_data] DROP CONSTRAINT [im_index_data_2]


	ALTER TABLE [dbo].[im_page] DROP CONSTRAINT [im_page_1]


	-- Drop the primary key for im_info
	ALTER TABLE [dbo].[im_info] DROP CONSTRAINT [im_info_PK]


	-- Drop indexes for im_info
	IF EXISTS (SELECT * FROM sys.indexes WHERE name='im_info_A'
		AND object_id = OBJECT_ID('[dbo].[im_info]'))
	BEGIN
		DROP INDEX [im_info_A] ON [dbo].[im_info]
	END


	IF EXISTS (SELECT * FROM sys.indexes WHERE name='im_info_B'
		AND object_id = OBJECT_ID('[dbo].[im_info]'))
	BEGIN
		DROP INDEX [im_info_B] ON [dbo].[im_info]
	END


	IF EXISTS (SELECT * FROM sys.indexes WHERE name='im_info_C'
		AND object_id = OBJECT_ID('[dbo].[im_info]'))
	BEGIN
		DROP INDEX [im_info_C] ON [dbo].[im_info]
	END


	IF EXISTS (SELECT * FROM sys.indexes WHERE name='im_info_D'
		AND object_id = OBJECT_ID('[dbo].[im_info]'))
	BEGIN
		DROP INDEX [im_info_D] ON [dbo].[im_info]
	END


	-- Declare variables
	DECLARE @constraintname SYSNAME
	DECLARE @objectid INT
	DECLARE @sqlcmd VARCHAR(1024)

	-- Find and then drop the contraints for im_info
	DECLARE CONSTRAINTSCURSOR CURSOR FOR
		SELECT name, object_id
		FROM   sys.all_objects
		WHERE  type = 'D' AND @objectid = OBJECT_ID('im_info')

	OPEN CONSTRAINTSCURSOR
	FETCH NEXT FROM CONSTRAINTSCURSOR INTO @constraintname, @objectid
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		SELECT @sqlcmd = 'ALTER TABLE ' + OBJECT_NAME(@objectid) + ' DROP CONSTRAINT ' + @constraintname
		EXEC(@sqlcmd)
		FETCH NEXT FROM CONSTRAINTSCURSOR INTO @constraintname, @objectid
	END
	CLOSE CONSTRAINTSCURSOR
	DEALLOCATE CONSTRAINTSCURSOR


	-- Create the temp_im_info defined the same way as im_info except with doc_id as identity
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	SET ANSI_PADDING ON

	CREATE TABLE [dbo].[temp_im_info](
		[access_dt] [datetime] NULL,
		[access_ttl] [int] NULL,
		[archive_dt] [datetime] NULL,
		[archived_flag] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[batch_id] [int] NULL,
		[clsid] [char](38) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[create_dt] [datetime] NULL,
		[description] [char](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[discard_dt] [datetime] NULL,
		[doc_id] [int] IDENTITY(1,1) NOT NULL,
		[doc_type] [char](16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[form_id] [char](16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[icr_flag] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[page_count] [int] NULL,
		[status] [char](16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[refresh_dt] [datetime] NULL,
		[user_id] [char](12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[viewer] [smallint] NULL,
		[storage_object] [char](36) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[email_type] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[email_address] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[attach_id] [char](36) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[client_name] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[unique_key] [char](36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT (newid()),
	 CONSTRAINT [im_info_PK] PRIMARY KEY CLUSTERED
	(
		[doc_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]


	SET ANSI_PADDING OFF


	-- Set a flag that allows inserts to be done using the full record
	SET IDENTITY_INSERT [dbo].[temp_im_info] ON


	-- Insert all records from im_info into temp_im_info
	IF EXISTS(SELECT * FROM [dbo].[im_info])
		INSERT INTO [dbo].[temp_im_info]
			(access_dt, access_ttl, archive_dt, archived_flag, batch_id, clsid, create_dt,
			description, discard_dt, doc_id, doc_type, form_id, icr_flag, page_count, status,
			refresh_dt, user_id, viewer, storage_object, email_type, email_address, attach_id,
			client_name, unique_key)
		SELECT access_dt, access_ttl, archive_dt, archived_flag, batch_id, clsid, create_dt,
			description, discard_dt, doc_id, doc_type, form_id, icr_flag, page_count, status,
			refresh_dt, user_id, viewer, storage_object, email_type, email_address, attach_id,
			client_name, unique_key
		FROM [dbo].[im_info] TABLOCKX

	-- Set the flag back off
	SET IDENTITY_INSERT [dbo].[temp_im_info] OFF


	-- Drop the im_info table
	DROP TABLE [dbo].[im_info]


	-- Rename temp_im_info to im_info
	EXEC sp_rename 'temp_im_info', 'im_info'

	-- Recreate the indexes on im_info
	CREATE UNIQUE NONCLUSTERED INDEX [im_info_A] ON [dbo].[im_info]
	(
		[unique_key] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]


	CREATE NONCLUSTERED INDEX [im_info_B] ON [dbo].[im_info]
	(
		[archived_flag] ASC,
		[client_name]
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]


	CREATE NONCLUSTERED INDEX [im_info_C] ON [dbo].[im_info]
	(
		[status] ASC,
		[client_name]
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]


	CREATE NONCLUSTERED INDEX [im_info_D] ON [dbo].[im_info]
	(
		[create_dt] ASC,
		[user_id] ASC,
		[client_name]
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]


	-- Add back the foreign keys that reference im_info.doc_id
	ALTER TABLE [dbo].[im_index_data]  WITH CHECK ADD  CONSTRAINT [im_index_data_2] FOREIGN KEY([doc_id])
	REFERENCES [dbo].[im_info] ([doc_id])


	ALTER TABLE [dbo].[im_page]  WITH CHECK ADD  CONSTRAINT [im_page_1] FOREIGN KEY([doc_id])
	REFERENCES [dbo].[im_info] ([doc_id])

	-- Commit the transaction
	COMMIT

END
--
-- End of logic that changes im_info.doc_id to an identity
--
