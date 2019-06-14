
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_insert_do_im_index_mstr]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_insert_do_im_index_mstr]
GO

/****** Object:  StoredProcedure [dbo].[sp_insert_do_im_index_mstr]    Script Date: 02/22/2011 12:36:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET NOCOUNT ON
GO
SET XACT_ABORT ON
GO

CREATE PROC [dbo].[sp_insert_do_im_index_mstr]
@client_name AS VARCHAR(256) = 'FINANCE'
AS
BEGIN

BEGIN TRANSACTION;

DECLARE @next_id AS INTEGER

SELECT @next_id = 1
IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'JOURNAL_ENTRY' and [client_name] = @client_name)
BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'JOURNAL_ENTRY' and [table_name] = 'DJOURNAL' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'JOURNAL_ENTRY', @next_id, N'DJOURNAL', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'VENDOR' and [client_name] = @client_name)
BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'VENDOR' and [table_name] = 'DMANCHK' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'VENDOR', @next_id, N'DMANCHK', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'VENDOR' and [client_name] = @client_name)
BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'VENDOR' and [table_name] = 'PAYABLE' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'VENDOR', @next_id, N'PAYABLE', 1, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'REQUISITION' and [client_name] = @client_name)
BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'REQUISITION' and [table_name] = 'PURCHASE' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'REQUISITION', @next_id, N'PURCHASE', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'INVOICE' and [client_name] = @client_name)
BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'INVOICE' and [table_name] = 'DPAYABLE' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'INVOICE', @next_id, N'DPAYABLE', 1, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'EMPLOYEE' and [client_name] = @client_name)
BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'EMPLOYEE' and [table_name] = 'EMPLOYEE' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'EMPLOYEE', @next_id, N'EMPLOYEE', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'VENDOR' and [client_name] = @client_name)
BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'VENDOR' and [table_name] = 'TRANSACT' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'VENDOR', @next_id, N'TRANSACT', 2, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'INVOICE' and [client_name] = @client_name)
BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'INVOICE' and [table_name] = 'TRANSACT' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'INVOICE', @next_id, N'TRANSACT', 2, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'EMPLOYEE' and [client_name] = @client_name)
BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'EMPLOYEE' and [table_name] = 'APPLICANT' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'EMPLOYEE', @next_id, N'APPLICANT', 1, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'PO' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'PO' and [table_name] = 'CHGORDER' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'PO', @next_id, N'CHGORDER', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'VENDOR' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'VENDOR' and [table_name] = 'VENDOR' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'VENDOR', @next_id, N'VENDOR', 3, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'PO' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'PO' and [table_name] = 'INVTORY' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'PO', @next_id, N'INVTORY', 1, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'PO' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'PO' and [table_name] = 'PURCHASE' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'PO', @next_id, N'PURCHASE', 2, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'INVOICE' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'INVOICE' and [table_name] = 'PAYABLE' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'INVOICE', @next_id, N'PAYABLE', 3, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'VENDOR' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'VENDOR' and [table_name] = 'REQUISIT' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'VENDOR', @next_id, N'REQUISIT', 4, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'REQUISITION' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'REQUISITION' and [table_name] = 'REQUISIT' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'REQUISITION', @next_id, N'REQUISIT', 1, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'INVOICE' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'INVOICE' and [table_name] = 'DMANCHK' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'INVOICE', @next_id, N'DMANCHK', 4, NEWID(), @client_name 
	END
END

--IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'VENDOR' and [table_name] = 'VENDOR' and [client_name] = @client_name)
--BEGIN
--INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
--SELECT N'VENDOR', @next_id, N'VENDOR', 5, NEWID(), @client_name 
--END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'FIXED_ASSET' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'FIXED_ASSET' and [table_name] = 'ASSETS' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'FIXED_ASSET', @next_id, N'ASSETS ', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'POSITION' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'POSITION' and [table_name] = 'POSPRATE' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'POSITION', @next_id, N'POSPRATE', 1, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'VENDOR' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'VENDOR' and [table_name] = 'PURCHASE' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'VENDOR', @next_id, N'PURCHASE', 5, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'JOURNAL_ENTRY' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'JOURNAL_ENTRY' and [table_name] = 'TRANSACT' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'JOURNAL_ENTRY', @next_id, N'TRANSACT', 1, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'APPLICANT' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'APPLICANT' and [table_name] = 'APPLICANT' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'APPLICANT', @next_id, N'APPLICANT', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'PO' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'PO' and [table_name] = 'ASSETS' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'PO', @next_id, N'ASSETS', 3, NEWID(), @client_name  
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'ENCUMBRANCE' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'ENCUMBRANCE' and [table_name] = 'TRANSACT' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'ENCUMBRANCE', @next_id, N'TRANSACT', 0, NEWID(), @client_name  
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'PERSONNEL' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'PERSONNEL' and [table_name] = 'PAT_ACT' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'PERSONNEL', @next_id, N'PAT_ACT', 0, NEWID(), @client_name  
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'ACTIVITY' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'ACTIVITY' and [table_name] = 'PAT_ACT' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'ACTIVITY', @next_id, N'PAT_ACT', 0, NEWID(), @client_name  
	END
END

--IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'VENDOR' and [table_name] = 'ASSETS' and [client_name] = @client_name)
--BEGIN
--INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
--SELECT N'VENDOR', @next_id, N'ASSETS', 6, NEWID(), @client_name 
--END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'AP_CHECK' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'AP_CHECK' and [table_name] = 'TRANSACT' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'AP_CHECK', @next_id, N'TRANSACT', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'POSITION' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'POSITION' and [table_name] = 'POSITIONDATA' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'POSITION', @next_id, N'POSITIONDATA', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'VENDOR' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'VENDOR' and [table_name] = 'DPAYABLE' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'VENDOR', @next_id, N'DPAYABLE', 7, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'PO' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'PO' and [table_name] = 'TRANSACT' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'PO', @next_id, N'TRANSACT', 4, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'PO' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'PO' and [table_name] = 'PAYABLE' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'PO', @next_id, N'PAYABLE', 5, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'PO' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'PO' and [table_name] = 'REQUISIT' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'PO', @next_id, N'REQUISIT', 6, NEWID(), @client_name
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'PO' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'PO' and [table_name] = 'DPAYABLE' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'PO', @next_id, N'DPAYABLE', 7, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'TRANSACTION' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'TRANSACTION' and [table_name] = 'TRANSACT' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'TRANSACTION', @next_id, N'TRANSACT', 0, NEWID(), @client_name
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'VENDOR' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'VENDOR' and [table_name] = 'DVENDOR' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'VENDOR', @next_id, N'DVENDOR', 8, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'PO' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'PO' and [table_name] = 'POAPRV' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'PO', @next_id, N'POAPRV', 8, NEWID(), @client_name
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'CERTIFICATE' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'CERTIFICATE' and [table_name] = 'EMP_CERTIFICATE' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'CERTIFICATE', @next_id, N'EMP_CERTIFICATE', 0, NEWID(), @client_name 
	END
END

/* Vendor Access Center */

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'VENDOR_TAX_FORMS' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'VENDOR_TAX_FORMS' and [table_name] = 'DMANCHK' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'VENDOR_TAX_FORMS', @next_id, N'DMANCHK', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'VENDOR_TAX_FORMS' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'VENDOR_TAX_FORMS' and [table_name] = 'PAYABLE' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'VENDOR_TAX_FORMS', @next_id, N'PAYABLE', 1, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'VENDOR_TAX_FORMS' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'VENDOR_TAX_FORMS' and [table_name] = 'TRANSACT' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'VENDOR_TAX_FORMS', @next_id, N'TRANSACT', 2, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'VENDOR_TAX_FORMS' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'VENDOR_TAX_FORMS' and [table_name] = 'VENDOR' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'VENDOR_TAX_FORMS', @next_id, N'VENDOR', 3, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'VENDOR_TAX_FORMS' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'VENDOR_TAX_FORMS' and [table_name] = 'REQUISIT' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'VENDOR_TAX_FORMS', @next_id, N'REQUISIT', 4, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'VENDOR_TAX_FORMS' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'VENDOR_TAX_FORMS' and [table_name] = 'PURCHASE' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'VENDOR_TAX_FORMS', @next_id, N'PURCHASE', 5, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'VENDOR_TAX_FORMS' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'VENDOR_TAX_FORMS' and [table_name] = 'DPAYABLE' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'VENDOR_TAX_FORMS', @next_id, N'DPAYABLE', 6, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'VENDOR_TAX_FORMS' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'VENDOR_TAX_FORMS' and [table_name] = 'DVENDOR' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'VENDOR_TAX_FORMS', @next_id, N'DVENDOR', 7, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'INVOICE' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'INVOICE' and [table_name] = 'VAC_INVOICE' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'INVOICE', @next_id, N'VAC_INVOICE', 5, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'VAC_TAX_FORMS' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'VAC_TAX_FORMS' and [table_name] = 'VAC_VENDOR' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'VAC_TAX_FORMS', @next_id, N'VAC_VENDOR', 0, NEWID(), @client_name 
	END
