<% response.buffer = true %>
<% Response.Expires=-1 %>
<% StartTime = Timer() %>

<% session("read")="" %>

<!-- #include file="../inc/dbinfo.asp" -->
<!-- #include file="../inc/info_tb.asp" -->
<!-- #include file="../inc/joint.asp" -->
<!-- #include file="../inc/board_check.asp" -->

<%
	Dim pagecount, recordCount,colspan
	
	session("tb") = request("tb")
  

	page = Request("page")
	if page = "" then page = 1


	call db_list
	
	if use_reco = 1 and view_reco = 1 then
		colspan = 7
	else
		colspan = 6
	end if
%>

<html>
<head>
<title><%=board_title%></title>

<LINK rel="stylesheet" type="text/css" href="../inc/style.css">
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

function admin_submit()
{
	if (document.adminform.admin_pin.value =="") {
		alert("Please enter your password.");
		document.adminform.admin_pin.focus();
		return;
	}

	document.adminform.submit();

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
			printMain = printMain +	"<tr onMouseOver=this.style.backgroundColor='#bbbbbb' onMouseOut=this.style.backgroundColor='' onMousedown=window.open('http://"+url+"');><td style=font-family:verdana;font-size:9pt height=18 nowrap>&nbsp;<img src=../img/n_homepage.gif border=0 align=absmiddle>&nbsp;&nbsp;HomePage&nbsp;&nbsp;</td></tr>";
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

var checkflag = "false"; 

function checkboxall() { 

field = eval("document.inno_check.cart");

if (checkflag == "false") { 
for (i = 0; i < field.length; i++) { 
field[i].checked = true;} 
checkflag = "true"; 
return; 
} 

else { 
for (i = 0; i < field.length; i++) { 
field[i].checked = false; } 
checkflag = "false"; 
return; 
} 

}

function read_cart()
{
	document.inno_check.action = "content1.asp?tb=<%=tb%>&page=<%=page%>&mode=read_cart"
	document.inno_check.submit();
}

function del_cart()
{
	document.inno_check.action = "del_ok.asp?tb=<%=tb%>&page=<%=page%>&mode=del_cart"
	document.inno_check.submit();
}



//-->
</Script>
<script LANGUAGE="VBScript" RUNAT="Server">
Function CheckWord(CheckValue)

CheckValue = replace(CheckValue, "&lt;", "<")
CheckValue = replace(CheckValue, "&gt;", ">")
CheckValue = replace(CheckValue, "&quot;", "'")
CheckValue = replace(CheckValue, "&amp;", "&" )
CheckWord = CheckValue
End Function
</script>
<meta name="description" content="Board">
</head>
<body bgcolor="<%=bgcolor%>" marginwidth="0" marginheight="0" leftmargin="0" topmargin="0">
<% if session("read")="" and Request.QueryString("num")="" then %>
<% if top_file<>"" then %><% server.execute(top_file)%><br><% end if %><%=top_board%>
<% end if %>

<table cellpadding="0" cellspacing="0" border="0" width="<%=board_size%>">
  <form method="post" name="inno_check" ID="form1">
  <tr>
    <td class="font"><img src="../img/reference.gif" border="0"> <img src="../img/total.gif" border="0"> <%=recordCount%>, &nbsp; <img src="../img/pages.gif" border="0"> <%=page%> / <%=pagecount%></td>
    <% if right(board_size,1)<>"%" then %><% if board_size <= 500 then %></tr><tr><% end if %><% end if %><td class="font" align="right"><% if session("read")="" and Request.QueryString("num")="" then %><% call member_form %> &nbsp; <% end if %></td>
  </tr>
</table>
<%
	Dim num,id,name,title,url,email,writeday,visit,reco,resame,tag,secret,mem_auth,blank,img_check,id_num,file,filename1,i_width1,i_height1
	Dim nowday,write_diff
	
	if board_type=0 or board_type=1 then
%>
<table width="<%=board_size%>" bgcolor="<%=tb_bgcolor%>" border="0" cellpadding="0" cellspacing="0">

<tr>
	<td width="40" background="../img/title_blank.gif"><img src="../img/title_num.gif"></td>
	<td width="24" align="center" background="../img/title_blank.gif"><a href=javascript:checkboxall();><img src="../img/title_c.gif" border="0"></a></td>
	<td width="100%" align="center" background="../img/title_blank.gif"><img src="../img/title_title.gif"></td>
	<td width="80"><img src="../img/title_name.gif"></td>
	<td width="80"><img src="../img/title_date.gif"></td>
	<td width="40"><img src="../img/title_visit.gif"></td>
	<% if use_reco = 1 and view_reco = 1 then %><td width="40"><img src="../img/title_vote.gif"></td><% end if %>
</tr>


<%
	
	Do until Rs.EOF

    num = rs("num")
    id = rs("id")
    name = rs("name")
    title = rs("title")
    email = rs("email")
    url = rs("url")
    write_diff=rs("writeday")
    writeday = left(write_diff,10)
    visit = rs("visit")
    reco = rs("reco")
    resame = rs("resame")
    tag = rs("tag")
    
    if session_admin="admin" or (session_login_name <> "" and session_uid=id) then
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
    
    if writeday = left(now(),10) then
		writeday=right(write_diff,11)
		writeday=left(writeday,8)
	end if

	nowday=now

	call len_process
	
	call search_fontcolor
	
	call db_comment
	
	call nickname_joint
	
	call img_name_joint

%>

<tr align="center" height="20" <% if nt_tr = 1 and DateDiff("d",write_diff,nowday) < new_title then %>bgcolor="<%=nt_color%>"<% else %>onmouseover="this.style.background='<%=tr_chcolor%>'" onMouseOut="this.style.background='<%=tb_bgcolor%>'<% end if %>">
	<td width="40" class="font" align="Center"><% if num > 100000000 then %><img src="../img/notice.gif"><% else %><%=id_num%><% end if %></td>
	<td width="24"><input type="checkbox" name="cart" value="<%=num%>"></td>
	<td align="left"><% if nt_img = 1 and DateDiff("d",write_diff,nowday) < new_title then %><% if file=1 then %><img src="../img/new_file.gif" border="0"><% else %><img src="../img/new_normal<% if rs("secret")=1 then %>_s<% end if %>.gif" border="0"><% end if %><% else %><% if file=1 then %><img src="../img/file.gif" border="0"><% else %><img src="../img/normal<% if rs("secret")=1 then %>_s<% end if %>.gif" border="0"><% end if %><% end if %>&nbsp;<% if resame <> 0  then %><img src="../img/blank.gif" width="<%=blank%>" height="5" border="0"><img src="../img/re.gif" border="0"> <% end if %><% if (r_level >= user_level) or (session_admin = "admin") then %><a href="<% if secret <> 0 then %>pin<% else %>view<% end if %>.asp?tb=<%=tb%>&num=<%=num%>&page=<%=page%><% if secret <> 0 then %>&mode=secret<% end if %><% if sw<>"" then %>&st=<%=st%>&sc=<%=sc%>&sn=<%=sn%>&sw=<%=sw%><% end if %>"><% end if %><%=title%><% if (r_level >= user_level) or (session_admin = "admin") then %></a><% end if %><% if com_record<>0 then %> &nbsp;<img src="../img/comment.gif" border="0"><span style="font-size:8pt;<% if 12 > DateDiff("h",com_date,nowday) then %>color:red;<% end if %>">(<%=com_record%>)</span><% end if %></td>
	<td width="80"><span onMousedown="inno_layer('info_layer<%=id_num%>','visible')" style=cursor:hand><% if mem_auth = 0 then %><%=name%><% else %><b><%=name%></b><% end if %></span><script>show_layer('info_layer<%=id_num%>', '<%=rs("name")%>', '<%=email%>', '<%=url%>', '<%=tb%>', '<%=mem_auth%>', '<%=id%>', '<% if session_admin="admin" then %>1<% end if %>');</script></td>
	<td width="80"><font size="1"><%=writeday%></font></td>
	<td width="40"><%=visit%></td>
	<% if use_reco = 1 and view_reco = 1 then %><td width="40"><%=reco%></td><% end if %>
</tr>
<tr>
	<td colspan="<%=colspan%>" height="1" bgcolor="#999999"></td>
</tr>

<%
    Rs.Movenext
    id_num = id_num - 1
  Loop
%>
<tr>
	<td colspan="<%=colspan%>" height="7"> 
      <table width="100%" border="0" cellpadding="0" cellspacing="0" ID="Table2">
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

</table>



<%

elseif board_type=2 then '겔러리 일경우

%>
<table width="<%=board_size%>" bgcolor="<%=tb_bgcolor%>" border="0" cellpadding="0" cellspacing="0" ID="Table5">
<tr>
	<td colspan="2">
	<table width="100%" border="0" cellpadding="0" cellspacing="0" ID="Table8">
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
</table>
<table width="<%=board_size%>" bgcolor="<%=tb_bgcolor%>" border="0" cellpadding="0" cellspacing="0" ID="Table10">
<tr>
	<td align="center">
<%

	dim process_gap,nanuki,j
	
	process_gap = cint(board_size)/145
	
	nanuki = int(process_gap)

	Do until Rs.EOF
	
%>
<% if gallery_type = "a" then %>
<!-- #include file="gallery_a.asp" -->
<% elseif gallery_type = "b" then %>
<!-- #include file="gallery_b.asp" -->
<% elseif gallery_type = "c" then %>
<!-- #include file="gallery_c.asp" -->
<% elseif gallery_type = "d" then %>
<!-- #include file="gallery_d.asp" -->
<% end if %>
<table width="<%=board_size%>" border="0" cellpadding="0" cellpadding ="0" ID="Table7">
<tr>
		<td height="1" bgcolor="#cccccc"></td>
</tr>
</table>
<%

	if gallery_type <> "a" then
		Rs.Movenext
		id_num = id_num-1
	end if
	Loop
%>
</td>
</tr>
</table>

<table width="<%=board_size%>" bgcolor="<%=tb_bgcolor%>" border="0" cellpadding="0" cellspacing="0" ID="Table3">
<tr>
	<td colspan="2">
	<table width="100%" border="0" cellpadding="0" cellspacing="0" ID="Table4">
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
</table>
<%
elseif board_type=3 then	'### 디지털 다이어리일경우
%>

<!-- #include file="digital_diary.asp" -->
<% end if %>

<table width="<%=board_size%>" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td class="font" align="center"><% Call PageSearch %></td>
</tr>
<% if session("read")="" and Request.QueryString("num")="" then %>
<tr>
	<td align="right" style="word-break:break-all;padding:5px;"><% if session_admin = "admin" then %><a href="javascript:del_cart();"><img src="../img/but_del_1.gif" border="0"></a> <% end if %><a href="javascript:box(document.all.form_search)"><img src="../img/but_search.gif" border="0"></a><% if w_level >= session_level then %> <a href="form.asp?tb=<%=tb%>"><img src="../img/but_write.gif" border="0"></a><% end if %><% if sw<>"" then %> <a href="list.asp?tb=<%=tb%>"><img src="../img/but_list.gif" border="0"></a><% end if %></td>
</tr>
<% end if %>
</form>

<% if session("read")="" and Request.QueryString("num")="" then %>
<tr>
	<td align="right" id="form_search" style="display:<% if sw="" then %>none<% end if %>"><% Call form_search %></td>
</tr>

<% end if %>
</table>

<%

  Rs.close
  db.close
  Set Rs = Nothing
  Set db = Nothing
%>
<% if session("read")="" and Request.QueryString("num")="" then %>
<% if down_file<>"" then %><% server.execute(down_file)%><br><% end if %><%=bottom_board%>
<% end if %>

</body>
</html>
