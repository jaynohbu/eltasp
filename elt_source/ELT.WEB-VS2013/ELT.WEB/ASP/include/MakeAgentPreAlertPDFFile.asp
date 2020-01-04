<%
'--------------------------------------------------------------------------------------------------
'Sub Procedures
'   InsertMAWBIntoPDF(vMAWB,Copy)
'   InsertSTMTIntoPDF(MAWB,AgentNo)
'   InsertHAWBIntoPDF(vHAWB,Copy)
'   InsertManifestIntoPDF(vMAWB,AgentName,vAgent,MasterAgentNo,MAsterAgentName,MasterAgentPhone)
'   InsertInvoiceIntoPDF(InvoiceNo)
'   InsertOceanManifestIntoPDF(vMBOL,AgentName,vAgent,MasterAgentNo,MAsterAgentName,MasterAgentPhone)
'   InsertInvoiceIntoPDF(InvoiceNo)
'---------------------------------------------------------------------------------------------------
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Sub InsertMAWBIntoPDF(vMAWB,Copy)

    Dim vShipperInfo, vShipperName,vShipperAcct
    Dim vConsigneeName, vConsigneeInfo,vConsigneeAcct
    Dim vAgentInfo,vAgentIATACode,vAgentAcct,vDepartureAirport, vTo, vBy, vTo1, vBy1, vTo2, vBy2
    Dim vDestAirport,vFlightDate1,vFlightDate2
    Dim vIssuedBy,vAccountInfo
    Dim vCurrency, vChargeCode, vPPO_1, vCOLL_1, vPPO_2, vCOLL_2
    Dim vDeclaredValueCarriage, vDeclaredValueCustoms,vInsuranceAMT
    Dim vHandlingInfo, vSCI
    Dim aTranNo(3),aPiece(3),aUnitQty(3),aGrossWeight(3),aKgLb(3),aRateClass(3),aItemNo(3)
    Dim aDimension(3),aDemDetail(3),aChargeableWeight(3),aRateCharge(3),aTotal(3)
    Dim hRateCharge(3),hTotal(3)
    Dim vDesc1,vDesc2
    Dim aCarrierAgent(10),aCollectPrepaid(10),aChargeCode(10),aDesc(10),aChargeAmt(10),aVendor(10),aCost(10),aCP(10)
    Dim tIndex
    Dim vTotalPiece,vTotalGrossWeight,vTotalWeightCharge
    Dim vPrepaidWeightCharge,vCollectWeightCharge
    Dim vPrepaidValuationCharge,vCollectValuationCharge
    Dim vPrepaidTax,vCollectTax
    Dim vPrepaidOtherChargeAgent,vCollectOtherChargeAgent
    Dim vPrepaidOtherChargeCarrier,vCollectOtherChargeCarrier
    Dim vTotalPrepaid,vTotalCollect
    Dim aOtherCharge(10),aOtherChargeDesc(10)
    Dim hOtherCharge(10),hOtherChargeDesc(10)
    Dim vOtherCharge1,vOtherCharge2,vOtherCharge3
    Dim vSignature,vDateExecuted,vPlaceExecuted,vExecute
    Dim vShowWeightChargeShipper,vShowWeightChargeConsignee
    Dim vShowPrepaidOtherChargeShipper,vShowCollectOtherChargeShipper
    Dim vShowPrepaidOtherChargeConsignee,vShowCollectOtherChargeConsignee
    Dim vConversionRate,vCCCharge,vChargeDestination,vFinalCollect
    '/////////////////////////////////////////////////// by ig NOV-27
    DIM ff_shipper_acct,ff_consignee_acct, UserCountry
    '/////////////////////////////////////////////////// by ig NOV-27
    Dim i
    'Copy="CONSIGNEE"

    if UserRight=1 then Copy="CONSIGNEE"

    Dim rsHAWB, SQL
    Set rsHAWB = Server.CreateObject("ADODB.Recordset")
    'get country stmt
    
    User_country = checkBlank(Session("user_country"),"US")
    
    SQL= "select * from form_stmt where form_name='awb' and country=N'" & UserCountry & "' order by stmt_name"
    rsHAWB.Open SQL, eltConn, , , adCmdText
    
    Do While Not rsHAWB.EOF
	    vSTMTName=rsHAWB("stmt_name")
	    if vSTMTName="stmt1" then
		    vSTMT1=rsHAWB("stmt")
	    end if
	    if vSTMTName="stmt2" then
		    vSTMT2=rsHAWB("stmt")
	    end if
	    rsHAWB.MoveNext
    Loop
    rsHAWB.Close

    if Not COLODee="" then
	    SQL="select * from colo where colodee_elt_acct=" & COLODee & " and coloder_elt_acct=" & elt_account_number
	    rsHAWB.Open SQL, eltConn, , , adCmdText
	    if rsHAWB.EOF then
		    ErrMsg="You don't have the privilege to access this page!"
		    rsHAWB.close
		    Response.Redirect("../extra/err_msg.asp?ErrMSG=" & ErrMsg)
	    else
		    rsHAWB.close
		    COPY="CONSIGNEE"
		    SQL= "select * from mawb_master where elt_account_number = " & COLODee & " and MAWB_NUM=N'" & vMAWB & "'"
	    end if
    else
	    SQL= "select * from mawb_master where elt_account_number = " & elt_account_number & " and MAWB_NUM=N'" & vMAWB & "'"
    end if
    rsHAWB.Open SQL, eltConn, , , adCmdText
   
    If Not rsHAWB.EOF Then
	    AirportCode=rsHAWB("dep_airport_code")
	    'vMAWB=mid(vMAWB,1,3) & "   " & AirportCode & "  " & mid(vMAWB,5,30)
	    If IsNull(rsHAWB("Shipper_Account_Number")) = False Then
		    vShipperAcct = rsHAWB("Shipper_Account_Number")
	    End If
	    If IsNull(rsHAWB("Shipper_Info")) = False Then
		    vShipperInfo = rsHAWB("Shipper_Info")
	    End If
	    If IsNull(rsHAWB("Consignee_Info")) = False Then
		    vConsigneeInfo = rsHAWB("Consignee_Info")
	    End If
	    If IsNull(rsHAWB("Consignee_acct_num")) = False Then
		    vConsigneeAcct = rsHAWB("Consignee_acct_num")
	    End If
	    If IsNull(rsHAWB("Issue_Carrier_Agent")) = False Then
		    vAgentInfo = rsHAWB("Issue_Carrier_Agent")
	    End If
	    If IsNull(rsHAWB("Agent_IATA_Code")) = False Then
		    vAgentIATACode = rsHAWB("Agent_IATA_Code")
	    End If
'///////////////////////////////////////////////
	If IsNull(rsHAWB("Account_No")) = False Then
		vAgentAcct = rsHAWB("Account_No")
	End If
	If IsNull(rsHAWB("ff_shipper_acct")) = False Then
		ff_shipper_acct = rsHAWB("ff_shipper_acct")
	End If
	If IsNull(rsHAWB("ff_consignee_acct")) = False Then
		ff_consignee_acct = rsHAWB("ff_consignee_acct")
	End If
