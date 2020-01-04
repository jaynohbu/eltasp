-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetRootFileItemID]
	@UserEmail Varchar(100),
	@ID int out 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SELECT Top 1 @ID = isnull([ID],0) FROM [dbo].[Files]
   WHERE OwnerEmail= @UserEmail and IsFolder = 1 and ParentID = -1 ORDER BY ID 
END
