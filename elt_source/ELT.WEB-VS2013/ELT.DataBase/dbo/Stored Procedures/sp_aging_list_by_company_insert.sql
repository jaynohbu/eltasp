-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_aging_list_by_company_insert]
(
	@elt_account_number numeric(8),
	@invoice_id numeric(18)
)	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF;
	DECLARE @gl_account_ar DECIMAL
	--Insert statements for procedure here
	SELECT @gl_account_ar = gl_account_number
		  FROM   gl
		  WHERE  elt_account_number = @elt_account_number
				 AND gl_account_desc = 'Accounts Receivable'
	DECLARE @customer_dba_name nvarchar(180)  
	BEGIN TRY
		INSERT [PRDDB].[dbo].[invoice_joined_temp]
			SELECT *
			FROM
			  (SELECT invoice_id,
					CASE
						  WHEN isnull(f.class_code,'') = '' THEN f.dba_name
						  ELSE f.dba_name + ' [' + RTRIM(LTRIM(isnull(f.class_code,''))) + ']'
					  END AS customer_dba_name,
					  f.business_phone,
					  0 AS customer_credit,
					  d.customer_number AS customer_no,
					  d.elt_account_number,
					  d.invoice_no,
					  invoice_type,
					  import_export,
					  air_ocean,
					  invoice_date,
					  ref_no,
					  ref_no_Our,
					  Customer_info,
					  Total_Pieces,
					  Total_Gross_Weight,
					  Total_Charge_Weight,
					  Origin_Dest,
					  origin,
					  dest,
					  Customer_Number,
					  Customer_Name,
					  shipper,
					  consignee,
					  entry_no,
					  entry_date,
					  Carrier,
					  Arrival_Dept,
					  mawb_num,
					  hawb_num,
					  subtotal,
					  sale_tax,
					  agent_profit,
					  accounts_receivable,
					  amount_charged,
					  ISNULL(e.p_amt,0) AS amount_paid,
					  ISNULL(e.b_amt,amount_charged) AS balance,
					  total_cost,
					  remarks,
					  pay_status,
					  term_curr,
					  term30,
					  term60,
					  term90,
					  received_amt,
					  pmt_method,
					  existing_credits,
					  deposit_to,
					  lock_ar,
					  lock_ap,
					  in_memo,
					  is_org_merged,
					  master_invoice_no
			   FROM invoice d
			   LEFT OUTER JOIN
				 (SELECT a.invoice_no,
						 a.amount_charged-SUM(ISNULL(b.payment,0)) AS b_amt,
						 SUM(ISNULL(b.payment,0)) AS p_amt
				  FROM invoice a
				  LEFT OUTER JOIN customer_payment_detail b ON (a.elt_account_number=b.elt_account_number
																AND a.invoice_no=b.invoice_no)
				  LEFT OUTER JOIN customer_payment c ON (b.elt_account_number=c.elt_account_number
														 AND b.payment_no=c.payment_no)
				  WHERE a.elt_account_number=@elt_account_number
					
					AND (c.payment_date IS NULL)
				  GROUP BY a.invoice_no,
						   a.amount_charged) e ON (d.invoice_no=e.invoice_no
												   AND d.elt_account_number=@elt_account_number)
			   LEFT OUTER JOIN organization f ON (f.elt_account_number=d.elt_account_number
												  AND f.org_account_number=d.customer_number)
			   WHERE (b_amt<>0
					  OR b_amt IS NULL)
				 
				 AND d.elt_account_number=@elt_account_number
				 AND d.elt_account_number is not null
			   UNION ALL SELECT invoice_id,
								 CASE
									WHEN isnull(f.class_code,'') = '' THEN f.dba_name
									ELSE f.dba_name + ' [' + RTRIM(LTRIM(isnull(f.class_code,''))) + ']'
								END AS customer_dba_name,
								f.business_phone,
								-1*e.credit AS customer_credit,
								   e.customer_no,
								   g.elt_account_number,
								   g.invoice_no,
								   invoice_type,
								   import_export,
								   air_ocean,
								   invoice_date,
								   ref_no,
								   ref_no_Our,
								   Customer_info,
								   Total_Pieces,
								   Total_Gross_Weight,
								   Total_Charge_Weight,
								   Origin_Dest,
								   origin,
								   dest,
								   Customer_Number,
								   Customer_Name,
								   shipper,
								   consignee,
								   entry_no,
								   entry_date,
								   Carrier,
								   Arrival_Dept,
								   mawb_num,
								   hawb_num,
								   subtotal,
								   sale_tax,
								   agent_profit,
								   accounts_receivable,
								   amount_charged,
								   amount_paid,
								   balance,
								   total_cost,
								   remarks,
								   pay_status,
								   term_curr,
								   term30,
								   term60,
								   term90,
								   received_amt,
								   pmt_method,
								   existing_credits,
								   deposit_to,
								   lock_ar,
								   lock_ap,
								   in_memo,
								   is_org_merged,
								   master_invoice_no
			   FROM organization f
			   RIGHT OUTER JOIN
				 (SELECT customer_no,
						 -1*SUM(val_1+val_2) AS credit
				  FROM
					(SELECT b.customer_number AS customer_no,
							(b.credit_amount+b.debit_amount) AS val_1,
							SUM(a.payment) AS val_2
					 FROM customer_payment_detail a
					 LEFT OUTER JOIN all_accounts_journal b ON (a.elt_account_number=b.elt_account_number
																AND b.tran_num=a.payment_no
																AND b.tran_type='PMT'
																AND b.gl_Account_number=@gl_account_ar)
					 WHERE b.elt_account_number=@elt_account_number
					 GROUP BY b.customer_number,
							  b.credit_amount,
							  b.debit_amount,
							  a.payment_no) c
				  GROUP BY c.customer_no) e
			   LEFT OUTER JOIN
				 (SELECT *
				  FROM invoice
				  WHERE elt_account_number=@elt_account_number
					AND balance<>0
					AND pay_status='A') g ON (g.invoice_no IS NULL
											  AND g.elt_account_number IS NULL) ON (f.elt_account_number=@elt_account_number
																					AND f.org_account_number=e.customer_no)
			   WHERE e.credit<>0
			   AND g.elt_account_number is not null
			   ) union_set
			WHERE invoice_id=@invoice_id
			ORDER BY customer_dba_name,
					 customer_number,
					 invoice_date+term_curr
	END TRY
	BEGIN CATCH
		-- Execute error retrieval routine.
		SELECT 
			ERROR_NUMBER() AS ErrorNumber
			,ERROR_MESSAGE() AS ErrorMessage
			,@elt_account_number as elt_account_number;
	END CATCH; 
END
