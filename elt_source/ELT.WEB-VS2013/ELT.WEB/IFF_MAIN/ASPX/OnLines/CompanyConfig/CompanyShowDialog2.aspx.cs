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
using Infragistics.WebUI.UltraWebGrid;
using System.IO;
using System.Configuration;


namespace IFF_MAIN.ASPX.OnLines.CompanyConfig
{
	/// <summary>
	/// CompanyShowDialog�� ���� ��� �����Դϴ�.
	/// </summary>
	public partial class CompanyShowDialog2 : System.Web.UI.Page
	{

		//***********************************************************//
		string ParentPage = "CompanyConfigCreate.aspx";
		string ParentTable = "organization";
		
		public string elt_account_number;
		public string user_id;
		string strDbaName;
		string strAcctNum;
		//***********************************************************//

        protected string ConnectStr;

		protected DataSet ds = new DataSet();

	
		protected void Page_Load(object sender, System.EventArgs e)
		{
			Session.LCID = 1033;
			ConnectStr = (new igFunctions.DB().getConStr());
			elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
			user_id  = Request.Cookies["CurrentUserInfo"]["user_id"];

			strDbaName = Request.QueryString["BusinessName"];
			strAcctNum = Request.QueryString["AcctNum"];

			string strChk = Request.QueryString["chk"];
			
			if(!IsPostBack)
			{
				if(strChk==null)
				{
					Response.Redirect(ParentPage);
				}
				else
				{
					if ((strDbaName == null) && (strAcctNum == null)) Response.Redirect(ParentPage);
				}

				if (strChk == "1")  
				{
					PerformSearchWithNum();
				}

				if (strChk == "2")  
				{
					PerformSearch();
				}

				PerformDataBind();
			}
		}

		private void PerformSearch()
		{
			strDbaName = strDbaName.Replace("'","''");
			SqlConnection Con = new SqlConnection(ConnectStr);
			SqlCommand cmd = new SqlCommand("select org_account_number,dba_name,business_address,business_city "
                + " from organization where elt_account_number=" + elt_account_number + " and LOWER(dba_name) like LOWER('" + strDbaName + "%') order by dba_name", Con);
			SqlDataAdapter Adap = new SqlDataAdapter();

			Con.Open();
			
			Adap.SelectCommand = cmd;
			Adap.Fill(ds, ParentTable);
			Con.Close();

		}

		private void PerformSearchWithNum()
		{
			SqlConnection Con = new SqlConnection(ConnectStr);
			SqlCommand cmd = new SqlCommand("select org_account_number,dba_name,business_address,business_city "
											+ " from organization where elt_account_number=" +elt_account_number+" and org_account_number like '" + strAcctNum+ "%' order by dba_name",Con);
			SqlDataAdapter Adap = new SqlDataAdapter();

			Con.Open();
			
			Adap.SelectCommand = cmd;
			Adap.Fill(ds, ParentTable);
			Con.Close();

		}

		private void PerformDataBind()
		{		

			UltraWebGrid1.DataSource=ds.Tables[ParentTable].DefaultView;	
			UltraWebGrid1.DataBind();

			if(UltraWebGrid1.Rows.Count<1)
			{
				UltraWebGrid1.Visible = false;
				lblError.Text = "No duplicated name was found!";
			}
			else
			{
				lblError.Text = "*" + (UltraWebGrid1.Rows.Count).ToString() + " name(s) was(are) found.";
			}
			
		}




		#region Web Form �����̳ʿ��� ������ �ڵ�
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: �� ȣ���� ASP.NET Web Form �����̳ʿ� �ʿ��մϴ�.
			//
			InitializeComponent();
			base.OnInit(e);
		}
		
		/// <summary>
		/// �����̳� ������ �ʿ��� �޼����Դϴ�.
		/// �� �޼����� ������ �ڵ� ������� �������� ���ʽÿ�.
		/// </summary>
		private void InitializeComponent()
		{    
			this.UltraWebGrid1.InitializeLayout += new Infragistics.WebUI.UltraWebGrid.InitializeLayoutEventHandler(this.UltraWebGrid1_InitializeLayout);

		}
		#endregion

		private void UltraWebGrid1_InitializeLayout(object sender, Infragistics.WebUI.UltraWebGrid.LayoutEventArgs e)
		{
			UltraWebGrid1.Bands[0].Columns.FromKey("org_account_number").Width= new Unit("50px");
			UltraWebGrid1.Bands[0].Columns.FromKey("dba_name").Width= new Unit("200px");
			UltraWebGrid1.Bands[0].Columns.FromKey("business_address").Width= new Unit("200px");
			UltraWebGrid1.Bands[0].Columns.FromKey("business_city").Width= new Unit("100px");

			UltraWebGrid1.Bands[0].Columns.FromKey("org_account_number").Header.Caption= "Number";
			UltraWebGrid1.Bands[0].Columns.FromKey("dba_name").Header.Caption= "Business Name";
			UltraWebGrid1.Bands[0].Columns.FromKey("business_address").Header.Caption= "Address";
			UltraWebGrid1.Bands[0].Columns.FromKey("business_city").Header.Caption= "City";
		}

		private void UltraWebGrid1_InitializeRow(object sender, Infragistics.WebUI.UltraWebGrid.RowEventArgs e)
		{
//			string s;
////			s = "CompanyConfigCreate.aspx?";
////			e.Row.Cells.FromKey("org_account_number").TargetURL = "@[_blank]" + s + e.Row.Cells.FromKey("org_account_number").Value;
//
//			s = "javascript:myFunction(";
//			e.Row.Cells.FromKey("org_account_number").TargetURL = s + e.Row.Cells.FromKey("org_account_number").Value + ")";

		}
	}
}
