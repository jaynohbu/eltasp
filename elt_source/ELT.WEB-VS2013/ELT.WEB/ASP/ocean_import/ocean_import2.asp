<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/header.asp" -->
<!--  #INCLUDE FILE="../include/GOOFY_Util_fun.inc" -->
<%
Public  vLock_ap, vPostBack
'------------------------------------------------------------Included  for Cost Item----------------------------
Public  AddCostItem,  DeleteCost 
Public  mb_no, TranNo,tNo '12/11
Public  carrier_code
Public  NoCostItem, vTotalCost
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
dim vDefault_SalesRep	
vDefault_SalesRep=session_user_lname
'-----------------------------------------
Dim vSalesPerson
Dim aSRName(1000)
Dim SRIndex
'--------------------------------------(11/18/06)

Dim rs,rs1,SQL,SQL1
Dim vMAWB,vAgentName,vCarrier,vPieces,vAgentDebitNo,vAgentDebitAmt,vCarrierCode,vCarrierAcct
Dim vFLTNo, vVoyageNo, vETD,vETA,vGrossWeight,vChargeableWeight
Dim aHAWB(64),aShipper(64),aConsignee(64),aNotify(64),aDesc(64),aPieces(64),aGrossWT(64),aChgWT(64)
Dim aFreightCollect(64),aOCCollect(64),aAN(64),aHAWBLock(64)
Dim vExportAgentELTAcct,vAgentOrgAcct
Dim vPRDate
Dim iType
Dim vTranDT, vScale1,vScale2,vScale3,vCargoLocation,vLastFreeDate,vITNumber,vITDate,vITEntryPort,vPlaceOfDelivery
Dim Delete, Save, Edit, DeleteMAWB, DeleteHAWB,AddHAWB, Search, vJob,vSec,NoItem, vSubMAWB, vGrossWT, vChgWT
Dim tOrgAcct
'// by ig 7/11/2006 for FILE No.
Dim aFILEPrefix(128),aNextFILE(128),fileIndex,vFILEPrefix, rs2,vFileNo,tIndex,fIndex,aIndex,cIndex 
Dim CarrierName(), CarrierCode()
Dim aAgentName(), aAgentELTAcct(), aAgentOrgAcct()
Dim fLocation(1024),fCode(1024),fPhone(1024),fFax(1024)
dim vCargoCode,vVesselName
Dim MAWBNotExist,Query,vNextFileNo

'// Added by Joon on Dec/6/2006 /////////////////////////////////////////////
Public isDeleted,dItemNo

'// T-SQL Data transaction added by Joon on March 14,2008

    eltConn.BeginTrans
    
    vScale1 = GetSQLResult("SELECT uom_qty FROM user_profile WHERE elt_account_number=" & elt_account_number, "uom_qty")
    vScale2 = GetSQLResult("SELECT uom FROM user_profile WHERE elt_account_number=" & elt_account_number, "uom")
    vScale3 = vScale2
    
    Call MainProcess
    
    eltConn.CommitTrans
    

'-----------------------------------------Main Procedure ------------------------------------------'

Sub MainProcess

    isDeleted = "no"

    Call ASSIGN_INITIAL_VALUES_TO_VARIABLES
    Call GET_REQUEST_QUERY_STRING
    Call LOAD_LIST_BOXES_FROM_DB

    '-----------------------------------------

    if Save="yes"  then   
     
        if tNo=TranNo then   
	        Call GET_REQUEST_FROM_SCREEN 
            Call SAVE_OR_CREATE_MAWB_TO_DB  
            Call LOAD_MAWB_FROM_DB_TO_SCREEN
            Call save_cost_item_and_bill_detail_type("O","I") 
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

    '////////////////////////////////////////////////////////////////////////////////

    '---------------------------------11/29/06
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


CALL SetPostBack

'------------------------------Server Side Sub Procedures---------------------------------
Sub DELETE_BILL_DETAIL_FROM_BILL_DETAIL_TABLE
    SQL= "delete bill_detail where elt_account_number = " & elt_account_number & " and mb_no=N'" & vMAWB &"' AND iType='O'"
    eltConn.Execute SQL
End Sub 

Sub  DELETE_COST_ITEMS_FROM_MB_COST_ITEM_TABLE  	
     SQL= "delete from mb_cost_item where elt_account_number = " & elt_account_number & " and mb_no=N'" & vMAWB &"' AND iType='O'"
     eltConn.Execute SQL
End Sub 

Sub ASSIGN_INITIAL_VALUES_TO_VARIABLES
    iType="O"
    MAWBNotExist=""	
    NoItem="0"
    
    TranNo=Session("ODCONTranNo") 'keep the transaction session 12/11
    if TranNo="" then
         Session("ODCONTranNo")=0
         TranNo=0
    end if
    
End Sub 

Sub GET_REQUEST_QUERY_STRING

    tNo=Request.QueryString("tNo")   
    if tNO="" then
	    tNO=0
    else
	    tNo=cLng(tNo)
    end if    
    
    vExportAgentELTAcct=Request.QueryString("AgentELTAcct")   
    if vExportAgentELTAcct="" then vExportAgentELTAcct=0
    vAgentOrgAcct=Request.QueryString("AgentOrgAcct")   
    if vAgentOrgAcct="" then vAgentOrgAcct=0   
    Delete=Request.QueryString("Delete")   
    vMAWB=Replace(Request.QueryString("MAWB"),"?"," ")  
    Search=Request.QueryString("Search")
    vJob=Request.QueryString("JOB")   
    vSec=Request.QueryString("Sec")    
    Edit=Request.QueryString("Edit")
    Save=Request.QueryString("Save")  
    AddHAWB=Request.QueryString("AddHAWB")
    DeleteHAWB=Request.QueryString("DeleteHAWB")
    DeleteMAWB=Request.QueryString("DeleteMAWB")   
    AddCostItem=Request.QueryString("AddCostItem")   
    DeleteCost=Request.QueryString("DeleteCost")
	NoCostItem=cInt(request.QueryString("NoCostItem"))

	if NoCostItem < 4 then
	    NoCostItem = 4
    end if
    
    vPostBack=Request("hPostBack")
    
    if IsPostBack = false then         
        Session("mawb")= vMAWB
    end if 
    
    If (Edit = "yes" Or Search = "yes") And vMAWB <> "" Then
        Dim vEDTSec
        SQL = "SELECT max(sec) FROM import_mawb WHERE mawb_num=N'" & vMAWB _
            & "' AND agent_elt_acct<>0 AND elt_account_number=" & elt_account_number & " AND processed='N'"

        vEDTSec = GetSQLResult(SQL, Null)
        If vEDTSec <> "" Then
            Response.Redirect("ocean_import2A.asp?MAWB=" & Server.URLEncode(vMAWB) & "&SEC=" & vEDTSec)
        End If
    End If
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

Sub GET_REQUEST_FROM_SCREEN
    vSavingCondition=Request("hSavingCondition")   
    vTotalCost=Request("txtTotalCost")
    if vTotalCost="" then vTotalCost=0
    vExportAgentELTAcct=Request("hExportAgentELTAcct")
    if vExportAgentELTAcct="" then vExportAgentELTAcct=0
    vAgentOrgAcct=Request("hAgentOrgAcct")

    vTranDT=Request("hTranDT")
    vMAWB=Request("txtMAWB")
    vSec=Request("hSec")
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
    vVesselName=Request("txtVesselName")
    
    vVoyageNo=Request("txtVoyageNo") 
    vETD=Request("txtETD")
    vETA=Request("txtETA")
    vDepPort=Request("lstDepPort")
    vArrPort=Request("lstArrPort")
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
    
	vDepPort=Request("hDepText")
    vArrPort=Request("hArrText")
	vDepCode=Request("lstDepPort")
    vArrCode=Request("lstArrPort")
	
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

    vProcessDT=Request("txtDate")
    if Not IsDate(vProcessDT) then vProcessDT=Date 
    
    NoCostItem=Request("hNoCostItem")

	if NoCostItem="" then
		NoCostItem=0
	else
		NoCostItem=CInt(NoCostItem)
	end if
    Call GET_COST_ITEMS_FROM_SCREEN	
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
    NoCostItem=0
    if Not vMAWB="" then
        SQL= "select * from mb_cost_item where elt_account_number = " & elt_account_number & " and mb_no=N'" & vMAWB& "'  AND iType='O' order by item_id"
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing

        ccIndex=0
        Do While Not rs.EOF
	        aCostItemNo(ccIndex)=rs("item_no")
	        aCostDesc(ccIndex)=rs("item_desc")
	        aRefNo(ccIndex)=rs("ref_no")
	        aRealCost(ccIndex)=cDbl(rs("cost_amount"))

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
	
	if NoCostItem < 4  then
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




