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
using Infragistics.WebUI.UltraWebGrid;


namespace IFF_MAIN.ASPX.OnLines.CompanyConfig
{
	/// <summary>
	/// AirExportOperationSelection에 대한 요약 설명입니다.
	/// </summary>
	public partial class CompanySearchSelection : System.Web.UI.Page
	{
		protected System.Web.UI.WebControls.Label Label14;
		protected System.Web.UI.WebControls.Label Label13;
		protected System.Web.UI.WebControls.Label Label11;
		protected System.Web.UI.WebControls.Label Label19;


		//*************************************************************************************************************************************************//

		string ChildPage = "CompanySearchDetail.aspx";
		string ParentTable="ORGANIZATION";
		string keyColName="ORG_ACCOUNT_NUMBER";
		string sHeaderName = "ORGANIZATION";

		string[] alphabet=new string[]{"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","?"}; 
		string pageColumn;
		int iPageCount = 27;
        protected string ConnectStr;

		protected DataSet ds = new DataSet();
		public static string elt_account_number;
		public string user_id,login_name,user_right;
		bool flagPage = true;
        public bool bReadOnly = false;

		//*************************************************************************************************************************************************//


		protected System.Web.UI.WebControls.DropDownList drSearch;
	
		protected void Page_Load(object sender, System.EventArgs e)
		{
            try
            {
                Session.LCID = 1033;
                elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
                user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
                user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
                login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
                ConnectStr = (new igFunctions.DB().getConStr());
                bReadOnly = new igFunctions.DB().AUTH_CHECK(elt_account_number, user_id, ConnectStr, Request.ServerVariables["URL"].ToLower(), "");

                if (!IsPostBack)
                {
                    performSelectionDataBinding();
                    this.UltraWebGrid1.Visible = false;
                    Dropdownlist2.Attributes.Add("onchange", "javascript:resetSearch();");
                }
                pageColumn = RadioButtonList1.SelectedItem.Value;
            }
            catch
            {
                Response.Write("<script>alert('Session Expired. Try logining in again'); self.close();</script>");
                Response.End();
            }
		}

		private void performSelectionDataBinding()
		{
			
			DropDownList1.Items.Add("ALL");
			DropDownList1.Items.Add("Shipper");
			DropDownList1.Items.Add("Consignee");
			DropDownList1.Items.Add("Forwarder");
			DropDownList1.Items.Add("Broker");
			DropDownList1.Items.Add("Trucker");
			DropDownList1.Items.Add("Warehousing");
			DropDownList1.Items.Add("Special/Others");
			DropDownList1.Items.Add("Govt");
			DropDownList1.Items.Add("CFS");
			DropDownList1.Items.Add("Carrier");
			DropDownList1.SelectedIndex = 0;


			for(int i=(int)'A';i<=(int)'Z';i++)
			{
				Dropdownlist2.Items.Add(((char)i).ToString());
			}
			Dropdownlist2.Items.Add("?");
			Dropdownlist2.SelectedIndex = 0;

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
			this.UltraWebGrid1.InitializeRow += new Infragistics.WebUI.UltraWebGrid.InitializeRowEventHandler(this.UltraWebGrid1_InitializeRow);
			this.ImageButton1.Click += new System.Web.UI.ImageClickEventHandler(this.ImageButton1_Click);

		}
		#endregion

		private void Button1_Click(object sender, System.EventArgs e)
		{
		}

		private void PerformIntelliSearch(string strAlpha)
		{
			pageColumn=RadioButtonList1.SelectedItem.Value;
//			string[] str = new string[9];

//			for(int i=0;i<str.Length;i++){ str[i] = ""; }

			if(txtSearchKey.Text != "") 
			{
				strAlpha  = txtSearchKey.Text;
			}

			System.Text.StringBuilder strHeader = PerformBuildSelectStr();

			if(Radiobuttonlist2.SelectedIndex!=2) 
			{

				if(strAlpha!="?")
				{
					switch (pageColumn) 
					{
						case "dba_name" :
							strHeader.Append(" and (dba_name LIKE '" +strAlpha+ "%'" + ") order by dba_name");
							break;
						case "business_state" :
							strHeader.Append(" and (business_state LIKE '" +strAlpha+ "%'" + ") order by business_state");
							break;
						default :
							strHeader.Append(" and (dba_name LIKE '" +strAlpha+ "%'" + ") order by dba_name");
							break;
					}
				}
				else
				{
					switch (pageColumn) 
					{
						case "dba_name" :
							strHeader.Append(" and (dba_name NOT LIKE '" + "'[A-Z]%'" + ") order by dba_name");
							break;
						case "business_state" :
							strHeader.Append(" and (business_state NOT LIKE '" + "'[A-Z]%'" + ") order by business_state");
							break;
						default :
							strHeader.Append(" and (dba_name NOT LIKE '" + "'[A-Z]%'" + ") order by dba_name");
							break;
					}
				}
			}

//			Session["Accounting_sPeriod"] = str[0];
//			Session["Accounting_sBranchName"]  = str[1];
//			Session["Accounting_sBranch_elt_account_number"]  = str[2];
//			Session["Accounting_sCompanName"]  = str[3];
//			Session["Accounting_sReportTitle"]  = str[4];
//			Session["Accounting_sSelectionParam"]  = str[5];
//			Session["str6"] = str[6];
//			Session["str7"] = str[7];
//			Session["str8"] = str[8];

			Session[sHeaderName] = strHeader.ToString();

		}

