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
using System.Net.Mail;

public partial class NewAccount_SetupComplete : System.Web.UI.Page
{
    string elt_account_number = "";
    string user_name = "";
    string user_pass = "";
    string user_email = "";
    protected string http_host = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"].ToString();
        Get_User_Id_Password();
        http_host = System.Web.HttpContext.Current.Request.ServerVariables["HTTP_HOST"].ToLower();
    }

    private void Get_User_Id_Password()
    {
        string ConnectStr = (new igFunctions.DB().getConStr());
        SqlConnection Con = new SqlConnection(ConnectStr);
        SqlCommand Cmd = new SqlCommand();
        Cmd.Connection = Con;
        bool resVal = false;

        Cmd.CommandText = "SELECT * FROM users WHERE elt_account_number=" + elt_account_number;

        try
        {
            Con.Open();
            SqlDataReader reader = Cmd.ExecuteReader();
            if (reader.Read())
            {
                user_name = reader["login_name"].ToString();
                user_pass = reader["password"].ToString();
            }
            reader.Close();
        }
        catch { }
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        string ConnectStr = (new igFunctions.DB().getConStr());
        SqlConnection Con = new SqlConnection(ConnectStr);
        SqlCommand Cmd = new SqlCommand();
        Cmd.Connection = Con;
        bool resVal = false;

        Cmd.CommandText = "select * from setup_session WHERE elt_account_number=" + elt_account_number;

        try
        {
            Con.Open();
            SqlDataReader reader = Cmd.ExecuteReader();
            if (reader.Read())
            {
                user_email = reader["email"].ToString();
            }
            reader.Close();

            string body = @"
                <html>
                <head>
                <title>FreightEasy Setup Completion</title>
                <style type='text/css'>
	                .style3 {	
		                font-family: Verdana, Arial, Helvetica, sans-serif;	
		                font-size: 9px;}
                </style>
                </head>
                <body>
                <p class='style3'><strong>FreightEasy Setup Completion</strong></p>
                <p />
                <table class='style3' width='100%' border='0' cellspacing='0' cellpadding='0'>
                <tr>
                <td colspan='2'>
                    <div>You have completed a setup session with following login information.<div><br/>
                    <table cellpadding=0 cellspacing=0 border=0 class='style3'>
                        <tr>
                            <td>
                                ELT Account No.</td>
                            <td style='width:5px'></td>
                            <td>
                               " + elt_account_number + @"</td>
                        </tr>
                        <tr>
                            <td>
                                User Name</td>
                            <td style='width:5px'></td>
                            <td>
                                " + user_name + @"</td>
                        </tr>
                        <tr>
                            <td>
                                Password</td>
                            <td style='width:5px'></td>
                            <td>
                                " + user_pass + @"</td>
                        </tr>
                    </table>
                </td>
                </tr>
                <tr>
                <td align='left' valign='bottom'>
                <span class='style3'>This message was sent by E-LOGISTICS TECHNOLOGY. (<a href='mailto:info@e-logitech.net'>info@e-logitech.net</a>)</span>
                </td>
                <td align='right' valign='top'>
                <a href='http://www.e-logitech.net target='_blank'><img src='http://www.e-logitech.net/elt_email/images/powered_logo.gif' width='123' height='50' border='0' /></a>
                </td>
                </tr>
                </table>
                </body>
                </html>";

            MailMessage message = new MailMessage("info@e-logitech.net", user_email, "FreightEasy Setup Completion", body);
            message.IsBodyHtml = true;
            SmtpClient client = new SmtpClient("localhost", 25);
            // client.Send(message);
        }
        catch (Exception ex) { Response.Write(ex.Message); }
        Update_Setup_Session();
    }

    protected void Update_Setup_Session()
    {
        Response.Write("<script> try{parent.update_setup_session('F');}catch(ex){}</script>");
    }
    protected void Button2_Click(object sender, EventArgs e)
    {
        Response.Write("<script>try{parent.update_setup_session('B');}catch(ex){}</script>");
    }
}
