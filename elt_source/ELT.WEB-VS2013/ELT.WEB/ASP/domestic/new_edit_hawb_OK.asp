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
<%  
Response.Expires = 0  
Response.AddHeader "Pragma","no-cache"  
Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
%>		
</head>
<!--  #INCLUDE FILE="../include/header.asp" -->
     <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
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
DIM AddWC,AddOC,Edit,NewHAWB,Save, SaveAsNew,DeleteWC,DeleteOC,vHAWBPrefix,rURL,AutoSave,DeleteHAWB,qCancel
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

Dim vSalesPerson

'/////////////////////////////////////////////////////////////////////////////////////////
%>

<%

CALL INITIALIZATION
CALL GET_QUERY_STRINGS

if qCancel = "yes" then
		saved_HAWB_NUM = request("hHAWB")

		CALL DELETE_TEMP_HAWB( saved_HAWB_NUM )
		session("HAWB_CLOSE") = "OK"
		session("HAWB_NUM") = ""
		%>
			<script language="javascript">
				parent.fShowModal.hReturnValue.value = 'cancel';
				window.top.close();
			</script>			
		<%	
end if

CALL GET_HAWB_PREFIX_FROM_USER_PROFILE	

if Save="yes" then

	saved_HAWB_NUM = request("hHAWB")

	if vHAWB = saved_HAWB_NUM then
		session("HAWB_CLOSE") = "OK"
		session("HAWB_NUM") = vHAWB
		%>
			<script language="javascript">
				parent.fShowModal.hReturnValue.value = '<%= vHAWB %>';
				window.top.close();
			</script>			
		<%	
	else

		CALL DELETE_TEMP_HAWB( saved_HAWB_NUM )		
		CALL VERIFY_NEW_HAWB_NUM ( vHAWB )

		if not HAWB_Exists then
			CALL DELETE_TEMP_HAWB( saved_HAWB_NUM )		
			session("HAWB_CLOSE") = "OK"
			session("HAWB_NUM") = vHAWB
			%>
				<script language="javascript">
					parent.fShowModal.hReturnValue.value = '<%= vHAWB %>';
					window.top.close();
				</script>			
			<%
		end if
	end if
end if

if SaveAsNew="yes" then
	saved_HAWB_NUM = request("hHAWB")
	if Not saved_HAWB_NUM  = "" then
		CALL DELETE_TEMP_HAWB( saved_HAWB_NUM )			
	end if
	CALL GET_NEW_HAWB_NUM		
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
	SQL= "delete hawb_master where elt_account_number = " & elt_account_number & " and hawb_num='" _
	    & saved_HAWB_NUM & "'" & " and is_dome='Y' and CAST(Agent_Info AS VARCHAR)='Auto Generated No.'"	
	eltConn.Execute SQL	
END SUB
%>

<%
SUB GET_QUERY_STRINGS
	Save=Request.QueryString("Save")
	qCancel=Request.QueryString("cancel")
	NewHAWB=Request.QueryString("New")
	vHAWB=Request.QueryString("HAWB")
	rURL=Request.QueryString("rURL")
	SaveAsNew=Request.QueryString("SaveAsNew")
	vHAWBPrefix=Request.QueryString("Prefix")
	
	vSalesPerson=Request.QueryString("salesPerson")'-----------------------------sales person
	
	'Response.Write("----------------------"&vSalesPerson)

	if NewHAWB="" then 
		NewHAWB=Request("hNewHAWB")
	end if
	
	if NewHAWB="" and Edit = ""  then
		NewHAWB="yes"
	end if
	
	if vHAWBPrefix="NONE" then 
		vHAWBPrefix="" 
	end if

END SUB
%>

<%
SUB INITIALIZATION
	Set rs = Server.CreateObject("ADODB.Recordset")
	Set rs3 = Server.CreateObject("ADODB.Recordset")
	errHAWB = ""
END SUB
%>

<%

SUB FINAL_SCREEN_PREPARE

	if  vNotifyAcct="" or isnull(vNotifyAcct) then 
		vNotifyAcct="0"
	end if
		
	if pIndex=0 then 
		pIndex=1 
	end if
END SUB
%>

<%

SUB UPDATE_NEXT_HAWB_NUMBER_IN_USER_TABLE

			pos=0
			pos=instr(vHAWB,"-")
			if pos>0 then
				tPrefix=Mid(vHAWB,1,pos-1)
				tHAWB_Number=Mid(vHAWB,pos+1,32)
			else
				tPrefix="NONE"
				tHAWB_Number=vHAWB
			end if
			SQL= "select * from user_prefix where elt_account_number=" & elt_account_number & " and type='DOME' and prefix='" & tPrefix & "'"
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
%>

<%
SUB VERIFY_NEW_HAWB_NUM ( vHAWB )'<---------------------------------------------------- it is to check if it is really created!!!

