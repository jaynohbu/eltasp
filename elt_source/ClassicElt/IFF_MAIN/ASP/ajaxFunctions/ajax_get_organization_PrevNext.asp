<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/connection.asp" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/AspFunctions.inc" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/GOOFY_Util_Ver_2.inc" -->
<!--  #INCLUDE FILE="boardConnection.inc" -->

<%  
    Response.Expires = 0  
    Response.AddHeader "Pragma","no-cache"  
    Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
    Response.ContentType = "text/xml"
    Response.CharSet = "utf-8"

	if not check_url("IFF_MAIN") then 
		response.write "e"
		response.end
	end if

    DIM elt_account_number,login_name,UserRight,vDbaName,vOrgAcct,vCodeList
    Dim Action,vFilter

    Action = Request.QueryString("Action")
    vFilter = Request.QueryString("f")
    vDbaName = Request.QueryString("s")
    vOrgAcct = Request.QueryString("o")
    vCodeList = Request.QueryString("c")
    if isnull(vFilter) then vFilter = ""
    if isnull(vCodeList) then vCodeList = ""

    elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
    login_name = Request.Cookies("CurrentUserInfo")("login_name")
    UserRight = Request.Cookies("CurrentUserInfo")("user_right")	
    call session_valid_ajax("client_profile")

    if isnull(Action) or Action = "" then
	    response.write "e"
    else
		    select case Action
			    case "getByOrg"
				     vCodeList = vFilter & ":"
				     call filter_one_org( vCodeList ) 	
				     vDbaName = get_first_dba()
				     call load_client( vDbaName )				 
			    case "filter" 
				     call filter_one_org( vCodeList ) 	
				     vDbaName = get_first_dba()
				     call load_client( vDbaName )				 
			    case "thisOrg" 
				     call load_client_org( vOrgAcct )				 
			    case "this" 
				     vFilter = ""
				     if vDbaName = "" then
					     vDbaName = get_first_dba()
				     end if
				     call load_client( vDbaName )				 
			    case "first" 
				     vDbaName = get_first_dba()
				     call load_client( vDbaName )				 
			    case "prev" 
				     vDbaName = get_prev_dba( vDbaName )
				     call load_client( vDbaName )				 
			    case "next" 
 				     vDbaName = get_next_dba( vDbaName )
				     call load_client( vDbaName )				 
			    case "last" 
 				     vDbaName = get_last_dba()
				     call load_client( vDbaName )				 
		    end select

    end if
    
    eltConn.Close
    Set eltConn = Nothing
%>

<%
sub filter_one_org( vCodeList )

DIM tmpArray,tmpStr,allCnt

tmpArray = Split(vCodeList,":")
allCnt = ubound(tmpArray)
if allCnt = 0 then 
		response.write "e"
		response.end
end if

vOrgAcct = tmpArray(0)
vDbaName = ""
vFilter = vCodeList
end sub
%>
<%
sub load_client_by_org( vFilter )
DIM rs,SQL,i

DIM lessCnt,allCnt,tmpArray,tmpStr

tmpArray = Split(vFilter,":")
allCnt = ubound(tmpArray)

if allCnt = 0 then exit sub
if allCnt = 1 then 
	SQL = "select isnull(count(org_account_number),0) as Cnt from organization where elt_account_number = " & elt_account_number 
	
	Set rs = eltConn.execute (SQL)
	if Not rs.EOF then
		allCnt = rs("Cnt")
	end if
	rs.Close	 
	lessCnt = get_less_cnt("","",tmpStr,vOrgAcct)
else
	lessCnt = 1
end if

response.write "<?xml version=""1.0"" encoding=""utf-8""?>"
response.write "<organization>"

response.write "<item>"&"<itemcode>lessOrGreaterTop</itemcode>"&"<itemdesc>" & lessCnt & " of " & allCnt & "</itemdesc>"&"</item>"
response.write "<item>"&"<itemcode>lessOrGreaterBottom</itemcode>"&"<itemdesc>" & lessCnt & " of " & allCnt & "</itemdesc>"&"</item>"

SQL = "select * from organization where elt_account_number = " & elt_account_number & " and org_account_number ="&tmpArray(0)&""

Set rs = eltConn.execute (SQL)
if Not rs.EOF then
	for i = 0 to rs.fields.count - 1
		response.write "<item>"
		response.write "<itemcode>"
		response.write rs(i).name
		response.write "</itemcode>"
		response.write "<itemdesc>" 
		response.write Server.HTMLEncode(ConvertAnyValue(rs(i).value,"String",""))
		response.write "</itemdesc>"
		response.write "</item>"
	next 