'///////////////////////////////////////////////
	    If IsNull(rsHAWB("Departure_Airport")) = False Then
		    vDepartureAirport = rsHAWB("Departure_Airport")
	    End If
	    If IsNull(rsHAWB("to_1")) = False Then
		    vTo = rsHAWB("to_1")
	    End If
	    If IsNull(rsHAWB("by_1")) = False Then
		    vBy = rsHAWB("by_1")
	    End If
	    If IsNull(rsHAWB("to_2")) = False Then
		    vTo1 = rsHAWB("to_2")
	    End If
	    If IsNull(rsHAWB("by_2")) = False Then
		    vBy1 = rsHAWB("by_2")
	    End If
	    If IsNull(rsHAWB("to_3")) = False Then
		    vTo2 = rsHAWB("to_3")
	    End If
	    If IsNull(rsHAWB("by_2")) = False Then
		    vBy2 = rsHAWB("by_2")
	    End If
	    If IsNull(rsHAWB("Dest_Airport")) = False Then
		    vDestAirport = rsHAWB("Dest_Airport")
	    End If
	    If IsNull(rsHAWB("Flight_Date_1")) = False Then
		    vFlightDate1 = rsHAWB("Flight_Date_1")
	    End If
	    If IsNull(rsHAWB("Flight_Date_2")) = False Then
		    vFlightDate2 = rsHAWB("Flight_Date_2")
	    End If
	    If IsNull(rsHAWB("IssuedBy")) = False Then
		    vIssuedBy = rsHAWB("IssuedBy")
	    End If
	    If IsNull(rsHAWB("Account_Info")) = False Then
		    vAccountInfo = rsHAWB("Account_Info")
	    End If
	    If IsNull(rsHAWB("currency")) = False Then
		    vCurrency = rsHAWB("currency")
	    End If
	    If IsNull(rsHAWB("Charge_Code")) = False Then
		    vChargeCode = rsHAWB("Charge_Code")
	    End If
	    If IsNull(rsHAWB("PPO_1")) = False Then
		    vPPO_1 = rsHAWB("PPO_1")
		    if vPPO_1="Y" then vPPO_1="X"
	    End If
	    If IsNull(rsHAWB("COLL_1")) = False Then
		    vCOLL_1 = rsHAWB("COLL_1")
		    if vCOLL_1="Y" then vCOLL_1="X"
	    End If
	    If IsNull(rsHAWB("PPO_2")) = False Then
		    vPPO_2 = rsHAWB("PPO_2")
		    if vPPO_2="Y" then vPPO_2="X"
	    End If
	    If IsNull(rsHAWB("COLL_2")) = False Then
		    vCOLL_2 = rsHAWB("COLL_2")
		    if vCOLL_2="Y" then vCOLL_2="X"
	    End If
	    If IsNull(rsHAWB("Declared_Value_Carriage")) = False Then
		    vDeclaredValueCarriage = rsHAWB("Declared_Value_Carriage")
	    End If
	    If IsNull(rsHAWB("Declared_Value_Customs")) = False Then
		    vDeclaredValueCustoms = rsHAWB("Declared_Value_Customs")
	    End If
	    If IsNull(rsHAWB("Insurance_AMT")) = False Then
		    vInsuranceAMT = rsHAWB("Insurance_AMT")
	    End If
	    If IsNull(rsHAWB("Handling_Info")) = False Then
		    vHandlingInfo = rsHAWB("Handling_Info")
	    End If
	    If IsNull(rsHAWB("dest_country")) = False Then
		    vDestCountry = rsHAWB("dest_country")
	    End If
	    If IsNull(rsHAWB("SCI")) = False Then
		    vSCI = rsHAWB("SCI")
	    End If
	    If IsNull(rsHAWB("Total_Pieces")) = False Then
		    vTotalPiece = cLng(rsHAWB("Total_Pieces"))
	    Else
		    vTotalPiece =0
	    end if
	    If IsNull(rsHAWB("Total_Gross_Weight")) = False Then
		    vTotalGrossWeight = cDBL(rsHAWB("Total_Gross_Weight"))
	    Else
		    vTotalGrossWeight=0
	    end if
	    If IsNull(rsHAWB("Total_Weight_Charge_HAWB")) = False Then
		    vTotalWeightCharge = FormatNumber(cdbl(rsHAWB("Total_Weight_Charge_HAWB")),2)
		    hTotalWeightCharge=vTotalWeightCharge
	    Else
		    vTotalWeightCharge=0
	    end if
	    If IsNull(rsHAWB("Prepaid_Weight_Charge")) = False Then
		    vPrepaidWeightCharge = FormatNumber(cdbl(rsHAWB("Prepaid_Weight_Charge")),2)
		    hPrepaidWeightCharge=vPrepaidWeightCharge
	    Else
		    vPrepaidWeightCharge=0
	    end if
	    If IsNull(rsHAWB("Collect_Weight_Charge")) = False Then
		    vCollectWeightCharge = FormatNumber(cdbl(rsHAWB("Collect_Weight_Charge")),2)
		    hCollectWeightCharge=vCollectWeightCharge
	    Else
		    vCollectWeightCharge=0
	    end if
	    If IsNull(rsHAWB("Prepaid_Valuation_Charge")) = False Then
		    vPrepaidValuationCharge = FormatNumber(cdbl(rsHAWB("Prepaid_Valuation_Charge")),2)
		    hPrepaidValuationCharge=vPrepaidValuationCharge
	    Else
		    vPrepaidValuationCharge=0
	    end if
	    If IsNull(rsHAWB("Collect_Valuation_Charge")) = False Then
		    vCollectValuationCharge = FormatNumber(cdbl(rsHAWB("Collect_Valuation_Charge")),2)
		    hCollectValuationCharge=vCollectValuationCharge
	    Else
		    vCollectValuationCharge=0
	    end if
	    If IsNull(rsHAWB("Prepaid_Tax")) = False Then
		    vPrepaidTax = FormatNumber(cdbl(rsHAWB("Prepaid_Tax")),2)
		    hPrepaidTax=vPrepaidTax
	    Else
		    vPrepaidTax=0
	    end if
	    If IsNull(rsHAWB("Collect_Tax")) = False Then
		    vCollectTax = FormatNumber(cdbl(rsHAWB("Collect_Tax")),2)
		    hCollectTax=vCollectTax
	    Else
		    vCollectTax=0
	    end if
	    If IsNull(rsHAWB("Prepaid_Due_Agent")) = False Then
		    vPrepaidOtherChargeAgent = FormatNumber(cdbl(rsHAWB("Prepaid_Due_Agent")),2)
		    hPrepaidOtherChargeAgent=vPrepaidOtherChargeAgent
	    Else
		    vPrepaidOtherChargeAgent=0
	    end if
	    If IsNull(rsHAWB("Collect_Due_Agent")) = False Then
		    vCollectOtherChargeAgent = FormatNumber(cdbl(rsHAWB("Collect_Due_Agent")),2)
		    hCollectOtherChargeAgent=vCollectOtherChargeAgent
	    Else
		    vCollectOtherChargeAgent=0
	    end if
	    If IsNull(rsHAWB("Prepaid_Due_Carrier")) = False Then
		    vPrepaidOtherChargeCarrier = FormatNumber(cdbl(rsHAWB("Prepaid_Due_Carrier")),2)
		    hPrepaidOtherChargeCarrier=vPrepaidOtherChargeCarrier
	    Else
		    vPrepaidOtherChargeCarrier=0
	    end if
	    If IsNull(rsHAWB("Collect_Due_Carrier")) = False Then
		    vCollectOtherChargeCarrier = FormatNumber(cdbl(rsHAWB("Collect_Due_Carrier")),2)
		    hCollectOtherChargeCarrier=vCollectOtherChargeCarrier
	    Else
		    vCollectOtherChargeCarrier=0
	    end if
	    If IsNull(rsHAWB("Prepaid_Total")) = False Then
		    vPrepaidTotal = FormatNumber(cdbl(rsHAWB("Prepaid_Total")),2)
		    hPrepaidTotal=vPrepaidTotal
	    Else
		    vPrepaidTotal=0
	    end if
	    If IsNull(rsHAWB("Collect_Total")) = False Then
		    vCollectTotal = FormatNumber(cdbl(rsHAWB("Collect_Total")),2)
		    hCollectTotal=vCollectTotal
	    Else
		    vCollectTotal=0
	    end if
	    If IsNull(rsHAWB("Signature")) = False Then
		    vSignature = rsHAWB("Signature")
	    End If
	    If IsNull(rsHAWB("Date_Executed")) = False Then
		    vDateExecuted = rsHAWB("Date_Executed")
	    End If
	    If IsNull(rsHAWB("execution")) = False Then
		    vPlaceExecuted = rsHAWB("execution")
	    End If
	     If IsNull(rsHAWB("execution")) = False Then
	    vExecute=rsHAWB("execution")
	    end If
	    If IsNull(rsHAWB("Desc1")) = False Then
		    vDesc1 = rsHAWB("Desc1")
	    End If
	    If IsNull(rsHAWB("Desc2")) = False Then
		    vDesc2 = rsHAWB("Desc2")
	    End If
	    If IsNull(rsHAWB("Show_Weight_Charge_Shipper")) = False Then
		    vShowWeightChargeShipper = rsHAWB("Show_Weight_Charge_Shipper")
	    End If
	    If IsNull(rsHAWB("Show_Weight_Charge_Consignee")) = False Then
		    vShowWeightChargeConsignee=rsHAWB("Show_Weight_Charge_Consignee")
	    End If
	    If IsNull(rsHAWB("Show_Prepaid_Other_Charge_Shipper")) = False Then
		    vShowPrepaidOtherChargeShipper = rsHAWB("Show_Prepaid_Other_Charge_Shipper")
	    End If
	    If IsNull(rsHAWB("Show_Collect_Other_Charge_shipper")) = False Then
		    vShowCollectOtherChargeShipper = rsHAWB("Show_Collect_Other_Charge_shipper")
	    End If
	    If IsNull(rsHAWB("Show_Prepaid_Other_Charge_Consignee")) = False Then
		    vShowPrepaidOtherChargeConsignee = rsHAWB("Show_Prepaid_Other_Charge_Consignee")
	    End If
	    If IsNull(rsHAWB("Show_Collect_Other_Charge_Consignee")) = False Then
		    vShowCollectOtherChargeConsignee = rsHAWB("Show_Collect_Other_Charge_Consignee")
	    End If
	    If IsNull(rsHAWB("Currency_Conv_Rate")) = False Then
		    vConversionRate = FormatNumber(cdbl(rsHAWB("Currency_Conv_Rate")),2)
	    End If
	    If IsNull(rsHAWB("CC_Charge_Dest_Rate")) = False Then
		    vCCCharge = FormatNumber(cdbl(rsHAWB("CC_Charge_Dest_Rate")),2)
	    End If
	    If IsNull(rsHAWB("Charge_at_Dest")) = False Then
		    vChargeDestination = FormatNumber(cdbl(rsHAWB("Charge_at_Dest")),2)
	    End If
	    If IsNull(rsHAWB("Total_Collect_Charge")) = False Then
		    vFinalCollect = FormatNumber(cdbl(rsHAWB("Total_Collect_Charge")),2)
		    hFinalCollect=vFinalCollect
	    End If
    End IF
    rsHAWB.Close
    if Not COLODee="" then
	    SQL= "select * from mawb_weight_charge where elt_account_number = " & COLODee & " and MAWB_NUM=N'" & vMAWB & "' order by tran_no"
    else
	    SQL= "select * from mawb_weight_charge where elt_account_number = " & elt_account_number & " and MAWB_NUM=N'" & vMAWB & "' order by tran_no"
    end if
    rsHAWB.Open SQL, eltConn, , , adCmdText
    tIndex=0
    vDimension=""
    Do While Not rsHAWB.EOF
	    If IsNull(rsHAWB("Tran_No")) = False Then
		    aTranNo(tIndex) = rsHAWB("Tran_No")
	    End If
	    If IsNull(rsHAWB("No_Pieces")) = False Then
		    aPiece(tIndex) = rsHAWB("No_Pieces")
	    End If
	    'aUnitQty(tIndex)=rsHAWB("unit_qty")
	    If IsNull(rsHAWB("Gross_Weight")) = False Then
		    aGrossWeight(tIndex) = rsHAWB("Gross_Weight")
	    End If
	    If IsNull(rsHAWB("Kg_Lb")) = False Then
		    aKgLb(tIndex) = rsHAWB("Kg_Lb")
	    End If
	    If IsNull(rsHAWB("Rate_Class")) = False Then
		    aRateClass(tIndex) = rsHAWB("Rate_Class")
	    End If
	    If IsNull(rsHAWB("Commodity_Item_No")) = False Then
		    aItemNo(tIndex) = rsHAWB("Commodity_Item_No")
	    End If
	    'If IsNull(rsHAWB("Dimension")) = False Then
	    '	aDimension(tIndex) = rsHAWB("Dimension")
	    'End If
	    'If IsNull(rsHAWB("Dem_Detail")) = False Then
	    '	aDemDetail(tIndex)=rsHAWB("Dem_Detail")
	    '	vDimension=vDimension & aDemDetail(tIndex)
	    'End If
	    If IsNull(rsHAWB("Chargeable_Weight")) = False Then
		    aChargeableWeight(tIndex) = rsHAWB("Chargeable_Weight")
	    End If
	    'if (vShowWeightChargeShipper="Y" and Copy="SHIPPER") or (vShowWeightChargeConsignee="Y" and Copy="CONSIGNEE") then
	    If IsNull(rsHAWB("Rate_Charge")) = False Then
		    aRateCharge(tIndex) = cDbl(rsHAWB("Rate_Charge"))
		    if aRateCharge(tIndex)=-1 then aRateCharge(tIndex)="MIN"
	    End If
	    If IsNull(rsHAWB("Total_Charge")) = False Then
		    aTotal(tIndex) = FormatNumber(rsHAWB("Total_Charge"),2)
	    End If
	    'end if
	    rsHAWB.MoveNext
	    tIndex=tIndex+1
    Loop
    rsHAWB.Close
    'if (Copy="SHIPPER" and (vShowPrepaidOtherChargeShipper="Y" or vShowCollectOtherChargeShipper="Y")) or (vShowPrepaidOtherChargeConsignee="Y" or vShowCollectOtherChargeConsignee="Y") then
	    if Not COLODee="" then
		    SQL= "select coll_prepaid,Amt_MAWB,Charge_Desc from mawb_other_charge where elt_account_number = " & COLODee & " and MAWB_NUM=N'" & vMAWB & "' order by tran_no"
	    else
		    SQL= "select coll_prepaid,Amt_MAWB,Charge_Desc from mawb_other_charge where elt_account_number = " & elt_account_number & " and MAWB_NUM=N'" & vMAWB & "' order by tran_no"
	    end if
	    SQL= "select coll_prepaid,Amt_MAWB,Charge_Desc from mawb_other_charge where elt_account_number = " & elt_account_number & " and MAWB_NUM=N'" & vMAWB & "' order by tran_no"
	    rsHAWB.Open SQL, eltConn, , , adCmdText
	    tIndex=0
	    tIndex1=0
	    Do While Not rsHAWB.EOF
		    aCP(tIndex)=rsHAWB("coll_prepaid")
		    'if (CP="P" and vShowPrepaidOtherChargeShipper="Y" and Copy="SHIPPER") or (CP="C" and vShowCollectOtherChargeShipper="Y" and Copy="SHIPPER") or (CP="P" and vShowPrepaidOtherChargeConsignee="Y" and Copy="CONSIGNEE") or (CP="C" and vShowCollectOtherChargeConsignee="Y" and Copy="CONSIGNEE")then
		    If IsNull(rsHAWB("Amt_MAWB")) = False Then
			    aOtherCharge(tIndex) = FormatNumber(rsHAWB("Amt_MAWB"),2)
		    End If
		    If IsNull(rsHAWB("Charge_Desc")) = False Then
			    aOtherChargeDesc(tIndex) = rsHAWB("Charge_Desc")
		    End If
		    tIndex=tIndex+1
		    'end if
		    rsHAWB.MoveNext
	    Loop
	    rsHAWB.Close

	    If (Not vShowWeightChargeShipper="Y" And Copy="SHIPPER") Or (Not vShowWeightChargeConsignee="Y" And Copy="CONSIGNEE") then
		    if vPrepaidWeightCharge>0 then
			    pdfPrepaidWeightCharge="AS ARRANGED"
		    else
			    pdfPrepaidWeightCharge=""
		    end if
		    if vCollectWeightCharge>0 then
			    pdfCollectWeightCharge="AS ARRANGED"
		    else
			    pdfCollectWeightCharge=""
		    end if
		    pdfTotalWeightCharge=""
	    else
		    pdfPrepaidWeightCharge=vPrepaidWeightCharge
		    pdfCollectWeightCharge=vCollectWeightCharge
		    pdfTotalWeightCharge=vTotalWeightCharge
	    end if
	    If (Not vShowPrepaidOtherChargeShipper="Y" and Copy="SHIPPER") or (Not vShowPrepaidOtherChargeConsignee="Y" and Copy="CONSIGNEE") then
		    if vPrepaidOtherChargeAgent>0 then
			    pdfPrepaidOtherChargeAgent="AS ARRANGED"
		    else
			    pdfPrepaidOtherChargeAgent=""
		    end if
		    if vPrepaidOtherChargeCarrier>0 then
			    pdfPrepaidOtherChargeCarrier="AS ARRANGED"
		    else
			    pdfPrepaidOtherChargeCarrier=""
		    end if
	    else
		    pdfPrepaidOtherChargeAgent=vPrepaidOtherChargeAgent
		    pdfPrepaidOtherChargeCarrier=vPrepaidOtherChargeCarrier
	    end if
	    If (Not vShowCollectOtherChargeShipper="Y" And Copy="SHIPPER") or (Not vShowCollectOtherChargeConsignee="Y" and Copy="CONSIGNEE") then
		    if vCollectOtherChargeAgent>0 then
			    pdfCollectOtherChargeAgent="AS ARRANGED"
		    else
			    pdfCollectOtherChargeAgent=""
		    end if
		    if vCollectOtherChargeCarrier>0 then
			    pdfCollectOtherChargeCarrier="AS ARRANGED"
		    else
			    pdfCollectOtherChargeCarrier=""
		    end if
	    else
		    pdfCollectOtherChargeAgent=vCollectOtherChargeAgent
		    pdfCollectOtherChargeCarrier=vCollectOtherChargeCarrier
	    end if
	    If (Copy="SHIPPER" and (Not vShowWeightChargeShipper="Y" or Not vShowCollectOtherChargeShipper="Y")) or  (Copy="CONSIGNEE" and (Not vShowWeightChargeConsignee="Y" or Not vShowCollectOtherChargeCONSIGNEE="Y")) then
		    if vCollectValuationCharge>0 then
			    pdfCollectValuationCharge="AS ARRANGED"
		    else
			    pdfCollectValuationCharge=""
		    end if
		    if vCollectTax>0 then
			    pdfCollectTax="AS ARRANGED"
		    else
			    pdfCollectTax=""
		    end if
		    if vCollectTotal>0 then
			    pdfCollectTotal="AS ARRANGED"
		    else
			    pdfCollectTotal=""
		    end if
		    if vChargeDestination>0 then
			    pdfChargeDestination="AS ARRANGED"
		    else
			    pdfChargeDestination=""
		    end if
		    if vFinalCollect>0 then
			    pdfFinalCollect="AS ARRANGED"
		    else
			    pdfFinalCollect=""
		    end if
	    else
		    pdfCollectValuationCharge=vCollectValuationCharge
		    pdfCollectTax=vCollectTax
		    pdfCollectTotal=vCollectTotal
		    pdfChargeDestination=vChargeDestination
		    pdfFinalCollect=vFinalCollect
	    end if
	    If Copy="SHIPPER" and (Not vShowWeightChargeShipper="Y" or Not vShowPrepaidOtherChargeShipper="Y") or Copy="CONSIGNEE" and (Not vShowWeightChargeConsignee="Y" or Not vShowPrepaidOtherChargeConsignee="Y") then
		    if vPrepaidValuationCharge>0 then
			    pdfPrepaidValuationCharge="AS ARRANGED"
		    else
			    pdfPrepaidValuationCharge=""
		    end if
		    if vPrepaidTax>0 then
			    pdfPrepaidTax="AS ARRANGED"
		    else
			    pdfPrepaidTax=""
		    end if
		    if vPrepaidTotal>0 then
			    pdfPrepaidTotal="AS ARRANGED"
		    else
			    pdfPrepaidTotal=""
		    end if
	    else
		    pdfPrepaidValuationCharge=vPrepaidValuationCharge
		    pdfPrepaidTax=vPrepaidTax
		    pdfPrepaidTotal=vPrepaidTotal
	    end if

    oFile = Server.MapPath("../template")
    r = PDF.OpenInputFile(oFile+"/awb.pdf")
    '// LogoName="../template/logo/logo" & elt_account_number & ".pdf"
    '// r = PDF.AddLogo(LogoName, 1)

    PDF.SetFormFieldData "HAWB",vMAWB,0
    vMAWBtemp=mid(vMAWB,1,3) & "   " & AirportCode & "  " & mid(vMAWB,5,30)
    PDF.SetFormFieldData "MAWB",vMAWBtemp,0
    '// PDF.SetFormFieldData "HAWB","HAWB: " & vHAWB,0
    PDF.SetFormFieldData "ShipperInfo",vShipperInfo,0
    PDF.SetFormFieldData "ConsigneeInfo",vConsigneeInfo,0
    PDF.SetFormFieldData "AgentInfo",vAgentInfo,0
    PDF.SetFormFieldData "AgentIATACode",vAgentIATACode,0
    '///////////////////////////////////////////////
    PDF.SetFormFieldData "Account_No",vAgentAcct,0
    PDF.SetFormFieldData "ff_shipper_acct",ff_shipper_acct,0
    PDF.SetFormFieldData "ff_consignee_acct",ff_consignee_acct,0
    '///////////////////////////////////////////////

    PDF.SetFormFieldData "DepartureAirport",vDepartureAirport,0
    PDF.SetFormFieldData "To",vTo,0
    PDF.SetFormFieldData "By",vBy,0
    PDF.SetFormFieldData "To1",vTo1,0
    PDF.SetFormFieldData "By1",vBy1,0
    PDF.SetFormFieldData "To2",vTo2,0
    PDF.SetFormFieldData "By2",vBy2,0
    PDF.SetFormFieldData "DestAirport",vDestAirport,0
    PDF.SetFormFieldData "FlightDate1",vFlightDate1,0
    PDF.SetFormFieldData "FlightDate2",vFlightDate2,0
    PDF.SetFormFieldData "IssuedBy",vIssuedBy,0
    PDF.SetFormFieldData "AccountInfo",vAccountInfo,0
    PDF.SetFormFieldData "Currency",vCurrency,0
    PDF.SetFormFieldData "ChargeCode",vChargeCode,0
    PDF.SetFormFieldData "PPO_1",vPPO_1,0
    PDF.SetFormFieldData "COLL_1",vCOLL_1,0
    PDF.SetFormFieldData "PPO_2",vPPO_2,0
    PDF.SetFormFieldData "COLL_2",vCOLL_2,0
    PDF.SetFormFieldData "DeclaredValueCarriage",vDeclaredValueCarriage,0
    PDF.SetFormFieldData "DeclaredValueCustoms",vDeclaredValueCustoms,0
    PDF.SetFormFieldData "InsuranceAMT",vInsuranceAMT,0
    PDF.SetFormFieldData "HandlingInfo",vHandlingInfo,0
    PDF.SetFormFieldData "stmt1",vSTMT1,0
    PDF.SetFormFieldData "stmt2",vSTMT2,0
    PDF.SetFormFieldData "DestCountry",vDestCountry,0
    PDF.SetFormFieldData "SCI",vSCI,0
    'weight info
    PDF.SetFormFieldData "Desc2",vDesc2,0
    for i=0 to 2
	    PDF.SetFormFieldData "Pieces" & i+1,aPiece(i) & aUnitQty(i),0
	    PDF.SetFormFieldData "GrossWeight" & i+1,aGrossWeight(i),0
	    PDF.SetFormFieldData "KgLb" & i+1,aKgLb(i),0
	    PDF.SetFormFieldData "RateClass" & i+1,aRateClass(i),0
	    PDF.SetFormFieldData "ItemNo" & i+1,aItemNo(i),0
	    PDF.SetFormFieldData "ChargeableWeight" & i+1,aChargeableWeight(i),0
	    if (vShowWeightChargeShipper="Y" and Copy="SHIPPER") or (vShowWeightChargeConsignee="Y" and Copy="CONSIGNEE") then
		    pdfRateCharge=aRateCharge(i)
		    pdfTotal=aTotal(i)
	    else
		    pdfRateCharge=""
		    pdfTotal=""
	    end if
	    PDF.SetFormFieldData "RateCharge" & i+1,pdfRateCharge,0
	    PDF.SetFormFieldData "Total" & i+1,pdfTotal,0
    next
    PDF.SetFormFieldData "Dimension",vDimension,0
    PDF.SetFormFieldData "Desc1",vDesc1,0
    PDF.SetFormFieldData "TotalPiece",vTotalPiece,0
    PDF.SetFormFieldData "TotalGrossWeight",vTotalGrossWeight,0
    PDF.SetFormFieldData "TotalWeightCharge",pdfTotalWeightCharge,0
    'other info
    PDF.SetFormFieldData "PrepaidWeightCharge",pdfPrepaidWeightCharge,0
    PDF.SetFormFieldData "CollectWeightCharge",pdfCollectWeightCharge,0
    PDF.SetFormFieldData "PrepaidValuationCharge",pdfPrepaidValuationCharge,0
    PDF.SetFormFieldData "CollectValuationCharge",pdfCollectValuationCharge,0
    PDF.SetFormFieldData "PrepaidTax",pdfPrepaidTax,0
    PDF.SetFormFieldData "CollectTax",pdfCollectTax,0
    PDF.SetFormFieldData "PrepaidOtherChargeAgent",pdfPrepaidOtherChargeAgent,0
    PDF.SetFormFieldData "CollectOtherChargeAgent",pdfCollectOtherChargeAgent,0
    PDF.SetFormFieldData "PrepaidOtherChargeCarrier",pdfPrepaidOtherChargeCarrier,0
    PDF.SetFormFieldData "CollectOtherChargeCarrier",pdfCollectOtherChargeCarrier,0
    PDF.SetFormFieldData "PrepaidTotal",pdfPrepaidTotal,0
    PDF.SetFormFieldData "CollectTotal",pdfCollectTotal,0
    'PDF.SetFormFieldData "ConversionRate",vConversionRate,0
    'PDF.SetFormFieldData "CCCharge",vCCCharge,0
    'PDF.SetFormFieldData "ChargeDestination",vChargeDestination,0
    'PDF.SetFormFieldData "FinalCollect",pdfFinalCollect,0
	    vOtherCharge1=""
	    vOtherCharge2=""
	    vOtherCharge3=""
	    for i=0 to 2
		    if (aCP(i)="P" and vShowPrepaidOtherChargeShipper="Y" and Copy="SHIPPER") or (aCP(i)="C" and vShowCollectOtherChargeShipper="Y" and Copy="SHIPPER") or (aCP(i)="P" and vShowPrepaidOtherChargeConsignee="Y" and Copy="CONSIGNEE") or (aCP(i)="C" and vShowCollectOtherChargeConsignee="Y" and Copy="CONSIGNEE") then
			    vOtherCharge1=vOtherCharge1 & aOtherChargeDesc(i) & "  " & aOtherCharge(i) & "  "
		    end if
		    if (aCP(i+3)="P" and vShowPrepaidOtherChargeShipper="Y" and Copy="SHIPPER") or (aCP(i+3)="C" and vShowCollectOtherChargeShipper="Y" and Copy="SHIPPER") or (aCP(i+3)="P" and vShowPrepaidOtherChargeConsignee="Y" and Copy="CONSIGNEE") or (aCP(i+3)="C" and vShowCollectOtherChargeConsignee="Y" and Copy="CONSIGNEE") then
			    vOtherCharge2=vOtherCharge2 & aOtherChargeDesc(i+3) & "  " & aOtherCharge(i+3) & "  "
		    end if
		    if (aCP(i+6)="P" and vShowPrepaidOtherChargeShipper="Y" and Copy="SHIPPER") or (aCP(i+6)="C" and vShowCollectOtherChargeShipper="Y" and Copy="SHIPPER") or (aCP(i+6)="P" and vShowPrepaidOtherChargeConsignee="Y" and Copy="CONSIGNEE") or (aCP(i+6)="C" and vShowCollectOtherChargeConsignee="Y" and Copy="CONSIGNEE") then
			    vOtherCharge3=vOtherCharge3 & aOtherChargeDesc(i+6) & "  " & aOtherCharge(i+6) & "  "
		    end if
	    next
	    if (aCP(9)="P" and vShowPrepaidOtherChargeShipper="Y" and Copy="SHIPPER") or (aCP(9)="C" and vShowCollectOtherChargeShipper="Y" and Copy="SHIPPER") or (aCP(9)="P" and vShowPrepaidOtherChargeConsignee="Y" and Copy="CONSIGNEE") or (aCP(9)="C" and vShowCollectOtherChargeConsignee="Y" and Copy="CONSIGNEE") then
		    vOtherCharge3=vOtherCharge3 & aOtherChargeDesc(9) & "  " & aOtherCharge(9)
	    end if
    PDF.SetFormFieldData "OtherCharge1",vOtherCharge1,0
    PDF.SetFormFieldData "OtherCharge2",vOtherCharge2,0
    PDF.SetFormFieldData "OtherCharge3",vOtherCharge3,0
    PDF.SetFormFieldData "Signature",vSignature,0
    PDF.SetFormFieldData "preparedby",session_user_lname,0
    PDF.SetFormFieldData "Execute",vExecute,0
    PDF.SetFormFieldData "Copy","Copy for:" & Copy,0
    PDF.FlattenRemainingFormFields = True
	'// R = PDF.AddLogo(oFile &  "/logo/Logo" & elt_account_number & ".pdf",1)
    R=PDF.CopyForm(0, 0)
    PDF.ResetFormFields

    Set rsHAWB=Nothing
