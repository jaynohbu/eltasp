<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/Header.asp" -->
 <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->

<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>Select Copy Type</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
<script language="javascript" type="text/javascript">
function getAnswer()
{
	var selObj = document.getElementById("lstPrintOpt");
	var returnValue = selObj.options[selObj.selectedIndex].value;
	window.returnValue = returnValue;
	window.close();
}

</script>
</head>
<body class="bodyheader"><center>
<br/><font size="2">Select Copy to print House B/L document</font><br/><br/>
<form id="form1" action="">

<select id="lstPrintOpt" class="bodyheader" style="width:200px;">
<option value="Non-Negotiatible" selected="selected" >Non-Negotiatible</option>
<option value="Original" >Original</option>
</select>

<br />
<br />
<input type="button" value="View" class="bodycopy" onclick="javascript:getAnswer();" style="width: 55px" size=""/>
<input type="button" value="Cancel" class="bodycopy" onclick="javascript:window.close();" style="width: 55px"/>

</form>
</center>
</body>
</html>