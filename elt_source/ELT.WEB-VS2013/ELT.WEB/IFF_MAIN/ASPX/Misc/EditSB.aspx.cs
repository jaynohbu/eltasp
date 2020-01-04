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

public partial class Common_EditSB : System.Web.UI.Page
{
    protected string ConnectStr, user_id, login_name, user_right, elt_account_number;

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            Session.LCID = 1033;

            if (!IsPostBack)
            {
                LoadAllData();
            }
        }
        catch
        {
        }
    }

    protected void LoadAllData()
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        feData.AddToDataSet("SBInfo", "SELECT * FROM scheduleB WHERE elt_account_number=" + elt_account_number + " AND auto_uid=" + hSBID.Value);

        if (feData.Tables["SBInfo"].Rows.Count > 0)
        {
            DataRow drSB = feData.Tables["SBInfo"].Rows[0];
            txtSBCode.Text = drSB["sb"].ToString();
            txtItemDesc.Text = drSB["description"].ToString();
            lstSBUnit1.SelectedValue = drSB["sb_unit1"].ToString();
            lstSBUnit2.SelectedValue = drSB["sb_unit2"].ToString();
            lstExportCode.SelectedValue = drSB["export_code"].ToString();
            lstLicenseType.SelectedValue = drSB["license_type"].ToString();
            txtECCN.Text = drSB["eccn"].ToString();
        }
    }

    protected void Page_Init(object sender, EventArgs e)
    {
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
        string sb_id = Request.Params["SBID"];
        hOrgID.Value = Request.Params["OrgID"];

        if (sb_id == null || sb_id == "")
        {
            labelTitle.Text = "ADD NEW SCHEDULE B ITEM";
        }
        else
        {
            labelTitle.Text = "EDIT SCHEDULE B ITEM";
            hSBID.Value = sb_id;
        }

        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        feData.AddToDataSet("ExportCode", "SELECT code_id,LEFT(code_id+'-'+CAST(code_desc AS NVARCHAR),32) AS code_desc FROM aes_codes WHERE code_type='Export Code' ORDER BY code_id");
        feData.AddToDataSet("LicenseType", "SELECT code_id,LEFT(code_id+'-'+CAST(code_desc AS NVARCHAR),32) AS code_desc FROM aes_codes WHERE code_type='License Code' ORDER BY code_id");
        feData.AddToDataSet("UOMCode", "SELECT code_id,LEFT(CAST(code_desc AS NVARCHAR),32) AS code_desc FROM aes_codes WHERE code_type='UOM' ORDER BY code_desc");
        
        lstSBUnit1.DataSource = feData.Tables["UOMCode"];
        lstSBUnit1.DataTextField = "code_desc";
        lstSBUnit1.DataValueField = "code_id";
        lstSBUnit1.DataBind();
        lstSBUnit1.Items.Insert(0, new ListItem("", ""));

        lstSBUnit2.DataSource = feData.Tables["UOMCode"];
        lstSBUnit2.DataTextField = "code_desc";
        lstSBUnit2.DataValueField = "code_id";
        lstSBUnit2.DataBind();
        lstSBUnit2.Items.Insert(0, new ListItem("", ""));

        lstExportCode.DataSource = feData.Tables["ExportCode"];
        lstExportCode.DataTextField = "code_desc";
        lstExportCode.DataValueField = "code_id";
        lstExportCode.DataBind();
        lstExportCode.Items.Insert(0, new ListItem("", ""));

        lstLicenseType.DataSource = feData.Tables["LicenseType"];
        lstLicenseType.DataTextField = "code_desc";
        lstLicenseType.DataValueField = "code_id";
        lstLicenseType.DataBind();
        lstLicenseType.Items.Insert(0, new ListItem("", ""));
    }

    protected void btnSave_Click(object sender, ImageClickEventArgs e)
    {
        if (hSBID.Value == "")
        {
            AddNewScheduleB();
        }
        else
        {
            UpdateScheduleB();
        }
    }

    protected void AddNewScheduleB()
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        ArrayList tranStrAL = new ArrayList();
        string tranStr = "";

        tranStr = "INSERT INTO scheduleB(elt_account_number,sb,description,sb_unit1,sb_unit2,export_code,license_type,eccn)\n"
            + "VALUES(" + elt_account_number + ",N'" + txtSBCode.Text + "',N'" + txtItemDesc.Text + "',N'" 
            + lstSBUnit1.SelectedValue + "',N'" + lstSBUnit2.SelectedValue + "',N'" + lstExportCode.SelectedValue + "',N'" 
            + lstLicenseType.SelectedValue + "',N'" + txtECCN.Text + "')";
        tranStrAL.Add(tranStr);

        if (hOrgID.Value != null && hOrgID.Value != "")
        {
            tranStr = "INSERT INTO ig_schedule_b(elt_account_number,org_account_number,sb_id,sb,description,sb_unit1,sb_unit2,export_code,license_type,eccn)\n"
            + "VALUES(" + elt_account_number + "," + hOrgID.Value + ",IDENT_CURRENT('scheduleB')-1,N'" + txtSBCode.Text + "',N'" + txtItemDesc.Text + "',N'"
            + lstSBUnit1.SelectedValue + "',N'" + lstSBUnit2.SelectedValue + "',N'" + lstExportCode.SelectedValue + "',N'"
            + lstLicenseType.SelectedValue + "',N'" + txtECCN.Text + "')";
            tranStrAL.Add(tranStr);
        }

        if (!feData.DataTransactions((string[])tranStrAL.ToArray(typeof(string))))
        {
            string errorStr = feData.GetLastTransactionError();
            string errorMsg = "Unexpected error occurred. " + errorStr;

            tableContent.Visible = false;
            txtResultBox.Text = errorMsg;
            txtResultBox.Visible = true;
        }
        else
        {
            this.ClientScript.RegisterClientScriptBlock(this.GetType(), "close_window_return", "<script>close_window_return(" + 0 + ",'');</script>");
        }
    }

    protected void UpdateScheduleB()
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        string[] tranStr = new string[1];

        tranStr[0] = "UPDATE scheduleB SET "
            + " sb=N'" + txtSBCode.Text
            + "',sb_unit1=N'" + lstSBUnit1.SelectedValue
            + "',sb_unit2=N'" + lstSBUnit2.SelectedValue
            + "',description=N'" + txtItemDesc.Text
            + "',export_code=N'" + lstExportCode.SelectedValue
            + "',license_type=N'" + lstLicenseType.SelectedValue
            + "',eccn=N'" + txtECCN.Text
            + "' WHERE elt_account_number=" + elt_account_number + " AND auto_uid=" + hSBID.Value;

        if (!feData.DataTransactions(tranStr))
        {
            string errorStr = feData.GetLastTransactionError();
            string errorMsg = "Unexpected error occurred. " + errorStr;

            tableContent.Visible = false;
            txtResultBox.Text = errorMsg;
            txtResultBox.Visible = true;
        }
        else
        {
            this.ClientScript.RegisterClientScriptBlock(this.GetType(), "close_window_return", "<script>close_window_return(" + 0 + ",'');</script>");
        }
    }

}
