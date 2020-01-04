

-- =============================================
CREATE PROCEDURE [Reporting].[APDetail]
	@GLAccountType VARCHAR(128), --@GLAccountType
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
					c.check_no,
					c.memo,
					Sum(c.debit_amount)  AS debit_amount,
					Sum(c.credit_amount) AS credit_amount,
					Sum(0)               AS balance
			 FROM   (SELECT a.elt_account_number,
							CASE
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
									 AND Isnull(flag_close, '') = 'Y' ) THEN 0
							  WHEN ( tran_date >= @StartDate
									 AND tran_date < Dateadd(day, 1, @EndDate) ) THEN
							  check_no
							END                                         AS Check_No,
							CASE
							  WHEN ( tran_date = @StartDate
									 AND Isnull(flag_close, '') = 'Y' ) THEN ''
							  WHEN ( tran_date >= @StartDate
									 AND tran_date < Dateadd(day, 1, @EndDate) ) THEN
							  memo
							END                                         AS Memo,
							Sum(debit_amount + Isnull(debit_memo, 0))   AS debit_amount,
							Sum(credit_amount + Isnull(credit_memo, 0)) AS credit_amount
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
								  AND tran_date < Dateadd(day, 1, @EndDate)
								   OR tran_type = 'INIT' )
					 GROUP  BY a.elt_account_number,
							   o.dba_name,
							   o.class_code,
							   customer_number,
							   tran_type,
							   tran_date,
							   flag_close,
							   air_ocean,
							   tran_num,
							   check_no,
							   memo)c
			 WHERE  Isnull(c.customer_name, '') <> ''
			 GROUP  BY c.elt_account_number,
					   c.customer_name,
					   c.customer_number,
					   c.type,
					   c.date,
					   c.air_ocean,
					   c.num,
					   c.check_no,
					   c.memo)
			UNION
			(SELECT a.elt_account_number,
					CASE
					  WHEN Isnull(o.class_code, '') = '' THEN o.dba_name
					  ELSE o.dba_name + ' ['
						   + Rtrim(Ltrim(Isnull(o.class_code, ''))) + ']'
					END                                         AS Customer_Name,
					customer_number,
					NULL                                        AS Date,
					'Start Balance'                                       AS Type,
					''                                          AS air_ocean,
					''                                          AS Num,
					NULL                                        AS Check_No,
					''                                          AS memo,
					0                                           AS debit_amount,
					0                                           AS credit_amount,
					Sum(debit_amount+Isnull(debit_memo, 0))
					+ Sum(credit_amount+Isnull(credit_memo, 0)) AS balance
			 FROM   gl b,
					all_accounts_journal a
					LEFT OUTER JOIN organization o
								 ON a.elt_account_number = o.elt_account_number
									AND a.customer_number = o.org_account_number
			 WHERE  a.elt_account_number = b.elt_account_number
					AND a.elt_account_number = @EltAccountNumber
					AND a.gl_account_number = b.gl_account_number
					AND b.gl_account_type = @GLAccountType
					AND tran_date < @StartDate
					AND Isnull(customer_name, '') <> ''
					AND Isnull(flag_close, '') = ''
			 GROUP  BY a.elt_account_number,
					   o.dba_name,
					   o.class_code,
					   customer_number
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
				c.check_no,
				c.memo,
				Sum(c.debit_amount)  AS debit_amount,
				Sum(c.credit_amount) AS credit_amount,
				Sum(0)               AS balance
		 FROM   (SELECT a.elt_account_number,
						CASE
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
								 AND Isnull(flag_close, '') = 'Y' ) THEN 0
						  WHEN ( tran_date >= @StartDate
								 AND tran_date < Dateadd(day, 1, @EndDate) ) THEN
						  check_no
						END                                         AS Check_No,
						CASE
						  WHEN ( tran_date = @StartDate
								 AND Isnull(flag_close, '') = 'Y' ) THEN ''
						  WHEN ( tran_date >= @StartDate
								 AND tran_date < Dateadd(day, 1, @EndDate) ) THEN
						  memo
						END                                         AS Memo,
						Sum(debit_amount + Isnull(debit_memo, 0))   AS debit_amount,
						Sum(credit_amount + Isnull(credit_memo, 0)) AS credit_amount
				 FROM   gl b,
						all_accounts_journal a
						LEFT OUTER JOIN organization o
									 ON a.elt_account_number = o.elt_account_number
										AND a.customer_number = o.org_account_number
				 WHERE  a.elt_account_number = b.elt_account_number
						AND LEFT(a.elt_account_number, 5) = @EltAccountNumber
						AND a.gl_account_number = b.gl_account_number
						AND b.gl_account_type = @GLAccountType
						AND ( tran_date >= @StartDate
							  AND tran_date < Dateadd(day, 1, @EndDate)
							   OR tran_type = 'INIT' )
				 GROUP  BY a.elt_account_number,
						   o.dba_name,
						   o.class_code,
						   customer_number,
						   tran_type,
						   tran_date,
						   flag_close,
						   air_ocean,
						   tran_num,
						   check_no,
						   memo)c
		 WHERE  Isnull(c.customer_name, '') <> ''
		 GROUP  BY c.elt_account_number,
				   c.customer_name,
				   c.customer_number,
				   c.type,
				   c.date,
				   c.air_ocean,
				   c.num,
				   c.check_no,
				   c.memo)
		UNION
		(SELECT a.elt_account_number,
				CASE
				  WHEN Isnull(o.class_code, '') = '' THEN o.dba_name
				  ELSE o.dba_name + ' ['
					   + Rtrim(Ltrim(Isnull(o.class_code, ''))) + ']'
				END                                         AS Customer_Name,
				customer_number,
				NULL                                        AS Date,
				'Start Balance'                                       AS Type,
				''                                          AS air_ocean,
				''                                          AS Num,
				NULL                                        AS Check_No,
				''                                          AS memo,
				0                                           AS debit_amount,
				0                                           AS credit_amount,
				Sum(debit_amount+Isnull(debit_memo, 0))
				+ Sum(credit_amount+Isnull(credit_memo, 0)) AS balance
		 FROM   gl b,
				all_accounts_journal a
				LEFT OUTER JOIN organization o
							 ON a.elt_account_number = o.elt_account_number
								AND a.customer_number = o.org_account_number
		 WHERE  a.elt_account_number = b.elt_account_number
				AND LEFT(a.elt_account_number, 5) = @EltAccountNumber
				AND a.gl_account_number = b.gl_account_number
				AND b.gl_account_type = @GLAccountType
				AND tran_date < @StartDate
				AND Isnull(customer_name, '') <> ''
				AND Isnull(flag_close, '') = ''
		 GROUP  BY a.elt_account_number,
				   o.dba_name,
				   o.class_code,
				   customer_number
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
