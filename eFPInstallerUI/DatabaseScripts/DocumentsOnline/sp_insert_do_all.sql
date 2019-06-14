IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_insert_do_all]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_insert_do_all]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[benefits_sp_insert_do_im_attach_mstr]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[benefits_sp_insert_do_im_attach_mstr]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[benefits_sp_insert_do_im_index_dtl]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[benefits_sp_insert_do_im_index_dtl]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[benefits_sp_insert_do_im_index_mstr]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[benefits_sp_insert_do_im_index_mstr]
GO
/****** Object:  StoredProcedure [dbo].[sp_insert_do_all]    Script Date: 09/22/2011 12:36:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET NOCOUNT ON
GO
SET XACT_ABORT ON
GO

-- For eFp pass @install = ''
-- For PD pass @install = 'PD'
-- For VAC pass @install = 'VAC'
-- For RM pass @install = 'RM'
-- For All pass @install = 'ALL'

CREATE PROC [dbo].[sp_insert_do_all]
@client_name AS VARCHAR(256) = 'FINANCE',
@install AS CHAR(20) = ''
AS
BEGIN

EXEC [dbo].[sp_insert_do_im_attach_mstr] @client_name , @install;
EXEC [dbo].[sp_insert_do_im_index_mstr] @client_name;
EXEC [dbo].[sp_insert_do_im_index_dtl] @client_name;
EXEC [dbo].[sp_insert_do_im_objects] @client_name;

END


GO

