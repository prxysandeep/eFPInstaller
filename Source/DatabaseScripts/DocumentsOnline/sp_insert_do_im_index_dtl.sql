
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_insert_do_im_index_dtl]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].sp_insert_do_im_index_dtl
GO

/****** Object:  StoredProcedure [dbo].sp_insert_do_im_index_dtl    Script Date: 02/22/2011 12:36:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET NOCOUNT ON
GO
SET XACT_ABORT ON
GO

CREATE PROC [dbo].sp_insert_do_im_index_dtl
@client_name AS VARCHAR(256) = 'FINANCE'
AS
BEGIN

BEGIN TRANSACTION;

DECLARE @index_id AS INTEGER
DECLARE @next_id AS INTEGER
SELECT @next_id = 1
IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'JOURNAL_ENTRY' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'JOURNAL_ENTRY' and [table_name] = 'TRANSACT' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'YR' and [client_name] = @client_name)
	BEGIN
		INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
		SELECT @index_id,  @next_id, N'YR', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'INVOICE' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'INVOICE' and [table_name] = 'DPAYABLE' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'VEND_NO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'VEND_NO', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'PO' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'PO' and [table_name] = 'INVTORY' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'L_PO_NO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'L_PO_NO', 0, NEWID(), @client_name 
	END
END	

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'PO' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'PO' and [table_name] = 'POAPRV' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'PO_NO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'PO_NO', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'INVOICE' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'INVOICE' and [table_name] = 'PAYABLE' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'INVOICE' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'INVOICE', 1, NEWID(), @client_name 
	END
END

--SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'INVOICE' and [table_name] = 'ASSETS' and [client_name] = @client_name
--IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'VEND_NO' and [client_name] = @client_name)
--BEGIN
--INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
--SELECT @index_id, @next_id, N'VEND_NO', 0, NEWID(), @client_name 
--END

--SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'VENDOR' and [table_name] = 'ASSETS' and [client_name] = @client_name
--IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'VEND_NO' and [client_name] = @client_name)
--BEGIN
--INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
--SELECT @index_id, @next_id, N'VEND_NO', 0, NEWID(), @client_name 
--END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'ENCUMBRANCE' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'ENCUMBRANCE' and [table_name] = 'TRANSACT' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'ENC_NO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'ENC_NO', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'JOURNAL_ENTRY' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'JOURNAL_ENTRY' and [table_name] = 'TRANSACT' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'JE_NUMBER' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'JE_NUMBER', 1, NEWID(), @client_name 
	END
END

--SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'POSITION' and [table_name] = 'POSITIONDATA' and [client_name] = @client_name
--IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'CLASSIFY' and [client_name] = @client_name)
--BEGIN
--INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
--SELECT @index_id, @next_id, N'CLASSIFY', 0, NEWID(), @client_name 
--END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'JOURNAL_ENTRY' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'JOURNAL_ENTRY' and [table_name] = 'DJOURNAL' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'YR' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'YR', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'VENDOR' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'VENDOR' and [table_name] = 'TRANSACT' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'VEND_NO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'VEND_NO', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'INVOICE' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'INVOICE' and [table_name] = 'DMANCHK' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'VEND_NO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'VEND_NO', 0, NEWID(), @client_name 
	END
END

--SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'POSITION' and [table_name] = 'POSPRATE' and [client_name] = @client_name
--IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'CLASSIFY' and [client_name] = @client_name)
--BEGIN
--INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
--SELECT @index_id, @next_id, N'CLASSIFY', 0, NEWID(), @client_name 
--END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'INVOICE' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'INVOICE' and [table_name] = 'PAYABLE' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'VEND_NO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'VEND_NO', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'INVOICE' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'INVOICE' and [table_name] = 'TRANSACT' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'INVOICE' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'INVOICE', 1, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'PO' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'PO' and [table_name] = 'TRANSACT' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'ENC_NO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'ENC_NO', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'ACTIVITY' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'ACTIVITY' and [table_name] = 'PAT_ACT' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'SIT_ID' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'SIT_ID', 1, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'VENDOR' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'VENDOR' and [table_name] = 'REQUISIT' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'REC_VEND' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'REC_VEND', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'VENDOR' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'VENDOR' and [table_name] = 'VENDOR' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'VEND_NO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'VEND_NO', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'INVOICE' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'INVOICE' and [table_name] = 'DPAYABLE' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'INVOICE' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'INVOICE', 1, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'AP_CHECK' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'AP_CHECK' and [table_name] = 'TRANSACT' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'CHECK_NO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'CHECK_NO', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'AP_CHECK' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'AP_CHECK' and [table_name] = 'TRANSACT' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'DISB_FUND' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'DISB_FUND', 1, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'AP_CHECK' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'AP_CHECK' and [table_name] = 'TRANSACT' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'YR' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'YR', 2, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'REQUISITION' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'REQUISITION' and [table_name] = 'PURCHASE' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'REQ_NO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'REQ_NO', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'PO' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'PO' and [table_name] = 'REQUISIT' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'PO_NO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'PO_NO', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'INVOICE' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'INVOICE' and [table_name] = 'DMANCHK' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'INVOICE' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'INVOICE', 1, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'PO' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'PO' and [table_name] = 'PURCHASE' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'PO_NO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'PO_NO', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'FIXED_ASSET' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'FIXED_ASSET' and [table_name] = 'ASSETS' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'TAGNO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'TAGNO', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'VENDOR' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'VENDOR' and [table_name] = 'DPAYABLE' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'VEND_NO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'VEND_NO', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'PERSONNEL' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'PERSONNEL' and [table_name] = 'PAT_ACT' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'SIT_ID' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'SIT_ID', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'VENDOR' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'VENDOR' and [table_name] = 'PURCHASE' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'VEND_NO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'VEND_NO', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'VENDOR' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'VENDOR' and [table_name] = 'DMANCHK' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'VEND_NO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'VEND_NO', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'JOURNAL_ENTRY' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'JOURNAL_ENTRY' and [table_name] = 'DJOURNAL' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'JE_NUMBER' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'JE_NUMBER ', 1, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'VENDOR' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'VENDOR' and [table_name] = 'VENDOR' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'VEND_NO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'VEND_NO', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'REQUISITION' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'REQUISITION' and [table_name] = 'REQUISIT' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'REQ_NO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'REQ_NO', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'EMPLOYEE' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'EMPLOYEE' and [table_name] = 'EMPLOYEE' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'EMPL_NO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'EMPL_NO', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'APPLICANT' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'APPLICANT' and [table_name] = 'APPLICANT' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'ID' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'ID', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'VENDOR' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'VENDOR' and [table_name] = 'PAYABLE' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'VEND_NO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'VEND_NO', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'PO' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'PO' and [table_name] = 'CHGORDER' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'PO_NO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'PO_NO', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'INVOICE' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'INVOICE' and [table_name] = 'TRANSACT' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'VEND_NO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'VEND_NO', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'PO' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'PO' and [table_name] = 'PAYABLE' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'ENC_NO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'ENC_NO', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'PO' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'PO' and [table_name] = 'DPAYABLE' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'ENC_NO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'ENC_NO', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'POSITION' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'POSITION' and [table_name] = 'POSPRATE' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'POS' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'POS', 1, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'EMPLOYEE' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'EMPLOYEE' and [table_name] = 'APPLICANT' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'EMPL_NO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'EMPL_NO', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'PO' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'PO' and [table_name] = 'ASSETS' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'PO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'PO', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'POSITION' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'POSITION' and [table_name] = 'POSITIONDATA' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'POS' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'POS', 1, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'VENDOR' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'VENDOR' and [table_name] = 'DVENDOR' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'VEND_NO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'VEND_NO', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'TRANSACTION' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'TRANSACTION' and [table_name] = 'TRANSACT' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'TRANS_NO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'TRANS_NO', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'CERTIFICATE' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'CERTIFICATE' and [table_name] = 'EMP_CERTIFICATE' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'EMPL_NO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'EMPL_NO', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'CERTIFICATE' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'CERTIFICATE' and [table_name] = 'EMP_CERTIFICATE' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'NUMBER' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'NUMBER', 1, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

/* Vendor Access Center */
IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'VENDOR_TAX_FORMS' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'VENDOR_TAX_FORMS' and [table_name] = 'TRANSACT' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'VEND_NO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'VEND_NO', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'VENDOR_TAX_FORMS' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'VENDOR_TAX_FORMS' and [table_name] = 'REQUISIT' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'REC_VEND' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'REC_VEND', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'VENDOR_TAX_FORMS' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'VENDOR_TAX_FORMS' and [table_name] = 'VENDOR' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'VEND_NO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'VEND_NO', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'VENDOR_TAX_FORMS' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'VENDOR_TAX_FORMS' and [table_name] = 'DPAYABLE' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'VEND_NO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'VEND_NO', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'VENDOR_TAX_FORMS' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'VENDOR_TAX_FORMS' and [table_name] = 'PURCHASE' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'VEND_NO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'VEND_NO', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'VENDOR_TAX_FORMS' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'VENDOR_TAX_FORMS' and [table_name] = 'DMANCHK' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'VEND_NO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'VEND_NO', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'VENDOR_TAX_FORMS' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'VENDOR_TAX_FORMS' and [table_name] = 'PAYABLE' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'VEND_NO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'VEND_NO', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'VENDOR_TAX_FORMS' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'VENDOR_TAX_FORMS' and [table_name] = 'DVENDOR' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'VEND_NO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'VEND_NO', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'INVOICE' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'INVOICE' and [table_name] = 'VAC_INVOICE' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'VEND_NO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'VEND_NO', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'INVOICE' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'INVOICE' and [table_name] = 'VAC_INVOICE' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'INVOICE' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'INVOICE', 1, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'VAC_TAX_FORMS' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'VAC_TAX_FORMS' and [table_name] = 'VAC_VENDOR' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'ROW_ID' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'ROW_ID', 0, NEWID(), @client_name 
	END
