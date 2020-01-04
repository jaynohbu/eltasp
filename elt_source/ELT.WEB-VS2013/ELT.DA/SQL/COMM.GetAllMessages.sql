USE [PRDDB]
GO

/****** Object:  StoredProcedure [COMM].[GetAllMessages]    Script Date: 05/02/2014 09:10:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [COMM].[GetAllMessages]
	@account_email varchar(100)='' AS
BEGIN
SELECT [ID]
      ,[Date]
      ,[Subject]
      ,[From]
      ,[To]
      ,[Text]
      , Folder 
      ,[Unread]
      ,[HasAttachment]
      ,[IsReply]
  FROM [PRDDB].[dbo].[Messages] left outer join organization on messages.org_account_number = organization.org_account_number and organization.elt_account_number = 10001000
  


END

GO