End Sub'<------------------------------------------------------------------------------------End of InsertMAWBIntoPDF

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Sub InsertSTMTIntoPDF(MAWB,AgentNo)
    'Dim MAWB,vHAWB,vAgent,vMasterAgent,vOrgAcct
    Dim aOrgInfo(5)
    Dim vAgentName
    Dim aHAWB(64),aRCVL(64),aPYBL(64),aPS(64),aDebit(64),aCredit(64),aOCarrier(64),aOAgent(64)
    Dim aAgentChg(64),aCarrierChg(64),aTotalDue(64)
    Dim rs, SQL
    Dim i
    Set rs = Server.CreateObject("ADODB.Recordset")
    'InvoiceNo=Request.QueryString("InvoiceNo")
    'MAWB=Request.QueryString("MAWB")
    'AgentNo=Request.QueryString("AgentNo")
    'vInvoiceDate=Request.QueryString("InvoiceDate")
    if Not MAWB="" And Not AgentNo="" then
    'get org info
	    SQL= "select dba_name,business_address,business_city,business_state,business_zip,business_country,business_phone from agent where elt_account_number = " & elt_account_number
	    rs.Open SQL, eltConn, , , adCmdText
	    If Not rs.EOF Then
		    aOrgInfo(0)=rs("dba_name")
		    aOrgInfo(1)=rs("business_address")
		    aOrgInfo(2)=rs("business_city") & "," & rs("business_state") & " " & rs("business_zip")
		    aOrgInfo(3)=rs("business_country")
		    aOrgInfo(4)=rs("business_phone")
	    End If
	    rs.Close
	    SQL= "select a.hawb_num,a.agent_name,a.by_1,a.departure_airport,a.flight_date_1,a.dest_airport,cast(a.account_info as nvarchar(1024)) as account_info,a.total_weight_charge_hawb,a.ppo_1,a.af_cost,a.agent_profit,a.agent_profit_share,a.other_agent_profit_carrier,other_agent_profit_agent,b.coll_prepaid,b.carrier_agent,sum(b.amt_hawb) as chg from hawb_master a LEFT OUTER JOIN hawb_other_charge b "
	    SQL=SQL & " on (a.elt_account_number=b.elt_account_number) and (a.hawb_num=b.hawb_num)"
	    SQL=SQL & " where a.elt_account_number = " & elt_account_number & " and a.mawb_num=N'" & MAWB & "' and a.agent_no=" & AgentNo
	    SQL=SQL & " group by a.hawb_num,a.agent_name,a.by_1,a.departure_airport,a.flight_date_1,a.dest_airport,cast(a.account_info as nvarchar(1024)),a.ppo_1,a.total_weight_charge_hawb,a.af_cost,a.agent_profit,a.agent_profit_share,a.other_agent_profit_carrier,a.other_agent_profit_agent,b.coll_prepaid,b.carrier_agent order by a.hawb_num,b.carrier_agent"
	    rs.Open SQL, eltConn, , , adCmdText

'// get smtp data from ocean
'///////////////////////////
	if rs.eof then
		rs.close
		SQL = get_ocean_smtp_sql
		rs.Open SQL, eltConn, , , adCmdText
	end if
'///////////////////////////

	    tIndex=0
	    if Not rs.EOF then
		    vAgentName=rs("Agent_name")
		    vCarrier=rs("by_1")
		    vDeptAirPort=rs("departure_airport")
		    vFlightNo=rs("flight_date_1")
		    vDestAirport=rs("dest_airport")
		    vFileNo=rs("account_info")
		    LastHAWB=rs("hawb_num")
		    aHAWB(0)=rs("hawb_num")
		    vFreightPrepay=rs("ppo_1")
		    if vFreightPrepay="Y" then
			    aRCVL(0)=0
		    else
			    aRCVL(0)=cDbl(rs("total_weight_charge_hawb"))
		    end if
		    if Not IsNull(rs("agent_profit")) then
			    aCredit(0)=cDbl(rs("agent_profit"))
		    else
			    aCredit(0)=0
		    end if
		    if vFreightPrepay="Y" then
			    aPYBL(0)=0
		    else
			    if Not IsNull(rs("af_cost")) then
				    aPYBL(0)=cDbl(rs("af_cost"))
			    else
				    aPYBL(0)=0
			    end if
		    end if
		    if Not IsNull(rs("other_agent_profit_carrier")) then
			    aOCarrier(0)=cDbl(rs("other_agent_profit_carrier"))
		    else
			    aOCarrier(0)=0
		    end if
		    if Not IsNull(rs("other_agent_profit_agent")) then
			    aOAgent(0)=cDbl(rs("other_agent_profit_agent"))
		    else
			    aOAgent(0)=0
		    end if
		    aTotalDue(0)=aRCVL(0)-aCredit(0)-aOAgent(0)-aOCarrier(0)
		    GrandTotal=aTotalDue(0)
		    
		    Do While Not rs.EOF
			    CurrHAWB=rs("hawb_num")
			    if Not LastHAWB=CurrHAWB then
				    tIndex=tIndex+1
				    aHAWB(tIndex)=CurrHAWB
				    vFreightPrepay=rs("ppo_1")
				    if vFreightPrepay="Y" then
					    aRCVL(tIndex)=0
				    else
					    aRCVL(tIndex)=cDbl(rs("total_weight_charge_hawb"))
				    end if
				    if Not IsNull(rs("agent_profit")) then
					    aCredit(tIndex)=cDbl(rs("agent_profit"))
				    else
					    aCredit(tIndex)=0
				    end if
				    if vFreightPrepay="Y" then
					    aPYBL(tIndex)=0
				    else
					    if Not IsNull(rs("af_cost")) then
						    aPYBL(tIndex)=cDbl(rs("af_cost"))
					    else
						    aPYBL(tIndex)=0
					    end if
				    end if
				    if Not IsNull(rs("other_agent_profit_carrier")) then
					    aOCarrier(tIndex)=cDbl(rs("other_agent_profit_carrier"))
				    else
					    aOCarrier(tIndex)=0
				    end if
				    if Not IsNull(rs("other_agent_profit_agent")) then
					    aOAgent(tIndex)=cDbl(rs("other_agent_profit_agent"))
				    else
					    aOAgent(tIndex)=0
				    end if
				    aTotalDue(tIndex)=aRCVL(tIndex)-aCredit(tIndex)-aOAgent(tIndex)-aOCarrier(tIndex)
				    GrandTotal=GrandTotal+aTotalDue(tIndex)
			    end if
			    if rs("carrier_agent")="A" then
				    if rs("coll_prepaid")="C" then
					    aAgentChg(tIndex)=cDbl(rs("chg"))
				    else
					    aAgentChg(tIndex)=0
				    end if
				    aTotalDue(tIndex)=aTotalDue(tIndex)+aAgentChg(tIndex)
				    GrandTotal=GrandTotal+aAgentChg(tIndex)
			    elseif rs("carrier_agent")="C" then
				    if rs("coll_prepaid")="C" then
					    aCarrierChg(tIndex)=cDbl(rs("chg"))
				    else
					    aCarrierChg(tIndex)=0
				    end if
				    aTotalDue(tIndex)=aTotalDue(tIndex)+aCarrierChg(tIndex)
				    GrandTotal=GrandTotal+aCarrierChg(tIndex)
			    end if
			    LastHAWB=CurrHAWB
			    rs.MoveNext
		    Loop	    
		    
	    end if
	    rs.Close
    end if
    GrandTotal="USD " & FormatNumber(GrandTotal,2)
    if tIndex="" then tIndex=1
    Dim Pages,PageMod
    Pages=Fix((tIndex+1)/4)
    PageMod=tIndex mod 4
    if PageMod<3 then Pages=Pages+1

    'oFile = Server.MapPath("../template")
    'r = PDF.OpenInputFile(oFile+"/agent_stmt.pdf")

    DIM oFile,LogoName
    oFile = Server.MapPath("../template")

    Set fso = CreateObject("Scripting.FileSystemObject")
    Dim CustomerForm
    CustomerForm=oFile & "/Customer/" & "agent_stmt" & elt_account_number & ".pdf"

    If fso.FileExists(CustomerForm) Then
    '// Customer has a specific invoice form
	    r = PDF.OpenInputFile(CustomerForm)
    Else
    '// Normal Form
	    r = PDF.OpenInputFile(oFile+"/agent_stmt.pdf")
    End If

    Set fso = nothing

    On Error Resume Next:
    
    for j=1 to Pages
	    PDF.SetFormFieldData "CompanyName",aOrgInfo(0),0
	    PDF.SetFormFieldData "Address1",aOrgInfo(1),0
	    PDF.SetFormFieldData "Address2",aOrgInfo(2),0
	    PDF.SetFormFieldData "FileNo",vFileNo,0
	    PDF.SetFormFieldData "BillTo",vAgentName,0
	    PDF.SetFormFieldData "Carrier",vCarrier,0
	    PDF.SetFormFieldData "Date",Date,0
	    PDF.SetFormFieldData "MAWB",MAWB,0
	    PDF.SetFormFieldData "Page",j,0
	    PDF.SetFormFieldData "FlightNo",vFlightNo,0
	    PDF.SetFormFieldData "DepAP",vDeptAirport,0
	    PDF.SetFormFieldData "DestAP",vDestAirport,0
	    
	    for i=(j-1)*4 to 4*j-1
		    PDF.SetFormFieldData "HAWB" & 1+i-(j-1)*4,aHAWB(i),0
		    PDF.SetFormFieldData "FreightCollect" & 1+i-(j-1)*4,FormatNumber(aRCVL(i),2),0
		    PDF.SetFormFieldData "FreightCost" & 1+i-(j-1)*4,FormatNumber(-aPYBL(i),2),0
		    PDF.SetFormFieldData "AF" & 1+i-(j-1)*4,FormatNumber((aRCVL(i)-aPYBL(i)),2),0
		    PDF.SetFormFieldData "Debit" & 1+i-(j-1)*4,FormatNumber(aRCVL(i),2),0
		    PDF.SetFormFieldData "ProfitShare" & 1+i-(j-1)*4,FormatNumber(aCredit(i),2),0
		    PDF.SetFormFieldData "OtherAgent" & 1+i-(j-1)*4,FormatNumber(aAgentChg(i),2),0
		    PDF.SetFormFieldData "OtherCarrier" & 1+i-(j-1)*4,FormatNumber(aCarrierChg(i),2),0
		    PDF.SetFormFieldData "OPSAgent" & 1+i-(j-1)*4,FormatNumber(aOAgent(i),2),0
		    PDF.SetFormFieldData "OPSCarrier" & 1+i-(j-1)*4,FormatNumber(aOCarrier(i),2),0
		    PDF.SetFormFieldData "Due" & 1+i-(j-1)*4,FormatNumber(aTotalDue(i),2),0
	    next
	    
		    PDF.SetFormFieldData "test",j & Pages,0
	    if j=Pages then
		    PDF.SetFormFieldData "GrandTotal1","Grand Total",0
		    PDF.SetFormFieldData "GrandTotal2",GrandTotal,0
	    else
		    PDF.SetFormFieldData "GrandTotal1","",0
		    PDF.SetFormFieldData "GrandTotal2","",0
	    end if
	    
	    PDF.FlattenRemainingFormFields = True
	    '// r = PDF.AddLogo(oFile &  "/logo/Logo" & elt_account_number & ".pdf",1)

	    r = PDF.CopyForm(0, 0)
	    PDF.ResetFormFields
    next
end Sub'<------------------------------------------------------------End of InsertSTMTIntoPDF

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Sub InsertHAWBIntoPDF(vHAWB,Copy)
    Dim vShipperInfo, vShipperName,vShipperAcct
    Dim vConsigneeName, vConsigneeInfo,vConsigneeAcct
    Dim vAgentInfo,vAgentIATACode,vAgentAcct,vDepartureAirport, vTo, vBy, vTo1, vBy1, vTo2, vBy2
    Dim vDestAirport,vFlightDate1,vFlightDate2
    Dim vIssuedBy,vAccountInfo
    Dim vCurrency, vChargeCode, vPPO_1, vCOLL_1, vPPO_2, vCOLL_2
    Dim vDeclaredValueCarriage, vDeclaredValueCustoms,vInsuranceAMT
    Dim vHandlingInfo, vSCI
    Dim aTranNo(3),aPiece(3),aUnitQty(3),aGrossWeight(3),aKgLb(3),aRateClass(3),aItemNo(3)
    Dim aDimension(3),aDemDetail(3),aChargeableWeight(3),aRateCharge(3),aTotal(3)
    Dim hRateCharge(3),hTotal(3)
    Dim vDesc1,vDesc2
    Dim aCarrierAgent(10),aCollectPrepaid(10),aChargeCode(10),aDesc(10),aChargeAmt(10),aVendor(10),aCost(10),aCP(10)
    Dim tIndex
    Dim vTotalPiece,vTotalGrossWeight,vTotalWeightCharge
    Dim vPrepaidWeightCharge,vCollectWeightCharge
    Dim vPrepaidValuationCharge,vCollectValuationCharge
    Dim vPrepaidTax,vCollectTax
    Dim vPrepaidOtherChargeAgent,vCollectOtherChargeAgent
    Dim vPrepaidOtherChargeCarrier,vCollectOtherChargeCarrier
    Dim vTotalPrepaid,vTotalCollect
    Dim aOtherCharge(10),aOtherChargeDesc(10)
    Dim hOtherCharge(10),hOtherChargeDesc(10)
    Dim vOtherCharge1,vOtherCharge2,vOtherCharge3
    Dim vSignature,vDateExecuted,vPlaceExecuted,vExecute
    Dim vShowWeightChargeShipper,vShowWeightChargeConsignee
    Dim vShowPrepaidOtherChargeShipper,vShowCollectOtherChargeShipper
    Dim vShowPrepaidOtherChargeConsignee,vShowCollectOtherChargeConsignee
    Dim vConversionRate,vCCCharge,vChargeDestination,vFinalCollect
'/////////////////////////////////////////////////// by ig NOV-27
    DIM ff_shipper_acct,ff_consignee_acct