END

/* Added for Recruitment: Additional Position group for external use that Applicants can see */

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'POSITION_RM' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'POSITION_RM' and [table_name] = 'POSITIONDATA' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'POSITION_RM', @next_id, N'POSITIONDATA', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'POSITION' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'POSITION' and [table_name] = 'BPOSITION' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'POSITION', @next_id, N'BPOSITION', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'POSITION_RM' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'POSITION_RM' and [table_name] = 'BPOSITION' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'POSITION_RM', @next_id, N'BPOSITION', 0, NEWID(), @client_name 
	END
END

/* Added eFP Recruitment */
IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'DOWNLOADS_RM' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'DOWNLOADS_RM' and [table_name] = 'AMSETTING' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'DOWNLOADS_RM', @next_id, N'AMSETTING', 0, NEWID(), @client_name 
	END
END

--IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'CERTS_RM' and [table_name] = 'AMAPPLICANTCERTAREA' and [client_name] = @client_name)
--BEGIN
--INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
--SELECT N'CERTS_RM', @next_id, N'AMAPPLICANTCERTAREA', 0, NEWID(), @client_name 
--END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'EDUCATION_RM' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'EDUCATION_RM' and [table_name] = 'AMAPPLICANTEDUCATION' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'EDUCATION_RM', @next_id, N'AMAPPLICANTEDUCATION', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'EXPERIENCE_RM' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'EXPERIENCE_RM' and [table_name] = 'AMAPPLICANTEXPERIENCE' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'EXPERIENCE_RM', @next_id, N'AMAPPLICANTEXPERIENCE', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'LICENSE_RM' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'LICENSE_RM' and [table_name] = 'AMLICENSECERTIFICATE' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'LICENSE_RM', @next_id, N'AMLICENSECERTIFICATE', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'REFERENCE_RM' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'REFERENCE_RM' and [table_name] = 'AMAPPLICANTREFERENCE' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'REFERENCE_RM', @next_id, N'AMAPPLICANTREFERENCE', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'APPRESPONSES_RM' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'APPRESPONSES_RM' and [table_name] = 'AMAPPLICATIONRESPONSES' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'APPRESPONSES_RM', @next_id, N'AMAPPLICATIONRESPONSES', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'CERTIFICATE_RM' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'CERTIFICATE_RM' and [table_name] = 'AMAPPLICANTCERTTYPE' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'CERTIFICATE_RM', @next_id, N'AMAPPLICANTCERTTYPE', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'SKILL_RM' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'SKILL_RM' and [table_name] = 'AMAPPLICANTSKILL' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'SKILL_RM', @next_id, N'AMAPPLICANTSKILL', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'WORKHIST_RM' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'WORKHIST_RM' and [table_name] = 'AMWORKHISTORY' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'WORKHIST_RM', @next_id, N'AMWORKHISTORY', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'PDCOURSE' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'PDCOURSE' and [table_name] = 'PD_COURSE_MSTR' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'PDCOURSE', @next_id, N'PD_COURSE_MSTR', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'PD_INSTRUCTOR' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'PD_INSTRUCTOR' and [table_name] = 'PD_INST_PART_MSTR' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'PD_INSTRUCTOR', @next_id, N'PD_INST_PART_MSTR', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'PD_INSTRUCTOR' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'PD_INSTRUCTOR' and [table_name] = 'EMPLOYEE' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'PD_INSTRUCTOR', @next_id, N'EMPLOYEE', 1, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'PDCONTED' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'PDCONTED' and [table_name] = 'EMP_COURSE_DTL' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'PDCONTED', @next_id, N'EMP_COURSE_DTL', 1, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'EMPLOYEE_RM' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'EMPLOYEE_RM' and [table_name] = 'EMPLOYEE' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'EMPLOYEE_RM', @next_id, N'EMPLOYEE', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'APPLICANT_RM' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'APPLICANT_RM' and [table_name] = 'AMAPPLICANTDEFINITION' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'APPLICANT_RM', @next_id, N'AMAPPLICANTDEFINITION', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'POSTINGJOB_RM' and [client_name] = @client_name)
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'POSTINGJOB_RM' and [table_name] = 'AMPOSTINGDEFINITION' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
		SELECT N'POSTINGJOB_RM', @next_id, N'AMPOSTINGDEFINITION', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'EMPL_NO' and [table_name] = 'EMPLINFO' and [client_name] = @client_name)
   BEGIN
      UPDATE [dbo].[im_index_mstr] SET [attach_id]='BENEFIT_EMPLOYEE' WHERE [attach_id]= 'EMPL_NO' and [table_name] = 'EMPLINFO' and [client_name] = @client_name
   END


