
function vlsch(gn,ValueListID,cellId) {
	var cell=igtbl_getCellById(cellId);
	var row=igtbl_getRowById(cellId);

	if(cell.Column.Key=="Partner Name") {
		var list = igtbl_getElementById(ValueListID);
		row.getCellFromKey('Code').setValue(list.value);
	}
//	else if(cell.Column.Key=="Airline") {
//		var list = igtbl_getElementById(ValueListID);
//		row.getCellFromKey('Airline_Code').setValue(list.value);
//	}
	
}

function acuh(gridName,cellId) {
var row=igtbl_getRowById(cellId);
var s = row.getCellFromKey("a").getValue();
if (s=="a") {
	return false;
}

s = row.getCellFromKey("x").getValue();
if (s=="x") {
	return false;
}
row.getCellFromKey('e').setValue('e');
row.getCellFromKey('e').Element.style.backgroundColor = "Lavender";
row.ParentRow.getCellFromKey('e').setValue('e');
row.ParentRow.getCellFromKey('e').Element.style.backgroundColor = "Lavender";
}

function arih(gridName,rowId) {

var row=igtbl_getRowById(rowId);
row.getCellFromKey("a").setValue("a");
row.getCellFromKey("a").Element.style.backgroundColor = "LightGreen";

var oGrid = igtbl_getGridById(gridName);
var oRows = oGrid.Rows;

if(oRows.length == 1) {
	oRows.getRow(0).getCellFromKey('i1_item_number').setValue("001");
	return false;
}
a = oRows.getRow(oRows.length-2).getCellFromKey('i1_item_number').getValue();
a++;

strA = a.toString(10);

while(strA.length<3) {
	strA = "0"+strA;		
}

oRows.getRow(oRows.length-1).getCellFromKey('i1_item_number').setValue(strA);

return false;

}

function beemh(gridName,cellId) {
var band = igtbl_getBandById(cellId);
var cell=igtbl_getCellById(cellId);
var row=igtbl_getRowById(cellId);
var s = row.getCellFromKey("a").getValue();

if (s=="a") {
	return false;
}
}

function cch(gridName,cellId,button) {

var SelectedParent = 'url(../../../Images/mark_op.gif)';
var row=igtbl_getRowById(cellId);
var cell=igtbl_getCellById(cellId);
var oCell = igtbl_getCellById(cellId);
var cUrl = oCell.Element.style.backgroundImage;
var band = igtbl_getBandById(row.Id);

			if(cell.Column.Key=="Chk") {
				if(cUrl==SelectedParent) {

					oCell.Element.style.backgroundImage =  'url(../../../Images/mark_xp.gif)';					
					row.getCellFromKey("x").setValue("x");
					row.getCellFromKey('e').setValue('e');
					row.getCellFromKey("x").Element.style.backgroundColor = "Red";
					row.getCellFromKey('e').Element.style.backgroundColor = "Lavender";
					
					row.setSelected(true);
				}
				else {
				
					oCell.Element.style.backgroundImage =  'url(../../../Images/mark_op.gif)';
					row.getCellFromKey("x").setValue('');
					row.getCellFromKey('e').setValue('e');
					row.getCellFromKey("x").Element.style.backgroundColor = "Lavender";
					row.getCellFromKey('e').Element.style.backgroundColor = "Lavender";
					row.setSelected(true);
				}
			}

}

function NumberingRows() {

var oGrid = igtbl_getGridById('UltraWebGrid1');
var oRows = oGrid.Rows;

	for(i=0; i<oRows.length; i++) {
				strA = i.toString(10);
				while(strA.length<3) {
					strA = "0"+strA;		
				oRow = oRows.getRow(i);
				oRow.getCellFromKey('i1_item_number').setValue(strA);
				}
		
	}

return false;

}

function SelectAllRows() {

var oGrid = igtbl_getGridById('UltraWebGrid1');
var oRows = oGrid.Rows;
oGrid.suspendUpdates(true);
	for(i=0; i<oRows.length; i++) {
		oRow = oRows.getRow(i);
		oRow.getCellFromKey('Chk').Element.style.backgroundImage =  'url(../../../Images/mark_xp.gif)';
		oRow.getCellFromKey("x").setValue("x");
		oRow.getCellFromKey('e').setValue('e');
		oRow.getCellFromKey("x").Element.style.backgroundColor = "Red";
		oRow.getCellFromKey('e').Element.style.backgroundColor = "Lavender";		
//		oRow.setSelected(true);
		
	}
	oUltraWebGrid1.suspendUpdates(false);
}

