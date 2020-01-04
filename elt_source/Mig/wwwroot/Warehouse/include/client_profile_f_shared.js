function get_post_parameters(oForm,actType) {
var all = oForm.all;
var str = '';
	for( i=0; i<all.length;i++) {
		var tagType = all[i].type;
		if(	tagType == 'text' || tagType == 'select-one' || tagType == 'checkbox' || tagType == 'select-multiple') {
			if(!all[i].readonly) {
				switch(tagType) {
					case  'text'		:	
						  str += all[i].name + "=" + escape(all[i].value) + "&";
						  break;	
					case  'checkbox'		:	
						   if(all[i].checked) {
							  str += all[i].name + "=Y&";
						   }
						  break;	
					case  'select-one'		:	
						  if(all[i].name == 'lst_other_options') {	
							str += all[i].name + "=" + escape(all[i].value) + "&";
						  }	else {
							if(all[i].name == 'lst_owner_mail_country' || all[i].name == 'lst_business_country') {
								str += all[i].name + "=" + escape(all[i].options[ all[i].selectedIndex ].text) + "&";
							} else {
								str += all[i].name + "=" + escape(all[i].value) + "&";						  
							}
						  }						  
						  break;	
					case  'select-multiple'	:	
						  if(( actType == 'bACTIVATE' || actType == 'bDEACTIVATE' ) && all[i].name == 'lst_code') {
								str += all[i].name + "=";	
								var obj = all[i];	
								for (var j=0; j<obj.options.length; j++) {
									if(obj.options[j].selected) { 
										str += escape(obj.options[j].value) + ",";
									}
								}					
							str = str.substring(0,str.length - 1);
						  }
					default					:	  
						  break;	
				}
			}
		}
	}
	return str;
}
/*
function showResponseFindResult(req,field,tmpVal,tWidth,url) {
	if (req.readyState == 4) {
		if (req.status == 200) {
			create_innerHTML_for_result(req.responseText);
			document.getElementById('txt_status').value= '';
		}
	}	
}
*/
function create_innerHTML_for_result(htmlText){
var deli1 = htmlText.indexOf('<!--// page break //-->');
var deli2 = htmlText.indexOf('<!--// Filtered / Total //-->');
	if ( deli1 > 0 && deli2 > 0 ) {
		var selectHtml = htmlText.substring(0,deli1);
		var pageHtml = htmlText.substring(deli1,deli2);
		var readCntHtml = htmlText.substring(deli2+29);
		var td_result = document.getElementById('td_result');
		if (td_result) {
			td_result.innerHTML = selectHtml;
		}
		var td_page_break = document.getElementById('td_page_break');
		if (td_page_break) {
			td_page_break.innerHTML = pageHtml;
		}
		document.getElementById('txt_lessOrGreaterTop').value = readCntHtml;
		try {
			lst_code_on_change(document.getElementById('lst_code'));
		} catch(f) {}
	}
	
}
function clickEmpty(o) {
var oSelect = document.getElementById('lst_other_options');
var name = oSelect.options[ oSelect.options.selectedIndex ].value;
var obj = document.getElementById('txt_other_options');

	if(o.checked) {
		o.value = 'Y';
		obj.disabled = "disabled";
		obj.className = "d_shorttextfield";
	  	obj.preset = "none";
	}
	else {
		o.value = '';	
		obj.disabled = "";
		obj.className = "shorttextfield";
     	obj.preset = "none";		
		make_field_type(name);		
	}
}

