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
    public partial class CancelPayable : System.Web.UI.Page
	{		
		private string elt_account_number;
		public string user_id,login_name,user_right;
        protected string ConnectStr;
        protected CheckQueueManager qMngr;
        static public string windowName;
        public bool bReadOnly = false;
        protected DataTable dtSelectedQItems;
        protected string Default_Start_Date;
        protected string Default_End_Date;
        protected DataTable dtPayables;

        private ArrayList BankAccountList;
        private GLManager glMgr;
     /************************************************************************************
     * Method:
     * Purpose:
     * 
     * *********************************************************************************/
     	protected void Page_Load(object sender, System.EventArgs e)
		{
          
			Session.LCID = 1033;           
			elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
			user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
			login_name  = Request.Cookies["CurrentUserInfo"]["login_name"];
            windowName = Request.QueryString["WindowName"];
            user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
            ConnectStr = (new igFunctions.DB().getConStr());            
            dtSelectedQItems = new DataTable();
			bReadOnly = new igFunctions.DB().AUTH_CHECK(elt_account_number, user_id, ConnectStr, Request.ServerVariables["URL"].ToLower(), "");
            qMngr = new CheckQueueManager(elt_account_number);            
            Default_Start_Date=getFirstDate().ToString();
            Default_End_Date=DateTime.Now.ToString();
            glMgr = new GLManager(elt_account_number);
            BankAccountList = glMgr.getGLAcctList(Account.BANK);

            string cmd = this.hCommand.Value;
            btnGo.Attributes.Add("onclick", "goNow()");          
           
            if (!IsPostBack)
            {
                this.ddlBankAcct.DataSource = BankAccountList;
                this.ddlBankAcct.DataTextField = "Gl_account_desc";
                this.ddlBankAcct.DataValueField = "Gl_account_number";
                this.ddlBankAcct.DataBind();
            }
            else
            {
               
               if(cmd=="GO")
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
			daysToAdd = System.DateTime.DaysInMonth(int.Parse(sd.Year.ToString()),int.Parse(sd.Month.ToString())) - int.Parse(sd.Day.ToString());
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
            string vendorAcct = hVendorAcct.Value;
            Session["orgId"] = vendorAcct;
            int vendorID = Int32.Parse(vendorAcct);
            if (start == "") start = Default_Start_Date;
            if (end == "") end = Default_End_Date;
            dtPayables = null;
            Decimal money = 0;
            try
            {
                money = Decimal.Parse(this.txtAmount.Text);
            }
            catch
            {
                money = 0;
            }
            dtPayables = qMngr.getCheckQueueDTwithinPeriod(start, end, vendorID, this.txtCheckNo.Text, this.txtRefNo.Text, Int32.Parse(this.ddlBankAcct.SelectedValue), this.ddlPaymethod.SelectedValue, money);
            this.GridView1.PageIndex = 0;
            BindData(dtPayables);
        }

       
        protected void BindData(DataTable dtPayables)
        {                   
            this.GridView1.DataSource = dtPayables.DefaultView;
            this.GridView1.DataBind();
            //for (int i = 0; i < GridView1.Rows.Count; i++)
            //{
            //    ((ImageButton)GridView1.Rows[i].FindControl("btnDelete")).Attributes.Add("onclick", "cancelClicked(this)");
            //}
            int startIndex = GridView1.PageIndex * 10;
          
            Session["dtPayables"] = dtPayables;
            
        }

     
        protected void Delete(object sender, CommandEventArgs e)
        {
           
                DataTable dtPayables = (DataTable)Session["dtPayables"];
                BindData(dtPayables);
                try
                {
                    int index = Int32.Parse(e.CommandArgument.ToString());
                    index += this.GridView1.PageIndex * 10;
                    int print_id = Int32.Parse(dtPayables.Rows[index]["print_id"].ToString());
                    CheckQueueRecord cRecord = qMngr.getcheckQueue(print_id);
                    string tran_type = "";
                    if (cRecord.check_type == "C")
                    {
                        tran_type = "CHK";
                    }
                    else
                    {
                        tran_type = "BP-CHK";
                    }
                    qMngr.CancelPayment(print_id, tran_type);

                    dtPayables.Rows.Remove(dtPayables.Rows[index]);
                    Session["dtPayables"] = dtPayables;
                    this.GridView1.DataSource = dtPayables.DefaultView;
                    this.GridView1.DataBind();
                }
                catch (Exception ex)
                {
                    throw ex;
                }
                Session["dtPayables"] = dtPayables;
           
        }

       
        protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {     
            DataTable dtPayables = (DataTable)Session["dtPayables"];
            GridView1.PageIndex = e.NewPageIndex;
            BindData(dtPayables);            
        }
        
}

}
