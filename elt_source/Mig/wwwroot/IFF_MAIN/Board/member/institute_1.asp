<% @Language = "VBScript" %>
<% Option Explicit %>
<% response.buffer = true %>

 


<!-- #include file="../inc/dbinfo.asp" -->
<!-- #include file="../inc/info_tb.asp" -->
<!-- #include file="../inc/joint.asp" -->


<% if session_login_name <> "admin"  then Response.Redirect "../inc/error.asp?no=1" %>

<% call f_member %>

<html>
<head>
<title><%=board_title%></title>

<LINK rel="stylesheet" type="text/css" href="../inc/style.css">
<script language="javascript">
<!--

function submit()
{
	document.inno.submit();
}

function box()
{ 
	   if (document.all.box.style.display != "none"){
           document.all.box.style.display = "none"
           }
           else {
           document.all.box.style.display = ""
           }
}

//-->
</script>
</head>
<body bgcolor="#FFFFFF" marginwidth="0" marginheight="0" leftmargin="0" topmargin="0">


<div align="center">
<br>
<table width="95%" border="0" cellpadding="0" cellspacing="0">
<form method="post" name="inno" action="institute_ok.asp">
<tr>
	<td colspan="2" height="12">
	<table width=100% border=1 cellspacing=0 cellpadding=0 bgcolor=#EEEEEE bordercolorlight=gray bordercolordark=#FFFFFF ID="Table5">
	<tr>
		<td style=font-family:Arial;font-size:1pt;color:gray nowrap>&nbsp;</td>
	</tr>
	</table>
	</td>
</tr>
<tr>
	<td width="100" align="right" class="form_title"><b>기본권한 &nbsp;</b></td>
	<td>
	<select name="f_level" size="1" ID="Select1">
	<%	
		dim f_level1,f_level2,j
		
		j=10
		do while j > 0
		f_level1 = j & " Level"
		f_level2 = j
		
	%>
	<option value="<%=f_level2%>"<% if f_level2=f_level then %>selected<% end if %>><%=f_level1%></option>
	<%
		j=j-1
		loop
	%>
	</select>
	</td>
</tr>
</table>
<input type="hidden" name="f_term" value="0">
<table width="95%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td colspan="2" height="12" background="../img/join_line.gif"><img src="../img/join_line.gif" border="0"></td>
</tr>
</table>
<table width="95%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="100" align="right" class="form_title">닉네임 &nbsp;</td>
	<td class="form_title" align="left"><input type="checkbox" name="f_nickname" value="1" <% if f_nickname=1 then %> checked<% end if %>> 닉네임을 입력 받습니다.</td>
</tr>
</table>
<table width="95%" border="0" cellpadding="0" cellspacing="0" ID="Table3">
<tr>
	<td colspan="2" height="12" background="../img/join_line.gif"><img src="../img/join_line.gif" border="0"></td>
</tr>
</table>
<table width="95%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="100" align="right" class="form_title">메신져 &nbsp;</td>
	<td class="form_title" align="left"><input type="checkbox" name="f_msg" value="1" <% if f_msg=1 then %> checked<% end if %>> 메신져 정보를 입력 받습니다.</td>
</tr>
</table>
<table width="95%" border="0" cellpadding="0" cellspacing="0" ID="Table2">
<tr>
	<td colspan="2" height="12" background="../img/join_line.gif"><img src="../img/join_line.gif" border="0"></td>
</tr>
</table>
<table width="95%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="100" align="right" class="form_title"><b>주민등록번호 &nbsp;</b></td>
	<td class="form_title" align="left"><input type="checkbox" name="f_jumin" value="1" <% if f_jumin=1 then %> checked<% end if %>> 주민등록번호를 입력 받습니다.</td>
</tr>
</table>
<table width="95%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td colspan="2" height="12" background="../img/join_line.gif"><img src="../img/join_line.gif" border="0"></td>
</tr>
</table>
<table width="95%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="100" align="right" class="form_title">생년월일 &nbsp;</td>
	<td class="form_title"><input type="checkbox" name="f_birthday" value="1" <% if f_birthday=1 then %> checked<% end if %>> 생년월일을 입력 받습니다.</td>
</tr>
</table>
<table width="95%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td colspan="2" height="12" background="../img/join_line.gif"><img src="../img/join_line.gif" border="0"></td>
</tr>
</table>
<table width="95%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="100" align="right" class="form_title">주 소 &nbsp;</td>
	<td class="form_title"><input type="checkbox" name="f_address" value="1" <% if f_address=1 then %> checked<% end if %>> 주소를 입력 받습니다.</td>
