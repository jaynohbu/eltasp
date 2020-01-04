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
		response.end
	end if

    DIM elt_account_number,login_name,UserRight
    Dim PostBack,Action,vMAWB	

	elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
	login_name = Request.Cookies("CurrentUserInfo")("login_name")
	UserRight = Request.Cookies("CurrentUserInfo")("user_right")	

	call get_queryString
	if( vMAWB <> "") then
		close_mawb(vMAWB)
	end if
	
	eltConn.Close
	Set eltConn = Nothing

    sub close_mawb(vMAWB)
        DIM rs,SQL
	    Set rs = Server.CreateObject("ADODB.Recordset")
	    SQL= "select * from mawb_number where elt_account_number = " _
	        & elt_account_number & " and mawb_no=N'" & vMAWB & "'"
	    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	    if not rs.EOF then
		    rs("Status")="C"
	    end if
	    rs.Update
	    rs.close
	    set rs = nothing
	    response.write "ok"
    end sub

    sub get_queryString
	    elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
	    login_name = Request.Cookies("CurrentUserInfo")("login_name")
	    UserRight = Request.Cookies("CurrentUserInfo")("user_right")	
	    vMAWB = Request.QueryString("n")
	    if isnull(vMAWB) then vMAWB = ""
    end sub 
%>
