<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% Option Explicit %>
<%
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>

<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/Header.asp" -->
 <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
<!--  #include file="../include/recent_file.asp" -->
<!--  #include file="../include/GOOFY_util_fun.inc" -->
<%
Dim rs,SQL
Set rs = Server.CreateObject("ADODB.Recordset")

Dim vHBOL,vMBOL,vBookingNum,vAgentName,vAgentInfo,vAgentAcct,rAgentInfo
Dim vShipperName,vShipperInfo,vShipperAcct
Dim vConsigneeName,vConsigneeInfo,vConsigneeAcct,vNotifyInfo
Dim vExportRef,vOriginCountry,vExportInstr,vLandingPier,vMoveType
Dim vConYes,vPreCarriage,vPreReceiptPlace
Dim vExportCarrier,vLandingPort,vUnloadingPort,vDepartureDate
Dim vDeliveryPlace,vDesc1,vDesc2,vDesc3,vPieces,vWeightCP,vGrossWeight
Dim vMeasurement
Dim vWidth,vLength,vHeight,vChargeableWeight,vChargeRate
Dim vTotalWeightCharge
Dim vShowPrepaidWeightCharge,vShowCollectWeightCharge
Dim vShowPrepaidOtherCharge,vShowCollectOtherCharge
Dim vOtherChargeCP,vChargeItem,vChargeAmt,vVendor,vCost
Dim vDeclaredValue,vBy,vDate,vPlace
Dim aChargeCP(10),aChargeItem(10),aChargeAmt(10),aChargeVendor(10),aChargeCost(10)
Dim aChargeNo(10),aChargeItemName(10)
Dim vTotalPrepaid,vTotalCollect
Dim Save,Add,Edit,Delete,vLoadingPier,vLoadingPort
Dim vScale,vGrossWeight1,vLb1,vMeasurement1,vCF1,string1,string2,string3,string4
Dim vDesc6,vDesc5,vManifestDesc,vDemDetail,tIndex,vPrintPort
Dim i

Save=Request.QueryString("Save")
Add=Request.QueryString("Add")
Edit=Request.QueryString("Edit")
Delete=Request.QueryString("Delete")
vHBOL=Request.QueryString("HBOL")
'// vCOLO=Request.QueryString("COLO")

if Not vHBOL="" then
	SQL= "select * from hbol_master where elt_account_number = " & elt_account_number & " and hbol_num=N'" & vHBOL & "'"
	rs.Open SQL, eltConn, , , adCmdText
	vConYes="Y"
	vDate=Now
	vTotalPrepaid=0
	vTotalCollect=0
	if Not rs.EOF then
		vBookingNum=rs("booking_num")
		vMBOL=rs("mbol_num")
		vShipperName=rs("shipper_name")
		vShipperInfo=rs("shipper_info")
		vShipperAcct=FormatNumberPlus(checkblank(rs("shipper_acct_num"),0),0)
		vConsigneeName=rs("consignee_name")
		vConsigneeInfo=rs("consignee_info")
		vConsigneeAcct=FormatNumberPlus(checkblank(rs("consignee_acct_num"),0),0)
		vNotifyInfo=rs("notify_info")
		vExportRef=rs("export_ref")
		vAgentInfo=rs("forward_agent_info")
		rAgentInfo=rs("agent_info")
		vOriginCountry=rs("origin_country")
		vExportInstr=rs("export_instr")
		vLoadingPier=rs("loading_pier")
		vMoveType=rs("move_type")
		vConYes=rs("containerized")
		vPreCarriage=rs("pre_carriage")
		vPreReceiptPlace=rs("pre_receipt_place")
		vExportCarrier=rs("export_carrier")
		vLoadingPort=rs("loading_port")
		vUnloadingPort=rs("unloading_port")
		vDeliveryPlace=rs("delivery_place")
		vDepartureDate=rs("departure_date")
		vWeightCP=rs("weight_cp")
		vPieces=rs("pieces")
		vScale=rs("scale")
        if IsNull(vScale) or vScale="K" or vScale="" then
            vGrossWeight1=FormatNumberPlus(checkblank(rs("gross_weight"),0),2)
            vLb1=Round(vGrossWeight1*2.204,2)
            vMeasurement1=FormatNumberPlus(checkblank(rs("measurement"),0),2)
            vCF1=Round(vMeasurement1*35.31,2)
        else
            vLb1=FormatNumberPlus(checkblank(rs("gross_weight"),0),2)
            vGrossWeight1=Round(vLb1*0.454,2)
            vCF1=FormatNumberPlus(checkblank(rs("measurement"),0),2)
            vMeasurement1=Round(vCF1/35.31,2)
        end if
			
        string1 = FormatNumber(vGrossWeight1,2,,0) & " KG"
        string2 = FormatNumber(vMeasurement1,2,,0) & " CBM"
        string3 = FormatNumber(vLb1,2,,0) & " LB"
        string4 = FormatNumber(vCF1,2,,0) & " CFT"

        string1 = space(12 - len(string1)) & trim(string1)
        string2 = space(12 - len(string2)) & trim(string2)
        string3 = space(12 - len(string3)) & trim(string3)
        string4 = space(12 - len(string4)) & trim(string4)
        		
        vDesc6 = string1 & " " & string2 & chr(13)
        vDesc6 = vDesc6 & string3 & " " &  string4
			
		vTotalWeightCharge=FormatNumberPlus(checkblank(rs("total_weight_charge"),0),2)
		vDesc1=rs("desc1")
		vDesc2=rs("desc2")
		vDesc3=rs("desc3")
		vDesc5=rs("desc5")
		vManifestDesc=rs("manifest_desc")
		vDemDetail=rs("dem_detail")		
		vShowPrepaidWeightCharge=rs("show_prepaid_weight_charge")
		vShowCollectWeightCharge=rs("show_collect_weight_charge")

		vShowPrepaidOtherCharge=rs("show_prepaid_other_charge")
		vShowCollectOtherCharge=rs("show_collect_other_charge")
		vDeclaredValue=rs("declared_value")
		vDate=rs("tran_date")
		vBy=rs("tran_by")
		vPlace=rs("tran_place")
	end if
	rs.Close
	SQL= "select * from hbol_other_charge where elt_account_number = " & elt_account_number & " and hbol_num=N'" & vHBOL & "' order by tran_no"
	rs.Open SQL, eltConn, , , adCmdText
	tIndex=0
	Do while Not rs.EOF
		aChargeNo(tIndex)=rs("tran_no")
		aChargeCP(tIndex)=rs("coll_prepaid")
		aChargeItem(tIndex)=rs("charge_code")
		aChargeItemName(tIndex)=rs("charge_desc")
		aChargeAmt(tIndex)=FormatNumberPlus(checkblank(rs("charge_amt"),0),2)
