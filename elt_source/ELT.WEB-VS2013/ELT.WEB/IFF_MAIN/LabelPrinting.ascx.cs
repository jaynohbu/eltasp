using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;
//using ELT.Printing;
using Neodynamic.SDK.Web;
public partial class LabelPrinting : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    public string elt_account_number;
    public string user_id, login_name, login_lname, user_type;
    public string board_name;
    protected DataSet ds;
    protected SqlDataAdapter Adap;
    public int allIndex = 0;
    protected string ConnectStr;
    public string logoUrl = "";
    public string session_id = "";

    protected void Page_Init(object sender, System.EventArgs e)
    {
        if (WebClientPrint.ProcessPrintJob(this.Request))
        {
            session_id = this.Request.QueryString["sid"];
            ClientPrintJob cpj = new ClientPrintJob();
            cpj.ClientPrinter = new UserSelectedPrinter();
            cpj.PrinterCommands = (string)Application[session_id + CommonConstants.PrintCommand];
            cpj.SendToClient(Response);           
        }
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        Response.Cache.SetExpires(DateTime.Now); //or a date much earlier than current time
    }

    [WebMethod]
    public static void SetPrintCommand(string sid_command)
    {
        string sid = sid_command.Split('_')[0];
        string command = sid_command.Split('_')[1];
        HttpContext.Current.Application[sid + CommonConstants.PrintCommand] = command;
    }

}