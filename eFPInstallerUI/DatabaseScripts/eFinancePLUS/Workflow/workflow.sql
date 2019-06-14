/****** Object:  Table [dbo].[wf_model]    Script Date: 09/11/2015 14:46:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[wf_model]') AND type in (N'U'))
DROP TABLE [dbo].[wf_model]
GO

/****** Object:  Table [dbo].[wf_model]    Script Date: 09/11/2015 14:46:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[wf_model](
	[model_id] [char](36) NOT NULL,
	[model_version] [int] NOT NULL,
	[status] [char](1) NOT NULL,
	[title] [varchar](50) NOT NULL,
	[description] [varchar](255) NULL,
	[launch_type] [char](2) NOT NULL,
	[data_set] [char](4) NOT NULL,
	[allow_cancel] [char](1) NOT NULL,
	[notify_cancel] [char](2) NULL,
	[xaml] [varchar](max) NULL,
	[cancel_template] [varchar](50) NULL,
	[change_date_time] [datetime] NOT NULL,
	[change_uid] [varchar](20) NOT NULL,
 CONSTRAINT [wf_model_PK] PRIMARY KEY CLUSTERED 
(
	[model_id] ASC,
	[model_version] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[wf_model] ADD  DEFAULT (newid()) FOR [model_id]
GO


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[wf_model_node_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[wf_model_node]'))
ALTER TABLE [dbo].[wf_model_node] DROP CONSTRAINT [wf_model_node_FK]
GO

/****** Object:  Table [dbo].[wf_model_node]    Script Date: 9/25/2015 9:13:27 AM ******/
DROP TABLE [dbo].[wf_model_node]
GO

/****** Object:  Table [dbo].[wf_model_node]    Script Date: 9/25/2015 9:13:27 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING OFF
GO

CREATE TABLE [dbo].[wf_model_node](
	[model_id] [char](36) NOT NULL,
	[model_version] [int] NOT NULL,
	[node_id] [int] IDENTITY(1,1) NOT NULL,
	[title] [varchar](50) NOT NULL,
	[type] [char](4) NOT NULL,
	[required] [char](1) NOT NULL,
	[change_date_time] [datetime] NOT NULL,
	[change_uid] [varchar](20) NOT NULL,
 CONSTRAINT [wf_model_node_PK] PRIMARY KEY CLUSTERED 
(
	[node_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[wf_model_node]  WITH CHECK ADD  CONSTRAINT [wf_model_node_FK] FOREIGN KEY([model_id], [model_version])
REFERENCES [dbo].[wf_model] ([model_id], [model_version])
GO

ALTER TABLE [dbo].[wf_model_node] CHECK CONSTRAINT [wf_model_node_FK]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[wf_model_node_transition_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[wf_model_node_transition]'))
ALTER TABLE [dbo].[wf_model_node_transition] DROP CONSTRAINT [wf_model_node_transition_FK]
GO

/****** Object:  Table [dbo].[wf_model_node_transition]    Script Date: 9/25/2015 9:15:54 AM ******/
DROP TABLE [dbo].[wf_model_node_transition]
GO

/****** Object:  Table [dbo].[wf_model_node_transition]    Script Date: 9/25/2015 9:15:54 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING OFF
GO

CREATE TABLE [dbo].[wf_model_node_transition](
	[node_id] [int] NOT NULL,
	[transition_id] [int] IDENTITY(1,1) NOT NULL,
	[order_num] [int] NOT NULL,
	[title] [varchar](50) NOT NULL,
	[condition] [varchar](max) NULL,
	[next_node_id] [int] NOT NULL,
	[change_date_time] [datetime] NOT NULL,
	[change_uid] [varchar](20) NOT NULL,
 CONSTRAINT [wf_model_node_transition_PK] PRIMARY KEY CLUSTERED 
(
	[node_id] ASC,
	[transition_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[wf_model_node_transition]  WITH CHECK ADD  CONSTRAINT [wf_model_node_transition_FK] FOREIGN KEY([node_id])
REFERENCES [dbo].[wf_model_node] ([node_id])
GO

ALTER TABLE [dbo].[wf_model_node_transition] CHECK CONSTRAINT [wf_model_node_transition_FK]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[wf_model_node_detail_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[wf_model_node_detail]'))
ALTER TABLE [dbo].[wf_model_node_detail] DROP CONSTRAINT [wf_model_node_detail_FK]
GO

/****** Object:  Table [dbo].[wf_model_node_detail]    Script Date: 9/25/2015 9:14:14 AM ******/
DROP TABLE [dbo].[wf_model_node_detail]
GO

