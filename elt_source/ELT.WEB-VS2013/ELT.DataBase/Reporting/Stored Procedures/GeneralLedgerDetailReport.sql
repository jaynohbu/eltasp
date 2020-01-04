

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Reporting].[GeneralLedgerDetailReport]
	--@GLAccountType VARCHAR(128), --@GLAccountType
	@StartDate datetime,
	@EndDate datetime,	
	@EltAccountNumber int 
AS
BEGIN
	SET NOCOUNT ON;
	IF LEN(CAST(@EltAccountNumber AS varchar(20))) >5
		BEGIN
			SELECT a.elt_account_number,
				   a.gl_account_number                            AS GL_Number,
				   b.gl_account_desc                              AS GL_Name,
				   a.tran_type                                    AS Type,
				   a.air_ocean,
				   a.tran_date                                    AS Date,
				   a.tran_num                                     AS Num,
				   a.check_no                                     AS Check_No,
				   CASE
					 WHEN Isnull(o.class_code, '') = '' THEN o.dba_name
					 ELSE o.dba_name + ' ['
						  + Rtrim(Ltrim(Isnull(o.class_code, ''))) + ']'
				   END                                            AS Company_Name,
				   a.memo                                         AS Memo,
				   a.split                                        AS Split,
				   ( a.debit_amount + Isnull(a.debit_memo, 0) )   AS debit_amount,
				   ( a.credit_amount + Isnull(a.credit_memo, 0) ) AS credit_amount
			FROM   gl b,
				   all_accounts_journal a
				   LEFT OUTER JOIN organization o
								ON a.elt_account_number = o.elt_account_number
								   AND a.customer_number = o.org_account_number
			WHERE  a.elt_account_number = b.elt_account_number
				   AND a.elt_account_number = @EltAccountNumber
				   AND a.gl_account_number = b.gl_account_number
				   AND ( a.tran_date >= @StartDate
						 AND a.tran_date < Dateadd(day, 1, @EndDate)
						  OR a.tran_type IS NULL )
				   AND Isnull(flag_close, '') <> 'Y'
			ORDER  BY a.elt_account_number,
					  a.gl_account_number,
					  a.tran_date,
					  a.tran_seq_num   
		END          
	--ELSE
	--	BEGIN	
			
	--	END
END