END

/* Added for Recruitment: Additional Position group for external use that Applicants can see */
IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'POSITION_RM' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'POSITION_RM' and [table_name] = 'POSITIONDATA' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'POS' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'POS', 1, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'POSITION' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'POSITION' and [table_name] = 'BPOSITION' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'POS' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'POS', 1, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'POSITION_RM' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'POSITION_RM' and [table_name] = 'BPOSITION' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'POS' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'POS', 1, NEWID(), @client_name 
	END
END

/* Added for eFP Recruitment */
IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'DOWNLOADS_RM' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'DOWNLOADS_RM' and [table_name] = 'AMSETTING' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'SETTINGKEY' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'SETTINGKEY', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'DOWNLOADS_RM' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'DOWNLOADS_RM' and [table_name] = 'AMSETTING' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'SETTINGGROUP' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'SETTINGGROUP', 1, NEWID(), @client_name 
	END
END

--SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'CERTS_RM' and [table_name] = 'AMAPPLICANTCERTAREA' and [client_name] = @client_name
--IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'DOCUMENTLINK' and [client_name] = @client_name)
--BEGIN
--INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
--SELECT @index_id, @next_id, N'DOCUMENTLINK', 0, NEWID(), @client_name 
--END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'EDUCATION_RM' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'EDUCATION_RM' and [table_name] = 'AMAPPLICANTEDUCATION' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'DOCUMENTLINK' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'DOCUMENTLINK', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'EXPERIENCE_RM' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'EXPERIENCE_RM' and [table_name] = 'AMAPPLICANTEXPERIENCE' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'DOCUMENTLINK' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'DOCUMENTLINK', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'LICENSE_RM' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'LICENSE_RM' and [table_name] = 'AMLICENSECERTIFICATE' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'DOCUMENTLINK' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'DOCUMENTLINK', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'REFERENCE_RM' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'REFERENCE_RM' and [table_name] = 'AMAPPLICANTREFERENCE' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'DOCUMENTLINK' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'DOCUMENTLINK', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'SKILL_RM' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'SKILL_RM' and [table_name] = 'AMAPPLICANTSKILL' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'DOCUMENTLINK' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'DOCUMENTLINK', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'WORKHIST_RM' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'WORKHIST_RM' and [table_name] = 'AMWORKHISTORY' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'DOCUMENTLINK' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'DOCUMENTLINK', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'APPRESPONSES_RM' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'APPRESPONSES_RM' and [table_name] = 'AMAPPLICATIONRESPONSES' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'DOCUMENTLINK' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'DOCUMENTLINK', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'CERTIFICATE_RM' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'CERTIFICATE_RM' and [table_name] = 'AMAPPLICANTCERTTYPE' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'DOCUMENTLINK' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'DOCUMENTLINK', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'PDCOURSE' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'PDCOURSE' and [table_name] = 'PD_COURSE_MSTR' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'COURSE_ID' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'COURSE_ID', 1, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'PD_EMPLOYEE' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'PD_EMPLOYEE' and [table_name] = 'EMPLOYEE' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'EMPL_NO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'EMPL_NO', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'PD_INSTRUCTOR' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'PD_INSTRUCTOR' and [table_name] = 'PD_INST_PART_MSTR' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'INST_PART_ID' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'INST_PART_ID', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'PD_INSTRUCTOR' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'PD_INSTRUCTOR' and [table_name] = 'EMPLOYEE' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'EMPL_NO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'EMPL_NO', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'PDCONTED' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'PDCONTED' and [table_name] = 'EMP_COURSE_DTL' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'UNIQUE_KEY' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'UNIQUE_KEY', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'EMPLOYEE_RM' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'EMPLOYEE_RM' and [table_name] = 'EMPLOYEE' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'EMPL_NO' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'EMPL_NO', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'APPLICANT_RM' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'APPLICANT_RM' and [table_name] = 'AMAPPLICANTDEFINITION' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'APPLICANTID' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'APPLICANTID', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END

IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'POSTINGJOB_RM' and [client_name] = @client_name)
BEGIN
	SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'POSTINGJOB_RM' and [table_name] = 'AMPOSTINGDEFINITION' and [client_name] = @client_name
	IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'POSTINGID' and [client_name] = @client_name)
	BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
	SELECT @index_id, @next_id, N'POSTINGID', 0, NEWID(), @client_name 
	END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
   SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END
IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'BENEFIT_EMPLOYEE' and [client_name] = @client_name)
BEGIN
   SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'BENEFIT_EMPLOYEE' and [table_name] = 'EMPLINFO' and [client_name] = @client_name
   IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'EMPL_NO' and [client_name] = @client_name)
   BEGIN
      INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
      SELECT @index_id, @next_id, N'EMPL_NO', 0, NEWID(), @client_name 
   END
END



IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
   SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END
IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'BENEFIT_DEPENDENT' and [client_name] = @client_name)
BEGIN
   SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'BENEFIT_DEPENDENT' and [table_name] = 'BEN_DEPENDENT' and [client_name] = @client_name
   IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'ROW_ID' and [client_name] = @client_name)
   BEGIN
      INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
      SELECT @index_id, @next_id, N'ROW_ID', 0, NEWID(), @client_name 
   END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
   SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END