IF EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'ROW_ID' and [table_name] = 'BEN_DEPENDENT' and [client_name] = @client_name)
   BEGIN
      UPDATE [dbo].[im_index_mstr] SET [attach_id]='BENEFIT_DEPENDENT' WHERE [attach_id]= 'ROW_ID' and [table_name] = 'BEN_DEPENDENT' and [client_name] = @client_name
   END


IF EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'BEN_BENEFICI' and [table_name] = 'BEN_BENEFICI' and [client_name] = @client_name)
   BEGIN
      UPDATE [dbo].[im_index_mstr] SET [attach_id]='BENEFIT_BENEFICIARY' WHERE [attach_id]= 'BEN_BENEFICI' and [table_name] = 'BEN_BENEFICI' and [client_name] = @client_name
   END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
	SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'BENEFIT_EMPLOYEE' and [client_name] = @client_name)
BEGIN
   IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'BENEFIT_EMPLOYEE' and [table_name] = 'EMPLINFO' and [client_name] = @client_name)
   BEGIN
      INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
      SELECT N'BENEFIT_EMPLOYEE', @next_id, N'EMPLINFO', 6, NEWID(), @client_name 
   END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
   SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'BENEFIT_DEPENDENT' and [client_name] = @client_name)
BEGIN
   IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'BENEFIT_DEPENDENT' and [table_name] = 'BEN_DEPENDENT' and [client_name] = @client_name)
   BEGIN
      INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
      SELECT N'BENEFIT_DEPENDENT', @next_id, N'BEN_DEPENDENT', 6, NEWID(), @client_name 
   END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
   SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'BENEFIT_BENEFICIARY' and [client_name] = @client_name)
