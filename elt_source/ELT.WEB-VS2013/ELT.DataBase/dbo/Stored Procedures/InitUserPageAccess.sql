
CREATE PROCEDURE [dbo].[InitUserPageAccess]
	@elt_account_number decimal,
	@user_id decimal,
	@user_type int
AS
BEGIN

		--Find Subscription 
	DECLARE @SubsCode nvarchar(50) 
	SELECT @SubsCode=[subscription_code] FROM [dbo].[subscription_freighteasy] where elt_account_number=@elt_account_number

	DECLARE @TbSegments TABLE
	(
	  id int, 
	  SegCode nvarchar(50)
	)	
	DECLARE @TbIds TABLE
	(
		[page_id] int	
	)
	
	INSERT INTO @TbSegments (id, SegCode) SELECT Id, Data FROM dbo.Split(@SubsCode, '_')
	--SELECT * FROM @TbSegments
	DECLARE @Count int
	DECLARE @id int
	DECLARE @Segment nvarchar(50)
	SET @id = 1
	SELECT @Count = count(*) from @TbSegments
	DELETE FROM [dbo].[page_user_access] WHERE elt_account_number=@elt_account_number AND user_id =@user_id
	
	While @id < @Count +1
	Begin
		SELECT @Segment = SegCode FROM @TbSegments WHERE id=@id 
		PRINT 'FOR '+ @Segment
		
		INSERT INTO @TbIds
		(
		[page_id]	
		)	    
		SELECT [page_id] FROM [dbo].[Subscription_Tab_Ref] where [Code_Segmenet] =@Segment 	
		
		DECLARE @Count2 int
		DECLARE @CurID int
		SELECT @Count2 = count(*) from @TbIds
		WHILE @Count2 > 0 
        BEGIN 
            SELECT top 1  @CurID =   [page_id] from @TbIds 
			IF (SELECT Count(*)  FROM [dbo].[page_user_access] WHERE user_id=@user_id and elt_account_number=@elt_account_number and page_id=@CurID) =0 
			BEGIN
				DECLARE @PRINT VARCHAR(500)
				SELECT @PRINT= b.top_module + b.sub_module + b.page_label from tab_master b where b.page_id=@CurID
				PRINT @PRINT
				INSERT INTO [dbo].[page_user_access]
					([elt_account_number]
					,[user_id]
					,[page_id]
					,is_bloked
					)
				SELECT  @elt_account_number, @user_id , @CurID, 1 
			END 
		    DELETE FROM @TbIds WHERE [page_id] =@CurID
			SELECT @Count2 = count(*) from @TbIds			
		END 
		SET @id=@id +1
			
	End

	UPDATE [dbo].[page_user_access] SET is_bloked = 0 WHERE [page_id] IN ( SELECT  [page_id] FROM [dbo].[UserType_Tab_Ref] a 
			WHERE a.User_type=@user_type ) AND user_id =@user_id AND elt_account_number=@elt_account_number	
    
	--SELECT a.*, b.master_url from [dbo].[page_user_access] a inner join tab_master b on a.page_id=b.page_id WHERE isnull(A.is_bloked,0)=0
END
