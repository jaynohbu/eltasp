<%
sub update_customer_payment(invoice_no)
    
    DIM rs,SQL	
	
	If isnull(invoice_no) Then invoice_no = ""

	If invoice_no <> "" Then
	
		Set rs=Server.CreateObject("ADODB.Recordset")   
		SQL = "select isnull(sum(payment),0) as pay_sum from customer_payment_detail where elt_account_number=" _
		    & elt_account_number & " and invoice_no=" & invoice_no & " group by elt_account_number,invoice_no"
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, adLockReadOnly, adCmdText
		Set rs.activeConnection = Nothing
		If Not rs.EOF AND Not rs.BOF Then
			SQL = "UPDATE invoice SET amount_paid=" & rs("pay_sum") & ",pay_status='P',lock_ar='Y' " _
		        & "WHERE elt_account_number=" & elt_account_number & " and invoice_no=" & invoice_no
		    eltConn.execute (SQL)
		else
			SQL = "UPDATE invoice SET amount_paid=0,pay_status='A',lock_ar='N' " _
		        & "WHERE elt_account_number=" & elt_account_number & " and invoice_no=" & invoice_no
		    eltConn.execute (SQL)
		end if
		rs.close
		

		SQL = " IF (select(ISNULL(amount_charged,0)-ISNULL(amount_paid,0)) FROM invoice where " & _
			  " elt_account_number="& elt_account_number & _
			  " AND invoice_no=" & invoice_no & ")<>0 " & _
			  "	BEGIN " & _
			  "	UPDATE invoice set balance=(ISNULL(amount_charged,0)-ISNULL(amount_paid,0)) " & _
			  "	WHERE elt_account_number="& elt_account_number &" AND invoice_no=" & invoice_no & _
			  "	END " & _
			  " ELSE " & _ 
			  "	BEGIN " & _
			  "	UPDATE invoice SET balance=0" & _
			  "	WHERE elt_account_number="& elt_account_number &" AND invoice_no=" & invoice_no & _
			  "	END "

		eltConn.execute (SQL)

		set rs = nothing
	end if

end sub

'// If Recieved Amt is more than total receivable item payment amount, then the difference occurs
'// It is then recognized as a existing credits
'// Note by Joon on 2/26/2009

sub update_customer_credit( acct, acctName )
    
    DIM tmpPay,tmpCharge
    DIM rs,SQL	
	Set rs=Server.CreateObject("ADODB.Recordset")   

    If acct = 0 Or acctName = "Select One" Or acctName = "" Then
		Exit Sub
	End If
	
	SQL = "DECLARE @total_received_amt decimal(12,2) " _
        & "DECLARE @total_payment decimal(12,2) " _
        & "SET @total_received_amt=(select isnull(sum(received_amt),0) from customer_payment " _
        & "where elt_account_number=" & elt_account_number & " and customer_number=" & acct & ") " _
        & "SET @total_payment=(select isnull(sum(b.payment),0) from customer_payment a inner join " _
        & "customer_payment_detail b on a.elt_account_number=b.elt_account_number and " _
        & "a.payment_no=b.payment_no where a.elt_account_number=" & elt_account_number _
        & " and customer_number=" & acct & ") " _
        & "SELECT @total_received_amt-@total_payment AS ar_credit"

	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, adLockReadOnly, adCmdText
	
	'// Response.Write(SQL)
	
	Set rs.activeConnection = Nothing
	if Not rs.EOF then
		tmpPay = rs("ar_credit")
	else
		tmpPay = "0"
	end if
	rs.close

	tmpCredit = CDbl(tmpPay)

	SQL="select elt_account_number,credit,customer_no,customer_name from customer_credits " _
	    & " where elt_account_number=" & elt_account_number & " and Customer_no=" & acct
	rs.Open SQL, eltConn, adOpenStatic, adLockPessimistic, adCmdText

    On Error Resume Next:
	If Not rs.EOF Then
		rs("credit")=tmpCredit
	Else
		rs.AddNew
		rs("elt_account_number")=elt_account_number
		rs("customer_no")=acct
		rs("customer_name")=acctName
		rs("credit")=tmpCredit
	End If
	
	rs.Update
	rs.Close
    set rs = nothing
    
end sub

%>

<%

DIM arPayMentNo(100),arPayMentNoIndex 
arPayMentNoIndex = 0

function get_ar_payment( invoice )
    if isnull(invoice) then invoice = ""
    if invoice = "" then invoice = 0

	if cLng(invoice) > 0 then
		DIM rs,SQL	
		Set rs=Server.CreateObject("ADODB.Recordset")   

		SQL = "select top 100 payment_no from customer_payment_detail where elt_account_number = "&elt_account_number&" and invoice_no=" & invoice &" order by payment_no"

		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, adLockReadOnly, adCmdText
		Set rs.activeConnection = Nothing
		do while not rs.eof
			arPayMentNoIndex = arPayMentNoIndex + 1
			arPayMentNo(arPayMentNoIndex) = rs("payment_no").value
			rs.MoveNext
		loop
		rs.Close

		set rs = nothing
	end if
end function

%>

<script language="javascript">
    
    function createOrgProfile(vHAWB) {

        var path = "/ASP/master_data/client_profile.asp";
	    winopen = window.open(path,"popupNew", "staus=0,titlebar=0,toolbar=0,menubar=1,scrollbars=1,resizable=1,location=0,width=800,height=600,hotkeys=0");  
    }

    function goLink(bill) {
        var sURL = "";
        var bURL = "";
	    if(bill) {
	        sURL = "../acct_tasks/enter_bill.asp?ViewBill=yes&BillNo=" + bill;
	        bURL = window.location.href;
	    }
        showJPModal(sURL,bURL,1000,600,"Popwin");
    }

    function goLinkPay(paymentNo) {	    
        var sURL = "";
        var bURL = "";
	    if(paymentNo) {
	        sURL = "../acct_tasks/receiv_pay.asp?PaymentNo=" + paymentNo;
	        bURL = window.location.href;
	    }
        showJPModal(sURL,bURL,1000,600,"Popwin");
    }
    
</script>