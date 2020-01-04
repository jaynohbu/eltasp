USE [PRDDB]
GO

/****** Object:  StoredProcedure [COMM].[GetFileAttachmentLog]    Script Date: 05/02/2014 09:10:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [COMM].[GetFileAttachmentLog]
	@GID decimal, 
	@RecipientEmail varchar(100)
	
AS
BEGIN
	SELECT [ID]
		  ,[GID]
		  ,[RecipientEmail]
		  ,[FileID]
		  ,[IsDelivered]
	  FROM [PRDDB].[COMM].[AttachmentLog] WHERE GID = @GID AND RecipientEmail = @RecipientEmail
END

GO

