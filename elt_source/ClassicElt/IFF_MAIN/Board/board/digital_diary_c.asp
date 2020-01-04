<% Option Explicit %>
<% 'response.buffer = true %>
<% StartTime = Timer() %>

 



<!-- #include file="../inc/dbinfo.asp" -->
<!-- #include file="../inc/info_tb.asp" -->
<!-- #include file="../inc/joint.asp" -->

<html>
<head>
<title><%=board_title%></title>

<LINK rel="stylesheet" type="text/css" href="../inc/style.css">

<script LANGUAGE="VBScript" RUNAT="Server">
Function CheckWord(CheckValue)
CheckValue = replace(CheckValue, "&lt;", "<")
CheckValue = replace(CheckValue, "&gt;", ">")
CheckValue = replace(CheckValue, "&quot;","'")
CheckValue = replace(CheckValue, "&amp;", "&" )

CheckWord = CheckValue
End Function 

</script>

<Script Language="javascript">
<!--

browserName = navigator.appName;
browserVer = parseInt(navigator.appVersion);
if(browserName == "Netscape" && browserVer >= 3){ init = "net"; }
else { init = "ie"; }


if(((init == "net")&&(browserVer >=3))||((init == "ie")&&(browserVer >= 4))){

 sn_on=new Image;
 sn_off=new Image;
 sn_on.src=  "../img/sn_on.gif";
 sn_off.src= "../img/sn_off.gif";

 st_on=new Image;
 st_off=new Image;
 st_on.src=  "../img/st_on.gif";
 st_off.src= "../img/st_off.gif";

 sc_on=new Image;
 sc_off=new Image;
 sc_on.src=  "../img/sc_on.gif";
 sc_off.src= "../img/sc_off.gif"; 
 
}

function OnOff(name) {
if(((init == "net")&&(browserVer >=3))||((init == "ie")&&(browserVer >= 4))) {
  if(document.inno[name].value=='on')
  {
   document.inno[name].value='off';
   ImgSrc=eval(name+"_off.src");
   document[name].src=ImgSrc;
  }
  else
  {
   document.inno[name].value='on';
   ImgSrc=eval(name+"_on.src");
   document[name].src=ImgSrc;
  }
 }
}


