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
    public partial class SearchRefundOrCredit : System.Web.UI.Page
    {
        private string is_checked;
        private string elt_account_number;
        public string user_id, login_name, user_right;
        protected string ConnectStr;
        protected CustomerCreditManager cMgr;
        static public string windowName;
        public bool bReadOnly = false;
        protected DataTable dtSelectedQItems;
        protected string Default_Start_Date;
        protected string Default_End_Date;
        protected DataTable dtCreditRecord;

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
            cMgr = new CustomerCreditManager(elt_account_number);
            Default_Start_Date = getFirstDate().ToString();
            Default_End_Date = DateTime.Now.ToString();
            string cmd = this.hCommand.Value;
            btnGo.Attributes.Add("onclick", "goNow()");

            if (!IsPostBack)
            {

            }
            else
            {
                if (cmd == "GET_IT")
                {
                    //searchData();
                }
                else if (cmd == "GO")
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
            dtCreditRecord = null;
            dtCreditRecord = cMgr.getCreditRecordDTwithinPeriod(start, end, vendorID,txtRefNo.Text,this.txtInvNo.Text,chkRefundOnly.Checked);
            this.GridView1.PageIndex = 0;
            BindData(dtCreditRecord);
        }

        protected void BindData(DataTable dtCreditRecord)
        {
            this.GridView1.DataSource = dtCreditRecord.DefaultView;
            this.GridView1.DataBind();
            int startIndex = GridView1.PageIndex * 10;

            Session["dtCreditRecord"] = dtCreditRecord;

        }

       

        protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {          
            GridView1.PageIndex = e.NewPageIndex;
            DataTable dtCreditRecord = (DataTable)Session["dtCreditRecord"];
            BindData(dtCreditRecord);

        }

       

    }

}
