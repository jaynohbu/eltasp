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



public partial class ASPX_Include_quickAddClientNew : System.Web.UI.Page
{
    protected string ConnectStr, user_id, login_name, user_right, elt_account_number, org_id;

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            Session.LCID = 1033;

            if (!IsPostBack && org_id != "")
            {
                LoadAllData(org_id);
            }
        }
        catch
        {
        }
    }

    protected void LoadAllData(string OrgID)
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        feData.AddToDataSet("OrgInfo", "SELECT * FROM organization WHERE elt_account_number=" + elt_account_number + " AND org_account_number=" + OrgID);

        if (feData.Tables["OrgInfo"].Rows.Count > 0)
        {
            DataRow drOrg = feData.Tables["OrgInfo"].Rows[0];
            txtDBA.Text = drOrg["dba_name"].ToString();
            txtLegalName.Text = drOrg["business_legal_name"].ToString();
            txtAddress1.Text = drOrg["business_address"].ToString();
            txtAddress2.Text = drOrg["business_address2"].ToString();
            txtCity.Text = drOrg["business_city"].ToString();
            txtState.Text = drOrg["business_state"].ToString();
            txtZip.Text = drOrg["business_zip"].ToString();
            lstCountry.SelectedValue = drOrg["b_country_code"].ToString();
            txtFirstName.Text = drOrg["owner_fname"].ToString();
            txtMidName.Text = drOrg["owner_mname"].ToString();
            txtLastName.Text = drOrg["owner_lname"].ToString();
            txtPhone.Text = FormatStringNumberOnly(drOrg["business_phone"].ToString());
            txtFax.Text = FormatStringNumberOnly(drOrg["business_fax"].ToString());
            txtCell.Text = FormatStringNumberOnly(drOrg["owner_phone"].ToString());
            txtEmail.Text = drOrg["owner_email"].ToString();
            txtTaxID.Text = drOrg["business_fed_taxid"].ToString();
        }
    }

    protected void Page_Init(object sender, EventArgs e)
    {
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
        org_id = Request.Params["orgID"].ToString();

        if (org_id == "" || org_id == "0")
        {
            labelTitle.Text = "ADD NEW COMPANY";
            org_id = "";
        }
        else
        {
            labelTitle.Text = "EDIT COMPANY";
        }

        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        feData.AddToDataSet("Countries", "SELECT * FROM country_code WHERE elt_account_number=" + elt_account_number + " ORDER BY country_name");

        lstCountry.DataSource = feData.Tables["Countries"];
        lstCountry.DataTextField = "country_name";
        lstCountry.DataValueField = "country_code";
        lstCountry.DataBind();
        lstCountry.Items.Insert(0, new ListItem("", ""));
    }

    protected void AddNewConsignee()
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        string[] tranStr = new string[1];
        tranStr[0] = "DECLARE @new_org_id DECIMAL\n";
        tranStr[0] += "SET @new_org_id=(SELECT ISNULL(MAX(org_account_number),0)+1 FROM organization WHERE elt_account_number=" + elt_account_number + ")\n";
        tranStr[0] += "INSERT INTO organization(elt_account_number,org_account_number,dba_name,business_legal_name,business_address,business_address2,business_city,business_state,business_zip,business_country,b_country_code,business_phone,business_fax,owner_lname,owner_fname,owner_mname,owner_phone,owner_email,account_status,date_opened,last_update)\n";
        tranStr[0] += "VALUES(" + elt_account_number + ",@new_org_id,N'" + txtDBA.Text + "',N'" + txtLegalName.Text + "',N'" + txtAddress1.Text + "',N'" + txtAddress2.Text + "',N'" + txtCity.Text + "',N'" + txtState.Text + "',N'" + txtZip.Text + "',N'" + lstCountry.Items[lstCountry.SelectedIndex].Text
            + "',N'" + lstCountry.SelectedValue + "',N'" + txtPhone.Text + "',N'" + txtFax.Text + "',N'" + txtLastName.Text + "',N'" + txtFirstName.Text + "',N'" + txtMidName.Text + "',N'" + txtCell.Text + "',N'" + txtEmail.Text + "','A',GETDATE(),GETDATE())";

        if (!feData.DataTransactions(tranStr))
        {
            string errorStr = feData.GetLastTransactionError();
            string errorMsg = "Unexpected error occurred. " + errorStr;

            tableContent.Visible = false;
            txtResultBox.Text = errorMsg;
            txtResultBox.Visible = true;
            btnSave.Visible = false;
        }
        else
        {
            this.ClientScript.RegisterClientScriptBlock(this.GetType(), "close_window_return", "<script>close_window_return(" + 0 + ",'');</script>");
        }
    }


    protected void UpdateConsignee(string OrgID)
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        string[] tranStr = new string[1];

        tranStr[0] = "UPDATE organization SET "
            + "dba_name=N'" + txtDBA.Text.Replace("'", "`")
            + "',business_legal_name=N'" + txtLegalName.Text.Replace("'","`")
            + "',business_address=N'" + txtAddress1.Text.Replace("'", "`")
            + "',business_address2=N'" + txtAddress2.Text.Replace("'", "`")
            + "',business_city=N'" + txtCity.Text.Replace("'", "`")
            + "',business_state=N'" + txtState.Text.Replace("'", "`")
            + "',business_zip=N'" + txtZip.Text
            + "',business_country=N'" + lstCountry.Items[lstCountry.SelectedIndex].Text.Replace("'", "`")
            + "',b_country_code=N'" + lstCountry.SelectedValue
            + "',business_phone=N'" + txtPhone.Text
            + "',business_fax=N'" + txtFax.Text
            + "',owner_lname=N'" + txtLastName.Text.Replace("'", "`")
            + "',owner_fname=N'" + txtFirstName.Text.Replace("'", "`")
            + "',owner_mname=N'" + txtMidName.Text.Replace("'", "`")
            + "',owner_phone=N'" + txtCell.Text
            + "',owner_email=N'" + txtEmail.Text.Replace("'", "`")
            + "',business_fed_taxid=N'" + txtTaxID.Text
            + "',account_status='A',last_update=GETDATE()"
            + " WHERE elt_account_number=" + elt_account_number + " AND org_account_number=" + OrgID;

        if (!feData.DataTransactions(tranStr))
        {
            string errorStr = feData.GetLastTransactionError();
            string errorMsg = "Unexpected error occurred. " + errorStr;

            tableContent.Visible = false;
            txtResultBox.Text = errorMsg;
            txtResultBox.Visible = true;
            btnSave.Visible = false;
        }
        else
        {
            this.ClientScript.RegisterClientScriptBlock(this.GetType(), "close_window_return", "<script>close_window_return(" + OrgID + ",'" + txtDBA.Text + "');</script>");
        }
    }

    protected void btnSave_Click(object sender, ImageClickEventArgs e)
    {
        if (org_id == "")
        {
            AddNewConsignee();
        }
        else
        {
            UpdateConsignee(org_id);
        }
    }

    protected string FormatStringNumberOnly(string input)
    {
        string ouput = "";
        try
        {
            char[] tmpCharArray = input.ToCharArray();
            for (int i = 0; i < tmpCharArray.Length; i++)
            {
                if (Char.IsNumber(tmpCharArray[i]))
                {
                    ouput = ouput + tmpCharArray[i];
                }
            }
        }
        catch { }
        return ouput;
    }
}