'//     aChargeVendor(tIndex)=FormatNumberPlus(checkblank(rs("vendor_num"),0),0)
'//     aChargeCost(tIndex)=rs("cost_amt")
		if aChargeCP(tIndex)="P" then
			if vShowPrepaidOtherCharge="Y" then
				vTotalPrepaid=vTotalPrepaid+aChargeAmt(tIndex)
			else
				aChargeAmt(tIndex)=""
				aChargeItemName(tIndex)=""
			end if
		else
			if vShowCollectOtherCharge="Y" then
				vTotalCollect=vTotalCollect+aChargeAmt(tIndex)
			else
				aChargeAmt(tIndex)=""
				aChargeItemName(tIndex)=""
			end if
		end if
		rs.MoveNext
		tIndex=tIndex+1
	Loop
	rs.Close
	if vWeightCP="P" then
		if vShowPrepaidWeightCharge="Y" then
			vTotalPrepaid=vTotalPrepaid+vTotalWeightCharge
		else
			vTotalWeightCharge=""
		end if
	else
		if vShowCollectWeightCharge="Y" then
			vTotalCollect=vTotalCollect+vTotalWeightCharge
		else
			vTotalWeightCharge=""
		end if
	end if
	if vTotalPrepaid=0 then vTotalPrepaid=""
	if vTotalCollect=0 then vTotalCollect=""
end if
Set rs=Nothing
vPrintPort=bolPort
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Untitled Document</title>

<link href="../css/dotmatrix_bol.css" rel="stylesheet" type="text/css" />
<style type="text/css">
<!--
#position {
	margin: 0px;
	padding: 0px;
	top: -90px;
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
	var pLeft = 0.1;
	var pRight = 0.1;
	var pTop = 0.1;
	var pBottom = 0.1;
	var pHeader = "";
	var pFooter = "";
	var pPrintBG = false;
	var pLandscape = false;
	var pPaper = "Letter";
	FreightEasy.ELT_PRINT_ALL_SET( pLeft, pRight, pTop, pBottom, pHeader, pFooter, pPrintBG, pLandscape, pPaper );
}

function printWindow() {
	
	var pageDiv = document.getElementById("PageDiv");
	
	pageDiv.style.posTop = -32;
	
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
		else
		{
			confirm("This version Browser may not be supported for this operation!\nDo you still want to print this document?");
			FreightEasy.ELT_PREVIEW();
		}
	}catch(error)
	{
		alert(error.description);
	}
	pageDiv.style.posTop = 0;
}

function resetDefault() {
    FreightEasy.SET_DEFAULT_PRINTER(defaultPrinter);
}

</script>

<style type="text/css">

