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
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;

namespace IFF_MAIN.ASPX.Reports.Operation
{
	/// <summary>
	/// AccountingDetail에 대한 요약 설명입니다.
	/// </summary>
	public partial class OperationResult : System.Web.UI.Page
	{
		protected System.Web.UI.WebControls.Button butShowCols;

//***********************************************************//

       
		string strDefaultXSDFileName = "Operation.XSD";
        string strDefaultXMLFileName = "Operation.XML";
        string strDefaultXMLXSDFileName = "Operation.XML";
	
        protected string ConnectStr;
		protected DataSet ds = new DataSet();
        static public string windowName;
        static public string strResultStyle;
        protected string grp;
        protected string anal;
        protected string part;
        protected ReportDocument rd;
		protected void Page_Load(object sender, System.EventArgs e)
		{
            
			Session.LCID = 1033;
            windowName = Request.QueryString["WindowName"];

            grp = (string)Session["keyCol"];
            anal = (string)Session["anal"];

            part=  Request.QueryString["Part"].ToString();            
            part=part.Replace('-', ' ');
            this.lblTitle.Text = part + " Operation Report";
            this.lblSubTitle.Text = "Analysis on: "+ anal + " Catagorized by: " + grp;
            this.lblSubTitle2.Text="Period: "+Session["timeStart"].ToString() + " ~ " + Session["timeEnd"].ToString();
          
           // Response.Write(part);

            if(!IsPostBack)
               {
                   ViewState["Count"]= 1;

                   if (part == "Air Export" || part == "Domestic Export")
                   {}
                   if(Request.UrlReferrer == null)
                   {
                       Response.Redirect("AirExportOperationSelection.aspx");
                   }
                   else
                   {
                       string refer = Request.UrlReferrer.ToString();
                       string ServerPath = Request.Url.ToString();                      
                   }                 
                   PerformBindToUGrid();                
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
       

        private void LoadReport()
        {
            ds = ((DataSet)Session["DSet"]).Copy();


            string elt_num = Request.Cookies["CurrentUserInfo"]["elt_account_number"];

                
            string[] str = new string[12];

            str[0] = Session["timeStart"].ToString() + " ~ " + Session["timeEnd"].ToString();
            str[1] = grp;
            str[2] = anal; Response.Write(anal);
            str[3] = Request.Cookies["CurrentUserInfo"]["login_name"];
            str[4] = part;
             
            str[5]=Session["GrossWeightTotal"].ToString();
            str[6] = Session["ChargeableWeightTotal"].ToString();
            str[7] = Session["QuantityTotal"].ToString();
            str[8] = Session["FreightChargeTotal"].ToString();
            str[9] = Session["OtherChargeTotal"].ToString();
            str[10] = Session["FrequenctyTotal"].ToString();
            str[11] = Session["PercentageTotal"].ToString();


            try
            {
                LoadCompanyInfo(elt_num, Server.MapPath("../../../ClientLogos/" + elt_num + ".jpg"));                
                LoadOtherInfo(str);

                if (grp == "Sales Rep.") { grp = "SalesRep"; }

                if (part == "Air Export" || part == "Domestic Export")
                {
                   
                    WriteXSD(Server.MapPath("../../../CrystalReportResources/xsd/AEOperation_"+grp+".xsd"));
                   
                    if (!BindNow(Server.MapPath("../../../CrystalReportResources/rpt/AEOperation_"+grp+".rpt")))
                    {
                        Response.Write("failed to bind");
                        Response.End();
                    }
                }

                

                if (part == "Ocean Export")
                {
                    WriteXSD(Server.MapPath("../../../CrystalReportResources/xsd/OEOperation_" + grp + ".xsd"));
                    if (!BindNow(Server.MapPath("../../../CrystalReportResources/rpt/OEOperation_" + grp + ".rpt")))
                    {
                        Response.Write("failed to bind");
                        Response.End();
                    }
                }

                if (part == "Air Import")
                {
                    WriteXSD(Server.MapPath("../../../CrystalReportResources/xsd/AIOperation_" + grp + ".xsd"));
                    if (!BindNow(Server.MapPath("../../../CrystalReportResources/rpt/AIOperation_" + grp + ".rpt")))
                    {
                        Response.Write("failed to bind");
                        Response.End();
                    }
                }

                if (part == "Ocean Import")
                {
                    WriteXSD(Server.MapPath("../../../CrystalReportResources/xsd/OIOperation_" + grp + ".xsd"));
                    if (!BindNow(Server.MapPath("../../../CrystalReportResources/rpt/OIOperation_" + grp + ".rpt")))
                    {
                        Response.Write("failed to bind");
                        Response.End();
                    }
                }


            }
            catch (Exception e)
            {
                Response.Write(e.ToString());
                Response.End();
            }
        }

        
        private void addImageTable(string columName, string imageFile)
        {
            DataTable dataTable = new DataTable();
            dataTable.TableName = "Images";
            try
            {
                if (imageFile != null)
                {
                    dataTable.Columns.Add(columName, System.Type.GetType("System.Byte[]"));
                    DataRow dataRow = dataTable.NewRow();
                    dataRow[0] = File.ReadAllBytes(imageFile);
                    dataTable.Rows.Add(dataRow);
                }
            }
            catch (Exception ex)
            {
            }
            ds.Tables.Add(dataTable);
        }

        public void LoadOtherInfo(string[] values)
        {
            DataTable dataTable = new DataTable();
            dataTable.TableName = "Other";

            if (values != null)
            {
                for (int i = 0; i < values.Length; i++)
                {
                    dataTable.Columns.Add("Param" + i, System.Type.GetType("System.String"));
                }
                dataTable.Rows.Add(values);
                ds.Tables.Add(dataTable);
            }
        }

        public void LoadCompanyInfo(string accountNumber, string imageFile)
        {
            string selectCompany = "select business_legal_name, business_address,business_city, "
                + "business_state, business_country, business_phone, business_fax, business_url "
                + "from agent where elt_account_number = " + accountNumber;
            string ConnectStr = (new igFunctions.DB().getConStr());
            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand cmd = new SqlCommand(selectCompany, Con);
            SqlDataAdapter Adap = new SqlDataAdapter();

            Con.Open();
            Adap.SelectCommand = cmd;
            Adap.Fill(ds, "Business");
            Con.Close();

            addImageTable("image_files", imageFile);
        }

        public bool BindNow(string rptFile)
        {
            try
            {
                rd = new ReportDocument();
                rd.Load(rptFile, OpenReportMethod.OpenReportByTempCopy);
                rd.SetDataSource(ds.Copy());
            }
            catch (Exception ex)
            {
                return false;
            }
            return true;
        }


        public void WriteXSD(string xsdFile)
        {

            if (xsdFile != null && (!File.Exists(xsdFile)))
            {
                try
                {
                    ds.WriteXmlSchema(xsdFile);
                }
                catch (Exception ex)
                {
                }
            }
        }

        /**** End of LoadReport ****************************************************************************************/

        private void PerformBindToUGrid()
		{

            grp = (string)Session["keyCol"];
            ds = ((DataSet)Session["DSet"]).Copy();
            
            UltraWebGrid1.DataSource = ds.Tables["parent"];
            UltraWebGrid1.DataBind();
            

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





        protected void UltraWebGrid1_InitializeLayout1(object sender, LayoutEventArgs e)
        {

            UltraWebGrid1.DisplayLayout.ReadOnly = ReadOnly.LevelOne;

            e.Layout.ViewType = ViewType.Hierarchical;// To show child table 
            e.Layout.TableLayout = TableLayout.Auto;// To expand column with 
            e.Layout.RowStyleDefault.BorderDetails.ColorTop = Color.Gray;

            e.Layout.Bands[1].Columns.FromKey(grp).Hidden = true;

            for (int i = 0; i < UltraWebGrid1.Bands.Count; i++)
            {
                //                Response.Write("<script language='javascript'> alert('" + i + "')</script>");
                for (int j = 0; j < UltraWebGrid1.Bands[i].Columns.Count; j++)
                {
                    e.Layout.Bands[i].HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
                   
                   
                }
            }

            
            changeParentCaption(e, grp);
            changeChildCaption(e);
            changeParentFormat(e);
            changeChildFormat(e);
        }
        private void changeParentFormat(LayoutEventArgs e)
        {
            e.Layout.Bands[0].Columns.FromKey("Chargeable Wt.").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[0].Columns.FromKey("Chargeable Wt.").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[0].Columns.FromKey("Gross Wt.").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[0].Columns.FromKey("Gross Wt.").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[0].Columns.FromKey("Percentage").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[0].Columns.FromKey("Percentage").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[0].Columns.FromKey("Other Charge").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[0].Columns.FromKey("Other Charge").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[0].Columns.FromKey("Freight Charge").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[0].Columns.FromKey("Freight Charge").CellStyle.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[0].Columns.FromKey("Quantity").CellStyle.HorizontalAlign = HorizontalAlign.Right;
        }
        private void changeChildFormat(LayoutEventArgs e)
        {

            e.Layout.Bands[1].Columns.FromKey("Chargeable Wt.").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[1].Columns.FromKey("Chargeable Wt.").CellStyle.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[1].Columns.FromKey("Gross Wt.").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[1].Columns.FromKey("Gross Wt.").CellStyle.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[1].Columns.FromKey("Other Charge").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[1].Columns.FromKey("Other Charge").CellStyle.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[1].Columns.FromKey("Freight Charge").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[1].Columns.FromKey("Freight Charge").CellStyle.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[1].Columns.FromKey("Quantity").CellStyle.HorizontalAlign = HorizontalAlign.Right;
           
           
            if (part == "Air Import" || part == "Ocean Import")
            {
                e.Layout.Bands[1].Columns.FromKey("sec").Hidden = true;
            }
        }

        private void changeParentCaption(LayoutEventArgs e, string grp)
        {            

             //e.Layout.Bands[0].Columns.FromKey("group").Header.Caption = grp;
             if (part == "Ocean Import" || part == "Ocean Export")
             {
                e.Layout.Bands[0].Columns.FromKey("Chargeable Wt.").Header.Caption="Measurement";
             }
             e.Layout.Bands[0].Columns.FromKey("Freight Charge").Header.Caption="Freight Charge";
             e.Layout.Bands[0].Columns.FromKey("Other Charge").Header.Caption = "Other Charge";
           

        }
        private void changeChildCaption(LayoutEventArgs e)
        {

            if (part == "Air Export" || part == "Ocean Export" || part == "Domestic Export"){                
                e.Layout.Bands[1].Columns.FromKey("Date").Header.Caption = "ETD";//EXPORT
             }
             if(part=="Air Import" || part=="Ocean Import"){
              e.Layout.Bands[1].Columns.FromKey("Date").Header.Caption = "ETA";
             }
             if (part == "Air Import" || part == "Air Export" || part == "Domestic Export")
             {
               e.Layout.Bands[1].Columns.FromKey("Master").Header.Caption="MAWB#";
               e.Layout.Bands[1].Columns.FromKey("House").Header.Caption="HAWB#";

            }if(part=="Ocean Import"||part=="Ocean Export"){

              e.Layout.Bands[1].Columns.FromKey("Master").Header.Caption="MBOL#";
              e.Layout.Bands[1].Columns.FromKey("House").Header.Caption="HBOL#";
              e.Layout.Bands[1].Columns.FromKey("Chargeable Wt.").Header.Caption="Measurement";
            }
           

        }

        

		
		
        protected void btnExcel_Click(object sender, System.EventArgs e)
		{
            this.UltraWebGridExcelExporter1.DownloadName = "Operation.xls";
			this.UltraWebGridExcelExporter1.Export(this.UltraWebGrid1);

		}
		
        protected void btnXML_Click(object sender, System.EventArgs e)
		{
			
			string tmpLogDir = Request.Cookies["CurrentUserInfo"]["temp_path"];			
            string c_strFilePathXSD = tmpLogDir+"/"+Session.SessionID.ToString()+DateTime.Now.Ticks.ToString()+ strDefaultXSDFileName;
			string c_strFilePathXML = tmpLogDir+"/"+Session.SessionID.ToString()+DateTime.Now.Ticks.ToString()+ strDefaultXMLFileName;
			
            string c_strFilePathXSDXML = tmpLogDir+"/"+Session.SessionID.ToString()+DateTime.Now.Ticks.ToString()+ strDefaultXMLXSDFileName;

            DataSet c_fileDataSet = ds; 

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
		
              
		
        protected void btnReset_Click(object sender, System.EventArgs e)
		{
			
			PerformBindToUGrid();
		}
        
        protected void btnPDF_Click(object sender, System.EventArgs e)
        {
            string tempFile = Session.SessionID.ToString();
           
            LoadReport();
            rd.ExportToHttpResponse(ExportFormatType.PortableDocFormat, Response, true, tempFile);
            rd.Close();
            rd.Dispose();
        
        }
        
        protected void btnDOC_Click(object sender, System.EventArgs e)
        {
            string tempFile = Session.SessionID.ToString();
            PerformBindToUGrid();
            LoadReport();
            rd.ExportToHttpResponse(ExportFormatType.WordForWindows, Response, true, tempFile);
            rd.Close();
            rd.Dispose();
        
        }
        
        
      

        /* REFERENCE ONLY
        private void performChangeGridWidth(object sender, LayoutEventArgs e, int iBand)
        {
            e.Layout.Bands[iBand].Columns.FromKey("Customer_Num").Hidden = true;
            e.Layout.Bands[iBand].Columns[0].Hidden = true;

            e.Layout.Bands[iBand].Columns.FromKey("Date").Format = "MM/dd/yyyy";
            

            e.Layout.Bands[iBand].Columns.FromKey("Amount").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[iBand].Columns.FromKey("Amount").Format = "###,###,##0.00;(###,###,##0.00); ";
            e.Layout.Bands[iBand].Columns.FromKey("Amount").FooterTotal = SummaryInfo.Sum;
            e.Layout.Bands[iBand].Columns.FromKey("Amount").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[iBand].HeaderStyle.HorizontalAlign = HorizontalAlign.Center;

        }*/


        protected void UltraWebGrid1_InitializeRow1(object sender, RowEventArgs e)
        {


            string s = "";
            if (part == "Ocean Export" )
            {
                if (e.Row.Band.BaseTableName == "Child")
                {
                    if (e.Row.Cells.FromKey("House").Value.ToString().Trim() == "")
                    {
                        s = "javascript:; " + "void(viewPop('../../../ASP/ocean_export/new_edit_mbol.asp?edit=yes&WindowName=popUpWindow&MBOL=";
                        e.Row.Cells.FromKey("Master").TargetURL = s + e.Row.Cells.FromKey("Master").Text + "'))";
                    }
                    else
                    {
                        s = "javascript:; " + "void(viewPop('../../../ASP/ocean_export/new_edit_mbol.asp?edit=yes&WindowName=popUpWindow&MBOL=";
                        e.Row.Cells.FromKey("Master").TargetURL = s + e.Row.Cells.FromKey("Master").Text + "'))";

                        s = "javascript:; " + "void(viewPop('../../../ASP/ocean_export/new_edit_hbol.asp?edit=yes&WindowName=popUpWindow&HBOL=";
                        e.Row.Cells.FromKey("House").TargetURL = s + e.Row.Cells.FromKey("House").Text

                            + "'))";

                    }

                }

            }
            else if ( part == "Ocean Import")
            {
                if (e.Row.Band.BaseTableName == "Child")
                {
                    if (e.Row.Cells.FromKey("House").Value.ToString().Trim() == "")
                    {
                        s = "javascript:; " + "void(viewPop('../../../ASP/ocean_import/ocean_import2.asp?iType=O&WindowName=popUpWindow&Edit=yes&MAWB=";
                        e.Row.Cells.FromKey("Master").TargetURL = s + e.Row.Cells.FromKey("Master").Text + "'))";
                    }
                    else
                    {
                        s = "javascript:; " + "void(viewPop('../../../ASP/ocean_import/ocean_import2.asp?iType=O&WindowName=popUpWindow&Edit=yes&MAWB=";
                        e.Row.Cells.FromKey("Master").TargetURL = s + e.Row.Cells.FromKey("Master").Text + "'))";

                        s = "javascript:; " + "void(viewPop('../../../ASP/ocean_import/arrival_notice.asp?iType=O&edit=yes&WindowName=popUpWindow&HAWB=";

                        e.Row.Cells.FromKey("House").TargetURL = s + e.Row.Cells.FromKey("House").Text + "&MAWB=" +
                            e.Row.Cells.FromKey("Master").Text + "&Sec=" + e.Row.Cells.FromKey("sec").Text
                            
                        + "'))";

                    }

                }

            }
            else if (part == "Air Export" )
            {
                if (e.Row.Band.BaseTableName == "Child")
                {
                    if (e.Row.Cells.FromKey("House").Value.ToString().Trim() == "")
                    {
                        s = "javascript:; " + "void(viewPop('../../../ASP/air_export/new_edit_mawb.asp?edit=yes&WindowName=popUpWindow&MAWB=";
                        e.Row.Cells.FromKey("Master").TargetURL = s + e.Row.Cells.FromKey("Master").Text + "'))";
                    }
                    else
                    {
                        s = "javascript:; " + "void(viewPop('../../../ASP/air_export/new_edit_mawb.asp?edit=yes&WindowName=popUpWindow&MAWB=";
                        e.Row.Cells.FromKey("Master").TargetURL = s + e.Row.Cells.FromKey("Master").Text + "'))";

                        s = "javascript:; " + "void(viewPop('../../../ASP/air_export/new_edit_hawb.asp?edit=yes&WindowName=popUpWindow&HAWB=";
                        e.Row.Cells.FromKey("House").TargetURL = s + e.Row.Cells.FromKey("House").Text + "'))";

                    }

                }
            }

            else if (part == "Domestic Export")
            {
                if (e.Row.Band.BaseTableName == "Child")
                {
                    s = "javascript:; " + "void(viewPop('../../../ASP/domestic/new_edit_hawb.asp?edit=yes&WindowName=popUpWindow&HAWB=";
                    e.Row.Cells.FromKey("House").TargetURL = s + e.Row.Cells.FromKey("House").Text + "'))";
                }
            }

            else if ( part == "Air Import")
            {
                if (e.Row.Band.BaseTableName == "Child")
                {
                    if (e.Row.Cells.FromKey("House").Value.ToString().Trim() == "")
                    {
                        s = "javascript:; " + "void(viewPop('../../../ASP/air_import/air_import2.asp?iType=A&WindowName=popUpWindow&Edit=yes&MAWB=";
                        e.Row.Cells.FromKey("Master").TargetURL = s + e.Row.Cells.FromKey("Master").Text + "'))";
                    }
                    else
                    {
                        s = "javascript:; " + "void(viewPop('../../../ASP/air_import/air_import2.asp?iType=A&WindowName=popUpWindow&Edit=yes&MAWB=";
                        e.Row.Cells.FromKey("Master").TargetURL = s + e.Row.Cells.FromKey("Master").Text + "'))";

                        s = "javascript:; " + "void(viewPop('../../../ASP/air_import/arrival_notice.asp?iType=A&edit=yes&WindowName=popUpWindow&HAWB=";                    

                        e.Row.Cells.FromKey("House").TargetURL = s + e.Row.Cells.FromKey("House").Text + "&MAWB=" + e.Row.Cells.FromKey("Master").Text + "&Sec=" + e.Row.Cells.FromKey("sec").Text                  
                            
                         + "'))";

                    }

                }
            }

        }

        protected void UltraWebGrid1_PageIndexChanged1(object sender, Infragistics.WebUI.UltraWebGrid.PageEventArgs e)
        {
        }


        protected void btnExcelExport_Click(object sender, ImageClickEventArgs e)
        {
            this.UltraWebGridExcelExporter1.DownloadName = "Operation.xls";
            this.UltraWebGridExcelExporter1.Export(this.UltraWebGrid1);
        }
}
}
























