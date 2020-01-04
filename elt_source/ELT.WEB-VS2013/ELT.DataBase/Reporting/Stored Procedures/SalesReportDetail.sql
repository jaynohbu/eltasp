

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Reporting].[SalesReportDetail]
	@GLAccountType VARCHAR(128), --@'Revenue'
	@StartDate datetime,
	@EndDate datetime,	
	@EltAccountNumber int 
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN	
		SELECT a.elt_account_number,
			   CASE
				 WHEN Isnull(o.class_code, '') = '' THEN o.dba_name
				 ELSE o.dba_name + ' ['
					  + Rtrim(Ltrim(Isnull(o.class_code, ''))) + ']'
			   END                                              AS Customer_Name,
			   customer_number                                  AS Customer_Number,
			   air_ocean                                        AS air_ocean,
			   tran_type                                        AS Type,
			   CASE
				 WHEN Isnull(flag_close, '') = 'Y' THEN ''
				 ELSE tran_num
			   END                                              AS Num,
			   tran_date                                        AS Date,
			   -Sum(( credit_amount + Isnull(credit_memo, 0) )) AS Amount,
			   -Sum(balance)                                    AS Balance,
			   ' '                                              AS Link
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
			   AND Isnull(flag_close, '') <> 'Y'
			   AND customer_name <> ''
		GROUP  BY a.elt_account_number,
				  o.dba_name,
				  o.class_code,
				  customer_number,
				  air_ocean,
				  tran_type,
				  tran_date,
				  flag_close,
				  tran_num
		ORDER  BY customer_name,
				  air_ocean,
				  tran_date,
				  tran_type,
				  tran_num  
		      
	END          
END
