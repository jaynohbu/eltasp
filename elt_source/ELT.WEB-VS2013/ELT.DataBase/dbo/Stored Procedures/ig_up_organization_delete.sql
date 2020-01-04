
/****** Object:  Stored Procedure dbo.ig_up_organization_delete    Script Date: 7/31/2008 11:07:36 AM ******/

/****** Object:  Stored Procedure dbo.ig_up_organization_delete    Script Date: 5/5/2008 2:56:02 PM ******/

/****** Object:  Stored Procedure dbo.ig_up_organization_delete    Script Date: 5/5/2008 2:47:35 PM ******/

/****** Object:  Stored Procedure dbo.ig_up_organization_delete    Script Date: 5/5/2008 2:24:38 PM ******/

/****** Object:  Stored Procedure dbo.ig_up_organization_delete    Script Date: 5/13/2006 10:39:02 PM ******/

CREATE PROCEDURE dbo.ig_up_organization_delete
(
	@elt_account_number numeric(8),
	@org_account_number numeric(7)
)
AS
	SET NOCOUNT OFF;
DELETE FROM organization WHERE (elt_account_number = @elt_account_number) AND (org_account_number = @org_account_number) 





