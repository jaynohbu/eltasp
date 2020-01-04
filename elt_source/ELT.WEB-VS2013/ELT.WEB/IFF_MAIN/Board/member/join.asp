<% @Language = "VBScript" %>
<% Option Explicit %>
<% response.buffer = true %>





<!-- #include file="../inc/dbinfo.asp" -->
<!-- #include file="../inc/joint.asp" -->
<!-- #include file="../inc/info_tb.asp" -->


<% call f_member %>

<html>
<head>
<title>회원가입</title>

<LINK rel="stylesheet" type="text/css" href="../inc/style.css">
<script language="javascript">
<!--

function submit()
{
<% if f_agreement = 1 then %>
	if (document.inno.agree.checked == false) {
			alert("약관에 동의하지 않으면 가입하실 수 없습니다.");
			document.inno.agree.focus();
			return;
	}
<% end if %>

	if (document.inno.id.value == "") {
		alert("아이디를 입력해 주세요.");
		document.inno.id.focus();
		return;
	}
	
	if (document.inno.id.value.length < 4) {
		alert("아이디는 4자 이상이어야 합니다");
		document.inno.id.focus();
		return;
	}	
	
	if (document.inno.pin.value =="") {
		alert("비밀번호를 입력해 주세요.");
		document.inno.pin.focus();
		return;
	}
	if (document.inno.pin.value != document.inno.pin1.value) {
		alert("비밀번호가 동일하지 않습니다.");
		document.inno.pin1.focus();
		return;
	}
	
	if (document.inno.name.value == "") {
		alert("이름을 입력해 주세요.");
		document.inno.name.focus();
		return;
	}

	if (document.inno.email.value == "") {
		alert("전자우편을 입력해 주세요.\n비밀번호 분실시 필요합니다.");
		document.inno.email.focus();
		return;
	}
	
	if (document.inno.email.value.length > 1)  {
	str = document.inno.email.value;
	if(	(str.indexOf("@")==-1) || (str.indexOf(".")==-1)){
		alert("E-mail 주소형식이 맞지않습니다.\n비밀번호 분실시 필요합니다.")
		document.inno.email.focus();
		return;
	}
	}
	
	<% if request("mode")<>"setup" and f_jumin = 1 then %>
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
	
	<% end if %>
	
	var letters = 'ghijklabvwxyzABCDEFef)_+|<>?:mnQRSTU~!@#$%^VWXYZ`1234567opGHIJKLu./;'+"'"+'[]MNOP890-='+'\\'+'&*("{},cdqrst'+"\n";
	var split = letters.split("");
	var num = '';
	var c1 = '';
	var encrypted = '';
	var it1 = document.inno.pin.value;
	var b1 = '0';
	var chars1 = it1.split("");
	while(b1<it1.length){c1 = '0';
	while(c1<letters.length){if(split[c1] == chars1[b1]){if(c1 == "0") { c1 = ""; }if(eval(c1+10) >= letters.length){num = eval(10-(letters.length-c1));
	encrypted += split[num];}else{num = eval(c1+10);encrypted += split[num];}}c1++;}b1++;}document.inno.pin.value = encrypted;encrypted = '';
	<% if f_jumin = 1 then %>
	var encrypted = '';
	var it = document.inno.jumin2.value;
	var c = '';
	var b = '0';
	var chars = it.split("");while(b<it.length){c = '0';while(c<letters.length){if(split[c] == chars[b]){if(c == "0") { c = ""; }if(eval(c+10) >= letters.length){num = eval(10-(letters.length-c));encrypted += split[num];}else{num = eval(c+10);encrypted += split[num];}}c++;}b++;}document.inno.jumin2.value = encrypted;encrypted = '';	
	<% end if %>
	document.inno.submit();



}

function id_check()
{ 
	if (document.inno.id.value.length < 4) {
		alert("아이디는 4자 이상이어야 합니다");
		document.inno.id.focus();
		return;
	}else{
	
	var id_value = document.inno.id.value;
	var winurl="id_check.asp?id="+id_value;
   
	var openwindow="toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=350,height=150";
	window.open(winurl,'id_check',openwindow);
	}
}


function post_check()
{ 
	var newwindow="toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=350,height=150";
	window.open('zipcode.asp','post',newwindow);
}

function numcheck()
{
	if ((event.keyCode<48) || (event.keyCode>57))
	event.returnValue=false;
}

