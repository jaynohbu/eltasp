USE [PRDDB]
GO

/****** Object:  StoredProcedure [dbo].[GetFiles]    Script Date: 05/02/2014 09:18:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[GetFiles] 
	@OwnerEmail varchar(100)
	
AS
BEGIN 
		SELECT isnull(FC.[LastWriteTime],getdate())as [LastWriteTime],
		      
		       FC.[Data],
		       FC.[CreatorEmail],
		       F.OwnerEmail
		  ,F.[Name]
		  ,F.[ID]
		  ,F.[ParentID]
		  ,F.[IsFolder]
		  ,FC.[Data]
		  ,F.[OptimisticLockField]
		  ,F.[GCRecord]
		  ,F.[SSMA_TimeStamp]
		  FROM [PRDDB].[dbo].[Files] F 
		  LEFT OUTER JOIN [PRDDB].[dbo].[FileContent] FC on F.ContentID = FC.ContentID
		  WHERE OwnerEmail = @OwnerEmail 
	 
END

GO

