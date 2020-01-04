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
DIM elt_account_number,vMawb

vMawb = Request.QueryString("MAWB")
if isnull(vMawb) then vMawb = ""

elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")

if vMawb <> "" then
	call get_mawb_info( vMawb )
end If
	response.End

%>

<%
Sub get_mawb_info( vMawb )
    
	Dim rs_mawb,SQL
    Dim vAvalue    
    SET rs_mawb = Server.CreateObject("ADODB.Recordset")    
	
	SQL = "SELECT * FROM import_mawb where elt_account_number='"& elt_account_number & "' and mawb_num=N'"&vMawb&"'"
	
	rs_mawb.CursorLocation = adUseClient
	rs_mawb.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs_mawb.activeConnection = Nothing

	if not rs_mawb.eof then         
		vAvalue=rs_mawb("file_no")&"^"&rs_mawb("flt_no")&"^"&rs_mawb("it_entry_port")&"^"&rs_mawb("it_number")&"^"&rs_mawb("it_date")&"^"&rs_mawb("last_free_date")&"^"&_
		rs_mawb("voyage_no")&"^"&rs_mawb("Sub_mawb")&"^"&rs_mawb("cargo_location")&"^"&rs_mawb("etd")&"^"&rs_mawb("eta")&"^"&rs_mawb("dep_port")&"^"&rs_mawb("arr_port")&_
		"^"&rs_mawb("dep_code")&"^"&rs_mawb("arr_code")&"^"&rs_mawb("agent_org_acct")&"^"&rs_mawb("sec")                     
	End If
	
	rs_mawb.Close
	response.write vAvalue
End sub
%>
