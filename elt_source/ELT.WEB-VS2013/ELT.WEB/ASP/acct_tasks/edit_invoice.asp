<!--  #INCLUDE FILE="../include/transaction.txt" -->
<!--  #INCLUDE FILE="../include/connection.asp" -->
<%
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../include/header.asp" -->

<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_Util_Ver_2.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_data_manager.inc" -->
<%
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'@DECLARATION
'@INITIALIZATION
'@GETTING GENERAL LEDGER INFORMATION FROM DB
'@GETTING THE LIST OF CHARGE ITEMS FROM DB
'@GETTING THE LIST OF COST ITEM FROM DB
'@GETTING THE <DEFAULT INVOICE DATE> AND <DEFAULT COST OF GOOD SOLD> ACCOUNT
'@CHECKING IF THE PAGE IS POST BACK FROM THE SAME SESSION
'@MAIN LOGIC CASE 1:SAVE/DELETE/ADD CHARGE ITEM/ADD COST ITEM/DELETE CHARGE ITEM/DELETE COST ITEM
'1)GETTING THE VALUES FROM SCREEN
'2)HANDLING SAVE REQUET
'-GETTING NEXT INVOICE INFO------------------------------------------------------------------------------
'-UPDATING NEXT INVOICE NUMBER IN USE RPROFILE TALBE --------------------------------------------------------
'-SAVING INVOICE TO THE DB------------------------------------------------------------------------------------------
'--INSERTING INVOICE GENERAL INFO  TO THE DB-----------------------------------
'--INSERTING INVOICE CHARGE ITEMS TO THE DB-----------------------------------
'--INSERTING INVOICE COST ITEMS TO DB-----------------------------------
'--UPDATING THE INVOICE_HAWB WITH ENTRIES THAT WILL BE ISSUED TO ONE CLIENT----------------- 
'--UPDATING ENTRIES OF BILL_DETAIL TABLE---------------------------------------------------
'--SETTING INVOICE QUEUE ENTRY TO BE NOT DISPLAYED IN THE INVOICE QUEUE  SINCE IT IS USED
'--CHECKING IF TRANSACTION TYPE IS ARRIVAL NOTICE (ARRIVAL NOTICE IS AN ENTRY TO ALL_ACCOUNTS_JOURNAL). IF NOT SET TO INV
'--UPDATING ALL_ACCOUNTS_JOURSNAL THAT HAS CURRENT INOIVE NUMBER---------------------------------------		
'@MAIN LOGIC CASE 2:CREATING NEW INVOICE 
'-GETTING INVOICE INFORMATION FROM A INVOICE TO QUEUE 
'-CHECKING IF THE HAWB/HBOL IS A MASTER HOSUE
'-GETTING INVOIE DATE FROM THE BOOKING INFORMATION 
'-GETTING INVOICE RELATED INFORMATION  FROM AIR MAWB/HAWBS
'--GETTING AIRPORT CODES TO BE FILLED IN THE INVOICE -----------------
'-GETTING INVOICE RELATED GENERAL INFORMATION  FROM OCEAN MBOL/HBOLS 
'-GETTING INVOICE RELATED WEIGHT CHARGE INFORMATION  FROM AIR MAWB/HAWBS	
'-GETTING INVOICE RELATED GENERAL INFORMATION  FROM OCEAN MBOL/HBOLS 
'-CALCULATING AIR FREIGHT COST FOR ACCOUNTING 

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Response.Buffer = true
'@DECLARATION ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Dim awb,vMAWB,vHAWB,vAgent,vMasterAgent,vOrgAcct,vOrgName
Dim aHAWB(128),aHAWBURL(128)
Dim Save,NewInvoice,EditInvoice,AddItem
Dim InvoiceNo,InvoiceDate,RefNo,vInvoiceType,vFileNo,vInvoiceAccessType
Dim vCustomerInfo,Customer,vlstHAWB
Dim OriginDest,Origin,Dest,CustomerNumber,EntryDate,Carrier,ArrivalDept
Dim OriginPort,DestPort,Airline
Dim TotalPieces,TotalGrossWeight,TotalChargeWeight,Description
Dim NoItem,aItemNo(1024),aItemName(1024),aDesc(1024),aAmount(1024)
Dim NoCostItem,aCostItemNo(1024),aCostItemName(1024),aCostDesc(1024),aRefNo(1024),aCost(1024),aRealCost(1024)
Dim aAR(1024),aRevenue(1024),aExpense(1024)
Dim aVendor(1024)
Dim vendor_list
Dim aAW(1024),aShare(1024)
Dim SubTotal,SaleTax,AgentProfit,TotalAmount,AR_Config
'// Dim qOrgInfo(),qOrgName(),qOrgAcct(),qOrgTerm(),qOrgAttn(),iCnt
Dim DefaultVendor(),DefaultVendorNo()
DIM vCheckMH
	vCheckMH=N
Dim rs, rs1,SQL
DIM vvvLockAR
DIM vvvLockAP,iType,Vimport_export
DIM MAWB_NUM,Weight_Prepaid,Weight_Collect
DIM cName,cAcct,cAddress,cCity,cState,cZip,cCountry,vCustomer,cZAttn
DIM aAPLock(1024)
DIM vRemarks,vAO,hIndex,pos
Dim TotalChargeWeightScale, TotalGrossWeightScale
Dim MasterInvoiceNo,CreateSub,aSubInvoices
'@END OF DECLARATION '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

'@INITIALIZATION '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Set rs = Server.CreateObject("ADODB.Recordset")
Set rs3 = Server.CreateObject("ADODB.Recordset")
Set aSubInvoices = Server.CreateObject("System.Collections.ArrayList")

NewInvoice=Request.QueryString("new")
NewInvoiceURL=Request("hNewInvoiceURL")
lstHAWB=Request("HAWB")
if NewInvoiceURL="" then
	NewInvoiceURL=query_string
end if
BlankInvoice=Request.QueryString("BlankInvoice")
Save=Request.QueryString("save")
EditInvoice=Request.QueryString("edit")
AddItem=Request.QueryString("AddItem")
AddCostItem=Request.QueryString("AddCostItem")
Delete=Request.QueryString("Delete")
DeleteCost=Request.QueryString("DeleteCost")
qCustomer=Request.QueryString("qCustomer")
COLO=Request("COLO")
Branch=Request.QueryString("Branch")
vQueueID=Request.QueryString("QueueID")
if vQueueID="" then vQueueID=Request("hQueueID")
if vQueueID="" then vQueueID=0
CreateSub = Request.QueryString("CreateSub")
MasterInvoiceNo = Request.QueryString("MasterInvoiceNo")

vTerm = 0
'@END OF INITIALIZATION ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
 
'@GETTING GENERAL LEDGER INFORMATION FROM DB''''''''''''''''''''''''''''''''''''''''''''''''''
SQL= "select * from gl where elt_account_number = " & elt_account_number & " and (gl_account_type='"&CONST__ACCOUNT_RECEIVABLE&"' or gl_master_type='"&CONST__MASTER_EXPENSE_NAME&"' " & " or gl_master_type='"&CONST__MASTER_REVENUE_NAME&"' ) order by gl_account_number"

rs.CursorLocation = adUseClient
rs.Open SQL, eltConn, adOpenForwardOnly, adLockReadOnly, adCmdText
Set rs.activeConnection = Nothing

Dim DefaultAR(64),DefaultARName(64) 
Dim DefaultCGS(64),DefaultCGSName(64)

ARIndex=0
CGSIndex=0
Do While Not rs.EOF
	GlType=rs("gl_account_type")
	GlMasterType=rs("gl_master_type")
	if GlType=CONST__ACCOUNT_RECEIVABLE then
		DefaultAR(ARIndex)=CLng(rs("gl_account_number"))
		DefaultARName(ARIndex)=rs("gl_account_desc")
		ARIndex=ARIndex+1
	end if	
	if GlType=CONST__COST_OF_SALES then
		DefaultCGS(CGSIndex)=Clng(rs("gl_account_number"))
		DefaultCGSName(CGSIndex)=rs("gl_account_desc")
		CGSIndex=CGSIndex+1
	end if

	rs.MoveNext
Loop
rs.Close

'@END OF GETTING GENERAL LEDGER INFORMATION FROM DB''''''''''''''''''''''''''''''''''''


'@GETTING THE LIST OF CHARGE ITEMS FROM DB'''''''''''''''''''''''''''''''''''''''''''''
'SQL= "select item_no,item_name,item_desc,account_revenue,Unit_Price from item_charge where elt_account_number = " & elt_account_number & " order by item_name"
'rs.CursorLocation = adUseClient
'rs.Open SQL, eltConn, adOpenForwardOnly, adLockReadOnly, adCmdText
'Set rs.activeConnection = Nothing
'ItemIndex=0
'Dim DefaultItem(1024),DefaultItemNo(1024),DefaultRevenue(1024),DefaultItemDesc(1024),aItemDesc(1024),igDefaultItem(1024)
'DIM aItemUnitPrice(1024) '// Unit_Price by ig 10/21/2006
'Do While Not rs.EOF
'	DefaultItemNo(ItemIndex)=rs("item_no")
'	if IsNull(DefaultItemNo(ItemIndex)) then DefaultItemNo(ItemIndex)=0
'	DefaultItem(ItemIndex)=rs("item_name")
'	DefaultItemDesc(ItemIndex)=rs("item_desc")
'	DefaultRevenue(ItemIndex)=rs("account_revenue")	
'	aItemUnitPrice(ItemIndex)=rs("Unit_Price") '// Unit_Price by ig 10/21/2006	
'	aItemDesc(DefaultItemNo(ItemIndex))=DefaultItemDesc(ItemIndex)
'	if ( len(DefaultItem(ItemIndex))) < 10 then
'		igDefaultItem(ItemIndex) = DefaultItem(ItemIndex) & " " & string(10-len(DefaultItem(ItemIndex)),"-") & " " & DefaultItemDesc(ItemIndex)
'	else
'		igDefaultItem(ItemIndex) = DefaultItem(ItemIndex)
'	end if
'	ItemIndex=ItemIndex+1
'	rs.MoveNext
'Loop
'rs.Close
'@END OF GETTING THE LIST OF CHARGE ITEMS FROM DB'''''''''''''''''''''''''''''''''''''''''''''

'@GETTING THE LIST OF COST ITEM FROM DB'''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SQL= "select item_no,item_name,item_desc,account_expense,Unit_Price from item_cost where elt_account_number = " & elt_account_number & " order by item_name"
'	rs.CursorLocation = adUseClient
'	rs.Open SQL, eltConn, adOpenForwardOnly, adLockReadOnly, adCmdText
'	Set rs.activeConnection = Nothing
'CostItemIndex=0
'Dim DefaultCostItem(1024),DefaultCostItemNo(1024),DefaultExpense(1024),DefaultCostItemDesc(1024),aCostItemDesc(1024),igDefaultCostItem(1024)
'DIM aCostItemUnitPrice(1024) '// Unit_Price by ig 10/21/2006
'Do While Not rs.EOF
'	DefaultCostItemNo(CostItemIndex)=rs("item_no")
'	if IsNull(DefaultCostItemNo(CostItemIndex)) then DefaultCostItemNo(CostItemIndex)=0
'	DefaultCostItem(CostItemIndex)=rs("item_name")
'	DefaultCostItemDesc(CostItemIndex)=rs("item_desc")
'	DefaultExpense(CostItemIndex)=rs("account_expense")
'	if IsNull(DefaultExpense(CostItemIndex)) then DefaultExpense(CostItemIndex)=0
'	aCostItemDesc(CostItemIndex)=DefaultCostItemDesc(CostItemIndex)	
'	aCostItemUnitPrice(CostItemIndex) = rs("Unit_Price") '// Unit_Price by ig 10/21/2006	
'	if ( len(DefaultCostItem(CostItemIndex))) < 10 then
'	igDefaultCostItem(CostItemIndex) = DefaultCostItem(CostItemIndex) & " " & string(10-len(DefaultCostItem(CostItemIndex)),"-") & " " & DefaultCostItemDesc(CostItemIndex)
'	else
'	igDefaultCostItem(CostItemIndex) = DefaultCostItem(CostItemIndex)
'	end if
'	CostItemIndex=CostItemIndex+1
'	rs.MoveNext
'Loop
'rs.Close
'@END OF GETTING THE LIST OF COST ITEMS FROM DB'''''''''''''''''''''''''''''''''''''''''''''''''''''''''

'@GETTING THE <DEFAULT INVOICE DATE> AND <DEFAULT COST OF GOOD SOLD> ACCOUNT''''''''''''''''''''
dim vUom
SQL= "select default_invoice_date,default_cgs, uom from user_profile where elt_account_number = " & elt_account_number
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, adLockReadOnly, adCmdText
	Set rs.activeConnection = Nothing
if not rs.EOF then
	vDefaultInvoiceDate=rs("default_invoice_date")
	If IsNull(rs("default_cgs")) = False then
		vCGS=rs("default_cgs")
	else
		vCGS=0
	end if
	if vCGS="" then
		vCGS=0
	else
		vCGS=cLng(vCGS)
	end if
    If IsNull(rs("uom")) = False then
        vUom=rs("uom")
    else 
        vUom = "Kg"
    end if 
end if
rs.Close
'@END OF GETTING THE <DEFAULT INVOICE DATE> AND <DEFAULT COST OF GOOD SOLD ACCOUNT>'''''''''''''''''

'@CHECKING IF THE PAGE IS POST BACK FROM THE SAME SESSION''''''''''''''''''''''''''''''''''''''''''''''
TranNo=Session("IVTranNo")
if TranNo="" then
	Session("IVTranNo")=0
	TranNo=0
end if
tNo=Request.QueryString("tNo")
if tNO="" then
	tNO=0
else
	tNo=cLng(tNo)
end if
if Save="yes" and ( tNo <> TranNo ) then
	Save = ""
	EditInvoice = "yes"
	InvoiceNo=Request("txtInvoiceNo")
end if

