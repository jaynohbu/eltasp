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


public partial class Ports_SearchNonUs : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            Session.LCID = 1033;

            if (!IsPostBack)
            {
            }
        }
        catch
        {
        }
    }

    protected void imgButSearch_Click(object sender, ImageClickEventArgs e)
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        feData.AddToDataSet("scheK", "SELECT port_code,port_desc+', '+port_country as port_desc FROM port_codes WHERE port_type='Schedule K' AND (port_desc LIKE N'%" + txtSearchKey.Text.ToUpper() + "%' OR port_country LIKE N'%" + txtSearchKey.Text.ToUpper() + "%') ORDER BY port_desc");

        lstScheK.DataSource = feData.Tables["scheK"];
        lstScheK.DataTextField = "port_desc";
        lstScheK.DataValueField = "port_code";
        lstScheK.DataBind();
    }

    protected void btnNext_Click(object sender, ImageClickEventArgs e)
    {
        string sURL = "./EditPort.aspx?FPID=" + lstScheK.SelectedValue + "&FPDESC="
            + GetDescByPort(lstScheK.SelectedValue) + "&COUNTRY=" + GetCountryByPort(lstScheK.SelectedValue);
        Response.Redirect(sURL);
    }

    protected string GetCountryByPort(string pCode)
    {
        string ConnectStr = (new igFunctions.DB().getConStr());
        SqlConnection Con = new SqlConnection(ConnectStr);
        SqlCommand Cmd = new SqlCommand();
        Cmd.Connection = Con;
        SqlDataReader reader;
        string resVal = "";

        try
        {
            Con.Open();

            Cmd.CommandText = "SELECT port_country FROM port_codes WHERE port_code=N'" + pCode + "' AND port_type='Schedule K'";

            reader = Cmd.ExecuteReader();
            if (reader.Read()) // Already being used by another user
            {
                resVal = reader["port_country"].ToString();
            }
            reader.Close();
        }
        catch { }
        finally
        {
            Con.Close();
        }
        return resVal;
    }

    protected string GetDescByPort(string pCode)
    {
        string ConnectStr = (new igFunctions.DB().getConStr());
        SqlConnection Con = new SqlConnection(ConnectStr);
        SqlCommand Cmd = new SqlCommand();
        Cmd.Connection = Con;
        SqlDataReader reader;
        string resVal = "";

        try
        {
            Con.Open();

            Cmd.CommandText = "SELECT port_desc FROM port_codes WHERE port_code=N'" + pCode + "' AND port_type='Schedule K'";

            reader = Cmd.ExecuteReader();
            if (reader.Read()) // Already being used by another user
            {
                resVal = reader["port_desc"].ToString();
            }
            reader.Close();
        }
        catch { }
        finally
        {
            Con.Close();
        }
        return resVal;
    }
}

