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

public partial class Ports_SelectType : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void chkUSPort_CheckedChanged(object sender, EventArgs e)
    {
        Response.Redirect("./SearchUS.aspx");
    }
    protected void chkNonUSPort_CheckedChanged(object sender, EventArgs e)
    {
        Response.Redirect("./SearchNonUS.aspx");
    }
}
