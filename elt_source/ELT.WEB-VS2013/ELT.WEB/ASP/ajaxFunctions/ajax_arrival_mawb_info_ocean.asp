<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE VIRTUAL="/ASP/include/connection.asp" -->
<!--  #INCLUDE VIRTUAL="/ASP/include/AspFunctions.inc" -->
<!--  #INCLUDE VIRTUAL="/ASP/include/JSON_2.0.4.asp"-->
<!--  #INCLUDE VIRTUAL="/ASP/include/JSON_UTIL_0.1.1.asp"-->
<%  
Response.Expires = 0  
Response.AddHeader "Pragma","no-cache"  
Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
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
         Dim  jsa, col
        Set jsa = jsArray()
        While not rs_mawb.eof
                Set jsa(Null) = jsObject()
                For Each col In rs_mawb.Fields
                        jsa(Null)(col.Name) = col.Value
                Next
        rs_mawb.MoveNext
        Wend
        jsa.Flush


		'vAvalue=rs_mawb("file_no")&"^"&rs_mawb("flt_no")&"^"&rs_mawb("it_entry_port")&"^"&rs_mawb("it_number")&"^"&rs_mawb("it_date")&"^"&rs_mawb("last_free_date")&"^"&_
		'rs_mawb("voyage_no")&"^"&rs_mawb("Sub_mawb")&"^"&rs_mawb("cargo_location")&"^"&rs_mawb("etd")&"^"&rs_mawb("eta")&"^"&rs_mawb("dep_port")&"^"&rs_mawb("arr_port")&_
		'"^"&rs_mawb("dep_code")&"^"&rs_mawb("arr_code")&"^"&rs_mawb("agent_org_acct")&"^"&rs_mawb("sec")                     
	End If
	
	rs_mawb.Close

End sub
%>
