<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/transaction.txt" -->
<% Option Explicit %>
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/connection.asp" -->

<%  
Response.Expires = 0  
Response.AddHeader "Pragma","no-cache"  
Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
%>

<%
DIM invoice_no,noProblem,elt_account_number,login_name,UserRight
Dim count,i,deleteCount
' On error Resume Next :

elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
login_name = Request.Cookies("CurrentUserInfo")("login_name")
UserRight = Request.Cookies("CurrentUserInfo")("user_right")	

'///////////////////////////////////////////// Added By Joon On Dec-6--2006

count = Request.QueryString("n").Count
reDim invoice_no(count)
deleteCount = 0

For i=1 To count
    invoice_no = Request.QueryString("n").Item(i)
    if IsNull(invoice_no) or IsEmpty(invoice_no) then
	    '//response.write "e"
    else
	    noProblem = check_invoice( invoice_no )
	    if noProblem then
		    '//response.write "lock"
	    else
		    call delete_invoice( checkBlank(invoice_no,0) )
		    deleteCount = deleteCount + 1
	    end if
    end if
Next

Response.Write(deleteCount)

'///////////////////////////////////////////////////////////////////////////
%>
<%
sub delete_invoice( invoice_no )
DIM mawb,hawb,rs,SQL,i,maxInvoice,iCnt
Set rs = Server.CreateObject("ADODB.Recordset")
Set hawb = Server.CreateObject("System.Collections.ArrayList")

	SQL = "select mawb_num from invoice where elt_account_number =" & elt_account_number & " and invoice_no =" & invoice_no
	rs.Open SQL, eltConn, , , adCmdText

	if NOT rs.eof and NOT rs.bof then
'// gather invoice mawb information 
		mawb = rs("mawb_num")
		rs.Close

		SQL = "select isnull(count(*),0) as icnt from invoice_queue where elt_account_number = " & elt_account_number & " and mawb_num ='" & mawb & "'"
		rs.Open SQL, eltConn, , , adCmdText		
		if NOT rs.eof and NOT rs.bof then
			iCnt = clng(rs("icnt"))
		end if
		rs.Close
	else
		rs.Close
		mawb = "no_mawb"
	end if

'// gather invoice hawb information 
		SQL = "select hawb_num from invoice_hawb where elt_account_number = " & elt_account_number & " and invoice_no =" & invoice_no
		rs.Open SQL, eltConn, , , adCmdText		
		do while not rs.eof
			hawb.add rs("hawb_num").value
			rs.MoveNext
		loop
		rs.Close

'// delete invoice
		SQL = "delete invoice where elt_account_number = " & elt_account_number & " and invoice_no =" & invoice_no
		eltConn.execute (SQL)

		SQL = "delete invoice_charge_item where elt_account_number = " & elt_account_number & " and invoice_no =" & invoice_no
		eltConn.execute (SQL)

		SQL = "delete invoice_cost_item where elt_account_number = " & elt_account_number & " and invoice_no =" & invoice_no
		eltConn.execute (SQL)

		SQL = "delete invoice_hawb where elt_account_number = " & elt_account_number & " and invoice_no =" & invoice_no
		eltConn.execute (SQL)

		SQL = "delete bill_detail where elt_account_number = " & elt_account_number & " and invoice_no =" & invoice_no
		eltConn.execute (SQL)

		SQL = "delete all_accounts_journal where elt_account_number = " & elt_account_number & " and tran_num ='" & invoice_no & "'"
		eltConn.execute (SQL)

		if iCnt > 1 then
			for i=0 To hawb.count-1 
				SQL = "update invoice_queue set invoiced = 'N', outqueue_date=''  where elt_account_number = " & elt_account_number & " and hawb_num ='" & hawb(i) & "' and mawb_num='"& mawb & "'"
				eltConn.execute (SQL)
			next
		else
			SQL = "update invoice_queue set invoiced = 'N', outqueue_date=''  where elt_account_number = " & elt_account_number & " and mawb_num='"& mawb & "'"
			eltConn.execute (SQL)
		end if

		for i=0 To hawb.count-1 
			SQL = "update import_hawb set invoice_no = 0 where elt_account_number = " & elt_account_number & " and hawb_num ='" & hawb(i) & "' and mawb_num='"& mawb & "'"
			eltConn.execute (SQL)
		next

'		SQL= "select max(invoice_no) as InvoiceNo from Invoice where elt_account_number = " & elt_account_number
'		rs.Open SQL, eltConn, , , adCmdText
'		If Not rs.eof and isNull(rs("InvoiceNo"))=false Then
'			maxInvoice=CLng(rs("InvoiceNo")) + 1
'		Else
'			maxInvoice=10001
'		End If
'		rs.close

'		SQL= "select next_invoice_no from user_profile where elt_account_number=" & elt_account_number
'		rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
'		If Not rs.EOF Then
'			rs("next_invoice_no")=maxInvoice
'			rs.Update
'		end if
'		rs.Close

		response.write "ok"
'	else
'		rs.Close
'		response.write "ee"
'	end if

set rs = nothing
Set hawb = nothing

end sub
%>
<%
function check_invoice( invoice_no )
DIM rs,SQL,vLockAR,vLockAP
Set rs = Server.CreateObject("ADODB.Recordset")

SQL = "select lock_ar,lock_ap from invoice where elt_account_number=" & elt_account_number & " and invoice_no =" & invoice_no
rs.Open SQL, eltConn, , , adCmdText

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
set rs = nothing

end function

Function checkBlank(arg1,arg2)
    Dim result
    If IsNull(arg1) Then 
        result = arg2
    Else
		If Trim(arg1)="" Then
			result = arg2
		Else
			result = arg1
		End If
    End If    
    checkBlank = result
    
End Function
%>
