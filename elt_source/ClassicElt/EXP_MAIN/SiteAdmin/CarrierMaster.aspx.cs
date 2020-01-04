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

public partial class SiteAdmin_CarrierMaster : System.Web.UI.Page
{
    protected string ConnectStr, user_id, login_name, user_right, elt_account_number;

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            Session.LCID = 1033;

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
        obj.SelectCommand = @"SELECT * FROM carrier_master WHERE elt_account_number=" + elt_account_number;
    }

    protected void UltraWebGrid1_InitializeLayout(object sender, LayoutEventArgs e)
    {
        ColumnsCollection cCols = e.Layout.Bands[0].Columns;

        cCols.FromKey("auto_uid").Hidden = true;
        cCols.FromKey("elt_account_number").Hidden = true;
        cCols.FromKey("org_account_number").Hidden = true;

        cCols.FromKey("carrier_name").Header.Caption = "Carrier Name";
        cCols.FromKey("carrier_code_type").Header.Caption = "Code Type";
        cCols.FromKey("carrier_code").Header.Caption = "Carrier Code";
        cCols.FromKey("tran_type").Header.Caption = "Carrier Type";

        cCols.FromKey("carrier_name").Width = Unit.Pixel(150);

    }

    protected void UltraWebGrid1_InitializeRow(object sender, Infragistics.WebUI.UltraWebGrid.RowEventArgs e)
    {
        e.Row.Cells[0].Text = "<a href=\"javascript:;\" onclick=\"go_carrier('"
                + e.Row.Cells.FromKey("auto_uid") + "');\"><img src=\"../Images/button_edit.gif\" alt=\"\" /></a>";
    }

    protected void btnDelete_Click(object sender, EventArgs e)
    {
        ImageButton button = (ImageButton)sender;
        int rowIndex = int.Parse(button.CommandArgument);
        string cid = UltraWebGrid1.Rows[rowIndex].Cells.FromKey("auto_uid").Value.ToString();

        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        string[] tranStr = new string[1];

        tranStr[0] = "DELETE FROM carrier_master WHERE elt_account_number=" + elt_account_number+ " AND auto_uid=" + cid;

        if (!feData.DataTransactions(tranStr))
        {
            Response.Write(feData.GetLastTransactionError());
        }
        else
        {
            Response.Redirect("./CarrierMaster.aspx");
        }
    }
}
