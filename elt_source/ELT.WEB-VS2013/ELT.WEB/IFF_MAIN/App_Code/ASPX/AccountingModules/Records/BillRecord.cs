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

/// <summary>
/// Summary description for BillRecord
/// </summary>
public class BillRecord
{
    private ArrayList billDetailList;
    public ArrayList BillDetailList
    {
        get { return billDetailList; }
        set
        {
            billDetailList = value;
        }
    }
    private ArrayList aajlist;
    public ArrayList All_accounts_journal_list
    {
        get { return aajlist; }
        set { aajlist = value; }
    } 
    private string elt_account_number;
    private int bill_number;
    public int Bill_number
    {
        get { return bill_number; }
        set
        {
            bill_number = value;
        }
    }  
    private int vendor_number;
    public int Vendor_number
    {
        get { return vendor_number; }
        set
        {
            vendor_number = value;
        }
    }    
    private Decimal bill_amt;
    public Decimal Bill_amt
    {
        get { return bill_amt; }
        set
        {
            bill_amt = value;
        }
    }
    private Decimal bill_amt_paid;
    public Decimal Bill_amt_paid
    {
        get { return bill_amt_paid; }
        set
        {
            bill_amt_paid = value;
        }
    }
    private Decimal bill_amt_due;
    public Decimal Bill_amt_due
    {
        get { return bill_amt_due; }
        set
        {
            bill_amt_due = value;
        }
    }   
    private int bill_expense_acct;
    public int Bill_expense_acct
    {
        get { return bill_expense_acct; }
        set
        {
            bill_expense_acct = value;
        }
    }
    private int bill_ap;
    public int Bill_ap
    {
        get { return bill_ap; }
        set
        {
            bill_ap = value;
        }
    }   
    private int print_id;
    public int Print_id
    {
        get { return print_id; }
        set
        {
            print_id = value;
        }
    }
    private string bill_status;
    private string bill_type;
    private string vendor_name;
    private string bill_date;
    private string bill_due_date;
    private string ref_no;
    private string _lock;
    private string pmt_method;
    private string is_org_merged;
    public string Bill_status
    {
        get { return bill_status; }
        set
        {
            bill_status = value;
        }
    }   
    public string Bill_type
    {
        get { return bill_type; }
        set
        {
            bill_type = value;
        }
    }   
    public string Vendor_name
    {
        get { return vendor_name; }
        set
        {
            vendor_name = value;
        }
    }    
    public string Bill_date
    {
        get { return bill_date; }
        set
        {
            bill_date = value;
        }
    }   
    public string Bill_due_date
    {
        get { return bill_due_date; }
        set
        {
            bill_due_date = value;
        }
    }    
    public string Ref_no
    {
        get { return ref_no; }
        set
        {
            ref_no = value;
        }
    }    
    public string Lock
    {
        get { return _lock; }
        set
        {
            _lock = value;
        }
    }    
    public string Pmt_method
    {
        get { return pmt_method; }
        set
        {
            pmt_method = value;
        }
    }    
    public string Is_org_merged
    {
        get { return is_org_merged; }
        set
        {
            is_org_merged = value;
        }
    }
    public void replaceQuote()
    {
        GeneralUtility gUtil = new GeneralUtility();
        vendor_name = gUtil.replaceQuote(vendor_name);
        ref_no = gUtil.replaceQuote(ref_no);
    }	
}