Sub SAVE_OR_CREATE_MAWB_TO_DB           
    Call GET_NEXT_SEC_NUMBER
    Dim rs
    Set rs=Server.CreateObject("ADODB.Recordset")
    			
    SQL= "select * from import_mawb where elt_account_number=" & elt_account_number & " and (agent_elt_acct=" & vExportAgentELTAcct & " or agent_org_acct=" & vAgentOrgAcct & ") and iType='O' and MAWB_NUM=N'" & vMAWB & "' and sec=" & vSec
    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
    if rs.EOF=true then
	    rs.AddNew
	    rs("elt_account_number")=elt_account_number
	    rs("agent_elt_acct")=vExportAgentELTAcct
	    rs("agent_org_acct")=vAgentOrgAcct
	    rs("mawb_num")=vMAWB				
	    rs("iType")="O"
	    rs("sec")=vSec
	    rs("CreatedBy")=session_user_lname	
        rs("CreatedDate")=Now
        rs("SalesPerson")=vSalesPerson	
    end if			
    rs("agent_org_acct")=vAgentOrgAcct
    rs("sub_mawb")=vSubMAWB
    if (Not isDate(vPRDate)) then vPRDate=Date
    rs("process_dt")=vPRDate
    rs("export_agent_name")=vAgentName
    vFileNo = GET_FILE_NUMBER("OIJ", vFileNo, vMAWB )

    rs("file_no")=vFileNo
    rs("carrier")=vCarrier
    rs("carrier_code")=vCarrierCode
    rs("pieces")=vPieces
    rs("agent_debit_no")=vAgentDebitNo
    rs("agent_debit_amt")=vTotalCost
    rs("vessel_name")=vVesselName
    rs("voyage_no")=vVoyageNo 
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
    rs("dep_code")=vDepCode
    rs("arr_code")=vArrCode	
    
    Session("mawb")=vMAWB		
    rs.update
    rs.close
    Session("ODCONTranNo")=Clng(Session("ODCONTranNo"))+1
    TranNo=Clng(Session("ODCONTranNo"))  
    Set rs=Nothing
    CALL UPDATE_USER_NEXT_NUMBER_IN_PREFIX( "OIJ", vFileNo )				
End Sub 

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

Sub DELETE_MAWB
    Dim rs
    Set rs=Server.CreateObject("ADODB.Recordset")
    dSQL= "delete from import_hawb where elt_account_number = " & elt_account_number & " and (agent_elt_acct=" & vExportAgentELTAcct & " or agent_org_acct=" & vAgentOrgAcct & ") and iType='O' and mawb_num=N'" & vMAWB & "' and sec=" & vSec
    rs.Open dSQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText	
    Set rs=Nothing
	    
    Set rs=Server.CreateObject("ADODB.Recordset")
    dSQL= "delete from import_mawb where elt_account_number = " & elt_account_number & " and (agent_elt_acct=" & vExportAgentELTAcct & " or agent_org_acct=" & vAgentOrgAcct & ") and iType='O' and mawb_num=N'" & vMAWB & "' and sec=" & vSec
    rs.Open dSQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText	
    Set rs=Nothing
    NoItem=1
    vMAWB=""	
    Session("mawb")=""  
End Sub


Sub GET_NEXT_SEC_NUMBER
    Dim rs
    Set rs=Server.CreateObject("ADODB.Recordset")
    if vSec=0 then
	    SQL= "select max(sec) as sec from import_mawb where elt_account_number=" & elt_account_number & " and (agent_elt_acct=" & vExportAgentELTAcct & " or agent_org_acct=" & vAgentOrgAcct & ") and iType='O' and MAWB_NUM=N'" & vMAWB & "'"
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
    dItemNo=Request.QueryString("dItemNo")

    dSQL= "delete from import_hawb where elt_account_number = " & elt_account_number & " and (agent_elt_acct=" & vExportAgentELTAcct & " or agent_org_acct=" & vAgentOrgAcct & ") and iType='O' and mawb_num=N'" & vMAWB & "' and hawb_num=N'" & aHAWB(dItemNo) & "' and sec=" & vSec
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
	else
		rs.Close
		mawb = "no_mawb"
	end if

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

'// delete invoice
		SQL = "delete invoice where elt_account_number = " & elt_account_number & " and invoice_no =" & invoice_no
		eltConn.execute (SQL)

		SQL = "delete invoice_charge_item where elt_account_number = " & elt_account_number & " and invoice_no =" & invoice_no
		eltConn.execute (SQL)

		SQL = "delete invoice_cost_item where elt_account_number = " & elt_account_number & " and invoice_no =" & invoice_no
		eltConn.execute (SQL)

		SQL = "delete invoice_hawb where elt_account_number = " & elt_account_number & " and invoice_no =" & invoice_no
		eltConn.execute (SQL)

		SQL = "delete bill_detail where elt_account_number = " & elt_account_number & " and invoice_no =" & invoice_no & " AND iType='O'"
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
			SQL = "update import_hawb set invoice_no = 0 where elt_account_number = " & elt_account_number & " and hawb_num =N'" & tmpHAWB(i) & "' and mawb_num=N'"& tmpMawb & "'" & " AND iType='O'"
			eltConn.execute (SQL)
		next


Set hawb = nothing
Set rs = nothing
end sub
'/////////////////////////////////////////////////////////////////////////////////////////////////

Sub PREPARE_KEYS_FOR_MAWB_DB_LOOKUP
    Dim rs
    Set rs=Server.CreateObject("ADODB.Recordset")
    if Search = "yes" then
		if Not vJob="" then
			SQL="select mawb_num,agent_elt_acct,agent_org_acct,sec from import_mawb where elt_account_number=" & elt_account_number & " and Replace(file_no,'-','')=N'" & Replace(vJob,"-","") & "' AND iType='O'"
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
				response.write("<script language='javascript'>alert('File # '+ '"&vJob &"' + ' does not exist.');</script>")
				vJob = ""
			end if	
			
		elseif Not vMAWB=""  then	
			SQL="select agent_elt_acct,agent_org_acct,sec from import_mawb where elt_account_number=" & elt_account_number & " and mawb_num=N'" & vMAWB & "' AND iType='O'"
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
				response.write("<script language='javascript'>alert('MBOL # '+ '"&vMAWB &"' + ' does not exist.');</script>")
				vMAWB = ""
			end if	
		end if			
	else
	    if Not vMAWB=""  then	
			SQL="select agent_elt_acct,agent_org_acct,sec from import_mawb where elt_account_number=" & elt_account_number & " and mawb_num=N'" & vMAWB & "' AND iType='O' order by sec desc"
			rs.CursorLocation = adUseClient
			rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
			Set rs.activeConnection = Nothing
			if Not rs.EOF then
				vExportAgentELTAcct=cLng(rs("agent_elt_acct"))
				vAgentOrgAcct=cLng(checkBlank(rs("agent_org_acct"),0))
				vSec=cLng(rs("sec"))	
				rs.close
			else
				rs.close
				response.write("<script language='javascript'>alert('MBOL # '+ '"&vMAWB &"' + ' does not exist.');</script>")
				vMAWB = ""
			end if	
		end if	
		
	    if Not vMAWB="" and Not vSec="0" then	
			SQL="select agent_elt_acct,agent_org_acct,sec from import_mawb where elt_account_number=" & elt_account_number & " and mawb_num=N'" & vMAWB & "'"& " and sec=N'" & vSec& "' AND iType='O'"
			rs.CursorLocation = adUseClient
			rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
			Set rs.activeConnection = Nothing
			if Not rs.EOF then
				vExportAgentELTAcct=cLng(rs("agent_elt_acct"))
				vAgentOrgAcct=cLng(checkBlank(rs("agent_org_acct"),0))
				vSec=cLng(rs("sec"))	
				rs.close
			else
				rs.close
				response.write("<script language='javascript'>alert('MBOL # '+ '"&vMAWB &"' + ' does not exist.');</script>")
				vMAWB = ""
			end if	
		end if		
		if Not vJob="" and vSec = "0" and vExportAgentELTAcct=0 and vAgentOrgAcct=0 then
			SQL="select mawb_num,agent_elt_acct,agent_org_acct,sec from import_mawb where elt_account_number=" & elt_account_number & " and file_no=N'" & vJob & "' AND iType='O'"
			rs.CursorLocation = adUseClient
			rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
			Set rs.activeConnection = Nothing
			if Not rs.EOF then
				vMAWB=rs("mawb_num")
				vExportAgentELTAcct=cLng(rs("agent_elt_acct"))
				vAgentOrgAcct=cLng(rs("agent_org_acct"))	
				vSec=cLng(rs("sec"))	
			end if	
			rs.close
		end if
	
		if Not vMAWB="" and vSec = "0" and vExportAgentELTAcct=0 and vAgentOrgAcct=0 then
			SQL="select agent_elt_acct,agent_org_acct,sec from import_mawb where elt_account_number=" & elt_account_number & " and mawb_num=N'" & vMAWB & "' AND iType='O'"
			rs.CursorLocation = adUseClient
			rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
			Set rs.activeConnection = Nothing
			if Not rs.EOF then
				vExportAgentELTAcct=cLng(rs("agent_elt_acct"))
				vAgentOrgAcct=cLng(rs("agent_org_acct"))	
				vSec=cLng(rs("sec"))	
			end if	
			rs.close
		end if		
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
	    aAgentName(aIndex)=rs("DBA_NAME")
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

