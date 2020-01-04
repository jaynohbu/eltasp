<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/header.asp" -->
<%
Public  vLock_ap, vPostBack

'------------------------------------------------------------Included  for Cost Item----------------------------
Public  AddCostItem,  DeleteCost 
Public  mb_no,  TranNo, tNo
Public  NoCostItem,vTotalCost,dItemNo
Public  aCostItemNo(1024),aCostItemName(1024),aCostDesc(1024),aRefNo(1024),aCost(1024),aRealCost(1024),aExpense(1024),aLock_ap(1024)

'///////////////////////
Public aLock_bill(1024) '// by iMoon
'///////////////////////

Public  vIndex, CostItemIndex
Public  DefaultCostItem(1024),DefaultCostItemNo(1024),DefaultExpense(1024),DefaultCostItemDesc(1024),aCostItemDesc(1024)
Public  aCostItemUnitPrice(1024),igDefaultCostItem(1024)
Public aOrigCost(128),aOrigAmt(128),OrigTotalCost	
Public aItemName(128), aItemNo(128),aAmount(1024)
Public vProcessDT

'-------------------------------------------------------------------------------------------------------------
Public Delete, Edit,Search,Save,AddHAWB,DeleteHAWB,DeleteMAWB,vJob
Public vDefault_SalesRep	
Public vSalesPerson
Public rs,rs1,rs2, SQL,SQL1
Public vMAWB,vAgentName,vFileNo,vCarrier,vPieces,vAgentDebitNo,vAgentDebitAmt,vCarrierCode,vCarrierAcct
Public vFLTNo,vETD,vETA,vGrossWeight,vChargeableWeight
Public aHAWB(64),aShipper(64),aConsignee(64),aNotify(64),aDesc(64),aPieces(64)
Public aGrossWT(64),aChgWT(64),aFreightCollect(64),aOCCollect(64),aAN(64),aHAWBLock(64)
Public vExportAgentELTAcct,vAgentOrgAcct
Public vPRDate,vTranDT
Public NoItem 
Public aFILEPrefix(128),aNextFILE(128)
Public fileIndex,vFILEPrefix
Public aAgentName(),aAgentELTAcct(),aAgentOrgAcct()

Dim fLocation(1024),fCode(1024),fPhone(1024),fFax(1024),vCargoCode,Query,i

Public vSec
Public fIndex,cIndex,aIndex,SRIndex,tIndex
Public aSRName(1000)
Public MAWBNotExist,vSubMAWB
Public pos
Public vGrossWT, vChgWT
Public vScale1,vScale2,vScale3
Public vITDate,vLastFreeDate
Public vITNumber,vITEntryPort,vCargoLocation,vPlaceOfDelivery
Public iType
Public tOrgAcct
Public isDeleted

    eltConn.BeginTrans
    
    vScale1 = GetSQLResult("SELECT uom_qty FROM user_profile WHERE elt_account_number=" & elt_account_number, "uom_qty")
    vScale2 = GetSQLResult("SELECT uom FROM user_profile WHERE elt_account_number=" & elt_account_number, "uom")
    vScale3 = vScale2
    
    Call MainProcess
    Call SetPostBack
    
    eltConn.CommitTrans


Sub MainProcess

    vDefault_SalesRep=session_user_lname

    isDeleted = "no"

    Call ASSIGN_INITIAL_VALUES_TO_VARIABLES
    Call GET_REQUEST_QUERY_STRING 
    GET_LIST_BOXES_FROM_DB

    if Save="yes"  then   
        if tNo=TranNo then
            Call GET_REQUEST_FROM_SCREEN 
            Call SAVE_OR_CREATE_MAWB_TO_DB  
            Call LOAD_MAWB_FROM_DB_TO_SCREEN
            Call save_cost_item_and_bill_detail_type("A","I") 
            Call GET_COST_ITEMS_FROM_DB
        else
            Call GET_REQUEST_FROM_SCREEN 
		    Edit="yes"
		    Search = "yes"
	    end if 
    end if

    if Edit="yes" then    
        Call PREPARE_KEYS_FOR_MAWB_DB_LOOKUP
        Call LOAD_MAWB_FROM_DB_TO_SCREEN
        Call GET_COST_ITEMS_FROM_DB
    end if 

    if DeleteMAWB="yes" then 
        Call GET_REQUEST_FROM_SCREEN  

            Call DELETE_INVOICE
		    CALL DELETE_BILL_DETAIL_FROM_BILL_DETAIL_TABLE
            CALL DELETE_COST_ITEMS_FROM_MB_COST_ITEM_TABLE
            Call DELETE_MAWB
            isDeleted = "yes"
            Call LOAD_MAWB_FROM_DB_TO_SCREEN   
    end if 

    if DeleteHAWB="yes" then  
        Call GET_REQUEST_FROM_SCREEN  
        
                dItemNo=Request.QueryString("dItemNo")
                Call DELETE_ONE_INVOICE(aAN(dItemNo))
                Call DELETE_HAWB
       
        Call LOAD_MAWB_FROM_DB_TO_SCREEN    
    end if 

    if AddCostItem="yes" then
      Call GET_REQUEST_FROM_SCREEN
    end if 

    if DeleteCost="yes" then
       Call GET_REQUEST_FROM_SCREEN
       Call DELETE_COST_ITEM_FROM_LIST	  
       CALL CALCULATE_TOTAL_CHARGE_AND_TOTAL_COST   
    end if
    
    call check_ap_lock
    Call CHECK_MAWB_LOCK    
End Sub

%>
<!--  #INCLUDE FILE="../include/aspFunctions_import.inc" -->
<%

Function check_ap_lock
    vLock_ap = ""
	For i=0 To NoCostItem-1 
		If aLock_ap(i) = "Y" Then 
		    vLock_ap = "Y"
		    check_ap_lock = True
		    Exit Function
		End If
	Next
	check_ap_lock = False
End Function

'---------------------------------------------------End of Main  Procedure ----------------------------'


Sub DELETE_BILL_DETAIL_FROM_BILL_DETAIL_TABLE
    SQL= "delete bill_detail where elt_account_number = " & elt_account_number & " and mb_no=N'" & vMAWB &"' AND iType='A'"
    
    eltConn.Execute SQL
End Sub 

Sub  DELETE_COST_ITEMS_FROM_MB_COST_ITEM_TABLE  	
     SQL= "delete from mb_cost_item where elt_account_number = " & elt_account_number & " and mb_no=N'" & vMAWB &"'  AND iType='A'"
	 
	 eltConn.Execute SQL
End Sub 

Sub CALCULATE_TOTAL_CHARGE_AND_TOTAL_COST
    vSubTotal=0
    vTotalCost=0
    for i=0 to NoItem-1
	    vSubTotal=vSubTotal+aAmount(i)
    next
    for i=0 to NoCostItem-1
	    vTotalCost=vTotalCost+aRealCost(i)
    next
    vTotalAmount=vSubTotal
    tIndex=NoItem
End Sub 

Sub DELETE_COST_ITEM_FROM_LIST
		dItemNo=Request.QueryString("rNo")
		for i=dItemNo to NoCostItem-1
			aCostItemNo(i)=aCostItemNo(i+1)
			aExpense(i)=aExpense(i+1)
			aCostDesc(i)=aCostDesc(i+1)
			aRefNo(i)=aRefNo(i+1)
			aRealCost(i)=aRealCost(i+1)
			aLock_ap(i)=aLock_ap(i+1)			
			aLock_bill(i)=aLock_bill(i+1)			
		next
		NoCostItem=NoCostItem-1	
End Sub 

Sub GET_COST_ITEMS_FROM_DB
    for i=0 to 256
        aCostItemNo(i)=empty
        aCostDesc(i)=empty
        aRefNo(i)=empty
	    aRealCost(i)=empty		
    next 
    Dim rs
    Set rs=Server.CreateObject("ADODB.Recordset")
    NoCostItem=0 'Not vMAWB=0 or
    if  Not vMAWB="" then
        SQL= "select item_no,item_desc,ref_no,cost_amount,lock_ap from mb_cost_item where elt_account_number = " & elt_account_number & " and mb_no=N'" & vMAWB& "'  AND iType='A' order by item_id"
	    
	    rs.CursorLocation = adUseClient
	    rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	    Set rs.activeConnection = Nothing
        ccIndex=0
        Do While Not rs.EOF
	        aCostItemNo(ccIndex)=rs("item_no")
	        aCostDesc(ccIndex)=rs("item_desc")
	        aRefNo(ccIndex)=rs("ref_no")
	        aRealCost(ccIndex)=cDbl(rs("cost_amount"))
			
'///////////////////////////////////////////////// by iMoon 12-01-2006
			aLock_ap(ccIndex)=rs("lock_ap")		
			if 	aLock_ap(ccIndex) = "Y" then
				aLock_bill(ccIndex)= get_ap_bill( aCostItemNo(ccIndex), aRealCost(ccIndex), vMAWB )
			else 
				aLock_bill(ccIndex) = ""
			end if
					
	        rs.MoveNext
	        ccIndex=ccIndex+1
        Loop
        rs.Close
    end if 
   
    
    NoCostItem=ccIndex
    vSubTotal=0
    vTotalCost=0
    for i=0 to NoItem-1
	    vSubTotal=vSubTotal+aAmount(i)
    next
    for i=0 to NoCostItem-1
	    vTotalCost=vTotalCost+aRealCost(i)
    next
    vTotalAmount=vSubTotal    
    if NoCostItem < 4 then
	    NoCostItem = 4
    end if
    Set rs=Nothing 
End Sub 

Sub  GET_COST_ITEMS_FROM_SCREEN
   
	for i=0 to NoCostItem-1
	
		item=Request("lstCostItem" & i)
		pos=0
		pos=instr(item,"-")
		
		if pos>0 then
			aCostItemNo(i)=Cint(Mid(item,1,pos-1))
			item=Mid(item,pos+1,200)
		end if

		pos=instr(item,"-")
		
		if pos>0 then
			aExpense(i)=Mid(item,1,pos-1)
			if aExpense(i)="" then aExpense(i)=0
			aCostItemName(i)=Mid(item,pos+1,200)
		end if
		
		aCostDesc(i)=Request("txtCostDesc" & i)
		aRefNo(i)=Request("txtRefNo" & i)
		aRealCost(i)=Request("txtCost" & i)
		aLock_ap(i)=Request("txtLock_ap" & i)
		aLock_bill(i)=Request("txtAPLOCK" & i)
		
		if aRealCost(i)="" then
			aRealCost(i)=0
		else
			aRealCost(i)=cdbl(aRealCost(i))
		end if
	next	
	
	if NoCostItem < 4 then
        NoCostItem = 4
    end if
End Sub 

Sub GET_COST_ITEM_LIST_FROM_DB
    Dim rs
    Set rs=Server.CreateObject("ADODB.Recordset")
    SQL= "select item_no,item_name,item_desc,account_expense,Unit_Price from item_cost where elt_account_number = " & elt_account_number & " order by item_name"
    
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
    CostItemIndex=0  
    Do While Not rs.EOF
	    DefaultCostItemNo(CostItemIndex)=rs("item_no")
	    if IsNull(DefaultCostItemNo(CostItemIndex)) then DefaultCostItemNo(CostItemIndex)=0
	    DefaultCostItem(CostItemIndex)=rs("item_name")
	    DefaultCostItemDesc(CostItemIndex)=rs("item_desc")
	    DefaultExpense(CostItemIndex)=rs("account_expense")
	    if IsNull(DefaultExpense(CostItemIndex)) then DefaultExpense(CostItemIndex)=0
	    aCostItemDesc(CostItemIndex)=DefaultCostItemDesc(CostItemIndex)
	    aCostItemUnitPrice(CostItemIndex) = rs("Unit_Price")
	    if ( len(DefaultCostItem(CostItemIndex))) < 7 then
	    igDefaultCostItem(CostItemIndex) = DefaultCostItem(CostItemIndex) & " " & string(7-len(DefaultCostItem(CostItemIndex)),"-") & " " & DefaultCostItemDesc(CostItemIndex)
	    else
	    igDefaultCostItem(CostItemIndex) = DefaultCostItem(CostItemIndex)
	    end if
	    CostItemIndex=CostItemIndex+1
	    rs.MoveNext
    Loop
    rs.Close
    Set rs=Nothing 
End Sub 
'---------------------------------------------------------

Sub ASSIGN_INITIAL_VALUES_TO_VARIABLES
    vDepCode=""
    vArrCode=""
    MAWBNotExist=""
    iType="A"
    NoItem=0
     
    TranNo=Session("ADCONTranNo") 'keep the transaction session 12/11
    if TranNo="" then
         Session("ADCONTranNo")=0
         TranNo=0
    end if

End Sub

Sub GET_LIST_BOXES_FROM_DB
    Call GET_SALES_PERSONS_FROM_USERS_TABLE
    Call GET_FILE_PREFIX_FROM_USER_PROFILE( "AIJ" )
    Call GET_AGENT_LIST
    Call GET_PORT_LIST    
    Call GET_FREIGHT_LOC_LIST
    Call GET_COST_ITEM_LIST_FROM_DB
End Sub 

'// By Joon on Dec-06-2006 Checks if MAWB is locked or not //////////////////////////////////
Function CHECK_MAWB_LOCK
    If Not IsNull(vMAWB) And Not Trim(vMAWB)="" Then
        For i=0 To UBound(aHAWBLock)
            If aHAWBLock(i)="hidden" Then
                vLock_ap = "Y"
                CHECK_MAWB_LOCK = True
                Exit Function
            End If
        Next
        CHECK_MAWB_LOCK = False
    End If
End Function
'/////////////////////////////////////////////////////////////////////////////////////////////////

Sub DELETE_MAWB
    Dim rs
    Set rs=Server.CreateObject("ADODB.Recordset")

	dSQL= "delete from import_hawb where elt_account_number = " & elt_account_number & " and (agent_elt_acct=" & vExportAgentELTAcct & " or agent_org_acct=" & vAgentOrgAcct & ") and iType='A' and mawb_num=N'" & vMAWB & "' and sec=" & vSec

	rs.Open dSQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText	
	Set rs=Nothing
	
	Set rs=Server.CreateObject("ADODB.Recordset")
	dSQL= "delete from import_mawb where elt_account_number = " & elt_account_number & " and (agent_elt_acct=" & vExportAgentELTAcct & " or agent_org_acct=" & vAgentOrgAcct & ") and iType='A' and mawb_num=N'" & vMAWB & "' and sec=" & vSec

	rs.Open dSQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
    NoItem=0
    vMAWB=""
    Session("mawb")=""
	Set rs=Nothing
End Sub

