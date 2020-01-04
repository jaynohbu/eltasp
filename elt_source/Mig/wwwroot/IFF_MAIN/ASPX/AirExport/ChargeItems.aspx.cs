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

public partial class ASPX_AirExport_ChargeItems : System.Web.UI.Page
{
    protected DataSet ds = null;
    protected string ConnectStr, user_id, login_name, user_right, elt_account_number;

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            Session.LCID = 1033;

            if (!IsPostBack)
            {
                GetParameters();
                BindGridData();
            }
        }
        catch
        { }
    }

    protected void BindGridData()
    {
        FreightEasy.AirExport.ChargeItems myDs = new FreightEasy.AirExport.ChargeItems();
        myDs.GetAllRecords(elt_account_number, Session["MAWB"].ToString());
        DataSet ds = myDs;

        UltraWebGrid1.DataSource = ds;
        UltraWebGrid1.DataBind();
        if (Request.Params["SearchType"] == "master" || Request.Params["SearchType"] == "file")
        {
            UltraWebGrid1.ExpandAll(true);
        }
    }

    protected void GetParameters()
    {
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];

        Session["MAWB"] = GetMasterAWB(Request.Params["SearchType"], Request.Params["SearchNo"]);
        lstSearchType.SelectedValue = Request.Params["SearchType"];
        hSearchNum.Value = Request.Params["SearchNo"];
        lstSearchNum.Text = Request.Params["SearchNo"];
    }

    protected void UltraWebGrid1_InitializeLayout(object sender, LayoutEventArgs e)
    {
        UltraWebGrid uwg = (UltraWebGrid)e.Layout.Grid;
        ColumnsCollection MasterCols = uwg.Bands[0].Columns;
        ColumnsCollection AgentCols = uwg.Bands[1].Columns;
        ColumnsCollection HouseCols = uwg.Bands[2].Columns;
        ColumnsCollection ItemCols = uwg.Bands[3].Columns;

        MasterCols.FromKey("elt_account_number").Hidden = true;
        MasterCols.FromKey("shipper_account_number").Hidden = true;
        MasterCols.FromKey("consignee_acct_num").Hidden = true;
        AgentCols.FromKey("elt_account_number").Hidden = true;
        AgentCols.FromKey("mawb_num").Hidden = true;
        AgentCols.FromKey("agent_no").Hidden = true;
        HouseCols.FromKey("elt_account_number").Hidden = true;
        HouseCols.FromKey("mawb_num").Hidden = true;
        HouseCols.FromKey("agent_no").Hidden = true;
        AgentCols.FromKey("mawb_num").Hidden = true;
        ItemCols.FromKey("elt_account_number").Hidden = true;
        ItemCols.FromKey("mawb_num").Hidden = true;
        ItemCols.FromKey("hawb_num").Hidden = true;
        ItemCols.FromKey("item_code").Hidden = true;
        ItemCols.FromKey("tran_no").Hidden = true;

        MasterCols.FromKey("chargeable_weight").Format = "#0.00";
        AgentCols.FromKey("chargeable_weight").Format = "#0.00";
        HouseCols.FromKey("chargeable_weight").Format = "#0.00";

        MasterCols.FromKey("mawb_num").Width = Unit.Pixel(120);
        MasterCols.FromKey("file#").Width = Unit.Pixel(100);
        MasterCols.FromKey("shipper_name").Width = Unit.Pixel(200);
        MasterCols.FromKey("consignee_name").Width = Unit.Pixel(200);
        MasterCols.FromKey("origin_port_id").Width = Unit.Pixel(50);
        MasterCols.FromKey("dest_port_id").Width = Unit.Pixel(50);
        MasterCols.FromKey("total_pieces").Width = Unit.Pixel(80);
        MasterCols.FromKey("chargeable_weight").Width = Unit.Pixel(80);

        AgentCols.FromKey("agent_name").Width = Unit.Pixel(200);
        AgentCols.FromKey("chargeable_weight").Width = Unit.Pixel(80);

        HouseCols.FromKey("hawb_num").Width = Unit.Pixel(120);
        HouseCols.FromKey("agent_name").Width = Unit.Pixel(200);
        HouseCols.FromKey("chargeable_weight").Width = Unit.Pixel(80);

        ItemCols.FromKey("Charge").Width = Unit.Pixel(180);
        ItemCols.FromKey("Cost").Width = Unit.Pixel(180);
        ItemCols.FromKey("Charge Amt").Width = Unit.Pixel(80);
        ItemCols.FromKey("Cost Amt").Width = Unit.Pixel(80);

        MasterCols.FromKey("mawb_num").Header.Caption = "Master AWB";
        MasterCols.FromKey("file#").Header.Caption = "File No";
        MasterCols.FromKey("shipper_name").Header.Caption = "Shipper";
        MasterCols.FromKey("consignee_name").Header.Caption = "Consignee";
        MasterCols.FromKey("origin_port_id").Header.Caption = "From";
        MasterCols.FromKey("dest_port_id").Header.Caption = "To";
        MasterCols.FromKey("chargeable_weight").Header.Caption = "Chg Wt. (Lb)";

        AgentCols.FromKey("agent_name").Header.Caption = "Agent";
        AgentCols.FromKey("chargeable_weight").Header.Caption = "Chg Wt. (Lb)";

        HouseCols.FromKey("hawb_num").Header.Caption = "House AWB";
        HouseCols.FromKey("agent_name").Header.Caption = "Agent";
        HouseCols.FromKey("chargeable_weight").Header.Caption = "Chg Wt. (Lb)";
    }

    protected void UltraWebGrid1_InitializeRow(object sender, Infragistics.WebUI.UltraWebGrid.RowEventArgs e)
    {
        try
        {
            if (e.Row.Cells.FromKey("mawb_num") != null)
            {
                e.Row.Cells.FromKey("mawb_num").TargetURL = "javascript:viewPop('/IFF_MAIN/ASP/air_export/new_edit_mawb.asp?WindowName=popupNew&Edit=yes&MAWB=" + e.Row.Cells.FromKey("mawb_num").Text + "');";
            }

            if (e.Row.Cells.FromKey("Cost Amt") != null)
            {
                if (e.Row.Cells.FromKey("Cost Amt").Text == null)
                {
                    e.Row.Cells.FromKey("Cost Amt").Text = "Edit";
                }
                e.Row.Cells.FromKey("Cost Amt").TargetURL = "javascript:setProfitShare('"
                    + e.Row.Cells.FromKey("mawb_num").Text + "','" + e.Row.Cells.FromKey("hawb_num").Text
                    + "','" + e.Row.Cells.FromKey("tran_no").Text + "');";
            }

            try
            {
                if (e.Row.Cells.FromKey("hawb_num") != null)
                {
                    if (e.Row.Cells.FromKey("hawb_num").Value == null)
                    {
                        e.Row.Cells.FromKey("hawb_num").Text = "Direct Shipment";
                    }
                    else
                    {
                        e.Row.Cells.FromKey("hawb_num").TargetURL = "javascript:viewPop('/IFF_MAIN/ASP/air_export/new_edit_hawb.asp?WindowName=popupNew&Edit=yes&HAWB=" + e.Row.Cells.FromKey("hawb_num").Text + "');";

                        if (e.Row.Cells.FromKey("hawb_num").Text == Request.Params["SearchNo"])
                        {
                            e.Row.Expand(true);
                            e.Row.ExpandAncestors();
                        }
                    }
                }
            }
            catch (Exception ex1)
            {
                Response.Write(ex1.Message);
            }
        }
        catch (Exception ex2)
        {
            Response.Write(ex2.Message);
        }
    }

    protected void btnExcelExport_Click(object sender, EventArgs e)
    {
        UltraWebGridExcelExporter1.DownloadName = "ChargeItems.xls";
        UltraWebGridExcelExporter1.Export(UltraWebGrid1);
    }

    protected string GetMasterAWB(string searchType, string searchNo)
    {
        string ConnectStr = (new igFunctions.DB().getConStr());
        SqlConnection Con = new SqlConnection(ConnectStr);
        SqlCommand Cmd = new SqlCommand();
        Cmd.Connection = Con;
        SqlDataReader reader;
        string returnVal = "";

        if (searchType == "master")
        {
            returnVal = searchNo;
        }
        else
        {
            if (searchType == "file")
            {
                Cmd.CommandText = "SELECT mawb_no FROM mawb_number WHERE "
                + "elt_account_number=" + elt_account_number + " AND file#=N'" + searchNo + "'";
            }
            if (searchType == "house")
            {
                Cmd.CommandText = "SELECT mawb_num FROM hawb_master WHERE "
                + "elt_account_number=" + elt_account_number + " AND hawb_num=N'" + searchNo + "'";
            }
            try
            {
                Con.Open();
                reader = Cmd.ExecuteReader();
                if (reader.Read())
                {
                    returnVal = reader[0].ToString();
                }
            }
            catch
            { }
            finally
            { Con.Close(); }
        }
        return returnVal;
    }
}
