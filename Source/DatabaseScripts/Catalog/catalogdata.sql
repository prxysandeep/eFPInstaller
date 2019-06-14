------------------------- Check if we are upgrading catalog database  -------------------------
DECLARE @currentVersion NVARCHAR(MAX);
DECLARE @upgradeCatalog BIT;

SET @currentVersion = '19.4'
SET @upgradeCatalog = 0;

DECLARE @fpsVersion NVARCHAR(MAX);
DECLARE crGetCatalogVersion CURSOR FOR
	SELECT var_value FROM global_variable WHERE var_name = 'FPSVER'
OPEN crGetCatalogVersion
FETCH crGetCatalogVersion INTO @fpsVersion
IF @@FETCH_STATUS = 0 AND  @fpsVersion != @currentVersion
	SET @upgradeCatalog = 1

CLOSE crGetCatalogVersion
DEALLOCATE crGetCatalogVersion

------------------------- Upgrade from 5.2 ----------------------
-- If upgrading, move some global variables to profile variables
IF @upgradeCatalog = 1 AND @fpsVersion = '5.2'
BEGIN
	DECLARE @hasFatalErrors BIT
	DECLARE @profileCount SMALLINT
	DECLARE @varNames NVARCHAR(MAX)
	DECLARE @profileId UNIQUEIDENTIFIER

	SET @hasFatalErrors = 0
	SET @profileCount = 0
	SET @varNames = ''

	--Loop through the profiles and add the profile variables.
	DECLARE crGet52Profiles CURSOR FOR
		SELECT profile_id FROM entity_profile
		WHERE major_version = @fpsVersion
		ORDER BY profile_id

	OPEN crGet52Profiles
	FETCH NEXT FROM crGet52Profiles INTO @profileId

	WHILE @@FETCH_STATUS = 0
	BEGIN
		BEGIN TRY
		DECLARE @var_name VARCHAR(50)
		DECLARE @var_value VARCHAR(MAX)

		SET @profileCount = @profileCount + 1

		--Get the list of global variables we need to copy to profile variables.
		DECLARE crGetGlobalVariablesWithVersion CURSOR FOR
			SELECT var_name, var_value
			  FROM global_variable
			 WHERE is_env_variable = 1
			    AND (var_value LIKE '%FPSVER%'
				OR var_value LIKE '%RMSVER%'
				OR var_value LIKE '%LIBVER%'
				OR var_value LIKE '%spiver%'
				OR var_value LIKE '%5.2%'
				OR var_value LIKE '%9.2%'
				OR var_value LIKE 'http%'
				OR var_name IN ('FPSVER', 'RMSVER', 'LIBVER', 'spiver', 'SPIHOME'))
				ORDER BY var_name

		OPEN crGetGlobalVariablesWithVersion
		FETCH NEXT FROM crGetGlobalVariablesWithVersion INTO @var_name, @var_value

		WHILE @@FETCH_STATUS = 0
		BEGIN
			BEGIN TRY		
			IF NOT EXISTS (SELECT 1 FROM profile_variable WHERE profile_id = @profileId AND var_name = @var_name)
				INSERT INTO profile_variable(profile_id, var_name, var_value, is_env_variable, order_id) VALUES (@profileId, @var_name, @var_value, 1, NULL)

			--Add list of global variable names to be deleted after all profiles are processed.
			IF @profileCount = 1
			BEGIN
				IF LEN(@varNames) > 1
					SET @varNames = @varNames + ','
				SET @varNames = RTRIM(LTRIM(@varNames)) + '''' + RTRIM(LTRIM(@var_name)) + ''''
			END

			END TRY

			BEGIN CATCH
				SET @hasFatalErrors = 1
			END CATCH

			FETCH NEXT FROM crGetGlobalVariablesWithVersion INTO @var_name, @var_value
		END -- Global variables Loop

		CLOSE crGetGlobalVariablesWithVersion
		DEALLOCATE crGetGlobalVariablesWithVersion 

		END TRY

		BEGIN CATCH
			SET @hasFatalErrors = 1
		END CATCH

	FETCH NEXT FROM crGet52Profiles INTO @profileId
	END -- Profile Loop

	CLOSE crGet52Profiles
	DEALLOCATE crGet52Profiles
	
	--Backup the Global Variables table and then delete the global variables that were moved to the profile_variable table.
	IF @hasFatalErrors = 0 AND LEN(@varNames) > 1
	BEGIN
	    DECLARE @sqlStmt NVARCHAR(MAX)

		--Backup the global_variable table if it doesn't already exist just in case something goes wrong.
		IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[bk52_global_variable]') AND type in (N'U'))
		BEGIN
			SET @sqlStmt = 'SELECT * INTO [dbo].[bk52_global_variable] FROM [dbo].[global_variable]'
			EXEC sp_executesql @sqlStmt
		END

		--Delete the global variables that we moved to the profile variable table.
		SET @sqlStmt = 'DELETE FROM [dbo].[global_variable] WHERE var_name IN (' + RTRIM(LTRIM(@varNames)) + ')'
		EXEC sp_executesql @sqlStmt
	END