'/////////////////////////////////////////////////// by ig NOV-27
    Dim i
    'Copy="CONSIGNEE"
    if UserRight=1 then Copy="CONSIGNEE"

    Dim rsHAWB, SQL
    Set rsHAWB = Server.CreateObject("ADODB.Recordset")
    'get country stmt
    
    User_country = checkBlank(Session("user_country"),"US")
    
    SQL= "select * from form_stmt where form_name='awb' and country=N'" & UserCountry & "' order by stmt_name"
    rsHAWB.Open SQL, eltConn, , , adCmdText
    Do While Not rsHAWB.EOF
	    vSTMTName=rsHAWB("stmt_name")
	    if vSTMTName="stmt1" then
		    vSTMT1=rsHAWB("stmt")
	    end if
	    if vSTMTName="stmt2" then
		    vSTMT2=rsHAWB("stmt")
	    end if
	    rsHAWB.MoveNext
    Loop
    rsHAWB.Close

    if Not COLODee="" then
	    SQL="select * from colo where colodee_elt_acct=" & COLODee & " and coloder_elt_acct=" & elt_account_number
	    rsHAWB.Open SQL, eltConn, , , adCmdText
	    if rsHAWB.EOF then
		    ErrMsg="You don't have the privilege to access this page!"
		    rsHAWB.close
		    Response.Redirect("../extra/err_msg.asp?ErrMSG=" & ErrMsg)
	    else
		    rsHAWB.close
		    COPY="CONSIGNEE"
		    SQL= "select * from hawb_master where elt_account_number = " & COLODee & " and HAWB_NUM=N'" & vHAWB & "'"
	    end if
    else
	    SQL= "select * from hawb_master where elt_account_number = " & elt_account_number & " and HAWB_NUM=N'" & vHAWB & "'"
    end if
    rsHAWB.Open SQL, eltConn, , , adCmdText
    If Not rsHAWB.EOF Then
	    If IsNull(rsHAWB("MAWB_NUM")) = False Then
		    vMAWB = rsHAWB("MAWB_NUM")
	    End If
	    AirportCode=rsHAWB("dep_airport_code")
	    'vMAWB=mid(vMAWB,1,3) & "   " & AirportCode & "  " & mid(vMAWB,5,30)
	    If IsNull(rsHAWB("Shipper_Account_Number")) = False Then
		    vShipperAcct = rsHAWB("Shipper_Account_Number")
	    End If
	    If IsNull(rsHAWB("Shipper_Info")) = False Then
		    vShipperInfo = rsHAWB("Shipper_Info")
	    End If
	    If IsNull(rsHAWB("Consignee_Info")) = False Then
		    vConsigneeInfo = rsHAWB("Consignee_Info")
	    End If
	    If IsNull(rsHAWB("Consignee_acct_num")) = False Then
		    vConsigneeAcct = rsHAWB("Consignee_acct_num")
	    End If
	    If IsNull(rsHAWB("Issue_Carrier_Agent")) = False Then
		    vAgentInfo = rsHAWB("Issue_Carrier_Agent")
	    End If
	    If IsNull(rsHAWB("Agent_IATA_Code")) = False Then
		    vAgentIATACode = rsHAWB("Agent_IATA_Code")
	    End If
	    If IsNull(rsHAWB("Account_No")) = False Then
		    vAgentAcct = rsHAWB("Account_No")
	    End If
	    If IsNull(rsHAWB("Departure_Airport")) = False Then
		    vDepartureAirport = rsHAWB("Departure_Airport")
	    End If
	    If IsNull(rsHAWB("to_1")) = False Then
		    vTo = rsHAWB("to_1")
	    End If
	    If IsNull(rsHAWB("by_1")) = False Then
		    vBy = rsHAWB("by_1")
	    End If
	    If IsNull(rsHAWB("to_2")) = False Then
		    vTo1 = rsHAWB("to_2")
	    End If
	    If IsNull(rsHAWB("by_2")) = False Then
		    vBy1 = rsHAWB("by_2")
	    End If
	    If IsNull(rsHAWB("to_3")) = False Then
		    vTo2 = rsHAWB("to_3")
	    End If
	    If IsNull(rsHAWB("by_2")) = False Then
		    vBy2 = rsHAWB("by_2")
	    End If
	    If IsNull(rsHAWB("Dest_Airport")) = False Then
		    vDestAirport = rsHAWB("Dest_Airport")
	    End If
	    If IsNull(rsHAWB("Flight_Date_1")) = False Then
		    vFlightDate1 = rsHAWB("Flight_Date_1")
	    End If
	    If IsNull(rsHAWB("Flight_Date_2")) = False Then
		    vFlightDate2 = rsHAWB("Flight_Date_2")
	    End If
	    If IsNull(rsHAWB("IssuedBy")) = False Then
		    vIssuedBy = rsHAWB("IssuedBy")
	    End If
        '///////////////////////////////////////////////
	    If IsNull(rsHAWB("Account_No")) = False Then
		    vAgentAcct = rsHAWB("Account_No")
	    End If
	    If IsNull(rsHAWB("Account_Info")) = False Then
		    vAccountInfo = rsHAWB("Account_Info")
	    End If
	    If IsNull(rsHAWB("ff_shipper_acct")) = False Then
		    ff_shipper_acct = rsHAWB("ff_shipper_acct")
	    End If
	    If IsNull(rsHAWB("ff_consignee_acct")) = False Then
		    ff_consignee_acct = rsHAWB("ff_consignee_acct")
	    End If
        '///////////////////////////////////////////////
	    If IsNull(rsHAWB("currency")) = False Then
		    vCurrency = rsHAWB("currency")
	    End If
	    If IsNull(rsHAWB("Charge_Code")) = False Then
		    vChargeCode = rsHAWB("Charge_Code")
	    End If
	    If IsNull(rsHAWB("PPO_1")) = False Then
		    vPPO_1 = rsHAWB("PPO_1")
		    if vPPO_1="Y" then vPPO_1="X"
	    End If
	    If IsNull(rsHAWB("COLL_1")) = False Then
		    vCOLL_1 = rsHAWB("COLL_1")
		    if vCOLL_1="Y" then vCOLL_1="X"
	    End If
	    If IsNull(rsHAWB("PPO_2")) = False Then
		    vPPO_2 = rsHAWB("PPO_2")
		    if vPPO_2="Y" then vPPO_2="X"
	    End If
	    If IsNull(rsHAWB("COLL_2")) = False Then
		    vCOLL_2 = rsHAWB("COLL_2")
		    if vCOLL_2="Y" then vCOLL_2="X"
	    End If
	    If IsNull(rsHAWB("Declared_Value_Carriage")) = False Then
		    vDeclaredValueCarriage = rsHAWB("Declared_Value_Carriage")
	    End If
	    If IsNull(rsHAWB("Declared_Value_Customs")) = False Then
		    vDeclaredValueCustoms = rsHAWB("Declared_Value_Customs")
	    End If
	    If IsNull(rsHAWB("Insurance_AMT")) = False Then
		    vInsuranceAMT = rsHAWB("Insurance_AMT")
	    End If
	    If IsNull(rsHAWB("Handling_Info")) = False Then
		    vHandlingInfo = rsHAWB("Handling_Info")
	    End If
	    If IsNull(rsHAWB("dest_country")) = False Then
		    vDestCountry = rsHAWB("dest_country")
	    End If
	    If IsNull(rsHAWB("SCI")) = False Then
		    vSCI = rsHAWB("SCI")
	    End If
	    If IsNull(rsHAWB("Total_Pieces")) = False Then
		    vTotalPiece = cLng(rsHAWB("Total_Pieces"))
	    Else
		    vTotalPiece =0
	    end if
	    If IsNull(rsHAWB("Total_Gross_Weight")) = False Then
		    vTotalGrossWeight = cDBL(rsHAWB("Total_Gross_Weight"))
	    Else
		    vTotalGrossWeight=0
	    end if
	    If IsNull(rsHAWB("Total_Weight_Charge_HAWB")) = False Then
		    vTotalWeightCharge = FormatNumber(cdbl(rsHAWB("Total_Weight_Charge_HAWB")),2)
		    hTotalWeightCharge=vTotalWeightCharge
	    Else
		    vTotalWeightCharge=0
	    end if
	    If IsNull(rsHAWB("Prepaid_Weight_Charge")) = False Then
		    vPrepaidWeightCharge = FormatNumber(cdbl(rsHAWB("Prepaid_Weight_Charge")),2)
		    hPrepaidWeightCharge=vPrepaidWeightCharge
	    Else
		    vPrepaidWeightCharge=0
	    end if
	    If IsNull(rsHAWB("Collect_Weight_Charge")) = False Then
		    vCollectWeightCharge = FormatNumber(cdbl(rsHAWB("Collect_Weight_Charge")),2)
		    hCollectWeightCharge=vCollectWeightCharge
	    Else
		    vCollectWeightCharge=0
	    end if
	    If IsNull(rsHAWB("Prepaid_Valuation_Charge")) = False Then
		    vPrepaidValuationCharge = FormatNumber(cdbl(rsHAWB("Prepaid_Valuation_Charge")),2)
		    hPrepaidValuationCharge=vPrepaidValuationCharge
	    Else
		    vPrepaidValuationCharge=0
	    end if
	    If IsNull(rsHAWB("Collect_Valuation_Charge")) = False Then
		    vCollectValuationCharge = FormatNumber(cdbl(rsHAWB("Collect_Valuation_Charge")),2)
		    hCollectValuationCharge=vCollectValuationCharge
	    Else
		    vCollectValuationCharge=0
	    end if
	    If IsNull(rsHAWB("Prepaid_Tax")) = False Then
		    vPrepaidTax = FormatNumber(cdbl(rsHAWB("Prepaid_Tax")),2)
		    hPrepaidTax=vPrepaidTax
	    Else
		    vPrepaidTax=0
	    end if
	    If IsNull(rsHAWB("Collect_Tax")) = False Then
		    vCollectTax = FormatNumber(cdbl(rsHAWB("Collect_Tax")),2)
		    hCollectTax=vCollectTax
	    Else
		    vCollectTax=0
	    end if
	    If IsNull(rsHAWB("Prepaid_Due_Agent")) = False Then
		    vPrepaidOtherChargeAgent = FormatNumber(cdbl(rsHAWB("Prepaid_Due_Agent")),2)
		    hPrepaidOtherChargeAgent=vPrepaidOtherChargeAgent
	    Else
		    vPrepaidOtherChargeAgent=0
	    end if
	    If IsNull(rsHAWB("Collect_Due_Agent")) = False Then
		    vCollectOtherChargeAgent = FormatNumber(cdbl(rsHAWB("Collect_Due_Agent")),2)
		    hCollectOtherChargeAgent=vCollectOtherChargeAgent
	    Else
		    vCollectOtherChargeAgent=0
	    end if
	    If IsNull(rsHAWB("Prepaid_Due_Carrier")) = False Then
		    vPrepaidOtherChargeCarrier = FormatNumber(cdbl(rsHAWB("Prepaid_Due_Carrier")),2)
		    hPrepaidOtherChargeCarrier=vPrepaidOtherChargeCarrier
	    Else
		    vPrepaidOtherChargeCarrier=0
	    end if
	    If IsNull(rsHAWB("Collect_Due_Carrier")) = False Then
		    vCollectOtherChargeCarrier = FormatNumber(cdbl(rsHAWB("Collect_Due_Carrier")),2)
		    hCollectOtherChargeCarrier=vCollectOtherChargeCarrier
	    Else
		    vCollectOtherChargeCarrier=0
	    end if
	    If IsNull(rsHAWB("Prepaid_Total")) = False Then
		    vPrepaidTotal = FormatNumber(cdbl(rsHAWB("Prepaid_Total")),2)
		    hPrepaidTotal=vPrepaidTotal
	    Else
		    vPrepaidTotal=0
	    end if
	    If IsNull(rsHAWB("Collect_Total")) = False Then
		    vCollectTotal = FormatNumber(cdbl(rsHAWB("Collect_Total")),2)
		    hCollectTotal=vCollectTotal
	    Else
		    vCollectTotal=0
	    end if
	    If IsNull(rsHAWB("Signature")) = False Then
		    vSignature = rsHAWB("Signature")
	    End If
	    If IsNull(rsHAWB("Date_Executed")) = False Then
		    vDateExecuted = rsHAWB("Date_Executed")
	    End If
	    If IsNull(rsHAWB("execution")) = False Then
		    vPlaceExecuted = rsHAWB("execution")
	    End If
	    If IsNull(rsHAWB("execution")) = False Then
	    vExecute=rsHAWB("execution")
	    end If
	    If IsNull(rsHAWB("Desc1")) = False Then
		    vDesc1 = rsHAWB("Desc1")
	    End If
	    If IsNull(rsHAWB("Desc2")) = False Then
		    vDesc2 = rsHAWB("Desc2")
	    End If
	    vLC=rsHAWB("lc")
	    vCI=rsHAWB("ci")
	    vOtherRef=rsHAWB("other_ref")
	    if Not vOtherRef="" then
		    vDesc2=vOtherRef & chr(10) & vDesc2
	    end if
	    if Not vCI="" then
		    vDesc2="INVOICE# " & vCI & chr(10) & vDesc2
	    end if
	    if Not vLC="" then
		    vDesc2="L/C# " & vLC & chr(10) & vDesc2
	    end if
	    If IsNull(rsHAWB("Show_Weight_Charge_Shipper")) = False Then
		    vShowWeightChargeShipper = rsHAWB("Show_Weight_Charge_Shipper")
	    End If
	    If IsNull(rsHAWB("Show_Weight_Charge_Consignee")) = False Then
		    vShowWeightChargeConsignee=rsHAWB("Show_Weight_Charge_Consignee")
	    End If
	    If IsNull(rsHAWB("Show_Prepaid_Other_Charge_Shipper")) = False Then
		    vShowPrepaidOtherChargeShipper = rsHAWB("Show_Prepaid_Other_Charge_Shipper")
	    End If
	    If IsNull(rsHAWB("Show_Collect_Other_Charge_shipper")) = False Then
		    vShowCollectOtherChargeShipper = rsHAWB("Show_Collect_Other_Charge_shipper")
	    End If
	    If IsNull(rsHAWB("Show_Prepaid_Other_Charge_Consignee")) = False Then
		    vShowPrepaidOtherChargeConsignee = rsHAWB("Show_Prepaid_Other_Charge_Consignee")
	    End If
	    If IsNull(rsHAWB("Show_Collect_Other_Charge_Consignee")) = False Then
		    vShowCollectOtherChargeConsignee = rsHAWB("Show_Collect_Other_Charge_Consignee")
	    End If
	    If IsNull(rsHAWB("Currency_Conv_Rate")) = False Then
		    vConversionRate = FormatNumber(cdbl(rsHAWB("Currency_Conv_Rate")),2)
	    End If
	    If IsNull(rsHAWB("CC_Charge_Dest_Rate")) = False Then
		    vCCCharge = FormatNumber(cdbl(rsHAWB("CC_Charge_Dest_Rate")),2)
	    End If
	    If IsNull(rsHAWB("Charge_at_Dest")) = False Then
		    vChargeDestination = FormatNumber(cdbl(rsHAWB("Charge_at_Dest")),2)
	    End If
	    If IsNull(rsHAWB("Total_Collect_Charge")) = False Then
		    vFinalCollect = FormatNumber(cdbl(rsHAWB("Total_Collect_Charge")),2)
		    hFinalCollect=vFinalCollect
	    End If
    End IF
    rsHAWB.Close
    if Not COLODee="" then
	    SQL= "select * from hawb_weight_charge where elt_account_number = " & COLODee & " and HAWB_NUM=N'" & vHAWB & "' order by tran_no"
    else
	    SQL= "select * from hawb_weight_charge where elt_account_number = " & elt_account_number & " and HAWB_NUM=N'" & vHAWB & "' order by tran_no"
    end if
    rsHAWB.Open SQL, eltConn, , , adCmdText
    tIndex=0
    vDimension=""
    Do While Not rsHAWB.EOF
	    If IsNull(rsHAWB("Tran_No")) = False Then
		    aTranNo(tIndex) = rsHAWB("Tran_No")
	    End If
	    If IsNull(rsHAWB("No_Pieces")) = False Then
		    aPiece(tIndex) = rsHAWB("No_Pieces")
	    End If
	    aUnitQty(tIndex)=rsHAWB("unit_qty")
	    if Copy="CONSIGNEE" then
		    If IsNull(rsHAWB("adjusted_weight")) = False Then
			    aGrossWeight(tIndex) = rsHAWB("adjusted_weight")
		    End If
	    else
		    If IsNull(rsHAWB("Gross_Weight")) = False Then
			    aGrossWeight(tIndex) = rsHAWB("Gross_Weight")
		    End If
	    end if
	    If IsNull(rsHAWB("Kg_Lb")) = False Then
		    aKgLb(tIndex) = rsHAWB("Kg_Lb")
	    End If
	    If IsNull(rsHAWB("Rate_Class")) = False Then
		    aRateClass(tIndex) = rsHAWB("Rate_Class")
	    End If
	    If IsNull(rsHAWB("Commodity_Item_No")) = False Then
		    aItemNo(tIndex) = rsHAWB("Commodity_Item_No")
	    End If
	    If IsNull(rsHAWB("Dimension")) = False Then
		    aDimension(tIndex) = rsHAWB("Dimension")
	    End If
	    If IsNull(rsHAWB("Dem_Detail")) = False Then
		    aDemDetail(tIndex)=rsHAWB("Dem_Detail")
		    vDimension=vDimension & aDemDetail(tIndex)
	    End If
	    If IsNull(rsHAWB("Chargeable_Weight")) = False Then
		    aChargeableWeight(tIndex) = rsHAWB("Chargeable_Weight")
	    End If
	    'if (vShowWeightChargeShipper="Y" and Copy="SHIPPER") or (vShowWeightChargeConsignee="Y" and Copy="CONSIGNEE") then
	    If IsNull(rsHAWB("Rate_Charge")) = False Then
		    aRateCharge(tIndex) = cDbl(rsHAWB("Rate_Charge"))
		    if aRateCharge(tIndex)=-1 then aRateCharge(tIndex)="MIN"
	    End If
	    If IsNull(rsHAWB("Total_Charge")) = False Then
		    aTotal(tIndex) = FormatNumber(rsHAWB("Total_Charge"),2)
	    End If
	    'end if
	    rsHAWB.MoveNext
	    tIndex=tIndex+1
    Loop
    rsHAWB.Close
    'if (Copy="SHIPPER" and (vShowPrepaidOtherChargeShipper="Y" or vShowCollectOtherChargeShipper="Y")) or (vShowPrepaidOtherChargeConsignee="Y" or vShowCollectOtherChargeConsignee="Y") then
	    if Not COLODee="" then
		    SQL= "select coll_prepaid,Amt_HAWB,Charge_Desc from hawb_other_charge where elt_account_number = " & COLODee & " and HAWB_NUM=N'" & vHAWB & "' order by tran_no"
	    else
		    SQL= "select coll_prepaid,Amt_HAWB,Charge_Desc from hawb_other_charge where elt_account_number = " & elt_account_number & " and HAWB_NUM=N'" & vHAWB & "' order by tran_no"
	    end if
	    SQL= "select coll_prepaid,Amt_HAWB,Charge_Desc from hawb_other_charge where elt_account_number = " & elt_account_number & " and HAWB_NUM=N'" & vHAWB & "' order by tran_no"
	    rsHAWB.Open SQL, eltConn, , , adCmdText
	    tIndex=0
	    tIndex1=0
	    Do While Not rsHAWB.EOF
		    aCP(tIndex)=rsHAWB("coll_prepaid")
		    'if (CP="P" and vShowPrepaidOtherChargeShipper="Y" and Copy="SHIPPER") or (CP="C" and vShowCollectOtherChargeShipper="Y" and Copy="SHIPPER") or (CP="P" and vShowPrepaidOtherChargeConsignee="Y" and Copy="CONSIGNEE") or (CP="C" and vShowCollectOtherChargeConsignee="Y" and Copy="CONSIGNEE")then
		    If IsNull(rsHAWB("Amt_HAWB")) = False Then
			    aOtherCharge(tIndex) = FormatNumber(rsHAWB("Amt_HAWB"),2)
		    End If
		    If IsNull(rsHAWB("Charge_Desc")) = False Then
			    aOtherChargeDesc(tIndex) = rsHAWB("Charge_Desc")
		    End If
		    tIndex=tIndex+1
		    'end if
		    rsHAWB.MoveNext
	    Loop
	    rsHAWB.Close

	    If (Not vShowWeightChargeShipper="Y" And Copy="SHIPPER") Or (Not vShowWeightChargeConsignee="Y" And Copy="CONSIGNEE") then
		    if vPrepaidWeightCharge>0 then
			    pdfPrepaidWeightCharge="AS ARRANGED"
		    else
			    pdfPrepaidWeightCharge=""
		    end if
		    if vCollectWeightCharge>0 then
			    pdfCollectWeightCharge="AS ARRANGED"
		    else
			    pdfCollectWeightCharge=""
		    end if
		    pdfTotalWeightCharge=""
	    else
		    pdfPrepaidWeightCharge=vPrepaidWeightCharge
		    pdfCollectWeightCharge=vCollectWeightCharge
		    pdfTotalWeightCharge=vTotalWeightCharge
	    end if
	    If (Not vShowPrepaidOtherChargeShipper="Y" and Copy="SHIPPER") or (Not vShowPrepaidOtherChargeConsignee="Y" and Copy="CONSIGNEE") then
		    if vPrepaidOtherChargeAgent>0 then
			    pdfPrepaidOtherChargeAgent="AS ARRANGED"
		    else
			    pdfPrepaidOtherChargeAgent=""
		    end if
		    if vPrepaidOtherChargeCarrier>0 then
			    pdfPrepaidOtherChargeCarrier="AS ARRANGED"
		    else
			    pdfPrepaidOtherChargeCarrier=""
		    end if
	    else
		    pdfPrepaidOtherChargeAgent=vPrepaidOtherChargeAgent
		    pdfPrepaidOtherChargeCarrier=vPrepaidOtherChargeCarrier
	    end if
	    If (Not vShowCollectOtherChargeShipper="Y" And Copy="SHIPPER") or (Not vShowCollectOtherChargeConsignee="Y" and Copy="CONSIGNEE") then
		    if vCollectOtherChargeAgent>0 then
			    pdfCollectOtherChargeAgent="AS ARRANGED"
		    else
			    pdfCollectOtherChargeAgent=""
		    end if
		    if vCollectOtherChargeCarrier>0 then
			    pdfCollectOtherChargeCarrier="AS ARRANGED"
		    else
			    pdfCollectOtherChargeCarrier=""
		    end if
	    else
		    pdfCollectOtherChargeAgent=vCollectOtherChargeAgent
		    pdfCollectOtherChargeCarrier=vCollectOtherChargeCarrier
	    end if
	    If (Copy="SHIPPER" and (Not vShowWeightChargeShipper="Y" or Not vShowCollectOtherChargeShipper="Y")) or  (Copy="CONSIGNEE" and (Not vShowWeightChargeConsignee="Y" or Not vShowCollectOtherChargeCONSIGNEE="Y")) then
		    if vCollectValuationCharge>0 then
			    pdfCollectValuationCharge="AS ARRANGED"
		    else
			    pdfCollectValuationCharge=""
		    end if
		    if vCollectTax>0 then
			    pdfCollectTax="AS ARRANGED"
		    else
			    pdfCollectTax=""
		    end if
		    if vCollectTotal>0 then
			    pdfCollectTotal="AS ARRANGED"
		    else
			    pdfCollectTotal=""
		    end if
		    if vChargeDestination>0 then
			    pdfChargeDestination="AS ARRANGED"
		    else
			    pdfChargeDestination=""
		    end if
		    if vFinalCollect>0 then
			    pdfFinalCollect="AS ARRANGED"
		    else
			    pdfFinalCollect=""
		    end if
	    else
		    pdfCollectValuationCharge=vCollectValuationCharge
		    pdfCollectTax=vCollectTax
		    pdfCollectTotal=vCollectTotal
		    pdfChargeDestination=vChargeDestination
		    pdfFinalCollect=vFinalCollect
	    end if
	    If Copy="SHIPPER" and (Not vShowWeightChargeShipper="Y" or Not vShowPrepaidOtherChargeShipper="Y") or Copy="CONSIGNEE" and (Not vShowWeightChargeConsignee="Y" or Not vShowPrepaidOtherChargeConsignee="Y") then
		    if vPrepaidValuationCharge>0 then
			    pdfPrepaidValuationCharge="AS ARRANGED"
		    else
			    pdfPrepaidValuationCharge=""
		    end if
		    if vPrepaidTax>0 then
			    pdfPrepaidTax="AS ARRANGED"
		    else
			    pdfPrepaidTax=""
		    end if
		    if vPrepaidTotal>0 then
			    pdfPrepaidTotal="AS ARRANGED"
		    else
			    pdfPrepaidTotal=""
		    end if
	    else
		    pdfPrepaidValuationCharge=vPrepaidValuationCharge
		    pdfPrepaidTax=vPrepaidTax
		    pdfPrepaidTotal=vPrepaidTotal
	    end If
    	
    oFile = Server.MapPath("../template")
    r = PDF.OpenInputFile(oFile+"/awb.pdf")

    '// LogoName="../template/logo/logo" & elt_account_number & ".pdf"
    '// r = PDF.AddLogo(LogoName, 1)

    vMAWBtemp=mid(vMAWB,1,3) & "   " & AirportCode & "  " & mid(vMAWB,5,30)
    PDF.SetFormFieldData "MAWB",vMAWBtemp,0
    PDF.SetFormFieldData "HAWB","HAWB: " & vHAWB,0
    PDF.SetFormFieldData "ShipperInfo",vShipperInfo,0
    PDF.SetFormFieldData "ConsigneeInfo",vConsigneeInfo,0
    PDF.SetFormFieldData "AgentInfo",vAgentInfo,0
    PDF.SetFormFieldData "AgentIATACode",vAgentIATACode,0
