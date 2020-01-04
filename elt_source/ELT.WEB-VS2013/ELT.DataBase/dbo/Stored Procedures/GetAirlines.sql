CREATE PROCEDURE [dbo].[GetAirlines]

	@elt_account_number int,
	@str nvarchar(50) =null
AS
BEGIN
    SELECT    
	[carrier_code],
	dba_name   
	FROM [organization]  WHERE ISNUMERIC([carrier_code]) =1 AND  
	elt_account_number=@elt_account_number AND is_carrier = 'Y' and (@str  is null or dba_name like '%'+@str+'%')
END
GO

