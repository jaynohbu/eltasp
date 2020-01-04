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

public partial class SiteAdmin_CompanyInformation : System.Web.UI.Page
{
    protected string ConnectStr, user_id, login_name, user_right, elt_account_number;

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            Session.LCID = 1033;
            ConnectStr = (new igFunctions.DB().getConStr());

            if (!IsPostBack)
            {
                LoadAllData();
            }
        }
        catch
        {
        }
    }

    protected void Page_Init(object sender, EventArgs e)
    {
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
    }

    protected void LoadAllData()
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        feData.AddToDataSet("CompanyInfo", "SELECT * FROM agent WHERE elt_account_number=" + elt_account_number);

        if (feData.Tables["CompanyInfo"].Rows.Count > 0)
        {
            DataRow drCompany = feData.Tables["CompanyInfo"].Rows[0];

            txtDBA.Text = drCompany["dba_name"].ToString();
            txtLegalName.Text = drCompany["business_legal_name"].ToString();
            txtTaxID.Text = drCompany["business_fed_taxid"].ToString();
            txtUSPPI.Text = drCompany["usppi"].ToString();
            txtAddress.Text = drCompany["business_address"].ToString();
            txtCity.Text = drCompany["business_city"].ToString();
            lstState.SelectedValue = drCompany["business_state"].ToString();
            txtZip.Text = drCompany["business_zip"].ToString();
            txtCompanyPhone.Text = drCompany["business_phone"].ToString();
            txtCompanyFax.Text = drCompany["business_fax"].ToString();
            txtCompanyURL.Text = drCompany["business_url"].ToString();
        }
    }

    protected void UpdateCompanyInfo()
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        string[] tranStr = new string[1];

        tranStr[0] = "UPDATE agent SET dba_name=N'" + txtDBA.Text
            + "',business_legal_name=N'" + txtLegalName.Text
            + "',business_fed_taxid=N'" + txtTaxID.Text
            + "',usppi=N'" + txtUSPPI.Text
            + "',business_address=N'" + txtAddress.Text
            + "',business_city=N'" + txtCity.Text
            + "',business_state=N'" + lstState.SelectedValue
            + "',business_zip=N'" + txtZip.Text
            + "',business_phone=N'" + txtCompanyPhone.Text
            + "',business_fax=N'" + txtCompanyFax.Text
            + "',business_url=N'" + txtCompanyURL.Text
            + "' WHERE elt_account_number=" + elt_account_number;

        if (!feData.DataTransactions(tranStr))
        {
            Response.Write(feData.GetLastTransactionError());
        }
        else
        {
            Response.Redirect("CompanyInformation.aspx");
        }
    }

    protected void btnSave_Click(object sender, ImageClickEventArgs e)
    {
        UpdateCompanyInfo();
    }
}
