-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AddTabAccessForUserType]
	@elt_account_number int,
	@login_name nvarchar(200)	
AS
BEGIN

	DECLARE @Userid int

	DECLARE @UserType int
	DECLARE @is_denied CHAR(1)
	SELECT @Userid =[userid] ,@UserType = [user_type] FROM [dbo].[users] WHERE [elt_account_number] = @elt_account_number AND [login_name] = @login_name
	print @UserType
	

	 DELETE  FROM [dbo].[tab_user] WHERE [elt_account_number] = @elt_account_number AND  [user_id] =@Userid 

		INSERT INTO [dbo].[tab_user]
		([elt_account_number]
		,[user_id]
		,[page_id]
		,[is_denied]
		)
		select @elt_account_number
		, @Userid
		, [page_id],'N' FROM [dbo].[UserType_Tab_Ref] WHERE  User_type =@UserType 

		select * from [dbo].[tab_user]  WHERE [elt_account_number] = @elt_account_number AND user_id = @Userid
	
END
