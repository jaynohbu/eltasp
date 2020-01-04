<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>AES FORM</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <!--  #INCLUDE FILE="../include/connection.asp" -->
    <!-- /Start of Combobox/ -->

    <script type="text/javascript">
<!-- 

// var ComboBoxes =  new Array('list1','list2','list3',.....);

var ComboBoxes =  new Array('lstShipper','lstConsignee');
// -->
    </script>

    <script type="text/jscript" src='../Include/iMoonCombo.js'></script>

    <!-- /End of Combobox/ -->
    <style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
-->
</style>
    <object id="EltClient" classid="CLSID:B38256C8-D8AE-42FF-8B14-B6FAB132E440" codebase="../include/ELTAuth.CAB#version=2,2,0,0">
        <param name="copyright" value="http://www.freighteasy.net" />
    </object>
</head>
<!--  #INCLUDE FILE="../include/header.asp" -->
<!--  #include file="../include/GOOFY_util_fun.inc" -->
<!--  #include file="../include/GOOFY_Util_Ver_2.inc" -->
<!--  #include file="../include/recent_file.asp" -->
<%
Dim rs, SQL
Set rs = Server.CreateObject("ADODB.Recordset")

Dim vShipperInfo,vShipperTaxID,vZipCode,vRelated
Dim vExportDate,vTranRefNo,vUltiConsignee,vInterConsignee,vForwardAgent
Dim vOriginState,vDestCountry,vLoadingPier,vMOT
Dim vExportCarrier,vExportPort,vUnloadingPort,vConYes
Dim vCarrierIDCode,vShipmentRefNo,vEntryNo,vHazYes
Dim vIBT,vRouteYes
Dim vLicenseNo,vECCN
Dim vTitle,vTranDate,vPhone,vEmail
Dim Save,EditSED,vHAWB,AddItem,DeleteItem
Dim aDFM(10),aBNumber(10),aBQty1(10),aUnit1(10),aBQty2(10),aUnit2(10),aGrossWeight(10),aVIN(10),aValue(10),aExportCode(10),aLicenseType(10)
Dim aBNumberSED(10),aSBDesc(10),aVFlag(10)
DIM tmpShipperAcct,returnURL,vSEDNo

tmpShipperAcct=Request.QueryString("ShipperAcct")
EditSED=Request.QueryString("EditSED")
Save=Request.QueryString("save")
vHAWB=Request.QueryString("HAWB")
tMAWB=checkBlank(Request.QueryString("tMAWB"),"")
vSEDNo = checkBlank(Request.QueryString("SEDNO"),"")
AddItem=Request.QueryString("AddItem")
DeleteItem=Request.QueryString("DeleteItem")
DeleteSED=Request.QueryString("DeleteSED")


eltConn.BeginTrans

If DeleteSED="yes" Then
	SQL= "delete from sed_master where elt_account_number = " & elt_account_number & " and auto_uid=" & Request.Form("hSEDNo")
	eltConn.Execute SQL
	SQL= "delete from sed_detail where elt_account_number = " & elt_account_number & " and sed_id=" & Request.Form("hSEDNo")
	eltConn.Execute SQL
end if
if Not (save="yes" or AddItem="yes" or deleteItem="yes" or DeleteSED="yes") then
	EditSED="yes"
end if

if EditSED="yes" and (Not vHAWB="" or Not tMAWB="" or vSEDNo <> "") and tmpShipperAcct = "" then

	If vHAWB <> "" Then
	    SQL= "select * from sed_master where elt_account_number=" & elt_account_number _
	        & " and HAWB_NUM=N'" & vHAWB & "'"
	Elseif tMAWB <> "" Then
		SQL= "select * from sed_master where elt_account_number=" & elt_account_number _
		    & " and  MAWB_NUM=N'" & tMAWB & "' AND ISNULL(HAWB_NUM,'')=''"
	Elseif vSEDNo <> "" Then
	    SQL= "select * from sed_master where elt_account_number=" & elt_account_number _
		    & " and  auto_uid=" & vSEDNo
    Else
	End If 
    
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	if Not rs.EOF then
	    vSEDNo = rs("auto_uid")
		vMAWB=rs("mawb_num")
		vHAWB=rs("hawb_num")
		vShipperInfo=rs("USPPI")
		vContactLastName=rs("usppi_contact_lastname")
		vContactFirstName=rs("usppi_contact_firstname")
		vShipperAcct=rs("shipper_acct")
		if IsNull(vShipperAcct) then
			vShipperAcct=0
		end if
		vRelated=rs("party_to_transaction")
		vConsigneeAcct=rs("consignee_acct")
		if IsNull(vConsigneeAcct) then
			vConsigneeAcct=0
		end if
		vConsigneeCountryCode=rs("consignee_country_code")
		vUltiConsignee=rs("ulti_consignee")
		vInterConsignee=rs("inter_consignee")
		vShipperTaxID=Replace(rs("USPPI_taxid"),"-","")
		vZipCode=rs("zip_code")
		vExportDate=rs("export_date")
		vTranRefNo=rs("tran_ref_no")
		vForwardAgent=rs("forward_agent")
		vLoadingPier=rs("loading_pier")
		vMOT=rs("tran_method")
		if vMOT="" then vMOT=40
		vExportCarrier=rs("export_carrier")
		vExportPort=rs("export_port")
		vUnloadingPort=rs("unloading_port")
		vConYes=rs("containerized")
		vOriginState=rs("origin_state")
		vDestCountry=rs("dest_country")
		vCarrierIDCode=rs("carrier_id_code")
		vShipmentRefNo=Replace(rs("shipment_ref_no")," ","")
		vEntryNo=rs("entry_no")
		vHazYes=rs("hazardous_materials")
		vIBT=rs("in_bond_code")
		vRouteYes=rs("route_export_tran")
		vLicenseNo=rs("license_no")
		vECCN=rs("ECCN")
		vDuly=rs("duly")
		vTitle=rs("Title")
		vPhone=rs("Phone")
		vEmail=rs("Email")
		vTranDate=rs("Tran_Date")
		rs.Close
		
		SQL = "select * from sed_detail where elt_account_number=" & elt_account_number & " and sed_id=" & vSEDNo
        		
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing
		tIndex=0
		Do While Not rs.EOF
			aDFM(tIndex)=rs("dfm")
			aBNumber(tIndex)=rs("b_number")
			aSBDesc(tIndex)=rs("item_desc")
			aBQty1(tIndex)=rs("b_qty1")
			aUnit1(tIndex)=rs("unit1")
			aBQty2(tIndex)=rs("b_qty2")
			aUnit2(tIndex)=rs("unit2")
			if aBQty1(tIndex)="" then aBQty1(tIndex)=0
			if aBQty2(tIndex)="" then aBQty2(tIndex)=0
			aGrossWeight(tIndex)=rs("gross_weight")
			if aGrossWeight(tIndex)="" then aGrossWeight(tIndex)=0		
			if isnull(aGrossWeight(tIndex)) then aGrossWeight(tIndex) = 0
			aGrossWeight(tIndex)=cLng(aGrossWeight(tIndex))
			aVIN(tIndex)=rs("VIN")
			if not aVIN(tIndex)="" then 
				aVFlag(tIndex)="Y"
			else
				aVFlag(tIndex)="N"
			end if
			aValue(tIndex)=rs("item_Value")		
			if isnull(aValue(tIndex)) then aValue(tIndex) = 0
			if aValue(tIndex)="" then aValue(tIndex)=0
			aValue(tIndex)=cLng(aValue(tIndex))
			aExportCode(tIndex)=rs("export_code")
			aLicenseType(tIndex)=rs("license_type")
			tIndex=tIndex+1
			rs.MoveNext
		Loop
		rs.Close
	else
		rs.close
		vRelated="N"
		vHazYes="N"
		vRouteYes="N"
		
		SQL= "select a.MAWB_NUM,a.shipper_account_number,a.shipper_info,a.export_date,a.consignee_acct_num,a.Consignee_Info,a.flight_date_1,a.departure_airport,a.dest_airport,a.departure_state,a.dest_country,a.total_pieces,a.weight_scale,a.total_gross_weight,a.declared_value_customs,b.business_fed_taxid,b.business_zip,b.business_country,b.owner_lname,b.owner_fname from HAWB_master a,organization b "
		SQL=SQL & " where a.elt_account_number=b.elt_account_number "
		SQL=SQL & " and a.elt_account_number=" & elt_account_number 
		SQL=SQL & " and a.HAWB_num=N'" & vHAWB & "'"
		SQL=SQL & " and a.shipper_account_number=b.org_account_number "
		
		if tMAWB <> "" then 
			SQL= "select a.mawb_num,"
			SQL=SQL & "a.shipper_account_number,"
			SQL=SQL & "a.shipper_info,"
			SQL=SQL & "a.consignee_acct_num,"
			SQL=SQL & "a.Consignee_Info,"
			SQL=SQL & "a.flight_date_1,"
			SQL=SQL & "a.departure_airport,"
			SQL=SQL & "a.dest_airport,"
			SQL=SQL & "a.dest_country,"
			SQL=SQL & "a.total_pieces,"
			SQL=SQL & "a.weight_scale,"
			SQL=SQL & "a.total_gross_weight,"
			SQL=SQL & "a.declared_value_customs,"
			SQL=SQL & "b.business_fed_taxid,"
			SQL=SQL & "b.business_zip,"
			SQL=SQL & "b.business_country,"
			SQL=SQL & "b.owner_lname,"
			SQL=SQL & "b.owner_fname,"
			SQL=SQL & "c.ETD_DATE1 as export_date,"
			SQL=SQL & "c.Origin_Port_State as departure_state"
			SQL=SQL & " from mawb_master a,"
			SQL=SQL & " organization b,"
			SQL=SQL & " mawb_number c"
			SQL=SQL & " where a.elt_account_number=b.elt_account_number"
			SQL=SQL & " and b.elt_account_number=c.elt_account_number"
			SQL=SQL & " and a.elt_account_number=" & elt_account_number 
			SQL=SQL & " and a.mawb_num=c.mawb_no"
			SQL=SQL & " and a.mawb_num=N'"& tMAWB & "'"
			SQL=SQL & " and a.shipper_account_number=b.org_account_number" 
		end if  

		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing
		if not rs.EOF then
			vMAWB=rs("mawb_num")
			vShipmentRefNo = Replace(checkBlank(vHAWB,vMAWB)," ","")
			vShipperAcct=rs("shipper_account_number")
			vShipperInfo=rs("shipper_info")
			vContactLastNmae=rs("owner_lname")
			vContactFirstName=rs("owner_fname")
			vConsigneeAcct=rs("consignee_acct_num")
			vUltiConsignee=rs("Consignee_Info")
			pos=0
			pos=instr(vUltiConsignee,"Notify")
			if pos>0 then
				vUltiConsignee=Mid(vUltiConsignee,1,pos-1)
			end if
			vShipperTaxID=Replace(rs("business_fed_taxid"),"-","")
			vZipCode=rs("business_zip")
			vExportDate=rs("export_date")
			vCarrierIDCode=Mid(rs("flight_date_1"),1,2)
			vExportPort=rs("departure_airport")
			vUnloadingPort=rs("dest_airport")
			vOriginState=rs("departure_state")
			vDestCountry=rs("dest_country")
			aBQty1(0)=rs("total_pieces")
			aGrossWeight(0)=cdbl(rs("total_gross_weight"))
			vScale=rs("weight_scale")
			if vScale="L" then aGrossWeight(0)=aGrossWeight(0)*0.454
			aGrossWeight(0)=cLng(aGrossWeight(0))
			aValue(0)=rs("declared_value_customs")
			if Not IsNumeric(aValue(0)) then aValue(0)=0
			aValue(0)=cLng(aValue(0))
		end if
		rs.Close
		if Not vMAWB="" then
			SQL="select flight#1 from mawb_number where elt_account_number=" & elt_account_number & " and mawb_no=N'" & vMAWB & "'"
			
			rs.CursorLocation = adUseClient
			rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
			Set rs.activeConnection = Nothing
			if not rs.EOF then
				vExportCarrier=rs("flight#1")
			end if
			rs.close
		end if
		vMOT=40
		vLicenseNo="NLR"
		vTranDate=Date
		tIndex=1

		UserID=user_id
		SQL= "select user_lname,user_fname,user_title,user_phone,user_email from users where elt_account_number = " & elt_account_number & " and userid=" & UserID
		
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing
		if Not rs.EOF then
			LastName=rs("user_lname")
			FirstName=rs("user_fname")
			vDuly=LastName & ", " & FirstName
			vTitle=rs("user_title")
			if vTitle="" then vTitle="Export Manager"
			vPhone=rs("user_phone")
			vEmail=rs("user_email")
		end if
		rs.Close
	end if
	
