-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DeveloperUtil].[CreateSystemUser]
	
AS
BEGIN

IF (SELECT COUNT(*) FROM [dbo].[users] WHERE [login_name] ='system')=0
BEGIN

	INSERT INTO [dbo].[users]
			   ([elt_account_number]
			   ,[userid]
			   ,[user_type]
			   ,[user_right]
			   ,[login_name]          
			   ,[user_fname]
			   )
		 VALUES
			   (80002000
			   ,9999
			   ,9
			   ,9
			   ,'system'
			   ,'system')
 END     


update [dbo].[UserProfile] set [elt_account_number]=80002000 where UserName = 'system'
   

END