'// By Joon on Dec-06-2006 Checks if HAWB is locked or not //////////////////////////////////
Function CHECK_INV_LOCK(invNum)
    Dim resV
    resV = "visible"
   
    If Not IsNull(invNum) And Not Trim(invNum)="" Then
        Dim rs
        Set rs=Server.CreateObject("ADODB.Recordset") 

        SQL = "SELECT lock_ar, lock_ap FROM invoice WHERE elt_account_number=" & elt_account_number _
            & " AND invoice_no=" & invNum
        
        Set rs = eltConn.execute(SQL)                
        If Not rs.EOF And Not rs.BOF then
            If rs("lock_ar").value="Y" Or rs("lock_ap").value="Y" Then
                resV = "hidden"
            Else
                resV = "visible"
            End If
            rs.close
            Set rs=Nothing
        End If 
    End If
    CHECK_INV_LOCK = resV
End Function
'/////////////////////////////////////////////////////////////////////////////////////////////////

Sub DELETE_HAWB
    Dim rs
    Set rs=Server.CreateObject("ADODB.Recordset")


    dSQL= "delete from import_hawb where elt_account_number = " & elt_account_number & " and (agent_elt_acct=" & vExportAgentELTAcct & " or agent_org_acct=" & vAgentOrgAcct & ") and iType='A' and mawb_num=N'" & vMAWB & "' and hawb_num=N'" & aHAWB(dItemNo) & "' and sec=" & vSec
    rs.Open dSQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
 
    for i=dItemNo to NoItem-1
	    aHAWB(i)=aHAWB(i+1)					
	    aShipper(i)=aShipper(i+1)
	    aConsignee(i)=aConsignee(i+1)
	    aNotify(i)=aNotify(i+1)
	    aDesc(i)=aDesc(i+1)
	    aPieces(i)=aPieces(i+1)
	    aGrossWT(i)=aGrossWT(i+1)
	    aChgWT(i)=aChgWT(i+1)
	    aFreightCollect(i)=aFreightCollect(i+1)
	    aOCCollect(i)=aOCCollect(i+1)
    next
    NoItem=NoItem-1	
 
    Set rs=Nothing 
End Sub		

'// By Joon on Dec-06-2006 Deletes invoices  ////////////////////////////////////////////////////
Sub DELETE_INVOICE
    
    For i=0 To noItem-1
        If aAN(i) <> "" Then
            DELETE_ONE_INVOICE(aAN(i))
        End If
    Next

End Sub

sub DELETE_ONE_INVOICE( invoice_no )
    DIM tmpMawb,tmpHawb,i,maxInvoice,iCnt
    Set tmpHawb = Server.CreateObject("System.Collections.ArrayList")
    Set rs=Server.CreateObject("ADODB.Recordset")	

	SQL = "select mawb_num from invoice where elt_account_number =" & elt_account_number & " and invoice_no =" & invoice_no
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing

	if NOT rs.eof and NOT rs.bof then

'// gather invoice mawb information 
		tmpMawb = rs("mawb_num")
		rs.Close

		SQL = "select isnull(count(*),0) as icnt from invoice_queue where elt_account_number = " & elt_account_number & " and mawb_num =N'" & tmpMawb & "'"
		
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing
		if NOT rs.eof and NOT rs.bof then
			iCnt = clng(rs("icnt"))
		end if
		rs.Close

'// gather invoice hawb information 
		SQL = "select hawb_num from invoice_hawb where elt_account_number = " & elt_account_number & " and invoice_no =" & invoice_no
		
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing
		do while not rs.eof
			tmpHawb.add rs("hawb_num").value
			rs.MoveNext
		loop
		rs.Close
    else
		rs.Close
		mawb = "no_mawb"
	end if

'// delete invoice
		SQL = "delete invoice where elt_account_number = " & elt_account_number & " and invoice_no =" & invoice_no
		
		eltConn.execute (SQL)

		SQL = "delete invoice_charge_item where elt_account_number = " & elt_account_number & " and invoice_no =" & invoice_no
		
		eltConn.execute (SQL)

		SQL = "delete invoice_cost_item where elt_account_number = " & elt_account_number & " and invoice_no =" & invoice_no
		
		eltConn.execute (SQL)

		SQL = "delete invoice_hawb where elt_account_number = " & elt_account_number & " and invoice_no =" & invoice_no
		
		eltConn.execute (SQL)

		SQL = "delete bill_detail where elt_account_number = " & elt_account_number & " and invoice_no =" & invoice_no & " AND iType='A'"
		
		eltConn.execute (SQL)

		SQL = "delete all_accounts_journal where elt_account_number = " & elt_account_number & " and tran_num =N'" & invoice_no & "'"
		
		eltConn.execute (SQL)

		SQL = "delete all_accounts_journal where elt_account_number = " & elt_account_number & " and customer_number in ( select customer_number from all_accounts_journal " & " where elt_account_number =" & elt_account_number & " group by customer_number  having count(customer_number) = 1 ) and tran_type = 'INIT'"
		
		eltConn.execute (SQL)

		if iCnt > 1 then
			for i=0 To tmpHawb.count-1 
				SQL = "update invoice_queue set invoiced = 'N', outqueue_date=''  where elt_account_number = " & elt_account_number & " and hawb_num =N'" & tmpHawb(i) & "' and mawb_num=N'"& tmpMawb & "'"
				
				eltConn.execute (SQL)
			next
		else
			SQL = "update invoice_queue set invoiced = 'N', outqueue_date=''  where elt_account_number = " & elt_account_number & " and mawb_num=N'"& tmpMawb & "'"
			
			eltConn.execute (SQL)
		end if

		for i=0 To tmpHAWB.count-1 
			SQL = "update import_hawb set invoice_no = 0 where elt_account_number = " & elt_account_number & " and hawb_num =N'" & tmpHAWB(i) & "' and mawb_num=N'"& tmpMawb & "' AND iType='A'"
			
			eltConn.execute (SQL)
		next



    Set hawb = nothing
    Set rs = nothing
end sub
'/////////////////////////////////////////////////////////////////////////////////////////////////
		
Sub SAVE_HAWB_TO_DB
    Dim rs
    Set rs=Server.CreateObject("ADODB.Recordset")

	tIndex=0
	For i=0 To NoItem-1
		if Not aHAWB(i)="" then
			SQL= "select * from import_hawb where elt_account_number =" & elt_account_number & " and (agent_elt_acct=" & vExportAgentELTAcct & " or agent_org_acct=" & vAgentOrgAcct & ") and iType='A' and hawb_num=N'" & aHAWB(i) & "' and sec=" & vSec
			
			rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
			If rs.EOF=true Then
				rs.AddNew
				rs("elt_account_number")=elt_account_number
				rs("agent_elt_acct")=vExportAgentELTAcct
				rs("agent_org_acct")=vAgentOrgAcct
				rs("iType")="A"
				rs("sec")=vSec
			end if
			rs("agent_org_acct")=vAgentOrgAcct
			if Not vTranDT="" then
				rs("tran_dt")=vTranDT
			end if
			rs("process_dt")=vPRDate					
			rs("hawb_num")=aHAWB(i)
			rs("mawb_num")=vMAWB
			rs("shipper_name")=aShipper(i)
			rs("consignee_name")=aConsignee(i)
			rs("notify_name")=aNotify(i)
			rs("desc3")=aDesc(i)
			if aPieces(i)="" then aPieces(i)=0
			rs("pieces")=aPieces(i)
			rs("desc2")=aPieces(i)
			rs("uom")=vUOM
			if aGrossWT(i)="" then aGrossWT(i)=0
			rs("gross_wt")=aGrossWT(i)
			rs("desc4")=aGrossWT(i)
			if aChgWT(i)="" then aChgWT(i)=0
			rs("chg_wt")=aChgWT(i)
			if aFreightCollect(i)="" then aFreightCollect(i)=0
			rs("freight_collect")=aFreightCollect(i)
			if aOCCollect(i)="" then aOCCollect(i)=0
			rs("oc_collect")=aOCCollect(i)
			rs("desc3")=aDesc(i)
			rs("prepared_by") = session_user_lname
			rs("process_dt")=vPRDate
			rs.update
			rs.close
			tIndex=tIndex+1
		end if
		 NoItem=tIndex
	Next
	Set rs=Nothing 
End Sub 
			
Sub SAVE_OR_CREATE_MAWB_TO_DB
    Dim rs
    Set rs=Server.CreateObject("ADODB.Recordset")
    Call GET_NEXT_SEC_NUMBER   
	SQL= "select * from import_mawb where elt_account_number=" & elt_account_number & " and (agent_elt_acct=" & vExportAgentELTAcct & " or agent_org_acct=" & vAgentOrgAcct & ") and iType='A' and MAWB_NUM=N'" & vMAWB & "' and sec=" & vSec
	
	rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	
	if rs.EOF=true then		
		rs.AddNew '// New Master
		rs("elt_account_number")=elt_account_number
		rs("agent_elt_acct")=vExportAgentELTAcct
		rs("agent_org_acct")=vAgentOrgAcct
		rs("mawb_num")=vMAWB
		rs("iType")="A"
		rs("sec")=vSec               				
        rs("CreatedBy")=session_user_lname	
        rs("CreatedDate")=Now
        rs("SalesPerson")=vSalesPerson	
	end if '// Existing Master
	rs("agent_org_acct")=vAgentOrgAcct
	rs("sub_mawb")=vSubMAWB
	if(Not isDate(vPRDate)) then vPRDate=Date
	rs("process_dt")=vPRDate
	rs("export_agent_name")=vAgentName
	vFileNo = GET_FILE_NUMBER("AIJ", vFileNo, vMAWB )
	rs("file_no")=vFileNo
	rs("carrier")=vCarrier
    rs("carrier_code")=vCarrierCode

	rs("pieces")=vPieces
	rs("agent_debit_no")=vAgentDebitNo
	rs("agent_debit_amt")=vTotalCost
	rs("flt_no")=vFLTNo
	if Not vETD="" then
		rs("etd")=vETD
	end if
	if Not vETA="" then
		rs("eta")=vETA
	end if
	rs("gross_wt")=vGrossWT
	rs("chg_wt")=vChgWT
	rs("scale1")=vScale1
	rs("scale2")=vScale2
	rs("scale3")=vScale3
	rs("dep_port")=vDepPort
	rs("arr_port")=vArrPort
	rs("dep_code")=vDepCode
	rs("arr_code")=vArrCode
	rs("cargo_location")=vCargoLocation
	if Not vLastFreeDate="" then
		rs("last_free_date")=vLastFreeDate
	end if
	rs("it_number")=vITNumber
	rs("it_date")=checkBlank(vITDate,Null)
	rs("it_entry_port")=vITEntryPort
	rs("place_of_delivery")=vPlaceOfDelivery			
	rs("SalesPerson")=vSalesPerson	
    rs("ModifiedBy")= session_user_lname
    rs("ModifiedDate")=Now	
    Session("mawb")=vMAWB    
	rs.update
	rs.close
	Session("ADCONTranNo")=Clng(Session("ADCONTranNo"))+1
	TranNo=Clng(Session("ADCONTranNo"))  	   
	Set rs=Nothing		
	CALL UPDATE_USER_NEXT_NUMBER_IN_PREFIX( "AIJ", vFileNo )
	'Call SAVE_HAWB_TO_DB  
END Sub


Sub GET_HAWBS_FROM_SCREEN

    if isnull(NoItem) or NoItem = "" then NoItem = 0
    For i=0 To NoItem -1
	    aHAWB(i)=Request("txtHAWB" & i)			
	    aShipper(i)=Request("txtShipper" & i)
	    aConsignee(i)=Request("txtConsignee" & i)
	    aNotify(i)=Request("txtNotify" & i)
	    aDesc(i)=Request("txtDesc" & i)
	    aPieces(i)=Request("txtPieces" & i)
	    if aPieces(i)="" then aPieces(i)=0
	    aGrossWT(i)=Request("txtGrossWT" & i)
	    if aGrossWT(i)="" then aGrossWT(i)=0
	    aChgWT(i)=Request("txtChgWT" & i)
	    aOCCollect(i)=Request("txtOCCollect" & i)
	    aFreightCollect(i)=Request("txtFreightCollect" & i)
	    
'// Modified by Joon on Dec-12-2005///////////////////////////////////////////
	    aAN(i)=Request("txtAN" & i)
	    aHAWBLock(i)=CHECK_INV_LOCK(aAN(i))
'/////////////////////////////////////////////////////////////////////////////

    Next
End Sub 
	    
Sub PREPARE_KEYS_FOR_MAWB_DB_LOOKUP

    Dim rs
    Set rs=Server.CreateObject("ADODB.Recordset")
    if Search = "yes" then'----------to search ----------require file# or mawb
  
        if Not vJob="" then
	        SQL="select mawb_num,agent_elt_acct,agent_org_acct,sec from import_mawb where elt_account_number=" & elt_account_number & " and replace(file_no,'-','')=N'" & Replace(vJob,"-","") & "' AND iType='A'"
			
			rs.CursorLocation = adUseClient
			rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
			Set rs.activeConnection = Nothing
	        if Not rs.EOF then
		        vMAWB=rs("mawb_num")
		        vExportAgentELTAcct=cLng(rs("agent_elt_acct"))
		        vAgentOrgAcct=cLng(rs("agent_org_acct"))	
		        vSec=cLng(rs("sec"))	
		        rs.close				
	        else	
		        rs.close
		        response.Write("<script language='javascript'>alert('File # '+ '"&vJob&"' + ' does not exist.');</script>")
	            vJob = ""
	        end if	
        	
        elseif Not vMAWB=""  then
            '// Get Last SEC 
	        SQL="select agent_elt_acct,agent_org_acct,sec from import_mawb where elt_account_number=" & elt_account_number & " and mawb_num=N'" & vMAWB & "' AND iType='A'"
			
			rs.CursorLocation = adUseClient
			rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
			Set rs.activeConnection = Nothing
	        if Not rs.EOF then
		        vExportAgentELTAcct=cLng(rs("agent_elt_acct"))
		        vAgentOrgAcct=cLng(rs("agent_org_acct"))	
		        vSec=cLng(rs("sec"))	
		        rs.close
	        else
		        rs.close
		        response.Write("<script language='javascript'>alert('MAWB # '+ '"&vMAWB&"' + ' does not exist.');</script>")

		        vMAWB = ""
	        end if	
        	
        end if
    else'------------------------------if it is not to search  ------------------------------------------------
        if Not vJob="" and vSec = 0 and vExportAgentELTAcct=0 and vAgentOrgAcct=0 then
	        SQL="select mawb_num,agent_elt_acct,agent_org_acct,sec from import_mawb where elt_account_number=" & elt_account_number & " and file_no=N'" & vJob & "' AND iType='A' order by sec desc"
			
			rs.CursorLocation = adUseClient
			rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
			Set rs.activeConnection = Nothing
	        if Not rs.EOF then
		        vMAWB=rs("mawb_num")
		        vExportAgentELTAcct=cLng(rs("agent_elt_acct"))
		        vAgentOrgAcct=cLng(rs("agent_org_acct"))	
		        vSec=cLng(rs("sec"))	
		        rs.close
	        end if   	
        end if
        if Not vMAWB=""  then
	        SQL="select agent_elt_acct,agent_org_acct,sec from import_mawb where elt_account_number=" & elt_account_number & " and mawb_num=N'" & vMAWB & "' AND iType='A'"
			
			rs.CursorLocation = adUseClient
			rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
			Set rs.activeConnection = Nothing
	        if Not rs.EOF then
		        vExportAgentELTAcct=cLng(rs("agent_elt_acct"))
		        vAgentOrgAcct=cLng(rs("agent_org_acct"))	
		        vSec=cLng(rs("sec"))	
		        rs.close
	        else
		        rs.close
		        response.Write("<script language='javascript'>alert('MAWB # '+ '"&vMAWB&"' + ' does not exist.');</script>")

		        vMAWB = ""
	        end if	
	    end if 
	    
	    if Not vMAWB="" and Not vSec=0 then
	        SQL="select agent_elt_acct,agent_org_acct,sec from import_mawb where elt_account_number=" & elt_account_number & " and mawb_num=N'" & vMAWB & "' AND iType='A'"
			
			rs.CursorLocation = adUseClient
			rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
			Set rs.activeConnection = Nothing
		        if Not rs.EOF then
		        vExportAgentELTAcct=cLng(rs("agent_elt_acct"))
		        vAgentOrgAcct=cLng(rs("agent_org_acct"))	
		        vSec=cLng(rs("sec"))	
		        rs.close
	        else
		        rs.close
		        response.Write("<script language='javascript'>alert('MAWB # '+ '"&vMAWB&"' + ' does not exist.');</script>")

		        vMAWB = ""
	        end if	
	    end if 
	    
        if Not vMAWB="" and vSec = 0 and vExportAgentELTAcct=0 and vAgentOrgAcct=0 then
	        SQL="select agent_elt_acct,agent_org_acct,sec from import_mawb where elt_account_number=" & elt_account_number & " and mawb_num=N'" & vMAWB & "' AND iType='A'"
	        
			rs.CursorLocation = adUseClient
			rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
			Set rs.activeConnection = Nothing
	        if Not rs.EOF then
		        vExportAgentELTAcct=cLng(rs("agent_elt_acct"))
		        vAgentOrgAcct=cLng(rs("agent_org_acct"))	
		        vSec=cLng(rs("sec"))	
		        rs.close
	        end if   		
        end if    	
   end if
   Set rs=Nothing 
   
