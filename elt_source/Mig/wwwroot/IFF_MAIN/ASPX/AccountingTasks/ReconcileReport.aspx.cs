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
    public partial class ReconcileReport : System.Web.UI.Page
    {
        private string elt_account_number;
        public string user_id, login_name, user_right;
        protected string ConnectStr;
        static public string windowName;
        public bool bReadOnly = false;
        protected string Default_Start_Date;
        protected string Default_End_Date;
        private ArrayList BankAccountList;
        private GLManager glMgr;
        private ReconcileManager rcMgr;
        private DataTable dtReconcile;
        protected void Page_Load(object sender, System.EventArgs e)
        {
            Session.LCID = 1033;

            elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
            user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
            login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
            windowName = Request.QueryString["WindowName"];
            user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
            ConnectStr = (new igFunctions.DB().getConStr());

            bReadOnly = new igFunctions.DB().AUTH_CHECK(elt_account_number, user_id, ConnectStr, Request.ServerVariables["URL"].ToLower(), "");
            Default_Start_Date = getFirstDate().ToString();
            Default_End_Date = DateTime.Now.ToString();

            glMgr = new GLManager(elt_account_number);
            BankAccountList = glMgr.getGLAcctList(Account.BANK);

            rcMgr = new ReconcileManager(elt_account_number);

            if (!IsPostBack)
            {
                this.ddlBankAcct.DataSource = BankAccountList;
                this.ddlBankAcct.DataTextField = "Gl_account_desc";
                this.ddlBankAcct.DataValueField = "Gl_account_number";
                this.ddlBankAcct.DataBind();
            }
            else
            {

            }

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
            dtReconcile = rcMgr.getAllReconcileDT(Int32.Parse(ddlBankAcct.SelectedValue));
            Session["dtReconcile"] = dtReconcile;
            BindData();
        }

        protected void BindData()
        {
            dtReconcile = (DataTable)Session["dtReconcile"];
            this.ddlBankAcct.DataSource = dtReconcile;
        }


        protected void ddlBankAcct_SelectedIndexChanged(object sender, EventArgs e)
        {
            searchData();
        }
    }

}
