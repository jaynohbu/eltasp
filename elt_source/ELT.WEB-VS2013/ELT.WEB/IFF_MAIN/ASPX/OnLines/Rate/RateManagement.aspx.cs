using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DevExpress.Web.ASPxEditors;
using DevExpress.Web.ASPxGridView;
using ELT.BL;
using ELT.CDT;
using ELT.COMMON;
public partial class ASPX_OnLines_Rate_RateManagement : System.Web.UI.Page
{
    int elt_account_number = 0;
    int customer_org_num = 0;
    int rate_type=4;//start with customer buying rate
    RateManagementBL bl;
    protected void Page_PreInit(object sender, EventArgs e)
    {
        bl = new RateManagementBL();
        GetParams();
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ASPxGridView.RegisterBaseScript(Page); // <<< NEW CODE
            ASPxComboBox.RegisterBaseScript(Page);
            bl.ClearRateRoutings();   
        }     
    }     
    protected void ddlRateType_SelectedIndexChanged(object sender, EventArgs e)
    {
        bl.ClearRateRoutings();
        GridMaster.Visible = false;
        if (ddlRateType.SelectedValue == "3" || ddlRateType.SelectedValue == "5")
        {
            ComboCompanyList.Enabled = false;
        }
        else
        {
            ComboCompanyList.Enabled = true;
        }
      
        HideShowColumns(GridMaster);
    }  
    protected void goBtn_Click(object sender, ImageClickEventArgs e)
    {
        bl.ClearRateRoutings();
       
        if (ComboCompanyList.Value != null)
        {
            customer_org_num = int.Parse(ComboCompanyList.Value.ToString());          
        }      
        rate_type = int.Parse(ddlRateType.SelectedValue);
        bl.SetParms(elt_account_number, customer_org_num, rate_type);        
        GridMaster.DataBind();
        GridMaster.Visible = true;
        HideShowColumns(GridMaster);
    }

    protected void GridMaster_Init(object sender, EventArgs e)
    {
        HideShowColumns(GridMaster);
    }

    private void HideShowColumns(ASPxGridView grid)
    {
        grid.Columns["AgentOrgName"].Visible = true;
        grid.Columns["CustomerOrgName"].Visible = true;
      
        if (rate_type == 1)
        {
            grid.Columns["CustomerOrgName"].Visible = false;
        }

        if (rate_type == 4)
        {
            grid.Columns["AgentOrgName"].Visible = false;
        }
        if (rate_type == 5 || rate_type == 3)
        {
            grid.Columns["AgentOrgName"].Visible = false;
            grid.Columns["CustomerOrgName"].Visible = false;
        }
    }

    protected void GridMaster_DataBound(object sender, EventArgs e)
    {
        ASPxGridView grid = (ASPxGridView)sender;
        HideShowColumns(grid);
    }
    protected void GridMaster_HtmlRowCreated(object sender, DevExpress.Web.ASPxGridView.ASPxGridViewTableRowEventArgs e)
    {
        //if (e.KeyValue != null)
        //{
        //    string key = e.KeyValue.ToString(); ;
        //    ASPxGridView grid = (ASPxGridView)sender;
        //    var a = (ObjectDataSource)GridMaster.FindEditRowCellTemplateControl(grid.Columns["Company Name"] as GridViewDataColumn, "OdsBreaks");
        //    var b = (HiddenField)GridMaster.FindRowCellTemplateControl(e.VisibleIndex, GridMaster.Columns["Company Name"] as GridViewDataColumn, "hRouteId");

        //    if (b != null)
        //    {
        //        b.Value = key;
        //    }             
        //}
    }
    protected void GridMaster_BeforePerformDataSelect(object sender, EventArgs e)
    {
        OdsRoutings.SelectParameters["elt_account_number"].DefaultValue = elt_account_number.ToString();
        OdsRoutings.SelectParameters["customer_org_num"].DefaultValue = customer_org_num.ToString();
        OdsRoutings.SelectParameters["rate_type"].DefaultValue = rate_type.ToString();
    }
   
    protected void GridSlave_Init(object sender, EventArgs e)
    {
            ASPxGridView grid = (ASPxGridView)sender;
            grid.SettingsEditing.BatchEditSettings.ShowConfirmOnLosingChanges = false;
            string routeId = (sender as ASPxGridView).GetMasterRowKeyValue().ToString();          
            DataTable dt = bl.GetDynamicTableForRoute(int.Parse(routeId));
            grid.KeyFieldName = "RateID";
            grid.Columns.Add(new GridViewDataTextColumn() { FieldName = "RateID", Caption = "RateID", Visible = false });
            grid.Columns.Add(new GridViewDataTextColumn() { FieldName = "RawItemId", Caption = "RawItemId", Visible = false });
            foreach (DataColumn column in dt.Columns)
            {
                string name = column.ColumnName;
                string caption = column.Caption;
                grid.Columns.Add(new GridViewDataTextColumn() { FieldName = name, Caption = caption });
            }
            grid.Columns.Add(new GridViewDataTextColumn() { FieldName = "Share", Caption = "Share", Visible = true });
            grid.KeyFieldName = "RateID";
            grid.DataSource = bl.GetRatesAndBreaks(int.Parse(routeId));
            grid.DataBind();
    }   
    protected void btnCreate_Click(object sender, EventArgs e)
    {
        if (ComboOrigin.SelectedItem == null)
        {
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "nonum", "alert('Origin is required!');", true);
            return;
        }
        if (ComboDestination.SelectedItem == null)
        {
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "nonum", "alert('Destination is required!');", true);
            return;
        }
        RateRouting routing = new RateRouting();
        routing.Origin = ComboOrigin.SelectedItem.Value.ToString();
        routing.Dest = ComboDestination.SelectedItem.Value.ToString();
        routing.Unit = ddlUnit.SelectedItem.Value.ToString();
        routing.UnitText = ddlUnit.SelectedItem.Text.ToString();
        List<RateRouting> list =bl.GetRateRoutings(elt_account_number,customer_org_num,rate_type);
        var exist = from c in list where c.Origin == routing.Origin && c.Dest == routing.Dest && c.Unit == routing.Unit select c;
        if (exist.Count() > 0)
        {
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "reroute", "alert('Route already exists!');", true);
            return;
        }
        if (rate_type == 4)
        {
            routing.customer_org_account_number = int.Parse(ComboCompanyList.SelectedItem.Value.ToString());
            ClientProfileBL ClientProfileBL = new ClientProfileBL();
            routing.CustomerOrgName = ClientProfileBL.GetClient(elt_account_number, routing.customer_org_account_number).dba_name;
        }
        else if (rate_type == 1)
        {
            routing.agent_org_account_number = int.Parse(ComboCompanyList.SelectedItem.Value.ToString());
            ClientProfileBL ClientProfileBL = new ClientProfileBL();
            routing.AgentOrgName = ClientProfileBL.GetClient(elt_account_number, routing.customer_org_account_number).dba_name;
        }
       
        Rate defaultRate = new Rate();
        defaultRate.RateID = bl.GetNextRateID();
        defaultRate.RouteID = routing.ID;
        defaultRate.Share = "0";
        routing.Rates.Add(defaultRate);
        int null_count = 0;
        for (int i = 0; i < GridBreak.Rows.Count; i++)
        {
            var text = ((TextBox)GridBreak.Rows[i].Cells[1].Controls[1]).Text;
            if (string.IsNullOrEmpty(text))
            {
                null_count++;
                continue;
            }
            if (!ELT.COMMON.Util.IsNumber(text))
            {
                List<RateDefinitionColum> wb = ExtractBreaksFromGridBreak();
                GridBreak.DataSource = wb;
                GridBreak.DataBind();
                ScriptManager.RegisterClientScriptBlock(this, GetType(), "nonum", "alert('Range should be a number!');", true);

                return;
            }
            defaultRate.RateDefinitionColums.Add(new RateDefinitionColum() { ID = i, Caption = text, Value = text });
        }
        if (null_count == GridBreak.Rows.Count)
        {
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "noelem", "alert('At least one Range Start is required!');", true);
            return;
        }
        var count = defaultRate.RateDefinitionColums.GroupBy(w => w.Caption).Select(x => x.Count() > 1).FirstOrDefault();
        if (count)
        {
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "samenum", "alert('You cannot have duplicate Ranage Start!');", true);
            return;
        }       
        int routeid = bl.InsertRoute(routing);
        GridMaster.DataBind();
        ResetGridBreak();
        ScriptManager.RegisterClientScriptBlock(this, GetType(), "CloseNewRouting", "CloseNewRouting();", true);      
        ScriptManager.RegisterClientScriptBlock(this, GetType(), "SaveBreaks", "redirectBack();", true);
    }    
    protected void GridSlave_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
    {
        ASPxGridView grid = (ASPxGridView)sender;
        int route_id = int.Parse(grid.GetMasterRowKeyValue().ToString());
 
        foreach (var line in e.DeleteValues)
        {
           int rateid= int.Parse(line.Keys[0].ToString());
           bl.DeleteRate(rateid, route_id);
        }
        foreach (var line in e.UpdateValues)
        {
            int rate_id = int.Parse(e.UpdateValues[0].Keys["RateID"].ToString());
            var route = bl.GetRouting(route_id);
            var rate1 = bl.GetRate(rate_id);
            var breaks = rate1.RateDefinitionColums;
            List<RateDefinitionColum> weightBreaks = new List<RateDefinitionColum>();
            int weightbreakid = 0;
            string Share = line.NewValues["Share"].ToString();
            double test_share = 0;
            if (!double.TryParse(line.NewValues["Share"].ToString(), out test_share))
            {
                ScriptManager.RegisterClientScriptBlock(grid, grid.GetType(), "ratenonum", "alert('Share must be a number!');", true);
                return;
            }

            string CarrierCode = line.NewValues["CarrierCode"].ToString();
         
            foreach (var br in breaks)
            {
                double test = 0;
                if (!double.TryParse(line.NewValues[br.Value].ToString(), out test))
                {
                    ScriptManager.RegisterClientScriptBlock(grid, grid.GetType(), "ratenonum", "alert('Rate must be a number!');", true);
                    return;
                }
                weightbreakid += 1;
                weightBreaks.Add(new RateDefinitionColum() { ID = weightbreakid, Rate = line.NewValues[br.Value].ToString(), Caption = br.Caption, Value = br.Value });
            }
            Rate rate = new Rate() { RateID = rate_id, Share = Share, RateDefinitionColums = weightBreaks, CarrierCode = CarrierCode, RouteID = route_id };
            bl.UpdateRate(rate, route_id);
        }
        foreach (var line in e.InsertValues)
        {
            if (line.NewValues != null)
            {
                var route = bl.GetRouting(route_id);
                var breaks = route.Rates[0].RateDefinitionColums;
                List<RateDefinitionColum> weightBreaks = new List<RateDefinitionColum>();
                int weightbreakid = 0;
                string Share = line.NewValues["Share"].ToString();

                double test_share = 0;
                if (!double.TryParse(line.NewValues["Share"].ToString(), out test_share))
                {                   
                    //e.e
                    ScriptManager.RegisterClientScriptBlock(grid, grid.GetType(), "ratenonum", "alert('Share must be a number!');", true);
                    return;
                }

                string CarrierCode = line.NewValues["CarrierCode"].ToString();              
               
                foreach (var br in breaks)
                {
                    double test = 0;
                    if (!double.TryParse(line.NewValues[br.Value].ToString(), out test))
                    {
                       
                        ScriptManager.RegisterClientScriptBlock(grid, grid.GetType(), "ratenonum", "alert('Rate must be a number!');", true);
                        return;
                    }
                    weightbreakid += 1;
                    weightBreaks.Add(new RateDefinitionColum() { ID = weightbreakid, Rate = line.NewValues[br.Value].ToString(), Caption = br.Caption, Value = br.Value });
                }
                Rate rate = new Rate() { RateID = bl.GetNextRateID(), Share = Share, RateDefinitionColums = weightBreaks, CarrierCode = CarrierCode, RouteID = route_id };
                bl.InsertRate(rate, route_id);
            }
        }
        List<RateRouting> list = bl.GetRateRoutings(elt_account_number, customer_org_num, rate_type);
        bl.SaveRateInfo(list);
        e.Handled = true;       
    }
   
    protected void GridMaster_DetailRowExpandedChanged(object sender, ASPxGridViewDetailRowEventArgs e)
    {    
        if (e.Expanded)
        {         
            var b = (HiddenField)GridMaster.FindDetailRowTemplateControl(e.VisibleIndex, "hRouteId");
            ASPxGridView grid = (ASPxGridView)GridMaster.FindDetailRowTemplateControl(e.VisibleIndex, "GridSlave");
            int routeId = int.Parse(b.Value);
            grid.KeyFieldName = "RateID";
            grid.DataSource = bl.GetRatesAndBreaks(routeId);
            grid.DataBind();
        }
    }   
    protected void btnAddNewBreak_Click(object sender, EventArgs e)
    {
        List<RateDefinitionColum> wb = ExtractBreaksFromGridBreak();
        wb.Add(new RateDefinitionColum() { ID = wb.Count });
        GridBreak.DataSource = wb;
        GridBreak.DataBind();
    }   
    protected void btnTriggerBreakTable_Click(object sender, EventArgs e)
    {
        ResetGridBreak();
        ScriptManager.RegisterClientScriptBlock(this, GetType(), "OpenNewRouting", "OpenNewRouting();", true);
    }
    protected void btnDeleteBreak_Click(object sender, EventArgs e)
    {
        List<RateDefinitionColum> wb = ExtractBreaksFromGridBreak();
        wb.RemoveAt(int.Parse(((ImageButton)sender).CommandArgument));
       GridBreak.DataSource = wb;
       GridBreak.DataBind();        
    }   
  
    protected void btnCancelCreate_Click(object sender, ImageClickEventArgs e)
    {
        ResetGridBreak();
        ScriptManager.RegisterClientScriptBlock(this, GetType(), "SaveBreaks", "redirectBack();", true);
    }
    protected void btnRefresh_Click(object sender, EventArgs e)
    {
     //this only refresh devexpress do not remove
    }   
    private void GetParams()
    {
        elt_account_number = int.Parse(Request.Cookies["CurrentUserInfo"]["elt_account_number"]);
        customer_org_num = HttpContext.Current.Session["rate_customer_org_num"] == null ? 0 : int.Parse(HttpContext.Current.Session["rate_customer_org_num"].ToString());
        rate_type = HttpContext.Current.Session["rate_rate_type"] == null ? 4 : int.Parse(HttpContext.Current.Session["rate_rate_type"].ToString());       
    }
    private List<RateDefinitionColum> ExtractBreaksFromGridBreak()
    {
        List<RateDefinitionColum> wb = new List<RateDefinitionColum>();
        for (int i = 0; i < GridBreak.Rows.Count; i++)
        {
            var text = ((TextBox)GridBreak.Rows[i].Cells[1].Controls[1]).Text;
            wb.Add(new RateDefinitionColum() { ID = i, Caption = text, Value = text });
        }
        return wb;
    }
    private void ResetGridBreak()
    {
        ComboDestination.Value = "";
        ComboOrigin.Value = "";
        ddlUnit.SelectedIndex = 0;
        List<RateDefinitionColum> wb = new List<RateDefinitionColum>();
        wb.Add(new RateDefinitionColum());
        wb.Add(new RateDefinitionColum());
        wb.Add(new RateDefinitionColum());
        wb.Add(new RateDefinitionColum());
        wb.Add(new RateDefinitionColum());
        GridBreak.DataSource = wb;
        GridBreak.DataBind();
    }

    protected void SqlCarrier_Init(object sender, EventArgs e)
    {
        SqlCarrier.SelectCommand = string.Format(SQLConstants.SELECT_LIST_CARRIERS, elt_account_number.ToString());
        SqlCarrier.DataSourceMode = SqlDataSourceMode.DataSet;
        SqlCarrier.ConnectionString = (new igFunctions.DB().getConStr());
    }
    protected void SqlDsPort_Init(object sender, EventArgs e)
    {
        SqlDsPort.SelectCommand = string.Format(SQLConstants.SELECT_LIST_PORT, elt_account_number.ToString());
        SqlDsPort.DataSourceMode = SqlDataSourceMode.DataSet;
        SqlDsPort.ConnectionString = (new igFunctions.DB().getConStr());
    }

    //protected void SqlDsAgentOrg_Init(object sender, EventArgs e)
    //{
    //    SqlDsAgentOrg.SelectCommand = SQLConstants.SELECT_LIST_AGENT;
    //    SqlDsAgentOrg.DataSourceMode = SqlDataSourceMode.DataSet;
    //    SqlDsAgentOrg.ConnectionString = (new igFunctions.DB().getConStr());
    //    SqlDsAgentOrg.SelectParameters.Clear();
    //    SqlDsAgentOrg.SelectParameters.Add("EmailItemID", TypeCode.Int32, EmailItemID.ToString());
    //}
    protected void ComboCompanyList_ItemsRequestedByFilterCondition(object source, DevExpress.Web.ASPxEditors.ListEditItemsRequestedByFilterConditionEventArgs e)
    {       
        string Qry = string.Empty;
        if (e.Filter == "")
        {
            if (rate_type == 4)
                Qry = SQLConstants.SELECT_LIST_ORGANIZATION_ALL;
            else
                Qry = SQLConstants.SELECT_LIST_ORGANIZATION_AGENT;
        }
        else
        {
            if (rate_type == 4)
                Qry = SQLConstants.SELECT_LIST_ORGANIZATION_WITH_FILTER_START_END_INDEX;
            else
                Qry = SQLConstants.SELECT_LIST_ORGANIZATION_AGENT_WITH_FILTER_START_END_INDEX;
        }
        ASPxComboBox comboBox = (ASPxComboBox)source;
        SQLDsClientProfile.SelectCommand = Qry;
        SQLDsClientProfile.SelectParameters.Clear();
        SQLDsClientProfile.SelectParameters.Add("elt_account_number", TypeCode.Int32, elt_account_number.ToString());
        SQLDsClientProfile.SelectParameters.Add("filter", TypeCode.String, string.Format("%{0}%", e.Filter));
        SQLDsClientProfile.SelectParameters.Add("startIndex", TypeCode.Int64, (e.BeginIndex + 1).ToString());
        SQLDsClientProfile.SelectParameters.Add("endIndex", TypeCode.Int64, (e.EndIndex + 1).ToString());
        SQLDsClientProfile.ConnectionString = (new igFunctions.DB().getConStr());
        comboBox.DataBind();
    }
    protected void ComboCompanyList_ItemRequestedByValue(object source, DevExpress.Web.ASPxEditors.ListEditItemRequestedByValueEventArgs e)
    {
        ASPxComboBox comboBox = (ASPxComboBox)source;
        SQLDsClientProfile.ConnectionString = (new igFunctions.DB().getConStr());
        long value = 0;
        string Qry = string.Empty;
        if (e.Value == null || !Int64.TryParse(e.Value.ToString(), out value))
        {
            if (rate_type == 4)
                Qry = SQLConstants.SELECT_LIST_ORGANIZATION_ALL;
            else
                Qry = SQLConstants.SELECT_LIST_ORGANIZATION_AGENT;
            SQLDsClientProfile.SelectCommand = Qry;
            SQLDsClientProfile.SelectParameters.Clear();
            SQLDsClientProfile.SelectParameters.Add("elt_account_number", TypeCode.Int32, elt_account_number.ToString());
            SQLDsClientProfile.SelectParameters.Add("startIndex", TypeCode.Int64, "1");
            SQLDsClientProfile.SelectParameters.Add("endIndex", TypeCode.Int64, "10");
            comboBox.DataBind();
        }
        else
        {
            if (rate_type == 4)
            Qry = SQLConstants.SELECT_LIST_ORGANIZATION_FOR_VALUE;
            else
                Qry = SQLConstants.SELECT_LIST_ORGANIZATION_AGENT_FOR_VALUE;
            SQLDsClientProfile.SelectCommand = Qry;
            SQLDsClientProfile.SelectParameters.Clear();
            SQLDsClientProfile.SelectParameters.Add("elt_account_number", TypeCode.Int32, elt_account_number.ToString());
            SQLDsClientProfile.SelectParameters.Add("org_account_number", TypeCode.Int64, e.Value.ToString());
            comboBox.DataBind();
        }
    }

    
}