End Sub 

Function IsPostBack
    Dim result    
        if vPostBack = "true" then 
            result= true
        else           
           result= false
        end if     
    IsPostBack= result
End Function

Sub SetPostBack
    if vPostBack="" then vPostBack="true"
End Sub 

Sub GET_REQUEST_QUERY_STRING
    
    
    tNo=Request.QueryString("tNo")

    if tNO="" then
	    tNO=0
    else
	    tNo=cLng(tNo)
    end if    
	
    vMAWB=Request.QueryString("MAWB")
    vExportAgentELTAcct=Request.QueryString("AgentELTAcct")
    if vExportAgentELTAcct="" then vExportAgentELTAcct=0
    vAgentOrgAcct=Request.QueryString("AgentOrgAcct")
    if vAgentOrgAcct="" then vAgentOrgAcct=0
    Delete=Request.QueryString("Delete")
    Search=Request.QueryString("Search")
    vJob=Request.QueryString("JOB")
    vSec=Request.QueryString("Sec")   
    Edit=Request.QueryString("Edit")
    Save=Request.QueryString("Save")    
    AddHAWB=Request.QueryString("AddHAWB")
    DeleteHAWB=Request.QueryString("DeleteHAWB")
    DeleteMAWB=Request.QueryString("DeleteMAWB")
    dItemNo=Request.QueryString("dItemNo") 
    vPostBack=Request("hPostBack")
    
    if IsPostBack = false then         
        Session("mawb")= vMAWB
    end if 

    AddCostItem=Request.QueryString("AddCostItem")   
    DeleteCost=Request.QueryString("DeleteCost")
	NoCostItem=cInt(request.QueryString("NoCostItem"))
	
	if NoCostItem < 4 then
        NoCostItem = 4
    end if
    
    If (Edit = "yes" Or Search = "yes") And vMAWB <> "" Then
        Dim vEDTSec
        SQL = "SELECT max(sec) FROM import_mawb WHERE mawb_num=N'" & vMAWB _
            & "' AND agent_elt_acct<>0 AND elt_account_number=" & elt_account_number & " AND processed='N'"

        vEDTSec = GetSQLResult(SQL, Null)
        If vEDTSec <> "" Then
            Response.Redirect("air_import2A.asp?MAWB=" & Server.URLEncode(vMAWB) & "&SEC=" & vEDTSec)
        End If
    End If
    
End Sub


SUB UPDATE_USER_NEXT_NUMBER_IN_PREFIX( strType, tmpFileNo )

    Dim rs2
    Set rs2=Server.CreateObject("ADODB.Recordset")
    DIM tmpNextNo,tPrefix

    if aFILEPrefix(0) = "NONE" then
	    exit sub
    end if

    pos=0
    pos=instr(tmpFileNo,"-")
    if pos>0 then
	    tPrefix=Mid(tmpFileNo,1,pos-1)
	    tmpNextNo=Mid(tmpFileNo,pos+1,32)
    else
	    exit sub
    end if

    SQL= "select next_no from user_prefix where elt_account_number=" & elt_account_number & " and type=N'"& strType &"' and prefix=N'" & tPrefix & "'"
    
    rs2.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
    If Not rs2.EOF Then
	    if cLng(tmpNextNo)>=cLng(rs2("next_no")) then
		    rs2("next_no")=cLng(tmpNextNo)+1
		    rs2.Update
	    end if
	    for i=0 to fileIndex
		    if tPrefix=aFILEPrefix(i) then
			    aNextFILE(i)=cLng(tmpNextNo)+1
		    end if
	    next
    end if
    rs2.Close
    Set rs2=Nothing
    
END SUB

FUNCTION GET_FILE_NUMBER ( strType, strFileNo, tmpMAWB)

    Dim rs2
    Set rs2=Server.CreateObject("ADODB.Recordset")
    DIM  tmpFileNo,FileNoExist,vNextFileNo
    vFILEPrefix = request("txtFileNo")
    pos=0
    pos=instr(vFILEPrefix,"-")
    if pos>0 then
	    vFILEPrefix=Mid(vFILEPrefix,1,pos-1)
    Else
	    GET_FILE_NUMBER = strFileNo
	    exit function
    End If
    if isnull(vFILEPrefix) or vFILEPrefix = "" then
	    GET_FILE_NUMBER = strFileNo
	    exit function
    end if
    vNextFileNo = request("hNEXTFILENo")
    if vNextFileNo = "" then 
	    vNextFileNo = "0"
    end if    	
    tmpFileNo = strFileNo
    if tmpFileNo = "" then
	    if Not vFILEPrefix="" then
		    tmpFileNo=vFILEPrefix & "-" & vNextFileNo
	    else
		    tmpFileNo=vNextFileNo
	    end if
    end if
    FileNoExist = true
    DO WHILE FileNoExist
	    SQL= "select file_no from import_mawb where elt_account_number = " & elt_account_number & " and file_no=N'" & tmpFileNo & "' and mawb_num<>N'"&tmpMAWB&"' AND iType='A'"
	    
	    rs2.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	    If rs2.EOF=true Then		
		    FileNoExist=false
		    rs2.close
		    GET_FILE_NUMBER = tmpFileNo
		    exit function
	    else
		    tmpFileNo = rs2("file_no")
		    rs2.close
		    pos=0
		    pos=instr(tmpFileNo,"-")
		    if pos>0 then
			    vNextFileNo=Mid(tmpFileNo,pos+1,32)
		    end if

		    vNextFileNo=vNextFileNo+1
		    tmpFileNo=vFILEPrefix & "-" & vNextFileNo
	    end if
    LOOP    
    Set rs2=Nothing
    
END FUNCTION


SUB GET_FILE_PREFIX_FROM_USER_PROFILE( strType )

    Dim rs2
    Dim vNEXTFILENo
    Set rs2=Server.CreateObject("ADODB.Recordset")
    if isnull(vFileNo) then
        vFileNo = ""
    end if
    vFILEPrefix=Request("hFILEPrefix")
    if isnull(vFILEPrefix) then
        vFILEPrefix = ""
    end if
    if vFILEPrefix = "" then
        if not vFileNo = "" then
		        pos=0
		        pos=instr(vFileNo,"-")
		        if pos>0 then
			        vFILEPrefix=Mid(vFileNo,1,pos-1)
		        end if
        end if
    end if
    SQL= "select prefix,next_no from user_prefix where elt_account_number = " & elt_account_number & " and type=N'"& strType & "' order by prefix"
    
    rs2.Open SQL, eltConn, , , adCmdText
    fileIndex=0
    do While Not rs2.EOF
        aFILEPrefix(fileIndex)=rs2("prefix")
        aNextFILE(fileIndex)=rs2("next_no")
        if vFILEPrefix = "" then
	        vFILEPrefix = aFILEPrefix(fileIndex)
        end if    	
        if aFILEPrefix(fileIndex)= vFILEPrefix then
	        vNEXTFILENo = aNextFILE(fileIndex)
        end if    	
        rs2.MoveNext
        fileIndex=fileIndex+1
    loop
    rs2.Close
    if fileIndex = 0 then
        aFILEPrefix(0) = "NONE"
        fileIndex = 1
        vFILEPrefix = ""
    end if
    if NOT vFileNo = ""  then
        aFILEPrefix(0) = "EDIT"
        fileIndex = 1
        vFILEPrefix = ""	
    end if
    if trim(vFileNo) = "" then
        if Not vFILEPrefix="" then
	        vFileNo=vFILEPrefix & "-" & vNextFileNo
        else
	        vFileNo=vNextFileNo
        end if
    end if
    Set rs2=Nothing
End SUB

SUB GET_DEFAULT_SALES_PERSON_FROM_DB
  Dim rs
  Set rs=Server.CreateObject("ADODB.Recordset")
  if isnull(vExportAgent) or vExportAgent = 0 then
   vSalesPerson ="" 
  else 
    SQL= "select SalesPerson from organization where elt_account_number = "& elt_account_number &" and org_account_number = "& vExportAgent
    
    rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
       if not rs.EOF then	
         vSalesPerson = rs("SalesPerson")
       else vSalesPerson ="" 
       end if   
   rs.close
 end if 
 Set rs=Nothing
END SUB

SUB GET_SALES_PERSONS_FROM_USERS_TABLE
    Dim rs
    Set rs=Server.CreateObject("ADODB.Recordset")
    SQL= "select code from all_code where elt_account_number = " & elt_account_number & " and type=22 order by code"
    
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
    SRIndex=0
	    do While Not rs.EOF
		    aSRName(SRIndex)=rs("code")	
		    rs.MoveNext
		    SRIndex=SRIndex+1
	    loop
	    rs.Close
	Set rs=Nothing
END SUB 

SUB LOAD_MAWB_FROM_DB_TO_SCREEN'---------------------(11/21/06)    
        
    Dim rs_to_scr
    Set rs_to_scr=Server.CreateObject("ADODB.Recordset")  
    
    if Not vMAWB="" and Not (vExportAgentELTAcct=0 and vAgentOrgAcct=0) then
		if Not vAgentOrgAcct=0 then
			SQL="select a.*,b.org_account_number from import_mawb a LEFT OUTER JOIN organization b ON "_
			    & "(a.elt_account_number=b.elt_account_number AND (a.carrier=b.dba_name OR a.carrier=b.dba_name+'['+LTRIM(RTRIM(b.class_code))+']') AND a.carrier_code=b.carrier_code) " _
			    & "WHERE a.elt_account_number=" & elt_account_number _
			    & " and a.agent_org_acct=" & vAgentOrgAcct & " and a.iType='A' and a.mawb_num=N'" _
			    & vMAWB & "' and a.Sec=" & vSec
		else
			SQL="select a.*,b.org_account_number from import_mawb a LEFT OUTER JOIN organization b ON "_
			    & "(a.elt_account_number=b.elt_account_number AND (a.carrier=b.dba_name OR a.carrier=b.dba_name+'['+LTRIM(RTRIM(b.class_code))+']') AND a.carrier_code=b.carrier_code) " _ 
			    & "WHERE a.elt_account_number=" & elt_account_number _
			    & " and a.agent_elt_acct=" & vExportAgentELTAcct & " and a.iType='A' and a.mawb_num=N'" _
			    & vMAWB & "' and a.Sec=" & vSec
		end if
		
		
		rs_to_scr.Open SQL, eltConn, , , adCmdText		
		if Not rs_to_scr.EOF then	
		    Session("mawb")=vMAWB	
			vExportAgentELTAcct=cLng(rs_to_scr("agent_elt_acct"))
			vAgentOrgAcct=cLng(rs_to_scr("agent_org_acct"))
			vSubMAWB=rs_to_scr("sub_mawb")
			vTranDT=rs_to_scr("tran_dt")
			vAgentName=rs_to_scr("export_agent_name")
			vFileNo=rs_to_scr("file_no")
			vCarrier=rs_to_scr("carrier")
			vCarrierCode= rs_to_scr("carrier_code")
			vCarrierAcct = rs_to_scr("org_account_number")
			vPieces=rs_to_scr("pieces")
			vAgentDebitNo=rs_to_scr("agent_debit_no")
			vFLTNo=rs_to_scr("flt_no")
			vETD=rs_to_scr("etd")
			vETA=rs_to_scr("eta")
			vGrossWT=rs_to_scr("gross_wt")
			vChgWT=rs_to_scr("chg_wt")
			vScale1=rs_to_scr("scale1")
			vScale2=rs_to_scr("scale2")
			vScale3=rs_to_scr("scale3")
			vDepPort=rs_to_scr("dep_port")
			vArrPort=rs_to_scr("arr_port")
			
			vDepCode=rs_to_scr("dep_code")
			vArrCode=rs_to_scr("arr_code")
			
			vCargoLocation=rs_to_scr("cargo_location")
			
            if not isnull(vCargoLocation) and  vCargoLocation<>"" then 				
			    tmp=Split(vCargoLocation,"-")
			    vCargoCode=tmp(0)
			end if 
			
			vLastFreeDate=rs_to_scr("last_free_date")
			vITNumber=rs_to_scr("it_number")
			vITDate=rs_to_scr("it_date")
			vITEntryPort=rs_to_scr("it_entry_port")
			vPlaceOfDelivery=rs_to_scr("place_of_delivery")
			vPRDate=rs_to_scr("process_dt")			
			if(isnull(rs_to_scr("SalesPerson"))) then 
     		 vSalesPerson=""
             else 
     		 vSalesPerson=rs_to_scr("SalesPerson")
            end if 			
            
			If Not IsNull(vDepPort) Then vDepPort = Replace(vDepPort,"Select One","")
			If Not IsNull(vArrPort) Then vArrPort = Replace(vArrPort,"Select One","")
			If Not IsNull(vCargoLocation) Then vCargoLocation = Replace(vCargoLocation,"Select One","")
			If Not IsNull(vPlaceOfDelivery) Then vPlaceOfDelivery = Replace(vPlaceOfDelivery,"Select One","")
			If Not IsNull(vITEntryPort) Then vITEntryPort = Replace(vITEntryPort,"Select One","")
		else
			MAWBNotExist="yes"
		end if
		rs_to_scr.close	
		Call GET_HAWBS_FROM_DB
		
	else
		MAWBNotExist="yes"
	end if
	
