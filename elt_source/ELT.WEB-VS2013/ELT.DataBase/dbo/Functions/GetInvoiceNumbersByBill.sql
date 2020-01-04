CREATE FUNCTION dbo.GetInvoiceNumbersByBill
(
	@elt_account_number decimal,
	@bill_number decimal
)
RETURNS nvarchar(1024) 
AS 

BEGIN
	DECLARE @r nvarchar(1024)
	SELECT @r=ISNULL(@r+',', '') + CAST(invoice_no AS VARCHAR) FROM  bill_detail 
		WHERE elt_account_number=@elt_account_number and bill_number=@bill_number
		GROUP BY invoice_no

	RETURN @r 

END
