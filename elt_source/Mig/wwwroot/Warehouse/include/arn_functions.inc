<%
sub update_customer_payment(invoice_no)
DIM tmpPayCus
DIM rs,SQL	
	
	if isnull(invoice_no) then invoice_no = ""

	if invoice_no <> "" then
		Set rs=Server.CreateObject("ADODB.Recordset")   
		SQL = "select isnull(sum(payment),0) as p from customer_payment_detail where elt_account_number = "&elt_account_number &_
			" and invoice_no="&invoice_no&" group by elt_account_number,invoice_no"
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing
		if Not rs.EOF then
			tmpPayCus = rs("p")
		else
			tmpPayCus = "0"
		end if
		rs.close

		SQL = "update invoice set amount_paid = "&tmpPayCus&" where elt_account_number = "&elt_account_number &_
			" and invoice_no="&invoice_no
		eltConn.execute (SQL)

		SQL = " if ( select ( isnull(amount_charged,0) - isnull(amount_paid,0) ) from invoice where "&_
			  " elt_account_number ="& elt_account_number &_
			  " and invoice_no = "&invoice_no&" ) > 0  "&_
			  "	begin "&_
			  "	update invoice set balance = ( isnull(amount_charged,0) - isnull(amount_paid,0) ) "&_
			  "	where elt_account_number = "& elt_account_number &" and invoice_no = "&invoice_no&_
			  "	end "&_
			  " else "&_ 
			  "	begin "&_
			  "	update invoice set balance = 0"&_
			  "	where elt_account_number = "& elt_account_number &" and invoice_no = "&invoice_no&_
			  "	end "
'response.write SQL		
		eltConn.execute (SQL)

		set rs = nothing
	end if

end sub

sub update_customer_credit( acct, acctName )
DIM tmpPay,tmpCharge
DIM rs,SQL	
	Set rs=Server.CreateObject("ADODB.Recordset")   

	SQL = " select  ( sum(isnull(a.received_amt,0)) - sum(isnull(b.payment,0)) ) as r "&_
		  " from customer_payment a inner join customer_payment_detail b "&_
		  "	on a.elt_account_number = b.elt_account_number and a.payment_no = b.payment_no "&_
		  "	where a.elt_account_number = "&elt_account_number &" and customer_number =" & acct &_
		  " group by a.elt_account_number, a.customer_number "
'response.write SQL
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing
		if Not rs.EOF then
			tmpPay = rs("r")
		else
			tmpPay = "0"
		end if
		rs.close

		tmpCredit = cDbl(tmpPay)

		SQL="select elt_account_number,credit,customer_no,customer_name,credit from customer_credits where elt_account_number=" & elt_account_number & " and Customer_no=" & acct
		rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText

		if Not rs.EOF then
			rs("credit")=tmpCredit
		else
			rs.AddNew
			rs("elt_account_number")=elt_account_number
			rs("customer_no")=acct
			rs("customer_name")=acctName
			rs("credit")=tmpCredit
		end if
		rs.Update
		rs.Close	
set rs = nothing
end sub
%>
<%
DIM arPayMentNo(32),arPayMentNoIndex 
arPayMentNoIndex = 0

function get_ar_payment( invoice )
if isnull(invoice) then invoice = ""
if invoice = "" then invoice = 0
'On Error Resume Next:
	if cLng(invoice) > 0 then
		DIM rs,SQL	
		Set rs=Server.CreateObject("ADODB.Recordset")   

		SQL = "select top 32 payment_no from customer_payment_detail where elt_account_number = "&elt_account_number&" and invoice_no=" & invoice &" order by payment_no"
'		response.write SQL
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
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

<script language='javascript'>
function createOrgProfile(vHAWB) {
	// var path = "/IFF_MAIN/ASPX/OnLines/CompanyConfig/CompanyConfigCreate.aspx?R=R&AutoCreate=yes&HAWB_NUM=" + vHAWB;
	var path = "/IFF_MAIN/ASP/master_data/client_profile.asp";
	winopen = window.open(path,"popupNew", "staus=0,titlebar=0,toolbar=0,menubar=1,scrollbars=1,resizable=1,location=0,width=800,height=600,hotkeys=0");  
}
function goLink(bill) {
	if(bill) {
	var url = '../acct_tasks/enter_bill.asp?ViewBill=yes&BillNo='+bill;
	var argS = 'menubar=1,toolbar=1,height=610,width=900,hotkeys=0,scrollbars=1,resizable=1';
	window.open(url,'PopWin', argS);
	}
	return false;			
}
function goLinkPay(paymentNo) {
	if(paymentNo) {
	var url = '../acct_tasks/receiv_pay.asp?PaymentNo='+paymentNo;
	var argS = 'menubar=1,toolbar=1,height=610,width=900,hotkeys=0,scrollbars=1,resizable=1';
	window.open(url,'PopWin', argS);
	}
	return false;			
}
</script>