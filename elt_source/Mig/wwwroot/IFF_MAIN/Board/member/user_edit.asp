<% @Language = "VBScript" %>
<% Option Explicit %>
<% response.buffer = true %>

 



<!-- #include file="../inc/dbinfo.asp" -->
<!-- #include file="../inc/info_tb.asp" -->
<!-- #include file="../inc/joint.asp" -->




<% call f_member %>


<%
	dim sql1,rs1
	Dim id,pin,name,email,url,nickname,msg_tool,msg_id,jumin,birthday,zipcode,address,tel,phone,hobby,job,introduce,info_open,join_day,term_day,mailling,authority,point,name_img,name_img_file,po_write,po_comment,b_admin
	dim o_email,o_url,o_nickname,o_msg,o_birthday,o_address,o_tel,o_phone,o_hobby,o_job,o_introduce
	
	SQL1 = "SELECT elt_account_number, id,pin,name,email,url,nickname,msg_tool,msg_id,birthday,zipcode,address,tel,phone,hobby,job,introduce,info_open,join_day,term_day,authority,user_level,mailling,point,name_img,po_write,po_comment,b_admin,o_email,o_url,o_nickname,o_msg,o_birthday,o_address,o_tel,o_phone,o_hobby,o_job,o_introduce FROM member where id='"&Request.QueryString("id")&"'"
    Set rs1 = db.execute (SQL1)
    
    name=rs1("name")
    if session_admin <> admin_name then
		if session_login_name <> name then
			Response.Redirect "../inc/error.asp?no=4"
		end if
	end if
	
    id=rs1("id")
    pin=rs1("pin")
    email=rs1("email")
    url=rs1("url")
    nickname=rs1("nickname")
    msg_tool=rs1("msg_tool")
    msg_id=rs1("msg_id")
    birthday= split(rs1("birthday"),"-")
    zipcode=split(rs1("zipcode"),"-")
    address=split(rs1("address"),"#")
    tel=split(rs1("tel"),"-")
    phone=split(rs1("phone"),"-")
    hobby=rs1("hobby")
    job=rs1("job")
    introduce=rs1("introduce")
    info_open=rs1("info_open")
    join_day=rs1("join_day")
    term_day=rs1("term_day")
    authority=rs1("authority")
    user_level=rs1("user_level")
    mailling=rs1("mailling")
    po_write=rs1("po_write")
    po_comment=rs1("po_comment")
    point=rs1("point")
    name_img=rs1("name_img")
    b_admin=rs1("b_admin")
    o_email=rs1("o_email")
    o_url=rs1("o_url")
    o_nickname=rs1("o_nickname")
    o_msg=rs1("o_msg")
    o_birthday=rs1("o_birthday")
    o_address=rs1("o_address")
    o_tel=rs1("o_tel")
    o_phone=rs1("o_phone")
    o_hobby=rs1("o_hobby")
    o_job=rs1("o_job")
    o_introduce=rs1("o_introduce")

	dim yy,h,mi

	yy= year(join_day)
    mm = right("0" & month(join_day),2)
    dd = right("0" & day(join_day),2)
    h = right("0" & hour(join_day),2)
    mi = right("0" & minute(join_day),2)
    join_day = yy & "�� " & mm & "�� " & dd & "�� (" & h & ":" & mi & ")"
    
    if trim(term_day) <> "" then
		yy= year(term_day)
		mm = right("0" & month(term_day),2)
		dd = right("0" & day(term_day),2)
		h = right("0" & hour(term_day),2)
		mi = right("0" & minute(term_day),2)
		term_day = yy & "�� " & mm & "�� " & dd & "�� (" & h & ":" & mi & ")"
	else
		term_day = ""
	end if
%>
<html>
<head>
<title>ȸ����������</title>

<LINK rel="stylesheet" type="text/css" href="../inc/style.css">
<script language="javascript">
<!--

