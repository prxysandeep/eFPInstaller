
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[im_objects](
	[object_id] [char](36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[object_instance] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[object_description] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[object_assembly] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[object_type] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[status_cd] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[client_name] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[unique_key] [char](36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT (newid()),
 CONSTRAINT [im_objects_PK] PRIMARY KEY CLUSTERED 
(
	[unique_key] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE UNIQUE NONCLUSTERED INDEX [im_objects_A] ON [dbo].[im_objects] 
(
	[unique_key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

SET ANSI_PADDING OFF

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[im_attach_mstr](
	[attach_id] [char](36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[attach_desc] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[status_cd] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[client_name] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[unique_key] [char](36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT (newid()),
 CONSTRAINT [im_attach_mstr_PK] PRIMARY KEY CLUSTERED 
(
	[unique_key] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE UNIQUE NONCLUSTERED INDEX [im_attach_mstr_A] ON [dbo].[im_attach_mstr] 
(
	[unique_key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [im_attach_mstr_B] ON [dbo].[im_attach_mstr] 
(
	[attach_id] ASC,
	[status_cd] ASC,
	[client_name]
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

SET ANSI_PADDING OFF

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[im_index_mstr](
	[attach_id] [char](36) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[index_id] [int] NOT NULL,
	[table_name] [char](64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sequence] [int] NULL,
	[client_name] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[unique_key] [char](36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT (newid()),	
 CONSTRAINT [im_index_mstr_PK] PRIMARY KEY CLUSTERED 
(
	[index_id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE UNIQUE NONCLUSTERED INDEX [im_index_mstr_A] ON [dbo].[im_index_mstr] 
(
	[unique_key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [im_index_mstr_B] ON [dbo].[im_index_mstr] 
(
	[attach_id] ASC,
	[client_name]
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [im_index_mstr_C] ON [dbo].[im_index_mstr] 
(
	[attach_id] ASC,
	[index_id] ASC,
	[client_name]
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [im_index_mstr_D] ON [dbo].[im_index_mstr] 
(
	[attach_id] ASC,
	[index_id] ASC,
	[sequence] ASC,
	[client_name]
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [im_index_mstr_E] ON [dbo].[im_index_mstr] 
(
	[table_name] ASC,
	[client_name]
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

SET ANSI_PADDING OFF


--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[im_index_dtl](
	[index_id] [int] NOT NULL,
	[field_id] [int] NULL,
	[column_name] [char](64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sequence] [int] NULL,
	[client_name] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[unique_key] [char](36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT (newid()),
 CONSTRAINT [im_index_dtl_PK] PRIMARY KEY CLUSTERED 
(
	[unique_key] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO

CREATE NONCLUSTERED INDEX [im_index_dtl_A] ON [dbo].[im_index_dtl] 
(
	[index_id] ASC,
	[client_name]
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [im_index_dtl_B] ON [dbo].[im_index_dtl] 
(
	[index_id] ASC,
	[field_id] ASC,
	[client_name]
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [im_index_dtl_C] ON [dbo].[im_index_dtl] 
(
	[index_id] ASC,
	[sequence] ASC,
	[client_name]
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [im_index_dtl_D] ON [dbo].[im_index_dtl] 
(
	[column_name] ASC,
	[client_name]
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

GO
ALTER TABLE [dbo].[im_index_dtl]  WITH CHECK ADD  CONSTRAINT [im_index_dtl_1] FOREIGN KEY([index_id])
REFERENCES [dbo].[im_index_mstr] ([index_id])

GO

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[im_info](
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

GO
SET ANSI_PADDING OFF

CREATE UNIQUE NONCLUSTERED INDEX [im_info_A] ON [dbo].[im_info] 
(
	[unique_key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [im_info_B] ON [dbo].[im_info] 
(
	[archived_flag] ASC,
	[client_name]
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [im_info_C] ON [dbo].[im_info] 
(
	[status] ASC,
	[client_name]
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [im_info_D] ON [dbo].[im_info] 
(
	[create_dt] ASC,
	[user_id] ASC,
	[client_name]
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[im_index_data](
	[index_id] [int] NOT NULL,
	[field_id] [int] NULL,
	[field_value] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[link_id] [int] NULL,
	[subset] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[doc_id] [int] NOT NULL,
	[client_name] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[unique_key] [char](36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT (newid()),
 CONSTRAINT [im_index_data_PK] PRIMARY KEY CLUSTERED 
(
	[unique_key] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO

CREATE NONCLUSTERED INDEX [im_index_data_A] ON [dbo].[im_index_data] 
(
	[index_id] ASC,
	[client_name]
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [im_index_data_B] ON [dbo].[im_index_data] 
(
	[doc_id] ASC,
	[client_name]
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [im_index_data_C] ON [dbo].[im_index_data] 
(
	[index_id] ASC,
	[field_id] ASC,
	[client_name]
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [im_index_data_D] ON [dbo].[im_index_data] 
(
	[index_id] ASC,
	[field_id] ASC,
	[field_value] ASC,
	[client_name]
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [im_index_data_E] ON [dbo].[im_index_data] 
(
	[index_id] ASC,
	[field_id] ASC,
	[field_value] ASC,
	[doc_id] ASC,
	[client_name]
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [im_index_data_F] ON [dbo].[im_index_data] 
(
	[index_id] ASC,
	[field_id] ASC,
	[link_id] ASC,
	[doc_id] ASC,
	[client_name]
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

GO

CREATE NONCLUSTERED INDEX [im_index_data_G] ON [dbo].[im_index_data] 
(	
	[client_name] ASC
)INCLUDE (link_id) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]


GO

CREATE NONCLUSTERED INDEX [im_index_data_H] ON [dbo].[im_index_data]
(
       [field_value] ASC,
       [client_name] ASC    
)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO

ALTER TABLE [dbo].[im_index_data]  WITH CHECK ADD  CONSTRAINT [im_index_data_1] FOREIGN KEY([index_id])
REFERENCES [dbo].[im_index_mstr] ([index_id])
GO
ALTER TABLE [dbo].[im_index_data]  WITH CHECK ADD  CONSTRAINT [im_index_data_2] FOREIGN KEY([doc_id])
REFERENCES [dbo].[im_info] ([doc_id])

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[im_page](
	[clsid] [char](38) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[doc_id] [int] NOT NULL,
	[doc_size] [int] NULL,
	[page_no] [smallint] NOT NULL,
	[document] [image] NULL,
	[client_name] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[unique_key] [char](36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT (newid()),
 CONSTRAINT [im_page_PK] PRIMARY KEY CLUSTERED 
(
	[unique_key] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO

CREATE NONCLUSTERED INDEX [im_page_A] ON [dbo].[im_page] 
(
	[doc_id] ASC,
	[client_name]
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE UNIQUE NONCLUSTERED INDEX [im_page_B] ON [dbo].[im_page] 
(
	[doc_id] ASC,
	[page_no] ASC,
	[client_name]
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

GO
ALTER TABLE [dbo].[im_page]  WITH CHECK ADD  CONSTRAINT [im_page_1] FOREIGN KEY([doc_id])
REFERENCES [dbo].[im_info] ([doc_id])

GO

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
