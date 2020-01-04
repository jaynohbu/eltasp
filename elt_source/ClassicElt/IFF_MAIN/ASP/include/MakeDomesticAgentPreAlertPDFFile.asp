<%

Sub InsertMAWBIntoPDF(vMAWB,Copy)

    Dim vHAWB,vShipperInfo, vShipperName,vShipperAcct
    Dim vConsigneeName, vConsigneeInfo,vConsigneeAcct
    Dim vAgentIATACode,vDepartureAirport, vTo, vBy, vTo1, vBy1, vTo2, vBy2
    Dim vDestAirport,vFlightDate1,vFlightDate2
    Dim vIssuedBy,vAccountInfo
    Dim vChargeCode, vPPO_1, vCOLL_1, vPPO_2, vCOLL_2
    Dim vDeclaredValueCarriage, vInsuranceAMT
    Dim aTranNo(3),aPiece(3),aGrossWeight(3),aKgLb(3),aRateClass(3),aItemNo(3)
    Dim aDimension(3),aDemDetail(3),aChargeableWeight(3),aRateCharge(3),aTotal(3)
    Dim hRateCharge(3),hTotal(3)
    Dim vDesc1,vDesc2
    Dim aCarrierAgent(10),aCollectPrepaid(10),aChargeCode(10),aDesc(10),aChargeAmt(10),aVendor(10),aCost(10)
    Dim tIndex,vHandlingInfo
    Dim vTotalPiece,vTotalGrossWeight,vTotalWeightCharge
    Dim vPrepaidWeightCharge,vCollectWeightCharge
    Dim vPrepaidValuationCharge,vCollectValuationCharge
    Dim vPrepaidTax,vCollectTax
    Dim vPrepaidOtherChargeAgent,vCollectOtherChargeAgent
    Dim vPrepaidOtherChargeCarrier,vCollectOtherChargeCarrier
    Dim vTotalPrepaid,vTotalCollect
    Dim aOtherCharge(10),aOtherChargeDesc(10)
    Dim hOtherCharge(10),hOtherChargeDesc(10)
    Dim vOtherCharge
    Dim vDateExecuted,vPlaceExecuted,vExecute
    Dim vShowWeightChargeShipper,vShowWeightChargeConsignee
    Dim vShowPrepaidOtherChargeShipper,vShowCollectOtherChargeShipper
    Dim vShowPrepaidOtherChargeConsignee,vShowCollectOtherChargeConsignee
    Dim vConversionRate,vCCCharge,vChargeDestination,vFinalCollect
    Dim vknowshipper,vunknowshipper,vitem_U,FAA_NU
    Dim vCOD_A,vFFA,vPC,vDC
    Dim vODC,vOAC,vCODFEE,vOTHERCAD
    Dim vDOOA,vDODA,vITP,vITC 
    DIM ff_shipper_acct,ff_consignee_acct
    Dim i

    Dim rsHAWB, SQL
    Set rsHAWB = Server.CreateObject("ADODB.Recordset")

    Dim vSTMT1,vSTMT2
    
    User_country = checkBlank(Session("user_country"),"US")
    
    SQL= "select * from form_stmt where form_name='awb' and country='" & User_country & "' order by stmt_name"
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

    SQL= "select * from mawb_master where elt_account_number = " & elt_account_number & " and MAWB_NUM = '" & vMAWB & "'"
    
    rsHAWB.Open SQL, eltConn, , , adCmdText
    If Not rsHAWB.EOF Then
	    AirportCode=rsHAWB("dep_airport_code")
	    If IsNull(rsHAWB("Shipper_Info")) = False Then
		    vShipperInfo = rsHAWB("Shipper_Info")
	    End If
	    If IsNull(rsHAWB("Consignee_Info")) = False Then
		    vConsigneeInfo = rsHAWB("Consignee_Info")
	    End If
	    If IsNull(rsHAWB("Agent_IATA_Code")) = False Then
		    vAgentIATACode = rsHAWB("Agent_IATA_Code")
	    End If

	    If IsNull(rsHAWB("ff_shipper_acct")) = False Then
		    ff_shipper_acct = rsHAWB("ff_shipper_acct")
	    End If
	    If IsNull(rsHAWB("ff_consignee_acct")) = False Then
		    ff_consignee_acct = rsHAWB("ff_consignee_acct")
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
	    If IsNull(rsHAWB("Account_Info")) = False Then
		    vAccountInfo = rsHAWB("Account_Info")
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
	    If IsNull(rsHAWB("Insurance_AMT")) = False Then
		    vInsuranceAMT = rsHAWB("Insurance_AMT")
	    End If
	    If IsNull(rsHAWB("Handling_Info")) = False Then
		    vHandlingInfo = rsHAWB("Handling_Info")
	    End If
	    If IsNull(rsHAWB("Total_Pieces")) = False Then
		    vTotalPiece = cLng(rsHAWB("Total_Pieces"))
	    End If
	    If IsNull(rsHAWB("Total_Gross_Weight")) = False Then
		    vTotalGrossWeight = cDbl(rsHAWB("Total_Gross_Weight"))
	    End If
	    If IsNull(rsHAWB("Total_Weight_Charge_HAWB")) = False Then
		    vTotalWeightCharge = FormatAmount(cDBL(rsHAWB("Total_Weight_Charge_HAWB")))
		    hTotalWeightCharge=vTotalWeightCharge
	    End If
	    If IsNull(rsHAWB("Prepaid_Weight_Charge")) = False Then
		    vPrepaidWeightCharge = FormatAmount(cDBL(rsHAWB("Prepaid_Weight_Charge")))
		    hPrepaidWeightCharge=vPrepaidWeightCharge
	    End If
	    If IsNull(rsHAWB("Collect_Weight_Charge")) = False Then
		    vCollectWeightCharge = FormatAmount(cDBL(rsHAWB("Collect_Weight_Charge")))
		    hCollectWeightCharge=vCollectWeightCharge
	    End If
	    If IsNull(rsHAWB("Prepaid_Valuation_Charge")) = False Then
		    vPrepaidValuationCharge = FormatAmount(cDBL(rsHAWB("Prepaid_Valuation_Charge")))
		    hPrepaidValuationCharge=vPrepaidValuationCharge
	    End If
	    If IsNull(rsHAWB("Collect_Valuation_Charge")) = False Then
		    vCollectValuationCharge = FormatAmount(cDBL(rsHAWB("Collect_Valuation_Charge")))
		    hCollectValuationCharge=vCollectValuationCharge
	    End If
	    If IsNull(rsHAWB("Prepaid_Tax")) = False Then
		    vPrepaidTax = FormatAmount(cDBL(rsHAWB("Prepaid_Tax")))
		    hPrepaidTax=vPrepaidTax
	    End If
	    If IsNull(rsHAWB("Collect_Tax")) = False Then
		    vCollectTax = FormatAmount(cDBL(rsHAWB("Collect_Tax")))
		    hCollectTax=vCollectTax
	    End If
	    If IsNull(rsHAWB("Prepaid_Due_Agent")) = False Then
		    vPrepaidOtherChargeAgent = FormatAmount(cDBL(rsHAWB("Prepaid_Due_Agent")))
		    hPrepaidOtherChargeAgent=vPrepaidOtherChargeAgent
	    End If
	    If IsNull(rsHAWB("Collect_Due_Agent")) = False Then
		    vCollectOtherChargeAgent = FormatAmount(cDBL(rsHAWB("Collect_Due_Agent")))
		    hCollectOtherChargeAgent=vCollectOtherChargeAgent
	    End If
	    If IsNull(rsHAWB("Prepaid_Due_Carrier")) = False Then
		    vPrepaidOtherChargeCarrier = FormatAmount(cDBL(rsHAWB("Prepaid_Due_Carrier")))
		    hPrepaidOtherChargeCarrier=vPrepaidOtherChargeCarrier
	    End If
	    If IsNull(rsHAWB("Collect_Due_Carrier")) = False Then
		    vCollectOtherChargeCarrier = FormatAmount(cDBL(rsHAWB("Collect_Due_Carrier")))
		    hCollectOtherChargeCarrier=vCollectOtherChargeCarrier
	    End If
	    If IsNull(rsHAWB("Prepaid_Total")) = False Then
		    vPrepaidTotal = FormatAmount(cDBL(rsHAWB("Prepaid_Total")))
		    hPrepaidTotal=vPrepaidTotal
	    End If
	    If IsNull(rsHAWB("Collect_Total")) = False Then
		    vCollectTotal = FormatAmount(cDBL(rsHAWB("Collect_Total")))
		    hCollectTotal=vCollectTotal
	    End If
	    If IsNull(rsHAWB("Date_Executed")) = False Then
		    vDateExecuted = rsHAWB("Date_Executed")
	    End If

	    If IsNull(rsHAWB("known_shipper")) = False Then
		    vknowshipper = rsHAWB("known_shipper")
	    End If
	    If IsNull(rsHAWB("unknown_shipper")) = False Then
		    vunknowshipper = rsHAWB("unknown_shipper")
	    End If
	    If IsNull(rsHAWB("item_under_16")) = False Then
		    vitem_U = rsHAWB("item_under_16")
	    End If
	    If IsNull(rsHAWB("cod_amount")) = False Then
		    vCOD_A = FormatAmount(rsHAWB("cod_amount"))
	    End If
	    If IsNull(rsHAWB("iac_num")) = False Then
		    vFFA = rsHAWB("iac_num")
	    End If
    	
	    If IsNull(rsHAWB("delivery_charge")) = False Then
		    vDC = FormatAmount(cDBL(rsHAWB("delivery_charge")))
	    End If
	    If IsNull(rsHAWB("pickup_charge")) = False Then
		    vPC = FormatAmount(cDBL(rsHAWB("pickup_charge")))
	    End If
	    If IsNull(rsHAWB("COD_FEE")) = False Then
		    vCODFEE = FormatAmount(cDBL(rsHAWB("COD_FEE")))
	    End If
	    If IsNull(rsHAWB("item_collect")) = False Then
		    vITC = FormatAmount(rsHAWB("item_collect"))
	    End If
	    If IsNull(rsHAWB("item_prepaid")) = False Then
		    vITP = FormatAmount(rsHAWB("item_prepaid"))
	    End If
	    If IsNull(rsHAWB("other_charge")) = False Then
		    vOTHERCAD = FormatAmount(cDBL(rsHAWB("other_charge")))
	    End If
	    If IsNull(rsHAWB("origin_adv_charge_desc")) = False Then
		    vDOOA = rsHAWB("origin_adv_charge_desc")
	    End If
	    If IsNull(rsHAWB("dest_adv_charge_desc")) = False Then
		    vDODA = rsHAWB("dest_adv_charge_desc")
	    End If
	    If IsNull(rsHAWB("origin_adv_charge")) = False Then
		    vOAC = FormatAmount(cDBL(rsHAWB("origin_adv_charge")))
	    End If
	    If IsNull(rsHAWB("dest_adv_charge")) = False Then
		    vODC = FormatAmount(cDBL(rsHAWB("dest_adv_charge")))
	    End If
    
	    vExecute=rsHAWB("execution")

	    If IsNull(rsHAWB("Desc1")) = False Then
		    vDesc1 = rsHAWB("Desc1")
	    End If
	    If IsNull(rsHAWB("Desc2")) = False Then
		    vDesc2 = rsHAWB("Desc2")
	    End If

        vShowWeightChargeShipper = "Y"

	    If Not vShowWeightChargeShipper="Y" And Copy="SHIPPER" then
		    if vPrepaidWeightCharge>0 then 
			    vPrepaidWeightCharge="AS ARRANGED"
		    else
			    vPrepaidWeightCharge=""
		    end if
		    if vCollectWeightCharge>0 then 
			    vCollectWeightCharge="AS ARRANGED"
		    else
			    vCollectWeightCharge=""
		    end if
		    vTotalWeightCharge=""
	    end if

        vShowWeightChargeConsignee = "Y"

	    If Not vShowWeightChargeConsignee="Y" then
		    if hPrepaidWeightCharge>0 then 
			    hPrepaidWeightCharge="AS ARRANGED"
		    else
			    hPrepaidWeightCharge=""
		    end if
		    if hCollectWeightCharge>0 then 
			    hCollectWeightCharge="AS ARRANGED"
		    else
			    hCollectWeightCharge=""
		    end if
		    hTotalWeightCharge=""
		    if Copy="CONSIGNEE" then
			    if vPrepaidWeightCharge>0 then 
				    vPrepaidWeightCharge="AS ARRANGED"
			    else
				    vPrepaidWeightCharge=""
			    end if
			    if vCollectWeightCharge>0 then 
				    vCollectWeightCharge="AS ARRANGED"
			    else
				    vCollectWeightCharge=""
			    end if
			    vTotalWeightCharge=""
		    end if
	    end if

        vShowPrepaidOtherChargeShipper = "Y"

	    If Not vShowPrepaidOtherChargeShipper="Y" and Copy="SHIPPER" then 
		    if vPrepaidOtherChargeAgent>0 then
			    vPrepaidOtherChargeAgent="AS ARRANGED"
		    else
			    vPrepaidOtherChargeAgent=""
		    end if
		    if vPrepaidOtherChargeCarrier>0 then
			    vPrepaidOtherChargeCarrier="AS ARRANGED"
		    else
			    vPrepaidOtherChargeCarrier=""
		    end if
	    end if

        vShowCollectOtherChargeShipper = "Y"

	    If Not vShowCollectOtherChargeShipper="Y" And Copy="SHIPPER" then 
		    if vCollectOtherChargeAgent>0 then
			    vCollectOtherChargeAgent="AS ARRANGED"
		    else
			    vCollectOtherChargeAgent=""
		    end if
		    if vCollectOtherChargeCarrier>0 then
			    vCollectOtherChargeCarrier="AS ARRANGED"
		    else
			    vCollectOtherChargeCarrier=""
		    end if
	    end if

        vShowPrepaidOtherChargeConsignee = "Y"

	    If Not vShowPrepaidOtherChargeConsignee="Y" then
		    if hPrepaidOtherChargeAgent>0 then
			    hPrepaidOtherChargeAgent="AS ARRANGED"
		    else
			    hPrepaidOtherChargeAgent=""
		    end if
		    if hPrepaidOtherChargeCarrier>0 then
			    hPrepaidOtherChargeCarrier="AS ARRANGED"
		    else
			    hPrepaidOtherChargeCarrier=""
		    end if
		    if Copy="CONSIGNEE" then 
			    if vPrepaidOtherChargeAgent>0 then
				    vPrepaidOtherChargeAgent="AS ARRANGED"
			    else
				    vPrepaidOtherChargeAgent=""
			    end if
			    if vPrepaidOtherChargeCarrier>0 then
				    vPrepaidOtherChargeCarrier="AS ARRANGED"
			    else
				    vPrepaidOtherChargeCarrier=""
			    end if
		    end if
	    end if

        vShowCollectOtherChargeConsignee = "Y"

	    If Not vShowCollectOtherChargeConsignee="Y" then
		    if hCollectOtherChargeAgent>0 then
			    hCollectOtherChargeAgent="AS ARRANGED"
		    else
			    hCollectOtherChargeAgent=""
		    end if
		    if hCollectOtherChargeCarrier>0 then
			    hCollectOtherChargeCarrier="AS ARRANGED"
		    else
			    hCollectOtherChargeCarrier=""
		    end if
		    if Copy="CONSIGNEE" then 
			    if vCollectOtherChargeAgent>0 then
				    vCollectOtherChargeAgent="AS ARRANGED"
			    else
				    vCollectOtherChargeAgent=""
			    end if
			    if vCollectOtherChargeCarrier>0 then
				    vCollectOtherChargeCarrier="AS ARRANGED"
			    else
				    vCollectOtherChargeCarrier=""
			    end if
		    end if
	    end if
	    If IsNull(rsHAWB("Currency_Conv_Rate")) = False Then
		    vConversionRate = FormatAmount(cdbl(rsHAWB("Currency_Conv_Rate")))
	    End If
	    If IsNull(rsHAWB("CC_Charge_Dest_Rate")) = False Then
		    vCCCharge = FormatAmount(cdbl(rsHAWB("CC_Charge_Dest_Rate")))
	    End If
	    If IsNull(rsHAWB("Charge_at_Dest")) = False Then
		    vChargeDestination = FormatAmount(cdbl(rsHAWB("Charge_at_Dest")))
	    End If
	    If IsNull(rsHAWB("Total_Collect_Charge")) = False Then
		    vFinalCollect = FormatAmount(cdbl(rsHAWB("Total_Collect_Charge")))
		    hFinalCollect=vFinalCollect
	    End If
	    If Not vShowWeightChargeConsignee="Y" or Not vShowCollectOtherChargeCONSIGNEE="Y" then 
		    if hCollectValuationCharge>0 then
			    hCollectValuationCharge="AS ARRANGED"
		    else
			    hCollectValuationCharge=""
		    end if
		    if hCollectTax>0 then
			    hCollectTax="AS ARRANGED"
		    else
			    hCollectTax=""
		    end if
		    if hCollectTotal>0 then
			    hCollectTotal="AS ARRANGED"
		    else
			    hCollectTotal=""
		    end if
		    if hChargeDestination>0 then
			    hChargeDestination="AS ARRANGED"
		    else
			    hChargeDestination=""
		    end if
		    if hFinalCollect>0 then
			    hFinalCollect="AS ARRANGED"
		    else
			    hFinalCollect=""
		    end if
	    end if
	    If (Copy="SHIPPER" and (Not vShowWeightChargeShipper="Y" or Not vShowCollectOtherChargeShipper="Y")) or  (Copy="CONSIGNEE" and (Not vShowWeightChargeConsignee="Y" or Not vShowCollectOtherChargeCONSIGNEE="Y")) then 
		    if vCollectValuationCharge>0 then
			    vCollectValuationCharge="AS ARRANGED"
		    else
			    vCollectValuationCharge=""
		    end if
		    if vCollectTax>0 then
			    vCollectTax="AS ARRANGED"
		    else
			    vCollectTax=""
		    end if
		    if vCollectTotal>0 then
			    vCollectTotal="AS ARRANGED"
		    else
			    vCollectTotal=""
		    end if
		    if vChargeDestination>0 then
			    vChargeDestination="AS ARRANGED"
		    else
			    vChargeDestination=""
		    end if
		    if vFinalCollect>0 then
			    vFinalCollect="AS ARRANGED"
		    else
			    vFinalCollect=""
		    end if
	    end if
	    If Not vShowWeightChargeConsignee="Y" or Not vShowPrepaidOtherChargeConsignee="Y" then 
		    if hPrepaidValuationCharge>0 then
			    hPrepaidValuationCharge="AS ARRANGED"
		    else
			    hPrepaidValuationCharge=""
		    end if
		    if hPrepaidTax>0 then
			    hPrepaidTax="AS ARRANGED"
		    else
			    hPrepaidTax=""
		    end if
		    if vPrepaidTotal>0 then
			    hPrepaidTotal="AS ARRANGED"
		    else
			    hPrepaidTotal=""
		    end if
	    end if
	    If Copy="SHIPPER" and (Not vShowWeightChargeShipper="Y" or Not vShowPrepaidOtherChargeShipper="Y") or Copy="CONSIGNEE" and (Not vShowWeightChargeConsignee="Y" or Not vShowPrepaidOtherChargeConsignee="Y") then 
		    if vPrepaidValuationCharge>0 then
			    vPrepaidValuationCharge="AS ARRANGED"
		    else
			    vPrepaidValuationCharge=""
		    end if
		    if vPrepaidTax>0 then
			    vPrepaidTax="AS ARRANGED"
		    else
			    vPrepaidTax=""
		    end if
		    if vPrepaidTotal>0 then
			    vPrepaidTotal="AS ARRANGED"
		    else
			    vPrepaidTotal=""
		    end if
	    end if
    End IF
    rsHAWB.Close
    SQL= "select * from mawb_weight_charge where elt_account_number = " & elt_account_number & " and MAWB_NUM = '" & vMAWB & "' order by tran_no"
    rsHAWB.Open SQL, eltConn, , , adCmdText
    tIndex=0
    Do While Not rsHAWB.EOF 
	    If IsNull(rsHAWB("Tran_No")) = False Then
		    aTranNo(tIndex) = rsHAWB("Tran_No")
	    End If	
	    If IsNull(rsHAWB("No_Pieces")) = False Then
		    aPiece(tIndex) = rsHAWB("No_Pieces")
	    End If
	    If IsNull(rsHAWB("Gross_Weight")) = False Then
		    aGrossWeight(tIndex) = formatAmount(rsHAWB("Gross_Weight"))
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
	    If IsNull(rsHAWB("Chargeable_Weight")) = False Then
		    aChargeableWeight(tIndex) = formatAmount(rsHAWB("Chargeable_Weight"))
	    End If
	    if (vShowWeightChargeShipper="Y" and Copy="SHIPPER") or  (vShowWeightChargeConsignee="Y" and Copy="CONSIGNEE") then
		    If IsNull(rsHAWB("Rate_Charge")) = False Then
			    aRateCharge(tIndex) = formatAmount(rsHAWB("Rate_Charge"))
			    if aRateCharge(i)="0" then 
		            aRateCharge(tIndex)=""
		        end if
		    End If
		    If IsNull(rsHAWB("Total_Charge")) = False Then
			    aTotal(tIndex) = formatAmount(rsHAWB("Total_Charge"))
		    End If
	    end if
	    if vShowWeightChargeConsignee="Y" then
		    If IsNull(rsHAWB("Rate_Charge")) = False Then
			    hRateCharge(tIndex) = formatAmount(rsHAWB("Rate_Charge"))
			    if hRateCharge(i)="0" then 
		            hRateCharge(tIndex)=""
		        end if
		    End If
		    If IsNull(rsHAWB("Total_Charge")) = False Then
			    hTotal(tIndex) = formatAmount(rsHAWB("Total_Charge"))
		    End If
	    end if
	    rsHAWB.MoveNext
	    tIndex=tIndex+1
    Loop
    rsHAWB.Close
    if (Copy="SHIPPER" and (vShowPrepaidOtherChargeShipper="Y" or vShowCollectOtherChargeShipper="Y")) or (COPY="CONSIGNEE" and (vShowPrepaidOtherChargeConsignee="Y" or vShowCollectOtherChargeConsignee="Y")) then
	    SQL= "select coll_prepaid,Amt_MAWB,Charge_Desc from mawb_other_charge where elt_account_number = " & elt_account_number & " and MAWB_NUM = '" & vMAWB & "' order by tran_no"
	    rsHAWB.Open SQL, eltConn, , , adCmdText
	    tIndex=0
	    tIndex1=0
	    Do While Not rsHAWB.EOF 
		    CP=rsHAWB("coll_prepaid")
		    if (CP="P" and vShowPrepaidOtherChargeShipper="Y" and Copy="SHIPPER") or (CP="C" and vShowCollectOtherChargeShipper="Y" and Copy="SHIPPER") or (CP="P" and vShowPrepaidOtherChargeConsignee="Y" and Copy="CONSIGNEE") or (CP="C" and vShowCollectOtherChargeConsignee="Y" and Copy="CONSIGNEE")then
			    If IsNull(rsHAWB("Amt_MAWB")) = False Then
				    aOtherCharge(tIndex) = FormatAmount(rsHAWB("Amt_MAWB"))
			    End If
			    If IsNull(rsHAWB("Charge_Desc")) = False Then
				    aOtherChargeDesc(tIndex) = rsHAWB("Charge_Desc")
			    End If
			    tIndex=tIndex+1
		    end if
		    if (CP="P" and vShowPrepaidOtherChargeConsignee="Y") or (CP="C" and vShowCollectOtherChargeConsignee="Y") then
			    hOtherCharge(tIndex1) = rsHAWB("Amt_MAWB")
			    hOtherChargeDesc(tIndex1) = rsHAWB("Charge_Desc")
			    tIndex1=tIndex1+1
		    end if
		    rsHAWB.MoveNext
	    Loop
	    rsHAWB.Close
	    for i=0 to 2
		    vOtherCharge1=vOtherCharge1 & aOtherChargeDesc(i) & "  " & aOtherCharge(i) & "  "
		    vOtherCharge2=vOtherCharge2 & aOtherChargeDesc(i+3) & "  " & aOtherCharge(i+3) & "  "
		    vOtherCharge3=vOtherCharge3 & aOtherChargeDesc(i+6) & "  " & aOtherCharge(i+6) & "  "
		    hOtherCharge1=hOtherCharge1 & hOtherChargeDesc(i) & "  " & hOtherCharge(i) & "  "
		    hOtherCharge2=hOtherCharge2 & hOtherChargeDesc(i+3) & "  " & hOtherCharge(i+3) & "  "
		    hOtherCharge3=hOtherCharge3 & hOtherChargeDesc(i+6) & "  " & hOtherCharge(i+6) & "  "
	    next
	    vOtherCharge3=vOtherCharge3 & aOtherChargeDesc(9) & "  " & aOtherCharge(9)
	    hOtherCharge3=hOtherCharge3 & hOtherChargeDesc(9) & "  " & hOtherCharge(9)
    end if
    Set rsHAWB=Nothing
    response.buffer = True

    DIM oFile
    oFile = Server.MapPath("../template_domestic")
    r = PDF.OpenInputFile(oFile + "/awb.pdf")

    Dim vMAWB2
    vMAWB2 = vMAWB
    '// vMAWB = mid(vMAWB,1,3) & "   " & AirportCode & "  " & mid(vMAWB,5,30)

    '// On Error Resume Next:

    PDF.SetFormFieldData "MAWB",vMAWB,0
    PDF.SetFormFieldData "ShipperInfo",vShipperInfo,0
    PDF.SetFormFieldData "ConsigneeInfo",vConsigneeInfo,0
    PDF.SetFormFieldData "AgentIATACode",vAgentIATACode,0
    PDF.SetFormFieldData "ff_shipper_acct",ff_shipper_acct,0
    PDF.SetFormFieldData "ff_consignee_acct",ff_consignee_acct,0
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
    PDF.SetFormFieldData "ChargeCode",vChargeCode,0
    PDF.SetFormFieldData "PPO_1",vPPO_1,0
    PDF.SetFormFieldData "COLL_1",vCOLL_1,0
    PDF.SetFormFieldData "PPO_2",vPPO_2,0
    PDF.SetFormFieldData "COLL_2",vCOLL_2,0
    PDF.SetFormFieldData "DeclaredValueCarriage",vDeclaredValueCarriage,0
    PDF.SetFormFieldData "InsuranceAMT",vInsuranceAMT,0
    PDF.SetFormFieldData "HandlingInfo",vHandlingInfo,0
    PDF.SetFormFieldData "Desc2",vDesc2,0
    for i=0 to 2
	    PDF.SetFormFieldData "Pieces" & i+1,aPiece(i),0
	    PDF.SetFormFieldData "GrossWeight" & i+1,aGrossWeight(i),0
	    PDF.SetFormFieldData "KgLb" & i+1,aKgLb(i),0
	    PDF.SetFormFieldData "RateClass" & i+1,aRateClass(i),0
	    PDF.SetFormFieldData "ItemNo" & i+1,aItemNo(i),0
	    PDF.SetFormFieldData "ChargeableWeight" & i+1,aChargeableWeight(i),0
	    PDF.SetFormFieldData "RateCharge" & i+1,aRateCharge(i),0
	    PDF.SetFormFieldData "Total" & i+1,aTotal(i),0
    next
    PDF.SetFormFieldData "Dimension",vDimension,0
    PDF.SetFormFieldData "Desc1",vDesc1,0
    PDF.SetFormFieldData "TotalPiece",vTotalPiece,0
    PDF.SetFormFieldData "TotalGrossWeight",formatAmount(vTotalGrossWeight),0
    PDF.SetFormFieldData "TotalWeightCharge",vTotalWeightCharge,0

    PDF.SetFormFieldData "PrepaidWeightCharge",vPrepaidWeightCharge,0
    PDF.SetFormFieldData "CollectWeightCharge",vCollectWeightCharge,0
    PDF.SetFormFieldData "PrepaidValuationCharge",vPrepaidValuationCharge,0
    PDF.SetFormFieldData "CollectValuationCharge",vCollectValuationCharge,0
    PDF.SetFormFieldData "PrepaidTax",vPrepaidTax,0
    PDF.SetFormFieldData "CollectTax",vCollectTax,0
    PDF.SetFormFieldData "PrepaidOtherChargeAgent",vPrepaidOtherChargeAgent,0
    PDF.SetFormFieldData "CollectOtherChargeAgent",vCollectOtherChargeAgent,0
    PDF.SetFormFieldData "PrepaidOtherChargeCarrier",vPrepaidOtherChargeCarrier,0
    PDF.SetFormFieldData "CollectOtherChargeCarrier",vCollectOtherChargeCarrier,0
    PDF.SetFormFieldData "PrepaidTotal",vPrepaidTotal,0
    PDF.SetFormFieldData "CollectTotal",vCollectTotal,0
    PDF.SetFormFieldData "ConversionRate",vConversionRate,0
    PDF.SetFormFieldData "CCCharge",vCCCharge,0
    PDF.SetFormFieldData "ChargeDestination",vChargeDestination,0
    PDF.SetFormFieldData "FinalCollect",vFinalCollect,0
    '// PDF.SetFormFieldData "Execute",vExecute,0
    PDF.SetFormFieldData "K_shipper",vknowshipper,0
    PDF.SetFormFieldData "UK_shipper",vunknowshipper,0
    PDF.SetFormFieldData "FAA_NUM",vFFA,0
    PDF.SetFormFieldData "ITEM_UD",vItem_U,0
    PDF.SetFormFieldData "CODA",vCOD_A,0
    PDF.SetFormFieldData "DC",vDC,0
    PDF.SetFormFieldData "PC",vPC,0
    PDF.SetFormFieldData "ODC",vODC,0
    PDF.SetFormFieldData "OAC",vOAC,0
    PDF.SetFormFieldData "DOOA",vDOOA,0
    PDF.SetFormFieldData "DODA",vDODA,0
    PDF.SetFormFieldData "IT_P",vITP,0
    PDF.SetFormFieldData "IT_C",vITC,0
    PDF.SetFormFieldData "Other_CAD",vOTHERCAD,0
    PDF.SetFormFieldData "COD_FE",vCODFEE,0

    R=PDF.CopyForm(0, 0)
    PDF.ResetFormFields

    Set rsHAWB=Nothing
