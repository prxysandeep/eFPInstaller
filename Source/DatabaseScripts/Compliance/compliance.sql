GO

/****** Object:  Table [dbo].[compliance_config]    Script Date: 14-08-2018 14:55:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[compliance_config]') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[compliance_config](
	[id] [uniqueidentifier] NOT NULL,
	[model] [char](30) NOT NULL,
	[year] [char](4) NOT NULL,
	[data] [nvarchar](max) NOT NULL,
	[change_date_time] [datetime] NOT NULL,
	[change_uid] [nchar](50) NOT NULL,	
CONSTRAINT [PK_compliance_config] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[compliance_config]  WITH CHECK ADD  CONSTRAINT [Compliance Config Data record should be formatted as JSON] CHECK  ((isjson([data])=(1)))

ALTER TABLE [dbo].[compliance_config] CHECK CONSTRAINT [Compliance Config Data record should be formatted as JSON]

/****** Object:  Table [dbo].[compliance_data]    Script Date: 14-08-2018 14:53:59 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

END
GO
SET ANSI_PADDING OFF
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[compliance_data]') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[compliance_data](
	[run_id] [uniqueidentifier] NOT NULL,
	[model] [char](30) NOT NULL,
	[type] [char](12) NOT NULL,	
	[state_id] [char](2) NULL,
	[year] [char](4) NULL,
	[quarter] [char](1) NULL,
	[month] [char](2) NULL,
	[period] [char](4) NULL,	
	[id] [varchar](50) NULL,
	[name] [varchar](100) NULL,
	[ssn] [char](11) NULL,	
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[data] [nvarchar](max) NOT NULL,
	[change_date_time] [datetime] NOT NULL,
	[change_uid] [nchar](50) NOT NULL	
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[compliance_data]  WITH CHECK ADD  CONSTRAINT [FK_compliance_config_compliance_data] FOREIGN KEY([run_id])
REFERENCES [dbo].[compliance_config] ([id])

ALTER TABLE [dbo].[compliance_data] CHECK CONSTRAINT [FK_compliance_config_compliance_data]

ALTER TABLE [dbo].[compliance_data]  WITH CHECK ADD  CONSTRAINT [Compliance Data record should be formatted as JSON] CHECK  ((isjson([data])=(1)))

ALTER TABLE [dbo].[compliance_data] CHECK CONSTRAINT [Compliance Data record should be formatted as JSON]

END

GO
SET ANSI_PADDING OFF
GO

IF COL_LENGTH('compliance_data', 'period') IS NULL
BEGIN
    ALTER TABLE compliance_data
    ADD [period] [char](4)
END

IF COL_LENGTH('compliance_data', 'type') IS NULL
BEGIN
    ALTER TABLE compliance_data
    ADD [type] [char](10)
END

IF COL_LENGTH('compliance_data', 'ssn') IS NULL
BEGIN
    ALTER TABLE compliance_data
    ADD [ssn] [char](11)
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='idx1_compliance_config' AND object_id = OBJECT_ID('dbo.compliance_config')) 
BEGIN
	CREATE NONCLUSTERED INDEX idx1_compliance_config on dbo.compliance_config (model, year DESC);
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='idx1_compliance_data' AND object_id = OBJECT_ID('dbo.compliance_data')) 
BEGIN
	CREATE NONCLUSTERED INDEX idx1_compliance_data on dbo.compliance_data (model, year DESC, end_date DESC);
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='idx2_compliance_data' AND object_id = OBJECT_ID('dbo.compliance_data')) 
BEGIN
	CREATE NONCLUSTERED INDEX idx2_compliance_data on dbo.compliance_data (model, year DESC);
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='idx3_compliance_data' AND object_id = OBJECT_ID('dbo.compliance_data')) 
BEGIN
	CREATE NONCLUSTERED INDEX idx3_compliance_data on dbo.compliance_data (model, year DESC, quarter DESC);
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='idx4_compliance_data' AND object_id = OBJECT_ID('dbo.compliance_data')) 
BEGIN
	CREATE NONCLUSTERED INDEX idx4_compliance_data on dbo.compliance_data (model, type, year DESC, month DESC, period DESC);
END

GO

/****** Object:  Table [dbo].[compliance_config_log]    Script Date: 15-05-2019 13:13:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[compliance_config_log]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[compliance_config_log](
	[id] [uniqueidentifier] NOT NULL,
	[model] [char](30) NOT NULL,
	[year] [char](4) NOT NULL,
	[data] [nvarchar](max) NOT NULL,
	[change_date_time] [datetime] NOT NULL,
	[change_uid] [nchar](50) NOT NULL,
	[action] [varchar](10) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[compliance_config_log] ADD  DEFAULT (getdate()) FOR [change_date_time]

ALTER TABLE [dbo].[compliance_config_log]  WITH CHECK ADD  CONSTRAINT [Compliance Config Log record should be formatted as JSON] CHECK  ((isjson([data])=(1)))

ALTER TABLE [dbo].[compliance_config_log] CHECK CONSTRAINT [Compliance Config Log record should be formatted as JSON]

SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON
END


GO

/****** Object:  Table [dbo].[compliance_data_log]    Script Date: 15-05-2019 13:18:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[compliance_data_log]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[compliance_data_log](
	[run_id] [uniqueidentifier] NOT NULL,
	[model] [char](30) NOT NULL,
	[state_id] [char](2) NULL,
	[year] [char](4) NULL,
	[quarter] [char](1) NULL,
	[month] [char](2) NULL,
	[id] [varchar](50) NULL,
	[name] [varchar](100) NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[data] [nvarchar](max) NOT NULL,
	[change_date_time] [datetime] NOT NULL,
	[change_uid] [nchar](50) NOT NULL,
	[period] [char](4) NULL,
	[type] [char](10) NULL,
	[action] [varchar](10) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[compliance_data_log] ADD  DEFAULT (getdate()) FOR [change_date_time]

ALTER TABLE [dbo].[compliance_data_log]  WITH CHECK ADD  CONSTRAINT [Compliance Data Log record should be formatted as JSON] CHECK  ((isjson([data])=(1)))

ALTER TABLE [dbo].[compliance_data_log] CHECK CONSTRAINT [Compliance Data Log record should be formatted as JSON]

SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='idx1_compliance_config_log' AND object_id = OBJECT_ID('dbo.compliance_config_log')) 
BEGIN
	CREATE NONCLUSTERED INDEX idx1_compliance_config_log on dbo.compliance_config_log (model, year DESC);
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='idx1_compliance_data_log' AND object_id = OBJECT_ID('dbo.compliance_data_log')) 
BEGIN
	CREATE NONCLUSTERED INDEX idx1_compliance_data_log on dbo.compliance_data_log (model, year DESC, end_date DESC);
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='idx2_compliance_data_log' AND object_id = OBJECT_ID('dbo.compliance_data_log')) 
BEGIN
	CREATE NONCLUSTERED INDEX idx2_compliance_data_log on dbo.compliance_data_log (model, year DESC);
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='idx3_compliance_data_log' AND object_id = OBJECT_ID('dbo.compliance_data_log')) 
BEGIN
	CREATE NONCLUSTERED INDEX idx3_compliance_data_log on dbo.compliance_data_log (model, year DESC, quarter DESC);
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='idx4_compliance_data_log' AND object_id = OBJECT_ID('dbo.compliance_data_log')) 
BEGIN
	CREATE NONCLUSTERED INDEX idx4_compliance_data_log on dbo.compliance_data_log (model, type, year DESC, month DESC, period DESC);
END

GO
/****** Object:  Trigger [dbo].[tgr_compliance_config]    Script Date: 15-05-2019 11:31:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER   TRIGGER [dbo].[tgr_compliance_config]
ON [dbo].[compliance_config]
AFTER INSERT,DELETE,UPDATE  
AS 
DECLARE @action varchar(10)
    IF EXISTS (SELECT * FROM INSERTED)
        BEGIN
            IF EXISTS (SELECT * FROM DELETED) 
                SET @action = 'Update' 
			ELSE
                SET @action = 'Insert' 
        END
    ELSE IF EXISTS (SELECT * FROM DELETED)
        SET @action = 'Delete'  
    ELSE
        SET @action = 'Noop'

DECLARE @change_uid VARCHAR(30)

 IF SESSION_CONTEXT(N'change_uid') IS NOT NULL
  SET @change_uid = CONVERT(VARCHAR (30),SESSION_CONTEXT(N'change_uid'))
 ELSE
  SET @change_uid = SUSER_NAME()


IF @action = 'Update' OR @action = 'Delete'
BEGIN
INSERT INTO [dbo].[compliance_config_log](id,model,year,data,change_uid,action) select deleted.id,deleted.model,deleted.year,deleted.data,@change_uid,@action from deleted
END


IF @action = 'Insert'
BEGIN
INSERT INTO [dbo].[compliance_config_log](id,model,year,data,change_uid,action) select inserted.id,inserted.model,inserted.year,inserted.data,inserted.change_uid,@action from inserted
END




GO
/****** Object:  Trigger [dbo].[tgr_compliance_data]    Script Date: 15-05-2019 13:24:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER  TRIGGER [dbo].[tgr_compliance_data]
ON [dbo].[compliance_data]
AFTER INSERT,DELETE,UPDATE  
As
DECLARE @action varchar(10)
    IF EXISTS (SELECT * FROM INSERTED)
        BEGIN
            IF EXISTS (SELECT * FROM DELETED) 
                SET @action = 'Update' 
			ELSE
                SET @action = 'Insert' 
        END
    ELSE IF EXISTS (SELECT * FROM DELETED)
        SET @action = 'Delete'  
    ELSE
        SET @action = 'Noop'

DECLARE @change_uid VARCHAR(30)

 IF SESSION_CONTEXT(N'change_uid') IS NOT NULL
  SET @change_uid = CONVERT(VARCHAR (30),SESSION_CONTEXT(N'change_uid'))
 ELSE
  SET @change_uid = SUSER_NAME()


IF @action = 'Update' OR @action = 'Delete'
BEGIN
INSERT INTO [dbo].[compliance_data_log](run_id,model,state_id,year,quarter,month,id,name,start_date,end_date,data,change_uid,period,type,action) select deleted.run_id,deleted.model,deleted.state_id,deleted.year,deleted.quarter,deleted.month,deleted.id,deleted.name,deleted.start_date,deleted.end_date,deleted.data,@change_uid,deleted.period,deleted.type,@action from deleted
END

IF @action = 'Insert'
BEGIN
INSERT INTO [dbo].[compliance_data_log](run_id,model,state_id,year,quarter,month,id,name,start_date,end_date,data,change_uid,period,type,action) select inserted.run_id,inserted.model,inserted.state_id,inserted.year,inserted.quarter,inserted.month,inserted.id,inserted.name,inserted.start_date,inserted.end_date,inserted.data,inserted.change_uid,inserted.period,inserted.type,@action from inserted
END