elseif Save="yes" Or AddItem="yes" Or DeleteItem="yes" Or ( Not tmpShipperAcct="" ) then
	vSEDNo = Request("hSEDNo")
	vMAWB=Request("hMAWB")
	vShipperAcct=checkBlank(Request("hShipperAcct"),0)
	vShipperInfo=request("txtUSPPI")
	vShipperName=Request("lstShipper:Text")
	vContactLastName=request("hContactLastName")
	vContactFirstName=request("hContactFirstName")
	vShipperTaxID=request("txtTaxID")		
	vRelated=Request("cRelated")
	if vRelated="" then vRelated="N"
	vConsigneeAcct=Request("hConsigneeAcct")
	vConsigneeCountryCode=Request("hConsigneeCountryCode")
	vUltiConsignee=request("txtUltiConsignee")
	vInterConsignee=Request("txtInterConsignee")
	vExportDate=request("txtExportDate")
	vTranRefNo=request("txtTranRefNo")
	vForwardAgent=request("txtForwardAgent")
	vOriginState=Request("txtOriginState")
	vDestCountry=Request("txtDestCountry")
	vLoadingPier=Request("txtLoadingPier")
	vMOT=request("lstMOT")
	vExportCarrier=request("txtExportCarrier")
	vVN=Request("hVesselName")
	vExportPort=request("txtExportPort")
	vUnloadingPort=request("txtUnloadingPort")
	vConYes=Request("cConYes")
	vCarrierIDCode=Request("txtCarrierIDCode")
	vShipmentRefNo=Request("txtShipmentRefNo")
	vEntryNo=Request("txtEntryNo")
	vHazYes=Request("cHazYes")
	if vHazYes="" then vHazYes="N"
	vIBT=Request("lstIBT")
	vRouteYes=Request("cRouteYes")
	if vRouteYes="" then vRouteYes="N"
	vLicenseNo=request("txtLicenseNo")
	vECCN=Request("txtECCN")
	vDuly=Request("txtDuly")
	vTitle=Request("txtTitle")
	vPhone=Request("txtPhone")
	vEmail=Request("txtEmail")
	vTranDate=Request("txtTranDate")
	NoItem=Request("hNoItem")
	if NoItem="" then
		NoItem=0
	else
		NoItem=CInt(NoItem)
	end if
	
	vHAWB = checkBlank(vHAWB,"")
	
	for i=0 to NoItem
		aDFM(i)=Request("lstDFM" & i)
		SBinfo=Request("lstBNumber" & i)
		
		if NOT Trim(SBinfo) = "Select One" then		
			pos=0
			pos=instr(SBinfo,"^")
			if pos>0 then
				aBNumber(i)=Mid(SBinfo,1,pos-1)
				SBinfo=Mid(SBinfo,pos+1,55)
			end if
			pos=instr(SBinfo,"^")
			if pos>0 then
				aSBDesc(i)=Mid(SBinfo,1,pos-1)
			end if
			aBQty1(i)=Request("txtBQty1" & i)
			if aBQty1(i)="" then aBQty1(i)=0
			aUnit1(i)=Request("txtUnitOne" & i)
			aBQty2(i)=Request("txtBQty2" & i)
			if aBQty2(i)="" then aBQty2(i)=0
			aUnit2(i)=Request("txtUnitTwo" & i)
			aGrossWeight(i)=Request("txtGrossWeight" & i)
			if aGrossWeight(i)="" then aGrossWeight(i)=0
			aGrossWeight(i)=cLng(aGrossWeight(i))
			aVIN(i)=Request("txtVIN" & i)
			if Not aVIN(i)="" then
				aVFlag(i)="Y"
			else
				aVFlag(i)="N"
			end if
			aValue(i)=Request("txtValue" & i)
			if aValue(i)="" then aValue(i)=0
			aValue(i)=cLng(aValue(i))
			aExportCode(i)=Request("txtExportCode" & i)
			aLicenseType(i)=Request("txtLicenseType" & i)		
		end if	
	next
	if DeleteItem="yes" then
		ItemNo=Request.QueryString("ItemNo")-1
		for i=ItemNo to NoItem-1
			aDFM(i)=aDFM(i+1)
			aBNumber(i)=aBNumber(i+1)
			aSBDesc(i)=aSBDesc(i+1)
			aBQty1(i)=aBQty1(i+1)
			aUnit1(i)=aUnit1(i+1)
			aBQty2(i)=aBQty2(i+1)
			aUnit2(i)=aUnit2(i+1)
			aGrossWeight(i)=aGrossWeight(i+1)
			aVIN(i)=aVIN(i+1)
			aValue(i)=aValue(i+1)
			aExportCode(i)=aExportCode(i+1)
			aLicenseType(i)=aLicenseType(i+1)
		next
		NoItem=NoItem-1
	end if
	tIndex=NoItem
	if Save="yes" then
		If vSEDNo <> "" Then
		    SQL = "select * from sed_master where elt_account_number = " _
		        & elt_account_number & " and auto_uid=" & vSEDNo
        Else
            SQL = "select * from sed_master where elt_account_number = " _
                & elt_account_number & " and hawb_num=N'" & vHAWB & "' and mawb_num=N'" & vMAWB & "'"
        End If
		
		rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
		
		If rs.EOF Then
			rs.AddNew
			rs("elt_account_number") = elt_account_number
			rs("HAWB_num") = vHAWB
			rs("tran_date") = Now
		End If
		rs("mawb_num")=vMAWB
		rs("USPPI")=vShipperInfo
		rs("shipper_acct")=vShipperAcct
		rs("USPPI_taxid")=vShipperTaxID
		rs("usppi_contact_lastname")=vContactLastName
		rs("usppi_contact_firstname")=vContactFirstName
		rs("party_to_transaction")=vRelated
		rs("zip_code")=vZipCode
		rs("export_date")=vExportDate
		rs("tran_ref_no")=vTranRefNo
		rs("consignee_acct")=vConsigneeAcct
		rs("consignee_country_code")=vConsigneeCountryCode
		rs("ulti_consignee")=vUltiConsignee
		rs("inter_consignee")=vInterConsignee
		rs("forward_agent")=vForwardAgent
		rs("Origin_State")=vOriginState
		rs("dest_country")=vDestCountry
		rs("loading_pier")=vLoadingPier
		rs("tran_method")=vMOT
		rs("export_carrier")=vExportCarrier
		rs("export_port")=vExportPort
		rs("unloading_port")=vUnloadingPort
		rs("containerized")=vConYes
		rs("carrier_id_code")=vCarrierIDCode
		rs("shipment_ref_no")=vShipmentRefNo
		rs("entry_no")=vEntryNo
		rs("hazardous_materials")=vHazYes
		rs("in_bond_code")=vIBT
		rs("route_export_tran")=vRouteYes
		rs("license_no")=vLicenseNo
		rs("ECCN")=vECCN
		rs("duly")=vDuly
		rs("last_modified")=Now
		rs("title")=vTitle
		rs("phone")=vPhone
		rs("email")=vEmail
		rs("tran_date")=vTranDate
		rs.Update
		rs.Close
		
		vSEDNo = GetSQLResult("SELECT IDENT_CURRENT('sed_master')", Null)
		
		If vSEDNo <> "" Then
		    SQL= "delete from sed_detail where elt_account_number = " & elt_account_number & " and sed_id=" & vSEDNo
		    eltConn.Execute SQL
		End If
		
		for i= 0 to NoItem

			if trim(aBNumber(i)) <> "" then
				SQL= "select * from sed_detail where elt_account_number = " & elt_account_number & " and sed_id=" & vSEDNo & " and item_no=" & i+1
				
				rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
				If rs.EOF Then
					rs.AddNew
					rs("elt_account_number")=elt_account_number
					rs("HAWB_num")=vHAWB
					rs("MAWB_num")=vMAWB
					rs("item_no")=i+1
				End If
				rs("sed_id") = vSEDNo
				rs("dfm")=aDFM(i)
				rs("b_number")=aBNumber(i)
				rs("item_desc")=aSBDesc(i)
				rs("b_qty1")=aBQty1(i)
				rs("unit1")=aUnit1(i)
				rs("b_qty2")=aBQty2(i)
				rs("unit2")=aUnit2(i)
				rs("gross_weight")=aGrossWeight(i)
				rs("VIN")=aVIN(i)
				rs("item_value")=aValue(i)
				rs("export_code")=aExportCode(i)
				rs("license_type")=aLicenseType(i)
				rs.Update
				rs.Close
			end if	
		next
	end if
end if

if Not vExportDate="" then
	eDD=Day(vExportDate)
	if Len(eDD)=1 then eDD="0" & eDD
	eMM=Month(vExportDate)
	if Len(eMM)=1 then eMM="0" & eMM
	eYY=Year(vExportDate)
	eYY=Mid(eYY,3,2)
	eExportDate=eYY & eMM & eDD
end if

'///////////////////////////////////////////////////////////////
'///////////////////////////////////////////// by ig 08/09/2005 
'///////////////////////////////////////////////////////////////

sbIndex=0
Dim aSB(200),aDesc(200),aSBUnit1(200),aSBUnit2(200)

if not vShipperAcct = "0" then
	if tmpShipperAcct = "" then
		tmpShipperAcct = vShipperAcct
	end if
end if

if not tmpShipperAcct = "" then
		SQL= "select sb,description,sb_unit1,sb_unit2 from ig_schedule_b where elt_account_number = " & elt_account_number & "AND org_account_number="& tmpShipperAcct & " order by sb"
		
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing
		Do While Not rs.EOF
			aSB(sbIndex)=rs("sb")
			aDesc(sbIndex)=rs("description")
			aSBUnit1(sbIndex)=rs("sb_unit1")
			aSBUnit2(sbIndex)=rs("sb_unit2")
			sbIndex=sbIndex+1
			rs.MoveNext
		Loop
		rs.Close			
end if

if sbIndex=0 then
		SQL= "select sb,description,sb_unit1,sb_unit2 from scheduleb where elt_account_number = " & elt_account_number & " order by sb"
		
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing
		sbIndex=0
		Do While Not rs.EOF
			aSB(sbIndex)=rs("sb")
			aDesc(sbIndex)=rs("description")
			aSBUnit1(sbIndex)=rs("sb_unit1")
			aSBUnit2(sbIndex)=rs("sb_unit2")
			sbIndex=sbIndex+1
			rs.MoveNext
		Loop
		rs.Close
end if


Dim aShipperArrayList,aConsigneeArrayList,shipperTable,consigneeTable
Set aShipperArrayList = Server.CreateObject("System.Collections.ArrayList")
Set aConsigneeArrayList = Server.CreateObject("System.Collections.ArrayList")

SQL = "SELECT is_shipper,is_consignee,b_country_code,org_account_number, " _
            & "CASE WHEN isnull(class_code,'') = '' THEN dba_name " _
            & "ELSE dba_name + '[' + RTRIM(LTRIM(isnull(class_code,''))) + ']' " _
            & "END as dba_name FROM organization where elt_account_number = " & elt_account_number _
            & "AND (is_consignee='Y' OR is_shipper='Y') ORDER BY dba_name"

eltConn.CursorLocation = adUseNone
rs.CursorLocation = adUseClient	
rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
Set rs.ActiveConnection = Nothing

Do While Not rs.EOF and NOT rs.bof
    cName = rs("dba_name")
	cAcct=cLng(rs("org_account_number"))
	cCountryCode=rs("b_country_code")
	IsShipper=rs("is_shipper")
	IsConsignee=rs("is_consignee")
	
    Set shipperTable = Server.CreateObject("System.Collections.HashTable")
    Set consigneeTable = Server.CreateObject("System.Collections.HashTable")
    
    
    If IsShipper="Y" then
		shipperTable.Add "name" ,RemoveQuotations(cName)
		shipperTable.Add "acct" , cAcct
		aShipperArrayList.Add shipperTable
	End If
	
	If IsConsignee="Y" then
		consigneeTable.Add "name" , RemoveQuotations(cName)
		consigneeTable.Add "acct" , cAcct
		aConsigneeArrayList.Add consigneeTable
		If checkBlank(vConsigneeAcct,0)=checkBlank(cAcct,0) then
            vConsigneeCountryCode=cCountryCode
        End If
	End If
	rs.MoveNext()
Loop

rs.Close()


'GET MOT
Dim aMOT(32), aMOTDesc(32)
SQL= "select mot,mot_desc from mode_transport_code order by mot"

rs.CursorLocation = adUseClient
rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
Set rs.activeConnection = Nothing
aMOT(0)=0
aMOTDesc(0)="Select One"
motIndex=1
Do While Not rs.EOF
	aMOT(motIndex)=cInt(rs("mot"))
	aMOTDesc(motIndex)=rs("mot_desc")
	motIndex=motIndex+1
	rs.MoveNext
Loop
rs.Close
'GET IBT
Dim aIBT(32), aIBTDesc(32)
SQL= "select ibt,ibt_desc from inbond_type order by ibt"

rs.CursorLocation = adUseClient
rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
Set rs.activeConnection = Nothing
aIBT(0)=0
aIBTDesc(0)="Select One"
ibtIndex=1
Do While Not rs.EOF
	aIBT(ibtIndex)=cInt(rs("ibt"))
	aIBTDesc(ibtIndex)=rs("ibt_desc")
	ibtIndex=ibtIndex+1
	rs.MoveNext
