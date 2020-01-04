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

namespace IFF_MAIN.ASPX.OnLines.ScheduleB
{
	/// <summary>
	/// ScheduleBCreate에 대한 요약 설명입니다.
	/// </summary>
	public partial class ScheduleBCreate : System.Web.UI.Page
	{
		public string elt_account_number;
		public string user_id;
		protected string strUserRight;
		string p_Code = null;
		string p_Name = null;
		protected DataSet ds = new DataSet();
        protected string ConnectStr;
        public string windowName;	

		protected void Page_Load(object sender, System.EventArgs e)
		{
			Session.LCID = 1033;		
			elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
			user_id  = Request.Cookies["CurrentUserInfo"]["user_id"];
			strUserRight  = Request.Cookies["CurrentUserInfo"]["user_right"];
            windowName = Request.QueryString["WindowName"];	

			if(!IsPostBack)
			{
				PerformDefault();
				ViewState["Count"]= 1;
			
				string Refer = "";
				if(Request.UrlReferrer != null)
				{
					Refer = Request.UrlReferrer.ToString();
				}

				if(Refer.IndexOf("ScheduleB") == -1)
				{
					ViewState["Parent"] = Request.Url.ToString();
				}
				else 
				{
					ViewState["Parent"] = Refer;
				}

				performSelectionDataBinding();

				p_Code = Request.QueryString["ff"];
				p_Name = Request.QueryString["nn"];

				if(p_Code != null)
				{

					performRateEditRemote(p_Code, p_Name);
				}
			}
			else
			{
				ViewState["Count"] = (int)ViewState["Count"] + 1;
			}

		}

		private void performRateEditRemote(string p_Code, string p_Name) 
		{
			this.ComboBox1.Text = p_Name;
			this.ComboBox1.SelectedValue = p_Code;
			txtNum.Text = ComboBox1.Items.IndexOf(ComboBox1.Items.FindByValue(p_Code)).ToString();
            if (txtNum.Text == "-1")
            {
                string script = "";
                string errMsg = "Company data is not in Database, Please save company data first.";
                script = "<script language='javascript'> ";
                script += "alert(' " + errMsg + " '); ";
                script += "window.close(); ";
                script += "</script>";
                this.ClientScript.RegisterClientScriptBlock(this.GetType(), "Pre", script);
                return;
            }
			this.Panel1.Visible = true;
			PerformCus();
			PerformGetAll();
		}

		private void PerformDefault()
		{
			btnGo.Attributes.Add("onclick",  "Javascript:ReqDataCheck();");
//			btnSelectAll.Attributes.Add("onclick",  "Javascript:SelectAllRows();");
//			btnUnselectAll.Attributes.Add("onclick",  "Javascript:unSelectAllRows();");
			this.Panel1.Visible = false;
		}

		private void performSelectionDataBinding()
		{

            ConnectStr = (new igFunctions.DB().getConStr());			
			SqlConnection Con = new SqlConnection(ConnectStr);

			SqlCommand cmdCustomer = new SqlCommand(@"
																	SELECT	org_account_number, 
                                                         CASE WHEN isnull(class_code,'') = '' THEN dba_name
                                                         ELSE dba_name + '[' + RTRIM(LTRIM(isnull(class_code,''))) + ']'
                                                         END as dba_name
																	  FROM	organization 
																	WHERE	elt_account_number = " + elt_account_number + 
				"	AND (dba_name!='') order by dba_name", Con);

			SqlDataAdapter Adap = new SqlDataAdapter();
			DataSet tmpDs = new DataSet();
				
			Con.Open();

			Adap.SelectCommand = cmdCustomer;
			Adap.Fill(tmpDs, "Customer");

			Con.Close();
		
			ComboBox1.DataSource =  tmpDs.Tables["Customer"];
			ComboBox1.DataTextField = tmpDs.Tables["Customer"].Columns["dba_name"].ToString();
			ComboBox1.DataValueField = tmpDs.Tables["Customer"].Columns["org_account_number"].ToString();
			ComboBox1.DataBind();
//			ComboBox1.Items.Insert(0,"");
//			ComboBox1.SelectedIndex = 0;

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
			this.btnGo.Click += new System.Web.UI.ImageClickEventHandler(this.btnGo_Click);
			this.btnSave.Click += new System.Web.UI.ImageClickEventHandler(this.btnSave_Click);
			this.UltraWebGrid1.InitializeLayout += new Infragistics.WebUI.UltraWebGrid.InitializeLayoutEventHandler(this.UltraWebGrid1_InitializeLayout);
			this.UltraWebGrid2.InitializeLayout += new Infragistics.WebUI.UltraWebGrid.InitializeLayoutEventHandler(this.UltraWebGrid2_InitializeLayout);
			this.btnBack.Click += new System.Web.UI.ImageClickEventHandler(this.btnBack_Click);
			this.btnReloadAll.Click += new System.Web.UI.ImageClickEventHandler(this.btnReloadAll_Click);

		}
		#endregion


