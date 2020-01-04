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
/// Summary description for customerPaymentRecord
/// </summary>
public class PaymentRecord
{
	public PaymentRecord()
	{
	}
    private ArrayList paymentDetailList;
    public ArrayList PaymentDetailList
    {
        set
        {
            paymentDetailList = value;
        }
        get
        {
            return paymentDetailList;
        }
    }

    private ArrayList invoiceList;

    public ArrayList InvoiceList
    {
        set
        {
            invoiceList = value;
        }
        get
        {
            return invoiceList;
        }
    }

    private ArrayList aajList;

    public  ArrayList AllAccountsJournalList
    {
        set
        {
            aajList = value;
        }
        get
        {
            return aajList;
        }
    }


    public string elt_account_number;
    public int payment_no;
    public string branch;
    public string payment_date;
    public string ref_no;
    public int customer_number;
    
    public Decimal accounts_receivable;
    public int deposit_to;
    public Decimal received_amt;
    public string pmt_method;
    public Decimal balance;
    public Decimal existing_credits;
    public Decimal unapplied_amt;
    public Decimal added_amt;
    public string is_org_merged;
    public string customer_name;


    public void replaceQuote()
    {
        GeneralUtility gUtil = new GeneralUtility();
        customer_name = gUtil.replaceQuote(customer_name);
    }
  
}
