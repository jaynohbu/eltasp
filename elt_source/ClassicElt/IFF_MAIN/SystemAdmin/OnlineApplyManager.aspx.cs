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
using System.Net.Mail;

public partial class SystemAdmin_OnlineApplyManager : System.Web.UI.Page
{
    protected string http_host = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        http_host = System.Web.HttpContext.Current.Request.ServerVariables["HTTP_HOST"].ToLower();
    }

    protected void SqlDataSource1_Init(object sender, EventArgs e)
    {
        SqlDataSource obj = (SqlDataSource)sender;
        obj.ConnectionString = (new igFunctions.DB().getConStr());
        obj.SelectCommand = "SELECT * FROM setup_session a LEFT OUTER JOIN setup_master b ON a.page_id=b.page_id";
        obj.DeleteCommand = @"
            DECLARE @elt_num VARCHAR(32)
            SET @elt_num=(SELECT elt_account_number from setup_session WHERE sid=@sid)
            IF @elt_num IS NULL
                DELETE FROM setup_session where sid=@sid
            ELSE
                EXEC dbo.DeleteAllTableRowsByELT @elt_num
            ";
    }

    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Email")
        {
            FreightEasy.DataManager.FreightEasyData fe = new FreightEasy.DataManager.FreightEasyData();
            fe.AddToDataSet("SetupSession", "SELECT * FROM setup_session WHERE sid='" + e.CommandArgument.ToString() + "'");
            DataRow dr = fe.Tables["SetupSession"].Rows[0];

            string sid = dr["sid"].ToString();
            string email = dr["email"].ToString();
            string password = dr["password"].ToString();
            string elt_account_number = dr["elt_account_number"].ToString();


            string body = @"
                <html>
                <head>
                <title>FreightEasy Online Application (Setup Information)</title>
                <style type='text/css'>
	                .style3 {	
		                font-family: Verdana, Arial, Helvetica, sans-serif;	
		                font-size: 9px;}
                </style>
                </head>
                <body>
                <p class='style3'><strong>FreightEasy Online Application (Setup Information)</strong></p>
                <p />
                <table class='style3' width='100%' border='0' cellspacing='0' cellpadding='0'>
                <tr>
                <td colspan='2'>
                <a href='http://" + http_host + @"/IFF_MAIN/Authentication/SetupLogin.aspx?sid=" + sid + @"'>click to login</a>
                <p />Email Address: " + email + @"
                <p />Password: " + password + @"</td>
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

            MailMessage message = new MailMessage("info@e-logitech.net", email, "FreightEasy Online Application (Setup Information)",body);
            message.IsBodyHtml = true;
            SmtpClient client = new SmtpClient("localhost", 25);
            client.Send(message);
        }
    }
}
