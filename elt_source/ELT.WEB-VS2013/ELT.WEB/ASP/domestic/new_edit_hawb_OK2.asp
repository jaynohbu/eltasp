<!--  #INCLUDE FILE="../include/transaction.txt" -->
<html>
<head>
<title>Air Export</title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<link href="../css/elt_css.css" rel="stylesheet" type="text/css">
<!--  #INCLUDE FILE="../include/connection.asp" -->
<style type="text/css">
<!--
.style3 {color: #FF0000}
-->
</style>
</head>
<!--  #INCLUDE FILE="../include/header.asp" -->
     <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->

<%
'////////////////////////////////////////////////////////////////////////////////////////
DIM vTotalHAWB,vQueueID
Dim NoHAWB,errHAWB
Dim tHAWB,tAW,tRateClass
Dim vExecutionDatePlace
Dim AgentName,AgentCity,AgentState,AgentZip,AgentCountry
Dim pIndex
DIM vRefNo 
DIM vDeclaredValueCarriage
DIM AddWC,AddOC,Edit,NewHAWB,Save,SaveAsNew,DeleteWC,DeleteOC,vHAWBPrefix,rURL,AutoSave,DeleteHAWB,qCancel,qClose
Dim qMAWB,vMAWB,vMAWBInfo,vHAWB
DIM aChargeItemNo(100),aChargeItemName(100),aChargeItemDesc(100),chIndex 
Dim aColoderName(100),aColoderAcct(100)
'/////////////////// GET_MAWB_INFO ///////////////////////////////////////////////////////
Dim mMawbNo,mDepartureAirport, mTo, mBy, mTo1, mBy1, mTo2, mBy2,mDestAirport,mDestCountry
Dim mFlight1,mFlight2,mETDDate,mFlightDate1,mFlightDate2,mCarrierDesc,mCount
DIM mIndex,mFile,mOrgNum,mDepartureAirportCode
DIM mExportDate,mDepartureState,vManifestDesc
Dim vAirOrgNum,vFFShipperAcct,vFFAgentName
DIM vFFAgentAcct,vFFAgentInfo
DIM	vFFConsigneeAcct
DIM vDepartureState
DIM vExportDate
DIM	vNotifyAcct
DIM	vCI,vOtherRef,vLC
DIM vPrepaidWeightCharge,vCollectWeightCharge,vPrepaidOtherChargeAgent,vCollectOtherChargeAgent
DIM vPrepaidOtherChargeCarrier,vCollectOtherChargeCarrier,vPrepaidTotal
DIM vCollectTotal,vPrepaidValuationCharge,vCollectValuationCharge
DIM	vPrepaidTax,vCollectTax,vConversionRate,vCCCharge,vChargeDestination,vFinalCollect
DIM vExecute,vCOLO,vCOLOPay,vColoderAcct
DIM wIndex,vDemDetail,oIndex,NoItemOC
'/////////////////// get agent,shipper,consignee,vendor info /////////////////////////////
Dim aAgentName(4096),aAgentInfo(4096),aAgentAcct(4096)
Dim aShipperName(4096),aShipperInfo(4096),aShipperAcct(4096)
Dim aConsigneeName(4096),aConsigneeInfo(4096),aConsigneeAcct(4096)
Dim aNotifyName(8192),aNotifyInfo(8192),aNotifyAcct(8192)
Dim aVendorName(4096),aVendorAcct(4096)
DIM aIndex,cIndex,sIndex,vIndex,nIndex,HAWB_Exists
'/////////////////////////////////////////////////////////////////////////////////////////

Dim qShipperName,vShipperInfo,vShipperName,qShipperAcct,vShipperAcct
Dim qConsigneeName, vConsigneeName, vConsigneeInfo,qConsigneeAcct,vConsigneeAcct
Dim qNotify
Dim vAgentInfo,vAgentIATACode,vAgentAcct,vDepartureAirport, vTo, vBy, vTo1, vBy1, vTo2, vBy2
Dim vOriginPortID
Dim vDestAirport,vFlightDate1,vFlightDate2
Dim vIssuedBy,vAccountInfo
Dim vCurrency, vChargeCode, vPPO_1, vCOLL_1, vPPO_2, vCOLL_2
Dim vDeclaredValueCustoms,vInsuranceAMT
Dim vHandlingInfo, vDestCountry,vSCI,vSignature,vPlaceExecuted
Dim aMAWB(1000), aMAWBInfo(1000),MAWBTemp
Dim aTranNo(3),aPiece(1536),aUnitQty(1536),aGrossWeight(1536),aAdjustedWeight(1536),aKgLb(1536),aRateClass(1536),aItemNo(1536)
Dim aDimension(1536),aDimDetail(3),aChargeableWeight(1536),aRateCharge(1536),aTotal(1536)
Dim vTotalPieces,vTotalGrossWeight,vTotalWeightCharge
Dim vDesc1,vDesc2
Dim vShowWeightChargeShipper,vShowWeightChargeConsignee
Dim aCarrierAgent(1280),aCollectPrepaid(1280),aChargeCode(1280)
Dim aDesc(1280),aChargeAmt(1280),aVendor(1280),aCost(1280),aOtherCharge(640)
Dim vShowPrepaidOtherChargeShipper,vShowCollectOtherChargeShipper
Dim vShowPrepaidOtherChargeConsignee,vShowCollectOtherChargeConsignee
Dim NotifyTemp,NotifyInfoTemp
Dim cName,cAddress,cCity,cState,cZip,cCountry,cPhone
Dim aHAWBPrefix(128),aNextHAWB(128)
Dim rs,SQL,rs3
'/////////////////////////////////////////////////////////////////////////////////////////
%>

<%

qClose=Request.QueryString("Close")

if qClose = "yes" then

	vHAWB = session("HAWB_NUM")
	
	if not session("HAWB_CLOSE") = "OK" then
		CALL DELETE_TEMP_HAWB( vHAWB )
		%>
			<script language="javascript">
				window.close();
			</script>			
		<%		
	end if
	
end if

%>

<%
'///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'//////////////////// SUB ROUTINES /////////////////////////////////////////////////////////////////////////////////
'///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
%>

<%
SUB DELETE_TEMP_HAWB( saved_HAWB_NUM )
	SQL= "delete hawb_master where elt_account_number = " & elt_account_number _
	    & " and hawb_num='" & saved_HAWB_NUM & "'" & " and CAST(Agent_Info AS VARCHAR)='Auto Generated No.' and is_dome='Y'"	
	eltConn.Execute SQL	
END SUB
%>

</html>