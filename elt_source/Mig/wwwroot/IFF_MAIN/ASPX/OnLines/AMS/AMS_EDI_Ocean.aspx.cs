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

namespace IFF_MAIN.ASPX.OnLines.AMS
{
	/// <summary>
	/// AMS_EDI_Ocean에 대한 요약 설명입니다.
	/// </summary>
	public partial class  AMS_EDI_Ocean : System.Web.UI.Page
	{

//***************************************************************//

		string ParentTable="ig_ocean_ams_edi_header";
		string ChildTable="ig_ocean_ams_edi_item";
		string keyColName="doc_number";
		public string elt_account_number;
		protected DataSet ds = new DataSet();

//***************************************************************//

		public string login_name;

		private void Page_Load(object sender, System.EventArgs e)
		{
			Session.LCID = 1033;
            elt_account_number = "80002000";
            login_name = "admin";
		
			if(!IsPostBack)	
			{
				ViewState["Count"]= 1;
				PerformDefault();

				if(Request.QueryString["number"] !=null)
				{
					txt_doc_number.Text = Request.QueryString["number"].ToString();
					PerformRemoteEdit();
				}
				else
				{
					LoadData();
				}


			}
			else
			{
				ViewState["Count"] = (int)ViewState["Count"] + 1;
			}
		}


		private void PerformRemoteEdit()
		{

			PerformDataEdit();			

		}

		private void LoadData()
		{
			PerformGridStruc(0);
			PerformDataBind();
			DoData();
		}

		private void PerformGridStruc(int iNumber)
		{
			// Gathering the Data			
            string ConnectStr = (new igFunctions.DB().getConStr());
			SqlConnection Con = new SqlConnection(ConnectStr);

			string strcmdAmsItem = @"						SELECT 
																						i1_item_number, 
																						i2_quantity, 
																						i3_net_weight, 
																						i4_volume, 
																						i5_package_type, 
																						i6_comodity_code, 
																						i7_cash_value, 
																						e1_equipment_number, 
																						e2_seal_number1, 
																						e3_seal_number2, 
																						e4_length, 
																						e5_width, 
																						e6_height, 
																						e7_iso_equipment, 
																						e8_type_of_service, 
																						e9_loaded_empty_total, 
																						e10_equipment_desc_code, 
																						d1_line_of_description, 
																						m1_line_of_marks_and_numbers, 
																						h1_hazard_code, 
																						h2_hazard_class, 
																						h3_hazard_description, 
																						h4_hazard_contact, 
																						h5_un_page_number, 
																						h6_flashpoint_temperature, 
																						h7_hazard_code_qualifier, 
																						h8_hazard_unit_of_measure, 
																						h9_negative_indigator, 
																						h10_hazard_label, 
																						h11_hazard_classification 
																			FROM	ig_ocean_ams_edi_item" +
																		 " WHERE	elt_account_number=" + elt_account_number+ " and doc_number=" + iNumber.ToString();

			SqlCommand cmdAmsItem = new SqlCommand(strcmdAmsItem,Con);

			SqlDataAdapter Adap = new SqlDataAdapter();

			Con.Open();
			
			Adap.SelectCommand = cmdAmsItem;
			Adap.Fill(ds, ChildTable);

			Con.Close();

			UltraWebGrid1.DataSource=ds.Tables[ChildTable].DefaultView;

		}
		private void PerformDataBind()
		{		

			UltraWebGrid1.DataBind();
		}

		private void DoData()
		{

			UltraWebGrid1.Bands[0].Columns.FromKey("e9_loaded_empty_total").Type=ColumnType.DropDownList;
			UltraWebGrid1.Bands[0].Columns.FromKey("e9_loaded_empty_total").ValueList.ValueListItems.Add(new ValueListItem());
			UltraWebGrid1.Bands[0].Columns.FromKey("e9_loaded_empty_total").ValueList.ValueListItems.Add(new ValueListItem());
			UltraWebGrid1.Bands[0].Columns.FromKey("e9_loaded_empty_total").ValueList.ValueListItems.Add(new ValueListItem());
			UltraWebGrid1.Bands[0].Columns.FromKey("e9_loaded_empty_total").ValueList.ValueListItems.Add(new ValueListItem());
			UltraWebGrid1.Bands[0].Columns.FromKey("e9_loaded_empty_total").ValueList.ValueListItems[0].DisplayText=" ";
			UltraWebGrid1.Bands[0].Columns.FromKey("e9_loaded_empty_total").ValueList.ValueListItems[0].DataValue=" ";
			UltraWebGrid1.Bands[0].Columns.FromKey("e9_loaded_empty_total").ValueList.ValueListItems[1].DisplayText="Loaded";
			UltraWebGrid1.Bands[0].Columns.FromKey("e9_loaded_empty_total").ValueList.ValueListItems[1].DataValue="L";
			UltraWebGrid1.Bands[0].Columns.FromKey("e9_loaded_empty_total").ValueList.ValueListItems[2].DisplayText="Empty";
			UltraWebGrid1.Bands[0].Columns.FromKey("e9_loaded_empty_total").ValueList.ValueListItems[2].DataValue="E";
			UltraWebGrid1.Bands[0].Columns.FromKey("e9_loaded_empty_total").ValueList.ValueListItems[3].DisplayText="Total";
			UltraWebGrid1.Bands[0].Columns.FromKey("e9_loaded_empty_total").ValueList.ValueListItems[3].DataValue="T";

			UltraWebGrid1.Bands[0].Columns.FromKey("h9_negative_indigator").Type=ColumnType.DropDownList;
			UltraWebGrid1.Bands[0].Columns.FromKey("h9_negative_indigator").ValueList.ValueListItems.Add(new ValueListItem());
			UltraWebGrid1.Bands[0].Columns.FromKey("h9_negative_indigator").ValueList.ValueListItems.Add(new ValueListItem());
			UltraWebGrid1.Bands[0].Columns.FromKey("h9_negative_indigator").ValueList.ValueListItems.Add(new ValueListItem());
			UltraWebGrid1.Bands[0].Columns.FromKey("h9_negative_indigator").ValueList.ValueListItems[0].DisplayText=" ";
			UltraWebGrid1.Bands[0].Columns.FromKey("h9_negative_indigator").ValueList.ValueListItems[0].DataValue=" ";
			UltraWebGrid1.Bands[0].Columns.FromKey("h9_negative_indigator").ValueList.ValueListItems[1].DisplayText="Y";
			UltraWebGrid1.Bands[0].Columns.FromKey("h9_negative_indigator").ValueList.ValueListItems[1].DataValue="Y";
			UltraWebGrid1.Bands[0].Columns.FromKey("h9_negative_indigator").ValueList.ValueListItems[2].DisplayText="N";
			UltraWebGrid1.Bands[0].Columns.FromKey("h9_negative_indigator").ValueList.ValueListItems[2].DataValue="N";

			WebNumericEdit1.Visible = true;

			UltraWebGrid1.Bands[0].Columns.FromKey("i2_quantity").Type=ColumnType.Custom;
			UltraWebGrid1.Bands[0].Columns.FromKey("i2_quantity").EditorControlID="WebNumericEdit1";

			UltraWebGrid1.Bands[0].Columns.FromKey("i3_net_weight").Type=ColumnType.Custom;
			UltraWebGrid1.Bands[0].Columns.FromKey("i3_net_weight").EditorControlID="WebNumericEdit1";

			UltraWebGrid1.Bands[0].Columns.FromKey("i4_volume").Type=ColumnType.Custom;
			UltraWebGrid1.Bands[0].Columns.FromKey("i4_volume").EditorControlID="WebNumericEdit1";

			UltraWebGrid1.Bands[0].Columns.FromKey("i4_volume").Type=ColumnType.Custom;
			UltraWebGrid1.Bands[0].Columns.FromKey("i4_volume").EditorControlID="WebNumericEdit1";

			UltraWebGrid1.Bands[0].Columns.FromKey("i7_cash_value").Type=ColumnType.Custom;
			UltraWebGrid1.Bands[0].Columns.FromKey("i7_cash_value").EditorControlID="WebNumericEdit1";

			UltraWebGrid1.Bands[0].Columns.FromKey("e4_length").Type=ColumnType.Custom;
			UltraWebGrid1.Bands[0].Columns.FromKey("e4_length").EditorControlID="WebNumericEdit1";

//			UltraWebGrid1.Bands[1].Columns.FromKey("Airline").Type=ColumnType.DropDownList;
//			UltraWebGrid1.Bands[1].Columns.FromKey("Airline").ValueList.DataSource =  tmpDs.Tables["Airline"];
//			UltraWebGrid1.Bands[1].Columns.FromKey("Airline").ValueList.DisplayMember= tmpDs.Tables["Airline"].Columns["dba_name"].ToString();
//			UltraWebGrid1.Bands[1].Columns.FromKey("Airline").ValueList.ValueMember = tmpDs.Tables["Airline"].Columns["carrier_code"].ToString();
//			UltraWebGrid1.Bands[1].Columns.FromKey("Airline").ValueList.DataBind();
//			UltraWebGrid1.Bands[1].Columns.FromKey("Airline").ValueList.ValueListItems.Insert(0,"-1","All");

		}


		private void PerformDefault()
		{
			lblTask.Text = "Creation";
			PerformSelectionDataBinding();
			PerformMode(0,true);
		}

		private void PerformSelectionDataBinding()
		{

			btnSearch.Attributes.Add("onclick","return searchOption();");
			btnValidation.Attributes.Add("onclick","return dataValidation();");
			btnAMS_Send.Attributes.Add("onclick","return dataValidation(1);");
			performSetDropDownList("dl_p1_port_of_discharge",true);
			performSetDropDownList("dl_v6_first_us_port_of_discharge",true);

			performSetDropDownList("dl_b5_b_lading_status_code",false);
			performSetDropDownList("dl_b20_weight_unit",false);

			performSetDropDownListCountry("dl_v5_vessel_flag");
			performSetDropDownListCountry("dl_s8_shipper_iso_country_code");

			perform_US_state("dl_c5_consignee_state_province");
			perform_US_state("dl_n5_notify_state_province");
			

		}

		private void perform_US_state(string strFieldName)
		{
			#region // Set Unite State
			
			DropDownList dl_state = (DropDownList)UltraWebTab1.FindControl(strFieldName);

			for(int i=0;i<52;i++)
			{
				dl_state.Items.Add("");
			}
			dl_state.Items[0].Value = "  ";		dl_state.Items[0].Text = "                  ";
			dl_state.Items[1].Value = "AK";	dl_state.Items[1].Text = "Alaska";
			dl_state.Items[2].Value = "AL";	dl_state.Items[2].Text = "Alabama";
			dl_state.Items[3].Value = "AR";	dl_state.Items[3].Text = "Arkansas";
			dl_state.Items[4].Value = "AZ";	dl_state.Items[4].Text = "Arizona";
			dl_state.Items[5].Value = "CA";	dl_state.Items[5].Text = "California";
			dl_state.Items[6].Value = "CO";	dl_state.Items[6].Text = "Colorado";
			dl_state.Items[7].Value = "CT";	dl_state.Items[7].Text = "Connecticut";
			dl_state.Items[8].Value = "DC";	dl_state.Items[8].Text = "DC";
			dl_state.Items[9].Value = "DE";	dl_state.Items[9].Text = "Delaware";
			dl_state.Items[10].Value = "FL";	dl_state.Items[10].Text = "Florida";
			dl_state.Items[11].Value = "GA";	dl_state.Items[11].Text = "Georgia";
			dl_state.Items[12].Value = "HI";	dl_state.Items[12].Text = "Hawaii";
			dl_state.Items[13].Value = "IA";	dl_state.Items[13].Text = "Iowa";
			dl_state.Items[14].Value = "ID";	dl_state.Items[14].Text = "Idaho";
			dl_state.Items[15].Value = "IL";	dl_state.Items[15].Text = "Illinois";
			dl_state.Items[16].Value = "IN";	dl_state.Items[16].Text = "Indiana";
			dl_state.Items[17].Value = "KS";	dl_state.Items[17].Text = "Kansas";
			dl_state.Items[18].Value = "KY";	dl_state.Items[18].Text = "Kentucky";
			dl_state.Items[19].Value = "LA";	dl_state.Items[19].Text = "Louisiana";
			dl_state.Items[20].Value = "MA";	dl_state.Items[20].Text = "Massachusetts";
			dl_state.Items[21].Value = "MD"; dl_state.Items[21].Text = "Maryland";
			dl_state.Items[22].Value = "ME";	dl_state.Items[22].Text = "Maine";
			dl_state.Items[23].Value = "MI";	dl_state.Items[23].Text = "Michigan";
			dl_state.Items[24].Value = "MN";	dl_state.Items[24].Text = "Minnesota";
			dl_state.Items[25].Value = "MO";	dl_state.Items[25].Text = "Missouri";
			dl_state.Items[26].Value = "MS";	dl_state.Items[26].Text = "Mississippi";
			dl_state.Items[27].Value = "MT";	dl_state.Items[27].Text = "Montana";
			dl_state.Items[28].Value = "NC";	dl_state.Items[28].Text = "North Carolina";
			dl_state.Items[29].Value = "ND";	dl_state.Items[29].Text = "North Dakota";
			dl_state.Items[30].Value = "NE";	dl_state.Items[30].Text = "Nebraska";
			dl_state.Items[31].Value = "NH";	dl_state.Items[31].Text = "New Hampshire";
			dl_state.Items[32].Value = "NJ";	dl_state.Items[32].Text = "New Jersey";
			dl_state.Items[33].Value = "NM";	dl_state.Items[33].Text = "New Mexico";
			dl_state.Items[34].Value = "NV";	dl_state.Items[34].Text = "Nevada";
			dl_state.Items[35].Value = "NY";	dl_state.Items[35].Text = "New York";
			dl_state.Items[36].Value = "OH";	dl_state.Items[36].Text = "Ohio";
			dl_state.Items[37].Value = "OK";	dl_state.Items[37].Text = "Oklahoma";
			dl_state.Items[38].Value = "OR";	dl_state.Items[38].Text = "Oregon";
			dl_state.Items[39].Value = "PA";	dl_state.Items[39].Text = "Pennsylvania";
			dl_state.Items[40].Value = "RI";	dl_state.Items[40].Text = "Rhode Island";
			dl_state.Items[41].Value = "SC";	dl_state.Items[41].Text = "South Carolina";
			dl_state.Items[42].Value = "SD";	dl_state.Items[42].Text = "South Dakota";
			dl_state.Items[43].Value = "TN";	dl_state.Items[43].Text = "Tennessee";
			dl_state.Items[44].Value = "TX";	dl_state.Items[44].Text = "Texas";
			dl_state.Items[45].Value = "UT";	dl_state.Items[45].Text = "Utah";
			dl_state.Items[46].Value = "VA";	dl_state.Items[46].Text = "Virginia";
			dl_state.Items[47].Value = "VT";	dl_state.Items[47].Text = "Vermont";
			dl_state.Items[48].Value = "WA";	dl_state.Items[48].Text = "Washington";
			dl_state.Items[49].Value = "WI";	dl_state.Items[49].Text = "Wisconsin";
			dl_state.Items[50].Value = "WV"; dl_state.Items[50].Text = "West Virginia";
			dl_state.Items[51].Value = "WY"; dl_state.Items[51].Text = "Wyoming";

			dl_state.SelectedIndex = 0;
			#endregion

			dl_state.Attributes.Add("onchange",  "Javascript:setState(this);");

		}
		private void performSetDropDownListCountry(string strFieldName)
		{

            string ConnectStr = (new igFunctions.DB().getConStr());
			DropDownList dl_country = (DropDownList)UltraWebTab1.FindControl(strFieldName);
			 

			SqlConnection Con = new SqlConnection(ConnectStr);
			SqlCommand cmdCustomer = new SqlCommand();
			cmdCustomer.Connection = Con;

			SqlCommand cmd= new SqlCommand("SELECT * from country_code order by country_name",Con);

			SqlDataAdapter Adap = new SqlDataAdapter();
			DataSet tmpDs = new DataSet();
				
			Con.Open();

			Adap.SelectCommand = cmd;
			Adap.Fill(tmpDs, "Country");

			Con.Close();
		
			dl_country.DataSource =  tmpDs.Tables["Country"];
			dl_country.DataTextField = tmpDs.Tables["Country"].Columns["country_name"].ToString();
			dl_country.DataValueField = tmpDs.Tables["Country"].Columns["country_code"].ToString();
			dl_country.DataBind();
			dl_country.Items.Insert(0,"");
			dl_country.SelectedIndex = 0;

			dl_country.Attributes.Add("onchange",  "Javascript:setCountry(this);");
	


		}