'@END OF CHECKING IF THE PAGE IS POST BACK FROM THE SAME SESSION''''''''''''''''''''''''''''''''''''''''''

'@MAIN LOGIC CASE 1:SAVE/DELETE/ADD CHARGE ITEM/ADD COST ITEM/DELETE CHARGE ITEM/DELETE COST ITEM''''''''''''''''''''''''''''''''''''''''''
if Save="yes" or AddItem ="yes" or AddCostItem ="yes" or Delete="yes" or DeleteCost="yes" or qCustomer="yes" or lstHAWB="yes" Then
	'1)GETTING THE VALUES FROM SCREEN-------------------------------------------------------
	vAO=Request("hAO")
	qCustomerName=Request("txtqCustomerName")
	InvoiceNo=Request("txtInvoiceNo")
	MasterInvoiceNo = Request.Form("txtMasterInvoice")

	If NOT tNo = TranNo Then 
		InvoiceNo=Session("InvoiceNo")
		If InvoiceNo="" Then 
			InvoiceNo=0
		End if
		If InvoiceNo=0 Then 
			InvoiceNo = Request("txtInvoiceNo")
		End If			
	End If	
	If InvoiceNo="" Then InvoiceNo=0
	vTerm = checkBlank(Request("txtTerm"), 0)
	
	InvoiceDate = ConvertAnyValue(Request("txtInvoiceDate"),"Date",Date())

	RefNo=Request("txtRefNo")
	vFileNo=Request("txtFileNo")
	vRemarks=Request("txtRemarks")
	vInMemo=Request("txtInMemo")
	TotalPieces=Request("txtTotalPiece")
	TotalGrossWeight=Request("txtTotalGrossWeight") + Request("lstTotalGrossWeightScale")
	TotalChargeWeight=Request("txtTotalChargeWeight") + Request("lstTotalChargeWeightScale")
	Description=Request("txtDescription")
	OriginDest=Request("txtOriginDest")
	Origin=Request("txtOrigin")
	Dest=Request("txtDest")
	
	vCustomerInfo=Request("txtCustomerInfo")
	vOrgAcct=Request("hCustomerAcct")
	if vOrgAcct="" then vOrgAcct=0
	vCustomer=Request("hCustomerName")
	vOrgName=Request("hCustomerName")
	
	vShipper=Request("txtShipper")
	vConsignee=Request("txtConsignee")
	EntryNo=Request("txtEntryNo")
	EntryDate=Request("txtEntryDate")
	if EntryDate="" then EntryDate=Date
	Carrier=Request("txtCarrier")
	ArrivalDept=Request("txtArrivalDept")
	MAWB_NUM=Request("txtMAWB")
	vHAWB=Request("txtHAWB")
	vHBOL=Request("hHBOL")
	if vHBOL="" then vHBOL=0
	SubTotal=Request("txtSubTotal")
	if SubTotal="" then SubTotal=0
	SaleTax=Request("txtSaleTax")
	if SaleTax="" then SaleTax=0
	AgentProfit=Request("txtAgentProfit")
	if AgentProfit="" then AgentProfit=0
	TotalAmount=Request("txtTotalAmount")
	TotalCost=Request("txtTotalCost")
	if TotalCost="" then TotalCost=0
	AR_Config=Request("lstAR")
	vCGS=Request("lstCGS")
	if vCGS="" then 
		vCGS=0
	else
		vCGS=cLng(vCGS)
	end if
	if TotalAmount="" then TotalAmount=0
	NoItem=Request("hNoItem")
	NoCostItem=Request("hNoCostItem")
	if NoItem="" then
		NoItem=0
	else
		NoItem=CInt(NoItem)
	end if
	if NoCostItem="" then
		NoCostItem=0
	else
		NoCostItem=CInt(NoCostItem)
	end if
	
	for i=0 to NoItem-1
	    If checkBlank(Request("hChargeItem" & i),"") <> "" Then
            aItemNo(i) = Request("hChargeItem" & i)
            aRevenue(i) = GetSQLResult("SELECT account_revenue FROM item_charge WHERE elt_account_number=" & elt_account_number & " AND item_no=" & aItemNo(i), Null)
		    aItemName(i) = GetSQLResult("SELECT item_name FROM item_charge WHERE elt_account_number=" & elt_account_number & " AND item_no=" & aItemNo(i), Null)
		    aDesc(i)=Request("txtDesc" & i)
		    aAmount(i)=Request("txtAmount" & i)
		    if aAmount(i)="" then
			    aAmount(i)=0
		    else
			    aAmount(i)=Cdbl(aAmount(i))
		    end if
		End If
	next
	
	for i=0 to NoCostItem-1
	    If checkBlank(Request("hCostItem" & i),"") <> "" And checkBlank(Request("hVendorAcct" & i),"") <> "" Then
	    
		    aCostItemNo(i) = Request("hCostItem" & i)
		    aExpense(i) = GetSQLResult("SELECT account_expense FROM item_cost WHERE elt_account_number=" & elt_account_number & " AND item_no=" & aCostItemNo(i), Null)
		    aExpense(i) = checkBlank(aExpense(i),0)
		    aCostItemName(i) = GetSQLResult("SELECT item_name FROM item_cost WHERE elt_account_number=" & elt_account_number & " AND item_no=" & aCostItemNo(i), Null)
    		
		    aCostDesc(i)=Request("txtCostDesc" & i)
		    aRefNo(i)=Request("txtRefNo" & i)
		    aRealCost(i)=Request("txtCost" & i)
		    if aRealCost(i)="" then
			    aRealCost(i)=0
		    else
			    aRealCost(i)=cdbl(aRealCost(i))
		    end if
		    aVendor(i)=CLng(Request("hVendorAcct" & i))
		    aAPLock(i)=Request("txtAPLOCK" & i)
        End If
	next
	
	NoHAWB=Request("hNoHAWB")
	if NoHAWB="" then
		NoHAWB=0
	else
		NoHAWB=cInt(NoHAWB)
	end if
	for i=0 to NoHAWB-1
		aHAWBURL(i)=Request("hHAWBURL" & i)
		pos=0
		pos=instr(aHAWBURL(i),"HAWB=")
		if pos>0 then
			aHAWB(i)=mid(aHAWBURL(i),pos+1,200)
			pos=instr(aHAWB(i),"=")
			if pos>0 then
			 aHAWB(i)=mid(aHAWB(i),pos+1,200)
			end if
		end if
	next
	hIndex=NoHAWB
	if Delete="yes" then
		dItemNo=Request.QueryString("rNo")
		for i=dItemNo to NoItem-1
			aItemNo(i)=aItemNo(i+1)
			aRevenue(i)=aRevenue(i+1)
			aDesc(i)=aDesc(i+1)
			aAmount(i)=aAmount(i+1)
		next
		NoItem=NoItem-1
	end if
	if DeleteCost="yes" then
		dItemNo=Request.QueryString("rNo")
		for i=dItemNo to NoCostItem-1
			aCostItemNo(i)=aCostItemNo(i+1)
			aExpense(i)=aExpense(i+1)
			aCostDesc(i)=aCostDesc(i+1)
			aRefNo(i)=aRefNo(i+1)
			aRealCost(i)=aRealCost(i+1)
			aVendor(i)=aVendor(i+1)
			aAPLock(i)=aAPLock(i+1)			
		next
		NoCostItem=NoCostItem-1
	end if
	SubTotal=0
	TotalCharge=0
	TotalCost=0
	for i=0 to NoItem-1
		TotalCharge=TotalCharge+aAmount(i)
	next
	for i=0 to NoCostItem-1
		TotalCost=TotalCost+aRealCost(i)
	next
	SubTotal=TotalCharge
	TotalAmount=SubTotal+SaleTax-AgentProfit	
	tIndex=NoItem
	cIndex=NoCostItem	
	'END OF GETTING THE VALUES FROM SCREEN--------------------------------------------------
	
	'2)HANDLING SAVE REQUET ----------------------------------------------------------------
	if Save="yes" And tNo=TranNo then
	    eltConn.BeginTrans()
		'-GETTING NEXT INVOICE INFO------------------------------------------------------------------------------
		If InvoiceNo=0 Then
			SQL= "select next_invoice_no from user_profile where elt_account_number = " & elt_account_number
			rs.CursorLocation = adUseClient
			rs.Open SQL, eltConn, adOpenForwardOnly, adLockReadOnly, adCmdText
			Set rs.activeConnection = Nothing
			If Not rs.EOF And IsNull(rs("next_invoice_no"))=False Then
				InvoiceNo=cLng(rs("next_invoice_no"))
				rs.close
			Else
				rs.close
				SQL= "select max(invoice_no) as InvoiceNo from Invoice where elt_account_number = " & elt_account_number
				rs.CursorLocation = adUseClient
				rs.Open SQL, eltConn, adOpenForwardOnly, adLockReadOnly, adCmdText
				Set rs.activeConnection = Nothing
				If Not rs.EOF And IsNull(rs("InvoiceNo"))=False Then
					InvoiceNo=CLng(rs("InvoiceNo")) + 1
				Else
					InvoiceNo=10001
				End If
				rs.close
			End If
			If InvoiceNo=0 Or InvoiceNo="0" Then
%>

<script language="javascript" type="text/javascript">
    alert("Sorry, An error was occured when creating a new I/V Number.\n Please try again.")
    history.go(-1);
</script>

<%
				response.end()
			End If
			InvoiceExist="Y"
			do while InvoiceExist="Y"
				SQL= "select * from Invoice where elt_account_number = " & elt_account_number & " and invoice_no=" & InvoiceNo
				rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
				If rs.EOF=true Then
					rs.AddNew
					rs("elt_account_number")=elt_account_number
					rs("Invoice_No")=InvoiceNo
					rs("invoice_type")="I"
					OrigTotalAmt=0
					InvoiceExist="N"
				else
					rs.close
					InvoiceNo=InvoiceNo+1
				end if
			Loop
			'-END OF GETTING NEXT INVOICE INFO---------------------------------------------------------------------------

			'-UPDATING NEXT INVOICE NUMBER IN USE RPROFILE TALBE --------------------------------------------------------
			Set rs1=Server.CreateObject("ADODB.Recordset")
			SQL= "select next_invoice_no from user_profile where elt_account_number=" & elt_account_number
			rs1.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
			If Not rs1.EOF Then
				rs1("next_invoice_no")=InvoiceNo+1
				rs1.Update
			end if
			rs1.Close
		else
			SQL= "select * from Invoice where elt_account_number = " & elt_account_number & " and invoice_no=" & InvoiceNo
			rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
			If rs.EOF=true Then
				rs.AddNew
				rs("elt_account_number")=elt_account_number
				rs("Invoice_No")=InvoiceNo
				rs("invoice_type")="I"
				OrigTotalAmt=0
			Else
				OrigTotalAmt=cdbl(rs("amount_charged"))
			end if
		end if
		'-END OF UPDATING NEXT INVOICE NUMBER IN USE RPROFILE TALBE --------------------------------------------------------

		'-SAVING INVOICE TO THE DB------------------------------------------------------------------------------------------
		'--INSERTING INVOICE GENERAL INFO  TO THE DB-----------------------------------
	  	Session("InvoiceNo") = InvoiceNo
		Session("IVTranNo")=Clng(Session("IVTranNo"))+1
		TranNo=Clng(Session("IVTranNo"))
		rs("term_curr") = vTerm
		if not InvoiceDate="" then
			rs("Invoice_Date")=InvoiceDate
		end if
		rs("remarks")=vRemarks
		rs("in_memo")=vInMemo		
		if isnull(rs("import_export")) then
			rs("import_export")="E"
			Vimport_export = "E"
		Else
			If Not Trim(rs("import_export"))="I" then
				rs("import_export")="E"
				Vimport_export = "E"
			End if
		End if
		if Vimport_export <> "E" then
			Vimport_export = "I"
		end if
		vAO = Request("hAO")

		If vAO="AIR" Then
			iType = "A"
		End If
		If vAO="OCEAN" Then
			iType = "O"
		End if	
		
		'// If checkBlank(rs("air_ocean"),"") <> "" Then
		'//    rs("air_ocean") = iType
		'// End If
		
		rs("air_ocean") = iType
		
		rs("ref_no")=RefNo		
		rs("ref_no_Our")=vFileNo
		rs("Customer_Info")=vCustomerInfo
		rs("Total_Pieces")=TotalPieces
		rs("Total_Gross_Weight")=TotalGrossWeight
		rs("Total_Charge_Weight")=TotalChargeWeight
		rs("Description")=Description
		rs("Origin_Dest")=OriginDest
		rs("Origin")=Origin
		rs("Dest")=Dest
		rs("Customer_Number")=vOrgAcct
		rs("Customer_Name")=vCustomer
		rs("shipper")=vShipper
		rs("consignee")=vConsignee
		rs("Entry_No")=EntryNo
		rs("Entry_Date")=EntryDate
		rs("Carrier")=Carrier
		rs("Arrival_Dept")=ArrivalDept
		rs("MAWB_NUM")=MAWB_NUM
		rs("HAWB_NUM")=vHAWB
		rs("SubTotal")=SubTotal
		rs("Sale_Tax")=SaleTax
		rs("Agent_Profit")=AgentProfit
		rs("accounts_receivable")=AR_Config	
		If checkBlank(MasterInvoiceNo,"") <> "" Then
		    rs("master_invoice_no") = MasterInvoiceNo
		End If
		if isnull(rs("lock_ar")) and  isnull(rs("lock_ap")) then			
			if not TotalAmount="" then rs("amount_charged")=TotalAmount
			if not TotalCost="" then rs("total_cost")=TotalCost
			if not TotalAmount="" then rs("balance")=TotalAmount
			
			'// if 	cDbl(rs("balance")) < 0 then rs("balance") = 0			
			
			if TotalAmount<>0 then
				rs("pay_status")="A"
			end if
			rs("lock_ar")="N"
			rs("lock_ap")="N"
		else			
			if not TotalAmount="" then 
				rs("amount_charged")=TotalAmount
			else
				rs("amount_charged")=0
			end if			
			if not TotalCost="" then 
				rs("total_cost")=TotalCost
			else
				rs("total_cost")=0
			end if
			DIM tmpPaid
			if isnull(rs("amount_paid")) then
				tmpPaid	= 0
			else
				tmpPaid = rs("amount_paid")
			end if		
			rs("balance") =  cDbl(TotalAmount) - cDbl(tmpPaid)	
			
			if ( ( cDbl(TotalAmount) - cDbl(tmpPaid)) <> 0 ) then
				rs("pay_status")="A"
			end if	
					
			'// if 	cDbl(rs("balance")) < 0 then rs("balance") = 0

		end if	
			
		rs.Update
		rs.Close
		
		call update_customer_payment(InvoiceNo)
		call update_customer_credit( vOrgAcct, vCustomer )	
		'// END OF INSERTING INVOICE GENERAL INFO  TO THE DB-----------------------------------	
		'// INSERTING INVOICE CHARGE ITEMS TO THE DB-----------------------------------
		Dim aOrigAmt(128)
		SQL= "delete from invoice_charge_item where elt_account_number = " & elt_account_number & " and invoice_no=" & InvoiceNo
		eltConn.Execute SQL
		OrigTotalCost=0
		for i=1 to NoItem
			if Not aItemNo(i-1)="" And aAmount(i-1)<>0 then
				SQL= "select elt_account_number,Invoice_No,item_id,item_no,item_desc,charge_amount from invoice_charge_item where elt_account_number = " & elt_account_number & " and invoice_no=" & InvoiceNo & " and item_id=" & i
				rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
				If rs.EOF Then
					rs.AddNew
					rs("elt_account_number")=elt_account_number
					rs("Invoice_No")=InvoiceNo
					rs("item_id")=i
					aOrigAmt(i-1)=0
				Else
					aOrigAmt(i-1)=cdbl(rs("charge_amount"))
				end if
				rs("item_no")=aItemNo(i-1)
				rs("item_desc")=aDesc(i-1)
				rs("charge_amount")=aAmount(i-1)
				rs.Update
				rs.Close
			end if
		next
		'// END OF INSERTING INVOICE CHARGE ITEMS TO DB-----------------------------------	
		if Vimport_export = "I" then
			call update_arrival_notice( InvoiceNo,NoItem )
		end if	
				
		'// INSERTING INVOICE COST ITEMS TO DB------------------------------------------------
		Dim aOrigCost(128),OrigTotalCost
		SQL= "delete from invoice_cost_item where elt_account_number = " & elt_account_number & " and invoice_no=" & InvoiceNo
		eltConn.Execute SQL
		OrigTotalCost=0

		for i=1 to NoCostItem
			if Not aCostItemNo(i-1)="" And aRealCost(i-1)<>0 then
				SQL= "select elt_account_number,Invoice_No,item_id,item_desc,cost_amount,item_no,ref_no,Vendor_no from invoice_cost_item where elt_account_number = " & elt_account_number & " and invoice_no=" & InvoiceNo & " and item_id=" & i
				rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
				If rs.EOF Then
					rs.AddNew
					rs("elt_account_number")=elt_account_number
					rs("Invoice_No")=InvoiceNo
					rs("item_id")=i
					aOrigCost(i-1)=0
					aOrigAmt(i-1)=0
				Else
					aOrigCost(i-1)=cdbl(rs("cost_amount"))
				end if
				OrigTotalCost=OrigTotalCost+aOrigCost(i-1)
				rs("item_no")=aCostItemNo(i-1)
				rs("item_desc")=aCostDesc(i-1)
				rs("ref_no")=aRefNo(i-1)
				rs("cost_amount")=aRealCost(i-1)
				rs("Vendor_no")=aVendor(i-1)
				rs.Update
				rs.Close
			end if
		next		
		'// END OF INSERTING INVOICE COST ITEMS TO DB------------------------------------------------

		'// UPDATING THE INVOICE_HAWB WITH ENTRIES THAT WILL BE ISSUED TO ONE CLIENT----------------- 
		SQL= "delete from invoice_hawb where elt_account_number = " & elt_account_number & " and invoice_no=" & InvoiceNo
		eltConn.Execute SQL			
		for i=0 to NoHAWB-1
			if Not aHAWB(i)="" then
				SQL= "select elt_account_number,Invoice_No,hawb_num,hawb_url from invoice_hawb where elt_account_number = " & elt_account_number & " and invoice_no=" & InvoiceNo
				rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
				rs.AddNew
				rs("elt_account_number")=elt_account_number
				rs("Invoice_No")=InvoiceNo
				rs("hawb_num")=aHAWB(i)
				rs("hawb_url")=aHAWBURL(i)
				rs.Update
				rs.Close
			end if
		next
		'// END OF UPDATING THE INVOICE_HAWB WITH ENTRIES THAT WILL BE ISSUED TO ONE CLIENT--------- 		
		
		'// UPDATING ENTRIES OF BILL_DETAIL TABLE---------------------------------------------------
		SQL= "delete from bill_detail where elt_account_number = " & elt_account_number & " and invoice_no=" & InvoiceNo 
		eltConn.Execute SQL
		item_id=1
		for i=1 to NoCostItem
			if aRealCost(i-1)<>0 then
				SQL= "select * from bill_Detail where elt_account_number=" & elt_account_number & " and invoice_no=" & InvoiceNo & " and item_id=" & item_id
				rs.Open SQL,eltConn,adOpenDynamic,adLockPessimistic,adCmdText
				rs.AddNew
				rs("elt_account_number")=elt_account_number
				rs("Invoice_No")=InvoiceNo
				rs("item_id")=item_id
				if isnull(aAPLock(i-1)) or aAPLock(i-1) = "" then
					rs("bill_number")= 0
				else
				    If checkBlank(Request.QueryString("AsNew"),"") = "Y" Then
				        rs("bill_number")= 0
				        aAPLock(i-1) = ""
				    Else
					    rs("bill_number")= aAPLock(i-1)
					End If
				end if
				rs("vendor_number")=aVendor(i-1)
				rs("item_name")=aCostDesc(i-1)
				rs("item_no")=aCostItemNo(i-1)
				rs("item_amt")=aRealCost(i-1)
				rs("item_amt_origin")=aRealCost(i-1)
				rs("item_expense_acct")=aExpense(i-1)
				rs("tran_date")=InvoiceDate
				rs("ref")=aRefNo(i-1)
				rs.Update
				rs.Close
				item_id=item_id+1
			end if
		next		
		'// END OF UPDATING ENTRIES OF BILL_DETAIL TABLE---------------------------------------------------
		
		'// SETTING INVOICE QUEUE ENTRY TO BE NOT DISPLAYED IN THE INVOICE QUEUE  SINCE IT IS USED
		if cLng(vQueueID)>0 then
			SQL="select invoiced,outqueue_date from invoice_queue where elt_account_number=" & elt_account_number & " and queue_id=" & vQueueID
			rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
			If not rs.EOF Then
				if rs("invoiced")="N" then
					rs("invoiced")="Y"
					rs("outqueue_date")=Now
					rs.Update
				end if
			End If
			rs.Close
		end if		
		'// SETTING INVOICE QUEUE ENTRY TO BE NOT DISPLAYED IN THE INVOICE QUEUE   SINCE IT IS USED
		
		'// CHECKING IF TRANSACTION TYPE IS ARRIVAL NOTICE (ARRIVAL NOTICE IS AN ENTRY TO ALL_ACCOUNTS_JOURNAL). IF NOT SET TO INV
		
		DIM tmpTran_type '// by iMoon DEC/13/2006
		SQL= "select tran_num from all_accounts_journal where elt_account_number=" & elt_account_number & " and tran_type='ARN' and tran_num=" & InvoiceNo
		rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
		If Not rs.EOF Then
			tmpTran_type = "ARN"
		else
			tmpTran_type = "INV"		
		end if
		rs.Close
		'// END OF CHECKING IF TRANSACTION TYPE IS ARRIVAL NOTICE (ARRIVAL NOTICE IS AN ENTRY TO ALL_ACCOUNTS_JOURNAL). IF NOT SET TO INV
		
		'// UPDATING ALL_ACCOUNTS_JOURSNAL THAT HAS CURRENT INOIVE NUMBER ---------------------------------------
		SQL= "delete from all_accounts_journal where elt_account_number = " & elt_account_number & " and tran_type='" & tmpTran_type & "' and tran_num=" & InvoiceNo
		eltConn.Execute SQL
		
		SQL= "select max(tran_seq_num) as SeqNo from all_accounts_journal where elt_account_number = " & elt_account_number
		rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
		If Not rs.EOF And IsNull(rs("SeqNo")) = False Then
			SeqNo = CLng(rs("SeqNo")) + 1
		Else
			SeqNo = 1
		End If
		rs.Close	
If Err.Number <> 0 Then
   
   Response.Write (Err.Description& "<br><br>")
                response.end
       end if
		'// insert an init record in all_accounts_journal for the AR and for this customer if it is not exist
		SQL= "select * from all_accounts_journal where elt_account_number = " & elt_account_number & " and gl_account_number=" & AR_Config & " and tran_type='INIT' and customer_number=" & vOrgAcct
		rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
		if rs.EOF then
			rs.AddNew
			rs("elt_account_number")=elt_account_number
			rs("gl_account_number")=AR_Config
			rs("gl_account_name")=GetGLDesc(AR_Config)
			rs("tran_seq_num") = SeqNo
			SeqNo = SeqNo + 1
			rs("tran_type")="INIT"
			rs("tran_date")=Now
			rs("Customer_Number")=vOrgAcct
			rs("Customer_Name")=vCustomer
			rs("debit_amount")=0
			rs("credit_amount")=0
			rs("balance")=0
			rs("previous_balance")=0
			rs("gl_balance")=0
			rs("gl_previous_balance")=0
			rs.Update
		end if
		rs.Close
		
		'// ------------------------(I/S & B/S) insert Revenue  data to all_accounts_journal---------------------
		
		SQL= "select * from all_accounts_journal where elt_account_number = " & elt_account_number & " and tran_seq_num=" & SeqNo
		rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
		if rs.eof then
			rs.AddNew
			rs("elt_account_number")=elt_account_number			
			rs("gl_account_number")=AR_Config '------------------AR account 			
			rs("gl_account_name")=GetGLDesc(AR_Config)
			rs("tran_seq_num")=SeqNo
			SeqNo=SeqNo+1
			rs("tran_type")=tmpTran_type
			rs("tran_num")=InvoiceNo
			rs("tran_date")=InvoiceDate
			rs("Customer_Number")=vOrgAcct
			rs("Customer_Name")=vCustomer
			rs("memo")=Mid(Description,1,255)
			rs("split")=Mid(GetGLDesc(aRevenue(0)),1,127)
			rs("debit_amount")=TotalAmount
			rs("credit_amount")=0
			rs("balance")=cuBalance
			rs("previous_balance")=cuPBalance
			rs("gl_balance")=arBalance
			rs("gl_previous_balance")=arPBalance
							
			rs.Update
		end if
		rs.Close	
		
		'-------------------(I/S & BS ) insert Cost of Goods Sold record (Agent Profit) in all_accounts_journal-----------------
		
		if Not AgentProfit=0 then
			SQL= "select * from all_accounts_journal where elt_account_number = " & elt_account_number & " and tran_seq_num=" & SeqNo
			rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
'			rs.Open "all_accounts_journal", eltConn, adOpenDynamic, adLockPessimistic, adCmdTable
			if rs.eof then
				rs.AddNew
				rs("elt_account_number")=elt_account_number
				rs("gl_account_number")=vCGS
				rs("gl_account_name")=GetGLDesc(vCGS)
				rs("tran_seq_num")=SeqNo
				SeqNo=SeqNo+1
				rs("tran_type")=tmpTran_type
				rs("tran_num")=InvoiceNo
				rs("tran_date")=InvoiceDate
				rs("split")=GetGLDesc(aRevenue(0))				
				rs("debit_amount")=AgentProfit
				rs("credit_amount")=0
				
				'rs("last_modified")=Now
				rs.Update
			end if
		rs.Close
		end if	
		
		'-----------------------------insert and update to Revenue in all_accounts_journal---------------
		
		'--------------------B/S:Each items should be increased as Revenues in credit; Asset(AR)=L(0 at this point)+E(Income)		
		'--------------------B/S:Total Amount is AR increased as debit. AR balances out the Revenue
		'------------------- I/S:Revenue - E(0)= Income
		
		
		
		for i=0 to NoItem-1		
			if Not aItemNo(i)="" then
				SQL= "select * from all_accounts_journal where elt_account_number = " & elt_account_number & " and tran_seq_num=" & SeqNo
				rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
				if rs.eof then
					rs.AddNew
					rs("elt_account_number")=elt_account_number
					rs("gl_account_number")=aRevenue(i)
					rs("gl_account_name")=GetGLDesc(aRevenue(i))
					rs("tran_seq_num")=SeqNo
					SeqNo=SeqNo+1
					rs("tran_type")=tmpTran_type
					rs("tran_num")=InvoiceNo
					rs("tran_date")=InvoiceDate
					rs("Customer_Number")=vOrgAcct
					rs("Customer_Name")=vCustomer
					rs("memo")=aDesc(i)
					rs("split")=GetGLDesc(AR_Config)					
					rs("debit_amount")=0					
					rs("credit_amount")=-aAmount(i)	
									
					rs("balance")=cuBalance
					rs("previous_balance")=cuPBalance
					rs("gl_balance")=rBalance
					rs("gl_previous_balance")=rPBalance
					
					rs.Update
				end if
				rs.Close
			end if
		next
		'--END OF UPDATING ALL_ACCOUNTS_JOURSNAL THAT HAS CURRENT INOIVE NUMBER---------------------------------------
	    eltConn.CommitTrans()
	end if
	'-END OF SAVING INVOICE TO THE DB------------------------------------------------------------------------------------------'
'@END OF MAIN LOGIC CASE 1:SAVE/DELETE/ADD CHARGE ITEM/ADD COST ITEM/DELETE CHARGE ITEM/DELETE COST ITEM'''''''''''''''''''''''''''''''''''

