<%
    num = rs("num")
    id = rs("id")
    name = rs("name")
    title = rs("title")
    email = rs("email")
    url = rs("url")
    content = rs("content")
    write_diff=rs("writeday")
    writeday = left(write_diff,10)
    visit = rs("visit")
    reco = rs("reco")
    resame = rs("resame")
    filename1 = rs("filename1")
    i_width1 = rs("i_width1")
    i_height1 = rs("i_height1")

	    if i_width1=0 and i_height1=0 then 
		filename1 = "../../img/noimage.jpg"
		i_height1 = 138
		i_width1 =  200
	elseif i_width1 > 200 and i_height1 > 138 then
		
		i_height1 = 138
		i_width1 =  i_width1 / (rs("i_height1")/i_height1)
		
		if i_width1 > 200 then
			i_width1 = 200
			i_height1 =  rs("i_height1") / (rs("i_width1")/200)
		end if
	end if
	
    
    tag = rs("tag")
    if session_admin = "admin" then
		secret=0
	else
		secret = rs("secret")
	end if    
    mem_auth = rs("mem_auth")
    
    if rs("filename1")<>"" or rs("filename2")<>"" or rs("filename3")<>"" or rs("filename4")<>"" then
		file=1
	else
		file=0
    end if
    
    blank=4*resame
    
'   if left(now,2)<>"20" then
'		nowday="20"&now
'	else
		nowday=now
'	end if
	
	if writeday = left(nowday,10) then
		writeday=right(write_diff,11)
		writeday=left(writeday,8)
	end if
	
	call len_process
	
	call search_fontcolor
	
	call db_comment
	

	If tag = 1 Then
		title = checkword(title)
		content = Replace(checkword(content), vbCrLf,"<br>")
	ElseIf tag = 2 Then
		title = checkword(title)
		content = checkword(content)
	Else
		content = Replace(content, vbCrLf,"<br>")
		Call autolink(content)
	End If
	
	call nickname_joint
	
	call img_name_joint
%>

<table width="<%=board_size%>" border="0" cellpadding="0" cellpadding ="0" ID="Table7">
<tr>
	<td width="210" align="center" valign="top"><% if rs("i_width1")<>0 then %><a href="javascript:OpenWindow('../board/open_img.asp?img_file=../files/<%=tb%>/<%=filename1%>','<%=rs("i_width1")+16%>','<%=rs("i_height1")+4%>')"><% end if %><img src="../files/<%=tb%>/<%=filename1%>" width="<%=i_width1%>" height="<%=i_height1%>" border="0"><% if rs("i_width1")<>0 then %></a><% end if %><% if mem_auth = 0 or (mem_auth = 1 and session_uid = id) or session_admin = "admin" then %><br><div align="right"> <a href="<% if (mem_auth = 1 and session_uid = id) or session_admin = "admin" then %>form<% else %>pin<% end if %>.asp?tb=<%=tb%>&page=<%=page%>&num=<%=num%>&mode=edit<% if (mem_auth = 1 and session_uid = id) or session_admin = "admin" then %>&mem=ok<% end if %><% if sw<>"" then %>&st=<%=Request.QueryString("st")%>&sc=<%=Request.QueryString("sc")%>&sn=<%=Request.QueryString("sn")%>&sw=<%=Request.QueryString("sw")%><% end if %>"><img src="../img/but_edit_mini.gif" border="0" alt="수정"></a>  <a href="<% if (mem_auth = 1 and session_uid = id) or session_admin = "admin" then %>del_ok<% else %>pin<% end if %>.asp?tb=<%=tb%>&num=<%=num%>&mode=del<% if (mem_auth = 1 and session_uid = id) or session_admin = "admin" then %>&mem=ok<% end if %><% if sw<>"" then %>&st=<%=Request.QueryString("st")%>&sc=<%=Request.QueryString("sc")%>&sn=<%=Request.QueryString("sn")%>&sw=<%=Request.QueryString("sw")%><% end if %>"><img src="../img/but_del_mini.gif" border="0" alt="삭제"></a>  &nbsp; &nbsp;  </div><% end if %></td>
	<td valign="top"><b>작성자 :</b> <span onMousedown="inno_layer('info_layer_<%=num%>','visible')" style=cursor:hand><%=name%></span> &nbsp; &nbsp; <b>작성일 :</b> <%=writeday%><br><b><%=title%></b><br><br><%=content%><script>show_layer('info_layer_<%=num%>', '<%=rs("name")%>', '<%=email%>', '<%=url%>', '<%=tb%>', '<%=mem_auth%>', '<%=id%>', '<% if session_admin="admin" then %>1<% end if %>');</script></td>
