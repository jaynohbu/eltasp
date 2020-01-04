<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% Option Explicit %>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/header.asp" -->
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_Util_Ver_2.inc" -->
<% 
    Dim rs, SQL
    Set rs = Server.CreateObject("ADODB.Recordset")

    Dim isVendor,VendorNo,Save,AddItem,DeleteItem,CheckQueueID,EditCheck
    Dim BillDueDate(256),BillInvoiceNo(256),BillAmtDue(256),BillAmtPaid(256),BillLastPaid(256)
    Dim BillMemo(256),BillAmt(256),BillCheck(256),BillNo(256),BillExpenseAcct(256),BillItemNo(256)
    Dim BillItemValue(256),BillItemLabel(256)
    Dim BankAcct(64),BankAcctName(64),dpBal(64)
    Dim ExpenseAcct(128),ExpenseName(128)
    Dim APAcct(64),APName(64)
    Dim CheckNo,CheckInfo,CheckDate,CheckMoney,CheckAmt
    Dim SeqNo,vDate,vMemo,vBank,vCheck,vAmount,Branch,BCustomer,BankAcctNo,vLastAmount,EditBill
    dim NoItem,ddIndex,vAP,vAPDesc,PrintID
    Dim DefaultItems,VendorItems
    Dim VendorName,v_print_check_as,vNextCheckNo
    DIM ChkHashTable,tempTable
    DIM check_void,check_complete,bankIndex,PrintOK,TranNo,tNo,exIndex,BankType
    Dim apIndex,ItemIndex,tIndex,last_date,first_date,i,j,vPrintPort,vAcctBalance
    Dim iMoonDefaultValue,iMoonDefaultValueInfo,iMoonDefaultValueHidden,iMoonComboBoxName
    Dim iMoonComboBoxWidth,iMoonHiddenField,iMoonTextArea,iMoonType,iMoonRelatedArea
    Dim custom_Change_evt,orgList,vVendorInfo,TotalBillAmtDue,TotalBillAmtPaid
    Dim pos,TotalAmount,OrigCheckAmt,OldBank,bal,epBalance,BillType
    Dim PrintNow
    
    Set DefaultItems = Server.CreateObject("System.Collections.ArrayList")
    Set VendorItems = Server.CreateObject("System.Collections.ArrayList")
    
    '// Transaction Added By Joon on Oct,30 2007 /////////////////////////////////
    eltConn.BeginTrans

    Call GetCostExpenseItems
    Call MainProcess
    Call GetCheckInfo
    Call FormatOutput
    
    eltConn.CommitTrans
