<%@  transaction="supported" language="vbscript" codepage="65001" %>
<% 
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>

<% response.buffer = true %>
<% Response.Expires=-1 %>

<!-- #include virtual="/IFF_MAIN/Board/inc/dbinfo.asp" -->
<!-- #include virtual="/IFF_MAIN/Board/inc/info_tb.asp" -->
<!-- #include virtual="/IFF_MAIN/Board/inc/joint.asp" -->

<% 

	if board_type > 0 and upload_type = "dext" then
		dim objMon
	
		Set objMon = Server.CreateObject("DEXT.FileUploadMonitor") 
		
		objMon.UseMonitor(True) 
		Set objMon = Nothing
	end if
%> 


<%
	
	dim num,mode,name,pin,secret_pin,email,url,link_1,link_2,notice,tag,secret,reply_mail,title,resame,reid,link,filename1,filesize1,filename2,filesize2,filename3,filesize3,filename4,filesize4
	dim i_width1,i_height1,i_width2,i_height2,i_width3,i_height3,i_width4,i_height4

	num = Request.QueryString("num")
	page = Request.QueryString("page")
	mode = Request.QueryString("mode")

	
	If mode = "reply" Then

		SQL = "Select name,title,content,resame,reid,tag From "&tb&"  where elt_account_number="&elt_account_number&" and org_account_number="&session("vOrgNum")&" and num="&num
		Set rs = db.Execute(SQL)
		
		name = rs("name")
		title = rs("title")
		content = rs("content")
		resame = rs("resame")
		reid  = rs("reid")
		tag = rs("tag")

		content = Chr(62)&Chr(62) &" Written by " & name & Chr(13) & content
		
		'######################## information for easywork editor ########################## 	
		if content_type="1" and tag > 0 then 
			content = Replace(content,vbcrlf,"")
			content = Replace(content,"'","\'")
			content = checkword(content)
		end if
		'######################## information for easywork editor ########################## 
	End If

	If mode = "edit" Then
	
		dim form_pin
		
		if session_login_name <> "" and Request.QueryString("mem") = "ok" then
			SQL="SELECT id,pin FROM "&tb&" where elt_account_number="&elt_account_number & " and org_account_number="&session("vOrgNum")&" and num="&num
			Set rs = db.Execute(SQL)
			form_pin = rs(1)			
		else
			form_pin = Request.Form("form_pin")
		end if
		
		SQL = "Select * From "&tb&" Where  elt_account_number="&elt_account_number & " and org_account_number="&session("vOrgNum")&" and num="&num&" and pin='"& form_pin &"'"
		Set rs = db.Execute(SQL)
		h_url = "/IFF_MAIN/Board/board/listRemarks.asp?tb=Remarks&page=" & page			
		if rs.eof or rs.bof then Response.Redirect "../inc/error.asp?no=2&h_url="&h_url
		
		name = rs("name")
		pin = rs("pin")
		secret_pin = rs("secret_pin")
		email = rs("email")
		url = rs("url")
		link_1 = rs("link_1")
		link_2 = rs("link_2")
		notice = rs("notice")
		tag = rs("tag")
		secret= rs("secret")
		reply_mail= rs("reply_mail")
		title = rs("title")
		content = rs("content")		
		
		'######################## information for easywork editor ########################## 	
		if content_type="1" and tag > 0 then 
			content = Replace(content,vbcrlf,"")
			content = Replace(content,"'","\'")
			content = checkword(content)
		end if
		'######################## information for easywork editor ########################## 
		
		resame = rs("resame")
		reid  = rs("reid")
		link = link_1&link_2
		
		if board_type > 0 and mode = "edit" then
			filename1 = rs("filename1")
			filesize1 = rs("filesize1")
			filename2 = rs("filename2")
			filesize2 = rs("filesize2")
			filename3 = rs("filename3")
			filesize3 = rs("filesize3")
			filename4 = rs("filename4")
			filesize4 = rs("filesize4")
			i_width1 = rs("i_width1")
			i_height1 = rs("i_height1")
			i_width2 = rs("i_width2")
			i_height2 = rs("i_height2")
			i_width3 = rs("i_width3")
			i_height3 = rs("i_height3")
			i_width4 = rs("i_width4")
			i_height4 = rs("i_height4")
		end if
				
	End If
