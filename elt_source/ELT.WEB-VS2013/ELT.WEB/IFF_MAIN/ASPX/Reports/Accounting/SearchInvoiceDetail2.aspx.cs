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

namespace IFF_MAIN.ASPX.Reports.Accounting
{
	/// <summary>
	/// AccountingDetail에 대한 요약 설명입니다.
	/// </summary>
	public partial class SearchInvoiceDetail2 : System.Web.UI.Page
	{
		protected System.Web.UI.WebControls.Button butShowCols;

//***********************************************************//
		string ParentTable="INVOICE";
		string ChildTable="INVOICE_DETAIL";
		string keyColName="invoice_no";
		string dsXMLName ="INVOICE";
		string sHeaderName = "SEARCHINVOICE";
		string defaultReportForm = "INVOICE.rpt";
		string strDefaultXSDFileName = "INVOICE.XSD";
		string strDefaultXMLFileName = "INVOICE.XML";
		string strDefaultXMLXSDFileName = "INVOICEALL.XML";
		string ParentPage = "SearchInvoiceSelection.aspx";
        protected string ConnectStr;
		protected DataSet ds = new DataSet();
        static public string windowName;	

		protected void Page_Load(object sender, System.EventArgs e)
		{
			Session.LCID = 1033;
            windowName = Request.QueryString["WindowName"];	

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

			str[0] = Session["Accounting_sPeriod"].ToString();
			str[1] = Session["Accounting_sBranchName"] .ToString();
			str[2] = Session["Accounting_sBranch_elt_account_number"] .ToString();
			str[3] = Session["Accounting_sCompanName"] .ToString();
			str[4] = Session["Accounting_sReportTitle"] .ToString();
			str[5] = Session["Accounting_sSelectionParam"] .ToString();
			str[6] = Session["str6"].ToString();
            str[7] = Session["str7"].ToString();
            str[8] = Session["str8"].ToString();

			for(int i=0;i<str.Length-1;i++)
			{
				if(str[i+1] !="") str[i] = str[i] + "/";
			}

            Label2.Text = string.Format("<FONT color='navy' size='1pt'>{0} {1} {2} {3} {4} {5}  {6} {7} {8}</FONT>", str[0], str[1], str[2], str[3], str[4], str[5], str[6], str[7], str[8]);

			if(strSelectionHeader == "" ) Response.Redirect(ParentPage);

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
            //string tmpStr = "";

            //foreach (DataRow eRow in ds.Tables[ParentTable].Rows)
            //{
            //    tmpStr += "'" + eRow["invoice_no"].ToString() + "',";
            //}

            //tmpStr = tmpStr.Substring(0, (tmpStr.Length - 1));

            //SqlCommand cmdDetail = new SqlCommand(strSelectionDetail + " and a.HAWB_NUM in (" + tmpStr + ") order by a.HAWB_NUM", Con);
            //Adap.SelectCommand = cmdDetail;
			///////////////////////////////////////////////////////
			#endregion

		
			Con.Close();	

		}

		private void PerformDataBind()
		{		

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
		}
		#endregion