</tr>

<%
	if use_comment = 1 then

	com_SQL = "SELECT com_id,com_mem_id,com_name,com_writeday,com_memo,com_pin,com_ip,com_mem_auth FROM inno_comment where tb='"&tb&"' and com_num="&num&" order by com_id asc"
	Set com_rs = db.Execute(com_SQL)
	
	i=1
	Do until com_rs.EOF
	
	com_id=com_rs("com_id")	
	com_mem_id=com_rs("com_mem_id")	
	com_name=com_rs("com_name")
	com_writeday=com_rs("com_writeday")
	com_memo = Replace(com_rs("com_memo"), vbCrlf,"<br>")
	com_ip=com_rs("com_ip")
	com_mem_auth = com_rs("com_mem_auth")
	
	yy = year(com_writeday)
    mm = right("0" & month(com_writeday),2)
    dd = right("0" & day(com_writeday),2)
    h = right("0" & hour(com_writeday),2)
    mi = right("0" & minute(com_writeday),2)
    com_writeday = yy & "-" & mm & "-" & dd & "-" & h & ":" & mi
    
    id = com_mem_id
    name = com_name
    call nickname_joint
    
    call img_name_joint
    com_name = name
	
%>
<tr>
	<td colspan="2" height="1" bgcolor="#cccccc"><script>show_layer('info_<%=com_id%>_<%=num%>', '<%=com_rs("com_name")%>', '', '', '<%=tb%>', '<%=com_mem_auth%>', '<%=com_mem_id%>', '<% if session_admin="admin" then %>1<% end if %>');</script></td>
</tr>
<tr>
	<td colspan="2" class="font1" style="word-break:break-all;padding:5px;"><b><span onMousedown="inno_layer('info_<%=com_id%>_<%=num%>','visible')" style=cursor:hand><%=com_name%></span></b> &nbsp; &nbsp; <span style="font-size:7.5pt;">(<%=com_writeday%><% if view_ip=1 then %>, &nbsp; IP:<%=com_ip%><% end if %>)</span><% if com_mem_auth = 0 or (com_mem_auth = 1 and session_login_name = com_mem_id) or session_admin = "admin" then %> &nbsp; &nbsp; <a href="<% if (com_mem_auth=1 and session_login_name = com_mem_id) or session_admin = "admin" then %>memo_ok<% else %>pin<% end if %>.asp?tb=<%=tb%>&mode=com_del&com_id=<%=com_id%><% if (com_mem_auth=1 and session_login_name = com_mem_id) or session_admin = "admin" then %>&mem=ok<% end if %>&h_url=<%=h_url%>"><img src="../img/but_del_mini.gif" border="0"></a><% end if %></td>
</tr>
<tr>
	<td colspan="2" style="word-break:break-all;padding:5px;font-family:verdana,verdana;font-size:9pt;color:#666666;" valign="top"><%=com_memo%></td>
</tr>

<%
	com_rs.movenext
	i=i+1
	loop

	com_rs.Close
	set com_rs=nothing
%>
<%if cw_level >= session_level then%>
<tr>
	<td colspan="2" align="center">
	<br>
