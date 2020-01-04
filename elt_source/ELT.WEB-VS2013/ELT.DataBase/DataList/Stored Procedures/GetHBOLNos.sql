-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataList].[GetHBOLNos]
	@ELT_account_number int,
    @PortDirection varchar(10)
AS
BEGIN
IF @PortDirection='Export'		
	SELECT [HBOL_NUM]
    FROM [dbo].[HBOL_master] where [elt_account_number]=@ELT_account_number
IF @PortDirection='Import'
		SELECT [hawb_num] AS HBOL_NUM 
		FROM [dbo].[import_hawb]
		where [elt_account_number]=@ELT_account_number AND iType='O'
END
