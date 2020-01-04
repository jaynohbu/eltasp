-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CheckPageAccess]
	@elt_account_number int,
	@login_name nvarchar(200),
	@url nvarchar(500),
	@result  bit out
AS
BEGIN
--1. Find out user_id with email-- return false if it doesn't exist
--2. Find out page_id with url 
--3. Check if it has the entry --return false if not
--4. Checck if it has entry but blocked --return false if bloked
--4. return true
	DECLARE @Userid int
	DECLARE @Pageid int
	DECLARE @is_blockecd bit
	SELECT @Userid =[userid] FROM [dbo].[users] WHERE [elt_account_number] = @elt_account_number AND [login_name] = @login_name
	SET @result =0

	SELECT @Pageid=[page_id] FROM [dbo].[tab_master] WHERE [master_url] LIKE '%'+ @url+'%'
	PRINT @url
	PRINT @Pageid
	IF @Pageid IS NOT NULL
	BEGIN 
		SELECT @is_blockecd = isnull([is_bloked],0) FROM [dbo].[page_user_access] 
		WHERE [elt_account_number] = @elt_account_number AND  [user_id] =@Userid AND [page_id] = @Pageid	
		   IF @is_blockecd = 0
			SET @result =1
		   ELSE 
			SET @result =0
 	END	     
END
