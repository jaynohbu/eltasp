

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Reporting].[ARDetail]
	@GLAccountType VARCHAR(128),
	@StartDate datetime,
	@EndDate datetime,	
	@EltAccountNumber int 
AS
BEGIN

	SET NOCOUNT ON;

	IF LEN(CAST(@EltAccountNumber AS varchar(20))) >5
			BEGIN
				
				 (SELECT c.elt_account_number,
				c.customer_name,
				c.customer_number,
				c.date,
				c.type,
				c.air_ocean,
				c.num,
				CASE
				  WHEN c.type = 'PMT' THEN c.memo
				  WHEN ( c.type = 'INV'
						  OR c.type = 'ARN' ) THEN (SELECT ref_no
													FROM   invoice
													WHERE
				  elt_account_number = c.elt_account_number
				  AND invoice_no = c.num)
				  ELSE ''
				END                  AS memo,
				CASE
				  WHEN c.type = 'PMT' THEN (SELECT TOP 1 ref_no_our
											FROM   invoice x
				  LEFT OUTER JOIN customer_payment_detail y
							   ON
				  x.elt_account_number = y.elt_account_number
				  AND x.invoice_no = y.invoice_no
											WHERE
				  y.elt_account_number = c.elt_account_number
				  AND y.payment_no = c.num)
				  WHEN ( c.type = 'INV'
						  OR c.type = 'ARN' ) THEN (SELECT ref_no_our
													FROM   invoice
													WHERE
				  elt_account_number = c.elt_account_number
				  AND invoice_no = c.num)
				  ELSE ''
				END                  AS file_no,
				Sum(c.debit_amount)  AS debit_amount,
				Sum(c.credit_amount) AS credit_amount,
				Sum(0)               AS balance,
				c.email,
				c.status,
				c.auto_uid
		 FROM   (SELECT a.elt_account_number,
						CASE
						 -- WHEN ( tran_date = @StartDate
						  --       AND Isnull(flag_close, '') = 'Y' ) THEN
						 -- '_Fiscal Closing of '+tran_date
						  WHEN ( tran_date >= @StartDate
								 AND tran_date < Dateadd(day, 1, @EndDate) ) THEN (
						  CASE
						  WHEN Isnull(d.class_code, '') = '' THEN d.dba_name
						  ELSE d.dba_name 
						  --+ ' ['  + Rtrim(Ltrim(Isnull(d.class_code, ''))) + ']'
						  END )
						END                                         AS Customer_Name,
						CASE
						  WHEN ( tran_date = @StartDate
								 AND Isnull(flag_close, '') = 'Y' ) THEN '300000'
						  WHEN ( tran_date >= @StartDate
								 AND tran_date < Dateadd(day, 1, @EndDate) ) THEN
						  customer_number
						END                                         AS Customer_Number,
						CASE
						  WHEN ( tran_date = @StartDate
								 AND Isnull(flag_close, '') = 'Y' ) THEN ''
						  WHEN ( tran_date >= @StartDate
								 AND tran_date < Dateadd(day, 1, @EndDate) ) THEN
						  tran_type
						END                                         AS Type,
						CASE
						  WHEN ( tran_date = @StartDate
								 AND Isnull(flag_close, '') = 'Y' ) THEN ''
						  WHEN ( tran_date >= @StartDate
								 AND tran_date < Dateadd(day, 1, @EndDate) ) THEN
						  tran_date
						END                                         AS Date,
						CASE
						  WHEN ( tran_date = @StartDate
								 AND Isnull(flag_close, '') = 'Y' ) THEN ''
						  WHEN ( tran_date >= @StartDate
								 AND tran_date < Dateadd(day, 1, @EndDate) ) THEN
						  air_ocean
						END                                         AS Air_Ocean,
						CASE
						  WHEN ( tran_date = @StartDate
								 AND Isnull(flag_close, '') = 'Y' ) THEN ''
						  WHEN ( tran_date >= @StartDate
								 AND tran_date < Dateadd(day, 1, @EndDate) ) THEN
						  tran_num
						END                                         AS Num,
						CASE
						  WHEN ( tran_date = @StartDate
								 AND Isnull(flag_close, '') = 'Y' ) THEN ''
						  WHEN ( tran_date >= @StartDate
								 AND tran_date < Dateadd(day, 1, @EndDate) ) THEN
						  memo
						END                                         AS Memo,
						Sum(debit_amount + Isnull(debit_memo, 0))   AS debit_amount,
						Sum(credit_amount + Isnull(credit_memo, 0)) AS credit_amount,
						d.owner_email                               AS email,
						e.status                                    AS status,
						e.auto_uid
				 FROM   gl b
						INNER JOIN all_accounts_journal a
								ON b.elt_account_number = a.elt_account_number
								   AND a.gl_account_number = b.gl_account_number
						LEFT OUTER JOIN organization d
									 ON a.elt_account_number = d.elt_account_number
										AND a.customer_number = d.org_account_number
						LEFT OUTER JOIN email_report e
									 ON d.elt_account_number = e.elt_account_number
										AND d.org_account_number = e.company
				 WHERE  a.elt_account_number = @EltAccountNumber
						AND b.gl_account_type = @GLAccountType
						AND ( tran_date >= @StartDate
							  AND tran_date < Dateadd(day, 1, @EndDate)
							   OR tran_type = 'INIT' )
						AND ( e.auto_uid IN (SELECT Max(auto_uid)
											 FROM   email_report
											 GROUP  BY elt_account_number,
													   company)
							   OR Isnull(e.auto_uid, '') = '' )
				 GROUP  BY a.elt_account_number,
						   d.dba_name,
						   d.class_code,
						   customer_number,
						   tran_type,
						   tran_date,
						   flag_close,
						   air_ocean,
						   tran_num,
						   memo,
						   owner_email,
						   status,
						   auto_uid) c
		 WHERE  Isnull(c.customer_name, '') <> ''
		 GROUP  BY c.elt_account_number,
				   c.customer_name,
				   c.customer_number,
				   c.type,
				   c.date,
				   c.air_ocean,
				   c.num,
				   c.memo,
				   c.email,
				   c.status,
				   c.auto_uid)
		UNION
		(SELECT a.elt_account_number,
				customer_name,
				customer_number,
				NULL                                        AS Date,
				'Start Balance'                                       AS Type,
				''                                          AS air_ocean,
				''                                          AS Num,
				''                                          AS memo,
				''                                          AS file_no,
				null                                           AS debit_amount,
				null                                           AS credit_amount,
				Sum(debit_amount+Isnull(debit_memo, 0))
				+ Sum(credit_amount+Isnull(credit_memo, 0)) AS balance,
				d.owner_email                               AS email,
				e.status,
				e.auto_uid
		 FROM   gl b
				INNER JOIN all_accounts_journal a
						ON b.elt_account_number = a.elt_account_number
						   AND a.gl_account_number = b.gl_account_number
				LEFT OUTER JOIN organization d
							 ON a.elt_account_number = d.elt_account_number
								AND a.customer_number = d.org_account_number
				LEFT OUTER JOIN email_report e
							 ON d.elt_account_number = e.elt_account_number
								AND d.org_account_number = e.company
		 WHERE  a.elt_account_number = @EltAccountNumber
				AND b.gl_account_type = @GLAccountType
				AND tran_date < @StartDate
				AND Isnull(customer_name, '') <> ''
				AND Isnull(flag_close, '') = ''
				AND ( e.auto_uid IN (SELECT Max(auto_uid)
									 FROM   email_report
									 GROUP  BY elt_account_number,
											   company)
					   OR Isnull(e.auto_uid, '') = '' )
		 GROUP  BY a.elt_account_number,
				   customer_name,
				   customer_number,
				   d.owner_email,
				   e.status,
				   e.auto_uid
		 HAVING ( Sum(debit_amount+Isnull(debit_memo, 0))
				  + Sum(credit_amount+Isnull(credit_memo, 0)) ) <> 0)
		ORDER  BY elt_account_number,
				  customer_name,
				  customer_number,
				  date,
				  type,
				  air_ocean,
				  num,
				  memo  


			END       
     ELSE
		BEGIN
			 (SELECT c.elt_account_number,
				c.customer_name,
				c.customer_number,
				c.date,
				c.type,
				c.air_ocean,
				c.num,
				CASE
				  WHEN c.type = 'PMT' THEN c.memo
				  WHEN ( c.type = 'INV'
						  OR c.type = 'ARN' ) THEN (SELECT ref_no
													FROM   invoice
													WHERE
				  elt_account_number = c.elt_account_number
				  AND invoice_no = c.num)
				  ELSE ''
				END                  AS memo,
				CASE
				  WHEN c.type = 'PMT' THEN (SELECT TOP 1 ref_no_our
											FROM   invoice x
				  LEFT OUTER JOIN customer_payment_detail y
							   ON
				  x.elt_account_number = y.elt_account_number
				  AND x.invoice_no = y.invoice_no
											WHERE
				  y.elt_account_number = c.elt_account_number
				  AND y.payment_no = c.num)
				  WHEN ( c.type = 'INV'
						  OR c.type = 'ARN' ) THEN (SELECT ref_no_our
													FROM   invoice
													WHERE
				  elt_account_number = c.elt_account_number
				  AND invoice_no = c.num)
				  ELSE ''
				END                  AS file_no,
				Sum(c.debit_amount)  AS debit_amount,
				Sum(c.credit_amount) AS credit_amount,
				Sum(0)               AS balance,
				c.email,
				c.status,
				c.auto_uid
		 FROM   (SELECT a.elt_account_number,
						CASE
						  WHEN ( tran_date = @StartDate
								 AND Isnull(flag_close, '') = 'Y' ) THEN
						  '_Fiscal Closing of 2006'
						  WHEN ( tran_date >= @StartDate
								 AND tran_date < Dateadd(day, 1, @EndDate) ) THEN (
						  CASE
						  WHEN Isnull(d.class_code, '') = '' THEN d.dba_name
						  ELSE d.dba_name + ' ['
							   + Rtrim(Ltrim(Isnull(d.class_code, ''))) + ']'
						  END )
						END                                         AS Customer_Name,
						CASE
						  WHEN ( tran_date = @StartDate
								 AND Isnull(flag_close, '') = 'Y' ) THEN '300000'
						  WHEN ( tran_date >= @StartDate
								 AND tran_date < Dateadd(day, 1, @EndDate) ) THEN
						  customer_number
						END                                         AS Customer_Number,
						CASE
						  WHEN ( tran_date = @StartDate
								 AND Isnull(flag_close, '') = 'Y' ) THEN ''
						  WHEN ( tran_date >= @StartDate
								 AND tran_date < Dateadd(day, 1, @EndDate) ) THEN
						  tran_type
						END                                         AS Type,
						CASE
						  WHEN ( tran_date = @StartDate
								 AND Isnull(flag_close, '') = 'Y' ) THEN ''
						  WHEN ( tran_date >= @StartDate
								 AND tran_date < Dateadd(day, 1, @EndDate) ) THEN
						  tran_date
						END                                         AS Date,
						CASE
						  WHEN ( tran_date = @StartDate
								 AND Isnull(flag_close, '') = 'Y' ) THEN ''
						  WHEN ( tran_date >= @StartDate
								 AND tran_date < Dateadd(day, 1, @EndDate) ) THEN
						  air_ocean
						END                                         AS Air_Ocean,
						CASE
						  WHEN ( tran_date = @StartDate
								 AND Isnull(flag_close, '') = 'Y' ) THEN ''
						  WHEN ( tran_date >= @StartDate
								 AND tran_date < Dateadd(day, 1, @EndDate) ) THEN
						  tran_num
						END                                         AS Num,
						CASE
						  WHEN ( tran_date = @StartDate
								 AND Isnull(flag_close, '') = 'Y' ) THEN ''
						  WHEN ( tran_date >= @StartDate
								 AND tran_date < Dateadd(day, 1, @EndDate) ) THEN
						  memo
						END                                         AS Memo,
						Sum(debit_amount + Isnull(debit_memo, 0))   AS debit_amount,
						Sum(credit_amount + Isnull(credit_memo, 0)) AS credit_amount,
						d.owner_email                               AS email,
						e.status                                    AS status,
						e.auto_uid
				 FROM   gl b
						INNER JOIN all_accounts_journal a
								ON b.elt_account_number = a.elt_account_number
								   AND a.gl_account_number = b.gl_account_number
						LEFT OUTER JOIN organization d
									 ON a.elt_account_number = d.elt_account_number
										AND a.customer_number = d.org_account_number
						LEFT OUTER JOIN email_report e
									 ON d.elt_account_number = e.elt_account_number
										AND d.org_account_number = e.company
				 WHERE  LEFT(a.elt_account_number, 5) = @EltAccountNumber
						AND b.gl_account_type = @GLAccountType
						AND ( tran_date >= @StartDate
							  AND tran_date < Dateadd(day, 1, @EndDate)
							   OR tran_type = 'INIT' )
						AND ( e.auto_uid IN (SELECT Max(auto_uid)
											 FROM   email_report
											 GROUP  BY elt_account_number,
													   company)
							   OR Isnull(e.auto_uid, '') = '' )
				 GROUP  BY a.elt_account_number,
						   d.dba_name,
						   d.class_code,
						   customer_number,
						   tran_type,
						   tran_date,
						   flag_close,
						   air_ocean,
						   tran_num,
						   memo,
						   owner_email,
						   status,
						   auto_uid) c
		 WHERE  Isnull(c.customer_name, '') <> ''
		 GROUP  BY c.elt_account_number,
				   c.customer_name,
				   c.customer_number,
				   c.type,
				   c.date,
				   c.air_ocean,
				   c.num,
				   c.memo,
				   c.email,
				   c.status,
				   c.auto_uid)
		UNION
		(SELECT a.elt_account_number,
				customer_name,
				customer_number,
				NULL                                        AS Date,
				'Start Balance'                                       AS Type,
				''                                          AS air_ocean,
				''                                          AS Num,
				''                                          AS memo,
				''                                          AS file_no,
				0                                           AS debit_amount,
				0                                           AS credit_amount,
				Sum(debit_amount+Isnull(debit_memo, 0))
				+ Sum(credit_amount+Isnull(credit_memo, 0)) AS balance,
				d.owner_email                               AS email,
				e.status,
				e.auto_uid
		 FROM   gl b
				INNER JOIN all_accounts_journal a
						ON b.elt_account_number = a.elt_account_number
						   AND a.gl_account_number = b.gl_account_number
				LEFT OUTER JOIN organization d
							 ON a.elt_account_number = d.elt_account_number
								AND a.customer_number = d.org_account_number
				LEFT OUTER JOIN email_report e
							 ON d.elt_account_number = e.elt_account_number
								AND d.org_account_number = e.company
		 WHERE  LEFT(a.elt_account_number, 5) = @EltAccountNumber
				AND b.gl_account_type = @GLAccountType
				AND tran_date < @StartDate
				AND Isnull(customer_name, '') <> ''
				AND Isnull(flag_close, '') = ''
				AND ( e.auto_uid IN (SELECT Max(auto_uid)
									 FROM   email_report
									 GROUP  BY elt_account_number,
											   company)
					   OR Isnull(e.auto_uid, '') = '' )
		 GROUP  BY a.elt_account_number,
				   customer_name,
				   customer_number,
				   d.owner_email,
				   e.status,
				   e.auto_uid
		 HAVING ( Sum(debit_amount+Isnull(debit_memo, 0))
				  + Sum(credit_amount+Isnull(credit_memo, 0)) ) <> 0)
		ORDER  BY elt_account_number,
				  customer_name,
				  customer_number,
				  date,
				  type,
				  air_ocean,
				  num,
				  memo  
		
		END 
END
