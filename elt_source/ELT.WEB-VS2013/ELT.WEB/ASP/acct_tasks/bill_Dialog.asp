<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Invoice Number</title>
</head>
<%
rURL=Request.servervariables("QUERY_STRING")
session("INVOICE_NO") = ""
%>

<script language="javascript">
function myLoad() {
	document.getElementById("modalFrame").src = '<%= rURL %>';
}


function myUnLoad() {
var rVal = document.fShowModal.hReturnValue.value;

	if (rVal == 'cancel') 
	{
	window.returnValue = '';
	}
	else
	{
	window.returnValue = document.fShowModal.hReturnValue.value;
	}
	
}

</script>
<body onload="javascript:myLoad();" onunload="javascript:myUnLoad();">
<form method="post" name="fShowModal">
	<input type=hidden name="hReturnValue">
</form>	
<iframe id="modalFrame" name="modalFrame" width="100%" frameBorder="no" style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; PADDING-TOP: 0px"  height="100%"></iframe>
</body>
</html>
