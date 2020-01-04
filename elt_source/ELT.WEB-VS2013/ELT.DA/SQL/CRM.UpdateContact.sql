USE [PRDDB]
GO

/****** Object:  StoredProcedure [CRM].[UpdateContact]    Script Date: 05/02/2014 09:16:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [CRM].[UpdateContact]
@id int, 
@name nvarchar(50),
 @email nvarchar(50) ,
  @address nvarchar(100), 
  @country nvarchar(100), 
  @city nvarchar(100), 
  @phone nvarchar(100),
  @photoUrl varchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
UPDATE [PRDDB].[dbo].[Contacts]
   SET [Name] = @name
      ,[Email] = @email
      ,[Address] = @address
      ,[Country] = @country
      ,[City] = @city
      ,[Phone] = @phone
      ,[PhotoUrl] = @photoUrl
      
 WHERE id =@id
END

GO

