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
	/// AirExportOperationDetail에 대한 요약 설명입니다.
	/// </summary>
	public partial class CompanySearchDetail : System.Web.UI.Page
	{
		protected System.Web.UI.WebControls.Button butShowCols;

//***********************************************************//
		string ParentTable="ORGANIZATION";
		string ParentPage="CompanySearchSelection.aspx";
		string keyColName="ORG_ACCOUNT_NUMBER";
		string dsXMLName ="ORGANIZATION";
		string sHeaderName = "ORGANIZATION";
		string defaultReportForm = "ORGANIZATION.rpt";
		string strDefaultXSDFileName = "ORGANIZATION.XSD";
		string strDefaultXMLFileName = "ORGANIZATION.XML";
		string strDefaultXMLXSDFileName = "ORGANIZATIONALL.XML";
		protected string ConnectStr;

		protected DataSet ds = new DataSet();
		//***********************************************************//
		
		protected System.Web.UI.WebControls.Button Button1;


	
		protected void Page_Load(object sender, System.EventArgs e)
		{
			Session.LCID = 1033;

			if(!IsPostBack)
			{
				ViewState["Count"]= 1;
				if(Request.UrlReferrer == null)
				{
					Response.Redirect(ParentPage);
				}
				else
				{
					string refer = Request.UrlReferrer.ToString();
					string ServerPath = Request.Url.ToString();
					ServerPath = ServerPath.Substring(0, ServerPath.LastIndexOf("/"));
					if(refer.IndexOf(ServerPath) == -1)
						Response.Redirect(ParentPage);
				}

				PerformSearch();
				PerformDataBind();
			}
			else
			{
				ViewState["Count"] = (int)ViewState["Count"] + 1;
			}
		}

		private void PerformSearch()
		{
			string strSelectionHeader = Session[sHeaderName].ToString();
			string[] str = new string[9];

//			str[0] = Session["Accounting_sPeriod"].ToString();
//			str[1] = Session["Accounting_sBranchName"] .ToString();
//			str[2] = Session["Accounting_sBranch_elt_account_number"] .ToString();
//			str[3] = Session["Accounting_sCompanName"] .ToString();
//			str[4] = Session["Accounting_sReportTitle"] .ToString();
//			str[5] = Session["Accounting_sSelectionParam"] .ToString();
//			str[6] = Session["str6"].ToString();
//			str[7] = Session["str7"].ToString();
//			str[8] = Session["str8"].ToString();

			for(int i=0;i<str.Length-1;i++)
			{
				if(str[i+1] !="") str[i] = str[i] + "/";
			}

//			Response.Write(string.Format("<FONT color='navy' size='1pt'>{0} {1} {2} {3} {4} {5} {6} {7} {8}</FONT>",str[0],str[1],str[2],str[3],str[4],str[5],str[6],str[7],str[8]));

			if(strSelectionHeader == "") Response.Redirect(ParentPage);

			// Gathering the Data			
			ConnectStr = (new igFunctions.DB().getConStr());
			SqlConnection Con = new SqlConnection(ConnectStr);
			SqlCommand cmdHeader = new SqlCommand(strSelectionHeader,Con);
			SqlDataAdapter Adap = new SqlDataAdapter();

			Con.Open();
			
			Adap.SelectCommand = cmdHeader;
			Adap.Fill(ds, ParentTable);

			#region For where in
			///////////////////////////////////////////////////////
			//
			//			string tmpStr = "";
			//
			//			foreach(DataRow eRow in ds.Tables[ParentTable].Rows)
			//			{
			//				tmpStr += "'" + eRow["HAWB"].ToString() + "',";
			//			}
			//
			//			tmpStr = tmpStr.Substring(0,(tmpStr.Length-1));
			//
			//			SqlCommand cmdDetail = new SqlCommand(strSelectionDetail + " and a.HAWB_NUM in (" + tmpStr + ") order by a.HAWB_NUM",Con);
			//			Adap.SelectCommand = cmdDetail;
			///////////////////////////////////////////////////////
			#endregion

			Con.Close();	

		}

		private void PerformDataBind()
		{		

			performDetailDataRefine();

			UltraWebGrid1.DataSource=ds.Tables[ParentTable].DefaultView;	
			UltraWebGrid1.DataBind();

			if(UltraWebGrid1.Rows.Count<1)
			{
				UltraWebGrid1.Visible = false;
				lblNoData.Text = "No Data was found!";
				lblNoData.Visible = true;

			}
			else
			{
				lblNoData.Visible = false;
			}
			
			foreach(UltraGridColumn aColumn in this.UltraWebGrid1.Columns)
			{
				if(aColumn.DataType == "System.DateTime")
				{
					aColumn.Format = "MM/dd/yyyy";
				}
			}

		}

		private void performDetailDataRefine()
		{

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
			this.UltraWebGrid1.InitializeRow += new Infragistics.WebUI.UltraWebGrid.InitializeRowEventHandler(this.UltraWebGrid1_InitializeRow);

		}
		#endregion

		protected void CheckBox1_CheckedChanged(object sender, System.EventArgs e)
		{
			if(this.CheckBox1.Checked)
			{
				PerformGroupby();
			}
			else
			{
				PerformFlat();
			}		
			PerformSearch();
			PerformDataBind();
		}

		private void PerformFlat()
		{
				UltraWebGrid1.DisplayLayout.HeaderClickActionDefault = HeaderClickAction.Select;
				UltraWebGrid1.DisplayLayout.ViewType = ViewType.Hierarchical;				
				UltraWebGrid1.DisplayLayout.AllowSortingDefault = Infragistics.WebUI.UltraWebGrid.AllowSorting.No;
				UltraWebGrid1.DisplayLayout.AllowColumnMovingDefault = Infragistics.WebUI.UltraWebGrid.AllowColumnMoving.None;

				this.UltraWebToolbar1.Items.FromKeyButton("Asce").Visible = true;
				this.UltraWebToolbar1.Items.FromKeyButton("Desc").Visible = true;
				this.UltraWebToolbar1.Items.FromKeyButton("Hide").Visible = true;

				butHideCol.Enabled = true;
				btnSortAsce.Enabled = true;
				this.btnSortDesc.Enabled =true;
			
		}
		private void PerformGroupby()
		{
				UltraWebGrid1.DisplayLayout.HeaderClickActionDefault = HeaderClickAction.SortMulti;

				UltraWebGrid1.DisplayLayout.ViewType = Infragistics.WebUI.UltraWebGrid.ViewType.OutlookGroupBy;
				UltraWebGrid1.DisplayLayout.GroupByBox.BandLabelStyle.BackColor = Color.White;

				UltraWebGrid1.DisplayLayout.AllowSortingDefault = Infragistics.WebUI.UltraWebGrid.AllowSorting.Yes;
//				UltraWebGrid1.DisplayLayout.AllowSortingDefault = Infragistics.WebUI.UltraWebGrid.AllowSorting.OnClient;

				UltraWebGrid1.DisplayLayout.GroupByBox.ShowBandLabels = Infragistics.WebUI.UltraWebGrid.ShowBandLabels.IntermediateBandsOnly;
				UltraWebGrid1.DisplayLayout.GroupByBox.Style.BackColor = Color.LightYellow;
				UltraWebGrid1.DisplayLayout.GroupByBox.ButtonConnectorColor=Color.Gray;
				UltraWebGrid1.DisplayLayout.GroupByBox.ButtonConnectorStyle=System.Web.UI.WebControls.BorderStyle.Dotted;


				this.UltraWebToolbar1.Items.FromKeyButton("Asce").Visible = false;
				this.UltraWebToolbar1.Items.FromKeyButton("Desc").Visible = false;
				this.UltraWebToolbar1.Items.FromKeyButton("Hide").Visible = false;

				butHideCol.Enabled = false;					
				btnSortAsce.Enabled = false;
				this.btnSortDesc.Enabled =false;

		}

		protected void btnExcel_Click(object sender, System.EventArgs e)
		{
			this.UltraWebGridExcelExporter1.DownloadName = "CompanyList.xls";
			this.UltraWebGridExcelExporter1.Export(this.UltraWebGrid1);

		}

		protected void btnXML_Click(object sender, System.EventArgs e)
		{
			
			string tmpLogDir = Request.Cookies["CurrentUserInfo"]["temp_path"];
			string c_strFilePathXSD = tmpLogDir+"/"+Session.SessionID.ToString()+DateTime.Now.Ticks.ToString()+ strDefaultXSDFileName;
			string c_strFilePathXML = tmpLogDir+"/"+Session.SessionID.ToString()+DateTime.Now.Ticks.ToString()+ strDefaultXMLFileName;
			string c_strFilePathXSDXML = tmpLogDir+"/"+Session.SessionID.ToString()+DateTime.Now.Ticks.ToString()+ strDefaultXMLXSDFileName;

			DataSet c_fileDataSet = PerformGetNewdataSet();

			PerformWriteOnlyXML(c_fileDataSet, c_strFilePathXSDXML);
			PerformWriteXML_XSD(c_fileDataSet, c_strFilePathXSD,c_strFilePathXML);
			
/// DownLoad XML

			string tmpStr = "../Common/MenuDownLoadXML.aspx?";
			tmpStr+= "c_strFilePathXSD=" + c_strFilePathXSD+ "&c_strFilePathXML=" + c_strFilePathXML+ "&c_strFilePathXSDXML=" + c_strFilePathXSDXML;

			string script="<script language= javascript>";
			script+=      "showModalDialog('"+ tmpStr +"' ,window,'dialogWidth:300px; dialogHeight:200px; center:yes;center=yes; screenTop=yes; scroll=no; status=no; help=no;');";
			script+=      "</script>";

			this.ClientScript.RegisterStartupScript(this.GetType(), "DownLoadXML", script);
		
		}

		protected void Button1_Click(object sender, System.EventArgs e)
		{
			int a = int.Parse(ViewState["Count"].ToString());
				string script = "<script language='javascript'>";

				script += "if(history.length >= " + a.ToString() + ")";
				script += "{ history.go(-" + a.ToString() + "); }";
				script += "else{location.replace('"+ParentPage+"')}";
				script += "</script>";
                this.ClientScript.RegisterClientScriptBlock(this.GetType(), "Pre", script);
            }

		protected void btnPrint_Click(object sender, System.EventArgs e)
		{
//			string strMode = "Write_Schema_XML"; // You can change if you want to write Schema and XML separately. 
			string strMode = "";

			string tmpLogDir = Request.Cookies["CurrentUserInfo"]["temp_path"];
			string c_strFilePathXSD = tmpLogDir+"/"+Session.SessionID.ToString()+DateTime.Now.Ticks.ToString()+ strDefaultXSDFileName;
			string c_strFilePathXML = tmpLogDir+"/"+Session.SessionID.ToString()+DateTime.Now.Ticks.ToString()+ strDefaultXMLFileName;
			string c_strFilePathXSDXML = tmpLogDir+"/"+Session.SessionID.ToString()+DateTime.Now.Ticks.ToString()+ strDefaultXMLXSDFileName;

			DataSet c_fileDataSet = PerformGetNewdataSet();

			if (strMode == "Write_Schema_XML")
			{
				PerformWriteOnlyXML(c_fileDataSet, c_strFilePathXSDXML);
				string tmpStr = string.Format("c_strFilePathXSDXML={0}&defaultReportForm={1}",c_strFilePathXSDXML,defaultReportForm);
				Response.Redirect("../Common/PrintReport.aspx?"+tmpStr);		
			}
			else
			{
				PerformWriteXML_XSD(c_fileDataSet, c_strFilePathXSD,c_strFilePathXML);
				string tmpStr = string.Format("c_strFilePathXSD={0}&c_strFilePathXML={1}&defaultReportForm={2}",c_strFilePathXSD,c_strFilePathXML,defaultReportForm);
				Response.Redirect("../Common/PrintReport.aspx?"+tmpStr);		
			}
		}

		private DataSet PerformGetNewdataSet()
		{
			int iCnt;

			DataSet c_fileDataSet = new DataSet(dsXMLName);

			PerformSearch();
		
			for(int iB=0;iB<this.UltraWebGrid1.Bands.Count;iB++)
			{
				DataTable table = new DataTable(ds.Tables[UltraWebGrid1.DisplayLayout.Bands[iB].Key].ToString());
						
				for(int i=0;i<this.UltraWebGrid1.DisplayLayout.Bands[iB].Columns.Count;i++)
				{
					if(UltraWebGrid1.DisplayLayout.Bands[iB].Columns[i].Hidden != true 
						|| UltraWebGrid1.DisplayLayout.Bands[iB].Columns[i].BaseColumnName.ToString() == keyColName )
					{
						table.Columns.Add(UltraWebGrid1.Bands[iB].Columns[i].BaseColumnName.ToString(),Type.GetType(UltraWebGrid1.Bands[iB].Columns[i].DataType));
					}
				}

				foreach(DataRow eRow in ds.Tables[UltraWebGrid1.DisplayLayout.Bands[iB].Key].Rows)
				{
					DataRow aRow = table.NewRow();						
					iCnt = 0;
					for(int j=0;j<this.UltraWebGrid1.DisplayLayout.Bands[iB].Columns.Count;j++)
					{
						if(UltraWebGrid1.DisplayLayout.Bands[iB].Columns[j].Hidden != true 
							|| UltraWebGrid1.DisplayLayout.Bands[iB].Columns[j].BaseColumnName.ToString() == keyColName )
						{
							aRow[iCnt] = eRow[j];
							iCnt += 1;
						}
					}			
					table.Rows.Add(aRow);		
				}
	
				c_fileDataSet.Tables.Add(table); }

			return c_fileDataSet;

		}

//		private DataSet PerformGetNewdataSet()
//		{
//			int iCnt;
//
//			DataSet c_fileDataSet = new DataSet(dsXMLName);
//
//			PerformSearch();
//		
//			for(int iB=0;iB<this.UltraWebGrid1.Bands.Count;iB++)
//			{
//				DataTable table = new DataTable(ds.Tables[UltraWebGrid1.DisplayLayout.Bands[iB].Key].ToString());
//				DataColumn[] keys = new DataColumn[1];
//				DataColumn tmpColumn;
//						
//				for(int i=0;i<this.UltraWebGrid1.DisplayLayout.Bands[iB].Columns.Count;i++)
//				{
//					if(UltraWebGrid1.DisplayLayout.Bands[iB].Columns[i].Hidden != true 
//						&& UltraWebGrid1.DisplayLayout.Bands[iB].Columns[i].BaseColumnName.ToString() != keyColName )
//					{
//						table.Columns.Add(UltraWebGrid1.Bands[iB].Columns[i].BaseColumnName.ToString(),Type.GetType(UltraWebGrid1.Bands[iB].Columns[i].DataType));
//					}
//					else if( UltraWebGrid1.DisplayLayout.Bands[iB].Columns[i].BaseColumnName.ToString() == keyColName )
//					{
//						tmpColumn = new DataColumn();
//						tmpColumn.DataType = Type.GetType(UltraWebGrid1.Bands[iB].Columns[i].DataType);
//						tmpColumn.ColumnName = UltraWebGrid1.Bands[iB].Columns[i].BaseColumnName.ToString();
//						table.Columns.Add(tmpColumn);
//						keys[0] = tmpColumn;
//					}
//
//				}
//				table.PrimaryKey = keys;
//
//				foreach(DataRow eRow in ds.Tables[UltraWebGrid1.DisplayLayout.Bands[iB].Key].Rows)
//				{
//					DataRow aRow = table.NewRow();						
//					iCnt = 0;
//					for(int j=0;j<this.UltraWebGrid1.DisplayLayout.Bands[iB].Columns.Count;j++)
//					{
//						if(UltraWebGrid1.DisplayLayout.Bands[iB].Columns[j].Hidden != true 
//							|| UltraWebGrid1.DisplayLayout.Bands[iB].Columns[j].BaseColumnName.ToString() == keyColName )
//						{
//							aRow[iCnt] = eRow[j];
//							iCnt += 1;
//						}
//					}			
//					table.Rows.Add(aRow);		
//				}
//	
//				c_fileDataSet.Tables.Add(table); }
//
//						if(c_fileDataSet.Relations.Count<1 && UltraWebGrid1.Bands.Count > 1)	
//							c_fileDataSet.Relations.Add(c_fileDataSet.Tables[ParentTable].Columns[keyColName],c_fileDataSet.Tables[ChildTable].Columns[keyColName]);
//
//			return c_fileDataSet;
//
//		}

		private void PerformWriteOnlyXML(DataSet c_fileDataSet, string c_strFilePathXSDXML)
		{
			StreamWriter XMLStreamWriter = new StreamWriter(c_strFilePathXSDXML);
			c_fileDataSet.WriteXml(XMLStreamWriter,System.Data.XmlWriteMode.WriteSchema);
			XMLStreamWriter.Flush();
			XMLStreamWriter.Close();
		}

		private void PerformWriteXML_XSD(DataSet c_fileDataSet, string c_strFilePathXSD, string c_strFilePathXML)
		{
			StreamWriter XSDStreamWriter = new StreamWriter(c_strFilePathXSD);
			c_fileDataSet.WriteXmlSchema(XSDStreamWriter);
			XSDStreamWriter.Flush();
			XSDStreamWriter.Close();

			StreamWriter XMLStreamWriter = new StreamWriter(c_strFilePathXML);
			c_fileDataSet.WriteXml(XMLStreamWriter);
			XMLStreamWriter.Flush();
			XMLStreamWriter.Close();
		}

		protected void radMulti_CheckedChanged(object sender, System.EventArgs e)
		{
			if (radMulti.Checked == true)
			{
				this.UltraWebGrid1.DisplayLayout.Pager.AllowPaging = true;
				this.UltraWebGrid1.DisplayLayout.Pager.Alignment=Infragistics.WebUI.UltraWebGrid.PagerAlignment.Center;
				this.UltraWebGrid1.DisplayLayout.Pager.PagerAppearance=Infragistics.WebUI.UltraWebGrid.PagerAppearance.Top;
				this.UltraWebGrid1.DisplayLayout.Pager.StyleMode=Infragistics.WebUI.UltraWebGrid.PagerStyleMode.Numeric;

				this.UltraWebGrid1.DisplayLayout.Pager.PageSize= 30;
				CheckBox1.Enabled = false;
				PerformFlat();	
				PerformSearch();
				PerformDataBind();
			}
		}

		protected void radSingle_CheckedChanged(object sender, System.EventArgs e)
		{
			if (radSingle.Checked)
			{
				this.UltraWebGrid1.DisplayLayout.Pager.AllowPaging = false;
				CheckBox1.Enabled = true;
				PerformSearch();
				PerformDataBind();
			}
		}

		protected void butHideCol_Click(object sender, System.EventArgs e)
		{
			
			for(int iB=0;iB<this.UltraWebGrid1.Bands.Count;iB++)
			{
				for(int i=0;i<UltraWebGrid1.Bands[iB].Columns.Count;i++)
				{
					if(UltraWebGrid1.Bands[iB].Columns[i].Selected)
					{
						UltraWebGrid1.Bands[iB].Columns[i].Hidden=true;
						UltraWebGrid1.Bands[iB].Columns[i].Selected=false;
					}
				}
			}

		}

		protected void btnSortAsce_Click(object sender, System.EventArgs e)
		{
			for(int iB=0;iB<this.UltraWebGrid1.DisplayLayout.Bands.Count;iB++)
			{
				UltraGridBand band = this.UltraWebGrid1.DisplayLayout.Bands[iB]; 

				if(UltraWebGrid1.DisplayLayout.SelectedColumns.Count>0 || band.SortedColumns.Count>0)
				{
					for(int i=0;i<band.Columns.Count;i++)
					{
						if(band.Columns[i].Selected)
						{
							band.Columns[i].SortIndicator = SortIndicator.Ascending; 
							band.SortedColumns.Add(UltraWebGrid1.Bands[iB].Columns[i]);
						}
					}
				}
			}
			PerformSearch();
			this.PerformDataBind();
		}

		protected void btnSortDesc_Click(object sender, System.EventArgs e)
		{
			for(int iB=0;iB<this.UltraWebGrid1.DisplayLayout.Bands.Count;iB++)
			{
				UltraGridBand band = this.UltraWebGrid1.DisplayLayout.Bands[iB]; 

				if(UltraWebGrid1.DisplayLayout.SelectedColumns.Count>0 || band.SortedColumns.Count>0)
				{
					for(int i=0;i<band.Columns.Count;i++)
					{
						if(band.Columns[i].Selected)
						{
							band.Columns[i].SortIndicator = SortIndicator.Descending;
							band.SortedColumns.Add(UltraWebGrid1.Bands[iB].Columns[i]);
						}
					}
				}
			}
			PerformSearch();
			this.PerformDataBind();
		}

		protected void btnReset_Click(object sender, System.EventArgs e)
		{
			UltraWebGrid1.ResetColumns();
			UltraWebGrid1.ResetBands();
			PerformSearch();
			PerformDataBind();

			if(this.CheckBox1.Checked)
			{
				PerformGroupby();
			}
			else
			{
				PerformFlat();
			}		
			

		}

        protected void UltraWebGrid1_InitializeLayout1(object sender, LayoutEventArgs e)
        {
            UltraWebGrid1.DisplayLayout.SelectTypeColDefault = SelectType.Extended;
            UltraWebGrid1.DisplayLayout.SelectTypeRowDefault = SelectType.Extended;

            UltraWebGrid1.DisplayLayout.ViewType = ViewType.Hierarchical;
            UltraWebGrid1.DisplayLayout.TableLayout = TableLayout.Fixed;
            UltraWebGrid1.DisplayLayout.RowStyleDefault.BorderDetails.ColorTop = Color.WhiteSmoke;

            if (CheckBox1.Checked && radSingle.Checked) PerformGroupby();


            for (int i = 0; i < UltraWebGrid1.Bands.Count; i++)
            {
                for (int j = 0; j < UltraWebGrid1.Bands[i].Columns.Count; j++)
                {
                    UltraWebGrid1.DisplayLayout.Bands[i].Columns[j].SelectedCellStyle.BackColor = Color.FromArgb(73, 30, 138);
                    UltraWebGrid1.DisplayLayout.Bands[i].Columns[j].SelectedCellStyle.ForeColor = Color.WhiteSmoke;
                }
            }

            UltraWebGrid1.Bands[0].RowStyle.BackColor = Color.White;

            UltraWebGrid1.DisplayLayout.SelectedHeaderStyleDefault.BackColor = Color.Red;
            UltraWebGrid1.DisplayLayout.SelectTypeCellDefault = Infragistics.WebUI.UltraWebGrid.SelectType.Single;
            UltraWebGrid1.DisplayLayout.AllowColSizingDefault = Infragistics.WebUI.UltraWebGrid.AllowSizing.Free;

            //set cursor 
            UltraWebGrid1.DisplayLayout.FrameStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Default;
            UltraWebGrid1.DisplayLayout.Bands[0].HeaderStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Default;

            UltraWebGrid1.DisplayLayout.SelectedHeaderStyleDefault.BackColor = Color.Red;

            UltraWebGrid1.Bands[0].DataKeyField = ds.Tables[ParentTable].Columns[keyColName].ColumnName;

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
        protected void UltraWebGrid1_InitializeRow(object sender, RowEventArgs e)
        {
            string s;
            s = "javascript:; void(viewPopPF('" + "CompanyConfigCreate.aspx?WindowName=PopWin&number=" + (e.Row.Cells.FromKey("org_account_number").Value.ToString()) + "'))";
            e.Row.Cells.FromKey("dba_name").TargetURL = s;
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
        protected void UltraWebGrid1_PageIndexChanged(object sender, Infragistics.WebUI.UltraWebGrid.PageEventArgs e)
        {
            UltraWebGrid1.DisplayLayout.Pager.CurrentPageIndex = e.NewPageIndex;
            PerformSearch();
            PerformDataBind();
		

        }
}
}
