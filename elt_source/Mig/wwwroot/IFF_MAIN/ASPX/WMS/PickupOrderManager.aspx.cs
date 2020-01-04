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

public partial class ASPX_WMS_PickupOrderManager : System.Web.UI.Page
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

        sqlDS.SelectCommand = @"SELECT auto_uid,po_num,file_type,MAWB_NUM,HAWB_NUM,Shipper_Name,Pickup_Name,Carrier_Name,Origin_Port_Code,Dest_Port_Code,ModifiedDate FROM pickup_order WHERE elt_account_number=" + elt_account_number;
    }

    protected void UltraWebGrid1_InitializeLayout(object sender, LayoutEventArgs e)
    {
        FreightEasy.ClientProfiles.Clients clients = new FreightEasy.ClientProfiles.Clients();
        clients.GetClientsByType(elt_account_number, "All");

        ColumnsCollection tmpCols = e.Layout.Bands[0].Columns;

        tmpCols.FromKey("auto_uid").Hidden = true;

        tmpCols.FromKey("po_num").Header.Caption = "Pickup Order No";
        tmpCols.FromKey("MAWB_NUM").Header.Caption = "Master AWB/BL";
        tmpCols.FromKey("HAWB_NUM").Header.Caption = "House AWB/BL";

        tmpCols.FromKey("Shipper_Name").Header.Caption = "Shipper";
        tmpCols.FromKey("Pickup_Name").Header.Caption = "Pickup From";
        tmpCols.FromKey("Carrier_Name").Header.Caption = "Delivery To";
        tmpCols.FromKey("Origin_Port_Code").Header.Caption = "From";
        tmpCols.FromKey("Dest_Port_Code").Header.Caption = "To";
        tmpCols.FromKey("ModifiedDate").Header.Caption = "Last Modified";
        tmpCols.FromKey("file_type").Header.Caption = "File Type";

        tmpCols.FromKey("ModifiedDate").Format = "MM/dd/yyyy";

        tmpCols.FromKey("file_type").Width = Unit.Pixel(60);
        tmpCols.FromKey("Shipper_Name").Width = Unit.Pixel(150);
        tmpCols.FromKey("Pickup_Name").Width = Unit.Pixel(150);
        tmpCols.FromKey("Carrier_Name").Width = Unit.Pixel(150);
        tmpCols.FromKey("Origin_Port_Code").Width = Unit.Pixel(50);
        tmpCols.FromKey("Dest_Port_Code").Width = Unit.Pixel(50);
        tmpCols.FromKey("ModifiedDate").Width = Unit.Pixel(80);
    }

    protected void UltraWebGrid1_InitializeRow(object sender, Infragistics.WebUI.UltraWebGrid.RowEventArgs e)
    {
        try
        {
            string file_type = e.Row.Cells.FromKey("file_type").Value.ToString();
            if (file_type == "AE")
            {
                e.Row.Cells.FromKey("HAWB_NUM").TargetURL = "/IFF_MAIN/ASP/air_export/new_edit_hawb.asp?Edit=yes&hawb=" + e.Row.Cells.FromKey("HAWB_NUM");
                e.Row.Cells.FromKey("MAWB_NUM").TargetURL = "/IFF_MAIN/ASP/air_export/new_edit_mawb.asp?Edit=yes&mawb=" + e.Row.Cells.FromKey("MAWB_NUM");
                e.Row.Cells.FromKey("file_type").Text = "Air Export";
            }

            if (file_type == "OE")
            {
                e.Row.Cells.FromKey("HAWB_NUM").TargetURL = "/IFF_MAIN/ASP/ocean_export/new_edit_hbol.asp?Edit=yes&hbol=" + e.Row.Cells.FromKey("HAWB_NUM");
                e.Row.Cells.FromKey("MAWB_NUM").TargetURL = "/IFF_MAIN/ASP/ocean_export/new_edit_mbol.asp?Edit=yes&BookingNum=" + e.Row.Cells.FromKey("MAWB_NUM");
                e.Row.Cells.FromKey("file_type").Text = "Ocean Export";
            }
        }
        catch { }
    }

    protected void btnEdit_Click(object sender, EventArgs e)
    {
        ImageButton button = (ImageButton)sender;
        int rowIndex = int.Parse(button.CommandArgument);
        string po_num = UltraWebGrid1.Rows[rowIndex].Cells.FromKey("po_num").Value.ToString();
        string auto_uid = UltraWebGrid1.Rows[rowIndex].Cells.FromKey("auto_uid").Value.ToString();
        string strURL = "/IFF_MAIN/ASP/pre_shipment/pickup_order.asp?mode=view&uid=" + auto_uid + "&po=" + po_num;

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

