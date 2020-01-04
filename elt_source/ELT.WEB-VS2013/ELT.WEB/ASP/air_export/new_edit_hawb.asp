<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<!--  #INCLUDE FILE="../include/header.asp" -->
<!--  #include file="../include/recent_file.asp" -->
<!--  #INCLUDE file="../include/GOOFY_Util_Ver_2.inc" -->


<%

''@DECLARATION'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Dim vectPiece(100),vectUnitQty(100),vectGrossWeight(100),vectAdjustedWeight(100), vectKgLb(100), vectRateClass(100),vectItemNo(100)
Dim vectDimension(100),vectDimDetail(100),vectChargeableWeight(100),SHIndex,aShippers,aConsignees,aAgents,vectAccounts(100)
Dim vectShippers(100),vectConsignees(100),vectAgents(100),vectHAWBs(100),vectTranNo(100),vectColo(100)
Dim vectHAWBs2(100),vectShippers2(100),vectConsignees2(100),vectAgents2(100),vectUnitQty2(100),vectKgLb2(100),vectTranNo2(100),vectColo2(100)
Dim vectPiece2(100),vectGrossWeight2(100),vectDimension2(100),	vectAdjustedWeight2(100),vectChargeableWeight2(100)
Dim vectPieceTotal2,vectGrossWeightTotal2,vectDimensionTotal2,vectAdjustedWeightTotal2,vectChargeableWeightTotal2,SHIndex2,vMaster_Weight_Charge
Dim vMaster_Gross_Weight,vMaster_Pieces,vMaster_Chargeable_Weight

Dim RemoveSH,rSHAWB,rELTACT,AdjustWeight
Dim vectPieceTotal,vectGrossWeightTotal,vectDimensionTotal,	vectAdjustedWeightTotal,vectChargeableWeightTotal
Dim is_invoice_queued,vCheckMH,vCheckSH,vCanbeMaster

'Dim aM_HAWBInfo(1000),aM_HAWB(1000),aMAWBInfo(1000)
Dim aMAWB()

Dim vIsMasterClosed,CloseMH,OpenMH,vSubNo,mhIndex, vM_HAWB
Dim aSubNoTmp,vDefault_SalesRep,IsColoaded
vDefault_SalesRep=session_user_lname	

Dim vAFCost,vAgentProfit,vAgentProfitPercent,vOtherProfitCarrier,vOtherProfitAgent

Dim vDepCode, vArrCode,vTotalHAWB,vQueueID,NoHAWB,IVstrMsg,vWeightScale
Dim tHAWB,tAW,tRateClass,vExecutionDatePlace,AgentName,AgentCity,AgentState,AgentZip,AgentCountry
Dim pIndex,coIndex,vTotalAdjustedWeight,vRefNo,vDeclaredValueCarriage,TempShare
DIM AddWC,AddOC,Edit,NewHAWB,Save, SaveAsNew,DeleteWC,DeleteOC,vHAWBPrefix,rURL,AutoSave,DeleteHAWB
Dim qMAWB,vMAWB,vMAWBInfo,vHAWB,aChargeItemNo(1024),aChargeItemName(1024),aChargeItemDesc(1024),chIndex,aChargeItemNameig(1024)

DIM aChargeUnitPrice(1024),aColoderName(100),aColoderAcct(100),aColodeeName(100),aColodeeAcct(100)

'/////////////////// GET_MAWB_INFO ///////////////////////////////////////////////////////
Dim mMawbNo,mDepartureAirport, mTo, mBy, mTo1, mBy1, mTo2, mBy2,mDestAirport,mDestCountry
Dim mFlight1,mFlight2,mETDDate,mFlightDate1,mFlightDate2,mCarrierDesc,mCount
DIM mIndex,mFile,mOrgNum,mDepartureAirportCode,mExportDate,mDepartureState,vManifestDesc
Dim vAirOrgNum,vFFShipperAcct,vFFAgentName,vFFAgentAcct,vFFAgentInfo
DIM	vFFConsigneeAcct,vDepartureState,vExportDate,vNotifyAcct,vNotifyName,vCI,vOtherRef,vLC
DIM vPrepaidWeightCharge,vCollectWeightCharge,vPrepaidOtherChargeAgent,vCollectOtherChargeAgent
DIM vPrepaidOtherChargeCarrier,vCollectOtherChargeCarrier,vPrepaidTotal
DIM vCollectTotal,vPrepaidValuationCharge,vCollectValuationCharge
DIM	vPrepaidTax,vCollectTax,vConversionRate,vCCCharge,vChargeDestination,vFinalCollect
DIM vExecute,vCOLO,vCOLOPay,vColoderAcct,vColodeeAcct,wIndex,vDemDetail,oIndex,NoItemOC,vTotalChargeableWeight
'/////////////////// get agent,shipper,consignee,vendor info /////////////////////////////
Dim aAgentName(4096),aAgentInfo(2),aAgentAcct(4096),aShipperName(4096),aShipperInfo(2),aShipperAcct(4096)
Dim aConsigneeName(4096),aConsigneeInfo(2),aConsigneeAcct(4096)
Dim aNotifyName(4096),aNotifyInfo(2),aNotifyAcct(4096),aIndex,cIndex,sIndex,vIndex,nIndex
'/////////////////////////////////////////////////////////////////////////////////////////

Dim qShipperName,vShipperInfo,vShipperName,qShipperAcct,vShipperAcct
Dim qConsigneeName, vConsigneeName, vConsigneeInfo,qConsigneeAcct,vConsigneeAcct,qNotify
Dim vAgentInfo,vAgentIATACode,vAgentAcct,vDepartureAirport, vTo, vBy, vTo1, vBy1, vTo2, vBy2
Dim vOriginPortID,vDestAirport,vFlightDate1,vFlightDate2,vIssuedBy,vAccountInfo
Dim vCurrency, vChargeCode, vPPO_1, vCOLL_1, vPPO_2, vCOLL_2,vDeclaredValueCustoms,vInsuranceAMT
Dim vHandlingInfo, vDestCountry,vSCI,vSignature,vPlaceExecuted,vDimText,MAWBTemp
Dim aTranNo(3),aPiece(1536),aUnitQty(1536),aGrossWeight(1536),aAdjustedWeight(1536),aKgLb(1536),aRateClass(1536),aItemNo(1536),aHAWB(1536),SHELTAcct(1536),aSHAWB(1536) 
Dim aDimension(1536),aDimDetail(3),aChargeableWeight(1536),aRateCharge(1536),aTotal(1536)
Dim vTotalPieces,vTotalGrossWeight,vTotalWeightCharge,vDesc1,vDesc2
Dim vShowWeightChargeShipper,vShowWeightChargeConsignee,aCarrierAgent(1280),aCollectPrepaid(1280),aChargeCode(1280)
Dim aDesc(1280),aChargeAmt(1280),aVendor(1280),aCost(1280),aOtherCharge(640)
Dim vShowPrepaidOtherChargeShipper,vShowCollectOtherChargeShipper
Dim vShowPrepaidOtherChargeConsignee,vShowCollectOtherChargeConsignee
Dim NotifyTemp,NotifyInfoTemp,cName,cAddress,cCity,cState,cZip,cCountry,cPhone
Dim aHAWBPrefix(128),aNextHAWB(128),rs,SQL,rs3

Dim vSalesPerson,aSRName(1000),SRIndex,co2Index,vAES,vReferenceNumber,AVIndex,vectAVHAWBs(100)
DIM vectAVShippers(100),vectAVConsignees(100),vectAVAgents(100)
DIM vectAVPiece(100),vectAVGrossWeight(100),vectAVAdjustedWeight(100),vectAVDimension(100)
DIM vectAVChargeableWeight(100),vectAVELTAcct(100),tmpAgent(100)

DIM vectAVGrossWeightTotal,vectAVAdjustedWeightTotal,vectAVDimensionTotal,vectAVChargeableWeightTotal
DIM vectAVPieceTotal,vDiscardMH,vSubCount,dict,vSEDStmt,AgentCountryCode,vSONum,vPONum

''@INITIALIZATION'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    vCanbeMaster=true
    IsColoaded=false
    Set rs = Server.CreateObject("ADODB.Recordset")
    Set rs3 = Server.CreateObject("ADODB.Recordset")
    vMaster_Weight_Charge=0
    AdjustWeight=Request.QueryString("AdjustWeight")
    is_invoice_queued=checkBlank(Request("hIs_invoice_queued"),"N")
    RemoveSH=request.QueryString("RemoveSH")
    rSHAWB=request.QueryString("rSHAWB")
    rELTACT=request.QueryString("ELTACT")
    CloseMH=Request.QueryString("CloseMH")
    OpenMH=Request.QueryString("OpenMH")
    Save=Request.QueryString("Save")
    AddWC=Request.QueryString("AddWC")
    AddOC=Request.QueryString("AddOC")
    Edit=Request.QueryString("Edit")
    NewHAWB=Request.QueryString("New")
    DeleteWC=Request.QueryString("DeleteWC")
    DeleteOC=Request.QueryString("DeleteOC")
    vHAWB=Request.QueryString("HAWB")
    rURL=Request.QueryString("rURL")
    AutoSave=Request("cAutoSave")
    DeleteHAWB=Request.QueryString("DeleteHAWB")
    SaveAsNew=Request.QueryString("SaveAsNew")
    vHAWBPrefix=Request("hHAWBPrefix")
    vCheckSH=checkBlank(Request("hCheckSH"),"N")
    vCheckMH=checkBlank(Request("hCheckMH"),"N")
    vDiscardMH=Request("hDiscardMH")
    vSubCount=checkBlank(Request("hSubCount"),0)
    
    '// Avoid data saving when back or refresh
    tNo=Request.QueryString("tNo")
    if tNO="" Then
	    Session("HAWBTranNo") = ""
	    tNO=0
    else
	    tNo=cLng(tNo)
    end if
    TranNo=Session("HAWBTranNo")
    if TranNo="" then
	    Session("HAWBTranNo")=0
	    TranNo=0
    end if

    if Save= "yes" and ( tNO <> TranNo ) then
		    if vHAWB = "" then 
			    vHAWB = Request("txtHAWB")
		    end if	
		    Edit = "yes"
		    Save = ""
    end if
''@INITIALIZATION END ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

''@MAIN LOGIC'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    'response.end

    eltConn.BeginTrans

    CALL REDIRECT_URL
    CALL GET_HAWB_PREFIX_FROM_USER_PROFILE
    CALL GET_DEFAULT_WEIGHT_SCALE
   'response.end
    CALL MAIN_PROCESS    
  
    CALL GET_MAWB_INFO
  'response.end
    CALL GET_AVAIL_HAWB
  'response.end
    CALL GET_DEP_ARR_CODE
  'response.end
    CALL GET_CHARGE_ITEM_INFO
  'response.end
    CALL GET_COLODER_INFO
  'response.end
    CALL FINAL_SCREEN_PREPARE	
  'response.end
    CALL GET_PRESHIPMENT_DATA
  'response.end
    
    eltConn.CommitTrans


Sub GET_PRESHIPMENT_DATA
    Dim SQL,rs
    Set rs = Server.CreateObject("ADODB.Recordset")
    
    If Request.QueryString("DataTransfer") = "SO" And Request.QueryString("SONum") <> "" Then
        vSONum = Request.QueryString("SONum")
        SQL = "SELECT * FROM warehouse_shipout WHERE elt_account_number=" _
            & elt_account_number & " AND so_num=N'" & vSONum & "'"

        rs.CursorLocation = adUseClient	
	    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
        Set rs.ActiveConnection = Nothing
        
        If Not rs.EOF And Not rs.BOF Then
            vShipperAcct = rs("customer_acct")
            vShipperName = GetBusinessName(rs("customer_acct"))
            vShipperInfo = GetOrgNameAddress(rs("customer_acct"))
            vConsigneeAcct = rs("consignee_acct")
            vConsigneeName = GetBusinessName(rs("consignee_acct"))
            vConsigneeInfo = GetOrgNameAddress(rs("consignee_acct")) 
            vNotifyAcct = rs("consignee_acct")
            vAccountInfo = GetOrgNameAddress(rs("consignee_acct")) 
        End If
        
        rs.close()
        
        SQL = "SELECT * FROM warehouse_receipt a LEFT OUTER JOIN warehouse_history b " _
            & "ON (a.elt_account_number=b.elt_account_number AND a.wr_num=b.wr_num) " _
            & "WHERE a.elt_account_number=" + elt_account_number + " AND b.so_num=N'" _
            & vSONum & "' AND history_type='Ship-out Made'"
        rs.CursorLocation = adUseClient	
	    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
        Set rs.ActiveConnection = Nothing
        
        aPiece(0) = 0
        Do While Not rs.EOF And Not rs.BOF
            vDesc2 = vDesc2 & rs("item_desc") & chr(10)
            vHandlingInfo = vHandlingInfo & rs("handling_info") & chr(10)
            aPiece(0) = aPiece(0) + CInt(rs("item_piece_shipout"))
            rs.MoveNext()
        Loop
    
    Elseif Request.QueryString("DataTransfer") = "PO" And Request.QueryString("PONum") <> "" Then
        vPONum = Request.QueryString("PONum")
        SQL = "SELECT * FROM pickup_order WHERE elt_account_number=" _
            & elt_account_number & " AND po_num=N'" & vPONum & "'"
            
        rs.CursorLocation = adUseClient	
	    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
        Set rs.ActiveConnection = Nothing
        
        If Not rs.EOF And Not rs.BOF Then
            vOtherRef = rs("customer_ref_no")
            
            vShipperAcct = rs("shipper_account_number")
            vShipperName = rs("Shipper_Name")
            vShipperInfo = rs("Shipper_Info")
            vConsigneeAcct = rs("Carrier_account_number")
            vConsigneeName = rs("Carrier_Name")
            vConsigneeInfo = rs("Carrier_Info")
            vNotifyAcct = rs("Carrier_account_number")
            vAccountInfo = rs("Carrier_Info")
            
            vHandlingInfo = rs("Handling_Info")
            vDepartureAirport = GetPortInfo(rs("Origin_Port_Code"),"port_desc")
            vDestAirport = GetPortInfo(rs("Dest_Port_Code"),"port_desc")
            
            If IsNumeric(rs("Total_Pieces")) Then
                aPiece(0) = rs("Total_Pieces")
            End If
            vDesc2 = rs("Desc2")
            aGrossWeight(0) = rs("Total_Gross_Weight")
            aAdjustedWeight(0) = rs("Total_Gross_Weight")
            aChargeableWeight(0) = rs("Total_Gross_Weight")
            akglb(0) = Left(rs("Weight_Scale"),1)
        End If

        rs.close()

    End If
    
    If Save = "yes" And vSONum <> "" Then
	    SQL="UPDATE warehouse_shipout SET file_type='AE',master_num=N'" & vMAWB _
	        & "',house_num=N'" & vHAWB & "' WHERE so_num=N'" & vSONum & "'"
	    eltConn.Execute(SQL)
	Elseif Save = "yes" And vPONum <> "" Then
        SQL="UPDATE pickup_order SET file_type='AE',MAWB_NUM=N'" & vMAWB _
	        & "',HAWB_NUM=N'" & vHAWB & "' WHERE po_num=N'" & vPONum & "'"
	    eltConn.Execute(SQL)
    End If
End Sub


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:MAIN_PROCESS
'Purpose  of the procedure: The procedure is in charge of splitting the tasks related to MAWB, according
'to the user request to the page
'Group of the tasks that are performed within:
'Group 1 Editing and Saving
'Group 2 Invoice Queue related
'Group 3 Getting the HAWB related information from Screen
'Group 4 Getting the HAWB related information from DB
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB MAIN_PROCESS
	addSUB=Request.QueryString("addSUB")
	if addSUB="yes" then
		addSUBNo=Request.QueryString("addSUBNo")
		addELTAcct=Request.QueryString("addELTAcct")
		MAWB=Request.QueryString("MAWB")
		CALL ADD_SUB_TO_MASTER(vHAWB,addSUBNo,addELTAcct,MAWB)
	end if 
	if RemoveSH="Y" then
		REMOVE_A_SUB_HOUSE_FROM_MASTER
	end if
	CALL GET_SALES_PERSONS_FROM_USERS
	If EDIT = "yes" Then
		Session("HAWBTMP") = vHAWB    
	End If
	
	if vHAWBPrefix = "" then
		if not vHAWB = "" then
			pos=0
			pos=instr(vHAWB,"-")
			if pos>0 then
				vHAWBPrefix=Mid(vHAWB,1,pos-1)
			end if
		end if
	end if
	if vHAWBPrefix="NONE" then 
		vHAWBPrefix="" 
	end if
	if DeleteHAWB="yes" then  
		CALL DELETE_HAWB( vHAWB )
		EXIT SUB
	end if
	if NewHAWB="yes" then
		Save="yes"
	end if
	IF Save="yes" or AddWC="yes" or AddOC="yes" or DeleteWC="yes" or DeleteOC="yes" or AdjustWeight = "yes" or addSUB="yes"  or RemoveSH="Y" THEN
           
	
		CALL GET_HAWB_HEADER_INFO_FROM_SCREEN	
		CALL CHECK_IF_COLOADED
		NoItemWC = GET_HAWB_WEIGHT_CHARGE_ITEM_LINE()
		NoItemWC=1
		CALL GET_HAWB_ITEM_WEIGHT_CHARGE_INFO( NoItemWC )
		NoItemOC = GET_HAWB_OTHER_CHARGE_ITEM_LINE()
		CALL GET_HAWB_ITEM_OTHER_CHARGE_INFO( NoItemOC )
		if DeleteWC="yes" then
			dItemNo=Request.QueryString("dItemNo")
			CALL DELETE_WEGHT_CHARGE_ITEM( dItemNo , NoItemWC )
			NoItemWC=NoItemWC-1
		end if
		if DeleteOC="yes" then
			dItemNo=Request.QueryString("dItemNo")
			CALL DELETE_OTHER_CHARGE_ITEM( dItemNo , NoItemOC )
			NoItemOC=NoItemOC-1
		end if
		CALL GET_HAWB_HEADER_INFO_ETC(  NoItemWC , NoItemOC )

		if not vOriginPortID="" and not vTo="" and not vPPO_1="Y" Then
			
			CALL GET_AGENT_PROFIT_INFO
		end if
'response.end
		IF Save="yes" And tNo=TranNo then
			CALL ADD_OR_UPDATE_HAWB_TABLE( vHAWB )

			Session("HAWBTMP") = vHAWB
			Session("HAWBTranNo")=Clng(Session("HAWBTranNo"))+1
			TranNo=Clng(Session("HAWBTranNo"))
			CALL UPDATE_CARGO_TRACKING_FOR_SHIPPING_REQUEST
			CALL UPDATE_WEIGHT_CHARGE_TABLE( NoItemWC )
			CALL UPDATE_OTHER_CHARGE_TABLE( NoItemOC )			
			CALL INVOICE_QUEUE_REFRESH( vHAWB )
			CALL HAWB_INVOICE_QUEUE( vHAWB, vMAWB )					
		END IF		
		if vCheckMH ="Y" and (AdjustWeight = "yes" or addSUB="yes" or RemoveSH="Y") then 
			CALL SUMUP_WEIGHT_CHARGES_BELONG_TO_MASTER_HOUSE(vM_HAWB)		
			if aRateCharge(0)="N/A" then
				aRateCharge(0)=0
			end if 
			if  aRateCharge(0)<>"N/A" or checkBlank(aRateCharge(0),0) then
				aTotal(i)=checkBlank(aRateCharge(0),0)*checkBlank(aChargeableWeight(0),0)
			end if 			
		end  if 	
		EXIT SUB		
	Else    
		If NewHAWB = "yes" And IsNull(vAgentInfo) Or vAgentInfo = "" Then
			Call GET_AGENT_GENERAL_INFORMAION
		End If
		vCurrency = GetSQLResult("SELECT currency FROM user_profile WHERE elt_account_number=" & elt_account_number, "currency")
	END IF	
	
    CALL CHECK_IF_COLOADED
    CALL GET_HAWB_INFORMATION_FROM_TABLE
		
END SUB


Sub REDIRECT_URL
    Dim SQL,rs
	Set rs = Server.CreateObject("ADODB.Recordset")
    IF Save="yes" or AddWC="yes" or AddOC="yes" or DeleteWC="yes" or DeleteOC="yes" or AdjustWeight = "yes" or addSUB="yes"  or RemoveSH="Y" THEN
    Else
        SQL = "SELECT is_dome FROM hawb_master WHERE elt_account_number=" & elt_account_number _
            & " AND hawb_num=N'" & vHAWB & "'"
        
	    rs.CursorLocation = adUseClient	
	    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
        Set rs.ActiveConnection = Nothing

        If NOT rs.EOF AND NOT rs.BOF Then
            If rs("is_dome") = "Y" Then
                Response.Write("<script> parent.document.frames['topFrame'].changeTopModule('Domestic'); window.location.href='/ASP/domestic/new_edit_hawb.asp?mode=search&HAWB=" & vHAWB & "'; </script>")    
                Response.End()
            End If
            rs.close()
        End If
    End If
End Sub


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE: GET_AVAIL_HAWB
'Purpose  of the procedure: The procedure is in charge of getting all the available HAWBs  that are 
'							listed in the availble sub houses on the screen
'Tasks that are performed within:				    
'1. Retrieve all the weight charge information pertaining to each HAWB in order to fill in the screen
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB GET_AVAIL_HAWB

	vectAVGrossWeightTotal=0
	vectAVAdjustedWeightTotal=0
	vectAVDimensionTotal=0
	vectAVChargeableWeightTotal=0
	vectAVPieceTotal=0
	
	DIM rs
	Dim tKgLb		
	Set rs = Server.CreateObject("ADODB.Recordset")		
	    SQL = "select a.elt_account_number,a.hawb_num,a.agent_name,a.Shipper_name,a.Consignee_name, " _
	    & "b.tran_no,b.no_pieces,b.rate_class,b.kg_lb,b.gross_weight,b.adjusted_weight,b.chargeable_weight,b.dimension from hawb_master a  INNER JOIN hawb_weight_charge b " _
	    & " on (a.elt_account_number=b.elt_account_number) and (a.hawb_num=b.hawb_num) " _
	    & " where (a.elt_account_number=" & elt_account_number _
	    & ") and a.is_dome='N' and isnull(a.is_sub,'N')='N' and  isnull(a.is_master,'N')='N' and (isnull(a.MAWB_NUM,'')='' OR a.MAWB_NUM=N'" & vMAWB & "') and (colo='N' OR isnull(colo,'')='') " _
	    & " UNION " _
	    & "select a.elt_account_number,a.hawb_num,a.agent_name,a.Shipper_name,a.Consignee_name, " _
	    & "b.tran_no,b.no_pieces,b.rate_class,b.kg_lb,b.gross_weight,b.adjusted_weight,b.chargeable_weight,b.dimension from hawb_master a  INNER JOIN hawb_weight_charge b " _
	    & " on (a.elt_account_number=b.elt_account_number) and (a.hawb_num=b.hawb_num) " _
	    & " where ( a.coloder_elt_acct=" & elt_account_number _
	    & ") and a.is_dome='N' and ( isnull(a.MAWB_NUM,'') = '' OR a.MAWB_NUM=N'" & vMAWB & "') and isnull(a.is_sub,'N')='N'and  isnull(a.is_master,'N')='N' order by a.hawb_num,b.tran_no"
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	AVIndex=0

	Do While Not rs.EOF And AVIndex < 100 		
		tran_no = CInt(checkBlank(rs("tran_no"),0))
		
		if tran_no>0 then
			tKgLb=rs("kg_lb")
			vectAVHAWBs(AVIndex)=rs("hawb_num")	
			vectAVPiece(AVIndex)=cdbl(checkBlank(rs("no_pieces"),0))		
			vectAVPieceTotal=vectAVPieceTotal+vectAVPiece(AVIndex)
			vectAVGrossWeight(AVIndex)=cdbl(checkBlank(rs("gross_weight"),0))	
			vectAVGrossWeightTotal=vectAVGrossWeightTotal+vectAVGrossWeight(AVIndex)			
			vectAVAdjustedWeight(AVIndex)=cdbl(checkBlank(rs("adjusted_weight"),0))	
			vectAVAdjustedWeightTotal=vectAVAdjustedWeightTotal+vectAVAdjustedWeight(AVIndex)				
			vectAVChargeableWeight(AVIndex)=cdbl(checkBlank(rs("Chargeable_Weight"),0))	
			vectAVChargeableWeightTotal=vectAVChargeableWeightTotal+vectAVChargeableWeight(AVIndex)				
			vectAVDimension(AVIndex)=cdbl(checkBlank(rs("dimension"),0))
			vectAVDimensionTotal=vectAVDimensionTotal+vectAVDimension(AVIndex)					
			if not tKgLb=aKgLb(0) then
				if aKgLb(0)="K" then
					vectAVGrossWeight(AVIndex)=FormatNumberPlus(vectAVGrossWeight(AVIndex)*0.454,2)
					vectAVAdjustedWeight(AVIndex)=FormatNumberPlus(vectAVAdjustedWeight(AVIndex)*0.454,2)
					vectAVChargeableWeight(AVIndex)=FormatNumberPlus(vectAVChargeableWeight(AVIndex)*0.454,2)
				else
					vectAVGrossWeight(AVIndex)=FormatNumberPlus(vectAVGrossWeight(AVIndex)*2.2,2)
					vectAVAdjustedWeight(AVIndex)=FormatNumberPlus(vectAVAdjustedWeight(AVIndex)*2.2,2)
					vectAVChargeableWeight(AVIndex)=FormatNumberPlus(vectAVChargeableWeight(AVIndex)*2.2,2)
				end if
			end if
			vectAVELTAcct(AVIndex)=rs("elt_account_number")	
			vectAVAgents(AVIndex) = rs("agent_name")			
			vectAVShippers(AVIndex) = rs("Shipper_name")
			vectAVConsignees(AVIndex) = rs("Consignee_name")
		end if			
		AVIndex=AVIndex+1
		rs.MoveNext
	Loop
	rs.Close
	set rs = nothing
END SUB

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE: FREE_ALL_SUB_HOUSE
'Purpose  of the procedure: The procedure is in charge of resetting all the selected sub houses to the 
'							regular houses 
'Tasks that are performed within:									    
'1.Reset all the sub houses back to regular houses
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB FREE_ALL_SUB_HOUSE
	dim SQL	
	SQL="UPDATE hawb_master set is_sub='N',sub_to_no='' where (elt_account_number=" & elt_account_number _
	    & " OR coloder_elt_acct=" & elt_account_number & " ) and is_dome='N' and isnull(is_sub,'')='Y' and isnull(sub_to_no,'')=N'" & vHAWB & "'"
	
	eltConn.Execute(SQL)
END SUB 


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE: UPDATE_ALL_SUB_HOUSE_INFO
'Purpose  of the procedure: The procedure is in charge of chaning  all the selected sub houses to reflect 
'							the MAWB information change done on the master hosue
'Tasks that are performed within:									    
'1.Change  all the sub houses with the MAWB information of the their master house
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB UPDATE_ALL_SUB_HOUSE_INFO(IS_QUE)
	
    dim rs, SQL, HAWBS(50),hhIndex
	
	set rs= Server.CreateObject("ADODB.Recordset")
	
	SQL= "select hawb_num as hb from hawb_master  where (elt_account_number= " _
	    & elt_account_number & " or coloder_elt_acct=" _
	    & elt_account_number & ") and is_dome='N' and is_sub='Y' and sub_to_no=N'" & vHAWB & "'"
	
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	
	If Not rs.EOF Then
		hhIndex=0
		Do While Not rs.EOF
			HAWBS(hhIndex)=rs("hb")
			hhIndex=hhIndex+1
			rs.MoveNext		
		Loop
			
	End If
	rs.close

	set rs=nothing 
	set rs= Server.CreateObject("ADODB.Recordset")

	For i =0 to hhIndex -1
	
		SQL= "select * from hawb_master  where (elt_account_number= " _
		    & elt_account_number & " or coloder_elt_acct=" _
		    & elt_account_number & ") and is_dome='N' and is_sub='Y' and hawb_num=N'"& HAWBS(i) & "'"
		rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText	
        
        
		if not rs.EOF then
			rs("mawb_num")=vMAWB
			rs("airline_vendor_num")=vAirOrgNum		
			rs("DEP_AIRPORT_CODE") = vOriginPortID
			rs("Departure_Airport") = vDepartureAirport
			rs("To_1") = vTo
			rs("by_1") = vBy 
			rs("To_2") = vTo1
			rs("By_2") = vBy1
			rs("To_3") = vTo2
			rs("By_3") = vBy2			
			rs("Dest_Airport") = vDestAirport
			rs("Flight_Date_1") = vFlightDate1
			rs("Flight_Date_2") = vFlightDate2
			rs("export_date")=vExportDate
			rs("dest_country")=vDestCountry
			rs("departure_state")=vDepartureState
			rs("IssuedBy")=vIssuedBy   
			rs("Execution")=vExecute			
			if checkBlank(rs("coloder_elt_acct"),0)= elt_account_number then 
			else 
				rs("is_invoice_queued")=IS_QUE			
			end if 			
			rs.Update
		end if 
		rs.close
	next
	
	set rs=nothing 
END SUB 

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE: REMOVE_A_SUB_HOUSE_FROM_MASTER
'Purpose  of the procedure: The procedure is in charge of removal of a sub house from the HAWB
'Tasks that are performed within:									    
'1.Reset a sub house to be a regular house
'2.Reset the sub house's invoice queue property so that the house air way bill can generate invoice queue
'  entry which is allow in reqular house airway bill by default
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB REMOVE_A_SUB_HOUSE_FROM_MASTER
	dim SQL	
	SQL="UPDATE hawb_master set is_sub='N',is_invoice_queued='Y', mawb_num='', sub_to_no='' " _
	    & "where elt_account_number=" & rELTACT & " and is_dome='N' and hawb_num=N'" & rSHAWB&"' "
	
	eltConn.Execute(SQL)
END SUB 


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:ADD_SUB_TO_MASTER
'Purpose  of the procedure: The procedure is in charge of adding an available HAWB to the current House
'Tasks that are performed within:									    
'1.Set is_sub to be 'Y' and set sub_to_no to be the HAWB# of the current HAWB so that it becomes a sub
' house to the current HAWB
'2.Set is_invoice_queued to b 'N', because whether to create invoice queue or not will be decided when
' saving the HAWB
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

SUB ADD_SUB_TO_MASTER(vHAWB,addSUBNo,addELTAcct,vMAWB)   
	dim SQL	
	SQL="UPDATE hawb_master set is_sub='Y',sub_to_no=N'"& vHAWB _
	    &"',is_invoice_queued='N',mawb_num=N'" & vMAWB & "' where elt_account_number=" _
	    & addELTAcct & " and is_dome='N' and hawb_num=N'"& addSUBNo & "'"
	
	eltConn.Execute(SQL)
END SUB 

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_ONE_MAWB_INFO
'Purpose  of the procedure: The procedure is in charge of retrieving a master airway bill info to be used 
'in current HAWB and its sub hosues
'Tasks that are performed within:									    
'1.Retrieve a MAWB info from DB
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
FUNCTION GET_ONE_MAWB_INFO(MAWB)
	dim rs2, SQL    
	set rs2=Server.CreateObject("ADODB.Recordset")	
	SQL= "select a.mawb_no,a.Origin_Port_ID, a.Dest_Port_ID, a.Origin_Port_ID,a.Origin_Port_Location," _
	    & "a.origin_port_state,a.[To],a.[By],a.To_1,a.By_1,a.To_2,a.By_2,a.Dest_Port_Location," _
	    & "a.dest_port_country,a.Flight#1,a.Flight#2,a.ETD_DATE1,a.ETD_DATE2,a.Carrier_Desc," _
	    & "a.file#,b.org_account_number from mawb_number a,organization b " _
	    & "where a.elt_account_number=b.elt_account_number and a.elt_account_number = " & elt_account_number _
	    & " and a.is_dome='N' And a.carrier_code=b.carrier_code and a.mawb_no=N'" & MAWB & "'"
	
	
	rs2.CursorLocation = adUseClient
	rs2.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs2.activeConnection = Nothing
	
	If Not rs2.EOF Then
		mMAWBNo = rs2("mawb_no")
		mOrgNum=rs2("org_account_number")
		vDepCode=rs2("Origin_Port_ID")
		vArrCode =rs2("Dest_Port_ID")
		mDepartureAirportCode = rs2("Origin_Port_ID")
		mDepartureAirport = rs2("Origin_Port_Location")
		mDepartureState=rs2("origin_port_state")
		mTo= rs2("To")
		mBy = rs2("By")
		mTo1= rs2("To_1")
		mBy1 = rs2("By_1")
		mTo2= rs2("To_2")
		mBy2 = rs2("By_2")
		mDestAirport = rs2("Dest_Port_Location")
		mDestCountry=rs2("dest_port_country")
		mFlight1 = rs2("Flight#1")
		mFlight2 = rs2("Flight#2")
		mETDDate1 = rs2("ETD_DATE1")
		mExportDate=mETDDate1
		mETDDate2 = rs2("ETD_DATE2")
		mCarrierDesc = rs2("Carrier_Desc")
		if not mFlight1="" then
			mFlightDate1=mFlight1 & "/" & day(mETDDate1)
		else
			mFlightDate1=""
		end if
		if not mFlight2="" then
			mFlightDate2=mFlight2 & "/" & day(mETDDate2)
		else
			mFlightDate2=""
		end if
		mFile=rs2("file#")
		mIndex = mIndex + 1
		
		GET_ONE_MAWB_INFO=MAWB&chr(10)&mOrgNum & chr(10) & mDepartureAirportCode & chr(10) & mDepartureAirport & chr(10) & mTo & chr(10) & mBy & Chr(10) & mTo1 & chr(10) & mBy1 & chr(10) & mTo2 & chr(10) & mBy2 & chr(10) & mDestAirport & chr(10) & mFlightDate1 & chr(10) & mFlightDate2 & chr(10) & mCarrierDesc & chr(10) & mExportDate & chr(10) & mDestCountry & chr(10) & mDepartureState & chr(10) & mFile
	End If
	rs2.close
	
	set rs2=nothing 
