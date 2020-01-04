<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252" />
<link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
<script language="javascript">
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
<br/><font size="2">Please, select a copy to print.</font><br/><br/>
<form>
<select id="lstPrintOpt" class="bodyheader" style="width: 125px">
<option value="shipper">Shipper Copy</option>
<option value="consignee">Consignee Copy</option>
<!--<option value="both">Both Copies</option>-->
</select>
<input type="button" value="Print" class="bodycopy" onclick="javascript:getAnswer();" style="width: 55px" size=""/>
<input type="button" value="Cancel" class="bodycopy" onclick="javascript:window.close();" style="width: 55px"/>

</form>
</center>
</body>
</html>