<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% Option Explicit %>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/header.asp" -->

<!--  #INCLUDE FILE="../include/GOOFY_Util_fun.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_Util_Ver_2.inc" -->
<%
    Dim rs, SQL
    Dim venIndex,VendorName,v_print_check_as,vNextCheckNo
    Dim VendorItems,tempTable,TotalAmt
    Dim isVendor,VendorNo,Save,AddItem,DeleteItem,CheckQueueID,EditCheck,PmtMethod
    '////////////////////////////////////////////////////////////////////////////////////////////
    Dim BillDueDate(512),BillInvoiceNo(512),BillAmtDue(512),BillAmtPaid(512),BillLastPaid(512)
    Dim BillMemo(512),BillAmt(512),BillCheck(512),BillNo(512),BillNew(512),BillItemNo(512),BillAmtDispute(512)
    '////////////////////////////////////////////////////////////////////////////////////////////
    Dim ItemDate(512),ItemID(512),ItemInvoice(512),ItemNo(512),ItemInfo(512),ItemRef(512)
    Dim ItemAmt(512),ItemExpense(512),OrigItemAmt(512),ItemCheck(512)
    '////////////////////////////////////////////////////////////////////////////////////////////
    Dim BankAcct(128),BankAcctName(128),dpBal(128),BankAcctType(128)
    Dim APAcct(64),APName(64)
    Dim ExpenseAcct(128),ExpenseName(128)
    '////////////////////////////////////////////////////////////////////////////////////////////
    Dim DefaultItem,DefaultItemNo,DefaultExpense
    Dim CheckNo,CheckInfo,CheckDate,CheckMoney,CheckAmt,EditBill,vAP,vAPDesc,PrintID
    Dim SeqNo,vDate,vMemo,vBank,vCheck,vAmount,Branch,BCustomer,BankAcctNo,vLastAmount
    Dim PrintOK,DeleteCheck,TranNo,tNo,bankIndex,exIndex,apIndex,ItemIndex,tIndex
    Dim last_date,first_date,ddIndex,i,vPrintPort,ChkHashTable,vAcctBalance
    Dim iMoonDefaultValue,iMoonDefaultValueInfo,iMoonDefaultValueHidden,iMoonComboBoxName,iMoonComboBoxWidth,iMoonHiddenField,iMoonTextArea,iMoonType,iMoonRelatedArea
    Dim custom_Change_evt,orgList,VendorInfo,TotalBillAmtDue,TotalBillAmtPaid,pos,BillType
    DIM check_void,check_complete,NoItem,vVendorInfo,TotalAmount,OrigCheckAmt,OldBank
    Dim PrintNow
    
    Set ChkHashTable = Server.CreateObject("System.Collections.HashTable")  
    Set rs = Server.CreateObject("ADODB.Recordset")
    Set VendorItems = Server.CreateObject("System.Collections.ArrayList")
    
    eltConn.BeginTrans()
    
    Call GetParameters
    Call GetBankInfo
    Call GetCostItems
    
    If PrintOK="save" Or PrintOK="now" Or PrintOK="later" Then
        Call MainUpdateBillInfo
    end If

    If isVendor="yes" Or PrintOK="now" Or PrintOK="later" _
        Or PrintOK="save" Or (EditCheck="yes" And Not CheckQueueID="") Then
	    Call MainGetBillInfo
    end if

    If Not PrintID="" And DeleteCheck="yes" Then
        SQL= "delete from check_queue where elt_account_number = " & elt_account_number _
            & " and print_id=" & PrintID
	    eltConn.Execute SQL
	    SQL= "delete from check_detail where elt_account_number = " & elt_account_number _
	        & " and print_id=" & PrintID
	    eltConn.Execute SQL
	    Call UpdateBillDelete
        Call delete_all_accounts_journal
        Call delete_gl_balance
    End If
    
    last_date = get_fiscal_year_of_last_date(Year(Date))
    first_date = get_fiscal_year_of_first_date(last_date)
    Call GetBankBalance
    
    vPrintPort=checkPort    
	
	If PmtMethod = "Check" Then
	    check_void = check_find_void("BP-CHK", CheckQueueID)		
	    check_complete = check_find_complete("BP-CHK", CheckQueueID)
	Else
	    check_void = check_find_void(PmtMethod, CheckQueueID)
	    check_complete = check_find_complete(PmtMethod, CheckQueueID)
	End If
	
	vAmount = formatNumber(vAmount,2)
	
    eltConn.CommitTrans()
    
    '/////////////////////////////////////////////////////////////////////////////
%>
<%

    Sub MainGetBillInfo
        tIndex=0
	    TotalBillAmtDue=0
	    TotalBillAmtPaid=0

	    if EditBill="TRUE" then
		    EditCheck="yes"
		    CheckQueueID = Request("hPrintID")
	    end if
    	
	    EditBill="False"

	    if EditCheck="yes" and not CheckQueueID="" then
            '///////////////////////////////////// get check info
		    if Not Branch="" then
			    if UserRight=9 then
				    SQL= "select * from check_queue where elt_account_number = " & Branch & " and print_id=" & CheckQueueID
			    else
			        Response.Write("<script> alert('You don`t have the privilege to access this page!'); history.go(-1); </script>")
			        Response.End()
			    end if
		    else
			    SQL= "select * from check_queue where elt_account_number = " & elt_account_number & " and print_id=" & CheckQueueID
		    end if
		    rs.CursorLocation = adUseClient
		    rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		    Set rs.activeConnection = Nothing
		    if Not rs.EOF And Not rs.BOF then
			    vCheck=rs("check_no")
			    vAmount=rs("check_amt")			
			    VendorNo=rs("vendor_number")
			    VendorName=rs("vendor_name")
			    v_print_check_as=rs("print_check_as")			
			    VendorInfo=rs("vendor_info")
			    BankAcctNo=rs("bank")
			    vDate=rs("bill_date")
			    vMemo=rs("memo")
			    PmtMethod=rs("pmt_method")
		    end if
		    rs.Close
		    vLastAmount = vAmount
    					
            '///////////////////////////////////// get check_detail
		    if Not Branch="" then
			    SQL= "select * from check_detail where elt_account_number=" & Branch & " and print_id=" & CheckQueueID
		    else
			    SQL= "select * from check_detail where elt_account_number=" & elt_account_number & " and print_id=" & CheckQueueID & " order by tran_id"
		    end if
