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
/// Summary description for GeneralJournalRecord
/// </summary>
public class GeneralJournalRecord
{
    public string elt_account_number;
    public int item_no;
    public int entry_no;
    public int gl_account_number;
    public Decimal credit;
    public Decimal debit;
    public string memo;
    public int org_acct;
    public string dt;


    public void replaceQuote()
    {
        GeneralUtility gUtil = new GeneralUtility();
        memo = gUtil.replaceQuote(memo);
    }

    private AllAccountsJournalRecord all_accounts_journal_entry;
   
    public AllAccountsJournalRecord All_Accounts_Journal_Entry
    {
        get { return all_accounts_journal_entry; }
        set { all_accounts_journal_entry = value; }       
    }

	public GeneralJournalRecord()
	{
		  
	}
}
