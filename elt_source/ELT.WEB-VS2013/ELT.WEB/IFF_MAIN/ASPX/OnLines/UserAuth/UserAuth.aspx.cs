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

namespace IFF_MAIN.ASPX.OnLines.UserAuth
{
	/// <summary>
	/// ScheduleBCreate에 대한 요약 설명입니다.
	/// </summary>
    public partial class UserAuth : System.Web.UI.Page
	{
		public string elt_account_number;
		public string user_id,login_name,user_right;
        public bool bReadOnly = false;

		string p_Code = null;
		protected DataSet ds = new DataSet();
        protected string ConnectStr;
        public string windowName;	

		protected void Page_Load(object sender, System.EventArgs e)
		{
			Session.LCID = 1033;		
			elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
			user_id  = Request.Cookies["CurrentUserInfo"]["user_id"];
			user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
			login_name  = Request.Cookies["CurrentUserInfo"]["login_name"];
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

				if(Refer.IndexOf("Auth") == -1)
				{
					ViewState["Parent"] = Request.Url.ToString();
				}
				else 
				{
					ViewState["Parent"] = Refer;
				}

				performSelectionDataBinding();

				p_Code = Request.QueryString["ff"];

				if(p_Code != null)
				{
					performEditRemote(p_Code);
				}
			}
			else
			{
				ViewState["Count"] = (int)ViewState["Count"] + 1;
			}

		}

		private void performEditRemote(string p_Code) 
		{
			this.ComboBox1.SelectedValue = p_Code;
			txtNum.Text = ComboBox1.Items.IndexOf(ComboBox1.Items.FindByValue(p_Code)).ToString();
            if (txtNum.Text == "-1")
            {
                string script = "";
                string errMsg = "User data is not in Database, Please save user data first.";
                script = "<script language='javascript'> ";
                script += "alert(' " + errMsg + " '); ";
                script += "window.close(); ";
                script += "</script>";
                this.ClientScript.RegisterClientScriptBlock(this.GetType(), "Pre", script);
                return;
            }
			this.Panel1.Visible = true;
			PerformUser();
			PerformGetAll();
		}

		private void PerformDefault()
		{
			btnGo.Attributes.Add("onclick",  "Javascript:ReqDataCheck();");
			this.Panel1.Visible = false;
		}

