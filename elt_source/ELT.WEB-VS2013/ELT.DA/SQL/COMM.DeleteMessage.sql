USE [PRDDB]
GO

/****** Object:  StoredProcedure [COMM].[DeleteMessage]    Script Date: 05/02/2014 09:09:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [COMM].[DeleteMessage]
  @id int 
    
AS
BEGIN  
	DELETE FROM [PRDDB].[dbo].[Messages]	
	WHERE id=@id
END

GO

