<% @Language = "VBScript" %>
<% Option Explicit %>
<% response.buffer = true %>

 



<!-- #include file="../inc/dbinfo.asp" -->
<!-- #include file="../inc/joint.asp" -->
<!-- #include file="../inc/info_tb.asp" -->



<% call f_member %>
<%
	dim sql1,rs1
	Dim id,name,email,url,nickname,msg_tool,msg_id,jumin,birthday,zipcode,address,tel,phone,hobby,job,introduce,info_open,join_day,mailling,authority,point,po_write,po_comment
	dim o_email,o_url,o_nickname,o_msg,o_birthday,o_address,o_tel,o_phone,o_hobby,o_job,o_introduce
	SQL1 = "SELECT elt_account_number, id,name,email,url,nickname,msg_tool,msg_id,birthday,zipcode,address,tel,phone,hobby,job,introduce,info_open,join_day,authority,user_level,mailling,point,po_write,po_comment,o_email,o_url,o_nickname,o_msg,o_birthday,o_address,o_tel,o_phone,o_hobby,o_job,o_introduce,jumin FROM member where elt_account_number=" & elt_account_number & "AND id='"&Request.QueryString("id")&"'"
    Set rs1 = db.execute (SQL1)
'response.write SQL1    
    id=rs1("id")
    name=rs1("name")
    email=rs1("email")
    url=rs1("url")
    nickname=rs1("nickname")
    msg_tool=rs1("msg_tool")
    msg_id=rs1("msg_id")
    birthday= split(rs1("birthday"),"-")
    zipcode=rs1("zipcode")
    address=split(rs1("address"),"#")
    tel=rs1("tel")
    phone=rs1("phone")
    hobby=rs1("hobby")
    job=rs1("job")
    introduce=rs1("introduce")
    info_open=rs1("info_open")
    join_day=rs1("join_day")
    authority=rs1("authority")
    user_level=rs1("user_level")
    mailling=rs1("mailling")
    point=rs1("point")
    po_write=rs1("po_write")
    po_comment=rs1("po_comment")
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
    jumin=rs1("jumin")
    if left(zipcode,1) = "-" then
		zipcode = ""
	end if
	   
    if left(tel,1) = "-" then
		tel = ""
	end if
	
	if left(phone,1) = "-" then
		phone = ""
	end if
	
	introduce = Replace(introduce, vbCrLf,"<br>")
	
	dim yy,h,mm,mi,dd

	yy= year(join_day)
    mm = right("0" & month(join_day),2)
    dd = right("0" & day(join_day),2)
    h = right("0" & hour(join_day),2)
    mi = right("0" & minute(join_day),2)
    join_day = mm & "/" & dd & "(" & h & ":" & mi & ")" & "/" & yy 

%>
<html>
<head>
<title><%=board_title%></title>

<LINK rel="stylesheet" type="text/css" href="../inc/style.css">

</head>
<body bgcolor="#FFFFFF" marginwidth="0" marginheight="0" leftmargin="0" topmargin="0">
<% 'if (session_uid = id ) or session_admin = "admin"  then %>
<img src="../img/join_view_title.gif" border="0">
<div align="center">

<table width="484" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td colspan="4" height="12">
	<table width=100% border=1 cellspacing=0 cellpadding=0 bgcolor=#EEEEEE bordercolorlight=gray bordercolordark=#FFFFFF ID="Table5">
	<tr>
		<td style=font-family:Arial;font-size:1pt;color:gray nowrap>&nbsp;</td>
	</tr>
	</table>	</td>
</tr>
<tr>
	<td width="100" align="right" class="form_title"><b>Company &nbsp;</b></td>
	<td colspan="3"><%=jumin%></td>
</tr>
<!-- 
<tr>
	<td colspan="4" height="12"><img src="../img/join_line.gif" border="0"></td>
</tr>
<tr>
	<td width="100" align="right" class="form_title"><b>ID &nbsp;</b></td>
	<td colspan="3"><%=id%></td>
</tr>
-->
<tr>
	<td colspan="4" height="12"><img src="../img/join_line.gif" border="0"></td>
</tr>
<tr>
	<td width="100" align="right" class="form_title"><b>Name &nbsp;</b></td>
	<td colspan="3"><%=nickname%></td>
</tr>
<tr>
	<td colspan="4" height="12"><img src="../img/join_line.gif" border="0"></td>
</tr>
<% if o_email = 1 then %>
<tr>
	<td width="100" align="right" class="form_title"><b>eMail &nbsp;</b></td>
	<td colspan="3"><%=email%></td>
</tr>
<tr>
	<td colspan="4" height="12"><img src="../img/join_line.gif" border="0"></td>
</tr>
<% end if %>
<% if o_url = 1 and url <> "" then %>
<tr>
	<td width="100" align="right" class="form_title">Homepage &nbsp;</td>
	<td colspan="3"><a href="http://<%=url%>" target="_blank">http://<%=url%></a></td>
</tr>
<tr>
	<td colspan="4" height="12"><img src="../img/join_line.gif" border="0"></td>
</tr>
<% end if %>
<% if o_nickname = 1 and nickname <> "" then %>

<tr>
	<td colspan="4" height="12"><img src="../img/join_line.gif" border="0"></td>
</tr>
<% end if %>
<% if o_msg = 1 and msg_id <> "" then %>
<tr>
	<td width="100" align="right" class="form_title">MSN Messenger &nbsp;</td>
	<td colspan="3"><b><%=msg_tool%></b> ID : <%=msg_id%></td>
</tr>
<tr>
	<td colspan="4" height="12"><img src="../img/join_line.gif" border="0"></td>
</tr>
<% end if %>

<tr>
	<td colspan="4" height="12">
	<table width=100% border=1 cellspacing=0 cellpadding=0 bgcolor=#EEEEEE bordercolorlight=gray bordercolordark=#FFFFFF ID="Table5">
	<tr>
		<td style=font-family:Arial;font-size:1pt;color:gray nowrap>&nbsp;</td>
	</tr>
	</table>	</td>
</tr>
<tr>
	<td colspan="4" align="right" style="word-break:break-all;padding:10px;"><a href="javascript:close();"><img src="../img/but_join_ok.gif" border="0"></a></td>
</tr>
</table>
</div>
<% 'end if %>
</body>
</html>

<%
	rs1.close
	db.Close
	Set rs1=nothing
	Set db=nothing
%>
