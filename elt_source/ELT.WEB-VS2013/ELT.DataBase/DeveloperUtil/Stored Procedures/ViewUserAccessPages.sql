

CREATE PROCEDURE [DeveloperUtil].[ViewUserAccessPages]
	@elt_account_number decimal,
	@user_id decimal	
AS
BEGIN
--1000
--60281000
	
    
	SELECT a.*, b.master_url from [dbo].[page_user_access] a inner join tab_master b on a.page_id=b.page_id WHERE isnull(A.is_bloked,0)=0 and a.elt_account_number=@elt_account_number and a.user_id=@user_id
END

	