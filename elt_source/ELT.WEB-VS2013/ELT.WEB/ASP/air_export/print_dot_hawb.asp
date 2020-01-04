<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/Header.asp" -->
<!--  #include file="../include/recent_file.asp" -->
<!--  #include file="../include/GOOFY_util_fun.inc" -->

<%
'// Dot matrix printing data

Dim vMAWB,vMAWB2,vHAWB,vShipperInfo, vShipperName,vShipperAcct
Dim vConsigneeName, vConsigneeInfo,vConsigneeAcct
Dim vAgentInfo,vAgentIATACode,vAgentAcct,vDepartureAirport, vTo, vBy, vTo1, vBy1, vTo2, vBy2
Dim vDestAirport,vFlightDate1,vFlightDate2
Dim vIssuedBy,vAccountInfo
Dim vCurrency, vChargeCode, vPPO_1, vCOLL_1, vPPO_2, vCOLL_2
Dim vDeclaredValueCarriage, vDeclaredValueCustoms,vInsuranceAMT
Dim vHandlingInfo, vSCI
Dim aTranNo(3),aPiece(3),aGrossWeight(3),aKgLb(3),aRateClass(3),aItemNo(3)
Dim aDimension(3),aDemDetail(3),aChargeableWeight(3),aRateCharge(3),aTotal(3),aAdjustedWeight(3)
Dim hRateCharge(3),hTotal(3)
Dim vDesc1,vDesc2
Dim aCarrierAgent(10),aCollectPrepaid(10),aChargeCode(10),aDesc(10),aChargeAmt(10),aVendor(10),aCost(10)
Dim hChargeAmt(10),hDesc(10)
Dim tIndex,tIndex1,NoItemOC,i,hNoItemOC,CP
Dim vTotalPiece,vTotalGrossWeight,vTotalWeightCharge,vTotalAdjustedWeight
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
Dim Copy,AirportCode,vDestCountry,vPrepaidTotal,vCollectTotal
Dim hTotalWeightCharge,hPrepaidWeightCharge,hPrepaidValuationCharge,hCollectTax,hCollectWeightCharge
Dim hPrepaidTax,hCollectValuationCharge,hPrepaidOtherChargeAgent,hCollectOtherChargeAgent
Dim hPrepaidOtherChargeCarrier,hCollectOtherChargeCarrier,hPrepaidTotal,hCollectTotal,hFinalCollect
Dim vCOLO,COLODee,vPrintPort,vLC,vCI,vOtherRef,hChargeDestination

vHAWB=Request.QueryString("HAWB")
Copy=Request.QueryString("Copy")
if UserRight="1" then Copy="CONSIGNEE"
vCOLO=Request.QueryString("COLO")
if vCOLO="" then vCOLO=Request("hCOLO")
COLODee=Request.QueryString("COLODee")
Dim pp
Dim rsHAWB, SQL
Set rsHAWB = Server.CreateObject("ADODB.Recordset")
if Not COLODee="" then
	SQL="select * from colo where colodee_elt_acct=" & COLODee & " and coloder_elt_acct=" & elt_account_number
	rsHAWB.Open SQL, eltConn, , , adCmdText
	if rsHAWB.EOF then
		ErrMsg="You don't have the privilege to access this page!"
		rsHAWB.close
		Response.Redirect("../extra/err_msg.asp?ErrMsg=" & ErrMsg)
	else
		rsHAWB.close
		COPY="CONSIGNEE"
		SQL= "select * from hawb_master where elt_account_number = " & COLODee & " and HAWB_NUM=N'" & vHAWB & "' and is_dome='N'"
	end if
else
	SQL= "select * from hawb_master where elt_account_number = " & elt_account_number & " and HAWB_NUM=N'" & vHAWB & "' and is_dome='N'"