SUB LOAD_MAWB_FROM_DB_TO_SCREEN
    
    Set rs=Server.CreateObject("ADODB.Recordset")
     
    if Not vMAWB="" and Not (vExportAgentELTAcct=0 and vAgentOrgAcct=0) then
	    
	    if Not vAgentOrgAcct=0 then
			SQL="select a.*,b.org_account_number from import_mawb a LEFT OUTER JOIN organization b ON "_
			    & "(a.elt_account_number=b.elt_account_number AND (a.carrier=b.dba_name OR a.carrier=b.dba_name+'['+LTRIM(RTRIM(b.class_code))+']') AND a.carrier_code=b.carrier_code) " _
			    & "WHERE a.elt_account_number=" & elt_account_number _
			    & " and a.agent_org_acct=" & vAgentOrgAcct & " and a.iType='O' and a.mawb_num=N'" _
			    & vMAWB & "' and a.Sec=" & vSec
		else
			SQL="select a.*,b.org_account_number from import_mawb a LEFT OUTER JOIN organization b ON "_
			    & "(a.elt_account_number=b.elt_account_number AND (a.carrier=b.dba_name OR a.carrier=b.dba_name+'['+LTRIM(RTRIM(b.class_code))+']') AND a.carrier_code=b.carrier_code) " _ 
			    & "WHERE a.elt_account_number=" & elt_account_number _
			    & " and a.agent_elt_acct=" & vExportAgentELTAcct & " and a.iType='O' and a.mawb_num=N'" _
			    & vMAWB & "' and a.Sec=" & vSec
		end if

    
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing

	    if Not rs.EOF then
	        Session("mawb")= vMAWB
	        vExportAgentELTAcct=cLng(rs("agent_elt_acct"))
	        vAgentOrgAcct=cLng(checkBlank(rs("agent_org_acct"),0))
	        vSubMAWB=rs("sub_mawb")
	        vTranDT=rs("tran_dt")
	        vAgentName=rs("export_agent_name")
	        vFileNo=rs("file_no")
	        vCarrier=rs("carrier")
	        vCarrierCode=rs("carrier_code")
            vCarrierAcct = rs("org_account_number")
	        
	        vPieces=rs("pieces")
	        vAgentDebitNo=rs("agent_debit_no")
	        vVesselName=rs("vessel_name")
	        
	        vVoyageNo=rs("voyage_no")
	        vETD=rs("etd")
	        vETA=rs("eta")
	        vGrossWT=rs("gross_wt")
	        vChgWT=rs("chg_wt")
	        vScale1=rs("scale1")
	        vScale2=rs("scale2")
	        vScale3=rs("scale3")
	        vDepPort=rs("dep_code")
	        vArrPort=rs("arr_code")
	        
	        vCargoLocation=rs("cargo_location")
	        if not isnull(vCargoLocation) and  vCargoLocation<>"" then 		
	             tmp=Split(vCargoLocation,"-")
	                vCargoCode=tmp(0)
	        end if 
	        vLastFreeDate=rs("last_free_date")
	        vITNumber=rs("it_number")
	        vITDate=rs("it_date")
	        vITEntryPort=rs("it_entry_port")
	        vPlaceOfDelivery=rs("place_of_delivery")
	        
	        vPRDate=rs("process_dt")
		
	        vDepCode=rs("dep_code")
	        vArrCode=rs("arr_code")			
            if(isnull(rs("SalesPerson"))) then 
                vSalesPerson=""
            else 
                vSalesPerson=rs("SalesPerson")
            end if             

		    If Not IsNull(vDepPort) Then vDepPort = Replace(vDepPort,"Select One","")
		    If Not IsNull(vArrPort) Then vArrPort = Replace(vArrPort,"Select One","")
		    If Not IsNull(vCargoLocation) Then vCargoLocation = Replace(vCargoLocation,"Select One","")
		    If Not IsNull(vPlaceOfDelivery) Then vPlaceOfDelivery = Replace(vPlaceOfDelivery,"Select One","")
		    If Not IsNull(vITEntryPort) Then vITEntryPort = Replace(vITEntryPort,"Select One","")
	    else
		    MAWBNotExist="yes"
		   
	    end if
	    rs.close
	    Set rs=Nothing 
	    Call GET_HAWBS_FROM_DB	
	   
    else
	    MAWBNotExist="yes"
    end if     	
    
END SUB

Sub LOAD_LIST_BOXES_FROM_DB
    CALL GET_SALES_PERSONS_FROM_USERS_TABLE
    CALL GET_FILE_PREFIX_FROM_USER_PROFILE( "OIJ" )	
    Call GET_AGENT_LIST
    '// Call GET_CARRIER_LIST
    Call GET_PORT_LIST   
    Call GET_FREIGHT_LOC_LIST
    Call GET_COST_ITEM_LIST_FROM_DB   

End Sub 

Sub GET_FREIGHT_LOC_LIST
    Dim rs
    Set rs=Server.CreateObject("ADODB.Recordset")
    
    SQL= "select location,firm_code,fax,phone from freight_location where elt_account_number = " & elt_account_number & " order by location"
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
    fIndex=0
    Do While Not rs.EOF
	    fLocation(fIndex)=rs("location")
	    fCode(fIndex)=rs("firm_code")
	    fFax(fIndex)=rs("fax")
        fPhone(fIndex)=rs("phone")
	    fIndex=fIndex+1
	    rs.MoveNext
    Loop
    rs.Close
    Set rs=Nothing
End Sub 

Sub GET_CARRIER_LIST
    Dim rs
    Set rs=Server.CreateObject("ADODB.Recordset")
    
	SQL = "SELECT carrier_code,org_account_number, " _
            & "CASE WHEN isnull(class_code,'') = '' THEN dba_name " _
            & "ELSE dba_name + '[' + RTRIM(LTRIM(isnull(class_code,''))) + ']' " _
            & "END as dba_name FROM organization where elt_account_number = " & elt_account_number _
            & " and is_carrier='Y' order by dba_name"  
            
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	reDim CarrierName(rs.RecordCount+1)
	reDim CarrierCode(rs.RecordCount+1)
    cIndex=1
    CarrierName(0)="Select One"
    Do While Not rs.EOF
	    CarrierName(cIndex)=rs("dba_name")
	    CarrierCode(cIndex)=rs("carrier_code")	   
	    cIndex=cIndex+1
	    rs.MoveNext
    Loop
    rs.Close
    Set rs=Nothing 
End Sub 

Sub GET_HAWBS_FROM_DB

    dim rs,tmpPrepaidCollect
    Set rs = Server.CreateObject("ADODB.Recordset") 
    SQL="select * from import_hawb where elt_account_number=" & elt_account_number & " and iType='O' and mawb_num=N'" & vMAWB & "' AND sec=" & vSec 
    	
    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText

    tIndex=0
    Do While Not rs.EOF
        aHAWB(tIndex)=rs("hawb_num")
        aShipper(tIndex)=rs("shipper_name")
        aConsignee(tIndex)=rs("consignee_name")
        aNotify(tIndex)=rs("notify_name")
        aDesc(tIndex)=rs("desc3")
        aPieces(tIndex)=rs("pieces")
        aGrossWT(tIndex)=rs("gross_wt")
        aChgWT(tIndex)=rs("chg_wt")
		aFreightCollect(tIndex)=rs("freight_collect")
	    aOCCollect(tIndex)=rs("oc_collect")
        aAN(tIndex)=rs("invoice_no")

'///////////////////////////////////////////////////// by Joon on Dec-12-2005
        aHAWBLock(tIndex)=CHECK_INV_LOCK(aAN(tIndex))
'////////////////////////////////////////////////////////////////////////////	    

        tOrgAcct=rs("agent_org_acct")
        if Not IsNull(tOrgAcct) then
            tOrgAcct=cLng(tOrgAcct)
        else
            tOrgAcct=0
        end if
        if tOrgAcct=0 then
            rs("agent_org_acct")=vAgentOrgAcct
            rs.Update
        end if
        rs.MoveNext
        tIndex=tIndex+1
    Loop
    rs.close

    NoItem=tIndex
    Set rs=Nothing 
End Sub 

Sub GET_HAWBS_FROM_SCREEN

    For i=0 To NoItem
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

