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
    /****************************************************************************************
     * Page: SearchReceivable
     * Tasks: Searches and displays payments received by customer within a given period  
     * ************************************************************************************/
    public partial class SearchReceivable : System.Web.UI.Page
    {
        private string is_checked;
        private string elt_account_number;
        public string user_id, login_name, user_right;
        protected string ConnectStr;
        protected PaymentManager pMngr;
        static public string windowName;
        public bool bReadOnly = false;
        private ArrayList BankAccountList;      
        private GLManager glMgr;
        protected DataTable dtSelectedQItems;
        protected string Default_Start_Date;
        protected string Default_End_Date;
        protected DataTable dtReceivables;

      
        protected void Page_Load(object sender, System.EventArgs e)
        {
            is_checked = "N";
            Session.LCID = 1033;
            elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
            user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
            login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
            windowName = Request.QueryString["WindowName"];
            user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
            ConnectStr = (new igFunctions.DB().getConStr());
            dtSelectedQItems = new DataTable();
            bReadOnly = new igFunctions.DB().AUTH_CHECK(elt_account_number, user_id, ConnectStr, Request.ServerVariables["URL"].ToLower(), "");
            pMngr = new PaymentManager(elt_account_number);
            Default_Start_Date = getFirstDate().ToString();
            Default_End_Date = DateTime.Now.ToString();
            string cmd = this.hCommand.Value;
            btnGo.Attributes.Add("onclick", "goNow()");
            glMgr = new GLManager(elt_account_number);
            BankAccountList = glMgr.getGLAcctList(Account.BANK);

            if (!IsPostBack)
            {

                ddlBankAcct.DataSource = BankAccountList;
                ddlBankAcct.DataTextField = "Gl_account_desc";
                ddlBankAcct.DataValueField = "Gl_account_number";
                ddlBankAcct.DataBind();
            }
            else
            {

                if (cmd == "GO")
                {
                    hCommand.Value = "";
                    searchData();
                }
            }
            hCommand.Value = "";
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


        #region Web Form 디자이너에서 생성한 코드
        override protected void OnInit(EventArgs e)
        {
            InitializeComponent();
            base.OnInit(e);
        }
        private void InitializeComponent()
        {

        }
        #endregion
       
        protected void searchData()
        {
            string start = Webdatetimeedit1.Text;
            string end = Webdatetimeedit2.Text;
            string vendorAcct = hCustomerAcct.Value;
            Session["orgId"] = vendorAcct;
            int vendorID = Int32.Parse(vendorAcct);
            if (start == "") start = Default_Start_Date;
            if (end == "") end = Default_End_Date;
            dtReceivables = null;
            Decimal money = 0;
            try
            {
                money = Decimal.Parse(this.txtAmount.Text);
            }
            catch
            {
                money = 0;
            }
            dtReceivables = pMngr.getPaymentDTwithinPeriod(start, end, vendorID, txtRefNo.Text, Int32.Parse(this.ddlBankAcct.SelectedValue), this.ddlPaymethod.SelectedValue, money);
            this.GridView1.PageIndex = 0;
            BindData(dtReceivables);
        }
      
        protected void BindData(DataTable dtReceivables)
        {
            this.GridView1.DataSource = dtReceivables.DefaultView;
            this.GridView1.DataBind();
            int startIndex = GridView1.PageIndex * 10;
            Session["dtReceivables"] = dtReceivables;

        }
      
        protected void Delete(object sender, CommandEventArgs e)
        {
            DataTable dtReceivables = (DataTable)Session["dtReceivables"];
            BindData(dtReceivables);
            try
            {
                int index = Int32.Parse(e.CommandArgument.ToString());
                index += this.GridView1.PageIndex * 10;
                int payment_no = Int32.Parse(dtReceivables.Rows[index]["payment_no"].ToString());

                PaymentRecord pRec = pMngr.getcustomerPaymentRecord(payment_no);
                pMngr.CancelPayment(pRec, "PMT", is_checked);
                dtReceivables.Rows.Remove(dtReceivables.Rows[index]);
                Session["dtReceivables"] = dtReceivables;
                this.GridView1.DataSource = dtReceivables.DefaultView;
                this.GridView1.DataBind();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            Session["dtReceivables"] = dtReceivables;
        }

        protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridView1.PageIndex = e.NewPageIndex;
            DataTable dtReceivables = (DataTable)Session["dtReceivables"];
            BindData(dtReceivables);

        }
     
        protected void CreditBack(object sender, CommandEventArgs e)
        {
            is_checked = "Y";
            Delete(sender, e);
        }

    }

}
