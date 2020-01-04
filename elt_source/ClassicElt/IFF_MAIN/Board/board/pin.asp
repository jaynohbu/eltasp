<% 'Option Explicit %>
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
function submit_ok()
{

	if (document.inno.form_pin.value =="") {
		alert("Please enter the password");
		document.inno.form_pin.focus();
		return;
	}
	
	var letters = 'ghijklabvwxyzABCDEFef)_+|<>?:mnQRSTU~!@#$%^VWXYZ`1234567opGHIJKLu./;'+"'"+'[]MNOP890-='+'\\'+'&*("{},cdqrst'+"\n";
	var split = letters.split("");var num = '';var c = '';
	var encrypted = '';
	var it = document.inno.form_pin.value;
	var b = '0';var chars = it.split("");while(b<it.length){c = '0';while(c<letters.length){if(split[c] == chars[b]){if(c == "0") { c = ""; }if(eval(c+10) >= letters.length){num = eval(10-(letters.length-c));encrypted += split[num];}else{num = eval(c+10);encrypted += split[num];}}c++;}b++;}document.inno.form_pin.value = encrypted;encrypted = '';
	
	document.inno.submit();

}
//-->
</script>
</head>
<body bgcolor="<%=bgcolor%>" marginwidth="0" marginheight="0" leftmargin="0" topmargin="0" onload="document.inno.form_pin.focus();">

<% if top_file<>"" then %><% server.execute(top_file)%><br><% end if %><%=top_board%>


<%
	num = Request.QueryString("num")
	mode = Request.QueryString("mode")
	sw = Request.QueryString("sw")
		
	Select Case mode
		Case "edit"
			url = "form.asp?num="&num&"&"
			msg = "Now <font color=red><b>Updating</b></font> this content."
		Case "del"
			url = "del_ok.asp?num="&num&"&"
			msg = "Now <font color=red><b>Deleting</b></font>this content"
		Case "com_del"
			url = "memo_ok.asp?com_id="&Request.QueryString("com_id")&"&"
			msg = "Now <font color=red><b>Deleteing</b></font>this memo."
		Case "secret"
			url = "view.asp?num="&num&"&"
			msg = "This content is a <font color=red><b>secret </b></font> text."
		End Select
%>

<%
	if mode = "com_del" then
		h_url = request("h_url")
		
		dim h_url1
			
		h_url = instr(q_info,"h_url=")
		h_url1 = len(q_info)
		h_url = h_url+5
		h_url = h_url1-h_url
		h_url = right(q_info,h_url)
	end if
%>
<table width="300" border="0" cellpadding="0" cellspacing="0">
<form name="inno" method="POST" action="<%=url%>tb=<%=Request.QueryString("tb")%>&page=<%=Request.QueryString("page")%>&mode=<%=mode%><% if request("mode1") <> "" then %>&mode1=<%=request("mode1")%><% end if %><% if sw<>"" then %>&st=<%=Request.QueryString("st")%>&sc=<%=Request.QueryString("sc")%>&sn=<%=Request.QueryString("sn")%>&sw=<%=Request.QueryString("sw")%><% end if %><% if mode="com_del" then %>&h_url=<%=h_url%><% end if %>" onsubmit = "return submit_ok();">
<tr>
	<td>
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

<tr> 
	<td style="word-break:break-all;padding:10px;" align="center" bgcolor="#eeeeee"><%=msg%><br>Please enter the password.<br><br>
	<input type="password" name="form_pin" size="15" class="form_input">	<a href="javascript:submit_ok();"><img src="../img/but_ok.gif" border="0"></a> <a href="javascript:history.back();"><img src="../img/but_cancel.gif" border="0"></a>
	</td>
</tr>
<tr>
	<td>
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
</form>
</table>
<% if down_file<>"" then %><% server.execute(down_file)%><br><% end if %><%=bottom_board%>

</body>
</html>