'@MAIN LOGIC CASE 2:CREATING NEW INVOICE ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
elseif NewInvoice="yes" then
	    
    '// GETTING INVOICE INFORMATION FROM A INVOICE TO QUEUE 
    SQL="select * from invoice_queue where elt_account_number=" & elt_account_number & " and queue_id=" & vQueueID
    rs.CursorLocation = adUseClient
    rs.Open SQL, eltConn, adOpenForwardOnly, adLockReadOnly, adCmdText
    Set rs.activeConnection = Nothing
    if Not rs.EOF then
	    vInvoiceType=rs("agent_shipper")
	    if vInvoiceType="S" then 'prepaid
		    vInvoiceType="Shipper" 
	    else
		    vInvoiceType="Agent" 'collect  from operation
	    end if
	    vOrgAcct=rs("bill_to_org_acct")
	    vOrgName=rs("bill_to")
	    if IsNull(vOrgAcct) Or vOrgAcct="" then vOrgAcct=0
	    vHAWB=rs("hawb_num")
	    vMAWB=rs("mawb_num")
	    vAgent=rs("agent_org_acct")
	    if IsNull(vAgent) Or vAgent="" then vAgent=0
	    vAO=rs("air_ocean")
	    if vAO="A" Or vAO="D" then
		    vAO="AIR"
		    iType = "A"
	    elseif vAO="O" then
		    vAO="OCEAN"
		    iType = "O"
	    end if
	    if vAO="OCEAN" then
		    vHBOL=vHAWB
		    vBookingNum=vMAWB
	    end if

	    vMasterAgent=rs("master_agent")
	    vMasterOnly=checkBlank(rs("master_only"),"N")
    end if
    rs.close	
    '-END OF GETTING INVOICE INFORMATION FROM INVOICE QUEUE

	
	'-CHECKING IF THE HAWB/HBOL IS A MASTER HOSUE
	IF iType="A" then 
		SQL="select isnull(is_master,'N') as is_master from hawb_master where elt_account_number=" & elt_account_number & " and hawb_num='" & vHAWB&"'"
	else 
		SQL="select isnull(is_master,'N') as is_master from hbol_master where elt_account_number=" & elt_account_number & " and hbol_num='" & vHAWB&"'"
	end if 	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, adLockReadOnly, adCmdText
	Set rs.activeConnection = Nothing
	if Not rs.EOF then
		vCheckMH=rs("is_master")
	end if 
	rs.close	
	'-EMD OF CHECKING IF THE HAWB/HBOL IS A MASTER HOSUE
	
	'-GETTING INVOIE DATE FROM THE BOOKING INFORMATION 
	if vAO="AIR" then
		SQL= "select  etd_date1 as etd, eta_date1 as eta,File# as file_no from mawb_number where elt_account_number = " & elt_account_number & " and mawb_no='" & vMAWB & "'"
	else
		SQL= "select  departure_date as etd, arrival_date as eta,file_no from ocean_booking_number where elt_account_number = " & elt_account_number & " and booking_num='" & vBookingNum & "'"
	end if
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, adLockReadOnly, adCmdText
	Set rs.activeConnection = Nothing
	if Not rs.EOF then
		if vDefaultInvoiceDate="Today" then
			InvoiceDate=Date()
		elseif (vAO="AIR" and Not vMAWB="") or (vAO="OCEAN" and Not vBookingNum="") then
				if vDefaultInvoiceDate="ETD" then
					InvoiceDate=rs("etd")
				else
					InvoiceDate=rs("eta")
				end if
		end if
		vFileNo = rs("file_no")
	end if
	rs.close
	'-END OF GETTING INVOICE DATE FROM THE BOOKING INFORMATION 

	'-GETTING INVOICE RELATED INFORMATION  FROM AIR MAWB/HAWBS  
	if vAO="AIR" And Not vInvoiceType="Colodee" then
		if vMasterOnly="Y" then
			SQL= "select *, weight_scale as m_weight_scale from mawb_master where elt_account_number = " & elt_account_number & " and mawb_num='" & vMAWB & "'"
		else
			if vInvoiceType="Shipper" then
				SQL= "select a.*, b.weight_scale as m_weight_scale from hawb_master a LEFT OUTER JOIN mawb_master b ON (a.elt_account_number=b.elt_account_number AND a.mawb_num = b.mawb_num)  where a.elt_account_number = " & elt_account_number & " and a.hawb_num='" & vHAWB & "'"
			else
				SQL= "select a.*, b.weight_scale as m_weight_scale from hawb_master a LEFT OUTER JOIN mawb_master b ON (a.elt_account_number=b.elt_account_number AND a.mawb_num = b.mawb_num)  where a.elt_account_number = " & elt_account_number & " and a.mawb_num='" & vMAWB & "' and a.agent_no=" & vAgent & " order by a.colo,a.colo_pay"
			end if
		end if
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, adLockReadOnly, adCmdText
		Set rs.activeConnection = Nothing			

		'// Response.Write(SQL)

		Do While Not rs.EOF
		
			if vInvoiceType="Shipper" then
				vCustomerInfo=rs("Shipper_Info")
				vCustomer=rs("Shipper_Name")
				vShipper=rs("Shipper_Name")
				vConsignee=rs("consignee_Name")
			else
				if Not vMasterOnly="Y" then
					vCOLO=rs("colo")
					if vCOLO="Y" then
						vCOLOPay=rs("colo_pay")
						if vCOLOPay="C" then
							vCustomerInfo=rs("agent_Info")
							vCustomer=rs("agent_Name")
							vShipper=rs("agent_Name")
						else
							vCustomerInfo="COLO"
							vShipper=""
						end if
					else
						vCustomerInfo=rs("Agent_Info")
						vCustomer=rs("Agent_Name")
                        If vHAWB<>"" And vHAWB<>"CONSOLIDATION" And vHAWB=rs("HAWB_num") Then
						    vShipper=rs("Shipper_Name")
						    vConsignee=rs("consignee_Name")
						End If
					end if
				else
					vCustomerInfo=rs("consignee_Info")
					vCustomer=rs("consignee_name")
					If vHAWB<>"" And vHAWB<>"CONSOLIDATION" And vHAWB=rs("HAWB_num") Then
                        vShipper=rs("Shipper_Name")
                        vConsignee=rs("consignee_Name")
                    End If
				end if
			end if				

			vWeightScale = checkBlank(rs("m_weight_scale"), null)

			If vHAWB <> "CONSOLIDATION" Then
				TotalPieces = TotalPieces + cint(rs("total_pieces"))

				If vWeightScale <> rs("weight_scale") And rs("weight_scale") = "L" Then
					TotalGrossWeight = TotalGrossWeight + cdbl(rs("total_gross_weight")) * 2.20462262
					TotalChargeWeight = TotalChargeWeight + cdbl(rs("total_chargeable_weight")) * 2.20462262
				Else
					TotalGrossWeight = TotalGrossWeight + cdbl(rs("total_gross_weight"))
					TotalChargeWeight = TotalChargeWeight + cdbl(rs("total_chargeable_weight"))	
				End If

			Else
				If rs("COLL_1") = "Y" Then
					TotalPieces = TotalPieces + cint(rs("total_pieces"))

					If vWeightScale <> rs("weight_scale") And rs("weight_scale") = "L" Then
						TotalGrossWeight = TotalGrossWeight + cdbl(rs("total_gross_weight")) * 2.20462262
						TotalChargeWeight = TotalChargeWeight + cdbl(rs("total_chargeable_weight")) * 2.20462262
					Else
						TotalGrossWeight = TotalGrossWeight + cdbl(rs("total_gross_weight"))
						TotalChargeWeight = TotalChargeWeight + cdbl(rs("total_chargeable_weight"))	
					End If
				End If
			End If

			if Not vMasterOnly="Y" then
				Description=rs("manifest_desc")
				ArrivalDept=rs("export_date")
			end If
			ArrivalDept = CHECK_EX_DATE( vMAWB, ArrivalDept )
			OriginDest=rs("dep_Airport_code") & "/" & rs("to_1")
			Origin=rs("dep_Airport_code")
			Dest=rs("to_1")
			EntryDate=""
			Carrier=rs("Flight_Date_1")
			OriginPort=rs("DEP_AIRPORT_CODE")
			DestPort=rs("To_1")
			MAWB_NUM=rs("MAWB_NUM")
			Airline=Mid(MAWB_NUM,1,3)
			Weight_Prepaid=rs("PPO_1")
			Weight_Collect=rs("COLL_1")
			rs.MoveNext
		Loop
		rs.Close		
		'--GETTING AIRPORT CODES TO BE FILLED IN THE INVOICE -----------------
		if Not vMAWB = "" then
		SQL= "select Origin_Port_Id,Dest_Port_Id from mawb_number where elt_account_number = " & elt_account_number & " and mawb_no='" & vMAWB & "'"
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, adLockReadOnly, adCmdText
		Set rs.activeConnection = Nothing
			if Not rs.EOF then
				OriginDest=rs("Origin_Port_Id") & "/" & rs("Dest_Port_Id")
				Origin=rs("Origin_Port_Id")
				Dest=rs("Dest_Port_Id")
			end if
		rs.close
		end if
		'--END OF GETTING AIRPORT CODES TO BE FILLED IN THE INVOICE-----------------
		
		TotalPieces=TotalPieces & "PCS"
		TotalGrossWeight = TotalGrossWeight & vWeightScale
		TotalChargeWeight = TotalChargeWeight & vWeightScale		
		
		'-END OF GETTING INVOICE RELATED INFORMATION  FROM AIR MAWB/HAWBS 
		
	elseif vAO="AIR" and vInvoiceType="Colodee" Then
	
	elseif Not vInvoiceType="Colodee" then	
	
	'-GETTING INVOICE RELATED GENERAL INFORMATION  FROM OCEAN MBOL/HBOLS 
		if vMasterOnly="Y" then
			SQL= "select * from mbol_master where elt_account_number = " & elt_account_number & " and booking_num='" & vBookingNum & "'"
		else
			if vInvoiceType="Shipper" then
				SQL= "select * from hbol_master where elt_account_number = " & elt_account_number & " and hbol_num='" & vHBOL & "'"
			else
				SQL= "select * from hbol_master where elt_account_number = " & elt_account_number & " and booking_num='" & vBookingNum & "' and agent_no=" & vAgent
			end if			
		end if
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, adLockReadOnly, adCmdText
		Set rs.activeConnection = Nothing		
		Do While Not rs.EOF
			if vInvoiceType="Shipper" then
				vCustomerInfo=rs("Shipper_Info")
				vCustomer=rs("Shipper_Name")
				vShipper=rs("Shipper_Name")
				vConsignee=rs("consignee_Name")
			else
				vCustomerInfo=rs("Agent_Info")
				vCustomer=rs("Agent_Name")
				vShipper=rs("Shipper_Name") & "/" & vShipper
				vConsignee=rs("consignee_Name") & "/" & vConsignee
			end if
			
			TotalPieces=TotalPieces+cint(rs("pieces"))
			
			'// Weight Scale Logic Change
            vWeightScale = rs("scale")
			
			If vWeightScale="K" Or IsNull(vWeightScale) or vWeightScale="" Then
			    '// vWeightScale="Kg"
			    TotalGrossWeight = TotalGrossWeight + cdbl(rs("gross_weight")) * 2.20462262
			    TotalChargeWeight = TotalGrossWeight	
			Else
			    '// vWeightScale="Lb"
			    TotalGrossWeight = TotalGrossWeight + cdbl(rs("gross_weight"))
			    TotalChargeWeight = TotalGrossWeight	
			End If
			
			vWeightScale="Lb"
			
			Description=rs("desc3")
			OriginDest=rs("loading_port") & "/" & rs("unloading_port")
			Origin=rs("loading_port")
			Dest=rs("unloading_port")
			EntryDate=rs("tran_date")
             dim EntrArry
            if EntryDate <> null Or EntryDate <> "" then 
                EntrArry = Split(EntryDate)
                EntryDate=EntrArry(0)
            end if 
			Carrier=rs("export_carrier")
			OriginPort=rs("loading_port")
			DestPort=rs("unloading_port")
			MAWB_NUM=rs("MBOL_NUM")
			vHAWB=vHBOL
			WeightCP=rs("weight_cp")
			if Not vMasterOnly="Y" then
				Description=rs("manifest_desc")
			end if
			ArrivalDept = CHECK_EX_DATE_OCEAN( vMAWB, ArrivalDept )			
			rs.MoveNext
		Loop
		rs.Close
		TotalPieces=TotalPieces & "PCS"
		TotalGrossWeight = TotalGrossWeight & vWeightScale
		TotalChargeWeight = TotalChargeWeight & vWeightScale
	end if
	tIndex=0
	cIndex=0	
	'-END OF GETTING INVOICE RELATED GENERAL INFORMATION  FROM OCEAN MBOL/HBOLS
	
	'-GETTING INVOICE RELATED WEIGHT CHARGE INFORMATION  FROM AIR MAWB/HAWBS	

	if vAO="AIR" And Not vInvoiceType="Colodee" then		
		if Not vMasterOnly="Y" then'------------------------profit share is only for the <not masteronly>
			if vInvoiceType="Shipper" then
				SQL= "select HAWB_NUM,airline_vendor_num,shipper_account_number," _
				    & "Total_Weight_Charge_HAWB as amount,master_chargeable_weight," _
				    & "Total_Chargeable_Weight as cw from hawb_master " _
				    & "where ((( isnull(is_master,'N')='Y' or isnull(is_sub,'N')='Y') " _
				    & "and isnull(is_invoice_queued,'Y') <> 'N') OR (( isnull(is_master,'N')='N' " _
				    & "and isnull(is_sub,'N')='N'))) and Total_Weight_Charge_HAWB > 0 and " _
				    & "elt_account_number = " & elt_account_number & " and hawb_num='" _
				    & vHAWB & "' And PPO_1='Y'"
			else
				if Not COLO="Y" then
					SQL= "select Total_Weight_Charge_HAWB as amount,adjusted_weight as aw," _
					    & "Total_Chargeable_Weight  as cw,agent_profit,hawb_num,airline_vendor_num," _
					    & "shipper_account_number,agent_profit,agent_profit_share,other_agent_profit_carrier,"_
					    & "other_agent_profit_agent from HAWB_master " _
					    & "where (((isnull(is_master,'N')='Y' or isnull(is_sub,'N')='Y') " _
					    & "and isnull(is_invoice_queued,'Y') <> 'N') OR (( isnull(is_master,'N')='N' " _
					    & "and isnull(is_sub,'N')='N'))) and Total_Weight_Charge_HAWB > 0 and  elt_account_number = " _
					    & elt_account_number & " and MAWB_NUM='" & vMAWB & "' and (agent_no=" & vAgent _
					    & " or (is_dome='Y' AND hawb_num='" & vHAWB & "')) and COLL_1='Y' order by HAWB_NUM"
					    
				end if
			end if
		else
			if vInvoiceType="Shipper" then
				SQL= "select airline_vendor_num,shipper_account_number, Total_Weight_Charge_HAWB as amount, Total_Chargeable_Weight as cw from mawb_master where elt_account_number = " & elt_account_number & " and mawb_num='" & vMAWB & "' And PPO_1='Y'"
			else
				SQL= "select airline_vendor_num,shipper_account_number, Total_Weight_Charge_HAWB as amount, Total_Chargeable_Weight as cw from mawb_master where elt_account_number = " & elt_account_number & " and mawb_num='" & vMAWB & "' And COLL_1='Y'"
			end if
		end if     
		
		'// response.Write("--AIR WEIGHT CHARGE--" &SQL&"<BR>")
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, adLockReadOnly, adCmdText
		Set rs.activeConnection = Nothing
		AgentProfit=0		
		hIndex=0
		Do While Not rs.EOF
			aItemNo(hIndex)=GetSQLResult("SELECT default_air_charge_item FROM user_profile WHERE elt_account_number=" & elt_account_number,null)
			if Not vMasterOnly="Y" then
				aDesc(tIndex)="Air Freight " & rs("HAWB_NUM")
				aHAWB(hIndex)=rs("HAWB_NUM")
				aHAWBURL(hIndex)="../air_export/new_edit_hawbr.asp?HAWB=" & rs("HAWB_NUM")
				hIndex=hIndex+1
			else
				aDesc(tIndex)="Air Freight "
			end if
			aAmount(tIndex)=Cdbl(rs("amount"))			
			cw=Cdbl(rs("cw"))			
			vShipperAcct=cLng(rs("shipper_account_number"))			
			if vInvoiceType="Agent" And Not vMasterOnly="Y" then			
				AgentProfit=AgentProfit+cDbl(rs("agent_profit"))
				AgentProfit=AgentProfit+cDbl(rs("other_agent_profit_agent"))
				AgentProfit=AgentProfit+cDbl(rs("other_agent_profit_carrier"))
			end if
			tIndex=tIndex+1
			rs.MoveNext
		Loop
		rs.Close
	'-END OF GETTING INVOICE RELATED WEIGHT CHARGE INFORMATION  FROM AIR MAWB/HAWBS
	
	'-CALCULATING AIR FREIGHT COST FOR ACCOUNTING 
		if vMasterAgent="Y" then
			SQL= "select total_chargeable_weight as cw "
			SQL=SQL & " from MAWB_master "
			SQL=SQL & " where elt_account_number = " & elt_account_number
			SQL=SQL & " and MAWB_NUM='" & vMAWB & "'"
			rs.CursorLocation = adUseClient
			rs.Open SQL, eltConn, adOpenForwardOnly, adLockReadOnly, adCmdText
			Set rs.activeConnection = Nothing
			if not rs.EOF and Not IsNull(rs("cw"))then
				cw=cdbl(rs("cw"))
			else
				cw=0
			end if
			rs.Close
			if Airline = "" then
				Airline=Mid(vMAWB,1,3)
			end if			
			DIM vUnit, vWeight
			vWeight=cw			
			dim rFLAG
			rFLAG=true  
			Dim minApplied 
			minApplied=false			
			if vWeightScale="Kg" then 
				vUnit="K"
				origUnit="K"
			else 
				vUnit="L"
				origUnit="L"
			end if			
			SQL="select weight_break,rate from all_rate_table where elt_account_number=" & elt_account_number
			SQL=SQL & " and rate_type=3"
			SQL=SQL & " and Airline=" & Airline
			SQL=SQL & " and origin_port='" & OriginPort & "'"
			SQL=SQL & " and dest_port='" & DestPort & "'"
			SQL=SQL & " and kg_lb='"&vUnit&"'"
			SQL=SQL & " order by weight_break desc" 			
			rs.CursorLocation = adUseClient
			rs.Open SQL, eltConn, adOpenForwardOnly, adLockReadOnly, adCmdText
			Set rs.activeConnection = Nothing			
			if rs.EOF or rs.BOF then
				rs.close		
				if vUnit ="K" then 
					vUnit="L" 
					vWeight = vWeight * 2.20462262      
				else 
					vUnit="K"
					vWeight =vWeight * 0.4535924
				end if
				SQL="select weight_break,rate from all_rate_table where elt_account_number=" & elt_account_number
				SQL=SQL & " and rate_type=3"
				SQL=SQL & " and Airline=" & Airline
				SQL=SQL & " and origin_port='" & OriginPort & "'"
				SQL=SQL & " and dest_port='" & DestPort & "'"
				SQL=SQL & " and kg_lb='"&vUnit&"'"
				SQL=SQL & " order by weight_break desc" ' desc is by Jay Noh 12/27/06			
				rs.CursorLocation = adUseClient
				rs.Open SQL, eltConn, adOpenForwardOnly, adLockReadOnly, adCmdText
				Set rs.activeConnection = Nothing
			end if 
			do while not rs.EOF
				wb1=cdbl(rs("weight_break"))
				TempRate1=cdbl(rs("rate"))
				if wb1=0 then MinCharge1=TempRate1
				if vWeight >= wb1 then
				  if rFLAG = true then 
					If wb=0 then minApplied=true
					rate1=TempRate1
					rFLAG=false
				  end if 
				end if
				rs.MoveNext
			loop
			rs.Close
			if rate1="" then
				rate1=TempRate1
			end If
			if origUnit ="K" and vUnit="L" then 
				rate1 = rate1 * 2.20462262
			else 
			   if origUnit ="L" and vUnit="K" then 
				rate1 =rate1 /2.20462262  
			   end if
			end if 
			cost=rate1*vWeight
			if ( minApplied=True Or cost < MinCharge1 ) then 
				cost=MinCharge1
			end if 
			aRealCost(0)=cost			
		end if	
		'-END OF CALCULATING AIR FREIGHT COST FOR ACCOUNTING FOR AIR 
		
	elseif Not vInvoiceType="Colodee" then		
		'-GETTING INVOICE RELATED WEIGHT CHARGE INFORMATION  FROM OCEAN MBOL/HBOLS
		if Not vMasterOnly="Y" then
			if vInvoiceType="Shipper" then
				SQL= "select hbol_num,shipper_acct_num, Total_Weight_Charge  as amount from hbol_master where  elt_account_number = " & elt_account_number & " and hbol_num='" & vHBOL & "' and weight_cp='P'"
			else
				SQL= "select Total_Weight_Charge as amount,hbol_num,shipper_acct_num "
				SQL=SQL & " from hbol_master "
				SQL=SQL & " where ((( isnull(is_master,'N')='Y' or isnull(is_sub,'N')='Y') and isnull(is_invoice_queued,'Y') <> 'N') OR (( isnull(is_master,'N')='N' and isnull(is_sub,'N')='N'))) and elt_account_number = " & elt_account_number
				SQL=SQL & " and booking_num='" & vBookingNum & "'"
				SQL=SQL & " and agent_no=" & vAgent & " and weight_cp='C' order by hbol_num"
			end if	
		else
			if vInvoiceType="Shipper" then
				SQL= "select mbol_num,''as hbol_num,shipper_acct_num,Total_Weight_Charge as amount from mbol_master where elt_account_number = " & elt_account_number & " and booking_num='" & vBookingNum & "' and weight_cp='P'"
			else
				SQL= "select Total_Weight_Charge as amount,mbol_num,shipper_acct_num,''as hbol_num "
				SQL=SQL & " from mbol_master "
				SQL=SQL & " where elt_account_number = " & elt_account_number
				SQL=SQL & " and booking_num='" & vBookingNum & "'"
				SQL=SQL & " and agent_acct_num=" & vAgent & " and weight_cp='C' order by mbol_num"
			end if	
		end if
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, adLockReadOnly, adCmdText
		Set rs.activeConnection = Nothing
		AgentProfit=0
		Set rs1 = Server.CreateObject("ADODB.Recordset")
		hIndex=0
		Do While Not rs.EOF
			aItemNo(tIndex)=GetSQLResult("SELECT default_ocean_charge_item FROM user_profile WHERE elt_account_number=" & elt_account_number,null)
			aHAWB(hIndex)=rs("hbol_num")
			aHAWBURL(hIndex)="../ocean_export/new_edit_hbolr.asp?HBOL=" & rs("hbol_num")
			hIndex=hIndex+1
			if Not vMasterOnly="Y" then
				aDesc(tIndex)="Ocean Freight HBOL# " & rs("hbol_num")
			else
				aDesc(tIndex)="Ocean Freight MBOL# " & rs("mbol_num")			
			end if	
			aAmount(tIndex)=Cdbl(rs("amount"))			
			vShipperAcct=cLng(rs("shipper_acct_num"))
			tIndex=tIndex+1
			rs.MoveNext
		Loop
		rs.Close
	end if
'-END OF GETTING INVOICE RELATED WEIGHT CHARGE INFORMATION  FROM OCEAN MBOL/HBOLS

'-GETTING INVOICE RELATED OTHER CHARGE INFORMATION  FROM AIR MAWB/HAWBS
	if vAO="AIR" And Not vInvoiceType="Colodee" then
		if Not vMasterOnly="Y" then
			
			if vInvoiceType="Shipper" then
				SQL= "select * from hawb_other_charge where elt_account_number = " & elt_account_number & " and hawb_num='" & vHAWB & "' and Coll_Prepaid='P' order by tran_no"
			else
				if Not COLO="Y" then
					SQL= "select a.* from hawb_other_charge a,hawb_master b " _
					    & " where a.elt_account_number=b.elt_account_number " _
					    & " and b.elt_account_number = " & elt_account_number _
					    & " and a.hawb_num=b.hawb_num  and b.MAWB_NUM='" & vMAWB _
					    & "' and (b.agent_no=" & vAgent _
					    & " or (b.is_dome='Y' AND b.hawb_num='" & vHAWB _
					    & "')) and (a.Coll_Prepaid='C' or (b.colo='Y' and b.colo_pay='C')) " _
					    & "order by a.HAWB_NUM,a.tran_no "
				end if
			end if
		else
			if vInvoiceType="Shipper" then
				SQL= "select * from mawb_other_charge where elt_account_number = " & elt_account_number & " and mawb_num='" & vMAWB & "' and Coll_Prepaid='P' order by tran_no"
			else
				SQL= "select * from mawb_other_charge where elt_account_number = " & elt_account_number & " and mawb_num='" & vMAWB & "' and Coll_Prepaid='C' order by tran_no"
			end if
		end if
        
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, adLockReadOnly, adCmdText
		Set rs.activeConnection = Nothing
		
		Do While Not rs.EOF

			aItemNo(tIndex)=rs("charge_code")
			
			if Not vMasterOnly="Y" then
				'// aDesc(tIndex)=aItemDesc(aItemNo(tIndex)) & "  " & rs("HAWB_NUM")
				aDesc(tIndex) = GetSQLResult("SELECT item_desc FROM item_charge WHERE elt_account_number=" & elt_account_number & " AND item_no=" & aItemNo(tIndex), Null) & "  " & rs("HAWB_NUM")
				aAmount(tIndex)=rs("Amt_HAWB")
			else
			    '// aDesc(tIndex)=aItemDesc(aItemNo(tIndex))
				aDesc(tIndex) = GetSQLResult("SELECT item_desc FROM item_charge WHERE elt_account_number=" & elt_account_number & " AND item_no=" & aItemNo(tIndex), Null)
				aAmount(tIndex)=rs("Amt_MAWB")
			end if
			if aAmount(tIndex)="" then aAmount(tIndex)=0
			aRealCost(cIndex)=rs("cost_amt")
			
			if aRealCost(cIndex)="" or IsNull(aRealCost(cIndex)) then
				aRealCost(cIndex)=0
			else
				aRealCost(cIndex)=cDbl(aRealCost(cIndex))
			end if