END FUNCTION

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:SUMUP_WEIGHT_CHARGES_BELONG_TO_MASTER_HOUSE
'Purpose of the procedure: The procedure is in charge of making a W/C list from W/C's in DB belong to  
'all the sub houses and to sumup the list 
'Tasks that are performed within:									    
'1.Sumup all the sub houses' WCs
'2.Create lists of information with the WCs of each house
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB SUMUP_WEIGHT_CHARGES_BELONG_TO_MASTER_HOUSE(masterHAWB)
	
	dim rs,SQL
	set rs=Server.CreateObject("ADODB.Recordset")
	Set aSubHouses = Server.CreateObject("System.Collections.ArrayList")
	Set aAccounts = Server.CreateObject("System.Collections.ArrayList")
	Set aShippers = Server.CreateObject("System.Collections.ArrayList")
	Set aConsignees = Server.CreateObject("System.Collections.ArrayList")
	Set aAgents= Server.CreateObject("System.Collections.ArrayList")
	Set aColo=Server.CreateObject("System.Collections.ArrayList")
	Set aIsInvoiceQueued=Server.CreateObject("System.Collections.ArrayList")	
	SQL= "select * from hawb_master where is_sub='Y' and (elt_account_number = " _
	    & elt_account_number & " or coloder_elt_acct = " & elt_account_number _
	    & ") and is_dome='N' and sub_to_no=N'" & vHAWB& "'"
	
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	
	Do While Not rs.eof And Not rs.bof 
		aSubHouses.Add rs("hawb_num").value
		aAccounts.Add rs("elt_account_number").value
		aShippers.Add rs("Shipper_Name").value
		aConsignees.Add rs("Consignee_Name").value
		aAgents.Add rs("Agent_Name").value
		aColo.Add rs("colo").value
		aIsInvoiceQueued.Add rs("is_invoice_queued").value
		if checkBlank(rs("is_invoice_queued"),"Y") <>"Y" then
			vMaster_Weight_Charge = vMaster_Weight_Charge + cDbl(checkBlank(rs("Total_Weight_Charge_HAWB"),0))
		end if 
		rs.MoveNext
	Loop
	rs.Close	
	wIndex=0
	upperbound=aSubHouses.count -1 
	SHIndex=0
	SHIndex2=0
	vectPieceTotal=0
	vectGrossWeightTotal=0
	vectDimensionTotal=0
	vectAdjustedWeightTotal=0
	vectChargeableWeightTotal=0	
	for p=0 to upperbound	
		call GET_WEIGHT_CHARGES_FOR_A_HAWB ( aSubHouses(p), aAccounts(p),aShippers(p),aConsignees(p),aAgents(p),aColo(p),aIsInvoiceQueued(p) ) 
	next 	
	NoItemWC=1
	vTotalPieces=0
	vTotalGrossWeight=0
	vTotalChargeableWeight=0
	vTotalAdjustedWeight=0	
	dim i
	for i=0 to wIndex-1
		vTotalPieces=vTotalPieces+aPiece(i)
		vTotalGrossWeight=vTotalGrossWeight+checkBlank(aGrossWeight(i),0)
		vTotalChargeableWeight=vTotalChargeableWeight+checkBlank(aChargeableWeight(i),0)
		vTotalAdjustedWeight=vTotalAdjustedWeight+checkBlank(aAdjustedWeight(i),0)
	next
	aPiece(0)=vectPieceTotal		
	aGrossWeight(0)=vectGrossWeightTotal
	aAdjustedWeight(0)=vectAdjustedWeightTotal
	aDimension(0)=vectDimensionTotal
	aChargeableWeight(0)=vectChargeableWeightTotal
	aKgLb(0)=vectKgLb(0)
	set rs=nothing 
END SUB 


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:SUMUP_WEIGHT_CHARGES_BELONG_TO_MASTER_HOUSE_BEFORE_SAVE
'Purpose  of the procedure: The procedure is in charge of making a W/C list from W/C's from all the sub
'houses and to sumup the list befor the save action 
'Tasks that are performed within:									    
'1.
'2.
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB SUMUP_WEIGHT_CHARGES_BELONG_TO_MASTER_HOUSE_BEFORE_SAVE(masterHAWB)
	dim rs,SQL
	set rs=Server.CreateObject("ADODB.Recordset")
	Set aSubHouses = Server.CreateObject("System.Collections.ArrayList")
	Set aAccounts = Server.CreateObject("System.Collections.ArrayList")
	Set aShippers = Server.CreateObject("System.Collections.ArrayList")
	Set aConsignees = Server.CreateObject("System.Collections.ArrayList")
	Set aAgents= Server.CreateObject("System.Collections.ArrayList")	
	Set aColo=Server.CreateObject("System.Collections.ArrayList")
	Set aIsInvoiceQueued=Server.CreateObject("System.Collections.ArrayList")
	
	SQL= "select hawb_num,elt_account_number,Shipper_Name,Consignee_Name,Agent_Name,colo," _
	    & "is_invoice_queued from hawb_master where is_sub='Y' and is_dome='N' and (elt_account_number=" _
	    & elt_account_number & " or coloder_elt_acct=" & elt_account_number & ") and sub_to_no=N'" & vHAWB& "'"
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	
	vMaster_Weight_Charge=0
	vMaster_Gross_Weight=0
	vMaster_Pieces=0
	vMaster_Chargeable_Weight=0
	
	Do While Not rs.eof And Not rs.bof 
		aSubHouses.Add rs("hawb_num").value
		aAccounts.Add rs("elt_account_number").value
		aShippers.Add rs("Shipper_Name").value
		aConsignees.Add rs("Consignee_Name").value
		aAgents.Add rs("Agent_Name").value
		aColo.Add rs("colo").value
		aIsInvoiceQueued.Add rs("is_invoice_queued").value
		rs.MoveNext
	Loop
	rs.Close
	wIndex=0
	upperbound=aSubHouses.count -1 
	SHIndex=0
	SHIndex2=0
	vectPieceTotal=0
	vectGrossWeightTotal=0
	vectDimensionTotal=0
	vectAdjustedWeightTotal=0
	vectChargeableWeightTotal=0
	for p=0 to upperbound
		call GET_WEIGHT_CHARGES_FOR_A_HAWB_BEFORE_SAVE( aSubHouses(p), aAccounts(p),aShippers(p),aConsignees(p),aAgents(p),aColo(p),aIsInvoiceQueued(p)) 
	next 
	NoItemWC=1
	set rs=nothing 
END SUB 


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_WEIGHT_CHARGES_FOR_A_HAWB
'Purpose  of the procedure: The procedure is in charge of getting weight charges for a HAWB and put them 
' into the arrays that will be displayed in the selected sub houses 
'Tasks that are performed within:									    
'1.Get weight charges for a hawb 
'2.Sumup them and put them in the varialbes that will be displayed  on the screen
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Sub GET_WEIGHT_CHARGES_FOR_A_HAWB(vHB,account,Shipper,Consignee,Agent,colo,is_invoice_queued)
    DIM rs
    DIM WC_COLLECT, WC_PREPAID
    WC_COLLECT=0
    WC_PREPAID=0	
    set rs=Server.CreateObject("ADODB.Recordset")
	 SQL= "select unit_qty,kg_lb,tran_no,no_pieces,gross_weight,dimension,adjusted_weight," _
	    & "chargeable_weight,no_pieces,gross_weight from hawb_weight_charge where elt_account_number=" _
	    & account & " and hawb_num=N'" & vHB & "' order by tran_no"
	
	
	rs.CursorLocation = adUseClient	
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	    Do while Not rs.EOF	
		vectHAWBs(SHIndex)=vHB
		vectShippers(SHIndex)=Shipper
		vectConsignees(SHIndex)=Consignee
		vectAgents(SHIndex)=Agent
		SHELTAcct(SHIndex)=account
		vectPiece(SHIndex)=0
		vectGrossWeight(SHIndex)=0
		vectDimension(SHIndex)=0
		vectAdjustedWeight(SHIndex)=0
		vectChargeableWeight(SHIndex)=0		 
		aSHAWB(SHIndex)=vHAWB&" - " &GET_SUB_HAWB_NO(vHB)     
		vectUnitQty(SHIndex)=rs("unit_qty")
		vectKgLb(SHIndex)=rs("kg_lb")
		vectTranNo(SHIndex)=rs("tran_no")
		vectColo(SHIndex)=colo
		vectPiece(SHIndex)=cInt(checkBlank(rs("no_pieces"),0))
		vectGrossWeight(SHIndex)=cDbl(checkBlank(rs("gross_weight"),0))
		vectDimension(SHIndex)=cDbl(checkBlank(rs("dimension"),0))
		vectAdjustedWeight(SHIndex)=cDbl(checkBlank(rs("adjusted_weight"),0))
		vectChargeableWeight(SHIndex)=cDbl(checkBlank(rs("chargeable_weight"),0))
		vectPieceTotal=vectPieceTotal+cInt(checkBlank(rs("no_pieces"),0))
		vectGrossWeightTotal=vectGrossWeightTotal+cDbl(checkBlank(rs("gross_weight"),0))
		vectDimensionTotal=vectDimensionTotal+cDbl(checkBlank(rs("dimension"),0))
		vectAdjustedWeightTotal=vectAdjustedWeightTotal+cDbl(checkBlank(rs("adjusted_weight"),0))
		vectChargeableWeightTotal=vectChargeableWeightTotal+cDbl(checkBlank(rs("chargeable_weight"),0))       
        SHIndex=SHIndex+1		
		if is_invoice_queued <> "Y" then			
			vectHAWBs2(SHIndex2)=vHB
			vectShippers2(SHIndex2)=Shipper
			vectConsignees2(SHIndex2)=Consignee
			vectAgents2(SHIndex2)=Agent
			vectUnitQty2(SHIndex2)=rs("unit_qty")
			vectKgLb2(SHIndex2)=rs("kg_lb")
			vectTranNo2(SHIndex2)=rs("tran_no")
			vectColo2(SHIndex2)=colo
			vectPiece2(SHIndex2)=cInt(checkBlank(rs("no_pieces"),0))
			vectGrossWeight2(SHIndex2)=cDbl(checkBlank(rs("gross_weight"),0))
			vectDimension2(SHIndex2)=cDbl(checkBlank(rs("dimension"),0))
			vectAdjustedWeight2(SHIndex2)=cDbl(checkBlank(rs("adjusted_weight"),0))
			vectChargeableWeight2(SHIndex2)=cDbl(checkBlank(rs("chargeable_weight"),0))			
			vectPieceTotal2=vectPieceTotal2+cInt(checkBlank(rs("no_pieces"),0))
			vectGrossWeightTotal2=vectGrossWeightTotal2+cDbl(checkBlank(rs("gross_weight"),0))
			vectDimensionTotal2=vectDimensionTotal2+cDbl(checkBlank(rs("dimension"),0))
			vectAdjustedWeightTotal2=vectAdjustedWeightTotal2+cDbl(checkBlank(rs("adjusted_weight"),0))
			vectChargeableWeightTotal2=vectChargeableWeightTotal2+cDbl(checkBlank(rs("chargeable_weight"),0))		 				
        	SHIndex2=SHIndex2+1
		end if 		
	    rs.MoveNext
    Loop
	vMaster_Gross_Weight=vectGrossWeightTotal2
	vMaster_Pieces=vectPieceTotal2
	vMaster_Chargeable_Weight=vectChargeableWeightTotal2			
	wIndex=1
    rs.Close
    set rs=Nothing    
End Sub


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_WEIGHT_CHARGES_FOR_A_HAWB_BEFORE_SAVE
'Purpose  of the procedure: The procedure is in charge of getting weight charges for a HAWB and put them 
' into the arrays that will be displayed in the selected sub houses before save action
'Tasks that are performed within:									    
'1.Get weight charges for a hawb before save 
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Sub GET_WEIGHT_CHARGES_FOR_A_HAWB_BEFORE_SAVE(vHB,account,Shipper,Consignee,Agent,colo,is_invoice_queued)
    DIM rs
    DIM WC_COLLECT, WC_PREPAID
    WC_COLLECT=0
    WC_PREPAID=0	
    set rs=Server.CreateObject("ADODB.Recordset")   
	SQL= "select unit_qty,kg_lb,tran_no,no_pieces,gross_weight,dimension,adjusted_weight,chargeable_weight," _
	    & "no_pieces,gross_weight from hawb_weight_charge where elt_account_number = " & account _
	    & " and hawb_num=N'" & vHB & "' order by tran_no"
	
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing   
    Do while Not rs.EOF		 
		SHELTAcct(SHIndex)=account
		vectHAWBs(SHIndex)=vHB
		vectShippers(SHIndex)=Shipper
		vectConsignees(SHIndex)=Consignee
		vectAgents(SHIndex)=Agent
		vectPiece(SHIndex)=0
		vectGrossWeight(SHIndex)=0
		vectDimension(SHIndex)=0
		vectAdjustedWeight(SHIndex)=0
		vectChargeableWeight(SHIndex)=0
		aSHAWB(SHIndex)=vHAWB&" - " &GET_SUB_HAWB_NO(vHB)
		vectUnitQty(SHIndex)=rs("unit_qty")
		vectKgLb(SHIndex)=rs("kg_lb")
		vectTranNo(SHIndex)=rs("tran_no")
		vectColo(SHIndex)=colo
		vectPiece(SHIndex)=cInt(checkBlank(rs("no_pieces"),0))
		vectGrossWeight(SHIndex)=cDbl(checkBlank(rs("gross_weight"),0))
		vectDimension(SHIndex)=cDbl(checkBlank(rs("dimension"),0))
		vectAdjustedWeight(SHIndex)=cDbl(checkBlank(rs("adjusted_weight"),0))
		vectChargeableWeight(SHIndex)=cDbl(checkBlank(rs("chargeable_weight"),0))
		vectPieceTotal=vectPieceTotal+cInt(checkBlank(rs("no_pieces"),0))
		vectGrossWeightTotal=vectGrossWeightTotal+cDbl(checkBlank(rs("gross_weight"),0))
		vectDimensionTotal=vectDimensionTotal+cDbl(checkBlank(rs("dimension"),0))
		vectAdjustedWeightTotal=vectAdjustedWeightTotal+cDbl(checkBlank(rs("adjusted_weight"),0))
		vectChargeableWeightTotal=vectChargeableWeightTotal+cDbl(checkBlank(rs("chargeable_weight"),0))       
        SHIndex=SHIndex+1
        rs.MoveNext
    Loop
	wIndex=1
	NoItemWC=1
    rs.Close
    set rs=Nothing
    
End Sub


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_SUB_HAWB_NO
'Purpose  of the procedure: The procedure is in charge of 
'Tasks that are performed within:									    
'1.
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Function GET_SUB_HAWB_NO(H)
	dim rs1
	set rs1= Server.CreateObject("ADODB.Recordset")
	dim SQL
	SQL="select sub_no from hawb_master where is_sub ='Y' and elt_account_number=" _
	    & elt_account_number & " and is_dome='N' and hawb_num=N'" & H & "'"
	
	
	rs1.CursorLocation = adUseClient
	rs1.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs1.activeConnection = Nothing
	if not rs1.eof then 
		GET_SUB_HAWB_NO = rs1("sub_no").Value
	end if 
	rs1.close
	set rs1=Nothing
END Function 


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_SHIPPER_ELT_ACCT
'Purpose  of the procedure: The procedure is in charge of getting ELT account number for the shipper 
'specified in the HAWB 
'Tasks that are performed within:									    
'1.Get the ELT account number for the shipper 
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
FUNCTION GET_SHIPPER_ELT_ACCT(ShipperAcct)
	dim rs1
	set rs1= Server.CreateObject("ADODB.Recordset")
	dim SQL

	SQL="select dba_name, agent_elt_acct from organization where org_account_number=" _
	    & checkBlank(ShipperAcct,0) & " and elt_account_number=" & elt_account_number
	
	
	rs1.CursorLocation = adUseClient
	rs1.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs1.activeConnection = Nothing
	if not rs1.eof then 
		GET_SHIPPER_ELT_ACCT = checkBlank(rs1("agent_elt_acct").Value,"-1")
	end if 	
	rs1.close
	set rs1=Nothing	
END FUNCTION 

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_OTHER_CHARGES_FOR_A_HAWB
'Purpose  of the procedure: The procedure is in charge of acquiring other charges for a given HAWB.
'Tasks that are performed within:									    
'1.Get other charge information for a give HAWB 
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''	
Sub GET_OTHER_CHARGES_FOR_A_HAWB(vHAWB,elt_account_number)
    DIM rs
    DIM WC_COLLECT, WC_PREPAID
    OC_COLLECT=0
    OC_PREPAID=0    
    set rs=Server.CreateObject("ADODB.Recordset")
    SQL= "select a.coll_prepaid, a.carrier_agent, a.charge_code, a.charge_desc, a.amt_hawb " _
        & "from hawb_other_charge a left outer join item_charge b " _
        & "on (a.elt_account_number=b.elt_account_number and a.charge_code=b.item_no) " _
        & "where isnull(b.item_def,'Custom')='Custom' and elt_account_number = " _
        & elt_account_number & " and hawb_num=N'" & vHAWB & "' order by tran_no"
    
    
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
    oIndex=0    
    Do while Not rs.EOF
        aCollectPrepaid(oIndex)=rs("coll_prepaid")
        aCarrierAgent(oIndex)=rs("carrier_agent")
        aChargeCode(oIndex)=rs("charge_code")
        aDesc(oIndex)=rs("charge_desc")
        aChargeAmt(oIndex)=rs("amt_hawb")
        rs.MoveNext
        oIndex=oIndex+1
    Loop
    rs.Close
    set rs=Nothing    
    NoItemOC = oIndex
	if NoItemOC>5 then
		for i=0 to NoItemOC-1 Step 2
			aOtherCharge(Fix(i/2))=aDesc(i) & " " & FormatNumberPlus(aChargeAmt(i),2) & "  " & aDesc(i+1) & " " & FormatNumberPlus(aChargeAmt(i+1),2)
		next
	else
		for i=0 to NoItemOC-1
			aOtherCharge(i)=aDesc(i) & " " & FormatNumberPlus(aChargeAmt(i),2)
		next
	end if	
	
End Sub 

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:CHECK_IF_COLOADED
'Purpose  of the procedure: The procedure is in charge of checking out where the HAWB is to be coloaded 
'in oder to decide wheter MAWB is editable or not
'Tasks that are performed within:									    
'1.Check if the HAWB is set to be coloaded
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB CHECK_IF_COLOADED
	DIM rs
	set rs=Server.CreateObject("ADODB.Recordset")
	SQL= "select mawb_num from hawb_master where elt_account_number = " _
	    & elt_account_number & " and colo='Y' and is_dome='N' and hawb_num=N'" & vHAWB & "'"
    
    
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	
	if not rs.eof  then
	  IsColoaded=true
	end if 
	rs.close
	set rs=Nothing 	
END SUB 

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:EXECUTION_STRING_CHANGE
'Purpose  of the procedure: The procedure is in charge of 
'Tasks that are performed within:									    
'1.
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Sub EXECUTION_STRING_CHANGE
    Dim txtPos
    txtPos = InStr(UCase(vExecute),"AS AGENT OF")
    If txtPos>0 Then
		If InStr(vExecute,"CARRIER") = 0 Then
			vExecute = Left(vExecute, txtPos) & Replace(vExecute, chr(13), ", CARRIER" & chr(13), txtPos + 1, 1)
		End If
    End If
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GETVEXECUTE
'Purpose  of the procedure: The procedure is in charge of 
'Tasks that are performed within:									    
'1.
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB GETVEXECUTE(vMAWB)
	Dim mInfo,pos
	Dim mDepartureAirportCode,mDepartureAirport, mTo, mBy, mTo1, mBy1, mTo2, mBy2,mDestAirport
	Dim mFlightDate1,mFlightDate2,IssuedBy,mServiceLevel
	if trim(vMAWB) = "" then
		vExecute=vExecutionDatePlace
		exit sub
	end if
	
	mInfo = GET_ONE_MAWB_INFO(vMAWB)
	// Modified by Joon 6/20/2007 service level
    pos=InStr(mInfo,chr(10))
    mServiceLevel=Left(mInfo,pos-1)
    mInfo=Mid(mInfo,pos+1,1000)
    //////////////////////////////////////////////
	pos=InStr(mInfo,chr(10))
	mAirOrgNum=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mDepartureAirportCode=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mDepartureAirport=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mTo=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mBy=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mTo1=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mBy1=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mTo2=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mBy2=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mDestAirport=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mFlightDate1=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mFlightDate2=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mCarrierDesc=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mExportDate=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mDestCountry=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mDepartureState=Left(mInfo,pos-1)
	IssuedBy=vIssuedBy
	pos=Instr(IssuedBy,chr(10))
	If pos>0 Then
		IssuedBy=Left(IssuedBy,pos-1)
	End If
	if Mid(IssuedBy,1,11) = "AS AGENT OF" then
		IssuedBy="AS AGENT OF " & mCarrierDesc & ", Carrier"
	else
		IssuedBy=IssuedBy & chr(10) & "AS AGENT OF " & mCarrierDesc & ", Carrier"
	end if
	vExecute=vExecutionDatePlace
	vExecute=IssuedBy & " " & vExecute

END SUB


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:FINAL_SCREEN_PREPARE
'Purpose  of the procedure: The procedure is in charge of 
'Tasks that are performed within:									    
'1.
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB FINAL_SCREEN_PREPARE
	if  vNotifyAcct="" or isnull(vNotifyAcct) then 
		vNotifyAcct="0"
	end if
		
	if pIndex=0 then 
		pIndex=1 
	end if

	IF NOT vHAWB = "" AND NOT vHAWB = "0" THEN
		CALL CHECK_INVOICE_STATUS_HAWB(	vHAWB, elt_account_number )	
	END IF	
	Set rs=Nothing
	Set rs3=Nothing
	if Not rURL="" then
		rURL=rURL & "&Copy=SHIPPER&COLO=Y"
		Response.Redirect("http://" & myServer & rURL)
	end if

	if trim(vExecute) = "" And vMAWB<> "" then
		CALL GETVEXECUTE(vMAWB)
	end if
END SUB

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:ADD_OR_UPDATE_HAWB_TABLE
'Purpose  of the procedure: The procedure is in charge of createing/updaing a HAWB in to the DB
'Tasks that are performed within:									    
'1.Save/update general HAWB 
'2.Calls routines for saving/udating charge items info.
'3.Decide wheter to create entry for invoice or not and process it when HAWB is a master hosue
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB ADD_OR_UPDATE_HAWB_TABLE( vHAWB )'////////////////////////////////////////////////updating hawb_master		
	dim rs

	Set rs = Server.CreateObject("ADODB.Recordset")
	If vHAWB = "" Then
	    Response.Write("<script>alert('HAWB number error.'); history.go(-1); </script>")
	    Response.End()
	end if
        

	If NewHAWB = "yes" then

		SQL= "select * from hawb_master where elt_account_number = " & elt_account_number _
		    & " and is_dome='N' and HAWB_NUM=N'" & vHAWB & "'"

		
		rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText

		If rs.EOF Then		
			rs.close
			Response.Write("<script>alert('HAWB number error.'); history.go(-1); </script>")
	        Response.End()			
		end if
		NewForm="Y"
	       
	Else	
		SQL= "select * from hawb_master where elt_account_number = " & elt_account_number _
		    & " and is_dome='N' and HAWB_NUM=N'" & vHAWB & "'"
		
		rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
		
		If rs.EOF=true Then
			rs.AddNew  
			rs("elt_account_number")=elt_account_number
			rs("HAWB_NUM")=vHAWB
			rs("date_executed")=Now
			rs("prepaid_invoiced")="N"
			rs("collect_invoiced")="N"		
			rs("is_master_closed")="N"		
			rs("is_invoice_queued")="N"
			rs("CreatedBy")=session_user_lname	
			rs("CreatedDate")=Now
			rs("SalesPerson")=vSalesPerson		
			rs("is_dome")="N"				
		end if
	end if
    
	rs("Shipper_Account_Number") = vShipperAcct
	 
	if  vCheckSH="Y" then
		rs("is_invoice_queued")=is_invoice_queued
	end if	
	rs("MAWB_NUM")=vMAWB
     
	rs("agent_name")=vFFAgentName
	rs("agent_no")=vFFAgentAcct
   
	rs("agent_info")=vFFAgentInfo
	rs("DEP_AIRPORT_CODE") = vOriginPortID
    
	rs("airline_vendor_num")=vAirOrgNum
	rs("Shipper_Name") = vShipperName
	
	if vCheckMH="Y"  then
		IF GET_SHIPPER_ELT_ACCT(checkBlank(vShipperAcct,0)) = elt_account_number THEN 
			rs("is_invoice_queued")="N"			
			CALL UPDATE_ALL_SUB_HOUSE_INFO("Y")			
		ELSE 
			rs("is_invoice_queued")="Y"			
			CALL UPDATE_ALL_SUB_HOUSE_INFO("N")
		END IF 
	end if 
    
	rs("Shipper_Info") = vShipperInfo
	rs("ff_shipper_acct") = vFFShipperAcct
	rs("Consignee_Name") = vConsigneeName
	rs("Consignee_Info") = vConsigneeInfo
	rs("Consignee_acct_num") = vConsigneeAcct
	rs("ff_consignee_acct") = vFFConsigneeAcct
	rs("Issue_Carrier_Agent") = vAgentInfo
	rs("Agent_IATA_Code") = vAgentIATACode
	rs("Account_No") = vAgentAcct
	rs("Departure_Airport") = vDepartureAirport
	rs("departure_state")=vDepartureState

	rs("To_1") = vTo
	rs("By_1") = vBy
	rs("To_2") = vTo1
	rs("By_2") = vBy1
	rs("To_3") = vTo2
	rs("By_3") = vBy2

    
	rs("Dest_Airport") = vDestAirport
	rs("Flight_Date_1") = vFlightDate1

	rs("Flight_Date_2") = vFlightDate2

    'response.Write Replace(vExportDate,"T"," ") 
  
            
	rs("export_date")=Replace(vExportDate,"T"," ") 
     
	rs("IssuedBy")=vIssuedBy
    
	rs("Account_Info") = vAccountInfo
	rs("Notify_No") = vNotifyAcct
	rs("Currency") = vCurrency
	rs("Charge_Code") = vChargeCode

	rs("PPO_1") = vPPO_1
	rs("COLL_1") = vCOLL_1
	rs("PPO_2") = vPPO_2
	rs("COLL_2") = vCOLL_2

  

	rs("Declared_Value_Carriage") = vDeclaredValueCarriage
	rs("Declared_Value_Customs")= vDeclaredValueCustoms

	rs("Insurance_AMT")=vInsuranceAMT
	rs("Handling_Info")=vHandlingInfo
	rs("dest_country")=vDestCountry
	rs("SCI")=vSCI
	rs("dimtext")=vDimText
	rs("total_pieces")=vTotalPieces
	rs("total_gross_weight")=vTotalGrossWeight
	rs("total_chargeable_weight")=FormatNumberPlus(vTotalChargeableWeight,0)
	rs("total_weight_charge_hawb")=FormatNumberPlus(vTotalWeightCharge,2)
	rs("af_cost")=FormatNumberPlus(vAFCost,2)
	rs("agent_profit")=FormatNumberPlus(vAgentProfit,2)
	rs("agent_profit_share")=TempShare
	rs("adjusted_weight")=FormatNumberPlus(vTotalAdjustedWeight,0)
	rs("desc1")=vDesc1
	rs("desc2")=vDesc2
	rs("manifest_desc")=vManifestDesc
	rs("lc")=vLC
	rs("ci")=vCI
	rs("other_ref")=vOtherRef
	rs("aes_xtn")=vAES
	rs("weight_scale")=vWeightScale
	rs("Prepaid_Weight_Charge") = FormatNumberPlus(vPrepaidWeightCharge,2)
	rs("Collect_Weight_Charge") = FormatNumberPlus(vCollectWeightCharge,2)
	rs("Prepaid_Due_Agent") = FormatNumberPlus(vPrepaidOtherChargeAgent,2)
	rs("Collect_Due_Agent") = FormatNumberPlus(vCollectOtherChargeAgent,2)
	rs("Prepaid_Due_Carrier") = FormatNumberPlus(vPrepaidOtherChargeCarrier,2)
	rs("Collect_Due_Carrier") = FormatNumberPlus(vCollectOtherChargeCarrier,2)
	rs("total_other_charges")=FormatNumberPlus(vTotalOtherCharge,2)
	rs("Prepaid_Total")=FormatNumberPlus(vPrepaidTotal,2)
	rs("Collect_Total")=FormatNumberPlus(vCollectTotal,2)
	rs("Prepaid_Valuation_Charge")=FormatNumberPlus(vPrepaidValuationCharge,2)
	rs("Collect_Valuation_Charge")=FormatNumberPlus(vCollectValuationCharge,2)
	rs("Prepaid_Tax")=FormatNumberPlus(vPrepaidTax,2)
	rs("Collect_Tax")=FormatNumberPlus(vCollectTax,2)
	rs("Currency_Conv_Rate")=vConversionRate
	rs("CC_Charge_Dest_Rate")=vCCCharge
	rs("Charge_at_Dest")=FormatNumberPlus(vChargeDestination,2)
	rs("Total_Collect_Charge")=FormatNumberPlus(vFinalCollect,2)
	rs("show_weight_charge_shipper")=vShowWeightChargeShipper
	rs("show_weight_charge_consignee")=vShowWeightChargeConsignee
	rs("show_prepaid_other_charge_shipper")=vShowPrepaidOtherChargeShipper
	rs("show_collect_other_charge_shipper")=vShowCollectOtherChargeShipper
	rs("show_prepaid_other_charge_consignee")=vShowPrepaidOtherChargeconsignee
	rs("show_collect_other_charge_consignee")=vShowCollectOtherChargeconsignee
	rs("Signature")=vSignature
	rs("Date_Last_Modified")=Now
	rs("Execution")=vExecute	
	rs("colo")=vCOLO
	rs("colo_pay")=vCOLOPay
	rs("coloder_elt_acct")=vColoderAcct	
	rs("SalesPerson")=	vSalesPerson	
	rs("ModifiedBy")= session_user_lname
	rs("ModifiedDate")=Now		
	rs("is_sub")=vCheckSH
	rs("sed_stmt")=vSEDStmt


	if vCheckSH="Y" then
		'rs("sub_no")=vSubNo
		rs("sub_to_no")=vM_HAWB
		rs("is_master")="N"
		rs("sub_count")=0
		vCanbeMaster = false 
	else 
		rs("sub_no")=null
		rs("sub_to_no")=null
		vM_HAWB=""
	end if 
	rs("is_master")=vCheckMH
	If vCheckMH ="Y" then
	 	rs("sub_count")=vSubCount
		call SUMUP_WEIGHT_CHARGES_BELONG_TO_MASTER_HOUSE_BEFORE_SAVE(vM_HAWB)	
		rs("sub_no")=null
		rs("sub_to_no")=null	
	end if 
	
	If vCheckMH ="N" and vDiscardMH="Y" then
		rs("is_master")="N"
		rs("sub_count")=0
	end if 
	rs("reference_number") = vReferenceNumber

	rs.Update
	rs.Close

	If vCheckMH ="N" and vDiscardMH="Y" then
	 	CALL FREE_ALL_SUB_HOUSE
	end if 

	if NewForm="Y" then
		CALL UPDATE_NEXT_HAWB_NUMBER_IN_USER_TABLE
		NewHAWB = ""
	end if
	
	set rs=Nothing 
END SUB

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_AGENT_PROFIT_INFO
'Purpose  of the procedure: The procedure is in charge of calcuating agent 
'profit according to the agent's rate
'Tasks that are performed within:									    
'1.
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB GET_AGENT_PROFIT_INFO
    
	'// rate_type
	'// 1 is agent buying rate
	'// 4 is customer selling rate

	Set rs1 = Server.CreateObject("ADODB.Recordset")
	DIM vUnit, vWeight
	Dim tmpWT

	tmpWT=-1
	vWeight = vTotalAdjustedWeight
	vUnit = vWeightScale
	origUnit = vUnit
	Airline = Mid(vMAWB,1,3)
	
	'// fregith cost rate from agent buying rate
	Set rs1 = Server.CreateObject("ADODB.Recordset")

	SQL="select weight_break,rate,share from all_rate_table"
	SQL=SQL & " where elt_account_number=" & elt_account_number
	SQL=SQL & " and rate_type=1"
	SQL=SQL & " and agent_no=" & vFFAgentAcct
	if( Airline <> "" ) then
		SQL=SQL & " and (airline=" & Airline & " or airline=-1)"
	else 
		SQL=SQL & " and airline=-1"
	end if	
	SQL=SQL & " and origin_port=N'" & vOriginPortID & "'"
	SQL=SQL & " and dest_port=N'" & checkBlank(vTo2, checkBlank(vTo1, vTo)) & "'"
	SQL=SQL & " and kg_lb=N'" & vUnit & "'"
	SQL=SQL & " order by airline desc,weight_break desc"
	
	rs1.CursorLocation = adUseClient
	rs1.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs1.activeConnection = Nothing

	'// Response.Write(SQL)

	TempRate=0
	TempShare=0
	rate=0
	share=0
	vAgentProfit=0
	vAFCost=0
	MinCharge=0
	MinShare=0
	Dim minApplied 
	minApplied=false
	dim rFLAG
	rFLAG=true
	
	do while not rs1.EOF
		wb=cdbl(rs1("weight_break"))
		TempRate=cdbl(rs1("rate"))
		
		if wb=0 then 
			MinCharge=TempRate
		end if 		
		if vWeight >= wb then
			if rFLAG = true then 
				If wb=0 then 
					minApplied=true
				end if 
				rate=TempRate
				rFLAG=false
			end if 		
		end if
		rs1.MoveNext
	Loop
	
	rs1.Close
	Set rs1=Nothing
	
	if rate=0 then
		rate=TempRate
	end If

	if origUnit ="K" and vUnit="L" then 
		rate = rate * 2.20462262
	else 
		if origUnit ="L" and vUnit="K" then 
			rate1 = rate /2.20462262  
		end if
	end if 

	'// Response.Write("test: " & rate)

	'// Profit share percentage from customer selling rate talbe
	Set rs1 = Server.CreateObject("ADODB.Recordset")

	SQL="select TOP 1 share from all_rate_table"
	SQL=SQL & " where elt_account_number=" & elt_account_number
	SQL=SQL & " and rate_type=4"

	If vPPO_1 = "Y" Then
		SQL=SQL & " and customer_no=" & vShipperAcct
	Else
		SQL=SQL & " and customer_no=" & vConsigneeAcct
	End If

	If( Airline <> "" ) Then
		SQL=SQL & " and (airline=" & Airline & " or airline=-1)"
	Else 
		SQL=SQL & " and airline=-1"
	End If

	SQL=SQL & " and origin_port=N'" & vOriginPortID & "'"
	SQL=SQL & " and dest_port=N'" & checkBlank(vTo2, checkBlank(vTo1, vTo)) & "'"
	SQL=SQL & " and kg_lb=N'" & vUnit & "'"
	SQL=SQL & " group by share,airline"
	SQL=SQL & " order by airline desc"
	
	rs1.CursorLocation = adUseClient
	rs1.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs1.activeConnection = Nothing

	If Not rs1.EOF And Not rs1.BOF Then
		share = cdbl(rs1("share")) * 0.01
	End If	
	
	rs1.Close
	Set rs1=Nothing

	'// Response.Write(SQL)
	'// Response.Write("share: " & share)

	'// If searching unit is differnt from the unit in db both rate and wight is converted already		
	vAFCost = rate * vWeight

	If minApplied=True Or cDbl(vAFCost) < cDbl(MinCharge) Then
		vAFCost = MinCharge
	end if 

	vAgentProfit = (vTotalWeightCharge-vAFCost) * share
	vAgentProfitPercent = share * 100
	TempShare = share

End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:UPDATE_NEXT_HAWB_NUMBER_IN_USER_TABLE
'Purpose  of the procedure: The procedure is in charge of getting the  HAWB number for a given prefix 
'Tasks that are performed within:									    
'1.GET the next number for the next HAWB
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB UPDATE_NEXT_HAWB_NUMBER_IN_USER_TABLE
	DIM tHAWB_Number
	pos=0
	pos=instr(vHAWB,"-")
	if pos>0 then
		tPrefix=Mid(vHAWB,1,pos-1)
		tHAWB_Number=Mid(vHAWB,pos+1,32)
	else
		tPrefix="NONE"
		tHAWB_Number=vHAWB
	end if
	SQL= "select * from user_prefix where elt_account_number=" & elt_account_number _
	    & " and type='HAWB' and prefix=N'" & tPrefix & "'"
	
	rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	If Not rs.EOF Then
		if cLng(tHAWB_Number)>=cLng(rs("next_no")) then
			rs("next_no")=cLng(tHAWB_Number)+1
			rs.Update
		end if
		for i=0 to pIndex
			if tPrefix=aHAWBPrefix(i) then
				aNextHAWB(i)=cLng(tHAWB_Number)+1
			end if
		next
	end if
	rs.Close			
