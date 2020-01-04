<% 'Option Explicit %>
<% response.buffer = true %>

 



<!-- #include file="../inc/dbinfo.asp" -->
<!-- #include file="../inc/info_tb.asp" -->

<%
Set objMail = Server.CreateObject("CDONTS.NewMail")

dim page,num,sw,st,sc,sn,name,email,toemail,subject,mailbody

email = Request.Form("email")
toemail = Request.Form("toemail")
subject = Request("title")
mailBody = Request.Form("content")

objMail.Value("From") = email
objMail.To = toemail
objMail.Subject = subject

objMail.Body = mailBody
objMail.Send()
Set objMail = Nothing
%>
<html>
<head>
<title><%=board_title%></title>

<LINK rel="stylesheet" type="text/css" href="../inc/style.css">
</head>
<body bgcolor="<%=bgcolor%>" topmargin="0" leftmargin="0" marginwidth="0" marginheight="0">
<% if top_file<>"" then %><% server.execute(top_file)%><br><% end if %><%=top_board%>

<table width="300" border="0" cellpadding="0" cellspacing="0">
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
	<td style="word-break:break-all;padding:10px;" align="center" bgcolor="#eeeeee">eMail was sent!</td>
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
</table>

<table width="300" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td align="right" style="word-break:break-all;padding:5px;"><a href="<%=request.Form("h_url")%>"><img src="../img/but_ok.gif" border="0"></a></td>
</tr>
</table>

<% if down_file<>"" then %><% server.execute(down_file)%><br><% end if %><%=bottom_board%>
</body>
</html>


