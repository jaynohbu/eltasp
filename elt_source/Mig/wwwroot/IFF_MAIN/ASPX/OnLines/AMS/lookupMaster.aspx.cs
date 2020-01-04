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

namespace IFF_MAIN.ASPX.OnLines.AMS
{
	/// <summary>
	/// lookup에 대한 요약 설명입니다.
	/// </summary>
    public partial class lookupMaster : System.Web.UI.Page
	{

		public string elt_account_number;
		public string login_name;
		string ParentTable="";
		public string ChildTable = "";
		public string strField = "";
		public string strFilter = "";
		public string strFilter1 = "";
		public string strFilter2 = "";
		protected string keyColName="v3_vessel_name";  
		string ParentPage = "AMS_EDI_Ocean.aspx";
		
		protected DataSet ds = new DataSet();


		private void Page_Load(object sender, System.EventArgs e)
		{
            elt_account_number = "80002000";
            login_name = "admin";

			ChildTable = Request.QueryString["TABLE"];
			
				strField = Request.QueryString["FIELD"];
				strFilter = Request.QueryString["FILTER"];
				strFilter1 = Request.QueryString["FILTER1"];
				strFilter2 = Request.QueryString["FILTER2"];
				ParentTable = "P"+ChildTable;

				if(!IsPostBack)	
				{
					if (ChildTable == null) Response.Redirect(ParentPage);
				}
				else
				{

				}

			if (strFilter == "Date") 
			{	
				PerformSearchWithNumMasterDate(); 
			}
			else 
			{	
				 PerformSearchWithNumMaster(strFilter); 
			}

			PerformDataBind();

		}

		private void PerformDataBind()
		{		

			UltraWebGrid1.DataSource=ds.Tables[ParentTable].DefaultView;	
			UltraWebGrid1.DataBind();

			if(UltraWebGrid1.Rows.Count<1)
			{
				UltraWebGrid1.Visible = false;
				lblError.Text = "No data was found!";
			}
			else
			{
				lblError.Text = "*" + (UltraWebGrid1.Rows.Count).ToString() + " name(s) was(are) found.";
			}
			
		}
		private void PerformSearchWithNumMasterDate()
		{
                    string ConnectStr = (new igFunctions.DB().getConStr());
					SqlConnection Con = new SqlConnection(ConnectStr);
					SqlCommand cmd = new SqlCommand("select DISTINCT(v3_vessel_name) from " + ChildTable +
																								" where elt_account_number=" +elt_account_number+" and ( creation_date >= '" + strFilter1 + "' and creation_date < DATEADD(day,1,'"+strFilter2+"'))",Con);
		
					SqlDataAdapter Adap = new SqlDataAdapter();
		
					Con.Open();
					
					Adap.SelectCommand = cmd;
					Adap.Fill(ds, ParentTable);

					cmd.CommandText = "select v3_vessel_name, doc_number, v1_vessel_code as Vessel_Code, v2_voyage_number as Voyage#,creation_date as Creation_Date  from " + ChildTable +
																								" where elt_account_number=" +elt_account_number+" and ( creation_date >= '" + strFilter1 + "' and creation_date < DATEADD(day,1,'"+strFilter2+"'))";

					Adap.Fill(ds, ChildTable);
		
					Con.Close();
		
					if(ds.Relations.Count<1) 
						ds.Relations.Add(ds.Tables[ParentTable].Columns[keyColName],ds.Tables[ChildTable].Columns[keyColName]);

		}
		private void PerformSearchWithNumMaster(string strFilter)
		{
            string ConnectStr = (new igFunctions.DB().getConStr());
			SqlConnection Con = new SqlConnection(ConnectStr);
			SqlCommand cmd = new SqlCommand();
			cmd.Connection = Con;

			switch(strFilter) 
			{
				case "Code" :
					cmd.CommandText = "select DISTINCT(v3_vessel_name) from " + ChildTable +
						" where elt_account_number=" +elt_account_number+" and v1_vessel_code like '" + strFilter1 + "%'";
					break;					
				case "Number"  :
					cmd.CommandText = "select DISTINCT(v3_vessel_name) from " + ChildTable +
						" where elt_account_number=" +elt_account_number+" and doc_number = " + strFilter1;					
					break;
				case "Name" :
					cmd.CommandText = "select DISTINCT(v3_vessel_name) from " + ChildTable +
						" where elt_account_number=" +elt_account_number+" and v3_vessel_name like '" + strFilter1 + "%'";					
					break;
				default:					
					return;
			}

			SqlDataAdapter Adap = new SqlDataAdapter();
		
			Con.Open();
					
			Adap.SelectCommand = cmd;
			Adap.Fill(ds, ParentTable);

			switch(strFilter) 
			{
				case "Code" :
					cmd.CommandText = "select v3_vessel_name, doc_number, v1_vessel_code as Vessel_Code, v2_voyage_number as Voyage#,creation_date as Creation_Date  from " + ChildTable +
						" where elt_account_number=" +elt_account_number+" and v1_vessel_code like '" + strFilter1 + "%'";
					break;					
				case "Number"  :
					cmd.CommandText = "select v3_vessel_name, doc_number, v1_vessel_code as Vessel_Code, v2_voyage_number as Voyage#,creation_date as Creation_Date  from " + ChildTable +
						" where elt_account_number=" +elt_account_number+" and doc_number = " + strFilter1;					
					break;
				case "Name" :
					cmd.CommandText = "select v3_vessel_name, doc_number, v1_vessel_code as Vessel_Code, v2_voyage_number as Voyage#,creation_date as Creation_Date  from " + ChildTable +
						" where elt_account_number=" +elt_account_number+" and v3_vessel_name like '" + strFilter1 + "%'";					
					break;
				default:					
					return;
			}

			Adap.Fill(ds, ChildTable);
		
			Con.Close();
		
			if(ds.Relations.Count<1) 
				ds.Relations.Add(ds.Tables[ParentTable].Columns[keyColName],ds.Tables[ChildTable].Columns[keyColName]);


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
			this.UltraWebGrid1.InitializeLayout += new Infragistics.WebUI.UltraWebGrid.InitializeLayoutEventHandler(this.UltraWebGrid1_InitializeLayout);
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion

		private void UltraWebGrid1_InitializeLayout(object sender, Infragistics.WebUI.UltraWebGrid.LayoutEventArgs e)
		{
			e.Layout.Bands[0].Columns[0].Width = new Unit("390px");
			e.Layout.Bands[1].Columns[0].Hidden = true;
			for(int i=0;i<UltraWebGrid1.Bands.Count;i++)
			{
				for(int j=0;j<UltraWebGrid1.Bands[i].Columns.Count;j++)
				{
						UltraWebGrid1.DisplayLayout.Bands[i].Columns[j].SelectedCellStyle.BackColor=Color.Yellow;
				}
			}

			e.Layout.Bands[1].Columns.FromKey("Vessel_Code").Width = new Unit("80px");
			e.Layout.Bands[1].Columns.FromKey("Voyage#").Width = new Unit("50px");

		}
	}
}
