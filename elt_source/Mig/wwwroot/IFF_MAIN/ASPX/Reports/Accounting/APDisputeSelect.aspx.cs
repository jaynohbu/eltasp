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

public partial class ASPX_Reports_Accounting_APDisputeSelect : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    protected void ImageButton1_Click1(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("APDisputeDetail.aspx?VENDOR=" + hVendorAcct.Value + "&SDATE="
            + Webdatetimeedit1.Text + "&EDATE=" + Webdatetimeedit2.Text);
    }
}