end if
rsHAWB.Open SQL, eltConn, , , adCmdText
If Not rsHAWB.EOF Then
	If IsNull(rsHAWB("MAWB_NUM")) = False Then
		vMAWB = rsHAWB("MAWB_NUM")
		vMAWB2 = vMAWB
	End If
	AirportCode=rsHAWB("dep_airport_code")
	vMAWB=mid(vMAWB,1,3) & " " & AirportCode & " " & mid(vMAWB,5,30)
	If IsNull(rsHAWB("Shipper_Info")) = False Then
		vShipperInfo = rsHAWB("Shipper_Info")
	End If
	If IsNull(rsHAWB("Consignee_Info")) = False Then
		vConsigneeInfo = rsHAWB("Consignee_Info")
	End If
'// Modified by Joon on Dec/07/2007
	If IsNull(rsHAWB("ff_shipper_acct")) = False Then
		vShipperAcct = rsHAWB("ff_shipper_acct")
	End If
	If IsNull(rsHAWB("ff_consignee_acct")) = False Then
		vConsigneeAcct = rsHAWB("ff_consignee_acct")
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
	End If
	If IsNull(rsHAWB("COLL_1")) = False Then
		vCOLL_1 = rsHAWB("COLL_1")
	End If
	If IsNull(rsHAWB("PPO_2")) = False Then
		vPPO_2 = rsHAWB("PPO_2")
	End If
	If IsNull(rsHAWB("COLL_2")) = False Then
		vCOLL_2 = rsHAWB("COLL_2")
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
	
    If checkBlank(rsHAWB("aes_xtn"),"") <> "" Then
        vHandlingInfo = vHandlingInfo & ", AES ITN: " & rsHAWB("aes_xtn")
    Elseif checkBlank(rsHAWB("sed_stmt"),"") <> "" Then
        vHandlingInfo = vHandlingInfo & ", " & rsHAWB("sed_stmt")
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
		vTotalGrossWeight = rsHAWB("Total_Gross_Weight")
	Else
		vTotalGrossWeight=0
	end if
	If IsNull(rsHAWB("adjusted_weight")) = False Then
		vTotalAdjustedWeight = rsHAWB("adjusted_weight")
	Else
		vTotalAdjustedWeight=0
	end if
	If IsNull(rsHAWB("Total_Weight_Charge_HAWB")) = False Then
		vTotalWeightCharge = FormatAmount(rsHAWB("Total_Weight_Charge_HAWB"))
		hTotalWeightCharge=vTotalWeightCharge
	Else
		vTotalWeightCharge=0
	end if
	If IsNull(rsHAWB("Prepaid_Weight_Charge")) = False Then
		vPrepaidWeightCharge = FormatAmount(rsHAWB("Prepaid_Weight_Charge"))
		hPrepaidWeightCharge=vPrepaidWeightCharge
	Else
		vPrepaidWeightCharge=0
	end if
	If IsNull(rsHAWB("Collect_Weight_Charge")) = False Then
		vCollectWeightCharge = FormatAmount(rsHAWB("Collect_Weight_Charge"))
		hCollectWeightCharge=vCollectWeightCharge
	Else
		vCollectWeightCharge=0
	end if
	If IsNull(rsHAWB("Prepaid_Valuation_Charge")) = False Then
		vPrepaidValuationCharge = FormatAmount(rsHAWB("Prepaid_Valuation_Charge"))
		hPrepaidValuationCharge=vPrepaidValuationCharge
	Else
		vPrepaidValuationCharge=0
	end if
	If IsNull(rsHAWB("Collect_Valuation_Charge")) = False Then
		vCollectValuationCharge = FormatAmount(rsHAWB("Collect_Valuation_Charge"))
		hCollectValuationCharge=vCollectValuationCharge
	Else
		vCollectValuationCharge=0
	end if
	If IsNull(rsHAWB("Prepaid_Tax")) = False Then
		vPrepaidTax = FormatAmount(rsHAWB("Prepaid_Tax"))
		hPrepaidTax=vPrepaidTax
	Else
		vPrepaidTax=0
	end if
	If IsNull(rsHAWB("Collect_Tax")) = False Then
		vCollectTax = FormatAmount(rsHAWB("Collect_Tax"))
		hCollectTax=vCollectTax
	Else
		vCollectTax=0
	end if
	If IsNull(rsHAWB("Prepaid_Due_Agent")) = False Then
		vPrepaidOtherChargeAgent = FormatAmount(rsHAWB("Prepaid_Due_Agent"))
		hPrepaidOtherChargeAgent=vPrepaidOtherChargeAgent
	Else
		vPrepaidOtherChargeAgent=0
	end if
	If IsNull(rsHAWB("Collect_Due_Agent")) = False Then
		vCollectOtherChargeAgent = FormatAmount(rsHAWB("Collect_Due_Agent"))
		hCollectOtherChargeAgent=vCollectOtherChargeAgent
	Else
		vCollectOtherChargeAgent=0
	end if
	If IsNull(rsHAWB("Prepaid_Due_Carrier")) = False Then
		vPrepaidOtherChargeCarrier = FormatAmount(rsHAWB("Prepaid_Due_Carrier"))
		hPrepaidOtherChargeCarrier=vPrepaidOtherChargeCarrier
	Else
		vPrepaidOtherChargeCarrier=0
	end if
	If IsNull(rsHAWB("Collect_Due_Carrier")) = False Then
		vCollectOtherChargeCarrier = FormatAmount(rsHAWB("Collect_Due_Carrier"))
		hCollectOtherChargeCarrier=vCollectOtherChargeCarrier
	Else
		vCollectOtherChargeCarrier=0
	end if
	If IsNull(rsHAWB("Prepaid_Total")) = False Then
		vPrepaidTotal = FormatAmount(rsHAWB("Prepaid_Total"))
		hPrepaidTotal=vPrepaidTotal
	Else
		vPrepaidTotal=0
	end if
	If IsNull(rsHAWB("Collect_Total")) = False Then
		vCollectTotal = FormatAmount(rsHAWB("Collect_Total"))
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
'// added by Joon on Dec-03-2007 ///////////////////////////////////////////////////
	Call ExecutionStringChange
