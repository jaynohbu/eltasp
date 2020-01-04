<% Option Explicit %>
<% response.buffer = true %>

 
<%
	tb="admin"
%>

<!-- #include file="../inc/dbinfo.asp" -->
<!-- #include file="../inc/info_tb.asp" -->
<!-- #include file="../inc/joint.asp" -->


<%
	if session_login_name <> "admin" then
		Response.Redirect "../member/login.asp?h_url="&h_url
	else
	
		dim a_menu,caseVar,file
%>
<html>
<head>
<title>▒ Admin Page ▒</title>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<LINK rel="stylesheet" type="text/css" href="../inc/style.css">
<script language="javascript">
<!-- //

function submit()
{
	document.inno.submit();
}

function box()
{ 
	   if (document.all.img_box.style.display != "none"){
           document.all.img_box.style.display = "none"
           }
           else {
           document.all.img_box.style.display = ""
           }
}
//-->
</script>
</HEAD>
<BODY BGCOLOR=#FFFFFF LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0>



<table border="0" width="100%" height="100%" cellpadding="0" cellspacing="0" ID="Table1">
<tr>
	<td height="75" align="center">
	<table border="0" width="772" height="75" cellpadding="0" cellspacing="0" ID="Table2">
	<tr>
		<td width="1" bgcolor="#cdcdcd"></td>
		<td width="770"><img src="../admin/img/top_innoboard.gif" border="0"></td>
		<td width="1" bgcolor="#cdcdcd"></td>
	</tr>
	</table>
	</td>
</tr>
<tr>
	<td height="1" bgcolor="#cdcdcd"></td>
</tr>
<tr>
	<td height="25" align="center">
	<table border="0" width="772" height="25" cellpadding="0" cellspacing="0" ID="Table3">
	<tr>
		<td width="1" bgcolor="#cdcdcd"></td>
		<td width="770" align="center">
		
		<!-- #include file="../admin/admin_top.asp" -->
				
		</td>
		<td width="1" bgcolor="#cdcdcd"></td>
	</tr>
	</table>
	</td>
</tr>
<tr>
	<td height="1" bgcolor="#cdcdcd"></td>
</tr>

<%
	'### 공통설정처리부분
	call f_member
	
	dim mode
%>


