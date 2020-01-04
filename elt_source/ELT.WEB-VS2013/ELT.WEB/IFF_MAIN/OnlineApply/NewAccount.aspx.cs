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

public partial class SystemAdmin_NewAccount : System.Web.UI.Page
{
    private string ConnectStr = null;
    private bool is_invalid = false;
    private string access_mode = "";
    protected int max_user = 3;
    protected string templateAcct = "10001000";

    private string[] states = {"AK", "AL", "AR" , "AZ", "CA" , "CO", "CT", "DC", "DE", "FL", 
        "GA", "HI", "IA", "ID", "IL", "IN", "KS", "KY", "LA", "MA", "MD", "ME", "MI", "MN", 
        "MO", "MS", "MT", "NC", "ND", "NE", "NH", "NJ", "NM", "NV", "NY", "OH", "OK", "OR", 
        "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VA", "VT", "WA", "WI", "WV", "WY"};

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            ConnectStr = (new igFunctions.DB().getConStr());
            Get_Parameters();

            if (!IsPostBack)
            {
                Initialize_Form();
            }
        }
        catch
        {
        }
    }

    protected void Get_Parameters()
    {
        access_mode = Request.Params.Get("mode").ToString();

        if (access_mode.Equals("Guest"))
        {
            if (!Validate_Guest())
            {
                Response.Write("<script>alert('The email and password for your login cannot be found!'); window.location.href=\"/IFF_MAIN/Authentication/SetupLogin.aspx?err=yes\";</script>");
            }
        }
    }

    protected bool Validate_Guest()
    {
        bool returnVal = false;
        try
        {
            if (checkSetupSession(Session["sid"].ToString(), Session["semail"].ToString(), Session["spassword"].ToString()))
            {
                returnVal = true;
            }
        }
        catch
        {
            returnVal = false;
        }
        return returnVal;
    }


    protected void Initialize_Form()
    {
        this.ddState1.DataSource = states;
        this.ddState1.DataBind();
        this.ddState2.DataSource = states;
        this.ddState2.DataBind();
        this.ddState1.SelectedValue = "CA";
        this.ddState2.SelectedValue = "CA";
        this.ddCountry1.SelectedValue = "UNITED STATES";
        this.ddCountry2.SelectedValue = "UNITED STATES";
        Get_Contries();
        txtNewAccNo.Text = suggestELTAccount();

        if (access_mode == "Guest")
        {
            rlAcType.Enabled = true;
            chkIsIntl.Enabled = false;
            chkIsDome.Enabled = false;
            chkIsCart.Enabled = false;
            chkIsWare.Enabled = false;
            chkIsAcct.Enabled = false;
            rlAcType.SelectedValue = "F";
            txtEmail.Text = Session["semail"].ToString();
        }
    }

    protected void Get_Contries()
    {
        try
        {
            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand Cmd = new SqlCommand();
            SqlDataReader reader;

            Cmd.Connection = Con;
            Cmd.CommandText = "SELECT [country_name], [country_code] FROM [dbo].[all_country_code] order by [country_name]";

            Con.Open();

            int index = 0;
            reader = Cmd.ExecuteReader();

            while (reader.Read())
            {
                this.ddCountry1.Items.Add(reader["country_name"].ToString());
                this.ddCountry1.Items[index].Value = reader["country_code"].ToString();

                this.ddCountry2.Items.Add(reader["country_name"].ToString());
                this.ddCountry2.Items[index].Value = reader["country_code"].ToString();
                index++;
            }
            this.ddCountry1.SelectedIndex = 224;
            this.ddCountry2.SelectedIndex = 224;
            reader.Close();
            Con.Close();

        }
        catch { }
    }

    protected void btnCreate_Click(object sender, EventArgs e)
    {
        if (is_invalid)
        {
            return;
        }

        SqlConnection Con = null;
        try
        {
            Con = new SqlConnection(ConnectStr);
            SqlCommand Cmd = new SqlCommand();
            Cmd.Connection = Con;
            Con.Open();
            SqlTransaction trans = Con.BeginTransaction();
            Cmd.Transaction = trans;

            string dba_name, business_legal_name, business_address, business_city, business_state;
            string business_zip, business_country, country_code, business_phone, business_fax, business_url;
            string owner_lname, owner_fname, owner_mail_address, owner_mail_city, owner_mail_state;
            string owner_mail_zip, owner_mail_country, owner_phone, owner_email, account_statue, board_name;
            string is_intl, is_dome, is_cartage, is_warehouse, is_accounting;
            int elt_account_number;

            if (txtNewAccNo.Text.Length == 8)
            {
                elt_account_number = Int32.Parse(this.txtNewAccNo.Text);
            }
            else
            {
                this.lblMessage.Text = "Invalid ELT account number!";
                return;
            }

            if (!this.checkExistingAgent(elt_account_number))
            {
                dba_name = this.txtDBA.Text;
                business_legal_name = this.txtLegalName.Text;
                business_address = this.txtAddress.Text;
                business_city = this.txtCity.Text;
                business_state = ddState1.SelectedItem.Value.ToString();
                business_zip = this.txtZip.Text;
                business_country = ddCountry1.SelectedItem.Value.ToString();
                country_code = ddCountry1.SelectedItem.Value.ToString();
                business_phone = this.txtBusPhone.Text;
                business_fax = this.txtBusFax.Text;
                business_url = this.txtURL.Text;
                owner_lname = this.txtLname.Text;
                owner_fname = this.txtFName.Text;
                owner_mail_address = this.txtMailAddress.Text;
                owner_mail_city = this.txtMailCity.Text;
                owner_mail_state = this.ddState2.SelectedItem.Value.ToString();
                owner_mail_zip = this.txtMailZip.Text;
                owner_mail_country = this.ddCountry2.SelectedItem.Value.ToString();
                owner_phone = this.txtPhone.Text;
                owner_email = this.txtEmail.Text;
                account_statue = this.rlAcType.SelectedItem.Value.ToString();
                if (chkIsIntl.Checked) { is_intl = "Y"; } else { is_intl = "N"; }
                if (chkIsDome.Checked) { is_dome = "Y"; } else { is_dome = "N"; }
                if (chkIsCart.Checked) { is_cartage = "Y"; } else { is_cartage = "N"; }
                if (chkIsWare.Checked) { is_warehouse = "Y"; } else { is_warehouse = "N"; }
                if (chkIsAcct.Checked) { is_accounting = "Y"; } else { is_accounting = "N"; }

                board_name = elt_account_number + "_board";

                try
                {
                    Cmd.CommandText = @"INSERT INTO [agent]([elt_account_number],[dba_name],[business_legal_name],
                        [business_address],[business_city], [business_state],[business_zip],[business_country],
                        [country_code],[business_phone],[business_fax],[business_url],[owner_lname],[owner_fname],
                        [owner_mail_address],[owner_mail_city],[owner_mail_state],[owner_mail_zip],
                        [owner_mail_country],[owner_phone],[owner_email],[account_statue],[is_intl],[is_dome],
                        [is_cartage],[is_warehouse],[is_accounting],[maxuser]) VALUES("
                            + elt_account_number + ",'" + dba_name + "','" + business_legal_name
                            + "','" + business_address + "','" + business_city + "','" + business_state
                            + "','" + business_zip + "','" + business_country + "','" + country_code
                            + "','" + business_phone + "','" + business_fax + "','" + business_url
                            + "','" + owner_lname + "','" + owner_fname + "','" + owner_mail_address
                            + "','" + owner_mail_city + "','" + owner_mail_state + "','" + owner_mail_zip
                            + "','" + owner_mail_country + "','" + owner_phone + "','" + owner_email
                            + "','" + account_statue + "','" + is_intl + "','" + is_dome + "','"
                            + is_cartage + "','" + is_warehouse + "','" + is_accounting + "'," + max_user + ")";
                    string err = Cmd.ExecuteNonQuery().ToString();

                    Cmd.CommandText = @" INSERT INTO [users]([elt_account_number],[userid],[user_type],[user_right],
                        [login_name],[password],[user_lname],[user_fname],[user_address],[user_city],[user_state],
                        [user_zip],[user_country],[user_phone],[user_email]) VALUES("
                            + elt_account_number + "," + 1000 + "," + 9 + "," + 9 + ",'" + "admin"
                            + "'," + "NULL" + ",'" + owner_lname + "','" + owner_fname + "','"
                            + owner_mail_address + "','" + owner_mail_city + "','" + owner_mail_state
                            + "','" + owner_mail_zip + "','" + owner_mail_country + "','" + owner_phone
                            + "','" + owner_email + "')";

                    err = Cmd.ExecuteNonQuery().ToString();

                    // Add All Country 
                    Cmd.CommandText = "If NOT EXISTS (SELECT * FROM country_code WHERE elt_account_number=" + elt_account_number
                        + ") INSERT INTO country_code SELECT " + elt_account_number + ",country_name,country_code FROM all_country_code";

                    err = Cmd.ExecuteNonQuery().ToString();

                    // make charge item template
                    Cmd.CommandText = "If NOT EXISTS (SELECT * FROM item_charge WHERE elt_account_number=" + elt_account_number
                        + ") INSERT INTO item_charge (elt_account_number, item_no, item_name, item_type, item_desc, unit_price, account_revenue) SELECT "
                        + elt_account_number + ", item_no, item_name, item_type, item_desc, 0, account_revenue FROM item_charge AS item_charge_copy WHERE elt_account_number=" + templateAcct;

                    err = Cmd.ExecuteNonQuery().ToString();

                    // make cost item template
                    Cmd.CommandText = "If NOT EXISTS (SELECT * FROM item_cost WHERE elt_account_number=" + elt_account_number
                        + ") INSERT INTO item_cost (elt_account_number, item_no, item_name, item_type, item_desc, unit_price, account_expense) SELECT "
                        + elt_account_number + ", item_no, item_name, item_type, item_desc, 0, account_expense FROM item_cost AS item_cost_copy WHERE elt_account_number=" + templateAcct;

                    err = Cmd.ExecuteNonQuery().ToString();

                    // make GL template
                    Cmd.CommandText = "If NOT EXISTS (SELECT * FROM gl WHERE elt_account_number=" + elt_account_number
                        + ") INSERT INTO gl (elt_account_number, gl_account_number, gl_account_desc, gl_master_type, gl_account_type, gl_account_balance, gl_begin_balance, gl_account_status, gl_account_cdate, gl_last_modified) SELECT "
                        + elt_account_number + ", gl_account_number, gl_account_desc, gl_master_type, gl_account_type, 0, 0, 'A', getdate(), getdate() FROM gl AS gl_copy WHERE elt_account_number=" + templateAcct;

                    err = Cmd.ExecuteNonQuery().ToString();

                    // make prefix template
                    Cmd.CommandText = "If Not EXISTS (SELECT * FROM user_prefix WHERE elt_account_number=" + elt_account_number
                        + ") INSERT INTO user_prefix (elt_account_number, prefix, type, next_no, [desc]) SELECT " + elt_account_number
                        + ", prefix, type, next_no, [desc] FROM user_prefix AS user_prefix_copy WHERE elt_account_number=" + templateAcct;

                    err = Cmd.ExecuteNonQuery().ToString();

                    // update setup session (EmailItemID)
                    Cmd.CommandText = "UPDATE setup_session SET elt_account_number=" + elt_account_number
                        + " WHERE sid='" + Session["sid"].ToString()
                        + "' AND email='" + Session["semail"].ToString()
                        + "' AND password='" + Session["spassword"].ToString()
                        + "' AND elt_account_number IS NULL AND page_id IS NULL";

                    err = Cmd.ExecuteNonQuery().ToString();

                    if (account_statue == "A")
                    {
                        string pay_fee = "1.99";
                        string pay_desc = "Premium Subscription";

                        Cmd.CommandText = "INSERT INTO payment_due(elt_account_number,create_date,pmt_amount,"
                            + "pmt_desc,pmt_status) VALUES(" + elt_account_number + ",GETDATE(),"
                            + pay_fee + ",'" + pay_desc + "','N') ";

                        err = Cmd.ExecuteNonQuery().ToString();

                        string payment_id = "";
                        Cmd.CommandText = "SELECT IDENT_CURRENT('payment_due') AS payment_id";
                        SqlDataReader reader = Cmd.ExecuteReader();
                        if (reader.Read())
                        {
                            payment_id = reader["payment_id"].ToString();
                        }
                        reader.Close();

                        Cmd.CommandText = "UPDATE setup_session SET payment_id=" + payment_id
                            + " WHERE sid='" + Session["sid"].ToString()
                            + "' AND email='" + Session["semail"].ToString()
                            + "' AND password='" + Session["spassword"].ToString()
                            + "' AND elt_account_number=" + elt_account_number + " AND page_id IS NULL";

                        err = Cmd.ExecuteNonQuery().ToString();
                    }

                    trans.Commit();
                    Con.Close();

                    Session["sELTAcct"] = elt_account_number;
                }
                catch (Exception ex)
                {
                    string err = ex.ToString();
                    this.lblMessage.Text = err;
                    trans.Rollback();
                    if (Con != null) { Con.Close(); }
                }
            }
        }
        catch { }
        finally { if (Con != null) { Con.Close(); } }

        checkSetupSession(Session["sid"].ToString(), Session["semail"].ToString(), Session["spassword"].ToString());
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

    private bool checkExistingAgent(int agentId)
    {
        SqlConnection Con = new SqlConnection(ConnectStr);
        SqlCommand Cmd = new SqlCommand();
        Cmd.Connection = Con;
        SqlDataReader reader;

        Cmd.CommandText = "SELECT [elt_account_number ] FROM [agent] Where elt_account_number = " + agentId;

        try
        {
            Con.Open();

            reader = Cmd.ExecuteReader();

            if (reader.Read())
            {
                Con.Close();
                return true;
            }
        }
        catch (Exception ex)
        {
            Response.Write("<script language='javascript'>alert('" + ex.ToString() + "')</script>");
        }
        Con.Close();
        return false;
    }

    private bool checkSetupSession(string sid, string semail, string spassword)
    {
        SqlConnection Con = new SqlConnection(ConnectStr);
        SqlCommand Cmd = new SqlCommand();
        Cmd.Connection = Con;
        SqlDataReader reader;
        bool returnValue = false;
        string eltAcct = "";

        Cmd.CommandText = "SELECT elt_account_number FROM setup_session WHERE "
            + "sid='" + sid + "' AND email='" + semail + "' AND password='" + spassword + "'";
        try
        {
            Con.Open();
            reader = Cmd.ExecuteReader();

            if (reader.Read())
            {
                returnValue = true;
                if (reader["elt_account_number"].ToString() != "")
                {
                    Session["sELTAcct"] = reader["elt_account_number"].ToString();
                    Response.Write("<script>window.location.href=\"./CreateAdmin.aspx\";</script>");
                }
            }
        }
        catch
        {
        }
        finally
        {
            Con.Close();
        }

        return returnValue;
    }

    protected string suggestELTAccount()
    {
        SqlConnection Con = new SqlConnection(ConnectStr);
        SqlCommand Cmd = new SqlCommand();
        Cmd.Connection = Con;
        SqlDataReader reader;
        string resVal = "";

        Cmd.CommandText = @"DECLARE @testVal INT
                            SET @testVal=CAST(Round(((99999-10000-1) * Rand() + 10000), 0) AS INT) * 1000
                            IF NOT EXISTS (SELECT * FROM agent WHERE elt_account_number=@testVal)
                                SELECT @testVal
                            ELSE
                                SELECT ''";
        try
        {
            Con.Open();
            reader = Cmd.ExecuteReader();

            if (reader.Read())
            {
                resVal = reader[0].ToString();
                Con.Close();

                if (resVal == "")
                {
                    Con.Close();
                    // Recursively calls itself
                    resVal = suggestELTAccount();
                }
            }
        }
        catch
        {
        }
        return resVal;
    }

    protected void rfvNewAccountType_ServerValidate(object source, ServerValidateEventArgs args)
    {
        args.IsValid = chkIsIntl.Checked;
        is_invalid = !(chkIsIntl.Checked);
    }
}
