<% 'Option Explicit %>
<% response.buffer = true %>

 



<!-- #include file="../inc/dbinfo.asp" -->
<!-- #include file="../inc/info_tb.asp" -->
<!-- #include file="../inc/joint.asp" -->

<html>
<head>
<title><%=board_title%></title>

<LINK rel="stylesheet" type="text/css" href="../inc/style.css">

<script language=javascript>
<!--
function submit(){
    if(document.inno.email.value.length == 0){
        alert("보내는사람의 EMail을 입력해 주십시요.");
        document.inno.email.focus();
        return;
 
    }
    
    if (document.inno.email.value.length > 1 )  {
	
	str = document.inno.email.value;
	if(	(str.indexOf("@")==-1) || (str.indexOf(".")==-1)){
		alert("전자우편 주소형식이 맞지않습니다")
		document.inno.email.focus();
		return;
	}
	}
	
    if(document.inno.title.value.length == 0){
        alert("제목을 입력해 주십시요.");
        document.inno.title.focus();
        return;
    }
    if(document.inno.content.value.length == 0){
        alert("내용을 입력해 주십시요.");
        document.inno.content.focus();
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

</head>
<body bgcolor="<%=bgcolor%>"  onload="document.inno.title.focus();" topmargin="0" leftmargin="0" marginwidth="0" marginheight="0">

<form name="inno" method="post" action="mailling_ok.asp" onsubmit="submit()">

<input type="hidden" name="h_url" value="<%=request.QueryString("h_url")%>">

<%
	if request("mode") = "sel" then	'선택된 회원만 일때
		cart_num = Request.Form("cart").count
		
		IF cart_num = 0 then response.Redirect "../inc/error.asp?no=19"
					
		i=1
		Do until i > cart_num
		
		id = Request.Form("cart")(i)
		
		
		SQL = "select email from member where elt_account_number=" & elt_account_number & "AND mailling = 1 and id='"&id&"'"
		Set Rs = db.Execute(SQL)
		
		if not(rs.eof and rs.bof) then
		
%>
	<input type="hidden" name="toemail" value="<%=rs(0)%>">
<%
		end if 
		
		rs.close
		set rs=nothing
		
		i=i+1
		loop
	
	elseif request("mode")="sel_all" then	'회원 전체보내기 일때
	
		SQL = "select email from member where elt_account_number=" & elt_account_number & "AND mailling = 1 order by num asc"
		Set Rs = db.Execute(SQL)
		
		if not(rs.eof and rs.bof) then

		do until rs.eof
%>
	<input type="hidden" name="toemail" value="<%=rs(0)%>">
<%	
		rs.movenext
		loop
		
		end if
		
		rs.close
		set rs = nothing
	end if
	
%>


<% '전체 테이블 시작 %>
<div align="center">
<br><br>
<table width="570" border="0" cellpadding="0" cellspacing="0">
<input type="hidden" name="email" value="<%=session_email%>">
<tr>
	<td colspan="2">
<table width="570" border="0" cellpadding="0" cellspacing="0">
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
</table>
	</td>
</tr>
<tr>
	<td colspan="2" height="1"></td>
</tr>
<tr>
	<td colspan="2" height="1" bgcolor="#cccccc"></td>
</tr>
<tr bgcolor="F7F7F7" height="25"> 
	<td width="110" class="form_title" align="right"><b>제 목 &nbsp;</b></td>
	<td width="460"><input type="text" name="title" size="30" class="form_input" maxlength="240"></td>
</tr>
<tr>
	<td colspan="2" height="1" bgcolor="#cccccc"></td>
</tr>
<tr>
	<td colspan="4" align="center" bgcolor="F7F7F7"><br><textarea name="content" cols="105" rows="12" class="form_textarea"></textarea><br><br></td>
</tr>
<tr>
	<td colspan="4" height="1" bgcolor="#cccccc"></td>
</tr>
<tr>
	<td colspan="2">
<table width="570" border="0" cellpadding="0" cellspacing="0">
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
</table>
	</td>
</tr>
</table>

<table width="570" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td align="right" style="word-break:break-all;padding:5px;"><a href="javascript:submit();"><img src="../img/but_ok.gif" border="0"></a> <a href="javascript:reset();"><img src="../img/but_again.gif" border="0"></a> <a href="javascript:history.go(-<% if mode = "edit" then %>2<% else %>1<% end if %>);"><img src="../img/but_cancel.gif" border="0"></a></td>
</tr>
</table>


</form>

</div>
</body>
</html>
