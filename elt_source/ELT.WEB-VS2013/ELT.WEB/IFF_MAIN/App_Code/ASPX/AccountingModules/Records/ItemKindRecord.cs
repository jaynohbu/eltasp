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
/// Summary description for ItemKind
/// </summary>
public class ItemKindRecord
{
    private int item_no;
    private string delim="-------";

    public string Delim
    {
        get { return delim; }
        set { delim = value; }
    }
    public int Item_no
    {
        get { return item_no; }
        set { item_no = value; }
    }

    private string item_name;
    public string Item_name
    {
        get { return item_name; }
        set { item_name = value; }
    }
    private string item_desc;
    public string Item_desc
    {
        get { return item_desc; }
        set { item_desc = value; }
    }
    private string item_type;
    public string Item_type
    {
        get { return item_type; }
        set { item_type = value; }
    }
    private Decimal unit_price;
    public Decimal Unit_price
    {
        get { return unit_price; }
        set { unit_price = value; }
    }
    public string NameDescription
    {
        get { return item_name + delim + item_desc; }
       
    }
	public ItemKindRecord()
	{
		//
		// TODO: Add constructor logic here
		//
	}
}
