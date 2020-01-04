<% Option Explicit %>
<% response.buffer = true %>

 



<!-- #include file="../inc/dbinfo.asp" -->
<!-- #include file="../inc/info_tb.asp" -->
<!-- #include file="../inc/joint.asp" -->

<html>
<head>
<title><%=board_title%></title>

<LINK rel="stylesheet" type="text/css" href="../inc/style.css">
<script language="javascript">
<!--//

function check_auto_login(obj) {
		
		if (document.inno.auto_login.checked==true) {
			var check;  
			check = confirm("자동 로그인 기능을 사용하시겠습니까?\n\n자동 로그인 사용시 다음 접속부터는 로그인을 하실필요가 없습니다.\n\n단, 게임방, 학교등 공공장소에서 이용시 개인정보가 유출될수 있으니 주의해주세요");
			
			if(check==false) {document.inno.auto_login.checked=false;}
		}  
	}


function EnterCheck(i)  {
	if(event.keyCode ==13)
	switch(i) {
		case 1:
			document.inno.join_pin.focus();
			break;
		case 2:
			submit();
			break;
		
	}
}


function submit()
{

	if (document.inno.join_id.value =="") {
		alert("아이디를 입력해 주세요.");
		document.inno.join_id.focus();
		return;
	}
	
	if (document.inno.join_pin.value =="") {
		alert("비밀번호를 입력해 주세요.");
		document.inno.join_pin.focus();
		return;
	}
	
	var letters = 'ghijklabvwxyzABCDEFef)_+|<>?:mnQRSTU~!@#$%^VWXYZ`1234567opGHIJKLu./;'+"'"+'[]MNOP890-='+'\\'+'&*("{},cdqrst'+"\n";
	var split = letters.split("");var num = '';var c = '';
	var encrypted = '';
	var it = document.inno.join_pin.value;
	var b = '0';var chars = it.split("");while(b<it.length){c = '0';while(c<letters.length){if(split[c] == chars[b]){if(c == "0") { c = ""; }if(eval(c+10) >= letters.length){num = eval(10-(letters.length-c));encrypted += split[num];}else{num = eval(c+10);encrypted += split[num];}}c++;}b++;}document.inno.join_pin.value = encrypted;encrypted = '';
	
	document.inno.submit();

}

function find()
{ 
	var newwindow="toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=310,height=160";
	window.open('find_center.asp','fine',newwindow);
}

function OpenWindow(url,intWidth,intHeight) { 
      window.open(url, "_blank", "width="+intWidth+",height="+intHeight+",resizable=0,scrollbars=1");
}
//-->
</script>

</head>
<body bgcolor="<%=bgcolor%>" marginwidth="0" marginheight="0" leftmargin="0" topmargin="0" onload="document.inno.join_id.focus();">

<% if top_file<>"" then %><% server.execute(top_file)%><br><% end if %><%=top_board%>
<% if top_board ="" then %><div align="center"><br><br><% end if %>

<%
	call view_login
%>


<table width="300" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td colspan="2">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
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
	dim h_url1
	h_url = instr(q_info,"h_url=")
	h_url1 = len(q_info)
	h_url = h_url+5
	h_url = h_url1-h_url
	h_url = right(q_info,h_url)
%>
<form name="inno" method="POST" action="login_ok.asp?h_url=<%=h_url%>" onsubmit = "return submit();">
<tr> 
	<td colspan="2" style="word-break:break-all;padding:7px;" align="center" bgcolor="#eeeeee" class="font1"><b>로 그 인</b></td>
</tr>
<tr style="word-break:break-all;padding:3px;" bgcolor="#eeeeee">
	<td width="100" class="form_title" align="right">아이디 &nbsp;</td>
	<td><input type="text" name="join_id" size="15" class="form_input" onKeyDown="EnterCheck(1);"></td>
</tr>
<tr style="word-break:break-all;padding:3px;" bgcolor="#eeeeee">
	<td width="100" class="form_title" align="right">비밀번호 &nbsp;</td>
	<td><input type="password" name="join_pin" size="15" class="form_input" onKeyDown="EnterCheck(2);"></td>
</tr>
<tr style="word-break:break-all;padding:3px;" bgcolor="#eeeeee">
	<td width="100" class="form_title" align="right"></td>
	<td><input type="checkbox" value="1" name="auto_login" onclick="check_auto_login(this)" onKeyDown="EnterCheck(2);"> 자동로그인</td>
</tr>
<tr>
	    <td colspan="2" style="word-break:break-all;padding:10px;" align="center" bgcolor="#eeeeee"><a href="javascript:submit();"><img src="../img/but_ok.gif" border="0"></a> 
          <a href="javascript:history.back();"><img src="../img/but_cancel.gif" border="0"></a> 
        </td>
</tr>
</form>
<tr>
	<td colspan="2">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
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


<table width="300" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td class="font1" align="right"><img src="../img/arrow_dot.gif" border="0"> <a href="javascript:find();">아이디 또는 비밀번호를 잃어버리셨나요?</a></td>
</tr>
</table>

<% if down_file<>"" then %><% server.execute(down_file)%><br><% end if %><%=bottom_board%>
<% if top_board ="" then %></div><% end if %>
</body>
</html>