function box(inno)
{ 

	   if (inno.style.display != "none") 
           inno.style.display = "none"
           else 
           inno.style.display = ""  
}



	var select_obj;
	function inno_layer(name,status) { 
		var obj=document.all[name];
		var _tmpx,_tmpy, marginx, marginy;
		_tmpx = event.clientX + parseInt(obj.offsetWidth);
		_tmpy = event.clientY + parseInt(obj.offsetHeight);
		_marginx = document.body.clientWidth - _tmpx;
		_marginy = document.body.clientHeight - _tmpy ;
		if(_marginx < 0)
			_tmpx = event.clientX + document.body.scrollLeft + _marginx ;
		else
			_tmpx = event.clientX + document.body.scrollLeft ;
		if(_marginy < 0)
			_tmpy = event.clientY + document.body.scrollTop + _marginy +20;
		else
			_tmpy = event.clientY + document.body.scrollTop ;
		obj.style.posLeft=_tmpx-13;
		obj.style.posTop=_tmpy-12;
		if(status=='visible') {
			if(select_obj) {
				select_obj.style.visibility='hidden';
				select_obj=null;
			}
			select_obj=obj;
		}else{
			select_obj=null;
		}
		obj.style.visibility=status; 
	}

	function show_layer(num, name, email, url, tb, mem_auth, mem_id, admin) {
		var printHeight = 0;
		var printMain="";
	
		if(email) {
			printMain = "<tr onMouseOver=this.style.backgroundColor='#bbbbbb' onMouseOut=this.style.backgroundColor='' onMousedown=location.href='email.asp?email1="+email+"&h_url=<%=h_url%>';><td style=font-family:verdana;font-size:9pt height=18 nowrap>&nbsp;<img src=../img/n_mail.gif border=0 align=absmiddle>&nbsp;&nbsp;Send eMail&nbsp;&nbsp;</td></tr>";
			printHeight = printHeight + 16;
		}
		if(url) {
			printMain = printMain +	"<tr onMouseOver=this.style.backgroundColor='#bbbbbb' onMouseOut=this.style.backgroundColor='' onMousedown=window.open('http://"+url+"');><td style=font-family:verdana;font-size:9pt height=18 nowrap>&nbsp;<img src=../img/n_homepage.gif border=0 align=absmiddle>&nbsp;&nbsp;홈페이지&nbsp;&nbsp;</td></tr>";
			printHeight = printHeight + 16;
		}
		{
			printMain = printMain +	"<tr onMouseOver=this.style.backgroundColor='#bbbbbb' onMouseOut=this.style.backgroundColor='' onMousedown=location.href='list.asp?tb="+tb+"&sn=on&st=off&sc=off&sw="+name+"';><td style=font-family:verdana;font-size:9pt height=18 nowrap>&nbsp;<img src=../img/n_search.gif border=0 align=absmiddle>&nbsp;&nbsp;Search by Name&nbsp;&nbsp;</td></tr>";
			printHeight = printHeight + 16;
		}
		if(mem_auth > 0) {
			printMain = printMain +	"<tr onMouseOver=this.style.backgroundColor='#bbbbbb' onMouseOut=this.style.backgroundColor='' onMousedown=OpenWindow('../member/user_view.asp?id="+mem_id+"','500','520');><td style=font-family:verdana;font-size:9pt height=18 nowrap>&nbsp;<img src=../img/n_information.gif border=0 align=absmiddle>&nbsp;&nbsp;View User Info.&nbsp;&nbsp;</td></tr>";
			printHeight = printHeight + 16;
			printMain = printMain +	"<tr onMouseOver=this.style.backgroundColor='#bbbbbb' onMouseOut=this.style.backgroundColor='' onMousedown=OpenWindow('../message/m_write.asp?r_id="+mem_id+"&r_name="+name+"','400','400');><td style=font-family:verdana;font-size:9pt height=18 nowrap>&nbsp;<img src=../img/n_msg.gif border=0 align=absmiddle>&nbsp;&nbsp;Send Memo&nbsp;&nbsp;</td></tr>";
			printHeight = printHeight + 16;
			if(admin) {
			printMain = printMain +	"<tr onMouseOver=this.style.backgroundColor='#bbbbbb' onMouseOut=this.style.backgroundColor='' onMousedown=OpenWindow('../member/user_edit.asp?id="+mem_id+"','500','520');><td style=font-family:verdana;font-size:9pt height=18 nowrap>&nbsp;<img src=../img/n_modify.gif border=0 align=absmiddle>&nbsp;&nbsp;<font color=red>User Info. Update&nbsp;&nbsp;</td></tr>";
			printHeight = printHeight + 16;
			}
		}
			
		var printHeader = "<div id='"+num+"' style='position:absolute; left:10px; top:25px; width:127; height: "+printHeight+"; z-index:1; visibility: hidden' onMousedown=inno_layer('"+num+"','hidden')><table border=0><tr><td colspan=3 onMouseover=inno_layer('"+num+"','hidden') height=3></td></tr><tr><td width=5 onMouseover=inno_layer('"+num+"','hidden') rowspan=2>&nbsp;</td><td height=5></td></tr><tr><td><table style=cursor:hand border='0' cellspacing='1' cellpadding='0' bgcolor='black' width=100% height=100%><tr><td valign=top bgcolor=white><table border=0 cellspacing=0 cellpadding=3 width=100% height=100%>";
		var printFooter = "</table></td></tr></table></td><td width=5 rowspan=2 onMouseover=inno_layer('"+num+"','hidden')>&nbsp;</td></tr><tr><td colspan=3 height=10 onMouseover=inno_layer('"+num+"','hidden')></td></tr></table></div>";
	
		document.writeln(printHeader+printMain+printFooter);
	}



//-->
</Script>

