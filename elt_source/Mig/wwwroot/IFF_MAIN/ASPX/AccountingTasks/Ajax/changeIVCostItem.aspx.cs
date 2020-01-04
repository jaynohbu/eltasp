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

public partial class ASPX_AccountingTasks_Ajax_changeIVCostItem : System.Web.UI.Page
{
    private int org_acct;
    private int bank_acct;   
    private string elt_account_number;
    public string user_id, login_name, user_right, cost_amount;
    protected string ConnectStr;
    private string invoice_no, item_id, item_no;
    private IVCostItemsManager IVCostMgr;

    protected void Page_Load(object sender, EventArgs e)
    {
        Session.LCID = 1033;
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        ConnectStr = (new igFunctions.DB().getConStr());
        IVCostMgr = new IVCostItemsManager(elt_account_number);

        invoice_no = Request.QueryString["invoice_no"];
        item_id = Request.QueryString["item_id"];
        item_no = Request.QueryString["item_no"];
        cost_amount = Request.QueryString["cost_amount"];
        Response.Write(IVCostMgr.changeIVCostItemAmt(invoice_no, item_id, item_no,cost_amount).ToString());
        Response.End();
        
    }
}
