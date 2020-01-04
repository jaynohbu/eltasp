USE [PRDDB]
GO

/****** Object:  StoredProcedure [COMM].[GetUnreadMessages]    Script Date: 05/02/2014 09:12:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [COMM].[GetUnreadMessages]
	@account_email varchar(100)='' AS
BEGIN
SELECT [ID]
      ,[Date]
      ,[Subject]
      ,[From]
      ,[To]
      ,[Text]
      ,[Folder]
      ,[Unread]
      ,[HasAttachment]
      ,[IsReply]
  FROM [PRDDB].[dbo].[Messages]
  WHERE UNREAD = 1 


END

GO

