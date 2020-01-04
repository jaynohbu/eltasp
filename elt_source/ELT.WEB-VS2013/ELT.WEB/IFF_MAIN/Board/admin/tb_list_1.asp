<% Option Explicit %>
<% response.buffer = true %>
<% Response.Expires=-1 %>


 



<!-- #include file="../inc/dbinfo.asp" -->
<!-- #include file="../inc/info_tb.asp" -->
<!-- #include file="../inc/joint.asp" -->

<% if session_login_name <> "admin" then Response.Redirect "../inc/error.asp?no=1" %>
<%

	dim id_num,recordcount,pagecount,num,count_num

	pagesize = Request("pagesize")
	if pagesize = "" then
		pagesize=10
	end if

	page = Request("page")
	if page = "" then page = 1
	
	block=10



	SQL = "select count(num) as recCount from inno_admin"
	Set Rs = db.Execute(SQL)

	recordCount = Rs(0)
	pagecount = int((recordCount-1)/pagesize) +1
	id_num = recordCount - (Page -1) * PageSize

	SQL = "SELECT TOP " & pagesize & " * FROM inno_admin "
	if int(page) > 1 then
	SQL = SQL & " WHERE num not in "
	SQL = SQL & "(SELECT TOP " & ((page - 1) * pagesize) & " num FROM inno_admin"
	SQL = SQL & " ORDER BY num DESC)"
	end if
	SQL = SQL & " order by num desc" 
	Set Rs = db.Execute(SQL)
%>

<html>
<head>
<title>▒ Admin Page ▒</title>

<LINK rel="stylesheet" type="text/css" href="../inc/style.css">

<Script Language="javascript">
<!--


var num;

function ans_tb_del(num)
{
	ans = confirm("선택된 게시판을 삭제하시겠습니까?")

	if(ans == true)
	{ 
		location.href="tb_del_ok.asp?tb=inno_" + num;	
	}
	else
	{ }
}

//-->
</Script>
</head>
<body bgcolor="#FFFFFF" marginwidth="0" marginheight="0" leftmargin="0" topmargin="0">

<div align="center">
<br>
<table cellpadding="0" cellspacing="0" border="0" width="95%">
  <tr>
    <td class="font"><img src="../img/reference.gif" border="0"> <img src="../img/total.gif" border="0"> <%=recordCount%>, &nbsp; <img src="../img/pages.gif" border="0"> <%=page%> / <%=pagecount%></td>
  </tr>
</table>
<table width="95%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td colspan="6" height="22">
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
			<td width="50"><font color="#FFFFFF"><b>No.</b></font></td>
			<td><font color="#FFFFFF"><b>Board Name</b></font></td>
			<td width="100"><font color="#FFFFFF"><b>타입</b></font></td>
			<td width="100"><font color="#FFFFFF"><b>등록된 글수</b></font></td>
			<td width="100"><font color="#FFFFFF"><b>미리보기</b></font></td>
			<td width="100"><font color="#FFFFFF"><b>기본설정변경</b></font></td>
			<td width="80"><font color="#FFFFFF"><b>삭제</b></font></td>
		</tr></table></td>
	</tr>
	<tr>
		<td height="1" bgcolor="#ffffff"></td>
	</tr>
	<tr>
		<td height="1" bgcolor="#333333"></td>
	</tr>
	</table></td>
</tr>

<%
  dim caseVar

  Do until Rs.EOF

    num = rs("num")
    tb = rs("tb")
    tb_name = rs("tb_name")
    board_type = rs("board_type")
    
    caseVar = lcase (board_type)
	Select Case caseVar
		Case 0  board_type = "게시판"
		Case 1  board_type = "자료실"
		Case 2  board_type = "갤러리"
		Case 3  board_type = "디지털 다이어리"
	End Select


	dim c_sql1,c_rs1
	c_SQL1 = "SELECT count(num) FROM "&tb
	Set c_rs1 = db.Execute(c_SQL1)
	
	if IsNULL(c_rs1(0)) then
		count_num = 0
	else
		count_num = c_rs1(0)
	end if

