-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataList].[GetHAWBNos]
	@ELT_account_number int,
	@PortDirection varchar(10)
AS
BEGIN
    IF @PortDirection='Export'
		SELECT [HAWB_NUM]
		FROM [dbo].[HAWB_master] 
		where [elt_account_number]=@ELT_account_number
    
    IF @PortDirection='Import'
		SELECT [hawb_num]
		FROM [dbo].[import_hawb]
		where [elt_account_number]=@ELT_account_number AND iType='A'
END
