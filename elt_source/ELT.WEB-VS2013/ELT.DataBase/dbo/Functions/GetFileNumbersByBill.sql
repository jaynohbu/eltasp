
/****** Object:  User Defined Function dbo.GetFileNumbersByBill    Script Date: 7/31/2008 11:07:36 AM ******/

/****** Object:  User Defined Function dbo.GetFileNumbersByBill    Script Date: 5/5/2008 2:56:02 PM ******/

/****** Object:  User Defined Function dbo.GetFileNumbersByBill    Script Date: 5/5/2008 2:47:35 PM ******/

/****** Object:  User Defined Function dbo.GetFileNumbersByBill    Script Date: 5/5/2008 2:24:42 PM ******/

CREATE FUNCTION dbo.GetFileNumbersByBill
(
	@elt_account_number decimal,
	@bill_number decimal
)
RETURNS nvarchar(1024) 
AS 
BEGIN 
	DECLARE @r nvarchar(1024)

	SELECT @r = ISNULL(@r+',', '') + ref_no_Our FROM invoice x LEFT OUTER JOIN bill_detail y 
		ON (x.elt_account_number=y.elt_account_number AND x.invoice_no=y.invoice_no) 
		WHERE y.elt_account_number=@elt_account_number and y.bill_number=@bill_number
		GROUP BY ref_no_Our
	RETURN @r 
END 




