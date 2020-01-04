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

namespace IFF_MAIN.ASPX.OnLines.MAWB
{
	/// <summary>
	/// ScheduleBCreate에 대한 요약 설명입니다.
	/// </summary>
    public partial class MAWBNumber : System.Web.UI.Page
	{
		public static string elt_account_number;
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
				ViewState["Count"]= 1;
                string strStartNo = "";
                string strEndNo = "";
                string str_D_FROM = "";
                string str_D_TO = "";
                string strStatus = "";
                if (Request.QueryString["StartNo"] != null && Request.QueryString["EndNo"] != null)
                {
                    strStartNo = Request.QueryString["StartNo"];
                    strEndNo = Request.QueryString["EndNo"];
                    str_D_FROM = Request.QueryString["D_FROM"];
                    str_D_TO = Request.QueryString["D_TO"];
                    strStatus = Request.QueryString["Status"];
                    txtStart.Text = strStartNo;
                    txtEnd.Text = strEndNo;
                    txt_D_From.Text = str_D_FROM;
                    txt_D_To.Text = str_D_TO;
                    txtStatus.Text = strStatus;
                    PerformDefault(strStartNo, strEndNo, str_D_FROM, str_D_TO, strStatus);
                }
                else
                {
                    Response.Write("javascript:self.close();");
                }

			}
			else
			{
				ViewState["Count"] = (int)ViewState["Count"] + 1;
			}

		}

        private void PerformDefault(string strStartNo, string strEndNo, string str_D_FROM, string str_D_TO, string strStatus)
		{
            PerformCus(strStartNo, strEndNo, str_D_FROM, str_D_TO, strStatus);
            this.TextBox1.Text = this.UltraWebGrid1.Rows.Count.ToString();
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


        private void PerformCus(string strStartNo, string strEndNo, string str_D_FROM, string str_D_TO, string strStatus)
		{
            //UltraWebGrid1.ResetColumns();
            //UltraWebGrid1.ResetBands();

            string strCommandText = @"
                                        select '' as Chk, 
                                    mawb_no as MAWB_NO, 
                               etd_date1 as ETD, 
                                                 File#,
                              Origin_port_id as Origin,
                                  Dest_port_id as Dest,
                                      status as Status,
                                          used as Used,
                    CASE    WHEN status = 'C' THEN 'true' 
                            ELSE 'false' 
                    END as Closed#,'' as Remark
                                      from mawb_number
                                    ";
            strCommandText += " where elt_account_number=" + elt_account_number;

            if (strStartNo != "" && strEndNo != "")
            {
                strCommandText += " AND mawb_no between '" + strStartNo + "' AND '"+ strEndNo + "'";
            }

            if (str_D_FROM != "" && str_D_TO != "")
            {
                strCommandText += " AND etd_date1 between '" + str_D_FROM + "' AND '" + str_D_TO + "'";
            }

            if (strStatus != "")
            {
                if (strStatus == "A") // Not Used
                {
                    strCommandText += " AND used ='N'";
                }
                else if (strStatus == "B")
                {
                    strCommandText += " AND used ='Y'";
                }
                else
                {
                    strCommandText += " AND status ='" + strStatus + "'";
                }
            }

            strCommandText += " order by mawb_no";

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

            string strMIN = "";
            string strMAX = "";
            string strCnt = "";

            for (int i = 0; i < UltraWebGrid1.Bands.Count; i++)
            {
                foreach (UltraGridColumn aColumn in this.UltraWebGrid1.Bands[i].Columns)
                {
                    if (aColumn.DataType == "System.DateTime")
                    {
                        aColumn.Format = "MM/dd/yyyy";
                    }
                }
            }

            for(int i=0;i<UltraWebGrid1.Rows.Count;i++)
			{
                if (i == 0)
                {
                    strMIN = UltraWebGrid1.Rows[i].Cells.FromKey("MAWB_NO").Text;
                }
                if (i == (UltraWebGrid1.Rows.Count - 1))
                {
                    strMAX = UltraWebGrid1.Rows[i].Cells.FromKey("MAWB_NO").Text;
                }

            }
            strCnt = UltraWebGrid1.Rows.Count.ToString();
            if (UltraWebGrid1.Rows.Count > 100)
            {
                lblMessage.Text = string.Format("You are now working with MAWB# : <FONT color='red' size='1pt'>{0}</FONT>  ~ <FONT color='red' size='1pt'>{1}</FONT> [{2} Number(s)].<br> For the safety reason, please limit the number of working records below 200.", strMIN, strMAX, strCnt);
            }
            else
            {
                lblMessage.Text = string.Format("You are now working with MAWB# : <FONT color='red' size='1pt'>{0}</FONT>  ~ <FONT color='red' size='1pt'>{1}</FONT> [{2} Number(s)]", strMIN, strMAX, strCnt);
            }

		}


        private bool PerformSave()
		{
            
            string strStartNo = txtStart.Text;
            string strEndNo = txtEnd.Text;
            string str_D_FROM = txt_D_From.Text;
            string str_D_TO = txt_D_To.Text;
            string strStatus = txtStatus.Text;

            string strDelete = @"
                                        delete
                                       mawb_number ";
            strDelete += " where elt_account_number= " + elt_account_number;
            if (strStartNo != "0" && strEndNo != "0")
            {
                strDelete += " AND mawb_no between '" + strStartNo + "' AND '" + strEndNo + "'";
            }
            
            if (str_D_FROM != "" && str_D_TO != "")
            {
                strDelete += " AND etd_date1 between '" + str_D_FROM + "' AND '" + str_D_TO + "'";
            }

            if (strStatus != "")
            {
                if (strStatus == "A") // Not Used
                {
                    strDelete += " AND used ='N'";
                }
                else if (strStatus == "B")
                {
                    strDelete += " AND used ='Y'";
                }
                else
                {
                    strDelete += " AND status ='" + strStatus + "'";
                }
            }
//            strDelete += " AND used <> 'Y'";
			string strInsert= @" INSERT INTO mawb_number 
													(
                                                        elt_account_number,
                                                        mawb_no,
                                                        Carrier_Code,
                                                        Carrier_Desc,
                                                        scac,
                                                        Flight#,
                                                        File#,
                                                        Created_Date,
                                                        Origin_Port_ID,
                                                        origin_port_aes_code,
                                                        Origin_Port_Location,
                                                        Origin_Port_State,
                                                        Origin_Port_Country,
                                                        Dest_Port_ID,
                                                        dest_port_aes_code,
                                                        Dest_Port_Location,
                                                        Dest_Port_Country,
                                                        dest_country_code,
                                                        [To],
                                                        [By],
                                                        To_1,
                                                        By_1,
                                                        To_2,
                                                        By_2,
                                                        Flight#1,
                                                        Flight#2,
                                                        ETD_DATE1,
                                                        ETD_DATE2,
                                                        ETA_DATE1,
                                                        ETA_DATE2,
                                                        Weight_Reserved,
                                                        Weight_Scale,
                                                        airline_staff,
                                                        Status,
                                                        used )
											VALUES 
														(
                                                        @elt_account_number,
                                                        @mawb_no,
                                                        @Carrier_Code,
                                                        @Carrier_Desc,
                                                        @scac,
                                                        @Flight#,
                                                        @File#,
                                                        @Created_Date,
                                                        @Origin_Port_ID,
                                                        @origin_port_aes_code,
                                                        @Origin_Port_Location,
                                                        @Origin_Port_State,
                                                        @Origin_Port_Country,
                                                        @Dest_Port_ID,
                                                        @dest_port_aes_code,
                                                        @Dest_Port_Location,
                                                        @Dest_Port_Country,
                                                        @dest_country_code,
                                                        @To,
                                                        @By,
                                                        @To_1,
                                                        @By_1,
                                                        @To_2,
                                                        @By_2,
                                                        @Flight#1,
                                                        @Flight#2,
                                                        @ETD_DATE1,
                                                        @ETD_DATE2,
                                                        @ETA_DATE1,
                                                        @ETA_DATE2,
                                                        @Weight_Reserved,
                                                        @Weight_Scale,
                                                        @airline_staff,
                                                        @Status,
                                                        @used	
													)";


            ConnectStr = (new igFunctions.DB().getConStr());
			SqlConnection	Con = new SqlConnection(ConnectStr);
			SqlCommand		Cmd = new SqlCommand();
			Cmd.Connection = Con;
            SqlDataAdapter Adap = new SqlDataAdapter();

			Con.Open();

            string strCommandText = @"
                                        select *
                                      from mawb_number ";
            strCommandText += " where elt_account_number= " + elt_account_number;
            if (strStartNo != "0" && strEndNo != "0")
            {
                strCommandText += " AND mawb_no between '" + strStartNo + "' AND '" + strEndNo + "'";
            }

            strCommandText += " order by mawb_no";
            Cmd.CommandText = strCommandText;
            Adap.SelectCommand = Cmd;
            Adap.Fill(ds, "AllData");


			SqlTransaction trans = Con.BeginTransaction();

			Cmd.Transaction = trans;

			try
			{

                Cmd.CommandText = strDelete;
				Cmd.ExecuteNonQuery();

				Cmd.CommandText = strInsert;
				for(int i=0;i<UltraWebGrid1.Rows.Count;i++)
				{
                    string f1 = "MAWB_NO='" + UltraWebGrid1.Rows[i].Cells.FromKey("MAWB_NO").Text + "'";
                    foreach (DataRow eRow in ds.Tables["AllData"].Select(f1))
                    {
                        Cmd.Parameters.Clear();
                        Cmd.Parameters.Add("@elt_account_number", SqlDbType.Decimal,9).Value = elt_account_number;
                        Cmd.Parameters.Add("@mawb_no", SqlDbType.VarChar, 32).Value = eRow["mawb_no"].ToString();
                        Cmd.Parameters.Add("@Carrier_Code", SqlDbType.VarChar, 16).Value = eRow["Carrier_Code"].ToString();
                        Cmd.Parameters.Add("@Carrier_Desc", SqlDbType.VarChar, 32).Value = eRow["Carrier_Desc"].ToString();
                        Cmd.Parameters.Add("@scac", SqlDbType.VarChar, 32).Value = eRow["scac"].ToString();
                        Cmd.Parameters.Add("@Flight#", SqlDbType.VarChar, 8).Value = eRow["Flight#"].ToString();
                        Cmd.Parameters.Add("@File#", SqlDbType.VarChar, 32).Value = eRow["File#"].ToString();
                        Cmd.Parameters.Add("@Created_Date", SqlDbType.DateTime).Value = eRow["Created_Date"];
                        Cmd.Parameters.Add("@Origin_Port_ID", SqlDbType.VarChar, 3).Value = eRow["Origin_Port_ID"].ToString();
                        Cmd.Parameters.Add("@origin_port_aes_code", SqlDbType.Decimal, 9).Value = eRow["origin_port_aes_code"];
                        Cmd.Parameters.Add("@Origin_Port_Location", SqlDbType.VarChar, 32).Value = eRow["Origin_Port_Location"].ToString();
                        Cmd.Parameters.Add("@Origin_Port_State", SqlDbType.VarChar, 8).Value = eRow["Origin_Port_State"].ToString();
                        Cmd.Parameters.Add("@Origin_Port_Country", SqlDbType.VarChar, 32).Value = eRow["Origin_Port_Country"].ToString();
                        Cmd.Parameters.Add("@Dest_Port_ID", SqlDbType.VarChar, 3).Value = eRow["Dest_Port_ID"].ToString();
                        Cmd.Parameters.Add("@dest_port_aes_code", SqlDbType.Decimal, 9).Value = eRow["dest_port_aes_code"];
                        Cmd.Parameters.Add("@Dest_Port_Location", SqlDbType.VarChar, 32).Value = eRow["Dest_Port_Location"].ToString();
                        Cmd.Parameters.Add("@Dest_Port_Country", SqlDbType.VarChar, 32).Value = eRow["Dest_Port_Country"].ToString();
                        Cmd.Parameters.Add("@dest_country_code", SqlDbType.VarChar, 2).Value = eRow["dest_country_code"].ToString();
                        Cmd.Parameters.Add("@To", SqlDbType.VarChar, 3).Value = eRow["To"].ToString();
                        Cmd.Parameters.Add("@By", SqlDbType.VarChar, 32).Value = eRow["By"].ToString();
                        Cmd.Parameters.Add("@To_1", SqlDbType.VarChar, 3).Value = eRow["To_1"].ToString();
                        Cmd.Parameters.Add("@By_1", SqlDbType.VarChar, 17).Value = eRow["By_1"].ToString();
                        Cmd.Parameters.Add("@To_2", SqlDbType.VarChar, 3).Value = eRow["To_2"].ToString();
                        Cmd.Parameters.Add("@By_2", SqlDbType.VarChar, 17).Value = eRow["By_2"].ToString();
                        Cmd.Parameters.Add("@Flight#1", SqlDbType.VarChar, 32).Value = eRow["Flight#1"].ToString();
                        Cmd.Parameters.Add("@Flight#2", SqlDbType.VarChar, 32).Value = eRow["Flight#2"].ToString();
                        Cmd.Parameters.Add("@ETD_DATE1", SqlDbType.DateTime).Value = eRow["ETD_DATE1"];
                        Cmd.Parameters.Add("@ETD_DATE2", SqlDbType.DateTime).Value = eRow["ETD_DATE2"];
                        Cmd.Parameters.Add("@ETA_DATE1", SqlDbType.DateTime).Value = eRow["ETA_DATE1"];
                        Cmd.Parameters.Add("@ETA_DATE2", SqlDbType.DateTime).Value = eRow["ETA_DATE2"];
                        Cmd.Parameters.Add("@Weight_Reserved", SqlDbType.Decimal, 9).Value = eRow["Weight_Reserved"];
                        Cmd.Parameters.Add("@Weight_Scale", SqlDbType.VarChar, 4).Value = eRow["Weight_Scale"].ToString();
                        Cmd.Parameters.Add("@airline_staff", SqlDbType.VarChar, 64).Value = eRow["airline_staff"].ToString();

                        if (UltraWebGrid1.Rows[i].Cells.FromKey("Closed#").Text == "true")
                        {
                            /*
                            if (eRow["Used"].ToString() == "Y")
                            {
                                continue;
                            }
                             */
                            Cmd.Parameters.Add("@Status", SqlDbType.Char, 1).Value = "C";
                        }
                        else
                        { 
                        
                            if (eRow["Used"].ToString() == "Y")
                            {
                                Cmd.Parameters.Add("@Status", SqlDbType.Char, 1).Value = "B";
//                                continue;
                            }
                            else
                            {
                                Cmd.Parameters.Add("@Status", SqlDbType.Char, 1).Value = "A";
                            }

                        }
                        Cmd.Parameters.Add("@used", SqlDbType.Char, 1).Value = eRow["used"].ToString();
                     	Cmd.ExecuteNonQuery();
                    }
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

            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand cmdRecent = new SqlCommand();
            cmdRecent.Connection = Con;
            Con.Open();
            cmdRecent.CommandText = SQL;
            try
            {
                cmdRecent.ExecuteNonQuery();
            }
            catch (Exception)
            {

            }
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
                string strStartNo = txtStart.Text;
                string strEndNo = txtEnd.Text;

                PerformRecentDB("/ASP/master_data/new_edit_mawb.asp", strStartNo + "~" + strEndNo, "Change status of MAWB No.", "MD->MAWB No. Mgr.");
// private void PerformRecentDB(string sURL, string DocNum, string WorkDetail, string strSoTitle)
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

            e.Layout.Bands[0].Columns.FromKey("MAWB_NO").Width = new Unit("90px");
            e.Layout.Bands[0].Columns.FromKey("ETD").Width = new Unit("80px");
            e.Layout.Bands[0].Columns.FromKey("Origin").Width = new Unit("40px");
            e.Layout.Bands[0].Columns.FromKey("Dest").Width = new Unit("40px");
            e.Layout.Bands[0].Columns.FromKey("Status").Hidden = true;
            e.Layout.Bands[0].Columns.FromKey("Used").Width = new Unit("40px");
            e.Layout.Bands[0].Columns.FromKey("Remark").Width = new Unit("200px");
            e.Layout.Bands[0].Columns.FromKey("Remark").CellStyle.ForeColor = Color.Red;
            //e.Layout.Bands[0].Columns.FromKey("MAWB").Width = new Unit("40px");
            //e.Layout.Bands[0].Columns.FromKey("Invoice#").Width = new Unit("50px");

            e.Layout.Bands[0].Columns.FromKey("Closed#").Type = ColumnType.CheckBox;
            e.Layout.Bands[0].Columns.FromKey("Closed#").AllowUpdate = AllowUpdate.Yes;
            e.Layout.Bands[0].Columns.FromKey("Closed#").CellStyle.HorizontalAlign = HorizontalAlign.Center;
            e.Layout.Bands[0].Columns.FromKey("Closed#").CellStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Hand;
            e.Layout.Bands[0].Columns.FromKey("Closed#").Width = new Unit("50px");

        }
        protected void UltraWebGrid1_InitializeRow(object sender, RowEventArgs e)
        {
            if (e.Row.Cells.FromKey("Status").Text == "C")
            {
                
            }

        }
}
}
