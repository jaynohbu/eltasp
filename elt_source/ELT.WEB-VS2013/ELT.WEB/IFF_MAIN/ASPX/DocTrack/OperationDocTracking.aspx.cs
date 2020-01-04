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


namespace IFF_MAIN.ASPX.DocTrack
{

    public partial class OperationDocTracking : System.Web.UI.Page
	{
		public string elt_account_number;
		public string user_id,login_name,user_right;
        string timeStart; 
        string timeEnd;
        protected string ConnectStr;
        public string windowName;
        protected DataSet ds;
        protected DataSet ds_No_Hawb;
        protected TreeView tree;

       
        private string AO="";
  
        protected void Page_Load(object sender, System.EventArgs e)
		{
           
			Session.LCID = 1033;
            windowName = Request.QueryString["WindowName"];
            elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];			
            user_id  = Request.Cookies["CurrentUserInfo"]["user_id"];
			user_right = Request.Cookies["CurrentUserInfo"]["user_right"];			
            login_name  = Request.Cookies["CurrentUserInfo"]["login_name"];		

            ConnectStr = (new igFunctions.DB().getConStr());
            timeStart = Webdatetimeedit1.Date.ToShortDateString();
            timeEnd = Webdatetimeedit2.Date.ToShortDateString();
            

            if(!IsPostBack){	
		        if(txtRefNo.Text!=""){
                    iBtnGo.Attributes.Add("onclick", "Javascript:return CheckDate();");
                }
			}
		}           
   
        protected void iBtnGo_Click(object sender, ImageClickEventArgs e)
        {

           
            if (this.ddlRefType.SelectedValue == "HAWB No.")
            {
                HAWBTracker tracker = new HAWBTracker(elt_account_number, ConnectStr);
                ds = tracker.trackDoc(this.txtRefNo.Text, timeStart, timeEnd);
                AO = "A";
            }
            else if (this.ddlRefType.SelectedValue == "MAWB No.")
            {
                MAWBTracker tracker = new MAWBTracker(elt_account_number, ConnectStr);
                ds = tracker.trackDoc(this.txtRefNo.Text, timeStart, timeEnd);
                AO = "A";

            }

            if (this.ddlRefType.SelectedValue == "House B/L No.")
            {
                HBOLTracker tracker = new HBOLTracker(elt_account_number, ConnectStr);
                ds = tracker.trackDoc(this.txtRefNo.Text, timeStart, timeEnd);
                AO = "O";
            }
            else if (this.ddlRefType.SelectedValue == "Master B/L No.")
            {
                MBOLTracker tracker = new MBOLTracker(elt_account_number, ConnectStr);
                ds = tracker.trackDoc(this.txtRefNo.Text, timeStart, timeEnd);
                AO = "O";

            }

            if (ds.Tables.Count > 0)
            {

                if (AO == "A")
                {
                    fillHtmlTables_Air();
                    this.pnlResult.Controls.Add(tree);
                  
                }
                else if (AO == "O")
                {
                    fillHtmlTables_Ocean();
                    this.pnlResult.Controls.Add(tree);
                   
                }

            }
        }    


