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

namespace IFF_MAIN.ASPX.OnLines.Rate
{

	public partial class Ratemanagement : System.Web.UI.Page
	{
		protected System.Web.UI.WebControls.Button butShowCols;
//***********************************************************//
		protected string ParentTable="RateHeader";
		protected string ChildTable="RateDetail";
		protected string keyColName="RATEKEY";  // Company Number + Rate Type
		protected string dsXMLName ="Rate";
		protected string defaultReportForm = "Rate.rpt";
		protected string strDefaultXSDFileName = "Rate.XSD";
		protected string strDefaultXMLFileName = "Rate.XML";
		protected string strDefaultXMLXSDFileName = "RateAll.XML";
		public string elt_account_number;
		public string user_id,login_name,user_right;
        protected string ConnectStr;
		protected DataSet ds = new DataSet();
		string p_Code = null;
		string p_Name = null;
        public string windowName;
        public bool bReadOnly = false;

		protected void Page_Load(object sender, System.EventArgs e)
		{
			Session.LCID = 1033;		
			elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
			user_id  = Request.Cookies["CurrentUserInfo"]["user_id"];
			user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
			login_name  = Request.Cookies["CurrentUserInfo"]["login_name"];
            windowName = Request.QueryString["WindowName"];

			ConnectStr = (new igFunctions.DB().getConStr());
			bReadOnly = new igFunctions.DB().AUTH_CHECK(elt_account_number, user_id, ConnectStr, Request.ServerVariables["URL"].ToLower(), "");

			if(!IsPostBack)
			{
                goBtn.Attributes.Add("onclick", "Javascript:ReqDataCheck();");		
				ViewState["Count"]= 1;
				string Refer = "";
				if(Request.UrlReferrer != null)
				{
					Refer = Request.UrlReferrer.ToString();
				}

					if(Refer.IndexOf("Rate") == -1)
					{
						ViewState["Parent"] = Request.Url.ToString();
					}
					else 
					{
						ViewState["Parent"] = Refer;
					}

				performSelectionDataBinding();

				p_Code = Request.QueryString["ff"];
				p_Name = Request.QueryString["nn"];
                if (p_Name != null)
                {
                    p_Name = p_Name.Replace("^", "&");
                }
                if (p_Code != null)
                {
                    performRateEditRemote(p_Code, p_Name);
                }
			}
			else
			{
				ViewState["Count"] = (int)ViewState["Count"] + 1;
			}

            if (UltraWebGrid1.Bands[0] != null)
            {
                UltraWebGrid1.Bands[0].HeaderStyle.Height = new Unit("17px");
            }
				
		}

		private void performRateEditRemote(string p_Code, string p_Name) 
		{
			this.ComboBox1.Text = p_Name;
			this.ComboBox1.SelectedValue = p_Code;
			if(p_Code!="")
			{
				txtNum.Text = ComboBox1.Items.IndexOf(ComboBox1.Items.FindByValue(p_Code)).ToString();
                if (txtNum.Text == "-1")
                {
                    string script = "";
                    string errMsg = "Company data is not in Database, Please save company data first.";
                    script = "<script language='javascript'> ";
                    script += "alert(' " + errMsg + " '); ";
                    script += "window.close(); ";
                    script += "</script>";
                    this.ClientScript.RegisterClientScriptBlock(this.GetType(), "Pre", script);
                    return;
                }
			}
			UltraWebGrid1.ResetColumns();
			UltraWebGrid1.ResetBands();			
			PerformSearch();
			PerformDataBind();
		}

		private void performSelectionDataBinding()
		{
			
            DropDownList1.Attributes.Add("onchange", "SetCombo(false);");
			SqlConnection Con = new SqlConnection(ConnectStr);

			SqlCommand cmdCustomer = new SqlCommand(@"
													    SELECT	org_account_number, 
                                                    CASE WHEN isnull(class_code,'') = '' THEN dba_name
                                                    ELSE dba_name + '[' + RTRIM(LTRIM(isnull(class_code,''))) + ']'
                                                    END as dba_name 
													      FROM	organization 
													    WHERE	elt_account_number = " + elt_account_number + 
				"	AND ( dba_name != '' ) " +
//				"	AND (" +
//				"	  	is_shipper = 'Y' " +
//				"	or	is_consignee = 'Y' " +
//				"	or	is_agent = 'Y' ) " +
				" order by dba_name",Con);

			SqlDataAdapter Adap = new SqlDataAdapter();
			DataSet tmpDs = new DataSet();
				
			Con.Open();

			Adap.SelectCommand = cmdCustomer;
			Adap.Fill(tmpDs, "Customer");

			Con.Close();
		
			ComboBox1.DataSource =  tmpDs.Tables["Customer"];
			ComboBox1.DataTextField = tmpDs.Tables["Customer"].Columns["dba_name"].ToString();
			ComboBox1.DataValueField = tmpDs.Tables["Customer"].Columns["org_account_number"].ToString();
			ComboBox1.DataBind();
			ComboBox1.Items.Insert(0,"");
			ComboBox1.SelectedIndex = 0;

		}


		#region Web Form 디자이너에서 생성한 코드
		override protected void OnInit(EventArgs e)
		{

			InitializeComponent();
			base.OnInit(e);
		}
		

		private void InitializeComponent()
		{    
		}
        #endregion

		private void PerformGroupby()
		{

				UltraWebGrid1.DisplayLayout.CellClickActionDefault = CellClickAction.CellSelect;
				UltraWebGrid1.DisplayLayout.GroupByBox.BandLabelStyle.BackColor = Color.White;

				UltraWebGrid1.DisplayLayout.AllowSortingDefault = Infragistics.WebUI.UltraWebGrid.AllowSorting.Yes;

				UltraWebGrid1.DisplayLayout.GroupByBox.ShowBandLabels = Infragistics.WebUI.UltraWebGrid.ShowBandLabels.IntermediateBandsOnly;
				UltraWebGrid1.DisplayLayout.GroupByBox.Style.BackColor = Color.LightYellow;
				UltraWebGrid1.DisplayLayout.GroupByBox.ButtonConnectorColor=Color.Gray;
				UltraWebGrid1.DisplayLayout.GroupByBox.ButtonConnectorStyle=System.Web.UI.WebControls.BorderStyle.Dotted;

				UltraWebGrid1.DisplayLayout.HeaderClickActionDefault = HeaderClickAction.NotSet;

		}

