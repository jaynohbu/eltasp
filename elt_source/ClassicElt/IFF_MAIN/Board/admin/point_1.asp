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
	<td height="20" class="font1" align="center" bgcolor="#333333"><font color="#ffffff"><b>����Ʈ ���ü���</b></font></td>
</tr>
<tr>
	<td height="1"></td>
</tr>
<tr bgcolor="#F7F7F7" height="25">
	<td class="form_title">&nbsp; <b>���� �������� <input type="text" name="w_point" size="2" maxlength="5" class="form_input" value="<%=w_point%>" onkeyPress="numcheck()">���� �ο��մϴ�.</b></td>
	<td class="font1" valign="center"></td>
</tr>
<tr bgcolor="#F7F7F7" height="25">
	<td class="form_title">&nbsp; <b>���� ���������� <input type="text" name="r_point" size="2" maxlength="5" class="form_input" value="<%=r_point%>" onkeyPress="numcheck()">���� �ο��մϴ�.</b></td>
	<td class="font1" valign="center"></td>
</tr>
<tr bgcolor="#F7F7F7" height="25">
	<td class="form_title">&nbsp; <b>�亯���� �������� <input type="text" name="rw_point" size="2" maxlength="5" class="form_input" value="<%=rw_point%>" onkeyPress="numcheck()">���� �ο��մϴ�.</b></td>
</tr>
<tr bgcolor="#F7F7F7" height="25">
	<td class="form_title">&nbsp; <b>�ڸ�Ʈ�� �������� <input type="text" name="c_point" size="2" maxlength="5" class="form_input" value="<%=c_point%>" onkeyPress="numcheck()">���� �ο��մϴ�.</b></td>
</tr>
<tr>
	<td height="1"></td>
</tr>
<tr>
	<td height="20" class="font1" align="center" bgcolor="#333333"><font color="#ffffff"><b>�������� ���ü���</b></font></td>
</tr>
<tr>
	<td height="1"></td>
</tr>
<tr bgcolor="#bbbbbb" height="25">
	<td class="font1">&nbsp; <b><input type="radio" name="level_select" value="1"<% if level_select=1 then %>checked<% end if %> onclick="javascript:box_1();"> ����Ʈ�� ���� �ڵ��������� &nbsp; &nbsp &nbsp; <input type="radio" name="level_select" value="0"<% if level_select=0 then %>checked<% end if %> onclick="javascript:box_2();">�����ڰ� ���Ƿ� ��������</b></td>
</tr>
<tr bgcolor="#F7F7F7" id="box1" style="display:<% if level_select = 0 then %>none<% end if%>">
	<td class="form_title">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr bgcolor="#F7F7F7" height="25">
		<td class="form_title">&nbsp; <b><input type="text" name="level_1" size="2" maxlength="5" class="form_input" value="<%=level_1%>" onkeyPress="numcheck()" ID="Text1">�� ����Ʈ�̻��� �Ǹ� �ڵ����� 1 Level �� �˴ϴ�.</b></td>
	</tr>
	<tr bgcolor="#F7F7F7" height="25">
		<td class="form_title">&nbsp; <b><input type="text" name="level_2" size="2" maxlength="5" class="form_input" value="<%=level_2%>" onkeyPress="numcheck()" ID="Text2">�� ����Ʈ�̻��� �Ǹ� �ڵ����� 2 Level �� �˴ϴ�.</b></td>
	</tr>
	<tr bgcolor="#F7F7F7" height="25">
		<td class="form_title">&nbsp; <b><input type="text" name="level_3" size="2" maxlength="5" class="form_input" value="<%=level_3%>" onkeyPress="numcheck()" ID="Text3">�� ����Ʈ�̻��� �Ǹ� �ڵ����� 3 Level �� �˴ϴ�.</b></td>
	</tr>
	<tr bgcolor="#F7F7F7" height="25">
		<td class="form_title">&nbsp; <b><input type="text" name="level_4" size="2" maxlength="5" class="form_input" value="<%=level_4%>" onkeyPress="numcheck()" ID="Text4">�� ����Ʈ�̻��� �Ǹ� �ڵ����� 4 Level �� �˴ϴ�.</b></td>
	</tr>
	<tr bgcolor="#F7F7F7" height="25">
		<td class="form_title">&nbsp; <b><input type="text" name="level_5" size="2" maxlength="5" class="form_input" value="<%=level_5%>" onkeyPress="numcheck()" ID="Text5">�� ����Ʈ�̻��� �Ǹ� �ڵ����� 5 Level �� �˴ϴ�.</b></td>
	</tr>
	<tr bgcolor="#F7F7F7" height="25">
		<td class="form_title">&nbsp; <b><input type="text" name="level_6" size="2" maxlength="5" class="form_input" value="<%=level_6%>" onkeyPress="numcheck()" ID="Text6">�� ����Ʈ�̻��� �Ǹ� �ڵ����� 6 Level �� �˴ϴ�.</b></td>
	</tr>
	<tr bgcolor="#F7F7F7" height="25">
		<td class="form_title">&nbsp; <b><input type="text" name="level_7" size="2" maxlength="5" class="form_input" value="<%=level_7%>" onkeyPress="numcheck()" ID="Text7">�� ����Ʈ�̻��� �Ǹ� �ڵ����� 7 Level �� �˴ϴ�.</b></td>
	</tr>
	<tr bgcolor="#F7F7F7" height="25">
		<td class="form_title">&nbsp; <b><input type="text" name="level_8" size="2" maxlength="5" class="form_input" value="<%=level_8%>" onkeyPress="numcheck()" ID="Text8">�� ����Ʈ�̻��� �Ǹ� �ڵ����� 8 Level �� �˴ϴ�.</b></td>
	</tr>
	</table>
	</td>
</tr>
<tr bgcolor="#F7F7F7" id="box2" style="display:<% if level_select = 1 then %>none<% end if%>">
	<td class="font1" style="word-break:break-all;padding:10px;">
	ȸ�������� �����ڴ��� ���Ƿ� ������ �� �ֵ��� �����ϼ̽��ϴ�.<br>
	<br>
	ȸ�� ������ ȸ������ �⺻������ ������ �Ǹ�,<br>
	<br>
	������ �����ϰ� ������ ��쿡�� �ش� ȸ���� �����Ͻ��� ������ ���Ƿ� ������ ���ּž� �մϴ�.<br>
	<br>
	����Ʈ�ϰ�� ����� ������ �˷��帳�ϴ�.<br>
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