end if
rs.Close	 

call check_remarks(tmpArray(0))

set rs = nothing
response.write "</organization>"
end sub
%>

<% 
function get_less_cnt(dba,vFilter,org_list,vOrgAcct)
DIM lessCnt
DIM rs,SQL,iCnt

iCnt = get_dupe_dba_cnt(dba,vFilter,org_list,"<>")

lessCnt = 0
SQL = "select ( isnull(count(org_account_number),0) ) as Cnt from organization where elt_account_number = " & elt_account_number

if vFilter <> "" then
	SQL =  SQL & " and org_account_number in " & org_list
end if

if Trim(vOrgAcct) <> "" and iCnt > 1 then
	if vFilter <> "" then
		SQL =  SQL & " and org_account_number < " & vOrgAcct
		SQL =  SQL & " AND dba_name <= N'" & dba & "'"
	else
		SQL = ""
		SQL = "SELECT ( "
		SQL =  SQL &"	SELECT ( isnull(count(org_account_number),0) + 1 ) from organization where elt_account_number = "
		SQL =  SQL & elt_account_number 
		SQL =  SQL & " AND ( org_account_number <> " & vOrgAcct & " AND dba_name <= N'" & dba & "'" & ") ) - ( "
		SQL =  SQL &"	SELECT ( isnull(count(org_account_number),0)) from organization where elt_account_number = "
		SQL =  SQL & elt_account_number 
		SQL =  SQL & " AND ( org_account_number > " & vOrgAcct & " AND dba_name = N'" & dba & "'" & ") )  as Cnt "
	end if
else
	SQL =  SQL & " AND dba_name < N'" & dba & "'"
end if

Set rs = eltConn.execute (SQL)
if Not rs.EOF then
	if Trim(vOrgAcct) <> "" and iCnt > 1 and vFilter = "" then
		lessCnt = rs("Cnt")
	else
		lessCnt = rs("Cnt") + 1
	end if
end if
rs.Close	 

set rs = nothing
get_less_cnt = lessCnt
end function
%>
<%
sub load_client( s )
Dim tmpS
DIM rs,SQL,i

DIM lessCnt,allCnt,tmpStr
tmpS = Replace(s,"'","''")
tmpStr = get_filter_string(vFilter)

'On Error Resume Next :
if vFilter <> "" then
	DIM tmpArray
	tmpArray = Split(vFilter,":")
	allCnt = ubound(tmpArray)	
	if allCnt = 1 then
		vFilter = ""
		tmpStr=""
	end if
end if

lessCnt = get_less_cnt(tmpS,vFilter,tmpStr,vOrgAcct)
allcnt = get_all_cnt( tmpStr ) 

response.write "<?xml version=""1.0"" encoding=""utf-8""?>"
response.write "<organization>"

response.write "<item>"&"<itemcode>lessOrGreaterTop</itemcode>"&"<itemdesc>" & lessCnt & " of " & allCnt & "</itemdesc>"&"</item>"
response.write "<item>"&"<itemcode>lessOrGreaterBottom</itemcode>"&"<itemdesc>" & lessCnt & " of " & allCnt & "</itemdesc>"&"</item>"

SQL = "select * from organization where elt_account_number = " & elt_account_number & " and org_account_number =" & vOrgAcct

Set rs = eltConn.execute (SQL)

if Not rs.EOF then
	for i = 0 to rs.fields.count - 1
		response.write "<item>"
		response.write "<itemcode>"
		response.write rs(i).name
		response.write "</itemcode>"
		response.write "<itemdesc>" 
		response.write Server.HTMLEncode(ConvertAnyValue(rs(i).value,"String",""))
		response.write "</itemdesc>"
		response.write "</item>"
	next 
end if
rs.Close	 
set rs = nothing

call check_remarks(vOrgAcct)
call check_contact(vOrgAcct)

response.write "</organization>"
end sub
%>
<%
sub load_client_org( o )
DIM rs,SQL,i


response.write "<?xml version=""1.0"" encoding=""utf-8""?>"
response.write "<organization>"

SQL = "select * from organization where elt_account_number = " & elt_account_number & " and org_account_number =" & o

Set rs = eltConn.execute (SQL)
if Not rs.EOF then
	for i = 0 to rs.fields.count - 1
		response.write "<item>"
		response.write "<itemcode>"
		response.write rs(i).name
		response.write "</itemcode>"
		response.write "<itemdesc>" 
		response.write Server.HTMLEncode(ConvertAnyValue(rs(i).value,"String",""))
		response.write "</itemdesc>"
		response.write "</item>"
	next 
