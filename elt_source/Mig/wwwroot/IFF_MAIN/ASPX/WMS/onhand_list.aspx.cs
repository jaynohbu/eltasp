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

public partial class ASPX_WMS_onhand_list : System.Web.UI.Page
{

    protected DataSet ds = null;
    protected DataSet dataTable = null;
    protected string ConnectStr = null;
    private string elt_account_number = null;
    private string nextpage = null;
    private string user_id, login_name, user_right;
    private int maxRows = 20;
    protected ReportSourceManager rsm = null;
    private int total_number1 = 0;
    private int total_number2 = 0;
    private int child_page_no = 0;
    private string sortby = null;
    protected void Page_Load(object sender, EventArgs e)
    {

        Session.LCID = 1033;
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
        ConnectStr = (new igFunctions.DB().getConStr());
        sortby = null;


        if (!IsPostBack)
        {
            LoadParameters();
            initializeForm();
        }
        reload_Page();

    }

    protected void initializeForm()
    {
        Webdatetimeedit1.Text = System.DateTime.Today.ToShortDateString();
    }

    protected void LoadParameters()
    {
        sortway.Visible = false;
        sortway2.Visible = false;
    }
    protected void reload_Page()
    {
        ds = new DataSet();
        dataTable = new DataSet();
        BindGridView();
        PrepReportDS();
    }
    protected void BindGridView()
    {
        object orgAcctObj = Request.Params.Get("orgAcct");

        string sqlText = "select b.dba_name as shipper_name, c.dba_name as customer_name, d.dba_name as received_name,"
            + " a.*,e.item_piece_remain as remain, e.history_date as date from warehouse_receipt a left join organization b "
            + " on (a.elt_account_number=b.elt_account_number and a.shipper_acct = b.org_account_number) "
            + " left join organization c "
            + " on (a.elt_account_number=c.elt_account_number and a.customer_acct = c.org_account_number) "
            + " left join organization d "
            + " on (a.elt_account_number=d.elt_account_number and a.shipper_acct = d.org_account_number) "
            + " left join warehouse_history e "
            + " on (a.wr_num=e.wr_num ) "
            + " where a.elt_account_number=" + elt_account_number + " AND ISNULL(a.job_status,'Pending')='Pending'"
            + " AND a.item_piece_remain>0 and ISNULL(a.wr_num,'')<>'' and e.auto_uid=(select top 1 auto_uid from warehouse_history "
            + " where elt_account_number=" + elt_account_number + " and wr_num=a.wr_num ";
            if (Webdatetimeedit1.Text != "")
            {
                sqlText = sqlText + " AND (history_date -1) <= '" + Webdatetimeedit1.Text + "'";
            }
            else
            {
                sqlText = sqlText + " AND history_date <= '" + DateTime.Today + "'";
            }
            sqlText = sqlText +" order by history_date desc)";

            string sqlText2 = "SELECT distinct c.dba_name as customer_name from warehouse_receipt a left join organization b "
                + " on (a.elt_account_number=b.elt_account_number and a.shipper_acct = b.org_account_number) "
                + " left join organization c "
                + " on (a.elt_account_number=c.elt_account_number and a.customer_acct = c.org_account_number) "
                + " where a.elt_account_number=" + elt_account_number + " AND ISNULL(a.job_status,'Pending')='Pending'";

            sqlText = SQLSetFilter(sqlText);
            sqlText2 = SQLSetFilterWRIn(sqlText2);
            if (sortby == null)
            {
                if (check1.Checked == true)
                {
                    if (sortway2.Text.ToString() == "")
                    {
                    sortby = " customer_name";
                    }
                    else
                    {
                        sortby = sortway2.Text.ToString();
                    }
                }

                else
                {
                    if (sortway2.Text.ToString() == "")
                    {
                        sortby = "a.wr_num";
                    }
                    else
                    {
                        sortby = sortway2.Text.ToString();
                    }
                }
            }

            else
            {
                sortway2.Text = sortby.ToString();
                if (sortby.ToString() == sortway.Text)
                {
                    sortway.Text = "";
                }
                else
                {
                    sortway.Text = sortby.ToString();
                }
            }
                sqlText = sqlText + " order by " + sortby;
           if (sortby.ToString() == sortway.Text)
            {
                sqlText = sqlText + " DESC";
            }
            //clearup
            sortby = null;
          
            MakeDataSet("SOlist", sqlText);
            Session["currentSQL"] = sqlText;
            // label3.Text = Session["currentSQL"].ToString();
            try
            {
                if (check1.Checked == true && nextpage == null)
                {
                    MakeDataSet("CustomerTable", sqlText2);
                    FormatDataTable("CustomerTable");

                }
                if (ds.Tables["SOlist"].Rows.Count == 0)
                {
                    no_item();
                }
                if (!check1.Checked)
                {

                    GridView2.Visible = false;
                    GridView1.Visible = true;
                    if (ds.Tables["SOlist"].Rows.Count == 0)
                    {
                        MakeEmptyGridView(GridView1, "SOlist");
                        //no_item();
                    }
                    else
                    {

                        GridView1.PageSize = maxRows;
                        GridView1.DataSource = ds.Tables["SOlist"].DefaultView;
                        GridView1.DataBind();
                        Get_total2();
                    }
                }
                     else
                    {
                           GridView1.Visible = false;
                            GridView2.Visible = true;

                                  if (ds.Tables["SOlist"].Rows.Count != 0)
                                  {
                                      
                                      if (ds.Tables["CustomerTable"].Rows.Count == 0)
                                      {
                                          MakeEmptyGridView(GridView2, "CustomerTable");
                                          
                                      }
                                      else
                                      {
                                          GridView2.PageSize = maxRows;
                                          GridView2.DataSource = ds.Tables["CustomerTable"].DefaultView;
                                          GridView2.DataBind();
                                          ds.Relations.Clear();
                                          ds.Relations.Add(ds.Tables["CustomerTable"].Columns["customer_name"], ds.Tables["SOlist"].Columns["customer_name"]);
                                          if (GridView2.Rows.Count != 0)
                                          {
                                              for (int rowIndex = 0; rowIndex < GridView2.Rows.Count; rowIndex++)
                                              {
                                                  GridView childgv = (GridView)GridView2.Rows[rowIndex].FindControl("GridView3");
                                                  if (childgv != null)
                                                  {
                                                      DataRow[] subSet = ds.Tables["CustomerTable"].Rows[rowIndex].GetChildRows(ds.Relations[0]);
                                                      if (child_page_no != 0)
                                                      {
                                                          childgv.PageIndex = child_page_no;
                                                      }

                                                      DataTable dt = new DataTable();
                                                      dt = ds.Tables["SOlist"].Clone();

                                                      if (subSet.Length == 0)
                                                      {
                                                          if (rowIndex == 0)
                                                          {
                                                              MakeEmptyGridView2(GridView2);

                                                          }
                                                          else
                                                          {
                                                              GridView2.Rows[rowIndex].Visible = false;
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
                                                          if (GridView2.Rows[0].Cells[0].Text == "No Records Found.")
                                                          {
                                                              GridView2.Rows[0].Visible = false;
                                                          }
                                                      }

                                                  }
                                              }
                                          }

                                      }
                                      ds.Dispose();
                                      Get_total2();
                                  }
                                  
                                  else
                                  {
                                      MakeEmptyGridView(GridView2, "CustomerTable");
                                  }
                              }
            }
            catch
            {
                Response.Write("<script>alert('Date Error. Please Check the Date and Try again'); self.close();</script>");
                //Response.End();
                Response.Write("<script>window.history.back();</script>");
            }
            
    }
    private void PrepReportDS()
    {
        //string StartDate = StartDate.ToString();
        //string EndDate = EndDate.ToString();
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
                aRow["StartDate"] = "Unlimited";
            }
            else
            {
                aRow["StartDate"] = Webdatetimeedit1.Text;// specially used for the new table
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

    protected void Get_total2()
    {
        //int total_number=0;
        total_number1 = 0;
        total_number2 = 0;
        foreach (DataRow eRow in ds.Tables["SOlist"].Rows)
        {
            try
            {
                    total_number1 = total_number1 + int.Parse(eRow["remain"].ToString());
                    total_number2 = total_number2 + int.Parse(eRow["item_piece_origin"].ToString());
            }
            catch
            {
                Response.Write(eRow["item_piece_remain"].ToString());
                Response.Write(eRow["item_piece_origin"].ToString());
                Response.End();
            }
        }
        label1.Text = total_number1.ToString();
        label2.Text = total_number2.ToString();
    }
        
    
    protected string SQLSetFilterWRIn(string sqlText)
    {
        //object orgAcctObj = Request.Params.Get("orgAcct");
        object orgAcctObj = Request.Form.Get("hAccountOfAcct");
        if (orgAcctObj != null && orgAcctObj.ToString().Trim() != "" && orgAcctObj.ToString() != "0")
        {
            sqlText = sqlText + " AND a.customer_acct=" + orgAcctObj.ToString();
        }
        if (lstSearchNum.Text != "")
        {
            sqlText = sqlText + " AND a.wr_num like N'" + lstSearchNum.Text + "%'";
        }
        if (Webdatetimeedit1.Text != "")
        {

            sqlText = sqlText + " AND a.received_date <= '" + Webdatetimeedit1.Text + "'";

        }
        else
        {
            sqlText = sqlText + " AND a.received_date<= '" + DateTime.Today.AddDays(1)+ "'";
        }
        return sqlText;
    }

    protected string SQLSetFilter(string sqlText)
    {
        object orgAcctObj = Request.Form.Get("hAccountOfAcct");
        if (orgAcctObj != null && orgAcctObj.ToString().Trim() != "" && orgAcctObj.ToString() != "0")
        {
            sqlText = sqlText + " AND a.customer_acct=" + orgAcctObj.ToString();
        }


       if (lstSearchNum.Text != "")
       {

           sqlText = sqlText + " AND a.wr_num like N'" + lstSearchNum.Text + "%'";
       }

        if (Webdatetimeedit1.Text != "")
        {

            sqlText = sqlText + " AND a.received_date <= '" + Webdatetimeedit1.Text + "'";

        }
        else
        {
            sqlText = sqlText + " AND a.received_date<= '" + DateTime.Today + "'";
        }

        return sqlText;
    }
    protected void FormatDataTable(string tableName)
    {
        DataColumn newColumn = new DataColumn("row_index", typeof(int));
        ds.Tables[tableName].Columns.Add(newColumn);
        for (int i = 0; i < ds.Tables[tableName].Rows.Count; i++)
        {
            ds.Tables[tableName].Rows[i][newColumn] = i;
        }
    }

    protected void number_Click(object sender, ImageClickEventArgs e)
    {
        sortby = "a.wr_num";
        reload_Page();

    }
    protected void date_Click(object sender, ImageClickEventArgs e)
    {
        sortby = "a.received_date";
        reload_Page();
    }
    protected void customer_Click(object sender, ImageClickEventArgs e)
    {
        sortby = "customer_name";
        reload_Page();
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

    protected void FormatDataSet()
    {
        DataColumn newColumn = new DataColumn("row_index", typeof(int));
        ds.Tables[0].Columns.Add(newColumn);
        for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
        {
            ds.Tables[0].Rows[i][newColumn] = i;
        }
    }
    protected void GridView1_EmptyCheck()
    {
        if (GridView1.Rows[0].Cells[0].Text == "No Records Found.")
        {
            GridView1.Rows[0].Cells[0].ColumnSpan = 1;
            GridView1.Rows[0].Cells[0].Text = "No Records Found.";
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
        //DetailsView1.Visible = false;
    }
    protected void GridView2_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView2.PageIndex = e.NewPageIndex; 
        nextpage = "check";
        BindGridView();
    }
    protected void GridView3_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        child_page_no = e.NewPageIndex;
        //sortby=sortway.Text.ToString();
        nextpage = "check";
        BindGridView();
    }
    protected void no_item()
    {

        label1.Text = "0";
        label2.Text = "0";
    }

   

    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        GridView gv = (GridView)sender;

        string args = e.CommandArgument.ToString();
        char[] splitters = { '-' };
        string[] argList;
        argList = args.Split(splitters);

        switch (e.CommandName)
        {
            case "Detail":
                string keyID = argList[0];
                int rowIndex = int.Parse(argList[1]);
                //BindDetailView(keyID);
                for (int i = 0; i < gv.Rows.Count; i++)
                {
                    if (i % 2 == 0)
                    {
                        gv.Rows[i].BackColor = ColorTranslator.FromHtml("#F3F3F3");
                    }
                    else
                    {
                        gv.Rows[i].BackColor = ColorTranslator.FromHtml("#FFFFFF");
                    }
                }
                gv.Rows[(rowIndex % maxRows)].BackColor = ColorTranslator.FromHtml("#EEFFCC");
                break;
        }
    }


    protected void PDFPrintButton_Click(object sender, EventArgs e)
    {
        MakeDataSet("SOList", Session["currentSQL"].ToString());
        try
        {
            rsm = new ReportSourceManager();
            rsm.LoadDataSet(ds);
            rsm.LoadCompanyInfo(elt_account_number, Server.MapPath("../../ClientLogos/" + elt_account_number + ".jpg"));
            // XSD file is automatically gerated
            rsm.WriteXSD(Server.MapPath("../../CrystalReportResources/xsd/OnhandReport.xsd"));
            // This file needs to be created
            if (check1.Checked == true)
            {
                rsm.BindNow(Server.MapPath("../../CrystalReportResources/rpt/OnhandReport_customer.rpt"));
            }
            else
            {
                rsm.BindNow(Server.MapPath("../../CrystalReportResources/rpt/OnhandReport1.rpt"));
            }
            Response.Clear();
            Response.Buffer = true;
            Response.ContentType = "application/pdf";
            Response.AddHeader("Content-Type", "application/pdf");
            Response.AddHeader("Content-disposition", "attachment;filename=onhand_report.pdf");

            MemoryStream oStream; // using System.IO
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
    protected void ExcelPrintButton_Click(object sender, EventArgs e)
    {
        
        MakeDataSet("SOList", Session["currentSQL"].ToString());
        try
        {
            rsm = new ReportSourceManager();
            rsm.LoadDataSet(ds);
            // XSD file is automatically gerated
            rsm.WriteXSD(Server.MapPath("../../CrystalReportResources/xsd/OnhandReport.xsd"));
            // This file needs to be created
            if (check1.Checked == true)
            {
                rsm.BindNow(Server.MapPath("../../CrystalReportResources/rpt/OnhandReport_customer.rpt"));
            }
            else
            {
                rsm.BindNow(Server.MapPath("../../CrystalReportResources/rpt/OnhandReport1.rpt"));
            }

            Response.Clear();
            Response.Buffer = true;
            Response.ContentType = "application/pdf";
            Response.AddHeader("Content-Type", "application/pdf");
            Response.AddHeader("Content-disposition", "attachment;filename=onhand_report.xls");
            MemoryStream oStream; // using System.IO
            oStream = (MemoryStream)rsm.getReportDocument().ExportToStream(ExportFormatType.Excel);
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
}