End Sub


    Sub InsertHAWBIntoPDF(vHAWB,Copy)

        Dim hawbTable,weightTable,OtherTable
        Dim pdfCollectWeightCharge, pdfPrepaidWeightCharge,collect_total,prepaid_total,totalcharge
        Dim otherchage(100),otherchargeDesc(100)
        Set hawbTable = Server.CreateObject("System.Collections.HashTable")
        Set weightTable = Server.CreateObject("System.Collections.HashTable")    
        Set OtherTable = Server.CreateObject("System.Collections.ArrayList")
        Dim dataObj,SQL
        
        SQL = "SELECT a.*,b.customer_acct FROM hawb_master a LEFT OUTER JOIN hawb_master_add b ON " _
            & "(a.elt_account_number=b.elt_account_number AND a.hawb_num=b.hawb_num) " _
            & " WHERE a.elt_account_number=" & elt_account_number _
            & " AND a.hawb_num='" & vHAWB & "' AND a.is_dome='Y'"

        Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set hawbTable = dataObj.GetRowTable(0)
        
        SQL = "SELECT * from hawb_weight_charge where elt_account_number=" & elt_account_number _
            & " AND HAWB_NUM='" & vHAWB & "'"

        Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set weightTable = dataObj.GetRowTable(0)
        
        SQL = "SELECT * from hawb_other_charge where elt_account_number=" & elt_account_number _
        & " AND HAWB_NUM='" & vHAWB & "' AND invoice_only='N'"        
         Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set OtherTable = dataObj.GetDataList
        
        dim j
        For j=1 To OtherTable.Count 
            otherchage(j)=OtherTable(j-1)("Amt_HAWB") 
            otherchargeDesc(j)=OtherTable(j-1)("Charge_Desc") 
        Next 
        if hawbTable("Charge_Code") ="C" then
            pdfPrepaidWeightCharge=""
            if hawbTable("show_weight_charge_rate") ="N" then
                pdfCollectWeightCharge="AS ARRANGED"
            else
                pdfCollectWeightCharge=checkBlank(hawbTable("Collect_Weight_Charge"),0)
            end if
        else
            pdfCollectWeightCharge=""
            if hawbTable("show_weight_charge_rate") ="N" then
                pdfPrepaidWeightCharge="AS ARRANGED"
            else
                pdfPrepaidWeightCharge=checkBlank(hawbTable("Prepaid_Weight_Charge"),0)
            end if
        end if

        dim x,tempcharge
        totalcharge=0
        collect_total=0
        prepaid_total=0
        if hawbTable("show_other_charge_rate") ="N" then
            collect_total="AS ARRANGED"
            prepaid_total="AS ARRANGED"
            totalcharge="AS ARRANGED"
            
        else
            collect_total= collect_total + FormatNumberPlus(hawbTable("Collect_Weight_Charge"),2)
            prepaid_total= prepaid_total + FormatNumberPlus(hawbTable("Prepaid_Weight_Charge"),2)
            for x=1 To OtherTable.Count
            tempcharge=0
            tempcharge=tempcharge+FormatAmount(cdbl(OtherTable(x-1)("Amt_HAWB") ))
            if hawbTable("Charge_Code") ="P" then
                    prepaid_total=prepaid_total+tempcharge+0
                    collect_total=""
           else

                    collect_total=collect_total+tempcharge
                    prepaid_total=""
            end if
            next
            
           if hawbTable("Charge_Code") ="P" then
                    collect_total=""
           else
                    prepaid_total=""
            end if
            totalcharge=formatAmount(checkBlank(hawbTable("shipper_cod_amount"),0))
            totalcharge=totalcharge+collect_total
            
        end if
         
        dim S_level,how_to_pay,is_danger_good,i
        
        S_level=hawbTable("service_level")
        if S_level="Select One" then
            S_level=""
        elseif S_level="Other" then
            S_level=hawbTable("service_level_other")
        end if
        how_to_pay=hawbTable("bill_to_party")
        is_danger_good=hawbTable("danger_good")

        DIM oFile
        oFile = Server.MapPath("../template_domestic")
        r = PDF.OpenInputFile(oFile + "/house_awb.pdf")
    
        '// On Error Resume Next:
        PDF.SetFormFieldData "CollectWeightCharge",formatAmount(pdfCollectWeightCharge),0
        PDF.SetFormFieldData "PrepaidWeightCharge",formatAmount(pdfPrepaidWeightCharge),0
        PDF.SetFormFieldData "HAWB", vHAWB,0
        PDF.SetFormFieldData "MAWB", hawbTable("MAWB_NUM"),0
        PDF.SetFormFieldData "Ser_level", checkBlank(S_level,""),0  
        PDF.SetFormFieldData "DeclaredValueCarriage", hawbTable("Declared_Value_Carriage"),0 
        PDF.SetFormFieldData "ShipperRefN", hawbTable("shipper_reference_num"),0    
        PDF.SetFormFieldData "PO_NO", hawbTable("purchase_num"),0
        PDF.SetFormFieldData "DATE_H1", hawbTable("Date_Executed"),0
        
        If checkBlank(hawbTable("is_agent_house"),"N") = "N" Then
            PDF.SetFormFieldData "ff_Name",GetAgentName(elt_account_number),0
            PDF.SetFormFieldData "ffaddress",GetAgentAddress(elt_account_number),0
            PDF.SetFormFieldData "rate1", checkBlank(weightTable("Rate_Charge"),0),0
        Else
            PDF.SetFormFieldData "ff_Name", GetBusinessName(hawbTable("customer_acct")), 0
            Dim customer_info
            customer_info = GetBusinessInfo(hawbTable("customer_acct"))
            PDF.SetFormFieldData "ffaddress", Mid(customer_info,InStr(1,customer_info,chr(13))+1,1000) , 0
        End If
        
        PDF.SetFormFieldData "shipperInfo", hawbTable("Shipper_Info"),0 
        PDF.SetFormFieldData "ConsigneeInfo", hawbTable("Consignee_Info"),0
        PDF.SetFormFieldData "AccountInfo", hawbTable("Account_Info"),0
        PDF.SetFormFieldData "DepartureAirport", hawbTable("Departure_Airport"),0 
        PDF.SetFormFieldData "DestAirport", hawbTable("Dest_Airport"),0  
        PDF.SetFormFieldData "COD_AMT", formatAmount(checkBlank(hawbTable("cod_amount"),0)),0  
        PDF.SetFormFieldData "InsuranceAMT", checkBlank(hawbTable("Insurance_AMT"),0),0
        PDF.SetFormFieldData "Shipper_COD", formatAmount(checkBlank(hawbTable("shipper_cod_amount"),0)),0
        PDF.SetFormFieldData "HANDLINGINFO", hawbTable("Handling_Info"),0
        
        PDF.SetFormFieldData "Pieces1", checkBlank(hawbTable("Total_Pieces"),0),0
        PDF.SetFormFieldData "TotalPiece", checkBlank(hawbTable("Total_Pieces"),0),0
        PDF.SetFormFieldData "CUBICWT", checkBlank(weightTable("Dimension"),0),0
        PDF.SetFormFieldData "CUBIC_IN", checkBlank(weightTable("cubic_inches"),0),0
        PDF.SetFormFieldData "GrossWeight1", checkBlank(hawbTable("Total_Gross_Weight"),0),0
        PDF.SetFormFieldData "TotalGrossWeight", checkBlank(hawbTable("Total_Gross_Weight"),0),0
        PDF.SetFormFieldData "Desc2", checkBlank(hawbTable("Desc2"),""),0                
        PDF.SetFormFieldData "Dimension", weightTable("Dem_Detail"),0
        PDF.SetFormFieldData "prepaidTotal", formatAmount(prepaid_total),0
        PDF.SetFormFieldData "CollectTotal", formatAmount(collect_total),0
        PDF.SetFormFieldData "FinalCollect",  formatAmount(totalcharge),0        
        
        for i=1 To OtherTable.Count 
        if hawbTable("show_other_charge_rate") ="N" then
            PDF.SetFormFieldData "OtherCharge"& i &"_D","AS ARRANGED",0
            if hawbTable("Charge_Code") ="C" then
                PDF.SetFormFieldData "OtherCharge"& i &"C","AS ARRANGED",0
            else
                PDF.SetFormFieldData "OtherCharge"& i &"P","AS ARRANGED",0
            end if
        
        else
            PDF.SetFormFieldData "OtherCharge"& i &"_D",otherchargeDesc(i),0
            if hawbTable("Charge_Code") ="C" then
                PDF.SetFormFieldData "OtherCharge"& i &"C",formatAmount(otherchage(i)),0
            else
                PDF.SetFormFieldData "OtherCharge"& i &"P",formatAmount(otherchage(i)),0
            end if
        end if
        next

        if how_to_pay ="3" then
            PDF.SetFormFieldData "3P_C", "X" ,0
        elseif how_to_pay ="C" then
            PDF.SetFormFieldData "C_C", "X" ,0
        else
            PDF.SetFormFieldData "S_C", "X" ,0
        end if 
        if is_danger_good="Y" then
            PDF.SetFormFieldData "CHGY", "X" ,0
        else
            PDF.SetFormFieldData "CHGN", "X" ,0
        end if
        
        Dim reader
        
        reader = PDF.CopyForm(0, 0)
        PDF.ResetFormFields

        Set rsHAWB=Nothing
    End Sub