end if
rs.Close	 
set rs = nothing
response.write "</organization>"
end sub
%>

<%
sub check_remarks( vOrgAcct )
DIM rs,SQL
SQL = "select TOP 1 * from remarks where elt_account_number = " & elt_account_number & " and org_account_number ="&vOrgAcct

Set rs = db.execute (SQL)
if Not rs.EOF then
	response.write "<item><itemcode>add_remarks</itemcode><itemdesc>Y</itemdesc></item>"
else
	response.write "<item><itemcode>add_remarks</itemcode><itemdesc></itemdesc></item>"
end if
rs.Close	 
set rs = nothing
end sub
%>
<%
sub check_contact( vOrgAcct )
DIM rs,SQL
SQL = "select TOP 1 * from ig_org_contact where elt_account_number = " & elt_account_number & " and org_account_number ="&vOrgAcct

Set rs = eltConn.execute (SQL)
if Not rs.EOF then
	response.write "<item><itemcode>add_contact</itemcode><itemdesc>Y</itemdesc></item>"
else
	response.write "<item><itemcode>add_contact</itemcode><itemdesc></itemdesc></item>"
end if
rs.Close	 
set rs = nothing
end sub
%>
<%
function get_filter_string(vFilter)
DIM tmpArray,tmpStr,allCnt,i
vFilter = trim(vFilter)
if vFilter <> "" then
	tmpArray = Split(vFilter,":")
	allCnt = ubound(tmpArray)	
	for i = 0 to allCnt 
		if ( tmpArray(i) <> "") then
			tmpStr = tmpStr & "" & tmpArray(i) & ","
		end if
	next
	tmpStr = "(" & tmpStr & ")"
	tmpStr = replace(tmpStr, ",)",")")
end if
get_filter_string = tmpStr
end function
%>

<% 
function get_prev_dba( dba )
DIM prev_dba
DIM rs,SQL
DIM tmpStr,iCnt

	tmpStr = get_filter_string(vFilter)

	dba = Replace(dba,"'","''")
	prev_dba = ""

	if 	dba = "" then
		dba = get_first_dba()
		prev_dba = dba
	else

		iCnt = get_dupe_dba_cnt(dba,vFilter,tmpStr,"LE")

		SQL = "select TOP 1 dba_name,org_account_number from organization where elt_account_number = " & elt_account_number 

		if Trim(vFilter) <> "" then
			SQL =  SQL & " and org_account_number in " & tmpStr
		end if

		if Trim(vOrgAcct) <> "" and iCnt > 1 then
			SQL =  SQL & " AND ((org_account_number < " & vOrgAcct
			SQL =  SQL & " AND dba_name <= N'" & dba & "') "
			SQL =  SQL & " OR ( org_account_number <> " & vOrgAcct
			SQL =  SQL & " AND dba_name < N'" & dba & "'))"
		else
			SQL =  SQL & " AND dba_name < N'" & dba & "'"
		end if

		SQL =  SQL & " order by dba_name DESC,org_account_number  DESC"
        
		Set rs = eltConn.execute (SQL)
		if NOT rs.eof and NOT rs.bof then
			prev_dba = rs("dba_name")
			vOrgAcct = rs("org_account_number")
		end if
		rs.Close	
		
		if prev_dba = "" then
			prev_dba = get_last_dba()
		end if
	end if
	get_prev_dba = prev_dba		
end function
%>
<% 
function get_next_dba( dba )
DIM next_dba
DIM rs,SQL
DIM tmpStr,iCnt

