<%

	 dim sql_ip,sql_db,sql_id,sql_pw,strconnect,db

	 sql_ip="127.0.0.1"
	 sql_db="myTest"
	 sql_id="sa"
	 sql_pw=""

	 strconnect = "Provider=SQLOLEDB; Data Source=NN1994; Initial Catalog=PRDDB; User ID=sa; Password=dpV8XXVK"
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

%>

