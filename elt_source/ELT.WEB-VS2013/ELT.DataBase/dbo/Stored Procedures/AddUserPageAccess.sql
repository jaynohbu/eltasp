
CREATE PROCEDURE [dbo].[AddUserPageAccess]
	@elt_account_number decimal,
	@user_id decimal,
	@page_id int
AS
BEGIN
	INSERT INTO [dbo].[page_user_access]
					([elt_account_number]
					,[user_id]
					,[page_id]
					)
	SELECT @elt_account_number,@user_id,@page_id

END