		private void PerformSearch(string strAlpha)
		{
			pageColumn=RadioButtonList1.SelectedItem.Value;

			if(txtSearchKey.Text != "") 
			{
				strAlpha  = txtSearchKey.Text;
				flagPage = false;
			}

			System.Text.StringBuilder strHeader = PerformBuildSelectStr();
            ConnectStr = (new igFunctions.DB().getConStr());
			SqlConnection Con = new SqlConnection(ConnectStr);
			SqlDataAdapter Adap = new SqlDataAdapter();

			if(strAlpha!="?")
			{
				switch (pageColumn) 
				{
					case "dba_name" :
						strHeader.Append(" and (dba_name LIKE @pDba_name) order by dba_name");
						SqlCommand cmdHeader1 = new SqlCommand(strHeader.ToString(),Con);
						cmdHeader1.Parameters.Add("@pDba_name ", SqlDbType.VarChar, 128).Value = strAlpha+"%";
						Con.Open();			
						Adap.SelectCommand = cmdHeader1;

						break;
					case "business_state" :
						strHeader.Append(" and (business_state LIKE @pState) order by business_state");
						SqlCommand cmdHeader2 = new SqlCommand(strHeader.ToString(),Con);
						cmdHeader2.Parameters.Add("@pState ", SqlDbType.VarChar, 128).Value = strAlpha+"%";
						Con.Open();			
						Adap.SelectCommand = cmdHeader2;
						break;
					default :
						strHeader.Append(" and (dba_name LIKE @pDba_name) order by dba_name");
						SqlCommand cmdHeader3 = new SqlCommand(strHeader.ToString(),Con);
						cmdHeader3.Parameters.Add("@pDba_name ", SqlDbType.VarChar, 128).Value = strAlpha+"%";
						Con.Open();			
						Adap.SelectCommand = cmdHeader3;
						break;
				}
			}
			else
			{
				switch (pageColumn) 
				{
					case "dba_name" :
						strHeader.Append(" and (dba_name NOT LIKE @pDba_name) order by dba_name");
						SqlCommand cmdHeader1 = new SqlCommand(strHeader.ToString(),Con);
						cmdHeader1.Parameters.Add("@pDba_name ", SqlDbType.VarChar, 128).Value = "[A-Z]%";
						Con.Open();			
						Adap.SelectCommand = cmdHeader1;

						break;
					case "business_state" :
						strHeader.Append(" and (business_state NOT LIKE @pState) order by business_state");
						SqlCommand cmdHeader2 = new SqlCommand(strHeader.ToString(),Con);
						cmdHeader2.Parameters.Add("@pState ", SqlDbType.VarChar, 128).Value = "[A-Z]%";
						Con.Open();			
						Adap.SelectCommand = cmdHeader2;
						break;
					default :
						strHeader.Append(" and (dba_name NOT LIKE @pDba_name) order by dba_name");
						SqlCommand cmdHeader3 = new SqlCommand(strHeader.ToString(),Con);
						cmdHeader3.Parameters.Add("@pDba_name ", SqlDbType.VarChar, 128).Value = "[A-Z]%";
						Con.Open();			
						Adap.SelectCommand = cmdHeader3;
						break;
				}
			}
			Adap.Fill(ds, ParentTable);			
			Con.Close();

			//			if(ds.Relations.Count<1) 
			//				ds.Relations.Add(ds.Tables[ParentTable].Columns[keyColName],ds.Tables[ChildTable].Columns[keyColName]);

			PerformDataBind();
		}