</head>
<body bgcolor="<%=bgcolor%>" marginwidth="0" marginheight="0" leftmargin="0" topmargin="0">
<% if top_file<>"" then %><% server.execute(top_file)%><br><% end if %><%=top_board%>
<%
	num = Request.QueryString("num")
	page = Request.QueryString("page")
	
	st = Request.QueryString("st")
	sc = Request.QueryString("sc")
	sn = Request.QueryString("sn")
	sw = Request.QueryString("sw")
	
	SQL = "SELECT num,id,name,email,url,link_1,link_2,title,content,writeday,ip,mem_auth,filename1,filesize1,filename2,filesize2,filename3,filesize3,filename4,filesize4,down1,down2,down3,down4,visit,reco,notice,tag,re,reid,secret,i_width1,i_height1,i_width2,i_height2,i_width3,i_height3,i_width4,i_height4 from "&tb&" where num="&num
	Set rs = db.execute(SQL)
	
	Dim num,id,name,email,url,link_1,link_2,title,writeday,ip,visit,reco,notice,tag,re,reid,img_check,id_num,secret,mem_auth,filename1,filesize1,filename2,filesize2,filename3,filesize3,filename4,filesize4,down1,down2,down3,down4,i_width1,i_height1,i_width2,i_height2,i_width3,i_height3,i_width4,i_height4

	if session_admin="admin" or (session_login_name <> "" and session_uid=id) then
		secret=0
	else
		secret = rs("secret")
	end if
	
	if secret > 0 and session("read") = ""  then Response.Redirect "pin.asp?tb="&tb&"&page="&page&"&num="&num&"&mode=secret"
	
    num = rs("num")
    id = rs("id")
    name = rs("name")
    email = rs("email")
    url = rs("url")
    link_1 = rs("link_1")
    link_2 = rs("link_2")
    title = rs("title")
    content = rs("content")
    writeday = rs("writeday")
    ip = rs("ip")
    filename1 = rs("filename1")
    filesize1 = rs("filesize1")
    filename2 = rs("filename2")
    filesize2 = rs("filesize2")
    filename3 = rs("filename3")
    filesize3 = rs("filesize3")
    filename4 = rs("filename4")
    filesize4 = rs("filesize4")
    down1 = rs("down1")
    down2 = rs("down2")
    down3 = rs("down3")
    down4 = rs("down4")
    visit = rs("visit")
    reco = rs("reco")
    notice = rs("notice")
    tag = rs("tag")
    re = rs("re")
    reid = rs("reid")
    i_width1 = rs("i_width1")
    i_height1 = rs("i_height1")
    
    if i_width1 > 0 and i_height1 > 0 then
		if i_width1 > cint(board_size) then
			i_width1 =  board_size*90/100
			i_height1 = rs("i_height1") / (rs("i_width1") / i_width1)
		end if
    end if 
            
    i_width2 = rs("i_width2")
    i_height2 = rs("i_height2")
    
    if i_width2 > 0 and i_height2 > 0 then
		if i_width2 > cint(board_size) then
			i_width2 =  board_size*90/100
			i_height2 = rs("i_height2") / (rs("i_width2") / i_width2)
		end if
    end if
    
    i_width3 = rs("i_width3")
    i_height3 = rs("i_height3")
    
    if i_width3 > 0 and i_height3 > 0 then
		if i_width3 > cint(board_size) then
			i_width3 =  board_size*90/100
			i_height3 = rs("i_height3") / (rs("i_width3") / i_width3)
		end if
    end if
    
    
    i_width4 = rs("i_width4")
    i_height4 = rs("i_height4")
    
    if i_width4 > 0 and i_height4 > 0 then
		if i_width4 > cint(board_size) then
			i_width4 =  board_size*90/100
			i_height4 = rs("i_height4") / (rs("i_width4") / i_width4)
		end if
    end if 
    
    mem_auth = rs("mem_auth")
    
       
    if Len(filesize1) > 0 Then
		if Clng(filesize1) > 1024000 then
			filesize1 = Round((Clng(filesize1)/1024000)*1000)/1000&" Mb"
		elseif Clng(filesize1) > 1024 then
			filesize1 = Round((Clng(filesize1)/1024)*10)/10&" Kb"
		else 
			filesize1 = filesize1 &" Byte"
		end if
	end if
        
    if Len(filesize2) > 0 Then
		if Clng(filesize2) > 1024000 then
			filesize2 = Round((Clng(filesize2)/1024000)*1000)/1000&" Mb"
		elseif Clng(filesize2) > 1024 then
			filesize2 = Round((Clng(filesize2)/1024)*10)/10&" Kb"
		else 
			filesize2 = filesize2 &" Byte"
		end if
	end if
	
	if Len(filesize3) > 0 Then
		if Clng(filesize3) > 1024000 then
			filesize3 = Round((Clng(filesize3)/1024000)*1000)/1000&" Mb"
		elseif Clng(filesize3) > 1024 then
			filesize3 = Round((Clng(filesize3)/1024)*10)/10&" Kb"
		else 
			filesize3 = filesize3 &" Byte"
		end if
	end if
	
	if Len(filesize4) > 0 Then
		if Clng(filesize4) > 1024000 then
			filesize4 = Round((Clng(filesize4)/1024000)*1000)/1000&" Mb"
		elseif Clng(filesize4) > 1024 then
			filesize4 = Round((Clng(filesize4)/1024)*10)/10&" Kb"
		else 
			filesize4 = filesize4 &" Byte"
		end if
	end if	
	
	
	dim yy,mm,dd,h,mi
	
	yy = year(writeday)
    mm = right("0" & month(writeday),2)
    dd = right("0" & day(writeday),2)
    h = right("0" & hour(writeday),2)
    mi = right("0" & minute(writeday),2)
    writeday = yy & "년 " & mm & "월 " & dd & "일 (" & h & ":" & mi & ")"

	dim title1
	
	title1 = title
	
	if title1 <> "diary_cl" and title1 <> "diary_ra" and title1 <> "diary_sc" and title1 <> "diary_sn" and title1 <> "diary_su" then
		title1 = "diary_su"
	end if
	
	title = content
	call len_process
	content = title
	call search_fontcolor
	
	
	
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
<script>show_layer('info_layer_<%=num%>', '<%=rs("name")%>', '<%=email%>', '<%=url%>', '<%=tb%>', '<%=mem_auth%>', '<%=id%>', '<% if session_admin="admin" then %>1<% end if %>');</script>
<table cellpadding="0" cellspacing="0" border="0" width="<%=board_size%>">
  <tr>
	<td class="font" align="right"><% call member_form %> &nbsp; </td>
  </tr>