		private void PerformGetCusData(string strCommandText)
		{
			UltraWebGrid1.ResetColumns();
			UltraWebGrid1.ResetBands();

            ConnectStr = (new igFunctions.DB().getConStr()); SqlConnection Con = new SqlConnection(ConnectStr);
			SqlCommand cmdCusData = new SqlCommand(strCommandText,Con);
			SqlDataAdapter Adap = new SqlDataAdapter();

			Con.Open();
			
			Adap.SelectCommand = cmdCusData;
			Adap.Fill(ds, "CusData");

			Con.Close();

			UltraWebGrid1.DataSource=ds.Tables["CusData"].DefaultView;
			UltraWebGrid1.DataBind();

		}
		
		private void PerformGetAllData(string strCommandText)
		{
			UltraWebGrid2.ResetColumns();
			UltraWebGrid2.ResetBands();

            ConnectStr = (new igFunctions.DB().getConStr());
			SqlConnection Con = new SqlConnection(ConnectStr);
			SqlCommand cmdCusData = new SqlCommand(strCommandText,Con);
			SqlDataAdapter Adap = new SqlDataAdapter();

			Con.Open();
			
			Adap.SelectCommand = cmdCusData;
			Adap.Fill(ds, "AllData");

			Con.Close();

			UltraWebGrid2.DataSource=ds.Tables["AllData"].DefaultView;
			UltraWebGrid2.DataBind();			
		}

		private void PerformCus()
		{
			string strCommandText = "";
			string strCompany = null;

			if( ComboBox1.Text != "" && txtNum.Text != "")
			{
				ComboBox1.SelectedIndex = int.Parse(txtNum.Text);
				strCompany = ComboBox1.SelectedValue;
				ViewState["strCompany"]= strCompany;
			}
			else
			{
				string script = "<script language='javascript'> alert('Please select a company!!');";
				script += "</script>";
				this.ClientScript.RegisterStartupScript(this.GetType(), "Pre", script);
				return;
			}

			strCommandText = "SELECT * from ig_schedule_b WHERE elt_account_number = '"+elt_account_number+ "' and "+ "org_account_number='" +strCompany+ "'";

			PerformGetCusData(strCommandText);
		}

		private void PerformFilterAll()
		{
			string keyVal = "";
			for(int i=0;i<UltraWebGrid1.Rows.Count;i++)
			{
				keyVal = UltraWebGrid1.Rows[i].Cells.FromKey("sb").Text;
				for(int j=0;j<UltraWebGrid2.Rows.Count;j++)
				{
					if(UltraWebGrid2.Rows[j].Cells.FromKey("sb").Text == keyVal)
					{
						UltraWebGrid2.Rows[j].Delete();
						break;
					}
				}
			}

		}