%>
<!-- #INCLUDE FILE="functions_for_ap.inc" -->
<%
    
    Sub GetAllParameters
        isVendor=Request.QueryString("Vendor")
        VendorNo=Request("hVendorAcct")
        VendorName=Request("lstVendorName")
        BankAcctNo=Request("lstBank")
        If BankAcctNo="" Or IsNull(BankAcctNo) Then
	        BankAcctNo=0
        Else
	        pos=0
	        pos=instr(BankAcctNo,"^")
	        IF pos>0 Then
		        BankAcctNo=CLng(Mid(BankAcctNo,1,pos-1))
	        Else
		        BankAcctNo=CLng(BankAcctNo)
	        End if
        End If
        If BankAcctNo=0 Then
	        BankAcctNo=CLng(Request.QueryString("Bank"))
        End If
        
        AddItem=Request.QueryString("AddItem")
        DeleteItem=Request.QueryString("DeleteItem")
        Save=Request.QueryString("save")
        CheckQueueID=Request.QueryString("CheckQueueID")
        EditCheck=Request.QueryString("EditCheck")
        PrintID=Request("hPrintID")
        if CheckQueueID="" then CheckQueueID=PrintID
        PrintOK=Request.QueryString("Print")
        EditBill=Request("hEditBill")
        vNextCheckNo=Request.QueryString("NextCheckNo")
        
        TranNo=Session("TranNo")
        if TranNo="" then
	        Session("TranNo")=0
	        TranNo=0
        end if
        tNo=Clng(Request.QueryString("tNo"))
    End Sub
    
    Sub GetBilledItems
        Dim ItemInfo
    
        v_print_check_as=Request("txt_print_check_as")
        vVendorInfo=Request("txtVendorInfo")
        vBank=BankAcctNo
        vCheck=checkBlank(Request("txtCheck"),0)
        vDate=Request("txtDate")
        vAmount=Request("txtAmount")
        vMemo=Request("txtMemo")
	    TotalAmount=checkBlank(TotalAmount,0)
        NoItem=Request("hNoItem")
        NoItem=ConvertAnyValue(NoItem,"Integer",0)
        TotalBillAmtDue=0
        TotalBillAmtPaid=0

        If AddItem="yes" then
            vAmount=0
        End If

	    For i=0 to NoItem-1
            BillNo(i)=checkBlank(Request("hBillNo" & i),0)
	        BillDueDate(i)=checkBlank(Request("txtBillDueDate" & i),vDate)
	        BillInvoiceNo(i)=Request("txtBillInvoiceNo" & i)
	        BillAmt(i)=Request("txtBillAmt" & i)
	        BillAmtDue(i)=Request("txtBillAmtDue" & i)
	        BillAmtPaid(i)=ConvertAnyValue(Request("txtBillAmtPaid" & i),"Double",0)
	        BillLastPaid(i)=ConvertAnyValue(Request("txtBillLastPaid" & i),"Double",0)
	        ItemInfo=Request("hCostExpenseItemName" & i)
	        BillItemValue(i) = ItemInfo
	        pos=instr(ItemInfo,"-")
	        If pos>0 Then
		        BillItemNo(i)=Mid(ItemInfo,1,pos-1)
		        BillExpenseAcct(i)=Mid(ItemInfo,pos+1,100)
		        BillItemLabel(i) = GetBillItemLabel(BillItemNo(i),BillExpenseAcct(i))
	        Else
		        BillItemNo(i)=0
		        BillExpenseAcct(i)=0
		        BillItemLabel(i) = ""
	        End If
	        

	        BillMemo(i)=Request("txtBillMemo" & i)
	        BillCheck(i)=Request("cBillCheck" & i)
	        If AddItem="yes" Then 
		        BillCheck(i)="Y"
		        If BillAmtPaid(i)=0 Then
			        BillAmtPaid(i)=cDbl(BillAmtDue(i))
		        end If
		        vAmount=vAmount+BillAmtPaid(i)
	        End If
	        TotalBillAmtDue=TotalBillAmtDue+BillAmtDue(i)
	        TotalBillAmtPaid=TotalBillAmtPaid+BillAmtPaid(i)
        Next
        
        tIndex=NoItem
        
        If DeleteItem="yes" then
	        dItemNo=Request.QueryString("dItemNo")
	        dAmtDue=BillAmtDue(dItemNo)
	        dAmtPaid=BillAmtPaid(dItemNo)
	        For i=dItemNo to NoItem-1
		        BillNo(i)=BillNo(i+1)
		        BillDueDate(i)=BillDueDate(i+1)
		        BillInvoiceNo(i)=BillInvoiceNo(i+1)
		        BillAmt(i)=BillAmt(i+1)
		        BillAmtDue(i)=BillAmtDue(i+1)
		        BillAmtPaid(i)=BillAmtPaid(i+1)
		        BillExpenseAcct(i)=BillExpenseAcct(i+1)
		        BillMemo(i)=BillMemo(i+1)
		        BillCheck(i)=BillCheck(i+1)
	        Next
	        TotalBillAmtDue=TotalBillAmtDue-dAmtDue
	        TotalBillAmtPaid=TotalBillAmtPaid-dAmtPaid
	        NoItem=NoItem-1
        End if
        tIndex=NoItem
	        
    End Sub
    
    Sub MainProcess
 
        Call GetAllParameters
        
        '///////////////////////////////////////////////////// by iMoon Jan-20-2007 for multi-check#
        If Save = "yes" Then
            Call check_number_update(BankAcctNo, vNextCheckNo)
        End If
        '///////////////////////////////////////////////////// by iMoon Jan-20-2007 for multi-check#
        	
        Call GetBankInfo
        
        vDate = Date
        tIndex = 0
        vAmount = 0
        vLastAmount = ConvertAnyValue(Request("txtOldAmount"),"Amount",0)

        if PrintOK="save" or PrintOK="now" or PrintOK="later" or AddItem ="yes" or DeleteItem="yes" then
	        
	        Call GetBilledItems
	        
	        if (PrintOK="save" or PrintOK="later" or PrintOK="now") and TranNo=tNo then
  		        Session("TranNo") = Clng(Session("TranNo")) + 1
		        TranNo=Clng(Session("TranNo"))
		        if PrintOK="now" then
			        CheckNo=vCheck
			        CheckDate=vDate
			        CheckAmt=vAmount
			        CheckInfo=vVendorInfo
			        CheckMoney=Request("txtMoney")
			        PrintNow="yes"
		        end if
        		
                'insert to check_queue table
		        if PrintID="" then
			        SQL= "select max(print_id) as PrintID from check_queue where elt_account_number = " & elt_account_number
			        rs.CursorLocation = adUseClient
			        rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
			        Set rs.activeConnection = Nothing
			        If Not rs.EOF And IsNull(rs("PrintID"))=False Then
				        PrintID = CLng(rs("PrintID")) + 1
			        Else
				        PrintID=1
			        End If
			        rs.Close
		        end if
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
		        rs("check_type")="C"
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
		        rs("pmt_method")="Check"
		        rs.Update
		        rs.Close
        		
                'insert to bill table
		        for i=0 to NoItem-1
			        if BillCheck(i)="Y" then
				        'new bill
				        if BillNo(i)="0" Or Trim(BillNo(i))="" then
					        SQL= "select max(bill_number) as BillNo from bill where elt_account_number = " & elt_account_number
					        rs.CursorLocation = adUseClient
					        rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
					        Set rs.activeConnection = Nothing
					        If Not rs.EOF And IsNull(rs("BillNo"))=False Then
						        BillNo(i) = CLng(rs("BillNo")) + 1
					        Else
						        BillNo(i)=1
					        End If
					        rs.Close
				        end if
				        SQL= "select * from bill where elt_account_number = " & elt_account_number & " and bill_number=" & BillNo(i)
				        rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
				        If rs.EOF then
					        rs.AddNew
					        rs("elt_account_number")=elt_account_number
					        rs("bill_number")=BillNo(i)
					        rs("bill_type")="D"
					        rs("vendor_number")=VendorNo
					        rs("vendor_name")=VendorName
				        end if
				        rs("bill_date")=vDate
				        rs("bill_due_date")=BillDueDate(i)
				        rs("bill_amt")=replace(BillAmt(i),",","")
				        rs("bill_amt_paid")=replace(BillAmtPaid(i),",","")
				        bal=BillAmt(i)-BillAmtPaid(i)
				        
				        '// Uncomment following to disable negative balance
				        'If bal < 0 Then
					    '    eltConn.RollbackTrans
					    '    Response.Write("<script> alert('Please, make sure the balance is greater than the amount paid!'); window.location.href='" & Request.ServerVariables("URL") & "'; </script>")
					    '    Response.End()
					    'End If
				        rs("ref_no")=BillInvoiceNo(i)
				        rs("bill_amt_due")=replace(bal,",","")
				        if bal=0 then
					        rs("bill_status")="N"
				        else
					        rs("bill_status")="A"
				        end if
				        rs("bill_expense_acct")=BillExpenseAcct(i)
				        rs("bill_ap")=0
				        rs("print_id")=PrintID
				        rs("pmt_method")="Check"
				        rs.Update
				        rs.Close
        				
                        'insert to bill_detail table
				        SQL= "select * from bill_Detail where elt_account_number = " & elt_account_number & " and bill_number=" & BillNo(i) & " and item_id=100"		
				        rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
				        If rs.EOF Then
					        rs.AddNew
					        rs("elt_account_number")=elt_account_number
					        rs("bill_number")=BillNo(i)
					        rs("item_id")=100
					        rs("item_amt_origin")=replace(BillAmt(i),",","")
				        end if
				        rs("invoice_no")=0
				        rs("vendor_number")=VendorNo
				        rs("item_no")=BillItemNo(i)
				        rs("item_expense_acct")=BillExpenseAcct(i)
				        rs("item_amt")=replace(BillAmt(i),",","")
				        rs("item_ap")=vAP
				        rs("tran_date")=vDate
				        rs.Update
				        rs.Close
			        elseif BillNo(i)>0 then
                        'delete from bill table if BillNo(i)>0
				        SQL= "delete from bill where elt_account_number = " & elt_account_number & " and bill_number=" & BillNo(i)
				        eltConn.Execute SQL
                        'delete from bill_detail table if BillNo(i)>0
				        SQL= "delete from bill_detail where elt_account_number = " & elt_account_number & " and bill_number=" & BillNo(i)
				        eltConn.Execute SQL
			        end if
		        next

		        Call reset_payment_for_void(NoItem) 
		        Call delete_all_accounts_journal
		        Call insert_all_accounts_journal_Bank
		        Call update_gl_expense_balance_and_insert_all_accounts
		        Call update_gl_bank_balance

	        end if
	        If (PrintOK="save" or PrintOK="later" or PrintOK="now") Then
		        tIndex=0
		        BillCheck(0)=""
		        BillDueDate(0)=""
		        BillInvoiceNo(0)=""
		        BillAmt(0)=0
		        BillAmtDue(0)=0
		        BillAmtPaid(0)=0
		        BillItemNo(0)=0
		        BillItemValue(0)=""
		        BillItemLabel(0)=""
		        BillMemo(0)=""
		        TotalBillAmtDue=0
		        TotalBillAmtPaid=0
		        vAmount=0
	        End if
        End If
    End Sub

    Sub GetCheckInfo
    
        if EditBill="TRUE" and NOT AddItem = "yes" then
	        EditCheck="yes"
        end if
        	
        EditBill="False"

        if EditCheck="yes" and not CheckQueueID="" then
            '// get check info
	        SQL= "select * from check_queue where elt_account_number = " & elt_account_number & " and print_id=" & CheckQueueID
	        rs.CursorLocation = adUseClient
	        rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	        Set rs.activeConnection = Nothing
	        if Not rs.EOF then
		        vCheck=rs("check_no")
		        vAmount=rs("check_amt")
		        VendorNo=rs("vendor_number")
		        VendorName=rs("vendor_name")
		        v_print_check_as=rs("print_check_as")
		        vVendorInfo=rs("vendor_info")
		        BankAcctNo=rs("bank")
		        vDate=rs("bill_date")
		        vMemo=rs("memo")
	        end if
	        rs.Close()

            '// get bill info
	        SQL= "select a.*,b.item_no from bill a,bill_detail b where a.elt_account_number=b.elt_account_number and a.elt_account_number=" _
	            & elt_account_number & " and a.bill_number=b.bill_number and b.item_id=100 and a.print_id=" & CheckQueueID
	        rs.CursorLocation = adUseClient
	        rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	        Set rs.activeConnection = Nothing
	        TotalBillAmtDue=0
	        TotalBillAmtPaid=0
	        tIndex=0
	        Do While Not rs.EOF
		        BillCheck(tIndex)="Y"
		        BillNo(tIndex)=rs("bill_number")
		        BillDueDate(tIndex)=rs("bill_due_date")
		        BillInvoiceNo(tIndex)=rs("ref_no")
		        BillAmt(tIndex)=rs("bill_amt")
		        BillType=rs("bill_type")
		        if BillType="C" then 
			        BillAmt(tIndex)=-BillAmt(tIndex)
			        BillAmtDue(tIndex)=-BillAmtDue(tIndex)
		        end if
		        BillAmtPaid(tIndex)=cdbl(rs("bill_amt_paid"))
		        TotalBillAmtPaid=TotalBillAmtPaid+BillAmtPaid(tIndex)
		        BillAmtDue(tIndex)=cdbl(rs("bill_amt_due"))+cdbl(rs("bill_amt_paid"))
		        TotalBillAmtDue=TotalBillAmtDue+BillAmtDue(tIndex)
		        BillExpenseAcct(tIndex)=cLng(rs("bill_expense_acct"))
		        BillItemNo(tIndex)=rs("item_no")
		        vAmount=TotalBillAmtPaid
		        BillItemValue(tIndex) = BillItemNo(tIndex) & "-" & BillExpenseAcct(tIndex)
		        BillItemLabel(tIndex) = getBillItemLabel(BillItemNo(tIndex),BillExpenseAcct(tIndex))
		        tIndex=tIndex+1
		        rs.MoveNext
	        Loop
	        rs.Close
	        BillNo(tIndex)=""
	        BillDueDate(tIndex)=""
	        BillInvoiceNo(tIndex)=""
	        BillAmt(tIndex)=""
	        BillAmtDue(tIndex)=""
	        BillAmtPaid(tIndex)=""
	        BillExpenseAcct(tIndex)=""
	        BillMemo(tIndex)=""
	        BillCheck(tIndex)=""
	        BillItemValue(tIndex) = ""
	        EditBill="TRUE"
        end if

        last_date = get_fiscal_year_of_last_date( year(date) )
        first_date = get_fiscal_year_of_first_date( last_date )

        '// get bank balance
        SQL= "select a.gl_account_number as gl,sum(a.credit_amount+a.debit_amount+ISNULL(a.debit_memo,0)+ISNULL(a.credit_memo,0)) as balance " _
            & "from all_accounts_journal a, gl b where a.elt_account_number=b.elt_account_number and a.elt_account_number= " _
            & elt_account_number  & " and a.gl_account_number=b.gl_account_number and b.gl_account_type='" _
            & CONST__BANK&"' and a.tran_date >='" & first_date & "' and a.tran_date >='" & first_date _
            & "' and a.tran_date < DATEADD(day, 1,'"& last_date &"') " _
            & "Group by a.gl_account_number order by a.gl_account_number"

        rs.CursorLocation = adUseClient
        rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
        Set rs.activeConnection = Nothing
        BankAcctNo=cLng(BankAcctNo)
        Do While Not rs.EOF
	        if BankAcctNo=0 then 
		        BankAcctNo=cLng(rs("gl"))
	        end if	
	        for i = 0 to bankIndex
		        if BankAcct(i) = cLng(rs("gl")) then
			        dpBal(i)=rs("balance")
			        exit for
		        end if
	        next
	        rs.MoveNext
        Loop
        rs.Close()

        vPrintPort=checkPort
        check_void = check_find_void("CHK",CheckQueueID)		
        check_complete = check_find_complete("CHK",CheckQueueID)	
    End Sub

    '// Other subs start here //////////////////////////////////////////////////////////////////////
    SUB update_gl_expense_balance_and_insert_all_accounts
    'update GL expense accounts
		for i=0 to NoItem-1
			if BillCheck(i)="Y" then
				SQL= "select gl_account_balance from gl where elt_account_number = " & elt_account_number & " and gl_account_number=" & BillExpenseAcct(i)				
				rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText

				if not rs.EOF then
					if Not IsNull(rs("gl_account_balance")) then
						if EditBill="TRUE" then
							epBalance=Cdbl(rs("gl_account_balance"))-BillLastPaid(i)+BillAmtPaid(i)
						else
							epBalance=Cdbl(rs("gl_account_balance"))+BillAmtPaid(i)					
						end if	
					Else
						epBalance=BillAmtPaid(i)
					End if
					
					rs("gl_account_balance")=epBalance
					rs.Update
				end if
				rs.Close
				
                'insert to all_accounts_journal for expense accounts
				SQL= "select * from all_accounts_journal where elt_account_number = " & elt_account_number & " and tran_seq_num=" & SeqNo
				rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
				'rs.Open "all_accounts_journal", eltConn, adOpenDynamic, adLockPessimistic, adCmdTable
				if rs.eof then
					rs.AddNew
					rs("elt_account_number")=elt_account_number
					rs("gl_account_number")=BillExpenseAcct(i)
					rs("gl_account_name")=GetGLDesc(BillExpenseAcct(i))
					rs("tran_seq_num")=SeqNo
					SeqNo=SeqNo+1
					rs("tran_type")="CHK"
					rs("tran_num")=PrintID
					rs("tran_date")=vDate
					rs("Customer_Number")=VendorNo
					rs("Customer_Name")=VendorName
					rs("print_check_as")=v_print_check_as
					rs("memo")=BillMemo(i)
					rs("split")=GetGLDesc(vBank)
					rs("check_no")=vCheck
					rs("debit_amount")=BillAmtPaid(i)
					rs("credit_amount")=0
					rs.Update
				end if
				rs.Close
			end if
		next
    END SUB

    SUB update_gl_bank_balance
        DIM bankBalance
		'//SQL= "select gl_account_balance from gl where elt_account_number = " & elt_account_number & " and gl_account_number=" & vBank
		
        SQL = "UPDATE gl SET gl_account_balance = b.balance FROM gl a LEFT OUTER JOIN " _
            & "(SELECT b.elt_account_number,b.gl_account_number," _
            & "SUM(b.credit_amount+b.debit_amount+ISNULL(b.debit_memo,0)+ISNULL(b.credit_memo,0)) AS balance " _
            & "FROM all_accounts_journal b GROUP BY b.elt_account_number,b.gl_account_number) b " _
            & "ON (a.elt_account_number=b.elt_account_number AND a.gl_account_number=b.gl_account_number) " _
            & "WHERE a.elt_account_number=" & elt_account_number & " AND a.gl_account_number=" & vBank

        Set rs = eltConn.execute(SQL)    
		'// rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
		'// if not rs.EOF then
        '//     if Not IsNull(rs("gl_account_balance")) then
        '//         if EditBill = "TRUE" then
        '//             bankBalance=cDbl(rs("gl_account_balance"))+vLastAmount-cDbl(vAmount)
        '//         else
        '//             bankBalance=cDbl(rs("gl_account_balance"))-cDbl(vAmount)
        '//         end if	
        '//     else
        '//         bankBalance=-cDbl(vAmount)
        '//     end if			
        '//     rs("gl_account_balance")=bankBalance
        '//     s.Update
	    '// end if
        '// rs.Close()
    END SUB

    SUB insert_all_accounts_journal_Bank
        DIM tmpV
        'insert to all_accounts_journal for bank acct
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
		'rs.Open "all_accounts_journal", eltConn, adOpenDynamic, adLockPessimistic, adCmdTable
		if rs.eof then
			rs.AddNew
			rs("elt_account_number")=elt_account_number
			rs("gl_account_number")=vBank
			rs("gl_account_name")=GetGLDesc(vBank)
			rs("tran_seq_num")=SeqNo
			SeqNo=SeqNo+1
			rs("tran_type")="CHK"
			rs("tran_num")=PrintID
			rs("tran_date")=vDate
			rs("Customer_Number")=VendorNo
			rs("Customer_Name")=VendorName
			rs("print_check_as")=v_print_check_as		
			rs("memo")=vMemo
			rs("split")=GetGLDesc(BillExpenseAcct(0))
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

    SUB delete_all_accounts_journal
	    SQL= "delete from all_accounts_journal where elt_account_number = " & elt_account_number & " and tran_type='CHK' and tran_num=" & PrintID
	    eltConn.Execute SQL		
    END SUB
    
    Sub GetBankInfo
        'get bank info and A/P
        SQL= "select gl_account_type,gl_account_number,gl_account_desc,control_no from gl where elt_account_number = " & elt_account_number & " and (gl_account_type='"&CONST__BANK&"' or gl_account_type='"& CONST__ACCOUNT_PAYABLE &"' or gl_account_type='"&CONST__EXPENSE&"' or gl_account_type='"&CONST__COST_OF_SALES&"' or gl_account_type='"&CONST__OTHER_EXPENSE&"') order by isnull(gl_default,'') desc, cast(gl_account_number as nvarchar)"
        
        rs.CursorLocation = adUseClient
        rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
        Set rs.activeConnection = Nothing

        '///////////////////////////////////////////////////// by iMoon Jan-20-2007 for multi-check#
        
        Set ChkHashTable = Server.CreateObject("System.Collections.HashTable")

        bankIndex=0
        exIndex=0

        Do While Not rs.EOF
	        BankType=rs("gl_account_type")
	        if BankType=CONST__BANK then
		        BankAcct(bankIndex)=clng(rs("gl_account_number"))
		        BankAcctName(bankIndex)=rs("gl_account_desc")
                ChkHashTable.Add BankAcct(bankIndex), rs("control_no").Value
		        bankIndex=bankIndex+1
	        elseif BankType=CONST__ACCOUNT_PAYABLE then
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

        vAP=APACCT(0)
    End Sub
    
    Sub GetCostExpenseItems
        SQL = "(select a.item_name,a.item_no,a.item_desc,a.account_expense,b.gl_account_number,b.gl_account_desc,1 as type " _
            & "from item_cost a left outer join gl b on (a.elt_account_number=b.elt_account_number and a.account_expense=b.gl_account_number) " _
            & "where a.elt_account_number=" & elt_account_number & " and b.gl_master_type='EXPENSE' AND ISNULL(a.account_expense,0)<>0) " _
            & "union " _
            & "(select cast(gl_account_number as nvarchar) as item_name,0 as item_no, gl_account_desc as item_desc,gl_account_number as account_expense," _
            & "gl_account_number, gl_account_desc,0 as type from gl where elt_account_number=" & elt_account_number & " and gl_master_type='EXPENSE') " _
            & "order by account_expense,type,item_desc"
        rs.CursorLocation = adUseClient
        rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
        Set rs.activeConnection = Nothing

        ItemIndex=0

        Do While Not rs.EOF
            Set tempTable = Server.CreateObject("System.Collections.HashTable")
            tempTable("DefaultItemNo") = rs("item_no").Value
            tempTable("DefaultItem") = rs("item_desc").Value
            tempTable("DefaultExpense") = rs("account_expense").Value
            tempTable("DefaultExpenseName") = rs("gl_account_desc").Value
            tempTable("DefaultItemName") = rs("item_name").Value
            DefaultItems.add(tempTable)
            rs.MoveNext
        Loop
        rs.Close
    End Sub
    
    Function getBillItemLabel(vItemNo,vItemExpenseNo)
        Dim resVal,t
        resVal = ""
        
        For t=0 To DefaultItems.Count-1
            If (CStr(DefaultItems(t)("DefaultItemNo")) = CStr(vItemNo)) _
                And (CStr(DefaultItems(t)("DefaultExpense")) = CStr(vItemExpenseNo)) Then
                resVal = DefaultItems(t)("DefaultItemName") & "-" & DefaultItems(t)("DefaultItem")
            End If
        Next
        Set t = Nothing
        getBillItemLabel = resVal
    End Function
    
    Sub FormatOutput
        vAmount = ConvertAnyValue(vAmount,"Amount",0)
        TotalBillAmtDue = ConvertAnyValue(TotalBillAmtDue,"Amount",0)
        TotalBillAmtPaid = ConvertAnyValue(TotalBillAmtPaid,"Amount",0)
    End Sub
    
