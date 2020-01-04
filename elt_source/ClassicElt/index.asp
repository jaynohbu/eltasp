<%
	Dim cServerName
	cServerName = LCase(request.ServerVariables("SERVER_NAME"))
   
	If InStr(LCase(cServerName),"e-logitech")>0 Then
		Response.Redirect("/freighteasy/index.aspx")
	ElseIf InStr(LCase(cServerName),"freighteasy")>0 Then
		Response.Redirect("/freighteasy/index.aspx")
	ElseIf InStr(LCase(cServerName),"aeseasy")>0 Then
		Response.Redirect("/EXP_MAIN/Default.aspx")
    ELSE
        Response.Redirect("/freighteasy/index.aspx")
	End If
%>