//-->
</script>
</head>
<body bgcolor="#FFFFFF" marginwidth="0" marginheight="0" leftmargin="0" topmargin="0" onload="document.inno.<% if request("mode")="setup" then %>pin<%else%>id<% end if %>.focus();">

<img src="../img/join_title.gif" border="0">
<div align="center">

<table width="484" border="0" cellpadding="0" cellspacing="0">
<form method="post" name="inno" action="join_ok.asp">
<input type="hidden" name="authority" value="<%=f_level%>">
<tr>
	<td colspan="4" height="12">
	<table width=100% border=1 cellspacing=0 cellpadding=0 bgcolor=#EEEEEE bordercolorlight=gray bordercolordark=#FFFFFF ID="Table5">
	<tr>
		<td style=font-family:Arial;font-size:1pt;color:gray nowrap>&nbsp;</td>
	</tr>
	</table>
	</td>
</tr>
<% if f_agreement = 1 then %>
<tr>
	<td colspan="4" align="center" class="form_title"><b>약 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 관</b></td>
</tr>
<tr>
	<td colspan="4" style="word-break:break-all;padding:5px;"><textarea name="f_agreement_text" cols="90" rows="7" class="form_textarea" readonly><%=f_agreement_text%></textarea></td>
</tr>
<tr>
	<td colspan="4" style="word-break:break-all;padding:5px;" align="right"> <input type="checkbox" name="agree"> <b>위의 약관에 동의합니다. &nbsp; &nbsp; &nbsp; </b></td>
</tr>
<tr>
	<td colspan="4" height="12"><img src="../img/join_line.gif" border="0"></td>
</tr>
<% end if %>
<tr>
	<td width="100" align="right" class="form_title"><b>아이디 &nbsp;</b></td>
	<td colspan="3"><input type="text" name="id" size="10" class="form_input" maxlength="20"<% if request("mode")="setup" then %>value="admin" readonly<% end if %>><% if request("mode")<>"setup" then %> &nbsp; <input type="button" class="but" value="중복확인" onclick="javascript:id_check()" id=button1 name=button1><% end if %></td>
</tr>
<tr>
	<td colspan="4" height="12"><img src="../img/join_line.gif" border="0"></td>
</tr>
<tr>
	<td width="100" align="right" class="form_title"><b>비밀번호 &nbsp;</b></td>
	<td width="142"><input type="password" name="pin" size="8" class="form_input" maxlength="15"></td>
	<td width="100" align="right" class="form_title"><b>비밀번호확인 &nbsp;</b></td>
	<td width="142"><input type="password" name="pin1" size="8" class="form_input" maxlength="15"></td>
</tr>
<tr>
	<td colspan="4" height="12"><img src="../img/join_line.gif" border="0"></td>
</tr>
<tr>
	<td width="100" align="right" class="form_title"><b>이 름 &nbsp;</b></td>
	<td colspan="3"><input type="text" name="name" size="20" class="form_input" maxlength="50"></td>
</tr>
<tr>
	<td colspan="4" height="12"><img src="../img/join_line.gif" border="0"></td>
</tr>
<tr>
	<td width="100" align="right" class="form_title"><b>전자우편 &nbsp;</b></td>
	<td colspan="3"><input type="text" name="email" size="30" class="form_input" maxlength="50"> <input type="checkbox" name="o_email" value="1" checked> 공개 &nbsp; <span style=" font-family: verdana,돋움, Arial;font-size:7.9pt;color:red;">(비번분실시 메일로 발송)</span></td>
</tr>
<tr>
	<td colspan="4" height="12"><img src="../img/join_line.gif" border="0"></td>
</tr>
<tr>
	<td width="100" align="right" class="form_title">홈페이지 &nbsp;</td>
	<td colspan="3"><input type="text" name="url" size="30" class="form_input" value="http://" maxlength="240"> <input type="checkbox" name="o_url" value="1" checked> 공개</td>
</tr>
<tr>
	<td colspan="4" height="12"><img src="../img/join_line.gif" border="0"></td>
</tr>
<% if f_nickname=1 then %>
<tr>
	<td width="100" align="right" class="form_title">닉네임 &nbsp;</td>
	<td colspan="3"><input type="text" name="nickname" size="30" maxlength="30" class="form_input"> <input type="checkbox" name="o_nickname" value="1" checked> 공개</td>
</tr>
<tr>
	<td colspan="4" height="12"><img src="../img/join_line.gif" border="0"></td>
