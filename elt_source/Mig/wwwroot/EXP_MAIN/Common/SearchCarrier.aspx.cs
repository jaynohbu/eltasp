using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public partial class Common_SearchCarrier : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    protected void imgButSearch_Click(object sender, ImageClickEventArgs e)
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        feData.AddToDataSet("IATA", "SELECT code_id, code_desc FROM aes_codes WHERE code_type='IATA Code 2' AND CAST(code_desc AS VARCHAR) LIKE N'%" + txtSearchKey.Text.ToUpper() + "%' ORDER BY CAST(code_desc AS VARCHAR)");

        lstIATACode.DataSource = feData.Tables["IATA"];
        lstIATACode.DataTextField = "code_desc";
        lstIATACode.DataValueField = "code_id";
        lstIATACode.DataBind();
    }
    protected void lstIATACode_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (lstIATACode.SelectedIndex >= 0)
        {
            lstSCACCode.SelectedIndex = -1;
        }
    }

    protected void lstSCACCode_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (lstSCACCode.SelectedIndex >= 0)
        {
            lstIATACode.SelectedIndex = -1;
        }
    }

    protected void btnNext_Click(object sender, ImageClickEventArgs e)
    {
        string strURL = "./EditCarrier.aspx?CID=";

        if (lstIATACode.SelectedIndex >= 0)
        {
            strURL = strURL + "&FCID=" + lstIATACode.SelectedValue + "&FCNAME=" + lstIATACode.Items[lstIATACode.SelectedIndex].Text + "&FCTYPE=IATA";
            Response.Redirect(strURL);
        }
    }
}
