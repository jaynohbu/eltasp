USE [PRDDB]
GO

/****** Object:  StoredProcedure [DataList].[GetHAWBNos]    Script Date: 05/02/2014 09:17:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataList].[GetHAWBNos]
	@ELT_account_number int
AS
BEGIN
	SELECT [HAWB_NUM]
    FROM [PRDDB].[dbo].[HAWB_master] where [elt_account_number]=@ELT_account_number

END

GO