'///////////////////////////////////////////////////////////////////////////////////
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
		'// Added by Joon on Feb/12/2007
		If vTotalWeightCharge>0 then 
			vTotalWeightCharge="AS ARRANGED"
		else
			vTotalWeightCharge=""
		End If
		
	end if
	If IsNull(rsHAWB("Show_Weight_Charge_Consignee")) = False Then
		vShowWeightChargeConsignee = rsHAWB("Show_Weight_Charge_Consignee")
	End If
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
			'// Added by Joon on Feb/12/2007
		    If vTotalWeightCharge>0 then 
			    vTotalWeightCharge="AS ARRANGED"
		    else
			    vTotalWeightCharge=""
		    End If
		end if
	end if
	If IsNull(rsHAWB("Show_Prepaid_Other_Charge_Shipper")) = False Then
		vShowPrepaidOtherChargeShipper = rsHAWB("Show_Prepaid_Other_Charge_Shipper")
	End If
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
	If IsNull(rsHAWB("Show_Collect_Other_Charge_shipper")) = False Then
		vShowCollectOtherChargeShipper = rsHAWB("Show_Collect_Other_Charge_shipper")
	End If
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
	If IsNull(rsHAWB("Show_Prepaid_Other_Charge_Consignee")) = False Then
		vShowPrepaidOtherChargeConsignee = rsHAWB("Show_Prepaid_Other_Charge_Consignee")
	End If
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
	If IsNull(rsHAWB("Show_Collect_Other_Charge_Consignee")) = False Then
		vShowCollectOtherChargeConsignee = rsHAWB("Show_Collect_Other_Charge_Consignee")
	End If
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
		vConversionRate = FormatAmount(rsHAWB("Currency_Conv_Rate"))
	End If
	If IsNull(rsHAWB("CC_Charge_Dest_Rate")) = False Then
		vCCCharge = FormatAmount(rsHAWB("CC_Charge_Dest_Rate"))
	End If
	If IsNull(rsHAWB("Charge_at_Dest")) = False Then
		vChargeDestination = FormatAmount(rsHAWB("Charge_at_Dest").value)
	End If
	If IsNull(rsHAWB("Total_Collect_Charge")) = False Then
		vFinalCollect = FormatAmount(rsHAWB("Total_Collect_Charge"))
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
		if hPrepaidTotal>0 then
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
if Not COLODee="" then
	SQL= "select * from hawb_weight_charge where elt_account_number = " & COLODee & " and HAWB_NUM=N'" & vHAWB & "' order by tran_no"
