
CREATE VIEW [dbo].[VW_CustomerInfo]
AS
SELECT elt_account_number, org_account_number, CASE WHEN isnull(class_code, '') = '' THEN dba_name ELSE dba_name + ' [' + RTRIM(LTRIM(isnull(class_code, ''))) + ']' END AS Customer_Name
FROM     dbo.organization with(nolock)
