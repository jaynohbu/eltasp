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
using System.Data.SqlClient;
using System.IO;
using System.Configuration;
using Infragistics.WebUI.UltraWebGrid;
using CrystalDecisions.Shared;

namespace IFF_MAIN.ASPX.Reports.Accounting
{
    public partial class APAgingDetail : System.Web.UI.Page
    {
        protected System.Web.UI.WebControls.Button butShowCols;
        //***********************************************************//
        protected string ParentTable = "AP";
        protected string ChildTable = "APDETAIL";
        protected string keyColName = "vendor_number";
        protected string dsXMLName = "AP";
        protected string sHeaderName = "APAgingSUMMARY";
        protected string sDetailName = "APAgingSUMMARYDETAIL";
        protected string defaultReportForm = "bill.rpt";
        protected string strDefaultXSDFileName = "AP.XSD";
        protected string strDefaultXMLFileName = "AP.XML";
        protected string strDefaultXMLXSDFileName = "APALL.XML";
        protected string ParentPage = "APAgingSelection.aspx";
        public string elt_account_number;
        public string user_id;
        protected string strUserRight;
        protected string strBranch;
        protected string strCompany;
        protected string ConnectStr;
        protected string vType="";
        protected string xType="";
        protected string vNum="";
        protected string IDNum="";
        protected string md;
        protected DataSet ds = new DataSet();
        protected DataTable dt = new DataTable();
        protected DataTable cdt = new DataTable();
        static public string windowName;

        protected void Page_Load(object sender, System.EventArgs e)
        {
            Session.LCID = 1033;
            windowName = Request.QueryString["WindowName"];
            elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];

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