HAWBExist="Y"
HAWB_Exists = false
session("HAWB_NUM") = ""

	SQL= "select * from hawb_master where elt_account_number = " & elt_account_number & " and is_dome='Y' and HAWB_NUM='" & vHAWB & "'"
	rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	If rs.EOF=true Then		
		rs.AddNew
		rs("elt_account_number")=elt_account_number
		rs("HAWB_NUM")=vHAWB
		rs("agent_name")=""
		rs("agent_no")="0"
		rs("agent_info")=""
		rs("DEP_AIRPORT_CODE") = ""
		rs("airline_vendor_num")=0
		rs("Shipper_Name") = ""
		rs("Shipper_Info") = ""
		rs("Shipper_Account_Number") = ""
		rs("ff_shipper_acct") = ""
		rs("Consignee_Name") = ""
		rs("Consignee_Info") = ""
		rs("Consignee_acct_num") = ""
		rs("ff_consignee_acct") = ""
		rs("Issue_Carrier_Agent") = ""
		rs("Agent_IATA_Code") = ""
		rs("Account_No") = ""
		rs("Departure_Airport") = ""
		rs("departure_state")=""
		rs("To_1") = ""
		rs("By_1") = ""
		rs("To_2") = ""
		rs("By_2") = ""
		rs("To_3") = ""
		rs("By_3") = ""
		rs("Dest_Airport") = ""
		rs("Flight_Date_1") = ""
		rs("Flight_Date_2") = ""
		rs("export_date")=0
		rs("IssuedBy")=""
		rs("Account_Info") = ""
		rs("Notify_No") = ""
		rs("Currency") = ""
		rs("Charge_Code") = ""
		rs("PPO_1") = ""
		rs("COLL_1") = ""
		rs("PPO_2") = ""
		rs("COLL_2") = ""
		rs("Declared_Value_Carriage") = ""
		rs("Declared_Value_Customs")= ""
		rs("Insurance_AMT")=""
		rs("Handling_Info")=""
		rs("dest_country")=""
		rs("SCI")=""
		rs("total_pieces")=0
		rs("total_gross_weight")=0
		rs("total_chargeable_weight")=0
		rs("total_weight_charge_hawb")=0
		rs("af_cost")=0
		rs("agent_profit")=0
		rs("agent_profit_share")=0
		rs("adjusted_weight")=0
		rs("desc1")=""
		rs("desc2")=""
		rs("manifest_desc")=""
		rs("lc")=""
		rs("ci")=""
		rs("other_ref")=""
		rs("Date_Last_Modified")=Now

		rs("Execution")=""
		rs("colo")=""
		rs("colo_pay")=""
		rs("coloder_elt_acct")=0

		rs("Agent_Info")= "Auto Generated No."
		rs("date_executed")=Now
		rs("prepaid_invoiced")="N"
		rs("collect_invoiced")="N"
		
		'----------------------------------------------------------------
		 rs("CreatedBy")=session_user_lname	
		 rs("CreatedDate")=Now
		 rs("SalesPerson")=	vSalesPerson			
		'----------------------------------------------------------------	
		
	
		rs("is_master_closed")="N"		
        rs("is_invoice_queued")="N"
        rs("is_dome")="Y"
        
		NewForm="Y"
		HAWBExist="N"
		rs.update
		rs.close
		session("HAWB_NUM") = vHAWB
	else
		rs.close
		HAWB_Exists = true
		errHAWB = vHAWB
	end if
	
END SUB
%>

<%
SUB GET_NEW_HAWB_NUM '-------------------------------------------------------> here is when it actaully creates new hawb
' for new hawb, get hawb_num
DIM vNextHAWB,HAWBExist

vHAWB="0"
vNextHAWB=request("lstHAWBPrefix")

if vNextHAWB = "" then
	vNextHAWB = request.querystring("NEXTPREFIX")
end if

'response.write vNextHAWB

if Not vHAWBPrefix="" then
	vHAWB=vHAWBPrefix & "-" & vNextHAWB
else
	vHAWB=vNextHAWB
end if

HAWBExist="Y"


do while HAWBExist="Y"
	SQL= "select * from hawb_master where elt_account_number = " & elt_account_number & " and is_dome='Y' and HAWB_NUM='" & vHAWB & "'"
	rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	If rs.EOF=true Then		
		rs.AddNew
		rs("elt_account_number")=elt_account_number
		rs("HAWB_NUM")=vHAWB
		rs("Agent_Info")= "Auto Generated No."
		rs("date_executed")=Now
		rs("prepaid_invoiced")="N"
		rs("collect_invoiced")="N"
		NewForm="Y"
		HAWBExist="N"
		'----------------------------------------------------------------
		 rs("CreatedBy")=session_user_lname	
		 rs("CreatedDate")=Now
		 rs("SalesPerson")=	vSalesPerson			
		'----------------------------------------------------------------	
		rs("is_dome")="Y"
		
		rs.update
		rs.close
		session("HAWB_NUM")	= vHAWB	
	else
		rs.close
		vNextHAWB=vNextHAWB+1
		if Not vHAWBPrefix="" then
			vHAWB=vHAWBPrefix & "-" & vNextHAWB
		else
			vHAWB=vNextHAWB
		end if
	end if
loop			

END SUB
%>