%>

<html>
<head>
<title><%=board_title%></title>

<LINK rel="stylesheet" type="text/css" href="../inc/style.css">
<% '######################## javascript for easywork editor ########################## %>
<% if content_type="1" then %>
<script LANGUAGE="VBScript" RUNAT="Server">
Function CheckWord(CheckValue)
CheckValue = replace(CheckValue, "&lt;", "<")
CheckValue = replace(CheckValue, "&gt;", ">")
CheckValue = replace(CheckValue, "&quot;","'")
CheckValue = replace(CheckValue, "&amp;", "&" )

CheckWord = CheckValue
End Function 

</script>


	<script language="javascript">
	<!--
		var blnBodyLoaded = false;
		var blnEditorLoaded = false;
		
		function window_onload() {
			blnBodyLoaded = true;
			if (blnEditorLoaded == true) {
				init();
			}	
		}
		
		function init() {
			for (var i = 0; i < 10000; i++){}

				document.all.editBox.html='<%=content%>'

		}
		
		function setEditMode(sMode) {
			if (document.all.editmode.checked == false) {
				sMode = "html";
				document.all.editBox.editmode = sMode;
			}
			else
			document.all.editBox.editmode = sMode;
		}
	//-->
	</script>
	<script for="editBox" event="onscriptletevent(name, eventData)">
		if (name == "onafterload") {
			blnEditorLoaded = true;
			if (blnBodyLoaded == true) {
				init();
			}
		}
	</script>
<% end if %>
<% '######################## javascript for easywork editor ########################## %>

<script language="javascript">
<!--

	
	function check_use_html(obj) {
		
		if(!obj.checked) {
			obj.value=1;
		} else {
			if(confirm("Do you want to use the auto line feed?\n\nAuto line feed will change the new line with <br> tag.")) {
				obj.value=1;
			} else {
				obj.value=2;
			}
		}
	}

	function secret_option(obj) {
		
		if(!obj.checked) {
			obj.value=1;
			document.all.secret_option.style.display = "none"
			document.all.secret_option1.style.display = "none"
		} else {
			if(confirm("Do you want to set a password for reading?\n\nIf you do not want, The password when you wrote this message will be entered.")) {
				obj.value=1;
				document.all.secret_option.style.display = ""
				document.all.secret_option1.style.display = ""
			} else {
				obj.value=2;
				document.all.secret_option.style.display = "none"
				document.all.secret_option1.style.display = "none"
			}
		}
	}	
	
	
	var letters = 'ghijklabvwxyzABCDEFef)_+|<>?:mnQRSTU~!@#$%^VWXYZ`1234567opGHIJKLu./;'+"'"+'[]MNOP890-='+'\\'+'&*("{},cdqrst'+"\n";
	var split = letters.split("");var num = '';var c = '';

function re(){	
	
	var encrypted = '';
	var it = '<%=pin%>';
	var b = '0';var chars = it.split("");while(b<it.length){c = '0';while(c<letters.length){if(split[c] == chars[b]){if(c == "0") { c = ""; }if(eval(c-10) < 0){num = eval(letters.length-(10-c));encrypted += split[num];}else{num = eval(c-10);encrypted += split[num];}}c++;}b++;}document.inno.pin.value = encrypted;encrypted = '';
	<% if secret=1 then %>
		var it = '<%=secret_pin%>';
		var b = '0';var chars = it.split("");while(b<it.length){c = '0';while(c<letters.length){if(split[c] == chars[b]){if(c == "0") { c = ""; }if(eval(c-10) < 0){num = eval(letters.length-(10-c));encrypted += split[num];}else{num = eval(c-10);encrypted += split[num];}}c++;}b++;}document.inno.secret_pin.value = encrypted;encrypted = '';
	<% end if %>
	}
	
	
