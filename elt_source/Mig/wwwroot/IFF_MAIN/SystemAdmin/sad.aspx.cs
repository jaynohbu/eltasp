using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public partial class sad : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["id"] != null&&Request.QueryString["tb"]!=null)
            {
                string elt_account_number =Request.QueryString["id"];
                string board_name=Request.QueryString["tb"];

                string ConnectStr = (new igFunctions.DB().getConStr());
                SqlConnection Con = new SqlConnection(ConnectStr);
                SqlCommand Cmd = new SqlCommand();
                Cmd.Connection = Con;  
                Cmd.CommandText = "UPDATE [agent] SET [board_name]= '" + board_name 
                    + "' WHERE [elt_account_number]= " + elt_account_number;

                try
                {
                    Con.Open();
                    Cmd.ExecuteNonQuery();
                    Con.Close();
                }
                catch (Exception ex)
                {
                    Response.Write(ex.ToString());
                    Response.End();
                }

            }
            try{
                if (Request.Cookies["CurrentUserInfo"]["elt_account_number"].ToString().Equals(""))
                    Response.Redirect("/IFF_MAIN/Authentication/login.aspx");
            }
            catch
            {
                Response.Redirect("/IFF_MAIN/Authentication/login.aspx");
            }

            if (!Request.Cookies["CurrentUserInfo"]["elt_account_number"].ToString().Equals("80002000")  || !Request.Cookies["CurrentUserInfo"]["login_name"].ToString().Equals("admin"))
            {
                Response.Redirect("/IFF_MAIN/Authentication/login.aspx");
            }

            string script = "<script language='javascript'>";
            script += "cBoardAssign();";
            script += "</script>";
            this.ClientScript.RegisterClientScriptBlock(this.GetType(), "PreLoad", script);           
 
              
        }

    }

    protected void btnNewAcct_Click(object sender, EventArgs e)
    {       
        Response.Redirect("NewAccount.aspx?mode=SysAdmin");
    }

    protected void btnAcCopy_Click(object sender, EventArgs e)
    {
        Response.Redirect("elt_account_copy.asp");
    }
    protected void btnmoduleManage_Click(object sender, EventArgs e)
    {
        Response.Redirect("ModuleManagerVer2.aspx");
    }
    protected void btnSetupManage_Click(object sender, EventArgs e)
    {
        Response.Redirect("SetupManager.aspx");
    }
    protected void lstTasks_SelectedIndexChanged(object sender, EventArgs e)
    {
        switch (lstTasks.SelectedValue)
        {
            case "0":
                hPageURL.Value = "NewAccount.aspx?mode=SysAdmin";
                break;
            case "1":
                hPageURL.Value = "elt_account_copy.asp";
                break;
            case "2":
                hPageURL.Value = "ModuleManagerVer2.aspx";
                break;
            case "3":
                hPageURL.Value = "SetupManager.aspx";
                break;
            case "4":
                hPageURL.Value = "OnlineApplyManager.aspx";
                break;
            case "5":
                hPageURL.Value = "ELTAccountManager.aspx";
                break;
        }
        
    }
}
