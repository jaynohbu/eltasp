<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>New/Edit HBOL</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
<!--  #INCLUDE FILE="../include/connection.asp" -->
<%  
Response.Expires = 0  
Response.AddHeader "Pragma","no-cache"  
Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
%>		
</head>
<!--  #INCLUDE FILE="../include/header.asp" -->
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<%
'/////////////////// FOR SUB MODULE //////////////////////////////////////////
DIM pIndex,NoItem,vForwardAgentInfo,vDestCountry,vLoadingPier
DIM vVN,vLoadingPort,vScale,vGWLB,vMCFT,vManifestDesc,vDemDetail
DIM vCollectOtherCharge,vPrepaidOtherCharge
DIM tIndex,vHBOLPrefix,vNextHBOL,NewForm
DIM qDelete,Save,Add,Edit,DeleteHBOL,GoNext,NewHBOL,SaveAsNew,OverwriteHBOL
DIM dItemNo,cIndex,sIndex,vIndex,aIndex,chIndex
Dim aShipperName(4096),aShipperInfo(4096),aShipperAcct(4096)
Dim aConsigneeName(4096),aConsigneeInfo(4096),aConsigneeAcct(4096)
Dim aVendorName(4096),aVendorAcct(4096),bIndex
Dim aAgentName(4096),aAgentAcct(4096),aAgentInfo(4096)
Dim aItemNo(100),aItemName(100),aItemDesc(100)
Dim aBookingNum(100),aExportCarrier(100),aLoadingPort(100),aUnloadingPort(100)
Dim aDeliveryPlace(100),aBookingInfo(100)
DIM qCancel,rURL,HAWB_Exists,errHAWB
%>

<%
Dim rs,rs1,rs3,IVstrMsg
Dim vHBOL,vMBOL,vBookingNum,vAgentName,vAgentInfo,vAgentAcct
Dim vShipperName,vShipperInfo,vShipperAcct
Dim vConsigneeName,vConsigneeInfo,vConsigneeAcct,vNotifyInfo
Dim vExportRef,vOriginCountry,vExportInstr,vLandingPier,vMoveType
Dim vConYes,vPreCarriage,vPreReceiptPlace
Dim vExportCarrier,vLandingPort,vUnloadingPort,vDepartureDate
Dim vDeliveryPlace,vDesc1,vDesc2,vDesc3,vDesc4,vDesc5,vDesc6,vPieces,vWeightCP,vGrossWeight
Dim vMeasurement
Dim vWidth,vLength,vHeight,vChargeableWeight,vChargeRate
Dim vTotalWeightCharge
Dim vShowPrepaidWeightCharge,vShowCollectWeightCharge
Dim vShowPrepaidOtherCharge,vShowCollectOtherCharge
Dim vOtherChargeCP,vChargeItem,vChargeAmt,vVendor,vCost
Dim vDeclaredValue,vBy,vDate,vPlace
Dim aChargeCP(64),aChargeItem(64),aChargeAmt(64),aChargeVendor(64),aChargeCost(64)
Dim aChargeNo(64),aChargeItemName(64) 
Dim vTotalPrepaid,vTotalCollect
Dim aHBOLPrefix(128),aNextHBOL(128)
Dim vQueueID
Dim vSalesPerson,IsCopied
%>

<%
CALL INITIALIZATION
CALL GET_QUERY_STRINGS

if qCancel = "yes" then
		saved_HBOL_NUM = request("hHBOL")

		CALL DELETE_TEMP_HAWB( saved_HBOL_NUM )
		session("HBOL_CLOSE") = "OK"
		session("HBOL_NUM") = ""
		%>
			<script language="javascript">
				parent.fShowModal.hReturnValue.value = 'cancel';
				window.top.close();
			</script>			
		<%	
end if

CALL GET_HAWB_PREFIX_FROM_USER_PROFILE	

