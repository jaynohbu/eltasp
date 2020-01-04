-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataList].[GetMAWBNos]
	@ELT_account_number int,
	@PortDirection VARCHAR(10)
AS
BEGIN

IF @PortDirection='Export'
	SELECT MAWB_NUM
    FROM [dbo].MAWB_MASTER where [elt_account_number]=@ELT_account_number

IF @PortDirection='Import'
		SELECT [mawb_num]
		FROM [dbo].[import_mawb]
		where [elt_account_number]=@ELT_account_number and iType='A'
END
