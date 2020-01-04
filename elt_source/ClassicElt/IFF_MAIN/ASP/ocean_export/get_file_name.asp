<html xmlns="http://www.w3.org/1999/xhtml">
<html>
<head>
    <meta http-equiv="Content-Language" content="en-us" />
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <title>File Name</title>
<script type="text/jscript">
function updateFileName()
{
    var value = document.getElementById("txtFileName").value;
    window.returnValue = value;
    window.close();
}
function setFileName()
{
    document.getElementById("txtFileName").value = window.dialogArguments;
}
</script>

</head>
<body onload="setFileName();">
<br /><br /><br />
<center>
<form name="form1" onsubmit="return false;">
<table class="bodycopy" cellpadding="2" cellspacing="0" border="0">
<tr>
<td><strong>File Name</strong></td>
<td><input type="text" ID="txtFileName" value="" class="shorttextfield" /> </td>
<td><input type="button" class="bodycopy" value="Save" onclick="updateFileName();"/></td>
<td><input type="button" class="bodycopy" value="Cancel" onclick="window.close();"/></td>
</tr>
</table>
</form>

</center>
</body>
</html>