function submit()
{
// ######################## javascript for easywork editor ##########################
<% if content_type=1 then %>
document.all.content.value = document.all.editBox.html;
<% end if %>
// ######################## javascript for easywork editor ##########################
<% if session_login_name = "" then %>
	if (document.inno.name.value == "") {
		alert("Please enter your name.");
		document.inno.name.focus();
		return;
	}
	if (document.inno.pin.value =="") {
		alert("Please enter your password.");
		document.inno.pin.focus();
		return;
	}
	
	if (document.inno.email.value.length > 1 )  {
	
	str = document.inno.email.value;
	if(	(str.indexOf("@")==-1) || (str.indexOf(".")==-1)){
		alert("Please enter the valid email address.")
		document.inno.email.focus();
		return;
	}
	}
	<% end if %>
	if (document.inno.title.value =="") {
		alert("Please enter the title.");
		document.inno.title.focus();
		return;
	}
	
	
	if (document.inno.reply_mail.checked == true) {
		if (document.inno.email.value =="") {
			alert("Please enter the email address.");
			document.inno.email.focus();
			return;
		}	
	}
	
	
	var encrypted = '';
	var it = document.inno.pin.value;
	var b = '0';var chars = it.split("");while(b<it.length){c = '0';while(c<letters.length){if(split[c] == chars[b]){if(c == "0") { c = ""; }if(eval(c+10) >= letters.length){num = eval(10-(letters.length-c));encrypted += split[num];}else{num = eval(c+10);encrypted += split[num];}}c++;}b++;}document.inno.pin.value = encrypted;encrypted = '';
	
	
	if (document.inno.secret.checked == true) {
		if (document.inno.secret_pin.value.length > 1) {
			var encrypted = '';
	var it1 = document.inno.secret_pin.value;
	var b1 = '0';
	var chars1 = it1.split("");
	while(b1<it1.length){c1 = '0';
	while(c1<letters.length){if(split[c1] == chars1[b1]){if(c1 == "0") { c1 = ""; }if(eval(c1+10) >= letters.length){num = eval(10-(letters.length-c1));
	encrypted += split[num];}else{num = eval(c1+10);encrypted += split[num];}}c1++;}b1++;}document.inno.secret_pin.value = encrypted;encrypted = '';
		}	
	}
	
	<% if board_type > 0 and upload_type="dext" and view_upload=1 then %>
	ShowProgress();
	<% elseif board_type > 0 and upload_type="abc" and view_upload=1 then %>
	DoUpload();
	<% end if %>
	//alert(document.inno.action);
	document.inno.submit();

}
function cancel()
{
	
if ( '<%=mode%>' == 'edit' ) {
		if ('<%=board_type%>' == '3' )
		{
		window.location = 'digitalRemarks_diary_c.asp?tb='+'<%=tb%>'+'&page='+'<%=page%>'+'&num='+'<%=num%>';
		}
		else
		{	
		window.location = 'contentRemarks.asp?tb='+'<%=tb%>'+'&page='+'<%=page%>'+'&num='+'<%=num%>';
		}
	}
else {
	window.location = 'listRemarks.asp?tb='+'<%=tb%>'+'&page='+'<%=page%>';
	}	
}

function reset()
{
	document.inno.reset();
}

function box()
{ 
	   if (document.all.link1.style.display != "none"){
           document.all.link1.style.display = "none"
           document.all.link11.style.display = "none"
           document.all.link2.style.display = "none"
           document.all.link22.style.display = "none"
           }
           else {
           document.all.link1.style.display = ""
           document.all.link11.style.display = ""
           document.all.link2.style.display = ""
           document.all.link22.style.display = ""
           }
}

function box1()
{ 
	   if (document.all.re_content.style.display != "none"){
           document.all.re_content.style.display = "none"
           document.all.re_content1.style.display = "none"
           }
           else {
           document.all.re_content.style.display = ""
           document.all.re_content1.style.display = ""
           }
}

