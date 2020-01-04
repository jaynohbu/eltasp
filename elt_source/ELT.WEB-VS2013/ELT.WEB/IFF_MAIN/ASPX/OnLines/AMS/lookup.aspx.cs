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
    public partial class lookup : System.Web.UI.Page
	{

		public string elt_account_number;
		public string login_name;

		string ParentTable="";
		public string ChildTable = "";
		public string strField = "";
		public string strFilter = "";
		protected string keyColName="Country";  
		string ParentPage = "AMS_EDI_Ocean.aspx";
		
		protected DataSet ds = new DataSet();


		private void Page_Load(object sender, System.EventArgs e)
		{
            elt_account_number = "80002000";
            login_name = "admin";

			ChildTable = Request.QueryString["TABLE"];
			

				strField = Request.QueryString["FIELD"];
				strFilter = Request.QueryString["FILTER"];

				ParentTable = "P"+ChildTable;

				if(!IsPostBack)	
				{
					if (ChildTable == null) Response.Redirect(ParentPage);
				}
				else
				{

				}
				PerformSearchWithNum();

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

		private void PerformSearchWithNum()
		{
            string ConnectStr = (new igFunctions.DB().getConStr());
			SqlConnection Con = new SqlConnection(ConnectStr);
			SqlCommand cmd = new SqlCommand("select DISTINCT(country) from " + ChildTable +
//																	 " where EmailItemID=" +EmailItemID+" and k_code  like '" + strFilter+ "%'",Con);
																	 " where port  like '" + strFilter+ "%'",Con);
			SqlDataAdapter Adap = new SqlDataAdapter();

			Con.Open();
			
			Adap.SelectCommand = cmd;
			Adap.Fill(ds, ParentTable);

			cmd.CommandText = "select * from " + ChildTable + 
				//																	 " where EmailItemID=" +EmailItemID+" and k_code  like '" + strFilter+ "%'",Con);
											" where port  like '" + strFilter+ "%'";

//			Adap.SelectCommand = cmd;

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
			e.Layout.Bands[0].Columns[0].Width = new Unit("217px");
			e.Layout.Bands[1].Columns[0].Hidden = true;
			for(int i=0;i<UltraWebGrid1.Bands.Count;i++)
			{
				for(int j=0;j<UltraWebGrid1.Bands[i].Columns.Count;j++)
				{
						UltraWebGrid1.DisplayLayout.Bands[i].Columns[j].SelectedCellStyle.BackColor=Color.Yellow;
				}
			}

		}
	}
}
