
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_insert_do_im_objects]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_insert_do_im_objects]
GO

/****** Object:  StoredProcedure [dbo].[sp_insert_do_im_objects]    Script Date: 02/22/2011 12:36:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET NOCOUNT ON
GO
SET XACT_ABORT ON
GO

CREATE PROC [dbo].[sp_insert_do_im_objects]
@client_name AS VARCHAR(256) = 'FINANCE'
AS
BEGIN

BEGIN TRANSACTION;
IF NOT EXISTS(SELECT 1 FROM [im_objects] WHERE [object_id]= '78E6477D-CB2B-4B89-BFD4-ECF800F2B46F' and [client_name] = @client_name)
BEGIN
INSERT INTO [dbo].[im_objects]([object_id], [object_instance], [object_description], [object_assembly], [object_type], [status_cd], [unique_key], [client_name])
SELECT N'78E6477D-CB2B-4B89-BFD4-ECF800F2B46F', N'eFinancePLUS.Documents.Attach.DataboundAttach', N'Databound Attachment Object', N'eFinancePLUS.Documents.dll', N'A ', N'A ', NEWID(), @client_name
END

IF NOT EXISTS(SELECT 1 FROM [im_objects] WHERE [object_id]= '455C061B-A9A0-4A67-A45C-194F0950732E' and [client_name] = @client_name)
BEGIN
INSERT INTO [dbo].[im_objects]([object_id], [object_instance], [object_description], [object_assembly], [object_type], [status_cd], [unique_key], [client_name])
SELECT N'455C061B-A9A0-4A67-A45C-194F0950732E', N'eFinancePLUS.Documents.Storage.FinanceStorage', N'Finance Storage Object', N'eFinancePLUS.Documents.dll', N'S ', N'A ', NEWID(), @client_name
END

COMMIT;
RAISERROR (N'[dbo].[im_objects]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;

END
GO