END
------------------------- cattb_product -------------------------

IF NOT EXISTS (Select 1 from cattb_product WHERE code= 'eCP' )
 INSERT INTO cattb_product(code,description) VALUES ('eCP','eCommunityPLUS')

IF NOT EXISTS (Select 1 from cattb_product WHERE code= 'eFP' )
 INSERT INTO cattb_product(code,description) VALUES ('eFP','eFinancePLUS')

------------------------- cattb_dbtype -------------------------

IF NOT EXISTS (Select 1 from cattb_dbtype WHERE code= 'aspnetdb' )
 INSERT INTO cattb_dbtype(code,description) VALUES ('aspnetdb','ASP.NET')

IF NOT EXISTS (Select 1 from cattb_dbtype WHERE code= 'DO' )
 INSERT INTO cattb_dbtype(code,description) VALUES ('DO','Documents Online')

IF NOT EXISTS (Select 1 from cattb_dbtype WHERE code= 'eCP' )
 INSERT INTO cattb_dbtype(code,description) VALUES ('eCP','eCommunityPLUS')

IF NOT EXISTS (Select 1 from cattb_dbtype WHERE code= 'eFP' )
 INSERT INTO cattb_dbtype(code,description) VALUES ('eFP','eFinancePLUS')

IF NOT EXISTS (Select 1 from cattb_dbtype WHERE code= 'Auth' )
 INSERT INTO cattb_dbtype(code,description) VALUES ('Auth','Auth Provider')

IF NOT EXISTS (Select 1 from cattb_dbtype WHERE code= 'Compliance')
 INSERT INTO cattb_dbtype(code,description) VALUES ('Compliance','eFinancePLUS Compliance')
------------------------- business_entity -------------------------

IF NOT EXISTS (Select 1 from business_entity WHERE entity_id= ('DEFAULT' + @currentVersion) )
 INSERT INTO business_entity(entity_id,entity_name,is_locked,crm_id) VALUES (('DEFAULT' + @currentVersion),('Default ' + @currentVersion + ' School District'),1,null)

------------------------- entity_profile ---------------------------
DECLARE @defaultProfileID UNIQUEIDENTIFIER;
IF NOT EXISTS (Select 1 from entity_profile WHERE entity_id= ('DEFAULT' + @currentVersion) )
BEGIN
 SET @defaultProfileID = NEWID();
 INSERT INTO entity_profile(profile_id,profile_name,entity_id,is_locked,major_version,minor_version,build_number,product_id) VALUES (@defaultProfileID,('Default eFinancePlus ' + @currentVersion + ' District'),('DEFAULT' + @currentVersion),0,@currentVersion,'0','0','eFP')
END
ELSE
BEGIN
  DECLARE crGetProfileID CURSOR FOR
  SELECT profile_id FROM entity_profile WHERE entity_id= ('DEFAULT' + @currentVersion)
  OPEN crGetProfileID
  FETCH NEXT FROM crGetProfileID INTO @defaultProfileID
  CLOSE crGetProfileID
  DEALLOCATE crGetProfileID
END
------------------------- application ------------------------------

IF NOT EXISTS (Select 1 from application WHERE profile_id = @defaultProfileID AND app_name = 'PO' )
 INSERT INTO application(app_id,profile_id,app_name,display_name,program_location,program_name,argument_values,is_visible) VALUES (NEWID(),@defaultProfileID,'PO','Purchase Order Approval','famx','poapprv1','A Y',0)

IF NOT EXISTS (Select 1 from application WHERE profile_id = @defaultProfileID AND app_name = 'CO' )
 INSERT INTO application(app_id,profile_id,app_name,display_name,program_location,program_name,argument_values,is_visible) VALUES (NEWID(),@defaultProfileID,'CO','Change Order Approval','famx','chgapprv1','A Y',0)

IF NOT EXISTS (Select 1 from application WHERE profile_id = @defaultProfileID AND app_name = 'INVBATCH' )
 INSERT INTO application(app_id,profile_id,app_name,display_name,program_location,program_name,argument_values,is_visible) VALUES (NEWID(),@defaultProfileID,'INVBATCH','Batch Invoice Approval','famx','bpayabl1','V',0)

