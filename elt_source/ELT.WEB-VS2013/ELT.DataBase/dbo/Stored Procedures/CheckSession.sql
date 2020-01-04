CREATE PROCEDURE [dbo].[CheckSession]
    @elt_account_number int,
    @operation int,
	@user_name nvarchar(100),
	@url nvarchar(200),
	@ip varchar(20),
	@sessionid varchar(100),
	@reason nvarchar(300),
	@Msg nvarchar(300) out,
	@Result bit out
AS
BEGIN
    SET @Result=0
	DECLARE @SessionTime int = 30
--@operation 
--1. add to table
	IF @operation = 1
	BEGIN 
	 
	  declare @maxuser int
	 
	  SELECT @maxuser =isnull( [maxuser],5) FROM [dbo].[agent] where elt_account_number=@elt_account_number

	  IF @maxuser < = ( select count(distinct a.login_name) from [dbo].UserSession a inner join dbo.users b on a.login_name=b.login_name  where b.elt_account_number=@elt_account_number AND alive=1 AND DATEDIFF(minute, last_updated, GETDATE()) < @SessionTime) 
	  BEGIN
		SET @Msg='Maximum allowed user number reached.'
		SET @Result=0
	  END	  
	  ELSE
	  BEGIN 
		  SET @Result=1  
		  IF (select count(*) from [dbo].UserSession  WHERE login_name=@user_name  AND alive=1 AND DATEDIFF(minute, last_updated, GETDATE()) < @SessionTime) > 0 
			  BEGIN
				--'User already logged in the system.'
				   UPDATE [dbo].UserSession SET alive=0, kick_out_reason='Re Login'  WHERE login_name=@user_name and alive=1
					INSERT INTO [dbo].UserSession
					   ([session_id]				 
					   ,[ip]
					   ,[Requested_page]
					   ,[login_name]
					   ,login_time				         
					   ,[last_updated]
						,elt_account_number   
					   ,alive
					  )
				 VALUES
					   (@sessionid				
					   ,@ip
					   ,@url
					   ,@user_name
					   ,getdate()
					   ,getdate()
						,@elt_account_number   
					   ,1
					  )
			  END	
		  ELSE
		  BEGIN		  
			INSERT INTO [dbo].UserSession
				   ([session_id]				 
				   ,[ip]
				   ,[Requested_page]
				   ,[login_name]
				   ,login_time				         
				   ,[last_updated]
				    ,elt_account_number   
				   ,alive
				  )
			 VALUES
				   (@sessionid			
				   ,@ip
				   ,@url
				   ,@user_name
				   ,getdate()
				   ,getdate()
				    ,@elt_account_number   
				   ,1
				  )
			SET @Result=1
		  END 
	  END 
	END --IF @operation = 1
	IF @operation = 2
	BEGIN
	---2. check  
	-- a. check if exist if not return false
	-- b. check if it is expired (30 min) if so kick out @operation = 3 
	-- c. update timestamp
		DECLARE @last_updated datetime
	
		SELECT @last_updated=last_updated
		FROM [dbo].UserSession WHERE (session_id =@sessionid) and login_name=@user_name and alive=1
		IF @last_updated IS NULL 
			SET @Result=0
		ELSE 
		BEGIN
			IF DATEDIFF(minute, @last_updated, GETDATE()) > @SessionTime
				BEGIN
					SET @operation=2
					SET @Msg='User session timed out.'
					  UPDATE [dbo].UserSession SET alive=0, kick_out_reason=@Msg  WHERE login_name=@user_name and session_id=@sessionid 
				END 
			ELSE 
				BEGIN 					
						UPDATE [dbo].UserSession SET [Requested_page] = @url ,[last_updated]=getdate() WHERE [session_id]=@sessionid
					SET @Result=1
				END 
			END 
		END --IF @operation = 2
    IF @operation = 3 
--3. kick out the user
	BEGIN
		UPDATE [dbo].UserSession SET [alive] = 0, kick_out_reason='Sign Out',last_updated=getdate()  WHERE login_name=@user_name and session_id=@sessionid
		SET @Result=0
	END 
END


GO


