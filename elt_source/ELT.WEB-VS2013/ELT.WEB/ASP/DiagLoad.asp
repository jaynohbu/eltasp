<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title></title>
</head>
<%
rURL=Request.servervariables("QUERY_STRING")
//session("HAWB_CLOSE") = ""
//session("HAWB_NUM") = ""
%>

<script language="javascript">
function myLoad() {
   
	document.modalFrame.location = '<%= rURL %>';
	document.modalFrame.title='Add a new client';
	//window.showModalDialog('<%= rURL %>','JA','font-size:10px;dialogWidth:55em;dialogHeight:12em');
}

function myUnLoad() {
 
 var rVal = document.fShowModal.hReturnValue.value;// this value is set from the loaded page

	if (rVal == 'cancel') 
	{
	window.returnValue = 'cancel';
	}
	else
	{
	window.returnValue = document.fShowModal.hReturnValue.value;
	}
	
	if (rVal == '') 
	{	
	//window.showModalDialog('<%= rURL %>','','font-size:10px;dialogWidth:55em;dialogHeight:12em');
	}

}

</script>
<body onload="javascript:myLoad();" onunload="javascript:myUnLoad();">
<form method="post" name="fShowModal">
	<input type=hidden name="hReturnValue">
</form>	
<IFRAME id="modalFrame" name="modalFrame" width="100%" frameBorder="no" style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; PADDING-TOP: 0px" language="javascript" height="100%"></IFRAME>
</body>
</html>
