using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Collections;
using System.Data.SqlClient;
/// <summary>
/// Summary description for ARStatusManager
/// </summary>
public class ARStatusManager:Manager
{
    public ARStatusManager(string elt_acct)
        : base(elt_acct)
	{        
       
	}

    public bool FindIfPaymentProcessed(int invoice_no)
    {
        SQL = "select  count(payment_no) from customer_payment_detail where elt_account_number=" + elt_account_number;
        SQL += " and invoice_no=" + invoice_no;
        Cmd = new SqlCommand(SQL, Con);
        int rowCount = 0;
        try
        {
            Con.Open();
            rowCount =Int32.Parse(Cmd.ExecuteScalar().ToString());
        }
        catch (Exception ex)
        {

            throw ex;
        }
        finally
        {
            Con.Close();
        }
        if (rowCount >= 1)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    public ArrayList getPaymentProcessed(int invoice_no)
    {

        ArrayList statusList = new ArrayList();
        SQL = "select distinct payment_no from customer_payment_detail where elt_account_number=" + elt_account_number;
        SQL += " and invoice_no=" + invoice_no + " order by payment_no";
        
     
        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        try
        {
            ad.Fill(dt);
        }
        catch (Exception ex)
        {
            throw ex;
        }

        for (int i = 0; i < dt.Rows.Count; i++)
        {
           int payment_no = Int32.Parse(dt.Rows[i]["payment_no"].ToString());

            String SQL2 = "select received_amt,payment_date, ref_no from customer_payment where elt_account_number=" + elt_account_number;
            SQL2 += " and payment_no=" + payment_no + " order by payment_date desc";


            DataTable dt2 = new DataTable();
            SqlDataAdapter ad2 = new SqlDataAdapter(SQL2, Con);
            try
            {
                ad2.Fill(dt2);
            }
            catch (Exception ex)
            {
                throw ex;
            }

            StatusItem item = new StatusItem();
            item.invoice_no = invoice_no.ToString();
            item.payment_no = payment_no.ToString();
            item.amount = Decimal.Parse(dt2.Rows[i]["received_amt"].ToString());
            item.processed_date = dt2.Rows[i]["payment_date"].ToString();
            statusList.Add(item);
        }
        return statusList;
    }

}
