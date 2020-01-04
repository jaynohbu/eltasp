<%
Sub Print(x)
   Response.Write("<br>" & x)
End Sub

Dim elt_account_number,last_url,curr_url
Dim myServer
myServer=Request.ServerVariables("SERVER_NAME")
curr_url="http://" & myServer & Request.ServerVariables("PATH_INFO")
query_string=Request.ServerVariables("QUERY_STRING")
elt_account_number=Session("elt_account_number")
if elt_account_number="" then
	Response.Redirect("http://" & myServer & "/elt/aspscript/home/login.asp?" & curr_url & "?" & query_string)
end if
last_url=Request.ServerVariables("HTTP_REFERER")
pos=Instr(last_url,"?")
if pos>0 Then last_url=Left(last_url,pos-1)
Dim rs2,SQL2
Set rs2=Server.CreateObject("ADODB.Recordset")
UserRight=cInt(Session("user_right"))
AccessPage=Request.ServerVariables("PATH_INFO")
SQL2="select user_right,view_right from user_right where object_name='" & AccessPage & "'"
rs2.Open SQL2, eltConn, adOpenStatic, , adCmdText
if Not rs2.EOF then
	rt=cInt(rs2("user_right"))
	vrt=cInt(rs2("view_right"))
	if UserRight<rt and UserRight<vrt then
		ErrMsg="You don't have the privilege to access this page!"
		Response.Redirect("http://" & myServer & "/elt/aspscript/home/err_msg.asp?ErrMsg=" & ErrMsg)
	end if
else
	ErrMsg="You don't have the privilege to access this page!"
	Response.Redirect("http://" & myServer & "/elt/aspscript/home/err_msg.asp?ErrMsg=" & ErrMsg)
end if
rs2.Close
Set rs2=Nothing
'response.write("<br>" & AccessPage)

%>