Loop
rs.Close
'GET Unit Code
Dim aUnitCode(64), aUnitDesc(64)
SQL= "select unit_code,unit_desc from unit_code order by unit_code"

rs.CursorLocation = adUseClient
rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
Set rs.activeConnection = Nothing
aUnitCode(0)=0
aUnitDesc(0)="Select One"
uIndex=1
Do While Not rs.EOF
	aUnitCode(uIndex)=Trim(rs("unit_code"))
	aUnitDesc(uIndex)=rs("unit_desc")
	uIndex=uIndex+1
	rs.MoveNext
Loop
rs.Close
'followings are for the AESdirect
'get mawb info
If vMAWB <> "" then
	SQL= "select * from mawb_number where mawb_no=N'" & vMAWB & "'"
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	if Not rs.EOF then
		vSCAC=rs("scac")
		vExportPort=rs("origin_port_id")
		vPOE = rs("origin_port_aes_code")
		vOriginState=rs("origin_port_state")
		vUnloadingPort=rs("dest_port_id")
		vPOU=rs("dest_port_aes_code")
		vCOD=rs("dest_country_code")
		vDestCountry=rs("dest_port_country")
	end if
	rs.Close
end if

SQL= "select * from agent where elt_account_number=" & elt_account_number

rs.CursorLocation = adUseClient
rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
Set rs.activeConnection = Nothing
if Not rs.EOF then
	vAD3_2="E"
	vAD3_3=rs("dba_name")
	vAD3_4=rs("business_fed_taxid")
	vAD3_5=rs("owner_fname") & " " & rs("owner_lname")
	vAD3_7=rs("business_phone")
	vAD3_8=rs("business_address")
	if len(vAD3_8)>32 then
		vAD3_9=Mid(vAD3_8,33,32)
		vAD3_8=Mid(vAD3_8,1,32)
	end if
	vAD3_10=rs("business_city")
	vAD3_11=rs("business_state")
	vAD3_12=rs("country_code")
	vAD3_13=rs("business_zip")
end if
rs.Close

if vForwardAgent="" then
	vForwardAgent=vAD3_3 & chr(10) & vAD3_10 & ", " & vAD3_11 & " " & vAD3_13
end if

if Not vShipperAcct="" then
	SQL= "select * from organization where elt_account_number=" & elt_account_number _
	    & " and org_account_number=" & vShipperAcct

	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	if Not rs.EOF then
		vAD0_1=rs("dba_name")
		vAD0_2=rs("business_fed_taxid")
		pos=0
		pos=instr(vAD0_2,"-")
		if pos>0 then
			vAD0_2=Mid(vAD0_2,1,pos-1) & Mid(vAD0_2,pos+1,20)
		end if
		vAD0_3="E"
		vAD0_4=Mid(rs("business_address"),1,32)
		vAD0_5=Mid(rs("business_address2"),1,32)
		vAD0_6=Mid(rs("business_city"),1,25)
		vAD0_7=rs("business_state")
		vAD0_8=rs("business_zip")
		vAD0_9=rs("owner_fname")
		vAD0_11=rs("owner_lname")
		vAD0_12=rs("owner_phone")
	end if
	rs.Close
end if

if Not vUltiConsignee="" then
    SQL= "select * from organization where elt_account_number=" & elt_account_number _
        & " and org_account_number="  & vConsigneeAcct
    
    rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	if Not rs.EOF then
		vAD1_3=rs("dba_name")
		vAD1_8=Mid(rs("business_address"),1,32)
		vAD1_9=Mid(rs("business_address2"),1,32)
		vAD1_10=Mid(rs("business_city"),1,25)
		vAD1_11=rs("business_state")
		vAD1_12=rs("b_country_code")
		vAD1_13=rs("business_zip")
	end if
	rs.Close
end if

for i=0 to tIndex-1
	aBNumberSED(i)=aBNumber(i)
	pos=0
	pos=instr(aBNumberSED(i),".")
	do while pos>0
		aBNumberSED(i)=Mid(aBNumberSED(i),1,pos-1) & Mid(aBNumberSED(i),pos+1,10)
		pos=instr(aBNumberSED(i),".")
	loop
next

Set rs=Nothing
vPrintPort=sedPort

Dim server_name
server_name = LCase(Request.ServerVariables("SERVER_NAME"))
returnURL = "http://" & server_name & "/IFF_MAIN/ASPX/MISC/ManageSED.aspx"
'// Remove this before publishing
Dim server_port
server_port = request.ServerVariables("SERVER_PORT")
If server_port <> "80" Then
    returnURL = "http://" & server_name & ":" & server_port & "/IFF_MAIN/ASPX/MISC/ManageSED.aspx"
End If

eltConn.CommitTrans
eltConn.Close()

Set eltConn = Nothing

