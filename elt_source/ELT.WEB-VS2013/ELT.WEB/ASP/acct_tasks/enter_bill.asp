
<!--  #INCLUDE FILE="../include/transaction.txt" -->

<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/header.asp" -->
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->

<%
    '////////////////////////////////////////////////////////////////////////////
    '// Fully Inspected and modified by Joon on Jan 23, 2008
    '// 1. Payable queue and bill management is broken up into sub functions.
    '// 2. Transaction data handling is implemented as well.
    '// 3. Variable definitions are done at the beginning and validated using 'option explicit'
    '// 4. New AJAX call is added to improve deleting item process
    '// 5. Limitation on item arrays are increased from 512 to 2040
    '////////////////////////////////////////////////////////////////////////////
    Dim rs,SQL,TranNo,tNo,ViewBill,DeleteBill,NewIVNum
    Dim venIndex,BCustomer,BillType,Branch,vAmountDue
    Dim isVendor,VendorNo,Save,AddItem,BillNo,CHGIV,vAP
    Dim ItemIndex,vVendorName,custom_Change_evt,orgList,vDate,vDueDate,vRefNo,vAmount
    Dim iMoonDefaultValue,iMoonDefaultInfo,iMoonDefaultValueInfo,iMoonDefaultValueHidden
    Dim iMoonComboBoxName,iMoonComboBoxWidth,iMoonHiddenField,iMoonTextArea,iMoonType,iMoonRelatedArea
    Dim tmpIV,hString,i,j,ExpenseAcct,TotalAmount,NoItem,Info,pos,TotalOrigBillAmt,OrigBillAmt
    Dim tmpItem,tmpItemID,iii,tmpItemDesc,apPBalance,apBalance,SeqNo,epBalance,epPBalance
    Dim APName(32),APACCT(32),apIndex,hAPAcct,glType
    Dim DefaultItem,DefaultItemNo,DefaultRevenue,DefaultExpense,DefaultItemDesc,igDefaultItem,igItemType
    '///////////////////////////////////////////////////////////////////////////////////////////
    Dim ItemDate(2040),ItemID(2040),ItemInvoice(2040),ItemNo(2040),ItemInfo(2040),ItemRef(2040)
    Dim ItemDomeHAWB(2040),ItemMAWB(2040),ItemType(2040),ItemAgentDebitNo(2040)
    Dim ItemAmt(2040),ItemExpense(2040),OrigItemAmt(2040),ItemCheck(2040),ItemFileNo(2040),ItemAmtOrigin(2040),ItemDisputeAmt(2040)
    '///////////////////////////////////////////////////////////////////////////////////////////
    Dim vQueueCount,TotalAmtDim,TotalAmt,tIndex,vLock,InvoiceNo,DItemInfo,DInfo,DItemID,DItemCheck,DItemMAWB
    
    eltConn.BeginTrans()

    Call MainSub
    
    eltConn.CommitTrans()
    
    '/////////////////////////////////////////////////////////////////////////////
    
    Sub MainSub
        Set rs = Server.CreateObject("ADODB.Recordset")
        Branch=Request.QueryString("Branch")
        
        Call GetAllGLAccounts
        Call GetAllCostItems
        
        '// Need to review this block - Inspected by Joon on Jan 22, 2008 //////////
        BCustomer = Request.QueryString("BCustomer")
        BCustomer = replace(BCustomer,"^","&")
        BCustomer = replace(BCustomer,"?"," ")
        
        '// Transaction handling
        TranNo=Session("TranNo")
        If TranNo="" then
            Session("TranNo")=0
            TranNo=0
        End If
        tNo=Clng(Request.QueryString("tNo"))
        
        '// Parameter handling
        BillType=Request("rCredit")
        If Not BillType="credit" Then BillType="debit"
        ViewBill=Request.QueryString("ViewBill")
        isVendor=Request.QueryString("Vendor")
        AddItem=Request.QueryString("AddItem")
        DeleteBill=Request.QueryString("DeleteBill")
        BillNo=Request("txtBillNo")
        Save=Request.QueryString("save")
        CHGIV=Request.QueryString("CHGIV")
        vAP=checkBlank(Request("lstAP"),0)
        VendorNo=checkBlank(Request("hVendorAcct"),0)
        vVendorName=Request("lstVendorName")
        
        vAP=cLng(vAP)
        VendorNo=cLng(VendorNo)
        tIndex=0
        '// Saving and adding items ////////////////////////////////////////////////////////
        '///////////////////////////////////////////////////////////////////////////////////
        If Save="yes" Or AddItem ="yes" Then
            Call GetPostedItems
            Call CheckBillLock    
        	
    	    if Save="yes" And TranNo=tNo then
    	        Call UpdateBillSub
		        Call UpdateBillDetail
                Call UpdateGLRelation
            End If
        End If
        '// Deleting Bill /////////////////////////////////////////////////////////////////////
        '//////////////////////////////////////////////////////////////////////////////////////
        If Not BillNo="" And DeleteBill="yes" then
            Call DeleteBillSub
            Response.Write("<script>window.close();</script>")
        End If
        
        '// Preparing for displaying //////////////////////////////////////////////////////////
        '//////////////////////////////////////////////////////////////////////////////////////
        Call PageLoad
        
    End Sub
    
    '// Block for all Subs /////////////////////////////////////////////////////////////////////
    
    Sub UPDATE_AGENT_DEBIT_STATUS( tmpMAWB, tmpVendorNo, tmpItemID, tmpAmount, tmpAgentDebitNo, status_code, itemOrigiAmt )
	    SQL= "update mb_cost_item set lock_ap='"&status_code&"' where elt_account_number = " _
	        & elt_account_number & " and mb_no = '" & tmpMAWB & "' and vendor_no ="&_ 
	    tmpVendorNo	& " and item_id=" & tmpItemID 
	    if ( itemOrigiAmt <> "" ) then
		    SQL = SQL & " and cost_amount=" & itemOrigiAmt	 			
	    end if
	    eltConn.Execute SQL		
    end Sub

    Sub UPDATE_AGENT_DEBIT( tmpMAWB, tmpVendorNo, tmpItemID, tmpAmount, tmpAgentDebitNo, itemOrigiAmt )
	    SQL= "update mb_cost_item set cost_amount=" & tmpAmount & " where elt_account_number = " _
	        & elt_account_number & " and mb_no = '" & tmpMAWB & "' and vendor_no ="&_ 
	    tmpVendorNo	& " and item_id=" & tmpItemID & " and cost_amount=" & itemOrigiAmt	 	
	    eltConn.Execute SQL		
    end Sub

    FUNCTION GET_IV_AMOUNT( IVNO,VendorNo )
        Dim rsTmp
        Set rsTmp = Server.CreateObject("ADODB.Recordset")
        SQL="select cost_amount from invoice_cost_item where elt_account_number=" & elt_account_number _
            & " and invoice_no=" & IVNO & " and vendor_no=" & VendorNo

	        rsTmp.CursorLocation = adUseClient
	        rsTmp.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	        Set rsTmp.activeConnection = Nothing
        	
	        If Not rsTmp.EOF Then
		        cost_amount=rsTmp("cost_amount")
	        Else
	            cost_amount = 0
	        end if
        rsTmp.close
        set rsTmp = nothing			
        GET_IV_AMOUNT = cost_amount
    END FUNCTION

    FUNCTION GET_IV_TOTAL_COST( IVNO )
        Dim rsTmp,cost_amount
        Set rsTmp = Server.CreateObject("ADODB.Recordset")
        SQL="select sum(cost_amount) as total_cost from invoice_cost_item where elt_account_number=" _
            & elt_account_number & " and invoice_no=" & IVNO 
        rsTmp.CursorLocation = adUseClient
        rsTmp.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
        Set rsTmp.activeConnection = Nothing
        	
        If Not rsTmp.EOF Then
	        cost_amount=rsTmp("total_cost")
        Else
	        cost_amount = 0
        end if
        rsTmp.close

        set rsTmp = nothing			
        GET_IV_TOTAL_COST = cost_amount
    END FUNCTION

    SUB UPDATE_IV_TOTAL_COST(tmpInvoice)
        Dim tmpAmount,rsTmp
        tmpAmount = GET_IV_TOTAL_COST( tmpInvoice )
        Set rsTmp = Server.CreateObject("ADODB.Recordset")
        SQL="select total_cost from invoice where elt_account_number=" & elt_account_number _
            & " and invoice_no=" & tmpInvoice
        rsTmp.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
        if Not rsTmp.EOF then
	        rsTmp("total_cost")= tmpAmount
	        rsTmp.Update
        end if
        rsTmp.close
        set rsTmp = nothing			
    END SUB

    FUNCTION GET_ITEM_ID( ItemInvoice, VendorNo )
        Dim rsTmp
        Set rsTmp = Server.CreateObject("ADODB.Recordset")
        DIM tmpId,item_id
        SQL="select isnull(max(item_id),'0') as item_id from invoice_cost_item where elt_account_number=" _
            & elt_account_number & " and invoice_no=" & ItemInvoice & " and vendor_no=" & VendorNo

	        rsTmp.CursorLocation = adUseClient
	        rsTmp.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	        Set rsTmp.activeConnection = Nothing
	        If Not isnull(rs("item_id")) Then
		        tmpId = rsTmp("item_id")
		        item_id=CLng(tmpId) + 1
	        Else
		        item_id=1
	        End If
	        rsTmp.close
        				
        set rsTmp = nothing				
        GET_ITEM_ID = item_id				
    END FUNCTION

    FUNCTION GET_ITEM_ID_BILLD_ETAIL( ItemInvoice, VendorNo )
        Dim rsTmp
        Set rsTmp = Server.CreateObject("ADODB.Recordset")
        DIM tmpId,item_id
        SQL="select isnull(max(item_id),'0') as item_id from bill_detail where elt_account_number=" _
            & elt_account_number & " and invoice_no=" & ItemInvoice & " and vendor_number=" & VendorNo

	        rsTmp.CursorLocation = adUseClient
	        rsTmp.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	        Set rsTmp.activeConnection = Nothing
	        If Not isnull(rs("item_id")) Then
		        tmpId = rsTmp("item_id")
		        item_id=CLng(tmpId) + 1
	        Else
		        item_id=1
	        End If
	        rsTmp.close
        				
        set rsTmp = nothing				
        GET_ITEM_ID_BILLD_ETAIL = item_id				
    END FUNCTION

    Sub GetAllGLAccounts
        '// Inspected by Joon on Jan 22, 2008 ////////////////////////////////////////////////

        SQL= "select gl_account_type,gl_account_desc,gl_account_number from gl where elt_account_number=" _
            & elt_account_number & " order by gl_account_number"
        rs.CursorLocation = adUseClient
        rs.Open SQL, eltConn, adOpenForwardOnly, adLockReadOnly, adCmdText
        Set rs.activeConnection = Nothing
        apIndex=0
        Do While Not rs.EOF
	        glType=rs("gl_account_type")
	        if glType=CONST__ACCOUNT_PAYABLE then
		        APName(apIndex)=rs("gl_account_desc")
		        APACCT(apIndex)=rs("gl_account_number")
		        if Not IsNull(APACCT(apIndex)) then
			        APACCT(apIndex)=cLng(APACCT(apIndex))
		        else
			        APACCT(apIndex)=0
		        end if
		        apIndex=apIndex+1
	        end if

	        rs.MoveNext
        Loop
        rs.Close
    End Sub

    Sub GetAllCostItems
        '// Retrieves cost items /////////////////////////////////////////////////////////////
        '// Modified by Joon /////////////////////////////////////////////////////////////////
         SQL= "select a.item_no,a.item_name,a.item_desc,a.account_expense,b.gl_account_type " _
            & "from item_cost a,gl b where a.elt_account_number = b.elt_account_number and " _
            & "a.elt_account_number = " & elt_account_number _
            & "  and a.account_expense = b.gl_account_number AND ISNULL(a.account_expense,0)<>0 order by b.gl_account_number"

        rs.CursorLocation = adUseClient
        rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
        Set rs.activeConnection = Nothing
        ItemIndex=0
        vQueueCount = 0
        Set DefaultItemNo = Server.CreateObject("System.Collections.ArrayList")
        Set DefaultItem = Server.CreateObject("System.Collections.ArrayList")
        Set DefaultItemDesc = Server.CreateObject("System.Collections.ArrayList")
        Set DefaultExpense = Server.CreateObject("System.Collections.ArrayList")
        Set igItemType = Server.CreateObject("System.Collections.ArrayList")
        Set igDefaultItem = Server.CreateObject("System.Collections.ArrayList")
    	
        Do While Not rs.EOF
	        DefaultItemNo.Add rs("item_no").value
	        DefaultItem.Add rs("item_name").value
	        DefaultItemDesc.Add rs("item_desc").value
	        DefaultExpense.Add rs("account_expense").value
	        igItemType.Add rs("gl_account_type").value
    		
	        if ( len(DefaultItem(ItemIndex))) < 7 then
		        igDefaultItem.Add rs("item_name").value & " " _
		            & string(7-len(rs("item_name").value),"-") & " " & rs("item_desc").value
	        else
		        igDefaultItem.Add rs("item_name").value
	        end if
    		
	        ItemIndex=ItemIndex+1
	        rs.MoveNext
        Loop
        rs.Close
    End Sub

    Sub GetPostedItems
        '// Retrieves postback items /////////////////////////////////////////////////////////
        '// Inspected by Joon on Jan 22, 2008 ////////////////////////////////////////////////
        vDate=Request("txtDate")
        vDueDate=Request("txtDueDate")
        vAmount=cdbl(Request("txtAmount"))
        vRefNo=Request("txtRefNo")
        BillNo=Request("txtBillNo")
    
        if BillNo="" then BillNo=0
        if TotalAmount="" then TotalAmount=0
    
        NoItem=checkBlank(Request("hNoItem"),0)
        NoItem=CInt(NoItem)

        TotalAmt=0
	
        for i=0 to NoItem-1
	        ItemInfo(i)=Request("hItemInfo" & i)
	        Info=ItemInfo(i)
	        pos=0
	        pos=instr(Info,"-")
	        if pos>0 then
		        ItemID(i)=Mid(Info,1,pos-1)
		        Info=Mid(Info,pos+1,100)
		        pos=Instr(Info,"-")
		        if pos>0 then
			        ItemInvoice(i)=Mid(Info,1,pos-1)
			        Info=Mid(Info,pos+1,100)
			        pos=Instr(Info,"-")
			        if pos>0 then
				        ItemNo(i)=Mid(Info,1,pos-1)
				        If ItemNo(i)="" or IsNull(ItemNo(i)) then
					        ItemNo(i)=0
				        else
					        ItemNo(i)=cInt(ItemNo(i))
				        end if
				        ItemExpense(i)=Mid(Info,pos+1,100)
				        if ItemExpense(i)="" or IsNull(ItemExpense(i)) then
					        ItemExpense(i)=0
				        end if
			        end if
		        end if
	        end if
	        ItemCheck(i)=Request("cItemCheck" & i)
	        ItemDate(i)=Request("txtItemDate" & i)
	        if ItemDate(i)="" then ItemDate(i)=Date
	        ItemAmt(i)=Request("txtItemAmt" & i)
	        ItemAmtOrigin(i) = checkBlank(Request("hItemAmtOrigin" & i),0)
	        if ItemAmt(i)="" then
		        ItemAmt(i)=0
	        else
		        ItemAmt(i)=cdbl(ItemAmt(i))
	        end if
	        ItemRef(i)=Request("txtItemRef" & i)
	        TotalAmt=TotalAmt+ItemAmt(i)
	        ItemMAWB(i)=Request("hItemMAWB" & i)
	        ItemDomeHAWB(i)=Request("hItemDomeHAWB" & i)
	        ItemType(i)=Request("hItemType" & i)
	        ItemAgentDebitNo(i)=Request("hItemAgentDebitNo" & i)		
        next
    	
        if AddItem ="yes" then	
	        NewIVNum = Request.QueryString("NewIVNum")

	        if NOT NewIVNum = "" then
	           ItemInvoice(NoItem-1)=NewIVNum
	           igIVAMOUNT =  GET_IV_AMOUNT( NewIVNum,VendorNo )  
	        end if
		
	        ItemCheck(NoItem-1)="Y"
	        vAmount=vAmount+ItemAmt(NoItem-1)
        end if
	
        tIndex=NoItem

    End Sub
 
    Sub UpdateBillDetail 
        '// Updaing bill_detail for each item
	    For i=0 to NoItem-1
            if BillType="credit" then ItemAmt(i)=-ItemAmt(i)
			
		    if ItemInvoice(i)="0" then
			    if ( trim(ItemMAWB(i)) <> "") 	 then	
				    SQL = "select * from bill_Detail where elt_account_number = " & elt_account_number _
				        & " and mb_no='" & ItemMAWB(i) & "' and item_id=" & ItemID(i)
			    Elseif ItemDomeHAWB(i) <> "" Then
			        SQL = "select * from bill_Detail where elt_account_number = " & elt_account_number _
			            & " and hawb_master_hawb_num='" & ItemDomeHAWB(i) & "' and item_id=" & ItemID(i)
			    else		
				    SQL = "select * from bill_Detail where elt_account_number = " & elt_account_number _
				        & " and bill_number=" & BillNo & " and item_id=" & i+100
			    end if
		    else
			    SQL = "select * from bill_Detail where elt_account_number = " & elt_account_number _
			        & " and invoice_no=" & ItemInvoice(i) & " and item_id=" & ItemID(i)
		    end if

		    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
		    if ItemCheck(i)="Y" then
                If rs.EOF Then
                    rs.Close()
                    SQL= "select * from bill_Detail where elt_account_number = " & elt_account_number _
                        & " and vendor_number="&VendorNo&" and item_id=" & i+100
				    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
				    If rs.EOF Then
					    rs.AddNew
					    rs("elt_account_number")=elt_account_number
					    rs("vendor_number") = VendorNo
					    rs("item_id")=100+i
					    OrigBillAmt=0
					    OrigItemAmt(i)=0
					    rs("item_amt_origin") = ItemAmtOrigin(i)
				    else
					    OrigBillAmt=cdbl(rs("item_amt"))
					    OrigItemAmt(i)=OrigBillAmt
				    end if	
			    else
				    OrigBillAmt=cdbl(rs("item_amt"))
				    OrigItemAmt(i)=OrigBillAmt
			    end if
			    TotalOrigBillAmt=TotalOrigBillAmt+OrigBillAmt
			    rs("tran_date")=ItemDate(i)
			    rs("bill_number") = BillNo
			    rs("item_no")=ItemNo(i)
			    rs("item_amt") = ItemAmt(i)
			    rs("item_expense_acct")=ItemExpense(i)
			    rs("item_ap")=vAP
			    rs("ref")=ItemRef(i)
			    rs.Update
			    rs.Close()
			    
                '// Updating invoice lock
			    if Not ItemInvoice(i)="0" then
				    SQL="select lock_ap from invoice where elt_account_number=" & elt_account_number _
				        & " and invoice_no=" & ItemInvoice(i)
				    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
				    if Not rs.EOF then
					    if Not rs("lock_ap")="Y" then
						    rs("lock_ap")="Y"
						    rs.Update
					    end if
				    end if
				    rs.Close()
					
                    '// Updating invoice cost item
				    tmpItem=Request("lstItemName" & i)
				    pos=0
				    pos=instr(tmpItem,"-")
				    if pos>0 then
				    tmpItem=Cint(Mid(tmpItem,1,pos-1))
				    end if

				    for iii = 0 to ItemIndex -1 
					    if DefaultItemNo(iii) = tmpItem then
						    tmpItemDesc = DefaultItemDesc(iii)
					    end if
				    next
						
				    if CHGIV = "yes" then
					    SQL="select elt_account_number,cost_amount,invoice_no,item_no,item_id,item_desc,ref_no,vendor_no "_
					        & "from invoice_cost_item where elt_account_number=" _
					        & elt_account_number & " and invoice_no=" & ItemInvoice(i) & " and vendor_no=" _
					        & VendorNo & " and item_no=" & ItemNo(i) & " AND item_id=" & ItemID(i)
					    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
					    
					    if Not rs.EOF then
						    rs("item_no")=tmpItem
						    rs("item_desc")=tmpItemDesc
						    rs("ref_no")=ItemRef(i)
						    rs("cost_amount")=ItemAmt(i)
						    rs.Update
					    else
						    tmpItemID = GET_ITEM_ID( ItemInvoice(i), VendorNo )						
						    rs.AddNew	
						    rs("elt_account_number")=elt_account_number
						    rs("invoice_no")=ItemInvoice(i)
						    rs("item_id")= tmpItemID
							
						    rs("item_no")=tmpItem
						    rs("item_desc")=tmpItemDesc
							
						    rs("ref_no")=ItemRef(i)
						    rs("cost_amount")=ItemAmt(i)
						    rs("vendor_no")=VendorNo
						    rs.Update
					    end if
					    rs.close

					    SQL="select * from bill_detail where elt_account_number=" & elt_account_number _
					        & " and invoice_no=" & ItemInvoice(i) & " and vendor_number=" _
					        & VendorNo & "and item_no=" & ItemNo(i) & " AND item_id=" & ItemID(i)

					    rs.Open SQL,eltConn,adOpenStatic,adLockPessimistic,adCmdText
					    if Not rs.EOF then
						    rs("item_no")=tmpItem
						    rs("item_name")=tmpItemDesc
						    rs("ref")=ItemRef(i)
						    rs("item_amt")=ItemAmt(i)
						    rs("item_amt_origin") = ItemAmtOrigin(i)
						    
						    rs.Update
					    else
					        '// In case item doesn't exist this section can be ignored
						    tmpItemID = GET_ITEM_ID_BILLD_ETAIL( ItemInvoice(i), VendorNo )						
						    rs.AddNew	
						    rs("elt_account_number")=elt_account_number
						    rs("invoice_no")=ItemInvoice(i)
						    rs("item_id")= tmpItemID
						    rs("bill_number")="0"
							
						    rs("item_no")=tmpItem
						    rs("item_name")=tmpItemDesc
							
						    rs("ref")=ItemRef(i)
						    rs("item_amt") = ItemAmt(i)
						    rs("item_amt_origin") = ItemAmtOrigin(i)
						    
						    rs("vendor_number")=VendorNo
						    rs("item_expense_acct")=ItemExpense(i)							
							
						    rs.Update
					    end if
					    rs.close
				
					    CALL UPDATE_IV_TOTAL_COST(	ItemInvoice(i) )					
				    end if

				    if ItemID(i) = "0" and NOT ItemInvoice(i) = "" then 
					    SQL="select * from invoice_cost_item where elt_account_number=" & elt_account_number _
					        & " and invoice_no=" & ItemInvoice(i) 
					    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
					    tmpItemID = GET_ITEM_ID( ItemInvoice(i), VendorNo )						
					    rs.AddNew	
					    rs("elt_account_number")=elt_account_number
					    rs("invoice_no")=ItemInvoice(i)
					    rs("item_id")= tmpItemID

					    rs("item_no")=tmpItem
					    rs("item_desc")=tmpItemDesc

					    rs("ref_no")=ItemRef(i)
					    rs("cost_amount")=ItemAmt(i)
					    rs("vendor_no")=VendorNo
					    rs.Update
					    rs.close
					    CALL UPDATE_IV_TOTAL_COST(	ItemInvoice(i) )
				    end if
			    Else
				    If ( ItemMAWB(i) <> "") Then	
					    If CHGIV = "yes" Then
						    CALL UPDATE_AGENT_DEBIT(ItemMAWB(i), VendorNo ,ItemID(i), ItemAmt(i),ItemAgentDebitNo(i), OrigItemAmt(i))
					    End If	
					    CALL UPDATE_AGENT_DEBIT_STATUS(ItemMAWB(i), VendorNo ,ItemID(i), ItemAmt(i),ItemAgentDebitNo(i),"Y" ,ItemAmt(i))					
				    End If
			    End if

		    else
			    if Not rs.EOF then
				    if ItemInvoice(i)="0" then
					    if ( ItemMAWB(i) <> "") then
					    Elseif ItemDomeHAWB(i) <> "" Then
					    else
						    rs.delete
					    end if	
				    else
					    rs("bill_number")=0
					    rs.Update
				    end if
			    end if
			    rs.close
		    end if
	    next
	    '// End of updating each bill item
    End Sub

    Sub CheckBillLock
        '// Checking lock for bill
        SQL= "select lock from bill where elt_account_number=" & elt_account_number _
            & " and bill_number=" & BillNo
        rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
        If Not rs.EOF Then
	        vLock=rs("lock")
	        if vLock="Y" then
		        Save=""
		        DeleteBill=""
		        ViewBill="yes"
		        Response.Write("<script type='text/jscript'>alert('This BILL can not be updated!');</script>")
	        end if
        end if
        rs.Close()
    End Sub
    
    Sub DeleteBillSub
        '// Deleting Bill
        Call CheckBillLock
        If DeleteBill="yes" then
            '// delete bill
            SQL= "delete from bill where elt_account_number = " & elt_account_number & " and bill_number=" & BillNo
            '// response.write SQl 		
            eltConn.Execute SQL
            '// update bill_detail
            SQL= "update bill_detail set bill_number=0 where elt_account_number = " & elt_account_number & " and bill_number=" & BillNo
            eltConn.Execute SQL
            '// delete all_account_journal
            SQL="delete from all_accounts_journal where elt_account_number=" & elt_account_number & " and tran_type='BILL' and tran_num=" & BillNo
            eltConn.Execute SQL
            '// update invoice table set lock_ap='N'
            NoItem=Request("hNoItem")
            
            for i=0 to NoItem-1
	            InvoiceNo=Request("hInvoiceNo" & i)
	            if InvoiceNo="" then InvoiceNo=-1
	            if not isnumeric(InvoiceNo) then InvoiceNo=-1
	            if Not InvoiceNo=-1 then
		            SQL= "select lock_ap from invoice where elt_account_number=" & elt_account_number & " and invoice_no=" & InvoiceNo 
		            rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
		            if Not rs.EOF then
			            rs("lock_ap")="N"
			            rs.Update
		            end if
		            rs.Close
	            end if
			
                '//////////////////////////////////////////////			
	            DItemInfo=Request("hItemInfo" & i)
	            DInfo=DItemInfo
	            pos=0
	            pos=instr(DInfo,"-")
	            if pos>0 then
		            DItemID=Mid(DInfo,1,pos-1)
	            end if
	            DItemCheck=Request("cItemCheck" & i)
	            DItemMAWB=Request("hItemMAWB" & i)
                CALL UPDATE_AGENT_DEBIT_STATUS( DItemMAWB, VendorNo ,DItemID,"","","N", ItemAmt(i) )			
            next
		End If
    End Sub
    
    Sub UpdateGLRelation
    
        '// Updating GL A/P account balance
	    SQL= "select gl_account_balance from gl where elt_account_number = " & elt_account_number & " and gl_account_number=" & vAP
	    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	    if not rs.EOF then
		    apPBalance=rs("gl_account_balance")
		    If (apPBalance="" Or IsNull(apPBalance)) Then
			    apBalance=-vAmount
		    else
			    apBalance=CDbl(rs("gl_account_balance"))-vAmount
		    End if
		    rs("gl_account_balance")=apBalance
	    end if
	    rs.Update
	    rs.Close
		
        'delete all records from all_accounts_journal table with this BillNo
	    SQL= "delete from all_accounts_journal where elt_account_number = " & elt_account_number _
	        & " and tran_type='BILL' and tran_num=" & BillNo
	    eltConn.Execute SQL
        'insert to all_accounts_journal for A/P record
	    SQL= "select max(tran_seq_num) as SeqNo from all_accounts_journal where elt_account_number = " & elt_account_number
	    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	    If Not rs.EOF And IsNull(rs("SeqNo"))=False Then
		    SeqNo = CLng(rs("SeqNo")) + 1
	    Else
		    SeqNo=1
	    End If
	    rs.Close
        'insert an init record in all_accounts_journal for the AP and for this vendor if it is not exist
	    SQL= "select * from all_accounts_journal where elt_account_number = " & elt_account_number _
	        & " and gl_account_number=" & vAP & " and tran_type='INIT' and customer_number=" & VendorNo
	    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	    if rs.EOF then
		    rs.AddNew
		    rs("elt_account_number")=elt_account_number
		    rs("gl_account_number")=vAP
		    rs("gl_account_name")=GetGLDesc(vAP)
		    rs("tran_seq_num")=SeqNo
		    SeqNo=SeqNo+1
		    rs("tran_type")="INIT"
		    rs("tran_date")=Now
		    rs("Customer_Number")=VendorNo
		    rs("Customer_Name")=vVendorName
		    rs("credit_amount")=0
		    rs.Update
	    end if
	    rs.Close
        'insert transaction data to all_accounts_journal for AP
	    SQL= "select * from all_accounts_journal where elt_account_number = " & elt_account_number _
	        & " and tran_seq_num=" & SeqNo
	    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	    if rs.EOF then
		    rs.AddNew
		    rs("elt_account_number")=elt_account_number
		    rs("gl_account_number")=vAP
		    rs("gl_account_name")=GetGLDesc(vAP)
		    rs("tran_seq_num")=SeqNo
		    SeqNo=SeqNo+1

		    rs("tran_type")="BILL"
		    rs("tran_num")=BillNo
		    rs("tran_date")=vDate
		    rs("Customer_Number")=VendorNo
		    rs("Customer_Name")=vVendorName
		    rs("memo")=vRefNo
		    rs("split")=GetGLDesc(ItemExpense(0))
		    rs("debit_amount")=0
		    rs("credit_amount")=-vAmount
		    rs.Update
		    rs.Close
            'update GL expense accounts
		    for i=0 to NoItem-1
			    if ItemCheck(i)="Y" then
				    SQL= "select gl_account_balance from gl where elt_account_number = " _
				        & elt_account_number & " and gl_account_number=" & ItemExpense(i)
				    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
				    if not rs.EOF then
					    if Not IsNull(rs("gl_account_balance")) then
						    epBalance=Cdbl(rs("gl_account_balance"))+ItemAmt(i)
						    epPBalance=rs("gl_account_balance")
					    else
						    epBalance=ItemAmt(i)
						    epPBalance=0
					    end if
					    rs("gl_account_balance")=epBalance
					    rs.Update
				    end if
				    rs.Close
                    'insert to all_accounts_journal for expense accounts
			        SQL= "select * from all_accounts_journal where elt_account_number = " _
			            & elt_account_number & " and tran_seq_num=" & SeqNo
			        rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
				    if rs.EOF then
					    rs.AddNew
					    rs("elt_account_number")=elt_account_number
					    rs("gl_account_number")=ItemExpense(i)
					    rs("gl_account_name")=GetGLDesc(ItemExpense(i))
					    rs("tran_seq_num")=SeqNo		
					    SeqNo=SeqNo+1
					    rs("tran_type")="BILL"
					    rs("tran_num")=BillNo
					    rs("tran_date")=vDate
					    rs("Customer_Number")=VendorNo
					    rs("Customer_Name")=vVendorName
					    rs("memo")=ItemRef(i)
					    rs("split")=GetGLDesc(vAP)
					    rs("debit_amount")=ItemAmt(i)
					    rs("credit_amount")=0
					    rs.Update
				    end if
                    rs.Close
			    end if
		    next
	    end if
    End Sub
    
    Sub UpdateBillSub
    
        Session("TranNo")=Clng(Session("TranNo"))+1
        TranNo=Clng(Session("TranNo"))
        if BillType="credit" then
            vAmount=-vAmount
        end if
	    if (BillNo="" Or BillNo="0") then
		    SQL= "select max(bill_number) as BillNo from bill where elt_account_number = " & elt_account_number
		    rs.CursorLocation = adUseClient
		    rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		    Set rs.activeConnection = Nothing
		    If Not rs.EOF And IsNull(rs("BillNo"))=False Then
			    BillNo = CLng(rs("BillNo")) + 1
		    Else
			    BillNo=1
		    End If
		    rs.Close
	    else
		    BillNo=cLng(BillNo)
	    end if

	    SQL= "select * from bill where elt_account_number = " & elt_account_number & " and bill_number=" & BillNo
	    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	    If rs.EOF Then
		    rs.AddNew
		    rs("elt_account_number")=elt_account_number
		    rs("bill_number")=BillNo
	    end if
	    if BillType="debit" then
		    rs("bill_type")="D"
	    else
		    rs("bill_type")="C"
	    end if
	    rs("vendor_number")=VendorNo
	    rs("vendor_name")=vVendorName
	    rs("bill_date")=vDate
	    If Not IsNull(vDueDate) And Trim(vDueDate) <> "" Then
		    rs("bill_due_date")=vDueDate
	    End If
	    rs("bill_amt")=vAmount
	    rs("bill_amt_due")=vAmount
	    rs("bill_amt_paid")=0
	    rs("ref_no")=vRefNo
	    rs("bill_expense_acct")=ItemExpense(0)
	    rs("bill_ap")=vAP
	    rs("bill_status")="A"
	    rs.Update
	    rs.Close
    End Sub
    
    Sub PageLoad
        if isVendor="yes" or Save="yes" or ViewBill="yes" then
	        if Save="yes" then
		        vRefNo=""
		        vAmount=0
		        BillNo=0
	        end if

	        TotalAmt=0
	        tIndex=0
	        if ViewBill="yes" then
		        BillNo=Request.QueryString("BillNo")
		        if BillNo="" then BillNo=Request("txtBillNo")
		        if BillNo="" then BillNo=0
		        if Not Branch="" then
                    SQL= "select * from bill where elt_account_number = " & Branch & " and bill_number=" & BillNo
		        else
			        SQL= "select * from bill where elt_account_number = " & elt_account_number & " and bill_number=" & BillNo
		        end if
		        rs.CursorLocation = adUseClient
		        rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		        Set rs.activeConnection = Nothing
		        If Not rs.EOF Then
			        VendorNo=rs("vendor_number")
			        vVendorName=rs("vendor_name")
			        vDate=rs("bill_date")
			        vDueDate=rs("bill_due_date")
			        '// Running balance
			        vAmount=rs("bill_amt_due")
			        vAP=rs("bill_ap")
			        vRefNo=rs("ref_no")
			        BillType=rs("bill_type")
			        if isnull(BillType) then
				        BillType = "D"
			        end if
			        if BillType="D" then
				        BillType="debit"
			        else
				        BillType="credit"
			        end if
		        end if
		        rs.Close

		        If Not Branch="" Then
			        SQL="select a.hawb_master_hawb_num,a.item_id,a.tran_date,a.invoice_no,a.item_no," _
			            & "a.item_amt,a.item_amt_origin,a.ref,a.item_expense_acct,isnull(a.mb_no,'') as mb_no," _
			            & "isnull(a.iType,'') as iType,isnull(a.agent_debit_no,'') as agent_debit_no," _
			            & "b.ref_no_our from bill_detail a left outer join invoice b " _
			            & "ON (a.elt_account_number=b.elt_account_number AND a.invoice_no=b.invoice_no) " _
			            & "WHERE a.elt_account_number = " & Branch & " and a.bill_number=" & BillNo _
			            & " order by a.tran_date"	    
    	        Else
			        SQL="select a.hawb_master_hawb_num,a.item_id,a.tran_date,a.invoice_no,a.item_no," _
			            & "a.item_amt,a.item_amt_origin,a.ref,a.item_expense_acct,isnull(a.mb_no,'') as mb_no," _
			            & "isnull(a.iType,'') as iType,isnull(a.agent_debit_no,'') as agent_debit_no," _
			            & "b.ref_no_our from bill_detail a left outer join invoice b " _
			            & "ON (a.elt_account_number=b.elt_account_number AND a.invoice_no=b.invoice_no) " _
			            & "WHERE a.elt_account_number = " & elt_account_number & " and a.bill_number=" & BillNo _
			            & " order by a.tran_date"	
		        End If
		        
		        If Request.QueryString("item_id")<>"" Then 
                    VendorNo=Request.QueryString("vendor_number")
                    SQL="select a.hawb_master_hawb_num,a.item_id,a.tran_date,a.invoice_no,a.item_no," _
			            & "a.item_amt,a.item_amt_origin,a.ref,a.item_expense_acct,isnull(a.mb_no,'') as mb_no," _
			            & "isnull(a.iType,'') as iType,isnull(a.agent_debit_no,'') as agent_debit_no," _
			            & "b.ref_no_our from bill_detail a left outer join invoice b " _
			            & "ON (a.elt_account_number=b.elt_account_number AND a.invoice_no=b.invoice_no) " _
			            & "WHERE a.elt_account_number=" & elt_account_number & " and a.vendor_number=" _
			            & VendorNo & " and item_id="&request.QueryString("item_id")
		        End if 
        	
		        rs.CursorLocation = adUseClient
		        rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		        Set rs.activeConnection = Nothing
    
		        Do While Not rs.EOF
			        ItemCheck(tIndex)="Y"
			        ItemID(tIndex)=rs("item_id")
			        ItemDate(tIndex)=rs("tran_date")
			        ItemInvoice(tIndex)=rs("invoice_no")
			        ItemNo(tIndex)=rs("item_no")
			        ItemAmt(tIndex)=cdbl(rs("item_amt"))
			        ItemAmtOrigin(tIndex) = cdbl(checkBlank(rs("item_amt_origin"),0))
			        ItemRef(tIndex)=rs("ref")
			        TotalAmt=TotalAmt+ItemAmt(tIndex)
			        ExpenseAcct=rs("item_expense_acct")
			        ItemInfo(tIndex)=ItemID(tIndex) & "-" & ItemInvoice(tIndex) & "-" & ItemNo(tIndex) & "-" & ExpenseAcct
			        ItemMAWB(tIndex) = rs("mb_no")
			        ItemType(tIndex) = rs("iType")
			        ItemAgentDebitNo(tIndex) = rs("agent_debit_no")
			        ItemDomeHAWB(tIndex) = rs("hawb_master_hawb_num")
        			ItemFileNo(tIndex)=rs("ref_no_our")
        			
			        rs.MoveNext
			        tIndex=tIndex+1
		        Loop
		        rs.close
	        end if
        	
	        SQL= "select top 500 a.hawb_master_hawb_num,a.item_id,a.tran_date,a.invoice_no,a.item_no," _
	            & "a.item_amt,a.item_amt_origin,a.ref,a.item_expense_acct,isnull(a.mb_no,'') as mb_no, " _
	            & "isnull(a.iType,'') as iType,isnull(a.agent_debit_no,'') as agent_debit_no,b.ref_no_our " _
	            & "from bill_detail a left outer join invoice b " _
	            & "ON (a.elt_account_number=b.elt_account_number AND a.invoice_no=b.invoice_no)" _
	            & "WHERE a.elt_account_number=" & elt_account_number & " and a.vendor_number=" & VendorNo
	        If request.QueryString("item_id") <> "" Then
		        SQL = SQL & " and a.bill_number=0 and a.item_id=" & request.QueryString("item_id") _
		            & " order by a.tran_date"
	        ElseIf request.QueryString("BillNo") <> "" Then
		        SQL = SQL & " and a.bill_number=" & request.QueryString("BillNo") & " order by a.tran_date"
	        Else
		        SQL = SQL & " and a.bill_number=0 order by a.tran_date"
	        End If

	        rs.CursorLocation = adUseClient
	        rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	        Set rs.activeConnection = Nothing
    

	        Do While Not rs.EOF AND Not rs.BOF
	            if request.QueryString("item_id")<>rs("item_id") Then 
		            ItemCheck(tIndex)="N"
		            If Not IsNull(rs("tran_date")) AND rs("tran_date") <> "" then
				         ItemDate(tIndex)=FormatDateTime(rs("tran_date"),2)
			        End If 
		            ItemID(tIndex)=rs("item_id")
		            ItemInvoice(tIndex)=rs("invoice_no")
		            ItemNo(tIndex)=rs("item_no")
		            ItemAmt(tIndex)=cdbl(rs("item_amt"))
		            ItemAmtOrigin(tIndex) = cdbl(checkBlank(rs("item_amt_origin"),0))
		            TotalAmt=TotalAmt+ItemAmt(tIndex)
		            ExpenseAcct=rs("item_expense_acct")
		            ItemRef(tIndex)=rs("ref")
		            ItemInfo(tIndex)=ItemID(tIndex) & "-" & ItemInvoice(tIndex) & "-" & ItemNo(tIndex) & "-" & ExpenseAcct
		            ItemMAWB(tIndex) = rs("mb_no")
		            ItemDomeHAWB(tIndex) = rs("hawb_master_hawb_num")
		            ItemType(tIndex) = rs("iType")		
		            ItemAgentDebitNo(tIndex)=rs("agent_debit_no")
		            ItemFileNo(tIndex)=rs("ref_no_our")
		            rs.MoveNext
		            tIndex=tIndex+1


	            end if
	        Loop

	        ItemCheck(tIndex)=""
	        ItemDate(tIndex)=""
	        ItemID(tIndex)=""
	        ItemInvoice(tIndex)=""
	        ItemNo(tIndex)=""
	        ItemAmt(tIndex)=""
	        ItemInfo(tIndex)=""
	        ItemRef(tIndex)=""
	        ItemFileNo(tIndex)=""
	        rs.Close
        end if
        
        vDate = checkBlank(vDate,Date())
        vDueDate = checkBlank(vDueDate,Date())

    End Sub
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
    <title>Enter Bills</title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../Include/JPTableDOM.js"></script>
    <script type="text/javascript" src="/ASP/ajaxFunctions/ajax.js"></script>
    <script type="text/javascript" src="../Include/JPED.js"></script>
    <script type="text/javascript">
    
        window.name='<%=Request.QueryString("WindowName") %>';
        // AJAX CALL TO DELETE BILL DETAIL: added by Joon on Jan 21, 2008
        //////////////////////////////////////////////////////////////////
        function DeleteItem(ItemNo,thisObj){
    	    
            try{
                var form = document.getElementById("form1");
                var count = form.elements.length; 

                var tranDate = document.getElementsByName("txtItemDate" + ItemNo).item(0).value;
                var itemInfo = document.getElementsByName("hItemInfo" + ItemNo).item(0).value;
                var invoiceNo = document.getElementsByName("hInvoiceNoOrigin" + ItemNo).item(0).value;
                var itemRef = document.getElementsByName("txtItemRef" + ItemNo).item(0).value;
                var vendorNo = document.getElementById("hVendorAcct").value;
                
                if(itemInfo != ""){
                    var ans = confirm("Are you sure you want to delete this item?");
                    if(ans){
                        var itemInfoArray = new Array();
                        itemInfoArray = itemInfo.split("-");
                        var itemNo = itemInfoArray[2];
                        var itemId = itemInfoArray[0];

                        var url = "/ASP/ajaxFunctions/ajax_payable_queue.asp?mode=DeleteBillItem"
                            + "&tranDate=" + encodeURIComponent(tranDate) 
                            + "&invoiceNo=" + encodeURIComponent(invoiceNo) 
                            + "&itemRef=" + encodeURIComponent(itemRef)
                            + "&vendorNo=" + encodeURIComponent(vendorNo) 
                            + "&itemNo=" + encodeURIComponent(itemNo) 
                            + "&itemId=" + encodeURIComponent(itemId);
                        
                        new ajax.xhr.Request('POST',"",url,AfterDeleteItem,thisObj,ItemNo,'','');
                    }
                }

            }catch(err)
            { alert("err:"+err.message); }
	    }
    	
	    function AfterDeleteItem(req,thisObj,itemNo,var3,var4,url){
    	
            if (req.readyState == 4){   
                if (req.status == 200){
                    if (req.responseText != ""){
                        alert(req.responseText);
                    }
                    else{
                        var checkObj = document.getElementsByName("cItemCheck" + itemNo).item(0);
                        if(checkObj.checked){
                            checkObj.checked = false;
                            CheckClick(itemNo)
                        }
                        checkObj.onclick = function() { return false; };
                        checkObj.style.visibility = "hidden";
                        thisObj.outerHTML = "<font size='2' color='red'>deleted</font>";
                    }
                }
                else {
                    alert("Failed to delete. " + req.responseText);
                }
            }
	    }
	    
	    function lstVendorNameChange(orgNum,orgName){
            var hiddenObj = document.getElementById("hVendorAcct");
            var txtObj = document.getElementById("lstVendorName");
            var divObj = document.getElementById("lstVendorNameDiv")
    
            hiddenObj.value = orgNum;
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
            divObj.style.height = "0px";
            setTimeout(GetQueueList,100);
	    }
	    
	    function GetQueueList(){
	        document.form1.action = "enter_bill.asp?Vendor=yes&WindowName=" + window.name;
            document.form1.method = "POST";
            document.form1.target = window.name;
            document.form1.submit();
	    }
	    
	    function LinkPayQueue(sURL){
            var hiddenObj = document.getElementById("hVendorAcct");
            var txtObj = document.getElementById("lstVendorName");
	        if(!showJPModal(sURL,"",1000,600,"Popwin")){
	            lstVendorNameChange(hiddenObj.value,txtObj.value);
	        }
	    }
	    
    </script>
    <style type="text/css">
        body {
	        margin-left: 0px;
	        margin-right: 0px;
	        margin-bottom: 0px;
        }
    </style>
