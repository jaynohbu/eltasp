using System;
using System.IO;
using System.Data;
using System.Configuration;
using System.Collections;
using System.ComponentModel;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls.WebParts;
using System.Data.SqlClient;
using Infragistics.WebUI.UltraWebGrid;
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;

public partial class ASPX_AirExport_SetProfitSharing : System.Web.UI.Page
{
    protected DataSet ds = null;
    protected string ConnectStr, user_id, login_name, user_right, elt_account_number;

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            Session.LCID = 1033;
            elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
            user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
            user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
            login_name = Request.Cookies["CurrentUserInfo"]["login_name"];

            if (!IsPostBack)
            {
                GetParameters();
                InitializeAll();
                GetRateList();
            }
        }
        catch
        { }
    }

    protected void GetParameters()
    {
        txtMAWB.Text = Request.Params["MAWB"];
        txtHAWB.Text = Request.Params["HAWB"];
        txtItem.Text = Request.Params["ITEM"];
    }

    protected void InitializeAll()
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        string CustomersSQL = "";
        DataRow drTmp = null;

        // Consolidated House Item
        if (txtHAWB.Text != "")
        {
            CustomersSQL = @"SELECT a.org_account_number,CASE WHEN isnull(a.class_code,'')='' THEN a.dba_name ELSE a.dba_name + '[' + RTRIM(LTRIM(isnull(a.class_code,''))) + ']' END AS dba_name 
                FROM organization a LEFT OUTER JOIN hawb_master b ON (a.elt_account_number=b.elt_account_number AND a.org_account_number=b.agent_no) WHERE a.elt_account_number=" + elt_account_number +
                " AND b.mawb_num=N'" + txtMAWB.Text + "' GROUP BY a.org_account_number,a.dba_name,a.class_code";
            feData.AddToDataSet("Customers", CustomersSQL);

            if (feData.Tables["Customers"].Rows.Count > 0)
            {
                lstCustomer.DataSource = feData.Tables["Customers"];
                lstCustomer.DataTextField = "dba_name";
                lstCustomer.DataValueField = "org_account_number";
                lstCustomer.DataBind();
                lstCustomer.Items.Insert(0, new ListItem("", ""));
            }

            feData.AddToDataSet("HouseInfo", "SELECT * FROM hawb_master WHERE elt_account_number=" + elt_account_number + " AND mawb_num=N'" + txtMAWB.Text + "' AND hawb_num=N'" + txtHAWB.Text + "'");

            if (feData.Tables["HouseInfo"].Rows.Count > 0)
            {
                drTmp = feData.Tables["HouseInfo"].Rows[0];

                lstCustomer.SelectedValue = drTmp["agent_no"].ToString();
                txtWeight.Text = drTmp["total_chargeable_weight"].ToString();
                txtWeightScale.Text = drTmp["weight_scale"].ToString();
            }

            // Other Charge
            if (txtItem.Text != "")
            {
                feData.AddToDataSet("ItemInfo", "SELECT * FROM hawb_other_charge WHERE elt_account_number=" + elt_account_number + " AND hawb_num=N'" + txtHAWB.Text + "' AND tran_no=" + txtItem.Text);
                if (feData.Tables["ItemInfo"].Rows.Count > 0)
                {
                    drTmp = feData.Tables["ItemInfo"].Rows[0];
                    txtItemName.Text = drTmp["charge_desc"].ToString();
                    txtItemAmt.Text = drTmp["amt_hawb"].ToString();
                    lstCostItem.Text = drTmp["cost_desc"].ToString();
                    hCostItem.Value = drTmp["cost_code"].ToString();
                    txtCostAmt.Text = drTmp["cost_amt"].ToString();
                }
            }
            // Weight Charge
            else
            {
                feData.AddToDataSet("ItemInfo", "SELECT * FROM hawb_weight_charge WHERE elt_account_number=" + elt_account_number + " AND hawb_num=N'" + txtHAWB.Text + "'");
                if (feData.Tables["ItemInfo"].Rows.Count > 0)
                {
                    drTmp = feData.Tables["ItemInfo"].Rows[0];
                    txtItemName.Text = "Freight Charge";
                    txtItemAmt.Text = drTmp["total_charge"].ToString();
                    lstCostItem.Text = drTmp["cost_desc"].ToString();
                    hCostItem.Value = drTmp["cost_code"].ToString();
                    txtCostAmt.Text = drTmp["cost_amt"].ToString();
                }
            }
        }
        
        // Direct Shipment
        else
        {
            CustomersSQL = @"SELECT a.org_account_number,CASE WHEN isnull(a.class_code,'')='' THEN a.dba_name ELSE a.dba_name + '[' + RTRIM(LTRIM(isnull(a.class_code,''))) + ']' END AS dba_name 
                FROM organization a LEFT OUTER JOIN mawb_master b ON (a.elt_account_number=b.elt_account_number AND a.org_account_number=b.shipper_account_number) WHERE a.elt_account_number=" + elt_account_number +
                " AND b.mawb_num=N'" + txtMAWB.Text + "' GROUP BY a.org_account_number,a.dba_name,a.class_code";
            
            feData.AddToDataSet("Customers", CustomersSQL);

            if (feData.Tables["Customers"].Rows.Count > 0)
            {
                lstCustomer.DataSource = feData.Tables["Customers"];
                lstCustomer.DataTextField = "dba_name";
                lstCustomer.DataValueField = "org_account_number";
                lstCustomer.DataBind();
                lstCustomer.Items.Insert(0, new ListItem("", ""));
                lstCustomer.SelectedIndex = 1;
            }

            feData.AddToDataSet("MasterInfo", "SELECT * FROM mawb_master WHERE elt_account_number=" + elt_account_number + " AND mawb_num=N'" + txtMAWB.Text + "' AND mawb_num=N'" + txtMAWB.Text + "'");

            if (feData.Tables["MasterInfo"].Rows.Count > 0)
            {
                drTmp = feData.Tables["MasterInfo"].Rows[0];
                txtWeight.Text = drTmp["total_chargeable_weight"].ToString();
                txtWeightScale.Text = drTmp["weight_scale"].ToString();
            }

            // Other Charge
            if (txtItem.Text != "")
            {
                feData.AddToDataSet("ItemInfo", "SELECT * FROM mawb_other_charge WHERE elt_account_number=" + elt_account_number + " AND mawb_num=N'" + txtMAWB.Text + "' AND tran_no=" + txtItem.Text);
                if (feData.Tables["ItemInfo"].Rows.Count > 0)
                {
                    drTmp = feData.Tables["ItemInfo"].Rows[0];
                    txtItemName.Text = drTmp["charge_desc"].ToString();
                    txtItemAmt.Text = drTmp["amt_mawb"].ToString();
                    lstCostItem.Text = drTmp["cost_desc"].ToString();
                    hCostItem.Value = drTmp["cost_code"].ToString();
                    txtCostAmt.Text = drTmp["cost_amt"].ToString();
                }
            }
            // Weight Charge
            else
            {
                feData.AddToDataSet("ItemInfo", "SELECT * FROM mawb_weight_charge WHERE elt_account_number=" + elt_account_number + " AND mawb_num=N'" + txtMAWB.Text + "'");
                if (feData.Tables["ItemInfo"].Rows.Count > 0)
                {
                    drTmp = feData.Tables["ItemInfo"].Rows[0];
                    txtItemName.Text = "Freight Charge";
                    txtItemAmt.Text = drTmp["total_charge"].ToString();
                    lstCostItem.Text = drTmp["cost_desc"].ToString();
                    hCostItem.Value = drTmp["cost_code"].ToString();
                    txtCostAmt.Text = drTmp["cost_amt"].ToString();
                }
            }
        }

        feData.AddToDataSet("BookingInfo", "SELECT origin_port_id,dest_port_id,carrier_code,carrier_desc FROM mawb_number WHERE elt_account_number=" + elt_account_number + " AND mawb_no=N'" + txtMAWB.Text + "'");

        if (feData.Tables["BookingInfo"].Rows.Count > 0)
        {
            drTmp = feData.Tables["BookingInfo"].Rows[0];
            
            txtFrom.Text = drTmp["origin_port_id"].ToString();
            txtTo.Text = drTmp["dest_port_id"].ToString();
            txtCarrierCode.Text = drTmp["carrier_code"].ToString();
            txtCarrierDesc.Text = drTmp["carrier_desc"].ToString();
        }
    }

    protected void btnGetRateList_Click(object sender, EventArgs e)
    {
        GetRateList();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        if (hCostItem.Value != "" && hCostItem.Value != "0")
        {
            string tranStr = "";
            // Consolidated House Item
            if (txtHAWB.Text != "")
            {
                // Other Charge
                if (txtItem.Text != "")
                {
                    tranStr = "UPDATE hawb_other_charge SET cost_desc=N'" + lstCostItem.Text 
                        + "',cost_code=" + hCostItem.Value + ",cost_amt=" + txtCostAmt.Text 
                        + " WHERE elt_account_number=" + elt_account_number + " AND hawb_num=N'" + txtHAWB.Text
                        + "' AND tran_no=" + txtItem.Text;
                }
                // Weight Charge
                else
                {
                    tranStr = "UPDATE hawb_weight_charge SET cost_desc=N'" + lstCostItem.Text 
                        + "',cost_code=" + hCostItem.Value + ",cost_amt=" + txtCostAmt.Text 
                        + " WHERE elt_account_number=" + elt_account_number + " AND hawb_num=N'" + txtHAWB.Text
                        + "'";
                }
            }

            // Direct Shipment
            else
            {
                // Other Charge
                if (txtItem.Text != "")
                {
                    tranStr = "UPDATE mawb_other_charge SET cost_desc=N'" + lstCostItem.Text
                        + "',cost_code=" + hCostItem.Value + ",cost_amt=" + txtCostAmt.Text
                        + " WHERE elt_account_number=" + elt_account_number + " AND mawb_num=N'" + txtMAWB.Text
                        + "' AND tran_no=" + txtItem.Text;
                }
                // Weight Charge
                else
                {
                    tranStr = "UPDATE mawb_weight_charge SET cost_desc=N'" + lstCostItem.Text
                        + "',cost_code=" + hCostItem.Value + ",cost_amt=" + txtCostAmt.Text
                        + " WHERE elt_account_number=" + elt_account_number + " AND mawb_num=N'" + txtMAWB.Text
                        + "'";
                }
            }

            feData.DataTransaction(tranStr);

            hSaved.Value = "Y";
        }
    }

    protected void GetRateList()
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();

        string rateSQL, rateDetailSQL;

        if (lstRateType.SelectedValue == "1")
        {
            rateSQL = @"SELECT distinct b.dba_name,b.carrier_code,a.airline,a.share FROM all_rate_table a 
                LEFT OUTER JOIN (select distinct dba_name,carrier_code,elt_account_number from organization) b 
                on (a.elt_account_number=b.elt_account_number 
                and a.airline=b.carrier_code) WHERE a.elt_account_number="
                + elt_account_number + " AND a.rate_type=" + lstRateType.SelectedValue
                + " AND a.origin_port=N'" + txtFrom.Text + "' AND a.dest_port=N'" + txtTo.Text
                + "' AND a.agent_no=" + lstCustomer.SelectedValue + " AND (b.carrier_code=" + txtCarrierCode.Text + " OR a.airline=-1)";
            
            rateDetailSQL = @"SELECT airline,weight_break=case item_no when 0 then 'Min($)' when 1 then '+Min' 
                else cast(weight_break as NVARCHAR) end,kg_lb,rate,fl_rate,sec_rate FROM all_rate_table WHERE elt_account_number="
                + elt_account_number + " AND rate_type=" + lstRateType.SelectedValue
                + " AND origin_port=N'" + txtFrom.Text + "' AND dest_port=N'" + txtTo.Text
                + "' AND agent_no=" + lstCustomer.SelectedValue + " ORDER BY item_no";
        }
        else if (lstRateType.SelectedValue == "5" || lstRateType.SelectedValue == "3")
        {
            rateSQL = @"SELECT distinct b.dba_name,b.carrier_code,a.airline,a.share FROM all_rate_table a 
                LEFT OUTER JOIN (select distinct dba_name,carrier_code,elt_account_number from organization) b 
                on (a.elt_account_number=b.elt_account_number 
                and a.airline=b.carrier_code) WHERE a.elt_account_number="
                + elt_account_number + " AND a.rate_type=" + lstRateType.SelectedValue
                + " AND a.origin_port=N'" + txtFrom.Text + "' AND a.dest_port=N'" + txtTo.Text
                + "' AND (b.carrier_code=" + txtCarrierCode.Text + " OR a.airline=-1)";

            rateDetailSQL = @"SELECT airline,weight_break=case item_no when 0 then 'Min($)' when 1 then '+Min' 
                else cast(weight_break as NVARCHAR) end,kg_lb,rate,fl_rate,sec_rate FROM all_rate_table WHERE elt_account_number="
                + elt_account_number + " AND rate_type=" + lstRateType.SelectedValue
                + " AND origin_port=N'" + txtFrom.Text + "' AND dest_port=N'" + txtTo.Text
                + "' ORDER BY item_no";
        }
        else if (lstRateType.SelectedValue == "4")
        {
            rateSQL = @"SELECT distinct b.dba_name,b.carrier_code,a.airline,a.share FROM all_rate_table a 
                LEFT OUTER JOIN (select distinct dba_name,carrier_code,elt_account_number from organization) b 
                on (a.elt_account_number=b.elt_account_number 
                and a.airline=b.carrier_code) WHERE a.elt_account_number="
                + elt_account_number + " AND a.rate_type=" + lstRateType.SelectedValue
                + " AND a.origin_port=N'" + txtFrom.Text + "' AND a.dest_port=N'" + txtTo.Text
                + "' AND a.customer_no=" + lstCustomer.SelectedValue + " AND (b.carrier_code=" + txtCarrierCode.Text + " OR a.airline=-1)";

            rateDetailSQL = @"SELECT airline,weight_break=case item_no when 0 then 'Min($)' when 1 then '+Min' 
                else cast(weight_break as NVARCHAR) end,kg_lb,rate,fl_rate,sec_rate FROM all_rate_table WHERE elt_account_number="
                + elt_account_number + " AND rate_type=" + lstRateType.SelectedValue
                + " AND origin_port=N'" + txtFrom.Text + "' AND dest_port=N'" + txtTo.Text
                + "' AND customer_no=" + lstCustomer.SelectedValue + " ORDER BY item_no";
        }
        else
        {
            return;
        }

        feData.AddToDataSet("Rate", rateSQL);
        feData.AddToDataSet("RateDetail", rateDetailSQL);
        feData.AddRelation("RateRelation", "Rate", "airline", "RateDetail", "airline");
        
        UltraWebGrid1.DataSource = feData;
        UltraWebGrid1.DataBind();
        UltraWebGrid1.ExpandAll(true);
    }

    protected void UltraWebGrid1_InitializeLayout(object sender, LayoutEventArgs e)
    {
        UltraWebGrid uwg = (UltraWebGrid)e.Layout.Grid;
        ColumnsCollection AirlineCols = uwg.Bands[0].Columns;
        ColumnsCollection WeightBreakCols = uwg.Bands[1].Columns;

        AirlineCols.FromKey("airline").Hidden = true;
        WeightBreakCols.FromKey("airline").Hidden = true;

        AirlineCols.FromKey("dba_name").Header.Caption = "Airline";
        AirlineCols.FromKey("carrier_code").Header.Caption = "Carrier Code";
        AirlineCols.FromKey("share").Header.Caption = "Profit Share (%)";

        WeightBreakCols.FromKey("weight_break").Header.Caption = "Weight Break";
        WeightBreakCols.FromKey("kg_lb").Header.Caption = "Kg/Lb";
        WeightBreakCols.FromKey("rate").Header.Caption = "Freight Charge Rate";
        WeightBreakCols.FromKey("fl_rate").Header.Caption = "Fuel Surcharge Rate";
        WeightBreakCols.FromKey("sec_rate").Header.Caption = "Securoty Surcharge Rate";

        WeightBreakCols.FromKey("weight_break").Width = Unit.Pixel(100);
        WeightBreakCols.FromKey("kg_lb").Width = Unit.Pixel(35);
        WeightBreakCols.FromKey("rate").Width = Unit.Pixel(60);
        WeightBreakCols.FromKey("fl_rate").Width = Unit.Pixel(60);
        WeightBreakCols.FromKey("sec_rate").Width = Unit.Pixel(60);
    }

    protected void UltraWebGrid1_InitializeRow(object sender, Infragistics.WebUI.UltraWebGrid.RowEventArgs e)
    {
        if (e.Row.Cells.FromKey("rate") != null)
        {
            e.Row.Cells.FromKey("rate").TargetURL = "javascript:CalculateRate(" + e.Row.Cells.FromKey("rate").Value +");";
        }
        else if (e.Row.Cells.FromKey("share") != null)
        {
            e.Row.Cells.FromKey("share").TargetURL = "javascript:CalculateRate(" + e.Row.Cells.FromKey("share").Value + "/100);";
        }
    }
}