%>
<body link="336699" vlink="336699" style="margin: 0px 0px 0px 0px" onload="self.focus()">
    <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
        <tr>
            <td width="36%" height="32" align="left" valign="middle" class="pageheader">
                AES Form&nbsp;</td>
            <td width="64%" align="right" valign="middle" class="bodycopy">
                <div id="print">
                    <img src="/iff_main/ASP/Images/icon_submit.gif" align="absbottom"><a href="javascript:;"
                        onclick="AESClick();return false;">Submit to AES Weblink</a><img src="/iff_main/ASP/Images/button_devider.gif"
                            alt="" /><a href="/IFF_MAIN/ASPX/Misc/ManageSED.aspx">Manage AES</a><img src="/iff_main/ASP/Images/button_devider.gif"
                                alt="" /><a href="javascript:void(viewPop2('PopWin','http://www.aesdirect.gov'));">AES
                                    Direct Homepage</a><img src="/iff_main/ASP/Images/button_devider.gif" alt="" /><a
                                        href="javascript:;" onclick="window.open('sed_help.html','aeshelp','width=460,height=300');return false;">AES
                                        Weblink Login Help</a>
                </div>
                <form method="post" name="AES" action="https://aesdirect.census.gov/weblink/weblink.cgi">
                    <input type="hidden" name="wl_app_ident" value="wlelog01" />
                    <input type="hidden" name="wl_app_name" value="eFreightForward" />
                    <input type="hidden" name="wl_nologin_url" value="http://www.weblinktestapp.com/nologin.html" />
                    <input type="hidden" name="wl_nosed_url" value="http://www.weblinktestapp.com/nosed.html" />
                    <!--<input type="hidden" name="wl_success_url" value="<%=returnURL %>" />-->
                    <input type="hidden" name="var_type" value="new" />
                    <input type="hidden" name="EMAIL" value="<%= vEmail %>" />
                    <input type="hidden" name="SRN" value="<%= vShipmentRefNo %>" />
                    <!--<input type="hidden" name="BN" value="" /> -->
                    <input type="hidden" name="ST" value="<%= vOriginState %>" />
                    <input type="hidden" name="POE" value="<%= vPOE %>" />
                    <input type="hidden" name="COD" value="<%= vCOD %>" />
                    <input type="hidden" name="EDA" value="<%= eExportDate %>" />
                    <input type="hidden" name="POU" value="<%= vPOU %>" />
                    <input type="hidden" name="MOT" value="<%= vMOT %>" />
                    <input type="hidden" name="SCAC" value="<%= vSCAC %>" />
                    <input type="hidden" name="VN" value="<%= vExportCarrier %>" />
                    <input type="hidden" name="RCC" value="<%= vRelated %>" />
                    <input type="hidden" name="HAZ" value="<%= vHazYes %>" />
                    <input type="hidden" name="RT" value="<%= vRouteYes %>" />
                    <input type="hidden" name="AD0_1" value="<%= vAD0_1 %>" />
                    <input type="hidden" name="AD0_2" value="<%= vAD0_2 %>" />
                    <input type="hidden" name="AD0_3" value="E" />
                    <input type="hidden" name="AD0_4" value="<%= vAD0_4 %>" />
                    <input type="hidden" name="AD0_5" value="<%= vAD0_5 %>" />
                    <input type="hidden" name="AD0_6" value="<%= vAD0_6 %>" />
                    <input type="hidden" name="AD0_7" value="<%= vAD0_7 %>" />
                    <input type="hidden" name="AD0_8" value="<%= vAD0_8 %>" />
                    <input type="hidden" name="AD0_9" value="<%= vAD0_9 %>" />
                    <input type="hidden" name="AD0_11" value="<%= vAD0_11 %>" />
                    <input type="hidden" name="AD0_12" value="<%=ReplaceAllButNumbers(vAD0_12) %>" />
                    <input type="hidden" name="AD1_3" value="<%= vAD1_3 %>" />
                    <input type="hidden" name="AD1_8" value="<%= vAD1_8 %>" />
                    <input type="hidden" name="AD1_9" value="<%= vAD1_9 %>" />
                    <input type="hidden" name="AD1_10" value="<%= vAD1_10 %>" />
                    <!--<input type="hidden" name="AD1_11" value="<%= vAD1_11 %>" />-->
                    <input type="hidden" name="AD1_12" value="<%= vAD1_12 %>" />
                    <input type="hidden" name="AD1_13" value="<%= vAD1_13 %>" />
                    <input type="hidden" name="AD3_2" value="<%= vAD3_2 %>" />
                    <input type="hidden" name="AD3_3" value="<%= vAD3_3 %>" />
                    <input type="hidden" name="AD3_4" value="<%= vAD3_4 %>" />
                    <input type="hidden" name="AD3_5" value="<%= vAD3_5 %>" />
                    <input type="hidden" name="AD3_7" value="<%=ReplaceAllButNumbers(vAD3_7) %>" />
                    <input type="hidden" name="AD3_8" value="<%= vAD3_8 %>" />
                    <input type="hidden" name="AD3_9" value="<%= vAD3_9 %>" />
                    <input type="hidden" name="AD3_10" value="<%= vAD3_10 %>" />
                    <input type="hidden" name="AD3_11" value="<%= vAD3_11 %>" />
                    <input type="hidden" name="AD3_12" value="<%= vAD3_12 %>" />
                    <input type="hidden" name="AD3_13" value="<%= vAD3_13 %>" />
                    <% for i=1 to tIndex %>
                    <input type="hidden" name="isLine<%= i %>" value="Y" />
                    <input type="hidden" name="IT<%= i %>_1" value="<%= aExportCode(i-1) %>" />
                    <input type="hidden" name="IT<%= i %>_2" value="<%= aValue(i-1) %>" />
                    <input type="hidden" name="IT<%= i %>_3" value="<%= aUnit1(i-1) %>" />
                    <input type="hidden" name="IT<%= i %>_4" value="<%= aBQty1(i-1) %>" />
                    <input type="hidden" name="IT<%= i %>_7" value="<%= aGrossWeight(i-1) %>" />
                    <input type="hidden" name="IT<%= i %>_8" value="<%= aLicenseType(i-1) %>" />
                    <input type="hidden" name="IT<%= i %>_12" value="<%= aSBDesc(i-1) %>" />
                    <input type="hidden" name="IT<%= i %>_13" value="<%= aBNumberSED(i-1) %>" />
                    <input type="hidden" name="IT<%= i %>_15" value="<%= aVFlag(i-1) %>" />
                    <input type="hidden" name="IT<%= i %>_20" value="<%= vECCN %>" />
                    <input type="hidden" name="IT<%= i %>_21" value="<% if vCOD="US" then response.write("D") else response.write("F") %>" />
                    <% next %>
                </form>
            </td>
        </tr>
    </table>
    <!--
    <div class="selectarea">
        <table width="95%" height="40" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td width="45%">
                </td>
                <td width="55%" align="right" valign="bottom">
                    <div id="print">
                        <img src="/iff_main/ASP/Images/icon_dotprinter.gif" align="absbottom"><a href="javascript:;"
                            onclick="PrintForm();return false;">SED</a></div>
                </td>
            </tr>
        </table>
    </div>
    -->
    <br />
    <form method="POST" name="form1">
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#A0829C"
            bgcolor="#A0829C" class="border1px">
            <tr>
                <td>
                    <% if tIndex = 0 then tIndex = 1  %>
                    <!-- start of scroll bar -->
                    <input type="hidden" name="scrollPositionX">
                    <input type="hidden" name="scrollPositionY">
                    <!-- end of scroll bar -->
                    <input type="HIDDEN" name="txtZipCode" value="<%= vZipCode %>">
                    <input type="hidden" name="hMAWB" value="<%= vMAWB %>">
                    <input type="hidden" name="hNoItem" value="<%= tIndex %>">
                    <input type="hidden" name="hPrintPort" value="<%= vPrintPort %>">
                    <input type="hidden" name="hClientOS" value="<%= ClientOS %>">
                    <input type="hidden" name="hVesselName" value="<%= vVN %>">
                    <input type="hidden" name="hContactLastName" value="<%= vContactLastName %>">
                    <input type="hidden" name="hContactFirstName" value="<%= vContactFirstName %>">
                    <input type="hidden" name="hConsigneeCountryCode" value="<%= vConsigneeCountryCode %>">
                    <input type="hidden" name="hSEDNo" value="<%=vSEDNo %>" />
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td colspan="2" height="24" align="left" valign="middle" bgcolor="E5D4E3" class="bodyheader">
                                <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="26%">
                                            &nbsp;</td>
                                        <td width="48%" align="center" valign="middle">
                                            <img src="../images/button_save_medium.gif" width="46" height="18" name="bSave" onclick="bSaveClick()"
                                                style="cursor: hand"></td>
                                        <td width="13%" align="right" valign="middle">
                                            <a href="/iff_main/ASP/air_export/sed.asp" target="_self">
                                                <img src="/iff_main/ASP/Images/button_new.gif" width="42" height="17" border="0"
                                                    style="cursor: hand"></a></td>
                                        <td width="13%" align="right" valign="middle">
                                            <img src="../images/button_delete_medium.gif" width="51" height="18" name="bDelete"
                                                onclick="DeleteSED()" style="cursor: hand"></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" height="1" bgcolor="#A0829C">
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <table width="100%" border="0" cellpadding="3" cellspacing="0">
                                    <% If vSEDNo <> "" Then %>
                                    <tr style="background-color: #f0e7ef">
                                        <td style="width: 150px">
                                            <span class="bodyheader" style="color: #c16b42">MAWB</span></td>
                                        <td style="width: 150px">
                                            <span class="bodyheader" style="color: #c16b42">HAWB</span></td>
                                        <td style="width: 100%">
                                        </td>
                                    </tr>
                                    <% End If %>
                                    <tr style="background-color: #ffffff">
                                        <td style="width: 150px">
                                            <input name="txtMAWB" type="text" class="bodyheader" value="<%= vMAWB %>" size="32"
                                                readonly="readonly" style="border: none 0px" />
                                        </td>
                                        <td style="width: 150px">
                                            <input name="txtHAWB" type="text" class="bodyheader" value="<%= vHAWB %>" size="32"
                                                readonly="readonly" style="border: none 0px" />
                                        </td>
                                        <td align="right" valign="middle" style="width: 100%">
                                            <span class="bodyheader">
                                                <img src="/iff_main/ASP/Images/required.gif" align="absbottom" alt="" />Required
                                                field</span></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" height="1" bgcolor="#A0829C">
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table width="100%" border="0" cellpadding="1" cellspacing="2" bgcolor="#FFFFFF"
                                    class="bodycopy">
                                    <tr align="left" valign="middle">
                                        <td height="20" colspan="2" bgcolor="#f0e7ef">
                                            <strong><span class="bodyheader">
                                                <img src="/iff_main/ASP/Images/required.gif" align="absbottom"></span>1a. U.S. Principal
                                                Party in Interest (USPPI)</strong>
                                            <br>
                                            (Complete Name and Address)
                                        </td>
                                        <td width="27%" valign="top" bgcolor="#f0e7ef">
                                            <strong><span class="bodyheader">
                                                <img src="/iff_main/ASP/Images/required.gif" align="absbottom"></span>2. Date of
                                                Exportation</strong></td>
                                        <td width="31%" valign="top" bgcolor="#f0e7ef">
                                            <strong>3. Transportation Reference No.</strong></td>
                                    </tr>
                                    <tr align="left" valign="middle">
                                        <td height="22" colspan="2" valign="top">
                                            <!-- //Start of Combobox// -->
                                            <%  iMoonComboBoxName =  "lstShipper" %>
                                            <%  iMoonComboBoxWidth =  "270px" %>
                                            <select name="lstShipper" id="lstShipper" listsize="20" class="ComboBox" style="width: 270px;
                                                display: none" onchange="ComboBox_SimpleAttach(this, this.form['<%=iMoonComboBoxName%>_Text'])">
                                                <option value="">Select One</option>
                                                <% for i=0 to aShipperArrayList.Count-1 %>
                                                <option value="<%= aShipperArrayList(i)("acct") %>" <% 
					  if CLng(vShipperAcct) = CLng(checkblank(aShipperArrayList(i)("acct"),0)) Then 
					  	response.write("selected")
						vShipperName = aShipperArrayList(i)("name")
						if vShipperName = "Select One" then vShipperName = ""
					  end if
					  %>>
                                                    <%= aShipperArrayList(i)("name") %>
                                                </option>
                                                <% next %>
                                            </select>
                                            <%  
    If InStr(1,vShipperName,"[") > 0 Then
        iMoonDefaultValue = Mid(vShipperName,1,InStr(1,vShipperName,"[")-1)
    Else
        iMoonDefaultValue = vShipperName
    End If
                                            %>

                                            <script language="javascript"> function <%=iMoonComboBoxName%>_OnChangePlus() { ShipperChange(); }
                                            </script>

                                            <div id="<%=iMoonComboBoxName%>_Container" class="ComboBox" style="width: <%=iMoonComboBoxWidth%>;
                                                position: ; top: ; left: ; z-index: ;">
                                                <input name="<%=iMoonComboBoxName%>:Text" type="text" id="<%=iMoonComboBoxName%>_Text"
                                                    class="ComboBox" autocomplete="off" style="width: <%=iMoonComboBoxWidth%>; vertical-align: middle"
                                                    value="<%=iMoonDefaultValue%>" />
                                                <div id="<%=iMoonComboBoxName%>_Div" style="display: none; position: absolute; top: 0;
                                                    left: 0; width: 17px">
                                                    <img id="<%=iMoonComboBoxName%>_Button" src="/ig_common/Images/combobox_drop.gif"
                                                        border="0" /></div>
                                            </div>
                                            <div id="<%=iMoonComboBoxName%>_NewDiv" style="display: none; position: absolute;
                                                top: 0; left: 0; width: 17px">
                                                <img id="<%=iMoonComboBoxName%>_AddNewButton" src="/ig_common/Images/combobox_addnew.gif"
                                                    border="0" /></div>
                                            <!-- /End of Combobox/ -->
                                            <input type="hidden" name="hShipper" value="<%= vShipperName %>">
                                            <input type="hidden" name="hShipperAcct" value="<%= vShipperAcct %>">
                                        </td>
                                        <td valign="top">
                                            <input name="txtExportDate" type="text" class="m_shorttextfield" preset="shortdate"
                                                value="<%= vExportDate %>" size="22">
                                        </td>
                                        <td valign="top">
                                            <input name="txtTranRefNo" type="text" class="shorttextfield" value="<%=vTranRefNo %>"
                                                maxlength="32" size="22" />
                                        </td>
                                    </tr>
                                    <tr align="left" valign="middle">
                                        <td colspan="2" valign="top">
                                            <table width="100%" border="0" cellpadding="1" cellspacing="2" class="bodycopy">
                                                <tr>
                                                    <td width="100%" colspan="7">
                                                        <textarea name="txtUSPPI" cols="50" rows="4" class="multilinetextfield"><%= vShipperInfo %></textarea>
                                                    </td>
                                                </tr>
                                                <tr bgcolor="#f0e7ef">
                                                    <td height="20">
                                                        <strong>b. USPPI EIN (IRS) No or ID No</strong></td>
                                                    <td>
                                                        <strong>c. Parties to Transaction</strong></td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <input name="txtTaxID" type="text" class="shorttextfield" maxlength="16" value="<%=vShipperTaxID %>"
                                                            size="22" /></td>
                                                    <td>
                                                        <input type="checkbox" name="cRelated" value="<%= vRelated %>" onclick="RelatedClick()"
                                                            <% if vRelated="Y" then response.write("checked") %>>
                                                        Related&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                        <input type="checkbox" name="cNonRelated" value="" onclick="NonRelatedClick()" <% if vRelated="N" then response.write("checked") %>>
                                                        Non-related
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td colspan="2" valign="top">
                                            <table width="100%" border="0" cellspacing="2" cellpadding="1">
                                                <tr bgcolor="#f0e7ef">
                                                    <td width="27%" class="bodycopy">
                                                        <strong><span class="bodyheader">
                                                            <img src="/iff_main/ASP/Images/required.gif" align="absbottom"></span>4a. Ultimate
                                                            Consignee</strong>
                                                        <br>
                                                        (Complete Name and Address)</td>
                                                    <td width="31%" class="bodycopy">
                                                        <strong>b. Intermediate Consignee</strong>
                                                        <br>
                                                        (Complete Name and Address)</td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <!-- /Start of Combobox/ -->
                                                        <%  iMoonComboBoxName =  "lstConsignee" %>
                                                        <%  iMoonComboBoxWidth =  "217px" %>
                                                        <select name="lstConsignee" id="lstConsignee" listsize="20" class="ComboBox" style="width: 217px;
                                                            display: none" onchange="ComboBox_SimpleAttach(this, this.form['<%=iMoonComboBoxName%>_Text'])">
                                                            <option value="">Select One</option>
                                                            <% for i=0 to aConsigneeArrayList.Count-1 %>
                                                            <option value="<%= aConsigneeArrayList(i)("acct") %>" <% 
							if not vConsigneeAcct = "" then 
								if cLng(vConsigneeAcct)=aConsigneeArrayList(i)("acct") then 
								response.write("selected") 
								vConsigneeName = aConsigneeArrayList(i)("name")
								if vConsigneeName = "Select One" then vConsigneeName = ""								
								end if
							end if
							%>>
                                                                <%= aConsigneeArrayList(i)("name") %>
                                                            </option>
                                                            <% next %>
                                                        </select>
                                                        <%  
    If InStr(1,vConsigneeName,"[") > 0 Then
        iMoonDefaultValue = Mid(vConsigneeName,1,InStr(1,vConsigneeName,"[")-1)
    Else
        iMoonDefaultValue = vConsigneeName
    End If
                                                        %>

                                                        <script language="javascript"> function <%=iMoonComboBoxName%>_OnChangePlus() { ConsigneeChange(); } </script>

                                                        <div id="<%=iMoonComboBoxName%>_Container" class="ComboBox" style="width: <%=iMoonComboBoxWidth%>;
                                                            position: ; top: ; left: ; z-index: ;">
                                                            <input name="<%=iMoonComboBoxName%>:Text" type="text" id="<%=iMoonComboBoxName%>_Text"
                                                                class="ComboBox" autocomplete="off" style="width: <%=iMoonComboBoxWidth%>; vertical-align: middle"
                                                                value="<%=iMoonDefaultValue%>" />
                                                            <div id="<%=iMoonComboBoxName%>_Div" style="display: none; position: absolute; top: 0;
                                                                left: 0; width: 17px">
                                                                <img id="<%=iMoonComboBoxName%>_Button" src="/ig_common/Images/combobox_drop.gif"
                                                                    border="0" /></div>
                                                        </div>
                                                        <div id="<%=iMoonComboBoxName%>_NewDiv" style="display: none; position: absolute;
                                                            top: 0; left: 0; width: 17px">
                                                            <img id="<%=iMoonComboBoxName%>_AddNewButton" src="/ig_common/Images/combobox_addnew.gif"
                                                                border="0" /></div>
                                                        <!-- /End of Combobox/ -->
                                                        <input type="hidden" name="hConsignee" value="<%= vConsigneeName %>">
                                                        <input type="hidden" name="hConsigneeAcct" value="<%= vConsigneeAcct %>"></td>
                                                    <td rowspan="2" valign="bottom">
                                                        <textarea name="txtInterConsignee" cols="40" rows="4" class="multilinetextfield"><%= vInterConsignee %></textarea></td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <textarea name="txtUltiConsignee" cols="40" rows="4" class="multilinetextfield"><%= vUltiConsignee %></textarea></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr align="left" valign="middle">
                                        <td height="20" colspan="2" bgcolor="#f0e7ef">
                                            <strong>5. Forwarding Agent</strong> (Complete Name and Address)</td>
                                        <td height="20" bgcolor="#f0e7ef">
                                            <strong>6. Point (State) of Origin or FTZ No</strong></td>
                                        <td height="20" bgcolor="#f0e7ef">
                                            <strong>7. Country of Ultimate Destination</strong></td>
                                    </tr>
                                    <tr align="left" valign="middle">
                                        <td td colspan="2">
                                            <textarea name="txtForwardAgent" cols="50" rows="3" class="multilinetextfield"><%= vForwardAgent %></textarea>
                                        </td>
                                        <td valign="top">
                                            <input name="txtOriginState" type="text" class="shorttextfield" maxlength="16" value="<%= vOriginState %>"
                                                size="22">
                                        </td>
                                        <td valign="top">
                                            <input name="txtDestCountry" type="text" class="shorttextfield" maxlength="32" value="<%= vDestCountry %>"
                                                size="22">
                                        </td>
                                    </tr>
                                    <tr align="left" valign="middle">
                                        <td height="20" bgcolor="#f0e7ef">
                                            <strong>8. Loading Pier</strong> (Vessel Only)</td>
                                        <td bgcolor="#f0e7ef">
                                            <strong>9. Method of Transportation</strong> (Specify)</td>
                                        <td bgcolor="#f0e7ef">
                                            <strong>14. Carrier Identification Code</strong></td>
                                        <td bgcolor="#f0e7ef">
                                            <img src="/iff_main/ASP/Images/required.gif" align="absbottom"><strong>15. Shipment
                                                Reference No</strong></td>
                                    </tr>
                                    <tr align="left" valign="middle">
                                        <td>
                                            <input name="txtLoadingPier" type="text" class="shorttextfield" maxlength="32" value="<%= vLoadingPier %>"
                                                size="20">
                                        </td>
                                        <td>
                                            <select name="lstMOT" size="1" class="smallselect" style="width: 160px">
                                                <% for i=0 to motIndex-1 %>
                                                <option value="<%= aMOT(i) %>" <% If ConvertAnyValue(vMOT,"String","")=ConvertAnyValue(aMOT(i),"String","") Then Response.Write("selected=selected") %>>
                                                    <%= aMOTDesc(i) %>
                                                </option>
                                                <% next %>
                                            </select>
                                        </td>
                                        <td>
                                            <input name="txtCarrierIDCode" type="text" maxlength="16" class="shorttextfield"
                                                value="<%= vCarrierIDCode %>" size="22" />
                                        </td>
                                        <td>
                                            <input name="txtShipmentRefNo" type="text" maxlength="16" class="shorttextfield"
                                                value="<%= vShipmentRefNo %>" size="22" />
                                        </td>
                                    </tr>
                                    <tr align="left" valign="middle">
                                        <td height="20" bgcolor="#f0e7ef">
                                            <strong>10. Exporting Carrier</strong></td>
                                        <td height="20" bgcolor="#f0e7ef">
                                            <strong>11. Port of Export&nbsp;&nbsp;<a href="javascript:void(viewPop2('PopWin','http://www.aesdirect.gov/support/tables/schdd.txt'));">Port
                                                Codes</a></strong></td>
                                        <td bgcolor="#f0e7ef">
                                            <strong>16. Entry Number</strong></td>
                                        <td bgcolor="#f0e7ef">
                                            <strong>17. Hazardous Materials</strong></td>
                                    </tr>
                                    <tr align="left" valign="middle">
                                        <td>
                                            <input name="txtExportCarrier" type="text" maxlength="32" class="shorttextfield"
                                                value="<%= vExportCarrier %>" size="20">
                                        </td>
                                        <td>
                                            <input name="txtExportPort" type="text" maxlength="32" class="shorttextfield" value="<%= vExportPort %>"
                                                size="20">
                                        </td>
                                        <td>
                                            <input name="txtEntryNo" type="text" maxlength="16" class="shorttextfield" value="<%= vEntryNo %>"
                                                size="22">
                                        </td>
                                        <td>
                                            <input type="checkbox" name="cHazYes" value="<%= vHazYes %>" onclick="HazYes()" <% if vHazYes="Y" then response.write("checked") %>>
                                            &nbsp; Yes &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            <input type="checkbox" name="cHazNo" value="" onclick="HazNo()" <% if vHazYes="N" then response.write("checked") %>>
                                            &nbsp; No</td>
                                    </tr>
                                    <tr align="left" valign="middle">
                                        <td height="20" bgcolor="#f0e7ef">
                                            <strong>12. Port of Unloading </strong>
                                            <br>
                                            (Vessel and Air Only)</td>
                                        <td height="20" bgcolor="#f0e7ef">
                                            <strong>13. containerized</strong> (Vessel Only)</td>
                                        <td bgcolor="#f0e7ef">
                                            <strong>18. In Bond Number</strong></td>
                                        <td bgcolor="#f0e7ef">
                                            <strong>19. Routed Export Transaction</strong></td>
                                    </tr>
                                    <tr align="left" valign="middle">
                                        <td width="25%">
                                            <input name="txtUnloadingPort" maxlength="32" type="text" class="shorttextfield"
                                                value="<%= vUnloadingPort %>" size="20">
                                        </td>
                                        <td width="25%">
                                            <input type="checkbox" name="cConYes" value="<%= vConYes %>" onclick="ConYes()" <% if vConYes="Y" then response.write("checked") %>>
                                            &nbsp; Yes&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            <input type="checkbox" name="cConNo" value="" onclick="ConNo()" <% if vConYes="" then response.write("checked") %>>
                                            &nbsp; No</td>
                                        <td width="27%">
                                            <select name="lstIBT" size="1" class="smallselect" style="width: 220px">
                                                <% for i=0 to ibtIndex-1 %>
                                                <option value="<%= aIBT(i) %>" <% If ConvertAnyValue(vIBT,"String","")=ConvertAnyValue(aIBT(i),"String","") Then Response.Write("selected=selected") %>>
                                                    <%= aIBTDesc(i) %>
                                                </option>
                                                <% next %>
                                            </select>
                                        </td>
                                        <td width="31%">
                                            <input type="checkbox" name="cRouteYes" value="<%= vRouteYes %>" onclick="RouteYes()"
                                                <% if vRouteYes="Y" then response.write("checked") %>>
                                            &nbsp; Yes &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            <input type="checkbox" name="cRouteNo" value="" onclick="RouteNo()" <% if vRouteYes="N" then response.write("checked") %>>
                                            &nbsp; No</td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" height="1" bgcolor="A0829C">
                            </td>
                        </tr>
                        <tr align="center" valign="middle">
                            <td colspan="2" bgcolor="#FFFFFF">
                                <table width="100%" border="0" cellpadding="1" cellspacing="2" bgcolor="#FFFFFF"
                                    class="bodycopy">
                                    <tr align="left" valign="middle" bgcolor="E5D4E3" class="bodycopy">
                                        <td height="20" colspan="14" bgcolor="E5D4E3">
                                            <strong>20. Schedule B Description of Commodities (Use Columns 22-24)</strong></td>
                                    </tr>
                                    <tr align="left" valign="top" bgcolor="#f0e7ef">
                                        <td width="48">
                                            D/F
                                            <br>
                                            or M<br>
                                            <br>
                                            <br>
                                            <br>
                                            <strong>(21)<br>
                                                <br>
                                            </strong>
                                        </td>
                                        <td width="279" colspan="2">
                                            <p>
                                                Schedule B No.</p>
                                            <br>
                                            <br>
                                            <strong>(22)<img src="/iff_main/Images/spacer.gif" width="180" height="5"><img src="../images/button_reload.gif"
                                                width="51" height="18" align="absbottom" onclick="javascript:GET_SCHEDULE_B_AJAX();"
                                                style="cursor: hand"></strong></td>
                                        <td>
                                            Qty1</td>
                                        <td>
                                            Unit1</td>
                                        <td>
                                            Qty2</td>
                                        <td>
                                            Unit2</td>
                                        <td>
                                            Shipping WT (KG)<br>
                                            <br>
                                            <br>
                                            <br>
                                            <strong>(24)<br>
                                                <br>
                                            </strong>
                                        </td>
                                        <td>
                                            VIN/<br>
                                            Product No./<br>
                                            Vehicle
                                            <br>
                                            Title No.<strong><br>
                                                <br>
                                                (25)</strong><br>
                                            <br>
                                        </td>
                                        <td bgcolor="#f0e7ef">
                                            Value<br>
                                            (U.S. dollar,
                                            <br>
                                            omit cents)<br>
                                            (Spelling price or cost if not sold)<br>
                                            <strong>(26) </strong>
                                            <br>
                                        </td>
                                        <td>
                                            <strong><a href="javascript:void(viewPop2('PopWin','/iff_main/ASP/Code/export_code.htm'));">
                                                Export Code</a></strong></td>
                                        <td>
                                            <strong><a href="javascript:void(viewPop2('PopWin','../Code/type_code.html'));">License
                                                Type</a></strong></td>
                                        <td>
                                            &nbsp;</td>
                                        <td width="89">
                                            &nbsp;</td>
                                    </tr>
                                    <input type="hidden" id="DFM">
                                    <input type="hidden" id="BNumber">
                                    <input type="hidden" id="BQty1">
                                    <input type="hidden" id="Unit1">
                                    <input type="hidden" id="BQty2">
                                    <input type="hidden" id="Unit2">
                                    <input type="hidden" id="GrossWeight">
                                    <input type="hidden" id="VIN">
                                    <input type="hidden" id="Value">
                                    <input type="hidden" id="ExportCode">
                                    <input type="hidden" id="LicenseType">
                                    <% for i=0 to tIndex - 1 %>
                                    <tr align="left" valign="middle" bgcolor="#FFFFFF">
                                        <td>
                                            <select name="lstDFM<%= i %>" size="1" class="smallselect" id="DFM" style="width: 35px">
                                                <option value="D" <% if aDFM(i)="D" then response.write("selected") %>>D</option>
                                                <option value="F" <% if aDFM(i)="F" then response.write("selected") %>>F</option>
                                                <option value="M" <% if aDFM(i)="M" then response.write("selected") %>>M</option>
                                            </select>
                                        </td>
                                        <td colspan="2" id="scheduleTd<%= i %>">
                                            <select name="lstBNumber<%= i %>" size="1" class="smallselect" id="BNumber" style="width: 260px"
                                                onchange="SBChange(<%= i %>)">
                                                <option>Select One</option>
                                                <option>Add New Schedule B Number</option>
                                                <% for j=0 to sbIndex-1 %>
                                                <option value="<%= aSB(j) & "^" & aDesc(j) & "^" & aSBUnit1(j) & "^" & aSBUnit2(j) %>"
                                                    <% if aSB(j)=aBNumber(i) then response.write("selected") %>>
                                                    <%= aSB(j) & "-" & aDesc(j) %>
                                                </option>
                                                <% next %>
                                            </select>
                                        </td>
                                        <td>
                                            <input name="txtBQty1<%= i %>" type="text" class="shorttextfield" id="BQty1" value="<%= aBQty1(i) %>"
                                                size="5"></td>
                                        <td>
                                            <input name="txtUnitOne<%= i %>" type="text" class="shorttextfield" id="Unit1" value="<%= aUnit1(i) %>"
                                                size="5"></td>
                                        <td>
                                            <input name="txtBQty2<%= i %>" type="text" class="shorttextfield" id="BQty2" value="<%= aBQty2(i) %>"
                                                size="5"></td>
                                        <td>
                                            <input name="txtUnitTwo<%= i %>" type="text" class="shorttextfield" id="Unit2" value="<%= aUnit2(i) %>"
                                                size="5"></td>
                                        <td>
                                            <input name="txtGrossWeight<%= i %>" type="text" class="shorttextfield" id="GrossWeight"
                                                value="<%= aGrossWeight(i) %>" size="9"></td>
                                        <td>
                                            <input name="txtVIN<%= i %>" type="text" class="shorttextfield" id="VIN" value="<%= aVIN(i) %>"
                                                size="15"></td>
                                        <td>
                                            <input name="txtValue<%= i %>" type="text" class="shorttextfield" id="Value" value="<%= aValue(i) %>"
                                                size="16"></td>
                                        <td>
                                            <input name="txtExportCode<%= i %>" type="text" class="shorttextfield" id="ExportCode"
                                                value="<%= aExportCode(i) %>" size="5"></td>
                                        <td>
                                            <input name="txtLicenseType<%= i %>" type="text" class="shorttextfield" id="LicenseType"
                                                value="<%= aLicenseType(i) %>" size="5"></td>
                                        <td>
                                            <img src="../images/button_delete.gif" width="50" height="17" onclick="DeleteItem(<%= i+1 %>)"
                                                style="cursor: hand"></td>
                                        <td>
                                            <img src="../images/button_add.gif" width="37" height="17" name="bAdd" onclick="AddItem()"
                                                style="cursor: hand"></td>
                                    </tr>
                                    <% next %>
                                    <tr align="left" valign="middle" bgcolor="#FFFFFF">
                                        <td width="48" height="1">
                                            &nbsp;</td>
                                        <td height="1" colspan="2">
                                            &nbsp;</td>
                                        <td width="35" height="1">
                                            &nbsp;</td>
                                        <td width="38" height="1">
                                            &nbsp;</td>
                                        <td width="37" height="1">
                                            &nbsp;</td>
                                        <td width="37" height="1">
                                            &nbsp;</td>
                                        <td width="75" height="1">
                                            &nbsp;</td>
                                        <td width="98" height="1">
                                            &nbsp;</td>
                                        <td width="139" height="1">
                                            &nbsp;</td>
                                        <td width="52" height="1">
                                            &nbsp;</td>
                                        <td width="56" height="1">
                                            &nbsp;</td>
                                        <td width="50" height="1">
                                            &nbsp;</td>
                                        <td height="1">
                                            &nbsp;</td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" bgcolor="#FFFFFF">
                                <table width="65%" border="0" cellpadding="1" cellspacing="2" class="bodycopy">
                                    <tr align="left" valign="middle">
                                        <td height="20" colspan="2" bgcolor="#f0e7ef">
                                            <strong>27. License No/License Exception Symbol/Authorization</strong></td>
                                        <td width="33%" height="20" bgcolor="#f0e7ef">
                                            <strong>28. ECCN </strong>(When Required)</td>
                                    </tr>
                                    <tr align="left" valign="middle">
                                        <td colspan="2">
                                            <input name="txtLicenseNo" type="text" maxlength="32" class="shorttextfield" value="<%= vLicenseNo %>"
                                                size="26"></td>
                                        <td>
                                            <input name="txtECCN" type="text" maxlength="16" class="shorttextfield" value="<%= vECCN %>"
                                                size="13"></td>
                                    </tr>
                                    <tr align="left" valign="middle">
                                        <td width="45%" height="20">
                                            <strong>29. Duty Authorized Officer or Employee</strong></td>
                                        <td width="22%">
                                            &nbsp;</td>
                                        <td>
                                            &nbsp;</td>
                                    </tr>
                                    <tr align="left" valign="middle">
                                        <td bgcolor="#f0e7ef">
                                            <input name="txtDuly" type="text" class="shorttextfield" maxlength="32" value="<%= vDuly %>"
                                                size="26">
                                        </td>
                                        <td>
                                            &nbsp;</td>
                                        <td>
                                            &nbsp;</td>
                                    </tr>
                                    <tr align="left" valign="middle">
                                        <td colspan="3">
                                            <strong>30.</strong> I certify that all statements made all information contained
                                            herein are true and correct and that I have read and understand the instruction
                                            for preparation of this document, set forth in the &quot;Correct Way to Fill Out
                                            the Shipper's Export Declaration.&quot; I understand that civil and criminal penalties,
                                            including forfeiture and sale, may be imposed for marking false or fraudulent statements
                                            herein, failing or provide the requested information or for violation of U.S. laws
                                            on exportation (13 U.S.C.Sec. 401;18 U.S.C.Sec. 1001; 50 U.S.C. App. 2410).</td>
                                    </tr>
                                    <tr align="left" valign="middle">
                                        <td height="20" bgcolor="#f0e7ef">
                                            Signature</td>
                                        <td colspan="2">
                                            <strong>Confidential</strong> - For use solely for official purpose authorized by
                                            the Secretary of Commerce (13 U.S. C. 301(g))</td>
                                    </tr>
                                    <tr align="left" valign="middle">
                                        <td>
                                            <input name="txtSignature" type="text" class="shorttextfield" value="" size="26"></td>
                                        <td>
                                            &nbsp;</td>
                                        <td>
                                            &nbsp;</td>
                                    </tr>
                                    <tr align="left" valign="middle">
                                        <td height="20" bgcolor="#f0e7ef">
                                            Title</td>
                                        <td colspan="2">
                                            Export shipments are subject to inspection by U.S. Customs Service and/or Office
                                            of Export Enforcement.</td>
                                    </tr>
                                    <tr align="left" valign="middle">
                                        <td>
                                            <input name="txtTitle" type="text" class="shorttextfield" value="<%= vTitle %>" size="26"></td>
                                        <td>
                                            &nbsp;</td>
                                        <td>
                                            &nbsp;</td>
                                    </tr>
                                    <tr align="left" valign="middle">
                                        <td height="20" bgcolor="#f0e7ef">
                                            <strong><span class="bodyheader">
                                                <img src="/iff_main/ASP/Images/required.gif" align="absbottom"></span></strong>Date</td>
                                        <td colspan="2" bgcolor="#f0e7ef">
                                            <strong>31. Authentication</strong> (When Required)</td>
                                    </tr>
                                    <tr align="left" valign="middle">
                                        <td>
                                            <input name="txtTranDate" type="text" class="m_shorttextfield" preset="shortdate"
                                                value="<%= vTranDate %>" size="26"></td>
                                        <td colspan="2">
                                            <input name="T26" type="text" class="shorttextfield" size="26"></td>
                                    </tr>
                                    <tr align="left" valign="middle">
                                        <td height="20" bgcolor="#f0e7ef">
                                            Telephone No (Include Area Code)</td>
                                        <td colspan="2" bgcolor="#f0e7ef">
                                            E-mail Address</td>
                                    </tr>
                                    <tr align="left" valign="middle">
                                        <td>
                                            <input name="txtPhone" type="text" class="m_shorttextfield" preset="phone" value="<%= Replace(Replace(vPhone,"(",""),")","") %>"
                                                size="26"></td>
                                        <td colspan="2">
                                            <input name="txtEmail" type="text" class="shorttextfield" value="<%= vEmail %>" size="26"></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr align="left" valign="middle">
                            <td height="1" colspan="2" bgcolor="A0829C">
                            </td>
                        </tr>
                        <tr>
                            <td height="24" colspan="2" align="center" valign="middle" bgcolor="#E5D4E3">
                                <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="26%">
                                            &nbsp;</td>
                                        <td width="48%" align="center" valign="middle">
                                            <img src="../images/button_save_medium.gif" width="46" height="18" name="bSave" onclick="bSaveClick()"
                                                style="cursor: hand"></td>
                                        <td width="13%" align="right" valign="middle">
                                            <a href="/iff_main/ASP/air_export/sed.asp" target="_self">
                                                <img src="/iff_main/ASP/Images/button_new.gif" width="42" height="17" border="0"
                                                    style="cursor: hand"></a></td>
                                        <td width="13%" align="right" valign="middle">
                                            <img src="../images/button_delete_medium.gif" width="51" height="18" name="bDelete"
                                                onclick="DeleteSED()" style="cursor: hand"></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td height="32" align="right" valign="bottom">
                    <div id="print">
                        <img src="/iff_main/ASP/Images/icon_submit.gif" align="absbottom"><a href="javascript:;"
                            onclick="AESClick();return false;">Submit to AES Weblink</a><img src="/iff_main/ASP/Images/button_devider.gif"><a
                                href="/IFF_MAIN/ASPX/Misc/ManageSED.aspx">Manage AES</a><img src="/iff_main/ASP/Images/button_devider.gif"><a
                                    href="javascript:void(viewPop2('PopWin','http://www.aesdirect.gov'));">AES Direct
                                    Homepage</a><img src="/iff_main/ASP/Images/button_devider.gif"><a href="javascript:;"
                                        onclick="window.open('sed_help.html','aeshelp','width=460,height=300');return false;">AES
                                        Weblink Login Help</a>
                    </div>
                </td>
            </tr>
        </table>
        <br>
    </form>
