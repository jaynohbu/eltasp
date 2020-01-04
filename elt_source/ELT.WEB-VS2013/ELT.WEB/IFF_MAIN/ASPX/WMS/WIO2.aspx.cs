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
public partial class ASPX_WMS_WIO2 : System.Web.UI.Page
{
    protected DataSet ds = null;
    protected DataSet dataTable = null;
    protected string ConnectStr = null;
    private string elt_account_number = null;
    private string nextpage = null;
    private string user_id, login_name, user_right;
    private int maxRows = 50;
    protected ReportSourceManager rsm = null;
    private int total_number1 = 0;
    private int total_number2 = 0;
    private int total_number3 = 0;
    private string isEmptyIn = null;
    private string isEmptyOut = null;
    private string sortby = "";
    private string sortby2 = "";
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
            initializeForm();
            //BindGridView();

        }
        reload_Page();
    }

    protected void reload_Page()
    {
        ds = new DataSet();
        dataTable = new DataSet();
        BindGridView();
        PrepReportDS();
    }

    protected void initializeForm()
    {
        listResultSelect.SelectedIndex = 0;

        Webdatetimeedit1.Text = System.DateTime.Today.ToShortDateString();
        Webdatetimeedit2.Text = System.DateTime.Today.ToShortDateString();
    }

    //Parse("1 1").AddYears(-1)
    protected void LoadParameters()
    {
        GridView1.Visible = true;
        sortway.Visible = false;
        sortway2.Visible = false;
        sortwayB.Visible = false;
        sortway2B.Visible = false;
    }


    protected void btnGo_Click(object sender, ImageClickEventArgs e)
    {
        sortby = "";
        sortby2 = "";
        BindGridView();

    }

    private void PrepReportDS()
    {
        string login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
        ConnectStr = (new igFunctions.DB().getConStr());
        SqlConnection Con = new SqlConnection(ConnectStr);
        SqlCommand Cmd = new SqlCommand();
        Cmd.Connection = Con;
        SqlDataReader reader;

        DataTable dt = new DataTable();
        dt.TableName = "DATEINFO";

        try
        {
            Con.Open();
            Cmd.CommandText = "SELECT user_lname, user_fname FROM users WHERE login_name = N'" + login_name + "' AND elt_account_number =" + elt_account_number;
            reader = Cmd.ExecuteReader();

            DataRow aRow = dt.NewRow();

            DataColumn dc_asof = new DataColumn("StartDate");
            DataColumn dc_asof2 = new DataColumn("EndDate");


            dt.Columns.Add(dc_asof);
            dt.Columns.Add(dc_asof2);
            reader.Close();
            // here we load logo 
            if (Webdatetimeedit1.Text.ToString() == "")
            {
                aRow["StartDate"] = "Unlimited";// specially used for the Date
            }
            else
            {
                aRow["StartDate"] = Webdatetimeedit1.Text;// specially used for Date
            }
            if (Webdatetimeedit2.Text.ToString() == "")
            {
                aRow["EndDate"] = "Unlimited";// specially used for the Date
            }
            else
            {
                aRow["EndDate"] = Webdatetimeedit2.Text;
            }
            dt.Rows.Add(aRow);

        }
        catch (Exception ex)
        {
            Response.Write(ex.ToString());
            Response.End();
        }
        finally
        {
            Con.Close();
        }

        if (ds != null && dt != null && !ds.Tables.Contains(dt.TableName))
        {
            ds.Tables.Add(dt);
        }
    }

    protected void BindGridView()
    {
        string sqlText = "select g.dba_name as shipper_name, c.dba_name as customer_name, a.customer_acct as customer_no, e.auto_uid  as so_uid ,g.dba_name as shipout_name, d.history_type as history_type, "
                + " a.*,d.so_num as so_no,(e.shipout_date - 1 ) as shipout_date ,d.item_piece_shipout as item_shipout,d.item_piece_remain as item_remain,e.consignee_acct as shipout_acct "
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
                + " and ISNULL(d.so_num, '') <>''  and a.customer_acct >'0' and isNUll(a.customer_acct,'0') <> '0'";

        string sqlText3 = "select b.dba_name as shipper_name, c.dba_name as customer_name, a.customer_acct as customer_no, e.auto_uid  as so_uid, d.history_type as history_type,"
                + " a.*,d.so_num as so_no,(e.shipout_date-1) as shipout_date ,d.item_piece_shipout as item_shipout,d.item_piece_remain as item_remain"
                + " ,(d.item_piece_remain + d.item_piece_shipout) as remain_QTY , e.PO_NO as PONO, e.customer_ref_no as customer_ref from warehouse_receipt a left join organization b "
                + " on (a.elt_account_number=b.elt_account_number and a.shipper_acct = b.org_account_number) "
                + " left join organization c "
                + " on (a.elt_account_number=c.elt_account_number and a.customer_acct = c.org_account_number) "
                + " left join warehouse_history d "
                + " on (a.elt_account_number=c.elt_account_number and a.wr_num = d.wr_num) "
                + " left join warehouse_shipout e "
                + " on (a.elt_account_number=c.elt_account_number and d.so_num = e.so_num) "
                + " where a.elt_account_number=" + elt_account_number + " AND ISNULL(a.job_status,'Pending')='Pending'";

        string sqlText2 = "select b.dba_name as shipper_name, c.dba_name as customer_name, b.dba_name as received_name,"
            + " a.* from warehouse_receipt a left join organization b "
            + " on (a.elt_account_number=b.elt_account_number and a.shipper_acct = b.org_account_number) "
            + " left join organization c "
            + " on (a.elt_account_number=c.elt_account_number and a.customer_acct = c.org_account_number) ";


        if (lstShipOut.Text != "" || txtCustomerRef2.Text != "" || txtPO2.Text != "")
        {
            sqlText2 = sqlText2 + " left join warehouse_history d "
                + " on (a.elt_account_number=c.elt_account_number and a.wr_num = d.wr_num) "
                + " left join warehouse_shipout e "
                + " on (a.elt_account_number=c.elt_account_number and d.so_num = e.so_num) ";
        }

        sqlText2 = sqlText2 + " where a.elt_account_number=" + elt_account_number + " AND ISNULL(a.job_status,'Pending')='Pending'"
            + " AND a.item_piece_remain>=0 and a.item_piece_origin > 0";

        string sqlText4 = "SELECT distinct c.dba_name as customer_name,a.customer_acct as customer_no from warehouse_receipt a left join organization b "
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
                + " and ISNULL(d.so_num, '') <>''  and a.customer_acct >'0' and isNUll(a.customer_acct,'0') <> '0'";

        string sqlText5 = "SELECT distinct c.dba_name as customer_name,a.customer_acct as customer_no from warehouse_receipt a left join organization b "
                + " on (a.elt_account_number=b.elt_account_number and a.shipper_acct = b.org_account_number) "
                + " left join organization c "
                + " on (a.elt_account_number=c.elt_account_number and a.customer_acct = c.org_account_number) ";
        if (lstShipOut.Text != "" || txtCustomerRef2.Text != "" || txtPO2.Text != "")
        {
            sqlText5 = sqlText5 + " left join warehouse_history d "
                + " on (a.elt_account_number=c.elt_account_number and a.wr_num = d.wr_num) "
                + " left join warehouse_shipout e "
                + " on (a.elt_account_number=c.elt_account_number and d.so_num = e.so_num) ";
        }

        sqlText5 = sqlText5 + " where a.elt_account_number=" + elt_account_number + " AND ISNULL(a.job_status,'Pending')='Pending'";

        sqlText = SQLSetFilter(sqlText); // out
        sqlText2 = SQLSetFilterWRIn(sqlText2); // in
        //sqlText3 = SQLSetFilterWRIn(sqlText3); // in out
        //sqlText4 = SQLSetFilterWRIn(sqlText4); //in customer Sort
        //sqlText5 = SQLSetFilterWRIn(sqlText5);//out customer Sort
        try
        {
            if (check1.Checked == true)
            {

                if (sortby == "")
                {
                    if (sortwayB.Text.ToString() == "")
                    {
                        sortby = "customer_name";
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
                        sortby2 = "customer_name";
                    }
                    else
                    {
                        sortby2 = sortway2B.Text.ToString();
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


                sqlText = sqlText + " order by " + sortby2;
                sqlText2 = sqlText2 + " order by " + sortby;
                sqlText3 = sqlText3 + " order by customer_name,d.wr_num";
                sqlText4 = sqlText4 + " order by customer_name";
                sqlText5 = sqlText5 + " order by customer_name";

                if (sortby.ToString() == sortway.Text)
                {
                    sqlText2 = sqlText2 + " DESC";
                }
                if (sortby2.ToString() == sortway2.Text)
                {
                    sqlText = sqlText + " DESC";
                }
                //clearup
                sortby = "";
                sortby2 = "";
            }
            else
            {
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
                        sortby2 = "d.so_num";
                    }
                    else
                    {
                        sortby2 = sortway2B.Text.ToString();
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

                sqlText = sqlText + " order by " + sortby2;
                sqlText2 = sqlText2 + " order by " + sortby;
                sqlText3 = sqlText3 + " order by d.so_num,d.wr_num";
                sqlText4 = sqlText4 + " order by customer_name";
                sqlText5 = sqlText5 + " order by customer_name";
                if (sortby.ToString() == sortway.Text)
                {
                    sqlText2 = sqlText2 + " DESC";
                }
                if (sortby2.ToString() == sortway2.Text)
                {
                    sqlText = sqlText + " DESC";
                }
                sortby = "";
                sortby2 = "";
            }

            Session["WrOutSQL"] = sqlText;
            Session["WrInSQL"] = sqlText2;
            Session["WrInOutSQL"] = sqlText3;
            Session["CustomerSQL"] = sqlText4;
            Session["CustomerSQL2"] = sqlText5;

            MakeDataSet("WrOutTable", sqlText);
            MakeDataSet("WrInTable", sqlText2);
            MakeDataSet("WrInOutTable", sqlText3);

            if (check1.Checked == true && nextpage == null)
            {
                MakeDataSet("CustomerTable", sqlText4);
                FormatDataTable("CustomerTable");
                MakeDataSet("CustomerTable2", sqlText5);
                FormatDataTable("CustomerTable2");
            }
            //try
            //{
            if (ds.Tables["WrOutTable"].Rows.Count == 0)
            {
                MakeEmptyGridView(GridView1, "WrOutTable");
                isEmptyOut = "yes";
            }
            else
            {
                isEmptyIn = null;
                if (!check1.Checked)
                {
                    GridView1.PageSize = maxRows;
                    GridView1.DataSource = ds.Tables["WrOutTable"].DefaultView;
                    GridView1.DataBind();
                }
            }

            if (ds.Tables["WrInTable"].Rows.Count == 0)
            {
                MakeEmptyGridView(GridView2, "WrInTable");
                isEmptyIn = "yes";
            }
            else
            {
                isEmptyIn = null;
                if (!check1.Checked)
                {
                    GridView2.PageSize = maxRows;
                    GridView2.DataSource = ds.Tables["WrInTable"].DefaultView;
                    GridView2.DataBind();
                }
            }
            if (!check1.Checked)
            {
                GridView3.Visible = false;
                //GridView4.Visible = false;
                GridView5.Visible = false;
                //GridView6.Visible = false;
            }
            else
            {
                GridView1.Visible = false;
                GridView2.Visible = false;
                GridView5.Visible = true;
                GridView3.Visible = true;
            }

            if (check1.Checked == true)
            {
                GridView2.Visible = false;
                GridView1.Visible = false;

                if (ds.Tables["CustomerTable"].Rows.Count == 0)
                {
                    MakeEmptyGridView(GridView3, "CustomerTable");
                }


                if (ds.Tables["CustomerTable2"].Rows.Count == 0)
                {
                    MakeEmptyGridView(GridView5, "CustomerTable2");
                }
                GridView3.PageSize = maxRows;
                GridView3.DataSource = ds.Tables["CustomerTable"].DefaultView;
                GridView3.DataBind();
                GridView5.PageSize = maxRows;
                GridView5.DataSource = ds.Tables["CustomerTable2"].DefaultView;
                GridView5.DataBind();
                ds.Relations.Clear();
                if (ds.Tables["CustomerTable2"].Rows.Count != 0)
                {
                    ds.Relations.Add(ds.Tables["CustomerTable2"].Columns["customer_name"], ds.Tables["WrInTable"].Columns["customer_name"]);
                    for (int rowIndex = 0; rowIndex < GridView5.Rows.Count; rowIndex++)
                    {
                        GridView childgv = (GridView)GridView5.Rows[rowIndex].FindControl("GridView6");
                        if (childgv != null)
                        {
                            DataRow[] subSet = ds.Tables["CustomerTable2"].Rows[rowIndex].GetChildRows(ds.Relations[0]);
                            if (Child_page_IN != 0)
                            {
                                childgv.PageIndex = Child_page_IN;
                            }
                            DataTable dt = new DataTable();
                            dt = ds.Tables["WrInTable"].Clone();

                            if (subSet.Length == 0)
                            {
                                if (rowIndex == 0)
                                {

                                    MakeEmptyGridView2(GridView5);
                                }
                                else
                                {
                                    GridView5.Rows[rowIndex].Visible = false;
                                }

                            }
                            else
                            {
                                for (int i = 0; i < subSet.Length; i++)
                                {
                                    dt.Rows.Add(subSet[i].ItemArray);
                                }

                                childgv.DataSource = dt;
                                childgv.DataBind();
                                if (GridView5.Rows[0].Cells[0].Text == "No Records Found.")
                                {
                                    GridView5.Rows[0].Visible = false;
                                }
                            }

                        }
                    }
                }
                if (ds.Tables["CustomerTable"].Rows.Count != 0)
                {
                    ds.Relations.Add(ds.Tables["CustomerTable"].Columns["customer_name"], ds.Tables["WrOutTable"].Columns["customer_name"]);
                    for (int rowIndex = 0; rowIndex < GridView3.Rows.Count; rowIndex++)
                    {
                        GridView childgv = (GridView)GridView3.Rows[rowIndex].FindControl("GridView4");
                        if (childgv != null)
                        {
                            DataRow[] subSet = ds.Tables["CustomerTable"].Rows[rowIndex].GetChildRows(ds.Relations[1]);
                            if (Child_page_OUT != 0)
                            {
                                childgv.PageIndex = Child_page_OUT;
                            }
                            DataTable dt = new DataTable();
                            dt = ds.Tables["WrOutTable"].Clone();

                            if (subSet.Length == 0)
                            {
                                if (rowIndex == 0)
                                {
                                    MakeEmptyGridView2(GridView3);

                                }
                                else
                                {
                                    GridView3.Rows[rowIndex].Visible = false;
                                }

                            }
                            else
                            {
                                for (int i = 0; i < subSet.Length; i++)
                                {
                                    dt.Rows.Add(subSet[i].ItemArray);
                                }

                                childgv.DataSource = dt;
                                childgv.DataBind();
                                if (GridView3.Rows[0].Cells[0].Text == "No Records Found.")
                                {
                                    GridView3.Rows[0].Visible = false;
                                }
                            }

                        }
                    }
                }

                if (listResultSelect.SelectedValue == "WROUT")
                {
                    GridView3.Visible = true;
                    GridView5.Visible = false;
                }
                else if (listResultSelect.SelectedValue == "WRIN")
                {
                    GridView3.Visible = false;
                    GridView5.Visible = true;
                }
                else
                {
                    GridView3.Visible = true;
                    GridView5.Visible = true;
                }
            }
            else
            {
                if (listResultSelect.SelectedValue == "WROUT")
                {
                    GridView1.Visible = true;
                    GridView2.Visible = false;
                    GridView3.Visible = false;
                    GridView5.Visible = false;
                }
                else if (listResultSelect.SelectedValue == "WRIN")
                {
                    GridView1.Visible = false;
                    GridView2.Visible = true;
                    GridView3.Visible = false;
                    GridView5.Visible = false;
                }
                else
                {
                    GridView1.Visible = true;
                    GridView2.Visible = true;
                    GridView3.Visible = false;
                    GridView5.Visible = false;
                }
                ds.Dispose();
            }
            Get_total();

        }
        catch
        {

            Response.Write("<script>alert('Date Error. Please Check the Date and Try again'); self.close();</script>");
            Response.Write("<script>window.history.back();</script>");
        }
    }

    protected void FormatDataTable(string tableName)
    {
        DataColumn newColumn = new DataColumn("row_index", typeof(int));

        try
        {
            ds.Tables[tableName].Columns.Add(newColumn);

            for (int i = 0; i < ds.Tables[tableName].Rows.Count; i++)
            {
                ds.Tables[tableName].Rows[i][newColumn] = i;

            }
        }
        catch
        {
            Response.Write("<script>alert('Date Error. Please Check the Date and Try again'); self.close();</script>");
            Response.Write("<script>window.history.back();</script>");
        }

    }


    protected string SQLSetFilter(string sqlText)
    {

        //object orgAcctObj = Request.Params.Get("orgAcct");
        object orgAcctObj = Request.Form.Get("hAccountOfAcct");
        //Search part 1 change by stanley on 11/14/2007
        if (lstSearchNum.Text == "" && txtPO.Text == "" && txtCustomerRef.Text == "")
        {
            if (lstShipOut.Text == "" && txtPO2.Text == "" && txtCustomerRef2.Text == "")
            {
                if (orgAcctObj != null && orgAcctObj.ToString().Trim() != "" && orgAcctObj.ToString() != "0")
                {
                    sqlText = sqlText + " AND a.customer_acct=" + orgAcctObj.ToString();
                }

                if (Webdatetimeedit1.Text != "")
                {
                    sqlText = sqlText + " AND  shipout_date  >= '" + Webdatetimeedit1.Text + "'";
                }
                if (Webdatetimeedit2.Text != "")
                {
                    sqlText = sqlText + " AND shipout_date - 1<= '" + Webdatetimeedit2.Text + "'";
                }
            }
        }
        //Search part 2 change by stanley on 11/14/2007
        if (lstSearchNum.Text != "")
        {
            sqlText = sqlText + " AND a.wr_num like N'" + lstSearchNum.Text + "%'";
        }
        if (lstShipOut.Text != "")
        {
            sqlText = sqlText + " AND d.so_num like N'" + lstShipOut.Text + "%'";
        }
        if (txtPO2.Text != "")
        {
            sqlText = sqlText + " AND e.Po_No like N'" + txtPO2.Text + "%'";
        }
        if (txtCustomerRef2.Text != "")
        {
            sqlText = sqlText + " AND e.customer_ref_no like N'" + txtCustomerRef2.Text + "%'";
        }
        if (txtCustomerRef.Text != "")
        {
            sqlText = sqlText + " AND a.customer_ref_no like N'" + txtCustomerRef.Text + "%'";
        }


        if (txtPO.Text != "")
        {
            sqlText = sqlText + " AND a.PO_NO like N'" + txtPO.Text + "%'";
        }
        return sqlText;
    }

    protected string SQLSetFilterWRIn(string sqlText)
    {

        object orgAcctObj = Request.Form.Get("hAccountOfAcct");
        //Search part 1 change by stanley on 11/14/2007
        if (lstSearchNum.Text == "" && txtPO.Text == "" && txtCustomerRef.Text == "")
        {
            if (lstShipOut.Text == "" && txtPO2.Text == "" && txtCustomerRef2.Text == "")
            {

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
            sqlText = sqlText + " AND d.so_num like N'" + lstShipOut.Text + "%'";
        }

        if (txtPO2.Text != "")
        {
            sqlText = sqlText + " AND e.Po_No like N'" + txtPO2.Text + "%'";

        }


        return sqlText;
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


    protected void Get_total()
    {
        total_number1 = 0;
        total_number2 = 0;
        total_number3 = 0;
        if (isEmptyIn == null)
        {
            foreach (DataRow eRow in ds.Tables["WrInTable"].Rows)
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
        }
        if (isEmptyOut == null)
        {
            foreach (DataRow aRow in ds.Tables["WrOutTable"].Rows)
            {
                try
                {
                    total_number2 = total_number2 + int.Parse(aRow["item_shipout"].ToString());
                    total_number3 = total_number3 + int.Parse(aRow["item_shipout"].ToString());

                }
                catch
                {
                    Response.Write(aRow["item_shipout"].ToString());
                    Response.End();

                }
            }
        }
        if (listResultSelect.SelectedIndex == 1)
        {
            label1.Text = total_number1.ToString();
            label2.Text = "";
            label3.Text = "";
            label5.Text = "";
            label4.Text = "TOTAL";
        }
        else if (listResultSelect.SelectedIndex == 2)
        {
            label2.Text = total_number2.ToString();
            label5.Text = "";
            label1.Text = "";
            label3.Text = "TOTAL";
            label4.Text = "";

        }
        else
        {
            label1.Text = total_number1.ToString();
            label2.Text = total_number2.ToString();
            label5.Text = "";
            label3.Text = "TOTAL";
            label4.Text = "TOTAL";
        }
    }


    protected void period_change_back(object sender, EventArgs e)
    {

    }



    protected void WR_Click(object sender, ImageClickEventArgs e)
    {
        sortby = "a.wr_num";
        sortby2 = "";
        reload_Page();

    }
    protected void Date_Click(object sender, ImageClickEventArgs e)
    {
        sortby = "a.received_date";
        sortby2 = "";
        reload_Page();
    }
    protected void WR2_Click(object sender, ImageClickEventArgs e)
    {
        sortby2 = "a.wr_num";
        sortby = "";
        reload_Page();

    }
    protected void SODate_Click(object sender, ImageClickEventArgs e)
    {
        sortby2 = "e.shipout_date";
        sortby = "";
        reload_Page();
    }
    protected void SO_Click(object sender, ImageClickEventArgs e)
    {
        sortby2 = "d.so_num";
        sortby = "";
        reload_Page();
    }
    protected void customer_Click(object sender, ImageClickEventArgs e)
    {
        sortby = "customer_name";
        sortby2 = "";
        reload_Page();
    }
    protected void SOcustomer_Click(object sender, ImageClickEventArgs e)
    {
        sortby2 = "customer_name";
        sortby = "";
        reload_Page();
    }
    protected void EmptyCheck()
    {
        try
        {
            if (GridView1.Rows[0].Cells[0].Text == "No Records Found.")
            {
                GridView1.Rows[0].Cells[0].ColumnSpan = 1;
                GridView1.Rows[0].Cells[0].Text = "No Records Found.";
            }

            if (GridView2.Rows[0].Cells[0].Text == "No Records Found.")
            {
                GridView2.Rows[0].Cells[0].ColumnSpan = 1;
                GridView2.Rows[0].Cells[0].Text = "No Records Found.";
            }
        }
        catch { }
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
    protected void MakeEmptyGridView2(GridView gridie)
    {
        int columnCount = gridie.Rows[0].Cells.Count;
        gridie.Rows[0].Cells.Clear();
        gridie.Rows[0].Cells.Add(new TableCell());
        gridie.Rows[0].Cells[0].ColumnSpan = columnCount;
        gridie.Rows[0].Cells[0].Text = "No Records Found.";
        gridie.Rows[0].Cells[0].HorizontalAlign = HorizontalAlign.Center;
    }

    protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView1.PageIndex = e.NewPageIndex;
        BindGridView();
    }

    protected void GridView2_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView2.PageIndex = e.NewPageIndex;
        BindGridView();
    }
    protected void GridView3_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView3.PageIndex = e.NewPageIndex;
        nextpage = "check";
        BindGridView();
    }
    protected void GridView5_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView5.PageIndex = e.NewPageIndex;
        nextpage = "check";
        BindGridView();
    }
    protected void GridView4_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {

        //DataSet dsData = (DataSet)Session["CustomerSQL"];
        //DataTable dtData = dsData.Tables[0];
        //GridView3.DataSource = SortDataTable(dtData, true);
        //GridView3.PageIndex = e.NewPageIndex;
        //GridView3.DataBind();
        //int rowIndex;
        //rowIndex = 4;
        //GridView childgv = (GridView)GridView3.Rows[rowIndex].FindControl("GridView4");
        //GridView3.PageIndex = e.NewPageIndex;
        //childgv.PageIndex 
        Child_page_OUT = e.NewPageIndex;
        nextpage = "check";
        BindGridView();
    }
    protected void GridView6_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        Child_page_IN = e.NewPageIndex;
        nextpage = "check";
        BindGridView();
    }

    protected void PDFPrintButton_Click(object sender, EventArgs e)
    {

        MakeDataSet("WrOutTable", Session["WrOutSQL"].ToString());
        MakeDataSet("WrInTable", Session["WrInSQL"].ToString());
        MakeDataSet("WrInOutTable", Session["WrInOutSQL"].ToString());

        try
        {
            rsm = new ReportSourceManager();
            rsm.LoadDataSet(ds);
            rsm.LoadCompanyInfo(elt_account_number, Server.MapPath("../../ClientLogos/" + elt_account_number + ".jpg"));
            rsm.WriteXSD(Server.MapPath("../../CrystalReportResources/xsd/WRInOut.xsd"));


            if (check1.Checked == true)
            {
                if (listResultSelect.SelectedIndex == 1)
                {
                    rsm.BindNow(Server.MapPath("../../CrystalReportResources/rpt/WarehouseINReport_customer.rpt"));
                }
                else if (listResultSelect.SelectedIndex == 2)
                {
                    rsm.BindNow(Server.MapPath("../../CrystalReportResources/rpt/WarehouseOUTReport_customer.rpt"));
                }
                else
                {
                    rsm.BindNow(Server.MapPath("../../CrystalReportResources/rpt/WRInOut_customer.rpt"));
                }
            }
            else
            {
                if (listResultSelect.SelectedIndex == 1)
                {
                    rsm.BindNow(Server.MapPath("../../CrystalReportResources/rpt/WarehouseINReport.rpt"));
                }
                else if (listResultSelect.SelectedIndex == 2)
                {
                    rsm.BindNow(Server.MapPath("../../CrystalReportResources/rpt/WarehouseOUTReport.rpt"));
                }
                else
                {
                    rsm.BindNow(Server.MapPath("../../CrystalReportResources/rpt/WRInOut.rpt"));
                }
            }


            Response.Clear();
            Response.Buffer = true;
            Response.ContentType = "application/pdf";
            Response.AddHeader("Content-Type", "application/pdf");
            Response.AddHeader("Content-disposition", "attachment;filename=In_and_Out.pdf");
            //MemoryStream oStream; // using System.IO
            //oStream = (MemoryStream)rsm.getReportDocument().ExportToStream(ExportFormatType.PortableDocFormat);
            //Response.BinaryWrite(oStream.ToArray());

            var rpt = rsm.getReportDocument();
            System.IO.Stream oStream = null;
            byte[] byteArray = null;
            oStream = rpt.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
            byteArray = new byte[oStream.Length];
            oStream.Read(byteArray, 0, Convert.ToInt32(oStream.Length - 1));
            Response.ClearContent();
            Response.ClearHeaders();
            Response.ContentType = "application/pdf";
            Response.BinaryWrite(byteArray);
            Response.Flush();
            Response.Close();
            Response.End();

            rpt.Close();
            rpt.Dispose();

        }
        catch { }
        finally
        {
            rsm.CloseReportDocumnet();
            Response.Flush();
            Response.End();
        }
    }

    protected void ExcelPrintButton_Click(object sender, EventArgs e)
    {
        MakeDataSet("WrOutTable", Session["WrOutSQL"].ToString());
        MakeDataSet("WrInTable", Session["WrInSQL"].ToString());
        MakeDataSet("WrInOutTable", Session["WrInOutSQL"].ToString());

        try
        {
            rsm = new ReportSourceManager();
            rsm.LoadDataSet(ds);
            rsm.LoadCompanyInfo(elt_account_number, Server.MapPath("../../../ClientLogos/" + elt_account_number + ".jpg"));
            rsm.WriteXSD(Server.MapPath("../../CrystalReportResources/xsd/WrInOut.xsd"));
            if (check1.Checked == true)
            {
                if (listResultSelect.SelectedIndex == 1)
                {
                    rsm.BindNow(Server.MapPath("../../CrystalReportResources/rpt/WarehouseINReport_customer.rpt"));
                }
                else if (listResultSelect.SelectedIndex == 2)
                {
                    rsm.BindNow(Server.MapPath("../../CrystalReportResources/rpt/WarehouseOUTReport_customer.rpt"));
                }
                else
                {
                    rsm.BindNow(Server.MapPath("../../CrystalReportResources/rpt/WRInOut_customer.rpt"));
                }
            }
            else
            {
                if (listResultSelect.SelectedIndex == 1)
                {
                    rsm.BindNow(Server.MapPath("../../CrystalReportResources/rpt/WarehouseINReport.rpt"));
                }
                else if (listResultSelect.SelectedIndex == 2)
                {
                    rsm.BindNow(Server.MapPath("../../CrystalReportResources/rpt/WarehouseOUTReport.rpt"));
                }
                else
                {
                    rsm.BindNow(Server.MapPath("../../CrystalReportResources/rpt/WRInOut.rpt"));
                }
            }
            Response.Clear();
            Response.Buffer = true;
            Response.ContentType = "application/pdf";
            Response.AddHeader("Content-Type", "application/pdf");
            Response.AddHeader("Content-disposition", "attachment;filename=In_and_Out.xls");

            //MemoryStream oStream; // using System.IO
            //oStream = (MemoryStream)rsm.getReportDocument().ExportToStream(ExportFormatType.Excel);
            //Response.BinaryWrite(oStream.ToArray());

            var rpt = rsm.getReportDocument();
            System.IO.Stream oStream = null;
            byte[] byteArray = null;
            oStream = rpt.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
            byteArray = new byte[oStream.Length];
            oStream.Read(byteArray, 0, Convert.ToInt32(oStream.Length - 1));
            Response.ClearContent();
            Response.ClearHeaders();
            Response.ContentType = "application/pdf";
            Response.BinaryWrite(byteArray);
            Response.Flush();
            Response.Close();
            Response.End();

            rpt.Close();
            rpt.Dispose();

        }
        catch { }
        finally
        {
            rsm.CloseReportDocumnet();
            Response.Flush();
            Response.End();
        }
    }
}