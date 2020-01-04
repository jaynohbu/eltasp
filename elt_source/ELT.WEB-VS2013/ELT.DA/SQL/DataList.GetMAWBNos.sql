USE [PRDDB]
GO

/****** Object:  StoredProcedure [DataList].[GetMAWBNos]    Script Date: 05/02/2014 09:17:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataList].[GetMAWBNos]
	@ELT_account_number int
AS
BEGIN
	SELECT MAWB_NUM
    FROM [PRDDB].[dbo].MAWB_MASTER where [elt_account_number]=@ELT_account_number

END

GO

