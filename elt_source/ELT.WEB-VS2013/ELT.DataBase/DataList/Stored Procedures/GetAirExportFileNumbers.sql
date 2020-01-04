-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataList].[GetAirExportFileNumbers]
	@ELT_account_number int
AS
BEGIN
	SELECT FILE#
    FROM [dbo].MAWB_NUMBER 
    where [elt_account_number]=@ELT_account_number and ISNULL(FILE#,'')<>''

END
