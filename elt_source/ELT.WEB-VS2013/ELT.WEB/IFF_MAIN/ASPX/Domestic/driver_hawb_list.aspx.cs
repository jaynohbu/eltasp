using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Web;
using System.Web.Mobile;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.MobileControls;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

public partial class ASPX_Domestic_driver_hawb_list : System.Web.UI.MobileControls.MobilePage
{
    protected string elt_account_number;
    protected string driver_acct;

    protected void Page_Load(object sender, EventArgs e)
    {
        elt_account_number = Request.Params["ELT"].ToString();
        driver_acct = Request.Params["ORG"].ToString();
        string SQL = "SELECT hawb_num FROM hawb_master_drivers where elt_account_number=" + elt_account_number
            + " AND driver_acct=" + driver_acct;

        HAWBList.DataSource = bindArrayToList(SQL);
        HAWBList.DataBind();
    }

    protected ArrayList bindArrayToList(string sqlText)
    {
        ArrayList arrayList = new ArrayList();
        SqlConnection Con = null;
        try
        {
            string ConnectStr = (new igFunctions.DB().getConStr());
            Con = new SqlConnection(ConnectStr);
            SqlCommand Cmd = new SqlCommand(sqlText, Con);
            Con.Open();
            SqlDataReader reader = Cmd.ExecuteReader();
            arrayList.Add("");
            while (reader.Read())
            {
                arrayList.Add(reader["hawb_num"].ToString());
            }
        }
        catch
        {
        }
        finally
        {
            if (Con != null)
            {
                Con.Close();
            }
        }
        return arrayList;
    }
    protected void HAWBList_ItemCommand(object sender, ListCommandEventArgs e)
    {
        Response.Redirect("driver_hawb_detail.aspx?ELT=" + elt_account_number  + "&ORG=" + driver_acct + "&HAWB=" + e.ListItem.Text);
    }
}
