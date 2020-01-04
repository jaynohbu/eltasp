﻿
CREATE PROCEDURE [dbo].[GetAllUserAuthorizedPages]
	@elt_account_number decimal,
	@user_id decimal
AS
BEGIN
SELECT [page_label]     
      ,[top_module]
      ,[sub_module]
       ,a.[page_id]
      ,isnull([is_bloked],0) as is_bloked
  FROM  [dbo].[page_user_access] A INNER JOIN DBO.tab_master B ON A.page_id = b.page_id WHERE A.elt_account_number = @elt_account_number and A.user_id = @user_id order by top_module, sub_module, page_label
END