'			if aRealCost(cIndex)>0 then // by iMoon
			if aRealCost(cIndex)<>0 then
				aCostItemNo(cIndex)=rs("charge_code")
				'// aCostDesc(cIndex)=aItemDesc(aCostItemNo(cIndex))
				aCostDesc(cIndex) = GetSQLResult("SELECT item_desc FROM item_charge WHERE elt_account_number=" & elt_account_number & " AND item_no=" & aCostItemNo(cIndex), Null)
                
   
                if vendor_num = null OR vendor_num="" then
                    aVendor(cIndex)= CLng(0)
                else
				    aVendor(cIndex)= CLng(rs("vendor_num"))
                end if
				cIndex=cIndex+1
			end if
			tIndex=tIndex+1
			rs.MoveNext
		Loop
		rs.Close
		
		If Not vMasterOnly="Y" Then
		    SQL = "SELECT a.*,b.item_name,b.item_desc FROM hawb_other_cost a LEFT OUTER JOIN item_cost b ON " _
		        & "(a.elt_account_number=b.elt_account_number AND a.item_no=b.item_no) " _
		        & "WHERE a.elt_account_number=" & elt_account_number _
		        & " AND a.hawb_num=N'" & vHAWB & "'"
		Else
		    SQL = "SELECT a.*,b.item_name,b.item_desc FROM mawb_other_cost a LEFT OUTER JOIN item_cost b ON " _
		        & "(a.elt_account_number=b.elt_account_number AND a.item_no=b.item_no) " _
		        & "WHERE a.elt_account_number=" & elt_account_number _
		        & " AND a.mawb_num=N'" & vMAWB & "'"
		End If
		
        rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, adLockReadOnly, adCmdText
		Set rs.activeConnection = Nothing
        Do While Not rs.EOF
		    aCostItemNo(cIndex) = rs("item_no")
		    aCostDesc(cIndex) = rs("item_desc")
		    aCostItemName(cIndex) = rs("item_name")
		    aRefNo(cIndex) = ""
		    aRealCost(cIndex) = rs("cost_amt")
		    aVendor(cIndex) = CLng(rs("vendor_no"))
		    rs.MoveNext
		    cIndex=cIndex+1
	    Loop
	    rs.Close
	'-END OF GETTING INVOICE RELATED OTHER  CHARGE INFORMATION  FROM AIR MAWB/HAWBS
	
	'-GETTING INVOICE RELATED OTHER  CHARGE INFORMATION  FROM OCEAN MBOL/HBOLS
	elseif Not vInvoiceType="Colodee" then		
		if Not vMasterOnly="Y" then
			if vInvoiceType="Shipper" then
				SQL= "select * from hbol_other_charge where elt_account_number = " & elt_account_number & " and hbol_num='" & vHBOL & "' and Coll_Prepaid='P' order by tran_no"
			else
				SQL= "select a.* from hbol_other_charge a,hbol_master b "
				SQL=SQL & " where a.elt_account_number=b.elt_account_number "
				SQL=SQL & " and b.elt_account_number = " & elt_account_number
				SQL=SQL & " and a.hbol_num=b.hbol_num "
				SQL=SQL & " and a.Coll_Prepaid='C' and b.booking_num='" & vBookingNum & "' and b.agent_no=" & vAgent & " order by a.hbol_num,a.tran_no "
			end if
		else
			if vInvoiceType="Shipper" then
				SQL= "select * from mbol_other_charge where elt_account_number = " & elt_account_number & " and booking_num='" & vBookingNum & "' and Coll_Prepaid='P' order by tran_no"
			else
				SQL= "select * from mbol_other_charge where elt_account_number = " & elt_account_number & " and booking_num='" & vBookingNum & "' and Coll_Prepaid='C' order by tran_no"
			end if						
		end if
		
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, adLockReadOnly, adCmdText
		Set rs.activeConnection = Nothing
		Do While Not rs.EOF
			aItemNo(tIndex)=rs("charge_code")
			
			if Not vMasterOnly="Y" then
				'// aDesc(tIndex)=aItemDesc(aItemNo(tIndex)) & "HBOL# " & rs("hbol_num")
				aDesc(tIndex) = GetSQLResult("SELECT item_desc FROM item_charge WHERE elt_account_number=" & elt_account_number & " AND item_no=" & aItemNo(tIndex), Null) & " HBOL# " & rs("hbol_num")
			else
				'// aDesc(tIndex) = aItemDesc(aItemNo(tIndex)) & "MBOL# " & rs("mbol_num")
				aDesc(tIndex) = GetSQLResult("SELECT item_desc FROM item_charge WHERE elt_account_number=" & elt_account_number & " AND item_no=" & aItemNo(tIndex), Null) & " MBOL# " & rs("mbol_num")
			end if
			aAmount(tIndex)=rs("charge_amt")
			if aAmount(tIndex)="" then aAmount(tIndex)=0
			
			aRealCost(tIndex)=rs("cost_amt")
			if aRealCost(cIndex)="" or IsNULL(rs("cost_amt")) then
				aRealCost(cIndex)=0
			else
				aRealCost(cIndex)=cDbl(rs("cost_amt"))
			end if
			if aRealCost(cIndex)<>0 then
				aCostItemNo(cIndex)=rs("charge_code")
				'// aCostDesc(cIndex)=aItemDesc(aCostItemNo(cIndex))
				aCostDesc(cIndex) = GetSQLResult("SELECT item_desc FROM item_charge WHERE elt_account_number=" & elt_account_number & " AND item_no=" & aCostItemNo(cIndex), Null) & " MBOL# " & rs("mbol_num")
				aVendor(tIndex)= CLng(rs("vendor_num"))
				cIndex=cIndex+1
			end if
			tIndex=tIndex+1
			rs.MoveNext
		Loop
		rs.Close
		
		If Not vMasterOnly="Y" Then
		    SQL = "SELECT a.*,b.item_name,b.item_desc FROM hbol_other_cost a LEFT OUTER JOIN item_cost b ON " _
		        & "(a.elt_account_number=b.elt_account_number AND a.item_no=b.item_no) " _
		        & "WHERE a.elt_account_number=" & elt_account_number _
		        & " AND a.hbol_num=N'" & vHBOL & "'"
		Else
		    SQL = "SELECT a.*,b.item_name,b.item_desc FROM mbol_other_cost a LEFT OUTER JOIN item_cost b ON " _
		        & "(a.elt_account_number=b.elt_account_number AND a.item_no=b.item_no) " _
		        & "WHERE a.elt_account_number=" & elt_account_number _
		        & " AND a.booking_num=N'" & vBookingNum & "'"
		End If
		
        rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, adLockReadOnly, adCmdText
		Set rs.activeConnection = Nothing
        Do While Not rs.EOF
		    aCostItemNo(cIndex) = rs("item_no")
		    aCostDesc(cIndex) = rs("item_desc")
		    aCostItemName(cIndex) = rs("item_name")
		    aRefNo(cIndex) = ""
		    aRealCost(cIndex) = rs("cost_amt")
		    aVendor(cIndex) = CLng(rs("vendor_no"))
		    rs.MoveNext
		    cIndex=cIndex+1
	    Loop
	    rs.Close
	end if
	
	'-END OF GETTING INVOICE RELATED OTHER  CHARGE INFORMATION  FROM OCEAN MBOL/HBOLS
		
	SubTotal=0
	TotalCharge=0
	TotalCost=0
	for i=0 to tIndex-1
		TotalCharge=TotalCharge+Cdbl(aAmount(i))
	next
	for i=0 to cIndex-1
		TotalCost=TotalCost + cdbl(aRealCost(i))
	next
	SubTotal=TotalCharge
	if SaleTax="" then SaleTax=0
	if AgentProfit="" then AgentProfit=0
	TotalAmount=SubTotal+SaleTax-AgentProfit		
end if

'@END OF MAIN LOGIC CASE 2:CREATING NEW INVOICE ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

'@MAIN LOGIC CASE 3:EDTING INVOICE '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

if editInvoice="yes" then
	InvoiceNo = Request.QueryString("InvoiceNo")
	if InvoiceNo="" then
		InvoiceNo=0
		InvoiceDate = Date()
	end If
	Session("InvoiceNo") = InvoiceNo
	
	if Not Branch="" then
		if UserRight=9 then
			SQL= "select * from Invoice where elt_account_number = " & Branch & " and invoice_no=" & InvoiceNo
		else
			ErrMsg="You don't have the privilege to access this page!"
			Response.Redirect("../extra/err_msg.asp?ErrMSG=" & ErrMsg)
		end if
	else
		SQL= "select * from Invoice where elt_account_number = " & elt_account_number & " and invoice_no=" & InvoiceNo
	end if	
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, adLockReadOnly, adCmdText
	Set rs.activeConnection = Nothing
	If Not rs.EOF Then
		
		'// check if credit note
		
		If CDbl(checkBlank(rs("amount_charged"),0)) < 0 Then
		    Response.Write("<script> window.location.href='./edit_credit_note.asp?edit=yes&InvoiceNo=" & InvoiceNo & "&WindowName=' + window.name; </script>")
		End If
		
		vAO=rs("air_ocean")
		
		If vAO="O" Then
			vAO="OCEAN"
	    End If
	    
		If vAO = "A" Then
			vAO="AIR"
		End if
		
		vRemarks=rs("remarks")
		vInMemo=rs("in_memo")
		InvoiceDate=rs("Invoice_Date")
		vTerm = rs("term_curr")
		RefNo=rs("ref_no")
		vFileNo=rs("ref_no_Our")
		vCustomerInfo=rs("Customer_Info")
		TotalPieces=rs("Total_Pieces")
		TotalGrossWeight=rs("Total_Gross_Weight")
		TotalChargeWeight=rs("Total_Charge_Weight")
		Description=rs("Description")
		OriginDest=rs("Origin_Dest")
		Origin=rs("origin")
		Dest=rs("dest")
		vOrgAcct=rs("Customer_Number")
		vCustomer=rs("Customer_Name")
		vOrgName=rs("Customer_Name")
		vShipper=rs("shipper")
		vConsignee=rs("consignee")
		EntryNo=rs("Entry_No")
		EntryDate=rs("Entry_Date")
		Carrier=rs("Carrier")
		ArrivalDept=rs("Arrival_Dept")
		MAWB_NUM=rs("MAWB_NUM")
		vHAWB=rs("HAWB_NUM")
		SubTotal=rs("SubTotal")
		SaleTax=rs("Sale_Tax")
		AgentProfit=rs("Agent_Profit")
		TotalAmount=rs("amount_charged")
		TotalCost=rs("total_cost")
		MasterInvoiceNo = rs("master_invoice_no")
		vInvoiceAccessType = rs("invoice_type")

	else
%>

<script language='JavaScript'>    alert('Could not find the Invoice No <%=InvoiceNo %>'); history.go(-1);</script>

<%
	End If
	rs.Close
	
	Call GetAllSubInvoices()
	
	if Not Branch="" then
		SQL= "select * from invoice_charge_item where elt_account_number = " & Branch & " and invoice_no=" & InvoiceNo
	else
		SQL= "select * from invoice_charge_item where elt_account_number = " & elt_account_number & " and invoice_no=" & InvoiceNo
	end if
	
	SQL= SQL & " order by item_id"
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, adLockReadOnly, adCmdText
	Set rs.activeConnection = Nothing
	tIndex=0
	TotalCharge=0
	
	Do While Not rs.EOF
		aItemNo(tIndex)=rs("item_no")
		aDesc(tIndex)=rs("item_desc")
		aAmount(tIndex)=cDBL(rs("charge_amount"))
		TotalCharge=TotalCharge+aAmount(tIndex)
		rs.MoveNext
		tIndex=tIndex+1
	Loop
	
	rs.Close
	
	if Not Branch="" then
		SQL= "select * from invoice_cost_item where elt_account_number = " & Branch & " and invoice_no=" & InvoiceNo
	else
		SQL= "select * from invoice_cost_item where elt_account_number = " & elt_account_number & " and invoice_no=" & InvoiceNo
	end if
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, adLockReadOnly, adCmdText
	Set rs.activeConnection = Nothing
	cIndex=0
	Do While Not rs.EOF
		aCostItemNo(cIndex)=rs("item_no")
		aCostDesc(cIndex)=rs("item_desc")
		aRefNo(cIndex)=rs("ref_no")
		aRealCost(cIndex)=rs("cost_amount")
		aVendor(cIndex)=CLng(rs("Vendor_no"))
		rs.MoveNext
		cIndex=cIndex+1
	Loop
	rs.Close

	for j=0 to cIndex - 1
		if Not Branch="" then
			SQL = "select bill_number from bill_detail where elt_account_number = "&Branch&" and invoice_no=" & InvoiceNo &_
			" and vendor_number="&aVendor(j)&_
			" and item_no='"&aCostItemNo(j)&"'"&_
			" and ( item_amt="&aRealCost(j) & " or item_amt=" & -1*CDbl(aRealCost(j)) & ") and bill_number <> 0"
		else
			SQL = "select bill_number from bill_detail where elt_account_number = "&elt_account_number&" and invoice_no=" & InvoiceNo &_
			" and vendor_number="&aVendor(j)&_
			" and item_no='"&aCostItemNo(j)&"'"&_
			" and ( item_amt="&aRealCost(j) & " or item_amt=" & -1*CDbl(aRealCost(j)) & ") and bill_number <> 0"
		end if
		
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, adLockReadOnly, adCmdText
		Set rs.activeConnection = Nothing
	
		if not rs.eof then
			aAPLock(j) = rs(0).value
		else
			aAPLock(j) = ""			
		end if
		rs.close()	
	next	
	SQL= "select hawb_num,hawb_url from invoice_hawb where elt_account_number = " & elt_account_number & " and invoice_no=" & InvoiceNo
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, adLockReadOnly, adCmdText
	Set rs.activeConnection = Nothing
	hIndex=0
	Do While Not rs.EOF
		aHAWB(hIndex)=rs("hawb_num")
		aHAWBURL(hIndex)=rs("hawb_url")
		rs.MoveNext
		hIndex=hIndex+1
	Loop
	rs.Close	
	igvHAWB = aHAWB(0)	
	
elseif BlankInvoice="yes" then
		tIndex = 4
		cIndex = 4
		InvoiceNo = ""
		InvoiceDate = Date()
end If
'@MAIN LOGIC CASE 3:END OF EDTING INVOICE '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

'@MAIN LOGIC CASE 4:CREATING SUBINVOICE '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

if CreateSub="yes" then
	
	if Not Branch="" then
		if UserRight=9 then
			SQL= "select * from Invoice where elt_account_number = " & Branch & " and invoice_no=" & MasterInvoiceNo
		else
			ErrMsg="You don't have the privilege to access this page!"
			Response.Redirect("../extra/err_msg.asp?ErrMSG=" & ErrMsg)
		end if
	else
		SQL= "select * from Invoice where elt_account_number = " & elt_account_number & " and invoice_no=" & MasterInvoiceNo
	end if	
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, adLockReadOnly, adCmdText
	Set rs.activeConnection = Nothing
	If Not rs.EOF Then
		
		vAO=rs("air_ocean")
		If vAO="O" Then
		 	vAO="OCEAN"
		Else
		 	vAO="AIR"
		End If
		
		InvoiceDate=rs("Invoice_Date")
		vTerm = rs("term_curr")
		RefNo=rs("ref_no")
		vFileNo=rs("ref_no_Our")
		vCustomerInfo=rs("Customer_Info")
		TotalPieces=rs("Total_Pieces")
		TotalGrossWeight=rs("Total_Gross_Weight")
		TotalChargeWeight=rs("Total_Charge_Weight")
		Description=rs("Description")
		OriginDest=rs("Origin_Dest")
		Origin=rs("origin")
		Dest=rs("dest")
		vOrgAcct=rs("Customer_Number")
		vCustomer=rs("Customer_Name")
		vOrgName=rs("Customer_Name")
		vShipper=rs("shipper")
		vConsignee=rs("consignee")
		EntryNo=rs("Entry_No")
		EntryDate=rs("Entry_Date")
		Carrier=rs("Carrier")
		ArrivalDept=rs("Arrival_Dept")
		MAWB_NUM=rs("MAWB_NUM")
		vHAWB=rs("HAWB_NUM")
		vInvoiceAccessType = rs("invoice_type")
    End If
	rs.Close
	
End If

'@MAIN LOGIC CASE 4:END OF CREATING SUBINVOICE '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

'// Call get_vendor_list

Call page_load

DIM igShipperAcct, igConsigneeAcct	
igShipperAcct = ""
igConsigneeAcct = ""	
if vAC = "AIR" then
	SQL= "select shipper_acct_num,consignee_acct_num from mawb_master where elt_account_number = " & elt_account_number & " and mawb_num='" & vMAWB & "'"
	rs.Open SQL, eltConn, adOpenForwardOnly, adLockReadOnly, adCmdText
	if Not rs.EOF then
		igShipperAcct=rs("shipper_acct_num")
		igConsigneeAcct=rs("consignee_acct_num")
	end if
else
	SQL= "select shipper_acct_num,consignee_acct_num from mbol_master where elt_account_number = " & elt_account_number & " and mbol_num='" & vMAWB & "'"
	rs.Open SQL, eltConn, adOpenForwardOnly, adLockReadOnly, adCmdText
	if Not rs.EOF then
		igShipperAcct=rs("shipper_acct_num")
		igConsigneeAcct=rs("consignee_acct_num")
	end if
end if

if igShipperAcct="" then igShipperAcct = 0
if igConsigneeAcct="" then igConsigneeAcct = 0

rs.Close

Set rs=Nothing
Set rs1=Nothing
Set rs3=Nothing

'// By ig 2006.6.14 Multi HAWB -> Remarks

if vInvoice = "" then
	if Save="yes" or AddItem ="yes" or AddCostItem ="yes" or Delete="yes" or DeleteCost="yes" or qCustomer="yes" or lstHAWB="yes" or editInvoice="yes" then
	Else
		CALL MAKE_HAWB_REMARK
	end if	
end if

query_string=Request.ServerVariables("QUERY_STRING")
vPrintPort=invoicePort

PrintINV=Request.QueryString("PrintINV")

If checkBlank(invoiceNo,0) <> 0 Then
	Call check_lock( invoiceNo )
End If

%>
<%

    Sub get_vendor_list
    
        Dim tempTable,SQL,rs

		Set vendor_list = Server.CreateObject("System.Collections.ArrayList")
		Set tempTable = Server.CreateObject("System.Collections.HashTable")
		Set rs = Server.CreateObject("ADODB.Recordset")

        SQL = "SELECT org_account_number,ISNULL(dba_name,'') as dba_name," _
            & "RTRIM(ISNULL(class_code,'')) as class_code FROM organization " _
            & "WHERE elt_account_number = "& elt_account_number _
			& " and isnull(dba_name,'') <> '' and (is_vendor = 'Y' or z_is_trucker = 'Y' or z_is_govt = 'Y' or z_is_special = 'Y' or z_is_broker='Y' or z_is_warehousing='Y' or is_agent='Y') order by dba_name"

		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, adLockReadOnly, adCmdText
		Set rs.activeConnection = Nothing
        Set tempTable = Server.CreateObject("System.Collections.HashTable")

		tempTable.Add "acct", "0"
		tempTable.Add "name", "Select One"
		vendor_list.Add tempTable

        Do While Not rs.EOF and NOT rs.bof
            Set tempTable = Server.CreateObject("System.Collections.HashTable")
            tempTable.Add "acct", rs("org_account_number").value
            If rs("class_code").value <> "" Then
                tempTable.Add "name", RemoveQuotations(rs("dba_name").value & "[" & rs("class_code").value) & "]"
            Else
                tempTable.Add "name", RemoveQuotations(rs("dba_name").value)
            End If
            vendor_list.Add tempTable
		    rs.MoveNext
	    Loop
        rs.Close
		Set rs = Nothing		
    End Sub
%>
<%
Sub check_lock(invoiceNo)
    DIM rs,SQL
	SQL = "select isnull(lock_ar,'') as lock_ar,isnull(lock_ap,'') as lock_ap from invoice where elt_account_number="&elt_account_number&" and invoice_no="&invoiceNo 
	Set rs = eltConn.execute(SQL)
	if NOT rs.eof then
		vvvLockAR = rs(0)
		vvvLockAP = rs(1)
	end if
	set rs = nothing
End Sub
%>
<%
function get_default_freight_charge_item(iType)
    Dim tmprs, tmpSQL
    DIM defaultF
    '// check if default ocean freight charage is in the database 
	
	if iType = "O" then
		tmpSQL= "select isnull(default_ocean_charge_item,-1 ) as default_charge_item from user_profile where elt_account_number = " & elt_account_number 
	else
		tmpSQL= "select isnull(default_air_charge_item,-1 ) as defaultcharge_item from user_profile where elt_account_number = " & elt_account_number 
	end if

	Set tmprs = eltConn.Execute(tmpSQL)

	if not tmprs.eof then 
		defaultF = tmprs(0)
	else
		defaultF = "-1"
	end if	
	tmprs.close()  
	get_default_freight_charge_item = defaultF
End function
%>
<%
sub update_arrival_notice( tmpInvoice, NoItem )
    Dim tmprs, tmpSQL, defaultF, updated
    defaultF = get_default_freight_charge_item(iType)
    updated = "N"

    if defaultF <> "-1" then
		    for i=0 to NoItem-1
			    if aItemNo(i) = cInt(defaultF) And aAmount(i)<>0 then
    tmpSQL= "update import_hawb set freight_collect="&aAmount(i)&",fc_charge="&aAmount(i)&" where elt_account_number="&elt_account_number& " and invoice_no=" & tmpInvoice
			    updated = "Y"
			    eltConn.Execute(tmpSQL)
			    end if
		    next
    tmpSQL= "update import_hawb set prepaid_collect='"&updated&"' where elt_account_number="&elt_account_number& " and invoice_no=" & tmpInvoice
			    eltConn.Execute(tmpSQL)
    end if
