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
/// Summary description for CostItemKindRecord
/// </summary>
public class CostItemKindRecord : ItemKindRecord
{

    private int account_expense;
    public int Account_expense
    {
        get { return account_expense; }
        set { account_expense = value; }
    }

    public string ItemNo_Accountexpense
    {
        get { return base.Item_no.ToString() + ":" + account_expense.ToString(); }
    }

    
    public CostItemKindRecord()
    {
    }
}

