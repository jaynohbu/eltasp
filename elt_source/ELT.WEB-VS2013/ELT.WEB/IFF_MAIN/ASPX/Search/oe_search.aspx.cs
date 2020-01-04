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

public partial class ASPX_SEARCH_OE_SEARCH : System.Web.UI.Page
{
    protected DataSet dm = null;
    protected DataSet dv = null;
    protected DataSet ds = null;
    protected DataSet dt = null;
    protected string ConnectStr = null;
    private string elt_account_number = null;
    private string user_id, login_name, user_right;
    private string sortby = null;
    private string sortby2 = null;
    private double weight = 0;
    private string changeview = "N";
    private int maxRows = 100;
    protected ReportSourceManager rsm = null;
    private int month = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        Session.LCID = 1033;
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
        ConnectStr = (new igFunctions.DB().getConStr());

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
        ds = new DataSet();
        string HouseSQL = "";
        string MasterSQL = "";
        HouseSQL = "select a.hbol_NUM as houseNo,a.mbol_NUM as MasterNo,a.booking_num as booking_num,isnull(b.file_no,'') as file#"
                 + ", a.CreatedDate as CreatedDate,a.shipper_name as shipper_name,a.shipper_acct_num as shipper_no ,a.measurement as measurement,a.consignee_name"
                 + " as consignee_name, a.consignee_acct_num as consignee_no, a.is_master as is_master,a.is_sub as is_sub, Right(rtrim(a.mbol_NUM),4) as lastF#,a.agent_name"
                 + " as agent, a.agent_no as agent_no,a.loading_port as p1,a.unloading_port as p2 from hbol_master a left outer join ocean_booking_number"
                 + " b on a.elt_account_number = b.elt_account_number and a.booking_num = b.booking_num where a.elt_account_number =" + elt_account_number;

        MasterSQL = "select a.booking_num as booking_num ,a.mbol_NUM as houseNo,a.mbol_NUM as MasterNo,isnull(b.file_no,'') as file#,a.CreatedDate"
                  + " as CreatedDate,a.shipper_name as shipper_name,a.shipper_acct_num as shipper_no,a.measurement as measurement,a.consignee_name as consignee_name,Right(rtrim(a.mbol_NUM),4)"
                  + " as lastF#,a.consignee_acct_num as consignee_no,a.agent_name as agent,a.loading_port as p1,a.unloading_port as p2 from mbol_master a left  join ocean_booking_number b"
                  + " on (a.elt_account_number = b.elt_account_number and a.booking_num = b.booking_num)";
         MasterSQL = MasterSQL + "where a.elt_account_number =" + elt_account_number;

