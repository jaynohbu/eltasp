<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<html>
<head>
<title>Untitled</title>
<meta name="generator" content="Namo WebEditor v3.0">
</head>

<body bgcolor="white" text="black" link="blue" vlink="purple" alink="red">
<object classid="clsid:34FD3126-734C-4F94-B006-8E1B23E149C8"  id = "FreightEasy" codebase="./FreightEasyNet.cab#version=1,0,0,1"></object>
<script language="javascript">
function OnAboutClick() {
   FreightEasy.AboutBox();      
}

function OnTextButtonClick() {
   alert(FreightEasy.MacAddress);      
}
function OnTextIPButtonClick() {
   alert(FreightEasy.IPAddress);      
}

function OnTextPrintButtonClick() {
   alert(FreightEasy.PrintForm('C:\\TEMP\\Eltdata\\HAWBconsignee.txt','LPT1',''));
}

</script> 
<form name="form" method="get">
<p><input type="button" name="TextButton" value="About Box" onclick="OnAboutClick();"> </p>
<p><input type="button" name="TextButton" value="get Mac Address" onclick="OnTextButtonClick();"> </p>
<p><input type="button" name="TextButton" value="get IP Address" onclick="OnTextIPButtonClick();"> </p>
<p><input type="button" name="TextButton" value="Print File" onclick="OnTextPrintButtonClick();"> </p>
</form>
<p>&nbsp;</p>
</body>

</html> 