IF NOT EXISTS (Select 1 from application WHERE profile_id = @defaultProfileID AND app_name = 'REQ' )
 INSERT INTO application(app_id,profile_id,app_name,display_name,program_location,program_name,argument_values,is_visible) VALUES (NEWID(),@defaultProfileID,'REQ','Requisition Approval','famx','reqappr1','A Y',0)

IF NOT EXISTS (Select 1 from application WHERE profile_id = @defaultProfileID AND app_name = 'WF' )
 INSERT INTO application(app_id,profile_id,app_name,display_name,program_location,program_name,argument_values,is_visible) VALUES (NEWID(),@defaultProfileID,'WF','Workflow',null,'WF',null,0)

IF NOT EXISTS (Select 1 from application WHERE profile_id = @defaultProfileID AND app_name = 'EF' )
 INSERT INTO application(app_id,profile_id,app_name,display_name,program_location,program_name,argument_values,is_visible) VALUES (NEWID(),@defaultProfileID,'EF','eForms',null,'EF',null,0)

IF NOT EXISTS (Select 1 from application WHERE profile_id = @defaultProfileID AND app_name = 'TASK' )
 INSERT INTO application(app_id,profile_id,app_name,display_name,program_location,program_name,argument_values,is_visible) VALUES (NEWID(),@defaultProfileID,'TASK','Schedule Task',null,'TASK',null,0)

IF NOT EXISTS (Select 1 from application WHERE profile_id = @defaultProfileID AND app_name = 'AP' )
 INSERT INTO application(app_id,profile_id,app_name,display_name,program_location,program_name,argument_values,is_visible) VALUES (NEWID(),@defaultProfileID,'AP','Accounts Payable Approval','famx','apapproval','A Y',0)

IF NOT EXISTS (Select 1 from application WHERE profile_id = @defaultProfileID AND app_name = 'EAC' )
 INSERT INTO application(app_id,profile_id,app_name,display_name,program_location,program_name,argument_values,is_visible) VALUES (NEWID(),@defaultProfileID,'EAC','Employee Access Center',null,'EAC',null,0)

IF NOT EXISTS (Select 1 from application WHERE profile_id = @defaultProfileID AND app_name = 'ETS' )
 INSERT INTO application(app_id,profile_id,app_name,display_name,program_location,program_name,argument_values,is_visible) VALUES (NEWID(),@defaultProfileID,'ETS','Employee Time Sheet',null,'ETS',null,0)

IF NOT EXISTS (Select 1 from application WHERE profile_id = @defaultProfileID AND app_name = 'AM' )
 INSERT INTO application(app_id,profile_id,app_name,display_name,program_location,program_name,argument_values,is_visible) VALUES (NEWID(),@defaultProfileID,'AM','Recruitment',null,'AM',null,0)

IF NOT EXISTS (Select 1 from application WHERE profile_id = @defaultProfileID AND app_name = 'INVONLINE' )
 INSERT INTO application(app_id,profile_id,app_name,display_name,program_location,program_name,argument_values,is_visible) VALUES (NEWID(),@defaultProfileID,'INVONLINE','Online Invoice Approval','famx','venpay1','V',0)

IF NOT EXISTS (Select 1 from application WHERE profile_id = @defaultProfileID AND app_name = 'VEN' )
 INSERT INTO application(app_id,profile_id,app_name,display_name,program_location,program_name,argument_values,is_visible) VALUES (NEWID(),@defaultProfileID,'VEN','VAC Vendor Approval','famx','vac_vendor',null,0)

IF NOT EXISTS (Select 1 from application WHERE profile_id = @defaultProfileID AND app_name = 'eFP' )
 INSERT INTO application(app_id,profile_id,app_name,display_name,program_location,program_name,argument_values,is_visible) VALUES (NEWID(),@defaultProfileID,'eFP',null,null,('/gas' + @currentVersion + '/wa/r/plus/finplus'),null,1)

IF NOT EXISTS (Select 1 from application WHERE profile_id = @defaultProfileID AND app_name = 'COURSE' )
 INSERT INTO application(app_id,profile_id,app_name,display_name,program_location,program_name,argument_values,is_visible) VALUES (NEWID(),@defaultProfileID,'COURSE','Professional Development Course Approval','hrmx','pdCourseMstr3','1',0)

IF NOT EXISTS (Select 1 from application WHERE profile_id = @defaultProfileID AND app_name = 'BT' )
 INSERT INTO application(app_id,profile_id,app_name,display_name,program_location,program_name,argument_values,is_visible) VALUES (NEWID(),@defaultProfileID,'BT','Budget Transfer Approval','famx','budapproval','2 A Y',0)

