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
/// Summary description for IVCostItemRecord
/// </summary>
public class IVCostItemRecord
{
    private bool ap_posted;
    public bool AP_Posted
    {
        get { return ap_posted; }
        set { ap_posted = value; }
    }
    private string import_export;

    public string Import_export
    {
        get { return import_export; }
        set { import_export = value; }
    } 

    private int bill_number;
    public int Bill_number
    {
        get { return bill_number; }
        set { bill_number = value; }
    }

    private int invoice_no;
    public int Invoice_no
    {
        get { return invoice_no; }
        set { invoice_no = value; }
    }
    private int item_no;

    public int Item_no
    {
        get { return item_no; }
        set { item_no = value; }
    }
    private int item_id;

    public int Item_id
    {
        get { return item_id; }
        set { item_id = value; }
    }
   
    private Decimal qty;
    public Decimal Qty
    {
        get { return qty; }
        set { qty = value; }
    }
    
    private Decimal cost_amount;

    public Decimal Cost_amount
    {
        get { return cost_amount; }
        set { cost_amount = value; }
    }
    private int vendor_no;

    public int Vendor_no
    {
        get { return vendor_no; }
        set { vendor_no = value; }
    }
    private char is_org_merged;

    public char Is_org_merged
    {
        get { return is_org_merged; }
        set { is_org_merged = value; }
    }

    private string air_ocean;

    public string Air_ocean
    {
        get { return air_ocean; }
        set { air_ocean = value; }
    }

    private string mb_no;

    public string Mb_no
    {
        get { return mb_no; }
        set { mb_no = value; }
    }
    private string hb_no;

    public string Hb_no
    {
        get { return hb_no; }
        set { hb_no = value; }
    }
    private string iType;

    public string IType
    {
        get { return iType; }
        set { iType = value; }
    }

    private string item_desc;

    public string Item_desc
    {
        get { return item_desc; }
        set { item_desc = value; }
    }
    private string ref_no;

    public string Ref_no
    {
        get { return ref_no; }
        set { ref_no = value; }
    }


    public void replaceQuote()
    {
        GeneralUtility gUtil = new GeneralUtility();
        ref_no = gUtil.replaceQuote(ref_no);
        item_desc = gUtil.replaceQuote(item_desc);
    }

   
	public IVCostItemRecord()
	{
		
	}
}
