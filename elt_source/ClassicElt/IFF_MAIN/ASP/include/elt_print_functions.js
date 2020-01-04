function setSelect(sName,text) {
	var oSelect = document.getElementById(sName);
	var items = oSelect.options;
	for( var i = 0; i < items.length; i++ ) {
	var item = items[i];
		if( item.text.toLowerCase() == text.toLowerCase() ) {
			oSelect.selectedIndex = i;
			break;
		}
	}						
}
function createSelect(TD_name, tmpHtml,strWidth) {
var oTd = document.getElementById(TD_name);
	if(oTd) {
	oTd.innerHTML = 
			"<select class='smallselect' id="
			+ "'"+TD_name+"'" 
			+ " style='WIDTH:"+strWidth+"'" 
			+ " name='lst_"+TD_name+"'" 
			+ " size='1'"
			+ " onChange='javascript:getPrinterPort(this);'" 
			+ ">"
			+ tmpHtml 
			+ '</select>';
	}		
}
function createSelectMulti(TD_name, tmpHtml,strWidth,strHeight) {
var oTd = document.getElementById(TD_name);
	if(oTd) {
	oTd.innerHTML = 
			"<select class='smallselect' id="
			+ "'"+TD_name+"'" 
			+ " style='height: "+strHeight+"; WIDTH:"+strWidth+"'" 
			+ " name='lst_"+TD_name+"'" 
			+ " size='3'"
			+ " onChange='javascript:getPrinterInfo_sel(this);'" 
			+ ">"
			+ tmpHtml 
			+ '</select>';
	}		
}
function getPrinterPort(oSelect) {
	var pPrinter = oSelect.options[ oSelect.options.selectedIndex ].text;
	if(pPrinter != '') {
	    var pPort = EltClient.GET_PRINTER_PORT(pPrinter);
		if (pPort) {
//			document.getElementById('txt'+oSelect.id+'Port').value = pPort.replace(':','');
			document.getElementById('txt'+oSelect.id+'Port').value = pPort;
		}
		document.getElementById('txt'+oSelect.id+'Queue').value = pPrinter;
	} else {
			document.getElementById('txt'+oSelect.id+'Queue').value = '';
			document.getElementById('txt'+oSelect.id+'Port').value = '';
	}
}