// JScript File
function viewPop(Url) {

	if ( Url.indexOf("pdf") >= 0 || Url.indexOf("agent_stmt.asp") >= 0 )
	{
		if(document.form1) {
			jPopUpPDF();
			document.form1.action=Url + '&WindowName=popUpPDF';
			document.form1.method="POST";
			document.form1.target="popUpPDF"
			document.form1.submit();
		}
	}
	else
	{

		var strJavaPop = "";
		strJavaPop = window.open(Url,'popupNew','staus=0,titlebar=0,toolbar=1,menubar=1,scrollbars=1,resizable=1,location=0,width=900,height=600,hotkeys=0');
		strJavaPop.focus();
	}
}
