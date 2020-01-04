<%@  transaction="supported" language="vbscript" codepage="65001" %>
<% 
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>

<% response.buffer = true %>
<% Response.Expires=-1 %>
<% StartTime = Timer() %>

<% session("read")="" %>

<!-- #include virtual="/IFF_MAIN/Board/inc/dbinfo.asp" -->
<!-- #include virtual="/IFF_MAIN/Board/inc/info_tb.asp" -->
<!-- #include virtual="/IFF_MAIN/Board/inc/joint.asp" -->
<!-- #include virtual="/IFF_MAIN/Board/inc/board_check.asp" -->

<%
	Dim pagecount, recordCount,colspan,vOrgNum,vOrgName

	vOrgNum = Request.QueryString("oNum")
    
    
	if vOrgNum <> "" and isnull(vOrgNum) = false then
		vOrgName = Request.QueryString("oName")
		
		session("vOrgNum") = vOrgNum
		session("vOrgName") = vOrgName
	end if


	session("tb") = request("tb")
  

	page = Request("page")
	if page = "" then page = 1

	call db_list_remarks
	
	if use_reco = 1 and view_reco = 1 then
		colspan = 7
	else
		colspan = 6
	end if
%>

<%
	dim temp_path,vDest
	temp_path = UCase(Server.MapPath("../../temp"))
	Set fsoTmp = Server.CreateObject("Scripting.FileSystemObject")
	If Not fsoTmp.FolderExists(temp_path) Then
		Set f = fsoTmp.CreateFolder(temp_path)
	End If
	If Not fsoTmp.FolderExists(temp_path & "\Eltdata") Then
		Set f = fsoTmp.CreateFolder(temp_path & "\Eltdata")
	End If

	If Not fsoTmp.FolderExists(temp_path & "\Eltdata\" & elt_account_number) Then
		Set f = fsoTmp.CreateFolder(temp_path & "\Eltdata\" & elt_account_number)
	End If
	if Not session("vOrgNum")="" then
		vDest=temp_path & "\Eltdata\" & elt_account_number & "\" & session("vOrgNum")
		If Not fsoTmp.FolderExists(vDest) Then
			Set f = fsoTmp.CreateFolder(vDest)
		End If
	end if
	
	Set fsoTmp=Nothing
%>

<% '//////////// listRemarks.asp 페이지 db 연결부분
sub db_list_remarks

	
	sw = request("sw")
	
	if sw="" then
		SQL = "select count(num) as recCount from "&tb & " where elt_account_number = " & elt_account_number & " and org_account_number="&session("vOrgNum")

		Set rs = db.Execute(SQL)

		recordCount = Rs(0)
		pagecount = int((recordCount-1)/pagesize) +1
		id_num = recordCount - (Page -1) * PageSize
		SQL = "SELECT TOP " & pagesize & " * FROM "&tb
		SQL = SQL & " WHERE elt_account_number = " & elt_account_number & " and org_account_number="&session("vOrgNum")
		if int(page) > 1 then
		SQL = SQL &  " and num not in "
		SQL = SQL & "(SELECT TOP " & ((page - 1) * pagesize) & " num FROM "&tb & " where elt_account_number = " & elt_account_number & " and org_account_number="&session("vOrgNum")
		SQL = SQL & " ORDER BY re DESC,reid asc,num DESC)" 
		end if
		SQL = SQL & " order by re DESC,reid asc,num desc"
	else
		st=request("st")
		sc=request("sc")
		sn=request("sn")
		sw = replace(sw,"'","''")

		if st="on" then
			search="(title LIKE '%"& sw &"%')"
		
			if sc="on" or sn="on" then
				search=search & " or "
			end if
		else
			st="off"	
		end if
	
		if sc="on" then
			if st="on" then
				search=search & "(content LIKE '%"& sw &"%')"
			else
				search="(content LIKE '%"& sw &"%')"
			end if
			
			if sn="on" then
				search=search & " or "
			end if
	
		else
			sc="off"
		end if
	
		if sn="on" then
			if st="on" or sc="on" then
				search=search & "(name LIKE '%"& sw &"%')"
			else
				search="(name LIKE '%"& sw &"%')"
			end if
		else
			sn="off"		
		end if
		h_url = "/IFF_MAIN/Board/board/listRemarks.asp?tb=Remarks&page=" & page			

		if st="off" and sc="off" and sn="off" then response.Redirect "../inc/error.asp?no=17&h_url="&h_url
		
		SQL = "select count(num) as recCount from "&tb&" where "&search & " and elt_account_number = " & elt_account_number & " and org_account_number="&session("vOrgNum")
		Set rs = db.Execute(SQL)

		recordCount = Rs(0)
		pagecount = int((recordCount-1)/pagesize) +1
		id_num = recordCount - (Page -1) * PageSize
  

		SQL = "SELECT TOP " & pagesize & " * FROM "&tb
		SQL = SQL & " WHERE ("&search&") "& " and elt_account_number=" & elt_account_number & " and org_account_number="&session("vOrgNum")
		if int(page) > 1 then
		SQL = SQL & " and num not in "
		SQL = SQL & "(SELECT TOP " & ((page - 1) * pagesize) & " num FROM "&tb
		SQL = SQL & " where "&search& " and elt_account_number=" & elt_account_number & " and org_account_number="&session("vOrgNum")&" ORDER BY num DESC)"
		end if
		SQL = SQL & " order by num desc" 

	end if

	Set Rs = db.Execute(SQL)
end sub
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=board_title%></title>

<link rel="stylesheet" type="text/css" href="../inc/style.css" />
<script type="text/jscript">
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

		{
			printMain = printMain +	"<tr onMouseOver=this.style.backgroundColor='#bbbbbb' onMouseOut=this.style.backgroundColor='' onMousedown=location.href='listRemarks.asp?tb="+tb+"&sn=on&st=off&sc=off&sw="+name+"';><td style=font-family:verdana;font-size:9pt height=18 nowrap>&nbsp;<img src=../img/n_search.gif border=0 align=absmiddle>&nbsp;&nbsp;Search by Name&nbsp;&nbsp;</td></tr>";
			printHeight = printHeight + 16;
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
    if(confirm("Selected remarks will be deleted! Are you sure to continue?")){
	    document.inno_check.action = "delRemarks_ok.asp?tb=<%=tb%>&page=<%=page%>&mode=del_cart"
	    document.inno_check.submit();
	}
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
<meta name="description" content="Client Remarks">
</head>
<body bgcolor="<%=bgcolor%>" marginwidth="0" marginheight="0" leftmargin="0" topmargin="0">
<% if session("read")="" and Request.QueryString("num")="" then %>
<% if top_file<>"" then %><% server.execute(top_file)%><br><% end if %><%=top_board%>
<% end if %>

<table cellpadding="0" cellspacing="0" border="0" width="<%=board_size%>">
  <form method="post" name="inno_check" ID="form1">
  <tr>
  <td class="form_title"><%
response.write "<b> Remarks- <span class='header'>" & session("vOrgName") & "</span><b>"
response.write "<br>"
response.write "<br>"
%></td>
  </tr>
  <tr>
    <td height="28" class="font"><img src="../img/reference.gif" border="0"> <img src="../img/total.gif" border="0"> <%=recordCount%>, &nbsp; <img src="../img/pages.gif" border="0"> <%=page%> / <%=pagecount%></td>
    <% if right(board_size,1)<>"%" then %><% if board_size <= 500 then %></tr><tr><% end if %><% end if %><td class="font" align="right"><% if session("read")="" and Request.QueryString("num")="" then %><% end if %></td>
  </tr>
</table>
<%
	Dim num,id,name,title,url,email,writeday,visit,reco,resame,tag,secret,mem_auth,blank,img_check,id_num,file,filename1,i_width1,i_height1
	Dim nowday,write_diff
	
	if board_type=0 or board_type=1 then
%>
<table width="<%=board_size%>" bgcolor="<%=tb_bgcolor%>" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td height="1" colspan="6" bgcolor="#aac9da"></td>
    </tr>
    <tr>
        <td height="1" colspan="6" bgcolor="#ffffff"></td>
    </tr>
    <tr>
        <td bgcolor="#dbe7ed" class="smallcopy"></td>
        <td height="10" bgcolor="#dbe7ed" class="smallcopy">No.</td>
        <td height="7" bgcolor="#dbe7ed"></td>
        <td width="571" height="7" bgcolor="#dbe7ed" class="smallcopy">Title</td>
        <td height="7" bgcolor="#dbe7ed" class="smallcopy">Name</td>
        <td height="7" bgcolor="#dbe7ed" class="smallcopy">Posted Date </td>
    </tr>
    <tr>
        <td height="1" colspan="6" bgcolor="#ffffff"></td>
    </tr>
    <tr>
        <td height="1" colspan="6" bgcolor="#aac9da"></td>
    </tr>
    <tr>
        <td colspan="6"><a href=javascript:checkboxall();></a></td>
        <td width="1"></td>
        <% if use_reco = 1 and view_reco = 1 then %>
        <td width="1"></td>
        <% end if %>
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
	
	call db_comment_Remarks
	
	call nickname_joint
	
	call img_name_joint

%>
    <tr align="center" height="20" <% if nt_tr = 1 and datediff("d",write_diff,nowday) < new_title then %>bgcolor="<%=nt_color%>"<% else %>onmouseover="this.style.background='<%=tr_chcolor%>'" onMouseOut="this.style.background='<%=tb_bgcolor%>'<% end if %>">
        <td width="10" class="font" align="Center">&nbsp;</td>
        <td width="32" align="left" valign="middle" class="font"><% if num > 100000000 then %>
                <img src="../img/notice.gif">
            <% else %>
            <%=id_num%>
            <% end if %></td>
        <td width="47" align="left" valign="middle"><input type="checkbox" name="cart" value="<%=num%>"></td>
        <td align="left" valign="middle"><% if nt_img = 1 and DateDiff("d",write_diff,nowday) < new_title then %>
                <% if file=1 then %>
            <img src="../img/new_file.gif" border="0">
            <% else %>
            <img src="../img/new_normal<% if rs("secret")=1 then %>_s<% end if %>.gif" border="0">
            <% end if %>
            <% else %>
            <% if file=1 then %>
            <img src="../img/file.gif" border="0">
            <% else %>
            <img src="../img/normal<% if rs("secret")=1 then %>_s<% end if %>.gif" border="0">
            <% end if %>
            <% end if %>
            &nbsp;
            <% if resame <> 0  then %>
            <img src="../img/blank.gif" width="<%=blank%>" height="5" border="0"><img src="../img/re.gif" border="0">
                <% end if %>
            <% if (r_level >= user_level) or (session_admin = "admin") then %>
            <a href="<% if secret <> 0 then %>pin<% else %>viewRemarks<% end if %>.asp?tb=<%=tb%>&num=<%=num%>&page=<%=page%><% if secret <> 0 then %>&mode=secret<% end if %><% if sw<>"" then %>&st=<%=st%>&sc=<%=sc%>&sn=<%=sn%>&sw=<%=sw%><% end if %>">
                <% end if %>
                <%=title%>
                <% if (r_level >= user_level) or (session_admin = "admin") then %>
            </a>
            <% end if %>
            <% if com_record<>0 then %>
            &nbsp;<img src="../img/comment.gif" border="0"><span style="font-size:9px;<% if 12 > DateDiff("h",com_date,nowday) then %>color:#996633;<% end if %>">(<%=com_record%>)</span>
            <% end if %></td>
        <td width="109" align="left" valign="middle" class="user"><span onMouseDown="inno_layer('info_layer<%=id_num%>','visible')" style=cursor:hand>
            <% if mem_auth = 0 then %>
            <%=name%>
            <% else %>
            <b><%=name%></b>
            <% end if %>
            </span>
                <script>show_layer('info_layer<%=id_num%>', '<%=rs("name")%>', '<%=email%>', '<%=url%>', '<%=tb%>', '<%=mem_auth%>', '<%=id%>', '<% if session_admin="admin" then %>1<% end if %>');</script></td>
        <td width="77" align="left" valign="middle" class="smallcopyitalic"><font size="1"><%=writeday%></font></td>
        <td width="1"></td>
        <% if use_reco = 1 and view_reco = 1 then %>
        <td width="1"></td>
        <% end if %>
    </tr>
    <tr>
        <td bgcolor="#999999"></td>
        <td colspan="<%=colspan%>" height="1" bgcolor="#999999"></td>
    </tr>
    <%
    Rs.Movenext
    id_num = id_num - 1
  Loop
%>
    <tr>
        <td><table width="100%" border="0" cellpadding="0" cellspacing="0">
            	<tr>
		<td height="1" bgcolor="#aac9da"></td>
	</tr>
	<tr>
		<td height="1" bgcolor="#ffffff"></td>
	</tr>
	<tr>
		<td height="12" bgcolor="#dbe7ed"></td>
	</tr>
	<tr>
		<td height="1" bgcolor="#ffffff"></td>
	</tr>
	<tr>
		<td height="1" bgcolor="#aac9da"></td>
	</tr>
        </table></td>
        <td colspan="<%=colspan%>" height="7"><table width="100%" border="0" cellpadding="0" cellspacing="0" id="Table2">
            	<tr>
		<td height="1" bgcolor="#aac9da"></td>
	</tr>
	<tr>
		<td height="1" bgcolor="#ffffff"></td>
	</tr>
	<tr>
		<td height="12" bgcolor="#dbe7ed"></td>
	</tr>
	<tr>
		<td height="1" bgcolor="#ffffff"></td>
	</tr>
	<tr>
		<td height="1" bgcolor="#aac9da"></td>
	</tr>
        </table></td>
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
<table width="<%=board_size%>" bgcolor="<%=tb_bgcolor%>" border="0" cellpadding="0" cellspacing="0" id="Table10">
  <tr>
    <td align="center"><%

	dim process_gap,nanuki,j
	
	process_gap = cint(board_size)/145
	
	nanuki = int(process_gap)

	Do until Rs.EOF
	
%>
        <% if gallery_type = "a" then %>
        <!-- #include file="gallery_a.asp" -->
</table>
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

<!-- #include file="digitalRemarks_diary.asp" -->
<% end if %>

<table width="<%=board_size%>" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td class="font" align="center"><% Call PageSearch_Remarks %></td>
</tr>
<% if session("read")="" and Request.QueryString("num")="" then %>
<tr>
	<td align="right" style="word-break:break-all;padding:5px;"><% if session_login_name = "admin" then %><a href="javascript:del_cart();"><img src="../img/but_del_1.gif" border="0"></a> <% end if %><a href="javascript:box(document.all.form_search)"><img src="../img/but_search.gif" border="0"></a><% if w_level >= session_level then %>
	    <a href="formRemarks.asp?tb=<%=tb%>&oNum=<%=session("vOrgNum")%>&page=<%=page%>"><img src="../img/but_write.gif" border="0"></a>
	    <% end if %><% if sw<>"" then %> <a href="listRemarks.asp?tb=<%=tb%>"><img src="../img/but_list.gif" border="0"></a><% end if %></td>
</tr>
<% end if %>
</form>

<% if session("read")="" and Request.QueryString("num")="" then %>
<tr>
	<td align="right" id="form_search" style="display:<% if sw="" then %>none<% end if %>"><% Call form_search_remarks %></td>
</tr>

<% end if %>
</table>
<div class="smallcopy">
<%

  Rs.close
  db.close
  Set Rs = Nothing
  Set db = Nothing
%>
<% if session("read")="" and Request.QueryString("num")="" then %>
<% if down_file<>"" then %><% server.execute(down_file)%><br><% end if %><%=bottom_board%>
<% end if %>

<% Sub PageSearch_Remarks %>
	<% If Rs.BOF Then %>
	
	<%
		Else
		If Int(Page) <> 1 Then 
	%>
		<a href="listRemarks.asp?tb=<%=tb%>&page=<%=Page-1%><% if sw<>"" then %>&st=<%=st%>&sc=<%=sc%>&sn=<%=sn%>&sw=<%=sw%><% end if %>" onFocus="this.blur()"><font color="#3399CC" style="font-size:9px;">[prv]</font></a>
	<%
		end if
		
		First_Page = Int((Page-1)/Block)*Block+1
		If First_Page <> 1 Then
	%>
			[<a href="listRemarks.asp?tb=<%=tb%>&page=1<% if sw<>"" then %>&st=<%=st%>&sc=<%=sc%>&sn=<%=sn%>&sw=<%=sw%><% end if %>" onFocus="this.blur()"><font color="#000000" style="font-size:9px;">1</font></a>]&nbsp;..
	<%
		end if
		
		If PageCount - First_Page < Block Then
			End_Page = PageCount
		Else
			End_Page = First_Page + Block - 1
		End If

		For page_i = First_Page To End_Page
		If Int(Page) = page_i Then
	%>
			[<font color="#FF0000" style="font-size:9px;"><b><%=page_i%></b></font>]
	<% Else %>
			[<a href="listRemarks.asp?tb=<%=tb%>&page=<%=page_i%><% if sw<>"" then %>&st=<%=st%>&sc=<%=sc%>&sn=<%=sn%>&sw=<%=sw%><% end if %>" onFocus="this.blur()"><font color="#000000" style="font-size:8pt;"><%=page_i%></font></a>]
	<%
		End If
		Next
		
		If End_Page <> PageCount Then
	%>
	&nbsp;..&nbsp;[<a href="listRemarks.asp?tb=<%=tb%>&page=<%=PageCount%><% if sw<>"" then %>&st=<%=st%>&sc=<%=sc%>&sn=<%=sn%>&sw=<%=sw%><% end if %>" onFocus="this.blur()"><font color="000000" style="font-size:8pt;"><%=PageCount%></font></a>]
	<%
		end if
		
		If Int(Page) <> PageCount Then
	%>
	&nbsp;<a href="listRemarks.asp?tb=<%=tb%>&page=<%=page+1%><% if sw<>"" then %>&st=<%=st%>&sc=<%=sc%>&sn=<%=sn%>&sw=<%=sw%><% end if %>" onFocus="this.blur()"><font color="#ff6600" style="font-size:8pt;">[next]</font></a>
	<%
		End If
		End If
	%>
<% End Sub %>

<% Sub form_search_remarks %></div>
<table border="0" cellpadding="0" cellspacing="0">
<tr>
	<form action="listRemarks.asp?tb=<%=tb%>" Method="POST" name="inno">
	<td valign="bottom">
		<input type=hidden name=st value="<% if st="on" then %>on<%elseif st="" then%>on<%else%>off<% end if %>">
		<input type=hidden name=sc value="<% if sc="on" then %>on<%elseif sc="" then%>on<%else%>off<% end if %>">
		<input type=hidden name=sn value="<% if sn="on" then %>on<%else%>off<% end if %>">
		<img src="../img/search0.gif" border="0"><a href="javascript:OnOff('st')"><img src="../img/st_<% if st="on" then %>on<%elseif st="" then%>on<%else%>off<% end if %>.gif" border="0" name="st" align="absmiddle"></a><a href="javascript:OnOff('sc')"><img src="../img/sc_<% if sc="on" then %>on<%elseif sc="" then%>on<%else%>off<% end if %>.gif" border="0" name="sc" align="absmiddle"></a><a href="javascript:OnOff('sn')"><img src="../img/sn_<% if sn="on" then %>on<%else%>off<% end if %>.gif" border="0" name="sn" align="absmiddle"></a></td>
	<td><input type="text" name="sw" value="<%=sw%>" class="form_input" size="20"></td>
	<td valign="bottom"><input type="image" border="0" src="../img/search.gif" align="absmiddle" id=image1 name=image1></td>
	<td valign="bottom"><a href="listRemarks.asp?tb=<%=tb%>"><img src="../img/search1.gif" border="0"></a></td>
</form>
  </tr>
</table>
<% end sub %>

</body>
</html>
