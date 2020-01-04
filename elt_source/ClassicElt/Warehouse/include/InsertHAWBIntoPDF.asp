<%
Sub InsertHAWBIntoPDF(vHAWB)
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

Copy="CONSIGNEE"
if UserRight=1 then Copy="CONSIGNEE"

Dim rsHAWB, SQL
Set rsHAWB = Server.CreateObject("ADODB.Recordset")
'get country stmt
UserCountry=Session("user_country")
SQL= "select * from form_stmt where form_name='awb' and country='" & UserCountry & "' order by stmt_name"
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
		SQL= "select * from hawb_master where elt_account_number = " & COLODee & " and HAWB_NUM='" & vHAWB & "'"
	end if
else
	SQL= "select * from hawb_master where elt_account_number = " & elt_account_number & " and HAWB_NUM='" & vHAWB & "'"
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
	vExecute=rsHAWB("execution")
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
	SQL= "select * from hawb_weight_charge where elt_account_number = " & COLODee & " and HAWB_NUM='" & vHAWB & "' order by tran_no"
else
	SQL= "select * from hawb_weight_charge where elt_account_number = " & elt_account_number & " and HAWB_NUM='" & vHAWB & "' order by tran_no"
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
		SQL= "select coll_prepaid,Amt_HAWB,Charge_Desc from hawb_other_charge where elt_account_number = " & COLODee & " and HAWB_NUM='" & vHAWB & "' order by tran_no"
	else
		SQL= "select coll_prepaid,Amt_HAWB,Charge_Desc from hawb_other_charge where elt_account_number = " & elt_account_number & " and HAWB_NUM='" & vHAWB & "' order by tran_no"
	end if
	SQL= "select coll_prepaid,Amt_HAWB,Charge_Desc from hawb_other_charge where elt_account_number = " & elt_account_number & " and HAWB_NUM='" & vHAWB & "' order by tran_no"
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
	end if

DIM oFile
oFile = Server.MapPath("../template")

Set PDF = Server.CreateObject("APToolkit.Object")
r = PDF.OpenOutputFile("MEMORY")
r = PDF.OpenInputFile(oFile+"/awb.pdf")

'LogoName=oFile & "/logo/logo" & elt_account_number & ".pdf"
'r=PDF.AddLogo(LogoName, 1)

PDF.SetFormFieldData "MAWB",vMAWB,0
PDF.SetFormFieldData "HAWB","HAWB: " & vHAWB,0
PDF.SetFormFieldData "ShipperInfo",vShipperInfo,0
PDF.SetFormFieldData "ConsigneeInfo",Replace(Replace(vConsigneeInfo, chr(13), chr(13) & "TEL: "),"TEL: ", "",1,2),0
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
	'  PDF.SetHeaderFont "Helvetica", 8
	PDF.FlattenRemainingFormFields = True
R=PDF.CopyForm(0, 0)
PDF.ResetFormFields

Set rsHAWB=Nothing
End Sub

%>
