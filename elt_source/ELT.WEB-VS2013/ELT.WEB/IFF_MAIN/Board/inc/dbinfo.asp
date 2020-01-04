<!-- #include virtual="/ASP/Include/connection.asp" -->

<%
	 dim sql_ip,sql_db,sql_id,sql_pw,strconnect,db
	 sql_ip="localhost"
	 sql_db="Board"
	 sql_id="sa"
	 sql_pw=""
	 
 	Dim cServerNameBoard

	cServerNameBoard = LCase(request.ServerVariables("SERVER_NAME"))
	sql_pw = "dpV8XXVK"	
	 strconnect = "Provider=SQLOLEDB;Persist Security Info=False;User ID="&sql_id&";Initial Catalog="&sql_db&";Data Source="&sql_ip&";Password="&sql_pw&""

	 Set db=Server.CreateObject("ADODB.Connection") 
	 db.Open strconnect

	 dim d_info,u_info,q_info,h_url
	 d_info = Request.ServerVariables("HTTP_HOST") 
	 u_info = Request.ServerVariables("PATH_INFO") 
	 q_info = Request.ServerVariables("QUERY_STRING")
	 h_url = "http://"&d_info&u_info&"?"&q_info

	if session_level = "" then
		session_level = 10
	end if

	Dim elt_account_number,session_login_name,session_lname,session_uid,session_email,session_ip,session_IntIp,session_server_name,session_id
	Dim session_admin,session_pin,session_url,session_level,session_company,redPage

	elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
	session_uid = elt_account_number & Request.Cookies("CurrentUserInfo")("user_id")
	session_company = Request.Cookies("CurrentUserInfo")("company_name")
	session_login_name = Request.Cookies("CurrentUserInfo")("login_name")

	session_ip = Request.Cookies("CurrentUserInfo")("IP")
	session_IntIp = Request.Cookies("CurrentUserInfo")("intIP")
	session_server_name = Request.Cookies("CurrentUserInfo")("Server_Name")
	session_id = Request.Cookies("CurrentUserInfo")("Session_ID")
	redPage = Request.Cookies("CurrentUserInfo")("ORIGINPAGE")

	If session_login_name="admin" then	
		If (elt_account_number = "80002000") Then
			session_admin = "admin"
		Else
			session_admin = ""
		End if
	End If
	session_pin = "-1"

	session_lname = Request.Cookies("CurrentUserInfo")("lname")
	session_email = Request.Cookies("CurrentUserInfo")("user_email")

%>

<%
	 Dim auto_update_view_login
	 auto_update_view_login = true
%>