</table>
<table width="<%=board_size%>" bgcolor="<%=tb_bgcolor%>" border="0" cellpadding="0" cellspacing="0" ID="Table7">
<tr>
	<td width="36"><img src="../img/diary_c_img1.gif"></td>
	<td background="../img/diary_c_img2.gif"><img src="../img/diary_c_img2.gif"></td>
	<td width="20"><img src="../img/diary_c_img3.gif"></td>
</tr>
<tr>
	<td width="36" background="../img/diary_c_img4.gif"><img src="../img/diary_c_img4.gif"></td>
	<td bgcolor="#ffffff"><br><br>
	<% if board_type > 0 and view_img = 1 then %><% if i_width1 > 0 and i_height1 > 0 then %><a href="javascript:OpenWindow('../board/open_img.asp?img_file=../files/<%=tb%>/<%=filename1%>','<%=rs("i_width1")+16%>','<%=rs("i_height1")+4%>')"><img src="../files/<%=tb%>/<%=filename1%>" width="<%=i_width1%>" height="<%=i_height1%>" border="0"></a><br><br><% end if %><% if i_width2 > 0 and i_height2 > 0 then %><a href="javascript:OpenWindow('../board/open_img.asp?img_file=../files/<%=tb%>/<%=filename2%>','<%=rs("i_width2")+16%>','<%=rs("i_height2")+4%>')"><img src="../files/<%=tb%>/<%=filename2%>" width="<%=i_width2%>" height="<%=i_height2%>" border="0"></a><br><br><% end if %><% if i_width3 > 0 and i_height3 > 0 then %><a href="javascript:OpenWindow('../board/open_img.asp?img_file=../files/<%=tb%>/<%=filename3%>','<%=rs("i_width3")+16%>','<%=rs("i_height3")+4%>')"><img src="../files/<%=tb%>/<%=filename3%>" width="<%=i_width3%>" height="<%=i_height3%>" border="0"></a><br><br><% end if %><% if i_width4 > 0 and i_height4 > 0 then %><a href="javascript:OpenWindow('../board/open_img.asp?img_file=../files/<%=tb%>/<%=filename4%>','<%=rs("i_width4")+16%>','<%=rs("i_height4")+4%>')"><img src="../files/<%=tb%>/<%=filename4%>" width="<%=i_width4%>" height="<%=i_height4%>" border="0"></a><br><% end if %><br><% end if %>
	<% dim filetext
	
		'## 동영상 파일 확장자를 적어주세요. 아래의 목록에 있는 파일만 미리보기가 가능합니다.
		filetext="mp3,asf,wmv,mpg,avi,wav"
	 %>
	 <% if board_type > 0 and view_multi = 1 then %><% if filename1 <> "" and Instr(filetext,Lcase(right(filename1,3))) > 0 then %>+ 재생버튼을 누르시면 감상을 하실 수 있습니다.<br><b>첨부파일 #1</b> : <%=filename1%><br><embed src="../files/<%=tb%>/<%=filename1%>" autostart="false"><br><% end if %><% if filename2 <> "" and Instr(filetext,Lcase(right(filename2,3))) > 0 then %><br><b>첨부파일 #2</b> : <%=filename2%><br><embed src="../files/<%=tb%>/<%=filename2%>" autostart="false"><br><% end if %><% if filename3 <> "" and Instr(filetext,Lcase(right(filename3,3))) > 0 then %><br><b>첨부파일 #3</b> : <%=filename3%><br><embed src="../files/<%=tb%>/<%=filename3%>" autostart="false"><br><% end if %><% if filename4 <> "" and Instr(filetext,Lcase(right(filename4,3))) > 0 then %><br><b>첨부파일 #4</b> : <%=filename4%><br><embed src="../files/<%=tb%>/<%=filename4%>" autostart="false"><br><% end if %><% end if %>
	<div align="right" style="font-family:verdana,verdana;font-size:7.9pt;text-align:right;color:#666666;"><img src="../img/<%=title1%>.gif"> <%=writeday%><% if use_reco = 1 then %>, &nbsp; <b>추천수 : </b><%=reco%><% end if %><% if view_ip = 1 then %>, &nbsp; <b>IP : </b><%=ip%><% end if %></div><br><%=content%><br><br>
	
	
	</td>
	<td width="20" background="../img/diary_c_img5.gif"><img src="../img/diary_c_img5.gif"></td>
