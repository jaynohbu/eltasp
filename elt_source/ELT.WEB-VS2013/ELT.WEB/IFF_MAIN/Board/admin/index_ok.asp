<% Option Explicit %>
<% response.buffer = true %>

 


<!-- #include file="../inc/dbinfo.asp" -->
<!-- #include file="../inc/info_tb.asp" -->
<!-- #include file="../inc/joint.asp" -->

<%
	if session_login_name <> "admin" then	Response.Redirect "../member/login.asp?h_url="&h_url
	
	dim mode,term_day
	
	
	
	mode = request("mode")
	
	if mode = "img_name" then
	
	
	
	img_name=request.Form("img_name")
	
	if img_name<>1 then
		img_name=0
	end if

	up_com=request.Form("up_com")
	
	if up_com<>1 then
		up_com=0
	end if
	
	SQL = "Update f_member set img_name = "& img_name &""
	SQL = SQL & ", up_com = "& up_com
	db.execute SQL
	
%>

<script language="JavaScript">
	alert("변경되었습니다.");
	location.href="../admin/index.asp";
</script>


<% elseif mode="term" then %>

<%

	dim id
	
	id = Request.Form("id")
	
	term_day = request.Form("t_time")
	
	if trim(term_day) <> "0" then
		yy = year(now)
		mm = right("0" & month(now),2)
		dd = right("0" & day(now),2)
		hh = right("0" & hour(now),2)
		mi = right("0" & minute(now),2)
		se = right("0" & second(now),2)
		term_day = yy & "-" & mm & "-" & dd & " " & hh & ":" & mi & ":" & se
	else
		term_day = ""
	end if
	

	SQL = "Update member set term_day = '"& term_day &"'"
	SQL = SQL & " where id = '" & id & "'"
	db.execute SQL
	
	SQL = "DELETE FROM inno_term where t_id = '" & id & "'"
	db.Execute SQL
	
		
%>
<script language="JavaScript">
	alert("갱신되었습니다..");
	location.href="../admin/index.asp";
</script>
<% end if %>