End SUB

Sub GET_HAWBS_FROM_DB
    Dim rs1
	SQL="select * from import_hawb where elt_account_number=" & elt_account_number & " and iType='A' and mawb_num=N'" & vMAWB &"' AND sec=" & vSec 
	

    Dim rs_to_scr
    Set rs_to_scr=Server.CreateObject("ADODB.Recordset")  
    rs_to_scr.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText		
    
    tIndex=0
    Do While Not rs_to_scr.EOF
	    aHAWB(tIndex)=rs_to_scr("hawb_num")
	    aShipper(tIndex)=rs_to_scr("shipper_name")
	    aConsignee(tIndex)=rs_to_scr("consignee_name")
	    aNotify(tIndex)=rs_to_scr("notify_name")
	    aDesc(tIndex)=rs_to_scr("desc3")
	    aPieces(tIndex)=rs_to_scr("pieces")
	    aGrossWT(tIndex)=rs_to_scr("gross_wt")
	    aChgWT(tIndex)=rs_to_scr("chg_wt")
		aFreightCollect(tIndex)=rs_to_scr("freight_collect")
	    aOCCollect(tIndex)=rs_to_scr("oc_collect")
	    aAN(tIndex)=rs_to_scr("invoice_no")
        aHAWBLock(tIndex)=CHECK_INV_LOCK(aAN(tIndex))        
	    tOrgAcct=rs_to_scr("agent_org_acct")
	    if Not IsNull(tOrgAcct) then
		    tOrgAcct=cLng(tOrgAcct)
	    else
		    tOrgAcct=0
	    end if
	    if tOrgAcct=0 then
		    rs_to_scr("agent_org_acct")=vAgentOrgAcct
		    rs_to_scr.Update
	    end if
	    rs_to_scr.MoveNext
	    tIndex=tIndex+1
    Loop
    rs_to_scr.close   
    NoItem=tIndex        
   
    Set rs1=Nothing 
    Set rs_to_scr=Nothing 

End Sub

Sub GET_FREIGHT_LOC_LIST
    Dim rs
    Set rs=Server.CreateObject("ADODB.Recordset")     
    SQL= "select location,firm_code,phone,fax from freight_location where elt_account_number = " & elt_account_number & " order by location"
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
    fIndex=0
    Do While Not rs.EOF
	    fLocation(fIndex)=rs("location")
	    fCode(fIndex)=rs("firm_code")
	    fPhone(fIndex)=rs("phone")
	    fFax(fIndex)=rs("fax")
	    fIndex=fIndex+1
	    rs.MoveNext
    Loop
    rs.Close
    Set rs=Nothing
End Sub

Sub GET_NEXT_SEC_NUMBER
    Dim rs
      Set rs=Server.CreateObject("ADODB.Recordset") 
    if vSec=0 then
        SQL= "select max(sec) as sec from import_mawb where elt_account_number=" & elt_account_number & " and (agent_elt_acct=" & vExportAgentELTAcct & " or agent_org_acct=" & vAgentOrgAcct & ") and iType='A' and MAWB_NUM=N'" & vMAWB & "'"
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
        if rs.EOF then
	        vSec=1
        else
	        vSec=rs("sec")
	        if isNull(vSec) then
		        vSec=1
	        else
		        vSec=cInt(vSec)
	        end if
        end if
        rs.Close
    end if
    Set rs=Nothing 
End Sub


Sub GET_AGENT_LIST 
    Dim rs
    Set rs=Server.CreateObject("ADODB.Recordset") 
    dim maxSize
    Query = " SELECT  COUNT(org_account_number)  from organization where elt_account_number = " & elt_account_number & " and is_agent='Y' "

	rs.CursorLocation = adUseClient
	rs.Open Query, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
    If Not (rs.BOF Or rs.EOF) Then
        maxSize =rs(0)
    End If
    rs.close
    maxSize=maxSize+20   
    redim aAgentName(maxSize),aAgentELTAcct(maxSize),aAgentOrgAcct(maxSize)
	
    aIndex=1
    aAgentName(0)="Select One"
    aAgentELTAcct(0)=0
    aAgentOrgAcct(0)=0
    
	SQL = "SELECT agent_elt_acct,org_account_number, " _
            & "CASE WHEN isnull(class_code,'') = '' THEN dba_name " _
            & "ELSE dba_name + '[' + RTRIM(LTRIM(isnull(class_code,''))) + ']' " _
            & "END as dba_name FROM organization where elt_account_number = " & elt_account_number _
            & " and is_agent='Y' order by dba_name"  
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
   
    Do While Not rs.EOF 
	    aAgentName(aIndex)=rs("dba_name")
	    aAgentOrgAcct(aIndex)=cLng(rs("org_account_number"))
	    aAgentELTAcct(aIndex)=rs("agent_elt_acct")
	    if IsNull(aAgentELTAcct(aIndex)) or aAgentELTAcct(aIndex)="" then
		    aAgentELTAcct(aIndex)=0
	    else
		    aAgentELTAcct(aIndex)=aAgentELTAcct(aIndex)
	    end if
	    rs.MoveNext
	    aIndex=aIndex+1
    Loop
    rs.close
    Set rs=Nothing
End Sub 

Sub GET_REQUEST_FROM_SCREEN 

    vTotalCost = Request("txtTotalCost")
    vTotalCost = checkBlank(vTotalCost,0)
    vExportAgentELTAcct = checkBlank(Request("hExportAgentELTAcct"),0)
    vAgentOrgAcct = checkBlank(Request("hAgentOrgAcct"),0)
    
    vTranDT=Request("hTranDT")
    vMAWB=Request("txtMAWB")
    if vSec="" then vSec=Request("hSec")
    if vSec="" then vSec=0
    NoItem=Request("hNoItem")
    if isnull(NoItem) or NoItem = "" then NoItem = 0
    MAWBNotExist=Request("hMAWBNotExist")
    vSubMAWB=Request("txtSubMAWB")

    vAgentOrgAcct = Request("hFFAgentAcct").Item
    vAgentName = Request("lstFFAgent").Item

    if vAgentOrgAcct="" then vAgentOrgAcct=0
    vFileNo=Request("txtFileNo")
    SQL = "SELECT CASE WHEN ISNULL(dba_name,'') = '' Then dba_name+'['+LTRIM(RTRIM(class_code))+']' ELSE dba_name END AS dba_name " _
        & "FROM organization WHERE elt_account_number=" & elt_account_number _
        & " AND org_account_number=" & checkBlank(Request.Form("hCarrierAcct"),0)
    vCarrier = GetSQLResult(SQL, "dba_name")
    vCarrierCode = Request.Form("hCarrierCode")

    vPieces=Request("txtPieces")
    if vPieces="" then vPieces=0
    vGrossWT=Request("txtGrossWT")
    if vGrossWT="" then vGrossWT=0
    vChgWT=Request("txtChgWT")
    if vChgWT="" then vChgWT=0
    vScale1=Request("lstScale1")
    vScale2=Request("lstScale2")
    vScale3=Request("lstScale3")
    vAgentDebitNo=Request("txtAgentDebitNo")
    vFLTNo=Request("txtFLTNo")
    vETD=Request("txtETD")
    vETA=Request("txtETA")
    
	vDepPort=Request("hDepText")
    vArrPort=Request("hArrText")
	vDepCode=Request("lstDepPort")
    vArrCode=Request("lstArrPort")
    
    vCargoLocation=Request("lstCargoLocation")
    
    if not isnull(vCargoLocation) and  vCargoLocation<>"" then 				
			    tmp=Split(vCargoLocation,"-")
			    vCargoCode=tmp(0)
	end if 
    vLastFreeDate=Request("txtLastFreeDate")
    vITNumber=Request("txtITNumber")
    vITDate=Request("txtITDate")
    vITEntryPort=Request("lstITEntryPort")
    vPlaceOfDelivery=Request("txtPlaceOfDelivery")	
    vSalesPerson=Request("lstSalesRP")
    if vSalesPerson = "none" then
        Call GET_DEFAULT_SALES_PERSON_FROM_DB
    end if
    vPRDate=Request("txtDate")   
    if trim(vMAWB) = "" then
	if trim(vPRDate) = "" then
		vPRDate = DATE
	end if
    end if    
    If Not IsNull(vDepPort) Then vDepPort = Replace(vDepPort,"Select One","")
    If Not IsNull(vArrPort) Then vArrPort = Replace(vArrPort,"Select One","")
    If Not IsNull(vCargoLocation) Then vCargoLocation = Replace(vCargoLocation,"Select One","")
    If Not IsNull(vPlaceOfDelivery) Then vPlaceOfDelivery = Replace(vPlaceOfDelivery,"Select One","")
    If Not IsNull(vITEntryPort) Then vITEntryPort = Replace(vITEntryPort,"Select One","") 

    Call GET_HAWBS_FROM_SCREEN
    
    '----------------------------------11/29/06------------------
    vProcessDT=Request("txtDate")'------into Get From Request
    if Not IsDate(vProcessDT) then vProcessDT=Date 
    
    NoCostItem=Request("hNoCostItem")
	if NoCostItem="" then
		NoCostItem=0
	else
		NoCostItem=CInt(NoCostItem)
	end if
    Call GET_COST_ITEMS_FROM_SCREEN	
    
    
End Sub 

Function checkBlank(arg1,arg2)
    Dim result
    If IsNull(arg1) Or Trim(arg1)="" Then
        result = arg2
    Else
        result = arg1
    End If    
    checkBlank = result
    
End Function

%>
<!--  #include file="../include/import_deconsol_functions.inc" -->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
    <title>Import MAWB/HAWB</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <!-- /Start of Combobox/ -->

    <script type="text/javascript">

    function validateSalesRep(){

         var txtSalesRep=document.getElementById("txtSalesRep");
         var salesRep=txtSalesRep.value;
         if(salesRep!=""){       
            return true;
         }else{
            //txtSalesRep.focus();
            return false;
        }
    }

//ADDef by stanley Limit Fumction
    function checkLimit(obj, limit,limit2)
    {
        var num=obj.value;
        var tempArray = new Array();
        tempArray = num.split(".");
        if(num <= limit)
        {
            return true;
        }
        else
        {
            if(num > limit){
                obj.value = num.substring(0,limit2);
            }
            else{
                obj.value = parseFloat(obj.value).toFixed(2);
            }

        }
    }
    
        function lstCarrierNameChange(orgNum,orgName){
            var hiddenObj = document.getElementById("hCarrierAcct");
            var hiddenCodeObj = document.getElementById("hCarrierCode");
            var txtObj = document.getElementById("lstCarrierName");
            var divObj = document.getElementById("lstCarrierNameDiv");
            
            var temp = new Array();
            var tempStr = getOrganizationInfo(orgNum,"C")

            if(tempStr != null && tempStr != "")
            {
                temp = tempStr.split("-");
                hiddenCodeObj.value = temp[0];
            }
            
            hiddenObj.value = orgNum;
            
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
            divObj.style.height = "0px";
		    divObj.innerHTML = "";
        }


        function lstFFAgentChange(orgNum,orgName)
        {
            var hiddenObj = document.getElementById("hFFAgentAcct");
            var txtObj = document.getElementById("lstFFAgent");
            var divObj = document.getElementById("lstFFAgentDiv");

            hiddenObj.value = orgNum;
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
            divObj.style.height = "0px";
        }
    
        function getOrganizationInfo(orgNum,infoFormat){
            if (window.ActiveXObject) {
                try {
                    xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
                } catch(error) {
                    try {
                        xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
                    } catch(error) { return ""; }
                }
            } 
            else if (window.XMLHttpRequest) {
                xmlHTTP = new XMLHttpRequest();
            } 
            else { return ""; }

            var url="/ASP/ajaxFunctions/ajax_get_org_address_info.asp?type=" + infoFormat + "&org=" + orgNum;
        
            xmlHTTP.open("GET",encodeURI(url),false); 
            xmlHTTP.send();
            
            return xmlHTTP.responseText; 
        }
    </script>

    <script type="text/javascript" language="javascript" src="/ASP/ajaxFunctions/ajax.js"></script>

    <script type="text/javascript" src="../include/JPED.js"></script>

    <script type="text/javascript" src="../Include/JPTableDOM.js"></script>

    <!-- /End of Combobox/ -->
    <style type="text/css">