%>
<!--  #include file="../include/recent_file.asp" -->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
    <title>Write Checks</title>
    <meta http-equiv="Content-Type" content="text/html; charset=windows-1252" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../Include/JPTableDOM.js"></script>
    <script type="text/javascript" src="/ASP/ajaxFunctions/ajax.js"></script>
    <script type="text/javascript" src="../Include/JPED.js"></script>
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
            IV_CustomerChange();
        }
        
        <% For i=0 to tIndex %>
        function lstCostExpenseItemName<%=i %>Change(vValue,vLabel){
            var hiddenObj = document.getElementById("hCostExpenseItemName<%=i %>");
            var txtObj = document.getElementById("lstCostExpenseItemName<%=i %>");
            var divObj = document.getElementById("lstCostExpenseItemName<%=i %>Div");

            hiddenObj.value = vValue;
            txtObj.value = vLabel;
            
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
            divObj.style.height = "0px";
        }
        <% Next %>
    </script>
</head>
<body link="336699" vlink="336699" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"
    onload="vbscript:PageLoad()">
    <form name="form1" method="post">
    <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
        <tr>
            <td width="43%" height="32" align="left" valign="middle" class="pageheader">
                Write checks
            </td>
            <td width="57%" align="right" valign="middle">
                <div id="print">
                    <img src="/ASP/Images/icon_printer.gif" width="40" height="27" align="absbottom"><a
                        href="javascript:;" onclick="SaveClick('PrintNow',<%= TranNo %>);return false;">Print
                        Check Now</a></div>
            </td>
        </tr>
    </table>
    <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#89A979"
        bgcolor="#89A979" class="border1px">
        <tr>
            <td>
                <!-- start of scroll bar -->
                <input type="hidden" name="scrollPositionX">
                <input type="hidden" name="scrollPositionY">
                <!-- end of scroll bar -->
                <input type="hidden" name="hPrintPort" value="<%= vPrintPort %>">
                <input type="hidden" name="hClientOS" value="<%= ClientOS %>">
                <input type="hidden" name="hNoItem" value="<%= tIndex %>">
                <input type="hidden" name="hPrintID" value="<%= CheckQueueID %>">
                <input type="hidden" name="hEditBill" value="<%= EditBill %>">
                <input type="hidden" name="hCheckNo" value="<% if EditCheck = "yes" then response.write vCheck else response.write ChkHashTable(BankAcctNo) end if %>">
                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr bgcolor="D5E8CB">
                        <td colspan="10" height="24" align="center" valign="middle" class="bodyheader">
                            <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td width="50%" align="right" valign="middle">
                                        <img src="../images/button_smallsave.gif" name="bSave2" onclick="SaveClick('Save',<%= TranNo %>)"
                                            style="cursor: hand">
                                    </td>
                                    <td width="50%" align="right" valign="middle">
                                        &nbsp;
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td height="1" colspan="10">
                        </td>
                    </tr>
                    <tr valign="middle" bgcolor="#E7F0E2">
                        <td colspan="10" align="left" bgcolor="#f3f3f3" class="bodycopy">
                            <br>
                            <table border="0" cellspacing="0" cellpadding="0" style="width: 77%; height: 28px">
                                <tr>
                                    <td height="28" align="right">
                                        <span class="bodyheader">
                                            <img src="/ASP/Images/required.gif" align="absbottom">Required field</span>
                                    </td>
                                </tr>
                            </table>
                            <table width="648" border="0" align="center" cellpadding="2" cellspacing="0" bordercolor="#89A979"
                                bgcolor="D5E8CB" class="border1px">
                                <tr align="left" valign="middle" bgcolor="E7F0E2">
                                    <td class="bodycopy">
                                        &nbsp;
                                    </td>
                                    <td width="42%" height="20">
                                        <span class="bodyheader">Bank Account</span>
                                    </td>
                                    <td colspan="-2" class="bodyheader">
                                        Balance&nbsp;
                                    </td>
                                </tr>
                                <tr align="left" valign="middle" bgcolor="E7F0E2">
                                    <td width="1%" bgcolor="#FFFFFF" class="bodycopy">
                                        &nbsp;
                                    </td>
                                    <td bgcolor="#FFFFFF">
                                        <font size="3"><b>
                                            <select name="lstBank" size="1" class="smallselect" style="width: 240px" onchange="BalChange()">
                                                <% for i=0 to bankIndex-1 %>
                                                <option value="<%= BankACCT(i) & "^" & dpBal(i) & "^" & ChkHashTable(BankAcct(i))%>"
                                                    <% if cLng(BankAcctNo)=cLng(BankAcct(i)) then response.write("selected") %>>
                                                    <%= BankAcctName(i) %>
                                                </option>
                                                <% next %>
                                            </select>
                                        </b></font>&nbsp;&nbsp;&nbsp;&nbsp;
                                    </td>
                                    <td width="57%" colspan="-2" bgcolor="#FFFFFF">
                                        <input name="txtAcctBalance" class="readonlyboldright" value="<%= FormatNumberPlus(vAcctBalance,2) %>"
                                            size="18" style="height:16px;"><input type="hidden"
                                                name="hVendorName" value="<%= VendorName %>">
                                    </td>
                                </tr>
                                <tr align="left" valign="middle" bgcolor="E7F0E2">
                                    <td height="20" bgcolor="#f3f3f3" class="bodycopy">
                                        &nbsp;
                                    </td>
                                    <td height="20" bgcolor="#f3f3f3">
                                        <img src="/ASP/Images/required.gif" align="absbottom"><span class="bodyheader">Company
                                            Name</span>
                                    </td>
                                    <td height="20" colspan="-2" bgcolor="#f3f3f3">
                                    </td>
                                </tr>
                                <tr align="left" valign="middle" bgcolor="E7F0E2">
                                    <td bgcolor="#FFFFFF" class="bodycopy">
                                        &nbsp;
                                    </td>
                                    <td colspan="2" bgcolor="#FFFFFF">
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
                                                        onfocus="initializeJPEDField(this,event);" />
                                                </td>
                                                <td>
                                                    <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstVendorName','Vendor','lstVendorNameChange',null,event)"
                                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                        border-left: 0px solid #7F9DB9; cursor: hand;" />
                                                </td>
                                                <td>
                                                    <input type='hidden' id='quickAdd_output'/>
                                                    <img src="/ig_common/Images/combobox_addnew.gif" alt="" style="cursor: hand; border: 0px"
                                                        onclick="quickAddClient('hVendorAcct','lstVendorName','')" />
                                                </td>
                                            </tr>
                                        </table>
                                        <!-- End JPED -->
                                        <% If CheckQueueID <> "" then%>
                                        <script type="text/javascript">
                                            makeAllReadOnly(document.getElementById("tblVendorName"));
                                        </script>
                                        <% End If %>
                                    </td>
                                </tr>
                            </table>
                            <br />
                            <table width="648" height="261" border="0" align="center" cellpadding="0" cellspacing="0"
                                bordercolor="#89A979" background='/ASP/Images/<%
			  if check_void then response.write "checkback_void.gif" else response.write "checkback.gif"%>'>
                                <tr align="left" valign="top">
                                    <td width="556" height="34" valign="bottom">
                                        &nbsp;
                                    </td>
                                    <td width="90" valign="bottom">
                                        <input name="txtCheck" class="shorttextfield" value="<% if EditCheck = "yes" then response.write vCheck else response.write ChkHashTable(BankAcctNo) end if %>"
                                            size="12">
                                    </td>
                                </tr>
                                <tr align="left" valign="top">
                                    <td width="556" height="31" valign="bottom">
                                        &nbsp;
                                    </td>
                                    <td width="90" valign="bottom">
                                        <input name="txtDate" class="m_shorttextfield date" preset="shortdate" value="<%= vDate %>"
                                            size="12">
                                    </td>
                                </tr>
                                <tr align="left" valign="top">
                                    <td height="29" colspan="2">
                                        <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td width="13%" align="left" valign="bottom">
                                                    &nbsp;
                                                </td>
                                                <td width="61%" align="left" valign="bottom">
                                                    <input name="txt_print_check_as" type="text" id="txt_print_check_as" class="shorttextfield"
                                                        autocomplete="off" style="width: 98%; vertical-align: middle" value="<%=v_print_check_as%>" />
                                                </td>
                                                <td width="4%" align="left" valign="bottom">
                                                    &nbsp;
                                                </td>
                                                <td width="22%" align="left" valign="bottom">
                                                    <input name="txtAmount" class="readonlyboldright" value="<%=vAmount %>" size="15" style="height:16px;" 
                                                        readonly>
                                                    <input type="hidden" name="txtOldAmount" value="<%= vLastAmount %>">
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr align="left" valign="middle">
                                    <td height="39" colspan="2" align="left" valign="top">
                                        <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td width="6%" align="right" valign="bottom">
                                                    &nbsp;
                                                </td>
                                                <td width="94%" align="left" valign="bottom">
                                                    <input name="txtMoney" type="text" class="readonly" size="95" style="height:16px; width:500px;" readonly>
                                                </td>
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
                                                    &nbsp;
                                                </td>
                                                <td align="left" valign="top">
                                                    <textarea name="txtVendorInfo" cols="45" rows="4" class="multilinetextfield" style="height:56px"><%= vVendorInfo %></textarea>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr align="left" valign="middle">
                                    <td height="40" colspan="2" valign="top">
                                        <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td width="6%" height="26" align="left" valign="bottom">
                                                    &nbsp;
                                                </td>
                                                <td width="94%" align="left" valign="bottom">
                                                    <font size="3"><b>
                                                        <input name="txtMemo" class="shorttextfield" value="<%= vMemo %>" size="47" maxlength="35">
                                                    </b></font>
                                                </td>
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
                            <br>
                        </td>
                    </tr>
                    <tr>
                        <td height="2" colspan="10">
                        </td>
                    </tr>
                    <tr valign="middle">
                        <td height="22" align="left" bgcolor="D5E8CB" class="bodyheader">
                            &nbsp;
                        </td>
                        <td align="left" bgcolor="D5E8CB" class="bodyheader">
                            Due Date
                        </td>
                        <td align="left" bgcolor="D5E8CB" class="bodyheader">
                            Invoice No.
                        </td>
                        <td align="left" bgcolor="D5E8CB" class="bodyheader">
                            Bill Amount
                        </td>
                        <td align="left" bgcolor="D5E8CB" class="bodyheader">
                            &nbsp;
                        </td>
                        <td align="left" bgcolor="D5E8CB" class="bodyheader">
                            Amount Due
                        </td>
                        <td align="left" bgcolor="D5E8CB" class="bodyheader">
                            Amount Paid
                        </td>
                        <td align="left" bgcolor="D5E8CB" class="bodyheader">
                            Item Name
                        </td>
                        <td align="left" bgcolor="D5E8CB" class="bodyheader">
                            Memo
                        </td>
                        <td bgcolor="D5E8CB">
                        </td>
                    </tr>
                    <input type="hidden" id="BillAmtPaid">
                    <input type="hidden" id="BillCheck">
                    <input type="hidden" id="BillAmtDue">
                    <input type="hidden" id="BillAmt">
                    <input type="hidden" id="hItemInfo">
                    <input type="hidden" id="hBillNo">
                    <input type="hidden" id="BillMemo">
                    <% for i=0 to tIndex %>
                    <tr valign="middle" bgcolor="#FFFFFF">
                        <td align="center">
                            <input type="checkbox" id="BillCheck" class="BillCheck" name="cBillCheck<%= i %>" onclick="CheckClick(<%= i %>)"
                                <% if BillCheck(i)="Y" then response.write("checked") %> value="Y">
                            <input type="hidden" id="hBillNo"  class="hBillNo" name="hBillNo<%= i %>" value="<%= BillNo(i) %>">
                        </td>
                        <td align="left">
                            <input name="txtBillDueDate<%= i %>" class="m_shorttextfield date" preset="shortdate"
                                value="<%= BillDueDate(i) %>" size="10">
                        </td>
                        <td align="left">
                            <input name="txtBillInvoiceNo<%= i %>" class="shorttextfield" id="txtBillInvoiceNo<%= i %>"
                                value="<%= BillInvoiceNo(i) %>" size="12" onblur="IVChange('<%= i %>', this)"
                                style="behavior: url(../include/igNumChkLeft.htc)">
                        </td>
                        <td align="left">
                            <input id="BillAmt" name="txtBillAmt<%= i %>" size="14" value="<%=ConvertAnyValue(BillAmt(i),"Amount","0.00") %>"
                                class="numberfield BillAmt"  style="height:16px;width: 80px;" />
                        </td>
                        <td align="left">
                            &nbsp;
                        </td>
                        <td align="left">
                            <input id="BillAmtDue" name="txtBillAmtDue<%= i %>" size="14" value="<%=ConvertAnyValue(BillAmtDue(i),"Amount","0.00") %>"
                                onchange="BillChange(<%= i %>)" class="numberfield BillAmtDue" style="height:16px;width: 80px;" />
                        </td>
                        <td align="left">
                            <input id="BillAmtPaid" name="txtBillAmtPaid<%= i %>" size="14" value="<%=ConvertAnyValue(BillAmtPaid(i),"Amount","0.00") %>"
                                onchange="BillChange(<%= i %>)" class="numberfield BillAmtPaid" style=" width: 80px; text-align:right;" />
                            <input type="hidden" name="txtBillLastPaid<%= i %>" size="11" value="<% If Not check_void Then Response.Write(BillAmtPaid(i)) Else Response.Write(0) End If %>">
                        </td>
                        <td align="left">
                            <!-- Start JPED -->
                            <input type="hidden" id="hCostExpenseItemName<%= i %>" name="hCostExpenseItemName<%= i %>"
                                value="<%=BillItemValue(i) %>" />
                            <div id="lstCostExpenseItemName<%= i %>Div">
                            </div>
                            <table cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td>
                                        <input type="text" autocomplete="off" id="lstCostExpenseItemName<%= i %>" name="lstCostExpenseItemName<%= i %>"
                                            value="<%=BillItemLabel(i) %>" class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9;
                                            border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;"
                                            onkeyup="GLItemFill(this,'ExpenseCost','lstCostExpenseItemName<%=i %>Change',140)"
                                            onfocus="initializeJPEDField(this,event);" />
                                    </td>
                                    <td>
                                        <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="GLItemFillAll('lstCostExpenseItemName<%=i %>','ExpenseCost','lstCostExpenseItemName<%=i %>Change',140)"
                                            style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                            border-left: 0px solid #7F9DB9; cursor: hand;" />
                                    </td>
                                </tr>
                            </table>
                            <!-- End JPED -->
                        </td>
                        <td align="left" bgcolor="#FFFFFF" class="bodyheader">
                            <input id="BillMemo" name="txtBillMemo<%= i %>" class="shorttextfield" value="<%= BillMemo(i) %>"
                                size="20" />
                        </td>
                        <td align="left" bgcolor="#FFFFFF" class="bodyheader">
                            <img src="../images/button_add.gif" width="37" height="17" name="bAddItem" onclick="AddItem()"
                                style="cursor: hand" />
                        </td>
                    </tr>
                    <% next %>
                    <tr valign="middle" bgcolor="#F3f3f3">
                        <td align="center">
                            &nbsp;
                        </td>
                        <td height="20" align="left">
                            &nbsp;
                        </td>
                        <td align="left">
                            &nbsp;
                        </td>
                        <td align="right" valign="middle" class="bodyheader">
                            <font color="c16b42">TOTAL</font>
                        </td>
                        <td align="left" class="bodyheader">
                            &nbsp;
                        </td>
                        <td align="left" class="bodyheader">
                            <input name="txtTotalAmtDue" class="readonlyboldright" value="<%= TotalBillAmtDue %>"
                                size="14" style="height:16px;width: 80px;" readonly="readonly">
                        </td>
                        <td align="left" class="bodyheader">
                            <input name="txtTotalAmtPaid" class="readonlyboldright" value="<%= TotalBillAmtPaid %>"
                                size="14" style="height:16px; width: 80px;" readonly="readonly">
                        </td>
                        <td align="left">
                            &nbsp;
                        </td>
                        <td align="left" bgcolor="f3f3f3" class="bodyheader">
                        </td>
                        <td bgcolor="f3f3f3">
                        </td>
                    </tr>
                    <tr valign="middle" bgcolor="#FFFFFF">
                        <td height="20" align="center">
                            <input type="checkbox" name="cToBePrint" onclick="ToBePrintClick()" <%
			if EditCheck = "yes" and Trim(vCheck) <> "0" then response.write " disabled='disabled' "			
			if NOT check_void and NOT check_complete then
			 response.write " value='Y' "
			 response.write "checked"
			end if 
			 %>>
                        </td>
                        <td colspan="2">
                            <span class="bodycopy"><strong>To Be Printed Later </strong></span>
                        </td>
                        <td>
                        </td>
                        <td>
                        </td>
                        <td>
                        </td>
                        <td>
                        </td>
                        <td class="bodyheader">
                        </td>
                        <td>
                        </td>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <td height="1" colspan="10">
                        </td>
                    </tr>
                    <tr valign="middle" bgcolor="#D5E8CB">
                        <td height="24" colspan="10" align="center">
                            <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td align="right" valign="middle" width="50%">
                                        <img src="../images/button_smallsave.gif" name="bSave2" onclick="SaveClick('Save',<%= TranNo %>)"
                                            style="cursor: hand">
                                    </td>
                                    <td width="50%" align="right" class="bodyheader">
                                        <%
					if EditCheck = "yes" or check_complete then
                                        %>
                                        <input id="chk_isCom" name="chk_isCom" type="checkbox" style="cursor: hand" <% 
					if check_complete = "True" then 
						response.write " checked='checked'" 
						response.write " value='Y'" 
					else
						response.write " value=''" 					
					end if	
					%> onclick="javascript:completeCheck(this);" /><label for="chk_isCom">Complete check</label>
                                        <%
					end if
                                        %>
                                        <%
					if EditCheck = "yes" or check_void then
                                        %>
                                        <input id="chk_isVoid" name="chk_isVoid" type="checkbox" style="cursor: hand" <% 
					if check_void = "True" then 
						response.write " checked='checked'" 
						response.write " value='Y'" 
					else
						response.write " value=''" 					
					end if	
					%> onclick="javascript:voidCheck(this);" /><label for="chk_isVoid">Void check</label>
                                        <%
					end if
                                        %>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td height="32" align="right" valign="bottom">
                <div id="print">
                    <img src="/ASP/Images/icon_printer.gif" width="40" height="27" align="absbottom"><a
                        href="javascript:;" onclick="SaveClick('PrintNow',<%= TranNo %>);return false;">Print
                        Check Now</a></div>
            </td>
        </tr>
    </table>
    <br />
    </form>
