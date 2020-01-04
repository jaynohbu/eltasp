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

public partial class SiteAdmin_PortMaster : System.Web.UI.Page
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
        obj.SelectCommand = @"SELECT port_code,port_id,port_desc,port_city,port_state,port_country_code FROM port WHERE elt_account_number=" + elt_account_number + " ORDER BY port_code";
    }

    protected void UltraWebGrid1_InitializeLayout(object sender, LayoutEventArgs e)
    {
        ColumnsCollection portCols = e.Layout.Bands[0].Columns;

        portCols.FromKey("port_code").Header.Caption = "Port Code";
        portCols.FromKey("port_id").Header.Caption = "AES Code";
        portCols.FromKey("port_desc").Header.Caption = "Port Description";
        portCols.FromKey("port_city").Header.Caption = "Port City";
        portCols.FromKey("port_state").Header.Caption = "State";
        portCols.FromKey("port_country_code").Header.Caption = "Country";

        portCols.FromKey("port_code").Width = Unit.Pixel(60);
        portCols.FromKey("port_id").Width = Unit.Pixel(80);
        portCols.FromKey("port_desc").Width = Unit.Pixel(120);
        portCols.FromKey("port_city").Width = Unit.Pixel(120);
        portCols.FromKey("port_state").Width = Unit.Pixel(40);
        portCols.FromKey("port_country_code").Width = Unit.Pixel(120);

        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        feData.AddToDataSet("Countries", "SELECT * FROM country_code WHERE elt_account_number=" + elt_account_number + " ORDER BY country_name");

        portCols.FromKey("port_country_code").Type = ColumnType.DropDownList;
        portCols.FromKey("port_country_code").ValueList.DataSource = feData.Tables["Countries"];
        portCols.FromKey("port_country_code").ValueList.DisplayMember = feData.Tables["Countries"].Columns["country_name"].ToString();
        portCols.FromKey("port_country_code").ValueList.ValueMember = feData.Tables["Countries"].Columns["country_code"].ToString();
        portCols.FromKey("port_country_code").ValueList.DataBind();
        portCols.FromKey("port_country_code").ValueList.ValueListItems.Insert(0, new ValueListItem("", 0));
    
        
    }

    protected void UltraWebGrid1_InitializeRow(object sender, Infragistics.WebUI.UltraWebGrid.RowEventArgs e)
    {
        e.Row.Cells[0].Text = "<a href=\"javascript:;\" onclick=\"go_port('"
                + e.Row.Cells.FromKey("port_code") + "');\"><img src=\"../Images/button_edit.gif\" alt=\"\" /></a>";
    }

    protected void btnDelete_Click(object sender, EventArgs e)
    {
        ImageButton button = (ImageButton)sender;
        int rowIndex = int.Parse(button.CommandArgument);
        string portCode = UltraWebGrid1.Rows[rowIndex].Cells.FromKey("port_code").Value.ToString();

        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        string[] tranStr = new string[1];

        tranStr[0] += "DELETE FROM port WHERE elt_account_number=" + elt_account_number + " AND port_code=N'" + portCode + "'";

        if (!feData.DataTransactions(tranStr))
        {
            Response.Write(feData.GetLastTransactionError());
        }
        else
        {
            Response.Redirect("./PortMaster.aspx");
        }
    }
}
