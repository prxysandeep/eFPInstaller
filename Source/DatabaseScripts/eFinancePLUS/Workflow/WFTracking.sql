
/****** Object:  Table [dbo].[wf_activity_instance_events]    Script Date: 04/22/2011 07:35:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[wf_activity_instance_events](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[wf_instance_id] [uniqueidentifier] NOT NULL,
	[record_number] [bigint] NOT NULL,
	[state] [nvarchar](128) NULL,
	[trace_level_id] [tinyint] NULL,
	[activity_record_type] [nvarchar](128) NOT NULL,
	[activity_name] [nvarchar](1024) NULL,
	[activity_id] [nvarchar](256) NULL,
	[activity_instance_id] [nvarchar](256) NULL,
	[activity_type] [nvarchar](2048) NULL,
	[serialized_arguments] [nvarchar](max) NULL,
	[serialized_variables] [nvarchar](max) NULL,
	[serialized_annotations] [nvarchar](max) NULL,
	[time_created] [datetime] NOT NULL,
 CONSTRAINT [pk_wf_activity_instance_events_Id] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO


/****** Object:  Table [dbo].[wf_bookmark_resumption_events]    Script Date: 04/22/2011 07:35:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[wf_bookmark_resumption_events](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[wf_instance_id] [uniqueidentifier] NOT NULL,
	[record_number] [bigint] NULL,
	[trace_level_id] [tinyint] NULL,
	[bookmark_name] [nvarchar](1024) NULL,
	[bookmark_scope] [uniqueidentifier] NULL,
	[owner_activity_name] [nvarchar](256) NULL,
	[owner_activity_id] [nvarchar](256) NULL,
	[owner_activity_instance_id] [nvarchar](256) NULL,
	[owner_activity_type] [nvarchar](256) NULL,
	[serialized_annotations] [nvarchar](max) NULL,
	[time_created] [datetime] NOT NULL,
 CONSTRAINT [pk_wf_bookmark_resumption_events_id] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [dbo].[wf_custom_tracking_events]    Script Date: 04/22/2011 07:35:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[wf_custom_tracking_events](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[wf_instance_id] [uniqueidentifier] NOT NULL,
	[record_number] [bigint] NULL,
	[trace_level_id] [tinyint] NULL,
	[custom_record_name] [nvarchar](2048) NULL,
	[activity_name] [nvarchar](2048) NULL,
	[activity_id] [nvarchar](256) NULL,
	[activity_instance_id] [nvarchar](256) NULL,
	[activity_type] [nvarchar](256) NULL,
	[serialized_data] [nvarchar](max) NULL,
	[serialized_annotations] [nvarchar](max) NULL,
	[time_created] [datetime] NOT NULL,
 CONSTRAINT [pk_wf_custom_tracking_events_id] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO


/****** Object:  Table [dbo].[wf_extended_activity_events]    Script Date: 04/22/2011 07:36:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[wf_extended_activity_events](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[wf_instance_id] [uniqueidentifier] NOT NULL,
	[record_number] [bigint] NULL,
	[trace_level_id] [tinyint] NULL,
	[activity_record_type] [nvarchar](128) NOT NULL,
	[activity_name] [nvarchar](1024) NULL,
	[activity_id] [nvarchar](256) NULL,
	[activity_instance_id] [nvarchar](256) NULL,
	[activity_type] [nvarchar](2048) NULL,
	[child_activity_name] [nvarchar](1024) NULL,
	[child_activity_id] [nvarchar](256) NULL,
	[child_activity_instance_id] [nvarchar](256) NULL,
	[child_activity_type] [nvarchar](2048) NULL,
	[fault_details] [nvarchar](max) NULL,
	[fault_handler_activity_name] [nvarchar](1024) NULL,
	[fault_handler_activity_id] [nvarchar](256) NULL,
	[fault_handler_activity_instance_id] [nvarchar](256) NULL,
	[fault_handler_activity_type] [nvarchar](2048) NULL,
	[serialized_annotations] [nvarchar](max) NULL,
	[time_created] [datetime] NOT NULL,
 CONSTRAINT [pk_wf_extended_activity_events_Id] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [dbo].[wf_instance_events]    Script Date: 04/22/2011 07:36:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[wf_instance_events](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[wf_instance_id] [uniqueidentifier] NOT NULL,
	[wf_activity_definition] [nvarchar](256) NULL,
	[record_number] [bigint] NOT NULL,
	[state] [nvarchar](128) NULL,
	[trace_level_id] [tinyint] NULL,
	[reason] [nvarchar](2048) NULL,
	[exception_details] [nvarchar](max) NULL,
	[serialized_annotations] [nvarchar](max) NULL,
	[time_created] [datetime] NOT NULL,
 CONSTRAINT [pk_wf_instance_events_id] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO


/****** Object:  Table [dbo].[wf_request_history]    Script Date: 04/22/2011 07:36:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[wf_request_history](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[record_number] [bigint] NULL,
	[wf_instance_id] [uniqueidentifier] NOT NULL,
	[source_state] [nvarchar](256) NULL,
	[action] [nvarchar](256) NULL,
	[comment] [nvarchar](256) NULL,
	[source_uid] [nvarchar](16) NULL,
	[date] [datetime] NOT NULL,
 CONSTRAINT [pk_wf_request_history_id] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
