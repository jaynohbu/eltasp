USE [PRDDB]
GO
/****** Object:  StoredProcedure [COMM].[LogFileAttachment]    Script Date: 05/02/2014 14:33:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [COMM].[LogFileAttachment]
	@GID decimal out,
	@RecipientEmail varchar(100),	
	@Name nvarchar(500),
	@FileID int
AS
BEGIN

INSERT INTO [PRDDB].[COMM].[AttachmentLog]
       ([GID]
       ,[RecipientEmail]
       ,[FileID]
       , Name
       ,[IsDelivered])
SELECT @GID,@RecipientEmail, @FileID,@Name, 0 



END