IF NOT EXISTS (Select 1 from application WHERE profile_id = @defaultProfileID AND app_name = 'PUN' )
 INSERT INTO application(app_id,profile_id,app_name,display_name,program_location,program_name,argument_values,is_visible) VALUES (NEWID(),@defaultProfileID,'PUN','Vendor PunchOut',null,'PUN',null,0)

IF NOT EXISTS (Select 1 from application WHERE profile_id = @defaultProfileID AND app_name = 'USER' )
 INSERT INTO application(app_id,profile_id,app_name,display_name,program_location,program_name,argument_values,is_visible) VALUES (NEWID(),@defaultProfileID,'USER','Professional Development User Approval','hrmx','pdPartInstructMstr3','A Y',0)

IF NOT EXISTS (Select 1 from application WHERE profile_id = @defaultProfileID AND app_name = 'homepage' )
 INSERT INTO application(app_id,profile_id,app_name,display_name,program_location,program_name,argument_values,is_visible) VALUES (NEWID(),@defaultProfileID,'homepage',null,'menx','menu_homepage',null,0)

IF NOT EXISTS (Select 1 from application WHERE profile_id = @defaultProfileID AND app_name = 'Update Budget KPI' )
 INSERT INTO application(app_id,profile_id,app_name,display_name,program_location,program_name,argument_values,is_visible) VALUES (NEWID(),@defaultProfileID,'Update Budget KPI',null,'famx','kpi_expbudact',null,0)

IF NOT EXISTS (Select 1 from application WHERE profile_id = @defaultProfileID AND app_name = 'BA' )
 INSERT INTO application(app_id,profile_id,app_name,display_name,program_location,program_name,argument_values,is_visible) VALUES (NEWID(),@defaultProfileID,'BA','Budget Adjustment Approval','famx','budapproval','1 A Y',0)

IF NOT EXISTS (Select 1 from application WHERE profile_id = @defaultProfileID AND app_name = 'PD' )
 INSERT INTO application(app_id,profile_id,app_name,display_name,program_location,program_name,argument_values,is_visible) VALUES (NEWID(),@defaultProfileID,'PD','Professional Development',null,'PD',null,0)

IF NOT EXISTS (Select 1 from application WHERE profile_id = @defaultProfileID AND app_name = 'ChkLedger' )
 INSERT INTO application(app_id,profile_id,app_name,display_name,program_location,program_name,argument_values,is_visible) VALUES (NEWID(),@defaultProfileID,'ChkLedger','Check Ledger Balances','fetc','cron_main',null,0)

IF NOT EXISTS (Select 1 from application WHERE profile_id = @defaultProfileID AND app_name = 'PAYSIM' )
 INSERT INTO application(app_id,profile_id,app_name,display_name,program_location,program_name,argument_values,is_visible) VALUES(NEWID(), @defaultProfileID, 'PAYSIM', 'Paycheck Simulator Service', 'hrmx', 'ws_whatif', null, 0)

IF NOT EXISTS (Select 1 from application WHERE profile_id = @defaultProfileID AND app_name = 'Compliance' )
 INSERT INTO application(app_id,profile_id,app_name,display_name,program_location,program_name,argument_values,is_visible) VALUES (NEWID(),@defaultProfileID,'Compliance','eFinancePLUS Compliance',null,'Compliance',null,0)

