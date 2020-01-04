function validateEmail(emailad) {
var exclude=/[^@\-\.\w]|^[_@\.\-]|[\._\-]{2}|[@\.]{2}|(@)[^@]*\1/;
var check=/@[\w\-]+\./;
var checkend=/\.[a-zA-Z]{2,3}$/;
if(((emailad.search(exclude) != -1)||(emailad.search(check)) == -1)||(emailad.search(checkend) == -1)){
	return false;
}
return true;
}

function trim(sourceString) { return sourceString.replace(/(?:^\s+|\s+$)/ig, ""); }

/**  start of XMLHttpRequest **/

function actionRequestForAll(strGroupName,url,tWidth,tMaxLength) {
var oClass = document.getElementById('txt_' + strGroupName);
var tmpVal = oClass.value;
	oClass.value = 'loading...';
	new ajax.xhr.Request('GET','',url,showResponse,strGroupName,tmpVal,tWidth,tMaxLength);	
}

function showResponse(req,field,tmpVal,tWidth,tMaxLength,url) {
	if (req.readyState == 4) {
		if (req.status == 200) {
			createInnerHTML(
							req,
							'tmp_' + field, 			// temp textbox name to value store
							'txt_' + field, 			// target textbox name
							'lst_' + field,			// listbox name
							 tWidth,							// width 	
							 tMaxLength,							// MaxLength 	
							'on_lst_' + field + '_change',	// onchange function
							'on_lst_' + field + '_change(this)',	// onchange function
							'td_' + field ,				// <td> id for box
							'td_' + field + '_href',		// <td> id for href
							field,				// name of field
							url,	 // ajax url
							tmpVal
							);	
		}	
	}								
}
function createInnerHTML(req,tmpTextBoxName,TextBoxName,ListBoxName,strWidth,strMaxLength,onChangeEventName,onChangeEventNameFullText,tdName,tdName_href,field,actionRequestUrl,tmpVal) {
			sHTML = "<input id='" + TextBoxName + "' name='" + TextBoxName + "' type='hidden'/>";
			sHTML 	+= "<select class='smallselect' id='"
					+ ListBoxName 
					+"' style='WIDTH:" 
					+ strWidth 
					+ "' name='" 
					+ ListBoxName 
					+ "' size='1'"
					+ " onChange='javascript:" 
					+ onChangeEventNameFullText 
					+ ";' >";
			sHTML += req.responseText;
			sHTML += '</select>';

			document.getElementById(tdName).innerHTML = sHTML;
			var oTextBox = document.getElementById(TextBoxName);
			oTextBox.value = tmpVal;
			document.getElementById(tdName_href).innerHTML = 
			"<a href='javascript:;' onclick=\"javascript:makeTextBox('"
			+TextBoxName
			+"','"
			+tdName
			+"','"
			+ListBoxName
			+"','"
			+strWidth
			+"','"
			+strMaxLength
			+"','"
			+tdName_href
			+"','actionRequestForAll','"
			+field
			+"','" 
			+actionRequestUrl 
			+"');return false;\"><span class='list'>[Text]</span></a>";
			try  { if(typeof(eval(onChangeEventName)) == 'function') {	
				setSelectionValue(ListBoxName,tmpVal);
				return false; }	} catch(f) {}			
			
			try 
			{
				var f_onChange = new on_lst_change(ListBoxName);
				document.getElementById(ListBoxName).onchange = function() { f_onChange.onchange(); };
			} catch(f) {}			
			
			try { setSelectionValue(ListBoxName,tmpVal); } catch(f) {}						
			
}

function makeTextBox(BoxName,boxTdName,ListName,strWidth,strMaxLength,refTdName,fName,strType,url) {
var oTdText = document.getElementById(boxTdName);

var oSelect = document.getElementById(ListName);
var text = '';
if(oSelect) {
	text = oSelect.options[ oSelect.options.selectedIndex ].text;
} else {
	text = '';
}

oTdText.innerHTML = "<input id='"+BoxName+"' class='shorttextfield' name='"+BoxName+"' style='width: "+ strWidth +"' type='text' value='"+ text +"' maxlength='"+ strMaxLength +"'/>";
document.getElementById(refTdName).innerHTML = "<a href='javascript:;' onclick=\"javascript:" + fName + "('"+strType+"','"+url+"','"+strWidth+"','" + strMaxLength + "');return false;\"><span class='list'>[List]</span></a>";
}
function adjust_options(oSelect,newVal,newText,index) {
	var items = oSelect.options;
	for( var i = 0; i < items.length; i++ ) {
		var item = items[i];
		if( item.value.toLowerCase() == newVal.toLowerCase() ) {
			oSelect.selectedIndex = i;
			item.value = newVal;
			break;
		}
	}
	
	if ( i >= items.length )
	{
		var oOption = document.createElement("OPTION");
		oSelect.options.add(oOption,index);
		oOption.innerText = newText;
		oOption.value = newVal;		
		oSelect.selectedIndex = index;
	}
}

function gather_list_again(strGroupName,width,retVal) {
	try {
		var oTxtClass = document.getElementById('txt_' + strGroupName);
		oTxtClass.value = retVal;
		actionRequestForAll(strGroupName,'/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t='+strGroupName,width)	;
	} catch(f) {}	
}

function gather_list_again_country(strGroupName,width,retVal) {
	try {
		var oTxtClass = document.getElementById('txt_' + strGroupName);
		oTxtClass.value = retVal;
		actionRequestForAll(strGroupName,'/IFF_MAIN/asp/ajaxFunctions/ajax_get_country_code.asp',width)	;
	} catch(f) {}	
}