/****** Object:  Table [dbo].[wf_model_node_detail]    Script Date: 9/25/2015 9:14:14 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING OFF
GO

CREATE TABLE [dbo].[wf_model_node_detail](
	[node_id] [int] NOT NULL,
	[key_id] [varchar](128) NOT NULL,
	[value_id] [int] NOT NULL,
	[value] [varchar](max) NULL,
	[next_key_id] [varchar](128) NULL,
	[change_date_time] [datetime] NOT NULL,
	[change_uid] [varchar](20) NOT NULL,
 CONSTRAINT [wf_model_node_detail_PK] PRIMARY KEY CLUSTERED 
(
	[node_id] ASC,
	[key_id] ASC,
	[value_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[wf_model_node_detail]  WITH CHECK ADD  CONSTRAINT [wf_model_node_detail_FK] FOREIGN KEY([node_id])
REFERENCES [dbo].[wf_model_node] ([node_id])
GO

ALTER TABLE [dbo].[wf_model_node_detail] CHECK CONSTRAINT [wf_model_node_detail_FK]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[wf_model_node_role_groups_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[wf_model_node_role_groups]'))
ALTER TABLE [dbo].[wf_model_node_role_groups] DROP CONSTRAINT [wf_model_node_role_groups_FK]
GO


/****** Object:  Table [dbo].[wf_model_node_role_groups]    Script Date: 9/25/2015 9:10:38 AM ******/
DROP TABLE [dbo].[wf_model_node_role_groups]
GO