		private void performSelectionDataBinding()
		{

            ConnectStr = (new igFunctions.DB().getConStr());			
			SqlConnection Con = new SqlConnection(ConnectStr);

			SqlCommand cmdCustomer = new SqlCommand(@"
														SELECT	userid,login_name
														  FROM	users 
														WHERE	elt_account_number = " + elt_account_number +
                " order by login_name", Con);

			SqlDataAdapter Adap = new SqlDataAdapter();
			DataSet tmpDs = new DataSet();
				
			Con.Open();

			Adap.SelectCommand = cmdCustomer;
			Adap.Fill(tmpDs, "Users");

			Con.Close();

            ComboBox1.DataSource = tmpDs.Tables["Users"];
            ComboBox1.DataTextField = tmpDs.Tables["Users"].Columns["login_name"].ToString();
            ComboBox1.DataValueField = tmpDs.Tables["Users"].Columns["userid"].ToString();
			ComboBox1.DataBind();

            DropDownList2.DataSource = tmpDs.Tables["Users"];
            DropDownList2.DataTextField = tmpDs.Tables["Users"].Columns["login_name"].ToString();
            DropDownList2.DataValueField = tmpDs.Tables["Users"].Columns["userid"].ToString();
            DropDownList2.DataBind();
            DropDownList2.Items.Insert(0," ");
            DropDownList2.SelectedIndex = 0;

            for (int i = 0; i < 7; i++)
            {
                DropDownList1.Items.Add("");
            }

            DropDownList1.Items[0].Value = "0"; DropDownList1.Items[0].Text = " ";
            DropDownList1.Items[1].Value = "1"; DropDownList1.Items[1].Text = "Customer";
            DropDownList1.Items[2].Value = "2"; DropDownList1.Items[2].Text = "Agent";
            DropDownList1.Items[3].Value = "3"; DropDownList1.Items[3].Text = "Operation";
            DropDownList1.Items[4].Value = "4"; DropDownList1.Items[4].Text = "Accounting";
            DropDownList1.Items[5].Value = "5"; DropDownList1.Items[5].Text = "Site Administrator";
            DropDownList1.Items[6].Value = "6"; DropDownList1.Items[6].Text = "Super User";


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

		private void PerformUser()
		{
			string strCommandText = "";
			string strUserID = null;

			if( ComboBox1.Text != "")
			{
                strUserID = ComboBox1.SelectedValue;
                ViewState["strUser"] = strUserID;
                strUserInfo.Text = "Allowed pages to User ID: " + ComboBox1.SelectedItem.Text;
			}
			else
			{
				string script = "<script language='javascript'> alert('Please select a user!!');";
				script += "</script>";
				this.ClientScript.RegisterStartupScript(this.GetType(), "Pre", script);
				return;
			}

            strCommandText = @"SELECT '' as Chk, 
                                      a.Page_Id, 
                        b.description as Module, 
                                 c.name as Page, 
                   c.description as Description,
                                 c.type as Type, 
                    CASE    WHEN a.Authority_Id = '0' THEN
                            'false' 
                        WHEN  a.Authority_Id = '1' THEN
                            'true' 
                        ELSE 'true' 
                    END AS R
                                   from SE_User_Authority a,SE_MODULES b,SE_Pages c where b.module_id = c.module_id and a.Page_id = c.Page_id";
            strCommandText += " and elt_account_number=" + elt_account_number + " and UserID=" + strUserID;
            strCommandText += " order by b.module_id ,a.Page_Id ";

			PerformGetCusData(strCommandText);
		}

		private void PerformFilterAll()
		{
            //string keyVal = "";
            //for(int i=0;i<UltraWebGrid1.Rows.Count;i++)
            //{
            //    keyVal = UltraWebGrid1.Rows[i].Cells.FromKey("sb").Text;
            //    for(int j=0;j<UltraWebGrid2.Rows.Count;j++)
            //    {
            //        if(UltraWebGrid2.Rows[j].Cells.FromKey("sb").Text == keyVal)
            //        {
            //            UltraWebGrid2.Rows[j].Delete();
            //            break;
            //        }
            //    }
            //}

		}

		private void PerformGetAll()
		{
			string strCommandText = "";

            strCommandText = "SELECT '' as Chk, a.Page_Id, b.description as Module,a.name as Page,a.description as Description,a.Type  from SE_PAGES a,SE_MODULES b where a.module_id = b.module_id order by b.module_id";

			PerformGetAllData(strCommandText);

			PerformFilterAll();

		}
		
		private bool PerformSave()
		{
			string strUser = ViewState["strUser"].ToString();

            if (strUser == null) return false;

            string strInsert = @" INSERT INTO SE_User_Authority 
													(
														elt_account_number,
														UserID,
														Page_Id,
														Authority_Id
													)
											VALUES 
														(
														@elt_account_number,
														@UserID,
														@Page_Id,
														@Authority_Id
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

                Cmd.CommandText = "DELETE SE_User_Authority  WHERE  elt_account_number=@elt_account_number AND UserID=@UserID";
				Cmd.Parameters.Add("@elt_account_number", SqlDbType.Decimal,9).Value = elt_account_number;
                Cmd.Parameters.Add("@UserID", SqlDbType.Decimal, 9).Value = strUser;
				Cmd.ExecuteNonQuery();

				Cmd.CommandText = strInsert;
				for(int i=0;i<UltraWebGrid1.Rows.Count;i++)
				{
                    string strR = "0";
                    if (UltraWebGrid1.Rows[i].Cells.FromKey("R").Text.Trim().ToLower() == "true")
                    {
                        strR = "1";
                    }
                    else
                    {
                        strR = "0";
                    }

					Cmd.Parameters.Clear();
					Cmd.Parameters.Add("@elt_account_number", SqlDbType.Decimal,9).Value = elt_account_number;
                    Cmd.Parameters.Add("@UserID", SqlDbType.Decimal, 9).Value = strUser;
                    Cmd.Parameters.Add("@Page_Id", SqlDbType.Int, 4).Value = (UltraWebGrid1.Rows[i].Cells.FromKey("Page_Id").Text == null ? "0" : UltraWebGrid1.Rows[i].Cells.FromKey("Page_Id").Text);
                    Cmd.Parameters.Add("@Authority_Id", SqlDbType.Int, 4).Value = int.Parse(strR);
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

        private bool PerformSaveCopy(string strSourceUser)
        {
            string strUser = ComboBox1.SelectedValue;

            if (strUser == null) return false;

            string strInsert = @" insert into SE_User_Authority 
                                            (elt_account_number,UserID,Page_Id,Authority_Id)
                                        select elt_account_number,";
            strInsert += strUser + ",page_Id,Authority_Id from SE_User_Authority where elt_account_number =";
            strInsert += elt_account_number + " and UserID =" + strSourceUser;

            ConnectStr = (new igFunctions.DB().getConStr());
            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand Cmd = new SqlCommand();
            Cmd.Connection = Con;

            Con.Open();

            SqlTransaction trans = Con.BeginTransaction();

            Cmd.Transaction = trans;

            try
            {

                Cmd.CommandText = "DELETE SE_User_Authority  WHERE  elt_account_number=@elt_account_number AND UserID=@UserID";
                Cmd.Parameters.Add("@elt_account_number", SqlDbType.Decimal, 9).Value = elt_account_number;
                Cmd.Parameters.Add("@UserID", SqlDbType.Decimal, 9).Value = strUser;
                Cmd.ExecuteNonQuery();

                Cmd.CommandText = strInsert;
                Cmd.ExecuteNonQuery();

                trans.Commit();

            }
            catch (Exception ex)
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
        private bool PerformSaveCopyAsType(string strSourceUser)
        {
            string strUser = ComboBox1.SelectedValue;

            if (strUser == null) return false;

            string strInsert = @" insert into SE_User_Authority 
                                            (elt_account_number,UserID,Page_Id,Authority_Id)
                                        select elt_account_number,";
            strInsert += strUser + ",page_Id,Authority_Id from SE_User_Authority where elt_account_number = 00000000";
            strInsert += " and UserID =" + strSourceUser;

            ConnectStr = (new igFunctions.DB().getConStr());
            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand Cmd = new SqlCommand();
            Cmd.Connection = Con;

            Con.Open();

            SqlTransaction trans = Con.BeginTransaction();

            Cmd.Transaction = trans;

            try
            {

                Cmd.CommandText = "DELETE SE_User_Authority  WHERE  elt_account_number=@elt_account_number AND UserID=@UserID";
                Cmd.Parameters.Add("@elt_account_number", SqlDbType.Decimal, 9).Value = elt_account_number;
                Cmd.Parameters.Add("@UserID", SqlDbType.Decimal, 9).Value = strUser;
                Cmd.ExecuteNonQuery();

                Cmd.CommandText = strInsert;
                Cmd.ExecuteNonQuery();

                trans.Commit();

            }
            catch (Exception ex)
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

		private void btnReloadAll_Click(object sender, System.Web.UI.ImageClickEventArgs e)
		{
					PerformGetAll();
		}

        protected void btnGo_Click1(object sender, ImageClickEventArgs e)
        {
            this.UltraWebGrid1.ResetRows();
            this.Panel1.Visible = true;
            PerformUser();
            PerformGetAll();

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
            e.Layout.Bands[0].Columns.Insert(0, "Chk");
            e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.BackgroundImage = "../../../Images/mark_o.gif";
            e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.HorizontalAlign = HorizontalAlign.Center;
            e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.CustomRules = "background-position:center ;background-repeat:no-repeat";
            e.Layout.Bands[0].Columns.FromKey("Chk").Header.Caption = "";
            e.Layout.Bands[0].Columns.FromKey("Chk").Width = new Unit("30px");
            e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.BackColor = Color.FromArgb(249, 236, 212);
            e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Hand;
            e.Layout.Bands[0].Columns.FromKey("Chk").AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No;
//            e.Layout.Bands[0].Columns.FromKey("Description").Width = new Unit("180px");
            e.Layout.Bands[0].Columns.FromKey("R").Width = new Unit("30px");
            e.Layout.Bands[0].Columns.FromKey("R").Hidden = true;

            e.Layout.Bands[0].Columns.FromKey("Module").Width = new Unit("90px");
            e.Layout.Bands[0].Columns.FromKey("Page").Width = new Unit("100px");
            e.Layout.Bands[0].Columns.FromKey("Type").Width = new Unit("65px");
            e.Layout.Bands[0].Columns.FromKey("Page_Id").Hidden = true;
            e.Layout.Bands[0].Columns.FromKey("Description").Hidden = true;
            e.Layout.Bands[0].Columns.FromKey("R").Type = ColumnType.CheckBox;
            e.Layout.Bands[0].Columns.FromKey("R").AllowUpdate = AllowUpdate.Yes;
            e.Layout.Bands[0].Columns.FromKey("R").CellStyle.HorizontalAlign = HorizontalAlign.Center;
            e.Layout.Bands[0].Columns.FromKey("R").CellStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Hand;


        }
        protected void UltraWebGrid2_InitializeLayout(object sender, LayoutEventArgs e)
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
            e.Layout.Bands[0].Columns.Insert(0, "Chk");
            e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.BackgroundImage = "../../../Images/mark_o.gif";
            e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.HorizontalAlign = HorizontalAlign.Center;
            e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.CustomRules = "background-position:center ;background-repeat:no-repeat";
            e.Layout.Bands[0].Columns.FromKey("Chk").Header.Caption = "";
            e.Layout.Bands[0].Columns.FromKey("Chk").Width = new Unit("30px");
            e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.BackColor = Color.FromArgb(249, 236, 212);
            e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Hand;
            e.Layout.Bands[0].Columns.FromKey("Chk").AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No;
            e.Layout.Bands[0].Columns.FromKey("Description").Width = new Unit("180px");
            e.Layout.Bands[0].Columns.FromKey("Module").Width = new Unit("90px");
            e.Layout.Bands[0].Columns.FromKey("Page").Width = new Unit("100px");
            e.Layout.Bands[0].Columns.FromKey("Type").Width = new Unit("65px");
            e.Layout.Bands[0].Columns.FromKey("Page_Id").Hidden = true;

        }
        protected void btnMake_Click(object sender, ImageClickEventArgs e)
        {
            lblError.Text = "";
            if (DropDownList1.SelectedIndex > 0)
            {
                if (PerformSaveCopyAsType(DropDownList1.SelectedValue))
                {
                    lblError.Text = "Data was saved successfully.";
                    this.UltraWebGrid1.ResetRows();
                    this.Panel1.Visible = true;
                    PerformUser();
                    PerformGetAll();
                }
            }
            else
            {
                string script = "<script language='javascript'> alert('Please select any type of user!!');";
                script += "</script>";
                this.ClientScript.RegisterStartupScript(this.GetType(), "Pre", script);
            }
        }
        protected void btnSave_Click1(object sender, ImageClickEventArgs e)
        {
            lblError.Text = "";
            if (PerformSave())
            {
                lblError.Text = "Data was saved successfully.";
            }
        }
        protected void btnGo_Click2(object sender, ImageClickEventArgs e)
        {
            this.lblError.Text = "";
            this.UltraWebGrid1.ResetRows();
            this.Panel1.Visible = true;
            PerformUser();
            PerformGetAll();
        }
        protected void btnCopy_Click(object sender, ImageClickEventArgs e)
        {
            lblError.Text = "";
            if (DropDownList2.SelectedIndex > 0)
            {
                if (this.ComboBox1.SelectedValue == DropDownList2.SelectedValue)
                {
                    string script = "<script language='javascript'> alert('Please select another user!!');";
                    script += "</script>";
                    this.ClientScript.RegisterStartupScript(this.GetType(), "Pre", script);
                    return;
                }
                if (PerformSaveCopy(DropDownList2.SelectedValue))
                {
                    lblError.Text = "Data was saved successfully.";
                    this.UltraWebGrid1.ResetRows();
                    this.Panel1.Visible = true;
                    PerformUser();
                    PerformGetAll();
                }
            }
            else
            {
                string script = "<script language='javascript'> alert('Please select user who copy from!!');";
                script += "</script>";
                this.ClientScript.RegisterStartupScript(this.GetType(), "Pre", script);
            }
        }
        protected void ComboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            this.lblError.Text = "";
            this.UltraWebGrid1.ResetRows();
            this.Panel1.Visible = true;
            PerformUser();
            PerformGetAll();
        }
}
}