'response.write  SQL
'response.end

		    rs.CursorLocation = adUseClient
		    rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		    Set rs.activeConnection = Nothing

		    TotalBillAmtDue=0
		    TotalBillAmtPaid=0
		    Do While Not rs.EOF
			    BillCheck(tIndex)="Y"
			    BillNo(tIndex)=rs("bill_number")
			    BillDueDate(tIndex)=rs("due_date")
			    BillInvoiceNo(tIndex)=rs("invoice_no")
			    Billmemo(tIndex)=rs("memo")
			    BillAmt(tIndex)=rs("bill_amt")
			    BillAmtDue(tIndex)=cDbl(rs("amt_due"))
			    BillAmtPaid(tIndex)=cdbl(rs("amt_paid"))
			    BillAmtDispute(tIndex) = CDbl(checkBlank(rs("amt_dispute"),0))
			    TotalBillAmtPaid=TotalBillAmtPaid+BillAmtPaid(tIndex)
			    TotalBillAmtDue=TotalBillAmtDue+BillAmtDue(tIndex)
			    tIndex=tIndex+1
			    rs.MoveNext
		    Loop
		    rs.Close
		    EditBill="TRUE"
	    end if
    	
	    if vAP="" then vAP=0
	    
	    if Not EditCheck="yes" then
	        '///////////////////////////////////// get bill
		    SQL= "select * from bill where elt_account_number=" & elt_account_number & " and vendor_number=" & VendorNo & " and bill_ap=" & vAP & " and bill_status='A'"
		    
		    rs.CursorLocation = adUseClient
		    rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		    Set rs.activeConnection = Nothing
		    Do While Not rs.EOF
			    BillNo(tIndex)=rs("bill_number")
			    BillCheck(tIndex)=""
			    BillDueDate(tIndex)=rs("bill_due_date")
			    BillInvoiceNo(tIndex)=rs("ref_no")
			    BillAmt(tIndex)=rs("bill_amt")
			    BillType=rs("bill_type")
			    BillAmtDue(tIndex)=cdbl(rs("bill_amt_due"))
			    if BillType="C" then 
				    BillAmt(tIndex)=-cdbl(BillAmt(tIndex))
				    BillAmtDue(tIndex)=-cdbl(BillAmtDue(tIndex))
			    end if
			    TotalBillAmtDue=TotalBillAmtDue+BillAmtDue(tIndex)
			    BillAmtPaid(tIndex)=0
			    tIndex=tIndex+1
			    rs.MoveNext
		    Loop
		    rs.Close
	    end if
	    
	    if isVendor="yes" or PrintOK="now" or PrintOK="later" or PrintOK="save" then
		    v_print_check_as = 	request("txt_print_check_as")
		    VendorInfo = request("txtVendorInfo")
	    end if
	    
	    BillNo(tIndex)=""
	    BillDueDate(tIndex)=""
	    BillInvoiceNo(tIndex)=""
	    BillAmt(tIndex)=""
	    BillAmtDue(tIndex)=""
	    BillAmtPaid(tIndex)=""
	    BillMemo(tIndex)=""
	    BillCheck(tIndex)=""
	End Sub
	
    Sub MainUpdateBillInfo
    
        Dim OldBank,NextBillNo,bal
        
	    v_print_check_as = Request("txt_print_check_as")
	    vVendorInfo = Request("txtVendorInfo")
	    vBank=BankAcctNo
	    vCheck = checkBlank(Request("txtCheck"),0)
	    vDate=Request("txtDate")
	    vAmount = Request("txtAmount")
        vLastAmount = checkBlank(vLastAmount,0)
        TotalAmount = checkBlank(TotalAmount,0)
	    vMemo = Request("txtMemo")
	    NoItem = ConvertAnyValue(Request("hNoItem"),"Integer",0) 
	    TotalBillAmtDue=0
	    TotalBillAmtPaid=0
	    
	    for i=0 to NoItem-1
		    BillNo(i)=Request("hBillNo" & i)
		    BillDueDate(i)=Request("txtBillDueDate" & i)
		    if BillDueDate(i)="" then BillDueDate(i)=vDate
		    BillAmt(i)=Request("txtBillAmt" & i)
		    BillAmtDue(i)=Request("txtBillAmtDue" & i)
		    BillAmtDispute(i) = Request("txtBillAmtDispute" & i)
		    TotalBillAmtDue=TotalBillAmtDue+BillAmtDue(i)
		    BillAmtPaid(i)=Request("txtBillAmtPaid" & i)
		    if BillAmtPaid(i)="" then 
			    BillAmtPaid(i)=0
		    else
			    BillAmtPaid(i)=cdbl(BillAmtPaid(i))
		    end if
		    BillLastPaid(i)=Request("txtBillLastPaid" & i)
		    if BillLastPaid(i)="" then 
			    BillLastPaid(i)=0
		    else
			    BillLastPaid(i)=cdbl(BillLastPaid(i))
		    end if
		    TotalBillAmtPaid=TotalBillAmtPaid+BillAmtPaid(i)
		    BillMemo(i)=Request("txtBillMemo" & i)
		    BillInvoiceNo(i)=Request("txtBillInvoiceNo" & i)
		    BillCheck(i)=Request("cBillCheck" & i)
	    next
	    tIndex=NoItem
	    if (PrintOK="save" or PrintOK="later" or PrintOK="now") and TranNo=tNo then
		    if PrintOK="now" then
			    CheckNo=vCheck
			    CheckDate=vDate
			    CheckAmt=vAmount
			    CheckInfo=VendorInfo
			    CheckMoney=Request("txtMoney")
			    PrintNow="yes"
		    end if
  		    Session("TranNo")=Clng(Session("TranNo"))+1
		    TranNo=Clng(Session("TranNo"))
    		
            '///////////////////////////////////// get last check queue id
		    if PrintID="" then
			    SQL= "select max(print_id) as PrintID from check_queue where elt_account_number = " & elt_account_number
			    rs.CursorLocation = adUseClient
			    rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
			    Set rs.activeConnection = Nothing
			    If Not rs.EOF And IsNull(rs("PrintID")) = False Then
				    PrintID = CLng(rs("PrintID")) + 1
			    Else
				    PrintID=1
			    End If
			    rs.Close
		    end if
		    
		    '///////////////////////////////////// insert to check_queue table
		    SQL= "select * from check_queue where elt_account_number = " & elt_account_number & " and print_id=" & PrintID
		    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
		    if rs.EOF then
			    rs.AddNew
			    rs("elt_account_number")=elt_account_number
			    rs("print_id")=PrintID
			    OrigCheckAmt=0
			    OldBank=vBank
		    else
			    OrigCheckAmt=cdbl(rs("check_amt"))
			    OldBank=clng(rs("bank"))
		    end if
		    rs("check_no")=vCheck
		    rs("check_amt")=vAmount
		    rs("vendor_number")=VendorNo
		    rs("vendor_name")=VendorName
		    rs("print_check_as")=v_print_check_as
		    rs("vendor_info")=vVendorInfo
		    rs("bank")=vBank
		    if PrintOK="later" then
			    rs("print_status")="A"
		    else
			    rs("print_status")="N"
		    end if
		    rs("bill_date")=vDate    'check date
		    rs("memo")=vMemo
		    rs("pmt_method")=PmtMethod
		    rs.Update
		    rs.Close
    		
            '///////////////////////////////////// insert to check_detail table
		    SQL= "delete from check_detail where elt_account_number = " & elt_account_number & " and print_id=" & PrintID
		    eltConn.Execute SQL
		    for i=0 to NoItem-1
			    if BillCheck(i)="Y" then
				    SQL= "select * from check_detail where elt_account_number="&elt_account_number&" and print_id="&PrintID&" and tran_id="&i+1
				    'rs.Open "check_detail", eltConn, adOpenDynamic, adLockPessimistic, adCmdTable
				    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
				    if rs.EOF then
					    rs.AddNew
					    rs("elt_account_number")=elt_account_number
					    rs("print_id")=PrintID
					    rs("tran_id")=i+1
					    rs("bill_number")=BillNo(i)
					    rs("due_date")=BillDueDate(i)
					    rs("bill_amt")=replace(BillAmt(i),",","")
					    rs("amt_paid")=replace(BillAmtPaid(i),",","")
					    rs("amt_due")=replace(BillAmtDue(i),",","")
					    rs("amt_dispute")=replace(BillAmtDispute(i),",","")
					    rs("invoice_no")=BillInvoiceNo(i)
					    rs("memo")=BillMemo(i)
					    rs("pmt_method")=PmtMethod
					    rs.Update
				    end if
				    rs.Close
			    end if
		    next
    		
            '///////////////////////////////////// update bill
		    NextBillNo=0
		    for i=0 to NoItem-1
			    SQL= "select * from bill where elt_account_number = " & elt_account_number & " and bill_number=" & BillNo(i)
			    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
			    If rs.EOF then
				    rs.AddNew
				    rs("elt_account_number")=elt_account_number
				    rs("bill_number")=BillNo(i)
				    rs("bill_type")="D"
				    rs("vendor_number")=VendorNo
				    rs("bill_date")=vDate
				    rs("bill_due_date")=BillDueDate(i)
				    rs("bill_amt")=BillAmt(i)
				    rs("bill_amt_paid")=BillAmtPaid(i)
				    bal=BillAmt(i)-BillAmtPaid(i)
				    rs("ref_no")=BillInvoiceNo(i)
			    else
				    If EditBill="TRUE" Then
					    rs("bill_amt_paid")=cDbl(rs("bill_amt_paid"))-BillLastPaid(i)+BillAmtPaid(i)
					    bal=cdbl(rs("bill_amt"))-cDbl(rs("bill_amt_paid"))
					    '// Uncomment following to disable negative balance
				        'If bal < 0 Then
					    '    eltConn.RollbackTrans
					    '    Response.Write("<script> alert('Please, make sure the balance is greater than the amount paid!'); window.location.href='" & Request.ServerVariables("URL") & "'; </script>")
					    '    Response.End()
					    'End If
				    else
					    rs("bill_amt_paid")=cdbl(rs("bill_amt_paid"))+BillAmtPaid(i)
					    bal=cdbl(rs("bill_amt_due"))-BillAmtPaid(i)
				    end if
			    end if

                '///////////////////////////////////// by ig 08/02/2006				
			    rs("pmt_method")=PmtMethod
			    rs("bill_amt_due")=bal
			    if BillCheck(i)="Y" then
				    if bal=0 then
					    rs("bill_status")="N"
				    else
					    rs("bill_status")="A"
				    end if
				    rs("bill_ap")=vAP
				    rs("print_id")=PrintID
				    rs("lock")="Y"
			    else
				    rs("bill_status")="A"
				    rs("print_id")=0
				    rs("lock")="N"
			    end if
			    rs.Update
			    rs.Close
		    next

		    CALL reset_bill(NoItem) 
		    CALL reset_payment_for_void( NoItem ) 
		    CALL update_gl_ap_balance
		    CALL delete_all_accounts_journal
		    CALL insert_all_accounts_journal_AP
		    CALL insert_all_accounts_journal_Bank
		    CALL update_gl_bank_balance
		    '// CALL update_credit_card
    		
	    end if
    End Sub
    
    Sub update_credit_card
        Dim vCreditCardAgentNo, NextBillNo
        vCreditCardAgentNo = GetSQLResult("SELECT gl_vendor_no FROM gl WHERE elt_account_number=" & elt_account_number & " AND gl_account_number=" & vBank, "gl_vendor_no")
        Response.Write(vCreditCardAgentNo)
        eltConn.RollBackTrans()
    End Sub
    
    Sub UpdateBillDelete	
	    NoItem=Request("hNoItem")
	    For i=0 to NoItem-1
		    BillNo(i)=Request("hBillNo" & i)
		    if BillNo(i)="" then BillNo(i)=-1
		    BillAmtPaid(i)=cDbl(Request("txtBillAmtPaid" & i))
		    if Not BillNo(i)=-1 then
			    SQL= "select * from bill where elt_account_number=" & elt_account_number _
			        & " and bill_number=" & BillNo(i)
			    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
			    if Not rs.EOF then
				    rs("bill_amt_paid") = cDbl(rs("bill_amt_paid")) - BillAmtPaid(i)
				    rs("bill_amt_due") = cDbl(rs("bill_amt_due")) + BillAmtPaid(i)
				    rs("lock") = "N"
				    rs("print_id") = null
				    rs("bill_status") = "A"
				    rs.Update
			    end if
			    rs.Close
    		
		    end if
	    Next
    End Sub
    
    SUB update_gl_ap_balance
        DIM apBalance
        SQL= "select gl_account_balance from gl where elt_account_number = " _
            & elt_account_number & " and gl_account_number=" & vAP
        rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
        if not rs.EOF then
            if Not IsNull(rs("gl_account_balance")) then
                if EditBill = "TRUE" then
                    apBalance = CDbl(rs("gl_account_balance")) - vLastAmount + vAmount
   			    else
   				    apBalance = CDbl(rs("gl_account_balance")) + vAmount			
   			    end if	
   		    Else
   			    apBalance=vAmount		
   		    End If
   		    rs("gl_account_balance")=apBalance
   		    rs.Update
   	    end if
   	    rs.Close
    End SUB
    
    SUB update_gl_bank_balance
        DIM bankBalance
		
        SQL = "UPDATE gl SET gl_account_balance = b.balance FROM gl a LEFT OUTER JOIN " _
            & "(SELECT b.elt_account_number,b.gl_account_number," _
            & "SUM(b.credit_amount+b.debit_amount+ISNULL(b.debit_memo,0)+ISNULL(b.credit_memo,0)) AS balance " _
            & "FROM all_accounts_journal b GROUP BY b.elt_account_number,b.gl_account_number) b " _
            & "ON (a.elt_account_number=b.elt_account_number AND a.gl_account_number=b.gl_account_number) " _
            & "WHERE a.elt_account_number=" & elt_account_number & " AND a.gl_account_number=" & vBank

        Set rs = eltConn.execute(SQL)    
    END SUB

