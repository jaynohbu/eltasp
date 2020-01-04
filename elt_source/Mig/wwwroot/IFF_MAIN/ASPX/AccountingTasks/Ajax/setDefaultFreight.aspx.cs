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

public partial class ASPX_AccountingTasks_Ajax_setDefaultFreight : System.Web.UI.Page
{
 
    private string elt_account_number;
    public string air_ocean, user_right, login_name, user_id;
    protected string ConnectStr;

    protected void Page_Load(object sender, EventArgs e)
    {
        Session.LCID = 1033;
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];

        ConnectStr = (new igFunctions.DB().getConStr());
        GLManager glMgr = new GLManager(elt_account_number);
       
        
        if (Request.QueryString["air_ocean"] == "air")
        {            
            Response.Write(glMgr.setDefaultAFCostAcct());
            Response.End();
        }
        else 
        {

            Response.Write(glMgr.setDefaultAFCostAcct());
            Response.End();
        }        
       
    }
}
