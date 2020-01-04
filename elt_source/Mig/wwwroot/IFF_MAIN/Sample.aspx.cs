using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Neodynamic.SDK.Web;
using ELT.Printing;

public partial class Sample : System.Web.UI.Page
{
    protected void Page_Init(object sender, EventArgs e)
    {
        if (WebClientPrint.ProcessPrintJob(this.Request))
        {
            PrintingManager.Print("AAAA", this);
           
        }       

    }
   
}