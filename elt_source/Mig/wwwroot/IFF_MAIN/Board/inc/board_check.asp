<%
DIM clast_url,cpos1
clast_url=Request.ServerVariables("HTTP_REFERER")

cpos1=Instr(clast_url,request.serverVariables("HTTP_HOST"))

	if (cpos1 < 1) then 
			session_uid = ""
			session_pin = ""
			session_login_name = ""
			session_email = ""
			session_url = ""
			session_level = 10
			session_admin = ""		
	end if

%>

