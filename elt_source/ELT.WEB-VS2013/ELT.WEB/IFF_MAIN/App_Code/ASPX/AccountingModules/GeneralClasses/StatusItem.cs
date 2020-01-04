using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;


[Serializable]
public struct StatusItem
{
    public string processed_date;
    public string reference_number;
    public string print_id;
    public string payment_no;
    public string invoice_no;
    public string bill_number;
    public Decimal amount;   
}
