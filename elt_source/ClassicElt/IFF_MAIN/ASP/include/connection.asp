
<!--  METADATA TYPE="typelib" FILE="C:\Program Files\Common Files\System\ado\msado15.dll" -->

<%


	Session.LCID = 1033
	Dim eltConn

	Dim cServerName,cServerPort,strConn,MailHost
    MailHost = "localhost"
	cServerName = LCase(request.ServerVariables("SERVER_NAME"))
	cServerPort = request.ServerVariables("SERVER_PORT")
    strConn = "Provider=SQLOLEDB; Data Source=localhost; Initial Catalog=PRDDB; User ID=sa; Password=dpV8XXVK"
  '  response.Write(cServerName)
  '  response.End()
	
	
	Set eltConn = Server.CreateObject("ADODB.Connection")
	eltConn.CursorLocation = adUseServer
	

	eltConn.Open strConn

%>