</body>
<!--  #INCLUDE FILE="../include/print_query_shared.asp" -->

<script type="text/jscript">
function GET_SCHEDULE_B_AJAX()
{ 
var s = '<%=vShipperAcct%>';
if ( s == '' ){
	alert("Please select a shipper");
	return false;
}

var tIndex = '<%=tIndex%>';

	try
	{
		var xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP") 
		var param = 'n=' + encodeURIComponent(s) + '&e=' + '<%=elt_account_number%>';
		xmlHTTP.open("get","/IFF_MAIN/asp/include/get_schedule_b.asp?" + param ,false); 
		
		xmlHTTP.send(); 
		var sourceCode = xmlHTTP.responseText;
		var tmpSrc = null;

		if (sourceCode) 
		{

			for(i=0; i<=tIndex ;i++)
			{
				var oTd = document.getElementById( "scheduleTd" + i );
				var oSelect = document.getElementById( "lstBNumber" + i );
							
				var sv = oSelect.options[ oSelect.selectedIndex ].value;
				sv = sv.substring(0,sv.indexOf("^"));

				var tmpSrc = "<select name='lstBNumber" + i + "' size='1' class='smallselect' id='BNumber' style='WIDTH: 260px' onChange='SBChange(" + i + ")'>";
				tmpSrc = tmpSrc + sourceCode + "</select>";
				oTd.innerHTML = tmpSrc;

				oSelect = document.getElementById( "lstBNumber" + i );
				var items = oSelect.options;

				for( var k = 0; k < items.length; k++ ) {
					var item = items[k];
					while(item.value.indexOf("^") != -1) { item.value = item.value.replace('^',' ');	}	
				}

				for( var k = 0; k < items.length; k++ ) {
					var item = items[k];
					if( item.value.substring(0,item.value.indexOf("^")) == sv ) {
						oSelect.selectedIndex = k;
						SBChange(i);
						break;
					}
				}
				
			}
			return false;
		}
		else
		{
			return true;
		}
	}	
	catch(e) {}

return true;

}
</script>

