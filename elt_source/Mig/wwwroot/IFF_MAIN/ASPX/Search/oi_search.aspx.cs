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

public partial class ASPX_SEARCH_OI_SEARCH : System.Web.UI.Page
{
    protected DataSet ds = null;
    protected string ConnectStr = null;
    private string elt_account_number = null;
    private string user_id, login_name, user_right;
    private string sortby = null;
    private string sortby2 = null;
    private string changeview = "N";
    private int maxRows = 100;
    protected ReportSourceManager rsm = null;
    private double weight = 0;
    private int month = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        Session.LCID = 1033;
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
        ConnectStr = (new igFunctions.DB().getConStr());
        ds = new DataSet();

        lblRecordCount.Text = "";
        if (!IsPostBack)
        {
            InitializeForm();
            LoadParameters();
        }
    }

    protected void LoadParameters()
    {
        changeview = "Y";
        reload_Page();
    }

    protected void InitializeForm()
    {
        sortway.Visible = false;
        sortway2.Visible = false;
        InitializeForm2();
        LoadPorts();
        //LoadMasterNUM();
        //LoadBookingNUM();
    }

    protected void InitializeForm2()
    {
        Webdatetimeedit1.Text = System.DateTime.Today.ToString("MM/dd/yyyy");
        Webdatetimeedit2.Text = System.DateTime.Today.ToString("MM/dd/yyyy");
        PeriodDropDownList.SelectedIndex = 10;
    }

    protected void PerSQLSearch()
    {
        //ds = new DataSet();
        string HouseSQL = "";
        string MasterSQL = "";
        HouseSQL = "select a.HAWB_NUM as hawb_num, b.MAWB_NUM as masterNo ,b.file_no as file#,b.sec,a.CreatedDate as tran_date,"
             + " a.Shipper_name as Shipper_name,a.shipper_acct as shipper_acct,a.consignee_name as consignee_name ,a.dep_port as p1, a.arr_port as p2, "
             + " a.iType,a.agent_org_acct as acct, a.consignee_acct as consignee_acct from import_hawb a  left join import_mawb b"
             + " on (a.elt_account_number=b.elt_account_number and a.mawb_num=b.mawb_num and a.agent_org_acct=b.agent_org_acct) "
             + " where a.elt_account_number=" + elt_account_number + " and a.iType ='O' and b.iType='O' and a.sec=b.sec and len(a.HAWB_NUM)>0";

        MasterSQL = "select a.file_no as file#,a.iType,a.agent_org_acct as acct,a.MAWB_NUM as masterNo,a.sec,a.CreatedDate as tran_date, "
            + " a.dep_port as p1,a.arr_port as p2,b.hawb_num as hawb_num,b.Shipper_name as Shipper_name, b.Shipper_acct as Shipper_acct, b.consignee_name as consignee_name, b.consignee_acct as consignee_acct "
            + "from import_mawb a left outer join import_hawb b on  a.elt_account_number=b.elt_account_number and a.mawb_num=b.mawb_num where a.elt_account_number=" + elt_account_number + " and a.iType ='O'";

        if (sortby == null)
        {
            if (sortway2.Text == "")
            {
                sortby = "a.hawb_num";
                sortby2 = "a.mawb_num";
            }
            else
            {
                sortby2 = sortway2.Text.ToString();
                sortby = sortway2.Text.ToString();
            }
        }
        else
        {
            sortway2.Text = sortby.ToString();
            sortby2 = sortby;
            if (sortby.ToString() == sortway.Text)
            {
                sortway.Text = "";
            }
            else
            {
                sortway.Text = sortby.ToString();
            }
        }
        if (lstSearchType.SelectedIndex == 0)
        {
            HouseSQL = HouseFilter(HouseSQL) + " ORDER BY " + sortby;
            if (sortby.ToString() == sortway.Text)
            {
                HouseSQL = HouseSQL + " DESC";
            }
            Session["HOUSEList"] = HouseSQL;
        }
        else
        {
            MasterSQL = MasterFilter(MasterSQL) + " ORDER BY " + sortby2;
            if (sortby.ToString() == sortway.Text)
            {
                MasterSQL = MasterSQL + " DESC";
            }
            Session["MasterList"] = MasterSQL;
        }
        try
        {
            MakeDataSet("HouseTable", HouseSQL);
            MakeDataSet("MasterTable", MasterSQL);
        }
        catch { }
    }

    protected void BindGridView()
    {
        try
        {
            if (lstSearchType.SelectedIndex == 0)
            {

                showHouseitem();
                GridViewHouse.Visible = true;
                GridViewMaster.Visible = false;
                if (ds.Tables["HouseTable"].Rows.Count == 0)
                {
                    MakeEmptyGridView(GridViewHouse, "HouseTable");
                }
                else
                {
                    GridViewHouse.PageSize = maxRows;
                    GridViewHouse.DataSource = ds.Tables["HouseTable"].DefaultView;
                    GridViewHouse.DataBind();

                    lblRecordCount.Text = ds.Tables["HouseTable"].Rows.Count + " records found.&nbsp;&nbsp;&nbsp;Page "
                        + (GridViewHouse.PageIndex + 1) + " / " + GridViewHouse.PageCount;
                }
            }
            else if (lstSearchType.SelectedIndex == 1)
            {
                hiddenHouseitem();
                GridViewHouse.Visible = false;
                GridViewMaster.Visible = true;
                if (ds.Tables["MasterTable"].Rows.Count == 0)
                {
                    MakeEmptyGridView(GridViewMaster, "MasterTable");
                }

                else
                {
                    GridViewMaster.PageSize = maxRows;
                    GridViewMaster.DataSource = ds.Tables["MasterTable"].DefaultView;
                    GridViewMaster.DataBind();

                    lblRecordCount.Text = ds.Tables["HouseTable"].Rows.Count + " records found.&nbsp;&nbsp;&nbsp;Page "
                        + (GridViewMaster.PageIndex + 1) + " / " + GridViewMaster.PageCount;
                }
            }
            ds.Dispose();
        }
        catch
        {
            Response.Write("<script>alert('Date Error. Please Check the Date and Try again'); self.close();</script>");
            Response.Write("<script>window.history.back();</script>");
        }

    }

    protected void refresh_Click(object sender, ImageClickEventArgs e)
    {
        changeAndRefresh();
    }

    protected void Page_change(object sender, EventArgs e)
    {
        sortway2.Text = "";
        changeAndRefresh();
    }

    protected void showHouseitem()
    {

        Txt1stHouse.Visible = true;
        LCNO.Visible = true;
        CINO.Visible = true;
        OTH_REF_NO.Visible = true;
        label0.Text = "House B/L No.";
        label1.Text = "LC No.";
        label2.Text = "C.I.No.";
        label3.Text = "Other Reference No.";
    }

    protected void hiddenHouseitem()
    {
        Txt1stHouse.Visible = false;
        LCNO.Visible = false;
        CINO.Visible = false;
        OTH_REF_NO.Visible = false;
        label0.Text = "";
        label1.Text = "";
        label2.Text = "";
        label3.Text = "";
    }

    protected void changeAndRefresh()
    {
        refresh();
        InitializeForm2();
        LoadParameters();
    }

    protected void refresh()
    {
        sortway.Text = "";
        VesselName.Text = "";
        TxtWeight.Text = "";
        lstSearchNum.Text = "";
        OriginPortSelect.SelectedIndex = 0;
        DestPortSelect.SelectedIndex = 0;
        hConsigneeAcct.Value = "";
        lstConsigneeName.Text = "";
        NoPiece.Text = "";
        txtFileNo.Text = "";
        lstShipperName.Text = "";
        hShipperAcct.Value = "";
        CINO.Text = "";
        LCNO.Text = "";
        OTH_REF_NO.Text = "";
        Txt1stHouse.Text="";
    }

    protected void period_change_back(object sender, EventArgs e)
    {
        PeriodDropDownList.SelectedIndex = 0;
    }

    protected string MasterFilter(string sqlTxt)
    {
        // period filter
        if (Webdatetimeedit1.Text.Trim() != "")
        {
            sqlTxt += " AND a.CreatedDate>=CAST('" + Webdatetimeedit1.Text + "' AS DATETIME)";
        }

        if (Webdatetimeedit2.Text.Trim() != "")
        {
            sqlTxt += " AND a.CreatedDate<=CAST('" + Webdatetimeedit2.Text + "' AS DATETIME)";
        }
        // Ports filter
        if (OriginPortSelect.SelectedIndex > 0)
        {
            sqlTxt += " AND a.dep_code=N'" + OriginPortSelect.SelectedValue.ToString() + "'";
        }
        if (DestPortSelect.SelectedIndex > 0)
        {
            sqlTxt += " AND a.arr_code=N'" + DestPortSelect.SelectedValue.ToString() + "'";
        }
        // shipper filter
        if (hShipperAcct.Value != "" && hShipperAcct.Value != "0")
        {
            sqlTxt += " AND b.shipper_acct=" + hShipperAcct.Value.ToString();
        }
        // Consignee filter
        if (hConsigneeAcct.Value != "" && hConsigneeAcct.Value != "0")
        {
            sqlTxt += " AND b.consignee_acct=" + hConsigneeAcct.Value.ToString();
        }
        // Pieces filter
        if (NoPiece.Text != "")
        {
            sqlTxt += " AND a.Pieces =" + NoPiece.Text;
        }
        // file filter
        if (txtFileNo.Text != "")
        {
            sqlTxt += " AND a.file_no like N'%" + txtFileNo.Text + "%'";
        }
        if (lstSearchNum.Text != "")
        {
            sqlTxt += " AND a.MAWB_NUM like N'" + lstSearchNum.Text + "%'";
        }
        // vessel name filter
        if (VesselName.Text !="")
        {
            sqlTxt += " AND a.flt_no like N'" + VesselName.Text + "%'";
        }
        if (TxtWeight.Text != "")
        {
            weight = double.Parse(TxtWeight.Text);
            if (WeightSelect.SelectedIndex == 1)
            {
                weight = weight / 2.2;
            }
            sqlTxt += " AND a.Gross_Wt='" + weight + "'";
        }
        return sqlTxt;
    }

    protected string HouseFilter(string sqlTxt)
    {
        // period filter
        if (Webdatetimeedit1.Text.Trim() != "")
        {
            sqlTxt += " AND a.CreatedDate>=CAST('" + Webdatetimeedit1.Text + "' AS DATETIME)";
        }

        if (Webdatetimeedit2.Text.Trim() != "")
        {
            sqlTxt += " AND a.CreatedDate<=CAST('" + Webdatetimeedit2.Text + "' AS DATETIME)";
        }
        // shipper filter
        if (hShipperAcct.Value != "" && hShipperAcct.Value != "0")
        {
            sqlTxt += " AND a.shipper_acct=" + hShipperAcct.Value.ToString();
        }
        // Ports filter

        if (OriginPortSelect.SelectedIndex > 0)
        {
            sqlTxt += " AND a.dep_code=N'" + OriginPortSelect.SelectedValue.ToString() + "'";
        }
        if (DestPortSelect.SelectedIndex > 0)
        {
            sqlTxt += " AND a.arr_code=N'" + DestPortSelect.SelectedValue.ToString() + "'";
        }
        // Consignee filter
        if (hConsigneeAcct.Value != "" && hConsigneeAcct.Value != "0")
        {
            sqlTxt += " AND a.consignee_acct=" + hConsigneeAcct.Value.ToString();
        }
        // Pieces filter
        if (NoPiece.Text != "")
        {
            sqlTxt += " AND b.Pieces =" + NoPiece.Text;
        }
        // LC NO filter
        if (LCNO.Text != "")
        {
            sqlTxt += " AND a.desc1 like N'" + LCNO.Text + "%'";
        }
        // LC NO filter
        if (CINO.Text != "")
        {
            sqlTxt += " AND a.desc2 like N'" + CINO.Text + "%'";
        }
        // LC NO filter
        if (OTH_REF_NO.Text != "")
        {
            sqlTxt += " AND a.customer_ref like N'" + OTH_REF_NO.Text + "%'";
        }
        if (txtFileNo.Text != "")
        {
            sqlTxt += " AND b.file_no like N'" + txtFileNo.Text + "%'";
        }
        if (lstSearchNum.Text != "")
        {
            sqlTxt += " AND a.MAWB_NUM like N'" + lstSearchNum.Text + "%'";
        }
        if( Txt1stHouse.Text != "")
        {
            sqlTxt += " AND a.HAWB_NUM like N'" + Txt1stHouse.Text + "%'";
        }
        if (VesselName.Text != "")
        {
            sqlTxt += " AND a.flt_no like N'" + VesselName.Text + "%'";
        }
        if (TxtWeight.Text != "")
        {
            weight =double.Parse(TxtWeight.Text);
            if (WeightSelect.SelectedIndex == 1)
            {
                weight=weight/2.2;
            }
            sqlTxt += " AND b.Gross_Wt='" + weight + "'";

        }
        return sqlTxt;
    }

    protected void LoadPorts()
    {
        string sqlText = "SELECT port_code,port_desc from port where elt_account_number="
            + elt_account_number + " order by port_desc";
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
/*
    protected void LoadMasterNUM()
    {
        string sqlText = "select mawb_num from import_mawb where elt_account_number= " + elt_account_number + " and Len(mawb_num)> 0 and itype='O' order by mawb_num";

        DataTable dt = new DataTable("MBOL_title");
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
            .Items.Add(new ListItem(dt.Rows[i]["mawb_num"].ToString(), dt.Rows[i]["mawb_num"].ToString()));
        }
    }
*/
    protected void LoadBookingNUM()
    {
        string sqlText = "select booking_num from ocean_booking_number where elt_account_number = " + elt_account_number + " order by booking_num";

        DataTable dt = new DataTable("Booking_title");
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
            //Booking_NO_Select.Items.Add(new ListItem(dt.Rows[i]["booking_num"].ToString(), dt.Rows[i]["booking_num"].ToString()));
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
        if (changeview == "Y")
        {
            gridie.Rows[0].Cells[0].Text = "";
        }
        else if (changeview == "N")
        {
            gridie.Rows[0].Cells[0].Text = "No Records Found.";
        }

        gridie.Rows[0].Cells[0].HorizontalAlign = HorizontalAlign.Center;
        ds.Tables[tableName].Rows.RemoveAt(0);
    }

    protected void GridViewHouse_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridViewHouse.PageIndex = e.NewPageIndex;
        reload_Page();
    }

    protected void GridViewMaster_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridViewMaster.PageIndex = e.NewPageIndex;
        reload_Page();
    }

    protected void btnGo_Click(object sender, ImageClickEventArgs e)
    {
        changeview = "N";
        if (PeriodDropDownList.SelectedIndex == 10)
        {
            Webdatetimeedit2.Text = "";
            Webdatetimeedit1.Text = "";
        }
        //S_Date = Webdatetimeedit1.Text.ToString();
        //E_Date = Webdatetimeedit2.Text.ToString();
        reload_Page();
    }

    protected void house_Click(object sender, ImageClickEventArgs e)
    {
        sortby = "hawb_num";
        reload_Page();
    }

    protected void master_Click(object sender, ImageClickEventArgs e)
    {
        sortby = "a.MAWB_NUM";
        reload_Page();
    }

    protected void File_Click(object sender, ImageClickEventArgs e)
    {
        sortby = "file#";
        reload_Page();
    }

    protected void SEC_Click(object sender, ImageClickEventArgs e)
    {
        sortby = "a.sec";
        reload_Page();
    }

    protected void Date_Click(object sender, ImageClickEventArgs e)
    {
        sortby = "tran_date";
        reload_Page();
    }

    protected void shipper_Click(object sender, ImageClickEventArgs e)
    {
        sortby = "shipper_name";
        reload_Page();
    }
    protected void Consignee_Click(object sender, ImageClickEventArgs e)
    {
        sortby = "consignee_name";
        reload_Page();
    }

    protected void Dep_Click(object sender, ImageClickEventArgs e)
    {
        sortby = "p1";
        reload_Page();
    }
    protected void Dest_Click(object sender, ImageClickEventArgs e)
    {
        sortby = "p2";
        reload_Page();
    }

    protected void reload_Page()
    {
        PerSQLSearch();
        BindGridView();
    }
        
    protected void Date_Changed(object sender, EventArgs e)
    {
        GridViewHouse.Controls.Clear();
        GridViewMaster.Controls.Clear();
        lblRecordCount.Text = "";

        //Today
        if (PeriodDropDownList.SelectedIndex == 1)
        {
            Webdatetimeedit1.Text = System.DateTime.Today.ToShortDateString();
            Webdatetimeedit2.Text = System.DateTime.Today.AddDays(1).ToShortDateString();
        }
        //month to date
        else if (PeriodDropDownList.SelectedIndex == 2)
        {
            month = System.DateTime.Today.Month;
            Date_Start(month);
            Webdatetimeedit2.Text = System.DateTime.Today.ToShortDateString();
        }
        //year to date
        else if (PeriodDropDownList.SelectedIndex == 3)
        {
            Webdatetimeedit1.Text = System.DateTime.Parse("1 1").ToShortDateString();
            Webdatetimeedit2.Text = System.DateTime.Today.ToShortDateString();
        }
        //this month
        else if (PeriodDropDownList.SelectedIndex == 4)
        {
            month = System.DateTime.Today.Month;
            Date_Start(month);
            Date_End(month);
        }
        //this Quarter
        else if (PeriodDropDownList.SelectedIndex == 5)
        {
            if (System.DateTime.Today.Month <= 3)
            {
                Webdatetimeedit1.Text = System.DateTime.Parse("1 1").ToShortDateString();
                Webdatetimeedit2.Text = System.DateTime.Parse("3 31").ToShortDateString();
            }
            else if (System.DateTime.Today.Month <= 6)
            {
                Webdatetimeedit1.Text = System.DateTime.Parse("4 1").ToShortDateString();
                Webdatetimeedit2.Text = System.DateTime.Parse("6 30").ToShortDateString();
            }
            else if (System.DateTime.Today.Month <= 9)
            {
                Webdatetimeedit1.Text = System.DateTime.Parse("7 1").ToShortDateString();
                Webdatetimeedit2.Text = System.DateTime.Parse("9 30").ToShortDateString();
            }
            else if (System.DateTime.Today.Month <= 12)
            {
                Webdatetimeedit1.Text = System.DateTime.Parse("10 1").ToShortDateString();
                Webdatetimeedit2.Text = System.DateTime.Parse("12 31").ToShortDateString();
            }
        }
        //this year
        else if (PeriodDropDownList.SelectedIndex == 6)
        {
            Webdatetimeedit1.Text = System.DateTime.Parse("1 1").ToShortDateString();
            Webdatetimeedit2.Text = System.DateTime.Parse("12 31").ToShortDateString();
        }
        // last month
        else if (PeriodDropDownList.SelectedIndex == 7)
        {
            month = System.DateTime.Today.Month;
            if (month == 1)
            {
                Webdatetimeedit1.Text = System.DateTime.Parse("12 1").AddYears(-1).ToShortDateString();
                Webdatetimeedit2.Text = System.DateTime.Parse("12 31").AddYears(-1).ToShortDateString();
            }
            else
            {
                month = month - 1;
                Date_Start(month);
                Date_End(month);
            }
        }
        //last Quarter
        else if (PeriodDropDownList.SelectedIndex == 8)
        {
            if (System.DateTime.Today.Month <= 3)
            {
                Webdatetimeedit1.Text = System.DateTime.Parse("10 1").AddYears(-1).ToShortDateString();
                Webdatetimeedit2.Text = System.DateTime.Parse("12 31").AddYears(-1).ToShortDateString();
            }
            else if (System.DateTime.Today.Month <= 6)
            {
                Webdatetimeedit1.Text = System.DateTime.Parse("1 1").ToShortDateString();
                Webdatetimeedit2.Text = System.DateTime.Parse("3 31").ToShortDateString();
            }
            else if (System.DateTime.Today.Month <= 9)
            {
                Webdatetimeedit1.Text = System.DateTime.Parse("4 1").ToShortDateString();
                Webdatetimeedit2.Text = System.DateTime.Parse("6 30").ToShortDateString();
            }
            else if (System.DateTime.Today.Month <= 12)
            {
                Webdatetimeedit1.Text = System.DateTime.Parse("7 1").ToShortDateString();
                Webdatetimeedit2.Text = System.DateTime.Parse("9 30").ToShortDateString();
            }
        }
        //last year
        else if (PeriodDropDownList.SelectedIndex == 9)
        {
            Webdatetimeedit1.Text = System.DateTime.Parse("1 1").AddYears(-1).ToShortDateString();
            Webdatetimeedit2.Text = System.DateTime.Parse("12 31").AddYears(-1).ToShortDateString();
        }
        else if (PeriodDropDownList.SelectedIndex == 10)
        {
            Webdatetimeedit1.Text = "";
            Webdatetimeedit2.Text = "";
        }

    }

    protected void Date_Start(int month)
    {
        if (month == 1)
        {
            Webdatetimeedit1.Text = System.DateTime.Parse("1 1").ToShortDateString();
        }
        else if (month == 2)
        {
            Webdatetimeedit1.Text = System.DateTime.Parse("2 1").ToShortDateString();
        }
        else if (month == 3)
        {
            Webdatetimeedit1.Text = System.DateTime.Parse("3 1").ToShortDateString();
        }
        else if (month == 4)
        {
            Webdatetimeedit1.Text = System.DateTime.Parse("4 1").ToShortDateString();
        }
        else if (month == 5)
        {
            Webdatetimeedit1.Text = System.DateTime.Parse("5 1").ToShortDateString();
        }
        else if (month == 6)
        {
            Webdatetimeedit1.Text = System.DateTime.Parse("6 1").ToShortDateString();
        }
        else if (month == 7)
        {
            Webdatetimeedit1.Text = System.DateTime.Parse("7 1").ToShortDateString();
        }
        else if (month == 8)
        {
            Webdatetimeedit1.Text = System.DateTime.Parse("8 1").ToShortDateString();
        }
        else if (month == 9)
        {
            Webdatetimeedit1.Text = System.DateTime.Parse("9 1").ToShortDateString();
        }
        else if (month == 10)
        {
            Webdatetimeedit1.Text = System.DateTime.Parse("10 1").ToShortDateString();
        }
        else if (month == 11)
        {
            Webdatetimeedit1.Text = System.DateTime.Parse("11 1").ToShortDateString();
        }
        else if (month == 12)
        {
            Webdatetimeedit1.Text = System.DateTime.Parse("12 1").ToShortDateString();
        }
    }

    protected void Date_End(int month)
    {
        if (month == 1)
        {
            Webdatetimeedit2.Text = System.DateTime.Parse("1 31").ToShortDateString();
        }
        else if (month == 2)
        {
            Webdatetimeedit2.Text = System.DateTime.Parse("2 28").ToShortDateString();
        }
        else if (month == 3)
        {
            Webdatetimeedit2.Text = System.DateTime.Parse("3 31").ToShortDateString();
        }
        else if (month == 4)
        {
            Webdatetimeedit2.Text = System.DateTime.Parse("4 30").ToShortDateString();
        }
        else if (month == 5)
        {
            Webdatetimeedit2.Text = System.DateTime.Parse("5 31").ToShortDateString();
        }
        else if (month == 6)
        {
            Webdatetimeedit2.Text = System.DateTime.Parse("6 30").ToShortDateString();
        }
        else if (month == 7)
        {
            Webdatetimeedit2.Text = System.DateTime.Parse("7 31").ToShortDateString();
        }
        else if (month == 8)
        {
            Webdatetimeedit2.Text = System.DateTime.Parse("8 31").ToShortDateString();
        }
        else if (month == 9)
        {
            Webdatetimeedit2.Text = System.DateTime.Parse("9 30").ToShortDateString();
        }
        else if (month == 10)
        {
            Webdatetimeedit2.Text = System.DateTime.Parse("10 31").ToShortDateString();
        }
        else if (month == 11)
        {
            Webdatetimeedit2.Text = System.DateTime.Parse("11 30").ToShortDateString();
        }
        else if (month == 12)
        {
            Webdatetimeedit2.Text = System.DateTime.Parse("12 31").ToShortDateString();
        }
    }
}
