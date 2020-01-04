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

public partial class ASPX_AccountingTasks_Ajax_getEnglish : System.Web.UI.Page
{
   
  
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
        string amount = "0";
        NumberToEnglish n2e = new NumberToEnglish();
       
      
        if (Request.QueryString["money"] != "")
        {
            amount = n2e.changeCurrencyToWords(Request.QueryString["money"]);
            
        }
        Response.Write(amount);
        Response.End();
    }
}
