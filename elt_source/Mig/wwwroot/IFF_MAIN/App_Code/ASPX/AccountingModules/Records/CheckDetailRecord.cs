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
/// Summary description for checkDetailRecord
/// </summary>
public class CheckDetailRecord
{
	public CheckDetailRecord()
	{
	}
    public string elt_account_number;
    public int print_id;
    public int tran_id;
    public int bill_number;
    public string due_date;
    public int invoice_no;
    public Decimal bill_amt;
    public Decimal amt_due;
    public Decimal amt_paid;
    public string memo;
    public string pmt_method;

    public void replaceQuote()
    {
        GeneralUtility gUtil = new GeneralUtility();
        memo = gUtil.replaceQuote(memo);
    }

}
