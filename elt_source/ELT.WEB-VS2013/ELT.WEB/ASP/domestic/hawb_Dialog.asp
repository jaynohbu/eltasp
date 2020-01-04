<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>HAWB Number</title>
</head>
<%
rURL=Request.servervariables("QUERY_STRING")
session("HAWB_CLOSE") = ""
session("HAWB_NUM") = ""
%>

<script language="javascript">
function myLoad() {
    //document.getElementById("modalFrame").scr= '<%= rURL %>';
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
	
	if (rVal == '') 
	{	
	showModalDialog('new_edit_hawb_OK2.asp?close=yes','dialogWidth:1px; dialogHeight:1x; help:0; status:0; scroll:0;center:1;dialogHide:1');
	}

}

</script>
<body onload="javascript:myLoad();" onunload="javascript:myUnLoad();">
<form method="post" name="fShowModal">
	<input type=hidden name="hReturnValue">
</form>	
<iframe id="modalFrame" name="modalFrame" width="100%" src="<%= rURL %>" style="PADDING: 0px; MARGIN: 0px;" height="100%"></iframe>
</body>
</html>
