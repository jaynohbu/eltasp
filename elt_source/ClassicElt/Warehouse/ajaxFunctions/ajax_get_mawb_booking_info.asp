<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/transaction.txt" -->
<% Option Explicit %>
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/connection.asp" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/AspFunctions.inc" -->
<%  
Response.Expires = 0  
Response.AddHeader "Pragma","no-cache"  
Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
Response.CharSet = "utf-8"
%>

<%
	if not check_url("IFF_MAIN") then 
		response.write "e"
		response.end
	end if
%>

<%
DIM elt_account_number,vMawb

vMawb = Request.QueryString("MAWB")
if isnull(vMawb) then vMawb = ""

if vMawb = ""  then
	response.end
end If

elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
call get_mawb_info( vMawb )
%>
<%
Sub get_mawb_info( MAWB )
if MAWB = "" then Exit sub
%>
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/ajaxFunctions/mawb_number_info.inc" -->
<%
	response.write mawbInfo
End sub
%>

