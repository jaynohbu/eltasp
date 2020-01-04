<% Option Explicit %>

<!-- #include file="../inc/dbinfo.asp" -->
<!-- #include file="../inc/info_tb.asp" -->
<!-- #include file="../inc/joint.asp" -->

<HTML>
<HEAD>
<TITLE>Memo Box</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<LINK rel="stylesheet" type="text/css" href="../inc/style.css">
</HEAD>
<BODY BGCOLOR=#FFFFFF LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0>


<table border="0" width="384" cellpadding="0" cellspacing="0">
<tr>
	<td width="384" height="70" colspan="2"><img src="img/m_list_title.gif"></td>
</tr>
<tr>
	<td width="384" height="8" colspan="2">
	<table width="100%" border="0" cellpadding="0" cellspacing="0" ID="Table1">
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
	</table>	</td>
</tr>
	<%
	dim m_box,m_num,s_id,s_name,r_id,m_title,m_writeday,m_read,m_memo,updatesql
	
	m_box = request("m_box")
	SQL = "SELECT * FROM message where (m_box like '"&m_box&"')  AND r_id='"&session_uid&"' and m_num="&request("m_num")

	Set rs = db.execute (SQL)
	
	if rs.eof or rs.bof then
	
	
	else
	
	m_num = rs("m_num")
	s_id = rs("s_id")
	s_name = rs("s_name")
	r_id = rs("r_id")
	m_title = rs("m_title")
	content = rs("m_memo")
	m_writeday = rs("m_writeday")
	
	m_read = rs("m_read")
	
	content = Replace(content, vbCrLf,"<br>")
	Call autolink(content)
	
	m_memo=content
	

	updateSQL = "Update message set m_read=1 where (m_box like '"&m_box&"') and elt_account_number="&elt_account_number&" AND r_id='"&session_uid&"' and m_num="&m_num
	db.execute updateSQL		
	
	dim yy,mm,dd,h,mi
	
	yy = year(m_writeday)
    mm = right("0" & month(m_writeday),2)
    dd = right("0" & day(m_writeday),2)
    h = right("0" & hour(m_writeday),2)
    mi = right("0" & minute(m_writeday),2)
    m_writeday = mm & "/ " & dd & "(" & h & ":" & mi & ")/ " & yy 
	
%>
<tr height="25"> 
	<td width="110" bgcolor="#eeeeee" class="form_title" align="right"><b><% if m_box=0 then %>From<% elseif m_box=1 then %>To<% elseif m_box=2 then %>From/To<% end if %> &nbsp;</b></td>
	<td width="274"align="left">&nbsp; <%=s_name%>(<%=s_id%>)</td>
</tr>
<tr>
	<td colspan="2" height="1" bgcolor="#cccccc"></td>
</tr>
<tr height="25"> 
	<td width="110" bgcolor="#eeeeee" class="form_title" align="right"><b>Title &nbsp;</b></td>
	<td width="274"align="left">&nbsp; <%=m_title%></td>
</tr>
<tr>
	<td colspan="2" height="1" bgcolor="#cccccc"></td>
</tr>
<tr>
	<td colspan="2" style="word-break:break-all;padding:10px;" valign="top"><%=m_memo%><br><br>
	<div align="right">(Received Date : <%=m_writeday%>)</div></td>
</tr>
<tr>
	<td colspan="2" height="1" bgcolor="#cccccc"></td>
</tr>
<%
	end if
	
	rs.close
	set rs=nothing	
%>
<tr>
	<td width="384" height="8" colspan="2">
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
	</table>	</td>
</tr>	
</table>
<div align="right" style="word-break:break-all;padding:5px;"><a href="m_list.asp?m_box=<%=request("m_box")%>&page=<%=request("page")%>"><img src="img/m_list_but.gif" border="0"></a><% if m_box=0 then %> <a href="m_write.asp?r_id=<%=s_id%>&r_name=<%=s_name%>"><img src="img/m_reply_but.gif" border="0"></a><% end if %> <a href="m_del_ok.asp?m_box=<%=request("m_box")%>&m_num=<%=m_num%>"><img src="img/m_del_but.gif" border="0"></a> <a href="javascript:close();"><img src="img/m_close_but.gif" border="0"></a></div>
</body>
</html>