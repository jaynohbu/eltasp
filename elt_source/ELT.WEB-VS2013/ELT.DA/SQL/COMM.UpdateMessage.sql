USE [PRDDB]
GO

/****** Object:  StoredProcedure [COMM].[UpdateMessage]    Script Date: 05/02/2014 09:13:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [COMM].[UpdateMessage]
  @id int,
  @subject nvarchar(200),
  @from nvarchar(100) ,
  @to nvarchar(MAX) ,
  @text ntext, 
  @folder nvarchar(300)
    
AS
BEGIN  
	UPDATE [PRDDB].[dbo].[Messages]
	SET [Date] = getdate()
	,[Subject] = @subject      
	,[To] = @to
	,[Text] = @text
	,[Folder] = @folder
	WHERE id=@id
END

GO