Sub SAVE_HAWB_TO_DB
    Dim rs
    Set rs=Server.CreateObject("ADODB.Recordset")
    tIndex=0
    For i=0 To NoItem -1

        if Not aHAWB(i)="" then
	        SQL= "select * from import_hawb where elt_account_number =" & elt_account_number & " and (agent_elt_acct=" & vExportAgentELTAcct & " or agent_org_acct=" & vAgentOrgAcct & ") and iType='O' and hawb_num=N'" & aHAWB(i) & "' and sec=" & vSec
	        rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	        If rs.EOF=true Then
		        rs.AddNew
		        rs("elt_account_number")=elt_account_number
		        rs("agent_elt_acct")=vExportAgentELTAcct
		        rs("agent_org_acct")=vAgentOrgAcct
		        rs("iType")="O"
		        rs("sec")=vSec
	        end if
	        rs("agent_org_acct")=vAgentOrgAcct
	        if Not vTranDT="" then
		        rs("tran_dt")=vTranDT
	        end if
	        if(Not isDate(vPRDate)) then vPRDate=Date
	        rs("process_dt")=vPRDate					
	        rs("hawb_num")=aHAWB(i)
	        rs("mawb_num")=vMAWB
	        rs("shipper_name")=aShipper(i)
	        rs("consignee_name")=aConsignee(i)
	        rs("notify_name")=aNotify(i)
	        rs("desc3")=aDesc(i)
	        if aPieces(tIndex)="" then aPieces(i)=0
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
	        rs.update
	        rs.close
	        tIndex=tIndex+1
        end if				
    Next
    NoItem=tIndex
    Set rs=Nothing 
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
    End if
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
	    SQL= "select * from import_mawb where elt_account_number = " & elt_account_number & " and file_no=N'" & tmpFileNo & "' and mawb_num<>N'"&tmpMAWB&"' AND iType='O'"
	    rs2.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	    If rs2.EOF=true Then		
		    FileNoExist=false
		    rs2.close
		    GET_FILE_NUMBER = tmpFileNo
		    Set rs2=Nothing 
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
	rs2.CursorLocation = adUseClient
	rs2.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs2.activeConnection = Nothing

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
  if isnull(vExportAgent ) or vExportAgent  = 0 then
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
    
    SQL= "select * from all_code where elt_account_number = " & elt_account_number & " and type=22 order by code"
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
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <style type="text/css">

    .style1 {color: #cc6600}
    .style4 {color: #663366}
    .numberalign {
	    font-weight: bold;
	    font-size: 9px;
	    text-align: right;
	    font-family: Verdana, Arial, Helvetica, sans-serif;
    }
    .style5 {color: #000000}
    body {
	    margin-left: 0px;
	    margin-right: 0px;
	    margin-bottom: 0px;
    }

    </style>

    <script type="text/javascript" language="javascript" src="/ASP/ajaxFunctions/ajax.js"></script>

    <script type="text/javascript" src="../include/JPED.js"></script>

    <script type="text/javascript" src="../Include/JPTableDOM.js"></script>

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
    
    //ADDed by stanley Limit Fumction
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
    //Added by stanley on 10-22-2007
    function checkDecimalTextMax(obj,limit){
    
        if(obj.value.length >= limit){
            var temp = obj.value;
            var tempArray = new Array();
            tempArray = temp.split(".");
            temp = tempArray[0];
            if(temp.length >= limit){
                obj.value = temp.substring(0,limit);
            }
            else{
                obj.value = parseFloat(obj.value).toFixed(2);
            }
            return false;
        }
        else
        {
            return true;
        }
    }
    </script>

    <script type="text/jscript">
    
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

</head>

<script type="text/jscript">
function navigateAway(event) 
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

    window.location.href = "ocean_import2.asp";
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
<body onbeforeunload="navigateAway(event);" <% If isDeleted="yes" Then Response.Write("onload='forwardToNew();'")%>
    link="336699" vlink="336699" topmargin="0" onload="self.focus()" id="ed">
    <!-- tooltip placeholder -->
    <div id="tooltipcontent">
    </div>
    <!-- placeholder ends -->
    <form name="form1" onkeydown="docModified('true');">
        <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
            <tr>
                <td width="51%" height="32" align="left" valign="middle" class="pageheader">
                    NEW/Edit Deconsolidation</td>
                <td width="49%" align="right" valign="middle">
                    <table border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td width="50%" height="27" align="right" valign="middle">
                                <img src="../Images/spacer.gif" width="1" height="27" align="absmiddle">
                                <select name="select" class="bodyheader" id="SearchType" onchange="selectSearchType();"
                                    style="width: 126px">
                                    <option value="masterNo" selected="selected">MASTER B/L NO.</option>
                                    <option value="fileNo">FILE NO.</option>
                                </select>
                            </td>
                            <td width="50%" align="right" valign="middle">
                                <div id="searchmaster">
                                    <span class="bodyheader style4">
                                        <input name="txtSMAWB" type="text" class="lookup" style="width: 120px" value="Master No. Here"
                                            onclick="javascript: this.value=''; this.style.color='#000000'; " onkeypress="javascript: if(event.keyCode == 13) { LookUp(); }">
                                        <img src="../images/icon_search.gif" name="B1" width="33" height="27" align="absmiddle"
                                            style="cursor: hand" onclick="LookUp()"></span>
                                </div>
                                <div id="searchfile" style="display: none;">
                                    <span class="bodyheader style4">
                                        <input name="txtJobNum" type="text" class="lookup" style="width: 120px" value="File No. Here"
                                            onclick="javascript: this.value=''; this.style.color='#000000'; " onkeypress="javascript: if(event.keyCode == 13) { LookUpFile(); }">
                                        <img src="../images/icon_search.gif" name="B1" width="33" height="27" align="absmiddle"
                                            style="cursor: hand" onclick="LookUpFile()"></span>
                                </div>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <div class="selectarea">
        </div>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#909EB0">
            <tr>
                <td>
                    <!-- start of scroll bar -->
                    <input type="hidden" name="scrollPositionX">
                    <input type="hidden" name="scrollPositionY">
                    <input type="hidden" id="isDocBeingSubmitted" value="false" />
                    <input type="hidden" id="isDocBeingModified" value="false" />
                    <!-- end of scroll bar -->
                    <input name="hPostBack" type="hidden" value="<%= vPostBack %>" />
                    <input type="hidden" name="hMAWB" value="<%= vMAWB %>">
                    <input type="hidden" name="hSec" value="<%= vSec %>">
                    <input type="hidden" name="hNoItem" value="<%= NoItem %>">
                    <input type="hidden" name="hExportAgentELTAcct" value="<%= vExportAgentELTAcct %>">
                    <input type="hidden" name="hAgentOrgAcct" value="<%= vAgentOrgAcct %>">
                    <input type="hidden" name="hTranDT" value="<%= vTranDT %>">
                    <input type="hidden" name="hPCS">
                    <input type="hidden" name="hGrossWT">
                    <input type="hidden" name="hMAWBNotExist" value="<%= MAWBNotExist %>">
                    <!--// by ig 7/11/2006 -->
                    <input type="hidden" name="hFILEPrefix" value="<%= vFILEPrefix %>">
                    <input type="hidden" name="hNEXTFILENo" value="<%= vNEXTFILENo %>">
                    <!--// -->
                    <table width="100%" border="0" cellpadding="2" cellspacing="1">
                        <tr bgcolor="CFD6DF">
                            <td height="24" colspan="14" align="center" valign="middle" bgcolor="#CFD6DF" class="bodyheader">
                                <table width="98%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="26%">
                                            <span class="bodycopy">
                                                <img src="/ASP/Images/spacer.gif" width="75" height="5"></span>
                                        </td>
                                        <td width="48%" align="center" valign="middle">
                                            <span class="bodycopy">
                                                <img height="18" style="cursor: hand" onclick="if(CheckIfMBExist()){ SaveClick();}"
                                                    src="../images/button_save_medium.gif" width="46"></span></td>
                                        <td width="13%" align="right" valign="middle">
                                            <a href="/ASP/ocean_import/ocean_import2.asp" target="_self">
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
                        <tr align="center" valign="middle" bgcolor="DFE1E6">
                            <td height="24" colspan="14" align="center" bgcolor="#f3f3f3" class="bodyheader">
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
                                <table width="75%" border="0" cellpadding="2" cellspacing="0" bordercolor="909EB0"
                                    bgcolor="edd3cf" class="border1px">
                                    <tr bgcolor="#CFD6DF">
                                        <td height="20" align="left" valign="middle">
                                            &nbsp;</td>
                                        <td height="20" align="left" valign="middle" class="bodyheader style5">
                                            <span class="bodyheader style1">
                                                <img src="/ASP/Images/required.gif" align="absbottom">Master B/L No.</span></td>
                                        <td>
                                            <span class="bodyheader style5">File No.</span></td>
                                        <td align="left" valign="middle" class="bodyheader style5">
                                            &nbsp;</td>
                                        <td align="left" valign="middle">
                                        </td>
                                    </tr>
                                    <tr bgcolor="#Ffffff">
                                        <td height="20" align="left" valign="middle">
                                            &nbsp;</td>
                                        <td height="20" align="left" valign="middle" class="bodyheader style5">
                                            <table cellpadding="0" cellspacing="0" border="0" width="220">
                                                <tr>
                                                    <td width="165">
                                                        <input name="txtMAWB" id="txtMAWB" type="text" value="<%= vMAWB %>" size="29" <% if vmawb <>"" then response.write("class='readonlybold' readonly") else response.write("class='bodyheader'") end if %> /></td>
                                                    <td class="bodyheader">
                                                        <% If vMAWB <> "" Then %>
                                                        <a href="javascript:ChangeMAWB();">Change</a><% End If %></td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td colspan="3">
                                            <span class="bodyheader style5">
                                                <% if NOT aFILEPrefix(0) = "NONE" and NOT aFILEPrefix(0) = "EDIT" then%>
                                                <select name="lstFILEPrefix" size="1" class="bodyheader" style="width: 60px" onchange="PrefixChange()">
                                                    <% For i=0 To fileIndex-1 %>
                                                    <option value="<%= aNextFILE(i) %>" <% if vFILEPrefix=aFILEPrefix(i) then response.write("selected") %>>
                                                        <%= aFILEPrefix(i) %>
                                                    </option>
                                                    <%  Next %>
                                                </select>
                                                <% end if %>
                                                <% if aFILEPrefix(0) = "NONE" then%>
                                                <input name='txtFileNo' class='bodyheader' style='width: 80px' value='<%= vFileNo %>'
                                                    size='16'>
                                                <% else %>
                                                <input name='txtFileNo' class='readonlybold' style='width: 80px' value='<%= vFileNo %>'
                                                    size='16' readonly='true'>
                                                <% end if%>
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="2" colspan="8" align="left" valign="middle" bgcolor="#909EB0">
                                        </td>
                                    </tr>
                                    <tr bgcolor="#F3f3f3">
                                        <td align="left" valign="middle">
                                            &nbsp;</td>
                                        <td height="18" align="left" valign="middle" bgcolor="#F3f3f3" class="bodyheader">
                                            Sub B/L No.
                                        </td>
                                        <td align="left" valign="middle" bgcolor="#F3f3f3" class="bodyheader">
                                            Date</td>
                                        <td align="left" valign="middle" bgcolor="#F3f3f3" class="bodyheader">
                                            &nbsp;</td>
                                        <td align="left" valign="middle">
                                            &nbsp;</td>
                                    </tr>
                                    <tr bgcolor="#Ffffff">
                                        <td align="left" valign="middle">
                                            &nbsp;</td>
                                        <td height="18" align="left" valign="middle" class="bodyheader">
                                            <input name="txtSubMAWB" type="text" maxlength="32" class="shorttextfield" value="<%= vSubMAWB %>"
                                                size="28"></td>
                                        <td align="left" valign="middle" class="bodyheader">
                                            <input name="txtDate" type="text" class="m_shorttextfield " preset="shortdate" value="<%= vPRDate %>"
                                                size="26"></td>
                                        <td align="left" valign="middle" class="bodyheader">
                                            &nbsp;</td>
                                        <td align="left" valign="middle">
                                            &nbsp;</td>
                                    </tr>
                                    <tr bgcolor="#F3f3f3">
                                        <td width="1" height="20" align="left" valign="middle">
                                            &nbsp;</td>
                                        <td height="20" colspan="2" align="left" valign="middle" bgcolor="#F3f3f3" class="bodyheader style5">
                                            Carrier</td>
                                        <td width="201" align="left" valign="middle" bgcolor="#F3f3f3" class="bodyheader style5">
                                            <img src="/ASP/Images/required.gif" align="absbottom">Agent</td>
                                        <td align="left" valign="middle">
                                        </td>
                                    </tr>
                                    <tr bgcolor="#FFFFFF">
                                        <td align="left" valign="middle" bgcolor="#FFFFFF">
                                            &nbsp;</td>
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
                                                    <td width="258">
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
                                                    <td td class="bodyheader" style="width: 40px; text-align: right">
                                                        <% If vMAWB <> "" AND Not(NoItem = 0 And vLock_ap <> "Y") Then %>
                                                        <a href="javascript:ChangeAgent();">Change</a><% End If %></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr bgcolor="#F3f3f3">
                                        <td width="1" align="left" valign="middle">
                                            &nbsp;</td>
                                        <td width="240" height="18" align="left" valign="middle" bgcolor="#F3f3f3" class="bodyheader">
                                            Vessel Name
                                        </td>
                                        <td width="206" align="left" valign="middle" bgcolor="#F3f3f3" class="bodyheader">
                                            Voyage No.</td>
                                        <td align="left" valign="middle" bgcolor="#F3f3f3" class="bodyheader">
                                            &nbsp;</td>
                                        <td width="209" align="left" valign="middle">
                                            &nbsp;</td>
                                    </tr>
                                    <tr bgcolor="#Ffffff">
                                        <td align="left" valign="middle">
                                            &nbsp;</td>
                                        <td align="left" valign="middle">
                                            <input name="txtVesselName" type="text" class="shorttextfield" value="<%= vVesselName %>"
                                                size="28"></td>
                                        <td align="left" valign="middle">
                                            <input name="txtVoyageNo" type="text" maxlength="30" class="shorttextfield" value="<%= vVoyageNo %>"
                                                size="19"></td>
                                        <td colspan="2" align="left" valign="middle">
                                            &nbsp;</td>
                                    </tr>
                                    <tr bgcolor="#F3f3f3">
                                        <td width="1" align="left" valign="middle">
                                            &nbsp;</td>
                                        <td height="18" align="left" valign="middle" bgcolor="#F3f3f3" class="bodyheader">
                                            Departure Port</td>
                                        <td align="left" valign="middle" bgcolor="#F3f3f3" class="bodyheader">
                                            ETD</td>
                                        <td align="left" valign="middle" bgcolor="#F3f3f3" class="bodyheader">
                                            Freight Location</td>
                                        <td align="left" valign="middle" bgcolor="#F3f3f3" class="bodyheader">
                                            &nbsp;</td>
                                    </tr>
                                    <tr bgcolor="#Ffffff">
                                        <td align="left" valign="middle">
                                            &nbsp;</td>
                                        <td align="left" valign="middle">
                                            <span class="smallselect">
                                                <select name="lstDepPort" onchange="doDepPortChange(this)" class="smallselect" style="width: 160px">
                                                    <% for i=0 to port_list.count-1 %>
                                                    <option value='<%=port_list(i)("port_code")%>' <% if vDepCode=port_list(i)("port_code") then 
																	response.write("selected=selected") 
                    							              end if%>>
                                                        <%= port_list(i)("port_desc") %>
                                                    </option>
                                                    <% next %>
                                                </select>
                                            </span>
                                        </td>
                                        <td align="left" valign="middle">
                                            <input name="txtETD" type="text" class="m_shorttextfield  date" preset="shortdate" value="<%= vETD %>"
                                                size="19"></td>
                                        <td colspan="2" align="left" valign="middle">
                                            <select name="lstCargoLocation" class="smallselect" style="width: 250px">
                                                <option value="">Select One</option>
                                                <% for i=0 to fIndex-1 %>
                                                <option value="<%= fCode(i) & "-" & fLocation(i)&" Phone: "&fPhone(i)&" Fax: "&fFax(i)%>"
                                                    <% if vCargoCode=fCode(i) then response.write("selected") %>>
                                                    <%= fCode(i) & "-" & fLocation(i) %>
                                                </option>
                                                <% next %>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr bgcolor="#F3f3f3">
                                        <td width="1" align="left" valign="middle" bgcolor="f3f3f3">
                                            &nbsp;</td>
                                        <td height="18" align="left" valign="middle" bgcolor="#F3f3f3" class="bodyheader">
                                            Destination Port</td>
                                        <td align="left" valign="middle" bgcolor="#F3f3f3" class="bodyheader">
                                            ETA</td>
                                        <td align="left" valign="middle" bgcolor="#F3f3f3" class="bodyheader">
                                            Last Free Date</td>
                                        <td align="left" valign="middle" bgcolor="#F3f3f3" class="bodyheader">
                                            Place of Delivery
                                        </td>
                                    </tr>
                                    <tr bgcolor="#FFFFFF">
                                        <td align="left" valign="middle" bgcolor="#FFFFFF">
                                            &nbsp;</td>
                                        <td align="left" valign="middle">
                                            <select name="lstArrPort" onchange="doArrPortChange(this)" class="smallselect" style="width: 160px">
                                                <% for i=0 to port_list.count-1 %>
                                                <option value='<%=port_list(i)("port_code")%>' <% 
														  if vArrPort=port_list(i)("port_code") then 
															  response.write("selected=selected") 
														  end if
                                  						%>>
                                                    <%= port_list(i)("port_desc") %>
                                                </option>
                                                <% next %>
                                            </select>
                                        </td>
                                        <td align="left" valign="middle">
                                            <input name="txtETA" type="text" class="m_shorttextfield " preset="shortdate" value="<%= vETA %>"
                                                size="19"></td>
                                        <td align="left" valign="middle">
                                            <input name="txtLastFreeDate" type="text" class="m_shorttextfield " preset="shortdate"
                                                value="<%= vLastFreeDate %>" size="19"></td>
                                        <td align="left" valign="middle">
                                            <input name="txtPlaceOfDelivery" type="text" class="shorttextfield" maxlength="64"
                                                value="<%= vPlaceOfDelivery %>" size="29"></td>
                                    </tr>
                                    <tr bgcolor="#F3f3f3">
                                        <td align="left" valign="middle" bgcolor="#F3f3f3">
                                            &nbsp;</td>
                                        <td height="18" align="left" valign="middle" class="bodyheader">
                                            Pieces</td>
                                        <td align="left" valign="middle" class="bodyheader">
                                            Gross Weight</td>
                                        <td align="left" valign="middle" class="bodyheader">
                                            <% response.write("CBM")%>
                                        </td>
                                        <td align="left" valign="middle" bgcolor="#F3f3f3">
                                            &nbsp;</td>
                                    </tr>
                                    <tr bgcolor="#FFFFFF">
                                        <td align="left" valign="middle" bgcolor="#FFFFFF">
                                            &nbsp;</td>
                                        <td align="left" valign="middle">
                                            <input name="txtPieces" type="text" class="shorttextfield" value="<%= vPieces %>"
                                                size="9" style="behavior: url(../include/igNumDotChkLeft.htc)">
                                            <select name="lstScale1" class="smallselect" style="width: 50px">
                                                <option <%if vScale1="PCS" then response.write("selected")%>>PCS</option>
                                                <option <%if vScale1="BOX" then response.write("selected")%>>BOX</option>
                                                <option <%if vScale1="PLT" then response.write("selected")%>>PLT</option>
                                                <option <%if vScale1="CTN" then response.write("selected")%>>CTN</option>
                                                <option <%if vScale1="SET" then response.write("selected")%>>SET</option>
                                                <option <%if vScale1="CRT" then response.write("selected")%>>CRT</option>
                                                <option <%if vScale1="SKD" then response.write("selected")%>>SKD</option>
                                                <option <%if vScale1="UNIT" then response.write("selected")%>>UNIT</option>
                                                <option <%if vScale1="UNIT" then response.write("selected")%>>PKGS</option>
                                            </select>
                                        </td>
                                        <td align="left" valign="middle">
                                            <input name="txtGrossWT" type="text" class="shorttextfield" value="<%= vGrossWT %>"
                                                size="9" style="behavior: url(../include/igNumDotChkLeft.htc)">
                                            <select name="lstScale2" class="smallselect" style="width: 50px">
                                                <option <% if vScale2="LB" Or vScale2="L" Then response.write("selected") %>>LB</option>
                                                <option <% if vScale2="KG" Or vScale2="K" Then response.write("selected") %>>KG</option>
                                            </select>
                                        </td>
                                        <td colspan="2" align="left" valign="middle">
                                            <input name="txtChgWT" type="text" class="shorttextfield" value="<%= vChgWT %>" size="9"
                                                style="behavior: url(../include/igNumDotChkLeft.htc)" />
                                            <select name="lstScale3" class="smallselect" style="width: 50px">
                                                <option <% if vScale3="LB" Or vScale3="L" or vScale3="CFT" then response.write("selected") %>>
                                                    CFT</option>
                                                <option <% if vScale3="KG" Or vScale3="K" or vScale3="CBM" then response.write("selected") %>>
                                                    CBM</option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr bgcolor="#F3f3f3">
                                        <td align="left" valign="middle">
                                            &nbsp;</td>
                                        <td height="18" align="left" valign="middle" bgcolor="#F3f3f3" class="bodyheader">
                                            I.T. No.</td>
                                        <td align="left" valign="middle" bgcolor="#F3f3f3" class="bodyheader">
                                            I.T. Date</td>
                                        <td align="left" valign="middle" bgcolor="#F3f3f3" class="bodyheader">
                                            I.T. Entry Port</td>
                                        <td align="left" valign="middle">
                                            &nbsp;</td>
                                    </tr>
                                    <tr bgcolor="#FFFFFF">
                                        <td width="1" align="left" valign="middle" bgcolor="#FFFFFF">
                                            &nbsp;</td>
                                        <td align="left" valign="middle">
                                            <input name="txtITNumber" type="text" class="shorttextfield" value="<%= vITNumber %>"
                                                size="20"></td>
                                        <td align="left" valign="middle">
                                            <input name="txtITDate" type="text" class="m_shorttextfield " preset="shortdate" value="<%= vITDate %>"
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
                            <tr bgcolor="CFD6DF">
                                <td height="22" colspan="14" align="center" valign="middle" class="bodyheader">
                                    <table id="tblChargeCost" border="0" cellpadding="0" cellspacing="0" width="100%">
                                        <input name="hNoCostItem" type="hidden" value="<%= NoCostItem %>">
                                        <input id="InvoiceCostItem" type="hidden">
                                        <input id="ItemCost" type="hidden">
                                        <input id="ItemCostDesc" type="hidden">
                                        <input id="ItemVendor" type="hidden">
                                        <input id="txtLock_ap" type="hidden">
                                        <tr>
                                            <td align="left" colspan="8" height="1" valign="middle">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="1%" height="20" bgcolor="CFD6DF" class="bodycopy">
                                                &nbsp;</td>
                                            <td width="24%" bgcolor="CFD6DF" class="bodyheader">
                                                <span class="style1">Agent Debit No.
                                                    <% if mode_begin then %>
                                                </span>
                                                <div style="width: 21px; display: inline; vertical-align: middle" onmouseover="showtip('This is where you enter the overall reference number for the Agent Debit items that will be related to this deconsolidation.');"
                                                    onmouseout="hidetip()">
                                                    <img src="../Images/button_info.gif" align="middle" class="bodylistheader"></div>
                                                <% end if %>
                                            </td>
                                            <td width="25%" bgcolor="CFD6DF" class="bodycopy">
                                                &nbsp;</td>
                                            <td width="9%" bgcolor="CFD6DF" class="bodycopy">
                                                &nbsp;</td>
                                            <td width="3%" bgcolor="CFD6DF" class="bodycopy">
                                                &nbsp;</td>
                                            <td width="12%" bgcolor="CFD6DF" class="bodycopy">
                                                &nbsp;</td>
                                            <td width="22%" bgcolor="CFD6DF" class="bodycopy">
                                                &nbsp;</td>
                                            <td width="4%" bgcolor="CFD6DF">
                                                &nbsp;</td>
                                        </tr>
                                        <tr bgcolor="#FFFFFF">
                                            <td height="20" class="bodycopy">
                                                &nbsp;</td>
                                            <td class="bodycopy">
                                                <input name="txtAgentDebitNo" type="text" maxlength="32" class='shorttextfield txtAgentDebitNo' value="<%= vAgentDebitNo %>"
                                                    size="16"></td>
                                            <td class="bodycopy">
                                                &nbsp;</td>
                                            <td class="bodycopy">
                                                &nbsp;</td>
                                            <td class="bodycopy">
                                                &nbsp;</td>
                                            <td class="bodycopy">
                                                &nbsp;</td>
                                            <td class="bodycopy">
                                                &nbsp;</td>
                                            <td>
                                                &nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="CFD6DF" class="bodycopy" height="20">
                                                &nbsp;
                                            </td>
                                            <td bgcolor="CFD6DF" class="bodycopy">
                                                <strong>Agent Debit Item </strong>
                                            </td>
                                            <td bgcolor="CFD6DF" class="bodycopy">
                                                <strong>Description</strong></td>
                                            <td bgcolor="CFD6DF" class="bodycopy">
                                                <strong>Cost</strong></td>
                                            <td bgcolor="CFD6DF" class="bodycopy">
                                                &nbsp;</td>
                                            <td bgcolor="CFD6DF" class="bodycopy">
                                                <strong>Reference No.</strong></td>
                                            <td bgcolor="CFD6DF" class="bodycopy">
                                                &nbsp;
                                            </td>
                                            <td bgcolor="CFD6DF">
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
                                                <select id="InvoiceCostItem" name="lstCostItem<%= i %>" class="InvoiceCostItem" style="visibility: hidden; width: 1px">
                                                    <option>Select One</option>
                                                    <option>Add New Item</option>
                                                    <% for j=0 to CostItemIndex-1 %>
                                                    <option <% if cint(acostitemno(i))=defaultcostitemno(j) then 
													response.write("selected") 
													tmpigDefaultCostItem = igDefaultCostItem(j)
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
                                                    size="12" type="text" value="<%= formatnumber(aRealCost(i),2) %>" <%if aLock_ap(i) ="Y" then response.write "readonly='true'"%>
                                                    style="behavior: url(../include/igNumDotChkLeft.htc)"></td>
                                            <td bgcolor="#FFFFFF">
                                                <select id="ItemVendor" class="smallselect" name="lstVendor<%= i %>" size="1" style="visibility: hidden">
                                                    <option></option>
                                                </select>
                                            </td>
                                            <td bgcolor="#FFFFFF">
                                                <input class="shorttextfield" name="txtRefNo<%= i %>" size="14" type="text" maxlength="64"
                                                    value="<%= aRefNo(i) %>" <%if aLock_ap(i) ="Y" then response.write "readonly='true'"%>></td>
                                            <td bgcolor="#FFFFFF">
                                                <input id="txtLock_ap" class="shorttextfield" name="txtLock_ap<%= i %>" type="hidden"
                                                    value="<%= aLock_ap(i) %>">
                                                <%if aLock_ap(i) = "Y" then %>
                                                <span style='color: #CC3333' class='bodyheader'><a href='javascrip:;' onclick="goLink('<%=aLock_bill(i)%>'); return false;">
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
                                            <td height="1" colspan="8" bgcolor="#909EB0">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="1" colspan="8" bgcolor="#ffffff">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="1" colspan="8" bgcolor="#909EB0">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="#FFFFFF">
                                                &nbsp;</td>
                                            <td bgcolor="#FFFFFF">
                                                &nbsp;</td>
                                            <td align="right" bgcolor="#FFFFFF" class="bodyheader">
                                                <strong><span class="style1">AGENT DEBIT TOTAL</span>&nbsp;&nbsp;</strong></td>
                                            <td bgcolor="#FFFFFF">
                                                <strong>
                                                    <input class="numberalign" name="txtTotalCost" size="12" type="text" value="<%= formatnumber(vTotalCost,2) %>"
                                                        readonly="true" style="behavior: url(../include/igNumDotChkLeft.htc)">
                                                </strong>
                                            </td>
                                            <td bgcolor="#FFFFFF">
                                                &nbsp;</td>
                                            <td colspan="3" bgcolor="#FFFFFF">
                                                <div align="right">
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="14" bgcolor="#CFD6DF">
                                    <table width="100%" border="0" cellpadding="2" cellspacing="1" bgcolor="#909EB0"
                                        class="bodycopy">
                                        <tr bgcolor="CFD6DF">
                                            <td width="15%" height="22" align="left" valign="middle" bgcolor="CFD6DF" class="bodyheader">
                                                <% response.write("House B/L No.")%>
                                            </td>
                                            <td width="15%" align="left" valign="middle" bgcolor="CFD6DF" class="bodyheader">
                                                Shipper</td>
                                            <td width="15%" align="left" valign="middle" bgcolor="CFD6DF" class="bodyheader">
                                                Consignee</td>
                                            <td align="left" valign="middle" bgcolor="CFD6DF" class="bodyheader">
                                                Notify</td>
                                            <!--
            <td width="415" align="left" valign="middle" class="bodyheader">Description</td>
			-->
                                            <td width="42" align="left" valign="middle" class="bodyheader">
                                                PC/UOM</td>
                                            <td width="68" align="left" valign="middle" class="bodyheader">
                                                Gross WT
                                            </td>
                                            <td width="60" align="left" valign="middle" class="bodyheader">
                                                <% response.write("CBM")%>
                                            </td>
                                            <td width="44" align="left" valign="middle" class="bodyheader">
                                                Ocean Freight
                                            </td>
                                            <td width="52" align="left" valign="middle" class="bodyheader">
                                                Other Charge
                                            </td>
                                            <td width="45" align="left" valign="middle" class="bodyheader">
                                                AN No.
                                            </td>
                                            <td width="42" align="left" valign="middle" class="bodycopy">
                                                &nbsp;</td>
                                            <td width="55" align="left" valign="middle" class="bodycopy">
                                                &nbsp;</td>
                                            <td width="61" align="left" valign="middle" class="bodycopy">
                                                &nbsp;</td>
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
                                                <input readonly name="txtHAWB<%= i %>" type="text" class="d_shorttextfield" id="HAWB"
                                                    value="<%= aHAWB(i) %>"></td>
                                            <td align="left" valign="middle">
                                                <span style="width: auto">
                                                    <input readonly name="txtShipper<%= i %>" type="text" class="d_shorttextfield" id="HAWBShipper"
                                                        value="<%= aShipper(i) %>"></span></td>
                                            <td align="left" valign="middle" class="bodycopy">
                                                <input readonly name="txtConsignee<%= i %>" type="text" class="d_shorttextfield"
                                                    id="HAWBConsignee" value="<%= aConsignee(i) %>"></td>
                                            <td align="left" valign="middle" class="bodycopy">
                                                <input readonly name="txtNotify<%= i %>" type="text" class="d_shorttextfield" id="HAWBNotify"
                                                    value="<%= aNotify(i) %>"></td>
                                            <!--
            <td align="left" valign="middle" class="bodycopy"><input readonly name="txtDesc<%= i %>" type=text class="d_shorttextfield" id="HAWBDesc" Value="<%= aDesc(i) %>" size =27></td>
			-->
                                            <td align="left" valign="middle" class="bodycopy">
                                                <input readonly name="txtPieces<%= i %>" type="text" class="d_shorttextfield" id="HAWBPieces"
                                                    value="<%= aPieces(i) %>" size="5" style="behavior: url(../include/igNumChkRight.htc)" /></td>
                                            <td align="left" valign="middle" class="bodycopy">
                                                <input readonly name="txtGrossWT<%= i %>" type="text" class="d_shorttextfield" id="HAWBGrossWT"
                                                    value="<%= aGrossWT(i) %>" size="5" style="behavior: url(../include/igNumChkRight.htc)" /></td>
                                            <td align="left" valign="middle" class="bodycopy">
                                                <input readonly name="txtChgWT<%= i %>" type="text" class="d_shorttextfield" id="HAWBChgWT"
                                                    value="<%= aChgWT(i) %>" size="6" style="behavior: url(../include/igNumChkRight.htc)" /></td>
                                            <td width="44" align="left" valign="middle" class="bodycopy">
                                                <input id="HAWBFreightCollect" class="d_shorttextfield" name="txtFreightCollect<%= i %>"
                                                    readonly="readonly" size="6" style="behavior: url(../include/igNumChkRight.htc)"
                                                    type="text" value="<%= formatnumber(checkBlank(aFreightCollect(i),0),2) %>" /></td>
                                            <td width="52" align="left" valign="middle" class="bodycopy">
                                                <input readonly name="txtOCCollect<%= i %>" type="text" class="d_shorttextfield"
                                                    value="<%= formatnumber(checkBlank(aOCCollect(i),0),2) %>" size="7" style="behavior: url(../include/igNumChkRight.htc)" /></td>
                                            <td width="45" align="left" valign="middle" class="bodycopy">
                                                <input readonly name="txtAN<%= i %>" type="text" class="d_shorttextfield" value="<%= aAN(i) %>"
                                                    size="6" /></td>
                                            <td width="42" align="left" valign="middle" class="bodycopy">
                                                <img src="../images/button_view.gif" width="42" height="18" name="B1" onclick="ViewClick('<%= aHAWB(i) %>')"
                                                    style="cursor: hand"></td>
                                            <td width="55" align="left" valign="middle" class="bodycopy">
                                                <img src="../images/button_edit_an.gif" width="55" height="18" name="B1" onclick="EditANClick(<%= vSec %>,<%= i+1 %>,<%= aAN(i) %>)"
                                                    style="cursor: hand"></td>
                                            <td width="61" align="left" valign="middle" class="bodycopy">
                                                <img src="../images/button_delete.gif" width="50" height="17" onclick="DeleteHAWB('<%=aAN(i)%>',<%= i %>)"
                                                    style="cursor: hand; visibility: <%=aHAWBLock(i) %>"></td>
                                        </tr>
                                        <% next %>
                                        <tr bgcolor="edd3cf">
                                            <td height="22" align="left" valign="middle" bgcolor="f3f3f3" class="bodycopy">
                                                <input type="hidden" name="hDepText" id="hDepText" value="<%=vDepPort%>" />
                                                <input type="hidden" name="hArrText" id="hArrText" value="<%=vArrPort%>" />
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
                                                <img src="../images/button_addhbol.gif" width="110" height="18" name="B1" onclick="AddHAWB()"
                                                    style="cursor: hand">
                                                <% if mode_begin then %>
                                                <div style="width: 21px; display: inline; vertical-align: middle" onmouseover="showtip('This Button will take you to the Arrival Notice screen for the entry of House information.  The Master bill and flight information from the Deconsolidation will automatically be pushed to the relevant fields.');"
                                                    onmouseout="hidetip()">
                                                    <img src="../Images/button_info.gif" align="middle" class="bodylistheader"></div>
                                                <% end if %>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr align="center" bgcolor="CFD6DF">
                                <td height="34" colspan="14" align="right" valign="middle" bgcolor="#FFFFFF" class="bodyheader">
                                    <span style="text-align: right">Sales Person
                                        <select name="lstSalesRP" size="1" class="smallselect" style="width: 200px">
                                            <option value="none">Select One</option>
                                            <% For i=0 To SRIndex-1 %>
                                            <option value="<%= aSRName(i)%>" <%
  	                    if vSalesPerson = aSRName(i) then response.write("selected") %>>
                                                <%= aSRName(i) %>
                                            </option>
                                            <%  Next  %>
                                        </select>
                                    </span>
                                </td>
                            </tr>
                            <tr align="center" bgcolor="CFD6DF">
                                <td height="22" colspan="14" valign="middle" class="bodycopy">
                                    <table width="98%" border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td width="26%">
                                                <img src="/ASP/Images/spacer.gif" width="75" height="5">
                                            </td>
                                            <td width="48%" align="center" valign="middle">
                                                <img height="18" style="cursor: hand" onclick="if(CheckIfMBExist()){ SaveClick();}"
                                                    src="../images/button_save_medium.gif" width="46"></td>
                                            <td width="13%" align="right" valign="middle">
                                                <a href="/ASP/ocean_import/ocean_import2.asp" target="_self">
                                                    <img src="/ASP/Images/button_new.gif" width="42" height="17" border="0"
                                                        style="cursor: hand"></a></td>
                                            <td width="13%" align="right" valign="middle">
                                                <% if vLock_ap <> "Y" then %>
                                                <img src="../images/button_delete_medium.gif" width="51" height="17" onclick="DeleteMAWBClick()"
                                                    style="cursor: hand">
                                                <% end if%>
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
var PortCode = "";

function doDepPortChange(obj) {
    dPortCode = obj.children[obj.options.selectedIndex].text;
    document.form1.hDepText.value = dPortCode;
}
function doArrPortChange(obj) {
    aPortCode = obj.children[obj.options.selectedIndex].text;
    document.form1.hArrText.value = aPortCode;
}
</script>
<script type="text/vbscript">
Sub lstMAWBChange_ocean(name)    'never used 

	Dim aVal
	aVal=split(document.getElementById(name).Value,"^")
	//msgbox document.getElementById(name).Value
	document.getElementById("txtRefNo").Value=aVal(0)
	document.getElementById("txtVessel").Value=aVal(1)
	//msgbox aVal(1)
	document.getElementById("txtITEntryPort").Value=aVal(2)
	document.getElementById("txtITNumber").Value=aVal(3)
	document.getElementById("txtITDate").Value=aVal(4)
	document.getElementById("txtFreeDate").Value=aVal(5)
	document.getElementById("txtVoyageNo").Value=aVal(6)
	document.getElementById("txtSubMAWB").Value=aVal(7)
	document.getElementById("txtCargoLocation").Value=aVal(8)
	document.getElementById("txtETD").Value=aVal(9)
	document.getElementById("txtETA").Value=aVal(10)
	aVal(11) = replace(aVal(11),"Select One","")	

	document.getElementById("hDepText").Value=aVal(11)
	document.getElementById("hArrText").Value=aVal(12)
	
	document.getElementById("hAgentOrgAcct").Value=aVal(15)
	document.getElementById("hSec").Value=aVal(16)

	call setSelect("lstDepPort", aVal(13) )
	call setSelect("lstArrPort", aVal(14) )

End Sub 
</script>
<script type="text/javascript">

// by igMoon 07/10/2006 for File No.
function PrefixChange() {
    var sIndex = document.form1.lstFILEPrefix.selectedIndex;
    var Prefix = document.form1.lstFILEPrefix.item(sIndex).text;
    document.form1.hNEXTFILENo.value = document.form1.lstFILEPrefix.value;
    document.form1.txtFileNo.value = Prefix + "-" + document.form1.lstFILEPrefix.value;
}

function LookUp() {
    document.form1.isDocBeingModified.value = "false";
    var MAWB = document.form1.txtSMAWB.value;
    if (MAWB != "" && MAWB != "Master No. Here") {
        document.form1.txtSMAWB.value = "";
        document.form1.action = encodeURI("ocean_import2.asp?iType=O&Edit=yes&MAWB=" + MAWB + "&Search=yes&WindowName=" + window.name);
        document.form1.method = "POST";
        document.form1.target = "_self";
        form1.submit();
    }
    else
        alert("Please enter a Master No!");
}
function LookUp2() {
    document.form1.isDocBeingModified.value = "false";
    var MAWB = document.form1.txtMAWB.value;
    if (MAWB != "" && MAWB != "Master No. Here") {
        document.form1.txtSMAWB.value = "";
        document.form1.action = encodeURI("ocean_import2.asp?iType=O&Edit=yes&MAWB=" + MAWB + "&Search=yes&WindowName=" + window.name);
        document.form1.method = "POST";
        document.form1.target = "_self";
        form1.submit();
    }
    else
        alert("Please enter a Master No!");
}


function LookUpFile(){
    document.form1.isDocBeingModified.value = "false";
    var JobNum=document.form1.txtJobNum.value;
    if (JobNum != "" && JobNum != "File No. Here" ){
        document.form1.txtJobNum.value = "";
        document.form1.txtMAWB.value = "";
        document.form1.action = encodeURI("ocean_import2.asp?iType=O&Edit=yes&JOB=" + JobNum + "&Search=yes&WindowName=" + window.name);
        document.form1.method = "POST";
        document.form1.target = "_self";
        form1.submit();
    }
    else
        alert("Please enter a File No!");
}

function SaveClick() {
    if (document.form1.txtFileNo.value == "") {
        alert("Please, preset file numbers and prefixes in prefix manager. You can also manual enter it in this page.");
        return false;
    }

    var NoCostItem = document.form1.hNoCostItem.value;
    for (var j = 0; j < NoCostItem; j++) {
        var oCost = $("input.ItemCost").get(j).value;
        if (oCost == "")
            oCost = 0;
        var oItem = $("select.InvoiceCostItem").get(j).value;
        if (!IsNumeric(oCost)) {
            alert("Please enter a Numeric Value for COST!");
            return false;
        }
        if (oCost != 0 && oItem == "") {
            alert("Please select a Cost Item!");
            return false;
        }

        if (oCost != 0 && document.all.txtAgentDebitNo.value.trim() == "") {
            alert("Please enter the Agent Debit No.");
            $("input.txtAgentDebitNo").focus();
            return false;
        }
    }

    // ----------------------------------------------------

    var MAWB = document.form1.txtMAWB.value;
    var ETD = document.form1.txtETD.value;
    var ETA = document.form1.txtETA.value;
    var fDate = document.form1.txtLastFreeDate.value;
    var ITDate = document.form1.txtITDate.value;
    var AgentDebit = document.form1.txtTotalCost.value;

    if (MAWB == "") {
        alert("Please enter a MAWB Number!");
        return false;
    }
    else if (document.form1.hFFAgentAcct.value == "" || document.form1.hFFAgentAcct.value == "0") {
        alert("Please select an Export Agent!");
        return false;
    }

    if (ETD != "" && !IsDate(ETD)) {
        alert("Please enter correct Date for ETD (MM/DD/YY)");
        return false;
    }
    if (ETA != "" && !IsDate(ETA)) {
        alert("Please enter correct Date for ETA (MM/DD/YY)");
        return false;
    }

    if (fDate != "" && !IsDate(fDate)) {
        alert("Please enter correct Date for Last Free Date (MM/DD/YY)");
        return false;
    }
    if (ITDate != "" && !IsDate(ITDate)) {
        alert("Please enter correct Date for IT Date (MM/DD/YY)");
        return false;
    }

    document.form1.isDocBeingSubmitted.value = "true";
    document.form1.action = encodeURI("ocean_import2.asp?iType=O&Save=yes&WindowName=" + window.name + "&tNo=<%=TranNo%>");

    document.form1.method = "POST";
    document.form1.target = "_self";
    form1.submit();
}


function AddHAWB() {
    var isConfirmYes = true;
    var isDocBeingSubmitted = document.form1.isDocBeingSubmitted.value;
    var isDocBeingModified = document.form1.isDocBeingModified.value;

    if (isDocBeingSubmitted == "false" && isDocBeingModified == "true")
        isConfirmYes = confirmGoAway();


    if (isConfirmYes) {
        var MAWB = document.form1.txtMAWB.value;
        var Sec = document.form1.hSec.value;
        var NoItem = parseInt(document.form1.hNoItem.value);
        var AgentOrgAcct = document.form1.hAgentOrgAcct.value;
        document.form1.hNoItem.value = NoItem + 1;
        document.form1.action = encodeURI("arrival_notice.asp?NoItem=4&NoCostItem=4&iType=O&NewHAWB=yes&forwarded=Y&MAWB=" + MAWB + "&Sec=" + Sec + "&WindowName=" + window.name + "&AgentOrgAcct=" + AgentOrgAcct);
        //alert(encodeURI("arrival_notice.asp?NoItem=4&NoCostItem=4&iType=O&NewHAWB=yes&forwarded=Y&MAWB=" + MAWB + "&Sec=" + Sec + "&WindowName=" + window.name + "&AgentOrgAcct=" + AgentOrgAcct));
        document.form1.method = "POST";
        document.form1.target = "_self";
        form1.submit();
    }

}

function DeleteHAWB(Invoice_no,ItemNo){
    
    document.form1.isDocBeingModified.value = "false"
    if (confirm("Are you sure you want to delete this HBOL? \r\nContinue?")) {
	    var NoItem=document.form1.hNoItem.value;
	    if (NoItem > 0) {
	        document.form1.action = encodeURI("ocean_import2.asp?iType=O&DeleteHAWB=yes&dItemNo=" + ItemNo + "&WindowName=" + window.name);
	        document.form1.target = "_self";
	        document.form1.method = "POST";
	        form1.submit();
	    }
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

        if (ExportAgentELTAcct > 0)
            document.form1.action = encodeURI("../ocean_export/hbol_pdf.asp?HBOL=" + HAWB + "&AgentELTAcct=" + ExportAgentELTAcct + "&WindowName=popUpWindow");
        else
            document.form1.action = encodeURI("arrival_notice_pdf.asp?iType=O&HAWB=" + HAWB + "&MAWB=" + MAWB + "&Sec=<%=Sec %>&AgentOrgAcct=" + AgentOrgAcct + "&WindowName=popUpWindow");

        document.form1.target = "_self";
        document.form1.method = "POST";
        form1.submit();
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
		
        document.form1.action = encodeURI("arrival_notice.asp?iType=O&Edit=yes&AgentOrgAcct=" + AgentOrgAcct + "&MAWB=" + MAWB + "&HAWB=" + HAWB + "&Sec=" + Sec + "&ItemNo=" + ItemNo + "&InvoiceNo="+ InvoiceNo);
        
		if ("<%=headBranch%>" != "")
		    document.form1.action = document.form1.action + "&Branch=" + "<%=headBranch%>";

		document.form1.target = "_self";
		document.form1.method = "POST";
		form1.submit();
	}
}
function DeleteMAWBClick(){
    if (confirm("Are you sure you want to delete this MAWB? \r\nContinue?")) {
        document.form1.isDocBeingModified.value = "false";
        document.form1.action = encodeURI("ocean_import2.asp?iType=O&DeleteMAWB=yes" + "&WindowName=" + window.name);
        document.form1.method = "POST";
        document.form1.target = "_self";
        form1.submit();
    }
}

function GET_ITEM_UNIT_PRICE(tmpBuf) {
    var ItemUnitPrice = 0

    var pos = tmpBuf.indexOf("\n");
    if (pos >= 0)
        ItemUnitPrice = tmpBuf.substring(pos + 1, 200);

    return ItemUnitPrice;
}

function SET_UNIT_PRICE(obj, val) {
    obj.value = parseFloat(val).toFixed(2);
}

function AddCostItem(){
	var iType="<%= iType %>";
	document.form1.isDocBeingModified.value = "false";
	document.form1.hNoCostItem.value=parseInt(document.form1.hNoCostItem.value)+1;
	document.form1.action=encodeURI("ocean_import2.asp?iType=O" + "&tNo=" + "<%=TranNo%>" +"&AddCostItem=yes"+"&WindowName="+ window.name);
	document.form1.method = "POST";
	document.form1.target = "_self";
	form1.submit();
}

function DeleteCostItem(rNo){
    var iType="<%= iType %>";
    if (confirm("Are you sure you want to delete this item? \r\nContinue?")){	
		document.form1.isDocBeingModified.value = "false";
	    document.form1.action=encodeURI("ocean_import2.asp?iType=O"+ "&tNo=" + "<%=TranNo%>" + "&DeleteCost=yes&rNo=" + rNo+ "&WindowName=" + window.name);

	    document.form1.method = "POST";
	    document.form1.target = "_self";
	    form1.submit();
	}
}

function ItemCostChange(rNo) {
    var sIndex = $("select.InvoiceCostItem").get(rNo).selectedIndex;
    var itemInfo = $("select.InvoiceCostItem").get(rNo).value;

    if (sIndex == 1) { // add new item
        window.open("../acct_tasks/edit_co_items.asp", "PopupWin", "<%=StrWindow %>");
    }
    else {
        var pos = itemInfo.indexOf("\n");
        if (pos >= 0) {
            var Desc = itemInfo.substring(pos + 1, 100);

            // Unit_Price by ig 10/21/2006
            var ItemUnitPrice = GET_ITEM_UNIT_PRICE(Desc);
            pos = Desc.indexOf("\n");
            if (pos >= 0)
                Desc = Desc.substring(0, pos);

            $("input.ItemCostDesc").get(rNo).value = Desc.trim();

            // Unit_Price by ig 10/21/2006
            SET_UNIT_PRICE($("input.ItemCost").get(rNo), ItemUnitPrice);

        }
    }
}

function CostChange(ItemNo) {
    var tCost = $("input.ItemCost").get(ItemNo).value;
    if (tCost != "") {
        if (!IsNumeric(tCost)) {
            alert("Please enter a numeric number!");
            $("input.ItemCost").get(ItemNo).value = 0;
            return false;
        }
    }
    var NoItem = parseInt(document.form1.hNoCostItem.value);
    var TotalCost = 0;
    for (var j = 0; j < NoItem; j++) {
        var Cost = $("input.ItemCost").get(j).value;
        if (Cost == "")
            Cost = 0;
        else
            Cost = parseFloat(Cost);

        TotalCost = TotalCost + Cost;
    }
    document.form1.txtTotalCost.value = parseFloat(TotalCost).toFixed(2);
}


function CheckIfMBExist(){ 
  
    var MAWB=document.getElementById("txtMAWB").value;
    var OriginalMAWB="<%=Session("mawb")%>";
    var MAWB_NOT_CHANGED=(MAWB==OriginalMAWB);
    var iType="O";;
    
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
        req.open("get", encodeURI("/ASP/ajaxFunctions/ajax_CheckIfMBExist.asp?MAWB="+MAWB+"&iType="+iType), false);
        req.send(); 
    
        var result =req.responseText.split("-");
        var exist=result[0];
        var MB=result[1];
	       	        
        if(exist=="True"){   
	        		  
            var aFirm=confirm("The MAWB alreay exists in the database."
                + "\n Would you like to reload with the previous MAWB?");			                      
                  
            if(aFirm){    
                LookUp2(); 
            }
            else{
                return false;			
            }	           
        }
        else{
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
            + "&ITYPE=O";
 
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
            + "&ITYPE=O";   
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
