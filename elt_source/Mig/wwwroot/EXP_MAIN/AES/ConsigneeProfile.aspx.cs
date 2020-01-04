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

public partial class AES_ConsigneeProfile : System.Web.UI.Page
{
    protected DataSet ds = null;
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

        SqlDataSource obj = (SqlDataSource)sender;
        obj.ConnectionString = (new igFunctions.DB().getConStr());
        obj.SelectCommand = @"SELECT org_account_number,dba_name,business_city,business_state,business_country,business_phone,business_fax,owner_fname,owner_lname,owner_phone,owner_email FROM organization WHERE elt_account_number=" + elt_account_number + " AND is_consignee='Y' ORDER BY dba_name";
    }

    protected void UltraWebGrid1_InitializeLayout(object sender, LayoutEventArgs e)
    {
        ColumnsCollection consigneeCols = e.Layout.Bands[0].Columns;

        consigneeCols.FromKey("dba_name").Header.Caption = "Company Name";
        consigneeCols.FromKey("business_city").Header.Caption = "City";
        consigneeCols.FromKey("business_state").Header.Caption = "State";
        consigneeCols.FromKey("business_country").Header.Caption = "Country";
        consigneeCols.FromKey("business_phone").Header.Caption = "Phone";
        consigneeCols.FromKey("business_fax").Header.Caption = "Fax";
        consigneeCols.FromKey("owner_fname").Header.Caption = "First Name";
        consigneeCols.FromKey("owner_lname").Header.Caption = "Last Name";
        consigneeCols.FromKey("owner_phone").Header.Caption = "Cell";
        consigneeCols.FromKey("owner_email").Header.Caption = "Email";

        consigneeCols.FromKey("org_account_number").Hidden = true;

        consigneeCols.FromKey("dba_name").Width = Unit.Pixel(200);
        consigneeCols.FromKey("business_city").Width = Unit.Pixel(120);
        consigneeCols.FromKey("business_state").Width = Unit.Pixel(40);
        consigneeCols.FromKey("business_country").Width = Unit.Pixel(120);
        consigneeCols.FromKey("business_phone").Width = Unit.Pixel(90);
        consigneeCols.FromKey("business_fax").Width = Unit.Pixel(90);
        consigneeCols.FromKey("owner_fname").Width = Unit.Pixel(100);
        consigneeCols.FromKey("owner_lname").Width = Unit.Pixel(100);
        consigneeCols.FromKey("owner_phone").Width = Unit.Pixel(90);
        consigneeCols.FromKey("owner_email").Width = Unit.Pixel(100);
    }

    protected void UltraWebGrid1_InitializeRow(object sender, Infragistics.WebUI.UltraWebGrid.RowEventArgs e)
    {
        e.Row.Cells[0].Text = "<a href=\"javascript:;\" onclick=\"go_consignee(" 
                + e.Row.Cells.FromKey("org_account_number") + ");\"><img src=\"../Images/button_edit.gif\" alt=\"\" /></a>";
    }

    protected void btnNewConsignee_Click(object sender, ImageClickEventArgs e)
    {

    }
}
