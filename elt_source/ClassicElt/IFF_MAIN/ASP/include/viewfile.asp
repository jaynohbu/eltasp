<%@ LANGUAGE = VBScript %>
<!--  #INCLUDE FILE="connection.asp" -->
<!--  #INCLUDE FILE="header.asp" -->
<%
Dim Sql
Response.Clear()

FileName = Request.QueryString("FileName")
OrgNo=Request.QueryString("OrgNo")
	Set rs = Server.CreateObject("ADODB.Recordset")
	SQL= "select * from user_files where elt_account_number=" & elt_account_number & " and org_no=" & OrgNo & " and file_name='" & FileName & "'"
'response.write SQL	
	rs.Open SQL, eltConn, , , adCmdText
	If Not rs.EOF Then
	' Write out the headers identifying the file

		Response.AddHeader "content-disposition", "inline; filename=" & rs("file_name")
		Response.AddHeader "content-length", rs("file_content").ActualSize
		Response.ContentType = rs("file_type")

	' Write the file
		Response.BinaryWrite rs("file_content")
	Else
	' Notify the visitor of the problem
		Response.Write("File could not be found")
	End If
	rs.Close
	Set rs=Nothing
%>

