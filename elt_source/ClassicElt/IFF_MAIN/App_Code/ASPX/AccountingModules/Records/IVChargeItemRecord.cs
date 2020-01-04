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
/// Summary description for IVChargeItemRecord
/// </summary>
public class IVChargeItemRecord
{
    private int invoice_no;

    public int Invoice_no
    {
        get { return invoice_no; }
        set { invoice_no = value; }
    }
    private int item_id;

    public int Item_id
    {
        get { return item_id; }
        set { item_id = value; }
    }
    private int item_no;
    public int Item_no
    {
        get { return item_no; }
        set { item_no = value; }
    }
    

    public string Item_desc
    {
        get { return item_desc; }
        set { item_desc = value; }
    }
    private Decimal qty;

    public Decimal Qty
    {
        get { return qty; }
        set { qty = value; }
    }
    private Decimal charge_amount;

    public Decimal Charge_amount
    {
        get { return charge_amount; }
        set { charge_amount = value; }
    }


    private string import_export;

    public string Import_export
    {
        get { return import_export; }
        set { import_export = value; }
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
	public IVChargeItemRecord()
	{
	}

    private string item_desc;

    public void replaceQuote()
    {
        GeneralUtility gUtil = new GeneralUtility();
        item_desc = gUtil.replaceQuote(item_desc);
    }
}
