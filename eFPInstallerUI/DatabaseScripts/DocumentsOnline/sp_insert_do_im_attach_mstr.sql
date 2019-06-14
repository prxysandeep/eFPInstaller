
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_insert_do_im_attach_mstr]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_insert_do_im_attach_mstr]
GO

/****** Object:  StoredProcedure [dbo].[sp_insert_do_im_attach_mstr]    Script Date: 02/22/2011 12:36:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET NOCOUNT ON
GO
SET XACT_ABORT ON
GO

CREATE PROC [dbo].[sp_insert_do_im_attach_mstr]
@client_name AS VARCHAR(256) = 'FINANCE',
@install AS CHAR(20) = ''
AS
BEGIN

BEGIN TRANSACTION;

/* eFinancePLUS - eFP */

IF @install = '' OR @install = 'ALL'

BEGIN

	IF NOT EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'ACTIVITY' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_attach_mstr]([attach_id], [attach_desc], [status_cd], [unique_key], [client_name])
	SELECT N'ACTIVITY', N'ACTIVITIES', N'A', NEWID(), @client_name 
	END

	IF NOT EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'INVOICE' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_attach_mstr]([attach_id], [attach_desc], [status_cd], [unique_key], [client_name])
	SELECT N'INVOICE', N'INVOICE', N'A', NEWID(), @client_name 
	END

	IF NOT EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'EMPLOYEE' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_attach_mstr]([attach_id], [attach_desc], [status_cd], [unique_key], [client_name])
	SELECT N'EMPLOYEE', N'EMPLOYEE', N'A', NEWID(), @client_name 
	END

	IF NOT EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'PERSONNEL' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_attach_mstr]([attach_id], [attach_desc], [status_cd], [unique_key], [client_name])
	SELECT N'PERSONNEL', N'PERSONNEL', N'A', NEWID(), @client_name 
	END

	IF NOT EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'APPLICANT' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_attach_mstr]([attach_id], [attach_desc], [status_cd], [unique_key], [client_name])
	SELECT N'APPLICANT', N'APPLICANT', N'A', NEWID(), @client_name 
	END

	IF NOT EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'POSITION' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_attach_mstr]([attach_id], [attach_desc], [status_cd], [unique_key], [client_name])
	SELECT N'POSITION', N'POSITION', N'A', NEWID(), @client_name 
	END

	IF NOT EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'REQUISITION' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_attach_mstr]([attach_id], [attach_desc], [status_cd], [unique_key], [client_name])
	SELECT N'REQUISITION', N'REQUISITION', N'A', NEWID(), @client_name 
	END

	IF NOT EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'PO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_attach_mstr]([attach_id], [attach_desc], [status_cd], [unique_key], [client_name])
	SELECT N'PO', N'PO', N'A', NEWID(), @client_name 
	END

	IF NOT EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'AP_CHECK' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_attach_mstr]([attach_id], [attach_desc], [status_cd], [unique_key], [client_name])
	SELECT N'AP_CHECK', N'AP_CHECK', N'A', NEWID(), @client_name 
	END

	IF NOT EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'ENCUMBRANCE' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_attach_mstr]([attach_id], [attach_desc], [status_cd], [unique_key], [client_name])
	SELECT N'ENCUMBRANCE', N'ENCUMBRANCE', N'A', NEWID(), @client_name 
	END

	IF NOT EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'VENDOR' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_attach_mstr]([attach_id], [attach_desc], [status_cd], [unique_key], [client_name])
	SELECT N'VENDOR', N'VENDOR', N'A', NEWID(), @client_name 
	END

	IF NOT EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'JOURNAL_ENTRY' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_attach_mstr]([attach_id], [attach_desc], [status_cd], [unique_key], [client_name])
	SELECT N'JOURNAL_ENTRY', N'JOURNAL_ENTRY', N'A', NEWID(), @client_name 
	END

	IF NOT EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'FIXED_ASSET' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_attach_mstr]([attach_id], [attach_desc], [status_cd], [unique_key], [client_name])
	SELECT N'FIXED_ASSET', N'FIXED_ASSET', N'A', NEWID(), @client_name
	END

	IF NOT EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'TRANSACTION' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_attach_mstr]([attach_id], [attach_desc], [status_cd], [unique_key], [client_name])
	SELECT N'TRANSACTION', N'TRANSACTION', N'A', NEWID(), @client_name
	END

	IF NOT EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'CERTIFICATE' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_attach_mstr]([attach_id], [attach_desc], [status_cd], [unique_key], [client_name])
	SELECT N'CERTIFICATE', N'CERTIFICATE', N'A', NEWID(), @client_name
	END

	IF NOT EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'VENDOR_TAX_FORMS' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_attach_mstr]([attach_id], [attach_desc], [status_cd], [unique_key], [client_name])
	SELECT N'VENDOR_TAX_FORMS', N'VENDOR_TAX_FORMS', N'A', NEWID(), @client_name 
	END

	IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'EMPL_NO' and [client_name] = @client_name)
	BEGIN
	UPDATE [dbo].[im_attach_mstr] SET [attach_id]='BENEFIT_EMPLOYEE' WHERE [attach_id]= 'EMPL_NO' and [client_name]= @client_name 
	END

	IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'ROW_ID' and [client_name] = @client_name)
	BEGIN
	UPDATE [dbo].[im_attach_mstr] SET [attach_id]='BENEFIT_DEPENDENT' WHERE [attach_id]= 'ROW_ID' and [client_name] = @client_name
	END

	IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'BEN_BENEFICI' and [client_name] = @client_name)
	BEGIN
	UPDATE [dbo].[im_attach_mstr] SET [attach_id]='BENEFIT_BENEFICIARY' WHERE [attach_id]= 'BEN_BENEFICI' and [client_name] = @client_name
	END

	IF NOT EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'BENEFIT_EMPLOYEE' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_attach_mstr]([attach_id], [attach_desc], [status_cd], [unique_key], [client_name])
	SELECT N'BENEFIT_EMPLOYEE', N'BENEFIT_EMPLOYEE', N'A', NEWID(), @client_name 
	END

	IF NOT EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'BENEFIT_DEPENDENT' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_attach_mstr]([attach_id], [attach_desc], [status_cd], [unique_key], [client_name])
	SELECT N'BENEFIT_DEPENDENT', N'BENEFIT_DEPENDENT', N'A', NEWID(), @client_name 
	END

	IF NOT EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'BENEFIT_BENEFICIARY' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_attach_mstr]([attach_id], [attach_desc], [status_cd], [unique_key], [client_name])
	SELECT N'BENEFIT_BENEFICIARY', N'BENEFIT_BENEFICIARY', N'A', NEWID(), @client_name 
	END

	IF NOT EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'PDCONTED' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_attach_mstr]([attach_id], [attach_desc], [status_cd], [unique_key], [client_name])
	SELECT N'PDCONTED', N'PD Continuing Education', N'A', NEWID(), @client_name
	END

	IF NOT EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id] = 'CONTR_TEMPLATE' AND [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_attach_mstr]([attach_id], [attach_desc], [status_cd], [unique_key], [client_name])
	SELECT N'CONTR_TEMPLATE', N'CONTRACT TEMPLATE', 'A', NEWID(), @client_name
	END
	IF NOT EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id] = 'CONTRACTS' AND [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_attach_mstr]([attach_id], [attach_desc], [status_cd], [unique_key], [client_name])
	SELECT N'CONTRACTS', N'SIGNED CONTRACTS', 'A', NEWID(), @client_name
	END