</tr>
<% end if %>
<% if f_msg=1 then %>
<tr>
	<td width="100" align="right" class="form_title">메신져 &nbsp;</td>
	<td colspan="3">
		<select name="msg_tool" size="1">
		<option value="" selected>선택하세요</option>
		<option value="MSN">MSN</option>
		<option value="ICQ">ICQ</option>
		<option value="버디버디">버디버디</option>
		<option value="AOL">AOL</option>
		<option value="Daum">Daum</option>
		<option value="지니">지니</option>
		</select> <b>ID :</b> <input type="text" name="msg_id" size="25" maxlength="50" class="form_input"> <input type="checkbox" name="o_msg" value="1" checked> 공개</td>
</tr>
<tr>
	<td colspan="4" height="12"><img src="../img/join_line.gif" border="0"></td>
</tr>
<% end if %>
<% if request("mode")<>"setup" and f_jumin=1 then %>
<tr>
	<td width="100" align="right" class="form_title"><b>주민등록번호 &nbsp;</b></td>
	<td colspan="3"><input type="text" name="jumin1" size="6" maxlength="6" class="form_input" onkeyPress="numcheck()"> - <input type="password" name="jumin2" size="7" maxlength="7" class="form_input" onkeyPress="numcheck()"></td>
</tr>
<tr>
	<td colspan="4" height="12"><img src="../img/join_line.gif" border="0"></td>
</tr>
<% end if %>
<% if f_birthday=1 then %>
<tr>
	<td width="100" align="right" class="form_title">생년월일 &nbsp;</td>
	<td colspan="3"><input type="text" name="b_year" size="4" maxlength="4" class="form_input" onkeyPress="numcheck()"> 년 &nbsp;
	<select name="b_month">
	<%
		dim mm
		
		for i=1 to 12
		if len(i) = 1 then
			mm = "0" & i
		else
			mm = i
		end if
	%>
	<option value="<%=mm%>"><%=mm%></option>
	<%next%>
	</select>
	월 &nbsp;
	<select name="b_day">
	<%	
		dim dd
		
		for i=1 to 31
		if len(i) = 1 then
			dd = "0" & i
		else
			dd = i
		end if
	%>
	<option value="<%=dd%>"><%=dd%></option>
	<%next%>
	</select>
	일 &nbsp;<input type="radio" name="b_br" checked value="1" >양력 <input type="radio" name="b_br" value="2">음력 &nbsp; <input type="checkbox" name="o_birthday" value="1" checked> 공개</td>
</tr>
<tr>
	<td colspan="4" height="12"><img src="../img/join_line.gif" border="0"></td>
</tr>
<% end if %>
<% if f_address=1 then %>
<tr>
	<td width="100" align="right" class="form_title">주 소 &nbsp;</td>
	<td colspan="3"><input type="text" name="post1" size="1" maxlength="3" class="form_input" readOnly> - <input type="text" name="post2" size="1" maxlength="3" class="form_input" readOnly> <input type="button" class="but" value="우편번호검색" onclick="javascript:post_check()"><br>
	<input type="text" name="add1" size="50" maxlength="60" class="form_input"><br>
	<input type="text" name="add2" size="40" maxlength="40" class="form_input"> <input type="checkbox" name="o_address" value="1" checked> 공개</td>
</tr>
<tr>
	<td colspan="4" height="12"><img src="../img/join_line.gif" border="0"></td>
</tr>
<% end if %>
<% if f_tel=1 then %>
<tr>
	<td width="100" align="right" class="form_title">전화번호 &nbsp;</td>
	<td colspan="3"><input type="text" name="tel1" size="1" maxlength="3" class="form_input" onkeyPress="numcheck()"> - <input type="text" name="tel2" size="1" maxlength="4" class="form_input" onkeyPress="numcheck()"> - <input type="text" name="tel3" size="1" maxlength="4" class="form_input" onkeyPress="numcheck()"> <input type="checkbox" name="o_tel" value="1" checked> 공개</td>
</tr>
<tr>
	<td colspan="4" height="12"><img src="../img/join_line.gif" border="0"></td>
</tr>
<% end if %>
<% if f_phone=1 then %>
<tr>
	<td width="100" align="right" class="form_title">핸드폰 &nbsp;</td>
	<td colspan="3"><input type="text" name="phone1" size="1" maxlength="3" class="form_input" onkeyPress="numcheck()"> - <input type="text" name="phone2" size="1" maxlength="4" class="form_input" onkeyPress="numcheck()"> - <input type="text" name="phone3" size="1" maxlength="4" class="form_input" onkeyPress="numcheck()"> <input type="checkbox" name="o_phone" value="1" checked> 공개</td>
