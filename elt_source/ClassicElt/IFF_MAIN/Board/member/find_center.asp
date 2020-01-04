<% Option Explicit %>
<% response.buffer = true %>

 



<!-- #include file="../inc/dbinfo.asp" -->
<!-- #include file="../inc/info_tb.asp" -->
<!-- #include file="../inc/joint.asp" -->

<% call f_member %>

<html>
<head>
<title><%=board_title%></title>

<LINK rel="stylesheet" type="text/css" href="../inc/style.css">
</head>
<body marginwidth="0" marginheight="0" leftmargin="0" topmargin="0">

<div align="center">
<br>

<table width="300" border="0" cellpadding="0" cellspacing="0" ID="Table1">
<input type="hidden" name="process" value="ok" ID="Hidden1">
<tr>
	<td>
	<table width="100%" border="0" cellpadding="0" cellspacing="0" ID="Table2">
	<tr>
		<td height="1" bgcolor="#cccccc"></td>
	</tr>
	<tr>
		<td height="1" bgcolor="#ffffff"></td>
	</tr>
	<tr>
		<td height="4" bgcolor="#999999"></td>
	</tr>
	<tr>
		<td height="1" bgcolor="#ffffff"></td>
	</tr>
	<tr>
		<td height="1" bgcolor="#cccccc"></td>
	</tr>
	</table>
	</td>
</tr>
<% if f_jumin=1 then %>
<tr>
	<td align="center" style="word-break:break-all;padding:5px;"><input type="button" class="but" value="ID/주민등록번호로 검색" style="width:250;" onclick="location.href='../member/find_center_ij.asp'"></td>
</tr>
<% end if %>
<tr>
	<td align="center" style="word-break:break-all;padding:5px;"><input type="button" class="but" value="ID/전자우편으로 검색" style="width:250;" onclick="location.href='../member/find_center_ie.asp'"></td>
</tr>
<% if f_jumin=1 then %>
<tr>
	<td align="center" style="word-break:break-all;padding:5px;"><input type="button" class="but" value="이름/주민등록번호로 검색" style="width:250;" onclick="location.href='../member/find_center_nj.asp'"></td>
</tr>
<% end if %>
<tr>
	<td align="center" style="word-break:break-all;padding:5px;"><input type="button" class="but" value="이름/전자우편으로 검색" style="width:250;" onclick="location.href='../member/find_center_ne.asp'"></td>
</tr>
<tr>
	<td>
	<table width="100%" border="0" cellpadding="0" cellspacing="0" ID="Table3">
	<tr>
		<td height="1" bgcolor="#cccccc"></td>
	</tr>
	<tr>
		<td height="1" bgcolor="#ffffff"></td>
	</tr>
	<tr>
		<td height="4" bgcolor="#999999"></td>
	</tr>
	<tr>
		<td height="1" bgcolor="#ffffff"></td>
	</tr>
	<tr>
		<td height="1" bgcolor="#cccccc"></td>
	</tr>
	</table>
	</td>
</tr>
</form>
</table>

</div>

</body>
</html>