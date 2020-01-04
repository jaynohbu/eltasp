
<!-- #include file="../inc/dbinfo.asp" -->
<!-- #include file="../inc/info_tb.asp" -->
<!-- #include file="../inc/joint.asp" -->
<HTML>
<HEAD>
<TITLE>Memo Box</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<LINK rel="stylesheet" type="text/css" href="../inc/style.css">
<Script Language="javascript">
<!--

var checkflag = "false"; 

function checkboxall() { 

field = eval("document.inno_check.cart");

if (checkflag == "false") { 
for (i = 0; i < field.length; i++) { 
field[i].checked = true;} 
checkflag = "true"; 
return; 
} 

else { 
for (i = 0; i < field.length; i++) { 
field[i].checked = false; } 
checkflag = "false"; 
return; 
} 

}

function del_cart()
{
document.inno_check.submit();
}


//-->
</Script>
</HEAD>
<BODY BGCOLOR=#FFFFFF LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0>

<table border="0" width="384" cellpadding="0" cellspacing="0">
<tr>
	<td width="384" height="70"><img src="img/m_list_title.gif"></td>
</tr>

<%
Dim Memo_list_0,Memo_list_1

If Request.QueryString("com") = "yes" Then
		Memo_list_0 = "mem_list_0.asp"
		Memo_list_1 = "mem_list_1.asp"
		session("tb") = ""
else
	If tb = "inno_1" Then
		Memo_list_0 = "mem_list_p0.asp"
		Memo_list_1 = "mem_list_p1.asp"
	Else
		Memo_list_0 = "mem_list_0.asp"
		Memo_list_1 = "mem_list_1.asp"
	End If
End if
%>

<%

	
	
	dim new_memo0,new_memo1,new_memo2
	m_box = request("m_box")
	
	SQL1 = "SELECT count(m_num) FROM message where (m_box like '0') and (m_read like '0') AND r_id='"&session_uid&"'"
	Set rs1 = db.execute (SQL1)
			
	if rs1.eof or rs1.bof then
		new_memo0=0
	else
		new_memo0=rs1(0)
	end if
		
	rs1.close
	set rs1=nothing	
	
	SQL1 = "SELECT count(m_num) FROM message where (m_box like '1') and (m_read like '0') AND r_id='"&session_uid&"'"
	Set rs1 = db.execute (SQL1)
			
	if rs1.eof or rs1.bof then
		new_memo1=0
	else
		new_memo1=rs1(0)
	end if
		
	rs1.close
	set rs1=nothing	
	
	SQL1 = "SELECT count(m_num) FROM message where (m_box like '2') and (m_read like '0') AND r_id='"&session_uid&"'"
	Set rs1 = db.execute (SQL1)
			
	if rs1.eof or rs1.bof then
		new_memo2=0
	else
		new_memo2=rs1(0)
	end if
		
	rs1.close
	set rs1=nothing	
%>
<tr>
	<td>
	<table width="384" height="25" border="0" cellpadding="0" cellspacing="0" ID="Table1">
	<tr align="center" bgcolor="#999999">
		<td width="125"<% if m_box=0 then %> bgcolor="#333333"<% end if %>><a href="m_list.asp?m_box=0"><b><font color="<% if m_box=0 then %>#ffffff<% else %>#ffffff<% end if %>">Received(<%=new_memo0%>)</b></font></a></td>
		<td width="125"<% if m_box=1 then %> bgcolor="#333333"<% end if %>><a href="m_list.asp?m_box=1"><b><font color="<% if m_box=1 then %>#ffffff<% else %>#ffffff<% end if %>">Sent(<%=new_memo1%>)</font></b></a></td>
		<td width="134"<% if m_box=2 then %> bgcolor="#333333"<% end if %>><a href="m_list.asp?m_box=2"><b><font color="<% if m_box=2 then %>#ffffff<% else %>#ffffff<% end if %>">Deleted(<%=new_memo2%>)</b></a></td>
		</tr>
	</table>
	</td>
</tr>
<tr>
	<td width="384" height="22">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="1" bgcolor="#333333"></td>
	</tr>
	<tr>
		<td height="1" bgcolor="#ffffff"></td>
	</tr>
	
<form method="post" name="inno_check" action="m_del_ok.asp?m_box=<%=m_box%>&mode=check_del" ID="form1">
	<tr>
		<td height="18" bgcolor="#333333">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr align="center">
			<td width="20"><b><a href=javascript:checkboxall();><font color="#FFFFFF">*</font></a></b></td>
			<td><font color="#FFFFFF"><b>Title</b></font></td>
			<td width="80"><font color="#FFFFFF">
			<b>
			<% if m_box=0 then %>From <% end if %>
			<% if m_box=1 then %>To <% end if %>
			<% if m_box=2 then %>From/To <% end if %>
			</b></font></td>
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
	
	
	sw = request("sw")
	
	pagesize=10
	page = Request("page")
	if page = "" then page = 1
	
	if sw="" then
		SQL = "select count(m_num) from message where (m_box like '"&m_box&"') AND r_id='"&session_uid&"'"
		Set rs = db.Execute(SQL)

		recordCount = Rs(0)
		pagecount = int((recordCount-1)/pagesize) +1
		id_num = recordCount - (Page -1) * PageSize
  


		SQL = "SELECT TOP " & pagesize & " * FROM message"
		SQL = SQL & " where (m_box like '"&m_box&"') AND r_id='"&session_uid&"'"
		if int(page) > 1 then
		SQL = SQL & " and m_num not in "
		SQL = SQL & "(SELECT TOP " & ((page - 1) * pagesize) & " m_num FROM message"
		SQL = SQL & " where (m_box like '"&m_box&"') AND r_id='"&session_uid&"' ORDER BY m_num DESC)"
		end if
		SQL = SQL & " ORDER BY m_num DESC"
		
	else
		
	
	end if

	Set Rs = db.Execute(SQL)
	
