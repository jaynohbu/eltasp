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
 

<!-- #include virtual="/IFF_MAIN/Board/inc/dbinfo.asp" -->

<%

	dim tb,num,mode,down,updatesql,file
	dim sql,rs

	tb=Request.QueryString("tb")
	num=Request.QueryString("num")
	mode=Request.QueryString("mode")
	down=Request.QueryString("down")
	if down = 1 then
		UpdateSQL = "Update "&tb&" Set down1 = down1+1 where elt_account_number = " & elt_account_number & " and org_account_number="&session("vOrgNum") & " and num = " & num
		db.Execute UpdateSQL

		SQL = "Select filename1 from "&tb&" where elt_account_number = " & elt_account_number & " and org_account_number="&session("vOrgNum") & " and num="&num
	elseif down = 2 then
		UpdateSQL = "Update "&tb&" Set down2 = down2+1 where elt_account_number = " & elt_account_number & " and org_account_number="&session("vOrgNum") & " and num = " & num

		db.Execute UpdateSQL

		SQL = "Select filename2 from "&tb&" where elt_account_number = " & elt_account_number & " and org_account_number="&session("vOrgNum") & " and num="&num
	elseif down = 3 then
		UpdateSQL = "Update "&tb&" Set down3 = down3+1 where elt_account_number = " & elt_account_number & " and org_account_number="&session("vOrgNum") & " and num = " & num
		db.Execute UpdateSQL

		SQL = "Select filename3 from "&tb&" where elt_account_number = " & elt_account_number & " and org_account_number="&session("vOrgNum") & " and num="&num
	elseif down = 4 then
		UpdateSQL = "Update "&tb&" Set down4 = down4+1 where elt_account_number = " & elt_account_number & " and org_account_number="&session("vOrgNum") & " and num = " & num
		db.Execute UpdateSQL

		SQL = "Select filename4 from "&tb&" where elt_account_number = " & elt_account_number & " and org_account_number="&session("vOrgNum") & " and num="&num
	end if
	Set rs=Db.Execute(SQL)
	file = rs(0)
	filename = file
	rs.close
	Set rs = Nothing
	
%>

<%
	dim temp_path,vDest
	temp_path = UCase(Server.MapPath("../../temp"))
	vDest=temp_path & "\Eltdata\" & elt_account_number & "\" & session("vOrgNum")
%>

<% 
	
	filepath = vDest &   "\" & filename
	'Response.AddHeader "Content-Disposition", content_disp & filename
	Response.AddHeader "Content-Disposition", "attachment; filename="""  & filename & """"
	Response.ContentType = contenttype
	Response.CacheControl = "public"
	 
	dim objstream,download
	
	Set objStream = Server.CreateObject("ADODB.Stream")
    objStream.Open

    objStream.Type = 1
	objStream.LoadFromFile filepath

    download = objStream.Read
    Response.BinaryWrite download

	Set objstream = nothing
	Db.Close
	Set Db=Nothing
	response.end

%>