/****** Object:  Table [dbo].[wf_model_node_role_groups]    Script Date: 9/25/2015 9:10:38 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING OFF
GO

CREATE TABLE [dbo].[wf_model_node_role_groups](
	[node_id] [int] NOT NULL,
	[role_id] [varchar](10) NOT NULL,
	[group_id] [varchar](10) NOT NULL,
	[row_num] [smallint] NOT NULL,
	[change_date_time] [datetime] NOT NULL,
	[change_uid] [varchar](20) NOT NULL,
 CONSTRAINT [wf_model_node_role_groups_PK] PRIMARY KEY CLUSTERED 
(
	[node_id] ASC,
	[role_id] ASC,
	[group_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[wf_model_node_role_groups]  WITH CHECK ADD  CONSTRAINT [wf_model_node_role_groups_FK] FOREIGN KEY([node_id])
REFERENCES [dbo].[wf_model_node] ([node_id])
GO

ALTER TABLE [dbo].[wf_model_node_role_groups] CHECK CONSTRAINT [wf_model_node_role_groups_FK]
GO

GO

/****** Object:  Table [dbo].[wf_queue]    Script Date: 10/8/2015 4:39:29 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[wf_queue]') AND type in (N'U'))
DROP TABLE [dbo].[wf_queue]
GO

GO

/****** Object:  Table [dbo].[wf_queue]    Script Date: 07/24/2015 18:18:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[wf_queue](
	[queue_id] [char](36) NOT NULL,
	[launch_type] [char](2) NOT NULL,
	[launch_object] [char](36) NOT NULL,
	[data_set] [char](4) NOT NULL,
	[processing_host] [char](36) NULL,
	[change_date_time] [datetime] NOT NULL,
	[change_uid] [varchar](20) NOT NULL,
 CONSTRAINT [wf_queue_PK] PRIMARY KEY CLUSTERED 
(
	[queue_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[wf_queue] ADD  DEFAULT (newid()) FOR [queue_id]
GO

/****** Object:  Table [dbo].[wf_queue]    Script Date: 9/25/2015 9:15:54 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[wf_instance]') AND type in (N'U'))
DROP TABLE [dbo].[wf_instance]
GO

GO

/****** Object:  Table [dbo].[wf_instance]    Script Date: 07/24/2015 18:51:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[wf_instance](
	[instance_id] [char](36) NOT NULL,
	[model_id] [char](36) NOT NULL,
	[model_version] [int] NOT NULL,	
	[launch_type] [char](2) NOT NULL,
	[launch_object] [char](36) NOT NULL,
	[timeout] [datetime] NULL,	
	[processing_host] [char](36) NULL,
	[data_set] [char](4) NOT NULL,	
	[create] [datetime] NULL,
	[status] [varchar](50) NOT NULL,	
	[description] [varchar](255) NULL,
	[change_date_time] [datetime] NOT NULL,
	[change_uid] [varchar](20) NOT NULL,
 CONSTRAINT [wf_instance_PK] PRIMARY KEY CLUSTERED 
(
	[instance_id] ASC	
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[wf_instance]  WITH NOCHECK ADD  CONSTRAINT [wf_instance_1] FOREIGN KEY([model_id], [model_version])
REFERENCES [dbo].[wf_model] ([model_id], [model_version])
GO

ALTER TABLE [dbo].[wf_instance] CHECK CONSTRAINT [wf_instance_1]
GO

/****** Object:  Table [dbo].[wf_instance_event]    Script Date: 9/25/2015 9:15:54 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[wf_instance_event]') AND type in (N'U'))
DROP TABLE [dbo].[wf_instance_event]
GO

GO

/****** Object:  Table [dbo].[wf_instance_event]    Script Date: 09/02/2015 17:46:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING OFF
GO

CREATE TABLE [dbo].[wf_instance_event](
	[event_id] [char](36) NOT NULL,
	[instance_id] [char](36) NOT NULL,		
	[node_id] [int] NOT NULL,
	[type] [char](8) NOT NULL,	
	[status] [varchar](50) NULL,	
	[start] [datetime] NULL,
	[completed] [datetime] NULL,
	[change_date_time] [datetime] NOT NULL,
	[change_uid] [varchar](20) NOT NULL,	
 CONSTRAINT [wf_instance_event_PK] PRIMARY KEY CLUSTERED 
(
	[event_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[wf_instance_event]  WITH CHECK ADD  CONSTRAINT [wf_instance_event_1] FOREIGN KEY([instance_id])
REFERENCES [dbo].[wf_instance] ([instance_id])

GO

ALTER TABLE [dbo].[wf_instance_event] CHECK CONSTRAINT [wf_instance_event_1]
GO

ALTER TABLE [dbo].[wf_instance_event] ADD  DEFAULT (newid()) FOR [event_id]
GO

GO

/****** Object:  Index [i_wf_instance_event]    Script Date: 10/28/2015 2:34:02 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [i_wf_instance_event] ON [dbo].[wf_instance_event]
(
	[instance_id] ASC,
	[node_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

/****** Object:  Table [dbo].[wf_instance_event]    Script Date: 9/25/2015 9:15:54 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[wf_instance_event_detail]') AND type in (N'U'))
DROP TABLE [dbo].[wf_instance_event_detail]
GO

/****** Object:  Table [dbo].[wf_instance_event_detail]    Script Date: 09/02/2015 17:46:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING OFF
GO

CREATE TABLE [dbo].[wf_instance_event_detail](
	[detail_id] [char](36) NOT NULL,
	[event_id] [char](36) NOT NULL,		
	[status] [varchar](50) NULL,	
	[group_id] [int] NULL,
	[role_id] [char](10) NULL,
	[user_id] [char](20) NULL,
	[start] [datetime] NULL,
	[completed] [datetime] NULL,
	[comments] [varchar](255) NULL,
	[change_date_time] [datetime] NOT NULL,
	[change_uid] [varchar](20) NOT NULL,	
 CONSTRAINT [wf_instance_event_detail_PK] PRIMARY KEY CLUSTERED 
(
	[detail_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[wf_instance_event_detail]  WITH CHECK ADD  CONSTRAINT [wf_instance_event_detail_1] FOREIGN KEY([event_id])
REFERENCES [dbo].[wf_instance_event] ([event_id])

GO

ALTER TABLE [dbo].[wf_instance_event_detail] CHECK CONSTRAINT [wf_instance_event_detail_1]
GO

ALTER TABLE [dbo].[wf_instance_event_detail] ADD  DEFAULT (newid()) FOR [detail_id]
GO



/****** Object:  Table [dbo].[wf_instance_state]    Script Date: 9/25/2015 9:15:54 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[wf_instance_state]') AND type in (N'U'))
DROP TABLE [dbo].[wf_instance_state]
GO

GO

/****** Object:  Table [dbo].[wf_instance_state]    Script Date: 09/02/2015 17:46:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[wf_instance_state](	
	[instance_id] [char](36) NOT NULL,		
	[meta] [varchar](max) NULL,
	[state] [varchar](max) NULL,
	[change_date_time] [datetime] NOT NULL,
	[change_uid] [varchar](20) NOT NULL,
 CONSTRAINT [wf_instance_state_PK] PRIMARY KEY CLUSTERED 
(
	[instance_id] ASC	
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[wf_instance_state]  WITH NOCHECK ADD  CONSTRAINT [wf_instance_state_1] FOREIGN KEY([instance_id] )
REFERENCES [dbo].[wf_instance] ([instance_id])
GO

ALTER TABLE [dbo].[wf_instance_state] CHECK CONSTRAINT [wf_instance_state_1]
GO