<tr>
	<td align="center">
	
	<table border="0" width="772" height="100%" cellpadding="0" cellspacing="0" ID="Table5">
	<tr>
		<td width="1" bgcolor="#cdcdcd"></td>
		<td width="770" align="center"><br>
		<!-- 내용 입력부분 시작 -->
		
		<table width="95%" border="0" cellpadding="0" cellspacing="0">
		<form method="post" name="inno" action="index_ok.asp?mode=img_name">

		<tr>
			<td height="20" class="font1" align="center" bgcolor="#333333"><font color="#ffffff"><b>Common</b></font></td>
		</tr>
		<tr>
			<td height="1"></td>
		</tr>
		<tr bgcolor="#F7F7F7" height="25">
			<td class="font1">&nbsp; <b><input type="checkbox" name="img_name" value="1" <% if img_name=1 then %> checked<% end if %> onclick="javascript:box();"> Use image name.</b></td>
		</tr>
		<tr bgcolor="#F7F7F7" height="25" id="img_box" style="display:<% if img_name <> 1 then %>none<% end if%>">
			<td class="font1">&nbsp; <b><input type="radio" name="up_com" value="0" <% if up_com = 0 or mode="" then %>checked<% end if %> ID="Radio3">ABC upload &nbsp; &nbsp; <input type="radio" name="up_com" value="1"<% if up_com = 1 then %> checked<% end if %> ID="Radio4">DEXT upload</b></td>
		</tr>
		<tr>
			<td align="right" style="word-break:break-all;padding:10px;"><a href="javascript:submit();"><img src="../img/but_join_ok.gif" border="0"></a> &nbsp;</td>
		</tr>
		</form>
		
		<%
				dim sql_t,rs_t,t_id,t_time,t_writeday
				
				sql_t = "select t_id,t_time,t_writeday from inno_term"
				set rs_t = db.execute(sql_t)
				
				if rs_t.bof or rs_t.eof then
				
				else
		%>
		<tr>
			<td height="20" class="font1" align="center" bgcolor="#333333"><font color="#ffffff"><b>Expire Date</b></font></td>
		</tr>
		<tr>
			<td height="20" class="font1">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
			
			<tr>
				<td align="center" colspan="4" height="1" bgcolor="#666666"></td>
			</tr>
			<tr bgcolor="#333333" height="25">
				<td width="100" style="color:#ffffff;" align="center"><b>ID</b></td>
				<td style="color:#ffffff;" align="center"><b>Renew term</b></td>
				<td width="100" style="color:#ffffff;" align="center"><b>Request Date</b></td>
				<td width="100" style="color:#ffffff;"></td>
			</tr>
			
			<%
				
				do until rs_t.eof
				t_id = rs_t("t_id")
				t_time = rs_t("t_time")
				t_writeday = left(rs_t("t_writeday"),10)
				
			%>
			<form method="post" name="inno_term<%=t_id%>" action="index_ok.asp?mode=term" ID="form1">
			<input type="hidden" name="id" value="<%=t_id%>">
			<tr>
				<td width="100" align="center"><%=t_id%></td>
				<td align="center">
				<select name="t_time" class="form" style="background:#FFFFFF;color:333333;font-weight:bold;text-align:center;">
				<option value=""<% if t_time = "-1" then %> selected<% end if %>>Select</option>
				<option value="0"<% if t_time = "0" then %> selected<% end if %>>Unlimted</option>
				<option value="1"<% if t_time = "1" then %> selected<% end if %>>1</option>
				<option value="3"<% if t_time = "3" then %> selected<% end if %>>3</option>
				<option value="6"<% if t_time = "6" then %> selected<% end if %>>6</option>
				<option value="12"<% if t_time = "12" then %> selected<% end if %>>12</option>
				<option value="24"<% if t_time = "24" then %> selected<% end if %>>24</option>
				<option value="36"<% if t_time = "36" then %> selected<% end if %>>36</option>
				</select>
				개월</td>
				<td width="100" align="center"><%=t_writeday%></td>
				<td width="100" align="center"><a href="javascript:document.inno_term<%=t_id%>.submit();"><img src="../img/but_consent.gif" border="0"></a></td>
			</tr>
			<tr>
				<td align="center" colspan="4" height="1" bgcolor="#666666"></td>
			</tr>
			</form>
			<%
				rs_t.movenext
				loop
				
				
				rs_t.close
				set rs_t = nothing
			%>
			
			</table>
			</td>
		</tr>
		<% end if %>
		</table>
		<!-- 내용 입력부분 끝 -->
		</td>
		<td width="1" bgcolor="#cdcdcd"></td>
	</tr>
	
	</table>
	</td>
</tr>
<tr>
	<td height="1" bgcolor="#cdcdcd"></td>
</tr>
<tr>
	<td height="35" align="center">
	<table border="0" width="772" height="35" cellpadding="0" cellspacing="0" ID="Table6">
	<tr>
		<td width="1" bgcolor="#cdcdcd"></td>
		<td width="770" valign="bottom" align="right" style="word-break:break-all;padding:10px;"><!-- #include file="../inc/copyright.asp" --></td>
		<td width="1" bgcolor="#cdcdcd"></td>
	</tr>
	</table>
	</td>
</tr>
<tr>
	<td height="1" bgcolor="#cdcdcd"></td>
</tr>
<tr>
	<td height="100%" align="center">
	<table border="0" width="772" height="100%" cellpadding="0" cellspacing="0" ID="Table7">
	<tr>
		<td width="1" bgcolor="#cdcdcd"></td>
		<td width="770"></td>
		<td width="1" bgcolor="#cdcdcd"></td>
	</tr>
	</table>
	</td>
</tr>
</table>

</body>
</html>

<% end if%>