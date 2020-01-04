USE [PRDDB]
GO

/****** Object:  StoredProcedure [dbo].[CopyFile]    Script Date: 05/02/2014 09:17:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[CopyFile] 		
		 @Name varchar(200)
		,@ParentID decimal
		,@IsFolder decimal
		,@FromID decimal				
		,@OwnerEmail varchar(100)
		,@ID decimal out 
AS
BEGIN 
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
	   ,(SELECT ContentID from [PRDDB].[dbo].[Files] WHERE ID = @FromID) 
	   ,@OwnerEmail)
	 set @ID=@@Identity 
END

GO

