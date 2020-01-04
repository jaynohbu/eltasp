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

public partial class ASPX_AccountingTasks_Ajax_getBalance: System.Web.UI.Page
{
    private int org_acct;
    private int bank_acct;
    private Decimal balance;
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

        balance = 0;
        if (Request.QueryString["type"] == "Bank")
        {
            bank_acct = Int32.Parse(Request.QueryString["acct"]);
            GLManager glMgr = new GLManager(elt_account_number);
            balance = glMgr.getBankBalance(bank_acct);
            Response.Write(balance.ToString());
            Response.End();
        }
        else if (Request.QueryString["type"] == "Customer_Credit")
        {
            org_acct = Int32.Parse(Request.QueryString["acct"]);
            CustomerCreditManager ccMger = new CustomerCreditManager(elt_account_number);
            Response.Write(ccMger.getcustomerCredit(org_acct));
            Response.End();
        }        
        else
        {

        }
    }
}
