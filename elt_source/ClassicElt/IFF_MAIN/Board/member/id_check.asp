<% @Language = "VBScript" %>
<% Option Explicit %>
<% response.buffer = true %>


 



<!-- #include file="../inc/dbinfo.asp" -->
<!-- #include file="../inc/info_tb.asp" -->
<html>
<head>
<title><%=board_title%></title>

<LINK rel="stylesheet" type="text/css" href="../inc/style.css">

<script language="JavaScript">
<!--
function update_cid()
{ 
  window.opener.document.inno.id.value = document.id_check.id.value;
  window.opener.document.inno.pin.focus();
  self.close();
}

function submit()
{

	if (document.id_check.id.value == "") {
		alert("아이디를 입력해주세요");
		document.id_check.id.focus();
		return;
	}
	
	if (document.id_check.id.value.length < 4) {
		alert("아이디는 4자 이상이어야 합니다");
		document.id_check.id.focus();
		return;
	}
	
	document.id_check.submit();

}
//-->
</script>
</head>

<body bgcolor="#FFFFFF" marginwidth="0" marginheight="0" leftmargin="0" topmargin="0">

<div align="center">
<img src="../img/idcheck_title.gif" border="0">

<%
	dim id
	id = request("id")
%>

<% if id="" then %>
<script LANGUAGE="JavaScript" FOR="window" EVENT="onload()">
	document.id_check.id.focus();
</script>
<table width="350" border="0" cellspacing="0" cellpadding="0">
<form method="post" name="id_check" action="id_check.asp">
<tr>
	<td align="center"><br>사용하실 아이디를 입력해 주세요<br><br></td>
</tr>
<tr>
	<td align="center"><input type="text" name="id" size="15" class="form_input"> <a href="javascript:submit();"><img src="../img/but_join_search.gif" border="0"></a></td>
</tr>
</form>
</table>

<% else %>

<%
	SQL = "SELECT id FROM member where elt_account_number=" & elt_account_number & "AND id='"&id&"'"
	Set rs=db.execute(SQL)
%>
	<% if rs.BOF or rs.EOF then %>
	<table width="350" border="0" cellspacing="0" cellpadding="0">
	<form method="post" name="id_check">
	<input type="hidden" name="id" value="<%=id%>">
	<tr>
		<td align="center"><br><b><%=id%></b>는 사용가능한 아이디입니다.<br><br></td>
	</tr>
	<tr>
		<td align="center"><a href="javascript:update_cid();"><img src="../img/but_join_ok.gif" border="0"></a> <a href="id_check.asp"><img src="../img/but_join_againsearch.gif" border="0"></a></td>
	</tr>
	</form>
	</table>
	<% else %>
	<script LANGUAGE="JavaScript" FOR="window" EVENT="onload()">
	document.id_check.id.focus();
</script>
	<table width="350" border="0" cellspacing="0" cellpadding="0">
	<form method="post" name="id_check" action="id_check.asp">
	<tr>
		<td align="center"><br><b><%=id%></b> 는 이미 사용중입니다.<br><br>사용하실 다른 아이디를 입력해주세요.<br><br></td>
	</tr>
	<tr>
		<td align="center"><input type="text" name="id" size="15" class="form_input"> <a href="javascript:submit();"><img src="../img/but_join_search.gif" border="0"></a></td>
	</tr>
	</form>
	</table>
	<% end if %>

<% end if %>


</div>
</body>
</html>
