using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using System.Collections;
using System.Text;

/// <summary>
/// Summary description for IVChargeItemManager
/// </summary>
public class ARNChargeItemsManager:Manager
{
    public ARNChargeItemsManager(string elt_acct)
        : base(elt_acct)
	{ 	}

    public DataTable getChargeItemsFromARN(int arn_no)
    {
        DataTable dt = new DataTable();
        SQL = "SELECT * ARN_CHARGE_ITEM WHERE ELT_ACCOUNT_NUMBER = '" + elt_account_number + "' and arn_no=" + arn_no;
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        try
        {
            ad.Fill(dt);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return dt;
    }

}
