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
using System.Data.SqlClient;
using Infragistics.WebUI.UltraWebGrid;

public partial class SystemAdmin_SetupManager : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            //if (!Validate_SystemAdmin())
            //{
            //    Response.Redirect("/IFF_MAIN/Authentication/login.aspx");
            //}

            if (!IsPostBack)
            {
                Initialize_Form();
            }
        }
        catch
        {
            Response.Redirect("/IFF_MAIN/Authentication/login.aspx");
        }
    }

    protected void Initialize_Form()
    {
        ListBox1_Load_Data();
    }

    protected void ListBox1_Load_Data()
    {
        FreightEasy.DataManager.FreightEasyData FEData = new FreightEasy.DataManager.FreightEasyData();
        FEData.AddToDataSet("SetupSteps", "select * from setup_master order by seq_id");
        DataTable tmpDt = FEData.Tables["SetupSteps"];
        ListBox1.DataSource = tmpDt;
        ListBox1.DataTextField = tmpDt.Columns["title"].ToString();
        ListBox1.DataValueField = tmpDt.Columns["page_id"].ToString();
        ListBox1.DataBind();
    }

    protected bool Validate_SystemAdmin()
    {
        try
        {
            if (!Request.Cookies["CurrentUserInfo"]["elt_account_number"].ToString().Equals("80002000")
                || !Request.Cookies["CurrentUserInfo"]["login_name"].ToString().Equals("admin"))
            {
                return false;
            }
        }
        catch
        {
            return false;
        }
        return true;
    }

    protected void Save_Setup_page()
    {
        string[] sqlTxt = new string[1];

        if (hPageId.Value == "")
        {
            sqlTxt[0] = "INSERT INTO setup_master(seq_id,title,setup_url,setup_type,valid_url,remark) "
                + "VALUES (" + hSeqId.Value + ",'" + txtPageTitle.Text + "','" + txtPageURL.Text
                + "','" + lstSetupType.SelectedValue + "','" + txtValidURL.Text + "','" + txtRemark.Text + "')";
        }
        else
        {
            sqlTxt[0] = "UPDATE setup_master SET "
                + "seq_id=" + hSeqId.Value + ","
                + "title='" + txtPageTitle.Text + "',"
                + "setup_url='" + txtPageURL.Text + "',"
                + "setup_type='" + lstSetupType.SelectedValue + "',"
                + "valid_url='" + txtValidURL.Text + "',"
                + "remark='" + txtRemark.Text + "' WHERE page_id=" + hPageId.Value;
            // update change
        }

        FreightEasy.DataManager.FreightEasyData FEData = new FreightEasy.DataManager.FreightEasyData();
        if (!FEData.DataTransactions(sqlTxt))
        {
            Response.Redirect("/IFF_MAIN/SystemAdmin/SetupManager.aspx");
        }
        else
        {
            Response.Write(sqlTxt[0]);
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (hPageId.Value == "")
        {
            ListBox1.Items.Add(new ListItem(txtPageTitle.Text, ""));
            hSeqId.Value = ListBox1.Items.Count.ToString();
        }
        Save_Setup_page();
        Response.Redirect("/IFF_MAIN/SystemAdmin/SetupManager.aspx");
    }

    protected void btnDelete_Click(object sender, EventArgs e)
    {
        string sqlTxt = sqlTxt = "DELETE FROM setup_master WHERE page_id=" + hPageId.Value;

        FreightEasy.DataManager.FreightEasyData FEData = new FreightEasy.DataManager.FreightEasyData();
        if (FEData.DataTransaction(sqlTxt))
        {
            Response.Redirect("/IFF_MAIN/SystemAdmin/SetupManager.aspx");
        }
    }

    protected void ListBox1_SelectedIndexChanged(object sender, EventArgs e)
    {
        FreightEasy.DataManager.FreightEasyData FEData = new FreightEasy.DataManager.FreightEasyData();
        FEData.AddToDataSet("PageEntry", "select * from setup_master where page_id=" + ListBox1.SelectedValue);
        DataTable tmpDt = FEData.Tables["PageEntry"];
        if(tmpDt != null){
            hSeqId.Value = tmpDt.Rows[0]["seq_id"].ToString();
            hPageId.Value = tmpDt.Rows[0]["page_id"].ToString();
            txtPageTitle.Text = tmpDt.Rows[0]["title"].ToString();
            txtPageURL.Text = tmpDt.Rows[0]["setup_url"].ToString();
            txtValidURL.Text = tmpDt.Rows[0]["valid_url"].ToString();
            txtRemark.Text = tmpDt.Rows[0]["remark"].ToString();
            lstSetupType.SelectedValue = tmpDt.Rows[0]["setup_type"].ToString();
        }
    }
}