</head>
<!--  #include file="../include/recent_file.asp" -->
<body onload="self.focus()">
    <form name="form1" id="form1" method="post">
        <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
            <tr>
                <td height="32" align="left" valign="middle" class="pageheader">
                    Payables Queue
                </td>
            </tr>
        </table>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#89A979"
            bgcolor="#89A979" class="border1px">
            <tr>
                <td>
                    <% if BillNo = "" then BillNo = 0%>
                    <!-- start of scroll bar -->
                    <input type="hidden" name="scrollPositionX">
                    <input type="hidden" name="scrollPositionY">
                    <!-- end of scroll bar -->
                    <input type="hidden" name="hNoItem" value="<%= tIndex %>">
                    <input type="hidden" name="hAP" value="<%= vAP %>">
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr bgcolor="D5E8CB">
                            <td colspan="9" height="24" align="center" valign="middle" class="bodyheader">
                                <table width="98%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="25%">
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                        <td width="49%" align="center" valign="middle">
                                            <% if ViewBill <> "yes" then %>
                                            <img src="../images/button_save_payment.gif" width="46" height="18" onclick="SaveClick(<%= TranNo %>)"
                                                <% if UserRight<5 or Not Branch="" then response.write("disabled") %> style="cursor: hand"
                                                id="btnTopSave"><% end if%></td>
                                        <td width="13%" align="right" valign="middle">
                                            &nbsp;</td>
                                        <td width="13%" align="right" valign="middle">
                                            <% if BillNo <> 0 then%>
                                            <img src="../images/button_delete_bill.gif" width="78" height="18" onclick="DeleteClick()"
                                                <% if UserRight<5 or Not Branch="" then response.write("disabled") %> style="cursor: hand"><% end if %></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td height="1" colspan="9">
                            </td>
                        </tr>
                        <tr align="center" valign="middle" bgcolor="E7F0E2">
                            <td colspan="9" bgcolor="#f3f3f3" class="bodycopy">
                                <br>
                                <table width="60%" height="28" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td>
                                            <span class="bodyheader">
                                                <input type="radio" value="debit" name="rDebit" onclick="DebitClick()" <% if BillType="debit" then response.write("checked") %> />
                                                <b>Bill</b>
                                                <img src="/ASP/Images/spacer.gif" width="20" height="10" alt="" />
                                                <input type="radio" name="rCredit" value="credit" onclick="CreditClick()" <% if BillType="credit" then response.write("checked") %> />
                                                <b>Credit Memo</b></span></td>
                                    </tr>
                                </table>
                                <table width="60%" border="0" align="center" cellpadding="2" cellspacing="0" bordercolor="89A979"
                                    bgcolor="D5E8CB" class="border1px">
                                    <tr align="left" valign="middle" bgcolor="E7F0E2">
                                        <td width="2" height="22" class="bodycopy">
                                            &nbsp;</td>
                                        <td colspan="3" class="bodyheader">
                                            <strong><font color="c16b42">Vendor</font></strong></td>
                                        <td width="169">
                                            &nbsp;</td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="E7F0E2">
                                        <td height="22" bgcolor="#FFFFFF" class="bodycopy">
                                            &nbsp;</td>
                                        <td colspan="3" bgcolor="#FFFFFF" class="bodyheader">
                                            <!-- Start JPED -->
                                            <input type="hidden" id="hVendorAcct" name="hVendorAcct" value="<%=VendorNo %>" />
                                            <div id="lstVendorNameDiv">
                                            </div>
                                            <table cellpadding="0" cellspacing="0" border="0" id="tblVendorName">
                                                <tr>
                                                    <td>
                                                        <input type="text" autocomplete="off" id="lstVendorName" name="lstVendorName" value="<%=vVendorName %>"
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
                                            <% If BillNo <> 0 then%>

                                            <script type="text/javascript">
                                                    makeAllReadOnly(document.getElementById("tblVendorName"));
                                            </script>

                                            <% End If %>
                                        </td>
                                        <td bgcolor="#FFFFFF">
                                            &nbsp;</td>
                                    </tr>
                                    <tr align="left" valign="middle">
                                        <td height="1" colspan="5" bgcolor="89A979">
                                        </td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="#FFFFFF">
                                        <td bgcolor="#f3f3f3">
                                            &nbsp;</td>
                                        <td width="163" height="20" bgcolor="#f3f3f3">
                                            <strong>Date</strong></td>
                                        <td width="171" bgcolor="#f3f3f3" class="bodyheader">
                                            Reference No.</td>
                                        <td bgcolor="#f3f3f3" class="bodyheader">
                                            Due Date</td>
                                        <td bgcolor="#f3f3f3">
                                            <strong><font color="c16b42">Amount</font></strong></td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="#FFFFFF">
                                        <td>
                                            &nbsp;</td>
                                        <td bgcolor="#FFFFFF">
                                            <input name="txtDate" class="m_shorttextfield date" preset="shortdate" value="<%= vDate %>"
                                                size="15"></td>
                                        <td>
                                            <font size="3"><b>
                                                <input name="txtRefNo" class="shorttextfield" value="<%= vRefNo %>" size="15">
                                            </b></font>
                                        </td>
                                        <td width="174">
                                            <input name="txtDueDate" class="m_shorttextfield date" preset="shortdate" value="<%= vDueDate %>"
                                                size="15"></td>
                                        <td width="169">
                                            <input name="txtAmount" class="readonlyboldright" value="<%= formatnumber(vAmount,2) %>"
                                                size="15" readonly style="height: 16px;"></td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="f3f3f3">
                                        <td>
                                            &nbsp;</td>
                                        <td class="bodyheader">
                                            A/P</td>
                                        <td>
                                            <input type="hidden" name="txtBillNo" value="<%= BillNo %>" />
                                        </td>
                                        <td>
                                            &nbsp;</td>
                                        <td>
                                            &nbsp;</td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="#FFFFFF">
                                        <td>
                                            &nbsp;</td>
                                        <td colspan="2">
                                            <b><font size="3"><b>
                                                <select name="lstAP" size="1" class="smallselect" style="width: 135px">
                                                    <% for i=0 to apIndex-1 %>
                                                    <option value="<%= APACCT(i) %>" <% if cLng(vAP)=cLng(APACCT(i)) then response.write("selected") %>>
                                                        <%= APName(i) %>
                                                    </option>
                                                    <% next %>
                                                </select>
                                            </b></font></b>
                                        </td>
                                        <td>
                                        </td>
                                        <td>
                                        </td>
                                    </tr>
                                </table>
                                <br>
                            </td>
                        </tr>
                        <tr>
                            <td height="2" colspan="9">
                            </td>
                        </tr>
                        <tr align="left" valign="middle">
                            <td bgcolor="D5E8CB" class="bodyheader">
                                &nbsp;</td>
                            <td bgcolor="D5E8CB" class="bodyheader">
                                Date</td>
                            <td bgcolor="D5E8CB" class="bodyheader">
                                Amount</td>
                            <td bgcolor="D5E8CB" class="bodyheader">
                            </td>
                            <td bgcolor="D5E8CB" class="bodyheader">
                                Invoice No.</td>
                            <td bgcolor="D5E8CB" class="bodyheader">
                                File No.</td>
                            <td align="left" bgcolor="D5E8CB" class="bodyheader">
                                Item Name
                            </td>
                            <td align="left" bgcolor="D5E8CB" class="bodyheader">
                                Reference No.</td>
                            <td align="left" bgcolor="D5E8CB" class="bodyheader">
                            </td>
                        </tr>
                        <input id="ItemName" type="hidden">
                        <input id="ItemCheck" type="hidden">
                        <input id="ItemAmt" type="hidden">
                        <input id="hItemAmt" type="hidden">
                        <input id="hItemSaved" type="hidden">
                        <input id="ItemInvoice" type="hidden">
                        <input id="hItemInvoice" type="hidden">
                        <input id="hItemInfo" type="hidden">
                        <input id="hItemRef" type="hidden">
                        <input id="hItemMAWB" type="hidden">
                        <input id="hItemDomeHAWB" type="hidden">
                        <input id="hItemType" type="hidden">
                        <input id="hIgItemType" type="hidden">
                        <input id="hItemAgentDebitNo" type="hidden">
                        <% 
    DIM flag_c,newItemCnt
	flag_c = false
	newItemCnt = 0

    for i=0 to tIndex
        if ViewBill = "yes" then 
            if ItemCheck(i)<>"Y" then
                flag_c = false
			else
				 flag_c = true			
            end if
        else
            flag_c = true
        end if
    if flag_c then 
        newItemCnt = newItemCnt + 1
                        %>
                        <tr align="left" valign="middle" bgcolor="#FFFFFF">
                            <td align="center">
                                <input type="checkbox" id="ItemCheck" name="cItemCheck<%= i %>" value="Y" onclick="CheckClick(<%=i %>)" class="ItemCheck"
                                    <% if ItemCheck(i)="Y" then response.write("checked") %> <% if ViewBill = "yes" then response.write " disabled='disabled'" end if %>>
                                <input type="hidden" id="hItemInfo" name="hItemInfo<%= i %>" value="<%= ItemInfo(i) %>" class="hItemInfo"></td>
                            <td>
                                <input name="txtItemDate<%= i %>" class="m_shorttextfield date" preset="shortdate" value="<%= ItemDate(i) %>"
                                    style="width: 70px" />
                            </td>
                            <td align="left" class="bodycopy">
                                <input name="txtItemAmt<%= i %>" class="numberfield ItemAmt" id="ItemAmt" onchange="ItemAmtChange(<%= i %>)"
                                    value="<%= formatAmount(ItemAmt(i)) %>" style="behavior: url(../include/igNumChkRight.htc);
                                    width: 80px">
                                <input type="hidden" id="hItemAmt" class="hItemAmt" value="<%= formatAmount(ItemAmt(i)) %>">
                                <input type="hidden" id="hItemSaved" class="hItemSaved" value="<%= ItemNo(i) %>"></td>
                            <td class="bodycopy">
                                <input type="hidden" name="hItemAmtOrigin<%=i %>" id="hItemAmtOrigin<%=i %>" value="<%=ItemAmtOrigin(i) %>" /></td>
                            <%
        tmpIV = ""
        if ItemInvoice(i) <> "0" then
            tmpIV = ItemInvoice(i)
            hString = "javascript:LinkPayQueue('../acct_tasks/edit_invoice.asp?edit=yes&InvoiceNo=" _
                & tmpIV &"');"
		else
            if ( ItemMAWB(i) <> "") 	 then	
                tmpIV = ItemAgentDebitNo(i)
                if (ItemType(i) = "O") then
                    hString = "javascript:LinkPayQueue('../ocean_import/ocean_import2.asp?iType=O&Edit=yes&MAWB=" _
                        & ItemMAWB(i)&"&AgentOrgAcct="&VendorNo&"&SEC=1')"
				else
                    hString = "javascript:LinkPayQueue('../air_import/air_import2.asp?iType=A&Edit=yes&MAWB=" _
                        & ItemMAWB(i)&"&AgentOrgAcct="&VendorNo&"&SEC=1')"
				end if
			end if
		end if
                            %>
                            <td class="bodycopy">
                                <p onclick="<%=hString%>" class="links" style="cursor: hand; text-decoration: underline">
                                    <%=tmpIV%>
                                </p>
                                <input type="hidden" id="hItemMAWB" class="hItemMAWB" name="hItemMAWB<%= i %>" value="<%= ItemMAWB(i) %>">
                                <input type="hidden" id="hItemDomeHAWB" class="hItemDomeHAWB" name="hItemDomeHAWB<%= i %>" value="<%= ItemDomeHAWB(i) %>">
                                <input type="hidden" id="hItemInvoice" class="hItemInvoice" name="hInvoiceNo<%= i %>" value="<%= tmpIV %>">
                                <input type="hidden" id="hItemInvoiceOrigin" class="hItemInvoiceOrigin" name="hInvoiceNoOrigin<%= i %>" value="<%= ItemInvoice(i) %>">
                                <input type="hidden" id="hItemType" class="hItemType" name="hItemType<%= i %>" value="<%= ItemType(i) %>">
                                <input id="hItemAgentDebitNo" class="hItemAgentDebitNo" name="hItemAgentDebitNo<%= i %>" type="hidden" value="<%= ItemAgentDebitNo(i) %>">
                            </td>
                            <td>
                                <input type="text" class="d_shorttextfield" value="<%=ItemFileNo(i) %>" style="width: 80px" readonly="readonly" />
                            </td>
                            <td align="left">
                                <select name="lstItemName<%= i %>" size="1" class="smallselect ItemName" id="ItemName" style="width: 260"
                                    onchange="ItemChange(<%= i %>)">
                                    <option>Select One</option>
                                    <option>Add New Item</option>
                                    <% for j=0 to ItemIndex-1 %>
                                    <% If ItemNo(i)=DefaultItemNo(j) OR ItemNo(i)="" Then %>
                                    <option value="<%= DefaultItemNo(j) & "-" & DefaultExpense(j) %>" <% if ItemNo(i)=DefaultItemNo(j) then response.write("selected") %>>
                                        <%= igDefaultItem(j) %>
                                    </option>
                                    <% End If %>
                                    <% next %>
                                </select>
                            </td>
                            <td align="left">
                                <input name="txtItemRef<%= i %>" class="shorttextfield" id="ItemRef" value="<%= ItemRef(i) %>"
                                    style="width: 80px" />
                            </td>
                            <td align="left">
                                <% if (ViewBill <> "yes" or BillNo = 0) And i <> tIndex then %>
                                <img src="../images/button_delete.gif" width="50" height="17" onclick="DeleteItem(<%= i %>,this)"
                                    <% if UserRight<5 or Not Branch="" then response.write("disabled") %> style="cursor: hand"
                                    alt="" name="btnDelete" />
                                <% end if%>
                            </td>
                        </tr>
                        <% 
                                end if 
                            next 
                        %>
                        <tr align="left" valign="middle" bgcolor="f3f3f3">
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td width="117" align="left" valign="middle">
                                <% if ViewBill <> "yes" then %>
                                <img src="../images/button_additem.gif" width="64" height="18" name="bAddItem" onclick="AddItem()"
                                    style="cursor: hand" id="btnAddItem"><% end if%></td>
                        </tr>
                        <tr>
                            <td height="1" colspan="9">
                            </td>
                        </tr>
                        <tr align="center" valign="middle" bgcolor="D5E8CB">
                            <td height="24" colspan="9" valign="middle" class="bodycopy">
                                <table width="98%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="25%">
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                        <td width="49%" align="center" valign="middle">
                                            <% if ViewBill <> "yes" then %>
                                            <img src="../images/button_save_payment.gif" width="46" height="18" onclick="SaveClick(<%= TranNo %>)"
                                                <% if UserRight<5 or Not Branch="" then response.write("disabled") %> style="cursor: hand"
                                                id="btnBotSave"><% end if%></td>
                                        <td width="13%" align="right" valign="middle">
                                            &nbsp;</td>
                                        <td width="13%" align="right" valign="middle">
                                            <% if BillNo <> 0 Then%>
                                            <img src="../images/button_delete_bill.gif" width="78" height="18" onclick="DeleteClick()"
                                                <% if UserRight<5 or Not Branch="" then response.write("disabled") %> style="cursor: hand"><% end if%></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <% For j=0 to igItemType.Count-1 %>
            <input type="hidden" class="hIgItemType" id="hIgItemType" value="<%= igItemType(j) %>">
            <% Next %>
        </table>
    </form>