tmpStr = get_filter_string(vFilter)

	dba = Replace(dba,"'","''")
	next_dba = ""

	if 	dba = "" then
		dba = get_first_dba()
		next_dba = dba
	else
		iCnt = get_dupe_dba_cnt(dba,vFilter,tmpStr,"GR")
		SQL = "select TOP 1 dba_name,org_account_number from organization where elt_account_number = " & elt_account_number 

		if Trim(vFilter) <> "" then
			SQL =  SQL & " and org_account_number in " & tmpStr
		end if
		if Trim(vOrgAcct) <> "" and iCnt > 1 then
			SQL =  SQL & " AND ((org_account_number > " & vOrgAcct
			SQL =  SQL & " AND dba_name >= N'" & dba & "') "
			SQL =  SQL & " OR ( org_account_number <> " & vOrgAcct
			SQL =  SQL & " AND dba_name > N'" & dba & "'))"
		else
			SQL =  SQL & " AND dba_name > N'" & dba & "'"
		end if

		SQL =  SQL & " order by dba_name,org_account_number"
		
		Set rs = eltConn.execute (SQL)
		if NOT rs.eof and NOT rs.bof then
			next_dba = rs("dba_name")
			vOrgAcct = rs("org_account_number")
		else
			if Trim(vOrgAcct) <> "" and iCnt > 1 then '// Table has same dba_name and user select them for work area.
				rs.Close	
				SQL = "select TOP 1 dba_name,org_account_number from organization where elt_account_number = " & elt_account_number 
				if Trim(vFilter) <> "" then
					SQL =  SQL & " and org_account_number in " & tmpStr
				end if
				SQL =  SQL & " AND ((org_account_number < " & vOrgAcct
				SQL =  SQL & " AND dba_name <= N'" & dba & "') "
				SQL =  SQL & " OR ( org_account_number <> " & vOrgAcct
				SQL =  SQL & " AND dba_name > N'" & dba & "'))"
				SQL =  SQL & " order by dba_name,org_account_number"
				
				Set rs = eltConn.execute (SQL)
				if NOT rs.eof and NOT rs.bof then
					next_dba = rs("dba_name")
					vOrgAcct = rs("org_account_number")
				end if
			end if
		end if
		rs.Close	

		if next_dba = "" then
			next_dba = get_first_dba()
		end if
	end if
	get_next_dba = next_dba	
end function
%>
<%
function get_dupe_dba_cnt(dba,vFilter,tmpStr,order)
DIM iCnt
DIM rs,SQL

iCnt = 1
SQL = "select  isnull(count(dba_name),0) as Cnt from organization where elt_account_number = " & elt_account_number 
if Trim(vFilter) <> "" then
	SQL =  SQL & " and org_account_number in " & tmpStr
end if
		select case order
			case "GR" 
				SQL =  SQL & " AND dba_name = N'" & dba & "'"
			case "LE" 
				SQL =  SQL & " AND dba_name = N'" & dba & "'"				
			case "<>" 
				SQL =  SQL & " AND dba_name = N'" & dba & "'"				
		end select

Set rs = eltConn.execute (SQL)

if Not rs.EOF then
	iCnt = rs("Cnt")
end if
rs.Close
get_dupe_dba_cnt = iCnt

end function
%>
<%
function get_first_dba()
DIM first_dba
DIM rs,SQL

DIM lessCnt,allCnt,tmpStr
tmpStr = get_filter_string(vFilter)

first_dba = ""

	SQL = "select TOP 1 dba_name,org_account_number from organization where elt_account_number = " & elt_account_number 

	if vFilter <> "" then
		SQL =  SQL & " and org_account_number in " & tmpStr
	end if

	SQL =  SQL & " order by dba_name"
    
	Set rs = eltConn.execute (SQL)

	if NOT rs.eof and NOT rs.bof then
		first_dba = rs("dba_name")
		vOrgAcct = rs("org_account_number")
	end if
	rs.Close	

	get_first_dba = first_dba	

end function
%>
<%
function get_last_dba()
DIM last_dba
DIM rs,SQL

DIM lessCnt,allCnt,tmpStr
tmpStr = get_filter_string(vFilter)

last_dba = ""

	SQL = "select TOP 1 dba_name,org_account_number from organization where elt_account_number = " & elt_account_number 

	if vFilter <> "" then
		SQL =  SQL & " and org_account_number in " & tmpStr
	end if

	SQL =  SQL & " order by dba_name desc"
    
	Set rs = eltConn.execute (SQL)

	if NOT rs.eof and NOT rs.bof then
		last_dba = rs("dba_name")
		vOrgAcct = rs("org_account_number")
	end if
	rs.Close	

	get_last_dba = last_dba	

end function
%>
<%
function get_all_cnt( tmpStr )
DIM rs,SQL,iCnt
	iCnt = 1
	SQL = "select isnull(count(org_account_number),0) as Cnt from organization where elt_account_number = " & elt_account_number 
	if tmpStr <> "" then
		SQL =  SQL & " and org_account_number in " & tmpStr
	end if
    
	Set rs = eltConn.execute (SQL)
	if Not rs.EOF then
		iCnt = rs("Cnt")
	end if
	rs.Close	 
	get_all_cnt = 	iCnt
end function
%>
