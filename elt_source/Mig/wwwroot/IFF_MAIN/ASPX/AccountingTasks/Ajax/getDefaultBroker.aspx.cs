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

public partial class ASPX_AccountingTasks_Ajax_getDefaultBroker : System.Web.UI.Page
{
  
   
    private string elt_account_number;
    private int org_account_number;
    public string user_id, login_name, user_right;
    protected string ConnectStr;

    protected void Page_Load(object sender, EventArgs e)
    {
        Session.LCID = 1033;
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];

        ConnectStr = (new igFunctions.DB().getConStr());


        string broker_acct = "0";
        try
        {
            org_account_number = Int32.Parse(Request.QueryString["org_account_number"]);
        }
        catch
        {
            org_account_number = 0;
        }
        OrganizationManager orgMgr = new OrganizationManager(elt_account_number);
        broker_acct = orgMgr.get_default_broker(org_account_number);
        Response.Write(broker_acct.ToString());
        Response.End();

    }
}
