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
/// Summary description for BillDetailRecord
/// </summary>
public class BillDetailRecord
{
    public BillDetailRecord()
    {
    }

    public BillDetailRecord(CostItemRecord crec,int invoice_no,int bill_number,int itme_ap)
    { 
    }

    private bool is_checked;

    public bool Is_checked
    {
        get { return is_checked; }
        set
        {
            is_checked = value;
        }
    }

    public string elt_account_number;
    public string vendor_name;
    public string tran_date;
    public string ref_no;
    public string mb_no;
    public string hb_no;

    public string iType;
    public string agent_debit_no;
    public string is_manual;
    public string is_org_merged;
    public string url;

    public int invoice_no;
    public int item_id;
    public int bill_number;
    public int vendor_number;
  
    public int item_no;
    public Decimal item_amt;
    public int item_expense_acct;
    public int item_ap;
    public string import_export;
   

    public void replaceQuote()
    {
        GeneralUtility gUtil = new GeneralUtility();       
        vendor_name = gUtil.replaceQuote(vendor_name);       
        ref_no = gUtil.replaceQuote(ref_no);
        mb_no = gUtil.replaceQuote(mb_no);        
        agent_debit_no = gUtil.replaceQuote(agent_debit_no);       
        url = gUtil.replaceQuote(url);        
    }
}
