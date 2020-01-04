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

public partial class ASPX_WMS_ShipoutManager : System.Web.UI.Page
{
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

        sqlDS.SelectCommand = @"SELECT auto_uid,so_num,file_type,house_num,master_num,customer_acct,consignee_acct,created_date,shipout_date FROM warehouse_shipout WHERE elt_account_number=" + elt_account_number;
    }

    protected void UltraWebGrid1_InitializeLayout(object sender, LayoutEventArgs e)
    {
        FreightEasy.ClientProfiles.Clients clients = new FreightEasy.ClientProfiles.Clients();
        clients.GetClientsByType(elt_account_number, "All");

        UltraGridColumn ConsigneeCol = UltraWebGrid1.Bands[0].Columns.FromKey("consignee_acct");
        ConsigneeCol.Type = ColumnType.DropDownList;
        ConsigneeCol.ValueList.DataSource = clients.Tables["All"];
        ConsigneeCol.ValueList.DisplayMember = clients.Tables["All"].Columns["dba_name"].ToString();
        ConsigneeCol.ValueList.ValueMember = clients.Tables["All"].Columns["org_account_number"].ToString();
        ConsigneeCol.ValueList.DataBind();
        ConsigneeCol.ValueList.ValueListItems.Insert(0, new ValueListItem("", ""));

        UltraGridColumn ShipperCol = UltraWebGrid1.Bands[0].Columns.FromKey("customer_acct");
        ShipperCol.Type = ColumnType.DropDownList;
        ShipperCol.ValueList.DataSource = clients.Tables["All"];
        ShipperCol.ValueList.DisplayMember = clients.Tables["All"].Columns["dba_name"].ToString();
        ShipperCol.ValueList.ValueMember = clients.Tables["All"].Columns["org_account_number"].ToString();
        ShipperCol.ValueList.DataBind();
        ShipperCol.ValueList.ValueListItems.Insert(0, new ValueListItem("", ""));

        ColumnsCollection tmpCols = e.Layout.Bands[0].Columns;

        tmpCols.FromKey("created_date").Format = "MM/dd/yyyy";
        tmpCols.FromKey("shipout_date").Format = "MM/dd/yyyy";

        tmpCols.FromKey("auto_uid").Hidden = true;

        tmpCols.FromKey("so_num").Header.Caption = "Shipout No";
        tmpCols.FromKey("created_date").Header.Caption = "Created Date";
        tmpCols.FromKey("shipout_date").Header.Caption = "Shipout Date";
        tmpCols.FromKey("consignee_acct").Header.Caption = "Ship To";
        tmpCols.FromKey("customer_acct").Header.Caption = "Customer";
        tmpCols.FromKey("file_type").Header.Caption = "File Type";
        tmpCols.FromKey("house_num").Header.Caption = "House AWB/BL";
        tmpCols.FromKey("master_num").Header.Caption = "Master AWB/BL";
        tmpCols.FromKey("file_type").Header.Caption = "File Type";
    }

    protected void UltraWebGrid1_InitializeRow(object sender, Infragistics.WebUI.UltraWebGrid.RowEventArgs e)
    {
        try
        {
            string file_type = e.Row.Cells.FromKey("file_type").Value.ToString();

            if (file_type == "AE")
            {
                //e.Row.Cells.FromKey("house_num").TargetURL = "/ASP/air_export/new_edit_hawb.asp?Edit=yes&hawb=" + e.Row.Cells.FromKey("house_num");
                //e.Row.Cells.FromKey("master_num").TargetURL = "/ASP/air_export/new_edit_mawb.asp?Edit=yes&mawb=" + e.Row.Cells.FromKey("master_num");

                e.Row.Cells.FromKey("house_num").TargetURL = "javascript:parent.window.location.href='"+"/AirExport/HAWB/" + Server.UrlEncode("Edit=yes&HAWB=" + e.Row.Cells.FromKey("house_num").Text)+"'";
                e.Row.Cells.FromKey("master_num").TargetURL = "javascript:parent.window.location.href='" + "/AirExport/MAWB/" + Server.UrlEncode("Edit=yes&MAWB=" + e.Row.Cells.FromKey("master_num").Text) + "'";

                e.Row.Cells.FromKey("file_type").Text = "Air Export";
            }

            if (file_type == "OE")
            {
                //e.Row.Cells.FromKey("house_num").TargetURL = "/ASP/ocean_export/new_edit_hbol.asp?Edit=yes&hbol=" + e.Row.Cells.FromKey("house_num");
                //e.Row.Cells.FromKey("master_num").TargetURL = "/ASP/ocean_export/new_edit_mbol.asp?Edit=yes&BookingNum=" + e.Row.Cells.FromKey("master_num");


                e.Row.Cells.FromKey("house_num").TargetURL = "javascript:parent.window.location.href='" + "/OceanExport/HBOL/" + Server.UrlEncode("Edit=yes&HBOL=" + e.Row.Cells.FromKey("house_num").Text) + "'";
                e.Row.Cells.FromKey("master_num").TargetURL = "javascript:parent.window.location.href='" + "/OceanExport/MAWB/" + Server.UrlEncode("Edit=yes&BookingNum=" + e.Row.Cells.FromKey("master_num").Text) + "'";

                e.Row.Cells.FromKey("file_type").Text = "Ocean Export";

            }
        }
        catch { }
    }

    protected void btnEdit_Click(object sender, EventArgs e)
    {
        ImageButton button = (ImageButton)sender;
        int rowIndex = int.Parse(button.CommandArgument);
        string so_num = UltraWebGrid1.Rows[rowIndex].Cells.FromKey("so_num").Value.ToString();
        string auto_uid = UltraWebGrid1.Rows[rowIndex].Cells.FromKey("auto_uid").Value.ToString();
        string strURL = "/ASP/WMS/shipout_detail.asp?mode=view&uid=" + auto_uid + "&so=" + so_num;
        
        Response.Redirect(strURL);
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
