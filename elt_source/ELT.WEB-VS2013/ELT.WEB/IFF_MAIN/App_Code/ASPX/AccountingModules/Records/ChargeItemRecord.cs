using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public class ChargeItemRecord
{
    private string import_export;

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

    public ChargeItemRecord()
    {

    }
    public void replaceQuote()
    {
        GeneralUtility gUtil = new GeneralUtility();
        description = gUtil.replaceQuote(description);
        url = gUtil.replaceQuote(url);
    }

}
