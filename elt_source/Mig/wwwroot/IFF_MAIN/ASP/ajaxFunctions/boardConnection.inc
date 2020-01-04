<%
	 dim sql_ip,sql_db,sql_id,sql_pw,strconnect,db
	 sql_ip="NN1994"
	 sql_db="Board"
	 sql_id="sa"
	 sql_pw="dpV8XXVK"
	 
 	Dim cServerNameBoard

	cServerNameBoard = LCase(request.ServerVariables("SERVER_NAME"))
	

	strconnect = "Provider=SQLOLEDB.1;Persist Security Info=False;User ID="&sql_id&";Initial Catalog="&sql_db&";Data Source="&sql_ip&";Password="&sql_pw&""

	Set db=Server.CreateObject("ADODB.Connection") 
	if cServerNameBoard = "192.168.0.100" or cServerNameBoard = "192.168.1.114" or cServerNameBoard = "s-app01" or cServerNameBoard = "www.kasamerica.vn" or cServerNameBoard = "kasamerica.vn" then
		db.CursorLocation = adUseClient
	else
		db.CursorLocation = adUseServer
	end if

	db.Open strconnect
%>