end sub
%>
<%
Function CHECK_EX_DATE ( vMAWB, ArrivalDept ) 
    Dim tmpSQL
    If ArrivalDept = "1/1/1900" Then
	    ArrivalDept = ""
    End if
    If Trim(vMAWB) = "" Then
	    CHECK_EX_DATE = ArrivalDept
	    Exit function
    End If
    If ( Not IsDate(ArrivalDept)) Or ( Trim(ArrivalDept) = "" ) Or ( ArrivalDept = "1/1/1900" )  Then
	    tmpSQL="select ETD_DATE1 as export_date from mawb_number where elt_account_number=" & elt_account_number & " AND mawb_no='"&vMAWB&"'"
	    rs3.Open tmpSQL, eltConn, , , adCmdText
	    If Not rs3.EOF And IsNull(rs3("export_date"))=False Then
		    ArrivalDept=rs3("export_date")
	    Else
		    ArrivalDept=""
	    End If
	    rs3.close
    End If

    CHECK_EX_DATE = ArrivalDept
End Function
%>
<%
Function CHECK_EX_DATE_OCEAN ( vMAWB, ArrivalDept ) 
    Dim tmpSQL
    If ArrivalDept = "1/1/1900" Then
	    ArrivalDept = ""
    End if
    If Trim(vMAWB) = "" Then
	    CHECK_EX_DATE_OCEAN = ArrivalDept
	    Exit function
    End If
    If ( Not IsDate(ArrivalDept)) Or ( Trim(ArrivalDept) = "" ) Or ( ArrivalDept = "1/1/1900" )  Then
	    tmpSQL="select departure_date as export_date from ocean_booking_number where elt_account_number=" & elt_account_number & " AND booking_num='"&vMAWB&"'"
    'response.write 	tmpSQL
	    rs3.Open tmpSQL, eltConn, , , adCmdText
	    If Not rs3.EOF And IsNull(rs3("export_date"))=False Then
		    ArrivalDept=rs3("export_date")
	    Else
		    ArrivalDept=""
	    End If
	    rs3.close
    End If

    CHECK_EX_DATE_OCEAN = ArrivalDept
End Function
%>
<%
SUB MAKE_HAWB_REMARK
    DIM tmpStr
    pos =0
	
    pos = inStr(vRemarks, "HAWB#:")
	IF pos > 0 then
		EXIT SUB
	Else
        If hIndex > 1 Or vHAWB = "CONSOLIDATION" Then
            vHAWB = "CONSOLIDATION"
			Description = "CONSOLIDATION"
			tmpStr = ""
			if vAO="AIR" then
				tmpStr = "HAWB#:" & chr(10)
			Else
				tmpStr = "HBOL#:" & chr(10)
			end if
			for i=0 to hIndex-1
				tmpStr = tmpStr & aHAWB(i) & ", "
			next
			vRemarks = MID(tmpStr,1,LEN(tmpStr)-2)
		End if
	END If
	
END SUB

Sub GetAllSubInvoices()
    SQL = "SELECT invoice_no FROM invoice WHERE elt_account_number=" & elt_account_number & " AND master_invoice_no=" & InvoiceNo

    Set dataObj = new DataManager
    dataObj.SetDataList(SQL)
    Set aSubInvoices = dataObj.GetDataList
End Sub

Sub page_load

    TotalChargeWeight = checkBlank(TotalChargeWeight,0)
    TotalGrossWeight = checkBlank(TotalGrossWeight,0)
    
    TotalChargeWeight = Replace(UCase(TotalChargeWeight), " ", "")
    TotalGrossWeight = Replace(UCase(TotalGrossWeight), " ", "")
    
    If InStr(TotalChargeWeight,"K") > 0 Then
        TotalChargeWeightScale = "Kg"
        TotalChargeWeight = Mid(TotalChargeWeight,1,InStr(TotalChargeWeight,"K")-1)
    Elseif InStr(TotalChargeWeight,"L") > 0 Then
        TotalChargeWeightScale = "Lb"
        TotalChargeWeight = Mid(TotalChargeWeight,1,InStr(TotalChargeWeight,"L")-1)
    Else
        TotalChargeWeightScale = ""
    End If
    
    If InStr(TotalGrossWeight,"K") > 0 Then
        TotalGrossWeightScale = "Kg"
        TotalGrossWeight = Mid(TotalGrossWeight,1,InStr(TotalGrossWeight,"K")-1)
    Elseif InStr(TotalGrossWeight,"L") > 0 Then
        TotalGrossWeightScale = "Lb"
        TotalGrossWeight = Mid(TotalGrossWeight,1,InStr(TotalGrossWeight,"L")-1)
    Else
        TotalGrossWeightScale = ""
    End If
    
End Sub

%>
<!--  #include file="../include/arn_functions.inc" -->
<%
	If invoiceNo <> "" Then
		Call get_ar_payment	( invoiceNo )
	End If
%>
<% If tIndex = "" Then tIndex = 0 %>
<!--  #include file="../include/recent_file.asp" -->
<!--  #include file="../include/print_query_shared.asp" -->
<% 
	If request.ServerVariables("QUERY_STRING") = "" Then
		 If tIndex < 4 Then tIndex = 4 
		 If cIndex < 4 Then cIndex = 4 
	End If
	
	On Error Resume Next:
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
<link href="/Scripts/jquery-ui-1.10.3/themes/base/jquery-ui.css" rel="stylesheet" type="text/css" />
    <title>Edit Invoice</title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/ASP/ajaxFunctions/ajax.js"></script>
    <script type="text/javascript" src="../Include/JPED.js"></script>
    <script type="text/javascript" src="../Include/JPTableDOM.js"></script>
    <script type="text/javascript">
    <% For i=0 To cIndex-1 %>
    function lstVendorNameChange<%=i %>(orgNum,orgName){
        var hiddenObj = document.getElementById("hVendorAcct<%=i %>");
        var txtObj = document.getElementById("lstVendorName<%=i %>");
        var divObj = document.getElementById("lstVendorName<%=i %>Div");

        hiddenObj.value = orgNum;
        txtObj.value = orgName;
            
        try{
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
            divObj.style.height = "0px";
        }catch(err){}
    }
        
        function lstCostItemChange<%=i %>(vValue,vLabel){
            if(vValue != "") {
                var hiddenObj = document.getElementById("hCostItem<%=i %>");
                var divObj = document.getElementById("lstCostItem<%=i %>Div");
                
                hiddenObj.value = vValue;
                getCostItemInfo(vValue,vLabel,<%=i %>);
                
                try{
                    divObj.style.position = "absolute";
                    divObj.style.visibility = "hidden";
                    divObj.style.height = "0px";
                }catch(err){}
            }
        }
            <% Next %>
        
            function getCostItemInfo(arg1,arg2,ind){
                var url = "/ASP/ajaxFunctions/ajax_account_payable.asp?mode=CostItemInfo&cid=" + arg1
                new ajax.xhr.Request('GET','',url,displayCostItem,ind,arg2,null,null);
            }
        
            function displayCostItem(req,v1,v2,v3,v4,url)
            {
                if (req.readyState == 4)
                {   
                    if (req.status == 200)
                    {
                        try{
                            var xmlObj = req.responseXML;
		                
                            if(v2 != null){
                                setFieldByName("unit_price", "txtCost" + v1, xmlObj);
                                setFieldByName("item_desc", "txtCostDesc" + v1, xmlObj);
                                CostChange(v1);
                            }
                            setField("item_label", "lstCostItem" + v1, xmlObj);
		                
                        }catch(error)
                        {
                            alert(error.description);
                            xmlObj = null;
                        }
                        xmlObj = null;
                    }
                }
            }
		
            function setField(xmlTag,htmlTag,xmlObj)
            {
                if(xmlObj.getElementsByTagName(xmlTag)[0] != null && xmlObj.getElementsByTagName(xmlTag)[0].childNodes[0] != null)
                {
                    document.getElementById(htmlTag).value = xmlObj.getElementsByTagName(xmlTag)[0].childNodes[0].nodeValue;
                }
                else
                {
                    document.getElementById(htmlTag).value = "";
                }
            }
        
            function setFieldByName(xmlTag,htmlTag,xmlObj)
            {
                if(xmlObj.getElementsByTagName(xmlTag)[0] != null && xmlObj.getElementsByTagName(xmlTag)[0].childNodes[0] != null)
                {
                    document.getElementsByName(htmlTag)[0].value = xmlObj.getElementsByTagName(xmlTag)[0].childNodes[0].nodeValue;
                }
                else
                {
                    document.getElementsByName(htmlTag)[0].value = "";
                }
            }
        
            function lstCustomerNameChange(orgNum,orgName){
                try{
                    var hiddenObj = document.getElementById("hCustomerAcct");
                    var hiddenObjAdd = document.getElementById("hCustomerName");
                    var txtObj = document.getElementById("lstCustomerName");
                    var divObj = document.getElementById("lstCustomerNameDiv");
                    var infoObj = document.getElementById("txtCustomerInfo");
                    var termObj = document.getElementById("txtTerm");
                    var txtCustomerNumber = document.getElementById("txtCustomerNumber");
                
                    hiddenObj.value = orgNum;
                    hiddenObjAdd.value = orgName;
                    txtObj.value = orgName;
                    infoObj.value = getOrganizationInfo(orgNum);
                    termObj.value = getOrganizationTerm(orgNum);
                    txtCustomerNumber.value = orgNum;
            
                    divObj.style.position = "absolute";
                    divObj.style.visibility = "hidden";
                    divObj.style.height = "0px";
                }catch(err){}
            }
        
            function getOrganizationInfo(orgNum)
            {
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

                var url="/ASP/ajaxFunctions/ajax_get_org_address_info.asp?type=IV&org="+ orgNum;
        
                xmlHTTP.open("GET",url,false); 
                xmlHTTP.send(); 
            
                return xmlHTTP.responseText; 
            }
        
            function getOrganizationTerm(orgNum)
            {
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

                var url="/ASP/ajaxFunctions/ajax_get_org_address_info.asp?type=invTerm&org="+ orgNum;
        
                xmlHTTP.open("GET",url,false); 
                xmlHTTP.send(); 
            
                return xmlHTTP.responseText; 
            }
            <% For i=0 To tIndex-1 %>
            function lstChargeItemChange<%=i %>(vValue,vLabel){

                if(vValue != "") {
                    var hiddenObj = document.getElementById("hChargeItem<%=i %>");
                    var divObj = document.getElementById("lstChargeItem<%=i %>Div");
                
                    hiddenObj.value = vValue;
                    getChargeItemInfo(vValue,vLabel,<%=i %>);
                
                    try{
                        divObj.style.position = "absolute";
                        divObj.style.visibility = "hidden";
                        divObj.style.height = "0px";
                    }catch(err){}
                }
            }
                <% Next %>
        
                function getChargeItemInfo(arg1,arg2,ind){
                    var url = "/ASP/ajaxFunctions/ajax_account_payable.asp?mode=ChargeItemInfo&cid=" + arg1
                    new ajax.xhr.Request('GET','',url,displayChargeItem,ind,arg2,null,null);
                }
        
                function displayChargeItem(req,v1,v2,v3,v4,url)
                {
                    if (req.readyState == 4)
                    {   
                        if (req.status == 200)
                        {
                            try{
                                var xmlObj = req.responseXML;
		                
                                if(v2 != null){
                                    setFieldByName("unit_price", "txtAmount" + v1, xmlObj);
                                    setFieldByName("item_desc", "txtDesc" + v1, xmlObj)
                                }
                                setField("item_label", "lstChargeItem" + v1, xmlObj);
                                AmountChange(v1 );
		                
                            }catch(error)
                            {
                                // alert(error.description);
                                xmlObj = null;
                            }
                            xmlObj = null;
                        }
                    }
                }
		
                function lstSubInvoices_change(thisObj){
                    if(thisObj.value == "New"){
                        var vInvoiceNo = document.getElementById("txtInvoiceNo").value;
                        window.location.href = "edit_invoice.asp?CreateSub=yes&MasterInvoiceNo=" + vInvoiceNo + "&WindowName=" + window.name;
                    }
                    else{
                        var vInvoiceNo = document.getElementById("lstSubInvoices").value;
                        window.location.href = "edit_invoice.asp?edit=yes&InvoiceNo=" + vInvoiceNo + "&WindowName=" + window.name;
                    }
                }
    </script>
    <!-- /End of Combobox/ -->
    <style type="text/css">
        body
        {
            margin-left: 0px;
            margin-right: 0px;
            margin-bottom: 0px;
        }
        .style1
        {
            color: #663366;
        }
        .style2
        {
            color: #cc6600;
            font-weight: bold;
        }
        .style3
        {
            color: #000000;
        }
        .style7
        {
            color: #CC3300;
            font-weight: bold;
        }
        .style7 a:hover
        {
            color: #CC3300;
        }
    </style>
   
     <script src="/Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script src="/Scripts/jquery-ui-1.8.20.min.js" type="text/javascript"></script>
     <link href="/Scripts/jquery-ui-1.10.3/themes/base/jquery-ui.css"
        rel="stylesheet" type="text/css" />
    <script type="text/javascript">
    $(document).ready(function () {
        $("#txtInvoiceDate").datepicker();     
        if( $("#txtInvoiceDate").val()==""){

            var currentDate = new Date();
            var day = currentDate.getDate()
            var month = currentDate.getMonth() + 1
            var year = currentDate.getFullYear()
            var today= month + "/" + day + "/" + year ;
            $("#txtInvoiceDate").val(today)
        }

        $("#txtEntryDate").datepicker();     
        if( $("#txtEntryDate").val()==""){

            var currentDate = new Date();
            var day = currentDate.getDate()
            var month = currentDate.getMonth() + 1
            var year = currentDate.getFullYear()
            var today= month + "/" + day + "/" + year ;
            $("#txtEntryDate").val(today)
        }
        



        if("<%=TotalChargeWeightScale %>"==""){
            var Unit="Kg"
            if("<%=vUom %>"=="LB"){Unit="Lb";}
            $("#lstTotalGrossWeightScale").val(Unit);
            $("#lstTotalChargeWeightScale").val(Unit);    
            WeightScaleChange( $("#lstTotalGrossWeightScale").get(0));              
        }
         
    });
    </script>
