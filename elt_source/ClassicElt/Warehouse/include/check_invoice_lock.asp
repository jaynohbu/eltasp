<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/transaction.txt" -->
<% Option Explicit %>
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/connection.asp" -->

<%  
Response.Expires = 0  
Response.AddHeader "Pragma","no-cache"  
Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
%>

<%
DIM invoice_no,noProblem,elt_account_number

' On error Resume Next :
invoice_no = Request.QueryString("n")
elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
 
if isnull(invoice_no) or invoice_no = "" then
	response.write "e"
else
	noProblem = check_invoice( invoice_no )
	if noProblem then
		response.write "lock"
	else
		response.write "ok"
	end if
end if
%>
<%
function check_invoice( invoice_no )
DIM rs,SQL,vLockAR,vLockAP

SQL = "select lock_ar,lock_ap from invoice where elt_account_number=" & elt_account_number & " and invoice_no =" & invoice_no
Set rs = eltConn.execute (SQL)
if NOT rs.eof and NOT rs.bof then
	vLockAR=rs("lock_ar")
	vLockAP=rs("lock_ap")
end if
rs.Close
	if ( vLockAR="Y" or vLockAP="Y" ) then
		check_invoice = true
	else
		check_invoice = false
	end if

end function
%>
