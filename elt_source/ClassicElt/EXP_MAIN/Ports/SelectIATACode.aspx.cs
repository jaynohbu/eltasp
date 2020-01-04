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



public partial class Ports_SelectIATACode : System.Web.UI.Page
{
    protected string port_desc, port_country;
    
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            Session.LCID = 1033;

            if (!IsPostBack)
            {
                //port_country = Request.Params["COUNTRY"];
                //port_desc = Request.Params["FPDESC"];
                //LoadPortList();
            }
        }
        catch(Exception ex)
        {
            Response.Write(ex.Message);
        }
    }

    protected void LoadPortList()
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        string sSQL = @"SELECT code_id,code_desc FROM aes_codes WHERE code_type='Port Code' 
            AND (CAST(code_desc AS VARCHAR(128)) LIKE N'%" + port_desc + "%' OR CAST(code_desc AS VARCHAR(128)) LIKE N'%" + port_country + "%') ORDER BY CAST(code_desc AS VARCHAR)";
        if (port_country == "")
        {
            sSQL = @"SELECT code_id,code_desc FROM aes_codes WHERE code_type='Port Code' 
                AND CAST(code_desc AS VARCHAR(128)) LIKE N'%" + port_desc + "%' ORDER BY CAST(code_desc AS VARCHAR)";
        }
        feData.AddToDataSet("portCode", sSQL);

        lstPortCode.DataSource = feData.Tables["portCode"];
        lstPortCode.DataTextField = "code_desc";
        lstPortCode.DataValueField = "code_id";
        lstPortCode.DataBind();
    }

    protected void imgButSearch_Click(object sender, ImageClickEventArgs e)
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        string sSQL = @"SELECT code_id,code_desc FROM aes_codes WHERE code_type='Port Code' 
                AND CAST(code_desc AS VARCHAR(128)) LIKE N'%" + txtSearchKey.Text + "%' ORDER BY CAST(code_desc AS VARCHAR)";

        feData.AddToDataSet("portCode", sSQL);

        lstPortCode.DataSource = feData.Tables["portCode"];
        lstPortCode.DataTextField = "code_desc";
        lstPortCode.DataValueField = "code_id";
        lstPortCode.DataBind();
    }

    protected void btnNext_Click(object sender, ImageClickEventArgs e)
    {
        string port_id, port_code, port_desc;

        port_id = "";
        port_desc = "";
        port_code = "";

        port_id = Request.Params["FPID"];
        port_code = lstPortCode.SelectedValue;
        port_desc = lstPortCode.Items[lstPortCode.SelectedIndex].Text;

        // string strURL = "../Common/EditPort.aspx?PCODE=&FPID=" + port_id + "&FPCOD="
        //    + port_code + "&FPDESC=" + Server.UrlEncode(port_desc);
        // Response.Redirect(strURL);
        this.ClientScript.RegisterClientScriptBlock(this.GetType(), "close_window_return", "<script>close_window_return('" + port_code + "');</script>");
    }

}
