<% @Language = "VBScript" %>
<% Option Explicit %>
<% response.buffer = true %>

 


<!-- #include file="../inc/dbinfo.asp" -->
<!-- #include file="../inc/info_tb.asp" -->

<% if session_login_name <> "admin" then Response.Redirect "../inc/error.asp?no=1" %>

<%
	dim f_level,f_term,f_nickname,f_msg,f_jumin,f_birthday,f_address,f_tel,f_phone,f_hobby,f_job,f_introduce,f_mailling,f_agreement,f_agreement_text
%>

<%
	
	f_level = request.form("f_level")
	if f_level = "" then
		f_level=0
	end if
	
	f_term = request.form("f_term")
	
	f_nickname = request.form("f_nickname")
	if f_nickname = "" then
		f_nickname=0
	end if
	
	f_msg = request.form("f_msg")
	if f_msg = "" then
		f_msg=0
	end if
	
	f_jumin = request.form("f_jumin")
	if f_jumin = "" then
		f_jumin=0
	end if
	f_birthday = request.form("f_birthday")
	if f_birthday = "" then
		f_birthday=0
	end if
	f_address = request.form("f_address")
	if f_address = "" then
		f_address=0
	end if
	f_tel = request.form("f_tel")
	if f_tel = "" then
		f_tel=0
	end if
	f_phone = request.form("f_phone")
	if f_phone = "" then
		f_phone=0
	end if
	f_hobby = request.form("f_hobby")
	if f_hobby = "" then
		f_hobby=0
	end if
	f_job = request.form("f_job")
	if f_job = "" then
		f_job=0
	end if
	f_introduce = request.form("f_introduce")
	if f_introduce = "" then
		f_introduce=0
	end if
	f_mailling = request.form("f_mailling")
	if f_mailling = "" then
		f_mailling=0
	end if
	f_agreement = request.form("f_agreement")
	if f_agreement = "" then
		f_agreement=0
	end if
	
	f_agreement_text = request.form("f_agreement_text")

	SQL = "Update f_member set f_level = "& f_level &""
	SQL = SQL & ", f_term = "& f_term &""
	SQL = SQL & ", f_nickname = "& f_nickname &""
	SQL = SQL & ", f_msg = "& f_msg &""
	SQL = SQL & ", f_jumin = "& f_jumin &""
	SQL = SQL & ", f_birthday = "& f_birthday &""
	SQL = SQL & ", f_address = "& f_address &""
    SQL = SQL & ", f_tel = "& f_tel &""
	SQL = SQL & ", f_phone = "& f_phone &""
	SQL = SQL & ", f_hobby = "& f_hobby &""
	SQL = SQL & ", f_job = "& f_job &""
	SQL = SQL & ", f_introduce = "& f_introduce &""
	SQL = SQL & ", f_mailling = "& f_mailling &""
	SQL = SQL & ", f_agreement = "& f_agreement &""
	SQL = SQL & ", f_agreement_text = '"& f_agreement_text &"'"
    db.execute SQL

	db.Close
	Set db=nothing

	'Response.Redirect "institute.asp"
%>

<script language="JavaScript">
	alert("변경 되었습니다.");
	location.href="institute.asp";
</script>