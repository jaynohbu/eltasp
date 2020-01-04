<% Option Explicit %>
<% response.buffer = true %>

 



<!-- #include file="../inc/dbinfo.asp" -->
<!-- #include file="../inc/info_tb.asp" -->
<% if session_login_name <> "admin" then Response.Redirect "../inc/error.asp?no=1" %>

<%
	dim sql2,sql3
	dim folder_url,folder,fs
	tb=Request.QueryString("tb")
	
	SQL = "DROP table "&tb
	db.Execute SQL

	SQL2 = "DELETE FROM inno_admin where tb = '"&tb&"'"
	db.Execute SQL2
	
	SQL3 = "DELETE FROM inno_comment where tb = '"&tb&"'"
	db.Execute SQL3
	
	
	folder_url = Request("PATH_TRANSLATED")
	folder_url = left(folder_url, InStrRev(folder_url, "\admin\")) & "files\"
	folder = folder_url&tb
	
	set fs=server.CreateObject("scripting.filesystemobject")
	fs.DeleteFolder folder,true

	Response.Redirect "tb_list.asp"
	
%>