		protected void btnExcel_Click(object sender, System.EventArgs e)
		{

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

			string tmpStr = "../../Reports/Common/MenuDownLoadXML.aspx?";
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
				Response.Redirect("../../Reports/Common/PrintReport.aspx?"+tmpStr);		
			}
			else
			{
				PerformWriteXML_XSD(c_fileDataSet, c_strFilePathXSD,c_strFilePathXML);
				string tmpStr = string.Format("c_strFilePathXSD={0}&c_strFilePathXML={1}&defaultReportForm={2}",c_strFilePathXSD,c_strFilePathXML,defaultReportForm);
				Response.Redirect("../../Reports/Common/PrintReport.aspx?"+tmpStr);		
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
					if((UltraWebGrid1.DisplayLayout.Bands[iB].Columns[i].Hidden != true && UltraWebGrid1.DisplayLayout.Bands[iB].Columns[i].BaseColumnName.ToString() != "Chk")
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
						if((UltraWebGrid1.DisplayLayout.Bands[iB].Columns[j].Hidden != true && UltraWebGrid1.DisplayLayout.Bands[iB].Columns[j].BaseColumnName.ToString() != "Chk")
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

		private void PerformSearch()
		{

			UltraWebGrid1.ResetColumns();
			UltraWebGrid1.ResetBands();

			string strCommandText = "";
			string strCompany = null;
			string strAirline = null;

			if( ComboBox1.Text != "" && txtNum.Text != "")
			{
				ComboBox1.SelectedIndex = int.Parse(txtNum.Text);
				strCompany = ComboBox1.SelectedValue;
			}

				SqlConnection Con = new SqlConnection(ConnectStr);
				SqlCommand Cmd = new SqlCommand();
				Cmd.Connection = Con;

                int iR = DropDownList1.SelectedIndex;
				switch (iR)  
				{
                    case 0: // Customer Selling Rate	: '4' in Oiginal table
                        strCommandText = "	SELECT	 a.*,b.dba_name FROM all_rate_table a,organization b " +
                            "	WHERE   a.elt_account_number=b.elt_account_number and a.elt_account_number = " + elt_account_number +
                            "	AND  a.customer_no=b.org_account_number AND a.rate_type='4' ";

                        if (strCompany != null)
                        {
                            strCommandText = strCommandText + "	 AND customer_no = " + strCompany;
                        }
                        strCommandText = strCommandText + "	 ORDER BY b.dba_name,origin_port,dest_port,kg_lb,airline,item_no,weight_break";
                        break;

					case 1 : // Airline Buying Rate			: '3' in Oiginal table

						if(strCompany != null) // Get Airline Code
						{
							string strCarrier = "	SELECT carrier_code FROM organization WHERE elt_account_number = "  + elt_account_number + 
								"  AND org_account_number = " + strCompany +
							"  AND org_account_number = " + strCompany + " AND is_carrier = 'Y' ";
							
							Con.Open();			
							Cmd.CommandText = strCarrier;
							SqlDataReader CarrierReader = Cmd.ExecuteReader();
							if(CarrierReader.Read()) 
							{
								strAirline = CarrierReader["carrier_code"].ToString();
							}
							CarrierReader.Close();
							Con.Close();
						}							    

                        strCommandText = "	SELECT a.*,b.dba_name FROM all_rate_table a left outer join organization b " +
                            "   ON a.elt_account_number=b.elt_account_number AND a.airline=b.carrier_code " +
                            "	WHERE a.elt_account_number = " + elt_account_number +
                            "	AND a.rate_type='3' ";						
						
						if(strAirline != null) 
						{
							strCommandText = strCommandText + "	 AND airline = " + strAirline;
						}
						strCommandText = strCommandText + "	 ORDER BY origin_port,dest_port,kg_lb,airline,item_no,weight_break";
						break;
                    case 2: // Agent Buying Rate			: '1' in Oiginal table
                        strCommandText =
                            "	SELECT	 a.*,b.dba_name FROM all_rate_table a,organization b " +
                            "	WHERE   a.elt_account_number=b.elt_account_number and a.elt_account_number = " + elt_account_number +
                            "	AND  a.agent_no=b.org_account_number AND a.rate_type='1' ";
                        if (strCompany != null)
                        {
                            strCommandText = strCommandText + "	 AND agent_no = " + strCompany;
                        }
                        strCommandText = strCommandText + "	 ORDER BY b.dba_name,origin_port,dest_port,kg_lb,airline,item_no,weight_break";
                        break;
                    case 3: // IATA Rate						: '5' in Oiginal table


						if(strCompany != null) // Get Airline Code
						{
							string strCarrier = "	SELECT carrier_code FROM organization WHERE elt_account_number = "  + elt_account_number + 
								"  AND org_account_number = " + strCompany +
							"  AND org_account_number = " + strCompany + " AND is_carrier = 'Y' ";
									
							Con.Open();			
							Cmd.CommandText = strCarrier;
							SqlDataReader CarrierReader = Cmd.ExecuteReader();
							if(CarrierReader.Read()) 
							{
								strAirline = CarrierReader["carrier_code"].ToString();
							}
							CarrierReader.Close();
							Con.Close();
						}

                        strCommandText = "	SELECT a.*,b.dba_name FROM all_rate_table a left outer join organization b " +
                            "   ON a.elt_account_number=b.elt_account_number AND a.airline=b.carrier_code " +
                            "	WHERE a.elt_account_number = " + elt_account_number +
                            "	AND a.rate_type='5' ";						
								
						if(strAirline != null) 
						{
							strCommandText = strCommandText + "	 AND airline = " + strAirline;
						}
						strCommandText = strCommandText + "	 ORDER BY origin_port,dest_port,kg_lb,airline,item_no,weight_break";
						break;
					default : return;
				}
			
				Con.Open();			
			
				Cmd.CommandText= strCommandText;
						
				SqlDataReader reader = Cmd.ExecuteReader();
			
				int iCount = 0;
				while (reader.Read()) { iCount ++; };
				reader.Close();

				string[,] aField = new string[9,iCount];
				string[,] bField = new string[7,iCount];

				reader = Cmd.ExecuteReader();

				int iIndex = 0;
				int tIndex = 0;
				string tmpKey1=null,tmpKey2 = null;
			
				while (reader.Read())				
				{

					switch (iR)  
					{
                        case 0: // Customer Selling Rate	: '4' in Oiginal table
                            tmpKey1 = reader["dba_name"].ToString() + reader["origin_port"].ToString() + reader["dest_port"].ToString() + reader["kg_lb"].ToString();
                            break;
						case 1 : // Airline Buying Rate			: '3' in Oiginal table
							tmpKey1 = reader["origin_port"].ToString() + reader["dest_port"].ToString() + reader["kg_lb"].ToString();
							break;
                        case 2: // Agent Buying Rate			: '1' in Oiginal table
                            tmpKey1 = reader["dba_name"].ToString() + reader["origin_port"].ToString() + reader["dest_port"].ToString() + reader["kg_lb"].ToString();
                            break;
                        case 3: // IATA Rate						: '5' in Oiginal table
							tmpKey1 = reader["origin_port"].ToString() + reader["dest_port"].ToString() + reader["kg_lb"].ToString();
							break;
						default : return;
					}

					if(iIndex == 0 || tmpKey1 != tmpKey2) 
					{
						aField[0,iIndex] = tmpKey1;
						aField[1,iIndex] = reader["dba_name"].ToString();
						aField[2,iIndex] = reader["rate_type"].ToString();
						aField[3,iIndex] = reader["agent_no"].ToString();
						aField[4,iIndex] = reader["customer_no"].ToString();
						aField[5,iIndex] = reader["origin_port"].ToString();
						aField[6,iIndex] = reader["dest_port"].ToString();
						aField[7,iIndex] = reader["kg_lb"].ToString();
						aField[8,iIndex] = reader["airline"].ToString();
						iIndex += 1;
					}

					bField[0,tIndex] = tmpKey1;
					bField[1,tIndex] = reader["dba_name"].ToString();
					bField[2,tIndex] = reader["item_no"].ToString();
					bField[3,tIndex] = reader["airline"].ToString();
					bField[4,tIndex] = reader["weight_break"].ToString();
					bField[5,tIndex] = reader["rate"].ToString();
					bField[6,tIndex] = reader["Share"].ToString();		
					tIndex += 1;

					tmpKey2 = tmpKey1;
				}

				reader.Close();
				Con.Close();

			PerformMakeSearchDataSet(aField, bField, iIndex, tIndex);
		
			if(ds.Relations.Count<1) 
				ds.Relations.Add(ds.Tables[ParentTable].Columns[keyColName],ds.Tables[ChildTable].Columns[keyColName]);

		}

		private void PerformMakeSearchDataSet(string[,] aField, string[,] bField, int iIndex, int tIndex )
		{
			if(ds.Tables[ParentTable] != null) ds.Tables.Remove(ParentTable);
			if(ds.Tables[ChildTable] != null) ds.Tables.Remove(ChildTable);

            int iR = DropDownList1.SelectedIndex;
			
			//Parent Table
			DataTable dt = new DataTable(ParentTable);
			DataRow dr;

			dt.Columns.Add(new DataColumn("Chk", typeof(string)));					
			dt.Columns.Add(new DataColumn(keyColName, typeof(string)));					
			dt.Columns.Add(new DataColumn("Company Name", typeof(string)));			
			dt.Columns.Add(new DataColumn("Code", typeof(string)));				
			dt.Columns.Add(new DataColumn("Origin", typeof(string)));						
			dt.Columns.Add(new DataColumn("Destination", typeof(string)));			
			dt.Columns.Add(new DataColumn("Kg/Lb", typeof(string)));
			dt.Columns.Add(new DataColumn("R0", typeof(string)));		/* 7 */
			dt.Columns.Add(new DataColumn("R1", typeof(string)));		/* 8 */
			dt.Columns.Add(new DataColumn("R2", typeof(string)));		/* 9 */
			dt.Columns.Add(new DataColumn("R3", typeof(string)));		/* 10 */
			dt.Columns.Add(new DataColumn("R4", typeof(string)));		/* 11 */
			dt.Columns.Add(new DataColumn("R5", typeof(string)));		/* 12 */
			dt.Columns.Add(new DataColumn("R6", typeof(string)));		/* 13 */
			dt.Columns.Add(new DataColumn("R7", typeof(string)));		/* 14 */
			dt.Columns.Add(new DataColumn("R8", typeof(string)));		/* 15 */
			dt.Columns.Add(new DataColumn("R9", typeof(string)));		/* 16 */	
			dt.Columns.Add(new DataColumn("Blank", typeof(string)));		
			dt.Columns.Add(new DataColumn("a", typeof(string)));		
			dt.Columns.Add(new DataColumn("e", typeof(string)));		
			dt.Columns.Add(new DataColumn("x", typeof(string)));		
			
			//Child Table
			DataTable cdt = new DataTable(ChildTable);
			DataRow cdr = null;

			cdt.Columns.Add(new DataColumn("Chk", typeof(string)));					
			cdt.Columns.Add(new DataColumn(keyColName, typeof(string)));					
			cdt.Columns.Add(new DataColumn("Company Name", typeof(string)));			
			cdt.Columns.Add(new DataColumn("item_no", typeof(string)));				
			cdt.Columns.Add(new DataColumn("Airline", typeof(string)));						
			cdt.Columns.Add(new DataColumn("R0", typeof(string)));		/* 5 */
			cdt.Columns.Add(new DataColumn("R1", typeof(string)));		/* 6 */		
			cdt.Columns.Add(new DataColumn("R2", typeof(string)));						
			cdt.Columns.Add(new DataColumn("R3", typeof(string)));						
			cdt.Columns.Add(new DataColumn("R4", typeof(string)));						
			cdt.Columns.Add(new DataColumn("R5", typeof(string)));						
			cdt.Columns.Add(new DataColumn("R6", typeof(string)));						
			cdt.Columns.Add(new DataColumn("R7", typeof(string)));						
			cdt.Columns.Add(new DataColumn("R8", typeof(string)));						
			cdt.Columns.Add(new DataColumn("R9", typeof(string)));		/* 14 */
			cdt.Columns.Add(new DataColumn("Share", typeof(string)));				
			cdt.Columns.Add(new DataColumn("a", typeof(string)));					
			cdt.Columns.Add(new DataColumn("e", typeof(string)));					
			cdt.Columns.Add(new DataColumn("x", typeof(string)));				

			for(int i=0;i<iIndex;i++)
			{
				if(aField[0,i] != null)  
				{

					dr = dt.NewRow();
					dr[1] = aField[0,i];
					dr[2] = aField[1,i];
					switch (iR)  
					{
                        case 0: // Customer Selling Rate	: '4' in Oiginal table
                            dr[3] = aField[4, i];
                            break;
						case 1 : // Airline Buying Rate			: '3' in Oiginal table
							dr[2] = "N/A";
							dr[3] = aField[8,i];
							break;
                        case 2: // Agent Buying Rate			: '1' in Oiginal table
                            dr[3] = aField[3, i];
                            break;
                        case 3: // IATA Rate						: '5' in Oiginal table
							dr[2] = "N/A";
							dr[3] = aField[8,i];
							break;
						default : return;
					}
					
					dr[4] = aField[5,i];
					dr[5] = aField[6,i];
					dr[6] = aField[7,i];

					// start
					string vAir1 = "";
					string vAir2 = "";
					int j = 0;

					while(j<tIndex)
					{
						if(bField[0,j] != aField[0,i])  
						{
							j++;
							continue;
						}

						vAir2 = bField[3,j];

						if(vAir1 != vAir2) 
						{
							if(vAir1 != "" )
							{
								cdt.Rows.Add(cdr);
							}

							cdr = cdt.NewRow();
							cdr[1] = bField[0,j];
							cdr[2] = bField[1,j];
							cdr[3] = bField[2,j];
							cdr[4] = bField[3,j]; /* Airline */
							cdr[15] = bField[6,j]; /* Share */

							vAir1 = bField[3,j];
						}

						if(bField[4,j]=="0") // Min
						{
							dr[7] = "MIN.($)";
							cdr[5] = bField[5,j]; 
						}
                        else if(bField[4,j]=="1") // Min+
						{
							dr[8] = "+MIN.";
							cdr[6] = bField[5,j]; 
						}
						else
						{
							for(int k=0;k<tIndex;k++)
							{
								if((bField[0,k] == aField[0,i]) && (bField[3,k] == vAir1))  
								{
                                    if (bField[4, k] == "0" || bField[4, k] == "1") 
									{
										continue;
									}

									for(int l=9;l<17;l++)
									{
										string tmpL = dr[l].ToString();
										int il = l-2;
										if (tmpL == "" || tmpL == bField[4,k])	
										{ 
											dr[l] = bField[4,k]; 
											cdr[il] = bField[5,k];
											break; 
										}
									}							 
								}
							}
						} // else Min

						j++;

					} // while

					for(int l=6;l<14;l++)
					{
						if(cdr[l].ToString() == "X") 
							cdr[l] = "";
					}							 

					cdt.Rows.Add(cdr);
					// end
					for(int l=8;l<16;l++)
					{
						if(dr[l].ToString() == "X") dr[l] = "";
					}							 

					dt.Rows.Add(dr);

				}
			}

			ds.Tables.Add(dt);
			ds.Tables.Add(cdt);	
	}
		

		private void PerformSearchNew()
		{

			UltraWebGrid1.ResetColumns();
			UltraWebGrid1.ResetBands();

			string strCompany = null;

			if( ComboBox1.Text != "" && txtNum.Text != "")
			{
				ComboBox1.SelectedIndex = int.Parse(txtNum.Text);
				strCompany = ComboBox1.SelectedValue;
			}

			if(ds.Tables[ParentTable] != null) ds.Tables.Remove(ParentTable);
			if(ds.Tables[ChildTable] != null) ds.Tables.Remove(ChildTable);

			//Parent Table
			DataTable dt = new DataTable(ParentTable);
			DataRow dr;

			dt.Columns.Add(new DataColumn("Chk", typeof(string)));					
			dt.Columns.Add(new DataColumn(keyColName, typeof(string)));					
			dt.Columns.Add(new DataColumn("Company Name", typeof(string)));			
			dt.Columns.Add(new DataColumn("Code", typeof(string)));				
			dt.Columns.Add(new DataColumn("Origin", typeof(string)));						
			dt.Columns.Add(new DataColumn("Destination", typeof(string)));			
			dt.Columns.Add(new DataColumn("Kg/Lb", typeof(string)));
			dt.Columns.Add(new DataColumn("R0", typeof(string)));		/* 7 */
			dt.Columns.Add(new DataColumn("R1", typeof(string)));		/* 8 */
			dt.Columns.Add(new DataColumn("R2", typeof(string)));		/* 9 */
			dt.Columns.Add(new DataColumn("R3", typeof(string)));		/* 10 */
			dt.Columns.Add(new DataColumn("R4", typeof(string)));		/* 11 */
			dt.Columns.Add(new DataColumn("R5", typeof(string)));		/* 12 */
			dt.Columns.Add(new DataColumn("R6", typeof(string)));		/* 13 */
			dt.Columns.Add(new DataColumn("R7", typeof(string)));		/* 14 */
			dt.Columns.Add(new DataColumn("R8", typeof(string)));		/* 15 */
			dt.Columns.Add(new DataColumn("R9", typeof(string)));		/* 16 */	
			dt.Columns.Add(new DataColumn("a", typeof(string)));		
			dt.Columns.Add(new DataColumn("e", typeof(string)));		
			dt.Columns.Add(new DataColumn("x", typeof(string)));		
			dt.Columns.Add(new DataColumn("Blank", typeof(string)));		

			dr = dt.NewRow();
			if(ComboBox1.Text != "") 
			{
				dr[2] = ComboBox1.Text;
			}
			else
			{
				dr[2] = "Dbl Click...";
			}

			dr[3] = strCompany;
			dr[4] = "Dbl Click...";
			dr[5] = "Dbl Click...";
			dr[6] = "Dbl Click...";
			dr[7] = "MIN.($)";
            dr[8] = "+MIN.";
			dr[17] = "a";
			dt.Rows.Add(dr);

			
			//Child Table
			DataTable cdt = new DataTable(ChildTable);

			cdt.Columns.Add(new DataColumn("Chk", typeof(string)));					
			cdt.Columns.Add(new DataColumn(keyColName, typeof(string)));					
			cdt.Columns.Add(new DataColumn("Company Name", typeof(string)));			
			cdt.Columns.Add(new DataColumn("item_no", typeof(string)));				
			cdt.Columns.Add(new DataColumn("Airline", typeof(string)));						
			cdt.Columns.Add(new DataColumn("R0", typeof(string)));		/* 5 */
			cdt.Columns.Add(new DataColumn("R1", typeof(string)));		/* 6 */		
			cdt.Columns.Add(new DataColumn("R2", typeof(string)));						
			cdt.Columns.Add(new DataColumn("R3", typeof(string)));						
			cdt.Columns.Add(new DataColumn("R4", typeof(string)));						
			cdt.Columns.Add(new DataColumn("R5", typeof(string)));						
			cdt.Columns.Add(new DataColumn("R6", typeof(string)));						
			cdt.Columns.Add(new DataColumn("R7", typeof(string)));						
			cdt.Columns.Add(new DataColumn("R8", typeof(string)));						
			cdt.Columns.Add(new DataColumn("R9", typeof(string)));		/* 14 */
			cdt.Columns.Add(new DataColumn("Share", typeof(string)));				
			cdt.Columns.Add(new DataColumn("a", typeof(string)));					
			cdt.Columns.Add(new DataColumn("e", typeof(string)));					
			cdt.Columns.Add(new DataColumn("x", typeof(string)));				
			
			ds.Tables.Add(dt);
			ds.Tables.Add(cdt);	
		
			if(ds.Relations.Count<1) 
				ds.Relations.Add(ds.Tables[ParentTable].Columns[keyColName],ds.Tables[ChildTable].Columns[keyColName]);

		}
		
		private void PerformDataBind()
		{		

			UltraWebGrid1.DataSource=ds.Tables[ParentTable].DefaultView;	
			UltraWebGrid1.DataBind();	
			DoData();

		}

		protected void btnShow_Click(object sender, System.EventArgs e)
		{
			UltraWebGrid1.ResetColumns();
			UltraWebGrid1.ResetBands();			
			PerformSearch();
			PerformDataBind();
            UltraWebGrid1.ExpandAll(true);
		}

		private void DoData()
		{
            int iR = DropDownList1.SelectedIndex;

			SqlConnection Con = new SqlConnection(ConnectStr);
			SqlCommand cmdCustomer = new SqlCommand();
			cmdCustomer.Connection = Con;

			switch(iR) 
			{
                case 0: // Customer Selling Rate	: '4' in Oiginal table
                    cmdCustomer.CommandText = @"
																	SELECT	dba_name,
																				org_account_number 
																	  FROM	organization 
																	WHERE	elt_account_number = " + elt_account_number +
                                                                    "	AND ( dba_name != '' ) " +
                                                                    " order by dba_name";
                    break;
                case 1: // Airline Buying Rate			: '3' in Oiginal table
					cmdCustomer.CommandText = @"
																	SELECT	dba_name,
																				carrier_code as org_account_number 
																	  FROM	organization 
																	WHERE	elt_account_number = " + elt_account_number + 
																"	AND ( dba_name != '' ) " +
																"	AND ( is_carrier = 'Y' ) " +
																" order by dba_name";
					break;
                case 2: // Agent Buying Rate			: '1' in Oiginal table
                    cmdCustomer.CommandText = @"
																	SELECT	dba_name,
																				org_account_number 
																	  FROM	organization 
																	WHERE	elt_account_number = " + elt_account_number +
                                                                           "	AND ( dba_name != '' ) " +
                                                                           "	AND ( is_agent = 'Y' ) " +
                                                                           " order by dba_name";
                    break;
				case 3 : // IATA Rate						: '5' in Oiginal table
					cmdCustomer.CommandText = @"
																	SELECT	dba_name,
																				carrier_code as org_account_number
																	  FROM	organization 
																	WHERE	elt_account_number = " + elt_account_number + 
																	"	AND ( dba_name != '' ) " +
																	"	AND ( is_carrier = 'Y' ) " +
																	" order by dba_name";
					break;

			}


			SqlDataAdapter Adap = new SqlDataAdapter();
			DataSet tmpDs = new DataSet();
				
			Con.Open();

			Adap.SelectCommand = cmdCustomer;
			Adap.Fill(tmpDs, "Customer");

			cmdCustomer.CommandText = "select * from port where elt_account_number=" + elt_account_number + " order by port_code";
			Adap.SelectCommand = cmdCustomer;
			Adap.Fill(tmpDs, "Port");

			cmdCustomer.CommandText = @"
																	SELECT	dba_name +' - '+ isnull(carrier_id,'') as dba_name,
																				carrier_code 
																	  FROM	organization 
																	WHERE	elt_account_number = " + elt_account_number + 
																	"	AND ( dba_name != '' ) " +
																	"	AND ( is_carrier = 'Y' ) " +
																	"	AND ( carrier_code <> '' ) " +
																	" order by dba_name";
			Adap.SelectCommand = cmdCustomer;
			Adap.Fill(tmpDs, "Airline");


			Con.Close();

			UltraWebGrid1.Bands[0].Columns.FromKey("Company Name").Type=ColumnType.DropDownList;
			UltraWebGrid1.Bands[0].Columns.FromKey("Company Name").ValueList.DataSource =  tmpDs.Tables["Customer"];
			UltraWebGrid1.Bands[0].Columns.FromKey("Company Name").ValueList.DisplayMember= tmpDs.Tables["Customer"].Columns["dba_name"].ToString();
			UltraWebGrid1.Bands[0].Columns.FromKey("Company Name").ValueList.ValueMember = tmpDs.Tables["Customer"].Columns["org_account_number"].ToString();
			UltraWebGrid1.Bands[0].Columns.FromKey("Company Name").ValueList.DataBind();
            UltraWebGrid1.Bands[0].Columns.FromKey("Company Name").ValueList.Style.Font.Name = "Tahoma";
            UltraWebGrid1.Bands[0].Columns.FromKey("Company Name").ValueList.ValueListItems.Insert(0, "","Select One");

            UltraWebGrid1.Bands[0].Columns.FromKey("Origin").Type = ColumnType.DropDownList;
			UltraWebGrid1.Bands[0].Columns.FromKey("Origin").ValueList.DataSource =  tmpDs.Tables["Port"];
			UltraWebGrid1.Bands[0].Columns.FromKey("Origin").ValueList.DisplayMember= tmpDs.Tables["Port"].Columns["port_code"].ToString();
			UltraWebGrid1.Bands[0].Columns.FromKey("Origin").ValueList.ValueMember = tmpDs.Tables["Port"].Columns["port_code"].ToString();
			UltraWebGrid1.Bands[0].Columns.FromKey("Origin").ValueList.DataBind();
            UltraWebGrid1.Bands[0].Columns.FromKey("Origin").ValueList.Style.Font.Name = "Tahoma";
            

			UltraWebGrid1.Bands[0].Columns.FromKey("Destination").Type=ColumnType.DropDownList;
			UltraWebGrid1.Bands[0].Columns.FromKey("Destination").ValueList.DataSource =  tmpDs.Tables["Port"];
			UltraWebGrid1.Bands[0].Columns.FromKey("Destination").ValueList.DisplayMember= tmpDs.Tables["Port"].Columns["port_code"].ToString();
			UltraWebGrid1.Bands[0].Columns.FromKey("Destination").ValueList.ValueMember = tmpDs.Tables["Port"].Columns["port_code"].ToString();
			UltraWebGrid1.Bands[0].Columns.FromKey("Destination").ValueList.DataBind();
            UltraWebGrid1.Bands[0].Columns.FromKey("Destination").ValueList.Style.Font.Name = "Tahoma";

			UltraWebGrid1.Bands[0].Columns.FromKey("Kg/Lb").Type=ColumnType.DropDownList;
			UltraWebGrid1.Bands[0].Columns.FromKey("Kg/Lb").ValueList.ValueListItems.Add(new ValueListItem());
			UltraWebGrid1.Bands[0].Columns.FromKey("Kg/Lb").ValueList.ValueListItems.Add(new ValueListItem());
			UltraWebGrid1.Bands[0].Columns.FromKey("Kg/Lb").ValueList.ValueListItems[0].DisplayText="LB";
			UltraWebGrid1.Bands[0].Columns.FromKey("Kg/Lb").ValueList.ValueListItems[0].DataValue="L";
			UltraWebGrid1.Bands[0].Columns.FromKey("Kg/Lb").ValueList.ValueListItems[1].DisplayText="KG";
			UltraWebGrid1.Bands[0].Columns.FromKey("Kg/Lb").ValueList.ValueListItems[1].DataValue="K";
            UltraWebGrid1.Bands[0].Columns.FromKey("Kg/Lb").ValueList.Style.Font.Name = "Tahoma";


			WebPercentEdit1.Visible = true;
			WebNumericEdit1.Visible = true;
            WebNumericEdit2.Visible = true;

			UltraWebGrid1.Bands[1].Columns.FromKey("Share").Type=ColumnType.Custom;
			UltraWebGrid1.Bands[1].Columns.FromKey("Share").EditorControlID="WebPercentEdit1";

			for(int i=2;i<10;i++)
			{
				string key = "R"+i.ToString();
				UltraWebGrid1.Bands[0].Columns.FromKey(key).Type=ColumnType.Custom;
                UltraWebGrid1.Bands[0].Columns.FromKey(key).EditorControlID = "WebNumericEdit2";
			}

			for(int i=2;i<10;i++)
			{
				string key = "R"+i.ToString();
				UltraWebGrid1.Bands[1].Columns.FromKey(key).Type=ColumnType.Custom;
				UltraWebGrid1.Bands[1].Columns.FromKey(key).EditorControlID="WebNumericEdit1";
			}

			UltraWebGrid1.Bands[1].Columns.FromKey("R0").Type=ColumnType.Custom;
			UltraWebGrid1.Bands[1].Columns.FromKey("R0").EditorControlID="WebNumericEdit1";


			UltraWebGrid1.Bands[1].Columns.FromKey("Airline").Type=ColumnType.DropDownList;
			UltraWebGrid1.Bands[1].Columns.FromKey("Airline").ValueList.DataSource =  tmpDs.Tables["Airline"];
			UltraWebGrid1.Bands[1].Columns.FromKey("Airline").ValueList.DisplayMember= tmpDs.Tables["Airline"].Columns["dba_name"].ToString();

			UltraWebGrid1.Bands[1].Columns.FromKey("Airline").ValueList.ValueMember = tmpDs.Tables["Airline"].Columns["carrier_code"].ToString();
			UltraWebGrid1.Bands[1].Columns.FromKey("Airline").ValueList.DataBind();
			UltraWebGrid1.Bands[1].Columns.FromKey("Airline").ValueList.ValueListItems.Insert(0,"-1","All");
            UltraWebGrid1.Bands[1].Columns.FromKey("Airline").ValueList.Style.Font.Name = "Tahoma";

            
		}
		protected void btnNew_Click(object sender, System.EventArgs e)
		{
			lblError.Text = "";
			UltraWebGrid1.ResetColumns();
			UltraWebGrid1.ResetBands();			
			PerformSearchNew();
			PerformDataBind();
		}

        protected void btnSave_Click(object sender, ImageClickEventArgs e)
        {
            lblError.Text = "";
            if (!PerformDataCheck())
            {
                this.UltraWebGrid1.ExpandAll();
                return;
            }

            if (PerformSave())
            {
                lblError.Text = "Data was saved successfully.";
                PerformSearch();
                PerformDataBind();
                this.UltraWebGrid1.ExpandAll();
                string sUrl = "/IFF_MAIN/ASPX/OnLines/Rate/RateManagement.aspx?ff=" + ComboBox1.SelectedValue + "&nn=" + ComboBox1.Text;
                PerformRecentDB(sUrl, ComboBox1.Text, "Change AE Rate", "MD->AE Rate");
            }
        }

        private void PerformRecentDB(string sURL, string DocNum, string WorkDetail, string strSoTitle)
        {
            string SQL = "insert INTO Recent_Work ( elt_account_number, user_id, workdate, title, docnum, surl, workdetail,remark,status ) ";
            SQL =
            SQL + " VALUES (" + elt_account_number + ", '" + user_id + "', '" + getDateTime() + "', N'" + strSoTitle + "',N'" + DocNum + "' ,'" + sURL + "' ,N'" + WorkDetail + "','','')";

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

        private bool PerformDataCheck()
		{
			int iCnt =0;
			string strCommandText = null;

			SqlConnection Con = new SqlConnection(ConnectStr);
			SqlCommand Cmd = new SqlCommand();
			Cmd.Connection = Con;
            int iR = DropDownList1.SelectedIndex;


			foreach( UltraGridRow eRow in UltraWebGrid1.Rows )
			{

				if( eRow.Cells.FromKey("a").Text == null && eRow.Cells.FromKey("e").Text == null) continue;
                if (this.DropDownList1.SelectedIndex == 0 || this.DropDownList1.SelectedIndex == 2)  
				{
                    if (eRow.Cells.FromKey("Code").Text == null || eRow.Cells.FromKey("Code").Text == "Select One")
                    {
                        lblError.Text = "Please input the Company name."; return false;
                    }
				}

				if( eRow.Cells.FromKey("Origin").Text == null || eRow.Cells.FromKey("Origin").Text =="Dbl Click...") {lblError.Text = "Please input the origin."; return false;}
				if( eRow.Cells.FromKey("Destination").Text == null || eRow.Cells.FromKey("Origin").Text =="Dbl Click...") {lblError.Text = "Please input the destination."; return false;}
				if( eRow.Cells.FromKey("Kg/Lb").Text == null || eRow.Cells.FromKey("Origin").Text =="Dbl Click...") {lblError.Text = "Please input the Kg/Lb."; return false;}
				
				int iChk = 0;

				for(int i=0;i<eRow.Rows.Count;i++)
				{

					if( eRow.Rows[i].Cells.FromKey("a").Text == null) continue;
					if( eRow.Rows[i].Cells.FromKey("Airline").Text == null || eRow.Rows[i].Cells.FromKey("Airline").Text == "Dbl Click...") continue;

					iChk++;
					switch (iR)  
					{
						case 2 : // Agent Buying Rate			: '1' in Oiginal table
							strCommandText =	"	SELECT	 * FROM all_rate_table WHERE   elt_account_number = " + elt_account_number +
								"	AND  agent_no=N'" + eRow.Cells.FromKey("Code").Text +"'" +
								"	AND  origin_port=N'" + eRow.Cells.FromKey("Origin").Text  + "'" +
								"	AND  dest_port=N'" + eRow.Cells.FromKey("Destination").Text  + "'" +
								"	AND  kg_lb=N'" + eRow.Cells.FromKey("Kg/Lb").Value.ToString()  + "'" +
								"	AND  airline=N'" + eRow.Rows[i].Cells.FromKey("Airline").Value.ToString() + "'" +
								"	AND rate_type='1'";
							break;
						case 1 : // Airline Buying Rate			: '3' in Oiginal table
							strCommandText =	"	SELECT	 * FROM all_rate_table WHERE   elt_account_number = " + elt_account_number +
								"	AND  origin_port=N'" + eRow.Cells.FromKey("Origin").Text  + "'" +
								"	AND  dest_port=N'" + eRow.Cells.FromKey("Destination").Text  + "'" +
								"	AND  kg_lb=N'" + eRow.Cells.FromKey("Kg/Lb").Value.ToString()  + "'" +
								"	AND  airline=N'" + eRow.Rows[i].Cells.FromKey("Airline").Value.ToString() + "'" +
								"	AND rate_type='3'";
							break;
						case 0 : // Customer Selling Rate	: '4' in Oiginal table
							strCommandText =	"	SELECT	 * FROM all_rate_table WHERE   elt_account_number = " + elt_account_number +
								"	AND  customer_no=N'" + eRow.Cells.FromKey("Code").Text +"'" +
								"	AND  origin_port=N'" + eRow.Cells.FromKey("Origin").Text  + "'" +
								"	AND  dest_port=N'" + eRow.Cells.FromKey("Destination").Text  + "'" +
								"	AND  kg_lb=N'" + eRow.Cells.FromKey("Kg/Lb").Value.ToString()  + "'" +
								"	AND  airline=N'" + eRow.Rows[i].Cells.FromKey("Airline").Value.ToString() + "'" +
								"	AND rate_type='4'";
							break;
						case 3 : // IATA Rate						: '5' in Oiginal table
							strCommandText =	"	SELECT	 * FROM all_rate_table WHERE   elt_account_number = " + elt_account_number +
								"	AND  origin_port=N'" + eRow.Cells.FromKey("Origin").Text  + "'" +
								"	AND  dest_port=N'" + eRow.Cells.FromKey("Destination").Text  + "'" +
								"	AND  kg_lb=N'" + eRow.Cells.FromKey("Kg/Lb").Value.ToString()  + "'" +
								"	AND  airline=N'" + eRow.Rows[i].Cells.FromKey("Airline").Value.ToString() + "'" +
								"	AND rate_type='5'";
							break;
					}
					
					Con.Open();			

					Cmd.CommandText= strCommandText;
					SqlDataReader reader = Cmd.ExecuteReader();			
					
					if(reader.Read()) 
					{
						reader.Close();
						Con.Close();				

						string script = "<script language='javascript'> alert('";
						script += eRow.Cells.FromKey("Company Name").Text + ":" + eRow.Cells.FromKey("Origin").Text + "->" + eRow.Cells.FromKey("Destination").Text +"(";
						script += eRow.Cells.FromKey("Kg/Lb").Text + "):" + eRow.Rows[i].Cells.FromKey("Airline").Text;
						script += " : This record already exists!');";
						script += "</script>";
                        this.ClientScript.RegisterStartupScript(this.GetType(), "Pre", script); 

						return false;
					}
					else
					{
						reader.Close();
						Con.Close();				
					}
				}

			}

			Con.Close();
			

			foreach( UltraGridRow eRow in UltraWebGrid1.Rows )
			{
				if( eRow.Cells.FromKey("e").Text == null ) continue;
				for(int i=0;i<eRow.Rows.Count;i++)
				{
                    if (eRow.Rows[i].Cells.FromKey("Airline").Text == null || eRow.Rows[i].Cells.FromKey("Airline").Text == "Dbl Click...") continue;
					iCnt++;
				}
			}

			string [] Array_keyCol			= new string[iCnt];
			string tmpKey = null;
			
			foreach( UltraGridRow eRow in UltraWebGrid1.Rows )
			{
				if( eRow.Cells.FromKey("e").Text == null ) continue;
				for(int i=0;i<eRow.Rows.Count;i++)
				{		
                    if( eRow.Rows[i].Cells.FromKey("Airline").Text == null || eRow.Rows[i].Cells.FromKey("Airline").Text == "Dbl Click...") continue;
						tmpKey = 
						eRow.Cells.FromKey("Code").Text + eRow.Cells.FromKey("Origin").Text + eRow.Cells.FromKey("Destination").Text + eRow.Cells.FromKey("Kg/Lb").Text + eRow.Rows[i].Cells.FromKey("Airline").Text;
					for(int j=0;j<Array_keyCol.Length;j++)
					{
						if(Array_keyCol[j] == null ) continue;
						if(Array_keyCol[j] == tmpKey)
						{
							string script = "<script language='javascript'> alert('";
							script += eRow.Cells.FromKey("Company Name").Text + ":" + eRow.Cells.FromKey("Origin").Text + "->" + eRow.Cells.FromKey("Destination").Text +"(";
							script += eRow.Cells.FromKey("Kg/Lb").Text + "):" + eRow.Rows[i].Cells.FromKey("Airline").Text;
							script += " : This record is duplicated!');";
							script += "</script>";
							this.ClientScript.RegisterStartupScript(this.GetType(), "Pre", script);
							return false;
						}						
					}
					Array_keyCol[i] = tmpKey;
				}

			}

			foreach( UltraGridRow eRow in UltraWebGrid1.Rows )
			{
				if( eRow.Cells.FromKey("e").Text == null  && eRow.Cells.FromKey("a").Text == null ) continue;

				for(int i=0;i<eRow.Rows.Count;i++)
				{

					string [] Array_R = new string[10] { null,null,null,null,null,null,null,null,null,null };
					string tmpR = null;

					for(int j=0;j<10;j++)
					{
						string key = "R"+j.ToString();
						if( eRow.Cells.FromKey(key).Text == null || eRow.Cells.FromKey(key).Text == "") continue;

						tmpR = eRow.Cells.FromKey(key).Text;

						for(int k=0;k<Array_R.Length;k++)
						{
							if(Array_R[k] == null ) continue;
							if(Array_R[k] == tmpR)	
							{
								string script = "<script language='javascript'> alert('";
								script += eRow.Cells.FromKey("Company Name").Text + ":" + eRow.Cells.FromKey("Origin").Text + "->" + eRow.Cells.FromKey("Destination").Text +"(";
								script += eRow.Cells.FromKey("Kg/Lb").Text + "):" + "Weight Break ->" + tmpR + " : " ;
								script += " : You can enter the unique weight break per one route. ');";
								script += "</script>";
								this.ClientScript.RegisterStartupScript(this.GetType(), "Pre", script);
								return false;
							}
						}
						Array_R[j] = tmpR;
					}
				}
			}

			return true;

		}

		protected void btnDelete_Click(object sender, System.EventArgs e)
		{
		}

		private bool PerformSave() 
		{

			int iCnt = 0;

			#region 
            foreach (UltraGridRow eRow in UltraWebGrid1.Rows)
            {

                for (int i = 0; i < eRow.Rows.Count; i++)
                {
                    if (eRow.Rows[i].Cells.FromKey("Airline").Text == null || eRow.Rows[i].Cells.FromKey("Airline").Text == "Dbl Click..." ) continue;
                    for (int j = 0; j < 10; j++)
                    {
                        string key = "R" + j.ToString();
                        if (eRow.Cells.FromKey(key).Text != null && eRow.Cells.FromKey(key).Text != "")
                        {
                             iCnt++;
                        }
                    }
                    iCnt++;
                }
            }

           
			string [] Array_rate_type		= new string[iCnt];
			string [] Array_item_no			= new string[iCnt];
			string [] Array_agent_no			= new string[iCnt];
			string [] Array_customer_no	= new string[iCnt];
			string [] Array_airline				= new string[iCnt];
			string [] Array_origin_port		= new string[iCnt];
			string [] Array_dest_port			= new string[iCnt];
			string [] Array_weight_break	= new string[iCnt];
			string [] Array_rate				= new string[iCnt];
			string [] Array_kg_lb				= new string[iCnt];
			string [] Array_share				= new string[iCnt];
			string [] Array_DeleFlag			= new string[iCnt];

			#endregion// Array

            int iR = int.Parse(txtSavedRateType.Text);
			iCnt = 0;

			foreach( UltraGridRow eRow in UltraWebGrid1.Rows )
			{

				for(int i=0;i<eRow.Rows.Count;i++)
				{
                    if (eRow.Rows[i].Cells.FromKey("Airline").Text == null || eRow.Rows[i].Cells.FromKey("Airline").Text == "Dbl Click...") continue;
					int iItem_no = 0;
					for(int j=0;j<10;j++)
					{
						string key = "R"+j.ToString();
                        if ((eRow.Cells.FromKey(key).Text != null && eRow.Cells.FromKey(key).Text != "") || j == 0 || j == 1)
						{
							if(j == 0) 
							{
                                if (eRow.Rows[i].Cells.FromKey(key).Text == null || eRow.Rows[i].Cells.FromKey(key).Text == "")
                                {
                                    eRow.Rows[i].Cells.FromKey(key).Text = "0";
                                }
								Array_weight_break[iCnt] = "0";
							}
                            else if (j == 1)
                            {
                                if (eRow.Rows[i].Cells.FromKey(key).Text == null || eRow.Rows[i].Cells.FromKey(key).Text == "")
                                {
                                    eRow.Rows[i].Cells.FromKey(key).Text = "0";
                                }
                                Array_weight_break[iCnt] = "1";
                            }
                            else
							{
								Array_weight_break[iCnt] = eRow.Cells.FromKey(key).Text;
							}
                            if (eRow.Rows[i].Cells.FromKey(key).Value == null)
                                eRow.Rows[i].Cells.FromKey(key).Value = 0;
							Array_rate[iCnt]				=	eRow.Rows[i].Cells.FromKey(key).Value.ToString();

                            Array_airline[iCnt] = eRow.Rows[i].Cells.FromKey("Airline").Text;

							Array_share[iCnt]				=	eRow.Rows[i].Cells.FromKey("Share").Text;
							Array_origin_port[iCnt]		    =	eRow.Cells.FromKey("Origin").Text;
							Array_dest_port[iCnt]			=	eRow.Cells.FromKey("Destination").Text;
							Array_kg_lb[iCnt]				=	eRow.Cells.FromKey("Kg/Lb").Value.ToString();

							switch (iR)  
							{
                                case 0: // Customer Selling Rate	: '4' in Oiginal table
                                    Array_rate_type[iCnt] = "4";
                                    //									Array_agent_no[iCnt] = "0";
                                    Array_customer_no[iCnt] = eRow.Cells.FromKey("Code").Text;
                                    break;
                                case 1: // Airline Buying Rate			: '3' in Oiginal table
									Array_rate_type[iCnt] = "3";
									Array_agent_no[iCnt] = "0";
									Array_customer_no[iCnt]	= "0";
									break;
                                case 2: // Agent Buying Rate			: '1' in Oiginal table
                                    Array_rate_type[iCnt] = "1";
                                    Array_agent_no[iCnt] = eRow.Cells.FromKey("Code").Text;
                                    //									Array_customer_no[iCnt]	= "0";
                                    break;
								case 3 : // IATA Rate						: '5' in Oiginal table
									Array_rate_type[iCnt] = "5";
									Array_agent_no[iCnt] = "0";
									Array_customer_no[iCnt]	= "0";
									break;
							}

							Array_DeleFlag[iCnt]			=	eRow.Rows[i].Cells.FromKey("x").Text;
							Array_item_no[iCnt]			=  iItem_no.ToString();

							iItem_no++;
							iCnt++;
						}
					}
				}
			} // fore each



			string strInsert= @" INSERT INTO ALL_RATE_TABLE 
													(
														elt_account_number,
														item_no,
														rate_type,
														agent_no,
														customer_no,
														airline,
														origin_port,
														dest_port,
														weight_break,
														rate,
														kg_lb,
														share	
													)
											VALUES 
														(
														@elt_account_number,
														@item_no,
														@rate_type,
														@agent_no,
														@customer_no,
														@airline,
														@origin_port,
														@dest_port,
														@weight_break,
														@rate,
														@kg_lb,
														@share	
													)";

			SqlConnection	Con = new SqlConnection(ConnectStr);
			SqlCommand		Cmd = new SqlCommand();
			Cmd.Connection = Con;

			Con.Open();			

			SqlTransaction trans = Con.BeginTransaction();

			Cmd.Transaction = trans;

			try
			{

                Cmd.CommandText = "DELETE all_rate_table  WHERE  elt_account_number=" + elt_account_number;
                switch (iR)
                {
                    #region // delete
                    case 0: // Customer Selling Rate	: '4' in Oiginal table
                        Cmd.CommandText = Cmd.CommandText +
                            " AND rate_type=4 ";
                        if (this.txtSavedOrg.Text != "")
                        {
                            Cmd.CommandText = Cmd.CommandText + " AND customer_no=" + this.txtSavedOrg.Text;
                        }
                        break;
                    case 1: // Airline Buying Rate			: '3' in Oiginal table
                        Cmd.CommandText = Cmd.CommandText +
                            " AND rate_type=3 AND agent_no=0 AND customer_no=0";
                        break;
                    case 2: // Agent Buying Rate			: '1' in Oiginal table
                        Cmd.CommandText = Cmd.CommandText +
                            " AND rate_type=1 ";
                        if (this.txtSavedOrg.Text != "")
                        {
                            Cmd.CommandText = Cmd.CommandText + " AND agent_no=" + this.txtSavedOrg.Text;
                        }
                        break;
                    case 3: // IATA Rate						: '5' in Oiginal table
                        Cmd.CommandText = Cmd.CommandText +
                            " AND rate_type=5 AND agent_no=0 AND customer_no=0";
                        break;
                    default:
                        break;
                    #endregion
                }

                Cmd.ExecuteNonQuery();

				for(int i=0;i<iCnt;i++)
				{
					Cmd.CommandText = strInsert;
					Cmd.Parameters.Clear();					
					switch (iR)  
					{
							#region // insert
                        case 0: // Customer Selling Rate	: '4' in Oiginal table
                            Cmd.Parameters.Add("@elt_account_number", SqlDbType.Decimal, 9).Value = elt_account_number;
                            Cmd.Parameters.Add("@item_no", SqlDbType.Decimal, 9).Value = int.Parse(Array_item_no[i]);
                            Cmd.Parameters.Add("@rate_type", SqlDbType.Decimal, 9).Value = 4;
                            Cmd.Parameters.Add("@agent_no", SqlDbType.Decimal, 4).Value = System.DBNull.Value;
                            Cmd.Parameters.Add("@customer_no", SqlDbType.Decimal, 4).Value = int.Parse(Array_customer_no[i]);
                            Cmd.Parameters.Add("@airline", SqlDbType.NVarChar, 8).Value = (Array_airline[i] == null ? "" : Array_airline[i]);
                            Cmd.Parameters.Add("@origin_port", SqlDbType.NVarChar, 8).Value = (Array_origin_port[i] == null ? "" : Array_origin_port[i]);
                            Cmd.Parameters.Add("@dest_port", SqlDbType.NVarChar, 8).Value = (Array_dest_port[i] == null ? "" : Array_dest_port[i]);
                            break;
						case 1 : // Airline Buying Rate			: '3' in Oiginal table
							Cmd.Parameters.Add("@elt_account_number", SqlDbType.Decimal,9).Value = elt_account_number;
							Cmd.Parameters.Add("@item_no", SqlDbType.Decimal,9).Value = int.Parse(Array_item_no[i]);
							Cmd.Parameters.Add("@rate_type", SqlDbType.Decimal,9).Value = 3;
							Cmd.Parameters.Add("@agent_no", SqlDbType.Decimal, 4).Value = 0;
							Cmd.Parameters.Add("@customer_no", SqlDbType.Decimal, 4).Value = 0;
							Cmd.Parameters.Add("@airline", SqlDbType.NVarChar, 8).Value = (Array_airline[i] == null ? "" : Array_airline[i]);
							Cmd.Parameters.Add("@origin_port", SqlDbType.NVarChar, 8).Value = (Array_origin_port[i] == null ? "" : Array_origin_port[i]);
							Cmd.Parameters.Add("@dest_port", SqlDbType.NVarChar, 8).Value = (Array_dest_port[i] == null ? "" : Array_dest_port[i]);
							break;
                        case 2: // Agent Buying Rate			: '1' in Oiginal table
                            Cmd.Parameters.Add("@elt_account_number", SqlDbType.Decimal, 9).Value = elt_account_number;
                            Cmd.Parameters.Add("@item_no", SqlDbType.Decimal, 9).Value = int.Parse(Array_item_no[i]);
                            Cmd.Parameters.Add("@rate_type", SqlDbType.Decimal, 9).Value = 1;
                            Cmd.Parameters.Add("@agent_no", SqlDbType.Decimal, 4).Value = int.Parse((Array_agent_no[i] == null ? "" : Array_agent_no[i]));
                            Cmd.Parameters.Add("@customer_no", SqlDbType.Decimal, 4).Value = System.DBNull.Value;
                            Cmd.Parameters.Add("@airline", SqlDbType.NVarChar, 8).Value = (Array_airline[i] == null ? "" : Array_airline[i]);
                            Cmd.Parameters.Add("@origin_port", SqlDbType.NVarChar, 8).Value = (Array_origin_port[i] == null ? "" : Array_origin_port[i]);
                            Cmd.Parameters.Add("@dest_port", SqlDbType.NVarChar, 8).Value = (Array_dest_port[i] == null ? "" : Array_dest_port[i]);
                            break;
						case 3 : // IATA Rate						: '5' in Oiginal table
							Cmd.Parameters.Add("@elt_account_number", SqlDbType.Decimal,9).Value = elt_account_number;
							Cmd.Parameters.Add("@item_no", SqlDbType.Decimal,9).Value = int.Parse(Array_item_no[i]);
							Cmd.Parameters.Add("@rate_type", SqlDbType.Decimal,9).Value = 5;
							Cmd.Parameters.Add("@agent_no", SqlDbType.Decimal, 4).Value = 0;
							Cmd.Parameters.Add("@customer_no", SqlDbType.Decimal, 4).Value = 0;
							Cmd.Parameters.Add("@airline", SqlDbType.NVarChar, 8).Value = (Array_airline[i] == null ? "" : Array_airline[i]);
							Cmd.Parameters.Add("@origin_port", SqlDbType.NVarChar, 8).Value = (Array_origin_port[i] == null ? "" : Array_origin_port[i]);
							Cmd.Parameters.Add("@dest_port", SqlDbType.NVarChar, 8).Value = (Array_dest_port[i] == null ? "" : Array_dest_port[i]);
							break;
							#endregion
					}
                    if ( Array_rate[i] != null ) 
                    { 
					Cmd.Parameters.Add("@weight_break", SqlDbType.Decimal, 9).Value = double.Parse((Array_weight_break[i] == null ? "0" : Array_weight_break[i]));
					Cmd.Parameters.Add("@rate", SqlDbType.Decimal, 9).Value = double.Parse((Array_rate[i] == null ? "0" : Array_rate[i]));
					Cmd.Parameters.Add("@kg_lb", SqlDbType.NChar, 1).Value = (Array_kg_lb[i] == null ? "" : Array_kg_lb[i]);
					Cmd.Parameters.Add("@share", SqlDbType.Decimal, 9).Value = double.Parse((Array_share[i] == null ? "0" : Array_share[i]));

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

			lblError.Text = "Data was saved successfully.";
			return true;
		}

        protected void UltraWebGrid1_InitializeLayout1(object sender, LayoutEventArgs e)
        {
            e.Layout.SelectTypeColDefault = SelectType.Single;
            e.Layout.SelectTypeRowDefault = SelectType.Extended;

            e.Layout.ViewType = ViewType.Hierarchical;
            e.Layout.TableLayout = TableLayout.Fixed;
            e.Layout.RowStyleDefault.BorderDetails.ColorTop = Color.Gray;

            for (int i = 0; i < UltraWebGrid1.Bands.Count; i++)
            {
                for (int j = 0; j < UltraWebGrid1.Bands[i].Columns.Count; j++)
                {
                    if (UltraWebGrid1.DisplayLayout.Bands[i].Columns[j].BaseColumnName != "Chk")
                    {
                        UltraWebGrid1.DisplayLayout.Bands[i].Columns[j].SelectedCellStyle.BackColor = Color.Yellow;
                        UltraWebGrid1.DisplayLayout.Bands[i].Columns[j].SelectedCellStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Text;
                    }
                }
            }

            UltraWebGrid1.DisplayLayout.SelectedHeaderStyleDefault.BackColor = Color.Red;
            UltraWebGrid1.DisplayLayout.SelectTypeCellDefault = Infragistics.WebUI.UltraWebGrid.SelectType.Single;
            UltraWebGrid1.DisplayLayout.AllowColSizingDefault = Infragistics.WebUI.UltraWebGrid.AllowSizing.Free;
            // New Box

            //set cursor 
            UltraWebGrid1.DisplayLayout.FrameStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Default;
            UltraWebGrid1.DisplayLayout.Bands[0].HeaderStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Default;
            UltraWebGrid1.DisplayLayout.SelectedHeaderStyleDefault.BackColor = Color.Red;
            UltraWebGrid1.Bands[0].DataKeyField = ds.Tables[ParentTable].Columns[keyColName].ColumnName;
            UltraWebGrid1.Bands[1].DataKeyField = ds.Tables[ChildTable].Columns[keyColName].ColumnName;

            // ********************************************************************************************************** //
            e.Layout.Bands[0].Columns.FromKey(keyColName).Hidden = true;
            e.Layout.Bands[1].Columns.FromKey(keyColName).Hidden = true;
            e.Layout.Bands[0].Columns.FromKey("Code").Hidden = true;
            e.Layout.Bands[1].Columns.FromKey("Company Name").Hidden = true;
   
            e.Layout.Bands[0].Columns.FromKey("a").Hidden = true;
            e.Layout.Bands[0].Columns.FromKey("e").Hidden = true;
            e.Layout.Bands[0].Columns.FromKey("x").Hidden = true;
            //
            e.Layout.Bands[1].Columns.FromKey("a").Hidden = true;
            e.Layout.Bands[1].Columns.FromKey("e").Hidden = true;
            e.Layout.Bands[1].Columns.FromKey("x").Hidden = true;

            e.Layout.Bands[1].Columns.FromKey("item_no").Hidden = true;
            this.UltraWebGrid1.DisplayLayout.RowSelectorsDefault = Infragistics.WebUI.UltraWebGrid.RowSelectors.No;
            e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.BackgroundImage = "../../../Images/mark_o.gif";
            e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.HorizontalAlign = HorizontalAlign.Center;
            e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.CustomRules = "background-position:center ;background-repeat:no-repeat";
            e.Layout.Bands[0].Columns.FromKey("Chk").Header.Caption = "";
            e.Layout.Bands[0].Columns.FromKey("Chk").Width = new Unit("40px");
            e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.BackColor = Color.FromArgb(204, 235, 237);
            e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Hand;
            e.Layout.Bands[0].Columns.FromKey("Chk").AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No;
            e.Layout.Bands[0].AddButtonCaption = "";

            e.Layout.Bands[0].Columns.Insert(0,"Add");
            e.Layout.Bands[0].Columns.FromKey("Add").Header.Caption = "";
            e.Layout.Bands[0].Columns.FromKey("Add").Width = new Unit("40px");
            e.Layout.Bands[0].Columns.FromKey("Add").CellStyle.BackgroundImage = "../../../Images/button_add.gif";
            e.Layout.Bands[0].Columns.FromKey("Add").CellStyle.HorizontalAlign = HorizontalAlign.Center;
            e.Layout.Bands[0].Columns.FromKey("Add").CellStyle.CustomRules = "background-position:center ;background-repeat:no-repeat";
            e.Layout.Bands[0].Columns.FromKey("Add").CellStyle.BackColor = Color.FromArgb(204, 235, 237);
            e.Layout.Bands[0].Columns.FromKey("Add").AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No;
            e.Layout.Bands[0].Columns.FromKey("Add").CellStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Hand;

            e.Layout.Bands[1].Columns.Insert(0, "Add");
            e.Layout.Bands[1].Columns.FromKey("Add").Header.Caption = "";
            e.Layout.Bands[1].Columns.FromKey("Add").Width = new Unit("40px");
            e.Layout.Bands[1].Columns.FromKey("Add").CellStyle.BackColor = Color.FromArgb(204, 235, 237);
            e.Layout.Bands[1].Columns.FromKey("Add").AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No;
            e.Layout.Bands[1].Columns.FromKey("Add").CellStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Hand;

            e.Layout.Bands[0].Columns.FromKey("Company Name").Width = new Unit("150px");
            e.Layout.Bands[0].Columns.FromKey("Origin").Width = new Unit("50px");
            e.Layout.Bands[0].Columns.FromKey("Destination").Width = new Unit("50px");
            e.Layout.Bands[0].Columns.FromKey("Destination").Header.Caption = "Dest.";
            e.Layout.Bands[0].Columns.FromKey("Kg/Lb").Width = new Unit("50px");

            e.Layout.Bands[0].Columns.FromKey("Company Name").CellStyle.ForeColor = Color.Navy;
            e.Layout.Bands[0].Columns.FromKey("Origin").CellStyle.ForeColor = Color.Navy;
            e.Layout.Bands[0].Columns.FromKey("Destination").CellStyle.ForeColor = Color.Navy;
            e.Layout.Bands[0].Columns.FromKey("Kg/Lb").CellStyle.ForeColor = Color.Navy;

            e.Layout.Bands[1].Columns.FromKey("Airline").Width = new Unit("278px");

            e.Layout.Bands[0].Columns.FromKey("a").Width = new Unit("12px");
            e.Layout.Bands[0].Columns.FromKey("e").Width = new Unit("12px");
            e.Layout.Bands[0].Columns.FromKey("x").Width = new Unit("12px");
            e.Layout.Bands[1].Columns.FromKey("a").Width = new Unit("12px");
            e.Layout.Bands[1].Columns.FromKey("e").Width = new Unit("12px");
            e.Layout.Bands[1].Columns.FromKey("x").Width = new Unit("12px");

            e.Layout.Bands[0].Columns.FromKey("a").CellStyle.HorizontalAlign = HorizontalAlign.Center;
            e.Layout.Bands[0].Columns.FromKey("e").CellStyle.HorizontalAlign = HorizontalAlign.Center;
            e.Layout.Bands[0].Columns.FromKey("x").CellStyle.HorizontalAlign = HorizontalAlign.Center;
            e.Layout.Bands[1].Columns.FromKey("a").CellStyle.HorizontalAlign = HorizontalAlign.Center;
            e.Layout.Bands[1].Columns.FromKey("e").CellStyle.HorizontalAlign = HorizontalAlign.Center;
            e.Layout.Bands[1].Columns.FromKey("x").CellStyle.HorizontalAlign = HorizontalAlign.Center;

            e.Layout.Bands[0].Columns.FromKey("a").Header.Caption = "";
            e.Layout.Bands[0].Columns.FromKey("e").Header.Caption = "";
            e.Layout.Bands[0].Columns.FromKey("x").Header.Caption = "";

            e.Layout.Bands[0].Columns.FromKey("a").Header.Style.BackgroundImage = "../../../Images/mark_n.gif";
            e.Layout.Bands[0].Columns.FromKey("a").Header.Style.CustomRules = "background-position:center ;background-repeat:no-repeat";
            e.Layout.Bands[0].Columns.FromKey("e").Header.Style.BackgroundImage = "../../../Images/mark_e.gif";
            e.Layout.Bands[0].Columns.FromKey("e").Header.Style.CustomRules = "background-position:center ;background-repeat:no-repeat";
            e.Layout.Bands[0].Columns.FromKey("x").Header.Style.BackgroundImage = "../../../Images/mark_x.gif";
            e.Layout.Bands[0].Columns.FromKey("x").Header.Style.CustomRules = "background-position:center ;background-repeat:no-repeat";

            e.Layout.Bands[1].Columns.FromKey("a").Header.Caption = "";
            e.Layout.Bands[1].Columns.FromKey("e").Header.Caption = "";
            e.Layout.Bands[1].Columns.FromKey("x").Header.Caption = "";

            e.Layout.Bands[1].Columns.FromKey("Chk").CellStyle.BackgroundImage = "../../../Images/mark_o.gif";
            e.Layout.Bands[1].Columns.FromKey("Chk").CellStyle.HorizontalAlign = HorizontalAlign.Center;
            e.Layout.Bands[1].Columns.FromKey("Chk").CellStyle.CustomRules = "background-position:center ;background-repeat:no-repeat";
            e.Layout.Bands[1].Columns.FromKey("Chk").Header.Caption = "";
            e.Layout.Bands[1].Columns.FromKey("Chk").Width = new Unit("40px");
            e.Layout.Bands[1].Columns.FromKey("Chk").CellStyle.BackColor = Color.FromArgb(204, 235, 237);
            e.Layout.Bands[1].Columns.FromKey("Chk").CellStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Hand;
            e.Layout.Bands[1].Columns.FromKey("Chk").AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No;

            e.Layout.Bands[0].Columns.FromKey("R0").AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No;
            e.Layout.Bands[0].Columns.FromKey("R1").AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No;
            e.Layout.Bands[0].Columns.FromKey("Blank").AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No;
            e.Layout.Bands[0].Columns.FromKey("Blank").Header.Caption = "";
            e.Layout.Bands[0].Columns.FromKey("Blank").CellStyle.HorizontalAlign = HorizontalAlign.Center;

            e.Layout.Bands[1].AddButtonCaption = "";

            for (int i = 0; i < 10; i++)
            {
                string key = "R" + i.ToString();
                string keyC = "WT BRK" + i.ToString();
                if (i == 0)
                {
                    keyC = "MIN.";      
                }
                else if (i == 1)
                {
                    keyC = "+MIN.";
                }
                else if (i == 2)
                {
                    keyC = "WT BRK";
                }
                else
                {
                    keyC = "";

                }

                e.Layout.Bands[0].Columns.FromKey(key).Header.Caption = keyC;
                e.Layout.Bands[0].Columns.FromKey(key).Header.Style.BackgroundImage = "";
                e.Layout.Bands[0].Columns.FromKey(key).Header.Style.CustomRules = "background-position:center; background-repeat:no-repeat";
                e.Layout.Bands[0].Columns.FromKey(key).Width = new Unit("47px");
                e.Layout.Bands[0].Columns.FromKey(key).CellStyle.HorizontalAlign = HorizontalAlign.Right;

                e.Layout.Bands[0].Columns.FromKey(key).CellStyle.BackColor = Color.WhiteSmoke;
                e.Layout.Bands[0].Columns.FromKey(key).CellStyle.BorderStyle = BorderStyle.Solid;
                e.Layout.Bands[0].Columns.FromKey(key).CellStyle.BorderColor = Color.Silver;
                e.Layout.Bands[0].Columns.FromKey(key).CellStyle.ForeColor = Color.Navy;

            }
            e.Layout.Bands[0].Columns.FromKey("R0").CellStyle.BackColor = Color.Lavender;
            e.Layout.Bands[0].Columns.FromKey("R1").CellStyle.BackColor = Color.Lavender;
            e.Layout.Bands[0].Columns.FromKey("Blank").CellStyle.BackColor = Color.FromArgb(204, 235, 237);

            for (int i = 0; i < 10; i++)
            {
                string key = "R" + i.ToString();
                e.Layout.Bands[1].Columns.FromKey(key).Header.Caption = "";
                e.Layout.Bands[1].Columns.FromKey(key).Header.Style.BackgroundImage = "";
                e.Layout.Bands[1].Columns.FromKey(key).Header.Style.CustomRules = "background-position:center; background-repeat:no-repeat";
                e.Layout.Bands[1].Columns.FromKey(key).Width = new Unit("47px");
                e.Layout.Bands[1].Columns.FromKey(key).CellStyle.HorizontalAlign = HorizontalAlign.Right;

                e.Layout.Bands[1].Columns.FromKey(key).CellStyle.BorderStyle = BorderStyle.Solid;
                e.Layout.Bands[1].Columns.FromKey(key).CellStyle.BorderColor = Color.Red;
                e.Layout.Bands[1].Columns.FromKey(key).CellStyle.BorderStyle = BorderStyle.Solid;
                e.Layout.Bands[1].Columns.FromKey(key).CellStyle.BorderColor = Color.Red;
                e.Layout.Bands[1].Columns.FromKey(key).CellStyle.BorderDetails.WidthTop = new Unit(0.5);
                e.Layout.Bands[1].Columns.FromKey(key).CellStyle.BorderDetails.WidthLeft = new Unit(0.5);
            }

            e.Layout.Bands[1].Columns.FromKey("Airline").CellStyle.BorderStyle = BorderStyle.Solid;
            e.Layout.Bands[1].Columns.FromKey("Airline").CellStyle.BorderColor = Color.Red;
            e.Layout.Bands[1].Columns.FromKey("Airline").CellStyle.BorderDetails.WidthTop = new Unit(0.5);
            e.Layout.Bands[1].Columns.FromKey("Airline").CellStyle.BorderDetails.WidthLeft = new Unit(0.5);

            e.Layout.Bands[0].Columns.FromKey("Blank").Width = new Unit("50px");
            e.Layout.Bands[1].Columns.FromKey("Share").Width = new Unit("50px");
            e.Layout.Bands[1].Columns.FromKey("Share").CellStyle.HorizontalAlign = HorizontalAlign.Right;
            e.Layout.Bands[1].Columns.FromKey("Share").CellStyle.BorderStyle = BorderStyle.Solid;
            e.Layout.Bands[1].Columns.FromKey("Share").CellStyle.BorderColor = Color.Red;
            e.Layout.Bands[1].Columns.FromKey("Share").CellStyle.BorderDetails.WidthTop = new Unit(0.5);
            e.Layout.Bands[1].Columns.FromKey("Share").CellStyle.BorderDetails.WidthLeft = new Unit(0.5);
            e.Layout.Bands[1].Columns.FromKey("Share").CellStyle.BorderDetails.ColorTop = Color.Red;

            e.Layout.Bands[0].Columns.FromKey("a").AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No;
            e.Layout.Bands[0].Columns.FromKey("e").AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No;
            e.Layout.Bands[0].Columns.FromKey("x").AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No;
            e.Layout.Bands[1].Columns.FromKey("a").AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No;
            e.Layout.Bands[1].Columns.FromKey("e").AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No;
            e.Layout.Bands[1].Columns.FromKey("x").AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No;

            if ((DropDownList1.SelectedIndex == 1) || (DropDownList1.SelectedIndex == 3))
            {
                e.Layout.Bands[0].Columns.FromKey("Company Name").AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No;
            }
            else
            {
                e.Layout.Bands[0].Columns.FromKey("Company Name").AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.Yes;
            }

            e.Layout.Bands[1].Columns.FromKey("Airline").Header.Caption = "";
            e.Layout.Bands[1].Columns.FromKey("Share").Header.Caption = "";

            if (this.DropDownList1.SelectedIndex == 1 || this.DropDownList1.SelectedIndex == 3)
            {
                e.Layout.Bands[0].Columns.FromKey("Company Name").Hidden = true;
                e.Layout.Bands[1].Columns.FromKey("Airline").Width = new Unit("128px");
            }


        }
        protected void UltraWebGrid1_InitializeRow1(object sender, RowEventArgs e)
        {
            if (e.Row.Band.BaseTableName == ChildTable)
            {
                if (e.Row.Cells.FromKey("a").Text == "a")
                {
                    e.Row.Cells.FromKey("a").Style.BackColor = Color.LightGreen;
                }
            }
            else
            {
                if (e.Row.Cells.FromKey("a").Text == "a")
                {
                    e.Row.Cells.FromKey("a").Style.BackColor = Color.LightGreen;
                }

                e.Row.Cells.FromKey("Blank").Text = "Share";
                e.Row.Cells.FromKey("Company Name").Style.BackColor = Color.Lavender;
                e.Row.Cells.FromKey("Origin").Style.BackColor = Color.Lavender;
                e.Row.Cells.FromKey("Destination").Style.BackColor = Color.Lavender;
                e.Row.Cells.FromKey("Kg/Lb").Style.BackColor = Color.Lavender;

            }

        }
        protected void UltraWebGrid1_PageIndexChanged1(object sender, Infragistics.WebUI.UltraWebGrid.PageEventArgs e)
        {
            UltraWebGrid1.DisplayLayout.Pager.CurrentPageIndex = e.NewPageIndex;
            PerformSearch();
            PerformDataBind();
        }
        protected void ImageButton1_Click1(object sender, ImageClickEventArgs e)
        {
            //UltraWebToolbar1.Visible = true;
            UltraWebGrid1.Visible = true;
            lblError.Text = "";
            UltraWebGrid1.ResetColumns();
            UltraWebGrid1.ResetBands();
            PerformSearch();
            PerformDataBind();
            this.UltraWebGrid1.ExpandAll(true);
            this.txtSavedOrg.Text = this.ComboBox1.SelectedValue.ToString();
            this.txtSavedRateType.Text = this.DropDownList1.SelectedIndex.ToString();
            this.Panel1.Visible = true;
        }
        protected void btnExcelExport_Click(object sender, ImageClickEventArgs e)
        {
            this.UltraWebGridExcelExporter1.DownloadName = "rates.xls";
            this.UltraWebGridExcelExporter1.Export(this.UltraWebGrid1);
        }
        
}
}
























