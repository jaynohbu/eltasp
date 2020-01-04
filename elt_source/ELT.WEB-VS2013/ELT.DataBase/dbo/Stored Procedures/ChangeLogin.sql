-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ChangeLogin]   
	@NewLogin nvarchar(100),
	@OldLogin nvarchar(100),
	@elt_account_number int,
	@Msg nvarchar(300) out,
	@Result bit out
AS
BEGIN
SET @Result=0
 --Check if duplicate in UserProfile
IF(SELECT count(*)  FROM [dbo].[UserProfile] where UserName=@NewLogin ) > 0
	BEGIN
		SET @Result=0
		SET @Msg='Email already exists!'
		RETURN 
	END
ELSE
	BEGIN
	IF(SELECT count(*)  FROM [dbo].[UserProfile] where UserName=@OldLogin and elt_account_number=@elt_account_number) = 1 AND (SELECT count(*)  FROM [dbo].users where login_name=@OldLogin and elt_account_number=@elt_account_number) =1 
		BEGIN
			UPDATE [dbo].[UserProfile] SET UserName= @NewLogin WHERE UserName=@OldLogin and elt_account_number=@elt_account_number
			UPDATE [dbo].users SET login_name= @NewLogin WHERE login_name=@OldLogin and elt_account_number=@elt_account_number
			SET @Result=1
		END
	ELSE 
	   BEGIN
	   IF(SELECT count(*)  FROM [dbo].[UserProfile] where UserName=@OldLogin)=0
	    SET @Msg='UserNotCreated'
	   ELSE
		SET @Msg='Can not change this ID due to data error!'
	   END 
	END
END