</tr>
<tr>
	<td width="36"><img src="../img/diary_c_img6.gif"></td>
	<td background="../img/diary_c_img7.gif"><img src="../img/diary_c_img7.gif"></td>
	<td width="20"><img src="../img/diary_c_img8.gif"></td>
</tr>
</table>

<table width="<%=board_size%>" border="0" cellpadding="0" cellspacing="0">


<%
	if use_comment = 1 then
	
	dim com_sql,com_rs,com_id,com_num,com_name,com_writeday,com_memo,com_pin,com_ip,com_mem_auth,com_mem_id
	
	com_SQL = "SELECT com_id,com_mem_id,com_name,com_writeday,com_memo,com_pin,com_ip,com_mem_auth FROM inno_comment where tb='"&tb&"' and com_num="&request("num")&" order by com_id asc"
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
    com_writeday = mm & "/ " & dd & "(" & h & ":" & mi & ")/ " & yy 
    
    id = com_mem_id
    name = com_name
    call nickname_joint
    
    call img_name_joint
    com_name = name
	
%>
<tr>
	<td colspan="2" class="font1" style="word-break:break-all;padding:5px;"><b><span onMousedown="inno_layer('info_<%=com_id%>_<%=num%>','visible')" style=cursor:hand><%=com_name%></span></b> &nbsp; &nbsp; <span style="font-size:7.5pt;">(<%=com_writeday%><% if view_ip=1 then %>, &nbsp; IP:<%=com_ip%><% end if %>)</span><% if com_mem_auth = 0 or (com_mem_auth = 1 and session_login_name = com_mem_id) or session_admin = "admin" then %> &nbsp; &nbsp; <a href="<% if (com_mem_auth=1 and session_login_name = com_mem_id) or session_admin = "admin" then %>memo_ok<% else %>pin<% end if %>.asp?tb=<%=tb%>&mode=com_del&com_id=<%=com_id%><% if (com_mem_auth=1 and session_login_name = com_mem_id) or session_admin = "admin" then %>&mem=ok<% end if %>&h_url=<%=h_url%>"><img src="../img/but_del_mini.gif" border="0"></a><% end if %></td>