		private void performSetDropDownList(string strFieldName,bool a)
		{
			#region 
			
			DropDownList dlPort = (DropDownList)UltraWebTab1.FindControl(strFieldName);
			 

			if (a)
			{
				for(int i=0;i<140;i++)
				{
					dlPort.Items.Add("");
				}

				dlPort.Items[0].Value = "   ";		dlPort.Items[0].Text= "                     ";
				dlPort.Items[1].Value= "0101 ";	dlPort.Items[1].Text= "PORTLAND,ME ";
				dlPort.Items[2].Value= "0103 ";	dlPort.Items[2].Text= "EASTPORT,ME ";
				dlPort.Items[3].Value= "0131 ";	dlPort.Items[3].Text= "PORTSMOUTH,NH ";
				dlPort.Items[4].Value= "0132 ";	dlPort.Items[4].Text= "BELFAST,ME ";
				dlPort.Items[5].Value= "0152 ";	dlPort.Items[5].Text= "SEARSPORT,ME ";
				dlPort.Items[6].Value= "0401 ";	dlPort.Items[6].Text= "BOSTON,MA ";
				dlPort.Items[7].Value= "0404 ";	dlPort.Items[7].Text= "GLOUCESTER,MA ";
				dlPort.Items[8].Value= "0406 ";	dlPort.Items[8].Text= "PLYMOUTH,MA ";
				dlPort.Items[9].Value= "0407 ";	dlPort.Items[9].Text= "FALL RIVER,MA ";
				dlPort.Items[10].Value= "0408 ";	dlPort.Items[10].Text= "SALEM,MA ";
				dlPort.Items[11].Value= "0410 ";	dlPort.Items[11].Text= "BRIDGEPORT,CT ";
				dlPort.Items[12].Value= "0412 ";	dlPort.Items[12].Text= "NEW HAVEN,CT ";
				dlPort.Items[13].Value= "0413 ";	dlPort.Items[13].Text= "NEW LONDON,CT ";
				dlPort.Items[14].Value= "0501 ";	dlPort.Items[14].Text= "NEWPORT,RI ";
				dlPort.Items[15].Value= "0502 ";	dlPort.Items[15].Text= "PROVIDENCE,RI ";
				dlPort.Items[16].Value= "0503 ";	dlPort.Items[16].Text= "MELVILLE,RI ";
				dlPort.Items[17].Value= "0701 ";	dlPort.Items[17].Text= "OGDENSBURG,NY ";
				dlPort.Items[18].Value= "0901 ";	dlPort.Items[18].Text= "BUFFALO-NIAGARA FALLS,NY ";
				dlPort.Items[19].Value= "0904 ";	dlPort.Items[19].Text= "OSWEGO,NY ";
				dlPort.Items[20].Value= "1001 ";	dlPort.Items[20].Text= "NEW YORK, NY ";
				dlPort.Items[21].Value= "1002 ";	dlPort.Items[21].Text= "ALBANY, NY ";
				dlPort.Items[22].Value= "1101 ";	dlPort.Items[22].Text= "PHILADELPHIA,PA ";
				dlPort.Items[23].Value= "1102 ";	dlPort.Items[23].Text= "CHESTER,PA ";
				dlPort.Items[24].Value= "1103 ";	dlPort.Items[24].Text= "WILMINGTON,DE ";
				dlPort.Items[25].Value= "1105 ";	dlPort.Items[25].Text= "PAULSBORO,PA ";
				dlPort.Items[26].Value= "1107 ";	dlPort.Items[26].Text= "CAMDEN,NJ ";
				dlPort.Items[27].Value= "1303 ";	dlPort.Items[27].Text= "BALTIMORE,MD ";
				dlPort.Items[28].Value= "1401 ";	dlPort.Items[28].Text= "NORFOLK,VA ";
				dlPort.Items[29].Value= "1402 ";	dlPort.Items[29].Text= "NEWPORT NEWS,VA ";
				dlPort.Items[30].Value= "1404 ";	dlPort.Items[30].Text= "RICHMOND-PETERSBURG,VA ";
				dlPort.Items[31].Value= "1501 ";	dlPort.Items[31].Text= "WILMINGTON,NC ";
				dlPort.Items[32].Value= "1511 ";	dlPort.Items[32].Text= "BEAUFORT-MOREHEAD CITY,NC ";
				dlPort.Items[33].Value= "1601 ";	dlPort.Items[33].Text= "CHARLESTON,SC ";
				dlPort.Items[34].Value= "1602 ";	dlPort.Items[34].Text= "GEORGETOWN,SC ";
				dlPort.Items[35].Value= "1701 ";	dlPort.Items[35].Text= "BRUNSWICK,GA ";
				dlPort.Items[36].Value= "1703 ";	dlPort.Items[36].Text= "SAVANNAH,GA ";
				dlPort.Items[37].Value= "1801 ";	dlPort.Items[37].Text= "TAMPA,FL ";
				dlPort.Items[38].Value= "1803 ";	dlPort.Items[38].Text= "JACKSONVILLE,FL ";
				dlPort.Items[39].Value= "1805 ";	dlPort.Items[39].Text= "FERNANDINA BEACH, FL ";
				dlPort.Items[40].Value= "1816 ";	dlPort.Items[40].Text= "PORT CANAVERAL,FL ";
				dlPort.Items[41].Value= "1818 ";	dlPort.Items[41].Text= "PANAMA CITY,FL ";
				dlPort.Items[42].Value= "1821 ";	dlPort.Items[42].Text= "PORT MANATEE,FL ";
				dlPort.Items[43].Value= "1901 ";	dlPort.Items[43].Text= "MOBILE,AL ";
				dlPort.Items[44].Value= "1902 ";	dlPort.Items[44].Text= "GULFPORT,MS ";
				dlPort.Items[45].Value= "1903 ";	dlPort.Items[45].Text= "PASCAGOULA,MS ";
				dlPort.Items[46].Value= "2001 ";	dlPort.Items[46].Text= "MORGAN CITY,LA ";
				dlPort.Items[47].Value= "2002 ";	dlPort.Items[47].Text= "NEW ORLEANS,LA ";
				dlPort.Items[48].Value= "2004 ";	dlPort.Items[48].Text= "BATON ROUGE,LA ";
				dlPort.Items[49].Value= "2005 ";	dlPort.Items[49].Text= "PORT SULPHUR,LA ";
				dlPort.Items[50].Value= "2009 ";	dlPort.Items[50].Text= "DESTREHAN,LA ";
				dlPort.Items[51].Value= "2010 ";	dlPort.Items[51].Text= "GRAMERCY,LA ";
				dlPort.Items[52].Value= "2012 ";	dlPort.Items[52].Text= "AVONDALE,LA ";
				dlPort.Items[53].Value= "2013 ";	dlPort.Items[53].Text= "ST. ROSE,LA ";
				dlPort.Items[54].Value= "2014 ";	dlPort.Items[54].Text= "GOOD HOPE,LA ";
				dlPort.Items[55].Value= "2017 ";	dlPort.Items[55].Text= "LAKE CHARLES,LA ";
				dlPort.Items[56].Value= "2101 ";	dlPort.Items[56].Text= "PORT ARTHUR,TX ";
				dlPort.Items[57].Value= "2102 ";	dlPort.Items[57].Text= "SABINE,TX ";
				dlPort.Items[58].Value= "2103 ";	dlPort.Items[58].Text= "ORANGE,TX ";
				dlPort.Items[59].Value= "2104 ";	dlPort.Items[59].Text= "BEAUMONT,TX ";
				dlPort.Items[60].Value= "2301 ";	dlPort.Items[60].Text= "BROWNSVILLE-CAMERON COUNTY,TX ";
				dlPort.Items[61].Value= "2501 ";	dlPort.Items[61].Text= "SAN DIEGO,CA ";
				dlPort.Items[62].Value= "2704 ";	dlPort.Items[62].Text= "LOS ANGELES,CA ";
				dlPort.Items[63].Value= "2709 ";	dlPort.Items[63].Text= "LONG BEACH,CA ";
				dlPort.Items[64].Value= "2711 ";	dlPort.Items[64].Text= "EL SEGUNDO,CA ";
				dlPort.Items[65].Value= "2713 ";	dlPort.Items[65].Text= "PORT HUENEME,CA ";
				dlPort.Items[66].Value= "2802 ";	dlPort.Items[66].Text= "EUREKA,CA ";
				dlPort.Items[67].Value= "2809 ";	dlPort.Items[67].Text= "SAN FRANCISCO,CA ";
				dlPort.Items[68].Value= "2810 ";	dlPort.Items[68].Text= "STOCKTON,CA ";
				dlPort.Items[69].Value= "2811 ";	dlPort.Items[69].Text= "OAKLAND,CA ";
				dlPort.Items[70].Value= "2812 ";	dlPort.Items[70].Text= "RICHMOND,CA ";
				dlPort.Items[71].Value= "2815 ";	dlPort.Items[71].Text= "CROCKETT,CA ";
				dlPort.Items[72].Value= "2816 ";	dlPort.Items[72].Text= "SACRAMENTO,CA ";
				dlPort.Items[73].Value= "2821 ";	dlPort.Items[73].Text= "REDWOOD CITY,CA ";
				dlPort.Items[74].Value= "2828 ";	dlPort.Items[74].Text= "SAN JOAQUIN RIVER,CA ";
				dlPort.Items[75].Value= "2830 ";	dlPort.Items[75].Text= "CARQUINEZ STRAIT,CA ";
				dlPort.Items[76].Value= "2901 ";	dlPort.Items[76].Text= "ASTORIA,OR ";
				dlPort.Items[77].Value= "2902 ";	dlPort.Items[77].Text= "NEWPORT,OR ";
				dlPort.Items[78].Value= "2903 ";	dlPort.Items[78].Text= "COOS BAY,OR ";
				dlPort.Items[79].Value= "2904 ";	dlPort.Items[79].Text= "PORTLAND,OR ";
				dlPort.Items[80].Value= "2905 ";	dlPort.Items[80].Text= "LONGVIEW,WA ";
				dlPort.Items[81].Value= "2908 ";	dlPort.Items[81].Text= "VANCOUVER,WA ";
				dlPort.Items[82].Value= "2909 ";	dlPort.Items[82].Text= "KALAMA,WA ";
				dlPort.Items[83].Value= "3001 ";	dlPort.Items[83].Text= "SEATTLE,WA ";
				dlPort.Items[84].Value= "3002 ";	dlPort.Items[84].Text= "TACOMA,WA ";
				dlPort.Items[85].Value= "3003 ";	dlPort.Items[85].Text= "ABERDEEN/HOQUIAM,WA ";
				dlPort.Items[86].Value= "3005 ";	dlPort.Items[86].Text= "BELLINGHAM,WA ";
				dlPort.Items[87].Value= "3006 ";	dlPort.Items[87].Text= "EVERETT,WA ";
				dlPort.Items[88].Value= "3007 ";	dlPort.Items[88].Text= "PORT ANGELES,WA ";
				dlPort.Items[89].Value= "3008 ";	dlPort.Items[89].Text= "PORT TOWNSEND,WA ";
				dlPort.Items[90].Value= "3010 ";	dlPort.Items[90].Text= "ANACORTES,WA ";
				dlPort.Items[91].Value= "3026 ";	dlPort.Items[91].Text= "OLYMPIA,WA ";
				dlPort.Items[92].Value= "3102 ";	dlPort.Items[92].Text= "KETCHIKAN,AK ";
				dlPort.Items[93].Value= "3107 ";	dlPort.Items[93].Text= "VALDEZ,AK ";
				dlPort.Items[94].Value= "3126 ";	dlPort.Items[94].Text= "ANCHORAGE,AK ";
				dlPort.Items[95].Value= "3127 ";	dlPort.Items[95].Text= "KODIAK,AK ";
				dlPort.Items[96].Value= "3201 ";	dlPort.Items[96].Text= "HONOLULU,HI ";
				dlPort.Items[97].Value= "3204 ";	dlPort.Items[97].Text= "NAWILIWILI-PORT ALLEN,HI ";
				dlPort.Items[98].Value= "3601 ";	dlPort.Items[98].Text= "DULUTH,MN ";
				dlPort.Items[99].Value= "3701 ";	dlPort.Items[99].Text= "MILWAUKEE,WI ";
				dlPort.Items[100].Value= "3702 ";	dlPort.Items[100].Text= "MARINETTE,WI ";
				dlPort.Items[101].Value= "3703 ";	dlPort.Items[101].Text= "GREEN BAY,WI ";
				dlPort.Items[102].Value= "3707 ";	dlPort.Items[102].Text= "SHEBOYGAN,WI ";
				dlPort.Items[103].Value= "3801 ";	dlPort.Items[103].Text= "DETROIT,MI ";
				dlPort.Items[104].Value= "3802 ";	dlPort.Items[104].Text= "PORT HURON,MI ";
				dlPort.Items[105].Value= "3803 ";	dlPort.Items[105].Text= "SAULT STE MARIE,MI ";
				dlPort.Items[106].Value= "3804 ";	dlPort.Items[106].Text= "SAGINAW/BAY CITY/FLINT,MI ";
				dlPort.Items[107].Value= "3805 ";	dlPort.Items[107].Text= "BATLE CREEK,MI ";
				dlPort.Items[108].Value= "3806 ";	dlPort.Items[108].Text= "GRAND RAPIDS,MI ";
				dlPort.Items[109].Value= "3808 ";	dlPort.Items[109].Text= "ESCANABA,MI ";
				dlPort.Items[110].Value= "3815 ";	dlPort.Items[110].Text= "MUSKEGON,MI ";
				dlPort.Items[111].Value= "3816 ";	dlPort.Items[111].Text= "GRAND HAVEN,MI ";
				dlPort.Items[112].Value= "3820 ";	dlPort.Items[112].Text= "MACKINAC ISLAND,MI ";
				dlPort.Items[113].Value= "3843 ";	dlPort.Items[113].Text= "ALPENA,MI ";
				dlPort.Items[114].Value= "3844 ";	dlPort.Items[114].Text= "FERRYSBURG,MI ";
				dlPort.Items[115].Value= "3901 ";	dlPort.Items[115].Text= "CHICAGO,IL ";
				dlPort.Items[116].Value= "3905 ";	dlPort.Items[116].Text= "GARY,IN ";
				dlPort.Items[117].Value= "4101 ";	dlPort.Items[117].Text= "CLEVELAND,OH ";
				dlPort.Items[118].Value= "4105 ";	dlPort.Items[118].Text= "TOLEDO-SANDUSKY,OH ";
				dlPort.Items[119].Value= "4106 ";	dlPort.Items[119].Text= "ERIE,PA ";
				dlPort.Items[120].Value= "4122 ";	dlPort.Items[120].Text= "ASHTABULA,OH ";
				dlPort.Items[121].Value= "4502 ";	dlPort.Items[121].Text= "ST. JOSEPH,MO ";
				dlPort.Items[122].Value= "4601 ";	dlPort.Items[122].Text= "NEWARK, NJ ";
				dlPort.Items[123].Value= "4602 ";	dlPort.Items[123].Text= "PERTH AMBOY, NJ ";
				dlPort.Items[124].Value= "4906 ";	dlPort.Items[124].Text= "HUMACAO,PR ";
				dlPort.Items[125].Value= "4907 ";	dlPort.Items[125].Text= "MAYAGUEZ,PR ";
				dlPort.Items[126].Value= "4908 ";	dlPort.Items[126].Text= "PONCE,PR ";
				dlPort.Items[127].Value= "4909 ";	dlPort.Items[127].Text= "SANJUAN,PR ";
				dlPort.Items[128].Value= "4912 ";	dlPort.Items[128].Text= "GUAYANILLA,PR ";
				dlPort.Items[129].Value= "5201 ";	dlPort.Items[129].Text= "MIAMI,FL ";
				dlPort.Items[130].Value= "5202 ";	dlPort.Items[130].Text= "KEY WEST,FL ";
				dlPort.Items[131].Value= "5203 ";	dlPort.Items[131].Text= "PORT EVERGLADES,FL ";
				dlPort.Items[132].Value= "5204 ";	dlPort.Items[132].Text= "WEST PALM BEACH,FL ";
				dlPort.Items[133].Value= "5205 ";	dlPort.Items[133].Text= "FORT PIERCE,FL ";
				dlPort.Items[134].Value= "5301 ";	dlPort.Items[134].Text= "HOUSTON,TX ";
				dlPort.Items[135].Value= "5306 ";	dlPort.Items[135].Text= "TEXAS CITY,TX ";
				dlPort.Items[136].Value= "5310 ";	dlPort.Items[136].Text= "GALVESTON,TX ";
				dlPort.Items[137].Value= "5311 ";	dlPort.Items[137].Text= "FREEPORT,TX ";
				dlPort.Items[138].Value= "5312 ";	dlPort.Items[138].Text= "CORPUS CHRISTI,TX ";
				dlPort.Items[139].Value= "5313 ";	dlPort.Items[139].Text= "PORT LAVACA,TX ";
				dlPort.SelectedIndex = 0;
			}
			#endregion

			dlPort.Attributes.Add("onchange",  "Javascript:setPort(this);");


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
			this.btnValidation.Click += new System.Web.UI.ImageClickEventHandler(this.btnValidation_Click);
			this.btnAMS_Send.Click += new System.Web.UI.ImageClickEventHandler(this.btnAMS_Send_Click);
			this.UltraWebGrid1.InitializeLayout += new Infragistics.WebUI.UltraWebGrid.InitializeLayoutEventHandler(this.UltraWebGrid1_InitializeLayout);
			this.btnNew.Click += new System.EventHandler(this.btnNew_Click);
			this.btnSave.Click += new System.EventHandler(this.btnSave_Click);
			this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
			this.btnShow.Click += new System.EventHandler(this.btnShow_Click);
			this.btnEdit.Click += new System.EventHandler(this.btnEdit_Click);
			this.btnDelete.Click += new System.EventHandler(this.btnDelete_Click);
			this.btnTmpNoDelete.Click += new System.EventHandler(this.btnTmpNoDelete_Click);
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion

		private void PerformFieldSet(bool how)
		{
			Color color = new Color();

			if(how) 
			{
				color = Color.White;
			}
			else
			{
				color = Color.Ivory;
			}

			#region FindControl

			TextBox  txt_v1_vessel_code  = (TextBox)UltraWebTab1.FindControl("txt_v1_vessel_code");
			TextBox  txt_v2_voyage_number = (TextBox)UltraWebTab1.FindControl("txt_v2_voyage_number");
			TextBox  txt_v3_vessel_name = (TextBox)UltraWebTab1.FindControl("txt_v3_vessel_name");
			TextBox  txt_v4_scac_code = (TextBox)UltraWebTab1.FindControl("txt_v4_scac_code");
			DropDownList  dl_v5_vessel_flag = (DropDownList)UltraWebTab1.FindControl("dl_v5_vessel_flag");
			TextBox  txt_v5_vessel_flag = (TextBox)UltraWebTab1.FindControl("txt_v5_vessel_flag");
			DropDownList  dl_v6_first_us_port_of_discharge = (DropDownList)UltraWebTab1.FindControl("dl_v6_first_us_port_of_discharge");
			TextBox  txt_v6_first_us_port_of_discharge = (TextBox)UltraWebTab1.FindControl("txt_v6_first_us_port_of_discharge");
			TextBox  txt_v7_last_foreign_pol_s = (TextBox)UltraWebTab1.FindControl("txt_v7_last_foreign_pol_s");
			TextBox  txt_v7_last_foreign_pol = (TextBox)UltraWebTab1.FindControl("txt_v7_last_foreign_pol");
			DropDownList  dl_p1_port_of_discharge = (DropDownList)UltraWebTab1.FindControl("dl_p1_port_of_discharge");
			TextBox  txt_p1_port_of_discharge = (TextBox)UltraWebTab1.FindControl("txt_p1_port_of_discharge");
			Infragistics.WebUI.WebDataInput.WebDateTimeEdit txt_p2_estimated_date_of_arrival = (Infragistics.WebUI.WebDataInput.WebDateTimeEdit)UltraWebTab1.FindControl("txt_p2_estimated_date_of_arrival");
			TextBox  txt_p3_terminal_operator_code_s = (TextBox)UltraWebTab1.FindControl("txt_p3_terminal_operator_code_s");
			TextBox  txt_p3_terminal_operator_code = (TextBox)UltraWebTab1.FindControl("txt_p3_terminal_operator_code");
			TextBox  txt_l1_port_of_load_s = (TextBox)UltraWebTab1.FindControl("txt_l1_port_of_load_s");
			TextBox  txt_l1_port_of_load = (TextBox)UltraWebTab1.FindControl("txt_l1_port_of_load");
			Infragistics.WebUI.WebDataInput.WebDateTimeEdit  txt_l2_load_date = (Infragistics.WebUI.WebDataInput.WebDateTimeEdit)UltraWebTab1.FindControl("txt_l2_load_date");
			Infragistics.WebUI.WebDataInput.WebDateTimeEdit  txt_l3_load_time = (Infragistics.WebUI.WebDataInput.WebDateTimeEdit)UltraWebTab1.FindControl("txt_l3_load_time");
//			TextBox  txt_creation_date = (TextBox)UltraWebTab1.FindControl("txt_creation_date");
			TextBox  txt_b1_bill_of_lading_number = (TextBox)UltraWebTab1.FindControl("txt_b1_bill_of_lading_number");
			TextBox  txt_b2_port_of_loading_s = (TextBox)UltraWebTab1.FindControl("txt_b2_port_of_loading_s");
			TextBox  txt_b2_port_of_loading = (TextBox)UltraWebTab1.FindControl("txt_b2_port_of_loading");
			TextBox  txt_b3_place_of_final_destination_s = (TextBox)UltraWebTab1.FindControl("txt_b3_place_of_final_destination_s");
			TextBox  txt_b3_place_of_final_destination = (TextBox)UltraWebTab1.FindControl("txt_b3_place_of_final_destination");
			TextBox  txt_b4_place_of_receipt = (TextBox)UltraWebTab1.FindControl("txt_b4_place_of_receipt");
			DropDownList  dl_b5_b_lading_status_code = (DropDownList)UltraWebTab1.FindControl("dl_b5_b_lading_status_code");
			TextBox  txt_b5_b_lading_status_code = (TextBox)UltraWebTab1.FindControl("txt_b5_b_lading_status_code");
			TextBox  txt_b6_b_lading_issuer_scac_code = (TextBox)UltraWebTab1.FindControl("txt_b6_b_lading_issuer_scac_code");
			TextBox  txt_b7_snp1 = (TextBox)UltraWebTab1.FindControl("txt_b7_snp1");
			TextBox  txt_b8_snp2 = (TextBox)UltraWebTab1.FindControl("txt_b8_snp2");
			TextBox  txt_b9_manifested_units = (TextBox)UltraWebTab1.FindControl("txt_b9_manifested_units");
			Infragistics.WebUI.WebDataInput.WebNumericEdit  txt_b10_total_gross_weight = (Infragistics.WebUI.WebDataInput.WebNumericEdit)UltraWebTab1.FindControl("txt_b10_total_gross_weight");
			TextBox  txt_b11_booking_number = (TextBox)UltraWebTab1.FindControl("txt_b11_booking_number");
			TextBox  txt_b12_master_ocean_bill_number = (TextBox)UltraWebTab1.FindControl("txt_b12_master_ocean_bill_number");
			TextBox  txt_b13_agency_unique_code = (TextBox)UltraWebTab1.FindControl("txt_b13_agency_unique_code");
			TextBox  txt_b14_snp3 = (TextBox)UltraWebTab1.FindControl("txt_b14_snp3");
			TextBox  txt_b15_snp4 = (TextBox)UltraWebTab1.FindControl("txt_b15_snp4");
			TextBox  txt_b16_snp5 = (TextBox)UltraWebTab1.FindControl("txt_b16_snp5");
			TextBox  txt_b17_snp6 = (TextBox)UltraWebTab1.FindControl("txt_b17_snp6");
			TextBox  txt_b18_snp7 = (TextBox)UltraWebTab1.FindControl("txt_b18_snp7");
			TextBox  txt_b19_snp8 = (TextBox)UltraWebTab1.FindControl("txt_b19_snp8");
			DropDownList  dl_b20_weight_unit = (DropDownList)UltraWebTab1.FindControl("dl_b20_weight_unit");
			TextBox  txt_b20_weight_unit = (TextBox)UltraWebTab1.FindControl("txt_b20_weight_unit");
			TextBox  txt_s1_shipper_name = (TextBox)UltraWebTab1.FindControl("txt_s1_shipper_name");
			TextBox  txt_s2_shipper_address1 = (TextBox)UltraWebTab1.FindControl("txt_s2_shipper_address1");
			TextBox  txt_s3_shipper_address2 = (TextBox)UltraWebTab1.FindControl("txt_s3_shipper_address2");
			TextBox  txt_s4_shipper_city = (TextBox)UltraWebTab1.FindControl("txt_s4_shipper_city");
			TextBox  txt_s5_shipper_state_province = (TextBox)UltraWebTab1.FindControl("txt_s5_shipper_state_province");
			TextBox  txt_s6_shipper_postal_code = (TextBox)UltraWebTab1.FindControl("txt_s6_shipper_postal_code");
			TextBox  txt_s7_shipper_telephone_fax = (TextBox)UltraWebTab1.FindControl("txt_s7_shipper_telephone_fax");
			DropDownList  dl_s8_shipper_iso_country_code = (DropDownList)UltraWebTab1.FindControl("dl_s8_shipper_iso_country_code");
			TextBox  txt_s8_shipper_iso_country_code = (TextBox)UltraWebTab1.FindControl("txt_s8_shipper_iso_country_code");
			TextBox  txt_s9_shipper_contact_name = (TextBox)UltraWebTab1.FindControl("txt_s9_shipper_contact_name");
			TextBox  txt_c1_consignee_name = (TextBox)UltraWebTab1.FindControl("txt_c1_consignee_name");
			TextBox  txt_c2_consignee_address1 = (TextBox)UltraWebTab1.FindControl("txt_c2_consignee_address1");
			TextBox  txt_c3_consignee_address2 = (TextBox)UltraWebTab1.FindControl("txt_c3_consignee_address2");
			TextBox  txt_c4_consignee_city = (TextBox)UltraWebTab1.FindControl("txt_c4_consignee_city");
			DropDownList  dl_c5_consignee_state_province = (DropDownList)UltraWebTab1.FindControl("dl_c5_consignee_state_province");
			TextBox  txt_c5_consignee_state_province = (TextBox)UltraWebTab1.FindControl("txt_c5_consignee_state_province");
			TextBox  txt_c6_consignee_postal_code = (TextBox)UltraWebTab1.FindControl("txt_c6_consignee_postal_code");
			TextBox  txt_c7_consignee_telephone_fax = (TextBox)UltraWebTab1.FindControl("txt_c7_consignee_telephone_fax");
			TextBox  txt_c8_consignee_iso_country_code = (TextBox)UltraWebTab1.FindControl("txt_c8_consignee_iso_country_code");
			TextBox  txt_c9_consignee_contact_name = (TextBox)UltraWebTab1.FindControl("txt_c9_consignee_contact_name");
			TextBox  txt_n1_notify_name = (TextBox)UltraWebTab1.FindControl("txt_n1_notify_name");
			TextBox  txt_n2_notify_address1 = (TextBox)UltraWebTab1.FindControl("txt_n2_notify_address1");
			TextBox  txt_n3_notify_address2 = (TextBox)UltraWebTab1.FindControl("txt_n3_notify_address2");
			TextBox  txt_n4_notify_city = (TextBox)UltraWebTab1.FindControl("txt_n4_notify_city");
			DropDownList  dl_n5_notify_state_province = (DropDownList)UltraWebTab1.FindControl("dl_n5_notify_state_province");
			TextBox  txt_n5_notify_state_province = (TextBox)UltraWebTab1.FindControl("txt_n5_notify_state_province");
			TextBox  txt_n6_notify_postal_code = (TextBox)UltraWebTab1.FindControl("txt_n6_notify_postal_code");
			TextBox  txt_n7_notify_telephone_fax = (TextBox)UltraWebTab1.FindControl("txt_n7_notify_telephone_fax");
			TextBox  txt_n8_notify_iso_country_code = (TextBox)UltraWebTab1.FindControl("txt_n8_notify_iso_country_code");
			TextBox  txt_n9_notify_party_contact_name = (TextBox)UltraWebTab1.FindControl("txt_n9_notify_party_contact_name");
			#endregion

			#region How
			txt_v1_vessel_code.ReadOnly = (!how);
			txt_v2_voyage_number.ReadOnly = (!how);
			txt_v3_vessel_name.ReadOnly = (!how);
			txt_v4_scac_code.ReadOnly = (!how);
			dl_v5_vessel_flag.Enabled = how;
			txt_v5_vessel_flag.ReadOnly = (!how);
			dl_v6_first_us_port_of_discharge.Enabled = how;
			txt_v6_first_us_port_of_discharge.ReadOnly = (!how);
			txt_v7_last_foreign_pol_s.ReadOnly = (!how);
			txt_v7_last_foreign_pol.ReadOnly = (!how);
			dl_p1_port_of_discharge.Enabled = how;
			txt_p1_port_of_discharge.ReadOnly = (!how);
			txt_p2_estimated_date_of_arrival.ReadOnly = (!how);
			txt_p3_terminal_operator_code_s.ReadOnly = (!how);
			txt_p3_terminal_operator_code.ReadOnly = (!how);
			txt_l1_port_of_load_s.ReadOnly = (!how);
			txt_l1_port_of_load.ReadOnly = (!how);
			txt_l2_load_date.ReadOnly = (!how);
			txt_l3_load_time.ReadOnly = (!how);
			txt_creation_date.ReadOnly = (!how);
			txt_b1_bill_of_lading_number.ReadOnly = (!how);
			txt_b2_port_of_loading_s.ReadOnly = (!how);
			txt_b2_port_of_loading.ReadOnly = (!how);
			txt_b3_place_of_final_destination_s.ReadOnly = (!how);
			txt_b3_place_of_final_destination.ReadOnly = (!how);
			txt_b4_place_of_receipt.ReadOnly = (!how);
			dl_b5_b_lading_status_code.Enabled = how;
			txt_b5_b_lading_status_code.ReadOnly = (!how);
			txt_b6_b_lading_issuer_scac_code.ReadOnly = (!how);
			txt_b7_snp1.ReadOnly = (!how);
			txt_b8_snp2.ReadOnly = (!how);
			txt_b9_manifested_units.ReadOnly = (!how);
			txt_b10_total_gross_weight.ReadOnly = (!how);
			txt_b11_booking_number.ReadOnly = (!how);
			txt_b12_master_ocean_bill_number.ReadOnly = (!how);
			txt_b13_agency_unique_code.ReadOnly = (!how);
			txt_b14_snp3.ReadOnly = (!how);
			txt_b15_snp4.ReadOnly = (!how);
			txt_b16_snp5.ReadOnly = (!how);
			txt_b17_snp6.ReadOnly = (!how);
			txt_b18_snp7.ReadOnly = (!how);
			txt_b19_snp8.ReadOnly = (!how);
			dl_b20_weight_unit.Enabled = how;
			txt_b20_weight_unit.ReadOnly = (!how);
			txt_s1_shipper_name.ReadOnly = (!how);
			txt_s2_shipper_address1.ReadOnly = (!how);
			txt_s3_shipper_address2.ReadOnly = (!how);
			txt_s4_shipper_city.ReadOnly = (!how);
			txt_s5_shipper_state_province.ReadOnly = (!how);
			txt_s6_shipper_postal_code.ReadOnly = (!how);
			txt_s7_shipper_telephone_fax.ReadOnly = (!how);
			dl_s8_shipper_iso_country_code.Enabled = how;
			txt_s8_shipper_iso_country_code.ReadOnly = (!how);
			txt_s9_shipper_contact_name.ReadOnly = (!how);
			txt_c1_consignee_name.ReadOnly = (!how);
			txt_c2_consignee_address1.ReadOnly = (!how);
			txt_c3_consignee_address2.ReadOnly = (!how);
			txt_c4_consignee_city.ReadOnly = (!how);
			dl_c5_consignee_state_province.Enabled = how;
			txt_c5_consignee_state_province.Enabled = how;
			txt_c6_consignee_postal_code.ReadOnly = (!how);
			txt_c7_consignee_telephone_fax.ReadOnly = (!how);
			txt_c8_consignee_iso_country_code.ReadOnly = (!how);
			txt_c9_consignee_contact_name.ReadOnly = (!how);
			txt_n1_notify_name.ReadOnly = (!how);
			txt_n2_notify_address1.ReadOnly = (!how);
			txt_n3_notify_address2.ReadOnly = (!how);
			txt_n4_notify_city.ReadOnly = (!how);
			dl_n5_notify_state_province.Enabled = how;
			txt_n5_notify_state_province.Enabled = how;
			txt_n6_notify_postal_code.ReadOnly = (!how);
			txt_n7_notify_telephone_fax.ReadOnly = (!how);
			txt_n8_notify_iso_country_code.ReadOnly = (!how);
			txt_n9_notify_party_contact_name.ReadOnly = (!how);
			#endregion

			if(!how)
			{
				this.UltraWebGrid1.DisplayLayout.AllowDeleteDefault = Infragistics.WebUI.UltraWebGrid.AllowDelete.No;
				this.UltraWebGrid1.DisplayLayout.AllowUpdateDefault = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No;
				this.UltraWebGrid1.DisplayLayout.AllowAddNewDefault = Infragistics.WebUI.UltraWebGrid.AllowAddNew.No;
				this.UltraWebGrid1.DisplayLayout.AddNewBox.Hidden = true;
			}
			else
			{
				this.UltraWebGrid1.DisplayLayout.AllowDeleteDefault = Infragistics.WebUI.UltraWebGrid.AllowDelete.Yes;
				this.UltraWebGrid1.DisplayLayout.AllowUpdateDefault = Infragistics.WebUI.UltraWebGrid.AllowUpdate.Yes;
				this.UltraWebGrid1.DisplayLayout.AllowAddNewDefault = Infragistics.WebUI.UltraWebGrid.AllowAddNew.Yes;
				this.UltraWebGrid1.DisplayLayout.AddNewBox.Hidden = false;
			}

			#region Color
			txt_v1_vessel_code.BackColor = color;
			txt_v2_voyage_number.BackColor = color;
			txt_v3_vessel_name.BackColor = color;
			txt_v4_scac_code.BackColor = color;
			dl_v5_vessel_flag.BackColor = color;
			txt_v5_vessel_flag.BackColor = color;
			dl_v6_first_us_port_of_discharge.BackColor = color;
			txt_v6_first_us_port_of_discharge.BackColor = color;
			txt_v7_last_foreign_pol_s.BackColor = color;
			txt_v7_last_foreign_pol.BackColor = color;
			dl_p1_port_of_discharge.BackColor = color;
			txt_p1_port_of_discharge.BackColor = color;
			txt_p2_estimated_date_of_arrival.BackColor = color;
			txt_p3_terminal_operator_code_s.BackColor = color;
			txt_p3_terminal_operator_code.BackColor = color;
			txt_l1_port_of_load_s.BackColor = color;
			txt_l1_port_of_load.BackColor = color;
			txt_l2_load_date.BackColor = color;
			txt_l3_load_time.BackColor = color;
			txt_creation_date.BackColor = color;
			txt_b1_bill_of_lading_number.BackColor = color;
			txt_b2_port_of_loading_s.BackColor = color;
			txt_b2_port_of_loading.BackColor = color;
			txt_b3_place_of_final_destination_s.BackColor = color;
			txt_b3_place_of_final_destination.BackColor = color;
			txt_b4_place_of_receipt.BackColor = color;
			dl_b5_b_lading_status_code.BackColor = color;
			txt_b5_b_lading_status_code.BackColor = color;
			txt_b6_b_lading_issuer_scac_code.BackColor = color;
			txt_b7_snp1.BackColor = color;
			txt_b8_snp2.BackColor = color;
			txt_b9_manifested_units.BackColor = color;
			txt_b10_total_gross_weight.BackColor = color;
			txt_b11_booking_number.BackColor = color;
			txt_b12_master_ocean_bill_number.BackColor = color;
			txt_b13_agency_unique_code.BackColor = color;
			txt_b14_snp3.BackColor = color;
			txt_b15_snp4.BackColor = color;
			txt_b16_snp5.BackColor = color;
			txt_b17_snp6.BackColor = color;
			txt_b18_snp7.BackColor = color;
			txt_b19_snp8.BackColor = color;
			dl_b20_weight_unit.BackColor = color;
			txt_b20_weight_unit.BackColor = color;
			txt_s1_shipper_name.BackColor = color;
			txt_s2_shipper_address1.BackColor = color;
			txt_s3_shipper_address2.BackColor = color;
			txt_s4_shipper_city.BackColor = color;
			txt_s5_shipper_state_province.BackColor = color;
			txt_s6_shipper_postal_code.BackColor = color;
			txt_s7_shipper_telephone_fax.BackColor = color;
			dl_s8_shipper_iso_country_code.BackColor = color;
			txt_s8_shipper_iso_country_code.BackColor = color;
			txt_s9_shipper_contact_name.BackColor = color;
			txt_c1_consignee_name.BackColor = color;
			txt_c2_consignee_address1.BackColor = color;
			txt_c3_consignee_address2.BackColor = color;
			txt_c4_consignee_city.BackColor = color;
			dl_c5_consignee_state_province.BackColor = color;
			txt_c6_consignee_postal_code.BackColor = color;
			txt_c7_consignee_telephone_fax.BackColor = color;
			txt_c8_consignee_iso_country_code.BackColor = color;
			txt_c9_consignee_contact_name.BackColor = color;
			txt_n1_notify_name.BackColor = color;
			txt_n2_notify_address1.BackColor = color;
			txt_n3_notify_address2.BackColor = color;
			txt_n4_notify_city.BackColor = color;
			dl_n5_notify_state_province.BackColor = color;
			txt_n6_notify_postal_code.BackColor = color;
			txt_n7_notify_telephone_fax.BackColor = color;
			txt_n8_notify_iso_country_code.BackColor = color;
			txt_n9_notify_party_contact_name.BackColor = color;
			#endregion

		}
		private void PerformMode(int mode,bool scrn)
		{



			UserControl UserControl1 = (UserControl)this.FindControl("RdSelectDateControl11");
			DropDownList rdDateSet1 = (DropDownList) UserControl1.FindControl("rdDateSet1");

			switch (mode)
			{
				case 0 : /* Blank mode  */
					this.UltraWebToolbar1.Items.FromKeyButton("New").Enabled = true;
					this.UltraWebToolbar1.Items.FromKeyButton("Edit").Enabled = false;
					this.UltraWebToolbar1.Items.FromKeyButton("Save").Enabled = false;
					this.UltraWebToolbar1.Items.FromKeyButton("Delete").Enabled = false;
					this.UltraWebToolbar1.Items.FromKeyButton("Cancel").Enabled = false;
					this.UltraWebToolbar1.Items.FromKeyButton("Reset").Enabled = false;
					this.UltraWebTab1.SelectedTab = 0;
					if(scrn) PerformFieldSet(false);
					this.lblTask.Text = "Ready";
					drSearch.Enabled = true;
					txtSearchKey.Enabled = drSearch.Enabled;
					rdDateSet1.Enabled = drSearch.Enabled;
					Webdatetimeedit1.Enabled = drSearch.Enabled;
					Webdatetimeedit2.Enabled = drSearch.Enabled;
					btnSearch.Enabled = drSearch.Enabled;
					lblValidation.Visible = false;
					btnValidation.Visible = false;
					break;
				case 1: /* New mode  */
					this.UltraWebToolbar1.Items.FromKeyButton("New").Enabled = false;
					this.UltraWebToolbar1.Items.FromKeyButton("Edit").Enabled = false;
					this.UltraWebToolbar1.Items.FromKeyButton("Save").Enabled = true;
					this.UltraWebToolbar1.Items.FromKeyButton("Delete").Enabled = false;
					this.UltraWebToolbar1.Items.FromKeyButton("Cancel").Enabled = true;
					this.UltraWebToolbar1.Items.FromKeyButton("Reset").Enabled = true;
					this.UltraWebTab1.SelectedTab = 0;
					if(scrn) PerformFieldSet(true);
					this.lblTask.Text = "Create";
					drSearch.Enabled = false;
					txtSearchKey.Enabled = drSearch.Enabled;
					rdDateSet1.Enabled = drSearch.Enabled;
					Webdatetimeedit1.Enabled = drSearch.Enabled;
					Webdatetimeedit2.Enabled = drSearch.Enabled;
					btnSearch.Enabled = drSearch.Enabled;
					lblValidation.Visible = true;
					btnValidation.Visible = true;
					break;
				case 2: /* Show mode for Existed data */
					this.UltraWebToolbar1.Items.FromKeyButton("New").Enabled = true;
					this.UltraWebToolbar1.Items.FromKeyButton("Edit").Enabled = true;
					this.UltraWebToolbar1.Items.FromKeyButton("Save").Enabled = false;
					this.UltraWebToolbar1.Items.FromKeyButton("Delete").Enabled = false;
					this.UltraWebToolbar1.Items.FromKeyButton("Cancel").Enabled = false;
					this.UltraWebToolbar1.Items.FromKeyButton("Reset").Enabled = false;
					this.UltraWebTab1.SelectedTab = 0;
					if(scrn) PerformFieldSet(false);
					drSearch.Enabled = true;
					txtSearchKey.Enabled = drSearch.Enabled;
					rdDateSet1.Enabled = drSearch.Enabled;
					Webdatetimeedit1.Enabled = drSearch.Enabled;
					Webdatetimeedit2.Enabled = drSearch.Enabled;
					btnSearch.Enabled = drSearch.Enabled;
					this.lblTask.Text = "Display";
					lblValidation.Visible = true;
					btnValidation.Visible = true;
					break;
				case 3: /* Edit mode  */
					this.UltraWebToolbar1.Items.FromKeyButton("Edit").Enabled = false;
					this.UltraWebToolbar1.Items.FromKeyButton("Save").Enabled = true;
					this.UltraWebToolbar1.Items.FromKeyButton("Delete").Enabled = true;
					this.UltraWebToolbar1.Items.FromKeyButton("Cancel").Enabled = true;
					this.UltraWebToolbar1.Items.FromKeyButton("Reset").Enabled = false;
					this.UltraWebTab1.SelectedTab = 0;
					if(scrn) PerformFieldSet(true);
					drSearch.Enabled = false;
					txtSearchKey.Enabled = drSearch.Enabled;
					rdDateSet1.Enabled = drSearch.Enabled;
					Webdatetimeedit1.Enabled = drSearch.Enabled;
					Webdatetimeedit2.Enabled = drSearch.Enabled;
					btnSearch.Enabled = drSearch.Enabled;
					this.lblTask.Text = "Edit";
					lblValidation.Visible = true;
					btnValidation.Visible = true;
					break;
				case 4 :
					break;
			}

				btnValidation.ImageUrl = "../../../Images/mark_o.gif";
				btnAMS_Send.Visible = false;
				lblAMS_Send.Visible = false;

		}


		private void btnNew_Click(object sender, System.EventArgs e)
		{
			lblError.Text = "";
			btnAMS_Send.Visible = false;
			lblAMS_Send.Visible = false;
			ValidationSummary1.Enabled = false;
			PerformNew();		
			ValidationSummary1.Enabled = true;
		}

		private void PerformNew()
		{
			int i = PerformPickAmsNumber();
		
			if(i>0)	
			{
				ViewState["iPickedAmsNumber"] = i;
				lblError.Text = "Now you are working with Temp.No.:"+ "*"+ViewState["iPickedAmsNumber"];
				this.lblDocNo.Text = " * Temp # " +ViewState["iPickedAmsNumber"];
				this.txt_doc_number.Text = ViewState["iPickedAmsNumber"].ToString();
			}
			else
			{
				Response.Write("<script language= 'javascript'> alert('Number creation error!'); </script>");
			}

			PerformMode(1,true);

			PerformBlankData();

			this.UltraWebGrid1.Bands[0].AddNew();
			UltraWebGrid1.Rows[0].Cells.FromKey("i1_item_number").Value = "001";
			UltraWebGrid1.Rows[0].Cells.FromKey("a").Value = "a";

		}

		private int	PerformPickAmsNumber()
		{
			int i = 0;
            string ConnectStr = (new igFunctions.DB().getConStr());
			SqlConnection Con = new SqlConnection(ConnectStr);
			SqlCommand Cmd = new SqlCommand();
			Cmd.Connection = Con;
			
			try
			{
				Con.Open();
				Cmd.CommandText="select max(doc_number) as doc_number from ig_ocean_ams_edi_header where elt_account_number = " + elt_account_number;
				SqlDataReader reader = Cmd.ExecuteReader();

				if(reader.Read())
				{
					string strI = reader["doc_number"].ToString();
					if(strI != "")
					{
						i = int.Parse( strI);
					}
				}
				else
				{
					lblError.Text = "Error was occured - ( AMS Doc. Number Creation Error )";
				}

				reader.Close();
			}
			catch(Exception ex)
			{
				lblError.Text = "Error was occured - ( AMS Doc. Number Creation Error ) <br/> ";
				lblError.Text += ex.Message;
				Con.Close();
				return -1;
			}
			finally
			{
				i++;
			}

			try
			{
				Cmd.CommandText="insert into ig_ocean_ams_edi_header ( elt_account_number,doc_number ) VALUES ( " +elt_account_number+ ", " +i.ToString()+ ")";
				if(Cmd.ExecuteNonQuery()==0)
				{
					lblError.Text = "Error was occured - ( AMS Doc. Number Creation Error )";
				}
			}
			catch(Exception ex)
			{
				lblError.Text = "Error was occured - ( AMS Doc. Number Creation Error ) <br/> ";
				lblError.Text += ex.Message;
				return -1;
			}
			finally
			{

			}

			// insert into enque table

			string strSessionID = Session.SessionID.ToString();
			try
			{
				Cmd.CommandText="insert into ig_ocean_ams_que ( sessionid,elt_account_number,doc_number ) VALUES ( '" +strSessionID+"',"+elt_account_number+ "," +i.ToString()+ ")";
				if(Cmd.ExecuteNonQuery()==0)
				{
					lblError.Text = "Error was occured - ( AMS Doc. Number Creation Error )";
				}
			}
			catch(Exception ex)
			{
				lblError.Text = "Error was occured - ( AMS Doc. Number Creation Error ) <br/> ";
				lblError.Text += ex.Message;
				return -1;
			}
			finally
			{
				Con.Close();
			}


			return i;
		}

		private void PerformDeleteQue()
		{
			int iPickedAmsNumber = (int) ViewState["iPickedAmsNumber"];
			string strSessionID = Session.SessionID.ToString();
            string ConnectStr = (new igFunctions.DB().getConStr());
			SqlConnection Con = new SqlConnection(ConnectStr);
			SqlCommand cmdDelete = 
				new SqlCommand("delete from ig_ocean_ams_que where sessionid='" +
				strSessionID + "' and elt_account_number="+elt_account_number+" and doc_number=" + iPickedAmsNumber.ToString(),Con);

			Con.Open();			
			cmdDelete.ExecuteNonQuery();
			cmdDelete.CommandText = "delete from ig_ocean_ams_edi_header where elt_account_number="+elt_account_number+" and doc_number=" + iPickedAmsNumber.ToString();
			cmdDelete.ExecuteNonQuery();
			Con.Close();
			lblDocNo.Text = "";
			txt_doc_number.Text = "";
		}

		private void btnCancel_Click(object sender, System.EventArgs e)
		{
			ValidationSummary1.Enabled = false;
			if(lblTask.Text == "Edit")
			{
				int i = int.Parse(txt_doc_number.Text);
				PerformDataShow();
				PerformGridStruc(i);
				PerformDataBind();
				PerformMode(2,true);			
			}
			if(lblTask.Text == "Create")
			{
				lblError.Text = "";
				PerformDeleteQue();
				PerformMode(0,true);
			}
			ValidationSummary1.Enabled = true;
		}


		private void PerformDataShow()
		{

			string Query;
			igFunctions.DB myDB = new igFunctions.DB();

            myDB.DbConnELT(Request.ServerVariables["SERVER_NAME"].ToLower(), Request.ServerVariables["SERVER_PORT"].ToLower());

			Query = " select * from ig_ocean_ams_edi_header  "
				+ " WHERE elt_account_number="+elt_account_number+ " AND doc_number = '"+ txt_doc_number.Text +"'";

			SqlDataReader Reader = myDB.FatechQuery(Query);
			if(Reader.Read())
			{
				PerformFillData(Reader);
			}
			else
			{
				lblError.Text = "Data was not found.";
			}

			myDB.ReaderClose();
			myDB.DbClose();

		}

		private void PerformBlankData()
		{

			#region FindControl

			TextBox  txt_v1_vessel_code  = (TextBox)UltraWebTab1.FindControl("txt_v1_vessel_code");
			TextBox  txt_v2_voyage_number = (TextBox)UltraWebTab1.FindControl("txt_v2_voyage_number");
			TextBox  txt_v3_vessel_name = (TextBox)UltraWebTab1.FindControl("txt_v3_vessel_name");
			TextBox  txt_v4_scac_code = (TextBox)UltraWebTab1.FindControl("txt_v4_scac_code");
			DropDownList  dl_v5_vessel_flag = (DropDownList)UltraWebTab1.FindControl("dl_v5_vessel_flag");
			TextBox  txt_v5_vessel_flag = (TextBox)UltraWebTab1.FindControl("txt_v5_vessel_flag");
			DropDownList  dl_v6_first_us_port_of_discharge = (DropDownList)UltraWebTab1.FindControl("dl_v6_first_us_port_of_discharge");
			TextBox  txt_v6_first_us_port_of_discharge = (TextBox)UltraWebTab1.FindControl("txt_v6_first_us_port_of_discharge");
			TextBox  txt_v7_last_foreign_pol_s = (TextBox)UltraWebTab1.FindControl("txt_v7_last_foreign_pol_s");
			TextBox  txt_v7_last_foreign_pol = (TextBox)UltraWebTab1.FindControl("txt_v7_last_foreign_pol");
			DropDownList  dl_p1_port_of_discharge = (DropDownList)UltraWebTab1.FindControl("dl_p1_port_of_discharge");
			TextBox  txt_p1_port_of_discharge = (TextBox)UltraWebTab1.FindControl("txt_p1_port_of_discharge");
			Infragistics.WebUI.WebDataInput.WebDateTimeEdit txt_p2_estimated_date_of_arrival = (Infragistics.WebUI.WebDataInput.WebDateTimeEdit)UltraWebTab1.FindControl("txt_p2_estimated_date_of_arrival");
			TextBox  txt_p3_terminal_operator_code_s = (TextBox)UltraWebTab1.FindControl("txt_p3_terminal_operator_code_s");
			TextBox  txt_p3_terminal_operator_code = (TextBox)UltraWebTab1.FindControl("txt_p3_terminal_operator_code");
			TextBox  txt_l1_port_of_load_s = (TextBox)UltraWebTab1.FindControl("txt_l1_port_of_load_s");
			TextBox  txt_l1_port_of_load = (TextBox)UltraWebTab1.FindControl("txt_l1_port_of_load");
			Infragistics.WebUI.WebDataInput.WebDateTimeEdit  txt_l2_load_date = (Infragistics.WebUI.WebDataInput.WebDateTimeEdit)UltraWebTab1.FindControl("txt_l2_load_date");
			Infragistics.WebUI.WebDataInput.WebDateTimeEdit  txt_l3_load_time = (Infragistics.WebUI.WebDataInput.WebDateTimeEdit)UltraWebTab1.FindControl("txt_l3_load_time");
//			TextBox  txt_creation_date = (TextBox)UltraWebTab1.FindControl("txt_creation_date");
			TextBox  txt_b1_bill_of_lading_number = (TextBox)UltraWebTab1.FindControl("txt_b1_bill_of_lading_number");
			TextBox  txt_b2_port_of_loading_s = (TextBox)UltraWebTab1.FindControl("txt_b2_port_of_loading_s");
			TextBox  txt_b2_port_of_loading = (TextBox)UltraWebTab1.FindControl("txt_b2_port_of_loading");
			TextBox  txt_b3_place_of_final_destination_s = (TextBox)UltraWebTab1.FindControl("txt_b3_place_of_final_destination_s");
			TextBox  txt_b3_place_of_final_destination = (TextBox)UltraWebTab1.FindControl("txt_b3_place_of_final_destination");
			TextBox  txt_b4_place_of_receipt = (TextBox)UltraWebTab1.FindControl("txt_b4_place_of_receipt");
			DropDownList  dl_b5_b_lading_status_code = (DropDownList)UltraWebTab1.FindControl("dl_b5_b_lading_status_code");
			TextBox  txt_b5_b_lading_status_code = (TextBox)UltraWebTab1.FindControl("txt_b5_b_lading_status_code");
			TextBox  txt_b6_b_lading_issuer_scac_code = (TextBox)UltraWebTab1.FindControl("txt_b6_b_lading_issuer_scac_code");
			TextBox  txt_b7_snp1 = (TextBox)UltraWebTab1.FindControl("txt_b7_snp1");
			TextBox  txt_b8_snp2 = (TextBox)UltraWebTab1.FindControl("txt_b8_snp2");
			TextBox  txt_b9_manifested_units = (TextBox)UltraWebTab1.FindControl("txt_b9_manifested_units");
			Infragistics.WebUI.WebDataInput.WebNumericEdit  txt_b10_total_gross_weight = (Infragistics.WebUI.WebDataInput.WebNumericEdit)UltraWebTab1.FindControl("txt_b10_total_gross_weight");
			TextBox  txt_b11_booking_number = (TextBox)UltraWebTab1.FindControl("txt_b11_booking_number");
			TextBox  txt_b12_master_ocean_bill_number = (TextBox)UltraWebTab1.FindControl("txt_b12_master_ocean_bill_number");
			TextBox  txt_b13_agency_unique_code = (TextBox)UltraWebTab1.FindControl("txt_b13_agency_unique_code");
			TextBox  txt_b14_snp3 = (TextBox)UltraWebTab1.FindControl("txt_b14_snp3");
			TextBox  txt_b15_snp4 = (TextBox)UltraWebTab1.FindControl("txt_b15_snp4");
			TextBox  txt_b16_snp5 = (TextBox)UltraWebTab1.FindControl("txt_b16_snp5");
			TextBox  txt_b17_snp6 = (TextBox)UltraWebTab1.FindControl("txt_b17_snp6");
			TextBox  txt_b18_snp7 = (TextBox)UltraWebTab1.FindControl("txt_b18_snp7");
			TextBox  txt_b19_snp8 = (TextBox)UltraWebTab1.FindControl("txt_b19_snp8");
			DropDownList  dl_b20_weight_unit = (DropDownList)UltraWebTab1.FindControl("dl_b20_weight_unit");
			TextBox  txt_b20_weight_unit = (TextBox)UltraWebTab1.FindControl("txt_b20_weight_unit");
			TextBox  txt_s1_shipper_name = (TextBox)UltraWebTab1.FindControl("txt_s1_shipper_name");
			TextBox  txt_s2_shipper_address1 = (TextBox)UltraWebTab1.FindControl("txt_s2_shipper_address1");
			TextBox  txt_s3_shipper_address2 = (TextBox)UltraWebTab1.FindControl("txt_s3_shipper_address2");
			TextBox  txt_s4_shipper_city = (TextBox)UltraWebTab1.FindControl("txt_s4_shipper_city");
			TextBox  txt_s5_shipper_state_province = (TextBox)UltraWebTab1.FindControl("txt_s5_shipper_state_province");
			TextBox  txt_s6_shipper_postal_code = (TextBox)UltraWebTab1.FindControl("txt_s6_shipper_postal_code");
			TextBox  txt_s7_shipper_telephone_fax = (TextBox)UltraWebTab1.FindControl("txt_s7_shipper_telephone_fax");
			DropDownList  dl_s8_shipper_iso_country_code = (DropDownList)UltraWebTab1.FindControl("dl_s8_shipper_iso_country_code");
			TextBox  txt_s8_shipper_iso_country_code = (TextBox)UltraWebTab1.FindControl("txt_s8_shipper_iso_country_code");
			TextBox  txt_s9_shipper_contact_name = (TextBox)UltraWebTab1.FindControl("txt_s9_shipper_contact_name");
			TextBox  txt_c1_consignee_name = (TextBox)UltraWebTab1.FindControl("txt_c1_consignee_name");
			TextBox  txt_c2_consignee_address1 = (TextBox)UltraWebTab1.FindControl("txt_c2_consignee_address1");
			TextBox  txt_c3_consignee_address2 = (TextBox)UltraWebTab1.FindControl("txt_c3_consignee_address2");
			TextBox  txt_c4_consignee_city = (TextBox)UltraWebTab1.FindControl("txt_c4_consignee_city");
			DropDownList  dl_c5_consignee_state_province = (DropDownList)UltraWebTab1.FindControl("dl_c5_consignee_state_province");
			TextBox  txt_c5_consignee_state_province = (TextBox)UltraWebTab1.FindControl("txt_c5_consignee_state_province");
			TextBox  txt_c6_consignee_postal_code = (TextBox)UltraWebTab1.FindControl("txt_c6_consignee_postal_code");
			TextBox  txt_c7_consignee_telephone_fax = (TextBox)UltraWebTab1.FindControl("txt_c7_consignee_telephone_fax");
			TextBox  txt_c8_consignee_iso_country_code = (TextBox)UltraWebTab1.FindControl("txt_c8_consignee_iso_country_code");
			TextBox  txt_c9_consignee_contact_name = (TextBox)UltraWebTab1.FindControl("txt_c9_consignee_contact_name");
			TextBox  txt_n1_notify_name = (TextBox)UltraWebTab1.FindControl("txt_n1_notify_name");
			TextBox  txt_n2_notify_address1 = (TextBox)UltraWebTab1.FindControl("txt_n2_notify_address1");
			TextBox  txt_n3_notify_address2 = (TextBox)UltraWebTab1.FindControl("txt_n3_notify_address2");
			TextBox  txt_n4_notify_city = (TextBox)UltraWebTab1.FindControl("txt_n4_notify_city");
			DropDownList  dl_n5_notify_state_province = (DropDownList)UltraWebTab1.FindControl("dl_n5_notify_state_province");
			TextBox  txt_n5_notify_state_province = (TextBox)UltraWebTab1.FindControl("txt_n5_notify_state_province");
			TextBox  txt_n6_notify_postal_code = (TextBox)UltraWebTab1.FindControl("txt_n6_notify_postal_code");
			TextBox  txt_n7_notify_telephone_fax = (TextBox)UltraWebTab1.FindControl("txt_n7_notify_telephone_fax");
			TextBox  txt_n8_notify_iso_country_code = (TextBox)UltraWebTab1.FindControl("txt_n8_notify_iso_country_code");
			TextBox  txt_n9_notify_party_contact_name = (TextBox)UltraWebTab1.FindControl("txt_n9_notify_party_contact_name");
			#endregion

			#region Fill
			txt_v1_vessel_code.Text = "";
			txt_v2_voyage_number.Text = "";
			txt_v3_vessel_name.Text = "";
			txt_v4_scac_code.Text = "";
			dl_v5_vessel_flag.SelectedIndex = 0;
			txt_v5_vessel_flag.Text = "";
			dl_v6_first_us_port_of_discharge.SelectedIndex = 0;
			txt_v6_first_us_port_of_discharge.Text = "";
			txt_v7_last_foreign_pol_s.Text = "";
			txt_v7_last_foreign_pol.Text = "";
			dl_p1_port_of_discharge.SelectedIndex = 0;
			txt_p1_port_of_discharge.Text = "";
			txt_p2_estimated_date_of_arrival.Text = DateTime.Now.ToShortDateString();
			txt_p3_terminal_operator_code_s.Text = "";
			txt_p3_terminal_operator_code.Text = "";
			txt_l1_port_of_load_s.Text = "";
			txt_l1_port_of_load.Text = "";
			txt_l2_load_date.Text = DateTime.Now.ToShortDateString();
			txt_l3_load_time.Text = DateTime.Now.ToShortTimeString();
			txt_creation_date.Text = "";
			txt_b1_bill_of_lading_number.Text = "";
			txt_b2_port_of_loading_s.Text = "";
			txt_b2_port_of_loading.Text = "";
			txt_b3_place_of_final_destination_s.Text = "";
			txt_b3_place_of_final_destination.Text = "";
			txt_b4_place_of_receipt.Text = "";
			dl_b5_b_lading_status_code.SelectedIndex = 0;
			txt_b5_b_lading_status_code.Text = "";
			txt_b6_b_lading_issuer_scac_code.Text = "";
			txt_b7_snp1.Text = "";
			txt_b8_snp2.Text = "";
			txt_b9_manifested_units.Text = "";
			txt_b10_total_gross_weight.Text ="";
			txt_b11_booking_number.Text = "";
			txt_b12_master_ocean_bill_number.Text ="";
			txt_b13_agency_unique_code.Text = "";
			txt_b14_snp3.Text = "";
			txt_b15_snp4.Text ="";
			txt_b16_snp5.Text = "";
			txt_b17_snp6.Text = "";
			txt_b18_snp7.Text ="";
			txt_b19_snp8.Text = "";
			dl_b20_weight_unit.SelectedIndex = 0;
			txt_b20_weight_unit.Text = "";
			txt_s1_shipper_name.Text = "";
			txt_s2_shipper_address1.Text = "";
			txt_s3_shipper_address2.Text = "";
			txt_s4_shipper_city.Text = "";
			txt_s5_shipper_state_province.Text = "";
			txt_s6_shipper_postal_code.Text = "";
			txt_s7_shipper_telephone_fax.Text = "";
			dl_s8_shipper_iso_country_code.SelectedIndex = 0;
			txt_s8_shipper_iso_country_code.Text = "";
			txt_s9_shipper_contact_name.Text = "";
			txt_c1_consignee_name.Text = "";
			txt_c2_consignee_address1.Text ="";
			txt_c3_consignee_address2.Text = "";
			txt_c4_consignee_city.Text = "";
			dl_c5_consignee_state_province.SelectedIndex = 0;
			txt_c5_consignee_state_province.Text = "";
			txt_c6_consignee_postal_code.Text = "";
			txt_c7_consignee_telephone_fax.Text = "";
			txt_c8_consignee_iso_country_code.Text = "";
			txt_c9_consignee_contact_name.Text = "";
			txt_n1_notify_name.Text = "";
			txt_n2_notify_address1.Text = "";
			txt_n3_notify_address2.Text = "";
			txt_n4_notify_city.Text = "";
			dl_n5_notify_state_province.SelectedIndex = 0;
			txt_n5_notify_state_province.Text= "";
			txt_n6_notify_postal_code.Text = "";
			txt_n7_notify_telephone_fax.Text = "";
			txt_n8_notify_iso_country_code.Text = "";
			txt_n9_notify_party_contact_name.Text = "";
			#endregion

		}


		private void PerformFillData(SqlDataReader Reader)
		{

			#region FindControl

			TextBox  txt_v1_vessel_code  = (TextBox)UltraWebTab1.FindControl("txt_v1_vessel_code");
			TextBox  txt_v2_voyage_number = (TextBox)UltraWebTab1.FindControl("txt_v2_voyage_number");
			TextBox  txt_v3_vessel_name = (TextBox)UltraWebTab1.FindControl("txt_v3_vessel_name");
			TextBox  txt_v4_scac_code = (TextBox)UltraWebTab1.FindControl("txt_v4_scac_code");
			DropDownList  dl_v5_vessel_flag = (DropDownList)UltraWebTab1.FindControl("dl_v5_vessel_flag");
			TextBox  txt_v5_vessel_flag = (TextBox)UltraWebTab1.FindControl("txt_v5_vessel_flag");
			DropDownList  dl_v6_first_us_port_of_discharge = (DropDownList)UltraWebTab1.FindControl("dl_v6_first_us_port_of_discharge");
			TextBox  txt_v6_first_us_port_of_discharge = (TextBox)UltraWebTab1.FindControl("txt_v6_first_us_port_of_discharge");
			TextBox  txt_v7_last_foreign_pol_s = (TextBox)UltraWebTab1.FindControl("txt_v7_last_foreign_pol_s");
			TextBox  txt_v7_last_foreign_pol = (TextBox)UltraWebTab1.FindControl("txt_v7_last_foreign_pol");
			DropDownList  dl_p1_port_of_discharge = (DropDownList)UltraWebTab1.FindControl("dl_p1_port_of_discharge");
			TextBox  txt_p1_port_of_discharge = (TextBox)UltraWebTab1.FindControl("txt_p1_port_of_discharge");
			Infragistics.WebUI.WebDataInput.WebDateTimeEdit txt_p2_estimated_date_of_arrival = (Infragistics.WebUI.WebDataInput.WebDateTimeEdit)UltraWebTab1.FindControl("txt_p2_estimated_date_of_arrival");
			TextBox  txt_p3_terminal_operator_code_s = (TextBox)UltraWebTab1.FindControl("txt_p3_terminal_operator_code_s");
			TextBox  txt_p3_terminal_operator_code = (TextBox)UltraWebTab1.FindControl("txt_p3_terminal_operator_code");
			TextBox  txt_l1_port_of_load_s = (TextBox)UltraWebTab1.FindControl("txt_l1_port_of_load_s");
			TextBox  txt_l1_port_of_load = (TextBox)UltraWebTab1.FindControl("txt_l1_port_of_load");
			Infragistics.WebUI.WebDataInput.WebDateTimeEdit  txt_l2_load_date = (Infragistics.WebUI.WebDataInput.WebDateTimeEdit)UltraWebTab1.FindControl("txt_l2_load_date");
			Infragistics.WebUI.WebDataInput.WebDateTimeEdit  txt_l3_load_time = (Infragistics.WebUI.WebDataInput.WebDateTimeEdit)UltraWebTab1.FindControl("txt_l3_load_time");
//			TextBox  txt_creation_date = (TextBox)UltraWebTab1.FindControl("txt_creation_date");
			TextBox  txt_b1_bill_of_lading_number = (TextBox)UltraWebTab1.FindControl("txt_b1_bill_of_lading_number");
			TextBox  txt_b2_port_of_loading_s = (TextBox)UltraWebTab1.FindControl("txt_b2_port_of_loading_s");
			TextBox  txt_b2_port_of_loading = (TextBox)UltraWebTab1.FindControl("txt_b2_port_of_loading");
			TextBox  txt_b3_place_of_final_destination_s = (TextBox)UltraWebTab1.FindControl("txt_b3_place_of_final_destination_s");
			TextBox  txt_b3_place_of_final_destination = (TextBox)UltraWebTab1.FindControl("txt_b3_place_of_final_destination");
			TextBox  txt_b4_place_of_receipt = (TextBox)UltraWebTab1.FindControl("txt_b4_place_of_receipt");
			DropDownList  dl_b5_b_lading_status_code = (DropDownList)UltraWebTab1.FindControl("dl_b5_b_lading_status_code");
			TextBox  txt_b5_b_lading_status_code = (TextBox)UltraWebTab1.FindControl("txt_b5_b_lading_status_code");
			TextBox  txt_b6_b_lading_issuer_scac_code = (TextBox)UltraWebTab1.FindControl("txt_b6_b_lading_issuer_scac_code");
			TextBox  txt_b7_snp1 = (TextBox)UltraWebTab1.FindControl("txt_b7_snp1");
			TextBox  txt_b8_snp2 = (TextBox)UltraWebTab1.FindControl("txt_b8_snp2");
			TextBox  txt_b9_manifested_units = (TextBox)UltraWebTab1.FindControl("txt_b9_manifested_units");
			Infragistics.WebUI.WebDataInput.WebNumericEdit  txt_b10_total_gross_weight = (Infragistics.WebUI.WebDataInput.WebNumericEdit)UltraWebTab1.FindControl("txt_b10_total_gross_weight");
			TextBox  txt_b11_booking_number = (TextBox)UltraWebTab1.FindControl("txt_b11_booking_number");
			TextBox  txt_b12_master_ocean_bill_number = (TextBox)UltraWebTab1.FindControl("txt_b12_master_ocean_bill_number");
			TextBox  txt_b13_agency_unique_code = (TextBox)UltraWebTab1.FindControl("txt_b13_agency_unique_code");
			TextBox  txt_b14_snp3 = (TextBox)UltraWebTab1.FindControl("txt_b14_snp3");
			TextBox  txt_b15_snp4 = (TextBox)UltraWebTab1.FindControl("txt_b15_snp4");
			TextBox  txt_b16_snp5 = (TextBox)UltraWebTab1.FindControl("txt_b16_snp5");
			TextBox  txt_b17_snp6 = (TextBox)UltraWebTab1.FindControl("txt_b17_snp6");
			TextBox  txt_b18_snp7 = (TextBox)UltraWebTab1.FindControl("txt_b18_snp7");
			TextBox  txt_b19_snp8 = (TextBox)UltraWebTab1.FindControl("txt_b19_snp8");
			DropDownList  dl_b20_weight_unit = (DropDownList)UltraWebTab1.FindControl("dl_b20_weight_unit");
			TextBox  txt_b20_weight_unit = (TextBox)UltraWebTab1.FindControl("txt_b20_weight_unit");
			TextBox  txt_s1_shipper_name = (TextBox)UltraWebTab1.FindControl("txt_s1_shipper_name");
			TextBox  txt_s2_shipper_address1 = (TextBox)UltraWebTab1.FindControl("txt_s2_shipper_address1");
			TextBox  txt_s3_shipper_address2 = (TextBox)UltraWebTab1.FindControl("txt_s3_shipper_address2");
			TextBox  txt_s4_shipper_city = (TextBox)UltraWebTab1.FindControl("txt_s4_shipper_city");
			TextBox  txt_s5_shipper_state_province = (TextBox)UltraWebTab1.FindControl("txt_s5_shipper_state_province");
			TextBox  txt_s6_shipper_postal_code = (TextBox)UltraWebTab1.FindControl("txt_s6_shipper_postal_code");
			TextBox  txt_s7_shipper_telephone_fax = (TextBox)UltraWebTab1.FindControl("txt_s7_shipper_telephone_fax");
			DropDownList  dl_s8_shipper_iso_country_code = (DropDownList)UltraWebTab1.FindControl("dl_s8_shipper_iso_country_code");
			TextBox  txt_s8_shipper_iso_country_code = (TextBox)UltraWebTab1.FindControl("txt_s8_shipper_iso_country_code");
			TextBox  txt_s9_shipper_contact_name = (TextBox)UltraWebTab1.FindControl("txt_s9_shipper_contact_name");
			TextBox  txt_c1_consignee_name = (TextBox)UltraWebTab1.FindControl("txt_c1_consignee_name");
			TextBox  txt_c2_consignee_address1 = (TextBox)UltraWebTab1.FindControl("txt_c2_consignee_address1");
			TextBox  txt_c3_consignee_address2 = (TextBox)UltraWebTab1.FindControl("txt_c3_consignee_address2");
			TextBox  txt_c4_consignee_city = (TextBox)UltraWebTab1.FindControl("txt_c4_consignee_city");
			DropDownList  dl_c5_consignee_state_province = (DropDownList)UltraWebTab1.FindControl("dl_c5_consignee_state_province");
			TextBox  txt_c5_consignee_state_province = (TextBox)UltraWebTab1.FindControl("txt_c5_consignee_state_province");
			TextBox  txt_c6_consignee_postal_code = (TextBox)UltraWebTab1.FindControl("txt_c6_consignee_postal_code");
			TextBox  txt_c7_consignee_telephone_fax = (TextBox)UltraWebTab1.FindControl("txt_c7_consignee_telephone_fax");
			TextBox  txt_c8_consignee_iso_country_code = (TextBox)UltraWebTab1.FindControl("txt_c8_consignee_iso_country_code");
			TextBox  txt_c9_consignee_contact_name = (TextBox)UltraWebTab1.FindControl("txt_c9_consignee_contact_name");
			TextBox  txt_n1_notify_name = (TextBox)UltraWebTab1.FindControl("txt_n1_notify_name");
			TextBox  txt_n2_notify_address1 = (TextBox)UltraWebTab1.FindControl("txt_n2_notify_address1");
			TextBox  txt_n3_notify_address2 = (TextBox)UltraWebTab1.FindControl("txt_n3_notify_address2");
			TextBox  txt_n4_notify_city = (TextBox)UltraWebTab1.FindControl("txt_n4_notify_city");
			DropDownList  dl_n5_notify_state_province = (DropDownList)UltraWebTab1.FindControl("dl_n5_notify_state_province");
			TextBox  txt_n5_notify_state_province = (TextBox)UltraWebTab1.FindControl("txt_n5_notify_state_province");
			TextBox  txt_n6_notify_postal_code = (TextBox)UltraWebTab1.FindControl("txt_n6_notify_postal_code");
			TextBox  txt_n7_notify_telephone_fax = (TextBox)UltraWebTab1.FindControl("txt_n7_notify_telephone_fax");
			TextBox  txt_n8_notify_iso_country_code = (TextBox)UltraWebTab1.FindControl("txt_n8_notify_iso_country_code");
			TextBox  txt_n9_notify_party_contact_name = (TextBox)UltraWebTab1.FindControl("txt_n9_notify_party_contact_name");
			#endregion

			#region Fill
			txt_v1_vessel_code.Text = Reader["v1_vessel_code"].ToString();
			txt_v2_voyage_number.Text = Reader["v2_voyage_number"].ToString();
			txt_v3_vessel_name.Text = Reader["v3_vessel_name"].ToString();
			txt_v4_scac_code.Text = Reader["v4_scac_code"].ToString();
			dl_v5_vessel_flag.SelectedValue = Reader["v5_vessel_flag"].ToString();
			txt_v5_vessel_flag.Text = Reader["v5_vessel_flag"].ToString();
			dl_v6_first_us_port_of_discharge.SelectedValue = Reader["v6_first_us_port_of_discharge"].ToString();
			txt_v6_first_us_port_of_discharge.Text = Reader["v6_first_us_port_of_discharge"].ToString();
			txt_v7_last_foreign_pol_s.Text = Reader["v7_last_foreign_pol_s"].ToString();
			txt_v7_last_foreign_pol.Text = Reader["v7_last_foreign_pol"].ToString();
			dl_p1_port_of_discharge.SelectedValue = Reader["p1_port_of_discharge"].ToString();
			txt_p1_port_of_discharge.Text = Reader["p1_port_of_discharge"].ToString();
			txt_p2_estimated_date_of_arrival.Value = DateTime.Parse(Reader["p2_estimated_date_of_arrival"].ToString());
			txt_p3_terminal_operator_code_s.Text = Reader["p3_terminal_operator_code_s"].ToString();
			txt_p3_terminal_operator_code.Text = Reader["p3_terminal_operator_code"].ToString();
			txt_l1_port_of_load_s.Text = Reader["l1_port_of_load_s"].ToString();
			txt_l1_port_of_load.Text = Reader["l1_port_of_load"].ToString();
			txt_l2_load_date.Value = DateTime.Parse(Reader["l2_load_date"].ToString());
			txt_l3_load_time.Value = DateTime.Parse(Reader["l3_load_time"].ToString());
			txt_creation_date.Text = Reader["creation_date"].ToString();
			txt_b1_bill_of_lading_number.Text = Reader["b1_bill_of_lading_number"].ToString();
			txt_b2_port_of_loading_s.Text = Reader["b2_port_of_loading_s"].ToString();
			txt_b2_port_of_loading.Text = Reader["b2_port_of_loading"].ToString();
			txt_b3_place_of_final_destination_s.Text = Reader["b3_place_of_final_destination_s"].ToString();
			txt_b3_place_of_final_destination.Text = Reader["b3_place_of_final_destination"].ToString();
			txt_b4_place_of_receipt.Text = Reader["b4_place_of_receipt"].ToString();
			dl_b5_b_lading_status_code.SelectedValue = Reader["b5_b_lading_status_code"].ToString();
			txt_b5_b_lading_status_code.Text = Reader["b5_b_lading_status_code"].ToString();
			txt_b6_b_lading_issuer_scac_code.Text = Reader["b6_b_lading_issuer_scac_code"].ToString();
			txt_b7_snp1.Text = Reader["b7_snp1"].ToString();
			txt_b8_snp2.Text = Reader["b8_snp2"].ToString();
			txt_b9_manifested_units.Text = Reader["b9_manifested_units"].ToString();
			txt_b10_total_gross_weight.Text = Reader["b10_total_gross_weight"].ToString();
			txt_b11_booking_number.Text = Reader["b11_booking_number"].ToString();
			txt_b12_master_ocean_bill_number.Text = Reader["b12_master_ocean_bill_number"].ToString();
			txt_b13_agency_unique_code.Text = Reader["b13_agency_unique_code"].ToString();
			txt_b14_snp3.Text = Reader["b14_snp3"].ToString();
			txt_b15_snp4.Text = Reader["b15_snp4"].ToString();
			txt_b16_snp5.Text = Reader["b16_snp5"].ToString();
			txt_b17_snp6.Text = Reader["b17_snp6"].ToString();
			txt_b18_snp7.Text = Reader["b18_snp7"].ToString();
			txt_b19_snp8.Text = Reader["b19_snp8"].ToString();
			dl_b20_weight_unit.SelectedValue = Reader["b20_weight_unit"].ToString();
			txt_b20_weight_unit.Text = Reader["b20_weight_unit"].ToString();
			txt_s1_shipper_name.Text = Reader["s1_shipper_name"].ToString();
			txt_s2_shipper_address1.Text = Reader["s2_shipper_address1"].ToString();
			txt_s3_shipper_address2.Text = Reader["s3_shipper_address2"].ToString();
			txt_s4_shipper_city.Text = Reader["s4_shipper_city"].ToString();
			txt_s5_shipper_state_province.Text = Reader["s5_shipper_state_province"].ToString();
			txt_s6_shipper_postal_code.Text = Reader["s6_shipper_postal_code"].ToString();
			txt_s7_shipper_telephone_fax.Text = Reader["s7_shipper_telephone_fax"].ToString();
			dl_s8_shipper_iso_country_code.SelectedValue = Reader["s8_shipper_iso_country_code"].ToString();
			txt_s8_shipper_iso_country_code.Text = Reader["s8_shipper_iso_country_code"].ToString();
			txt_s9_shipper_contact_name.Text = Reader["s9_shipper_contact_name"].ToString();
			txt_c1_consignee_name.Text = Reader["c1_consignee_name"].ToString();
			txt_c2_consignee_address1.Text = Reader["c2_consignee_address1"].ToString();
			txt_c3_consignee_address2.Text = Reader["c3_consignee_address2"].ToString();
			txt_c4_consignee_city.Text = Reader["c4_consignee_city"].ToString();
			dl_c5_consignee_state_province.SelectedValue = Reader["c5_consignee_state_province"].ToString();
			txt_c5_consignee_state_province.Text = Reader["c5_consignee_state_province"].ToString();
			txt_c6_consignee_postal_code.Text = Reader["c6_consignee_postal_code"].ToString();
			txt_c7_consignee_telephone_fax.Text = Reader["c7_consignee_telephone_fax"].ToString();
			txt_c8_consignee_iso_country_code.Text = Reader["c8_consignee_iso_country_code"].ToString();
			txt_c9_consignee_contact_name.Text = Reader["c9_consignee_contact_name"].ToString();
			txt_n1_notify_name.Text = Reader["n1_notify_name"].ToString();
			txt_n2_notify_address1.Text = Reader["n2_notify_address1"].ToString();
			txt_n3_notify_address2.Text = Reader["n3_notify_address2"].ToString();
			txt_n4_notify_city.Text = Reader["n4_notify_city"].ToString();
			dl_n5_notify_state_province.SelectedValue= Reader["n5_notify_state_province"].ToString();
			txt_n5_notify_state_province.Text= Reader["n5_notify_state_province"].ToString();
			txt_n6_notify_postal_code.Text = Reader["n6_notify_postal_code"].ToString();
			txt_n7_notify_telephone_fax.Text = Reader["n7_notify_telephone_fax"].ToString();
			txt_n8_notify_iso_country_code.Text = Reader["n8_notify_iso_country_code"].ToString();
			txt_n9_notify_party_contact_name.Text = Reader["n9_notify_party_contact_name"].ToString();
			bool bSent = (Reader["ams_sent_flag"].ToString() == "Y" ? true : false);

			if (bSent) 
			{
				img_ams_sent.ImageUrl = "../../../Images/mark_x.gif";
			}
			else
			{
				img_ams_sent.ImageUrl = "../../../Images/mark_o.gif";
			}
			#endregion

		}


		private void btnTmpNoDelete_Click(object sender, System.EventArgs e)
		{
			ValidationSummary1.Enabled = false;
			PerformDeleteQue();	
			PerformMode(0,true);
			ValidationSummary1.Enabled = true;	
		}

		private void UltraWebGrid1_InitializeLayout(object sender, Infragistics.WebUI.UltraWebGrid.LayoutEventArgs e)
		{

			#region my Style
			e.Layout.SelectTypeColDefault=SelectType.Extended;
			e.Layout.SelectTypeRowDefault=SelectType.Extended;

			e.Layout.TableLayout=TableLayout.Fixed;
			e.Layout.RowStyleDefault.BorderDetails.ColorTop=Color.Gray;

			for(int i=0;i<UltraWebGrid1.Bands.Count;i++)
			{
				for(int j=0;j<UltraWebGrid1.Bands[i].Columns.Count;j++)
				{
					if(UltraWebGrid1.DisplayLayout.Bands[i].Columns[j].BaseColumnName != "Chk" )
					{
						UltraWebGrid1.DisplayLayout.Bands[i].Columns[j].SelectedCellStyle.BackColor=Color.Yellow;
						UltraWebGrid1.DisplayLayout.Bands[i].Columns[j].SelectedCellStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Text;
					}
				}
			}

			UltraWebGrid1.Bands[0].RowStyle.BackColor=Color.White;
			UltraWebGrid1.DisplayLayout.SelectedHeaderStyleDefault.BackColor=Color.Red;
			UltraWebGrid1.DisplayLayout.SelectTypeCellDefault=Infragistics.WebUI.UltraWebGrid.SelectType.Single;
			UltraWebGrid1.DisplayLayout.AllowColSizingDefault=Infragistics.WebUI.UltraWebGrid.AllowSizing.Free;

			//set cursor 
			UltraWebGrid1.DisplayLayout.FrameStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Default;
			UltraWebGrid1.DisplayLayout.Bands[0].HeaderStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Default;
			UltraWebGrid1.DisplayLayout.SelectedHeaderStyleDefault.BackColor=Color.Red;		
//			e.Layout.Bands[0].AllowRowNumbering=Infragistics.WebUI.UltraWebGrid.RowNumbering.Continuous;
			e.Layout.Bands[0].RowSelectorStyle.BackgroundImage = "../../../Images/mark_e.gif";

//			this.UltraWebGrid1.DisplayLayout.RowSelectorsDefault = Infragistics.WebUI.UltraWebGrid.RowSelectors.No;
			#endregion

			#region CHK
			e.Layout.Bands[0].Columns.Insert(0,"Chk");
			e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.BackgroundImage = "../../../Images/mark_o.gif";
			e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.HorizontalAlign=HorizontalAlign.Center;
			e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.CustomRules="background-position:center ;background-repeat:no-repeat";
			e.Layout.Bands[0].Columns.FromKey("Chk").Header.Caption = "";
			e.Layout.Bands[0].Columns.FromKey("Chk").Width = new Unit("40px");
			e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.BackColor = Color.FromArgb(249,236,212);
			e.Layout.Bands[0].Columns.FromKey("Chk").CellStyle.Cursor =  Infragistics.WebUI.Shared.Cursors.Hand;
			e.Layout.Bands[0].Columns.FromKey("Chk").AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No;
			e.Layout.Bands[0].AddButtonCaption = "";
			#endregion

			#region item number
			e.Layout.Bands[0].Columns.FromKey("i1_item_number").AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No;
			e.Layout.Bands[0].Columns.FromKey("i1_item_number").CellStyle.BackColor = Color.WhiteSmoke;

			#endregion

			#region Header caption
			e.Layout.Bands[0].Columns.FromKey("i1_item_number").Header.Caption = "Item *";
			e.Layout.Bands[0].Columns.FromKey("i1_item_number").Header.Style.Font.Bold = true;
			e.Layout.Bands[0].Columns.FromKey("i1_item_number").Header.Style.ForeColor = Color.Blue;

			e.Layout.Bands[0].Columns.FromKey("i2_quantity").Header.Caption = "Quantity *";
			e.Layout.Bands[0].Columns.FromKey("i2_quantity").Header.Style.Font.Bold = true;
			e.Layout.Bands[0].Columns.FromKey("i2_quantity").Header.Style.ForeColor = Color.Blue;

			e.Layout.Bands[0].Columns.FromKey("i3_net_weight").Header.Caption = "Net WGT";
			e.Layout.Bands[0].Columns.FromKey("i3_net_weight").Header.Style.Font.Italic = true;
			e.Layout.Bands[0].Columns.FromKey("i3_net_weight").Header.Style.ForeColor = Color.Red;

			e.Layout.Bands[0].Columns.FromKey("i4_volume").Header.Caption = "VOL."; 
			e.Layout.Bands[0].Columns.FromKey("i5_package_type").Header.Caption = "PKG.T"; 
			e.Layout.Bands[0].Columns.FromKey("i6_comodity_code").Header.Caption = "Comodity"; 
			e.Layout.Bands[0].Columns.FromKey("i6_comodity_code").Header.Style.Font.Italic = true;
			e.Layout.Bands[0].Columns.FromKey("i6_comodity_code").Header.Style.ForeColor = Color.Red;

			e.Layout.Bands[0].Columns.FromKey("i7_cash_value").Header.Caption = "Cash Val.";
			e.Layout.Bands[0].Columns.FromKey("i7_cash_value").Header.Style.Font.Italic = true;
			e.Layout.Bands[0].Columns.FromKey("i7_cash_value").Header.Style.ForeColor = Color.Red;

			e.Layout.Bands[0].Columns.FromKey("e1_equipment_number").Header.Caption = "Equip.No. *"; 
			e.Layout.Bands[0].Columns.FromKey("e1_equipment_number").Header.Style.Font.Bold = true;
			e.Layout.Bands[0].Columns.FromKey("e1_equipment_number").Header.Style.ForeColor = Color.Blue;

			e.Layout.Bands[0].Columns.FromKey("e2_seal_number1").Header.Caption = "Seal #1 *";
			e.Layout.Bands[0].Columns.FromKey("e2_seal_number1").Header.Style.Font.Bold = true;
			e.Layout.Bands[0].Columns.FromKey("e2_seal_number1").Header.Style.ForeColor = Color.Blue;

			e.Layout.Bands[0].Columns.FromKey("e3_seal_number2").Header.Caption = "Seal #2";
			e.Layout.Bands[0].Columns.FromKey("e4_length").Header.Caption = "Length";
			e.Layout.Bands[0].Columns.FromKey("e4_length").Header.Style.Font.Italic = true;
			e.Layout.Bands[0].Columns.FromKey("e4_length").Header.Style.ForeColor = Color.Red;

			e.Layout.Bands[0].Columns.FromKey("e5_width").Header.Caption = "Width"; 
			e.Layout.Bands[0].Columns.FromKey("e5_width").Header.Style.Font.Italic = true;
			e.Layout.Bands[0].Columns.FromKey("e5_width").Header.Style.ForeColor = Color.Red;

			e.Layout.Bands[0].Columns.FromKey("e6_height").Header.Caption = "Height"; 
			e.Layout.Bands[0].Columns.FromKey("e6_height").Header.Style.Font.Italic = true;
			e.Layout.Bands[0].Columns.FromKey("e6_height").Header.Style.ForeColor = Color.Red;

			e.Layout.Bands[0].Columns.FromKey("e7_iso_equipment").Header.Caption = "ISO Equip."; 
			e.Layout.Bands[0].Columns.FromKey("e7_iso_equipment").Header.Style.Font.Italic = true;
			e.Layout.Bands[0].Columns.FromKey("e7_iso_equipment").Header.Style.ForeColor = Color.Red;

			e.Layout.Bands[0].Columns.FromKey("e8_type_of_service").Header.Caption = "SVC.Type"; 

			e.Layout.Bands[0].Columns.FromKey("e9_loaded_empty_total").Header.Caption = "L/E/T *";
			e.Layout.Bands[0].Columns.FromKey("e9_loaded_empty_total").Header.Style.Font.Bold = true;
			e.Layout.Bands[0].Columns.FromKey("e9_loaded_empty_total").Header.Style.ForeColor = Color.Blue;

			e.Layout.Bands[0].Columns.FromKey("e10_equipment_desc_code").Header.Caption = "Equip.Desc. *"; 
			e.Layout.Bands[0].Columns.FromKey("e10_equipment_desc_code").Header.Style.Font.Bold = true;
			e.Layout.Bands[0].Columns.FromKey("e10_equipment_desc_code").Header.Style.ForeColor = Color.Blue;

			e.Layout.Bands[0].Columns.FromKey("d1_line_of_description").Header.Caption = "Desc. *"; 
			e.Layout.Bands[0].Columns.FromKey("d1_line_of_description").Header.Style.Font.Bold = true;
			e.Layout.Bands[0].Columns.FromKey("d1_line_of_description").Header.Style.ForeColor = Color.Blue;

			e.Layout.Bands[0].Columns.FromKey("m1_line_of_marks_and_numbers").Header.Caption = "Marks & No.s *";
			e.Layout.Bands[0].Columns.FromKey("m1_line_of_marks_and_numbers").Header.Style.Font.Bold = true;
			e.Layout.Bands[0].Columns.FromKey("m1_line_of_marks_and_numbers").Header.Style.ForeColor = Color.Blue;

			e.Layout.Bands[0].Columns.FromKey("h1_hazard_code").Header.Caption = "Hazard *"; 
			e.Layout.Bands[0].Columns.FromKey("h1_hazard_code").Header.Style.Font.Bold = true;
			e.Layout.Bands[0].Columns.FromKey("h1_hazard_code").Header.Style.ForeColor = Color.Blue;

			e.Layout.Bands[0].Columns.FromKey("h2_hazard_class").Header.Caption = "Class"; 
			e.Layout.Bands[0].Columns.FromKey("h3_hazard_description").Header.Caption = "Hazard Desc."; 
			e.Layout.Bands[0].Columns.FromKey("h4_hazard_contact").Header.Caption = "Hazard Contact"; 
			e.Layout.Bands[0].Columns.FromKey("h5_un_page_number").Header.Caption = "UN Page"; 
			e.Layout.Bands[0].Columns.FromKey("h6_flashpoint_temperature").Header.Caption = "F.Point Temp."; 
			e.Layout.Bands[0].Columns.FromKey("h6_flashpoint_temperature").Header.Style.Font.Italic = true;
			e.Layout.Bands[0].Columns.FromKey("h6_flashpoint_temperature").Header.Style.ForeColor = Color.Red;

			e.Layout.Bands[0].Columns.FromKey("h7_hazard_code_qualifier").Header.Caption = "Qualifier *";
			e.Layout.Bands[0].Columns.FromKey("h7_hazard_code_qualifier").Header.Style.Font.Bold = true;
			e.Layout.Bands[0].Columns.FromKey("h7_hazard_code_qualifier").Header.Style.ForeColor = Color.Blue;

			e.Layout.Bands[0].Columns.FromKey("h8_hazard_unit_of_measure").Header.Caption = "Unit"; 
			e.Layout.Bands[0].Columns.FromKey("h8_hazard_unit_of_measure").Header.Style.Font.Italic = true;
			e.Layout.Bands[0].Columns.FromKey("h8_hazard_unit_of_measure").Header.Style.ForeColor = Color.Red;

			e.Layout.Bands[0].Columns.FromKey("h9_negative_indigator").Header.Caption = "N.Indigator";
			e.Layout.Bands[0].Columns.FromKey("h9_negative_indigator").Header.Style.Font.Italic = true;
			e.Layout.Bands[0].Columns.FromKey("h9_negative_indigator").Header.Style.ForeColor = Color.Red;

			e.Layout.Bands[0].Columns.FromKey("h10_hazard_label").Header.Caption = "Label";
			e.Layout.Bands[0].Columns.FromKey("h11_hazard_classification").Header.Caption = "Class";
			#endregion

			# region  Field length
			e.Layout.Bands[0].Columns.FromKey("i1_item_number").FieldLen = 3;
			e.Layout.Bands[0].Columns.FromKey("i2_quantity").FieldLen = 10;
			e.Layout.Bands[0].Columns.FromKey("i3_net_weight").FieldLen = 10;
			e.Layout.Bands[0].Columns.FromKey("i4_volume").FieldLen = 10;
			e.Layout.Bands[0].Columns.FromKey("i5_package_type").FieldLen = 3;
			e.Layout.Bands[0].Columns.FromKey("i6_comodity_code").FieldLen = 11;
			e.Layout.Bands[0].Columns.FromKey("i7_cash_value").FieldLen = 8;
			e.Layout.Bands[0].Columns.FromKey("e1_equipment_number").FieldLen = 14;
			e.Layout.Bands[0].Columns.FromKey("e2_seal_number1").FieldLen = 15;
			e.Layout.Bands[0].Columns.FromKey("e3_seal_number2").FieldLen = 15;
			e.Layout.Bands[0].Columns.FromKey("e4_length").FieldLen = 5;
			e.Layout.Bands[0].Columns.FromKey("e5_width").FieldLen = 8;
			e.Layout.Bands[0].Columns.FromKey("e6_height").FieldLen = 8;
			e.Layout.Bands[0].Columns.FromKey("e7_iso_equipment").FieldLen = 4;
			e.Layout.Bands[0].Columns.FromKey("e8_type_of_service").FieldLen = 2;
			e.Layout.Bands[0].Columns.FromKey("e9_loaded_empty_total").FieldLen = 1;
			e.Layout.Bands[0].Columns.FromKey("e10_equipment_desc_code").FieldLen = 2;
			e.Layout.Bands[0].Columns.FromKey("d1_line_of_description").FieldLen = 45;
			e.Layout.Bands[0].Columns.FromKey("m1_line_of_marks_and_numbers").FieldLen = 45;
			e.Layout.Bands[0].Columns.FromKey("h1_hazard_code").FieldLen = 10;
			e.Layout.Bands[0].Columns.FromKey("h2_hazard_class").FieldLen = 4;
			e.Layout.Bands[0].Columns.FromKey("h3_hazard_description").FieldLen = 30;
			e.Layout.Bands[0].Columns.FromKey("h4_hazard_contact").FieldLen = 24;
			e.Layout.Bands[0].Columns.FromKey("h5_un_page_number").FieldLen = 6;
			e.Layout.Bands[0].Columns.FromKey("h6_flashpoint_temperature").FieldLen = 3;
			e.Layout.Bands[0].Columns.FromKey("h7_hazard_code_qualifier").FieldLen = 1;
			e.Layout.Bands[0].Columns.FromKey("h8_hazard_unit_of_measure").FieldLen = 2;
			e.Layout.Bands[0].Columns.FromKey("h9_negative_indigator").FieldLen = 1;
			e.Layout.Bands[0].Columns.FromKey("h10_hazard_label").FieldLen = 30;
			e.Layout.Bands[0].Columns.FromKey("h11_hazard_classification").FieldLen = 30;
			#endregion

			#region Field width
			e.Layout.Bands[0].Columns.FromKey("i1_item_number").Width = new Unit("30px");
			e.Layout.Bands[0].Columns.FromKey("i5_package_type").Width = new Unit("30px");
			e.Layout.Bands[0].Columns.FromKey("e4_length").Width = new Unit("60px");
			e.Layout.Bands[0].Columns.FromKey("e5_width").Width = new Unit("60px");
			e.Layout.Bands[0].Columns.FromKey("e6_height").Width = new Unit("60px");
			e.Layout.Bands[0].Columns.FromKey("e7_iso_equipment").Width = new Unit("40px");
			e.Layout.Bands[0].Columns.FromKey("e8_type_of_service").Width = new Unit("30px");
			e.Layout.Bands[0].Columns.FromKey("e9_loaded_empty_total").Width = new Unit("60px");
			e.Layout.Bands[0].Columns.FromKey("e10_equipment_desc_code").Width = new Unit("30px");
			e.Layout.Bands[0].Columns.FromKey("h2_hazard_class").Width = new Unit("40px");
			e.Layout.Bands[0].Columns.FromKey("h5_un_page_number").Width = new Unit("40px");
			e.Layout.Bands[0].Columns.FromKey("h6_flashpoint_temperature").Width = new Unit("40px");
			e.Layout.Bands[0].Columns.FromKey("h7_hazard_code_qualifier").Width = new Unit("30px");
			e.Layout.Bands[0].Columns.FromKey("h8_hazard_unit_of_measure").Width = new Unit("30px");
			e.Layout.Bands[0].Columns.FromKey("h9_negative_indigator").Width = new Unit("30px");
			#endregion

			#region HorizontalAlign
			e.Layout.Bands[0].Columns.FromKey("i2_quantity").CellStyle.HorizontalAlign = HorizontalAlign.Right;
			e.Layout.Bands[0].Columns.FromKey("i3_net_weight").CellStyle.HorizontalAlign = HorizontalAlign.Right;
			e.Layout.Bands[0].Columns.FromKey("i4_volume").CellStyle.HorizontalAlign = HorizontalAlign.Right;
			e.Layout.Bands[0].Columns.FromKey("i7_cash_value").CellStyle.HorizontalAlign = HorizontalAlign.Right;
			e.Layout.Bands[0].Columns.FromKey("e4_length").CellStyle.HorizontalAlign = HorizontalAlign.Right;
			#endregion

			#region a,e,x
			e.Layout.Bands[0].Columns.Add("a");
			e.Layout.Bands[0].Columns.Add("e");
			e.Layout.Bands[0].Columns.Add("x");

			e.Layout.Bands[0].Columns.FromKey("a").Width = new Unit("12px");
			e.Layout.Bands[0].Columns.FromKey("e").Width = new Unit("12px");
			e.Layout.Bands[0].Columns.FromKey("x").Width = new Unit("12px");
				
			e.Layout.Bands[0].Columns.FromKey("a").CellStyle.HorizontalAlign=HorizontalAlign.Center;
			e.Layout.Bands[0].Columns.FromKey("e").CellStyle.HorizontalAlign=HorizontalAlign.Center;
			e.Layout.Bands[0].Columns.FromKey("x").CellStyle.HorizontalAlign=HorizontalAlign.Center;
	
			e.Layout.Bands[0].Columns.FromKey("a").Header.Caption = "";
			e.Layout.Bands[0].Columns.FromKey("e").Header.Caption = "";
			e.Layout.Bands[0].Columns.FromKey("x").Header.Caption = "";
			
			e.Layout.Bands[0].Columns.FromKey("a").Header.Style.BackgroundImage = "../../../Images/mark_n.gif";
			e.Layout.Bands[0].Columns.FromKey("a").Header.Style.CustomRules="background-position:center ;background-repeat:no-repeat";
			e.Layout.Bands[0].Columns.FromKey("e").Header.Style.BackgroundImage = "../../../Images/mark_e.gif";
			e.Layout.Bands[0].Columns.FromKey("e").Header.Style.CustomRules="background-position:center ;background-repeat:no-repeat";
			e.Layout.Bands[0].Columns.FromKey("x").Header.Style.BackgroundImage = "../../../Images/mark_x.gif";
			e.Layout.Bands[0].Columns.FromKey("x").Header.Style.CustomRules="background-position:center ;background-repeat:no-repeat";

			e.Layout.Bands[0].AddButtonCaption = "";

			e.Layout.Bands[0].Columns.FromKey("a").AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No;
			e.Layout.Bands[0].Columns.FromKey("e").AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No;
			e.Layout.Bands[0].Columns.FromKey("x").AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No;

			e.Layout.Bands[0].Columns.FromKey("x").Hidden = true;
			#endregion

		}

		private void btnShow_Click(object sender, System.EventArgs e)
		{
			ValidationSummary1.Enabled = false;
			PerformDataEdit();
			ValidationSummary1.Enabled = true;
		}

		private void PerformDataEdit()
		{
			int i = int.Parse(txt_doc_number.Text);
			ViewState["iPickedAmsNumber"] = txt_doc_number.Text;			
			lblError.Text = "";
			lblDocNo.Text = "";
			lblTask.Text = "Edit";
			PerformDataShow();
			PerformGridStruc(i);
			PerformDataBind();
			PerformMode(3,true);

		}

		private void btnBack_Click(object sender, System.EventArgs e)
		{
			PerformBack();
		}

		private void PerformBack()
		{
			int a = int.Parse(ViewState["Count"].ToString());
			string script = "<script language='javascript'>";

			script += "if(history.length >= " + a.ToString() + ")";
			script += "{ history.go(-" + a.ToString() + "); }";
			script += "else{location.replace('AirExportOperationSelection.aspx')}";
			script += "</script>";
			this.RegisterClientScriptBlock("Pre", script);  			
		}

		private void btnEdit_Click(object sender, System.EventArgs e)
		{
			lblError.Text = "";
			ValidationSummary1.Enabled = false;
			PerformMode(3,true);
			ValidationSummary1.Enabled = true;
		}

		private void btnDelete_Click(object sender, System.EventArgs e)
		{
			lblError.Text = "";
			ValidationSummary1.Enabled = false;
			int iPickedAmsNumber = int.Parse( ViewState["iPickedAmsNumber"].ToString());
			if(iPickedAmsNumber < 0) 
			{
				ValidationSummary1.Enabled = true;
				return;
			}
			if(PerformDelete(iPickedAmsNumber)) lblError.Text = "*" + iPickedAmsNumber.ToString() + " was successfully deleted";
			PerformMode(0,true);		
			ValidationSummary1.Enabled = true;
		}

		private bool PerformDeleteItem(int iPickedAmsNumber)
		{
            string ConnectStr = (new igFunctions.DB().getConStr());
			SqlConnection	Con = new SqlConnection(ConnectStr);
			SqlCommand		Cmd = new SqlCommand();
			Cmd.Connection = Con;

			Con.Open();			

			SqlTransaction trans = Con.BeginTransaction();

			Cmd.Transaction = trans;

			try
			{
			
				Cmd.CommandText = "DELETE ig_ocean_ams_edi_item  WHERE  elt_account_number=" + elt_account_number + " AND doc_number=" + iPickedAmsNumber.ToString();
				Cmd.ExecuteNonQuery();

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

		private bool PerformDelete(int iPickedAmsNumber)
		{

			if (!PerformDeleteItem(iPickedAmsNumber)) return false;

            string ConnectStr = (new igFunctions.DB().getConStr());
			SqlConnection Con = new SqlConnection(ConnectStr);
			SqlCommand sqlCmd = new SqlCommand();
			sqlCmd.Connection = Con;
			sqlCmd.CommandText = "DELETE ig_ocean_ams_edi_header  WHERE  elt_account_number=" + elt_account_number + " AND doc_number=" + iPickedAmsNumber.ToString();

			Con.Open();			
			SqlTransaction trans = Con.BeginTransaction();
			sqlCmd.Transaction = trans;

			try
			{
				int a = sqlCmd.ExecuteNonQuery();
				if( a< 1)
				{
					lblError.Text = "Data not found!";
					Con.Close();
					return false;					
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

		private void btnSave_Click(object sender, System.EventArgs e)
		{

			string errMsg = performDataCheck();

			if(errMsg != null) 
			{
				viewJavaMsg(errMsg);
				return;
			}

			this.btnValidation.ImageUrl = "../../../Images/mark_x.gif";

			if(btnValidation.ImageUrl == "../../../Images/mark_x.gif")
			{
				btnAMS_Send.Visible = true;
				lblAMS_Send.Visible = true;
			}
			else
			{
				btnAMS_Send.Visible = false;
				lblAMS_Send.Visible = false;
			}

			int iPickedAmsNumber = int.Parse( ViewState["iPickedAmsNumber"].ToString());
			lblError.Text = "";
			lblDocNo.Text = "";
			if (PerformSave())
			{
				PerformMode(2,true);
				lblError.Text = "*"+iPickedAmsNumber+" : was saved successfully.";
			}		

		}

		private void btnAMS_Send_Click(object sender, System.Web.UI.ImageClickEventArgs e)
		{
			
			if(btnValidation.ImageUrl == "../../../Images/mark_o.gif")
			{
				viewJavaMsg("Please mark the Data Validation.");
				return;
			}

			if(!performValidation(false)) return;

			string newLine = "\n\r";
			string strItem = null;
			string strHeader = null;
			int iPickedAmsNumber = int.Parse( ViewState["iPickedAmsNumber"].ToString());
			strItem = PerformSaveItemAMS(iPickedAmsNumber);
			if(strItem == null) 	
			{
				lblError.Text = "Error was occured when AMS sending.";
				return;
			}


			#region FindControl

			TextBox  txt_v1_vessel_code  = (TextBox)UltraWebTab1.FindControl("txt_v1_vessel_code");
			TextBox  txt_v2_voyage_number = (TextBox)UltraWebTab1.FindControl("txt_v2_voyage_number");
			TextBox  txt_v3_vessel_name = (TextBox)UltraWebTab1.FindControl("txt_v3_vessel_name");
			TextBox  txt_v4_scac_code = (TextBox)UltraWebTab1.FindControl("txt_v4_scac_code");
			DropDownList  dl_v5_vessel_flag = (DropDownList)UltraWebTab1.FindControl("dl_v5_vessel_flag");
			TextBox  txt_v5_vessel_flag = (TextBox)UltraWebTab1.FindControl("txt_v5_vessel_flag");
			DropDownList  dl_v6_first_us_port_of_discharge = (DropDownList)UltraWebTab1.FindControl("dl_v6_first_us_port_of_discharge");
			TextBox  txt_v6_first_us_port_of_discharge = (TextBox)UltraWebTab1.FindControl("txt_v6_first_us_port_of_discharge");
			TextBox  txt_v7_last_foreign_pol_s = (TextBox)UltraWebTab1.FindControl("txt_v7_last_foreign_pol_s");
			TextBox  txt_v7_last_foreign_pol = (TextBox)UltraWebTab1.FindControl("txt_v7_last_foreign_pol");
			DropDownList  dl_p1_port_of_discharge = (DropDownList)UltraWebTab1.FindControl("dl_p1_port_of_discharge");
			TextBox  txt_p1_port_of_discharge = (TextBox)UltraWebTab1.FindControl("txt_p1_port_of_discharge");
			Infragistics.WebUI.WebDataInput.WebDateTimeEdit txt_p2_estimated_date_of_arrival = (Infragistics.WebUI.WebDataInput.WebDateTimeEdit)UltraWebTab1.FindControl("txt_p2_estimated_date_of_arrival");
			TextBox  txt_p3_terminal_operator_code_s = (TextBox)UltraWebTab1.FindControl("txt_p3_terminal_operator_code_s");
			TextBox  txt_p3_terminal_operator_code = (TextBox)UltraWebTab1.FindControl("txt_p3_terminal_operator_code");
			TextBox  txt_l1_port_of_load_s = (TextBox)UltraWebTab1.FindControl("txt_l1_port_of_load_s");
			TextBox  txt_l1_port_of_load = (TextBox)UltraWebTab1.FindControl("txt_l1_port_of_load");
			Infragistics.WebUI.WebDataInput.WebDateTimeEdit  txt_l2_load_date = (Infragistics.WebUI.WebDataInput.WebDateTimeEdit)UltraWebTab1.FindControl("txt_l2_load_date");
			Infragistics.WebUI.WebDataInput.WebDateTimeEdit  txt_l3_load_time = (Infragistics.WebUI.WebDataInput.WebDateTimeEdit)UltraWebTab1.FindControl("txt_l3_load_time");
			//			TextBox  txt_creation_date = (TextBox)UltraWebTab1.FindControl("txt_creation_date");
			TextBox  txt_b1_bill_of_lading_number = (TextBox)UltraWebTab1.FindControl("txt_b1_bill_of_lading_number");
			TextBox  txt_b2_port_of_loading_s = (TextBox)UltraWebTab1.FindControl("txt_b2_port_of_loading_s");
			TextBox  txt_b2_port_of_loading = (TextBox)UltraWebTab1.FindControl("txt_b2_port_of_loading");
			TextBox  txt_b3_place_of_final_destination_s = (TextBox)UltraWebTab1.FindControl("txt_b3_place_of_final_destination_s");
			TextBox  txt_b3_place_of_final_destination = (TextBox)UltraWebTab1.FindControl("txt_b3_place_of_final_destination");
			TextBox  txt_b4_place_of_receipt = (TextBox)UltraWebTab1.FindControl("txt_b4_place_of_receipt");
			DropDownList  dl_b5_b_lading_status_code = (DropDownList)UltraWebTab1.FindControl("dl_b5_b_lading_status_code");
			TextBox  txt_b5_b_lading_status_code = (TextBox)UltraWebTab1.FindControl("txt_b5_b_lading_status_code");
			TextBox  txt_b6_b_lading_issuer_scac_code = (TextBox)UltraWebTab1.FindControl("txt_b6_b_lading_issuer_scac_code");
			TextBox  txt_b7_snp1 = (TextBox)UltraWebTab1.FindControl("txt_b7_snp1");
			TextBox  txt_b8_snp2 = (TextBox)UltraWebTab1.FindControl("txt_b8_snp2");
			TextBox  txt_b9_manifested_units = (TextBox)UltraWebTab1.FindControl("txt_b9_manifested_units");
			Infragistics.WebUI.WebDataInput.WebNumericEdit  txt_b10_total_gross_weight = (Infragistics.WebUI.WebDataInput.WebNumericEdit)UltraWebTab1.FindControl("txt_b10_total_gross_weight");
			TextBox  txt_b11_booking_number = (TextBox)UltraWebTab1.FindControl("txt_b11_booking_number");
			TextBox  txt_b12_master_ocean_bill_number = (TextBox)UltraWebTab1.FindControl("txt_b12_master_ocean_bill_number");
			TextBox  txt_b13_agency_unique_code = (TextBox)UltraWebTab1.FindControl("txt_b13_agency_unique_code");
			TextBox  txt_b14_snp3 = (TextBox)UltraWebTab1.FindControl("txt_b14_snp3");
			TextBox  txt_b15_snp4 = (TextBox)UltraWebTab1.FindControl("txt_b15_snp4");
			TextBox  txt_b16_snp5 = (TextBox)UltraWebTab1.FindControl("txt_b16_snp5");
			TextBox  txt_b17_snp6 = (TextBox)UltraWebTab1.FindControl("txt_b17_snp6");
			TextBox  txt_b18_snp7 = (TextBox)UltraWebTab1.FindControl("txt_b18_snp7");
			TextBox  txt_b19_snp8 = (TextBox)UltraWebTab1.FindControl("txt_b19_snp8");
			DropDownList  dl_b20_weight_unit = (DropDownList)UltraWebTab1.FindControl("dl_b20_weight_unit");
			TextBox  txt_b20_weight_unit = (TextBox)UltraWebTab1.FindControl("txt_b20_weight_unit");
			TextBox  txt_s1_shipper_name = (TextBox)UltraWebTab1.FindControl("txt_s1_shipper_name");
			TextBox  txt_s2_shipper_address1 = (TextBox)UltraWebTab1.FindControl("txt_s2_shipper_address1");
			TextBox  txt_s3_shipper_address2 = (TextBox)UltraWebTab1.FindControl("txt_s3_shipper_address2");
			TextBox  txt_s4_shipper_city = (TextBox)UltraWebTab1.FindControl("txt_s4_shipper_city");
			TextBox  txt_s5_shipper_state_province = (TextBox)UltraWebTab1.FindControl("txt_s5_shipper_state_province");
			TextBox  txt_s6_shipper_postal_code = (TextBox)UltraWebTab1.FindControl("txt_s6_shipper_postal_code");
			TextBox  txt_s7_shipper_telephone_fax = (TextBox)UltraWebTab1.FindControl("txt_s7_shipper_telephone_fax");
			DropDownList  dl_s8_shipper_iso_country_code = (DropDownList)UltraWebTab1.FindControl("dl_s8_shipper_iso_country_code");
			TextBox  txt_s8_shipper_iso_country_code = (TextBox)UltraWebTab1.FindControl("txt_s8_shipper_iso_country_code");
			TextBox  txt_s9_shipper_contact_name = (TextBox)UltraWebTab1.FindControl("txt_s9_shipper_contact_name");
			TextBox  txt_c1_consignee_name = (TextBox)UltraWebTab1.FindControl("txt_c1_consignee_name");
			TextBox  txt_c2_consignee_address1 = (TextBox)UltraWebTab1.FindControl("txt_c2_consignee_address1");
			TextBox  txt_c3_consignee_address2 = (TextBox)UltraWebTab1.FindControl("txt_c3_consignee_address2");
			TextBox  txt_c4_consignee_city = (TextBox)UltraWebTab1.FindControl("txt_c4_consignee_city");
			DropDownList  dl_c5_consignee_state_province = (DropDownList)UltraWebTab1.FindControl("dl_c5_consignee_state_province");
			TextBox  txt_c5_consignee_state_province = (TextBox)UltraWebTab1.FindControl("txt_c5_consignee_state_province");
			TextBox  txt_c6_consignee_postal_code = (TextBox)UltraWebTab1.FindControl("txt_c6_consignee_postal_code");
			TextBox  txt_c7_consignee_telephone_fax = (TextBox)UltraWebTab1.FindControl("txt_c7_consignee_telephone_fax");
			TextBox  txt_c8_consignee_iso_country_code = (TextBox)UltraWebTab1.FindControl("txt_c8_consignee_iso_country_code");
			TextBox  txt_c9_consignee_contact_name = (TextBox)UltraWebTab1.FindControl("txt_c9_consignee_contact_name");
			TextBox  txt_n1_notify_name = (TextBox)UltraWebTab1.FindControl("txt_n1_notify_name");
			TextBox  txt_n2_notify_address1 = (TextBox)UltraWebTab1.FindControl("txt_n2_notify_address1");
			TextBox  txt_n3_notify_address2 = (TextBox)UltraWebTab1.FindControl("txt_n3_notify_address2");
			TextBox  txt_n4_notify_city = (TextBox)UltraWebTab1.FindControl("txt_n4_notify_city");
			DropDownList  dl_n5_notify_state_province = (DropDownList)UltraWebTab1.FindControl("dl_n5_notify_state_province");
			TextBox  txt_n5_notify_state_province = (TextBox)UltraWebTab1.FindControl("txt_n5_notify_state_province");
			TextBox  txt_n6_notify_postal_code = (TextBox)UltraWebTab1.FindControl("txt_n6_notify_postal_code");
			TextBox  txt_n7_notify_telephone_fax = (TextBox)UltraWebTab1.FindControl("txt_n7_notify_telephone_fax");
			TextBox  txt_n8_notify_iso_country_code = (TextBox)UltraWebTab1.FindControl("txt_n8_notify_iso_country_code");
			TextBox  txt_n9_notify_party_contact_name = (TextBox)UltraWebTab1.FindControl("txt_n9_notify_party_contact_name");
			#endregion

			#region Header

			strHeader = "";

			strHeader	= "V"							+	"*" +  txt_v1_vessel_code.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_v2_voyage_number.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_v3_vessel_name.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_v4_scac_code.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_v5_vessel_flag.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_v6_first_us_port_of_discharge.Text.Trim();
//			strHeader	= strHeader				+	"*" +  txt_v7_last_foreign_pol_s.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_v7_last_foreign_pol.Text.Trim();
			strHeader	= strHeader	+ newLine + "P"		+	"*" +  txt_p1_port_of_discharge.Text.Trim();
			strHeader	= strHeader				+	"*" +  
				txt_p2_estimated_date_of_arrival.Date.Year.ToString().Substring(2,2) + txt_p2_estimated_date_of_arrival.Date.Month.ToString().PadLeft(2,'0') + txt_p2_estimated_date_of_arrival.Date.Day.ToString().PadLeft(2,'0');
//			strHeader	= strHeader				+	"*" +  txt_p3_terminal_operator_code_s.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_p3_terminal_operator_code.Text.Trim();
//			strHeader	= strHeader	+ newLine + "L"		+	"*" +  txt_l1_port_of_load_s.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_l1_port_of_load.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_l2_load_date.Date.Year.ToString() + txt_l2_load_date.Date.Month.ToString().PadLeft(2,'0') + txt_l2_load_date.Date.Day.ToString().PadLeft(2,'0');			
			strHeader	= strHeader				+	"*" +  txt_l3_load_time.Date.Hour.ToString().PadLeft(2,'0') + txt_l3_load_time.Date.Minute.ToString().PadLeft(2,'0') + txt_l3_load_time.Date.Second.ToString().PadLeft(2,'0');
			strHeader	= strHeader	+ newLine + "B"		+	"*" +  txt_b1_bill_of_lading_number.Text.Trim();
//			strHeader	= strHeader				+	"*" +  txt_b2_port_of_loading_s.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_b2_port_of_loading.Text.Trim();
//			strHeader	= strHeader				+	"*" +  txt_b3_place_of_final_destination_s.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_b3_place_of_final_destination.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_b4_place_of_receipt.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_b5_b_lading_status_code.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_b6_b_lading_issuer_scac_code.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_b7_snp1.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_b8_snp2.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_b9_manifested_units.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_b10_total_gross_weight.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_b11_booking_number.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_b12_master_ocean_bill_number.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_b13_agency_unique_code.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_b14_snp3.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_b15_snp4.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_b16_snp5.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_b17_snp6.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_b18_snp7.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_b19_snp8.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_b20_weight_unit.Text.Trim();
			strHeader	= strHeader	+ newLine + "S"		+	"*" +  txt_s1_shipper_name.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_s2_shipper_address1.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_s3_shipper_address2.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_s4_shipper_city.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_s5_shipper_state_province.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_s6_shipper_postal_code.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_s7_shipper_telephone_fax.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_s8_shipper_iso_country_code.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_s9_shipper_contact_name.Text.Trim();
			strHeader	= strHeader	+ newLine + "C"		+	"*" +  txt_c1_consignee_name.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_c2_consignee_address1.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_c3_consignee_address2.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_c4_consignee_city.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_c5_consignee_state_province.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_c6_consignee_postal_code.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_c7_consignee_telephone_fax.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_c8_consignee_iso_country_code.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_c9_consignee_contact_name.Text.Trim();
			strHeader	= strHeader	+ newLine + "N"		+	"*" +  txt_n1_notify_name.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_n2_notify_address1.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_n3_notify_address2.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_n4_notify_city.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_n5_notify_state_province.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_n6_notify_postal_code.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_n7_notify_telephone_fax.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_n8_notify_iso_country_code.Text.Trim();
			strHeader	= strHeader				+	"*" +  txt_n9_notify_party_contact_name.Text.Trim();

			#endregion			
			
			#region Database update for AMS sent
            string ConnectStr = (new igFunctions.DB().getConStr());
			SqlConnection Con = new SqlConnection(ConnectStr);
			SqlCommand sqlCmd = new SqlCommand();
			sqlCmd.Connection = Con;
			sqlCmd.CommandText = "UPDATE ig_ocean_ams_edi_header SET ams_sent_flag  = 'Y'" + 
				" WHERE  elt_account_number=" + elt_account_number + " AND doc_number=" + iPickedAmsNumber.ToString();
			Con.Open();			
			SqlTransaction trans = Con.BeginTransaction();
			sqlCmd.Transaction = trans;

			try
			{
				int a = sqlCmd.ExecuteNonQuery();
				if( a< 1)
				{
					lblError.Text = "Data not found!";
					Con.Close();
					return;
				}
				trans.Commit();
			}
			catch(Exception ex)
			{
				trans.Rollback();
				lblError.Text = ex.Message;
				Con.Close();
				return;
			}
			finally
			{
				Con.Close();
			}				

			#endregion


			string tmpLogDir = System.Configuration.ConfigurationSettings.AppSettings["tmpLogDirectory"];
			string strFilePathAMS = tmpLogDir+"/"+Session.SessionID.ToString()+DateTime.Now.Ticks.ToString()+ "AMS.txt";

			FileInfo file = new FileInfo(strFilePathAMS);

			StreamWriter s = file.CreateText();
			s.WriteLine(strHeader+strItem);
			s.Close();

			img_ams_sent.ImageUrl = "../../../Images/mark_x.gif";
			viewJavaMsg("AMS Data was sent successfully.");
		}


		private string PerformSaveItemAMS(int iPickedAmsNumber)
		{

			string  i1_item_number, i2_quantity, i3_net_weight,  i4_volume,  i5_package_type, i6_comodity_code,  i7_cash_value,  e1_equipment_number,
				e2_seal_number1, e3_seal_number2, e4_length, e5_width, e6_height, e7_iso_equipment, e8_type_of_service, e9_loaded_empty_total,
				e10_equipment_desc_code, d1_line_of_description, m1_line_of_marks_and_numbers, h1_hazard_code, h2_hazard_class,
				h3_hazard_description,h4_hazard_contact, h5_un_page_number, h6_flashpoint_temperature, h7_hazard_code_qualifier,h8_hazard_unit_of_measure,
				h9_negative_indigator, h10_hazard_label, h11_hazard_classification = "";
			string strItem = null;
			string newLine = "\n\r";

			foreach( UltraGridRow eRow in UltraWebGrid1.Rows )
			{
				i1_item_number = (eRow.Cells.FromKey("i1_item_number").Text ==null ? "" : eRow.Cells.FromKey("i1_item_number").Text.Trim());	
				i2_quantity= (eRow.Cells.FromKey("i2_quantity").Text ==null ? "" : eRow.Cells.FromKey("i2_quantity").Text.Trim());	
				i3_net_weight= (eRow.Cells.FromKey("i3_net_weight").Text ==null ? "" : eRow.Cells.FromKey("i3_net_weight").Text.Trim());	
				i4_volume= (eRow.Cells.FromKey("i4_volume").Text ==null ? "" : eRow.Cells.FromKey("i4_volume").Text.Trim());	
				i5_package_type= (eRow.Cells.FromKey("i5_package_type").Text ==null ? "" : eRow.Cells.FromKey("i5_package_type").Text.Trim());	
				i6_comodity_code= (eRow.Cells.FromKey("i6_comodity_code").Text ==null ? "" : eRow.Cells.FromKey("i6_comodity_code").Text.Trim());	
				i7_cash_value= (eRow.Cells.FromKey("i7_cash_value").Text ==null ? "" :eRow.Cells.FromKey("i7_cash_value").Text.Trim());	
				e1_equipment_number= (eRow.Cells.FromKey("e1_equipment_number").Text ==null ? "" : eRow.Cells.FromKey("e1_equipment_number").Text.Trim());	
				e2_seal_number1= (eRow.Cells.FromKey("e2_seal_number1").Text ==null ? "" : eRow.Cells.FromKey("e2_seal_number1").Text.Trim());	
				e3_seal_number2= (eRow.Cells.FromKey("e3_seal_number2").Text ==null ? "" : eRow.Cells.FromKey("e3_seal_number2").Text.Trim());	
				e4_length= (eRow.Cells.FromKey("e4_length").Text ==null ? "" : eRow.Cells.FromKey("e4_length").Text.Trim());	
				e5_width= (eRow.Cells.FromKey("e5_width").Text ==null ? "" : eRow.Cells.FromKey("e5_width").Text.Trim());	
				e6_height= (eRow.Cells.FromKey("e6_height").Text ==null ? "" : eRow.Cells.FromKey("e6_height").Text.Trim());		
				e7_iso_equipment= (eRow.Cells.FromKey("e7_iso_equipment").Text ==null ? "" : eRow.Cells.FromKey("e7_iso_equipment").Text.Trim());	
				e8_type_of_service= (eRow.Cells.FromKey("e8_type_of_service").Text ==null ? "" : eRow.Cells.FromKey("e8_type_of_service").Text.Trim());	
				e9_loaded_empty_total= (eRow.Cells.FromKey("e9_loaded_empty_total").Text ==null ? "" : eRow.Cells.FromKey("e9_loaded_empty_total").Text.Trim());	
				e10_equipment_desc_code= (eRow.Cells.FromKey("e10_equipment_desc_code").Text ==null ? "" : eRow.Cells.FromKey("e10_equipment_desc_code").Text.Trim());	
				d1_line_of_description= (eRow.Cells.FromKey("d1_line_of_description").Text ==null ? "" : eRow.Cells.FromKey("d1_line_of_description").Text.Trim());	
				m1_line_of_marks_and_numbers= (eRow.Cells.FromKey("m1_line_of_marks_and_numbers").Text ==null ? "" : eRow.Cells.FromKey("m1_line_of_marks_and_numbers").Text.Trim());	
				h1_hazard_code= (eRow.Cells.FromKey("h1_hazard_code").Text ==null ? "" : eRow.Cells.FromKey("h1_hazard_code").Text.Trim());	
				h2_hazard_class= (eRow.Cells.FromKey("h2_hazard_class").Text ==null ? "" : eRow.Cells.FromKey("h2_hazard_class").Text.Trim());	
				h3_hazard_description= (eRow.Cells.FromKey("h3_hazard_description").Text ==null ? "" : eRow.Cells.FromKey("h3_hazard_description").Text.Trim());	
				h4_hazard_contact= (eRow.Cells.FromKey("h4_hazard_contact").Text ==null ? "" : eRow.Cells.FromKey("h4_hazard_contact").Text.Trim());	
				h5_un_page_number= (eRow.Cells.FromKey("h5_un_page_number").Text ==null ? "" : eRow.Cells.FromKey("h5_un_page_number").Text.Trim());	
				h6_flashpoint_temperature= (eRow.Cells.FromKey("h6_flashpoint_temperature").Text ==null ? "" : eRow.Cells.FromKey("h6_flashpoint_temperature").Text.Trim());	
				h7_hazard_code_qualifier= (eRow.Cells.FromKey("h7_hazard_code_qualifier").Text ==null ? "" : eRow.Cells.FromKey("h7_hazard_code_qualifier").Text.Trim());	
				h8_hazard_unit_of_measure= (eRow.Cells.FromKey("h8_hazard_unit_of_measure").Text ==null ? "" : eRow.Cells.FromKey("h8_hazard_unit_of_measure").Text.Trim());	
				h9_negative_indigator= (eRow.Cells.FromKey("h9_negative_indigator").Text ==null ? "" : eRow.Cells.FromKey("h9_negative_indigator").Text.Trim());	
				h10_hazard_label= (eRow.Cells.FromKey("h10_hazard_label").Text ==null ? "" : eRow.Cells.FromKey("h10_hazard_label").Text.Trim());	
				h11_hazard_classification= (eRow.Cells.FromKey("h11_hazard_classification").Text ==null ? "" : eRow.Cells.FromKey("h11_hazard_classification").Text.Trim());						
				
				strItem = "";

				#region make string
				strItem	= newLine + "I"	+"*" + i1_item_number;  
				strItem	= strItem			+"*" + (i2_quantity == null ? "" : i2_quantity);
				strItem	= strItem			+"*" + (i3_net_weight == null ? "" : i3_net_weight);
				strItem	= strItem			+"*" + (i4_volume == null ? "" : i4_volume);
				strItem	= strItem			+"*" + (i5_package_type == null ? "" : i5_package_type);
				strItem	= strItem			+"*" + (i6_comodity_code == null ? "" : i6_comodity_code);
				strItem	= strItem			+"*" + (i7_cash_value == null ? "" : i7_cash_value); 
				strItem	= strItem	+ newLine + "E"	+"*" + (e1_equipment_number == null ? "" : e1_equipment_number);
				strItem	= strItem			+"*"	+ (e2_seal_number1 == null ? "" : e2_seal_number1); 
				strItem	= strItem			+"*"	+ (e3_seal_number2 == null ? "" : e3_seal_number2);
				strItem	= strItem			+"*"	+ (e4_length == null ? "" : e4_length);
				strItem	= strItem			+"*"	+ (e5_width == null ? "" : e5_width);
				strItem	= strItem			+"*"	+ (e6_height == null ? "" : e6_height);
				strItem	= strItem			+"*"	+ (e7_iso_equipment == null ? "" : e7_iso_equipment);
				strItem	= strItem			+"*"	+ (e8_type_of_service == null ? "" : e8_type_of_service);
				strItem	= strItem			+"*"	+ (e9_loaded_empty_total == null ? "" : e9_loaded_empty_total);
				strItem	= strItem			+"*"	+ (e10_equipment_desc_code == null ? "" : e10_equipment_desc_code);
				strItem	= strItem	+ newLine + "D"	+ "*" + (d1_line_of_description == null ? "" : d1_line_of_description);
				strItem	= strItem	+ newLine + "M"	+ "*" + (m1_line_of_marks_and_numbers == null ? "" : m1_line_of_marks_and_numbers);
				strItem	= strItem	+ newLine + "H"	+ "*" + (h1_hazard_code == null ? "" : h1_hazard_code);
				strItem	= strItem			+"*"	+ (h2_hazard_class == null ? "" : h2_hazard_class);
				strItem	= strItem			+"*"	+ (h3_hazard_description == null ? "" : h3_hazard_description);
				strItem	= strItem			+"*"	+ (h4_hazard_contact == null ? "" : h4_hazard_contact);
				strItem	= strItem			+"*"	+ (h5_un_page_number == null ? "" : h5_un_page_number);
				strItem	= strItem			+"*"	+ (h6_flashpoint_temperature == null ? "" : h6_flashpoint_temperature);
				strItem	= strItem			+"*"	+ (h7_hazard_code_qualifier == null ? "" : h7_hazard_code_qualifier);
				strItem	= strItem			+"*"	+ (h8_hazard_unit_of_measure == null ? "" : h8_hazard_unit_of_measure);
				strItem	= strItem			+"*"	+ (h9_negative_indigator == null ? "" : h9_negative_indigator);
				strItem	= strItem			+"*"	+ (h10_hazard_label == null ? "" : h10_hazard_label);
				strItem	= strItem			+"*"	+  (h11_hazard_classification == null ? "" : h11_hazard_classification);
				#endregion
			}

			return strItem;

		}



		private bool PerformSave()
		{

			int iPickedAmsNumber = int.Parse( ViewState["iPickedAmsNumber"].ToString());
			if (!PerformSaveItem(iPickedAmsNumber)) return false;


			#region FindControl

			TextBox  txt_v1_vessel_code  = (TextBox)UltraWebTab1.FindControl("txt_v1_vessel_code");
			TextBox  txt_v2_voyage_number = (TextBox)UltraWebTab1.FindControl("txt_v2_voyage_number");
			TextBox  txt_v3_vessel_name = (TextBox)UltraWebTab1.FindControl("txt_v3_vessel_name");
			TextBox  txt_v4_scac_code = (TextBox)UltraWebTab1.FindControl("txt_v4_scac_code");
			DropDownList  dl_v5_vessel_flag = (DropDownList)UltraWebTab1.FindControl("dl_v5_vessel_flag");
			TextBox  txt_v5_vessel_flag = (TextBox)UltraWebTab1.FindControl("txt_v5_vessel_flag");
			DropDownList  dl_v6_first_us_port_of_discharge = (DropDownList)UltraWebTab1.FindControl("dl_v6_first_us_port_of_discharge");
			TextBox  txt_v6_first_us_port_of_discharge = (TextBox)UltraWebTab1.FindControl("txt_v6_first_us_port_of_discharge");
			TextBox  txt_v7_last_foreign_pol_s = (TextBox)UltraWebTab1.FindControl("txt_v7_last_foreign_pol_s");
			TextBox  txt_v7_last_foreign_pol = (TextBox)UltraWebTab1.FindControl("txt_v7_last_foreign_pol");
			DropDownList  dl_p1_port_of_discharge = (DropDownList)UltraWebTab1.FindControl("dl_p1_port_of_discharge");
			TextBox  txt_p1_port_of_discharge = (TextBox)UltraWebTab1.FindControl("txt_p1_port_of_discharge");
			Infragistics.WebUI.WebDataInput.WebDateTimeEdit txt_p2_estimated_date_of_arrival = (Infragistics.WebUI.WebDataInput.WebDateTimeEdit)UltraWebTab1.FindControl("txt_p2_estimated_date_of_arrival");
			TextBox  txt_p3_terminal_operator_code_s = (TextBox)UltraWebTab1.FindControl("txt_p3_terminal_operator_code_s");
			TextBox  txt_p3_terminal_operator_code = (TextBox)UltraWebTab1.FindControl("txt_p3_terminal_operator_code");
			TextBox  txt_l1_port_of_load_s = (TextBox)UltraWebTab1.FindControl("txt_l1_port_of_load_s");
			TextBox  txt_l1_port_of_load = (TextBox)UltraWebTab1.FindControl("txt_l1_port_of_load");
			Infragistics.WebUI.WebDataInput.WebDateTimeEdit  txt_l2_load_date = (Infragistics.WebUI.WebDataInput.WebDateTimeEdit)UltraWebTab1.FindControl("txt_l2_load_date");
			Infragistics.WebUI.WebDataInput.WebDateTimeEdit  txt_l3_load_time = (Infragistics.WebUI.WebDataInput.WebDateTimeEdit)UltraWebTab1.FindControl("txt_l3_load_time");
//			TextBox  txt_creation_date = (TextBox)UltraWebTab1.FindControl("txt_creation_date");
			TextBox  txt_b1_bill_of_lading_number = (TextBox)UltraWebTab1.FindControl("txt_b1_bill_of_lading_number");
			TextBox  txt_b2_port_of_loading_s = (TextBox)UltraWebTab1.FindControl("txt_b2_port_of_loading_s");
			TextBox  txt_b2_port_of_loading = (TextBox)UltraWebTab1.FindControl("txt_b2_port_of_loading");
			TextBox  txt_b3_place_of_final_destination_s = (TextBox)UltraWebTab1.FindControl("txt_b3_place_of_final_destination_s");
			TextBox  txt_b3_place_of_final_destination = (TextBox)UltraWebTab1.FindControl("txt_b3_place_of_final_destination");
			TextBox  txt_b4_place_of_receipt = (TextBox)UltraWebTab1.FindControl("txt_b4_place_of_receipt");
			DropDownList  dl_b5_b_lading_status_code = (DropDownList)UltraWebTab1.FindControl("dl_b5_b_lading_status_code");
			TextBox  txt_b5_b_lading_status_code = (TextBox)UltraWebTab1.FindControl("txt_b5_b_lading_status_code");
			TextBox  txt_b6_b_lading_issuer_scac_code = (TextBox)UltraWebTab1.FindControl("txt_b6_b_lading_issuer_scac_code");
			TextBox  txt_b7_snp1 = (TextBox)UltraWebTab1.FindControl("txt_b7_snp1");
			TextBox  txt_b8_snp2 = (TextBox)UltraWebTab1.FindControl("txt_b8_snp2");
			TextBox  txt_b9_manifested_units = (TextBox)UltraWebTab1.FindControl("txt_b9_manifested_units");
			Infragistics.WebUI.WebDataInput.WebNumericEdit  txt_b10_total_gross_weight = (Infragistics.WebUI.WebDataInput.WebNumericEdit)UltraWebTab1.FindControl("txt_b10_total_gross_weight");
			TextBox  txt_b11_booking_number = (TextBox)UltraWebTab1.FindControl("txt_b11_booking_number");
			TextBox  txt_b12_master_ocean_bill_number = (TextBox)UltraWebTab1.FindControl("txt_b12_master_ocean_bill_number");
			TextBox  txt_b13_agency_unique_code = (TextBox)UltraWebTab1.FindControl("txt_b13_agency_unique_code");
			TextBox  txt_b14_snp3 = (TextBox)UltraWebTab1.FindControl("txt_b14_snp3");
			TextBox  txt_b15_snp4 = (TextBox)UltraWebTab1.FindControl("txt_b15_snp4");
			TextBox  txt_b16_snp5 = (TextBox)UltraWebTab1.FindControl("txt_b16_snp5");
			TextBox  txt_b17_snp6 = (TextBox)UltraWebTab1.FindControl("txt_b17_snp6");
			TextBox  txt_b18_snp7 = (TextBox)UltraWebTab1.FindControl("txt_b18_snp7");
			TextBox  txt_b19_snp8 = (TextBox)UltraWebTab1.FindControl("txt_b19_snp8");
			DropDownList  dl_b20_weight_unit = (DropDownList)UltraWebTab1.FindControl("dl_b20_weight_unit");
			TextBox  txt_b20_weight_unit = (TextBox)UltraWebTab1.FindControl("txt_b20_weight_unit");
			TextBox  txt_s1_shipper_name = (TextBox)UltraWebTab1.FindControl("txt_s1_shipper_name");
			TextBox  txt_s2_shipper_address1 = (TextBox)UltraWebTab1.FindControl("txt_s2_shipper_address1");
			TextBox  txt_s3_shipper_address2 = (TextBox)UltraWebTab1.FindControl("txt_s3_shipper_address2");
			TextBox  txt_s4_shipper_city = (TextBox)UltraWebTab1.FindControl("txt_s4_shipper_city");
			TextBox  txt_s5_shipper_state_province = (TextBox)UltraWebTab1.FindControl("txt_s5_shipper_state_province");
			TextBox  txt_s6_shipper_postal_code = (TextBox)UltraWebTab1.FindControl("txt_s6_shipper_postal_code");
			TextBox  txt_s7_shipper_telephone_fax = (TextBox)UltraWebTab1.FindControl("txt_s7_shipper_telephone_fax");
			DropDownList  dl_s8_shipper_iso_country_code = (DropDownList)UltraWebTab1.FindControl("dl_s8_shipper_iso_country_code");
			TextBox  txt_s8_shipper_iso_country_code = (TextBox)UltraWebTab1.FindControl("txt_s8_shipper_iso_country_code");
			TextBox  txt_s9_shipper_contact_name = (TextBox)UltraWebTab1.FindControl("txt_s9_shipper_contact_name");
			TextBox  txt_c1_consignee_name = (TextBox)UltraWebTab1.FindControl("txt_c1_consignee_name");
			TextBox  txt_c2_consignee_address1 = (TextBox)UltraWebTab1.FindControl("txt_c2_consignee_address1");
			TextBox  txt_c3_consignee_address2 = (TextBox)UltraWebTab1.FindControl("txt_c3_consignee_address2");
			TextBox  txt_c4_consignee_city = (TextBox)UltraWebTab1.FindControl("txt_c4_consignee_city");
			DropDownList  dl_c5_consignee_state_province = (DropDownList)UltraWebTab1.FindControl("dl_c5_consignee_state_province");
			TextBox  txt_c5_consignee_state_province = (TextBox)UltraWebTab1.FindControl("txt_c5_consignee_state_province");
			TextBox  txt_c6_consignee_postal_code = (TextBox)UltraWebTab1.FindControl("txt_c6_consignee_postal_code");
			TextBox  txt_c7_consignee_telephone_fax = (TextBox)UltraWebTab1.FindControl("txt_c7_consignee_telephone_fax");
			TextBox  txt_c8_consignee_iso_country_code = (TextBox)UltraWebTab1.FindControl("txt_c8_consignee_iso_country_code");
			TextBox  txt_c9_consignee_contact_name = (TextBox)UltraWebTab1.FindControl("txt_c9_consignee_contact_name");
			TextBox  txt_n1_notify_name = (TextBox)UltraWebTab1.FindControl("txt_n1_notify_name");
			TextBox  txt_n2_notify_address1 = (TextBox)UltraWebTab1.FindControl("txt_n2_notify_address1");
			TextBox  txt_n3_notify_address2 = (TextBox)UltraWebTab1.FindControl("txt_n3_notify_address2");
			TextBox  txt_n4_notify_city = (TextBox)UltraWebTab1.FindControl("txt_n4_notify_city");
			DropDownList  dl_n5_notify_state_province = (DropDownList)UltraWebTab1.FindControl("dl_n5_notify_state_province");
			TextBox  txt_n5_notify_state_province = (TextBox)UltraWebTab1.FindControl("txt_n5_notify_state_province");
			TextBox  txt_n6_notify_postal_code = (TextBox)UltraWebTab1.FindControl("txt_n6_notify_postal_code");
			TextBox  txt_n7_notify_telephone_fax = (TextBox)UltraWebTab1.FindControl("txt_n7_notify_telephone_fax");
			TextBox  txt_n8_notify_iso_country_code = (TextBox)UltraWebTab1.FindControl("txt_n8_notify_iso_country_code");
			TextBox  txt_n9_notify_party_contact_name = (TextBox)UltraWebTab1.FindControl("txt_n9_notify_party_contact_name");
			#endregion
            string ConnectStr = (new igFunctions.DB().getConStr());
			SqlConnection Con = new SqlConnection(ConnectStr);

			#region ig_up_ig_ocean_ams_edi_header_update

			SqlCommand sqlCmd = new SqlCommand("dbo.ig_up_ig_ocean_ams_edi_header_update", Con);
			sqlCmd.CommandType = CommandType.StoredProcedure;

            sqlCmd.Parameters.Add("@elt_account_number",SqlDbType.Decimal, 9);
            sqlCmd.Parameters.Add("@doc_number",SqlDbType.Decimal, 9);
            sqlCmd.Parameters.Add("@v1_vessel_code",SqlDbType.Char, 7);
            sqlCmd.Parameters.Add("@v2_voyage_number",SqlDbType.Char, 5);
            sqlCmd.Parameters.Add("@v3_vessel_name",SqlDbType.Char, 23);
            sqlCmd.Parameters.Add("@v4_scac_code",SqlDbType.Char, 4);
            sqlCmd.Parameters.Add("@v5_vessel_flag",SqlDbType.Char, 2);
            sqlCmd.Parameters.Add("@v6_first_us_port_of_discharge",SqlDbType.Char, 5);
            sqlCmd.Parameters.Add("@v7_last_foreign_pol_s",SqlDbType.Char, 32);
            sqlCmd.Parameters.Add("@v7_last_foreign_pol",SqlDbType.Char, 5);
            sqlCmd.Parameters.Add("@p1_port_of_discharge",SqlDbType.Char, 5);
            sqlCmd.Parameters.Add("@p2_estimated_date_of_arrival",SqlDbType.DateTime, 8);
            sqlCmd.Parameters.Add("@p3_terminal_operator_code_s",SqlDbType.Char, 32);
            sqlCmd.Parameters.Add("@p3_terminal_operator_code",SqlDbType.Char, 5);
            sqlCmd.Parameters.Add("@l1_port_of_load_s",SqlDbType.Char, 32);
            sqlCmd.Parameters.Add("@l1_port_of_load",SqlDbType.Char, 5);
            sqlCmd.Parameters.Add("@l2_load_date",SqlDbType.DateTime, 8);
            sqlCmd.Parameters.Add("@l3_load_time",SqlDbType.SmallDateTime, 4);
            sqlCmd.Parameters.Add("@creation_date",SqlDbType.DateTime, 8);
			sqlCmd.Parameters.Add("@b1_bill_of_lading_number",SqlDbType.Char, 12);
			sqlCmd.Parameters.Add("@b2_port_of_loading_s",SqlDbType.Char, 32);
			sqlCmd.Parameters.Add("@b2_port_of_loading",SqlDbType.Char, 5);
			sqlCmd.Parameters.Add("@b3_place_of_final_destination_s",SqlDbType.Char, 32);
			sqlCmd.Parameters.Add("@b3_place_of_final_destination",SqlDbType.Char, 5);
			sqlCmd.Parameters.Add("@b4_place_of_receipt",SqlDbType.Char, 17);
			sqlCmd.Parameters.Add("@b5_b_lading_status_code",SqlDbType.Char, 1);
			sqlCmd.Parameters.Add("@b6_b_lading_issuer_scac_code",SqlDbType.Char, 4);
			sqlCmd.Parameters.Add("@b7_snp1",SqlDbType.Char, 4);
			sqlCmd.Parameters.Add("@b8_snp2",SqlDbType.Char, 4);
			sqlCmd.Parameters.Add("@b9_manifested_units",SqlDbType.Char, 5);
			sqlCmd.Parameters.Add("@b10_total_gross_weight",SqlDbType.NChar, 20);
			sqlCmd.Parameters.Add("@b11_booking_number",SqlDbType.Char, 30);
			sqlCmd.Parameters.Add("@b12_master_ocean_bill_number",SqlDbType.Char, 16);
			sqlCmd.Parameters.Add("@b13_agency_unique_code",SqlDbType.Char, 5);
			sqlCmd.Parameters.Add("@b14_snp3",SqlDbType.Char, 4);
			sqlCmd.Parameters.Add("@b15_snp4",SqlDbType.Char, 4);
			sqlCmd.Parameters.Add("@b16_snp5",SqlDbType.Char, 4);
			sqlCmd.Parameters.Add("@b17_snp6",SqlDbType.Char, 4);
			sqlCmd.Parameters.Add("@b18_snp7",SqlDbType.Char, 4);
			sqlCmd.Parameters.Add("@b19_snp8",SqlDbType.Char, 4);
			sqlCmd.Parameters.Add("@b20_weight_unit",SqlDbType.Char, 2);
			sqlCmd.Parameters.Add("@s1_shipper_name",SqlDbType.Char, 35);
			sqlCmd.Parameters.Add("@s2_shipper_address1",SqlDbType.Char, 35);
			sqlCmd.Parameters.Add("@s3_shipper_address2",SqlDbType.Char, 35);
			sqlCmd.Parameters.Add("@s4_shipper_city",SqlDbType.Char, 19);
			sqlCmd.Parameters.Add("@s5_shipper_state_province",SqlDbType.Char, 2);
			sqlCmd.Parameters.Add("@s6_shipper_postal_code",SqlDbType.NChar, 20);
			sqlCmd.Parameters.Add("@s7_shipper_telephone_fax",SqlDbType.Char, 35);
			sqlCmd.Parameters.Add("@s8_shipper_iso_country_code",SqlDbType.Char, 2);
			sqlCmd.Parameters.Add("@s9_shipper_contact_name",SqlDbType.Char, 35);
			sqlCmd.Parameters.Add("@c1_consignee_name",SqlDbType.Char, 35);
			sqlCmd.Parameters.Add("@c2_consignee_address1",SqlDbType.Char, 35);
			sqlCmd.Parameters.Add("@c3_consignee_address2",SqlDbType.Char, 35);
			sqlCmd.Parameters.Add("@c4_consignee_city",SqlDbType.Char, 19);
			sqlCmd.Parameters.Add("@c5_consignee_state_province",SqlDbType.Char, 2);
			sqlCmd.Parameters.Add("@c6_consignee_postal_code",SqlDbType.Char, 9);
			sqlCmd.Parameters.Add("@c7_consignee_telephone_fax",SqlDbType.Char, 35);
			sqlCmd.Parameters.Add("@c8_consignee_iso_country_code",SqlDbType.Char, 2);
			sqlCmd.Parameters.Add("@c9_consignee_contact_name",SqlDbType.Char, 35);
			sqlCmd.Parameters.Add("@n1_notify_name",SqlDbType.Char, 35);
			sqlCmd.Parameters.Add("@n2_notify_address1",SqlDbType.Char, 35);
			sqlCmd.Parameters.Add("@n3_notify_address2",SqlDbType.Char, 35);
			sqlCmd.Parameters.Add("@n4_notify_city",SqlDbType.Char, 19);
			sqlCmd.Parameters.Add("@n5_notify_state_province",SqlDbType.Char, 2);
			sqlCmd.Parameters.Add("@n6_notify_postal_code",SqlDbType.NChar, 18);
			sqlCmd.Parameters.Add("@n7_notify_telephone_fax",SqlDbType.Char, 35);
			sqlCmd.Parameters.Add("@n8_notify_iso_country_code",SqlDbType.Char, 2);
			sqlCmd.Parameters.Add("@n9_notify_party_contact_name",SqlDbType.Char, 35);
			sqlCmd.Parameters.Add("@ams_sent_flag",SqlDbType.Char, 1);

            sqlCmd.Parameters[0].Value = elt_account_number;
            sqlCmd.Parameters[1].Value = txt_doc_number.Text;
            sqlCmd.Parameters[2].Value = txt_v1_vessel_code.Text;
            sqlCmd.Parameters[3].Value = txt_v2_voyage_number.Text;
            sqlCmd.Parameters[4].Value = txt_v3_vessel_name.Text;
            sqlCmd.Parameters[5].Value = txt_v4_scac_code.Text;
            sqlCmd.Parameters[6].Value = txt_v5_vessel_flag.Text;
            sqlCmd.Parameters[7].Value = txt_v6_first_us_port_of_discharge.Text;
            sqlCmd.Parameters[8].Value = txt_v7_last_foreign_pol_s.Text;
            sqlCmd.Parameters[9].Value = txt_v7_last_foreign_pol.Text;
            sqlCmd.Parameters[10].Value = txt_p1_port_of_discharge.Text;
            sqlCmd.Parameters[11].Value = txt_p2_estimated_date_of_arrival.Text;
            sqlCmd.Parameters[12].Value = txt_p3_terminal_operator_code_s.Text;
            sqlCmd.Parameters[13].Value = txt_p3_terminal_operator_code.Text;
            sqlCmd.Parameters[14].Value = txt_l1_port_of_load_s.Text;
            sqlCmd.Parameters[15].Value = txt_l1_port_of_load.Text;
            sqlCmd.Parameters[16].Value = txt_l2_load_date.Date.ToShortDateString();
            sqlCmd.Parameters[17].Value = txt_l3_load_time.Date;
            sqlCmd.Parameters[18].Value = DateTime.Now;
			sqlCmd.Parameters[19].Value = txt_b1_bill_of_lading_number.Text;
			sqlCmd.Parameters[20].Value = txt_b2_port_of_loading_s.Text;
			sqlCmd.Parameters[21].Value = txt_b2_port_of_loading.Text;
			sqlCmd.Parameters[22].Value = txt_b3_place_of_final_destination_s.Text;
			sqlCmd.Parameters[23].Value = txt_b3_place_of_final_destination.Text;
			sqlCmd.Parameters[24].Value = txt_b4_place_of_receipt.Text;
			sqlCmd.Parameters[25].Value = txt_b5_b_lading_status_code.Text;
			sqlCmd.Parameters[26].Value = txt_b6_b_lading_issuer_scac_code.Text;
			sqlCmd.Parameters[27].Value = txt_b7_snp1.Text;
			sqlCmd.Parameters[28].Value = txt_b8_snp2.Text;
			sqlCmd.Parameters[29].Value = txt_b9_manifested_units.Text;
			sqlCmd.Parameters[30].Value = txt_b10_total_gross_weight.Text;
			sqlCmd.Parameters[31].Value = txt_b11_booking_number.Text;
			sqlCmd.Parameters[32].Value = txt_b12_master_ocean_bill_number.Text;
			sqlCmd.Parameters[33].Value = txt_b13_agency_unique_code.Text;
			sqlCmd.Parameters[34].Value = txt_b14_snp3.Text;
			sqlCmd.Parameters[35].Value = txt_b15_snp4.Text;
			sqlCmd.Parameters[36].Value = txt_b16_snp5.Text;
			sqlCmd.Parameters[37].Value = txt_b17_snp6.Text;
			sqlCmd.Parameters[38].Value = txt_b18_snp7.Text;
			sqlCmd.Parameters[39].Value = txt_b19_snp8.Text;
			sqlCmd.Parameters[40].Value = txt_b20_weight_unit.Text;
			sqlCmd.Parameters[41].Value = txt_s1_shipper_name.Text;
			sqlCmd.Parameters[42].Value = txt_s2_shipper_address1.Text;
			sqlCmd.Parameters[43].Value = txt_s3_shipper_address2.Text;
			sqlCmd.Parameters[44].Value = txt_s4_shipper_city.Text;
			sqlCmd.Parameters[45].Value = txt_s5_shipper_state_province.Text;
			sqlCmd.Parameters[46].Value = txt_s6_shipper_postal_code.Text;
			sqlCmd.Parameters[47].Value = txt_s7_shipper_telephone_fax.Text;
			sqlCmd.Parameters[48].Value = txt_s8_shipper_iso_country_code.Text;
			sqlCmd.Parameters[49].Value = txt_s9_shipper_contact_name.Text;
			sqlCmd.Parameters[50].Value = txt_c1_consignee_name.Text;
			sqlCmd.Parameters[51].Value = txt_c2_consignee_address1.Text;
			sqlCmd.Parameters[52].Value = txt_c3_consignee_address2.Text;
			sqlCmd.Parameters[53].Value = txt_c4_consignee_city.Text;
			sqlCmd.Parameters[54].Value = txt_c5_consignee_state_province.Text;
			sqlCmd.Parameters[55].Value = txt_c6_consignee_postal_code.Text;
			sqlCmd.Parameters[56].Value = txt_c7_consignee_telephone_fax.Text;
			sqlCmd.Parameters[57].Value = txt_c8_consignee_iso_country_code.Text;
			sqlCmd.Parameters[58].Value = txt_c9_consignee_contact_name.Text;
			sqlCmd.Parameters[59].Value = txt_n1_notify_name.Text;
			sqlCmd.Parameters[60].Value = txt_n2_notify_address1.Text;
			sqlCmd.Parameters[61].Value = txt_n3_notify_address2.Text;
			sqlCmd.Parameters[62].Value = txt_n4_notify_city.Text;
			sqlCmd.Parameters[63].Value = txt_n5_notify_state_province.Text;
			sqlCmd.Parameters[64].Value = txt_n6_notify_postal_code.Text;
			sqlCmd.Parameters[65].Value = txt_n7_notify_telephone_fax.Text;
			sqlCmd.Parameters[66].Value = txt_n8_notify_iso_country_code.Text;
			sqlCmd.Parameters[67].Value = txt_n9_notify_party_contact_name.Text;

			if (img_ams_sent.ImageUrl == "../../../Images/mark_x.gif") 
			{
				sqlCmd.Parameters[68].Value = "Y";
			}
			else
			{
				sqlCmd.Parameters[68].Value = "N";
			}

			Con.Open();			
			SqlTransaction trans = Con.BeginTransaction();
			sqlCmd.Transaction = trans;

			try
			{
				int i = sqlCmd.ExecuteNonQuery();
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

			#endregion			

		return true;
		}
		

		private bool PerformSaveItem(int iPickedAmsNumber)
		{
			string strInsert=@" INSERT INTO     ig_ocean_ams_edi_item  
											   (
												elt_account_number,
												doc_number,
												i1_item_number,
												i2_quantity,
												i3_net_weight,
												i4_volume,
												i5_package_type,
												i6_comodity_code,
												i7_cash_value,
												e1_equipment_number,
												e2_seal_number1,
												e3_seal_number2,
												e4_length,
												e5_width,
												e6_height,
												e7_iso_equipment,
												e8_type_of_service,
												e9_loaded_empty_total,
												e10_equipment_desc_code,
												d1_line_of_description,
												m1_line_of_marks_and_numbers,
												h1_hazard_code,
												h2_hazard_class,
												h3_hazard_description,
												h4_hazard_contact,
												h5_un_page_number,
												h6_flashpoint_temperature,
												h7_hazard_code_qualifier,
												h8_hazard_unit_of_measure,
												h9_negative_indigator,
												h10_hazard_label,
												h11_hazard_classification
												)
										VALUES  
											   (
												@elt_account_number,
												@doc_number,
												@i1_item_number,
												@i2_quantity,
												@i3_net_weight,
												@i4_volume,
												@i5_package_type,
												@i6_comodity_code,
												@i7_cash_value,
												@e1_equipment_number,
												@e2_seal_number1,
												@e3_seal_number2,
												@e4_length,
												@e5_width,
												@e6_height,
												@e7_iso_equipment,
												@e8_type_of_service,
												@e9_loaded_empty_total,
												@e10_equipment_desc_code,
												@d1_line_of_description,
												@m1_line_of_marks_and_numbers,
												@h1_hazard_code,
												@h2_hazard_class,
												@h3_hazard_description,
												@h4_hazard_contact,
												@h5_un_page_number,
												@h6_flashpoint_temperature,
												@h7_hazard_code_qualifier,
												@h8_hazard_unit_of_measure,
												@h9_negative_indigator,
												@h10_hazard_label,
												@h11_hazard_classification
												)";

			string  i1_item_number, i2_quantity, i3_net_weight,  i4_volume,  i5_package_type, i6_comodity_code,  i7_cash_value,  e1_equipment_number,
				e2_seal_number1, e3_seal_number2, e4_length, e5_width, e6_height, e7_iso_equipment, e8_type_of_service, e9_loaded_empty_total,
				e10_equipment_desc_code, d1_line_of_description, m1_line_of_marks_and_numbers, h1_hazard_code, h2_hazard_class,
				h3_hazard_description,h4_hazard_contact, h5_un_page_number, h6_flashpoint_temperature, h7_hazard_code_qualifier,h8_hazard_unit_of_measure,
				h9_negative_indigator, h10_hazard_label, h11_hazard_classification = "";

            string ConnectStr = (new igFunctions.DB().getConStr());
			SqlConnection	Con = new SqlConnection(ConnectStr);
			SqlCommand		Cmd = new SqlCommand();
			Cmd.Connection = Con;

			Con.Open();			

			SqlTransaction trans = Con.BeginTransaction();

			Cmd.Transaction = trans;

			try
			{
			
				Cmd.CommandText = "DELETE ig_ocean_ams_edi_item  WHERE  elt_account_number=" + elt_account_number + " AND doc_number=" + txt_doc_number.Text;
				Cmd.ExecuteNonQuery();

				Cmd.CommandText = strInsert;

				foreach( UltraGridRow eRow in UltraWebGrid1.Rows )
				{
					i1_item_number = eRow.Cells.FromKey("i1_item_number").Text;
					i2_quantity= eRow.Cells.FromKey("i2_quantity").Text;
					i3_net_weight= eRow.Cells.FromKey("i3_net_weight").Text;
					i4_volume= eRow.Cells.FromKey("i4_volume").Text;
					i5_package_type= eRow.Cells.FromKey("i5_package_type").Text;
					i6_comodity_code= eRow.Cells.FromKey("i6_comodity_code").Text;
					i7_cash_value= eRow.Cells.FromKey("i7_cash_value").Text;
					e1_equipment_number= eRow.Cells.FromKey("e1_equipment_number").Text;
					e2_seal_number1= eRow.Cells.FromKey("e2_seal_number1").Text;
					e3_seal_number2= eRow.Cells.FromKey("e3_seal_number2").Text;
					e4_length= eRow.Cells.FromKey("e4_length").Text;
					e5_width= eRow.Cells.FromKey("e5_width").Text;
					e6_height= eRow.Cells.FromKey("e6_height").Text;
					e7_iso_equipment= eRow.Cells.FromKey("e7_iso_equipment").Text;
					e8_type_of_service= eRow.Cells.FromKey("e8_type_of_service").Text;
					e9_loaded_empty_total= eRow.Cells.FromKey("e9_loaded_empty_total").Text;
					e10_equipment_desc_code= eRow.Cells.FromKey("e10_equipment_desc_code").Text;
					d1_line_of_description= eRow.Cells.FromKey("d1_line_of_description").Text;
					m1_line_of_marks_and_numbers= eRow.Cells.FromKey("m1_line_of_marks_and_numbers").Text;
					h1_hazard_code= eRow.Cells.FromKey("h1_hazard_code").Text;
					h2_hazard_class= eRow.Cells.FromKey("h2_hazard_class").Text;
					h3_hazard_description= eRow.Cells.FromKey("h3_hazard_description").Text;
					h4_hazard_contact= eRow.Cells.FromKey("h4_hazard_contact").Text;
					h5_un_page_number= eRow.Cells.FromKey("h5_un_page_number").Text;
					h6_flashpoint_temperature= eRow.Cells.FromKey("h6_flashpoint_temperature").Text;
					h7_hazard_code_qualifier= eRow.Cells.FromKey("h7_hazard_code_qualifier").Text;
					h8_hazard_unit_of_measure= eRow.Cells.FromKey("h8_hazard_unit_of_measure").Text;
					h9_negative_indigator= eRow.Cells.FromKey("h9_negative_indigator").Text;
					h10_hazard_label= eRow.Cells.FromKey("h10_hazard_label").Text;
					h11_hazard_classification= eRow.Cells.FromKey("h11_hazard_classification").Text;					
				
					#region Parameter ADD
					Cmd.Parameters.Clear();
                    Cmd.Parameters.Add("@elt_account_number",SqlDbType.Decimal, 9);
                    Cmd.Parameters.Add("@doc_number",SqlDbType.Decimal, 9);
                    Cmd.Parameters.Add("@i1_item_number",SqlDbType.NChar, 6);
                    Cmd.Parameters.Add("@i2_quantity",SqlDbType.NChar, 20);
                    Cmd.Parameters.Add("@i3_net_weight",SqlDbType.NChar, 20);
                    Cmd.Parameters.Add("@i4_volume",SqlDbType.NChar, 20);
                    Cmd.Parameters.Add("@i5_package_type",SqlDbType.Char, 3);
                    Cmd.Parameters.Add("@i6_comodity_code",SqlDbType.NChar, 22);
                    Cmd.Parameters.Add("@i7_cash_value",SqlDbType.NChar, 16);
                    Cmd.Parameters.Add("@e1_equipment_number",SqlDbType.Char, 14);
                    Cmd.Parameters.Add("@e2_seal_number1",SqlDbType.Char, 15);
                    Cmd.Parameters.Add("@e3_seal_number2",SqlDbType.Char, 15);
                    Cmd.Parameters.Add("@e4_length",SqlDbType.NChar, 10);
                    Cmd.Parameters.Add("@e5_width",SqlDbType.Char, 8);
                    Cmd.Parameters.Add("@e6_height",SqlDbType.Char, 8);
                    Cmd.Parameters.Add("@e7_iso_equipment",SqlDbType.Char, 4);
                    Cmd.Parameters.Add("@e8_type_of_service",SqlDbType.Char, 2);
                    Cmd.Parameters.Add("@e9_loaded_empty_total",SqlDbType.Char, 1);
                    Cmd.Parameters.Add("@e10_equipment_desc_code",SqlDbType.Char, 2);
                    Cmd.Parameters.Add("@d1_line_of_description",SqlDbType.Char, 45);
                    Cmd.Parameters.Add("@m1_line_of_marks_and_numbers",SqlDbType.Char, 45);
                    Cmd.Parameters.Add("@h1_hazard_code",SqlDbType.Char, 10);
                    Cmd.Parameters.Add("@h2_hazard_class",SqlDbType.Char, 4);
                    Cmd.Parameters.Add("@h3_hazard_description",SqlDbType.Char, 30);
                    Cmd.Parameters.Add("@h4_hazard_contact",SqlDbType.Char, 24);
                    Cmd.Parameters.Add("@h5_un_page_number",SqlDbType.Char, 6);
                    Cmd.Parameters.Add("@h6_flashpoint_temperature",SqlDbType.NChar, 6);
                    Cmd.Parameters.Add("@h7_hazard_code_qualifier",SqlDbType.Char, 1);
                    Cmd.Parameters.Add("@h8_hazard_unit_of_measure",SqlDbType.Char, 2);
                    Cmd.Parameters.Add("@h9_negative_indigator",SqlDbType.Char, 1);
                    Cmd.Parameters.Add("@h10_hazard_label",SqlDbType.Char, 30);
                    Cmd.Parameters.Add("@h11_hazard_classification",SqlDbType.Char, 30);
					#endregion
					#region set Value
                    Cmd.Parameters[0].Value	= elt_account_number;
                    Cmd.Parameters[1].Value	= txt_doc_number.Text; 
                    Cmd.Parameters[2].Value	= i1_item_number;  
                    Cmd.Parameters[3].Value	= (i2_quantity == null ? "" : i2_quantity);
                    Cmd.Parameters[4].Value	= (i3_net_weight == null ? "" : i3_net_weight);
                    Cmd.Parameters[5].Value	= (i4_volume == null ? "" : i4_volume);
                    Cmd.Parameters[6].Value	= (i5_package_type == null ? "" : i5_package_type);
                    Cmd.Parameters[7].Value	= (i6_comodity_code == null ? "" : i6_comodity_code);
                    Cmd.Parameters[8].Value	=	(i7_cash_value == null ? "" : i7_cash_value); 
                    Cmd.Parameters[9].Value	=	(e1_equipment_number == null ? "" : e1_equipment_number);
                    Cmd.Parameters[10].Value = (e2_seal_number1 == null ? "" : e2_seal_number1); 
                    Cmd.Parameters[11].Value = (e3_seal_number2 == null ? "" : e3_seal_number2);
                    Cmd.Parameters[12].Value = (e4_length == null ? "" : e4_length);
                    Cmd.Parameters[13].Value = (e5_width == null ? "" : e5_width);
                    Cmd.Parameters[14].Value = (e6_height == null ? "" : e6_height);
                    Cmd.Parameters[15].Value = (e7_iso_equipment == null ? "" : e7_iso_equipment);
                    Cmd.Parameters[16].Value = (e8_type_of_service == null ? "" : e8_type_of_service);
                    Cmd.Parameters[17].Value = (e9_loaded_empty_total == null ? "" : e9_loaded_empty_total);
                    Cmd.Parameters[18].Value = (e10_equipment_desc_code == null ? "" : e10_equipment_desc_code);
                    Cmd.Parameters[19].Value = (d1_line_of_description == null ? "" : d1_line_of_description);
                    Cmd.Parameters[20].Value = (m1_line_of_marks_and_numbers == null ? "" : m1_line_of_marks_and_numbers);
                    Cmd.Parameters[21].Value = (h1_hazard_code == null ? "" : h1_hazard_code);
                    Cmd.Parameters[22].Value = (h2_hazard_class == null ? "" : h2_hazard_class);
                    Cmd.Parameters[23].Value = (h3_hazard_description == null ? "" : h3_hazard_description);
                    Cmd.Parameters[24].Value = (h4_hazard_contact == null ? "" : h4_hazard_contact);
                    Cmd.Parameters[25].Value = (h5_un_page_number == null ? "" : h5_un_page_number);
                    Cmd.Parameters[26].Value = (h6_flashpoint_temperature == null ? "" : h6_flashpoint_temperature);
                    Cmd.Parameters[27].Value = (h7_hazard_code_qualifier == null ? "" : h7_hazard_code_qualifier);
                    Cmd.Parameters[28].Value = (h8_hazard_unit_of_measure == null ? "" : h8_hazard_unit_of_measure);
                    Cmd.Parameters[29].Value = (h9_negative_indigator == null ? "" : h9_negative_indigator);
                    Cmd.Parameters[30].Value = (h10_hazard_label == null ? "" : h10_hazard_label);
                    Cmd.Parameters[31].Value = (h11_hazard_classification == null ? "" : h11_hazard_classification);
					#endregion

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


		private void btnSend_Click(object sender, System.EventArgs e)
		{
			ValidationSummary1.Enabled = true;
		}


		private string performDataCheck()
		{
			string errMsg = null;

			#region FindControl
			TextBox  txt_v7_last_foreign_pol_s = (TextBox)UltraWebTab1.FindControl("txt_v7_last_foreign_pol_s");
			TextBox  txt_v7_last_foreign_pol = (TextBox)UltraWebTab1.FindControl("txt_v7_last_foreign_pol");
			TextBox  txt_p3_terminal_operator_code_s = (TextBox)UltraWebTab1.FindControl("txt_p3_terminal_operator_code_s");
			TextBox  txt_p3_terminal_operator_code = (TextBox)UltraWebTab1.FindControl("txt_p3_terminal_operator_code");
			TextBox  txt_l1_port_of_load_s = (TextBox)UltraWebTab1.FindControl("txt_l1_port_of_load_s");
			TextBox  txt_l1_port_of_load = (TextBox)UltraWebTab1.FindControl("txt_l1_port_of_load");
			TextBox  txt_b2_port_of_loading_s = (TextBox)UltraWebTab1.FindControl("txt_b2_port_of_loading_s");
			TextBox  txt_b2_port_of_loading = (TextBox)UltraWebTab1.FindControl("txt_b2_port_of_loading");
			TextBox  txt_b3_place_of_final_destination_s = (TextBox)UltraWebTab1.FindControl("txt_b3_place_of_final_destination_s");
			TextBox  txt_b3_place_of_final_destination = (TextBox)UltraWebTab1.FindControl("txt_b3_place_of_final_destination");
			#endregion
            string ConnectStr = (new igFunctions.DB().getConStr());
			SqlConnection Con = new SqlConnection(ConnectStr);
			SqlCommand Cmd = new SqlCommand();
			Cmd.Connection = Con;
			
			try
			{
				Con.Open();
				if(txt_v7_last_foreign_pol.Text != null && txt_v7_last_foreign_pol.Text != "")
				{

					Cmd.CommandText="select port from ig_schedule_k where k_code = " + txt_v7_last_foreign_pol.Text;
					SqlDataReader reader = Cmd.ExecuteReader();

					if(reader.Read())
					{
						txt_v7_last_foreign_pol_s.Text = reader["port"].ToString();
					}
					else
					{
						errMsg = "Vessel Info. : Last foreign POL is invalid.";
					}
				
					reader.Close();
				}
			}
			catch(Exception ex)
			{
				lblError.Text = "Error was occured - Schedule K loading error. ";
				lblError.Text += ex.Message;
				Con.Close();
				return lblError.Text;
			}

			if (errMsg != null ) 
			{
				Con.Close();
				return errMsg;
			}

			try
			{
				if(txt_p3_terminal_operator_code.Text != null && txt_p3_terminal_operator_code.Text != "")
				{

					Cmd.CommandText="select port from ig_schedule_k where k_code = " + txt_p3_terminal_operator_code.Text;
					SqlDataReader reader = Cmd.ExecuteReader();

					if(reader.Read())
					{
						txt_p3_terminal_operator_code_s.Text = reader["port"].ToString();
					}
					else
					{
						errMsg += "Vessel Info. : Terminal operator code is invalid.";
					}

					reader.Close();
				}
			}
			catch(Exception ex)
			{
				lblError.Text = "Error was occured - Schedule K loading error. ";
				lblError.Text += ex.Message;
				Con.Close();
				return lblError.Text;
			}
			
			if (errMsg != null ) 
			{
				Con.Close();
				return errMsg;
			}

			try
			{
				if(txt_l1_port_of_load.Text != null && txt_l1_port_of_load.Text != "")
				{
					Cmd.CommandText="select port from ig_schedule_k where k_code = " + txt_l1_port_of_load.Text;
					SqlDataReader reader = Cmd.ExecuteReader();

					if(reader.Read())
					{
						txt_l1_port_of_load_s.Text = reader["port"].ToString();
					}
					else
					{
						errMsg += "Bill Header Info. : Port of load code is invalid.";
					}

					reader.Close();
				}
			}
			catch(Exception ex)
			{
				lblError.Text = "Error was occured - Schedule K loading error. ";
				lblError.Text += ex.Message;
				Con.Close();
				return lblError.Text;
			}
			
			if (errMsg != null ) 
			{
				Con.Close();
				return errMsg;
			}

			try
			{
				if(txt_b2_port_of_loading.Text != null && txt_b2_port_of_loading.Text != "")
				{
					Cmd.CommandText="select port from ig_schedule_k where k_code = " + txt_b2_port_of_loading.Text;
					SqlDataReader reader = Cmd.ExecuteReader();

					if(reader.Read())
					{
						txt_b2_port_of_loading_s.Text = reader["port"].ToString();
					}
					else
					{
						errMsg += "Bill Header Info. : Port of Loading is invalid.";
					}

					reader.Close();
				}
			}
			catch(Exception ex)
			{
				lblError.Text = "Error was occured - Schedule K loading error. ";
				lblError.Text += ex.Message;
				Con.Close();
				return lblError.Text;
			}

			if (errMsg != null ) 
			{
				Con.Close();
				return errMsg;
			}

			try
			{
				if(txt_b3_place_of_final_destination.Text != null && txt_b3_place_of_final_destination.Text != "")
				{
					Cmd.CommandText="select port from ig_schedule_k where k_code = " + txt_b3_place_of_final_destination.Text;
					SqlDataReader reader = Cmd.ExecuteReader();

					if(reader.Read())
					{
						txt_b3_place_of_final_destination_s.Text = reader["port"].ToString();
					}
					else
					{
						errMsg += "Bill Header Info. : Place of final destination code is invalid.";
					}

					reader.Close();
				}
			}
			catch(Exception ex)
			{
				lblError.Text = "Error was occured - Schedule K loading error. ";
				lblError.Text += ex.Message;
				Con.Close();
				return lblError.Text;
			}

			Con.Close();
			return errMsg;

		}
		private bool performValidation(bool showMsg)
		{
			string errMsg = performDataCheck();


			if(errMsg != null) 
			{
				viewJavaMsg(errMsg);
				return false;
			}

			this.btnValidation.ImageUrl = "../../../Images/mark_x.gif";

			if(showMsg)
			{
				viewJavaMsg("Data was filled out completely.");
			}
			if(btnValidation.ImageUrl == "../../../Images/mark_x.gif")
			{
				btnAMS_Send.Visible = true;
				lblAMS_Send.Visible = true;
			}
			else
			{
				btnAMS_Send.Visible = false;
				lblAMS_Send.Visible = false;
			}

			return true;
		}

		private void btnValidation_Click(object sender, System.Web.UI.ImageClickEventArgs e)
		{
			
			performValidation(true);

		}

		private void viewJavaMsg(string strMsg)
		{
			string script = "";
			script = "<script language='javascript'> ";
			script += "alert(' " +strMsg+" '); ";
			script += "</script>";
			this.RegisterClientScriptBlock("Pre", script);  			
		}
	}
}