</body>
<!--  #INCLUDE FILE="../include/shared.asp" -->
<!--  #INCLUDE FILE="../include/print_query_shared.asp" -->
<script type="text/jscript">
    function completeCheck(o) {
        if (o.checked) {
            o.value = 'Y';
        } else {
            o.value = '';
        }
    }

    function voidCheck(o) {
        var NoItem = document.form1.hNoItem.value;
        if (NoItem > 0) {
            if (o.checked) {
                o.value = 'Y';
            } else {
                o.value = '';
            }
        }
    }
</script>
<script type="text/javascript" src="/ASP/ajaxFunctions/ajax_ig_call_db.js">  </script>
<script type="text/javascript">
    
    function PageLoad(){
        <% if  EditCheck = "yes" then %>
        make_money_string();
        <% end if %>
        BalChange();
        
       var EditCheck = "<%=EditCheck%>";

	    if ("<%=EditCheck%>" != "yes" )
		    ToBePrintClick()
	    else{
	        if (document.form1.txtCheck.value=="" || document.form1.txtCheck.value=="0" )
		        document.form1.cToBePrint.checked=true;
	        else
		        document.form1.cToBePrint.checked=false;
        }

        var tmpMoney = "<%= vAmount %>";
        tmpMoney = replaceAll(",","",tmpMoney);
        document.form1.txtMoney.value=ToMoney(tmpMoney);
}
function make_money_string(){
	    var NoItem=parseInt(document.form1.hNoItem.value);
	    var Amt=0;
	    for (var i=0 ; i< NoItem; i++){
		    if ($("input.BillCheck").get(i).checked ){
			
			    if(document.getElementById("hCostExpenseItemName" + i).value == "" ){
				    alert( "Please select an ITEM!");
				    return false;
			    }
			    var BillAmtDue=parseFloat(replaceAll(',', '', $("input.BillAmtDue").get(i).value));
			    if ($("input.BillAmtPaid").get(i).value==0 )
				    $("input.BillAmtPaid").get(i).value=BillAmtDue;
			    Amt=Amt+parseFloat(replaceAll(',', '', $("input.BillAmtPaid").get(i).value));
		    }
	    }
	    document.form1.txtAmount.value=parseFloat(Amt).toFixed(2);
	    document.form1.txtTotalAmtPaid.value=parseFloat(Amt).toFixed(2);
	     var Money=ToMoney(Amt)
	    document.form1.txtMoney.value=Money;
}


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
        
        if (Bal != "")
            document.form1.txtAcctBalance.value = parseFloat(Bal).toFixed(2);
        else
            document.form1.txtAcctBalance.value = "";

        
        <% if Not EditCheck = "yes" then %> 
        document.form1.hCheckNo.value = CheckNo;
        if ( !document.form1.cToBePrint.checked )
	        document.form1.txtCheck.value = document.form1.hCheckNo.value;
        <% End If %>
    }
    function IVChange( nL, str ){
        $("input.hBillNo").get(nL).value = str.value;
    }
    function docModified(dummy){
    }
    function IV_CustomerChange(){
        var strPrintAs;
        document.form1.hVendorName.value = document.form1.lstVendorName.value;
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
	    var NoItem=parseInt(document.form1.hNoItem.value);
        var Amt=0;
        var TotalAmtPaid=0;
	    if ( (k) != NoItem ){
		    if ($("input.BillCheck").get(k).checked){
			    $("input.BillCheck").get(k).value="Y";
			    var BillAmtDue=parseFloat(replaceAll(',', '', $("input.BillAmtDue").get(k).value));
                $("input.BillAmtPaid").get(k).value=BillAmtDue;
            }
		    else
            {
			    $("input.BillCheck").get(k).value="N";
			    Amt=document.form1.txtAmount.value;
			    var BillAmtDue=parseFloat(replaceAll(',', '', $("input.BillAmtDue").get(k).value));
			    $("input.BillAmtPaid").get(k).value=0;
		   }
		    var TotalAmtPaid=0;
		    for (var i=0 ; i< NoItem; i++){
			    if( $("input.BillCheck").get(i).checked){
				    Amt=parseFloat(replaceAll(',', '', $("input.BillAmtPaid").get(i).value));
				    TotalAmtPaid=TotalAmtPaid+Amt;
			    }
		    }
		    document.form1.txtAmount.value= parseFloat(TotalAmtPaid).toFixed(2);// formatNumber(TotalAmtPaid,2,,,0)
		    document.form1.txtTotalAmtPaid.value= parseFloat(TotalAmtPaid).toFixed(2); //formatNumber(TotalAmtPaid,2,,,0)
	    }
        var Money=ToMoney(TotalAmtPaid);
	    document.form1.txtMoney.value=Money;
    }
    function SaveClick(SaveorPrint,TranNo){
        make_money_string();

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
        var aItem = new Array();
        if (SaveorPrint == "PrintNow" )
	        document.form1.cToBePrint.checked=false;

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
        else if (document.form1.cToBePrint.checked==false 
                && document.form1.txtCheck.value=="" )
	        alert( "Please enter a check number!");
        else
        {
	        for (var k=0 ; k< NoItem; k++){
		        if ($("input.BillCheck").get(k).checked ) 
			        save="yes";
		        aItem[k]="INV#: " + $("input.hBillNo").get(k).value+ ": " +"$" 
                + parseFloat(replaceAll(",","",$("input.BillAmt").get(k).value)).toFixed(2);

	        }
	        for (var k=0 ; k< NoItem; k++){

		        if ($("input.BillAmtPaid").get(k).value == "" ) 
                    $("input.BillAmtPaid").get(k).value = "0.00";
		        if ($("input.BillAmtDue").get(k).value== "" ) 
                    $("input.BillAmtDue").get(k).value = "0.00";
		        if ($("input.BillAmt").get(k).value== "" ) 
                    $("input.BillAmt").get(k).value = "0.00";

		        if ($("input.BillCheck").get(k).checked 
                && (parseFloat(replaceAll(',', '', $("input.BillAmtPaid").get(k).value))>parseFloat(replaceAll(',', '', $("input.BillAmtDue").get(k).value))) ){
			        alert( "Amt Paid is more than Amt Due. Please correct it.");
			        return false;
		        }
		        if(parseFloat(replaceAll(',', '', $("input.BillAmt").get(k).value))==0) 
			        $("input.BillAmt").get(k).value = $("input.BillAmtDue").get(k).value;
	        }
	        if (save=="yes" ){
		        var CheckNo="";
		        if (pPrint=="now" ){
			        CheckNo=document.form1.txtCheck.value;
			        if ( CheckNo!="" ) 
                        CheckNo=new Number(CheckNo);
			        var CheckDate=document.form1.txtDate.value;
			        var Vendor=document.form1.txtVendorInfo.value;
			        var CheckAmt=document.form1.txtAmount.value;
			        var Money=document.form1.txtMoney.value;
			        var vPrintPort=document.form1.hPrintPort.value;
			        var ClientOS=document.form1.hClientOS.value;
			        var vMemo=document.form1.txtMemo.value;

			        NoItem=parseInt(document.form1.hNoItem.value);
			        var iCnt = 0;
			        for (var i=0; i < NoItem; i++){
				        if ($("input.BillCheck").get(i).checked)
					        iCnt = iCnt + 1;
			        }
        			
        ///////////////////////////////////////////////// New logic of Check Printing  by iMoon Nov-13-2006
			        var wOptions = "dialogWidth:700px; dialogHeight:600px; help:no; status:no; scroll:no;center:yes"
			        var popUpCheck = showModalDialog("check_Dialog_frame.asp?PostBack=false&cType=one&aItem="+iCnt,"self", wOptions);
        //////////////////////////////////////////////////////////////////////////////////////////////////////
			        var nextAction = checkPrintStopSingle( CheckNo );
			        if (nextAction != 0 )
				        return false;
			        else
				        CheckNo=CheckNo+1;
		        }
		        document.form1.action="write_chk.asp?save=yes&Print=" + pPrint+ "&tNo=<%=TranNo %>&NextCheckNo=" + CheckNo + "&WindowName="+ window.name;
		        document.form1.method="POST";
		        document.form1.target="_self";
		        document.form1.submit();
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
		    var AmtDue=parseFloat(replaceAll(',', '', $("input.BillAmtDue").get(i).value));
		    if ($("input.BillCheck").get(i).checked)
			    TotalAmtPaid=TotalAmtPaid+AmtPaid;
		    
		    TotalAmtDue=TotalAmtDue+AmtDue	;
	    }
	    document.form1.txtAmount.value=TotalAmtPaid.toFixed(2);
	    document.form1.txtTotalAmtPaid.value=TotalAmtPaid.toFixed(2);
	    document.form1.txtTotalAmtDue.value=TotalAmtDue.toFixed(2);
	     var Money=ToMoney(TotalAmtPaid);
	    document.form1.txtMoney.value=Money;
    }
    function AddItem() {
        var NoItem=parseInt(document.form1.hNoItem.value);
        if ($("input.BillAmt").get(NoItem).value=="" )
	        alert( "Please enter the bill amt!");
        else if ($("input.BillAmtDue").get(NoItem).value=="" )
	        alert( "Please enter the bill due amt!");
        else if (document.getElementById("hCostExpenseItemName" + NoItem).value=="" )
	        alert( "Please select an ITEM!");
        else{
	        document.form1.hNoItem.value=NoItem+1;
	        document.form1.action="write_chk.asp?AddItem=yes" + "&WindowName=" + window.name;
	        document.form1.method="POST";
	        document.form1.target="_self";
	        form1.submit();
        }
    }
    
    function DeleteItem(ItemNo){
    //	'MsgBox document.form1.hNoItem.Value
	    if (document.form1.hNoItem.value>0 
            &&  parseInt(document.form1.hNoItem.value)!=ItemNo ){
		    document.form1.action="write_chk.asp?DeleteItem=yes&dItemNo=" + ItemNo + "&WindowName=" + window.name;
		    document.form1.method="POST";
		    document.form1.target="_self";
		    form1.submit();
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
    -->
</script>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
