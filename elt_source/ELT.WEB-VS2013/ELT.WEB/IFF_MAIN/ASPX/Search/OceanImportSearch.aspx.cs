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

public partial class ASPX_Search_OceanImportSearch : System.Web.UI.Page
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
            columns.FromKey("hawb_num").Header.Caption = "House AWB";
            columns.FromKey("masterNo").Header.Caption = "Master AWB";
            columns.FromKey("file#").Header.Caption = "File No.";
            columns.FromKey("sec").Header.Caption = "SEC";
            columns.FromKey("p1").Header.Caption = "Departure Port";
            columns.FromKey("p2").Header.Caption = "Destination Port";
            columns.FromKey("Shipper_name").Header.Caption = "Shipper";
            columns.FromKey("consignee_name").Header.Caption = "Consingee";
            columns.FromKey("CreatedDate").Header.Caption = "Date";

            columns.FromKey("hawb_num").Width = Unit.Percentage(10);
            columns.FromKey("masterNo").Width = Unit.Percentage(10);
            columns.FromKey("file#").Width = Unit.Percentage(10);
            columns.FromKey("sec").Width = Unit.Percentage(4);
            columns.FromKey("p1").Width = Unit.Percentage(10);
            columns.FromKey("p2").Width = Unit.Percentage(10);
            columns.FromKey("Shipper_name").Width = Unit.Percentage(15);
            columns.FromKey("consignee_name").Width = Unit.Percentage(15);
            columns.FromKey("CreatedDate").Width = Unit.Percentage(7);

            columns.FromKey("CreatedDate").Format = "MM/dd/yyyy";

            columns.FromKey("Shipper_acct").Hidden = true;
            columns.FromKey("consignee_acct").Hidden = true;
            columns.FromKey("agent_org_acct").Hidden = true;
            columns.FromKey("iType").Hidden = true;
            columns.FromKey("lastF#").Hidden = true;
        }

        if (lstSearchType.SelectedValue == "master")
        {
            columns.FromKey("masterNo").Header.Caption = "Master AWB";
            columns.FromKey("file#").Header.Caption = "File No.";
            columns.FromKey("sec").Header.Caption = "SEC";
            columns.FromKey("p1").Header.Caption = "Departure Port";
            columns.FromKey("p2").Header.Caption = "Destination Port";
            columns.FromKey("carrier").Header.Caption = "Carrier";
            columns.FromKey("export_agent_name").Header.Caption = "Export Agent";
            columns.FromKey("CreatedDate").Header.Caption = "Date";

            columns.FromKey("masterNo").Width = Unit.Percentage(10);
            columns.FromKey("file#").Width = Unit.Percentage(10);
            columns.FromKey("sec").Width = Unit.Percentage(4);
            columns.FromKey("p1").Width = Unit.Percentage(10);
            columns.FromKey("p2").Width = Unit.Percentage(10);
            columns.FromKey("carrier").Width = Unit.Percentage(15);
            columns.FromKey("export_agent_name").Width = Unit.Percentage(15);
            columns.FromKey("CreatedDate").Width = Unit.Percentage(7);

            columns.FromKey("CreatedDate").Format = "MM/dd/yyyy";

            columns.FromKey("agent_org_acct").Hidden = true;
            columns.FromKey("carrier_code").Hidden = true;
            columns.FromKey("agent_org_acct").Hidden = true;
            columns.FromKey("iType").Hidden = true;
        }
    }

    protected void UltraWebGrid1_InitializeRow(object sender, Infragistics.WebUI.UltraWebGrid.RowEventArgs e)
    {
        e.Row.Cells.FromKey("masterNo").TargetURL = "javascript:EditClickMAWB('" + e.Row.Cells.FromKey("iType").Text
            + "','" + e.Row.Cells.FromKey("masterNo").Text + "','" + e.Row.Cells.FromKey("sec").Text
            + "','" + e.Row.Cells.FromKey("agent_org_acct").Text + "');";
        e.Row.Cells.FromKey("file#").TargetURL = "javascript:EditClickFILE('" + e.Row.Cells.FromKey("iType").Text
            + "','" + e.Row.Cells.FromKey("file#").Text + "');";
        if (e.Row.Cells.FromKey("hawb_num") != null)
        {
            e.Row.Cells.FromKey("hawb_num").TargetURL = "javascript:EditClick('" + e.Row.Cells.FromKey("iType").Text
                + "','" + e.Row.Cells.FromKey("masterNo").Text + "','" + e.Row.Cells.FromKey("sec").Text
                + "','" + e.Row.Cells.FromKey("agent_org_acct").Text + "','" + e.Row.Cells.FromKey("hawb_num").Text + "');";
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
            txtSQL = "select a.hawb_num as hawb_num, b.MAWB_NUM as masterNo ,b.file_no as file#, a.sec,"
                + " a.Shipper_name as Shipper_name,Right(rtrim(b.MAWB_NUM),4) as lastF#, a.Shipper_acct as Shipper_acct ,a.consignee_name as consignee_name ,a.dep_port as p1, a.arr_port as p2, a.iType,a.agent_org_acct,"
                + " a.consignee_acct as consignee_acct,a.CreatedDate FROM import_hawb a left join import_mawb b "
                + " on (a.elt_account_number=b.elt_account_number and a.mawb_num=b.mawb_num) "
                + " where a.elt_account_number=" + elt_account_number + " and a.iType ='O' and b.iType='O' and len(a.HAWB_NUM)>0";

            // period filter
            if (Webdatetimeedit1.Text.Trim() != "")
            {
                txtSQL += " AND a.CreatedDate>=CAST('" + Webdatetimeedit1.Text + "' AS DATETIME)";
            }

            if (Webdatetimeedit2.Text.Trim() != "")
            {
                txtSQL += " AND a.CreatedDate<DATEADD(DAY,1,'" + Webdatetimeedit2.Text + "')";
            }

            if (hShipperAcct.Value != "" && hShipperAcct.Value != "0")
            {
                txtSQL += " AND a.shipper_acct=" + hShipperAcct.Value;
            }

            if (txtlast.Text != "")
            {
                txtSQL += "AND Right(RTRIM(b.MAWB_NUM),4) like N'" + txtlast.Text + "%'";
            }

            if (OriginPortSelect.SelectedIndex > 0)
            {
                txtSQL += " AND b.dep_code=N'" + OriginPortSelect.SelectedValue + "'";
            }

            if (DestPortSelect.SelectedIndex > 0)
            {
                txtSQL += " AND b.arr_code=N'" + DestPortSelect.SelectedValue + "'";
            }

            if (hConsigneeAcct.Value != "" && hConsigneeAcct.Value != "0")
            {
                txtSQL += " AND a.consignee_acct=" + hConsigneeAcct.Value;
            }

            if (NoPiece.Text != "")
            {
                txtSQL += " AND b.Pieces =" + NoPiece.Text;
            }

            if (LCNO.Text != "")
            {
                txtSQL += " AND a.desc1 like N'" + LCNO.Text + "%'";
            }

            if (CINO.Text != "")
            {
                txtSQL += " AND a.desc2 like N'" + CINO.Text + "%'";
            }

            if (OTH_REF_NO.Text != "")
            {
                txtSQL += " AND a.customer_ref like N'" + OTH_REF_NO.Text + "%'";
            }

            if (txtFileNo.Text != "")
            {
                txtSQL += " AND b.file_no like N'%" + txtFileNo.Text + "%'";
            }

            if (lstSearchNum.Text != "")
            {
                txtSQL += " AND a.MAWB_NUM like N'" + lstSearchNum.Text + "%'";
            }

            if (txtHouseNo.Text != "")
            {
                txtSQL += " AND a.HAWB_NUM like N'" + txtHouseNo.Text + "%'";
            }

            if (SaleDroplist.SelectedIndex > 0)
            {
                txtSQL += " AND a.SalesPerson like N'" + SaleDroplist.SelectedValue + "'";
            }

            txtSQL += " ORDER BY a.hawb_num";
        }

        if (lstSearchType.SelectedValue == "master")
        {
            txtSQL = "select a.MAWB_NUM as masterNo ,a.file_no as file#,a.sec,a.carrier,a.export_agent_name,"
                + " a.dep_port as p1, a.arr_port as p2, a.iType,a.agent_org_acct,a.carrier_code,a.CreatedDate"
                + " from import_mawb a left join import_hawb b "
                + " on (a.elt_account_number=b.elt_account_number and a.mawb_num=b.mawb_num) "
                + " where a.elt_account_number=" + elt_account_number + " and a.iType ='O'";

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
                txtSQL += " AND b.dep_code=N'" + OriginPortSelect.SelectedValue + "'";
            }

            if (DestPortSelect.SelectedIndex > 0)
            {
                txtSQL += " AND b.arr_code=N'" + DestPortSelect.SelectedValue + "'";
            }

            if (txtlast.Text != "")
            {
                txtSQL += "AND Right(rtrim(a.MAWB_NUM),4) like N'" + txtlast.Text + "%'";
            }

            if (hShipperAcct.Value != "" && hShipperAcct.Value != "0")
            {
                txtSQL += " AND b.shipper_acct=" + hShipperAcct.Value.ToString();
            }

            if (hConsigneeAcct.Value != "" && hConsigneeAcct.Value != "0")
            {
                txtSQL += " AND b.consignee_acct=" + hConsigneeAcct.Value.ToString();
            }

            if (NoPiece.Text != "")
            {
                txtSQL += " AND a.Pieces =" + NoPiece.Text;
            }

            if (txtFileNo.Text != "")
            {
                txtSQL += " AND a.file_no like N'" + txtFileNo.Text + "%'";
            }

            if (lstSearchNum.Text != "")
            {
                txtSQL += " AND a.MAWB_NUM like N'" + lstSearchNum.Text + "%'";
            }

            if (SaleDroplist.SelectedIndex > 0)
            {
                txtSQL += " AND a.SalesPerson like N'" + SaleDroplist.SelectedValue + "'";
            }

            txtSQL += " GROUP BY a.MAWB_NUM,a.file_no,a.sec,a.carrier,a.export_agent_name,a.dep_port,a.arr_port,a.iType,a.agent_org_acct,a.carrier_code,a.CreatedDate ORDER BY a.MAWB_NUM";
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
        FEData.AddToDataSet("SalesPersons", "select distinct(SalesPerson) from import_mawb where elt_account_number = " + elt_account_number + " and len(SalesPerson)>0 and SalesPerson <> 'none'order by SalesPerson DESC");
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