else
	SQL= "select * from hawb_weight_charge where elt_account_number = " & elt_account_number & " and HAWB_NUM=N'" & vHAWB & "' order by tran_no"
end if
rsHAWB.Open SQL, eltConn, , , adCmdText
tIndex=0

Do While Not rsHAWB.EOF 
	If IsNull(rsHAWB("Tran_No")) = False Then
		aTranNo(tIndex) = rsHAWB("Tran_No")
	End If	
	If IsNull(rsHAWB("No_Pieces")) = False Then
		aPiece(tIndex) = rsHAWB("No_Pieces") '// & chr(13) & rsHAWB("unit_qty")
	End If

	If IsNull(rsHAWB("Gross_Weight")) = False Then
		aGrossWeight(tIndex) = rsHAWB("Gross_Weight").value
	End If
	If IsNull(rsHAWB("adjusted_Weight")) = False Then
		aAdjustedWeight(tIndex) = rsHAWB("adjusted_Weight").value
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
	End If
	If IsNull(rsHAWB("Chargeable_Weight")) = False Then
		aChargeableWeight(tIndex) = rsHAWB("Chargeable_Weight")
	End If
	if (vShowWeightChargeShipper="Y" and Copy="SHIPPER") or  (vShowWeightChargeConsignee="Y" and Copy="CONSIGNEE") then
		If IsNull(rsHAWB("Rate_Charge")) = False Then
			aRateCharge(tIndex) = rsHAWB("Rate_Charge")
			if aRateCharge(tIndex)="0" then
			    aRateCharge(tIndex)=""
			end if 
		End If
		If IsNull(rsHAWB("Total_Charge")) = False Then
			aTotal(tIndex) = rsHAWB("Total_Charge")
		End If

    else		
		If checkBlank(FormatAmount(rsHAWB("Total_Charge")),0) > 0 Then
			aTotal(tIndex) = "AS ARRANGED"
		End If
	end if

	if vShowWeightChargeConsignee="Y" then
		If IsNull(rsHAWB("Rate_Charge")) = False Then
			hRateCharge(tIndex) = rsHAWB("Rate_Charge")
			if hRateCharge(tIndex)="0" then
			    hRateCharge(tIndex)=""
			end if
		End If
		If IsNull(rsHAWB("Total_Charge")) = False Then
			hTotal(tIndex) = rsHAWB("Total_Charge")
		End If
	end if
	
	rsHAWB.MoveNext
	tIndex=tIndex+1
