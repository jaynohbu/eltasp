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
public class APStatusManager:Manager
{
    public APStatusManager(string elt_acct)
        : base(elt_acct)
	{        
       
	}
    public bool FindIfPaymentProcessed(int bill_number)
    {
        SQL = "select  count(print_id) from check_detail where elt_account_number=" + elt_account_number;
        SQL += " and bill_number=" + bill_number;
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
    public bool FindIfAPProcessed(int invoice_no)
    {
        SQL = "select  count(bill_number) from bill_detail where isnull(bill_number,0)<>0 and  elt_account_number=" + elt_account_number;
        SQL += " and invoice_no=" + invoice_no;
        Cmd = new SqlCommand(SQL, Con);
        int rowCount = 0;
        try
        {
            Con.Open();
            rowCount = Int32.Parse(Cmd.ExecuteScalar().ToString());
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
    public ArrayList getPaymentProcessed(int bill_number)
    {
        ArrayList statusList = new ArrayList();
        SQL = "select * from check_detail where elt_account_number=" + elt_account_number;
        SQL += " and bill_number=" + bill_number + " order by print_id";
     
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
        StatusItem item = new StatusItem();
        
        for (int i = 0; i < dt.Rows.Count; i++)
        {            
            item.print_id= dt.Rows[i]["print_id"].ToString();
            item.amount = Decimal.Parse(dt.Rows[i]["bill_amt"].ToString());
            statusList.Add(item);            
        }
        return statusList;
    }
}