function unSelectAllRows() {
	
var oGrid = igtbl_getGridById('UltraWebGrid1');
var oRows = oGrid.Rows;
oGrid.suspendUpdates(true);
	for(i=0; i<oRows.length; i++) {
		oRow = oRows.getRow(i);
		oRow.getCellFromKey('Chk').Element.style.backgroundImage =  'url(../../../Images/mark_op.gif)';
		oRow.getCellFromKey("x").setValue("");
		oRow.getCellFromKey('e').setValue('e');
		oRow.getCellFromKey("x").Element.style.backgroundColor = "Lavender";
		oRow.getCellFromKey('e').Element.style.backgroundColor = "Lavender";		
//		oRow.setSelected(true);
		
	}
	oUltraWebGrid1.suspendUpdates(false);

}

function gridRowDelete(strGrid) {
   igtbl_deleteSelRows(strGrid);

}

function gridRowDeleteAll(strGrid) {
	var oGrid = igtbl_getGridById(strGrid);
	var oRows = oGrid.Rows;

	for(i=(oRows.length-1); i>=0; i--) {
	 strRow = strGrid+"r_"+i;
	 igtbl_deleteRow(strGrid,strRow);	 
	}
}

function DeleteRows() {

var oGrid = igtbl_getGridById('UltraWebGrid1');
var oRows = oGrid.Rows;
oGrid.suspendUpdates(true);

	for(i=0; i<oRows.length; i++) {
		oRow = oRows.getRow(i);
		if( oRow.getCellFromKey('Chk').Element.style.backgroundImage ==  'url(../../../Images/mark_xp.gif)' ) {
		oRow.setSelected(true);
		}		
	}

oUltraWebGrid1.suspendUpdates(false);
gridRowDelete(oGrid.Id);

}


function setState(a) {
var strN = a.name.split(':');
igtab_getTabById(strN[0]).findControl("txt_"+ strN[2].substr(strN[2].indexOf("dl_")+3,strN[2].length)).value =  igtab_getTabById(strN[0]).findControl(strN[2]).value;
}

function setPort(a) {
var strN = a.name.split(':');
igtab_getTabById(strN[0]).findControl("txt_"+ strN[2].substr(strN[2].indexOf("dl_")+3,strN[2].length)).value =  igtab_getTabById(strN[0]).findControl(strN[2]).value;
}

function setCountry(a) {
var strN = a.name.split(':');
igtab_getTabById(strN[0]).findControl("txt_"+ strN[2].substr(strN[2].indexOf("dl_")+3,strN[2].length)).value =  igtab_getTabById(strN[0]).findControl(strN[2]).value;
}		

var lookup_url_start = "lookup.aspx";
var lookup_url_startMaster = "lookupMaster.aspx";

function searchOption() {
	
	var strOption = document.form1.drSearch.value;
	var strSearchKey = document.form1.txtSearchKey.value; 	

	if  ( strOption == 'Date')  {
		var strDate1 = igedit_getById("Webdatetimeedit1").getValueByMode(1);
		var strDate2 = igedit_getById("Webdatetimeedit2").getValueByMode(1);
		if ( !strDate1 ) { 
			alert('Please input the from date.');
			return false;	
		}
		if ( !strDate2 ) { 
			alert('Please input the from date.');
			return false;	
		}

        var lookup_url = lookup_url_startMaster + "?TABLE=ig_ocean_ams_edi_header" + "&FIELD=doc_number" +"&FILTER=Date"+"&FILTER1=" + strDate1+"&FILTER2=" + strDate2;
        openLookup( lookup_url, document.form1.txtSearchKey );                
			return false;	
		
	}
	
	if(strSearchKey=="") { 
		alert('Please input the search text.');
		document.form1.drSearch.selectedIndex = 0;
		return false; 
	 }	  
	if  ( strOption == 'Code') {
        var lookup_url = lookup_url_startMaster + "?TABLE=ig_ocean_ams_edi_header" + "&FIELD=doc_number" +"&FILTER=Code"+"&FILTER1=" + strSearchKey+"&FILTER2=''";
        openLookup( lookup_url, document.form1.txtSearchKey );                		
		return false;
	}
	if  ( strOption == 'Number') {
        var lookup_url = lookup_url_startMaster + "?TABLE=ig_ocean_ams_edi_header" + "&FIELD=doc_number" +"&FILTER=Number"+"&FILTER1=" + strSearchKey+"&FILTER2=''";
        openLookup( lookup_url, document.form1.txtSearchKey );                		
		return false;
	}
	if  ( strOption == 'Name')  {
	    var lookup_url = lookup_url_startMaster + "?TABLE=ig_ocean_ams_edi_header" + "&FIELD=doc_number" +"&FILTER=Name"+"&FILTER1=" + strSearchKey+"&FILTER2=''";
        openLookup( lookup_url, document.form1.txtSearchKey );                		
		return false;	
	}
	

}

