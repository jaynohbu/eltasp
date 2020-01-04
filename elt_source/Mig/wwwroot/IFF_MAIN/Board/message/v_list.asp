<% Option Explicit %>

<!-- #include file="../inc/dbinfo.asp" -->
<!-- #include file="../inc/joint.asp" -->

<HTML>
<HEAD>
<TITLE>Sending Memo</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<LINK rel="stylesheet" type="text/css" href="../inc/style.css">
</HEAD>
<BODY BGCOLOR=#FFFFFF LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0>

<table border="0" width="384" cellpadding="0" cellspacing="0">
<tr>
	<td width="384" height="70"><img src="img/m_list_title.gif"></td>
</tr>
<tr>
	<td width="384" height="22">
	<a href="#">Received</a> | <a href="#">Sent</a> | <a href="#">Deleted</a>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="1" bgcolor="#333333"></td>
	</tr>
	<tr>
		<td height="1" bgcolor="#ffffff"></td>
	</tr>
	<tr>
		<td height="18" bgcolor="#333333">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr align="center">
			<td><font color="#FFFFFF"><b>Title</b></font></td>
			<td width="80"><font color="#FFFFFF"><b>Sent by</b></font></td>
			<td width="80"><font color="#FFFFFF"><b>Date</b></font></td>
		</tr></table></td>
	</tr>
	<tr>
		<td height="1" bgcolor="#ffffff"></td>
	</tr>
	<tr>
		<td height="1" bgcolor="#333333"></td>
	</tr>
	</table>
	</td>
</tr>
<%
'Set db=Server.CreateObject("ADODB.Connection") 
'	 db.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=d:\[1]web\board\inno.mdb;Persist Security Info=False"
	Dim ip,rs1,SQL1
	ip = session_ip
	Dim tmp_session_id
	tmp_session_id=Request.Cookies("CurrentUserInfo")("Session_ID")
	
	SQL1 = "SELECT * FROM view_login where ip='"&session_ip&"'" & " AND server_name='" & 	session_server_name & "'"
	Set rs1 = eltConn.execute (SQL1)
	
if rs1.eof or rs1.bof then
	
	
	else
	
	Do until Rs1.EOF
	
	tmp_session_id=rs1("session_id")
	ip = rs1("ip")
	
	
	
%>
<tr>
	<td height="20">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr align="center">
		<td><a href="memo2.asp"><%=tmp_session_id%></a></td>
		<td width="80"><%=ip%></td>
		<td width="80">02-02-14</td>
	</tr></table></td>
</tr>
<%
Rs1.Movenext

  Loop
end if
%>
<tr>
	<td height="8">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="1" bgcolor="#ffffff"></td>
	</tr>
	<tr>
		<td height="4" bgcolor="#333333"></td>
	</tr>
	<tr>
		<td height="1" bgcolor="#ffffff"></td>
	</tr>
	<tr>
		<td height="1" bgcolor="#333333"></td>
	</tr>
	</table></td>
</tr>
<tr>
	<td align="right" style="padding-top:5;padding-right:5;"><a href="m_write.asp"><img src="img/m_send_but.gif" border="0"></a> <a href="javascript:close();"><img src="img/m_close_but.gif" border="0"></a></td>
</tr>
</table>
</body>
</html>