<script language="javascript">
<!--//
function ok_<%=num%>()
{
	<% if session_login_name = "" then %>
	if (document.com_inno_<%=num%>.com_name.value =="") {
		alert("이름을 입력해 주세요.");
		document.com_inno_<%=num%>.com_name.focus();
		return;
	}
	
	if (document.com_inno_<%=num%>.com_pin.value =="") {
		alert("비밀번호를 입력해 주세요.");
		document.com_inno_<%=num%>.com_pin.focus();
		return;
	}
	
	var letters = 'ghijklabvwxyzABCDEFef)_+|<>?:mnQRSTU~!@#$%^VWXYZ`1234567opGHIJKLu./;'+"'"+'[]MNOP890-='+'\\'+'&*("{},cdqrst'+"\n";
	var split = letters.split("");var num = '';var c = '';
	var encrypted = '';
	var it = document.com_inno_<%=num%>.com_pin.value;
	var b = '0';var chars = it.split("");while(b<it.length){c = '0';while(c<letters.length){if(split[c] == chars[b]){if(c == "0") { c = ""; }if(eval(c+10) >= letters.length){num = eval(10-(letters.length-c));encrypted += split[num];}else{num = eval(c+10);encrypted += split[num];}}c++;}b++;}document.com_inno_<%=num%>.com_pin.value = encrypted;encrypted = '';
	
	<% end if %>
		
	document.com_inno_<%=num%>.submit();

}
//-->
</script>
	<table border="0" cellpadding="0" cellspacing="0" width="100%" ID="Table1">
	<form name="com_inno_<%=num%>" method="post" action="memo_ok.asp" ID="form1">
	<tr align="center" height="30">
		<td align="center">
		<table border="0" cellpadding="10" cellspacing="1" bgcolor="#666666" width="100%" ID="Table2">
		<tr>
			<td bgcolor="#EEEEEE">
			<% if session_login_name = "" then %>
			<table border="0" cellpadding="0" cellspacing="0" ID="Table3">
			<tr>
				<td class="font1"><b>이 름</b>&nbsp;</td>
				<td><input type="text" name="com_name" size="8" maxlength="20" class="form_input" ID="Text1">&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td class="font1"><b>비밀번호</b>&nbsp;</td>
				<td><input type="password" name="com_pin"  size="10"  maxlength="15" class="form_input" ID="Password1">&nbsp;&nbsp;</td>
			</tr>
			</table>
			<br><% else %>
			<input type="hidden" name="com_name" value="<%=session_login_name%>" ID="Hidden1">
			<input type="hidden" name="com_pin" value="<%=session_pin%>" ID="Hidden2">
			<input type="hidden" name="com_mem_id" value="<%=session_uid%>" ID="Hidden3">
			<% end if %>
			<table border="0" cellpadding="0" cellspacing="0" width="100%" ID="Table4">
			<tr>
				<td class="font1"><b>메 모</b></td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td><textarea name="com_memo" style="width:100%;" rows="3" class="form_textarea" ID="Textarea1"></textarea>&nbsp;&nbsp;</td>
				<td width="70" align="center" valign="top" style="padding-top:2;"><input type="button" name="com_inno_<%=num%>" class="but" value=" 확 인 " style="width:60;height=48" onclick="javascript:ok_<%=num%>();" ID="Button1"></td>
			</tr>
			</table>
			</td>
		</tr>
		</table><br>
		</td>
	</tr>
	<input type="hidden" name="tb" value="<%=tb%>" ID="Hidden4">
	<input type="hidden" name="num" value="<%=num%>" ID="Hidden6">
	<input type="hidden" name="h_url" value="<%=h_url%>" ID="Hidden7">
	
	</form>
	</table>
	</td>
</tr>
<tr>
	<td colspan="2" height="1" bgcolor="#cccccc"></td>
</tr>
<% end if %>
<% end if %>
</table>
