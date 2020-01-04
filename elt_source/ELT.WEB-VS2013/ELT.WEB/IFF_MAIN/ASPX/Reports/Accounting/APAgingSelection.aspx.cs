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
using System.IO;
using System.Data.SqlClient;
using System.Configuration;

namespace IFF_MAIN.ASPX.Reports.Accounting
{

    public partial class APAgingSelection : System.Web.UI.Page
    {

        protected System.Web.UI.WebControls.Label Label3;
        protected System.Web.UI.WebControls.Label Label5;
        protected System.Web.UI.WebControls.Label Label6;
        protected System.Web.UI.WebControls.TextBox txtbillNum;
        protected System.Web.UI.WebControls.TextBox txtHAWBNum;
        protected System.Web.UI.WebControls.TextBox txtMAWBNum;
        protected System.Web.UI.WebControls.Label Label9;
        protected System.Web.UI.WebControls.Label Label10;
        protected System.Web.UI.WebControls.DropDownList DropDownList2;
        protected System.Web.UI.WebControls.Button Button2;

        public string elt_account_number;
        protected string ConnectStr;
        static public string windowName;
        public string user_id, login_name, user_right;
        public bool bReadOnly = false;
        protected void Page_Load(object sender, System.EventArgs e)
        {
            Session.LCID = 1033;
            elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
            user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
            user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
            login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
            windowName = Request.QueryString["WindowName"];

            ConnectStr = (new igFunctions.DB().getConStr());
            bReadOnly = new igFunctions.DB().AUTH_CHECK(elt_account_number, user_id, ConnectStr, Request.ServerVariables["URL"].ToLower(), "");

            if (!IsPostBack)
            {
                ELT.COMMON.SessionManager Smgr = new ELT.COMMON.SessionManager();
                Smgr.ClearReportSessionVars();
                this.Webdatetimeedit2.Text = DateTime.Now.ToShortDateString();
                PerformBranch();
            }
        }

        private void PerformBranch()
        {

            if (int.Parse(user_right) < 9)
            {
                lblBranch.Visible = DropDownList1.Visible = false;
                return;
            }

            string[] BranchName = new string[64];
            string[] BranchAcct = new string[64];

            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand Cmd = new SqlCommand();
            Cmd.Connection = Con;

            Con.Open();

            Cmd.CommandText = "select elt_account_number,dba_name from agent where left(elt_account_number,5) = " + elt_account_number.Substring(0, 5);

            SqlDataReader reader = Cmd.ExecuteReader();

            int bIndex = 0;
            while (reader.Read())
            {
                BranchName[bIndex] = reader["dba_name"].ToString();
                BranchAcct[bIndex] = reader["elt_account_number"].ToString();
                bIndex += 1;
            }

            reader.Close();
            Con.Close();

            if (bIndex > 1)
            {

                lblBranch.Visible = DropDownList1.Visible = true;
                DropDownList1.Items.Clear();

                for (int i = 0; i < bIndex; i++)
                {
                    DropDownList1.Items.Add("");
                    DropDownList1.Items[i].Value = BranchAcct[i];
                    DropDownList1.Items[i].Text = BranchName[i];
                }

                DropDownList1.Items.Insert(0, "All");
                DropDownList1.SelectedIndex = DropDownList1.Items.IndexOf(DropDownList1.Items.FindByValue(elt_account_number));
            }
        }

        # region /// DateDefault
        private void performDateDefault()
        {
        }

        private DateTime getFirstDate()
        {
            int daysToAdd;
            DateTime sd = DateTime.Now.AddMonths(-1);
            DateTime firstDate;

            daysToAdd = System.DateTime.DaysInMonth(int.Parse(sd.Year.ToString()), int.Parse(sd.Month.ToString())) - int.Parse(sd.Day.ToString());
            firstDate = sd.AddDays(daysToAdd);
            return firstDate.AddDays(1);

        }
        # endregion


        #region Web Form
        override protected void OnInit(EventArgs e)
        {

            InitializeComponent();
            base.OnInit(e);
        }

        private void InitializeComponent()
        {

        }
        #endregion