END SUB

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:UPDATE_WEIGHT_CHARGE_TABLE
'Purpose  of the procedure: The procedure is in charge of updating all the weight charge for the HAWB
'Tasks that are performed within:									    
'1.update all the weight charge information to the DB
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB UPDATE_WEIGHT_CHARGE_TABLE ( NoItemWC )       
	dim SQL
	SQL= "select * from hawb_weight_charge where elt_account_number = " & elt_account_number _
	    & " and hawb_num=N'" & vHAWB & "'"
	
	dim rs
	Set rs = Server.CreateObject("ADODB.Recordset")
	rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	Do while Not rs.EOF
		rs.Delete
		rs.MoveNext
	Loop
	rs.Close
	for i=0 to NoItemWC-1
		SQL= "select * from hawb_weight_charge where elt_account_number = " & elt_account_number _
		    & " and hawb_num=N'" & vHAWB & "' and tran_no=" & i+1
		
		
		rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
		rs.AddNew
		if vCheckMH="Y" then
			rs("is_master")="Y"
		else 
			rs("is_master")="N"
		end if 
		rs("elt_account_number")=elt_account_number
		rs("hawb_num")=vHAWB
		rs("tran_no")=i+1
		rs("no_pieces")=aPiece(i)
		
		rs("unit_qty")=aUnitQty(i)
		rs("gross_weight")=Round(aGrossWeight(i),2)
		rs("kg_lb")=aKgLb(i)
		rs("rate_class")=aRateClass(i)
		rs("commodity_item_no")=aItemNo(i)
		rs("dimension")=Round(aDimension(i),2)
		rs("dem_detail")=aDimDetail(i)
		rs("chargeable_weight")=Round(aChargeableWeight(i),0)
		rs("adjusted_weight")=Round(aAdjustedWeight(i),2)
		
		if not aRateCharge(i)="" then
			if UCase(aRateCharge(i))="MIN" then aRateCharge(i)=-1
			if aRateCharge(i)="N/A" then
			aRateCharge(i)=0
			end if 
			rs("rate_charge")=aRateCharge(i)
		end if
		if aRateCharge(i)="-1" then aRateCharge(i)="MIN"
		if not aTotal(i)="" then
			rs("total_charge")=Round(aTotal(i),2)
		end if
		rs.Update
		rs.Close
	next
 	set rs=Nothing
END SUB

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:UPDATE_OTHER_CHARGE_TABLE
'Purpose  of the procedure: The procedure is in charge of updting other charges belong to the HAWB 
'Tasks that are performed within:									    
'1.upadate other charges for the HAWB into DB
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB UPDATE_OTHER_CHARGE_TABLE ( NoItemOC )
	SQL= "delete from hawb_other_charge where elt_account_number = " & elt_account_number _
	    & " and hawb_num=N'" & vHAWB & "'"
	
	
	eltConn.Execute SQL
	ii=1
	for i=0 to NoItemOC-1
		if Not aDesc(i)="" Or not aChargeAmt(i)=0 Or not aCost(i)=0 then
			SQL= "select * from hawb_other_charge where elt_account_number = " & elt_account_number _
			& " and hawb_num=N'" & vHAWB & "' and tran_no=" & ii
			
			
			rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
			rs.AddNew
			rs("elt_account_number")=elt_account_number
			rs("hawb_num")=vHAWB
			rs("tran_no")=ii
			rs("coll_prepaid")=aCollectPrepaid(i)
			rs("carrier_agent")=aCarrierAgent(i)
			rs("charge_code")=aChargeCode(i)
			rs("charge_desc")=aDesc(i)
			rs("amt_hawb")=aChargeAmt(i)
			'rs("vendor_num")=aVendor(i)
			'rs("cost_amt")=aCost(i)
			rs.Update
			rs.Close
			ii=ii+1
		end if
	next
END SUB

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_HAWB_HEADER_INFO_ETC
'Purpose  of the procedure: The procedure is in charge of getting HAWB formation not inclduing charges 
'from screen 
'Tasks that are performed within:									    
'1.Get general HAWB infromation from the reqeust(screen)
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB GET_HAWB_HEADER_INFO_ETC(  NoItemWC , NoItemOC )
	wIndex=NoItemWC
	oIndex=NoItemOC	
	vTotalPieces=0
	vTotalGrossWeight=0
	vTotalWeightCharge=0
	vTotalChargeableWeight=0
	vTotalAdjustedWeight=0	
	for i=0 to NoItemWC-1
		vTotalPieces=vTotalPieces+aPiece(i)
		vTotalGrossWeight=vTotalGrossWeight+aGrossWeight(i)
		vTotalChargeableWeight=vTotalChargeableWeight+aChargeableWeight(i)
		if not aTotal(i)="" then
			vTotalWeightCharge=vTotalWeightCharge+aTotal(i)
		end if
		vTotalAdjustedWeight=vTotalAdjustedWeight+aAdjustedWeight(i)
	next	
	vDesc1=Request("txtDesc1")
	vDesc2=Request("txtDesc2")
	vManifestDesc=Request("txtManifestDesc")	
	vLC=Request("txtLC")
	vCI=Request("txtCI")
	vAES = checkBlank(Request.Form.Item("txtAES"),"")
	
    If vAES = "" Then
	    vSEDStmt = Request.Form.Item("txtSEDStatement")
	End If
	
	vOtherRef=Request("txtOtherRef")
	vPrepaidOtherChargeAgent=0
	vCollectOtherChargeAgent=0
	vPrepaidOtherChargeCarrier=0
	vCollectOtherChargeCarrier=0
	'vPPO_2=""
	'vCOLL_2=""	
	For i=0 To NoItemOC-1
		if aCarrierAgent(i)="A" and aCollectPrepaid(i)="P" then
			vPrepaidOtherChargeAgent=vPrepaidOtherChargeAgent+aChargeAmt(i)
		elseif aCarrierAgent(i)="A" and aCollectPrepaid(i)="C" then
			vCollectOtherChargeAgent=vCollectOtherChargeAgent+aChargeAmt(i)
		elseif aCarrierAgent(i)="C" and aCollectPrepaid(i)="P" then
			vPrepaidOtherChargeCarrier=vPrepaidOtherChargeCarrier+aChargeAmt(i)
		elseif aCarrierAgent(i)="C" and aCollectPrepaid(i)="C" then
			vCollectOtherChargeCarrier=vCollectOtherChargeCarrier+aChargeAmt(i)
		end if
		if aCollectPrepaid(i)="P" and aChargeAmt(i)>0 then
			vPPO_2="Y"
		end if
		if aCollectPrepaid(i)="C" and aChargeAmt(i)>0 then
			vCOLL_2="Y"
		end if
	Next	
	vTotalOtherCharge=vPrepaidOtherChargeAgent+vCollectOtherChargeAgent+vPrepaidOtherChargeCarrier+vCollectOtherChargeCarrier	
	
	if NoItemOC>5 then
		for i=0 to NoItemOC-1 Step 2
			aOtherCharge(Fix(i/2))=aDesc(i) & " " & FormatNumberPlus(aChargeAmt(i),2) & "  " & aDesc(i+1) & " " & FormatNumberPlus(aChargeAmt(i+1),2)
		next
	else
		for i=0 to NoItemOC-1
			aOtherCharge(i)=aDesc(i) & " " & FormatNumberPlus(aChargeAmt(i),2)
		next
	end if
	vShowWeightChargeShipper=Request("cShowWeightChargeShipper")
	vShowWeightChargeConsignee=Request("cShowWeightChargeConsignee")
	vShowPrepaidOtherChargeShipper=Request("cShowPrepaidOtherChargeShipper")
	vShowCollectOtherChargeShipper=Request("cShowCollectOtherChargeShipper")
	vShowPrepaidOtherChargeConsignee=Request("cShowPrepaidOtherChargeConsignee")
	vShowCollectOtherChargeConsignee=Request("cShowCollectOtherChargeConsignee")
	If vPPO_1="Y" Then
		vPrepaidWeightCharge=vTotalWeightCharge
		vCollectWeightCharge=0
	Else
		vCollectWeightCharge=vTotalWeightCharge
		vPrepaidWeightCharge=0
	End If
	vPrepaidValuationCharge=Request("txtPrepaidValuationCharge")
	if vPrepaidValuationCharge="" then vPrepaidValuationCharge=0
	vCollectValuationCharge=Request("txtCollectValuationCharge")
	if vCollectValuationCharge="" then vCollectValuationCharge=0
	vPrepaidTax=Request("txtPrepaidTax")
	if vPrepaidTax="" then vPrepaidTax=0
	vCollectTax=Request("txtCollectTax")
	if vCollectTax="" then vCollectTax=0
	vConversionRate=Request("txtConversionRate")
	if vConversionRate="" then vConversionRate=0
	vCCCharge=Request("txtCCCharge")
	if vCCCharge="" then vCCCharge=0
	vChargeDestination=Request("txtChargeDestination")
	if vChargeDestination="" then vChargeDestination=0
	vPrepaidTotal=vPrepaidWeightCharge+vPrepaidValuationCharge+vPrepaidTax+vPrepaidOtherChargeAgent+vPrepaidOtherChargeCarrier
	vCollectTotal=vCollectWeightCharge+vCollectValuationCharge+vCollectTax+vCollectOtherChargeAgent+vCollectOtherChargeCarrier
	vFinalCollect=vCollectTotal+vChargeDestination
END SUB

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:DELETE_WEGHT_CHARGE_ITEM
'Purpose  of the procedure: The procedure is in charge of deleting one weight charge item from screen
'Tasks that are performed within:									    
'1.Delete one weight charge item from weight charge  item array
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB DELETE_WEGHT_CHARGE_ITEM( dItemNo , NoItemWC )

	for i=dItemNo to NoItemWC-1
		aPiece(i)=aPiece(i+1)
		aUnitQty(i)=aUnitQty(i+1)
		aGrossWeight(i)=aGrossWeight(i+1)
		aAdjustedWeight(i)=aAdjustedWeight(i+1)
		aDimension(i)=aDimension(i+1)
		aDimDetail(i)=aDimDetail(i+1)
		aKgLb(i)=aKgLb(i+1)
		aRateClass(i)=aRateClass(i+1)
		aItemNo(i)=aItemNo(i+1)
		aChargeableWeight(i)=aChargeableWeight(i+1)
		aRateCharge(i)=aRateCharge(i+1)
		aTotal(i)=aTotal(i+1)
	next
END SUB

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:DELETE_OTHER_CHARGE_ITEM
'Purpose  of the procedure: The procedure is in charge of deleting one other charge item from screen
'Tasks that are performed within:									    
'1.Delte one other charge item from the other charge item array
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB DELETE_OTHER_CHARGE_ITEM( dItemNo , NoItemOC )

	for i=dItemNo to NoItemOC-1
		aCarrierAgent(i)=aCarrierAgent(i+1)
		aCollectPrepaid(i)=aCollectPrepaid(i+1)
		aChargeCode(i)=aChargeCode(i+1)
		aDesc(i)=aDesc(i+1)
		aChargeAmt(i)=aChargeAmt(i+1)
		'// aVendor(i)=aVendor(i+1)
		'// aCost(i)=aCost(i+1)
	next

END SUB

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_HAWB_ITEM_OTHER_CHARGE_INFO
'Purpose  of the procedure: The procedure is in charge of getting other charge items from screen 
'Tasks that are performed within:									    
'1.Get all the other charge itmes from the scree and store them in to variables inorder to calculate/save/edit
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB GET_HAWB_ITEM_OTHER_CHARGE_INFO( NoItemOC )
	for i=0 to NoItemOC-1
		aCarrierAgent(i)=Request("lstCarrierAgent" & i)
		aCollectPrepaid(i)=Request("lstCollectPrepaid" & i)
		ChargeItemInfo=Request("lstChargeCode" & i)
		pos=0
		pos=Instr(ChargeItemInfo,"-")
		if pos>0 then
			aChargeCode(i)=cInt(left(ChargeItemInfo,pos-1))
			aDesc(i)=Mid(ChargeItemInfo,pos+1,2000)
	        pos=0
			pos=Instr(aDesc(i),"-")
			if (pos > 0) then
				aDesc(i)=LTRIM(Mid(aDesc(i),1,pos-1))
			end if
		end if
		if aDesc(i)="Select One" then aDesc(i)=""
		aChargeAmt(i)=Request("txtChargeAmt" & i)
		if aChargeAmt(i)="" then aChargeAmt(i)=0		
	next
END SUB

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_HAWB_ITEM_WEIGHT_CHARGE_INFO
'Purpose  of the procedure: The procedure is in charge of getting weight charge items from screen
'Tasks that are performed within:									    
'1.Get all the weight charge itmes from the scree and store them in to variables inorder to calculate/save/edit
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB GET_HAWB_ITEM_WEIGHT_CHARGE_INFO( NoItemWC )
	for i=0 to NoItemWC-1
		aPiece(i)=Request("txtPiece" & i)
		if aPiece(i)="" then aPiece(i)=0
		aUnitQty(i)=Request("lstUnitQty" & i)
		aGrossWeight(i)=Request("txtGrossWeight" & i)
		if aGrossWeight(i)="" then aGrossWeight(i)=0
		aAdjustedWeight(i)=Request("txtAdjustedWeight" & i)
		if aAdjustedWeight(i)="" then aAdjustedWeight(i)=0
		aKgLb(i)=Request("lstKgLb" & i)
		aRateClass(i)=Request("txtRateClass" & i)
		aItemNo(i)=Request("txtItemNo" & i)
		aDimension(i)=Request("txtDimension" & i)
		if aDimension(i)="" then aDimension(i)=0
		aDimDetail(i)=Request("hDimDetail" & i)
		if aDimension(i)=0 then aDimDetail(i)=""
		aChargeableWeight(i)=Request("txtChargeableWeight" & i)
		if not aChargeableWeight(i)="" then
			aChargeableWeight(i)=cdbl(aChargeableWeight(i))
		else
			aChargeableWeight(i)=0
		end if
		aRateCharge(i)=Request("txtRateCharge" & i)
		aTotal(i)=Request("txtTotal" & i)
	next
	vWeightScale=aKgLb(0)

	
END SUB

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_HAWB_WEIGHT_CHARGE_ITEM_LINE
'Purpose  of the procedure: The procedure is in charge of getting the count of weight charge items
'Tasks that are performed within:									    
'1.Get the count of weight charge items from screen
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Function GET_HAWB_WEIGHT_CHARGE_ITEM_LINE
	F_NoItemWC=Request("hNoItemWC")
	if F_NoItemWC="" then F_NoItemWC=0	
	GET_HAWB_WEIGHT_CHARGE_ITEM_LINE = F_NoItemWC
END Function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_HAWB_OTHER_CHARGE_ITEM_LINE
'Purpose  of the procedure: The procedure is in charge of getting the count of other charge items
'Tasks that are performed within:									    
'1.Get the count of other charge items from screen
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Function GET_HAWB_OTHER_CHARGE_ITEM_LINE
	F_NoItemOC=Request("hNoItemOC")
	if F_NoItemOC="" then F_NoItemOC=0
	GET_HAWB_OTHER_CHARGE_ITEM_LINE = F_NoItemOC	
END Function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_HAWB_HEADER_INFO_FROM_SCREEN
'Purpose  of the procedure: The procedure is in charge of getting all the infromation stored in screen 
'in order to save/update HAWB
'Tasks that are performed within:									    
'1.GET all the values from the request submitted and store them in variables 
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB GET_HAWB_HEADER_INFO_FROM_SCREEN
	vCheckMH=Request("hCheckMH")
	vM_HAWB=Request("lstM_HAWB:Text")
	vCOLO=Request("cCOLO")
	if vCOLO="" or isEmpty(vCOLO) then 
		vCOLO="N"
	end if 

    vSalesPerson=Request("lstSalesRP")
    if vSalesPerson = "none" then
       Call GET_DEFAULT_SALES_PERSON_FROM_DB
    end if 
    
	if vCOLO="Y" then
		vCOLOPay=Request("lstCOLOPAy")
	else
		vCOLOPay="N"
		vCOLO="N"
	end if
	
	vColoderAcct=cLng(Request("lstColoder"))
	
	if not NewHAWB  = "yes" then
		vHAWB=Request("txtHAWB")
	end if

	if NOT tNo = TranNo then vHAWB = Session("HAWBTMP")
	
    if vHAWB="" then vHAWB="0"

	vMAWB=Request("hmawb_num")
	vAirOrgNum=Request("hAirOrgNum")
	if vAirOrgNum="" then vAirOrgNum=0
	vFFAgentName=Request("lstFFAgent")
	vFFAgentInfo=Request("hFFAgentInfo")
	vFFAgentAcct=Request("hFFAgentAcct")
	if not vFFAgentAcct="" then
		vFFAgentAcct=cLng(vFFAgentAcct)
	else
		vFFAgentAcct=0
	end if
	qShipperName=Request("txtShipperName")
	vSelectedShipperInfo=Request("lstShipperName")
	vShipperInfo=Trim(Request("txtShipperInfo"))

	pos=0
	pos=instr(vShipperInfo,chr(13))
	if pos>0 then
		vShipperName=Mid(vShipperInfo,1,pos-1)
	else
		vShipperName=vShipperInfo
	end if
	
	vShipperAcct = checkBlank(Request.Form("hShipperAcct").Item,0)

	vFFShipperAcct=Request("txtShipperAcct")
	qConsigneeName=Request("txtConsigneeName")
	vConsigneeInfo=Request("txtConsigneeInfo")
	vNotifyAcct=Request("hNotifyAcct")
	vSelectedConsigneeInfo=vConsigneeInfo
	pos=0
	pos=instr(vConsigneeInfo,chr(13))
	if pos>0 then
		vConsigneeName=Mid(vConsigneeInfo,1,pos-1)
	else
		vConsigneeName=vConsigneeInfo
	end if
	
	vConsigneeAcct=Request("hConsigneeAcct")
	if not vConsigneeAcct="" then
		vConsigneeAcct=cLng(vConsigneeAcct)
	else
		vConsigneeAcct=0
	end if
	vFFConsigneeAcct=Request("txtConsigneeAcct")
	vAgentInfo=Request("txtAgentInfo")
	vAgentIATACode=Request("txtAgentIATACode")
	vAgentAcct=Request("txtAgentAcct")
	vOriginPortID=Request("hOriginPortID")
	vDepartureAirport = Request("txtDepartureAirport")
	vDepartureState=Request("hDepartureState")
	vAccountInfo=Request("txtBillToInfo")
	vTo=Request("txtTo")
	vBy=Request("txtBy")
	vTo1=Request("txtTo1")
	vBy1=Request("txtBy1")
	vTo2=Request("txtTo2")
	vBy2=Request("txtBy2")
	vDestAirport=Request("txtDestAirport")
	vFlightDate1=Request("txtFlightDate1")
	vFlightDate2=Request("txtFlightDate2")
	vExportDate=Request("hExportDate") 
	if vExportDate="" then vExportDate="1/1/1900"
	vIssuedBy=Request("txtIssuedBy")
	vAccountInfo=Request("txtBillToInfo")
	vCurrency=Request("txtCurrency")
	vChargeCode=Request("txtChargeCode")
	vChargeCode=Request("txtChargeCode")


	vPPO_1 = Request("cPPO1")
	vCOLL_1 = Request("cCOLL1")
	vPPO_2 = Request("cPPO2")    
	vCOLL_2 = Request("cCOLL2") 


	
	vDeclaredValueCarriage=Request("txtDeclaredValueCarriage")
	vDeclaredValueCustoms=Request("txtDeclaredValueCustoms")
	vInsuranceAMT=Request("txtInsuranceAMT")
	vHandlingInfo=Request("txtHandlingInfo")
	vDestCountry=Request("txtDestCountry")
	vSCI=Request("txtSCI")
	vDemDetail=Request("txtDemDetail")
	vDimText=Request("dimtext")
	vSignature=Request("txtSignature")
	vExecute=Request("txtExecute")
	vReferenceNumber = Request("txtReferenceNumber")
    vSONum = Request.Form("hSONum")
    vPONum = Request.Form("hPONum")
	
END SUB

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_HAWB_INFORMATION_FROM_TABLE
'Purpose  of the procedure: The procedure is in charge of retriving HAWB information from DB
'Tasks that are performed within:									    
'1.retrive HAWB information from DB
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB GET_HAWB_INFORMATION_FROM_TABLE

	if vHAWB="0" then
		if Not aHAWBPrefix(0)="NONE" then
			'vHAWB=aHAWBPrefix(0) & "-" & aNextHAWB(0)
		else
			'vHAWB=aNextHAWB(0)
		end if
	end if
	
	if Not vHAWB="0" and Not vHAWB="" then
		SQL= "select * from hawb_master where elt_account_number = " & elt_account_number _
		    & " and is_dome='N' and HAWB_NUM=N'" & vHAWB & "'"
        
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing

		If Not rs.EOF Then
			vMAWB = rs("MAWB_NUM")
			
		    vM_HAWB= rs("sub_to_no")
			
		    if not isnull(rs("is_master")) then 
                vCheckMH= rs("is_master")
            else 
                vCheckMH= "N"
            end  if 		
			
			if not isnull(rs("is_sub")) then 
                vCheckSH= rs("is_sub")
            else 
                vCheckSH= "N"
            end  if 
		
			if vCheckMH="Y" OR vCheckSH="Y" then
				is_invoice_queued=rs("is_invoice_queued")
			end if           
		    vIsMasterClosed=rs("is_master_closed")
			
			IF isnull(rs("is_master_closed")) then
				vIsMasterClosed="N"
			end if 
		
			vAirOrgNum=rs("airline_vendor_num")
			vOriginPortID=rs("DEP_AIRPORT_CODE")
			vShipperAcct = rs("Shipper_Account_Number")
			
			vFFShipperAcct = rs("ff_shipper_acct")
			vFFAgentName=rs("agent_name")
			vShipperName=rs("shipper_name")
			If Not IsNull(rs("agent_name")) then
			vFFAgentAcct=cLng(rs("agent_no"))
			Else
			vFFAgentAcct=0
			End if
			vFFAgentInfo=rs("agent_info")
			vShipperInfo = rs("Shipper_Info")
			vConsigneeInfo = rs("Consignee_Info")
			vConsigneeAcct = rs("Consignee_acct_num")
			vConsigneeName=rs("Consignee_name")
			vFFConsigneeAcct = rs("ff_consignee_acct")
			vAgentInfo = rs("Issue_Carrier_Agent")
			vAgentIATACode = rs("Agent_IATA_Code")
			vAgentAcct = rs("Account_No")
			vDepartureAirport = rs("Departure_Airport")
			vDepartureState=rs("departure_state")
			vTo = rs("to_1")
			vBy = rs("by_1")
			vTo1 = rs("to_2")
			vBy1 = rs("by_2")
			vTo2 = rs("to_3")
			vBy2 = rs("by_2")
			vDestAirport = rs("Dest_Airport")
			vFlightDate1 = rs("Flight_Date_1")
			vFlightDate2 = rs("Flight_Date_2")
			vExportDate=rs("export_date")
			vIssuedBy = rs("IssuedBy")
			vAccountInfo = rs("Account_Info")
			vNotifyAcct =  rs("Notify_No")
			vChargeCode = rs("Charge_Code")


			vPPO_1 = rs("PPO_1")
			vCOLL_1 = rs("COLL_1")
			vPPO_2 = rs("PPO_2")
			vCOLL_2 = rs("COLL_2")

     
			vDeclaredValueCarriage = rs("Declared_Value_Carriage")
			vDeclaredValueCustoms = rs("Declared_Value_Customs")
			vInsuranceAMT = rs("Insurance_AMT")
			vHandlingInfo = rs("Handling_Info")
			vDestCountry=rs("dest_country")
			vSCI = rs("SCI")
			vDimText= rs("dimtext")
			vTotalPieces=rs("total_pieces")
			vTotalGrossWeight=rs("total_gross_weight")
			vTotalWeightCharge=rs("total_weight_charge_hawb")
			
			vAFCost = ConvertAnyValue(rs("af_cost"), "Double", 0)
			vAgentProfit = ConvertAnyValue(rs("agent_profit"), "Double", 0)
			vAgentProfitPercent = ConvertAnyValue(rs("agent_profit_share"),"Double",0) * 100
			vOtherProfitCarrier = ConvertAnyValue(rs("other_agent_profit_carrier"), "Double", 0)
			vOtherProfitAgent = ConvertAnyValue(rs("other_agent_profit_agent"), "Double", 0)
			
			vDesc1=rs("desc1")
			vDesc2=rs("desc2")
			vManifestDesc=rs("manifest_desc")
			vLC=rs("lc")
			vCI=rs("ci")
			vOtherRef=rs("other_ref")
			
			vAES = checkBlank(rs("aes_xtn"),"")
            vSEDStmt = checkBlank(rs("sed_stmt").value,"")
            
            If vAES = "" And vSEDStmt = "" Then
                vSEDStmt = GetSQLResult("SELECT sed_statement FROM user_profile WHERE elt_account_number=" & elt_account_number, Null)
            End If
            
			vPrepaidWeightCharge=rs("Prepaid_Weight_Charge")
			vCollectWeightCharge=rs("Collect_Weight_Charge")
			vPrepaidOtherChargeAgent=rs("Prepaid_Due_Agent")
			vCollectOtherChargeAgent=rs("Collect_Due_Agent")
			vPrepaidOtherChargeCarrier=rs("Prepaid_Due_Carrier")
			vCollectOtherChargeCarrier=rs("Collect_Due_Carrier")
			vPrepaidTotal = ConvertAnyValue(rs("Prepaid_Total"), "Double", 0)
			vCollectTotal = ConvertAnyValue(rs("Collect_Total"), "Double", 0)
			vPrepaidValuationCharge=rs("Prepaid_Valuation_Charge")
			vCollectValuationCharge=rs("Collect_Valuation_Charge")
			vPrepaidTax=rs("Prepaid_Tax")
			vCollectTax=rs("Collect_Tax")
			vConversionRate=rs("Currency_Conv_Rate")
			vCCCharge=rs("CC_Charge_Dest_Rate")
			vChargeDestination=rs("Charge_at_Dest")
			vFinalCollect=rs("Total_Collect_Charge")
			
			vShowWeightChargeShipper=rs("show_weight_charge_shipper")
			vShowWeightChargeConsignee=rs("show_weight_charge_consignee")
			vShowPrepaidOtherChargeShipper=rs("show_prepaid_other_charge_shipper")
			vShowCollectOtherChargeShipper=rs("show_collect_other_charge_shipper")
			vShowPrepaidOtherChargeConsignee=rs("show_prepaid_other_charge_consignee")
			vShowCollectOtherChargeConsignee=rs("show_collect_other_charge_consignee")
			vSignature = rs("Signature")
			vExecute=rs("execution")
			vCOLO=rs("colo")
            if(isnull(rs("SalesPerson"))) then 
	         vSalesPerson=""
            else 
 	        vSalesPerson=rs("SalesPerson")
            end if 
			if IsNull(vCOLO) then vCOLO="N"
			vCOLOPay=rs("colo_pay")			
			vColoderAcct=rs("coloder_elt_acct")
			if Not vColoderAcct="" then vColoderAcct=cLng(vColoderAcct)
			vReferenceNumber = rs("reference_number").value
			rs.Close
		else
		    rs.Close
		    Response.Write("<script> alert('Could not find the HAWB'); location.href = 'new_edit_hawb.asp'; </script>")
		    Response.End()
		end if
		
		If vCheckMH ="Y" then 
			call SUMUP_WEIGHT_CHARGES_BELONG_TO_MASTER_HOUSE(vM_HAWB)		
		end if 
	
		SQL= "select no_pieces,unit_qty,gross_weight,adjusted_weight,kg_lb,rate_class,commodity_item_no," _
		    & "dimension,dem_detail,chargeable_weight,rate_charge,total_charge " _
		    & "from hawb_weight_charge where elt_account_number = " & elt_account_number _
		    & " and hawb_num=N'" & vHAWB & "' order by tran_no"
		
		
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing
		wIndex=0
		Do while Not rs.EOF
			aPiece(wIndex)=rs("no_pieces")
			aUnitQty(wIndex)=rs("unit_qty")
			aGrossWeight(wIndex)=rs("gross_weight")
			aAdjustedWeight(wIndex)=rs("adjusted_weight")
			aKgLb(wIndex)=rs("kg_lb")
			aRateClass(wIndex)=rs("rate_class")
			aItemNo(wIndex)=rs("commodity_item_no")
			aDimension(wIndex)=rs("dimension")
			aDimDetail(wIndex)=rs("dem_detail")
			aChargeableWeight(wIndex)=rs("chargeable_weight")
			aRateCharge(wIndex)=rs("rate_charge")
			if aRateCharge(wIndex)="-1" then aRateCharge(wIndex)="MIN"
			aTotal(wIndex)=rs("total_charge")
			rs.MoveNext
			wIndex=wIndex+1
		Loop
		rs.Close
		
		vDemDetail=aDimDetail(0)
		
		'// to show system charge items default, change left join to right join in the second part of union
        SQL= "(select a.tran_no,a.coll_prepaid, a.carrier_agent, a.charge_code, a.charge_desc, a.amt_hawb " _
            & "from hawb_other_charge a left outer join item_charge b " _
            & "on (a.elt_account_number=b.elt_account_number and a.charge_code=b.item_no) " _
            & "where isnull(b.item_def,'Custom')='Custom' and a.elt_account_number = " _
            & elt_account_number & " and a.hawb_num=N'" & vHAWB _
            & "') union (select isnull(a.tran_no,0),isnull(a.coll_prepaid,'') as coll_prepaid," _
            & "isnull(a.carrier_agent,'') as carrier_agent,b.item_no as charge_code, b.item_desc as charge_desc," _
            & "isnull(a.amt_hawb,0) as amt_hawb from " _
            & "(select * from hawb_other_charge where hawb_num=N'" & vHAWB _
            & "') a right outer join item_charge b " _
            & "on (a.elt_account_number=b.elt_account_number and a.charge_code=b.item_no) " _ 
            & "where b.elt_account_number=" & elt_account_number & " and isnull(b.item_def,'Custom')='System') order by tran_no"
        
        rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing
		
		oIndex=0
		Do while Not rs.EOF
			aCollectPrepaid(oIndex)=rs("coll_prepaid")
			aCarrierAgent(oIndex)=rs("carrier_agent")
			aChargeCode(oIndex)=rs("charge_code")
			aDesc(oIndex)=rs("charge_desc")
			aChargeAmt(oIndex)=rs("amt_hawb")
			
			rs.MoveNext
			oIndex=oIndex+1
		Loop
		rs.Close
		
		NoItemOC=oIndex
		
		if NoItemOC>5 then
			for i=0 to NoItemOC-1 Step 2
				aOtherCharge(Fix(i/2))=aDesc(i) & " " & FormatNumberPlus(aChargeAmt(i),2) & "  " & aDesc(i+1) & " " & FormatNumberPlus(aChargeAmt(i+1),2)
			next
		else
			for i=0 to NoItemOC-1
				aOtherCharge(i)=aDesc(i) & " " & FormatNumberPlus(aChargeAmt(i),2)
			next
		end if
	else
		vCOLL_1="Y"
		vCOLL_2="Y"
		vDeclaredValueCarriage="NVD"
		vDeclaredValueCustoms="NCV"
		vInsuranceAMT="XXX"
		vShowWeightChargeShipper="Y"
		vShowWeightChargeConsignee="Y"
		vShowPrepaidOtherChargeShipper="Y"
		vShowCollectOtherChargeShipper="Y"
		vShowPrepaidOtherChargeConsignee="Y"
		vShowCollectOtherChargeConsignee="Y"

		wIndex=0
		
		SQL= "select '' as coll_prepaid,'' as carrier_agent,item_no,item_desc,0 as amt_hawb from " _
            & "item_charge where elt_account_number=" & elt_account_number _
            & " and isnull(item_def,'Custom')='System' order by item_no"
        
        rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing
		
		oIndex=0
		Do while Not rs.EOF
			aCollectPrepaid(oIndex)=rs("coll_prepaid")
			aCarrierAgent(oIndex)=rs("carrier_agent")
			aChargeCode(oIndex)=rs("item_no")
			aDesc(oIndex)=rs("item_desc")
			aChargeAmt(oIndex)=rs("amt_hawb")
			oIndex = oIndex + 1
			rs.MoveNext
		Loop
		rs.Close
		
		vSEDStmt = GetSQLResult("SELECT sed_statement FROM user_profile WHERE elt_account_number=" & elt_account_number, Null)
		'// If vDeclaredValueCustoms = "NCV" Or ConvertAnyValue(vDeclaredValueCustoms,"Double","0")<2500 Then
        '// End If
	end if

    
END SUB

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_DEFAULT_SHIPPER_INDEX
'Purpose  of the procedure: The procedure is in charge of finding out if the current ELT account is listed
'in the default shipper and returing the index of the shipper to be used in determining wheter to set 
'the shipper to be the ELT account holder when creating a Master House
'Tasks that are performed within:									    
'1.Get the index of the current ELT account holder from the shipper list box
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Function GET_DEFAULT_SHIPPER_INDEX
    
	Dim tempValue,returnValue,rs
    returnValue = 0
	tempValue = 1
	Set rs = Server.CreateObject("ADODB.Recordset")
    SQL = "select org_account_number,dba_name from organization where elt_account_number=" _
        & elt_account_number & " and agent_elt_acct = " & elt_account_number
    
    
    eltConn.CursorLocation = adUseNone
    rs.CursorLocation = adUseClient	
    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
    Set rs.ActiveConnection = Nothing
    
    if Not rs.EOF then
		returnValue = rs("org_account_number") & "-" & rs("dba_name")
    end if
    rs.Close()
    GET_DEFAULT_SHIPPER_INDEX = returnValue
	
End Function 


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_MAWB_INFO
'Purpose  of the procedure: The procedure is in charge of retrieving all the MAWB #s  that will be stored 
' in the MAWB selection list
'Tasks that are performed within:									    
'1.Retrive all teh MAWB numbers and store them into arry aMAWB()
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB GET_MAWB_INFO
	SQL= "SELECT mawb_no FROM mawb_number WHERE elt_account_number=" & elt_account_number _
	    & " AND status='B' AND is_dome='N' AND ISNULL([File#],'')<>'' ORDER BY mawb_no"

	If rs.state <> 0 Then
		rs.close()
	End If

	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	reDim aMAWB(rs.RecordCount)
	
	If Not rs.EOF Then
		mIndex=0
		aMAWB(0)="Select One"
		Do While Not rs.EOF
			mIndex = mIndex + 1
			aMAWB(mIndex) = rs("mawb_no")
			rs.MoveNext
		Loop
	End If
	rs.close()
END SUB

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GetFileNumber
'Purpose  of the procedure: The procedure is in charge of getting file number pertaing to the MAWB 
' that the HAWB is assinged 
'Tasks that are performed within:									    
'1.Get the File number from the MAWB 
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Function GetFileNumber(mawb_num)
    Dim resVal,rs,SQL
    Set rs = Server.CreateObject("ADODB.Recordset")
    SQL = "SELECT File# from mawb_number where elt_account_number=" & elt_account_number _
        & " AND mawb_no=N'" & mawb_num & "' and is_dome='N'"
    
    
    resVal = ""    
   	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing

    If Not rs.EOF And Not rs.BOF Then
        resVal = rs("File#").value
    End If
        
    GetFileNumber = resVal
End Function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_DEP_ARR_CODE
'Purpose  of the procedure: The procedure is in charge of retrieving the airport codes for departure
'and arrival
'Tasks that are performed within:									    
'1.find and store departure and arrival airport code in the variables
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Sub GET_DEP_ARR_CODE
	SQL= "select Origin_Port_ID,Dest_Port_ID from mawb_number a where elt_account_number = " _
	    & elt_account_number & " and is_dome='N' And mawb_no=N'" & vMAWB & "'"
	
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	If Not rs.EOF Then
		vDepCode=rs("Origin_Port_ID")
    	vArrCode =rs("Dest_Port_ID")
	END IF 
	rs.close
