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
	public partial class APAgingDetailUnPost : System.Web.UI.Page
	{
		protected System.Web.UI.WebControls.Button butShowCols;

//***********************************************************//
		protected string ParentTable="AP";
		protected string ChildTable="APDETAIL";
		protected string keyColName="Vendor Name";
		protected string dsXMLName ="AP";
		protected string sHeaderName = "APAgingSUMMARY";
		protected string sDetailName = "APAgingSUMMARYDETAIL";
		protected string defaultReportForm = "bill.rpt";
		protected string strDefaultXSDFileName = "AP.XSD";
		protected string strDefaultXMLFileName = "AP.XML";
		protected string strDefaultXMLXSDFileName = "APALL.XML";
		protected string ParentPage = "APAgingSelection.aspx";
		public string elt_account_number;
		public string user_id;
		protected string strUserRight;
		protected string strBranch;
		protected string strCompany;
        protected string ConnectStr;
		protected DataSet ds = new DataSet();

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
			string[] str = new string[7];
			string strCommandText;
			string strlblBranch;
			string strBranch;

			strCommandText = Session["strCommandText"].ToString();
			strlblBranch = Session["strlblBranch"].ToString();
			strBranch = Session["strBranch"].ToString();

			str[0] = Session["Accounting_sPeriod"].ToString();
			str[1] = Session["Accounting_sBranchName"] .ToString();
			str[2] = Session["Accounting_sBranch_elt_account_number"] .ToString();
			str[3] = Session["Accounting_sCompanName"] .ToString();

			for(int i=0;i<str.Length-1;i++)
			{
				if(str[i+1] !="") str[i] = str[i] + "/";
			}

			Label2.Text = string.Format("<FONT color='navy' size='1pt'>{0} {1} {2} {3} </FONT>",str[0],str[1],str[2],str[3]);

			if(strCommandText == "") Response.Redirect(ParentPage);

			PerformGetAPData(strCommandText,strlblBranch);

		}

		private void PerformGetAPData(string strCommandText,string strBranch)
		{
			ConnectStr = (new igFunctions.DB().getConStr());
			SqlConnection Con = new SqlConnection(ConnectStr);
			SqlCommand Cmd = new SqlCommand();
			Cmd.Connection = Con;

			Con.Open();			

			Cmd.CommandText= strCommandText;
			
			SqlDataReader reader = Cmd.ExecuteReader();

			//**********************************************// refer from old program logic
			
			double 
				sTotalCurrent=0,
				sTotal1_30=0,
				sTotal31_60=0,
				sTotal61_90=0,
				sTotal91=0,
				sTotal=0,

				sCurrent=0,
				s1_30=0,
				s31_60=0,
				s61_90=0,
				s91=0,
				sSubTotal=0;

			//				vTotalCurrent=0,
			//				vTotal1_30=0,
			//				vTotal31_60=0,
			//				vTotal61_90=0,
			//				vTotal91=0,
			//				vTotal=0;

			string vLastName="",cName="";
			int tIndex=0;
			int bIndex=0;

//			DataTable schemaTable = reader.GetSchemaTable().Rows.Count;
//			int iCount = reader.GetSchemaTable().Rows.Count;

			int iCount = 0;
			while (reader.Read()) { iCount ++; };
			reader.Close();

			string[,] aField = new string[7,iCount];
			string[,] bField = new string[14,iCount];

			reader = Cmd.ExecuteReader();

			while (reader.Read())				
			{
				#region // Parent logic
				cName=reader["dba_name"].ToString().Trim();

                if (cName == null) cName = "";
                cName = cName.Trim().Replace("'", "`");
	
				if (bIndex == 0) vLastName = cName;

				if ( cName != vLastName ) 
				{
					aField[0,tIndex]=vLastName;
					aField[1,tIndex]=sTotalCurrent.ToString();
					aField[2,tIndex]=sTotal1_30.ToString();
					aField[3,tIndex]=sTotal31_60.ToString();
					aField[4,tIndex]=sTotal61_90.ToString();
					aField[5,tIndex]=sTotal91.ToString();
					aField[6,tIndex]=sTotal.ToString();
					vLastName=cName;
					tIndex+=1;
					sTotalCurrent=0;
					sTotal1_30=0;
					sTotal31_60=0;
					sTotal61_90=0;
					sTotal91=0;
					sTotal=0;
				}
					
				DateTime vBillDate=DateTime.Parse(reader["tran_date"].ToString());
				double vBalance = double.Parse(reader["item_amt"].ToString());

				DateTime d1 = DateTime.Now;
				TimeSpan vAging  = d1 -vBillDate;
			
				if ( vAging.Days<= 0)
				{
					sTotalCurrent=sTotalCurrent+vBalance;
					sTotal=sTotal+vBalance;
				}
				else if(vAging.Days > 0 && vAging.Days < 31)
				{
					sTotal1_30=sTotal1_30+vBalance;
					sTotal=sTotal+vBalance;
				}
				else if(vAging.Days>30 && vAging.Days<61)
				{
					sTotal31_60=sTotal31_60+vBalance;
					sTotal=sTotal+vBalance;
				}
				else if(vAging.Days>60 && vAging.Days<91)
				{
					sTotal61_90=sTotal61_90+vBalance;
					sTotal=sTotal+vBalance;
				}
				else if ( vAging.Days>90 )
				{
					sTotal91=sTotal91+vBalance;
					sTotal=sTotal+vBalance;
				}

				if ( (bIndex +1) == iCount )  // end of reader
				{
					aField[0,tIndex]=cName;
					aField[1,tIndex]=sTotalCurrent.ToString();
					aField[2,tIndex]=sTotal1_30.ToString();
					aField[3,tIndex]=sTotal31_60.ToString();
					aField[4,tIndex]=sTotal61_90.ToString();
					aField[5,tIndex]=sTotal91.ToString();
					aField[6,tIndex]=sTotal.ToString();
					tIndex += 1;  // for using transfer to DataTable below
				}

				#endregion

// Detail Info. : Refer from original program...I hate this kind of logic.... 
// (by iMoon...)

				sCurrent=0;
				s1_30=0;
				s31_60=0;
				s61_90=0;
				s91=0;
				sSubTotal=0;

				bField[0,bIndex]=cName;				
				bField[2,bIndex]=vBillDate.ToShortDateString();
				bField[3,bIndex]=reader["invoice_no"].ToString();


				bField[5,bIndex] = ((DateTime) (vBillDate)).ToShortDateString();

				if (vAging.Days > 0) 
				{
					bField[5,bIndex]=vAging.Days.ToString();
				}

				bField[6,bIndex]=vBalance.ToString();

				if (vAging.Days <= 0) 
				{
					sCurrent=vBalance;
					sSubTotal= vBalance;
				}
				else if(vAging.Days > 0 && vAging.Days < 31)
				{
					s1_30=vBalance;
					sSubTotal= vBalance;
				}
				else if(vAging.Days>30 && vAging.Days<61)
				{
					s31_60=vBalance;
					sSubTotal= vBalance;
				}
				else if(vAging.Days>60 && vAging.Days<91)
				{
					s61_90=vBalance;
					sSubTotal= vBalance;
				}
				else if ( vAging.Days>90 )
				{
					s91=vBalance;
					sSubTotal= vBalance;
				}

				bField[7,bIndex]=sCurrent.ToString();
				bField[8,bIndex]=s1_30.ToString();
				bField[9,bIndex]=s31_60.ToString();
				bField[10,bIndex]=s61_90.ToString();
				bField[11,bIndex]=s91.ToString();
				bField[12,bIndex]=sSubTotal.ToString();

				bField[1,bIndex] = "BILL";
                bField[13, bIndex] = "../../../ASPX/AccountingTasks/edit_invoice.aspx?edit=yes&invoice_no=" + bField[3, bIndex].ToString();
                bField[13, bIndex] += "&Branch=" + reader["elt_account_number"].ToString();
	
				bIndex += 1;



			} 

			reader.Close();

			#region // backup

//			aField[0,tIndex]=cName;
//			aField[1,tIndex]=sTotalCurrent.ToString();
//			aField[2,tIndex]=sTotal1_30.ToString();
//			aField[3,tIndex]=sTotal31_60.ToString();
//			aField[4,tIndex]=sTotal61_90.ToString();
//			aField[5,tIndex]=sTotal91.ToString();
//			aField[6,tIndex]=sTotal.ToString();

			//			vTotal=vTotalCurrent+vTotal1_30+vTotal31_60+vTotal61_90+vTotal91;
			//			vTotalCurrent=vTotalCurrent;
			//			vTotal1_30=vTotal1_30;
			//			vTotal31_60=vTotal31_60;
			//			vTotal61_90=vTotal61_90;
			//			vTotal91=vTotal91;
			//			vTotal=vTotal;

			#endregion

			Con.Close();

			// DataTable

			#region // Parent table

			DataTable dt = new DataTable(ParentTable);
			DataRow dr;

			dt.Columns.Add(new DataColumn(keyColName, typeof(string)));
			dt.Columns.Add(new DataColumn("Current", typeof(System.Decimal)));
			dt.Columns.Add(new DataColumn("1~30", typeof(System.Decimal)));
			dt.Columns.Add(new DataColumn("31~60", typeof(System.Decimal)));
			dt.Columns.Add(new DataColumn("61~90", typeof(System.Decimal)));
			dt.Columns.Add(new DataColumn("+90", typeof(System.Decimal)));
			dt.Columns.Add(new DataColumn("Total", typeof(System.Decimal)));

			for(int i=0;i<tIndex;i++)
			{
				if(aField[0,i] == null)  break;

				dr = dt.NewRow();
				dr[0] = aField[0,i];
				dr[1] = aField[1,i];
				dr[2] = aField[2,i];
				dr[3] = aField[3,i];
				dr[4] = aField[4,i];
				dr[5] = aField[5,i];
				dr[6] = aField[6,i];

				if (dr[0].ToString() != string.Empty) dt.Rows.Add(dr);
			}

			ds.Tables.Add(dt);

#endregion

			# region // Child table
			DataTable cdt = new DataTable(ChildTable);
			DataRow cdr;

			cdt.Columns.Add(new DataColumn(keyColName, typeof(string)));
			cdt.Columns.Add(new DataColumn("Type", typeof(string)));
			cdt.Columns.Add(new DataColumn("I/V Date", typeof(string)));
			cdt.Columns.Add(new DataColumn("I/V No.", typeof(string)));
			cdt.Columns.Add(new DataColumn("Aging", typeof(string)));
			cdt.Columns.Add(new DataColumn("Open Balance", typeof(System.Decimal)));
			cdt.Columns.Add(new DataColumn("Current", typeof(System.Decimal)));
			cdt.Columns.Add(new DataColumn("1~30", typeof(System.Decimal)));
			cdt.Columns.Add(new DataColumn("31~60", typeof(System.Decimal)));
			cdt.Columns.Add(new DataColumn("61~90", typeof(System.Decimal)));
			cdt.Columns.Add(new DataColumn("+90", typeof(System.Decimal)));
			cdt.Columns.Add(new DataColumn("Total", typeof(System.Decimal)));
			cdt.Columns.Add(new DataColumn("Link", typeof(string)));

			for(int i=0;i<bIndex;i++)
			{
				if(bField[0,i] == null)  break;			

				cdr = cdt.NewRow();

				cdr[0] = bField[0,i];
				cdr[1] = bField[1,i];
				cdr[2] = bField[2,i];
				cdr[3] = bField[3,i];
				cdr[4] = bField[5,i];
				cdr[5] = bField[6,i];
				cdr[6] = bField[7,i];
				cdr[7] = bField[8,i];
				cdr[8] = bField[9,i];
				cdr[9] = bField[10,i];
				cdr[10] = bField[11,i];
				cdr[11] = bField[12,i];
				cdr[12] = bField[13,i];

				if (cdr[0].ToString() != string.Empty) cdt.Rows.Add(cdr);
			}

			ds.Tables.Add(cdt);

			#endregion


			if(ds.Relations.Count<1) 
				ds.Relations.Add(ds.Tables[ParentTable].Columns[keyColName],ds.Tables[ChildTable].Columns[keyColName]);
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

//			int iWeight = 0;
//			int iOther = 0;
//			string strHAWB1 = "";
//			string strHAWB2 = "";
//
//			//			DataTable table = new DataTable(ChildTable);
//
//			foreach(DataRow eRow in ds.Tables[ChildTable].Rows)
//			{				
//				strHAWB1 = eRow["bill"].ToString();
//				if(strHAWB1 != strHAWB2)
//				{
//					iWeight = (int) eRow["a_Rec_count"];
//					iOther = (int) eRow["b_Rec_count"];
//				}
//
//				if (iWeight == 0)
//				{
//					eRow["PCS"] = System.DBNull.Value;
//					eRow["Unit_of_QTY"] = System.DBNull.Value;
//					eRow["Gross_Weight"] = System.DBNull.Value;
//					eRow["Chargeable_Weight"] = System.DBNull.Value;
//					eRow["Kg_Lb"] = System.DBNull.Value;
//					eRow["Rate_Charge"] = System.DBNull.Value;
//					eRow["Total_Charge"] = System.DBNull.Value;
//				}
//				else { iWeight--; }
//				if (iOther == 0)
//				{
//					eRow["Other_Charge"] = System.DBNull.Value;
//				}
//				else { iOther--; }
//
//				strHAWB2 = strHAWB1;
//			}
//
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
			this.UltraWebGrid1.PageIndexChanged += new Infragistics.WebUI.UltraWebGrid.PageIndexChangedEventHandler(this.UltraWebGrid1_PageIndexChanged);
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
			this.UltraWebGridExcelExporter1.DownloadName = "OP_report_HAWB.xls";
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

		protected void Button1_Click(object sender, System.EventArgs e)
		{
			int a = int.Parse(ViewState["Count"].ToString());
				string script = "<script language='javascript'>";

				script += "if(history.length >= " + a.ToString() + ")";
				script += "{ history.go(-" + a.ToString() + "); }";
				script += "else{location.replace('APAgingSelection.aspx')}";
				script += "</script>";
				this.ClientScript.RegisterStartupScript(this.GetType(), "Pre", script);  			
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
					string colName = UltraWebGrid1.DisplayLayout.Bands[iB].Columns[i].BaseColumnName.ToString();
					if(UltraWebGrid1.DisplayLayout.Bands[iB].Columns[i].Hidden != true  ||  colName == keyColName )
					{
						if ( colName == "Link" ) continue;
						table.Columns.Add(UltraWebGrid1.Bands[iB].Columns[i].BaseColumnName.ToString(),Type.GetType(UltraWebGrid1.Bands[iB].Columns[i].DataType));
					}
				}

				foreach(DataRow eRow in ds.Tables[UltraWebGrid1.DisplayLayout.Bands[iB].Key].Rows)
				{
					DataRow aRow = table.NewRow();						
					iCnt = 0;
					for(int j=0;j<this.UltraWebGrid1.DisplayLayout.Bands[iB].Columns.Count;j++)
					{
						string colName = UltraWebGrid1.DisplayLayout.Bands[iB].Columns[j].BaseColumnName.ToString();
						if(UltraWebGrid1.DisplayLayout.Bands[iB].Columns[j].Hidden != true || colName == keyColName )
						{
							if ( colName == "Link" ) continue;
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

			if(this.CheckBox1.Checked)
			{
				PerformGroupby();
			}
			else
			{
				PerformFlat();
			}		
			

		}

		private void UltraWebGrid1_PageIndexChanged(object sender, Infragistics.WebUI.UltraWebGrid.PageEventArgs e)
		{
			UltraWebGrid1.DisplayLayout.Pager.CurrentPageIndex = e.NewPageIndex;
			PerformSearch();
			PerformDataBind();
		
		}

		private void UltraWebGrid1_InitializeRow(object sender, Infragistics.WebUI.UltraWebGrid.RowEventArgs e)
		{
            string s = "";
            if (e.Row.Band.BaseTableName == ChildTable)
            {
                e.Row.Cells.FromKey("Vendor Name").Text = "";
                //e.Row.Cells.FromKey("Open Balance").Style.ForeColor = Color.Purple;
                //e.Row.Cells.FromKey("Aging").Style.ForeColor = Color.Purple;				

                s = "javascript:; void(viewPop('" + (e.Row.Cells.FromKey("Link").Value.ToString()) + "'))";
                e.Row.Cells.FromKey("I/V No.").TargetURL = s;
            }

		}

        protected void UltraWebGrid1_InitializeLayout1(object sender, LayoutEventArgs e)
        {
            e.Layout.SelectTypeColDefault = SelectType.Single;
            e.Layout.SelectTypeRowDefault = SelectType.Extended;

            e.Layout.ViewType = ViewType.Hierarchical;
            e.Layout.TableLayout = TableLayout.Fixed;
//            e.Layout.RowStyleDefault.BorderDetails.ColorTop = Color.Gray;

            PerformFlat();


            for (int i = 0; i < UltraWebGrid1.Bands.Count; i++)
            {
                for (int j = 0; j < UltraWebGrid1.Bands[i].Columns.Count; j++)
                {
                    UltraWebGrid1.DisplayLayout.Bands[i].Columns[j].SelectedCellStyle.BackColor = Color.FromArgb(73, 30, 138);
                    UltraWebGrid1.DisplayLayout.Bands[i].Columns[j].SelectedCellStyle.ForeColor = Color.WhiteSmoke;
                }
            }

            e.Layout.Bands[1].Columns.FromKey("Link").Hidden = true;

            UltraWebGrid1.DisplayLayout.SelectedHeaderStyleDefault.BackColor = Color.Red;
            UltraWebGrid1.DisplayLayout.SelectTypeCellDefault = Infragistics.WebUI.UltraWebGrid.SelectType.Single;
            UltraWebGrid1.DisplayLayout.AllowColSizingDefault = Infragistics.WebUI.UltraWebGrid.AllowSizing.Free;

            //set cursor 
            UltraWebGrid1.DisplayLayout.FrameStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Default;
            UltraWebGrid1.DisplayLayout.Bands[0].HeaderStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Default;

            UltraWebGrid1.DisplayLayout.SelectedHeaderStyleDefault.BackColor = Color.Red;

            UltraWebGrid1.Bands[0].DataKeyField = ds.Tables[ParentTable].Columns[keyColName].ColumnName;
            UltraWebGrid1.Bands[1].DataKeyField = ds.Tables[ChildTable].Columns[keyColName].ColumnName;

            e.Layout.Bands[1].Columns.FromKey("Vendor Name").CellStyle.BackColor = Color.FromArgb(207, 221, 240);
            e.Layout.Bands[1].Columns.FromKey("Aging").CellStyle.BackColor = Color.LightYellow;
            e.Layout.Bands[1].Columns.FromKey("Open Balance").CellStyle.BackColor = Color.LightYellow;
            e.Layout.Bands[1].Columns.FromKey("Total").CellStyle.BackColor = Color.LightGoldenrodYellow;

            e.Layout.Bands[0].Columns.FromKey("Vendor Name").CellStyle.BorderDetails.WidthRight = new Unit("0px");
            
            e.Layout.Bands[0].Columns.FromKey("Vendor Name").Width = new Unit("320px");
            e.Layout.Bands[1].Columns.FromKey("Vendor Name").Width = new Unit("0px");
            e.Layout.Bands[1].Columns.FromKey("Type").Width = new Unit("40px");
            e.Layout.Bands[1].Columns.FromKey("I/V Date").Width = new Unit("70px");
            e.Layout.Bands[1].Columns.FromKey("I/V No.").Width = new Unit("50px");
            e.Layout.Bands[1].Columns.FromKey("Aging").Width = new Unit("40px");
            e.Layout.Bands[1].Columns.FromKey("Open Balance").Width = new Unit("70px");


            e.Layout.Bands[1].Columns.FromKey("Vendor Name").Header.Caption = "";

            UltraWebGrid1.DisplayLayout.ColFootersVisibleDefault = ShowMarginInfo.Yes;
            UltraWebGrid1.DisplayLayout.FooterStyleDefault.Height = 20;

            e.Layout.Bands[1].Columns.FromKey("Aging").Footer.Caption = "Total";
            e.Layout.Bands[1].Columns.FromKey("Aging").Footer.Style.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[0].FooterStyle.BackColor = Color.Yellow;
            e.Layout.Bands[1].FooterStyle.BackColor = Color.LightGoldenrodYellow;

            e.Layout.Bands[0].Columns.FromKey("Current").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[0].Columns.FromKey("Current").Format = "###,###,##0.00";
            e.Layout.Bands[0].Columns.FromKey("Current").FooterTotal = SummaryInfo.Sum;
            e.Layout.Bands[0].Columns.FromKey("Current").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[0].Columns.FromKey("1~30").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[0].Columns.FromKey("1~30").Format = "###,###,##0.00";
            e.Layout.Bands[0].Columns.FromKey("1~30").FooterTotal = SummaryInfo.Sum;
            e.Layout.Bands[0].Columns.FromKey("1~30").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[0].Columns.FromKey("31~60").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[0].Columns.FromKey("31~60").Format = "###,###,##0.00";
            e.Layout.Bands[0].Columns.FromKey("31~60").FooterTotal = SummaryInfo.Sum;
            e.Layout.Bands[0].Columns.FromKey("31~60").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[0].Columns.FromKey("61~90").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[0].Columns.FromKey("61~90").Format = "###,###,##0.00";
            e.Layout.Bands[0].Columns.FromKey("61~90").FooterTotal = SummaryInfo.Sum;
            e.Layout.Bands[0].Columns.FromKey("61~90").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[0].Columns.FromKey("+90").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[0].Columns.FromKey("+90").Format = "###,###,##0.00";
            e.Layout.Bands[0].Columns.FromKey("+90").FooterTotal = SummaryInfo.Sum;
            e.Layout.Bands[0].Columns.FromKey("+90").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[0].Columns.FromKey("Total").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[0].Columns.FromKey("Total").Format = "###,###,##0.00";
            e.Layout.Bands[0].Columns.FromKey("Total").FooterTotal = SummaryInfo.Sum;
            e.Layout.Bands[0].Columns.FromKey("Total").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[1].Columns.FromKey("Aging").CellStyle.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[1].Columns.FromKey("Open Balance").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[1].Columns.FromKey("Open Balance").Format = "###,###,##0.00";
            e.Layout.Bands[1].Columns.FromKey("Open Balance").FooterTotal = SummaryInfo.Sum;
            e.Layout.Bands[1].Columns.FromKey("Open Balance").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[1].Columns.FromKey("Current").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[1].Columns.FromKey("Current").Format = "###,###,##0.00";
            e.Layout.Bands[1].Columns.FromKey("Current").FooterTotal = SummaryInfo.Sum;
            e.Layout.Bands[1].Columns.FromKey("Current").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[1].Columns.FromKey("1~30").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[1].Columns.FromKey("1~30").Format = "###,###,##0.00";
            e.Layout.Bands[1].Columns.FromKey("1~30").FooterTotal = SummaryInfo.Sum;
            e.Layout.Bands[1].Columns.FromKey("1~30").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[1].Columns.FromKey("31~60").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[1].Columns.FromKey("31~60").Format = "###,###,##0.00";
            e.Layout.Bands[1].Columns.FromKey("31~60").FooterTotal = SummaryInfo.Sum;
            e.Layout.Bands[1].Columns.FromKey("31~60").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[1].Columns.FromKey("61~90").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[1].Columns.FromKey("61~90").Format = "###,###,##0.00";
            e.Layout.Bands[1].Columns.FromKey("61~90").FooterTotal = SummaryInfo.Sum;
            e.Layout.Bands[1].Columns.FromKey("61~90").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[1].Columns.FromKey("+90").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[1].Columns.FromKey("+90").Format = "###,###,##0.00";
            e.Layout.Bands[1].Columns.FromKey("+90").FooterTotal = SummaryInfo.Sum;
            e.Layout.Bands[1].Columns.FromKey("+90").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;

            e.Layout.Bands[1].Columns.FromKey("Total").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[1].Columns.FromKey("Total").Format = "###,###,##0.00";
            e.Layout.Bands[1].Columns.FromKey("Total").FooterTotal = SummaryInfo.Sum;
            e.Layout.Bands[1].Columns.FromKey("Total").FooterStyleResolved.HorizontalAlign = HorizontalAlign.Right;

        }
}
}
























