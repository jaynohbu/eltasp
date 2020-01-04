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

public partial class ASPX_OnLines_Rate_AgentBuying : System.Web.UI.Page
{
    public string elt_account_number = "";
    public string rate_type = "1";

    protected void ObjectDataSource1_Init(object sender, EventArgs e)
    {
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"].ToString();
        ObjectDataSource ods = (ObjectDataSource)sender;
        ods.SelectMethod = "GetAllRecords";
        ods.SelectParameters.Add("elt_account_number", elt_account_number);
        ods.SelectParameters.Add("rate_type", rate_type);
        ods.InsertMethod = "InsertRecord";
        ods.DeleteMethod = "DeleteRecord";
        ods.UpdateMethod = "UpdateRecord";
        ods.TypeName = "FreightEasy.Rates.AgentRates";
        ods.DataObjectTypeName = "FreightEasy.Rates.RateEntity";
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        UltraWebGrid uwg = (UltraWebGrid)RateWebGrid.FindControl("UltraWebGrid1");
        uwg.InitializeLayout += new InitializeLayoutEventHandler(this.InitializeUWG);
        DropDownList lst = (DropDownList)RateWebGrid.FindControl("lstRateTypes");
        lst.SelectedValue = rate_type;
    }

    protected void InitializeUWG(object sender, LayoutEventArgs e)
    {
        UltraWebGrid uwg = (UltraWebGrid)e.Layout.Grid;
        e.Layout.Bands[0].DataKeyField = "elt_account_number,rate_type,origin_port,dest_port,kg_lb,agent_no";
        e.Layout.Bands[1].DataKeyField = "elt_account_number,rate_type,origin_port,dest_port,kg_lb,agent_no,airline";
        e.Layout.Bands[2].DataKeyField = "elt_account_number,rate_type,origin_port,dest_port,kg_lb,agent_no,airline,item_no";
        FormatColumns(uwg);
    }

    protected void FormatColumns(UltraWebGrid uwg)
    {
        ColumnsCollection routeCols = uwg.Bands[0].Columns;
        ColumnsCollection airlineCols = uwg.Bands[1].Columns;
        ColumnsCollection weightCols = uwg.Bands[2].Columns;

        routeCols.FromKey("agent_no").Hidden = true;
        airlineCols.FromKey("agent_no").Hidden = true;
        weightCols.FromKey("agent_no").Hidden = true;

        routeCols.FromKey("dba_name").Header.Caption = "Agent";

        UltraGridColumn AgentCol = uwg.Bands[0].Columns.FromKey("dba_name");
        AgentCol.EditorControlID = "TextAgent";
        AgentCol.Type = ColumnType.Custom;
        AgentCol.DataType = "System.String";
        AgentCol.Width = Unit.Pixel(300);
    }
}