'// SUB update_gl_bank_balance
'//     DIM bankBalance
'//     SQL= "select gl_account_balance from gl where elt_account_number = " & elt_account_number & " and gl_account_number=" & vBank
'// 	rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
'// 	if not rs.EOF then
'// 		if Not IsNull(rs("gl_account_balance")) then
'// 			if EditBill = "TRUE" then
'// 				bankBalance = cDbl(rs("gl_account_balance")) + vLastAmount - cDbl(vAmount)
'// 			else
'// 				bankBalance = cDbl(rs("gl_account_balance")) - cDbl(vAmount)
'// 			end if	
'// 		else
'// 			bankBalance =- cDbl(vAmount)
'// 		end if			
'// 		
'// 		rs("gl_account_balance") = bankBalance
'// 		rs.Update
'// 	end if
'// 	rs.Close
'// END SUB

    SUB delete_all_accounts_journal	
        SQL= "delete from all_accounts_journal where elt_account_number = " & elt_account_number & " and ( tran_type='BP-CHK' or  tran_type='Cash' or tran_type='Credit Card' or tran_type='Bank to Bank') and tran_num=" & PrintID
	    eltConn.Execute SQL		
    END SUB

    SUB insert_all_accounts_journal_AP
		SQL= "select max(tran_seq_num) as SeqNo from all_accounts_journal where elt_account_number = " & elt_account_number
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing
		If Not rs.EOF And IsNull(rs("SeqNo"))=False Then
			SeqNo = CLng(rs("SeqNo")) + 1
		Else
			SeqNo=1
		End If
		rs.Close

		SQL= "select * from all_accounts_journal where elt_account_number = " & elt_account_number & " and tran_seq_num=" & SeqNo
		rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
		if rs.eof then	
			rs.AddNew
			rs("elt_account_number")=elt_account_number
			rs("gl_account_number")=vAP
			rs("gl_account_name")=GetGLDesc(vAP)
			rs("tran_seq_num")=SeqNo
			SeqNo=SeqNo+1
			if PmtMethod ="Check" then		
				rs("tran_type")="BP-CHK"
			else
				rs("tran_type")=PmtMethod		
			end if	
			rs("tran_num")=PrintID
			rs("tran_date")=vDate
			rs("Customer_Number")=VendorNo
			rs("Customer_Name")=VendorName
			rs("print_check_as")=v_print_check_as		
			rs("memo")=vMemo
			rs("split")=GetGLDesc(vAP)
			rs("check_no")=vCheck
			rs("debit_amount")=vAmount
			rs("credit_amount")=0
			rs.Update
		end if	
		rs.Close

    END SUB

    '// adding gl entry for asset/liability account 
    '// in either way, credit amount with negative will be added
    SUB insert_all_accounts_journal_Bank
        Dim tmpV
		SQL= "select max(tran_seq_num) as SeqNo from all_accounts_journal where elt_account_number = " _
	        & elt_account_number
		rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
		If Not rs.EOF And IsNull(rs("SeqNo"))=False Then
			SeqNo = CLng(rs("SeqNo")) + 1
		Else
			SeqNo=1
		End If
		rs.Close
		SQL= "select * from all_accounts_journal where elt_account_number = " _
		    & elt_account_number & " and tran_seq_num=" & SeqNo
		rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
		if rs.eof then
			rs.AddNew
			rs("elt_account_number")=elt_account_number
			rs("gl_account_number")=vBank
			rs("gl_account_name")=GetGLDesc(vBank)
			rs("tran_seq_num")=SeqNo
			SeqNo=SeqNo+1
			if PmtMethod ="Check" then		
				rs("tran_type")="BP-CHK"
			else
				rs("tran_type")=PmtMethod		
			end if	
			rs("tran_num")=PrintID
			rs("tran_date")=vDate
			rs("Customer_Number")=VendorNo
			rs("Customer_Name")=VendorName
			rs("memo")=vMemo
			rs("print_check_as")=v_print_check_as				
			rs("split")=GetGLDesc(vBank)
			rs("check_no")=vCheck
			rs("debit_amount")=0
			rs("credit_amount")=-vAmount
			tmpV = request("chk_isVoid")
			if not isnull(tmpV) then rs("chk_void")= tmpV
			tmpV = request("chk_isCom")
			if not isnull(tmpV) then rs("chk_complete")= tmpV
			rs.Update
		end if
		rs.Close
    END SUB

 
    Sub GetParameters
         '// Get parameter values
        Branch=Request.QueryString("Branch")
        BCustomer=Request.QueryString("BCustomer")
        isVendor=Request.QueryString("Vendor")
        VendorNo=checkBlank(Request("hVendorAcct"),0)
        VendorName=Request("lstVendorName")
        BankAcctNo=Request("lstBank")
        PmtMethod=Request("lstPmtMethod")
        Save=Request.QueryString("save")
        CheckQueueID=Request.QueryString("CheckQueueID")
        EditCheck=checkBlank(Request.QueryString("EditCheck"),"")
        PrintID=Request("hPrintID")
        PrintOK=Request.QueryString("Print")
        EditBill=Request("hEditBill")
        vAP=Request("lstAP")
        vNextCheckNo=Request.QueryString("NextCheckNo")
        DeleteCheck=Request.QueryString("DeleteCheck")

        if BankAcctNo="" or isnull(BankAcctNo) then
	        BankAcctNo=0
        else
	        pos=0
	        pos=instr(BankAcctNo,"^")
	        if pos>0 then
		        BankAcctNo=cLng(Mid(BankAcctNo,1,pos-1))
	        else
		        BankAcctNo=cLng(BankAcctNo)
	        end if
        end if

        if BankAcctNo=0 then
	        BankAcctNo=Clng(Request.QueryString("Bank"))
        end if

        venIndex=1
        TranNo=Session("TranNo")
        if TranNo="" then
	        Session("TranNo")=0
	        TranNo=0
        end if
        tNo=Clng(Request.QueryString("tNo"))
    End Sub
 
    Sub GetBankInfo
