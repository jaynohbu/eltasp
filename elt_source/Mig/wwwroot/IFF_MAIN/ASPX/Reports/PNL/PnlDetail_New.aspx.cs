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
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;

namespace IFF_MAIN.ASPX.Reports.PNL
{
    /// <summary>
    /// AccountingDetail에 대한 요약 설명입니다.
    /// </summary>
    public partial class PnlDetail : System.Web.UI.Page
    {
        protected System.Web.UI.WebControls.Button butShowCols;
        protected ReportDocument rd;
        protected string ConnectStr;
        protected DataSet ds = new DataSet();
        static public string windowName;
        static public string strResultStyle;
        protected DataSet dsPNL;
        protected DataTable dtParent;
        protected DataTable dtChild;
        protected string grp;
        int selectedCase;
        Hashtable hashGroupCaption;
       
        protected void Page_Load(object sender, System.EventArgs e)
        {
            Hashtable hashGroupCaption = new Hashtable();
           
            selectedCase = 0;
            Session.LCID = 1033;
            windowName = Request.QueryString["WindowName"];
            dsPNL = new DataSet();
            DataTable dtFinalResult=((DataTable)Session["dtFinalResult"]);
            grp = "";

            DataView dv=new DataView(dtFinalResult);
            dv.Sort = "date_exec asc";
        
            dsPNL = new DataSet();
            if (!IsPostBack)
            {
                rebind();
            }
            else
            {

            }
        }

        #region Web Form 디자이너에서 생성한 코드
        override protected void OnInit(EventArgs e)
        {
            //
            // CODEGEN: 이 호출은 ASP.NET Web Form 디자이너에 필요합니다.
            //
            InitializeComponent();
            base.OnInit(e);
        }

        /// <summary>
        /// 디자이너 지원에 필요한 메서드입니다.
        /// 이 메서드의 내용을 코드 편집기로 수정하지 마십시오.
        /// </summary>
        private void InitializeComponent()
        {
        }
        #endregion

        public DataTable createTable()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add(new DataColumn("KeyField", System.Type.GetType("System.String")));            
            dt.Columns.Add(new DataColumn("charge", System.Type.GetType("System.Decimal")));
            dt.Columns.Add(new DataColumn("cost", System.Type.GetType("System.Decimal")));
            dt.Columns.Add(new DataColumn("Profit", System.Type.GetType("System.Decimal")));
            return dt;
        }

        private void PrepReportDS()
        {            
            string branchName = Request.Cookies["CurrentUserInfo"]["company_name"];
            string branchCode = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
            string user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
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
                DataColumn dc_branch_name = new DataColumn("Branch_Name");
                DataColumn dc_branch_code = new DataColumn("Branch_Code");
                DataColumn user_full_name = new DataColumn("User_FullName");
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
                dt.Columns.Add(new DataColumn("period_start"));
                dt.Columns.Add(new DataColumn("period_end"));
                dt.Columns.Add(new DataColumn("group"));
                dt.Columns.Add(new DataColumn("GrandTotalCharge"));
                dt.Columns.Add(new DataColumn("GrandTotalCost"));
                dt.Columns.Add(new DataColumn("GrandTotalProfit"));
                reader.Close();

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
                aRow["period_start"] = Session["period_start"].ToString().Replace("'","");
                aRow["period_end"] = Session["period_end"].ToString().Replace("'", "");
                string group = "";

                switch (this.ddlSumBy.SelectedIndex)
                {
                    case 1: break;
                    case 2: group = "Master Bill Number"; break;
                    case 3: group = "File Number"; break;
                    case 4: group = "Reference"; break;
                    case 5: group = "Year"; break;
                    case 6: group = "Month"; break;
                    default: group = "Customer"; break;
                }

                aRow["group"] = group;
                dtParent = (DataTable)Session["dtParent"];
                aRow["GrandTotalCharge"] = dtParent.Rows[dtParent.Rows.Count-1]["charge"].ToString();
                aRow["GrandTotalCost"] = dtParent.Rows[dtParent.Rows.Count-1]["cost"].ToString();
                aRow["GrandTotalProfit"] = dtParent.Rows[dtParent.Rows.Count-1]["Profit"].ToString();
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

            if (dsPNL != null && dt != null && !dsPNL.Tables.Contains(dt.TableName))
            {
                dsPNL.Tables.Add(dt);
            }
        }

        protected ReportSourceManager rsm = null;

        private void LoadReport()
        {
            PrepReportDS();
            rsm = new ReportSourceManager();

            dtParent =(DataTable)Session["dtParent"];
            dtChild = (DataTable)Session["dtChild"];

            DataTable dtXSDParent = dtParent.Copy();
            dtXSDParent.Rows.Remove(dtXSDParent.Rows[dtXSDParent.Rows.Count-1]);
            DataTable dtXSDChild = dtChild.Copy();
            dtXSDParent.TableName="Parent";
            dtXSDChild.TableName= "Child";
            dsPNL.Tables.Add(dtXSDParent);
            dsPNL.Tables.Add(dtXSDChild);
            dsPNL.Relations.Add(dtXSDParent.Columns["KeyField"], dtXSDChild.Columns["KeyField"]);

            try
            {
                rsm.LoadDataSet(dsPNL);
                rsm.WriteXSD(Server.MapPath("../../../CrystalReportResources/xsd/pnlNew.xsd"));
                rsm.BindNow(Server.MapPath("../../../CrystalReportResources/rpt/PNL_NEW.rpt"));

            }
            catch (Exception e)
            {
                Response.Write(e.ToString());
                Response.End();
            }
            
        }



