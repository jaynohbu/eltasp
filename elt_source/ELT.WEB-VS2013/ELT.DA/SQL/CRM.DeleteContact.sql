USE [PRDDB]
GO

/****** Object:  StoredProcedure [CRM].[DeleteContact]    Script Date: 05/02/2014 09:15:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [CRM].[DeleteContact]
  @id int  
AS
BEGIN
   
	Delete from  [PRDDB].[dbo].[Contacts]
	where id =@id 
        
END

GO

