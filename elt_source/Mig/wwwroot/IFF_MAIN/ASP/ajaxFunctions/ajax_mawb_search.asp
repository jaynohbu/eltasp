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
    Dim PostBack,Action,vJobNo

	elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
	login_name = Request.Cookies("CurrentUserInfo")("login_name")
	UserRight = Request.Cookies("CurrentUserInfo")("user_right")	

	call get_queryString
	if( vJobNo <> "") then
		search_mawb(vJobNo)
	end if
	
	eltConn.Close
	Set eltConn = Nothing

    sub search_mawb(vJobNo)
	    DIM rs,SQL
	    vJobNo = replace(vJobNo,"-","")
	    vJobNo = trim(vJobNo)
	    vJobNo = UCASE(vJobNo)
	    Set rs = Server.CreateObject("ADODB.Recordset")
	    SQL= "select mawb_no from mawb_number where elt_account_number = " _
	        & elt_account_number & " and upper(replace([file#],'-',''))=N'" & vJobNo & "'"
	    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	    if not rs.EOF then
		    response.write rs("mawb_no")
	    else
		    response.write "no"
	    end if
	    rs.close
	    set rs = nothing
    end sub

    sub get_queryString
	    elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
	    login_name = Request.Cookies("CurrentUserInfo")("login_name")
	    UserRight = Request.Cookies("CurrentUserInfo")("user_right")	
	    vJobNo = Request.QueryString("j")
	    if isnull(vJobNo) then vJobNo = ""
    end sub 
%>
