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

public partial class ASPX_OnLines_Rate_RateControl : System.Web.UI.UserControl
{
    public string elt_account_number = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"].ToString();
        WebNavBar1.GridID = UltraWebGrid1.UniqueID;
    }

    protected void UltraWebGrid1_UpdateGrid(object sender, UpdateEventArgs e)
    {
        Response.Redirect(Request.Url.ToString());
    }

    protected void UltraWebGrid1_InitializeLayout(object sender, LayoutEventArgs e)
    {
        ColumnsCollection routeCols = e.Layout.Bands[0].Columns;
        ColumnsCollection airlineCols = e.Layout.Bands[1].Columns;
        ColumnsCollection weightCols = e.Layout.Bands[2].Columns;

        //hiding uneccessary columns
        routeCols.FromKey("elt_account_number").Hidden = true;
        routeCols.FromKey("rate_type").Hidden = true;
        airlineCols.FromKey("origin_port").Hidden = true;
        airlineCols.FromKey("dest_port").Hidden = true;
        airlineCols.FromKey("kg_lb").Hidden = true;
        airlineCols.FromKey("elt_account_number").Hidden = true;
        airlineCols.FromKey("rate_type").Hidden = true;
        weightCols.FromKey("airline").Hidden = true;
        weightCols.FromKey("origin_port").Hidden = true;
        weightCols.FromKey("dest_port").Hidden = true;
        weightCols.FromKey("kg_lb").Hidden = true;
        weightCols.FromKey("airline").Hidden = true;
        weightCols.FromKey("item_no").Hidden = true;
        weightCols.FromKey("elt_account_number").Hidden = true;
        weightCols.FromKey("rate_type").Hidden = true;
        weightCols.FromKey("share").Hidden = true;
        weightCols.FromKey("fl_rate").Hidden = true;
        weightCols.FromKey("sec_rate").Hidden = true;
        weightCols.FromKey("include_fl_rate").Hidden = true;
        weightCols.FromKey("include_sec_rate").Hidden = true;

        // renaming headers
        routeCols.FromKey("origin_port").Header.Caption = "Origin Port";
        routeCols.FromKey("dest_port").Header.Caption = "Destination Port";
        routeCols.FromKey("kg_lb").Header.Caption = "Unit";
        airlineCols.FromKey("share").Header.Caption = "Share (%)";
        airlineCols.FromKey("airline").Header.Caption = "Airline (Code)";
        airlineCols.FromKey("fl_rate").Header.Caption = "Fuel Sur (%)";
        airlineCols.FromKey("sec_rate").Header.Caption = "Security Sur (%)";
        airlineCols.FromKey("include_fl_rate").Header.Caption = "Fuel Profit Sharing";
        airlineCols.FromKey("include_sec_rate").Header.Caption = "Security Profit Sharing";
        weightCols.FromKey("weight_break").Header.Caption = "Weight Break";
        weightCols.FromKey("rate").Header.Caption = "Rate (%)";

        ////////////////////////////////////////////////////////////////////

        FreightEasy.Ports.ALLPorts ports = new FreightEasy.Ports.ALLPorts();
        ports.GetAllPorts(elt_account_number, "All");
        FreightEasy.ClientProfiles.Clients clients = new FreightEasy.ClientProfiles.Clients();
        clients.GetClientsByType(elt_account_number, "Airlines");

        //////////////////////////////////////////////////////////////////////

        UltraGridColumn KgLbCol = UltraWebGrid1.Bands[0].Columns.FromKey("kg_lb");
        KgLbCol.Type = ColumnType.DropDownList;
        KgLbCol.ValueList.ValueListItems.Add(new ValueListItem("LB", "L"));
        KgLbCol.ValueList.ValueListItems.Add(new ValueListItem("KG", "K"));
        KgLbCol.ValueList.Style.Font.Size = FontUnit.Point(8);
        KgLbCol.Width = Unit.Pixel(80);

        UltraGridColumn OriginPortCol = UltraWebGrid1.Bands[0].Columns.FromKey("origin_port");
        OriginPortCol.Type = ColumnType.DropDownList;
        OriginPortCol.ValueList.DataSource = ports.Tables["All"]; ;
        OriginPortCol.ValueList.DisplayMember = ports.Tables["All"].Columns["port_display"].ToString();
        OriginPortCol.ValueList.ValueMember = ports.Tables["All"].Columns["port_code"].ToString();
        OriginPortCol.ValueList.DataBind();
        OriginPortCol.ValueList.Style.Font.Size = FontUnit.Point(8);
        OriginPortCol.Width = Unit.Pixel(200);

        UltraGridColumn DestPortCol = UltraWebGrid1.Bands[0].Columns.FromKey("dest_port");
        DestPortCol.Type = ColumnType.DropDownList;
        DestPortCol.ValueList.DataSource = ports.Tables["All"];
        DestPortCol.ValueList.DisplayMember = ports.Tables["All"].Columns["port_display"].ToString();
        DestPortCol.ValueList.ValueMember = ports.Tables["All"].Columns["port_code"].ToString();
        DestPortCol.ValueList.DataBind();
        DestPortCol.ValueList.Style.Font.Size = FontUnit.Point(8);
        DestPortCol.Width = Unit.Pixel(200);

        UltraGridColumn AirlineCol = UltraWebGrid1.Bands[1].Columns.FromKey("airline");
        AirlineCol.Type = ColumnType.DropDownList;
        AirlineCol.ValueList.DataSource = clients.Tables["Airlines"];
        AirlineCol.ValueList.DisplayMember = clients.Tables["Airlines"].Columns["airline_display"].ToString();
        AirlineCol.ValueList.ValueMember = clients.Tables["Airlines"].Columns["carrier_code"].ToString();
        AirlineCol.ValueList.DataBind();
        AirlineCol.ValueList.Style.Font.Size = FontUnit.Point(8);
        AirlineCol.Width = Unit.Pixel(250);

        UltraGridColumn IncFlRateCol = UltraWebGrid1.Bands[1].Columns.FromKey("include_fl_rate");
        IncFlRateCol.Type = ColumnType.DropDownList;
        IncFlRateCol.ValueList.ValueListItems.Add(new ValueListItem("Yes", "Y"));
        IncFlRateCol.ValueList.ValueListItems.Add(new ValueListItem("No", "N"));
        IncFlRateCol.ValueList.Style.Font.Size = FontUnit.Point(8);
        IncFlRateCol.Width = Unit.Pixel(100);

        UltraGridColumn IncSecRateCol = UltraWebGrid1.Bands[1].Columns.FromKey("include_sec_rate");
        IncSecRateCol.Type = ColumnType.DropDownList;
        IncSecRateCol.ValueList.ValueListItems.Add(new ValueListItem("Yes", "Y"));
        IncSecRateCol.ValueList.ValueListItems.Add(new ValueListItem("No", "N"));
        IncSecRateCol.ValueList.Style.Font.Size = FontUnit.Point(8);
        IncSecRateCol.Width = Unit.Pixel(120);

        UltraWebGrid1.Bands[1].Columns.FromKey("share").Width = Unit.Pixel(80);
        UltraWebGrid1.Bands[1].Columns.FromKey("fl_rate").Width = Unit.Pixel(80);
        UltraWebGrid1.Bands[1].Columns.FromKey("sec_rate").Width = Unit.Pixel(90);
    }
}