'response.write "GetBankInfo"
        Dim BankTypeTmp, BankAgentNoTmp
        Set ChkHashTable = Nothing
        Set ChkHashTable = Server.CreateObject("System.Collections.HashTable")  
        If Save = "yes" Then
            SQL= "select * from gl where elt_account_number = " & elt_account_number & " and gl_account_number = " & BankAcctNo
		    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
		    if Not rs.EOF then
			    if Not vNextCheckNo="" then
				    rs("control_no")=vNextCheckNo
				    rs.Update
			    end if
		    end if
		    rs.Close
	        if Not EditCheck="yes" then
		        vCheck=vNextCheckNo
	        end If
        End If
        
        SQL= "select ISNULL(gl_vendor_no,0) as gl_vendor_no,gl_account_type,gl_account_number,gl_account_desc,control_no  " _
            & "from gl where elt_account_number = " & elt_account_number _
            & " and gl_account_type in (" _
            & "'" & CONST__BANK & "'," _
            & "'" & CONST__CURRENT_LIB & "'," _
            & "'" & CONST__LONG_TERM_LIB & "'," _
            & "'" & CONST__ACCOUNT_PAYABLE & "'," _
            & "'" & CONST__EXPENSE & "'," _
            & "'" & CONST__COST_OF_SALES & "'," _
            & "'" & CONST__OTHER_EXPENSE & "'" _
            & ") "

'response.write SQL
'response.end 

        rs.CursorLocation = adUseClient
        rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
        Set rs.activeConnection = Nothing

        '///////////////////////////////////////////////////// by iMoon Jan-20-2007 for multi-check#

        bankIndex=0
        exIndex=0

        Do While Not rs.EOF
	        BankTypeTmp = rs("gl_account_type")
	        BankAgentNoTmp = rs("gl_vendor_no")
	        if BankTypeTmp=CONST__BANK Or (BankTypeTmp=CONST__CURRENT_LIB And BankAgentNoTmp<>"0") _
	            Or (BankTypeTmp=CONST__LONG_TERM_LIB And BankAgentNoTmp<>"0") Then
		        BankAcct(bankIndex)=clng(rs("gl_account_number"))
		        BankAcctName(bankIndex)=rs("gl_account_desc")
                ChkHashTable.Add BankAcct(bankIndex), rs("control_no").Value
                BankAcctType(bankIndex)=BankTypeTmp
		        bankIndex=bankIndex+1
	        elseif BankTypeTmp=CONST__ACCOUNT_PAYABLE then
		        APACCT(apIndex)=clng(rs("gl_account_number"))
		        APName(apIndex)=rs("gl_account_desc")
		        apIndex=apIndex+1
	        else
		        ExpenseName(exIndex)=rs("gl_account_desc")
		        ExpenseAcct(exIndex)=clng(rs("gl_account_number"))
		        exIndex=exIndex+1
	        end if

	        rs.MoveNext
        Loop
        rs.Close
        
        if BankAcctNo = 0 then
	        BankAcctNo = BankAcct(0)
        end if
    End Sub

    Sub GetCostItems
        SQL= "select item_no,item_name,account_expense from item_cost where elt_account_number = " _
            & elt_account_number & " AND ISNULL(account_expense,0)<>0 order by item_name"

        rs.CursorLocation = adUseClient
        rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
        Set rs.activeConnection = Nothing
        Set DefaultItemNo = Server.CreateObject("System.Collections.ArrayList")
        Set DefaultItem = Server.CreateObject("System.Collections.ArrayList")
        Set DefaultExpense = Server.CreateObject("System.Collections.ArrayList")

        ItemIndex=0
        Do While Not rs.EOF
	        DefaultItemNo.Add rs("item_no").value
	        DefaultItem.Add rs("item_name").value
	        DefaultExpense.Add rs("account_expense").value
	        ItemIndex=ItemIndex+1
	        rs.MoveNext
        Loop
        rs.Close
        vDate=Date
        tIndex=0
        vAmount=0
        vLastAmount=0
        vLastAmount=Request("txtOldAmount")
    End Sub
    
    Sub GetBankBalance
        SQL= "select a.gl_account_number as gl," _
            & "sum(a.credit_amount+a.debit_amount+ISNULL(a.debit_memo,0)+ISNULL(a.credit_memo,0)) as balance " _
            & "from all_accounts_journal a, gl b where a.elt_account_number=b.elt_account_number " _
            & "and a.elt_account_number= " & elt_account_number _
            & " and a.gl_account_number=b.gl_account_number and b.gl_account_type in ('" _
            & CONST__BANK & "','" & CONST__CURRENT_LIB & "','" & CONST__LONG_TERM_LIB _
            & "') and a.tran_date >='" & first_date & "' and a.tran_date >='" _
            & first_date & "' and a.tran_date < DATEADD(day, 1,'" & last_date _
            & "') Group by a.gl_account_number order by a.gl_account_number"

        rs.CursorLocation = adUseClient
        rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
        Set rs.activeConnection = Nothing
        ddIndex=0
        BankAcctNo=cLng(BankAcctNo)

        Do While Not rs.EOF
	        if BankAcctNo=0 then 
		        BankAcctNo=cLng(rs("gl"))
	        end if	
	        For i = 0 to bankIndex
		        If BankAcct(i) = cLng(rs("gl")) then
			        dpBal(i)=rs("balance")
			        exit for
		        end if
	        Next
	        rs.MoveNext
        Loop
        rs.Close
    End Sub
    
    Function SetCheckStatus(vCheckStatus)
        Dim resVal
        resVal = ""
        If vCheckStatus Then 
            resVal = resVal & " checked='checked' value='Y'" 
        Else
            resVal = resVal & " value=''" 					
        End if
        SetCheckStatus = resVal
    End Function
    
    Function SetAuthStr(disableVal,enableVal)
        Dim resVal
        If UserRight<5 or Not Branch="" Then
            resVal = disableVal
        Else
            resVal = enableVal
        End If
        SetAuthStr = resVal
    End Function

