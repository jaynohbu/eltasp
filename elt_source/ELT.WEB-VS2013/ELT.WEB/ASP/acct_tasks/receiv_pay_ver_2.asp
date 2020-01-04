<!--  #INCLUDE FILE="../include/transaction.txt" -->
<!--  #INCLUDE FILE="../include/connection.asp" -->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Receive Payments</title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <base target="_self" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="/ASP/ajaxFunctions/ajax.js"></script>

    <script type="text/javascript" src="../Include/JPED.js"></script>

    <script type="text/javascript" src="../Include/JPTableDOM.js"></script>

    <script type="text/javascript">

        function lstCustomerNameChange(orgNum,orgName){
            try{
                var hiddenObj = document.getElementById("hCustomerAcct");
                var txtObj = document.getElementById("lstCustomerName");
                var divObj = document.getElementById("lstCustomerNameDiv");
                
                hiddenObj.value = orgNum;
                txtObj.value = orgName;
            
                divObj.style.position = "absolute";
                divObj.style.visibility = "hidden";
                divObj.style.height = "0px";
                document.form1.action = "receiv_pay.asp?Cus=yes&WindowName=" + window.name;
	            document.form1.method = "POST";
	            document.form1.target = "_self";
	            document.form1.submit();
            }catch(err){ }
        }

		function lstThirdPartyChange(orgNum,orgName){
            try{
                var hiddenObj = document.getElementById("hThirdPartyAcct");
                var txtObj = document.getElementById("lstThirdParty");
                var divObj = document.getElementById("lstThirdPartyDiv");
                
                hiddenObj.value = orgNum;
                txtObj.value = orgName;
            
                divObj.style.position = "absolute";
                divObj.style.visibility = "hidden";
                divObj.style.height = "0px";
            }catch(err){}
        }
        
    </script>

    <style type="text/css">

        body {
	        margin-left: 0px;
	        margin-right: 0px;
	        margin-bottom: 0px;
        }
        .style1 {color: #000000}
        .style6 {color: #CC0000; font-weight: bold; font-size: 11px; }
        .style8 {color: #CC3300; font-weight: bold; font-size: 11px; }
        .style9 {color: #CC6600}
        .style10 {
	        color: #cc6600;
	        font-weight: bold;
        }

    </style>
</head>
<!-- #INCLUDE FILE="../include/header.asp" -->
    <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
<!-- #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<%
Dim rs, SQL
Set rs = Server.CreateObject("ADODB.Recordset")

Dim Customer(),Org_ACCT(),cusIndex
Dim recentPaymentNo
Dim isCustomer,CustomerNo,DepositAcct,PmtMethod,Save,OverPaidTo
Dim dpACCTName(32),dpACCT(32),dpBal(32),dpIndex
Dim ARName(32),ARACCT(32),arIndex,hARAcct
Dim vAcctBalance
Dim InvoiceDate(),InvoiceNo(),InvoiceType(),InvoiceCheck(),InvoiceRefNo()
Dim OrigAmt(),AmtDue(),aPayment(),TotalAmtDue
Dim tIndex
Dim bankIndex,PaymentNo
Dim NoItem,Checked,sInvoiceNo,sAmtDue,sPayment
DIM Branch,iDate,CustomerName,AR,ReceivedAMT,CheckNo,Credits,unAppliedAmt,AddedAmt,TotalPayment 
DIM BCustomer,iType
Dim ThirdPartyNo, ThirdPartyName
DIM iCnt

tIndex=0

eltConn.BeginTrans()

Branch = Request.QueryString("Branch")
BCustomer = Request.QueryString("BCustomer")
UpdatePMT = Request.QueryString("UpdatePMT")
PaymentNo = Request.QueryString("PaymentNo")
DeletePMT = Request.QueryString("DeletePMT")
pNo = Request("hPaymentNo")

If pNo = "" Then pNo = 0

isCustomer = Request.QueryString("Cus")
CustomerNo = Request("hCustomerAcct")
CustomerName = Request("lstCustomerName")
DepositAcct = Request("lstDepositAcct")
ThirdPartyNo = checkBlank(Request("hThirdPartyAcct"), 0)
ThirdPartyName = Request("lstThirdParty")
OverPaidTo = Request.QueryString("OverPaidTo")

if DepositAcct = "" then
	DepositAcct = 0
else
	pos = 0
	pos = instr(DepositAcct,"-")
	if pos > 0 then
		DepositAcct = CLng(Mid(DepositAcct, 1, pos-1))
	end if
end if

AR = Request("hARAcct")

If AR = "" Then
	AR = 0
Else
	AR = CLng(AR)
End if

PmtMethod = Request("lstPmtMethod")
CheckNo = Request("txtCheckNo")
iDate = Request("txtDAte")
if iDate = "" then iDate = Date

Save = Request.QueryString("save")

TranNo = Session("TranNoRe")

if TranNo = "" then
    Session("TranNoRe") = 0
    TranNo = 0
end if

tNo = Request.QueryString("tNo")

if tNO = "" then 
	tNO = 0
else
	tNo = cLng(tNo)
end if

if Save = "yes" And ( tNo <> TranNo ) then 'refresh or back
	Save = ""
	isCustomer = "yes"	
	CustomerNo = Request("hCustomerAcct")
end if

If Save = "yes" And tNo = TranNo then

	Session("TranNoRe") = Clng(Session("TranNoRe")) + 1
	TranNo = Clng(Session("TranNoRe"))
	vTranDate = Request("txtDate")
	ReceivedAMT = cDbl(Request("txtAmount"))
	ExistingCredit = cDbl(Request("txtCreditAmt"))
	unAppliedAmt = cDbl(Request("txtUnappliedAmt"))
	iTotalPayment = cDbl(Request("txtTotalPayment"))
	ApplyCredit = Request("cApplyCredit")
	AddedAmt = Request("hAddedAmt")
	
	If AddedAmt = "" or IsNull(AddedAmt) Then
		AddedAmt = 0
	End If
	NoItem = Request("hNoItem")

    '// add payment record in the customer_payment table
	If pNo=0 Then
		SQL= "select max(payment_no) as PaymentNo from customer_payment where elt_account_number = " _
		    & elt_account_number 
		rs.Open SQL, eltConn, , , adCmdText
		If Not rs.EOF And IsNull(rs("PaymentNo"))=False Then
			pNo = CLng(rs("PaymentNo")) + 1
		Else
			pNo=10001
		End If
		rs.Close
	End If

	SQL= "select * from customer_payment where elt_account_number = " & elt_account_number _
	    & " and payment_no=" & pNo
	rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	If rs.EOF Then
		rs.AddNew
		rs("elt_account_number")=elt_account_number
		rs("payment_no")=pNo
	End If
	rs("payment_Date") = vTranDate
	rs("ref_no") = CheckNo
	rs("Customer_Number") = CustomerNo
	rs("Customer_Name") = LTrim(CustomerName)
	rs("third_party_number") = ThirdPartyNo
	rs("third_party_name") = ThirdPartyName
	rs("accounts_receivable") = AR
	rs("deposit_to") = DepositAcct
	rs("received_amt") = ReceivedAMT
	rs("balance") = ReceivedAMT - iTotalPayment
	rs("pmt_method") = PmtMethod
	rs("existing_credits") = ExistingCredit
	rs("unapplied_amt") = unAppliedAmt
	If ApplyCredit="Y" Then
		rs("added_amt") = unAppliedAmt - ExistingCredit
	Else
		rs("added_amt") = unAppliedAmt
	End if
	rs.Update
	rs.Close
	
    '// Insert to customer_payment_detail
	Dim aOrigCost(32),aOrigAmt(32),OrigTotalCost
	SQL= "delete from customer_payment_detail where elt_account_number = " & elt_account_number & " and payment_no=" & pNo
	eltConn.Execute SQL
	pItemID=1
	
	For i=0 To NoItem-1 
		Checked=Request("cCheck" & i)
		If Checked="Y" Then
			cpInvoiceNo=Request("hInvoiceNo" & i)
			cpAmtDue=cdbl(Request("txtAmtDue" & i))
			cpPayment=cdbl(Request("txtPayment" & i))
			cpOrigAmt=cdbl(Request("txtOrigAmt" & i))
			cpInvoiceDate=Request("txtInvoiceDate" & i)
			cpInvoiceType=Request("txtInvoiceType" & i)
			SQL= "select * from customer_payment_detail where elt_account_number = " & elt_account_number & " and payment_no=" & pNo & " and item_id=" & pItemID
			rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
			'// If rs.EOF Or rs.BOF Then
				rs.AddNew
				rs("elt_account_number")=elt_account_number
				rs("payment_No")=pNo
				rs("item_id")=pItemID
			'// end if
			rs("invoice_date")=cpInvoiceDate
			rs("type")=cpInvoiceType
			rs("invoice_no")=cpInvoiceNo
			rs("orig_amt")=cpOrigAmt
			rs("amt_due")=cpAmtDue
			rs("payment")=cpPayment
			rs.Update
			rs.Close
			pItemID=pItemID+1
		End If
	Next

    '// Update GL for A/R record
	SQL= "select * from gl where elt_account_number = " & elt_account_number _
	    & " and gl_account_number=" & AR
	rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	
	If Not rs.EOF Then
		If Not IsNull(rs("gl_account_balance")) Then
			arPBalance = rs("gl_account_balance")
			arBalance = CDbl(rs("gl_account_balance")) - CDbl(iTotalPayment)
		Else
			arPBalance = 0
			arBalance = -(CDbl(iTotalPayment))
		End if
		rs("gl_account_balance") = arBalance
	End if
	rs.Update
	rs.Close
	
    '// Delete all records for the receiving
	SQL= "delete from all_accounts_journal where elt_account_number = " & elt_account_number & " and tran_type='PMT' and tran_num=" & pNo
	eltConn.Execute SQL
	
	'// Insert A/R for total amount received
	SQL= "select max(tran_seq_num) as SeqNo from all_accounts_journal where elt_account_number = " & elt_account_number
	rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	
	If Not rs.EOF And IsNull(rs("SeqNo")) = False Then
		SeqNo = CLng(rs("SeqNo")) + 1
	Else
		SeqNo=1
	End If
	rs.Close
	
	rs.Open "all_accounts_journal", eltConn, adOpenDynamic, adLockPessimistic, adCmdTable
	rs.AddNew
	rs("elt_account_number") = elt_account_number
	rs("gl_account_number") = AR
	rs("gl_account_name") = GetGLDesc(AR)
	rs("tran_seq_num") = SeqNo
	SeqNo = SeqNo + 1
	rs("tran_type") = "PMT"
	rs("tran_num") = pNo
	rs("tran_date") = vTranDate
	rs("Customer_Number") = CustomerNo
	rs("Customer_Name") = CustomerName
	rs("memo") = CheckNo
	rs("split") = GetGLDesc(DepositAcct)
	rs("debit_amount") = 0
	rs("credit_amount") = -iTotalPayment
	rs.Update
	rs.Close
	
	'// GL balance update for deposit account
	SQL= "select * from gl where elt_account_number=" & elt_account_number _
	    & " and gl_account_number=" & DepositAcct
	rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	
	If Not rs.EOF Then
		If Not IsNull(rs("gl_account_balance")) then
			dBalance = cDbl(rs("gl_account_balance")) + cDbl(iTotalPayment)
			dPBalance = rs("gl_account_balance")
		Else
			dBalance = cDbl(iTotalPayment)
			dPBalance = 0
		End if
		rs("gl_account_balance") = dBalance
	End if
	rs.Update
	rs.Close
	
	'// Insert GL entry for deposite account
	rs.Open "all_accounts_journal", eltConn, adOpenDynamic, adLockPessimistic, adCmdTable
	rs.AddNew
	rs("elt_account_number") = elt_account_number
	rs("gl_account_number") = DepositAcct
	rs("gl_account_name") = GetGLDesc(DepositAcct)
	rs("tran_seq_num") = SeqNo
	SeqNo = SeqNo + 1
	rs("tran_type") = "PMT"
	rs("tran_num") = pNo
	rs("tran_date") = vTranDate
	rs("Customer_Number") = CustomerNo
	rs("Customer_Name") = CustomerName
	rs("memo") = CheckNo
	rs("split") = GetGLDesc(AR)
	rs("debit_amount") = ReceivedAMT
	rs("credit_amount") = 0
	rs.Update
	rs.Close
	
	If Not IsNull(OverPaidTo) And OverPaidTo <> "" Then
	
	    '// GL balance update for overpay account
	    SQL= "select * from gl where elt_account_number=" & elt_account_number _
	        & " and gl_account_number=" & OverPaidTo
	    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
		
	    If Not rs.EOF Then
		    If Not IsNull(rs("gl_account_balance")) then
			    dBalance = cDbl(rs("gl_account_balance")) + cDbl(unAppliedAmt)
			    dPBalance = rs("gl_account_balance")
		    Else
			    dBalance = cDbl(unAppliedAmt)
			    dPBalance = 0
		    End if
		    rs("gl_account_balance") = dBalance
	    End if
	    rs.Update
	    rs.Close
		
	    '// Insert GL entry for overpay account
	    rs.Open "all_accounts_journal", eltConn, adOpenDynamic, adLockPessimistic, adCmdTable
	    rs.AddNew
	    rs("elt_account_number") = elt_account_number
	    rs("gl_account_number") = OverPaidTo
	    rs("gl_account_name") = GetGLDesc(OverPaidTo)
	    rs("tran_seq_num") = SeqNo
	    rs("tran_type") = "PMT"
	    rs("tran_num") = pNo
	    rs("tran_date") = vTranDate
	    rs("Customer_Number") = CustomerNo
	    rs("Customer_Name") = CustomerName
	    rs("memo") = CheckNo
	    rs("split") = "Customer Overpaid"
	    rs("debit_amount") = 0
	    rs("credit_amount") = -unAppliedAmt
	    rs.Update
	    rs.Close
	    
    End If
	    
end if
	
if save="yes" then	
    '// update customer credit
    CALL update_customer_credit( CustomerNo, CustomerName )
	'// update invoice table
	for i=0 to NoItem-1
		Checked=Request("cCheck" & i)
		if Checked="Y" then
			sInvoiceNo=Request("hInvoiceNo" & i)
			if sInvoiceNo="" then sInvoiceNo=-1
			
			sOrigAmt=Request("txtOrigAmt" & i)
			if  Not sOrigAmt = "" then
				sOrigAmt=cdbl(sOrigAmt)
			else
				sOrigAmt=0
			end if	

			sAmtDue=Request("txtAmtDue" & i)
			if  Not sAmtDue = "" then
				sAmtDue=cdbl(sAmtDue)
			else
				sOrigAmt=0
			end if	

			sPayment=Request("txtPayment" & i)
			if  Not sPayment = "" then
				sPayment=cdbl(sPayment)
			else
				sPayment=0
			end if	

			if  sInvoiceNo > 0 then
			    update_customer_payment(sInvoiceNo)
			end if
		end if
	next
end if

		if ( isCustomer="yes" or Save="yes" ) and ( UpdatePMT <> "yes" ) then
		    '// can get rid of it later
		    CALL update_customer_credit(CustomerNo, CustomerName)
		    
		    '// get customer's credits
			SQL= "select * from customer_credits where elt_account_number=" & elt_account_number _
			    & " and Customer_no=" & CustomerNo
			rs.Open SQL, eltConn, , , adCmdText
			Credits=0
			if Not rs.EOF and IsNull(rs("credit")) = False then
				Credits=rs("credit")
			end if
			rs.Close
			
			SQL= "select count(*) as iCnt from invoice where elt_account_number=" & elt_account_number _
			    & " and Customer_number=" & CustomerNo & " and accounts_receivable=" _
			    & AR & " and (invoice_type='I' or invoice_type='G') and balance <> 0"
			Set rs = eltConn.execute (SQL)
			iCnt = 0
			if NOT rs.eof and NOT rs.bof then
				iCnt = rs("iCnt")
			end if	
			rs.Close
		
			ReDim InvoiceDate(iCnt), InvoiceNo(iCnt), OrigAmt(iCnt), AmtDue(iCnt), InvoiceType(iCnt), InvoiceCheck(iCnt), aPayment(iCnt), InvoiceRefNo(iCnt)
			
			SQL= "select * from invoice where elt_account_number=" & elt_account_number _
			    & " and Customer_number=" & CustomerNo & " and accounts_receivable=" & AR _
			    & " and (invoice_type='I' or invoice_type='G') and balance <> 0 order by invoice_no"
		    '//	response.write SQL
			rs.Open SQL, eltConn, , , adCmdText
			TotalAmtDue=0
			TotalPayment=0
			ReceivedAMT=0
			CheckNo=""
			unAppliedAmt=0
			Do While Not rs.EOF
				InvoiceDate(tIndex)=rs("invoice_date")
				iType=rs("invoice_type")
				if iType="I" then 
					InvoiceType(tIndex)="INVOICE"
				elseif iType="G" then
					InvoiceType(tIndex)="GJE"
				end if
				InvoiceNo(tIndex)=rs("invoice_no")
				OrigAmt(tIndex)=rs("amount_charged")
				AmtDue(tIndex)=Cdbl(rs("balance"))
				TotalAmtDue=TotalAmtDue+AmtDue(tIndex)
				InvoiceRefNo(tIndex) = rs("ref_no_our")
				rs.MoveNext
				tIndex=tIndex+1
			Loop
			rs.Close
		end if

		if UpdatePMT = "yes" then
			PaymentNo = pNo
			CALL get_payment_data( PaymentNo )
		end if

		if PaymentNo <> "" And DeletePMT = "yes" then
			CALL delete_payment	
			CALL update_customer_credit( CustomerNo, CustomerName )
		end if

		if PaymentNo <> "" And DeletePMT <> "yes" And UpdatePMT <> "yes" then
			CALL get_payment_data( PaymentNo )
		end if
	
		CALL get_gl_balance

		Set rs=Nothing
	
		recentPaymentNo = pNo
		if PaymentNo = "" then
			PaymentNo = 0
		end if
		
		eltConn.CommitTrans()
%>
<%
sub get_payment_data( PaymentNo )
	if Not Branch="" then
		if UserRight=9 then
			SQL= "select * from customer_payment where elt_account_number=" & Branch & " and payment_no=" & PaymentNo 
		else
%>

<script type="text/javascript">alert("You don`t have the privilege to access this page!"); history.go(-1);</script>

<%	
		end if
	else
		SQL= "select * from customer_payment where elt_account_number=" & elt_account_number & " and payment_no=" & PaymentNo 
	end if

	rs.Open SQL, eltConn, , , adCmdText
	if Not rs.EOF then
		iDate=rs("payment_date")
		CustomerNo=rs("customer_number")
		CustomerName=rs("customer_name")
		ThirdPartyNo = rs("third_party_number")
		ThirdPartyName = rs("third_party_name")
		DepositAcct=rs("deposit_to")
		if IsNull(DepositAcct) then
			DepositAcct=0
		else
			DepositAcct=cLng(DepositAcct)
		end if
		AR=rs("accounts_receivable")
		if IsNull(AR) then
			AR=0
		else
			AR=cLng(AR)
		end if
		PmtMethod=rs("pmt_method")
		ReceivedAMT=rs("received_amt")
		CheckNo=rs("ref_no")
		Credits=rs("existing_credits")
		unAppliedAmt=rs("unapplied_amt")
		AddedAmt=rs("added_amt")
	end if
	rs.Close
	
	if Not Branch="" then
		SQL= "select count(*) as iCnt from customer_payment_detail where elt_account_number=" & Branch & " and payment_no=" & PaymentNo 
	else
		SQL= "select count(*) as iCnt from customer_payment_detail where elt_account_number=" & elt_account_number & " and payment_no=" & PaymentNo 
	end if
	Set rs = eltConn.execute (SQL)
	
	iCnt = 0
	if NOT rs.eof and NOT rs.bof then
		iCnt = rs("iCnt")
	end if	
	rs.Close
	
	ReDim InvoiceDate(iCnt), InvoiceNo(iCnt),OrigAmt(iCnt),AmtDue(iCnt),InvoiceType(iCnt),InvoiceCheck(iCnt),aPayment(iCnt)
	
	if Not Branch="" then
		SQL= "select * from customer_payment_detail where elt_account_number=" & Branch & " and payment_no=" & PaymentNo & " order by item_id"
	else
		SQL= "select * from customer_payment_detail where elt_account_number=" & elt_account_number & " and payment_no=" & PaymentNo & " order by item_id"
	end if

	rs.Open SQL, eltConn, , , adCmdText
	TotalAmtDue=0
	TotalPayment=0
	Do While Not rs.EOF
		InvoiceCheck(tIndex)="Y"
		InvoiceDate(tIndex)=rs("invoice_date")
		InvoiceType(tIndex)=rs("type")
		InvoiceNo(tIndex)=rs("invoice_no")
		OrigAmt(tIndex)=rs("orig_amt")
		AmtDue(tIndex)=Cdbl(rs("amt_due"))
		aPayment(tIndex)=cDbl(rs("payment"))
		TotalAmtDue=TotalAmtDue+AmtDue(tIndex)
		TotalPayment=TotalPAyment+aPayment(tIndex)
		rs.MoveNext
		tIndex=tIndex+1
	Loop
	rs.Close

end sub
%>
<%
sub delete_payment
'delete customer_payment
	SQL= "delete from customer_payment where elt_account_number = " & elt_account_number & " and payment_no=" & PaymentNo
	eltConn.Execute SQL
'delete customer_payment_detail
	SQL= "delete from customer_payment_detail where elt_account_number = " & elt_account_number & " and payment_no=" & PaymentNo
	eltConn.Execute SQL
'delete all_account_journal
	SQL="delete from all_accounts_journal where elt_account_number=" & elt_account_number & " and tran_type='PMT' and tran_num=" & PaymentNo
	eltConn.Execute SQL

	NoItem=Request("hNoItem")
	
	for i=0 to NoItem-1
		sInvoiceNo=Request("hInvoiceNo" & i)
		if sInvoiceNo="" then sInvoiceNo=-1

		sPayment=Request("txtPayment" & i)
		if  Not sPayment = "" then
			sPayment=cdbl(sPayment)
		else
			sPayment=0
		end if	
		

		if sInvoiceNo > 0 then
			SQL= "select * from invoice where elt_account_number=" & elt_account_number & " and invoice_no=" & sInvoiceNo
	
			rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
			if Not rs.EOF then
				rs("amount_paid")=cDbl(rs("amount_paid"))-sPayment
				rs("balance")=cDbl(rs("balance"))+sPayment
				If IsDataExist("SELECT * FROM customer_payment_detail WHERE invoice_no=" & sInvoiceNo & " AND elt_account_number=" & elt_account_number) Then
                    rs("pay_status")="P"
                    rs("lock_ar")="Y"
                Else
                    rs("pay_status")="A"
                    rs("lock_ar")="N"
                End If
				rs.Update
			end if
			rs.Close
		end if
		
	next
end sub
%>
<%
function get_fiscal_year_of_first_date( vFiscalTo )
    vFiscalFrom = DateAdd("m",-11,vFiscalTo)
    vFiscalFrom = cStr(month(vFiscalFrom)) & "/01/" & cStr(year(vFiscalFrom))

    get_fiscal_year_of_first_date = vFiscalFrom
End function
%>
<!--  #include file="../include/arn_functions.inc" -->
<%
function get_fiscal_year_of_last_date( vFiscalYear )
    dim tmpYear,tmpMonth
    DIM vCalcYear,vFiscalFrom,vFiscalTo,vfiscalEndMonth

    SQL= "select * from user_profile where elt_account_number = " & elt_account_number
    rs.Open SQL, eltConn, , , adCmdText
    If Not rs.EOF Then
	    vfiscalEndMonth=rs("fiscalEndMonth")
    end if
    rs.close

    if isnull(vFiscalEndMonth) or trim(vFiscalEndMonth) = "" then
	    vFiscalEndMonth = "12"
    end if

    tmpMonth = month(date)

    if vFiscalYear = "" or isnull( vFiscalYear ) then
	    if ( cInt(tmpMonth) = cInt(vfiscalEndMonth) ) then
		    if 	cInt(vfiscalEndMonth) = 12 then
 		      vFiscalYear = year(date)
		      vCalcYear = cInt(vFiscalYear)  
	  	    else
		      vCalcYear = year(date)	
 		      vFiscalYear = year(date) - 1
		    end if		
	    else
		    if 	cInt(vfiscalEndMonth) = 12 then
		      if cInt(tmpMonth	< 4) then
			      vFiscalYear = year(date) - 1
			      vCalcYear = cInt(vFiscalYear)
		      else
			      vFiscalYear = year(date)
			      vCalcYear = cInt(vFiscalYear)
		      end if			    
	  	    else
 		      vFiscalYear = year(date) -1 
		      vCalcYear =   year(date)
		    end if		
	    end if
    else
	    vCalcYear = cInt(vFiscalYear)  
    end if

    vFiscalTo = vfiscalEndMonth & "/" & "01" & "/" & cStr(vCalcYear)
    vFiscalTo = DateAdd("m",1,vFiscalTo)
    vFiscalTo = DateAdd("d",-1,vFiscalTo)

    get_fiscal_year_of_last_date = vFiscalTo
End function
%>
<%
SUB get_gl_balance

    'get bank info and A/P
    SQL= "select * from gl where elt_account_number = " & elt_account_number & " and (gl_account_type='"&CONST__BANK&"' or gl_account_type='"& CONST__ACCOUNT_RECEIVABLE &"')" & " order by isnull(gl_default,'') desc, cast(gl_account_number as nvarchar)"
    rs.Open SQL, eltConn, , , adCmdText

    bankIndex=0
    arIndex=0
    Do While Not rs.EOF
	    BankType=rs("gl_account_type")
	    if BankType=CONST__BANK then
		    dpACCT(bankIndex)=clng(rs("gl_account_number"))
		    dpACCTName(bankIndex)=rs("gl_account_desc")
		    bankIndex=bankIndex+1
	    else
		    ARName(arIndex)=rs("gl_account_desc")
		    ARACCT(arIndex)=clng(rs("gl_account_number"))
		    arIndex=arIndex+1
	    end if

	    rs.MoveNext
    Loop
    rs.Close

    hARAcct=ARAcct(0)

    last_date = get_fiscal_year_of_last_date( year(date) )
    first_date = get_fiscal_year_of_first_date( last_date )

    SQL= "select a.gl_account_number as gl,b.gl_account_desc as  gl_account_name,sum((a.debit_amount+ISNULL(a.debit_memo,0))+(a.credit_amount+ISNULL(a.credit_memo,0))) as balance from all_accounts_journal a, gl b where a.elt_account_number=b.elt_account_number and a.elt_account_number= " & elt_account_number  & " and a.gl_account_number=b.gl_account_number and b.gl_account_type='"&CONST__BANK&"' and a.tran_date >='" & first_date & "' and a.tran_date < DATEADD(day, 1,'"& last_date &"') Group by a.gl_account_number,b.gl_account_desc,b.gl_default order by isnull(b.gl_default,'') desc, cast(a.gl_account_number as nvarchar)"
    rs.Open SQL, eltConn, , , adCmdText
    dpIndex=0
    vAcctBalance = 0
    Do While Not rs.EOF
	    if DepositAcct=0 then
		    DepositAcct = cLng(rs("gl"))
	    end if	
	    for i = 0 to bankIndex
		    if dpACCT(i) = cLng(rs("gl")) then
			    dpBal(i)=rs("balance")
			    exit for
		    end if
	    next
	    rs.MoveNext
    Loop
    rs.Close

    DepositAcct = cLng(DepositAcct)
    for i = 0 to bankIndex
	    if DepositAcct=dpACCT(i) then
		    vAcctBalance=Cdbl(dpBal(i))
		    exit for
	    end if	
    next
    
END SUB

ON ERROR RESUME NEXT:
%>
<!--  #include file="../include/recent_file.asp" -->
<body link="336699" vlink="336699" topmargin="0">
    <form name="form1" method="post">
        <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
            <tr>
                <td height="32" align="left" valign="middle" class="pageheader">
                    Accounts Receivable
                </td>
            </tr>
        </table>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#89A979"
            bgcolor="#89A979" class="border1px">
            <tr>
                <td>
                    <input type="hidden" name="hNoItem" value="<%= tIndex %>" />
                    <input type="hidden" name="hUnappliedAmt" value="0" />
                    <input type="hidden" name="hARAcct" value="<%= hARAcct %>" />
                    <input type="hidden" name="hPaymentNo" value="<%= PaymentNo %>" />
                    <input type="hidden" name="hAddedAmt" value="<%= AddedAmt %>" />
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr bgcolor="D5E8CB">
                            <td height="24" colspan="8" align="center" valign="middle" bgcolor="D5E8CB" class="bodyheader">
                                <table width="98%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="22%">
                                        </td>
                                        <td width="52%" align="center" valign="middle">
                                            <img src="../images/button_save_payment.gif" width="46" height="18" name="bSave"
                                                onclick="SaveClick('<%= TranNo %>')" <% if Not Branch="" then response.write("disabled") %>
                                                style="cursor: hand"></td>
                                        <td width="13%">
                                            &nbsp;</td>
                                        <td width="13%" align="right" valign="middle">
                                            <% if PaymentNo > 0 then %>
                                            <img src="../images/button_delete_medium.gif" width="51" height="17" name="bDelPMT"
                                                onclick="DeletePMT(<%= PaymentNo %>)" <% if Not Branch="" then response.write("disabled") %>
                                                style="cursor: hand">
                                            <% end if %>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr align="left" valign="middle">
                            <td height="1" colspan="7" bgcolor="89A979">
                            </td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="E7F0E2">
                            <td colspan="8" bgcolor="#f3f3f3" class="bodycopy">
                                <br>
                                <table width="60%" border="0" align="center" cellpadding="2" cellspacing="0" bordercolor="#89A979"
                                    bgcolor="D5E8CB" class="border1px">
                                    <tr align="left" valign="middle" bgcolor="E7F0E2">
                                        <td class="bodycopy">
                                            &nbsp;</td>
                                        <td height="20" colspan="5" bgcolor="E7F0E2" class="bodyheader">
                                            <span class="style1">Customer</span></td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="E7F0E2">
                                        <td bgcolor="#FFFFFF" class="bodycopy">
                                            &nbsp;</td>
                                        <td colspan="5" bgcolor="#FFFFFF" class="bodyheader">
                                            <!-- Start JPED -->
                                            <div id="CustomerContainer">
                                                <input type="hidden" id="hCustomerAcct" name="hCustomerAcct" value="<%=CustomerNo %>" />
                                                <div id="lstCustomerNameDiv">
                                                </div>
                                                <table cellpadding="0" cellspacing="0" border="0">
                                                    <tr>
                                                        <td>
                                                            <input type="text" autocomplete="off" id="lstCustomerName" name="lstCustomerName"
                                                                value="<%=CustomerName %>" class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9;
                                                                border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;"
                                                                onkeyup="organizationFill(this,'Customer','lstCustomerNameChange',null,event)" onfocus="initializeJPEDField(this,event);" /></td>
                                                        <td>
                                                            <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstCustomerName','Customer','lstCustomerNameChange',null,event)"
                                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                    </tr>
                                                </table>
                                            </div>
                                            <!-- End JPED -->
                                        </td>
                                    </tr>
                                    <tr align="left" valign="middle">
                                        <td height="1" colspan="6" bgcolor="89A979">
                                        </td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="#FFFFFF">
                                        <td width="1%" bgcolor="#F3F3F3">
                                            &nbsp;</td>
                                        <td width="23%" height="20" bgcolor="#F3F3F3" class="bodyheader style9">
                                            <span class="bodyheader"><strong>Date</strong></span></td>
                                        <td width="24%" bgcolor="#F3F3F3">
                                            <span class="bodyheader">Reference Check No.</span></td>
                                        <td width="29%" bgcolor="#F3F3F3" class="bodyheader">
                                            Payment Method</td>
                                        <td width="23%" bgcolor="#F3F3F3">
                                            <span class="bodyheader">Balance</span></td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="f3f3f3">
                                        <td bgcolor="#FFFFFF">
                                            &nbsp;</td>
                                        <td bgcolor="#FFFFFF">
                                            <input name="txtDate" class="m_shorttextfield " preset="shortdate" value="<%= iDate %>"
                                                style="width: 87px"></td>
                                        <td bgcolor="#FFFFFF">
                                            <b>
                                                <input name="txtCheckNo" class="shorttextfield" value="<%= CheckNo %>" style="width: 87px">
                                            </b>
                                        </td>
                                        <td bgcolor="#FFFFFF">
                                            <span class="bodyheader">
                                                <select name="lstPmtMethod" size="1" class="smallselect">
                                                    <option <% if PmtMethod="Check" then response.write("selected") %>>Check</option>
                                                    <option <% if PmtMethod="Cash" then response.write("selected") %>>Cash</option>
                                                    <option <% if PmtMethod="Credit Card" then response.write("selected") %>>Credit Card</option>
                                                    <option <% if PmtMethod="Bank to Bank" then response.write("selected") %>>Bank to Bank</option>
                                                </select>
                                            </span>
                                        </td>
                                        <td bgcolor="#FFFFFF">
                                            <b>
                                                <input name="txtBalance" class="readonlyboldright" value="<%= formatnumber(TotalAmtDue,2) %>"
                                                    style="width: 87px" readonly>
                                            </b>
                                        </td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="#FFFFFF">
                                        <td bgcolor="#F3F3F3">
                                        </td>
                                        <td height="20" bgcolor="#F3F3F3" class="bodyheader">
                                            Third Party</td>
                                        <td bgcolor="#F3F3F3">
                                            &nbsp;</td>
                                        <td bgcolor="#F3F3F3">
                                            <span class="bodyheader">Existing Credits</span></td>
                                        <td bgcolor="#F3F3F3">
                                            <span class="style10">Received AMT</span></td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="#FFFFFF">
                                        <td bgcolor="#FFFFFF">
                                        </td>
                                        <td height="20" bgcolor="#FFFFFF" class="bodyheader">
                                            <!-- Start JPED -->
                                            <div id="CustomerContainer">
                                                <input type="hidden" id="hThirdPartyAcct" name="hThirdPartyAcct" value="<%=ThirdPartyNo %>" />
                                                <div id="lstThirdPartyDiv">
                                                </div>
                                                <table cellpadding="0" cellspacing="0" border="0">
                                                    <tr>
                                                        <td>
                                                            <input type="text" autocomplete="off" id="lstThirdParty" name="lstThirdParty" value="<%=ThirdPartyName %>"
                                                                class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Customer','lstThirdPartyChange',null,event)"
                                                                onfocus="initializeJPEDField(this,event);" /></td>
                                                        <td>
                                                            <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstThirdParty','Customer','lstThirdPartyChange',null,event)"
                                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                    </tr>
                                                </table>
                                            </div>
                                            <!-- End JPED -->
                                        </td>
                                        <td bgcolor="#FFFFFF">
                                            &nbsp;</td>
                                        <td bgcolor="#FFFFFF">
                                            <input name="txtCreditAmt" class="readonlyright" value="<%= formatnumber(Credits,2) %>"
                                                style="width: 87px" readonly></td>
                                        <td bgcolor="#FFFFFF">
                                            <strong>
                                                <input name="txtAmount" class="bodyheader" onblur="AmountBlur(this)" onkeydown="AmountEnter(this)"
                                                    value="<%= formatnumber(ReceivedAMT,2) %>" size="14" style="behavior: url(../include/igNumChkRight.htc)"
                                                    width="80px" />
                                            </strong>
                                        </td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="#FFFFFF">
                                        <td bgcolor="#F3F3F3">
                                            &nbsp;</td>
                                        <td height="20" bgcolor="#F3F3F3" class="bodyheader">
                                            &nbsp;</td>
                                        <td bgcolor="#F3F3F3">
                                            &nbsp;</td>
                                        <td bgcolor="#F3F3F3">
                                            <span class="bodyheader">Deposit to</span></td>
                                        <td bgcolor="#F3F3F3">
                                            <b>Balance</b></td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="#F3f3f3">
                                        <td bgcolor="#FFFFFF">
                                            &nbsp;</td>
                                        <td bgcolor="#FFFFFF">
                                            &nbsp;</td>
                                        <td bgcolor="#FFFFFF">
                                            &nbsp;</td>
                                        <td bgcolor="#FFFFFF" class="bodyheader">
                                            <b>
                                                <select name="lstDepositAcct" size="1" class="smallselect" onchange="BalChange()">
                                                    <% for j=0 to bankIndex-1 %>
                                                    <option value="<%= dpACCT(j) & "-" & dpBal(j) %>" <% if dpACCT(j)=cLng(DepositAcct) then response.write("selected") %>>
                                                        <%= dpACCTName(j) %>
                                                    </option>
                                                    <% next %>
                                                </select>
                                            </b>
                                        </td>
                                        <td bgcolor="#FFFFFF">
                                            <b>
                                                <input name="txtAcctBalance" class="d_shorttextfield" value="<%= formatnumber(vAcctBalance,2) %>"
                                                    size="18" readonly="true" style="behavior: url(../include/igNumChkRight.htc);
                                                    width: 87px">
                                            </b>
                                        </td>
                                    </tr>
                                </table>
                                <br>
                            </td>
                        </tr>
                        <tr>
                            <td height="2" colspan="8">
                            </td>
                        </tr>
                        <tr align="left" valign="middle">
                            <td height="20" bgcolor="D5E8CB" class="bodyheader">
                                &nbsp;</td>
                            <td bgcolor="D5E8CB" class="bodyheader">
                                Date</td>
                            <td bgcolor="D5E8CB" class="bodyheader">
                                Type</td>
                            <td width="143" bgcolor="D5E8CB" class="bodyheader">
                                Invoice No.</td>
                            <td bgcolor="D5E8CB" class="bodyheader">
                                Ref. No.</td>
                            <td align="left" bgcolor="D5E8CB" class="bodyheader">
                                Original Amount
                            </td>
                            <td align="left" bgcolor="D5E8CB" class="bodyheader">
                                Amount Due</td>
                            <td align="left" bgcolor="D5E8CB" class="bodyheader">
                                Payment</td>
                        </tr>
                        <input type="hidden" id="iType">
                        <input type="hidden" id="AmtDue">
                        <input type="hidden" id="Payment">
                        <input type="hidden" id="cCheck">
                        <% for k=0 to tIndex-1 %>
                        <tr align="left" valign="middle" bgcolor="#FFFFFF">
                            <td align="center">
                                <input type="checkbox" id="cCheck" name="cCheck<%= k %>" value="Y" onclick="CheckClick(<%= k %>)"
                                    <% if InvoiceCheck(k)="Y" then response.write("checked") %>></td>
                            <td>
                                <input readonly name="txtInvoiceDate<%= k %>" class="readonly" value="<%= InvoiceDate(k) %>"
                                    size="13">
                            </td>
                            <td>
                                <input name="txtInvoiceType<%= k %>" class="readonly" value="<%= InvoiceType(k) %>"
                                    size="16" readonly /></td>
                            <% 
                                If CDbl(OrigAmt(k))>=0 Then 
                                    strLink = "edit_invoice.asp?edit=yes&InvoiceNo=" & InvoiceNo(k) 
                                Else
                                    strLink = "edit_credit_note.asp?edit=yes&InvoiceNo=" & InvoiceNo(k)
                                End If
                            %>
                            <td class="bodyheader">
                                <span class="links" style="cursor: hand; text-decoration: underline" onclick="GotoInvoice('<%= strLink %>');">
                                    <%= InvoiceNo(k) %>
                                </span>
                                <input type="hidden" name="hInvoiceNo<%= k %>" value="<%= InvoiceNo(k) %>" /></td>
                            <td class="bodycopy">
                                <%=InvoiceRefNo(k) %>
                            </td>
                            <td align="left">
                                <input name="txtOrigAmt<%= k %>" class="readonlyright" value="<%= formatnumber(OrigAmt(k),2) %>"
                                    size="16" readonly></td>
                            <td align="left">
                                <input name="txtAmtDue<%= k %>" class="readonlyright" id="AmtDue" value="<%=formatnumber(AmtDue(k),2) %>"
                                    style="width: 80px" readonly></td>
                            <td align="left">
                                <input name="txtPayment<%= k %>" class="readonlyright" id="Payment" value="<%= formatnumber(aPayment(k),2) %>"
                                    style="width: 80px" readonly></td>
                        </tr>
                        <% next %>
                        <tr align="left" valign="middle" bgcolor="f3f3f3">
                            <td align="left" valign="middle" class="bodycopy">
                                &nbsp;</td>
                            <td align="left" valign="middle" class="bodycopy">
                                &nbsp;</td>
                            <td align="left" valign="middle" class="bodycopy">
                                &nbsp;</td>
                            <td align="left" valign="middle" class="bodycopy">
                                &nbsp;</td>
                            <td valign="middle" bgcolor="f3f3f3">
                            </td>
                            <td align="right" valign="middle" class="bodyheader">
                                <font color="c16b42">TOTAL&nbsp;&nbsp;&nbsp;</font></td>
                            <td align="left" valign="middle">
                                <b>
                                    <input name="txtTotalAmtDue" class="readonlyboldright" value="<%= formatnumber(TotalAmtDue,2) %>"
                                        style="width: 80px" readonly>
                                </b>
                            </td>
                            <td align="left" valign="middle">
                                <b>
                                    <input name="txtTotalPayment" class="readonlyboldright" value="<%=formatnumber(TotalPayment,2) %>"
                                        style="width: 80px" readonly>
                                </b>
                            </td>
                        </tr>
                        <tr align="left" valign="middle">
                            <td height="1" colspan="6" bgcolor="89A979">
                            </td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="#FFFFFF">
                            <td align="center" valign="middle" bgcolor="#E7F0E2" class="bodycopy">
                                <input type="checkbox" name="cApplyCredit" value="N" onclick="ApplyCredit()" <% if PaymentNo <> 0 then %>disabled="disabled"
                                    <% End If %> />
                            </td>
                            <td height="20" colspan="4" align="left" valign="middle" bgcolor="#E7F0E2" class="bodycopy">
                                <strong>Applying Existing Credits </strong>
                            </td>
                            <td align="left" valign="middle" bgcolor="#E7F0E2" class="bodycopy">
                                &nbsp;</td>
                            <td align="right" valign="middle" bgcolor="#E7F0E2" class="bodycopy">
                                &nbsp;</td>
                            <td align="left" valign="middle" bgcolor="#E7F0E2">
                                <input name="txtUnappliedAmt" class="readonlyright" value="<%=formatnumber(unAppliedAmt,2) %>"
                                    style="width: 80px" readonly>
                                <span class="bodycopy"><strong>Unapplied Amount</strong><span class="style8">*</span></span></td>
                        </tr>
                        <tr align="left" valign="middle">
                            <td height="1" colspan="6" bgcolor="89A979">
                            </td>
                        </tr>
                        <tr align="center" valign="middle" bgcolor="D5E8CB">
                            <td height="24" colspan="8" valign="middle" bgcolor="D5E8CB" class="bodycopy">
                                <table width="98%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="22%">
                                        </td>
                                        <td width="52%" align="center" valign="middle">
                                            <img src="../images/button_save_payment.gif" width="46" height="18" name="bSave"
                                                onclick="SaveClick('<%= TranNo %>')" <% if Not Branch="" then response.write("disabled") %>
                                                style="cursor: hand"></td>
                                        <td width="13%">
                                            &nbsp;</td>
                                        <td width="13%" align="right" valign="middle">
                                            <% if PaymentNo > 0 then %>
                                            <img src="../images/button_delete_medium.gif" width="51" height="17" name="bDelPMT"
                                                onclick="DeletePMT(<%= PaymentNo %>)" <% if Not Branch="" then response.write("disabled") %>
                                                style="cursor: hand">
                                            <% end if %>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" class="bodycopy">
            <tr>
                <td width="32%" height="18" align="right" valign="bottom">
                    <span class="style6">*</span> Any balance of the <strong>Unapplied Amount</strong>
                    will be the credit for this customer
                </td>
            </tr>
        </table>
        <br />
    </form>
</body>

<script type="text/vbscript" language="vbscript">

Sub AmountEnter(o)
	if window.event.Keycode = 13 then
		AmountBlur(o)
	end if
end sub

Sub docModified(dummy)
End Sub



Sub ApplyCredit()

	if IsNull(document.form1.txtAmount.Value) or document.form1.txtAmount.Value = "" then
		UnappliedAmt=0
	else
		UnappliedAmt=Cdbl(document.form1.txtAmount.Value)
	end if

	if IsNull(document.form1.txtCreditAmt.Value) or document.form1.txtCreditAmt.Value = "" then
		Credits=0
	else
		Credits=CDbl(document.form1.txtCreditAmt.Value)
	end if

	if document.form1.cApplyCredit.checked=true then
		document.form1.cApplyCredit.Value="Y"
		UnappliedAmt=UnappliedAmt+Credits
	else
		document.form1.cApplyCredit.Value="N"
	end if

	call sum_payment( UnappliedAmt )
	
End Sub

function check_payment()
DIM totalPay

	for y=1 to <%= tIndex %>
		If document.all("cCheck").item(y).checked=true then	
			pmt=document.all("Payment").item(y).Value
			if pmt="" then
				pmt=0
			else
				pmt=cDbl(pmt)
			end if
			totalPay = totalPay + pmt
		end if	
	next

	if totalPay <> 0 then
		check_payment = true
	else
		check_payment = false
	end if
	
end function

'Sub SaveClick(cTranNo)
'    if NOT check_payment() then
'	    msgbox "Please enter the amount"
'	    exit sub
'    end if

'    aindex = Document.form1.lstDepositAcct.Selectedindex
'    PaymentNo = Document.form1.hPaymentNo.Value
'    totalPay = document.form1.txtTotalPayment.value

'    if document.form1.hCustomerAcct.value = "" Or document.form1.hCustomerAcct.value = "0" then
'	    MsgBox "Please select a customer!"
'    elseif totalPay <= 0 Then
'        MsgBox "Total payment amount needs to be more than 0"
'    else
'        
'	    if PaymentNo=0 then
'		    document.form1.action="receiv_pay.asp?save=yes&tNo=" & cTranNo  & "&WindowName=" & window.name 
'	    else
'		    document.form1.action="receiv_pay.asp?save=yes&tNo=" & cTranNo & "&UpdatePMT=yes"  & "&WindowName=" & window.name 
'	    end if
'	    document.form1.method="POST"
'	    Document.form1.target="_self"
'	    form1.submit()
'    end if
'End Sub

Sub CheckClick(k)

    Dim UnappliedAmt,Payment,AmtDue,TotalPmt,iType
    TotalPmt=cdbl(document.form1.txtTotalPayment.Value)
    UnappliedAmt=document.form1.txtUnappliedAmt.Value

    if not UnappliedAmt="" then
	    UnappliedAmt=cdbl(UnappliedAmt)
    else
	    UnappliedAmt=0
    end if

    AmtDue = document.all("AmtDue").item(k+1).Value

    If Not AmtDue="" Then
	    AmtDue = Cdbl(AmtDue)
    Else
	    AMtDue = 0
    End If

    If document.all("cCheck").item(k+1).checked = true Then

	    if UnappliedAmt >= AmtDue then
		    Payment = AmtDue
		    UnappliedAmt = UnappliedAmt - Payment
	    else
		    Payment = UnappliedAmt
		    UnappliedAmt = 0
	    end if
	    TotalPmt=TotalPmt+Payment
    Else
	    Payment = document.all("Payment").item(k+1).Value
	    if Not Payment = "" Then
		    Payment = Cdbl(Payment)
	    else
		    Payment = 0
	    end if
	    
	    UnappliedAmt = UnappliedAmt + Payment
	    TotalPmt = TotalPmt - Payment
	    Payment = 0
    End If
    
    If Payment = 0 Then
        document.all("cCheck").item(k+1).checked = false
    End If

	document.form1.hUnappliedAmt.Value=UnappliedAmt
	document.all("Payment").item(k+1).Value=Payment
	document.form1.txtUnappliedAmt.Value=UnappliedAmt
	document.form1.txtTotalPayment.Value=TotalPmt
	
    If UnappliedAmt < 0 Then
        sum_payment(document.form1.txtAmount.Value)
    End If
    
End Sub

Sub AmountBlur(o)
	
	If Not IsNumeric(o.value) Then
		o.value = 0
		document.form1.txtUnappliedAmt.value = 0
		Exit Sub
    Elseif o.value < 0 Then
        o.value = 0
		document.form1.txtUnappliedAmt.value = 0
		Exit Sub
	End If
	UnappliedAmt = o.value
	
	if IsNull(document.form1.txtCreditAmt.Value) or document.form1.txtCreditAmt.Value = "" then
		Credits=0
	else
		Credits=CDbl(document.form1.txtCreditAmt.Value)
	end if
	
	if document.form1.cApplyCredit.checked=true then
		document.form1.cApplyCredit.Value="Y"
		UnappliedAmt=UnappliedAmt+Credits
	else
		document.form1.cApplyCredit.Value="N"
	end if

	TotalPmt=0
	
	call sum_payment( UnappliedAmt )

End Sub

sub sum_payment( UnappliedAmt )

	Credits = UnappliedAmt
	
	for y=1 to <%= tIndex %>
		If document.all("cCheck").item(y).checked = true then	
			pmt = document.all("Payment").item(y).Value
			if pmt = "" then
				pmt = 0
			else
				pmt = cDbl(pmt)
			end if
			if Credits > pmt then
				Credits = Credits - pmt
				pmt = 0
			else
				pmt = pmt - Credits
				Credits = 0
			end if
		else
			document.all("Payment").item(y).Value = 0	
		end if	

        document.all("Payment").item(y).Value = pmt
	    TotalPmt = pmt + TotalPmt		
	next

	document.form1.txtTotalPayment.Value = TotalPmt
	document.form1.hUnappliedAmt.Value = UnappliedAmt
	document.form1.txtUnappliedAmt.Value = UnappliedAmt

	For y = 1 To <%= tIndex %>
		CheckClick(y-1)
	Next	

end sub

Sub DeletePMT(PaymentNo)

    if Not PaymentNo="" then
	    ok=MsgBox ("Do you really to delete this Payment?" & chr(13) & "Continue?",36,"Message")
	    if ok=6 then	
		    document.form1.action="receiv_pay.asp?DeletePMT=yes&PaymentNo=" & PaymentNo  & "&WindowName=" & window.name 
		    document.form1.method="POST"
		    Document.form1.target="_self"
		    form1.submit()
	    end if
    end if
End Sub

Sub BalChange()
    sindex=document.form1.lstDepositAcct.selectedindex
    Bal=document.form1.lstDepositAcct.item(sindex).Value

    pos=0
    pos=instr(Bal,"-")
    if pos>0 then
	    document.form1.txtAcctBalance.Value=Mid(Bal,pos+1,200)
    end if
End Sub

Sub MenuMouseOver()
End Sub

Sub MenuMouseOut()
End Sub

</script>

<script type="text/javascript" language="javascript">

    function GotoInvoice(sURL){
        
        if(!showJPModal(sURL,"",1000,600,"Popwin")){
            var customerAcct = document.getElementById("hCustomerAcct").value;
            var customerName = document.getElementById("lstCustomerName").value;
            
            lstCustomerNameChange(customerAcct, customerName);
        }
    }
    
    function SaveClick(cTranNo){
    
        if(! check_payment())
        {
            alert("Please enter the amount");
            return ;
        }
        
        var aindex = document.form1.lstDepositAcct.selectedIndex ;
        var PaymentNo = document.form1.hPaymentNo.value;
        var totalPay = document.form1.txtTotalPayment.value

        if(document.form1.hCustomerAcct.value == "" || document.form1.hCustomerAcct.value == "0")
        {
            alert("Please select a customer!");
        }
        else if(totalPay <= 0)
        {
            alert("Total payment amount needs to be more than 0");
        }
        else
        {
            var pay_over_args = new Array();

            pay_over_args[0] = document.form1.lstCustomerName.value;
            pay_over_args[1] = document.form1.txtAmount.value;
            pay_over_args[2] = totalPay;
            pay_over_args[3] = document.form1.txtUnappliedAmt.value;
            
            if(pay_over_args[3] > 0)
            {
                var liability_account_no = window.showModalDialog("receiv_pay_over_prompt.asp", pay_over_args, "dialogWidth:600px; dialogHeight:400px; center:yes");

                if(liability_account_no != undefined)
                {
                    if(PaymentNo == 0){
                        document.form1.action="receiv_pay.asp?save=yes&tNo=" + cTranNo  + "&WindowName=" + window.name + "&OverPaidTo=" + liability_account_no;
                    }
                    else{
                        document.form1.action="receiv_pay.asp?save=yes&tNo=" + cTranNo + "&UpdatePMT=yes&"  + "WindowName=" + window.name + "&OverPaidTo=" + liability_account_no;
                    }

                    document.form1.method = "POST";
                    document.form1.target = "_self";
                    document.form1.submit();
                }
            }
            else
            {
                if(PaymentNo == 0){
                    document.form1.action="receiv_pay.asp?save=yes&tNo=" + cTranNo  + "&WindowName=" + window.name ;
                }
                else{
                    document.form1.action="receiv_pay.asp?save=yes&tNo=" + cTranNo + "&UpdatePMT=yes&"  + "WindowName=" + window.name ;
                }

                document.form1.method = "POST";
                document.form1.submit();
            }
        }
    }

</script>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