function lst_other_options_change(o) {
var name = o.options[ o.options.selectedIndex ].value;
var co = document.getElementById('chkEmpty');
    co.value = '';	
    co.checked = false;
	document.getElementById('txt_other_options').disabled = "";
	
	make_field_type(name);
}
function obj_reset(obj) {
	obj.value = '';
	obj.preset = '';
    obj.style.behavior = '';
	obj.className = 'shorttextfield';		
}
function make_field_type(name) {
var obj = document.getElementById('txt_other_options');
	obj_reset(obj);
	name = name.toLowerCase();
	switch(name) {
		case 'isfrequently'		:	
				obj.value = 'Y';
			  break;	
		case 'known_shipper'		:	
				obj.value = 'Y';
			  break;	
		case 'is_colodee'		:	
				obj.value = 'Y';
			  break;	
		case 'edt'		:	
				obj.value = 'Y';
			  break;	
		case 'account_status'		:	
				obj.value = 'Deactivated';
			  break;	
		case 'credit_amt'		:	
				obj.className = "shorttextfield";
				obj.style.behavior = "url(igNumChkLeft.htc)";
			  break;	
		case 'bill_term'		:	
				obj.className = "shorttextfield";
				obj.style.behavior = "url(igNumChkLeft.htc)";
			  break;	
		case 'date_opened'		:	
				obj.className = "m_shorttextfield";
				obj.preset = "shortdate";
			  break;	
		case 'date_opened'		:	
				obj.className = "m_shorttextfield";
				obj.preset = "shortdate";
			  break;	
		case 'last_update'		:	  
				obj.className = "m_shorttextfield";		
				obj.preset = "shortdate";
			  break;	
		default					:	  
			  break;	
	}
}
function cClick(o) {
	o.value = (o.checked)?'Y':'';
}

function setSelectionValue(listName, listValue)
{
	var oSelect = document.getElementById(listName);
	if (oSelect) {
	
		switch(listName) {
			case 'lst_business_country' 	:
						var items = oSelect.options;
						for( var i = 0; i < items.length; i++ ) {
						var item = items[i];
							if( item.text.toLowerCase().indexOf(listValue.toLowerCase()) == 0 ) {
								oSelect.selectedIndex = i;
								on_lst_business_country_change(oSelect);
							  return;		
							}
						}	
						break;	
			default					:	  
						break;	
		}
		
		var items = oSelect.options;
		for( var i = 0; i < items.length; i++ ) {
		var item = items[i];
			if( item.value.toLowerCase() == listValue.toLowerCase() ) {
				oSelect.selectedIndex = i;
				break;
			}
		}	
		
	}
}

function on_lst_business_country_change(oSelect)
{
	var text = oSelect.options[ oSelect.options.selectedIndex ].text;
	document.getElementById('txt_business_country').value = text;
}

function on_lst_change(ListBoxName) {
	this.objName = ListBoxName;
	this.onchange = common_on_change;
}

function common_on_change() {
	var oSelect = document.getElementById(this.objName);
	var text = oSelect.options[ oSelect.options.selectedIndex ].value;
	if(text == '_edit') {
		oSelect.options.selectedIndex = 0;
		edit_all_code(oSelect);
	}
	else {
		var strGroupName = 	oSelect.id.substring(oSelect.id.indexOf('lst_')+4);
		try {
			var oTxtClass = document.getElementById('txt_' + strGroupName);
			oTxtClass.value = text;
		} catch(f) {}		
	}
}

function edit_all_code(oSelect) {
var strGroupName = 	oSelect.id.substring(oSelect.id.indexOf('lst_')+4);
var oTxtClass = document.getElementById('txt_' + strGroupName);
var param =  'PostBack=false&type=' + strGroupName + '&default=' + oTxtClass.value;
var retVal = showModalDialog("../Include/all_code_manage.asp?"
								+param,
								"AllCode","dialogWidth:450px; dialogHeight:340px; help:0; status:0; scroll:0;center:1;Sunken;");					
	
	try {
		if (retVal != '' && typeof(retVal) != 'undefined') {
			gather_list_again(strGroupName,oSelect.style.width,retVal);

			if ( strGroupName.indexOf('_city') > 0 || strGroupName.indexOf('_state')  > 0 || strGroupName.indexOf('_zip')  > 0 ) {
				strGroupName = ( strGroupName.indexOf('_mail_') > 0 )?strGroupName.replace('owner_mail','business'):strGroupName.replace('business','owner_mail');
				var nSelect = document.getElementById('lst_' + strGroupName);
				if (nSelect) {
					gather_list_again(strGroupName,nSelect.style.width,retVal);		
				}	
				else {
					gather_list_again(strGroupName,oSelect.style.width,retVal);		
				}
			}

		}
	} catch(f) {}
}	