End Sub 

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_COLODER_INFO
'Purpose  of the procedure: The procedure is in charge of retriving all possible coloader orgainzation and 
'storing them in the the list of coloaders in order to make the HAWB to be seen(transferred) to the coloader
'system user.
'Tasks that are performed within:									    
'1.Find all the users that are the listed companies in the clinet profile and  has ELT user account of our system
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB GET_COLODER_INFO
	SQL= "select coloder_name,coloder_elt_acct from colo where colodee_elt_acct = " _
	    & elt_account_number & " order by coloder_name"
	
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	
	coIndex=1
	aColoderName(0)="Select One"
	aColoderAcct(0)=0
	Do While Not rs.EOF
		aColoderName(coIndex)=rs("coloder_name")
		aColoderAcct(coIndex)=cLng(rs("coloder_elt_acct"))
		coIndex=coIndex+1
		rs.MoveNext
	Loop
	rs.Close
	
END SUB

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:CHECK_EX_DATE
'Purpose  of the procedure: The procedure is in charge of fining out the time the HAWB is executed 
'Tasks that are performed within:									    
'1.Find out the first estimated date of departure for the HAWB 
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Function CHECK_EX_DATE ( vMAWB, ArrivalDept ) 
	Dim tmpSQL
	
	If Trim(vMAWB) = "" Then
		CHECK_EX_DATE = ArrivalDept
		Exit function
	End If
	
	If ( Not IsDate(ArrivalDept)) Or ( Trim(ArrivalDept) = "" ) Or ( ArrivalDept = "1/1/1900" )  Then
		tmpSQL="select ETD_DATE1 as export_date from mawb_number where elt_account_number=" _
		    & elt_account_number & " and is_dome='N' AND mawb_no=N'" & vMAWB & "'"
		
		rs3.CursorLocation = adUseClient
		rs3.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs3.activeConnection = Nothing	
	
		If Not rs3.EOF And IsNull(rs3("export_date"))=False Then
			ArrivalDept=rs3("export_date")
		Else
			ArrivalDept=""
		End If
		rs3.close
	End If

	CHECK_EX_DATE = ArrivalDept

End Function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_CHARGE_ITEM_INFO
'Purpose  of the procedure: The procedure is in charge of retrieving all the charge items from DB
'Tasks that are performed within:									    
'1.retrive all the charge items and store them to the arrarys that will be displayed on the screen
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB GET_CHARGE_ITEM_INFO

	SQL= "select item_name,item_no,item_desc,unit_price from item_charge where elt_account_number = " _
	    & elt_account_number & " order by item_name"	
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing

	chIndex=1
	aChargeItemName(0)="Select One"
	aChargeItemNo(0)=0
	aChargeUnitPrice(0)=0 '// Unit_price by ig 10/21/2006
	aChargeItemDesc(0)=""
	aChargeItemNameig(0)="Select One"
	
	Do While Not rs.EOF
		aChargeItemName(chIndex)=rs("item_name")
		aChargeItemNo(chIndex)=cInt(rs("item_no"))
		aChargeItemDesc(chIndex)=rs("item_desc")
		aChargeUnitPrice(chIndex)=rs("unit_price") '// Unit_price by ig 10/21/2006
		
		if ( len(aChargeItemName(chIndex))) < 7 then	
			aChargeItemNameig(chIndex) = aChargeItemName(chIndex) & " " & string(7-len(aChargeItemName(chIndex)),"-") & " " & aChargeItemDesc(chIndex)
		else
			aChargeItemNameig(chIndex) = aChargeItemName(chIndex)
		end if
		
		chIndex=chIndex+1
		rs.MoveNext
	Loop
	rs.Close
END SUB


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:UPDATE_CARGO_TRACKING_FOR_SHIPPING_REQUEST
'Purpose  of the procedure: The procedure is in charge of 
'Tasks that are performed within:									    
'1.
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB UPDATE_CARGO_TRACKING_FOR_SHIPPING_REQUEST
	if Not vCI="" then
		pos=0
		pos=instr(vCI,",")
		Do while pos>0
			vRefNo=Mid(vCI,1,pos-1)
			vCI=Mid(vCI,pos+1,2000)
			SQL= "select hawb,mawb from cargo_tracking where elt_account_number = " & elt_account_number _
			    & " and shipper_acct=" & vShipperAcct & " and ref_no=N'" & vRefNo & "'"
			
			
			rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
			If Not rs.EOF Then
				rs("hawb")=vHAWB
				rs("mawb")=vMAWB
				rs.Update
			End If
			rs.Close
			pos=0
			pos=instr(vCI,",")
		loop
		vRefNo=vCI
		SQL= "select hawb,mawb from cargo_tracking where elt_account_number = " & elt_account_number _
		    & " and shipper_acct=" & vShipperAcct & " and ref_no=N'" & vRefNo & "'"
		
		
		rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
		If Not rs.EOF Then
			rs("hawb")=vHAWB
			rs("mawb")=vMAWB
			rs.Update
		End If
		rs.Close
	end if
END SUB

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:RESET_SUB_HOSUES
'Purpose  of the procedure: The procedure is in charge of making all the sub houses to be normal houses 
'when the master house becomes normal house or delted
'Tasks that are performed within:									    
'1.Clear the sub_to_no, is_sub for each sub houses
'2.Make them invoice queuable 
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB RESET_SUB_HOSUES
	dim SQL	
	SQL="UPDATE hawb_master set is_sub='N',sub_to_no='', is_invoice_queued='Y' where ( elt_account_number=" _
	    & elt_account_number & " OR coloder_elt_acct=" & elt_account_number _
	    & " ) and is_dome='N' and sub_to_no=N'" & vHAWB & "' "
    
    
	eltConn.Execute(SQL)
END sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:DELETE_HAWB
'Purpose  of the procedure: The procedure is in charge of deleting a HAWB
'Tasks that are performed within:									    
'1.Delete a HAWB in the DB
'2.Delete all the HAWB weight charges
'3.Delete all the HAWB other charges 
'4.Delete all the invoice queue entries
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB DELETE_HAWB( vHAWB )
	if vCheckMH="Y" then
		call RESET_SUB_HOSUES
	end if
	SQL= "select hawb_num from hawb_master where elt_account_number = " & elt_account_number _
	    & " and is_dome='N' and HAWB_NUM=N'" & vHAWB & "'"
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	If Not rs.EOF Then
		rs.close
		SQL= "delete from hawb_master where elt_account_number = " & elt_account_number _
		    & " and is_dome='N' and hawb_num=N'" & vHAWB & "'"
		eltConn.Execute SQL
		SQL= "delete from hawb_weight_charge where elt_account_number = " & elt_account_number _
		    & " and hawb_num=N'" & vHAWB & "'"
		eltConn.Execute SQL
		SQL= "delete from hawb_other_charge where elt_account_number = " & elt_account_number _
		    & " and hawb_num=N'" & vHAWB & "'"
		eltConn.Execute SQL
		SQL= "delete from invoice_queue where elt_account_number = " & elt_account_number _
		    & " and hawb_num=N'" & vHAWB & "' AND air_ocean='A' AND is_dome='N'"
		eltConn.Execute SQL			
		SQL= "delete from hawb_other_cost where elt_account_number = " & elt_account_number _
		    & " and hawb_num=N'" & vHAWB & "'"
		eltConn.Execute SQL
		
		vHAWB = ""
	else
%>

<script type="text/jscript">    alert('Could not find the HAWB'); location.href = 'new_edit_hawb.asp'; </script>

<%
	end if
END SUB

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_HAWB_PREFIX_FROM_USER_PROFILE
'Purpose  of the procedure: The procedure is in charge of getting a list of HAWB prefix  and next HAWB #used in creating a HAWB number
'Tasks that are performed within:									    
'1.Retrieve and store all the HAWB prefix from the DB
'2.Retrieve and store all the next number for each prefix
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Sub GET_HAWB_PREFIX_FROM_USER_PROFILE
	SQL= "select prefix,next_no from user_prefix where elt_account_number=" & elt_account_number _
	    & " and type='HAWB' order by seq_num"
    
    
	rs3.CursorLocation = adUseClient
	rs3.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs3.activeConnection = Nothing
	pIndex=0
	do While Not rs3.EOF
		aHAWBPrefix(pIndex)=rs3("prefix")
		aNextHAWB(pIndex)=rs3("next_no")
		rs3.MoveNext
		pIndex=pIndex+1
	loop
	rs3.Close
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_DEFAULT_WEIGHT_SCALE
'Purpose  of the procedure: The procedure is in charge of finding out weight scale that the user uses
'                           from the user profile
'Tasks that are performed within:
'1)Set the first entry of aKgLb to be the one in user profile
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB GET_DEFAULT_WEIGHT_SCALE
    Dim vUOM
	SQL= "select uom,uom_qty from user_profile where elt_account_number = " & elt_account_number
	
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	if not rs.EOF then
		vUOM=rs("uom")
		if vUOM="KG" then
			aKgLb(0)="K"
		else
			aKgLb(0)="L"
		end if
		aunitqty(0)=rs("uom_qty")
	end if
	rs.Close
END SUB

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_AGENT_GENERAL_INFORMAION
'Purpose  of the procedure: The procedure is in charge of retrieving necessary information for an agent
'Tasks that are performed within:									    
'1.retrive general information for an agent
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

SUB GET_AGENT_GENERAL_INFORMAION
	vExecute = ""
	SQL= "select dba_name,business_address,business_city,business_state,business_zip,business_country," _
	    & "business_phone,agent_IATA_Code,country_code from agent where elt_account_number = " & elt_account_number
	    
	    
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing
	If Not rs.EOF Then
		vAgentIATACode = rs("Agent_IATA_Code")
		AgentName = rs("dba_name")
		vDefaultAgentName=AgentName
		AgentAddress=rs("business_address")
		AgentCity = rs("business_city")
		AgentState = rs("business_state")
		AgentZip = rs("business_zip")
		AgentCountry = rs("business_country")
		AgentPhone=rs("business_phone")
		AgentCountryCode = rs("country_code")
		vAgentInfo=AgentName & chr(10) & AgentAddress & chr(10) & AgentCity & "," & AgentState & " " & AgentZip & "," & AgentCountry
		vDefaultAgentInfo=vAgentInfo
		vShipperAcct=elt_account_number
		vPlaceExecuted=AgentCity & "," & AgentState & " " & AgentZip & " " & AgentCountry
		If IsNull(vIssuedBy) Or vIssuedBy = "" Then
			vIssuedBy=AgentName
		End If
		vExecute=AgentName & chr(10) & Date & " " & vPlaceExecuted 
		vSignature="FOR " & AgentName
		vExecutionDatePlace=Date & " " & vPlaceExecuted
		aShipperName(1)=AgentName
		aShipperInfo(1)=elt_account_number & "-" & AgentName & chr(10) & AgentAddress & chr(10) & AgentCity & "," & AgentState & " " & AgentZip & "," & AgentCountry & chr(10) & AgentPhone
		aShipperAcct(1)=elt_account_number
	End If
	rs.Close
END SUB

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:INVOICE_QUEUE_REFRESH
'Purpose  of the procedure: The procedure is in charge of deleting all the invoice queue entries that 
'belong to the HAWB/MAWB
'Tasks that are performed within:									    
'1.delete all the queue entries that belong to the HAWB
'2.delete all the queue entries that belong to the MAWB
'3.Last query should be understoood 
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Sub INVOICE_QUEUE_REFRESH( tvHAWB )
	
	DIM arr_queue_id(100),qu_index
	qu_index = 0
	SQL="select queue_id from invoice_queue where elt_account_number=" & elt_account_number _
	    & " and hawb_num=N'" & tvHAWB & "' and invoiced='N'"
	
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	
	Do While Not rs.EOF
		arr_queue_id(qu_index) = rs("queue_id")
		qu_index = qu_index + 1										
		rs.MoveNext
	Loop
	rs.Close
	
	SQL="select queue_id from invoice_queue where elt_account_number=" & elt_account_number _
	    & " and agent_shipper='A' and mawb_num=N'" & vMAWB & "' and invoiced='N' and bill_to_org_acct=" & vFFAgentAcct
	
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	
	Do While Not rs.EOF
		arr_queue_id(qu_index) = rs("queue_id")
		qu_index = qu_index + 1										
		rs.MoveNext
	Loop
	rs.Close
	for iii = 0 to qu_index - 1
		SQL= "delete invoice_queue where elt_account_number=" & elt_account_number & "and invoiced='N' and queue_id=" & arr_queue_id(iii)
		
		eltConn.Execute SQL
	next
	
	SQL= "delete invoice_queue where elt_account_number=" & elt_account_number & " and agent_shipper='A' and mawb_num=N'" & vMAWB _
	    & "' and invoiced='N' and bill_to_org_acct not in (select agent_no from hawb_master where elt_account_number=" & elt_account_number _
	    & " and is_dome='N' and mawb_num=N'" & vMAWB & "' group by agent_no )"
	
	eltConn.Execute SQL
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:INVOICE_QUEUE_REFRESH_MAWB
'Purpose  of the procedure: The procedure is in charge of deleting all the invoice queue entries that
'belong to the MAWB
'Tasks that are performed within:									    
'1.delete all the invoice entry that belong to the MAWB
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB INVOICE_QUEUE_REFRESH_MAWB( vMAWB )
	DIM arr_queue_id(100),qu_index
	qu_index = 0	
	SQL="select queue_id from invoice_queue where elt_account_number=" & elt_account_number _
	    & " and mawb_num=N'" & vMAWB & "' and invoiced='N' "
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	Do While Not rs.EOF
		arr_queue_id(qu_index) = rs("queue_id")
		qu_index = qu_index + 1										
		rs.MoveNext
	Loop
	rs.Close
	for iii = 0 to qu_index - 1
		SQL= "delete invoice_queue where elt_account_number=" & elt_account_number _
		    & " and mawb_num=N'" & vMAWB & "' and invoiced='N' and queue_id=" & arr_queue_id(iii)
		
		eltConn.Execute SQL
	next
	SQL= "delete invoice_queue where elt_account_number=" & elt_account_number _
	    & " and agent_shipper='A' and mawb_num=N'" & vMAWB _
	    & "' and invoiced = 'N' and bill_to_org_acct not in (select agent_no from hawb_master where elt_account_number=" _
	    & elt_account_number & " and mawb_num=N'" & vMAWB & "' group by agent_no )"
	
	eltConn.Execute SQL
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:HAWB_INVOICE_QUEUE
'Purpose  of the procedure: The procedure is in charge of creating/updating invoice queue entries
'Tasks that are performed within:									    
'1.Delete all the HAWB invoice queue entries in the queue that belong to the MAWB that the HAWB is assigned
'2.Recreate all the HAWB invoice reflecting the changes made for the HAWB and the Sub HAWBs, and the other 
'HAWBS that belong to the MAWB. 
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Sub HAWB_INVOICE_QUEUE( tmpHAWB, tmpMAWB)
	if trim(tmpMAWB) = "" then
		exit sub
	end if
	IF (vCheckMH <>"Y" and vCheckSH <> "Y") OR (vCheckSH="Y" and is_invoice_queued <>"N") OR (vCheckMH="Y" and is_invoice_queued <>"N") THEN
	   
		if vPPO_1="Y" or vPPO_2="Y" then
			SQL="select * from invoice_queue where elt_account_number=" & elt_account_number _
			    & " and agent_shipper='S' and hawb_num=N'" & tmpHAWB & "' and bill_to_org_acct=" & vShipperAcct
			
			rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
			if rs.EOF then
				vQueueID = GET_QUEUE_ID() 
				rs.AddNew
				rs("elt_account_number")=elt_account_number
				rs("queue_id")=vQueueID
				rs("inqueue_date")=now
				rs("agent_shipper")="S"
				rs("hawb_num")=tmpHAWB
				rs("mawb_num")=tmpMAWB
				rs("bill_to")=vShipperName
				rs("bill_to_org_acct")=vShipperAcct
				rs("agent_name")=vFFAgentName
				rs("agent_org_acct")=vFFAgentAcct
				rs("air_ocean")="A"
				rs("invoiced")="N"
				rs.Update
			end if
			rs.close
		end if
		if vCOLL_1="Y" or vCOLL_2="Y" then
			SQL="select * from invoice_queue where elt_account_number=" & elt_account_number _
			    & " and agent_shipper='A' and mawb_num=N'" & tmpMAWB & "' and bill_to_org_acct=" & vFFAgentAcct
			
			rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
			if rs.EOF then
				vQueueID = GET_QUEUE_ID() 
				rs.AddNew
				rs("elt_account_number")=elt_account_number
				rs("queue_id")=vQueueID
				rs("inqueue_date")=now
				rs("agent_shipper")="A"
				rs("mawb_num")=tmpMAWB
				rs("bill_to")=vFFAgentName
				rs("bill_to_org_acct")=vFFAgentAcct
				rs("agent_name")=vFFAgentName
				rs("agent_org_acct")=vFFAgentAcct
				rs("air_ocean")="A"
				rs("invoiced")="N"
				rs.Update
			end if
			rs.close
		end if
		
	END IF 
	CALL INVOICE_QUEUE_REFRESH_MAWB( tmpMAWB )
	dim atmpHAWB(100),tmpIndex 
	Set dict = CreateObject("Scripting.Dictionary")
	tmpIndex = 0
	SQL = "select hawb_num, Agent_Name from hawb_master where " _
	    & "((( isnull(is_master,'N')='Y' or isnull(is_sub,'N')='Y') and " _
	    & "isnull(is_invoice_queued,'Y') <> 'N') OR (( isnull(is_master,'N')='N' " _
	    & "and isnull(is_sub,'N')='N'))) and elt_account_number = " & elt_account_number _
	    & " and is_dome='N' and mawb_num=N'" & tmpMAWB & "'" 
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	
	Do while Not rs.EOF
		atmpHAWB(tmpIndex)=rs("hawb_num")
		tmpAgent(tmpIndex)=rs("Agent_Name")
		tmpval=tmpAgent(tmpIndex)
		if not dict.Exists(tmpval) then		   
			dict.Add tmpval, 1
		else 			
			dict(tmpval)=dict(tmpval)+1
		end if 
		tmpIndex = tmpIndex + 1
		rs.MoveNext
	Loop
	rs.Close
	for i=0 to tmpIndex-1
		call HAWB_INVOICE_QUEUE_SINGLE ( atmpHAWB(i), tmpIndex,tmpAgent(i))
	next
	set dict=nothing 	
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:HAWB_INVOICE_QUEUE_SINGLE
'Purpose  of the procedure: The procedure is in charge of entring an invoice queue entry with the HAWB
'Tasks that are performed within:									    
'1.Enter a invoice queue entry to the queue according to the fact whether if it should be prepaid or collected
'  If inovice is prepaid invoice queue will be entered for the shipper, otherwise, it will be entered for the agent
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Sub HAWB_INVOICE_QUEUE_SINGLE ( tmpHAWB, tmpIndex,tmpAt )
	DIM tvQueueID,tvShipperAcct,tvShipperName,tvFFAgentAcct,tvFFAgentName,tvPPO_1,tvPPO_2,tvCOLL_1,tvCOLL_2,tvMAWB
	DIM rs
	Set rs = Server.CreateObject("ADODB.Recordset")	
	SQL= "select MAWB_NUM,Shipper_Account_Number,ff_shipper_acct,agent_name,agent_no," _
	    & "shipper_name,PPO_1,COLL_1,PPO_2,COLL_2 from hawb_master where elt_account_number=" _
	    & elt_account_number & " and is_dome='N' and HAWB_NUM=N'" & tmpHAWB & "'"
	
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	if not rs.EOF Then		
		tvMAWB = rs("MAWB_NUM")
		tvShipperAcct = rs("Shipper_Account_Number")
		tvFFShipperAcct = rs("ff_shipper_acct")
		tvFFAgentName=rs("agent_name")
		tvFFAgentAcct=cLng(rs("agent_no"))
		tvShipperName=rs("shipper_name")
		tvPPO_1 = rs("PPO_1")
		tvCOLL_1 = rs("COLL_1")
		tvPPO_2 = rs("PPO_2")
		tvCOLL_2 = rs("COLL_2")
		if tvPPO_1="Y" or tvPPO_2="Y" then
			rs.close	
			tvQueueID = GET_QUEUE_ID()
			SQL="select * from invoice_queue where elt_account_number=" & elt_account_number _
			    & " and agent_shipper='S' and hawb_num=N'" & tmpHAWB & "' and bill_to_org_acct=" & tvShipperAcct
			
			
			rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
			if rs.EOF then
				rs.AddNew
				rs("elt_account_number")=elt_account_number
				rs("queue_id")=tvQueueID
				rs("inqueue_date")=now
				rs("agent_shipper")="S"
				rs("hawb_num")=tmpHAWB
				rs("mawb_num")=tvMAWB
				rs("bill_to")=tvShipperName
				rs("bill_to_org_acct")=tvShipperAcct
				rs("agent_name")=tvFFAgentName
				rs("agent_org_acct")=tvFFAgentAcct
				rs("air_ocean")="A"
				rs("invoiced")="N"
				rs.Update
			end if
			rs.close
		else
			rs.close			
		end if
		if tvCOLL_1="Y" or tvCOLL_2="Y" then
			tvQueueID = GET_QUEUE_ID()
			SQL="select * from invoice_queue where elt_account_number=" & elt_account_number _
			    & " and agent_shipper='A' and mawb_num=N'" & tvMAWB & "' and bill_to_org_acct=" & tvFFAgentAcct
			
			
			rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
			if rs.EOF then
				rs.AddNew
				rs("elt_account_number")=elt_account_number
				rs("queue_id")=tvQueueID
				rs("inqueue_date")=now
				rs("agent_shipper")="A"
				if dict(tmpAt)=1 then				
					rs("hawb_num")=tmpHAWB
				else
					rs("hawb_num")="CONSOLIDATION"
				end if
				rs("mawb_num")=tvMAWB
				rs("bill_to")=tvFFAgentName
				rs("bill_to_org_acct")=tvFFAgentAcct
				rs("agent_name")=tvFFAgentName
				rs("agent_org_acct")=tvFFAgentAcct
				rs("air_ocean")="A"
				rs("invoiced")="N"
				rs.Update
			end if
			rs.close
		end if
	end if	
	set rs=nothing 
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_QUEUE_ID
'Purpose  of the procedure: The procedure is in charge of retrieving current queue id that will be assinged
'to the next invoice queue entry
'Tasks that are performed within:									    
'1.retreive the most updated queue id
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
FUNCTION GET_QUEUE_ID
	SQL="select max(queue_id) as queue_id from invoice_queue where elt_account_number=" & elt_account_number
	
	
	rs3.CursorLocation = adUseClient
	rs3.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs3.activeConnection = Nothing
	If Not rs3.EOF And IsNull(rs3("queue_id"))=False Then
		vQueueID=CLng(rs3("queue_id"))+1
	Else
		vQueueID=1
	End If
	rs3.close
GET_QUEUE_ID = vQueueID
END FUNCTION

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:CHECK_INVOICE_STATUS_HAWB
'Purpose  of the procedure: The procedure is in charge of checking out whether the invoices belong to the 
'HAWB has been processed or not 
'Tasks that are performed within:									    
'1.Find all the invoice # belong to the HAWB and store on a array
'2.Make a message string that will be used in alerting the user when the user attempt to modify HAWB that
'are already processed.
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB CHECK_INVOICE_STATUS_HAWB( tvHAWB, t_elt_account_number )
	DIM invoiceNUM(100),ivIndex
	ivIndex = 0				
	if tvHAWB = "" Then Exit sub
		SQL="select invoice_no from invoice where elt_account_number=" & t_elt_account_number _
		    & " and air_ocean = 'A' and hawb_num=N'" & tvHAWB & "'"
		
		rs3.CursorLocation = adUseClient
		rs3.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs3.activeConnection = Nothing
		Do While Not rs3.EOF
			invoiceNUM(ivIndex) = rs3("invoice_no")
			ivIndex = ivIndex + 1										
			rs3.MoveNext
		Loop
		rs3.Close
		if ivIndex = 0	then
			SQL= "select invoice_no from invoice_hawb where elt_account_number = " & elt_account_number _
			    & " and hawb_num=N'" & tvHAWB & "'"
			
			
			rs3.CursorLocation = adUseClient
			rs3.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
			Set rs3.activeConnection = Nothing
			Do While Not rs3.EOF
				invoiceNUM(ivIndex) = rs3("invoice_no")
				ivIndex = ivIndex + 1										
				rs3.MoveNext
			Loop
			rs3.Close
			if ivIndex = 0	then
				SQL="select hawb_num from invoice_queue where elt_account_number=" & t_elt_account_number _
				    & " and hawb_num=N'" & tvHAWB & "' and invoiced = 'Y' "
				
				
				rs3.CursorLocation = adUseClient
				rs3.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
				Set rs3.activeConnection = Nothing
				if Not rs3.EOF then
					invoiceNUM(ivIndex) = "(Unknown)"
					ivIndex = ivIndex + 1										
				end if
				rs3.Close
			end if
		end if
	IVstrMsg = ""
	if ivIndex > 0 then
		for iii = 0 to ivIndex - 1
			IVstrMsg = IVstrMsg	& invoiceNUM(iii) & ","
		next
		IVstrMsg = MID(IVstrMsg,1,LEN(IVstrMsg)-1)
	end if
End Sub		

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_DEFAULT_SALES_PERSON_FROM_DB
'Purpose  of the procedure: The procedure is in charge of getting a Default Sales person that will be 
'filled in the screen
'Tasks that are performed within:									    
'1.Retrieve the Default sales person for the organization
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

SUB GET_DEFAULT_SALES_PERSON_FROM_DB
	if isnull(vShipperAcct) or vShipperAcct = 0 then
		vSalesPerson ="" 
	else 
		SQL= "select SalesPerson from organization where elt_account_number = "& elt_account_number _
		    &" and org_account_number = "& vShipperAcct
		
		
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing
		if not rs.EOF then	
			vSalesPerson = rs("SalesPerson")
		else vSalesPerson ="" 
	end if   
	rs.close
	end if 