------------------------- global_variable -----------------------------

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'acct_mgmt_password' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('acct_mgmt_password',null,'eFP',0,null)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'acct_mgmt_user' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('acct_mgmt_user',null,'eFP',0,null)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'APPINFO' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('APPINFO','/ApplicantTracking/ApplicantOverview.aspx','eFP',0,null)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'APPSEARCH' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('APPSEARCH','/ApplicantTracking/ApplicantPostingOverview.aspx','eFP',0,null)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'AUTHENTICATIONAUTHORITY' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('AUTHENTICATIONAUTHORITY',('http://<api_server>/eFP' + @currentVersion + '/eFinancePLUS/ERP.eFinancePLUS.Security.OpenIDConnect' + @currentVersion),'eFP',1,null)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'BCPPATH' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('BCPPATH','C:\PROGRA~1\MICROS~4\130\Tools\Binn\','eFP',1,null)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'bens' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('bens','@@SPIFPS@@/ben/src','eFP',1,325)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'benx' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('benx','@@SPIFPS@@/ben/bin','eFP',1,330)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'buds' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('buds','@@SPIFPS@@/bud/src','eFP',1,345)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'budx' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('budx','@@SPIFPS@@/bud/bin','eFP',1,350)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'comlibs' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('comlibs','@@SPICPS@@/comlib/src','eFP',1,375)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'comlibx' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('comlibx','@@SPICPS@@/comlib/bin','eFP',1,380)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'custom_url' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('custom_url',null,'eFP',0,null)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'DBPATH' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('DBPATH','@@SPIFPS@@/data;@@SPICPS@@/data','eFP',1,120)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'DBPRINT' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('DBPRINT','html5','eFP',1,65)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'detc' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('detc','@@SPICPS@@/dbs/etc','eFP',1,385)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'EFPAPPSERVER' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('EFPAPPSERVER',('http://<application_server>/eFP' + @currentVersion),'eFP',1,null)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'EFPTOKENEXPIRATION' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('EFPTOKENEXPIRATION','45','eFP',0,null)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'EMPCREATE' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('EMPCREATE','/ApplicantTracking/CreateEmployees.aspx','eFP',0,null)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'ens' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('ens','@@SPICPS@@/en/src','eFP',1,415)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'enx' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('enx','@@SPICPS@@/en/bin','eFP',1,420)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'fams' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('fams','@@SPIFPS@@/fam/src','eFP',1,435)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'famx' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('famx','@@SPIFPS@@/fam/bin','eFP',1,440)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'FASLOGDIR' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('FASLOGDIR','@@SPIFPS@@/log','eFP',1,125)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'FASRPTDIR' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('FASRPTDIR','@@SPIDRIVE@@/users/@@LOGNAME@@/rpt','eFP',1,130)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'FASTAPDIR' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('FASTAPDIR','@@SPIFPS@@/log','eFP',1,135)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'feature_selection' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('feature_selection','Disabled','eFP',0,null)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'fetc' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('fetc','@@SPIFPS@@/etc','eFP',1,445)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'FGLDBPATH' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('FGLDBPATH','@@SPIFPS@@/data;@@SPICPS@@/data','eFP',1,140)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'FGLDIR' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('FGLDIR','@@SPITOOLS@@\4jsplus\runtime@@FOURJSVER@@','eFP',1,98)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'FGLGUI' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('FGLGUI','1','eFP',1,57)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'FGLLDPATH' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('FGLLDPATH','@@futilx@@;@@libx@@;@@fjlibx@@;@@comlibx@@;@@FGLDIR@@/lib;@@GREDIR@@\lib','eFP',1,780)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'FGLPROFILE' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('FGLPROFILE','@@FGLDIR@@\etc\fglprofile','eFP',1,97)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'FGLRESOURCEPATH' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('FGLRESOURCEPATH','@@libt@@','eFP',1,785)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'fixs' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('fixs','@@SPIFPS@@/fix/src','eFP',1,450)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'fixx' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('fixx','@@SPIFPS@@/fix/bin','eFP',1,455)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'fjlibs' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('fjlibs','@@SPISHARE@@/fjlib/src','eFP',1,460)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'fjlibx' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('fjlibx','@@SPISHARE@@/fjlib/bin','eFP',1,465)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'FOURJSVER' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('FOURJSVER','2.50','eFP',1,5)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'FP_NO_HOST_CHECK' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('FP_NO_HOST_CHECK','NO','eFP',1,66)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'FPSVER' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('FPSVER',@currentVersion,'eFP',1,1)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'futils' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('futils','@@SPIFPS@@/futil/src','eFP',1,480)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'futilx' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('futilx','@@SPIFPS@@/futil/bin','eFP',1,485)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'GREDIR' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('GREDIR','@@SPITOOLS@@\4jsplus\gre@@FOURJSVER@@','eFP',1,81)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'HOME' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('HOME','@@HOMEDIRLETTER@@/users/@@LOGNAME@@','eFP',1,165)
 
IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'APISCOPES' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('APISCOPES','attendance,contact,degree,deduction,certificate,employee,timecard,configuration,receipt,receivable,payrate,pendingemployee,workflow','eFP',0,null)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'HOMEDIRLETTER' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('HOMEDIRLETTER','D:','eFP',1,15)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'IMAGE_FOLDER_VIEW' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('IMAGE_FOLDER_VIEW','0','eFP',0,NULL)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'IMAGE_DIR_ENTITY' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('IMAGE_DIR_ENTITY','\\\\server\\attach\\entity\\','eFP',1,NULL)

 IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'IMAGE_DIR_MISCBILL' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('IMAGE_DIR_MISCBILL','\\\\server\\attach\\miscbill\\','eFP',1,NULL)

 IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'IMAGE_DIR_PARCEL' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('IMAGE_DIR_PARCEL','\\\\server\\attach\\parcel\\','eFP',1,NULL)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'hrms' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('hrms','@@SPIFPS@@/hrm/src','eFP',1,500)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'hrmx' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('hrmx','@@SPIFPS@@/hrm/bin','eFP',1,505)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'libs' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('libs','@@SPISHARE@@/lib/src','eFP',1,520)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'libt' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('libt','@@SPISHARE@@/lib/tools','eFP',1,525)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'libx' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('libx','@@SPISHARE@@/lib/bin','eFP',1,530)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'mens' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('mens','@@SPISHARE@@/men/src','eFP',1,535)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'menx' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('menx','@@SPISHARE@@/men/bin','eFP',1,540)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'migs' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('migs','@@SPIFPS@@/mig/src','eFP',1,545)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'migx' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('migx','@@SPIFPS@@/mig/bin','eFP',1,550)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'mrs' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('mrs','@@SPICPS@@/mr/src','eFP',1,565)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'mrx' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('mrx','@@SPICPS@@/mr/bin','eFP',1,570)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'notificationsPath' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('notificationsPath',('/eFP' + @currentVersion + '/Notifications/Web/'),'eFP',0,null)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'OPTIO_AP_DIR' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('OPTIO_AP_DIR','\\@@OPTIOSERVER@@\attach','eFP',1,215)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'OPTIO_PO_DIR' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('OPTIO_PO_DIR','\\@@OPTIOSERVER@@\attach','eFP',1,220)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'OPTIO_SERVER' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('OPTIO_SERVER','//@@OPTIOSERVER@@','eFP',1,225)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'OPTIO_TEMP_DIR' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('OPTIO_TEMP_DIR','//@@OPTIOSERVER@@/spitmp','eFP',1,83)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'OPTIOSERVER' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('OPTIOSERVER','<optio_server>','eFP',1,82)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'password_requirements_message' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('password_requirements_message',null,'eFP',0,null)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'PATH' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('PATH','@@PLUSPATH@@;@@FGLDIR@@/bin;@@FGLLDPATH@@;.;@@SPIHOMEDIR@@;','eFP',1,800)    

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'pbs' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('pbs','@@SPICPS@@/pb/src','eFP',1,575)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'pbss' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('pbss','@@SPIFPS@@/pbs/src','eFP',1,580)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'pbsx' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('pbsx','@@SPIFPS@@/pbs/bin','eFP',1,585)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'pbx' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('pbx','@@SPICPS@@/pb/bin','eFP',1,590)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'pems' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('pems','@@SPIFPS@@/pem/src','eFP',1,600)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'pemx' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('pemx','@@SPIFPS@@/pem/bin','eFP',1,605)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'PLUSPATH' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('PLUSPATH','@@SPITOOLS@@/bin;@@SPITOOLS@@/mks/bin64;@@SPITOOLS@@/mks/bin;@@SPITOOLS@@/mks/bin/X11;@@SPITOOLS@@/mks/mksnt;@@BCPPATH@@;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\','eFP',1,null)
ELSE
 IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'PLUSPATH' AND product_id= 'eFP' AND var_value LIKE '%BCPPATH%')
    UPDATE global_variable SET var_value = var_value + ';@@BCPPATH@@' WHERE var_name = 'PLUSPATH' AND product_id = 'eFP'

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'POSTAPP' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('POSTAPP','/ApplicantTracking/PostingApprovalEFP.aspx','eFP',0,null)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'POSTINFO' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('POSTINFO','/ApplicantTracking/PostingOverview.aspx','eFP',0,null)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'POSTREQ' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('POSTREQ','/WebPostingRequest.aspx','eFP',0,null)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'PRTLDOCSCONFIG' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('PRTLDOCSCONFIG','/GeneralConfig/DocumentsSetup.aspx','eFP',0,null)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'PRTLHELPCONFIG' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('PRTLHELPCONFIG','/GeneralConfig/HelpEditor.aspx','eFP',0,null)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'PRTLMENUOPTIONS' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('PRTLMENUOPTIONS','/GeneralConfig/WebMenuOptions.aspx','eFP',0,null)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'PRTLOLOPTIONS' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('PRTLOLOPTIONS','/GeneralConfig/WebOnlinePresentationSetup.aspx','eFP',0,null)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'PRTLPRIVACY' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('PRTLPRIVACY','/GeneralConfig/PrivacyStatementSetup.aspx','eFP',0,null)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'PRTLWELCOME' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('PRTLWELCOME','/GeneralConfig/WelcomePageSetup.aspx','eFP',0,null)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'QUESTAPP' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('QUESTAPP','/QuestionSetup/QuestionCategorySetup.aspx','eFP',0,null)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'QUESTEEMP' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('QUESTEEMP','/QuestionSetup/EmpRefSetup.aspx?AppType=eEmp','eFP',0,null)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'QUESTEREF' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('QUESTEREF','/QuestionSetup/EmpRefSetup.aspx?AppType=eRef','eFP',0,null)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'retc' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('retc','@@SPICPS@@/etc','eFP',1,640)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'rms' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('rms','@@SPICPS@@/rm/src','eFP',1,645)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'RMSLOGDIR' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('RMSLOGDIR','@@SPICPS@@/log','eFP',1,150)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'RMSRPTDIR' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('RMSRPTDIR','@@SPIDRIVE@@/users/@@LOGNAME@@/rpt','eFP',1,155)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'RMSTAPDIR' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('RMSTAPDIR','@@SPICPS@@/media','eFP',1,160)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'rmx' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('rmx','@@SPICPS@@/rm/bin','eFP',1,650)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'RUNTIME' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('RUNTIME','@@SPITOOLS@@/4jsplus/runtime@@FOURJSVER@@','eFP',1,115)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'secs' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('secs','@@SPISHARE@@/sec/src','eFP',1,665)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'secx' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('secx','@@SPISHARE@@/sec/bin','eFP',1,670)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPI4JS' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPI4JS','1','eFP',1,55)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPIADSERVER' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPIADSERVER','@@SPIWORKFLOWSERVER@@/eFP@@FPSVER@@/','eFP',1,230)
ELSE
 UPDATE global_variable SET var_value = '@@SPIWORKFLOWSERVER@@/eFP@@FPSVER@@/' WHERE var_name= 'SPIADSERVER' AND product_id= 'eFP'

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPIAPPSERVER' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPIAPPSERVER',('http://<application_server>/eFP' + @currentVersion + '/eFinancePLUS/Sungard.eFinancePLUS.Web/Notifications/Entry/Subscriptions/'),'eFP',1,235)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPIASP' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPIASP','0','eFP',1,6)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPIATTACHSERVER' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPIATTACHSERVER','@@SPIWORKFLOWSERVER@@/DocumentsOnline/Web/DocumentViewer.aspx?FileName=@PARAM@','eFP',1,240)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPIATTACHSERVICE' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPIATTACHSERVICE','@@SPIWORKFLOWSERVER@@/SharedServices/Documents/Attachments.svc','eFP',1,245)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPICLIENTDEFAULTPATH' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPICLIENTDEFAULTPATH','  ','eFP',1,42)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPICLIENTDIR' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPICLIENTDIR','/tmp/','eFP',1,62)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPICONSORTIUM' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPICONSORTIUM','0','eFP',1,801)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPICPS' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPICPS','@@SPIDRIVE@@/@@SPIHOME@@/spicps','eFP',1,105)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPIDBAUTH' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPIDBAUTH','1','eFP',1,35)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPIDIRTREAD' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPIDIRTREAD','0','eFP',1,60)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPIDRIVE' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPIDRIVE','D:','eFP',1,10)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPIEACURL' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPIEACURL','@@SPIWORKFLOWSERVER@@/EmployeeAccessCenter/Web/Default.aspx','eFP',1,250)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPIETSURL' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPIETSURL','@@SPIWORKFLOWSERVER@@/EmployeeTimeSheet/Web/Default.aspx','eFP',1,255)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPIEXCELEXTENSION' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPIEXCELEXTENSION','xls','eFP',1,63)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPIEXCELFORMAT' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPIEXCELFORMAT','XML','eFP',1,64)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPIEXTERNALWORKFLOWSERVER' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPIEXTERNALWORKFLOWSERVER','  ','eFP',1,11)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPIFEEDBACKSERVICE' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPIFEEDBACKSERVICE','@@SPIWORKFLOWSERVER@@/SharedServices/UserFeedback/UserFeedbackService.svc','eFP',1,270)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPIFPS' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPIFPS','@@SPIDRIVE@@/@@SPIHOME@@/spifps','eFP',1,100)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPIGAS' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPIGAS','1','eFP',1,20)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPIGWC' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPIGWC','1','eFP',1,25)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPIGWCASP' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPIGWCASP','0','eFP',1,7)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPIHOME' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPIHOME',('spi/@@FPSVER@@'),'eFP',1,30)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPIHOMEDIR' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPIHOMEDIR','@@HOMEDIRLETTER@@\users\@@LOGNAME@@','eFP',1,32)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPIIMAGEEXTENSION' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPIIMAGEEXTENSION','.jpg','eFP',1,67)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPIJACURL' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPIJACURL','@@SPIWORKFLOWSERVER@@/JobApplicantCenter/Web/Default.aspx','eFP',1,275)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPIJAVURL' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPIJAVURL','@@SPIWORKFLOWSERVER@@/JobApplicantCenter/Admin/Default.aspx','eFP',1,280)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPILEARNING' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPILEARNING','@@SPIWORKFLOWSERVER@@/eLearning','eFP',1,285)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPIMACDIR' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPIMACDIR','  ','eFP',1,46)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPIMACMAIL' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPIMACMAIL','  ','eFP',1,12)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPIMAILSERVER' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPIMAILSERVER','<mail_server>','eFP',1,210)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPIMAPIMAIL' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPIMAPIMAIL','  ','eFP',1,13)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPINT' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPINT','1','eFP',1,68)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPIONLINE' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPIONLINE','1','eFP',1,69)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPIOWNER' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPIOWNER','K12','eFP',1,70)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPIPICTURE' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPIPICTURE','0','eFP',1,71)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPIPRINT' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPIPRINT','pdf','eFP',1,73)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPIRECRUITMENTSERVER' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPIRECRUITMENTSERVER','@@SPIWORKFLOWSERVER@@/Recruitment/Web/AM','eFP',1,290)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPIRIBBON' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPIRIBBON','1','eFP',1,40)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPISHARE' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPISHARE','@@SPIDRIVE@@/@@SPIHOME@@/spishare','eFP',1,90)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPISUBSYSTEM' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPISUBSYSTEM','RMS','eFP',1,50)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPITOOLS' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPITOOLS','@@SPIDRIVE@@\spi\spitools','eFP',1,95)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPIUSERS' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPIUSERS','@@SPIDRIVE@@/users','eFP',1,85)

