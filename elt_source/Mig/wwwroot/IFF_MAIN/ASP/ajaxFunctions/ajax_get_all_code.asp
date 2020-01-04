<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/connection.asp" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/AspFunctions.inc" -->

<%  
Response.Expires = 0  
Response.AddHeader "Pragma","no-cache"  
Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
%>

<%
	if not check_url("IFF_MAIN") then 
		response.write "e"
		response.end
	end if
%>

<%
DIM code_type,elt_account_number,login_name,UserRight

elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
login_name = Request.Cookies("CurrentUserInfo")("login_name")
UserRight = Request.Cookies("CurrentUserInfo")("user_right")	

' On error Resume Next :
code_type = Request.QueryString("t")

if isnull(code_type) or code_type = "" then
	response.write "e"
else
	call gather_list( code_type )
end if
%>

<%
sub gather_list( sType )
		select case sType
			case "dba_name" 
				call gather_dba_all()
			case "class_code" 
				call gather_list_all("1")
			case "business_city" 
				call gather_list_all("2")
			case "business_state" 
				call gather_list_all("3")
			case "business_zip" 
				call gather_list_all("4")
			case "owner_mail_city" 
				call gather_list_all("2")
			case "owner_mail_state" 
				call gather_list_all("3")
			case "owner_mail_zip" 
				call gather_list_all("4")
'			case "business_country" 
'				call gather_list_all("5")'?
			case "SubConsignee" 
				call gather_list_all("11")
			case "SubShipper" 
				call gather_list_all("12")
			case "SubAgent" 
				call gather_list_all("13")
			case "SubCarrier" 
				call gather_list_all("14")
			case "SubTrucker" 
				call gather_list_all("15")
			case "SubWarehousing" 
				call gather_list_all("16")
			case "SubCFS" 
				call gather_list_all("17")
			case "SubBroker" 
				call gather_list_all("18")
			case "SubVendor" 
				call gather_list_all("19")
			case "SubCustomer" 
				call gather_list_all("24")	
			case "SubGovt" 
				call gather_list_all("20")
			case "SubSpecial" 
				call gather_list_all("21")
			case "salesperson" 
				call gather_list_all("22")
			case "refferedBy" 
				call gather_list_all("23")

		end select

end sub
%>

<% 
sub gather_dba_all()
DIM rs,SQL,i

response.write " <option></option><br>"

SQL = "select org_account_number,isnull(dba_name,'') as dba_name from organization where elt_account_number = " & elt_account_number  &" order by dba_name,class_code"
Set rs = eltConn.execute(SQL)

'On Error Resume Next:
	response.write " <option value='_edit' style='color:#cc6600; font-weight:bold'>EDIT LIST...</option>"
Do While Not rs.EOF and NOT rs.bof
	response.write " <option value='" & rs("org_account_number").value & "'>" & rs("dba_name").value & "</option><br>"
	rs.MoveNext
Loop
end sub
%>


<% 
sub gather_list_all(sType)
DIM rs,SQL,i
Dim code,codeText

response.write " <option></option><br>"

'SQL = "select code,isnull(description,'') as description,( isnull(code,'') + space(7-len(isnull(code,''))) + ' ' + isnull(description,'') ) as text from all_code where elt_account_number = " & elt_account_number & " AND  type="& sType &" order by code"
SQL = "select code,isnull(description,'') as description from all_code where elt_account_number = " & elt_account_number & " AND  type=" & sType & " order by code"
Set rs = eltConn.execute(SQL)

'On Error Resume Next:
	response.write " <option value='_edit' style='color:#cc6600; font-weight:bold'>EDIT LIST...</option>"
Do While Not rs.EOF and NOT rs.bof
	code = rs("code").value
	codeText = mid(rs("description").value,1,10)
'	response.write " <option value='" & code & "'>" & replace(rs("text").value," ","&nbsp;") & "</option><br>"
	response.write " <option value='" & code & "'>" & code & "</option><br>"
	rs.MoveNext
Loop
end sub
%>

<% 
function fill_space( s, spaceLen )
DIM i,tL,tmpS
tL = spaceLen - LEN(s)
tmpS = ""

if tL <= 0 then
	fill_space = ""
	exit function
end if

For i = 0  to tL
	tmpS = tmpS & "-"
Next

fill_space = tmpS
end function
%>