</tr>
</table>
<table width="95%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td colspan="2" height="12" background="../img/join_line.gif"><img src="../img/join_line.gif" border="0"></td>
</tr>
</table>
<table width="95%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="100" align="right" class="form_title">전화번호 &nbsp;</td>
	<td class="form_title"><input type="checkbox" name="f_tel" value="1" <% if f_tel=1 then %> checked<% end if %>> 전화번호를 입력 받습니다.</td>
</tr>
</table>
<table width="95%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td colspan="2" height="12" background="../img/join_line.gif"><img src="../img/join_line.gif" border="0"></td>
</tr>
</table>
<table width="95%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="100" align="right" class="form_title">핸드폰 &nbsp;</td>
	<td class="form_title"><input type="checkbox" name="f_phone" value="1" <% if f_phone=1 then %> checked<% end if %>> 핸드폰 번호를 입력 받습니다.</td>
</tr>
</table>
<table width="95%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td colspan="2" height="12" background="../img/join_line.gif"><img src="../img/join_line.gif" border="0"></td>
</tr>
</table>
<table width="95%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="100" align="right" class="form_title">취 미 &nbsp;</td>
	<td class="form_title"><input type="checkbox" name="f_hobby" value="1" <% if f_hobby=1 then %> checked<% end if %>> 취미를 입력 받습니다.</td>
</tr>
</table>
<table width="95%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td colspan="2" height="12" background="../img/join_line.gif"><img src="../img/join_line.gif" border="0"></td>
</tr>
</table>
<table width="95%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="100" align="right" class="form_title">직 업 &nbsp;</td>
	<td class="form_title"><input type="checkbox" name="f_job" value="1" <% if f_job=1 then %> checked<% end if %>> 직업을 입력 받습니다.</td>
</tr>
</table>
<table width="95%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td colspan="2" height="12" background="../img/join_line.gif"><img src="../img/join_line.gif" border="0"></td>
</tr>
</table>
<table width="95%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="100" align="right" class="form_title">자기소개 &nbsp;</td>
	<td class="form_title"><input type="checkbox" name="f_introduce" value="1" <% if f_introduce=1 then %> checked<% end if %>> 자기소개를 입력 받습니다.</td>
</tr>
</table>
<table width="95%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td colspan="2" height="12" background="../img/join_line.gif"><img src="../img/join_line.gif" border="0"></td>
</tr>
</table>
<table width="95%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="100" align="right" class="form_title">메일링 리스트 &nbsp;</td>
	<td class="form_title"><input type="checkbox" name="f_mailling" value="1" <% if f_mailling=1 then %> checked<% end if %>> 메일링 리스트 가입선택을 입력 받습니다.</td>
</tr>
</table>
<table width="95%" border="0" cellpadding="0" cellspacing="0" ID="Table4">
<tr>
	<td colspan="2" height="12" background="../img/join_line.gif"><img src="../img/join_line.gif" border="0"></td>
</tr>
</table>
<table width="95%" border="0" cellpadding="0" cellspacing="0" ID="Table1">
<tr>
	<td width="100" align="right" class="form_title">약 관 &nbsp;</td>
	<td class="form_title"><input type="checkbox" name="f_agreement" value="1" <% if f_agreement=1 then %> checked<% end if %> onclick="javascript:box();"> 약관동의를 입력 받습니다.</td>
</tr>
</table>
<table width="95%" border="0" cellpadding="0" cellspacing="0" ID="Table6">
<tr>
	<td colspan="2" height="12" background="../img/join_line.gif"><img src="../img/join_line.gif" border="0"></td>
</tr>
</table>
<table width="95%" border="0" cellpadding="0" cellspacing="0" id="box" style="display:<% if f_agreement <> 1 then %>none<% end if%>">
<tr>
	<td width="100" align="right" class="form_title">약관내용 &nbsp;</td>
	<td class="form_title"><textarea name="f_agreement_text" cols="90" rows="7" class="form_textarea"><%=f_agreement_text%></textarea></td>
</tr>
</table>
<table width="95%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td colspan="2" height="12" background="../img/join_line.gif">
	<table width=100% border=1 cellspacing=0 cellpadding=0 bgcolor=#EEEEEE bordercolorlight=gray bordercolordark=#FFFFFF ID="Table5">
	<tr>
		<td style=font-family:Arial;font-size:1pt;color:gray nowrap>&nbsp;</td>
	</tr>
	</table>
	</td>
</tr>
<tr>
	<td colspan="2" align="right"><a href="javascript:submit();"><img src="../img/but_join_ok.gif" border="0"></a> &nbsp;<br><br></td>
</tr>
</form>
</table>
</div>
</body>
</html>
<%
	db.close
	Set db = nothing
%>

