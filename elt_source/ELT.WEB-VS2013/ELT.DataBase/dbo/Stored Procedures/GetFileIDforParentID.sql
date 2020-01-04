

CREATE PROCEDURE [dbo].[GetFileIDforParentID]
	@ParentID decimal,
	@OwnerEmail varchar(200),
	@ID decimal out
AS
BEGIN 
		SELECT top 1 @ID=F.ID
		  FROM [dbo].[Files] F 
		  LEFT OUTER JOIN [dbo].[FileContent] FC on F.ContentID = FC.ContentID
		  WHERE ParentID = @ParentID and OwnerEmail=@OwnerEmail order by F.LastWriteTime desc
	 
END
