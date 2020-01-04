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

	if not check_url("IFF_MAIN") then 
		response.write "e"
		eltConn.Close
		Set eltConn = Nothing
		response.end
	end if

    DIM elt_account_number,vMawb

    vMawb = Request.QueryString("MAWB")
    if isnull(vMawb) then vMawb = ""

    if vMawb = ""  then
        eltConn.Close
		Set eltConn = Nothing
	    
    end If

    elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
    call get_mawb_info( vMawb )
    
    eltConn.Close
    Set eltConn = Nothing
    response.end
    
    Sub get_mawb_info( MAWB )
        if MAWB = "" then Exit sub
%>
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/ajaxFunctions/mawb_number_info.inc" -->
<%
	    response.write mawbInfo
    End sub

%>

