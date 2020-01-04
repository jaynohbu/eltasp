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


public partial class ASPX_Reports_OperationPNL_PNLResultAE : System.Web.UI.Page
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
        FreightEasy.PNL.AirExportPNL myDs = new FreightEasy.PNL.AirExportPNL();
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
        mawbCols.FromKey("shipper_account_number").Hidden = true;
        mawbCols.FromKey("createddate").Hidden = true;
        mawbCols.FromKey("createdby").Hidden = true;

        hawbCols.FromKey("elt_account_number").Hidden = true;
        hawbCols.FromKey("mawb_num").Hidden = true;
        hawbCols.FromKey("shipper_account_number").Hidden = true;
        hawbCols.FromKey("agent_no").Hidden = true;
        hawbCols.FromKey("createddate").Hidden = true;
        hawbCols.FromKey("modifiedby").Hidden = true;

        itemCols.FromKey("elt_account_number").Hidden = true;
        itemCols.FromKey("hawb_num").Hidden = true;
        itemCols.FromKey("mawb_num").Hidden = true;

        // renaming headers
        mawbCols.FromKey("mawb_num").Header.Caption = "Master AWB";
        mawbCols.FromKey("shipper_name").Header.Caption = "Shipper";
        mawbCols.FromKey("dep_airport_code").Header.Caption = "From";
        mawbCols.FromKey("to_1").Header.Caption = "To 1";
        mawbCols.FromKey("to_2").Header.Caption = "To 2";
        mawbCols.FromKey("total_gross_weight").Header.Caption = "Gross Wt.";
        mawbCols.FromKey("total_chargeable_weight").Header.Caption = "Charge Wt.";
        mawbCols.FromKey("weight_scale").Header.Caption = "Scale";
        mawbCols.FromKey("createddate").Header.Caption = "Created";
        mawbCols.FromKey("createdby").Header.Caption = "By";

        hawbCols.FromKey("hawb_num").Header.Caption = "House AWB";
        hawbCols.FromKey("shipper_name").Header.Caption = "Shipper";
        hawbCols.FromKey("agent_name").Header.Caption = "Agent";
        hawbCols.FromKey("total_chargeable_weight").Header.Caption = "Charge Wt.";
        hawbCols.FromKey("weight_scale").Header.Caption = "Scale";
        hawbCols.FromKey("createddate").Header.Caption = "Created";
        hawbCols.FromKey("modifiedby").Header.Caption = "By";

        itemCols.FromKey("item_type").Header.Caption = "Item Type";
        itemCols.FromKey("item_desc").Header.Caption = "Item Name";
        itemCols.FromKey("item_amount").Header.Caption = "Item Amount";
        itemCols.FromKey("vendor_no").Header.Caption = "Vendor";

        // format data
        mawbCols.FromKey("createddate").Format = "MM/dd/yyyy";
        hawbCols.FromKey("createddate").Format = "MM/dd/yyyy";

        FreightEasy.ClientProfiles.Clients clients = new FreightEasy.ClientProfiles.Clients();
        clients.GetClientsByType(elt_account_number, "All");
        UltraGridColumn vendorCol = itemCols.FromKey("vendor_no");
        vendorCol.Type = ColumnType.DropDownList;
        vendorCol.ValueList.DataSource = clients.Tables["All"];
        vendorCol.ValueList.DisplayMember = clients.Tables["All"].Columns["dba_name"].ToString();
        vendorCol.ValueList.ValueMember = clients.Tables["All"].Columns["org_account_number"].ToString();
        vendorCol.ValueList.DataBind();
        vendorCol.ValueList.ValueListItems.Insert(0, new ValueListItem("", 0));

        mawbCols.FromKey("mawb_num").Width = Unit.Pixel(120);
        mawbCols.FromKey("shipper_name").Width = Unit.Pixel(200);
        mawbCols.FromKey("dep_airport_code").Width = Unit.Pixel(50);
        mawbCols.FromKey("to_1").Width = Unit.Pixel(50);
        mawbCols.FromKey("to_2").Width = Unit.Pixel(50);
        mawbCols.FromKey("total_gross_weight").Width = Unit.Pixel(80);
        mawbCols.FromKey("total_chargeable_weight").Width = Unit.Pixel(80);
        mawbCols.FromKey("weight_scale").Width = Unit.Pixel(40);
        mawbCols.FromKey("Revenue").Width = Unit.Pixel(80);
        mawbCols.FromKey("Expense").Width = Unit.Pixel(80);
        mawbCols.FromKey("createddate").Width = Unit.Pixel(80);
        mawbCols.FromKey("createdby").Width = Unit.Pixel(80);
        mawbCols.FromKey("Profit").Width = Unit.Pixel(80);

        hawbCols.FromKey("hawb_num").Width = Unit.Pixel(138);
        hawbCols.FromKey("shipper_name").Width = Unit.Pixel(200);
        hawbCols.FromKey("agent_name").Width = Unit.Pixel(200);
        hawbCols.FromKey("total_chargeable_weight").Width = Unit.Pixel(80);
        hawbCols.FromKey("weight_scale").Width = Unit.Pixel(40);
        hawbCols.FromKey("Revenue").Width = Unit.Pixel(80);
        hawbCols.FromKey("Expense").Width = Unit.Pixel(80);
        hawbCols.FromKey("createddate").Width = Unit.Pixel(80);
        hawbCols.FromKey("modifiedby").Width = Unit.Pixel(80);
        hawbCols.FromKey("Profit").Width = Unit.Pixel(80);

        itemCols.FromKey("item_type").Width = Unit.Pixel(80);
        itemCols.FromKey("item_desc").Width = Unit.Pixel(160);
        itemCols.FromKey("item_amount").Width = Unit.Pixel(80);
        itemCols.FromKey("vendor_no").Width = Unit.Pixel(150);
    }

    protected void UltraWebGrid1_InitializeRow(object sender, Infragistics.WebUI.UltraWebGrid.RowEventArgs e)
    {
        try
        {
            if (e.Row.Cells.FromKey("mawb_num") != null)
            {
                e.Row.Cells.FromKey("mawb_num").TargetURL = "javascript:viewPop('/ASP/air_export/new_edit_mawb.asp?WindowName=popupNew&Edit=yes&MAWB=" + e.Row.Cells.FromKey("mawb_num").Text + "');"; 
            }

            try
            {
                if (e.Row.Cells.FromKey("hawb_num").Value == null)
                {
                    e.Row.Cells.FromKey("hawb_num").Text = "Direct Shipment";
                    e.Row.Cells.FromKey("Revenue").Text = "";
                    e.Row.Cells.FromKey("Expense").Text = "";
                    e.Row.Cells.FromKey("Profit").Text = "";
                }
                else
                {
                    e.Row.Cells.FromKey("hawb_num").TargetURL = "javascript:viewPop('/ASP/air_export/new_edit_hawb.asp?WindowName=popupNew&Edit=yes&HAWB=" + e.Row.Cells.FromKey("hawb_num").Text + "');"; 
                }
            }
            catch { }
        }
        catch (Exception ex){
            Response.Write(ex.Message);
        }
    }

    protected void btnExcelExport_Click(object sender, EventArgs e)
    {
        UltraWebGridExcelExporter1.DownloadName = "AirExportPNL.xls";
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
            rsm.WriteXSD(Server.MapPath("../../../CrystalReportResources/xsd/AirExportPNL.xsd"));
            rsm.BindNow(Server.MapPath("../../../CrystalReportResources/rpt/AirExportPNL.rpt"));
            Response.Clear();
            Response.Buffer = true;
            Response.ContentType = "application/pdf";
            Response.AddHeader("Content-Type", "application/pdf");
            Response.AddHeader("Content-disposition", "attachment;filename=AirExportPNL_" + System.DateTime.Today.ToString("yyyy-MM-dd") + ".pdf");

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