        protected void ddlSumBy_SelectedIndexChanged(object sender, EventArgs e)
        {
            rebind();  
        }
        protected void rebind()
        {
            hashGroupCaption = new Hashtable();
            DataTable dtFinalResult = ((DataTable)Session["dtFinalResult"]);
            if (dtFinalResult.Rows.Count > 0)
            {
                DataView dv = new DataView(dtFinalResult);
                double grandTotalCost = 0;
                double grandTotalCharge = 0;
                double grandTotalProfit = 0;
                hashGroupCaption.Add("customer", "For Customer: ");
                hashGroupCaption.Add("mawb_num", "For Master Bill: ");
                hashGroupCaption.Add("file_no", "For File No.: ");
                hashGroupCaption.Add("ref_no", "For Reference No.: ");
                hashGroupCaption.Add("date_exec_year", "For Year: ");
                hashGroupCaption.Add("date_exec_moth", "For Month");

                switch (this.ddlSumBy.SelectedIndex)
                {
                    case 1: dv.Sort = "customer,date_exec,mawb_num asc"; selectedCase = 1; grp = "customer"; break;
                    case 2: dv.Sort = "mawb_num,date_exec,mawb_num asc"; selectedCase = 2; grp = "mawb_num"; break;
                    case 3: dv.Sort = "file_no,date_exec,mawb_num asc"; selectedCase = 3; grp = "file_no"; break;
                    case 4: dv.Sort = "ref_no,date_exec,mawb_num asc"; selectedCase = 4; grp = "ref_no"; break;
                    case 5: dv.Sort = "date_exec,mawb_num,customer asc"; selectedCase = 5; grp = "date_exec_year"; break;
                    case 6: dv.Sort = "date_exec,mawb_num,customer asc"; selectedCase = 6; grp = "date_exec_moth"; break;

                    default: dv.Sort = "customer,date_exec,mawb_num asc"; selectedCase = 1; grp = "customer"; break;
                }

                if (selectedCase == 1)
                {
                    dtParent = createTable();
                    dtFinalResult = dv.ToTable();
                    dtChild = dtFinalResult.Copy();
                    dtChild.Columns.Add(new DataColumn("KeyField", System.Type.GetType("System.String")));
                    dtChild.Columns.Add(new DataColumn("Profit", System.Type.GetType("System.Decimal")));
                    string current = dtFinalResult.Rows[0]["customer"].ToString();

                    double total_cst = 0;
                    double total_chg = 0;
                    double total_profit = 0;

                    for (int i = 0; i < dtFinalResult.Rows.Count; i++)
                    {
                        dtChild.Rows[i]["KeyField"] = dtFinalResult.Rows[i]["customer"].ToString();

                        dtChild.Rows[i]["Profit"] = Double.Parse(dtFinalResult.Rows[i]["charge"].ToString()) - Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                        grandTotalCost += Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                        grandTotalCharge += Double.Parse(dtFinalResult.Rows[i]["charge"].ToString());
                        grandTotalProfit += Double.Parse(dtFinalResult.Rows[i]["charge"].ToString()) - Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());

                        if (dtFinalResult.Rows[i]["customer"].ToString() == current && i != (dtFinalResult.Rows.Count - 1))
                        {
                            total_cst += Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                            total_chg += Double.Parse(dtFinalResult.Rows[i]["charge"].ToString());
                            total_profit += Double.Parse(dtFinalResult.Rows[i]["charge"].ToString()) - Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                        }
                        else if (dtFinalResult.Rows[i]["customer"].ToString() != current && i != (dtFinalResult.Rows.Count - 1))
                        {
                            //-----------------------------------
                            dtParent.Rows.Add(dtParent.NewRow());
                            dtParent.Rows[dtParent.Rows.Count - 1]["KeyField"] = current;
                            dtParent.Rows[dtParent.Rows.Count - 1]["cost"] = total_cst;
                            dtParent.Rows[dtParent.Rows.Count - 1]["charge"] = total_chg;
                            dtParent.Rows[dtParent.Rows.Count - 1]["Profit"] = total_profit;
                            //-----------------------------------                    

                            current = dtFinalResult.Rows[i]["customer"].ToString();

                            total_cst = Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                            total_chg = Double.Parse(dtFinalResult.Rows[i]["charge"].ToString());
                            total_profit = Double.Parse(dtFinalResult.Rows[i]["charge"].ToString()) - Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());

                        }


                        if (i == dtFinalResult.Rows.Count - 1)
                        {
                            if (dtFinalResult.Rows[i]["customer"].ToString() == current)
                            {

                                total_cst += Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                                total_chg += Double.Parse(dtFinalResult.Rows[i]["charge"].ToString());
                                total_profit += Double.Parse(dtFinalResult.Rows[i]["charge"].ToString()) - Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                                //-----------------------------------
                                dtParent.Rows.Add(dtParent.NewRow());
                                dtParent.Rows[dtParent.Rows.Count - 1]["KeyField"] = current;
                                dtParent.Rows[dtParent.Rows.Count - 1]["cost"] = total_cst;
                                dtParent.Rows[dtParent.Rows.Count - 1]["charge"] = total_chg;
                                dtParent.Rows[dtParent.Rows.Count - 1]["Profit"] = total_profit;
                                //-----------------------------------

                            }
                            else
                            {
                                //-----------------------------------
                                dtParent.Rows.Add(dtParent.NewRow());
                                dtParent.Rows[dtParent.Rows.Count - 1]["KeyField"] = current;
                                dtParent.Rows[dtParent.Rows.Count - 1]["cost"] = total_cst;
                                dtParent.Rows[dtParent.Rows.Count - 1]["charge"] = total_chg;
                                dtParent.Rows[dtParent.Rows.Count - 1]["Profit"] = total_profit;
                                //-----------------------------------

                                total_cst = Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                                total_chg = Double.Parse(dtFinalResult.Rows[i]["charge"].ToString());
                                total_profit = Double.Parse(dtFinalResult.Rows[i]["charge"].ToString()) - Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                                //-----------------------------------
                                dtParent.Rows.Add(dtParent.NewRow());
                                dtParent.Rows[dtParent.Rows.Count - 1]["KeyField"] = dtFinalResult.Rows[i]["customer"].ToString();
                                dtParent.Rows[dtParent.Rows.Count - 1]["cost"] = total_cst;
                                dtParent.Rows[dtParent.Rows.Count - 1]["charge"] = total_chg;
                                dtParent.Rows[dtParent.Rows.Count - 1]["Profit"] = total_profit;
                                //-----------------------------------
                            }
                        }
                    }
                }
                else if (selectedCase == 2)
                {
                    dtParent = createTable();
                    dtFinalResult = dv.ToTable();
                    dtChild = dtFinalResult.Copy();
                    dtChild.Columns.Add(new DataColumn("KeyField", System.Type.GetType("System.String")));
                    dtChild.Columns.Add(new DataColumn("Profit", System.Type.GetType("System.Decimal")));
                    string current = dtFinalResult.Rows[0]["mawb_num"].ToString();
                    double total_cst = 0;
                    double total_chg = 0;
                    double total_profit = 0;
                    for (int i = 0; i < dtFinalResult.Rows.Count; i++)
                    {
                        dtChild.Rows[i]["Profit"] = Double.Parse(dtFinalResult.Rows[i]["charge"].ToString()) - Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                        grandTotalCost += Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                        grandTotalCharge += Double.Parse(dtFinalResult.Rows[i]["charge"].ToString());
                        grandTotalProfit += Double.Parse(dtFinalResult.Rows[i]["charge"].ToString()) - Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());

                        dtChild.Rows[i]["KeyField"] = dtFinalResult.Rows[i]["mawb_num"].ToString();

                        if (dtFinalResult.Rows[i]["mawb_num"].ToString() == current && i != (dtFinalResult.Rows.Count - 1))
                        {
                            total_cst += Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                            total_chg += Double.Parse(dtFinalResult.Rows[i]["charge"].ToString());
                            total_profit += Double.Parse(dtFinalResult.Rows[i]["charge"].ToString()) - Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                        }
                        else if (dtFinalResult.Rows[i]["mawb_num"].ToString() != current && i != (dtFinalResult.Rows.Count - 1))
                        {
                            //-----------------------------------
                            dtParent.Rows.Add(dtParent.NewRow());
                            dtParent.Rows[dtParent.Rows.Count - 1]["KeyField"] = current;
                            dtParent.Rows[dtParent.Rows.Count - 1]["cost"] = total_cst;
                            dtParent.Rows[dtParent.Rows.Count - 1]["charge"] = total_chg;
                            dtParent.Rows[dtParent.Rows.Count - 1]["Profit"] = total_profit;
                            //-----------------------------------
                            current = dtFinalResult.Rows[i]["mawb_num"].ToString();

                            total_cst = Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                            total_chg = Double.Parse(dtFinalResult.Rows[i]["charge"].ToString());
                            total_profit = Double.Parse(dtFinalResult.Rows[i]["charge"].ToString()) - Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());

                        }


