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


public partial class Common_SearchPort : System.Web.UI.Page
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
        feData.AddToDataSet("scheD", "SELECT port_code,port_desc FROM port_codes WHERE port_type='Schedule D' AND port_desc LIKE N'%" + txtSearchKey.Text.ToUpper() + "%' ORDER BY port_desc");
        feData.AddToDataSet("scheK", "SELECT port_code,port_desc+', '+port_country as port_desc FROM port_codes WHERE port_type='Schedule K' AND (port_desc LIKE N'%" + txtSearchKey.Text.ToUpper() + "%' OR port_country LIKE N'%" + txtSearchKey.Text.ToUpper() + "%') ORDER BY port_desc");
        feData.AddToDataSet("portCode", "SELECT code_id,code_desc FROM aes_codes WHERE code_type='Port Code' AND CAST(code_desc AS VARCHAR) LIKE N'%" + txtSearchKey.Text.ToUpper() + "%' ORDER BY CAST(code_desc AS VARCHAR)");
        
        lstScheD.DataSource = feData.Tables["scheD"];
        lstScheD.DataTextField = "port_desc";
        lstScheD.DataValueField = "port_code";
        lstScheD.DataBind();
        
        lstScheK.DataSource = feData.Tables["scheK"];
        lstScheK.DataTextField = "port_desc";
        lstScheK.DataValueField = "port_code";
        lstScheK.DataBind();

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

        if (lstPortCode.SelectedValue != "")
        {
            port_desc = lstPortCode.Items[lstPortCode.SelectedIndex].Text;
        }

        if (lstScheD.SelectedValue != "")
        {
            port_id = lstScheD.SelectedValue;
            port_desc = lstScheD.Items[lstScheD.SelectedIndex].Text;
        }

        if (lstScheK.SelectedValue != "")
        {
            port_id = lstScheK.SelectedValue;
            port_desc = lstScheK.Items[lstScheK.SelectedIndex].Text;
        }
        

        string strURL = "./EditPort.aspx?PCODE=&FPID=" + port_id + "&FPCOD=" 
            + lstPortCode.SelectedValue + "&FPDESC=" + Server.UrlEncode(port_desc);
        Response.Redirect(strURL);
    }

    protected void lstScheD_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (lstScheK.SelectedIndex >= 0)
        {
            lstScheK.SelectedIndex = -1;
        }
    }

    protected void lstScheK_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (lstScheD.SelectedIndex >= 0)
        {
            lstScheD.SelectedIndex = -1;
        }
    }
}