</head>
<body link="336699" vlink="336699" topmargin="0">
    <form id="form1" name="form1" method="POST">
        <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
            <tr>
                <td width="51%" height="32" align="left" valign="middle" class="pageheader">Add Invoices
                </td>
                <td width="49%" align="right" valign="middle">
                    <div id="print">
                        <!-- <img src="/ASP/Images/icon_dotprinter.gif" width="40" height="27" align="absbottom"><a href="javascript:;" onClick="SaveClick(<%= TranNo %>,'YES');return false;">Invoice (Dot Matrix)</a> -->
                        <img src="/ASP/Images/spacer.gif" width="54" height="10" alt="" /><img src="/ASP/Images/icon_printer.gif"
                            width="40" height="27" align="absbottom" alt="" /><a href="javascript:;" onclick="PDFClick();return false;">Invoice</a><img
                                src="/ASP/Images/button_devider.gif" width="19" height="10" alt="" /><a href="javascript:;"
                                    onclick="StmtClick();return false;">Agent Statement</a>
                    </div>
                </td>
            </tr>
        </table>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#89A979">
            <tr>
                <td>
                    <!-- start of scroll bar -->
                    <input type="hidden" name="scrollPositionX" />
                    <input type="hidden" name="scrollPositionY" />
                    <!-- end of scroll bar -->
                    <input type="hidden" name="hAO" value="<%= vAO %>" />
                    <input type="hidden" name="hPrintPort" value="<%= vPrintPort %>" />
                    <input type="hidden" name="hClientOS" value="<%= ClientOS %>" />
                    <input type="hidden" name="hNoItem" value="<%= tIndex %>" />
                    <input type="hidden" name="hNoCostItem" value="<%= cIndex %>" />
                    <input type="hidden" name="hCustomerName" id="hCustomerName" value="<%= vCustomer %>" />
                    <input type="hidden" name="hHBOL" value="<%= vHBOL %>" />
                    <input type="hidden" name="hNoHAWB" value="<%= hIndex %>" />
                    <!--// by ig 7/11/2006 -->
                    <input type="hidden" name="hFILEPrefix" value="<%= vFILEPrefix %>" />
                    <input type="hidden" name="hNEXTFILENo" value="<%= vNEXTFILENo %>" />
                    <!--// -->
                    <% for jj=0 to hIndex-1 %>
                    <input type="hidden" name="hHAWBURL<%= jj %>" value="<%= aHAWBURL(jj) %>" />
                    <% next %>
                    <input type="hidden" name="hNewInvoiceURL" value="<%= NewInvoiceURL %>" />
                    <input type="hidden" name="hQueueID" value="<%= vQueueID %>" />
                    <table width="100%" border="0" cellpadding="2" cellspacing="1">
                        <tr bgcolor="D5E8CB">
                            <td height="8" colspan="19" align="left" valign="top" bgcolor="D5E8CB" class="bodyheader">
                                <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
                                    <tr align="center">
                                        <td width="24%">&nbsp;
                                        </td>
                                        <td width="52%" height="100%" colspan="1" valign="middle" bgcolor="D5E8CB">
                                            <% If UserRight < 5 Or Branch <> "" Or vInvoiceAccessType = "G" Then %>
                                            <% Else %>
                                            <img src="../images/button_save_medium.gif" width="46" height="18" name="bSave" onclick="SaveClick(<%= TranNo %>,'NO')"
                                                style="cursor: hand" alt="" />
                                            <% End If %>
                                        &nbsp;&nbsp;&nbsp;
                                        </td>
                                        <td width="12%" align="right" valign="middle">&nbsp;
                                        </td>
                                        <td width="12%" align="right" valign="middle">
                                            <% if UserRight = 9 And  InvoiceNo > 0 And vvvLockAR <> "Y" And vvvLockAP <> "Y" AND vInvoiceAccessType <> "G" then %>
                                            <img src="../images/button_delete_medium.gif" onclick="javascript:deleteInvoice('<%=InvoiceNo %>');"
                                                style="cursor: hand" alt="" />
                                            <% end if %>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="E7F0E2">
                            <td width="100%" colspan="19" bgcolor="#f3f3f3" class="bodycopy">
                                <br />
                                <br />
                                <table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td style="height: 20px">
                                            <span class="bodyheader style1">INVOICE NO.</span>
                                            <input name="txtqInvoiceNo" type="text" class="shorttextfield" size="20" value="Search Here"
                                                onkeydown="javascript: if(event.keyCode == 13) { LookupIV(); return false;}"
                                                onclick="        javascript: this.value = ''; this.style.color='#000000'; "
                                                style="behavior: url(../include/igNumChkLeft.htc)" id="txtqInvoiceNo" />
                                            <img src="../images/button_newsearch.gif" name="B1" width="25" height="18" align="absmiddle"
                                                style="cursor: hand" onclick="LookupIV()" alt="" />
                                        </td>
                                        <td align="right">
                                            <span class="bodyheader">
                                                <img src="/ASP/Images/required.gif" align="absbottom" alt="" />Required field</span>
                                        </td>
                                    </tr>
                                </table>
                                <br />
                                <table width="90%" border="0" align="center" cellpadding="0" cellspacing="0" style="border: solid 1px #89A979"
                                    bgcolor="D5E8CB" class="border1px">
                                    <tr align="left" valign="middle" style="height: 20px; background-color: #D5E8CB"
                                        class="bodyheader">
                                        <td></td>
                                        <td>Invoice No.
                                        </td>
                                        <td colspan="2">
                                            <% If MasterInvoiceNo <> "" Then %>
                                        Master Invoice
                                        <% Elseif InvoiceNo <> "" Then %>
                                        Sub Invoices
                                        <% Else %>
                                            <% End If %>
                                        </td>
                                        <td>&nbsp;
                                        </td>
                                        <td>&nbsp;
                                        </td>
                                        <td>&nbsp;
                                        </td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="D5E8CB" class="bodycopy">
                                        <td align="left" valign="middle" bgcolor="#FFFFFF"></td>
                                        <td height="26" align="left" valign="middle" bgcolor="#FFFFFF">
                                            <strong>
                                                <input name="txtInvoiceNo" id="txtInvoiceNo" type="text" class="readonlybold" value="<%=InvoiceNo %>"
                                                    style="width: 100px" readonly="readonly" />
                                            </strong>
                                        </td>
                                        <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodyheader" colspan="2">
                                            <% If MasterInvoiceNo <> "" Then %>
                                            <input type="text" id="txtMasterInvoice" name="txtMasterInvoice" value="<%=MasterInvoiceNo %>"
                                                class="readonlybold" readonly="readonly" style="width: 100px" />
                                            <a href="edit_invoice.asp?edit=yes&InvoiceNo=<%=MasterInvoiceNo %>">
                                                <img src="../images/icon_go.gif" style="border: none 0px" alt="" width="26" height="16"
                                                    align="absmiddle" /></a>
                                            <% Elseif InvoiceNo <> "" Then %>
                                            <select id="lstSubInvoices" class="smallselect" style="width: 125px" onchange="lstSubInvoices_change(this);">
                                                <option value="">Select One</option>
                                                <option value="New">Create New</option>
                                                <% For i=0 To aSubInvoices.Count-1 %>
                                                <option value="<%=aSubInvoices(i)("invoice_no") %>">
                                                    <%=aSubInvoices(i)("invoice_no") %>
                                                </option>
                                                <% Next %>
                                            </select>
                                            <% Else %>
                                            <% End If %>
                                        </td>
                                        <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodyheader">&nbsp;
                                        </td>
                                        <td align="left" valign="middle" bgcolor="#FFFFFF">&nbsp;
                                        </td>
                                        <td align="left" valign="middle" bgcolor="#FFFFFF">&nbsp;
                                        </td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="89A979">
                                        <td height="1" colspan="7" align="left" valign="middle"></td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="D5E8CB" class="bodycopy">
                                        <td align="left" valign="middle" bgcolor="#f3f3f3"></td>
                                        <td height="20" colspan="3" align="left" valign="middle" bgcolor="#f3f3f3">
                                            <img src="/ASP/Images/required.gif" align="absbottom" alt="" /><strong>Customer</strong>
                                        </td>
                                        <td align="left" valign="middle" bgcolor="#f3f3f3">
                                            <span class="bodyheader">
                                                <img src="/ASP/Images/required.gif" align="absbottom" alt="" />Invoice Date
                                            </span>
                                        </td>
                                        <td align="left" valign="middle" bgcolor="#f3f3f3">
                                            <span class="bodyheader">Customer Reference No.</span>
                                        </td>
                                        <td align="left" valign="middle" bgcolor="#f3f3f3">
                                            <span class="bodyheader">File No. </span>
                                        </td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="D5E8CB" class="bodycopy">
                                        <td align="left" valign="middle" bgcolor="#FFFFFF"></td>
                                        <td colspan="3" rowspan="3" align="left" valign="middle" bgcolor="#FFFFFF">
                                            <!-- Start JPED -->
                                            <div id="CustomerContainer">
                                                <input type="hidden" id="hCustomerAcct" name="hCustomerAcct" />
                                                <div id="lstCustomerNameDiv">
                                                </div>
                                                <table cellpadding="0" cellspacing="0" border="0">
                                                    <tr>
                                                        <td>
                                                            <input type="text" autocomplete="off" id="lstCustomerName" name="lstCustomerName"
                                                                value="" class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;"
                                                                onkeyup="organizationFill(this,'Customer','lstCustomerNameChange',null,event)"
                                                                onfocus="initializeJPEDField(this,event);" alt="lstCustomerName" />
                                                        </td>
                                                        <td>
                                                            <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstCustomerName','Customer','lstCustomerNameChange',null,event)"
                                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9; border-left: 0px solid #7F9DB9; cursor: hand;" />
                                                        </td>
                                                    </tr>
                                                </table>
                                                <textarea id="txtCustomerInfo" name="txtCustomerInfo" class="multilinetextfield"
                                                    cols="" rows="7" style="width: 300px"></textarea>
                                            </div>
                                            <!-- End JPED -->
                                        </td>
                                        <td align="left" valign="top" bgcolor="#FFFFFF">
                                            <font size="2">
                                            <input name="txtInvoiceDate" type="text" class="m_shorttextfield " preset="shortdate"
                                                value="<%= InvoiceDate %>" size="14" id="txtInvoiceDate" />
                                        </font>
                                        </td>
                                        <td align="left" valign="top" bgcolor="#FFFFFF">
                                            <span class="bodyheader"><font size="2">
                                            <input name="txtRefNo" type="text" class="shorttextfield" 
                                            value="<%= RefNo %>" size="20" id="txtRefNo">
                                        </font></span>
                                        </td>
                                        <td align="left" valign="top" bgcolor="#FFFFFF">
                                            <span class="bodyheader">
                                                <input name='txtFileNo' class='shorttextfield' value='<%= vFileNo %>'
                                                    size='20' id="txtFileNo">
                                            </span>
                                        </td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="D5E8CB" class="bodycopy">
                                        <td align="left" valign="middle" bgcolor="#FFFFFF"></td>
                                        <td align="left" valign="middle" bgcolor="#f3f3f3">
                                            <span class="bodyheader"><strong>Customer No.</strong></span>
                                        </td>
                                        <td align="left" valign="middle" bgcolor="#f3f3f3">
                                            <span class="bodyheader">Term</span>
                                        </td>
                                        <td align="left" valign="middle" bgcolor="#f3f3f3">
                                            <span class="bodyheader">A/R</span>
                                        </td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="D5E8CB" class="bodycopy">
                                        <td width="9" align="left" valign="middle" bgcolor="#FFFFFF"></td>
                                        <td width="170" align="left" valign="top" bgcolor="#FFFFFF">
                                            <input name="txtCustomerNumber" id="txtCustomerNumber" type="text" class="d_shorttextfield"
                                                value="<%= vOrgAcct %>" size="14" readonly="readonly" />
                                        </td>
                                        <td width="188" align="left" valign="top" bgcolor="#FFFFFF">
                                            <input name="txtTerm" id="txtTerm" type="text" class="shorttextfield" value="<%= vTerm %>"
                                                size="8">
                                        </td>
                                        <td width="182" align="left" valign="top" bgcolor="#FFFFFF">
                                            <select name="lstAR" size="1" class="smallselect" style="width: 137" id="lstAR">
                                                <% for j=0 to ARIndex-1 %>
                                                <option value="<%= DefaultAR(j) %>" <% if DefaultAR(j)=AR_Config then response.write("selected") %>>
                                                    <%= DefaultARName(j) %>
                                                </option>
                                                <% next %>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="D5E8CB" class="bodycopy">
                                        <td align="left" valign="middle" bgcolor="#f3f3f3"></td>
                                        <td height="20" align="left" valign="middle" bgcolor="#f3f3f3">
                                            <%
                                                    '// tmpShipper = replace(vShipper,"/","")
                                                    '// tmpConsignee = replace(vConsignee,"/","")
                                            %>
                                            <a href="javascript:;" onclick="javascript: goClientProfile('txtShipper');return false;"
                                                tabindex="-1"><strong>Shipper</strong></a>
                                        </td>
                                        <td valign="middle" bgcolor="#f3f3f3">&nbsp;
                                        </td>
                                        <td valign="middle" bgcolor="#f3f3f3">
                                            <a href="javascript:;" onclick="javascript: goClientProfile('txtConsignee');return false;"
                                                tabindex="-1"><strong>Consignee</strong></a>
                                        </td>
                                        <td align="left" valign="middle" bgcolor="#f3f3f3">&nbsp;
                                        </td>
                                        <td align="left" valign="middle" bgcolor="#f3f3f3">
                                            <span class="style2">Master AWB <span class="style3">/</span> Master B/L</span>
                                        </td>
                                        <td align="left" valign="middle" bgcolor="#f3f3f3">
                                            <span class="style2">House AWB <span class="style3">/</span> House B/L</span>
                                        </td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="D5E8CB" class="bodycopy">
                                        <td align="left" valign="middle" bgcolor="#FFFFFF"></td>
                                        <td height="20" colspan="2" align="left" valign="middle" bgcolor="#FFFFFF">
                                            <input name="txtShipper" name="txtShipper" type="text" class="shorttextfield" value="<%= vShipper %>"
                                                size="38" id="txtShipper" />
                                        </td>
                                        <td colspan="2" align="left" valign="middle" bgcolor="#FFFFFF">
                                            <input name="txtConsignee" type="text" class="shorttextfield" value="<%= vConsignee %>"
                                                size="38" id="txtConsignee" />
                                        </td>
                                        <td bgcolor="#FFFFFF">
                                            <% if vAO = "OCEAN" and MAWB_NUM = "" then MAWB_NUM = vBookingNum %>
                                            <input name="txtMAWB" type="text" class="shorttextfield" value="<%= MAWB_NUM %>"
                                                size="25" onclick="        SetBillNumber('Master')" id="txtMAWB" />
                                        </td>
                                        <td bgcolor="#FFFFFF">
                                            <input name="txtHAWB" type="text" class="shorttextfield" value="<%= vHAWB %>" size="25"
                                                onclick="        SetBillNumber('House')" id="txtHAWB" />
                                        </td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="D5E8CB" class="bodycopy">
                                        <td align="left" valign="middle" bgcolor="#f3f3f3"></td>
                                        <td height="20" align="left" valign="middle" bgcolor="#f3f3f3">
                                            <strong>Pieces</strong>
                                        </td>
                                        <td valign="middle" bgcolor="#f3f3f3">
                                            <strong>Gross Weight</strong>
                                        </td>
                                        <td valign="middle" bgcolor="#f3f3f3">
                                            <strong>Charge Weight</strong>
                                        </td>
                                        <td align="left" valign="middle" bgcolor="#f3f3f3">
                                            <strong>Description</strong>
                                        </td>
                                        <td align="left" valign="middle" bgcolor="#f3f3f3">&nbsp;
                                        </td>
                                        <td align="left" valign="middle" bgcolor="#f3f3f3">&nbsp;
                                        </td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="D5E8CB" class="bodycopy">
                                        <td align="left" valign="middle" bgcolor="#FFFFFF"></td>
                                        <td height="20" align="left" valign="middle" bgcolor="#FFFFFF">
                                            <input name="txtTotalPiece" type="text" class="shorttextfield" value="<%= TotalPieces %>"
                                                size="10" id="txtTotalPiece" />
                                        </td>
                                        <td bgcolor="#FFFFFF">
                                            <input name="txtTotalGrossWeight" type="text" class="shorttextfield" style="behavior: url(../include/igNumDotChkLeft.htc)"
                                                value="<%= formatNumber(TotalGrossWeight,2,,,0) %>" size="10"
                                                onblur="javascript:txtTotalGrossWeight_click();" id="txtTotalGrossWeight">
                                            <select name="lstTotalGrossWeightScale" id="lstTotalGrossWeightScale" class="smallselect"
                                                onchange="WeightScaleChange(this);">

                                                <option value="Kg" <% If TotalGrossWeightScale="Kg" Then Response.Write("Selected") %>>Kg</option>
                                                <option value="Lb" <% If TotalGrossWeightScale="Lb" Then Response.Write("Selected") %>>Lb</option>
                                            </select>
                                        </td>
                                        <td bgcolor="#FFFFFF">
                                            <input name="txtTotalChargeWeight" type="text" class="shorttextfield" value="<%= formatNumber(TotalChargeWeight,2,,,0) %>"
                                                style="behavior: url(../include/igNumDotChkLeft.htc)" size="10"
                                                onblur="javascript:txtTotalChargeWeight_click();" id="txtTotalChargeWeight" />
                                            <select name="lstTotalChargeWeightScale" id="lstTotalChargeWeightScale" class="smallselect"
                                                onchange="WeightScaleChange(this);">

                                                <option value="Kg" <% If TotalChargeWeightScale="Kg" Then Response.Write("Selected") %>>Kg</option>
                                                <option value="Lb" <% If TotalChargeWeightScale="Lb" Then Response.Write("Selected") %>>Lb</option>
                                            </select>
                                        </td>
                                        <td colspan="2" align="left" valign="top" bgcolor="#FFFFFF">
                                            <input name="txtDescription" type="text" class="shorttextfield" value="<%= Description %>"
                                                size="48" checked="txtDescription">
                                        </td>
                                        <td align="left" valign="top" bgcolor="#FFFFFF">&nbsp;
                                        </td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="D5E8CB" class="bodycopy">
                                        <td height="20" align="left" valign="middle" bgcolor="#f3f3f3"></td>
                                        <td height="20" align="left" valign="middle" bgcolor="#f3f3f3">
                                            <strong>Entry No.</strong>
                                        </td>
                                        <td height="20" valign="middle" bgcolor="#f3f3f3">
                                            <strong>Entry Date</strong>
                                        </td>
                                        <td height="20" valign="middle" bgcolor="#f3f3f3">
                                            <strong>Origin</strong>
                                        </td>
                                        <td height="20" align="left" valign="middle" bgcolor="#f3f3f3">
                                            <strong>Destination</strong>
                                        </td>
                                        <td height="20" align="left" valign="middle" bgcolor="#f3f3f3">
                                            <strong>Airline/Steamship</strong>
                                        </td>
                                        <td height="20" align="left" valign="middle" bgcolor="#f3f3f3">
                                            <strong>Arrival/Departure</strong>
                                        </td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="D5E8CB" class="bodycopy">
                                        <td align="left" valign="middle" bgcolor="#FFFFFF"></td>
                                        <td height="20" align="left" valign="middle" bgcolor="#FFFFFF">
                                            <input name="txtEntryNo" type="text" class="shorttextfield" value="<%= EntryNo %>"
                                                size="20" id="txtEntryNo">
                                        </td>
                                        <td bgcolor="#FFFFFF">
                                            <input name="txtEntryDate" type="text" class="shorttextfield date" value="<%= EntryDate %>"
                                                size="20" id="txtEntryDate">
                                        </td>
                                        <td bgcolor="#FFFFFF">
                                            <input name="txtOrigin" type="text" class="shorttextfield" value="<%= Origin %>"
                                                size="20" id="txtOrigin">
                                        </td>
                                        <td align="left" valign="top" bgcolor="#FFFFFF">
                                            <input name="txtDest" type="text" class="shorttextfield" value="<%= Dest %>"
                                                size="20" id="txtDest">
                                            <input name="txtOriginDest" type="hidden" class="shorttextfield" value="<%= OriginDest %>">
                                        </td>
                                        <td align="left" valign="top" bgcolor="#FFFFFF">
                                            <input name="txtCarrier" type="text" class="shorttextfield" value="<%= Carrier %>"
                                                size="20" id="txtCarrier">
                                        </td>
                                        <td align="left" valign="top" bgcolor="#FFFFFF">
                                            <input name="txtArrivalDept" type="text" class="shorttextfield" value="<%= ArrivalDept %>"
                                                size="28" id="txtArrivalDept">
                                        </td>
                                    </tr>
                                </table>
                                <br />
                                <input type="hidden" id="InvoiceItem" />
                                <input type="hidden" id="ItemDesc" />
                                <input type="hidden" id="ItemAmount" />
                                <input type="hidden" id="ItemCost" />
                                <input type="hidden" id="ItemCostDesc" />
                                <table cellpadding="0" cellspacing="0" border="0" style="border: solid 1px #89A979; width: 90%"
                                    class="border1px" align="center" id="tblChargeItems">
                                    <tr style="background-color: #D5E8CB; height: 20px" class="bodyheader">
                                        <td>&nbsp;
                                        </td>
                                        <td>Charge Item
                                        </td>
                                        <td>Description
                                        </td>
                                        <td>Amount
                                        </td>
                                        <td colspan="3"></td>
                                    </tr>
                                    <tr>
                                        <td style="height: 5px"></td>
                                    </tr>
                                    <% for i=0 to tIndex-1 %>
                                    <tr>
                                        <td bgcolor="#FFFFFF">&nbsp;
                                        </td>
                                        <td height="20" bgcolor="#FFFFFF">
                                            <!-- Start JPED -->
                                            <input type="hidden" id="hChargeItem<%=i %>" name="hChargeItem<%=i %>" value="" />
                                            <div id="lstChargeItem<%=i %>Div">
                                            </div>
                                            <table cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td>
                                                        <input type="text" autocomplete="off" id="lstChargeItem<%=i %>" name="lstChargeItem<%=i %>"
                                                            value="" class="shorttextfield" style="width: 200px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;"
                                                            onkeyup="GLItemFill(this,'ItemChargeNameDesc','lstChargeItemChange<%=i %>',140)"
                                                            onfocus="initializeJPEDField(this,event);"
                                                            checked="lstChargeItem<%=i %>" />
                                                    </td>
                                                    <td>
                                                        <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="GLItemFillAll('lstChargeItem<%=i %>','ItemChargeNameDesc','lstChargeItemChange<%=i %>',140)"
                                                            style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9; border-left: 0px solid #7F9DB9; cursor: hand;" />
                                                    </td>
                                                </tr>
                                            </table>
                                            <!-- End JPED -->
                                            <script type="text/javascript">
    lstChargeItemChange<%=i %>("<%=aItemNo(i) %>",null);
                                            </script>
                                        </td>
                                        <td>
                                            <input name="txtDesc<%= i %>" type="text" class="shorttextfield" id="ItemDesc" value="<%= aDesc(i) %>"
                                                style="width: 150px" checked="txtDesc<%= i %>" />
                                        </td>
                                        <td align="left" bgcolor="#FFFFFF">
                                            <input name="txtAmount<%= i %>" style="behavior: url(../include/igNumDotChkLeft.htc)"
                                                type="text" class="numberfield ItemAmount" id="ItemAmount" onchange="AmountChange(<%= i %>)"
                                                value="<%= formatNumber(aAmount(i),2,,,0) %>" size="13"
                                                checked="txtAmount<%= i %>" />
                                        </td>
                                        <td style="background-color: #ffffff" colspan="3">
                                            <img src="../images/button_delete.gif" width="50" height="17" onclick="DeleteItem(<%= i %>)"
                                                <% if UserRight<5 then response.write("disabled") %> style="cursor: hand" alt="" />
                                        </td>
                                    </tr>
                                    <% next %>
                                    <tr>
                                        <td colspan="4" bgcolor="#FFFFFF"></td>
                                        <td colspan="3" bgcolor="#FFFFFF">
                                            <img alt="" src="../images/button_addcharge_item.gif" width="109" height="18" name="bAddItem2"
                                                onclick="AddItem()" <% if UserRight<5 Or Not Branch="" then response.write("disabled") %>
                                                style="cursor: hand" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="f3f3f3" colspan="2">&nbsp;
                                        </td>
                                        <td align="right" bgcolor="#f3f3f3" style="padding-right: 10px">
                                            <strong><font color="#C16B42">Total Charge</font></strong>
                                        </td>
                                        <td align="left" bgcolor="#f3f3f3">
                                            <input type="text" name="txtTotalCharge" class="numberfield" value="<%= formatNumber(TotalCharge,2,,,0) %>"
                                                readonly="readonly" size="13" style="font-weight: bold"
                                                checked="txtTotalCharge" />
                                        </td>
                                        <td bgcolor="f3f3f3" colspan="3"></td>
                                    </tr>
                                    <tr>
                                        <td valign="top" bgcolor="#FFFFFF" colspan="2">
                                            <input name="txtSubTotal" type="hidden" class="numberfield" value="<%= SubTotal %>" />
                                        </td>
                                        <td height="20" align="right" bgcolor="#FFFFFF" style="padding-right: 10px">
                                            <strong>Sales Tax</strong>
                                        </td>
                                        <td align="left" bgcolor="#FFFFFF">
                                            <input name="txtSaleTax" type="text" class="numberfield" value="<%= formatNumber(SaleTax,2,,,0) %>"
                                                size="13" style="font-weight: bold" checked="txtSaleTax" />
                                        </td>
                                        <td colspan="3" bgcolor="#FFFFFF">&nbsp;
                                        </td>
                                    </tr>
                                    <% 'if NOT vAO = "OCEAN" then %>
                                    <tr>
                                        <td bgcolor="#FFFFFF" colspan="2"></td>
                                        <td height="20" align="right" bgcolor="#FFFFFF" style="padding-right: 10px">
                                            <strong>Agent Profit</strong>
                                        </td>
                                        <td align="left" bgcolor="#FFFFFF">
                                            <input name="txtAgentProfit" type="text" class="numberfield" onchange="AgentProfitChange()"
                                                value="<%=formatNumber(AgentProfit,2,,,0) %>" size="13" style="font-weight: bold"
                                                readonly="readonly" checked="txtAgentProfit" />
                                        </td>
                                        <td valign="middle" bgcolor="#FFFFFF" colspan="3">
                                            <table cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td>
                                                        <img src="../images/button_adjustment.gif" name="bProfitAdj" width="80" height="18"
                                                            onclick="ProfitAdj()" style="cursor: hand" alt="" align="absbottom" />
                                                    </td>
                                                    <td style="width: 10px"></td>
                                                    <td>
                                                        <select name="lstCGS" class="smallselect" id="lstCGS">
                                                            <% for k=0 to CGSIndex-1 %>
                                                            <option value="<%= DefaultCGS(k) %>" <% if DefaultCGS(k)=vCGS then response.write("selected") %>>
                                                                <%= DefaultCGSName(k) %>
                                                            </option>
                                                            <% next %>
                                                        </select>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right" bgcolor="#f3f3f3" colspan="2">&nbsp;
                                        </td>
                                        <td align="right" bgcolor="#f3f3f3" class="Total14pt" style="padding-right: 10px">
                                            <font color="c16b42">TOTAL</font>
                                        </td>
                                        <td align="left" bgcolor="#f3f3f3" class="bodyheader">
                                            <b>
                                                <input name="txtTotalAmount" type="text" class="numberfield" value="<% if Not TotalAmount="" then response.write(formatNumber(TotalAmount,2,,,0)) %>"
                                                    size="13" style="font-weight: bold" readonly="readonly"
                                                    checked="txtTotalAmount" />
                                            </b>
                                        </td>
                                        <td colspan="3" bgcolor="#f3f3f3">&nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right" bgcolor="#FFFFFF">&nbsp;
                                        </td>
                                        <td height="20" align="right" bgcolor="#FFFFFF">&nbsp;
                                        </td>
                                        <td colspan="5" align="left" bgcolor="#FFFFFF" class="bodyheader"></td>
                                    </tr>
                                </table>
                                <script type="text/javascript">
    <% If vvvLockAR = "Y" Then %>
    makeAllReadOnlyStyle(document.getElementById("tblChargeItems"));
    <% End If %>
                                </script>
                                <span style="width: 90%; text-align: right">
                                    <%	
					                            if arPayMentNoIndex > 0 then
						                            response.write "<span class='style7'>"
						                            response.write "Payment received "
						                            for i=1 to arPayMentNoIndex+1
                                    %>
                                    <a href="javascrip:;" onclick="goLinkPay('<%=arPayMentNo(i)%>'); return false;">
                                        <%=arPayMentNo(i)%>
                                    </a>&nbsp;
                                <%	
						                            next
						                            response.write "</strong></span>"						
						                            if arPayMentNoIndex > arPayMentNoIndex+1 then
							                            response.write "..."
						                            end if
					                            end if
                                %>
                                </span>
                                <br />
                                <br />
                                <table cellpadding="0" cellspacing="0" border="0" style="border: solid 1px #89A979; width: 98%"
                                    class="border1px" align="center">
                                    <tr>
                                        <td align="right" bgcolor="#D5E8CB">&nbsp;
                                        </td>
                                        <td height="20" align="left" valign="middle" bgcolor="#D5E8CB">
                                            <strong>Cost Item</strong>
                                        </td>
                                        <td align="left" valign="middle" bgcolor="#D5E8CB" class="bodyheader">
                                            <strong>Amount</strong>
                                        </td>
                                        <td bgcolor="#D5E8CB">
                                            <strong>Vendor</strong>
                                        </td>
                                        <td bgcolor="#D5E8CB">
                                            <strong>Reference No.</strong>
                                        </td>
                                        <td bgcolor="#D5E8CB"></td>
                                    </tr>
                                    <% for i=0 to cIndex-1 %>
                                    <% if aAPLock(i) = "" or aAPLock(i) = "0" then%>
                                    <tr>
                                        <td align="right" bgcolor="#FFFFFF">
                                            <input name="txtAPLOCK<%= i %>" type="hidden" value="<%= aAPLock(i) %>">
                                        </td>
                                        <td height="20" align="left" valign="middle" bgcolor="#FFFFFF">
                                            <!-- Start JPED -->
                                            <input type="hidden" id="hCostItem<%=i %>" name="hCostItem<%=i %>" value="" />
                                            <div id="lstCostItem<%=i %>Div">
                                            </div>
                                            <table cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td>
                                                        <input type="text" autocomplete="off" id="lstCostItem<%=i %>" name="lstCostItem<%=i %>"
                                                            value="" class="shorttextfield" style="width: 200px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;"
                                                            onkeyup="GLItemFill(this,'ItemCostNameDesc','lstCostItemChange<%=i %>',140)"
                                                            onfocus="initializeJPEDField(this,event);" />
                                                    </td>
                                                    <td>
                                                        <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="GLItemFillAll('lstCostItem<%=i %>','ItemCostNameDesc','lstCostItemChange<%=i %>',140)"
                                                            style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9; border-left: 0px solid #7F9DB9; cursor: hand;" />
                                                    </td>
                                                </tr>
                                            </table>
                                            <!-- End JPED -->
                                            <script type="text/javascript">
    lstCostItemChange<%=i %>("<%=aCostItemNo(i) %>",null);
                                            </script>
                                            <input name="txtCostDesc<%= i %>" type="hidden" class="shorttextfield ItemCostDesc" id="ItemCostDesc"
                                                value="<%= aCostDesc(i) %>" size="34" />
                                        </td>
                                        <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodyheader">
                                            <input name="txtCost<%= i %>" style="behavior: url(../include/igNumDotChkLeft.htc)"
                                                type="text" class="numberfield ItemCost" id="ItemCost" onchange="CostChange(<%= i %>)"
                                                value="<%= formatNumber(aRealCost(i),2,,,0) %>" size="13" />
                                        </td>
                                        <td align="left" valign="middle" bgcolor="#FFFFFF">
                                            <!-- Start JPED -->
                                            <input type="hidden" id="hVendorAcct<%=i %>" name="hVendorAcct<%=i %>" />
                                            <div id="lstVendorName<%=i %>Div">
                                            </div>
                                            <table cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td>
                                                        <input type="text" autocomplete="off" id="lstVendorName<%=i %>" name="lstVendorName"
                                                            value="" class="shorttextfield" style="width: 220px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;"
                                                            onkeyup="organizationFill(this,'Vendor','lstVendorNameChange<%=i %>',null,event)"
                                                            onfocus="initializeJPEDField(this,event);" />
                                                    </td>
                                                    <td>
                                                        <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstVendorName<%=i %>','Vendor','lstVendorNameChange<%=i %>',null,event)"
                                                            style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9; border-left: 0px solid #7F9DB9; cursor: hand;" />
                                                    </td>
                                                </tr>
                                            </table>
                                            <!-- End JPED -->
                                            <script type="text/javascript">
    lstVendorNameChange<%=i %>("<%=aVendor(i) %>","<%=GetBusinessName(aVendor(i)) %>");
                                            </script>
                                        </td>
                                        <td bgcolor="#FFFFFF">
                                            <input name="txtRefNo<%= i %>" type="text" class="shorttextfield" value="<%= aRefNo(i) %>"
                                                size="15" id="txtRefNo<%= i %>" />
                                        </td>
                                        <td bgcolor="#FFFFFF">
                                            <img src="../images/button_delete.gif" width="50" height="17" onclick="DeleteCostItem(<%= i %>)"
                                                <% if UserRight<5 then response.write("disabled") %> style="cursor: hand" alt="" />
                                        </td>
                                    </tr>
                                    <% else %>
                                    <tr>
                                        <td align="right" bgcolor="#FFFFFF">
                                            <input name="txtAPLOCK<%= i %>" type="hidden" value="<%= aAPLock(i) %>" />
                                        </td>
                                        <td height="20" align="left" valign="middle" bgcolor="#FFFFFF">
                                            <div id="CostItemDivContainer<%=i %>">
                                                <!-- Start JPED -->
                                                <input type="hidden" id="hCostItem<%=i %>" name="hCostItem<%=i %>" value="" />
                                                <div id="lstCostItem<%=i %>Div">
                                                </div>
                                                <table cellpadding="0" cellspacing="0" border="0">
                                                    <tr>
                                                        <td>
                                                            <input type="text" autocomplete="off" id="lstCostItem<%=i %>" name="lstCostItem<%=i %>"
                                                                value="" class="shorttextfield" style="width: 200px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;"
                                                                onkeyup="GLItemFill(this,'ItemCostNameDesc','lstCostItemChange<%=i %>',140)"
                                                                onfocus="initializeJPEDField(this,event);" />
                                                        </td>
                                                        <td>
                                                            <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="GLItemFillAll('lstCostItem<%=i %>','ItemCostNameDesc','lstCostItemChange<%=i %>',140)"
                                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9; border-left: 0px solid #7F9DB9; cursor: hand;" />
                                                        </td>
                                                    </tr>
                                                </table>
                                                <!-- End JPED -->
                                            </div>
                                            <script type="text/javascript">
    lstCostItemChange<%=i %>("<%=aCostItemNo(i) %>",null);
    makeAllReadOnlyStyle(document.getElementById("CostItemDivContainer<%=i %>"));
                                            </script>
                                            <input name="txtCostDesc<%= i %>" type="hidden" class="d_shorttextfield ItemCostDesc" id="ItemCostDesc"
                                                value="<%= aCostDesc(i) %>" size="34" readonly="true" />
                                        </td>
                                        <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodyheader">
                                            <input name="txtCost<%= i %>" type="text" class="numberfield ItemCost" id="ItemCost" onchange="CostChange(<%= i %>)"
                                                value="<%= formatNumber(aRealCost(i),2,,,0) %>" size="13" readonly="true" />
                                        </td>
                                        <td align="left" valign="middle" bgcolor="#FFFFFF">
                                            <div id="VendorDivContainer<%=i %>">
                                                <!-- Start JPED -->
                                                <input type="hidden" id="hVendorAcct<%=i %>" name="hVendorAcct<%=i %>" />
                                                <div id="lstVendorName<%=i %>Div">
                                                </div>
                                                <table cellpadding="0" cellspacing="0" border="0">
                                                    <tr>
                                                        <td>
                                                            <input type="text" autocomplete="off" id="lstVendorName<%=i %>" name="lstVendorName<%=i %>"
                                                                value="" class="shorttextfield" style="width: 220px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;"
                                                                onkeyup="organizationFill(this,'Vendor','lstVendorNameChange<%=i %>',null,event)"
                                                                onfocus="initializeJPEDField(this,event);" />
                                                        </td>
                                                        <td>
                                                            <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstVendorName<%=i %>','Vendor','lstVendorNameChange<%=i %>',null,event)"
                                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9; border-left: 0px solid #7F9DB9; cursor: hand;" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                            <!-- End JPED -->
                                            <script type="text/javascript">
    lstVendorNameChange<%=i %>("<%=aVendor(i) %>","<%=GetBusinessName(aVendor(i)) %>");
    makeAllReadOnlyStyle(document.getElementById("VendorDivContainer<%=i %>"));
                                            </script>
                                        </td>
                                        <td bgcolor="#FFFFFF">
                                            <input name="txtRefNo<%= i %>" type="text" class="d_shorttextfield" value="<%= aRefNo(i) %>"
                                                size="15" readonly="true" id="txtRefNo<%= i %>" />
                                        </td>
                                        <td bgcolor="#FFFFFF">
                                            <span class="goto"><a href="javascrip:;" onclick="goLink('<%=aAPLock(i)%>'); return false;">A/P posted </a></span>
                                        </td>
                                    </tr>
                                    <% end if %>
                                    <% next %>
                                    <tr>
                                        <td align="right" bgcolor="#FFFFFF">&nbsp;
                                        </td>
                                        <td height="20" align="left" valign="middle" bgcolor="#FFFFFF">&nbsp;
                                        </td>
                                        <td align="left" valign="middle" bgcolor="#FFFFFF" class="Total14pt">&nbsp;
                                        </td>
                                        <td align="left" valign="middle" bgcolor="#FFFFFF">&nbsp;
                                        </td>
                                        <td bgcolor="#FFFFFF">&nbsp;
                                        </td>
                                        <td bgcolor="#FFFFFF">
                                            <img src="../images/button_addcost_item.gif" width="94" height="18" name="bAddItem"
                                                onclick="AddCostItem()" <% if UserRight<5 Or Not Branch="" then response.write("disabled") %>
                                                style="cursor: hand">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="#F3f3f3">&nbsp;
                                        </td>
                                        <td align="right" bgcolor="#F3f3f3">
                                            <strong><font color="c16b42" style="padding-right: 10px">Total Cost</font></strong>
                                        </td>
                                        <td align="left" bgcolor="#F3f3f3">
                                            <input type="text" name="txtTotalCost" class="numberfield" value="<%=formatNumber(TotalCost,2,,,0) %>"
                                                readonly="true" size="13" style="font-weight: bold" id="txtTotalCost">
                                        </td>
                                        <td bgcolor="#F3f3f3" colspan="3">&nbsp;
                                        </td>
                                    </tr>
                                </table>
                                <br />
                                <table cellpadding="0" cellspacing="0" border="0" style="border: solid 1px #89A979; width: 90%"
                                    class="border1px" align="center">
                                    <tr>
                                        <td bgcolor="f3f3f3"></td>
                                        <td colspan="7" style="background-color: #ffffff">
                                            <table cellpadding="2" cellspacing="0" border="0" style="height: 100%">
                                                <tr class="bodyheader">
                                                    <td>Remarks
                                                    </td>
                                                    <td>Internal Memo
                                                    </td>
                                                    <td></td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <textarea name="txtRemarks" cols="45" rows="4" class="multilinetextfield"
                                                            id="txtRemarks"><%= vRemarks %></textarea>
                                                    </td>
                                                    <td>
                                                        <textarea name="txtInMemo" cols="50" rows="4" class="multilinetextfield"
                                                            id="txtInMemo"><%= vInMemo %></textarea>
                                                    </td>
                                                    <td class="bodyheader" style="vertical-align: top">
                                                        <% If MasterInvoiceNo <> "" Then %>
                                                    This invoice is a additional invoice of orginal invoice
                                                    <%=MasterInvoiceNo %>
                                                    .
                                                    <% End IF %>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="8" style="height: 10px; background-color: #ffffff"></td>
                                    </tr>
                                </table>
                                <br />
                            </td>
                        </tr>
                        <tr>
                            <td height="24" align="center" valign="middle" bgcolor="D5E8CB">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="24%" valign="middle">
                                            <img src="../images/button_save_new.gif" name="bSaveAsNew" width="88" height="18"
                                                onclick="SaveAsNewClick(<%= TranNo %>,'NO')" <% if UserRight<5 or Not Branch="" or vInvoiceAccessType="G" then response.write("disabled") %>
                                                style="cursor: hand" alt="" />
                                        </td>
                                        <td width="52%" align="center" valign="middle">
                                            <% If UserRight < 5 Or Branch <> "" Or vInvoiceAccessType = "G" Then %>
                                            <% Else %>
                                            <img src="../images/button_save_medium.gif" width="46" height="18" name="bSave" onclick="SaveClick(<%= TranNo %>,'NO')"
                                                style="cursor: hand" alt="" />
                                            <% End If %>
                                        </td>
                                        <td width="12%" align="right" valign="middle">&nbsp;
                                        </td>
                                        <td width="12%" align="right" valign="middle">
                                            <% if UserRight = 9 And  InvoiceNo > 0 And vvvLockAR <> "Y" And vvvLockAP <> "Y" AND vInvoiceAccessType <> "G" then %>
                                            <img src="../images/button_delete_medium.gif" onclick="javascript:deleteInvoice('<%=InvoiceNo %>');"
                                                style="cursor: hand" alt="" />
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
        <table width="95%" height="32" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td align="right" valign="bottom">
                    <div id="print">
                        <img src="/ASP/Images/icon_printer.gif" width="40" height="27" align="absbottom"
                            alt="" /><a href="javascript:;" onclick="PDFClick();return false;">Invoice</a><img
                                src="/ASP/Images/button_devider.gif" width="19" height="10" alt="" /><a href="javascript:;"
                                    onclick="StmtClick();return false;">Agent Statement</a>
                    </div>
                </td>
            </tr>
        </table>
        <br />
    </form>
