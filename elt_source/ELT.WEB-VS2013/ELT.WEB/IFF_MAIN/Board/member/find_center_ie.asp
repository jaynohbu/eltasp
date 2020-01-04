<% Option Explicit %>
<% response.buffer = true %>

 



<!-- #include file="../inc/dbinfo.asp" -->
<!-- #include file="../inc/info_tb.asp" -->

<html>
<head>
<title><%=board_title%></title>

<LINK rel="stylesheet" type="text/css" href="../inc/style.css">
<script language="javascript">
<!--//
function submit()
{

	if (document.inno.id.value =="") {
		alert("아이디를 입력해 주세요.");
		document.inno.id.focus();
		return;
	}
	
	if (document.inno.email.value =="") {
		alert("전자우편을 입력해 주세요.");
		document.inno.email.focus();
		return;
	}else{
	if (document.inno.email.value.length > 1)  {
	str = document.inno.email.value;
	if(	(str.indexOf("@")==-1) || (str.indexOf(".")==-1)){
		alert("E-mail 주소형식이 맞지않습니다.\n비밀번호 분실시 필요합니다.")
		document.inno.email.focus();
		return;
	}
	}
	}
	document.inno.submit();


}



function EnterCheck(i)  {
	if(event.keyCode ==13)
	switch(i) {
		case 1:
			document.inno.email.focus();
			break;
		case 2:
			submit();
			break;
		
	}
}

//-->
</script>
</head>
<body bgcolor="<%=bgcolor%>" marginwidth="0" marginheight="0" leftmargin="0" topmargin="0"<% if request.Form("process") = "" then %> onload="document.inno.id.focus();"<% end if %>>

<div align="center">
<br>

<% if request.Form("process") = "" then %>
<%
	dim num,sw
	
	sw = Request.QueryString("sw")
	num = Request.QueryString("num")
%>


<table width="300" border="0" cellpadding="0" cellspacing="0" ID="Table1">
<form name="inno" method="POST" action="find_center_ie.asp" ID="form1">
<input type="hidden" name="process" value="ok" ID="Hidden1">
<tr>
	<td colspan="2">
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
<tr> 
	<td colspan="2" style="word-break:break-all;padding:7px;" align="center" bgcolor="#eeeeee" class="font1"><b>ID / PW 분실센터</b></td>
</tr>
<tr style="word-break:break-all;padding:3px;" bgcolor="#eeeeee">
	<td width="100" class="form_title" align="right">아이디 &nbsp;</td>
	<td><input type="text" name="id" size="15" class="form_input" onKeyDown="EnterCheck(1);"></td>
</tr>

<tr style="word-break:break-all;padding:3px;" bgcolor="#eeeeee">
	<td width="100" class="form_title" align="right">전자우편 &nbsp;</td>
	<td><input type="text" name="email" size="15" class="form_input" onKeyDown="EnterCheck(2);"></td>
</tr>
<tr>
	<td colspan="2" style="word-break:break-all;padding:10px;" align="center" bgcolor="#eeeeee"><a href="javascript:submit();"><img src="../img/but_ok.gif" border="0"></a> <a href="javascript:history.back();"><img src="../img/but_cancel.gif" border="0"></a></td>
</tr>
<tr>
	<td colspan="2">
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

<% else %>

<table width="300" border="0" cellpadding="0" cellspacing="0" ID="Table4">
<tr>
	<td colspan="2">
	<table width="100%" border="0" cellpadding="0" cellspacing="0" ID="Table5">
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
<%
	dim id,email,sql1,rs1
	
	id = request.Form("id")
	email = request.Form("email")

	SQL = "SELECT id,name,email FROM member where elt_account_number=" & elt_account_number & "AND id='"&id&"' and email='"&email&"'"
	Set rs=db.execute(SQL)
	
	SQL1 = "SELECT name,email FROM member where elt_account_number=" & elt_account_number & "AND id='admin'"
	Set rs1=db.execute(SQL1)
%>

<% if rs.BOF or rs.EOF then %>
<tr> 
	<td colspan="2" style="word-break:break-all;padding:7px;" align="center" bgcolor="#eeeeee" class="font1"><b>오 류 발 생</b></td>
</tr>
<tr>
	<td colspan="2" style="word-break:break-all;padding:10px;" align="center" bgcolor="#eeeeee">입력하신 정보와<br>일치하는 정보가 없습니다.</td>
</tr>
<tr>
	<td colspan="2" style="word-break:break-all;padding:10px;" align="center" bgcolor="#eeeeee"><a href="javascript:history.back();"><img src="../img/but_back.gif" border="0"></a></td>
</tr>
<% else %>
<% if request.Form("pro_pin") = "" then %>
<script language="javascript">
<!--//
function ok()
{

	var letters = 'ghijklabvwxyzABCDEFef)_+|<>?:mnQRSTU~!@#$%^VWXYZ`1234567opGHIJKLu./;'+"'"+'[]MNOP890-='+'\\'+'&*("{},cdqrst'+"\n";
	var split = letters.split("");var num = '';var c = '';
	var encrypted = '';
	var it = document.inno.free_pin.value;
	var b = '0';var chars = it.split("");while(b<it.length){c = '0';while(c<letters.length){if(split[c] == chars[b]){if(c == "0") { c = ""; }if(eval(c-10) < 0){num = eval(letters.length-(10-c));encrypted += split[num];}else{num = eval(c-10);encrypted += split[num];}}c++;}b++;}document.inno.free_pin.value = encrypted;encrypted = '';
	
	document.inno.submit();

}
//-->
</script>
<%
	dim free_pin,o_pin
	
	'### 임시비밀번호 발급
	Randomize 
	free_pin = int((999999-1000+1)*Rnd+1000)
