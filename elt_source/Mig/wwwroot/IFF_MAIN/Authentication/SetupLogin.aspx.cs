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


public partial class Authentication_create_login : System.Web.UI.Page
{
    protected string vSession = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        Session.RemoveAll();

        try
        {
            
            if (Request.Params["sid"] != "")
            {
                vSession = Request.Params["sid"];
            }
            else
            {
                if (Request.Params["err"] != "")
                {
                    vSession = Session["sid"].ToString();
                }
            }
        }
        catch { }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        Session["semail"] = TxtEmail.Text;
        Session["spassword"] = TxtPassword.Text;
        if (Session["sid"] == "" || Session["sid"] == null)
        {
            // Find Session ID when new login occurs
            Session["sid"] = getSetupSession(TxtEmail.Text, TxtPassword.Text);
        }
        Response.Redirect("/IFF_MAIN/OnlineApply/NewAccount.aspx?mode=Guest");
    }

    private string getSetupSession(string semail, string spassword)
    {
        string ConnectStr = (new igFunctions.DB().getConStr());
        SqlConnection Con = new SqlConnection(ConnectStr);
        SqlCommand Cmd = new SqlCommand();
        Cmd.Connection = Con;
        SqlDataReader reader;
        string returnValue = "";

        Cmd.CommandText = "SELECT * FROM setup_session WHERE "
            + "email='" + semail + "' AND password='" + spassword + "'";
        try
        {
            Con.Open();
            reader = Cmd.ExecuteReader();
            if (reader.Read())
            {
                returnValue = reader["sid"].ToString();
            }
        }
        catch
        {
        }
        finally
        {
            Con.Close();
        }

        return returnValue;
    }
}