if Save="yes" then

	saved_HBOL_NUM = request("hHBOL")

	if vHBOL = saved_HBOL_NUM then
		session("HBOL_CLOSE") = "OK"
		session("HBOL_NUM") = vHAWB
		%>
			<script language="javascript">
				parent.fShowModal.hReturnValue.value = '<%= vHBOL %>';
				window.top.close();
			</script>			
		<%	
	else

		CALL DELETE_TEMP_HAWB( saved_HBOL_NUM )		
		CALL VERIFY_NEW_HAWB_NUM ( vHBOL )

		if not HAWB_Exists then
			CALL DELETE_TEMP_HAWB( saved_HBOL_NUM )		
			session("HBOL_CLOSE") = "OK"
			session("HBOL_NUM") = vHBOL
			%>
				<script language="javascript">
					parent.fShowModal.hReturnValue.value = '<%= vHBOL %>';
					window.top.close();
				</script>			
			<%
		end if
	end if
end if

if SaveAsNew="yes" then
	saved_HBOL_NUM = request("hHBOL")
	if Not saved_HBOL_NUM  = "" then
		CALL DELETE_TEMP_HAWB( saved_HBOL_NUM )			
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
SUB GET_QUERY_STRINGS

IsCopied=checkBlank(Request.QueryString.Item("IsCopied"),"no")
Save=Request.QueryString("Save")
qCancel=Request.QueryString("cancel")
NewHBOL=Request.QueryString("New")
vHBOL=Request.QueryString("HBOL")
rURL=Request.QueryString("rURL")
SaveAsNew=Request.QueryString("SaveAsNew")
vHBOLPrefix=Request.QueryString("Prefix")
vSalesPerson=Request.QueryString("salesPerson")

END SUB
%>

<%
SUB VERIFY_NEW_HAWB_NUM ( vHBOL )

HAWBExist="Y"
HAWB_Exists = false

	SQL= "select * from hbol_master where elt_account_number = " & elt_account_number & " and HBOL_NUM=N'" & vHBOL & "'"

	rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	If rs.EOF=true Then		
		rs.AddNew
		rs("elt_account_number")=elt_account_number
		rs("HBOL_NUM")=vHBOL

		rs("booking_num")=""
		rs("mbol_num")=""
		rs("agent_name")=""
		rs("agent_no")=0
		rs("agent_info")=""
		rs("shipper_name")=""
		rs("shipper_info")=""
		rs("shipper_acct_num")=0
		rs("consignee_name")=""
		rs("consignee_info")=""
		rs("consignee_acct_num")=0
		rs("notify_name")=""
		rs("notify_info")=""
		rs("notify_acct_num")=0
		rs("export_ref")=""
		rs("forward_agent_info")=""
		rs("origin_country")=""
		rs("dest_country")=""
		rs("export_instr")=""
		rs("loading_pier")=""
		rs("move_type")=""
		rs("containerized")=""
		rs("pre_carriage")=""
		rs("pre_receipt_place")=""
		rs("export_carrier")=""
		rs("vessel_name")=""
		rs("loading_port")=""
		rs("unloading_port")=""
		rs("delivery_place")=""
'----------------------------------------------------------------------- here is to make sure to enter the data
         rs("CreatedBy")=session_user_lname	
		 rs("CreatedDate")=Now
		 rs("SalesPerson")=	vSalesPerson	
'------------------------------------------------------------------------
		rs("Agent_Info")= "Auto Generated No."
		rs("prepaid_invoiced")="N"
		rs("collect_invoiced")="N"
		NewForm="Y"
		HAWBExist="N"
		rs.update
		rs.close
		session("HAWB_NUM") = vHBOL
	else
		rs.close
		HAWB_Exists = true
		errHAWB = vHBOL
	end if
	
END SUB
%>

<%
SUB DELETE_TEMP_HAWB( saved_HBOL_NUM )
	SQL= "delete hbol_master where elt_account_number = " & elt_account_number & " and hbol_num=N'" _
	    & saved_HBOL_NUM & "'" & " and CAST(Agent_Info AS VARCHAR)='Auto Generated No.'"	
	eltConn.Execute SQL	
