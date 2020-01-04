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

namespace IFF_MAIN.ASPX.OnLines.Country
{
	/// <summary>
	/// ScheduleBCreate에 대한 요약 설명입니다.
	/// </summary>
    public partial class CountrySet : System.Web.UI.Page
	{
		public string elt_account_number;
		public string user_id,login_name,user_right;
		protected DataSet ds = new DataSet();
        protected string ConnectStr;
        public string windowName;	
        public bool bReadOnly = false;
		protected void Page_Load(object sender, System.EventArgs e)
		{
			Session.LCID = 1033;		
			elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
			user_id  = Request.Cookies["CurrentUserInfo"]["user_id"];
            user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
            windowName = Request.QueryString["WindowName"];
            ConnectStr = (new igFunctions.DB().getConStr());
			bReadOnly = new igFunctions.DB().AUTH_CHECK(elt_account_number, user_id, ConnectStr, Request.ServerVariables["URL"].ToLower(), "");
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

			}
			else
			{
				ViewState["Count"] = (int)ViewState["Count"] + 1;
			}

		}

		private void PerformDefault()
		{
            PerformCus();
            string strCommandText = " select '' as Chk, country_name as Country, country_code as Code from all_country_code order by country_name";
            PerformGetAllData(strCommandText);

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
			this.btnBack.Click += new System.Web.UI.ImageClickEventHandler(this.btnBack_Click);
		}
		#endregion


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
            UltraWebGrid1.ResetColumns();
            UltraWebGrid1.ResetBands();

            string strCommandText = " select '' as Chk, country_name as Country, country_code as Code from country_code where elt_account_number=" + elt_account_number.ToString() + " order by country_name";

            ConnectStr = (new igFunctions.DB().getConStr());
            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand cmdCusData = new SqlCommand(strCommandText, Con);
            SqlDataAdapter Adap = new SqlDataAdapter();

            Con.Open();

            Adap.SelectCommand = cmdCusData;
            Adap.Fill(ds, "CusData");

            Con.Close();

            UltraWebGrid1.DataSource = ds.Tables["CusData"].DefaultView;
            UltraWebGrid1.DataBind();
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

