USE [PRDDB]
GO

/****** Object:  StoredProcedure [CRM].[AddContact]    Script Date: 05/02/2014 09:14:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [CRM].[AddContact]
  @name nvarchar(50),
  @email nvarchar(50) ,
  @address nvarchar(100), 
  @country nvarchar(100), 
  @city nvarchar(100), 
  @phone nvarchar(100),
  @photoUrl varchar(100)
AS
BEGIN
    If (0= (select count(*)from [dbo].[Contacts] where email = @email))
	INSERT INTO [PRDDB].[dbo].[Contacts]
           ([Name]
           ,[Email]
           ,[Address]
           ,[Country]
           ,[City]
           ,[Phone]
           ,[PhotoUrl]
           )
     VALUES
           (@name
           ,@email
           ,@address
           ,@country
           ,@city
           ,@phone
           ,@photoUrl
           )
END

GO

