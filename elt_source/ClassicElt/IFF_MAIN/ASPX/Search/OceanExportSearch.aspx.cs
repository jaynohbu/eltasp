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

public partial class ASPX_Search_OceanExportSearch : System.Web.UI.Page
{
    protected string user_id, login_name, user_right, elt_account_number;
    FreightEasy.DataManager.FreightEasyData FEData;

    protected void Page_Load(object sender, EventArgs e)
    {
        Session.LCID = 1033;
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];

        try
        {
            if (!IsPostBack)
            {
                FEData = new FreightEasy.DataManager.FreightEasyData();
                LoadPorts();
                LoadSalesPersons();
            }
        }
        catch
        {
        }
    }

    protected void UltraWebGrid1_InitializeLayout(object sender, LayoutEventArgs e)
    {
        ColumnsCollection columns = e.Layout.Bands[0].Columns;

        if (lstSearchType.SelectedValue == "house")
        {
            columns.FromKey("houseNo").Header.Caption = "House B/L";
            columns.FromKey("booking_num").Header.Caption = "Booking No.";
            columns.FromKey("MasterNo").Header.Caption = "Master B/L";
            columns.FromKey("file#").Header.Caption = "File No.";
            columns.FromKey("p1").Header.Caption = "Departure Port";
            columns.FromKey("p2").Header.Caption = "Destination Port";
            columns.FromKey("shipper_name").Header.Caption = "Shipper";
            columns.FromKey("consignee_name").Header.Caption = "Consingee";
            columns.FromKey("agent").Header.Caption = "Agent";
            columns.FromKey("CreatedDate").Header.Caption = "Date";

            columns.FromKey("houseNo").Width = Unit.Percentage(10);
            columns.FromKey("booking_num").Width = Unit.Percentage(10);
            columns.FromKey("MasterNo").Width = Unit.Percentage(10);
            columns.FromKey("file#").Width = Unit.Percentage(8);
            columns.FromKey("p1").Width = Unit.Percentage(10);
            columns.FromKey("p2").Width = Unit.Percentage(10);
            columns.FromKey("shipper_name").Width = Unit.Percentage(10);
            columns.FromKey("consignee_name").Width = Unit.Percentage(10);
            columns.FromKey("agent").Width = Unit.Percentage(10);
            columns.FromKey("CreatedDate").Width = Unit.Percentage(7);
            columns.FromKey("Type").Width = Unit.Percentage(5);

            columns.FromKey("CreatedDate").Format = "MM/dd/yyyy";

            columns.FromKey("is_sub").Hidden = true;
            columns.FromKey("is_master").Hidden = true;
            columns.FromKey("shipper_no").Hidden = true;
            columns.FromKey("consignee_no").Hidden = true;
            columns.FromKey("agent_no").Hidden = true;
            columns.FromKey("lastF#").Hidden = true;
            columns.FromKey("measurement").Hidden = true;
        }

        if (lstSearchType.SelectedValue == "master")
        {
            columns.FromKey("booking_num").Header.Caption = "Booking No.";
            columns.FromKey("MasterNo").Header.Caption = "Master B/L";
            columns.FromKey("file#").Header.Caption = "File No.";
            columns.FromKey("p1").Header.Caption = "Departure Port";
            columns.FromKey("p2").Header.Caption = "Destination Port";
            columns.FromKey("shipper_name").Header.Caption = "Shipper";
            columns.FromKey("consignee_name").Header.Caption = "Consingee";
            columns.FromKey("agent").Header.Caption = "Agent";
            columns.FromKey("CreatedDate").Header.Caption = "Date";

            columns.FromKey("booking_num").Width = Unit.Percentage(10);
            columns.FromKey("MasterNo").Width = Unit.Percentage(10);
            columns.FromKey("file#").Width = Unit.Percentage(8);
            columns.FromKey("p1").Width = Unit.Percentage(10);
            columns.FromKey("p2").Width = Unit.Percentage(10);
            columns.FromKey("shipper_name").Width = Unit.Percentage(10);
            columns.FromKey("consignee_name").Width = Unit.Percentage(10);
            columns.FromKey("agent").Width = Unit.Percentage(10);
            columns.FromKey("CreatedDate").Width = Unit.Percentage(7);
            columns.FromKey("Status").Width = Unit.Percentage(5);
            columns.FromKey("Type").Width = Unit.Percentage(5);

            columns.FromKey("CreatedDate").Format = "MM/dd/yyyy";

            columns.FromKey("shipper_no").Hidden = true;
            columns.FromKey("consignee_no").Hidden = true;
            columns.FromKey("lastF#").Hidden = true;
            columns.FromKey("measurement").Hidden = true;
        }
    }

    protected void UltraWebGrid1_InitializeRow(object sender, Infragistics.WebUI.UltraWebGrid.RowEventArgs e)
    {
        e.Row.Cells.FromKey("booking_num").TargetURL = "javascript:EditBookClick('" + e.Row.Cells.FromKey("booking_num").Text + "');";
        e.Row.Cells.FromKey("MasterNo").TargetURL = "javascript:EditClick('" + e.Row.Cells.FromKey("MasterNo").Text + "');";
        e.Row.Cells.FromKey("file#").TargetURL = "javascript:EditClickFILE('" + e.Row.Cells.FromKey("file#").Text + "');";
        if (e.Row.Cells.FromKey("houseNo") != null)
        {
            e.Row.Cells.FromKey("houseNo").TargetURL = "javascript:EditClickHAWB('" + e.Row.Cells.FromKey("houseNo").Text + "');";
        }
    }

    protected void btnGo_Click(object sender, ImageClickEventArgs e)
    {
        string txtSQL = BuildSearchSQL();
        SetFreightEasyData(txtSQL);
    }

    protected void SetFreightEasyData(string txtSQL)
    {
        UltraWebGrid1.Clear();
        FEData = new FreightEasy.DataManager.FreightEasyData();
        FEData.AddToDataSet("SearchList", txtSQL);
        UltraWebGrid1.DataSource = FEData.Tables["SearchList"].DefaultView;
        UltraWebGrid1.DataBind();
        UltraWebGrid1.DisplayLayout.Pager.CurrentPageIndex = 1;
        txtResultBox.Text = FEData.Tables["SearchList"].Rows.Count.ToString() + " Records Found.";
        btnExcelExport.Visible = true;
    }

    protected string BuildSearchSQL()
    {
        string txtSQL = "";

        if (lstSearchType.SelectedValue == "house")
        {
            txtSQL = "select a.hbol_NUM as houseNo,a.booking_num,a.mbol_NUM as MasterNo,isnull(b.file_no,'') as file#,"
                + "a.shipper_name as shipper_name,a.shipper_acct_num as shipper_no ,a.measurement as measurement,a.consignee_name "
                + "AS consignee_name, a.consignee_acct_num as consignee_no, a.is_master as is_master,a.is_sub as is_sub, Right(rtrim(a.mbol_NUM),4) as lastF#,a.agent_name "
                + "AS agent, a.agent_no as agent_no,a.loading_port as p1,a.unloading_port as p2,CASE WHEN a.is_master='Y' THEN 'Master House' WHEN a.is_sub='Y' THEN 'Sub House' END AS Type,"
                + "a.CreatedDate from hbol_master a left outer join ocean_booking_number b "
                + "ON a.elt_account_number = b.elt_account_number and a.booking_num = b.booking_num where a.elt_account_number =" + elt_account_number;

            // period filter
            if (Webdatetimeedit1.Text.Trim() != "")
            {
                txtSQL += " AND a.CreatedDate>=CAST('" + Webdatetimeedit1.Text + "' AS DATETIME)";
            }

            if (Webdatetimeedit2.Text.Trim() != "")
            {
                txtSQL += " AND a.CreatedDate<DATEADD(DAY,1,'" + Webdatetimeedit2.Text + "')";
            }

            if (lstBookingNum.Text != "")
            {
                txtSQL += " AND a.booking_num like N'%" + lstBookingNum.Text + "%'";
            }

            if (lstShipperName.Text != "")
            {
                txtSQL += " AND a.shipper_name like N'%" + lstShipperName.Text + "%'";
            }

            if (OriginPortSelect.SelectedIndex > 0)
            {
                txtSQL += " AND b.origin_port_id='" + OriginPortSelect.SelectedValue + "'";
            }

            if (DestPortSelect.SelectedIndex > 0)
            {
                txtSQL += " AND b.dest_port_id='" + DestPortSelect.SelectedValue + "'";
            }

            if (hConsigneeAcct.Value != "" && hConsigneeAcct.Value != "0")
            {
                txtSQL += " AND a.consignee_acct_num=" + hConsigneeAcct.Value;

            }

            if (NoPiece.Text != "")
            {
                txtSQL += " AND a.Pieces =" + NoPiece.Text;
            }

            if (LCNO.Text != "")
            {
                txtSQL += " AND a.lc like N'" + LCNO.Text + "%'";
            }

            if (CINO.Text != "")
            {
                txtSQL += " AND a.ci like N'" + CINO.Text + "%'";
            }

            if (OTH_REF_NO.Text != "")
            {
                txtSQL += " AND a.export_ref like N'%" + OTH_REF_NO.Text + "%'";
            }

            if (txtFileNo.Text != "")
            {
                txtSQL += " AND b.file_no like N'%" + txtFileNo.Text + "%'";
            }

            if (lstSearchNum.Text != "")
            {
                txtSQL += " AND a.mbol_NUM like N'%" + lstSearchNum.Text + "%'";
            }

            if (txtHouseNo.Text != "")
            {
                txtSQL += " AND a.hbol_NUM like N'%" + txtHouseNo.Text + "%'";
            }

            if (lstAgentName.Text != "")
            {
                txtSQL += " AND a.Agent_name like N'%" + lstAgentName.Text + "%'";
            }

            if (lstHouseType.SelectedValue == "Sub")
            {
                txtSQL += " AND a.is_sub='Y'";
            }

            if (lstHouseType.SelectedValue == "Master")
            {
                txtSQL += " AND a.is_master='Y'";
            }

            if (TxtWeight.Text != "")
            {
                double weight = double.Parse(TxtWeight.Text);
                if (WeightSelect.SelectedIndex == 1)
                {
                    weight = weight / 2.2;
                }
                txtSQL += " AND a.Gross_Weight='" + weight + "'";
            }

            if (VesselName.Text != "")
            {
                txtSQL += " AND b.vsl_name like N'%" + VesselName.Text + "%'";
            }

            if (TxtCBM.Text != "")
            {
                txtSQL += " AND a.measurement like N'" + TxtCBM.Text + "%'";
            }

            if (SaleDroplist.SelectedIndex > 0)
            {
                txtSQL += " AND a.SalesPerson like N'" + SaleDroplist.SelectedValue + "'";
            }

            txtSQL += " ORDER BY a.hbol_NUM";
        }

        if (lstSearchType.SelectedValue == "master")
        {
            txtSQL = "select a.booking_num as booking_num ,a.mbol_NUM as MasterNo,isnull(b.file_no,'') as file#,"
                + "a.shipper_name as shipper_name,a.shipper_acct_num as shipper_no,a.measurement as measurement,a.consignee_name as consignee_name,Right(rtrim(a.mbol_NUM),4)"
                + " as lastF#,a.consignee_acct_num as consignee_no,a.agent_name as agent,a.loading_port as p1,a.unloading_port as p2,"
                + "CASE WHEN b.Status='B' THEN 'Booked' WHEN b.Status='C' THEN 'Closed' WHEN b.Status='A' THEN 'Assigned' END AS Status,CASE WHEN a.booking_num IN (select booking_num from hbol_master where elt_account_number= " + elt_account_number + " and booking_num <> '' ) THEN 'Consol' ELSE 'Direct' END AS Type,"
                + "a.CreatedDate from mbol_master a LEFT JOIN ocean_booking_number b"
                + " on (a.elt_account_number = b.elt_account_number and a.booking_num = b.booking_num) where a.elt_account_number =" + elt_account_number;

            // period filter
            if (Webdatetimeedit1.Text.Trim() != "")
            {
                txtSQL += " AND a.CreatedDate>=CAST('" + Webdatetimeedit1.Text + "' AS DATETIME)";
            }

            if (Webdatetimeedit2.Text.Trim() != "")
            {
                txtSQL += " AND a.CreatedDate<DATEADD(DAY,1,'" + Webdatetimeedit2.Text + "')";
            }

            if (OriginPortSelect.SelectedIndex > 0)
            {
                txtSQL += " AND b.origin_port_id='" + OriginPortSelect.SelectedValue + "'";
            }

            if (DestPortSelect.SelectedIndex > 0)
            {
                txtSQL += " AND b.dest_port_id='" + DestPortSelect.SelectedValue + "'";
            }

            if (lstShipperName.Text != "")
            {
                txtSQL += " AND a.shipper_name like N'%" + lstShipperName.Text + "%'";
            }

            if (hConsigneeAcct.Value != "" && hConsigneeAcct.Value != "0")
            {
                txtSQL += " AND a.consignee_acct_num=" + hConsigneeAcct.Value;
            }

            if (lstBookingNum.Text != "")
            {
                txtSQL += " AND a.booking_num like N'%" + lstBookingNum.Text + "%'";
            }

            if (NoPiece.Text != "")
            {
                txtSQL += " AND a.Pieces =" + NoPiece.Text;
            }

            if (txtFileNo.Text != "")
            {
                txtSQL += " AND b.file_no like N'%" + txtFileNo.Text + "%'";
            }
            if (lstSearchNum.Text != "")
            {
                txtSQL += " AND a.mbol_NUM like N'%" + lstSearchNum.Text + "%'";
            }

            if (TxtWeight.Text != "")
            {
                double weight = double.Parse(TxtWeight.Text);
                if (WeightSelect.SelectedIndex == 1)
                {
                    weight = weight / 2.2;
                }
                txtSQL += " AND a.Gross_Weight='" + weight + "'";
            }

            if (VesselName.Text != "")
            {
                txtSQL += " AND b.vsl_name like N'%" + VesselName.Text + "%'";
            }

            if (TxtCBM.Text != "")
            {
                txtSQL += " AND a.measurement like N'" + TxtCBM.Text + "%'";
            }

            if (lstShipmentType.SelectedValue == "Consol")
            {
                txtSQL += "AND a.booking_num IN (select booking_num from hbol_master where elt_account_number= " + elt_account_number + " and booking_num <> '' )";
            }

            if (lstShipmentType.SelectedValue == "Direct")
            {
                txtSQL += "AND a.booking_num Not IN (select booking_num from hbol_master where elt_account_number= " + elt_account_number + " and booking_num <> '' )";
            }

            if (lstMasterStatus.SelectedValue == "Closed")
            {
                txtSQL += " AND b.Status like N'%C%'";
            }

            if (lstMasterStatus.SelectedValue == "Used")
            {
                txtSQL += " AND b.Status NOT like N'%C%'";
            }

            if (SaleDroplist.SelectedIndex > 0)
            {
                txtSQL += " AND a.SalesPerson like N'" + SaleDroplist.SelectedValue + "'";

            }
            txtSQL += " ORDER BY a.booking_num";
        }

        return txtSQL;
    }

    protected void LoadPorts()
    {
        FEData.AddToDataSet("Ports", "SELECT port_code + ' - ' + port_desc as port_name,port_code FROM port WHERE elt_account_number=" + elt_account_number + " ORDER BY port_desc");
        OriginPortSelect.DataSource = FEData.Tables["Ports"].DefaultView;
        OriginPortSelect.DataTextField = "port_name";
        OriginPortSelect.DataValueField = "port_code";
        OriginPortSelect.DataBind();
        OriginPortSelect.Items.Insert(0, new ListItem("", ""));
        DestPortSelect.DataSource = FEData.Tables["Ports"].DefaultView;
        DestPortSelect.DataTextField = "port_name";
        DestPortSelect.DataValueField = "port_code";
        DestPortSelect.DataBind();
        DestPortSelect.Items.Insert(0, new ListItem("", ""));
    }

    protected void LoadSalesPersons()
    {
        FEData.AddToDataSet("SalesPersons", "select distinct(SalesPerson) from MBOL_MASTER where elt_account_number = " + elt_account_number + " and len(SalesPerson)>0 and SalesPerson <> 'none'order by SalesPerson DESC");
        SaleDroplist.DataSource = FEData.Tables["SalesPersons"].DefaultView;
        SaleDroplist.DataTextField = "SalesPerson";
        SaleDroplist.DataValueField = "SalesPerson";
        SaleDroplist.DataBind();
        SaleDroplist.Items.Insert(0, new ListItem("", ""));
    }

    protected void btnExcelExport_Click(object sender, ImageClickEventArgs e)
    {
        UltraWebGridExcelExporter1.DownloadName = "SearchList.xls";
        UltraWebGridExcelExporter1.Export(UltraWebGrid1);
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
