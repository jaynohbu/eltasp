<% @Language = "VBScript" %>
<% Option Explicit %>
<% response.buffer = true %>


<!-- #include file="../inc/dbinfo.asp" -->


<%

Dim num,id,pin,name,email,url,nickname,msg_tool,msg_id,jumin,birthday,zipcode,address,tel,phone,hobby,job,introduce,info_open,join_day,term_day,mailling,authority,user_level,b_admin
dim o_email,o_url,o_nickname,o_msg,o_birthday,o_address,o_tel,o_phone,o_hobby,o_job,o_introduce

authority = request.form("authority")
id = request.form("id")

	SQL="SELECT id FROM member where elt_account_number=" & elt_account_number & "AND id='"&id&"'"
	Set rs = db.Execute(SQL)
	
	if not(rs.BOF or rs.EOF) then Response.Redirect "../inc/error.asp?no=5"
	
pin = request.form("pin")
name = request.form("name")
email = request.form("email")
	
	SQL="SELECT email FROM member where elt_account_number=" & elt_account_number & "AND email='"&email&"'"
	Set rs = db.Execute(SQL)
	
	if not(rs.BOF or rs.EOF) then Response.Redirect "../inc/error.asp?no=6"
	
o_email = request.form("o_email")
url = request.form("url")
o_url = request.form("o_url")
nickname = request.form("nickname")
o_nickname = request.form("o_nickname")
msg_tool = request.form("msg_tool")
msg_id = request.form("msg_id")
o_msg = request.form("o_msg")
jumin = request.form("jumin1")&"-"&request.form("jumin2")

if Request.Form("f_jumin") = 1 then
	SQL="SELECT jumin FROM member where elt_account_number=" & elt_account_number & "AND jumin='"&jumin&"'"
	Set rs = db.Execute(SQL)
	
	if not(rs.BOF or rs.EOF) then Response.Redirect "../inc/error.asp?no=7"
end if

birthday = request.form("b_year")&"-"&request.form("b_month")&"-"&request.form("b_day")&"-"&request.form("b_br")
o_birthday = request.form("o_birthday")
zipcode = request.form("post1")&"-"&request.form("post2")
address = request.form("add1")&"#"&request.form("add2")
o_address = request.form("o_address")
tel = request.form("tel1")&"-"&request.form("tel2")&"-"&request.form("tel3")
o_tel = request.form("o_tel")
phone = request.form("phone1")&"-"&request.form("phone2")&"-"&request.form("phone3")
o_phone = request.form("o_phone")
hobby = request.form("hobby")
o_hobby = request.form("o_hobby")
job = request.form("job")
o_job = request.form("o_job")
introduce = request.form("introduce")
o_introduce = request.form("o_introduce")
mailling = request.form("mailling")
info_open = request.form("info_open")


if left(url,7) = "http://" then
	url = mid(url,8)
end if

'if left(now,2) <> "20" then
'	join_day = "20"&now
'else
	join_day = now
'end if

dim sql_f,rs_f,f_term
SQL_f = "SELECT f_term FROM f_member"
Set rs_f = db.execute (SQL_f)

f_term = rs_f("f_term")

if f_term<>"0" then
'	if left(now,2) <> "20" then
'		term_day = "20"&DateAdd("m",f_term,now)
'	else
		term_day = DateAdd("m",f_term,now)
'	end if
	
else
	term_day = ""
end if


if f_term < 0 then
	dim sql_term
	
	SQL_term = "INSERT INTO inno_term (t_id,t_time,t_writeday) VALUES "
	SQL_term = SQL_term & "('" & id & "'"
	SQL_term = SQL_term & ",'" & f_term & "'"
	SQL_term = SQL_term & ",'" & now & "')"
	db.Execute SQL_term
end if

rs_f.close
set rs_f=nothing

	
dim sql,rs
	
SQL="SELECT MAX(num) FROM member elt_account_number=" & elt_account_number 
Set rs = db.Execute(SQL)

if IsNULL(rs(0)) then
	num = 1
else
	num = rs(0)+1
end if

b_admin=""

if id="admin" then
	authority = 1
end if

if info_open<>"" then
	info_open=1
else
	info_open=0
end if

if mailling<>"" then
	mailling=1
else
	mailling=0
end if

if o_email<>"" then
	o_email=1
else
	o_email=0
end if