'///////////////////////////////////////////////
    PDF.SetFormFieldData "Account_No",vAgentAcct,0
    PDF.SetFormFieldData "ff_shipper_acct",ff_shipper_acct,0
    PDF.SetFormFieldData "ff_consignee_acct",ff_consignee_acct,0
'///////////////////////////////////////////////

    PDF.SetFormFieldData "DepartureAirport",vDepartureAirport,0
    PDF.SetFormFieldData "To",vTo,0
    PDF.SetFormFieldData "By",vBy,0
    PDF.SetFormFieldData "To1",vTo1,0
    PDF.SetFormFieldData "By1",vBy1,0
    PDF.SetFormFieldData "To2",vTo2,0
    PDF.SetFormFieldData "By2",vBy2,0
    PDF.SetFormFieldData "DestAirport",vDestAirport,0
    PDF.SetFormFieldData "FlightDate1",vFlightDate1,0
    PDF.SetFormFieldData "FlightDate2",vFlightDate2,0
    PDF.SetFormFieldData "IssuedBy",vIssuedBy,0
    PDF.SetFormFieldData "AccountInfo",vAccountInfo,0
    PDF.SetFormFieldData "Currency",vCurrency,0
    PDF.SetFormFieldData "ChargeCode",vChargeCode,0
    PDF.SetFormFieldData "PPO_1",vPPO_1,0
    PDF.SetFormFieldData "COLL_1",vCOLL_1,0
    PDF.SetFormFieldData "PPO_2",vPPO_2,0
    PDF.SetFormFieldData "COLL_2",vCOLL_2,0
    PDF.SetFormFieldData "DeclaredValueCarriage",vDeclaredValueCarriage,0
    PDF.SetFormFieldData "DeclaredValueCustoms",vDeclaredValueCustoms,0
    PDF.SetFormFieldData "InsuranceAMT",vInsuranceAMT,0
    PDF.SetFormFieldData "HandlingInfo",vHandlingInfo,0
    PDF.SetFormFieldData "stmt1",vSTMT1,0
    PDF.SetFormFieldData "stmt2",vSTMT2,0
    PDF.SetFormFieldData "DestCountry",vDestCountry,0
    PDF.SetFormFieldData "SCI",vSCI,0
    'weight info
    PDF.SetFormFieldData "Desc2",vDesc2,0
    for i=0 to 2
	    PDF.SetFormFieldData "Pieces" & i+1,aPiece(i) & aUnitQty(i),0
	    PDF.SetFormFieldData "GrossWeight" & i+1,aGrossWeight(i),0
	    PDF.SetFormFieldData "KgLb" & i+1,aKgLb(i),0
	    PDF.SetFormFieldData "RateClass" & i+1,aRateClass(i),0
	    PDF.SetFormFieldData "ItemNo" & i+1,aItemNo(i),0
	    PDF.SetFormFieldData "ChargeableWeight" & i+1,aChargeableWeight(i),0
	    if (vShowWeightChargeShipper="Y" and Copy="SHIPPER") or (vShowWeightChargeConsignee="Y" and Copy="CONSIGNEE") then
		    pdfRateCharge=aRateCharge(i)
		    pdfTotal=aTotal(i)
	    else
		    pdfRateCharge=""
		    pdfTotal=""
	    end if
	    PDF.SetFormFieldData "RateCharge" & i+1,pdfRateCharge,0
	    PDF.SetFormFieldData "Total" & i+1,pdfTotal,0
    next
    PDF.SetFormFieldData "Dimension",vDimension,0
    PDF.SetFormFieldData "Desc1",vDesc1,0
    PDF.SetFormFieldData "TotalPiece",vTotalPiece,0
    PDF.SetFormFieldData "TotalGrossWeight",vTotalGrossWeight,0
    PDF.SetFormFieldData "TotalWeightCharge",pdfTotalWeightCharge,0
    'other info
    PDF.SetFormFieldData "PrepaidWeightCharge",pdfPrepaidWeightCharge,0
    PDF.SetFormFieldData "CollectWeightCharge",pdfCollectWeightCharge,0
    PDF.SetFormFieldData "PrepaidValuationCharge",pdfPrepaidValuationCharge,0
    PDF.SetFormFieldData "CollectValuationCharge",pdfCollectValuationCharge,0
    PDF.SetFormFieldData "PrepaidTax",pdfPrepaidTax,0
    PDF.SetFormFieldData "CollectTax",pdfCollectTax,0
    PDF.SetFormFieldData "PrepaidOtherChargeAgent",pdfPrepaidOtherChargeAgent,0
    PDF.SetFormFieldData "CollectOtherChargeAgent",pdfCollectOtherChargeAgent,0
    PDF.SetFormFieldData "PrepaidOtherChargeCarrier",pdfPrepaidOtherChargeCarrier,0
    PDF.SetFormFieldData "CollectOtherChargeCarrier",pdfCollectOtherChargeCarrier,0
    PDF.SetFormFieldData "PrepaidTotal",pdfPrepaidTotal,0
    PDF.SetFormFieldData "CollectTotal",pdfCollectTotal,0
    'PDF.SetFormFieldData "ConversionRate",vConversionRate,0
    'PDF.SetFormFieldData "CCCharge",vCCCharge,0
    'PDF.SetFormFieldData "ChargeDestination",vChargeDestination,0
    'PDF.SetFormFieldData "FinalCollect",pdfFinalCollect,0
	    vOtherCharge1=""
	    vOtherCharge2=""
	    vOtherCharge3=""
	    for i=0 to 2
		    if (aCP(i)="P" and vShowPrepaidOtherChargeShipper="Y" and Copy="SHIPPER") or (aCP(i)="C" and vShowCollectOtherChargeShipper="Y" and Copy="SHIPPER") or (aCP(i)="P" and vShowPrepaidOtherChargeConsignee="Y" and Copy="CONSIGNEE") or (aCP(i)="C" and vShowCollectOtherChargeConsignee="Y" and Copy="CONSIGNEE") then
			    vOtherCharge1=vOtherCharge1 & aOtherChargeDesc(i) & "  " & aOtherCharge(i) & "  "
		    end if
		    if (aCP(i+3)="P" and vShowPrepaidOtherChargeShipper="Y" and Copy="SHIPPER") or (aCP(i+3)="C" and vShowCollectOtherChargeShipper="Y" and Copy="SHIPPER") or (aCP(i+3)="P" and vShowPrepaidOtherChargeConsignee="Y" and Copy="CONSIGNEE") or (aCP(i+3)="C" and vShowCollectOtherChargeConsignee="Y" and Copy="CONSIGNEE") then
			    vOtherCharge2=vOtherCharge2 & aOtherChargeDesc(i+3) & "  " & aOtherCharge(i+3) & "  "
		    end if
		    if (aCP(i+6)="P" and vShowPrepaidOtherChargeShipper="Y" and Copy="SHIPPER") or (aCP(i+6)="C" and vShowCollectOtherChargeShipper="Y" and Copy="SHIPPER") or (aCP(i+6)="P" and vShowPrepaidOtherChargeConsignee="Y" and Copy="CONSIGNEE") or (aCP(i+6)="C" and vShowCollectOtherChargeConsignee="Y" and Copy="CONSIGNEE") then
			    vOtherCharge3=vOtherCharge3 & aOtherChargeDesc(i+6) & "  " & aOtherCharge(i+6) & "  "
		    end if
	    next
	    if (aCP(9)="P" and vShowPrepaidOtherChargeShipper="Y" and Copy="SHIPPER") or (aCP(9)="C" and vShowCollectOtherChargeShipper="Y" and Copy="SHIPPER") or (aCP(9)="P" and vShowPrepaidOtherChargeConsignee="Y" and Copy="CONSIGNEE") or (aCP(9)="C" and vShowCollectOtherChargeConsignee="Y" and Copy="CONSIGNEE") then
		    vOtherCharge3=vOtherCharge3 & aOtherChargeDesc(9) & "  " & aOtherCharge(9)
	    end if
    PDF.SetFormFieldData "OtherCharge1",vOtherCharge1,0
    PDF.SetFormFieldData "OtherCharge2",vOtherCharge2,0
    PDF.SetFormFieldData "OtherCharge3",vOtherCharge3,0
    PDF.SetFormFieldData "Signature",vSignature,0
    PDF.SetFormFieldData "preparedby",session_user_lname,0
    PDF.SetFormFieldData "Execute",vExecute,0
    PDF.SetFormFieldData "Copy","Copy for:" & Copy,0
    PDF.FlattenRemainingFormFields = True
	'// R = PDF.AddLogo(oFile &  "/logo/Logo" & elt_account_number & ".pdf",1)
    R=PDF.CopyForm(0, 0)
    PDF.ResetFormFields

    Set rsHAWB=Nothing
End Sub'<---------------------------------------------------------------------End of InsertHAWBIntoPDF


