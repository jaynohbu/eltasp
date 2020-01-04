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

public partial class ASPX_AccountingTasks_RefundTo : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void btnGo_Click(object sender, ImageClickEventArgs e)
    {
       
        string customer_acct = this.hCustomerAcct.Value;
        if (customer_acct != "" && customer_acct != null)
        {

            if (this.checkMethod.SelectedValue == "Credit")
            {

                string script2 = "<script language='javascript'>";
                script2 += "form1.method='Post';";
                script2 += "form1.action='" + "customer_credit.aspx?FromRefundTo=yes&customer_acct=" + customer_acct + "';";
                //script2 += "form1.__VIEWSTATE.name = 'NOVIEWSTATE';";
                script2 += "form1.submit();";
                script2 += "</script>";
                this.ClientScript.RegisterClientScriptBlock(this.GetType(), "PreLoad", script2);

                //Response.Redirect("customer_credit.aspx?FromRefundTo=yes&customer_acct=" + customer_acct);
            }
            else
            {
                string script2 = "<script language='javascript'>";
                script2 += "form1.method='Post';";
                script2 += "form1.action='" + "write_check.aspx?FromRefundTo=yes&customer_acct=" + customer_acct + "';";
                //script2 += "form1.__VIEWSTATE.name = 'NOVIEWSTATE';";
                script2 += "form1.submit();";
                script2 += "</script>";
                this.ClientScript.RegisterClientScriptBlock(this.GetType(), "PreLoad", script2);

                // Response.Redirect("write_check.aspx?FromRefundTo=yes&customer_acct=" + customer_acct);
            }
        }
        else
        {
            string script2 = "<script language='javascript'>";
            script2 += "alert('Please select a customer');";           
            script2 += "</script>";
            this.ClientScript.RegisterClientScriptBlock(this.GetType(), "PreLoad", script2);
        }
    }
    protected void checkMethod_SelectedIndexChanged(object sender, EventArgs e)
    {
        
    }
}