END SUB
%>


<%
SUB GET_NEW_HAWB_NUM
' for new hawb, get hawb_num
DIM vNextHAWB,HAWBExist

vHBOL="0"
vNextHAWB=request("lstHBOLPrefix")

if vNextHAWB = "" then
	vNextHAWB = request.querystring("NEXTPREFIX")
end if

'response.write vNextHAWB

if Not vHBOLPrefix="" then
	vHBOL=vHBOLPrefix & "-" & vNextHAWB
else
	vHBOL=vNextHAWB
end if

HAWBExist="Y"


do while HAWBExist="Y"
	SQL= "select * from hbol_master where elt_account_number = " & elt_account_number & " and HBOL_NUM=N'" & vHBOL & "'"
	rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	If rs.EOF=true Then		
		rs.AddNew
		rs("elt_account_number")=elt_account_number
		rs("HBOL_NUM")=vHBOL
		rs("Agent_Info")= "Auto Generated No."
		rs("tran_date")=Now
		
		'------------------------------------------------------------ here is when it first crates data
		 rs("CreatedBy")=session_user_lname	
		 rs("CreatedDate")=Now
		 rs("SalesPerson")=	vSalesPerson	
		'--------------------------------------------------------------
		NewForm="Y"
		HAWBExist="N"
		rs.update
		rs.close
		session("HBOL_NUM")	= vHBOL	
	else
		rs.close
		vNextHAWB=vNextHAWB+1
		if Not vHBOLPrefix="" then
			vHBOL=vHBOLPrefix & "-" & vNextHAWB
		else
			vHBOL=vNextHAWB
		end if
	end if
loop			

END SUB
%>

