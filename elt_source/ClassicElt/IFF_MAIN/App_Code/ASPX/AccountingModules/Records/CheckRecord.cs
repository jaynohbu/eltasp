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
using System.Text;


public class CheckRecord
{
    public string elt_account_number;
 
    public int bank_gl_account_number;
    public string tran_date;
    public string customer_name;
    public int customer_number;
    public int check_no;
    public Decimal amount;
    public string chk_complete;
    public string chk_void;
    public string is_org_merged;
    private ArrayList billList;

    public ArrayList BillList
    {
        get { return billList; }
        set { billList = value; }
    }

    private ArrayList all_accounts_journal_entry_list;

    public ArrayList All_accounts_journal_entry_list
    {
        get { return all_accounts_journal_entry_list; }
        set { all_accounts_journal_entry_list = value; }
    }

    private ArrayList checkDetailList;
    public ArrayList CheckDetailList
    {
        get { return checkDetailList; }
        set { checkDetailList = value; }
    }

	public CheckRecord()
	{
		
	}

    public void replaceQuote()
    {
        GeneralUtility gUtil = new GeneralUtility();
        customer_name = gUtil.replaceQuote(customer_name);


    }


     
}
