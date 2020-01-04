<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/connection.asp" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/AspFunctions.inc" -->
<!--  #INCLUDE FILE="boardConnection.inc" -->

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
DIM elt_account_number,login_name,UserRight,vOrgAcct,vType

vOrgAcct = Request.QueryString("a")
vType = Request.QueryString("t")
if isnull(vOrgAcct) then vOrgAcct = ""
if isnull(vType) then vType = ""

' On error Resume Next :
elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
login_name = Request.Cookies("CurrentUserInfo")("login_name")
UserRight = Request.Cookies("CurrentUserInfo")("user_right")	
call session_valid_ajax("client_profile")

if vOrgAcct = "" or vType = "" then
	response.write "e"
else
		select case vType
			case "contact"
				call check_contact( vOrgAcct ) 	
			case "remarks"
				call check_remarks( vOrgAcct ) 	
		end select
end if
%>
<%
sub check_remarks( vOrgAcct )
DIM rs,SQL
SQL = "select TOP 1 * from remarks where elt_account_number = " & elt_account_number & " and org_account_number ="&vOrgAcct
Set rs = db.execute (SQL)
if Not rs.EOF then
	response.write "Y"
else
	response.write ""
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
	response.write "Y"
else
	response.write ""
end if
rs.Close	 
set rs = nothing
end sub
%>
