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

public partial class Ports_SearchUS : System.Web.UI.Page
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

        lstScheD.DataSource = feData.Tables["scheD"];
        lstScheD.DataTextField = "port_desc";
        lstScheD.DataValueField = "port_code";
        lstScheD.DataBind();
    }

    protected void btnNext_Click(object sender, ImageClickEventArgs e)
    {
        string sURL = "./EditPort.aspx?FPID=" + lstScheD.SelectedValue + "&FPDESC="
            + Server.UrlEncode(lstScheD.Items[lstScheD.SelectedIndex].Text) + "&COUNTRY=US";

        Response.Redirect(sURL);
    }
}