</body>
<script language="javascript" type="text/javascript" src="/ASP/ajaxFunctions/ajax_ig_call_db.js">  </script>
<script type="text/javascript">
    function docModified(dummy) {
    }
    
    function SearchCustomer(){
        var CustomerName=document.form1.txtqCustomerName.value;
        if (CustomerName != "") {
            document.form1.action = "edit_invoice.asp?new=yes&tNo=" + "<%=TranNo%>" + "&qCustomer=yes" + "&WindowName=" + window.name;
            document.form1.method = "POST";
            document.form1.target = "_self";
            form1.submit();
        }
    }

    function SaveClick(TranNo,PrintINV){
        if( !check_ar_ap() )
            return false;

        var NoItem = document.form1.hNoItem.value;
        var NoCostItem = document.form1.hNoCostItem.value;
        var OK = true;
        //alert('a');
        var CustomerNumber = document.form1.txtCustomerNumber.value;
        if (CustomerNumber == "" ) 
            CustomerNumber=0;
        if (CustomerNumber == 0 ||CustomerNumber=="0"||CustomerNumber=="") {
            alert( "Please enter a Customer!");
            return;
        }

        for(var j=1 ; j<=NoItem; j++){
            var oAmt = $("input.ItemAmount").get(j - 1).value;
            if (oAmt == "" ) 
                oAmt = 0;
            var oItem = document.getElementById("hChargeItem" + (j - 1)).value;

            if (oCost != 0 && oAmt == "" ){
                alert( "Please select (a) charge items(s)");
                return;
            }
        }
 
        for(var j=1 ; j<=NoCostItem; j++){
            var oCost = parseFloat($("input.ItemCost").get(j - 1).value).toFixed(0);
            if( oCost == "" )
                oCost = 0;
            var oVendor = document.getElementById("hVendorAcct"+(j-1)).value;
            if( oVendor == "" )
                oVendor = 0;
            var oItem = document.getElementById("hCostItem"+(j-1)).value;

            //	        if (oCost != 0 && oItem == "" ){
            //		        alert( "Please select (a) cost items(s)");
            //		        return;
            //	        }
            //alert(oCost);
            //if (oCost!= 0 && oVendor == 0 ){
            //    alert( "Please select (a) vendor(s).");
            //    return;
            //}
        }
    
        var EntryDate=document.form1.txtEntryDate.value;
      
        if ( EntryDate!="" ){
           
            if (! IsDate(EntryDate) ){
                alert( "Please enter the entry date in MM/DD/YYYY format!");
                return;
            }
        }
        var InvoiceDate=document.form1.txtInvoiceDate.value;
        if (InvoiceDate=="" ){
            alert( "Please enter the Invoice Date!");
            return;
        }
        if (!IsDate(InvoiceDate)) {
            alert( "Please enter Credit Note Date in (MM/DD/YYYY) format!");
            return;
        }
    
        var InvoiceNo=document.form1.txtInvoiceNo.value;

        if ( InvoiceNo!="" )
            document.form1.action="edit_invoice.asp?save=yes&tNo=<%=TranNo %>&InvoiceNo=" + InvoiceNo + "&PrintINV=<%=PrintINV %>&WindowName=" + window.name;
        else
            document.form1.action="edit_invoice.asp?save=yes&tNo=<%=TranNo %>&PrintINV=<%=PrintINV %>&WindowName=" + window.name;

        //'MSGBOX "BEFORE SAVE"
        document.form1.method = "POST";
        document.form1.target = "_self";
        form1.submit();
    }

    function SaveAsNewClick(TranNo,PrintINV){

        var InvoiceNo = document.form1.txtInvoiceNo.value;

        if (!confirm("This will create and copy to new Invoice with reference from I/V:"+InvoiceNo +". \r\nPlease click Yes to continue."))
            return false;

        var NoItem = document.form1.hNoItem.value;
        var NoCostItem = document.form1.hNoCostItem.value;
        var OK = true;
        var CustomerNumber = document.form1.txtCustomerNumber.value;
        if (CustomerNumber == "")
            CustomerNumber = 0;
        if (CustomerNumber == 0 || CustomerNumber == "0" || CustomerNumber == "") {
            alert("Please enter a Customer!");
            return;
        }

        for (var j = 1; j <= NoItem; j++) {
            var oAmt = $("input.ItemAmount").get(j - 1).value;
            if (oAmt == "")
                oAmt = 0;
            var oItem = document.getElementById("hChargeItem" + (j - 1)).value;

            if (oCost != 0 && oAmt == "") {
                alert("Please select (a) charge items(s)");
                return;
            }
        }
    
        for (var j = 1; j <= NoCostItem; j++) {
            var oCost = parseFloat($("input.ItemAmount").get(j - 1).value).toFixed(0);
            if (oCost == "")
                oCost = 0;
            var oVendor = document.getElementById("hVendorAcct" + (j - 1)).value;
            if (oVendor == "")
                oVendor = 0;
            var oItem = document.getElementById("hCostItem" + (j - 1)).value;

            if (oCost != 0 && oItem == "") {
                alert("Please select (a) cost items(s)");
                return;
            }
            if (oCost != 0 && oVendor == 0) {
                alert("Please select (a) vendor(s)");
                return;
            }
        }
        var EntryDate = document.form1.txtEntryDate.value;
        if (EntryDate != "") {
            if (!IsDate(EntryDate)) {
                alert("Please enter the entry date in MM/DD/YYYY format!");
                return;
            }
        }
        var InvoiceDate = document.form1.txtInvoiceDate.value;
        if (InvoiceDate == "") {
            alert("Please enter an Credit Note Date!");
            return;
        }
        if (!IsDate(InvoiceDate)) {
            alert("Please enter Credit Note Date in (MM/DD/YYYY) format!");
            return;
        }
        //'InvoiceType=document.form1.hInvoiceType.Value
        document.form1.txtInvoiceNo.value = "";
        InvoiceNo = document.form1.txtInvoiceNo.value;
        document.form1.action = "edit_invoice.asp?save=yes&AsNew=Y&tNo=<%=TranNo %>&PrintINV=<%=PrintINV %>&WindowName=" + window.name;
        document.form1.method = "POST";
        document.form1.target = "_self";
        form1.submit();
    }


    function check_ar_ap(){
        var arLock = "<%=vvvLockAR%>";
        var apLock = "<%=vvvLockAP%>";

        return true;
    }
    function AddItem(){
        var InvoiceNo = document.form1.txtInvoiceNo.value;
        document.form1.hNoItem.value = parseInt(document.form1.hNoItem.value) + 1;
        document.form1.action = "edit_invoice.asp?new=yes&tNo=" + "<%=TranNo%>" + "&AddItem=yes" + "&InvoiceNo=" + InvoiceNo + "&WindowName=" + window.name;
        document.form1.method = "POST";
        document.form1.target = "_self";
        form1.submit();
    }

    function AddCostItem(){
        //if( NOT check_ar_ap() ) then exit sub
        var InvoiceNo = document.form1.txtInvoiceNo.value;
        if (document.form1.hNoCostItem.value == "")
            document.form1.hNoCostItem.value = 0;

        document.form1.hNoCostItem.value = parseInt(document.form1.hNoCostItem.value) + 1;
        document.form1.action = "edit_invoice.asp?new=yes&tNo=" + "<%=TranNo%>" + "&AddCostItem=yes" + "&InvoiceNo=" + InvoiceNo + "&WindowName=" + window.name;
        document.form1.method = "POST";
        document.form1.target = "_self";
        form1.submit()
    }

    function DeleteItem(rNo){
        var InvoiceNo = document.form1.txtInvoiceNo.value;
        if (confirm("Are you sure you want to delete this item?\r\nContinue?")) {
            document.form1.action = "edit_invoice.asp?new=yes&tNo=" + "<%=TranNo%>" + "&Delete=yes&rNo=" + rNo + "&InvoiceNo=" + InvoiceNo + "&WindowName=" + window.name;
            document.form1.method = "POST";
            document.form1.target = "_self";
            form1.submit()
        }
    }

    function DeleteCostItem(rNo){
        var InvoiceNo = document.form1.txtInvoiceNo.value;
        if (confirm("Are you sure you want to delete this item?\r\nContinue?")) {
            document.form1.action = "edit_invoice.asp?new=yes&tNo=" + "<%=TranNo%>" + "&DeleteCost=yes&rNo=" + rNo + "&InvoiceNo=" + InvoiceNo + "&WindowName=" + window.name;
            document.form1.method = "POST";
            document.form1.target = "_self";
            form1.submit()
        }
    }
    

</script>
<script type="text/vbscript">

/////////////////////////////' Not using
Sub ItemChange(rNo)
/////////////////////////////
    On Error Resume Next:
	//'if( NOT check_ar_ap() ) then exit sub
    sIndex=document.all("InvoiceItem").item(rNo).selectedindex
    itemInfo=document.all("InvoiceItem").item(rNo).value
    if sIndex=1 then
	    viewPop2 "PopWin", "../acct_tasks/edit_ch_items.asp"
    else
	    pos=0
	    pos=instr(itemInfo,chr(10))
	    if pos>0 then
		    Desc=Mid(itemInfo,pos+1,100)

		    //' Unit_Price by ig 10/21/2006
		    DIM ItemUnitPrice
		    ItemUnitPrice = GET_ITEM_UNIT_PRICE ( Desc )

		    pos=Instr(Desc,chr(10))
		    if pos > 0 then
			    Desc=Mid(Desc,1,pos-1)
		    end if

		    document.all("ItemDesc").item(rNo).Value=LTRIM(Desc)
    		
		    //' Unit_Price by ig 10/21/2006
		    CALL SET_UNIT_PRICE ( Document.all("ItemAmount").item(rNo) , ItemUnitPrice )
    		
	    end if
    end if
End Sub

/////////////////////////////' Not using
Sub ItemCostChange(rNo)
/////////////////////////////
	//'if( NOT check_ar_ap() ) then exit sub
    On Error Resume Next:
    sIndex=document.all("InvoiceCostItem").item(rNo).selectedindex
    itemInfo=document.all("InvoiceCostItem").item(rNo).value
    if sIndex=1 then

    viewPop2 "PopWin", "../acct_tasks/edit_co_items.asp"

    else
	    pos=0
	    pos=instr(itemInfo,chr(10))
	    if pos>0 then
		    Desc=Mid(itemInfo,pos+1,100)
    		
		    //' Unit_Price by ig 10/21/2006
		    DIM ItemUnitPrice
		    ItemUnitPrice = GET_ITEM_UNIT_PRICE ( Desc )
    		
		    pos=Instr(Desc,chr(10))
		    if pos > 0 then
			    Desc=Mid(Desc,1,pos-1)
		    end if
    		
		    document.all("ItemCostDesc").item(rNo).Value=LTRIM(Desc)
    		
		    //' Unit_Price by ig 10/21/2006
		    CALL SET_UNIT_PRICE ( Document.all("ItemCost").item(rNo) , ItemUnitPrice )
    		
	    end if
    end if

End Sub


