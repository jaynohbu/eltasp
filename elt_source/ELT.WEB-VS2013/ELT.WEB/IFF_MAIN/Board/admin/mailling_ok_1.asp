<% 'Option Explicit %>
<% response.buffer = true %>

 



<!-- #include file="../inc/dbinfo.asp" -->
<!-- #include file="../inc/info_tb.asp" -->

<%
	


	email = Request.Form("email")
	toemail = Request.Form("toemail")
	subject = Request("title")
	mailBody = Request.Form("content")


	cart_num = Request.Form("toemail").count
					
	i=1
	Do until i > cart_num
		
	toemail = Request.Form("toemail")(i)
	
	Set objMail = Server.CreateObject("CDONTS.NewMail")
	objMail.Value("From") =  session_login_name & "<" & email & ">"
	objMail.To = toemail
	objMail.Subject = subject
	objMail.BodyFormat = 0
	objMail.MailFormat = 0
	objMail.Body = mailBody
	objMail.Send()
	
	Set objMail = Nothing	
	i=i+1
	loop

	

	
%>
<html>
<head>
<title><%=board_title%></title>

<LINK rel="stylesheet" type="text/css" href="../inc/style.css">
</head>
<body bgcolor="<%=bgcolor%>" topmargin="0" leftmargin="0" marginwidth="0" marginheight="0">

<div align="center">
<br><br>
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
	<td style="word-break:break-all;padding:10px;" align="center" bgcolor="#eeeeee">메일이 발송 되었습니다.</td>
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
	<td align="right" style="word-break:break-all;padding:5px;"><a href="<%=request.form("h_url")%>"><img src="../img/but_ok.gif" border="0"></a></td>
</tr>
</table><br>
</div>

</body>
</html>


