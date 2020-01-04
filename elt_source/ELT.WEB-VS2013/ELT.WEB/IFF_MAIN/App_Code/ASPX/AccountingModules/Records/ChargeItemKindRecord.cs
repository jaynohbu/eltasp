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
/// Summary description for ChargeItemKindRecord
/// </summary>
public class ChargeItemKindRecord:ItemKindRecord 
{
    
    private int account_revenue;
    public int Account_revenue
    {
        get { return account_revenue; }
        set { account_revenue = value; }
    }

    public string ItemNo_AccountRevenue
    {
        get { return base.Item_no.ToString()+":"+account_revenue.ToString(); }       
    }

	public ChargeItemKindRecord()
	{		
	}
}
