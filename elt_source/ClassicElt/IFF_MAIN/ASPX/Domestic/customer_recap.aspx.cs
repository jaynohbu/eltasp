using System;
using System.IO;
using System.Data;
using System.Drawing;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using CrystalDecisions.Shared;

public partial class ASPX_Domestic_customer_recap : System.Web.UI.Page
{
    protected DataSet ds = null;
    protected string ConnectStr = null;
    private string elt_account_number = null;
    private string user_id, login_name, user_right;
    private int maxRows = 10;
    protected ReportSourceManager rsm = null;
    private int Child_page_IN = 0;
    private int Child_page_OUT = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        Session.LCID = 1033;
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
        ConnectStr = (new igFunctions.DB().getConStr());

        if (!IsPostBack)
        {
            LoadParameters();
            InitializeForm();
            PerformSearch();
            BindGridView();
        }
    }

    protected void LoadParameters()
    {
        GridViewInSort.PageIndex = 0;
        GridViewOutSort.PageIndex = 0;
        imagb.Visible = false;
        
        
    }


    protected void InitializeForm()
    {
        Webdatetimeedit1.Text = System.DateTime.Today.ToString("MM/dd/yyyy");
        Webdatetimeedit2.Text = System.DateTime.Today.ToString("MM/dd/yyyy");
        LoadPorts();
    }

    protected void BindGridView()
    {
        try
        {
            if (ds.Tables["InboundSortTable"] == null) { }
            else if (ds.Tables["InboundSortTable"].Rows.Count == 0)
            {
                MakeEmptyGridView(GridViewInSort, "InboundSortTable");
            }
            else
            {
                GridViewInSort.PageSize = maxRows;
                GridViewInSort.DataSource = ds.Tables["InboundSortTable"].DefaultView;
                GridViewInSort.DataBind();
            }

            if (ds.Tables["OutboundSortTable"] == null) { }
            else if (ds.Tables["OutboundSortTable"] == null || ds.Tables["OutboundSortTable"].Rows.Count == 0)
            {
                MakeEmptyGridView(GridViewOutSort, "OutboundSortTable");
            }
            else
            {
                GridViewOutSort.PageSize = maxRows;
                GridViewOutSort.DataSource = ds.Tables["OutboundSortTable"].DefaultView;
                GridViewOutSort.DataBind();
            }

            if (lstShipmentType.SelectedIndex == 1)
            {
                GridViewOutSort.Visible = false;
                GridViewInSort.Visible = true;
                bindChildGridView("InboundSortTable", "InboundTable", "GridViewInDetail", GridViewInSort, "InboundRelation");
            }
            else if (lstShipmentType.SelectedIndex == 2)
            {
                GridViewOutSort.Visible = true;
                GridViewInSort.Visible = false;
                bindChildGridView("OutboundSortTable", "OutboundTable", "GridViewOutDetail", GridViewOutSort, "OutboundRelation");
            }
            else
            {
                GridViewOutSort.Visible = true;
                GridViewInSort.Visible = true;
                bindChildGridView("InboundSortTable", "InboundTable", "GridViewInDetail", GridViewInSort, "InboundRelation");
                bindChildGridView("OutboundSortTable", "OutboundTable", "GridViewOutDetail", GridViewOutSort, "OutboundRelation");
            }
        }
        catch { }
    }

    protected void PerformSearch()
    {
        ds = new DataSet();
        string InboundSQL = "";
        string OutboundSQL = "";
        string SortInboundSQL = "";
        string SortOutboundSQL = "";

        if (lstSortBy.SelectedValue == "Customer")
        {
            SortInboundSQL = "SELECT distinct customer_acct AS sort_key, d.dba_name AS sort_value FROM hawb_master a LEFT OUTER JOIN mawb_number c ON (a.mawb_num=c.mawb_no AND a.elt_account_number=c.elt_account_number) RIGHT OUTER JOIN hawb_master_add b ON (a.hawb_num=b.hawb_num AND a.elt_account_number=b.elt_account_number) LEFT OUTER JOIN organization d ON (a.elt_account_number=d.elt_account_number AND ISNULL(b.customer_acct,0)=d.org_account_number) WHERE a.elt_account_number=" + elt_account_number + " AND ISNULL(b.ship_status,'')='C' AND a.is_inbound='Y'";
            SortOutboundSQL = "SELECT distinct customer_acct AS sort_key,d.dba_name AS sort_value FROM hawb_master a LEFT OUTER JOIN mawb_number c ON (a.mawb_num=c.mawb_no AND a.elt_account_number=c.elt_account_number) RIGHT OUTER JOIN hawb_master_add b ON (a.hawb_num=b.hawb_num AND a.elt_account_number=b.elt_account_number) LEFT OUTER JOIN organization d ON (a.elt_account_number=d.elt_account_number AND ISNULL(b.customer_acct,0)=d.org_account_number) WHERE a.elt_account_number=" + elt_account_number + " AND ISNULL(b.ship_status,'')='C' AND a.is_inbound='N'";
            InboundSQL = "SELECT customer_acct AS sort_key_detail,CASE WHEN Total_Weight_Charge_HAWB = 0 THEN Total_Other_Charges WHEN Total_Weight_Charge_HAWB <> 0 THEN (Total_Weight_Charge_HAWB+Total_Other_Charges) END AS WillCharge, g.driver_acct as DriverID, h.dba_name as drive_name, e.business_city AS B_city,e.business_state AS B_state ,a.hawb_num,Consignee_Name,Consignee_acct_num, Dest_Port_Location,POD_signer,POD_time,Total_Pieces,Adjusted_Weight,Total_Weight_Charge_HAWB,Origin_Port_Location,Carrier_Desc,Carrier_acct,a.mawb_num,Handling_Info FROM hawb_master a LEFT OUTER JOIN mawb_number c ON (a.mawb_num=c.mawb_no AND a.elt_account_number=c.elt_account_number) RIGHT OUTER JOIN hawb_master_add b ON (a.hawb_num=b.hawb_num AND a.elt_account_number=b.elt_account_number) LEFT OUTER JOIN organization d ON (a.elt_account_number=d.elt_account_number AND ISNULL(b.customer_acct,0)=d.org_account_number) LEFT OUTER JOIN organization e ON (a.elt_account_number=e.elt_account_number AND ISNULL(a.Consignee_acct_num,'')=cast(e.org_account_number as nvarchar)) LEFT OUTER JOIN hawb_master_drivers g ON (a.elt_account_number=g.elt_account_number AND g.auto_uid = (select top 1 auto_uid from hawb_master_drivers where hawb_num = a.hawb_num and elt_account_number = " + elt_account_number + " )) LEFT OUTER JOIN organization h ON (g.elt_account_number=h.elt_account_number AND g.driver_acct=h.org_account_number)  WHERE a.elt_account_number=" + elt_account_number + " AND ISNULL(b.ship_status,'')='C' AND a.is_inbound='Y'";
            OutboundSQL = "SELECT customer_acct AS sort_key_detail, case WHEN Total_Weight_Charge_HAWB = 0 THEN Total_Other_Charges WHEN Total_Weight_Charge_HAWB <> 0 THEN (Total_Weight_Charge_HAWB+Total_Other_Charges) END AS WillCharge, g.driver_acct as DriverID, h.dba_name as drive_name, e.business_city AS B_city, e.business_state AS B_state,a.hawb_num,Shipper_Name, shipper_account_number,Origin_Port_Location,Dest_Port_Location,Carrier_Desc,Carrier_acct,a.mawb_num,Total_Pieces,Adjusted_Weight,Total_Weight_Charge_HAWB,Handling_Info FROM hawb_master a LEFT OUTER JOIN mawb_number c ON (a.mawb_num=c.mawb_no AND a.elt_account_number=c.elt_account_number) RIGHT OUTER JOIN hawb_master_add b ON (a.hawb_num=b.hawb_num AND a.elt_account_number=b.elt_account_number) LEFT OUTER JOIN organization d ON (a.elt_account_number=d.elt_account_number AND ISNULL(b.customer_acct,0)=d.org_account_number) LEFT OUTER JOIN organization e ON (a.elt_account_number=e.elt_account_number AND a.shipper_Name=e.dba_name) LEFT OUTER JOIN hawb_master_drivers g ON (a.elt_account_number=g.elt_account_number AND g.auto_uid = (select top 1 auto_uid from hawb_master_drivers where hawb_num = a.hawb_num and elt_account_number = " + elt_account_number + " )) LEFT OUTER JOIN organization h ON (g.elt_account_number=h.elt_account_number AND g.driver_acct=h.org_account_number) WHERE a.elt_account_number=" + elt_account_number + " AND ISNULL(b.ship_status,'')='C' AND a.is_inbound='N'";
        }
        if (lstSortBy.SelectedValue == "")
        {
            SortInboundSQL = "SELECT distinct a.elt_account_number AS sort_key, '' AS sort_value FROM hawb_master a LEFT OUTER JOIN mawb_number c ON (a.mawb_num=c.mawb_no AND a.elt_account_number=c.elt_account_number) RIGHT OUTER JOIN hawb_master_add b ON (a.hawb_num=b.hawb_num AND a.elt_account_number=b.elt_account_number) LEFT OUTER JOIN organization d ON (a.elt_account_number=d.elt_account_number AND ISNULL(b.customer_acct,0)=d.org_account_number) WHERE a.elt_account_number=" + elt_account_number + " AND ISNULL(b.ship_status,'')='C' AND a.is_inbound='Y'";
            SortOutboundSQL = "SELECT distinct a.elt_account_number AS sort_key, '' AS sort_value FROM hawb_master a LEFT OUTER JOIN mawb_number c ON (a.mawb_num=c.mawb_no AND a.elt_account_number=c.elt_account_number) RIGHT OUTER JOIN hawb_master_add b ON (a.hawb_num=b.hawb_num AND a.elt_account_number=b.elt_account_number) LEFT OUTER JOIN organization d ON (a.elt_account_number=d.elt_account_number AND ISNULL(b.customer_acct,0)=d.org_account_number) WHERE a.elt_account_number=" + elt_account_number + " AND ISNULL(b.ship_status,'')='C' AND a.is_inbound='N'";
            InboundSQL = "SELECT a.elt_account_number AS sort_key_detail,Total_Weight_Charge_HAWB AS WillCharge , e.business_city AS B_city, e.business_state AS B_state, a.hawb_num,Consignee_Name, Consignee_acct_num, Dest_Port_Location,POD_signer,POD_time,Total_Pieces,Adjusted_Weight,Total_Weight_Charge_HAWB,Origin_Port_Location,Carrier_Desc,Carrier_acct,a.mawb_num,Handling_Info, g.driver_acct as DriverID, h.dba_name as drive_name FROM hawb_master a LEFT OUTER JOIN mawb_number c ON (a.mawb_num=c.mawb_no AND a.elt_account_number=c.elt_account_number) RIGHT OUTER JOIN hawb_master_add b ON (a.hawb_num=b.hawb_num AND a.elt_account_number=b.elt_account_number) LEFT OUTER JOIN organization d ON (a.elt_account_number=d.elt_account_number AND ISNULL(b.customer_acct,0)=d.org_account_number) LEFT OUTER JOIN organization e ON (a.elt_account_number=e.elt_account_number AND ISNULL(a.Consignee_acct_num,'')=cast(e.org_account_number as nvarchar)) LEFT OUTER JOIN hawb_master_drivers g ON (a.elt_account_number=g.elt_account_number AND g.auto_uid = (select top 1 auto_uid from hawb_master_drivers where hawb_num = a.hawb_num and elt_account_number = " + elt_account_number + " )) LEFT OUTER JOIN organization h ON (g.elt_account_number=h.elt_account_number AND g.driver_acct=h.org_account_number) WHERE a.elt_account_number=" + elt_account_number + " AND ISNULL(b.ship_status,'')='C' AND a.is_inbound='Y'";
            OutboundSQL = "SELECT a.elt_account_number AS sort_key_detail, Total_Weight_Charge_HAWB AS WillCharge , e.business_city AS B_city, e.business_state AS B_state, a.hawb_num,Shipper_Name,shipper_account_number,Origin_Port_Location,Dest_Port_Location,Carrier_Desc,Carrier_acct,a.mawb_num,Total_Pieces,Adjusted_Weight,Total_Weight_Charge_HAWB,Handling_Info, g.driver_acct as DriverID, h.dba_name as drive_name FROM hawb_master a LEFT OUTER JOIN mawb_number c ON (a.mawb_num=c.mawb_no AND a.elt_account_number=c.elt_account_number) RIGHT OUTER JOIN hawb_master_add b ON (a.hawb_num=b.hawb_num AND a.elt_account_number=b.elt_account_number) LEFT OUTER JOIN organization d ON (a.elt_account_number=d.elt_account_number AND ISNULL(b.customer_acct,0)=d.org_account_number) LEFT OUTER JOIN organization e ON (a.elt_account_number=e.elt_account_number AND a.shipper_Name=e.dba_name) LEFT OUTER JOIN hawb_master_drivers g ON (a.elt_account_number=g.elt_account_number AND g.auto_uid = (select top 1 auto_uid from hawb_master_drivers where hawb_num = a.hawb_num and elt_account_number = " + elt_account_number + " )) LEFT OUTER JOIN organization h ON (g.elt_account_number=h.elt_account_number AND g.driver_acct=h.org_account_number) WHERE a.elt_account_number=" + elt_account_number + " AND ISNULL(b.ship_status,'')='C' AND a.is_inbound='N'";
        }

        InboundSQL = ApplyFilter(InboundSQL) + " ORDER BY a.hawb_num";
        OutboundSQL = ApplyFilter(OutboundSQL) + " ORDER BY a.hawb_num";
        SortInboundSQL = ApplyFilter(SortInboundSQL) + " ORDER BY sort_value";
        SortOutboundSQL = ApplyFilter(SortOutboundSQL) + " ORDER BY sort_value";

        Session["InboundSQL"] = InboundSQL;
        Session["OutboundSQL"] = OutboundSQL;
        Session["SortInboundSQL"] = SortInboundSQL;
        Session["SortOutboundSQL"] = SortOutboundSQL;

        try
        {
            MakeDataSet("InboundSortTable", SortInboundSQL);
            MakeDataSet("OutboundSortTable", SortOutboundSQL);
            MakeDataSet("InboundTable", InboundSQL);
            MakeDataSet("OutboundTable", OutboundSQL);

            // Add relations if more sort options
            ds.Relations.Add("InboundRelation", ds.Tables["InboundSortTable"].Columns["sort_key"], ds.Tables["InboundTable"].Columns["sort_key_detail"]);
            ds.Relations.Add("OutboundRelation", ds.Tables["OutboundSortTable"].Columns["sort_key"], ds.Tables["OutboundTable"].Columns["sort_key_detail"]);
        }
        catch { }
    }

    protected string ApplyFilter(string sqlTxt)
    {
        // period filter
        if (Webdatetimeedit1.Text.Trim() != "")
        {
            sqlTxt += " AND ((a.is_inbound='N' AND CAST(b.transfer_date AS DATETIME)>=CAST('" + Webdatetimeedit1.Text
                + "' AS DATETIME)) OR (a.is_inbound='Y' AND CAST(b.POD_date AS DATETIME)>=CAST('" + Webdatetimeedit1.Text + "' AS DATETIME)))";
        }

        if (Webdatetimeedit2.Text.Trim() != "")
        {
            sqlTxt += " AND ((a.is_inbound='N' AND CAST(b.transfer_date AS DATETIME)<=CAST('" + Webdatetimeedit2.Text
                + "' AS DATETIME)) OR (a.is_inbound='Y' AND CAST(b.POD_date AS DATETIME)<=CAST('" + Webdatetimeedit2.Text + "' AS DATETIME)))";
        }

        // Ports filter
        if (OriginPortSelect.SelectedIndex > 0 && DestPortSelect.SelectedIndex > 0)
        {
            sqlTxt += " AND (c.Origin_Port_ID='" + OriginPortSelect.SelectedValue.ToString() + "' OR c.Dest_Port_ID='" + DestPortSelect.SelectedValue.ToString() + "'";
        }
        else
        {
            if (OriginPortSelect.SelectedIndex > 0)
            {
                sqlTxt += " AND c.Origin_Port_ID='" + OriginPortSelect.SelectedValue.ToString() + "'";
            }
            if (DestPortSelect.SelectedIndex > 0)
            {
                sqlTxt += " AND c.Dest_Port_ID='" + DestPortSelect.SelectedValue.ToString() + "'";
            }
        }

        // Customer filter
        if (hCustomerAcct.Value != "" && hCustomerAcct.Value != "0")
        {
            sqlTxt += " AND b.customer_acct=" + hCustomerAcct.Value.ToString();
           imagb.Visible = true;
        }

        // Carrier filter
        if (hCarrierAcct.Value != "" && hCarrierAcct.Value != "0")
        {
            sqlTxt += " AND c.Carrier_acct=" + hCarrierAcct.Value.ToString();
        }
        return sqlTxt;
    }
    protected void MakeDataSet(string tableName, string sqlText)
    {
        SqlDataAdapter Adap = null;
        SqlConnection Con = null;

        if (sqlText != null && sqlText.Trim() != "")
        {
            try
            {
                DataTable tempTable = new DataTable(tableName);

                ConnectStr = (new igFunctions.DB().getConStr());
                Con = new SqlConnection(ConnectStr);
                Adap = new SqlDataAdapter();

                Con.Open();
                SqlCommand cmd = new SqlCommand(sqlText.ToString(), Con);
                Adap.SelectCommand = cmd;
                Adap.Fill(tempTable);
                ds.Tables.Add(tempTable);
            }
            catch
            {
            }
            finally
            {
                if (Adap != null)
                {
                    Adap.Dispose();
                }
                if (Con != null)
                {
                    Con.Close();
                }
            }
        }
    }

    
    protected void MakeEmptyGridView(GridView gridie, string tableName)
    {
        ds.Tables[tableName].Rows.Add(ds.Tables[tableName].NewRow());
        gridie.DataSource = ds.Tables[tableName].DefaultView;
        gridie.DataBind();
        int columnCount = gridie.Rows[0].Cells.Count;
        gridie.Rows[0].Cells.Clear();
        gridie.Rows[0].Cells.Add(new TableCell());
        gridie.Rows[0].Cells[0].ColumnSpan = columnCount;
        gridie.Rows[0].Cells[0].Text = "No Records Found.";
        gridie.Rows[0].Cells[0].HorizontalAlign = HorizontalAlign.Center;
    }

    protected void GridViewOutSort_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridViewOutSort.PageIndex = e.NewPageIndex;
        PerformSearch();
        BindGridView();
    }

    protected void GridViewInSort_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridViewInSort.PageIndex = e.NewPageIndex;
        PerformSearch();
        BindGridView();
    }

    protected void GridViewOutDetail_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        Child_page_OUT = e.NewPageIndex;
        PerformSearch();
        BindGridView();
    }

    protected void GridViewInDetail_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        Child_page_IN = e.NewPageIndex;
        PerformSearch();
        BindGridView();

    }

    protected void btnGo_Click(object sender, ImageClickEventArgs e)
    {
        LoadParameters();
        PerformSearch();
        BindGridView();
    }

    public string GetTotalCharge(string hawbNum)
    {
        string sqlText = "SELECT Total_Charge FROM hawb_weight_charge WHERE hawb_num='" + hawbNum + "' AND elt_account_number=" + elt_account_number + " UNION SELECT SUM(Amt_HAWB) AS Total_Charge FROM hawb_other_charge WHERE hawb_num='DOH-9003' AND elt_account_number=" + elt_account_number;

        DataTable dt = new DataTable("organization");
        SqlDataAdapter Adap = null;
        SqlConnection Con = null;
        
        double total_charge = 0;

        if (sqlText != null && sqlText.Trim() != "")
        {
            try
            {
                ConnectStr = (new igFunctions.DB().getConStr());
                Con = new SqlConnection(ConnectStr);
                Adap = new SqlDataAdapter();

                Con.Open();
                SqlCommand cmd = new SqlCommand(sqlText.ToString(), Con);
                Adap.SelectCommand = cmd;
                Adap.Fill(dt);
                total_charge = double.Parse(dt.Rows[0]["Total_Charge"].ToString()) + double.Parse(dt.Rows[1]["Total_Charge"].ToString());
            }
            catch
            {
            }
            finally
            {
                if (Adap != null)
                {
                    Adap.Dispose();
                }
                if (Con != null)
                {
                    Con.Close();
                }

            }
        }
        return total_charge.ToString();
    }

    protected void bindChildGridView(string parentTable, string childTable, string childGV, GridView parentGVObj, string dsRelation)
    {
        for (int rowIndex = 0; rowIndex < parentGVObj.Rows.Count; rowIndex++)
        {
            GridView childgv = (GridView)parentGVObj.Rows[rowIndex].FindControl(childGV);
            if (childgv != null)
            {
                DataRow[] subSet = ds.Tables[parentTable].Rows[rowIndex].GetChildRows(ds.Relations[dsRelation]);
                if (Child_page_IN != 0 && dsRelation == "InboundRelation")
                {
                    childgv.PageIndex = Child_page_IN;
                }
                if (Child_page_OUT != 0 && dsRelation == "OutboundRelation")
                {
                    childgv.PageIndex = Child_page_OUT;
                }
                DataTable dt = new DataTable();
                dt = ds.Tables[childTable].Clone();

                if (subSet.Length == 0)
                {
                    if (rowIndex == 0)
                    {

                        int columnCount = parentGVObj.Rows[0].Cells.Count;
                        parentGVObj.Rows[0].Cells[0].ColumnSpan = columnCount;
                        parentGVObj.Rows[0].Cells[0].Text = "No Records Found.";
                        parentGVObj.Rows[0].Cells[0].HorizontalAlign = HorizontalAlign.Center;
                    }
                    else
                    {
                        parentGVObj.Rows[rowIndex].Visible = false;
                    }

                }
                else
                {
                    for (int i = 0; i < subSet.Length; i++)
                    {
                        dt.Rows.Add(subSet[i].ItemArray);
                    }
                    childgv.PageIndex = 20;
                    childgv.DataSource = dt;
                    childgv.DataBind();
                    if (parentGVObj.Rows[0].Cells[0].Text == "No Records Found.")
                    {
                        parentGVObj.Rows[0].Visible = false;
                    }
                }
            }
        }
    }

    protected void LoadPorts()
    {
        string sqlText = "SELECT port_code,port_desc from port where elt_account_number="
            + elt_account_number + " AND ISNULL(port_country_code,'')='US'";
        DataTable dt = new DataTable("email_title");
        SqlDataAdapter Adap = null;
        SqlConnection Con = null;

        if (sqlText != null && sqlText.Trim() != "")
        {
            try
            {
                ConnectStr = (new igFunctions.DB().getConStr());
                Con = new SqlConnection(ConnectStr);
                Adap = new SqlDataAdapter();
                ds = new DataSet();

                Con.Open();
                SqlCommand cmd = new SqlCommand(sqlText.ToString(), Con);
                Adap.SelectCommand = cmd;
                Adap.Fill(dt);
            }
            catch
            {
            }
            finally
            {
                if (Adap != null)
                {
                    Adap.Dispose();
                }
                if (Con != null)
                {
                    Con.Close();
                }
            }
        }

        for (int i = 0; i < dt.Rows.Count; i++)
        {
            OriginPortSelect.Items.Add(new ListItem(dt.Rows[i]["port_desc"].ToString(), dt.Rows[i]["port_code"].ToString()));
            DestPortSelect.Items.Add(new ListItem(dt.Rows[i]["port_desc"].ToString(), dt.Rows[i]["port_code"].ToString()));
        }
    }


    protected void SENDMAIL(object sender, EventArgs e)
    {
        PerformSearch();
        string fileLocation = "C://temp//Customer_daily_Recap_" + System.DateTime.Today.ToString("yyyy-MM-dd") + ".pdf";
        string orgNum = hCustomerAcct.Value.ToString();
        if (orgNum != "" && orgNum != "0")
        {
            try
            {
                File.Delete(fileLocation);
                rsm = new ReportSourceManager();
                rsm.LoadDataSet(ds);
                rsm.LoadCompanyInfo(elt_account_number, Server.MapPath("../../ClientLogos/" + elt_account_number + ".jpg"));
                rsm.LoadOtherInfo(AddFilter());
                rsm.WriteXSD(Server.MapPath("../../CrystalReportResources/xsd/customer_recap.xsd"));
                rsm.BindNow(Server.MapPath("../../CrystalReportResources/rpt/customer_recap.rpt"));
                Response.Clear();
                MemoryStream oStream;
                oStream = (MemoryStream)rsm.getReportDocument().ExportToStream(ExportFormatType.PortableDocFormat);
                FileStream fs = new FileStream(fileLocation, FileMode.CreateNew, FileAccess.Write);
                fs.Write(oStream.ToArray(), 0, oStream.ToArray().Length);
                fs.Close();
                oStream.Close();
            }
            catch { }
            finally
            {
                //rsm.CloseReportDocumnet();
                Response.Flush();                   
            }
            reload.Value = "Y";
        }
    }

    protected void ExcelPrintButton_Click(object sender, EventArgs e)
    {
        Response.Clear();
        Response.AddHeader("content-disposition", "attachment;filename=customer_recap_" + System.DateTime.Today.ToString("yyyy-MM-dd") + ".xls");
        Response.Charset = "";

        // If you want the option to open the Excel file without saving then
        // comment out the line below
        // Response.Cache.SetCacheability(HttpCacheability.NoCache);
        Response.ContentType = "application/vnd.xls";
        System.IO.StringWriter stringWrite = new System.IO.StringWriter();
        System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
        GridViewOutSort.RenderControl(htmlWrite);
        GridViewInSort.RenderControl(htmlWrite);
        Response.Write(stringWrite.ToString());
        Response.End();
    }

    protected void PDFPrintButton_Click(object sender, EventArgs e)
    {
        PerformSearch();

        try
        {

            rsm = new ReportSourceManager();
            rsm.LoadDataSet(ds);
            rsm.LoadCompanyInfo(elt_account_number, Server.MapPath("../../ClientLogos/" + elt_account_number + ".jpg"));
            rsm.LoadOtherInfo(AddFilter());
            rsm.WriteXSD(Server.MapPath("../../CrystalReportResources/xsd/customer_recap.xsd"));
            rsm.BindNow(Server.MapPath("../../CrystalReportResources/rpt/customer_recap.rpt"));
            Response.Clear();
            Response.Buffer = true;
            Response.ContentType = "application/pdf";
            Response.AddHeader("Content-Type", "application/pdf");
            Response.AddHeader("Content-disposition", "attachment;filename=customer_recap_" + System.DateTime.Today.ToString("yyyy-MM-dd") + ".pdf");

            MemoryStream oStream;
            oStream = (MemoryStream)rsm.getReportDocument().ExportToStream(ExportFormatType.PortableDocFormat);
            Response.BinaryWrite(oStream.ToArray());
        }
        catch { }
        finally
        {
            rsm.CloseReportDocumnet();
            Response.Flush();
            Response.End();
        }
    }

    public override void VerifyRenderingInServerForm(Control control)
    {
        /* Confirms that an HtmlForm control is rendered for the specified ASP.NET
           server control at run time. */
    }

    protected string[] AddFilter()
    {
        string[] returnObj = new string[10];

        returnObj[0] = lstShipmentType.Items[lstShipmentType.SelectedIndex].Text;
        if (Webdatetimeedit1.Text.ToString() == "")
        {
            returnObj[1] = "ALL TIME";// specially used for the ALL DATE SELECTION
        }
        else
        {
            returnObj[1] = Webdatetimeedit1.Text;// specially used for the ALL DATE SELECTION
        }
        if (Webdatetimeedit2.Text.ToString() == "")
        {
            returnObj[2] = "ALL TIME";// specially used for the ALL DATE SELECTION
        }
        else
        {
            returnObj[2] = Webdatetimeedit2.Text;
        }

        returnObj[3] = lstCustomerName.Text;
        returnObj[4] = lstSortBy.SelectedValue;
        returnObj[5] = lstCarrier.Text;
        returnObj[6] = OriginPortSelect.Items[OriginPortSelect.SelectedIndex].Text;
        returnObj[7] = DestPortSelect.Items[DestPortSelect.SelectedIndex].Text;

        return returnObj;
    }

    public string GetDrivers(object hawbNum)
    {
        string sqlText = "SELECT distinct b.dba_name from hawb_master_drivers a LEFT OUTER JOIN organization b ON (a.elt_account_number=b.elt_account_number AND a.driver_acct=b.org_account_number) WHERE a.elt_account_number=" + elt_account_number + " AND a.hawb_num='" + hawbNum.ToString() + "'";
        DataTable dt = new DataTable("organization");
        SqlDataAdapter Adap = null;
        SqlConnection Con = null;
        string driverList = "";

        if (sqlText != null && sqlText.Trim() != "")
        {
            try
            {
                ConnectStr = (new igFunctions.DB().getConStr());
                Con = new SqlConnection(ConnectStr);
                Adap = new SqlDataAdapter();

                Con.Open();
                SqlCommand cmd = new SqlCommand(sqlText.ToString(), Con);
                Adap.SelectCommand = cmd;
                Adap.Fill(dt);
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    if (driverList != "")
                    {
                        driverList = driverList + "; ";
                    }
                    driverList += dt.Rows[i][0].ToString();
                }
            }
            catch
            {
            }
            finally
            {
                if (Adap != null)
                {
                    Adap.Dispose();
                }
                if (Con != null)
                {
                    Con.Close();
                }

            }
        }
        return driverList;
    }
}