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

public partial class ASPX_Accounting_ChartOfAccounts : System.Web.UI.Page
{
    public string elt_account_number = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        WebNavBar1.GridID = UltraWebGrid1.UniqueID;
    }

    protected void ObjectDataSource1_Init(object sender, EventArgs e)
    {
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"].ToString();
        ObjectDataSource ods = (ObjectDataSource)sender;
        ods.SelectMethod = "GetAllChartOfAccounts";
        ods.SelectParameters.Add("elt_account_number", elt_account_number);
        
        ods.TypeName = "FreightEasy.GLAccounts.GLAccounts";
        ods.DataObjectTypeName = "FreightEasy.GLAccounts.GLAccountEntity";
    }

    protected void UltraWebGrid1_UpdateGrid(object sender, UpdateEventArgs e)
    {
        Response.Redirect(Request.Url.ToString());
    }

    protected void UltraWebGrid1_InitializeLayout(object sender, LayoutEventArgs e)
    {
        UltraWebGrid1.Bands[0].Columns.FromKey("gl_account_balance").Hidden = true;

        UltraGridColumn GLMasterType = UltraWebGrid1.Bands[0].Columns.FromKey("gl_master_type");
        UltraGridColumn GLAccountType = UltraWebGrid1.Bands[0].Columns.FromKey("gl_account_type");
        GLAccountType.Type = ColumnType.DropDownList;
        // start getting gl types
        FreightEasy.DataManager.FreightEasyData glTypes = new FreightEasy.DataManager.FreightEasyData();
        glTypes.AddToDataSet("GLTypes", "select * from gl_reference");
        DataTable GLTypeTable = glTypes.Tables["GLTypes"];
        // end of getting gl types
        GLAccountType.ValueList.DataSource = GLTypeTable;
        GLAccountType.ValueList.DisplayMember = GLTypeTable.Columns["gl_type"].ToString();
        GLAccountType.ValueList.ValueMember = GLTypeTable.Columns["gl_type"].ToString();
        GLAccountType.ValueList.DataBind();
        GLAccountType.ValueList.Style.Font.Size = FontUnit.Point(8);

    }
}
 