<!--
.style1 {color: #CC6600}
.style3 {color: #cc6600}
.style4 {color: #663366}
.numberalign {
	font-weight: bold;
	font-size: 9px;
	text-align: right;
	font-family: Verdana, Arial, Helvetica, sans-serif;
}
body {
	margin-left: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
-->
</style>
</head>

<script type="text/jscript">
function navigateAway() 
{
    var msg;
    var isDocBeingSubmitted = document.getElementById("isDocBeingSubmitted");
    var isDocBeingModified = document.getElementById("isDocBeingModified");
    
    msg = "----------------------------------------------------------\n";
    msg += "The form has not been saved.\n";
    msg += "All changes you have made will be lost\n";
    msg += "----------------------------------------------------------";
    
    if (isDocBeingSubmitted.value == "false" && isDocBeingModified.value == "true") 
    {
        event.returnValue = msg;
    }
}

function confirmGoAway() 
{
    var msg = "The form has not been saved.\n";
    msg += "Continue without saving? ";
    var isGO = confirm(msg);
        
    if (isGO== true)
    {
        document.form1.isDocBeingModified.value = "false";
        return true;
    }
    else
    {
        return false;
    }
}

function docModified(arg) {

    var isDocBeingModified = document.getElementById("isDocBeingModified");
    isDocBeingModified.value = arg;
}

function forwardToNew(){

    window.location.href="air_import2.asp";
}
</script>

<script type="text/javascript">
function selectSearchType(){

  var selectBox = document.getElementById('SearchType');
  var typemaster = document.getElementById('searchmaster');
	typemaster.style.display= (selectBox.value == 'masterNo') ? '' : 'none';
  var typefile = document.getElementById('searchfile');
	typefile.style.display= (selectBox.value == 'fileNo') ? '' : 'none';
}
</script>

<!--  #include file="../include/recent_file.asp" -->
<body onbeforeunload="navigateAway();" <% if isdeleted="yes" then response.write("onload='forwardToNew();'")%>
    link="336699" vlink="336699" topmargin="0" onload="self.focus()" id="ed">
    <!-- tooltip placeholder -->
    <div id="tooltipcontent">
    </div>
    <!-- placeholder ends -->
    <form name="form1" onkeydown="docModified('true');">
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td width="40%" height="32" align="left" valign="middle" class="pageheader">
                    NEW/Edit Deconsolidation</td>
                <td width="34%" align="right" valign="middle">
                    <table border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td width="50%" height="27" align="right" valign="middle">
                                <img src="../Images/spacer.gif" width="1" height="27" align="absmiddle">
                                <select name="select" class="bodyheader" id="SearchType" onchange="selectSearchType();"
                                    style="width: 126px">
                                    <option value="masterNo" selected="selected">MASTER AWB NO.</option>
                                    <option value="fileNo">FILE NO.</option>
                                </select>
                            </td>
                            <td width="50%" align="right" valign="middle">
                                <div id="searchmaster">
                                    <span class="bodyheader style4">
                                        <input name="txtSMAWB" type="text" class="lookup" style="width: 120px" value="Master No. Here"
                                            onfocus="javascript: this.value=''; this.style.color='#000000'; " onkeypress="javascript: if(event.keyCode == 13) { LookUp(); }"><img
                                                src="../images/icon_search.gif" name="B1" width="33" height="27" align="absmiddle"
                                                style="cursor: hand" onclick="LookUp()"></span>
                                </div>
                                <div id="searchfile" style="display: none;">
                                    <span class="bodyheader style4">
                                        <input name="txtJobNum" type="text" class="lookup" style="width: 120px" value="File No. Here"
                                            onfocus="javascript: this.value=''; this.style.color='#000000'; " onkeypress="javascript: if(event.keyCode == 13) { LookupFile(); }"><img
                                                src="../images/icon_search.gif" name="B1" width="33" height="27" align="absmiddle"
                                                style="cursor: hand" onclick="LookupFile()"></span>
                                </div>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <div class="selectarea">
        </div>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#ba9590">
            <tr>
                <td>
                    <!-- start of scroll bar -->
                    <input type="hidden" name="scrollPositionX">
                    <input type="hidden" name="scrollPositionY">
                    <input type="hidden" id="isDocBeingSubmitted" value="false" />
                    <input type="hidden" id="isDocBeingModified" value="false" />
                    <!-- end of scroll bar -->
                    <input type="hidden" name="hMAWB" value="<%= vMAWB %>" />
                    <input name="hPostBack" type="hidden" value="<%= vPostBack %>" />
                    <input type="hidden" name="hSec" value="<%= vSec %>" />
                    <input type="hidden" name="hNoItem" value="<%= NoItem %>">
                    <input type="hidden" name="hExportAgentELTAcct" value="<%= vExportAgentELTAcct %>" />
                    <input type="hidden" name="hAgentOrgAcct" value="<%= vAgentOrgAcct %>" />
                    <input type="hidden" name="hTranDT" value="<%= vTranDT %>" />
                    <input type="hidden" name="hPCS">
                    <input type="hidden" name="hGrossWT">
                    <input type="hidden" name="hMAWBNotExist" value="<%= MAWBNotExist %>" />
                    <!--// by ig 7/11/2006 -->
                    <input type="hidden" name="hFILEPrefix" value="<%= vFILEPrefix %>">
                    <input type="hidden" name="hNEXTFILENo" value="<%= vNEXTFILENo %>">
                    <!--// -->
                    <table width="100%" border="0" cellpadding="2" cellspacing="1">
                        <tr bgcolor="edd3cf">
                            <td height="22" colspan="14" align="center" valign="middle" bgcolor="edd3cf" class="bodyheader">
                                <table width="98%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="26%">
                                            &nbsp;</td>
                                        <td width="48%" align="center" valign="middle">
                                            <span class="bodycopy">
                                                <img height="18" style="cursor: hand" onclick=" if(CheckIfMBExist()){SaveClick();}"
                                                    src="../images/button_save_medium.gif" width="46"></span></td>
                                        <td width="13%" align="right" valign="middle">
                                            <a href="/ASP/air_import/air_import2.asp" target="_self">
                                                <img src="/ASP/Images/button_new.gif" width="42" height="17" border="0"
                                                    style="cursor: hand" alt="" /></a></td>
                                        <td width="13%" align="right" valign="middle">
                                            <span class="bodycopy">
                                                <% if vLock_ap <> "Y" then %>
                                                <img src="../images/button_delete_medium.gif" width="51" height="17" onclick="DeleteMAWBClick()"
                                                    style="cursor: hand">
                                                <% end if%>
                                            </span>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr align="center" valign="middle" bgcolor="efe1df">
                            <td height="24" colspan="14" align="center" bgcolor="f3f3f3" class="bodyheader">
                                <br>
                                <br>
                                <table width="75%" height="28" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="43%" class="bodyheader style4">
                                            &nbsp;</td>
                                        <td width="57%" align="right" valign="middle" class="bodyheader">
                                            <img src="/ASP/Images/required.gif" align="absbottom">Required field</td>
                                    </tr>
                                </table>
                                <table width="75%" border="0" cellpadding="2" cellspacing="0" bordercolor="ba9590"
                                    bgcolor="edd3cf" class="border1px">
                                    <tr bgcolor="#efe1df">
                                        <td height="20" align="left" valign="middle">
                                            &nbsp;
                                        </td>
                                        <td height="20" align="left" valign="middle" class="bodyheader">
                                            <span class="bodyheader style3"><span class="bodycopy">
                                                <img src="/ASP/Images/required.gif" align="absbottom"></span>Master AWB
                                                No. </span>
                                        </td>
                                        <td align="left" valign="middle" class="bodyheader">
                                            File No.</td>
                                        <td align="left" valign="middle" class="bodyheader">
                                            &nbsp;
                                        </td>
                                        <td align="left" valign="middle">
                                        </td>
                                    </tr>
                                    <tr bgcolor="#Ffffff">
                                        <td height="20" align="left" valign="middle">
                                            &nbsp;
                                        </td>
                                        <td height="20" align="left" valign="middle" class="bodyheader">
                                            <table cellpadding="0" cellspacing="0" border="0" width="220">
                                                <tr>
                                                    <td width="165">
                                                        <input name="txtMAWB"  id="txtMAWB" type="text" value="<%= vMAWB %>" size="29" <% if vmawb <>"" then response.write("class='readonlybold' readonly") else response.write("class='bodyheader'") end if %> /></td>
                                                    <td class="bodyheader">
                                                        <% If vMAWB <> "" Then %>
                                                        <a href="javascript:ChangeMAWB();">Change</a><% End If %></td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td colspan="2" align="left" valign="middle">
                                            <input name="txtSubMAWB" type="hidden" class="shorttextfield" value="<%= vSubMAWB %>">
                                            <% if NOT aFILEPrefix(0) = "NONE" and NOT aFILEPrefix(0) = "EDIT" then%>
                                            <select name="lstFILEPrefix" size="1" class="bodyheader" style="width: 60px" onchange="PrefixChange()">
                                                <% For i=0 To fileIndex-1 %>
                                                <option value="<%= aNextFILE(i) %>" <% if vfileprefix=afileprefix(i) then response.write("selected") %>>
                                                    <%= aFILEPrefix(i) %>
                                                </option>
                                                <%  Next %>
                                            </select>
                                            <% end if %>
                                            <% if aFILEPrefix(0) = "NONE" then%>
                                            <input name='txtFileNo' class='bodyheader' value='<%= vFileNo %>' size='16'>
                                            <% else %>
                                            <input name='txtFileNo' class='readonlybold' value='<%= vFileNo %>' size='16' readonly='true'>
                                            <% end if%>
                                        </td>
                                        <td align="left" valign="middle">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="2" colspan="8" align="left" valign="middle" bgcolor="#ba9590">
                                        </td>
                                    </tr>
                                    <tr bgcolor="#F3f3f3">
                                        <td height="20" align="left" valign="middle">
                                            &nbsp;
                                        </td>
                                        <td height="20" align="left" valign="middle" bgcolor="#F3f3f3" class="bodyheader">
                                            Date</td>
                                        <td align="left" valign="middle">
                                        </td>
                                        <td align="left" valign="middle" class="bodyheader">
                                            &nbsp;
                                        </td>
                                        <td align="left" valign="middle">
                                        </td>
                                    </tr>
                                    <tr bgcolor="#Ffffff">
                                        <td height="20" align="left" valign="middle">
                                            &nbsp;
                                        </td>
                                        <td height="20" align="left" valign="middle" class="bodyheader">
                                            <input name="txtDate" type="text" class="m_shorttextfield date" preset="shortdate" value="<%= vPRDate %>"
                                                size="30"></td>
                                        <td align="left" valign="middle">
                                        </td>
                                        <td align="left" valign="middle" class="bodyheader">
                                            &nbsp;
                                        </td>
                                        <td align="left" valign="middle">
                                        </td>
                                    </tr>
                                    <tr bgcolor="#F3f3f3">
                                        <td width="1" height="20" align="left" valign="middle">
                                            &nbsp;
                                        </td>
                                        <td width="237" height="20" align="left" valign="middle" bgcolor="#F3f3f3" class="bodyheader">
                                            Carrier</td>
                                        <td align="left" valign="middle">
                                        </td>
                                        <td width="173" align="left" valign="middle" class="bodyheader">
                                            <span class="bodycopy">
                                                <img src="/ASP/Images/required.gif" align="absbottom"></span>Agent</td>
                                        <td align="left" valign="middle">
                                        </td>
                                    </tr>
                                    <tr bgcolor="#FFFFFF">
                                        <td width="1" align="left" valign="middle" bgcolor="#FFFFFF">
                                            &nbsp;
                                        </td>
                                        <td height="18" colspan="2" align="left" valign="middle">
                                            <!-- Start JPED -->
                                            <input type="hidden" id="hCarrierCode" name="hCarrierCode" value="<%=vCarrierCode %>" />
                                            <input type="hidden" id="hCarrierAcct" name="hCarrierAcct" value="<%=vCarrierAcct %>" />
                                            <div id="lstCarrierNameDiv">
                                            </div>
                                            <table cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td>
                                                        <input type="text" autocomplete="off" id="lstCarrierName" name="lstCarrierName" value="<%=vCarrier %>"
                                                            class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                            border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Carrier','lstCarrierNameChange',null,event)"
                                                            onfocus="initializeJPEDField(this,event);" /></td>
                                                    <td>
                                                        <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstCarrierName','Carrier','lstCarrierNameChange',null,event)"
                                                            style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                            border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                    <td>
                                                    </td>
                                                </tr>
                                            </table>
                                            <!-- End JPED -->
                                        </td>
                                        <td colspan="2" align="left" valign="middle">
                                            <table cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td style="width: 258px">
                                                        <!-- Start JPED -->
                                                        <input type="hidden" id="hFFAgentAcct" name="hFFAgentAcct" value="<%=vagentorgacct %>" />
                                                        <div id="lstFFAgentDiv">
                                                        </div>
                                                        <table cellpadding="0" cellspacing="0" border="0" id="tblAgent">
                                                            <tr>
                                                                <td>
                                                                    <input type="text" autocomplete="off" id="lstFFAgent" name="lstFFAgent" value="<%=vAgentName %>"
                                                                        class="shorttextfield" style="width: 237px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                        border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Agent','lstFFAgentChange',null,event)"
                                                                        onfocus="initializeJPEDField(this,event);" /></td>
                                                                <td>
                                                                    <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstFFAgent','Agent','lstFFAgentChange',null,event)"
                                                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                        border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                                <td>
                                                                    <input type='hidden' id='quickAdd_output'/>
                                                                    <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                        onclick="quickAddClient('hFFAgentAcct','lstFFAgent','hFFAgentInfo')" /></td>
                                                            </tr>
                                                        </table>
                                                        <% If NoItem = 0 And vLock_ap <> "Y" Then %>
                                                        <% Else %>

                                                        <script type="text/jscript">
                                                            makeAllReadOnly(document.getElementById("tblAgent"));
                                                            document.getElementById("lstFFAgent").style.backgroundColor = "#cdcdcd";
                                                        </script>

                                                        <% End If %>
                                                        <!-- End JPED -->
                                                    </td>
                                                    <td class="bodyheader" style="width: 40px; text-align: right">
                                                        <% If vMAWB <> "" AND Not(NoItem = 0 And vLock_ap <> "Y") Then %>
                                                        <a href="javascript:ChangeAgent();">Change</a><% End If %></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr bgcolor="#F3f3f3">
                                        <td width="1" align="left" valign="middle" bgcolor="f3f3f3">
                                            &nbsp;
                                        </td>
                                        <td height="19" align="left" valign="middle" class="bodyheader">
                                            <% response.write("Flight No.") %>
                                        </td>
                                        <td width="197" align="left" valign="middle">
                                            &nbsp;
                                        </td>
                                        <td align="left" valign="middle" class="bodyheader">
                                            &nbsp;</td>
                                        <td width="249" align="left" valign="middle">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr bgcolor="#FFFFFF">
                                        <td align="left" valign="middle" bgcolor="#FFFFFF">
                                            &nbsp;
                                        </td>
                                        <td align="left" valign="middle">
                                            <input name="txtFLTNo" type="text" class="shorttextfield" maxlength="32" value="<%= vFLTNo %>"
                                                size="30"></td>
                                        <td align="left" valign="middle">
                                            &nbsp;
                                        </td>
                                        <td colspan="2" align="left" valign="middle">
                                            &nbsp;</td>
                                    </tr>
                                    <tr bgcolor="#F3f3f3">
                                        <td width="1" height="19" align="left" valign="middle">
                                            &nbsp;
                                        </td>
                                        <td align="left" valign="middle" class="bodyheader">
                                            Departure Port</td>
                                        <td align="left" valign="middle" class="bodyheader">
                                            ETD</td>
                                        <td align="left" valign="middle" class="bodyheader">
                                            Freight Location
                                        </td>
                                        <td align="left" valign="middle">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr bgcolor="#Ffffff">
                                        <td align="left" valign="middle">
                                            &nbsp;</td>
                                        <td align="left" valign="middle">
                                            <span class="smallselect">
                                                <select name="lstDepPort" onchange="doDepPortChange(this)" class="smallselect" style="width: 160px">
                                                    <% for i=0 to port_list.count-1 %>
                                                    <option value='<%=port_list(i)("port_code")%>' <% If vDepCode=port_list(i)("port_code") then 
                                                            response.write("selected=selected") 
					                            		End If%>>
                                                        <%= port_list(i)("port_desc") %>
                                                    </option>
                                                    <% next %>
                                                </select>
                                            </span>
                                        </td>
                                        <td align="left" valign="middle">
                                            <input name="txtETD" type="text" class="m_shorttextfield date" preset="shortdate" value="<%= vETD %>"
                                                size="19"></td>
                                        <td colspan="2" align="left" valign="middle">
                                            <select name="lstCargoLocation" class="smallselect" style="width: 250px">
                                                <option value=""></option>
                                                <% for i=0 to fIndex-1 %>
                                                <option value="<%= fCode(i)&"-"&fLocation(i)&" Phone: "& fPhone(i)&" Fax: "& fFax(i)%>"
                                                    <% if vcargocode=fcode(i) then response.write("selected") %>>
                                                    <%= fCode(i) & "-" & fLocation(i) %>
                                                </option>
                                                <% next %>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr bgcolor="#F3f3f3">
                                        <td width="1" height="19" align="left" valign="middle" bgcolor="f3f3f3">
                                            &nbsp;
                                        </td>
                                        <td align="left" valign="middle" class="bodyheader">
                                            Destination Port</td>
                                        <td align="left" valign="middle" class="bodyheader">
                                            ETA</td>
                                        <td align="left" valign="middle" class="bodyheader">
                                            Last Free Date</td>
                                        <td align="left" valign="middle" class="bodyheader">
                                            Place of Delivery</td>
                                    </tr>
                                    <tr bgcolor="#FFFFFF">
                                        <td width="1" align="left" valign="middle" bgcolor="#FFFFFF">
                                            &nbsp;
                                        </td>
                                        <td align="left" valign="middle">
                                            <select name="lstArrPort" onchange="doArrPortChange(this)" class="smallselect" style="width: 160px">
                                                <% for i=0 to port_list.count-1 %>
                                                <option value='<%=port_list(i)("port_code")%>' <% 
														  if vArrCode=port_list(i)("port_code") then 
															  response.write("selected=selected") 
														  end if
                                  						%>>
                                                    <%= port_list(i)("port_desc") %>
                                                </option>
                                                <% next %>
                                            </select>
                                        </td>
                                        <td align="left" valign="middle">
                                            <input name="txtETA" type="text" class="m_shorttextfield date" preset="shortdate" value="<%= vETA %>"
                                                size="19"></td>
                                        <td align="left" valign="middle">
                                            <input name="txtLastFreeDate" type="text" class="m_shorttextfield date" preset="shortdate"
                                                value="<%= vLastFreeDate %>" size="19"></td>
                                        <td align="left" valign="middle">
                                            <input name="txtPlaceOfDelivery" type="text" class="shorttextfield date" maxlength="64"
                                                value="<%= vPlaceOfDelivery %>" size="29"></td>
                                    </tr>
                                    <tr bgcolor="#F3f3f3">
                                        <td width="1" height="19" align="left" valign="middle" bgcolor="f3f3f3">
                                            &nbsp;
                                        </td>
                                        <td align="left" valign="middle" class="bodyheader">
                                            Pieces</td>
                                        <td align="left" valign="middle" class="bodyheader">
                                            Gross Weight</td>
                                        <td align="left" valign="middle" class="bodyheader">
                                            <% response.write("Charge Weight") %>
                                        </td>
                                        <td align="left" valign="middle">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr bgcolor="#FFFFFF">
                                        <td width="1" align="left" valign="middle" bgcolor="#FFFFFF">
                                            &nbsp;
                                        </td>
                                        <td align="left" valign="middle">
                                            <input name="txtPieces" style="behavior: url(../include/igNumDotChkLeft.htc)" type="text"
                                                class="shorttextfield" value="<%= vPieces %>" size="9" />
                                            <select name="lstScale1" class="smallselect" style="width: 50px">
                                                <option <%if vScale1="PCS" then response.write("selected")%>>PCS</option>
                                                <option <%if vScale1="BOX" then response.write("selected")%>>BOX</option>
                                                <option <%if vScale1="PLT" then response.write("selected")%>>PLT</option>
                                                <option <%if vScale1="CTN" then response.write("selected")%>>CTN</option>
                                                <option <%if vScale1="SET" then response.write("selected")%>>SET</option>
                                                <option <%if vScale1="CRT" then response.write("selected")%>>CRT</option>
                                                <option <%if vScale1="SKD" then response.write("selected")%>>SKD</option>
                                                <option <%if vScale1="UNIT" then response.write("selected")%>>UNIT</option>
                                                <option <%if vScale1="PKGS" then response.write("selected") %>>PKGS</option>
                                                <option <%if vScale1="CNTR" then response.write("selected") %>>CNTR</option>
                                            </select>
                                        </td>
                                        <td align="left" valign="middle">
                                            <input name="txtGrossWT" style="behavior: url(../include/igNumDotChkLeft.htc)" type="text"
                                                class="shorttextfield" value="<%= vGrossWT %>" size="9" />
                                            <select name="lstScale2" class="smallselect" style="width: 50px">
                                                <option <% if vscale2="LB" Or vscale2="L" then response.write("selected") %>>LB</option>
                                                <option <% if vscale2="KG" Or vscale2="K" then response.write("selected") %>>KG</option>
                                            </select>
                                        </td>
                                        <td colspan="2" align="left" valign="middle">
                                            <input name="txtChgWT" type="text" style="behavior: url(../include/igNumDotChkLeft.htc)"
                                                class="shorttextfield" value="<%= vChgWT %>" size="9" <% response.write("13") %> />
                                            <select name="lstScale3" class="smallselect" style="width: 50px">
                                                <option <% if vscale3="LB" Or vscale3="L" Or vscale3="CFT" then response.write("selected") %>>
                                                    LB</option>
                                                <option <% if vscale3="KG" Or vscale3="K" Or vscale3="CBM" then response.write("selected") %>>
                                                    KG</option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr bgcolor="#F3f3f3">
                                        <td height="19" align="left" valign="middle" bgcolor="f3f3f3">
                                            &nbsp;
                                        </td>
                                        <td align="left" valign="middle" class="bodyheader">
                                            I.T. No.</td>
                                        <td align="left" valign="middle" class="bodyheader">
                                            I.T.Date</td>
                                        <td align="left" valign="middle" class="bodyheader">
                                            I.T. Entry Port</td>
                                        <td align="left" valign="middle">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr bgcolor="#Ffffff">
                                        <td width="1" align="left" valign="middle">
                                            &nbsp;
                                        </td>
                                        <td align="left" valign="middle">
                                            <span class="smallselect">
                                                <input name="txtITNumber" type="text" maxlength="64" class="shorttextfield" value="<%= vITNumber %>"
                                                    size="30">
                                            </span>
                                        </td>
                                        <td align="left" valign="middle">
                                            <input name="txtITDate" type="text" class="m_shorttextfield date" preset="shortdate" value="<%= vITDate %>"
                                                size="19"></td>
                                        <td colspan="2" align="left" valign="middle">
                                            <select name="lstITEntryPort" class="smallselect" style="width: 160px">
                                                <% for i=0 to port_list.count-1 %>
                                                <option <% if vitentryport=port_list(i)("port_desc") then response.write(" selected") %>>
                                                    <%= port_list(i)("port_desc") %>
                                                </option>
                                                <% next %>
                                            </select>
                                        </td>
                                    </tr>
                                </table>
                                <br>
                            </td>
                            <tr bgcolor="edd3cf">
                                <td height="22" colspan="14" align="center" valign="middle" class="bodyheader">
                                    <table width="100%" border="0" cellpadding="0" cellspacing="0" id="tblChargeCost">
                                        <input name="hNoCostItem" type="hidden" value="<%= NoCostItem %>">
                                        <input id="InvoiceCostItem" type="hidden">
                                        <input id="ItemCost" type="hidden">
                                        <input id="ItemCostDesc" type="hidden">
                                        <input id="ItemVendor" type="hidden">
                                        <input id="txtLock_ap" type="hidden">
                                        <input type="hidden" name="hDepText" id="hDepText" value="<%=vDepPort%>" />
                                        <input type="hidden" name="hArrText" id="hArrText" value="<%=vArrPort%>" />
                                        <tr>
                                            <td align="left" bgcolor="ba9590" colspan="8" height="1" valign="middle">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="left" bgcolor="#FFFFFF" colspan="8" height="1" valign="middle">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="20" bgcolor="efe1df" class="bodycopy">
                                                &nbsp;
                                            </td>
                                            <td valign="middle" bgcolor="efe1df" class="bodyheader style3">
                                                Agent Debit No.
                                                <% if mode_begin then %>
                                                <div style="width: 21px; display: inline; vertical-align: middle" onmouseover="showtip(' This is where you enter the overall reference number for the Agent Debit items that will be related to this deconsolidation.');"
                                                    onmouseout="hidetip()">
                                                    <img src="../Images/button_info.gif" align="middle" class="bodylistheader"></div>
                                                <% end if %>
                                            </td>
                                            <td bgcolor="efe1df" class="bodycopy">
                                                &nbsp;
                                            </td>
                                            <td bgcolor="efe1df" class="bodyheader">
                                                &nbsp;
                                            </td>
                                            <td bgcolor="efe1df" class="bodycopy">
                                                &nbsp;
                                            </td>
                                            <td bgcolor="efe1df" class="bodycopy">
                                                &nbsp;
                                            </td>
                                            <td bgcolor="efe1df" class="bodycopy">
                                                &nbsp;
                                            </td>
                                            <td bgcolor="efe1df">
                                                &nbsp;
                                            </td>
                                        </tr>
                                        <tr bgcolor="#FFFFFF">
                                            <td height="20" class="bodycopy">
                                                &nbsp;
                                            </td>
                                            <td class="bodycopy">
                                                <input name="txtAgentDebitNo" type="text" class='shorttextfield txtAgentDebitNo' value="<%= vAgentDebitNo %>"
                                                    size="16"></td>
                                            <td class="bodycopy">
                                                &nbsp;
                                            </td>
                                            <td class="bodyheader">
                                                &nbsp;
                                            </td>
                                            <td class="bodycopy">
                                                &nbsp;
                                            </td>
                                            <td class="bodycopy">
                                                &nbsp;
                                            </td>
                                            <td class="bodycopy">
                                                &nbsp;
                                            </td>
                                            <td>
                                                &nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="1%" height="20" bgcolor="efe1df" class="bodycopy">
                                                &nbsp;
                                            </td>
                                            <td width="24%" bgcolor="efe1df" class="bodycopy">
                                                <strong>Agent Debit Item</strong></td>
                                            <td width="25%" bgcolor="efe1df" class="bodycopy">
                                                <strong>Description</strong></td>
                                            <td width="8%" bgcolor="efe1df" class="bodyheader">
                                                Amount</td>
                                            <td width="3%" bgcolor="efe1df" class="bodycopy">
                                                &nbsp;
                                            </td>
                                            <td width="12%" bgcolor="efe1df" class="bodycopy">
                                                <strong>Ref No.</strong></td>
                                            <td width="16%" bgcolor="efe1df" class="bodycopy">
                                                &nbsp;
                                            </td>
                                            <td width="11%" bgcolor="efe1df">
                                                &nbsp;
                                            </td>
                                        </tr>
                                        <% for i=0 to NoCostItem-1 %>
                                        <tr>
                                            <td bgcolor="#FFFFFF">
                                            </td>
                                            <td bgcolor="#FFFFFF">
                                                <% DIM tmpigDefaultCostItem%>
                                                <% if aLock_ap(i) ="Y" then %>
                                                <select id="InvoiceCostItem" name="lstCostItem<%= i %>" style="visibility: hidden; width: 1px" class="InvoiceCostItem">
                                                    <option></option>
                                                    <option>Add New Item</option>
                                                    <% for j=0 to CostItemIndex-1 %>
                                                    <option <% if cint(acostitemno(i))=defaultcostitemno(j) then 
													response.write("selected") 
													tmpigdefaultcostitem = igdefaultcostitem(j)
												end if%>="" value="<%= DefaultCostItemNo(j) & "-" & DefaultExpense(j) & "-" & DefaultCostItem(j) & chr(10) & DefaultCostItemDesc(j) & chr(10) & aCostItemUnitPrice(j) %>">
                                                        <%= igDefaultCostItem(j) %>
                                                    </option>
                                                    <% next %>
                                                </select>
                                                <input id="txtItemCostDesc" class="d_shorttextfield" size="30" type="text" value="<%= tmpigDefaultCostItem %>"
                                                    readonly="true">
                                                <% else %>
                                                <select id="InvoiceCostItem" class="smallselect InvoiceCostItem" name="lstCostItem<%= i %>" onchange="ItemCostChange(<%= i %>);CostChange(<%= i %>)"
                                                    size="1" style="width: 180">
                                                    <option>Select One</option>
                                                    <option>Add New Item</option>
                                                    <% for j=0 to CostItemIndex-1 %>
                                                    <option <% if cint(acostitemno(i))=defaultcostitemno(j) then response.write("selected") %>=""
                                                        value="<%= DefaultCostItemNo(j) & "-" & DefaultExpense(j) & "-" & DefaultCostItem(j) & chr(10) & DefaultCostItemDesc(j) & chr(10) & aCostItemUnitPrice(j) %>">
                                                        <%= igDefaultCostItem(j) %>
                                                    </option>
                                                    <% next %>
                                                </select>
                                                <% end if %>
                                            </td>
                                            <td bgcolor="#FFFFFF">
                                                <input id="ItemCostDesc" class="shorttextfield ItemCostDesc" name="txtCostDesc<%= i %>" size="39"
                                                    type="text" value="<%= aCostDesc(i) %>" <%if aLock_ap(i) ="Y" then response.write "readonly='true'"%>></td>
                                            <td bgcolor="#FFFFFF">
                                                <input id="ItemCost" class="numberalign ItemCost" name="txtCost<%= i %>" onchange="CostChange(<%= i %>)"
                                                    style="behavior: url(../include/igNumDotChkLeft.htc)" size="12" type="text" value="<%= formatNumberPlus(checkBlank(aRealCost(i),0),2) %>"
                                                    <% if aLock_ap(i) ="Y" then response.write " readonly='true'" %> /></td>
                                            <td bgcolor="#FFFFFF">
                                                <select id="ItemVendor" class="smallselect" name="lstVendor<%= i %>" size="1" style="visibility: hidden">
                                                    <option></option>
                                                </select>
                                            </td>
                                            <td bgcolor="#FFFFFF">
                                                <input class="shorttextfield" name="txtRefNo<%= i %>" size="14" maxlength="64" type="text"
                                                    value="<%= aRefNo(i) %>" <%if aLock_ap(i) ="Y" then response.write "readonly='true'"%>></td>
                                            <td bgcolor="#FFFFFF">
                                                <input id="txtLock_ap" class="shorttextfield" name="txtLock_ap<%= i %>" type="hidden"
                                                    value="<%= aLock_ap(i) %>">
                                                <%if aLock_ap(i) = "Y" then %>
                                                <span style='color: #CC3333' class='bodyheader'><a href="javascript:goLink('<%=aLock_bill(i)%>');">
                                                    Billed</a></span>
                                                <% else%>
                                                <img height='17' onclick="DeleteCostItem(<%= i %>)" src='../images/button_delete.gif'
                                                    style="cursor: hand" width='50'>
                                                <% end if%>
                                            </td>
                                            <td bgcolor="#FFFFFF">
                                                <input name="txtAPLOCK<%= i %>" type="hidden" value="<%= aLock_bill(i) %>"></td>
                                        </tr>
                                        <% next %>
                                        <tr>
                                            <td bgcolor="#FFFFFF">
                                                &nbsp;
                                            </td>
                                            <td bgcolor="#FFFFFF">
                                                <img height='18' name='bAddItem2' onclick='AddCostItem()' src='../images/button_addcost_item.gif'
                                                    style="cursor: hand" width='94'></td>
                                            <td bgcolor="#FFFFFF">
                                                &nbsp;
                                            </td>
                                            <td bgcolor="#FFFFFF">
                                                &nbsp;
                                            </td>
                                            <td bgcolor="#FFFFFF">
                                                &nbsp;
                                            </td>
                                            <td bgcolor="#FFFFFF">
                                                &nbsp;
                                            </td>
                                            <td bgcolor="#FFFFFF">
                                                &nbsp;
                                            </td>
                                            <td bgcolor="#FFFFFF">
                                                &nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="1" colspan="8" bgcolor="#ba9590">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="1" colspan="8" bgcolor="#ffffff">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="1" colspan="8" bgcolor="#ba9590">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="#FFFFFF">
                                                &nbsp;
                                            </td>
                                            <td bgcolor="#FFFFFF">
                                                &nbsp;
                                            </td>
                                            <td align="right" bgcolor="#FFFFFF">
                                                <span class="bodylistheader style1">AGENT DEBIT TOTAL&nbsp;&nbsp;</span>
                                            </td>
                                            <td bgcolor="#FFFFFF">
                                                <strong>
                                                    <input class="numberalign" name="txtTotalCost" size="12" type="text" value="<%= formatNumberPlus(CheckBlank(vTotalCost,0),2) %>"
                                                        readonly="true">
                                                </strong>
                                            </td>
                                            <td bgcolor="#FFFFFF">
                                                &nbsp;
                                            </td>
                                            <td bgcolor="#FFFFFF">
                                                &nbsp;
                                            </td>
                                            <td colspan="2" bgcolor="#FFFFFF">
                                                <div align="right">
                                                </div>
                                            </td>
                                        </tr>
                                        <tr bgcolor="#FFFFFF">
                                            <td height="8" colspan="8">
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr bgcolor="edd3cf">
                                <td width="11%" height="22" align="left" valign="middle" bgcolor="edd3cf" class="bodyheader">
                                    <%response.write("House AWB No.") %>
                                </td>
                                <td width="13%" align="left" valign="middle" bgcolor="edd3cf" class="bodyheader">
                                    Shipper
                                </td>
                                <td width="13%" align="left" valign="middle" bgcolor="edd3cf" class="bodyheader">
                                    Consignee</td>
                                <td width="13%" align="left" valign="middle" bgcolor="edd3cf" class="bodyheader">
                                    Notify</td>
                                <td width="5%" align="left" valign="middle" class="bodyheader">
                                    PC/UOM</td>
                                <td width="5%" align="left" valign="middle" class="bodyheader">
                                    Gross
                                    <br>
                                    WT</td>
                                <td width="6%" align="left" valign="middle" class="bodyheader">
                                    Charge Weight</td>
                                <td width="5%" align="left" valign="middle" class="bodyheader">
                                    Air
                                    <br>
                                    Freight
                                </td>
                                <td width="6%" align="left" valign="middle" class="bodyheader">
                                    Other Charge
                                </td>
                                <td width="5%" align="left" valign="middle" class="bodyheader">
                                    AN No.
                                </td>
                                <td colspan="4" align="left" valign="middle" class="bodycopy">
                                    &nbsp;
                                </td>
                            </tr>
                            <input type="hidden" id="HAWB">
                            <input type="hidden" id="HAWBShipper">
                            <input type="hidden" id="HAWBConsignee">
                            <input type="hidden" id="HAWBNotify">
                            <input type="hidden" id="HAWBDesc">
                            <input type="hidden" id="HAWBPieces">
                            <input type="hidden" id="HAWBGrossWT">
                            <input type="hidden" id="HAWBChgWT">
                            <input id="HAWBFreightCollect" type="hidden" />
                            <% for i=0 to NoItem-1 %>
                            <tr bgcolor="#FFFFFF">
                                <td height="22" align="left" valign="middle" class="bodycopy">
                                    <input readonly="readonly" name="txtHAWB<%= i %>" type="text" class="d_shorttextfield HAWB"
                                        id="HAWB" value="<%= aHAWB(i) %>" /></td>
                                <td align="left" valign="middle" class="bodycopy ">
                                    <input readonly="readonly" name="txtShipper<%= i %>" type="text" class="d_shorttextfield HAWBShipper"
                                        id="HAWBShipper" value="<%= aShipper(i) %>"></td>
                                <td align="left" valign="middle" class="bodycopy ">
                                    <input readonly="readonly" name="txtConsignee<%= i %>" type="text" class="d_shorttextfield HAWBConsignee"
                                        id="HAWBConsignee" value="<%= aConsignee(i) %>"></td>
                                <td align="left" valign="middle" class="bodycopy ">
                                    <input readonly="readonly" name="txtNotify<%= i %>" type="text" class="d_shorttextfield HAWBNotify"
                                        id="HAWBNotify" value="<%= aNotify(i) %>"></td>
                                <td align="left" valign="middle" class="bodycopy ">
                                    <input readonly="readonly" style="behavior: url(../include/igNumChkRight.htc)" name="txtPieces<%= i %>"
                                        type="text" class="d_shorttextfield HAWBPieces" id="HAWBPieces" value="<%= aPieces(i) %>"
                                        size="6"></td>
                                <td align="left" valign="middle" class="bodycopy">
                                    <input readonly="readonly" style="behavior: url(../include/igNumChkRight.htc)" name="txtGrossWT<%= i %>"
                                        type="text" class="d_shorttextfield HAWBGrossWT" id="HAWBGrossWT" value="<%= aGrossWT(i) %>"
                                        size="6"></td>
                                <td align="left" valign="middle" class="bodycopy">
                                    <input readonly="readonly" style="behavior: url(../include/igNumChkRight.htc)" name="txtChgWT<%= i %>"
                                        type="text" class="d_shorttextfield HAWBChgWT" id="HAWBChgWT" value="<%= aChgWT(i) %>"
                                        size="6"></td>
                                <td align="left" valign="middle" class="bodycopy">
                                    <input id="HAWBFreightCollect" class="d_shorttextfield HAWBFreightCollect" name="txtFreightCollect<%= i %>"
                                        readonly="readonly" style="behavior: url(../include/igNumChkRight.htc)" size="6"
                                        type="text" value="<%= formatNumberPlus(aFreightCollect(i),2) %>"></td>
                                <td align="left" valign="middle" class="bodycopy">
                                    <input readonly="readonly" name="txtOCCollect<%= i %>" type="text" class="d_shorttextfield"
                                        value="<%=formatNumberPlus( aOCCollect(i),2) %>" style="behavior: url(../include/igNumChkRight.htc)"
                                        size="6"></td>
                                <td>
                                    <span class="bodycopy">
                                        <input readonly="readonly" name="txtAN<%= i %>" type="text" class="d_shorttextfield"
                                            value="<%= aAN(i) %>" size="6">
                                    </span>
                                </td>
                                <td width="4%" align="left" valign="middle" class="bodycopy">
                                    <img src="../images/button_view.gif" width="42" height="18" name="B1" onclick="ViewClick('<%= aHAWB(i) %>')"
                                        style="cursor: hand"></td>
                                <td width="5%" align="left" valign="middle" class="bodycopy">
                                    <img src="../images/button_edit_an.gif" width="55" height="18" name="B1" onclick="EditANClick(<%= vSec %>,<%= i+1 %>,<%= aAN(i) %>)"
                                        style="cursor: hand"></td>
                                <td width="9%" align="left" valign="middle" class="bodycopy">
                                    <img src="../images/button_delete.gif" width="50" height="17" onclick="DeleteHAWB('<%=aAN(i)%>',<%= i %>)"
                                        style="cursor: hand; visibility: <%=aHAWBLock(i) %>"></td>
                            </tr>
                            <% next %>
                            <tr bgcolor="edd3cf">
                                <td height="22" align="left" valign="middle" bgcolor="f3f3f3" class="bodycopy">
                                    &nbsp;
                                </td>
                                <td align="left" valign="middle" bgcolor="f3f3f3" class="bodyheader">
                                </td>
                                <td align="left" valign="middle" bgcolor="f3f3f3" class="bodyheader">
                                </td>
                                <td align="left" valign="middle" bgcolor="f3f3f3" class="bodyheader">
                                </td>
                                <td align="left" valign="middle" bgcolor="f3f3f3" class="bodyheader">
                                </td>
                                <td align="left" valign="middle" bgcolor="f3f3f3" class="bodyheader">
                                </td>
                                <td align="left" valign="middle" bgcolor="f3f3f3" class="bodyheader">
                                </td>
                                <td align="left" valign="middle" bgcolor="f3f3f3" class="bodyheader">
                                </td>
                                <td align="left" valign="middle" bgcolor="f3f3f3" class="bodyheader">
                                </td>
                                <td align="left" valign="middle" bgcolor="f3f3f3" class="bodyheader">
                                </td>
                                <td colspan="4" align="left" valign="middle" bgcolor="f3f3f3" class="bodyheader">
                                    <img src="../images/button_addan.gif" name="B1" width="110" height="18" align="middle"
                                        style="cursor: hand" onclick="AddHAWB()">
                                    <% if mode_begin then %>
                                    <div style="width: 21px; display: inline; vertical-align: middle" onmouseover="showtip('This Button will take you to the Arrival Notice screen for the entry of House information.  The Master bill and flight information from the Deconsolidation will automatically be pushed to the relevant fields.');"
                                        onmouseout="hidetip()">
                                        <img src="../Images/button_info.gif" align="middle" class="bodylistheader"></div>
                                    <% end if %>
                                </td>
                            </tr>
                            <tr align="center" bgcolor="edd3cf">
                                <td height="34" colspan="14" align="right" valign="middle" bgcolor="#FFFFFF" class="bodyheader">
                                    Sales Person
                                    <select name="lstSalesRP" size="1" class="smallselect" style="width: 200px">
                                        <option value="none"></option>
                                        <% For i=0 To SRIndex-1 %>
                                        <option value="<%= aSRName(i)%>" <%
  	                        if vsalesperson = asrname(i) then response.write("selected") %>>
                                            <%= aSRName(i) %>
                                        </option>
                                        <%  Next  %>
                                    </select>
                                </td>
                            </tr>
                            <tr align="center" bgcolor="edd3cf">
                                <td height="22" colspan="14" valign="middle" bgcolor="edd3cf" class="bodycopy">
                                    <table width="98%" border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td width="26%">
                                                &nbsp;</td>
                                            <td width="48%" align="center" valign="middle">
                                                <span class="bodycopy">
                                                    <img height="18" style="cursor: hand" onclick=" if(CheckIfMBExist()){SaveClick();}"
                                                        src="../images/button_save_medium.gif" width="46"></span></td>
                                            <td width="13%" align="right" valign="middle">
                                                <a href="/ASP/air_import/air_import2.asp" target="_self">
                                                <img src="/ASP/Images/button_new.gif" width="42" height="17" border="0"
                                                    style="cursor: hand" alt="" /></a></td>
                                            <td width="13%" align="right" valign="middle">
                                                <span class="bodycopy">
                                                    <% if vLock_ap <> "Y" then %>
                                                    <img src="../images/button_delete_medium.gif" width="51" height="17" onclick="DeleteMAWBClick()"
                                                        style="cursor: hand">
                                                    <% end if%>
                                                </span>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                    </table>
                </td>
            </tr>
        </table>
        <br>
    </form>
</body>
<script type="text/javascript">
var dPortCode ="";
var aPortCode ="";
var PortCode="";

function doDepPortChange(obj) {
    dPortCode = obj.children[obj.options.selectedIndex].text;
    document.form1.hDepText.value = dPortCode;
}
function doArrPortChange(obj){
    aPortCode = obj.children[obj.options.selectedIndex].text;
    document.form1.hArrText.value = aPortCode;
}

</script>
<script type="text/vbscript">

Sub lstMAWBChange_air(name)   'never used
    dim aVal
	aVal=split(document.getElementById(name).Value,"^")

    document.getElementById("txtRefNo").Value=aVal(0)
	document.getElementById("txtVessel").Value=aVal(1)
	
	document.getElementById("txtCargoLocation").Value=aVal(2)
	document.getElementById("txtETD").Value=aVal(3)
	document.getElementById("txtETA").Value=aVal(4)	

	document.getElementById("hDepText").Value=aVal(5)	
	document.getElementById("hArrText").Value=aVal(6)		

	document.getElementById("hAgentOrgAcct").Value=aVal(9)
	document.getElementById("hSec").Value=aVal(10)		
	aVal(11) = replace(aVal(11),"Select One","")	
	document.getElementById("txtITEntryPort").Value=aVal(11)
	document.getElementById("txtITNumber").Value=aVal(12)
	document.getElementById("txtITDate").Value=aVal(13)
	document.getElementById("txtFreeDate").Value=aVal(14)
	document.getElementById("hAirline").Value=aVal(15)

	call setSelect("lstDepPort", aVal(7) )
	call setSelect("lstArrPort", aVal(8) )

End Sub 





</script>
<script type="text/javascript">

function LookUp2(){
    document.form1.isDocBeingModified.value = "false";
    var MAWB=document.form1.txtMAWB.value;
    if (MAWB != "" && MAWB != "Master No. Here") {
        document.form1.txtMAWB.value = "";
        document.form1.action = encodeURI("air_import2.asp?iType=A&Edit=yes&MAWB=" + MAWB + "&Search=yes&WindowName=" + window.name);
        document.form1.method = "POST";
        document.form1.target = "_self";
        form1.submit();
    }
    else
        alert("Please enter a Master No!");
}


// by igMoon 07/10/2006 for File No.
/////////////////////////////
function LookUp() {
    document.form1.isDocBeingModified.value = "false";
    var MAWB=document.form1.txtSMAWB.value;
    if (MAWB != "" && MAWB != "Master No. Here") {
        document.form1.txtSMAWB.value = "";
        document.form1.action = encodeURI("air_import2.asp?iType=A&Edit=yes&MAWB=" + MAWB
            + "&Search=yes&WindowName=" + window.name);
        document.form1.method = "POST";
        document.form1.target = "_self";
        form1.submit();
    }
    else
        alert("Please enter a Master No!");
}

function LookupFile(){
    document.form1.isDocBeingModified.value = "false";
    var JobNum=document.form1.txtJobNum.value;
    if (JobNum != "" && JobNum != "File No. Here" ){
        document.form1.txtJobNum.value = "";
        document.form1.txtMAWB.value= "";
        document.form1.action=encodeURI("air_import2.asp?iType=A&Edit=yes&JOB="+ JobNum +"&Search=yes&WindowName=" + window.name);
        document.form1.method="POST";
        document.form1.target="_self";
        form1.submit();
    }
    else
        alert( "Please enter a File No!");
}

function SaveClick(){
    if (document.form1.txtFileNo.value == "" ){
		alert( "Please, preset file numbers and prefixes in prefix manager. You can also manual enter it in this page.");
	    return false;
	}
  // --------------------------for cost item 11/29/06
    var NoCostItem=document.form1.hNoCostItem.value;
	for (var j=0; j< NoCostItem; j++){
		var oCost=$("input.ItemCost").get(j).value;
		if (oCost=="" ) 
            oCost=0;
		var oItem=$("select.InvoiceCostItem").get(j).value;
		if (! IsNumeric(oCost) ){
			alert( "Please enter a Numeric Value for COST!");
			return false;
		}
		if (oCost!=0 && oItem=="" ){
			alert( "Please select a Cost Item!");
			return false;
		}

		if ( oCost!=0 && document.all.txtAgentDebitNo.value.trim() == "" ){
			alert( "Please enter the Agent Debit No.");
			$("input.txtAgentDebitNo").focus();
			return false;
		}
	}
	
// ----------------------------------------------------
    
    var MAWB=document.form1.txtMAWB.value;
    var ETD=document.form1.txtETD.value;
    var ETA=document.form1.txtETA.value;
    var fDate=document.form1.txtLastFreeDate.value;
    var ITDate=document.form1.txtITDate.value;
    var AgentDebit=document.form1.txtTotalCost.value;
    
	if (MAWB==""){
		alert( "Please enter a MAWB Number!");
		return false;
    }		
    else if( document.form1.hFFAgentAcct.value == "" || document.form1.hFFAgentAcct.value == "0" ){
	    alert("Please select an Export Agent!");
	    return false;
    }

	if (ETD!="" && !IsDate(ETD) ){  
		alert("Please enter correct Date for ETD (MM/DD/YY)");
		return false;
	}
    if (ETA!="" && !IsDate(ETA) ){
		alert("Please enter correct Date for ETA (MM/DD/YY)");
		return false;
	}
    if (fDate != "" && !IsDate(fDate)) {
		alert("Please enter correct Date for Last Free Date (MM/DD/YY)");
		return false;
	}
	if (ITDate!="" && !IsDate(ITDate) ){
		alert("Please enter correct Date for IT Date (MM/DD/YY)");
		return false;
	}

    document.form1.isDocBeingSubmitted.value = "true";
	document.form1.action=encodeURI("air_import2.asp?iType=A&Save=yes" 
    + "&WindowName=" + window.name
    + "&AgentOrgAcct=<%=AgentOrgAcct %>&tNo=<%=TranNo%>");
	document.form1.target="_self";
	document.form1.method="POST";
	form1.submit();
}

function AddHAWB()
{
    var isConfirmYes = true;
    var isDocBeingSubmitted = document.form1.isDocBeingSubmitted.value;
    var isDocBeingModified = document.form1.isDocBeingModified.value;
    
    if (isDocBeingSubmitted == "false" && isDocBeingModified == "true" )
        isConfirmYes = confirmGoAway();

    if (isConfirmYes) {
        var MAWB = document.form1.txtMAWB.value;
        var Sec = document.form1.hSec.value;
        var NoItem = parseInt(document.form1.hNoItem.value);
        var AgentOrgAcct = document.form1.hAgentOrgAcct.value;
        document.form1.hNoItem.value = NoItem + 1;
        document.form1.action = encodeURI("arrival_notice.asp?NoItem=4&NoCostItem=4&iType=A&NewHAWB=yes&forwarded=Y&MAWB=" + MAWB + "&Sec=" + Sec + "&WindowName=" + window.name + "&AgentOrgAcct=" + AgentOrgAcct);
        document.form1.target = "_self";
        document.form1.method = "POST";
        form1.submit();
    }
}


function ViewClick(HAWB){

    var isConfirmYes = true;
    var isDocBeingSubmitted = document.form1.isDocBeingSubmitted.value;
    var isDocBeingModified = document.form1.isDocBeingModified.value;
    
    if( isDocBeingSubmitted == "false" && isDocBeingModified == "true" )
        isConfirmYes = confirmGoAway();
    
    if (isConfirmYes) {
    
	    var ExportAgentELTAcct=parseFloat(document.form1.hExportAgentELTAcct.value);
	    var AgentOrgAcct=document.form1.hAgentOrgAcct.value;
        var MAWB=document.form1.txtMAWB.value;
        
        if  (ExportAgentELTAcct > 0) 
            document.form1.action = encodeURI("../air_export/hawb_pdf.asp?HAWB=" + HAWB + "&AgentELTAcct=" + ExportAgentELTAcct + "&WindowName=popUpWindow");
        else
            document.form1.action = encodeURI("arrival_notice_pdf.asp?iType=A&HAWB=" + HAWB + "&Sec=<%=Sec %>&AgentOrgAcct=" + AgentOrgAcct + "&WindowName=popUpWindow&MAWB=" + MAWB);

        document.form1.target="_self";
        document.form1.method="POST";
        form1.submit();
	 }
	
}

function DeleteHAWB(Invoice_no,ItemNo){
    document.form1.isDocBeingModified.value = "false"
    if (confirm("Are you sure you want to delete this HAWB? \r\nContinue?")) {
	    var NoItem=document.form1.hNoItem.value;	
	    if (NoItem > 0 ){
		    document.form1.action=encodeURI("air_import2.asp?iType=A&DeleteHAWB=yes&dItemNo=" + ItemNo + "&WindowName="+ window.name)
		    document.form1.target="_self";
		    document.form1.method="POST";
		    form1.submit();
	    }
    }
}

function EditANClick(Sec,ItemNo,InvoiceNo){
    var isConfirmYes = true;
    var isDocBeingSubmitted = document.form1.isDocBeingSubmitted.value;
    var isDocBeingModified = document.form1.isDocBeingModified.value;
    
    if (isDocBeingSubmitted == "false" && isDocBeingModified == "true" )
        isConfirmYes = confirmGoAway();
   
    if (isConfirmYes) {
 
	    var MAWB=document.form1.txtMAWB.value;
	    if (MAWB=="" ){
		    alert("Please enter a MAWB first!");
		    return false;
	    }
	    var MAWBNotExist=document.form1.hMAWBNotExist.value;
	    if (MAWBNotExist=="yes" ){
		    alert("Please SAVE the MAWB first!");
		    return false;
	    }
	    if (Sec==0 ) 
            Sec=1;
	    var HAWB=$("input[name='txtHAWB"+(ItemNo-1)+"']").val();
	    var AgentOrgAcct=document.form1.hAgentOrgAcct.value;
	    
        document.form1.action = encodeURI("arrival_notice.asp?iType=A&Edit=yes&AgentOrgAcct=" + AgentOrgAcct+ "&MAWB=" + MAWB + "&HAWB=" + HAWB+ "&Sec=" + Sec + "&ItemNo=" +ItemNo + "&InvoiceNo=" + InvoiceNo);
        
		if ("<%=headBranch%>" != "") 
			document.form1.action = document.form1.action + "&Branch=" + "<%=headBranch%>";
		
	    document.form1.target="_self";
	    document.form1.method="POST";
	    form1.submit();
    }
}
//--------------------------------------11/29/06 functions for cost Item-------------
function DeleteMAWBClick(){
    if (confirm("Are you sure you want to delete this MAWB? \r\nContinue?")){
	    document.form1.isDocBeingModified.value = "false";
	    document.form1.action=encodeURI("air_import2.asp?iType=A&DeleteMAWB=yes" + "&WindowName=" + window.name);
	    document.form1.target="_self";
	    document.form1.method="POST";
	    form1.submit();
    }
}


function PrefixChange(){
    var sIndex = document.form1.lstFILEPrefix.selectedIndex;
    var Prefix = document.form1.lstFILEPrefix.item(sIndex).text;
    document.form1.hNEXTFILENo.value =  document.form1.lstFILEPrefix.value;
    document.form1.txtFileNo.value = Prefix+ "-"+ document.form1.lstFILEPrefix.value;
}

function GET_ITEM_UNIT_PRICE ( tmpBuf ){
    var ItemUnitPrice=0

    var pos=tmpBuf.indexOf("\n");
    if (pos >= 0)
        ItemUnitPrice = tmpBuf.substring(pos+1, 200);

    return ItemUnitPrice;
}
function SET_UNIT_PRICE( obj, val ){
    obj.value = parseFloat(val).toFixed(2); 
}
function AddCostItem(){
	var iType="<%= iType %>";
	document.form1.isDocBeingModified.value = "false";
	document.form1.hNoCostItem.value=parseInt(document.form1.hNoCostItem.value)+1;
	document.form1.action=encodeURI("air_import2.asp?iType=A" + "&tNo=" + "<%=TranNo%>" + "&AddCostItem=yes"+ "&WindowName=" +window.name);
	document.form1.method="POST";
	document.form1.target="_self";
	form1.submit();
}

function DeleteCostItem(rNo){
    var iType="<%= iType %>";
    if (confirm("Are you sure you want to delete this item? \r\nContinue?")){	
		document.form1.isDocBeingModified.value = "false";
	    document.form1.action=encodeURI("air_import2.asp?iType=A"+ "&tNo="+ "<%=TranNo%>" + "&DeleteCost=yes&rNo="+ rNo+ "&WindowName=" + window.name);
	    document.form1.method="POST";
	    document.form1.target="_self";
	    form1.submit();
   }
}

function ItemCostChange(rNo)
{
    var sIndex=$("select.InvoiceCostItem").get(rNo).selectedIndex;
    var itemInfo = $("select.InvoiceCostItem").get(rNo).value;
    
    if (sIndex==1 ) { // add new item
        window.open ("../acct_tasks/edit_co_items.asp" ,"PopupWin", "<%=StrWindow %>");
    }
    else{
	    var pos=itemInfo.indexOf("\n");
	    if (pos>=0 ){
		    var Desc=itemInfo.substring(pos+1,100);
    		
		    // Unit_Price by ig 10/21/2006
		    var ItemUnitPrice = GET_ITEM_UNIT_PRICE ( Desc );
    		pos=Desc.indexOf("\n");
		    if (pos>=0 )
			    Desc=Desc.substring(0,pos ); 

		    $("input.ItemCostDesc").get(rNo).value=Desc.trim();
    		
		    // Unit_Price by ig 10/21/2006
		    SET_UNIT_PRICE ( $("input.ItemCost").get(rNo) , ItemUnitPrice );
    		
	     }
    }
}

function CostChange(ItemNo){
    var tCost=$("input.ItemCost").get(ItemNo).value;
    if ( tCost!="" ){
	    if (!IsNumeric(tCost)){
		    alert( "Please enter a numeric number!");
		    $("input.ItemCost").get(ItemNo).value=0;
		    return false;
	    }
    }
    var NoItem=parseInt(document.form1.hNoCostItem.value);
    var TotalCost=0;
    for (var j=0 ; j< NoItem; j++){
	    var Cost=$("input.ItemCost").get(j).value;
	    if (Cost=="" )
		    Cost=0;
	    else
		    Cost=parseFloat(Cost);

	    TotalCost=TotalCost+Cost;
    }
    document.form1.txtTotalCost.value=parseFloat(TotalCost).toFixed(2);

}
//------------------------------------------------------------------------------------

function CheckIfMBExist(){ 
  
     var MAWB=document.getElementById("txtMAWB").value;
     var OriginalMAWB="<%=Session("mawb")%>";
     var MAWB_NOT_CHANGED=(MAWB==OriginalMAWB);
     var iType="A";
             
   
	 if(MAWB_NOT_CHANGED){
	    return true;
	 }
	 if(!MAWB_NOT_CHANGED)//IF CHANGED
	 {   
        var req ="";
        if (window.ActiveXObject) {
            try {
                req = new ActiveXObject("Msxml2.XMLHTTP");
            } catch(error) {
                try {
                    req = new ActiveXObject("Microsoft.XMLHTTP");
                } catch(error) { return ""; }
            }
        } 
        else if (window.XMLHttpRequest) {
            req = new XMLHttpRequest();
        } 
        else { return ""; }

        
        req.open("get",encodeURI("/ASP/ajaxFunctions/ajax_CheckIfMBExist.asp?MAWB="+MAWB+"&iType="+iType+"&elt_account_number="+"<%=elt_account_number%>") ,false);
        req.send(); 
        
        var result =req.responseText.split("-");
        var exist=result[0];
        var MB=result[1];
        
        if(exist=="True"){ 
             var aFirm=confirm("The MAWB alreay exists in the database."
             +"\n Would you like to reload with the previous MAWB?"
            );			                      
              
             if(aFirm){    
                 LookUp2(); 
             }
             else{
               return false;			
             }	           
        }else{
            return true;	
        }            
     }
	  return false;  
}

    function ChangeMAWB(){
        <% If check_ap_lock Then %>
        alert("Agent cannot be reassigned since debit item(s) is(are) billed.\nYou must delete bill(s) to perform this operation.");
        <% Else %>
        var sURL = "change_mawb.asp?"
            + "FILE=" + document.form1.txtFileNo.value
            + "&MAWB=" + document.form1.txtMAWB.value
            + "&DEBITNO=" + document.form1.txtAgentDebitNo.value
            + "&ITYPE=A";
 
        var returnval = showModalDialog(encodeURI(sURL + "&WindowName=ChangeImportMAWB"), "", 
            "dialogWidth:350px; dialogHeight:260px; help:0; status:1; scroll:1; center:1; resizable:0;");
        if(returnval){
            document.getElementById("isDocBeingSubmitted").value = "false";
            document.getElementById("isDocBeingModified").value = "false";

            document.form1.txtSMAWB.value = returnval;
            LookUp();
        }
        <% End If %>
    }
    
    function ChangeAgent(){
        <% If check_ap_lock Then %>
        alert("Agent cannot be reassigned since debit item(s) is(are) billed.\nYou must delete bill(s) to perform this operation.");
        <% Else %>

        var sURL = "change_agent.asp?"
            + "FILE=" + document.form1.txtFileNo.value
            + "&MAWB=" + document.form1.txtMAWB.value
            + "&AGENTNAME=" + document.form1.lstFFAgent.value 
            + "&AGENTNO=" + document.form1.hFFAgentAcct.value
            + "&ITYPE=A";   
        if(showModalDialog(encodeURI(sURL + "&WindowName=ChangeImportAgent"), "", 
            "dialogWidth:350px; dialogHeight:260px; help:0; status:1; scroll:1; center:1; resizable:0;")){
            
            document.getElementById("isDocBeingSubmitted").value = "false";
            document.getElementById("isDocBeingModified").value = "false";
            
            document.form1.txtSMAWB.value = document.form1.txtMAWB.value;
            LookUp();
        }
        <% End If %>
    }

    function goLink(billNum) {
	    if(billNum) {
	        var sURL = "../acct_tasks/enter_bill.asp?ViewBill=yes&BillNo=" + billNum;
            if(!showJPModal(encodeURI(sURL), "", 800, 600, "Popwin")){
                document.form1.txtSMAWB.value = document.form1.txtMAWB.value;
                LookUp();
            }
        }
    }

</script>

<!-- //for Tooltip// -->

<script language="JavaScript" type="text/javascript" src="../include/tooltips.js"></script>

<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
