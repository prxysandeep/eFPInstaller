/*************************************************************** CATALOG TABLES ***************************************************************/

/****** Object:  Table [dbo].[application] ******/
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[application]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[application](
	[app_id] [uniqueidentifier] NOT NULL DEFAULT (newid()),
	[profile_id] [uniqueidentifier] NOT NULL,
	[app_name] [varchar](256) NOT NULL,
	[display_name] [varchar](256) NULL,
	[program_location] [varchar](max) NULL,
	[program_name] [varchar](max) NULL,
	[argument_values] [varchar](max) NULL,
	[is_visible] [bit] NOT NULL,
 CONSTRAINT [PK_application] PRIMARY KEY CLUSTERED 
(
	[app_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO


/****** Object:  Table [dbo].[business_entity] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[business_entity]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[business_entity](
	[entity_id] [varchar](20) NOT NULL,
	[entity_name] [varchar](50) NOT NULL,
	[is_locked] [bit] NOT NULL,
	[crm_id] [varchar](20) NULL,
 CONSTRAINT [PK_business_entity] PRIMARY KEY CLUSTERED 
(
	[entity_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO

/****** Object:  Table [dbo].[cattb_dbtype] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cattb_dbtype]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[cattb_dbtype](
	[code] [varchar](20) NOT NULL,
	[description] [varchar](50) NOT NULL,
 CONSTRAINT [PK_cattb_dbtype] PRIMARY KEY CLUSTERED 
(
	[code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO

/****** Object:  Table [dbo].[cattb_product] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cattb_product]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[cattb_product](
	[code] [varchar](64) NOT NULL,
	[description] [varchar](50) NOT NULL,
 CONSTRAINT [PK_cattb_product] PRIMARY KEY CLUSTERED 
(
	[code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO

/****** Object:  Table [dbo].[database_info] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[database_info]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[database_info](
	[db_id] [uniqueidentifier] NOT NULL DEFAULT (newid()),
	[db_name] [varchar](256) NOT NULL,
	[sql_server_info] [varchar](max) NOT NULL,
	[username] [varchar](max) NOT NULL,
	[password] [varchar](max) NULL,
	[db_type] [varchar](20) NOT NULL,
	[column_encryption] [bit] NOT NULL DEFAULT (0),
 CONSTRAINT [PK_database_info] PRIMARY KEY CLUSTERED 
(
	[db_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
ELSE
BEGIN
	IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'database_info' AND COLUMN_NAME = 'column_encryption')
		ALTER TABLE [dbo].[database_info] ADD [column_encryption] [bit] NOT NULL DEFAULT (0)
END
GO
SET ANSI_PADDING OFF
GO

/****** Object:  Table [dbo].[entity_profile] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[entity_profile]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[entity_profile](
	[profile_id] [uniqueidentifier] NOT NULL DEFAULT (newid()),
	[profile_name] [varchar](128) NOT NULL,
	[entity_id] [varchar](20) NOT NULL,
	[is_locked] [bit] NOT NULL,
	[major_version] [varchar](20) NOT NULL,
	[minor_version] [varchar](20) NOT NULL,
	[build_number] [varchar](20) NOT NULL,
	[product_id] [varchar](64) NOT NULL,
 CONSTRAINT [PK_entity_profile] PRIMARY KEY CLUSTERED 
(
	[profile_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO

/****** Object:  Table [dbo].[global_variable] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[global_variable]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[global_variable](
	[var_name] [varchar](50) NOT NULL,
	[var_value] [varchar](max) NULL,
	[product_id] [varchar](64) NOT NULL,
	[is_env_variable] [bit] NOT NULL,
	[order_id] [int] NULL,
 CONSTRAINT [PK_global_variable] PRIMARY KEY CLUSTERED 
(
	[var_name] ASC,
	[product_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO

/****** Object:  Table [dbo].[profile_db_link] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[profile_db_link]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[profile_db_link](
	[profile_id] [uniqueidentifier] NOT NULL,
	[db_id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_profile_db_link] PRIMARY KEY CLUSTERED 
(
	[profile_id] ASC,
	[db_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

/****** Object:  Table [dbo].[profile_service_link] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[profile_service_link]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[profile_service_link](
	[profile_id] [uniqueidentifier] NOT NULL,
	[service_id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_profile_service_link] PRIMARY KEY CLUSTERED 
(
	[profile_id] ASC,
	[service_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

/****** Object:  Table [dbo].[profile_variable] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[profile_variable]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[profile_variable](
	[profile_id] [uniqueidentifier] NOT NULL,
	[var_name] [varchar](50) NOT NULL,
	[var_value] [varchar](max) NOT NULL,
	[is_env_variable] [bit] NOT NULL,
	[order_id] [int] NULL,
 CONSTRAINT [PK_profile_variable] PRIMARY KEY CLUSTERED 
(
	[profile_id] ASC,
	[var_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO

/****** Object:  Table [dbo].[service_info] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[service_info]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[service_info](
	[service_id] [uniqueidentifier] NOT NULL,
	[service_type] [char](2) NOT NULL,
	[server_name] [varchar](50) NOT NULL,
	[service_name] [varchar](36) NOT NULL,
 CONSTRAINT [PK_service_info] PRIMARY KEY CLUSTERED 
(
	[service_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO

/****** Object:  Table [dbo].[spi_error_info] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spi_error_info]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[spi_error_info](
	[session_error_id] [int] IDENTITY(1,1) NOT NULL,
	[session_id] [varchar](40) NULL,
	[application_name] [varchar](100) NULL,
	[request_method] [varchar](5) NULL,
	[server_port] [int] NULL,
	[https] [varchar](3) NULL,
	[server_name] [varchar](15) NULL,
	[client_ip] [varchar](15) NULL,
	[auth_user] [varchar](50) NULL,
	[client_browser] [varchar](255) NULL,
	[url] [varchar](400) NULL,
	[query_string] [varchar](4096) NULL,
	[reference_id] [varchar](36) NULL,
	[database_name] [varchar](50) NULL,
	[form_data] [text] NULL,
	[http_headers] [text] NULL,
	[application_vars] [text] NULL,
	[session_vars] [text] NULL,
	[error_date_time] [datetime] NOT NULL,
	[is_cookieless] [bit] NULL,
	[is_new_session] [bit] NULL,
	[controller] [varchar](50) NULL,
	[action] [varchar](50) NULL,
 CONSTRAINT [PK_spi_error_info] PRIMARY KEY NONCLUSTERED 
(
	[session_error_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_PADDING ON

GO

/****** Object:  Index [cix_spi_error_info] ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[spi_error_info]') AND name = N'cix_spi_error_info')
CREATE CLUSTERED INDEX [cix_spi_error_info] ON [dbo].[spi_error_info]
(
	[error_date_time] ASC,
	[session_error_id] ASC,
	[session_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[spi_exception_info] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spi_exception_info]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[spi_exception_info](
	[exception_id] [int] IDENTITY(1,1) NOT NULL,
	[exception_level] [int] NOT NULL,
	[session_error_id] [int] NOT NULL,
	[exception_source] [varchar](200) NULL,
	[stack_trace] [text] NULL,
	[error_message] [text] NULL,
	[target_site] [varchar](100) NULL,
 CONSTRAINT [pK_spi_exception_info] PRIMARY KEY NONCLUSTERED 
(
	[exception_id] ASC,
	[exception_level] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO

/****** Object:  Index [cix_spi_exception_info] ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[spi_exception_info]') AND name = N'cix_spi_exception_info')
CREATE CLUSTERED INDEX [cix_spi_exception_info] ON [dbo].[spi_exception_info]
(
	[session_error_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[task_schedule] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[task_schedule]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[task_schedule](
	[task_id] [uniqueidentifier] NOT NULL DEFAULT (newid()),
	[profile_id] [uniqueidentifier] NOT NULL,
	[app_id] [uniqueidentifier] NOT NULL,
	[task_key] [varchar](30) NULL,
	[task_type] [varchar](255) NULL,
	[related_page] [varchar](max) NULL,
	[task_description] [varchar](255) NOT NULL,
	[scheduled_time] [datetime] NOT NULL,
	[task_status] [char](1) NOT NULL,
	[task_owner] [varchar](20) NOT NULL,
	[task_server] [varchar](255) NULL,
	[next_run_time] [datetime] NULL,
	[last_run_time] [datetime] NULL,
	[schedule_type] [char](1) NULL,
	[schd_interval] [smallint] NULL,
	[schd_dow] [smallint] NULL,
	[queue_position] [int] NULL,
	[change_date_time] [datetime] NOT NULL,
	[change_uid] [varchar](20) NOT NULL,
 CONSTRAINT [PK_SPI_TASK] PRIMARY KEY NONCLUSTERED 
(
	[task_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO

/****** Object:  Table [dbo].[task_schedule_archive] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[task_schedule_archive]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[task_schedule_archive](
	[task_id] [uniqueidentifier] NOT NULL DEFAULT (newid()),
	[profile_id] [uniqueidentifier] NOT NULL,
	[app_id] [uniqueidentifier] NOT NULL,
	[task_key] [varchar](30) NULL,
	[task_type] [varchar](255) NULL,
	[related_page] [varchar](max) NULL,
	[task_description] [varchar](255) NOT NULL,
	[scheduled_time] [datetime] NOT NULL,
	[task_status] [char](1) NOT NULL,
	[task_owner] [varchar](20) NOT NULL,
	[task_server] [varchar](255) NULL,
	[next_run_time] [datetime] NULL,
	[last_run_time] [datetime] NULL,
	[schedule_type] [char](1) NULL,
	[schd_interval] [smallint] NULL,
	[schd_dow] [smallint] NULL,
	[queue_position] [int] NULL,
	[delete_datetime] [datetime] NOT NULL,
 CONSTRAINT [PK_task_schedule_archive] PRIMARY KEY NONCLUSTERED 
(
	[task_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO

/****** Object:  Table [dbo].[task_schedule_history] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[task_schedule_history]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[task_schedule_history](
	[history_id] [uniqueidentifier] NOT NULL DEFAULT (newid()),
	[task_id] [uniqueidentifier] NOT NULL,
	[profile_id] [uniqueidentifier] NOT NULL,
	[app_id] [uniqueidentifier] NOT NULL,
	[task_key] [varchar](30) NULL,
	[task_type] [varchar](255) NULL,
	[task_description] [varchar](255) NOT NULL,
	[scheduled_time] [datetime] NOT NULL,
	[run_time] [datetime] NOT NULL,
	[completion_time] [datetime] NULL,
	[task_server] [varchar](255) NOT NULL,
	[schedule_type] [char](1) NULL,
	[task_status] [char](1) NOT NULL,
 CONSTRAINT [PK_task_schedule_history] PRIMARY KEY NONCLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO

/****** Object:  Table [dbo].[token] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[token]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[token](
	[token_id] [uniqueidentifier] NOT NULL,
	[username] [varchar](max) NOT NULL,
	[profile_id] [uniqueidentifier] NOT NULL,
	[application_id] [uniqueidentifier] NOT NULL,
	[create_datetime] [datetime] NOT NULL,
	[empl_no] [int] NULL,
 CONSTRAINT [PK_token] PRIMARY KEY CLUSTERED 
(
	[token_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO


/****** Object:  Table [dbo].[token_archive] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[token_archive]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[token_archive](
	[token_id] [uniqueidentifier] NOT NULL,
	[username] [varchar](max) NOT NULL,
	[profile_id] [uniqueidentifier] NOT NULL,
	[application_id] [uniqueidentifier] NOT NULL,
	[create_datetime] [datetime] NOT NULL,
	[delete_datetime] [datetime] NOT NULL,
	[empl_no] [int] NULL,
 CONSTRAINT [PK_token_archive] PRIMARY KEY CLUSTERED 
(
	[token_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO

/****** Object:  Table [dbo].[user_access] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[user_access]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[user_access](
	[username] [varchar](256) NOT NULL,
 CONSTRAINT [PK_user_access] PRIMARY KEY CLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO

/****** Object:  Table [dbo].[user_variable] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[user_variable]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[user_variable](
	[username] [varchar](256) NOT NULL,
	[var_name] [varchar](50) NOT NULL,
	[var_value] [varchar](max) NOT NULL,
	[is_env_variable] [bit] NOT NULL,
	[major_version] [varchar](20) NOT NULL,
	[order_id] [int] NOT NULL,
 CONSTRAINT [PK_user_variable] PRIMARY KEY CLUSTERED 
(
	[username] ASC,
	[var_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO

/****** Object:  Table [dbo].[profile_integration] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[profile_integration]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[profile_integration](
	[profile_id] [uniqueidentifier] NOT NULL,
	[integration_type] [varchar](20) NOT NULL,
	[uri_endpoint] [varchar](max) NOT NULL,
	[client_id] [varchar](max) NOT NULL,
	[client_secret] [varchar](max) NOT NULL,
	[auth_endpoint] [varchar](max) NULL,
	[token] [varchar](max) NULL,
	[change_date_time] [datetime] NULL,
	[change_uid] [varchar](256) NULL,
PRIMARY KEY CLUSTERED 
(
	[profile_id] ASC,
	[integration_type] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO

/****** Object:  Table [dbo].[profile_hostname] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[profile_hostname]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[profile_hostname](
	[profile_id] [uniqueidentifier] NOT NULL,
	[hostname] [varchar](max) NOT NULL,
 CONSTRAINT [PK_profile_hostname] PRIMARY KEY CLUSTERED 
(
	[profile_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO

/*************************************************************** foreign_keys ***************************************************************/

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_application_entity_profile]') AND parent_object_id = OBJECT_ID(N'[dbo].[application]'))
ALTER TABLE [dbo].[application]  WITH CHECK ADD  CONSTRAINT [FK_application_entity_profile] FOREIGN KEY([profile_id])
REFERENCES [dbo].[entity_profile] ([profile_id])
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_application_entity_profile]') AND parent_object_id = OBJECT_ID(N'[dbo].[application]'))
ALTER TABLE [dbo].[application] CHECK CONSTRAINT [FK_application_entity_profile]
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_database_info_cattb_dbtype]') AND parent_object_id = OBJECT_ID(N'[dbo].[database_info]'))
ALTER TABLE [dbo].[database_info]  WITH CHECK ADD  CONSTRAINT [FK_database_info_cattb_dbtype] FOREIGN KEY([db_type])
REFERENCES [dbo].[cattb_dbtype] ([code])
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_database_info_cattb_dbtype]') AND parent_object_id = OBJECT_ID(N'[dbo].[database_info]'))
ALTER TABLE [dbo].[database_info] CHECK CONSTRAINT [FK_database_info_cattb_dbtype]
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_entity_profile_business_entity]') AND parent_object_id = OBJECT_ID(N'[dbo].[entity_profile]'))
ALTER TABLE [dbo].[entity_profile]  WITH CHECK ADD  CONSTRAINT [FK_entity_profile_business_entity] FOREIGN KEY([entity_id])
REFERENCES [dbo].[business_entity] ([entity_id])
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_entity_profile_business_entity]') AND parent_object_id = OBJECT_ID(N'[dbo].[entity_profile]'))
ALTER TABLE [dbo].[entity_profile] CHECK CONSTRAINT [FK_entity_profile_business_entity]
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_entity_profile_cattb_product]') AND parent_object_id = OBJECT_ID(N'[dbo].[entity_profile]'))
ALTER TABLE [dbo].[entity_profile]  WITH CHECK ADD  CONSTRAINT [FK_entity_profile_cattb_product] FOREIGN KEY([product_id])
REFERENCES [dbo].[cattb_product] ([code])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_entity_profile_cattb_product]') AND parent_object_id = OBJECT_ID(N'[dbo].[entity_profile]'))
ALTER TABLE [dbo].[entity_profile] CHECK CONSTRAINT [FK_entity_profile_cattb_product]
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_global_variable_cattb_product]') AND parent_object_id = OBJECT_ID(N'[dbo].[global_variable]'))
ALTER TABLE [dbo].[global_variable]  WITH CHECK ADD  CONSTRAINT [FK_global_variable_cattb_product] FOREIGN KEY([product_id])
REFERENCES [dbo].[cattb_product] ([code])
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_global_variable_cattb_product]') AND parent_object_id = OBJECT_ID(N'[dbo].[global_variable]'))
ALTER TABLE [dbo].[global_variable] CHECK CONSTRAINT [FK_global_variable_cattb_product]
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_profile_service_link_entity_profile]') AND parent_object_id = OBJECT_ID(N'[dbo].[profile_service_link]'))
ALTER TABLE [dbo].[profile_service_link]  WITH CHECK ADD  CONSTRAINT [FK_profile_service_link_entity_profile] FOREIGN KEY([profile_id])
REFERENCES [dbo].[entity_profile] ([profile_id])
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_profile_service_link_entity_profile]') AND parent_object_id = OBJECT_ID(N'[dbo].[profile_service_link]'))
ALTER TABLE [dbo].[profile_service_link] CHECK CONSTRAINT [FK_profile_service_link_entity_profile]
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_profile_service_link_service_info]') AND parent_object_id = OBJECT_ID(N'[dbo].[profile_service_link]'))
ALTER TABLE [dbo].[profile_service_link]  WITH CHECK ADD  CONSTRAINT [FK_profile_service_link_service_info] FOREIGN KEY([service_id])
REFERENCES [dbo].[service_info] ([service_id])
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_profile_service_link_service_info]') AND parent_object_id = OBJECT_ID(N'[dbo].[profile_service_link]'))
ALTER TABLE [dbo].[profile_service_link] CHECK CONSTRAINT [FK_profile_service_link_service_info]
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_task_schedule_application]') AND parent_object_id = OBJECT_ID(N'[dbo].[task_schedule]'))
ALTER TABLE [dbo].[task_schedule]  WITH CHECK ADD  CONSTRAINT [FK_task_schedule_application] FOREIGN KEY([app_id])
REFERENCES [dbo].[application] ([app_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_task_schedule_application]') AND parent_object_id = OBJECT_ID(N'[dbo].[task_schedule]'))
ALTER TABLE [dbo].[task_schedule] CHECK CONSTRAINT [FK_task_schedule_application]
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_task_schedule_entity_profile]') AND parent_object_id = OBJECT_ID(N'[dbo].[task_schedule]'))
ALTER TABLE [dbo].[task_schedule]  WITH CHECK ADD  CONSTRAINT [FK_task_schedule_entity_profile] FOREIGN KEY([profile_id])
REFERENCES [dbo].[entity_profile] ([profile_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_task_schedule_entity_profile]') AND parent_object_id = OBJECT_ID(N'[dbo].[task_schedule]'))
ALTER TABLE [dbo].[task_schedule] CHECK CONSTRAINT [FK_task_schedule_entity_profile]
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_token_entity_profile]') AND parent_object_id = OBJECT_ID(N'[dbo].[token]'))
ALTER TABLE [dbo].[token]  WITH CHECK ADD  CONSTRAINT [FK_token_entity_profile] FOREIGN KEY([profile_id])
REFERENCES [dbo].[entity_profile] ([profile_id])
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_token_entity_profile]') AND parent_object_id = OBJECT_ID(N'[dbo].[token]'))
ALTER TABLE [dbo].[token] CHECK CONSTRAINT [FK_token_entity_profile]
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_profile_db_link_entity_profile]') AND parent_object_id = OBJECT_ID(N'[dbo].[profile_db_link]'))
ALTER TABLE [dbo].[profile_db_link]  WITH CHECK ADD  CONSTRAINT [FK_profile_db_link_entity_profile] FOREIGN KEY([profile_id])
REFERENCES [dbo].[entity_profile] ([profile_id])
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_profile_db_link_entity_profile]') AND parent_object_id = OBJECT_ID(N'[dbo].[profile_db_link]'))
ALTER TABLE [dbo].[profile_db_link] CHECK CONSTRAINT [FK_profile_db_link_entity_profile]
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_profile_variable_entity_profile]') AND parent_object_id = OBJECT_ID(N'[dbo].[profile_variable]'))
ALTER TABLE [dbo].[profile_variable]  WITH CHECK ADD  CONSTRAINT [FK_profile_variable_entity_profile] FOREIGN KEY([profile_id])
REFERENCES [dbo].[entity_profile] ([profile_id])
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_profile_variable_entity_profile]') AND parent_object_id = OBJECT_ID(N'[dbo].[profile_variable]'))
ALTER TABLE [dbo].[profile_variable] CHECK CONSTRAINT [FK_profile_variable_entity_profile]
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_profile_db_link_database_info]') AND parent_object_id = OBJECT_ID(N'[dbo].[profile_db_link]'))
ALTER TABLE [dbo].[profile_db_link]  WITH CHECK ADD  CONSTRAINT [FK_profile_db_link_database_info] FOREIGN KEY([db_id])
REFERENCES [dbo].[database_info] ([db_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_profile_db_link_database_info]') AND parent_object_id = OBJECT_ID(N'[dbo].[profile_db_link]'))
ALTER TABLE [dbo].[profile_db_link] CHECK CONSTRAINT [FK_profile_db_link_database_info]
GO

/*************************************************************** FUNCTION ***************************************************************/

/****** Object:  UserDefinedFunction [dbo].[spi_get_application] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spi_get_application]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

CREATE FUNCTION [dbo].[spi_get_application](@AppId uniqueidentifier, @ProfileId uniqueidentifier)
RETURNS @retAppTable TABLE
(
    app_id uniqueidentifier,
	profile_id uniqueidentifier,
	app_name varchar(256),
	display_name varchar(256),
	program_location varchar(max), 
	program_name varchar(max),
	argument_values varchar(max),
	is_visible bit 
)
AS
BEGIN

   IF (@AppId is NOT null) and (LEN(@AppId) <> 0)
		INSERT INTO @retAppTable SELECT app_id, profile_id, app_name, display_name,
										program_location, program_name, argument_values, is_visible bit
								 FROM [dbo].application
								 WHERE app_id = @AppId
	
		RETURN;
END;
' 
END

GO

/****** Object:  UserDefinedFunction [dbo].[spi_get_task] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spi_get_task]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

CREATE FUNCTION [dbo].[spi_get_task](@ProfileId uniqueidentifier, @TaskDesc varchar(128))
RETURNS @retTaskTable TABLE
(
    task_id uniqueidentifier,
	profile_id uniqueidentifier,
	app_id uniqueidentifier,
	task_key varchar(30),
	task_type varchar(255), 
	related_page varchar(max),
	task_description varchar(255),
	scheduled_time datetime,
	task_status char(1),
	task_owner varchar(20),
	task_server varchar(255),
	next_run_time datetime,
	last_run_time datetime,
	schedule_type char(1),
	schd_interval smallint,
	schd_dow smallint,
	queue_position int,
	change_date_time datetime,
	change_uid varchar(20) 
)
AS
BEGIN

    IF (LEN(@ProfileId) IS NULL) AND ((LEN(@TaskDesc) = 0) OR @TaskDesc IS NULL)
		INSERT INTO @retTaskTable SELECT task_id, profile_id, app_id, task_key, task_type, related_page, task_description, scheduled_time,
										 task_status, task_owner, task_server, next_run_time, last_run_time, schedule_type, schd_interval,
										 schd_dow, queue_position, change_date_time, change_uid
								  FROM [dbo].task_schedule
		
	IF (LEN(@ProfileId) = 36)  AND ((LEN(@TaskDesc) = 0) OR @TaskDesc IS NULL)
		INSERT INTO @retTaskTable SELECT task_id, profile_id, app_id, task_key, task_type, related_page, task_description, scheduled_time,
										 task_status, task_owner, task_server, next_run_time, last_run_time, schedule_type, schd_interval,
										 schd_dow, queue_position, change_date_time, change_uid
								  FROM [dbo].task_schedule
								  WHERE profile_id = @ProfileId
	   
    IF (LEN(@TaskDesc) > 0 AND @TaskDesc IS NOT NULL) AND (@ProfileId is null)
		INSERT INTO @retTaskTable SELECT task_id, profile_id, app_id, task_key, task_type, related_page, task_description, scheduled_time,
										 task_status, task_owner, task_server, next_run_time, last_run_time, schedule_type, schd_interval,
										 schd_dow, queue_position, change_date_time, change_uid
								  FROM [dbo].task_schedule
								  WHERE task_description = @TaskDesc
		
	IF (LEN(@ProfileId) = 36) AND (LEN(@TaskDesc) > 0 AND @TaskDesc IS NOT NULL)
		INSERT INTO @retTaskTable SELECT task_id, profile_id, app_id, task_key, task_type, related_page, task_description, scheduled_time,
										 task_status, task_owner, task_server, next_run_time, last_run_time, schedule_type, schd_interval,
										 schd_dow, queue_position, change_date_time, change_uid
								  FROM [dbo].task_schedule
								  WHERE profile_id = @ProfileId AND task_description = @TaskDesc
	
	RETURN;
END;
' 
END

GO

/*************************************************************** StoredProcedure ***************************************************************/

/****** Object:  StoredProcedure [dbo].[spi_AddCategory] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spi_AddCategory]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spi_AddCategory] AS' 
END
GO
ALTER PROCEDURE [dbo].[spi_AddCategory]
-- Add the parameters for the function here
@categoryName nvarchar(64),
@logID int
AS
BEGIN
SET NOCOUNT ON;
RETURN 0
END
GO

/****** Object:  StoredProcedure [dbo].[spi_changeschema]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spi_changeschema]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spi_changeschema] AS' 
END
GO
ALTER PROCEDURE [dbo].[spi_changeschema] @old_schema VARCHAR(256), @table_name VARCHAR(256), @new_schema VARCHAR(256) AS  DECLARE @mySQL nvarchar(2000); SET @mySQL = N'ALTER SCHEMA [' + @new_schema + '] TRANSFER [' +  @old_schema + '].[' + @table_name + ']'; EXEC sp_executesql @stmt=@mySQL;
GO


/****** Object:  StoredProcedure [dbo].[spi_ClearErrorHistory] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spi_ClearErrorHistory]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spi_ClearErrorHistory] AS' 
END
GO
/*
'------------------------------------------------------------------------------------------------
' Procedure Name: spi_ClearErrorHistory
'------------------------------------------------------------------------------------------------
' Procedure Description:
'   This stored procedure is called whenever the error detail page is loaded to make sure the
'   table of errors gets cleaned out.
'------------------------------------------------------------------------------------------------
*/
ALTER PROCEDURE [dbo].[spi_ClearErrorHistory](
	@pintDaysToKeep	INT
) AS
BEGIN
	SET NOCOUNT ON

	DELETE	spi_exception_info
	FROM	spi_exception_info
		INNER JOIN spi_error_info ON
			spi_error_info.session_error_id = spi_exception_info.session_error_id
	WHERE	DATEADD(day, @pintDaysToKeep, spi_error_info.error_date_time) < GETDATE()

	DELETE
	FROM	spi_error_info
	WHERE	DATEADD(day, @pintDaysToKeep, spi_error_info.error_date_time) < GETDATE()
END
GO

/****** Object:  StoredProcedure [dbo].[spi_delete_application] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spi_delete_application]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spi_delete_application] AS' 
END
GO

ALTER PROCEDURE [dbo].[spi_delete_application]
	@AppId	UNIQUEIDENTIFIER
	AS
	BEGIN
	   IF (@AppId is null) OR (LEN(@AppId) = 0)
		  RAISERROR('Null values not allowed for Application ID',16,1)
	   BEGIN TRY
		  BEGIN TRANSACTION
			 IF (LEN(@AppId) > 0) AND (@AppId IS NOT NULL)
			 BEGIN
				DELETE FROM [dbo].application
					WHERE app_id = @AppId
			 END
		 
		  COMMIT TRANSACTION
	   END TRY
   
	   BEGIN CATCH
			ROLLBACK TRANSACTION
			SELECT ERROR_NUMBER(), ERROR_MESSAGE() 
	   END CATCH
    END
GO

/****** Object:  StoredProcedure [dbo].[spi_dropschema] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spi_dropschema]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spi_dropschema] AS' 
END
GO
ALTER PROCEDURE [dbo].[spi_dropschema]
      @schema_name SYSNAME
      AS
      BEGIN
         DECLARE @dropSchemaStmt   NVARCHAR(4000)
      
         -- This will drop the schema passed to this function if the schema exists
         IF EXISTS (SELECT * FROM sys.schemas WHERE name = @schema_name)
         BEGIN
            SET @dropSchemaStmt = 'DROP SCHEMA ' + quotename(@schema_name, ']')
            EXEC (@dropSchemaStmt)
      
            IF @@error <> 0
               -- Error message comes from inside the invoke
               RETURN (1)
         END
      
         -- Return success --
         RETURN (0)
      END
GO


/****** Object:  StoredProcedure [dbo].[spi_insert_application] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spi_insert_application]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spi_insert_application] AS' 
END
GO

ALTER PROCEDURE [dbo].[spi_insert_application]

    @AppId           UNIQUEIDENTIFIER OUTPUT,
	@ProfileId		 UNIQUEIDENTIFIER,
	@AppName         VARCHAR(256),
	@ProgramLocation VARCHAR(max),
	@ProgramName     VARCHAR(max),
	@ArgValues		 VARCHAR(max),
	@AssignedAppId   UNIQUEIDENTIFIER,
	@DisplayName     VARCHAR(256)

AS
  -- DECLARE @AppId   UNIQUEIDENTIFIER
   
   IF @ProfileId is null
      RAISERROR('Null values not allowed for Profile ID',16,1)
BEGIN TRY
      IF ((LEN(@AssignedAppId) = 0) OR (@AssignedAppId IS NULL))
		SET @AppId = NEWID()
	  ELSE
	    SET @AppId = @AssignedAppId
		 
      BEGIN TRANSACTION
          
         INSERT INTO [dbo].application
         (	app_id,
			profile_id,
			app_name,
			display_name,
			program_location,
			program_name,
			argument_values,
			is_visible)
         VALUES (@AppId,
            @ProfileId,
            @AppName,
            @DisplayName,
            @ProgramLocation,
            @ProgramName,
            @ArgValues,
            0
         )
         
     COMMIT TRANSACTION
	 SELECT @AppId
	 
END TRY
BEGIN CATCH
   SELECT
         ERROR_NUMBER(), 
         ERROR_MESSAGE() 
END CATCH
GO

/****** Object:  StoredProcedure [dbo].[spi_insert_token] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spi_insert_token]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spi_insert_token] AS' 
END
GO
ALTER PROCEDURE [dbo].[spi_insert_token] @EmployeeNo INTEGER, @UserName AS VARCHAR(256), @ProfileId AS CHAR(36), @AppId AS CHAR(36), @Token as Char(36) = NULL AS  
BEGIN  
	SET NOCOUNT ON;
	DECLARE @next_guid AS CHAR(36);  

	SET @next_guid = ISNULL(@Token, convert(CHAR(36),NEWID()));  
	print @EmployeeNo;  
	print @next_guid;  

	INSERT INTO token (token_id, username, profile_id, application_id, create_datetime, empl_no)
	VALUES (@next_guid, @UserName, @ProfileId, @AppId, GETUTCDATE(), @EmployeeNo);

	SELECT guid = @next_guid;
END
GO

/****** Object:  StoredProcedure [dbo].[spi_task_delete] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spi_task_delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spi_task_delete] AS' 
END
GO

ALTER PROCEDURE [dbo].[spi_task_delete]

	@TaskId	UNIQUEIDENTIFIER

AS
   DECLARE @AppId UNIQUEIDENTIFIER
   DECLARE @ScheduleType CHAR(1)
   
   IF @TaskId is null
      RAISERROR('Null values not allowed for Task ID',16,1)
   BEGIN TRY

		 SELECT @AppId = app_id, @ScheduleType = schedule_type FROM [dbo].task_schedule
			WHERE task_id = @TaskId
			
      BEGIN TRANSACTION
		 DELETE FROM [dbo].task_schedule
			WHERE task_id = @TaskId
			
		 IF (LEN(@AppId) > 0) AND (@AppId IS NOT NULL) AND ((@ScheduleType = 'O') OR (@ScheduleType = 'N') OR (@ScheduleType = 'I') OR (@ScheduleType = 'S'))
		 BEGIN
			DELETE FROM [dbo].application
				WHERE app_id = @AppId
		 END
		 
      COMMIT TRANSACTION
   END TRY
   
   BEGIN CATCH
		ROLLBACK TRANSACTION
		SELECT ERROR_NUMBER(), ERROR_MESSAGE() 
   END CATCH
GO

/****** Object:  StoredProcedure [dbo].[spi_task_insert] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spi_task_insert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spi_task_insert] AS' 
END
GO

ALTER PROCEDURE [dbo].[spi_task_insert]

	@ProfileId			UNIQUEIDENTIFIER,
	@AppId				UNIQUEIDENTIFIER,
	@TaskType           VARCHAR(255),
	@TaskDescription	VARCHAR(255),
	@ScheduledTime		DATETIME,
	@TaskStatus			CHAR(1),
	@TaskOwner			VARCHAR(20),
	@NextRunTime		DATETIME,
	@ScheduleType		CHAR(1)

AS

   IF @ProfileId is null
      RAISERROR('Null values not allowed for Profile ID',16,1)
BEGIN TRY
          BEGIN TRANSACTION

         INSERT INTO [dbo].task_schedule
         (	task_id,
			profile_id,
			app_id,
			task_type,
			task_description,
			scheduled_time,
			task_status,
			task_owner,
			next_run_time,
			schedule_type,
			schd_interval,
			change_date_time, 
			change_uid)
         VALUES (DEFAULT,
            @ProfileId,
            @AppId,
            @TaskType,
            @TaskDescription,
            @ScheduledTime,
            @TaskStatus,
            @TaskOwner,
            @NextRunTime,
            @ScheduleType,
            1,
            CURRENT_TIMESTAMP,
            @TaskOwner
         )

     COMMIT TRANSACTION
END TRY
BEGIN CATCH
   SELECT
         ERROR_NUMBER(), 
         ERROR_MESSAGE() 
END CATCH

GO

/****** Object:  StoredProcedure [dbo].[spi_task_update] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spi_task_update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spi_task_update] AS' 
END
GO

ALTER PROCEDURE [dbo].[spi_task_update]

	@TaskId	  	    UNIQUEIDENTIFIER,
	@ProfileId		UNIQUEIDENTIFIER,
	@AppId  		UNIQUEIDENTIFIER,
	@TaskDescription  VARCHAR(255),
	@TaskStatus       CHAR(1),
	@TaskScheduleTime DATETIME,
    @ChangeUserID	  VARCHAR(20)

AS

	IF (@ProfileId is null)
      RAISERROR('Null values not allowed for Profile ID',16,1)
      
	IF (@TaskId IS NULL)
      RAISERROR('Null values not allowed for Application ID',16,1)

	IF (@AppId IS NULL)
      RAISERROR('Null values not allowed for Task ID',16,1)

	IF (@TaskDescription IS NULL)
      RAISERROR('Null values not allowed for Task Description',16,1)

	IF (@TaskStatus IS NULL)
      RAISERROR('Null values not allowed for Task Status',16,1)

	IF (@TaskScheduleTime IS NULL)
      RAISERROR('Null values not allowed for Scheduled Time',16,1)

	BEGIN TRY
      BEGIN TRANSACTION
  
      UPDATE [dbo].task_schedule
		SET profile_id = @ProfileId,
			app_id = @AppId,
			task_description = @TaskDescription,
			task_status = @TaskStatus,
			next_run_time = @TaskScheduleTime,
			change_uid = @ChangeUserID,
			change_date_time = CURRENT_TIMESTAMP
	  WHERE task_id = @TaskId

     COMMIT TRANSACTION
END TRY
BEGIN CATCH
   SELECT
         ERROR_NUMBER(), 
         ERROR_MESSAGE() 
END CATCH
GO

/****** Object:  StoredProcedure [dbo].[spi_WriteLog] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spi_WriteLog]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spi_WriteLog] AS' 
END
GO

/*
'---------------------------------------------------------------------------------------------
' Procedure Name: spi_WriteLog
'---------------------------------------------------------------------------------------------
' Procedure Description:
'   Stored procedure used to write to spi_error_info and spi_exception_info via the Enterprise
'   Library Logging Application block
'---------------------------------------------------------------------------------------------
*/

ALTER PROCEDURE [dbo].[spi_WriteLog]
(
	@eventID int, 
	@priority int, 
	@severity nvarchar(32), 
	@title nvarchar(256), 
	@timestamp datetime,
	@machineName nvarchar(32), 
	@AppDomainName nvarchar(512),
	@ProcessID nvarchar(256),
	@ProcessName nvarchar(512),
	@ThreadName nvarchar(512),
	@Win32ThreadId nvarchar(128),
	@message nvarchar(1500),
	@formattedmessage ntext,
	@LogId int OUTPUT
)
AS 
BEGIN
	SET NOCOUNT ON
 
	DECLARE @xDoc int

	--Clear the error history of all entries older than 30 days
	EXEC spi_ClearErrorHistory 30

	EXEC sp_xml_preparedocument @xDoc OUTPUT, @formattedmessage

	INSERT INTO [spi_error_info]
		([session_id]
		,[application_name]
		,[request_method]
		,[server_port]
		,[https]
		,[server_name]
		,[client_ip]
		,[auth_user]
		,[client_browser]
		,[url]
		,[query_string]
		,[reference_id]
		,[database_name]
		,[form_data]
		,[http_headers]
		,[application_vars]
		,[session_vars]
		,[error_date_time]
		,[is_cookieless]
		,[is_new_session]
		,[controller]
		,[action])
	SELECT
		SessionID,
		ApplicationName,
		RequestMethod,
		ServerPort,
		Https,
		ServerName,
		ClientIP,
		AuthUser,
		ClientBrowser,
		Url,
		QueryString,
		ReferenceId,
		DatabaseName,
		FormData,
		HttpHeaders,
		ApplicationVars,
		SessionVars,
		CONVERT(datetime, ErrorDateTime, 21) AS ErrorDateTime,
		(CASE IsCookieless WHEN 'True' THEN 1 ELSE 0 END) AS IsCookieless,
		(CASE IsNewSession WHEN 'True' THEN 1 ELSE 0 END) AS IsNewSession,
		ControllerName,
		ActionName
		FROM OPENXML (@xDoc, '/LogEntry', 1 )
		WITH (
			SessionID			VARCHAR(40)		'SessionID',
			ApplicationName		VARCHAR(100)	'ApplicationPath',
			RequestMethod		VARCHAR(5)		'RequestMethod',
			ServerPort			INT				'ServerPort',
			Https				VARCHAR(3)		'Https',
			ServerName			VARCHAR(15)		'Server',
			ClientIP			VARCHAR(15)		'HostAddress',
			AuthUser			VARCHAR(50)		'Login',
			ClientBrowser		VARCHAR(255)	'UserAgent',
			Url					VARCHAR(400)	'Url',
			QueryString			VARCHAR(4096)	'QueryString',
			ReferenceId			CHAR(36)		'ReferenceId',
			DatabaseName		VARCHAR(50)		'Database',
			HttpHeaders			TEXT			'AllHttp',
			ApplicationVars		TEXT			'HttpApplicationSettingsAll',
			SessionVars			TEXT			'HttpSessionSettingsAll',
			FormData			TEXT			'HttpRequestFormDataAll',
			ErrorDateTime		VARCHAR(23)		'TimeOfError',
			IsCookieless		VARCHAR(5)		'IsCookieless',
			IsNewSession		VARCHAR(5)		'IsNewSession',
			ControllerName		VARCHAR(50)		'ControllerName',
			ActionName			VARCHAR(50)		'ActionName')
				

	SET @LogId = @@IDENTITY

	INSERT INTO [spi_exception_info]
	   ([exception_level]
	   ,[session_error_id]
	   ,[exception_source]
	   ,[stack_trace]
	   ,[error_message]
	   ,[target_site])
	SELECT
		CAST(ExceptionLevel AS INT),
		@LogId,
		ExceptionSource,
		StackTrace,
		ErrorMessage,
		TargetSite
	FROM OPENXML (@xDoc, '/LogEntry/Exception', 1 )
	WITH (
		ExceptionLevel		VARCHAR(15)		'Level',
		ExceptionSource		VARCHAR(200)	'Source',
		StackTrace			TEXT			'StackTrace',
		ErrorMessage		TEXT			'Message',
		TargetSite			VARCHAR(100)	'TargetSite')
				
	EXEC sp_xml_removedocument @xDoc

	RETURN @LogId

END

GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'business_entity', N'COLUMN',N'entity_id'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unique district ID.  Usually the 3 character site code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'business_entity', @level2type=N'COLUMN',@level2name=N'entity_id'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'business_entity', N'COLUMN',N'entity_name'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Name of the district' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'business_entity', @level2type=N'COLUMN',@level2name=N'entity_name'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'business_entity', N'COLUMN',N'is_locked'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Determines if all realms/databases are locked so the users do not have access. Valid values are Y/N' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'business_entity', @level2type=N'COLUMN',@level2name=N'is_locked'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'business_entity', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Table that holds information regarding a specific district' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'business_entity'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'database_info', N'COLUMN',N'db_id'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unique database id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'database_info', @level2type=N'COLUMN',@level2name=N'db_id'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'database_info', N'COLUMN',N'db_name'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Actual database name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'database_info', @level2type=N'COLUMN',@level2name=N'db_name'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'database_info', N'COLUMN',N'sql_server_info'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Connection string information for the database connection' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'database_info', @level2type=N'COLUMN',@level2name=N'sql_server_info'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'database_info', N'COLUMN',N'username'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User name used to connect to the database' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'database_info', @level2type=N'COLUMN',@level2name=N'username'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'database_info', N'COLUMN',N'password'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Encrypted password for the database connection' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'database_info', @level2type=N'COLUMN',@level2name=N'password'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'database_info', N'COLUMN',N'db_type'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Type of database; Ex. App, Doc, Workflow, aspnetdb, cps' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'database_info', @level2type=N'COLUMN',@level2name=N'db_type'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'database_info', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Contains all databases used for the eFP applications' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'database_info'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'entity_profile', N'COLUMN',N'profile_id'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unique ID identifying a realm' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'entity_profile', @level2type=N'COLUMN',@level2name=N'profile_id'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'entity_profile', N'COLUMN',N'profile_name'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Name of a realm. Ex. Test, Train, Live, Q2Y2015' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'entity_profile', @level2type=N'COLUMN',@level2name=N'profile_name'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'entity_profile', N'COLUMN',N'entity_id'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'District ID associated with the realm' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'entity_profile', @level2type=N'COLUMN',@level2name=N'entity_id'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'entity_profile', N'COLUMN',N'is_locked'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Determines if a realm is locked so the users do not have access. Valid values are Y/N' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'entity_profile', @level2type=N'COLUMN',@level2name=N'is_locked'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'entity_profile', N'COLUMN',N'major_version'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Major version of the realm, Ex. 19.4, 19.11' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'entity_profile', @level2type=N'COLUMN',@level2name=N'major_version'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'entity_profile', N'COLUMN',N'minor_version'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Minor version of the realm, Ex. 1, 2, 3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'entity_profile', @level2type=N'COLUMN',@level2name=N'minor_version'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'entity_profile', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Table that holds the realm information.  A realm is similar to an environment, i.e. Test, Train, Live, Q2Y2015' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'entity_profile'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'profile_db_link', N'COLUMN',N'profile_id'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Realm id from the cat_realm table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'profile_db_link', @level2type=N'COLUMN',@level2name=N'profile_id'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'profile_db_link', N'COLUMN',N'db_id'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Database id of the database associated with a particular realm' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'profile_db_link', @level2type=N'COLUMN',@level2name=N'db_id'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'profile_db_link', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Table containing records that determine which databases are contained in which realm' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'profile_db_link'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'profile_variable', N'COLUMN',N'profile_id'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Realm database ID associated with the record.  This relates the variable back to a specific realm and database.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'profile_variable', @level2type=N'COLUMN',@level2name=N'profile_id'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'profile_variable', N'COLUMN',N'var_name'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The variable name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'profile_variable', @level2type=N'COLUMN',@level2name=N'var_name'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'profile_variable', N'COLUMN',N'var_value'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The variable value' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'profile_variable', @level2type=N'COLUMN',@level2name=N'var_value'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'profile_variable', N'COLUMN',N'is_env_variable'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Determines if the record is an environment variable.  Valid values Y/N' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'profile_variable', @level2type=N'COLUMN',@level2name=N'is_env_variable'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'profile_variable', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Table that holds records containing the environment variables needed for a realm database.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'profile_variable'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'service_info', N'COLUMN',N'service_id'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unique Identifier' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'service_info', @level2type=N'COLUMN',@level2name=N'service_id'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'service_info', N'COLUMN',N'service_type'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Service type. Workflow (WF)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'service_info', @level2type=N'COLUMN',@level2name=N'service_type'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'service_info', N'COLUMN',N'server_name'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Server Host Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'service_info', @level2type=N'COLUMN',@level2name=N'server_name'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'service_info', N'COLUMN',N'service_name'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Service Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'service_info', @level2type=N'COLUMN',@level2name=N'service_name'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'service_info', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Contains a list of services and the server they are located' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'service_info'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'user_variable', N'COLUMN',N'username'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The user associated with the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'user_variable', @level2type=N'COLUMN',@level2name=N'username'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'user_variable', N'COLUMN',N'var_name'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The variable name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'user_variable', @level2type=N'COLUMN',@level2name=N'var_name'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'user_variable', N'COLUMN',N'var_value'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The variable value' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'user_variable', @level2type=N'COLUMN',@level2name=N'var_value'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'user_variable', N'COLUMN',N'is_env_variable'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Determines if the record is an environment variable.  Valid values Y/N' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'user_variable', @level2type=N'COLUMN',@level2name=N'is_env_variable'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'user_variable', N'COLUMN',N'major_version'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Used to associate the variable with a specific version' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'user_variable', @level2type=N'COLUMN',@level2name=N'major_version'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'user_variable', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Table that holds records containing the user environment variables needed for a realm database.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'user_variable'
GO