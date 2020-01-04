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
using System.Drawing;

public partial class Ports_EditPort : System.Web.UI.Page
{
    protected string ConnectStr, user_id, login_name, user_right, elt_account_number, port_code;

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            Session.LCID = 1033;
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

        labelTitle.Text = "ADD NEW PORT";
        try
        {
            txtIATACode.Text = Request.Params["FPCOD"];
            txtAESCode.Text = Request.Params["FPID"];
            txtPortDesc.Text = Request.Params["FPDESC"];
        }
        catch { }
        
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        feData.AddToDataSet("Countries", "SELECT * FROM country_code WHERE elt_account_number=" + elt_account_number + " ORDER BY country_name");

        lstPortCountry.DataSource = feData.Tables["Countries"];
        lstPortCountry.DataTextField = "country_name";
        lstPortCountry.DataValueField = "country_code";
        lstPortCountry.DataBind();
        lstPortCountry.Items.Insert(0, new ListItem("", ""));

        lstPortCountry.SelectedValue = Request.Params["COUNTRY"];
    }

    protected void btnSave_Click(object sender, ImageClickEventArgs e)
    {
        AddNewPort();
    }

    protected void AddNewPort()
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        string[] tranStr = new string[1];

        tranStr[0] = "INSERT INTO port(elt_account_number,port_code,port_id,port_desc,port_city,port_state,port_country,port_country_code)\n";
        tranStr[0] += "VALUES(" + elt_account_number + ",N'" + txtIATACode.Text + "',N'" + txtAESCode.Text + "',N'" + txtPortDesc.Text + "',N'"
            + txtPortCity.Text + "',N'" + lstPortState.SelectedValue + "',N'" + lstPortCountry.Items[lstPortCountry.SelectedIndex].Text + "',N'" + lstPortCountry.SelectedValue + "')";

        if (!feData.DataTransactions(tranStr))
        {
            string errorStr = feData.GetLastTransactionError();
            string errorMsg = "";
            if (errorStr.Contains("Cannot insert duplicate key in object"))
            {
                errorMsg = "Port exists alreay. Cannot be inserted.";
            }
            else
            {
                errorMsg = "Unexpected error occurred: " + errorStr;
            }
            // tableContent.Visible = false;
            txtResultBox.Text = errorMsg;
            txtResultBox.Visible = true;
            // btnSave.Visible = false;
        }
        else
        {
            this.ClientScript.RegisterClientScriptBlock(this.GetType(), "close_window_return", "<script>close_window_return(" + 0 + ",'');</script>");
        }
    }
}