<%
SUB GET_HAWB_HEADER_INFO_FROM_SCREEN	
	vTotalPrepaid=0
	vTotalCollect=0
	NoItem=Request("hNoItem")
	if NoItem="" then
		NoItem=0
	else
		NoItem=CInt(NoItem)
	end if
	vHBOL=Request("txtHBOL")
	if vHBOL="" then vHBOL="0"
	vMBOL=Request("txtMBOL")
	
	vBookingNum=Request("hBookingNum")
	vAgentName=Request("hAgent")
	vAgentInfo=Request("hAgentInfo")
	vAgentAcct=Request("hAgentAcct")
	if not vAgentAcct="" then 
		vAgentAcct=cLng(vAgentAcct)
	else
		vAgentAcct=0
	end if
	vShipperName=Request("hShipper")
	vShipperInfo=Request("txtShipperInfo")
	vShipperAcct=Request("hShipperAcct")
	if not vShipperAcct="" then
		vShipperAcct=cLng(vShipperAcct)
	else
		vShipperAcct=0
	end if
	vConsigneeName=Request("hConsignee")
	vConsigneeInfo=Request("txtConsigneeInfo")
	vConsigneeAcct=Request("hConsigneeAcct")
	if not vConsigneeAcct="" then
		vConsigneeAcct=cLng(vConsigneeAcct)
	else
		vConsigneeAcct=0
	end if
	vNotifyInfo=Request("txtNotifyInfo")
	vExportRef=Request("txtExportRef")
	vForwardAgentInfo=Request("txtForwardAgentInfo")
	vOriginCountry=Request("txtOriginCountry")
	vDestCountry=Request("hDestCountry")
	vExportInstr=Request("txtExportInstr")
	vLoadingPier=Request("txtLoadingPier")
	vMoveType=Request("lstMoveType")
	vConYes=Request("cConYes")
	vPreCarriage=Request("txtPreCarriage")
	vPreReceiptPlace=Request("txtPreReceiptPlace")
	vExportCarrier=Request("txtExportCarrier")
	vVN=Request("hVesselName")
	vLoadingPort=Request("txtLoadingPort")
	vUnloadingPort=Request("txtUnloadingPort")
	vDeliveryPlace=Request("txtDeliveryPlace")
	vDepartureDate=Request("hDepartureDate")
	if IsDate(vDepartureDate)=false then vDepartureDate="1/1/1900"
	vWeightCP=Request("lstWeightCP")
	vPieces=Request("txtPieces")
	if vPieces="" then vPieces=0
	vScale=Request("lstScale")
	vGrossWeight=Request("txtGrossWeight")
	if Not vGrossWeight="" then 
		vGWLB=vGrossWeight*2.2
	else
		vGrossWeight=0
		vGWLB=0
	end if
	vMeasurement=Request("txtMeasurement")
	if Not vMeasurement="" then 
		vMCFT=FormatNumber(vMeasurement*35.314666721,2)
	else
		vMeasurement=0
		vMCFT=0
	end if
	vChargeRate=Request("txtChargeRate")
	if vChargeRate="" then vChargeRate=0
	'vLength=Request("txtLength")
	'if vLength="" then vLength=0
	'vWidth=Request("txtWidth")
	'if vWidth="" then vWidth=0
	'vHeight=Request("txtHeight")
	'if vHeight="" then vHeight=0
	'vChargeableWeight=Request("txtChargeableWeight")
	'if vChargeableWeight="" then vChargeableWeight=0
	'vChargeRate=Request("txtChargeRate")
	'if vChargeRate="" then vChargeRate=0
	vTotalWeightCharge=Request("txtTotalWeightCharge")
	if vTotalWeightCharge="" then vTotalWeightCharge=0
	if vWeightCP="P" then
		vTotalPrepaid=vTotalPrepaid+vTotalWeightCharge
	else
		vTotalCollect=vTotalCollect+vTotalWeightCharge
	end if
	vDesc1=Request("txtDesc1")
	vDesc2=Request("txtDesc2")
	vDesc3=Request("txtDesc3")
	'vDesc4=Request("txtDesc4")
	vDesc5=Request("txtDesc5")
	vDesc6=Request("txtDesc6")
	vManifestDesc=Request("txtManifestDesc")
	vDemDetail=Request("hDemDetail")
	vShowPrepaidWeightCharge=Request("cShowPWeightCharge")
	vShowCollectWeightCharge=Request("cShowCWeightCharge")
	vShowPrepaidOtherCharge=Request("cShowPOtherCharge")
	vShowCollectOtherCharge=Request("cShowCOtherCharge")
	for i=0 to NoItem-1
		aChargeNo(i)=Request("hChargeNo" & i)
		aChargeCP(i)=Request("lstOtherChargeCP" & i)
		if aChargeCP(i)="C" then
			vCollectOtherCharge="Y"
		else
			vPrepaidOtherCharge="Y"
		end if
		aChargeItemName(i)=Request("hItemName" & i)
		aChargeItem(i)=Cint(Request("lstChargeItem" & i))
		aChargeAmt(i)=Request("txtChargeAmt" & i)
		if aChargeAmt(i)="" then aChargeAmt(i)=0
		'aChargeVendor(i)=cLng(Request("lstVendor" & i))
		'aChargeCost(i)=Request("txtCost" & i)
		if aChargeCost(i)="" then aChargeCost(i)=0
	next
	vDeclaredValue=Request("txtDeclaredValue")
	if vDeclaredValue="" then vDeclaredValue=0
	vBy=Request("txtBy")
	vDate=Request("txtDate")
	if vDate="" then vData=now
	vPlace=Request("txtPlace")
	tIndex=NoItem
	if qDelete="yes" then
		dItemNo=Request.QueryString("dItemNo")
		for i=dItemNo to NoItem-1
			aChargeNo(i)=aChargeNo(i+1)
			aChargeCP(i)=aChargeCP(i+1)
			aChargeItem(i)=aChargeItem(i+1)
			aChargeItemName(i)=aChargeItemName(i+1)
			aChargeAmt(i)=aChargeAmt(i+1)
			'aChargeVendor(i)=aChargeVendor(i+1)
			'aChargeCost(i)=aChargeCost(i+1)
		next
		NoItem=NoItem-1
	end if
	for i=0 to NoItem-1
		if aChargeCP(i)="P" then
			vTotalPrepaid=vTotalPrepaid+aChargeAmt(i)
		else
			vTotalCollect=vTotalCollect+aChargeAmt(i)
		end if
	next
	tIndex=NoItem
