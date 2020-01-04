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

public partial class OnlineApply_CreateAdmin : System.Web.UI.Page
{
    protected string credit_card_url = "";
    private string ConnectStr = null;
    string returnURL = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            ConnectStr = (new igFunctions.DB().getConStr());
            checkPaymentDue(Session["sELTAcct"].ToString());
            TxtELTAcct.Text = Session["sELTAcct"].ToString();
        }
        catch
        {
            Response.Write("<script>window.location.href=\"" + returnURL + "\";</script>");
        }
    }

    protected void checkPaymentDue(string eltAcct)
    {
        SqlConnection Con = new SqlConnection(ConnectStr);
        SqlCommand Cmd = new SqlCommand();
        Cmd.Connection = Con;
        SqlDataReader reader;

        Cmd.CommandText = "SELECT a.elt_account_number,a.payment_id,ISNULL(pmt_status,'') AS pmt_status "
            + "FROM setup_session a LEFT OUTER JOIN payment_due b "
            + "ON (a.elt_account_number=b.elt_account_number AND b.pmt_desc='Premium Subscription' AND a.page_id IS NULL) "
            + "WHERE a.elt_account_number=" + eltAcct;

        try
        {
            Con.Open();
            reader = Cmd.ExecuteReader();

            if (reader.Read())
            {
                if (reader["elt_account_number"].ToString() != "")
                {
                    if (reader["pmt_status"].ToString() == "N")
                    {
                        returnURL = "../AuthorizeNet/credit_card.asp?pid=" + reader["payment_id"].ToString();
                        Response.Write("<script>window.location.href=\"" + returnURL + "\";</script>");
                    }
                }
            }
        }
        catch { }
        finally { if (Con != null) { Con.Close(); } }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        string ConnectStr = (new igFunctions.DB().getConStr());
        SqlConnection Con = null;
        string returnURL = "";

        Con = new SqlConnection(ConnectStr);
        SqlCommand Cmd = new SqlCommand();
        Cmd.Connection = Con;
        Con.Open();
        SqlTransaction trans = Con.BeginTransaction();
        Cmd.Transaction = trans;

        try
        {
            

            Cmd.CommandText = "UPDATE users SET password='" + TxtPassword.Text
                + "' WHERE elt_account_number=" + TxtELTAcct.Text + " AND userid=1000";

            string err = Cmd.ExecuteNonQuery().ToString();

            Cmd.CommandText = @"BEGIN DECLARE @page_id INT 
                SET @page_id=(select TOP 1 page_id from setup_master ORDER BY seq_id)
                UPDATE setup_session SET page_id=@page_id WHERE elt_account_number=" + TxtELTAcct.Text + " END";

            err = Cmd.ExecuteNonQuery().ToString();

            trans.Commit();
            Con.Close();
        }
        catch {
            trans.Rollback();
            returnURL = "../Authentication/SetupLogin.aspx?err=yes";
        }
        finally { if (Con != null) { Con.Close(); } }

        returnURL = "./CreateComplete.aspx";

        Response.Write("<script>window.location.href=\"" + returnURL + "\";</script>");
    }
}

