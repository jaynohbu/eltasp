/****** Object:  StoredProcedure [dbo].[GetScheduleB]    Script Date: 8/7/2014 3:13:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[GetScheduleB]
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

