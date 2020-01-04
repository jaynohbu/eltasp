<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="/ASP/css/elt_css.css" rel="stylesheet" type="text/css">

<title>Remarks</title>
</head>
<%
vOrgNum = Request.QueryString("Num")
vOrgName = Request.QueryString("Name")
%>

<script language="javascript">
function myLoad() {
	var loc = "/IFF_MAIN/Board/board/listRemarks.asp?tb=Remarks&Start=yes&oNum=" + "<%= vOrgNum %>" + "&oName=" + "<%= Server.URLEncode(vOrgName) %>" ;
	document.modalFrame.location = loc;
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
<body onload="javascript:myLoad();">
<form method="post" name="fShowModal">
	<input type=hidden name="hReturnValue">
   	<input type=hidden name="hOrgNum" Value="<%= vOrgNum %>">	
</form>	
<IFRAME id="modalFrame" name="modalFrame" width="100%" frameBorder="no" style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; PADDING-TOP: 0px" language="javascript" height="530" scrolling="yes"></IFRAME>
</body>
<p align="right"><span class="bodycopy"><input type="button" class="bodycopy" id=Button1 style="WIDTH: 100px; BACKGROUND-COLOR: #f4f2e8" onClick="javascript:window.close();" value="Close Window" name="CloseMe"></span>&nbsp;&nbsp;&nbsp;</p>
</html>