if rs.eof or rs.bof then
	
	
	else
	
	Do until Rs.EOF
	
	
	m_num = rs("m_num")
	s_id = rs("s_id")
	s_name = rs("s_name")
	r_id = rs("r_id")
	r_name = rs("r_name")
	m_title = rs("m_title")
	m_memo = rs("m_memo")
	m_writeday = left(rs("m_writeday"),10)
	m_read = rs("m_read")

%>
<tr>
	<td height="20"<% if m_read=0 then %> bgcolor="#efefef"<% end if %>>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td width="20"><input type="checkbox" name="cart" value="<%=m_num%>" ID="Checkbox1"></td>
		<td>&nbsp; <a href="m_view.asp?m_box=<%=m_box%>&m_num=<%=m_num%>&page=<%=page%>"><%=m_title%></a></td>
		<td width="80" align="center"><a href="m_write.asp?r_id=<%=s_id%>&r_name=<%=s_name%>"><%=s_name%></a></td>
		<td width="80" align="center"><%=m_writeday%></td>
	</tr></table></td>
</tr>
<tr>
	<td height="1" bgcolor="#999999"></td>
</tr>
<%
Rs.Movenext

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
<% '############### 페이지 네비게이션 부분 시작 #################################### %>
<tr>
	<td align="center">	<% If Rs.BOF Then %>
	
	<%
		Else
		If Int(Page) <> 1 Then 
	%>
		<a href="m_list.asp?m_box=<%=m_box%>&page=<%=Page-1%><% if sw<>"" then %>&st=<%=st%>&sc=<%=sc%>&sn=<%=sn%>&sw=<%=sw%><% end if %>" onfocus="this.blur()"><font color="#000000" style="font-size:8pt;">[prv]</font></a>
	<%
		end if
		
		First_Page = Int((Page-1)/Block)*Block+1
		If First_Page <> 1 Then
	%>
			[<a href="m_list.asp?m_box=<%=m_box%>&page=1<% if sw<>"" then %>&st=<%=st%>&sc=<%=sc%>&sn=<%=sn%>&sw=<%=sw%><% end if %>" onfocus="this.blur()"><font color="#000000" style="font-size:8pt;">1</font></a>]&nbsp;..
	<%
		end if
		
		If PageCount - First_Page < Block Then
			End_Page = PageCount
		Else
			End_Page = First_Page + Block - 1
		End If

		For i = First_Page To End_Page
		If Int(Page) = i Then
	%>
			[<font color="#FF0000" style="font-size:8pt;"><b><%=i%></b></font>]
	<% Else %>
			[<a href="m_list.asp?m_box=<%=m_box%>&page=<%=i%><% if sw<>"" then %>&st=<%=st%>&sc=<%=sc%>&sn=<%=sn%>&sw=<%=sw%><% end if %>" onfocus="this.blur()"><font color="#000000" style="font-size:8pt;"><%=i%></font></a>]
	<%
		End If
		Next
		
		If End_Page <> PageCount Then
	%>
	&nbsp;..&nbsp;[<a href="m_list.asp?m_box=<%=m_box%>&page=<%=PageCount%><% if sw<>"" then %>&st=<%=st%>&sc=<%=sc%>&sn=<%=sn%>&sw=<%=sw%><% end if %>" onfocus="this.blur()"><font color="000000" style="font-size:8pt;"><%=PageCount%></font></a>]
	<%
		end if
		
		If Int(Page) <> PageCount Then
	%>
	&nbsp;<a href="m_list.asp?m_box=<%=m_box%>&page=<%=page+1%><% if sw<>"" then %>&st=<%=st%>&sc=<%=sc%>&sn=<%=sn%>&sw=<%=sw%><% end if %>" onfocus="this.blur()"><font color="#000000" style="font-size:8pt;">[next]</font></a>
	<%
		End If
		End If
	%></td>
</tr>

<% '############### 페이지 네비게이션 부분 끝 #################################### %>
<tr>
	<td align="right" style="padding-top:5;padding-right:5;"><a href="javascript:del_cart();"><img src="img/m_del_but.gif" border="0"></a> <% if m_box<>2 then %><a href="<%=Memo_list_0%>"><img src="img/m_send_but.gif" border="0"></a><% else %><a href="m_del_ok.asp?m_box=3"><img src="img/m_alldel_but.gif" border="0"></a><% end if %> <a href="javascript:close();"><img src="img/m_close_but.gif" border="0"></a></td>
</tr>
</form>
</table>
</body>
</html>