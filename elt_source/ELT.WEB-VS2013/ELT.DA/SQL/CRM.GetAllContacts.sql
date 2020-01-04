USE [PRDDB]
GO

/****** Object:  StoredProcedure [CRM].[GetAllContacts]    Script Date: 05/02/2014 09:15:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [CRM].[GetAllContacts]
	@account_email varchar(100)='' AS
BEGIN
SELECT [ID]
      ,[Name]
      ,[Email]
      ,[Address]
      ,[Country]
      ,[City]
      ,[Phone]
      ,[PhotoUrl]
      ,[Collected]
  FROM [PRDDB].[dbo].[Contacts]

END

GO

