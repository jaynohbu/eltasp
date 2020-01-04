using FreightEasy.DataManager;
using System;

namespace FreightEasy.Accounting
{
    [Serializable]
    public class APDispute : FreightEasyData
    {
        public APDispute()
        {
        }

        public APDispute GetAllRecords(string elt_account_number, string vendor_num, string start_date, string end_date)
        {
            string txtSQL = @"SELECT a.elt_account_number,a.org_account_number,a.dba_name,a.class_code,a.business_phone, 
                SUM(CASE WHEN (c.bill_amt=c.amt_due) THEN c.bill_amt END) AS [Bill Amount],
                SUM(CASE WHEN (c.bill_amt=c.amt_due) THEN c.bill_amt END)-SUM(c.amt_paid) AS [Balance],
                SUM(c.amt_paid) AS [Paid Amount],
                SUM(c.amt_dispute) AS [Dispute Amount]
                FROM organization a LEFT OUTER JOIN bill b 
                ON (a.elt_account_Number=b.elt_account_number AND a.org_account_number=b.vendor_number) LEFT OUTER JOIN check_detail c
                ON (b.elt_account_Number=c.elt_account_number AND b.bill_number=c.bill_number)
                WHERE ISNULL(amt_dispute,0)<>0 AND a.elt_account_number=" + elt_account_number;

            if (vendor_num != "" && vendor_num != "0")
            {
                txtSQL = txtSQL + " AND org_account_number=" + vendor_num;
            }

            if (start_date != "")
            {
                txtSQL = txtSQL + " AND b.bill_date>=CAST('" + start_date + "' AS DATETIME)";
            }

            if (end_date != "")
            {
                txtSQL = txtSQL + " AND b.bill_date<=CAST('" + end_date + "' AS DATETIME)";
            }

            txtSQL = txtSQL + " GROUP BY a.elt_account_number,a.org_account_number,a.dba_name,a.class_code,a.business_phone";
            this.AddToDataSet("APDispute", txtSQL);


            txtSQL = @"SELECT a.elt_account_number,a.bill_number,a.print_id,b.vendor_number,
                b.bill_date,b.pmt_method,a.memo,
                dbo.GetFileNumbersByBill(a.elt_account_number,b.bill_number) AS file_no,
                amt_due,a.amt_paid,a.amt_dispute
                FROM check_detail a LEFT OUTER JOIN bill b
                ON (a.elt_account_Number=b.elt_account_number AND a.bill_number=b.bill_number)
                WHERE ISNULL(a.amt_dispute,0)<>0 AND a.elt_account_number=" + elt_account_number;

            if (vendor_num != "" && vendor_num != "0")
            {
                txtSQL = txtSQL + " AND b.vendor_number=" + vendor_num;
            }

            if (start_date != "")
            {
                txtSQL = txtSQL + " AND b.bill_date>=CAST('" + start_date + "' AS DATETIME)";
            }

            if (end_date != "")
            {
                txtSQL = txtSQL + " AND b.bill_date<=CAST('" + end_date + "' AS DATETIME)";
            }

            txtSQL = txtSQL + " ORDER BY a.bill_number,a.amt_due DESC";

            this.AddToDataSet("APDisputeBill", txtSQL);

            this.AddRelation("Relation1", "APDispute", "elt_account_number,org_account_number", "APDisputeBill", "elt_account_number,vendor_number");
            
            return this;
        }
    }
}
