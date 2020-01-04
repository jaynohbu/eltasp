
<!--  METADATA TYPE="typelib" FILE="C:\Program Files\Common Files\System\ado\msado15.dll" -->

<%
	Session.LCID = 1033
	Dim eltConn

	Dim cServerName,cServerPort,strConn,MailHost

	cServerName = LCase(request.ServerVariables("SERVER_NAME"))
	cServerPort = request.ServerVariables("SERVER_PORT")
    strConn = "Provider=SQLOLEDB; Data Source=.; Initial Catalog=PRODDB; User ID=sa; Password=dpV8XXVK"
	
	
	Set eltConn = Server.CreateObject("ADODB.Connection")
	eltConn.CursorLocation = adUseServer
	

	eltConn.Open strConn

%>
