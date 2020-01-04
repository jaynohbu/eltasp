
<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/PDFManager.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_Util_fun.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_Util_Ver_2.inc" -->
<% 

    '// Copied from header.asp /////////////////////////////////////////////////////
    
    Dim elt_account_number,login_name,user_id,ClientOS,session_ip,session_IntIp
    Dim session_server_name,session_user_lname,redPage
	elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
	login_name = Request.Cookies("CurrentUserInfo")("login_name")
	user_id = Request.Cookies("CurrentUserInfo")("user_id")
	ClientOS = Request.Cookies("CurrentUserInfo")("ClientOS")
	session_ip = Request.Cookies("CurrentUserInfo")("IP")
	session_IntIp = Request.Cookies("CurrentUserInfo")("intIP")
	session_server_name = Request.Cookies("CurrentUserInfo")("Server_Name")
	session_user_lname = Request.Cookies("CurrentUserInfo")("lname")
	redPage = Request.Cookies("CurrentUserInfo")("ORIGINPAGE")
	
	'////////////////////////////////////////////////////////////////////////////////
	
Dim vMAWB, vHAWB,vShipperInfo, vShipperName,vShipperAcct
Dim vConsigneeName, vConsigneeInfo,vConsigneeAcct
Dim vAgentIATACode,vDepartureAirport, vTo, vBy, vTo1, vBy1, vTo2, vBy2
Dim vDestAirport,vFlightDate1,vFlightDate2
Dim vIssuedBy,vAccountInfo
Dim  vChargeCode, vPPO_1, vCOLL_1, vPPO_2, vCOLL_2
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
'/////////////////////////////////////////////////// by ig NOV-27
DIM ff_shipper_acct,ff_consignee_acct
'/////////////////////////////////////////////////// by ig NOV-27

vMAWB=Request.QueryString("MAWB")
Copy=Request.QueryString("Copy")
if UserRight=1 then Copy="CONSIGNEE"

CALL REDIRECT_URL

Dim rsHAWB, SQL
Set rsHAWB = Server.CreateObject("ADODB.Recordset")

'// added by Joon on Jan/16/2007 /////////////////////////////////////////////
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
'////////////////////////////////////////////////////////////////////////////

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

'///////////////////////////////////////////////

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
'/////change by stanley/////////////////////////
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
'///////////////////////////////////////////////


	'If IsNull(rsHAWB("Place_Executed")) = False Then
	'	vPlaceExecuted = rsHAWB("Place_Executed")
	'End If
	vExecute=rsHAWB("execution")
'// added by Joon on Dec-03-2007 ///////////////////////////////////////////////////
	Call ExecutionStringChange
'///////////////////////////////////////////////////////////////////////////////////
	If IsNull(rsHAWB("Desc1")) = False Then
		vDesc1 = rsHAWB("Desc1")
	End If
	If IsNull(rsHAWB("Desc2")) = False Then
		vDesc2 = rsHAWB("Desc2")
	End If
'	If IsNull(rsHAWB("Show_Weight_Charge_Shipper")) = False Then
'		vShowWeightChargeShipper = rsHAWB("Show_Weight_Charge_Shipper")
'	End If

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
'	If IsNull(rsHAWB("Show_Weight_Charge_Consignee")) = False Then
'		vShowWeightChargeConsignee = rsHAWB("Show_Weight_Charge_Consignee")
'	End If

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
'	If IsNull(rsHAWB("Show_Prepaid_Other_Charge_Shipper")) = False Then
'		vShowPrepaidOtherChargeShipper = rsHAWB("Show_Prepaid_Other_Charge_Shipper")
'	End If

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
'	If IsNull(rsHAWB("Show_Collect_Other_Charge_shipper")) = False Then
'		vShowCollectOtherChargeShipper = rsHAWB("Show_Collect_Other_Charge_shipper")
'	End If

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
'	If IsNull(rsHAWB("Show_Prepaid_Other_Charge_Consignee")) = False Then
'		vShowPrepaidOtherChargeConsignee = rsHAWB("Show_Prepaid_Other_Charge_Consignee")
'	End If

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
'	If IsNull(rsHAWB("Show_Collect_Other_Charge_Consignee")) = False Then
'		vShowCollectOtherChargeConsignee = rsHAWB("Show_Collect_Other_Charge_Consignee")
'	End If

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