		private void PerformGetAll()
		{
			string strCommandText = "";

			strCommandText = "SELECT *  from scheduleB WHERE elt_account_number = '"+elt_account_number+"'";

			PerformGetAllData(strCommandText);

			PerformFilterAll();

		}
		private void UltraWebGrid2_InitializeLayout(object sender, Infragistics.WebUI.UltraWebGrid.LayoutEventArgs e)
		{
			e.Layout.SelectTypeColDefault=SelectType.Single;
			e.Layout.SelectTypeRowDefault=SelectType.Extended;
			
			e.Layout.Bands[0].AllowAdd = Infragistics.WebUI.UltraWebGrid.AllowAddNew.Yes;

			e.Layout.TableLayout=TableLayout.Fixed;
			e.Layout.RowStyleDefault.BorderDetails.ColorTop=Color.Gray;

			for(int i=0;i<UltraWebGrid2.Bands.Count;i++)
			{
				for(int j=0;j<UltraWebGrid2.Bands[i].Columns.Count;j++)
				{
					if(UltraWebGrid2.DisplayLayout.Bands[i].Columns[j].BaseColumnName != "Chk" )
					{
						UltraWebGrid2.DisplayLayout.Bands[i].Columns[j].SelectedCellStyle.BackColor=Color.Yellow;
						UltraWebGrid2.DisplayLayout.Bands[i].Columns[j].SelectedCellStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Text;
					}
				}
			}

//			UltraWebGrid2.Bands[0].RowStyle.BackColor=Color.PaleTurquoise;
			UltraWebGrid2.DisplayLayout.SelectedHeaderStyleDefault.BackColor=Color.Red;
			UltraWebGrid2.DisplayLayout.SelectTypeCellDefault=Infragistics.WebUI.UltraWebGrid.SelectType.Single;
			UltraWebGrid2.DisplayLayout.AllowColSizingDefault=Infragistics.WebUI.UltraWebGrid.AllowSizing.Free;

			//set cursor 
			UltraWebGrid2.DisplayLayout.FrameStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Default;
			UltraWebGrid2.DisplayLayout.Bands[0].HeaderStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Default;
			UltraWebGrid2.DisplayLayout.SelectedHeaderStyleDefault.BackColor=Color.Red;		

			// ********************************************************************************************************** //
			e.Layout.Bands[0].Columns.FromKey("elt_account_number").Hidden=true;
			e.Layout.Bands[0].Columns.Insert(0,"Chk");
			e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.BackgroundImage = "../../../Images/mark_o.gif";
			e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.HorizontalAlign=HorizontalAlign.Center;
			e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.CustomRules="background-position:center ;background-repeat:no-repeat";
			e.Layout.Bands[0].Columns.FromKey("Chk").Header.Caption = "";
			e.Layout.Bands[0].Columns.FromKey("Chk").Width = new Unit("40px");
			e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.BackColor = Color.FromArgb(249,236,212);
			e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.Cursor =  Infragistics.WebUI.Shared.Cursors.Hand;
			e.Layout.Bands[0].Columns.FromKey("Chk").AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No;

			e.Layout.Bands[0].Columns.FromKey("sb").Header.Caption = "Schedule B";
			e.Layout.Bands[0].Columns.FromKey("sb_unit1").Header.Caption = "Unit 1";
			e.Layout.Bands[0].Columns.FromKey("sb_unit2").Header.Caption = "Unit 2";
			e.Layout.Bands[0].Columns.FromKey("description").Header.Caption = "Description";
			e.Layout.Bands[0].Columns.FromKey("sb_unit1").Width = new Unit("40px");
			e.Layout.Bands[0].Columns.FromKey("sb_unit2").Width = new Unit("40px");
			e.Layout.Bands[0].Columns.FromKey("description").Width = new Unit("180px");

		}

		private void btnGo_Click(object sender, System.Web.UI.ImageClickEventArgs e)
		{
			this.UltraWebGrid1.ResetRows();
			this.Panel1.Visible = true;
			PerformCus();
			PerformGetAll();
		}

