using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;

public partial class AjaxFacade_AjaxHelper : System.Web.UI.Page
{   
    [WebMethod]
    public static void SetPrintCommand(string command, string sid)
    {
        HttpContext.Current.Application[sid+CommonConstants.PrintCommand] = command;
    }
}