        private bool PerformSave()
		{
			string strInsert= @" INSERT INTO country_code 
													(
														elt_account_number,
														country_name,
														country_code
													)
											VALUES 
														(
														@elt_account_number,
														@country_name,
														@country_code
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

				Cmd.CommandText = "DELETE country_code WHERE  elt_account_number=@elt_account_number";
				Cmd.Parameters.Add("@elt_account_number", SqlDbType.Decimal,9).Value = elt_account_number;
				Cmd.ExecuteNonQuery();

				Cmd.CommandText = strInsert;
				for(int i=0;i<UltraWebGrid1.Rows.Count;i++)
				{
					Cmd.Parameters.Clear();
					Cmd.Parameters.Add("@elt_account_number", SqlDbType.Decimal,9).Value = elt_account_number;
                    Cmd.Parameters.Add("@country_name", SqlDbType.VarChar, 128).Value = (UltraWebGrid1.Rows[i].Cells.FromKey("Country").Text == null ? " " : UltraWebGrid1.Rows[i].Cells.FromKey("Country").Text);
                    Cmd.Parameters.Add("@country_code", SqlDbType.VarChar, 2).Value = (UltraWebGrid1.Rows[i].Cells.FromKey("Code").Text == null ? " " : UltraWebGrid1.Rows[i].Cells.FromKey("Code").Text);
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

        protected void btnSave_Click1(object sender, ImageClickEventArgs e)
        {
            lblError.Text = "";
            if (PerformSave())
            {
                lblError.Text = "Data was saved successfully.";
                //                PerformRecentDB(sUrl, ComboBox1.Text, "","MD->Country");

            }
        }
        protected void UltraWebGrid1_InitializeLayout1(object sender, LayoutEventArgs e)
        {
            e.Layout.SelectTypeColDefault = SelectType.Single;
            e.Layout.SelectTypeRowDefault = SelectType.Extended;

            e.Layout.TableLayout = TableLayout.Fixed;
            e.Layout.RowStyleDefault.BorderDetails.ColorTop = Color.Gray;

            e.Layout.Bands[0].AllowAdd = Infragistics.WebUI.UltraWebGrid.AllowAddNew.Yes;

            for (int i = 0; i < UltraWebGrid1.Bands.Count; i++)
            {
                for (int j = 0; j < UltraWebGrid1.Bands[i].Columns.Count; j++)
                {
                    if (UltraWebGrid1.DisplayLayout.Bands[i].Columns[j].BaseColumnName != "Chk")
                    {
//                        UltraWebGrid1.DisplayLayout.Bands[i].Columns[j].SelectedCellStyle.BackColor = Color.Yellow;
                        UltraWebGrid1.DisplayLayout.Bands[i].Columns[j].SelectedCellStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Text;
                    }
                }
            }

            //			UltraWebGrid1.Bands[0].RowStyle.BackColor=Color.PaleTurquoise;
            UltraWebGrid1.DisplayLayout.SelectedHeaderStyleDefault.BackColor = Color.Red;
            UltraWebGrid1.DisplayLayout.SelectTypeCellDefault = Infragistics.WebUI.UltraWebGrid.SelectType.Single;
            UltraWebGrid1.DisplayLayout.AllowColSizingDefault = Infragistics.WebUI.UltraWebGrid.AllowSizing.Free;

            //set cursor 
            UltraWebGrid1.DisplayLayout.FrameStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Default;
            UltraWebGrid1.DisplayLayout.Bands[0].HeaderStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Default;
            UltraWebGrid1.DisplayLayout.SelectedHeaderStyleDefault.BackColor = Color.Red;

            // ********************************************************************************************************** //

            e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.BackgroundImage = "../../../Images/mark_o.gif";
            e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.HorizontalAlign = HorizontalAlign.Center;
            e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.CustomRules = "background-position:center ;background-repeat:no-repeat";
            e.Layout.Bands[0].Columns.FromKey("Chk").Header.Caption = "";
            e.Layout.Bands[0].Columns.FromKey("Chk").Width = new Unit("40px");
            e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.BackColor = Color.FromArgb(249, 236, 212);
            e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Hand;
            e.Layout.Bands[0].Columns.FromKey("Chk").AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.Yes;
        }
        protected void UltraWebGrid2_InitializeLayout1(object sender, LayoutEventArgs e)
        {
            e.Layout.SelectTypeColDefault = SelectType.Single;
            e.Layout.SelectTypeRowDefault = SelectType.Extended;

            e.Layout.Bands[0].AllowAdd = Infragistics.WebUI.UltraWebGrid.AllowAddNew.Yes;

            e.Layout.TableLayout = TableLayout.Fixed;
            e.Layout.RowStyleDefault.BorderDetails.ColorTop = Color.Gray;

            for (int i = 0; i < UltraWebGrid2.Bands.Count; i++)
            {
                for (int j = 0; j < UltraWebGrid2.Bands[i].Columns.Count; j++)
                {
                    if (UltraWebGrid2.DisplayLayout.Bands[i].Columns[j].BaseColumnName != "Chk")
                    {
//                        UltraWebGrid2.DisplayLayout.Bands[i].Columns[j].SelectedCellStyle.BackColor = Color.Yellow;
                        UltraWebGrid2.DisplayLayout.Bands[i].Columns[j].SelectedCellStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Text;
                    }
                }
            }

            //			UltraWebGrid2.Bands[0].RowStyle.BackColor=Color.PaleTurquoise;
            UltraWebGrid2.DisplayLayout.SelectedHeaderStyleDefault.BackColor = Color.Red;
            UltraWebGrid2.DisplayLayout.SelectTypeCellDefault = Infragistics.WebUI.UltraWebGrid.SelectType.Single;
            UltraWebGrid2.DisplayLayout.AllowColSizingDefault = Infragistics.WebUI.UltraWebGrid.AllowSizing.Free;

            //set cursor 
            UltraWebGrid2.DisplayLayout.FrameStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Default;
            UltraWebGrid2.DisplayLayout.Bands[0].HeaderStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Default;
            UltraWebGrid2.DisplayLayout.SelectedHeaderStyleDefault.BackColor = Color.Red;

            // ********************************************************************************************************** //
            e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.BackgroundImage = "../../../Images/mark_o.gif";
            e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.HorizontalAlign = HorizontalAlign.Center;
            e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.CustomRules = "background-position:center ;background-repeat:no-repeat";
            e.Layout.Bands[0].Columns.FromKey("Chk").Header.Caption = "";
            e.Layout.Bands[0].Columns.FromKey("Chk").Width = new Unit("40px");
            e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.BackColor = Color.FromArgb(249, 236, 212);
            e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Hand;
            e.Layout.Bands[0].Columns.FromKey("Chk").AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No;

        }
        protected void btnReloadAll_Click1(object sender, ImageClickEventArgs e)
        {
            string strCommandText = " select '' as Chk, country_name as Country, country_code as Code from all_country_code order by country_name";
            PerformGetAllData(strCommandText);

        }
}
}
