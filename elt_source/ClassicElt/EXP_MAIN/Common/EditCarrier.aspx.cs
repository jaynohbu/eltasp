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

public partial class Common_EditCarrier : System.Web.UI.Page
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
        feData.AddToDataSet("CInfo", "SELECT * FROM carrier_master WHERE elt_account_number=" + elt_account_number + " AND auto_uid=" + hCID.Value);

        if (feData.Tables["CInfo"].Rows.Count > 0)
        {
            DataRow drOrg = feData.Tables["CInfo"].Rows[0];
            txtCarrierName.Text = drOrg["carrier_name"].ToString();
            txtCarrierCode.Text = drOrg["carrier_code"].ToString();
            lstCarrierType.SelectedValue = drOrg["tran_type"].ToString();
            lstCodeType.SelectedValue = drOrg["carrier_code_type"].ToString();
        }
    }

    protected void Page_Init(object sender, EventArgs e)
    {
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
        string cid = Request.Params["CID"].ToString();

        if (cid == "")
        {
            labelTitle.Text = "ADD NEW CARRIER";
            try
            {
                txtCarrierName.Text = Request.Params["FCNAME"].ToString();
                txtCarrierCode.Text = Request.Params["FCID"].ToString();
                lstCodeType.SelectedValue = Request.Params["FCTYPE"].ToString();
                if (lstCodeType.SelectedValue == "IATA")
                {
                    lstCarrierType.SelectedValue = "Airline";
                }
            }
            catch { }
        }
        else
        {
            labelTitle.Text = "EDIT CARRIER";
            hCID.Value = cid;
        }

        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();

    }
    protected void btnSave_Click(object sender, ImageClickEventArgs e)
    {
        if (hCID.Value == "")
        {
            AddNewCarrier();
        }
        else
        {
            UpdateCarrier();
        }
    }

    protected void AddNewCarrier()
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        string[] tranStr = new string[1];

        tranStr[0] = "INSERT INTO carrier_master(elt_account_number,carrier_name,carrier_code_type,carrier_code,tran_type)\n";
        tranStr[0] += "VALUES(" + elt_account_number + ",N'" + txtCarrierName.Text + "',N'" + lstCodeType.SelectedValue + "',N'" + txtCarrierCode.Text + "',N'" + lstCarrierType.SelectedValue + "')";

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

    protected void UpdateCarrier()
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        string[] tranStr = new string[1];

        tranStr[0] = "UPDATE carrier_master SET "
            + " carrier_name=N'" + txtCarrierName.Text
            + "',carrier_code_type=N'" + lstCodeType.SelectedValue
            + "',carrier_code=N'" + txtCarrierCode.Text
            + "',tran_type=N'" + lstCarrierType.SelectedValue
            + "' WHERE elt_account_number=" + elt_account_number + " AND auto_uid=" + hCID.Value ;

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
}