END SUB
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_SALES_PERSONS_FROM_USERS
'Purpose  of the procedure: The procedure is in charge of retrieving the list of salse persons to be 
'used.
'Tasks that are performed within:									    
'1.retrieve sales person from DB
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB GET_SALES_PERSONS_FROM_USERS
    SQL= "select code from all_code where elt_account_number = " & elt_account_number _
        & " and type=22 order by code"
    
    
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
END SUB 

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
   
    <title>Air Export</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <base target="_self" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
   <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
    <script src="/Scripts/modernizr-2.5.3.js"></script>
    <script type="text/jscript" language="javascript" src="../include/WebDateSetJN.js"></script>

    <script type="text/jscript" src="/ASP/ajaxFunctions/ajax.js"></script>
    <script type="text/jscript" src="../Include/iMoonCombo.js"></script>
 <script type="text/jscript" src="../Include/scripts/showModalDialog.js"></script>
    <script type="text/jscript">

    <% If Request.QueryString("READ").Item = "Y" Then %>
    
    function disablePage()
    {
        alert("This for is read-noly!: ");
        return false;
    }
    
    document.onkeypress = disablePage;
    document.onmousedown = disablePage;

    <% End If %>

    function viewRecent(){}

   
    
    function docModified(arg){}

    function validateSalesRep(){

        var txtSalesRep=document.getElementById("txtSalesRep");
        var salesRep=txtSalesRep.value;
        if(salesRep!=""){       
            return true;
        }
        else{
            // txtSalesRep.focus();
            return false;
        }
    }

    function checkMaxRows(txtObj){
	    var nomoretext=false;
	    var str = txtObj.value;
	    var allowedRows =txtObj.getAttribute("rows");
	    var allowedCols =txtObj.getAttribute("cols");
	    var lines = str.split("\r\n");
    	
	    if (lines.length > allowedRows)
	    {
		    if(window.event.keyCode != 8 && (window.event.keyCode <37 || window.event.keyCode >40))
		    {
			    alert("Can't add more line!")
			    nomoretext = true;
			    txtObj.value = "";
			    for(var i=0;i<allowedRows;i++)
			    {
				    if(i == allowedRows-1)
				    {
					    txtObj.value = txtObj.value + lines[i];
				    }
				    else
				    {
					    txtObj.value = txtObj.value + lines[i] + "\n";
				    }
			    }
		    }
	    }
	    return !nomoretext;
    }

    var ComboBoxes =  new Array('lstMAWB','lstM_HAWB');

    function MM_findObj(n, d) { //v4.01
      var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
        d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
      if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
      for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
      if(!x && d.getElementById) x=d.getElementById(n); return x;
    }

    function MM_showHideLayers() { //v6.0
      var i,p,v,obj,args=MM_showHideLayers.arguments;
      for (i=0; i<(args.length-2); i+=3) if ((obj=MM_findObj(args[i]))!=null) { v=args[i+2];
        if (obj.style) { obj=obj.style; v=(v=='show')?'visible':(v=='hide')?'hidden':v; }
        obj.visibility=v; }
    }

    var state = 'none';

    function showhide(layer_ref) {

        if (state == 'block') {
        state = 'none';
        }
        else {
        state = 'block';
        }
        if (document.all) {
        eval( "document.all." + layer_ref + ".style.display = state");
        }
        if (document.getElementById &&!document.all) {
        hza = document.getElementById(layer_ref);
        hza.style.display = state;
        }
    }
   //ADDef by stanley Limit Fumction
    function checkLimit(obj, limit,limit2) // was javascript
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

    // name changed from "checkDecimalTextMax_ChargeItem" 
    function checkDecimalTextMax_ChargeItem(obj,limit) // was javascript
    {
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

    function GetOtherCurrency(thisObj,objID){
        var vCountry = document.getElementById(objID).value;
        var vURL = "/ASP/site_admin/select_currency.asp?code=" + thisObj.value + "&ccode=" + vCountry;
        var vWinArg = "dialogWidth:370px; dialogHeight:280px; help:no; status:no; scroll:no; center:yes";
        
        var vReturn = showModalDialog(vURL, "popWindow", vWinArg);
        if (vReturn){
            thisObj.value = vReturn;
        }
    }
    
    function SetCostItems(){
        var vURL = "./new_edit_hawb_cost_items.asp?HAWB=" + encodeURIComponent(document.getElementById("txtHAWB").value);
        var vWinArg = "dialogWidth:600px; dialogHeight:400px; help:no; status:no; scroll:yes; center:yes";
        var vReturn = showModalDialog(vURL, "popWindow", vWinArg);
    }
    
    function SetCreditNote(){
        if(document.getElementById("txtHAWB").value==""){
            alert("House Airway Bill No. is required!");
            return;
        }

        var vWinArg = "dialogWidth:600px; dialogHeight:400px; help:no; status:no; scroll:yes; center:yes";
        var vReturn = showModalDialog("/ASP/acct_tasks/credit_note_list.asp?TYPE=A&MAWB=" + document.getElementById("lstMAWB").value+ "&HAWB=" + document.getElementById("txtHAWB").value, "popWindow", vWinArg);
        var url="";
        if(vReturn >= 0){
            //try {parent.document.frames['topFrame'].changeTopModule("Accounting");}catch(err){}
            if(vReturn == 0){
                url = 
                "/ASP/acct_tasks/edit_credit_note.asp?" 
                + 
                    "new=yes&MoveType=AIR&MasterOnly=N&InvType=Agent&AgentID=" 
                    + document.getElementById("hFFAgentAcct").value 
                    + "&MAWB=" 
                    + document.getElementById("lstMAWB").value
                    + "&HAWB=" 
                    + document.getElementById("txtHAWB").value
                ;
            }
            else{
                url= 
                "/ASP/acct_tasks/edit_credit_note.asp?" 
                +"edit=yes&InvoiceNo=" + vReturn
                ;
            }
            viewPop(url);
        }
    }
    function EditClick(HAWB,MAWB){
        url ="/IFF_MAIN/ASPX/Misc/EditAES.aspx?AESID=&HAWB="+encodeURIComponent(HAWB)+"&MAWB="+encodeURIComponent(MAWB) + "&WindowName=popUpWindow";
        openWindowFromSearch(url);
    }

    function openWindowFromSearch(url){
        window.open(url, "popUpWindow", "menubar=0,toolbar=0,hotkeys=1,status=1,location=0,scrollbars=1,resizable=1,width=900,height=600");
    }
    </script>
    <script type="text/javascript">
        var charageable_weight_in_KG=0;
        var charageable_weight_in_LB=0;

        var gross_weight_in_KG=0;
        var gross_weight_in_LB=0;

        var ajust_weight_in_KG=0;
        var ajust_weight_in_LB=0;

        var dim_weight_in_KG=0;
        var dim_weight_in_LB=0;


        var rate_in_kg=0;
        var rate_in_lb=0;

        var current_scale;


        function ResetChargeableWeightInMem(){
            
            var Scale = $("#lstKgLb").val();
            
            current_scale=Scale;
            
            var CW = $('input.ChargeableWeight').val();           
            var GW = $('input.GrossWeight').val();      
            var AW = $('input.AdjustedWeight').val();
           
            var DW = $('input.Dimension').val();
            var Rate= $('input.RateCharge').val();
          
            if(CW!=undefined&&CW!=""&&CW!="0"){
           
                CW=parseFloat(CW);
                GW=parseFloat(GW);
                AW=parseFloat(AW);
                DW=parseFloat(DW);
             
                if (Scale=="K") {
                    charageable_weight_in_KG=CW;
                    charageable_weight_in_LB = Math.round(CW * 2.20462262);

                    gross_weight_in_KG=GW;
                    gross_weight_in_LB = Math.round(GW * 2.20462262);

                    
                    ajust_weight_in_KG=AW;
                    ajust_weight_in_LB = Math.round(AW * 2.20462262);
                   
                    dim_weight_in_KG=DW;
                    dim_weight_in_LB = Math.round(DW * 2.20462262);

                    if (Rate != "N/A")rate_in_kg=Rate;
                    rate_in_lb = Math.round(Rate * 2.20462262);


                }
                else{
                    charageable_weight_in_LB= CW;
                    charageable_weight_in_KG = Math.round(CW / 2.20462262);

                    gross_weight_in_LB=GW;
                    gross_weight_in_KG = Math.round(GW / 2.20462262);

               
                    ajust_weight_in_LB=AW;
                    ajust_weight_in_KG = Math.round(AW /2.20462262);
                    
                    dim_weight_in_LB=DW;
                    dim_weight_in_KG = Math.round(DW / 2.20462262);

                    
                    if (Rate != "N/A")rate_in_lb=Rate;
                    rate_in_kg = Math.round(Rate / 2.20462262);
                }

                
            }

        }

       

    var sindex,AgentName;

        var flag;
        flag = false;
        var memGW, memCW, memAW, memDW;
        function ScaleChange(ItemNo) { //converted from vbscript
            var Scale = $("#lstKgLb").val();
            var CW = $('input.ChargeableWeight').val();       

            if(Scale=="K"&&current_scale=="L"){
                //alert(current_scale);
                current_scale=Scale;
                if(CW==charageable_weight_in_LB){
                    //Get all from saved
	               
                }else{
                    //Reset
                    ResetChargeableWeightInMem();
                }

                $('input.GrossWeight').val(gross_weight_in_KG);
                $('input.ChargeableWeight').val(charageable_weight_in_KG);
                $('input.AdjustedWeight').val(ajust_weight_in_KG);
                $('input.Dimension').val(dim_weight_in_KG);
                $('input.RateCharge').val(rate_in_kg);

            }else{

                if(Scale=="L"&&current_scale=="K"){
                    alert(current_scale);
                    current_scale=Scale;
                    if(CW==charageable_weight_in_KG){
                        //Get all from saved
                    }else{
                        //Reset
                        ResetChargeableWeightInMem();
                    }
                    $('input.GrossWeight').val(gross_weight_in_LB);
                    $('input.ChargeableWeight').val(charageable_weight_in_LB);
                    $('input.AdjustedWeight').val(ajust_weight_in_LB);
                    $('input.Dimension').val(dim_weight_in_LB);
                    $('input.RateCharge').val(rate_in_lb);
                }
            }
            
	        $('input.TotalCharge').val(0);

    	    checkDecimalTextMax_ChargeItem($('input.GrossWeight').get(0), 8);
    	    checkDecimalTextMax_ChargeItem($('input.ChargeableWeight').get(0), 8);
    	    checkDecimalTextMax_ChargeItem($('input.AdjustedWeight').get(0), 8);
    	    checkDecimalTextMax_ChargeItem($('input.Dimension').get(0), 8);
    	}
    	function isNumber(n) { // added new
    	    return !isNaN(parseFloat(n)) && isFinite(n);
    	}
    	var cChanged = new Array();
    	function cChange(ButtonNum) {
    	  
    	    cChanged(ButtonNum) = true;
    	}
    	function WCAdd(ButtonNum) {  //converted from vbscript
    	    var Dem, pos, pos1, DD, D1, D2, D3, D4, TotalDem, TemDem, NoPiece, nPiece, Scale, Factor, i;
    	    TotalDem = $("input.Dimension").get(ButtonNum - 1).value;
    	    if (TotalDem == "")
    	        TotalDem = 0;
    	    TotalCharge = $("input.TotalCharge").get(ButtonNum - 1).value;
    	    RateCharge = $("input.RateCharge").get(ButtonNum - 1).value;

    	    if (RateCharge == "N/A")
    	        RateCharge = 0;

    	    $("input.RateCharge").get(ButtonNum - 1).value = RateCharge

    	    if (!cChanged[ButtonNum - 1]) // changed from [ButtonNum-1] 12/30/2013
    	    {
    	        $("input.ChargeableWeight").get(ButtonNum - 1).value = "";
    	        ChargeableWeight = 0;
    	    }
    	    else
    	        ChargeableWeight = $("input.ChargeableWeight").get(ButtonNum - 1).value;

    	    if (ButtonNum <= 3) {
    	        NoItem = parseInt(document.frmHAWB.hNoItemWC.value);
    	        Pieces = $("input.Pieces").get(ButtonNum - 1).value;
    	        if (Pieces == "")
    	            Pieces = 0;

    	        GrossWeight = $("input.GrossWeight").get(ButtonNum - 1).value;
    	        AdjustedWeight = $("input.AdjustedWeight").get(ButtonNum - 1).value;
    	        if (AdjustedWeight == "")
    	            $("input.AdjustedWeight").get(ButtonNum - 1).value = GrossWeight;

    	        if (GrossWeight == "")
    	            GrossWeight = 0;

    	        RateClass = $("input.RateClass").get(ButtonNum - 1).value;
    	        if (!isNumber(Pieces))
    	            alert("Please enter a numeric value for PIECES");
    	        else if (!isNumber(GrossWeight))
    	            alert("Please enter a numeric value for Gross Weight");
    	        else if (!TotalCharge == "" && !isNumber(TotalCharge))
    	            alert("Please enter a numeric value for TOTAL CHARGE!");
    	        else if (!RateCharge == "" && !isNumber(RateCharge)) {
    	            if (toUpperCase(RateCharge) != "MIN")
    	                alert("Please enter a numeric value for Charge Rate");
    	        }
    	        else if (GrossWeight == 0)
    	            alert("Please enter the GROSS WEIGHT!");
    	        //else if ((parseFloat(TotalPieces) > 0) && (parseFloat(TotalPieces)!= parseFloat(Pieces)))
    	        //    alert("No of Pieces doesn't match!");
    	        // commented out since TotalPieces not defined.  
    	        else {
    	            if (Math.round(GrossWeight) > Math.round(TotalDem))
    	                TotalDem = GrossWeight;

    	            if ((ChargeableWeight == "" || ChargeableWeight == 0)
                                && (!cChanged[ButtonNum - 1])) // changed from (ButtonNum-1) 12/30/2013
    	                ChargeableWeight = TotalDem;

    	            if (!RateCharge == "") {
    	                if (RateCharge > 0) {
    	                    TotalCharge = RateCharge * ChargeableWeight;
    	                    TotalCharge = Math.round(TotalCharge * 100) / 100;
    	                }
    	            }

    	            $("input.ChargeableWeight").get(ButtonNum - 1).value = ChargeableWeight;
    	            $("input.TotalCharge").get(ButtonNum - 1).value = TotalCharge;
    	            Pieces = 0;
    	            GrossWeight = 0;
    	            TotalCharge = 0;
    	            for (var i = 0; i < NoItem; i++) {
    	                Pieces = Pieces + $("input.Pieces").get(i).value;
    	                GrossWeight = GrossWeight + $("input.GrossWeight").get(i).value;
    	                if ($("input.TotalCharge").get(i).value != "")
    	                    TotalCharge = TotalCharge + $("input.TotalCharge").get(i).value;
    	            }
    	            document.frmHAWB.txtTotalPieces.value = Pieces;
    	            document.frmHAWB.txtTotalGrossWeight.value = GrossWeight;
    	            document.frmHAWB.txtTotalWeightCharge.value = TotalCharge;
    	            if ((ButtonNum - (NoItem + 1) == 0) && (NoItem < 3)) {
    	                document.frmHAWB.hNoItemWC.value = NoItem + 1;
    	                document.frmHAWB.action = "new_edit_hawb.asp?AddWC=yes&focus=tblWeightCharge"
                                + "&tNo=" + "<%=TranNo%>"
                                + "&WindowName=" + window.name;
    	                document.frmHAWB.method = "POST";
    	                document.frmHAWB.target = window.name;
    	                alert("Please, save the House AWB after updating.");
    	                frmHAWB.submit();
    	            }
    	            else {
    	                document.frmHAWB.action = "new_edit_hawb.asp?AddWC=yes&focus=tblWeightCharge"
                                + "&tNo=" + "<%=TranNo%>" + "&WindowName=" + window.name;
    	                document.frmHAWB.method = "POST";
    	                document.frmHAWB.target = window.name;
    	                alert("Please, save the House AWB after updating.");
    	                frmHAWB.submit();
    	            }
    	        }
    	    }
    	    else
    	        alert("Can't add more than 3 weights!");


    	}

    	function PrefixChange() {  //converted from vbscript
    	    sindex = document.frmHAWB.lstHAWBPrefix.selectedIndex;
    	    Prefix = document.frmHAWB.lstHAWBPrefix.item(sindex).text;
    	}
        //////////////////////////////////
        // Unit_Price by ig 10/21/2006
        //////////////////////////////////
        function GET_ITEM_UNIT_PRICE ( tmpBuf ){ // converted from vbscript
            var ItemUnitPrice,pos

            ItemUnitPrice=0

            pos=tmpBuf.indexOf("-")
            if (pos>0)
	            ItemUnitPrice=tmpBuf.substring(pos+1,201);

            return ItemUnitPrice;
        }
        //////////////////////////////////
    function isNull(what){return what==null}    // added new
    function CHECK_IV_STATUS(tvHAWB) {  //converted from vbscript
        if (tvHAWB == "" || tvHAWB == "0")
	        return true;
        var IVstrMSG = "<%=IVstrMsg%>";
        if(IVstrMSG != ""){
	        return (confirm("Invoice No. "+ IVstrMSG + " for HAWB#:" + tvHAWB + " was processed already. \r\nDo you want to continue?")) ;
        }
        return true;
   }



   function ChargeItemChange(index, sindex) { // converted from vbscript
            //sindex = $("select.ChargeItem>option").get(index + 1).index;
       ItemInfo = $("select.ChargeItem>option").get(sindex).value;
            pos = ItemInfo.indexOf("-");
            if (pos > 0)
                ItemDesc = ItemInfo.substring(pos + 1, 201);

            var ItemUnitPrice = GET_ITEM_UNIT_PRICE(ItemDesc);

            pos = ItemDesc.indexOf("-");
            if (pos > 0)
                ItemDesc = ItemDesc.substring(0, pos);

            if (sindex > 0) { //(index+1)
                $("input.ItemDesc").get(index).value = ItemDesc.replace(/^\s+/, "");
                $("input.ChargeAmt").get(index).value = parseFloat(ItemUnitPrice).toFixed(2);
            }
            else //(index+1)
                $("input.ItemDesc").get(index).value = "";
        }


   function AddOC() {  //converted from vbscript
         
	        NoItem=parseInt(document.frmHAWB.hNoItemOC.value);
	        if (NoItem >= 10)
	            alert("Can't have more than 10 Charge Items!");
	        else {
	            document.frmHAWB.hNoItemOC.value = NoItem + 1;
	            document.frmHAWB.action = "new_edit_hawb.asp?AddOC=yes&focus=tblOtherCharge" 
                        + "&tNo=" + "<%=TranNo%>" + "&WindowName=" + window.name;
	            document.frmHAWB.method = "POST";
	            document.frmHAWB.target = window.name;
	            frmHAWB.submit();
	        }
        }

        var tempTranNo;
        /////////////////////////////
        function SaveNewHAWB(NewNum){ 
           
            if (NewNum.copyOption == "RemoveMasterhouse"){
                document.getElementById("hCheckSH").value = "N";
                document.getElementById("hmawb_num").value = "";
            }
            if (NewNum.hawbNum != "") {
                document.frmHAWB.hHAWBPrefix.value = "";
                document.frmHAWB.action = "new_edit_hawb.asp?save=yes&New=yes&HAWB=" + encodeURIComponent(NewNum.hawbNum) + "&tNo=" + "<%=TranNo%>" + "&WindowName=" + window.name;
                document.frmHAWB.method = "post";
                document.frmHAWB.target = "_self";
                frmHAWB.submit();
            }} 
    function bsaveClick(TranNo, SaveAsNew)  //converted from vbscript
    /////////////////////////////
        {
        var i, is_copied;
        
        // added by Joon on 10-15-2007 new save as options
        if( SaveAsNew == "yes" && document.getElementById("lstM_HAWB_Text").value != "" )
            is_copied = "yes";
        else
            is_copied = "no";
        
        var To0=document.frmHAWB.txtTo.value;
        var To1=document.frmHAWB.txtTo1.value;
        var To2=document.frmHAWB.txtTo2.value;
        if (To0.length>3 || To1.length >3 || To2.length >3 ){
	        alert( "The To Port has three characters!");
	        return false;
        }
        //////////////////////////////
        var SHIndex = "<%=SHIndex%>";
        if ( "<%=vCheckMH%>" == "Y" ){
            if (SHIndex="")
                document.frmHAWB.hSubCount.value = 0;
            else
                document.frmHAWB.hSubCount.value = parseInt(SHIndex);
        }

        WC = document.frmHAWB.hNoItemWC.value;
        if (WC!="")
	        WC=parseInt(WC);
        else
	        WC=0;

	    OC = document.frmHAWB.hNoItemOC.value;
   
        if (OC!="" )
	        OC=parseInt(OC);
        else
	        OC=0;

	    var HAWB_NUM = document.frmHAWB.txtHAWB.value;

	    if (SaveAsNew != "yes") {
	        ////////////////////////////////////////	
	        if (!CHECK_IV_STATUS(HAWB_NUM))
	            return false;
	        ////////////////////////////////////////
	        if (HAWB_NUM == "" || HAWB_NUM == "0")
	            SaveAsNew = "yes";
	    }

        pos=0;
        pos=HAWB_NUM.indexOf("-");
        if (pos>0)
	        HAWB_NUM=HAWB_NUM.substring(pos+1,21);
        pos=0
        pos=HAWB_NUM.indexOf("-");
        if (pos>0)
	        HAWB_NUM=HAWB_NUM.substring(HAWB_NUM,pos+1,21);

        if (document.frmHAWB.lstFFAgent.value == "" ){
	        if (document.frmHAWB.hCheckMH.value!="Y"){
		        alert( "Please select an agent!");
		        return false;
	        }
        }
        else{
	        for (var i=0 ; i< WC; i++){
		        if (! isNumber($("input.Pieces").get(i).value) ){
			        alert( "Please enter a Numeric Value for PIECEs!");
			        return false;
                    }
		        else if (!isNumber($("input.GrossWeight").get(i).value)) {
			        alert( "Please enter a Numeric Value for GROSS WEIGHT!");
			        return false;}
		        else if (!isNumber($("input.AdjustedWeight").get(i).value)) {
			        alert( "Please enter a Numeric Value for ADJUSTED WEIGHT!");
			        return false;}
		        else if (!isNumber($("input.ChargeableWeight").get(i).value)) {
			        alert( "Please enter a Numeric Value for CHARGEABLE WEIGHT!");
			        return false;}
		        else if (!isNumber($("input.Dimension").get(i).value)) {
			        alert( "Please enter a Numeric Value for DIMENSIONAL WEIGHT!");
			        return false;}
		        else if ($("input.RateCharge").get(i).value!="" && !isNumber($("input.RateCharge").get(i).value)) {
			        if ($("input.RateCharge").get(i).value="N/A"  )
                        $("input.RateCharge").get(i).value=0;
			        else{
				            alert ("Please enter a Numeric Value for RATE/CHARGE!");
				            return false;
                        }
                }
		        else if ($("input.TotalCharge").get(i).value!="" && !isNumber($("input.TotalCharge").get(i).value) ){
			        alert ("Please enter a Numeric Value for TOTAL CHARGE!");
			        return false;
		        }
			    //Scale = $("input.KgLb").get(i).value;
		        //if (Scale != $("input.KgLb").get(1).value) {
		        //    alert("UOM mismatch!");
		        //    return false;
		        //}
	        }
        	
	        for(var i=0; i< OC;i++){
		        var oItem=$("select.ChargeItem").get(i).value;
		        var oAmt=$("input.ChargeAmt").get(i).value;
		        if (isNull(oAmt) || oAmt == "")
                    oAmt = 0;
		        if (!isNumber(oAmt))
			    {
                    alert( "Please enter a Numeric Value for CHARGE AMT!");
			        return false;
                }
		        if (oAmt!=0 && oItem=="0-Select One" ){
		            alert("Please select an item!");
			        return false;
		        }
	        }
	        if ( document.frmHAWB.txtPrepaidValuationCharge.value!="" && 
                     !isNumber(document.frmHAWB.txtPrepaidValuationCharge.value) ){
		        alert( "Please enter a Numeric Value for VALUATION CHARGE!");
                return false;
	        }
	        if (document.frmHAWB.txtCollectValuationCharge.value != "" &&
                    !isNumber(document.frmHAWB.txtCollectValuationCharge.value)) {
	            alert("Please enter a Numeric Value for VALUATION CHARGE!");
	            return false;
	        }
	        if (document.frmHAWB.txtPrepaidTax.value!="" && !isNumber(document.frmHAWB.txtPrepaidTax.value) ) {
		        alert("Please enter a Numeric Value for TAX!");
                return false;
	        }
	        if (document.frmHAWB.txtCollectTax.value!="" && !isNumber(document.frmHAWB.txtCollectTax.value) ) {
		        alert("Please enter a Numeric Value for TAX!");
                return false;
	        }
	        if (document.frmHAWB.txtConversionRate.value!="" && !isNumber(document.frmHAWB.txtConversionRate.value) ) {
		        alert("Please enter a Numeric Value for CONVERSION RATE!");
                return false;
	        }
	        if (document.frmHAWB.txtCCCharge.value!="" && !isNumber(document.frmHAWB.txtCCCharge.value) ) {
		        alert("Please enter a Numeric Value for CC CHARGE!");
                return false;
	        }
	        if (document.frmHAWB.txtChargeDestination.value!="" && !isNumber(document.frmHAWB.txtChargeDestination.value) ) {
		        alert("Please enter a Numeric Value for DESTINATION CHARGE!");
                return false;
	        }
        		
            var NewHAWB=document.frmHAWB.hNewHAWB.value;
            var HAWBPrefix=document.frmHAWB.hHAWBPrefix.value;

            if (HAWBPrefix == "") {
                HAWBPrefix = document.frmHAWB.lstHAWBPrefix.item(0).text;
                document.frmHAWB.hHAWBPrefix.value = HAWBPrefix;
            }

            if (SaveAsNew == "yes") {
                sindex = document.frmHAWB.lstHAWBPrefix.selectedIndex;
                HAWBPrefix = document.frmHAWB.lstHAWBPrefix.item(sindex).text;
                NEXTPrefix = document.frmHAWB.lstHAWBPrefix.item(sindex).value;
                var salesPerson = "<%=vSalesPerson %>";
                tmpUrl = "new_edit_hawb_OK.asp?SaveAsNew=yes&prefix=" + encodeURIComponent(HAWBPrefix) + "&NEXTPREFIX="
                + encodeURIComponent(NEXTPrefix) + "&salesPerson=" + encodeURIComponent(salesPerson) + "&IsCopied="
                + is_copied;
                //hawb_Dialog.asp?new_edit_hawb_OK.asp?SaveAsNew=yes&prefix=CLA&NEXTPREFIX=3208141&salesPerson=undefined&IsCopied=no
                //new_edit_hawb_OK.asp?SaveAsNew=yes&prefix=CLA&NEXTPREFIX=3208137&salesPerson=&IsCopied=no
                var url = "hawb_Dialog.asp?" + tmpUrl;
                var NewNum = new Object();
                var sharedObject = new Object();
                if ($.browser.chrome || $.browser.safari) {
                    ModalHandle.CallBack=SaveNewHAWB;                   
                    showModalDialogJN(encodeURI(url), "popWindow", "dialogWidth:400px; dialogHeight:170px; help:no; status:no; scroll:no;center:yes", ModalHandle);
                    
                }else{
                    NewNum = showModalDialog(encodeURI(url), "popWindow", "dialogWidth:400px; dialogHeight:170px; help:no; status:no; scroll:no;center:yes");
                    SaveNewHAWB(NewNum);
                }
                            
            }
            else {
                if (HAWB_NUM.trim() != "")
                    NewHAWB == HAWB_NUM; // This logic will be processed ( Click Save -> Refresh -> Click Save )

                document.frmHAWB.action = "new_edit_hawb.asp?save=yes&New=" + encodeURIComponent(NewHAWB)
		            + "&tNo=" + TranNo + "&WindowName=" + window.name;
                document.frmHAWB.method = "POST";
                document.frmHAWB.target = window.name;
                frmHAWB.submit();
            }
        }
    }
  


    function AfterSave(NewNum) {  //added new
        
        if (NewNum.copyOption == "RemoveMasterhouse") {
        	document.getElementById("hCheckSH").value = "N";
        	document.getElementById("hmawb_num").value = "";
        }
        		        
        if(NewNum.hawbNum != ""){
        	document.frmHAWB.hHAWBPrefix.value = "";
        	document.frmHAWB.action = "new_edit_hawb.asp?save=yes&New=yes&HAWB=" + encodeURIComponent(NewNum.hawbNum)
        		+ "&tNo=" + tempTranNo + "&WindowName=" + window.name;
        	document.frmHAWB.method = "post";
        	document.frmHAWB.target = window.name;
        	frmHAWB.submit();
        }
 }

 /////////////////////////////
 function lookup()  //converted from vbscript
    /////////////////////////////
    {
        HAWB=document.frmHAWB.txtqHAWB.value.toUpperCase();
        document.frmHAWB.txtqHAWB.value = "";
        if ( HAWB != "" && HAWB != "Search Here")
	        document.frmHAWB.hNewHAWB.value = "";
        else{
	        alert( "Please enter a House AWB No!");
	        return;
        }

        HAWB=HAWB.replace(" ","");
        document.frmHAWB.action = "new_edit_hawb.asp?Edit=yes&hawb=" + encodeURIComponent(HAWB) + "&tNo=" + "<%=TranNo%>" + "&WindowName=" + window.name;
        document.frmHAWB.method = "POST";
        document.frmHAWB.target = window.name;
        frmHAWB.submit();
    }


    function CreateMasterHouse() {  //converted from vbscript
	    document.frmHAWB.hCheckMH.value="Y"	;
	    bsaveClick ("<%= TranNo %>","no" );
	}

     function lstMAWBChange() // converted from vbscript
     {
         var sIndex, mInfo, pos;
        var mDepartureAirportCode,mDepartureAirport, mTo, mBy, mTo1, mBy1, mTo2, mBy2,mDestAirport;
        var mFlightDate1,mFlightDate2,IssuedBy,mServiceLevel;

        sIndex = document.frmHAWB.lstMAWB.selectedIndex;

        if (sIndex == 0 )
            return;
        
        
	    if ($("select[id='lstMAWB']>option").get(sIndex).value != "" )
		    CHECK_INVOICE_STATUS_AJAX ("MAWB" , $("select[id='lstMAWB']>option").get(sIndex).value);

	    if (sIndex >= 0) {
            document.frmHAWB.hmawb_num.value = document.frmHAWB.lstMAWB.item(sIndex).text;
    		

		    if (document.frmHAWB.hmawb_num.value.toLowerCase() == "select one" )
		        document.frmHAWB.hmawb_num.value = "";

		    $.get("http://rateman.e-logitech.net/api/waybill/mawb_booking_info?mawb="+document.frmHAWB.lstMAWB.item(sIndex).text+"&elt_account_number="+"<%=elt_account_number%>",function(data){
		        AccountInfo=document.frmHAWB.txtBillToInfo.value;
		        console.log(data);
		        document.frmHAWB.hAirOrgNum.value=data.mOrgNum;
		        document.frmHAWB.hOriginPortID.value=data.mDepartureAirportCode;
		        document.frmHAWB.txtDepartureAirport.value=data.mDepartureAirport;
		        document.frmHAWB.txtTo.value=data.mTo;
		        document.frmHAWB.txtBy.value=data.mBy;
		        document.frmHAWB.txtTo1.value=data.mTo1;
		        document.frmHAWB.txtBy1.value=data.mBy1;
		        document.frmHAWB.txtTo2.value=data.mTo2;
		        document.frmHAWB.txtBy2.value=data.mBy2;
		        document.frmHAWB.txtDestAirport.value=data.mDestAirport;
		        document.frmHAWB.txtFlightDate1.value=data.mFlightDate1;
		        document.frmHAWB.txtFlightDate2.value=data.mFlightDate2;
          
		        document.frmHAWB.hExportDate.value=data.mExportDate;
		        document.frmHAWB.txtDestCountry.value=data.mDestCountry;
		        document.frmHAWB.hDepartureState.value=data.mDepartureState;
		        document.frmHAWB.hfDestArrCode.value = data.mTo2;

		        if( document.frmHAWB.hfDestArrCode.value == "" )
		            document.frmHAWB.hfDestArrCode.value = data.mTo1;

		        if( document.frmHAWB.hfDestArrCode.value  == "" )
		            document.frmHAWB.hfDestArrCode.value = data.mTo;

		       // mServiceLevel
		        // msgbox(document.frmHAWB.hfDestArrCode.value)

		        IssuedBy=document.frmHAWB.txtIssuedBy.value;
		        pos=IssuedBy.indexOf('\n');
		        if (pos>0 )
		            IssuedBy=IssuedBy.substring(0,pos);

		        if (IssuedBy.substring(0, 10) == "AS AGENT OF")
		            IssuedBy = "AS AGENT OF " + data.mCarrierDesc;
		        else
		            IssuedBy = IssuedBy + '\n' + "AS AGENT OF " + data.mCarrierDesc;


		        document.frmHAWB.txtIssuedBy.value = IssuedBy;
		        vExecute = document.frmHAWB.hExecution.value;

		        document.frmHAWB.txtExecute.value = IssuedBy + '\n' + vExecute;
		    })
		   // alert("<%=elt_account_number%>");

//			mInfo = get_mawb_booking_info(document.frmHAWB.lstMAWB.item(sIndex).text);
//console.log(mInfo);
//	        //   & chr(10) &  & chr(10) &  & chr(10) &  & chr(10) &  & chr(10) &  & chr(10) &  & chr(10) &  & chr(10) &  & chr(10) &  & chr(10) &  & chr(10) & mServiceLevel & chr(10)
//		    pos = mInfo.indexOf('\n');
//mAirOrgNum = mInfo.substring(0, pos);//mOrgNum
//--alert(mCarrierDesc);
//		    mInfo = mInfo.substring(pos + 1, 1000);
//		    pos = mInfo.indexOf('\n');
//		    mDepartureAirportCode = mInfo.substring(0, pos);//mDepartureAirportCode

//            mInfo = mInfo.substring(pos + 1, 1000);
//            pos = mInfo.indexOf('\n');
//            mDepartureAirport = mInfo.substring(0, pos);//mDepartureAirport

//            mInfo = mInfo.substring(pos + 1, 1000);
//            pos = mInfo.indexOf('\n');
//            mTo = mInfo.substring(0, pos);//mTo

//            mInfo = mInfo.substring(pos + 1, 1000);
//            pos = mInfo.indexOf('\n');
//            mBy = mInfo.substring(0, pos);//mBy

//            mInfo = mInfo.substring(pos + 1, 1000);
//            pos = mInfo.indexOf('\n');
//            mTo1 = mInfo.substring(0, pos);//mTo1

//            mInfo = mInfo.substring(pos + 1, 1000);
//            pos = mInfo.indexOf('\n');
//            mBy1 = mInfo.substring(0, pos);//mBy1

//            mInfo = mInfo.substring(pos + 1, 1000);
//            pos = mInfo.indexOf('\n');
//            mTo2 = mInfo.substring(0, pos );//mTo2

//            mInfo = mInfo.substring(pos + 1, 1000);
//            pos = mInfo.indexOf('\n');
//            mBy2 = mInfo.substring(0, pos );//mBy2

//            mInfo = mInfo.substring(pos + 1, 1000);
//            pos = mInfo.indexOf('\n');
//            mDestAirport = mInfo.substring(0, pos );//mDestAirport

//            mInfo = mInfo.substring(pos + 1, 1000);
//            pos = mInfo.indexOf('\n');
//            mFlightDate1 = mInfo.substring(0, pos );//mFlightDate1

//            mInfo = mInfo.substring(pos + 1, 1000);
//            pos = mInfo.indexOf('\n');
//            mFlightDate2 = mInfo.substring(0, pos );//mFlightDate2

//            mInfo = mInfo.substring(pos + 1, 1000);
//            pos = mInfo.indexOf('\n');
//            mCarrierDesc = mInfo.substring(0, pos );//mCarrierDesc
            
//            mInfo = mInfo.substring(pos + 1, 1000);
//            pos = mInfo.indexOf('\n');
//            mExportDate = mInfo.substring(0, pos );//mExportDate

//            mInfo = mInfo.substring(pos + 1, 1000);
//            pos = mInfo.indexOf('\n');
//            mDestCountry = mInfo.substring(0, pos );//mDestCountry

//            mInfo = mInfo.substring(pos + 1, 1000);
//            pos = mInfo.indexOf('\n');
//            mDepartureState = mInfo.substring(0, pos );//mDepartureState

//            mInfo = mInfo.substring(pos + 1, 1000);
//            pos = mInfo.indexOf('\n');
//            mFile = mInfo.substring(pos + 1, 1000);//mFile

//	        // Modified by Joon 6/20/2007 service level
//            mInfo = mInfo.substring(pos + 1, 1000);           
//            pos = mInfo.indexOf('\n');
//            mServiceLevel = mInfo.substring(0, pos );

           
////	        //////////////////////////////////////////////
            
        }

    }


    function MAWBEditClick(a) {  //converted from vbscript
        var sindex = document.frmHAWB.lstMAWB.selectedIndex;
        if (sindex>0) {
            var MAWB_NUM = document.frmHAWB.lstMAWB.item(sindex).text;

            //window.location.href = "new_edit_mawb.asp?WindowName=<%=WindowName %>&edit=yes&mawb=" + encodeURIComponent(MAWB_NUM) + "&tNo=<%=TranNo%>";

            window.top.location.href = "/AirExport/MAWB/WindowName=<%=WindowName %>&edit=yes&mawb=" + encodeURIComponent(MAWB_NUM) + "&tNo=<%=TranNo%>";
        }
    }

    function DiscardMasterHouse() {  //converted from vbscript
	    document.frmHAWB.hCheckMH.value="N";
	    document.frmHAWB.hDiscardMH.value="Y";
	    //msgbox document.frmHAWB.hCheckMH.Value
	    bsaveClick("<%= TranNo %>", "no");
    }
    function COLOClick() { 
        if (document.frmHAWB.cCOLO.checked=false)
	        document.frmHAWB.lstCOLOPay.style.visibility="hidden";
        else
	        document.frmHAWB.lstCOLOPay.style.visibility="visible";

    }

    
    function Desc2KeyUp(){ // converted from vbscript
        var Info=document.frmHAWB.txtDesc2.value;
        var MyArray =Info.split('\n');
        var dd=MyArray.length - 1;
        if (dd>13){
	        alert( "Please go to Other Description session to continue!");
	        Info="";
	        for (var i=0; i<=13; i++){
		        Info=Info + MyArray[i];
	        }
	        document.frmHAWB.txtDesc2.value=Info;
	        document.frmHAWB.txtDesc1.focus();
        }
        Info="";
        for (var i=0 ; i<= dd; i++){
	        Info=Info + MyArray[i];
        }
        if (Info.length > 260) {
            Info = Info.substring(0, 261);
            document.frmHAWB.txtDesc2.value = Info;
            document.frmHAWB.txtDesc1.focus();
        }
    }

    function cPPO2Click(){
        if (document.frmHAWB.cPPO2.checked==false) {
            document.frmHAWB.cPPO2.value = "";
            document.frmHAWB.cCOLL2.checked = true;
            document.frmHAWB.cCOLL2.value = "Y";
            }
        else{
            document.frmHAWB.cPPO2.value = "Y";
            document.frmHAWB.cCOLL2.checked = false;
            document.frmHAWB.cCOLL2.value = "";
	    }
    }
    function cCOLL2Click(){
        if ( document.frmHAWB.cCOLL2.checked==false) {
	        document.frmHAWB.cCOLL2.value = "";
	        document.frmHAWB.cPPO2.checked=true;
	        document.frmHAWB.cPPO2.value="Y";
           }
        else{
	        document.frmHAWB.cCOLL2.value = "Y";
	        document.frmHAWB.cPPO2.checked=false;
	        document.frmHAWB.cPPO2.value="";
        }
     }
    function cPPO1Click(){
        if ( document.frmHAWB.cPPO1.checked==false) {
	        document.frmHAWB.cPPO1.value = "";
	        document.frmHAWB.cCOLL1.checked=true;
	        document.frmHAWB.cCOLL1.value="Y";
           }
        else{
	        document.frmHAWB.cPPO1.value="Y";
	        document.frmHAWB.cCOLL1.checked=false;
	        document.frmHAWB.cCOLL1.value="";
        }
     }
    function cCOLL1Click(){
        if ( document.frmHAWB.cCOLL1.checked==false) {
	        document.frmHAWB.cCOLL1.value = "";
	        document.frmHAWB.cPPO1.checked=true;
	        document.frmHAWB.cPPO1.value="Y";
           }
        else{
	        document.frmHAWB.cCOLL1.value="Y";
	        document.frmHAWB.cPPO1.checked=false;
	        document.frmHAWB.cPPO1.value = "";
	    }
     }
     function DeleteWC(ItemNo){
        if( document.frmHAWB.hNoItemWC.value>0
                && parseInt(document.frmHAWB.hNoItemWC.value) != ItemNo)
        {
	        if (confirm ("Do you really want to delete this Weight Charge? \r\nPlease click Yes to continue."))
            {
		        document.frmHAWB.action="new_edit_hawb.asp?DeleteWC=yes&dItemNo="+ ItemNo+ "&focus=tblWeightCharge"+ "&tNo="+ "<%=TranNo%>" +"&WindowName=" + window.name ;
		        document.frmHAWB.method="POST";
		        document.frmHAWB.target="_self";
		        frmHAWB.submit();
                }
	    }
    }


    function DeleteOC(ItemNo){
        if (document.frmHAWB.hNoItemOC.value > 0 && parseInt(document.frmHAWB.hNoItemOC.value) != ItemNo) {
            if (confirm("Do you really want to delete this Other Charge? \r\nPlease click Yes to continue."))
            {
		        document.frmHAWB.action="new_edit_hawb.asp?DeleteOC=yes&dItemNo=" + ItemNo + "&focus=tblOtherCharge" + "&tNo=" + "<%=TranNo%>" + "&WindowName=" + window.name ;
		        document.frmHAWB.method="POST";
		        document.frmHAWB.target=window.name;
		        frmHAWB.submit();
	        }
        }
    }
    </script>
    <!--vbscript-->
    <script type="text/vbscript">
  

'    Sub MAWBEditClick()
'        sindex=document.frmHAWB.lstMAWB.selectedIndex
'        if sindex>0 then
'	        MAWB_NUM=document.frmHAWB.lstMAWB.item(sindex).Text
'	        window.location.href = "new_edit_mawb.asp?WindowName=<%=WindowName %>&edit=yes&mawb=" & encodeURIComponent(MAWB_NUM) & "&tNo=<%=TranNo%>" 
'        end if
'    End Sub

    Sub bAddDemClick()
        Dim D1,D2,D3,D4,DD
        D1=document.frmHAWB.txtQty.Value
        D2=document.frmHAWB.txtLength.Value
        D3=document.frmHAWB.txtWidth.Value
        D4=document.frmHAWB.txtHeight.Value
        If IsNumeric(D1)=false Or IsNumeric(D2)=false Or IsNumeric(D3)=false Or IsNumeric(D4)=false then
	        msgbox "Please enter numerical values only!"
        Else
	        DD=D1 & "@" & D2 & "X" & D3 & "X" & D4 & Chr(10)
        	
	        document.frmHAWB.txtDemDetail.Value=document.frmHAWB.txtDemDetail.Value & DD
        	
	        document.frmHAWB.txtQty.Value=""
	        document.frmHAWB.txtLength.Value=""
	        document.frmHAWB.txtWidth.Value=""
	        document.frmHAWB.txtHeight.Value=""
        End If
    End Sub

    </script>
<script type="text/javascript">

    //'///////////////////////////////////////////////////
    

    
    function AddToMaster(addSUB,addELTAcct) {  //converted from vbscript
	    document.frmHAWB.action="new_edit_hawb.asp?focus=tblSubHouses&addSUB=yes&Edit=yes&addSUBNo=" 
	        + encodeURIComponent(addSUB) & "&addELTAcct=" +addELTAcct & "&hawb=" 
	        + encodeURIComponent("<%=vHAWB%>") + "&MAWB="+ encodeURIComponent("<%=vMAWB%>") 
	        + "&tNo=" +"<%=TranNo%>" + "&WindowName=" + window.name 
	    document.frmHAWB.method="POST";
	    document.frmHAWB.target ="_self";
	    frmHAWB.submit();
	}
    function DeleteHAWB(){
        var HAWB=document.frmHAWB.txtHAWB.value;

        if (HAWB  != "" ){
	        if (confirm ("Do you really want to delete HAWB " + HAWB + "? \r\nPlease click Yes to continue.")){
		        ////////////////////////////////////////	
		        if (!CHECK_IV_STATUS( HAWB ) )
                    return;
		        ////////////////////////////////////////
                document.frmHAWB.action = "new_edit_hawb.asp?DeleteHAWB=yes&HAWB=" + encodeURIComponent(HAWB) + "&tNo=" + "<%=TranNo%>" + "&WindowName=" + window.name;
                document.frmHAWB.method = "POST";
                document.frmHAWB.target = window.name;
                frmHAWB.submit();
	        }
        }
    }

    </script>
<script type="text/vbscript">


    
    

   

   
    Sub MenuMouseOver()
      document.frmHAWB.lstHAWBPrefix.style.visibility="hidden"
      document.frmHAWB.lstColoder.style.visibility="hidden"
    End Sub

    Sub MenuMouseOut()
      document.frmHAWB.lstHAWBPrefix.style.visibility="visible"
      document.frmHAWB.lstColoder.style.visibility="visible"
    End Sub

    </script>

    <script type="text/javascript" src="../include/JPED.js"></script>

    <script type="text/javascript">
       
     function DimCalClick(ItemNum) {

         var props = "scrollBars=no,resizable=yes,toolbar=no,menubar=no,location=no,directories=no,width=350,height=280";
         var url = "dimcal.asp?ItemNum=" + ItemNum;
         //iframe-dimcal
//         $("#dialog-dimcal").dialog({
//             height: 320,
//             width:400,
//             modal: true,
//             autoOpen: false,
//            close: function(event, ui) { $(this).dialog('close') },
//             open: function (ev, ui) {
//                
//                 $('#iframe-dimcal').attr('src', url);
//                 $('#iframe-dimcal').attr('width', '400');
//                 $('#iframe-dimcal').attr('height', '320');
//             }
//         });
//         $('#dialog-dimcal').dialog('open');
         window.open("dimcal.asp?ItemNum=" + ItemNum, "Dimension_Calculation", props);
    
    }

    function showtip(){}

    function setChargeableWeight(index){
        
	    var id1="txtGrossWeight"+index;
	    var id2="txtDimension"+index;
	    var id3="txtChargeableWeight"+index;

	    var gross = document.getElementsByName(id1).item(0).value;
	    var dimension = document.getElementsByName(id2).item(0).value;
	    if(gross==""){
		    gross="0";
	    }
	    if(dimension==""){
		    dimension="0";
	    }	
	    gross=parseFloat(gross);
	    dimension=parseFloat(dimension);
    	
	    if(gross > dimension){
	        document.getElementsByName(id3).item(0).value = gross;
	    }else{
	        document.getElementsByName(id3).item(0).value = dimension;
	    }
    }
    
    function setAdjustedWeight(index){
        var id1="txtGrossWeight"+index;
	    var id2="txtAdjustedWeight"+index;
	    var goss = document.getElementsByName(id1).item(0).value;

	    document.getElementsByName(id2).item(0).value = goss;
    }
    
// Start of list change effect //////////////////////////////////////////////////////////////////

    
    function lstFFAgentChange(orgNum,orgName)
    {
        var hiddenObj = document.getElementById("hFFAgentAcct");
        var txtObj = document.getElementById("lstFFAgent");
        var divObj = document.getElementById("lstFFAgentDiv");
        var infoObj = document.getElementById("hFFAgentInfo");

        hiddenObj.value = orgNum;
        txtObj.value = orgName;
        infoObj.value = getOrganizationInfo(orgNum);

        divObj.style.position = "absolute";
        divObj.style.marginTop = "20px";
        divObj.style.visibility = "hidden";
        divObj.style.height = "0px";
	    docModified(1);
    }
    
    function lstShipperNameChange(orgNum,orgName)
    {
        var hiddenObj = document.getElementById("hShipperAcct");
        var infoObj = document.getElementById("txtShipperInfo");
        var txtObj = document.getElementById("lstShipperName");
        var divObj = document.getElementById("lstShipperNameDiv")

        hiddenObj.value = orgNum;
        infoObj.value = getOrganizationInfo(orgNum);
        txtObj.value = orgName;
        
        document.getElementsByName("txtSignature").value = "AS AGENT FOR " + orgName;
        
        divObj.style.position = "absolute";
        divObj.style.visibility = "hidden";
        divObj.style.height = "0px";
	    docModified(1);
    }
    
    function lstConsigneeNameChange(orgNum,orgName)
    {
        var hiddenObj = document.getElementById("hConsigneeAcct");
        var infoObj = document.getElementById("txtConsigneeInfo");
        var txtObj = document.getElementById("lstConsigneeName");
        var divObj = document.getElementById("lstConsigneeNameDiv");

        hiddenObj.value = orgNum;
        infoObj.value = getOrganizationInfo(orgNum);
        txtObj.value = orgName;
        divObj.style.position = "absolute";
        divObj.style.visibility = "hidden";
        divObj.style.height = "0px";
	    docModified(1);
	    lstNotifyNameChange(orgNum,orgName);
    }
    
    function lstNotifyNameChange(orgNum,orgName)
    {
        var hiddenObj = document.getElementById("hNotifyAcct");
        var infoObj = document.getElementById("txtBillToInfo");
        var txtObj = document.getElementById("lstNotifyName");
        var divObj = document.getElementById("lstNotifyNameDiv")

        hiddenObj.value = orgNum;
        infoObj.value = getOrganizationInfo(orgNum);
        txtObj.value = orgName;
        divObj.style.visibility = "hidden";
        divObj.style.position = "absolute";
        divObj.style.height = "0px";
	    docModified(1);
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

        var url = "/ASP/ajaxFunctions/ajax_get_org_address_info.asp?type=B&org=" + orgNum;
    
        xmlHTTP.open("GET",url,false); 
        xmlHTTP.send(); 
        
        return (xmlHTTP.responseText); 
    }
    
    </script>

    <style type="text/css">
    <!--
    body {
	    margin-left: 0px;
	    margin-right: 0px;
	    margin-bottom: 0px;
    }
    .style6 {color: #663366}
    .style8 {
	    color: #CC3333;
	    font-weight: bold;
	    font-size: 10px;
	    font-family: Verdana, Arial, Helvetica, sans-serif;
    }
    .style11 {color: #CC9900}
    .style12 {color: #0099FF}
    .style14 {color: #CC0000}
    #Layer1 {
	    position:absolute;
	    width:705px;
	    height:115px;
	    z-index:101;
	    visibility: hidden;
    }
    .center-container {
  position: relative;
}
    .center
    {
        margin: auto;
      position: absolute;
      top: auto; left: 0; bottom: 0; right: 0;
    }
    -->
    </style>
</head>
<body link="336699" vlink="336699" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"
    onload="self.focus(); scrollToObj('<%=Request.QueryString.Item("focus") %>');">
    <form method="post" name="frmHAWB">
         
        <input type="image" style="position: absolute; visibility: hidden" onclick="return false;" />
        <input type="hidden" id="hSONum" name="hSONum" value="<%=vSONum %>" />
        <input type="hidden" id="hPONum" name="hPONum" value="<%=vPONum %>" />
        <!-- tooltip placeholder -->
        <div id="tooltipcontent">
        </div>
        <div id="dialog-hawb" name="dialoghawb" style="display:none; " class="center">
            <iframe id="modalFrame" src=""></iframe>
        </div>
        <!-- placeholder ends -->
        <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
            <tr>
                <td height="32" colspan="4" align="left" valign="middle" class="pageheader">
                    NEW/EDIT HOUSE AIR WAYBILL (HAWB)</td>
                <td width="55%" colspan="5" align="right" valign="middle">
                    <span class="bodyheader style6">HOUSE AWB NO.</span>
                    <% if mode_begin then %>
                    <div style="width: 21px; display: inline; vertical-align: middle" onmouseover="showtip('Use this field to find previously entered HAWBs. Enter the number including prefix and the dash and click the magnifying glass button.');"
                        onmouseout="hidetip()">
                        <img src="../Images/button_info.gif" align="absmiddle" class="bodylistheader"></div>
                    <% end if %>
                    <input name="txtqHAWB" class="lookup" value="Search Here" onkeydown="javascript: if(event.keyCode == 13) { lookup(); return false;}"
                        onclick="javascript: this.value = ''; this.style.color='#000000'; " size="22"
                        tabindex="-1"><img src="../images/icon_search.gif" name="B1" width="33" height="27"
                            align="absmiddle" style="cursor: hand" onclick="lookup()"></td>
            </tr>
        </table>
        <div class="selectarea">
            <table width="95%" height="40" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                    <td width="45%">
                    </td>
                    <td width="55%" align="right" valign="bottom">
                        <% If vHAWB <> "" Then %>
                        <div id="print">
                            <a href="javascript:;" onclick="SetCostItems(); return false;" tabindex="-1">Cost Items</a>
                            <img src="/ASP/Images/button_devider.gif" alt="" />
                            <a href="javascript:;" onclick="SetCreditNote(); return false;" tabindex="-1">Credit Note</a>
                            <img src="/ASP/Images/button_devider.gif" alt="" />

                            


                            <a href="javascript:EditClick('<%=vHAWB %>','<%=vMAWB %>');" tabindex="-1">
                                <img src="/ASP/Images/icon_createhouse.gif" alt="Click here to create SED"
                                    width="25" height="26" style="margin-right: 10px" />Create AES</a>
                            <img src="/ASP/Images/button_devider.gif" alt="" />
                            <a href="javascript:void(0);" id="NewPrintVeiw1" tabindex="-1">
                                <img src="/ASP/Images/icon_printer_preview.gif" align="absbottom" alt="" />House
                                Air Waybill</a>
                        </div>
                        <% End If %>
                    </td>
                </tr>
            </table>
        </div>
        <input id="hCurrentIndex" type="hidden" />
        <!-- start of scroll bar -->
        <input type="hidden" name="scrollPositionX" id="scrollPositionX">
        <input type="hidden" name="scrollPositionY" id="scrollPositionY">
        <!-- end of scroll bar -->
        <input type="hidden" id="hCheckSH" name="hCheckSH" id="hCheckSH" value="<%= vCheckSH %>">
        <input type="hidden" name="hCheckMH"  id="hCheckMH" value="<%= vCheckMH %>">
        <input type="hidden" name="hDiscardMH" id="hDiscardMH">
        <input type="hidden" name="hSubCount" id="hSubCount">
        <input type="hidden" name="hMaster_Gross_Weight"  id="hMaster_Gross_Weight" value="<%= vectGrossWeightTotal2 %>">
        <input type="hidden" name="hMaster_Chargeable_Weight" id="hMaster_Chargeable_Weight" value="<%= vectChargeableWeightTotal2 %>">
        <input type="hidden" name="hMaster_Pieces" id="hMaster_Pieces" value="<%= vectPieceTotal2 %>">
        <input type="hidden" name="hIs_invoice_queued"  id="hIs_invoice_queued" value="<%= is_invoice_queued %>">
        <input type="hidden" name="hHAWBPrefix" id="hHAWBPrefix" value="<%= vHAWBPrefix %>">
        <input type="hidden" name="hNewHAWB"" id="hNewHAWB" value="<%= NewHAWB %>">
        <input type="hidden" id="hmawb_num" name="hmawb_num" value="<%= vMAWB %>">
        <input id="hAirOrgNum" name="hAirOrgNum"  type="hidden" value="<%= vAirOrgNum %>">
        <input name="hOriginPortID" id="hOriginPortID" type="hidden" value="<%= vOriginPortID %>">
        <input type="hidden" name="hFFAgentInfo" id="hFFAgentInfo"  value="<%= vFFAgentInfo %>">
        <input type="hidden" name="hNoItemWC" id="hNoItemWC" value="<%= wIndex %>">
        <input type="hidden" name="hNoItemOC" id="hNoItemOC" value="<%= oIndex %>">
        <input type="hidden" name="hExecution" id="hExecution" value="<%= vExecutionDatePlace %>">
        <input type="hidden" name="hExportDate"  id="hExportDate" value="<%= vExportDate %>">
        <input type="hidden" name="hDepartureState" id="hDepartureState" value="<%= vDepartureState %>">
        <input type="hidden" name="hPickupNumber" id="hPickupNumber" value="">
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#A0829C" 
            class="border1px">
            <tr>
                <td height="24" colspan="2" align="left" valign="middle" bgcolor="E5D4E3" class="bodycopy">
                    <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="26%">
                                &nbsp;
                            </td>
                            <td width="48%" align="center" valign="middle">
                                <img src="../images/button_save_medium.gif" id="bSaveBottom" name="bSave" width="43" height="18" onclick="if('<%=vCheckSH%>'=='Y'){CheckIfMasterHasSameMAWB();}else{bsaveClick('<%= TranNo %>','no')}"
                                    style="cursor: hand"></td>
                            <td width="13%" align="right" valign="middle">
                                <a href="/ASP/air_export/new_edit_hawb.asp" tabindex="-1">
                                    <img src="/ASP/Images/button_new.gif" width="42" height="17" border="0"
                                        style="cursor: hand"></a></td>
                            <td width="13%" align="right" valign="middle">
                                <img src="../images/button_delete_medium.gif" width="51" height="17" name="bDeleteHAWB"
                                    onclick="DeleteHAWB()" style="cursor: hand"></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td width="92%" height="1" bgcolor="A0829C" colspan="2">
                </td>
            </tr>
            <tr>
                <td bgcolor="#f3f3f3" colspan="2">
                    <br>
                    <table width="60%" border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                            <td height="28" align="right">
                                <span class="bodyheader">
                                    <img src="/ASP/Images/required.gif" align="absbottom">Required field</span></td>
                        </tr>
                    </table>
                    <table width="60%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#A0829C"
                        bgcolor="#FFFFFF" class="border1px">
                        <tr bgcolor="#f0e7ef">
                            <td>
                                &nbsp;
                            </td>
                            <td height="20" bgcolor="#f0e7ef">
                                <font color="c16b42"><strong>House AWB No.</strong></font></td>
                            <td>
                                &nbsp;
                            </td>
                            <td>
                                &nbsp;
                            </td>
                        </tr>
                        <tr bgcolor="#ffffff">
                            <td>
                                &nbsp;
                            </td>
                            <td height="24">
                                <select name="lstHAWBPrefix" size="1" class="bodyheader" onchange="PrefixChange()">
                                    <% For i=0 To pIndex-1 %>
                                    <option value="<%= aNextHAWB(i) %>" <% if vhawbprefix=ahawbprefix(i) then response.write("selected") %>>
                                        <%= aHAWBPrefix(i) %>
                                    </option>
                                    <%  Next  %>
                                </select>
                                <input name="txtHAWB" id="txtHAWB" class="readonlybold" value="<%= vHAWB %>" size="22" readonly="readonly"
                                    tabindex="-1"></td>
                            <td>
                                &nbsp;
                            </td>
                            <td>
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" height="1" bgcolor="#A0829C">
                            </td>
                        </tr>
                        <tr bgcolor="#f3f3f3">
                            <td width="1%">
                                &nbsp;
                            </td>
                            <td width="40%">
                                <span class="bodyheader">
                                    <img src="/ASP/Images/required.gif" align="absbottom">Agent</span></td>
                            <td width="19%">
                                &nbsp;
                            </td>
                            <td width="40%">
                                <span class="bodyheader">Master AWB No.</span>
                                <% if mode_begin then %>
                                <div style="width: 21px; display: inline; vertical-align: middle" onmouseover="showtip('Select a MAWB to consolidate this HAWB to.  This is optional.  Consolidation may be done later through the MAWB screen.')"
                                    onmouseout="hidetip()">
                                    <img src="../Images/button_info.gif" align="bottom" class="bodylistheader"></div>
                                <% end if %>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &nbsp;
                            </td>
                            <td colspan="2" valign="top">
                                <!-- Start JPED -->
                                <input type="hidden" id="hFFAgentAcct" name="hFFAgentAcct" value="<%=vFFAgentAcct %>" />
                                <div id="lstFFAgentDiv">
                                </div>
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td>
                                            <input type="text" autocomplete="off" id="lstFFAgent" name="lstFFAgent" value="<%=vFFAgentName %>"
                                                class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
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
                                <!-- End JPED -->
                            </td>
                            <td valign="top">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <td>
                                    </td>
                                    <tr>
                                        <td>
                                            <!-- //Start of Combobox// -->
                                            <%  iMoonDefaultValue = vMAWB %>
                                            <%  iMoonComboBoxName =  "lstMAWB" %>
                                            <%  iMoonComboBoxWidth =  "140px" %>
                                  
                                            <script type="text/javascript"> 
                                                function <%=iMoonComboBoxName%>_OnChangePlus(){  
	                                                lstMAWBChange(); 
                                                }
                                            </script>
                                            
                                            <div id="<%=iMoonComboBoxName%>_Container" class="ComboBox" style="width: <%=iMoonComboBoxWidth%>;
                                                position: ; top: ; left: ; z-index: ;">
                                                <span class="ComboBox" style="width: <%=iMoonComboBoxWidth%>; position: ; top: ;
                                                    left: ; z-index: ;">
                                                    <input width="140" name="<%=iMoonComboBoxName%>:Text" type="text" id="<%=iMoonComboBoxName%>_Text"
                                                        <%if vcheckmh="Y" then response.write("class='shorttextfield' ")else response.write("class='combobox' ") %>
                                                        autocomplete="off" 
                                                        style="ertical-align: middle;height:14px;
                                                        <% if iscoloaded then response.write("background-color:#cccccc") end if %>" 
                                                        <% if iscoloaded then response.write("readonly") end if%>
                                                        value="<%=iMoonDefaultValue%>" />
                                                </span>
                                                <div id="<%=iMoonComboBoxName%>_Div" style="display: none; position: absolute; top: 0;
                                                    left: 0; width: 17px">
                                                    <% if not IsColoaded  then response.Write("<img id='"&iMoonComboBoxName&"_Button' src='/ig_common/Images/combobox_drop.gif' border='0' />")end if %>
                                                </div>
                                            </div>
                                            <div id="<%=iMoonComboBoxName%>_NewDiv" style="display: none; position: absolute;
                                                top: 0; left: 0; width: 17px">
                                                <img id="<%=iMoonComboBoxName%>_AddNewButton" src="/ig_common/Images/combobox_addnew.gif"
                                                    border="0"></div>
                                            <!-- /End of Combobox/ -->
                                            <select name="lstMAWB" id="lstMAWB" listsize="20" class="ComboBox" style="width: 140px;
                                                display: none" onchange="ComboBox_SimpleAttach(this, this.form['<%=iMoonComboBoxName%>_Text'])">
                                                <% For i=0 To UBound(aMAWB) %>
                                                <option value="<%= aMAWB(i) %>" <% if vmawb=amawb(i) and vmawb <> "" then response.write("selected") %>>
                                                    <%= aMAWB(i) %>
                                                </option>
                                                <%  Next  %>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="32">
                                            <span class="goto"><a href="javascript:;" onclick="MAWBEditClick(); return false;">
                                                <img src="/ASP/Images/icon_goto.gif" align="absbottom" />Go to MAWB</a></span></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>

                    <br>
                    <table width="60%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#A0829C"
                        bgcolor="#f3f3f3" class="border1px">
                        <tr bgcolor="#f3f3f3">
                            <td width="1%">
                                &nbsp;
                            </td>
                            <td width="40%" height="20" valign="middle" class="bodyheader">
                                <% 
				  if vCheckMH = "Y"  then
				  	response.Write("MASTER HOUSE") 
				  else 
				  	
				  end if
                                %>
                                <span <% if vchecksh="Y" then response.write("style='display:none'")  %>class="goto">
                                    <a href="javascript:;" <% if vcheckmh="Y" then response.write(" onclick='DiscardMasterHouse();return false'") else response.write(" onclick='if (setshipperwithaccountholder()){ CreateMasterHouse()}; return false'") %>>
                                        <% if vCheckMH="Y" then response.Write("Revert to Regular House") else response.Write("Save as Master House") %>
                                    </a></span>
                            </td>
                            <td width="59%" height="20" colspan="2">
                                <span <% if vchecksh="Y" then response.write("style='display:none'")  %>class="goto">
                                    <a href="javascript:;" <% if vcheckmh="Y" then response.write(" onclick='DiscardMasterHouse();return false'") else response.write(" onclick='if (setshipperwithaccountholder()){ CreateMasterHouse()}; return false'") %>>
                                    </a></span>
                                <div style="width: 21px; display: inline; vertical-align: middle" onmouseover="showtip('Clicking this will turn this House into a Master House.  Other house bills can then be added to this bill as Sub-Houses.  Consolidation to a MAWB will be done by the Master house.')"
                                    onmouseout="hidetip()">
                                    <span <% if vchecksh="Y" then response.write("style='display:none'")  %>class="goto">
                                        <a href="javascript:;" <% if vcheckmh="Y" then response.write(" onclick='DiscardMasterHouse();return false'") else response.write(" onclick='if (setshipperwithaccountholder()){ CreateMasterHouse()}; return false'") %>>
                                        </a></span>
                                </div>
                            </td>
                        </tr>
                        <tr bgcolor="#f3f3f3">
                            <td bgcolor="#f3f3f3">
                                &nbsp;
                            </td>
                            <td height="32" valign="middle" id="td_mhlink" style="<% if vm_hawb <>"" then response.write("") else response.write("display:none")  end if %>">
                                <span class="goto"><a href="javascript:;" onclick="goToMasterHouse()">
                                    <img src="/ASP/Images/icon_goto.gif" align="absbottom">Go to Master House
                                    <%response.Write(vM_HAWB)%>
                                </a></span>
                            </td>
                            <td height="20" bgcolor="#f3f3f3">
                                &nbsp;
                            </td>
                        </tr>
                        <tr bgcolor="#ffffff" style="height:30px">
                            <td>
                                &nbsp;
                            </td>
                            <td valign="middle" class="bodyheader">
                                <strong class="bodyheader">
                                    <input type="checkbox" name="cCOLO" id="cCOLO" value="Y" <% if vcolo="Y" then response.write("checked") %>
                                        onclick="COLOClick()">
                                    COLOAD</strong>
                                <div style="width: 21px; display: inline; vertical-align: middle" onmouseover="showtip('Click to make this a Coload.')"
                                    onmouseout="hidetip()">
                                    <% if mode_begin then %>
                                    <img src="../Images/button_info.gif" align="texttop" class="bodylistheader"></div>
                                <% end if %>
                                <strong class="bodyheader">
                                    <img src="/ASP/Images/spacer.gif" width="3" height="10">
                                    <select name="lstCOLOPay" size="1" class="smallselect" style="width: 98px; visibility: <% if Not vCOLO="Y" then response.write("hidden") %>">
                                        <option value="P">COLO Prepaid</option>
                                        <option value="C" <% if vcolopay="c" then response.write("selected") %>>COLO Collect</option>
                                    </select>
                                    <input id="txtMAWB" class="shorttextfield" name="txtMAWB" size="16" type="hidden"
                                        value="<%= vMAWB %>" />
                                </strong>
                                <div style="width: 21px; display: inline; vertical-align: middle" onmouseover="showtip('Select the company you wish to coload with.  This list is configured in the C/P Profile screen.')"
                                    onmouseout="hidetip()">
                                    <strong class="bodyheader"></strong>
                                </div>
                            </td>
                            <td colspan="2" valign="middle">
                                <span class="bodyheader">COLOADER
                                    <select name="lstColoder" class="smallselect" style="width: 220px;">
                                        <% for i=0 to coIndex-1 %>
                                        <option value="<%= aColoderAcct(i) %>" <% if vcoloderacct=acoloderacct(i) then response.write("selected") %>>
                                            <%= aColoderName(i) %>
                                        </option>
                                        <% next %>
                                    </select>
                                </span>
                                <div style="width: 21px; display: inline; vertical-align: middle" onmouseover="showtip('Select the company you wish to coload with.  This list is configured in the C/P Profile screen.')"
                                    onmouseout="hidetip()">
                                    <span class="bodyheader">
                                        <% if mode_begin then %>
                                        <img src="../Images/button_info.gif" align="top" class="bodylistheader"></span></div>
                                <% end if %>
                                <span class="bodyheader">
                                    <input type="checkbox" name="cAutoSave" id="cAutoSave" value="Y" <% if autosave="Y" then response.write("checked") %>
                                        style="visibility: hidden">
                                </span><span class="bodyheader"></span>
                            </td>
                        </tr>
                    </table>

                    <br>
                </td>
            </tr>
            <tr>
                <td colspan="2" height="2" bgcolor="A0829C">
                </td>
            </tr>
            <tr>
                <td width="50%" align="left" valign="top">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="bodycopy" style="padding-left: 10px">
                        <tr class="bodyheader">
                            <td width="70%" height="20" bgcolor="#f0e7ef">
                                Shipper's Name and Address</td>
                            <td width="30%" bgcolor="#f0e7ef">
                                Shipper's Account No</td>
                        </tr>
                        <tr>
                            <td>
                                <!-- Start JPED -->
                                <input type="hidden" id="hShipperAcct" name="hShipperAcct" value="<%=vShipperAcct %>" />
                                <div id="lstShipperNameDiv">
                                </div>
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td>
                                            <input type="text" autocomplete="off" id="lstShipperName" name="lstShipperName" value="<%=vShipperName %>"
                                                class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Shipper','lstShipperNameChange',null,event)"
                                                onfocus="initializeJPEDField(this,event);" /></td>
                                        <td>
                                            <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstShipperName','Shipper','lstShipperNameChange',null,event)"
                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                        <td>

                                            <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                onclick="quickAddClient('hShipperAcct','lstShipperName','txtShipperInfo')" /></td>
                                    </tr>
                                </table>
                                <textarea id="txtShipperInfo" name="txtShipperInfo" class="monotextarea" cols=""
                                    rows="5" style="width: 300px"><%=vShipperInfo %></textarea>
                                <!-- End JPED -->
                            </td>
                            <td valign="top">
                                <input name="txtShipperAcct" id="txtShipperAcct" class="shorttextfield" value="<%= vFFShipperAcct %>"
                                    size="20" maxlength="16"></td>
                        </tr>
                        <tr class="bodyheader" bgcolor="#f3f3f3">
                            <td height="18">
                                <strong>Consignee's Name and Address </strong>
                            </td>
                            <td valign="middle" bgcolor="#f3f3f3">
                                Consignee's Account No</td>
                        </tr>
                        <tr>
                            <td>
                                <!-- Start JPED -->
                                <input type="hidden" id="hConsigneeAcct" name="hConsigneeAcct" value="<%=vConsigneeAcct %>" />
                                <div id="lstConsigneeNameDiv">
                                </div>
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td>
                                            <input type="text" autocomplete="off" id="lstConsigneeName" name="lstConsigneeName"
                                                value="<%=vConsigneeName %>" class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9;
                                                border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;"
                                                onkeyup="organizationFill(this,'Consignee','lstConsigneeNameChange',null,event)" onfocus="initializeJPEDField(this,event);" /></td>
                                        <td>
                                            <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstConsigneeName','Consignee','lstConsigneeNameChange',null,event)"
                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                        <td>
                                            <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                onclick="quickAddClient('hConsigneeAcct','lstConsigneeName','txtConsigneeInfo')" /></td>
                                    </tr>
                                </table>
                                <textarea id="txtConsigneeInfo" name="txtConsigneeInfo" class="monotextarea" cols=""
                                    rows="5" style="width: 300px"><%=vConsigneeInfo %></textarea>
                                <!-- End JPED -->
                            </td>
                            <td valign="top">
                                <input name="txtConsigneeAcct" id="txtConsigneeAcct" class="shorttextfield" value="<%= vFFConsigneeAcct %>"
                                    size="20" maxlength="16"></td>
                        </tr>
                        <tr bgcolor="#f3f3f3" class="bodyheader">
                            <td height="18">
                                Issuing Carrier's Agent Name and City</td>
                            <td valign="middle" bgcolor="#f3f3f3">
                                &nbsp;</td>
                        </tr>
                        <tr>
                            <td height="18">
                                <textarea name="txtAgentInfo" cols="40" rows="3" wrap="hard" class="monotextarea"
                                    onkeypress="javascript:return checkMaxRows(this);"><%= vAgentInfo %></textarea></td>
                            <td valign="top">
                                &nbsp;</td>
                        </tr>
                        <tr>
                            <td height="18" colspan="2">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr class="bodyheader" bgcolor="#f3f3f3">
                                        <td width="50%" height="18" align="left" valign="middle">
                                            Agent's IATA Code</td>
                                        <td align="left" valign="middle">
                                            Account No.</td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <input name="txtAgentIATACode" id="txtAgentIATACode" class="shorttextfield" value="<%= vAgentIATACode %>"
                                                size="27" maxlength="17"></td>
                                        <td>
                                            <input name="txtAgentAcct" id="txtAgentAcct" class="shorttextfield" value="<%= vAgentAcct %>" size="17"
                                                maxlength="17"></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr class="bodyheader" bgcolor="#f3f3f3">
                            <td height="18" colspan="2">
                                Airport of Departure (Addr. of First Carrier) and Requested Routing</td>
                        </tr>
                        <tr>
                            <td height="18" colspan="2">
                                <input name="txtDepartureAirport" id="txtDepartureAirport" class="shorttextfield" value="<%= vDepartureAirport %>"
                                    size="27" maxlength="27"></td>
                        </tr>
                        <tr>
                            <td height="18" colspan="2">
                                <table width="100%" border="0" cellpadding="0" cellspacing="1" class="bodycopy">
                                    <tr align="left" valign="middle" bgcolor="#f0e7ef">
                                        <td height="13" bgcolor="#f0e7ef">
                                            &nbsp;</td>
                                        <td align="center" class="bodycopy">
                                            Routing and Destination</td>
                                        <td colspan="4">
                                            &nbsp;</td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="#f0e7ef">
                                        <td width="15%" height="24" bgcolor="#f0e7ef">
                                            &nbsp;<strong>To</strong></td>
                                        <td width="41%" bgcolor="#f0e7ef">
                                            &nbsp;<strong>By First Carrier</strong></td>
                                        <td width="11%">
                                            To</td>
                                        <td width="11%">
                                            By</td>
                                        <td width="11%">
                                            To</td>
                                        <td width="11%" bgcolor="#f0e7ef">
                                            By</td>
                                    </tr>
                                    <tr align="left" valign="middle">
                                        <td>
                                            <input class="m_shorttextfield"  maxlength="8" name="txtTo" id="txtTo" size="12" value="<%= vTo %>"></td>
                                        <td>
                                            <input name="txtBy" class="shorttextfield" value="<%= vBy %>" size="20" maxlength="20"></td>
                                        <td>
                                            <input name="txtTo1" class="shorttextfield" value="<%= vTo1 %>" size="8" maxlength="8"></td>
                                        <td>
                                            <input name="txtBy1" class="shorttextfield" value="<%= vBy1 %>" size="8" maxlength="8"></td>
                                        <td>
                                            <input name="txtTo2" class="shorttextfield" value="<%= vTo2 %>" size="8" maxlength="8"></td>
                                        <td>
                                            <input name="txtBy2" class="shorttextfield" value="<%= vBy2 %>" size="8" maxlength="8"></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <table width="100%" border="0" cellpadding="0" cellspacing="1" class="bodycopy">
                                    <tr align="left" valign="middle" bgcolor="#f0e7ef">
                                        <td height="13" bgcolor="#f0e7ef">
                                            &nbsp;</td>
                                        <td colspan="2" align="center" bgcolor="#f0e7ef">
                                            For Carrier Only</td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="#f0e7ef">
                                        <td height="20">
                                            <strong>Airport of Destination</strong></td>
                                        <td>
                                            &nbsp;<strong>Flight/Date</strong></td>
                                        <td>
                                            &nbsp;<strong>Flight/Date</strong></td>
                                    </tr>
                                    <tr align="left" valign="middle">
                                        <td>
                                            <input name="txtDestAirport" id="txtDestAirport" class="shorttextfield" value="<%= vDestAirport %>" size="24"
                                                maxlength="24">
												
												<input type="hidden" name="hfDestArrCode" id="hfDestArrCode" value="<%=vArrCode %>" />
												</td>
                                        <td>
                                            <input name="txtFlightDate1" id="txtFlightDate1" class="shorttextfield" value="<%= vFlightDate1 %>" size="17"
                                                maxlength="17"></td>
                                        <td>
                                            <input name="txtFlightDate2" id="txtFlightDate2"  class="shorttextfield" value="<%= vFlightDate2 %>" size="17"
                                                maxlength="17"></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
                <td width="50%" valign="top">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td height="20" bgcolor="#f0e7ef" class="bodycopy">
                                Not Negotiable</td>
                        </tr>
                        <tr>
                            <td style="padding-bottom: 5px">
                                <span class="pageheader"><font color="c16b42" size="2">Air Way Bill</font><br />
                                    <br />
                                </span><span class="bodyheader">Issued by</span><br>
                                <textarea name="txtIssuedBy" cols="30" rows="3" wrap="hard" class="monotextarea"
                                    onkeypress="javascript:return checkMaxRows(this);"><%= vIssuedBy %></textarea></td>
                        </tr>
                        <tr>
                            <td height="18" bgcolor="#f3f3f3">
                                <strong class="bodyheader">Accounting Information</strong></td>
                        </tr>
                        <tr>
                            <td style="padding-bottom: 105px">
                                <!-- Start JPED -->
                                <input type="hidden" id="hNotifyAcct" name="hNotifyAcct" value="<%=vNotifyAcct %>" />
                                <div id="lstNotifyNameDiv">
                                </div>
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td>
                                            <input type="text" autocomplete="off" id="lstNotifyName" name="lstNotifyName" value="<%= GetBusinessName(checkBlank(vNotifyAcct,0)) %>"
                                                class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Notify','lstNotifyNameChange',null,event)"
                                                onfocus="initializeJPEDField(this,event);" /></td>
                                        <td>
                                            <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstNotifyName','Notify','lstNotifyNameChange',null,event)"
                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                        <td>
                                           
                                            <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                onclick="quickAddClient('hNotifyAcct','lstNotifyName','txtBillToInfo')" /></td>
                                    </tr>
                                </table>
                                <textarea id="txtBillToInfo" name="txtBillToInfo" class="monotextarea" cols="" rows="5"
                                    style="width: 300px"><%=vAccountInfo %></textarea>
                                <!-- End JPED -->
                            </td>
                        </tr>
                        <tr>
                            <td height="18" bgcolor="#f3f3f3">
                                <span class="bodycopy"><strong>Reference Number</strong></span></td>
                        </tr>
                        <tr>
                            <td>
                                <input type="text" name="txtReferenceNumber" id="txtReferenceNumber" class="shorttextfield" maxlength="32"
                                    size="27" value="<%=checkBlank(vReferenceNumber,GetFileNumber(vMAWB))%>" /></td>
                        </tr>
                        <tr>
                            <td>
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td valign="top">
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1" class="bodycopy">
                                                <tr align="center" valign="middle">
                                                    <td height="13" bgcolor="#f0e7ef" class="bodycopy">
                                                        &nbsp;</td>
                                                    <td bgcolor="#f0e7ef">
                                                        &nbsp;</td>
                                                    <td colspan="2" bgcolor="#f0e7ef">
                                                        <strong>WT/VAL</strong></td>
                                                    <td colspan="2" bgcolor="#f0e7ef">
                                                        <strong>Other</strong></td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#f0e7ef">
                                                    <td>
                                                        Currency</td>
                                                    <td>
                                                        CHGS<br>
                                                        Code</td>
                                                    <td>
                                                        PPD</td>
                                                    <td>
                                                        COLL</td>
                                                    <td>
                                                        PPD</td>
                                                    <td>
                                                        COLL</td>
                                                </tr>
                                                <tr>
                                                    <td align="left" valign="middle">
                                                        <input name="txtCurrency" id="txtCurrency" type="text" class="shorttextfield" size="4" maxlength="3"
                                                            value="<%=vCurrency %>" onclick="GetOtherCurrency(this,'hCountryCode')" onkeydown="GetOtherCurrency(this,'hCountryCode')"
                                                            readonly="readonly" style="cursor: hand" />
                                                        <input type="hidden" id="hCountryCode" value="<%=AgentCountryCode %>" />
                                                    </td>
                                                    <td align="left" valign="middle">
                                                        <input name="txtChargeCode" id="txtChargeCode" class="shorttextfield" value="<%=vChargeCode %>" size="4"
                                                            maxlength="4"></td>
                                                    <td align="center" valign="middle">
                                                        <input name="cPPO1" id="cPPO1" type="checkbox" <% if vPPO_1="Y" then response.write("checked") %>
                                                            onclick="cPPO1Click()" value="<%= vPPO_1 %>"></td>
                                                    <td align="center" valign="middle">
                                                        <input type="checkbox" name="cCOLL1" id="cCOLL1" value="<%= vCOLL_1 %>" <% if vCOLL_1="Y" then response.write("checked") %>
                                                            onclick="cCOLL1Click()"></td>
                                                    <td align="center" valign="middle">
                                                        <input name="cPPO2" id="cPPO2" type="checkbox" <% if vPPO_2="Y" then response.write("checked") %>
                                                            value="Y" onclick="cPPO2Click()"></td>
                                                    <td align="center" valign="middle">
                                                        <input type="checkbox" name="cCOLL2" id="cCOLL2" value="Y" <% if vCOLL_2="Y" then response.write("checked") %>
                                                            onclick="cCOLL2Click()"></td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td valign="top">
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1" class="bodycopy">
                                                <tr align="left" valign="middle" bgcolor="#f0e7ef">
                                                    <td width="50%" height="20" class="bodycopy">
                                                        <strong>Declared Value for Carriage</strong></td>
                                                    <td width="50%" class="bodycopy">
                                                        <strong>Declared Value for Customs</strong></td>
                                                </tr>
                                                <tr align="left" valign="middle">
                                                    <td>
                                                        <input name="txtDeclaredValueCarriage" id="txtDeclaredValueCarriage"  maxlength="16" class="shorttextfield" value="<%=vDeclaredValueCarriage %>"
                                                            size="12"></td>
                                                    <td>
                                                        <input name="txtDeclaredValueCustoms" id="txtDeclaredValueCustoms" maxlength="16" class="shorttextfield" value="<%= vDeclaredValueCustoms %>"
                                                            size="12"></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td height="13">
                                        </td>
                                        <td width="75%">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td width="25%" height="18" bgcolor="#f3f3f3">
                                            <strong class="bodyheader">Amount of Insurance</strong></td>
                                        <td rowspan="2" valign="top">
                                            <span class="bodycopy">INSURANCE - If carrier offers insurance and such insurance is
                                                requested in accordance with conditions on reverse hereof indicate amount to be
                                                insured in figures in box marked Amount of insurance.</span></td>
                                    </tr>
                                    <tr>
                                        <td valign="middle">
                                            <input name="txtInsuranceAmt" id="txtInsuranceAmt" class="shorttextfield" value="<%= vInsuranceAMT %>"
                                                size="17" maxlength="17"></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr align="center" valign="middle">
                <td colspan="2" align="left" valign="top" bgcolor="#FFFFFF">
                    <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF"
                        style="padding-left: 10px" class="bodycopy">
                        <tr>
                            <td width="61%" height="18" align="left" valign="middle" bgcolor="#f3f3f3" class="bodycopy">
                                <strong>Handling Information </strong>
                            </td>
                            <td width="26%" bgcolor="#f3f3f3">
                                &nbsp;</td>
                            <td width="13%" bgcolor="#f3f3f3">
                                &nbsp;</td>
                        </tr>
                        <tr>
                            <td align="left" valign="middle">
                                <p>
                                    <textarea name="txtHandlingInfo" cols="70" rows="2" wrap="hard" class="monotextarea"><%= vHandlingInfo %></textarea>
                                </p>
                            </td>
                            <td>
                            </td>
                            <td align="left" valign="bottom">
                                <strong>SCI</strong></td>
                        </tr>
                        <tr>
                            <td align="left" valign="top">
                                These commodities, technology or software exported from
                                <%=GetAgentCountry() %>
                                in accordance
                                <br>
                                with the Export Administration Regulations.<strong> Ultimate destination
                                    <input name="txtDestCountry" id="txtDestCountry" class="shorttextfield" value="<%= vDestCountry %>" size="20">
                                </strong>
                            </td>
                            <td width="26%" align="right" valign="top" style="padding-right: 10px">
                                Diversion contrary to
                                <br>
                                U.S. law prohibited.</td>
                            <td width="13%" height="20">
                                <input name="txtSCI" id="txtSCI" maxlength="16" class="shorttextfield" value="<%= vSCI %>" size="14"></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <!-- Issuing Carrier's starts  -->
            <tr>
                <td>
                </td>
            </tr>
            <tr align="left" valign="middle">
                <td height="1" colspan="5" bgcolor="A0829C">
                </td>
            </tr>
        </table>
        <table id="tblWeightCharge" width="95%" border="0" align="center" cellpadding="0"
            cellspacing="0" bordercolor="#A0829C" bgcolor="#FFFFFF" class="border1px" style="padding-left: 10px">
            <tr align="left" valign="middle" bgcolor="E5D4E3">
                <td height="22" colspan="15">
                    <strong><font color="c16b42">WEIGHT CHARGE</font> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="checkbox" value="Y" name="cShowWeightChargeShipper" id="cShowWeightChargeShipper" <% if vshowweightchargeshipper="Y" then response.write("checked") %>>
                    </strong>Show Shipper
                    <% if mode_begin then %>
                    <div style="width: 21px; display: inline; vertical-align: middle""" onmouseover="showtip('Checking this will show the Charges due the Shipper when you print the bill.  If uncheck, the prepaid charges will show as ?As Arranged?.')"
                        onmouseout="hidetip()">
                        <img src="../Images/button_info.gif" align="middle" class="bodylistheader"></div>
                    <% end if %>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="checkbox" value="Y" name="cShowWeightChargeConsignee" id="cShowWeightChargeConsignee" <% if vshowweightchargeconsignee="Y" then response.write("checked") %>>
                    Show Consignee
                    <% if mode_begin then %>
                    <div style="width: 21px; display: inline; vertical-align: middle""" onmouseover="showtip('Checking this will show the Charges due the Consignee when you print the bill.  If uncheck, the prepaid charges will show as ?As Arranged?')"
                        onmouseout="hidetip()">
                        <img src="../Images/button_info.gif" align="middle" class="bodylistheader"></div>
                    <% end if %>
                </td>
            </tr>
            <tr align="left" valign="middle">
                <td height="1" colspan="15" bgcolor="#A0829C">
                </td>
            </tr>
            <tr bgcolor="#f0e7ef">
                <td width="7%" height="20" align="left" valign="top" bgcolor="#f3f3f3">
                    No of<br>
                    Pieces
                </td>
                <td width="7%" align="left" valign="top" bgcolor="#f3f3f3">
                    Unit of
                    <br>
                    Qty</td>
                <td width="6%" align="left" valign="top" bgcolor="#f3f3f3">
                    KG/LB</td>
                <td width="7%" align="left" valign="top" bgcolor="#f3f3f3">
                    Gross WT</td>
                <td width="6%" align="left" valign="top" bgcolor="#f3f3f3">
                    Adjusted<br>
                    WT</td>
                <td width="4%" align="left" valign="top" bgcolor="#f3f3f3">
                    Rate<br>
                    Class</td>
                <td width="7%" align="left" valign="top" bgcolor="#f3f3f3">
                    Commodity<br>
                    Item No</td>
                <td width="10%" align="left" valign="top" bgcolor="#f3f3f3">
                    Dimensional
                    <br>
                    WT</td>
                <td width="8%" align="left" valign="top" bgcolor="#f3f3f3">
                    Chargeable<br>
                    WT</td>
                <td width="6%" align="left" valign="top" bgcolor="#f3f3f3">
                    Rate/<br>
                    Charge</td>
                <td width="9%" align="left" valign="top" bgcolor="#f3f3f3">
                    Fetch
                    <br>
                    Default Rate
                </td>
                <td width="1%" align="left" valign="top" bgcolor="#f3f3f3">
                    &nbsp;
                </td>
                <td width="8%" align="left" valign="top" bgcolor="#f3f3f3">
                    <%if vCheckMH="Y" then response.Write("")else  response.Write("Weight<br>Charge") %>
                </td>
                <td width="9%" align="left" valign="top" bgcolor="#f3f3f3">
                    <input type="hidden" id='dimtext' name="dimtext" value="<%= vDimText %>"></td>
                <td width="5%" align="left" valign="top" bgcolor="#f3f3f3">
                    &nbsp;
                </td>
            </tr>
            <input name="lstM_HAWB:Text" type="hidden" id="lstM_HAWB_Text" value="<%=vM_HAWB%>" />
            <input type="hidden" id="Pieces">
            <input type="hidden" id="UnitQty">
            <input type="hidden" id="KgLb">
            <input type="hidden" id="GrossWeight">
            <input type="hidden" id="AdjustedWeight">
            <input type="hidden" id="RateClass">
            <input type="hidden" id="Dimension">
            <input type="hidden" id="DimDetail">
            <input type="hidden" id="ChargeableWeight">
            <input type="hidden" id="RateCharge">
            <input type="hidden" id="TotalCharge">
            <% if vCheckMH="Y" then IndexLast= 0 ELSE IndexLast= wIndex %>
            <% for i=0 to 0 %>
            <tr id="td_wc_list" align="left" valign="middle">
                <td>
                    <input name="txtPiece<%= i %>"  type="text" style="width: 50px; behavior: url(../include/igNumDotChkLeft.htc)"
                        class="numberfield Pieces" id="Pieces" value="<%=aPiece(i)%>" size="8"></td>
                <!--onKeyup="checkLimit(this,10000,4)"-->
                <td>
                    <select name="lstUnitQty<%= i %>" size="1" class="smallselect" id="UnitQty">
                        <option value="PCS" <% if aunitqty(i)="PCS" then response.write("selected") %>>PCS</option>
                        <option value="BOX" <% if aunitqty(i)="BOX" then response.write("selected") %>>BOX</option>
                        <option value="PLT" <% if aunitqty(i)="PLT" then response.write("selected") %>>PLT</option>
                        <option value="CTN" <% if aunitqty(i)="CTN" then response.write("selected") %>>CTN</option>
                        <option value="SET" <% if aunitqty(i)="SET" then response.write("selected") %>>SET</option>
                        <option value="CRT" <% if aunitqty(i)="CRT" then response.write("selected") %>>CRT</option>
                        <option value="SKD" <% if aunitqty(i)="SKD" then response.write("selected") %>>SKD</option>
                        <option value="UNIT" <% if aunitqty(i)="UNIT" then response.write("selected") %>>UNIT</option>
                        <option value="PKGS" <% if aunitqty(i)="PKGS" then response.write("selected") %>>PKGS</option>
                        <option value="CNTR" <% if aunitqty(i)="CNTR" then response.write("selected") %>>CNTR</option>
                    </select>
                </td>
                <td>
                    <select name="lstKgLb<%= i %>" size="1" class="smallselect KgLb" id="lstKgLb" onchange="ScaleChange(<%= i %>)">
                        <option value="L">LB</option>
                        <option value="K" <% if akglb(i)="K" then response.write("selected") %>>KG</option>
                    </select>
                </td>
                <td>
                    <input name="txtGrossWeight<%= i %>" type="text" style="width: 58px; behavior: url(../include/igNumDotChkLeft.htc)"
                        class="numberfield GrossWeight" id="GrossWeight" value="<%=aGrossWeight(i)%>" size="9" onblur='setChargeableWeight("<%= i %>"); setAdjustedWeight("<%= i %>");' /></td>
                <td>
                    <input name="txtAdjustedWeight<%= i %>" type="text" style="behavior: url(../include/igNumDotChkLeft.htc)"
                        class="numberfield AdjustedWeight" id="AdjustedWeight" value="<%=aAdjustedWeight(i)%>" size="9" /></td>
                <td>
                    <input name="txtRateClass<%= i %>" type="text" style="behavior: url(../include/igNumDotChkLeft.htc)"
                        class="numberfield RateClass" id="RateClass" value="<%= aRateClass(i) %>" size="5" maxlength="1"></td>
                <td>
                    <input name="txtItemNo<%= i %>" type="text" class="numberfield" value="<%= aItemNo(i) %>"
                        maxlength="16" size="7"></td>
                <td>
                    <input name="txtDimension<%= i %>" type="text" 
                        class="numberfield Dimension" id="Dimension" value="<%= aDimension(i) %>" size="7" onblur='setChargeableWeight("<%=i%>")' style="behavior: url(../include/igNumDotChkLeft.htc)" />
                    <input type="image" src="../images/measure.gif" name="bDimCal<%= i %>" width="20"
                        height="18" align="absbottom" onclick="return false;" onmousedown="DimCalClick(<%= i %>); return false;"
                        style="cursor: hand" />
                    <input type="hidden" id="DimDetail<%= i %>" name="hDimDetail<%= i %>" value="<%= aDimDetail(i) %>" />
                    <div id="dialog-dimcal" name="dialogdimcal" style="display:none;">
                        <iframe id="iframe-dimcal" src=""></iframe>
                    </div>
                </td>
                <td>
                    <input name="txtChargeableWeight<%= i %>" type="text" style="behavior: url(../include/igNumDotChkLeft.htc)"
                        class="numberfield ChargeableWeight" id="txtChargeableWeight<%= i %>"  value="<%= aChargeableWeight(i) %>"
                        size="7" onchange="cChange(<%= i %>); getCustomerSellingRate(<%=i %>);"></td>
                <td>
                    <input name="txtRateCharge<%= i %>" type="text" style="behavior: url(../include/igNumDotChkLeft.htc)"
                        class="numberfield RateCharge" id="txtRateCharge<%= i %>"value="<%
                        '// Not IsNumeric(checkBlank(aRateCharge(i),0)) And checkBlank(aRateCharge(i),0) = 0
            if ConvertAnyValue(aRateCharge(i),"Double",0) = 0  Then 
				response.Write("N/A")
			else 
				response.Write(aRateCharge(i))
			end if  %>" size="8"></td>
                <td align="left">
                    <img src='../Images/icon_rate_on.gif' name="chkDfRate" align="middle" id="chkDfRate"
                        style="cursor: hand" onclick="javascript:chkDfRateClicked(<%=i %>)" onmousedown="src='../Images/icon_rate_off.gif'"
                        onmouseup="src='../Images/icon_rate_on.gif'" />
                    <% if mode_begin then %>
                    <div style="width: 21px; display: inline; vertical-align: middle" onmouseover="showtip(' If you have a rate in the rate manager that corresponds to this shipment, clicking this button will import it into the rate field. Depending on the circumstance, the ports, shipper/consignee, and rate type may all need to match.')"
                        onmouseout="hidetip()">
                        <img src="../Images/button_info.gif" align="absmiddle" class="bodylistheader"></div>
                    <% end if %>
                </td>
                <td>
                    <img src="../Images/button_cal.gif" align="middle" style="cursor: hand; display: none"
                        onclick="calculateTotalFc(<%=i %>);" /></td>
                <% if aTotal(i) = "0.00" then aTotal(i) = "" %>
                <td <%if vcheckmh="Y" then response.write("style='visibility:visible'")else  response.write("style='visibility:visible'")  %>>
                    <input name="txtTotal<%= i %>" type="text" style="width: 58px; behavior: url(../include/igNumDotChkLeft.htc)"
                        class="numberfield TotalCharge" id="TotalCharge" value="<%=ConvertAnyValue(aTotal(i),"Amount",0) %>"
                        size="10" /></td>
                <td align="left" style="visibility: <% if vCheckMH ="Y" then response.Write("hidden") end  if%>">
                    <input type="image" src="../images/button_update.gif" height="18" name="bUpdateDim"
                        style="cursor: hand; visibility:visible" onclick="WCAdd(<%= i +1 %>); return false;" /></td>
                <td align="left" style="visibility: <% if vCheckMH ="Y" then response.Write("hidden") end  if%>">
                    <input type="image" src="../images/button_delete.gif" width="50" height="17" onclick="DeleteWC(<%= i %>); return false;"
                        style="cursor: hand; visibility:hidden" /></td>
                <% if not vectHAWBs(i)="" then %>
                <% end if %>
                <% if not vectHAWBs(i)="" then %>
                <% end if %>
            </tr>
            <% next %>
            <tr bgcolor="E5D4E3">
                <td height="20" colspan="2" bgcolor="#f3f3f3">
                </td>
                <td bgcolor="#f3f3f3">
                    &nbsp;
                </td>
                <td colspan="2" bgcolor="#f3f3f3">
                </td>
                <td bgcolor="#f3f3f3">
                </td>
                <td bgcolor="#f3f3f3">
                </td>
                <td bgcolor="#f3f3f3">
                </td>
                <td bgcolor="#f3f3f3">
                </td>
                <td bgcolor="#f3f3f3">
                </td>
                <td bgcolor="#f3f3f3">
                </td>
                <td bgcolor="#f3f3f3">
                </td>
                <td colspan="2" bgcolor="#f3f3f3">
                    <%if vCheckMH="Y" then response.Write("")else  response.Write("<strong>Total Weight Charge</strong>")%>
                </td>
                <td bgcolor="#f3f3f3">
                </td>
            </tr>
            <tr style="display: none" align="left" valign="middle">
                <td height="20">
                    <input name="txtTotalPieces" style="width: 50px" type="text" <%if vcheckmh="Y" then response.write("class='numberfieldbold' readonly ") else response.write("class='numberfield'" ) end if %>
                        value="<%= vTotalPieces %>" size="8"></td>
                <td height="20">
                    &nbsp;
                </td>
                <td height="20">
                </td>
                <td>
                    <input name="txtTotalGrossWeight" style="width: 58px" type="text" <%if vcheckmh="Y" then response.write("class='d_numberfieldbold' readonly ") else response.write("class='numberfield'" ) end if %>
                        value="<%= vTotalGrossWeight %>" size="9"></td>
                <td height="20">
                    &nbsp;
                </td>
                <td height="20">
                    &nbsp;
                </td>
                <td height="20">
                    &nbsp;
                </td>
                <td height="20">
                    &nbsp;
                </td>
                <td height="20">
                    &nbsp;
                </td>
                <td height="20">
                    &nbsp;
                </td>
                <td height="20">
                    &nbsp;
                </td>
                <td height="20">
                    &nbsp;
                </td>
                <td height="20" <%if vcheckmh="Y" then response.write("style='visibility:hidden'")else  response.write("style='visibility:visible'")%>>
                    <input name="txtTotalWeightCharge" style="width: 58px" type="text" <%if vcheckmh="Y" then response.write("class='d_numberfield' readonly ") else response.write("class='numberfieldbold'" ) end if %>
                        value="<%= ConvertAnyValue(vTotalWeightCharge,"Amount",0) %>" size="10"></td>
                <td height="20" colspan="2">
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td colspan="15" height="1" bgcolor="#A0829C">
                </td>
            </tr>
            <tr align="left" valign="middle" <% if vcheckmh <>"Y" then response.write("style='display:none'")%>>
                <td colspan="15" align="left" bgcolor="#FFFFFF">
                    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="bodycopy" id="tblSubHouses">
                        <tr align="left" valign="middle">
                            <td height="1" colspan="15" bgcolor="#A0829C">
                            </td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="f3f3f3" <% if vcheckmh <>"Y" then response.write("style='display:none'")%>>
                            <td align="left" colspan="15">
                            </td>
                        </tr>
                        <tr>
                            <td height="20" colspan="11" align="left" valign="middle" bgcolor="#E5D4E3" class="bodyheader">
                                <span class="bodyheader style12">AVAILABLE SUB- HOUSES </span>
                            </td>
                        </tr>
                        <tr>
                            <td height="20" bgcolor="#f3f3f3" class="bodyheader">
                                Sub House No.</td>
                            <td bgcolor="#f3f3f3" class="bodyheader">
                                Shipper</td>
                            <td bgcolor="#f3f3f3" class="bodyheader">
                                Consignee</td>
                            <td height="20" bgcolor="#f3f3f3" class="bodyheader">
                                Agent</td>
                            <td bgcolor="#f3f3f3" class="bodyheader">
                                Pieces</td>
                            <td bgcolor="#f3f3f3" class="bodyheader">
                                GW</td>
                            <td bgcolor="#f3f3f3" class="bodyheader">
                                AW</td>
                            <td bgcolor="#f3f3f3" class="bodyheader">
                                DW</td>
                            <td bgcolor="#f3f3f3" class="bodyheader">
                                CW</td>
                            <td bgcolor="#f3f3f3" class="bodyheader">
                                &nbsp;
                            </td>
                            <td bgcolor="#f3f3f3" class="bodyheader">
                                &nbsp;
                            </td>
                        </tr>
                        <input type="hidden" name="hAVIndex" value="<%=AVIndex%>" />
                        <%for i=0 to AVIndex-1%>
                        <tr>
                            <td height="20" bgcolor="#FFFFFF">
                                <input type="text" class='d_shorttextfield' readonly value="<%= vectAVHAWBs(i)%>"></td>
                            <td bgcolor="#FFFFFF">
                                <input type="text" class='d_shorttextfield' readonly value="<%= vectAVShippers(i)%>"></td>
                            <td bgcolor="#FFFFFF">
                                <input type="text" class='d_shorttextfield' readonly value="<%= vectAVConsignees(i)%>"></td>
                            <td height="20">
                                <input type="text" class='d_shorttextfield' readonly value="<%= vectAVAgents(i)%>"></td>
                            <td bgcolor="#FFFFFF">
                                <input type="text" style="width: 50px" class="readonlyright" readonly value="<%=vectAVPiece(i)%>"
                                    size="7"></td>
                            <td bgcolor="#FFFFFF">
                                <input type="text" style="width: 58px" class="d_numberfield" readonly value="<%=vectAVGrossWeight(i)%>"
                                    size="7"></td>
                            <td bgcolor="#FFFFFF">
                                <input type="text" style="width: 58px" class="readonlyright" readonly value="<%=vectAVAdjustedWeight(i)%>"
                                    size="7"></td>
                            <td bgcolor="#FFFFFF">
                                <input type="text" style="width: 50px" class="readonlyright" readonly value="<%=vectAVDimension(i)%>"
                                    size="7"></td>
                            <td bgcolor="#FFFFFF">
                                <input type="text" style="width: 58px" class="readonlyright" readonly value="<%=vectAVChargeableWeight(i)%>"
                                    size="7"></td>
                            <td bgcolor="#FFFFFF" class="bodyheader style14">
                                <img src="../images/button_add.gif" width="37" height="17" onclick="AddToMaster('<%= vectAVHAWBs(i) %>',<%= vectAVELTAcct(i)%>)"
                                    style="cursor: hand"></td>
                            <td bgcolor="#FFFFFF" class="bodyheader style14">
                                <img src="../images/button_edit.gif" width="37" height="18" onclick="EditHAWB('<%= vectAVHAWBs(i) %>','<%= vectAVELTAcct(i)%>')"
                                    style="cursor: hand"></td>
                        </tr>
                        <%next%>
                        <tr>
                            <td height="20" bgcolor="#FFFFFF">
                                &nbsp;
                            </td>
                            <td bgcolor="#FFFFFF">
                                &nbsp;
                            </td>
                            <td bgcolor="#FFFFFF">
                                &nbsp;
                            </td>
                            <td height="20" bgcolor="#FFFFFF">
                                <div align="right">
                                    <span class="bodyheader">Total</span>&nbsp;</div>
                            </td>
                            <td bgcolor="#FFFFFF">
                                <input type="text" style="width: 50px" class="readonlyboldright" readonly value="<%=vectAVPieceTotal%>"
                                    size="7"></td>
                            <td bgcolor="#FFFFFF">
                                <input type="text" style="width: 58px" class="readonlyboldright" readonly value="<%=vectAVGrossWeightTotal%>"
                                    size="7"></td>
                            <td bgcolor="#FFFFFF">
                                <input type="text" style="width: 58px" class="readonlyboldright" readonly value="<%=vectAVAdjustedWeightTotal%>"
                                    size="7"></td>
                            <td bgcolor="#FFFFFF">
                                <input type="text" style="width: 50px" class="readonlyboldright" readonly value="<%=vectAVDimensionTotal%>"
                                    size="7"></td>
                            <td bgcolor="#FFFFFF">
                                <input type="text" style="width: 58px" class="readonlyboldright" readonly value="<%=vectAVChargeableWeightTotal%>"
                                    size="7">
                                &nbsp;</td>
                            <td bgcolor="#FFFFFF">
                                &nbsp;
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td height="20" bgcolor="#FFFFFF">
                                &nbsp;
                            </td>
                            <td bgcolor="#FFFFFF">
                                &nbsp;
                            </td>
                            <td bgcolor="#FFFFFF">
                                &nbsp;
                            </td>
                            <td height="20" bgcolor="#FFFFFF">
                                &nbsp;
                            </td>
                            <td colspan="4" align="right" valign="middle" bgcolor="#FFFFFF" class="bodyheader style14">
                            </td>
                            <td bgcolor="#FFFFFF">
                                &nbsp;
                            </td>
                            <td colspan="2" bgcolor="#FFFFFF">
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td height="20" colspan="11" align="left" valign="middle" bgcolor="#E5D4E3" class="bodyheader style11 style12">
                                SELECTED SUB-HOUSES
                            </td>
                        </tr>
                        <tr align="left" valign="middle">
                            <td height="1" colspan="15" bgcolor="#A0829C">
                            </td>
                        </tr>
                        <tr>
                            <td height="20" bgcolor="#f3f3f3" class="bodyheader">
                                Sub-House No.</td>
                            <td bgcolor="#f3f3f3" class="bodyheader">
                                Shipper</td>
                            <td bgcolor="#f3f3f3" class="bodyheader">
                                Consignee</td>
                            <td bgcolor="#f3f3f3" class="bodyheader">
                                Agent</td>
                            <td bgcolor="#f3f3f3" class="bodyheader">
                                Pieces</td>
                            <td bgcolor="#f3f3f3" class="bodyheader">
                                GW</td>
                            <td bgcolor="#f3f3f3" class="bodyheader">
                                AW</td>
                            <td bgcolor="#f3f3f3" class="bodyheader">
                                DW</td>
                            <td bgcolor="#f3f3f3" class="bodyheader">
                                CW</td>
                            <td bgcolor="#f3f3f3" class="bodyheader">
                                &nbsp;
                            </td>
                            <td bgcolor="#f3f3f3" class="bodyheader">
                                &nbsp;
                            </td>
                        </tr>
                        <input type="hidden" name="hSHIndex" value="<%=SHIndex%>" />
                        <%for i=0 to SHIndex-1%>
                        <tr>
                            <td height="20">
                                <input type="text" class='d_shorttextfield' readonly value="<%= vectHAWBs(i)%>"></td>
                            <td>
                                <input type="text" class='d_shorttextfield' readonly value="<%= vectShippers(i)%>"></td>
                            <td>
                                <input type="text" class='d_shorttextfield' readonly value="<%= vectConsignees(i)%>"></td>
                            <td>
                                <input type="text" class='d_shorttextfield' readonly value="<%= vectAgents(i)%>"></td>
                            <td>
                                <input type="text" style="width: 50px" class="readonlyright" readonly value="<%=vectPiece(i)%>"
                                    size="7"></td>
                            <td>
                                <input type="text" style="width: 58px" class="d_numberfield" readonly value="<%=vectGrossWeight(i)%>"
                                    size="9"></td>
                            <td>
                                <input type="text" style="width: 58px" <%if elt_account_number = cstr(sheltacct(i)) then response.write(" class='numberfield'") else  response.write(" class='d_numberfield' readonly")  end if%>
                                    value="<%=vectAdjustedWeight(i)%>" size="9" onfocus="SaveOldAjustedWeight('<%=vectAdjustedWeight(i)%>')"
                                    onblur=" if ('<%= vectColo(i)%>'!='Y'){ ChangeAdjustedWeight('<%= vectHAWBs(i)%>',this,'<%= vectTranNo(i)%>')}"></td>
                            <td>
                                <input type="text" style="width: 50px" class="readonlyright" readonly value="<%=vectDimension(i)%>"
                                    size="7"></td>
                            <td>
                                <input type="text" style="width: 58px" class="readonlyright" readonly value="<%=vectChargeableWeight(i)%>"
                                    size="7"></td>
                            <td>
                                <img src="../images/button_edit.gif" width="37" height="18" onclick="EditHAWB('<%= vectHAWBs(i) %>','<%= SHELTAcct(i) %>')"
                                    style="cursor: hand"></td>
                            <td align="left">
                                <img src="../images/button_remove.gif" width="55" height="17" onclick="RemoveSH('<%= vectHAWBs(i) %>','<%= SHELTAcct(i) %>')"
                                    style="cursor: hand"></td>
                            <input type="hidden" id="hAW" />
                        </tr>
                        <%next%>
                        <tr>
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
                                <div align="right">
                                    <span class="bodyheader">Total</span>&nbsp;</div>
                            </td>
                            <td bgcolor="#FFFFFF">
                                <input type="text" style="width: 50px" class="readonlyboldright" readonly value="<%=vectPieceTotal%>"
                                    size="7"></td>
                            <td bgcolor="#FFFFFF">
                                <input type="text" style="width: 58px" class="readonlyboldright" readonly value="<%=vectGrossWeightTotal%>"
                                    size="9"></td>
                            <td bgcolor="#FFFFFF">
                                <input type="text" style="width: 58px" class="readonlyboldright" readonly value="<%=vectAdjustedWeightTotal%>"
                                    size="9"></td>
                            <td bgcolor="#FFFFFF">
                                <input type="text" style="width: 50px" class="readonlyboldright" readonly value="<%=vectDimensionTotal%>"
                                    size="7"></td>
                            <td bgcolor="#FFFFFF">
                                <input type="text" style="width: 58px" class="readonlyboldright" readonly value="<%=vectChargeableWeightTotal%>"
                                    size="7"></td>
                            <td bgcolor="#FFFFFF">
                                <%if   SHIndex > 0 then%>
                                <img src="../images/button_adjust.gif" width="51" height="18" onclick="AdjustWeight()"
                                    style="cursor: hand">
                                <%end if%>
                            </td>
                            <td bgcolor="#FFFFFF">
                                &nbsp;
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#A0829C"
            bgcolor="#FFFFFF" class="border1px" style="padding-left: 10px">
            <tr class="bodyheader" bgcolor="#f3f3f3">
                <td width="28%" height="18">
                    <strong>Nature and Quantity of Goods</strong></td>
                <td width="35%">
                    <strong>Nature and Quantity of Goods (continued)</strong></td>
                <td width="37%">
                    <strong>Manifest Description</strong></td>
            </tr>
            <tr class="bodyheader">
                <td height="18" valign="top">
                    <textarea name="txtDesc2" cols="22" rows="14" wrap="hard" class="monotextarea" onkeyup="Desc2KeyUp()"><%= vDesc2 %></textarea></td>
                <td valign="top">
                    <textarea name="txtDesc1" cols="22" rows="9" wrap="hard" class="monotextarea" onkeydown="javascript:return checkMaxRows(this);"><%= vDesc1 %></textarea></td>
                <td align="left" valign="top">
                    <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                        <tr>
                            <td colspan="2">
                                <textarea name="txtManifestDesc" cols="22" rows="2" wrap="hard" class="monotextarea"><%= vManifestDesc %></textarea></td>
                        </tr>
                        <tr class="bodyheader">
                            <td height="18" bgcolor="#f3f3f3">
                                AES ITN No. &nbsp;</td>
                            <td height="18" bgcolor="#f3f3f3">
                                AES Exemption Statement &nbsp;</td>
                        </tr>
                        <tr>
                            <td height="18">
                                <input type="text" class="m_shorttextfield" preset="maxsize" name="txtAES" value="<%=vAES %>"
                                    style="width: 180px" /></td>
                            <td>
                                <input type="text" class="m_shorttextfield" name="txtSEDStatement" value="<%=vSEDStmt %>"
                                    maxlength="128" style="width: 180px" /></td>
                        </tr>
                        <tr>
                            <td colspan="2" width="23%" height="18" bgcolor="#f3f3f3" class="bodyheader">
                                LC No.
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" height="18">
                                <input name="txtLC" type="text" class="m_shorttextfield" preset="maxsize" value="<%= vLC %>"
                                    size="20"></td>
                        </tr>
                        <tr>
                            <td colspan="2" height="18" bgcolor="#f3f3f3" class="bodyheader">
                                C.I. No.
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" height="18">
                                <input name="txtCI" type="text" class="m_shorttextfield" preset="maxsize" value="<%= vCI %>"
                                    size="20"></td>
                        </tr>
                        <tr>
                            <td colspan="2" height="18" bgcolor="#f3f3f3" class="bodyheader">
                                Other Ref.</td>
                        </tr>
                        <tr>
                            <td colspan="2" height="18">
                                <input name="txtOtherRef" type="text" class="m_shorttextfield" preset="maxsize" value="<%= vOtherRef %>"
                                    size="20"></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <table id="tblOtherCharge" width="95%" border="0" align="center" cellpadding="0"
            cellspacing="0" bordercolor="#A0829C" bgcolor="#FFFFFF" class="border1px" style="padding-left: 10px">
            <tr align="left" valign="middle" bgcolor="E5D4E3">
                <td width="11%" height="22">
                    <strong><font color="c16b42">OTHER CHARGE</font></strong></td>
                <td colspan="5" bgcolor="E5D4E3">
                    <strong>Prepaid&nbsp; &nbsp; &nbsp;
                        <input type="checkbox" value="Y" name="cShowPrepaidOtherChargeShipper" <% if vshowprepaidotherchargeshipper="Y" then response.write("checked") %>>
                    </strong>Show Shipper&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="checkbox" value="Y" name="cShowPrepaidOtherChargeConsignee" <% if vshowprepaidotherchargeconsignee="Y" then response.write("checked") %>>
                    Show Consignee&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;<strong>Collect
                        &nbsp; &nbsp; &nbsp; </strong>
                    <input type="checkbox" value="Y" name="cShowCollectOtherChargeShipper" <% if vshowcollectotherchargeshipper="Y" then response.write("checked") %>>
                    Show Shipper&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="checkbox" value="Y" name="cShowCollectOtherChargeConsignee" <% if vshowcollectotherchargeconsignee="Y" then response.write("checked") %>>
                    Show Consignee</td>
            </tr>
            <tr align="left" valign="middle">
                <td height="1" colspan="10" bgcolor="#A0829C">
                </td>
            </tr>
            <input type="hidden" id="ChargeItem" />
            <input type="hidden" id="ChargeCP" />
            <input type="hidden" id="ChargeVendor" />
            <input type="hidden" id="ChargeAmt" />
            <input type="hidden" id="ChargeCost" />
            <input type="hidden" id="ItemDesc" />
            <tr bgcolor="#f3f3f3">
                <td width="11%" height="18">
                    <strong>Carrier/Agent</strong></td>
                <td width="13%">
                    <strong>Collect/Prepaid</strong></td>
                <td width="26%">
                    <strong>Charge Item</strong></td>
                <td width="27%">
                    <strong>Description</strong></td>
                <td width="11%">
                    <strong>Charge Amount</strong></td>
                <td width="12%">
                    &nbsp;
                </td>
            </tr>

         

            <% for i=0 to oIndex-1 %>
            <tr class="oc_row" bgcolor="ffffff" id="aRow<%=i %>" style="visibility: <% if vCheckMH ="Y" then response.Write("visible") end if%>">
                <td>
                    <input type="radio" <% if aCarrierAgent(i)="C" then response.write("checked") %>
                        name="lstCarrierAgent<%= i %>" value="C" />
                    <input type="radio" <% if aCarrierAgent(i)="A" then response.write("checked") %>
                        name="lstCarrierAgent<%= i %>" value="A" /></td>
                <td>
                    <input type="radio" <% if aCollectPrepaid(i)="C" then response.write("checked") %>
                        id="collectPaid<%= i %>" name="lstCollectPrepaid<%= i %>" value="C" class="ChargeCP" />
                    <input type="radio" <% if aCollectPrepaid(i)="P" then response.write("checked") %>
                        id="prePaid<%= i %>" name="lstCollectPrepaid<%= i %>" value="P" class="ChargeCP" /></td>
                <td>
                    <select style="width: 230px" name="lstChargeCode<%= i %>" size="1" class="smallselect ChargeItem"
                        id="ChargeItem" onchange="ChargeItemChange('<%= i %>',this.selectedIndex)">
                        <% for j=0 to chIndex-1 %>
                        <option value="<%= aChargeItemNo(j) & "-" & aChargeItemDesc(j) & "-" & aChargeUnitPrice(j) %>"
                            <% if CInt(achargecode(i))=achargeitemno(j) then response.write("selected") %>>
                            <%= aChargeItemNameig(j) %>
                        </option>
                        <% next %>
                    </select>
                </td>
                <td>
                    <input name="txtChargeDesc<%= i %>" class="shorttextfield ItemDesc" id="ItemDesc" value="<%= aDesc(i) %>"
                        size="46" /></td>
                <td>
                    <input name="txtChargeAmt<%= i %>" style="behavior: url(../include/igNumDotChkLeft.htc)"
                        class="numberfield ChargeAmt" id="ChargeAmt" value="<%= ConvertAnyValue(aChargeAmt(i),"Amount",0) %>"
                        size="18" maxlength="14" /></td>
                <td align="left" valign="middle">
                    <input type="image" src="../images/button_delete.gif" width="50" height="17" onclick="DeleteOC(<%= i %>); return false;" /></td>
            </tr>
            <% next %>
            <tr align="right">
                <td height="20" colspan="5" align="left">
                    <span style="visibility: <% if vCheckMH ="Y" then response.Write("visible") end if%>">
                       
                         <input id="btnAddOC" type="image" src="../images/button_addcharge.gif" width="113" height="18"
                            name="bAddOC" onclick="AddOC(); return false;" style="cursor: pointer" />
                        <div id="dispBthAddOC">
                        <span style="color:red">
                            *
                        </span><span>Other charges can be added once the HAWB is saved first.</span>
                        </div>
                    </span></td>
                <!--            
				<td width="25%" align="left" valign="middle"><img src="../images/button_addcharge.gif" width="113" height="18" name="bAddOC" onClick="addTableRow();"  style="cursor:hand"></td> 
				-->
                <td width="12%" align="left" valign="middle" id="td_oc_list" style="visibility: <% if vCheckMH ="Y" then response.Write("visible ") end if%>">
                    &nbsp;</td>
            </tr>
            <!--
            <tr align="left" valign="middle">
                <td colspan="6" style="background-color:#A0829C; height:1px">
                </td>
            </tr>
            <tr style="background-color:#E5D4E3; height:22px">
                <td colspan="6" class="bodyheader" style="color:#c16b42">AGENT CREDIT</td>
            </tr>
            <tr align="left" valign="middle">
                <td colspan="6" style="background-color:#A0829C; height:1px">
                </td>
            </tr>
            <tr align="left" valign="middle">
                <td colspan="6" style="background-color:#ffffff; height:5px">
                </td>
            </tr>
            -->
        </table>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#A0829C"
            bgcolor="#FFFFFF" class="border1px">
            <tr align="center" valign="middle">
                <td width="50%" height="22" align="left" valign="top" bgcolor="#FFFFFF">
                    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                        <tr align="center" valign="middle">
                            <td width="50%" height="20" bgcolor="#f0e7ef">
                                <strong>Prepaid</strong></td>
                            <td width="50%" bgcolor="#f0e7ef">
                                <strong>Collect</strong></td>
                        </tr>
                        <tr align="center" valign="middle">
                            <td colspan="2" bgcolor="#f3f3f3">
                                Weight Charge</td>
                        </tr>
                        <tr align="center">
                            <td>
                                <input name="txtPrepaidWeightCharge" class="readonlyright" value="<%=ConvertAnyValue(vPrepaidWeightCharge,"Amount",0) %>"
                                    size="14" maxlength="14" readonly="readonly" /></td>
                            <td>
                                <input name="txtCollectWeightCharge" class="readonlyright" value="<%=ConvertAnyValue(vCollectWeightCharge,"Amount",0) %>"
                                    size="14" maxlength="14" readonly="readonly" /></td>
                        </tr>
                        <tr align="center" valign="middle">
                            <td colspan="2" bgcolor="#f3f3f3">
                                Valuation Charge</td>
                        </tr>
                        <tr align="center">
                            <td>
                                <input name="txtPrepaidValuationCharge" style="behavior: url(../include/igNumDotChkLeft.htc)"
                                    class="numberfield" value="<%=ConvertAnyValue(vPrepaidValuationCharge,"Amount",0) %>"
                                    size="14" maxlength="14" /></td>
                            <td>
                                <input name="txtCollectValuationCharge" style="behavior: url(../include/igNumDotChkLeft.htc)"
                                    class="numberfield" value="<%=ConvertAnyValue(vCollectValuationCharge,"Amount",0) %>"
                                    size="14" maxlength="14" /></td>
                        </tr>
                        <tr align="center" valign="middle">
                            <td colspan="2" bgcolor="#f3f3f3">
                                Tax</td>
                        </tr>
                        <tr align="center">
                            <td>
                                <input name="txtPrepaidTax" style="behavior: url(../include/igNumDotChkLeft.htc)"
                                    class="numberfield" value="<%=ConvertAnyValue(vPrepaidTax,"Amount",0) %>" size="14"
                                    maxlength="14" /></td>
                            <td>
                                <input name="txtCollectTax" style="behavior: url(../include/igNumDotChkLeft.htc)"
                                    class="numberfield" value="<%=ConvertAnyValue(vCollectTax,"Amount",0) %>" size="14"
                                    maxlength="14" /></td>
                        </tr>
                        <tr align="center" valign="middle">
                            <td colspan="2" bgcolor="#f3f3f3">
                                Total Other Charges Due Agent</td>
                        </tr>
                        <tr align="center">
                            <td>
                                <input name="txtPrepaidOtherChargeAgent" class="readonlyright" style="behavior: url(../include/igNumDotChkLeft.htc)"
                                    value="<%=ConvertAnyValue(vPrepaidOtherChargeAgent,"Amount",0) %>" size="14"
                                    maxlength="14" readonly="readonly" /></td>
                            <td>
                                <input name="txtCollectOtherChargeAgent" class="readonlyright" style="behavior: url(../include/igNumDotChkLeft.htc)"
                                    value="<%=ConvertAnyValue(vCollectOtherChargeAgent,"Amount",0) %>" size="14"
                                    maxlength="14" readonly="readonly" /></td>
                        </tr>
                        <tr align="center" valign="middle">
                            <td colspan="2" bgcolor="#f3f3f3">
                                Total Other Chrges Due Carrier</td>
                        </tr>
                        <tr align="center">
                            <td>
                                <input name="txtPrepaidOtherChargeCarrier" class="readonlyright" style="behavior: url(../include/igNumDotChkLeft.htc)"
                                    value="<%=ConvertAnyValue(vPrepaidOtherChargeCarrier,"Amount",0) %>" size="14"
                                    maxlength="14" readonly="readonly" /></td>
                            <td>
                                <input name="txtCollectOtherChargeCarrier" class="readonlyright" style="behavior: url(../include/igNumDotChkLeft.htc)"
                                    value="<%=ConvertAnyValue(vCollectOtherChargeCarrier,"Amount",0) %>" size="14"
                                    maxlength="14" readonly="readonly" /></td>
                        </tr>
                        <tr align="center">
                            <td height="18" bgcolor="#f0e7ef">
                                <strong>Total Prepaied</strong></td>
                            <td bgcolor="#f0e7ef">
                                <strong>Total Collect</strong></td>
                        </tr>
                        <tr align="center">
                            <td>
                                <input name="txtPrepaidTotal" class="readonlyright" style="behavior: url(../include/igNumDotChkLeft.htc)"
                                    value="<%=ConvertAnyValue(vPrepaidTotal,"Amount",0) %>" size="14" maxlength="14"
                                    readonly="readonly" /></td>
                            <td>
                                <input name="txtCollectTotal" class="readonlyright" style="behavior: url(../include/igNumDotChkLeft.htc)"
                                    value="<%=ConvertAnyValue(vCollectTotal,"Amount",0) %>" size="14" maxlength="14"
                                    readonly="readonly" /></td>
                        </tr>
                        <tr align="center">
                            <td height="18" bgcolor="#f3f3f3">
                                <strong>Currency Conversion Rates</strong></td>
                            <td bgcolor="#f3f3f3">
                                <strong>CC Charges in Dest. Currency</strong></td>
                        </tr>
                        <tr align="center">
                            <td>
                                <input name="txtConversionRate" class="numberfield" style="behavior: url(../include/igNumDotChkLeft.htc)"
                                    value="<%=ConvertAnyValue(vConversionRate,"Double",0) %>" size="14" maxlength="14" /></td>
                            <td>
                                <input name="txtCCCharge" class="numberfield" style="behavior: url(../include/igNumDotChkLeft.htc)"
                                    value="<%=ConvertAnyValue(vCCCharge,"Amount",0) %>" size="14" maxlength="14" /></td>
                        </tr>
                        <tr align="center">
                            <td>
                                &nbsp;</td>
                            <td height="20">
                                <strong>Charges at Destination</strong></td>
                        </tr>
                        <tr align="center">
                            <td>
                                For Carriers Use only at Destination</td>
                            <td>
                                <input name="txtChargeDestination" class="numberfield" style="behavior: url(../include/igNumDotChkLeft.htc)"
                                    value="<%=ConvertAnyValue(vChargeDestination,"Amount",0) %>" size="14" maxlength="14"></td>
                        </tr>
                    </table>
                </td>
                <td width="50%" align="left" valign="top" bgcolor="ffffff">
                    <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF"
                        class="bodycopy">
                        <tr bgcolor="#f0e7ef">
                            <td height="20" colspan="2">
                                <strong>Other Charges</strong></td>
                        </tr>
                        <tr>
                            <td width="73%" colspan="2">
                                <input name="txtOtherCharge1" class="shorttextfield" value="<%= aOtherCharge(0) %>"
                                    size="75" maxlength="45" /></td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <input name="txtOtherCharge12" class="shorttextfield" value="<%= aOtherCharge(1) %>"
                                    size="75" maxlength="45"></td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <input name="txtOtherCharge3" class="shorttextfield" value="<%= aOtherCharge(2) %>"
                                    size="75" maxlength="45" /></td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <input name="txtOtherCharge4" class="shorttextfield" value="<%= aOtherCharge(3) %>"
                                    size="75" maxlength="45" /></td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <input name="txtOtherCharge5" class="shorttextfield" value="<%= aOtherCharge(4) %>"
                                    size="75" maxlength="45" /></td>
                        </tr>
                        <tr>
                            <td height="20" colspan="2">
                                &nbsp;</td>
                        </tr>
                        <tr>
                            <td height="57" valign="bottom">
                                <textarea name="txtSignature" id="txtSignature" cols="50" rows="2" wrap="hard" class="multilinetextfield"><%= vSignature %></textarea></td>
                            <td width="27%" valign="bottom">
                                <input type="text" name="txtEmpolyee" class="readonly" value="<%=GetUserFLName(user_id) %>"
                                    readonly="readonly" /></td>
                        </tr>
                        <tr>
                            <td>
                                Signature of Shipper or Agent</td>
                            <td>
                                Prepared by</td>
                        </tr>
                        <tr>
                            <td height="20" colspan="2">
                                &nbsp;</td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <textarea name="txtExecute" cols="50" rows="3" wrap="hard" class="multilinetextfield"><%= vExecute %></textarea>
                                <br>
                                Executed on (date) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;at (place) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Signature
                                of issuing carrier or its agent
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="50%" align="center" class="bodycopy">
                                &nbsp;</td>
                            <td width="50%" height="18" align="center" bgcolor="#f0e7ef" class="bodycopy">
                                <strong>Total Collect Charges</strong></td>
                        </tr>
                        <tr>
                            <td class="bodycopy">
                                &nbsp;
                            </td>
                            <td align="center">
                                <input name="txtFinalCollect" class="readonlyboldright" value="<%=ConvertAnyValue(vFinalCollect,"Amount",0) %>"
                                    size="14" maxlength="14" readonly="readonly" /></td>
                        </tr>
                    </table>
                    <br />
                </td>
                <td>
                    &nbsp;</td>
            </tr>
            <!--
            <tr>
                <td colspan="2" height="1" bgcolor="A0829C">
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="border1px"
                        style="padding-left: 10px">
                        <tr style="background-color: #e5d4e3; height: 22px">
                            <td colspan="6">
                                <b style="color: #c16b42">AGENT CREDIT</b></td>
                        </tr>
                        <tr>
                            <td colspan="6" height="1" style="background-color:#A0829C"></td>
                        </tr>
                        <tr style="height: 22px" class="bodyheader">
                            <td>
                                Freight Charge
                            </td>
                            <td>
                                Freight Cost
                            </td>
                            <td>
                                P/S (%)
                            </td>
                            <td>
                                P/S Amount
                            </td>
                            <td>
                                Other P/S for Carrier
                            </td>
                            <td>
                                Other P/S for Agent
                            </td>
                        </tr>
                        <tr style="height: 22px" class="bodyheader">
                            <td>
                                <input type="text" class="shorttextfield" value="<%=ConvertAnyValue(vTotalWeightCharge,"Amount",0) %>" />
                            </td>
                            <td>
                                <input type="text" class="shorttextfield" value="<%=ConvertAnyValue(vAFCost,"Amount",0) %>" />
                            </td>
                            <td>
                                <input type="text" class="shorttextfield" value="<%=ConvertAnyValue(vAgentProfitPercent,"Integer",0) %>" />
                            </td>
                            <td>
                                <input type="text" class="shorttextfield" value="<%=ConvertAnyValue(vAgentProfit,"Amount",0) %>" />
                            </td>
                            <td>
                                <input type="text" class="shorttextfield" value="<%=ConvertAnyValue(vOtherProfitCarrier,"Amount",0) %>" />
                            </td>
                            <td>
                                <input type="text" class="shorttextfield" value="<%=ConvertAnyValue(vOtherProfitAgent,"Amount",0) %>" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="2" height="1" bgcolor="A0829C">
                </td>
            </tr>
            -->
            <tr align="center" valign="middle">
                <td height="32" colspan="2" bgcolor="#f3f3f3">
                    <div align="right" style="margin-right: 10px">
                        <strong>Sales Person</strong>
                        <select name="lstSalesRP" size="1" class="smallselect" style="width: 200px">
                            <option value="none">Select One</option>
                            <% For i=0 To SRIndex-1 %>
                            <option value="<%= aSRName(i)%>" <%
  	                    if vsalesperson = asrname(i) then response.write("selected") %>>
                                <%= aSRName(i) %>
                            </option>
                            <%  Next  %>
                        </select>
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="2" height="1" bgcolor="A0829C">
                </td>
            </tr>
            <tr align="center" valign="middle">
                <td height="24" colspan="2" bgcolor="E5D4E3">
                    <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="26%">
                                <img src="../images/button_save_new.gif" alt="save as new" name="bSaveAsNew" onclick="bsaveClick('<%= TranNo %>','yes')"
                                    style="cursor: hand" /></td>
                            <td width="48%" align="center" valign="middle">
                                <input type="image" src="../images/button_save_medium.gif" onclick="if('<%=vCheckSH%>'=='Y'){CheckIfMasterHasSameMAWB();}else{bsaveClick('<%= TranNo %>','no')} return false;"
                                    name="bSave" width="43" height="18" style="cursor: pointer" /></td>
                            <td width="13%" align="right" valign="middle">
                                <a href="/ASP/air_export/new_edit_hawb.asp">
                                    <img src="/ASP/Images/button_new.gif" width="42" height="17" border="0"
                                        style="cursor: pointer"></a></td>
                            <td width="13%" align="right" valign="middle">
                                <input type="image" src="../images/button_delete_medium.gif" width="51" height="17"
                                    name="bDeleteHAWB" onclick="DeleteHAWB(); return false;" style="cursor: pointer"></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <input id="hAjustWeight" type="hidden" />
        <table width="95%" height="32" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td align="right" valign="bottom">
                    <% If vHAWB <> "" Then %>
                        <div id="print">
                            <a href="javascript:;" onclick="SetCostItems(); return false;" tabindex="-1">Cost Items</a>
                            <img src="/ASP/Images/button_devider.gif" alt="" />
                            <a href="javascript:;" onclick="SetCreditNote(); return false;" tabindex="-1">Credit Note</a>
                            <img src="/ASP/Images/button_devider.gif" alt="" />
                            <a href="javascript:EditClick('<%=vHAWB %>','<%=vMAWB %>');"
                                tabindex="-1">
                                <img src="/ASP/Images/icon_createhouse.gif" alt="Click here to create SED"
                                    width="25" height="26" style="margin-right: 10px" />Create AES</a>
                            <img src="/ASP/Images/button_devider.gif" alt="" />
                            <a href="javascript:void(0);" id="NewPrintVeiw1" tabindex="-1">
                                <img src="/ASP/Images/icon_printer_preview.gif" align="absbottom" alt="" />House
                                Air Waybill</a>
                        </div>
                        <% End If %>
                </td>
            </tr>
        </table>
        <br />
    </form>
</body>

<script type="text/javascript" src="/ASP/ajaxFunctions/ajax_ig_call_db.js"></script>

<script type="text/javascript">

    

    var dep="";
    var arp="";
    var Unit="";
    var wgt="";
    var airline="";
    var cusAcc="";

    function catchRatingInfo(index){ //was javascript

  	     var cwId="txtChargeableWeight"+index;
	     var id="lstKgLb";

         var unitSelect = document.getElementById(id);
    	 
	     if(!document.frmHAWB.cPPO1.checked){
    		cusAcc = document.getElementById("hConsigneeAcct").value;
	     }else{
	 	    cusAcc = document.getElementById("hShipperAcct").value;
	     }

		  dep = document.getElementById("hOriginPortID").value;
		  arp = document.getElementById("hfDestArrCode").value;
    	
          Unit = unitSelect.options[ unitSelect.options.selectedIndex ].value;
          var vMAWB=document.getElementById("lstMAWB_Text").value;
          var tmp;
          tmp=vMAWB.split("-");
          airline=tmp[0];
	    
	    
	      wgt=document.getElementById(cwId).value; 
	      var WGT;
	      try{
	  	    WGT=wgt.split(",");
	      } catch(f) {}
    	  
    	  
	      if(WGT.length>1 && WGT){
	      wgt="";
	       for (var i=0;i<WGT.length;i++){
	        wgt+=WGT[i];
	        }
	      }
    }

    function SaveOldAjustedWeight(AW){

	    document.getElementById("hAW").value=AW;
    }

    function ChangeAdjustedWeight(HAWB,AW,tran_no)
    { 

	    MAWB = document.getElementById("lstMAWB_Text").value;
    	
        if (window.ActiveXObject) {
	           try {
                xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
	           } catch(e) {
                    try {
                     xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
                    } catch(e1) {
                     return;
                    }
              }
          } else if (window.XMLHttpRequest) {
                xmlHTTP = new XMLHttpRequest();
        } else {return;}
	    try
	    {
	        var url="/ASP/ajaxFunctions/ajax_updateAdjustedWeight.asp?MAWB=" + encodeURIComponent(MAWB)
                + "&HAWB=" + encodeURIComponent(HAWB) + "&AO=A&AWeight=" + AW.value + "&tran_no=" + tran_no
    		
		    xmlHTTP.open("get",url,false); 
            xmlHTTP.send(); 
    		
		    var result = xmlHTTP.responseText;
    	
    						
		    if (result=="Success"){				
			    //document.getElementById("txtAgentInfo").value=result;	
		    }else{			
			    //document.getElementById("txtAgentInfo").value=result;	
                AW.value=document.getElementById("hAW").value
		    }
	    }	
	    catch(e) {
	    alert(e);
	    }

    }

    function setshipperwithaccountholder() //was javascript
    {   
	    if (document.frmHAWB.hFFAgentAcct == "" || document.frmHAWB.hFFAgentAcct <= 0)
	    {		
		    alert("Agent is required to save  as a Master House."+"\n"+"Please select an agent and try again!"); 
		    return false;
	    }
	    if (document.getElementById("lstShipperName").value == "") {
	        var defaultShipper = "<%=GET_DEFAULT_SHIPPER_INDEX()%>";
	        var pos = defaultShipper.indexOf("-");
	        if(pos>1){
                lstShipperNameChange(defaultShipper.substring(0,pos),defaultShipper.substring(pos+1,1000));
		        document.getElementsByName("txtSignature").value = "AS AGENT" + "\n" + "FOR " + defaultShipper.substring(pos+1,1000);	
		    }
	    }
	    return true;
    }


    function CheckIfMasterHasSameMAWB()
    { 
	    MAWB=document.getElementById("lstMAWB_Text").value;
	    HAWB=document.getElementById("lstM_HAWB_Text").value;

          if (window.ActiveXObject) {
	           try {
		        xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
	           } catch(e) {
                    try {
                     xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
                    } catch(e1) {
                     return;
                    }
              }
          } else if (window.XMLHttpRequest) {
                xmlHTTP = new XMLHttpRequest();
          } else {return;}

	    try
	    {
		    xmlHTTP.open("get","/ASP/ajaxFunctions/ajax_checkIfMasterHasSameMAWB.asp?MAWB=" 
		        + encodeURIComponent(MAWB) + "&HAWB=" + encodeURIComponent(HAWB), false); 
            xmlHTTP.send(); 
    		
		    var result = xmlHTTP.responseText;
    	
		    var arr=result.split(":")
    				
		    if (arr[0]=="N"){
    		
			    if(confirm("Master Airway bill number cannot be differnt from Master House \n Would you like to change it to match with the Master House?")){
    				
				    document.getElementById("lstMAWB_Text").value=arr[1];
				    document.getElementById("hmawb_num").value=arr[1];
    				
				    bsaveClick('<%= TranNo %>','no');
    				
			    }else{
    				
			    }
		    }else{
			    bsaveClick('<%= TranNo %>','no');
		    }
	    }	
	    catch(e) {}

    }

    function chkDfRateClicked(vInd){
        <% If agent_status = "A" Or agent_status = "T" Then %>
        getCustomerSellingRate(vInd);
        <% Else %>
        alert("Premium subscription is needed for this feature.");
        <% End If %>
    }
    var req ="";
    function getCustomerSellingRate(index){
        <% If agent_status = "A" Or agent_status = "T" Then %>
	    catchRatingInfo(index);
	    
	    document.getElementById("hCurrentIndex").value=index;
	    
      
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


        if (req) {
          
		    req.onreadystatechange = processReqChange;		
		    req.open("GET","/ASP/ajaxFunctions/ajax_cus_rate.asp?cusAcc=" + encodeURIComponent(cusAcc) 
		        + "&Unit=" + encodeURIComponent(Unit) + "&airline=" + encodeURIComponent(airline)
		        + "&arp=" + encodeURIComponent(arp) + "&dep=" + encodeURIComponent(dep) 
		        + "&wgt=" + encodeURIComponent(wgt), true);	
		   console.log( "/ASP/ajaxFunctions/ajax_cus_rate.asp?cusAcc=" + encodeURIComponent(cusAcc) 
            + "&Unit=" + encodeURIComponent(Unit) + "&airline=" + encodeURIComponent(airline)
            + "&arp=" + encodeURIComponent(arp) + "&dep=" + encodeURIComponent(dep) 
            + "&wgt=" + encodeURIComponent(wgt))
        
				//window.open("/ASP/ajaxFunctions/ajax_cus_rate.asp?cusAcc=" + encodeURIComponent(cusAcc) + "&Unit=" + encodeURIComponent(Unit) + "&airline=" + encodeURIComponent(airline) + "&arp=" + encodeURIComponent(arp) + "&dep=" + encodeURIComponent(dep) + "&wgt=" + encodeURIComponent(wgt));
		    req.send();		
	    }
	    <% End If %>
    }

    function processReqChange(){

        var index=document.getElementById("hCurrentIndex").value;
        var rateId="txtRateCharge"+index;
        var totalId="txtTotal"+index;
	    if (req.readyState == 4) {	
		    if (req.status == 200) {				
		        var result = req.responseText;
		      
                //document.getElementById("txtSignature").value=result;
		        var numericVar=parseFloat(result);
    		   
		        if(numericVar<0){
		            if(confirm("Minimum charge will be applied.\n Would you like to proceed?")){
		                var tVal=numericVar*-1;
	                     tVal=Math.round(tVal*1000)/1000;
        	            
	                    document.getElementById(totalId).value=tVal.toFixed(2);
		                document.getElementById(rateId).value="N/A";
		            }else{
				        document.getElementById(rateId).value="N/A";
				     }
		            return;
		        }
			    CSRate=parseFloat(result);
			    //result=Math.round(result*1000)/1000;
			    if( document.getElementById(rateId).value!=0){
			        document.getElementById(rateId).value=CSRate;
				     calculateTotalFc(index);
			    }
			    document.getElementById(rateId).value=result;	
    			
			    if(result==0){
				    document.getElementById(rateId).value="N/A";
			    }			
		        document.getElementById(rateId).focus();	
    			
    			
		    } else {
			    document.getElementById(rateId).value="N/A";
			    document.getElementById(rateId).focus();
		    }
	    }
    }

    function calculateTotalFc(index){  

        var cwId="txtChargeableWeight"+index;
        var rateId="txtRateCharge"+index;
        var totalId="txtTotal"+index;
	    FLAG=false
        try {
            var chargeable=document.getElementById(cwId).value;
    		
		    var ch_break=chargeable.split(",");			
		    if(ch_break.length >1){
		        chargeable="";
			    for(var i=0;i<ch_break.length;i++){
				    chargeable+=ch_break[i];
			    }
		    }
		    
		    var CSRate=document.getElementById(rateId).value;
		    var TotalFC=document.getElementById(totalId).value;	
		    
		    if(CSRate!=0){
				    CSRate=parseFloat(CSRate);
		    } 	
    		
		    if((CSRate*0)!=0){	
		      alert("Please Enter a number for rate");
		      document.getElementById(rateId).value="0";
		      document.getElementById(totalId).value="0";
		      document.getElementById(rateId).focus();
		      return;
		    }	
    		
		    chargeable=parseFloat(chargeable);

	    }catch(e){ return;}
    					
        if((chargeable*0)!=0){
            alert("Please Enter a number for Chargeable Weight");
            document.getElementById(cwId).value="0";
            document.getElementById(totalId).value="0";
            document.getElementById(cwId).focus();
            return;
	    }	
	    var tVal=chargeable * CSRate;
	    tVal=Math.round(tVal*1000)/1000;
    	
	    document.getElementById(totalId).value=tVal.toFixed(2);
	    document.getElementById(totalId).focus();
    		
    }
    
    function changeMasterInfoForAllSubs(){

	    vAirOrgNum=document.frmHAWB.hAirOrgNum.value;
	    vOriginPortID=document.frmHAWB.hOriginPortID.value;
    	
	    vDepartureAirport=document.frmHAWB.txtDepartureAirport.value;
    	
	    vTo=document.frmHAWB.txtTo.value;
	    vBy=document.frmHAWB.txtBy.value;
	    vTo1=document.frmHAWB.txtTo1.value;
	    vBy1=document.frmHAWB.txtBy1.value;
	    vTo2=document.frmHAWB.txtTo2.value;
	    vBy2=document.frmHAWB.txtBy2.value ;
    	
	    vDestAirport=document.frmHAWB.txtDestAirport.value; 
	    vFlightDate1=document.frmHAWB.txtFlightDate1.value ;
	    vFlightDate2=document.frmHAWB.txtFlightDate2.value; 
	    vExportDate=document.frmHAWB.hExportDate.value;

	    vDestCountry=document.frmHAWB.txtDestCountry.value;
	    vDepartureState=document.frmHAWB.hDepartureState.value; 
	    vIssuedBy=document.frmHAWB.txtIssuedBy.value;    
	    vExecute=document.frmHAWB.txtExecute.value;
    		
	    var post_parameter ="vAirOrgNum="+vAirOrgNum+"&";
	    post_parameter +="vOriginPortID="+vOriginPortID+"&";
	    post_parameter +="vDepartureAirport="+vDepartureAirport+"&";
	    post_parameter +="vTo="+vTo+"&";
	    post_parameter +="vBy="+vBy+"&";
	    post_parameter +="vTo1="+vTo1+"&";
	    post_parameter +="vBy1="+vBy1+"&";
	    post_parameter +="vTo2="+vTo2+"&";
	    post_parameter +="vBy2="+vBy2+"&";
	    post_parameter +="vDestAirport="+vDestAirport+"&";
	    post_parameter +="vFlightDate1="+vFlightDate1+"&";
	    post_parameter +="vFlightDate2="+vFlightDate2+"&";
	    post_parameter +="vExportDate="+vExportDate+"&";
	    post_parameter +="vDestCountry="+vDestCountry+"&";
	    post_parameter +="vDepartureState="+vDepartureState+"&";
	    post_parameter +="vIssuedBy="+vIssuedBy+"&";
	    post_parameter +="vExecute="+vExecute+"&";
	    var toClearEmptyString=document.frmHAWB.hmawb_num.value.split(" ");
	    var vMAWB=toClearEmptyString[0]+":"+toClearEmptyString[1];
	    post_parameter +="vMAWB="+vMAWB+"&";
	    post_parameter +="vHAWB="+"<%=vHAWB%>";
    		
	    var url = '/ASP/ajaxFunctions/ajax_changeMasterInfoForAllSubs.asp';
    	
	    new ajax.xhr.Request('POST',post_parameter,url,verifyMasterChanged,'','','');	
    	
    		
    }

    function verifyMasterChanged(req) {

	    if (req.readyState == 4) {
		    if (req.status == 200) {
			    var tmpVal = req.responseText
			    if (tmpVal=="Success") {
    				
			    }
			    else {
				    alert('update error');						
			    }
		    }
		    else {
			    alert(req.responseText);				
		    }	
	    }				
    }
    
    function getFormObject(argObj){
    
        var form = argObj.parentElement;
        var newWindow;
        	        
            form.action = "../include/GOOFY_form_get.asp";
            form.method = "POST";
            window.open('', 'formTest');
            form.target = "formTest";
            form.submit();
    }
       
    

</script>


<script>
$(document).ready(function() {

    for (i = 0; i < $(".oc_row").length; i++) {

        var parent = $("#aRow" + i);
        var selector = "input[name=lstCarrierAgent" + i + "]:checked";

        if ($(selector).length == 0) {
            $(parent).find("input[type=radio][name=lstCarrierAgent"+ i + "] +[value='A']").first().attr("checked", "checked");
           
        }

        selector = "input[name=lstCollectPrepaid" + i + "]:checked";
        if ($(selector).length == 0) {

            if (document.frmHAWB.cPPO2.checked) {
                $(parent).find("input[type=radio][name=lstCollectPrepaid" + i + "][value='P']").first().attr("checked", "checked");

            } else {
                $(parent).find("input[type=radio][name=lstCollectPrepaid" + i + "][value='C']").first().attr("checked", "checked");
            }
        }
    }


    if (!$("#txtHAWB").val()) {
        $("#btnAddOC").css("display", "none");
        $("#dispBthAddOC").css("display", "block");
    } else {
        $("#btnAddOC").css("display", "block");
        $("#dispBthAddOC").css("display", "none");
    }

  

    if (parent.PrepPDFPrintOptions == undefined) {
        $("#NewPrintVeiw1").click(
            function() {
                if (confirm("You cannot print this document in a popup mode. Would you like to try in full page mode?")) {
                    opener.top.location.href = "/AirExport/HAWB/" + window.location.href.split("?")[1];
                    window.close();
                } else {
                    window.close();
                }
            });
    }

    $("input.GrossWeight").blur(function() {
        ResetChargeableWeightInMem()
    });
    $("input.ChargeableWeight").blur(function() {
        ResetChargeableWeightInMem()
    });
    $("input.AdjustedWeight").blur(function() {
        ResetChargeableWeightInMem()
    });
    $("input.Dimension").blur(function() {
        ResetChargeableWeightInMem()
    });

    ResetChargeableWeightInMem();
});

    </script>

<!--vbscript-->
<script type="text/vbscript">
    Dim cChanged(10)

    AskOverWrite="<%= AskOverWrite %>"
    if AskOverWrite="yes" then
        strMsg = "The HAWB #" & "<%=VHAWB%>" & " already exists! " _
            & chr(13) & "Do you really want to replace this HAWB ?"
	    ok=MsgBox (strMsg,36,"Warning")
	    if ok=6 then
		    document.frmHAWB.action = "new_edit_hawb.asp?Save=yes&OverWrite=yes" _
		        & "&tNo=" & "<%=TranNo%>" & "&WindowName=" & window.name 
		    document.frmHAWB.method = "POST"
		    document.frmHAWB.target = window.name
		    frmHAWB.submit()
	    end if
    end if

    Sub EditHAWB(HAWB,COLODee)
	    if Not cLng(COLODee)=cLng(<%= elt_account_number %>) then
		    window.open "view_print.asp?sType=house&hawb=" & encodeURIComponent(HAWB), "popupNew", ""
	    else
		    window.open "new_edit_hawb.asp?HAWB=" & encodeURIComponent(HAWB), "popupNew", ""
	    end if
    End Sub

    Sub RemoveSH(rSHAWB,ELTACT)
	    document.frmHAWB.action="new_edit_hawb.asp?RemoveSH=Y&focus=tblSubHouses&rSHAWB=" _
	        & encodeURIComponent(rSHAWB) & "&ELTACT=" & ELTACT & "&HAWB=" _
	        & encodeURIComponent("<%=vHAWB%>") & "&tNo=" & "<%=TranNo%>" & "&WindowName=" & window.name 
	    document.frmHAWB.method="POST"
	    document.frmHAWB.target=window.name
	    frmHAWB.submit()	
    End Sub 

    sub goToMasterHouse
	    HAWB=document.getElementById("lstM_HAWB_Text").value 
	    if HAWB="" then
		    Exit sub 
	    end if 
	    window.open "new_edit_hawb.asp?HAWB=" & encodeURIComponent(HAWB)& "&tNo=" & "<%=TranNo%>","popupNew", ""
    end sub 

    sub closeMasterHouse
	    HAWB=document.getElementById("txtHAWB").value 
	    if HAWB="" then
		    Exit sub 
	    end if 
	    document.frmHAWB.action="new_edit_hawb.asp?CloseMH=Y&HAWB="& encodeURIComponent(HAWB)& "&tNo=" & "<%=TranNo%>"
	    document.frmHAWB.method="POST"
	    document.frmHAWB.target=window.name
	    frmHAWB.submit()	
    end sub 

    sub openMasterHouse
	    HAWB=document.getElementById("txtHAWB").value 
	    if HAWB="" then
		    Exit sub 
	    end if 
	    document.frmHAWB.action="new_edit_hawb.asp?OpenMH=Y&HAWB="& encodeURIComponent(HAWB)& "&tNo=" & "<%=TranNo%>"
	    document.frmHAWB.method="POST"
	    document.frmHAWB.target=window.name
	    frmHAWB.submit()	
    end sub 

    Sub AdjustWeight()
	    //document.getElementById("hAjustWeight").value="Y"
	    document.frmHAWB.action="new_edit_hawb.asp?AdjustWeight=yes&Edit=yes&HAWB=" _
	        & encodeURIComponent("<%=vHAWB%>") & "&tNo=" & "<%=TranNo%>" & "&WindowName=" & window.name 
	    document.frmHAWB.method="POST"
	    document.frmHAWB.target=window.name
	    frmHAWB.submit()
    End Sub
    

    
</script>
<script type="text/javascript">
	//change by stanley on 6/19/2007
    function NewPrintVeiw() { //converted from vbscript
        var props,HAWB;
        HAWB=document.getElementById("txtHAWB").value ;
        if (HAWB != "" && HAWB != "Select One" ){
            props = "scrollBars=no,resizable=yes,toolbar=no,menubar=no,location=no,directories=no,status=yes,width=880,height=650";
            window.open ("view_print.asp?sType=house&hawb=" + encodeURIComponent(HAWB), "popUpWindow", props);
        }
        else
            alert("Please, select HOUSE AWB NO. to view PDF");
    }
</script>
<!--  #INCLUDE FILE="../include/OrgSearch.asp" -->
<!-- //for Tooltip// -->

<script language="JavaScript" type="text/javascript" src="../include/tooltips.js"></script>

<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
