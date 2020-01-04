USE [PRDDB]
GO

/****** Object:  StoredProcedure [COMM].[GetAllMailNodes]    Script Date: 05/02/2014 09:10:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [COMM].[GetAllMailNodes]
	@account_email varchar(100)
AS
BEGIN
 with nodes as(
  SELECT distinct m.Folder, m.org_account_number, o.dba_name
  FROM [PRDDB].[dbo].[Messages] m left outer join organization o on o.org_account_number = m.org_account_number and o.elt_account_number = 10001000
  )
  select case when isnumeric(nodes.Folder) =1 then nodes.dba_name else nodes.folder end as Folder from nodes
END

GO

