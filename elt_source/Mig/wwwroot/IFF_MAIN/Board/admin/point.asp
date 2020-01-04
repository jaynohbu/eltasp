<% Option Explicit %>
<% response.buffer = true %>

 


<!-- #include file="../inc/dbinfo.asp" -->
<!-- #include file="../inc/info_tb.asp" -->


<%
	if session_login_name <> "admin" then
		Response.Redirect "../member/login.asp?h_url="&h_url
	else
	
		dim a_menu,caseVar,file
%>
<html>
<head>
<title>▒ Admin Page ▒</title>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<LINK rel="stylesheet" type="text/css" href="../inc/style.css">
</HEAD>
<BODY BGCOLOR=#FFFFFF LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0>



<table border="0" width="100%" height="100%" cellpadding="0" cellspacing="0" ID="Table1">
<tr>
	<td height="75" align="center">
	<table border="0" width="772" height="75" cellpadding="0" cellspacing="0" ID="Table2">
	<tr>
		<td width="1" bgcolor="#cdcdcd"></td>
		<td width="770"><img src="../admin/img/top_innoboard.gif" border="0"></td>
		<td width="1" bgcolor="#cdcdcd"></td>
	</tr>
	</table>
	</td>
</tr>
<tr>
	<td height="1" bgcolor="#cdcdcd"></td>
</tr>
<tr>
	<td height="25" align="center">
	<table border="0" width="772" height="25" cellpadding="0" cellspacing="0" ID="Table3">
	<tr>
		<td width="1" bgcolor="#cdcdcd"></td>
		<td width="770" align="center">
		
		<!-- #include file="../admin/admin_top.asp" -->
		
		</td>
		<td width="1" bgcolor="#cdcdcd"></td>
	</tr>
	</table>
	</td>
</tr>
<tr>
	<td height="1" bgcolor="#cdcdcd"></td>
</tr>


<tr>
	<td align="center">
	<table border="0" width="772" height="100%" cellpadding="0" cellspacing="0" ID="Table5">
	<tr>
		<td width="1" bgcolor="#cdcdcd"></td>
		<td width="770"><% server.execute("../admin/point_1.asp") %></td>
		<td width="1" bgcolor="#cdcdcd"></td>
	</tr>
	</table>
	</td>
</tr>
<tr>
	<td height="1" bgcolor="#cdcdcd"></td>
</tr>
<tr>
	<td height="35" align="center">
	<table border="0" width="772" height="35" cellpadding="0" cellspacing="0" ID="Table6">
	<tr>
		<td width="1" bgcolor="#cdcdcd"></td>
		<td width="770" valign="bottom" align="right" style="word-break:break-all;padding:10px;"><!-- #include file="../inc/copyright.asp" --></td>
		<td width="1" bgcolor="#cdcdcd"></td>
	</tr>
	</table>
	</td>
</tr>
<tr>
	<td height="1" bgcolor="#cdcdcd"></td>
</tr>
<tr>
	<td height="100%" align="center">
	<table border="0" width="772" height="100%" cellpadding="0" cellspacing="0" ID="Table7">
	<tr>
		<td width="1" bgcolor="#cdcdcd"></td>
		<td width="770"></td>
		<td width="1" bgcolor="#cdcdcd"></td>
	</tr>
	</table>
	</td>
</tr>
</table>

</body>
</html>

<% end if%>