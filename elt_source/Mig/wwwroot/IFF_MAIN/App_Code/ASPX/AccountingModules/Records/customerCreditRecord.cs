using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Collections;

/// <summary>
/// Summary description for customerCreditsRecord
/// </summary>
public class customerCreditRecord
{
	public customerCreditRecord()
	{

	}
    public string elt_account_number;
    public int customer_no;
    public string tran_date;
    public string memo;
    public string customer_name;
    public int invoice_no;
    public string ref_no;
    public string is_refund;

    public Decimal credit;
    public string is_org_merged;
    public int entry_no;
    public ArrayList all_accounts_journal_list;
    public void replaceQuote()
    {
    }

}
