-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataList].[GetOceanExportFileNumbers]
	@ELT_account_number int
AS
BEGIN
	SELECT file_no
    FROM [dbo].ocean_booking_number 
    where [elt_account_number]=@ELT_account_number and ISNULL(file_no,'')<>''

END
