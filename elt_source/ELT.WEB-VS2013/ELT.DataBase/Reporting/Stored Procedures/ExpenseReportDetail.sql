

CREATE PROCEDURE [Reporting].[ExpenseReportDetail]
	@GLAccountType VARCHAR(128), --@'Expense'
	@StartDate datetime,
	@EndDate datetime,	
	@EltAccountNumber int 
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN	
		
		SELECT a.elt_account_number,
			   Isnull(customer_name, '')               AS Customer_Name,
			   tran_type                               AS Type,
			   tran_date                               AS Date,
			   CASE
				 WHEN Isnull(flag_close, '') = 'Y' THEN ''
				 ELSE tran_num
			   END                                     AS Num,
			   memo                                    AS Memo,
			   gl_account_name                         AS Account,
			   split                                   AS Split,
			   ( debit_amount + Isnull(debit_memo, 0) )AS Amount,
			   balance                                 AS Balance,
			   ' '                                     AS Link
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
			   AND Isnull(flag_close, '') <> 'Y'
		ORDER  BY a.elt_account_number,
				  customer_name,
				  tran_date,
				  tran_seq_num  
				      
	END          
END
