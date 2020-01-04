using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

/// <summary>
/// Summary description for AllAccountJournalRecord
/// </summary>
public class ReconcilePaymentDetailRecord
{
    public string is_recon_cleared;
    public int recon_id;
    public int elt_account_number;
    public int tran_seq_num;
    public int tran_num;
    public int gl_account_number;
    public string gl_account_name;
    public string tran_type;
    public string memo;
    public string tran_date;
    public string customer_name;
    public int customer_number;
    public Decimal credit_amount;
    public void replaceQuote()
    {
        GeneralUtility gUtil = new GeneralUtility();
        customer_name = gUtil.replaceQuote(customer_name);    

    }
}
