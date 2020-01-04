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

public partial class LabelPrintUtil : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }


    protected void Page_Init(object sender, System.EventArgs e)
    {
        if (WebClientPrint.ProcessPrintJob(this.Request))
        {
            ClientPrintJob cpj = new ClientPrintJob();
            cpj.ClientPrinter = new UserSelectedPrinter();
            cpj.PrinterCommands = (string)Application[this.Request.QueryString["sid"] + CommonConstants.PrintCommand];
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