-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[GetFreightCost]
(
	@AirLineCode int,
	@Weight Decimal,
	@Unit NCHAR(1),
	@elt_account_number int
)
RETURNS Decimal
AS
BEGIN
	Declare @Rate decimal=0
	Declare @Amount decimal =0
	Declare @Count int =0
	SELECT @Count= COUNT(a.rate) from all_rate_table a where airline =@AirLineCode and a.rate_type=3 and weight_break > = @Weight AND kg_lb=@Unit and elt_account_number=elt_account_number
	IF @Count >0 
	SELECT  top 1 @Rate= a.rate from all_rate_table a where airline =@AirLineCode and a.rate_type=3 and weight_break > = @Weight AND kg_lb=@Unit and elt_account_number=elt_account_number
	order by weight_break desc
	ELSE
	return 0
	

	return @Weight * @Rate

END
