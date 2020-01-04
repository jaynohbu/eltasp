

CREATE VIEW [dbo].[VW_ArrivalNotice]
AS
SELECT TOP (100) PERCENT IV.invoice_no, IV.Customer_Number, IV.elt_account_number, IV.mawb_num, IV.hawb_num, IV.invoice_date, IV.air_ocean, IV.import_export, MB.dep_code AS Origin, MB.arr_code AS Dest
FROM     (SELECT DISTINCT tran_num, elt_account_number
                  FROM      dbo.all_accounts_journal AS a with(nolock) 
                  WHERE   (tran_type = 'ARN')) AS ARN INNER JOIN
                  dbo.invoice AS IV with(nolock)  ON ARN.tran_num = IV.invoice_no AND ARN.elt_account_number = IV.elt_account_number AND IV.import_export = 'I' LEFT OUTER JOIN
                  dbo.import_mawb AS MB with(nolock)  ON IV.mawb_num = MB.mawb_num AND IV.elt_account_number = MB.elt_account_number
ORDER BY IV.invoice_date DESC
