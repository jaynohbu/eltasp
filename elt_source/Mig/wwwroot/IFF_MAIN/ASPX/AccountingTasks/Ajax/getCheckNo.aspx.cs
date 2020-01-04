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

public partial class ASPX_AccountingTasks_Ajax_getCheckNo : System.Web.UI.Page
{
   
    private int bank_acct;
    private Decimal checkNo;
    private string elt_account_number;
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
        //glMgr = new GLManager(elt_account_number);
        //BankAccountList = glMgr.getGLAcctList(Account.BANK);

        checkNo = -1;
        bank_acct = Int32.Parse(Request.QueryString["acct"]);
        GLManager glMgr = new GLManager(elt_account_number);
        checkNo = glMgr.getNextCheckNumber(bank_acct);
        Response.Write(checkNo.ToString());
        Response.End();        

    }
}
