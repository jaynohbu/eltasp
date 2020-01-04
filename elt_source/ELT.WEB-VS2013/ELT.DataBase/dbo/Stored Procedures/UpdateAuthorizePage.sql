
CREATE PROCEDURE [dbo].UpdateAuthorizePage
	@elt_account_number decimal,
	@user_id decimal,
	@page_id decimal,
	@is_bloked bit
AS
BEGIN
	UPDATE  [dbo].[page_user_access] SET is_bloked=@is_bloked WHERE elt_account_number = @elt_account_number and [user_id] = @user_id and page_id=@page_id
END
