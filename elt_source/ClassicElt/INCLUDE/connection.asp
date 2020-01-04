<!--  METADATA TYPE="typelib" FILE="C:\Program Files\Common Files\System\ado\msado15.dll" -->

<%
	Dim eltConn
	Set eltConn = Server.CreateObject("ADODB.Connection")
	strConn = "Provider=SQLOLEDB; Data Source=localhost; Initial Catalog=devdb; User ID=sa; Password=njy*8824"
	eltConn.CursorLocation = adUseServer
	eltConn.Open strConn
%>