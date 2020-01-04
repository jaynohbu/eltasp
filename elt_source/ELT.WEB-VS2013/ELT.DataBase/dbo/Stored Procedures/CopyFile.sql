

CREATE PROCEDURE [dbo].[CopyFile] 		
		 @Name varchar(200)
		,@ParentID decimal
		,@IsFolder decimal
		,@FromID decimal				
		,@OwnerEmail varchar(100)
		,@ID decimal out 
AS
BEGIN 
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
	   ,(SELECT ContentID from [dbo].[Files] WHERE ID = @FromID) 
	   ,@OwnerEmail)
	 set @ID=@@Identity 
END
