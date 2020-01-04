USE [PRDDB]
GO

/****** Object:  StoredProcedure [CRM].[GetCities]    Script Date: 05/02/2014 09:16:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [CRM].[GetCities]
	@country varchar(100)AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
SELECT c.City FROM [Cities] c, [Countries] cr WHERE (c.CountryId = cr.CountryId) and cr.country = @country  order by c.City
END

GO