function copy_list(oSource,oTarget) {
//	try {
		for(var i = 0;i < oSource.length;i++){
			if(oSource.options[i].selected == true){
				copy_option(oSource.options[i],oTarget);
			}
		} 
//		sortSelect(oTarget);
//	} catch	(ex) {}
}

function copy_option(oSourceItem,oTarget) {
	try {
		var oSource = oSourceItem.parentNode;
		if(!check_dupe(oSourceItem.value,oTarget.options)) {
			var oOption = document.createElement("OPTION");
			oTarget.options.add(oOption,0);
			oOption.innerText = oSourceItem.text;
			oOption.value = oSourceItem.value;		
			oOption.selectedIndex = 0;		
//			delete_oSourceItem(oSource,oSourceItem);
		}
	} catch	(ex) {}
}

function delete_oSourceItem(oSource,oSourceItem) {
	try {
		for( var i = 0; i < items.length; i++ ) {
			var item = items[i];
			if( item.value.toLowerCase() == code.toLowerCase() ) {
				return true;
			}
		}
	} catch	(ex) {}
}

function check_dupe(code,items) {
	try {
		for( var i = 0; i < items.length; i++ ) {
			var item = items[i];
			if( item.value.toLowerCase() == code.toLowerCase() ) {
				return true;
			}
		}
	} catch	(ex) {}
	return false;
}

function GetSelectValues(CONTROL){
	var iCnt = 0;
	try {
		for(var i = 0;i < CONTROL.length;i++){
			if(CONTROL.options[i].selected == true){
				iCnt ++;
			}
		} 
	} catch(ex) {}		
	return iCnt;
}

function adjust_option_item(rVal,oSelect) {
	var items = oSelect.options;
	var sCode = rVal.split('^^^');
	if (sCode.length > 1) {
		for( var i = 0; i < items.length; i++ ) {
			var item = items[i];
			if( item.value == sCode[0] ) {
				oSelect.selectedIndex = i;
				item.text = sCode[1];
				break;
			}
		}
	}
}

function sortSelect(obj) {
	var o = new Array();
	if (!hasOptions(obj)) { return; }
	for (var i=0; i<obj.options.length; i++) {
		o[o.length] = new Option( obj.options[i].text, obj.options[i].value, obj.options[i].defaultSelected, obj.options[i].selected) ;
		}
	if (o.length==0) { return; }
	o = o.sort( 
		function(a,b) { 
			if ((a.text+"") < (b.text+"")) { return -1; }
			if ((a.text+"") > (b.text+"")) { return 1; }
			return 0;
			} 
		);

	for (var i=0; i<o.length; i++) {
		obj.options[i] = new Option(o[i].text, o[i].value, o[i].defaultSelected, o[i].selected);
		}
	}

function removeSelectedOptions(from) { 
	if (!hasOptions(from)) { return; }
	if (from.type=="select-one") {
		from.options[from.selectedIndex] = null;
		}
	else {
		for (var i=(from.options.length-1); i>=0; i--) { 
			var o=from.options[i]; 
			if (o.selected) { 
				from.options[i] = null; 
				} 
			}
		}
	from.selectedIndex = -1; 
	} 

function hasOptions(obj) {
	if (obj!=null && obj.options!=null) { return true; }
	return false;
	}

function selectAllOptions(obj) {
	if (!hasOptions(obj)) { return; }
	for (var i=0; i<obj.options.length; i++) {
		obj.options[i].selected = true;
		}
	}

function get_post_parameters(oForm) {
var all = oForm.all;
var str = '';
	
	for( i=0; i<all.length;i++) {
		var tagType = all[i].type;
		if(	tagType == 'text' || tagType == 'select-one' || tagType == 'checkbox') {
			if(!all[i].readonly) {
				switch(tagType) {
					case  'text'		:	
						  str += all[i].name + "=" + all[i].value + "&";
						  break;	
					case  'checkbox'		:	
						  str += all[i].name + "=" + all[i].value + "&";
						  break;	
					case  'select-one'		:	
						  if(all[i].name == 'lst_other_options') {	
							str += all[i].name + "=" + all[i].value + "&";
						  }	
						  break;	
					default					:	  
						  break;	
				}
			}
		}
	}
	return str;
}

// isIntegerInRange (STRING s, INTEGER a, INTEGER b)
   function isIntegerInRange (s, a, b)
   {   if (isEmpty(s))
         if (isIntegerInRange.arguments.length == 1) return false;
         else return (isIntegerInRange.arguments[1] == true);

      // Catch non-integer strings to avoid creating a NaN below,
      // which isn't available on JavaScript 1.0 for Windows.
      if (!isInteger(s, false)) return false;

      // Now, explicitly change the type to integer via parseInt
      // so that the comparison code below will work both on
      // JavaScript 1.2 (which typechecks in equality comparisons)
      // and JavaScript 1.1 and before (which doesn't).
      var num = parseInt (s);
      return ((num >= a) && (num <= b));
   }

   function isInteger (s)
   {
      var i;

      if (isEmpty(s))
      if (isInteger.arguments.length == 1) return 0;
      else return (isInteger.arguments[1] == true);

      for (i = 0; i < s.length; i++)
      {
         var c = s.charAt(i);

         if (!isDigit(c)) return false;
      }

      return true;
   }

   function isEmpty(s)
   {
      return ((s == null) || (s.length == 0))
   }

   function isDigit (c)
   {
      return ((c >= "0") && (c <= "9"))
   }

