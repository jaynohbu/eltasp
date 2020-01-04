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

public partial class ASPX_Misc_ManageSED : System.Web.UI.Page
{
    protected FreightEasy.DataManager.FreightEasyData AESListDS;
    protected string ConnectStr, user_id, login_name, user_right, elt_account_number;

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            Session.LCID = 1033;
            ConnectStr = (new igFunctions.DB().getConStr());

            if (!IsPostBack)
            {
            }
        }
        catch
        {
        }
    }

    protected void SqlDataSource1_Init(object sender, EventArgs e)
    {
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];

        SqlDataSource sqlDS = (SqlDataSource)sender;
        sqlDS.ConnectionString = (new igFunctions.DB().getConStr());
        sqlDS.SelectCommand = @"SELECT auto_uid,ISNULL(aes_status,'') AS aes_status,shipment_ref_no,aes_itn,shipper_acct,house_num,master_num
            ,consignee_acct,inter_consignee_acct,export_date,origin_state,dest_country,export_carrier,export_port,unloading_port,tran_date 
            FROM aes_master WHERE elt_account_number=" + elt_account_number + " AND ISNULL(file_type,'')='AE' ORDER BY last_modified desc";
    }

    protected void UltraWebGrid1_InitializeLayout(object sender, LayoutEventArgs e)
    {
        ColumnsCollection aesCols = e.Layout.Bands[0].Columns;

        FreightEasy.ClientProfiles.Clients clients = new FreightEasy.ClientProfiles.Clients();
        clients.GetClientsByType(elt_account_number, "Consignees");
        clients.GetClientsByType(elt_account_number, "Shippers");

        UltraGridColumn ConsigneeCol = UltraWebGrid1.Bands[0].Columns.FromKey("consignee_acct");
        ConsigneeCol.Type = ColumnType.DropDownList;
        ConsigneeCol.ValueList.DataSource = clients.Tables["Consignees"];
        ConsigneeCol.ValueList.DisplayMember = clients.Tables["Consignees"].Columns["dba_name"].ToString();
        ConsigneeCol.ValueList.ValueMember = clients.Tables["Consignees"].Columns["org_account_number"].ToString();
        ConsigneeCol.ValueList.DataBind();
        ConsigneeCol.ValueList.ValueListItems.Insert(0, new ValueListItem("", ""));

        UltraGridColumn InterConsigneeCol = UltraWebGrid1.Bands[0].Columns.FromKey("inter_consignee_acct");
        InterConsigneeCol.Type = ColumnType.DropDownList;
        InterConsigneeCol.ValueList.DataSource = clients.Tables["Consignees"];
        InterConsigneeCol.ValueList.DisplayMember = clients.Tables["Consignees"].Columns["dba_name"].ToString();
        InterConsigneeCol.ValueList.ValueMember = clients.Tables["Consignees"].Columns["org_account_number"].ToString();
        InterConsigneeCol.ValueList.DataBind();
        InterConsigneeCol.ValueList.ValueListItems.Insert(0, new ValueListItem("", ""));

        UltraGridColumn ShipperCol = UltraWebGrid1.Bands[0].Columns.FromKey("shipper_acct");
        ShipperCol.Type = ColumnType.DropDownList;
        ShipperCol.ValueList.DataSource = clients.Tables["Shippers"];
        ShipperCol.ValueList.DisplayMember = clients.Tables["Shippers"].Columns["dba_name"].ToString();
        ShipperCol.ValueList.ValueMember = clients.Tables["Shippers"].Columns["org_account_number"].ToString();
        ShipperCol.ValueList.DataBind();
        ShipperCol.ValueList.ValueListItems.Insert(0, new ValueListItem("", ""));

        aesCols.FromKey("shipment_ref_no").Header.Caption = "Ship Ref No";
        aesCols.FromKey("aes_status").Header.Caption = "AES Status";
        aesCols.FromKey("aes_itn").Header.Caption = "ITN No.";
        aesCols.FromKey("shipper_acct").Header.Caption = "USPPI";
        aesCols.FromKey("house_num").Header.Caption = "House AWB";
        aesCols.FromKey("master_num").Header.Caption = "Master AWB";
        aesCols.FromKey("consignee_acct").Header.Caption = "Consignee";
        aesCols.FromKey("inter_consignee_acct").Header.Caption = "Inter Consignee";
        aesCols.FromKey("export_date").Header.Caption = "Export Date";
        aesCols.FromKey("origin_state").Header.Caption = "Origin";
        aesCols.FromKey("dest_country").Header.Caption = "Destination";
        aesCols.FromKey("export_carrier").Header.Caption = "Carrier";
        aesCols.FromKey("export_port").Header.Caption = "From";
        aesCols.FromKey("unloading_port").Header.Caption = "To";
        aesCols.FromKey("tran_date").Header.Caption = "Submit Date";

        aesCols.FromKey("export_date").Format = "MM/dd/yyyy";
        aesCols.FromKey("tran_date").Format = "MM/dd/yyyy";

        aesCols.FromKey("auto_uid").Hidden = true;
        aesCols.FromKey("aes_status").Width = new Unit("80px");
        aesCols.FromKey("shipment_ref_no").Width = new Unit("90px");
        aesCols.FromKey("shipper_acct").Width = new Unit("160px");
        aesCols.FromKey("consignee_acct").Width = new Unit("160px");
        aesCols.FromKey("inter_consignee_acct").Width = new Unit("160px");
        aesCols.FromKey("export_date").Width = new Unit("70px");
        aesCols.FromKey("origin_state").Width = new Unit("40px");
        aesCols.FromKey("dest_country").Width = new Unit("65px");
        aesCols.FromKey("export_carrier").Width = new Unit("110px");
        aesCols.FromKey("export_port").Width = new Unit("40px");
        aesCols.FromKey("unloading_port").Width = new Unit("40px");
        aesCols.FromKey("tran_date").Width = new Unit("70px");

        aesCols.FromKey("shipment_ref_no").Hidden = true;
        aesCols.FromKey("consignee_acct").Hidden = true;
        aesCols.FromKey("inter_consignee_acct").Hidden = true;
        aesCols.FromKey("origin_state").Hidden = true;
        aesCols.FromKey("dest_country").Hidden = true;
        aesCols.FromKey("export_carrier").Hidden = true;
    }

    protected void UltraWebGrid1_InitializeRow(object sender, Infragistics.WebUI.UltraWebGrid.RowEventArgs e)
    {
        e.Row.Key = e.Row.Cells.FromKey("auto_uid").Text;
        e.Row.Cells.FromKey("shipment_ref_no").TargetURL = "javascript:EditAES('"
            + e.Row.Cells.FromKey("auto_uid").Text + "')";

        if (e.Row.Cells.FromKey("aes_status").Text == "")
        {
            e.Row.Cells.FromKey("aes_status").Text = "GET STATUS";
            e.Row.Cells.FromKey("aes_status").TargetURL = "javascript:get_itn_from_aes_direct(" + e.Row.Cells.FromKey("auto_uid") + ");";
        }
        else
        {
            e.Row.Cells.FromKey("aes_status").Text = e.Row.Cells.FromKey("aes_status").Text;
            e.Row.Cells.FromKey("aes_status").TargetURL = "javascript:get_itn_from_aes_direct(" + e.Row.Cells.FromKey("auto_uid") + ");";
        }

        //e.Row.Cells.FromKey("house_num").TargetURL = "/ASP/air_export/new_edit_hawb.asp?Edit=yes&HAWB=" + e.Row.Cells.FromKey("house_num").Text;
        //e.Row.Cells.FromKey("master_num").TargetURL = "/ASP/air_export/new_edit_mawb.asp?Edit=yes&MAWB=" + e.Row.Cells.FromKey("master_num").Text;

        e.Row.Cells.FromKey("house_num").TargetURL = "javascript:parent.window.location.href='" + "/AirExport/HAWB/" + Server.UrlEncode("Edit=yes&HAWB=" + e.Row.Cells.FromKey("house_num").Text) + "'";
        e.Row.Cells.FromKey("master_num").TargetURL = "javascript:parent.window.location.href='" + "/AirExport/MAWB/" + Server.UrlEncode("Edit=yes&MAWB=" + e.Row.Cells.FromKey("master_num").Text) + "'";

    }

    protected void btnEdit_Click(object sender, EventArgs e)
    {
        ImageButton button = (ImageButton)sender;
        int rowIndex = int.Parse(button.CommandArgument);
        string aesIndex = UltraWebGrid1.Rows[rowIndex].Cells.FromKey("auto_uid").Value.ToString();
        string click= "<script>OpenAES('" + aesIndex + "')</script>";
        ClientScript.RegisterClientScriptBlock(sender.GetType(),"OpenAES", click);

    }

    protected void btnDelete_Click(object sender, EventArgs e)
    {
        ImageButton button = (ImageButton)sender;
        int rowIndex = int.Parse(button.CommandArgument);
        string aesIndex = UltraWebGrid1.Rows[rowIndex].Cells.FromKey("auto_uid").Value.ToString();

        string[] sqlTxt = new string[2];
        FreightEasy.DataManager.FreightEasyData FEData = new FreightEasy.DataManager.FreightEasyData();
        sqlTxt[0] = "DELETE FROM aes_master WHERE elt_account_number=" + elt_account_number + " AND auto_uid=" + aesIndex;
        sqlTxt[1] = "DELETE FROM aes_detail WHERE elt_account_number=" + elt_account_number + " AND aes_id=" + aesIndex;

        if (!FEData.DataTransactions(sqlTxt))
        {
            txtResultBox.Text = FEData.GetLastTransactionError();
            txtResultBox.Visible = true;
        }
        else
        {
            Response.Redirect("ManageSED.aspx");
        }
    }

    protected void btnExcelExport_Click(object sender, ImageClickEventArgs e)
    {
        UltraWebGridExcelExporter1.Export(UltraWebGrid1);
    }

    protected void btnPDFExport_Click(object sender, ImageClickEventArgs e)
    {
        ReportDocument rd = new ReportDocument();
        string rptFile = Server.MapPath("/IFF_MAIN/CrystalReportResources/rpt/AESList.rpt");
        string xsdFile = Server.MapPath("/IFF_MAIN/CrystalReportResources/xsd/AESList.xsd");

        AESListDS = new FreightEasy.DataManager.FreightEasyData();
        string selectSQL = @"SELECT a.*, b.dba_name AS consignee_name, c.dba_name AS inter_consignee_name
            FROM aes_master a LEFT OUTER JOIN organization b ON (a.elt_account_number=b.elt_account_number AND a.consignee_acct=b.org_account_number) 
            LEFT OUTER JOIN organization c ON (a.elt_account_number=c.elt_account_number AND a.inter_consignee_acct=c.org_account_number)
            WHERE a.elt_account_number=" + elt_account_number + " AND ISNULL(file_type,'')='AE' ORDER BY a.last_modified desc";
        AESListDS.AddToDataSet("AESList", selectSQL);

        try
        {
            rd.Load(rptFile, OpenReportMethod.OpenReportByTempCopy);
            rd.SetDataSource(AESListDS.Copy());
            AESListDS.WriteXmlSchema(xsdFile);

            Response.Clear();
            Response.Buffer = true;
            Response.ContentType = "application/pdf";
            Response.AddHeader("Content-Type", "application/pdf");
            Response.AddHeader("Content-disposition", "attachment;filename=AESList.pdf");

            MemoryStream oStream = (MemoryStream)rd.ExportToStream(ExportFormatType.PortableDocFormat);
            Response.BinaryWrite(oStream.ToArray());
        }
        catch { }
        finally
        {
            rd.Close();
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