<script language="javascript" type="text/javascript" src="../ajaxFunctions/ajax_ig_call_db.js">  </script>

<script type="text/vbscript">
<!---
Sub newScheduleB()
		sssindex=Document.form1.lstShipper.Selectedindex
		ShipperInfo=Document.form1.lstShipper.item(sssindex).value
		ShipperName=Document.form1.lstShipper.item(sssindex).Text
		pos=Instr(shipperInfo,chr(10))
		if pos>0 then
			ShipperAcct=Left(ShipperInfo,pos-1)
			ShipperInfo=Mid(ShipperInfo,pos+1,200)
		end if
		pos=Instr(shipperInfo,chr(10))
		if pos>0 then
			TaxID=Left(ShipperInfo,pos-1)
			ShipperInfo=Mid(ShipperInfo,pos+1,200)
		end if
		pos=Instr(shipperInfo,chr(10))
		if pos>0 then
			ContactLastName=Left(ShipperInfo,pos-1)
			ShipperInfo=Mid(ShipperInfo,pos+1,200)
		end if
		pos=Instr(shipperInfo,chr(10))
		if pos>0 then
			ContactFirstName=Left(ShipperInfo,pos-1)
			ShipperInfo=Mid(ShipperInfo,pos+1,200)
		end if
		props = "scrollBars=yes,resizable=yes,toolbar=no,menubar=no,location=no,directories=no,width=600,height=600"
		window.open "../../ASPX/Onlines/ScheduleB/ScheduleBCreate.aspx?ff="& ShipperAcct & "&nn=" & encodeURIComponent(ShipperName), "Dimension_Calculation", props
		GET_SCHEDULE_B_AJAX()
End Sub

Sub ShipperChange()
Dim sindex,ShipperInfo,ShipperName
sindex=Document.form1.lstShipper.Selectedindex

// by iMoon 3/7/2007
//ShipperInfo=Document.form1.lstShipper.item(sindex).value
//ShipperName=Document.form1.lstShipper.item(sindex).Text

ShipperInfo= get_organization_info_sed ( "../ajaxFunctions/ajax_get_org_address_info.asp?org=" _
    & encodeURIComponent(Document.form1.lstShipper.item(sindex).value) & "&type=sed_s" )

pos=Instr(ShipperInfo,"@@@")
if pos>0 then
	ShipperName=Left(ShipperInfo,pos-1)
	ShipperInfo=Mid(ShipperInfo,pos+3)
end if

pos=Instr(shipperInfo,chr(10))
if pos>0 then
	ShipperAcct=Left(ShipperInfo,pos-1)
	ShipperInfo=Mid(ShipperInfo,pos+1,200)
end if
pos=Instr(shipperInfo,chr(10))
if pos>0 then
	TaxID=Left(ShipperInfo,pos-1)
	ShipperInfo=Mid(ShipperInfo,pos+1,200)
end if
pos=Instr(shipperInfo,chr(10))
if pos>0 then
	ContactLastName=Left(ShipperInfo,pos-1)
	ShipperInfo=Mid(ShipperInfo,pos+1,200)
end if
pos=Instr(shipperInfo,chr(10))
if pos>0 then
	ContactFirstName=Left(ShipperInfo,pos-1)
	ShipperInfo=Mid(ShipperInfo,pos+1,200)
end if
document.form1.hShipper.Value=ShipperName
document.form1.txtUSPPI.Value=ShipperInfo

document.form1.hShipperAcct.Value=ShipperAcct

document.form1.txtTaxID.value=TaxID
document.form1.hContactLastName.value=ContactLastName
document.form1.hContactFirstName.value=ContactFirstName

//'//////////////////////
//'// by ig 08/09/2005
//'//////////////////////

document.form1.action="sed.asp?ShipperAcct=" & ShipperAcct & "&HAWB=" _
    & encodeURIComponent("<%= vHAWB %>") & "&WindowName=" & window.name 
document.form1.method="POST"
document.form1.target = "_self"
form1.submit()


End Sub

Sub ConsigneeChange()
Dim sindex,ConsigneeInfo,ConsigneeName
sindex=Document.form1.lstConsignee.Selectedindex

// by iMoon 3/7/2007
//ConsigneeInfo=Document.form1.lstConsignee.item(sindex).value
//ConsigneeName=Document.form1.lstConsignee.item(sindex).Text

ConsigneeInfo= get_organization_info_sed ( "../ajaxFunctions/ajax_get_org_address_info.asp?org=" _
    & encodeURIComponent(Document.form1.lstConsignee.item(sindex).value) & "&type=sed_c" )

pos=Instr(ConsigneeInfo,"@@@")
if pos>0 then
	ConsigneeName=Left(ConsigneeInfo,pos-1)
	ConsigneeInfo=Mid(ConsigneeInfo,pos+3)
end if

pos=Instr(ConsigneeInfo,"-")
if pos>0 then
	ConsigneeCountryCode=Left(ConsigneeInfo,pos-1)
	ConsigneeInfo=Mid(ConsigneeInfo,pos+1,200)
end if
pos=Instr(ConsigneeInfo,"-")
if pos>0 then
	ConsigneeAcct=Left(ConsigneeInfo,pos-1)
	ConsigneeInfo=Mid(ConsigneeInfo,pos+1,200)