		private void performDateDefault()
		{
			
			//			this.Button1.Attributes.Add("onMouseDown", "Javascript:checkDate();");

			//			Webdatetimeedit1.Date = getFirstDate();
			//			Webdatetimeedit2.Date = DateTime.Now;
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



		override protected void OnInit(EventArgs e)
		{
			InitializeComponent();
			base.OnInit(e);
		}
		
		private void InitializeComponent()
		{
            //this.iBtnGo.Click += new System.Web.UI.ImageClickEventHandler(this.iBtnGo_Click);

		}


        protected void fillHtmlTables_Air()
        {
            tree = new TreeView();
            string pky = "";
           
            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                string MAWB = ds.Tables[0].Rows[i]["MAWB#"].ToString();
                string date = "";
                string MAWB_IE = ds.Tables[0].Rows[i]["IE"].ToString();
                date = ds.Tables["MAWB"].Rows[i]["Date Issued"].ToString().Split()[0];
                pky = ds.Tables["MAWB"].Rows[i]["Primary"].ToString();
                DataRow[] HAWB_drs = ds.Tables["HAWB"].Select("Foreign = '" + pky + "'");
                TreeNode MAWBnode = new TreeNode();
               
                for (int j = 0; j < HAWB_drs.Length; j++)
                {
                    string HAWB = HAWB_drs[j]["HAWB#"].ToString();
                    string date_HAWB = "";
                    date_HAWB = HAWB_drs[j]["Date Issued"].ToString().Split()[0];
                    string HAWB_IE = HAWB_drs[j]["IE"].ToString();
                    DataRow[] iv_drs = ds.Tables["IV"].Select("Foreign = '" + HAWB_drs[j]["Primary"].ToString() + "'");
                    TreeNode HAWBnode = new TreeNode();

                    for (int k = 0; k < iv_drs.Length; k++)
                    {
                        string iv = iv_drs[k]["IV#"].ToString();
                        string date_iv = "";
                        date_iv = iv_drs[k]["Date Issued"].ToString().Split()[0];
                        DataRow[] rp_drs = ds.Tables["RP"].Select("Foreign = '" + iv_drs[k]["Primary"].ToString() + "'");
                        TreeNode IVnode = new TreeNode();
                    
                        foreach (DataRow dr in rp_drs)
                        {
                            string rp = dr["RP#"].ToString();
                            string amount = dr["Paid"].ToString();
                            string date_rp = "";
                            date_rp = dr["Date Issued"].ToString().Split()[0];
                            TreeNode RPnode = new TreeNode();
                            LinkItem tr_rp = getRP_Item(rp, amount, date_rp);
                            
                            RPnode.ImageUrl=tr_rp.getImage();
                            RPnode.Text = tr_rp.getText();
                            RPnode.NavigateUrl=tr_rp.getLink();
                           
                            IVnode.ChildNodes.Add(RPnode);                           
                        }
                        LinkItem tr_iv = getIV_Item(iv, date_iv);
                        
                        IVnode.ImageUrl = tr_iv.getImage();
                        IVnode.Text = tr_iv.getText();
                        IVnode.NavigateUrl = tr_iv.getLink();

                        if (HAWB_drs[j]["MAWB#"].ToString() == iv_drs[k]["MAWB#"].ToString())
                        {
                            bool check = true;
                            for (int m = 0; m < HAWBnode.ChildNodes.Count; m++)
                            {
                                if (HAWBnode.ChildNodes[m].Text == IVnode.Text)
                                {
                                    check = false;
                                }
                            }
                            if (check)
                            {
                                HAWBnode.ChildNodes.Add(IVnode);
                            }
                        }
                    }

                    LinkItem tr_HAWB = getHAWB_Item(HAWB, date_HAWB, HAWB_IE, MAWB);
                    HAWBnode.ImageUrl = tr_HAWB.getImage();
                    HAWBnode.Text = tr_HAWB.getText();
                    HAWBnode.NavigateUrl = tr_HAWB.getLink();
                    if (HAWBnode.NavigateUrl != "")
                    {
                        MAWBnode.ChildNodes.Add(HAWBnode);
                    }
                }
                
                LinkItem tr_MAWB = getMAWB_Item(MAWB, date, MAWB_IE);
                MAWBnode.ImageUrl = tr_MAWB.getImage();
                MAWBnode.Text = tr_MAWB.getText();
                MAWBnode.NavigateUrl = tr_MAWB.getLink();
                
                tree.Nodes.Add(MAWBnode);
            }
           // tree.ExpandAll();
           
        }

