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

public partial class SiteAdmin_SBMaster : System.Web.UI.Page
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
        obj.SelectCommand = @"SELECT auto_uid,sb,sb_unit1,sb_unit2,description,export_code,license_type,eccn FROM scheduleB WHERE elt_account_number=" + elt_account_number + " ORDER BY description";
    }

    protected void UltraWebGrid1_InitializeLayout(object sender, LayoutEventArgs e)
    {
        ColumnsCollection SBCols = e.Layout.Bands[0].Columns;

        SBCols.FromKey("auto_uid").Hidden = true;
        SBCols.FromKey("sb").Header.Caption = "Schedule B Code";
        SBCols.FromKey("description").Header.Caption = "Item Description";
        SBCols.FromKey("sb_unit1").Header.Caption = "Unit 1";
        SBCols.FromKey("sb_unit2").Header.Caption = "Unit 2";
        SBCols.FromKey("export_code").Header.Caption = "Export Code";
        SBCols.FromKey("license_type").Header.Caption = "License Type";
        SBCols.FromKey("eccn").Header.Caption = "ECCN";

        SBCols.FromKey("sb").Width = Unit.Pixel(100);
        SBCols.FromKey("description").Width = Unit.Pixel(250);
        SBCols.FromKey("sb_unit1").Width = Unit.Pixel(60);
        SBCols.FromKey("sb_unit2").Width = Unit.Pixel(60);
        SBCols.FromKey("export_code").Width = Unit.Pixel(70);
        SBCols.FromKey("license_type").Width = Unit.Pixel(70);
        SBCols.FromKey("eccn").Width = Unit.Pixel(70);
    }

    protected void UltraWebGrid1_InitializeRow(object sender, Infragistics.WebUI.UltraWebGrid.RowEventArgs e)
    {
        e.Row.Cells[0].Text = "<a href=\"javascript:;\" onclick=\"go_scheduleB("
                + e.Row.Cells.FromKey("auto_uid") + ");\"><img src=\"/ASP/images/button_edit.gif\" alt=\"\" border=\"\" /></a>";
    }

    protected void btnDelete_Click(object sender, EventArgs e)
    {
        ImageButton button = (ImageButton)sender;
        int rowIndex = int.Parse(button.CommandArgument);
        string SBID = UltraWebGrid1.Rows[rowIndex].Cells.FromKey("auto_uid").Value.ToString();

        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        string[] tranStr = new string[1];

        tranStr[0] += "DELETE FROM scheduleb WHERE elt_account_number=" + elt_account_number + " AND auto_uid=" + SBID;

        if (!feData.DataTransactions(tranStr))
        {
            Response.Write(feData.GetLastTransactionError());
        }
        else
        {
            Response.Redirect("./SBMaster.aspx");
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
