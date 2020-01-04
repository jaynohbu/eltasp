using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using System.IO;
using System.Configuration;
using Infragistics.WebUI.UltraWebGrid;
using CrystalDecisions.Shared;

public partial class ASPX_Reports_Accounting_APDisputeDetail : System.Web.UI.Page
{
    protected DataSet ds = null;
    protected string user_id, login_name, user_right, elt_account_number;

    protected void Page_Load(object sender, EventArgs e)
    {
        Session.LCID = 1033;
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];

        try
        {
            Session.LCID = 1033;

            if (!IsPostBack)
            {
                GetParameters();
                BindGridData();
            }
        }
        catch
        {
        }
    }

    protected void BindGridData()
    {
        FreightEasy.Accounting.APDispute myDs = new FreightEasy.Accounting.APDispute();
        myDs.GetAllRecords(elt_account_number, Session["VENDOR"].ToString(),
            Session["SDATE"].ToString(), Session["EDATE"].ToString());
        DataSet ds = myDs;

        UltraWebGrid1.DataSource = ds;
        UltraWebGrid1.DataBind();
        UltraWebGrid1.ExpandAll();
    }

    protected void GetParameters()
    {
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];

        Session["VENDOR"] = Request.Params["VENDOR"];
        Session["SDATE"] = Request.Params["SDATE"];
        Session["EDATE"] = Request.Params["EDATE"];
    }

    protected void UltraWebGrid1_InitializeLayout(object sender, LayoutEventArgs e)
    {
        UltraWebGrid uwg = (UltraWebGrid)e.Layout.Grid;
        ColumnsCollection disputeTotal = uwg.Bands[0].Columns;
        ColumnsCollection disputeItem = uwg.Bands[1].Columns;

        disputeTotal.FromKey("elt_account_number").Hidden = true;
        disputeTotal.FromKey("org_account_number").Hidden = true;

        disputeItem.FromKey("elt_account_number").Hidden = true;
        disputeItem.FromKey("vendor_number").Hidden = true;
        disputeItem.FromKey("memo").Hidden = true;

        disputeTotal.FromKey("dba_name").Header.Caption = "Vendor";
        disputeTotal.FromKey("class_code").Header.Caption = "Class";
        disputeTotal.FromKey("business_phone").Header.Caption = "Phone";

        disputeItem.FromKey("print_id").Header.Caption = "Tran No";
        disputeItem.FromKey("bill_number").Header.Caption = "Bill No";
        disputeItem.FromKey("bill_date").Header.Caption = "Tran Date";
        disputeItem.FromKey("pmt_method").Header.Caption = "Payment";
        disputeItem.FromKey("memo").Header.Caption = "Memo";
        disputeItem.FromKey("file_no").Header.Caption = "File No";
        disputeItem.FromKey("amt_due").Header.Caption = "Due Amount";
        disputeItem.FromKey("amt_paid").Header.Caption = "Paid Amount";
        disputeItem.FromKey("amt_dispute").Header.Caption = "Disputed Amount";

        disputeTotal.FromKey("dba_name").Width = Unit.Pixel(267);
        disputeTotal.FromKey("class_code").Width = Unit.Pixel(80);
        disputeTotal.FromKey("business_phone").Width = Unit.Pixel(100);
        disputeTotal.FromKey("Bill Amount").Width = Unit.Pixel(100);
        disputeTotal.FromKey("Paid Amount").Width = Unit.Pixel(100);
        disputeTotal.FromKey("Balance").Width = Unit.Pixel(100);
        disputeTotal.FromKey("Dispute Amount").Width = Unit.Pixel(100);

        disputeItem.FromKey("bill_number").Width = Unit.Pixel(100);
        disputeItem.FromKey("print_id").Width = Unit.Pixel(100);
        disputeItem.FromKey("bill_date").Width = Unit.Pixel(80);
        disputeItem.FromKey("file_no").Width = Unit.Pixel(165);
        disputeItem.FromKey("pmt_method").Width = Unit.Pixel(70);
        disputeItem.FromKey("amt_due").Width = Unit.Pixel(100);
        disputeItem.FromKey("amt_paid").Width = Unit.Pixel(100);
        disputeItem.FromKey("amt_dispute").Width = Unit.Pixel(100);

        disputeItem.FromKey("bill_date").Format = "MM/dd/yyyy";
    }

    protected void UltraWebGrid1_InitializeRow(object sender, Infragistics.WebUI.UltraWebGrid.RowEventArgs e)
    {
        try
        {
            e.Row.Cells.FromKey("print_id").TargetURL = "javascript:viewPop('/ASP/acct_tasks/pay_bills.asp?WindowName=popupNew&EditCheck=yes&CheckQueueID=" + e.Row.Cells.FromKey("print_id") + "');";
            e.Row.Cells.FromKey("bill_number").TargetURL = "javascript:viewPop('/ASP/acct_tasks/enter_bill.asp?WindowName=popupNew&ViewBill=yes&BillNo=" + e.Row.Cells.FromKey("bill_number") + "');";
        }
        catch { }
    }

    protected void btnExcelExport_Click(object sender, EventArgs e)
    {
        UltraWebGridExcelExporter1.DownloadName = "APDetail.xls";
        UltraWebGridExcelExporter1.Export(UltraWebGrid1);
    }

    protected void btnPDFExport_Click(object sender, EventArgs e)
    {
        FreightEasy.Accounting.APDispute myDs = new FreightEasy.Accounting.APDispute();
        myDs.GetAllRecords(elt_account_number, Session["VENDOR"].ToString(),
            Session["SDATE"].ToString(), Session["EDATE"].ToString());
        DataSet ds = myDs;

        ReportSourceManager rsm = null;
        try
        {
            rsm = new ReportSourceManager();
            rsm.LoadDataSet(ds);
            rsm.LoadCompanyInfo(elt_account_number, Server.MapPath("../../../ClientLogos/" + elt_account_number + ".jpg"));
            rsm.WriteXSD(Server.MapPath("../../../CrystalReportResources/xsd/APDispute.xsd"));
            rsm.BindNow(Server.MapPath("../../../CrystalReportResources/rpt/APDispute.rpt"));
            Response.Clear();
            Response.Buffer = true;
            Response.ContentType = "application/pdf";
            Response.AddHeader("Content-Type", "application/pdf");
            Response.AddHeader("Content-disposition", "attachment;filename=APDispute_" + System.DateTime.Today.ToString("yyyy-MM-dd") + ".pdf");

            MemoryStream oStream;
            oStream = (MemoryStream)rsm.getReportDocument().ExportToStream(ExportFormatType.PortableDocFormat);

            Response.BinaryWrite(oStream.ToArray());
        }
        catch { }
        finally
        {
            rsm.CloseReportDocumnet();
            Response.Flush();
            Response.End();
        }
    }

    protected override object LoadPageStateFromPersistenceMedium()
    {
        object state = this.Session["GridState"];
        return state;
    }

    protected override void SavePageStateToPersistenceMedium(object viewState)
    {
        this.Session.Add("GridState", viewState);
    }
}
