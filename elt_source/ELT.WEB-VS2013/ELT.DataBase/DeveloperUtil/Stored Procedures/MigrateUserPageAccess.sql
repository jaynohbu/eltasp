-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE DeveloperUtil.MigrateUserPageAccess

AS
BEGIN	 
	DECLARE @TbSegments TABLE
	(
	  ID int IDENTITY (18, 1) NOT NULL , 
	  userid int,
	  elt_account_number decimal,
	  user_type int
	)
	INSERT INTO @TbSegments (userid,elt_account_number,user_type)  SELECT userid, elt_account_number, user_type   from users 
	DECLARE @Count int
	DECLARE @id int
	DECLARE @Segment nvarchar(50)
	DECLARE @elt_account_number decimal
	DECLARE @user_id int
	DECLARE @user_type int
	SELECT @Count = count(*) from users
	DELETE FROM [dbo].[page_user_access]
	SET @id = 1

	While @id < @Count +1
	Begin
		SELECT  @elt_account_number=elt_account_number,@user_id=userid, @user_type=user_type FROM @TbSegments where id =@id
		EXEC	[dbo].[InitUserPageAccess] @elt_account_number, @user_id,@user_type 
		SET @id=@id +1
	END
END
