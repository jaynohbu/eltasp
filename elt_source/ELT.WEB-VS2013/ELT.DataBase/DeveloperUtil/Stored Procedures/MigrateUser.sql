


CREATE PROCEDURE DeveloperUtil.MigrateUser
	@elt_account_number int,
	@userid int,
	@login_name nvarchar(200)
AS
BEGIN	
	DECLARE @user_type int
    PRINT 'SET elt_account_number on user  profile'

	UPDATE [dbo].[UserProfile]
	SET [elt_account_number] = @elt_account_number
	WHERE UserName=@login_name

	PRINT 'SET login name for the user table '
	UPDATE [dbo].[users]
	SET [login_name] = @login_name WHERE elt_account_number=@elt_account_number and userid=@userid   

	PRINT 'PAGE ACCESS'
	select @user_type= user_type from dbo.users  WHERE elt_account_number=@elt_account_number and userid=@userid
	EXEC	[dbo].[InitUserPageAccess]
		@elt_account_number,
		@userid ,
		@user_type

	SELECT A.* from users A inner join UserProfile B on A.elt_account_number=B.elt_account_number AND A.login_name = B.UserName
	WHERE A.elt_account_number=@elt_account_number AND A.login_name=@login_name
END