--NOT NEEDED ANYMORE
--IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'spiver' AND product_id= 'eFP' )
-- INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('spiver','19.4','eFP',1,4)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPIVPOURL' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPIVPOURL','@@SPIWORKFLOWSERVER@@/VendorPunchout/Web/Login.aspx','eFP',1,295)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPIWEBURL' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPIWEBURL','@@EFPAPPSERVER@@/eFinancePLUS/SunGard.eFinancePLUS.Web','eFP',0,null)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPIWORKFLOWSERVER' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPIWORKFLOWSERVER',('http://<workflow_server>/eFP' + @currentVersion),'eFP',1,211)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SPIXP' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SPIXP','@@SPIDRIVE@@/exportfs/dbexport','eFP',1,675)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SYSEMAIL' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SYSEMAIL','/GeneralSetup/EmailTemplateLookup.aspx','eFP',0,null)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SYSEMPCHECK' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SYSEMPCHECK','/GeneralConfig/ACS.aspx?type=EMPLOYMENT','eFP',0,null)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SYSEXTERNAL' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SYSEXTERNAL','/GeneralConfig/ExternalIntegration.aspx','eFP',0,null)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SYSHIREMGR' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SYSHIREMGR','/GeneralConfig/HAViewSetup.aspx','eFP',0,null)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SYSHIREPROCESS' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SYSHIREPROCESS','/GeneralConfig/ChecklistSetup.aspx','eFP',0,null)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SYSPOSTREQ' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SYSPOSTREQ','/GeneralConfig/WebPostingRequestSetup.aspx','eFP',0,null)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'SYSPREEMP' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('SYSPREEMP','/GeneralConfig/ACS.aspx?type=PEMPLOYMENT','eFP',0,null)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'vbss' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('vbss','@@SPIFPS@@/vbs/src','eFP',1,720)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'vbsx' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('vbsx','@@SPIFPS@@/vbs/bin','eFP',1,725)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'VERIF' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('VERIF','/ApplicantTracking/VerificationList.aspx','eFP',0,null)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'wars' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('wars','@@SPIFPS@@/war/src','eFP',1,740)

IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'warx' AND product_id= 'eFP' )
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('warx','@@SPIFPS@@/war/bin','eFP',1,745)

 IF NOT EXISTS (Select 1 from global_variable WHERE var_name= 'ERPCOMPLIANCEURL' AND product_id= 'eFP')
 INSERT INTO global_variable(var_name,var_value,product_id,is_env_variable,order_id) VALUES ('ERPCOMPLIANCEURL','https://localhost/ComplianceVirtualDirectory/#/Compliance/','eFP',0,null) 

---------------------------------------------------------------------------------------------------------------------------------------------------