</tr>
<tr>
	<td colspan="4" height="12"><img src="../img/join_line.gif" border="0"></td>
</tr>
<% end if %>
<% if f_hobby=1 then %>
<tr>
	<td width="100" align="right" class="form_title">취 미 &nbsp;</td>
	<td colspan="3"><input type="text" name="hobby" size="30" class="form_input"> <input type="checkbox" name="o_hobby" value="1" checked> 공개</td>
</tr>
<tr>
	<td colspan="4" height="12"><img src="../img/join_line.gif" border="0"></td>
</tr>
<% end if %>
<% if f_job=1 then %>
<tr>
	<td width="100" align="right" class="form_title">직 업 &nbsp;</td>
	<td colspan="3">
	<select name="job" size="1" class="form_input">
		<option value="">선택하여 주십시오. </option>
		<option value="대학생(원)">대학생(원)</option>
		<option value="고등학생">고등학생</option>
		<option value="중학생">중학생</option>
		<option value="초등학생">초등학생</option>
		<option value="사무직">사무직</option>
		<option value="연구/기술직">연구/기술직</option>
		<option value="경영/관리직">경영/관리직</option>
		<option value="전문직">전문직</option>
		<option value="자영업">자영업</option>
		<option value="공무원">공무원</option>
		<option value="예술인">예술인</option>
		<option value="언론인">언론인</option>
		<option value="방송인">방송인</option>
		<option value="농/축/수산업">농/축/수농업 </option>
		<option value="서비스업">서비스업 </option>
		<option value="군인">군인</option>
		<option value="무직">무직</option>
		<option value="기타">기타</option>
	</select> <input type="checkbox" name="o_job" value="1" checked> 공개</td>
</tr>
<tr>
	<td colspan="4" height="12"><img src="../img/join_line.gif" border="0"></td>
</tr>
<% end if %>
<% if f_introduce=1 then %>
<tr>
	<td width="100" align="right" class="form_title">자기소개 &nbsp;</td>
	<td colspan="3"><textarea name="introduce" cols="70" rows="5" class="form_textarea"></textarea><br>
	 <input type="checkbox" name="o_introduce" value="1" checked> 공개</td>
</tr>
<tr>
	<td colspan="4" height="12"><img src="../img/join_line.gif" border="0"></td>
</tr>
<% end if %>
<% if f_mailling=1 then %>
<tr>
	<td width="100" align="right" class="form_title"><b>메일링리스트 &nbsp;</b></td>
	<td colspan="3"><input type="checkbox" name="mailling" value="1" checked></td>
</tr>
<tr>
	<td colspan="4" height="12"><img src="../img/join_line.gif" border="0"></td>
</tr>
<% end if %>
<tr>
	<td width="100" align="right" class="form_title"><b>정보공개 &nbsp;</b></td>
	<td colspan="3"><input type="checkbox" name="info_open" value="1" checked></td>
</tr>
<tr>
	<td colspan="4" height="12">
	<table width=100% border=1 cellspacing=0 cellpadding=0 bgcolor=#EEEEEE bordercolorlight=gray bordercolordark=#FFFFFF ID="Table5">
	<tr>
		<td style=font-family:Arial;font-size:1pt;color:gray nowrap>&nbsp;</td>
	</tr>
	</table>
	</td>
</tr>
<tr>
	<td colspan="4" align="right"><a href="javascript:submit();"><img src="../img/but_join_submit.gif" border="0"></a> &nbsp; <a href="javascript:close();"><img src="../img/but_join_cancel.gif" border="0"></a> &nbsp;<br><!-- #include file="../inc/copyright.asp" --></td>
</tr>

<%
	h_url = Request.QueryString("h_url")
	dim h_url1
	h_url = instr(q_info,"h_url=")
	h_url1 = len(q_info)
	h_url = h_url+5
	h_url = h_url1-h_url
	h_url = right(q_info,h_url)
%>

<input type="hidden" name="tb" value="<%=Request.QueryString("tb")%>">
<input type="hidden" name="page" value="<%=Request.QueryString("page")%>">
<input type="hidden" name="num" value="<%=Request.QueryString("num")%>">
<input type="hidden" name="f_jumin" value="<%=f_jumin%>">
<input type="hidden" name="h_url" value="<%=h_url%>">
<input type="hidden" name="pagesize" value="<%=Request.QueryString("pagesize")%>">
</form>
</table>
</div>

</body>
</html>
<%
	'rs.close
	db.close
	'set rs=nothing
	set db=nothing
%>

