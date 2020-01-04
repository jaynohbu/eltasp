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
/// Summary description for checkQueueRecord
/// </summary>
public class CheckQueueRecord
{
    public CheckQueueRecord()
	{
	}

    public bool chk_void;
    public bool chk_complete;
    public string elt_account_number;
    public int print_id;
    public int check_no;
    public string check_type;
    public Decimal check_amt;
    public int vendor_number;
    public string vendor_name;
    public string vendor_info;
    public int  bank;
    public int  ap;
    public string print_status;
    public string bill_date;
    public string bill_due_date;
    public string print_date;
    public string memo;
    public string pmt_method;
    public string print_check_as;
    public string is_org_merged;


    public void replaceQuote()
    {
        GeneralUtility gUtil = new GeneralUtility();
        vendor_name = gUtil.replaceQuote(vendor_name);
        vendor_info = gUtil.replaceQuote(vendor_info);
        memo = gUtil.replaceQuote(memo);

    }

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

}
