using System;
using System.IO;
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
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;

public partial class ASPX_Reports_OperationPNL_PNLResultOE : System.Web.UI.Page
{
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
        FreightEasy.PNL.OceanExportPNL myDs = new FreightEasy.PNL.OceanExportPNL();
        myDs.GetAllRecords(elt_account_number, Session["MAWB"].ToString(),
            "", "");
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
        
        Session["MAWB"] = Request.Params["MAWB"];

        btnPDFExport.Visible = false;
    }

    protected void UltraWebGrid1_InitializeLayout(object sender, LayoutEventArgs e)
    {
        UltraWebGrid uwg = (UltraWebGrid)e.Layout.Grid;
        ColumnsCollection mawbCols = uwg.Bands[0].Columns;
        ColumnsCollection hawbCols = uwg.Bands[1].Columns;
        ColumnsCollection itemCols = uwg.Bands[2].Columns;

        //hiding uneccessary columns
        mawbCols.FromKey("elt_account_number").Hidden = true;
        mawbCols.FromKey("shipper_acct_num").Hidden = true;

        hawbCols.FromKey("elt_account_number").Hidden = true;
        hawbCols.FromKey("booking_num").Hidden = true;
        hawbCols.FromKey("shipper_acct_num").Hidden = true;
        hawbCols.FromKey("agent_no").Hidden = true;

        itemCols.FromKey("elt_account_number").Hidden = true;
        itemCols.FromKey("booking_num").Hidden = true;
        itemCols.FromKey("hbol_num").Hidden = true;

        // renaming headers
        mawbCols.FromKey("booking_num").Header.Caption = "Booking No";
        mawbCols.FromKey("loading_port").Header.Caption = "FROM";
        mawbCols.FromKey("unloading_port").Header.Caption = "To";
        mawbCols.FromKey("gross_weight").Header.Caption = "Gross Wt.";

        hawbCols.FromKey("hbol_num").Header.Caption = "House B/L";
        hawbCols.FromKey("shipper_name").Header.Caption = "Shipper";
        hawbCols.FromKey("agent_name").Header.Caption = "Agent";
        hawbCols.FromKey("gross_weight").Header.Caption = "Gross Wt.";

        itemCols.FromKey("item_type").Header.Caption = "Item Type";
        itemCols.FromKey("item_desc").Header.Caption = "Item Name";
        itemCols.FromKey("item_amount").Header.Caption = "Item Amount";
        itemCols.FromKey("vendor").Header.Caption = "Vendor";

        FreightEasy.ClientProfiles.Clients clients = new FreightEasy.ClientProfiles.Clients();
        clients.GetClientsByType(elt_account_number, "All");
        UltraGridColumn vendorCol = itemCols.FromKey("vendor");
        vendorCol.Type = ColumnType.DropDownList;
        vendorCol.ValueList.DataSource = clients.Tables["All"];
        vendorCol.ValueList.DisplayMember = clients.Tables["All"].Columns["dba_name"].ToString();
        vendorCol.ValueList.ValueMember = clients.Tables["All"].Columns["org_account_number"].ToString();
        vendorCol.ValueList.DataBind();
        vendorCol.ValueList.ValueListItems.Insert(0, new ValueListItem("", 0));

        mawbCols.FromKey("booking_num").Width = Unit.Pixel(120);
        mawbCols.FromKey("shipper_name").Width = Unit.Pixel(200);
        mawbCols.FromKey("loading_port").Width = Unit.Pixel(50);
        mawbCols.FromKey("unloading_port").Width = Unit.Pixel(50);
        mawbCols.FromKey("gross_weight").Width = Unit.Pixel(80);
        mawbCols.FromKey("Revenue").Width = Unit.Pixel(80);
        mawbCols.FromKey("Expense").Width = Unit.Pixel(80);
        mawbCols.FromKey("Profit").Width = Unit.Pixel(80);

        hawbCols.FromKey("hbol_num").Width = Unit.Pixel(138);
        hawbCols.FromKey("shipper_name").Width = Unit.Pixel(200);
        hawbCols.FromKey("agent_name").Width = Unit.Pixel(200);
        hawbCols.FromKey("gross_weight").Width = Unit.Pixel(80);
        hawbCols.FromKey("Revenue").Width = Unit.Pixel(80);
        hawbCols.FromKey("Expense").Width = Unit.Pixel(80);
        hawbCols.FromKey("Profit").Width = Unit.Pixel(80);

        itemCols.FromKey("item_type").Width = Unit.Pixel(80);
        itemCols.FromKey("item_desc").Width = Unit.Pixel(160);
        itemCols.FromKey("item_amount").Width = Unit.Pixel(80);
        itemCols.FromKey("vendor").Width = Unit.Pixel(150);

    }

    protected void UltraWebGrid1_InitializeRow(object sender, Infragistics.WebUI.UltraWebGrid.RowEventArgs e)
    {
        try
        {
            if (e.Row.Cells.FromKey("booking_num") != null)
            {
                e.Row.Cells.FromKey("booking_num").TargetURL = "javascript:viewPop('/ASP/ocean_export/new_edit_mbol.asp?WindowName=popupNew&Edit=yes&BookingNum=" + e.Row.Cells.FromKey("booking_num").Text + "');";
            }

            try
            {
                if (e.Row.Cells.FromKey("hbol_num").Value == null)
                {
                    e.Row.Cells.FromKey("hbol_num").Text = "Direct Shipment";
                    e.Row.Cells.FromKey("Revenue").Text = "";
                    e.Row.Cells.FromKey("Expense").Text = "";
                    e.Row.Cells.FromKey("Profit").Text = "";
                }
                else
                {
                    e.Row.Cells.FromKey("hbol_num").TargetURL = "javascript:viewPop('/ASP/ocean_export/new_edit_hbol.asp?WindowName=popupNew&Edit=yes&hbol=" + e.Row.Cells.FromKey("hbol_num").Text + "');";
                }
            }
            catch { }
            
        }
        catch (Exception ex)
        {
            Response.Write(ex.Message);
        }
    }

    protected void btnExcelExport_Click(object sender, EventArgs e)
    {
        UltraWebGridExcelExporter1.DownloadName = "OceanExportPNL.xls";
        UltraWebGridExcelExporter1.Export(UltraWebGrid1);
    }

    protected void btnPDFExport_Click(object sender, EventArgs e)
    {
        FreightEasy.PNL.AirExportPNL pnlDS = new FreightEasy.PNL.AirExportPNL();
        pnlDS.GetAllRecords(elt_account_number, Session["MAWB"].ToString(), 
            "", "");
        DataSet ds = pnlDS;
        ReportSourceManager rsm = null;

        try
        {
            rsm = new ReportSourceManager();
            rsm.LoadDataSet(ds);
            rsm.LoadCompanyInfo(elt_account_number, Server.MapPath("../../../ClientLogos/" + elt_account_number + ".jpg"));
            rsm.WriteXSD(Server.MapPath("../../../CrystalReportResources/xsd/OceanExportPNL.xsd"));
            rsm.BindNow(Server.MapPath("../../../CrystalReportResources/rpt/OceanExportPNL.rpt"));
            Response.Clear();
            Response.Buffer = true;
            Response.ContentType = "application/pdf";
            Response.AddHeader("Content-Type", "application/pdf");
            Response.AddHeader("Content-disposition", "attachment;filename=OceanExportPNL_" + System.DateTime.Today.ToString("yyyy-MM-dd") + ".pdf");

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
}