		private void UltraWebGrid1_InitializeLayout(object sender, Infragistics.WebUI.UltraWebGrid.LayoutEventArgs e)
		{
			e.Layout.SelectTypeColDefault=SelectType.Single;
			e.Layout.SelectTypeRowDefault=SelectType.Extended;

			e.Layout.TableLayout=TableLayout.Fixed;
			e.Layout.RowStyleDefault.BorderDetails.ColorTop=Color.Gray;
			
			e.Layout.Bands[0].AllowAdd = Infragistics.WebUI.UltraWebGrid.AllowAddNew.Yes;

			for(int i=0;i<UltraWebGrid1.Bands.Count;i++)
			{
				for(int j=0;j<UltraWebGrid1.Bands[i].Columns.Count;j++)
				{
					if(UltraWebGrid1.DisplayLayout.Bands[i].Columns[j].BaseColumnName != "Chk" )
					{
						UltraWebGrid1.DisplayLayout.Bands[i].Columns[j].SelectedCellStyle.BackColor=Color.Yellow;
						UltraWebGrid1.DisplayLayout.Bands[i].Columns[j].SelectedCellStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Text;
					}
				}
			}

			//			UltraWebGrid1.Bands[0].RowStyle.BackColor=Color.PaleTurquoise;
			UltraWebGrid1.DisplayLayout.SelectedHeaderStyleDefault.BackColor=Color.Red;
			UltraWebGrid1.DisplayLayout.SelectTypeCellDefault=Infragistics.WebUI.UltraWebGrid.SelectType.Single;
			UltraWebGrid1.DisplayLayout.AllowColSizingDefault=Infragistics.WebUI.UltraWebGrid.AllowSizing.Free;

			//set cursor 
			UltraWebGrid1.DisplayLayout.FrameStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Default;
			UltraWebGrid1.DisplayLayout.Bands[0].HeaderStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Default;
			UltraWebGrid1.DisplayLayout.SelectedHeaderStyleDefault.BackColor=Color.Red;		

			// ********************************************************************************************************** //
			e.Layout.Bands[0].Columns.FromKey("elt_account_number").Hidden=true;
			e.Layout.Bands[0].Columns.FromKey("org_account_number").Hidden=true;

			e.Layout.Bands[0].Columns.Insert(0,"Chk");
			e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.BackgroundImage = "../../../Images/mark_o.gif";
			e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.HorizontalAlign=HorizontalAlign.Center;
			e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.CustomRules="background-position:center ;background-repeat:no-repeat";
			e.Layout.Bands[0].Columns.FromKey("Chk").Header.Caption = "";
			e.Layout.Bands[0].Columns.FromKey("Chk").Width = new Unit("40px");
			e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.BackColor = Color.FromArgb(249,236,212);
			e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.Cursor =  Infragistics.WebUI.Shared.Cursors.Hand;
			e.Layout.Bands[0].Columns.FromKey("Chk").AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.Yes;

			e.Layout.Bands[0].Columns.FromKey("sb").Header.Caption = "Schedule B";
			e.Layout.Bands[0].Columns.FromKey("sb_unit1").Header.Caption = "Unit 1";
			e.Layout.Bands[0].Columns.FromKey("sb_unit2").Header.Caption = "Unit 2";
			e.Layout.Bands[0].Columns.FromKey("description").Header.Caption = "Description";
			e.Layout.Bands[0].Columns.FromKey("sb_unit1").Width = new Unit("40px");
			e.Layout.Bands[0].Columns.FromKey("sb_unit2").Width = new Unit("40px");
			e.Layout.Bands[0].Columns.FromKey("description").Width = new Unit("180px");
		
		}
		private bool PerformSave()
		{
			string strCompany = ViewState["strCompany"].ToString();

			if(strCompany == null) return false;

			string strInsert= @" INSERT INTO ig_schedule_b 
													(
														elt_account_number,
														org_account_number,
														sb,
														sb_unit1,
														sb_unit2,
														description
													)
											VALUES 
														(
														@elt_account_number,
														@org_account_number,
														@sb,
														@sb_unit1,
														@sb_unit2,
														@description
													)";

            ConnectStr = (new igFunctions.DB().getConStr());
			SqlConnection	Con = new SqlConnection(ConnectStr);
			SqlCommand		Cmd = new SqlCommand();
			Cmd.Connection = Con;

			Con.Open();			

			SqlTransaction trans = Con.BeginTransaction();

			Cmd.Transaction = trans;

			try
			{

				Cmd.CommandText = "DELETE ig_schedule_b  WHERE  elt_account_number=@elt_account_number AND org_account_number=@org_account_number";
				Cmd.Parameters.Add("@elt_account_number", SqlDbType.Decimal,9).Value = elt_account_number;
				Cmd.Parameters.Add("@org_account_number", SqlDbType.Decimal, 9).Value = strCompany;
				Cmd.ExecuteNonQuery();

				Cmd.CommandText = strInsert;
				for(int i=0;i<UltraWebGrid1.Rows.Count;i++)
				{
					Cmd.Parameters.Clear();
					Cmd.Parameters.Add("@elt_account_number", SqlDbType.Decimal,9).Value = elt_account_number;
					Cmd.Parameters.Add("@org_account_number", SqlDbType.Decimal, 9).Value = int.Parse(strCompany);
					Cmd.Parameters.Add("@sb", SqlDbType.NVarChar, 32).Value = (UltraWebGrid1.Rows[i].Cells.FromKey("sb").Text == null ? " " : UltraWebGrid1.Rows[i].Cells.FromKey("sb").Text);
					Cmd.Parameters.Add("@sb_unit1", SqlDbType.NVarChar, 3).Value = (UltraWebGrid1.Rows[i].Cells.FromKey("sb_unit1").Text == null ? " " : UltraWebGrid1.Rows[i].Cells.FromKey("sb_unit1").Text);
					Cmd.Parameters.Add("@sb_unit2", SqlDbType.NVarChar, 3).Value =(UltraWebGrid1.Rows[i].Cells.FromKey("sb_unit2").Text == null ? " " : UltraWebGrid1.Rows[i].Cells.FromKey("sb_unit2").Text);
					Cmd.Parameters.Add("@description", SqlDbType.NVarChar, 45).Value =(UltraWebGrid1.Rows[i].Cells.FromKey("description").Text == null ? " " : UltraWebGrid1.Rows[i].Cells.FromKey("description").Text);
					Cmd.ExecuteNonQuery();
				}

				trans.Commit();

			}
			catch(Exception ex)
			{
				trans.Rollback();
				lblError.Text = ex.Message;
				Con.Close();
				return false;
			}
			finally
			{
				Con.Close();
			}

			return true;
		}