function ShowProgress() 
{ 
   strAppVersion = navigator.appVersion; 
   if (document.inno.allfile1.value != ""<% if upload_form > 1 then %> || document.inno.allfile2.value != ""<% end if %><% if upload_form > 2 then %> || document.inno.allfile3.value != ""<% end if %><% if upload_form > 3 then %> || document.inno.allfile4.value != ""<% end if %>) {
      if (strAppVersion.indexOf('MSIE')!=-1 && 
          strAppVersion.substr(strAppVersion.indexOf('MSIE')+5,1) > 4) { 

          winstyle = "dialogWidth=385px; dialogHeight:150px; center:yes"; 
          window.showModelessDialog("show_progress.asp?nav=ie", null, winstyle); 
      } 
      else { 
          winpos = "left=" + ((window.screen.width-380)/2)+",top="+((window.screen.height-110)/2);
          winstyle="width=380,height=110,status=no,toolbar=no,menubar=no," + "location=no, resizable=no,scrollbars=no,copyhistory=no," + winpos; 
          window.open("show_progress.asp",null,winstyle); 
      } 
   }

   return true; 
}
function DoUpload() {

  theFeats =   "height=120,width=500,location=no,menubar=no,resizable=no,scrollbars=no,status=no,toolbar=no";
  theUniqueID = (new Date()).getTime() % 1000000000;
  if (document.inno.allfile1.value != ""<% if upload_form > 1 then %> || document.inno.allfile2.value != ""<% end if %><% if upload_form > 2 then %> || document.inno.allfile3.value != ""<% end if %><% if upload_form > 3 then %> || document.inno.allfile4.value != ""<% end if %>) {
  window.open("progressbar.asp?ID=" + theUniqueID, theUniqueID, theFeats);
  }
  document.inno.action = "abc_formRemarks_ok.asp?ID=" + theUniqueID;
}


//-->
</script>

<script src="Scripts/AC_ActiveX.js" type="text/javascript"></script>
<script src="Scripts/AC_RunActiveContent.js" type="text/javascript"></script>
</head>
<body bgcolor="<%=bgcolor%>" marginwidth="0" marginheight="0" leftmargin="0" topmargin="0" onLoad="<% if mode="edit" then %>javascript:re();<% end if %>document.inno.<% if session_login_name <> "" then %><% if board_type=3 then %>allfile1<% else %>title<% end if %><% else %>name<% end if %>.focus();<% if content_type=1 and (mode="edit" or mode="reply") then %>return window_onload();<% end if %>">

<% if top_file<>"" then %><% server.execute(top_file)%><br><% end if %><%=top_board%>
<table cellpadding="0" cellspacing="0" border="0" width="<%=board_size%>" ID="Table1">
  <tr>
	<td class="font" align="right"></td>
  </tr>
</table>
<table width="<%=board_size%>" border="0" cellpadding="0" cellspacing="0">
<form name="inno" method="POST" action="<% if board_type > 0 then %><%=upload_type%>_<% end if %>formRemarks_ok.asp"<% if board_type > 0 then %> enctype="MULTIPART/FORM-DATA"<% end if %> onSubmit="return submit(this);">
<tr>
	<td colspan="4">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<tr><td height="34" align="right" valign="middle"><span style="word-break:break-all;padding:5px;">
		    
		    <a href="listRemarks.asp?tb=<%=tb%>&page=<%=page%>"><img src="../img/but_list2.gif" border="0"></a></span></td></tr>
	<tr>
		<td height="1" bgcolor="#aac9da"></td>
	</tr>
	<tr>
		<td height="1" bgcolor="#ffffff"></td>
	</tr>
	<tr>
		<td height="7" bgcolor="#dbe7ed"></td>
	</tr>
	<tr>
		<td height="1" bgcolor="#ffffff"></td>
	</tr>
	<tr>
		<td height="1" bgcolor="#aac9da"></td>
	</tr>
</table>
	</td>
</tr>
<tr>
	<td colspan="4" height="1"></td>