function SearchCode ( field, lookup_name )
{
	
var ultraTab = igtab_getTabById("UltraWebTab1");
var htmlText = ultraTab.findControl(field);

	if(htmlText.value=="") { 
		alert('Please input the search text.');
		return true; 
	  }

    if ( htmlText && lookup_name )
    {
        // open lookup window with lookup results
        var lookup_url = lookup_url_start + "?TABLE=" + lookup_name + "&FIELD=" + field +"&FILTER=" + htmlText.value;
        openLookup( lookup_url, htmlText );                
    }
    else
    {
        return;
    }
    
}

function openLookup ( url, field )
{
	var winprops = "";

    if ( url && field )
    {
        // cleanup
//        field.value = "";

        // open window
        winprops =  "left="+event.screenX+",top="+event.screenY+",status=0,toolbar=0,location=0,directories=0,menubar=0,scrollbars=1,resize=0,width=450,height=350"
        lookup_window = window.open( url, "lookup_window", winprops );
    }

}

function formRest(tr,id) {

	var idText = id.getText();
	
	if(idText == 'New') {

		gridRowDeleteAll('UltraWebGrid1');
		__doPostBack("btnNew", "");   		
		return true;
	}
	else if(idText == 'Cancel' ) {
		gridRowDeleteAll('UltraWebGrid1');
		__doPostBack("btnCancel", "");  
		return true;
	}
	else if(idText == 'Reset' ) {
		return true;
	}
	else if(idText == 'Edit' ) {
		__doPostBack("btnEdit", "");   		
		return true;
	}
	else if(idText == 'Delete' ) {
		__doPostBack("btnDelete", "");   		
		return true;
	}
	else if ( idText == 'Save' ) {
		if (!ValidatorOnSubmit()) return false;
//		if(!dataValidation()) return true;
		NumberingRows();
		__doPostBack("btnSave", "");			
	}	
}

