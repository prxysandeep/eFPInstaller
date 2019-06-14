/****** Object:  Table [dbo].[sectb_action_feature] ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sectb_action_feature]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[sectb_action_feature](
		   [area] [varchar](64) NOT NULL,
		   [controller] [varchar](128) NOT NULL,
		   [action] [varchar](128) NOT NULL,
		   [feature_id] [varchar](32) NOT NULL,
		   [read_access_resource] [int] NULL,
		   [write_access_resource] [int] NULL,
		   [description] [varchar](1024) NULL,
		   [change_date_time] [datetime] NOT NULL,
		   [change_uid] [varchar](20) NOT NULL,
	CONSTRAINT [pk_sectb_action_feature] PRIMARY KEY NONCLUSTERED 
	(
		   [area] ASC,
		   [controller] ASC,
		   [action] ASC,
		   [feature_id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

END

GO
SET ANSI_PADDING OFF
GO

/****** Object:  Table [dbo].[sectb_action_resource]  ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sectb_action_resource]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[sectb_action_resource](
		   [area] [varchar](64) NOT NULL,
		   [controller] [varchar](128) NOT NULL,
		   [action] [varchar](128) NOT NULL,
		   [read_access_resource] [int] NULL,
		   [write_access_resource] [int] NULL,
		   [description] [varchar](1024) NULL,
		   [change_date_time] [datetime] NOT NULL,
		   [change_uid] [varchar](20) NOT NULL,
	CONSTRAINT [pk_sectb_action_resource] PRIMARY KEY NONCLUSTERED 
	(
		   [area] ASC,
		   [controller] ASC,
		   [action] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
END

GO

SET ANSI_PADDING OFF
GO

IF NOT EXISTS(SELECT * FROM sectb_action_resource WHERE area = 'Catalog' AND controller = 'Setup' AND action = 'BusinessEntityList')
BEGIN
	INSERT INTO sectb_action_resource VALUES ('Catalog','Setup','BusinessEntityList',-1,-1,'Allow access to Business Entity List',GETDATE(),'support')
END

IF NOT EXISTS(SELECT * FROM sectb_action_resource WHERE area = 'Catalog' AND controller = 'Setup' AND action = 'BusinessEntityDetail')
BEGIN
	INSERT INTO sectb_action_resource VALUES ('Catalog','Setup','BusinessEntityDetail',-1,-1,'Allow access to Business Entity Detail',GETDATE(),'support')
END

IF NOT EXISTS(SELECT * FROM sectb_action_resource WHERE area = 'Catalog' AND controller = 'Setup' AND action = 'DatabaseInformationList')
BEGIN
INSERT INTO sectb_action_resource VALUES ('Catalog','Setup','DatabaseInformationList',-1,-1,'Allow access to Database Information List',GETDATE(),'support')
END

IF NOT EXISTS(SELECT * FROM sectb_action_resource WHERE area = 'Catalog' AND controller = 'Setup' AND action = 'GlobalVariableList')
BEGIN
INSERT INTO sectb_action_resource VALUES ('Catalog','Setup','GlobalVariableList',-1,-1,'Allow access to Global Variable List',GETDATE(),'support')
END

IF NOT EXISTS(SELECT * FROM sectb_action_resource WHERE area = 'Catalog' AND controller = 'Setup' AND action = 'ProfileVariableList')
BEGIN
INSERT INTO sectb_action_resource VALUES ('Catalog','Setup','ProfileVariableList',-1,-1,'Allow access to Profile Variable List',GETDATE(),'support')
END

IF NOT EXISTS(SELECT * FROM sectb_action_resource WHERE area = 'Catalog' AND controller = 'Setup' AND action = 'ProfileDetail')
BEGIN
INSERT INTO sectb_action_resource VALUES ('Catalog','Setup','ProfileDetail',-1,-1,'Allow access to Profile Detail',GETDATE(),'support')
END

IF NOT EXISTS(SELECT * FROM sectb_action_resource WHERE area = 'Catalog' AND controller = 'Setup' AND action = 'ApplicationList')
BEGIN
INSERT INTO sectb_action_resource VALUES ('Catalog','Setup','ApplicationList',-1,-1,'Allow access to Application List',GETDATE(),'support')
END

IF NOT EXISTS(SELECT * FROM sectb_action_resource WHERE area = 'Catalog' AND controller = 'Setup' AND action = 'DatabaseLinkList')
BEGIN
INSERT INTO sectb_action_resource VALUES ('Catalog','Setup','DatabaseLinkList',-1,-1,'Allow access to Database Link List',GETDATE(),'support')
END

IF NOT EXISTS(SELECT * FROM sectb_action_resource WHERE area = 'Catalog' AND controller = 'Setup' AND action = 'ServiceLinkList')
BEGIN
INSERT INTO sectb_action_resource VALUES ('Catalog','Setup','ServiceLinkList',-1,-1,'Allow access to Service Link List',GETDATE(),'support')
END

IF NOT EXISTS(SELECT * FROM sectb_action_resource WHERE area = 'Catalog' AND controller = 'Setup' AND action = 'ServiceInfoList')
BEGIN
INSERT INTO sectb_action_resource VALUES ('Catalog','Setup','ServiceInfoList',-1,-1,'Allow access to Service Info List',GETDATE(),'support')
END

IF NOT EXISTS(SELECT * FROM sectb_action_resource WHERE area = 'Catalog' AND controller = 'Setup' AND action = 'UserAccessList')
BEGIN
INSERT INTO sectb_action_resource VALUES ('Catalog','Setup','UserAccessList',-1,-1,'Allow access to User Access List',GETDATE(),'support')
END

IF NOT EXISTS(SELECT * FROM sectb_action_resource WHERE area = 'N/A' AND controller = 'Common' AND action = 'UnderConstruction')
BEGIN
INSERT INTO sectb_action_resource VALUES ('N/A','Common','UnderConstruction',-1,-1,'',GETDATE(),'support')
END

IF NOT EXISTS(SELECT * FROM sectb_action_resource WHERE area = 'N/A' AND controller = 'Common' AND action = 'ScreenPrint')
BEGIN
INSERT INTO sectb_action_resource VALUES ('N/A','Common','ScreenPrint',-1,-1,'Allow access to the screen print functionality',GETDATE(),'support')
END

IF NOT EXISTS(SELECT * FROM sectb_action_resource WHERE area = 'N/A' AND controller = 'Home' AND action = 'Index')
BEGIN
INSERT INTO sectb_action_resource VALUES ('N/A','Home','Index',-1,-1,'',GETDATE(),'support')
END

IF NOT EXISTS(SELECT * FROM sectb_action_resource WHERE area = 'N/A' AND controller = 'Search' AND action = 'Index')
BEGIN
INSERT INTO sectb_action_resource VALUES ('N/A','Search','Index',-1,-1,'Allow access to Searches',GETDATE(),'support')
END

IF NOT EXISTS(SELECT * FROM sectb_action_resource WHERE area = 'N/A' AND controller = 'Search' AND action = 'QuickSearch')
BEGIN
INSERT INTO sectb_action_resource VALUES ('N/A','Search','QuickSearch',-1,-1,'Allow access to Quick Searches',GETDATE(),'support')
END

IF NOT EXISTS(SELECT * FROM sectb_action_resource WHERE area = 'N/A' AND controller = 'Search' AND action = '_SearchWidget')
BEGIN
INSERT INTO sectb_action_resource VALUES ('N/A','Search','_SearchWidget',-1,-1,'Allow access to Search Widgets',GETDATE(),'support')
END

IF NOT EXISTS(SELECT * FROM sectb_action_resource WHERE area = 'N/A' AND controller = 'SupportTools' AND action = 'Index')
BEGIN
INSERT INTO sectb_action_resource VALUES ('N/A','SupportTools','Index',-1,-1,'Allows access to Support Tools',GETDATE(),'support')
END

IF NOT EXISTS(SELECT * FROM sectb_action_resource WHERE area = 'N/A' AND controller = 'ThirdParty' AND action = 'UserVoice')
BEGIN
INSERT INTO sectb_action_resource VALUES ('N/A','ThirdParty','UserVoice',-1,-1,'Allows access to UserVoice view',GETDATE(),'support')
END

IF NOT EXISTS(SELECT * FROM sectb_action_resource WHERE area = 'N/A' AND controller = 'ThirdParty' AND action = 'UserVoiceForCoreEFP')
BEGIN
INSERT INTO sectb_action_resource VALUES ('N/A','ThirdParty','UserVoiceForCoreEFP',-1,-1,'Allows access to User Voice from core eFP',GETDATE(),'support')
END

IF NOT EXISTS(SELECT * FROM sectb_action_resource WHERE area = 'N/A' AND controller = 'ThirdParty' AND action = '_UserVoiceWidget')
BEGIN
INSERT INTO sectb_action_resource VALUES ('N/A','ThirdParty','_UserVoiceWidget',-1,-1,'Allows access to UserVoice view',GETDATE(),'support')
END


/****** Object:  StoredProcedure [dbo].[spi_GetFeatureAccessForAction]  ******/
IF OBJECT_ID('spi_GetFeatureAccessForAction', 'P') IS NOT NULL
    DROP PROCEDURE spi_GetFeatureAccessForAction
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
'===============================================================
' Stored Procedure:  spi_GetFeatureAccessForAction
'
' Description:
'  This procedure determines the user access level for the
'  features of a given view
'
' Paramters
'  @pLoginID  - varchar(20) - The login id of the user
'  @pArea - varchar(64) - The application area
'  @pController - varchar(128) - The controller name
'  @pAction - varchar(128) - The action name
'
' REV #       DATE       BY           CASE#  COMMENTS
' 1.0.000     08/19/2016 Steve.Eberly -      Initial write.
'===============================================================
*/

