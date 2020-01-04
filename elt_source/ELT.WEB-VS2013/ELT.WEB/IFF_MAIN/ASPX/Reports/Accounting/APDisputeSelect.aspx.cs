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
        if (!IsPostBack)
        {
            ELT.COMMON.SessionManager Smgr = new ELT.COMMON.SessionManager();

        }
    }
   
    protected void btnGo_Click(object sender, ImageClickEventArgs e)
    {
        FreightEasy.Accounting.APDispute myDs = new FreightEasy.Accounting.APDispute();
        string elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        myDs.GetAllRecords(elt_account_number, hVendorAcct.Value,
            Webdatetimeedit1.Text, Webdatetimeedit2.Text);
   
        Session["Accounting_sPeriodBegin"] = Webdatetimeedit1.Text;
        Session["Accounting_sPeriodEnd"] = Webdatetimeedit2.Text;
        Session["Accounting_sCompanName"] = this.lstVendorName.Text;



        DataSet ds = new DataSet();
        foreach (DataTable dt in myDs.Tables)
        {
            ds.Tables.Add(dt.Copy());
        }
        Session["Accounting_sSelectionParam"] = "apdispute";
        Session["APDisputeDS"] = ds;
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "RediretThis", "window.top.location.href='/Accounting/APDispute/dataready'", true);
    }
}