                        if (i == dtFinalResult.Rows.Count - 1)
                        {
                            if (dtFinalResult.Rows[i]["mawb_num"].ToString() == current)
                            {
                                total_cst += Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                                total_chg += Double.Parse(dtFinalResult.Rows[i]["charge"].ToString());
                                total_profit += Double.Parse(dtFinalResult.Rows[i]["charge"].ToString()) - Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                                //-----------------------------------
                                dtParent.Rows.Add(dtParent.NewRow());
                                dtParent.Rows[dtParent.Rows.Count - 1]["KeyField"] = current;
                                dtParent.Rows[dtParent.Rows.Count - 1]["cost"] = total_cst;
                                dtParent.Rows[dtParent.Rows.Count - 1]["charge"] = total_chg;
                                dtParent.Rows[dtParent.Rows.Count - 1]["Profit"] = total_profit;
                                //-----------------------------------
                            }
                            else
                            {
                                //-----------------------------------
                                dtParent.Rows.Add(dtParent.NewRow());
                                dtParent.Rows[dtParent.Rows.Count - 1]["KeyField"] = current;
                                dtParent.Rows[dtParent.Rows.Count - 1]["cost"] = total_cst;
                                dtParent.Rows[dtParent.Rows.Count - 1]["charge"] = total_chg;
                                dtParent.Rows[dtParent.Rows.Count - 1]["Profit"] = total_profit;
                                //-----------------------------------

                                total_cst = Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                                total_chg = Double.Parse(dtFinalResult.Rows[i]["charge"].ToString());
                                total_profit = Double.Parse(dtFinalResult.Rows[i]["charge"].ToString()) - Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());

                                //-----------------------------------
                                dtParent.Rows.Add(dtParent.NewRow());
                                dtParent.Rows[dtParent.Rows.Count - 1]["KeyField"] = dtFinalResult.Rows[i]["mawb_num"].ToString();
                                dtParent.Rows[dtParent.Rows.Count - 1]["cost"] = total_cst;
                                dtParent.Rows[dtParent.Rows.Count - 1]["charge"] = total_chg;
                                dtParent.Rows[dtParent.Rows.Count - 1]["Profit"] = total_profit;
                                //-----------------------------------                          
                            }
                        }
                    }
                }
                else if (selectedCase == 3)
                {
                    dtParent = createTable();
                    dtFinalResult = dv.ToTable();
                    dtChild = dtFinalResult.Copy();
                    dtChild.Columns.Add(new DataColumn("KeyField", System.Type.GetType("System.String")));
                    dtChild.Columns.Add(new DataColumn("Profit", System.Type.GetType("System.Decimal")));
                    string current = dtFinalResult.Rows[0]["file_no"].ToString();
                    double total_cst = 0;
                    double total_chg = 0;
                    double total_profit = 0;
                    for (int i = 0; i < dtFinalResult.Rows.Count; i++)
                    {
                        dtChild.Rows[i]["Profit"] = Double.Parse(dtFinalResult.Rows[i]["charge"].ToString()) - Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                        grandTotalCost += Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                        grandTotalCharge += Double.Parse(dtFinalResult.Rows[i]["charge"].ToString());
                        grandTotalProfit += Double.Parse(dtFinalResult.Rows[i]["charge"].ToString()) - Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());

                        dtChild.Rows[i]["KeyField"] = dtFinalResult.Rows[i]["file_no"].ToString();
                        if (dtFinalResult.Rows[i]["file_no"].ToString() == current && i != (dtFinalResult.Rows.Count - 1))
                        {
                            total_cst += Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                            total_chg += Double.Parse(dtFinalResult.Rows[i]["charge"].ToString());
                            total_profit += Double.Parse(dtFinalResult.Rows[i]["charge"].ToString()) - Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());

                        }
                        else if (dtFinalResult.Rows[i]["file_no"].ToString() != current && i != (dtFinalResult.Rows.Count - 1))
                        {
                            //-----------------------------------
                            dtParent.Rows.Add(dtParent.NewRow());
                            dtParent.Rows[dtParent.Rows.Count - 1]["KeyField"] = current;
                            dtParent.Rows[dtParent.Rows.Count - 1]["cost"] = total_cst;
                            dtParent.Rows[dtParent.Rows.Count - 1]["charge"] = total_chg;
                            dtParent.Rows[dtParent.Rows.Count - 1]["Profit"] = total_profit;
                            //-----------------------------------

                            current = dtFinalResult.Rows[i]["file_no"].ToString();

                            total_cst = Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                            total_chg = Double.Parse(dtFinalResult.Rows[i]["charge"].ToString());
                            total_profit = Double.Parse(dtFinalResult.Rows[i]["charge"].ToString()) - Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());

                        }


                        if (i == dtFinalResult.Rows.Count - 1)
                        {
                            if (dtFinalResult.Rows[i]["file_no"].ToString() == current)
                            {
                                total_cst += Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                                total_chg += Double.Parse(dtFinalResult.Rows[i]["charge"].ToString());
                                total_profit += Double.Parse(dtFinalResult.Rows[i]["charge"].ToString()) - Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                                //-----------------------------------
                                dtParent.Rows.Add(dtParent.NewRow());
                                dtParent.Rows[dtParent.Rows.Count - 1]["KeyField"] = current;
                                dtParent.Rows[dtParent.Rows.Count - 1]["cost"] = total_cst;
                                dtParent.Rows[dtParent.Rows.Count - 1]["charge"] = total_chg;
                                dtParent.Rows[dtParent.Rows.Count - 1]["Profit"] = total_profit;
                                //-----------------------------------

                            }
                            else
                            {
                                //-----------------------------------
                                dtParent.Rows.Add(dtParent.NewRow());
                                dtParent.Rows[dtParent.Rows.Count - 1]["KeyField"] = current;
                                dtParent.Rows[dtParent.Rows.Count - 1]["cost"] = total_cst;
                                dtParent.Rows[dtParent.Rows.Count - 1]["charge"] = total_chg;
                                dtParent.Rows[dtParent.Rows.Count - 1]["Profit"] = total_profit;
                                //-----------------------------------

                                total_cst = Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                                total_chg = Double.Parse(dtFinalResult.Rows[i]["charge"].ToString());
                                total_profit = Double.Parse(dtFinalResult.Rows[i]["charge"].ToString()) - Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());

                                //-----------------------------------
                                dtParent.Rows.Add(dtParent.NewRow());
                                dtParent.Rows[dtParent.Rows.Count - 1]["KeyField"] = dtFinalResult.Rows[i]["file_no"].ToString();
                                dtParent.Rows[dtParent.Rows.Count - 1]["cost"] = total_cst;
                                dtParent.Rows[dtParent.Rows.Count - 1]["charge"] = total_chg;
                                dtParent.Rows[dtParent.Rows.Count - 1]["Profit"] = total_profit;
                                //-----------------------------------
                            }
                        }
                    }
                }

                else if (selectedCase == 4)
                {
                    dtParent = createTable();
                    dtFinalResult = dv.ToTable();
                    dtChild = dtFinalResult.Copy();
                    dtChild.Columns.Add(new DataColumn("KeyField", System.Type.GetType("System.String")));
                    dtChild.Columns.Add(new DataColumn("Profit", System.Type.GetType("System.Decimal")));
                    string current = dtFinalResult.Rows[0]["ref_no"].ToString();
                    double total_cst = 0;
                    double total_chg = 0;
                    double total_profit = 0;
                    for (int i = 0; i < dtFinalResult.Rows.Count; i++)
                    {
                        dtChild.Rows[i]["Profit"] = Double.Parse(dtFinalResult.Rows[i]["charge"].ToString()) - Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                        grandTotalCost += Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                        grandTotalCharge += Double.Parse(dtFinalResult.Rows[i]["charge"].ToString());
                        grandTotalProfit += Double.Parse(dtFinalResult.Rows[i]["charge"].ToString()) - Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());

                        dtChild.Rows[i]["KeyField"] = dtFinalResult.Rows[i]["ref_no"].ToString();
                        if (dtFinalResult.Rows[i]["ref_no"].ToString() == current && i != (dtFinalResult.Rows.Count - 1))
                        {
                            total_cst += Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                            total_chg += Double.Parse(dtFinalResult.Rows[i]["charge"].ToString());
                            total_profit += Double.Parse(dtFinalResult.Rows[i]["charge"].ToString()) - Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                        }
                        else if (dtFinalResult.Rows[i]["ref_no"].ToString() != current && i != (dtFinalResult.Rows.Count - 1))
                        {
                            //-----------------------------------
                            dtParent.Rows.Add(dtParent.NewRow());
                            dtParent.Rows[dtParent.Rows.Count - 1]["KeyField"] = current;
                            dtParent.Rows[dtParent.Rows.Count - 1]["cost"] = total_cst;
                            dtParent.Rows[dtParent.Rows.Count - 1]["charge"] = total_chg;
                            dtParent.Rows[dtParent.Rows.Count - 1]["Profit"] = total_profit;
                            //-----------------------------------    

                            current = dtFinalResult.Rows[i]["ref_no"].ToString();
                            total_cst = Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                            total_chg = Double.Parse(dtFinalResult.Rows[i]["charge"].ToString());
                            total_profit = Double.Parse(dtFinalResult.Rows[i]["charge"].ToString()) - Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());

                        }

                        if (i == dtFinalResult.Rows.Count - 1)
                        {
                            if (dtFinalResult.Rows[i]["ref_no"].ToString() == current)
                            {
                                total_cst += Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                                total_chg += Double.Parse(dtFinalResult.Rows[i]["charge"].ToString());
                                total_profit += Double.Parse(dtFinalResult.Rows[i]["charge"].ToString()) - Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                                //-----------------------------------
                                dtParent.Rows.Add(dtParent.NewRow());
                                dtParent.Rows[dtParent.Rows.Count - 1]["KeyField"] = current;
                                dtParent.Rows[dtParent.Rows.Count - 1]["cost"] = total_cst;
                                dtParent.Rows[dtParent.Rows.Count - 1]["charge"] = total_chg;
                                dtParent.Rows[dtParent.Rows.Count - 1]["Profit"] = total_profit;
                                //-----------------------------------
                            }
                            else
                            {
                                //-----------------------------------
                                dtParent.Rows.Add(dtParent.NewRow());
                                dtParent.Rows[dtParent.Rows.Count - 1]["KeyField"] = current;
                                dtParent.Rows[dtParent.Rows.Count - 1]["cost"] = total_cst;
                                dtParent.Rows[dtParent.Rows.Count - 1]["charge"] = total_chg;
                                dtParent.Rows[dtParent.Rows.Count - 1]["Profit"] = total_profit;
                                //-----------------------------------

                                total_cst = Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                                total_chg = Double.Parse(dtFinalResult.Rows[i]["charge"].ToString());
                                total_profit = Double.Parse(dtFinalResult.Rows[i]["charge"].ToString()) - Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());

                                //-----------------------------------
                                dtParent.Rows.Add(dtParent.NewRow());
                                dtParent.Rows[dtParent.Rows.Count - 1]["KeyField"] = dtFinalResult.Rows[i]["ref_no"].ToString();
                                dtParent.Rows[dtParent.Rows.Count - 1]["cost"] = total_cst;
                                dtParent.Rows[dtParent.Rows.Count - 1]["charge"] = total_chg;
                                dtParent.Rows[dtParent.Rows.Count - 1]["Profit"] = total_profit;
                                //-----------------------------------
                            }
                        }
                    }
                }


                else if (selectedCase == 5)
                {
                    dtParent = createTable();
                    dtFinalResult = dv.ToTable();
                    dtChild = dtFinalResult.Copy();
                    dtChild.Columns.Add(new DataColumn("KeyField", System.Type.GetType("System.String")));
                    dtChild.Columns.Add(new DataColumn("Profit", System.Type.GetType("System.Decimal")));

                    string current = DateTime.Parse(dtFinalResult.Rows[0]["date_exec"].ToString()).Year.ToString();
                    double total_cst = 0;
                    double total_chg = 0;
                    double total_profit = 0;

                    for (int i = 0; i < dtFinalResult.Rows.Count; i++)
                    {
                        dtChild.Rows[i]["Profit"] = Double.Parse(dtFinalResult.Rows[i]["charge"].ToString()) - Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                        grandTotalCost += Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                        grandTotalCharge += Double.Parse(dtFinalResult.Rows[i]["charge"].ToString());
                        grandTotalProfit += Double.Parse(dtFinalResult.Rows[i]["charge"].ToString()) - Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());

                        dtChild.Rows[i]["KeyField"] = DateTime.Parse(dtFinalResult.Rows[i]["date_exec"].ToString()).Year.ToString();

                        if (DateTime.Parse(dtFinalResult.Rows[i]["date_exec"].ToString()).Year.ToString() == current && i != (dtFinalResult.Rows.Count - 1))
                        {
                            total_cst += Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                            total_chg += Double.Parse(dtFinalResult.Rows[i]["charge"].ToString());
                            total_profit += Double.Parse(dtFinalResult.Rows[i]["charge"].ToString()) - Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                        }
                        else if (DateTime.Parse(dtFinalResult.Rows[i]["date_exec"].ToString()).Year.ToString() != current && i != (dtFinalResult.Rows.Count - 1))
                        {
                            //-----------------------------------
                            dtParent.Rows.Add(dtParent.NewRow());
                            dtParent.Rows[dtParent.Rows.Count - 1]["KeyField"] = current;
                            dtParent.Rows[dtParent.Rows.Count - 1]["cost"] = total_cst;
                            dtParent.Rows[dtParent.Rows.Count - 1]["charge"] = total_chg;
                            dtParent.Rows[dtParent.Rows.Count - 1]["Profit"] = total_profit;
                            //------------------------------------ 

                            current = DateTime.Parse(dtFinalResult.Rows[i]["date_exec"].ToString()).Year.ToString();
                            total_cst = Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                            total_chg = Double.Parse(dtFinalResult.Rows[i]["charge"].ToString());
                            total_profit = Double.Parse(dtFinalResult.Rows[i]["charge"].ToString()) - Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());

                        }


                        if (i == dtFinalResult.Rows.Count - 1)
                        {
                            if (DateTime.Parse(dtFinalResult.Rows[i]["date_exec"].ToString()).Year.ToString() == current)
                            {
                                total_cst += Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                                total_chg += Double.Parse(dtFinalResult.Rows[i]["charge"].ToString());
                                total_profit += Double.Parse(dtFinalResult.Rows[i]["charge"].ToString()) - Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());

                                //-----------------------------------
                                dtParent.Rows.Add(dtParent.NewRow());
                                dtParent.Rows[dtParent.Rows.Count - 1]["KeyField"] = current;
                                dtParent.Rows[dtParent.Rows.Count - 1]["cost"] = total_cst;
                                dtParent.Rows[dtParent.Rows.Count - 1]["charge"] = total_chg;
                                dtParent.Rows[dtParent.Rows.Count - 1]["Profit"] = total_profit;
                                //-----------------------------------
                            }
                            else
                            {
                                //-----------------------------------
                                dtParent.Rows.Add(dtParent.NewRow());
                                dtParent.Rows[dtParent.Rows.Count - 1]["KeyField"] = current;
                                dtParent.Rows[dtParent.Rows.Count - 1]["cost"] = total_cst;
                                dtParent.Rows[dtParent.Rows.Count - 1]["charge"] = total_chg;
                                dtParent.Rows[dtParent.Rows.Count - 1]["Profit"] = total_profit;
                                //-----------------------------------


                                total_cst = Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                                total_chg = Double.Parse(dtFinalResult.Rows[i]["charge"].ToString());
                                total_profit = Double.Parse(dtFinalResult.Rows[i]["charge"].ToString()) - Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());

                                //-----------------------------------
                                dtParent.Rows.Add(dtParent.NewRow());
                                dtParent.Rows[dtParent.Rows.Count - 1]["KeyField"] = DateTime.Parse(dtFinalResult.Rows[i]["date_exec"].ToString()).Year.ToString();
                                dtParent.Rows[dtParent.Rows.Count - 1]["cost"] = total_cst;
                                dtParent.Rows[dtParent.Rows.Count - 1]["charge"] = total_chg;
                                dtParent.Rows[dtParent.Rows.Count - 1]["Profit"] = total_profit;
                                //-----------------------------------
                            }
                        }
                    }
                }

                else if (selectedCase == 6)
                {
                    dtParent = createTable();
                    dtFinalResult = dv.ToTable();
                    dtChild = dtFinalResult.Copy();
                    dtChild.Columns.Add(new DataColumn("KeyField", System.Type.GetType("System.String")));
                    dtChild.Columns.Add(new DataColumn("Profit", System.Type.GetType("System.Decimal")));
                    string current = DateTime.Parse(dtFinalResult.Rows[0]["date_exec"].ToString()).Month.ToString();
                    double total_cst = 0;
                    double total_chg = 0;
                    double total_profit = 0;
                    for (int i = 0; i < dtFinalResult.Rows.Count; i++)
                    {
                        dtChild.Rows[i]["Profit"] = Double.Parse(dtFinalResult.Rows[i]["charge"].ToString()) - Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                        grandTotalCost += Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                        grandTotalCharge += Double.Parse(dtFinalResult.Rows[i]["charge"].ToString());
                        grandTotalProfit += Double.Parse(dtFinalResult.Rows[i]["charge"].ToString()) - Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());

                        dtChild.Rows[i]["KeyField"] = DateTime.Parse(dtFinalResult.Rows[i]["date_exec"].ToString()).Month.ToString();
                        if (DateTime.Parse(dtFinalResult.Rows[i]["date_exec"].ToString()).Month.ToString() == current && i != (dtFinalResult.Rows.Count - 1))
                        {
                            total_cst += Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                            total_chg += Double.Parse(dtFinalResult.Rows[i]["charge"].ToString());
                            total_profit += Double.Parse(dtFinalResult.Rows[i]["charge"].ToString()) - Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());

                        }
                        else if (DateTime.Parse(dtFinalResult.Rows[i]["date_exec"].ToString()).Month.ToString() != current && i != (dtFinalResult.Rows.Count - 1))
                        {
                            //-----------------------------------
                            dtParent.Rows.Add(dtParent.NewRow());
                            dtParent.Rows[dtParent.Rows.Count - 1]["KeyField"] = current;
                            dtParent.Rows[dtParent.Rows.Count - 1]["cost"] = total_cst;
                            dtParent.Rows[dtParent.Rows.Count - 1]["charge"] = total_chg;
                            dtParent.Rows[dtParent.Rows.Count - 1]["Profit"] = total_profit;
                            //-----------------------------------                      
                            current = DateTime.Parse(dtFinalResult.Rows[i]["date_exec"].ToString()).Month.ToString();

                            total_cst = Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                            total_chg = Double.Parse(dtFinalResult.Rows[i]["charge"].ToString());
                            total_profit = Double.Parse(dtFinalResult.Rows[i]["charge"].ToString()) - Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());


                        }


                        if (i == dtFinalResult.Rows.Count - 1)
                        {
                            if (DateTime.Parse(dtFinalResult.Rows[i]["date_exec"].ToString()).Month.ToString() == current)
                            {
                                total_cst += Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                                total_chg += Double.Parse(dtFinalResult.Rows[i]["charge"].ToString());
                                total_profit += Double.Parse(dtFinalResult.Rows[i]["charge"].ToString()) - Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());

                                //-----------------------------------
                                dtParent.Rows.Add(dtParent.NewRow());
                                dtParent.Rows[dtParent.Rows.Count - 1]["KeyField"] = current;
                                dtParent.Rows[dtParent.Rows.Count - 1]["cost"] = total_cst;
                                dtParent.Rows[dtParent.Rows.Count - 1]["charge"] = total_chg;
                                dtParent.Rows[dtParent.Rows.Count - 1]["Profit"] = total_profit;
                                //-----------------------------------
                            }
                            else
                            {
                                //-----------------------------------
                                dtParent.Rows.Add(dtParent.NewRow());
                                dtParent.Rows[dtParent.Rows.Count - 1]["KeyField"] = current;
                                dtParent.Rows[dtParent.Rows.Count - 1]["cost"] = total_cst;
                                dtParent.Rows[dtParent.Rows.Count - 1]["charge"] = total_chg;
                                dtParent.Rows[dtParent.Rows.Count - 1]["Profit"] = total_profit;
                                //-----------------------------------
                                total_cst = Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());
                                total_chg = Double.Parse(dtFinalResult.Rows[i]["charge"].ToString());
                                total_profit = Double.Parse(dtFinalResult.Rows[i]["charge"].ToString()) - Double.Parse(dtFinalResult.Rows[i]["cost"].ToString());


                                //-----------------------------------
                                dtParent.Rows.Add(dtParent.NewRow());
                                dtParent.Rows[dtParent.Rows.Count - 1]["KeyField"] = DateTime.Parse(dtFinalResult.Rows[i]["date_exec"].ToString()).Month.ToString();
                                dtParent.Rows[dtParent.Rows.Count - 1]["cost"] = total_cst;
                                dtParent.Rows[dtParent.Rows.Count - 1]["charge"] = total_chg;
                                dtParent.Rows[dtParent.Rows.Count - 1]["Profit"] = total_profit;
                                //-----------------------------------
                            }
                        }
                    }
                }

                //-----------------------------------GRAND TOTAL
                dtParent.Rows.Add(dtParent.NewRow());
                dtParent.Rows[dtParent.Rows.Count - 1]["KeyField"] = "GRAND TOTAL:";
                dtParent.Rows[dtParent.Rows.Count - 1]["cost"] = grandTotalCost;
                dtParent.Rows[dtParent.Rows.Count - 1]["charge"] = grandTotalCharge;
                dtParent.Rows[dtParent.Rows.Count - 1]["Profit"] = grandTotalProfit;
                //-----------------------------------
                DataSet ds = new DataSet();

                dtParent.TableName = "Parent";
                dtChild.TableName = "Child";
                ds.Tables.Add(dtParent);
                ds.Tables.Add(dtChild);
                ds.Relations.Add(dtParent.Columns["KeyField"], dtChild.Columns["KeyField"]);
                this.UltraWebGridPNL.DataSource = ds;
                this.UltraWebGridPNL.DataBind();
                Session["dtParent"] = dtParent;
                Session["dtChild"] = dtChild;
            }
        }

        protected void UltraWebGridPNL_InitializeLayout(object sender, LayoutEventArgs e)
        {
            UltraWebGridPNL.DisplayLayout.ReadOnly = ReadOnly.LevelOne;

            e.Layout.ViewType = ViewType.Hierarchical;// To show child table 
            e.Layout.TableLayout = TableLayout.Auto;// To expand column with 
            e.Layout.RowStyleDefault.BorderDetails.ColorTop = Color.Gray;

            setParentLook(e);
            setChildLook(e);

        }

        protected void setParentLook(LayoutEventArgs e)
        {
            e.Layout.Bands[0].Columns.FromKey("KeyField").Header.Caption = hashGroupCaption[grp].ToString();

            e.Layout.Bands[0].Columns.FromKey("charge").Header.Caption = "Total Charge";
            e.Layout.Bands[0].Columns.FromKey("cost").Header.Caption = "Total Cost";
            e.Layout.Bands[0].Columns.FromKey("Profit").Header.Caption = "Total Profit";
            e.Layout.Bands[0].Columns.FromKey("charge").Header.Style.Width = new Unit(200,UnitType.Pixel);
            e.Layout.Bands[0].Columns.FromKey("cost").Header.Style.Width = new Unit(200, UnitType.Pixel);
            e.Layout.Bands[0].Columns.FromKey("charge").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[0].Columns.FromKey("charge").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[0].Columns.FromKey("cost").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[0].Columns.FromKey("cost").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[0].Columns.FromKey("Profit").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[0].Columns.FromKey("Profit").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            

        }

        protected void setChildLook(LayoutEventArgs e)
        {
            e.Layout.Bands[1].Columns.FromKey("origin").Header.Caption="Origin Port";
            e.Layout.Bands[1].Columns.FromKey("destination").Header.Caption = "Destination Port";
            e.Layout.Bands[1].Columns.FromKey("mawb_num").Header.Caption = "Master Bill";
            e.Layout.Bands[1].Columns.FromKey("date_exec").Header.Caption = "Date";
            e.Layout.Bands[1].Columns.FromKey("file_no").Header.Caption = "File#";
            e.Layout.Bands[1].Columns.FromKey("import_export").Header.Caption = "Import/Export";
            e.Layout.Bands[1].Columns.FromKey("air_ocean").Header.Caption = "Air/Ocean";
            e.Layout.Bands[1].Columns.FromKey("hawb_num").Header.Caption = "House Bill";
            e.Layout.Bands[1].Columns.FromKey("ref_no").Header.Caption = "Reference";
            e.Layout.Bands[1].Columns.FromKey("charge").Header.Caption = "Charge";
            e.Layout.Bands[1].Columns.FromKey("cost").Header.Caption = "Cost";
            e.Layout.Bands[1].Columns.FromKey("Profit").Header.Caption = "Profit";
            e.Layout.Bands[1].Columns.FromKey("freight_size").Hidden = true;
            e.Layout.Bands[1].Columns.FromKey("scale").Hidden = true;
            e.Layout.Bands[1].Columns.FromKey("link").Hidden = true;
            e.Layout.Bands[1].Columns.FromKey("link_m").Hidden = true;
            e.Layout.Bands[1].Columns.FromKey("invoice_no").Hidden = true;
            e.Layout.Bands[1].Columns.FromKey("customer_number").Hidden = true;
            e.Layout.Bands[1].Columns.FromKey("customer").Hidden = true;
            e.Layout.Bands[1].Columns.FromKey("KeyField").Hidden = true;
            e.Layout.Bands[1].Columns.FromKey("charge").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[1].Columns.FromKey("charge").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[1].Columns.FromKey("cost").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[1].Columns.FromKey("cost").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[1].Columns.FromKey("Profit").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[1].Columns.FromKey("Profit").CellStyle.HorizontalAlign = HorizontalAlign.Right;

        }


        protected void UltraWebGridPNL_InitializeRow(object sender, RowEventArgs e)
        {
            if (e.Row.Band.BaseTableName == "Child")
            {

                string s_master = "javascript:; " + "void(viewPop('" + e.Row.Cells.FromKey("link_m").Value + "'))";
                e.Row.Cells.FromKey("mawb_num").TargetURL = s_master;
                string s_child = "javascript:; " + "void(viewPop('" + e.Row.Cells.FromKey("link").Value + "'))";
                e.Row.Cells.FromKey("hawb_num").TargetURL = s_child;
            }
        }
        protected void btnExcel_Click(object sender, ImageClickEventArgs e)
        {
            this.UltraWebGridExcelExporter1.DownloadName = "Operation.xls";
            this.UltraWebGridExcelExporter1.Export(this.UltraWebGridPNL);

        }
        
        protected void btnPDF_Click(object sender, ImageClickEventArgs e)
        {

            string tempFile = Session.SessionID.ToString();

            LoadReport();
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
























