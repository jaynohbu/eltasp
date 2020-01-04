<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/transaction.txt" -->
<% Option Explicit %>
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/connection.asp" -->

<%  
Response.Expires = 0  
Response.AddHeader "Pragma","no-cache"  
Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
%>

<%
DIM rs,SQL,dType,dNum, rNum,elt_acc
	On error Resume Next :
	dType = Request.QueryString("dType")
	dNum = Request.QueryString("n")
	elt_acc = Request.QueryString("e")
	
		select case dType
			case "MAWB" 
			SQL = "select TOP 1 invoice_no as num from invoice where elt_account_number =" & elt_acc & " and mawb_num='"& dNum & "'"
			case "Booking" 
			SQL = "select TOP 1 invoice_no as num from invoice where elt_account_number =" & elt_acc & " and mawb_num='"& dNum & "'"		
		end select

	Set rs = eltConn.execute (SQL)

	if NOT rs.eof and NOT rs.bof then
		rNum = rs("num")
		response.write rNum
	else
		response.write ""
	end if

	rs.Close
%>
