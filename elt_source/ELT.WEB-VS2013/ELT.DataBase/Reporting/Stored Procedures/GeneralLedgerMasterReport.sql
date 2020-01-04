

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Reporting].[GeneralLedgerMasterReport]
	--@GLAccountType VARCHAR(128), --@GLAccountType
	@StartDate datetime,
	@EndDate datetime,	
	@EltAccountNumber int 
AS
DECLARE @FirstDateOfThisYear datetime
DECLARE @Title nvarchar(50)
BEGIN

	SET @FirstDateOfThisYear = ( select DateAdd(dd, DAY(0)-1, DateAdd(mm, MONTH(0)-1, DateAdd(yy, YEAR(@StartDate)-2000, '20000101'))))
	SET	@Title	=(
		SELECT '_Fiscal Closing of '+ CAST((YEAR(@FirstDateOfThisYear)-1) as varchar)+' ~ '+ CONVERT(VARCHAR(10), @StartDate, 101) AS [MM/DD/YYYY]

	)
	SET NOCOUNT ON;
	IF LEN(CAST(@EltAccountNumber AS varchar(20))) >5
		BEGIN
			IF @FirstDateOfThisYear = @StartDate
				BEGIN
					SELECT c.elt_account_number,
						   c.gl_number,
						   c.gl_name,
						   c.customer_name,
						   Sum(c.balance) AS Balance
					FROM   (SELECT a.elt_account_number           AS elt_account_number,
								   a.tran_date,
								   CASE
									 WHEN ( tran_date = @StartDate
											AND Isnull(flag_close, '') = 'Y' ) THEN ''
									 WHEN ( a.tran_date >= @StartDate
											AND a.tran_date < Dateadd(day, 1, @EndDate) ) THEN (
									 CASE
									 WHEN Isnull(o.class_code, '') = '' THEN o.dba_name
									 ELSE o.dba_name + ' ['
										  + Rtrim(Ltrim(Isnull(o.class_code, ''))) + ']'
									 END )
								   END                            AS customer_name,
								   CASE
									 WHEN ( tran_date = @StartDate
											AND Isnull(flag_close, '') = 'Y' ) THEN
									 Isnull(a.gl_account_number, '')
									 WHEN ( a.tran_date >= @StartDate
											AND a.tran_date < Dateadd(day, 1, @EndDate) ) THEN
									 Isnull(a.gl_account_number, '')
								   END                            AS GL_Number,
								   CASE
									 WHEN ( tran_date = @StartDate
											AND Isnull(flag_close, '') = 'Y' ) THEN
									 @Title
									 WHEN ( a.tran_date >= @StartDate
											AND a.tran_date < Dateadd(day, 1, @EndDate) ) THEN
									 Isnull(b.gl_account_desc, '')
								   END                            AS GL_Name,
								   Sum(a.credit_amount + a.debit_amount
									   + Isnull(a.credit_memo, 0)
									   + Isnull(a.debit_memo, 0)) AS Balance
							FROM   gl b,
								   all_accounts_journal a
								   LEFT OUTER JOIN organization o
												ON a.elt_account_number = o.elt_account_number
												   AND a.customer_number = o.org_account_number
							WHERE  a.elt_account_number = @EltAccountNumber
								   AND a.elt_account_number = b.elt_account_number
								   AND a.gl_account_number = b.gl_account_number
								   AND ( tran_date >= @StartDate
										 AND tran_date < Dateadd(day, 1, @EndDate)
										  OR tran_type = 'INIT' )
							GROUP  BY a.elt_account_number,
									  o.dba_name,
									  o.class_code,
									  a.gl_account_number,
									  b.gl_account_desc,
									  a.tran_date,
									  flag_close,
									  a.customer_name) c
					WHERE  LEFT(Isnull(c.customer_name, ''), 7) = '_Fiscal'
							OR LEFT(Isnull(c.gl_name, ''), 7) = '_Fiscal'
					GROUP  BY c.elt_account_number,
							  c.gl_number,
							  c.gl_name,
							  c.customer_name
					ORDER  BY elt_account_number,
							  gl_number,
							  gl_name

				END
			ELSE
				BEGIN
					SELECT c.elt_account_number,
						   c.gl_number,
						   c.gl_name,
						   c.customer_name,
						   Sum(c.balance) AS Balance
					FROM   (SELECT a.elt_account_number           AS elt_account_number,
								   a.tran_date,
								   CASE
									 WHEN ( tran_date >= @FirstDateOfThisYear
											AND tran_date < Dateadd(day, 0, @StartDate) ) THEN ''
									 WHEN ( a.tran_date >= @StartDate
											AND a.tran_date < Dateadd(day, 1, @EndDate) ) THEN (
									 CASE
									 WHEN Isnull(o.class_code, '') = '' THEN o.dba_name
									 ELSE o.dba_name + ' ['
										  + Rtrim(Ltrim(Isnull(o.class_code, ''))) + ']'
									 END )
								   END                            AS customer_name,
								   CASE
									 WHEN ( tran_date >= @FirstDateOfThisYear
											AND tran_date < Dateadd(day, 0, @StartDate) ) THEN
									 Isnull(a.gl_account_number, '')
									 WHEN ( a.tran_date >= @StartDate
											AND a.tran_date < Dateadd(day, 1, @EndDate) ) THEN
									 Isnull(a.gl_account_number, '')
								   END                            AS GL_Number,
								   CASE
									 WHEN ( tran_date >= @FirstDateOfThisYear --1/1/2007 0000
											AND tran_date < Dateadd(day, 0, @StartDate) ) THEN
									 @Title 
									 WHEN ( a.tran_date >= @StartDate
											AND a.tran_date < Dateadd(day, 1, @EndDate) ) THEN
									 Isnull(b.gl_account_desc, '')
								   END                            AS GL_Name,
								   Sum(a.credit_amount + a.debit_amount
									   + Isnull(a.credit_memo, 0)
									   + Isnull(a.debit_memo, 0)) AS Balance
							FROM   gl b,
								   all_accounts_journal a
								   LEFT OUTER JOIN organization o
												ON a.elt_account_number = o.elt_account_number
												   AND a.customer_number = o.org_account_number
							WHERE  a.elt_account_number = @EltAccountNumber
								   AND a.elt_account_number = b.elt_account_number
								   AND a.gl_account_number = b.gl_account_number
								   AND ( tran_date >= @FirstDateOfThisYear
										 AND tran_date < Dateadd(day, 1, @EndDate)
										  OR tran_type = 'INIT' )
							GROUP  BY a.elt_account_number,
									  o.dba_name,
									  o.class_code,
									  a.gl_account_number,
									  b.gl_account_desc,
									  a.tran_date,
									  flag_close,
									  a.customer_name) c
					WHERE  LEFT(Isnull(c.customer_name, ''), 7) = '_Fiscal'
							OR LEFT(Isnull(c.gl_name, ''), 7) = '_Fiscal'
					GROUP  BY c.elt_account_number,
							  c.gl_number,
							  c.gl_name,
							  c.customer_name
					ORDER  BY elt_account_number,
							  gl_number,
							  gl_name
			END
		END          
	--ELSE
	--	BEGIN	
			
	--	END
END
