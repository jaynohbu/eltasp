

CREATE PROCEDURE [Reporting].[IncomeStatementReport]
	@StartDate datetime,
	@EndDate datetime,	
	@EltAccountNumber int 
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN	
		 SELECT 
				b.gl_master_type               AS Area,
				CASE
					WHEN ( Isnull(b.gl_account_type, '') = 'Cost of Sales' ) 
						THEN ('ORDINARY INCOME/EXPENSE')
					WHEN ( Isnull(b.gl_account_type, '') = 'Expense' ) 
						THEN ('GROSS PROFIT')
					WHEN ( Isnull(b.gl_account_type, '') = 'Other Expense' ) 
						THEN ('GROSS PROFIT')
					WHEN ( Isnull(b.gl_account_type, '') = 'Revenue' ) 
						THEN ('ORDINARY INCOME/EXPENSE')
					WHEN ( Isnull(b.gl_account_type, '') = 'Other Revenue' ) 
						THEN ('ORDINARY INCOME/EXPENSE')
					ELSE Isnull(b.gl_account_type, '')
			   END         
												AS Category,
			   CASE
					WHEN ( Isnull(b.gl_account_type, '') = 'Cost of Sales' ) 
						THEN ('Cost of Sales')
					WHEN ( Isnull(b.gl_account_type, '') = 'Expense' ) 
						THEN ('Expense')
					WHEN ( Isnull(b.gl_account_type, '') = 'Other Expense' ) 
						THEN ('Expense')
					WHEN ( Isnull(b.gl_account_type, '') = 'Revenue' ) 
						THEN ('Revenue')
					WHEN ( Isnull(b.gl_account_type, '') = 'Other Revenue' ) 
						THEN ('Revenue')
					ELSE Isnull(b.gl_account_type, '')
			   END         
												AS SubCategory,
			   b.gl_account_type               AS Type,
			   a.gl_account_number             AS GL_Number,
			   a.gl_account_name               AS GL_Name,
			   Sum(a.debit_amount + a.credit_amount
				   + Isnull(a.debit_memo, 0)
				   + Isnull(a.credit_memo, 0)) AS Amount

		FROM   all_accounts_journal a,
			   gl b
		WHERE  a.elt_account_number = b.elt_account_number
			   AND a.elt_account_number = @EltAccountNumber
			   AND a.gl_account_number = b.gl_account_number
			   AND ( b.gl_master_type = 'REVENUE'
					  OR gl_master_type = 'EXPENSE' )
			   AND ( a.tran_date >= @StartDate
					 AND a.tran_date < Dateadd(day, 1, @EndDate) )
			   AND Isnull(flag_close, '') <> 'Y'
		GROUP  BY b.gl_master_type,
				  b.gl_account_type,
				  a.gl_account_number,
				  a.gl_account_name
		ORDER  BY b.gl_master_type desc,
				  b.gl_account_type desc,
				  a.gl_account_number desc  
				      
	END          
END
