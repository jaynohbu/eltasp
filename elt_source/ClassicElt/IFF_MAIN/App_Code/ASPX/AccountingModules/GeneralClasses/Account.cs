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
/// Summary description for Account
/// </summary>
public class Account
{
    public static string MASTER_ASSET_NAME { get { return "ASSET"; } }
    public static string CURRENT_ASSET { get { return "Current Asset"; } }
    public static string ACCOUNT_RECEIVABLE { get { return "Accounts Receivable"; } }
    public static string CUSTOMER_CREDIT { get { return "Customer Credit"; } }
    public static string FIXED_ASSET { get { return "Fixed Asset"; } }
    public static string OTHER_ASSET { get { return "Other Asset"; } }
    public static string BANK { get { return "Cash in Bank"; } }
    public static string MASTER_LIABILITY_NAME { get { return "LIABILITY"; } }
    public static string CURRENT_LIB { get { return "Current Liability"; } }
    public static string ACCOUNT_PAYABLE { get { return "Accounts Payable"; } }
    public static string LONG_TERM_LIB { get { return "Long-Term Liability"; } }

    public static string MASTER_EQUITY_NAME { get { return "EQUITY"; } }
    public static string EQUITY { get { return "Equity"; } }
    public static string EQUITY_RETAINED_EARNINGS { get { return "Equity-Retained Earnings"; } }
    public static string MASTER_REVENUE_NAME { get { return "REVENUE"; } }
    public static string REVENUE { get { return "Revenue"; } }
    public static string OTHER_REVENUE { get { return "Other Revenue"; } }

    public static string MASTER_EXPENSE_NAME { get { return "EXPENSE"; } }
    public static string EXPENSE { get { return "Expense"; } }
    public static string COST_OF_SALES { get { return "Cost of Sales"; } }
    public static string OTHER_EXPENSE { get { return "Other Expense"; } }
    
	public Account()
	{
		//
		// TODO: Add constructor logic here
		//
	}
}
