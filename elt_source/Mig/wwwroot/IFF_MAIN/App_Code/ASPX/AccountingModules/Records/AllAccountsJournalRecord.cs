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
public class AllAccountsJournalRecord
{
    public int elt_account_number;
    public int tran_seq_num;
    public int tran_num;
    public int gl_account_number;
    public string gl_account_name;
    public string tran_type;
    public string air_ocean;
    public string inland_type; //added by stanley on 12/14
    public string tran_date;
    public string customer_name;
    public int customer_number;
    public string memo;
    public string split;
    public int check_no;
    public Decimal debit_amount;
    public Decimal credit_amount;
    public Decimal balance;
    public Decimal previous_balance;
    public Decimal gl_balance;
    public Decimal gl_previous_balance;
    public Decimal adjust_amount;
    public string ModifiedBy;
    public string ModifiedDate;
    public Decimal debit_memo;
    public Decimal credit_memo;
    public string flag_close;
    public string print_check_as;
    public string chk_complete;
    public string chk_void;
    public string is_org_merged;
    public string is_recon_cleared;
   
	public AllAccountsJournalRecord()
	{
	}
    public void replaceQuote()
    {
        GeneralUtility gUtil = new GeneralUtility();
       
        customer_name = gUtil.replaceQuote(customer_name);
        memo = gUtil.replaceQuote(memo);        
        print_check_as = gUtil.replaceQuote(print_check_as);
        
    }
}