BEGIN
   IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'BENEFIT_BENEFICIARY' and [table_name] = 'BEN_BENEFICI' and [client_name] = @client_name)
   BEGIN
      INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
      SELECT N'BENEFIT_BENEFICIARY', @next_id, N'BEN_BENEFICI', 6, NEWID(), @client_name 
   END
END

/* Added for eContracts */

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
   SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'CONTRACTS' and [client_name] = @client_name)
BEGIN
   IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'CONTRACTS' and [table_name] = 'EMPLOYEE' and [client_name] = @client_name)
   BEGIN
      INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
      SELECT N'CONTRACTS', @next_id, N'EMPLOYEE', 0, NEWID(), @client_name 
   END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
   SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'CONTRACTS' and [client_name] = @client_name)
BEGIN
   IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'CONTRACTS' and [table_name] = 'ECONTEMPL' and [client_name] = @client_name)
   BEGIN
      INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
      SELECT N'CONTRACTS', @next_id, N'ECONTEMPL', 1, NEWID(), @client_name 
   END
END

IF EXISTS(SELECT 1 FROM [im_index_mstr])
BEGIN
   SELECT @next_id = MAX([index_id]) + 1 FROM [im_index_mstr]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'CONTR_TEMPLATE' and [client_name] = @client_name)
BEGIN
   IF NOT EXISTS(SELECT 1 FROM [im_index_mstr] WHERE [attach_id]= 'CONTR_TEMPLATE' and [table_name] = 'ECONTDEF' and [client_name] = @client_name)
   BEGIN
      INSERT INTO [dbo].[im_index_mstr]([attach_id], [index_id], [table_name], [sequence], [unique_key], [client_name])
      SELECT N'CONTR_TEMPLATE', @next_id, N'ECONTDEF', 0, NEWID(), @client_name 
   END
END

COMMIT;
RAISERROR (N'[dbo].[im_index_mstr]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;

END
GO