function submit()
{
	if (document.inno.pin.value.length > 1) {
			
	if (document.inno.pin.value != document.inno.pin1.value) {
		alert("���ο� ��й�ȣ�� �������� �ʽ��ϴ�.");
		document.inno.pin1.focus();
		return;
	}
	
	if (document.inno.email.value.length > 1)  {
	str = document.inno.email.value;
	if(	(str.indexOf("@")==-1) || (str.indexOf(".")==-1)){
		alert("E-mail �ּ������� �����ʽ��ϴ�")
		document.inno.email.focus();
		return;
	}
	}
	}
	
	var letters = 'ghijklabvwxyzABCDEFef)_+|<>?:mnQRSTU~!@#$%^VWXYZ`1234567opGHIJKLu./;'+"'"+'[]MNOP890-='+'\\'+'&*("{},cdqrst'+"\n";
	var split = letters.split("");var num = '';var c = '';
	var encrypted = '';
	var it = document.inno.pin.value;
	var b = '0';var chars = it.split("");while(b<it.length){c = '0';while(c<letters.length){if(split[c] == chars[b]){if(c == "0") { c = ""; }if(eval(c+10) >= letters.length){num = eval(10-(letters.length-c));encrypted += split[num];}else{num = eval(c+10);encrypted += split[num];}}c++;}b++;}document.inno.pin.value = encrypted;encrypted = '';
	
	document.inno.submit();

}

function admin_submit()
{
	document.inno_admin.submit();
}

