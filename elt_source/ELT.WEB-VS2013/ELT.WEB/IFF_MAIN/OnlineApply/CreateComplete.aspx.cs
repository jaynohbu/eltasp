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

public partial class OnlineApply_CreateComplete : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            SendCompletionEmail();
        }
    }

    protected void SendCompletionEmail()
    {
        string email_address, elt_account_number, user_name, user_pass;
        string ConnectStr = (new igFunctions.DB().getConStr());
        SqlConnection Con = new SqlConnection(ConnectStr);
        SqlCommand Cmd = new SqlCommand();
        Cmd.Connection = Con;
        bool resVal = false;

        email_address = elt_account_number = user_name = user_pass = "";

        Cmd.CommandText = "select * from users WHERE userid=1000 AND elt_account_number=" + Session["sELTAcct"].ToString();

        try
        {
            Con.Open();
            SqlDataReader reader = Cmd.ExecuteReader();
            if (reader.Read())
            {
                email_address = Session["semail"].ToString();
                elt_account_number = reader["elt_account_number"].ToString();
                user_name = reader["login_name"].ToString();
                user_pass = reader["password"].ToString();
            }
            reader.Close();

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
                <a href='http://www.e-logitech.net targest='_blank'><img src='http://www.e-logitech.net/elt_email/images/powered_logo.gif' width='123' height='50' border='0' /></a>
                </td>
                </tr>
                </table>
                </body>
                </html>";

            MailMessage message = new MailMessage("info@e-logitech.net", email_address, "FreightEasy Account Creation Completed", body);
            message.IsBodyHtml = true;
            SmtpClient client = new SmtpClient("localhost", 25);
            // client.Send(message);
        }
        catch (Exception e) { Response.Write(e.Message);  }
    }
}
