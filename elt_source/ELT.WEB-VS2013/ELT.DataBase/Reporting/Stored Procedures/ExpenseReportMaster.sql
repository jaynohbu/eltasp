CREATE PROCEDURE [Reporting].[ExpenseReportMaster]
	@GLAccountType VARCHAR(128), --'Expense'
	@StartDate datetime,
	@EndDate datetime,	
	@EltAccountNumber int 
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN	
		SELECT c.customer_name,
			   Sum(c.amount)  AS Amount,
			   Sum(c.balance) AS Balance
		FROM   (SELECT CASE
						 WHEN ( tran_date = @StartDate
								AND Isnull(flag_close, '') = 'Y' ) THEN
						 '_Fiscal Closing of 2006'
						 WHEN ( tran_date >= @StartDate
								AND tran_date < Dateadd(day, 1, @EndDate) ) THEN
						 Isnull(
						 customer_name, '')
					   END                                       AS Customer_Name,
					   Sum(debit_amount + Isnull(debit_memo, 0)) AS Amount,
					   Sum(debit_amount + Isnull(debit_memo, 0)) AS Balance
				FROM   all_accounts_journal a,
					   gl b
				WHERE  a.elt_account_number = b.elt_account_number
					   AND a.elt_account_number = @EltAccountNumber
					   AND a.gl_account_number = b.gl_account_number
					   AND b.gl_account_type = @GLAccountType
					   AND ( tran_date >= @StartDate
							 AND tran_date < Dateadd(day, 1, @EndDate) )
					   AND ( tran_type = 'BILL'
							  OR tran_type = 'CHK' )
				GROUP  BY customer_name,
						  tran_date,
						  flag_close) c
		GROUP  BY c.customer_name
		ORDER  BY customer_name
		      
	END          
END
