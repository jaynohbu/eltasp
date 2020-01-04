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
        alert("Please enter a EMail address.");
        document.inno.email.focus();
        return;
 
    }
    
    if (document.inno.email.value.length > 1 )  {
	
	str = document.inno.email.value;
	if(	(str.indexOf("@")==-1) || (str.indexOf(".")==-1)){
		alert("Invalid eMail adress.")
		document.inno.email.focus();
		return;
	}
	}
	
    if(document.inno.title.value.length == 0){
        alert("Please enter a title.");
        document.inno.title.focus();
        return;
    }
    if(document.inno.content.value.length == 0){
        alert("Please enter a content.");
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

<form name="inno" method="post" action="email_ok.asp" onsubmit="submit()">
<%
	dim h_url1
	h_url = instr(q_info,"h_url=")
	h_url1 = len(q_info)
	h_url = h_url+5
	h_url = h_url1-h_url
	h_url = right(q_info,h_url)
%>
<input type="hidden" name="h_url" value="<%=h_url%>">


<% if top_file<>"" then %><% server.execute(top_file)%><br><% end if %><%=top_board%>
<% '전체 테이블 시작 %>
<table width="570" border="0" cellpadding="0" cellspacing="0">

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
	<td width="110" class="form_title" align="right"><b>To &nbsp;</b></td>
	<td width="460"><input type="text" name="toemail" size="30" class="form_input" maxlength="240" value="<%=Request.QueryString("email1")%>"></td>
</tr>
<tr>
	<td colspan="2" height="1" bgcolor="#cccccc"></td>
</tr>
<tr bgcolor="F7F7F7" height="25"> 
	<td width="110" class="form_title" align="right"><b>From &nbsp;</b></td>
	<td width="460"><input type="text" name="email" size="30" class="form_input" maxlength="240" value="<%=session_email%>"></td>
</tr>
<tr>
	<td colspan="2" height="1" bgcolor="#cccccc"></td>
</tr>
<tr bgcolor="F7F7F7" height="25"> 
	<td width="110" class="form_title" align="right"><b>Title &nbsp;</b></td>
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
	<td align="right" style="word-break:break-all;padding:5px;"><a href="javascript:submit();"><img src="../img/but_ok.gif" border="0"></a> <a href="javascript:reset();"><img src="../img/but_again.gif" border="0"></a> <a href="javascript:history.go(-<% if mode = "edit" then %>2<% else %>1<% end if %>);"><img src="../img/but_cancel.gif" border="0"></a><br><!-- #include file="../inc/copyright.asp" --></td>
</tr>
</table>


</form>
<% if down_file<>"" then %><% server.execute(down_file)%><br><% end if %><%=bottom_board%>

</body>
</html>