        private void PerformSearch()
        {
            string[] str = new string[7];
            string strCommandText, strCommandTextU;
            string strlblBranch = "";
            string strBranch = "";
            string strCompany = "";

            for (int i = 0; i < str.Length; i++) { str[i] = ""; }

            if (DropDownList1.Visible)
            {
                if (DropDownList1.SelectedValue == "All")
                {
                    strBranch = "0";
                }
                else
                {
                    strBranch = DropDownList1.SelectedValue;
                }
            }

            if (strBranch == "") strBranch = elt_account_number;

            // Company

            if (lstCompanyName.Text != "" && hCompanyAcct.Value != "" && hCompanyAcct.Value != "0")
            {
                strCompany = hCompanyAcct.Value;
                str[3] = string.Format("Company : {0}", lstCompanyName.Text);
            }

            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand Cmd = new SqlCommand();
            Cmd.Connection = Con;

            Con.Open();

            if (strBranch == "0")
            {
                Cmd.CommandText = "SELECT dba_name FROM agent WHERE Left(elt_account_number,5) = " + elt_account_number.Substring(0, 5);
            }
            else
            {
                Cmd.CommandText = "SELECT dba_name FROM agent WHERE elt_account_number = " + strBranch;
            }

            SqlDataReader reader = Cmd.ExecuteReader();

            if (reader.Read())
            {
                strlblBranch = reader["dba_name"].ToString();
            }

            reader.Close();
            Con.Close();

            if (strBranch != "0")
            {
                strCommandText = @"
                    DECLARE @elt_account_number decimal
                    DECLARE @selected_date datetime
                    SET @elt_account_number=" + elt_account_number + @"
                    SET @selected_date='" + DateTime.Parse(Webdatetimeedit2.Text).ToShortDateString() + @"'
                    SELECT ISNULL(c.current_paid,0) AS bill_amt_paid,
                    a.elt_account_number,a.bill_number,a.bill_type,a.vendor_number, 
                    CASE WHEN isnull(b.class_code,'') = '' THEN b.dba_name
                    ELSE b.dba_name + '[' + RTRIM(LTRIM(isnull(b.class_code,''))) + ']'
                    END vendor_name,b.business_phone,
                    ISNULL(dbo.GetFileNumbersByBill(a.elt_account_number,a.bill_number),'') as ref_no_Our,
                    isnull(a.bill_date,'') as bill_date, 
                    isnull(a.bill_due_date,'') as bill_due_date, 
                    a.bill_amt,a.bill_amt_paid as paid_total,a.bill_amt_due,a.ref_no,a.bill_expense_acct, 
                    a.bill_ap,a.bill_status,a.print_id,a.lock,a.pmt_method,'' as agent_debit_no,'' as mb_no
                    FROM  bill a left outer join organization b 
                    On (a.elt_account_number = b.elt_account_number and a.vendor_number = b.org_account_number)
                    LEFT OUTER JOIN 
                    (SELECT SUM(ISNULL(cd.amt_paid,0)) AS current_paid,cd.elt_account_number,cd.bill_number from check_Queue cq 
                    LEFT OUTER JOIN check_detail cd ON (cq.elt_account_number=cd.elt_account_number AND cq.print_id=cd.print_id)
                    LEFT OUTER JOIN all_accounts_journal gl ON (gl.elt_account_number=cq.elt_account_number 
                    AND cq.print_id=gl.tran_num AND cq.check_no=gl.check_no)
                    WHERE cq.bill_date<@selected_date AND ISNULL(gl.chk_void,'')<>'Y' 
                    AND gl_account_name<>'Account Payable' AND cd.elt_account_number=@elt_account_number
                    GROUP by cd.elt_account_number,cd.bill_number) c
                    ON (a.elt_account_number=c.elt_account_number AND a.bill_number=c.bill_number)
                    WHERE a.elt_account_number=@elt_account_number 
                    AND bill_date<@selected_date AND bill_amt_due>0";

//                strCommandText = @" SELECT a.EmailItemID,a.bill_number,a.bill_type,a.vendor_number, 
//                                    CASE WHEN isnull(b.class_code,'') = '' THEN b.dba_name
//                                    ELSE b.dba_name + '[' + RTRIM(LTRIM(isnull(b.class_code,''))) + ']'
//                                    END vendor_name,b.business_phone,
//                                    ISNULL(dbo.GetFileNumbersByBill(a.EmailItemID,a.bill_number),'') as ref_no_Our,
//                                    isnull(a.bill_date,'') as bill_date, 
//                                    isnull(a.bill_due_date,'') as bill_due_date, 
//                                    a.bill_amt,a.bill_amt_paid,a.bill_amt_due,a.ref_no,a.bill_expense_acct, 
//                                    a.bill_ap,a.bill_status,a.print_id,a.lock,a.pmt_method,'' as agent_debit_no,'' as mb_no
//                                    FROM  bill a left outer join organization b 
//                                    On (a.EmailItemID = b.EmailItemID and a.vendor_number = b.org_account_number)
//                                    WHERE a.EmailItemID = " + strBranch +
//                                    " AND (isnull(bill_date,'') < DATEADD(day, 1,'" + Webdatetimeedit2.Date.ToShortDateString() + "'))" +
//                                    " AND bill_amt_due>0 ";
                if (strCompany != "")
                {
                    strCommandText += " AND vendor_number=" + strCompany;
                }
                strCommandText += " ORDER BY vendor_name,bill_date";

                str[2] = string.Format("Branch : {0}", strBranch);

            }  /* strBranch != 0 */
            else
            {
                strCommandText = @"
                    DECLARE @elt_account_number decimal
                    DECLARE @selected_date datetime
                    SET @elt_account_number=" + elt_account_number.Substring(0, 5) + @"
                    SET @selected_date='" + DateTime.Parse(Webdatetimeedit2.Text).ToShortDateString() + @"'
                    SELECT ISNULL(c.current_paid,0) AS bill_amt_paid,
                    a.elt_account_number,a.bill_number,a.bill_type,a.vendor_number, 
                    CASE WHEN isnull(b.class_code,'') = '' THEN b.dba_name
                    ELSE b.dba_name + '[' + RTRIM(LTRIM(isnull(b.class_code,''))) + ']'
                    END vendor_name,b.business_phone,
                    ISNULL(dbo.GetFileNumbersByBill(a.elt_account_number,a.bill_number),'') as ref_no_Our,
                    isnull(a.bill_date,'') as bill_date, 
                    isnull(a.bill_due_date,'') as bill_due_date, 
                    a.bill_amt,a.bill_amt_paid as paid_total,a.bill_amt_due,a.ref_no,a.bill_expense_acct, 
                    a.bill_ap,a.bill_status,a.print_id,a.lock,a.pmt_method,'' as agent_debit_no,'' as mb_no
                    FROM  bill a left outer join organization b 
                    On (a.elt_account_number = b.elt_account_number and a.vendor_number = b.org_account_number)
                    LEFT OUTER JOIN 
                    (SELECT SUM(ISNULL(cd.amt_paid,0)) AS current_paid,cd.elt_account_number,cd.bill_number from check_Queue cq 
                    LEFT OUTER JOIN check_detail cd ON (cq.elt_account_number=cd.elt_account_number AND cq.print_id=cd.print_id)
                    LEFT OUTER JOIN all_accounts_journal gl ON (gl.elt_account_number=cq.elt_account_number 
                    AND cq.print_id=gl.tran_num AND cq.check_no=gl.check_no)
                    WHERE cq.bill_date<@selected_date AND ISNULL(gl.chk_void,'')<>'Y' 
                    AND gl_account_name<>'Account Payable' AND LEFT(cd.elt_account_number,5)=@elt_account_number
                    GROUP by cd.elt_account_number,cd.bill_number) c
                    ON (a.elt_account_number=c.elt_account_number AND a.bill_number=c.bill_number)
                    WHERE LEFT(a.elt_account_number,5)=@elt_account_number 
                    AND bill_date<@selected_date AND bill_amt_due>0";

//                strCommandText = @" SELECT a.EmailItemID,a.bill_number,a.bill_type,a.vendor_number, 
//                                    CASE WHEN isnull(b.class_code,'') = '' THEN b.dba_name
//                                    ELSE b.dba_name + '[' + RTRIM(LTRIM(isnull(b.class_code,''))) + ']'
//                                    END vendor_name,b.business_phone,
//                                    ISNULL(dbo.GetFileNumbersByBill(a.EmailItemID,a.bill_number),'') as ref_no_Our,
//                                    isnull(a.bill_date,'') as bill_date, 
//                                    isnull(a.bill_due_date,'') as bill_due_date, 
//                                    a.bill_amt,a.bill_amt_paid,a.bill_amt_due,a.ref_no, 
//                                    a.bill_expense_acct,a.bill_ap,a.bill_status,a.print_id, 
//                                    a.lock,a.pmt_method,'' as agent_debit_no,'' as mb_no
//                                    FROM  bill a left outer join organization b 
//                                    On (a.EmailItemID = b.EmailItemID and a.vendor_number = b.org_account_number)
//                                    WHERE  Left(a.EmailItemID,5) = " + EmailItemID.Substring(0, 5) +
//                                    " AND (isnull(bill_date,'') < DATEADD(day, 1,'" + Webdatetimeedit2.Date.ToShortDateString() + "'))" +
//                                    " AND bill_amt_due>0 ";

                if (strCompany != "")
                {
                    strCommandText += " AND vendor_number =" + strCompany;
                }

                strCommandText += " ORDER BY vendor_name,bill_date";

                str[2] = string.Format("Branch Code (All) : {0}", elt_account_number.Substring(0, 5));
            }

            if (this.CheckUnposted.Checked)
            {

                if (strBranch != "0")
                {
                    strCommandTextU = @"SELECT isnull(a.import_export,'') as import_export, a.ref as ref_no, a.*,  
                                        a.vendor_number,CASE WHEN isnull(b.class_code,'') = '' THEN b.dba_name
                                        ELSE b.dba_name + '[' + RTRIM(LTRIM(isnull(b.class_code,''))) + ']'
                                        END vendor_name,b.business_phone,c.ref_no_Our
                                        FROM  bill_detail a left outer join organization b 
                                        On (a.elt_account_number = b.elt_account_number and a.vendor_number=b.org_account_number)
                                        LEFT OUTER JOIN invoice c ON (a.elt_account_number = c.elt_account_number and a.invoice_no=c.invoice_no)
										WHERE a.elt_account_number = " + strBranch +
                            " AND (a.tran_date < DATEADD(day, 1,'" + DateTime.Parse(Webdatetimeedit2.Text).ToShortDateString() + "'))" +
                            " AND a.bill_number=0 and a.item_amt<>0";

                    if (strCompany != "")
                    {
                        strCommandTextU += " AND  vendor_number =" + strCompany;
                    }
                    strCommandTextU += " ORDER BY b.dba_name, a.tran_date";


                }  /* strBranch != 0 */
                else
                {
                    strCommandTextU = @"SELECT isnull(a.import_export,'') as import_export, a.ref as ref_no,a.*,
                                        a.vendor_number,CASE WHEN isnull(b.class_code,'') = '' THEN b.dba_name
                                        ELSE b.dba_name + '[' + RTRIM(LTRIM(isnull(b.class_code,''))) + ']'
                                        END vendor_name,b.business_phone,c.ref_no_Our
                                        FROM  bill_detail a left outer join organization b On (a.elt_account_number = b.elt_account_number and a.vendor_number=b.org_account_number)
                                        LEFT OUTER JOIN invoice c ON (a.elt_account_number = c.elt_account_number and a.invoice_no=c.invoice_no)
                                        WHERE LEFT(a.elt_account_number,5) = " + elt_account_number.Substring(0, 5) +
                                        " AND (a.tran_date < DATEADD(day, 1,'" + DateTime.Parse(Webdatetimeedit2.Text).ToShortDateString() + "'))" +
                                        " AND a.bill_number=0 and a.item_amt<>0";
                    if (strCompany != "")
                    {
                        strCommandTextU += " AND vendor_number =" + strCompany;
                    }

                    strCommandTextU += " ORDER BY b.dba_name, a.tran_date";

                }
            }
            else
            {
                strCommandTextU = "";
            }


            str[0] = string.Format("Date  :  ~ {0}", DateTime.Parse(Webdatetimeedit2.Text).ToShortDateString());
            str[1] = string.Format("Branch Name : {0}", strlblBranch);

            Session["strCommandText"] = strCommandText;
            Session["strCommandTextU"] = strCommandTextU;
            Session["strlblBranch"] = strlblBranch;
            if (strBranch != "0")
            {
                Session["strBranch"] = elt_account_number;
            }
            else
            {
                Session["strBranch"] = elt_account_number.Substring(0, 5);
            }

            Session["Accounting_sPeriod"] = str[0];
            Session["Accounting_sPeriodBegin"] = Webdatetimeedit2.Text;
            Session["Accounting_sBranchName"]  = str[1];
            Session["Accounting_sBranch_elt_account_number"]  = str[2];
            Session["Accounting_sCompanName"]  = str[3];
            Session["login_name"] = Request.Cookies["CurrentUserInfo"]["login_name"];
            Session["AsOf"] = DateTime.Parse(Webdatetimeedit2.Text).ToShortDateString();
            Session["Branch_Name"] = strlblBranch;
            Session["Branch_Code"] = elt_account_number;

        }


        protected void ImageButton2_Click1(object sender, ImageClickEventArgs e)
        {
            
            PerformSearch();
            Session["Accounting_sSelectionParam"] = "apaging";
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "RediretThis", "window.top.location.href='/Accounting/APAging/dataready'", true);
           // Response.Redirect("APAgingDetail.aspx?WindowName=" + windowName);

        }
    }
}