IF EXISTS(SELECT 1 FROM [im_attach_mstr] WHERE [attach_id]= 'BENEFIT_BENEFICIARY' and [client_name] = @client_name)
BEGIN
   SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'BENEFIT_BENEFICIARY' and [table_name] = 'BEN_BENEFICI' and [client_name] = @client_name
   IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'ROW_ID' and [client_name] = @client_name)
   BEGIN
      INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
      SELECT @index_id, @next_id, N'ROW_ID', 0, NEWID(), @client_name 
   END
END

/* Added for eContracts */

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END
BEGIN
   SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'CONTRACTS' and [table_name] = 'EMPLOYEE' and [client_name] = @client_name
   IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'EMPL_NO' and [client_name] = @client_name)
   BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
      SELECT @index_id, @next_id, N'EMPL_NO', 0, NEWID(), @client_name 
   END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END
BEGIN
   SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'CONTRACTS' and [table_name] = 'ECONTEMPL' and [client_name] = @client_name
   IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'EMPL_NO' and [client_name] = @client_name)
   BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
      SELECT @index_id, @next_id, N'EMPL_NO', 0, NEWID(), @client_name 
   END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END
BEGIN
   SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'CONTR_TEMPLATE' and [table_name] = 'ECONTDEF' and [client_name] = @client_name
   IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'IDENT' and [client_name] = @client_name)
   BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
      SELECT @index_id, @next_id, N'IDENT', 0, NEWID(), @client_name 
   END
END

IF EXISTS(SELECT 1 FROM [im_index_dtl])
BEGIN
	SELECT @next_id = MAX([field_id]) + 1 FROM [im_index_dtl]
END
BEGIN
   SELECT @index_id = index_id FROM [im_index_mstr] WHERE [attach_id]= 'CONTR_TEMPLATE' and [table_name] = 'ECONTDEF' and [client_name] = @client_name
   IF NOT EXISTS(SELECT 1 FROM [im_index_dtl] WHERE [index_id]= @index_id and [column_name] = 'SCHOOLYR' and [client_name] = @client_name)
   BEGIN
	INSERT INTO [dbo].[im_index_dtl]([index_id], [field_id], [column_name], [sequence], [unique_key], [client_name])
      SELECT @index_id, @next_id, N'SCHOOLYR', 1, NEWID(), @client_name 
   END
END


COMMIT;
RAISERROR (N'[dbo].[im_index_dtl]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;

END
GO