        protected void fillHtmlTables_Ocean()
        {
            tree = new TreeView();
            string pky = "";

            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                string MBOL = ds.Tables[0].Rows[i]["MBOL#"].ToString();
                string date = "";
                string MBOL_IE = ds.Tables[0].Rows[i]["IE"].ToString();
                date = ds.Tables["MBOL"].Rows[i]["Date Issued"].ToString().Split()[0];
                pky = ds.Tables["MBOL"].Rows[i]["Primary"].ToString();
                DataRow[] HBOL_drs = ds.Tables["HBOL"].Select("Foreign = '" + pky + "'");
                TreeNode MBOLnode = new TreeNode();
                for (int j = 0; j < HBOL_drs.Length; j++)
                {
                    string HBOL = HBOL_drs[j]["HBOL#"].ToString();
                    string date_HBOL = "";
                    date_HBOL = HBOL_drs[j]["Date Issued"].ToString().Split()[0];
                    string HBOL_IE = HBOL_drs[j]["IE"].ToString();
                    DataRow[] iv_drs = ds.Tables["IV"].Select("Foreign = '" + HBOL_drs[j]["Primary"].ToString() + "'");
                    TreeNode HBOLnode = new TreeNode();
                    for (int k = 0; k < iv_drs.Length; k++)
                    {
                        string iv = iv_drs[k]["IV#"].ToString();
                        string date_iv = "";
                        date_iv = iv_drs[k]["Date Issued"].ToString().Split()[0];
                        DataRow[] rp_drs = ds.Tables["RP"].Select("Foreign = '" + iv_drs[k]["Primary"].ToString() + "'");
                        TreeNode IVnode = new TreeNode();
                        foreach (DataRow dr in rp_drs)
                        {
                            string rp = dr["RP#"].ToString();
                            string amount = dr["Paid"].ToString();
                            string date_rp = "";
                            date_rp = dr["Date Issued"].ToString().Split()[0];
                            TreeNode RPnode = new TreeNode();
                            LinkItem tr_rp = getRP_Item(rp, amount, date_rp);

                            RPnode.ImageUrl = tr_rp.getImage();
                            RPnode.Text = tr_rp.getText();
                            RPnode.NavigateUrl = tr_rp.getLink();

                            IVnode.ChildNodes.Add(RPnode);
                        }
                        LinkItem tr_iv = getIV_Item(iv, date_iv);
                        
                        IVnode.ImageUrl = tr_iv.getImage();
                        IVnode.Text = tr_iv.getText();
                        IVnode.NavigateUrl = tr_iv.getLink();
                        if (HBOL_drs[j]["MBOL#"].ToString() == iv_drs[k]["MBOL#"].ToString())
                        {
                            bool check = true;
                            for (int m = 0; m < HBOLnode.ChildNodes.Count; m++)
                            {
                                if (HBOLnode.ChildNodes[m].Text == IVnode.Text)
                                {
                                    check = false;
                                }
                            }
                            if (check)
                            {
                                HBOLnode.ChildNodes.Add(IVnode);
                            }
                        }
                    }

                    LinkItem tr_HBOL = getHBOL_Item(HBOL, date_HBOL, HBOL_IE, MBOL);
                    

                    HBOLnode.ImageUrl = tr_HBOL.getImage();
                    HBOLnode.Text = tr_HBOL.getText();
                    HBOLnode.NavigateUrl = tr_HBOL.getLink();
                    if (HBOLnode.NavigateUrl != "")
                    {
                        MBOLnode.ChildNodes.Add(HBOLnode);
                    }
                }
                
                LinkItem tr_MBOL = getMBOL_Item(MBOL, date, MBOL_IE);
                MBOLnode.ImageUrl = tr_MBOL.getImage();
                MBOLnode.Text = tr_MBOL.getText();
                MBOLnode.NavigateUrl = tr_MBOL.getLink();
                tree.Nodes.Add(MBOLnode);
                
            }
            //tree.ExpandAll();
          
       
        }

        protected LinkItem getMAWB_Item(string MAWB, string date, string IE)
        {
            string formatDate = "";
            if (date != "") formatDate = "    Date Issued:" + date + "";
            string url = "";
            if (IE == "E") url = "/ASP/air_export/new_edit_mawb.asp?Edit=yes&mawb=" + MAWB;
            else if (IE == "I") url = "/ASP/air_import/air_import2.asp?iType=A&Edit=yes&MAWB=" + MAWB;
            LinkItem item = new LinkItem("MAWB No.:"+MAWB + formatDate, url, "");
            return item; 
        }
        protected LinkItem getMBOL_Item(string MBOL, string date, string IE)
        {
            string formatDate = "";
            if (date != "") formatDate = "    Date Issued:" + date + "";
            string url = "";
            if (IE == "E") url = "/ASP/ocean_export/new_edit_mbol.asp?BookingNum=" + MBOL;
            else if (IE == "I") url = "/ASP/ocean_import/ocean_import2.asp?iType=O&Edit=yes&MAWB=" + MBOL;
            LinkItem item = new LinkItem("Master B/L No.:"+MBOL + formatDate, url, "");
            return item; 
        }
        protected LinkItem getHAWB_Item(string HAWB, string date, string IE, string MAWB)
        {
            string formatDate = "";
            if (date != "") formatDate = "    Date Issued:" + date + "";
            string url = "";
            if (IE == "E") url = "/ASP/air_export/new_edit_hawb.asp?Edit=yes&hawb=" + HAWB;
            else if (IE == "I") url = "/ASP/air_import/arrival_notice.asp?iType=A&Edit=yes&HAWB=" + HAWB + "&MAWB=" + MAWB;
            LinkItem item = new LinkItem("HAWB No.:"+HAWB + formatDate, url, "");
            return item; 
        }

        protected LinkItem getHBOL_Item(string HBOL, string date, string IE, string MBOL)
        {
            string formatDate = "";
            if (date != "") formatDate = "    Date Issued:" + date + "";
            string url = "";
            if (IE == "E") url = "/ASP/ocean_export/new_edit_hbol.asp?hbol=" + HBOL;
            else if (IE == "I") url = "/ASP/ocean_import/arrival_notice.asp?iType=O&Edit=yes&HAWB=" + HBOL + "&MAWB=" + MBOL;
            LinkItem item = new LinkItem("House B/L No.:"+HBOL + formatDate, url, "");
            return item; 
        }

        protected LinkItem getIV_Item(string iv, string date)
        {
            string formatDate = "";
            if (date != "") formatDate = "    Date Issued:" + date + "";
            string url = "../..//ASP/acct_tasks/edit_invoice.asp?edit=yes&InvoiceNo=" + iv;
            LinkItem item = new LinkItem("Invoice No.:"+iv + formatDate, url, "");
            return item;
        }

        protected LinkItem getRP_Item(string rp, string amount, string date)
        {
            string formatDate = "";
            if (date != "") formatDate = " (" + date + ")";
            string url = "/ASP/acct_tasks/receiv_pay.asp?PaymentNo=" + rp;
            LinkItem item = new LinkItem("Payment:"+rp + formatDate+ "  Amount Received:"+amount, url, "");
            return item;
        }
 
    }
}