%>
<tr align="center" height="20">
	<td colspan="6">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr align="center">
		<td width="50"><%=num%></td>
		<td><b><%=tb_name%></b></td>
		<td width="100"><%=board_type%></td>
		<td width="100"><%=count_num%></td>
		<td width="100"><a href="../board/list.asp?tb=<%=tb%>" target="_blank">보 기</a></td>
		<td width="100"><a href="tb_form.asp?tb=<%=tb%>&mode=edit">설 정</a></td>
		<td width="80"><a href="javascript:ans_tb_del(<%=num%>)">삭제</a></td>
	</tr></table></td>
</tr>
<tr>
	<td colspan="6" height="1" bgcolor="#999999"></td>
</tr>
<%
    Rs.Movenext
	id_num = id_num - 1
	Loop

%>
<tr>
	<td colspan="6" height="8">
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
<script language="javascript">
<!--

function page_size_submit()
{
	if (document.inno_page.pagesize.value == "") {
		alert("페이지수를 입력해 주세요.");
		document.inno_page.pagesize.focus();
		return;
	}
	
	document.inno_page.submit();

}

//-->
</script>
<form method="post" name="inno_page" action="tb_list.asp?page=<%=page%>">
<tr>
	<td colspan="6" class="font1" align="right" style="word-break:break-all;padding:5px;">한페이지에 나타낼 목록수 <input type="text" name="pagesize" size="1" maxlength="3" class="form_input" value="<%=pagesize%>">개로 <input type="button" class="but" value="다시보기" onClick="javascript:page_size_submit();" id=button1 name=button1>, &nbsp; <input type="button" class="but" value="게시판 추가" onClick="location.href='tb_form.asp'" id=button2 name=button2></td>
</tr>
</form>
<tr>
	<td colspan="6" height="15" align="center">
		<% If Rs.BOF Then %>
	
	<%
		Else
		If Int(Page) <> 1 Then 
	%>
		<a href="tb_list.asp?page=<%=Page-1%>&pagesize=<%=pagesize%><% if sw<>"" then %>&ss=<%=ss%>&sw=<%=sw%><% end if %>" onFocus="this.blur()"><font color="#000000" style="font-size:8pt;">[prv]</font></a>
	<%
		end if
		
		First_Page = Int((Page-1)/Block)*Block+1
		If First_Page <> 1 Then
	%>
			[<a href="tb_list.asp?page=1&pagesize=<%=pagesize%><% if sw<>"" then %>&ss=<%=ss%>&sw=<%=sw%><% end if %>" onFocus="this.blur()"><font color="#000000" style="font-size:8pt;">1</font></a>]&nbsp;..
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
			[<a href="tb_list.asp?page=<%=i%>&pagesize=<%=pagesize%><% if sw<>"" then %>&ss=<%=ss%>&sw=<%=sw%><% end if %>" onFocus="this.blur()"><font color="#000000" style="font-size:8pt;"><%=i%></font></a>]
	<%
		End If
		Next
		
		If End_Page <> PageCount Then
	%>
	&nbsp;..&nbsp;[<a href="tb_list.asp?page=<%=PageCount%>&pagesize=<%=pagesize%><% if sw<>"" then %>&ss=<%=ss%>&sw=<%=sw%><% end if %>" onFocus="this.blur()"><font color="000000" style="font-size:8pt;"><%=PageCount%></font></a>]
	<%
		end if
		
		If Int(Page) <> PageCount Then
	%>
	&nbsp;<a href="tb_list.asp?page=<%=page+1%>&pagesize=<%=pagesize%><% if sw<>"" then %>&ss=<%=ss%>&sw=<%=sw%><% end if %>" onFocus="this.blur()"><font color="#000000" style="font-size:8pt;">[next]</font></a>
	<%
		End If
		End If
	%>
	
	</td>
</tr>
</table>

<%

  Rs.close
  db.close
  Set Rs = Nothing
  Set db = Nothing
%>
<br><br>
</div>

</body>
</html>
