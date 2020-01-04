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

public partial class ASPX_AccountingTasks_BankReconcileStep3 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ReconcileRecord rcRec=(ReconcileRecord)Session["rcRec"];


        this.txtOpeningBalance.Text = rcRec.opening_balance.ToString();
        this.txtClearedTransactions.Text=rcRec.total_cleared.ToString();
        this.txtEndingBalanceOfStatement.Text=rcRec.statement_ending_balance.ToString();
        this.txtRegisterBalanceAsOfReconcileDate.Text = rcRec.system_balance_asof_recon_date.ToString();
        this.txtRegisterBalanceAsOfStatement.Text = rcRec.system_balance_asof_statement.ToString();
        this.txtUnclearedTransactions.Text=rcRec.total_uncleared.ToString();

        Session["dtReceivement"] = null;
        Session["dtPayment"] = null;
        Session["rcRec"] = null;
    }
}