		private void btnSave_Click(object sender, System.Web.UI.ImageClickEventArgs e)
		{
			lblError.Text = "";
			if(PerformSave()) 
			{
				lblError.Text = "Data was saved successfully.";
				string sUrl = "/IFF_MAIN/ASPX/OnLines/ScheduleB/ScheduleBCreate.aspx?ff="+ComboBox1.SelectedValue+"&nn="+ComboBox1.Text;
                PerformRecentDB(sUrl, ComboBox1.Text, "","MD->ScheduleB");

			}
		}

        private void PerformRecentDB(string sURL, string DocNum, string WorkDetail, string strSoTitle)
        {
            string SQL = "insert INTO Recent_Work ( elt_account_number, user_id, workdate, title, docnum, surl, workdetail,remark,status ) ";
            SQL =
            SQL + " VALUES (" + elt_account_number + ", '" + user_id + "', '" + getDateTime() + "', '" + strSoTitle + "','" + DocNum + "' ,'" + sURL + "' ,'" + WorkDetail + "','','')";

            ConnectStr = (new igFunctions.DB().getConStr());
            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand cmdRecent = new SqlCommand();
            cmdRecent.Connection = Con;
            Con.Open();
            cmdRecent.CommandText = SQL;
            cmdRecent.ExecuteNonQuery();
            Con.Close();
        }

        private string getDateTime()
        {
            string strDateTime = "";
            string strDate = getTodaySQL();
            string strTime = getTimeSQL();

            strDateTime = strDate.Substring(4, 2) + "/" + strDate.Substring(6, 2) + "/" + strDate.Substring(0, 4);
            strDateTime = strDateTime + " " + strTime.Substring(0, 2) + ":" + strTime.Substring(2, 2) + ":" + strTime.Substring(4, 2);
            
            return strDateTime;
        }

        private string getTimeSQL()
        {
            string strTime = "";

            if (DateTime.Now.Hour.ToString().Length == 1)
            {
                strTime = strTime + "0" + DateTime.Now.Hour.ToString();
            }
            else
            {
                strTime = strTime + DateTime.Now.Hour.ToString();
            }

            if (DateTime.Now.Minute.ToString().Length == 1)
            {
                strTime = strTime + "0" + DateTime.Now.Minute.ToString();
            }
            else
            {
                strTime = strTime + DateTime.Now.Minute.ToString();
            }

            if (DateTime.Now.Second.ToString().Length == 1)
            {
                strTime = strTime + "0" + DateTime.Now.Second.ToString();
            }
            else
            {
                strTime = strTime + DateTime.Now.Second.ToString();
            }

            return strTime;
        }

        private string getTodaySQL()
        {
            string strDate = "";
            strDate = DateTime.Now.Year.ToString();

            if (DateTime.Now.Month.ToString().Length == 1)
            {
                strDate = strDate + "0" + DateTime.Now.Month.ToString();
            }
            else
            {
                strDate = strDate + DateTime.Now.Month.ToString();
            }

            if (DateTime.Now.Day.ToString().Length == 1)
            {
                strDate = strDate + "0" + DateTime.Now.Day.ToString();
            }
            else
            {
                strDate = strDate + DateTime.Now.Day.ToString();
            }

            return strDate;
        }

		private void btnBack_Click(object sender, System.Web.UI.ImageClickEventArgs e)
		{
			string ParentPage = ViewState["Parent"].ToString();
			int a = int.Parse(ViewState["Count"].ToString());
			string script = "<script language='javascript'>";

			script += "if(history.length >= " + a.ToString() + ")";
			script += "{ history.go(-" + a.ToString() + "); }";
			script += "else{location.replace('"+ParentPage+"')}";
			script += "</script>";
			this.ClientScript.RegisterStartupScript(this.GetType(), "Pre", script);  					
		
		}

		private void btnReloadAll_Click(object sender, System.Web.UI.ImageClickEventArgs e)
		{
					PerformGetAll();
		}

	}
}