</tr>
<% 
if session_login_name = "" then %>
<tr bgcolor="F7F7F7" height="25"> 
	<td width="92" align="right" bgcolor="#dbe7ed" class="form_title"><b>&nbsp;Name&nbsp;</b></td>
	<td width="193" bgcolor="#FFFFFF"><input type="text" name="name" size="15" class="form_input" maxlength="30" value="<% if session_login_name = "" and mode="edit" then %><%=name%><% else %><% if session_login_name<>"" then %><%=session_login_name%><% else %><% if use_cookies=1 then %><%=Request.Cookies("inno")("name")%><% end if %><% end if %><% end if %>"></td>
	<td width="110" align="right" bgcolor="#FFFFFF" class="form_title"><b>Password&nbsp;</b></td>
	<td width="175" bgcolor="#FFFFFF"><input type="password" name="pin" size="15" maxlength="20" class="form_input" value="<% if session_uid = "" and mode="edit" then %><% else %><%=session_pin%><% end if %>"></td>
</tr>
<tr>
	<td colspan="4" height="1" bgcolor="#999999"></td>
</tr>
<tr bgcolor="F7F7F7" height="25"> 
	<td width="92" align="right" bgcolor="#dbe7ed" class="form_title">Email&nbsp;</td>
	<td colspan="3" bgcolor="#FFFFFF"><input type="text" name="email" size="30" class="form_input" maxlength="50" value="<% if session_login_name = "" and mode="edit" then %><%=email%><% else %><% if session_login_name<>"" then %><%=session_email%><% else %><% if use_cookies=1 then %><%=Request.Cookies("inno")("email")%><% end if %><% end if %><% end if %>"></td>
</tr>
<tr>
	<td colspan="4" height="1" bgcolor="#999999"></td>
</tr>
<tr bgcolor="F7F7F7" height="25"> 
	<td width="92" align="right" bgcolor="#dbe7ed" class="form_title">HomePage&nbsp;</td>
	<td colspan="3" bgcolor="#FFFFFF"><input type="text" name="url" size="30" class="form_input" maxlength="240" value="http://<% if session_login_name = "" and mode="edit" then %><%=url%><% else %><% if session_login_name<>"" then %><%=session_url%><% else %><% if use_cookies=1 then %><%=Request.Cookies("inno")("url")%><% end if %><% end if %><% end if %>"></td>
</tr>
<tr>
	<td colspan="4" height="1" bgcolor="#999999"></td>
</tr>
<% else %>
<% if mode<>"edit" then %>
<input type="hidden" name="name" value="<%=session_login_name%>">
<input type="hidden" name="pin" value="<%=session_pin%>">
<input type="hidden" name="email" value="<%=session_email%>">
<input type="hidden" name="url" value="<%=session_url%>">
<% else %>
<input type="hidden" name="name" value="<%=name%>">
<input type="hidden" name="pin" value="<%=pin%>">
<input type="hidden" name="email" value="<%=email%>">
<input type="hidden" name="url" value="<%=url%>">
<% end if %><% end if %>
<% 
nw_level = session_level + 1 
%>
<tr bgcolor="F7F7F7" height="25"> 
	<td width="92" align="right" bgcolor="#f5f5f7" class="form_title"><b>Add function</b></td>
	<td colspan="3" bgcolor="#f5f5f7" class="form_title">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%if nw_level >= session_level then%>
	    <input type="checkbox" name="notice" value="1"<% if notice = 1 then %> checked<% end if%>>Announcement<% end if %>&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="tag" value="<% if content_type <> "1" then %><% if tag = 1 then %>1<% elseif tag = 2 then %>2<% else %>1<% end if %><% else %>1<% end if %>"<% if tag > 0 or (mode<>"edit" and content_type <> 0) then %> checked<% end if%> onClick="check_use_html(this)">Use HTML&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="secret" value="<% if secret = 1 then %>1<% elseif secret = 2 then %>2<% else %>1<% end if %>"<% if secret > 0 then %> checked<% end if%> onClick="secret_option(this)">Secret&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="reply_mail" value="1"<% if reply_mail = 1 then %> checked<% end if%>>Rcv.Msg.via email&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="link" value="1"<% if link <> "" then %> checked<% end if%> onClick="javascript:box()">Link</td>
