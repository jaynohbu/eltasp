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
    public partial class SearchInvoiceSelection : System.Web.UI.Page
	{		
		private string elt_account_number;
		public string user_id,login_name,user_right;
        protected string ConnectStr;
        protected IVQManager qMngr;
        static public string windowName;
        public bool bReadOnly = false;
        protected DataTable dtSelectedQItems;
        protected string Default_Start_Date;
        protected string Default_End_Date;
        protected DataSet dsIVQ;

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
            qMngr = new IVQManager(elt_account_number);            
            Default_Start_Date=getFirstDate().ToString();
            Default_End_Date=DateTime.Now.ToString();
            string cmd = this.hCommand.Value;
           // this.btnGo.Visible = false;
            btnGo.Attributes.Add("onclick", "goNow()");

            if (Session["QlistSelected"] != null)
            {
                cmd = "";
                Session["QlistSelected"]=null;                
                GridView1.DataSource = null;               
            }
           
            if (!IsPostBack)
            {
                searchData();
            }
            else
            {
                if (cmd == "GET_IT")
                {
                    searchData();                   
                }
                else if(cmd=="GO")
                {
                    hCommand.Value = "";                   
                    prepareSelected_and_go();                   
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
            string cstAcct = hCustomerAcct.Value;
            Session["orgId"] = cstAcct;
            int custId = Int32.Parse(cstAcct);
            if (start == "") start = Default_Start_Date;
            if (!IsPostBack) start = "01/01/2000";
            if (end == "") end = Default_End_Date;
            dsIVQ = null;
            dsIVQ = qMngr.getEntriesForCustomer(custId, start, end);
            this.GridView1.PageIndex = 0;
            BindData(dsIVQ);
            Session["orgId"] = 0;
        }

        protected void BindData(DataSet dsIVQ)
        {
            rebind(dsIVQ);
            
            if (dsIVQ.Tables[0].Rows.Count > 0)
            {
                this.btnGo.Visible = true;
            }
            int startIndex = GridView1.PageIndex * 20;
            try
            {
                for (int i = 0; i < GridView1.Rows.Count; i++)
                {
                    System.Web.UI.WebControls.Image btnCheck = ((System.Web.UI.WebControls.Image)GridView1.Rows[i].FindControl("btnCheck"));

                    HiddenField hCheck = ((HiddenField)GridView1.Rows[i].FindControl("hCheck"));
                    btnCheck.Attributes.Add("onclick", "checkClicked(this," + hCheck.ClientID + ")");

                    if (dsIVQ.Tables[0].Rows[startIndex]["is_selected"].ToString() == "0")
                    {
                        btnCheck.ImageUrl = "~/ASPX/AccountingTasks/images/mark_o.gif";
                        hCheck.Value = "images/mark_o.gif";
                    }
                    else if (dsIVQ.Tables[0].Rows[startIndex]["is_selected"].ToString() == "1")
                    {
                        btnCheck.ImageUrl = "~/ASPX/AccountingTasks/images/mark_x.gif";
                        hCheck.Value = "images/mark_x.gif";
                    }
                    startIndex++;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            Session["dsIVQ"] = dsIVQ;
            
        }

        protected void prepareSelected_and_go()
        {
            ArrayList listSelected = new ArrayList();
            dsIVQ = (DataSet)Session["dsIVQ"];
            IVQRecord aRecord;
            string firstAgent = "";
            bool flag = true;
            int count = 0;

            getCheckedFromScreen(this.GridView1.PageIndex);//first page could be missing !
            this.BindData(dsIVQ);

            this.qMngr.getHeaderInfoForSelection(ref dsIVQ);
            GeneralUtility gUtil = new GeneralUtility();
            DataTable dt = dsIVQ.Tables[0];
            for (int i = 0; i < dsIVQ.Tables[0].Rows.Count; i++)
            {
                if (dsIVQ.Tables[0].Rows[i]["is_selected"].ToString() == "1")
                {
                    count++;
                    if (flag)
                    {
                        firstAgent = dsIVQ.Tables[0].Rows[i]["bill_to_org_acct"].ToString();
                        flag = false;
                    }
                    if (firstAgent == dsIVQ.Tables[0].Rows[i]["bill_to_org_acct"].ToString())
                    {
                        aRecord = new IVQRecord();

                        gUtil.removeNull(ref dt);
                        try
                        {
                            aRecord.Queue_id = Int32.Parse(dsIVQ.Tables[0].Rows[i]["queue_id"].ToString());
                            aRecord.Agent_name = dsIVQ.Tables[0].Rows[i]["agent_name"].ToString();
                            aRecord.Agent_org_acct = Int32.Parse(dsIVQ.Tables[0].Rows[i]["agent_org_acct"].ToString());
                            aRecord.Agent_shipper = dsIVQ.Tables[0].Rows[i]["agent_shipper"].ToString();
                            aRecord.Air_ocean = dsIVQ.Tables[0].Rows[i]["air_ocean"].ToString();
                            aRecord.Master_agent = dsIVQ.Tables[0].Rows[i]["master_agent"].ToString();
                            aRecord.Master_only = dsIVQ.Tables[0].Rows[i]["master_only"].ToString();
                            aRecord.Hawb_num = dsIVQ.Tables[0].Rows[i]["hawb_num"].ToString();
                            aRecord.Mawb_num = dsIVQ.Tables[0].Rows[i]["mawb_num"].ToString();
                            aRecord.Bill_to = dsIVQ.Tables[0].Rows[i]["bill_to"].ToString();
                            aRecord.Bill_to_org_acct = Int32.Parse(dsIVQ.Tables[0].Rows[i]["bill_to_org_acct"].ToString());
                            aRecord.Consignee = dsIVQ.Tables[0].Rows[i]["Consignee"].ToString();
                            aRecord.Shipper = dsIVQ.Tables[0].Rows[i]["Shipper"].ToString();
                            aRecord.FileNo = dsIVQ.Tables[0].Rows[i]["FILE"].ToString();
                            aRecord.Pieces = Int32.Parse(dsIVQ.Tables[0].Rows[i]["Pieces"].ToString());
                            aRecord.Gross_weight = Decimal.Parse(dsIVQ.Tables[0].Rows[i]["GrossWeight"].ToString());
                            aRecord.Chargeable_weight = Decimal.Parse(dsIVQ.Tables[0].Rows[i]["ChargeableWeight"].ToString());
                            aRecord.origin = dsIVQ.Tables[0].Rows[i]["Origin"].ToString();
                            aRecord.destination = dsIVQ.Tables[0].Rows[i]["Destination"].ToString();
                            aRecord.carrier = dsIVQ.Tables[0].Rows[i]["Carrier"].ToString();
                            aRecord.ETA = dsIVQ.Tables[0].Rows[i]["ETA"].ToString();
                            aRecord.ETD = dsIVQ.Tables[0].Rows[i]["ETD"].ToString();
                        }
                        catch (Exception ex) { throw ex; }
                        listSelected.Add(aRecord);
                    }
                    else
                    {
                        string script = "<script language='javascript'>";
                        script += "alert('You cannot choose differnt bill to party for a invoice!');";
                        script += "</script>";
                        this.ClientScript.RegisterClientScriptBlock(this.GetType(), "PreLoad", script);
                        listSelected.Clear();

                        //for (int j = 0; j < dsIVQ.Tables[0].Rows.Count; j++)
                        //{
                        //    dsIVQ.Tables[0].Rows[j]["is_selected"] = 0;

                        //}
                        Session["dsIVQ"] = dsIVQ;
                        return;
                    }
                }
            }


            if (count < 1)
            {
                string script = "<script language='javascript'>";
                script += "alert('You must select at least one item!');";
                script += "</script>";
                this.ClientScript.RegisterClientScriptBlock(this.GetType(), "PreLoad", script);
                listSelected.Clear();
                return;
            }
            this.hCommand.Value = "";
            Session["dsIVQ"] = dsIVQ;
            Session["QlistSelected"] = listSelected;

            if (count > 1)
            {
                string script2 = "<script language='javascript'>";

                script2 += "if(confirm('Invoice created on multiple operation will not contain header information!')){";
                script2 += "form1.method='Post';";
                script2 += "form1.action='edit_invoi.aspx';";
                script2 += "form1.__VIEWSTATE.name = 'NOVIEWSTATE';";
                script2 += "form1.submit();";
                script2 += "}";
                script2 += "</script>";
                Session["from_queue"] = "Y";
                this.ClientScript.RegisterClientScriptBlock(this.GetType(), "PreLoad", script2);
            }
            else
            {



                string script2 = "<script language='javascript'>";
                script2 += "form1.method='Post';";
                script2 += "form1.action='edit_invoi.aspx';";
                script2 += "form1.__VIEWSTATE.name = 'NOVIEWSTATE';";
                script2 += "form1.submit();";
                script2 += "</script>";
                Session["from_queue"] = "Y";
                this.ClientScript.RegisterClientScriptBlock(this.GetType(), "PreLoad", script2);
            }
            //Response.Redirect("edit_invoi.aspx");
        }

        protected void getCheckedFromScreen(int pageIndex)
        {          
            dsIVQ = (DataSet)Session["dsIVQ"];
            int Index = pageIndex * 20;

            for (int i = 0; i < GridView1.Rows.Count; i++)
            {
                if (Request[((HiddenField)GridView1.Rows[i].FindControl("hCheck")).UniqueID] == "images/mark_x.gif")
                {
                    dsIVQ.Tables[0].Rows[Index]["is_selected"] = 1;
                }
                else if(Request[((HiddenField)GridView1.Rows[i].FindControl("hCheck")).UniqueID] == "images/mark_o.gif")
                {
                    dsIVQ.Tables[0].Rows[Index]["is_selected"] = 0;
                }
                Index++;
            }
             Session["dsIVQ"]=dsIVQ;
        }
        //PLESE KEEP THIS FOR REFERENCE------------------------------------------------------
        //protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
        //{
        //    GridView1.PageIndex = e.NewPageIndex;            
        //    BindData(1);          
        //}-----------------------------------------------------------------------------------


     
        protected void Delete(object sender, CommandEventArgs e)
        {
            DataSet dsIVQ = (DataSet)Session["dsIVQ"];
            BindData(dsIVQ);
            try
            {
                int index = Int32.Parse(e.CommandArgument.ToString());

                IVQRecord aRecord = new IVQRecord();
                aRecord.Queue_id = Int32.Parse(dsIVQ.Tables[0].Rows[index]["queue_id"].ToString());
                this.qMngr.deleteIVQRecord(aRecord);
                dsIVQ.Tables[0].Rows.RemoveAt(index);
                Session["dsIVQ"] = dsIVQ;
                BindData(dsIVQ);
               // this.GridView1.DataSource = dsIVQ.Tables[0].DefaultView;
                //this.GridView1.DataBind();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            Session["dsIVQ"] = dsIVQ;     
        }


        protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {                      
            getCheckedFromScreen(GridView1.PageIndex);           
            GridView1.PageIndex = e.NewPageIndex;
            dsIVQ = (DataSet)Session["dsIVQ"];
            BindData(dsIVQ);
            
        }

        
        protected void ddlSortBy_SelectedIndexChanged(object sender, EventArgs e)
        {
            dsIVQ = (DataSet)Session["dsIVQ"];
            this.BindData(dsIVQ);
        }

       
        protected void rebind(DataSet dsIVQ)
        {
            DataTable dtFinalResult = dsIVQ.Tables[0];
            DataView dv = new DataView(dtFinalResult);
            switch (this.ddlSortBy.SelectedIndex)
            {
                case 1: dv.Sort = "mawb_num asc"; break;
                case 2: dv.Sort = "hawb_num asc"; break;
                case 3: dv.Sort = "bill_to"; break;
                case 4: dv.Sort = "air_ocean";  break;
                case 5: dv.Sort = "agent_name";  break;
                default: dv.Sort = "mawb_num"; break;
            }

            this.GridView1.DataSource = dv;
            this.GridView1.DataBind();
            dsIVQ.Tables.Clear();
            dsIVQ.Tables.Add(dv.ToTable());
        }
}
}
