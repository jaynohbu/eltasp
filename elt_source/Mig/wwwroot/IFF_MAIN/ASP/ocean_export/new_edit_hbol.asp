<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_Util_Ver_2.inc" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/GOOFY_Util_Ver_2.inc" -->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>New/Edit HBOL</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <base target="_self" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <style type="text/css">

    .style2 {
	    color: #cc6600;
	    font-weight: bold;
    }
    .style6 {color: #cc6600}
    body {
	    margin-left: 0px;
	    margin-right: 0px;
	    margin-bottom: 0px;
    }
    .style10 {color: #663366}
    .style11 {color: #CC9900}
    .style12 {color: #0099FF}
    .style14 {color: #CC0000}

    </style>

    <script type="text/javascript" src="../include/JPED.js"></script>

    <script type="text/jscript" src="../ajaxFunctions/ajax.js"></script>

    <script type="text/jscript">
    function lstShipperNameChange(orgNum,orgName)
    {
        var hiddenObj = document.getElementById("hShipperAcct");
        var infoObj = document.getElementById("txtShipperInfo");
        var txtObj = document.getElementById("lstShipperName");
        var divObj = document.getElementById("lstShipperNameDiv")

        hiddenObj.value = orgNum;
        infoObj.value = getOrganizationInfo(orgNum);
        txtObj.value = orgName;

        divObj.style.position = "absolute";
        divObj.style.visibility = "hidden";
    }
    
    function lstConsigneeNameChange(orgNum,orgName)
    {
        var hiddenObj = document.getElementById("hConsigneeAcct");
        var infoObj = document.getElementById("txtConsigneeInfo");
        var txtObj = document.getElementById("lstConsigneeName");
        var divObj = document.getElementById("lstConsigneeNameDiv");

        hiddenObj.value = orgNum;
        infoObj.value = getOrganizationInfo(orgNum);
        txtObj.value = orgName;
        
        divObj.style.position = "absolute";
        divObj.style.visibility = "hidden";
	    lstNotifyNameChange(orgNum,orgName);
    }
    
    function lstNotifyNameChange(orgNum,orgName)
    {
        var hiddenObj = document.getElementById("hNotifyAcct");
        var infoObj = document.getElementById("txtNotifyInfo");
        var txtObj = document.getElementById("lstNotifyName");
        var divObj = document.getElementById("lstNotifyNameDiv")

        hiddenObj.value = orgNum;
        infoObj.value = getOrganizationInfo(orgNum);
        txtObj.value = orgName;
        divObj.style.visibility = "hidden";
        divObj.style.position = "absolute";
    }
    function lstFFAgentChange(orgNum,orgName)
    {
        var hiddenObj = document.getElementById("hFFAgentAcct");
        var txtObj = document.getElementById("lstFFAgent");
        var divObj = document.getElementById("lstFFAgentDiv");
        var infoObj = document.getElementById("hFFAgentInfo");

        hiddenObj.value = orgNum;
        txtObj.value = orgName;
        infoObj.value = getOrganizationInfo(orgNum);
        
        divObj.style.position = "absolute";
        divObj.style.visibility = "hidden";
        document.getElementById("txtExportInstr").value = infoObj.value;
    }
    function getOrganizationInfo(orgNum)
    {
        if (window.ActiveXObject) {
            try {
                xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
            } catch(error) {
                try {
                    xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
                } catch(error) { return ""; }
            }
        } 
        else if (window.XMLHttpRequest) {
            xmlHTTP = new XMLHttpRequest();
        } 
        else { return ""; }

        var url = "../ajaxFunctions/ajax_get_org_address_info.asp?type=B&org=" + orgNum;
    
        xmlHTTP.open("GET",url,false); 
        xmlHTTP.send(); 
        
        return (xmlHTTP.responseText); 
    }
    
    function searchNumFill(obj,eType,changeFunction,vHeight){
            var qStr = obj.value;
            var keyCode = window.event.keyCode;
            var url;

            if(qStr != "" && keyCode != 229 && keyCode != 27){
                url = "/IFF_MAIN/asp/ajaxFunctions/ajax_get_bills.asp?mode=list&export=O&qStr=" 
                    + qStr + "&type=master";
                FillOutJPED(obj,url,changeFunction,vHeight);
            }
        }
        
    function searchNumFillAll(objName,eType,changeFunction,vHeight){
        var obj = document.getElementById(objName);
        var url;
            
        url = "/IFF_MAIN/asp/ajaxFunctions/ajax_get_bills.asp?mode=list&type=master&export=O";
        FillOutJPED(obj,url,changeFunction,vHeight);
    }
    
    function lstSearchNumChange(argV,argL){
        var divObj = document.getElementById("lstSearchNumDiv");
        document.getElementById("hSearchNum").value = argV;
        document.getElementById("lstSearchNum").value = argL;
        BookingChange();
        divObj.style.position = "absolute";
        divObj.style.visibility = "hidden";
    }
    function EditClick(HAWB,MAWB){
        url ="/IFF_MAIN/ASPX/Misc/EditOceanAES.aspx?AESID=&HAWB="+encodeURIComponent(HAWB)+"&MAWB="+encodeURIComponent(MAWB) + "&WindowName=popUpWindow";
        openWindowFromSearch(url);
    }

    function openWindowFromSearch(url){
        window.open(url, "popUpWindow", "menubar=0,toolbar=0,hotkeys=1,status=1,location=0,scrollbars=1,resizable=1,width=900,height=600");
    }
    </script>

</head>
<!--  #INCLUDE FILE="../include/header.asp" -->

<script type="text/javascript">

    function validateSalesRep(){

         var txtSalesRep=document.getElementById("txtSalesRep");
         var salesRep=txtSalesRep.value;
         if(salesRep!=""){       
            return true;
         }else{
            return false;
        }
    }
   
    function docModified(arg){}
    
    function SetCostItems(){
        var vURL = "./new_edit_hbol_cost_items.asp?HBOL=" + encodeURIComponent(document.getElementById("txtHBOL").value);
        var vWinArg = "dialogWidth:600px; dialogHeight:400px; help:no; status:no; scroll:yes; center:yes";
        var vReturn = showModalDialog(vURL, "popWindow", vWinArg);
    }
    
    function SetCreditNote(){
        var vWinArg = "dialogWidth:600px; dialogHeight:400px; help:no; status:no; scroll:yes; center:yes";
        var vReturn = showModalDialog("../acct_tasks/credit_note_list.asp?TYPE=O&BOOK=" + encodeURIComponent(document.getElementById("hSearchNum").value)+ "&HBOL=" + encodeURIComponent(document.getElementById("txtHBOL").value), "popWindow", vWinArg);
        
        if(vReturn >= 0){
            try{parent.document.frames['topFrame'].changeTopModule("Accounting");}catch(err){}
            if(vReturn == 0){
                window.location.href = "../acct_tasks/edit_credit_note.asp?new=yes&MoveType=OCEAN&MasterOnly=N&InvType=Agent&AgentID=" + document.getElementById("hFFAgentAcct").value + "&BookingNum=" + encodeURIComponent(document.getElementById("hSearchNum").value)+ "&HBOL=" + encodeURIComponent(document.getElementById("txtHBOL").value);
            }
            else{
                window.location.href = "../acct_tasks/edit_credit_note.asp?edit=yes&InvoiceNo=" + vReturn;
            }
        }
    }

</script>

<script language="javascript" type="text/javascript" src="../ajaxFunctions/ajax.js"> </script>

<%
'/////////////////// FOR SUB MODULE //////////////////////////////////////////
'------------FOR SUB MASTER ONLY--------------------------------
dim vectAVGrossWeightTotal,vectAVMeasurementTotal,vectAVDimensionTotal,vectAVChargeableWeightTotal,vectAVPieceTotal,AVIndex,vectAVGWLBTotal,vectAVMCFTTotal
dim vectAVELTAcct(1024)
dim vectAVAgents(1024)			
dim vectAVShippers(1024)	
dim vectAVConsignees(1024)

dim vectAVHAWBs(1024)
dim vectAVPiece(1024)
dim vectAVGrossWeight(1024)		
dim vectAVMeasurement(1024)	
dim vectAVGWLB(1024)			
dim vectAVMCFT(1024)		
dim vectAVBookingNum(1024)
'------------FOR SUB MASTER ONLY--------------------------------

dim  aColo, aIsInvoiceQueued,bIndex
DIM vDefaultShipperIndex
dim  vCanbeMaster
vCanbeMaster=true
DIM RemoveSH,rSHAWB,rELTACT
DIM aShippers,aConsignees,aAgents
DIM AdjustWeight
Dim is_invoice_queued
dim vMaster_Weight_Charge
Dim vectorBookingNum,vectorConsigneeName
dim aPieces,aGrossWeight,aMeasurement,aTotalWeightCharge,aGWLB,aMCFT,aUnitQty
dim aPiecesTotal,aGrossWeightTotal,	aMeasurementTotal,	aTotalWeightChargeTotal,  aGWLBTotal, aMCFTTotal,aUnitQtyTotal

Dim aSubHouses 
Dim aAccounts 
DIM vCheckMH, vCheckSH
vCheckMH ="N"
vCheckSH ="N"
dim aSubNoTmp

Dim vIsMasterClosed
dim mhIndex,aM_HAWBInfo(1), vM_HAWB, aM_HAWB(1000)
dim IsColoaded
IsColoaded=false

dim vDefault_SalesRep	
vDefault_SalesRep=session_user_lname	
Dim aColoderName(100),aColoderAcct(100)
DIM coIndex
DIM pIndex,NoItem,vForwardAgentInfo,vDestCountry,vLoadingPier,vDimText
DIM vVN,vLoadingPort,vScale,vGWLB,vMCFT,vManifestDesc,vDemDetail
DIM vCollectOtherCharge,vPrepaidOtherCharge
DIM tIndex,vHBOLPrefix,vNextHBOL,NewForm
DIM qDelete,Save,Add,Edit,DeleteHBOL,NewHBOL,SaveAsNew,OverwriteHBOL
DIM dItemNo,cIndex,sIndex,vIndex,aIndex,nIndex
Dim aItemNo(1024),aItemName(1024),aItemDesc(1024),aChargeItemNameig(1024),chIndex
DIM aChargeUnitPrice(1024) 
Dim aExportCarrier(100),aLoadingPort(100),aUnloadingPort(100)
Dim aDeliveryPlace(100),aBookingInfo(2)
Dim vNotifyName,vNotifyInfo,vNotifyAcct,vUnitQty
DIM vExecute,vCOLO,vCOLOPay,vColoderAcct
DIM vSubCount
Dim rs,rs1,rs3,IVstrMsg
Dim vHBOL,vMBOL,vBookingNum,vFFAgentName,vFFAgentInfo,vFFAgentAcct
Dim vShipperName,vShipperInfo,vShipperAcct
Dim vConsigneeName,vConsigneeInfo,vConsigneeAcct
Dim vExportRef,vOriginCountry,vExportInstr,vLandingPier,vMoveType
Dim vConYes,vPreCarriage,vPreReceiptPlace
Dim vExportCarrier,vLandingPort,vUnloadingPort,vDepartureDate
Dim vDeliveryPlace,vDesc1,vDesc2,vDesc3,vDesc5,vDesc4,vPieces,vWeightCP,vGrossWeight
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
Dim aSRName(1000)
Dim SRIndex
Dim vSalesPerson
Dim vLC, vCI, vAES, vSEDStmt,vSONum,vPONum
dim SelIndex
dim vMaster_Gross_Weight,vMaster_Pieces,vMaster_Chargeable_Weight

	Dim company_country 

company_country_code = CheckBlank(GetSQLResult("SELECT country_code from agent where elt_account_number=" & elt_account_number, null), "US")

    CALL INITIALIZATION

    is_invoice_queued=checkBlank(Request("hIs_invoice_queued"),"N")
    AdjustWeight=Request.QueryString("AjustWeight")
    CloseMH=Request.QueryString("CloseMH")
    OpenMH=Request.QueryString("OpenMH")
    RemoveSH=request.QueryString("RemoveSH")
    rSHAWB=request.QueryString("rSHAWB")
    rELTACT=request.QueryString("ELTACT")

    Save=Request.QueryString("Save")
    Add=Request.QueryString("Add")
    Edit=Request.QueryString("Edit")
    qDelete=Request.QueryString("Delete")
    DeleteHBOL=Request.QueryString("DeleteHBOL")
    vHBOL=Request.QueryString("HBOL")

    '// Avoid data saving when back or refresh
    tNo=Request.QueryString("tNo")

    if tNO="" then
	    Session("HBOLTranNo") = ""
	    tNO=0
    else
	    tNo=cLng(tNo)
    end if

    TranNo=Session("HBOLTranNo")
    if TranNo="" then
	    Session("HBOLTranNo")=0
	    TranNo=0
    end if

    eltConn.BeginTrans

    if Save= "yes" and ( tNO <> TranNo ) then
        if vHBOL = "" then 
            vHBOL = Request("txtHBOL")
        end if	
        Edit = "yes"
        sSave = ""
    end if

    if RemoveSH="Y" then
	    REMOVE_A_SUB_HOUSE_FROM_MASTER
    end if

    CALL MAIN_PROCESS

    vDefaultShipperIndex = get_default_shipper_index

    CALL GET_CHARGE_ITEM_INFO
    CALL GET_M_HAWB_INFO
    call GET_AVAIL_HAWB
    CALL GET_COLODER_INFO
    CALL FINAL_SCREEN_PREPARE
    CALL GET_PRESHIPMENT_DATA
    
    if CloseMH="Y" then
        CLOSE_MASTER
    end if 
    	
    if OpenMH="Y" then
       OPEN_MASTER
    end if 

    eltConn.CommitTrans

Sub GET_PRESHIPMENT_DATA
    Dim SQL,rs
    Set rs = Server.CreateObject("ADODB.Recordset")
    
    If Request.QueryString("DataTransfer") = "SO" And Request.QueryString("SONum") <> "" Then
        vSONum = Request.QueryString("SONum")
        SQL = "SELECT * FROM warehouse_shipout WHERE elt_account_number=" _
            & elt_account_number & " AND so_num=N'" & vSONum & "'"

        rs.CursorLocation = adUseClient	
	    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
        Set rs.ActiveConnection = Nothing
        
        If Not rs.EOF And Not rs.BOF Then
            vShipperAcct = rs("customer_acct")
            vShipperName = GetBusinessName(rs("customer_acct"))
            vShipperInfo = GetOrgNameAddress(rs("customer_acct"))
            vConsigneeAcct = rs("consignee_acct")
            vConsigneeName = GetBusinessName(rs("consignee_acct"))
            vConsigneeInfo = GetOrgNameAddress(rs("consignee_acct"))
            vNotifyAcct = rs("consignee_acct")
            vNotifyInfo = GetOrgNameAddress(rs("consignee_acct")) 
        End If
        
        rs.close()
        
        SQL = "SELECT * FROM warehouse_receipt a LEFT OUTER JOIN warehouse_history b " _
            & "ON (a.elt_account_number=b.elt_account_number AND a.wr_num=b.wr_num) " _
            & "WHERE a.elt_account_number=" + elt_account_number + " AND b.so_num=N'" _
            & vSONum & "' AND history_type='Ship-out Made'"
        rs.CursorLocation = adUseClient	
	    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
        Set rs.ActiveConnection = Nothing
        
        vPieces = 0
        Do While Not rs.EOF And Not rs.BOF
            vDesc3 = vDesc3 & rs("item_desc") & chr(10)
            vPieces = vPieces + CInt(rs("item_piece_shipout"))
            rs.MoveNext()
        Loop
    
    Elseif Request.QueryString("DataTransfer") = "PO" And Request.QueryString("PONum") <> "" Then
        vPONum = Request.QueryString("PONum")
        SQL = "SELECT * FROM pickup_order WHERE elt_account_number=" _
            & elt_account_number & " AND po_num=N'" & vPONum & "'"
            
        rs.CursorLocation = adUseClient	
	    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
        Set rs.ActiveConnection = Nothing
        
        If Not rs.EOF And Not rs.BOF Then
            vShipperAcct = rs("shipper_account_number")
            vShipperName = rs("Shipper_Name")
            vShipperInfo = rs("Shipper_Info")
            vConsigneeAcct = rs("Carrier_account_number")
            vConsigneeName = rs("Carrier_Name")
            vConsigneeInfo = rs("Carrier_Info")
            vNotifyAcct = rs("Carrier_account_number")
            vNotifyInfo = rs("Carrier_Info")
            
            vLoadingPort = GetPortInfo(rs("Origin_Port_Code"),"port_desc")
            vUnloadingPort = GetPortInfo(rs("Dest_Port_Code"),"port_desc")
            
            If IsNumeric(rs("Total_Pieces")) Then
                vPieces = rs("Total_Pieces")
            End If
            vDesc3 = rs("Desc2")
            
            If CStr(rs("Weight_Scale")) = "K" Then
                vGrossWeight = checkBlank(rs("Total_Gross_Weight"),0)
                vGWLB = formatNumber(2.20462262185 * CLng(vGrossWeight),2,,,0)
            Else
                vGWLB = checkBlank(rs("Total_Gross_Weight"),0)
                vGrossWeight = formatNumber(0.4535924277 * CLng(vGWLB),2,,,0)
            End If
        End If

        rs.close()
    
    End If
    
    If Save="yes" And vSONum <> "" Then
	    SQL="UPDATE warehouse_shipout SET file_type='OE',master_num=N'" & vBookingNum _
	        & "',house_num=N'" & vHBOL & "' WHERE so_num=N'" & vSONum & "'"
	    eltConn.Execute(SQL)
	Elseif Save = "yes" And vPONum <> "" Then
        SQL="UPDATE pickup_order SET file_type='OE',MAWB_NUM=N'" & vMAWB _
	        & "',HAWB_NUM=N'" & vHAWB & "' WHERE po_num=N'" & vPONum & "'"
	    eltConn.Execute(SQL)
    End If
End Sub

    
'///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'//////////////////// SUB ROUTINES /////////////////////////////////////////////////////////////////////////////////
'///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
%>
<%
SUB MAIN_PROCESS


    '-------------------------------------------------------------------------------------
    CALL GET_SALES_PERSONS_FROM_USERS
    '-------------------------------------------------------------------------------------
	
	addSUB=Request.QueryString("addSUB")
	
	if addSUB="yes" then
		addSUBNo=Request.QueryString("addSUBNo")
		addELTAcct=Request.QueryString("addELTAcct")
		MBOL=Request.QueryString("MBOL")
		CALL ADD_SUB_TO_MASTER(vHBOL,addSUBNo,addELTAcct,MBOL)
	end if 



	NewHBOL=Request.QueryString("New")
	SaveAsNew=Request.QueryString("SaveAsNew")
	
	If EDIT = "yes" Then
		Session("HBOLTMP") = vHBOL
	End If
	
	if SaveAsNew="yes" then
		Save="yes"
	end if
	
	vHBOLPrefix=Request("hHBOLPrefix")
	
	if vHBOLPrefix="NONE" then vHBOLPrefix=""
	if vHBOLPrefix="" ANd Not vHBOL="" then
		pos=0
		pos=instr(vHBOL,"-")
		if pos>0 then
			vHBOLPrefix=Mid(vHBOL,1,pos-1)
		end if
	end if
	
	CALL GET_HAWB_PREFIX_FROM_USER_PROFILE
	vUnitQty = GetSQLResult("SELECT uom_qty FROM user_profile WHERE elt_account_number=" & elt_account_number, "uom_qty")
	
	if Save="yes" or Add="yes" or qDelete="yes" or AdjustWeight = "yes" or addSUB="yes"  or RemoveSH="Y" then
		
		CALL GET_HAWB_HEADER_INFO_FROM_SCREEN
		'CALL CHECK_IF_COLOADED
'// Avoid data saving when back or refresh	''''''''''<-------------------------------OK page comes back and update again

		if Save="yes" And tNo=TranNo then
			CALL UPDATE_HAWB_TABLE( vHBOL )
			
			
		'// Avoid data saving when back or refresh	
			Session("HBOLTMP") = vHBOL
			Session("HBOLTranNo")=checkblank(Session("HBOLTranNo"),0)+1
			TranNo=checkblank(Session("HBOLTranNo"),0)
			'----------------------------------------------------
		
			CALL INVOICE_QUEUE_REFRESH( vHBOL, vBookingNum )
			CALL HBOL_INVOICE_QUEUE( vHBOL,vBookingNum )	
		
			'----------------------------------------------------				
		END IF
		
		if vCheckMH ="Y" and (AdjustWeight = "yes" or addSUB="yes" or RemoveSH="Y") then 
			
			GET_WEIGHT_CHARGE_INFO_FOR_MASTER_HOUSE vHBOL,"no" 		
			
			if vChargeRate="N/A" then
				vChargeRate=0
			end if 
			
			if  vChargeRate<>"N/A" or checkBlank(vChargeRate,0) then
				vTotalWeightCharge=checkBlank(vChargeRate,0)*checkBlank(vChargeableWeight,0)
			end if 
			
		end  if 
		
	elseif DeleteHBOL="yes" then
		
		CALL DELETE_HAWB
		CALL INVOICE_QUEUE_REFRESH( vHBOL, vBookingNum )	
		CALL HBOL_INVOICE_QUEUE( vHBOL,vBookingNum )	
				
					
		'CALL HBOL_INVOICE_QUEUE( vHBOL,vBookingNum )
%>

<script language="javascript">location.replace("new_edit_hbol.asp");</script>

<%
		Exit Sub 	
				
		
	else
	    '// Commented out by Joon on Mar/13/2007
		'// if vHBOL="" then
		'//	CALL GET_AGENT_INFO
		'// end if
	
		vConYes="Y"
		vDate=Now
		
		vTotalPrepaid=0
		vTotalCollect=0

		if Not vHBOL="" then
			CALL GET_HAWB_INFO_FROM_TABLE
			'CALL CHECK_IF_COLOADED
			CALL GET_HAWB_ITEM_OTHER_CHARGE_FROM_TABLE
		else
			tIndex = 4
		end if
	end if
	
	
	CALL CHECK_IF_COLOADED
	
	if vCheckMH ="N" and vHAWB <> "" then 
        'vCanbeMaster=false
	end  if 
	
	
END SUB

SUB ADD_SUB_TO_MASTER(vHBOL,addSUBNo,addELTAcct,vMBOL)
	'response.Write("-------------"&vMAWB)
	dim SQL	
	SQL="UPDATE hbol_master set is_sub='Y',sub_to_no=N'"& vHBOL &"',is_invoice_queued='N',mbol_num=N'"&vMBOL&"' where elt_account_number="&addELTAcct&" and hbol_num=N'"& addSUBNo&"' "
	eltConn.Execute(SQL)
END SUB 


SUB UPDATE_ALL_SUB_HOUSE_INFO(IS_QUE)

    dim rs, SQL, HAWBS(50),hhIndex	
	set rs= Server.CreateObject("ADODB.Recordset")
	elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
	
	SQL= "select hbol_num as hb from hbol_master  where (elt_account_number= "
	SQL= SQL& elt_account_number & " or coloder_elt_acct="
	SQL= SQL& elt_account_number & ") and is_sub='Y' and sub_to_no=N'"& vHBOL & "'"
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	
	If Not rs.EOF Then
		hhIndex=0
		Do While Not rs.EOF
			HAWBS(hhIndex)=rs("hb")
			hhIndex=hhIndex+1
			rs.MoveNext		
		Loop
	End If
	rs.close
	
	For i =0 to hhIndex -1	
		SQL= "select * from hbol_master  where (elt_account_number= "
		SQL= SQL& elt_account_number & " or coloder_elt_acct="
		SQL= SQL& elt_account_number & ") and is_sub='Y' and hbol_num=N'"& HAWBS(i) & "'"
		rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
		
		if not rs.EOF then
			rs("booking_num")=vBookingNum	
			rs("loading_port")=vLoadingPort
			rs("unloading_port")=vUnloadingPort
			rs("export_carrier")=vExportCarrier
			rs("delivery_place")=vDeliveryPlace
			rs("origin_country")=vOriginCountry
			rs("departure_date")=vDepartureDate
			rs("mbol_num")=vMBOL
			rs("move_type")=vMoveType
			rs("pre_receipt_place")=vPreReceiptPlace
			
			rs("export_ref")=vExportRef
			rs("dest_country")=vDestCountry
			rs("vessel_name")=vVN	
			rs("weight_cp")=vWeightCP	
			rs("desc5")=vDesc5
			
			if checkBlank(rs("coloder_elt_acct"),0)=elt_account_number then 
				'must not change
			else 
				rs("is_invoice_queued")=IS_QUE			
			end if 
			rs.Update
		end if 
		
		rs.close
	next
	set rs=nothing 
END SUB 



SUB CLOSE_MASTER
	dim SQL	
	SQL="UPDATE hbol_master set is_master_closed='Y' where elt_account_number="&elt_account_number&" and hbol_num=N'"& vHBOL&"' "
	eltConn.Execute(SQL)
	vIsMasterClosed="Y"
END SUB 

SUB Open_MASTER
	dim SQL	
	SQL="UPDATE hbol_master set is_master_closed='N' where elt_account_number="&elt_account_number&" and hbol_num=N'"& vHBOL&"' "
	eltConn.Execute(SQL)
	vIsMasterClosed="N"
END SUB 

SUB GET_M_HAWB_INFO
    dim rs
	set rs= Server.CreateObject("ADODB.Recordset")
	SQL= "select hbol_num,booking_num from hbol_master  where elt_account_number= " & elt_account_number & "  and is_master='Y' order by hbol_num"
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	If Not rs.EOF Then
		mhIndex=1
		Do While Not rs.EOF
			aM_HAWB(mhIndex) = rs("hbol_num")
'			subno=GET_NEXT_SUB_NO(rs("hbol_num"))
'			aM_HAWBInfo(mhIndex)= subno&chr(10) &GET_ONE_MAWB_INFO(rs("booking_num"))	
			mhIndex = mhIndex + 1
			rs.MoveNext
		Loop
	End If
	rs.close
	set rs=nothing 
END SUB



Function GET_NEXT_SUB_NO(oHAWB)

	dim rs1
	set rs1= Server.CreateObject("ADODB.Recordset")
	dim SQL
	
	SQL="select sub_no from hbol_master where is_sub ='Y' and elt_account_number="&elt_account_number&" and sub_to_no=N'"& oHAWB&"' order by sub_no asc"
	rs1.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
    
	if not rs1.eof then 
	    Do While Not rs1.EOF
			aSubNoTmp.Add rs1("sub_no").Value
			rs1.MoveNext
		Loop
		rs1.close
		
		GET_NEXT_SUB_NO=aSubNoTmp(aSubNoTmp.Count-1)+1
		
		first=0
		
        for indexS=0 to aSubNoTmp.Count-1
            tmp=first+1
            
            if aSubNoTmp(indexS) > tmp then
                GET_NEXT_SUB_NO=tmp
                exit Function
            else
                first=tmp
            end if 	          
		next 
		
	else 
		 GET_NEXT_SUB_NO=1
	end if 	
	
	set rs1=nothing
End Function




FUNCTION GET_ONE_MAWB_INFO(MAWB)
    dim rs, SQL    
    set rs=Server.CreateObject("ADODB.Recordset")
	SQL= "select booking_num,departure_date,origin_port_location,dest_port_location,vsl_name,origin_port_state,mbol_num,move_type,receipt_place,delivery_place,file_no,dest_port_country,vsl_name from ocean_booking_number where elt_account_number = " & elt_account_number & " and booking_num=N'"&MAWB&"'"
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	
	If Not rs.EOF Then			
		oneBookingNum=rs("booking_num")
		GET_ONE_MAWB_INFO=oneBookingNum&chr(10)&rs("departure_date") & chr(10) & rs("origin_port_location") & chr(10) & rs("dest_port_location") & chr(10) & rs("vsl_name") & chr(10) & 	rs("origin_port_state") & chr(10) & rs("mbol_num") & chr(10) & rs("move_type") & chr(10) & rs("receipt_place") & chr(10) & rs("delivery_place") & chr(10) & rs("file_no") & chr(10) & rs("dest_port_country") & chr(10) & rs("vsl_name")
		mIndex = mIndex + 1
	
	End If
	rs.close
	set rs=nothing 
END FUNCTION

SUB GET_AVAIL_HAWB

	vectAVGrossWeightTotal=0
	vectAVMeasurementTotal=0
	vectAVDimensionTotal=0
	vectAVChargeableWeightTotal=0
	vectAVPieceTotal=0
	
	DIM rs
	
	Set rs = Server.CreateObject("ADODB.Recordset")		
	SQL= "select a.booking_num,a.elt_account_number,a.hbol_num,a.agent_name,a.Shipper_name,a.Consignee_name, "
	SQL=SQL & "a.pieces,a.gross_weight,a.measurement from hbol_master a "
	SQL=SQL & " where (a.elt_account_number=" & elt_account_number &" OR a.coloder_elt_acct="&elt_account_number
	SQL=SQL & ") and  isnull(a.is_sub,'N')='N' and  isnull(a.is_master,'N')='N' and ( isnull(a.booking_num,'') = '' OR a.booking_num=N'"&vBookingNum&"') and (colo ='N' OR isnull(colo,'')='') " ' COLO ='N' done by Jay Noh
    
	SQL=SQL &" UNION "
	SQL=SQL & "select a.booking_num,a.elt_account_number,a.hbol_num,a.agent_name,a.Shipper_name,a.Consignee_name, "
	SQL=SQL & "a.pieces,a.gross_weight,a.measurement from hbol_master a "	
	SQL=SQL & " where ( a.coloder_elt_acct=" & elt_account_number &" OR a.coloder_elt_acct="&elt_account_number
	SQL=SQL & ") and ( isnull(a.booking_num,'') = '' OR a.booking_num=N'"&vBookingNum&"') and isnull(a.is_sub,'N') ='N'and  isnull(a.is_master,'N')='N'  order by a.hbol_num" ' COLO ='N' done by Jay Noh
	
	'response.Write("-----"&SQL)
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	AVIndex=0

	Do While Not rs.EOF 	
		
		vectAVHAWBs(AVIndex)=rs("hbol_num")	
		
		vectAVPiece(AVIndex)=ConvertAnyValue(rs("pieces"),"Long",0)		
		vectAVPieceTotal=vectAVPieceTotal+vectAVPiece(AVIndex)
		
		vectAVGrossWeight(AVIndex)=ConvertAnyValue(rs("gross_weight"),"Amount",0)	
		vectAVGrossWeightTotal=vectAVGrossWeightTotal+vectAVGrossWeight(AVIndex)	
		
		vectAVMeasurement(AVIndex)=ConvertAnyValue(rs("measurement"),"Amount",0)	
		vectAVMeasurementTotal=vectAVMeasurementTotal+vectAVMeasurement(AVIndex)				
		
						
		vectAVGWLB(AVIndex)= Round(ConvertAnyValue(rs("gross_weight").Value,"Amount",0)*2.204,2)
		vectAVMCFT(AVIndex)= Round(ConvertAnyValue(rs("measurement").Value,"Amount",0)*35.314666721,2)  
					
		vectAVBookingNum(AVIndex) = rs("booking_num").Value				
		vectAVGWLBTotal=vectAVGWLBTotal + Round(ConvertAnyValue(rs("gross_weight").Value,"Amount",0)*2.204,2)
		vectAVMCFTTotal=vectAVMCFTTotal + Round(ConvertAnyValue(rs("measurement").Value,"Amount",0)*35.314666721,2)
		
		vectAVELTAcct(AVIndex)=rs("elt_account_number")	
		vectAVAgents(AVIndex) = rs("agent_name")			
		vectAVShippers(AVIndex) = rs("Shipper_name")
		vectAVConsignees(AVIndex) = rs("Consignee_name")
		
		
		AVIndex=AVIndex+1
		rs.MoveNext
	Loop
	rs.Close
	set rs = nothing
END SUB

SUB GET_WEIGHT_CHARGE_INFO_FOR_MASTER_HOUSE(masterHAWB,toSave)
	SQL=""
	dim rs
	set rs=Server.CreateObject("ADODB.Recordset")
	Set aSubHouses = Server.CreateObject("System.Collections.ArrayList")
	Set aAccounts = Server.CreateObject("System.Collections.ArrayList")
	Set aShippers = Server.CreateObject("System.Collections.ArrayList")
	Set aConsignees = Server.CreateObject("System.Collections.ArrayList")
	Set aAgents= Server.CreateObject("System.Collections.ArrayList")
	set vectorBookingNum=server.CreateObject("System.Collections.ArrayList")
	set vectorConsigneeName=server.CreateObject("System.Collections.ArrayList")
	set aPieces=server.CreateObject("System.Collections.ArrayList")
	set aGrossWeight=server.CreateObject("System.Collections.ArrayList")
	set aMeasurement=server.CreateObject("System.Collections.ArrayList")
	set aTotalWeightCharge=server.CreateObject("System.Collections.ArrayList")
	set aGWLB=server.CreateObject("System.Collections.ArrayList")
	set aMCFT=server.CreateObject("System.Collections.ArrayList")
	set aUnitQty=server.CreateObject("System.Collections.ArrayList")
	
	Set aColo=Server.CreateObject("System.Collections.ArrayList")

	
		
	Set aIsInvoiceQueued=Server.CreateObject("System.Collections.ArrayList")
	
	vGrossWeight=0
	vMeasurement=0
	
	vGrossWeight1=0
	vMeasurement1=0
	
	vPieces=0
	vLb1=0
	vCF1=0
	vGWLB=0
	vMCFT=0		
					
	SQL= "select *  from hbol_master where is_sub='Y' and (elt_account_number = " & elt_account_number&" OR coloder_elt_acct="&elt_account_number & ") and sub_to_no=N'" & masterHAWB& "'"
	rs.Open SQL, eltConn, , , adCmdText
	
    'response.Write("---------------"&SQL)
	vMaster_Weight_Charge=0
	vMaster_Gross_Weight=0
	vMaster_Pieces=0
	vMaster_Chargeable_Weight=0
	Do While Not rs.eof And Not rs.bof 
		aSubHouses.Add rs("hbol_num").value
		aAccounts.Add rs("elt_account_number").value
		aShippers.Add rs("Shipper_Name").value
		aConsignees.Add rs("Consignee_Name").value
		aAgents.Add rs("Agent_Name").value
		aIsInvoiceQueued.Add checkBlank(rs("is_invoice_queued"),"Y")
		'response.Write("--------------"&rs("is_invoice_queued"))
		aColo.Add rs("colo")
		rs.MoveNext
	Loop
	rs.Close
	upperbound=aSubHouses.count -1 
    
	aPiecesTotal=0			
	aGrossWeightTotal=0	
	aMeasurementTotal=0			
	aGWLBTotal=0	
	aMCFTTotal=0
	
	
	
	for p=0 to upperbound
		call GET_WEIGHT_CHARGES_FOR_A_HAWB ( aSubHouses(p), aAccounts(p),aShippers(p),aConsignees(p),aAgents(p),aColo(p),aIsInvoiceQueued(p)) 
	next 
   
   '---------------------------------------------------------------------
    vLb1=Round(vGrossWeight*2.204,2)
    vCF1=Round(vMeasurement*35.314666721,2)
	vGWLB=vLb1
	vMCFT=vCF1
   '--------------------------------------------------------------------
	set rs=nothing 
	
	if toSave ="no" then
		vPieces=aPiecesTotal
		vGrossWeight=aGrossWeightTotal
		vMeasurement=aMeasurementTotal		
		vGWLB=aGWLBTotal
		vMCFT=aMCFTTotal
	end if 
	
END SUB




Sub GET_WEIGHT_CHARGES_FOR_A_HAWB(mHBOL,account,Shipper,Consignee,Agent,colo,is_invoice_q)
		dim rs
		set rs=Server.CreateObject("ADODB.Recordset")
		SQL= "select * from hbol_master where elt_account_number = " & account & " and hbol_num=N'" & mHBOL & "'"
	
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing

		
		if Not rs.EOF then
		
			if not isnull(rs("gross_weight")) = true  then
				vGrossWeight=vGrossWeight+ConvertAnyValue(rs("gross_weight"),"Amount",0)				
			end if
			
			if not isnull(rs("measurement")) = true  then
				vMeasurement=vMeasurement+ConvertAnyValue(rs("measurement"),"Amount",0)				
			end if
           	vUnitQty=rs("unit_qty")				
			vPieces=vPieces+rs("pieces")
			
			aPieces.Add rs("pieces").Value	
			'response.Write("-----------------"&rs("pieces")&"<br>")
			aGrossWeight.Add ConvertAnyValue(rs("gross_weight").Value,"Amount",0)
			aMeasurement.Add ConvertAnyValue(rs("measurement").Value,"Amount",0)
			aTotalWeightCharge.Add ConvertAnyValue(rs("total_weight_charge").Value,"Amount",0)
			
		
							
			aGWLB.Add Round(ConvertAnyValue(rs("gross_weight").Value,"Amount",0)*2.204,2)
   			aMCFT.Add Round(ConvertAnyValue(rs("measurement").Value,"Amount",0)*35.314666721,2)
		    aUnitQty.Add rs("unit_qty").Value	
						
			vectorBookingNum.Add rs("booking_num").Value
	        vectorConsigneeName.Add rs("consignee_name").Value
		    aPiecesTotal=aPiecesTotal +ConvertAnyValue(rs("pieces").Value,"Long",0)			
			aGrossWeightTotal=aGrossWeightTotal +ConvertAnyValue(rs("gross_weight").Value,"Amount",0)	
			
			
			aMeasurementTotal=aMeasurementTotal +ConvertAnyValue(rs("measurement").Value,"Long",0)
						
			aGWLBTotal=aGWLBTotal + Round(ConvertAnyValue(rs("gross_weight").Value,"Amount",0)*2.204,2)
			aMCFTTotal=aMCFTTotal + Round(ConvertAnyValue(rs("measurement").Value,"Amount",0)*35.314666721,2)
			
			
			rs.Close
		
		end if
     
		set rs=nothing 
End Sub 
%>
<%
SUB CHECK_IF_COLOADED
		DIM rs
		set rs=Server.CreateObject("ADODB.Recordset")
		if vHBOL<>"" then 
			SQL= "select hbol_num from hbol_master where elt_account_number = " & elt_account_number & " and colo='Y' and hbol_num=N'"&vHBOL&"'"
			'response.Write("------"&SQL)
			rs.CursorLocation = adUseClient
			rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
			Set rs.activeConnection = Nothing

			if not rs.eof  then
			  IsColoaded=true
			end if 
			rs.close
		end if 
		set rs=Nothing 
	'response.Write("---"&IsColoaded)
END SUB 
%>
<%
SUB GET_COLODER_INFO
	'get coloder info
	SQL= "select coloder_name, coloder_elt_acct from colo where colodee_elt_acct = " & elt_account_number & " order by coloder_name"
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing

	
	'response.Write("---"&SQL)
	coIndex=1
	aColoderName(0)=""
	aColoderAcct(0)=0
	Do While Not rs.EOF
		aColoderName(coIndex)=rs("coloder_name")
		aColoderAcct(coIndex)=ConvertAnyValue(rs("coloder_elt_acct"),"Long",0)
		coIndex=coIndex+1
		rs.MoveNext
	Loop
	rs.Close
	
END SUB
%>
<%
Sub HBOL_INVOICE_QUEUE( tmpHAWB, vBookingNum)

	if trim(vBookingNum) = "" Then
		exit sub
	end if

	IF (vCheckMH <>"Y" and vCheckSH <> "Y") OR (vCheckSH="Y" and is_invoice_queued <>"N") OR (vCheckMH="Y" and is_invoice_queued <>"N") THEN
		'below is same as from air CALL INSERT_A_QUEUE_ENTRY(tmpHAWB,tmpMAWB)
	
		if vWeightCP="P" or vPrepaidOtherCharge="Y" then
			SQL="select * from invoice_queue where elt_account_number=" & elt_account_number & " and agent_shipper='S' and hawb_num=N'" & tmpHAWB & "' and bill_to_org_acct=" & vShipperAcct
			rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
			if rs.EOF then
				vQueueID = GET_QUEUE_ID() 
				rs.AddNew
				rs("elt_account_number")=elt_account_number
				rs("queue_id")=vQueueID
				rs("inqueue_date")=now
				rs("agent_shipper")="S"
				rs("mawb_num")=vBookingNum
				rs("bill_to")=vShipperName
				rs("bill_to_org_acct")=vShipperAcct
				rs("agent_name")=vFFAgentName
				rs("agent_org_acct")=vFFAgentAcct
				rs("air_ocean")="O"
				rs("invoiced")="N"
				rs.Update
			end if
			rs.close

		end if
		
'insert into invoice_queue table for agent
		if vWeightCP="C" or vCollectOtherCharge="Y" then
			SQL="select * from invoice_queue where elt_account_number=" & elt_account_number & " and agent_shipper='A' and mawb_num=N'" & vBookingNum & "' and bill_to_org_acct=" & vFFAgentAcct
'			response.write SQL
			rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
			if rs.EOF then
				vQueueID = GET_QUEUE_ID() 
				rs.AddNew
				rs("elt_account_number")=elt_account_number
				rs("queue_id")=vQueueID
				rs("inqueue_date")=now
				rs("agent_shipper")="A"
				rs("hawb_num")=tmpHAWB
				rs("mawb_num")=vBookingNum
				rs("bill_to")=vFFAgentName
				rs("bill_to_org_acct")=vFFAgentAcct
				rs("agent_name")=vFFAgentName
				rs("agent_org_acct")=vFFAgentAcct
				rs("air_ocean")="O"
				rs("invoiced")="N"
				rs.Update
			end if
			rs.close
		end if
	END IF 	
	CALL INVOICE_QUEUE_REFRESH_MAWB( vBookingNum )

	dim atmpHAWB(100),tmpIndex
	tmpIndex = 0
	
	SQL = "select hbol_num from hbol_master where isnull(is_invoice_queued,'Y')<>'N' and elt_account_number = " & elt_account_number & " and booking_num=N'" & vBookingNum & "'" 

	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing

	Do while Not rs.EOF
		atmpHAWB(tmpIndex)=rs("hbol_num")
		tmpIndex = tmpIndex + 1
		rs.MoveNext
	Loop
	rs.Close
	i=0
	for i=0 to tmpIndex-1
		call HAWB_INVOICE_QUEUE_SINGLE ( atmpHAWB(i), tmpIndex )
	next
	
End Sub
%>
<%
Sub HAWB_INVOICE_QUEUE_SINGLE ( tmpHAWB, iiiCnt )

		DIM tvQueueID,tvShipperAcct,tvShipperName,tvFFAgentAcct,tvFFAgentName,vWeightCP,vPrepaidOtherCharge,vCollectOtherCharge,tvMAWB

		SQL= "select Booking_num,Shipper_Acct_Num,agent_name,agent_no,shipper_name,weight_cp,prepaid_other_charge,collect_other_charge from hbol_master where elt_account_number = " & elt_account_number & " and HBOL_NUM =N'" & tmpHAWB & "'"

		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing

		if not rs.EOF Then		
				tvMAWB = rs("Booking_num")
				tvShipperAcct = rs("Shipper_Acct_Num")
				tvAgentName=rs("agent_name")
				tvAgentAcct=ConvertAnyValue(rs("agent_no"),"Long",0)
				tvShipperName=rs("shipper_name")
				vWeightCP=rs("weight_cp")
				vPrepaidOtherCharge=rs("prepaid_other_charge")
				vCollectOtherCharge=rs("collect_other_charge")
				
			if vWeightCP="P" or vPrepaidOtherCharge="Y" then
				rs.close
				
				tvQueueID = GET_QUEUE_ID()
	
				SQL="select * from invoice_queue where elt_account_number=" & elt_account_number & " and agent_shipper='S' and hawb_num=N'" & tmpHAWB & "' and bill_to_org_acct=" & tvShipperAcct
				rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
				if rs.EOF then
					vQueueID = GET_QUEUE_ID() 
					rs.AddNew
					rs("elt_account_number")=elt_account_number
					rs("queue_id")=tvQueueID
					rs("inqueue_date")=now
					rs("agent_shipper")="S"
					rs("hawb_num")=tmpHAWB
					rs("mawb_num")=vBookingNum
					rs("bill_to")=tvShipperName
					rs("bill_to_org_acct")=tvShipperAcct
					rs("agent_name")=tvAgentName
					rs("agent_org_acct")=tvAgentAcct
					rs("air_ocean")="O"
					rs("invoiced")="N"
					rs.Update
				end if
				rs.close
			else
				rs.close			
			end if
			
			if vWeightCP="C" or vCollectOtherCharge="Y" then
				SQL="select * from invoice_queue where elt_account_number=" & elt_account_number & " and agent_shipper='A' and mawb_num=N'" & vBookingNum & "' and bill_to_org_acct=" & tvAgentAcct
	'			response.write SQL
				rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
				if rs.EOF then
					vQueueID = GET_QUEUE_ID() 
					rs.AddNew
					rs("elt_account_number")=elt_account_number
					rs("queue_id")=vQueueID
					rs("inqueue_date")=now
					rs("agent_shipper")="A"
					if iiiCnt = 1 then
						rs("hawb_num")=tmpHAWB
					end if					
					rs("mawb_num")=vBookingNum
					rs("bill_to")=tvAgentName
					rs("bill_to_org_acct")=tvAgentAcct
					rs("agent_name")=tvAgentName
					rs("agent_org_acct")=tvAgentAcct
					rs("air_ocean")="O"
					rs("invoiced")="N"
					rs.Update
				end if
				rs.close
			end if
		end if			
		
End Sub
%>
<%
SUB INVOICE_QUEUE_REFRESH_MAWB( vMAWB )

DIM arr_queue_id(100),qu_index

		qu_index = 0				
		SQL="select queue_id from invoice_queue where elt_account_number=" & elt_account_number & " and mawb_num=N'" & vMAWB & "'" & " and invoiced = 'N' "
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing

		Do While Not rs.EOF
			arr_queue_id(qu_index) = rs("queue_id")
			qu_index = qu_index + 1										
			rs.MoveNext
		Loop
		rs.Close

		
		'////////////////////////////////////////////////////////////
		'Delete Queue for MAWB
		'////////////////////////////////////////////////////////////
		
		for iii = 0 to qu_index - 1
			SQL= "delete invoice_queue where elt_account_number=" & elt_account_number & " and mawb_num=N'" & vMAWB & "'" & " and invoiced = 'N' and queue_id=" & arr_queue_id(iii)
			eltConn.Execute SQL
		next

'// Refresh Invoice_queue according to HBOL and Agent_no
		SQL= "delete invoice_queue where elt_account_number=" & elt_account_number & " and agent_shipper='A' and mawb_num=N'" & vMAWB & "' and invoiced = 'N' and bill_to_org_acct not in (select agent_no from hbol_master where elt_account_number=" & elt_account_number & " and booking_num = N'" & vMAWB & "' group by agent_no )"
		eltConn.Execute SQL

End Sub
		
%>
<%
FUNCTION GET_QUEUE_ID
	SQL="select max(queue_id) as queue_id from invoice_queue where elt_account_number=" & elt_account_number
	rs3.CursorLocation = adUseClient
	rs3.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs3.activeConnection = Nothing

	If Not rs3.EOF And IsNull(rs3("queue_id"))=False Then
		vQueueID=ConvertAnyValue(rs3("queue_id"),"Long",0)+1
	Else
		vQueueID=1
	End If
	rs3.close
	GET_QUEUE_ID = vQueueID
END FUNCTION
%>
<%
SUB GET_CHARGE_ITEM_INFO
'get charge_item info
SQL= "select item_name,item_no,item_desc,unit_price from item_charge where elt_account_number = " & elt_account_number & " order by item_name"
rs.CursorLocation = adUseClient
rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
Set rs.activeConnection = Nothing

chIndex=0
Do While Not rs.EOF
	aItemNo(chIndex)=ConvertAnyValue(rs("item_no"),"Long",0)
    aItemName(chIndex)=rs("item_name")
    
	aItemDesc(chIndex)=rs("item_desc")
	aChargeUnitPrice(chIndex)=rs("unit_price") '// Unit_price by ig 10/21/2006

	if ( len(aItemName(chIndex))) < 7 then	
		aChargeItemNameig(chIndex) = aItemName(chIndex) & " " & string(7-len(aItemName(chIndex)),"-") & " " & aItemDesc(chIndex)
	else
		aChargeItemNameig(chIndex) = aItemDesc(chIndex)
	end if
	
	chIndex=chIndex+1
	rs.MoveNext
Loop
rs.Close
END SUB
%>
<%

Function get_default_shipper_index

    Dim tempValue,returnValue
   
    returnValue = 0
	tempValue = 1
	
    SQL = "select org_account_number from organization where elt_account_number=" & elt_account_number & " and agent_elt_acct = " & elt_account_number

    eltConn.CursorLocation = adUseNone
    rs.CursorLocation = adUseClient	
    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
    Set rs.ActiveConnection = Nothing
    
    if Not rs.EOF then
		returnValue = rs("org_account_number")
    end if
	
    rs.Close()
	
    get_default_shipper_index = returnValue
	
End Function 

%>
<%
SUB GET_HAWB_INFO_FROM_TABLE

        SQL= "select * from hbol_master where elt_account_number = " & elt_account_number & " and hbol_num=N'" & vHBOL & "'"
        'response.write SQL
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing

		
		if Not rs.EOF then
		'---------------------------------------------------
		   
            if not isnull(rs("is_master")) then 
                vCheckMH= rs("is_master")
            else 
                vCheckMH= "N"
            end  if 		
			
			if not isnull(rs("is_sub")) then 
                vCheckSH= rs("is_sub")
            else 
                vCheckSH= "N"
            end  if 
			
            vM_HAWB= rs("sub_to_no")
			
		    vIsMasterClosed=rs("is_master_closed")
			
			vBookingNum=rs("booking_num")
		
			
			if vCheckMH="Y" OR vCheckSH="Y" then
				is_invoice_queued=rs("is_invoice_queued")				
			end if
			
			
			
			vMBOL=rs("mbol_num")
			vFFAgentName=rs("agent_name")
			if not isnull(rs("agent_no")) = true  then
				vFFAgentAcct=ConvertAnyValue(rs("agent_no"),"Long",0)
			end if
			vFFAgentInfo=rs("agent_info")
			vShipperName=rs("shipper_name")
			vShipperInfo=rs("shipper_info")
			
			if not isnull(rs("shipper_acct_num")) = true  then
				vShipperAcct=ConvertAnyValue(rs("shipper_acct_num"),"Long",0)
			end if
			
			vConsigneeName=rs("consignee_name")
			vConsigneeInfo=rs("consignee_info")
	
			if not isnull(rs("consignee_acct_num")) = true  then
				vConsigneeAcct=ConvertAnyValue(rs("consignee_acct_num"),"Long",0)
			end if
			
			vNotifyName=rs("notify_name")
			vNotifyInfo=rs("notify_info")
			if (Not rs("notify_acct_num") = "0") then
			vNotifyAcct=ConvertAnyValue(rs("notify_acct_num"),"Long",0)
			else
			vNotifyAcct = "0"
			end if
			vExportRef=rs("export_ref")
			vForwardAgentInfo=rs("forward_agent_info")
			vOriginCountry=rs("origin_country")
			vDestCountry=rs("dest_country")
			vExportInstr=rs("export_instr")
			vLoadingPier=rs("loading_pier")
			vMoveType=rs("move_type")
			vConYes=rs("containerized")
			vPreCarriage=rs("pre_carriage")
			vPreReceiptPlace=rs("pre_receipt_place")
			vExportCarrier=rs("export_carrier")
			vVN=rs("vessel_name")
			vLoadingPort=rs("loading_port")
			vUnloadingPort=rs("unloading_port")
			vDeliveryPlace=rs("delivery_place")
			vDepartureDate=rs("departure_date")
			vWeightCP=rs("weight_cp")
			
			vScale=rs("scale")
			vDimText=rs("dimtext")
			'----------------------------------------------
            if(isnull(rs("SalesPerson"))) then 
	         vSalesPerson=""
             else 
 	         vSalesPerson=rs("SalesPerson")
            end if 
			
            if vCheckMH="Y" then
					GET_WEIGHT_CHARGE_INFO_FOR_MASTER_HOUSE vHBOL,"no" 
					
			end if 
			
			
			if not isnull(rs("gross_weight")) = true  then
				vGrossWeight=ConvertAnyValue(rs("gross_weight"),"Amount",0)
			end if
			if not isnull(rs("measurement")) = true  then
				vMeasurement=ConvertAnyValue(rs("measurement"),"Amount",0)
			end if
			
			vPieces=rs("pieces")
			
		 
				
'///////////////////////// vUnitQty
            vUnitQty=rs("unit_qty")
'/////////////////////////			
			
			'vLength=rs("length")
			'vWidth=rs("width")
			'vHeight=rs("height")
			'vChargeableWeight=rs("chargeable_weight")
			vChargeRate=rs("charge_rate")
			vTotalWeightCharge=checkBlank(rs("total_weight_charge").value,0)
		
			if vWeightCP="P" then
				vTotalPrepaid=vTotalPrepaid+vTotalWeightCharge
			else
				vTotalCollect=vTotalCollect+vTotalWeightCharge
			end if
			
			vDesc1=rs("desc1")
			vDesc2=rs("desc2")
			vDesc3=rs("desc3")
			vDesc5=rs("desc5")
			vDesc4=rs("desc4")
			'---------------------------------------------------
			vLC=rs("lc")
			vCI=rs("ci")
			vAES=rs("aes_xtn")
			vSEDStmt = rs("sed_stmt").value
            '--------------------------------------------------
			
            vAES = checkBlank(rs("aes_xtn"),"")
            vSEDStmt = checkBlank(rs("sed_stmt").value,"")
            
            If vAES = "" And vSEDStmt = "" Then
                vSEDStmt = GetSQLResult("SELECT sed_statement FROM user_profile WHERE elt_account_number=" & elt_account_number, Null)
            End If
		
			if not isnull(rs("gross_weight")) = true  then			
				vGrossWeight1=ConvertAnyValue(rs("gross_weight"),"Amount",0)
				vLb1=Round(vGrossWeight1*2.204,2)
			end if
			if not isnull(rs("measurement")) = true  then			
				vMeasurement1=ConvertAnyValue(rs("measurement"),"Amount",0)
				vCF1=Round(vMeasurement1*35.314666721,2)
			end if	

			vGWLB=vLb1
			vMCFT=vCF1
		

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
			
			vCOLO=rs("colo")
			
			if IsNull(vCOLO) then vCOLO="N"
			vCOLOPay=rs("colo_pay")
			vColoderAcct=rs("coloder_elt_acct")
			if Not vColoderAcct="" then vColoderAcct = ConvertAnyValue(vColoderAcct,"Long",0)
			rs.Close
		else
			rs.Close
%>

<script language='JavaScript'> alert('Could not find the B/L Number '); history.go(-1);</script>

<%
		end if

END SUB
%>
<%
SUB GET_HAWB_ITEM_OTHER_CHARGE_FROM_TABLE
		SQL= "select tran_no,coll_prepaid,charge_code,charge_desc,charge_amt from hbol_other_charge where elt_account_number = " & elt_account_number & " and hbol_num=N'" & vHBOL & "' order by tran_no"
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing
		tIndex=0
		Do while Not rs.EOF
			aChargeNo(tIndex)=rs("tran_no")
			aChargeCP(tIndex)=rs("coll_prepaid")
			aChargeItem(tIndex)=rs("charge_code")
			aChargeItemName(tIndex)=rs("charge_desc")
			aChargeAmt(tIndex)=ConvertAnyValue(rs("charge_amt"),"Amount",0)
			
			if aChargeCP(tIndex)="P" then
				vTotalPrepaid=vTotalPrepaid+aChargeAmt(tIndex)
			else
				vTotalCollect=vTotalCollect+aChargeAmt(tIndex)
			end if
			rs.MoveNext
			tIndex=tIndex+1
		Loop
		rs.Close

END SUB
%>
<%
SUB GET_AGENT_INFO
DIM AgentAddress,AgentCity,AgentState,AgentZip,AgentCountry

		SQL= "select dba_name,business_address,business_city,business_state,business_zip,business_country from agent where elt_account_number = " & elt_account_number
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing
		If Not rs.EOF Then
			vFFAgentName = rs("dba_name")
			AgentAddress=rs("business_address")
			AgentCity = rs("business_city")
			AgentState = rs("business_state")
			AgentZip = rs("business_zip")
			AgentCountry = rs("business_country")
			vFFAgentInfo = vFFAgentName & chr(10) & AgentAddress & chr(10) & AgentCity & "," & AgentState & " " & AgentZip & " " & AgentCountry
			vBy=vFFAgentName
			vPlace=AgentCity
		End If
		rs.Close
END SUB
%>
<%
SUB DELETE_HAWB

	if vCheckMH="Y" then
		call FREE_ALL_SUB_HOUSE
	end if
	SQL= "delete from hbol_master where elt_account_number = " & elt_account_number & " and hbol_num=N'" & vHBOL & "'"
	eltConn.Execute SQL
	SQL= "delete from hbol_other_charge where elt_account_number = " & elt_account_number & " and hbol_num=N'" & vHBOL & "'"
	eltConn.Execute SQL
	SQL= "delete from hbol_other_cost where elt_account_number = " & elt_account_number & " and hbol_num=N'" & vHBOL & "'"
    eltConn.Execute SQL
    SQL= "delete from invoice_queue where elt_account_number = " & elt_account_number & " and hawb_num=N'" & vHAWB & "' and air_ocean='O'"
    eltConn.Execute SQL		
	
END SUB
%>
<%
SUB FREE_ALL_SUB_HOUSE
	dim SQL	
	SQL="UPDATE hbol_master set is_sub='N',sub_to_no='' where ( elt_account_number="&elt_account_number&" OR coloder_elt_acct="& elt_account_number& " ) and isnull(is_sub,'')='Y' and isnull(sub_to_no,'')=N'"& vHBOL & "'"
	eltConn.Execute(SQL)
END SUB 




'SUB REMOVE_A_SUB_HOUSE_FROM_MASTER
	'dim SQL	
	'SQL="UPDATE hbol_master set is_sub='N',is_invoice_queued='Y', mawb_num='', sub_to_no='' where elt_account_number="&rELTACT&" and hawb_num='"& rSHAWB&"' "
	'eltConn.Execute(SQL)
'	RemoveSH
'END SUB 

SUB REMOVE_A_SUB_HOUSE_FROM_MASTER
	dim SQL	
	SQL="UPDATE hbol_master set is_sub='N',is_invoice_queued='Y', mbol_num='', sub_to_no='' where elt_account_number="&rELTACT&" and hbol_num=N'"& rSHAWB&"' "
	eltConn.Execute(SQL)
'	RemoveSH
END SUB 


SUB UPDATE_HAWB_TABLE( vHBOL )
	DIM tHBOL_Number
	Dim totalOC
	totalOC=0
	'**
	i=0
	for i=0 to NoItem-1
		totalOC=totalOC+aChargeAmt(i)
	next	
	'**

	if NewHBOL="yes" then
		SQL= "select * from hbol_master where elt_account_number = " & elt_account_number & " and HBOL_NUM=N'" & vHBOL & "'"
		rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
		rs("is_master_closed")="N"	
		vIsMasterClosed="N"
		
		If rs.EOF Then		
			rs.close
%>

<script type="text/jscript"> alert('HBOL number error.:'+'<%=vHBOL%>'); history.go(-1);</script>

<%			
		end if
		Save = "yes"
	else
			if Not vHBOL="" then
				SQL= "select * from hbol_master where elt_account_number = " & elt_account_number & " and hbol_num=N'" & vHBOL & "'"
				rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
				If rs.EOF then
					rs.AddNew
					rs("elt_account_number")=elt_account_number
					rs("hbol_num")=vHBOL
					rs("tran_date")=Now
					rs("is_master_closed")="N"	
					vIsMasterClosed="N"
				
				else
					if not TRIM(vDate)="" then
						rs("tran_date")=vDate
					end if
				end if
			else
				Save="No"
			end if
	end if
		
	IF NOT Save = "yes" THEN
		EXIT SUB
	END IF
       '----------------------------------------
        rs("is_master")=vCheckMH
        rs("is_sub")=vCheckSH
		
        if vCheckSH="Y" then           
            rs("sub_to_no")=vM_HAWB
			vCanbeMaster = false 
        else 
            rs("sub_no")=null
            rs("sub_to_no")=null
            vM_HAWB=""
        end if 		
		
		if vCheckMH="Y" then
		 	rs("sub_no")=null
         	rs("sub_to_no")=null		
		end if 
		
		IF GET_SHIPPER_ELT_ACCT(vShipperAcct) = elt_account_number THEN 
			rs("is_invoice_queued")="N"
			'response.Write("-----------Invoice queued?-------"&rs("is_invoice_queued"))
			CALL UPDATE_ALL_SUB_HOUSE_INFO("Y")			
		ELSE 
			rs("is_invoice_queued")="Y"
			'response.Write("------------Invoice queued?-------"&rs("is_invoice_queued"))
			CALL UPDATE_ALL_SUB_HOUSE_INFO("N")
		END IF 
		
		
		rs("booking_num")=vBookingNum
		rs("mbol_num")=vMBOL
		rs("agent_name")=vFFAgentName
		rs("agent_no")=vFFAgentAcct
		rs("agent_info")=vFFAgentInfo
		rs("shipper_name")=vShipperName
		rs("shipper_info")=vShipperInfo
		rs("shipper_acct_num")=vShipperAcct
		rs("consignee_name")=vConsigneeName
		rs("consignee_info")=vConsigneeInfo
		rs("consignee_acct_num")=vConsigneeAcct
		rs("notify_name")=vNotifyName
		rs("notify_info")=vNotifyInfo
		rs("notify_acct_num")=vNotifyAcct
		rs("export_ref")=vExportRef
		rs("forward_agent_info")=vForwardAgentInfo
		rs("origin_country")=vOriginCountry
		rs("dest_country")=vDestCountry
		rs("export_instr")=vExportInstr
		rs("loading_pier")=vLoadingPier
		rs("dimtext")=vDimText
		rs("move_type")=vMoveType
		if vConYes <> "Y" then vConYes = "N"
		rs("containerized")=vConYes
		rs("pre_carriage")=vPreCarriage
		rs("pre_receipt_place")=vPreReceiptPlace
		rs("export_carrier")=vExportCarrier
		rs("vessel_name")=vVN
		rs("loading_port")=vLoadingPort
		rs("unloading_port")=vUnloadingPort
		rs("delivery_place")=vDeliveryPlace
		rs("departure_date")=vDepartureDate
		rs("weight_cp")=vWeightCP
		rs("prepaid_other_charge")=vPrepaidOtherCharge
		rs("collect_other_charge")=vCollectOtherCharge
		rs("pieces")=vPieces
		rs("scale")="K"
		rs("gross_weight")=Round(vGrossWeight,0)
		rs("measurement")=vMeasurement
		'rs("length")=vLength
		'rs("width")=vWidth
		'rs("height")=vHeight
		'rs("chargeable_weight")=vChargeableWeight
		rs("charge_rate")=vChargeRate
		rs("total_weight_charge")=Round(vTotalWeightCharge,2)
		rs("desc1")=vDesc1
		rs("desc2")=vDesc2
		rs("desc3")=vDesc3
		rs("desc4")=vDesc4
		rs("desc5")=vDesc5
		'----------------------------------------------
		rs("lc")=vLC
	    rs("ci")=vCI
		rs("aes_xtn")=vAES
		rs("sed_stmt")=vSEDStmt
		'---------------------------------------------
		rs("manifest_desc")=vManifestDesc
		rs("dem_detail")=vDemDetail
		rs("show_prepaid_weight_charge")=vShowPrepaidWeightCharge
		rs("show_collect_weight_charge")=vShowCollectWeightCharge
		rs("show_prepaid_other_charge")=vShowPrepaidOtherCharge
		rs("show_collect_other_charge")=vShowCollectOtherCharge
		rs("declared_value")=vDeclaredValue
		rs("tran_by")=vBy
		rs("tran_place")=vPlace
		rs("last_modified")=Now
		rs("prepaid_invoiced")="N"
		rs("collect_invoiced")="N"
		rs("unit_qty")=vUnitQty
		
		'-------------------------------------------------------------for existing record in hbol table 
		rs("SalesPerson")=	vSalesPerson	
		rs("ModifiedBy")= session_user_lname
		rs("ModifiedDate")=Now	
		rs("total_other_charge")=totalOC
		'response.Write("aaaaaaaaaaaaaaaaaa" & vSalesPerson)	
		rs("colo")=vCOLO
		rs("colo_pay")=vCOLOPay
		rs("coloder_elt_acct")=vColoderAcct
		
		If vCheckMH ="Y" then 
			rs("sub_count")=vSubCount
			rs("sub_no")=null
			rs("sub_to_no")=null				
			GET_WEIGHT_CHARGE_INFO_FOR_MASTER_HOUSE vHBOL,"yes"
			rs("sub_count")=vSubCount
		end if 
		
		If vCheckMH ="N" and vDiscardMH="Y" then
			rs("is_master")="N"
			rs("sub_count")=0
			CALL FREE_ALL_SUB_HOUSE
		end if 

		
		'--------------------------------------------------------------
		rs.Update
		rs.Close
		
		
'update next hbol number in user_prefix table
'///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		if NewForm="Y" then
			pos=0
			pos=instr(vHBOL,"-")
			if pos>0 then
				tPrefix=Mid(vHBOL,1,pos-1)
				tHBOL_Number=Mid(vHBOL,pos+1,32)
			else
				tPrefix="NONE"
				tHBOL_Number=vHBOL
			end if
			
			SQL= "select * from user_prefix where elt_account_number=" & elt_account_number & " and type='HBOL' and prefix=N'" & tPrefix & "'"
			rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
			If Not rs.EOF Then
				rs("next_no")=checkblank(tHBOL_Number,0)+1
				rs.Update
				
				i=0
				for i=0 to pIndex
					if tPrefix=aHBOLPrefix(i) then
						aNextHBOL(i)=checkblank(tHBOL_Number,0)+1
					end if
				next
			end if
			rs.Close
		end if
		
		SQL= "delete from hbol_other_charge where elt_account_number = " & elt_account_number & " and hbol_num=N'" & vHBOL & "'"
		eltConn.Execute SQL
		ii=1
		
		i=0
		for i=0 to NoItem-1
			if Not aChargeItem(i)=0 Or not aChargeAmt(i)=0 Or Not aChargeCost(i)=0 then
				SQL= "select * from hbol_other_charge where elt_account_number = " & elt_account_number & " and hbol_num=N'" & vHBOL & "' and tran_no=" & i
				rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
				rs.AddNew
				rs("elt_account_number")=elt_account_number
				rs("hbol_num")=vHBOL
				rs("tran_no")=i
				rs("coll_prepaid")=aChargeCP(i)
				rs("charge_code")=aChargeItem(i)
				rs("charge_desc")=aChargeItemName(i)
				rs("charge_amt")=aChargeAmt(i)
				'rs("vendor_num")=aChargeVendor(i)
				'rs("cost_amt")=aChargeCost(i)
				
				rs.Update
				rs.Close
				ii=ii+1
			end if
		next	
		
		
		NewHBOL=""
				
END SUB



FUNCTION GET_SHIPPER_ELT_ACCT(ShipperAcct)
	dim rs1
	set rs1= Server.CreateObject("ADODB.Recordset")
	dim SQL
	
	SQL="select dba_name, agent_elt_acct from organization where org_account_number = '"&ShipperAcct&"' and elt_account_number="&elt_account_number
	
	'response.Write("------------"&SQL)
	rs1.CursorLocation = adUseClient
	rs1.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs1.activeConnection = Nothing
	if not rs1.eof then 
		'response.Write(rs1("dba_name"))
		GET_SHIPPER_ELT_ACCT = checkBlank(rs1("agent_elt_acct").Value,"-1")
	end if 	
	rs1.close
	set rs1=Nothing	
END FUNCTION 



%>
<%
'// by ig 07/14/2006
function format(ByVal szString, ByVal Expression)
	if len(szString) < len(Expression) then
			format = left(expression, len(szString)) & szString
	else
			format = szString
	end if
end function
%>
<%
Sub INVOICE_QUEUE_REFRESH( tvHAWB,vBookingNum  )

DIM arr_queue_id(100),qu_index

		qu_index = 0				
		SQL="select queue_id from invoice_queue where elt_account_number=" & elt_account_number & " and hawb_num=N'" & tvHAWB & "'" & " and invoiced = 'N' "
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing
		Do While Not rs.EOF
			arr_queue_id(qu_index) = rs("queue_id")
			qu_index = qu_index + 1										
			rs.MoveNext
		Loop
		rs.Close

	vFFAgentAcct = checkBlank(Request("hFFAgentAcct"),0)

SQL="select queue_id from invoice_queue where elt_account_number=" & elt_account_number & " and agent_shipper='A' and mawb_num=N'" & vBookingNum  & "' and invoiced = 'N' " & " and bill_to_org_acct=" & vFFAgentAcct

		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing
		Do While Not rs.EOF
			arr_queue_id(qu_index) = rs("queue_id")
			qu_index = qu_index + 1										
			rs.MoveNext
		Loop
		rs.Close

	for iii = 0 to qu_index - 1
		SQL= "delete invoice_queue where elt_account_number=" & elt_account_number & "and invoiced = 'N' and queue_id=" & arr_queue_id(iii)
		eltConn.Execute SQL
	next

'// Refresh Invoice_queue according to HBOL and Agent_no
		SQL= "delete invoice_queue where elt_account_number=" & elt_account_number & " and agent_shipper='A' and mawb_num=N'" & vBookingNum & "' and invoiced = 'N' and bill_to_org_acct not in (select agent_no from hbol_master where elt_account_number=" & elt_account_number & " and booking_num = N'" & vBookingNum & "' group by agent_no )"
		eltConn.Execute SQL

End Sub
		
%>
<%
SUB GET_NEW_HAWB_NUM

	SQL= "select * from hbol_master where elt_account_number = " & elt_account_number & " and hbol_num=N'" & vHBOL & "'"
	rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	If rs.EOF=true Then
			rs.AddNew
			rs("elt_account_number")=elt_account_number
			rs("hbol_num")=vHBOL
			rs("tran_date")=Now
			'--------------------------------------------------for new record in hbol_master
			rs("CreatedBy")=session_user_lname	
			rs("CreatedDate")=Now
			rs("SalesPerson")=	vSalesPerson	
	else
		rs.close
	end if

END SUB
%>
<%
SUB GET_HAWB_HEADER_INFO_FROM_SCREEN	
'-----------------------------------------

	vCheckSH=checkBlank(Request("hCheckSH"),"N")
	vCheckMH=checkBlank(Request("hCheckMH"),"N")
	vDiscardMH=Request("hDiscardMH")
	vSubCount=checkBlank(Request("hSubCount"),0)

	vM_HAWB=Request("hM_HAWB")
	
'-----------------------------------------
	vTotalPrepaid=0
	vTotalCollect=0
	NoItem=Request("hNoItem")
    NoItem=checkblank(NoItem,0)

	if NewHBOL = "" then
		vHBOL=Request("txtHBOL")
	end if

'// Avoid data saving when back or refresh	
	if NOT tNo = TranNo then vHBOL = Session("HBOLTMP")
	
	vMBOL=Request("txtMBOL")
	
'--------------------------------------------------------------------------------------------------------
     vSalesPerson=Request("lstSalesRP")
    if vSalesPerson = "none" then
       Call getDefaultSalesPersonFromDB
    end if 
'--------------------------------------------------------------------------------------------------------

     
	vBookingNum=Request("hSearchNum")
	vFFAgentName=Request("lstFFAgent")
	vFFAgentInfo=Request("hFFAgentInfo")
	vFFAgentAcct=checkblank(Request("hFFAgentAcct"),0)

	vShipperName=Request("lstShipperName")
	vShipperInfo=Request("txtShipperInfo")
	vShipperAcct=checkblank(Request("hShipperAcct"),0)

	vConsigneeName=Request("lstConsigneeName")
	vConsigneeInfo=Request("txtConsigneeInfo")
	vConsigneeAcct=checkblank(Request("hConsigneeAcct"),0)

	vNotifyName=Request("lstNotifyName")
	vNotifyInfo=Request("txtNotifyInfo")
	vNotifyAcct=checkblank(Request("hNotifyAcct"),0)
	
	vExportRef=Request("txtExportRef")
	'---------------------------------------------------
	vLC=Request("txtLC")
	vCI=Request("txtCI")
	vAES = checkBlank(Request.Form.Item("txtAES"),"")
	
    If vAES = "" Then
	    vSEDStmt = Request.Form.Item("txtSEDStatement")
	Else
	    vSEDStmt = ""
	End If
	'---------------------------------------------------
	vForwardAgentInfo=Request("txtForwardAgentInfo")
	vOriginCountry=Request("txtOriginCountry")
	vDestCountry=Request("hDestCountry")
	vExportInstr=Request("txtExportInstr")
	vLoadingPier=Request("txtLoadingPier")
	vDimText=Request("dimtext")
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
'	vDepartureDate = CHECK_EX_DATE	( vMBOL, vDepartureDate )

	vWeightCP=Request("lstWeightCP")
	vPieces=Request("txtPieces")
	if vPieces="" then vPieces=0
	vScale=Request("lstScale")
	vGrossWeight=Request("txtGrossWeight")
	if Not vGrossWeight="" then 
		vGWLB=Round(ConvertAnyValue(vGrossWeight,"Amount",0)*2.204,2)
	else
		vGrossWeight=0
		vGWLB=0
	end if
	vMeasurement=Request("txtMeasurement")
	if Not vMeasurement="" then 
		vMCFT=Round(ConvertAnyValue(vMeasurement,"Amount",0)*35.314666721,2)
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
	vTotalWeightCharge = checkBlank(Request("txtTotalWeightCharge"),0)
	
	if vWeightCP="P" then
		vTotalPrepaid = vTotalPrepaid + vTotalWeightCharge
		
		'response.Write("----"&vTotalPrepaid)
	else
		vTotalCollect = vTotalCollect + vTotalWeightCharge
	end if
	
	vDesc1=Request("txtDesc1")
	vDesc2=Request("txtDesc2")
	vDesc3=Request("txtDesc3")
	vDesc5=Request("txtDesc5")
	vDesc4=Request("txtDesc4")
	vManifestDesc=Request("txtManifestDesc")
	vDemDetail=Request("hDemDetail")
	vShowPrepaidWeightCharge=Request("cShowPWeightCharge")
	vShowCollectWeightCharge=Request("cShowCWeightCharge")
	vShowPrepaidOtherCharge=Request("cShowPOtherCharge")
	vShowCollectOtherCharge=Request("cShowCOtherCharge")
	
	i=0
	for i=0 to NoItem-1
		aChargeNo(i)=Request("hChargeNo" & i)
		aChargeCP(i)=Request("lstOtherChargeCP" & i)
		if aChargeCP(i)="C" then
			vCollectOtherCharge="Y"
		else
			vPrepaidOtherCharge="Y"
		end if
		aChargeItemName(i)=Request("hItemName" & i)
		
		aChargeItem(i)=Request("lstChargeItem" & i)
		pos=0
		pos=Instr(aChargeItem(i),"-")
		if pos>0 then
			aChargeItem(i) = ConvertAnyValue(left(aChargeItem(i),pos-1),"Long",0)
		else
			On Error Resume Next:
			aChargeItem(i) = ConvertAnyValue(Request("lstChargeItem" & i),"Long",0)
		end if
		
		aChargeAmt(i)=Request("txtChargeAmt" & i)
		if aChargeAmt(i)="" then aChargeAmt(i)=0
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
		
		i=0
		for i=dItemNo to NoItem-1
			aChargeNo(i)=aChargeNo(i+1)
			aChargeCP(i)=aChargeCP(i+1)
			aChargeItem(i)=aChargeItem(i+1)
			aChargeItemName(i)=aChargeItemName(i+1)
			aChargeAmt(i)=aChargeAmt(i+1)
		next
		NoItem=NoItem-1
	end if

	
	i=0
	for i=0 to NoItem-1
		if aChargeCP(i)="P" then
			vTotalPrepaid=vTotalPrepaid+aChargeAmt(i)
		else
			vTotalCollect=vTotalCollect+aChargeAmt(i)
		end if
	next
	
	vTotalPrepaid = FormatAmount(vTotalPrepaid)
	vTotalCollect = FormatAmount(vTotalCollect)
	
	tIndex=NoItem
	vUnitQty=Request("lstUnitQty")
	
	vCOLO=Request("cCOLO")
	if vCOLO="" or isEmpty(vCOLO) then 
		vCOLO="N"
	end if 
	if vCOLO="Y" then
		vCOLOPay=Request("lstCOLOPAy")
	else
		vCOLOPay="N"
		vCOLO="N"
	end if
	vColoderAcct = ConvertAnyValue(Request("lstColoder"),"Amount",0)
	
	vSONum = Request.Form("hSONum")
	vPONum = Request.Form("hPONum")
END SUB	
%>
<%
Function CHECK_EX_DATE ( vMBOL, ArrivalDept ) 
Dim tmpSQL

If Trim(vMAWB) = "" Then
	CHECK_EX_DATE = ArrivalDept
	Exit function
End If

If ( Not IsDate(ArrivalDept)) Or ( Trim(ArrivalDept) = "" ) Or ( ArrivalDept = "1/1/1900" )  Then
	tmpSQL="select departure_date as export_date from ocean_booking_number where elt_account_number=" & elt_account_number & " AND mbol_num=N'"&vMBOL&"'"
	rs3.Open tmpSQL, eltConn, , , adCmdText
	If Not rs3.EOF And IsNull(rs3("export_date"))=False Then
		ArrivalDept=rs3("export_date")
	Else
		ArrivalDept=""
	End If
	rs3.close
End If

CHECK_EX_DATE = ArrivalDept

End Function
%>
<%
SUB GET_HAWB_PREFIX_FROM_USER_PROFILE
'get Hawb prefix from user profile
SQL= "select prefix,next_no from user_prefix where elt_account_number = " & elt_account_number & " and type='HBOL' order by seq_num"
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
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
SUB CHECK_INVOICE_STATUS_HAWB( tvHAWB, t_elt_account_number )
DIM invoiceNUM(100),ivIndex

		ivIndex = 0				
if tvHAWB = "" Then Exit sub
		SQL="select invoice_no from invoice where elt_account_number=" & t_elt_account_number & " and air_ocean <> 'A' and hawb_num=N'" & tvHAWB & "'"
		rs3.CursorLocation = adUseClient
		rs3.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs3.activeConnection = Nothing

		Do While Not rs3.EOF
			invoiceNUM(ivIndex) = rs3("invoice_no")
			ivIndex = ivIndex + 1										
			rs3.MoveNext
		Loop
		rs3.Close

		if ivIndex = 0	then
			SQL= "select invoice_no from invoice_hawb where elt_account_number = " & elt_account_number & " and hawb_num=N'" & tvHAWB & "'"
			rs3.CursorLocation = adUseClient
			rs3.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
			Set rs3.activeConnection = Nothing

			Do While Not rs3.EOF
				invoiceNUM(ivIndex) = rs3("invoice_no")
				ivIndex = ivIndex + 1										
				rs3.MoveNext
			Loop
			rs3.Close

			if ivIndex = 0	then
				SQL="select queue_id from invoice_queue where elt_account_number=" & t_elt_account_number & " and hawb_num=N'" & tvHAWB & "'" & " and invoiced = 'Y' "
				rs3.CursorLocation = adUseClient
				rs3.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
				Set rs3.activeConnection = Nothing
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
<%

'---------------------------------------------------------------------------------------------------------------------------------------------
SUB getDefaultSalesPersonFromDB
  if isnull(vShipperAcct) or vShipperAcct = 0 then
   vSalesPerson ="" 
  else 
   SQL= "select SalesPerson from organization where elt_account_number = "& elt_account_number &" and org_account_number = "& vShipperAcct
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
       if not rs.EOF then	
         vSalesPerson = rs("SalesPerson")
       else vSalesPerson ="" 
       end if   
   rs.close
 end if 
END SUB
'----------------------------------------------------------------------------------------------------------------------------------------------


'----------------------------------------------------------------------------------------------------------------------------------------------

SUB GET_SALES_PERSONS_FROM_USERS

   SQL= "select code from all_code where elt_account_number = " & elt_account_number & " and type=22 order by code"
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
    SRIndex=0
	    do While Not rs.EOF
		    aSRName(SRIndex)=rs("code")	
		    rs.MoveNext
		    SRIndex=SRIndex+1
	    loop
	    rs.Close
END SUB 

'----------------------------------------------------------------------------------------------------------------------------------------------

%>
<!--  #include file="../include/recent_file.asp" -->
<body link="336699" vlink="336699" topmargin="0">
    <!-- tooltip placeholder -->
    <div id="tooltipcontent">
    </div>
    <!-- placeholder ends -->
    <form method="post" name="form1">
        <input type="image" style="position: absolute; visibility: hidden" onclick="return false;" />
        <input type="hidden" id="hSONum" name="hSONum" value="<%=vSONum %>" />
        <input type="hidden" id="hPONum" name="hPONum" value="<%=vPONum %>" />
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td colspan="2" align="left" valign="middle" class="pageheader">
                    New/Edit HOUSE BILL OF LADING (HOUSE B/L)
                </td>
                <td width="51%" align="right" valign="middle">
                    <span class="bodyheader style10">HOUSE B/L NO. </span>
                    <input type="text" name="txtqHBOL" class="lookup" value="<%=checkBlank(vqHBOL,"Search Here")%>"
                        onkeydown="javascript: if(event.keyCode == 13) { lookup(); }" onfocus="javascript: this.value='';this.style.color='#000000'"
                        size="24" tabindex="-1" /><img src="../images/icon_search.gif" name="B1" width="33"
                            height="27" align="absmiddle" style="cursor: hand" onclick="lookup()" /></td>
            </tr>
        </table>
        <div class="selectarea">
            <table width="95%" height="40" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                    <td width="45%">
                    </td>
                    <td width="55%" align="right" valign="bottom">
                        <% If vHBOL <> "" Then %>
                        <div id="print">
                            <a href="javascript:;" onclick="SetCostItems(); return false;" tabindex="-1">Cost Items</a>
                            <img src="/iff_main/ASP/Images/button_devider.gif" alt="" />
                            <a href="javascript:;" onclick="SetCreditNote(); return false;" tabindex="-1">Credit Note</a>
                            <img src="/iff_main/ASP/Images/button_devider.gif" alt="" />
                             <a href="javascript:EditClick('<%=vHAWB %>','<%=vBookingNum %>');" tabindex="-1">
                            
                                <img src="/iff_main/ASP/Images/icon_createhouse.gif" alt="Click here to create SED"
                                    width="25" height="26" style="margin-right: 10px" />Create AES</a>
                            <img src="/iff_main/ASP/Images/button_devider.gif" alt="" />
                            <a href="javascript:;" onclick="NewPrintVeiw(); return false;">
                                <img src="/iff_main/ASP/Images/icon_printer_preview.gif" align="absbottom" alt="" />House
                                B/L</a></div>
                        <% End If %>
                    </td>
                </tr>
            </table>
        </div>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#6D8C80"
            bgcolor="#6D8C80" class="border1px">
            <tr>
                <td>
                    <!-- start of scroll bar -->
                    <input type="hidden" name="scrollPositionX">
                    <input type="hidden" name="scrollPositionY">
                    <!-- end of scroll bar -->
                    <input type="hidden" name="hCheckSH" value="<%= vCheckSH %>">
                    <input type="hidden" name="hCheckMH" value="<%= vCheckMH %>">
                    <input type="hidden" name="hM_HAWB" value="<%= vM_HAWB%>">
                    <input type="hidden" name="hDiscardMH">
                    <input type="hidden" name="hSubCount">
                    <input type="hidden" name="hIs_consoled" value="<%= is_consoled %>">
                    <input type="hidden" name="hMaster_Weight_Charge" value="<%= vMaster_Weight_Charge %>">
                    <input type="hidden" name="hMaster_Gross_Weight" value="<%= vMaster_Gross_Weight %>">
                    <input type="hidden" name="hMaster_Chargeable_Weight" value="<%= vMaster_Chargeable_Weight %>">
                    <input type="hidden" name="hMaster_Pieces" value="<%= vMaster_Pieces %>">
                    <input type="hidden" name="hNewHBOL" value="<%= NewHBOL %>">
                    <input type="hidden" name="hHBOLPrefix" value="<%= vHBOLPrefix %>">
                    <input type="hidden" name="hFFAgentInfo" value="<%= vFFAgentInfo %>">
                    <input type="hidden" name="hNoItem" value="<%= tIndex %>">
                    <input type="hidden" name="hDepartureDate" value="<%= vDepartureDate %>">
                    <input type="hidden" name="hDestCountry" value="<%= vDestCountry %>">
                    <input type="hidden" name="hVesselName" value="<%= vVN %>">
                    <input type="hidden" name="hIs_invoice_queued" value="<%=is_invoice_queued%>">
                    <input type="hidden" name="hPickupNumber" id="hPickupNumber" value="" />
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td colspan="2" height="24" align="left" valign="middle" bgcolor="BFD0C9" class="bodyheader">
                                <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="26%">
                                        </td>
                                        <td width="48%" align="center" valign="middle">
                                            <img src="../images/button_save_medium.gif" width="46" height="18" onclick="if('<%=vCheckSH%>'=='Y'){CheckIfMasterHasSameMAWB();}else{SaveClick('<%= TranNo %>','no')}"
                                                style="cursor: hand"></td>
                                        <td width="13%" align="right" valign="middle">
                                            <a href="/iff_main/ASP/ocean_export/new_edit_hbol.asp" tabindex="-1">
                                                <img src="/iff_main/ASP/Images/button_new.gif" width="42" height="17" border="0"
                                                    style="cursor: hand"></a></td>
                                        <td width="13%" align="right" valign="middle">
                                            <img src="../images/button_delete_medium.gif" width="51" height="17" name="bDelete"
                                                onclick="DeleteHBOL()" style="cursor: hand"></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" height="1" bgcolor="#6D8C80">
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF"
                                    class="bodycopy">
                                    <tr align="left" valign="middle" bgcolor="BFD0C9">
                                        <td height="20" bgcolor="#f3f3f3" style="border-bottom: 2px solid #6D8C80">
                                            <br />
                                            <table width="60%" border="0" align="center" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td height="28" align="right">
                                                        <span class="bodyheader">
                                                            <img src="/iff_main/ASP/Images/required.gif" align="absbottom">Required field</span></td>
                                                </tr>
                                            </table>
                                            <table width="60%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#6D8C80"
                                                bgcolor="#FFFFFF" class="border1px" style="padding-left: 10px">
                                                <tr bgcolor="#E0EDE8">
                                                    <td width="62%" height="20">
                                                        <span class="style2">House B/L No.</span></td>
                                                    <td width="38%" bgcolor="#E0EDE8">
                                                        &nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td height="24" align="left" valign="middle">
                                                        <select name="lstHBOLPrefix" size="1" class="smallselect" onchange="PrefixChange()">
                                                            <%i=0%>
                                                            <% For i=0 To pIndex-1 %>
                                                            <option value="<%= aNextHBOL(i) %>" <% if vHBOLPrefix=aHBOLPrefix(i) then response.write("selected") %>>
                                                                <%= aHBOLPrefix(i) %>
                                                            </option>
                                                            <%  Next  %>
                                                        </select>
                                                        <input name="txtHBOL" class="readonlybold" value="<%= vHBOL %>" size="17" readonly="true"
                                                            tabindex="-1"></td>
                                                    <td>
                                                        &nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2" height="1" bgcolor="#6D8C80">
                                                    </td>
                                                </tr>
                                                <tr bgcolor="#F3F3F3">
                                                    <td height="20">
                                                        <strong><span class="bodyheader">
                                                            <img src="/iff_main/ASP/Images/required.gif" align="absbottom"></span>Agent</strong></td>
                                                    <td>
                                                        <span class="bodyheader">Booking No. </span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <!-- Start JPED -->
                                                        <input type="hidden" id="hFFAgentAcct" name="hFFAgentAcct" value="<%=vFFAgentAcct %>" />
                                                        <div id="lstFFAgentDiv">
                                                        </div>
                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                            <tr>
                                                                <td>
                                                                    <input type="text" autocomplete="off" id="lstFFAgent" name="lstFFAgent" value="<%=vFFAgentName %>"
                                                                        class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                        border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Agent','lstFFAgentChange')"
                                                                        onfocus="initializeJPEDField(this);" /></td>
                                                                <td>
                                                                    <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstFFAgent','Agent','lstFFAgentChange')"
                                                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                        border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                                <td>
                                                                    <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                        onclick="quickAddClient('hFFAgentAcct','lstFFAgent','hFFAgentInfo')" /></td>
                                                            </tr>
                                                        </table>
                                                        <!-- End JPED -->
                                                    </td>
                                                    <td valign="top">
                                                        <!-- Start JPED -->
                                                        <input type="hidden" id="hSearchNum" name="hSearchNum" value="<%=vBookingNum %>" />
                                                        <div id="lstSearchNumDiv">
                                                        </div>
                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                            <tr>
                                                                <td>
                                                                    <input type="text" autocomplete="off" id="lstSearchNum" name="lstSearchNum" value="<%=vBookingNum %>"
                                                                        class="shorttextfield" style="width: 140px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                        border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="searchNumFill(this,'O','lstSearchNumChange',200);"
                                                                        onfocus="initializeJPEDField(this);" /></td>
                                                                <td>
                                                                    <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="searchNumFillAll('lstSearchNum','O','lstSearchNumChange',200);"
                                                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                        border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                            </tr>
                                                        </table>
                                                        <!-- End JPED -->
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        &nbsp;</td>
                                                    <td height="32" valign="middle">
                                                        <a href="javascript:;" onclick="MBOLEditClick(); return false;" class="goto">
                                                            <img src="/iff_main/ASP/Images/icon_goto.gif" width="36" height="21" align="absbottom">Go
                                                            to Master B/L</a></td>
                                                </tr>
                                            </table>
                                            <br>
                                            <table width="60%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#6D8C80"
                                                bgcolor="#F3F3F3" class="border1px" style="padding-left: 10px">
                                                <tr bgcolor="#F3F3F3" <% 'if elt_account_number <> 20011000 then response.Write("style='display:none'") end if %>>
                                                    <td height="18" colspan="2" valign="middle" bgcolor="#F3F3F3">
                                                        <% If vCheckMH = "Y" Then %>
                                                        Master House
                                                        <% End If %>
                                                        <span <% if vCheckSH="Y" then response.write("style='display:none'")  %>class="goto">
                                                            <a href="javascript:;" <% if vCheckMH="Y" then response.Write(" onClick='DiscardMasterHouse();return false'") else response.Write("onClick='setShipperWithAccountHolder(); return false;'") %>>
                                                                <% if vCheckMH="Y" then response.Write("Revert to Regular House") else response.Write("Save as Master House") %>
                                                            </a></span>
                                                    </td>
                                                </tr>
                                                <tr bgcolor="#F3F3F3">
                                                    <td height="32" colspan="2" valign="middle" id="td_mhlink" style="<% if vM_HAWB <>"" then response.Write("") else response.Write("display:none")  end if %>">
                                                        <span class="goto"><a href="javascript:;" onclick="goToMasterHouse()">
                                                            <img src="/iff_main/ASP/Images/icon_goto.gif" align="absbottom">Go to Master House:
                                                            <%response.Write(vM_HAWB)%>
                                                        </a></span>
                                                    </td>
                                                </tr>
                                                <tr bgcolor="#FFFFFF">
                                                    <td width="40%">
                                                        <input type="checkbox" name="cCOLO" value="Y" <% if vCOLO="Y" then response.write("checked") %>
                                                            onclick="COLOClick()" />
                                                        <strong>Coload</strong>
                                                        <% if mode_begin then %>
                                                        <div style="width: 21px; display: inline; vertical-align: middle" onmouseover="showtip('Click to make this a Coload.');"
                                                            onmouseout="hidetip()">
                                                            <img src="../Images/button_info.gif" align="texttop" class="bodylistheader"></div>
                                                        <% end if %>
                                                        <img src="/iff_main/ASP/Images/spacer.gif" width="3" height="10">
                                                        <select name="lstCOLOPay" size="1" class="smallselect" style="width: 105px; visibility: <% if Not vCOLO="Y" then response.write("hidden") %>">
                                                            <option value="P">COLO Prepaid</option>
                                                            <option value="C" <% if vCOLOPay="C" then response.write("selected") %>>COLO Collect</option>
                                                        </select>
                                                    </td>
                                                    <td width="59%">
                                                        <strong>Coloader
                                                            <select name="lstColoder" class="smallselect" style="width: 200px;">
                                                                <%i=0%>
                                                                <% for i=0 to coIndex-1 %>
                                                                <option value="<%= aColoderAcct(i) %>" <% if vColoderAcct=aColoderAcct(i) then response.write("selected") %>>
                                                                    <%= aColoderName(i) %>
                                                                </option>
                                                                <% next %>
                                                            </select>
                                                        </strong>
                                                        <% if mode_begin then %>
                                                        <div style="width: 21px; display: inline; vertical-align: middle" onmouseover="showtip('Select the company you wish to coload with.  This list is configured in the C/P Profile screen.');"
                                                            onmouseout="hidetip()">
                                                            <span class="bodyheader">
                                                                <img src="../Images/button_info.gif" align="top" class="bodylistheader"></span></div>
                                                        <% end if %>
                                                    </td>
                                                </tr>
                                            </table>
                                            <br>
                                            <br>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                                <tr>
                                                    <td height="20" colspan="2" valign="top" bgcolor="#FFFFFF">
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="bodycopy" style="padding-left: 10px">
                                                            <tr>
                                                                <td height="18" bgcolor="#E0EDE8">
                                                                    <strong><span class="bodyheader">
                                                                        <img src="/iff_main/ASP/Images/required.gif" align="absbottom"></span>Exporter</strong></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <!-- Start JPED -->
                                                                    <input type="hidden" id="hShipperAcct" name="hShipperAcct" value="<%=vShipperAcct %>" />
                                                                    <div id="lstShipperNameDiv">
                                                                    </div>
                                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                                        <tr>
                                                                            <td>
                                                                                <input type="text" autocomplete="off" id="lstShipperName" name="lstShipperName" value="<%=vShipperName %>"
                                                                                    class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                                    border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Shipper','lstShipperNameChange')"
                                                                                    onfocus="initializeJPEDField(this);" /></td>
                                                                            <td>
                                                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstShipperName','Shipper','lstShipperNameChange')"
                                                                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                                    border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                                            <td>
                                                                                <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                                    onclick="quickAddClient('hShipperAcct','lstShipperName','txtShipperInfo')" /></td>
                                                                        </tr>
                                                                    </table>
                                                                    <textarea id="txtShipperInfo" name="txtShipperInfo" class="monotextarea" cols=""
                                                                        rows="5" style="width: 300px"><%=vShipperInfo %></textarea>
                                                                    <!-- End JPED -->
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="18" bgcolor="#f3f3f3">
                                                                    <strong>Consigned to</strong></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <!-- Start JPED -->
                                                                    <input type="hidden" id="hConsigneeAcct" name="hConsigneeAcct" value="<%=vConsigneeAcct %>" />
                                                                    <div id="lstConsigneeNameDiv">
                                                                    </div>
                                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                                        <tr>
                                                                            <td>
                                                                                <input type="text" autocomplete="off" id="lstConsigneeName" name="lstConsigneeName"
                                                                                    value="<%=vConsigneeName %>" class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9;
                                                                                    border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;"
                                                                                    onkeyup="organizationFill(this,'Consignee','lstConsigneeNameChange')" onfocus="initializeJPEDField(this);" /></td>
                                                                            <td>
                                                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstConsigneeName','Consignee','lstConsigneeNameChange')"
                                                                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                                    border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                                            <td>
                                                                                <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                                    onclick="quickAddClient('hConsigneeAcct','lstConsigneeName','txtConsigneeInfo')" /></td>
                                                                        </tr>
                                                                    </table>
                                                                    <textarea id="txtConsigneeInfo" name="txtConsigneeInfo" class="monotextarea" cols=""
                                                                        rows="5" style="width: 300px"><%=vConsigneeInfo %></textarea>
                                                                    <!-- End JPED -->
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="18" bgcolor="#f3f3f3">
                                                                    <strong>Notify Party/Intermediate Consignee</strong></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <!-- Start JPED -->
                                                                    <input type="hidden" id="hNotifyAcct" name="hNotifyAcct" value="<%=vNotifyAcct %>" />
                                                                    <div id="lstNotifyNameDiv">
                                                                    </div>
                                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                                        <tr>
                                                                            <td>
                                                                                <input type="text" autocomplete="off" id="lstNotifyName" name="lstNotifyName" value="<%= GetBusinessName(checkBlank(vNotifyAcct,0)) %>"
                                                                                    class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                                    border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Notify','lstNotifyNameChange')"
                                                                                    onfocus="initializeJPEDField(this);" /></td>
                                                                            <td>
                                                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstNotifyName','Notify','lstNotifyNameChange')"
                                                                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                                    border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                                            <td>
                                                                                <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                                    onclick="quickAddClient('hNotifyAcct','lstNotifyName','txtBillToInfo')" /></td>
                                                                        </tr>
                                                                    </table>
                                                                    <textarea id="txtNotifyInfo" name="txtNotifyInfo" class="monotextarea" cols="" rows="5"
                                                                        style="width: 300px"><%=vNotifyInfo %></textarea>
                                                                    <!-- End JPED -->
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                    <td colspan="3" valign="top" bgcolor="#FFFFFF">
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                                            <tr>
                                                                <td height="18" bgcolor="#E0EDE8">
                                                                    <strong>Export Reference</strong></td>
                                                            </tr>
                                                            <tr style="padding-bottom: 45px">
                                                                <td>
                                                                    <textarea wrap="hard" name="txtExportRef" cols="45" rows="3" class="monotextarea"><%= vExportRef %></textarea></td>
                                                            </tr>
                                                            <tr>
                                                                <td height="18" bgcolor="#f3f3f3">
                                                                    <strong>Forwarding Agent</strong></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <textarea name="txtForwardAgentInfo" wrap="hard" cols="45" rows="3" class="monotextarea"><%= vForwardAgentInfo %></textarea></td>
                                                            </tr>
                                                            <tr>
                                                                <td height="18" bgcolor="#f3f3f3">
                                                                    <strong>Point (State) of Origin or FTZ No.</strong></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="padding-bottom: 9px">
                                                                    <input name="txtOriginCountry" class="shorttextfield" maxlength="32" value="<%= vOriginCountry %>"></td>
                                                            </tr>
                                                            <tr>
                                                                <td height="18" bgcolor="#f3f3f3">
                                                                    <strong>Domestic Routing/Export Instructions</strong></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <textarea name="txtExportInstr" wrap="hard" cols="45" rows="5" class="monotextarea"><%= vExportInstr %></textarea></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr align="left" valign="middle">
                                                    <td width="22%" height="20" bgcolor="#f3f3f3" style="padding-left: 10px">
                                                        <strong>Pre-Carriage By </strong>
                                                    </td>
                                                    <td width="24%" bgcolor="#f3f3f3">
                                                        <strong>Place of Receipt By Pre-Carrier</strong></td>
                                                    <td colspan="3" bgcolor="#FFFFFF">
                                                        &nbsp;</td>
                                                </tr>
                                                <tr align="left" valign="middle">
                                                    <td bgcolor="#FFFFFF" style="padding-left: 10px">
                                                        <input name="txtPreCarriage" maxlength="64" class="shorttextfield" value="<%= vPreCarriage %>"
                                                            size="32" /></td>
                                                    <td bgcolor="#FFFFFF">
                                                        <input name="txtPreReceiptPlace" class="shorttextfield" maxlength="64" value="<%= vPreReceiptPlace %>"
                                                            size="32" />
                                                    </td>
                                                    <td colspan="3" bgcolor="#FFFFFF">
                                                        &nbsp;</td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#f3f3f3">
                                                    <td height="20" style="padding-left: 10px">
                                                        <strong>Exporting Carrier</strong></td>
                                                    <td>
                                                        <strong>Port of Loading/Export</strong></td>
                                                    <td colspan="3">
                                                        <strong>Loading Pier/Terminal</strong></td>
                                                </tr>
                                                <tr align="left" valign="middle">
                                                    <td style="padding-left: 10px">
                                                        <input name="txtExportCarrier" type="text" maxlength="64" class="shorttextfield"
                                                            value="<%= vExportCarrier %>" size="32" />
                                                    </td>
                                                    <td>
                                                        <input name="txtLoadingPort" type="text" class="shorttextfield" maxlength="64" value="<%= vLoadingPort %>"
                                                            size="32" />
                                                    </td>
                                                    <td width="21%">
                                                        <input name="txtLoadingPier" class="shorttextfield" maxlength="64" value="<%= vLoadingPier %>"
                                                            size="32" />
                                                    </td>
                                                    <td width="15%">
                                                        &nbsp;</td>
                                                    <td width="18%">
                                                        &nbsp;</td>
                                                </tr>
                                                <tr align="left" valign="top" bgcolor="#f3f3f3">
                                                    <td height="20" valign="middle" style="padding-left: 10px">
                                                        <strong>Foreign Port of Unloading</strong>
                                                        <br>
                                                    </td>
                                                    <td valign="middle">
                                                        <strong>Place of Delivery By On-Carrier</strong></td>
                                                    <td valign="middle">
                                                        <strong>Type of Move</strong></td>
                                                    <td colspan="2" valign="middle">
                                                        <strong>Containerized</strong></td>
                                                </tr>
                                                <tr align="left" valign="middle">
                                                    <td style="padding-left: 10px">
                                                        <input name="txtUnloadingPort" type="text" maxlength="64" class="shorttextfield"
                                                            value="<%= vUnloadingPort %>" size="32" />
                                                    </td>
                                                    <td>
                                                        <input name="txtDeliveryPlace" class="shorttextfield" maxlength="64" value="<%= vDeliveryPlace %>"
                                                            size="32" />
                                                    </td>
                                                    <td>
                                                        <input name="lstMoveType" type="text" class="shorttextfield" maxlength="32" value="<%= vMoveType %>"
                                                            size="32" />
                                                    </td>
                                                    <td>
                                                        <input type="checkbox" name="cConYes" value="Y" onclick="ConYes()" <% if vConYes="Y" then response.write("checked") %>>
                                                        &nbsp; Yes &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                        <input type="checkbox" name="cConNo" value="Y" onclick="ConNo()" <% if not vConYes="Y" then response.write("checked") %> />
                                                        &nbsp; No</td>
                                                    <td>
                                                        &nbsp;</td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table width="100%" border="0" cellpadding="2" cellspacing="0" class="bodycopy">
                                                <tr>
                                                    <td colspan="12" height="2" bgcolor="6D8C80">
                                                    </td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="BFD0C9">
                                                    <td height="20" colspan="10" class="bodyheader">
                                                        <span class="style6">FREIGHT CHARGE</span><strong> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                            <input type="checkbox" name="cShowPWeightCharge" value="Y" <% if vShowPrepaidWeightCharge="Y" then response.write("checked") %> />
                                                            Show Prepaid Ocean Freight
                                                            <% if mode_begin then %>
                                                        </strong>
                                                        <div style="width: 21px; display: inline; vertical-align: middle" onmouseover="showtip('Checking this will show the Prepaid Charges when you print the bill.  If uncheck, the prepaid charges will show as &ldquo;As Arranged&rdquo;');"
                                                            onmouseout="hidetip()">
                                                            <img src="../Images/button_info.gif" align="middle" class="bodylistheader"></div>
                                                        <% end if %>
                                                        <strong>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                            <input type="checkbox" name="cShowCWeightCharge" value="Y" <% if vShowCollectWeightCharge="Y" then response.write("checked") %>>
                                                            Show Collect Ocean Freight
                                                            <% if mode_begin then %>
                                                        </strong>
                                                        <div style="width: 21px; display: inline; vertical-align: middle" onmouseover="showtip('Checking this will show the Collect Charges when you print the bill.  If uncheck, the prepaid charges will show as &ldquo;As Arranged&rdquo;');"
                                                            onmouseout="hidetip()">
                                                            <img src="../Images/button_info.gif" align="middle" class="bodylistheader"></div>
                                                        <% end if %>
                                                        <strong>&nbsp; </strong>
                                                    </td>
                                                    <td>
                                                    </td>
                                                    <td>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="12" height="1" bgcolor="FFFFFF">
                                                    </td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#f3f3f3">
                                                    <td width="5%" height="20" valign="top" class="bodyheader">
                                                        C/P</td>
                                                    <td width="8%" valign="top" class="bodyheader">
                                                        No. of Pieces</td>
                                                    <td width="8%" valign="top" class="bodyheader">
                                                        Unit of<br />
                                                        Qty</td>
                                                    <td width="10%" valign="top" class="bodyheader">
                                                        Gross Weight (KG)</td>
                                                    <td width="9%" valign="top" class="bodyheader">
                                                        Gross Weight (LB)</td>
                                                    <td width="12%" valign="top" class="bodyheader">
                                                        Dimension (CBM)</td>
                                                    <td width="13%" valign="top" class="bodyheader">
                                                        Dimension(CFT)</td>
                                                    <td width="8%" valign="top" class="bodyheader">
                                                        Rate</td>
                                                    <td width="9%" valign="top" class="bodyheader">
                                                        Total</td>
                                                    <td width="8%" valign="top" class="bodyheader">
                                                        &nbsp;</td>
                                                    <% If isempty(aSubHouses) then SelIndex=0 else SelIndex=aSubHouses.Count end if %>
                                                    <td width="6%" valign="top" class="bodyheader">
                                                        <% if SelIndex>0 then response.Write("Sub House No.")%>
                                                    </td>
                                                    <td width="4%" valign="top" class="bodyheader">
                                                        <input type="hidden" id='dimtext' name="dimtext" value="<%= vDimText %>" /></td>
                                                </tr>
                                                <tr id="tr_wc_list" align="left" valign="middle" <%if vCheckMH="Y" then response.Write("style='visibility:visible'")%>>
                                                    <td>
                                                        <select name="lstWeightCP" size="1" class="smallselect" onchange="WeightCPChange()">
                                                            <option value="C">C</option>
                                                            <option value="P" <% if vWeightCP="P" then response.write("selected") %>>P</option>
                                                        </select>
                                                    </td>
                                                    <td>
                                                        <input name="txtPieces" style="behavior: url(../include/igNumDotChkLeft.htc)" maxlength="7"
                                                            <%if vCheckMH="Y" then response.Write("class='numberfield' ") else response.Write("class='numberfield'" ) end if %>OnBlur="CheckData()"
                                                            value="<%= vPieces %>" size="8" /></td>
                                                    <td>
                                                        <select name="lstUnitQty" size="1" class="smallselect" id="UnitQty" onchange="UnitQtyChange()">
                                                            <option value="PCS" <% if vUnitQty="PCS" then response.write("selected") %>>PCS</option>
                                                            <option value="BOX" <% if vUnitQty="BOX" then response.write("selected") %>>BOX</option>
                                                            <option value="PLT" <% if vUnitQty="PLT" then response.write("selected") %>>PLT</option>
                                                            <option value="CTN" <% if vUnitQty="CTN" then response.write("selected") %>>CTN</option>
                                                            <option value="SET" <% if vUnitQty="SET" then response.write("selected") %>>SET</option>
                                                            <option value="CRT" <% if vUnitQty="CRT" then response.write("selected") %>>CRT</option>
                                                            <option value="SKD" <% if vUnitQty="SKD" then response.write("selected") %>>SKD</option>
                                                            <option value="UNIT" <% if vUnitQty="UNIT" then response.write("selected") %>>UNIT</option>
                                                            <option value="PKGS" <% if vUnitQty="PKGS" then response.write("selected") %>>PKGS</option>
                                                            <option value="CNTR" <% if vUnitQty="CNTR" then response.write("selected") %>>CNTR</option>
                                                        </select>
                                                    </td>
                                                    <td>
                                                        <input name="txtGrossWeight" style="behavior: url(../include/igNumDotChkLeft.htc)"
                                                            maxlength="8" onblur="CheckData1()" <%if vCheckMH="Y" then response.Write("class='numberfield'") else response.Write("class='numberfield'" ) end if %>
                                                            value="<%= vGrossWeight %>" size="15" /></td>
                                                    <td>
                                                        <input name="txtGWLB" style="behavior: url(../include/igNumDotChkLeft.htc)" maxlength="8"
                                                            onblur="CheckData2()" <%if vCheckMH="Y" then response.Write("class='numberfield'") else response.Write("class='numberfield'" ) end if %>
                                                            value="<%= vGWLB %>" size="15" /></td>
                                                    <td>
                                                        <input type="hidden" name="hDemDetail" value="<%= vDemDetail %>" />
                                                        <input name="txtMeasurement" style="behavior: url(../include/igNumDotChkLeft.htc)"
                                                            maxlength="10" <%if vCheckMH="Y" then response.Write("class='numberfield'") else response.Write("class='numberfield'" ) end if %>
                                                            onblur="CheckData3()" value="<%= vMeasurement %>" size="15" />
                                                        <input type="image" src="../images/measure.gif" onclick="return false;" onmousedown="DimCalClick('CBM'); return false;"
                                                            align="absbottom" style="cursor: hand" /></td>
                                                    <td>
                                                        <input name="txtMCFT" style="behavior: url(../include/igNumDotChkLeft.htc)" maxlength="10"
                                                            <%if vCheckMH="Y" then response.Write("class='numberfield'") else response.Write("class='numberfield'" ) end if %>
                                                            onblur="CheckData4()" value="<%= vMCFT %>" size="15" />
                                                        <input type="image" src="../images/measure.gif" onclick="return false;" onmousedown="DimCalClick('CFT'); return false;"
                                                            align="absbottom" style="cursor: pointer" /></td>
                                                    <td>
                                                        <input name="txtChargeRate" style="behavior: url(../include/igNumDotChkLeft.htc)"
                                                            maxlength="10" value="<%= vChargeRate %>" <%if vCheckMH="Y" then response.Write("class='numberfield'") else response.Write("class='numberfield'" ) end if %>
                                                            size="10" /></td>
                                                    <td>
                                                        <input name="txtTotalWeightCharge" maxlength="10" style="behavior: url(../include/igNumDotChkLeft.htc)"
                                                            onblur="TotalWeightCharge()" value="<%=ConvertAnyValue(vTotalWeightCharge,"Amount",0) %>"
                                                            <%if vCheckMH="Y" then response.Write("class='numberfield'  ") else response.Write("class='numberfield'" ) end if %>
                                                            size="15" /></td>
                                                    <td>
                                                        <input type="image" src="../images/button_cal.gif" width="37" height="18" onclick="CalClick('cal'); return false;"
                                                            style="cursor: pointer" /></td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="f3f3f3" <% if vCheckMH <>"Y" then response.Write("style='display:none'")%>>
                                                    <td height="20" colspan="12" style="visibility: visible">
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                                            <tr align="left" valign="middle">
                                                                <td height="1" colspan="15" bgcolor="#6D8C80">
                                                                </td>
                                                            </tr>
                                                            <tr align="left" valign="middle">
                                                                <td height="1" colspan="15" bgcolor="#ffffff">
                                                                </td>
                                                            </tr>
                                                            <tr align="left" valign="middle">
                                                                <td height="1" colspan="15" bgcolor="#6D8C80">
                                                                </td>
                                                            </tr>
                                                            <tr align="left" valign="middle" bgcolor="f3f3f3" <% if vCheckMH <>"Y" then response.Write("style='display:none'")%>>
                                                                <td align="left" colspan="15">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="20" colspan="11" align="left" valign="middle" bgcolor="#E0EDE8" class="bodyheader">
                                                                    <span class="bodyheader style12">AVAILABLE SUB- HOUSES </span>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="20" bgcolor="#f3f3f3" class="bodyheader">
                                                                    Sub House No.</td>
                                                                <td bgcolor="#f3f3f3" class="bodyheader">
                                                                    Shipper</td>
                                                                <td bgcolor="#f3f3f3" class="bodyheader">
                                                                    Consignee</td>
                                                                <td height="20" bgcolor="#f3f3f3" class="bodyheader">
                                                                    Agent</td>
                                                                <td bgcolor="#f3f3f3" class="bodyheader">
                                                                    Pieces</td>
                                                                <td bgcolor="#f3f3f3" class="bodyheader">
                                                                    GW(KG)</td>
                                                                <td bgcolor="#f3f3f3" class="bodyheader">
                                                                    GW(LB)</td>
                                                                <td bgcolor="#f3f3f3" class="bodyheader">
                                                                    DM(CBM)</td>
                                                                <td bgcolor="#f3f3f3" class="bodyheader">
                                                                    DM(CFT)</td>
                                                                <td bgcolor="#f3f3f3" class="bodyheader">
                                                                    &nbsp;</td>
                                                                <td bgcolor="#f3f3f3" class="bodyheader">
                                                                    &nbsp;</td>
                                                            </tr>
                                                            <input type="hidden" name="hAVIndex" value="<%=AVIndex%>" />
                                                            <%for i=0 to AVIndex-1%>
                                                            <tr>
                                                                <td height="20" bgcolor="#FFFFFF">
                                                                    <input class="d_shorttextfield" readonly value="<%=vectAVHAWBs(i)%>" size="22" /></td>
                                                                <td bgcolor="#FFFFFF">
                                                                    <input class="d_shorttextfield" readonly value="<%= vectAVShippers(i) %>" size="24" /></td>
                                                                <td bgcolor="#FFFFFF">
                                                                    <input class="d_shorttextfield" readonly value="<%= vectAVConsignees(i)%>" size="24" /></td>
                                                                <td height="20">
                                                                    <input class="d_shorttextfield" readonly value="<%= vectAVAgents(i)  %>" size="24" /></td>
                                                                <td bgcolor="#FFFFFF">
                                                                    <input class="d_numberfield" style="width: 50px" readonly value="<%=vectAVPiece(i)  %>"
                                                                        size="7" /></td>
                                                                <td bgcolor="#FFFFFF">
                                                                    <input class="d_numberfield" style="width: 58px" readonly value="<%=vectAVGrossWeight(i) %>"
                                                                        size="7" /></td>
                                                                <td bgcolor="#FFFFFF">
                                                                    <input class="d_numberfield" style="width: 58px" readonly value="<%=vectAVGWLB(i) %>"
                                                                        size="7" /></td>
                                                                <td bgcolor="#FFFFFF">
                                                                    <input class="d_numberfield" style="width: 50px" readonly value="<%=vectAVMeasurement(i)  %>"
                                                                        size="7" /></td>
                                                                <td bgcolor="#FFFFFF">
                                                                    <input class="d_numberfield" style="width: 58px" readonly value="<%=vectAVMCFT(i)  %>"
                                                                        size="7" /></td>
                                                                <td bgcolor="#FFFFFF" class="bodyheader style14">
                                                                    <input type="image" src="../images/button_add.gif" width="37" height="17" onclick="AddToMaster('<%= vectAVHAWBs(i) %>',<%= vectAVELTAcct(i)%>); return false;"
                                                                        style="cursor: hand" /></td>
                                                                <td bgcolor="#FFFFFF" class="bodyheader style14">
                                                                    <input type="image" src="../images/button_edit.gif" width="37" height="18" onclick="EditHBOL('<%= vectAVHAWBs(i) %>'); return false;"
                                                                        style="cursor: hand" /></td>
                                                            </tr>
                                                            <%next%>
                                                            <tr>
                                                                <td height="20" bgcolor="#FFFFFF">
                                                                    &nbsp;</td>
                                                                <td bgcolor="#FFFFFF">
                                                                    &nbsp;</td>
                                                                <td bgcolor="#FFFFFF">
                                                                    &nbsp;</td>
                                                                <td height="20" bgcolor="#FFFFFF">
                                                                    <div align="right">
                                                                        <span class="bodyheader">Total</span>&nbsp;</div>
                                                                </td>
                                                                <td bgcolor="#FFFFFF">
                                                                    <input type="text" class="d_numberfield" style="width: 50px" readonly value="" size="7" /></td>
                                                                <td bgcolor="#FFFFFF">
                                                                    <input type="text" class="d_numberfield" style="width: 58px" readonly value="" size="7" /></td>
                                                                <td bgcolor="#FFFFFF">
                                                                    <input type="text" class="d_numberfield" style="width: 58px" readonly value="" size="7" /></td>
                                                                <td bgcolor="#FFFFFF">
                                                                    <input type="text" class="d_numberfield" style="width: 50px" readonly value="" size="7" /></td>
                                                                <td bgcolor="#FFFFFF">
                                                                    <input type="text" class="d_numberfield" style="width: 58px" readonly value="" size="7" /></td>
                                                                <td bgcolor="#FFFFFF">
                                                                    &nbsp;</td>
                                                                <td bgcolor="#FFFFFF">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="20" colspan="11" align="left" valign="middle" bgcolor="#E0EDE8" class="bodyheader style11 style12">
                                                                    SELECTED SUB-HOUSES
                                                                </td>
                                                            </tr>
                                                            <tr align="left" valign="middle">
                                                                <td height="1" colspan="15" bgcolor="#6D8C80">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="20" bgcolor="#f3f3f3" class="bodyheader">
                                                                    Sub-House No.</td>
                                                                <td bgcolor="#f3f3f3" class="bodyheader">
                                                                    Shipper</td>
                                                                <td bgcolor="#f3f3f3" class="bodyheader">
                                                                    Consignee</td>
                                                                <td bgcolor="#f3f3f3" class="bodyheader">
                                                                    Agent</td>
                                                                <td bgcolor="#f3f3f3" class="bodyheader">
                                                                    Pieces</td>
                                                                <td bgcolor="#f3f3f3" class="bodyheader">
                                                                    GW(KG)</td>
                                                                <td bgcolor="#f3f3f3" class="bodyheader">
                                                                    GW(LB)</td>
                                                                <td bgcolor="#f3f3f3" class="bodyheader">
                                                                    DM(CBM)</td>
                                                                <td bgcolor="#f3f3f3" class="bodyheader">
                                                                    DM(CFT)</td>
                                                                <td bgcolor="#f3f3f3" class="bodyheader">
                                                                    &nbsp;</td>
                                                                <td bgcolor="#f3f3f3" class="bodyheader">
                                                                    &nbsp;</td>
                                                            </tr>
                                                            <input type="hidden" name="hSHIndex" value="<%=SHIndex%>" />
                                                            <%for i=0 to SelIndex-1%>
                                                            <tr>
                                                                <td height="20">
                                                                    <input id="txtSubHouses<%=i%>" class='d_shorttextfield' readonly value="<%= aSubHouses(i)%>"
                                                                        size="22" /></td>
                                                                <td>
                                                                    <input class="d_shorttextfield" readonly value="<%= aShippers(i) %>" size="24" /></td>
                                                                <td>
                                                                    <input class="d_shorttextfield" readonly value="<%= aConsignees(i) %>" size="24" /></td>
                                                                <td>
                                                                    <input class="d_shorttextfield" readonly value="<%= aAgents(i) %>" size="24" /></td>
                                                                <td>
                                                                    <input class="d_numberfield" style="width: 50px" readonly value="<%= aPieces(i) %>"
                                                                        size="7" /></td>
                                                                <td>
                                                                    <input class="d_numberfield" style="width: 58px" readonly value="<%= aGrossWeight(i)%>"
                                                                        size="7" /></td>
                                                                <td>
                                                                    <input class="d_numberfield" style="width: 58px" readonly value="<%= aGWLB(i) %>"
                                                                        size="7" /></td>
                                                                <td>
                                                                    <input id="txtMeasure<%=i%>" class="numberfield" style="width: 50px" onblur="if(!ChangeAdjustedWeight('<%=aSubHouses(i)%>',this.value,'')){alert('Update for subhouse,'+subhouse+'failed')}"
                                                                        value="<%= aMeasurement(i) %>" size="7" /></td>
                                                                <td>
                                                                    <input class="d_numberfield" style="width: 58px" readonly value="<%= aMCFT(i)  %>"
                                                                        size="7" /></td>
                                                                <td>
                                                                    <input type="image" src="../images/button_edit.gif" width="37" height="18" onclick="EditHBOL('<%= aSubHouses(i) %>'); return false;"
                                                                        style="cursor: hand" /></td>
                                                                <td align="left">
                                                                    <input type="image" src="../images/button_remove.gif" width="55" height="17" onclick="RemoveSH('<%= aSubHouses(i) %>','<%= aAccounts(i) %>'); return false;"
                                                                        style="cursor: hand" /></td>
                                                                <input type="hidden" id="hAW" />
                                                            </tr>
                                                            <%next%>
                                                            <tr>
                                                                <td bgcolor="#FFFFFF">
                                                                    &nbsp;</td>
                                                                <td bgcolor="#FFFFFF">
                                                                    &nbsp;</td>
                                                                <td bgcolor="#FFFFFF">
                                                                    &nbsp;</td>
                                                                <td bgcolor="#FFFFFF">
                                                                    <div align="right">
                                                                        <span class="bodyheader">Total</span>&nbsp;</div>
                                                                </td>
                                                                <td bgcolor="#FFFFFF">
                                                                    <input type="text" class="d_numberfield" style="width: 50px" readonly value="<%=aPiecesTotal %>"
                                                                        size="7" /></td>
                                                                <td bgcolor="#FFFFFF">
                                                                    <input type="text" class="d_numberfield" style="width: 58px" readonly value="<%=aGrossWeightTotal  %>"
                                                                        size="7" /></td>
                                                                <td bgcolor="#FFFFFF">
                                                                    <input type="text" class="d_numberfield" style="width: 58px" readonly value="<%=aGWLBTotal%>"
                                                                        size="7" /></td>
                                                                <td bgcolor="#FFFFFF">
                                                                    <input type="text" class="d_numberfield" style="width: 50px" readonly value="<%=aMeasurementTotal%>"
                                                                        size="7" /></td>
                                                                <td bgcolor="#FFFFFF">
                                                                    <input type="text" class="d_numberfield" style="width: 58px" readonly value="<%=aMCFTTotal%>"
                                                                        size="7" /></td>
                                                                <td bgcolor="#FFFFFF">
                                                                    <%if   SelIndex > 0 then%>
                                                                    <input type="image" src="../images/button_adjust.gif" width="51" height="18" onclick="javascript:DoAdjustWeight();"
                                                                        style="cursor: hand" />
                                                                    <%end if%>
                                                                </td>
                                                                <td bgcolor="#FFFFFF">
                                                                    &nbsp;</td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="15" height="2" bgcolor="#6D8C80">
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table width="100%" border="0" cellpadding="1" cellspacing="2" class="bodycopy">
                                                <tr align="left" valign="top" bgcolor="E0EDE8">
                                                    <td height="21" valign="middle" bgcolor="E0EDE8">
                                                        <strong>Marks and Numbers</strong></td>
                                                    <td valign="middle" bgcolor="E0EDE8">
                                                        <strong>Number of Packages</strong></td>
                                                    <td valign="middle" bgcolor="E0EDE8">
                                                        <strong>Description of Commodities</strong></td>
                                                    <td colspan="2" valign="middle" bgcolor="E0EDE8">
                                                        <strong>Gross Weight</strong> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>Measurement</strong>
                                                    </td>
                                                </tr>
                                                <tr align="left" valign="top">
                                                    <td rowspan="2">
                                                        <textarea name="txtDesc1" cols="14" rows="17" wrap="hard" class="monotextarea"><%= vDesc1 %></textarea></td>
                                                    <td rowspan="2">
                                                        <textarea name="txtDesc2" cols="8" rows="17" wrap="hard" class="monotextarea"><%= vDesc2 %></textarea>
                                                    </td>
                                                    <td rowspan="2">
                                                        <textarea name="txtDesc3" cols="60" rows="17" wrap="hard" class="monotextarea"><%= vDesc3 %></textarea></td>
                                                    <td colspan="2">
                                                        <textarea name="txtDesc4" cols="33" rows="11" wrap="hard" class="monotextarea" readonly="readonly"
                                                            tabindex="-1"><%= vDesc4 %></textarea></td>
                                                </tr>
                                                <tr align="left" valign="top">
                                                    <td colspan="2">
                                                        <textarea name="txtDesc5" cols="25" rows="5" wrap="hard" class="monotextarea"><%= vDesc5 %></textarea></td>
                                                </tr>
                                                <tr>
                                                    <td colspan="5" style="text-align: right">
                                                        <table cellpadding="2" cellspacing="2" border="0" class="bodycopy" style="width: 50%">
                                                            <tr align="left" valign="top">
                                                                <td valign="middle" style="background-color: #E0EDE8">
                                                                    <strong>Manifest Description</strong></td>
                                                                <td>
                                                                </td>
                                                            </tr>
                                                            <tr align="left" valign="top">
                                                                <td rowspan="2">
                                                                    <textarea name="txtManifestDesc" cols="22" rows="4" wrap="hard" class="monotextarea"><%= vManifestDesc %></textarea></td>
                                                                <td>
                                                                    LC No.
                                                                    <input type="text" class="shorttextfield" name="txtLC" maxlength="64" value="<%=vLC%>"
                                                                        width="200px" /></td>
                                                            </tr>
                                                            <tr align="left" valign="top">
                                                                <td>
                                                                    CI No.
                                                                    <input type="text" class="shorttextfield" name="txtCI" maxlength="64" value="<%=vCI%>"
                                                                        width="200px" /></td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <table cellpadding="2" cellspacing="2" border="0" class="bodycopy">
                                                                        <tr style="background-color: #E0EDE8" align="left" valign="top">
                                                                            <td>
                                                                                <strong>AES ITN Number</strong></td>
                                                                            <td>
                                                                                <strong>SED Statement on Manifest </strong>
                                                                            </td>
                                                                        </tr>
                                                                        <tr align="left" valign="top">
                                                                            <td>
                                                                                <input type="text" class="shorttextfield" name="txtAES" maxlength="64" value="<%=vAES%>"
                                                                                    style="width: 100px" /></td>
                                                                            <td>
                                                                                <input type="text" class="m_shorttextfield" name="txtSEDStatement" value="<%=vSEDStmt %>"
                                                                                    maxlength="128" style="width: 200px" /></td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr align="left" valign="top">
                                                    <td>
                                                        &nbsp;</td>
                                                    <td colspan="2">
                                                    </td>
                                                    <td colspan="2">
                                                        &nbsp;</td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table width="100%" border="0" cellpadding="2" cellspacing="0" class="bodycopy">
                                                <tr align="left" valign="middle">
                                                    <td height="1" colspan="5" bgcolor="#6D8C80">
                                                    </td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="BFD0C9">
                                                    <td height="20" colspan="5" class="bodyheader">
                                                        <span class="style6">OTHER CHARGE</span> <strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                            <input type="checkbox" name="cShowPOtherCharge" value="Y" <% if vShowPrepaidOtherCharge="Y" then response.write("checked") %>>
                                                            Show Prepaid Other Charge
                                                            <% if mode_begin then %>
                                                        </strong>
                                                        <div style="width: 21px; display: inline; vertical-align: middle" onmouseover="showtip('Checking this will show the Prepaid Charges when you print the bill.  If uncheck, the prepaid charges will show as ?As Arranged?')"
                                                            onmouseout="hidetip()">
                                                            <img src="../Images/button_info.gif" align="middle" class="bodylistheader"></div>
                                                        <% end if %>
                                                        <strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                            <input type="checkbox" name="cShowCOtherCharge" value="Y" <% if vShowCollectOtherCharge="Y" then response.write("checked") %>>
                                                            Show Collect Other Charge
                                                            <% if mode_begin then %>
                                                        </strong>
                                                        <div style="width: 21px; display: inline; vertical-align: middle" onmouseover="showtip('Checking this will show the Collect Charges when you print the bill.  If uncheck, the prepaid charges will show as ?As Arranged?')"
                                                            onmouseout="hidetip()">
                                                            <img src="../Images/button_info.gif" align="middle" class="bodylistheader"></div>
                                                        <% end if %>
                                                        <strong></strong>
                                                    </td>
                                                </tr>
                                                <tr align="left" valign="middle">
                                                    <td height="1" colspan="5" bgcolor="#FFFFFF">
                                                    </td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="E0EDE8">
                                                    <td width="165" height="20">
                                                        <strong>C/P</strong></td>
                                                    <td width="360">
                                                        <strong>Charge Item</strong></td>
                                                    <td colspan="3">
                                                        <strong>Amount</strong></td>
                                                </tr>
                                                <input type="hidden" id="ChargeAmt" name="1">
                                                <input type="hidden" id="CostAmt" name="2">
                                                <input type="hidden" id="ChargeItem" name="3">
                                                <input type="hidden" id="ChargeVendor" name="4">
                                                <input type="hidden" id="ItemName" name="5">
                                                <%i=0%>
                                                <% for i=0 to tIndex-1 %>
                                                <tr id="oc_tr_<%=i%>" align="left" valign="middle" bgcolor="#FFFFFF">
                                                    <td height="20">
                                                        <input type="hidden" id="ItemName" name="hItemName<%= i %>" value="<%= aChargeItemName(i) %>">
                                                        <select name="lstOtherChargeCP<%= i %>" size="1" class="smallselect" style="width: 58px">
                                                            <option <% if aChargeCP(i)="C" then response.write("selected") %>>C</option>
                                                            <option <% if aChargeCP(i)="P" then response.write("selected") %>>P</option>
                                                        </select>
                                                    </td>
                                                    <td>
                                                        <select name="lstChargeItem<%= i %>" size="1" class="smallselect" id="ChargeItem"
                                                            style="width: 250px" onchange="ItemChange(<%= i %>)">
                                                            <option value="0">Select One</option>
                                                            <% for k=0 to chIndex-1 %>
                                                            <option value="<%= aItemNo(k) & "-" & aChargeUnitPrice(k)  %>" <% if aChargeItem(i)=aItemNo(k) then response.write("selected") %>>
                                                                <%= aChargeItemNameig(k) %>
                                                            </option>
                                                            <% next %>
                                                        </select>
                                                    </td>
                                                    <td>
                                                        <input name="txtChargeAmt<%= i %>" style="behavior: url(../include/igNumDotChkLeft.htc)"
                                                            maxlength="15" class="numberalign" id="ChargeAmt" value="<%=ConvertAnyValue(aChargeAmt(i),"Amount",0)%>"
                                                            size="26" /></td>
                                                    <td>
                                                        &nbsp;</td>
                                                    <td id="td_DeleteItem_<%=i%>" width="91" <%if vCheckMH="Y" then response.Write("style='visibility:visible'") %>>
                                                        <input type="image" src="../images/button_delete.gif" width="50" height="17" onclick="DeleteItem(<%= i %>); return false;"
                                                            style="cursor: hand" /></td>
                                                </tr>
                                                <% next %>
                                                <tr align="left" valign="middle" bgcolor="#F3f3f3">
                                                    <td width="165" height="20">
                                                        &nbsp;
                                                    </td>
                                                    <td width="360">
                                                        &nbsp;</td>
                                                    <td width="447">
                                                        &nbsp;</td>
                                                    <td width="88">
                                                        &nbsp;</td>
                                                    <td id="td_AddItem" <%if vCheckMH="Y" then response.Write("style='visibility:visible'") %>>
                                                        <input type="image" src="../images/button_additem.gif" width="64" height="18" name="bAdd"
                                                            onclick="AddItem(); return false;" style="cursor: hand" /></td>
                                                </tr>
                                                <tr align="left" valign="middle">
                                                    <td height="1" colspan="5" bgcolor="ffffff">
                                                    </td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="E0EDE8">
                                                    <td height="20" colspan="2" bgcolor="E0EDE8">
                                                        <div align="left">
                                                        </div>
                                                    </td>
                                                    <td colspan="3">
                                                        &nbsp;
                                                    </td>
                                                </tr>
                                                <tr align="left" valign="middle">
                                                    <td height="1" colspan="5" bgcolor="ffffff">
                                                    </td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#FFFFFF">
                                                    <td height="20" colspan="5">
                                                        <%=GetSQLResult("SELECT stmt from form_stmt where form_name='bol' AND country='" & company_country_code & "' and stmt_name='stmt4'", null) %>  </td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#FFFFFF">
                                                    <td colspan="5" height="20">
                                                        DECLARED VALUE
                                                        <input name="txtDeclaredValue" class="shorttextfield" onblur="CheckData()" value="<%= vDeclaredValue %>"
                                                            size="16">
                                                        READ CLAUSE 29 HEREOF CONCERNING EXTRA FREIGHT AND CARRIER'S LIMITATIONS OF LIABILITY.</td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                    <td width="50%" align="left" valign="top">
                                                        <table width="100%" border="0" cellpadding="1" cellspacing="2" class="bodycopy">
                                                            <tr align="center" valign="middle" bgcolor="E0EDE8">
                                                                <td colspan="3">
                                                                    <strong>Freight Rates, Charges, Weights and/Or Measurements</strong></td>
                                                            </tr>
                                                            <tr align="left" valign="middle" bgcolor="E0EDE8">
                                                                <td width="60%" height="20">
                                                                    Subject to Correction</td>
                                                                <td width="20%">
                                                                    Prepaid</td>
                                                                <td width="20%" bgcolor="E0EDE8">
                                                                    Collect</td>
                                                            </tr>
                                                            <tr align="left" valign="middle">
                                                                <td>
                                                                    <input name="txtOceanFreight" class="readonly" value="Ocean Freight" size="45" readonly="true"
                                                                        tabindex="-1" /></td>
                                                                <td>
                                                                    <input name="txtPOceanFreight" class="readonlyright" value="<% if vWeightCP="P" then 
								'vTotalPrepaid=vTotalPrepaid+vTotalWeightCharge
								response.write(formatNumberPlus(vTotalWeightCharge,2)) 
								end if  %>" style="width: 70px" readonly="readonly" tabindex="-1" />
                                                                </td>
                                                                <td>
                                                                    <input name="txtCOceanFreight" class="readonlyright" value="<% if vWeightCP="C"  then 
								'vTotalCollect=vTotalCollect+vTotalWeightCharge
								response.write(formatNumberPlus(vTotalWeightCharge,2))  
								end if %>" style="width: 70px" readonly="readonly" tabindex="-1" />
                                                                </td>
                                                            </tr>
                                                            <input type="hidden" id="POtherCharge" name="6" tabindex="-1" />
                                                            <input type="hidden" id="COtherCharge" tabindex="-1" />
                                                            <%i=0%>
                                                            <% for i=0 to 9 %>
                                                            <tr align="left" valign="middle">
                                                                <td>
                                                                    <input name="txtOtherChargeDesc<%= i %>" class="readonly" value="<%= aChargeItemName(i) %>"
                                                                        size="45" readonly tabindex="-1" /></td>
                                                                <td>
                                                                    <input name="txtPOtherCharge<%= i %>" class="readonlyright" id="POtherCharge" value="<% if aChargeCP(i)="P" then if (isnumeric(aChargeAmt(i)) )then response.write(formatNumberPlus(aChargeAmt(i),2)) else response.Write(aChargeAmt(i))end if  %>"
                                                                        style="width: 70px" readonly tabindex="-1" />
                                                                </td>
                                                                <td>
                                                                    <input name="txtCOtherCharge<%= i %>" class="readonlyright" id="COtherCharge" value="<% if aChargeCP(i)="C" then if (isnumeric(aChargeAmt(i))  )then response.write(formatNumberPlus(aChargeAmt(i),2)) else response.Write(aChargeAmt(i))end if  %>"
                                                                        style="width: 70px" readonly tabindex="-1" />
                                                                </td>
                                                            </tr>
                                                            <% next %>
                                                            <tr>
                                                                <td align="right" valign="middle">
                                                                    <span class="style6"><strong>GRAND TOTAL </strong></span>
                                                                </td>
                                                                <td align="left" valign="middle">
                                                                    <strong>
                                                                        <input name="txtTotalPrepaid" class="readonlyboldright" value="<%=FormatNumberPlus(ConvertAnyValue(vTotalPrepaid,"Amount",0),2) %>"
                                                                            style="width: 70px" readonly tabindex="-1" />
                                                                    </strong>
                                                                </td>
                                                                <td align="left" valign="middle">
                                                                    <strong>
                                                                        <input name="txtTotalCollect" class="readonlyboldright" value="<%=FormatNumberPlus(ConvertAnyValue(vTotalCollect,"Amount",0),2) %>"
                                                                            style="width: 70px" readonly tabindex="-1" />
                                                                    </strong>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    &nbsp;</td>
                                                                <td align="left" valign="middle">
                                                                    &nbsp;</td>
                                                                <td align="left" valign="middle">
                                                                    &nbsp;</td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                    <td align="left" valign="top">
                                                        <table width="100%" border="0" cellpadding="2" cellspacing="2" class="bodycopy">
                                                            <tr>
                                                                <td colspan="4" align="left" valign="middle">
                                                                    Received by Carrier for shipment by ocean vessel between port of loading and port
                                                                    of discharge, and for arrangement of pre-carriage from place of receipt and on-carriage
                                                                    to place of delivery, where stated above, the goods as specified above in apparent
                                                                    good order and condition unless otherwise stated,. The goods to be delivered at
                                                                    the above mentioned port of discharge or place of delivery, whichever is applicable,
                                                                    subject always to the exceptions, limitations, conditions and liberties set out
                                                                    on the reverse side hereof, to which the Shipper and/or Consignee agree to accepting
                                                                    this Bill of loading. IN WITNESS WHEREOF three(3) original Bills of loading have
                                                                    been signed, not otherwise stated above, one of which being accomplished the other
                                                                    shall be void.</td>
                                                            </tr>
                                                            <tr>
                                                                <td width="10%" align="left" valign="middle">
                                                                    At</td>
                                                                <td width="40%" align="left" valign="middle">
                                                                    <code><kbd><sup>
                                                                        <input name="txtPlace" class="shorttextfield" maxlength="32" value="<%= vPlace %>"
                                                                            size="37">
                                                                    </sup></kbd></code>
                                                                </td>
                                                                <td width="10%" align="left" valign="middle">
                                                                    &nbsp;</td>
                                                                <td width="40%" align="left" valign="middle">
                                                                    &nbsp;</td>
                                                            </tr>
                                                            <tr>
                                                                <td align="left" valign="middle">
                                                                    By</td>
                                                                <td align="left" valign="middle">
                                                                    <code><kbd><sup>
                                                                        <input name="txtBy" class="shorttextfield" maxlength="32" value="<%= vBy %>" size="37">
                                                                    </sup></kbd></code>
                                                                </td>
                                                                <td align="left" valign="middle">
                                                                    &nbsp;</td>
                                                                <td align="left" valign="middle">
                                                                    &nbsp;</td>
                                                            </tr>
                                                            <tr>
                                                                <td height="21" align="left" valign="middle">
                                                                    Date</td>
                                                                <td align="left" valign="middle">
                                                                    <code><kbd><sup>
                                                                        <input name="txtDate" class="shorttextfield" value="<%= vDate %>" size="37">
                                                                    </sup></kbd></code>
                                                                </td>
                                                                <td align="left" valign="middle">
                                                                    &nbsp;</td>
                                                                <td align="left" valign="middle">
                                                                    &nbsp;</td>
                                                            </tr>
                                                            <tr bgcolor="E0EDE8">
                                                                <td height="20" colspan="2" align="left" valign="middle">
                                                                    <strong>Master B/L No.</strong></td>
                                                                <td colspan="2" align="left" valign="middle">
                                                                    <strong>House B/L No.</strong></td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2" align="left" valign="middle">
                                                                    <code><kbd><sup>
                                                                        <input name="txtMBOL" class="readonlybold" value="<%= vMBOL %>" size="32" readonly
                                                                            tabindex="-1" />
                                                                    </sup></kbd></code>
                                                                </td>
                                                                <td colspan="2" align="left" valign="middle">
                                                                    <code><kbd><sup>
                                                                        <input name="T15" class="readonlybold" value="<%= vHBOL %>" size="32" readonly="true"
                                                                            tabindex="-1" />
                                                                    </sup></kbd></code>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr align="left" valign="middle">
                                                    <td height="1" colspan="5" bgcolor="#6D8C80">
                                                    </td>
                                                </tr>
                                                <tr align="left" valign="middle">
                                                    <td height="32" colspan="2" bgcolor="#f3f3f3" class="bodycopy">
                                                        <table width="100%" align="right">
                                                            <tr>
                                                                <td class="bodycopy" align="right">
                                                                    <strong>Sales Person</strong>
                                                                    <select name="lstSalesRP" size="1" class="smallselect" style="width: 200px">
                                                                        <option value="none">Select One</option>
                                                                        <%i=0%>
                                                                        <% For i=0 To SRIndex-1 %>
                                                                        <option value="<%= aSRName(i)%>" <% if vSalesPerson = aSRName(i) then response.write("selected") %>>
                                                                            <%= aSRName(i) %>
                                                                        </option>
                                                                        <%  Next  %>
                                                                    </select>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" height="1" bgcolor="6D8C80">
                            </td>
                        </tr>
                        <tr>
                            <td height="24" colspan="2" align="center" valign="middle" bgcolor="#BFD0C9">
                                <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="26%" valign="middle">
                                            <img src="../images/button_save_new.gif" align="absbottom" onclick="SaveClick('<%= TranNo %>','yes')"
                                                style="cursor: hand">
                                            <% if mode_begin then %>
                                            <div style="width: 21px; display: inline; vertical-align: middle" onmouseover="showtip('This will make a copy of the selected bill, and allow you to assign a new reference number to it.  This is a way to quickly create a shipment similar to a previous one.')"
                                                onmouseout="hidetip()">
                                                <img src="../Images/button_info.gif" align="texttop" class="bodylistheader"></div>
                                            <% end if %>
                                        </td>
                                        <td width="48%" align="center" valign="middle">
                                            <input type="image" src="../images/button_save_medium.gif" onclick="if('<%=vCheckSH%>'=='Y'){CheckIfMasterHasSameMAWB();}else{SaveClick('<%= TranNo %>','no')}; return false"
                                                style="cursor: hand" /></td>
                                        <td width="13%" align="right" valign="middle">
                                            <a href="/iff_main/ASP/ocean_export/new_edit_hbol.asp">
                                                <img src="/iff_main/ASP/Images/button_new.gif" width="42" height="17" border="0"
                                                    style="cursor: hand"></a></td>
                                        <td width="13%" align="right" valign="middle">
                                            <input type="image" src="../images/button_delete_medium.gif" width="51" height="17"
                                                name="bDelete" onclick="DeleteHBOL(); return false;" style="cursor: pointer"></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <table width="95%" height="32" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td align="right" valign="bottom">
                    <% If vHBOL <> "" Then %>
                    <div id="print">
                        <a href="javascript:;" onclick="SetCostItems(); return false;" tabindex="-1">Cost Items</a>
                        <img src="/iff_main/ASP/Images/button_devider.gif" alt="" />
                        <a href="javascript:;" onclick="SetCreditNote(); return false;" tabindex="-1">Credit Note</a>
                        <img src="/iff_main/ASP/Images/button_devider.gif" alt="" />
                        <a href="javascript:EditClick('<%=vHAWB %>','<%=vBookingNum %>');"
                                tabindex="-1">
 
                            <img src="/iff_main/ASP/Images/icon_createhouse.gif" alt="Click here to create SED"
                                width="25" height="26" style="margin-right: 10px" />Create AES</a>
                        <img src="/iff_main/ASP/Images/button_devider.gif" alt="" />
                        <a href="javascript:;" onclick="NewPrintVeiw(); return false;">
                            <img src="/iff_main/ASP/Images/icon_printer_preview.gif" align="absbottom" alt="" />House
                            B/L</a></div>
                    <% End If %>
                </td>
            </tr>
        </table>
        <br />
    </form>
</body>

<script language="javascript" type="text/javascript" src="../ajaxFunctions/ajax_ig_call_db.js">  </script>

<script type="text/jscript" language="javascript">


function setShipperWithAccountHolder()
{ 
    // || document.form1.hFFAgentAcct.value == "0"
	if (document.form1.hFFAgentAcct.value == ""){		
		alert("Agent is required to save  as a Master House."+"\n"+"Please select an agent and try again!"); 
	    return ;
	}
	
	if(document.form1.hShipperAcct.value == "" || document.form1.hShipperAcct.value == "0"){
        lstShipperNameChange(<%=vDefaultShipperIndex %>,"<%=GetBusinessName(vDefaultShipperIndex) %>");
	}
	MakeMasterHouse();
}

function CHECK_ConsoleClick(){

	if(document.getElementById("checkConsol").checked){
		document.getElementById("hIs_consoled").value="Y";
	}else{
		document.getElementById("hIs_consoled").value="N";
	}
}




function DoAdjustWeight(){
    
	var HBOL="<%=vHBOL%>";
	Count="<%=SelIndex%>";
	for(i=0; i< Count ; i++){
		id="txtMeasure"+i;
		id2="txtSubHouses"+i;
		measure=document.getElementById(id).value;
        subhouse=document.getElementById(id2).value;		
	}		
	document.form1.action = "new_edit_hbol.asp?edit=yes&HBOL=" + encodeURIComponnent(HBOL) + "&WindowName=" + window.name ;
	document.form1.method = "post";
	document.form1.target = window.name;
	
	form1.submit();
}

function ChangeAdjustedWeight(HAWB,AW,tran_no)
{ 
	MAWB = document.getElementById("hSearchNum").value;
      if (window.ActiveXObject) {
	       try {
		    xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
	       } catch(e) {
                try {
                 xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
                } catch(e1) {
                 return;
                }
          }
      } else if (window.XMLHttpRequest) {
            xmlHTTP = new XMLHttpRequest();
      } else {return;}

	try
	{
	
	    var url = "../ajaxFunctions/ajax_updateAdjustedWeight.asp?MAWB="+ MAWB+ "&HAWB=" 
	        + HAWB + "&AO=O&AWeight=" + AW + "&tran_no=" + tran_no
		
		xmlHTTP.open("get",encodeURI(url),false); 
        xmlHTTP.send(); 
		
		var result = xmlHTTP.responseText;
		
		if (result=="Success"){	
			 return true;		
		}else{	
			return false;			
		}
	}	
	catch(e) {
	    alert(e);
	}
}


function CheckIfMasterHasSameMAWB()
{ 
    MAWB = document.getElementById("hSearchNum").value;
	HAWB = "<%=vM_HAWB%>";
    if (window.ActiveXObject) {
        try {
            xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
        } catch(e) {
            try {
                xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
            } catch(e1) {
                return;
            }
        }
    }
    else if (window.XMLHttpRequest) {
        xmlHTTP = new XMLHttpRequest();
    } 
    else { return; }

	try
	{
		xmlHTTP.open("get",encodeURI("../ajaxFunctions/ajax_checkIfMasterHasSameMAWB.asp?MAWB="+ MAWB + "&HAWB=" + HAWB+"&AO=O"),false); 
        xmlHTTP.send(); 
		
		var result = xmlHTTP.responseText;

		var arr=result.split(":")

		if (arr[0]=="N"){
		
			if(confirm("Cannot change the booking number in sub-house B/L")){
				
				lstSearchNumChange(arr[1],arr[1]);
				SaveClick('<%= TranNo %>','no');
				
			}else{
				
			}
		}else{
			SaveClick('<%= TranNo %>','no');
		}
	}	
	catch(e) { }

}


function changeMasterInfoForAllSubs(){

	vBookingNum = document.form1.hSearchNum.value;
	vLoadingPort=document.form1.txtLoadingPort.value;
	vUnloadingPort=document.form1.txtUnloadingPort.value;	
	vExportCarrier=document.form1.txtExportCarrier.value;
	vDeliveryPlace=document.form1.txtDeliveryPlace.value;
	vOriginCountry=document.form1.txtOriginCountry.value;
	vDepartureDate=document.form1.hDepartureDate.value;
	vMBOL=document.form1.txtMBOL.value;

	vMoveType=document.form1.lstMoveType.value;
	vPreReceiptPlace=document.form1.txtPreReceiptPlace.value;
	vExportRef=document.form1.txtExportRef.value;
	vDestCountry=document.form1.hDestCountry.value;
	vVN=document.form1.hVesselName.value;
	vWeightCP=document.form1.lstWeightCP.value  ;
	vDesc5=document.form1.txtDesc5.value;
	
	var post_parameter ="vLoadingPort="+vLoadingPort+"&";
	post_parameter +="vUnloadingPort="+vUnloadingPort+"&";
	post_parameter +="vExportCarrier="+vExportCarrier+"&";
	post_parameter +="vDeliveryPlace="+vDeliveryPlace+"&";
	post_parameter +="vOriginCountry="+vOriginCountry+"&";
	post_parameter +="vDepartureDate="+vDepartureDate+"&";
	post_parameter +="vMBOL="+vMBOL+"&";
	post_parameter +="vMoveType="+vMoveType+"&";
	post_parameter +="vPreReceiptPlace="+vPreReceiptPlace+"&";
	post_parameter +="vExportRef="+vExportRef+"&";
	post_parameter +="vDestCountry="+vDestCountry+"&";
	post_parameter +="vVN="+vVN+"&";
	post_parameter +="vWeightCP="+vWeightCP+"&";
	post_parameter +="vDesc5="+vDesc5+"&";
	post_parameter +="vBookingNum="+vBookingNum+"&";
	post_parameter +="vHBOL="+"<%=vHBOL%>";

 	post_parameter=encodeURIComponent(post_parameter);
	
	var url = '/IFF_MAIN/asp/ajaxFunctions/ajax_changeMasterInfoForAllSubs.asp';
	
	
	new ajax.xhr.Request('POST',post_parameter,url,verifyMasterChanged,'','','');	
	
}

function verifyMasterChanged(req) {

	if (req.readyState == 4) {
		if (req.status == 200) {
			var tmpVal = req.responseText
				alert(tmpVal)
			if (tmpVal=="Success") {
				
			}
			else {
				alert('update error');						
			}
		}
		else {
			alert(req.responseText);				
		}	
	}				
}
    
</script>

<script type="text/vbscript" language="vbscript">

AskOverWrite="<%= AskOverWrite %>"
if AskOverWrite="yes" then
	ok=MsgBox ("The HBOL is existed. Overwrite it?" & chr(13) & "Yes?",36,"Message")
	if ok=6 then	
		document.form1.action=encodeURI("new_edit_hbol.asp?Save=yes&OverWrite=yes"& "&tNo=" & "<%=TranNo%>" & "&WindowName=" & window.name)
		document.form1.method="POST"
		document.form1.target=window.name
		form1.submit()
	end if
end if

///////////////////////
Sub LaserClick()
///////////////////////
jPopUpPDF()
HBOL=document.form1.txtHBOL.Value
document.form1.action=encodeURI("hbol_pdf.asp?hbol=" & HBOL & "&WindowName=popupNew" )
document.form1.method="POST"
document.form1.target = "popUpPDF"
form1.submit()

End Sub

////////////////////////////////////
////////////////////////////////////
////////////////////////////////////
FUNCTION CHECK_IV_STATUS( tvHAWB )
////////////////////////////////////
////////////////////////////////////
////////////////////////////////////

IF tvHAWB = "" OR tvHAWB = "0" THEN
	CHECK_IV_STATUS = true
	exit function
END IF

DIM IVstrMSG

IVstrMSG = "<%=IVstrMsg%>"

IF NOT IVstrMSG = "" THEN
	ok=MsgBox ("Invoice No. " & IVstrMSG & " for HBOL#:" & tvHAWB & " was processed already." & chr(10) & "Do you want to continue?",36,"Warning!")
	if ok=6 then
		CHECK_IV_STATUS = true
		exit function
	else
		CHECK_IV_STATUS = false
		exit function
	end if	
END IF

CHECK_IV_STATUS = true

END FUNCTION
////////////////////////////////////
////////////////////////////////////
////////////////////////////////////
////////////////////////////////////



Function CheckNullToZero(FormValue)
    if isnull(FormValue) or trim(FormValue)="" then
        CheckNullToZero=0
    else
        CheckNullToZero=FormValue
    end if    
End Function

Function checkBlank(arg1,arg2)
    Dim result
    If IsNull(arg1) Then 
        result = arg2
    Else
		If Trim(arg1)="" Then
			result = arg2
		Else
			result = Trim(arg1)
		End If
    End If    
    checkBlank = result
    
End Function

Function FormatNumberPlus(argStrVal,decim)
    Dim returnVal
    returnVal = 0
	If Not IsNull(argStrVal) And Trim(argStrVal) <> "" Then
		argStrVal = Trim(argStrVal)
		If isnumeric(argStrVal) And Not isempty(argStrVal) Then
		    returnVal = FormatNumber(argStrVal,decim,,,0)
		End If
    End If
	FormatNumberPlus = returnVal
End Function



Sub SaveClick(TranNo,SaveAsNew)

    Dim is_copied
    
    If SaveAsNew = "yes" And document.getElementById("hM_HAWB").value <> "" Then
        is_copied = "yes"
    Else
        is_copied = "no"
    End If    
        
    if "<%=vCheckMH%>"="Y" then
	    if "<%=SelIndex%>"="" then
		    Document.form1.hSubCount.Value=0
	    else 
		    Document.form1.hSubCount.Value=FormatNumberPlus(checkblank("<%=SelIndex%>",0),0)
	    end if 	
    end if 

    Call CalClick("save")

    If document.form1.hFFAgentAcct.value = "" Or document.form1.hFFAgentAcct.value = "0" Then
        msgbox "Please select a agent"
        Exit Sub
    End If
    
    if "<%=vHBOL%>" = "" then
	    SaveAsNew="yes"
    end if

    if Not SaveAsNew="yes" then
	    ////////////////////////////////////////	
	    IF NOT CHECK_IV_STATUS( " <%=vHBOL%> " ) THEN
		    EXIT SUB
	    END IF
	    ////////////////////////////////////////
    end if

    OC = FormatNumberPlus(checkblank(document.form1.hNoItem.Value,0),0)

    Dim i

    for i=1 to OC
    	
	    oItem=document.all("ChargeItem").item(i).Value
    		
	    On Error Resume Next:
	    pos=0
	    pos=Instr(oItem,"-")
	    if pos>0 then
		    oItem=FormatNumberPlus(checkblank(left(oItem,pos-1),0),0)
	    else
		    oItem=FormatNumberPlus(checkblank(oItem,0),0)
	    end if
    	
	    oAmt=document.all("ChargeAmt").item(i).Value

	    if oAmt="" then oAmt=0
	    if oCost="" then oCost=0
	    if Not IsNumeric(oAmt) then
		    MsgBox "Please enter a Numeric Value for CHARGE AMT!"
		    exit Sub
	    end if
	    if Not IsNumeric(oCost) then
		    MsgBox "Please enter a Numeric Value for CHARGE COST!"
		    exit Sub
	    end if
	    if not oAmt=0 and oItem=0 then
		    MsgBox "Please select an item!"
		    Exit Sub
	    end if
	    if Not oAmt="" and Not IsNumeric(oAmt) then
		    MsgBox "Please enter a Numeric Value for CHARGE AMT!"
		    exit Sub
	    end if
    next

    If document.form1.hShipperAcct.value = "" Or document.form1.hShipperAcct.value = "0" Then
        MsgBox "Please select an exporter!"
        Exit Sub
    End If

	HBOLPrefix=document.form1.hHBOLPrefix.Value

	if HBOLPrefix="" then
		HBOLPrefix=document.form1.lstHBOLPrefix.item(0).Text
		document.form1.hHBOLPrefix.Value=HBOLPrefix
	end if

	if SaveAsNew="yes" Then
		
		sindex=document.form1.lstHBOLPrefix.selectedindex
		HBOLPrefix=document.form1.lstHBOLPrefix.item(sindex).Text
		NEXTPrefix=document.form1.lstHBOLPrefix.item(sindex).value
		tmpUrl = "new_edit_hbol_OK.asp?SaveAsNew=yes&prefix=" & HBOLPrefix _
		    & "&NEXTPREFIX=" & NEXTPrefix & "&salesPerson=" & vSalesPerson & "&IsCopied=" & is_copied
		Set NewNum = showModalDialog(encodeURI("hbol_Dialog.asp?"&tmpUrl) ,,"dialogWidth:400px; dialogHeight:170px; help:no; status:no; scroll:no;center:yes")
        
        If NewNum.copyOption = "RemoveMasterhouse" Then
            document.getElementById("hCheckSH").value = "N"
            document.getElementById("hM_HAWB").value = ""
            Call lstSearchNumChange("","")
        End If
		        
		If Not NewNum.hbolNum = "" Then
			document.form1.hHBOLPrefix.value = ""			
			document.form1.action = encodeURI("new_edit_hbol.asp?save=yes&New=yes&HBOL=" & NewNum.hbolNum & "&tNo=" & TranNo & "&WindowName=" & window.name)
			document.form1.method="post"
			document.form1.target=window.name
			form1.submit()
		end if
			
	else
		document.form1.action = encodeURI("new_edit_hbol.asp?Save=yes&New=" & NewHBOL & "&tNo=" & TranNo & "&WindowName=" & window.name)
		document.form1.method = "POST"
		document.form1.target = window.name	
		document.form1.submit()
	end if

End Sub



Sub AddItem()
NoItem=FormatNumberPlus(checkblank(document.form1.hNoItem.Value,0),0)
'if document.all("ChargeItem").item(NoItem+1).Value=0 then
'	MsgBox "Please select a charge item!"
''elseif document.all("ChargeVendor").item(NoItem+1).Value=0 then
'	'MsgBox "Please select a vendor!"
'elseif document.all("ChargeAmt").item(NoItem+1).Value="" then
'	MsgBox "Please enter a charge amt!"
'elseif IsNumeric(document.all("ChargeAmt").item(NoItem+1).Value)=false then
'	MsgBox "Please enter a numeric value for charge amt!"
'elseif IsNumeric(document.all("CostAmt").item(NoItem+1).Value)=false and not document.all("CostAmt").item(NoItem+1).Value="" then
'	MsgBox "Please enter a numeric value for cost amt!"
if NoItem>=10 then
	MsgBox "Can't have more than 10 Charge Items!"
else
//	'if document.all("CostAmt").item(NoItem+1).Value="" then
//	'	document.all("CostAmt").item(NoItem+1).Value=0
//	'end if
	document.form1.hNoItem.Value=NoItem+1
	document.form1.action=encodeURI("new_edit_hbol.asp?Add=yes"& "&tNo=" & "<%=TranNo%>" & "&WindowName=" & window.name)
	document.form1.method="POST"
	document.form1.target=window.name		
	form1.submit()
end if
End Sub

Sub DeleteItem(ItemNo)
	if document.form1.hNoItem.Value>0 and not FormatNumberPlus(checkblank(document.form1.hNoItem.Value,0),0)=ItemNo then
		ok=MsgBox ("Are you sure you want to delete this item?" & chr(13) & "Continue?",36,"Message")
		if ok=6 then	
			document.form1.action=encodeURI("new_edit_hbol.asp?Delete=yes&tNo=" & "<%=TranNo%>" & "&dItemNo=" & ItemNo & "&WindowName=" & window.name)
			document.form1.method="POST"
			document.form1.target=window.name				
			form1.submit()
		end if
	end if
End Sub

Sub ConYes()
    if document.form1.cConYes.Checked=True then
	    document.form1.cConNo.Checked=False
    else
	    document.form1.cConNo.Checked=True
    end if
End Sub

Sub ConNo()
    if document.form1.cConNo.Checked=True then
	    document.form1.cConYes.Checked=False
    else
	    document.form1.cConYes.Checked=True
    end if
End Sub

Sub CalClick(arg)
    WeightCP=document.form1.lstWeightCP.Value
    GWKG=CheckNullToZero(document.form1.txtGrossWeight.Value)
    GWLB=CheckNullToZero(document.form1.txtGWLB.Value)
    Pieces=CheckNullToZero(document.form1.txtPieces.Value)
    Rate=CheckNullToZero(document.form1.txtChargeRate.Value)
    MCBM= CheckNullToZero(document.form1.txtMeasurement.Value)
    MCFT= CheckNullToZero(document.form1.txtMCFT.Value)
    TotalDem=0

    if IsNumeric(Pieces)=False then
	    MsgBox "Please enter a numeric value for No. of Pieces!"
    elseif IsNumeric(GrossWeight)=False then
	    MsgBox "Please enter a numeric value for Gross Weight!"
    elseif not Rate="" and IsNumeric(Rate)=false then
	    MsgBox "Please enter a numeric value for Rate!"
    elseif not Measuremnet="" and IsNumeric(Measurement)=false then
	    MsgBox "Please enter a numeric value for MEASUREMENT!"
    elseif TotalPieces>0 and not TotalPieces=Pieces then
	    MsgBox "Pieces mismatch!"
    else
	    if Not MCBM="" then
		    if MCBM>0 then
			    TotalDem=MCBM
		    end if
	    end if
	    cw=TotalDem
	    if TRIM(GWKG) = "" then
		    msgbox "Please enter a Gross Weight"
		    exit sub
	    end if
	    GrossWeight=GWKG/1000
	    if cw < GrossWeight then cw=GrossWeight
	    tc = Round(Rate) * cw
	    if not Trim(document.form1.txtTotalWeightCharge.Value)="" Then
	        'comment out following lines if u want to calculate always'
	        If arg="save" Then
	            tc = document.form1.txtTotalWeightCharge.Value
	        End If
    	    
            if Not Trim(document.form1.txtChargeRate.Value)="" Then
                document.form1.txtTotalWeightCharge.Value=tc
            end if
            if WeightCP="P" then
                document.form1.txtPOceanFreight.Value=tc
                document.form1.txtCOceanFreight.Value=0
            else
                document.form1.txtCOceanFreight.Value=tc
                document.form1.txtPOceanFreight.Value=0
            end if
	    elseif Trim(document.form1.txtTotalWeightCharge.Value)="" then
		    document.form1.txtTotalWeightCharge.Value=tc
		    if WeightCP="P" then
			    document.form1.txtPOceanFreight.Value=tc
			    document.form1.txtCOceanFreight.Value=0
		    else
			    document.form1.txtCOceanFreight.Value=tc
			    document.form1.txtPOceanFreight.Value=0
		    end if
	    end if
	    document.form1.txtMeasurement.value=Round(TotalDem,2)
    end if

    string1 = FormatNumber(GWKG,2,,,0) & " KG"
    string2 = FormatNumber(MCBM,2,,,0) & " CBM"
    string3 = FormatNumber(GWLB,2,,,0) & " LB"
    string4 = FormatNumber(MCFT,2,,,0) & " CFT"

    string1 = space(15 - len(string1)) & trim(string1)
    string2 = space(15 - len(string2)) & trim(string2)
    string3 = space(15 - len(string3)) & trim(string3)
    string4 = space(15 - len(string4)) & trim(string4)

    vDesc4 = string1 & "  " & string2 & chr(13)
    vDesc4 = vDesc4 & string3 & "  " &  string4

    document.form1.txtDesc4.Value=vDesc4

    Call UnitQtyChange()

End Sub

Sub UnitQtyChange
    UnitQty=document.form1.lstUnitQty.Value
    Pieces=document.form1.txtPieces.value
    document.form1.txtDesc2.value = Pieces & " " & UnitQty
End Sub

Sub ItemChange(k)
    DIM ItemName
    sIndex=document.all("ChargeItem").item(k+1).SelectedIndex
    ItemDesc = document.all("ChargeItem").item(k+1).item(sIndex).Text

    pos = InStrRev(ItemDesc,"-")
    if pos>0 then
	    ItemDesc=Mid(ItemDesc,pos+1,200)
    end if
    document.all("ItemName").item(k+1).Value = LTRIM(ItemDesc)

    ItemName=Document.all("ChargeItem").item(k+1).Value
    pos=Instr(ItemName,"-")
    if pos>0 then
	    ///////////////////////////////
	    // Unit_Price by ig 10/21/2006
	    DIM ItemUnitPrice
	    ItemUnitPrice = GET_ITEM_UNIT_PRICE ( ItemName )
    end if

    if sindex>0 then
	    // Unit_Price by ig 10/21/2006
	    CALL SET_UNIT_PRICE ( Document.all("ChargeAmt").item(k+1) , ItemUnitPrice )
	    ///////////////////////////////	
    else
	    Document.all("ItemName").item(k+1).Value=""
    end if
    // document.all("ItemName").item(k+1).Value=document.all("ChargeItem").item(k+1).item(sIndex).Text
End Sub

//////////////////////////////////
// Unit_Price by ig 10/21/2006
//////////////////////////////////
function GET_ITEM_UNIT_PRICE ( tmpBuf )
    DIM ItemUnitPrice,pos

    ItemUnitPrice=0

    pos=Instr(tmpBuf,"-")
    if pos>0 then
	    ItemUnitPrice=Mid(tmpBuf,pos+1,200)
    end if

    GET_ITEM_UNIT_PRICE = ItemUnitPrice
end function

sub SET_UNIT_PRICE( obj, val )
	On Error Resume Next:
    //	if(val = "0") then
    //		obj.value = ""
    //	else
        obj.value = FormatNumber(val,2,,,0)
    //	end if	
end sub
//////////////////////////////////

Sub TotalWeightCharge()

    WeightCharge=document.form1.txtTotalWeightCharge.Value

    if Not WeightCharge="" then
	    if IsNumeric(WeightCharge)=false then
		    MsgBox "Please enter a numeric value!"
		    document.form1.txtTotalWeightCharge.Value=""
	    else
		    if document.form1.lstWeightCP.value="P" then
			    document.form1.txtPOceanFreight.Value=WeightCharge
			    document.form1.txtCOceanFreight.Value=""
    			
			    TotalPCharge=FormatNumberPlus(checkblank(WeightCharge,0),2)
    			
		    else
			    document.form1.txtCOceanFreight.Value=WeightCharge
			    document.form1.txtPOceanFreight.Value=""
			    TotalCCharge=FormatNumberPlus(checkblank(WeightCharge,0),2)
		    end if
		    for k=1 to 10
			    pc=document.all("POtherCharge").item(k).Value
			    if not pc="" then
				    pc=FormatNumberPlus(checkblank(pc,0),2)
			    else
				    pc=0
			    end if
    			
			    TotalPCharge=TotalPCharge+pc
    			
			    cc=document.all("COtherCharge").item(k).Value
			    if not cc="" then
				    cc=FormatNumberPlus(checkblank(cc,0),2)
			    else
				    cc=0
			    end if
			    TotalCCharge=TotalCCharge+cc
		    next
		    document.form1.txtTotalPrepaid.Value=TotalPCharge
		    document.form1.txtTotalCollect.Value=TotalCCharge
	    end if
    end if

End Sub

Sub BookingChange()

    Dim vBookingNumber
    vBookingNumber = document.getElementById("hSearchNum").value
    If vBookingNumber = "" Then
        Exit Sub
    End If

    CHECK_INVOICE_STATUS_AJAX "Booking", vBookingNumber

    bInfo = get_mbol_booking_info(vBookingNumber)
    pos=0
    pos=instr(bInfo,chr(10))
    if pos>0 then
	    DepartureDate=Mid(bInfo,1,pos-1)
	    bInfo=Mid(bInfo,pos+1,200)
    end if
    pos=instr(bInfo,chr(10))
    if pos>0 then
	    LoadingPort=Mid(bInfo,1,pos-1)
	    bInfo=Mid(bInfo,pos+1,200)
    end if
    pos=instr(bInfo,chr(10))
    if pos>0 then
	    unLoadingPort=Mid(bInfo,1,pos-1)
	    bInfo=Mid(bInfo,pos+1,200)
    end if
    pos=instr(bInfo,chr(10))
    if pos>0 then
	    ExportCarrier=Mid(bInfo,1,pos-1)
	    bInfo=Mid(bInfo,pos+1,200)
    end if
    pos=instr(bInfo,chr(10))
    if pos>0 then
	    Country=Mid(bInfo,1,pos-1)
	    bInfo=Mid(bInfo,pos+1,200)
    end if
    pos=instr(bInfo,chr(10))
    if pos>0 then
	    MBOLNum=Mid(bInfo,1,pos-1)
	    bInfo=Mid(bInfo,pos+1,200)
    end if
    pos=instr(bInfo,chr(10))
    if pos>0 then
	    MoveType=Mid(bInfo,1,pos-1)
	    bInfo=Mid(bInfo,pos+1,200)
    end if
    pos=instr(bInfo,chr(10))
    if pos>0 then
	    ReceiptPlace=Mid(bInfo,1,pos-1)
	    bInfo=Mid(bInfo,pos+1,200)
    end if
    pos=instr(bInfo,chr(10))
    if pos>0 then
	    DeliveryPlace=Mid(bInfo,1,pos-1)
	    bInfo=Mid(bInfo,pos+1,200)
    end if
    pos=instr(bInfo,chr(10))
    if pos>0 then
	    FileNo=Mid(bInfo,1,pos-1)
	    bInfo=Mid(bInfo,pos+1,200)
    end if
    pos=instr(bInfo,chr(10))
    if pos>0 then
	    DestCountry=Mid(bInfo,1,pos-1)
	    VN=Mid(bInfo,pos+1,200)
    end if
    document.form1.txtLoadingPort.Value=LoadingPort
    document.form1.txtUnLoadingPort.Value=unLoadingPort
    document.form1.txtExportCarrier.Value=ExportCarrier
    document.form1.txtDeliveryPlace.Value=DeliveryPlace
    document.form1.txtOriginCountry.Value=Country
    document.form1.hDepartureDate.Value=DepartureDate
    document.form1.txtMBOL.value=MBOLNum
    document.form1.lstMoveType.value=MoveType
    document.form1.txtPreReceiptPlace.Value=ReceiptPlace
    document.form1.txtDeliveryPlace.Value=DeliveryPlace
    document.form1.txtExportRef.Value=FileNo & chr(10) & "MBOL:" & MBOLNum
    document.form1.hDestCountry.Value=DestCountry
    document.form1.hVesselName.Value=VN
    CP=document.form1.lstWeightCP.Value

    if CP="C" then
	    CP="COLLECT"
    else
	    CP="PREPAID"
    end if
    Desc5 = "FREIGHT " & CP & chr(13) & "LADEN ON BOARD:" & chr(13) & DepartureDate & chr(13) & ExportCarrier & chr(13) & LoadingPort
    document.form1.txtDesc5.Value = Desc5
    
End Sub


Sub WeightCPChange()
    On Error Resume Next:
	Call lstSearchNumChange(Document.form1.hSearchNum.value, Document.form1.lstSearchNum.value)
End Sub

Sub CheckData()
    Pieces=document.form1.txtPieces.Value
    GWKG=document.form1.txtGrossWeight.Value 'this is in KG
    GWLB=document.form1.txtGWLB.Value
    MCBM=document.form1.txtMeasurement.Value 'this is in CBM
    MCFT=document.form1.txtMCFT.Value
    DeclaredValue=document.form1.txtDeclaredValue.Value
    if Not Pieces="" then
	    if IsNumeric(Pieces)=False then
		    MsgBox "Please enter a numeric value for PIECES!"
		    document.form1.txtPieces.Value=""
	    end if
    end if
    if Not GWKG="" then
	    if IsNumeric(GWKG)=False then
		    MsgBox "Please enter a numeric value for GrossWeight/KG!"
		    document.form1.txtGrossWeight.Value=""
	    end if
    end if
    if Not GWLB="" then
	    if IsNumeric(GWLB)=False then
		    MsgBox "Please enter a numeric value for GrossWeight/LB!"
		    document.form1.txtGWLB.Value=""
	    end if
    end if
    if Not MCBM="" then
	    if IsNumeric(MCBM)=False then
		    MsgBox "Please enter a numeric value for Measurement/CBM!"
		    document.form1.txtMeasurement.Value=""
	    end if
    end if
    if Not MCFT="" then
	    if IsNumeric(MCFT)=False then
		    MsgBox "Please enter a numeric value for Measurement/CFT!"
		    document.form1.txtMCFT.Value=""
	    end if
    end if
    if Not DeclaredValue="" then
	    if IsNumeric(DeclaredValue)=False then
		    MsgBox "Please enter a numeric value for DeclaredValue!"
		    document.form1.txtDeclaredValue.Value=""
	    end if
    end if
End Sub

Sub CheckData1()
    GWKG=document.form1.txtGrossWeight.Value
    //'this is in KG
    if Not GWKG="" then
	    if IsNumeric(GWKG)=False then
		    MsgBox "Please enter a numeric value for GrossWeight/KG!"
		    document.form1.txtGrossWeight.Value=""
		    exit Sub
	    end if
	    GWLB=GWKG*2.20462262185
        if (document.form1.txtGWLB.Value <> "" ) then
		    tmpNum = abs(GWLB - document.form1.txtGWLB.Value)
	    else
		    document.form1.txtGWLB.Value=formatNumberPlus(GWLB,2)	
	    end if

	    if ( tmpNum > 1 ) then 	document.form1.txtGWLB.Value=formatNumberPlus(GWLB,2)

    end if
End Sub

Sub CheckData2()
    GWLB=document.form1.txtGWLB.Value 
    //'this is in LB
    if Not GWLB="" then
	    if IsNumeric(GWLB)=False then
		    MsgBox "Please enter a numeric value for GrossWeight/LB!"
		    document.form1.txtGWLB.Value=""
		    exit Sub
	    end if
	    GWKG=GWLB*0.4535924277
    	
	    tmpNum = abs(GWKG - document.form1.txtGrossWeight.Value)

	    if ( tmpNum > 1 ) then  document.form1.txtGrossWeight.Value=Round(GWKG,2)
    	
    end if
End Sub

Sub CheckData3()
    MCBM=document.form1.txtMeasurement.Value 
    //'this is in CBM
    if Not MCBM="" then
	    if IsNumeric(MCBM)=False then
		    MsgBox "Please enter a numeric value for Measurement/CBM!"
		    document.form1.txtMeasurement.Value=""
		    exit Sub
	    end if
	    MCFT=MCBM*35.314666721
	    document.form1.txtMCFT.Value=Round(MCFT,2)
    end if
End Sub

Sub CheckData4()
    MCFT=document.form1.txtMCFT.Value //'this is in CFT
    if Not MCFT="" then
	    if IsNumeric(MCFT)=False then
		    MsgBox "Please enter a numeric value for Measurement/CFT!"
		    document.form1.txtMCFT.Value=""
		    exit Sub
	    end if
	    MCBM=MCFT/35.314666721
	    document.form1.txtMeasurement.Value=Round(MCBM,2)
    end if
End Sub

Sub DeleteHBOL()
    HBOL=document.form1.txtHBOL.Value
    	
    ok=MsgBox ("Are you sure you want to delete HBOL " & HBOL & "?" & chr(13) & "Continue?",36,"Message")
    if ok=6 then	

	    ////////////////////////////////////////	
	    IF NOT CHECK_IV_STATUS( HBOL ) THEN
		    EXIT SUB
	    END IF
	    ////////////////////////////////////////

	    document.form1.action=encodeURI("new_edit_hbol.asp?DeleteHBOL=yes&tNo=" & "<%=TranNo%>" & "&HBOL=" & HBOL& "&WindowName=" & window.name)
	    document.form1.method="POST"
	    document.form1.target=window.name	
	    form1.submit()
    end if
End Sub

Sub key()
    //HBOL=document.form1.txtHBOL.value
    //HBOL=Replace(HBOL," ","")
    //if Window.event.Keycode=13 then
    //	document.form1.action=encodeURI("new_edit_hbol.asp?hbol=" & HBOL & "&tNo=" & "<%=TranNo%>")
    //	document.form1.method="POST"
    //	form1.submit()
    //end if
End Sub

/////////////////////////////
Sub Lookup()
/////////////////////////////
    HBOL = UCase(document.form1.txtqHBOL.value)
    HBOLCopy = HBOL
    document.form1.txtqHBOL.value = ""
    HBOL = Replace(HBOL," ","")
    If Not HBOL = "" And Not HBOLCopy = "Search Here" Then
	    document.form1.action=encodeURI("new_edit_hbol.asp?hbol=" & HBOL & "&tNo=" & "<%=TranNo%>" & "&WindowName=" & window.name)
	    document.form1.method="POST"
	    document.form1.target=window.name	
	    form1.submit()
    Else
        msgbox "Please enter a House B/L No!"
    End If
End Sub

Sub bAddDemClick()
    Dim D1,D2,D3,D4,DD
    D1=document.form1.txtQty.Value
    D2=document.form1.txtLength.Value
    D3=document.form1.txtWidth.Value
    D4=document.form1.txtHeight.Value
    If IsNumeric(D1)=false Or IsNumeric(D2)=false Or IsNumeric(D3)=false Or IsNumeric(D4)=false then
	    msgbox "Please enter numerical values only!"
    Else
	    DD=D1 & "@" & D2 & "X" & D3 & "X" & D4 & Chr(10)
	    document.form1.txtDemDetail.Value=document.form1.txtDemDetail.Value & DD
	    document.form1.txtQty.Value=""
	    document.form1.txtLength.Value=""
	    document.form1.txtWidth.Value=""
	    document.form1.txtHeight.Value=""
    End If
End Sub

Sub ScaleChange()
    Scale=document.form1.lstScale.Value
    GrossWeight=document.form1.txtGrossWeight.Value
    Measurement=document.form1.txtMeasurement.Value
    Rate=document.form1.txtChargeRate.Value
    Total=document.form1.txtTotalWeightCharge.Value
    if Scale="K" then
	    if Not GrossWeight="" then
		    GrossWeight=Round(FormatNumberPlus(checkblank(GrossWeight,0),2)*0.454/1000,2)
	    end if
	    if Not Measurement="" then
		    Measurement=FormatNumberPlus(checkblank(Measurement,0),2)/35.314666721
	    end if
	    if Not Rate="" then
		    if GrossWeight>Measurement then
			    Rate=Rate/0.454
			    Total=GrossWeight
		    else
			    Rate=Rate*35.314666721
			    Total=Measurement
		    end if
		    Total=Total*Rate
	    end if
    else
	    if Not GrossWeight="" then
		    GrossWeight=Round(FormatNumberPlus(checkblank(GrossWeight,0),2)/454,2)
	    end if
	    if Not Measurement="" then
		    Measurement=FormatNumberPlus(checkblank(Measurement,0),2)*35.314666721
	    end if
	    if Not Rate="" then
		    if GrossWeight>Measurement then
			    Rate=Rate*0.454
			    Total=GrossWeight
		    else
			    Rate=Rate/35.314666721
			    Total=Measurement
		    end if
		    Total=Total*Rate
	    end if
    end if
    document.form1.txtGrossWeight.Value=GrossWeight*1000
    document.form1.txtMeasurement.Value=Measurement
    document.form1.txtChargeRate.Value=Rate
    document.form1.txtTotalWeightCharge.Value=Round(Total,2)
    End Sub

Sub COLOClick()
	if document.form1.cCOLO.checked=false then
		document.form1.lstCOLOPay.style.visibility="hidden"
	else
		document.form1.lstCOLOPay.style.visibility="visible"
	end if
End Sub

Sub PrefixChange()
    sindex=document.form1.lstHBOLPrefix.selectedindex
    Prefix=document.form1.lstHBOLPrefix.item(sindex).Text
    document.form1.hHBOLPrefix.Value=Prefix
End Sub

Sub MBOLEditClick()

    If document.form1.hSearchNum.Value <> "" And document.form1.hSearchNum.Value<>"0" Then
	    BookingNum = document.form1.hSearchNum.Value
	    window.location.href = encodeURI("new_edit_mbol.asp?WindowName=<%=WindowName %>&edit=yes&BookingNum=" & BookingNum & "&NotifyAcct=" & "<%= vNotifyAcct %>")
    End If
    
End Sub

Sub DimCalClick(Scale)
    props = "scrollBars=no,resizable=yes,toolbar=no,menubar=no,location=no,directories=no,width=350,height=280"
    window.open "dimcal.asp?S=" & Scale, "Dimension_Calculation", props
End Sub

Sub MenuMouseOver()
  document.form1.lstHBOLPrefix.style.visibility="hidden"
End Sub

Sub MenuMouseOut()
  document.form1.lstHBOLPrefix.style.visibility="visible"
End Sub

sub goToMasterHouse
	HAWB="<%=vM_HAWB%>"
	if HAWB="" then
		Exit sub 
	end if 
	window.location.href = encodeURI("new_edit_hbol.asp?Hbol=" & HAWB & "&tNo=" & "<%=TranNo%>")
end sub 
--->

sub closeMasterHouse
	HAWB=document.getElementById("txtHBOL").value 
	if HAWB="" then
		Exit sub 
	end if 
	document.form1.action=encodeURI("new_edit_hbol.asp?CloseMH=Y&HBOL="& HAWB & "&tNo=" & "<%=TranNo%>")
	document.form1.method="POST"
	document.form1.target=window.name
	form1.submit()	
end sub 

sub openMasterHouse
	HAWB=document.getElementById("txtHBOL").value 
	if HAWB="" then
		Exit sub 
	end if 
	document.form1.action=encodeURI("new_edit_hbol.asp?OpenMH=Y&HBOL="& HAWB & "&tNo=" & "<%=TranNo%>")
	document.form1.method="POST"
	document.form1.target=window.name
	form1.submit()	
end sub 

Sub AddToMaster(addSUB,addELTAcct)
	document.form1.action=encodeURI("new_edit_hbol.asp?addSUB=yes&Edit=yes&addSUBNo=" & addSUB & "&addELTAcct=" & addELTAcct & "&hbol=" & "<%=vHBOL%>" & "&MBOL=" & "<%=vMBOL%>" & "&tNo=" & "<%=TranNo%>" & "&WindowName=" & window.name)
	document.form1.method="POST"
	document.form1.target = window.name
	form1.submit()
End Sub

Sub EditHBOL(HBOL)
	window.open encodeURI("new_edit_hbol.asp?HBOL=" & HBOL & "&tNo=" & "<%=TranNo%>") ,"popupNew", ""
End Sub

Sub RemoveSH(rSHAWB,ELTACT)
	document.form1.action=encodeURI("new_edit_hbol.asp?RemoveSH=Y&rSHAWB=" & rSHAWB &"&ELTACT=" & ELTACT & "&HBOL=" & "<%=vHBOL%>" & "&tNo=" & "<%=TranNo%>" & "&WindowName=" & window.name)
	document.form1.method="POST"
	document.form1.target=window.name
	form1.submit()	
End Sub 
	//change by stanley on 6/19/2007

Sub NewPrintVeiw()
    Dim props,HAWB
    HAWB=document.getElementById("txtHBOL").value 
    If HAWB <> "" Then
        props = "scrollBars=no,resizable=yes,toolbar=no,menubar=no,location=no,directories=no,status=yes,width=880,height=650"
        window.open encodeURI("view_print.asp?sType=house&hbol=" & HAWB), "popUpWindow", props
	else
		alert("Please, select HOUSE B/L NO. to view PDF")
    End If
End Sub

sub MakeMasterHouse
	document.form1.hCheckMH.Value="Y"
	SaveClick "<%= TranNo %>","no" 	
end sub 

sub DiscardMasterHouse
	document.form1.hCheckMH.Value="N"
	document.form1.hDiscardMH.Value="Y"	
	SaveClick "<%= TranNo %>","no" 	
end sub 

</script>

<!--  #INCLUDE FILE="../include/OrgSearch.asp" -->

<script language="JavaScript" type="text/javascript" src="../include/tooltips.js"></script>

<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