END

/* Vendor Access Center  - VAC */

IF @install = 'VAC' OR @install = 'ALL'

BEGIN


	IF NOT EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'VAC_TAX_FORMS' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_attach_mstr]([attach_id], [attach_desc], [status_cd], [unique_key], [client_name])
	SELECT N'VAC_TAX_FORMS', N'VAC_TAX_FORMS', N'A', NEWID(), @client_name 
	END

END


/* Professional Development  - PD */

IF @install = 'PD' OR @install = 'ALL'

BEGIN

	IF NOT EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'PDCOURSE' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_attach_mstr]([attach_id], [attach_desc], [status_cd], [unique_key], [client_name])
	SELECT N'PDCOURSE', N'PD Course Master', N'A', NEWID(), @client_name 
	END

	IF NOT EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'PD_INSTRUCTOR' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_attach_mstr]([attach_id], [attach_desc], [status_cd], [unique_key], [client_name])
	SELECT N'PD_INSTRUCTOR', N'PD INSTRUCTOR', N'A', NEWID(), @client_name
	END

END

/* Recruitment = RM */

IF @install = 'RM' OR @install = 'ALL'

BEGIN

	IF NOT EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'POSITION_RM' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_attach_mstr]([attach_id], [attach_desc], [status_cd], [unique_key], [client_name])
	SELECT N'POSITION_RM', N'POSITION RM', N'A', NEWID(), @client_name 
	END

	IF NOT EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'DOWNLOADS_RM' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_attach_mstr]([attach_id], [attach_desc], [status_cd], [unique_key], [client_name])
	SELECT N'DOWNLOADS_RM', N'DOWNLOADS RM', N'A', NEWID(), @client_name 
	END

	IF NOT EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'EDUCATION_RM' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_attach_mstr]([attach_id], [attach_desc], [status_cd], [unique_key], [client_name])
	SELECT N'EDUCATION_RM', N'EDUCATION RM', N'A', NEWID(), @client_name 
	END

	IF NOT EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'EXPERIENCE_RM' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_attach_mstr]([attach_id], [attach_desc], [status_cd], [unique_key], [client_name])
	SELECT N'EXPERIENCE_RM', N'EXPERIENCE RM', N'A', NEWID(), @client_name 
	END

	IF NOT EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'LICENSE_RM' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_attach_mstr]([attach_id], [attach_desc], [status_cd], [unique_key], [client_name])
	SELECT N'LICENSE_RM', N'LICENSE RM', N'A', NEWID(), @client_name 
	END

	IF NOT EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'REFERENCE_RM' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_attach_mstr]([attach_id], [attach_desc], [status_cd], [unique_key], [client_name])
	SELECT N'REFERENCE_RM', N'REFERENCE RM', N'A', NEWID(), @client_name 
	END

	IF NOT EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'APPRESPONSES_RM' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_attach_mstr]([attach_id], [attach_desc], [status_cd], [unique_key], [client_name])
	SELECT N'APPRESPONSES_RM', N'RESPONSE RM', N'A', NEWID(), @client_name 
	END

	IF NOT EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'SKILL_RM' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_attach_mstr]([attach_id], [attach_desc], [status_cd], [unique_key], [client_name])
	SELECT N'SKILL_RM', N'SKILLS RM', N'A', NEWID(), @client_name 
	END

	IF NOT EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'WORKHIST_RM' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_attach_mstr]([attach_id], [attach_desc], [status_cd], [unique_key], [client_name])
	SELECT N'WORKHIST_RM', N'WORK HISTORY RM', N'A', NEWID(), @client_name 
	END

	IF NOT EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'EMPLOYEE_RM' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_attach_mstr]([attach_id], [attach_desc], [status_cd], [unique_key], [client_name])
	SELECT N'EMPLOYEE_RM', N'EMPLOYEE RM', N'A', NEWID(), @client_name 
	END

	IF NOT EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'APPLICANT_RM' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_attach_mstr]([attach_id], [attach_desc], [status_cd], [unique_key], [client_name])
	SELECT N'APPLICANT_RM', N'APPLICANT RM', N'A', NEWID(), @client_name 
	END

	IF NOT EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'CERTIFICATE_RM' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_attach_mstr]([attach_id], [attach_desc], [status_cd], [unique_key], [client_name])
	SELECT N'CERTIFICATE_RM', N'CERTIFICATE RM', N'A', NEWID(), @client_name 
	END

	IF NOT EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'POSTINGJOB_RM' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_attach_mstr]([attach_id], [attach_desc], [status_cd], [unique_key], [client_name])
	SELECT N'POSTINGJOB_RM', N'POSTING JOB RM', N'A', NEWID(), @client_name 
	END
	
END

COMMIT;
RAISERROR (N'[dbo].[im_attach_mstr]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;

END
GO
