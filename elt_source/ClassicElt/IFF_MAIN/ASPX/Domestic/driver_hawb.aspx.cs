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

public partial class ASPX_Domestic_driver_hawb : System.Web.UI.MobileControls.MobilePage
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void Command1_Click(object sender, EventArgs e)
    {
        string sqlText = "SELECT * FROM registered_driver WHERE elt_account_number=" + txtLoginAcct.Text.ToString()
            + " AND driver_id='" + txtLoginID.Text.ToString() + "' AND driver_pass='" + txtLoginPass.Text.ToString() + "'";
        SqlConnection Con = null;
        
        try
        {
            string ConnectStr = (new igFunctions.DB().getConStr());
            Con = new SqlConnection(ConnectStr);
            SqlCommand Cmd = new SqlCommand(sqlText, Con);
            Con.Open();
            SqlDataReader reader = Cmd.ExecuteReader();
            if (reader.Read())
            {
                Response.Redirect("driver_hawb_list.aspx?ELT=" + reader["elt_account_number"].ToString() + "&ORG=" + reader["driver_acct"].ToString());
            }
            else
            {
                Command1.Text = "Failed, try again";
            }
        }
        catch
        {
            Command1.Text = "Failed, try again";
        }
        finally
        {
            if (Con != null)
            {
                Con.Close();
            }
        }
    }
}
