<!-- #include file="dbinfo.asp" -->
<%
dim strServerName,strIP
dim sql

On Error Resume Next
if NOT Session("sessionSaved") = "yes" then
	Session("sessionSaved") = "yes"
	strServerName = Request.queryString("a") & ":" & Request.queryString("b")
	strIP = strServerName + "@" + Request.ServerVariables("REMOTE_ADDR")

	SQL = "INSERT INTO iff_statistics (s_date,s_week,s_user_agent,s_referer,ip) VALUES "
	SQL = SQL + "(getdate()"
	SQL = SQL + ",'" & weekday(now) & "'"
	SQL = SQL + ",'" & Request.ServerVariables("HTTP_USER_AGENT") & "'"
	SQL = SQL + ",'" & Request.ServerVariables("HTTP_REFERER") & "'"
	SQL = SQL + ",'" &strIP & "')"
	db.Execute SQL
end if
%>
