using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using Infragistics.WebUI.UltraWebGrid;

public partial class ASPX_Reports_Accounting_SearchInvoices : System.Web.UI.Page
{
    public string elt_account_number = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        WebNavBar1.GridID = UltraWebGrid1.UniqueID;
    }

    protected void UltraWebGrid1_UpdateGrid(object sender, UpdateEventArgs e)
    {
        Response.Redirect(Request.Url.ToString());
    }

    protected void UltraWebGrid1_InitializeLayout(object sender, LayoutEventArgs e)
    {
        ColumnsCollection InvoiceCols = e.Layout.Bands[0].Columns;
        InvoiceCols.FromKey("invoice_no").Header.Caption = "I/V No.";
        InvoiceCols.FromKey("customer_name").Header.Caption = "Customer";
        InvoiceCols.FromKey("mawb_num").Header.Caption = "Master BL";
        InvoiceCols.FromKey("hawb_num").Header.Caption = "House BL";
        InvoiceCols.FromKey("entry_date").Header.Caption = "I/V Date";
        InvoiceCols.FromKey("invoice_type").Header.Caption = "T";
        InvoiceCols.FromKey("import_export").Header.Caption = "I/E";
        InvoiceCols.FromKey("air_ocean").Header.Caption = "A/O";
        InvoiceCols.FromKey("ref_no").Header.Caption = "Ref. No.";
        InvoiceCols.FromKey("ref_no_our").Header.Caption = "File No.";
        InvoiceCols.FromKey("total_pieces").Header.Caption = "PCS";
        InvoiceCols.FromKey("total_gross_weight").Header.Caption = "G. Weight";
        InvoiceCols.FromKey("total_charge_weight").Header.Caption = "Charge";
        InvoiceCols.FromKey("agent_profit").Header.Caption = "Agent P/F";
        InvoiceCols.FromKey("sale_tax").Header.Caption = "Tax";
        InvoiceCols.FromKey("total_cost").Header.Caption = "Cost";
        InvoiceCols.FromKey("subtotal").Header.Caption = "Sub Total";
        InvoiceCols.FromKey("lock_ap").Header.Caption = "A/P";
        InvoiceCols.FromKey("balance").Header.Caption = "Balance";
        InvoiceCols.FromKey("pay_status").Header.Caption = "P";
        InvoiceCols.FromKey("arrival_dept").Header.Caption = "Arrival/Departure";

    }

    protected void ObjectDataSource1_Init(object sender, EventArgs e)
    {
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"].ToString();
        ObjectDataSource ods = (ObjectDataSource)sender;
        ods.SelectMethod = "GetAllRecords";
        ods.SelectParameters.Add("elt_account_number", elt_account_number);
        ods.TypeName = "FreightEasy.Accounting.Invoices";
    }
}
