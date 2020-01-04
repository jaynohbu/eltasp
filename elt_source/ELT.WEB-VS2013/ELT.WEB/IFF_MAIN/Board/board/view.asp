<% Option Explicit %>
<% response.buffer = true %>

 



<!-- #include file="../inc/dbinfo.asp" -->
<!-- #include file="../inc/info_tb.asp" -->
<!-- #include file="../inc/board_check.asp" -->

<%
	if r_level < session_level then Response.Redirect "../inc/error.asp?no=4&h_url="&h_url
%>


<%
	
	dim page,num,mode,form_pin
	tb = Request.QueryString("tb")
	page = Request.QueryString("page")
	num = Request.QueryString("num")
	mode = Request.QueryString("mode")
	form_pin = Request.Form("form_pin")
	
	if session_admin="admin" then
		session("read") = "ok"
	else
		session("read") = ""
	end if  
	
	if mode = "secret" then
		
		if form_pin = ""  then Response.Redirect "pin.asp?tb="&tb&"&page="&page&"&num="&num&"&mode=secret"
		
		SQL="SELECT secret from "&tb&" where num="&num&" and (secret_pin='"& form_pin &"' or pin='"& form_pin &"')"
		Set rs = db.Execute(SQL)
	
		if rs.eof or rs.bof then Response.Redirect "../inc/error.asp?no=2"
		
		session("read") = rs(0)
		
		
	end if
	
	if mode = "reco" then
		SQL = "Update "&tb&" set reco=reco+1 where num="&num
		db.execute SQL
	else
		SQL = "Update "&tb&" set visit=visit+1 where num="&num
		db.execute SQL
		
		if session_login_name <> "" then		'### 회원이 있을때는 ###
		
			SQL = "SELECT r_point FROM f_member"	'### 포인트 관리의 글읽을때의 포인트를 불러와서 ###
			Set rs = db.execute (SQL)
    
			SQL = "Update member set point=point+"&rs(0)&" where id='"&session_login_name&"'"	'### 해당 회원 id 를 가진 포인트에 글읽을때의 포인트를 적용시킨다.
			db.execute SQL
			
			
		end if
	end if 
	
	

	db.close
	Set db = Nothing
	
	if Request.QueryString("sw") <> "" then
		if board_type=3 then
			Response.Redirect "digital_diary_c.asp?tb="&tb&"&page="&page&"&num="&num&"&st="&Request.QueryString("st")&"&sc="&Request.QueryString("sc")&"&sn="&Request.QueryString("sn")&"&sw="&Request.QueryString("sw")
		else
			Response.Redirect "content.asp?tb="&tb&"&page="&page&"&num="&num&"&st="&Request.QueryString("st")&"&sc="&Request.QueryString("sc")&"&sn="&Request.QueryString("sn")&"&sw="&Request.QueryString("sw")
		end if
	else
		if board_type=3 then
			Response.Redirect "digital_diary_c.asp?tb="&tb&"&page="&page&"&num="&num
		else
			Response.Redirect "content.asp?tb="&tb&"&page="&page&"&num="&num
		end if 
	end if
%>