<% For i=0 To 9 %>
    #txtOtherCharge<%=i %> {
	    position:absolute;
	    width:247px;
	    height:14px;
	    z-index:3;
	    left: 23px;
	    top: <%=799+(i*17) %>px;
    }
    #txtPrepaid<%=i %> {
	    position:absolute;
	    width:71px;
	    height:14px;
	    z-index:3;
	    left: 273px;
	    top: <%=799+(i*17) %>px;
    }
    #txtCollect<%=i %> {
	    position:absolute;
	    width:68px;
	    height:14px;
	    z-index:3;
	    left: 344px;
	    top: <%=799+(i*17) %>px;
    }
<% Next %>

</style>

</head>

<BODY onLoad="setDefault();" onUnload="resetDefault();">
<div id="PageDiv">
<div id="background"></div>
<div id="txtShipperInfo">
    <textarea name="txtShipperInfo" wrap="hard" cols="48" rows="4" style="height:70px;" class="monotextarea" readonly="readonly"><%=vShipperInfo %></textarea>
</div>
<div id="txtBookingNum"><%=vBookingNum %></div>
<div id="txtHBOL"><%=vHBOL %></div>
<div id="txtExportRef">
    <textarea name="txtExportRef" wrap="hard" cols="45" rows="3" style="height:42px;" class="monotextarea" readonly="readonly"><%=vExportRef %></textarea>
</div>
<div id="txtConsigneeInfo">
    <textarea name="txtConsigneeInfo" wrap="hard" cols="48" rows="4" style="height:42px;" class="monotextarea" readonly="readonly"><%=vConsigneeInfo %></textarea>
</div>
<div id="txtAgentInfo">
    <textarea name="txtAgentInfo" wrap="hard" cols="45" rows="3" style="height:42px;" class="monotextarea" readonly="readonly"><%=vAgentInfo %></textarea>
</div>
<div id="txtOriginCountry"><%=vOriginCountry %></div>
<div id="txtNotifyInfo">
    <textarea name="txtNotifyInfo" wrap="hard" cols="48" rows="4" style="height:42px;" class="monotextarea" readonly="readonly"><%=vNotifyInfo %></textarea>
</div>
<div id="txtExportInstr">
    <textarea name="txtExportInstr" wrap="hard" cols="45" rows="6" style="height:42px;" class="monotextarea" readonly="readonly"><%=vExportInstr %></textarea>
</div>

<div id="txtPreCarriage"><%=vPreCarriage %></div>
<div id="txtPreReceiptPlace"><%=vPreReceiptPlace %></div>
<div id="txtExportCarrier"><%=vExportCarrier %></div>
<div id="txtLoadingPort"><%=vLoadingPort %></div>

<div id="txtLoadingPier"><%=vLoadingPier %></div>
<div id="txtUnloadingPort"><%=vUnloadingPort %></div>
<div id="txtDeliveryPlace"><%=vDeliveryPlace %></div>
<div id="txtMoveType"><%=vMoveType %></div>
<div id="txtConYes">X</div>
<div id="txtConNo">X</div>
<div id="txtDesc1"><%=vDesc1 %></div>
<div id="txtDesc5"><%=vDesc5 %></div>
<div id="txtDesc3"><%=vDesc3 %></div>
<div id="txtDesc6"><%=vDesc6 %></div>
<div id="txtDesc2"><%=vDesc2 %></div>
<div id="txtManifestDesc"><%=vManifestDesc %></div>


<div id="txtOtherCharge0"><%If checkBlank(vTotalWeightCharge,"0") <> "0" Then Response.Write("OCEAN FREIGHT") %></div>
<div id="txtPrepaid0"><% if vWeightCP="P" then response.write(FormatAmount(vTotalWeightCharge)) %></div>
<div id="txtCollect0"><% if vWeightCP="C" then response.write(FormatAmount(vTotalWeightCharge)) %></div>

<% For i=1 To 9 %>
<div id="txtOtherCharge<%=i %>"><%=aChargeItemName(i-1) %></div>
<div id="txtPrepaid<%=i %>"><% if aChargeCP(i-1)="P" then response.write(FormatAmount(aChargeAmt(i-1))) %></div>
<div id="txtCollect<%=i %>"><% if aChargeCP(i-1)="C" then response.write(FormatAmount(aChargeAmt(i-1))) %></div>
<% Next %>
<div id="txtTotalPrepaid"><%=FormatAmount(vTotalPrepaid) %></div>
<div id="txtTotalCollect"><%=FormatAmount(vTotalCollect) %></div>
<div id="txtPlace"><%=vPlace %></div>
<div id="txtBy"><%=vBy %></div>
<div id="T15"><%=vHBOL %></div>
<div id="txtDate"><%=vDate %></div>
</div>

</body>
</html>