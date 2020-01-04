USE [PRDDB]
GO

/****** Object:  StoredProcedure [dbo].[CreateFile]    Script Date: 05/02/2014 09:17:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[CreateFile] 		
		 @Name varchar(200)
		,@ParentID decimal
		,@IsFolder bit
		,@Data varbinary(max)		
		,@CreatorEmail varchar(100)
		,@ID decimal out 
AS
BEGIN 

	INSERT INTO [PRDDB].[dbo].[FileContent]
		   ([LastWriteTime]
		   ,[Data]
		   ,[CreatorEmail]
		   )
	 VALUES
		   (getdate()        
		   ,@Data
		   ,@CreatorEmail)

	INSERT INTO [PRDDB].[dbo].[Files]
	   ([Name]
	   ,[ParentID]
	   ,[IsFolder] 
	   ,ContentID    
	   ,OwnerEmail)
	VALUES
	   (@Name 
	   ,@ParentID
	   ,@IsFolder
	   ,@@Identity 
	   ,@CreatorEmail)
	 
	 set @ID=@@Identity 
END

GO