%>
<!--  #include file="functions_for_ap.inc" -->
<!--  #include file="../include/recent_file.asp" -->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
    <title>Pay Bills</title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="/ASP/ajaxFunctions/ajax.js"></script>

    <script type="text/javascript" src="/ASP/ajaxFunctions/ajax_ig_call_db.js">  </script>

    <script type="text/javascript" src="../Include/JPED.js"></script>

    <script type="text/javascript" src="../Include/JPTableDOM.js"></script>

    <script type="text/javascript">

    function lstVendorNameChange(orgNum,orgName){
        var hiddenObj = document.getElementById("hVendorAcct");
        var txtObj = document.getElementById("lstVendorName");
        var divObj = document.getElementById("lstVendorNameDiv")

        hiddenObj.value = orgNum;
        txtObj.value = orgName;
        divObj.style.position = "absolute";
        divObj.style.visibility = "hidden";
        divObj.style.height = "0px";
        setTimeout(IV_CustomerChange_adaptor,100);
    }
    
    function IV_CustomerChange_adaptor()
    {
        IV_CustomerChange();
    }
	    
    function completeCheck(o) {
        if(o.checked) {
            o.value = 'Y';
        } else {
            o.value = '';
        }
    }	

    function voidCheck(o) {
        var NoItem = document.form1.hNoItem.value;
	    if(NoItem > 0) {
		    if(o.checked) {
			    o.value = 'Y';

		    } else {
			    o.value = '';
		    }
	    }	
    }

    function ShowBillDetail(vBillNo){
    
        var sURL = "enter_bill.asp?ViewBill=yes&BillNo=" + vBillNo;
        if(!showJPModal(sURL,"",850,600,"Popwin")){
	        IV_CustomerChange();
	    }
    }
    
    function pmtChange(){
        var vPmtMethod = "";
        vPmtMethod = document.form1.lstPmtMethod.value;
        if(vPmtMethod == "Check"){

            document.form1.cToBePrint.style.visibility = "visible";
	        document.form1.sToBePrint.style.visibility = "visible";
	        document.getElementById("divPrintTop").style.visibility = "visible";
	        document.getElementById("divPrintBottom").style.visibility = "visible";
	        //document.getElementById("tblCheck").style.visibility = "visible";
	        //document.getElementById("tblCheck").style.position = "relative";
	        document.getElementById("tdCompleteCheck").style.visibility = "visible";
	        document.getElementById("tdVoidCheck").style.visibility = "visible";

	        if("<%=EditCheck%>" != "yes"){
		        ToBePrintClick();
	        }
        }
        else{
	        document.form1.cToBePrint.style.visibility = "hidden";
	        document.form1.sToBePrint.style.visibility = "hidden";
	        document.getElementById("divPrintTop").style.visibility = "hidden";
	        document.getElementById("divPrintBottom").style.visibility = "hidden";
	        //document.getElementById("tblCheck").style.visibility = "hidden";
	        //document.getElementById("tblCheck").style.position = "absolute";
	        //document.getElementById("tdVoidCheck").style.visibility = "hidden";
	        //document.getElementById("tdCompleteCheck").style.visibility = "hidden";
	        
	        document.form1.txtCheck.value="";
	        document.form1.txtCheck.disabled=true;
            document.form1.txtCheck.className  = "d_shorttextfield";
        }
        
        var lstBankObj = document.form1.lstBank;
        var optIndex = 0;
        lstBankObj.children.length = 0;
 $(lstBankObj).children().remove();
        // Change this to enable credit card pay
        if(vPmtMethod == "Credit Card Notyet"){
            <% For i=0 To bankIndex-1 %>
            <% If BankAcctType(i) <> CONST__BANK Then %>
                optIndex = addSelectOption(lstBankObj,"<%= BankAcctName(i) %>","<%= BankACCT(i) & "^" & dpBal(i) & "^" & ChkHashTable(BankAcct(i))%>");
                <% If Clng(BankAcctNo) = Clng(BankACCT(i)) Then %>
                lstBankObj.options[optIndex].selected = true;
                <% End If %>
            <% End If %>
            <% Next %>
        }
        else{
            <% For i=0 To bankIndex-1 %>
            <% If BankAcctType(i) = CONST__BANK Then %>
                optIndex = addSelectOption(lstBankObj,"<%= BankAcctName(i) %>","<%= BankACCT(i) & "^" & dpBal(i) & "^" & ChkHashTable(BankAcct(i))%>");
                <% If Clng(BankAcctNo) = Clng(BankACCT(i)) Then %>
                lstBankObj.options[optIndex].selected = true;
                <% End If %>
            <% End If %>
            <% Next %>
        }
        
        BalChange();
    }
    
    function addSelectOption(lstObj,vText,vValue){
        var optIndex = lstObj.children.length;
        lstObj.options[optIndex] = new Option();
        lstObj.options[optIndex].text = vText;
        lstObj.options[optIndex].value = vValue;
        
        return optIndex;
    }

    </script>

    <style type="text/css">
        .m_shorttextfield1 {
            behavior: url("../include/mask_js.htc");
		    font-family: Verdana, Arial, Helvetica, sans-serif;
		    font-size: 9px;
		    color: #000000;
		    height: 16px;
		    border-top-color: #666666;
		    border-right-color: #CCCCCC;
		    border-bottom-color: #CCCCCC;
		    border-left-color: #666666;
		    border-top-style: solid;
		    border-right-style: solid;
		    border-bottom-style: solid;
		    border-left-style: solid;
		    border-top-width: 1px;
		    border-right-width: 1px;
		    border-bottom-width: 1px;
		    border-left-width: 1px;
        }
        body {
	        margin-left: 0px;
	        margin-right: 0px;
	        margin-bottom: 0px;
        }
        .style1 {color: #FF0000}
    </style>
</head>
<body link="336699" vlink="336699" topmargin="0" onload="vbscript:PageLoad()">
    <form name="form1" method="post">
        <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
            <tr>
                <td width="47%" height="32" align="left" valign="middle" class="pageheader">
                    Accounts Payable
                </td>
                <td style="width: 53%" align="right" valign="middle" id="divPrintTop">
                    <div id="print" style="visibility: <%=SetAuthStr("hidden","") %>;">
                        <img src="/ASP/Images/icon_printer.gif" width="40" height="27" alt="" />
                        <a href="javascript:;" onclick="SaveClick('PrintNow',<%= TranNo %>)" alt="">Print Check
                            Now</a>
                    </div>
                </td>
            </tr>
        </table>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#89A979"
            bgcolor="#89A979" class="border1px">
            <tr>
                <td>
                    <input type="hidden" name="hPrintPort" value="<%= vPrintPort %>">
                    <input type="hidden" name="hClientOS" value="<%= ClientOS %>">
                    <input type="hidden" name="hNoItem"  id="hNoItem" value="<%= tIndex %>">
                    <input type="hidden" name="hPrintID" value="<%= CheckQueueID %>">
                    <input type="hidden" name="hEditBill" value="<%= EditBill %>">
                    <input type="hidden" name="hCheckNo" value="<% if EditCheck = "yes" then response.write vCheck else response.write ChkHashTable(BankAcctNo) end if %>">
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr bgcolor="D5E8CB">
                            <td colspan="10" height="24" align="center" valign="middle" class="bodyheader">
                                <table width="98%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="50%" align="right" valign="middle">
                                            <img src="../images/button_smallsave.gif" onclick="SaveClick('Save',<%= TranNo %>)"
                                                style="cursor: hand" <%=SetAuthStr("disabled","") %> /></td>
                                        <td width="50%" align="right" valign="middle">
                                            <img src="../Images/button_delete_payment.gif" onclick="DeleteClick()" style="cursor: hand"
                                                <%=SetAuthStr("disabled","") %> /></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td height="1" colspan="10">
                            </td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="E7F0E2">
                            <td colspan="10" bgcolor="#f3f3f3" class="bodycopy">
                                <br />
                                <table border="0" cellspacing="0" cellpadding="0" style="width: 77%; height: 28px">
                                    <tr>
                                        <td style="height: 28" align="right">
                                            <span class="bodyheader">
                                                <img src="/ASP/Images/required.gif" alt="" />Required field</span></td>
                                    </tr>
                                </table>
                                <table width="648" border="0" align="center" cellpadding="2" cellspacing="0" bordercolor="89A979"
                                    bgcolor="D5E8CB" class="border1px" style="visibility: <%=SetAuthStr("hidden","visible") %>"
                                    id="tbl_top_options">
                                    <tr align="left" valign="middle" bgcolor="E7F0E2">
                                        <td class="bodycopy">
                                            &nbsp;</td>
                                        <td height="20" valign="middle" bgcolor="E7F0E2" class="bodyheader">
                                            Payment Method</td>
                                        <td width="44%" valign="middle">
                                            <span class="bodyheader">Bank Account</span></td>
                                        <td width="29%" valign="top">
                                            <span class="bodyheader">Balance</span></td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="E7F0E2">
                                        <td width="1%" bgcolor="#FFFFFF" class="bodycopy">
                                            &nbsp;</td>
                                        <td width="26%" valign="middle" bgcolor="#FFFFFF" class="bodyheader">
                                            <select name="lstPmtMethod" size="1" class="smallselect" style="width: 120px" onchange="pmtChange()">
                                                <option value="Check" <% if PmtMethod="Check" then response.write("selected") %>>Check</option>
                                                <option value="Cash" <% if PmtMethod="Cash" then response.write("selected") %>>Cash</option>
                                                <option value="Credit Card" <% if PmtMethod="Credit Card" then response.write("selected") %>>
                                                    Credit Card</option>
                                                <option value="Bank to Bank" <% if PmtMethod="Bank to Bank" then response.write("selected") %>>
                                                    Bank to Bank</option>
                                            </select>
                                        </td>
                                        <td valign="middle" bgcolor="#FFFFFF">
                                            <span class="bodyheader">
                                                <select name="lstBank" size="1" class="smallselect" style="width: 240px" onchange="BalChange()">
                                                    <% for i=0 to bankIndex-1 %>
                                                    <option value="<%= BankACCT(i) & "^" & dpBal(i) & "^" & ChkHashTable(BankAcct(i))%>"
                                                        <% if cLng(BankAcctNo)=cLng(BankAcct(i)) then response.write("selected") %>>
                                                        <%= BankAcctName(i) %>
                                                    </option>
                                                    <% next %>
                                                </select>
                                            </span>
                                        </td>
                                        <td bgcolor="#FFFFFF">
                                            <input name="txtAcctBalance" class="readonlyboldright" value="" size="15" style="height:16px;" /></td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="E7F0E2">
                                        <td bgcolor="#f3f3f3" class="bodycopy">
                                            &nbsp;</td>
                                        <td height="20" valign="middle" bgcolor="#f3f3f3" class="bodyheader">
                                            <img align="absBottom" src="/ASP/Images/required.gif" />Company Name
                                        </td>
                                        <td valign="middle" bgcolor="#f3f3f3" class="bodyheader">
                                            &nbsp;</td>
                                        <td valign="middle" bgcolor="#f3f3f3" class="bodyheader">
                                            A/P</td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="E7F0E2">
                                        <td bgcolor="#FFFFFF" class="bodycopy">
                                            &nbsp;</td>
                                        <td colspan="2" valign="middle" bgcolor="#FFFFFF" class="bodyheader">
                                            <!-- Start JPED -->
                                            <input type="hidden" id="hVendorAcct" name="hVendorAcct" value="<%=VendorNo %>" />
                                            <div id="lstVendorNameDiv">
                                            </div>
                                            <table cellpadding="0" cellspacing="0" border="0" id="tblVendorName">
                                                <tr>
                                                    <td>
                                                        <input type="text" autocomplete="off" id="lstVendorName" name="lstVendorName" value="<%=VendorName %>"
                                                            class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                            border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Vendor','lstVendorNameChange',null,event)"
                                                            onfocus="initializeJPEDField(this,event);" /></td>
                                                    <td>
                                                        <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstVendorName','Vendor','lstVendorNameChange',null,event)"
                                                            style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                            border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                    <td>
                                                        <input type='hidden' id='quickAdd_output'/>
                                                        <img src="/ig_common/Images/combobox_addnew.gif" alt="" style="cursor: hand; border: 0px"
                                                            onclick="quickAddClient('hVendorAcct','lstVendorName','')" /></td>
                                                </tr>
                                            </table>
                                            <!-- End JPED -->
                                        </td>
                                        <td valign="top" bgcolor="#FFFFFF">
                                            <select name="lstAP" size="1" class="smallselect" style="width: 120px">
                                                <% for i=0 to apIndex-1 %>
                                                <option value="<%= APACCT(i) %>" <% if cLng(vAP)=cLng(APACCT(i)) then response.write("selected") %>>
                                                    <%= APName(i) %>
                                                </option>
                                                <% next %>
                                            </select>
                                        </td>
                                    </tr>
                                </table>
                                <br />
                                <table id="tblCheck" width="648" height="261" border="0" align="center" cellpadding="0"
                                    cellspacing="0" bordercolor="89A979" background="/ASP/Images/<% if check_void then response.write "checkback_void.gif" else response.write "checkback.gif"%>">
                                    <tr align="left" valign="top">
                                        <td width="556" height="34" valign="bottom">
                                        </td>
                                        <td width="90" valign="bottom">
                                        <%
                                            Dim NextCheckNo
                                            if EditCheck = "yes" then 
                                                NextCheckNo= vCheck 
                                            else 
                                              ' response.write("here")
'response.end()

                                                NextCheckNo= ChkHashTable(BankAcctNo) 
                                            end if 
                                            
                                         %>
                                            <input name="txtCheck" id="txtCheck" class="shorttextfield" value="<%=NextCheckNo%>"
                                                size="12"></td>
                                    </tr>
                                    <tr align="left" valign="top" height="31">
                                        <td width="556" valign="bottom"></td>
                                        <td width="90" valign="bottom"><input name="txtDate" 
                                            class="m_shorttextfield date" preset="shortdate" value="<%= vDate %>" size="12"></td>
                                    </tr>
                                    <tr align="left" valign="top"  height="32">
                                        <td height="29" colspan="2"><table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td width="13%" align="left" valign="bottom"></td>
                                                    <td width="61%" align="left" valign="bottom"><input 
                                                    name="txt_print_check_as" type="text" 
                                                    id="txt_print_check_as" class="shorttextfield" 
                                                    autocomplete="off" 
                                                    style="width: 98%; vertical-align: middle;height:16px;" value="<%=v_print_check_as%>" /></td>
                                                    <td width="4%" align="left" valign="bottom"></td>
                                                    <td width="22%" align="left" valign="bottom"><input name="txtAmount" 
                                                    class="readonlyboldright" style="height:16px;" 
                                                    value="<%= ConvertAnyValue(vAmount,"Amount",0) %>" size="14" readonly><input 
                                                    type="hidden" name="txtOldAmount" value="<%= vLastAmount %>"></td>
                                                </tr>
                                            </table></td>
                                    </tr>
                                    <tr align="left" valign="middle">
                                        <td height="39" colspan="2" align="left" valign="top">
                                            <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td width="6%" align="right" valign="bottom"></td>
                                                    <td width="94%" align="left" valign="bottom"><span 
                                                    class="bodyheader"><b><input 
                                                    name="txtMoney" 
                                                        type="text" class="readonly" size="95" style="height:16px; width:500px;" readonly></b></span></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr align="left" valign="middle">
                                        <td height="75" colspan="2" valign="top">
                                            <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td width="6%" height="20" align="left" valign="top">
                                                    </td>
                                                    <td width="94%" align="left" valign="top">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left" valign="top">
                                                        &nbsp;</td>
                                                    <td align="left" valign="top">
                                                        <textarea name="txtVendorInfo" cols="45" rows="4" class="multilinetextfield" style="height:56px"><%= VendorInfo %></textarea></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr align="left" valign="middle">
                                        <td height="40" colspan="2" valign="top">
                                            <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td width="6%" height="26" align="left" valign="bottom">
                                                        &nbsp;</td>
                                                    <td width="94%" align="left" valign="bottom">
                                                        <input name="txtMemo" class="shorttextfield" value="<%= vMemo %>" size="47" maxlength="35"></td>
                                                </tr>
                                                <tr>
                                                    <td align="left" valign="bottom">
                                                    </td>
                                                    <td align="left" valign="bottom">
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                                <br />
                            </td>
                        </tr>
                        <tr>
                            <td height="2" colspan="10">
                            </td>
                        </tr>
                        <tr align="left" valign="middle">
                            <td height="22" bgcolor="D5E8CB" class="bodyheader">
                                &nbsp;</td>
                            <td bgcolor="D5E8CB" class="bodyheader">
                                Due Date</td>
                            <td bgcolor="D5E8CB" class="bodyheader">
                                Invoice No</td>
                            <td bgcolor="D5E8CB" class="bodyheader">
                            </td>
                            <td align="left" bgcolor="D5E8CB" class="bodyheader">
                                Bill Amount</td>
                            <td align="left" bgcolor="D5E8CB" class="bodyheader">
                                &nbsp;</td>
                            <td align="left" bgcolor="D5E8CB" class="bodyheader">
                                Amount Due
                            </td>
                            <td align="left" bgcolor="D5E8CB" class="bodyheader">
                                Amount Paid</td>
                            <td align="left" bgcolor="D5E8CB" class="bodyheader">
                                Amount Dispute</td>
                            <td align="left" bgcolor="D5E8CB" class="bodyheader">
                                Memo</td>
                        </tr>
                        <input type="hidden" id="BillAmtPaid" />
                        <input type="hidden" id="BillCheck" />
                        <input type="hidden" id="BillAmtDue" />
                        <input type="hidden" id="BillAmt" />
                        <input type="hidden" id="hItemInfo" />
                        <input type="hidden" id="hBillNo" />
                        <input type="hidden" id="BillMemo" />
                        <input type="hidden" id="txtBillAmtDispute" />
                        <% for i=0 to tIndex-1 %>
                        <tr align="left" valign="middle" bgcolor="#FFFFFF" id="tr_pay_item_<%=i %>">
                            <td align="center">
                                <input type="hidden" id="hBillNo" name="hBillNo<%= i %>" value="<%= BillNo(i) %>" />
                                <input type="checkbox" id="BillCheck" name="cBillCheck<%= i %>" onclick="CheckClick(<%= i %>)" class="BillCheck"
                                    <% if BillCheck(i)="Y" then response.write("checked") %> value="Y" />
                            </td>
                            <td>
                                <table class="bodycopy" cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td>
                                            <input name="txtBillDueDate<%= i %>" class="m_shorttextfield1 date" preset="shortdate"
                                                value="<%= BillDueDate(i) %>" size="15" />
                                        </td>
                                        <td style="visibility: <%=SetAuthStr("hidden","visible") %>">
                                            <a href="javascript:ShowBillDetail(<%= BillNo(i) %>)">
                                                <img src="../images/button_newsearch.gif" alt="" /></a>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td>
                                <input name="txtBillInvoiceNo<%= i %>" class="shorttextfield" value="<%= BillInvoiceNo(i) %>"
                                    size="16" />
                            </td>
                            <td>
                            </td>
                            <td align="left">
                                <input id="BillAmt" name="txtBillAmt<%= i %>" readonly="readonly" class="readonlyright BillAmt"
                                    size="15" value="<%= formatnumber(BillAmt(i),2) %>" style="height:16px;width: 80px;" />
                            </td>
                            <td align="left">
                                &nbsp;</td>
                            <td align="left">
                                <input name="txtBillAmtDue<%= i %>" class="readonlyright BillAmtDue" readonly="readOnly" id="BillAmtDue"
                                    value="<%=formatnumber(BillAmtDue(i),2) %>" size="14" style="height:16px;width: 80px;" />
                            </td>
                            <td align="left">
                                <input name="txtBillAmtPaid<%= i %>" class="shorttextfield BillAmtPaid" id="BillAmtPaid" 
                                    onchange="BillChange(<%= i %>)"
                                    value="<%=formatnumber( BillAmtPaid(i),2) %>" style="
                                    width: 80px; text-align:right;" />
                                <input type="hidden" name="txtBillLastPaid<%= i %>" size="11" value="<% If Not check_void Then Response.Write(BillAmtPaid(i)) Else Response.Write(0) End If %>" /></td>
                            <td>
                                <input type="text" name="txtBillAmtDispute<%= i %>" id="txtBillAmtDispute" class="shorttextfield txtBillAmtDispute"
                                    style="text-align:right;width: 80px;" value="<%=formatnumber(BillAmtDispute(i),2) %>" />
                            </td>
                            <td align="left">
                                <input id="BillMemo" name="txtBillMemo<%= i %>" class="shorttextfield BillMemo" value="<%= BillMemo(i) %>"
                                    size="45" />
                            </td>
                        </tr>
                        <% If CheckQueueID <> "" Then %>

                        <script type="text/javascript">
                            document.getElementById("txtBillDueDate<%=i %>").readOnly = true;
                            document.getElementById("txtBillDueDate<%=i %>").className = "readonlyright";
                            document.getElementById("txtBillInvoiceNo<%=i %>").readOnly = true;
                            document.getElementById("txtBillInvoiceNo<%=i %>").className = "readonlyright";
                            document.getElementById("txtBillAmtPaid<%=i %>").readOnly = true;
                            document.getElementById("txtBillAmtPaid<%=i %>").className = "readonlyright";
                            document.getElementById("txtBillAmtDispute<%=i %>").readOnly = true;
                            document.getElementById("txtBillAmtDispute<%=i %>").className = "readonlyright";
                            document.getElementById("txtBillMemo<%=i %>").readOnly = true;
                            document.getElementById("txtBillMemo<%=i %>").className = "readonlyright";
                        </script>

                        <% End If %>
                        <% next %>
                        <tr align="left" valign="middle" bgcolor="#F3f3f3">
                            <td align="center">
                                &nbsp;</td>
                            <td height="20">
                                &nbsp;</td>
                            <td>
                                &nbsp;</td>
                            <td>
                                &nbsp;</td>
                            <td align="right" valign="middle" class="bodyheader">
                                <font color="c16b42">TOTAL</font></td>
                            <td align="left" class="bodyheader">
                                &nbsp;</td>
                            <td align="left" class="bodyheader">
                                <b>
                                    <input name="txtTotalAmtDue" class="readonlyboldright" value="<%=ConvertAnyValue(TotalBillAmtPaid,"Amount",0) %>"
                                        size="14" style="height:16px;width: 80px;"></b></td>
                            <td align="left" class="bodyheader">
                                <b>
                                    <input name="txtTotalAmtPaid" class="readonlyboldright" value="<%=ConvertAnyValue(TotalBillAmtPaid,"Amount",0) %>"
                                        size="14" style="height:16px; width: 80px;">
                                </b>
                            </td>
                            <td align="left">
                                &nbsp;</td>
                            <td align="left">
                                &nbsp;</td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="#FFFFFF">
                            <td style="height: 20px" align="center">
                                <input name="cToBePrint" type="checkbox" id="cToBePrint" onclick="ToBePrintClick()"
                                    <% If EditCheck = "yes" And Trim(vCheck) <> "0" Then response.write " disabled='disabled' " %>
                                    <%=SetCheckStatus(Not check_complete And Not check_void) %> /></td>
                            <td colspan="9">
                                <input type="text" id="sToBePrint" name="sToBePrint" value="To Be Printed Later"
                                    class="bodyheader" style="border: none" /></td>
                        </tr>
                        <tr>
                            <td style="height: 1px" colspan="">
                            </td>
                        </tr>
                        <tr align="left" valign="middle" style="background-color: #D5E8CB">
                            <td style="height: 24px" colspan="10" align="center">
                                <table width="98%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="50%" align="right" valign="middle">
                                            <img src="../images/button_smallsave.gif" onclick="SaveClick('Save',<%= TranNo %>)"
                                                style="cursor: hand" <%=SetAuthStr("disabled","") %> /></td>
                                        <td width="50%" align="right" valign="middle">
                                            <table cellpadding="0" cellspacing="0" border="0" class="bodyheader">
                                                <tr>
                                                    <td id="tdCompleteCheck">
                                                        <% if EditCheck = "yes" or check_complete then %>
                                                        <input id="chk_isCom" name="chk_isCom" type="checkbox" style="cursor: hand" <%=SetCheckStatus(check_complete) %>
                                                            onclick="javascript:completeCheck(this);" /><label for="chk_isCom">COMPLETE</label>
                                                        <% end if %>
                                                    </td>
                                                    <td style="width: 10px">
                                                    </td>
                                                    <td id="tdVoidCheck">
                                                        <% if EditCheck = "yes" or check_void then %>
                                                        <input id="chk_isVoid" name="chk_isVoid" type="checkbox" style="cursor: hand" <%=SetCheckStatus(check_void) %>
                                                            onclick="javascript:voidCheck(this);" /><label for="chk_isVoid">VOID</label>
                                                        <% end if %>
                                                    </td>
                                                    <td style="width: 10px">
                                                    </td>
                                                    <td>
                                                        <% If EditCheck = "yes" Then %>
                                                        <img src="../Images/button_delete_payment.gif" onclick="DeleteClick()" style="cursor: hand"
                                                            alt="" <%=SetAuthStr("disabled","") %> />
                                                        <% End If %>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <table width="95%" border="0" align="Center" cellpadding="0" cellspacing="0">
            <tr>
                <td style="height: 32px" align="right" valign="bottom" id="divPrintBottom">
                    <div id="print" style="visibility: <%=SetAuthStr("hidden","") %>">
                        <img src="/ASP/Images/icon_printer.gif" width="40" height="27" alt="" />
                        <a href="javascript:;" onclick="SaveClick('PrintNow',<%= TranNo %>)">Print Check Now</a>
                    </div>
                </td>
            </tr>
        </table>
        <br />
    </form>
</body>
<!--  #INCLUDE FILE="../include/shared.asp" -->
<script type="text/javascript">
    function docModified(dummy) {
    }
    function IV_CustomerChange(){
    
        var strPrintAs;
        var VendorInfo= get_organization_info_for_check(document.form1.hVendorAcct.value) ;

        var pos2=VendorInfo.indexOf("@@@");
        if (pos2>0 ){
	        var arrVendorInfo = VendorInfo.split("@@@");
            strPrintAs=arrVendorInfo[1];
            }
        var pos=VendorInfo.indexOf("-");

        if (pos>=0){
            arrVendorInfo2=arrVendorInfo[0].split("-");
            VendorInfo=arrVendorInfo2[1];
            VendorInfo=''
            $(arrVendorInfo2).each(function(i,obj){
                if(i>0){
                    VendorInfo+='-'+obj;
                }
            });
        }
	    document.form1.txt_print_check_as.value = strPrintAs;
	    document.form1.txtVendorInfo.value = VendorInfo;
	    document.form1.action = "pay_bills.asp?Vendor=yes" + "&WindowName=" + window.name;
	    document.form1.method = "POST";
	    document.form1.target = "_self";
	    form1.submit();
	}

    function ToBePrintClick(){
	    if (document.form1.cToBePrint.checked){
	        <% if EditCheck = "yes" and Trim(vCheck) <> "0" then %>
		        if (confirm("This check has been printed as Check# : " + "[<%=vCheck%>] \r\nDo you really want to print this check again?")) {	
			        document.form1.txtCheck.value="";
			        document.form1.txtCheck.disabled=true;
			        document.form1.txtCheck.className  = "d_shorttextfield"	;
                }	
		        else
                {
			        document.form1.cToBePrint.checked=false;
			        return false;
		        }
	        <% else %>
		        document.form1.txtCheck.value="";
		        document.form1.txtCheck.disabled=true;
		        document.form1.txtCheck.className  = "d_shorttextfield";
	        <% end if %>	
        }
	    else{
		    document.form1.txtCheck.value=document.form1.hCheckNo.value;
		    document.form1.txtCheck.disabled=false;
		    document.form1.txtCheck.className  = "shorttextfield";
	    }
    }
    function CheckClick(k){
	     make_money_string();
   }

    function SaveClick(SaveorPrint,TranNo){
        make_money_string();
        var sindex=document.form1.lstPmtMethod.selectedIndex;
        if (sindex > 0 )
	        document.form1.txtCheck.value="";

        if (SaveorPrint == "PrintNow" ){
	        if (document.form1.cToBePrint.checked) {
		        document.form1.cToBePrint.checked=false;
		        ToBePrintClick();
                
		        var tmpCheckNo = prompt("Please confirm the Check No.",document.form1.txtCheck.value);
		        if (tmpCheckNo == "" )
			        return false;
		        else
			        document.form1.txtCheck.value=tmpCheckNo;
	        }
        	
	        if (document.form1.txtCheck.value=="" ){
		        alert( "Please enter a check number!");
		        return false;
	        }
        }
        var pPrint="now";
        if (document.form1.cToBePrint.checked)
	        pPrint="later";
        else if (SaveorPrint=="Save" )
	        pPrint="save";
        else
	        pPrint="now";

        var NoItem=document.form1.hNoItem.value;
        var vVendorNo = document.form1.hVendorAcct.value;
        
        if( vVendorNo == "" || vVendorNo == "0" )
	        alert( "Please select a Company Name!");
        else if (NoItem==0 )
	        alert( "Nothing to pay!");
        else if (document.form1.cToBePrint.checked==false && document.form1.txtCheck.value=="" ){
	        if (document.form1.lstPmtMethod.selectedIndex == 0 )
		        alert( "Please enter a check number!");
        }
        else{
	        var iCnt = 0;
	        for (var k=0 ; k< NoItem; k++){
		        if ($("input.BillCheck").get(k).checked ) {
			        save="yes";
			        iCnt =iCnt + 1;
		        }
	        }
	        if (iCnt == 0 ){
		        alert( "Please select at least one item.");
		        return false;
	        }

	        for (var k=0 ; k< NoItem; k++){
		        if ($("input.BillCheck").get(k).checked 
                && (parseFloat(replaceAll(',', '', $("input.BillAmtPaid").get(k).value))>parseFloat(replaceAll(',', '', $("input.BillAmtDue").get(k).value))) ){
                //replaceAll(',', '', $("input.BillAmtPaid").get(i).value)
			        save="";
			        alert( "Amt Paid is more than Amt Due. Please correct it.");
		        }
	        }

	        if (save=="yes" ){
		        var CheckNo="";
		        if (pPrint=="now" ){
			        CheckNo=document.form1.txtCheck.value;
			        if ( CheckNo!="" ) 
                        CheckNo=new Number(CheckNo);
			        document.form1.txtCheck.value = CheckNo;
			        var CheckDate=document.form1.txtDate.value;
			        var Vendor=document.form1.txtVendorInfo.value;
			        var CheckAmt=document.form1.txtAmount.value;
			        var Money=document.form1.txtMoney.value;

			        var NoItem=parseInt(document.form1.hNoItem.value);
			        var iCnt = 0;
			        for (var i=0; i < NoItem; i++){
				        if ($("input.BillCheck").get(i).checked)
					        iCnt = iCnt + 1;
			        }
                    ///////////////////////////////////// New logic of Check Printing  by iMoon Nov-13-2006
			        var wOptions = "dialogWidth:700px; dialogHeight:600px; help:no; status:no; scroll:no;center:yes";
			        var popUpCheck = showModalDialog("check_Dialog_frame.asp?PostBack=false&cType=one&aItem="+iCnt,"self", wOptions)
                    //////////////////////////////////////////////////////////////////////////////////////////

			        var nextAction = checkPrintStopSingle( CheckNo );

			        if (nextAction != 0 )
				        return false;
			        else
				        CheckNo=CheckNo+1;
       			
		        }
		        document.form1.action="pay_bills.asp?save=yes&Print=" +pPrint + "&tNo=<%=TranNo %>&NextCheckNo="+ CheckNo + "&WindowName=" + window.name;
                        //alert(document.form1.action);
		        document.form1.method="POST";
		        document.form1.target="_self";
		        form1.submit();
	        }
        }
    }
    function BillChange(k){
    
        var NoItem=parseInt(document.form1.hNoItem.value);
        if (!IsNumeric($("input.BillAmtPaid").get(k).value)){
	        alert( "Please enter a numeric value!");
	        $("input.BillAmtPaid").get(k).value=0;
        }
        var TotalAmtPaid=0;
        var TotalAmtDue=0;
	    for(var i= 0; i<NoItem; i++){
		    var AmtPaid=parseFloat(replaceAll(',', '', $("input.BillAmtPaid").get(i).value));
            $("input.BillAmtPaid").get(i).value = AmtPaid.toFixed(2);
		    var AmtDue=parseFloat(replaceAll(',', '', $("input.BillAmtDue").get(i).value));
		    if ($("input.BillCheck").get(i).checked)
			    TotalAmtPaid=TotalAmtPaid+AmtPaid;
		    TotalAmtDue=TotalAmtDue+AmtDue;
	    }
	    document.form1.txtAmount.value=TotalAmtPaid.toFixed(2);
	    document.form1.txtTotalAmtPaid.value=TotalAmtPaid.toFixed(2);
	    document.form1.txtTotalAmtDue.value=TotalAmtDue.toFixed(2);
	    var Money=ToMoney(TotalAmtPaid);
	    document.form1.txtMoney.value=Money;
   }
    
    function DeleteClick(){
    
        var PrintID=document.form1.hPrintID.value;
        if(PrintID!="" ){
	        if (confirm("Do you want to delete this payment? \r\nPlease, click on yes/no to continue.")){
		        document.form1.action="pay_bills.asp?DeleteCheck=yes" +"&WindowName=" +window.name;
		        document.form1.method="POST";
		        document.form1.target="_self";
		        form1.submit();
	        }
        }
    }
</script>
<script type="text/vbscript">

    

    Sub MenuMouseOver()
        document.form1.lstBank.style.visibility="hidden"
    End Sub
    
    Sub MenuMouseOut()
        document.form1.lstBank.style.visibility="visible"
    End Sub

</script>
<script type="text/javascript">
    function BalChange(){
        var sindex=document.form1.lstBank.selectedIndex;
        var tmpStr=document.form1.lstBank.item(sindex).value;
        var CheckNo,Bal;
        var pos=tmpStr.indexOf("^");
        if (pos>=0 )
	        tmpStr = tmpStr.substring(pos+1,200);
        
        pos=tmpStr.indexOf("^");
        if (pos>=0 ){
	        Bal = tmpStr.substring(0,pos);
	        CheckNo = tmpStr.substring(pos+1, tmpStr.length);
        }
        document.form1.txtAcctBalance.value=Bal;
        
        <% if Not EditCheck = "yes" then %> 
        document.form1.hCheckNo.value = CheckNo;
        if ( !document.form1.cToBePrint.checked )
	        document.form1.txtCheck.value = document.form1.hCheckNo.value;

        <% End If %>
    }
    function make_money_string(){
	    var NoItem=parseInt(document.form1.hNoItem.value);
	    var Amt=0;
	    for (var i=0 ; i< NoItem; i++){
		    if ($("input.BillCheck").get(i).checked ){
                //alert($("input.BillAmtDue").get(i).value);
                
			    var BillAmtDue=parseFloat(replaceAll(',', '', $("input.BillAmtDue").get(i).value));
               // alert(BillAmtDue);
			    if ($("input.BillAmtPaid").get(i).value==0 )
				    $("input.BillAmtPaid").get(i).value=BillAmtDue;
			    Amt=Amt+parseFloat(replaceAll(',', '', $("input.BillAmtPaid").get(i).value));
                
		    }else{
                $("input.BillAmtPaid").get(i).value=0;
            }
	    }
	    document.form1.txtAmount.value=parseFloat(Amt).toFixed(2);//formatnumber(Amt,2,,,0)
	    document.form1.txtTotalAmtPaid.value=parseFloat(Amt).toFixed(2);//formatnumber(Amt,2,,,0)
	    var Money=ToMoney(Amt);
	    document.form1.txtMoney.value=Money;
    }
    function PageLoad(){
        <% if  EditCheck = "yes" then %>
	    make_money_string();
        <% end if %>

        
        var EditCheck = "<%=EditCheck%>";

        pmtChange()
        if ("<%=EditCheck%>" != "yes" )
	        ToBePrintClick()
        else{
	        if (document.form1.txtCheck.value=="" || document.form1.txtCheck.value=="0" )
		        document.form1.cToBePrint.checked=true;
	        else
		        document.form1.cToBePrint.checked=false;
        }
    }
     
</script>
<% If CheckQueueID <> "" Then %>

<script type="text/javascript">
    makeAllReadOnly(document.getElementById("tbl_top_options"));
    makeAllReadOnly(document.getElementById("tblCheck"));
</script>

<% End If %>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