</tr>
<tr>
	<td colspan="4" height="1" bgcolor="#999999"></td>
</tr>
<tr>
	<td colspan="4" height="1" bgcolor="#aac9da"></td>
</tr>
<tr bgcolor="F7F7F7" height="25" id="secret_option" style="display:<% if secret <> 1 then %>none<% end if%>"> 
	<td width="92" align="right" bgcolor="#dbe7ed" class="form_title">Password for reading &nbsp;</td>
	<td colspan="3" bgcolor="#FFFFFF" class="form_title"><input type="password" name="secret_pin" size="15" class="form_input" value="<%=secret_pin%>"></td>
</tr>
<tr id="secret_option1" style="display:<% if secret <> 1 then %>none<% end if%>">
	<td colspan="4" height="1" bgcolor="#999999"></td>
</tr>
<tr bgcolor="F7F7F7" height="25" id="link1" style="display:<% if link = "" then %>none<% end if%>"> 
	<td width="92" align="right" bgcolor="#dbe7ed" class="form_title">Link #1 &nbsp;</td>
	<td colspan="3" bgcolor="#FFFFFF"><input type="text" name="link_1" size="60" class="form_input" maxlength="240" value="<%=link_1%>"></td>
</tr>
<tr id="link11" style="display:<% if link = "" then %>none<% end if%>">
	<td colspan="4" height="1" bgcolor="#999999"></td>
</tr>
<tr bgcolor="F7F7F7" height="25" id="link2" style="display:<% if link = "" then %>none<% end if%>"> 
	<td width="92" align="right" bgcolor="#dbe7ed" class="form_title">Link #2 &nbsp;</td>
	<td colspan="3" bgcolor="#FFFFFF"><input type="text" name="link_2" size="60" class="form_input" maxlength="240" value="<%=link_2%>"></td>
</tr>
<tr id="link22" style="display:<% if link = "" then %>none<% end if%>">
	<td colspan="4" height="1" bgcolor="#999999"></td>
</tr>
<tr bgcolor="F7F7F7" height="25"> 
	<td width="92" align="right" bgcolor="#dbe7ed" class="form_title"><b><% if board_type = 3 then %>Memo Type<% else %>Title<% end if %> &nbsp;</b></td>
	<td colspan="3" valign="center" bgcolor="#dbe7ed" class="font1"> <% if board_type = 3 then %>
	    <input type="radio" name="title" value="diary_su"<% if mode="" or title="diary_su" then %> checked<% end if %> ID="Radio6"> <img src="../img/diary_su.gif"> &nbsp; &nbsp; <input type="radio" name="title" value="diary_sc"<% if title="diary_sc" then %> checked<% end if %> ID="Radio7"> <img src="../img/diary_sc.gif"> &nbsp; &nbsp; <input type="radio" name="title" value="diary_cl"<% if title="diary_cl" then %> checked<% end if %> ID="Radio8"> <img src="../img/diary_cl.gif"> &nbsp; &nbsp; <input type="radio" name="title" value="diary_ra"<% if title="diary_ra" then %> checked<% end if %> ID="Radio9"> <img src="../img/diary_ra.gif"> &nbsp; &nbsp; <input type="radio" name="title" value="diary_sn"<% if title="diary_sn" then %> checked<% end if %> ID="Radio10"> <img src="../img/diary_sn.gif"><% else %><input type="text" name="title" size="60" maxlength="240" class="form_input" value="<%=title%>" ID="Text2"><% end if %><% if content_type = "1" then %><input type=checkbox name="editmode" onClick="setEditMode('text');" id="directHTML">Write HTML<% else %><% if mode="reply" then %> &nbsp; &nbsp; <a href="javascript:box1()" style="text-align:center"><img src="../img/but_re_con.gif" border="0"></a><% end if %><% end if %></td>
