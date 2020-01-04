using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using CrystalDecisions.Shared;
using System.Data.SqlClient;
using Infragistics.WebUI.UltraWebGrid;
using System.IO;
using System.Configuration;

namespace IFF_MAIN.ASPX.Reports.Accounting
{
    public partial class ARAgingDetail : System.Web.UI.Page
    {
        protected System.Web.UI.WebControls.Button butShowCols;

        //***********************************************************//
        protected string ParentTable = "AR";
        protected string ChildTable = "ARDETAIL";
        protected string keyColName = "Company Name No";
        protected string dsXMLName = "AR";
        protected string sHeaderName = "ARAGINGSUMMARY";
        protected string sDetailName = "ARAGINGSUMMARYDETAIL";
        protected string defaultReportForm = "INVOICE.rpt";
        protected string strDefaultXSDFileName = "AR.XSD";
        protected string strDefaultXMLFileName = "AR.XML";
        protected string strDefaultXMLXSDFileName = "ARALL.XML";
        protected string ParentPage = "ARAgingSelection.aspx";
        public string elt_account_number;
        public string user_id;
        protected string login_name;
        protected string strUserRight;
        protected string strBranch;
        protected string strCompany;
        protected string ConnectStr;
        protected DataSet ds = new DataSet();

        //---------------------------------------------------------------------------------------------------------------
        protected ReportSourceManager rsm = null;