//////////////////////////////////
// Unit_Price by ig 10/21/2006
//////////////////////////////////
Function GET_ITEM_UNIT_PRICE ( tmpBuf )
    On Error Resume Next:
    DIM ItemUnitPrice,pos
    ItemUnitPrice=0
    pos=Instr(tmpBuf,chr(10))
    if pos>0 then
	    ItemUnitPrice=Mid(tmpBuf,pos+1,200)
    end if
    GET_ITEM_UNIT_PRICE = ItemUnitPrice

End Function

sub SET_UNIT_PRICE( obj, val )
    obj.value = FormatNumber(val,2,,,0)
end sub
//////////////////////////////////

</script>
<script type="text/javascript">

    function AmountChange(ItemNo){
        var NoItem=parseInt(document.form1.hNoItem.value);
        var tAmount = $("input.ItemAmount").get(ItemNo).value;
        if (parseInt(NoItem) > 0) {
            if (!IsNumeric(tAmount)) {
                alert("Please enter a numeric number!");
                $("input.ItemAmount").get(ItemNo).value = 0;
                return;
            }
            var TotalAmount = 0;
            for (var j = 0; j < NoItem; j++) {
                var Amount = $("input.ItemAmount").get(j).value;
                if (Amount == "")
                    Amount = 0;
                else
                    Amount = parseFloat(Amount);

                TotalAmount = TotalAmount + Amount;
            }
            document.form1.txtSubTotal.value = parseFloat(TotalAmount).toFixed(2);
            document.form1.txtTotalCharge.value = parseFloat(TotalAmount).toFixed(2);
            var Tax = document.form1.txtSaleTax.value;
            if (Tax == "")
                Tax = 0;
            else
                Tax = parseFloat(Tax);

            var AgentProfit = document.form1.txtAgentProfit.value;
            if (AgentProfit == "")
                AgentProfit = 0;
            else
                AgentProfit = parseFloat(AgentProfit);

            TotalAmount = TotalAmount + Tax - AgentProfit;
            document.form1.txtTotalAmount.value = parseFloat(TotalAmount).toFixed(2);
        }
    }
    function CostChange(ItemNo){

        var tCost=$("input.ItemCost").get(ItemNo).value;

        if (tCost!="" ){
            if (!IsNumeric(tCost)) {
                alert( "Please enter a numeric number!");
                $("input.ItemCost").get(ItemNo).value=0;
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

        document.form1.txtTotalCost.value = parseFloat(TotalCost).toFixed(2);  //FormatNumber(TotalCost,2,,,0)

    }

    function LookupIV(){
        var InvoiceNo=document.form1.txtqInvoiceNo.value;
        if (InvoiceNo == "" || InvoiceNo == "Search Here") {
            alert("Please enter Invoice No. first!");
            return;
        }

        document.form1.txtqInvoiceNo.value = "";
        document.form1.action = "edit_invoice.asp?edit=yes&tNo=" + "<%=TranNo%>" + "&InvoiceNo=" + InvoiceNo + "&WindowName=" + window.name;
        document.form1.method = "POST";
        document.form1.target = "_self";
        form1.submit()
    }

    function AgentProfitChange(){
        if( ! check_ar_ap() )
            return false;

        var SubTotal=document.form1.txtSubTotal.value;
        if (SubTotal=="")
            SubTotal = 0;

        var SubTotal=parseFloat(SubTotal);
        var SaleTax=document.form1.txtSaleTax.value;
        if (SaleTax=="" )
            SaleTax = 0;

        var SaleTax=parseFloat(SaleTax);
        var AgentProfit=document.form1.txtAgentProfit.value;
        if (AgentProfit == "")
            AgentProfit = 0;

        var AgentProfit=parseFloat(AgentProfit);
        var Total=SubTotal+SaleTax-AgentProfit;
        document.form1.txtTotalAmount.value=Total;
    }
</script>
<script type="text/javascript">
    function StmtClick(){
        var InvoiceNo = document.form1.txtInvoiceNo.value;
        if (InvoiceNo == "" || InvoiceNo == "Search Here") {
            alert("Please save Invoice data first!");
            return;
        }

        //' by iMoon 2/22/2007
        var iType;
        if (document.form1.hAO.value == "OCEAN" )
            iType = "O";
        else
            iType = "A";

        var MAWB = document.form1.txtMAWB.value;
        var AgentNo = document.form1.txtCustomerNumber.value;
        var InvoiceDate = document.form1.txtInvoiceDate.value;

        //' jPopUpPDF()
        document.form1.action = "agent_stmt.asp?iType=" + iType + "&MAWB=" + MAWB + "&AgentNo=" + AgentNo + "&WindowName=" + window.name;
        document.form1.method = "POST";
        document.form1.target = "_self";
        form1.submit();

    }

    function PDFClick()
    {
        var InvoiceNo=document.form1.txtInvoiceNo.value;
        if (InvoiceNo == "" || InvoiceNo == "Search Here") {
            alert("Please save Invoice data first!");
            return;
        }
        //' viewPop2 "PopWin", "invoice_pdf.asp?InvoiceNo=" & InvoiceNo & "&WindowName=" & window.name

        //' jPopUpPDF()
        document.form1.action = "invoice_pdf.asp?Branch=" + "<%=Branch%>" + "&InvoiceNo=" + InvoiceNo + "&WindowName=" + window.name;
        document.form1.method = "POST";
        document.form1.target = "_self";
        form1.submit();

    }
    function ProfitAdj() {
        var InvoiceNo=document.form1.txtInvoiceNo.value;
        // NewInvoice="<%= NewInvoice %>"
        if (InvoiceNo == "0" || InvoiceNo == "" ){
            alert( "Please save Invoice data first!");
            return false;
        }
        var currUrl = location.href;
        var temp = currUrl.split("?");
        var qStr = temp[1];
        if (currUrl.indexOf("InvoiceNo") < 0) {
            qStr = "InvoiceNo=" + InvoiceNo + "&" + qStr;
        }
        jPopUpNormal();

        if ("<%=vAO%>" == "OCEAN" )
            document.form1.action="of_cost_adjustment.asp?" + qStr + "&WindowName=popUpWin"
        else
            document.form1.action="af_cost_adjustment.asp?"+qStr + "&WindowName=popUpWin"

        document.form1.method = "POST";
        document.form1.target = "popUpWindow";
        form1.submit();

    }

    function HAWBChange(){
        var sindex=Document.form1.lstHAWB.selectedIndex;
        var URL=document.form1.lstHAWB.item(sindex).value;

        if (sindex > 0) {
            document.form1.txtHAWB.Value = Document.form1.lstHAWB.item(sindex).text;
            document.form1.action = "edit_invoice.asp?HAWB=yes" + "&tNo=" + "<%=TranNo%>" + "&WindowName=" + window.name;
            document.form1.method = "POST";
            document.form1.target = "_self";
            form1.submit();
        }
    }

    function CheckBlank(arg1, arg2) { //converted from vbscript
        var result;
        if (IsNull(arg1))
            result = arg2;
        else {
            if (arg1 == "")
                result = arg2;
            else
                result = arg1;
        }
        return result;
    }

</script>
<script type="text/javascript">

    function selectSetValue(oList, sValue) {

        for (var i = 0; i < oList.children.length; i++) {
            if (sValue == oList.options[i].value) {
                oList.options[i].selected = true;
                return true;
            }
        }
        return false;
    }
</script>
<% If InvoiceNo > 0 And Not vvvLockAR = "Y" And Not vvvLockAP = "Y" Then %>
<script type="text/jscript">
    function deleteInvoice(arg) {
        var input_box = confirm("Do you really want to delete this invoice?");

        if (input_box == true) {
            try {
                var xmlHTTP ;
                if (window.ActiveXObject) {
                    try {
                        xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
                    } catch (error) {
                        try {
                            xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
                        } catch (error) { return ""; }
                    }
                }
                else if (window.XMLHttpRequest) {
                    xmlHTTP = new XMLHttpRequest();
                }
                else { return ""; }


                
                var param = 'n=' + arg;
                xmlHTTP.open("get", "/ASP/include/delete_invoice.asp?" + param, false);
                xmlHTTP.send();
                var resultCode = xmlHTTP.responseText;
                resultCode = "ok";
                if (resultCode.indexOf('ok') >= 0) {
                    alert("The Invoice has been deleted successfully.");
                    if (window.name == "") {
                        window.location.href = "edit_invoice.asp";
                    }
                    else {
                        window.close();
                    }
                }
                else {
                    alert("Failed to delete the invoice (Error Code: " + resultCode + ").");
                }
            }
            catch (e) { alert("Internal Error Occurred: " + e); }
        }
    }
</script>
<script type="text/vbscript">



/////////////////////////////
Sub key()   'not used
/////////////////////////////
    On Error Resume Next:
    document.form1.hQueueID.Value=0
    InvoiceNo=document.form1.txtInvoiceNo.value
    if Window.event.Keycode=13 then
	    document.form1.action="edit_invoice.asp?edit=yes&tNo=" & "<%=TranNo%>" & "&InvoiceNo=" & InvoiceNo & "&WindowName=" & window.name
	    document.form1.method="POST"
	    document.form1.target=window.name
	    form1.submit()
    end if
End Sub


/////////////////////////////
Sub PrintClick()    'not used
/////////////////////////////
    On Error Resume Next:
    //' Print Port Query
    Dim vPrintPort
    vPrintPort = queryPort( "<%=invoicePort%>", "<%=invoiceQueue%>" )
    if( vPrintPort = "-1" ) then exit sub
    ////////////////////

    Dim CustomerInfo(5),vCustomerInfo,InvoiceNo,InvoiceDate,RefNo,vFileNo
    Dim TotalPieces,TotalGrossWeight,Description
    Dim Customer
    Dim OriginDest,CustomerNumber
    Dim EntryNo,EntryDate
    Dim Carrier,ArrivalDept
    Dim MAWB,HAWB
    Dim Remarks(8)
    Dim NoItem,aDesc(128),aAmount(128)
    Dim TotalAmount
    vCustomerInfo=document.form1.txtCustomerInfo.value

    pos=Instr(vCustomerInfo,chr(10))

    i=0
    do While pos>0 And i<5
	    CustomerInfo(i)=Left(vCustomerInfo,pos-2)
	    vCustomerInfo=Mid(vCustomerInfo,pos+1,2000)
	    pos=Instr(vCustomerInfo,chr(10))
	    i=i+1
    loop
    CustomerInfo(i)=vCustomerInfo

    InvoiceNo=document.form1.txtInvoiceNo.Value
    If InvoiceNo = "0" Or InvoiceNo = "" Then
	    MsgBox "Please save Invoice data first!"
	    Exit sub
    End if

    InvoiceDate=document.form1.txtInvoiceDate.Value
    RefNo=document.form1.txtRefNo.Value
    RefNoOur=document.form1.txtFileNo.Value

    TotalPieces=document.form1.txtTotalPiece.Value
    TotalGrossWeight=document.form1.txtTotalGrossWeight.Value
    Description=document.form1.txtDescription.Value
    vShipper=document.form1.txtShipper.value
    OriginDest=Mid(document.form1.txtOriginDest.value,1,23)
    CustomerNumber=document.form1.txtCustomerNumber.value
    EntryNo=document.form1.txtEntryNo.value
    EntryDate=document.form1.txtEntryDate.value
    Carrier=document.form1.txtCarrier.value
    ArrivalDept=document.form1.txtArrivalDept.value
    MAWB=document.form1.txtMAWB.value
    HAWB=document.form1.txtHAWB.value

    NoItem=Cint(document.form1.hNoItem.Value)
    for i=0 to NoItem-1
	    aDesc(i)=document.all("ItemDesc").item(i).value
	    aAmount(i)=Mid(FormatCurrency(document.all("ItemAmount").item(i+1).value),2,100)

    next
    TotalAmount=document.form1.txtTotalAmount.value

    for i=0 to 7
	    Remarks(i)=""
    next


    Set fso = CreateObject("Scripting.FileSystemObject")

    If Not fso.FolderExists("C:\TEMP") Then
	    Set f = fso.CreateFolder("C:\TEMP")
    End If

    If Not fso.FolderExists("C:\TEMP\Eltdata" ) Then
	    Set f = fso.CreateFolder("C:\TEMP\Eltdata" )
    End If

    Set MyFile = fso.CreateTextFile("C:\TEMP\Eltdata\invoice" & InvoiceNo & ".txt", True)
    MyFile.WriteLine(chr(27) & "C" & chr(51))

    Dim Line(40)
    pTop=10
    pLeft=2

    for i=1 to pTop
	    MyFile.WriteLine("")
    next

    Line(1)= Space(45) & InvoiceNo
    Line(1)= Line(1) & Space(57-Len(line(1))) & InvoiceDate
    Line(1)= Line(1) & Space(69-Len(line(1))) & RefNo
    Line(1)= Space(pLeft) & Line(1)

    Line(2)=""
    for i=3 to 7
	    Line(i)=Space(pLeft+1) & CustomerInfo(i-3)
    next

    line(8)=""
    line(9)=Space(42) & aDesc(0)
    line(9)=line(9) & Space(69-Len(line(9))) & aAmount(0)
    line(9)=Space(pLeft) & line(9)
    line(10)=""

    line(11)=TotalPieces

    if Len(line(11)) < 7 then
    line(11)=line(11) & Space(6-Len(line(11))) & TotalGrossWeight
    else
    line(11)=line(11) & Space(10-Len(line(11))) & TotalGrossWeight
    end if

    if Len(line(11)) < 13 then
    line(11)=line(11) & Space(13-Len(line(11))) & Description
    else
    line(11)=line(11) & Space(20-Len(line(11))) & Description
    end if

    line(11)=line(11) & Space( CalcSpace( 46, Len(line(11)) ) ) & aDesc(1)
    line(11)=line(11) & Space( CalcSpace( 69, Len(line(11)) ) ) & aAmount(1)
    line(11)=Space(pLeft) & line(11)

    line(12)=""
    line(13)=Space(42) & aDesc(2)
    line(13)=line(13) & Space( CalcSpace( 69, Len(line(13)) ) ) & aAmount(2)
    line(13)=Space(pLeft) & line(13)
    line(14)=Space(pLeft) & vShipper
    line(15)=Space(42) & aDesc(3)
    line(15)=line(15) & Space( CalcSpace( 69, Len(line(15)) ) ) & aAmount(3)
    line(15)=Space(pLeft) & line(15)
    line(16)=""
    line(17)=OriginDest
    line(17)=line(17) & Space( CalcSpace( 25, Len(line(17)) ) ) & CustomerNumber
    line(17)=line(17) & Space( CalcSpace( 42, Len(line(17)) ) ) & aDesc(4)
    line(17)=line(17) & Space( CalcSpace( 69, Len(line(17)) ) ) & aAmount(4)
    line(17)=Space(pLeft) & line(17)
    line(18)=""
    line(19)=Space(42) & aDesc(5)
    line(19)=line(19) & Space( CalcSpace( 69, Len(line(19)) ) ) & aAmount(5)
    line(19)=Space(pLeft) & line(19)
    line(20)=EntryNo
    line(20)=line(20) & Space( CalcSpace( 23, Len(line(20)) ) ) & EntryDate
    line(21)=Space(42) & aDesc(6)
    line(21)=line(21) & Space( CalcSpace( 69, Len(line(21)) ) ) & aAmount(6)
    line(21)=Space(pLeft) & line(21)
    line(22)=""
    line(23)=Carrier
    line(23)=line(23) & Space( CalcSpace( 25, Len(line(23)) ) ) & ArrivalDept
    line(23)=line(23) & Space( CalcSpace( 42, Len(line(23)) ) ) & aDesc(7)
    line(23)=line(23) & Space( CalcSpace( 69, Len(line(23)) ) ) & aAmount(7)
    line(23)=Space(pLeft) & line(23)
    line(24)=""
    line(25)=Space(42) & aDesc(8)
    line(25)=line(25) & Space( CalcSpace( 69, Len(line(25)) ) ) & aAmount(8)
    line(25)=Space(pLeft) & line(25)
    line(26)=MAWB
    line(26)=line(26) & Space( CalcSpace( 23, Len(line(26)) ) ) & HAWB
    line(27)=Space(42) & aDesc(9)
    line(27)=line(27) & Space( CalcSpace( 69, Len(line(27)) ) ) & aAmount(9)
    line(27)=Space(pLeft) & line(27)
    line(28)=Space(pLeft) & Remarks(0)
    line(29)=Remarks(1)
    line(29)=line(29) & Space( CalcSpace( 42, Len(line(29)) ) ) & aDesc(10)
    line(29)=line(29) & Space( CalcSpace( 69, Len(line(29)) ) ) & aAmount(10)
    line(29)=Space(pLeft) & line(29)
    line(30)=Space(pLeft) & Remarks(2)
    line(31)=Remarks(3)
    line(31)=line(31) & Space( CalcSpace( 42, Len(line(31)) ) ) & aDesc(11)
    line(31)=line(31) & Space( CalcSpace( 69, Len(line(31)) ) ) & aAmount(11)
    line(31)=Space(pLeft) & line(31)
    line(32)=Space(pLeft) & Remarks(4)
    line(33)=Remarks(5)
    line(33)=line(33) & Space( CalcSpace( 42, Len(line(33)) ) ) & aDesc(12)
    line(33)=line(33) & Space( CalcSpace( 69, Len(line(33)) ) ) & aAmount(12)
    line(33)=Space(pLeft) & line(33)
    line(34)=Space(pLeft) & Remarks(6)
    line(35)=Remarks(7)
    line(35)=line(35) & Space( CalcSpace( 42, Len(line(35)) ) ) & aDesc(13)
    line(35)=line(35) & Space( CalcSpace( 69, Len(line(35)) ) ) & aAmount(13)
    line(35)=Space(pLeft) & line(35)
    line(36)=""
    line(37)=Space(69) & TotalAmount
    line(37)=Space(pLeft) & line(37)

    For i=1 to 40
	    MyFile.WriteLine(Line(i))
    next

    MyFile.Close
    Set MyFile=Nothing

    DIM fileName 
    fileName = "c:\TEMP\EltData\invoice" & InvoiceNo & ".txt"

    DIM tmpPort
    tmpPort = TRIM(UCASE(vPrintPort))

    if tmpPort = "LPT1" or tmpPort = "LPT2" or tmpPort = "LPT3" or tmpPort = "LPT4" or tmpPort = "LPT5" _ 
    or tmpPort = "LPT6" or tmpPort = "LPT7" or tmpPort = "LPT8" then
	    Call ELTClient.ELTPrintForm(FileName,vPrintPort)
    else
	    Call ELTClient.ELTPrintFormWithNetwork(FileName,vPrintPort)
    end if
    Sleep 2
    //' LPT9 port init
    Call ELTClient.ELTPrintPortInit()

End Sub

Sub Sleep(tmpSeconds) 'not used
    On Error Resume Next:
    Dim dtmOne,dtmTwo
    dtmOne = Now()
    While DateDiff("s",dtmOne,dtmTwo) < tmpSeconds
	    dtmTwo = Now()
    Wend
End Sub



/////////////////////////////
Sub MenuMouseOver()
/////////////////////////////
    document.form1.lstAR.style.visibility="hidden"
    document.form1.lstCGS.style.visibility="hidden"
End Sub

/////////////////////////////
Sub MenuMouseOut()
/////////////////////////////
    document.form1.lstAR.style.visibility="visible"
    document.form1.lstCGS.style.visibility="visible"
End Sub

Function CalcSpace(Space_Length, Line_Length) 'not used
    tmpSpace = Space_Length-Line_Length
    if tmpSpace < 0 then
        tmpSpace = Space_Length + ABS(tmpSpace)
    else
        tmpSpace = Space_Length
    end if
    CalcSpace = tmpSpace
End Function

</script>
<script type="text/vbscript">
    if "<%= PrintINV %>" = "YES" then
	    Call PrintClick()
    end if
</script>
<% end if %>
<script type="text/jscript">
    function goClientProfile(TxtName) {
        var oTxtClass = document.getElementById(TxtName);
        var param = 'PostBack=false&default=' + encodeURIComponent(oTxtClass.value);
        var retVal = showModalDialog("../Include/all_dba_manage.asp?" + param, "AllDba", "dialogWidth:620px; dialogHeight:700px; help:0; status:0; scroll:0;center:1;Sunken;");
        try {
            if (retVal != '' && typeof (retVal) != 'undefined') {
                goProfile(retVal + ":");
            }
        } catch (f) { }
    }

    function goProfile(n) {
        if (n) {
            if (n.indexOf(':') < 0) { n += ':'; }
            var url = '../master_data/client_profile.asp?Action=filter' + '&n=' + n;
            window.open(url, 'PopWin', 'staus=0,titlebar=0,toolbar=1,menubar=1,scrollbars=1,resizable=1,location=0,width=1024,height=800,hotkeys=0');
        } else {
            var url = '../master_data/client_profile.asp';
            window.open(url, 'PopWin', 'staus=0,titlebar=0,toolbar=1,menubar=1,scrollbars=1,resizable=1,location=0,width=1024,height=800,hotkeys=0');
        }
    }

    function SetBillNumber(arg) {
        var vURL = "./set_bill_number.asp?Type=" + arg;

        // var resVal = showModalDialog(vURL, "Set Bill Number","dialogWidth:310px; dialogHeight:300px; help:0; status:1; scroll:0; center:1; Sunken;");

    }

    var memGW = null;
    var memCW = null;

    function WeightScaleChange(thisObj) {

        var oGWScale = document.getElementById("lstTotalGrossWeightScale");
        var oCWScale = document.getElementById("lstTotalChargeWeightScale");
        var oGW = document.getElementById("txtTotalGrossWeight");
        var oCW = document.getElementById("txtTotalChargeWeight");

        if (memGW == null) {
            memGW = oGW.value;
        }

        if (memCW == null) {
            memCW = oCW.value;
        }

        if (thisObj.value == "Kg") {
            oGWScale.value = "Kg";
            oCWScale.value = "Kg";
            memGW = memGW / 2.20462262;
            memCW = memCW / 2.20462262;
        }
        if (thisObj.value == "Lb") {
            oGWScale.value = "Lb";
            oCWScale.value = "Lb";
            memGW = memGW * 2.20462262;
            memCW = memCW * 2.20462262;
        }
        oGW.value = memGW.toFixed(2);
        oCW.value = memCW.toFixed(2);
    }

    function txtTotalGrossWeight_click() {
        memGW = null;
    }

    function txtTotalChargeWeight_click() {
        memCW = null;
    }
</script>
<script type="text/javascript">
    lstCustomerNameChange("<%=vOrgAcct %>","<%=vOrgName %>");
    <% If vvvLockAR = "Y" Then %>
    makeAllReadOnlyStyle(document.getElementById("CustomerContainer"));
    <% End If %>
</script>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
