<!--  #INCLUDE FILE="transaction.txt" -->
<%
    Option Explicit
    Response.Charset = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE VIRTUAL="/ASP/include/connection.asp" -->

<%  
    Response.Expires = 0  
    Response.AddHeader "Pragma","no-cache"  
    Response.AddHeader "Cache-Control","no-cache,must-revalidate"  

    DIM rs,SQL,dType,dNum, rNum,elt_acc
    
	On error Resume Next :
	dType = Request.QueryString("dType")
	dNum = Request.QueryString("n")
	elt_acc = Request.QueryString("e")
	
		select case dType
			case "MAWB" 
			SQL = "select TOP 1 invoice_no as num from invoice where elt_account_number =" _
			    & elt_acc & " and mawb_num=N'"& dNum & "'"
			case "Booking" 
			SQL = "select TOP 1 invoice_no as num from invoice where elt_account_number =" _
			    & elt_acc & " and mawb_num=N'"& dNum & "'"		
		end select

	Set rs = eltConn.execute (SQL)

	if NOT rs.eof and NOT rs.bof then
		rNum = rs("num")
		Response.write rNum
	else
		Response.write ""
	end if

	rs.Close
	eltConn.Close
	Set rs = Nothing
	Set eltConn = Nothing
%>
