<% @Language = "VBScript" %>
<% Option Explicit %>
<% response.buffer = true %>

 


<!-- #include file="../inc/dbinfo.asp" -->
<!-- #include file="../inc/info_tb.asp" -->
<!-- #include file="../inc/joint.asp" -->


<% if session_login_name <> "admin" then Response.Redirect "../inc/error.asp?no=1" %>

<% call f_member %>

<html>
<head>
<title><%=board_title%></title>

<LINK rel="stylesheet" type="text/css" href="../inc/style.css">
<script language="javascript">
<!--
function numcheck()
{
	if ((event.keyCode<48) || (event.keyCode>57))
	event.returnValue=false;
}

function submit()
{
	document.inno.submit();
}

function box_1()
{ 
	document.all.box1.style.display = ""
	document.all.box2.style.display = "none"
}
function box_2()
{ 
	document.all.box1.style.display = "none"
	document.all.box2.style.display = ""
}

//-->
</script>
</head>
<body bgcolor="#FFFFFF" marginwidth="0" marginheight="0" leftmargin="0" topmargin="0">


<div align="center">
<br><br>
<table width="95%" border="0" cellpadding="0" cellspacing="0">
<form method="post" name="inno" action="point_ok.asp">

<tr>
	<td height="20" class="font1" align="center" bgcolor="#333333"><font color="#ffffff"><b>포인트 관련설정</b></font></td>
</tr>
<tr>
	<td height="1"></td>
</tr>
<tr bgcolor="#F7F7F7" height="25">
	<td class="form_title">&nbsp; <b>글을 쓸때마다 <input type="text" name="w_point" size="2" maxlength="5" class="form_input" value="<%=w_point%>" onkeyPress="numcheck()">점을 부여합니다.</b></td>
	<td class="font1" valign="center"></td>
</tr>
<tr bgcolor="#F7F7F7" height="25">
	<td class="form_title">&nbsp; <b>글을 읽을때마다 <input type="text" name="r_point" size="2" maxlength="5" class="form_input" value="<%=r_point%>" onkeyPress="numcheck()">점을 부여합니다.</b></td>
	<td class="font1" valign="center"></td>
</tr>
<tr bgcolor="#F7F7F7" height="25">
	<td class="form_title">&nbsp; <b>답변글을 쓸때마다 <input type="text" name="rw_point" size="2" maxlength="5" class="form_input" value="<%=rw_point%>" onkeyPress="numcheck()">점을 부여합니다.</b></td>
</tr>
<tr bgcolor="#F7F7F7" height="25">
	<td class="form_title">&nbsp; <b>코멘트를 쓸때마다 <input type="text" name="c_point" size="2" maxlength="5" class="form_input" value="<%=c_point%>" onkeyPress="numcheck()">점을 부여합니다.</b></td>
</tr>
<tr>
	<td height="1"></td>
</tr>
<tr>
	<td height="20" class="font1" align="center" bgcolor="#333333"><font color="#ffffff"><b>레벨조정 관련설정</b></font></td>
</tr>
<tr>
	<td height="1"></td>
</tr>
<tr bgcolor="#bbbbbb" height="25">
	<td class="font1">&nbsp; <b><input type="radio" name="level_select" value="1"<% if level_select=1 then %>checked<% end if %> onclick="javascript:box_1();"> 포인트에 따른 자동레벨조정 &nbsp; &nbsp &nbsp; <input type="radio" name="level_select" value="0"<% if level_select=0 then %>checked<% end if %> onclick="javascript:box_2();">관리자가 임의로 레벨조정</b></td>
</tr>
<tr bgcolor="#F7F7F7" id="box1" style="display:<% if level_select = 0 then %>none<% end if%>">
	<td class="form_title">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr bgcolor="#F7F7F7" height="25">
		<td class="form_title">&nbsp; <b><input type="text" name="level_1" size="2" maxlength="5" class="form_input" value="<%=level_1%>" onkeyPress="numcheck()" ID="Text1">점 포인트이상이 되면 자동으로 1 Level 이 됩니다.</b></td>
	</tr>
	<tr bgcolor="#F7F7F7" height="25">
		<td class="form_title">&nbsp; <b><input type="text" name="level_2" size="2" maxlength="5" class="form_input" value="<%=level_2%>" onkeyPress="numcheck()" ID="Text2">점 포인트이상이 되면 자동으로 2 Level 이 됩니다.</b></td>
	</tr>
	<tr bgcolor="#F7F7F7" height="25">
		<td class="form_title">&nbsp; <b><input type="text" name="level_3" size="2" maxlength="5" class="form_input" value="<%=level_3%>" onkeyPress="numcheck()" ID="Text3">점 포인트이상이 되면 자동으로 3 Level 이 됩니다.</b></td>
	</tr>
	<tr bgcolor="#F7F7F7" height="25">
		<td class="form_title">&nbsp; <b><input type="text" name="level_4" size="2" maxlength="5" class="form_input" value="<%=level_4%>" onkeyPress="numcheck()" ID="Text4">점 포인트이상이 되면 자동으로 4 Level 이 됩니다.</b></td>
	</tr>
	<tr bgcolor="#F7F7F7" height="25">
		<td class="form_title">&nbsp; <b><input type="text" name="level_5" size="2" maxlength="5" class="form_input" value="<%=level_5%>" onkeyPress="numcheck()" ID="Text5">점 포인트이상이 되면 자동으로 5 Level 이 됩니다.</b></td>
	</tr>
	<tr bgcolor="#F7F7F7" height="25">
		<td class="form_title">&nbsp; <b><input type="text" name="level_6" size="2" maxlength="5" class="form_input" value="<%=level_6%>" onkeyPress="numcheck()" ID="Text6">점 포인트이상이 되면 자동으로 6 Level 이 됩니다.</b></td>
	</tr>
	<tr bgcolor="#F7F7F7" height="25">
		<td class="form_title">&nbsp; <b><input type="text" name="level_7" size="2" maxlength="5" class="form_input" value="<%=level_7%>" onkeyPress="numcheck()" ID="Text7">점 포인트이상이 되면 자동으로 7 Level 이 됩니다.</b></td>
	</tr>
	<tr bgcolor="#F7F7F7" height="25">
		<td class="form_title">&nbsp; <b><input type="text" name="level_8" size="2" maxlength="5" class="form_input" value="<%=level_8%>" onkeyPress="numcheck()" ID="Text8">점 포인트이상이 되면 자동으로 8 Level 이 됩니다.</b></td>
	</tr>
	</table>
	</td>
</tr>
<tr bgcolor="#F7F7F7" id="box2" style="display:<% if level_select = 1 then %>none<% end if%>">
	<td class="font1" style="word-break:break-all;padding:10px;">
	회원레벨을 관리자님이 임의로 설정할 수 있도록 선택하셨습니다.<br>
	<br>
	회원 가입후 회원들은 기본레벨로 설정이 되며,<br>
	<br>
	레벨을 변경하고 싶으신 경우에는 해당 회원을 선택하신후 레벨을 임의로 변경을 해주셔야 합니다.<br>
	<br>
	포인트하고는 상관이 없음을 알려드립니다.<br>
	</td>
</tr>
<tr>
	<td>
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
	</table>
	</td>
</tr>
<tr>
	<td align="right" style="word-break:break-all;padding:10px;"><a href="javascript:submit();"><img src="../img/but_join_ok.gif" border="0"></a> &nbsp;</td>
</tr>
</form>
</table>
<br><br>
</div>
</body>
</html>

<%
	db.close
	Set db = nothing
%>