        if (sortby == null)
        {
            if (sortway2.Text == "")
            {
                sortby = "a.hbol_NUM";
                sortby2 = "a.mbol_NUM";
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
            
            HouseSQL = HouseFilter(HouseSQL) + " ORDER BY "+ sortby;
            if (sortby.ToString() == sortway.Text)
            {
                HouseSQL = HouseSQL + " DESC";
            }
            Session["HOUSEList"] = HouseSQL;
        }
        else
        {
            MasterSQL = MasterFilter(MasterSQL) + " ORDER BY "+ sortby2;
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

                    showhawbitem();
                    GridViewHouse.Visible = true;
                    GridViewMaster.Visible = false;
                    if (ds.Tables["HouseTable"].Rows.Count == 0 )
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
                    hiddenhawbitem();
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
                        lblRecordCount.Text = ds.Tables["MasterTable"].Rows.Count + " records found.&nbsp;&nbsp;&nbsp;Page "
                            + (GridViewMaster.PageIndex + 1) + " / " + GridViewMaster.PageCount;
                    }
                }
                ds.Dispose();
        }
        catch
        {
            Response.Write("<script>alert('Error occurred. Couldn't continue searching.'); self.close();</script>");
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

    protected void showhawbitem()
    {
        Txt1stHawb.Visible = true;
        LCNO.Visible = true;
        CINO.Visible = true;
        OTH_REF_NO.Visible = true;
        //lstAgentName.Visible = true;
        //imagb.Visible = true;
        tblAgent.Visible = true;
        CheckAllH.Visible = true;
        CheckSub.Visible = true;
        CheckMaster.Visible = true;
        CheckAT.Visible = false;
        CheckCon.Visible = false;
        CheckDS.Visible = false;
        label0.Text = "House B/L No.";
        label1.Text = "LC No.";
        label2.Text = "C.I.No.";
        label3.Text = "Other Reference No.";
        label4.Text = "Agent";
        label5.Text = "Type of House";
    }

    protected void hiddenhawbitem()
    {
        Txt1stHawb.Visible = false;
        LCNO.Visible = false;
        CINO.Visible = false;
        OTH_REF_NO.Visible = false;
        //lstAgentName.Visible = false;
        //imagb.Visible = false;
        tblAgent.Visible = false;
        CheckAllH.Visible = false;
        CheckSub.Visible = false;
        CheckMaster.Visible = false;
        CheckAT.Visible = true;
        CheckCon.Visible = true;
        CheckDS.Visible = true;
        label0.Text = "Type of Shipment";
        label1.Text = "";
        label2.Text = "";
        label3.Text = "";
        label4.Text = "";
        label5.Text = "";
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
        TxtCBM.Text = "";
        TxtWeight.Text = "";
        lstSearchNum.Text = "";
        OriginPortSelect.SelectedIndex = 0;
        DestPortSelect.SelectedIndex = 0;
        lstAgentName.Text = "";
        hAgentAcct.Value = "";
        lstBookingNum.Text = "";
        WeightSelect.SelectedIndex = 0;
        hConsigneeAcct.Value = "";
        lstConsigneeName.Text = "";
        NoPiece.Text = "";
        txtFileNo.Text = "";
        lstShipperName.Text = "";
        hShipperAcct.Value = "";
        CINO.Text = "";
        LCNO.Text = "";
        OTH_REF_NO.Text = "";
        Txt1stHawb.Text="";
        CheckAllH.Checked = true;
        CheckSub.Checked = false;
        CheckMaster.Checked = false;
        CheckAT.Checked = true;
        CheckCon.Checked = false;
        CheckDS.Checked = false;
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
            sqlTxt += " AND a.loading_port='" + OriginPortSelect.SelectedValue.ToString() + "'";
        }
        if (DestPortSelect.SelectedIndex > 0)
        {
            sqlTxt += " AND a.unloading_port='" + DestPortSelect.SelectedValue.ToString() + "'";
        }
        // shipper filter
        if (lstShipperName.Text != "")
        {
            sqlTxt += " AND a.shipper_name like N'%" + lstShipperName.Text + "%'";
        }
        // Consignee filter
        if (hConsigneeAcct.Value != "" && hConsigneeAcct.Value != "0")
        {
            sqlTxt += " AND a.consignee_acct_num=" + hConsigneeAcct.Value.ToString();
        }
        // Booking filter
        if (lstBookingNum.Text!="")
        {
            sqlTxt += " AND a.booking_num like N'%" + lstBookingNum.Text + "%'";
        }
        // Pieces filter
        if (NoPiece.Text != "")
        {
            sqlTxt += " AND a.Pieces =" + NoPiece.Text;
        }
        // file filter
        if (txtFileNo.Text != "")
        {
            sqlTxt += " AND b.file_no like N'%" + txtFileNo.Text + "%'";
        }
        if (lstSearchNum.Text != "")
        {
            sqlTxt += " AND a.mbol_NUM like N'%" + lstSearchNum.Text + "%'";
        }
        // Vessel Name Filter
        if (VesselName.Text != "")
        {
            sqlTxt += " AND b.vsl_name like N'%" + VesselName.Text + "%'";
        }
        // CBM Filter
        if (TxtCBM.Text != "")
        {
            sqlTxt += " AND a.measurement like N'" + TxtCBM.Text + "%'";
        }
        if (CheckCon.Checked == true)
        {
            sqlTxt += "AND a.booking_num IN (select booking_num from hbol_master where elt_account_number= " + elt_account_number + " and booking_num <> '' )";
        }
        if (CheckDS.Checked == true)
        {
            sqlTxt += "AND a.booking_num Not IN (select booking_num from hbol_master where elt_account_number= " + elt_account_number + " and booking_num <> '' )";
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
        // Booking filter
        if (lstBookingNum.Text != "")
        {
            sqlTxt += " AND a.booking_num like N'%" + lstBookingNum.Text + "%'";
        }
        // shipper filter
        if (lstShipperName.Text != "")
        {
            sqlTxt += " AND a.shipper_name like N'%" + lstShipperName.Text + "%'";
        }
        // Ports filter

        if (OriginPortSelect.SelectedIndex > 0)
        {
            sqlTxt += " AND a.loading_port='" + OriginPortSelect.SelectedValue.ToString() + "'";
        }
        if (DestPortSelect.SelectedIndex > 0)
        {
            sqlTxt += " AND a.unloading_port='" + DestPortSelect.SelectedValue.ToString() + "'";
        }
        // Consignee filter
        if (hConsigneeAcct.Value != "" && hConsigneeAcct.Value != "0")
        {
            sqlTxt += " AND a.consignee_acct_num=" + hConsigneeAcct.Value.ToString();

        }
        // Pieces filter
        if (NoPiece.Text != "")
        {
            sqlTxt += " AND a.Pieces =" + NoPiece.Text;
        }
        // LC NO filter
        if (LCNO.Text != "")
        {
            sqlTxt += " AND a.lc like N'" + LCNO.Text + "%'";
        }
        // LC NO filter
        if (CINO.Text != "")
        {
            sqlTxt += " AND a.ci like N'" + CINO.Text + "%'";
        }
        // other Reference No filter
        if (OTH_REF_NO.Text != "")
        {
            sqlTxt += " AND a.export_ref like N'%" + OTH_REF_NO.Text + "%'";
        }
        // file filter
        if (txtFileNo.Text != "")
        {
            sqlTxt += " AND b.file_no like N'%" + txtFileNo.Text + "%'";
        }
        if (lstSearchNum.Text != "")
        {
            sqlTxt += " AND a.mbol_NUM like N'%" + lstSearchNum.Text + "%'";
        }
        if( Txt1stHawb.Text != "")
        {
            sqlTxt += " AND a.hbol_NUM like N'%" + Txt1stHawb.Text + "%'";
        }
        //Agent filter
        if (lstAgentName.Text != "")
        {
            sqlTxt += " AND a.Agent_name like N'%" + lstAgentName.Text + "%'";
        }
        // House Type filter
        if (CheckSub.Checked == true)
        {
            sqlTxt += " AND a.is_sub='Y'";
        }
        if (CheckMaster.Checked == true)
        {
            sqlTxt += " AND a.is_master='Y'";
        }
        // weight Filter
        if (TxtWeight.Text != "")
        {
            weight = double.Parse(TxtWeight.Text);
            if (WeightSelect.SelectedIndex == 1)
            {
                weight = weight / 2.2;
            }
            sqlTxt += " AND a.Gross_Weight='" + weight + "'";
        }
        // Vessel Name Filter
        if (VesselName.Text != "")
        {
            sqlTxt += " AND b.vsl_name like N'%" + VesselName.Text + "%'";
        }
        // CBM Filter
        if (TxtCBM.Text != "")
        {
            sqlTxt += " AND a.measurement like N'" + TxtCBM.Text + "%'";
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
            OriginPortSelect.Items.Add(new ListItem(dt.Rows[i]["port_desc"].ToString(), dt.Rows[i]["port_desc"].ToString()));
            DestPortSelect.Items.Add(new ListItem(dt.Rows[i]["port_desc"].ToString(), dt.Rows[i]["port_desc"].ToString()));
        }
    }

    /*    protected void LoadBookingNUM()
        {
            string sqlText = "select booking_num from ocean_booking_number where EmailItemID = " + EmailItemID + " order by booking_num";
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
                .Items.Add(new ListItem(dt.Rows[i]["booking_num"].ToString(), dt.Rows[i]["booking_num"].ToString()));
            }
        }

        protected void LoadMasterNUM()
        {
            string sqlText = "select mbol_num from ocean_booking_number where EmailItemID= " + EmailItemID + " and len(mbol_num)>0 order by mbol_num";
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
                .Items.Add(new ListItem(dt.Rows[i]["mbol_num"].ToString(), dt.Rows[i]["mbol_num"].ToString()));
            }
        }*/

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
        reload_Page();
    }

    protected void house_Click(object sender, ImageClickEventArgs e)
    {
        sortby = "houseNo";
        reload_Page();
    }

    protected void master_Click(object sender, ImageClickEventArgs e)
    {
        sortby = "MasterNo";
        reload_Page();
    }

    protected void Booking_Click(object sender, ImageClickEventArgs e)
    {
        sortby = "a.booking_num";
        reload_Page();

    }

    protected void File_Click(object sender, ImageClickEventArgs e)
    {
        sortby = "file#";
        reload_Page();
    }

    protected void ETD_Click(object sender, ImageClickEventArgs e)
    {
        sortby = "CreatedDate";
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

    protected void Agent_Click(object sender, ImageClickEventArgs e)
    {
        sortby = "Agent";
        reload_Page();
    }
   
    protected void reload_Page()
    {
        PerSQLSearch();
        BindGridView();

    }

    public string GetShortDate(object dateStr)
    {
        string returnVal = "";
        if (dateStr.ToString() != "")
        {
            returnVal = System.Convert.ToDateTime(dateStr).ToString("MM/dd/yyyy");
        }
        return returnVal;
    }

    public string GetHouse(object IsMaster, object IsSub)
    {
        string HouseType = "";
        if (IsMaster.ToString() == "Y")
        {
            if (IsSub.ToString() == "Y")
            {
                HouseType="Master /Sub House";
            }
            else
            {
                HouseType="Master House";
            }
        }
        else if (IsSub.ToString() == "Y")
        {
            HouseType = "Sub House"; 
        }

        return HouseType;
    }

    public string GetShipType(object Booking_Num )
    {
        string shipType = "";
        string ShiptypeSQL ="";

        ShiptypeSQL = "select a.booking_num from hbol_master a left outer join ocean_booking_number b on "
            + " a.elt_account_number = b.elt_account_number and a.booking_num = b.booking_num where a.elt_account_number= " + elt_account_number + " and a.booking_num = '" + Booking_Num + "'";
        DataTable dm = new DataTable("ShipTypeTable");
        SqlDataAdapter Adap = null;
        SqlConnection Con = null;
            if (ShiptypeSQL != null && ShiptypeSQL.Trim() != "")
            {
                try
                {
                    ConnectStr = (new igFunctions.DB().getConStr());
                    Con = new SqlConnection(ConnectStr);
                    Adap = new SqlDataAdapter();
                    dv = new DataSet();

                    Con.Open();
                    SqlCommand cmd = new SqlCommand(ShiptypeSQL.ToString(), Con);
                    Adap.SelectCommand = cmd;
                    Adap.Fill(dm);
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

                if (dm.Rows.Count > 0)
                {
                            shipType = "Consol" ;
                }
                else
                {
                        shipType = " Direct";

                }
        return shipType;
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