</tr>
<tr>
	<td colspan="2" style="word-break:break-all;padding:5px;font-family:verdana,verdana;font-size:9pt;color:#666666;" valign="top"><%=com_memo%></td>
</tr>
<tr>
	<td colspan="2" height="1" bgcolor="#cccccc"><script>show_layer('info_<%=com_id%>_<%=num%>', '<%=com_rs("com_name")%>', '', '', '<%=tb%>', '<%=com_mem_auth%>', '<%=com_mem_id%>', '<% if session_admin="admin" then %>1<% end if %>');</script></td>
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
function ok()
{
	<% if session_login_name = "" then %>
	if (document.com_inno.com_name.value =="") {
		alert("이름을 입력해 주세요.");
		document.com_inno.com_name.focus();
		return;
	}
	
	if (document.com_inno.com_pin.value =="") {
		alert("비밀번호를 입력해 주세요.");
		document.com_inno.com_pin.focus();
		return;
	}
	
	var letters = 'ghijklabvwxyzABCDEFef)_+|<>?:mnQRSTU~!@#$%^VWXYZ`1234567opGHIJKLu./;'+"'"+'[]MNOP890-='+'\\'+'&*("{},cdqrst'+"\n";
	var split = letters.split("");var num = '';var c = '';
	var encrypted = '';
	var it = document.com_inno.com_pin.value;
	var b = '0';var chars = it.split("");while(b<it.length){c = '0';while(c<letters.length){if(split[c] == chars[b]){if(c == "0") { c = ""; }if(eval(c+10) >= letters.length){num = eval(10-(letters.length-c));encrypted += split[num];}else{num = eval(c+10);encrypted += split[num];}}c++;}b++;}document.com_inno.com_pin.value = encrypted;encrypted = '';
	
	<% end if %>
		
	document.com_inno.submit();

}
//-->
</script>
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<form name="com_inno" method="post" action="memo_ok.asp">
	<tr align="center" height="30">
		<td align="center">
		<table border="0" cellpadding="10" cellspacing="1" bgcolor="#666666" width="100%">
		<tr>
			<td bgcolor="#EEEEEE">
			<% if session_login_name = "" then %>
			<table border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td class="font1"><b>이 름</b>&nbsp;</td>
				<td><input type="text" name="com_name" size="8" maxlength="20" class="form_input">&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td class="font1"><b>비밀번호</b>&nbsp;</td>
				<td><input type="password" name="com_pin"  size="10"  maxlength="15" class="form_input">&nbsp;&nbsp;</td>
			</tr>
			</table>
			<br><% else %>
			<input type="hidden" name="com_name" value="<%=session_login_name%>">
			<input type="hidden" name="com_pin" value="<%=session_pin%>">
			<input type="hidden" name="com_mem_id" value="<%=session_uid%>">
			<% end if %>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td class="font1"><b>메 모</b></td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td><textarea name="com_memo" style="width:100%;" rows="3" class="form_textarea"></textarea>&nbsp;&nbsp;</td>
				<td width="70" align="center" valign="top" style="padding-top:2;"><input type="button" name="com_inno" class="but" value=" 확 인 " style="width:60;height=48" onclick="javascript:ok();"></td>
			</tr>
			</table>
			</td>
		</tr>
		</table><br>
		</td>
	</tr>
	<input type="hidden" name="tb" value="<%=tb%>">
	<input type="hidden" name="num" value="<%=num%>">
	<input type="hidden" name="h_url" value="<%=h_url%>" ID="Hidden7">
	</form>
	</table>
	</td>
</tr>

<% end if %>
<% end if %>