%>
<form name="inno" method="POST" action="find_center_ie.asp" ID="Form2">
<input type="hidden" name="process" value="ok" ID="Hidden5">
<input type="hidden" name="pro_pin" value="ok" ID="Hidden2">
<input type="hidden" name="free_pin" value="<%=free_pin%>" ID="Hidden3">
<input type="hidden" name="o_pin" value="<%=free_pin%>" ID="Hidden7">
<input type="hidden" name="id" value="<%=id%>" ID="Hidden4">
<input type="hidden" name="email" value="<%=email%>" ID="Hidden6">
</form>
<Meta http-equiv="Refresh" content="0; url=javascript:ok()">
<% else %>

<%

	free_pin = request.Form("free_pin")
	o_pin = request.Form("o_pin")
	'### 데이터베이스의 정보에 임시번호로 수정
	SQL = "Update member set pin = '" & o_pin & "'"
	SQL = SQL & " where id='"&id&"' and email='"&email&"'"

	db.execute SQL
	
	'### 아이디와 임시비밀번호를 이메일로 발송
	Dim html,objMail
	
	
	html = "<html>"
	html = html & "<head>"
	html = html & "<title>정보분실센터</title>"
	html = html & "<style type=text/css>"
	html = html & "td {  font-family: verdana,돋움, Arial; color: #333333; font-size: 9pt}"
	html = html & ".form_input{border:solid 1;font-family:verdana,verdana;font-size:9pt;color:000000;background-color:white;font-size:8pt;font-family:Arial;vertical-align:top;border-left-color:D7D6D6;border-right-color:D7D6D6;border-top-color:D7D6D6;border-bottom-color:D7D6D6;height:18px;}"
	html = html & "</style>"
	html = html & "</head>"
	html = html & "<body>"
	html = html & "<table border=0 width=400 cellpadding=0 cellspacing=0>"
	html = html & "<tr align=center height=25 bgcolor=#333333>"
	html = html & "<td><font color=#ffffff><b>아이디와 비밀번호 분실건</b></font></td>"
	html = html & "</tr>"
	html = html & "<tr align=center height=25 bgcolor=#efefef>"
	html = html & "<td><b>임시비밀번호 사용방법</b></td>"
	html = html & "</tr>"
	html = html & "<tr>"
	html = html & "<td style=word-break:break-all;padding:5px;>"
	html = html & "1. 임시 발급된 비밀번호를 마우스로 드래그해서 복사를 합니다.<br>"
	html = html & "2. 로그인 창으로 이동하여 비밀번호에 붙여넣기를 합니다.<br>"
	html = html & "3. 로그인을 합니다.<br>"
	html = html & "4. 정보관리에서 새비밀번호를 입력합니다.<br>"
	html = html & "</td>"
	html = html & "</tr>"
	html = html & "<tr align=center height=25 bgcolor=#efefef>"
	html = html & "<td><b>아이디와 임시 비밀번호</b></td>"
	html = html & "</tr>"
	html = html & "<tr>"
	html = html & "<td style=word-break:break-all;padding:5px;>"
	html = html & "<b>아이디</b> : "&rs("id")&"<br>"
	html = html & "<b>임시 비밀번호</b> :  <input type=text name=pin value="&free_pin&" class=form_input readonly><br><br>"
	html = html & "</td>"
	html = html & "</tr>"
	html = html & "<tr align=center height=25 bgcolor=#333333>"
	html = html & "<td></td>"
	html = html & "</tr>"
	html = html & "</table></body></html>"
	
	
	

	Set objMail = Server.CreateObject("CDONTS.NewMail")

	objMail.Value("From") = rs1("name") & "<" & rs1("email") & ">"
	objMail.To = rs("email")
	objMail.Subject = "분실하신 아이디와 임시비밀번호 입니다."
	objMail.BodyFormat = 0
	objMail.MailFormat = 0
	objMail.Body = html
	objMail.Send()
	Set objMail = Nothing



%>
<tr> 
	<td colspan="2" style="word-break:break-all;padding:7px;" align="center" bgcolor="#eeeeee" class="font1"><b>정보 검색 완료</b></td>
</tr>
<tr>
	<td colspan="2" style="word-break:break-all;padding:10px;" align="center" bgcolor="#eeeeee">입력하신 메일로 관련 정보를 발송하였습니다.</td>
</tr>
<tr>
	<td colspan="2" style="word-break:break-all;padding:10px;" align="center" bgcolor="#eeeeee"><a href="javascript:close();"><img src="../img/but_ok.gif" border="0"></a></td>
</tr>
<% end if %>
<% end if %>
<tr>
	<td colspan="2">
	<table width="100%" border="0" cellpadding="0" cellspacing="0" ID="Table6">
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
</table>

<%
	db.Close
	Set db=nothing

	end if
%>
</div>

</body>
</html>