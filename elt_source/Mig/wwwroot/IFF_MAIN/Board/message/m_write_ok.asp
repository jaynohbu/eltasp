<% Option Explicit %>
<% response.buffer = true %>

<!-- #include file="../inc/dbinfo.asp" -->
<!-- #include file="../inc/info_tb.asp" -->
<!-- #include file="../inc/joint.asp" -->

<%
	dim m_num,s_id,m_box,s_name,r_id,r_name,m_title,m_memo,m_writeday
	
	SQL="SELECT MAX(m_num) FROM message"
	Set rs = db.execute (SQL)
	
	if IsNULL(rs(0)) then
		m_num = 1
	else
		m_num = rs(0)+1
	end if
	
	m_box=0
	s_id = request("s_id")
	s_name = request("s_name")
	r_id = request("r_id")
	r_name = request("r_name")
	m_title = request("m_title")
	m_memo = request("m_memo")
	
'response.write "s_name" & s_name & "<br>"
'response.write "r_name" & r_name & "<br>"

'	if left(now,2) = "20" then
'		m_writeday = now
'	else
'		m_writeday = "20"&now
'	end if

		m_writeday = now
	
	SQL = "INSERT INTO message (m_num,m_box,elt_account_number,s_name,s_id,r_name,r_id,m_title,m_memo,m_writeday,m_read) VALUES "
	SQL = SQL & "(" & m_num & ""
	SQL = SQL & "," & 0 & ""	'받은쪽지함
	SQL = SQL & ",'" & elt_account_number & "'"
	SQL = SQL & ",'" & s_name & "'"
	SQL = SQL & ",'" & s_id & "'"
	SQL = SQL & ",'" & r_name & "'"
	SQL = SQL & ",'" & r_id & "'"
	SQL = SQL & ",'" & m_title & "'"
	SQL = SQL & ",'" & m_memo & "'"
	SQL = SQL & ",'" & m_writeday & "'"
	SQL = SQL & ", 0 )"
	
	db.Execute SQL
	

	SQL = "INSERT INTO message (m_num,m_box,elt_account_number,s_name,s_id,r_name,r_id,m_title,m_memo,m_writeday,m_read) VALUES "
	SQL = SQL & "(" & m_num+1 & ""
	SQL = SQL & "," & 1 & ""	'보낸쪽지함
	SQL = SQL & ",'" & elt_account_number & "'"
	SQL = SQL & ",'" & r_name & "'"
	SQL = SQL & ",'" & r_id & "'"
	SQL = SQL & ",'" & s_name & "'"
	SQL = SQL & ",'" & s_id & "'"
	SQL = SQL & ",'" & m_title & "'"
	SQL = SQL & ",'" & m_memo & "'"
	SQL = SQL & ",'" & m_writeday & "'"
	SQL = SQL & ", 0 )"
	
	db.Execute SQL

%>
<HTML>
<HEAD>
<TITLE>Sending Memo</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<Meta http-equiv="Refresh" content="5; url=javascript:close();">
<LINK rel="stylesheet" type="text/css" href="../inc/style.css">
<script language="javascript">
<!--

function submit()
{
	if (document.inno.m_title.value =="") {
		alert("제목을 적어주세요.");
		document.inno.m_title.focus();
		return;
	}
	
	if (document.inno.m_memo.value =="") {
		alert("내용을 적어주세요.");
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
<BODY BGCOLOR=#FFFFFF LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0>
<table border="0" width="384" cellpadding="0" cellspacing="0" ID="Table1">
<tr>
	<td width="384" height="70" colspan="2"><img src="img/m_send_title.gif"></td>
</tr>
<tr>
	<td height="8" colspan="2">
	<table width="100%" border="0" cellpadding="0" cellspacing="0" ID="Table2">
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

<tr height="25">
	<td colspan="2" align="center"><br><b>Memo was sent.</b><br><br><a href="javascript:close();"><img src="../img/but_ok.gif" border="0"></a><br><br>
	</td>
</tr>
<tr>
	<td height="8" colspan="2">
	<table width="100%" border="0" cellpadding="0" cellspacing="0" ID="Table3">
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

</table>

</body>
</html>