</table>
<table width="<%=board_size%>" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td align="left" style="word-break:break-all;padding:5px;"><% if use_reco = 1 then %><a href="view.asp?tb=<%=tb%>&page=<%=page%>&num=<%=num%>&mode=reco<% if sw<>"" then %>&st=<%=Request.QueryString("st")%>&sc=<%=Request.QueryString("sc")%>&sn=<%=Request.QueryString("sn")%>&sw=<%=Request.QueryString("sw")%><% end if %>"><img src="../img/but_reco.gif" border="0"></a> <% end if %><%if rw_level >= session_level then%><% if (board_type < 2 and notice <> 1) or board_type < 2 then %><a href="form.asp?tb=<%=tb%>&page=<%=page%>&num=<%=num%>&mode=reply<% if sw<>"" then %>&st=<%=Request.QueryString("st")%>&sc=<%=Request.QueryString("sc")%>&sn=<%=Request.QueryString("sn")%>&sw=<%=Request.QueryString("sw")%><% end if %>"><img src="../img/but_reply.gif" border="0"></a> <% end if %><% end if %><% if w_level >= session("level") then %><a href="form.asp?tb=<%=tb%>"><img src="../img/but_write.gif" border="0"></a> <% end if %>
	<% if mem_auth = 0 or (mem_auth = 1 and session_uid = id) or session_admin = "admin" then %> <a href="<% if (mem_auth = 1 and session_uid = id) or session_admin = "admin" then %>form<% else %>pin<% end if %>.asp?tb=<%=tb%>&page=<%=page%>&num=<%=num%>&mode=edit<% if (mem_auth = 1 and session_uid = id) or session_admin = "admin" then %>&mem=ok<% end if %><% if sw<>"" then %>&st=<%=Request.QueryString("st")%>&sc=<%=Request.QueryString("sc")%>&sn=<%=Request.QueryString("sn")%>&sw=<%=Request.QueryString("sw")%><% end if %>"><img src="../img/but_edit.gif" border="0"></a> <a href="<% if (mem_auth = 1 and session_uid = id) or session_admin = "admin" then %>del_ok<% else %>pin<% end if %>.asp?tb=<%=tb%>&num=<%=num%>&mode=del<% if (mem_auth = 1 and session_uid = id) or session_admin = "admin" then %>&mem=ok<% end if %><% if sw<>"" then %>&st=<%=Request.QueryString("st")%>&sc=<%=Request.QueryString("sc")%>&sn=<%=Request.QueryString("sn")%>&sw=<%=Request.QueryString("sw")%><% end if %>"><img src="../img/but_del.gif" border="0"></a> <% end if %><% if sw<>"" then %><a href="list.asp?tb=<%=tb%>&page=<%=page%>&st=<%=st%>&sc=<%=sc%>&sn=<%=sn%>&sw=<%=sw%>"><img src="../img/but_search_list.gif" border="0"></a> <% end if %><a href="list.asp?tb=<%=tb%>&page=<%=page%>"><img src="../img/but_list.gif" border="0"></a></td>
	<td align="right" style="word-break:break-all;padding:5px;">
<%

dim p_num,p_title,p_name,n_num,n_title,n_name
call pre_next(p_num,n_num,p_title,p_name,n_title,n_name)

%>
	<% If p_num <> 0 Then %><a href="view.asp?tb=<%=tb%>&num=<%=p_num%>&page=<%=page%>&sw=<%=sw%>&sn=<%=sn%>&st=<%=st%>&sc=<%=sc%>"><img src="../img/but_pre.gif" border="0"></a><% end if %>&nbsp;<% If n_num <> 0 Then %><a href="view.asp?tb=<%=tb%>&num=<%=n_num%>&page=<%=page%>&sw=<%=sw%>&sn=<%=sn%>&st=<%=st%>&sc=<%=sc%>"><img src="../img/but_next.gif" border="0"></a><% end if %>
	
	</td>
</tr>
</table>

<table width="<%=board_size%>" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td colspan="2" align="right"><!--#include file="../inc/copyright.asp"--></td>
</tr>
</table>

<%
	call rs_db_close
%>
<% if down_file<>"" then %><% server.execute(down_file)%><br><% end if %><%=bottom_board%>

</body>
</html>
