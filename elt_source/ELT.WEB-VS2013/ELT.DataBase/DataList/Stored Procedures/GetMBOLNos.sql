-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataList].[GetMBOLNos]
	@ELT_account_number int,
    @PortDirection VARCHAR(10)
AS
BEGIN


IF @PortDirection='Export'
	SELECT MBOL_NUM
    FROM [dbo].MBOL_MASTER where [elt_account_number]=@ELT_account_number
    
    
IF @PortDirection='Import'
		SELECT [mawb_num] as MBOL_NUM
		FROM [dbo].[import_mawb]
		where [elt_account_number]=@ELT_account_number and iType='O'

END
