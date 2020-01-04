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
/// Summary description for BillDetailRecord
/// </summary>
public class IVHeaderRecord
{
    public string elt_account_number;
    public string invoice_no;
    public string mawb;
    public string hawb;
    public string ETA;
    public string ETD;

    public string Consignee;
    public string Shipper;
    public string FILE;
    public string GrossWeight;
    public string ChargeableWeight;

    public string Pieces;
    public string unit;
    public string Origin;
    public string Destination;  
    public string Carrier;
}