%>

<%

Sub InsertSTMTIntoPDF(MAWB,AgentNo)

    Dim aOrgInfo(5)
    Dim vAgentName
    Dim aHAWB(64),aRCVL(64),aPYBL(64),aPS(64),aDebit(64),aCredit(64),aOCarrier(64),aOAgent(64)
    Dim aAgentChg(64),aCarrierChg(64),aTotalDue(64)
    Dim rs, SQL
    Dim i
    Set rs = Server.CreateObject("ADODB.Recordset")

    if Not MAWB="" And Not AgentNo="" then

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

	    if rs.eof then
		    rs.close
		    SQL = get_ocean_smtp_sql
		    rs.Open SQL, eltConn, , , adCmdText
	    end if

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

    DIM oFile,LogoName
    oFile = Server.MapPath("../template")

    Set fso = CreateObject("Scripting.FileSystemObject")
    Dim CustomerForm
    CustomerForm=oFile & "/Customer/" & "agent_stmt" & elt_account_number & ".pdf"

    If fso.FileExists(CustomerForm) Then
	    r = PDF.OpenInputFile(CustomerForm)
    Else
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

	    r = PDF.CopyForm(0, 0)
	    PDF.ResetFormFields
    next
end Sub


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
	Set fso = CreateObject("Scripting.FileSystemObject")
	Dim CustomerForm
	CustomerForm=oFile & "/Customer/" & "Manifest" & elt_account_number & ".pdf"

	If fso.FileExists(CustomerForm) Then
		r = PDF.OpenInputFile(CustomerForm)
	Else
	    r = PDF.OpenInputFile(oFile+"/Manifest.pdf")
	End If
	Set fso = nothing

    DIM vFlightNoELI,aAgentInfoFull(64),vDateArrivalFull,vDateDepartFull
    Dim aSubToNo(64),aIsSub(64)
    Dim aShipperName(64),aConsigneeName(64)
    Dim aDangerGood(64)


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

	    If IsNull(rs("Total_Pieces")) = False Then
		    aPiece(tIndex) = CInt(rs("Total_Pieces"))
		    vTotalPiece=vTotalPiece+aPiece(tIndex)
	    Else
		    aPiece(tIndex)=0
	    End If
	    If Not IsNull(rs("Weight_Scale")) Or Trim(rs("Weight_Scale")) <> "" Then
		    vWeightScale = rs("Weight_Scale")
	    end if

	    If Not IsNull(rs("adjusted_Weight")) Or Trim(rs("adjusted_Weight")) <> "" Then
		    aGrossWeight(tIndex) = CDBL(rs("adjusted_Weight"))
		    if vWeightScale="L" then
			    aGrossWeight(tIndex)=aGrossWeight(tIndex)*0.4535924
		    end if
		    vTotalGrossWeight=vTotalGrossWeight+aGrossWeight(tIndex)
	    Else
		    aGrossWeight(tIndex)=0
	    End If
    	
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

    For j=1 To Pages
        
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
	    PDF.SetFormFieldData "FlightNo_ELI", vFlightNoELI, 0
	    PDF.SetFormFieldData "DateDepartFull",POD & " " & ETD,0
	    PDF.SetFormFieldData "DateArrivalFull",POA & " " & vDateArrival,0

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
                        PDF.SetFormFieldData "MASTER" & i-(j-1)*5,"M/H: "&aSubToNo(i),0
				    end if 
    				
				    PDF.SetFormFieldData "HAZMAT" & i-(j-1)*5, aDangerGood(i) & "", 0
			    end if 	
		    next
            
            PDF.SetFormFieldData "TotalPieces",vTotalPiece,0
            PDF.SetFormFieldData "TotalGrossWeight", ConvertAnyValue(vTotalGrossWeight,"Long",""), 0
            PDF.SetFormFieldData "TotalHAWB","TOTAL " & tIndex & " HAWB",0

	    end if

        PDF.FlattenRemainingFormFields = True

        r = PDF.CopyForm(0, 0)
        PDF.ResetFormFields
    Next


