<% Option Explicit %>
<% response.buffer = true %>

 


<!-- #include file="../inc/dbinfo.asp" -->

<%

	'#############################
	dim sql1,rs1,user_id,user_name,updatesql,sql
	
	SQL1 = "SELECT * FROM view_login where ip='"&session_ip&"'" & " AND server_name='" & 	session_server_name & "'"
	Set rs1 = eltConn.execute (SQL1)
	
	if rs1.eof or rs1.bof then
		
	else
		UPDATESQL = "Update view_login Set alive = 0, user_id ='invalid',user_name='invalid',login_time='"&now&"',u_time='"&now&"' where ip='"&session_ip&"'" 
		eltConn.Execute UPDATESQL
	end if
	
	'#############################
	
'	session_uid = ""
'	session_pin = ""
'	session_login_name = ""
'	session_email = ""
'	session_url = ""
'	session_level = 10
'	session_admin = ""
	
'	Response.Cookies("a_login").expires = #12/31/2020 00:00:00#
'	Response.Cookies("a_login")("auto_login") = 0
'	Response.Cookies("a_login")("id") = ""
'	Response.Cookies("a_login")("pin") = ""	
	
	dim h_url1
	h_url = instr(q_info,"h_url=")
	h_url1 = len(q_info)
	h_url = h_url+5
	h_url = h_url1-h_url
	h_url = right(q_info,h_url)
	
	Response.Redirect h_url
	
%>
