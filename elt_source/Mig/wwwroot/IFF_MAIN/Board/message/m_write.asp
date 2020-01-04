<HTML>
<HEAD>
<TITLE>Sending Memo</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<LINK rel="stylesheet" type="text/css" href="../inc/style.css">
<!-- #include file="../inc/dbinfo.asp" -->

<%
	Dim SQL_view_login, rs_view_login

	SQL_view_login = "SELECT * FROM view_login where elt_account_number="&elt_account_number&" AND ip='"&session_ip&"'" & " AND server_name='" & 	session_server_name & "'"

	Set rs_view_login = eltConn.execute (SQL_view_login)
	if not (rs_view_login.eof or rs_view_login.bof) Then 
		session_login_name = rs_view_login("login_name")
		session_lname = rs_view_login("user_lname") & "," & rs_view_login("user_fname")
		If session_lname = "," Then session_lname = ""
		session_email = rs_view_login("user_email")
	End If
%>

<script language="javascript">
<!--

function submit()
{
	if (document.inno.m_title.value =="") {
		alert("Please enter a title.");
		document.inno.m_title.focus();
		return;
	}
	
	if (document.inno.m_memo.value =="") {
		alert("Please enter a content.");
		document.inno.m_memo.focus();
		return;
	}
	
	document.inno.submit();

}

function reset()
{
	document.inno.reset();
}

//-->
</script>
</HEAD>
<BODY BGCOLOR=#FFFFFF LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0 onLoad="document.inno.m_title.focus();">
<table border="0" width="384" cellpadding="0" cellspacing="0">
<tr>
	<td width="384" height="70" colspan="2"><img src="img/m_send_title.gif"></td>
</tr>
<tr>
	<td height="8" colspan="2">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="1" bgcolor="#333333"></td>
	</tr>
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
<form method="post" name="inno" action="m_write_ok.asp">
<input type="hidden" name="s_id" value="<%=session_uid%>"><input type="hidden" name="s_name" value="<%=session_login_name%>">
<input type="hidden" name="r_id" value="<%=request("r_id")%>"><input type="hidden" name="r_name" value="<%=request("r_name")%>">
<tr height="25">
	<td width="100" align="center" bgcolor="#eeeeee"><b>To</b></td>
	<td width="284">&nbsp; <b><%=request("r_name")%></b></td>
</tr>
<tr height="25">
	<td width="100" align="center" bgcolor="#eeeeee"><b>Title</b></td>
	<td width="284">&nbsp;  <input type="text" name="m_title" size="20" class="form_input" ID="Text1"></td>
</tr>
<tr height="25">
	<td height="25" colspan="2" align="center" bgcolor="#eeeeee"><b>Content</b></td>
</tr>
<tr height="25">
	<td colspan="2" align="center"><textarea name="m_memo" cols="70" rows="12" class="form_textarea"></textarea></td>
</tr>
<tr>
	<td height="8" colspan="2">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="1" bgcolor="#333333"></td>
	</tr>
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
	<td colspan="2" align="right" style="padding-top:5;padding-right:5;"><a href="javascript:submit();"><img src="img/m_send_but.gif" border="0"></a> <a href="javascript:close();"><img src="img/m_close_but.gif" border="0"></a></td>
</tr>
</form>
</table>

</body>
</html>