<%
Sub GET_HAWB_PREFIX_FROM_USER_PROFILE
'get Hawb prefix from user profile
	SQL= "select prefix,next_no from user_prefix where elt_account_number = " & elt_account_number & " and type='DOME' order by seq_num"
	rs3.Open SQL, eltConn, , , adCmdText
	pIndex=0
	do While Not rs3.EOF
		aHAWBPrefix(pIndex)=rs3("prefix")
		aNextHAWB(pIndex)=rs3("next_no")
		rs3.MoveNext
		pIndex=pIndex+1
	loop
	rs3.Close
End Sub
%>

<body link="336699" vlink="336699" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="self.focus()">
<br>
      <form method="post" name="frmHAWB">
		<input type="hidden" name="hHAWBPrefix" value="<%= vHAWBPrefix %>">
	 	<input type="hidden" name="hNewHAWB" value="<%= NewHAWB %>">
	 	<input type="hidden" name="hHAWB" value="<%= vHAWB %>">
	 	<input type="hidden" name="herrHAWB" value="<%= errHAWB %>">
		<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="bodycopy">
                <tr>
                  <td class="formbody"><div align="center">Next domestic bill number :</div></td>
                </tr>
                <tr>
                  <td class="formbody"></td>
                </tr>
                <tr>
                  <td height="22" align="center">&nbsp;<font color="c16b42"><strong>Bill No.</strong></font>&nbsp;&nbsp;
                    <select name="lstHAWBPrefix" size="1" class="smallselect" style="WIDTH: 60px" onChange="PrefixChange()">
                      <% For i=0 To pIndex-1 %>
                      <option value="<%= aNextHAWB(i) %>" <% if vHAWBPrefix=aHAWBPrefix(i) then response.write("selected") %>><%= aHAWBPrefix(i) %></option>
                      <%  Next  %>
                    </select>
				  <%if HAWB_Exists then%> 
					 <input name="txtHAWB" class="shorttextfieldbold" style="WIDTH: 100px; color:#FF0000" tabindex=1 value="<%= vHAWB %>" size="20">
				  <%else%>
                    <input name="txtHAWB" class="shorttextfieldbold" style="WIDTH: 100px" tabindex=1 value="<%= vHAWB %>" size="20">
				  <%end if%>				  </td>				
                </tr>

				  <%if HAWB_Exists then%> 
                <tr>
                  <td height="18" align="center">
					  <P align="center"><span class="style3">Domestic Bill Number: <%=vHAWB%> already exists!</span></P>
				  </td>
                </tr>
                <tr>
                  <td height="18" align="center">
					  <P align="center"><span class="style3">Please choose another number! </span></P>
				  </td>
                </tr>
			      <%end if%>
				
        </table>	
        <% If pIndex > 0 Then %>
      <P align="center"><input name="OK" type="button" id="OK" value="OK" onClick="OkClick()"  style="width:70px">
        <input name="Cancel" type="button" id="Cancel" value="Cancel" onClick="CancelClick()" style="width:70px">
      </P>
      <% Else %>
      <P align="center"><span class="style3">Please, enter a prefix for domestic in company information page</span></P>
      <% End If %>
      
		
</form>
</body>
<script type="text/javascript">
function OkClick(){

    if (document.frmHAWB.txtHAWB.value == "" )
        return false;

    var already_e = "<%= HAWB_Exists %>";
    var errHAWB = "<%= errHAWB %>";
    var vHAWB = document.frmHAWB.txtHAWB.value;

    var tmpHAWB = vHAWB;
    var pos=vHAWB.indexOf("-");
    if (pos>=0 )
	    tmpHAWB=vHAWB.substring(pos+1,20);

    if (already_e == "True" ){
     if (errHAWB == vHAWB )
        return false;
    }

    var sindex = document.frmHAWB.lstHAWBPrefix.selectedIndex;
    var HAWBPrefix = document.frmHAWB.lstHAWBPrefix.item(sindex).text;
    var NEXTPrefix = document.frmHAWB.lstHAWBPrefix.item(sindex).value;
    document.frmHAWB.action = "new_edit_hawb_ok.asp?save=yes&prefix=" + HAWBPrefix + "&HAWB=" + vHAWB + "&NEXTPREFIX=" + NEXTPrefix;
    document.frmHAWB.method = "POST";
    document.frmHAWB.target = "_self";
    frmHAWB.submit();
}

function CancelClick(){
    document.frmHAWB.action = "new_edit_hawb_ok.asp?cancel=yes";
    document.frmHAWB.method = "POST";
    document.frmHAWB.target = "_self";
    frmHAWB.submit();
}

function PrefixChange(){

    var sindex = document.frmHAWB.lstHAWBPrefix.selectedIndex;
    var HAWBPrefix = document.frmHAWB.lstHAWBPrefix.item(sindex).text;
    var NEXTPrefix = document.frmHAWB.lstHAWBPrefix.item(sindex).value;

    var vHAWB = "";
    document.frmHAWB.action = "new_edit_hawb_ok.asp?SaveAsNew=yes&prefix=" + HAWBPrefix + "&HAWB=" + vHAWB + "&NEXTPREFIX=" + NEXTPrefix;
    document.frmHAWB.method = "POST";
    document.frmHAWB.target = "_self";
    frmHAWB.submit();
}

</script>

</html>