''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Sub InsertManifestIntoPDF(vMAWB,AgentName,vAgent,MasterAgentNo,MAsterAgentName,MasterAgentPhone)
	Dim aHAWB(64),aShipperInfo(64),aAgentInfo(64)
    Dim aConsigneeInfo(64)
    Dim vOwner,vConcolidator,vFlightNo,vDateArrival
    Dim aPiece(64),aGrossWeight(64),vWeightScale
    Dim aDesc(64)
    Dim tIndex
    Dim vTotalPiece,vTotalGrossWeight
    Dim i
	oFile = Server.MapPath("../template")
	'/////////////////////////////////////////////////////////////////////////
	Set fso = CreateObject("Scripting.FileSystemObject")
	Dim CustomerForm
	CustomerForm=oFile & "/Customer/" & "Manifest" & elt_account_number & ".pdf"

	If fso.FileExists(CustomerForm) Then
	'// Customer has a specific invoice form
		r = PDF.OpenInputFile(CustomerForm)
	Else
	'// Normal Form
	    r = PDF.OpenInputFile(oFile+"/Manifest.pdf")
	End If
	Set fso = nothing
	'////////////////////////////////////////////////////////////////////////
	'// r = PDF.AddLogo(oFile &  "/logo/Logo" & elt_account_number & "_horizon.pdf",1)
    '///////////////////////////////// for ELI by iMoon
    DIM vFlightNoELI,aAgentInfoFull(64),vDateArrivalFull,vDateDepartFull
    '///////////////////////////////// 

    '// Added by Joon on Feb/28/2007 /////////////////////////////////////
    Dim aSubToNo(64),aIsSub(64)
    Dim aShipperName(64),aConsigneeName(64)
    Dim aDangerGood(64)
    '/////////////////////////////////////////////////////////////////////
    '// vTypeOfMenifest

    if vAgent="" then
	    vAgent=0
    else
	    vAgent=cLng(vAgent)
    end if
    if MasterAgentNo="" then
	    MasterAgentNo=0
    else
	    MasterAgentNo=cLng(MasterAgentNo)
    end if

    Dim rs, SQL
    Set rs = Server.CreateObject("ADODB.Recordset")

    SQL= "select dba_name,business_address,business_city,business_state,business_zip,business_country,business_phone,agent_IATA_Code from agent where elt_account_number = " & elt_account_number
    rs.Open SQL, eltConn, , , adCmdText	
    If Not rs.EOF Then
	    vFFName = rs("dba_name")
	    vFFAddress=rs("business_address")
	    vFFCity = rs("business_city")
	    vFFState = rs("business_state")
	    vFFZip = rs("business_zip")
	    vFFCountry = rs("business_country")
	    vFFPhone=rs("business_phone")
	    vFFInfo=vFFName & chr(13) & vFFAddress & chr(13) & vFFCity & "," & vFFState & " " & vFFZip & " " & vFFCountry
    end if
    rs.close
    SQL= "select a.*,b.consignee_name,b.Flight_Date_1,b.account_info from mawb_number a,mawb_master b where a.elt_account_number=b.elt_account_number and a.elt_account_number = " & elt_account_number & " and a.mawb_no=b.mawb_num and a.MAWB_No=N'" & vMAWB & "'"
    rs.Open SQL, eltConn, , , adCmdText
    if Not rs.EOF then
	    MasterAgentName=rs("consignee_name")
	    if AgentName="" then AgentName=MasterAgentName
	    If IsNull(rs("Carrier_Desc")) = False Then
		    vOwner = rs("Carrier_Desc")
	    End If
	    If IsNull(rs("Flight#1")) = False Then
		    vFlightNo = rs("Flight#1")
	    End If
	    If IsNull(rs("ETA_Date1")) = False Then
		    vDateArrival = rs("ETA_Date1")
	    End If
	    If IsNull(rs("ETA_Date2")) = False Then
		    vDateArrival = rs("ETA_Date2")
	    End If
	    POD=rs("origin_port_id")
	    ETD=rs("etd_date1")
	    vPODETD=POD & " " & ETD
	    POA=rs("dest_port_id")	

	    IF not isnull(rs("eta_date1"))then 
	        ETA=rs("eta_date1")	
	    end if 
    	
	    IF not isnull(rs("eta_date2"))then 
	        ETA=rs("eta_date2")
	    end if 
    	
	    vPOAETA=POA & " " & ETA
	    vFileNo=rs("file#")
	    vFlightNoELI=rs("Flight_Date_1")

    End If
    rs.Close

    '// Modified by Joon on Feb/28/2007 //////////////////////////////////////////////////////////////
    if not vMAWB="" then
	    if vAgent=0 or vAgent=MasterAgentNo then
		    SQL= "select sub_to_no,is_sub,hawb_num,agent_name,Total_Pieces,adjusted_Weight,Weight_Scale,Shipper_Info,Shipper_Name,Consignee_Info,Consignee_Name,manifest_desc, aes_xtn,account_info, danger_good, sed_stmt from hawb_master where isnull(is_sub,'N')='N' and  elt_account_number = " & elt_account_number & " and MAWB_NUM = N'" & vMAWB & "' order by hawb_num"
	    else
		    SQL= "select sub_to_no,is_sub,hawb_num,agent_name,Total_Pieces,adjusted_Weight,Weight_Scale,Shipper_Info,Shipper_Name,Consignee_Info,Consignee_Name,manifest_desc, aes_xtn,account_info, danger_good, sed_stmt from hawb_master where isnull(is_sub,'N')='N' and elt_account_number = " & elt_account_number & " and MAWB_NUM = N'" & vMAWB & "' and agent_no=" & vAgent & " order by sub_to_no, hawb_num"
    end if

    rs.Open SQL, eltConn, , , adCmdText
    tIndex=0
    vTotalPiece=0
    vTotalGrossWeight=0
    Do While Not rs.EOF
	    tIndex=tIndex+1
	    aHAWB(tIndex) = rs("HAWB_NUM")
	    SubAgent=rs("agent_name")
	    if vAgent=MasterAgentNo or elt_account_number = 20009000 then
		    aAgentInfo(tIndex)="Agent " & chr(10) & SubAgent
		    aAgentInfoFull(tIndex) = rs("account_info")
	    end if
	    'AgentName=rs("agent_name")
	    If IsNull(rs("Total_Pieces")) = False Then
		    aPiece(tIndex) = CInt(rs("Total_Pieces"))
		    vTotalPiece=vTotalPiece+aPiece(tIndex)
	    Else
		    aPiece(tIndex)=0
	    End If
	    If Not IsNull(rs("Weight_Scale")) Or Trim(rs("Weight_Scale")) <> "" Then
		    vWeightScale = rs("Weight_Scale")
	    end if
	    '// if vWeightScale="L" then
	    '// 	vWeightScale="LB"
	    '// Else
	    '// 	vWeightScale="KG"
	    '// end if
	    If Not IsNull(rs("adjusted_Weight")) Or Trim(rs("adjusted_Weight")) <> "" Then
		    aGrossWeight(tIndex) = CDBL(rs("adjusted_Weight"))
		    if vWeightScale="L" then
			    aGrossWeight(tIndex)=aGrossWeight(tIndex)*0.4535924
		    end if
		    vTotalGrossWeight=vTotalGrossWeight+aGrossWeight(tIndex)
	    Else
		    aGrossWeight(tIndex)=0
	    End If
	    'aGrossWeight(tIndex)=aGrossWeight(tIndex) & vWeightScale
    	
	    If IsNull(rs("Shipper_Info")) = False Then
		    aShipperInfo(tIndex)=rs("Shipper_Info")
	    End If
	    If IsNull(rs("Shipper_Name")) = False Then
		    aShipperName(tIndex)=rs("Shipper_Name")
	    End If
	    If IsNull(rs("Consignee_Info")) = False Then
		    aConsigneeInfo(tIndex)=rs("Consignee_Info")
	    End If
	    If IsNull(rs("Consignee_Name")) = False Then
		    aConsigneeName(tIndex)=rs("Consignee_Name")
	    End If
    	
	    If Not IsNull(rs("manifest_desc")) Then
	        aDesc(tIndex) = rs("manifest_desc")
	    End If
        
        If (not isNull(rs("aes_xtn"))) and rs("aes_xtn")<>"" then
            adesc(tindex) = aDesc(tIndex) & chr(13) & "AES ITN: " & rs("aes_xtn")
        Elseif (not isNull(rs("sed_stmt"))) and rs("sed_stmt")<>"" then
            aDesc(tIndex) = aDesc(tIndex) & chr(13) & rs("sed_stmt")
        End If
            

    '// Modified by Joon on Feb/28/2007 //////////////////////////////////////////////////////////////
        if not isnull(rs("sub_to_no").value) then 
    	    aSubToNo(tIndex)= rs("sub_to_no").value
	    else
		    aSubToNo(tIndex)= "N"
	    end if 
    	
	    if not isnull(rs("is_sub").value) then 
    	    aIsSub(tIndex) = rs("is_sub").value
	    else 
		    aIsSub(tIndex)= "N"
	    end if 
    	
	    aDangerGood(tIndex)=rs("danger_good").value
	    rs.MoveNext
    Loop
    rs.Close
    end if
    Set rs=Nothing

    if tIndex="" then tIndex=1
    Dim Pages,PageMod
    Pages=fix(tIndex/5)
    PageMod=tIndex mod 5
    if Not PageMod= 0 then Pages=Pages+1
    if Pages=0 then Pages=1
    i=0

    On Error Resume Next:
    '// Pages=2
    For j=1 To Pages
    '// gerenal info
        
	    If Not vMAWB = "" then
		    PDF.SetFormFieldData "FLAG_MAWB","M",0
	    End If
        PDF.SetFormFieldData "FFName",Left(vFFInfo,InStr(vFFInfo,chr(13))) & "",0
        PDF.SetFormFieldData "FFInfo",Mid(vFFInfo,InStr(vFFInfo,chr(13))+1) & "",0
	    PDF.SetFormFieldData "MAWB",vMAWB,0
	    PDF.SetFormFieldData "AgentName",AgentName,0
	    PDF.SetFormFieldData "Owner",vOwner,0
	    PDF.SetFormFieldData "FlightNo",vFlightNo,0
	    PDF.SetFormFieldData "DateArrival",vDateArrival,0
	    PDF.SetFormFieldData "Page",j & " of " & Pages,0
	    PDF.SetFormFieldData "File#",vFileNo,0

    '///////////////////////////////////////////////////// for ELI by iMoon
	    PDF.SetFormFieldData "FlightNo_ELI", vFlightNoELI, 0
	    PDF.SetFormFieldData "DateDepartFull",POD & " " & ETD,0
	    PDF.SetFormFieldData "DateArrivalFull",POA & " " & vDateArrival,0
	    '// DIM PREV_SUB_TO_NO
	    '// PREV_SUB_TO_NO=aSubToNo(0)
	    if tIndex>0 then
	        for i=(j-1)*5+1 to 5*j
			    if aIsSub(i)<> "Y" then 
				    PDF.SetFormFieldData "HAWB" & i-(j-1)*5,aHAWB(i),0
				    If Not aHAWB(i) = "" then
					    PDF.SetFormFieldData "FLAG_HAWB"& i-(j-1)*5,"H",0
				    End if
				    PDF.SetFormFieldData "MasterAgentInfo" & i-(j-1)*5,aAgentInfo(i),0
				    PDF.SetFormFieldData "MasterAgentInfoFull" & i-(j-1)*5,aAgentInfoFull(i),0
				    PDF.SetFormFieldData "Pieces" & i-(j-1)*5,aPiece(i),0
				    PDF.SetFormFieldData "GrossWeight" & i-(j-1)*5, ConvertAnyValue(aGrossWeight(i),"Long",""), 0
    				
				    If IsNull(AddInfo) Or AddInfo = "" Then
				        AddInfo = "Y"
				    End If
    				
				    If AddInfo = "Y" Then 
					    PDF.SetFormFieldData "ShipperInfo" & i-(j-1)*5,aShipperInfo(i),0
				    Else
					    PDF.SetFormFieldData "ShipperInfo" & i-(j-1)*5,aShipperName(i),0
				    End If 
    				
				    If AddInfo = "Y" Then 
					    PDF.SetFormFieldData "ConsigneeInfo" & i-(j-1)*5,aConsigneeInfo(i),0
				    Else
					    PDF.SetFormFieldData "ConsigneeInfo" & i-(j-1)*5,aConsigneeName(i),0
				    End If 
    				
				    PDF.SetFormFieldData "Desc" & i-(j-1)*5,aDesc(i),0
    				
				    if aIsSub(i)="Y" then 
					    '// if i=0 or (PREV_SUB_TO_NO <> aSubToNo(i)) then 
						    PDF.SetFormFieldData "MASTER" & i-(j-1)*5,"M/H: "&aSubToNo(i),0
					    '// end if 
					    '// PREV_SUB_TO_NO=aSubToNo(i)
				    end if 
    				
				    PDF.SetFormFieldData "HAZMAT" & i-(j-1)*5, aDangerGood(i) & "", 0
			    end if 	
		    next
	    '// if j=cInt(Pages) then
                PDF.SetFormFieldData "TotalPieces",vTotalPiece,0
			    PDF.SetFormFieldData "TotalGrossWeight", ConvertAnyValue(vTotalGrossWeight,"Long",""), 0
			    PDF.SetFormFieldData "TotalHAWB","TOTAL " & tIndex & " HAWB",0
            '// PDF.SetFormFieldData "TotalPieces",j,0
            '// PDF.SetFormFieldData "TotalGrossWeight",Pages,0
	    '// end if
	    end if

        '// r = PDF.AddLogo(oFile &  "/logo/Logo" & elt_account_number & "_horizon.pdf",1)
        PDF.FlattenRemainingFormFields = True

        r = PDF.CopyForm(0, 0)
        PDF.ResetFormFields
    Next


end Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Sub InsertInvoiceIntoPDF(InvoiceNo)

    Dim awb,vMAWB,vHAWB,vAgent,vMasterAgent,vOrgAcct
    Dim Save,NewInvoice,EditInvoice,AddItem
    Dim InvoiceDate,RefNo,InvoiceType,vInvoice_prefix,RefNo_Our
    Dim CustomerInfo,Customer
    Dim OriginDest,CustomerNumber,EntryDate,Carrier,ArrivalDept
    Dim OriginPort,DestPort,Airline
    Dim TotalPieces,TotalGrossWeight,Description
    Dim NoItem,aItemNo(400),aItemName(400),aDesc(400),aRefNo(400),aAmount(400),aCost(400),aRealCost(400)
    Dim aAR(400),aRevenue(400),aExpense(400)
    Dim aVendor(400)
    Dim aAW(400),aShare(400)
    Dim SubTotal,SaleTax,AgentProfit,TotalAmount,AR
    Dim qOrgInfo(256),qOrgName(256),qOrgAcct(256)
    Dim vOrgInfo
    Dim rs, SQL
'// by iMoon I/V Statement
    Dim v_iv_statement
    Dim i
    
	Set rs = Server.CreateObject("ADODB.Recordset")
    Set rs1 = Server.CreateObject("ADODB.Recordset")

    if Not InvoiceNo="" then
	    SQL= "select dba_name,business_address,business_city,business_state,business_zip,business_country,business_phone,business_fax,		 isnull(iv_statement,'') as iv_statement from agent where elt_account_number = " & elt_account_number
	    rs.Open SQL, eltConn, , , adCmdText	
	    If Not rs.EOF Then
		    vOrgInfo1=rs("dba_name")
		    vOrgInfo2=rs("business_address")
		    vOrgInfo2=vOrgInfo2 & chr(13) & rs("business_city") & "," & rs("business_state") & " " & rs("business_zip")
		    vOrgInfo2=vOrgInfo2 & chr(13) & rs("business_country")
		    vTelFax="Tel: " & rs("business_phone") & "    " & "Fax: " & rs("business_fax")
			v_iv_statement=rs("iv_statement")
	    End If
	    rs.Close
	    SQL= "select * from Invoice where elt_account_number = " & elt_account_number & " and invoice_no=" & InvoiceNo
	    rs.Open SQL, eltConn, , , adCmdText
	    If Not rs.EOF Then
		    InvoiceDate=rs("Invoice_Date")
		    vTerm=CLNG(rs("term_curr"))
		    if vTerm>0 then
			    InvoiceDueDate=InvoiceDate+vTerm
		    else
			    InvoiceDueDate=""
		    end if
		    RefNo=rs("ref_no")
		    if IsnUll(RefNo) then RefNo=""
		    RefNo_Our=rs("ref_no_Our")
		    if IsnUll(RefNo_Our) then RefNo_Our=""

		    orgNo=rs("customer_number")
		    CustomerInfo=rs("Customer_Info")
    '		pos=0
    '		pos=instrRev(CustomerInfo,Chr(10))
    '		if pos>0 then
    '			CustomerInfo=Mid(CustomerInfo, 1,pos)
    '		end if
    '		SQL= "select business_phone,business_fax from organization where elt_account_number = " & elt_account_number & " and org_account_number=" & OrgNo
    '		rs1.Open SQL, eltConn, , , adCmdText
    '		if Not rs1.EOF then
    '			cTel=rs1("business_phone")
    '			cFax=rs1("business_fax")
    '		end if
    '		rs1.close
    '		CustomerInfo=CustomerInfo & "Tel: " & cTel & "    Fax: " & cFax
    '		CustomerInfo=CustomerInfo & chr(13) & "ATTN: Accounts Payable"

    '		pos = 0
    '		pos=Instr(CustomerInfo,"ATTN.:")
    '		if pos>0 then
    '		else
    '			CustomerInfo=CustomerInfo & chr(13) & "ATTN.: Accounts Payable"
    '		end if	

		    TotalPieces=rs("Total_Pieces")
    		
    '		TotalGrossWeight=rs("Total_Gross_Weight") & "(G)"
    '		TotalChargeWeight=rs("Total_Charge_Weight") & "(C)"

		    If Not rs("Total_Gross_Weight") = "" Then
			    TotalGrossWeight=rs("Total_Gross_Weight") & "(G)"
		    Else
			    TotalGrossWeight=""		
		    End If
    		
		    If Not rs("Total_Charge_Weight") = "" Then
			    TotalChargeWeight=rs("Total_Charge_Weight") & "(C)"
		    Else
			    TotalChargeWeight=""		
		    End If
    		
		    If TotalGrossWeight = ""  Then
		       TotalGrossWeight = TotalChargeWeight
               TotalChargeWeight = ""
		    End if

		    Description=rs("Description")
		    if IsNull(Description) then Description=""
		    Origin=rs("Origin")
		    if IsNull(Origin) then Origin=""
		    Dest=rs("Dest")
		    if IsNull(Dest) then Dest=""
		    OrgAcct=rs("Customer_Number")
		    Customer=rs("Customer_Name")
		    if IsNull(Customer) then Customer=""
		    Shipper=rs("shipper")
		    if ISNULL(Shipper) then Shipper=""
		    Consignee=rs("consignee")
		    if IsNULL(Consignee) then Consignee=""
		    EntryNo=rs("Entry_No")
		    if IsNull(EntryNo) then EntryNo=""
		    EntryDate=rs("Entry_Date")
		    if IsNull(EntryDate) then EntryDate=""
		    Carrier=rs("Carrier")
		    if IsNull(Carrier) then Carrier=""
		    ArrivalDept=rs("Arrival_Dept")
		    if IsNull(ArrivalDept) then ArrivalDept=""
		    MAWB=rs("MAWB_NUM")
		    if IsNull(MAWB) then MAWB=""
		    HAWB=rs("HAWB_NUM")
		    if IsNull(HAWB) then HAWB=""
		    SubTotal=rs("SubTotal")
		    SaleTax=rs("Sale_Tax")
		    AgentProfit=rs("Agent_Profit")
		    if IsNull(AgentProfit) then
			    AgentProfit=0
		    else
			    AgentProfit=cDbl(AgentProfit)
		    end if
		    TotalAmount=rs("amount_charged")
		    TotalCost=rs("total_cost")
		    Remarks=rs("remarks")
		    if IsNull(Remarks) then Remarks=""
	    End If
	    rs.Close
	    SQL= "select * from invoice_charge_item where elt_account_number = " & elt_account_number & " and invoice_no=" & InvoiceNo 
	    SQL= SQL & " order by item_id" 
	    rs.Open SQL, eltConn, , , adCmdText
	    tIndex=0
	    total=0
	    Do While Not rs.EOF
		    aDesc(tIndex)=rs("item_desc")
		    aAmount(tIndex)=rs("charge_amount")
		    rs.MoveNext
		    total=total+cDbl(aAmount(tIndex))
		    tIndex=tIndex+1
	    Loop
	    rs.Close
	    total=total-AgentProfit
    end if

    '///////////////////////////// by ig_moon

    if HAWB = "0" then
	    HAWB = " "		
    end if

    if Not InvoiceNo="" then
	    SQL= "select * from user_profile where elt_account_number = " & elt_account_number
	    rs.Open SQL, eltConn, , , adCmdText	

	    If Not rs.EOF Then
		    vInvoice_prefix=rs("invoice_prefix")
	    End If
	    rs.Close
    end if


    Set rs=Nothing
    Set rs1=Nothing

    'DIM oFile
    'oFile = Server.MapPath("../template")
    'r = PDF.OpenInputFile(oFile+"/invoice.pdf")

    'PDF.SetFormFieldData "From1",vOrgInfo1,0
    'PDF.SetFormFieldData "From2",vOrgInfo2,0
    'PDF.SetFormFieldData "TelFax",vTelFax,0

    DIM oFile,LogoName
    oFile = Server.MapPath("../template")

    Set fso = CreateObject("Scripting.FileSystemObject")
    Dim CustomerForm
    CustomerForm=oFile & "/Customer/" & "Invoice" & elt_account_number & ".pdf"

    If fso.FileExists(CustomerForm) Then
    '// Customer has a specific invoice form
	    r = PDF.OpenInputFile(CustomerForm)
    Else
    '// Normal Form
	    r = PDF.OpenInputFile(oFile+"/invoice.pdf")
    End If

    Set fso = nothing
    
    '// Added by Joon on Dec-21-2006 //////////////////////////////
    Dim CustomerInfoTelFax
    'CustomerInfo = GetBusinessInfo(orgNo)
    'CustomerInfoTelFax = GetBusinessTelFax(orgNo)
    '//////////////////////////////////////////////////////////////