function dataValidation() {

var ultraTab = igtab_getTabById("UltraWebTab1");

var txt_v1_vessel_code=ultraTab.findControl('txt_v1_vessel_code').value;
var txt_v2_voyage_number=ultraTab.findControl('txt_v2_voyage_number').value;
var txt_v3_vessel_name=ultraTab.findControl('txt_v3_vessel_name').value;
var txt_v4_scac_code=ultraTab.findControl('txt_v4_scac_code').value;
var dl_v5_vessel_flag=ultraTab.findControl('dl_v5_vessel_flag').value;
var txt_v5_vessel_flag=ultraTab.findControl('txt_v5_vessel_flag').value;
var dl_v6_first_us_port_of_discharge=ultraTab.findControl('dl_v6_first_us_port_of_discharge').value;
var txt_v6_first_us_port_of_discharge=ultraTab.findControl('txt_v6_first_us_port_of_discharge').value;
var txt_v7_last_foreign_pol_s=ultraTab.findControl('txt_v7_last_foreign_pol_s').value;
var txt_v7_last_foreign_pol=ultraTab.findControl('txt_v7_last_foreign_pol').value;
var dl_p1_port_of_discharge=ultraTab.findControl('dl_p1_port_of_discharge').value;
var txt_p1_port_of_discharge=ultraTab.findControl('txt_p1_port_of_discharge').value;
var txt_p2_estimated_date_of_arrival=ultraTab.findControl('txt_p2_estimated_date_of_arrival').value;
var txt_p3_terminal_operator_code_s=ultraTab.findControl('txt_p3_terminal_operator_code_s').value;
var txt_p3_terminal_operator_code=ultraTab.findControl('txt_p3_terminal_operator_code').value;
var txt_l1_port_of_load_s=ultraTab.findControl('txt_l1_port_of_load_s').value;
var txt_l1_port_of_load=ultraTab.findControl('txt_l1_port_of_load').value;
var txt_l2_load_date=ultraTab.findControl('txt_l2_load_date').value;
var txt_l3_load_time=ultraTab.findControl('txt_l3_load_time').value;
var txt_creation_date=ultraTab.findControl('txt_creation_date').value;
var txt_b1_bill_of_lading_number=ultraTab.findControl('txt_b1_bill_of_lading_number').value;
var txt_b2_port_of_loading_s=ultraTab.findControl('txt_b2_port_of_loading_s').value;
var txt_b2_port_of_loading=ultraTab.findControl('txt_b2_port_of_loading').value;
var txt_b3_place_of_final_destination_s=ultraTab.findControl('txt_b3_place_of_final_destination_s').value;
var txt_b3_place_of_final_destination=ultraTab.findControl('txt_b3_place_of_final_destination').value;
var txt_b4_place_of_receipt=ultraTab.findControl('txt_b4_place_of_receipt').value;
var dl_b5_b_lading_status_code=ultraTab.findControl('dl_b5_b_lading_status_code').value;
var txt_b5_b_lading_status_code=ultraTab.findControl('txt_b5_b_lading_status_code').value;
var txt_b6_b_lading_issuer_scac_code=ultraTab.findControl('txt_b6_b_lading_issuer_scac_code').value;
var txt_b7_snp1=ultraTab.findControl('txt_b7_snp1').value;
var txt_b8_snp2=ultraTab.findControl('txt_b8_snp2').value;
var txt_b9_manifested_units=ultraTab.findControl('txt_b9_manifested_units').value;
var txt_b10_total_gross_weight=ultraTab.findControl('txt_b10_total_gross_weight').value;
var txt_b11_booking_number=ultraTab.findControl('txt_b11_booking_number').value;
var txt_b12_master_ocean_bill_number=ultraTab.findControl('txt_b12_master_ocean_bill_number').value;
var txt_b13_agency_unique_code=ultraTab.findControl('txt_b13_agency_unique_code').value;
var txt_b14_snp3=ultraTab.findControl('txt_b14_snp3').value;
var txt_b15_snp4=ultraTab.findControl('txt_b15_snp4').value;
var txt_b16_snp5=ultraTab.findControl('txt_b16_snp5').value;
var txt_b17_snp6=ultraTab.findControl('txt_b17_snp6').value;
var txt_b18_snp7=ultraTab.findControl('txt_b18_snp7').value;
var txt_b19_snp8=ultraTab.findControl('txt_b19_snp8').value;
var dl_b20_weight_unit=ultraTab.findControl('dl_b20_weight_unit').value;
var txt_b20_weight_unit=ultraTab.findControl('txt_b20_weight_unit').value;
var txt_s1_shipper_name=ultraTab.findControl('txt_s1_shipper_name').value;
var txt_s2_shipper_address1=ultraTab.findControl('txt_s2_shipper_address1').value;
var txt_s3_shipper_address2=ultraTab.findControl('txt_s3_shipper_address2').value;
var txt_s4_shipper_city=ultraTab.findControl('txt_s4_shipper_city').value;
var txt_s5_shipper_state_province=ultraTab.findControl('txt_s5_shipper_state_province').value;
var txt_s6_shipper_postal_code=ultraTab.findControl('txt_s6_shipper_postal_code').value;
var txt_s7_shipper_telephone_fax=ultraTab.findControl('txt_s7_shipper_telephone_fax').value;
var dl_s8_shipper_iso_country_code=ultraTab.findControl('dl_s8_shipper_iso_country_code').value;
var txt_s8_shipper_iso_country_code=ultraTab.findControl('txt_s8_shipper_iso_country_code').value;
var txt_s9_shipper_contact_name=ultraTab.findControl('txt_s9_shipper_contact_name').value;
var txt_c1_consignee_name=ultraTab.findControl('txt_c1_consignee_name').value;
var txt_c2_consignee_address1=ultraTab.findControl('txt_c2_consignee_address1').value;
var txt_c3_consignee_address2=ultraTab.findControl('txt_c3_consignee_address2').value;
var txt_c4_consignee_city=ultraTab.findControl('txt_c4_consignee_city').value;
var dl_c5_consignee_state_province=ultraTab.findControl('dl_c5_consignee_state_province').value;
var txt_c5_consignee_state_province=ultraTab.findControl('txt_c5_consignee_state_province').value;
var txt_c6_consignee_postal_code=ultraTab.findControl('txt_c6_consignee_postal_code').value;
var txt_c7_consignee_telephone_fax=ultraTab.findControl('txt_c7_consignee_telephone_fax').value;
var txt_c8_consignee_iso_country_code=ultraTab.findControl('txt_c8_consignee_iso_country_code').value;
var txt_c9_consignee_contact_name=ultraTab.findControl('txt_c9_consignee_contact_name').value;
var txt_n1_notify_name=ultraTab.findControl('txt_n1_notify_name').value;
var txt_n2_notify_address1=ultraTab.findControl('txt_n2_notify_address1').value;
var txt_n3_notify_address2=ultraTab.findControl('txt_n3_notify_address2').value;
var txt_n4_notify_city=ultraTab.findControl('txt_n4_notify_city').value;
var dl_n5_notify_state_province=ultraTab.findControl('dl_n5_notify_state_province').value;
var txt_n5_notify_state_province=ultraTab.findControl('txt_n5_notify_state_province').value;
var txt_n6_notify_postal_code=ultraTab.findControl('txt_n6_notify_postal_code').value;
var txt_n7_notify_telephone_fax=ultraTab.findControl('txt_n7_notify_telephone_fax').value;
var txt_n8_notify_iso_country_code=ultraTab.findControl('txt_n8_notify_iso_country_code').value;
var txt_n9_notify_party_contact_name=ultraTab.findControl('txt_n9_notify_party_contact_name').value;

if(!txt_v1_vessel_code || txt_v1_vessel_code=="") { alert("Please input the Vessel Code"); return false; }

var oGrid = igtbl_getGridById('UltraWebGrid1');
var oRows = oGrid.Rows;

	for(i=0; i<oRows.length; i++) {
		oRow = oRows.getRow(i);
		i2_quantity = oRow.getCellFromKey('i2_quantity').getValue();										
		i3_net_weight = oRow.getCellFromKey('i3_net_weight').getValue();									
		i4_volume = oRow.getCellFromKey('i4_volume').getValue();											
		i5_package_type = oRow.getCellFromKey('i5_package_type').getValue();								
		i6_comodity_code = oRow.getCellFromKey('i6_comodity_code').getValue();								
		i7_cash_value = oRow.getCellFromKey('i7_cash_value').getValue();									
		e1_equipment_number = oRow.getCellFromKey('e1_equipment_number').getValue();                      
		e2_seal_number1 = oRow.getCellFromKey('e2_seal_number1').getValue();								
		e3_seal_number2 = oRow.getCellFromKey('e3_seal_number2').getValue();								
		e4_length = oRow.getCellFromKey('e4_length').getValue();											
		e5_width = oRow.getCellFromKey('e5_width').getValue();											
		e6_height = oRow.getCellFromKey('e6_height').getValue();											
		e7_iso_equipment = oRow.getCellFromKey('e7_iso_equipment').getValue();                             
		e8_type_of_service = oRow.getCellFromKey('e8_type_of_service').getValue();                           
		e9_loaded_empty_total = oRow.getCellFromKey('e9_loaded_empty_total').getValue();						
		e10_equipment_desc_code = oRow.getCellFromKey('e10_equipment_desc_code').getValue();					
		d1_line_of_description = oRow.getCellFromKey('d1_line_of_description').getValue();                       
		m1_line_of_marks_and_numbers = oRow.getCellFromKey('m1_line_of_marks_and_numbers').getValue();		
		h1_hazard_code = oRow.getCellFromKey('h1_hazard_code').getValue();								
		h2_hazard_class = oRow.getCellFromKey('h2_hazard_class').getValue();								
		h3_hazard_description = oRow.getCellFromKey('h3_hazard_description').getValue();						
		h4_hazard_contact = oRow.getCellFromKey('h4_hazard_contact').getValue();                            
		h5_un_page_number = oRow.getCellFromKey('h5_un_page_number').getValue();							
		h6_flashpoint_temperature = oRow.getCellFromKey('h6_flashpoint_temperature').getValue();					
		h7_hazard_code_qualifier = oRow.getCellFromKey('h7_hazard_code_qualifier').getValue();					
		h8_hazard_unit_of_measure = oRow.getCellFromKey('h8_hazard_unit_of_measure').getValue();				
		h9_negative_indigator = oRow.getCellFromKey('h9_negative_indigator').getValue();						
		h10_hazard_label = oRow.getCellFromKey('h10_hazard_label').getValue();								
		h11_hazard_classification = oRow.getCellFromKey('h11_hazard_classification').getValue();
	}                                                                                                                  


return true;

}


