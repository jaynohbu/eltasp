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
	/// <summary>
	/// AccountingSelection에 대한 요약 설명입니다.
	/// </summary>
	public partial class SearchInvoiceSelection : System.Web.UI.Page
	{
		protected System.Web.UI.WebControls.Button Button1;


		string elt_account_number;
		public string user_id,login_name,user_right;
        protected string ConnectStr;

		string sHeaderName = "SEARCHINVOICE";
		protected System.Web.UI.WebControls.Button Button2;
//		string sDetailName = "SEARCHINVOICEDETAIL";

        static public string windowName;
        public bool bReadOnly = false;

		protected void Page_Load(object sender, System.EventArgs e)
		{
			Session.LCID = 1033;

			elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
			user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
			login_name  = Request.Cookies["CurrentUserInfo"]["login_name"];
            windowName = Request.QueryString["WindowName"];
            user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
            ConnectStr = (new igFunctions.DB().getConStr());
			bReadOnly = new igFunctions.DB().AUTH_CHECK(elt_account_number, user_id, ConnectStr, Request.ServerVariables["URL"].ToLower(), "");
			
			if(!IsPostBack)
			{
				performSelectionDataBinding();
				ImageButton1.Attributes.Add("onclick","Javascript:return CheckDate();");
				txtInvoiceNum.Attributes.Add("onchange",  "Javascript:return isNum(this);");

				
			}
		}

		# region /// DateDefault
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
		# endregion

		private void performSelectionDataBinding()
		{
			
			ConnectStr = (new igFunctions.DB().getConStr());			
			SqlConnection Con = new SqlConnection(ConnectStr);

			SqlCommand cmdCustomer = new SqlCommand(@"
				SELECT	org_account_number, CASE WHEN isnull(class_code,'') = '' THEN dba_name
                             ELSE dba_name + '[' + RTRIM(LTRIM(isnull(class_code,''))) + ']'
                             END as dba_name
				  FROM	organization 
				WHERE	elt_account_number = " + elt_account_number + 
				"	AND ( dba_name != '' ) " +
				"	AND (" +
				"	  	is_shipper = 'Y' " +
				"	or	is_consignee = 'Y' " +
				"	or	is_agent = 'Y' ) " +
				" order by dba_name",Con);

			SqlDataAdapter Adap = new SqlDataAdapter();
			DataSet ds = new DataSet();
				
			Con.Open();

			Adap.SelectCommand = cmdCustomer;
			Adap.Fill(ds, "Customer");

			Con.Close();
		
			ComboBox1.DataSource =  ds.Tables["Customer"];
            ComboBox1.DataTextField = ds.Tables["Customer"].Columns["dba_name"].ToString();
			ComboBox1.DataValueField = ds.Tables["Customer"].Columns["org_account_number"].ToString();
			ComboBox1.DataBind();
			ComboBox1.Items.Insert(0,"");
			ComboBox1.SelectedIndex = 0;

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
			this.ImageButton1.Click += new System.Web.UI.ImageClickEventHandler(this.ImageButton1_Click);

		}
		#endregion

		private bool PerformDateCheck()
		{

			if (ComboBox1.Text != "" ) return true;
			if (txtInvoiceNum.Text != "" ) return true;
			if (txtHAWBNum.Text != "" ) return true;
			if (txtMAWBNum.Text != "" ) return true;
            if (txtRefNo.Text != "") return true;
            if (txtFileNo.Text != "") return true;

			if (Webdatetimeedit1.Text == "" )
			{
				//				Response.Write("<script language= 'javascript'> alert(' Please enter a from date!')</script>"); 
				return false;
			}
			return true;
		}

		private void PerformSearch()
		{
			string[] str = new string[9];
			for(int i=0;i<str.Length;i++){ str[i] = ""; }

			bool boolAND = true;
			System.Text.StringBuilder sbSQL = new System.Text.StringBuilder(4096);
			System.Text.StringBuilder sbSQLWhere = new System.Text.StringBuilder(4096);

			sbSQL.Append(@"									SELECT 
																							invoice_no,
																							Customer_Number,
																							Customer_Name as Customer,
																							mawb_num,
																							hawb_num,
																							invoice_date,
																							invoice_type,
																							import_export,
																							air_ocean,
																							ref_no as Ref_No,
																							ref_no_Our as File_No,
																							Total_Pieces,
																							Total_Gross_Weight,
																							amount_charged,
																							agent_profit,
																							sale_tax,
																							total_cost,
																							subtotal,
																							amount_paid,
																							balance,
																							pay_status,
																							origin_dest as Origin_Dest,
																							origin as Origin,
																							dest as Destination,
																							shipper as Shipper,
																							consignee as Consignee,
																							Carrier as Carrier,
																							Arrival_Dept,
																							Description
																				FROM		invoice WHERE ");

			sbSQLWhere.Append(" elt_account_number = " + elt_account_number );													
			

			// Invoice Date			
			if( Webdatetimeedit1.Text != "" )
			{
				if (boolAND) sbSQLWhere.Append(" AND");

				if( Webdatetimeedit2.Text == "" )
				{
					sbSQLWhere.Append(" (invoice_date >= '" + Webdatetimeedit1.Date.ToShortDateString() + "' "); 
					sbSQLWhere.Append(" AND");
					sbSQLWhere.Append(" invoice_date < DATEADD(day, 1,'" + Webdatetimeedit1.Date.ToShortDateString() + "')) "); 
					boolAND = true;
					
					str[0] = string.Format("Invoice Date : {0}", Webdatetimeedit1.Date.ToShortDateString());
				}
				else
				{
					sbSQLWhere.Append(" (invoice_date >= '" + Webdatetimeedit1.Date.ToShortDateString() + "' "); 
					sbSQLWhere.Append(" AND");
					sbSQLWhere.Append(" invoice_date < DATEADD(day, 1,'" + Webdatetimeedit2.Date.ToShortDateString() + "')) "); 
					boolAND = true;

					str[0] = string.Format("Invoice Date : {0} ~ {1}", Webdatetimeedit1.Date.ToShortDateString(),Webdatetimeedit2.Date.ToShortDateString());

				}
			}

			// Company

            if (ComboBox1.Text != "" && txtNum.Text != null && txtNum.Text != "")
            {
				ComboBox1.SelectedIndex = int.Parse(txtNum.Text);

				if (boolAND) sbSQLWhere.Append(" AND");
				sbSQLWhere.Append(" ( Customer_Number = '" + ComboBox1.SelectedValue + "') ");
				boolAND = true;


				str[1] = string.Format("Company : {0}", ComboBox1.Text  );

			}

			// Invoice Number

			if( txtInvoiceNum.Text != "")
			{
				if (boolAND) sbSQLWhere.Append(" AND");
				sbSQLWhere.Append(" ( invoice_no = '" + txtInvoiceNum.Text + "') ");
				boolAND = true;

				str[2] = string.Format("Invoice # : {0}", txtInvoiceNum.Text );
			}

			// HAWB Number

			if( txtHAWBNum.Text != "")
			{
				if (boolAND) sbSQLWhere.Append(" AND");
				sbSQLWhere.Append(" (hawb_num like '%" + txtHAWBNum.Text + "%') ");
				boolAND = true;

				str[3] = string.Format("HAWB # : {0}", txtHAWBNum.Text );
			}

			// MAWB Number

			if( txtMAWBNum.Text != "")
			{
				if (boolAND) sbSQLWhere.Append(" AND");
				sbSQLWhere.Append(" (mawb_num like '%" + txtMAWBNum.Text + "%') ");
				boolAND = true;

				str[4] = string.Format("MAWB # : {0}", txtMAWBNum.Text );
			}

            if( DropDownList1.SelectedValue == "Import")										

			{
				if (boolAND) sbSQLWhere.Append(" AND");
				sbSQLWhere.Append(" ( import_export = 'I') ");
				boolAND = true;

				str[5] = string.Format("Import/Export : {0}", DropDownList1.SelectedItem.Text );

			}
			else if( DropDownList1.SelectedValue == "Export")										

			{
				if (boolAND) sbSQLWhere.Append(" AND");
				sbSQLWhere.Append(" ( import_export != 'I') ");
				boolAND = true;

				str[5] = string.Format("Import/Export : {0}", DropDownList1.SelectedItem.Text );

			}

			if( DropDownList2.SelectedValue == "Air")										

			{
				if (boolAND) sbSQLWhere.Append(" AND");
				sbSQLWhere.Append(" ( air_ocean = 'A') ");
				boolAND = true;

				str[6] = string.Format("Air/Ocean : {0}", DropDownList2.SelectedItem.Text );

			}
			else if( DropDownList2.SelectedValue == "Ocean")										

			{
				if (boolAND) sbSQLWhere.Append(" AND");
                sbSQLWhere.Append(" ( air_ocean != 'A') ");
				boolAND = true;

				str[6] = string.Format("Air/Ocean : {0}", DropDownList2.SelectedItem.Text );

			}

			if(CheckBox1.Checked) 
			{
				if (boolAND) sbSQLWhere.Append(" AND");
				sbSQLWhere.Append(" ( invoice_type = 'I' AND balance>0 AND pay_status='A') ");
				boolAND = true;
			}

            if (txtRefNo.Text != "")
            {
                if (boolAND) sbSQLWhere.Append(" AND");
                sbSQLWhere.Append(" (ref_no like '%" + txtRefNo.Text + "%') ");
                boolAND = true;

                str[7] = string.Format("Ref. # : {0}", txtRefNo.Text);
            }

            if (txtFileNo.Text != "")
            {
                if (boolAND) sbSQLWhere.Append(" AND");
                sbSQLWhere.Append(" (replace(ref_no_Our,'-','') like '%" + txtFileNo.Text.Replace("-","") + "%') ");
                boolAND = true;

                str[8] = string.Format("File # : {0}", txtFileNo.Text);
            }

			sbSQL.Append( sbSQLWhere.ToString() +" order by invoice_no ");

			Session["str0"] = str[0];
			Session["str1"] = str[1];
			Session["str2"] = str[2];
			Session["str3"] = str[3];
			Session["str4"] = str[4];
			Session["str5"] = str[5];
			Session["str6"] = str[6];
            Session["str7"] = str[7];
            Session["str8"] = str[8];
            Session[sHeaderName] = sbSQL.ToString();
		
		}

		private void Button2_Click(object sender, System.EventArgs e)
		{

            Response.Redirect("ARAgingSummary.aspx?" + "WindowName=" + windowName);
		}

		private void ImageButton1_Click(object sender, System.Web.UI.ImageClickEventArgs e)
		{

		}
        protected void ImageButton1_Click1(object sender, ImageClickEventArgs e)
        {
            if (!PerformDateCheck()) return;
            PerformSearch();
            if (this.RadioButtonList1.SelectedIndex == 0)
            {
                Response.Redirect("SearchInvoiceDetail2.aspx?" + "WindowName=" + windowName);
            }
            else
            {
                Response.Redirect("SearchInvoiceDetail.aspx?" + "WindowName=" + windowName);
            }
        }
}
}
