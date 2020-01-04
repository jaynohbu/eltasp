

CREATE PROCEDURE [dbo].[CreateFile] 		
		 @Name varchar(200)
		,@ParentID decimal
		,@IsFolder bit
		,@Data varbinary(max)=null		
		,@CreatorEmail varchar(100)
		,@ID decimal out 
AS
BEGIN 

	INSERT INTO [dbo].[FileContent]
		   ([LastWriteTime]
		   ,[Data]
		   ,[CreatorEmail]
		   )
	 VALUES
		   (getdate()        
		   ,@Data
		   ,@CreatorEmail)

	INSERT INTO [dbo].[Files]
	   ([Name]
	   ,[ParentID]
	   ,[IsFolder] 
	   ,ContentID    
	   ,OwnerEmail)
	VALUES
	   (@Name 
	   ,@ParentID
	   ,@IsFolder
	   ,SCOPE_IDENTITY()
	   ,@CreatorEmail)
	 
	 set @ID=SCOPE_IDENTITY ()
END