end Sub


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
		    TotalPieces=rs("Total_Pieces")

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

    DIM oFile,LogoName
    oFile = Server.MapPath("../template")

    Set fso = CreateObject("Scripting.FileSystemObject")
    Dim CustomerForm
    CustomerForm=oFile & "/Customer/" & "Invoice" & elt_account_number & ".pdf"

    If fso.FileExists(CustomerForm) Then
	    r = PDF.OpenInputFile(CustomerForm)
    Else
	    r = PDF.OpenInputFile(oFile+"/invoice.pdf")
    End If

    Set fso = nothing
    
    '// Added by Joon on Dec-21-2006 //////////////////////////////
    Dim CustomerInfoTelFax

		CustomerInfo = Replace(UCASE(CustomerInfo), ",USA", "")
		CustomerInfo = Replace(UCASE(CustomerInfo), "USA", "")
		CustomerInfo = Replace(UCASE(CustomerInfo), "UNITED STATES", "")
		CustomerInfo = Replace(UCASE(CustomerInfo), "US", "")
		If InStr(UCASE(CustomerInfo), "TEL:") > 0 Then
		    CustomerInfoTelFax = Right(CustomerInfo, Len(CustomerInfo)-InStr(UCASE(CustomerInfo), "TEL:")+1)
		    CustomerInfo = Left(CustomerInfo, InStr(UCASE(CustomerInfo), "TEL:")-1)
		Else
	        CustomerInfoTelFax = GetBusinessTelFax(orgNo)
		End if

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
    PDF.SetFormFieldData "CustomerTelFax", CustomerInfoTelFax, 0
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

	PDF.SetFormFieldData "DEFAULT_STATEMENT",v_iv_statement,0
    R=PDF.CopyForm(0, 0)


end Sub

%>