END SUB	
%>

<%
SUB GET_HAWB_PREFIX_FROM_USER_PROFILE
'get Hawb prefix from user profile
SQL= "select prefix,next_no from user_prefix where elt_account_number = " & elt_account_number & " and type='HBOL' order by seq_num"

rs.Open SQL, eltConn, , , adCmdText
pIndex=0
do While Not rs.EOF
	aHBOLPrefix(pIndex)=rs("prefix")
	aNextHBOL(pIndex)=rs("next_no")
	rs.MoveNext
	pIndex=pIndex+1
loop
rs.Close
END SUB
%>

<%
SUB INITIALIZATION
	Set rs = Server.CreateObject("ADODB.Recordset")
	Set rs3 = Server.CreateObject("ADODB.Recordset")
END SUB
%>

<%

SUB FINAL_SCREEN_PREPARE

	IF NOT vHBOL = "" AND NOT vHBOL = "0" THEN
		CALL CHECK_INVOICE_STATUS_HAWB(	vHBOL, elt_account_number )	
	END IF	

	Set rs=Nothing
	Set rs3=Nothing

END SUB
%>

<%
SUB CHECK_INVOICE_STATUS_HAWB( tvHBOL, t_elt_account_number )
DIM invoiceNUM(100),ivIndex

		ivIndex = 0				
		SQL="select * from invoice where elt_account_number=" & t_elt_account_number & " and hawb_num=N'" & tvHBOL & "'"

		rs3.Open SQL, eltConn, , , adCmdText
		Do While Not rs3.EOF
			invoiceNUM(ivIndex) = rs3("invoice_no")
			ivIndex = ivIndex + 1										
			rs3.MoveNext
		Loop
		rs3.Close

		if ivIndex = 0	then
			SQL= "select * from invoice_hawb where elt_account_number = " & elt_account_number & " and hawb_num=N'" & tvHBOL & "'"
			rs3.Open SQL, eltConn, , , adCmdText
			Do While Not rs3.EOF
				invoiceNUM(ivIndex) = rs3("invoice_no")
				ivIndex = ivIndex + 1										
				rs3.MoveNext
			Loop
			rs3.Close

			if ivIndex = 0	then
				SQL="select * from invoice_queue where elt_account_number=" & t_elt_account_number & " and hawb_num=N'" & tvHBOL & "'" & " and invoiced = 'Y' "
				rs3.Open SQL, eltConn, , , adCmdText
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
%>

