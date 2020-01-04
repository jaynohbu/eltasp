

CREATE PROCEDURE [dbo].[GetFileByID] 
	@FileID decimal
	
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
		  FROM [dbo].[Files] F 
		  LEFT OUTER JOIN [dbo].[FileContent] FC on F.ContentID = FC.ContentID
		  WHERE ID = @FileID 
	 
END