        private void PrepReportDS()
        {
            string asOf = Session["AsOf"].ToString();
            string branchName = Session["Branch_Name"].ToString();
            string branchCode = Session["Branch_Code"].ToString();
            string login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
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

        protected ReportSourceManager rsm = null;

        private void LoadReport()
        {
            PrepReportDS();
            rsm = new ReportSourceManager();
            try
            {
                rsm.LoadDataSet(ds);
                rsm.WriteXSD(Server.MapPath("../../../CrystalReportResources/xsd/APaging.xsd"));
                rsm.BindNow(Server.MapPath("../../../CrystalReportResources/rpt/APaging.rpt"));
                /*
                ReportDocument rd;
                ds.WriteXmlSchema(Server.MapPath("../../../CrystalReportResources/xsd/ARaging.xsd"));                         
                rd = new ReportDocument();
                rd.Load(Server.MapPath("../../../CrystalReportResources/rpt/APAging.rpt"));
                rd.SetDataSource(ds);
                    rd.ExportToDisk(ExportFormatType.PortableDocFormat, Server.MapPath("../../../Temp/" + Session["Branch_Code"].ToString() + "_APAging.pdf"));
                    rd.ExportToDisk(ExportFormatType.WordForWindows, Server.MapPath("../../../Temp/" + Session["Branch_Code"].ToString() + "_APAging.doc"));
                 */
            }
            catch (Exception e)
            {
                Response.Write(e.ToString());
                Response.End();
            }
        }


        private void PerformSearch()
        {
            string[] str = new string[7];
            string strCommandText, strCommandTextU;
            string strlblBranch;

            strCommandText = Session["strCommandText"].ToString();
            strCommandTextU = Session["strCommandTextU"].ToString();
            strlblBranch = Session["strlblBranch"].ToString();
            strBranch = Session["strBranch"].ToString();

            str[0] = Session["Accounting_sPeriod"].ToString();
            str[1] = Session["Accounting_sBranchName"] .ToString();
            str[2] = Session["Accounting_sBranch_elt_account_number"] .ToString();
            str[3] = Session["Accounting_sCompanName"] .ToString();

            for (int i = 0; i < str.Length - 1; i++)
            {
                if (str[i + 1] != "") str[i] = str[i] + "/";
            }

            Label2.Text = string.Format("<FONT color='navy' size='1pt'>{0} {1} {2} {3}</FONT>", str[0], str[1], str[2], str[3]);

            if (strCommandText == "") Response.Redirect(ParentPage);

            dt.TableName = ParentTable;
            cdt.TableName = ChildTable;

            dt.Columns.Add(new DataColumn("vendor_name", typeof(string)));
            dt.Columns.Add(new DataColumn("Current", typeof(System.Decimal)));
            dt.Columns.Add(new DataColumn("1~30", typeof(System.Decimal)));
            dt.Columns.Add(new DataColumn("31~60", typeof(System.Decimal)));
            dt.Columns.Add(new DataColumn("61~90", typeof(System.Decimal)));
            dt.Columns.Add(new DataColumn("+90", typeof(System.Decimal)));
            dt.Columns.Add(new DataColumn("Total", typeof(System.Decimal)));
            dt.Columns.Add(new DataColumn(keyColName, typeof(string)));
            dt.Columns.Add(new DataColumn("telephone", typeof(string)));

            cdt.Columns.Add(new DataColumn("vendor_name", typeof(string)));
            cdt.Columns.Add(new DataColumn("Type", typeof(string)));
            cdt.Columns.Add(new DataColumn("Date", typeof(System.DateTime)));
            cdt.Columns.Add(new DataColumn("Doc.No.", typeof(string)));
            cdt.Columns.Add(new DataColumn("Ref No.", typeof(string)));
            cdt.Columns.Add(new DataColumn("Due Date", typeof(System.DateTime)));
            cdt.Columns.Add(new DataColumn("Aging", typeof(string)));
            cdt.Columns.Add(new DataColumn("Open Balance", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("Current", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("1~30", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("31~60", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("61~90", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("+90", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("Total", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("Link", typeof(string)));
            cdt.Columns.Add(new DataColumn(keyColName, typeof(string)));
            cdt.Columns.Add(new DataColumn("File No.", typeof(string)));

            PerformGetAPData(strCommandText, strBranch);
            if (strCommandTextU.Trim() != "")
            {
                Label1.Text = "A/P Aging ( Include Unposted Transactions )";
                PerformGetAPDataU(strCommandTextU, strBranch);
                DataTable tmpDt = new DataTable();
                DataRow tmpDr;
                tmpDt = dt.Clone();

                string uniqName = "", vendorNum = "";
                string expr = "";
                double Total_0, Total_1, Total_2, Total_3, Total_4, Total_5;

                foreach (DataRow eRow in dt.Select("", "vendor_name," + keyColName))
                {

                    if (vendorNum != eRow[keyColName].ToString())
                    {
                        uniqName = eRow["vendor_name"].ToString();
                        vendorNum = eRow["vendor_number"].ToString();

                        Total_0 = Total_1 = Total_2 = Total_3 = Total_4 = Total_5 = 0;
                        expr = keyColName + "=" + vendorNum;
                        try
                        {
                            foreach (DataRow eeRow in dt.Select(expr, "vendor_name," + keyColName))
                            {
                                Total_0 = Total_0 + double.Parse(eeRow[1].ToString());
                                Total_1 = Total_1 + double.Parse(eeRow[2].ToString());
                                Total_2 = Total_2 + double.Parse(eeRow[3].ToString());
                                Total_3 = Total_3 + double.Parse(eeRow[4].ToString());
                                Total_4 = Total_4 + double.Parse(eeRow[5].ToString());
                                Total_5 = Total_5 + double.Parse(eeRow[6].ToString());
                            }
                            tmpDr = tmpDt.NewRow();
                            tmpDr[0] = uniqName;
                            tmpDr[1] = Total_0;
                            tmpDr[2] = Total_1;
                            tmpDr[3] = Total_2;
                            tmpDr[4] = Total_3;
                            tmpDr[5] = Total_4;
                            tmpDr[6] = Total_5;
                            tmpDr[7] = vendorNum;
                            tmpDr[8] = eRow["telephone"].ToString();
                            tmpDt.Rows.Add(tmpDr);
                        }catch
                        {
                            Response.Write("Source Count:" + dt.Rows.Count + "<br>");
                            Response.Write("VendorNum:" + vendorNum + "<br>");
                            Response.Write("VebdorCursor:" + eRow[keyColName].ToString() + "<br>");
                            Response.Write("SQL:" + strCommandTextU);
                            Response.End();
                        }
                    }
                }
                tmpDt.TableName = ParentTable;
                ds.Tables.Add(tmpDt);
            }
            else
            {
                ds.Tables.Add(dt);
            }

            DataTable tmpcDt = new DataTable();
            DataRow tmpcDr;
            tmpcDt = cdt.Clone();

            foreach (DataRow eRow in cdt.Select("", keyColName + ",Date"))
            {
                tmpcDr = tmpcDt.NewRow();
                for (int i = 0; i < eRow.ItemArray.Length; i++)
                {
                    tmpcDr[i] = eRow[i];
                }
                tmpcDt.Rows.Add(tmpcDr);
            }

            tmpcDt.TableName = ChildTable;
            ds.Tables.Add(tmpcDt);

            /*
             * Testing for bug by Joon */
            //ArrayList tempList = new ArrayList();
            //for (int tv = 0; tv < ds.Tables[ChildTable].Rows.Count; tv++)
            //{
            //    bool found = true;

            //    string tempVendorNum = ds.Tables[ChildTable].Rows[tv][keyColName].ToString();
            //    for (int tvr = 0; tvr < ds.Tables[ParentTable].Rows.Count; tvr++)
            //    {
            //        found = false;
            //        string tempChildVendorNum = ds.Tables[ParentTable].Rows[tvr][keyColName].ToString();
            //        if (tempVendorNum == tempChildVendorNum)
            //        {
            //            tvr = ds.Tables[ParentTable].Rows.Count;
            //            found = true;
            //        }
            //    }
            //    if (found == false)
            //    {
            //        tempList.Add(tempVendorNum);
            //    }
            //}

            DataColumn[] parentDataCols = new DataColumn[2];
            DataColumn[] childDataCols = new DataColumn[2];

            parentDataCols[0] = ds.Tables[ParentTable].Columns[keyColName];
            parentDataCols[1] = ds.Tables[ParentTable].Columns["vendor_name"];

            childDataCols[0] = ds.Tables[ChildTable].Columns[keyColName];
            childDataCols[1] = ds.Tables[ChildTable].Columns["vendor_name"];

            if (ds.Relations.Count < 1)
                ds.Relations.Add(parentDataCols, childDataCols);
        }

        private void PerformGetAPData(string strCommandText, string strBranch)
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

            string vLastVnum = "", vLastName = "", cName = "", cVnum = "";

            int tIndex = 0;
            int bIndex = 0;

            // DataTable schemaTable = reader.GetSchemaTable().Rows.Count;
            // int iCount = reader.GetSchemaTable().Rows.Count;

            int iCount = 0;
            while (reader.Read()) { iCount++; };
            reader.Close();

            string[,] aField = new string[9, iCount];
            string[,] bField = new string[17, iCount];

            reader = Cmd.ExecuteReader();

            while (reader.Read())
            {
                #region // Parent logic

                if (cName == null)
                {
                    cName = "";
                }

                cName = reader["vendor_name"].ToString().Trim().Replace("'", "`");
                cVnum = reader["vendor_number"].ToString();
                
                if (bIndex == 0)
                {
                    vLastName = cName;
                    vLastVnum = cVnum;
                }

                if (vLastVnum != cVnum)
                {
                    aField[0, tIndex] = vLastName;
                    aField[1, tIndex] = sTotalCurrent.ToString();
                    aField[2, tIndex] = sTotal1_30.ToString();
                    aField[3, tIndex] = sTotal31_60.ToString();
                    aField[4, tIndex] = sTotal61_90.ToString();
                    aField[5, tIndex] = sTotal91.ToString();
                    aField[6, tIndex] = sTotal.ToString();
                    aField[7, tIndex] = vLastVnum;
                    aField[8, tIndex] = reader["business_phone"].ToString();

                    vLastName = cName;
                    vLastVnum = cVnum;
                    tIndex += 1;
                    sTotalCurrent = 0;
                    sTotal1_30 = 0;
                    sTotal31_60 = 0;
                    sTotal61_90 = 0;
                    sTotal91 = 0;
                    sTotal = 0;
                }

                string vBillType = reader["bill_type"].ToString();

                DateTime vBillDate = DateTime.Parse(reader["bill_due_date"].ToString());
                double vBalance = double.Parse(reader["bill_amt_due"].ToString());

                // DateTime d1 = DateTime.Now;
                DateTime d1 = DateTime.Parse(Session["AsOf"].ToString());

                TimeSpan vAging = d1 - vBillDate;

                if (vAging.Days <= 0)
                {
                    sTotalCurrent = sTotalCurrent + vBalance;
                    sTotal = sTotal + vBalance;
                }
                else if (vAging.Days > 0 && vAging.Days < 31)
                {
                    sTotal1_30 = sTotal1_30 + vBalance;
                    sTotal = sTotal + vBalance;
                }
                else if (vAging.Days > 30 && vAging.Days < 61)
                {
                    sTotal31_60 = sTotal31_60 + vBalance;
                    sTotal = sTotal + vBalance;
                }
                else if (vAging.Days > 60 && vAging.Days < 91)
                {
                    sTotal61_90 = sTotal61_90 + vBalance;
                    sTotal = sTotal + vBalance;
                }
                else if (vAging.Days > 90)
                {
                    sTotal91 = sTotal91 + vBalance;
                    sTotal = sTotal + vBalance;
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
                    aField[7, tIndex] = cVnum;
                    aField[8, tIndex] = reader["business_phone"].ToString();

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
                bField[2, bIndex] = vBillDate.ToShortDateString();
                bField[3, bIndex] = reader["bill_number"].ToString();
                bField[4, bIndex] = reader["ref_no"].ToString();
                bField[5, bIndex] = ((DateTime)(vBillDate)).ToShortDateString();
                if (vAging.Days > 0)
                {
                    bField[6, bIndex] = vAging.Days.ToString();
                }

                bField[7, bIndex] = vBalance.ToString();

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
                bField[15, bIndex] = cVnum;
                bField[16, bIndex] = reader["ref_no_Our"].ToString();

                switch (vBillType)
                {
                    case "G":
                        bField[1, bIndex] = "GJE";
                        break;
                    default:
                        bField[1, bIndex] = "BILL";
                        break;
                }
                if (elt_account_number == reader["elt_account_number"].ToString())
                {
                    bField[14, bIndex] = "javascript:goFindURL('"
                        + bField[1, bIndex] + "','" + bField[3, bIndex]
                        + "','" + bField[4, bIndex] + "','" + vType + "','"
                        + xType + "','" + IDNum + "','" + cVnum
                        + "','" + md + "')";

                    vNum = "";
                    cVnum = "";
                    vType = "";
                    xType = "";
                    md = "";
                    IDNum = "";
                }

                bIndex += 1;
            }

            reader.Close();

            Con.Close();

            // DataTable

            #region // Parent table

            DataRow dr;

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
                if (dr[0].ToString() != string.Empty) dt.Rows.Add(dr);
            }

            #endregion

            # region // Child table

            DataRow cdr;

            for (int i = 0; i < bIndex; i++)
            {
                if (bField[0, i] == null) break;

                cdr = cdt.NewRow();

                cdr[0] = bField[0, i];
                cdr[1] = bField[1, i];
                cdr[2] = DateTime.Parse(bField[2, i]);
                cdr[3] = bField[3, i];
                cdr[4] = bField[4, i];
                cdr[5] = DateTime.Parse(bField[5, i]);
                cdr[6] = bField[6, i];
                cdr[7] = bField[7, i];
                cdr[8] = bField[8, i];
                cdr[9] = bField[9, i];
                cdr[10] = bField[10, i];
                cdr[11] = bField[11, i];
                cdr[12] = bField[12, i];
                cdr[13] = bField[13, i];
                cdr[14] = bField[14, i];
                cdr[15] = bField[15, i];
                cdr[16] = bField[16, i];
                if (cdr[0].ToString() != string.Empty) cdt.Rows.Add(cdr);
            }

            #endregion

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

        private void PerformGetAPDataU(string strCommandText, string strBranch)
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

            string vLastVnum = "", vLastName = "", cName = "", cVnum = "";
            int tIndex = 0;
            int bIndex = 0;
            int bIndexAdjuster = 0;
            int iCount = 0;
            while (reader.Read()) { iCount++; };
            reader.Close();

            string[,] aField = new string[9, iCount];
            string[,] bField = new string[17, iCount];

            reader = Cmd.ExecuteReader();

            while (reader.Read())
            {
                #region // Parent logic
                cName = reader["vendor_name"].ToString().Trim().Replace("'", "`");
                cVnum = reader["vendor_number"].ToString();

                if (cName == "")
                {
                    bIndexAdjuster += 1;
                    continue;
                }

                if (bIndex == 0)
                {
                    vLastName = cName;
                    vLastVnum = cVnum;
                }

                if (cVnum != vLastVnum)
                {
                    aField[0, tIndex] = vLastName;
                    aField[1, tIndex] = sTotalCurrent.ToString();
                    aField[2, tIndex] = sTotal1_30.ToString();
                    aField[3, tIndex] = sTotal31_60.ToString();
                    aField[4, tIndex] = sTotal61_90.ToString();
                    aField[5, tIndex] = sTotal91.ToString();
                    aField[6, tIndex] = sTotal.ToString();
                    aField[7, tIndex] = vLastVnum;
                    aField[8, tIndex] = reader["business_phone"].ToString();

                    vLastName = cName;
                    vLastVnum = cVnum;
                    tIndex += 1;
                    sTotalCurrent = 0;
                    sTotal1_30 = 0;
                    sTotal31_60 = 0;
                    sTotal61_90 = 0;
                    sTotal91 = 0;
                    sTotal = 0;
                }

                DateTime vBillDate = DateTime.Parse(reader["tran_date"].ToString());
                double vBalance = double.Parse(reader["item_amt"].ToString());

                DateTime d1 = DateTime.Now;
                TimeSpan vAging = d1 - vBillDate;

                if (vAging.Days <= 0)
                {
                    sTotalCurrent = sTotalCurrent + vBalance;
                    sTotal = sTotal + vBalance;
                }
                else if (vAging.Days > 0 && vAging.Days < 31)
                {
                    sTotal1_30 = sTotal1_30 + vBalance;
                    sTotal = sTotal + vBalance;
                }
                else if (vAging.Days > 30 && vAging.Days < 61)
                {
                    sTotal31_60 = sTotal31_60 + vBalance;
                    sTotal = sTotal + vBalance;
                }
                else if (vAging.Days > 60 && vAging.Days < 91)
                {
                    sTotal61_90 = sTotal61_90 + vBalance;
                    sTotal = sTotal + vBalance;
                }
                else if (vAging.Days > 90)
                {
                    sTotal91 = sTotal91 + vBalance;
                    sTotal = sTotal + vBalance;
                }

                if ((bIndex + bIndexAdjuster + 1) >= iCount)  // end of reader
                {
                    aField[0, tIndex] = cName;
                    aField[1, tIndex] = sTotalCurrent.ToString();
                    aField[2, tIndex] = sTotal1_30.ToString();
                    aField[3, tIndex] = sTotal31_60.ToString();
                    aField[4, tIndex] = sTotal61_90.ToString();
                    aField[5, tIndex] = sTotal91.ToString();
                    aField[6, tIndex] = sTotal.ToString();
                    aField[7, tIndex] = cVnum;
                    aField[8, tIndex] = reader["business_phone"].ToString();
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
                bField[14, bIndex] = cVnum;
                bField[2, bIndex] = vBillDate.ToShortDateString();
                bField[3, bIndex] = reader["invoice_no"].ToString();

                if (reader["invoice_no"].ToString() == "0")
                {
                }

                bField[5, bIndex] = ((DateTime)(vBillDate)).ToShortDateString();

                if (vAging.Days > 0)
                {
                    bField[5, bIndex] = vAging.Days.ToString();
                }

                bField[6, bIndex] = vBalance.ToString();

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

                bField[7, bIndex] = sCurrent.ToString();
                bField[8, bIndex] = s1_30.ToString();
                bField[9, bIndex] = s31_60.ToString();
                bField[10, bIndex] = s61_90.ToString();
                bField[11, bIndex] = s91.ToString();
                bField[12, bIndex] = sSubTotal.ToString();

                bField[1, bIndex] = "INV";
                string import_export = reader["import_export"].ToString();
                string air_ocean = reader["itype"].ToString();

                if (air_ocean == "A" && import_export == "I")
                {
                    vType = "AI";
                    bField[1, bIndex] = "ARN";
                }
                if (air_ocean == "O" && import_export == "I")
                {
                    vType = "OI";
                    bField[1, bIndex] = "ARN";
                }

                if (reader["invoice_no"].ToString() == "0")
                {

                    bField[3, bIndex] = reader["agent_debit_no"].ToString();
                    md = reader["mb_no"].ToString();
                    if (reader["itype"].ToString() == "A" && reader["agent_debit_no"].ToString() != "")
                    {
                        xType = "A";

                        bField[1, bIndex] = "ADN";
                        bField[4, bIndex] = reader["ref_no"].ToString();
                    }
                    else if (reader["itype"].ToString() == "O" && reader["agent_debit_no"].ToString() != "")
                    {
                        xType = "O";
                        bField[1, bIndex] = "ADN";
                        bField[4, bIndex] = reader["ref_no"].ToString();
                    }
                    else
                    {
                        bField[3, bIndex] = "Direct Entry";
                        vNum = reader["vendor_number"].ToString();
                        IDNum = reader["item_id"].ToString();
                    }
                }
                else
                {
                    bField[16, bIndex] = reader["ref_no_Our"].ToString();
                }

                if (elt_account_number == reader["elt_account_number"].ToString())
                {
                    bField[15, bIndex] = "javascript:goFindURL('"
                        + bField[1, bIndex] + "','" + bField[3, bIndex]
                        + "','" + bField[4, bIndex] + "','" + vType + "','"
                        + xType + "','" + IDNum + "','" + vNum + "','" + md + "')";

                    vNum = "";
                    cVnum = "";
                    vType = "";
                    xType = "";
                    md = "";
                    IDNum = "";
                }

                bIndex += 1;
            }

            reader.Close();

            Con.Close();


            #region // Parent table
            DataRow dr;

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

                if (dr[0].ToString() != string.Empty) dt.Rows.Add(dr);
            }

            #endregion

            # region // Child table
            DataRow cdr;

            for (int i = 0; i < bIndex; i++)
            {
                if (bField[0, i] == null) break;

                cdr = cdt.NewRow();

                cdr[0] = bField[0, i];
                cdr[1] = bField[1, i];
                cdr[2] = bField[2, i];
                cdr[3] = bField[3, i];
                cdr[4] = bField[4, i];
                cdr[5] = System.DBNull.Value;
                cdr[6] = bField[5, i];
                cdr[7] = bField[6, i];
                cdr[8] = bField[7, i];
                cdr[9] = bField[8, i];
                cdr[10] = bField[9, i];
                cdr[11] = bField[10, i];
                cdr[12] = bField[11, i];
                cdr[13] = bField[12, i];
                cdr[14] = bField[15, i];
                cdr[15] = bField[14, i];
                cdr[16] = bField[16, i];

                if (cdr[0].ToString() != string.Empty) cdt.Rows.Add(cdr);
            }

            #endregion

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
            //				strHAWB1 = eRow["bill"].ToString();
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


        override protected void OnInit(EventArgs e)
        {
            InitializeComponent();
            base.OnInit(e);
        }


        private void InitializeComponent()
        {
            this.UltraWebGrid1.InitializeRow += new Infragistics.WebUI.UltraWebGrid.InitializeRowEventHandler(this.UltraWebGrid1_InitializeRow);
            this.UltraWebGrid1.PageIndexChanged += new Infragistics.WebUI.UltraWebGrid.PageIndexChangedEventHandler(this.UltraWebGrid1_PageIndexChanged);
        }

        protected void CheckBox1_CheckedChanged(object sender, System.EventArgs e)
        {
            if (this.CheckBox1.Checked)
            {
                PerformGroupby();
            }
            else
            {
                PerformFlat();
            }
            PerformSearch();
            PerformDataBind();
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

            //this.UltraWebToolbar1.Items.FromKeyButton("Asce").Visible = false;
            //this.UltraWebToolbar1.Items.FromKeyButton("Desc").Visible = false;
            //this.UltraWebToolbar1.Items.FromKeyButton("Hide").Visible = false;

            butHideCol.Enabled = false;
            btnSortAsce.Enabled = false;
            this.btnSortDesc.Enabled = false;

        }

        protected void btnExcel_Click(object sender, System.EventArgs e)
        {
            this.UltraWebGridExcelExporter1.DownloadName = "APAging.xls";
            this.UltraWebGridExcelExporter1.Export(this.UltraWebGrid1);

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

        protected void Button1_Click(object sender, System.EventArgs e)
        {
            int a = int.Parse(ViewState["Count"].ToString());
            string script = "<script language='javascript'>";

            script += "if(history.length >= " + a.ToString() + ")";
            script += "{ history.go(-" + a.ToString() + "); }";
            script += "else{location.replace('APAgingSelection.aspx')}";
            script += "</script>";
            this.ClientScript.RegisterStartupScript(this.GetType(), "Pre", script);
        }

        protected void btnPDF_Click(object sender, System.EventArgs e)
        {
            string tempFile = Session.SessionID.ToString();
            PerformSearch();
            PerformDataBind();
            LoadReport();
            //rsm.getReportDocument().ExportToHttpResponse(ExportFormatType.PortableDocFormat, Response, true, tempFile);
            //rsm.CloseReportDocumnet();

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
            //rsm.getReportDocument().ExportToHttpResponse(ExportFormatType.WordForWindows, Response, true, tempFile);
            //rsm.CloseReportDocumnet();

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

        protected void btnPrint_Click(object sender, System.EventArgs e)
        {
            // string strMode = "Write_Schema_XML"; // You can change if you want to write Schema and XML separately. 
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
                        if (colName == "Link") continue;
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
                            if (colName == "Link") continue;
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

            if (this.CheckBox1.Checked)
            {
                PerformGroupby();
            }
            else
            {
                PerformFlat();
            }
        }

        private void UltraWebGrid1_PageIndexChanged(object sender, Infragistics.WebUI.UltraWebGrid.PageEventArgs e)
        {
            UltraWebGrid1.DisplayLayout.Pager.CurrentPageIndex = e.NewPageIndex;
            PerformSearch();
            PerformDataBind();

        }

        private void UltraWebGrid1_InitializeRow(object sender, Infragistics.WebUI.UltraWebGrid.RowEventArgs e)
        {
            if (e.Row.Band.BaseTableName == ChildTable)
            {
                e.Row.Cells.FromKey("Doc.No.").TargetURL = e.Row.Cells.FromKey("Link").Text;
            }

            if (e.Row.Band.BaseTableName == ParentTable)
            {
                e.Row.Cells.FromKey("vendor_name").TargetURL = "javascript:viewPop('/ASP/master_data/client_profile.asp?n=" + e.Row.Cells.FromKey("vendor_number").Value + "')";
            }
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

        protected void UltraWebGrid1_InitializeLayout1(object sender, LayoutEventArgs e)
        {
            e.Layout.SelectTypeColDefault = SelectType.Single;
            e.Layout.SelectTypeRowDefault = SelectType.Extended;

            e.Layout.ViewType = ViewType.Hierarchical;
            e.Layout.TableLayout = TableLayout.Fixed;
            e.Layout.RowStyleDefault.BorderDetails.ColorTop = Color.Gray;

            this.PerformFlat();

            for (int i = 0; i < UltraWebGrid1.Bands.Count; i++)
            {
                for (int j = 0; j < UltraWebGrid1.Bands[i].Columns.Count; j++)
                {
                    UltraWebGrid1.DisplayLayout.Bands[i].Columns[j].SelectedCellStyle.BackColor = Color.FromArgb(73, 30, 138);
                    UltraWebGrid1.DisplayLayout.Bands[i].Columns[j].SelectedCellStyle.ForeColor = Color.WhiteSmoke;
                }
            }

            e.Layout.Bands[1].Columns.FromKey("Link").Hidden = true;

            //UltraWebGrid1.Bands[0].RowStyle.BackColor = Color.White;
            //UltraWebGrid1.Bands[1].RowStyle.BackColor = Color.White;


            UltraWebGrid1.DisplayLayout.SelectedHeaderStyleDefault.BackColor = Color.Red;
            UltraWebGrid1.DisplayLayout.SelectTypeCellDefault = Infragistics.WebUI.UltraWebGrid.SelectType.Single;
            UltraWebGrid1.DisplayLayout.AllowColSizingDefault = Infragistics.WebUI.UltraWebGrid.AllowSizing.Free;

            //set cursor 
            UltraWebGrid1.DisplayLayout.FrameStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Default;
            UltraWebGrid1.DisplayLayout.Bands[0].HeaderStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Default;

            UltraWebGrid1.DisplayLayout.SelectedHeaderStyleDefault.BackColor = Color.Red;

            UltraWebGrid1.Bands[0].DataKeyField = ds.Tables[ParentTable].Columns["vendor_name"].ColumnName;
            UltraWebGrid1.Bands[1].DataKeyField = ds.Tables[ChildTable].Columns["vendor_name"].ColumnName;

            e.Layout.Bands[1].Columns.FromKey("Due Date").CellStyle.BackColor = Color.LightGreen;
            e.Layout.Bands[1].Columns.FromKey("Aging").CellStyle.BackColor = Color.LightYellow;
            e.Layout.Bands[1].Columns.FromKey("Open Balance").CellStyle.BackColor = Color.LightYellow;
            e.Layout.Bands[1].Columns.FromKey("Total").CellStyle.BackColor = Color.LightGoldenrodYellow;

            e.Layout.Bands[0].Columns.FromKey("vendor_name").Width = new Unit("472px");
            e.Layout.Bands[0].Columns.FromKey("telephone").Width = new Unit("100px");

            UltraWebGrid1.DisplayLayout.RowSelectorsDefault = Infragistics.WebUI.UltraWebGrid.RowSelectors.No;
            e.Layout.Bands[1].Columns.FromKey("vendor_name").Hidden = true;
            e.Layout.Bands[1].Columns.FromKey("Type").Width = new Unit("40px");
            e.Layout.Bands[1].Columns.FromKey("Date").Width = new Unit("70px");
            e.Layout.Bands[1].Columns.FromKey("Doc.No.").Width = new Unit("70px");
            e.Layout.Bands[1].Columns.FromKey("Ref No.").Width = new Unit("70px");
            e.Layout.Bands[1].Columns.FromKey("File No.").Width = new Unit("80px");
            e.Layout.Bands[1].Columns.FromKey("Due Date").Width = new Unit("70px");
            e.Layout.Bands[1].Columns.FromKey("Aging").Width = new Unit("70px");
            e.Layout.Bands[1].Columns.FromKey("Open Balance").Width = new Unit("80px");


            e.Layout.Bands[1].Columns.FromKey("vendor_name").Header.Caption = "";

            UltraWebGrid1.DisplayLayout.ColFootersVisibleDefault = ShowMarginInfo.Yes;
            UltraWebGrid1.DisplayLayout.FooterStyleDefault.Height = 20;

            //            e.Layout.Bands[0].Columns[7].Footer.Style.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[1].Columns.FromKey("Aging").Footer.Caption = "Total";
            e.Layout.Bands[1].Columns.FromKey("Aging").Footer.Style.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[0].FooterStyle.BackColor = Color.Yellow;
            e.Layout.Bands[1].FooterStyle.BackColor = Color.LightGoldenrodYellow;

            e.Layout.Bands[1].Columns.FromKey("Date").Format = "MM/dd/yyyy";
            e.Layout.Bands[1].Columns.FromKey("Due Date").Format = "MM/dd/yyyy";

            e.Layout.Bands[0].Columns.FromKey("Current").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[0].Columns.FromKey("Current").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[0].Columns.FromKey("Current").FooterTotal = Infragistics.WebUI.UltraWebGrid.SummaryInfo.Sum;
            e.Layout.Bands[0].Columns.FromKey("Current").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[0].Columns.FromKey("1~30").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[0].Columns.FromKey("1~30").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[0].Columns.FromKey("1~30").FooterTotal = Infragistics.WebUI.UltraWebGrid.SummaryInfo.Sum;
            e.Layout.Bands[0].Columns.FromKey("1~30").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[0].Columns.FromKey("31~60").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[0].Columns.FromKey("31~60").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[0].Columns.FromKey("31~60").FooterTotal = Infragistics.WebUI.UltraWebGrid.SummaryInfo.Sum;
            e.Layout.Bands[0].Columns.FromKey("31~60").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[0].Columns.FromKey("61~90").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[0].Columns.FromKey("61~90").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[0].Columns.FromKey("61~90").FooterTotal = Infragistics.WebUI.UltraWebGrid.SummaryInfo.Sum;
            e.Layout.Bands[0].Columns.FromKey("61~90").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[0].Columns.FromKey("+90").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[0].Columns.FromKey("+90").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[0].Columns.FromKey("+90").FooterTotal = Infragistics.WebUI.UltraWebGrid.SummaryInfo.Sum;
            e.Layout.Bands[0].Columns.FromKey("+90").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[0].Columns.FromKey("Total").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[0].Columns.FromKey("Total").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[0].Columns.FromKey("Total").FooterTotal = Infragistics.WebUI.UltraWebGrid.SummaryInfo.Sum;
            e.Layout.Bands[0].Columns.FromKey("Total").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[1].Columns.FromKey("Aging").CellStyle.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[1].Columns.FromKey("Open Balance").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[1].Columns.FromKey("Open Balance").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[1].Columns.FromKey("Open Balance").FooterTotal = Infragistics.WebUI.UltraWebGrid.SummaryInfo.Sum;
            e.Layout.Bands[1].Columns.FromKey("Open Balance").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[0].Columns.FromKey("telephone").Move(1);
            e.Layout.Bands[1].Columns.FromKey("File No.").Move(3);

            e.Layout.Bands[1].Columns.FromKey("Current").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[1].Columns.FromKey("Current").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[1].Columns.FromKey("Current").FooterTotal = Infragistics.WebUI.UltraWebGrid.SummaryInfo.Sum;
            e.Layout.Bands[1].Columns.FromKey("Current").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[1].Columns.FromKey("1~30").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[1].Columns.FromKey("1~30").Format = "###,###,##0.00;(###,###,###.00); ";
            e.Layout.Bands[1].Columns.FromKey("1~30").FooterTotal = Infragistics.WebUI.UltraWebGrid.SummaryInfo.Sum;
            e.Layout.Bands[1].Columns.FromKey("1~30").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[1].Columns.FromKey("31~60").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[1].Columns.FromKey("31~60").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[1].Columns.FromKey("31~60").FooterTotal = Infragistics.WebUI.UltraWebGrid.SummaryInfo.Sum;
            e.Layout.Bands[1].Columns.FromKey("31~60").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[1].Columns.FromKey("61~90").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[1].Columns.FromKey("61~90").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[1].Columns.FromKey("61~90").FooterTotal = Infragistics.WebUI.UltraWebGrid.SummaryInfo.Sum;
            e.Layout.Bands[1].Columns.FromKey("61~90").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[1].Columns.FromKey("+90").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[1].Columns.FromKey("+90").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[1].Columns.FromKey("+90").FooterTotal = Infragistics.WebUI.UltraWebGrid.SummaryInfo.Sum;
            e.Layout.Bands[1].Columns.FromKey("+90").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[1].Columns.FromKey("Total").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[1].Columns.FromKey("Total").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[1].Columns.FromKey("Total").FooterTotal = Infragistics.WebUI.UltraWebGrid.SummaryInfo.Sum;
            e.Layout.Bands[1].Columns.FromKey("Total").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[0].Columns.FromKey(keyColName).Hidden = true;
            e.Layout.Bands[1].Columns.FromKey(keyColName).Hidden = true;
        }
        protected void btnExcelExport_Click(object sender, ImageClickEventArgs e)
        {
            this.UltraWebGridExcelExporter1.DownloadName = "APAging.xls";
            this.UltraWebGridExcelExporter1.Export(this.UltraWebGrid1);
        }
        protected void btnPDF_Click1(object sender, ImageClickEventArgs e)
        {
            string tempFile = Session.SessionID.ToString();
            PerformSearch();
            PerformDataBind();
            LoadReport();
            //rsm.getReportDocument().ExportToHttpResponse(ExportFormatType.PortableDocFormat, Response, true, tempFile);
            //rsm.CloseReportDocumnet();

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