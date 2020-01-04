


CREATE PROCEDURE [Reporting].[BankRegisterReport]
	@GLAccountType VARCHAR(128),
	@StartDate datetime,
	@EndDate datetime,	
	@EltAccountNumber int 
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN	
		SELECT a.elt_account_number,
			   tran_type                                    AS Type,
			   tran_date                                    AS Date,
			   check_no                                     AS Check_No,
			   memo                                         AS Memo,
			   CASE
				 WHEN Isnull(o.class_code, '') = '' THEN o.dba_name
				 ELSE o.dba_name + ' ['
					  + Rtrim(Ltrim(Isnull(o.class_code, ''))) + ']'
			   END                                          AS Description,
			   Isnull(a.print_check_as, '')                 AS PrintCheckAs,
			   CASE
				 WHEN Isnull(chk_complete, '') <> '' THEN '*'
				 ELSE ''
			   END                                          AS Clear,
			   CASE
				 WHEN Isnull(chk_void, '') <> '' THEN '*'
				 ELSE ''
			   END                                          AS Void,
			   ( debit_amount + Isnull(debit_memo, 0)
				 + credit_amount + Isnull(credit_memo, 0) ) AS Amount,
			   air_ocean,
			   tran_num,
			   Replace(Replace(Upper(gl_account_name), 'CASH IN BANK-', ''),
			   'CASH IN BANK -',
			   '')                                          AS gl_account_name
		FROM   gl b,
			   all_accounts_journal a
			   LEFT OUTER JOIN organization o
							ON a.elt_account_number = o.elt_account_number
							   AND a.customer_number = o.org_account_number
		WHERE  a.elt_account_number = b.elt_account_number
			   AND a.elt_account_number = @EltAccountNumber
			   AND a.gl_account_number = b.gl_account_number
			   AND b.gl_account_type = @GLAccountType
			   --AND a.gl_account_number = '1200'
			   AND ( tran_date >= @StartDate
					 AND tran_date < Dateadd(day, 1, @EndDate) )
			   AND Isnull(flag_close, '') <> 'Y'
		ORDER  BY a.elt_account_number,
				  tran_date,
				  tran_seq_num
	END          
END
