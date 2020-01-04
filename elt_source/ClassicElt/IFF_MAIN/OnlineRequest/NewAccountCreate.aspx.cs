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
using System.Net.Mail;

public partial class OnlineRequest_NewAccountCreate : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!IsPostBack)
            {
                CreateAccount();
                SendCompeletionMail();
            }
        }
        catch (Exception ex)
        {
            Response.Write(ex.Message);
        }
    }

    protected void Page_Init(object sender, EventArgs e)
    {
        this.hRequestID.Value = Request.Params["rid"];
        this.hTranID.Value = Request.Params["tid"];
    }


    protected void CreateAccount()
    {
        string elt_account_number = suggestELTAccount();
        string templateAcct = "10001000";
        int max_user = 3;

        string dba_name, business_legal_name, business_address, business_city, business_state;
        string business_zip, business_country, country_code, business_phone, business_fax, business_url;
        string owner_lname, owner_fname, owner_mail_address, owner_mail_city, owner_mail_state;
        string owner_mail_zip, owner_mail_country, owner_phone, owner_email, account_type, board_name;
        string is_intl, is_dome, is_cartage, is_warehouse, is_accounting, is_aes;
        string admin_id, admin_pass, business_address_add, business_province;

        SqlConnection Con = null;
        try
        {
            if (hRequestID.Value != "")
            {
                FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
                feData.AddToDataSet("RequestInfo", "SELECT * FROM account_request WHERE auto_uid=" + hRequestID.Value);

                if (feData.Tables["RequestInfo"].Rows.Count == 0)
                {
                    return;
                }
                
                DataRow dr = feData.Tables["RequestInfo"].Rows[0];

                string ConnectStr = (new igFunctions.DB().getConStr());
                Con = new SqlConnection(ConnectStr);
                SqlCommand Cmd = new SqlCommand();
                Cmd.Connection = Con;
                Con.Open();
                SqlTransaction trans = Con.BeginTransaction();
                Cmd.Transaction = trans;

                dba_name = dr["dba_name"].ToString();
                business_legal_name = dr["business_legal_name"].ToString();
                business_address = dr["business_address"].ToString();
                business_address_add = dr["business_address_add"].ToString();
                business_city = dr["business_city"].ToString();
                business_province = dr["business_province"].ToString();
                business_state = dr["business_state"].ToString();
                business_zip = dr["business_zip"].ToString();
                business_country = dr["business_country"].ToString();
                country_code = dr["country_code"].ToString();
                business_phone = dr["business_phone"].ToString();
                business_fax = dr["business_fax"].ToString();
                business_url = dr["business_url"].ToString();
                owner_lname = dr["owner_lname"].ToString();
                owner_fname = dr["owner_fname"].ToString();
                owner_mail_address = dr["owner_mail_address"].ToString();
                owner_mail_city = dr["owner_mail_city"].ToString();
                owner_mail_state = dr["owner_mail_state"].ToString();
                owner_mail_zip = dr["owner_mail_zip"].ToString();
                owner_mail_country = dr["owner_mail_country"].ToString();
                owner_phone = dr["owner_phone"].ToString();
                owner_email = dr["owner_email"].ToString();
                account_type = dr["account_type"].ToString();
                admin_id = dr["admin_id"].ToString();
                admin_pass = dr["admin_pass"].ToString();

                is_intl = "Y";
                is_dome = "N";
                is_cartage = "N";
                is_warehouse = "Y";
                is_accounting = "Y";
				is_aes = "N";

                try
                {
                    Cmd.CommandText = @"INSERT INTO [agent]([elt_account_number],[dba_name],[business_legal_name],
                    [business_address],[business_address_add],[business_city],[business_province],[business_state],[business_zip],[business_country],
                    [country_code],[business_phone],[business_fax],[business_url],[owner_lname],[owner_fname],
                    [owner_mail_address],[owner_mail_city],[owner_mail_state],[owner_mail_zip],
                    [owner_mail_country],[owner_phone],[owner_email],[account_statue],[is_intl],[is_dome],
                    [is_cartage],[is_warehouse],[is_accounting],[is_aes],[maxuser],[date_opened]) VALUES("
                            + elt_account_number + ",N'" + dba_name + "',N'" + business_legal_name
                            + "',N'" + business_address + "',N'" + business_address_add
                            + "',N'" + business_city + "',N'" + business_province + "',N'" + business_state
                            + "',N'" + business_zip + "',N'" + business_country + "',N'" + country_code
                            + "',N'" + business_phone + "',N'" + business_fax + "',N'" + business_url
                            + "',N'" + owner_lname + "',N'" + owner_fname + "',N'" + owner_mail_address
                            + "',N'" + owner_mail_city + "',N'" + owner_mail_state + "',N'" + owner_mail_zip
                            + "',N'" + owner_mail_country + "',N'" + owner_phone + "',N'" + owner_email
                            + "',N'" + account_type + "',N'" + is_intl + "',N'" + is_dome + "',N'"
                            + is_cartage + "',N'" + is_warehouse + "',N'" + is_accounting + "',N'" + is_aes 
                            + "'," + max_user + ",GETDATE())";
                    
                    Cmd.ExecuteNonQuery().ToString();

                    Cmd.CommandText = @" INSERT INTO [users]([elt_account_number],[userid],[user_type],[user_right],
                    [login_name],[password],[user_lname],[user_fname],[user_address],[user_city],[user_state],
                    [user_zip],[user_country],[user_phone],[user_email]) VALUES("
                            + elt_account_number + "," + 1000 + "," + 9 + "," + 9 + ",'" + admin_id
                            + "','" + admin_pass + "','" + owner_lname + "','" + owner_fname + "','"
                            + owner_mail_address + "','" + owner_mail_city + "','" + owner_mail_state
                            + "','" + owner_mail_zip + "','" + owner_mail_country + "','" + owner_phone
                            + "','" + owner_email + "')";

                    Cmd.ExecuteNonQuery().ToString();

                    // Add All Country 
                    Cmd.CommandText = "If NOT EXISTS (SELECT * FROM country_code WHERE elt_account_number=" + elt_account_number
                        + ") INSERT INTO country_code SELECT " + elt_account_number + ",country_name,country_code FROM all_country_code";

                    Cmd.ExecuteNonQuery().ToString();

                    // make charge item template
                    Cmd.CommandText = "If NOT EXISTS (SELECT * FROM item_charge WHERE elt_account_number=" + elt_account_number
                        + ") INSERT INTO item_charge (elt_account_number, item_no, item_name, item_type, item_desc, unit_price, account_revenue) SELECT "
                        + elt_account_number + ", item_no, item_name, item_type, item_desc, 0, account_revenue FROM item_charge AS item_charge_copy WHERE elt_account_number=" + templateAcct;

                    Cmd.ExecuteNonQuery().ToString();

                    // make cost item template
                    Cmd.CommandText = "If NOT EXISTS (SELECT * FROM item_cost WHERE elt_account_number=" + elt_account_number
                        + ") INSERT INTO item_cost (elt_account_number, item_no, item_name, item_type, item_desc, unit_price, account_expense) SELECT "
                        + elt_account_number + ", item_no, item_name, item_type, item_desc, 0, account_expense FROM item_cost AS item_cost_copy WHERE elt_account_number=" + templateAcct;

                    Cmd.ExecuteNonQuery().ToString();

                    // make GL template
                    Cmd.CommandText = "If NOT EXISTS (SELECT * FROM gl WHERE elt_account_number=" + elt_account_number
                        + ") INSERT INTO gl (elt_account_number, gl_account_number, gl_account_desc, gl_master_type, gl_account_type, gl_account_balance, gl_begin_balance, gl_account_status, gl_account_cdate, gl_last_modified) SELECT "
                        + elt_account_number + ", gl_account_number, gl_account_desc, gl_master_type, gl_account_type, 0, 0, 'A', getdate(), getdate() FROM gl AS gl_copy WHERE elt_account_number=" + templateAcct;

                    Cmd.ExecuteNonQuery().ToString();

                    // make prefix template
                    Cmd.CommandText = "If Not EXISTS (SELECT * FROM user_prefix WHERE elt_account_number=" + elt_account_number
                        + ") INSERT INTO user_prefix (elt_account_number, prefix, type, next_no, [desc]) SELECT " + elt_account_number
                        + ", prefix, type, next_no, [desc] FROM user_prefix AS user_prefix_copy WHERE elt_account_number=" + templateAcct;

                    Cmd.ExecuteNonQuery().ToString();


                    // Delete Payment
                    if (hTranID.Value != "" && dr["payment_id"].ToString() != "")
                    {
                        Cmd.CommandText = "DELETE FROM payment_due WHERE auto_uid=" + dr["payment_id"].ToString()
                            + " AND tran_id=N'" + hTranID.Value + "'";
                        
                        Cmd.ExecuteNonQuery().ToString();
                    }

                    // Delete Account Request
                    Cmd.CommandText = "DELETE FROM account_request WHERE auto_uid=" + hRequestID.Value;

                    Cmd.ExecuteNonQuery().ToString();

                    // Insert Setup Session

                    Cmd.CommandText = @"BEGIN DECLARE @page_id INT
                        SET @page_id=(select TOP 1 page_id from setup_master ORDER BY seq_id)
                        INSERT INTO setup_session(sid,created_date,updated_date,elt_account_number,page_id) VALUES (NEWID(),GETDATE(),GETDATE()," + elt_account_number + ",@page_id) END";

                    Cmd.ExecuteNonQuery().ToString();

                    trans.Commit();
                    Con.Close();

                    hELTAcct.Value = elt_account_number;
                    hAdminID.Value = admin_id;
                    hAdminPass.Value = admin_pass;
                    lblELTAcct.Text = elt_account_number;
                    lblAdminID.Text = admin_id;
                    lblAdminPass.Text = admin_pass;
                    lblEmailAddress.Text = owner_email;
                }
                catch (Exception ex){
                    Response.Write(ex.Message);
                    trans.Rollback();
                }
                finally { if (Con != null) { Con.Close(); } }
            }
        }
        catch (Exception ex){
            Response.Write(ex.Message);
        }
        finally { if (Con != null) { Con.Close(); } }
    }

    protected string suggestELTAccount()
    {
        string ConnectStr = (new igFunctions.DB().getConStr());
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

    protected void SendCompeletionMail()
    {
        string body = @"
                <html>
                <head>
                <title>FreightEasy Account Creation Completed</title>
                <style type='text/css'>
	                .style3 {	
		                font-family: Verdana, Arial, Helvetica, sans-serif;	
		                font-size: 9px;}
                </style>
                </head>
                <body>
                <p class='style3'><strong>FreightEasy Account Creation Completed</strong></p>
                <p />
                <table class='style3' width='100%' border='0' cellspacing='0' cellpadding='0'>
                <tr>
                <td colspan='2'>
                    <div>You have successfully created a new FreightEasy account with following login information.<div><br/>
                    <table cellpadding=0 cellspacing=0 border=0 class='style3'>
                        <tr>
                            <td>
                                ELT Account No.</td>
                            <td style='width:5px'></td>
                            <td>
                               " + hELTAcct.Value + @"</td>
                        </tr>
                        <tr>
                            <td>
                                User Name</td>
                            <td style='width:5px'></td>
                            <td>
                                " + hAdminID.Value + @"</td>
                        </tr>
                        <tr>
                            <td>
                                Password</td>
                            <td style='width:5px'></td>
                            <td>
                                " + hAdminPass.Value + @"</td>
                        </tr>
                    </table>
                </td>
                </tr>
                <tr>
                <td align='left' valign='bottom'>
                <span class='style3'>This message was sent by E-LOGISTICS TECHNOLOGY. (<a href='mailto:info@e-logitech.net'>info@e-logitech.net</a>)</span>
                </td>
                <td align='right' valign='top'>
                <a href='http://www.e-logitech.net targest='_blank'><img src='http://www.e-logitech.net/elt_email/images/powered_logo.gif' width='123' height='50' border='0' /></a>
                </td>
                </tr>
                </table>
                </body>
                </html>";

        MailMessage message = new MailMessage("info@e-logitech.net", lblEmailAddress.Text, "FreightEasy Account Creation Completed", body);
        message.IsBodyHtml = true;
        SmtpClient client = new SmtpClient("localhost", 25);
        // client.Send(message);
    }
}
