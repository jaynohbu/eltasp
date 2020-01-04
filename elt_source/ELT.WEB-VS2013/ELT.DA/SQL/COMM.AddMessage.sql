USE [PRDDB]
GO

/****** Object:  StoredProcedure [COMM].[AddMessage]    Script Date: 05/02/2014 09:09:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [COMM].[AddMessage]
  @subject nvarchar(200),
  @from nvarchar(100) ,
  @to nvarchar(MAX) ,
  @text ntext, 
  @folder nvarchar(300),
  @isReply bit =0
    
AS
BEGIN
  
	INSERT INTO [PRDDB].[dbo].[Messages]
           ([Date]
           ,[Subject]
           ,[From]
           ,[To]
           ,[Text]
           ,[Folder]
           ,isReply
           ,unread
           )
     VALUES
           (getdate()
           ,@subject
           ,@from
           ,@to
           ,@text
           ,@folder
           ,@isReply
           ,1
          )

END

GO