Loop
rsHAWB.Close
if (Copy="SHIPPER" and (vShowPrepaidOtherChargeShipper="Y" or vShowCollectOtherChargeShipper="Y")) or (vShowPrepaidOtherChargeConsignee="Y" or vShowCollectOtherChargeConsignee="Y") then
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
		CP=rsHAWB("coll_prepaid")
		if (CP="P" and vShowPrepaidOtherChargeShipper="Y" and Copy="SHIPPER") or (CP="C" and vShowCollectOtherChargeShipper="Y" and Copy="SHIPPER") or (CP="P" and vShowPrepaidOtherChargeConsignee="Y" and Copy="CONSIGNEE") or (CP="C" and vShowCollectOtherChargeConsignee="Y" and Copy="CONSIGNEE")then
			If IsNull(rsHAWB("Amt_HAWB")) = False Then
				aChargeAmt(tIndex) = FormatAmount(rsHAWB("Amt_HAWB"))
			End If
			If IsNull(rsHAWB("Charge_Desc")) = False Then
				aDesc(tIndex) = rsHAWB("Charge_Desc")
			End If
			tIndex=tIndex+1
		end if
		if (CP="P" and vShowPrepaidOtherChargeConsignee="Y") or (CP="C" and vShowCollectOtherChargeConsignee="Y") then
			hChargeAmt(tIndex1) = FormatAmount(rsHAWB("Amt_HAWB"))
			hDesc(tIndex1) = rsHAWB("Charge_Desc")
			tIndex1=tIndex1+1
		end if
		rsHAWB.MoveNext
	Loop
	rsHAWB.Close
	NoItemOC=tIndex

'// Modified by Joon on Dec/17/2007 /////////////////////////////////////////////////////////////////
    
    For i=0 to NoItemOC
        aOtherCharge(0) = aOtherCharge(0) & aDesc(i) & " " & FormatAmount(aChargeAmt(i)) 
        If i+1 < NoItemOC Then
            aOtherCharge(0) = aOtherCharge(0) & "; "
        End If
    Next
    
'	if NoItemOC>5 then
'		for i=0 to NoItemOC-1 Step 2
'			aOtherCharge(Fix(i/2))=aDesc(i) & " " & FormatAmount(aChargeAmt(i)) & "  " & aDesc(i+1) & " " & FormatAmount(aChargeAmt(i+1))
'		next
'	else
'		for i=0 to NoItemOC
'			if aChargeAmt(i) <> "0" Then
'			    aOtherCharge(i)=aDesc(i) & " " & FormatAmount(aChargeAmt(i))
'			else 
'			    '// aOtherCharge(i)=aDesc(i) & " " & aChargeAmt(i)
'			end if
'		next
'	end if
'	hNoItemOC=tIndex1
'	if hNoItemOC>5 then
'		for i=0 to NoItemOC-1 Step 2
'			hOtherCharge(Fix(i/2))=hDesc(i) & " " & FormatAmount(hChargeAmt(i)) & "  " & hDesc(i+1) & " " & FormatAmount(hChargeAmt(i+1))
'		next
'	else
'		for i=0 to hNoItemOC
'			hOtherCharge(i)=hDesc(i) & " " & FormatAmount(hChargeAmt(i))
'		next
'	end If
'////////////////////////////////////////////////////////////////////////////////////////////////////

	'for i=0 to 2
	'	vOtherCharge1=vOtherCharge1 & aOtherChargeDesc(i) & "  " & aOtherCharge(i) & "  "
	'	vOtherCharge2=vOtherCharge2 & aOtherChargeDesc(i+3) & "  " & aOtherCharge(i+3) & "  "
	'	vOtherCharge3=vOtherCharge3 & aOtherChargeDesc(i+6) & "  " & aOtherCharge(i+6) & "  "
	'	hOtherCharge1=hOtherCharge1 & hOtherChargeDesc(i) & "  " & hOtherCharge(i) & "  "
	'	hOtherCharge2=hOtherCharge2 & hOtherChargeDesc(i+3) & "  " & hOtherCharge(i+3) & "  "
	'	hOtherCharge3=hOtherCharge3 & hOtherChargeDesc(i+6) & "  " & hOtherCharge(i+6) & "  "
	'next
	'vOtherCharge3=vOtherCharge3 & aOtherChargeDesc(9) & "  " & aOtherCharge(9)
	'hOtherCharge3=hOtherCharge3 & hOtherChargeDesc(9) & "  " & hOtherCharge(9)