</tr>

<% if mode="reply" and content_type <> "1" then %>
<tr id="re_content" style="display:none">
	<td colspan="4" height="1" bgcolor="#999999"></td>
</tr>
<tr id="re_content1" style="display:none">
	<td colspan="4" align="center" bgcolor="#f5f5f7"><br>
	    <textarea name="reply_content" cols="105" rows="12" class="form_textarea" readonly style="width:97%"><%=content%></textarea><br><br></td>
</tr>
<% end if %>
<tr>
	<td colspan="4" height="1" bgcolor="#999999"></td>
</tr>
<tr>
	<td colspan="4" align="center" bgcolor="F7F7F7"><% if content_type <> "1" then %><br><textarea name="content" cols="105" rows="12" class="form_textarea" style="width:97%"><% if mode = "edit" then %><%=content%><% end if %></textarea><br><br><% else %><script type="text/javascript">
AC_AX_RunContent( 'id','editBox','data','../web/Editor.asp','width','97%','height','235','type','text/x-scriptlet','viewastext','VIEWASTEXT' ); //end AC code
</script><noscript><OBJECT id="editBox" data="../web/Editor.asp" width="97%" height=235 type=text/x-scriptlet VIEWASTEXT></OBJECT></noscript><input type="hidden" name="content"><% end if %></td>
</tr>
<tr>
	<td colspan="4" height="1" bgcolor="#999999"></td>
</tr>
<% if board_type > 0 then %>
<%
	dim b_name
	
	if maxsize > 1000 then
		b_name = "M"
		maxsize = maxsize/1000
		maxsize = round(maxsize,1)
	else
		b_name = "K"
	end if
%>
<tr bgcolor="#F7F7F7" height="25">
	<td width="92" class="form_title" align="right">Attach File &nbsp;</td>
	<td colspan="3" align="left" valign="middle" class="smallcopy"><input type=file name="allfile1" size="80" class="form_input"> 
	    &nbsp; &nbsp; <span class="smallcopyitalic">Maximum file size:<%=maxsize%><%=b_name%></span></td>
</tr>
<% if mode = "edit" and filename1 <> "" then %>
<tr>
	<td colspan="4" class="font1" bgcolor="#F7F7F7" style="padding-left:30px;color:#999999;"><%=filename1%> is attached aready. <input type="checkbox" name="del_file1" value="1">Delete</td>
</tr>
<% end if %>
<tr>
	<td colspan="4" height="1" bgcolor="#999999"></td>
</tr>
<% if upload_form > 1 then %>
<tr bgcolor="#F7F7F7" height="25">
	<td width="92" class="form_title" align="right">Attached #2 &nbsp;</td>
	<td colspan="3" class="font1" valign="center"><input type=file name="allfile2" size="30" class="form_input"> &nbsp; &nbsp; <%=maxsize%><%=b_name%>Byte Limit</td>
</tr>
<% if mode = "edit" and filename2 <> "" then %>
<tr>
	<td colspan="4" class="font1" bgcolor="#F7F7F7" style="padding-left:30px;color:#999999;"><%=filename2%> is attached aready.<input type="checkbox" name="del_file2" value="1">Delete</td>
</tr>
<% end if %>
<tr>
	<td colspan="4" height="1" bgcolor="#999999"></td>
</tr>
<% end if %>
<% if upload_form > 2 then %>
<tr bgcolor="#F7F7F7" height="25">
	<td width="92" class="form_title" align="right">Attached #3 &nbsp;</td>
	<td colspan="3" class="font1" valign="center"><input type=file name="allfile3" size="30" class="form_input"> &nbsp; &nbsp; <%=maxsize%><%=b_name%>Byte limit</td>
</tr>
<% if mode = "edit" and filename3 <> "" then %>
<tr>
	<td colspan="4" class="font1" bgcolor="#F7F7F7" style="padding-left:30px;color:#999999;"><%=filename3%> is attached aready. <input type="checkbox" name="del_file3" value="1">Delete</td>
