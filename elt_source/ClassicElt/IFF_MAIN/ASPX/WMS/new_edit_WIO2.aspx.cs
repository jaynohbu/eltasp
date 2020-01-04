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


public partial class ASPX_WMS_new_edit_WIO2 : System.Web.UI.Page
{
    protected DataSet ds = null;
    protected string ConnectStr = null;
    private string elt_account_number = null;
    private string user_id, login_name, user_right;
    private int maxRows = 10;
    protected ReportSourceManager rsm = null;
    private int Child_page_IN = 0;
    private int Child_page_IN2 = 0;
    private int Child_page_OUT = 0;
    private int Child_page_OUT2 = 0;
    private int total_number1 = 0;
    private int total_number2 = 0;
    private int total_number3 = 0;
    private string sortby = "";
    private string sortby2 = "";
    private string sortby3 = "";
    private string isEmptyIn = null;
    private string isEmptyOut = null;
    string SortWRSQL = "";
    string SortSoSQL = "";
    string InOutSQL = "";
    string InOutSQL2 = "";
    string InSQLText = "";
    string NonShipSQL = "";

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
            pageAction();
        }
    }

    protected void LoadParameters()
    {
        GridViewWRSort.PageIndex = 0;
        GridViewSoSort.PageIndex = 0;
        GridViewSoSortCustomer.PageIndex = 0;
        GridViewWRSortCustomer.PageIndex = 0;
        sortway.Visible = false;
        sortway2.Visible = false;
        sortwayB.Visible = false;
        sortway2B.Visible = false;
        sortway.Text="";
        sortway2.Text="";
        sortwayB.Text="";
        sortway2B.Text = "";
    }

    protected void pageAction()
    {
        PerformSearch();
        BindGridView();
    }
    protected void InitializeForm()
    {
        Webdatetimeedit1.Text = System.DateTime.Today.ToString("MM/dd/yyyy");
        Webdatetimeedit2.Text = System.DateTime.Today.ToString("MM/dd/yyyy");
    }

    protected void BindGridView()
    {
        try
        {
            if (ds.Tables["SortWRSQLTable"] == null) { }
            else if (ds.Tables["SortWRSQLTable"].Rows.Count == 0)
            {
                MakeEmptyGridView(GridViewWRSort, "SortWRSQLTable");
                MakeEmptyGridView(GridViewWRSortCustomer, "SortWRSQLTable");
                isEmptyIn = "Y";
            }
            else
            {
                GridViewWRSort.PageSize = maxRows;
                GridViewWRSort.DataSource = ds.Tables["SortWRSQLTable"].DefaultView;
                GridViewWRSort.DataBind();
                GridViewWRSortCustomer.PageSize = maxRows;
                GridViewWRSortCustomer.DataSource = ds.Tables["SortWRSQLTable"].DefaultView;
                GridViewWRSortCustomer.DataBind();
                isEmptyIn = null;
            }


            if (ds.Tables["IOEmptyTable"].Rows.Count == 0)
            {
                
                MakeEmptyGridView2(GridView2, "IOEmptyTable");
                GridView2.Visible = false;
            }
            else
            {

                    GridView2.PageSize = maxRows;
                    GridView2.DataSource = ds.Tables["IOEmptyTable"].DefaultView;
                    GridView2.DataBind();
            }

            if (ds.Tables["IOEmptyTable"].Rows.Count == 0)
            {
                
                MakeEmptyGridView2(GridView2, "IOEmptyTable");
                GridView3.Visible = false;
            }
            else
            {

                GridView3.PageSize = maxRows;
                GridView3.DataSource = ds.Tables["IOEmptyTable"].DefaultView;
                GridView3.DataBind();
            }


            if (ds.Tables["SortSoSQLTable"] == null) { }
            else if (ds.Tables["SortSoSQLTable"] == null || ds.Tables["SortSoSQLTable"].Rows.Count == 0)
            {
                MakeEmptyGridView(GridViewSoSort, "SortSoSQLTable");
                MakeEmptyGridView(GridViewSoSortCustomer, "SortSoSQLTable");
                isEmptyIn = "Y";
            }
            else
            {
                GridViewSoSort.PageSize = maxRows;
                GridViewSoSort.DataSource = ds.Tables["SortSoSQLTable"].DefaultView;
                GridViewSoSort.DataBind();
                GridViewSoSortCustomer.PageSize = maxRows;
                GridViewSoSortCustomer.DataSource = ds.Tables["SortSoSQLTable"].DefaultView;
                GridViewSoSortCustomer.DataBind();
            }

            if (lstSortBy.SelectedIndex == 0)
            {
                GridViewSoSort.Visible = false;
                GridView2.Visible = false;
                GridViewSoSortCustomer.Visible = false;
                GridView3.Visible = false;
                if (hAccountOfAcct.Value != "" && hAccountOfAcct.Value != "0")
                {
                    if (checkpart2() == true)
                    {
                        GridViewWRSort.Visible = false;
                        GridViewWRSortCustomer.Visible = true;
                    }
                    else
                    {
                        GridViewWRSort.Visible = true;
                        GridViewWRSortCustomer.Visible = false;
                    }

                }
                else
                {
                    GridViewWRSort.Visible = true;
                    GridViewWRSortCustomer.Visible = false;
                }



                bindChildGridView("SortWRSQLTable", "InOutSQLTable", "GridViewWRDetail", GridViewWRSort, "WRRelation");
                bindChildGridView("SortWRSQLTable", "InOutSQLTable", "GridViewWRCustomerDetail", GridViewWRSortCustomer, "WRRelation");
            }
            else if (lstSortBy.SelectedIndex == 1)
            {
                
                if (hAccountOfAcct.Value != "" && hAccountOfAcct.Value != "0")
                {
                    if (checkpart2() == true)
                    {
                        GridViewSoSort.Visible = false;
                        GridView2.Visible = false;
                        GridViewSoSortCustomer.Visible = true;
                        GridView3.Visible = true;
                    }
                    else
                    {
                        GridViewSoSort.Visible = true;
                        if (ds.Tables["IOEmptyTable"].Rows.Count != 0)
                        {
                            if (checkpart2a() == true)
                            {
                                GridView2.Visible = true;
                            }
                            else
                            {
                                GridView2.Visible = false;
                            }
                        }
                        else
                        {
                            GridView2.Visible = false;
                        }
                        GridViewSoSortCustomer.Visible = false;
                        GridView3.Visible = false;

                    }

                }
                else
                {
                    GridViewSoSort.Visible = true;
                    if (ds.Tables["IOEmptyTable"].Rows.Count != 0)
                    {
                         if (checkpart2a() == true)
                            {
                                GridView2.Visible = true;
                            }
                            else
                            {
                                GridView2.Visible = false;
                            }
                    }
                    GridViewSoSortCustomer.Visible = false;
                    GridView3.Visible = false;
                }

                if (GridView2.Rows[0].Cells[0].Text.ToString() == "None")
                {
                    GridView2.Visible = false;
                    GridView3.Visible = false;
                }

                else
                {
                    //if(GridViewSoSort.Rows[0].Cells[0].Text.ToString ==)
                }

                GridViewWRSort.Visible = false;
                GridViewWRSortCustomer.Visible = false;
                bindChildGridView("SortSoSQLTable", "InOutSQLTable2", "GridViewSoDetail", GridViewSoSort, "SORelation");
                bindChildGridView("SortSoSQLTable", "InOutSQLTable2", "GridViewSoDetailCustomer", GridViewSoSortCustomer, "SORelation");
            }
            Get_total();
            
       }
        catch { }
    }

    protected void PerformSearch()
    {
        ds = new DataSet();

        
        InSQLText = "select b.dba_name as shipper_name, c.dba_name as customer_name, b.dba_name as received_name,"
            + " a.* from warehouse_receipt a left join organization b "
            + " on (a.elt_account_number=b.elt_account_number and a.shipper_acct = b.org_account_number) "
            + " left join organization c "
            + " on (a.elt_account_number=c.elt_account_number and a.customer_acct = c.org_account_number) ";


        if (lstShipOut.Text != "" || txtCustomerRef2.Text != "" || txtPO2.Text != "")
        {
            InSQLText = InSQLText + " left join warehouse_history d "
                + " on (a.elt_account_number=c.elt_account_number and a.wr_num = d.wr_num) "
                + " left join warehouse_shipout e "
                + " on (a.elt_account_number=c.elt_account_number and d.so_num = e.so_num) ";
        }

        InSQLText = InSQLText + " where a.elt_account_number=" + elt_account_number + " AND ISNULL(a.job_status,'Pending')='Pending'"
            + " AND a.item_piece_remain>=0 and a.item_piece_origin > 0 and isnull(a.wr_num,'') <> ''";

        //No shipout warehouse item
       NonShipSQL = "select  a.*, b.dba_name as rec_name, c.dba_name as customer_name from warehouse_receipt a left join organization b "
        + " on (a.elt_account_number=b.elt_account_number and a.shipper_acct = b.org_account_number) "
        + " left join organization c "
        + " on (a.elt_account_number=c.elt_account_number and a.customer_acct = c.org_account_number) ";

        NonShipSQL = NonShipSQL + " where a.elt_account_number=" + elt_account_number + " AND ISNULL(a.wr_num,'')!=''"
            + " AND a.item_piece_remain = a.item_piece_origin and a.wr_num <> all(select wr_num from warehouse_history where history_type = 'Ship-out Made' and elt_account_number="+ elt_account_number+")";
        //Sort by WR number SQL
        SortWRSQL = " SELECT distinct wr_num as sort_key,wr_num as sort_value, auto_uid as auto_uid from Warehouse_receipt where elt_account_number =" + elt_account_number;
        //Sort by So number SQL
        SortSoSQL = " SELECT distinct so_num as sort_key, so_num as sort_value, auto_uid as auto_uid from warehouse_shipout where elt_account_number =" + elt_account_number;
        //Main SQL for In and Out
        InOutSQL = "SELECT g.dba_name as shipper_name, c.dba_name as customer_name, a.customer_acct as customer_no, e.auto_uid  as so_uid ,g.dba_name as shipout_name, d.history_type as history_type, "
        + " a.*,d.so_num as so_no,(e.shipout_date - 1 ) as shipout_date ,d.item_piece_shipout as item_shipout,d.item_piece_remain as item_remain,e.consignee_acct as shipout_acct, b.dba_name as rec_name "
        + " ,(d.item_piece_remain + d.item_piece_shipout) as remain_QTY , e.PO_NO as PONO, e.customer_ref_no as customer_ref from warehouse_receipt a left join organization b "
        + " on (a.elt_account_number=b.elt_account_number and a.shipper_acct = b.org_account_number) "
        + " left join organization c "
        + " on (a.elt_account_number=c.elt_account_number and a.customer_acct = c.org_account_number) "
        + " left join warehouse_history d "
        + " on (a.elt_account_number=c.elt_account_number and a.wr_num = d.wr_num) "
        + " left join warehouse_shipout e "
        + " on (a.elt_account_number=c.elt_account_number and d.so_num = e.so_num) "
        + " left join organization g "
        + " on (a.elt_account_number=g.elt_account_number and e.consignee_acct = g.org_account_number)"
        + " where a.elt_account_number=" + elt_account_number + " AND ISNULL(a.job_status,'Pending')='Pending'"
        + " and (ISNULL(d.so_num, '') <>'' or (a.elt_account_number =" + elt_account_number + " and a.item_piece_remain = a.item_piece_origin and history_type = 'Warehouse Created')) "
        + " and a.customer_acct >'0' and isNUll(a.customer_acct,'0') <> '0'";
        
        if (sortby == "")
        {
            if (sortwayB.Text.ToString() == "")
            {
                sortby = "a.wr_num";
            }
            else
            {
                sortby = sortwayB.Text.ToString();
            }

        }
        else
        {
            sortwayB.Text = sortby.ToString();
            if (sortby.ToString() == sortway.Text)
            {
                sortway.Text = "";
            }
            else
            {
                sortway.Text = sortby.ToString();
            }
        }
        if (sortby2 == "")
        {
            if (sortway2B.Text.ToString() == "")
            {
                sortby2 = "so_no";
                sortby3 = "a.wr_num";
            }
            else
            {
                sortby2 = sortway2B.Text.ToString();
                sortby3 = sortway2B.Text.ToString();
            }
        }
        else
        {
            sortway2B.Text = sortby2.ToString();
            if (sortby2.ToString() == sortway2.Text)
            {
                sortway2.Text = "";
            }
            else
            {
                sortway2.Text = sortby2.ToString();
            }
        }
        if (lstSortBy.SelectedValue == "WR")
        {
            InOutSQL = ApplyFilter(InOutSQL) + " ORDER BY " + sortby;
            if (sortby.ToString() == sortway.Text)
            {
                InOutSQL = InOutSQL + " DESC";
            }
            sortby = "";
        }
        else
        {
            InOutSQL2 = ApplyFilter(InOutSQL) + " ORDER BY " + sortby2;
            NonShipSQL = ApplyFilter2(NonShipSQL) + " ORDER BY a.wr_num";
            InSQLText = ApplyFilter(InSQLText) + " ORDER BY a.auto_uid";
            if (sortby2.ToString() == sortway2.Text)
            {
                InOutSQL2 = InOutSQL2 + " DESC";
                NonShipSQL = NonShipSQL + " DESC";
            }

            sortby3 = "";
            sortby2 = "";
        }
 
        SortWRSQL = SortWRSQL + " ORDER BY auto_uid";
        SortSoSQL = SortSoSQL + " ORDER BY auto_uid";
        
        Session["SortWRSQL"] = SortWRSQL;//Sort by WR number
        Session["SortSoSQL"] = SortSoSQL;//Sort by SO number
        Session["InOutSQL"] = InOutSQL;//In & Out
        Session["InOutSQL2"] = InOutSQL2;//In & Out
        Session["WrInSQL"] = NonShipSQL;//non shipout warehouse
        Session["InSQL"] = InSQLText;//In only SQL

        try
        {
            MakeDataSet("InOutSQLTable", InOutSQL);// sort by WR number in and out
            MakeDataSet("InOutSQLTable2", InOutSQL2);//sort by So number In and Out
            MakeDataSet("SortSoSQLTable", SortSoSQL); // Shipout number table
            MakeDataSet("SortWRSQLTable", SortWRSQL);//Warehouse number table
            MakeDataSet("IOEmptyTable", NonShipSQL); //non ship out warehouse data set
            MakeDataSet("InOnlyTable", InSQLText);//In only data Set

            //MakeDataSet("InOutSQLTable", OutboundSQL);

            // Add relations if more sort options
            //Sort by Warehouse number relation
            ds.Relations.Add("WRRelation", ds.Tables["SortWRSQLTable"].Columns["sort_key"], ds.Tables["InOutSQLTable"].Columns["wr_num"]);
            //Sort by Ship out number relation
            ds.Relations.Add("SORelation", ds.Tables["SortSoSQLTable"].Columns["sort_key"], ds.Tables["InOutSQLTable2"].Columns["so_no"]);
        }
        catch { }
    }









    protected void PerformSearch2()
    {
        ds = new DataSet();
        string NonShipSQL2 = "";
        string InOutSQL2 = "";


       
        InOutSQL2 = "SELECT g.dba_name as shipper_name, c.dba_name as customer_name, a.customer_acct as customer_no, e.auto_uid  as so_uid ,g.dba_name as shipout_name, d.history_type as history_type, "
        + " a.*,d.so_num as so_no,(e.shipout_date - 1 ) as shipout_date ,d.item_piece_shipout as item_shipout,d.item_piece_remain as item_remain,e.consignee_acct as shipout_acct, b.dba_name as rec_name "
        + " ,(d.item_piece_remain + d.item_piece_shipout) as remain_QTY , e.PO_NO as PONO, e.customer_ref_no as customer_ref from warehouse_receipt a left join organization b "
        + " on (a.elt_account_number=b.elt_account_number and a.shipper_acct = b.org_account_number) "
        + " left join organization c "
        + " on (a.elt_account_number=c.elt_account_number and a.customer_acct = c.org_account_number) "
        + " left join warehouse_history d "
        + " on (a.elt_account_number=c.elt_account_number and a.wr_num = d.wr_num) "
        + " left join warehouse_shipout e "
        + " on (a.elt_account_number=c.elt_account_number and d.so_num = e.so_num) "
        + " left join organization g "
        + " on (a.elt_account_number=g.elt_account_number and e.consignee_acct = g.org_account_number)"
        + " where a.elt_account_number=" + elt_account_number + " AND ISNULL(a.job_status,'Pending')='Pending'"
        + " and (ISNULL(d.so_num, '') <>'' or (a.elt_account_number =" + elt_account_number + " and a.item_piece_remain = a.item_piece_origin and history_type = 'Warehouse Created')) "
        + " and a.customer_acct >'0' and isNUll(a.customer_acct,'0') <> '0'";

       Session["InOutSQL2"] = InOutSQL2;//In & Out


        try
        {
            MakeDataSet("InOutSQLTable", InOutSQL2);// sort by WR number in and out

        }
        catch { }
    }




    //Main Filter 
    protected string ApplyFilter(string sqlText)
    {
        object orgAcctObj = Request.Form.Get("hAccountOfAcct");

        if (checkpart2()==true)
        {
            if (orgAcctObj != null && orgAcctObj.ToString().Trim() != "" && orgAcctObj.ToString() != "0")
            {
                sqlText = sqlText + " AND a.customer_acct=" + orgAcctObj.ToString();
            }
            if (orgAcctObj != null && orgAcctObj.ToString().Trim() != "" && orgAcctObj.ToString() != "0")
            {
                sqlText = sqlText + " AND a.customer_acct=" + orgAcctObj.ToString();
            }

            if (Webdatetimeedit1.Text != "")
            {
                sqlText = sqlText + " AND a.received_date >= '" + Webdatetimeedit1.Text + "'";
            }
            if (Webdatetimeedit2.Text != "")
            {
                sqlText = sqlText + " AND a.received_date <= '" + Webdatetimeedit2.Text + "'";
            }
        }

        //Search part 2 change by stanley on 11/14/2007
        if (txtPO.Text != "")
        {
            sqlText = sqlText + " AND a.PO_NO like N'" + txtPO.Text + "%'";

        }

        if (lstSearchNum.Text != "")
        {
            sqlText = sqlText + " AND a.wr_num like N'" + lstSearchNum.Text + "%'";
        }

        if (txtPO.Text != "")
        {
            sqlText = sqlText + " AND a.PO_NO like N'" + txtPO.Text + "%'";

        }
        if (txtCustomerRef2.Text != "")
        {
            sqlText = sqlText + " AND e.customer_ref_no like N'" + txtCustomerRef2.Text + "%'";
        }
        if (txtCustomerRef.Text != "")
        {
            sqlText = sqlText + " AND a.customer_ref_no like N'" + txtCustomerRef.Text + "%'";
        }
        if (lstShipOut.Text != "")
        {
            sqlText = sqlText + " AND e.so_num like N'" + lstShipOut.Text + "%'";
        }

        if (txtPO2.Text != "")
        {
            sqlText = sqlText + " AND e.Po_No like N'" + txtPO2.Text + "%'";

        }
        
        return sqlText;
    }

    //Part2 Warehouse filter Check
    protected bool checkpart2()
    {
        bool partvalue=false;
          if (lstSearchNum.Text == "" && txtPO.Text == "" && txtCustomerRef.Text == "")
          {
              if (checkpart2a()==true)
            {
                partvalue=true;
            }
          }
          return partvalue;
    }

    //Part2 Shopout filter Check
    protected bool checkpart2a()
    {
        bool partvalue = false;

            if (lstShipOut.Text == "" && txtPO2.Text == "" && txtCustomerRef2.Text == "")
            {
                partvalue = true;
            }
        return partvalue;
    }
    
    //filter for Non shipout warehouse
    protected string ApplyFilter2(string sqlText)
    {
        object orgAcctObj = Request.Form.Get("hAccountOfAcct");
        if (checkpart2() == true)
        {
            if (orgAcctObj != null && orgAcctObj.ToString().Trim() != "" && orgAcctObj.ToString() != "0")
            {
                sqlText = sqlText + " AND a.customer_acct=" + orgAcctObj.ToString();
            }
            if (orgAcctObj != null && orgAcctObj.ToString().Trim() != "" && orgAcctObj.ToString() != "0")
            {
                sqlText = sqlText + " AND a.customer_acct=" + orgAcctObj.ToString();
            }

            if (Webdatetimeedit1.Text != "")
            {
                sqlText = sqlText + " AND a.received_date >= '" + Webdatetimeedit1.Text + "'";
            }
            if (Webdatetimeedit2.Text != "")
            {
                sqlText = sqlText + " AND a.received_date <= '" + Webdatetimeedit2.Text + "'";
            }
        }

        //Search part 2 change by stanley on 11/14/2007
        if (txtPO.Text != "")
        {
            sqlText = sqlText + " AND a.PO_NO like N'" + txtPO.Text + "%'";

        }

        if (lstSearchNum.Text != "")
        {
            sqlText = sqlText + " AND a.wr_num like N'" + lstSearchNum.Text + "%'";
        }

        if (txtCustomerRef.Text != "")
        {
            sqlText = sqlText + " AND a.customer_ref_no like N'" + txtCustomerRef.Text + "%'";
        }
        return sqlText;
    }

    //get csutomer Name for Customer Search
    public string GetCustomer()
    {
        string CustomerName="";
        object orgAcctObj = Request.Form.Get("lstAccountOfName");
        object orgAcct2 = Request.Form.Get("hAccountOfAcct");
        if (lstSortBy.SelectedIndex == 1)
        {
            if (ds.Tables["InOutSQLTable2"].Rows.Count != 0)
            {

                if (orgAcct2 != "" && orgAcct2 != null)
                {
                    CustomerName = orgAcctObj.ToString();
                }
            }
        }
        else
        {
            if (ds.Tables["InOutSQLTable"].Rows.Count != 0)
            {

                if (orgAcct2 != "" && orgAcct2 != null)
                {
                    CustomerName = orgAcctObj.ToString();
                }
            }
        }
        return CustomerName.ToString();
    }
    public string GetCustomerNo()
    {
        string CustomerNo = "";
        object orgAcct2 = Request.Form.Get("hAccountOfAcct");
        if (lstSortBy.SelectedIndex == 1)
        {
            if (ds.Tables["InOutSQLTable2"].Rows.Count != 0)
            {

                if (orgAcct2 != "" && orgAcct2 != null)
                {
                    CustomerNo = orgAcct2.ToString();
                }
            }
        }
        else
        {
            if (ds.Tables["InOutSQLTable"].Rows.Count != 0)
            {

                if (orgAcct2 != "" && orgAcct2 != null)
                {
                    CustomerNo = orgAcct2.ToString();
                }
            }
        }
        return CustomerNo.ToString();
    }

   
    public string GetShipout(string SoNumber)
    {

        if (SoNumber == null || SoNumber == "")
        {
            return "None";
        }
        else
        {
            return SoNumber.ToString();
        }
    }
    protected void Get_total()
    {
        total_number1 = 0;
        total_number2 = 0;
        total_number3 = 0;

            foreach (DataRow eRow in ds.Tables["InOutSQLTable"].Rows)
            {
                try
                {
                    total_number1 = total_number1 + int.Parse(eRow["item_piece_origin"].ToString());
                }
                catch
                {
                    Response.Write(eRow["item_piece_origin"].ToString());
                    Response.End();

                }
            }

            foreach (DataRow aRow in ds.Tables["InOutSQLTable"].Rows)
            {
                try
                {
                    total_number2 = total_number2 + int.Parse(aRow["item_shipout"].ToString());

                }
                catch
                {
                    Response.Write(aRow["item_shipout"].ToString());
                    Response.End();

                }
            }
            if (lstSortBy.SelectedIndex == 0)
            {
                label1.Text = "Total";
                label2.Text = total_number2.ToString();
                label3.Text = "";

            }
            else if (lstSortBy.SelectedIndex == 1)
            {
                label1.Text = "";
                label2.Text = "";
                label3.Text = "";
            }
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

    protected void MakeEmptyGridView2(GridView gridie, string tableName)
    {
        ds.Tables[tableName].Rows.Add(ds.Tables[tableName].NewRow());
        gridie.DataSource = ds.Tables[tableName].DefaultView;
        gridie.DataBind();
        int columnCount = gridie.Rows[0].Cells.Count;
        gridie.Rows[0].Cells.Clear();
        gridie.Rows[0].Cells.Add(new TableCell());
        gridie.Rows[0].Cells[0].ColumnSpan = columnCount;
        gridie.Rows[0].Cells[0].Text = "None";
        gridie.Rows[0].Cells[0].HorizontalAlign = HorizontalAlign.Center;
        gridie.Visible = false;
    }

    protected void sortchange(object sender, GridViewPageEventArgs e)
    {
        pageAction();

    }
    protected void Page_change(object sender, EventArgs e)
    {
        LoadParameters();
        pageAction();
    }
    protected void GridViewSoSort_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridViewSoSort.PageIndex = e.NewPageIndex;
        pageAction();
    }
    protected void GridView2_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView2.PageIndex = e.NewPageIndex;
        pageAction();
    }
    protected void GridView3_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView3.PageIndex = e.NewPageIndex;
        pageAction();
    }
    protected void GridViewSoSortCustomer_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridViewSoSortCustomer.PageIndex = e.NewPageIndex;
        pageAction();
    }
    protected void GridViewWRSort_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridViewWRSort.PageIndex = e.NewPageIndex;
        pageAction();
    }
    protected void GridViewWRSortCustomer_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridViewWRSortCustomer.PageIndex = e.NewPageIndex;
        pageAction();
    }

    protected void GridViewSoDetail_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        Child_page_OUT = e.NewPageIndex;
        pageAction();
    }

    protected void GridViewSoDetailCustomer_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        Child_page_OUT2 = e.NewPageIndex;
        pageAction();
    }

    protected void GridViewWRDetail_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        Child_page_IN = e.NewPageIndex;
        pageAction();
    }

    protected void GridViewWRCustomerDetail_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        Child_page_IN2 = e.NewPageIndex;
        pageAction();

    }
    protected void btnGo_Click(object sender, ImageClickEventArgs e)
    {
        sortby = "";
        sortby2 = "";
        LoadParameters();
        pageAction();
    }

    protected void Date_Click(object sender, ImageClickEventArgs e)
    {
        sortby = "";
        sortby2 = "a.received_date";
        pageAction();
    }
    protected void WR2_Click(object sender, ImageClickEventArgs e)
    {
        sortby2 = "a.auto_uid";
        sortby = "";
        pageAction();

    }
    protected void SODate_Click(object sender, ImageClickEventArgs e)
    {
        sortby2 = "";
        sortby = "e.shipout_date";
        pageAction();
    }
    protected void SO_Click(object sender, ImageClickEventArgs e)
    {
        sortby2 = "";
        sortby = "e.auto_uid";
        pageAction();
    }
  
   
    protected void bindChildGridView(string parentTable, string childTable, string childGV, GridView parentGVObj, string dsRelation)
    {
        for (int rowIndex = 0; rowIndex < parentGVObj.Rows.Count; rowIndex++)
        {
            GridView childgv = (GridView)parentGVObj.Rows[rowIndex].FindControl(childGV);
            if (childgv != null)
            {
                DataRow[] subSet = ds.Tables[parentTable].Rows[rowIndex].GetChildRows(ds.Relations[dsRelation]);
                if (Child_page_IN != 0 && dsRelation == "WRRelation")
                {
                    childgv.PageIndex = Child_page_IN;
                }
                if (Child_page_OUT != 0 && dsRelation == "SORelation")
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
                        if (GridViewSoSort.Rows[0].Cells[0].Text.ToString() == "No Records Found." )
                        {
                            
                            parentGVObj.Rows[0].Cells[0].Text = "";
                            if (GridView2.Rows[0].Cells[0].Text.ToString() != "None")
                            {
                                
                                if (checkpart2a() == true)
                                {
                                    GridViewSoSortCustomer.Rows[0].Cells[0].Text = "";
                                    GridViewSoSort.Rows[0].Cells[0].Text = "";
                                }
                                else
                                {
                                    parentGVObj.Rows[0].Cells[0].Text = "No Records Found.";

                                }
                            
                            }
                            else
                            {
                                parentGVObj.Rows[0].Cells[0].Text = "No Records Found.";
                            }
             
                        }
                        else
                        {
                            parentGVObj.Rows[0].Cells[0].Text = "No Records Found.";
                        }
                        //parentGVObj.Rows[0].Cells[0].Text = "No Records Found.";
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


    protected void ExcelPrintButton_Click(object sender, EventArgs e)
    {
        Response.Clear();
        Response.AddHeader("content-disposition", "attachment;filename=Warehouse_InOut_" + System.DateTime.Today.ToString("yyyy-MM-dd") + ".xls");
        Response.Charset = "";

        // If you want the option to open the Excel file without saving then
        // comment out the line below
        // Response.Cache.SetCacheability(HttpCacheability.NoCache);
        Response.ContentType = "application/vnd.xls";
        System.IO.StringWriter stringWrite = new System.IO.StringWriter();
        System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
        GridViewSoSort.RenderControl(htmlWrite);
        GridViewWRSort.RenderControl(htmlWrite);
        Response.Write(stringWrite.ToString());
        Response.End();
    }

    protected void PDFPrintButton_Click(object sender, EventArgs e)
    {
        PerformSearch2();

        try
        {

            rsm = new ReportSourceManager();
            rsm.LoadDataSet(ds);
            rsm.LoadCompanyInfo(elt_account_number, Server.MapPath("../../ClientLogos/" + elt_account_number + ".jpg"));
            rsm.LoadOtherInfo(AddFilter());
            rsm.WriteXSD(Server.MapPath("../../CrystalReportResources/xsd/new_edit_InOut.xsd"));
            if(PDFPrint.SelectedIndex == 1)
            {
                rsm.BindNow(Server.MapPath("../../CrystalReportResources/rpt/WarehouseINReport2.rpt"));
            }
            else if(PDFPrint.SelectedIndex ==2)
            {
                rsm.BindNow(Server.MapPath("../../CrystalReportResources/rpt/WarehouseINReport2.rpt"));
            }
            else
            {
                rsm.BindNow(Server.MapPath("../../CrystalReportResources/rpt/WarehouseINReport2.rpt"));
            }
            Response.Clear();
            Response.Buffer = true;
            Response.ContentType = "application/pdf";
            Response.AddHeader("Content-Type", "application/pdf");
            Response.AddHeader("Content-disposition", "attachment;filename=Warehouse_InOut_" + System.DateTime.Today.ToString("yyyy-MM-dd") + ".pdf");

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

        returnObj[0] = lstSortBy.Items[lstSortBy.SelectedIndex].Text;
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

       // returnObj[3] = 

        returnObj[4] = lstSortBy.SelectedValue;
        returnObj[5] = lstSortBy.SelectedValue;
        returnObj[6] = lstSortBy.SelectedValue;
        returnObj[7] = lstSortBy.SelectedValue;

        return returnObj;
    }
}