        private void PrepReportDS()
        {
            string asOf = Session["AsOf"].ToString();
            string branchName = Session["Branch_Name"].ToString();
            string branchCode = Session["Branch_Code"].ToString();
            login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
            ConnectStr = (new igFunctions.DB().getConStr());
            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand Cmd = new SqlCommand();
            Cmd.Connection = Con;
            SqlDataReader reader;

            DataTable dt = new DataTable();
            dt.TableName = "BUSINFO";

            string fname = "";
            string lname = "";
            string fullname = "";

            string business_address = "";
            string business_city = "";
            string business_state = "";
            string business_zip = "";

            string business_country = "";
            string business_fax = "";
            string business_phone = "";
            string business_url = "";

            try
            {
                Con.Open();
                Cmd.CommandText = "SELECT user_lname, user_fname FROM users WHERE login_name = '" + login_name + "' AND elt_account_number =" + branchCode;
                reader = Cmd.ExecuteReader();

                if (reader.Read())
                {

                    fname = reader["user_fname"].ToString();
                    lname = reader["user_lname"].ToString();

                    fullname = lname + "," + fname;
                    if (fullname == ",")
                    {
                        fullname = login_name;
                    }

                }
                DataRow aRow = dt.NewRow();

                DataColumn dc_asof = new DataColumn("As_Of");
                DataColumn dc_branch_name = new DataColumn("Branch_Name");
                DataColumn dc_branch_code = new DataColumn("Branch_Code");
                DataColumn user_full_name = new DataColumn("User_FullName");

                dt.Columns.Add(dc_asof);
                dt.Columns.Add(dc_branch_name);
                dt.Columns.Add(dc_branch_code);
                dt.Columns.Add(user_full_name);

                dt.Columns.Add(new DataColumn("business_address"));
                dt.Columns.Add(new DataColumn("business_city"));
                dt.Columns.Add(new DataColumn("business_state"));
                dt.Columns.Add(new DataColumn("business_zip"));

                dt.Columns.Add(new DataColumn("business_country"));
                dt.Columns.Add(new DataColumn("business_fax"));
                dt.Columns.Add(new DataColumn("business_phone"));
                dt.Columns.Add(new DataColumn("business_url"));

                reader.Close();

                // here we load logo 

                Cmd.CommandText = "SELECT business_address, business_city, business_state, business_zip, business_country, business_fax, business_phone, business_url FROM agent WHERE elt_account_number =" + branchCode;
                reader = Cmd.ExecuteReader();


                if (reader.Read())
                {
                    business_address = reader["business_address"].ToString();
                    business_city = reader["business_city"].ToString();
                    business_state = reader["business_state"].ToString();
                    business_zip = reader["business_zip"].ToString();

                    business_country = reader["business_country"].ToString();
                    business_fax = reader["business_fax"].ToString();
                    business_phone = reader["business_phone"].ToString();
                    business_url = reader["business_url"].ToString();

                    reader.Close();
                    fullname = lname + "," + fname;
                    if (fullname == ",")
                    {
                        fullname = login_name;
                    }

                }

                aRow["As_Of"] = asOf;// specially used for the AR/AP aging reports

                aRow["Branch_Name"] = branchName;
                aRow["Branch_Code"] = branchCode;
                aRow["User_FullName"] = fullname;
                aRow["business_address"] = business_address;
                aRow["business_city"] = business_city;
                aRow["business_state"] = business_state;
                aRow["business_zip"] = business_zip;

                aRow["business_country"] = business_country;
                aRow["business_fax"] = business_fax;
                aRow["business_phone"] = business_phone;
                aRow["business_url"] = business_url;
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

        private void LoadReport()
        {
            PrepReportDS();
            rsm = new ReportSourceManager();
            try
            {
                rsm.LoadDataSet(ds);
                rsm.WriteXSD(Server.MapPath("../../../CrystalReportResources/xsd/ARAging.xsd"));
                rsm.BindNow(Server.MapPath("../../../CrystalReportResources/rpt/ARAging.rpt"));
            }
            catch (Exception e)
            {
                Response.Write(e.ToString());
                Response.End();
            }
        }
        //-----------------------------------------------------------------------------------


        protected void Page_Load(object sender, System.EventArgs e)
        {
            Session.LCID = 1033;

            if (Session["AsOf"] == null)
            {
                Response.Redirect(ParentPage);
            }

            if (!IsPostBack)
            {
                ViewState["Count"] = 1;
                if (Request.UrlReferrer == null)
                {
                    Response.Redirect(ParentPage);
                }
                else
                {
                    string refer = Request.UrlReferrer.ToString();
                    string ServerPath = Request.Url.ToString();
                    ServerPath = ServerPath.Substring(0, ServerPath.LastIndexOf("/"));
                    if (refer.IndexOf(ServerPath) == -1)
                        Response.Redirect(ParentPage);
                }

                PerformSearch();
                PerformDataBind();
            }
            else
            {
                ViewState["Count"] = (int)ViewState["Count"] + 1;
            }
        }

        private void PerformSearch()
        {
            string[] str = new string[4];
            string strCommandText;
            string strlblBranch;

            strCommandText = Session["strCommandText"].ToString();
            strlblBranch = Session["strlblBranch"].ToString();
            strBranch = Session["strBranch"].ToString();

            // Response.Write(strCommandText);

            str[0] = Session["str0"].ToString();
            str[1] = Session["str1"].ToString();
            str[2] = Session["str2"].ToString();
            str[3] = Session["str3"].ToString();

            for (int i = 0; i < str.Length - 1; i++)
            {
                if (str[i + 1] != "") str[i] = str[i] + "/";
            }

            Label2.Text = string.Format("<FONT color='navy' size='1pt'>{0} {1} {2} {3} </FONT>", str[0], str[1], str[2], str[3]);

            if (strCommandText == "") Response.Redirect(ParentPage);


            PerformGetARData(strCommandText, strBranch);
        }

        private void PerformGetARData(string strCommandText, string strBranch)
        {
            ConnectStr = (new igFunctions.DB().getConStr());
            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand Cmd = new SqlCommand();
            Cmd.Connection = Con;

            Con.Open();

            Cmd.CommandText = strCommandText;

            SqlDataReader reader = Cmd.ExecuteReader();

            //**********************************************// refer from old program logic

            double
                sTotalCurrent = 0,
                sTotal1_30 = 0,
                sTotal31_60 = 0,
                sTotal61_90 = 0,
                sTotal91 = 0,
                sTotal = 0,

                sCurrent = 0,
                s1_30 = 0,
                s31_60 = 0,
                s61_90 = 0,
                s91 = 0,
                sSubTotal = 0;

            string vLastName = "", cName = "", cPhone = "", cCredit = "", vLastCredit = "";
            string vLastCompanyName = "", cCompanyName = "", vLastPhone = "";
            int tIndex = 0;
            int bIndex = 0;

            int iCount = 0;
            while (reader.Read()) { iCount++; };
            reader.Close();

            string[,] aField = new string[10, iCount];
            string[,] bField = new string[19, iCount];

            reader = Cmd.ExecuteReader();

            while (reader.Read())
            {
                #region // Parent logic

                cName = reader["customer_no"].ToString().Trim();
                cCompanyName = reader["customer_dba_name"].ToString().Trim();
                cPhone = reader["business_phone"].ToString().Trim();
                cCredit = reader["customer_credit"].ToString().Trim();

                if (bIndex == 0)
                {
                    vLastName = cName;
                    vLastCompanyName = cCompanyName;
                    vLastPhone = cPhone;
                    vLastCredit = cCredit;
                }

                if (cName != vLastName)
                {
                    aField[0, tIndex] = vLastName;
                    aField[1, tIndex] = sTotalCurrent.ToString();
                    aField[2, tIndex] = sTotal1_30.ToString();
                    aField[3, tIndex] = sTotal31_60.ToString();
                    aField[4, tIndex] = sTotal61_90.ToString();
                    aField[5, tIndex] = sTotal91.ToString();
                    aField[6, tIndex] = sTotal.ToString();
                    aField[7, tIndex] = vLastCompanyName;
                    aField[8, tIndex] = vLastPhone;
                    aField[9, tIndex] = vLastCredit;

                    vLastName = cName;
                    vLastCompanyName = cCompanyName;
                    vLastPhone = cPhone;
                    vLastCredit = cCredit;

                    tIndex += 1;
                    sTotalCurrent = 0;
                    sTotal1_30 = 0;
                    sTotal31_60 = 0;
                    sTotal61_90 = 0;
                    sTotal91 = 0;
                    sTotal = 0;
                }

                string vInvoiceType = reader["invoice_type"].ToString();
                string vTerm = reader["term_curr"].ToString();
                if (vTerm == "")
                {
                    vTerm = "0";
                }

                DateTime vInvoiceDate;
                double vBalance;

                if (reader["invoice_no"].ToString() == string.Empty)
                {
                    vInvoiceDate = DateTime.Now;
                    vBalance = double.Parse(reader["customer_credit"].ToString());
                }
                else
                {
                    vInvoiceDate = DateTime.Parse(reader["invoice_date"].ToString());
                    vBalance = double.Parse(reader["balance"].ToString());
                }

                //DateTime d1 = DateTime.Now;
                DateTime d1 = DateTime.Parse(Session["AsOf"].ToString());

                TimeSpan days = new TimeSpan(int.Parse(vTerm), 0, 0, 0, 0);
                TimeSpan vAging = d1 - (vInvoiceDate + days);

                if (vAging.Days <= 0)
                {
                    if (reader["invoice_no"].ToString() != string.Empty)
                    {
                        sTotalCurrent = sTotalCurrent + vBalance;
                    }
                    sTotal = sTotal + vBalance;
                    // vTotalCurrent=vTotalCurrent+vBalance;
                }
                else if (vAging.Days > 0 && vAging.Days < 31)
                {
                    sTotal1_30 = sTotal1_30 + vBalance;
                    sTotal = sTotal + vBalance;
                    // vTotal1_30=vTotal1_30+vBalance;
                }
                else if (vAging.Days > 30 && vAging.Days < 61)
                {
                    sTotal31_60 = sTotal31_60 + vBalance;
                    sTotal = sTotal + vBalance;
                    // vTotal31_60=vTotal31_60+vBalance;
                }
                else if (vAging.Days > 60 && vAging.Days < 91)
                {
                    sTotal61_90 = sTotal61_90 + vBalance;
                    sTotal = sTotal + vBalance;
                    // vTotal61_90=vTotal61_90+vBalance;
                }
                else if (vAging.Days > 90)
                {
                    sTotal91 = sTotal91 + vBalance;
                    sTotal = sTotal + vBalance;
                    // vTotal91=vTotal91+vBalance;
                }

                if ((bIndex + 1) == iCount)  // end of reader
                {
                    aField[0, tIndex] = cName;
                    aField[1, tIndex] = sTotalCurrent.ToString();
                    aField[2, tIndex] = sTotal1_30.ToString();
                    aField[3, tIndex] = sTotal31_60.ToString();
                    aField[4, tIndex] = sTotal61_90.ToString();
                    aField[5, tIndex] = sTotal91.ToString();
                    aField[6, tIndex] = sTotal.ToString();
                    aField[7, tIndex] = cCompanyName;
                    aField[8, tIndex] = cPhone;
                    aField[9, tIndex] = cCredit;

                    tIndex += 1;  // for using transfer to DataTable below
                }

                #endregion

                // Detail Info. : Refer from original program...I hate this kind of logic.... 
                // (by iMoon...)

                sCurrent = 0;
                s1_30 = 0;
                s31_60 = 0;
                s61_90 = 0;
                s91 = 0;
                sSubTotal = 0;

                bField[0, bIndex] = cName;
                bField[18, bIndex] = cCompanyName;
                bField[2, bIndex] = vInvoiceDate.ToShortDateString();
                bField[3, bIndex] = reader["invoice_no"].ToString();
                bField[4, bIndex] = reader["ref_no"].ToString();

                if (vInvoiceType != "P")
                {
                    bField[5, bIndex] = ((DateTime)(vInvoiceDate + days)).ToShortDateString();
                }

                if ((vAging.Days > 0) && (vInvoiceType != "P"))
                {
                    bField[6, bIndex] = vAging.Days.ToString();
                }

                bField[7, bIndex] = vBalance.ToString();

                if (vInvoiceType == "P")
                {
                    bField[7, bIndex] = (-1 * vBalance).ToString();
                }

                if (vAging.Days <= 0)
                {
                    sCurrent = vBalance;
                    sSubTotal = vBalance;
                }
                else if (vAging.Days > 0 && vAging.Days < 31)
                {
                    s1_30 = vBalance;
                    sSubTotal = vBalance;
                }
                else if (vAging.Days > 30 && vAging.Days < 61)
                {
                    s31_60 = vBalance;
                    sSubTotal = vBalance;
                }
                else if (vAging.Days > 60 && vAging.Days < 91)
                {
                    s61_90 = vBalance;
                    sSubTotal = vBalance;
                }
                else if (vAging.Days > 90)
                {
                    s91 = vBalance;
                    sSubTotal = vBalance;
                }

                bField[8, bIndex] = sCurrent.ToString();
                bField[9, bIndex] = s1_30.ToString();
                bField[10, bIndex] = s31_60.ToString();
                bField[11, bIndex] = s61_90.ToString();
                bField[12, bIndex] = s91.ToString();
                bField[13, bIndex] = sSubTotal.ToString();



                string vEI = reader["import_export"].ToString();
                string iType = reader["air_ocean"].ToString();

                string vAirOcean = reader["air_ocean"].ToString();
                string vImportExport = reader["import_export"].ToString();
                string vHouseNumber = reader["hawb_num"].ToString();
                string vMasterNumber = reader["mawb_num"].ToString();
                string vInvoiceNo = reader["invoice_no"].ToString();

                switch (vInvoiceType)
                {
                    case "P":
                        break;
                    case "I":
                        if (vAirOcean == "A" && vImportExport == "I")
                        {
                            bField[1, bIndex] = "ARN";
                        }
                        else if (vAirOcean == "O" && vImportExport == "I")
                        {
                            bField[1, bIndex] = "ARN";
                        }
                        else if (double.Parse(bField[13, bIndex]) < 0)
                        {
                            bField[1, bIndex] = "CRN";
                        }
                        else
                        {
                            bField[1, bIndex] = "INV";
                        }
                        break;
                    case "G":
                        bField[1, bIndex] = "GJE";
                        break;
                    default:
                        if (reader["customer_credit"].ToString() != string.Empty)
                        {
                            bField[1, bIndex] = "CRD";
                        }
                        else
                        {
                            bField[1, bIndex] = "PMT";
                        }
                        break;
                }

                bField[15, bIndex] = vTerm;
                bField[16, bIndex] = vHouseNumber;
                bField[17, bIndex] = vAirOcean + vImportExport;

                bIndex += 1;
            }

            reader.Close();

            Con.Close();

            // DataTable

            #region // Parent table

            DataTable dt = new DataTable(ParentTable);
            DataRow dr;

            dt.Columns.Add(new DataColumn(keyColName, typeof(string)));
            dt.Columns.Add(new DataColumn("Current", typeof(System.Decimal)));
            dt.Columns.Add(new DataColumn("1~30", typeof(System.Decimal)));
            dt.Columns.Add(new DataColumn("31~60", typeof(System.Decimal)));
            dt.Columns.Add(new DataColumn("61~90", typeof(System.Decimal)));
            dt.Columns.Add(new DataColumn("+90", typeof(System.Decimal)));
            dt.Columns.Add(new DataColumn("Total", typeof(System.Decimal)));
            dt.Columns.Add(new DataColumn("Company Name", typeof(string)));
            dt.Columns.Add(new DataColumn("Phone", typeof(string)));
            dt.Columns.Add(new DataColumn("Credit", typeof(System.Decimal)));

            for (int i = 0; i < tIndex; i++)
            {
                if (aField[0, i] == null) break;

                dr = dt.NewRow();
                dr[0] = aField[0, i];
                dr[1] = aField[1, i];
                dr[2] = aField[2, i];
                dr[3] = aField[3, i];
                dr[4] = aField[4, i];
                dr[5] = aField[5, i];
                dr[6] = aField[6, i];
                dr[7] = aField[7, i];
                dr[8] = aField[8, i];
                dr[9] = aField[9, i];

                if (dr[0].ToString() != string.Empty) dt.Rows.Add(dr);
            }


            ds.Tables.Add(dt);

            #endregion

            # region // Child table
            DataTable cdt = new DataTable(ChildTable);
            DataRow cdr;

            cdt.Columns.Add(new DataColumn(keyColName, typeof(string)));
            cdt.Columns.Add(new DataColumn("Type", typeof(string)));
            cdt.Columns.Add(new DataColumn("I/V Date", typeof(System.DateTime)));
            cdt.Columns.Add(new DataColumn("I/V No.", typeof(string)));
            cdt.Columns.Add(new DataColumn("House Type", typeof(string)));
            cdt.Columns.Add(new DataColumn("House No.", typeof(string)));
            cdt.Columns.Add(new DataColumn("Ref No.", typeof(string)));
            cdt.Columns.Add(new DataColumn("Due Date", typeof(System.DateTime)));
            cdt.Columns.Add(new DataColumn("Term", typeof(string)));
            cdt.Columns.Add(new DataColumn("Aging", typeof(string)));
            cdt.Columns.Add(new DataColumn("Open Balance", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("Current", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("1~30", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("31~60", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("61~90", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("+90", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("Total", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("Company Name", typeof(string)));

            for (int i = 0; i < bIndex; i++)
            {
                if (bField[0, i] == null) break;

                cdr = cdt.NewRow();

                cdr[0] = bField[0, i];
                cdr[1] = bField[1, i];
                cdr[2] = bField[2, i];
                cdr[3] = bField[3, i];
                cdr[4] = bField[17, i];
                cdr[5] = bField[16, i];
                cdr[6] = bField[4, i];
                cdr[7] = bField[5, i];
                cdr[8] = bField[15, i];
                cdr[9] = bField[6, i];
                cdr[10] = bField[7, i];
                cdr[11] = bField[8, i];
                cdr[12] = bField[9, i];
                cdr[13] = bField[10, i];
                cdr[14] = bField[11, i];
                cdr[15] = bField[12, i];
                cdr[16] = bField[13, i];
                cdr[17] = bField[18, i];

                // Customer Credit
                if (bField[1, i] == "CRD")
                {
                    cdr[2] = DBNull.Value;
                    cdr[7] = DBNull.Value;
                    cdr[8] = DBNull.Value;
                    cdr[9] = DBNull.Value;
                    cdr[10] = DBNull.Value;
                    cdr[11] = DBNull.Value;
                }

                if (cdr[0].ToString() != string.Empty) cdt.Rows.Add(cdr);
            }

            ds.Tables.Add(cdt);


            #endregion


            if (ds.Relations.Count < 1)
                ds.Relations.Add(ds.Tables[ParentTable].Columns[keyColName], ds.Tables[ChildTable].Columns[keyColName]);
        }

        private void PerformDataBind()
        {

            performDetailDataRefine();

            UltraWebGrid1.DataSource = ds.Tables[ParentTable].DefaultView;
            UltraWebGrid1.DataBind();

            if (UltraWebGrid1.Rows.Count < 1)
            {
                UltraWebGrid1.Visible = false;
                lblNoData.Text = "No Data was found!";
                lblNoData.Visible = true;
            }
            else
            {
                lblNoData.Visible = false;
            }


            for (int i = 0; i < UltraWebGrid1.Bands.Count; i++)
            {
                foreach (UltraGridColumn aColumn in this.UltraWebGrid1.Bands[i].Columns)
                {
                    if (aColumn.DataType == "System.DateTime")
                    {
                        aColumn.Format = "MM/dd/yyyy";
                    }
                }
            }


        }

        private void performDetailDataRefine()
        {

            //			int iWeight = 0;
            //			int iOther = 0;
            //			string strHAWB1 = "";
            //			string strHAWB2 = "";
            //
            //			//			DataTable table = new DataTable(ChildTable);
            //
            //			foreach(DataRow eRow in ds.Tables[ChildTable].Rows)
            //			{				
            //				strHAWB1 = eRow["INV"].ToString();
            //				if(strHAWB1 != strHAWB2)
            //				{
            //					iWeight = (int) eRow["a_Rec_count"];
            //					iOther = (int) eRow["b_Rec_count"];
            //				}
            //
            //				if (iWeight == 0)
            //				{
            //					eRow["PCS"] = System.DBNull.Value;
            //					eRow["Unit_of_QTY"] = System.DBNull.Value;
            //					eRow["Gross_Weight"] = System.DBNull.Value;
            //					eRow["Chargeable_Weight"] = System.DBNull.Value;
            //					eRow["Kg_Lb"] = System.DBNull.Value;
            //					eRow["Rate_Charge"] = System.DBNull.Value;
            //					eRow["Total_Charge"] = System.DBNull.Value;
            //				}
            //				else { iWeight--; }
            //				if (iOther == 0)
            //				{
            //					eRow["Other_Charge"] = System.DBNull.Value;
            //				}
            //				else { iOther--; }
            //
            //				strHAWB2 = strHAWB1;
            //			}
            //
        }


        #region Web Form
        override protected void OnInit(EventArgs e)
        {

            InitializeComponent();
            base.OnInit(e);
        }

        private void InitializeComponent()
        {
            this.UltraWebGrid1.PageIndexChanged += new Infragistics.WebUI.UltraWebGrid.PageIndexChangedEventHandler(this.UltraWebGrid1_PageIndexChanged);
            this.UltraWebGrid1.InitializeRow += new Infragistics.WebUI.UltraWebGrid.InitializeRowEventHandler(this.UltraWebGrid1_InitializeRow);

        }
        #endregion

        protected void CheckBox1_CheckedChanged(object sender, System.EventArgs e)
        {
            //if(this.CheckBox1.Checked)
            //{
            //    PerformGroupby();
            //}
            //else
            //{
            //    PerformFlat();
            //}		
            //PerformSearch();
            //PerformDataBind();
        }

        private void PerformFlat()
        {
            UltraWebGrid1.DisplayLayout.HeaderClickActionDefault = HeaderClickAction.Select;
            UltraWebGrid1.DisplayLayout.ViewType = ViewType.Hierarchical;
            UltraWebGrid1.DisplayLayout.AllowSortingDefault = Infragistics.WebUI.UltraWebGrid.AllowSorting.No;
            UltraWebGrid1.DisplayLayout.AllowColumnMovingDefault = Infragistics.WebUI.UltraWebGrid.AllowColumnMoving.None;

            //this.UltraWebToolbar1.Items.FromKeyButton("Asce").Visible = true;
            //this.UltraWebToolbar1.Items.FromKeyButton("Desc").Visible = true;
            //this.UltraWebToolbar1.Items.FromKeyButton("Hide").Visible = true;

            butHideCol.Enabled = true;
            btnSortAsce.Enabled = true;
            this.btnSortDesc.Enabled = true;

        }
        private void PerformGroupby()
        {

            UltraWebGrid1.DisplayLayout.HeaderClickActionDefault = HeaderClickAction.SortMulti;

            UltraWebGrid1.DisplayLayout.CellClickActionDefault = CellClickAction.CellSelect;
            UltraWebGrid1.DisplayLayout.ViewType = Infragistics.WebUI.UltraWebGrid.ViewType.OutlookGroupBy;
            UltraWebGrid1.DisplayLayout.GroupByBox.BandLabelStyle.BackColor = Color.White;

            UltraWebGrid1.DisplayLayout.AllowSortingDefault = Infragistics.WebUI.UltraWebGrid.AllowSorting.Yes;

            UltraWebGrid1.DisplayLayout.GroupByBox.ShowBandLabels = Infragistics.WebUI.UltraWebGrid.ShowBandLabels.IntermediateBandsOnly;
            UltraWebGrid1.DisplayLayout.GroupByBox.Style.BackColor = Color.LightYellow;
            UltraWebGrid1.DisplayLayout.GroupByBox.ButtonConnectorColor = Color.Gray;
            UltraWebGrid1.DisplayLayout.GroupByBox.ButtonConnectorStyle = System.Web.UI.WebControls.BorderStyle.Dotted;

            butHideCol.Enabled = false;
            btnSortAsce.Enabled = false;
            this.btnSortDesc.Enabled = false;

        }

        protected void btnExcel_Click(object sender, System.EventArgs e)
        {
            UltraWebGridExcelExporter1.DownloadName = "ARAging.xls";
            UltraWebGridExcelExporter1.WorksheetName = "Customers";
            UltraWebGridExcelExporter1.Export(UltraWebGrid1);
        }
        protected void UltraWebGridExcelExporter1_CellExported(object sender, Infragistics.WebUI.UltraWebGrid.ExcelExport.CellExportedEventArgs e)
        {
            int rowIndex = e.CurrentRowIndex;
            int colIndex = e.CurrentColumnIndex;
            Infragistics.Documents.Excel.Worksheet workSheet = e.CurrentWorksheet;

            if (workSheet.Rows[rowIndex].Cells[0].Value == null && colIndex != 0 && workSheet.Rows[rowIndex].Cells[colIndex].Value != null)
            {
                workSheet.Rows[rowIndex].Cells[colIndex].Value = workSheet.Rows[rowIndex].Cells[colIndex].Value.ToString();
            }

        }
        protected void btnXML_Click(object sender, System.EventArgs e)
        {

            string tmpLogDir = Request.Cookies["CurrentUserInfo"]["temp_path"];
            string c_strFilePathXSD = tmpLogDir + "/" + Session.SessionID.ToString() + DateTime.Now.Ticks.ToString() + strDefaultXSDFileName;
            string c_strFilePathXML = tmpLogDir + "/" + Session.SessionID.ToString() + DateTime.Now.Ticks.ToString() + strDefaultXMLFileName;
            string c_strFilePathXSDXML = tmpLogDir + "/" + Session.SessionID.ToString() + DateTime.Now.Ticks.ToString() + strDefaultXMLXSDFileName;

            DataSet c_fileDataSet = PerformGetNewdataSet();

            PerformWriteOnlyXML(c_fileDataSet, c_strFilePathXSDXML);
            PerformWriteXML_XSD(c_fileDataSet, c_strFilePathXSD, c_strFilePathXML);

            /// DownLoad XML

            string tmpStr = "../Common/MenuDownLoadXML.aspx?";
            tmpStr += "c_strFilePathXSD=" + c_strFilePathXSD + "&c_strFilePathXML=" + c_strFilePathXML + "&c_strFilePathXSDXML=" + c_strFilePathXSDXML;

            string script = "<script language= javascript>";
            script += "showModalDialog('" + tmpStr + "' ,window,'dialogWidth:300px; dialogHeight:200px; center:yes;center=yes; screenTop=yes; scroll=no; status=no; help=no;');";
            script += "</script>";

            this.ClientScript.RegisterStartupScript(this.GetType(), "DownLoadXM", script);
        }

        protected void btnPDF_Click(object sender, System.EventArgs e)
        {
            string tempFile = Session.SessionID.ToString();
            PerformSearch();
            PerformDataBind();
            LoadReport();
            // rsm.getReportDocument().ExportToHttpResponse(ExportFormatType.PortableDocFormat, Response, true, tempFile);
            // rsm.CloseReportDocumnet();

            Response.Clear();
            Response.Buffer = true;
            Response.ContentType = "application/pdf";
            Response.AddHeader("Content-Type", "application/pdf");
            Response.AddHeader("Content-disposition", "attachment;filename=" + tempFile + ".pdf");

            MemoryStream oStream; // using System.IO
            oStream = (MemoryStream)rsm.getReportDocument().ExportToStream(ExportFormatType.PortableDocFormat);
            rsm.CloseReportDocumnet();
            Response.BinaryWrite(oStream.ToArray());
            Response.Flush();
            Response.End();
        }

        protected void btnDOC_Click(object sender, System.EventArgs e)
        {
            string tempFile = Session.SessionID.ToString();
            PerformSearch();
            PerformDataBind();
            LoadReport();

            Response.Clear();
            Response.Buffer = true;
            Response.ContentType = "application/doc";
            Response.AddHeader("Content-Type", "application/doc");
            Response.AddHeader("Content-disposition", "attachment;filename=" + tempFile + ".doc");

            MemoryStream oStream; // using System.IO
            oStream = (MemoryStream)rsm.getReportDocument().ExportToStream(ExportFormatType.WordForWindows);
            rsm.CloseReportDocumnet();
            Response.BinaryWrite(oStream.ToArray());
            Response.Flush();
            Response.End();
        }

        protected void Button1_Click(object sender, System.EventArgs e)
        {
            int a = int.Parse(ViewState["Count"].ToString());
            string script = "<script language='javascript'>";

            script += "if(history.length >= " + a.ToString() + ")";
            script += "{ history.go(-" + a.ToString() + "); }";
            script += "else{location.replace('ARAgingSelection.aspx')}";
            script += "</script>";
            this.ClientScript.RegisterStartupScript(this.GetType(), "Pre", script);
        }

        protected void btnPrint_Click(object sender, System.EventArgs e)
        {
            // You can change if you want to write Schema and XML separately. 
            // string strMode = "Write_Schema_XML"; 
            string strMode = "";

            string tmpLogDir = Request.Cookies["CurrentUserInfo"]["temp_path"];
            string c_strFilePathXSD = tmpLogDir + "/" + Session.SessionID.ToString() + DateTime.Now.Ticks.ToString() + strDefaultXSDFileName;
            string c_strFilePathXML = tmpLogDir + "/" + Session.SessionID.ToString() + DateTime.Now.Ticks.ToString() + strDefaultXMLFileName;
            string c_strFilePathXSDXML = tmpLogDir + "/" + Session.SessionID.ToString() + DateTime.Now.Ticks.ToString() + strDefaultXMLXSDFileName;

            DataSet c_fileDataSet = PerformGetNewdataSet();

            if (strMode == "Write_Schema_XML")
            {
                PerformWriteOnlyXML(c_fileDataSet, c_strFilePathXSDXML);
                string tmpStr = string.Format("c_strFilePathXSDXML={0}&defaultReportForm={1}", c_strFilePathXSDXML, defaultReportForm);
                Response.Redirect("../Common/PrintReport.aspx?" + tmpStr);
            }
            else
            {
                PerformWriteXML_XSD(c_fileDataSet, c_strFilePathXSD, c_strFilePathXML);
                string tmpStr = string.Format("c_strFilePathXSD={0}&c_strFilePathXML={1}&defaultReportForm={2}", c_strFilePathXSD, c_strFilePathXML, defaultReportForm);
                Response.Redirect("../Common/PrintReport.aspx?" + tmpStr);
            }
        }

        private DataSet PerformGetNewdataSet()
        {
            int iCnt;

            DataSet c_fileDataSet = new DataSet(dsXMLName);

            PerformSearch();

            for (int iB = 0; iB < this.UltraWebGrid1.Bands.Count; iB++)
            {
                DataTable table = new DataTable(ds.Tables[UltraWebGrid1.DisplayLayout.Bands[iB].Key].ToString());

                for (int i = 0; i < this.UltraWebGrid1.DisplayLayout.Bands[iB].Columns.Count; i++)
                {
                    string colName = UltraWebGrid1.DisplayLayout.Bands[iB].Columns[i].BaseColumnName.ToString();
                    if (UltraWebGrid1.DisplayLayout.Bands[iB].Columns[i].Hidden != true || colName == keyColName)
                    {
                        table.Columns.Add(UltraWebGrid1.Bands[iB].Columns[i].BaseColumnName.ToString(), Type.GetType(UltraWebGrid1.Bands[iB].Columns[i].DataType));
                    }
                }

                foreach (DataRow eRow in ds.Tables[UltraWebGrid1.DisplayLayout.Bands[iB].Key].Rows)
                {
                    DataRow aRow = table.NewRow();
                    iCnt = 0;
                    for (int j = 0; j < this.UltraWebGrid1.DisplayLayout.Bands[iB].Columns.Count; j++)
                    {
                        string colName = UltraWebGrid1.DisplayLayout.Bands[iB].Columns[j].BaseColumnName.ToString();
                        if (UltraWebGrid1.DisplayLayout.Bands[iB].Columns[j].Hidden != true || colName == keyColName)
                        {
                            aRow[iCnt] = eRow[j];
                            iCnt += 1;
                        }
                    }
                    table.Rows.Add(aRow);
                }

                c_fileDataSet.Tables.Add(table);
            }

            if (c_fileDataSet.Relations.Count < 1 && UltraWebGrid1.Bands.Count > 1)
                c_fileDataSet.Relations.Add(c_fileDataSet.Tables[ParentTable].Columns[keyColName], c_fileDataSet.Tables[ChildTable].Columns[keyColName]);


            return c_fileDataSet;

        }

        private void PerformWriteOnlyXML(DataSet c_fileDataSet, string c_strFilePathXSDXML)
        {
            StreamWriter XMLStreamWriter = new StreamWriter(c_strFilePathXSDXML);
            c_fileDataSet.WriteXml(XMLStreamWriter, System.Data.XmlWriteMode.WriteSchema);
            XMLStreamWriter.Flush();
            XMLStreamWriter.Close();
        }

        private void PerformWriteXML_XSD(DataSet c_fileDataSet, string c_strFilePathXSD, string c_strFilePathXML)
        {
            StreamWriter XSDStreamWriter = new StreamWriter(c_strFilePathXSD);
            c_fileDataSet.WriteXmlSchema(XSDStreamWriter);
            XSDStreamWriter.Flush();
            XSDStreamWriter.Close();

            StreamWriter XMLStreamWriter = new StreamWriter(c_strFilePathXML);
            c_fileDataSet.WriteXml(XMLStreamWriter);
            XMLStreamWriter.Flush();
            XMLStreamWriter.Close();
        }

        protected void radMulti_CheckedChanged(object sender, System.EventArgs e)
        {
            if (radMulti.Checked == true)
            {
                this.UltraWebGrid1.DisplayLayout.Pager.AllowPaging = true;
                this.UltraWebGrid1.DisplayLayout.Pager.Alignment = Infragistics.WebUI.UltraWebGrid.PagerAlignment.Center;
                this.UltraWebGrid1.DisplayLayout.Pager.PagerAppearance = Infragistics.WebUI.UltraWebGrid.PagerAppearance.Top;
                this.UltraWebGrid1.DisplayLayout.Pager.StyleMode = Infragistics.WebUI.UltraWebGrid.PagerStyleMode.Numeric;

                this.UltraWebGrid1.DisplayLayout.Pager.PageSize = 30;
                CheckBox1.Enabled = false;
                PerformFlat();
                PerformSearch();
                PerformDataBind();
            }
        }

        protected void radSingle_CheckedChanged(object sender, System.EventArgs e)
        {
            if (radSingle.Checked)
            {
                this.UltraWebGrid1.DisplayLayout.Pager.AllowPaging = false;
                CheckBox1.Enabled = true;
                PerformSearch();
                PerformDataBind();
            }
        }

        protected void butHideCol_Click(object sender, System.EventArgs e)
        {

            for (int iB = 0; iB < this.UltraWebGrid1.Bands.Count; iB++)
            {
                for (int i = 0; i < UltraWebGrid1.Bands[iB].Columns.Count; i++)
                {
                    if (UltraWebGrid1.Bands[iB].Columns[i].Selected)
                    {
                        UltraWebGrid1.Bands[iB].Columns[i].Hidden = true;
                        UltraWebGrid1.Bands[iB].Columns[i].Selected = false;
                    }
                }
            }

        }

        protected void btnSortAsce_Click(object sender, System.EventArgs e)
        {

            for (int iB = 0; iB < this.UltraWebGrid1.DisplayLayout.Bands.Count; iB++)
            {
                UltraGridBand band = this.UltraWebGrid1.DisplayLayout.Bands[iB];
                band.SortedColumns.Clear(); // 2005.8.4

                if (UltraWebGrid1.DisplayLayout.SelectedColumns.Count > 0 || band.SortedColumns.Count > 0)
                {

                    for (int i = 0; i < band.Columns.Count; i++)
                    {
                        if (band.Columns[i].Selected)
                        {
                            band.Columns[i].SortIndicator = SortIndicator.Ascending;
                            band.SortedColumns.Add(UltraWebGrid1.Bands[iB].Columns[i]);
                            break; // 2005.8.4
                        }
                    }
                }
            }

            PerformSearch();
            this.PerformDataBind();

        }

        protected void btnSortDesc_Click(object sender, System.EventArgs e)
        {

            for (int iB = 0; iB < this.UltraWebGrid1.DisplayLayout.Bands.Count; iB++)
            {
                UltraGridBand band = this.UltraWebGrid1.DisplayLayout.Bands[iB];
                band.SortedColumns.Clear(); // 2005.8.4

                if (UltraWebGrid1.DisplayLayout.SelectedColumns.Count > 0 || band.SortedColumns.Count > 0)
                {
                    for (int i = 0; i < band.Columns.Count; i++)
                    {
                        if (band.Columns[i].Selected)
                        {
                            band.Columns[i].SortIndicator = SortIndicator.Descending;
                            band.SortedColumns.Add(UltraWebGrid1.Bands[iB].Columns[i]);
                            break; // 2005.8.4
                        }
                    }
                }
            }
            PerformSearch();
            this.PerformDataBind();
        }


        protected void btnReset_Click(object sender, System.EventArgs e)
        {
            UltraWebGrid1.ResetColumns();
            UltraWebGrid1.ResetBands();
            PerformSearch();
            PerformDataBind();
        }


        private void UltraWebGrid1_PageIndexChanged(object sender, Infragistics.WebUI.UltraWebGrid.PageEventArgs e)
        {
            UltraWebGrid1.DisplayLayout.Pager.CurrentPageIndex = e.NewPageIndex;
            PerformSearch();
            PerformDataBind();

        }

        protected void UltraWebGrid1_InitializeLayout1(object sender, LayoutEventArgs e)
        {
            e.Layout.SelectTypeColDefault = SelectType.Single;
            e.Layout.SelectTypeRowDefault = SelectType.Extended;

            e.Layout.ViewType = ViewType.Hierarchical;
            e.Layout.TableLayout = TableLayout.Fixed;
            e.Layout.RowStyleDefault.BorderDetails.ColorTop = Color.Gray;

            // if (CheckBox1.Checked && radSingle.Checked) PerformGroupby();

            e.Layout.RowSelectorsDefault = RowSelectors.No;

            for (int i = 0; i < UltraWebGrid1.Bands.Count; i++)
            {
                for (int j = 0; j < UltraWebGrid1.Bands[i].Columns.Count; j++)
                {
                    UltraWebGrid1.DisplayLayout.Bands[i].Columns[j].SelectedCellStyle.BackColor = Color.FromArgb(73, 30, 138);
                    UltraWebGrid1.DisplayLayout.Bands[i].Columns[j].SelectedCellStyle.ForeColor = Color.WhiteSmoke;
                }
            }

            UltraWebGrid1.DisplayLayout.SelectedHeaderStyleDefault.BackColor = Color.Red;
            UltraWebGrid1.DisplayLayout.SelectTypeCellDefault = Infragistics.WebUI.UltraWebGrid.SelectType.Single;
            UltraWebGrid1.DisplayLayout.AllowColSizingDefault = Infragistics.WebUI.UltraWebGrid.AllowSizing.Free;

            // set cursor 
            UltraWebGrid1.DisplayLayout.FrameStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Default;
            UltraWebGrid1.DisplayLayout.Bands[0].HeaderStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Default;

            UltraWebGrid1.DisplayLayout.SelectedHeaderStyleDefault.BackColor = Color.Red;

            UltraWebGrid1.Bands[0].DataKeyField = ds.Tables[ParentTable].Columns[keyColName].ColumnName;
            UltraWebGrid1.Bands[1].DataKeyField = ds.Tables[ChildTable].Columns[keyColName].ColumnName;

            e.Layout.Bands[1].Columns.FromKey("Due Date").CellStyle.BackColor = Color.LightGreen;
            e.Layout.Bands[1].Columns.FromKey("Aging").CellStyle.BackColor = Color.LightYellow;
            e.Layout.Bands[1].Columns.FromKey("Open Balance").CellStyle.BackColor = Color.LightYellow;
            e.Layout.Bands[1].Columns.FromKey("Total").CellStyle.BackColor = Color.LightGoldenrodYellow;

            e.Layout.Bands[0].Columns.FromKey("Company Name").Move(0);
            e.Layout.Bands[0].Columns.FromKey("Company Name").Width = new Unit("413px");
            e.Layout.Bands[0].Columns.FromKey("Company Name No").Hidden = true;
            e.Layout.Bands[0].Columns.FromKey("Company Name No").Width = new Unit("0px");

            e.Layout.Bands[0].Columns.FromKey("Phone").Move(1);
            e.Layout.Bands[0].Columns.FromKey("Phone").Width = new Unit("180px");
            e.Layout.Bands[0].Columns.FromKey("Credit").Hidden = true;

            e.Layout.Bands[1].Columns.FromKey("Company Name No").Width = new Unit("0px");
            e.Layout.Bands[1].Columns.FromKey("Company Name No").Hidden = true;
            e.Layout.Bands[1].Columns.FromKey("Company Name").Width = new Unit("0px");
            e.Layout.Bands[1].Columns.FromKey("Company Name").Hidden = true;

            e.Layout.Bands[1].Columns.FromKey("Type").Width = new Unit("51px");
            e.Layout.Bands[1].Columns.FromKey("I/V Date").Width = new Unit("65px");
            e.Layout.Bands[1].Columns.FromKey("I/V No.").Width = new Unit("50px");
            e.Layout.Bands[1].Columns.FromKey("House No.").Width = new Unit("80px");
            e.Layout.Bands[1].Columns.FromKey("House Type").Width = new Unit("0px");
            e.Layout.Bands[1].Columns.FromKey("House Type").Hidden = true;
            e.Layout.Bands[1].Columns.FromKey("Ref No.").Hidden = false;
            e.Layout.Bands[1].Columns.FromKey("Due Date").Width = new Unit("65px");
            e.Layout.Bands[1].Columns.FromKey("Term").Width = new Unit("50px");
            e.Layout.Bands[1].Columns.FromKey("Aging").Width = new Unit("50px");
            e.Layout.Bands[1].Columns.FromKey("Open Balance").Width = new Unit("70px");

            UltraWebGrid1.DisplayLayout.ColFootersVisibleDefault = ShowMarginInfo.Yes;
            UltraWebGrid1.DisplayLayout.FooterStyleDefault.Height = 20;

            e.Layout.Bands[1].Columns.FromKey("I/V Date").Format = "MM/dd/yyyy";
            e.Layout.Bands[1].Columns.FromKey("Due Date").Format = "MM/dd/yyyy";

            e.Layout.Bands[1].Columns.FromKey("Aging").Footer.Caption = "Total";
            e.Layout.Bands[1].Columns.FromKey("Aging").Footer.Style.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[0].FooterStyle.BackColor = Color.Yellow;
            e.Layout.Bands[1].FooterStyle.BackColor = Color.LightGoldenrodYellow;

            e.Layout.Bands[0].Columns.FromKey("Current").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[0].Columns.FromKey("Current").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[0].Columns.FromKey("Current").FooterTotal = Infragistics.WebUI.UltraWebGrid.SummaryInfo.Sum;
            e.Layout.Bands[0].Columns.FromKey("Current").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[0].Columns.FromKey("Current").Width = new Unit("80px");

            e.Layout.Bands[0].Columns.FromKey("1~30").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[0].Columns.FromKey("1~30").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[0].Columns.FromKey("1~30").FooterTotal = Infragistics.WebUI.UltraWebGrid.SummaryInfo.Sum;
            e.Layout.Bands[0].Columns.FromKey("1~30").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[0].Columns.FromKey("1~30").Width = new Unit("80px");

            e.Layout.Bands[0].Columns.FromKey("31~60").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[0].Columns.FromKey("31~60").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[0].Columns.FromKey("31~60").FooterTotal = Infragistics.WebUI.UltraWebGrid.SummaryInfo.Sum;
            e.Layout.Bands[0].Columns.FromKey("31~60").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[0].Columns.FromKey("31~60").Width = new Unit("80px");

            e.Layout.Bands[0].Columns.FromKey("61~90").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[0].Columns.FromKey("61~90").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[0].Columns.FromKey("61~90").FooterTotal = Infragistics.WebUI.UltraWebGrid.SummaryInfo.Sum;
            e.Layout.Bands[0].Columns.FromKey("61~90").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[0].Columns.FromKey("61~90").Width = new Unit("80px");

            e.Layout.Bands[0].Columns.FromKey("+90").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[0].Columns.FromKey("+90").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[0].Columns.FromKey("+90").FooterTotal = Infragistics.WebUI.UltraWebGrid.SummaryInfo.Sum;
            e.Layout.Bands[0].Columns.FromKey("+90").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[0].Columns.FromKey("+90").Width = new Unit("80px");

            e.Layout.Bands[0].Columns.FromKey("Total").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[0].Columns.FromKey("Total").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[0].Columns.FromKey("Total").FooterTotal = Infragistics.WebUI.UltraWebGrid.SummaryInfo.Sum;
            e.Layout.Bands[0].Columns.FromKey("Total").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[0].Columns.FromKey("Total").Width = new Unit("80px");

            e.Layout.Bands[1].Columns.FromKey("Term").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[1].Columns.FromKey("Aging").CellStyle.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[1].Columns.FromKey("Open Balance").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[1].Columns.FromKey("Open Balance").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[1].Columns.FromKey("Open Balance").FooterTotal = Infragistics.WebUI.UltraWebGrid.SummaryInfo.Sum;
            e.Layout.Bands[1].Columns.FromKey("Open Balance").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[1].Columns.FromKey("Open Balance").Width = new Unit("80px");

            e.Layout.Bands[1].Columns.FromKey("Current").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[1].Columns.FromKey("Current").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[1].Columns.FromKey("Current").FooterTotal = Infragistics.WebUI.UltraWebGrid.SummaryInfo.Sum;
            e.Layout.Bands[1].Columns.FromKey("Current").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[1].Columns.FromKey("Current").Width = new Unit("80px");

            e.Layout.Bands[1].Columns.FromKey("1~30").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[1].Columns.FromKey("1~30").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[1].Columns.FromKey("1~30").FooterTotal = Infragistics.WebUI.UltraWebGrid.SummaryInfo.Sum;
            e.Layout.Bands[1].Columns.FromKey("1~30").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[1].Columns.FromKey("1~30").Width = new Unit("80px");

            e.Layout.Bands[1].Columns.FromKey("31~60").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[1].Columns.FromKey("31~60").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[1].Columns.FromKey("31~60").FooterTotal = Infragistics.WebUI.UltraWebGrid.SummaryInfo.Sum;
            e.Layout.Bands[1].Columns.FromKey("31~60").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[1].Columns.FromKey("31~60").Width = new Unit("80px");

            e.Layout.Bands[1].Columns.FromKey("61~90").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[1].Columns.FromKey("61~90").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[1].Columns.FromKey("61~90").FooterTotal = Infragistics.WebUI.UltraWebGrid.SummaryInfo.Sum;
            e.Layout.Bands[1].Columns.FromKey("61~90").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[1].Columns.FromKey("61~90").Width = new Unit("80px");

            e.Layout.Bands[1].Columns.FromKey("+90").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[1].Columns.FromKey("+90").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[1].Columns.FromKey("+90").FooterTotal = Infragistics.WebUI.UltraWebGrid.SummaryInfo.Sum;
            e.Layout.Bands[1].Columns.FromKey("+90").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[1].Columns.FromKey("+90").Width = new Unit("80px");

            e.Layout.Bands[1].Columns.FromKey("Total").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[1].Columns.FromKey("Total").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[1].Columns.FromKey("Total").FooterTotal = Infragistics.WebUI.UltraWebGrid.SummaryInfo.Sum;
            e.Layout.Bands[1].Columns.FromKey("Total").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[1].Columns.FromKey("Total").Width = new Unit("80px");

        }
        protected void UltraWebGrid1_InitializeRow(object sender, RowEventArgs e)
        {
            string s = "";
            if (e.Row.Band.BaseTableName == ChildTable)
            {
                string sType = e.Row.Cells.FromKey("Type").Value.ToString();

                if (sType == "GJE")
                {
                    e.Row.Cells.FromKey("I/V No.").TargetURL = "javascript:goFindURL('" + sType + "','" + e.Row.Cells.FromKey("House No.").Value + "','" + e.Row.Cells.FromKey("Ref No.").Value + "')";
                }
                else
                {
                    e.Row.Cells.FromKey("I/V No.").TargetURL = "javascript:goFindURL('" + sType + "','" + e.Row.Cells.FromKey("House No.").Value + "','" + e.Row.Cells.FromKey("I/V No.").Value + "')";
                }

                e.Row.Cells.FromKey("House No.").TargetURL = "javascript:goFindURL('" + e.Row.Cells.FromKey("House Type").Value + "','" + e.Row.Cells.FromKey("House No.").Value + "','" + e.Row.Cells.FromKey("I/V No.").Value + "')";

            }
            if (e.Row.Band.BaseTableName == ParentTable)
            {
                e.Row.Cells.FromKey("Company Name").TargetURL = "javascript:viewPop('/IFF_MAIN/ASP/master_data/client_profile.asp?n=" + e.Row.Cells.FromKey("Company Name No").Value + "')";
            }
        }
        protected void btnExcelExport_Click(object sender, ImageClickEventArgs e)
        {
            UltraWebGridExcelExporter1.DownloadName = "ARAging.xls";
            UltraWebGridExcelExporter1.WorksheetName = "Customers";
            UltraWebGridExcelExporter1.Export(UltraWebGrid1);
        }
        protected void btnPDF_Click1(object sender, ImageClickEventArgs e)
        {
            string tempFile = Session.SessionID.ToString();
            PerformSearch();
            PerformDataBind();
            LoadReport();
            // rsm.getReportDocument().ExportToHttpResponse(ExportFormatType.PortableDocFormat, Response, true, tempFile);
            // rsm.CloseReportDocumnet();

            Response.Clear();
            Response.Buffer = true;
            Response.ContentType = "application/pdf";
            Response.AddHeader("Content-Type", "application/pdf");
            Response.AddHeader("Content-disposition", "attachment;filename=" + tempFile + ".pdf");

            MemoryStream oStream; // using System.IO
            oStream = (MemoryStream)rsm.getReportDocument().ExportToStream(ExportFormatType.PortableDocFormat);
            rsm.CloseReportDocumnet();
            Response.BinaryWrite(oStream.ToArray());
            Response.Flush();
            Response.End();
        }
}
}
