</tr>
<% end if %>
<tr>
	<td colspan="4" height="1" bgcolor="#999999"></td>
</tr>
<% end if %>
<% if upload_form > 3 then %>
<tr bgcolor="#F7F7F7" height="25">
	<td width="92" class="form_title" align="right">Attached #4 &nbsp;</td>
	<td colspan="3" class="font1" valign="center"><input type=file name="allfile4" size="30" class="form_input"> &nbsp; &nbsp; <%=maxsize%><%=b_name%>Byte Limit</td>
</tr>
<% if mode = "edit" and filename4 <> "" then %>
<tr>
	<td colspan="4" class="font1" bgcolor="#F7F7F7" style="padding-left:30px;color:#999999;"><%=filename4%> is attached aready. <input type="checkbox" name="del_file4" value="1">Delete</td>
</tr>
<% end if %>
<tr>
	<td colspan="4" height="1" bgcolor="#999999"></td>
</tr>
<% end if %>
<% end if %>
<tr>
	<td colspan="4">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
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
	</table>
	</td>
</tr>
<input type="hidden" name="tb" value="<%=tb%>">
<input type="hidden" name="num" value="<%=num%>">
<input type="hidden" name="page" value="<%=page%>">
<input type="hidden" name="mode" value="<%=mode%>">
<input type="hidden" name="st" value="<%=Request.QueryString("st")%>">
<input type="hidden" name="sc" value="<%=Request.QueryString("sc")%>">
<input type="hidden" name="sn" value="<%=Request.QueryString("sn")%>">
<input type="hidden" name="sw" value="<%=Request.QueryString("sw")%>">
<% if board_type > 0 and mode = "edit" then %>
<input type="hidden" name="oldfilename1" value="<%=filename1%>" ID="Hidden1">
<input type="hidden" name="oldfilesize1" value="<%=filesize1%>" ID="Hidden2">
<input type="hidden" name="oldfilename2" value="<%=filename2%>" ID="Hidden3">
<input type="hidden" name="oldfilesize2" value="<%=filesize2%>" ID="Hidden4">
<input type="hidden" name="oldfilename3" value="<%=filename3%>" ID="Hidden5">
<input type="hidden" name="oldfilesize3" value="<%=filesize3%>" ID="Hidden6">
<input type="hidden" name="oldfilename4" value="<%=filename4%>" ID="Hidden7">
<input type="hidden" name="oldfilesize4" value="<%=filesize4%>" ID="Hidden8">
<input type="hidden" name="i_w1" value="<%=rs("i_width1")%>" ID="Hidden9">
<input type="hidden" name="i_h1" value="<%=rs("i_height1")%>" ID="Hidden10">
<input type="hidden" name="i_w2" value="<%=rs("i_width2")%>" ID="Hidden11">
<input type="hidden" name="i_h2" value="<%=rs("i_height2")%>" ID="Hidden12">
<input type="hidden" name="i_w3" value="<%=rs("i_width3")%>" ID="Hidden13">
<input type="hidden" name="i_h3" value="<%=rs("i_height3")%>" ID="Hidden14">
<input type="hidden" name="i_w4" value="<%=rs("i_width4")%>" ID="Hidden15">
<input type="hidden" name="i_h4" value="<%=rs("i_height4")%>" ID="Hidden16">

<% end if %>
</form>
</table>

<table width="<%=board_size%>" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td align="right" style="word-break:break-all;padding:5px;"><a href="javascript:submit();"><img src="../img/but_<% if mode = "edit" then %>edit<% else %>save<% end if %>.gif" border="0"></a> <a href="javascript:reset();"><img src="../img/but_again.gif" border="0"></a><a href="javascript:cancel();"><img src="../img/but_cancel.gif" border="0"></a><br></td>
</tr>
</table>

<% if down_file<>"" then %><% server.execute(down_file)%><br><% end if %><%=bottom_board%>

</body>
</html>
<%
	If mode <> "" Then
	rs.close
	db.Close
	Set rs=nothing
	Set db=nothing
	end if
%>