</body>
<% if ViewBill = "yes" then %>

<script type="text/jscript">
	document.form1.hNoItem.value = '<%=newItemCnt%>';
</script>

<% end if %>
<script type="text/javascript">
    function AddItem() {
        var sindex = parseInt(document.form1.hNoItem.value);
        var igItemIndex = parseInt($("select.ItemName").get(sindex).selectedIndex);

        if (igItemIndex > 1) {
            igItemType = $("input.hIgItemType").get(igItemIndex - 1).value;
            ////////////////////////////////////////////////////////////////////////	Get I/V
            var VendorName = "";
            var tmpUrl = "";
            var NewNum = "";
            // commented out - logically wring - by S
//            if (igItemType == "<%=CONST__COST_OF_SALES %>") {
//                VendorName = document.form1.lstVendorName.value;
//                alert("igItemType:" + igItemType);
//                alert("CONST__COST_OF_SALES:" + "<%=CONST__COST_OF_SALES %>");
//                
//                tmpUrl = "get_Invoice_no.asp?Vendor=" + "<%=VendorNo%>" + "&VendorName=" + VendorName
//                NewNum = showModalDialog("bill_Dialog.asp?" + tmpUrl, "", "dialogWidth:400px; dialogHeight:160px; help:no; status:no; scroll:no;center:yes");
//                alert("NewNum:" + NewNum);
//                if (NewNum == "")
//                    return false;
//            }
            ////////////////////////////////////////////////////////////////////////	
            var ItemInfo = $("select.ItemName").get(sindex ).value;
            
            var ItemNo = -1;
            var ItemExpense = "";
            var pos = 0;
            pos = ItemInfo.indexOf("-");
            if (pos >= 0) {
                ItemNo = ItemInfo.substring(0, pos);
                ItemExpense = ItemInfo.substring(pos + 1, 100);
            }

            if (NewNum != "") {
                ItemExpense = $("input.ItemAmt").get(sindex).value;
                $("input.hItemInfo").get(sindex ).value = "0-" + NewNum + "-" + ItemNo + "-" + ItemExpense;
            }
            else
                $("input.hItemInfo").get(sindex).value = "0-0-" + ItemNo + "-" + ItemExpense;

            document.form1.hNoItem.value = parseInt(document.form1.hNoItem.value) + 1;
           
            document.form1.action = "enter_bill.asp?AddItem=yes&NewIVNum=" 
                + NewNum + "&WindowName=" + window.name;
            document.form1.method = "POST";
            document.form1.target = "_self";
            form1.submit();
        }
        else
            alert("Please select an item!");

    }
    
    function CheckClick(k){
        var NoItem = parseInt(document.form1.hNoItem.value);

        var Amt = parseFloat(replaceAll(",", "", document.form1.txtAmount.value));  //formatnumber(document.form1.txtAmount.value,2) ;
        //msgbox document.all("ItemAmt").item(k).Value
        if (IsNumeric($("input.ItemAmt").get(k).value)){
            if ($("input.ItemCheck").get(k).checked)
                Amt = Amt + parseFloat(replaceAll(",", "", $("input.ItemAmt").get(k).value));
            else
                Amt = Amt - parseFloat(replaceAll(",", "", $("input.ItemAmt").get(k).value));
            document.form1.txtAmount.value = Amt.toFixed(2);
       }
    }
    function docModified(dummy) { }

    function SaveClick(TranNo){
        var vendorAcctNo=document.form1.hVendorAcct.value;
        var NoItem=parseInt(document.form1.hNoItem.value);

        if (vendorAcctNo==0 ){
	        alert( "Please select a vendor!");
        }
        else if (NoItem==0){
        }
        else{
	        var save="no";
	        for (var k=0; k< NoItem;k++){
		        if ($("input.ItemCheck").get(k).checked) {

			        if ($("select.ItemName").get(k).selectedIndex < 1 ){
				        alert( "Please select an ITEM!");
				        return false;
			        }
    					
			        var tmpItemName = $("select.ItemName").get(k).value;
			        var pos=tmpItemName.indexOf("-");
			        if (pos>0 )
				        tmpItemName=tmpItemName.substring(0,pos);
                    
                    var vIV="";
                    var CHGIV="";
			        if ($("input.hItemAmt").get(k).value != $("input.ItemAmt").get(k).value) 
                    {
				        vIV = $("input.hItemInvoice").get(k).value;
				        if ( CHECK_IV_STATUS( vIV ) == 6 ) 
					        CHGIV = "yes";
				        else if ( oCHECK_IV_STATUS( vIV ) == 7 ) 
					        CHGIV = "no";
				        else 
					        return false;
                    }
			        else if ($("input.hItemSaved").get(k).value != tmpItemName) 
                    {
				        vIV = $("input.hItemInvoice").get(k).value;
				        if ( CHECK_IV_STATUS_ITEM( vIV ) == 6 ) 
					        CHGIV = "yes";
				        else if ( CHECK_IV_STATUS_ITEM( vIV ) == 7 ) 
					        CHGIV = "no";
				        else 
					        return false;
    				}

			        save="yes";
		        }
	        }
            var viewBill =  "<%=ViewBill%>"	;
	        if (save="yes" ){
		        if (viewBill == "yes" )
			        document.form1.action="enter_bill.asp?save=yes&ViewBill=yes&BillNo=<%=BillNo%>&tNo=<%=TranNo %>&CHGIV=" + CHGIV +"&WindowName=" + window.name;
		        else
			        document.form1.action="enter_bill.asp?save=yes&tNo=<%=TranNo %>&CHGIV=" + CHGIV + "&WindowName=" + window.name;
    		
		        document.form1.method="POST";
		        document.form1.target="_self";
		        form1.submit();
	        }
       }
    }
    function CHECK_IV_STATUS( vIV ){
        return 6;
    }
    function CHECK_IV_STATUS_ITEM( vIV ){
        return 6;
    }

    function ItemAmtChange(k){
        var NoItem=parseInt(document.form1.hNoItem.value);
        if (!IsNumeric(document.all("ItemAmt").item(k).value)) {
	        alert( "Please enter a numeric value!");
	        $("input.ItemAmt").get(k).value=0;
        }
        var BillAmt=0;
        var DueAmt=0;
        for (var i = 0; i < NoItem; i++) {
            var Amt = parseFloat($("input.ItemAmt").get(i).value);
            if ($("input.ItemCheck").get(i).checked)
                BillAmt = BillAmt + Amt;

            DueAmt = DueAmt + Amt;
        }
        document.form1.txtAmount.value = BillAmt;
    }

    function DebitClick(){
	    if (document.form1.rDebit.checked){
		    document.form1.rDebit.value="debit";
		    document.form1.rCredit.checked=false;
        }
	    else{
		    document.form1.rCredit.checked=true;
		    document.form1.rCredit.value="credit";
	    }
    }

    function CreditClick(){
	    if (document.form1.rCredit.checked){
		    document.form1.rCredit.value="credit";
		    document.form1.rDebit.checked=false;
        }
	    else{
		    document.form1.rDebit.checked=true;
		    document.form1.rDebit.value="debit";
	    }
    }

function ItemChange(rNo){
    var sIndex=$("select.ItemName").get(rNo).selectedIndex;
    if (sIndex == 1)
        window.open("edit_co_items.asp" + "?WindowName=" + window.name, "PopupNew", "<%=StrWindow %>");
}
function DeleteClick(){
    var BillNo=document.form1.txtBillNo.value;
    if (BillNo!="" ){
	    if ("Are you sure you want to delete this BILL? \r\nContinue?") {
		    document.form1.action = "enter_bill.asp?DeleteBill=yes"
		    document.form1.method = "POST"
		    document.form1.target = window.name
		    form1.submit()
	    }
    }
}
</script>
<script type="text/vbscript">


Sub MenuMouseOver()
    NoItem=cint(document.form1.hNoItem.Value)
    for i=1 to NoItem+1
	    document.all("ItemName").item(i).style.visibility="hidden"
    next
End Sub
Sub MenuMouseOut()
    NoItem=cint(document.form1.hNoItem.Value)
    for i=1 to NoItem+1
	    document.all("ItemName").item(i).style.visibility="visible"
    next
End Sub

</script>

<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
