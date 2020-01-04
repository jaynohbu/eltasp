USE [PRDDB]
GO

/****** Object:  StoredProcedure [COMM].[MarkMessagesAs]    Script Date: 05/02/2014 09:13:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [COMM].[MarkMessagesAs]
  @id int,
  @unread bit 
    
AS
BEGIN  
	UPDATE [PRDDB].[dbo].[Messages]
	SET unread=@unread
	WHERE id=@id
END

GO