'//////////////////////////////////////////////////////////////////////////////////////////////////
'//    	Modified By Joon On Dec-8-2006 Uncomment following if neccessary
'//	
		CustomerInfo = Replace(UCASE(CustomerInfo), ",USA", "")
		CustomerInfo = Replace(UCASE(CustomerInfo), "USA", "")
		CustomerInfo = Replace(UCASE(CustomerInfo), "UNITED STATES", "")
		CustomerInfo = Replace(UCASE(CustomerInfo), "US", "")
'//		
		If InStr(UCASE(CustomerInfo), "TEL:") > 0 Then
		    CustomerInfoTelFax = Right(CustomerInfo, Len(CustomerInfo)-InStr(UCASE(CustomerInfo), "TEL:")+1)
		    CustomerInfo = Left(CustomerInfo, InStr(UCASE(CustomerInfo), "TEL:")-1)
		Else
	        CustomerInfoTelFax = GetBusinessTelFax(orgNo)
		End if
'       CustomerInfo = GetBusinessInfo(orgNo)
'//////////////////////////////////////////////////////////////////////////////////////////////////

    PDF.SetFormFieldData "From1",vOrgInfo1,0
    PDF.SetFormFieldData "From2",vOrgInfo2,0
    PDF.SetFormFieldData "TelFax",vTelFax,0

    if not vInvoice_prefix = "" then
    PDF.SetFormFieldData "InvoiceNo",vInvoice_prefix & "-" & InvoiceNo,0
    else
    PDF.SetFormFieldData "InvoiceNo", InvoiceNo,0
    end if

    PDF.SetFormFieldData "InvoiceDate",InvoiceDate,0
    PDF.SetFormFieldData "InvoiceDueDate",InvoiceDueDate,0
    PDF.SetFormFieldData "RefNo",RefNo,0
    PDF.SetFormFieldData "RefNo_Our",RefNo_Our,0
    PDF.SetFormFieldData "CustomerName",Left(CustomerInfo,InStr(CustomerInfo,chr(13))) & "",0
    PDF.SetFormFieldData "CustomerInfo",Mid(CustomerInfo,InStr(CustomerInfo,chr(13))+1) & "",0
    
    '// Added by Joon on Dec-21-2006 //////////////////////////////
    PDF.SetFormFieldData "CustomerTelFax", CustomerInfoTelFax, 0
    '//////////////////////////////////////////////////////////////
    
    PDF.SetFormFieldData "TotalPieces",TotalPieces,0
    PDF.SetFormFieldData "TotalGrossWeight",TotalGrossWeight,0
    PDF.SetFormFieldData "TotalChargeWeight",TotalChargeWeight,0
    PDF.SetFormFieldData "Desc",Description,0
    PDF.SetFormFieldData "Shipper",Shipper,0
    PDF.SetFormFieldData "Consignee",Consignee,0
    PDF.SetFormFieldData "Origin",Origin,0
    PDF.SetFormFieldData "Dest",Dest,0
    PDF.SetFormFieldData "OrgAcct",OrgAcct,0
    PDF.SetFormFieldData "EntryNo",EntryNo,0
    PDF.SetFormFieldData "EntryDate",EntryDate,0
    PDF.SetFormFieldData "Carrier",Carrier,0
    PDF.SetFormFieldData "ArrivalDept",ArrivalDept,0
    PDF.SetFormFieldData "MAWB",MAWB,0
    PDF.SetFormFieldData "HAWB",HAWB,0
    PDF.SetFormFieldData "Remarks",Remarks,0
    for i=0 to tIndex-1
	    PDF.SetFormFieldData "Desc" & i+1,aDesc(i),0
	    PDF.SetFormFieldData "Amount" & i+1,FormatNumber(aAmount(i),2),0
    next
        
	    if not FormatNumber(AgentProfit,2) = 0 then
    PDF.SetFormFieldData "Desc" & tIndex+1,"Agent Profit",0
    PDF.SetFormFieldData "Amount" & tIndex+1,"-" & FormatNumber(AgentProfit,2),0
        end if

    PDF.SetFormFieldData "Total",FormatNumber(Total,2),0

	'// by iMoon 2/26/2007 // default statement
	PDF.SetFormFieldData "DEFAULT_STATEMENT",v_iv_statement,0

	    '  PDF.SetHeaderFont "Helvetica", 8
	'// R = PDF.AddLogo(oFile &  "/logo/Logo" & elt_account_number & ".pdf",1)
    R=PDF.CopyForm(0, 0)


end Sub

'////////////////////////////////////////////////////////////////////////////////////////////////////
Sub InsertOceanManifestIntoPDF(vMBOL,AgentName,vAgent,MasterAgentNo,MasterAgentName,MasterAgentPhone)
'////////////////////////////////////////////////////////////////////////////////////////////////////
    Dim vMAWB, aHAWB(64),aShipperInfo(64),aAgentInfo(64)
    Dim aConsigneeInfo(64),aCBM(64)
    Dim vOwner,vConcolidator,vFlightNo,vDateArrival
    Dim aPiece(64),aGrossWeight(64),vWeightScale
    Dim aDesc(64)
    Dim tIndex
    Dim vTotalPiece,vTotalGrossWeight
    Dim i
    
    if vAgent="" then
	    vAgent=0
    else
	    vAgent=cLng(vAgent)
    end if
    if MasterAgentNo="" then
	    MasterAgentNo=0
    else
	    MasterAgentNo=cLng(MasterAgentNo)
    end if

    Dim rs, SQL
    Set rs = Server.CreateObject("ADODB.Recordset")
    SQL= "select dba_name,business_address,business_city,business_state,business_zip,business_country,business_phone,agent_IATA_Code from agent where elt_account_number = " & elt_account_number
    rs.Open SQL, eltConn, , , adCmdText	
    If Not rs.EOF Then
	    vFFName = rs("dba_name")
	    vFFAddress=rs("business_address")
	    vFFCity = rs("business_city")
	    vFFState = rs("business_state")
	    vFFZip = rs("business_zip")
	    vFFCountry = rs("business_country")
	    vFFPhone=rs("business_phone")
	    vFFInfo=vFFName & chr(13) & vFFAddress & chr(13) & vFFCity & "," & vFFState & " " & vFFZip & " " & vFFCountry
    end if
    rs.close
    SQL= "select * from ocean_booking_number where elt_account_number = " & elt_account_number & " and booking_num=N'" & vMBOL & "'"
    rs.Open SQL, eltConn, , , adCmdText
    if Not rs.EOF then
	    vCarrierName = rs("carrier_desc")
	    vDateArrival = rs("arrival_date")
	    POD=rs("origin_port_id")
	    ETD=rs("departure_date")
	    vPODETD=POD & " " & ETD
	    POA=rs("dest_port_id")
	    ETA=rs("arrival_date")
	    vPOAETA=POA & " " & ETA
	    vFlightNo = rs("vsl_name")'<--------------------------------------------- get from DB
	    vVoyageNo = rs("voyage_no")
	    vFlightNo = vFlightNo &" "& vVoyageNo'<-----------------concat here with newley applied vVoyageNo
	    vFileNo=rs("file_no")
    	
    End If
    rs.Close

    vMAWB = ""  '// IT's a real MBOL Number
    SQL= "select * from mbol_master where elt_account_number = " & elt_account_number & " and booking_num=N'" & vMBOL & "'"
    rs.Open SQL, eltConn, , , adCmdText
    if Not rs.EOF then
	    vOwner = rs("consignee_name")
	    vMAWB = rs("mbol_num")
    End If

    If vMAWB = "" Then
	    vMAWB = vMBOL
    End If

    rs.Close
    if not vMBOL="" then
	    if vAgent=0 or vAgent=MasterAgentNo then
		    SQL= "select hbol_num,agent_name,pieces,gross_weight,measurement,Shipper_Info,Consignee_Info,manifest_desc,aes_xtn,sed_stmt from hbol_master where elt_account_number = " & elt_account_number & " and booking_num = N'" & vMBOL & "' order by hbol_num"
	    else
		    SQL= "select hbol_num,agent_name,pieces,gross_weight,measurement,Shipper_Info,Consignee_Info,manifest_desc,aes_xtn,sed_stmt from hbol_master where elt_account_number = " & elt_account_number & " and booking_num = N'" & vMBOL & "' and agent_no=" & vAgent & " order by hbol_num"
	    end If

    rs.Open SQL, eltConn, , , adCmdText

    If rs.EOF then
	    rs.close
	    if vAgent=0 or vAgent=MasterAgentNo then
		    SQL= "select mbol_num,'' as hbol_num, agent_name,pieces,gross_weight,measurement,Shipper_Info,Consignee_Info,manifest_desc,'' as aes_xtn,'' as sed_stmt from mbol_master where elt_account_number = " & elt_account_number & " and booking_num = N'" & vMBOL & "' order by hbol_num"
	    else
		    SQL= "select mbol_num,'' as hbol_num,agent_name,pieces,gross_weight,measurement,Shipper_Info,Consignee_Info,manifest_desc,'' as aes_xtn,'' as sed_stmt from mhbol_master where elt_account_number = " & elt_account_number & " and booking_num = N'" & vMBOL & "' and agent_no=" & vAgent & " order by hbol_num"
	    end If
	    rs.Open SQL, eltConn, , , adCmdText
    End If

    tIndex=0
    HBOLCnt=0
    vTotalPiece=0
    vTotalGrossWeight=0
    vTotalCBM=0
    Do While Not rs.EOF
	    tIndex=tIndex+1
	    aHAWB(tIndex) = rs("hbol_num")
	    If Not Trim(aHAWB(tIndex)) = "" Then
		    HBOLCnt = HBOLCnt + 1
	    End IF
	    'SubAgent=rs("agent_name")
	    'if vAgent=MasterAgentNo then
	    '	aAgentInfo(tIndex)="Agent" & chr(10) & SubAgent
	    'end if
	    'AgentName=rs("agent_name")
	    If IsNull(rs("pieces")) = False Then
		    aPiece(tIndex) = CLNG(rs("pieces"))
		    vTotalPiece=vTotalPiece+aPiece(tIndex)
	    Else
		    aPiece(tIndex)=0
	    End If
	    If IsNull(rs("measurement")) = False Then
		    aCBM(tIndex) = Cdbl(rs("measurement"))
		    vTotalCBM=vTotalCBM+aCBM(tIndex)
	    Else
		    aCBM(tIndex)=0
	    End If
	    If IsNull(rs("gross_weight")) = False Then
		    aGrossWeight(tIndex) = CDBL(rs("gross_weight"))
		    'if vWeightScale="L" then
		    '	aGrossWeight(tIndex)=FormatNumber(aGrossWeight(tIndex)*0.454,2)
		    'end if
		    vTotalGrossWeight=vTotalGrossWeight+aGrossWeight(tIndex)
	    Else
		    aGrossWeight(tIndex)=0
	    End If
	    'aGrossWeight(tIndex)=aGrossWeight(tIndex) & vWeightScale
	    If IsNull(rs("Shipper_Info")) = False Then
		    aShipperInfo(tIndex)=rs("Shipper_Info")
	    End If
	    If IsNull(rs("Consignee_Info")) = False Then
		    aConsigneeInfo(tIndex)=rs("Consignee_Info")
	    End If
    	
	    If Not IsNull(rs("manifest_desc")) Then
	        aDesc(tIndex) = rs("manifest_desc")
	    End If
        
        If (not isNull(rs("aes_xtn"))) and rs("aes_xtn")<>"" then
            adesc(tindex) = aDesc(tIndex) & chr(13) & "AES ITN: " & rs("aes_xtn")
        Elseif (not isNull(rs("sed_stmt"))) and rs("sed_stmt")<>"" then
            aDesc(tIndex) = aDesc(tIndex) & chr(13) & rs("sed_stmt")
        End If
        
	    rs.MoveNext
    Loop
    rs.Close
    end if
    Set rs=Nothing

    if tIndex="" then tIndex=1
    Dim Pages,PageMod
    Pages=fix(tIndex/5)
    PageMod=tIndex mod 5
    if Not PageMod= 0 then Pages=Pages+1

    i=0

    response.buffer = True


    '/////////////////
    oFile = Server.MapPath("../template")
    r = PDF.OpenInputFile(oFile+"/Manifest_Ocean.pdf")
    '/////////////////

    for j=1 to Pages
    'gerenal info
        PDF.SetFormFieldData "FFName",Left(vFFInfo,InStr(vFFInfo,chr(13))) & "",0
        PDF.SetFormFieldData "FFInfo",Mid(vFFInfo,InStr(vFFInfo,chr(13))+1) & "",0
	    PDF.SetFormFieldData "MAWB",vMAWB,0
	    If Not vMBOL = "" then
		    PDF.SetFormFieldData "FLAG_MAWB","M",0
	    End If

	    PDF.SetFormFieldData "Owner",vOwner,0
	    PDF.SetFormFieldData "CarrierName",vCarrierName,0
	    PDF.SetFormFieldData "Owner",vOwner,0
	    PDF.SetFormFieldData "FlightNo",vFlightNo,0
	    PDF.SetFormFieldData "DateArrival",vDateArrival,0
	    PDF.SetFormFieldData "Page",j & " of " & Pages,0
	    PDF.SetFormFieldData "File#",vFileNo,0
	    PDF.SetFormFieldData "ETD",vPODETD,0
	    PDF.SetFormFieldData "ETA",vPOAETA,0
	    for i=(j-1)*5+1 to 5*j
		    PDF.SetFormFieldData "HAWB" & i-(j-1)*5,aHAWB(i),0
		    If Not aHAWB(i) = "" then
		    PDF.SetFormFieldData "FLAG_HAWB"& i-(j-1)*5,"H",0
		    End if
		    'PDF.SetFormFieldData "MasterAgentInfo" & i-(j-1)*5,aAgentInfo(i),0
		    PDF.SetFormFieldData "Pieces" & i-(j-1)*5,aPiece(i),0
		    PDF.SetFormFieldData "GrossWeight" & i-(j-1)*5,aGrossWeight(i),2
		    PDF.SetFormFieldData "CBM" & i-(j-1)*5,aCBM(i),2
		    PDF.SetFormFieldData "ShipperInfo" & i-(j-1)*5,aShipperInfo(i),0
		    PDF.SetFormFieldData "ConsigneeInfo" & i-(j-1)*5,aConsigneeInfo(i),0
		    PDF.SetFormFieldData "Desc" & i-(j-1)*5,aDesc(i),0
	    next
		    PDF.SetFormFieldData "TotalPieces",vTotalPiece,0
		    PDF.SetFormFieldData "TotalGrossWeight",vTotalGrossWeight,2
		    PDF.SetFormFieldData "TotalCBM",vTotalCBM,2
		    If HBOLCnt > 0 then
			    PDF.SetFormFieldData "TotalHAWB","TOTAL " & tIndex & " HBOL",0
		    End if
		    PDF.SetFormFieldData "KG","KG",0
		    PDF.SetFormFieldData "CBM","CBM",0

	    PDF.FlattenRemainingFormFields = True
	    '// r = PDF.AddLogo(oFile &  "/logo/Logo" & elt_account_number & "_horizon.pdf",1)
	    r = PDF.CopyForm(0, 0)
	    PDF.ResetFormFields
    Next

end Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Sub InsertHBOLIntoPDF(vHBOL)
    Dim rsHBOL,SQL
    Set rsHBOL = Server.CreateObject("ADODB.Recordset")

    Dim vMBOL,vBookingNum,vAgentName,vAgentInfo,vAgentAcct
    Dim vShipperName,vShipperInfo,vShipperAcct
    Dim Shipper(4),Consignee(4),Agent(3),Notify(4)
    Dim vConsigneeName,vConsigneeInfo,vConsigneeAcct,vNotifyInfo
    Dim vExportRef,vOriginCountry,vExportInstr,vLandingPier,vMoveType
    Dim ExportRef(3),ExportInstr(6)
    Dim vConYes,vPreCarriage,vPreReceiptPlace
    Dim vExportCarrier,vLandingPort,vUnloadingPort,vDepartureDate
    Dim vDeliveryPlace,vDesc1,vDesc2,vDesc3,vPieces,vWeightCP,vGrossWeight
    Dim Desc1(13),Desc2(13),Desc3(13),Desc5(5)
    Dim vMeasurement
    Dim vWidth,vLength,vHeight,vChargeableWeight,vChargeRate
    Dim vTotalWeightCharge
    Dim vShowPrepaidWeightCharge,vShowCollectWeightCharge
    Dim vShowPrepaidOtherCharge,vShowCollectOtherCharge
    Dim vOtherChargeCP,vChargeItem,vChargeAmt,vVendor,vCost
    Dim vDeclaredValue,vBy,vDate,vPlace
    Dim aChargeCP(10),aChargeItem(10),aChargeAmt(10),aChargeVendor(10),aChargeCost(10)
    Dim aChargeNo(10),aChargeItemName(10)
    Dim vTotalPrepaid,vTotalCollect,vColo
    Dim i
    
    if Not vHBOL="" then
	    SQL= "select * from hbol_master where elt_account_number = " & elt_account_number & " and hbol_num=N'" & vHBOL & "'"
		rsHBOL.Open SQL, eltConn, , , adCmdText
	    vConYes="Y"
	    vDate=Now
	    vTotalPrepaid=0
	    vTotalCollect=0
	    if Not rsHBOL.EOF then
		    vBookingNum=rsHBOL("booking_num")
		    vMBOL=rsHBOL("mbol_num")
		    vShipperName=rsHBOL("shipper_name")
		    vShipperInfo=rsHBOL("shipper_info")
		    vShipperAcct=cLng(rsHBOL("shipper_acct_num"))
		    vConsigneeName=rsHBOL("consignee_name")
		    vConsigneeInfo=rsHBOL("consignee_info")
		    vConsigneeAcct=cLng(rsHBOL("consignee_acct_num"))
		    vNotifyInfo=rsHBOL("notify_info")
		    vExportRef=rsHBOL("export_ref")
		    vAgentInfo=rsHBOL("forward_agent_info")
		    vOriginCountry=rsHBOL("origin_country")
		    vExportInstr=rsHBOL("export_instr")
		    vLoadingPier=rsHBOL("loading_pier")
		    vMoveType=rsHBOL("move_type")
		    vConYes=rsHBOL("containerized")
		    If vConYes="Y" then
			    vConYes="X"
			    vConNo=""
		    else
			    vConYes=""
			    vConNo="X"
		    end if
		    vPreCarriage=rsHBOL("pre_carriage")
		    vPreReceiptPlace=rsHBOL("pre_receipt_place")
		    vExportCarrier=rsHBOL("export_carrier")
		    vLoadingPort=rsHBOL("loading_port")
		    vUnloadingPort=rsHBOL("unloading_port")
		    vDeliveryPlace=rsHBOL("delivery_place")
		    vDepartureDate=rsHBOL("departure_date")
		    vWeightCP=rsHBOL("weight_cp")
		    vPieces=rsHBOL("pieces")
		    'vScale=rsHBOL("scale")
		    'if vScale="K" then
			    vGrossWeight=cDbl(rsHBOL("gross_weight"))
			    vLb=Round(vGrossWeight*2.204,2)
			    vMeasurement=cDbl(rsHBOL("measurement"))
			    vCF=Round(vMeasurement*35.31,2)
		    'else
			    'vLb=cDbl(rsHBOL("gross_weight"))
			    'vGrossWeight=Round(vLb*0.454,2)
			    'vCF=cDbl(rsHBOL("measurement"))
			    'vMeasurement=Round(vCF/35.31,2)
		    'end if
		    vDesc6=vGrossWeight & " KG" & "  " & vMeasurement & " CBM"
		    vDesc7=vLb & " LB" & "  " & vCF & " CF"
		    'vLength=rsHBOL("length")
		    'vWidth=rsHBOL("width")
		    'vHeight=rsHBOL("height")
		    'vChargeableWeight=rsHBOL("chargeable_weight")
		    'vChargeRate=rsHBOL("charge_rate")
		    vTotalWeightCharge=cDbl(rsHBOL("total_weight_charge"))
		    vDesc1=rsHBOL("desc1")
		    vDesc2=rsHBOL("desc2")
		    vDesc3=rsHBOL("desc3")
			On error resume Next:
			vColo=rs("colo")
    '///////////////////////////////////////////////////////////////////////////////////////////////////////////
    '//  by ig at 2006.6.20		
		    if Not Trim(vDesc3)="" Then
			    If InStr(vDesc3,"SAID TO CONTAIN:") <= 0 Then
				    vDesc3="SAID TO CONTAIN:" & chr(13) & vDesc3
			    End if
		    end If
    '///////////////////////////////////////////////////////////////////////////////////////////////////////////

		    vDesc4=rsHBOL("desc4")
		    vDesc5=rsHBOL("desc5")
		    vShowPrepaidWeightCharge=rsHBOL("show_prepaid_weight_charge")
		    vShowCollectWeightCharge=rsHBOL("show_collect_weight_charge")
		    vShowPrepaidOtherCharge=rsHBOL("show_prepaid_other_charge")
		    vShowCollectOtherCharge=rsHBOL("show_collect_other_charge")
		    vDeclaredValue=FormatNumber(rsHBOL("declared_value"),2)
		    vDate=rsHBOL("tran_date")
		    vBy=rsHBOL("tran_by")
		    vPlace=rsHBOL("tran_place")
	    end if
	    rsHBOL.Close
	    SQL= "select * from hbol_other_charge where elt_account_number = " & elt_account_number & " and hbol_num=N'" & vHBOL & "' order by tran_no"
	    rsHBOL.Open SQL, eltConn, , , adCmdText
	    tIndex=0
	    Do while Not rsHBOL.EOF
		    aChargeNo(tIndex)=rsHBOL("tran_no")
		    aChargeCP(tIndex)=rsHBOL("coll_prepaid")
		    aChargeItem(tIndex)=rsHBOL("charge_code")
		    aChargeItemName(tIndex)=rsHBOL("charge_desc")
		    aChargeAmt(tIndex)=cDbl(rsHBOL("charge_amt"))
		    'aChargeVendor(tIndex)=cLng(rsHBOL("vendor_num"))
		    'aChargeCost(tIndex)=rsHBOL("cost_amt")
		    if aChargeCP(tIndex)="P" then
			    if vShowPrepaidOtherCharge="Y" then
				    vTotalPrepaid=vTotalPrepaid+aChargeAmt(tIndex)
				    aChargeAmt(tIndex)=FormatNumber(aChargeAmt(tIndex),2)
			    else
				    aChargeAmt(tIndex)=""
				    aChargeItemName(tIndex)=""
			    end if
		    else
			    if vShowCollectOtherCharge="Y" then
				    vTotalCollect=vTotalCollect+aChargeAmt(tIndex)
				    aChargeAmt(tIndex)=FormatNumber(aChargeAmt(tIndex),2)
			    else
				    aChargeAmt(tIndex)=""
				    aChargeItemName(tIndex)=""
			    end if
		    end if
		    rsHBOL.MoveNext
		    tIndex=tIndex+1
	    Loop
	    rsHBOL.Close
	    if vWeightCP="P" then
		    if vShowPrepaidWeightCharge="Y" then
			    vTotalPrepaid=vTotalPrepaid+vTotalWeightCharge
			    vTotalWeightCharge=FormatNumber(vTotalWeightCharge,2)
		    else
			    vTotalWeightCharge=""
		    end if
	    else
		    if vShowCollectWeightCharge="Y" then
			    vTotalCollect=vTotalCollect+vTotalWeightCharge
			    vTotalWeightCharge=FormatNumber(vTotalWeightCharge,2)
		    else
			    vTotalWeightCharge=""
		    end if
	    end if
	    vTotalPrepaid=FormatNumber(vTotalPrepaid,2)
	    vTotalCollect=FormatNumber(vTotalCollect,2)
	    if vTotalPrepaid="0.00" then vTotalPrepaid=""
	    if vTotalCollect="0.00" then vTotalCollect=""
    end if
    'get country stmt
    
    User_country = checkBlank(Session("user_country"),"US")
    
    SQL= "select * from form_stmt where form_name='bol' and country=N'" & UserCountry & "' order by stmt_name"
    rsHBOL.Open SQL, eltConn, , , adCmdText
    Do While Not rsHBOL.EOF
	    vSTMTName=rsHBOL("stmt_name")
	    if vSTMTName="stmt1" then
		    vSTMT1=rsHBOL("stmt")
	    end if
	    if vSTMTName="stmt2" then
		    vSTMT2=rsHBOL("stmt")
	    end if
	    if vSTMTName="stmt3" then
		    vSTMT3=rsHBOL("stmt")
	    end if
	    if vSTMTName="stmt4" then
		    vSTMT4=rsHBOL("stmt")
	    end if
	    rsHBOL.MoveNext
    Loop
    rsHBOL.Close
    'get ff name
    SQL= "select dba_name from agent where elt_account_number=" & elt_account_number
    rsHBOL.Open SQL, eltConn, , , adCmdText
    if Not rsHBOL.EOF then
	    vFFName=rsHBOL("dba_name")
    end if
    rsHBOL.close
    Set rsHBOL=Nothing

'////////////////////////////////////// disabled by iMoon 11/6/2006
'    DIM oFile
'    oFile = Server.MapPath("../template")
'    r = PDF.OpenInputFile(oFile+"/bol.pdf")


'///////////////////////
'// by iMoon 11/6/2006

DIM oFile
oFile = Server.MapPath("../template")

'/////////////////////////////////////////////////////////////////////////
Set fso = CreateObject("Scripting.FileSystemObject")
Dim CustomerForm
CustomerForm=oFile & "/Customer/" & "bol_" & elt_account_number & ".pdf"

If fso.FileExists(CustomerForm) Then
'// Customer has a specific bol form
	r = PDF.OpenInputFile(CustomerForm)

Else
'// Normal Form
	r = PDF.OpenInputFile(oFile+"/bol.pdf")
End If
Set fso = nothing
'////////////////////////////////////////////////////////////////////////


    On Error Resume Next:
    '// Added By Joon on Feb/23/2007
    PDF.SetFormFieldData "PageTitleLeft","MASTER BILL OF LADING",0
    PDF.SetFormFieldData "PageTitleRight","INSTRUCTION",0  
    PDF.SetFormFieldData "TopName",vFFName & "",0
    
    '// Air 7 Seas Request
    CarrierSQL = "SELECT carrier_desc FROM ocean_booking_number WHERE ISNULL(carrier_code,0)<>0 AND " _
        & "booking_num=N'" & vBookingNum & "' AND elt_account_number=" & elt_account_number
    PDF.SetFormFieldData "AgentForTheCarrier", GETSQLResult(CarrierSQL, Null), 0

    PDF.SetFormFieldData "FF_Name",vFFName,0
    PDF.SetFormFieldData "ShipperInfo",vShipperInfo,0
    PDF.SetFormFieldData "ConsigneeInfo",vConsigneeInfo,0
    PDF.SetFormFieldData "NotifyInfo",vNotifyInfo,0
    PDF.SetFormFieldData "PreCarriage",vPreCarriage,0
    PDF.SetFormFieldData "PreReceiptPlace",vPreReceiptPlace,0
    PDF.SetFormFieldData "ExportCarrier",vExportCarrier,0
    PDF.SetFormFieldData "LoadingPort",vLoadingPort,0
    PDF.SetFormFieldData "DeliveryPlace",vDeliveryPlace,0
    PDF.SetFormFieldData "UnloadingPort",vUnloadingPort,0
    PDF.SetFormFieldData "BookingNum",vBookingNum,0
    PDF.SetFormFieldData "HBOL",vHBOL,0
    PDF.SetFormFieldData "ExportRef",vExportRef,0
    PDF.SetFormFieldData "AgentInfo",vAgentInfo,0
    PDF.SetFormFieldData "OriginCountry",vOriginCountry,0
    PDF.SetFormFieldData "ExportInstr",vExportInstr,0
    PDF.SetFormFieldData "LoadingPier",vLoadingPier,0
    PDF.SetFormFieldData "MoveType",vMoveType,0
    PDF.SetFormFieldData "ConYes",vConYes,0
    PDF.SetFormFieldData "ConNo",vConNo,0
    'weight info
	PDF.SetFormFieldData "Desc1",vDesc1,0
	PDF.SetFormFieldData "Desc2",vDesc2,0
	PDF.SetFormFieldData "Desc3",vDesc3,0
	PDF.SetFormFieldData "stmt4",vSTMT4,0
	If IsNull(vDesc4) Then vDesc4 = ""
	PDF.SetFormFieldData "Desc4",vDesc4,0
	PDF.SetFormFieldData "Desc5",vDesc5,0
	'PDF.SetFormFieldData "WeightKG",vGrossWeight & " KG",0
	'PDF.SetFormFieldData "WeightLB",vLb & " LB",0
	'PDF.SetFormFieldData "MeasureCBM",vMeasurement & " CBM",0
	'PDF.SetFormFieldData "MeasureCF",vCF & " CF",0
	PDF.SetFormFieldData "DeclaredValue",vDeclaredValue,0
	PDF.SetFormFieldData "STMT1",vSTMT1,0
	PDF.SetFormFieldData "STMT2",vSTMT2,0
	PDF.SetFormFieldData "STMT3",vSTMT3,0

'other info
PDF.SetFormFieldData "OceanFreight","Ocean Freight",0
'/////////////////////
if vWeightCP="P" then
	PDF.SetFormFieldData "PrepaidWeightCharge",vTotalWeightCharge,0
else
	PDF.SetFormFieldData "CollectWeightCharge",vTotalWeightCharge,0
end if
'/////////////////////

'///////////////////// for Air7Seas
'On error resume Next:
if cDbl(vTotalWeightCharge) > 0 then
	if vWeightCP="P" then
		PDF.SetFormFieldData "prePaidYes","X",0
	else
		PDF.SetFormFieldData "collectYes","X",0
	end if
end if
'/////////////////////


for i=0 to 9

	PDF.SetFormFieldData "ChargeItemName" & i+1,aChargeItemName(i),0
	if aChargeCP(i)="P" then
		PDF.SetFormFieldData "PrepaidChargeAmt" & i+1,aChargeAmt(i),0
	else
		PDF.SetFormFieldData "CollectChargeAmt" & i+1,aChargeAmt(i),0
	end if
	
	'///////////////////// for Air7Seas
	On error resume Next:
	if cDbl(aChargeAmt(i)) > 0 then
		if aChargeCP(i)="P" then
			PDF.SetFormFieldData "prePaidYes","X",0
		else
			PDF.SetFormFieldData "collectYes","X",0
		end if
	end if
	'/////////////////////

next

	PDF.SetFormFieldData "TotalPrepaid",vTotalPrepaid,0
    PDF.SetFormFieldData "TotalCollect",vTotalCollect,0

'//////////////////////////////////////
On error resume Next:
if vColo = "Y" then
	PDF.SetFormFieldData "coloaderYes","X",0
else
	PDF.SetFormFieldData "shippers_stowlYes","X",0
end if
'//////////////////////////////////////

    PDF.SetFormFieldData "Place",vPlace,0
    PDF.SetFormFieldData "By",vBy,0

    On error resume Next:
    if vDate = "" or isnull(vDate) then
	     vDate=now 
    end if
    vDate= Month(vDate) & "/" & Day(vDate) & "/" & Year(vDate)
    PDF.SetFormFieldData "Date",vDate,0

	PDF.SetFormFieldData "Date",vDate,0
    PDF.FlattenRemainingFormFields = True
    '// R = PDF.AddLogo(oFile &  "/logo/Logo" & elt_account_number & ".pdf",1)
    R=PDF.CopyForm(0, 0)
    PDF.ResetFormFields
End Sub


Function GetBusinessInfo(arg)
    Dim result,sqlTxt,rsObj
    result = ""
    sqlTxt = "SELECT dba_name,business_address,business_city," _
        & "business_state,business_zip,business_country FROM " _
        & "organization WHERE elt_account_number=" & elt_account_number & " and org_account_number=" & arg
    Set rsObj = Server.CreateObject("ADODB.Recordset")
    rsObj.Open sqlTxt, eltConn, , , adCmdText
    
    If Not rsObj.EOF And Not rsObj.BOF Then
    
        result = rsObj("dba_name").value & chr(13) _
            & rsObj("business_address").value & chr(13) _
            & checkBlank(rsObj("business_city").value,"")
        
        If checkBlank(rsObj("business_state").value,"") <> "" Then
            result = result & ","
        End If
        
        result = result & checkBlank(rsObj("business_state").value,"")
        
        If checkBlank(rsObj("business_zip").value,"") <> "" Then
            result = result & " "
        End If            
        
        result = result & checkBlank(rsObj("business_zip").value,"")
        
        If checkBlank(rsObj("business_country").value,"") <> "" Then
            result = result & chr(13)
        End If 
        
        result = result & checkBlank(rsObj("business_country").value,"")        
    End If
    GetBusinessInfo = result
End Function


Function GetBusinessTelFax(arg)
    Dim result,sqlTxt,rsObj
    result = ""
    sqlTxt = "SELECT business_phone,business_fax FROM " _
        & "organization WHERE elt_account_number="&elt_account_number&" and org_account_number=" & arg
    Set rsObj = Server.CreateObject("ADODB.Recordset")
    
    On Error Resume Next:
    rsObj.Open sqlTxt, eltConn, , , adCmdText
    
    If Not rsObj.EOF And Not rsObj.BOF Then
        If checkBlank(rsObj("business_phone").value,"") <> "" Then
            result = "Tel: " & checkBlank(rsObj("business_phone").value,"")
        End If
        
        If checkBlank(rsObj("business_fax").value,"") <> "" Then
            result = result & "  " & "Fax: " _
                & checkBlank(rsObj("business_fax").value,"")
        End If
    End If
    GetBusinessTelFax = result
End Function

%>
<!--  #INCLUDE FILE="../acct_tasks/stmt_ocean_sql.inc" -->
