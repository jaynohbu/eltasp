USE [PRDDB]
GO

/****** Object:  StoredProcedure [DataList].[GetAirExportFileNumbers]    Script Date: 05/02/2014 09:16:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataList].[GetAirExportFileNumbers]
	@ELT_account_number int
AS
BEGIN
	SELECT FILE#
    FROM [PRDDB].[dbo].MAWB_NUMBER 
    where [elt_account_number]=@ELT_account_number and ISNULL(FILE#,'')<>''

END

GO