Set PDF = GetNewPDFObject()
r = PDF.OpenOutputFile("MEMORY")

Set fso = CreateObject("Scripting.FileSystemObject")
CustomerForm=oFile & "/Customer/" & "awb_" & elt_account_number & ".pdf"

If fso.FileExists(CustomerForm) Then
    r = PDF.OpenInputFile(CustomerForm)
Else
    r = PDF.OpenInputFile(oFile & "/awb.pdf")
End If

PDF.SetFormFieldData "HAWB",vMAWB,0

'// Added By Joon On 02/26/2007 /////////////////////////////////
Dim vMAWB2
vMAWB2 = vMAWB
vMAWB=mid(vMAWB,1,3) & "   " & AirportCode & "  " & mid(vMAWB,5,30)

On Error Resume Next:

PDF.SetFormFieldData "MAWB",vMAWB,0
PDF.SetFormFieldData "ShipperInfo",vShipperInfo,0
PDF.SetFormFieldData "ConsigneeInfo",vConsigneeInfo,0
PDF.SetFormFieldData "AgentIATACode",vAgentIATACode,0

'///////////////////////////////////////////////
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
PDF.SetFormFieldData "ChargeCode",vChargeCode,0
PDF.SetFormFieldData "PPO_1",vPPO_1,0
PDF.SetFormFieldData "COLL_1",vCOLL_1,0
PDF.SetFormFieldData "PPO_2",vPPO_2,0
PDF.SetFormFieldData "COLL_2",vCOLL_2,0
PDF.SetFormFieldData "DeclaredValueCarriage",vDeclaredValueCarriage,0
PDF.SetFormFieldData "InsuranceAMT",vInsuranceAMT,0
PDF.SetFormFieldData "HandlingInfo",vHandlingInfo,0
'weight info
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
'other info
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
PDF.SetFormFieldData "Execute",vExecute,0
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


reader = PDF.CopyForm(0, 0)
PDF.CloseOutputFile

Response.Clear
Response.Expires = 0
Response.ContentType = "application/pdf"
Response.AddHeader "Content-Type", "application/pdf"
Response.AddHeader "Content-Disposition", "attachment; filename=MAWB" & Session.SessionID & ".pdf"
WritePDFBinary(PDF)

Set fso = Nothing
Set PDF = Nothing
Set reader = Nothing
Set bridge = Nothing

'//added by joon on Dec/03/2007
Sub ExecutionStringChange
    Dim txtPos
    txtPos = InStr(UCase(vExecute),"AS AGENT OF")
    If txtPos>0 Then
		If InStr(vExecute,"CARRIER") = 0 Then
			vExecute = Left(vExecute, txtPos) & Replace(vExecute, chr(13), ", CARRIER" & chr(13), txtPos + 1, 1)
		End If
    End If
End Sub

'// added by Joon on Jan/17/2007
Function FormatAmount (argStrVal)
    Dim returnVal
	If Not IsNull(argStrVal) And Trim(argStrVal) <> "" Then
		argStrVal = Trim(argStrVal)
		If isnumeric(argStrVal) And Not isempty(argStrVal) Then
			If argStrVal <> "0" Then
				returnVal = FormatNumber(argStrVal,2)
			End If
		Else
			returnVal = argStrVal
		End If
	Else
		returnVal = ""
	End If
	FormatAmount = returnVal
End Function


    Sub REDIRECT_URL
        Dim SQL,rs,vURL
	    Set rs = Server.CreateObject("ADODB.Recordset")

        SQL = "SELECT master_type,is_inbound FROM mawb_number WHERE elt_account_number=" & elt_account_number _
            & " AND is_dome='Y' AND mawb_no='" & vMAWB & "'"

	    rs.CursorLocation = adUseClient	
	    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
        Set rs.ActiveConnection = Nothing
        
        If NOT rs.EOF AND NOT rs.BOF Then
            If rs(0).value = "DG" Then
                vURL = "ground_mawb_pdf.asp?MAWB=" & vMAWB & "&Copy=" & Copy
                Response.Redirect(vURL) 
                Response.End()
            End If
        Else
            Response.Write("<script> alert('The MAWB was not found!'); window.location.href='new_edit_mawb.asp'; </script>")    
        End If
		rs.close()

    End Sub

%>


