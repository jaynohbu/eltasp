-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataList].[GetImportFileNumbers]
	@ELT_account_number int,
	@iType char(1)
AS
BEGIN
	SELECT file_no
    FROM [dbo].[import_mawb]
    where [elt_account_number]=@ELT_account_number and ISNULL(file_no,'')<>'' and iType=@iType

END