<body link="336699" vlink="336699" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<br>
      <form method="post" name="frmHAWB">
		<input type="hidden" name="hHBOLPrefix" value="<%= vHBOLPrefix %>">
	 	<input type="hidden" name="hNewHAWB" value="<%= NewHAWB %>">
	 	<input type="hidden" name="hHBOL" value="<%= vHBOL %>">
	 	<input type="hidden" name="herrHAWB" value="<%= errHAWB %>">
		<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="bodycopy">
                <tr>
                  <td class="formbody"><div align="center">Next House B/L No. : </div></td>
                </tr>
                <tr>
                  <td class="formbody">				  </td>
                </tr>
                <tr>
                  <td height="22" align="center">&nbsp;<font color="c16b42"><strong>House B/L No</strong></font>.&nbsp;&nbsp;
                    <select name="lstHBOLPrefix" size="1" class="smallselect" style="WIDTH: 60px" onChange="PrefixChange()">
                      <% For i=0 To pIndex-1 %>
                      <option value="<%= aNextHBOL(i) %>" <% if vHBOLPrefix=aHBOLPrefix(i) then response.write("selected") %>><%= aHBOLPrefix(i) %></option>
                      <%  Next  %>
                    </select>
				  <%if HAWB_Exists then%> 
					 <input name="txtHAWB" class="shorttextfieldbold" style="WIDTH: 100px; color:#FF0000" tabindex=1 value="<%= vHBOL %>" size="20">
				  <%else%>
                    <input name="txtHAWB" class="shorttextfieldbold" style="WIDTH: 100px" tabindex=1 value="<%= vHBOL %>" size="20">
				  <%end if%>				  </td>				
                </tr>
                <% If IsCopied = "yes" Then %>
                <tr>
                    <td class="formbody" align="center">
                        <select id="lstSaveAsNewType" class="smallselect">
                            <option value="copyAll" selected>Copy All</option>
                            <option value="RemoveMasterhouse">Remove Masterhouse</option>
                        </select>
                    </td>
                </tr>
                <% End If %>
            
				  <%if HAWB_Exists then%> 
                <tr>
                  <td height="18" align="center">
					  <P align="center"><span class="style3">House B/L No.: <%=vHBOL%> already exists!</span></P>
				  </td>
                </tr>
                <tr>
                  <td height="18" align="center">
					  <P align="center"><span class="style3">Please choose another number! </span></P>
				  </td>
                </tr>
			      <%end if%>
				
        </table>	

      <P align="center"><input name="OK" type="button" id="OK" value="OK" onClick="OkClick()"  style="width:70px">
        <input name="Cancel" type="button" id="Cancel" value="Cancel" onClick="CancelClick()" style="width:70px">
      </P>
		
</form>
</body>
<script language="vbscript">

Sub OkClick

<% If IsCopied = "yes" Then %>
window.parent.stripeMaster(document.getElementById("lstSaveAsNewType").value)
<% End If %>
already_e = "<%= HAWB_Exists %>"
errHAWB = "<%= errHAWB %>"
vHBOL = document.frmHAWB.txtHAWB.value

DIM tmpHBOL
tmpHBOL = vHBOL
pos=instr(vHBOL,"-")
if pos>0 then
	tmpHBOL=Mid(vHBOL,pos+1,20)
end if

if Not tmpHBOL="" and Not IsNumeric(tmpHBOL) then
	MsgBox "Please enter HBOL# in Prefix-Number format!"
	exit sub
end if

if already_e = "True" then
 if errHAWB = vHBOL then
// 	msgbox "Please use another HAWB No."
	exit sub
 end if
end if

sindex=document.frmHAWB.lstHBOLPrefix.selectedindex
HAWBPrefix= document.frmHAWB.lstHBOLPrefix.item(sindex).Text
NEXTPrefix= document.frmHAWB.lstHBOLPrefix.item(sindex).value
			document.frmHAWB.action="new_edit_hbol_ok.asp?save=yes&prefix=" _
			    & encodeURIComponent(HAWBPrefix) & "&HBOL=" & encodeURIComponent(vHBOL) & "&NEXTPREFIX=" & encodeURIComponent(NEXTPrefix)
			document.frmHAWB.method="POST"
			document.frmHAWB.target="_self"
			frmHAWB.submit()
End Sub

Sub CancelClick
			document.frmHAWB.action="new_edit_hbol_ok.asp?cancel=yes"
			document.frmHAWB.method="POST"
			document.frmHAWB.target="_self"
			frmHAWB.submit()
End Sub

Sub PrefixChange()

sindex=document.frmHAWB.lstHBOLPrefix.selectedindex
HAWBPrefix=document.frmHAWB.lstHBOLPrefix.item(sindex).Text
NEXTPrefix= document.frmHAWB.lstHBOLPrefix.item(sindex).value

vHBOL = ""
			document.frmHAWB.action="new_edit_hbol_ok.asp?SaveAsNew=yes&prefix=" _
			    & encodeURIComponent(HAWBPrefix) & "&HBOL=" & encodeURIComponent(vHBOL) & "&NEXTPREFIX=" & encodeURIComponent(NEXTPrefix)
			document.frmHAWB.method="POST"
			document.frmHAWB.target="_self"
			frmHAWB.submit()
End Sub

</script>


</html>