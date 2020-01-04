USE [PRDDB]
GO
/****** Object:  StoredProcedure [COMM].[CreateFileAttachmentGroup]    Script Date: 05/02/2014 14:34:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [COMM].[CreateFileAttachmentGroup]
	@GID decimal out,
	@OriginatorEmail varchar(100),
	@ReferenceNo varchar(100),
	@ReferenceType tinyint
AS
BEGIN
SET ARITHABORT ON

DECLARE @OriginatorID DECIMAL
SELECT @OriginatorID =[UserId] FROM [aspnet-ELT.WEB].[dbo].[UserProfile] WHERE [UserName]=@OriginatorEmail

INSERT INTO [PRDDB].[COMM].[AttachmentFileGroup]
           ([OriginatorID]
           ,[SentDate]
           ,[ReferenceNo]
           ,[ReferenceType])
     VALUES
           (@OriginatorID
           ,Getdate()
           ,@ReferenceNo
           ,@ReferenceType)

SET @GID = @@IDENTITY 

END
