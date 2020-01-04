using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public partial class NewAccount_SetupAsk : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        hELTAcctNo.Value = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
    }

    protected void rlSetupOption_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rlSetupOption.SelectedValue == "N")
        {
            RemoveSetupSession();
        }
        if (rlSetupOption.SelectedValue == "L")
        {
            UpdateSetupSession();
        }
        if (rlSetupOption.SelectedValue == "H")
        {
            Response.Write("<script>window.close();</script>");
        }
        Response.Write("<script>window.returnValue=\"" + rlSetupOption.SelectedValue + "\"; window.close();</script>");
    }

    protected void UpdateSetupSession()
    {
        string SQL = "";
        string ConnectStr = (new igFunctions.DB().getConStr());
        SqlConnection Con = new SqlConnection(ConnectStr);
        SqlCommand Cmd = new SqlCommand();
        Cmd.Connection = Con;
        Con.Open();
        try
        {
            Cmd.CommandText = "UPDATE setup_session SET updated_date=DATEADD(dd,10,GETDATE()) WHERE ISNULL(elt_account_number,0)=" + hELTAcctNo.Value; 
            Cmd.ExecuteNonQuery();
        }
        catch { }
        finally
        {
            Con.Close();
            Cmd = null;
            Con = null;
        }
    }

    protected void RemoveSetupSession()
    {
        string SQL = "";
        string ConnectStr = (new igFunctions.DB().getConStr());
        SqlConnection Con = new SqlConnection(ConnectStr);
        SqlCommand Cmd = new SqlCommand();
        Cmd.Connection = Con;
        Con.Open();
        try
        {
            Cmd.CommandText = "DELETE FROM setup_session WHERE ISNULL(elt_account_number,0)=" + hELTAcctNo.Value; 
            Cmd.ExecuteNonQuery();
        }
        catch { }
        finally
        {
            Con.Close();
            Cmd = null;
            Con = null;
        }
    }
}
