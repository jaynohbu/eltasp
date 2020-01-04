<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/connection.asp" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/AspFunctions.inc" -->
<!--  #INCLUDE FILE="boardConnection.inc" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/GOOFY_util_fun.inc" -->
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
DIM elt_account_number,source,target,login_name,UserRight

source = Request.QueryString("src")
target = Request.QueryString("target")
if isnull(source) then source = ""
if isnull(target) then target = ""

if source = "" or target = "" then
	response.write "e"
	response.end
end if
elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
login_name = Request.Cookies("CurrentUserInfo")("login_name")
UserRight = Request.Cookies("CurrentUserInfo")("user_right")	

eltConn.BeginTrans
On Error Resume Next:

call transfer( elt_account_number, source, target )
call transfer( elt_account_number, target, target )

If eltConn.Errors.Count > 0 Then
    Dim vErrorMesssage, objErr
    vErrorMesssage = "Unexpected Error Occurred. Please, contact us if this problem persists"
    For Each objErr in eltConn.Errors
    vErrorMesssage = eltConn.Errors.Count & " error(s) found" & chr(13) _
        & "Description: " & RemoveQuotations(objErr.Description) & chr(13) _
        & "Error Source: " & RemoveQuotations(objErr.Source) & chr(13)
    Next   
    eltConn.RollbackTrans
    response.write vErrorMesssage
Else
    response.write "ok"
    eltConn.CommitTrans
End If

%>

