
<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta name="GENERATOR" content="Microsoft FrontPage 4.0" />
<meta name="ProgId" content="FrontPage.Editor.Document" />
<title>Error Message</title>
<link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
</head>
<%
ErrMsg=Request.QueryString("ErrMSG")

If InStr(ErrMsg, "^") > 0 Then
	ArrMsg = split(ErrMsg,"^")
else
	ErrMsg = ErrMsg & " ^  "
	ArrMsg = split(ErrMsg,"^")
end if

%>
<body onLoad="self.focus()">
<form name=form1>
  <table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr>
      <td width="100%" align="center" class="pageheader">Error Message</td>
  </tr>
  <% For i = 0 To UBound(ArrMsg) %>
  <tr>
      <td width="100%" align="left" class="bodycopy"><%= ArrMsg(i) %></td>
  </tr>
  <% NEXT %>
</table>
      <P align="center"><input name="OK" type="button" id="OK" value="OK" onClick="self.close()"  style="width:70px"></P>

</form>
</body>
<script language="VBScript">
<!--
Sub MenuMouseOver()
End Sub
Sub MenuMouseOut()
End Sub
-->
</script>
</html>
