using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public class CostItemRecord
{
    private string import_export;
    public bool ap_lock;
    public string Import_export
    {
        get { return import_export; }
        set { import_export = value; }
    } 
    private int itemNo;//Item's unique ID


    public int ItemNo
    {
        get { return itemNo; }
        set { itemNo = value; }
    }
    private int itemId;//Sequence Number

    public int ItemId
    {
        get { return itemId; }
        set { itemId = value; }
    }
    private string hb;

    public string Hb
    {
        get { return hb; }
        set { hb = value; }
    }
    private string mb;

    public string Mb
    {
        get { return mb; }
        set { mb = value; }
    }
    private string waybill_type;

    public string Waybill_type
    {
        get { return waybill_type; }
        set { waybill_type = value; }
    }
    private Decimal amount;

    public Decimal Amount
    {
        get { return amount; }
        set { amount = value; }
    }
    private string description;

    public string Description
    {
        get { return description; }
        set { description = value; }
    }
    private string url;

    public string Url
    {
        get { return url; }
        set { url = value; }
    }

    public CostItemRecord()
    {

    }

    private int vendor_no;

    public int Vendor_no{
        get{return vendor_no;}
        set { vendor_no = value; }
    }


    private string  vendor_name;
    public string Vendor_name
    {
        get { return vendor_name; }
        set { vendor_name = value; }
    }

    private int  expense_acct;

    public int  Expense_acct
    {
        get { return expense_acct; }
        set { expense_acct = value; }
    }

    private int ap_acct;

    public int Ap_acct
    {
        get { return ap_acct; }
        set { ap_acct = value; }
    }



    private string ref_no;

    public string Ref_no{
        get{return ref_no;}
        set{ref_no=value;}
    }


    public void replaceQuote()
    {
        GeneralUtility gUtil = new GeneralUtility();
        ref_no = gUtil.replaceQuote(ref_no);
        vendor_name = gUtil.replaceQuote(vendor_name);
        url = gUtil.replaceQuote(url);
        description = gUtil.replaceQuote(description);       
    }
}