if o_url<>"" then
	o_url=1
else
	o_url=0
end if

if o_nickname<>"" then
	o_nickname=1
else
	o_nickname=0
end if

if o_msg<>"" then
	o_msg=1
else
	o_msg=0
end if

if o_birthday<>"" then
	o_birthday=1
else
	o_birthday=0
end if

if o_address<>"" then
	o_address=1
else
	o_address=0
end if

if o_tel<>"" then
	o_tel=1
else
	o_tel=0
end if

if o_phone<>"" then
	o_phone=1
else
	o_phone=0
end if

if o_hobby<>"" then
	o_hobby=1
else
	o_hobby=0
end if

if o_job<>"" then
	o_job=1
else
	o_job=0
end if

if o_introduce<>"" then
	o_introduce=1
else
	o_introduce=0
end if

	SQL = "INSERT INTO member (num,elt_account_number,id,pin,name,email,url,jumin,nickname,msg_tool,msg_id,birthday,zipcode,address,tel,phone,hobby,job,introduce,mailling,info_open,join_day,term_day,authority,user_level,o_email,o_url,o_nickname,o_msg,o_birthday,o_address,o_tel,o_phone,o_hobby,o_job,o_introduce,po_write,po_comment,point,name_img,b_admin) VALUES "
	SQL = SQL & "(" & num & ""
	SQL = SQL & ",'" & session_elt_account_number & "'"
	SQL = SQL & ",'" & id & "'"
	SQL = SQL & ",'" & pin & "'"
	SQL = SQL & ",'" & name & "'"
	SQL = SQL & ",'" & email & "'"
	SQL = SQL & ",'" & url & "'"
	SQL = SQL & ",'" & jumin & "'"
	SQL = SQL & ",'" & nickname & "'"
	SQL = SQL & ",'" & msg_tool & "'"
	SQL = SQL & ",'" & msg_id & "'"
	SQL = SQL & ",'" & birthday & "'"
	SQL = SQL & ",'" & zipcode & "'"
	SQL = SQL & ",'" & address & "'"
	SQL = SQL & ",'" & tel & "'"
	SQL = SQL & ",'" & phone & "'"
	SQL = SQL & ",'" & hobby & "'"
	SQL = SQL & ",'" & job & "'"
	SQL = SQL & ",'" & introduce & "'"
	SQL = SQL & "," & mailling & ""
	SQL = SQL & "," & info_open & ""
	SQL = SQL & ",'" & join_day & "'"
	SQL = SQL & ",'" & term_day & "'"
	SQL = SQL & "," & authority & ""
	SQL = SQL & "," & authority & ""
	SQL = SQL & "," & o_email & ""
	SQL = SQL & "," & o_url & ""
	SQL = SQL & "," & o_nickname & ""
	SQL = SQL & "," & o_msg & ""
	SQL = SQL & "," & o_birthday & ""
	SQL = SQL & "," & o_address & ""
	SQL = SQL & "," & o_tel & ""
	SQL = SQL & "," & o_phone & ""
	SQL = SQL & "," & o_hobby & ""
	SQL = SQL & "," & o_job & ""
	SQL = SQL & "," & o_introduce & ""
	SQL = SQL & "," & 0 & ""
	SQL = SQL & "," & 0 & ""
	SQL = SQL & "," & 0 & ""
	SQL = SQL & "," & 0 & ""
	SQL = SQL & ",'" & b_admin & "')"
	db.Execute SQL


	rs.close
	db.Close
	Set rs=nothing
	Set db=nothing

%>
<% if id="admin" then %>
	<script language=javascript>
		self.close();
		window.opener.location = '../member/login_ok.asp?join_id=<%=id%>&join_pin=<%=pin%>&term=1&h_url=../admin/index.asp';
	</script>
<% else %>
	<% if session_admin = "admin" then %>
		<script language=javascript>
			self.close();
			window.opener.location = '../member/user_list.asp?page=<%=Request.Form("page")%>&pagesize=<%=Request.Form("pagesize")%>';
		</script>
	<% elseif Request.Form("h_url") <> "" then %>
		<script language=javascript>
			self.close();
			window.opener.location = '../member/login_ok.asp?join_id=<%=id%>&join_pin=<%=pin%>&term=1&h_url=<%=Request.Form("h_url")%>';
		</script>
		
	<% end if %>
<% end if %>
