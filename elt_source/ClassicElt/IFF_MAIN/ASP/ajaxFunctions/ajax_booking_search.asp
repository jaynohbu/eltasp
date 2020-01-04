<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/transaction.txt" -->
<% Option Explicit %>
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/connection.asp" -->
<%  
    Response.Expires = 0  
    Response.AddHeader "Pragma","no-cache"  
    Response.AddHeader "Cache-Control","no-cache,must-revalidate"  

    DIM elt_account_number,login_name,UserRight
    Dim PostBack,Action,vJobNo

	elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
	login_name = Request.Cookies("CurrentUserInfo")("login_name")
	UserRight = Request.Cookies("CurrentUserInfo")("user_right")	

	call get_queryString
	if( vJobNo <> "") then
		search_booking_num(vJobNo)
	end if

    sub search_booking_num(vJobNo)
	    DIM rs,SQL
	    vJobNo = replace(vJobNo,"-","")
	    vJobNo = trim(vJobNo)
	    vJobNo = UCASE(vJobNo)
	    Set rs = Server.CreateObject("ADODB.Recordset")
	    SQL= "select booking_num,file_no from ocean_booking_number where elt_account_number = " & elt_account_number & " and upper(replace([file_no],'-',''))='" & vJobNo & "'"
	    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	    if not rs.EOF then
		    response.write rs("booking_num")
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