		private void PerformDataBind()
		{


			UltraWebGrid1.DataSource=ds.Tables[ParentTable].DefaultView;	
			UltraWebGrid1.DataBind();
			this.UltraWebGrid1.DisplayLayout.Pager.PageCount=iPageCount;

			//			if(UltraWebGrid1.Rows.Count<1)
			//			{
			//				UltraWebGrid1.Visible = false;
			//				lblNoData.Text = "No Data was found!";
			//				lblNoData.Visible = true;
			//			}
			//			else
			//			{
			//				lblNoData.Visible = false;
			//			}
			
			//			foreach(UltraGridColumn aColumn in this.UltraWebGrid1.Columns)
			//			{
			//				if(aColumn.DataType == "System.DateTime")
			//				{
			//					aColumn.Format = "MM/dd/yyyy";
			//				}
			//			}
		}
		private System.Text.StringBuilder PerformBuildSelectStr()
		{
			#region // All selection
//									EmailItemID
//									org_account_number
//									acct_name
//									dba_name
//									class_code
//									date_opened
//									last_update
//									business_legal_name
//									business_fed_taxid
//									business_st_taxid
//									business_address
//									business_city
//									business_state
//									business_zip
//									business_country
//									b_country_code
//									business_phone
//									business_fax
//									business_url
//									owner_ssn
//									owner_lname
//									owner_fname
//									owner_mname
//									owner_mail_address
//									owner_mail_city
//									owner_mail_state
//									owner_mail_zip
//									owner_mail_country
//									owner_phone
//									owner_email
//									attn_name
//									notify_name
//									is_shipper
//									is_consignee
//									broker_info
//									is_agent
//									agent_elt_acct
//									edt
//									is_vendor
//									is_carrier
//									iata_code
//									carrier_code
//									carrier_id
//									carrier_type
//									account_status
//									comment
//									credit_amt
//									bill_term
//									is_colodee
//									colodee_elt_acct
//									z_is_trucker
//									z_is_special
//									z_is_broker
//									z_is_warehousing
//									z_is_cfs
//									z_is_govt
//									z_bond_number
//									z_bond_exp_date
//									z_bond_amount
//									z_bond_surety
//									z_bank_name
//									z_bank_account_no
//									z_trucker_chl_no
//									z_trucker_con_type
//									z_warehousing_chl_no
//									z_cfs_firm_code
//									z_carrier_firm_code
//									z_carrier_code
//									z_carrier_prefix
//									z_carrier_isc_charges
#endregion 

			string bizType = this.DropDownList1.SelectedValue.ToString();
			System.Text.StringBuilder strHeader = new System.Text.StringBuilder(4096);
			strHeader.Append(@"
										SELECT
                                                org_account_number,
                                                dba_name,
												business_city,
												business_state,
												business_country,
												business_phone,
												business_fax,
												business_url,
												( owner_lname + owner_mname + owner_fname ) as name,
												owner_phone,
												owner_email,
                                                is_consignee,
                                                is_shipper, 
                                                is_agent, 
                                                is_carrier,
                                                z_is_trucker,
                                                z_is_warehousing,
                                                z_is_cfs,
                                                z_is_broker,
                                                z_is_govt,
                                                z_is_special
                                           FROM organization 
                                           WHERE elt_account_number = " + elt_account_number 
							);

			switch (bizType) 
			{
				case "ALL" :
					break;
				case "Shipper" :
					strHeader.Append(" AND is_shipper = 'Y' ");
					break;
				case "Consignee" :
					strHeader.Append(" AND is_consignee = 'Y' ");
					break;
				case "Forwarder" :
					strHeader.Append(" AND is_agent = 'Y' ");
					break;
				case "Broker" :
					strHeader.Append(" AND z_is_broker = 'Y' ");
					break;
				case "Trucker" :
					strHeader.Append(" AND z_is_trucker = 'Y' ");
					break;
				case "Warehousing" :
					strHeader.Append(" AND z_is_warehousing = 'Y' ");
					break;
				case "Special/Others" :
					strHeader.Append(" AND z_is_special = 'Y' ");
					break;
				case "Govt" :
					strHeader.Append(" AND z_is_govt = 'Y' ");
					break;
				case "CFS" :
					strHeader.Append(" AND z_is_cfs = 'Y' ");
					break;
				case "Carrier" :
					strHeader.Append(" AND is_carrier = 'Y' ");
					break;			
				default:
					break;
			}

			return strHeader;

		}

