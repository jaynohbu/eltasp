
CREATE PROCEDURE [dbo].GetAllUserPages
	@elt_account_number decimal,
	@user_id decimal
AS
BEGIN
SELECT [page_label]     
      ,[top_module]
      ,[sub_module]
       [page_id]
      ,[is_bloked]
  FROM  [dbo].[page_user_access] A INNER JOIN DBO.tab_master B ON A.page_id = b.page_id WHERE A.elt_account_number = @elt_account_number and A.user_id = @user_id
END
