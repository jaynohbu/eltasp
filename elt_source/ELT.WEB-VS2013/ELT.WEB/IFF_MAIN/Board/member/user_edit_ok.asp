<% @Language = "VBScript" %>
<% Option Explicit %>
<% response.buffer = true %>

 



<!-- #include file="../inc/dbinfo.asp" -->
<!-- #include file="../inc/info_tb.asp" -->


<%

Dim num,id,pin,name,email,url,nickname,msg_tool,msg_id,jumin,birthday,zipcode,address,tel,phone,hobby,job,introduce,info_open,join_day,mailling,authority
dim o_email,o_url,o_nickname,o_msg,o_birthday,o_address,o_tel,o_phone,o_hobby,o_job,o_introduce


num = request.form("num")
pin = request.form("pin")
if pin = "" then
	pin = request.form("old_pin")
end if
name = request.form("name")
email = request.form("email")
url = request.form("url")
nickname = request.form("nickname")
msg_tool = request.form("msg_tool")
msg_id = request.form("msg_id")
birthday = request.form("b_year")&"-"&request.form("b_month")&"-"&request.form("b_day")&"-"&request.form("b_br")
zipcode = request.form("post1")&"-"&request.form("post2")
address = request.form("add1")&"#"&request.form("add2")
tel = request.form("tel1")&"-"&request.form("tel2")&"-"&request.form("tel3")
phone = request.form("phone1")&"-"&request.form("phone2")&"-"&request.form("phone3")
hobby = request.form("hobby")
job = request.form("job")
introduce = request.form("introduce")
authority = request.form("authority")
user_level = request.form("user_level")
mailling = request.form("mailling")
if mailling = "" then
	mailling=0
end if
info_open = request.form("info_open")
if info_open = "" then
	info_open=0
end if

o_email = request.form("o_email")
o_url = request.form("o_url")
o_nickname = request.form("o_nickname")
o_msg = request.form("o_msg")
o_birthday = request.form("o_birthday")
o_address = request.form("o_address")
o_tel = request.form("o_tel")
o_phone = request.form("o_phone")
o_hobby = request.form("o_hobby")
o_job = request.form("o_job")
o_introduce = request.form("o_introduce")

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

if left(url,7) = "http://" then
	url = mid(url,8)
end if

SQL = "Update member set email = '" & email & "'"
SQL = SQL & ", pin = '" & pin & "'"
SQL = SQL & ", url = '" & url & "'"
SQL = SQL & ", nickname = '" & nickname & "'"
SQL = SQL & ", msg_tool = '" & msg_tool & "'"
SQL = SQL & ", msg_id = '" & msg_id & "'"
SQL = SQL & ", birthday = '" & birthday & "'"
SQL = SQL & ", zipcode = '" & zipcode & "'"\
SQL = SQL & ", address = '" & address & "'"
SQL = SQL & ", tel = '" & tel & "'"
SQL = SQL & ", phone = '" & phone & "'"
SQL = SQL & ", hobby = '" & hobby & "'"
SQL = SQL & ", job = '" & job & "'"
SQL = SQL & ", introduce = '" & introduce & "'"
SQL = SQL & ", info_open = " & info_open & ""
SQL = SQL & ", user_level = " & user_level & ""
SQL = SQL & ", mailling = " & mailling & ""
SQL = SQL & ", o_email = " & o_email & ""
SQL = SQL & ", o_url = " & o_url & ""
SQL = SQL & ", o_nickname = " & o_nickname & ""
SQL = SQL & ", o_msg = " & o_msg & ""
SQL = SQL & ", o_birthday = " & o_birthday & ""
SQL = SQL & ", o_address = " & o_address & ""
SQL = SQL & ", o_tel = " & o_tel & ""
SQL = SQL & ", o_phone = " & o_phone & ""
SQL = SQL & ", o_hobby = " & o_hobby & ""
SQL = SQL & ", o_job = " & o_job & ""
SQL = SQL & ", o_introduce = " & o_introduce & ""
SQL = SQL & " where id='"&Request.Form("id")&"'"

db.execute SQL



db.Close
Set db=nothing
%>
<script language="JavaScript">
	alert("수정 되었습니다.");
	location.href="javascript:close()";
</script>