		private void UltraWebGrid1_InitializeLayout(object sender, Infragistics.WebUI.UltraWebGrid.LayoutEventArgs e)
		{

		}

		private void UltraWebGrid1_InitializeRow(object sender, Infragistics.WebUI.UltraWebGrid.RowEventArgs e)
		{

		}

		private void ImageButton1_Click(object sender, System.Web.UI.ImageClickEventArgs e)
		{
			string tmpStr=this.Dropdownlist2.SelectedItem.Text.ToString().Substring(0,1);
			if(Radiobuttonlist2.SelectedIndex == 0)
			{
				PerformSearch(tmpStr);
				PerformDataBind();
				this.UltraWebGrid1.Visible = true;			
				UltraWebGrid1.DisplayLayout.Pager.CurrentPageIndex= (int) ((tmpStr.ToCharArray(0,1))[0]) -64;
			}
			else
			{
				PerformIntelliSearch(tmpStr);
				Response.Redirect(ChildPage);
			}


		}



        protected void UltraWebGrid1_InitializeLayout1(object sender, LayoutEventArgs e)
        {
            UltraWebGrid1.DisplayLayout.SelectTypeColDefault = SelectType.Extended;
            UltraWebGrid1.DisplayLayout.SelectTypeRowDefault = SelectType.Extended;

            UltraWebGrid1.DisplayLayout.ViewType = ViewType.Hierarchical;
            UltraWebGrid1.DisplayLayout.TableLayout = TableLayout.Fixed;
            //			UltraWebGrid1.DisplayLayout.RowStyleDefault.BorderDetails.ColorTop=Color.Gray;

            //			for(int i=0;i<UltraWebGrid1.Bands.Count;i++)
            //			{
            //				for(int j=0;j<UltraWebGrid1.Bands[i].Columns.Count;j++)
            //				{
            //					UltraWebGrid1.DisplayLayout.Bands[i].Columns[j].SelectedCellStyle.BackColor=Color.FromArgb(73,30,138);
            //					UltraWebGrid1.DisplayLayout.Bands[i].Columns[j].SelectedCellStyle.ForeColor=Color.WhiteSmoke;
            //				}
            //			}

            //			UltraWebGrid1.Bands[0].RowStyle.BackColor=Color.WhiteSmoke;

            //			UltraWebGrid1.DisplayLayout.SelectedHeaderStyleDefault.BackColor=Color.Red;
            UltraWebGrid1.DisplayLayout.SelectTypeCellDefault = Infragistics.WebUI.UltraWebGrid.SelectType.Single;
            UltraWebGrid1.DisplayLayout.AllowColSizingDefault = Infragistics.WebUI.UltraWebGrid.AllowSizing.Free;

            //set cursor 
            UltraWebGrid1.DisplayLayout.FrameStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Default;
            UltraWebGrid1.DisplayLayout.Bands[0].HeaderStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Default;

            //			UltraWebGrid1.DisplayLayout.SelectedHeaderStyleDefault.BackColor=Color.Red;		

            UltraWebGrid1.Bands[0].DataKeyField = ds.Tables[ParentTable].Columns[keyColName].ColumnName;

            //			PerformHeader_ON();
            //			PerformFooter_ON();

            if (flagPage)
            {
                e.Layout.Pager.Alignment = Infragistics.WebUI.UltraWebGrid.PagerAlignment.Center;
                e.Layout.Pager.AllowCustomPaging = true;
                e.Layout.Pager.AllowPaging = true;
                e.Layout.Pager.PagerAppearance = Infragistics.WebUI.UltraWebGrid.PagerAppearance.Both;
                e.Layout.Pager.PageSize = 3;
                e.Layout.Pager.CustomLabels = alphabet;
                e.Layout.Pager.StyleMode = Infragistics.WebUI.UltraWebGrid.PagerStyleMode.CustomLabels;
            }
            else
            {
                e.Layout.Pager.AllowPaging = false;
            }
            e.Layout.Bands[0].Columns.FromKey("org_account_number").Hidden = true;


            e.Layout.Bands[0].Columns.FromKey("dba_name").Header.Caption = "Company Name";
            e.Layout.Bands[0].Columns.FromKey("dba_name").Width = new Unit("140px");
            e.Layout.Bands[0].Columns.FromKey("business_city").Header.Caption = "City";
            e.Layout.Bands[0].Columns.FromKey("business_city").Width = new Unit("80px");
            e.Layout.Bands[0].Columns.FromKey("business_state").Header.Caption = "State";
            e.Layout.Bands[0].Columns.FromKey("business_state").Width = new Unit("30px");
            e.Layout.Bands[0].Columns.FromKey("business_country").Header.Caption = "Country";
            e.Layout.Bands[0].Columns.FromKey("business_country").Width = new Unit("50px");
            e.Layout.Bands[0].Columns.FromKey("business_phone").Header.Caption = "Phone";
            e.Layout.Bands[0].Columns.FromKey("business_phone").Width = new Unit("80px");
            e.Layout.Bands[0].Columns.FromKey("business_fax").Header.Caption = "Fax";
            e.Layout.Bands[0].Columns.FromKey("business_fax").Width = new Unit("80px");
            e.Layout.Bands[0].Columns.FromKey("business_url").Header.Caption = "URL";
            e.Layout.Bands[0].Columns.FromKey("business_url").Width = new Unit("60px");
            e.Layout.Bands[0].Columns.FromKey("owner_phone").Header.Caption = "P.Phone";
            e.Layout.Bands[0].Columns.FromKey("owner_phone").Width = new Unit("80px");
            e.Layout.Bands[0].Columns.FromKey("owner_email").Header.Caption = "eMail";
            e.Layout.Bands[0].Columns.FromKey("owner_email").Width = new Unit("80px");
            e.Layout.Bands[0].Columns.FromKey("name").Hidden = true;

            e.Layout.Bands[0].Columns.FromKey("is_shipper").Header.Caption = "Shp";
            e.Layout.Bands[0].Columns.FromKey("is_shipper").Width = new Unit("30px");
            e.Layout.Bands[0].Columns.FromKey("is_shipper").CellStyle.HorizontalAlign = System.Web.UI.WebControls.HorizontalAlign.Center;

            e.Layout.Bands[0].Columns.FromKey("z_is_trucker").Header.Caption = "Trk";
            e.Layout.Bands[0].Columns.FromKey("z_is_trucker").Width = new Unit("30px");
            e.Layout.Bands[0].Columns.FromKey("z_is_trucker").CellStyle.HorizontalAlign = System.Web.UI.WebControls.HorizontalAlign.Center;

            e.Layout.Bands[0].Columns.FromKey("is_carrier").Header.Caption = "Crr";
            e.Layout.Bands[0].Columns.FromKey("is_carrier").Width = new Unit("30px");
            e.Layout.Bands[0].Columns.FromKey("is_carrier").CellStyle.HorizontalAlign = System.Web.UI.WebControls.HorizontalAlign.Center;

            e.Layout.Bands[0].Columns.FromKey("is_consignee").Header.Caption = "Cgn";
            e.Layout.Bands[0].Columns.FromKey("is_consignee").Width = new Unit("30px");
            e.Layout.Bands[0].Columns.FromKey("is_consignee").CellStyle.HorizontalAlign = System.Web.UI.WebControls.HorizontalAlign.Center;

            e.Layout.Bands[0].Columns.FromKey("is_agent").Header.Caption = "Agn";
            e.Layout.Bands[0].Columns.FromKey("is_agent").Width = new Unit("30px");
            e.Layout.Bands[0].Columns.FromKey("is_agent").CellStyle.HorizontalAlign = System.Web.UI.WebControls.HorizontalAlign.Center;

            e.Layout.Bands[0].Columns.FromKey("z_is_special").Header.Caption = "Otr";
            e.Layout.Bands[0].Columns.FromKey("z_is_special").Width = new Unit("30px");
            e.Layout.Bands[0].Columns.FromKey("z_is_special").CellStyle.HorizontalAlign = System.Web.UI.WebControls.HorizontalAlign.Center;

            e.Layout.Bands[0].Columns.FromKey("z_is_broker").Header.Caption = "Brk";
            e.Layout.Bands[0].Columns.FromKey("z_is_broker").Width = new Unit("30px");
            e.Layout.Bands[0].Columns.FromKey("z_is_broker").CellStyle.HorizontalAlign = System.Web.UI.WebControls.HorizontalAlign.Center;

            e.Layout.Bands[0].Columns.FromKey("z_is_cfs").Header.Caption = "CFS";
            e.Layout.Bands[0].Columns.FromKey("z_is_cfs").Width = new Unit("30px");
            e.Layout.Bands[0].Columns.FromKey("z_is_cfs").CellStyle.HorizontalAlign = System.Web.UI.WebControls.HorizontalAlign.Center;

            e.Layout.Bands[0].Columns.FromKey("z_is_govt").Header.Caption = "Gov";
            e.Layout.Bands[0].Columns.FromKey("z_is_govt").Width = new Unit("30px");
            e.Layout.Bands[0].Columns.FromKey("z_is_govt").CellStyle.HorizontalAlign = System.Web.UI.WebControls.HorizontalAlign.Center;

            e.Layout.Bands[0].Columns.FromKey("z_is_warehousing").Header.Caption = "WH";
            e.Layout.Bands[0].Columns.FromKey("z_is_warehousing").Width = new Unit("30px");
            e.Layout.Bands[0].Columns.FromKey("z_is_warehousing").CellStyle.HorizontalAlign = System.Web.UI.WebControls.HorizontalAlign.Center;
		
        }
        protected void UltraWebGrid1_InitializeRow1(object sender, RowEventArgs e)
        {
            string s;

            s = "javascript:; void(viewPopPF('" + "CompanyConfigCreate.aspx?WindowName=PopWin&number=" + (e.Row.Cells.FromKey("org_account_number").Value.ToString()) + "'))";
            e.Row.Cells.FromKey("dba_name").TargetURL = s ;
            if (e.Row.Cells.FromKey("business_url").Value != null)
            {
                e.Row.Cells.FromKey("business_url").TargetURL = e.Row.Cells.FromKey("business_url").Value.ToString();
            }
            if (e.Row.Cells.FromKey("owner_email").Value != null)
            {
                e.Row.Cells.FromKey("owner_email").TargetURL = e.Row.Cells.FromKey("owner_email").Value.ToString();
            }

            if (e.Row.Cells.FromKey("is_shipper").Text == "Y")
            {
                e.Row.Cells.FromKey("is_shipper").Text = "*";
                e.Row.Cells.FromKey("is_shipper").Style.BackColor = Color.Yellow;
            }
            if (e.Row.Cells.FromKey("z_is_trucker").Text == "Y")
            {
                e.Row.Cells.FromKey("z_is_trucker").Text = "*";
                e.Row.Cells.FromKey("z_is_trucker").Style.BackColor = Color.Yellow;
            }
            if (e.Row.Cells.FromKey("is_carrier").Text == "Y")
            {
                e.Row.Cells.FromKey("is_carrier").Text = "*";
                e.Row.Cells.FromKey("is_carrier").Style.BackColor = Color.Yellow;
            }
            if (e.Row.Cells.FromKey("is_consignee").Text == "Y")
            {
                e.Row.Cells.FromKey("is_consignee").Text = "*";
                e.Row.Cells.FromKey("is_consignee").Style.BackColor = Color.Yellow;
            }
            if (e.Row.Cells.FromKey("is_agent").Text == "Y")
            {
                e.Row.Cells.FromKey("is_agent").Text = "*";
                e.Row.Cells.FromKey("is_agent").Style.BackColor = Color.Yellow;
            }

            if (e.Row.Cells.FromKey("z_is_special").Text == "Y")
            {
                e.Row.Cells.FromKey("z_is_special").Text = "*";
                e.Row.Cells.FromKey("z_is_special").Style.BackColor = Color.Yellow;
            }
            if (e.Row.Cells.FromKey("z_is_broker").Text == "Y")
            {
                e.Row.Cells.FromKey("z_is_broker").Text = "*";
                e.Row.Cells.FromKey("z_is_broker").Style.BackColor = Color.Yellow;
            }
            if (e.Row.Cells.FromKey("z_is_cfs").Text == "Y")
            {
                e.Row.Cells.FromKey("z_is_cfs").Text = "*";
                e.Row.Cells.FromKey("z_is_cfs").Style.BackColor = Color.Yellow;
            }
            if (e.Row.Cells.FromKey("z_is_govt").Text == "Y")
            {
                e.Row.Cells.FromKey("z_is_govt").Text = "*";
                e.Row.Cells.FromKey("z_is_govt").Style.BackColor = Color.Yellow;
            }
            if (e.Row.Cells.FromKey("z_is_warehousing").Text == "Y")
            {
                e.Row.Cells.FromKey("z_is_warehousing").Text = "*";
                e.Row.Cells.FromKey("z_is_warehousing").Style.BackColor = Color.Yellow;
            }

		
        }
        protected void UltraWebGrid1_PageIndexChanged1(object sender, Infragistics.WebUI.UltraWebGrid.PageEventArgs e)
        {
            PerformSearch(alphabet[e.NewPageIndex - 1]);
            PerformDataBind();				
        }
}
}
