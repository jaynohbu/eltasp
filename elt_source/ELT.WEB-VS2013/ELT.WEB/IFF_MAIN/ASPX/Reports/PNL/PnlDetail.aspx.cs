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
using System.IO;
using System.Configuration;
using Infragistics.WebUI.UltraWebGrid;
using CrystalDecisions.Shared;

namespace IFF_MAIN.ASPX.Reports.PNL
{
	/// <summary>
	/// AccountingDetail에 대한 요약 설명입니다.
	/// </summary>
	public partial class PnlDetail : System.Web.UI.Page
	{
		protected System.Web.UI.WebControls.Button butShowCols;

//***********************************************************//
		string ParentTable="INVOICE";
		string dsXMLName ="INVOICE";
		string sHeaderName = "PNLINDEX";
		string defaultReportForm = "INVOICE.rpt";
		string strDefaultXSDFileName = "INVOICE.XSD";
		string strDefaultXMLFileName = "INVOICE.XML";
		string strDefaultXMLXSDFileName = "INVOICEALL.XML";
		string ParentPage = "PnlIndex.aspx";
        protected string ConnectStr;
		protected DataSet ds = new DataSet();
        static public string windowName;
        static public string strResultStyle;
        static string keyColName;

		protected void Page_Load(object sender, System.EventArgs e)
		{
			Session.LCID = 1033;
            windowName = Request.QueryString["WindowName"];

            if (Session["Accounting_sPeriod"] == null)
            {
                Response.Redirect(ParentPage);
            }

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
					if(refer.IndexOf(ServerPath) == -1) Response.Redirect(ParentPage);
				}
                strResultStyle = Request.QueryString["rs"].ToString().ToLower();
                PerformSearch();
			}
			else
			{
                //rsm.CloseReportDocumnet();
				ViewState["Count"] = (int)ViewState["Count"] + 1;
			}
            
        }

        /**************************************************************************************************************  
         *  Added on September 13, 2006 By Joon
         * 
         *  ReportSourceManager class in App_code has a static ReportDocument variable.
         *  This allows outside classes to look up thier values contained in the dataset - company info., image, and data.
         *  WriteXDS creates a xsd file in given location (folder needs to be declaired to be writable for all users
         *  BindNow puts DataSet value to ReportDocument so that it can be available while exporting
         * 
         **************************************************************************************************************/
        protected ReportSourceManager rsm = null;

        private void LoadReport()
        {
            rsm = new ReportSourceManager();
            DataColumn col = null;
            string[] str = new string[10];

            str[0] = Session["Accounting_sPeriod"].ToString();
            str[1] = Request.Cookies["CurrentUserInfo"]["login_name"];
            str[2] = Session["PNLkey"].ToString();
            string rsType = Request.QueryString["rs"];
                    
            string elt_num = Request.Cookies["CurrentUserInfo"]["elt_account_number"];

            try
            {
                rsm.LoadDataSet(ds);
                rsm.LoadCompanyInfo(elt_num, Server.MapPath("../../../ClientLogos/" + elt_num + ".jpg"));
                rsm.LoadOtherInfo(str);
                rsm.WriteXSD(Server.MapPath("../../../CrystalReportResources/xsd/pnl.xsd"));

                rsm.TableRename("Invoice", "cTmp");

                if (!rsm.BindNow(Server.MapPath("../../../CrystalReportResources/rpt/pnl_" + rsType + ".rpt")))
                {
                        Response.Write("failed to bind");
                        Response.End();
                }

            }
            catch (Exception e)
            {
                Response.Write(e.ToString());
                Response.End();
            }
        }
        /**** End of LoadReport ****************************************************************************************/

        private void PerformSearch()
		{
			string strSelectionHeader = Session[sHeaderName].ToString();
            keyColName = Session["PNLkey"].ToString();
            string[] str = new string[8];

			str[0] = Session["Accounting_sPeriod"].ToString();
			str[1] = Session["Accounting_sBranchName"] .ToString();
			str[2] = Session["Accounting_sBranch_elt_account_number"] .ToString();
			str[3] = Session["Accounting_sCompanName"] .ToString();
			str[4] = Session["Accounting_sReportTitle"] .ToString();
			str[5] = Session["Accounting_sSelectionParam"] .ToString();
			str[6] = Session["str6"].ToString();
            str[7] = Session["str7"].ToString();

			for(int i=0;i<str.Length-1;i++)
			{
				if(str[i+1] !="") str[i] = str[i] + "/";
			}

            Label2.Text = string.Format("<FONT color='navy' size='1pt'>{0} {1} {2} {3} {4} {5}  {6} {7}</FONT>", str[0], str[1], str[2], str[3], str[4], str[5], str[6], str[7]);

			if(strSelectionHeader == "" ) Response.Redirect(ParentPage);

			ConnectStr = (new igFunctions.DB().getConStr());
			SqlConnection Con = new SqlConnection(ConnectStr);
			SqlCommand cmdHeader = new SqlCommand(strSelectionHeader,Con);
			SqlDataAdapter Adap = new SqlDataAdapter();
           //Response.Write("--------------" + strSelectionHeader);
           //Response.End();

			Con.Open();
			
			Adap.SelectCommand = cmdHeader;

			Adap.Fill(ds, ParentTable);

			Con.Close();

            if (strResultStyle != "d")
            {
                performInsertSubTotal();
            }
            else
            {
                UltraWebGrid1.DataSource = ds.Tables[ParentTable].DefaultView;
                UltraWebGrid1.DataBind();
            }

            if (UltraWebGrid1.Rows.Count < 1)
            {
                UltraWebGrid1.Visible = false;
                lblNoData.Text = "No Data was found!";
                lblNoData.Visible = true;
            }
            else
            {
                lblNoData.Visible = false;
            }
            
		}

        private void performInsertSubTotal()
        {
            string tmpkey = "";
            double subtotAmount = 0;
            double subtotCost = 0;
            double subtotProfit = 0;
            double totAmount = 0;
            double totCost = 0;
            double totProfit = 0;
            int iCnt = 0;
//            DataTable dt = new DataTable("Tmp");
            DataTable dt = ds.Tables[ParentTable].Clone();
            dt.TableName = "Tmp"; 
            DataRow dr;

//            DataTable cdt = new DataTable("cTmp");
            DataTable cdt = ds.Tables[ParentTable].Clone();
            cdt.TableName = "cTmp";
            DataRow cdr;

            foreach (DataRow eRow in ds.Tables[ParentTable].Rows)
            {
                iCnt++;
                if (iCnt == 1) tmpkey = eRow[0].ToString().Trim();
                if (eRow[0].ToString().Trim() != tmpkey)
                {
                    totAmount += subtotAmount;
                    totCost += subtotCost;
                    totProfit += subtotProfit;

                    dr = dt.NewRow();
                    dr[0] = tmpkey;
                    dr["Customer"] = performGetSubTotalCaption(tmpkey.ToString());
                    dr["Description"] = "Sub Total";
                    dr["Amount"] = subtotAmount;
                    dr["Cost"] = subtotCost;
                    dr["Profit"] = subtotProfit;
                    dt.Rows.Add(dr);

                    tmpkey = eRow[0].ToString().Trim();
                    subtotAmount = subtotCost = subtotProfit = 0;

                }
                if (eRow["Amount"].ToString() != "")
                {
                    subtotAmount += double.Parse(eRow["Amount"].ToString());
                }
                if (eRow["Cost"].ToString() != "")
                {
                    subtotCost += double.Parse(eRow["Cost"].ToString());
                }
                if (eRow["Profit"].ToString() != "")
                {
                    subtotProfit += double.Parse(eRow["Profit"].ToString());
                }    
                if (strResultStyle == "d")
                {
                    dr = dt.NewRow();

                    for (int i = 1; i < eRow.ItemArray.Length; i++)
                    {
                        dr[i] = eRow[i];
                    }

                    dt.Rows.Add(dr);
                }
                else if (strResultStyle == "a")
                {
                    cdr = cdt.NewRow();

                    cdr[0] = eRow[0].ToString().Trim();
                    for (int i = 1; i < eRow.ItemArray.Length; i++)
                    {
                        cdr[i] = eRow[i];
                    }

                    cdt.Rows.Add(cdr);
                }

                if (iCnt == ds.Tables[ParentTable].Rows.Count)
                {

                    totAmount += subtotAmount;
                    totCost += subtotCost;
                    totProfit += subtotProfit;

                    dr = dt.NewRow();
                    dr[0] = tmpkey;
                    dr["Customer"] = performGetSubTotalCaption(tmpkey.ToString());
                    dr["Description"] = "Sub Total";
                    dr["Amount"] = subtotAmount;
                    dr["Cost"] = subtotCost;
                    dr["Profit"] = subtotProfit;
                    dt.Rows.Add(dr);
                    break;
                }

            }

            ds.Tables.Remove(ParentTable);

            if (strResultStyle != "a")
            {
                dr = dt.NewRow();
                dr[0] = "Grand Total";
                dr["Customer"] = "Grand Total";
                dr["Description"] = "Grand Total";
                dr["Amount"] = totAmount;
                dr["Cost"] = totCost;
                dr["Profit"] = totProfit;
                dt.Rows.Add(dr);
                ds.Tables.Add(dt);
            }
            else
            {
                ds.Tables.Add(dt);
                ds.Tables.Add(cdt);
                ds.Relations.Add(ds.Tables["Tmp"].Columns["sort_key"], ds.Tables["cTmp"].Columns["sort_key"]);
            }

            UltraWebGrid1.DataSource = dt.DefaultView;
            UltraWebGrid1.DataBind();



        }

        private object performGetSubTotalCaption(string p)
        {
            string strTitle = "";
            if (strResultStyle == "s" || strResultStyle == "a")
            {
                if (keyColName == "Route")
                {
                    if (p.Trim() == "->" || p.Trim() == " -> ")
                    {
                        strTitle = "";
                    }
                    else
                    {
                        strTitle = p;
                    }
                }
                else
                {
                    strTitle = p;
                }
            }
            else
            {
                if (keyColName == "MAWB/MBOL#")
                {
                    if (p.Trim() != "")
                    {
                        strTitle = "Sub Total of " + p + " ";
                    }
                    else
                    {
                        strTitle = "Sub Total ";
                    }

                }
                else if (keyColName == "Route")
                {
                     strTitle = "Sub Total ";
                }
                else if (keyColName == "Ref.#")
                {
                    if (p.Trim() != "")
                    {
                        strTitle = "Total of " + keyColName + " " + p;
                    }
                    else
                    {
                        strTitle = "Total ";
                    }
                }
                else if (keyColName == "Import/Export")
                {
                    if (p.Trim() == "")
                    {
                        strTitle = "Total ";
                    }
                    else if (p.Trim() == "I")
                    {
                        strTitle = "Total of Import";
                    }
                    else if (p.Trim() == "E")
                    {
                        strTitle = "Total of Export";
                    }
                }

                else
                {

                    if (p.Trim() != "")
                    {
                        strTitle = "Total of " + keyColName + " " + p;
                    }
                    else
                    {
                        strTitle = "Total ";
                    }
                }
            }
            return strTitle;
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
                UltraWebGrid1.DisplayLayout.ReadOnly = ReadOnly.LevelOne;
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

//				UltraWebGrid1.DisplayLayout.HeaderClickActionDefault = HeaderClickAction.SortMulti;
                UltraWebGrid1.DisplayLayout.ReadOnly = ReadOnly.NotSet;
				UltraWebGrid1.DisplayLayout.CellClickActionDefault = CellClickAction.CellSelect;
				UltraWebGrid1.DisplayLayout.ViewType = Infragistics.WebUI.UltraWebGrid.ViewType.OutlookGroupBy;
				UltraWebGrid1.DisplayLayout.GroupByBox.BandLabelStyle.BackColor = Color.White;

				UltraWebGrid1.DisplayLayout.AllowSortingDefault = Infragistics.WebUI.UltraWebGrid.AllowSorting.Yes;
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
                DataTable table = new DataTable(UltraWebGrid1.DisplayLayout.Bands[iB].BaseTableName);
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
		}
		
        protected void btnReset_Click(object sender, System.EventArgs e)
		{
			UltraWebGrid1.ResetColumns();
			UltraWebGrid1.ResetBands();
			PerformSearch();
		}
        
        protected void btnPDF_Click(object sender, System.EventArgs e)
        {
            string tempFile = Session.SessionID.ToString();
            PerformSearch();
            LoadReport();
            //rsm.getReportDocument().ExportToHttpResponse(ExportFormatType.PortableDocFormat, Response, true, tempFile);
            //rsm.CloseReportDocumnet();

            Response.Clear();
            Response.Buffer = true;
            Response.ContentType = "application/pdf";
            Response.AddHeader("Content-Type", "application/pdf");
            Response.AddHeader("Content-disposition", "attachment;filename=" + tempFile + ".pdf");

            MemoryStream oStream; // using System.IO
            oStream = (MemoryStream)rsm.getReportDocument().ExportToStream(ExportFormatType.PortableDocFormat);
            rsm.CloseReportDocumnet();
            Response.BinaryWrite(oStream.ToArray());
            Response.Flush();
            Response.End();
        }
        
        protected void btnDOC_Click(object sender, System.EventArgs e)
        {
            string tempFile = Session.SessionID.ToString();
            PerformSearch();
            LoadReport();
            //rsm.getReportDocument().ExportToHttpResponse(ExportFormatType.WordForWindows, Response, true, tempFile);
            //rsm.CloseReportDocumnet();

            Response.Clear();
            Response.Buffer = true;
            Response.ContentType = "application/doc";
            Response.AddHeader("Content-Type", "application/doc");
            Response.AddHeader("Content-disposition", "attachment;filename=" + tempFile + ".doc");

            MemoryStream oStream; // using System.IO
            oStream = (MemoryStream)rsm.getReportDocument().ExportToStream(ExportFormatType.WordForWindows);
            rsm.CloseReportDocumnet();
            Response.BinaryWrite(oStream.ToArray());
            Response.Flush();
            Response.End();
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
                    e.Layout.Bands[i].SelectedHeaderStyle.HorizontalAlign = HorizontalAlign.Center;

                }
            }


            UltraWebGrid1.DisplayLayout.SelectedHeaderStyleDefault.BackColor = Color.Red;
            UltraWebGrid1.DisplayLayout.SelectTypeCellDefault = Infragistics.WebUI.UltraWebGrid.SelectType.Single;
            UltraWebGrid1.DisplayLayout.AllowColSizingDefault = Infragistics.WebUI.UltraWebGrid.AllowSizing.Free;

            //set cursor 
            UltraWebGrid1.DisplayLayout.FrameStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Default;
            UltraWebGrid1.DisplayLayout.Bands[0].HeaderStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Default;

            UltraWebGrid1.DisplayLayout.SelectedHeaderStyleDefault.BackColor = Color.Red;

            performChangeGridWidth(sender, e, 0);

            if (strResultStyle == "s")
            {
                PerformFlat();

                performMakeHiddenField(sender, e, 0);

                switch (keyColName)
                {
                    case "MAWB/MBOL#":
                        break;
                    case "Customer":
                        e.Layout.Bands[0].Columns.FromKey("Customer").Width = new Unit("300px");
                        break;
                    case "Month": break;
                    case "Week": break;
                    case "Day": break;
                    case "Quater": break;
                    case "Year": break;
                    case "Route":
                        e.Layout.Bands[0].Columns.FromKey("Customer").Width = new Unit("300px");
                        break;
                    default:
                        break;
                }

            }
            else if (strResultStyle == "d")
            {
                PerformGroupby();

                UltraWebGrid1.DisplayLayout.ColFootersVisibleDefault = ShowMarginInfo.Yes;
                UltraWebGrid1.DisplayLayout.FooterStyleDefault.Height = 20;
                e.Layout.Bands[0].FooterStyle.BackColor = Color.Yellow;
                e.Layout.Bands[0].FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            }
            else if (strResultStyle == "a")
            {
                PerformFlat();
                performMakeHiddenField(sender, e, 0);

                e.Layout.Bands[0].FooterStyle.BackColor = Color.Yellow;
                e.Layout.Bands[1].Columns.FromKey("sort_key").Hidden = true;
                e.Layout.Bands[1].Columns.FromKey("Date").Format = "MM/dd/yyyy";
                performChangeGridWidth(sender, e, 1);

                UltraWebGrid1.DisplayLayout.ColFootersVisibleDefault = ShowMarginInfo.Yes;
                UltraWebGrid1.DisplayLayout.FooterStyleDefault.Height = 20;
                e.Layout.Bands[0].FooterStyle.BackColor = Color.Yellow;
                e.Layout.Bands[0].FooterStyle.HorizontalAlign = HorizontalAlign.Right;
                e.Layout.Bands[1].FooterStyle.BackColor = Color.YellowGreen;
                e.Layout.Bands[1].FooterStyle.HorizontalAlign = HorizontalAlign.Right;
                switch (keyColName)
                {
                    case "Air/Ocean":
                        e.Layout.Bands[0].Columns.FromKey("Customer").Width = new Unit("734px");
                        e.Layout.Bands[1].Columns.FromKey("air_ocean").Hidden = true;
                        break;
                    case "Import/Export":
                        e.Layout.Bands[0].Columns.FromKey("Customer").Width = new Unit("734px");
                        e.Layout.Bands[1].Columns.FromKey("import_export").Hidden = true;
                        break;
                    case "MAWB/MBOL#":
                        e.Layout.Bands[0].Columns.FromKey("Customer").Width = new Unit("664px");
                        e.Layout.Bands[1].Columns.FromKey("MAWB").Hidden = true;
                        break;
                    case "Customer":
                        e.Layout.Bands[0].Columns.FromKey("Customer").Width = new Unit("604px");
                        e.Layout.Bands[1].Columns.FromKey("Customer").Hidden = true;
                        break;
                    case "Month":
                        e.Layout.Bands[0].Columns.FromKey("Customer").Width = new Unit("764px");
                        break;
                    case "Week":
                        e.Layout.Bands[0].Columns.FromKey("Customer").Width = new Unit("764px");
                        break;
                    case "Day":
                        e.Layout.Bands[0].Columns.FromKey("Customer").Width = new Unit("764px");
                        break;
                    case "Quater":
                        e.Layout.Bands[0].Columns.FromKey("Customer").Width = new Unit("764px");
                        break;
                    case "Year":
                        e.Layout.Bands[0].Columns.FromKey("Customer").Width = new Unit("764px");
                        break;
                    case "File No.":
                        e.Layout.Bands[0].Columns.FromKey("Customer").Width = new Unit("694px");
                        e.Layout.Bands[1].Columns.FromKey("Our_Ref_No").Hidden = true;
                        break;
                    case "Ref.#":
                        e.Layout.Bands[0].Columns.FromKey("Customer").Width = new Unit("694px");
                        e.Layout.Bands[1].Columns.FromKey("Ref_No").Hidden = true;
                        break;
                    case "Route":
                        e.Layout.Bands[0].Columns.FromKey("Customer").Width = new Unit("624px");
                        e.Layout.Bands[1].Columns.FromKey("Origin").Hidden = true;
                        e.Layout.Bands[1].Columns.FromKey("Destination").Hidden = true;
                        break;
                    default:
                        break;
                }
            }

        }

        private void performMakeHiddenField(object sender, LayoutEventArgs e, int iBand)
        {
            e.Layout.Bands[iBand].Columns.FromKey("Customer").Header.Caption = keyColName;
            e.Layout.Bands[iBand].Columns.FromKey("Customer").Width = new Unit("100px");
            e.Layout.Bands[iBand].Columns.FromKey("Date").Hidden = true;
            e.Layout.Bands[iBand].Columns.FromKey("Ref_No").Hidden = true;
            e.Layout.Bands[iBand].Columns.FromKey("MAWB").Hidden = true;
            e.Layout.Bands[iBand].Columns.FromKey("Invoice").Hidden = true;
            e.Layout.Bands[iBand].Columns.FromKey("Our_Ref_No").Hidden = true;
            e.Layout.Bands[iBand].Columns.FromKey("import_export").Hidden = true;
            e.Layout.Bands[iBand].Columns.FromKey("air_ocean").Hidden = true;
            e.Layout.Bands[iBand].Columns.FromKey("Origin").Hidden = true;
            e.Layout.Bands[iBand].Columns.FromKey("Destination").Hidden = true;

        }

        private void performChangeGridWidth(object sender, LayoutEventArgs e, int iBand)
        {
            e.Layout.Bands[iBand].Columns.FromKey("Customer_Num").Hidden = true;
            e.Layout.Bands[iBand].Columns[0].Hidden = true;

            e.Layout.Bands[iBand].Columns.FromKey("Date").Format = "MM/dd/yyyy";
            e.Layout.Bands[iBand].Columns.FromKey("Date").Width = new Unit("70px");
            e.Layout.Bands[iBand].Columns.FromKey("Invoice").Width = new Unit("50px");
            e.Layout.Bands[iBand].Columns.FromKey("Invoice").Header.Caption = "Invoice";
           // e.Layout.Bands[iBand].Columns.FromKey("Invoice").Header.Style.HorizontalAlign = HorizontalAlign.Center;
            e.Layout.Bands[iBand].Columns.FromKey("Customer").Width = new Unit("160px");
            e.Layout.Bands[iBand].Columns.FromKey("MAWB").Width = new Unit("100px");
            e.Layout.Bands[iBand].Columns.FromKey("import_export").Width = new Unit("30px");
            e.Layout.Bands[iBand].Columns.FromKey("air_ocean").Width = new Unit("30px");

            e.Layout.Bands[iBand].Columns.FromKey("MAWB").Header.Caption = "MAWB/MBOL";
            e.Layout.Bands[iBand].Columns.FromKey("import_export").Header.Caption = "I/E";
            e.Layout.Bands[iBand].Columns.FromKey("air_ocean").Header.Caption = "A/O";

            e.Layout.Bands[iBand].Columns.FromKey("Ref_No").Width = new Unit("70px");
            e.Layout.Bands[iBand].Columns.FromKey("Our_Ref_No").Width = new Unit("70px");
            e.Layout.Bands[iBand].Columns.FromKey("Our_Ref_No").Header.Caption = "File No.";
            e.Layout.Bands[iBand].Columns.FromKey("Amount").Width = new Unit("70px");
            e.Layout.Bands[iBand].Columns.FromKey("Cost").Width = new Unit("70px");
            e.Layout.Bands[iBand].Columns.FromKey("Profit").Width = new Unit("70px");
            e.Layout.Bands[iBand].Columns.FromKey("Origin").Width = new Unit("70px");
            e.Layout.Bands[iBand].Columns.FromKey("Destination").Width = new Unit("70px");
            e.Layout.Bands[iBand].Columns.FromKey("Description").Hidden = true;

            e.Layout.Bands[iBand].Columns.FromKey("Amount").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[iBand].Columns.FromKey("Amount").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[iBand].Columns.FromKey("Amount").FooterTotal = SummaryInfo.Sum;
            e.Layout.Bands[iBand].Columns.FromKey("Amount").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[iBand].Columns.FromKey("Cost").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[iBand].Columns.FromKey("Cost").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[iBand].Columns.FromKey("Cost").FooterTotal = SummaryInfo.Sum;
            e.Layout.Bands[iBand].Columns.FromKey("Cost").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[iBand].Columns.FromKey("Profit").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[iBand].Columns.FromKey("Profit").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[iBand].Columns.FromKey("Profit").FooterTotal = SummaryInfo.Sum;
            e.Layout.Bands[iBand].Columns.FromKey("Profit").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[iBand].HeaderStyle.HorizontalAlign = HorizontalAlign.Center;

        }
        
        protected void UltraWebGrid1_InitializeRow1(object sender, RowEventArgs e)
        {
            if (e.Row.Band.BaseTableName == "cTmp" || e.Row.Band.BaseTableName == "INVOICE" )
            {
                if (e.Row.Cells.FromKey("Invoice").Value.ToString() != "0")
                {
                    string s = "javascript:; void(viewPop('/ASP/acct_tasks/edit_invoice.asp?edit=yes&InvoiceNo=" + e.Row.Cells.FromKey("Invoice").Value.ToString() + "'))";
                    e.Row.Cells.FromKey("Invoice").TargetURL = s;
                }
                else
                {
                   
                    string s = "";
                    e.Row.Cells.FromKey("Invoice").Text = "ADN";
                   
                    if (e.Row.Cells.FromKey("air_ocean").Value.ToString() == "A")
                    {
                       
                        s = "javascript:; void(viewPop('/ASP/air_import/air_import2.asp?iType=A&Edit=yes&MAWB=" + e.Row.Cells.FromKey("MAWB").Value.ToString() + "'))";
                    }
                    else
                    {
                       
                       s = "javascript:; void(viewPop('../../../ASP/ocean_import/ocean_import2.asp?iType=O&Edit=yes&MAWB=" + e.Row.Cells.FromKey("MAWB").Value.ToString() + "'))";

                    }
                    e.Row.Cells.FromKey("Invoice").TargetURL = s;
                }
            }


   

            if (e.Row.Cells.FromKey("Description").Text == "Sub Total")
            {
                e.Row.Style.BackColor = Color.LightYellow;
            }

            if (e.Row.Cells.FromKey("Description").Text == "Grand Total")
            {
                e.Row.Style.BackColor = Color.Yellow;
            }


        }

        protected void UltraWebGrid1_PageIndexChanged1(object sender, Infragistics.WebUI.UltraWebGrid.PageEventArgs e)
        {
        }

        protected void btnExcelExport_Click(object sender, ImageClickEventArgs e)
        {
            this.UltraWebGridExcelExporter1.DownloadName = "InvoiceList.xls";
            this.UltraWebGridExcelExporter1.Export(this.UltraWebGrid1);
        }
}
}
























