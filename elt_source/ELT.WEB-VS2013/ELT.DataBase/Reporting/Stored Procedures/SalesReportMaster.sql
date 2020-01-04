


CREATE PROCEDURE [Reporting].[SalesReportMaster]
	@GLAccountType VARCHAR(128), --'Revenue'
	@StartDate datetime,
	@EndDate datetime,	
	@EltAccountNumber int 
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN	
		SELECT c.customer_name,
		   c.customer_number,
		   Sum(c.amount)  AS Amount,
		   Sum(c.balance) AS Balance
		FROM   (SELECT CASE
					 WHEN ( tran_date = @StartDate
							AND Isnull(flag_close, '') = 'Y' ) THEN
					 '_Fiscal Closing of 2006'
					 WHEN ( tran_date >= @StartDate
							AND tran_date < Dateadd(day, 1, @EndDate) ) THEN (
					 CASE
					 WHEN Isnull(o.class_code, '') = '' THEN o.dba_name
					 ELSE o.dba_name + ' ['
						  + Rtrim(Ltrim(Isnull(o.class_code, ''))) + ']'
					 END )
				   END                                          AS Customer_Name,
				   CASE
					 WHEN ( tran_date = @StartDate
							AND Isnull(flag_close, '') = 'Y' ) THEN '0'
					 WHEN ( tran_date >= @StartDate
							AND tran_date < Dateadd(day, 1, @EndDate) ) THEN
					 customer_number
				   END                                          AS Customer_Number,
				   -Sum(credit_amount + Isnull(credit_memo, 0)) AS Amount,
				   -Sum(credit_amount + Isnull(credit_memo, 0)) AS Balance
			FROM   gl b,
				   all_accounts_journal a
				   LEFT OUTER JOIN organization o
								ON a.elt_account_number = o.elt_account_number
								   AND a.customer_number = o.org_account_number
			WHERE  a.elt_account_number = b.elt_account_number
				   AND a.elt_account_number = @EltAccountNumber
				   AND a.gl_account_number = b.gl_account_number
				   AND b.gl_account_type = @GLAccountType 
				   AND ( tran_date >= @StartDate
						 AND tran_date < Dateadd(day, 1, @EndDate) )
				   AND customer_name <> ''
			GROUP  BY o.dba_name,
					  o.class_code,
					  customer_number,
					  tran_date,
					  flag_close) c
		GROUP  BY c.customer_name,
			  c.customer_number
		ORDER  BY customer_name,
			  customer_number  
		      
	END          
END
