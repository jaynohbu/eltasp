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
/// Summary description for customerPaymentDetailRecord
/// </summary>
public class PaymentDetailRecord
{
	public PaymentDetailRecord()
	{
	}
    public string elt_account_number;
    public int item_id;
    public int payment_no;
    public string invoice_date;
    public string type;
    public int invoice_no;
    public Decimal orig_amt;
    public Decimal amt_due;    
    public Decimal payment;

    
}
