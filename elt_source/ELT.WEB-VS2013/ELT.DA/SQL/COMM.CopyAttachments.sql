USE [PRDDB]
GO

/****** Object:  StoredProcedure [COMM].[CopyAttachments]    Script Date: 05/02/2014 09:09:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [COMM].[CopyAttachments]
	@GID decimal,
	@RecipientEmail varchar(100),
	@ParentID decimal
AS
BEGIN
DECLARE @FILES TABLE (ID int, NAME varchar(300)) INSERT INTO @FILES (ID,Name) 
SELECT [ID],NAME FROM [PRDDB].[COMM].[AttachmentLog] WHERE [GID]=@GID AND [RecipientEmail] =@RecipientEmail

DECLARE @Count INT = 0
SELECT @Count= COUNT(*) FROM @FILES

WHile @Count > 0 
begin 
	DECLARE @ID DECIMAL
	DECLARE @NAME NVARCHAR(500)

	SELECT TOP 1  @ID=[ID],@NAME= NAME FROM @FILES ORDER BY ID ;
		DELETE FROM @FILES WHERE ID =@ID 
		EXEC  [dbo].[CopyFile]
		@Name,
		@ParentID ,
		0,
		@FromID = @ID,
		@OwnerEmail = @RecipientEmail,
		@ID = @ID OUTPUT
    
    SELECT @Count= COUNT(*) FROM @FILES
end 
END

GO

