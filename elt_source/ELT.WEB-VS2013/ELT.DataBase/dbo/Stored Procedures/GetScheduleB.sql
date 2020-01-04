-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetScheduleB]
	@elt_account_number int,
	@description nvarchar(300)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT 
       [sb]
      ,[sb_unit1]
      ,[sb_unit2]
      ,[description]
      ,[export_code]
      ,[license_type]
      ,[eccn]
  FROM [dbo].[scheduleB] 
  WHERE  elt_account_number = @elt_account_number and description = @description
END
