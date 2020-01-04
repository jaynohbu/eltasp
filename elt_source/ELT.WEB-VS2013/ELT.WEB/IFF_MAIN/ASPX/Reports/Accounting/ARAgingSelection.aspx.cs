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

    public partial class ARAgingSelection : System.Web.UI.Page
    {

        protected System.Web.UI.WebControls.Label Label3;
        protected System.Web.UI.WebControls.Label Label5;
        protected System.Web.UI.WebControls.Label Label6;
        protected System.Web.UI.WebControls.TextBox txtInvoiceNum;
        protected System.Web.UI.WebControls.TextBox txtHAWBNum;
        protected System.Web.UI.WebControls.TextBox txtMAWBNum;
        protected System.Web.UI.WebControls.Label Label9;
        protected System.Web.UI.WebControls.Label Label10;
        protected System.Web.UI.WebControls.DropDownList DropDownList2;
        protected System.Web.UI.WebControls.CheckBox CheckBox1;
        protected System.Web.UI.WebControls.Button Button2;

        public string elt_account_number;
        public string user_id, login_name, user_right;
        protected string ConnectStr;
        static public string windowName;
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

            // this.Button1.Attributes.Add("onMouseDown", "Javascript:checkDate();");

            // Webdatetimeedit1.Date = getFirstDate();
            // Webdatetimeedit2.Date = DateTime.Now;
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


        override protected void OnInit(EventArgs e)
        {
            InitializeComponent();
            base.OnInit(e);
        }

        private void InitializeComponent()
        {
        }

        private void PerformSearch()
        {
            string[] str = new string[7];
            string strCommandText;
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
                /*
                strCommandText = @"SELECT * FROM (
SELECT CASE WHEN isnull(b.class_code,'') = '' THEN b.dba_name ELSE b.dba_name + ' [' + RTRIM(LTRIM(isnull(b.class_code,''))) + ']' END as customer_dba_name,
b.business_phone,0 AS customer_credit,b.org_account_number AS customer_no,a.* FROM invoice a left outer join organization b 
On (a.EmailItemID = b.EmailItemID and a.customer_number = b.org_account_number) 
LEFT OUTER JOIN customer_credits c 
ON (a.EmailItemID = c.EmailItemID and a.customer_number = c.customer_no) 
WHERE a.EmailItemID=" + EmailItemID + @" AND (invoice_date < DATEADD(day, 1,'" + Webdatetimeedit2.Date.ToShortDateString() + @"')) 
AND balance<>0 AND not isnull(a.customer_name,'1') = '1'";
                if (strCompany != "")
                {
                    strCommandText += " AND a.customer_number=" + strCompany;
                }
                strCommandText += @" UNION ALL
SELECT CASE WHEN isnull(a.class_code,'') = '' THEN a.dba_name ELSE a.dba_name + ' [' + RTRIM(LTRIM(isnull(a.class_code,''))) + ']' END as customer_dba_name,
a.business_phone,-1*b.credit AS customer_credit,b.customer_no,c.*
FROM organization a RIGHT OUTER JOIN customer_Credits b 
ON (a.elt_Account_number=b.EmailItemID AND a.org_Account_number=b.customer_no AND ISNULL(b.credit,0)<>0)
LEFT OUTER JOIN (SELECT * FROM invoice WHERE elt_Account_number=" + EmailItemID + @" AND balance<>0 AND pay_status='A')  c 
ON (a.elt_Account_number=c.elt_Account_number AND a.org_account_number IS NULL) 
WHERE a.EmailItemID=" + EmailItemID + @" AND invoice_no IS NULL";
                if (strCompany != "")
                {
                    strCommandText += " AND a.org_Account_number=" + strCompany;
                }
                strCommandText += @") x ORDER BY customer_dba_name,customer_number,invoice_date+term_curr";
                */


                strCommandText = @"BEGIN

DECLARE @elt_account_number decimal
DECLARE @selected_date datetime
DECLARE @gl_account_ar decimal

SET @elt_account_number=" + elt_account_number + @"
SET @selected_date = DATEADD(day,0,'" + DateTime.Parse(Webdatetimeedit2.Text).ToShortDateString() + @"')
SET @gl_account_ar = (SELECT gl_account_number FROM gl WHERE elt_account_number=@elt_account_number AND gl_account_desc='Accounts Receivable')


SELECT * FROM (
SELECT  CASE WHEN isnull(f.class_code,'') = '' THEN f.dba_name 
ELSE f.dba_name + ' [' + RTRIM(LTRIM(isnull(f.class_code,''))) + ']' END as customer_dba_name,f.business_phone,0 AS customer_credit,d.customer_number AS customer_no,
d.elt_account_number, d.invoice_no, invoice_type, import_export, air_ocean, invoice_date, ref_no, ref_no_Our, Customer_info, Total_Pieces, 
Total_Gross_Weight, Total_Charge_Weight, Origin_Dest, origin, dest, Customer_Number, Customer_Name, shipper, consignee, entry_no, 
entry_date, Carrier, Arrival_Dept, mawb_num, hawb_num, subtotal, sale_tax, agent_profit, accounts_receivable, amount_charged, ISNULL(e.p_amt,0) AS amount_paid, 
ISNULL(e.b_amt,amount_charged) AS balance, total_cost, remarks, pay_status, term_curr, term30, term60, term90, received_amt, pmt_method, existing_credits, deposit_to, lock_ar, lock_ap,
in_memo, is_org_merged, master_invoice_no
FROM invoice d LEFT OUTER JOIN 
(SELECT a.invoice_no,a.amount_charged-SUM(ISNULL(b.payment,0)) AS b_amt, SUM(ISNULL(b.payment,0)) AS p_amt FROM invoice a 
LEFT OUTER JOIN customer_payment_detail b
ON (a.elt_account_number=b.elt_account_number AND a.invoice_no=b.invoice_no)
LEFT OUTER JOIN customer_payment c
ON (b.elt_account_number=c.elt_account_number AND b.payment_no=c.payment_no)
WHERE a.elt_account_number=@elt_account_number AND a.invoice_date<=@selected_date 
AND (c.payment_date<=@selected_date OR c.payment_date IS NULL)
GROUP BY a.invoice_no,a.amount_charged) e 
ON (d.invoice_no=e.invoice_no AND d.elt_account_number=@elt_account_number)
LEFT OUTER JOIN organization f
ON (f.elt_account_number=d.elt_account_number AND f.org_account_number=d.customer_number)
WHERE (b_amt<>0 OR b_amt IS NULL) AND invoice_date<=@selected_date AND d.elt_account_number=@elt_account_number

UNION ALL

SELECT CASE WHEN isnull(f.class_code,'') = '' THEN f.dba_name 
ELSE f.dba_name + ' [' + RTRIM(LTRIM(isnull(f.class_code,''))) + ']' END as customer_dba_name,
f.business_phone,-1*e.credit AS customer_credit,e.customer_no,
g.elt_account_number, g.invoice_no, invoice_type, import_export, air_ocean, invoice_date, ref_no, ref_no_Our, Customer_info, Total_Pieces, 
Total_Gross_Weight, Total_Charge_Weight, Origin_Dest, origin, dest, Customer_Number, Customer_Name, shipper, consignee, entry_no, 
entry_date, Carrier, Arrival_Dept, mawb_num, hawb_num, subtotal, sale_tax, agent_profit, accounts_receivable, amount_charged, amount_paid, 
balance, total_cost, remarks, pay_status, term_curr, term30, term60, term90, received_amt, pmt_method, existing_credits, deposit_to, lock_ar, lock_ap,
in_memo, is_org_merged, master_invoice_no
FROM organization f RIGHT OUTER JOIN
(SELECT customer_no, -1*SUM(val_1+val_2) AS credit FROM
(SELECT b.customer_number AS customer_no,(b.credit_amount+b.debit_amount) AS val_1,SUM(a.payment) AS val_2
FROM customer_payment_detail a LEFT OUTER JOIN all_accounts_journal  b 
ON (a.elt_account_number=b.elt_account_number AND b.tran_num=a.payment_no AND b.tran_type='PMT' AND b.gl_Account_number=@gl_account_ar)
WHERE b.elt_account_number=@elt_account_number AND b.tran_date<=@selected_date
GROUP BY b.customer_number,b.credit_amount,b.debit_amount,a.payment_no
) c GROUP BY c.customer_no) e LEFT OUTER JOIN 
(SELECT * FROM invoice WHERE elt_account_number=@elt_account_number AND balance<>0 AND pay_status='A') g
 ON (g.invoice_no IS NULL AND g.elt_account_number IS NULL) 
ON (f.elt_account_number=@elt_account_number AND f.org_account_number=e.customer_no) WHERE e.credit<>0


) union_set ";
                if (strCompany != "")
                {
                    strCommandText += " WHERE customer_no=" + strCompany;
                }
                strCommandText += @"
ORDER BY customer_dba_name,customer_number,invoice_date+term_curr 

END ";

                str[2] = string.Format("Branch : {0}", strBranch);
            }
            else
            {
                /*
                strCommandText = @"SELECT * FROM (
SELECT CASE WHEN isnull(b.class_code,'') = '' THEN b.dba_name ELSE b.dba_name + ' [' + RTRIM(LTRIM(isnull(b.class_code,''))) + ']' END as customer_dba_name,
b.business_phone,0 AS customer_credit,b.org_account_number AS customer_no,a.* FROM invoice a left outer join organization b 
On (a.EmailItemID = b.EmailItemID and a.customer_number = b.org_account_number) 
LEFT OUTER JOIN customer_credits c 
ON (a.EmailItemID = c.EmailItemID and a.customer_number = c.customer_no) 
WHERE a.EmailItemID=" + EmailItemID.Substring(0, 5) + @" AND (invoice_date < DATEADD(day, 1,'" + Webdatetimeedit2.Date.ToShortDateString() + @"')) 
AND balance<>0 AND not isnull(a.customer_name,'1') = '1'";
                if (strCompany != "")
                {
                    strCommandText += " AND a.customer_number=" + strCompany;
                }
                strCommandText += @" UNION ALL
SELECT CASE WHEN isnull(a.class_code,'') = '' THEN a.dba_name ELSE a.dba_name + ' [' + RTRIM(LTRIM(isnull(a.class_code,''))) + ']' END as customer_dba_name,
a.business_phone,-1*b.credit AS customer_credit,b.customer_no,c.*
FROM organization a RIGHT OUTER JOIN customer_Credits b 
ON (a.elt_Account_number=b.EmailItemID AND a.org_Account_number=b.customer_no AND ISNULL(b.credit,0)<>0)
LEFT OUTER JOIN (SELECT * FROM invoice WHERE elt_Account_number=" + EmailItemID.Substring(0, 5) + @" AND balance<>0 AND pay_status='A')  c 
ON (a.elt_Account_number=c.elt_Account_number AND a.org_account_number IS NULL) 
WHERE a.EmailItemID=" + EmailItemID.Substring(0, 5) + @" AND invoice_no IS NULL";
                if (strCompany != "")
                {
                    strCommandText += " AND a.org_Account_number=" + strCompany;
                }
                strCommandText += @") x ORDER BY customer_dba_name,customer_number,invoice_date+term_curr";
                */

                strCommandText = @"BEGIN

DECLARE @elt_account_number decimal
DECLARE @selected_date datetime
DECLARE @gl_account_ar decimal

SET @elt_account_number=" + elt_account_number.Substring(0, 5) + @"
SET @selected_date = DATEADD(day,0,'" + DateTime.Parse(Webdatetimeedit2.Text).ToShortDateString() + @"')
SET @gl_account_ar = (SELECT gl_account_number FROM gl WHERE elt_account_number=@elt_account_number AND gl_account_desc='Accounts Receivable')


SELECT * FROM (
SELECT  CASE WHEN isnull(f.class_code,'') = '' THEN f.dba_name 
ELSE f.dba_name + ' [' + RTRIM(LTRIM(isnull(f.class_code,''))) + ']' END as customer_dba_name,f.business_phone,0 AS customer_credit,d.customer_number AS customer_no,
d.elt_account_number, d.invoice_no, invoice_type, import_export, air_ocean, invoice_date, ref_no, ref_no_Our, Customer_info, Total_Pieces, 
Total_Gross_Weight, Total_Charge_Weight, Origin_Dest, origin, dest, Customer_Number, Customer_Name, shipper, consignee, entry_no, 
entry_date, Carrier, Arrival_Dept, mawb_num, hawb_num, subtotal, sale_tax, agent_profit, accounts_receivable, amount_charged, ISNULL(e.p_amt,0) AS amount_paid, 
ISNULL(e.b_amt,amount_charged) AS balance, total_cost, remarks, pay_status, term_curr, term30, term60, term90, received_amt, pmt_method, existing_credits, deposit_to, lock_ar, lock_ap,
in_memo, is_org_merged, master_invoice_no
FROM invoice d LEFT OUTER JOIN 
(SELECT a.invoice_no,a.amount_charged-SUM(ISNULL(b.payment,0)) AS b_amt, SUM(ISNULL(b.payment,0)) AS p_amt FROM invoice a 
LEFT OUTER JOIN customer_payment_detail b
ON (a.elt_account_number=b.elt_account_number AND a.invoice_no=b.invoice_no)
LEFT OUTER JOIN customer_payment c
ON (b.elt_account_number=c.elt_account_number AND b.payment_no=c.payment_no)
WHERE a.elt_account_number=@elt_account_number AND a.invoice_date<=@selected_date 
AND (c.payment_date<=@selected_date OR c.payment_date IS NULL)
GROUP BY a.invoice_no,a.amount_charged) e 
ON (d.invoice_no=e.invoice_no AND d.elt_account_number=@elt_account_number)
LEFT OUTER JOIN organization f
ON (f.elt_account_number=d.elt_account_number AND f.org_account_number=d.customer_number)
WHERE (b_amt<>0 OR b_amt IS NULL) AND invoice_date<=@selected_date AND d.elt_account_number=@elt_account_number

UNION ALL

SELECT CASE WHEN isnull(f.class_code,'') = '' THEN f.dba_name 
ELSE f.dba_name + ' [' + RTRIM(LTRIM(isnull(f.class_code,''))) + ']' END as customer_dba_name,
f.business_phone,-1*e.credit AS customer_credit,e.customer_no,
g.elt_account_number, g.invoice_no, invoice_type, import_export, air_ocean, invoice_date, ref_no, ref_no_Our, Customer_info, Total_Pieces, 
Total_Gross_Weight, Total_Charge_Weight, Origin_Dest, origin, dest, Customer_Number, Customer_Name, shipper, consignee, entry_no, 
entry_date, Carrier, Arrival_Dept, mawb_num, hawb_num, subtotal, sale_tax, agent_profit, accounts_receivable, amount_charged, amount_paid, 
balance, total_cost, remarks, pay_status, term_curr, term30, term60, term90, received_amt, pmt_method, existing_credits, deposit_to, lock_ar, lock_ap,
in_memo, is_org_merged, master_invoice_no
FROM organization f RIGHT OUTER JOIN
(SELECT customer_no, -1*SUM(val_1+val_2) AS credit FROM
(SELECT b.customer_number AS customer_no,(b.credit_amount+b.debit_amount) AS val_1,SUM(a.payment) AS val_2
FROM customer_payment_detail a LEFT OUTER JOIN all_accounts_journal  b 
ON (a.elt_account_number=b.elt_account_number AND b.tran_num=a.payment_no AND b.tran_type='PMT' AND b.gl_Account_number=@gl_account_ar)
WHERE b.elt_account_number=@elt_account_number AND b.tran_date<=@selected_date
GROUP BY b.customer_number,b.credit_amount,b.debit_amount,a.payment_no
) c GROUP BY c.customer_no) e LEFT OUTER JOIN 
(SELECT * FROM invoice WHERE elt_account_number=@elt_account_number AND balance<>0 AND pay_status='A') g
 ON (g.invoice_no IS NULL AND g.elt_account_number IS NULL) 
ON (f.elt_account_number=@elt_account_number AND f.org_account_number=e.customer_no) WHERE e.credit<>0


) union_set ";
                if (strCompany != "")
                {
                    strCommandText += " WHERE customer_no=" + strCompany;
                }
                strCommandText += @"
ORDER BY customer_dba_name,customer_number,invoice_date+term_curr 

END ";

                str[2] = string.Format("Branch Code (All) : {0}", elt_account_number.Substring(0, 5));
            }

            str[0] = string.Format("Invoice Date  :  ~ {0}",DateTime.Parse(Webdatetimeedit2.Text).ToShortDateString() );
            str[1] = string.Format("Branch Name : {0}", strlblBranch);

            Session["AsOf"] = DateTime.Parse(Webdatetimeedit2.Text).ToShortDateString();
            Session["Branch_Name"] = strlblBranch;
            Session["Branch_Code"] = elt_account_number;
            Session["strCommandText"] = strCommandText;

            //Response.Write(strCommandText);
            //Response.End();

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

        }

        protected void btnValidate_Click(object sender, System.EventArgs e)
        {
        }

        protected void goBtn_Click1(object sender, ImageClickEventArgs e)
        {
            PerformSearch();
            Session["Accounting_sSelectionParam"] = "araging";
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "RediretThis", "window.top.location.href='/Accounting/ARAging/dataready'", true);
            //Response.Redirect("ARAgingDetail.aspx?" + "WindowName=" + windowName);
        }
    }
}
