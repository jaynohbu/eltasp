

CREATE PROCEDURE [Reporting].[BalanceSheetReport]
	@EndDate datetime,	
	@EltAccountNumber int 
AS
DECLARE @FirstDateOfThisYear datetime
BEGIN
	SET NOCOUNT ON;
	BEGIN	
		SET @FirstDateOfThisYear = ( select DateAdd(dd, DAY(0)-1, DateAdd(mm, MONTH(0)-1, DateAdd(yy, YEAR(@EndDate)-2000, '20000101'))))
		SELECT 
			CASE
			WHEN b.gl_master_type = 'REVENUE'
				   OR b.gl_master_type = 'EXPENSE'	THEN 'Liability & Equity'
			WHEN b.gl_master_type = 'ASSET'			THEN 'Asset' 
			WHEN b.gl_master_type = 'EQUITY'		THEN 'Liability & Equity'
			WHEN b.gl_master_type = 'LIABILITY'		THEN 'Liability & Equity'
			ELSE b.gl_master_type 	   
			END												AS Header,
			
			CASE
			 WHEN b.gl_master_type = 'REVENUE'
				   OR b.gl_master_type = 'EXPENSE' THEN 'EQUITY'
			 ELSE b.gl_master_type
		   END                                               AS Type,
		   CASE
			 WHEN b.gl_account_type = 'Cash in Bank'
				   OR b.gl_account_type = 'Accounts Receivable' THEN 'Current Asset'
			 WHEN b.gl_account_type = 'Accounts Payable' THEN 'Current Liability'
			 WHEN b.gl_account_type = 'Other Revenue'
				   OR b.gl_account_type = 'Revenue' THEN 'Equity-Retained Earnings'
			 WHEN b.gl_account_type = 'Expense'
				   OR b.gl_account_type = 'Cost of Sales'
				   OR b.gl_account_type = 'Other Expense' THEN
			 'Equity-Retained Earnings'
			 ELSE b.gl_account_type
		   END                                               AS gl_account_type,
		   b.gl_account_type                                 AS gl_account_type2,
		   a.gl_account_number                               AS GL_Number,
		   a.gl_account_name                                 AS GL_Name,
		   Sum(a.debit_amount + Isnull(a.debit_memo, 0)
			   + a.credit_amount + Isnull(a.credit_memo, 0)) AS Amount,
		   Sum(b.gl_begin_balance)                           AS Begin_Balance
	FROM   all_accounts_journal a,
		   gl b
	WHERE  a.elt_account_number = b.elt_account_number
		   AND a.elt_account_number = @EltAccountNumber
		   AND a.gl_account_number = b.gl_account_number
		   AND a.tran_date >= @FirstDateOfThisYear
		   AND a.tran_date < Dateadd(day, 1, @EndDate)
	GROUP  BY b.gl_master_type,
			  gl_account_type,
			  a.gl_account_number,
			  a.gl_account_name
	ORDER  BY b.gl_master_type,
			  gl_account_type,
			  a.gl_account_number  
				      
	END          
END