function id_check()
{ 
	if (document.inno.id.value.length < 4) {
		alert("���̵�� 4�� �̻��̾�� �մϴ�");
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

function del_id_submit()
{
	ans = confirm("ȸ��Ż�� �Ͻðڽ��ϱ�?")

    if(ans == true)
		{ document.del_id.submit();	}
	else
		{}
}

//-->
</script>


</head>
<body bgcolor="#FFFFFF" marginwidth="0" marginheight="0" leftmargin="0" topmargin="0" onload="document.inno.pin.focus();">
<img src="../img/join_edit_title.gif" border="0">
<div align="center">
<% if img_name=1 then %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
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
	<td width="100" align="right" class="form_title"><b>�̹������� &nbsp;</b></td>
	<td colspan="3"><!-- #include file="img_name.asp" --></td>
</tr>

</table>
<% end if %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td colspan="4" height="12">
	<table width=100% border=1 cellspacing=0 cellpadding=0 bgcolor=#EEEEEE bordercolorlight=gray bordercolordark=#FFFFFF ID="Table5">
	<tr>
		<td style=font-family:Arial;font-size:1pt;color:gray nowrap>&nbsp;</td>
	</tr>
	</table>
	</td>
</tr>
<form method="post" name="inno" action="user_edit_ok.asp">
<input type="hidden" name="tb" value="<%=Request.QueryString("tb")%>">
<input type="hidden" name="id" value="<%=id%>">
<input type="hidden" name="old_pin" value="<%=pin%>">
<tr>
	<td width="100" align="right" class="form_title"><b>���̵� &nbsp;</b></td>
	<td colspan="3"><b><%=id%></b></td>
</tr>
<tr>
	<td colspan="4" height="12" background="img/line_1.gif"><img src="img/line_1.gif" border="0"></td>
</tr>
<tr>
	<td width="100" align="right" class="form_title"><b>�� ��й�ȣ &nbsp;</b></td>
	<td colspan="3" class="form_title"><table width="300" border="0" cellpadding="0" cellspacing="0">
	<tr><td width="100"><input type="password" name="pin" size="8" class="form_input"></td>
	<td width="120" align="right" class="form_title"><b>�� ��й�ȣȮ�� &nbsp;</b></td>
	<td width="80"><input type="password" name="pin1" size="8" class="form_input"></td>
	</tr></table></td>
</tr>
<tr>
	<td colspan="4" height="12" background="img/line_1.gif"><img src="img/line_1.gif" border="0"></td>
</tr>
<tr>
	<td width="100" align="right" class="form_title"><b>��� ���� &nbsp;</b></td>
	<td><% if session_admin = "admin" and level_select = 0 then %>
	<select name="user_level" ID="Select2">
	<%	
		dim level,i_user_level,j
		
		j=10
		do while j > 0
		level = j & " Level"
		i_user_level = j
		
	%>
	<option value="<%=i_user_level%>"<% if i_user_level=user_level then %>selected<% end if %>><%=level%></option>
	<%
		j=j-1
		loop
	%>
	</select><% else %><%=user_level%> Level<input type="hidden" name="user_level" value="<%=user_level%>"><% end if %>
	</td>
</tr>
<tr>
	<td colspan="4" height="12" background="img/line_1.gif"><img src="img/line_1.gif" border="0"></td>
</tr>

<tr>
	<td width="100" align="right" class="form_title"><b>�� �� &nbsp;</b></td>
	<td colspan="3"><b><%=name%></b></td>
</tr>
<tr>
	<td colspan="4" height="12" background="img/line_1.gif"><img src="img/line_1.gif" border="0"></td>
</tr>
<tr>
	<td width="100" align="right" class="form_title"><b>���ڿ��� &nbsp;</b></td>
	<td colspan="3"><input type="text" name="email" size="30" class="form_input" value="<%=email%>"> <input type="checkbox" name="o_email" value="1"<% if o_email = 1 then %> checked<% end if %>> ����</td>
</tr>
<tr>
	<td colspan="4" height="12" background="img/line_1.gif"><img src="img/line_1.gif" border="0"></td>
</tr>
<tr>
	<td width="100" align="right" class="form_title"><b>Ȩ������ &nbsp;</b></td>
	<td colspan="3"><input type="text" name="url" size="30" class="form_input" value="http://<%=url%>"> <input type="checkbox" name="o_url" value="1"<% if o_url = 1 then %> checked<% end if %>> ����</td>
</tr>
<tr>
	<td colspan="4" height="12" background="img/line_1.gif"><img src="img/line_1.gif" border="0"></td>
</tr>

<% if f_nickname=1 then %>
<tr>
	<td width="100" align="right" class="form_title">�г��� &nbsp;</td>
	<td colspan="3"><input type="text" name="nickname" size="30" class="form_input" value="<%=nickname%>"> <input type="checkbox" name="o_nickname" value="1"<% if o_nickname = 1 then %> checked<% end if %> ID="Checkbox1"> ����</td>
</tr>
<tr>
	<td colspan="4" height="12" background="img/line_1.gif"><img src="img/line_1.gif" border="0"></td>
</tr>
<% end if %>

<% if f_msg=1 then %>
<tr>
	<td width="100" align="right" class="form_title">�޽��� &nbsp;</td>
	<td colspan="3"><select name="msg_tool" size="1" ID="Select1">
							<option value="">�����ϼ���</option>
							<option value="MSN" <% If msg_tool = "MSN" Then %>selected<% End If %>>MSN</option>
							<option value="ICQ" <% If msg_tool = "ICQ" Then %>selected<% End If %>>ICQ</option>
							<option value="�������" <% If msg_tool = "�������" Then %>selected<% End If %>>�������</option>
							<option value="AOL" <% If msg_tool = "AOL" Then %>selected<% End If %>>AOL</option>
							<option value="Daum"<% If msg_tool = "Daum" Then %>selected<% End If %>>Daum</option>
							<option value="����" <% If msg_tool = "����" Then %>selected<% End If %>>����</option>
						</select> <b>ID : </b><input type="text" name="msg_id" size="30" class="form_input" value="<%=msg_id%>" ID="Text1"> <input type="checkbox" name="o_msg" value="1"<% if o_msg = 1 then %> checked<% end if %> ID="Checkbox2"> ����</td>
</tr>
<tr>
	<td colspan="4" height="12" background="img/line_1.gif"><img src="img/line_1.gif" border="0"></td>
</tr>
<% end if %>


<% if f_birthday=1 then %>
<tr>
	<td width="100" align="right" class="form_title">������� &nbsp;</td>
	<td colspan="3"><input type="text" name="b_year" size="4" maxlength="4" class="form_input" onkeyPress="numcheck()" value="<%=birthday(0)%>"> �� &nbsp;
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
	<option value="<%=mm%>"<% if birthday(1) = mm then %> selected<% end if %>><%=mm%></option>
	<%next%>
	</select>
	�� &nbsp;
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
	<option value="<%=dd%>"<% if birthday(2) = dd then %> selected<% end if %>><%=dd%></option>
	<%next%>
	</select>
	�� &nbsp;<input type="radio" name="b_br" value="1"<% if birthday(3) = "1" then %> checked<% end if %>>��� <input type="radio" name="b_br" value="2"<% if birthday(3) = "2" then %> checked<% end if %>>���� <input type="checkbox" name="o_birthday" value="1"<% if o_birthday = 1 then %> checked<% end if %>> ����</td>
</tr>
<tr>
	<td colspan="4" height="12" background="img/line_1.gif"><img src="img/line_1.gif" border="0"></td>
</tr>
<% end if %>
<% if f_address=1 then %>
<tr>
	<td width="100" align="right" class="form_title">�� �� &nbsp;</td>
	<td colspan="3"><input type="text" name="post1" size="1" maxlength="3" class="form_input" readOnly value="<%=zipcode(0)%>"> - <input type="text" name="post2" size="1" maxlength="3" class="form_input" readOnly value="<%=zipcode(1)%>"> <input type="button" class="but" value="�����ȣ�˻�" onclick="javascript:post_check()"><br>
	<input type="text" name="add1" size="50" maxlength="60" class="form_input" value="<%=address(0)%>"><br>
	<input type="text" name="add2" size="40" maxlength="40" class="form_input" value="<%=address(1)%>"> <input type="checkbox" name="o_address" value="1"<% if o_address = 1 then %> checked<% end if %>> ����</td>
</tr>
<tr>
	<td colspan="4" height="12" background="img/line_1.gif"><img src="img/line_1.gif" border="0"></td>
</tr>
<% end if %>
<% if f_tel=1 then %>
<tr>
	<td width="100" align="right" class="form_title">��ȭ��ȣ &nbsp;</td>
	<td colspan="3"><input type="text" name="tel1" size="1" maxlength="3" class="form_input" onkeyPress="numcheck()" value="<%=tel(0)%>"> - <input type="text" name="tel2" size="1" maxlength="4" class="form_input" onkeyPress="numcheck()" value="<%=tel(1)%>"> - <input type="text" name="tel3" size="1" maxlength="4" class="form_input" onkeyPress="numcheck()" value="<%=tel(2)%>"> <input type="checkbox" name="o_tel" value="1"<% if o_tel = 1 then %> checked<% end if %>> ����</td>
</tr>
<tr>
	<td colspan="4" height="12" background="img/line_1.gif"><img src="img/line_1.gif" border="0"></td>
</tr>
<% end if %>
<% if f_phone=1 then %>
<tr>
	<td width="100" align="right" class="form_title">�ڵ��� &nbsp;</td>
	<td colspan="3"><input type="text" name="phone1" size="1" maxlength="3" class="form_input" onkeyPress="numcheck()" value="<%=phone(0)%>"> - <input type="text" name="phone2" size="1" maxlength="4" class="form_input" onkeyPress="numcheck()" value="<%=phone(1)%>"> - <input type="text" name="phone3" size="1" maxlength="4" class="form_input" onkeyPress="numcheck()" value="<%=phone(2)%>"> <input type="checkbox" name="o_phone" value="1"<% if o_phone = 1 then %> checked<% end if %>> ����</td>
</tr>
<tr>
	<td colspan="4" height="12" background="img/line_1.gif"><img src="img/line_1.gif" border="0"></td>
</tr>
<% end if %>
<% if f_hobby=1 then %>
<tr>
	<td width="100" align="right" class="form_title">�� �� &nbsp;</td>
	<td colspan="3"><input type="text" name="hobby" size="30" class="form_input" value="<%=hobby%>"> <input type="checkbox" name="o_hobby" value="1"<% if o_hobby = 1 then %> checked<% end if %>> ����</td>
</tr>
<tr>
	<td colspan="4" height="12" background="img/line_1.gif"><img src="img/line_1.gif" border="0"></td>
</tr>
<% end if %>
<% if f_job=1 then %>
<tr>
	<td width="100" align="right" class="form_title">�� �� &nbsp;</td>
	<td colspan="3">
	<select name="job" size="1" class="form_input">
		<option value="" <% if job ="" then%>selected<%end if%>>�����Ͽ� �ֽʽÿ�. </option>
		<option value="���л�(��)" <% if job ="���л�(��)" then%>selected<%end if%>>���л�(��)</option>
		<option value="����л�" <% if job ="����л�" then%>selected<%end if%>>����л�</option>
		<option value="���л�" <% if job ="���л�" then%>selected<%end if%>>���л�</option>
		<option value="�ʵ��л�" <% if job ="�ʵ��л�" then%>selected<%end if%>>�ʵ��л�</option>
		<option value="�繫��" <% if job ="�繫��" then%>selected<%end if%>>�繫��</option>
		<option value="����/�����" <% if job ="����/�����" then%>selected<%end if%>>����/�����</option>
		<option value="�濵/������" <% if job ="�濵/������" then%>selected<%end if%>>�濵/������</option>
		<option value="������" <% if job ="������" then%>selected<%end if%>>������</option>
		<option value="�ڿ���" <% if job ="�ڿ���" then%>selected<%end if%>>�ڿ���</option>
		<option value="������" <% if job ="������" then%>selected<%end if%>>������</option>
		<option value="������" <% if job ="������" then%>selected<%end if%>>������</option>
		<option value="�����" <% if job ="�����" then%>selected<%end if%>>�����</option>
		<option value="�����" <% if job ="�����" then%>selected<%end if%>>�����</option>
		<option value="��/��/�����" <% if job ="��/��/�����" then%>selected<%end if%>>��/��/�����</option>
		<option value="���񽺾�" <% if job ="���񽺾�" then%>selected<%end if%>>���񽺾�</option>
		<option value="����" <% if job ="����" then%>selected<%end if%>>����</option>
		<option value="����" <% if job ="����" then%>selected<%end if%>>����</option>
		<option value="��Ÿ" <% if job ="��Ÿ" then%>selected<%end if%>>��Ÿ</option>
	</select> <input type="checkbox" name="o_job" value="1"<% if o_job = 1 then %> checked<% end if %>> ����</td>
</tr>
<tr>
	<td colspan="4" height="12" background="img/line_1.gif"><img src="img/line_1.gif" border="0"></td>
</tr>
<% end if %>
<% if f_introduce=1 then %>
<tr>
	<td width="100" align="right" class="form_title">�ڱ�Ұ� &nbsp;</td>
	<td colspan="3"><textarea name="introduce" cols="70" rows="5" class="form_textarea"><%=introduce%></textarea><br>
	<input type="checkbox" name="o_introduce" value="1"<% if o_introduce = 1 then %> checked<% end if %>> ����</td>
</tr>
<tr>
	<td colspan="4" height="12" background="img/line_1.gif"><img src="img/line_1.gif" border="0"></td>
</tr>
<% end if %>
<% if f_mailling=1 then %>
<tr>
	<td width="100" align="right" class="form_title"><b>���ϸ�����Ʈ &nbsp;</b></td>
	<td colspan="3"><input type="checkbox" name="mailling" value="1" <% if mailling=1 then%>checked<%end if%>></td>
</tr>
<tr>
	<td colspan="4" height="12" background="img/line_1.gif"><img src="img/line_1.gif" border="0"></td>
</tr>
<% end if %>
<tr>
	<td width="100" align="right" class="form_title"><b>�������� &nbsp;</b></td>
	<td colspan="3"><input type="checkbox" name="info_open" value="1" <% if info_open=1 then%>checked<%end if%>></td>
</tr>
<tr>
	<td colspan="4" height="12" background="img/line_1.gif"><img src="img/line_1.gif" border="0"></td>
</tr>
<tr>
	<td width="100" align="right" class="form_title"><b>����Ʈ &nbsp;</b></td>
	<td colspan="3"> <%=point%> ( ���ۼ� : <%=po_write%> / �ڸ�Ʈ : <%=po_comment%> )</td>
</tr>
<tr>
	<td colspan="4" height="12" background="img/line_1.gif"><img src="img/line_1.gif" border="0"></td>
</tr>
<tr>
	<td width="100" align="right" class="form_title"><b>������ &nbsp;</b></td>
	<td colspan="3"> <%=join_day%></td>
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
	<td colspan="4" align="right"><a href="javascript:submit();"><img src="../img/but_join_ok.gif" border="0"></a> &nbsp; <a href="javascript:close();"><img src="../img/but_join_cancel.gif" border="0"></a><% if request.QueryString("admin")<>"ok" then %> &nbsp; <a href="javascript:del_id_submit();"><img src="../img/but_join_out.gif" border="0"></a>&nbsp;<br><!-- #include file="../inc/copyright.asp" --><% end if %></td>
</tr>
</form>
<form method="post" name="del_id" action="user_process.asp?mode=del&sel=1&style=del&tb=<%=request.QueryString("tb")%>">
<input type="hidden" name="id" value="<%=id%>">
</form>
</table>
</div>

</body>
</html>
<% if request("reload") = "write" or request("reload") = "del" then %><script language="JavaScript">alert("�̹��������� <% if request("reload")="write" then %>����<% else %>����<% end if %>�Ǿ����ϴ�.");</script><Meta http-equiv="Refresh" content="0; url=<%=h_url%>&reload=no"><% end if %>
<%
	rs1.close
	db.Close
	Set rs1=nothing
	Set db=nothing
%>

