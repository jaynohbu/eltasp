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

public partial class ASPX_Reports_OperationPNL_PNLSelectAE : System.Web.UI.Page
{
    protected string ConnectStr, user_id, login_name, user_right, elt_account_number;

    protected void Page_Load(object sender, EventArgs e)
    {
        Session.LCID = 1033;
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
        ConnectStr = (new igFunctions.DB().getConStr());
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        Response.Redirect("PNLResultAE.aspx?MAWB=" + lstSearchNum.Text);
    }
}
