<% @Language = "VBScript" %>
<% response.buffer = true %>


 




<html>
<head>
<title>▒ 우편번호 검색 ▒</title>

<LINK rel="stylesheet" type="text/css" href="../inc/style.css">

<script language="JavaScript">
<!--

function submit()
{

	if (document.inno_post.address.value == "") {
		alert("지역명을 입력해 주세요.");
		document.inno_post.address.focus();
		return;
	}
	
	document.inno_post.submit();

}
//-->
</script>
</head>

<body bgcolor="#FFFFFF" marginwidth="0" marginheight="0" leftmargin="0" topmargin="0" onload="document.inno_post.address.focus();">

<img src="../img/zipcode_title.gif" border="0">

<table width="350" border="0" cellspacing="0" cellpadding="0">
<form method="post" name="inno_post" action="zipcode_ok.asp">
<tr>
	<td align="center"><br>동/읍/면, 기관, 학교 등의 이름을 입력하세요.<br><br></td>
</tr>
<tr>
	<td align="center"><input type="text" name="address" size="15" class="form_input"> <a href="javascript:submit();"><img src="../img/but_join_search.gif" border="0"></a></td>
</tr>
</form>
</table>

</body>
</html>