		private void PerformFlat()
		{
				UltraWebGrid1.DisplayLayout.HeaderClickActionDefault = HeaderClickAction.Select;
				UltraWebGrid1.DisplayLayout.ViewType = ViewType.Hierarchical;				
				UltraWebGrid1.DisplayLayout.AllowSortingDefault = Infragistics.WebUI.UltraWebGrid.AllowSorting.No;
				UltraWebGrid1.DisplayLayout.AllowColumnMovingDefault = Infragistics.WebUI.UltraWebGrid.AllowColumnMoving.None;

                //this.UltraWebToolbar1.Items.FromKeyButton("Asce").Visible = true;
                //this.UltraWebToolbar1.Items.FromKeyButton("Desc").Visible = true;
                //this.UltraWebToolbar1.Items.FromKeyButton("Hide").Visible = true;

				butHideCol.Enabled = true;
				btnSortAsce.Enabled = true;
				this.btnSortDesc.Enabled =true;
			
		}
		private void PerformGroupby()
		{

				UltraWebGrid1.DisplayLayout.HeaderClickActionDefault = HeaderClickAction.SortMulti;

				UltraWebGrid1.DisplayLayout.CellClickActionDefault = CellClickAction.CellSelect;
				UltraWebGrid1.DisplayLayout.ViewType = Infragistics.WebUI.UltraWebGrid.ViewType.OutlookGroupBy;
				UltraWebGrid1.DisplayLayout.GroupByBox.BandLabelStyle.BackColor = Color.White;

				UltraWebGrid1.DisplayLayout.AllowSortingDefault = Infragistics.WebUI.UltraWebGrid.AllowSorting.Yes;

//				UltraWebGrid1.DisplayLayout.AllowColumnMovingDefault = Infragistics.WebUI.UltraWebGrid.AllowColumnMoving.None;
//				UltraWebGrid1.DisplayLayout.AllowColumnMovingDefault = Infragistics.WebUI.UltraWebGrid.AllowColumnMoving.OnServer;
//				UltraWebGrid1.DisplayLayout.FooterStyleDefault.Height = new Unit(40);
//				UltraWebGrid1.DisplayLayout.GroupByRowStyleDefault.Height = new Unit(22);

				UltraWebGrid1.DisplayLayout.GroupByBox.ShowBandLabels = Infragistics.WebUI.UltraWebGrid.ShowBandLabels.IntermediateBandsOnly;
				UltraWebGrid1.DisplayLayout.GroupByBox.Style.BackColor = Color.LightYellow;
				UltraWebGrid1.DisplayLayout.GroupByBox.ButtonConnectorColor=Color.Gray;
				UltraWebGrid1.DisplayLayout.GroupByBox.ButtonConnectorStyle=System.Web.UI.WebControls.BorderStyle.Dotted;

                //this.UltraWebToolbar1.Items.FromKeyButton("Asce").Visible = false;
                //this.UltraWebToolbar1.Items.FromKeyButton("Desc").Visible = false;
                //this.UltraWebToolbar1.Items.FromKeyButton("Hide").Visible = false;

				butHideCol.Enabled = false;					
				btnSortAsce.Enabled = false;
				this.btnSortDesc.Enabled =false;

		}

		protected void btnExcel_Click(object sender, System.EventArgs e)
		{
			this.UltraWebGridExcelExporter1.DownloadName = "InvoiceList.xls";
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

			this.ClientScript.RegisterStartupScript(this.GetType(), "DownLoadXM", script);
		
		}