CREATE PROCEDURE [dbo].[spi_GetFeatureAccessForAction]
   @pLoginID VARCHAR(20),
   @pArea VARCHAR(64),
   @pController VARCHAR(128),
   @pAction VARCHAR(128)

AS
BEGIN

   SET NOCOUNT ON
   DECLARE @lPackage varchar(6)
   DECLARE @lSubPack varchar(6)
   DECLARE @lFunc   smallint
   DECLARE @lPrivCode int
   DECLARE @ResultID  int
   DECLARE @WriteAccessType int
   DECLARE @ReadAccessType int

   DECLARE @access CHAR(1)
   DECLARE @featureId VARCHAR(32)
   DECLARE @features TABLE(
      FeatureId VARCHAR(32),
      AccessType CHAR(1)
   )

   -- select all features that match teh given area, controller, action
   DECLARE curFeatures CURSOR FOR
      SELECT sectb_action_feature.feature_id,
         sectb_action_feature.read_access_resource,
         sectb_action_feature.write_access_resource
      FROM sectb_action_feature
      WHERE (sectb_action_feature.area = @pArea OR
          sectb_action_feature.area = 'ANY') AND
         (sectb_action_feature.controller = @pController OR
          sectb_action_feature.controller = 'ANY') AND
         (sectb_action_feature.[action] = @pAction OR
          sectb_action_feature.[action] = 'ANY')

   OPEN curFeatures
   FETCH NEXT FROM curFeatures into @featureId, @ReadAccessType, @WriteAccessType
   WHILE @@fetch_status = 0
   BEGIN
      SELECT @lPackage = package, @lSubPack = subpack, @lFunc = func, @lPrivCode = priv_code
         FROM sectb_resource
         WHERE usertype = @WriteAccessType

      SET @ResultID = dbo.spi_CheckSecurity(@pLoginID, @lPackage, @lSubPack, @lFunc, @lPrivCode)

      IF @ResultID = 1   SET @access = 'W'
      ELSE
         BEGIN
         SELECT @lPackage = package, @lSubPack = subpack, @lFunc = func, @lPrivCode = priv_code
             FROM sectb_resource
             WHERE usertype = @ReadAccessType

         SET @ResultID = dbo.spi_CheckSecurity(@pLoginID, @lPackage, @lSubPack, @lFunc, @lPrivCode)

         IF @ResultID = 1
            SET @access = 'R'
         ELSE
            SET @access = 'N'
      END
      INSERT INTO @features (FeatureId, AccessType) VALUES (@featureId, @access)
      FETCH NEXT FROM curFeatures into @featureId, @ReadAccessType, @WriteAccessType
   END
   CLOSE curFeatures
   DEALLOCATE curFeatures

   SELECT * FROM @features
END

GO
