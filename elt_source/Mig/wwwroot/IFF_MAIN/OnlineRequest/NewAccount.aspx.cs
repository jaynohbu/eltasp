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
using System.Text;


public partial class OnlineRequest_NewAccount : System.Web.UI.Page
{
    protected int max_user = 3;
    protected string templateAcct = "10001000";

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!IsPostBack)
            {
            }
        }
        catch
        {
        }
    }

    protected void Page_Init(object sender, EventArgs e)
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        feData.AddToDataSet("Countries", "SELECT DISTINCT country_name,country_code FROM all_country_code ORDER BY country_name");

        ddCountry1.DataSource = feData.Tables["Countries"];
        ddCountry1.DataTextField = "country_name";
        ddCountry1.DataValueField = "country_code";
        ddCountry1.DataBind();
        ddCountry1.Items.Insert(0, new ListItem("", ""));

        ddCountry2.DataSource = feData.Tables["Countries"];
        ddCountry2.DataTextField = "country_name";
        ddCountry2.DataValueField = "country_code";
        ddCountry2.DataBind();
        ddCountry2.Items.Insert(0, new ListItem("", ""));
    }

    protected void chkSame_CheckedChanged(object sender, EventArgs e)
    {
        if (this.chkSame.Checked)
        {
            this.txtMailAddress.Text = this.txtAddress.Text;
            this.txtMailCity.Text = this.txtCity.Text;
            this.txtMailZip.Text = this.txtZip.Text;
            this.ddState2.SelectedIndex = this.ddState1.SelectedIndex;
            this.ddCountry2.SelectedIndex = this.ddCountry1.SelectedIndex;
            this.txtPhone.Text = this.txtBusPhone.Text;
        }
    }

    protected void btnCreate_Click(object sender, EventArgs e)
    {
        SqlConnection Con = null;
        string nextURL = "";
        try
        {
            string ConnectStr = (new igFunctions.DB().getConStr());
            Con = new SqlConnection(ConnectStr);
            SqlCommand Cmd = new SqlCommand();
            Cmd.Connection = Con;
            Con.Open();
            SqlTransaction trans = Con.BeginTransaction();
            Cmd.Transaction = trans;

            Hashtable applyInfo = new Hashtable();
            applyInfo.Add("dba_name", this.txtDBA.Text);
            applyInfo.Add("business_legal_name", this.txtLegalName.Text);
            applyInfo.Add("business_address", this.txtAddress.Text);
            applyInfo.Add("business_address_add", this.txtAddressAdd.Text);
            applyInfo.Add("business_city", this.txtCity.Text);
            applyInfo.Add("business_province", this.txtProvince.Text);
            applyInfo.Add("business_state", ddState1.SelectedItem.Value.ToString());
            applyInfo.Add("business_zip", this.txtZip.Text);
            applyInfo.Add("business_country", ddCountry1.SelectedItem.Value.ToString());
            applyInfo.Add("country_code", ddCountry1.SelectedItem.Value.ToString());
            applyInfo.Add("business_phone", this.txtBusPhone.Text);
            applyInfo.Add("business_fax", this.txtBusFax.Text);
            applyInfo.Add("business_url", this.txtURL.Text);
            applyInfo.Add("admin_pass", this.txtAdminPassword.Text);
            applyInfo.Add("admin_id", this.txtAdminID.Text);
            applyInfo.Add("owner_lname", this.txtLname.Text);
            applyInfo.Add("owner_fname", this.txtFName.Text);
            applyInfo.Add("owner_mail_address", this.txtMailAddress.Text);
            applyInfo.Add("owner_mail_city", this.txtMailCity.Text);
            applyInfo.Add("owner_mail_state", this.ddState2.SelectedItem.Value.ToString());
            applyInfo.Add("owner_mail_zip", this.txtMailZip.Text);
            applyInfo.Add("owner_mail_country", this.ddCountry2.SelectedItem.Value.ToString());
            applyInfo.Add("owner_phone", this.txtPhone.Text);
            applyInfo.Add("owner_email", this.txtEmail.Text);
            applyInfo.Add("account_type", this.rlAcType.SelectedItem.Value.ToString());

            try
            {
                string payment_id = "";
                string request_id = "";

                if (this.rlAcType.SelectedItem.Value.ToString() == "A")
                {
                    string pay_fee = "1.60";
                    string pay_desc = "Premium FreightFowarder Subscription";

                    Cmd.CommandText = "INSERT INTO payment_due(create_date,pmt_amount,"
                        + "pmt_desc,pmt_status) VALUES(GETDATE(),"
                        + pay_fee + ",'" + pay_desc + "','N') ";
                    Cmd.ExecuteNonQuery();
                    
                    Cmd.CommandText = "SELECT IDENT_CURRENT('payment_due') AS payment_id";
                    SqlDataReader reader = Cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        payment_id = reader["payment_id"].ToString();
                    }
                    reader.Close();
                    applyInfo.Add("payment_id", payment_id);
                    nextURL = "./credit_card.asp?pid=" + payment_id;

                    Cmd.CommandText = HashTableSQL(applyInfo, "account_request");
                    Cmd.ExecuteNonQuery();
                }

                else
                {
                    Cmd.CommandText = HashTableSQL(applyInfo, "account_request");
                    Cmd.ExecuteNonQuery();

                    Cmd.CommandText = "SELECT IDENT_CURRENT('account_request') AS request_id";
                    SqlDataReader reader = Cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        request_id = reader["request_id"].ToString();
                    }
                    reader.Close();
                    nextURL = "./NewAccountCreate.aspx?rid=" + request_id;
                }

                trans.Commit();
                Con.Close();
            }
            catch (Exception ex)
            {
                lblMessage.Text = ex.ToString();
                lblMessage.Visible = true;
                trans.Rollback();
            }
            finally { if (Con != null) { Con.Close(); } }
        }

        catch (Exception ex)
        {
            lblMessage.Text = ex.ToString();
            lblMessage.Visible = true;
        }
        finally { if (Con != null) { Con.Close(); } }

        if (nextURL != "")
        {
            Response.Redirect(nextURL);
        }
    }


    public string HashTableSQL(Hashtable ht, string tableName)
    {
        StringBuilder s1 = new StringBuilder();
        StringBuilder s2 = new StringBuilder();

        IDictionaryEnumerator enumInterface = ht.GetEnumerator();
        bool first = true;
        while (enumInterface.MoveNext())
        {
            if (first)
            {
                s2.Append("'");
                first = false;
            }
            else
            {
                s1.Append(",");
                s2.Append("','");
            }
            s1.Append(enumInterface.Key.ToString());
            s2.Append(enumInterface.Value.ToString());
        }
        s2.Append("'");

        return "INSERT INTO " + tableName + " (" + s1 + ") VALUES (" + s2 + ");";
    }
}