		private void Button1_Click(object sender, System.EventArgs e)
		{
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

						if(c_fileDataSet.Relations.Count<1 && UltraWebGrid1.Bands.Count > 1)	
							c_fileDataSet.Relations.Add(c_fileDataSet.Tables[ParentTable].Columns[keyColName],c_fileDataSet.Tables[ChildTable].Columns[keyColName]);

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
				band.SortedColumns.Clear(); // 2005.8.4

				if(UltraWebGrid1.DisplayLayout.SelectedColumns.Count>0 || band.SortedColumns.Count>0)
				{

					for(int i=0;i<band.Columns.Count;i++)
					{
						if(band.Columns[i].Selected)
						{
							band.Columns[i].SortIndicator = SortIndicator.Ascending; 
							band.SortedColumns.Add(UltraWebGrid1.Bands[iB].Columns[i]);
							break; // 2005.8.4
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
				band.SortedColumns.Clear(); // 2005.8.4

				if(UltraWebGrid1.DisplayLayout.SelectedColumns.Count>0 || band.SortedColumns.Count>0)
				{
					for(int i=0;i<band.Columns.Count;i++)
					{
						if(band.Columns[i].Selected)
						{
							band.Columns[i].SortIndicator = SortIndicator.Descending;
							band.SortedColumns.Add(UltraWebGrid1.Bands[iB].Columns[i]);
							break; // 2005.8.4
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

		}

		protected void btnBack_Click(object sender, System.EventArgs e)
		{
			int a = int.Parse(ViewState["Count"].ToString());
			string script = "<script language='javascript'>";

			script += "if(history.length >= " + a.ToString() + ")";
			script += "{ history.go(-" + a.ToString() + "); }";
			script += "else{location.replace('SearchInvoiceSelection.aspx')}";
			script += "</script>";
			this.ClientScript.RegisterStartupScript(this.GetType(), "Pre", script);  					
		}

        protected void UltraWebGrid1_InitializeLayout1(object sender, LayoutEventArgs e)
        {
            e.Layout.SelectTypeColDefault = SelectType.Single;
            e.Layout.SelectTypeRowDefault = SelectType.Extended;

            e.Layout.ViewType = ViewType.Flat;
            e.Layout.TableLayout = TableLayout.Fixed;
            e.Layout.RowStyleDefault.BorderDetails.ColorTop = Color.Gray;

            for (int i = 0; i < UltraWebGrid1.Bands.Count; i++)
            {
                for (int j = 0; j < UltraWebGrid1.Bands[i].Columns.Count; j++)
                {
                    UltraWebGrid1.DisplayLayout.Bands[i].Columns[j].SelectedCellStyle.BackColor = Color.FromArgb(73, 30, 138);
                    UltraWebGrid1.DisplayLayout.Bands[i].Columns[j].SelectedCellStyle.ForeColor = Color.WhiteSmoke;
                }
            }


            PerformFlat();

            e.Layout.Bands[0].Columns.FromKey("Customer_Number").ServerOnly = true;
            e.Layout.Bands[0].Columns.FromKey("Origin_Dest").ServerOnly = true;
            e.Layout.Bands[0].Columns.FromKey("Origin").ServerOnly = true;
            e.Layout.Bands[0].Columns.FromKey("Destination").ServerOnly = true;
            e.Layout.Bands[0].Columns.FromKey("Shipper").ServerOnly = true;
            e.Layout.Bands[0].Columns.FromKey("Consignee").ServerOnly = true;
            e.Layout.Bands[0].Columns.FromKey("Carrier").ServerOnly = true;
            e.Layout.Bands[0].Columns.FromKey("Description").ServerOnly = true;

            UltraWebGrid1.Bands[0].RowStyle.BackColor = Color.WhiteSmoke;


            UltraWebGrid1.DisplayLayout.SelectedHeaderStyleDefault.BackColor = Color.Red;
            UltraWebGrid1.DisplayLayout.SelectTypeCellDefault = Infragistics.WebUI.UltraWebGrid.SelectType.Single;
            UltraWebGrid1.DisplayLayout.AllowColSizingDefault = Infragistics.WebUI.UltraWebGrid.AllowSizing.Free;

            //set cursor 
            UltraWebGrid1.DisplayLayout.FrameStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Default;
            UltraWebGrid1.DisplayLayout.Bands[0].HeaderStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Default;

            UltraWebGrid1.DisplayLayout.SelectedHeaderStyleDefault.BackColor = Color.Red;

            e.Layout.Bands[0].Columns.FromKey("Total_Gross_Weight").CellStyle.BackColor = Color.LightYellow;
            e.Layout.Bands[0].Columns.FromKey("total_cost").CellStyle.BackColor = Color.LightYellow;
            e.Layout.Bands[0].Columns.FromKey("amount_charged").CellStyle.BackColor = Color.LightYellow;
            e.Layout.Bands[0].Columns.FromKey("agent_profit").CellStyle.BackColor = Color.LightYellow;
            e.Layout.Bands[0].Columns.FromKey("sale_tax").CellStyle.BackColor = Color.LightYellow;
            e.Layout.Bands[0].Columns.FromKey("subtotal").CellStyle.BackColor = Color.LightYellow;
            e.Layout.Bands[0].Columns.FromKey("amount_paid").CellStyle.BackColor = Color.LightYellow;
            e.Layout.Bands[0].Columns.FromKey("balance").CellStyle.BackColor = Color.LightYellow;
            e.Layout.Bands[0].Columns.FromKey("pay_status").CellStyle.BackColor = Color.LightYellow;
            e.Layout.Bands[0].Columns.FromKey("subtotal").CellStyle.BackColor = Color.LightGoldenrodYellow;


            e.Layout.Bands[0].Columns.FromKey("invoice_no").Width = new Unit("50px");
            e.Layout.Bands[0].Columns.FromKey("Customer").Width = new Unit("120px");
            e.Layout.Bands[0].Columns.FromKey("mawb_num").Width = new Unit("100px");
            e.Layout.Bands[0].Columns.FromKey("hawb_num").Width = new Unit("100px");
            e.Layout.Bands[0].Columns.FromKey("invoice_date").Width = new Unit("70px");
            e.Layout.Bands[0].Columns.FromKey("invoice_type").Width = new Unit("20px");
            e.Layout.Bands[0].Columns.FromKey("import_export").Width = new Unit("20px");
            e.Layout.Bands[0].Columns.FromKey("air_ocean").Width = new Unit("20px");
            e.Layout.Bands[0].Columns.FromKey("Ref_No").Width = new Unit("70px");
            e.Layout.Bands[0].Columns.FromKey("Total_Pieces").Width = new Unit("60px");
            e.Layout.Bands[0].Columns.FromKey("subtotal").Width = new Unit("60px");
            e.Layout.Bands[0].Columns.FromKey("sale_tax").Width = new Unit("60px");
            e.Layout.Bands[0].Columns.FromKey("agent_profit").Width = new Unit("60px");
            e.Layout.Bands[0].Columns.FromKey("amount_charged").Width = new Unit("60px");
            e.Layout.Bands[0].Columns.FromKey("amount_paid").Width = new Unit("60px");
            e.Layout.Bands[0].Columns.FromKey("balance").Width = new Unit("60px");
            e.Layout.Bands[0].Columns.FromKey("total_cost").Width = new Unit("60px");
            e.Layout.Bands[0].Columns.FromKey("pay_status").Width = new Unit("20px");
            e.Layout.Bands[0].Columns.FromKey("Total_Gross_Weight").Width = new Unit("60px");


            e.Layout.Bands[0].Columns.FromKey("invoice_no").Header.Caption = "I/V No.";
            e.Layout.Bands[0].Columns.FromKey("hawb_num").Header.Caption = "HAWB(HBOL)";
            e.Layout.Bands[0].Columns.FromKey("mawb_num").Header.Caption = "MAWB(MBOL)";
            e.Layout.Bands[0].Columns.FromKey("invoice_date").Header.Caption = "I/V Date";
            e.Layout.Bands[0].Columns.FromKey("Total_Pieces").Header.Caption = "PCS";
            e.Layout.Bands[0].Columns.FromKey("invoice_type").Header.Caption = "T";
            e.Layout.Bands[0].Columns.FromKey("import_export").Header.Caption = "I/E";
            e.Layout.Bands[0].Columns.FromKey("air_ocean").Header.Caption = "A/O";

            e.Layout.Bands[0].Columns.FromKey("Total_Gross_Weight").Header.Caption = "G.Weight";
            e.Layout.Bands[0].Columns.FromKey("total_cost").Header.Caption = "Cost";
            e.Layout.Bands[0].Columns.FromKey("amount_charged").Header.Caption = "Charge";
            e.Layout.Bands[0].Columns.FromKey("agent_profit").Header.Caption = "Agt.P/F";
            e.Layout.Bands[0].Columns.FromKey("sale_tax").Header.Caption = "Tax.";
            e.Layout.Bands[0].Columns.FromKey("subtotal").Header.Caption = "Sub Total.";
            //			e.Layout.Bands[0].Columns.FromKey("accounts_receivable").Header.Caption="A/R";
            e.Layout.Bands[0].Columns.FromKey("amount_paid").Header.Caption = "A/P";
            e.Layout.Bands[0].Columns.FromKey("balance").Header.Caption = "Balance";
            e.Layout.Bands[0].Columns.FromKey("pay_status").Header.Caption = "P";
            e.Layout.Bands[0].Columns.FromKey("Origin_Dest").Header.Caption = "Origin/Destination";
            e.Layout.Bands[0].Columns.FromKey("Arrival_Dept").Header.Caption = "Arrival/Departure";

            e.Layout.Bands[0].Columns.FromKey("Total_Pieces").CellStyle.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[0].Columns.FromKey("total_cost").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[0].Columns.FromKey("total_cost").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[0].Columns.FromKey("total_cost").FooterTotal = SummaryInfo.Sum;
            e.Layout.Bands[0].Columns.FromKey("total_cost").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[0].Columns.FromKey("amount_charged").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[0].Columns.FromKey("amount_charged").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[0].Columns.FromKey("amount_charged").FooterTotal = SummaryInfo.Sum;
            e.Layout.Bands[0].Columns.FromKey("amount_charged").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[0].Columns.FromKey("agent_profit").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[0].Columns.FromKey("agent_profit").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[0].Columns.FromKey("agent_profit").FooterTotal = SummaryInfo.Sum;
            e.Layout.Bands[0].Columns.FromKey("agent_profit").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[0].Columns.FromKey("sale_tax").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[0].Columns.FromKey("sale_tax").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[0].Columns.FromKey("sale_tax").FooterTotal = SummaryInfo.Sum;
            e.Layout.Bands[0].Columns.FromKey("sale_tax").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[0].Columns.FromKey("subtotal").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[0].Columns.FromKey("subtotal").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[0].Columns.FromKey("subtotal").FooterTotal = SummaryInfo.Sum;
            e.Layout.Bands[0].Columns.FromKey("subtotal").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[0].Columns.FromKey("amount_paid").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[0].Columns.FromKey("amount_paid").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[0].Columns.FromKey("amount_paid").FooterTotal = SummaryInfo.Sum;
            e.Layout.Bands[0].Columns.FromKey("amount_paid").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[0].Columns.FromKey("balance").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[0].Columns.FromKey("balance").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[0].Columns.FromKey("balance").FooterTotal = SummaryInfo.Sum;
            e.Layout.Bands[0].Columns.FromKey("balance").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[0].HeaderStyle.HorizontalAlign = HorizontalAlign.Center;

        }
        protected void UltraWebGrid1_InitializeRow1(object sender, RowEventArgs e)
        {
            string[] strOrigin_dest = null;

            if (e.Row.Band.BaseTableName == ChildTable)
            {

            }
            else
            {
                if (e.Row.Cells.FromKey("import_export").Text == "E")
                {
                    e.Row.Cells.FromKey("import_export").Style.BackColor = Color.AliceBlue;
                }
                if (e.Row.Cells.FromKey("import_export").Text == "I")
                {
                    e.Row.Cells.FromKey("import_export").Style.BackColor = Color.LightYellow;
                }
                if (e.Row.Cells.FromKey("pay_status").Text == "P")
                {
                    e.Row.Cells.FromKey("import_export").Style.BackColor = Color.LightYellow;
                }

                if (e.Row.Cells.FromKey("Origin_Dest").Text != null)
                {
                    strOrigin_dest = e.Row.Cells.FromKey("Origin_Dest").Text.Split('/');

                    if (e.Row.Cells.FromKey("Origin").Text == null && strOrigin_dest.Length > 0)
                    {
                        e.Row.Cells.FromKey("Origin").Text = (strOrigin_dest[0] != null ? strOrigin_dest[0] : "");
                    }
                    if (e.Row.Cells.FromKey("Destination").Text == null && strOrigin_dest.Length > 1)
                    {
                        e.Row.Cells.FromKey("Destination").Text = (strOrigin_dest[1] != null ? strOrigin_dest[1] : "");
                    }
                }

            }
            string s = "";


            if (e.Row.Band.BaseTableName == ParentTable)
            {
               
                s = "javascript:; " + "void(viewPop('/ASP/acct_tasks/edit_invoice.asp?edit=yes&InvoiceNo=";

                e.Row.Cells.FromKey("invoice_no").TargetURL = s + e.Row.Cells.FromKey("invoice_no").Value.ToString() + "'))";
            }


        }
        protected void UltraWebGrid1_PageIndexChanged1(object sender, Infragistics.WebUI.UltraWebGrid.PageEventArgs e)
        {
            UltraWebGrid1.DisplayLayout.Pager.CurrentPageIndex = e.NewPageIndex;
            PerformSearch();
            PerformDataBind();
        }
        protected void btnExcelExport_Click(object sender, ImageClickEventArgs e)
        {
            this.UltraWebGridExcelExporter1.DownloadName = "InvoiceList.xls";
            this.UltraWebGridExcelExporter1.Export(this.UltraWebGrid1);
        }
}
}
























