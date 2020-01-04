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

	if (document.inno.name.value =="") {
		alert("이름을 입력해 주세요.");
		document.inno.name.focus();
		return;
	}
	
	var jumin1 = inno.jumin1.value;
	var jumin2 = inno.jumin2.value;

	if (jumin1 == "" || jumin2 =="") {
		alert("주민등록번호를 입력해 주세요.");
		document.inno.jumin1.focus();
		return;
	}else{

	var f1=jumin1.substring(0,1);
	var f2=jumin1.substring(1,2);
	var f3=jumin1.substring(2,3);
	var f4=jumin1.substring(3,4);
	var f5=jumin1.substring(4,5);
	var f6=jumin1.substring(5,6);
	var hap=f1*2+f2*3+f3*4+f4*5+f5*6+f6*7;
	var l1=jumin2.substring(0,1);
	var l2=jumin2.substring(1,2);
	var l3=jumin2.substring(2,3);
	var l4=jumin2.substring(3,4);
	var l5=jumin2.substring(4,5);
	var l6=jumin2.substring(5,6);
	var l7=jumin2.substring(6,7);
	hap=hap+l1*8+l2*9+l3*2+l4*3+l5*4+l6*5;
	var rem=hap%11;
	rem=(11-rem)%10;
	if (rem != l7) 
	{
	  alert('주민등록번호가 맞지 않습니다.');
	  document.inno.jumin2.focus();
	  return;
	}
	}
	var letters = 'ghijklabvwxyzABCDEFef)_+|<>?:mnQRSTU~!@#$%^VWXYZ`1234567opGHIJKLu./;'+"'"+'[]MNOP890-='+'\\'+'&*("{},cdqrst'+"\n";
	var split = letters.split("");
	var num = '';
	var c1 = '';
	
	var encrypted = '';
	var it = document.inno.jumin2.value;
	var c = '';
	var b = '0';
	var chars = it.split("");while(b<it.length){c = '0';while(c<letters.length){if(split[c] == chars[b]){if(c == "0") { c = ""; }if(eval(c+10) >= letters.length){num = eval(10-(letters.length-c));encrypted += split[num];}else{num = eval(c+10);encrypted += split[num];}}c++;}b++;}document.inno.jumin2.value = encrypted;encrypted = '';	
	
	
	document.inno.submit();

}

function numcheck()
{
	if ((event.keyCode<48) || (event.keyCode>57))
	event.returnValue=false;
}

function EnterCheck(i)  {
	if(event.keyCode ==13)
	switch(i) {
		case 1:
			document.inno.jumin1.focus();
			break;
		case 2:
			submit();
			break;
		
	}
}

//-->
</script>
</head>
<body bgcolor="<%=bgcolor%>" marginwidth="0" marginheight="0" leftmargin="0" topmargin="0"<% if request.Form("process") = "" then %> onload="document.inno.name.focus();"<% end if %>>

<div align="center">
<br>

<% if request.Form("process") = "" then %>
<%
	dim num,sw
	
	sw = Request.QueryString("sw")
	num = Request.QueryString("num")
%>


<table width="300" border="0" cellpadding="0" cellspacing="0" ID="Table1">
<form name="inno" method="POST" action="find_center_nj.asp" ID="form1">
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
	<td width="100" class="form_title" align="right">이름 &nbsp;</td>
	<td><input type="text" name="name" size="15" class="form_input" onKeyDown="EnterCheck(1);"></td>
</tr>

<tr style="word-break:break-all;padding:3px;" bgcolor="#eeeeee">
	<td width="100" class="form_title" align="right">주민등록번호 &nbsp;</td>
	<td><input type="text" name="jumin1" size="6" maxlength="6" class="form_input" onkeyPress="numcheck()"> - <input type="password" name="jumin2" size="7" maxlength="7" class="form_input" onkeyPress="numcheck()" onKeyDown="EnterCheck(2);"></td>
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
	dim name,jumin,sql1,rs1,jumin1,jumin2
	
	name = request.Form("name")
	jumin1 = request.Form("jumin1")
	jumin2 = request.Form("jumin2")
	jumin = jumin1&"-"&jumin2
	
	SQL = "SELECT id,name,email,jumin FROM member where elt_account_number=" & elt_account_number & "AND name='"&name&"' and jumin='"&jumin&"'"
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
<form name="inno" method="POST" action="find_center_nj.asp" ID="Form2">
<input type="hidden" name="process" value="ok" ID="Hidden5">
<input type="hidden" name="pro_pin" value="ok" ID="Hidden2">
<input type="hidden" name="free_pin" value="<%=free_pin%>" ID="Hidden3">
<input type="hidden" name="o_pin" value="<%=free_pin%>" ID="Hidden7">
<input type="hidden" name="name" value="<%=name%>" ID="Hidden4">
<input type="hidden" name="jumin1" value="<%=jumin1%>" ID="Hidden6">
<input type="hidden" name="jumin2" value="<%=jumin2%>" ID="Hidden8">

<Meta http-equiv="Refresh" content="0; url=javascript:ok()">
</form>
<% else %>

<%

	free_pin = request.Form("free_pin")
	o_pin = request.Form("o_pin")
	'### 데이터베이스의 정보에 임시번호로 수정
	SQL = "Update member set pin = '" & o_pin & "'"
	SQL = SQL & " where name='"&name&"' and jumin='"&jumin&"'"

	db.execute SQL
	
%>

<tr> 
	<td colspan="2">
	<table border="0" width="300" cellpadding="0" cellspacing="0" ID="Table7">
<tr align="center" height="25" bgcolor="#333333">
	<td><font color="#ffffff"><b>아이디와 비밀번호</b></font></td>
</tr>
<tr>
	<td style="word-break:break-all;padding:5px;">
	<b>아이디</b> :  <%=rs("id")%><br><br>
	<b>임시 비밀번호</b> :  <input type=text name=pin value=<%=free_pin%> class=form_input readonly><br>
	</td>
</tr>
<tr align="center" height="25" bgcolor="#333333">
	<td><a href="javascript:close();"><img src="../img/but_ok.gif" border="0"></a></td>
</tr>
</table>
	</td>
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