end if
Set rsHAWB=Nothing
vPrintPort=awbPort

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

Function GetFileNumber()
    Dim resVal,rs,SQL
    Set rs = Server.CreateObject("ADODB.Recordset")
    SQL = "SELECT File# from mawb_number where elt_account_number=" & elt_account_number _
        & " AND mawb_no=N'" & vMAWB2 & "' and is_dome='N'"
    resVal = ""    
    Set rs = eltConn.execute (SQL)

    If Not rs.EOF And Not rs.BOF Then
        resVal = rs("File#").value
    End If
        
    GetFileNumber = resVal
End Function

%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Untitled Document</title>

<link href="../css/dotmatrix_hawb.css" rel="stylesheet" type="text/css" />
<style type="text/css">
<!--
body,td,th {
	font-size: 14px;
}
-->
</style>

<script language="javascript" type="text/javascript">
<% awbPrn = Replace(checkBlank(awbPrn,""),"\","\\") %>
var pdfPrinter = "<%=awbPrn %>";
var defaultPrinter = "";

function setDefault()
{
    defaultPrinter = FreightEasy.GET_DEFAULT_PRINTER();
}

function setProperties() {

	var pLeft = 6.25;
	var pRight = 0.01;
	var pTop = 11.25;
	var pBottom = 0.1;
	var pHeader = "";
	var pFooter = "";
	var pPrintBG = false;
	var pLandscape = false;
	var pPaper = "Fanfold  8 1/2 x 12 in";
	FreightEasy.ELT_PRINT_ALL_SET( pLeft, pRight, pTop, pBottom, pHeader, pFooter, pPrintBG, pLandscape, pPaper );
}

function printWindow() {
	try{
		FreightEasy.SET_DEFAULT_PRINTER(pdfPrinter);
		setProperties();
		
		var verStr = navigator.appVersion;
		
		if(verStr.match(/MSIE 7/ig))
		{
			FreightEasy.ELT_PREVIEW7();
		}
		else if(verStr.match(/MSIE 6/ig))
		{
			FreightEasy.ELT_PREVIEW();
		}
		else if(verStr.match(/MSIE 8/ig))
		{
		    FreightEasy.ELT_PREVIEW();
		}
		else
		{
			var answer = confirm("This version Browser may not be supported for this operation!\nDo you still want to print this document?");
			if(answer){FreightEasy.ELT_PREVIEW();}
		}
	}catch(error)
	{
		alert(error.description);
	}
}

function printWindowDelay()
{
	window.clearInterval(oInterval);
	FreightEasy.VbSendKeys ("{MENU}%{S}"); 
	FreightEasy.VbSendKeys ("{HOME}"); 
	FreightEasy.VbSendKeys (1);
}

/*
function pageSetup() {
    FreightEasy.SET_DEFAULT_PRINTER(pdfPrinter);
	FreightEasy.ELT_PREVIEW();
}
*/

function resetDefault() 
{
    FreightEasy.SET_DEFAULT_PRINTER(defaultPrinter);
}

</script>
</head>

<body onload="setDefault();" onunload="resetDefault()">
<div id="background"></div>
<div id="PageDiv">
<div id="txtMAWB" class="pagehead"><%=vMAWB %></div>
<div id="txtHAWBTop" align="right" class="pagehead"><%=vHAWB %></div>
<div id="txtShipperAcct"><%=vShipperAcct %></div>
<div id="txtConsigneeAcct"><%=vConsigneeAcct %></div>
<div id="txtShipperInfo">
  <textarea name="txtShipperInfo" wrap="hard" cols="40" rows="5" style="height:70px;" class="monotextarea" readonly="readonly"><%= vShipperInfo %></textarea></div>
<div id="txtConsigneeInfo"><textarea name="txtConsigneeInfo" wrap="hard" cols="40" rows="5" style="height:70px;" class="monotextarea" readonly="readonly"><%= vConsigneeInfo %></textarea> </div>
<div id="txtIssuedBy">
  <textarea name="txtIssuedBy" wrap="hard" cols="30" rows="3" class="monotextarea" style="font-size:17px; line-height:15px; font-weight:bold" readonly="readonly"><%= vIssuedBy %></textarea></div>
<div id="txtAgentInfo">
  <textarea name="txtAgentInfo" wrap="hard" cols="40" rows="3"  style="height:42px;" class="monotextarea" readonly="readonly"><%= vAgentInfo %></textarea></div>
<div id="txtAccountInfo"><textarea name="txtAccountInfo" wrap="hard" cols="40" rows="5" style="height:70px;" class="monotextarea" readonly="readonly"><%= vAccountInfo %></textarea></div>
<div id="txtAgentIATACode"><%= vAgentIATACode %></div>
<div id="txtAgentAcct"><%= vAgentAcct %></div>
<div id="txtDepartureAirport"><%=vDepartureAirport %></div>
<div id="txtReferenceNumber"><%=GetFileNumber() %></div>
<div id="txtTo"><%= vTo %></div>
<div id="txtBy"><%= vBy %></div>
<div id="txtTo1"><%= vTo1 %></div>
<div id="txtBy1"><%= vBy1 %></div>
<div id="txtTo2"><%= vTo2 %></div>
<div id="txtBy2"><%= vBy2 %></div>
<div id="txtCurrency"><%=vCurrency %></div>
<div id="txtChargeCode"><%=vChargeCode %></div>
<div id="ppd1"><%=Replace(vPPO_1,"Y","X") %></div>
<div id="coll1"><%=Replace(vCOLL_1,"Y","X") %></div>
<div id="cPPO2"><%=Replace(vPPO_2,"Y","X") %></div>
<div id="cCOLL2"><%=Replace(vCOLL_2,"Y","X") %></div>
<div id="txtDeclaredValueCarriage"><%=vDeclaredValueCarriage %></div>
<div id="txtDeclaredValueCustoms"><%=vDeclaredValueCustoms %></div>
<div id="txtDestAirport"><%=vDestAirport %></div>
<div id="txtFlightDate1"><%=vFlightDate1 %></div>
<div id="txtFlightDate2"><%=vFlightDate2 %></div>
<div id="txtInsuranceAmt"><%=vInsuranceAMT %></div>
<div id="txtHandlingInfo">
    <textarea name="txtHandlingInfo" wrap="hard" cols="70" rows="2" style="height:28px" class="monotextarea" readonly="readonly"><%= vHandlingInfo %></textarea></div>
<div id="txtDestCountry"><%=vDestCountry %></div>
<div id="txtSCI"><%=vSCI %></div>
<div id="txtDesc2">
  <textarea name="txtDesc2" wrap="hard" cols="23" rows="14" class="monotextarea" readonly="readonly"><%= vDesc2 %></textarea></div>
<div id="txtDesc2Add">
	<textarea name="txtDesc2Add" wrap="hard" cols="23" rows="9" class="monotextarea" readonly="readonly"><%=vDesc1 %></textarea></div>
<div id="txtPiece1"><%=aPiece(0) %></div>
<div id="txtGrossWeight1"><%=aGrossWeight(0) %></div>
<div id="txtKgLb1"><%=aKgLb(0) %></div>
<div id="txtChargeableWeight1"><%=aChargeableWeight(0) %></div>
<div id="txtRateClass1"><%=aRateClass(0) %></div>
<div id="txtItemNo1"><%=aItemNo(0) %></div>
<div id="txtRateCharge1"><%=aRateCharge(0) %></div>
<div id="txtTotal1"><%=aTotal(0) %></div>

<div id="txtPiece2"><%=aPiece(1) %></div>
<div id="txtGrossWeight2"><%=aGrossWeight(1) %></div>
<div id="txtKgLb2"><%=aKgLb(1) %></div>
<div id="txtChargeableWeight2"><%=aChargeableWeight(1) %></div>
<div id="txtRateClass2"><%=aRateClass(1) %></div>
<div id="txtItemNo2"><%=aItemNo(1) %></div>
<div id="txtRateCharge2"><%=aRateCharge(1) %></div>
<div id="txtTotal2"><%=aTotal(1) %></div>

<div id="txtPiece3"><%=aPiece(2) %></div>
<div id="txtGrossWeight3"><%=aGrossWeight(2) %></div>
<div id="txtKgLb3"><%=aKgLb(2) %></div>
<div id="txtChargeableWeight3"><%=aChargeableWeight(2) %></div>
<div id="txtRateClass3"><%=aRateClass(2) %></div>
<div id="txtItemNo3"><%=aItemNo(2) %></div>
<div id="txtRateCharge3"><%=aRateCharge(2) %></div>
<div id="txtTotal3"><%=aTotal(2) %></div>


<div id="txtDemDetail"><textarea name="txtDemDetail" wrap="hard" style="height:112px" cols="21" rows="8" class="monotextarea" readonly="readonly"><%=join(aDemDetail) %></textarea>
</div>

<div id="txtTotalPiece"><%=vTotalPiece %></div>
<div id="txtTotalGrossWeight"><%=vTotalGrossWeight %></div>
<div id="txtTotalWeightCharge"><%=vTotalWeightCharge %></div>
<div id="txtPrepaidWeightCharge"><%=vPrepaidWeightCharge %></div>
<div id="txtCollectWeightCharge"><%=vCollectWeightCharge %></div>
<div id="txtPrepaidValuationCharge"><%=vPrepaidValuationCharge %></div>
<div id="txtCollectValuationCharge"><%=vCollectValuationCharge %></div>
<div id="txtPrepaidTax"><%=vPrepaidTax %></div>
<div id="txtCollectTax"><%=vCollectTax %></div>

<div id="txtOtherCharge1"><%=aOtherCharge(0) %></div>
<div id="txtOtherCharge2"><%=aOtherCharge(1) %></div>
<div id="txtOtherCharge3"><%=aOtherCharge(2) %></div>
<div id="txtOtherCharge4"><%=aOtherCharge(3) %></div>
<div id="txtOtherCharge5"><%=aOtherCharge(4) %></div>

<div id="txtPrepaidOtherChargeAgent"><%=vPrepaidOtherChargeAgent %></div>
<div id="txtCollectOtherChargeAgent"><%=vCollectOtherChargeAgent %></div>
<div id="txtPrepaidOtherChargeCarrier"><%=vPrepaidOtherChargeCarrier %></div>
<div id="txtCollectOtherChargeCarrier"><%=vCollectOtherChargeCarrier %></div>
<div id="txtSignature"><textarea name="txtSignature" wrap="hard" style="height:28px" cols="50" rows="2" class="monotextarea" readonly="readonly"><%=vSignature  %></textarea></div>
<div id="txtSignatureUserName"><%=GetUserFLName(user_id) %></div>
<div id="txtPrepaidTotal"><%=vPrepaidTotal %></div>
<div id="txtCollectTotal"><%=vCollectTotal %></div>
<div id="txtExecute">
  <textarea name="txtExecute" wrap="hard" style="height:42px" cols="50" rows="3" class="monotextarea" readonly="readonly"><%= vExecute %></textarea></div>
<div id="txtConversionRate"><%=vConversionRate %></div>
<div id="txtCCCharge"><%=vCCCharge %></div>
<div id="txtChargeDestination"><%=vChargeDestination %></div>
<div id="txtFinalCollect"><%=vFinalCollect %></div>
<div id="txtHAWBBottom" align="right" class="pagehead"><%=vHAWB %></div>
</div>
</body>
</html>