end if
document.form1.hConsignee.Value=ConsigneeName
document.form1.txtUltiConsignee.Value=ConsigneeInfo
document.form1.hConsigneeAcct.Value=ConsigneeAcct
document.form1.hConsigneeCountryCode.Value=ConsigneeCountryCode

End Sub

Sub SBChange(ItemNo)
Dim sssindex,ShipperInfo,ShipperName
sssindex=Document.form1.lstShipper.Selectedindex
if sssindex = 0 then
	msgbox "Please select a shipper"
else

	sIndex=document.all("BNumber").item(ItemNo+1).selectedindex
	if sIndex=1 then

        ShipperInfo= get_organization_info_sed ( "../ajaxFunctions/ajax_get_org_address_info.asp?org=" _
            & encodeURIComponent(Document.form1.lstShipper.item(sssindex).value) & "&type=sed_s" )

        pos=Instr(ShipperInfo,"@@@")
        if pos>0 then
	        ShipperName=Left(ShipperInfo,pos-1)
	        ShipperInfo=Mid(ShipperInfo,pos+3)
        end if

        pos=Instr(shipperInfo,chr(10))
        if pos>0 then
	        ShipperAcct=Left(ShipperInfo,pos-1)
	        ShipperInfo=Mid(ShipperInfo,pos+1,200)
        end if
        pos=Instr(shipperInfo,chr(10))
        if pos>0 then
	        TaxID=Left(ShipperInfo,pos-1)
	        ShipperInfo=Mid(ShipperInfo,pos+1,200)
        end if
        pos=Instr(shipperInfo,chr(10))
        if pos>0 then
	        ContactLastName=Left(ShipperInfo,pos-1)
	        ShipperInfo=Mid(ShipperInfo,pos+1,200)
        end if
        pos=Instr(shipperInfo,chr(10))
        if pos>0 then
	        ContactFirstName=Left(ShipperInfo,pos-1)
	        ShipperInfo=Mid(ShipperInfo,pos+1,200)
        end if

		document.form1.hShipper.Value=ShipperName
		document.form1.txtUSPPI.Value=ShipperInfo
		document.form1.hShipperAcct.Value=ShipperAcct
		document.form1.txtTaxID.value=TaxID
		document.form1.hContactLastName.value=ContactLastName
		document.form1.hContactFirstName.value=ContactFirstName

        props = "scrollBars=yes,resizable=yes,toolbar=no,menubar=no,location=no,directories=no,width=600,height=600"
        window.open "../../ASPX/Onlines/ScheduleB/ScheduleBCreate.aspx?ff=" & ShipperAcct & "&nn=" & encodeURIComponent(ShipperName), "Dimension_Calculation", props

	elseif sIndex>1 then

		sInfo=document.all("BNumber").item(ItemNo+1).item(sIndex).Value

		pos=0
		pos=instr(sInfo,"^")
		if pos>0 then
			sInfo=Mid(sInfo,pos+1,100)
		end if
		pos=instr(sInfo,"^")
		if pos>0 then
			sInfo=Mid(sInfo,pos+1,100)
		end if
		pos=instr(sInfo,"^")

		if pos>0 then
			Unit1=Mid(sInfo,1,pos-1)
			Unit2=Mid(sInfo,pos+1,100)
		end if

		Unit1 = Replace(Unit1,"^","")
		Unit2 = Replace(Unit2,"^","")
		document.all("Unit1").item(ItemNo+1).Value=Unit1
		document.all("Unit2").item(ItemNo+1).Value=Unit2
	end if
end if 
End Sub

Sub bsaveclick()
OK=True
    If document.form1.lstShipper.options.selectedIndex <= 0 Then
        MsgBox "Please select the name of shipper!"
        document.getElementById("txtUSPPI").focus
		exit sub
	Elseif Not IsDate(document.form1.txtExportDate.Value) then
		MsgBox "Please enter a Export Date in (MM/DD/YYYY) format!"
		document.form1.txtExportDate.focus
		exit sub
	Elseif document.form1.lstConsignee.options.selectedIndex <= 0 Then
        MsgBox "Please select the name of consignee!"
		document.form1.txtUltiConsignee.focus
		exit sub
	Elseif Not IsDate(document.form1.txtTranDate.Value) then
		MsgBox "Please enter a Date in (MM/DD/YYYY) format!"
		document.form1.txtTranDate.focus
		exit sub
    Elseif Not document.form1.txtZipCode.Value="" And Not IsNumeric(document.form1.txtZipCode.Value) then
		MsgBox "Please enter a numeric value for ZIP CODE!"
 	    document.form1.txtZipCode.focus
		exit sub
    Elseif document.form1.txtShipmentRefNo.Value = "" then
		MsgBox "Please enter shipment reference number!"
		document.form1.txtShipmentRefNo.focus
		exit sub
	Else
		NoItem=CInt(document.form1.hNoItem.Value)
		for i=1 to NoItem
			sindex=cint(document.all("BNumber").item(i).selectedindex)
			if sindex=0 or sindex=1 then
				if document.all("BQty1").item(i).Value <> "" and document.all("BQty1").item(i).Value <> "0" then
					MsgBox "Please select a Schedule B Number!"
					OK=False
					Exit for
				end if
			end if
			if Not document.all("BQty1").item(i).Value="" and Not IsNumeric(document.all("BQty1").item(i).Value) then
				MsgBox "Please enter a numeric value for Schedule B Qty!"
				OK=False
				Exit for
			end if
			if Not document.all("BQty2").item(i).Value="" and Not IsNumeric(document.all("BQty2").item(i).Value) then
				MsgBox "Please enter a numeric value for Schedule B Qty!"
				OK=False
				Exit for
			end if
			if document.all("GrossWeight").item(i).Value <> "" and Not IsNumeric(document.all("GrossWeight").item(i).Value) then
				MsgBox "Please enter a numeric value for Schedule B Gross Weight!"
				OK=False
				Exit for
			end if
			if document.all("Value").item(i).Value <> "" and Not IsNumeric(document.all("Value").item(i).Value) then
				MsgBox "Please enter a numeric value for Schedule B Value!"
				OK=False
				Exit for
			end if
		next
		if OK=True then
			document.form1.action="sed.asp?save=yes" & "&HAWB=" _
			    & encodeURIComponent("<%= vHAWB %>") & "&WindowName=" & window.name 
			document.form1.method="POST"
			document.form1.target = "_self"			
			form1.submit()
		end if
	end if
End Sub

Sub DeleteSED()
    If document.form1.hSEDNo.value <> "" Then
	    ok=MsgBox ("Are you sure you want to delete this?", 36, "Message")
	    if ok=6 then	
		    document.form1.action="sed.asp?DeleteSED=yes" & "&HAWB=" & encodeURIComponent(vHAWB) & "&WindowName=" & window.name 
		    document.form1.method="POST"
		    document.form1.target = "_self"
		    form1.submit()
	    end if
    end if
End Sub

Sub RelatedClick()
    If document.form1.cRelated.checked=FAlse then
	    document.form1.cRelated.VALUE="N"
	    document.form1.cNonRelated.checked=true
	    document.form1.cNonRelated.Value="Y"
    ELSE
	    document.form1.cRelated.VALUE="Y"
	    document.form1.cNonRelated.checked=FAlse
	    document.form1.cNonRelated.VALUE="N"
    END IF
end sub

Sub NonRelatedClick()
    If document.form1.cNonRelated.checked=FAlse then
	    document.form1.cNonRelated.VALUE="N"
	    document.form1.cRelated.checked=true
	    document.form1.cRelated.Value="Y"
    ELSE
	    document.form1.cNonRelated.VALUE="Y"
	    document.form1.cRelated.checked=FAlse
	    document.form1.cRelated.VALUE="N"
    END IF
End Sub

Sub ConYes()
    If document.form1.cConYes.checked=FAlse then
	    document.form1.cConYes.VALUE="N"
	    document.form1.cConNo.checked=true
	    document.form1.cConNo.Value="Y"
    ELSE
	    document.form1.cConYes.VALUE="Y"
	    document.form1.cConNo.checked=FAlse
	    document.form1.cConNo.VALUE="N"
    END IF
end sub

Sub ConNo()
    If document.form1.cConNo.checked=FAlse then
	    document.form1.cConNo.VALUE="N"
	    document.form1.cConYes.checked=true
	    document.form1.cConYes.Value="Y"
    ELSE
	    document.form1.cConNo.VALUE="Y"
	    document.form1.cConYes.checked=FAlse
	    document.form1.cConYes.VALUE="N"
    END IF
end sub

Sub HazYes()
    If document.form1.cHazYes.checked=FAlse then
	    document.form1.cHazYes.VALUE="N"
	    document.form1.cHazNo.checked=true
	    document.form1.cHazNo.Value="Y"
    ELSE
	    document.form1.cHazYes.VALUE="Y"
	    document.form1.cHazNo.checked=FAlse
	    document.form1.cHazNo.VALUE="N"
    END IF
end sub
Sub HazNo()
    If document.form1.cHazNo.checked=FAlse then
	    document.form1.cHazNo.VALUE="N"
	    document.form1.cHazYes.checked=true
	    document.form1.cHazYes.Value="Y"
    ELSE
	    document.form1.cHazNo.VALUE="Y"
	    document.form1.cHazYes.checked=FAlse
	    document.form1.cHazYes.VALUE="N"
    END IF
end sub

Sub RouteYes()
    If document.form1.cRouteYes.checked=FAlse then
	    document.form1.cRouteYes.VALUE="N"
	    document.form1.cRouteNo.checked=true
	    document.form1.cRouteNo.Value="Y"
    ELSE
	    document.form1.cRouteYes.VALUE="Y"
	    document.form1.cRouteNo.checked=FAlse
	    document.form1.cRouteNo.VALUE="N"
    END IF
end sub

Sub RouteNo()
    If document.form1.cRouteNo.checked=FAlse then
	    document.form1.cRouteNo.VALUE="N"
	    document.form1.cRouteYes.checked=true
	    document.form1.cRouteYes.Value="Y"
    ELSE
	    document.form1.cRouteNo.VALUE="Y"
	    document.form1.cRouteYes.checked=FAlse
	    document.form1.cRouteYes.VALUE="N"
    END IF
end sub

Function CheckNullToZero(FormValue)
    if not isnull(FormValue) or trim(FormValue)="" then
        CheckNullToZero=0
    else
        CheckNullToZero=FormValue
    end if    
End Function

Sub AddItem()
	document.form1.hNoItem.Value=CInt(document.form1.hNoItem.Value)+1
	document.form1.action="sed.asp?AddItem=yes" & "&HAWB=" & encodeURIComponent("<%= vHAWB %>") & "&WindowName=" & window.name 
	document.form1.method="POST"
	document.form1.target = "_self"
	form1.submit()
End Sub

Sub DeleteItem(ItemNo)
	if document.form1.hNoItem.Value>0 then
		document.form1.action="sed.asp?DeleteItem=yes&ItemNo=" & ItemNo & "&HAWB=" & encodeURIComponent("<%= vHAWB %>") & "&WindowName=" & window.name 
		document.form1.method="POST"
		document.form1.target = "_self"
		form1.submit()
	end if
End Sub

