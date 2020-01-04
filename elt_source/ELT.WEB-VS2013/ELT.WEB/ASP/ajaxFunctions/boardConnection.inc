<%
	 dim sql_ip,sql_db,sql_id,sql_pw,strconnect,db
	 sql_ip="localhost"
	 sql_db="Board"
	 sql_id="sa"
	 sql_pw="dpV8XXVK"
	 
 	Dim cServerNameBoard

	cServerNameBoard = LCase(request.ServerVariables("SERVER_NAME"))
	

	strconnect = "Provider=SQLOLEDB;Persist Security Info=False;User ID="&sql_id&";Initial Catalog="&sql_db&";Data Source="&sql_ip&";Password="&sql_pw&""

	Set db=Server.CreateObject("ADODB.Connection") 
	db.CursorLocation = adUseServer
	

	db.Open strconnect
%>