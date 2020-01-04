


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Reporting].[TrialBalanceReport]

	@EndDate datetime,	
	@EltAccountNumber int 
AS
DECLARE @FirstDateOfThisYear datetime
BEGIN
	SET NOCOUNT ON;
	BEGIN	
		SET @FirstDateOfThisYear = ( select DateAdd(dd, DAY(0)-1, DateAdd(mm, MONTH(0)-1, DateAdd(yy, YEAR(@EndDate)-2000, '20000101'))))
		SELECT a.gl_account_number                                 AS gl_account_number,
			   a.gl_account_name                                   AS gl_account_name,
			   Sum(a.debit_amount + Isnull(a.debit_memo, 0))       AS Debit,
			   Sum(a.credit_amount + Isnull(a.credit_memo, 0))     AS Credit,
			   ( Sum(a.debit_amount+Isnull(a.debit_memo, 0))
				 + Sum(a.credit_amount+Isnull(a.credit_memo, 0)) ) AS Balance
		FROM   all_accounts_journal a,
			   gl b
		WHERE  a.elt_account_number = b.elt_account_number
			   AND a.elt_account_number = @EltAccountNumber
			   AND a.gl_account_number = b.gl_account_number
			   AND ( a.tran_date >= @FirstDateOfThisYear
					 AND a.tran_date < Dateadd(day, 1, @EndDate) )
			   AND Isnull(a.tran_type, '') <> 'INIT'
		GROUP  BY a.gl_account_number,
				  a.gl_account_name
		ORDER  BY a.gl_account_number  
						      
	END          
END