Sub PrintForm()

    Dim vPrintPort
    vPrintPort = queryPort( "<%=sedPort%>", "<%=sedQueue%>" )
    if( vPrintPort = "-1" ) then exit sub

    Dim vShipperInfo,Shipper(4),vShipperTaxID,vZipCode,vRelated
    Dim vExportDate,vTranRefNo,vUltiConsignee,UltiConsignee(3)
    Dim vInterConsignee,InterConsignee(3),vForwardAgent,Agent(4)
    Dim vOriginState,vDestCountry,vLoadingPier,vMOT
    Dim vExportCarrier,vExportPort,vUnloadingPort,vConYes
    Dim vCarrierIDCode,vShipmentRefNo,vEntryNo,vHazYes
    Dim vIBT,vRouteYes
    Dim vLicenseNo,vECCN
    Dim Save,EditSED,vHAWB,AddItem,DeleteItem
    Dim aDFM(10),aBNumber(10),aBQty(10),aGrossWeight(10),aVIN(10),aValue(10)

    Dim fso, MyFile
    Dim pTop,pLeft

    vShipperInfo=document.form1.txtUSPPI.value
    pos=Instr(vShipperInfo,chr(10))
    i=0
    do While pos>0 And i<3
	    Shipper(i)=Left(vShipperInfo,pos-2)
	    if Len(Shipper(i))>35 then
		    tShipper=Shipper(i)
		    Shipper(i)=Mid(tShipper,1,35)
		    i=i+1
		    Shipper(i)=Mid(tShipper,36,100)
	    end if
	    vShipperInfo=Mid(vShipperInfo,pos+1,2000)
	    pos=Instr(vShipperInfo,chr(10))
	    i=i+1
    loop
    Shipper(i)=vShipperInfo
    //'vZipCode=document.form1.txtZipCode.Value
    vZipCode=""
    vShipperTaxID=document.form1.txtTaxID.Value
    vRelated=document.form1.cRelated.Value
    if vRelated="Y" then
	    vRelatedYes="X"
	    vRelatedNo=""
    else
	    vRelatedYes=""
	    vRelatedNo="X"
    end if
    vUltiConsignee=document.form1.txtUltiConsignee.value
    pos=Instr(vUltiConsignee,chr(10))
    i=0
    do While pos>0 And i<3
	    UltiConsignee(i)=Left(vUltiConsignee,pos-2)
    //	'if Len(UltiConsignee(i))>35 then
    //	'	tUltiConsignee=UltiConsignee(i)
    //	'	UltiConsignee(i)=Mid(tUltiConsignee,1,35)
    //	'	i=i+1
    //	'	UltiConsignee(i)=Mid(tUltiConsignee,36,100)
    //	'end if
	    vUltiConsignee=Mid(vUltiConsignee,pos+1,2000)
	    pos=Instr(vUltiConsignee,chr(10))
	    i=i+1
    loop
    UltiConsignee(i)=vUltiConsignee
    vInterConsignee=document.form1.txtInterConsignee.value
    pos=Instr(vInterConsignee,chr(10))
    i=0
    do While pos>0 And i<2
	    InterConsignee(i)=Left(vInterConsignee,pos-2)
	    if Len(InterConsignee(i))>35 then
		    tInterConsignee=InterConsignee(i)
		    InterConsignee(i)=Mid(tInterConsignee,1,35)
		    i=i+1
		    InterConsignee(i)=Mid(tInterConsignee,36,100)
	    end if
	    vInterConsignee=Mid(vInterConsignee,pos+1,2000)
	    pos=Instr(vInterConsignee,chr(10))
	    i=i+1
    loop
    InterConsignee(i)=vInterConsignee
    vAgentInfo=document.form1.txtForwardAgent.value
    pos=Instr(vAgentInfo,chr(10))
    i=0
    do While pos>0 And i<3
	    Agent(i)=Left(vAgentInfo,pos-2)
	    if Len(Agent(i))>35 then
		    tAgent=Agent(i)
		    Agent(i)=Mid(tAgent,1,35)
		    i=i+1
		    Agent(i)=Mid(tAgent,36,100)
	    end if
	    vAgentInfo=Mid(vAgentInfo,pos+1,2000)
	    pos=Instr(vAgentInfo,chr(10))
	    i=i+1
    loop
    Agent(i)=vAgentInfo
    vExportDate=document.form1.txtExportDate.Value
    vTranRefNo=document.form1.txtTranRefNo.Value
    pos=0
    pos=instr(vTranRefNo,",")
    if pos>0 then
	    vTranRefNo1=Mid(vTranRefNo,1,pos-1)
	    vTranRefNo2=Mid(vTranRefNo,pos+1,100)
    else
	    vTranRefNo1=vTranRefNo
    end if
    vOriginState=document.form1.txtOriginState.Value
    vDestCountry=document.form1.txtDestCountry.Value
    vLoadingPier=document.form1.txtLoadingPier.Value
    vLoadingPier=Mid(vLoadingPier,1,17)
    vMOT=document.form1.lstMOT.item(document.form1.lstMOT.selectedindex).Text
    vMOT=Mid(vMOT,1,17)
    vExportCarrier=document.form1.txtExportCarrier.Value
    vExportCarrier=Mid(vExportCarrier,1,17)
    vExportPort=document.form1.txtExportPort.Value
    vExportPort=Mid(vExportPort,1,17)
    vUnloadingPort=document.form1.txtUnloadingPort.Value
    vUnloadingPort=Mid(vUnloadingPort,1,17)
    vConYes=document.form1.cConYes.Value
    if vConYes="Y" then
	    vConYes="X"
	    vConNo=""
    else
	    vConYes=""
	    vConNo="X"
    end if
    vCarrierIDCode=document.form1.txtCarrierIDCode.Value
    vShipmentRefNo=document.form1.txtShipmentRefNo.Value
    vEntryNo=document.form1.txtEntryNo.Value
    vHazYes=document.form1.cHazYes.Value
    if vHazYes="Y" then
	    vHazYes="X"
	    vHazNo=""
    else
	    vHazYes=""
	    vHazNo="X"
    end if
    vIBT=document.form1.lstIBT.item(document.form1.lstIBT.selectedindex).Text
    vIBT=Mid(vIBT,1,15)
    vRouteYes=document.form1.cRouteYes.Value
    if vRouteYes="Y" then
	    vRouteYes="X"
	    vRouteNo=""
    else
	    vRouteYes=""
	    vRouteNo="X"
    end if
    NoItem=cInt(document.form1.hNoItem.Value)
    for i=1 to NoItem
	    aDFM(i-1)=document.all("DFM").item(i).Value
	    aBNumber(i-1)=document.all("BNumber").item(i).Value
	    pos=0
	    pos=instr(aBNumber(i-1),"^")
	    if pos>0 then
		    aBNumber(i-1)=Mid(aBNumber(i-1),1,pos-1)
	    end if
	    aBQty(i-1)=document.all("BQty1").item(i).Value
	    aGrossWeight(i-1)=document.all("GrossWeight").item(i).Value
	    aVIN(i-1)=document.all("VIN").item(i).Value
	    aValue(i-1)=document.all("Value").item(i).Value
    next
    vLicenseNo=document.form1.txtLicenseNo.Value
    vECCN=document.form1.txtECCN.Value
    vDuly=document.form1.txtDuly.Value
    vTitle=document.form1.txtTitle.Value
    vTranDate=document.form1.txtTranDate.Value
    vPhone=document.form1.txtPhone.Value
    vEmail=document.form1.txtEmail.Value

    Set fso = CreateObject("Scripting.FileSystemObject")
    FileName="C:\TEMP\EltData\SED.txt"
    If Not fso.FolderExists("C:\TEMP") Then
	    Set f = fso.CreateFolder("C:\TEMP")
    End If
    If Not fso.FolderExists("C:\TEMP\Eltdata") Then
	    Set f = fso.CreateFolder("C:\TEMP\Eltdata")
    End If
    Set MyFile = fso.CreateTextFile(FileName, True)

    ///////////////////////////////////////////////
    DIM  C__10CPI, C__12CPI
    // Epson FX
    C__10CPI = chr(27) & chr(80) 
    C__12CPI = chr(27) & chr(77) 

    // IBM Propringter III
    //C__10CPI = chr(27) & chr(18) 
    //C__12CPI = chr(27) & chr(58)

    // Oki Data MICROLINE
    //C__10CPI = chr(30) 
    //C__12CPI = chr(28)
    ///////////////////////////////////////////////

    MyFile.WriteLine(chr(27) & chr(67) & chr(66))
    Dim Line(66)
    pTop=0
    pLeft=6
    for i=1 to pTop
	    MyFile.WriteLine("")
    next 
    Line(1)=""
    Line(2)=""
    Line(3)=Space(pLeft) & Shipper(0)
    Line(4)=Space(pLeft) & Shipper(1)
    Line(5)=Space(pLeft) & Shipper(2)

    If (len(Line(5)) >= 33) then
	    Line(5)=  Mid(Shipper(2),1,32)
    End If

    Line(5)=Line(5) & Space(33-len(Line(5))) & vZipCode

    Line(5)=Line(5) & Space(40-len(Line(5))) & vExportDate
    Line(5)=Line(5) & Space(58-len(Line(5))) & vTranRefNo1
    Line(6)=Space(pLeft) & Space(52) & vTranRefNo2
    Line(7)=Space(pLeft) & vShipperTaxID
    If (len(Line(7)) >= 24) then
	    Line(7)= vShipperTaxID
    End If

    Line(7)=Line(7) & Space(24-len(Line(7))) & vRelatedYes
    Line(7)=Line(7) & Space(30-len(Line(7))) & vRelatedNo
    Line(8)=""
    Line(9)=Space(pLeft) & UltiConsignee(0)
    Line(10)=Space(pLeft) & UltiConsignee(1)
    Line(11)=Space(pLeft) & UltiConsignee(2)
    Line(12)=Space(pLeft) & InterConsignee(0)
    Line(13)=Space(pLeft) & InterConsignee(1)
    Line(14)=""
    Line(15)=Space(pLeft) & Agent(0)
    Line(16)=Space(pLeft) & Agent(1)
    Line(17)=Space(pLeft) & Agent(2)
    If (len(Line(17)) >= 40) then
	    Line(17)= Agent(2)
    End If

    Line(17)=Line(17) & Space(40-len(Line(17))) & vOriginState
    Line(17)=Line(17) & Space(58-len(Line(17))) & vDestCountry
    Line(18)=""
    Line(19)=Space(pLeft) & vLoadingPier
    Line(19)=Space(pLeft) & vLoadingPier
    If (len(Line(19)) >= 23) then
	    Line(19)= vLoadingPier
    End If

    Line(19)=Line(19) & Space(23-len(Line(19))) & vMOT
    Line(19)=Line(19) & Space(40-len(Line(19))) & vCarrierIDCode
    Line(19)=Line(19) & Space(58-len(Line(19))) & vShipmentRefNo
    Line(20)=""
    Line(21)=Space(pLeft) & Mid(vExportCarrier,1,15)
    If (len(Line(21)) >= 22) then
	    Line(21)= Mid(vExportCarrier,1,15)
    End If

    Line(21)=Line(21) & Space(22-len(Line(21))) & vExportPort
    Line(21)=Line(21) & Space(40-len(Line(21))) & vEntryNo
    Line(21)=Line(21) & Space(60-len(Line(21))) & vHazYes
    Line(21)=Line(21) & Space(66-len(Line(21))) & vHazNo
    Line(22)=""
    Line(23)=Space(pLeft) & vUnloadingPort
    If (len(Line(23)) >= 24) then
	    Line(23)= vUnloadingPort
    End If

    if vIBT = "Select One" then vIBT = ""

    Line(23)=Line(23) & Space(24-len(Line(23))) & vConYes
    Line(23)=Line(23) & Space(30-len(Line(23))) & vConNo
    Line(23)=Line(23) & Space(40-len(Line(23))) & vIBT
    Line(23)=Line(23) & Space(60-len(Line(23))) & vRouteYes
    Line(23)=Line(23) & Space(66-len(Line(23))) & vRouteNo
    for i=24 to 30
	    Line(i)=""
    Next

    for i=0 to 9
	    Line(31+i)=Space(pLeft-2) & aDFM(i)
	    Line(31+i)=Line(31+i) & Space(7 -len(Line(31+i))) & aBNumber(i)
	    Line(31+i)=Line(31+i) & Space(38-len(Line(31+i))) & aBQty(i)
	    Line(31+i)=Line(31+i) & Space(47-len(Line(31+i))) & aGrossWeight(i)
	    Line(31+i)=Line(31+i) & Space(51-len(Line(31+i))) & aVIN(i)
	    Line(31+i)=Line(31+i) & Space(70-len(Line(31+i))) & aValue(i)
	    Line(31+i)= C__12CPI & Line(31+i) & C__10CPI
    next
    for i=41 to 48
	    Line(i)=""
    next
    Line(49)=Space(pLeft) & vLicenseNo
    Line(49)=Line(49) & Space(32 -len(Line(49))) & vECCN
    Line(50)=""
    Line(51)=Space(pLeft) & vDuly
    Line(57)=Space(pLeft) & vTitle
    Line(58)=Space(pLeft) & vTranDate
    Line(60)=Space(pLeft) & vPhone
    Line(60)=Line(60) & Space(26-Len(Line(60))) & vEmail


    ClientOS=document.form1.hClientOS.Value
    If ClientOS="NT" then
	    tLine=64
    else
	    tLine=65
    end if
    For i=1 to tLine
	    MyFile.WriteLine(Line(i))
    next

    MyFile.Close
    Set MyFile=Nothing

    DIM tmpPort

    tmpPort = TRIM(UCASE(vPrintPort))

    if tmpPort = "LPT1" or tmpPort = "LPT2" or tmpPort = "LPT3" or tmpPort = "LPT4" or tmpPort = "LPT5" _ 
    or tmpPort = "LPT6" or tmpPort = "LPT7" or tmpPort = "LPT8" then
	    Call ELTClient.ELTPrintForm(FileName,vPrintPort)
    else
	    Call ELTClient.ELTPrintFormWithNetwork(FileName,vPrintPort)
    end if

    Sleep 2
    // LPT9 port init
    Call ELTClient.ELTPrintPortInit()

end Sub

Sub Sleep(tmpSeconds)
    Dim dtmOne,dtmTwo
    dtmOne = Now()
    While DateDiff("s",dtmOne,dtmTwo) < tmpSeconds
	    dtmTwo = Now()
    Wend
End Sub

Sub AESClick()
    If document.form1.hSEDNo.value = "" Then
        MsgBox "Please, save the form first!"
        Exit Sub
    Else
        jPopUpNormalforSED()
        document.AES.action="https://aesdirect.census.gov/weblink/weblink.cgi" 
        document.AES.method="POST"
        document.AES.target="popUpSED"
        AES.submit()
    End If
End Sub

Sub MenuMouseOver()
End Sub
Sub MenuMouseOut()
End Sub
--->
</script>

</html>
