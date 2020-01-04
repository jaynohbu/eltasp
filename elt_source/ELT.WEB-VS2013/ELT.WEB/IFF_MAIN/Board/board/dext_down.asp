<%@ Language=VBScript %>
<%
	Option Explicit
	Response.Buffer = False
	 
	Dim user_agent
	Dim content_disp
	Dim contenttype
	 
	Dim filepath
	Dim filename
	Dim objFS
	Dim objF
	Dim objDownload

%>
 


<!-- #include file="../inc/dbinfo.asp" -->

<%

	
	
	dim tb,num,mode,down,updatesql,file
	dim sql,rs

	tb=Request.QueryString("tb")
	num=Request.QueryString("num")
	mode=Request.QueryString("mode")
	down=Request.QueryString("down")
		
	if down = 1 then
		UpdateSQL = "Update "&tb&" Set down1 = down1+1 where num = " & num
		db.Execute UpdateSQL

		SQL = "Select filename1 from "&tb&" where num="&num
	elseif down = 2 then
		UpdateSQL = "Update "&tb&" Set down2 = down2+1 where num = " & num
		db.Execute UpdateSQL

		SQL = "Select filename2 from "&tb&" where num="&num
	elseif down = 3 then
		UpdateSQL = "Update "&tb&" Set down3 = down3+1 where num = " & num
		db.Execute UpdateSQL

		SQL = "Select filename3 from "&tb&" where num="&num
	elseif down = 4 then
		UpdateSQL = "Update "&tb&" Set down4 = down4+1 where num = " & num
		db.Execute UpdateSQL

		SQL = "Select filename4 from "&tb&" where num="&num
	end if
	
	Set rs=Db.Execute(SQL)
	file = rs(0)
	rs.close
	Set rs = Nothing
	
%>

<% 
	user_agent = Request.ServerVariables("HTTP_USER_AGENT")
	If InStr(user_agent, "MSIE") > 0 Then
	    'IE 5.0인 경우.
	    If InStr(user_agent, "MSIE 5.0") > 0 Then
	        content_disp = "inline;filename="
	        contenttype = "application/x-msdownload"
	    'IE 5.0이 아닌 경우.
	    Else
	        content_disp = "inline;filename="
	        contenttype = "application/unknown"
	    End If
	Else
	    'Netscape등 기타 브라우저인 경우.
	    content_disp = "attachment;filename="
	    contenttype = "application/unknown"
	End If
	 
	filepath = Server.MapPath("..")&"\files\"&tb&"\"& file
	 
	Response.AddHeader "Content-Disposition", content_disp & file
	set objFS = Server.CreateObject("Scripting.FileSystemObject")
	set objF = objFS.GetFile(filepath)
	Response.AddHeader "Content-Length", objF.Size
	set objF = nothing
	set objFS = nothing
	Response.ContentType = contenttype
	Response.CacheControl = "public"
	 
	Set objDownload = Server.CreateObject("DEXT.FileDownload")
	objDownload.Download filepath
	Set objDownload = Nothing

	Db.Close
	Set Db=Nothing
%>