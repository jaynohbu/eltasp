<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/GOOFY_Util_Ver_2.inc" -->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>New/Edit MBOL</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <base target="_self" />
 
    <script type="text/jscript" src="../include/CollapsibleRows.js"></script>
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <script type="text/vbscript">
        Function makeMsgBox(tit,mess,icon,buts,defs,mode)   'never used
           butVal = icon + buts + defs + mode
           makeMsgBox = MsgBox(mess,butVal,tit)
        End Function

        Function setDefaultFreight()    'never used
            RET=makeMsgBox("Check if Ocean Freight Cost is set","Default Ocean Freight Cost Item is not set in your Company Profile, would you like to set it before you move on?",48,4,0,4096)
            if RET = 6 THEN window.location="/ASP/SITE_ADMIN/co_config.asp?DOFCost=Y"  end if
        End Function
    </script>
    <script type="text/javascript">

        function checkDecimalTextMax(obj, limit) {
            if (obj.value.length >= limit) {
                var temp = obj.value;
                var tempArray = new Array();
                tempArray = temp.split(".");
                temp = tempArray[0];
                if (temp.length >= limit) {
                    obj.value = temp.substring(0, limit);
                }
                else {
                    obj.value = parseFloat(obj.value).toFixed(2);
                }
                return false;
            }
            else {
                return true;
            }
        }

        function validateSalesRep() {

            var txtSalesRep = document.getElementById("txtSalesRep");
            var salesRep = txtSalesRep.value;
            if (salesRep != "") {
                return true;
            }
            else {
                return false;
            }
        }

        function docModified(arg) {
        }


        // var ComboBoxes =  new Array('list1','list2','list3',.....);

        var ComboBoxes = new Array('lstBookingNum');

    </script>
    <script type="text/javascript" src="../include/JPED.js"></script>
    <script type="text/jscript" src="/ASP/ajaxFunctions/ajax.js"></script>
    <script type="text/jscript">
        function lstShipperNameChange(orgNum, orgName) {
            var hiddenObj = document.getElementById("hShipperAcct");
            var infoObj = document.getElementById("txtShipperInfo");
            var txtObj = document.getElementById("lstShipperName");
            var divObj = document.getElementById("lstShipperNameDiv")

            hiddenObj.value = orgNum;
            infoObj.value = getOrganizationInfo(orgNum);
            txtObj.value = orgName;

            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
            divObj.style.height = "0px";
        }

        function lstConsigneeNameChange(orgNum, orgName) {
            var hiddenObj = document.getElementById("hConsigneeAcct");
            var infoObj = document.getElementById("txtConsigneeInfo");
            var txtObj = document.getElementById("lstConsigneeName");
            var divObj = document.getElementById("lstConsigneeNameDiv");

            hiddenObj.value = orgNum;
            infoObj.value = getOrganizationInfo(orgNum);
            txtObj.value = orgName;

            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
            divObj.style.height = "0px";
            lstNotifyNameChange(orgNum, orgName);
        }

        function lstNotifyNameChange(orgNum, orgName) {
            var hiddenObj = document.getElementById("hNotifyAcct");
            var infoObj = document.getElementById("txtNotifyInfo");
            var txtObj = document.getElementById("lstNotifyName");
            var divObj = document.getElementById("lstNotifyNameDiv")

            hiddenObj.value = orgNum;
            infoObj.value = getOrganizationInfo(orgNum);
            txtObj.value = orgName;
            divObj.style.visibility = "hidden";
            divObj.style.position = "absolute";
            divObj.style.height = "0px";
        }

        function getOrganizationInfo(orgNum) {
            if (window.ActiveXObject) {
                try {
                    xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
                } catch (error) {
                    try {
                        xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
                    } catch (error) { return ""; }
                }
            }
            else if (window.XMLHttpRequest) {
                xmlHTTP = new XMLHttpRequest();
            }
            else { return ""; }

            var url = "/ASP/ajaxFunctions/ajax_get_org_address_info.asp?type=B&org=" + orgNum;

            xmlHTTP.open("GET", url, false);
            xmlHTTP.send();

            return (xmlHTTP.responseText);
        }

        function SetCostItems() {
            var vURL = "./new_edit_mbol_cost_items.asp?BookingNum=" + encodeURIComponent(document.getElementsByName("hBookingNum").value);
            var vWinArg = "dialogWidth:600px; dialogHeight:400px; help:no; status:no; scroll:yes; center:yes";
            var vReturn = showModalDialog(vURL, "popWindow", vWinArg);
        }

        function SetCreditNote() {
            if(document.getElementById("hMBOL").value=="")
            {
                alert("Master Bill of Ladding No. is required!");
                return;
            }
            var vWinArg = "dialogWidth:600px; dialogHeight:400px; help:no; status:no; scroll:yes; center:yes";
            var vReturn = showModalDialog("/ASP/acct_tasks/credit_note_list.asp?TYPE=O&MAWB=" + document.getElementById("hMBOL").value + "&HAWB=", "popWindow", vWinArg);
            var url="";
            if (vReturn >= 0) {
                
                //try { parent.document.frames['topFrame'].changeTopModule("Accounting"); } catch (err) { }


                if (vReturn == 0) {
                    url=
                    "/ASP/acct_tasks/edit_credit_note.asp?"
                    + 
                        "new=yes&MoveType=OCEAN&MasterOnly=Y&InvType=Agent&AgentID="
                        + document.getElementById("hShipperAcct").value
                        + "&BookingNum="
                        + document.getElementById("lstBookingNum_Text").value
                        + "&HBOL=";
                  

                   // window.location.href = "../acct_tasks/edit_credit_note.asp?new=yes&MoveType=OCEAN&MasterOnly=Y&InvType=Agent&AgentID=" + document.getElementById("hShipperAcct").value + "&BookingNum=" + encodeURIComponent(document.getElementsByName("txtMBOL").value) + "&HBOL=";
                }
                else {
                    url =
                    "/ASP/acct_tasks/edit_credit_note.asp?"
                    + "edit=yes&InvoiceNo=" + vReturn
                    ;
                    //window.location.href = "../acct_tasks/edit_credit_note.asp?edit=yes&InvoiceNo=" + vReturn;
                }

                viewPop(url);
            }
        }
        function EditClick(HAWB, MAWB) {
            url = "/IFF_MAIN/ASPX/Misc/EditOceanAES.aspx?AESID=&HAWB=" + encodeURIComponent(HAWB) + "&MAWB=" + encodeURIComponent(MAWB) + "&WindowName=popUpWindow";
            openWindowFromSearch(url);
        }

        function openWindowFromSearch(url) {
            window.open(url, "popUpWindow", "menubar=0,toolbar=0,hotkeys=1,status=1,location=0,scrollbars=1,resizable=1,width=900,height=600");
        }
    </script>
    <script type="text/jscript" src="../Include/iMoonCombo.js"></script>

    <style type="text/css">
        body
        {
            margin-left: 0px;
            margin-right: 0px;
            margin-bottom: 0px;
        }
        .style1
        {
            color: #cc6600;
            font-weight: bold;
        }
        .numberalign
        {
            font-weight: normal;
            font-size: 9px;
            text-align: right;
            font-family: Verdana, Arial, Helvetica, sans-serif;
        }
        .style4
        {
            color: #663366;
        }
        .style5
        {
            color: #cc6600;
        }
        .style8
        {
            font-size: 10px;
            font-weight: bold;
            color: #cc6600;
        }
        .style9
        {
            color: #CC3333;
            font-weight: bold;
            font-size: 10px;
            font-family: Verdana, Arial, Helvetica, sans-serif;
        }
    </style>
</head>
<!-- #INCLUDE FILE="../include/header.asp" -->
     <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
<!-- #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<%

Dim bill_num,vDefaultFreightCostNo,vDefaultFreightCostDesc,vTotalRealCost
Dim vLock_ap,vAgentOrgAcct,vRateRealCost,vProcessDT,vDefaultAccountExpense
Dim vDefault_SalesRep	
vDefault_SalesRep=session_user_lname	
Dim rs,SQL,rs3,rs1
Dim Save,Add,AddOC,DeleteOC,Edit,Delete,GoNext,vHBOL,vMBOL,vBookingNum
Dim ChangeBookingNum,DeleteMBOL,AdjustWeight
DIM vLoadingPier,vLoadingPort,bIndex,cIndex,sIndex,vIndex,avindex,seIndex,vDimText
Dim aCountryCodeArry(400),aCountryArry(400),aConIndex,tmpCode
DIM tmpIVstrMsg,vTotalHAWB
DIM	vCollectOtherCharge,vPrepaidOtherCharge
Dim totalOC,vTotalChgWT
DIM vWeightCP,vScale,vGWLB,vMCFT,tIndex,NoItem,IVstrMsg
Dim vAgentName,vAgentInfo,vAgentAcct
Dim vShipperName,vShipperInfo,vShipperAcct
Dim vConsigneeName,vConsigneeInfo,vConsigneeAcct
Dim vExportRef,vOriginCountry,vExportInstr,vLandingPier,vMoveType
Dim vConYes,vPreCarriage,vPreReceiptPlace
Dim vExportCarrier,vLandingPort,vUnloadingPort,vDepartureDate
Dim vDeliveryPlace,vDesc1,vDesc2,vDesc3,vPieces,vGrossWeight,vDesc4,vDesc5
Dim vMeasurement,aExportRef
Dim aItemNo(1024),aItemName(1024),aItemDesc(1024),aChargeItemNameig(1024),chIndex
DIM aChargeUnitPrice(1024) ' Unit_Price // by ig 10/21/2006
Dim aBookingNum(),aExportCarrier(100),aLoadingPort(100),aUnloadingPort(100)
Dim aDeliveryPlace(100),aBookingInfo(2)
Dim aHBOL(1024),aExporter(1024),aConsignee(1024),aPieces(1024),aGrossWeight(1024),aMeasurement(1024),aColodeeAcct(1024)
Dim sHBOL(1024),sExporter(1024),sConsignee(1024),sPieces(1024),sGrossWeight(1024),sMeasurement(1024),sColodeeAcct(1024)
Dim TotalPieces,TotalGrossWeight,TotalMeasurement
Dim vNotifyName,vNotifyInfo,vNotifyAcct,nIndex

'// For MBOL that does not have HBOL by ig 07/24/2006
'////////////////////////////////////////////////////////////////
Dim vShowPrepaidWeightCharge,vShowCollectWeightChargedesc4
Dim vWidth,vLength,vHeight,vChargeableWeight,vChargeRate
Dim vTotalWeightCharge
Dim vShowPrepaidOtherCharge,vShowCollectOtherCharge
Dim vOtherChargeCP,vChargeItem,vChargeAmt,vVendor,vCost
Dim vDeclaredValue,vBy,vDate,vPlace
Dim aChargeCP(128),aChargeItem(128),aChargeAmt(128),aChargeVendor(128)
Dim aChargeNo(128),aChargeItemName(128)
Dim vTotalPrepaid,vTotalCollect,vUnitQty
'////////////////////////////////////////////////////////////////
Dim setExpanded
Dim vSalesPerson
Dim aSRName(1000)
Dim SRIndex
Dim vAES,vSEDStmt,vSONum,vPONum

'/// by MOON 10/22/2006
DIM vLb1,vCF1

DIM vUOM,aKgLb(3)

CALL INITIALIZATION

Save=Request.QueryString("Save")
Add=Request.QueryString("Add")
Edit=Request.QueryString("Edit")
Delete=Request.QueryString("Delete")
GoNext=Request.QueryString("GoNext")
vHBOL=Request.QueryString("HBOL")
vMBOL=Request.QueryString("MBOL")
vBookingNum=Request.QueryString("BookingNum")
ChangeBookingNum=Request.QueryString("ChangeBookingNum")
DeleteMBOL=Request.QueryString("DeleteMBOL")
AdjustWeight=Request.QueryString("AdjustWeight")
AddOC=Request.QueryString("AddOC")
DeleteOC=Request.QueryString("DeleteOC")


'// If master is not saved yet bring booking info
If Edit="yes" Then
    If GetSQLResult("SELECT booking_num FROM mbol_master WHERE elt_account_number=" & elt_account_number & " AND booking_num=N'" & vMBOL & "'",Null) = "" Then
        ChangeBookingNum = "yes"
    End If
End If

eltConn.BeginTrans
CALL MAIN_PROCESS
eltConn.CommitTrans

SUB MAIN_PROCESS

   
    vUnitQty = GetSQLResult("SELECT uom_qty FROM user_profile WHERE elt_account_number=" & elt_account_number, "uom_qty")
    CALL GET_DEFAULT_FREIGHT_COST_FROM_DB
    CALL GET_SALES_PERSONS_FROM_USERS
    if DeleteMBOL="yes" then
		CALL INVOICE_QUEUE_REFRESH( vBookingNum )
		CALL DELETE_MBOL
	end if

	CALL GET_AGENT_GENERAL_INFORMAION
    
    if Save="yes" or Add="yes" or Delete="yes"  or AddOC="yes" or DeleteOC="yes" then

	    CALL GET_MBOL_INFO_FROM_SCREEN
    	
    '///////////////////////////////////////////////////// new	
	    CALL GET_ITEM_WEIGHT_CHARGE_INFO_SCREEN
	    CALL GET_ITEM_OTHER_CHARGE_INFO_SCREEN
    '///////////////////////////////////////////////////// new	

	    if Delete="yes" then
		    CALL CHECK_INVOICE_STATUS_HAWB(	vHBOL )	
		    CALL UPDATE_HBOL_MASTER_TABLE_FOR_MBOL_DELETE( vHBOL )
	    end if
    	
	    if Add="yes" then
		    CALL CHECK_INVOICE_STATUS_HAWB(	vHBOL )	
		    CALL UPDATE_HBOL_MASTER_TABLE_FOR_MBOL_ADD( vHBOL )
	    end if
   
	    if Save="yes" then
	       if save_cost_item_and_bill_detail_trans("O","E") then 
			    CALL INVOICE_QUEUE_REFRESH( vBookingNum )
			    CALL MBOL_INVOICE_QUEUE( vBookingNum )				
			    CALL UPDATE_MBOL_MASTER_TABLE
			    CALL UPDATE_MBOL_OTHER_CHARGE_TABLE
			    if GoNext="yes" then
				    tmpUrl = "bol_instruction.asp?BookingNum=" & vBookingNum
                    %>
                    <script type="text/javascript">
                        var props = "scrollBars=yes,resizable=yes,toolbar=no,menubar=no,location=no,directories=no,width=500,height=450";
                        window.open("<%= tmpUrl %>", "bol_instruction", props);
                    </script>
                    <%			
			    end if
		    end if 
	    end if

   
    elseif vBookingNum="" then
      
	    tIndex=4
	    vDesc3="SAID TO CONTAIN:"
    	
    elseif not vBookingNum="" then
                         
	    vTotalPrepaid = 0
	    vTotalCollect = 0
	    CALL GET_MBOL_INFO_FROM_TABLE
	    CALL GET_MB_COST_ITEM_FROM_DB
	    CALL GET_MBOL_ITEM_OTHER_CHARGE_FROM_TABLE
    end if

    CALL GET_SELECTED_HBOL_INFO
    CALL GET_AVAILABLE_HBOL_INFO
    '//CALL GET_COUNTRY_NAME
    CALL GET_CHARGE_ITEM_INFO

    CALL GET_BOOKING_NUMBER
    CALL FINAL_SCREEN_PREPARE
    CALL GET_PRESHIPMENT_DATA
    
END SUB

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
                vGrossWeight = CheckBlank(rs("Total_Gross_Weight"),0)
                vGWLB = formatNumber(2.2046 * CLng(vGrossWeight),2,,,0)
            Else
                vGWLB = CheckBlank(rs("Total_Gross_Weight"),0)
                vGrossWeight = formatNumber(0.4535924277 * CLng(vGWLB),2,,,0)
            End If
        End If

        rs.close()
    
    End If
    
    If Save="yes" And vSONum <> "" Then
	    SQL="UPDATE warehouse_shipout SET file_type='OE',master_num=N'" & vBookingNum _
	        & "',house_num='' WHERE so_num=N'" & vSONum & "'"
	    eltConn.Execute(SQL)
	Elseif Save = "yes" And vPONum <> "" Then
        SQL="UPDATE pickup_order SET file_type='OE',MAWB_NUM=N'" & vMAWB _
	        & "',HAWB_NUM=N'' WHERE po_num=N'" & vPONum & "'"
	    eltConn.Execute(SQL)
    End If
End Sub


%>
<%
Function CHECK_SHOULD_INVOICE_QUEUED(hawb)
'response.Write("-----------"&hawb)
    dim rs,SQL
	Set rs = Server.CreateObject("ADODB.Recordset")
	SQL= "select isnull(is_sub,'N') as is_sub,isnull(is_master,'N') as is_master," _
	    & "isnull(is_invoice_queued,'Y') as is_invoice_queued from hbol_master " _
	    & "where elt_account_number = " & elt_account_number & " And mbol_num=N'" _
	    & vMBOL & "' And hbol_num=N'" & hawb & "'"
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	If Not rs.EOF Then
	    if rs("is_sub")="Y" OR  rs("is_master")="Y" then
			if  rs("is_invoice_queued") ="N" then
				CHECK_SHOULD_INVOICE_QUEUED=false
			else 
				CHECK_SHOULD_INVOICE_QUEUED=true
			end if 
		else 
			CHECK_SHOULD_INVOICE_QUEUED=true
		end if
	END IF 
	rs.close
	set rs=Nothing 
End Function


%>
<%
SUB getDefaultSalesPersonFromDB
  if isnull(vShipperAcct) or vShipperAcct = 0 then
   vSalesPerson ="" 
  else 
   SQL= "select SalesPerson from organization where elt_account_number = " _
    & elt_account_number & " and org_account_number = " & vShipperAcct
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

SUB GET_SALES_PERSONS_FROM_USERS

   SQL= "select code from all_code where elt_account_number = " & elt_account_number _
    & " and type=22 order by code"
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

%>
<%
SUB GET_MBOL_ITEM_OTHER_CHARGE_FROM_TABLE
    SQL= "select tran_no,coll_prepaid,charge_code,charge_desc,charge_amt from " _
        & "mbol_other_charge where elt_account_number = " & elt_account_number _
        & " and booking_num=N'" & vBookingNum & "' order by tran_no"
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
		tIndex=0
		Do while Not rs.EOF
			aChargeNo(tIndex)=rs("tran_no")
			aChargeCP(tIndex)=rs("coll_prepaid")
			aChargeItem(tIndex) = ConvertAnyValue(rs("charge_code"),"Long",0)
			aChargeItemName(tIndex)=rs("charge_desc")
			aChargeAmt(tIndex)=ConvertAnyValue(rs("charge_amt").value,"Amount",0)
			if aChargeCP(tIndex)="P" then
				vTotalPrepaid=vTotalPrepaid+aChargeAmt(tIndex)
			else
				vTotalCollect=vTotalCollect+aChargeAmt(tIndex)
			end if
			rs.MoveNext
			tIndex=tIndex+1
		Loop
        'Response.Write "tIndex"&tIndex
		rs.Close
END SUB
%>
<%
SUB UPDATE_MBOL_OTHER_CHARGE_TABLE
    SQL= "delete from mbol_other_charge where elt_account_number = " & elt_account_number _
        & " and booking_num=N'" & vBookingNum & "'" 
		eltConn.Execute SQL
		ii=1
		for i=0 to NoItem-1
			if Not aChargeItem(i)=0 Or not aChargeAmt(i)=0 then
				SQL= "select * from mbol_other_charge where elt_account_number = " _
				    & elt_account_number & " and booking_num=N'" & vBookingNum & "' and tran_no=" & i
				rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
				rs.AddNew
				rs("elt_account_number")=elt_account_number
				rs("booking_num")=vBookingNum
				rs("mbol_num")=vMBOL
				rs("tran_no")=i
				rs("coll_prepaid")=aChargeCP(i)
				rs("charge_code")=aChargeItem(i)
				rs("charge_desc")=aChargeItemName(i)
				rs("charge_amt")=aChargeAmt(i)
				rs.Update
				rs.Close
				ii=ii+1
			end if
		next	
END SUB
%>
<% 
SUB CalcTotalOC

totalOC=0
ItemNo=Request("hNoItem")
'//response.Write("----------------"&ItemNo)
'**
for i=0 to ItemNo-1
    totalOC=totalOC+aChargeAmt(i)
next	
'**
'//response.Write("----------------"&totalOC)
END SUB
%>
<%
SUB GET_ITEM_OTHER_CHARGE_INFO_SCREEN


	NoItem = ConvertAnyValue(Request("hNoItem"),"Long",0)

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
			aChargeItem(i)=ConvertAnyValue(left(aChargeItem(i),pos-1),"Long",0)
		else
			On Error Resume Next:
			aChargeItem(i)=ConvertAnyValue(Request("lstChargeItem" & i),"Long",0)
		end if
		aChargeAmt(i) = ConvertAnyValue(Request("txtChargeAmt" & i),"Amount",0)
	next

	tIndex=NoItem
	if DeleteOC="yes" then
		dItemNo=Request.QueryString("dItemNo")
		for i=dItemNo to NoItem-1
			aChargeNo(i)=aChargeNo(i+1)
			aChargeCP(i)=aChargeCP(i+1)
			aChargeItem(i)=aChargeItem(i+1)
			aChargeItemName(i)=aChargeItemName(i+1)
			aChargeAmt(i)=aChargeAmt(i+1)
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
SUB INITIALIZATION
Set rs = Server.CreateObject("ADODB.Recordset")
Set rs1 = Server.CreateObject("ADODB.Recordset")
Set rs3 = Server.CreateObject("ADODB.Recordset")

setExpanded =(Not Add="yes" and  Not Delete="yes" and Not GoNext ="yes" and  Not DeleteMBOL ="yes" )

END SUB
%>
<%
SUB GET_AGENT_GENERAL_INFORMAION
DIM AgentAddress,AgentCity,AgentState,AgentZip,AgentCountry
	SQL= "select dba_name,business_address,business_city,business_state,business_zip,business_country from agent where elt_account_number = " & elt_account_number
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	If Not rs.EOF Then
		vAgentName = rs("dba_name")
		AgentAddress=rs("business_address")
		AgentCity = rs("business_city")
		AgentState = rs("business_state")
		AgentZip = rs("business_zip")
		AgentCountry = rs("business_country")
		vShipperInfo=vAgentName & chr(10) & AgentAddress & chr(10) & AgentCity & "," & AgentState & " " & AgentZip & " " & AgentCountry
		vBy=vAgentName
		vPlace=AgentCity
	End If
	rs.Close
	vDate=date

END SUB
%>
<%
SUB DELETE_MBOL
	SQL= "delete from mbol_master where elt_account_number = " & elt_account_number & " AND booking_num=N'" & vBookingNum &"'"
	eltConn.Execute SQL
	SQL= "delete from mbol_other_charge where elt_account_number = " & elt_account_number & " AND booking_num=N'" & vBookingNum &"'"
	eltConn.Execute SQL
	SQL= "delete from mbol_other_cost where elt_account_number = " & elt_account_number & " AND booking_num=N'" & vBookingNum &"'"
    eltConn.Execute SQL
	vBookingNum=""
	vMBOL=""
END SUB
%>
<%
SUB GET_MBOL_INFO_FROM_SCREEN
	vTotalPrepaid=0
	vTotalCollect=0

    '----------------------------------------------------------
	vSalesPerson=Request("lstSalesRP")
    if vSalesPerson = "none" then
       Call getDefaultSalesPersonFromDB
    end if 
	'----------------------------------------------------------
	
	vMBOL=Request("hMBOL")
	vBookingNum=Request("hBookingNum")
	
	if vBookingNum="Select One" then vBookingNum=""
	
	vShipperName=Request("lstShipperName")
	vShipperInfo=Request("txtShipperInfo")
	vShipperAcct=Request("hShipperAcct")
	
	vShipperAcct=ConvertAnyValue(vShipperAcct,"Integer",0)

	vConsigneeName=Request("lstConsigneeName")
	vConsigneeInfo=Request("txtConsigneeInfo")
	vConsigneeAcct=Request("hConsigneeAcct")
	
	vConsigneeAcct=ConvertAnyValue(vConsigneeAcct,"Integer",0)

	vNotifyName=Request("lstNotifyName")
	vNotifyInfo=Request("txtNotifyInfo")
	vNotifyAcct=Request("hNotifyAcct")
	
	vNotifyAcct=ConvertAnyValue(vNotifyAcct,"Integer",0)

	vExportRef=Request("txtExportRef")
	vAgentInfo=Request("txtAgentInfo")
	vOriginCountry=Request("txtOriginCountry")
	vExportInstr=Request("txtExportInstr")
	vLoadingPier=Request("txtLoadingPier")
	vDimText=Request("dimtext")
	vMoveType=Request("lstMoveType")
	vConYes=Request("cConYes")
	vPreCarriage=Request("txtPreCarriage")
	vPreReceiptPlace=Request("txtPreReceiptPlace")
	vExportCarrier=Request("txtExportCarrier")
	vLoadingPort=Request("txtLoadingPort")
	vUnloadingPort=Request("txtUnloadingPort")
	vDeliveryPlace=Request("txtDeliveryPlace")
	vDepartureDate=Request("hDepartureDate")
	if IsDate(vDepartureDate)=false then vDepartureDate="1/1/1900"
	vPieces=Request("txtTotalPieces")
	if vPieces="" then vPieces=0
	vGrossWeight=Request("txtTotalGrossWeight")
	vMeasurement=Request("txtTotalMeasurement")
	if vMeasurement="" then vMeasurement=0
	if vGrossWeight="" Or IsNull(vGrossWeight) then vGrossWeight=0
	vDesc1=Request("txtDesc1")
	vDesc2=Request("txtDesc2")
	vDesc3=Request("txtDesc3")
	vDesc4=Request("txtDesc4")
	vDesc5=Request("txtDesc5")
	
	vAES = CheckBlank(Request.Form.Item("txtAES"),"")
    If vAES = "" Then
	    vSEDStmt = Request.Form.Item("txtSEDStatement")
	Else
	    vSEDStmt = ""
	End If
END SUB
%>
<% 
SUB UPDATE_HBOL_MASTER_TABLE_FOR_MBOL_DELETE( vHBOL )
	dim NoFound
	SQL= "select elt_account_number,booking_num,hbol_num from hbol_master where (elt_account_number = " & elt_account_number & " or coloder_elt_acct="& elt_account_number&") and hbol_num=N'" & vHBOL & "'"
	rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	NoFound=false
	If not rs.EOF then
		rs("booking_num")=""
		rs.Update
	else 
		NoFound=true
	end if
	rs.Close
	
	'if not isempty(request.QueryString("ColoAcct"))then 
			'ColoAcct=request.QueryString("ColoAcct")
			'ColoAcct=ConvertAnyValue(ColoAcct,"Long",0)
			'SQL= "select elt_account_number,booking_num,hbol_num from hbol_master where elt_account_number = " & ColoAcct & " and hbol_num='" & vHBOL & "'"
			'rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
			'If not rs.EOF then
				'rs("booking_num")=""
				'rs.Update
			'end if
			'rs.Close
	'end if 

END SUB	
%>
<% 
SUB UPDATE_HBOL_MASTER_TABLE_FOR_MBOL_ADD( vHBOL )
        dim NoFound
		SQL= "select elt_account_number,hbol_num,booking_num,export_carrier,origin_country,loading_port,unloading_port,departure_date,move_type from hbol_master where ( elt_account_number = " & elt_account_number & " OR coloder_elt_acct=" & elt_account_number&") and hbol_num=N'" & vHBOL & "'"
		rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
		'response.Write("---------"&SQL)
		'response.End()
		NoFound=false
		If not rs.EOF then
			rs("booking_num")=vBookingNum
			rs("export_carrier")=vExportCarrier
			rs("origin_country")=vOriginCountry
			rs("loading_port")=vLoadingPort
			rs("unloading_port")=vUnloadingPort
			rs("departure_date")=vDepartureDate
			rs("move_type")=vMoveType
			rs.Update
		else 
			NoFound=true
		end if 
		rs.Close
		'dim ColoAcct
		
		'if not isempty(request.QueryString("ColoAcct"))then 
			'ColoAcct=request.QueryString("ColoAcct")
			'ColoAcct=ConvertAnyValue(ColoAcct,"Long",0)
			'response.Write("---------"&request.QueryString("ColoAcct"))
			'SQL= "select elt_account_number,hbol_num,booking_num,export_carrier,origin_country,loading_port,unloading_port,departure_date,move_type from hbol_master where elt_account_number = " & ColoAcct & " and hbol_num='" & vHBOL & "'"
			'rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
			
			'response.Write("---------"&SQL)
			'If not rs.EOF then
			'	rs("booking_num")=vBookingNum
			'	rs("export_carrier")=vExportCarrier
			'	rs("origin_country")=vOriginCountry
			'	rs("loading_port")=vLoadingPort
			'	rs("unloading_port")=vUnloadingPort
			'	rs("departure_date")=vDepartureDate
			'	rs("move_type")=vMoveType
			'	rs.Update
			'end if 
			'rs.close
		'end if
END SUB	
%>
<%
SUB UPDATE_MBOL_MASTER_TABLE

       Call CalcTotalOC
       
		'/////////////////////////////////
		vTotalHAWB=Request("hTotalHAWB")
		if vTotalHAWB="" then vTotalHAWB=0
		'/////////////////////////////////

		SQL= "select * from mbol_master where elt_account_number = " & elt_account_number & " and booking_num=N'" & vBookingNum & "'"
		rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
		If rs.EOF then
			rs.AddNew
			
			rs("total_other_charge")=totalOC
						
			rs("elt_account_number")=elt_account_number
			rs("booking_num")=vBookingNum
			rs("tran_date")=date
			'----------------------------------------------------------
			 rs("CreatedBy")=session_user_lname	
			 rs("CreatedDate")=Now
		 	 rs("SalesPerson")=vSalesPerson				
			'----------------------------------------------------------
		end if
		rs("mbol_num")=vMBOL
		rs("shipper_name")=vShipperName
		rs("shipper_info")=vShipperInfo
		rs("shipper_acct_num")=vShipperAcct
		
		rs("consignee_name")=vConsigneeName
		rs("consignee_info")=vConsigneeInfo
		rs("consignee_acct_num")=vConsigneeAcct
		
		'// Commented out by Joon
		'// if vTotalHAWB = 0 then
		'//	rs("agent_name")=vConsigneeName
		'//	rs("agent_acct_num")=vConsigneeAcct		
		'//	rs("agent_info")=vConsigneeInfo
		'// Else
		'//	rs("agent_info")=vAgentInfo		
		'// End if
		
		rs("agent_info")=vAgentInfo
		
		rs("notify_name")=vNotifyName
		rs("notify_info")=vNotifyInfo
		rs("notify_acct_num")=vNotifyAcct
		
		rs("export_ref")=vExportRef
		rs("origin_country")=vOriginCountry
		rs("export_instr")=vExportInstr
		rs("loading_pier")=vLoadingPier
		rs("dimtext")=vDimText
		rs("move_type")=vMoveType
		rs("containerized")=vConYes
		rs("pre_carriage")=vPreCarriage
		rs("pre_receipt_place")=vPreReceiptPlace
		rs("export_carrier")=vExportCarrier
		rs("loading_port")=vLoadingPort
		rs("unloading_port")=vUnloadingPort
		rs("delivery_place")=vDeliveryPlace
		rs("departure_date")=vDepartureDate
		rs("pieces")=vPieces
		rs("gross_weight")=vGrossWeight
		rs("measurement")=vMeasurement
		rs("desc1")=vDesc1
		rs("desc2")=vDesc2
		rs("desc3")=vDesc3
		rs("desc4")=vDesc4
		rs("desc5")=vDesc5
		rs("manifest_desc")=vManifestDesc
		rs("weight_cp")=vWeightCP
		rs("dem_detail")=vDemDetail
		rs("declared_value")=vDeclaredValue
		rs("tran_by")=vBy
		rs("tran_place")=vPlace
		rs("last_modified")=Now
		rs("prepaid_invoiced")="N"
		rs("collect_invoiced")="N"
		rs("unit_qty")=vUnitQty
		rs("charge_rate")=vChargeRate
		rs("total_weight_charge") = vTotalWeightCharge
		rs("SalesPerson")=	vSalesPerson	
		rs("ModifiedBy")= session_user_lname
		rs("ModifiedDate")=Now
		rs("total_other_charge")=totalOC
        rs("aes_xtn")=vAES
        rs("sed_stmt")=vSEDStmt
		'---------------------------------------------------here we save realcost
		rs("Total_Freight_Cost") = vTotalRealCost
		rs.Update
		rs.Close
END SUB
%>
<%
SUB GET_MBOL_INFO_FROM_TABLE

    DIM tmpShipperName,tmpShipperInfo,tmpShipperAcct

	tmpShipperName=Request("lstShipperName")
	tmpShipperInfo=Request("txtShipperInfo")
	tmpShipperAcct=Request("hShipperAcct")
    vSONum = Request.Form("hSONum")
    vPONum = Request.Form("hPONum")
    
	if isnull(tmpShipperName) then tmpShipperName = ""
	if tmpShipperName = "Select One" then tmpShipperName = ""

	if trim(tmpShipperName) <> "" then
		vShipperName=tmpShipperName
		vShipperInfo=tmpShipperInfo
		vShipperAcct=tmpShipperAcct
	else
		vShipperName=""
		vShipperAcct=0
	end if
	
	SQL= "select * from mbol_master where elt_account_number = " & elt_account_number _
	    & " and booking_num=N'" & vBookingNum & "'"

    'response.write SQL
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	vConYes="Y"
	vDate=Date
	if Not rs.EOF then
	    '-----------------------------------------------------------------
		
		if(isnull(rs("SalesPerson")))then 
     		 vSalesPerson=""
        else 
     		 vSalesPerson=rs("SalesPerson")
        end if 
		'-----------------------------------------------------------------
		vMBOL=rs("mbol_num")
		vShipperName=rs("shipper_name")
		vShipperInfo=rs("shipper_info")
		vShipperAcct=ConvertAnyValue(rs("shipper_acct_num"),"Long",0)
		vConsigneeName=rs("consignee_name")
		vConsigneeInfo=rs("consignee_info")
		vConsigneeAcct=ConvertAnyValue(rs("consignee_acct_num"),"Long",0)

		vNotifyName=rs("notify_name")
		vNotifyInfo=rs("notify_info")
		if (Not rs("notify_acct_num") = "0") then
		vNotifyAcct=ConvertAnyValue(rs("notify_acct_num"),"Long",0)
		else
		vNotifyAcct = "0"
		end if
		
		vExportRef=rs("export_ref")
		vAgentInfo=rs("agent_info")
		vOriginCountry=rs("origin_country")
		vExportInstr=rs("export_instr")
		vLoadingPier=rs("loading_pier")
		vDimText=rs("dimtext")
		vMoveType=rs("move_type")
		vConYes=rs("containerized")
		vPreCarriage=rs("pre_carriage")
		vPreReceiptPlace=rs("pre_receipt_place")
		vExportCarrier=rs("export_carrier")
		vLoadingPort=rs("loading_port")
		vUnloadingPort=rs("unloading_port")
		vDeliveryPlace=rs("delivery_place")
		vDepartureDate=rs("departure_date")
		vPieces=rs("pieces")
		
		vGrossWeight = CheckBlank(rs("gross_weight").value,0)
		vMeasurement = CheckBlank(rs("measurement").value,0)

		vDesc1=rs("desc1")
		vDesc2=rs("desc2")
		vDesc3=rs("desc3")
		vDesc4=rs("desc4")
		vDesc5=rs("desc5")		
		vWeightCP=rs("weight_cp")
        vUnitQty=rs("unit_qty")	
		
        vAES = CheckBlank(rs("aes_xtn"),"")
        vSEDStmt = CheckBlank(rs("sed_stmt").value,"")
            
        If vAES = "" And vSEDStmt = "" Then
            vSEDStmt = GetSQLResult("SELECT sed_statement FROM user_profile WHERE elt_account_number=" & elt_account_number, Null)
        End If
            
		'vLength=rs("length")
		'vWidth=rs("width")
		'vHeight=rs("height")
		'vChargeableWeight=rs("chargeable_weight")
		vChargeRate=rs("charge_rate")
		vTotalWeightCharge = CheckBlank(rs("total_weight_charge").value,0)

		if vWeightCP="P" then
			vTotalPrepaid = vTotalPrepaid + vTotalWeightCharge
		else
			vTotalCollect = vTotalCollect + vTotalWeightCharge
		end if

        vGrossWeight1 = CheckBlank(rs("gross_weight").value,0)
        vLb1 = vGrossWeight1 * 2.2046
        vMeasurement1=CheckBlank(rs("measurement").value, 0)
        vCF1 = vMeasurement1 * 35.314666721489

		vGWLB=vLb1
		vMCFT=vCF1

'		if trim(vDesc4) = "" or isnull(vDesc4) then
'			vDesc4="  " & vGrossWeight1 & " KG" & "              " & vMeasurement1 & " CBM" & chr(13)
'			vDesc4=vDesc4 & vLb1 & " LB" & "          " & vCF1 & " CFT"
'		end if
		

		vManifestDesc=rs("manifest_desc")
		vDemDetail=rs("dem_detail")
		vDeclaredValue=rs("declared_value")
		
        DIM tvDate,tvBy,tvPlace

		tvDate=rs("tran_date")
		tvBy=rs("tran_by")
		tvPlace=rs("tran_place")
		
		if NOT TRIM(tvDate) = "" THEN vDate = tvDate
		if NOT TRIM(tvBy) = "" THEN vBy = tvBy
		if NOT TRIM(tvPlace) = "" THEN vPlace = tvPlace
		
		vAES = CheckBlank(rs("aes_xtn"),"")
        vSEDStmt = CheckBlank(rs("sed_stmt").value,"")
        
        If vAES = "" And vSEDStmt = "" Then
            vSEDStmt = GetSQLResult("SELECT sed_statement FROM user_profile WHERE elt_account_number=" & elt_account_number, Null)
        End If
        
	else
		vExportInstr=Request("txtExportInstr")
		vExportRef=Request("txtExportRef")
		vLoadingPort=Request("txtLoadingPort")
		vUnloadingPort=Request("txtUnLoadingPort")
		vExportCarrier=Request("txtExportCarrier")
		vPreReceiptPlace=Request("txtPreReceiptPlace")
		vDeliveryPlace=Request("txtDeliveryPlace")
		vOriginCountry=Request("txtOriginCountry")
		vDepartureDate=Request("hDepartureDate")
		vMBOL=Request("hMBOL")
		vMoveType=Request("lstMoveType")
		vDesc5=Request("txtDesc5")
	end if
	rs.Close
    
END SUB
%>
<%
SUB GET_SELECTED_HBOL_INFO
If Not vBookingNum="" then
	SQL= "select coloder_elt_acct,elt_account_number,hbol_num,shipper_name,consignee_name," _
	    & "pieces,gross_weight,measurement from hbol_master where (elt_account_number = " _
	    & elt_account_number & " or coloder_elt_acct = " & elt_account_number _
	    & " ) and booking_num=N'" & vBookingNum & "' and  isnull(is_sub,'N')='N'  order by hbol_num"

	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	seIndex=0
	TotalPieces=0
	TotalGrossWeight=0
	TotalMeasurement=0
	Do While Not rs.EOF
		if isnull(rs("coloder_elt_acct")) then
			sColodeeAcct(seIndex)=0
		else 
		    sColodeeAcct(seIndex)=rs("elt_account_number")
		end if 
		sHBOL(seIndex)=rs("hbol_num")
		sExporter(seIndex)=rs("shipper_name")
		sConsignee(seIndex)=rs("consignee_name")
		sPieces(seIndex)=CheckBlank(rs("pieces").value,0)
		sGrossWeight(seIndex)=CheckBlank(rs("gross_weight").value,0)
		sMeasurement(seIndex)=CheckBlank(rs("measurement").value,0)
		TotalPieces=TotalPieces+sPieces(seIndex)
		TotalGrossWeight=TotalGrossWeight+sGrossWeight(seIndex)
		TotalMeasurement=TotalMeasurement+sMeasurement(seIndex)
		rs.MoveNext
		seIndex=seIndex+1
	Loop
	rs.Close
	
	if Delete="yes" or  Add="yes" or vPieces = "" then
		vPieces = TotalPieces 
		vGrossWeight = TotalGrossWeight
		vTotalMeasurement = TotalMeasurement
		vLb1 = Round(vGrossWeight*2.2046, 2)
		vMeasurement = vTotalMeasurement
		vCF1 = Round(vMeasurement * 35.314666721489, 2)
		vGWLB = vLb1
		vMCFT = vCF1
	end if
	

	if TRIM(vDesc4 ) = "" then
		string1 = ConvertAnyValue(TotalGrossWeight,"Amount",0) & " KG"
		string2 = ConvertAnyValue(TotalMeasurement,"Amount",0) & " CBM"
		string3 = ConvertAnyValue(vGWLB,"Amount",0) & " LB"
		string4 = ConvertAnyValue(vMCFT,"Amount",0) & " CFT"

		string1 = space(15 - len(string1)) & trim(string1)
		string2 = space(15 - len(string2)) & trim(string2)
		string3 = space(15 - len(string3)) & trim(string3)
		string4 = space(15 - len(string4)) & trim(string4)

		vDesc4 = string1 & "  " & string2 & chr(13)
		vDesc4 = vDesc4 & string3 & "  " &  string4
	end if		
end if
END SUB
%>
<%
SUB GET_AVAILABLE_HBOL_INFO
SQL= "select coloder_elt_acct,elt_account_number,hbol_num,shipper_name,consignee_name," _
    & "pieces,gross_weight,measurement from hbol_master where ( elt_account_number = " _
    & elt_account_number & " or coloder_elt_acct = " & elt_account_number _
    & " ) and not (elt_account_number=" & elt_account_number _
    & " and isnull(colo,'')= 'Y') and booking_num ='' and isnull(is_master,'N')='N' " _
    & "AND not (isnull(is_master,'N')='Y' and sub_count <= 0)  order by hbol_num"

	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	avIndex=0

Do While Not rs.EOF And avIndex < 100
	if isnull(rs("coloder_elt_acct")) then
		aColodeeAcct(avIndex)=0
	else 
	   aColodeeAcct(avIndex)=rs("elt_account_number")
	end if 
	aHBOL(avIndex)=rs("hbol_num")
	aExporter(avIndex)=rs("shipper_name")
	aConsignee(avIndex)=rs("consignee_name")
	aPieces(avIndex)=rs("pieces")
	aGrossWeight(avIndex)=rs("gross_weight")
	aMeasurement(avIndex)=rs("measurement")
	rs.MoveNext
	avIndex=avIndex+1
Loop
rs.Close
END SUB
%>
<%
SUB GET_COUNTRY_NAME
'////////////////////////////////////////////////// get country name by ig 2006.6.14
aConIndex = 0
SQL= "select country_code,country_name from country_code where elt_account_number = " & elt_account_number 

	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
Do While Not rs.EOF 
	aCountryCodeArry(aConIndex) = rs("country_code")
	aCountryArry(aConIndex) = rs("country_name")
	aConIndex = aConIndex + 1
	rs.MoveNext
Loop	
rs.Close
'////////////////////////////////////////////////// 
END SUB
%>
<%
SUB GET_ITEM_WEIGHT_CHARGE_INFO_SCREEN

	vWeightCP=Request("lstWeightCP")
	vPieces=Request("txtPieces")
	if vPieces="" then vPieces=0
	vScale=Request("lstScale")
	vGrossWeight=Request("txtGrossWeight")
	if Not vGrossWeight="" then
	    vGWLB = ConvertAnyValue(CDbl(vGrossWeight)*2.2046, "Amount", 2)
	else
		vGrossWeight=0
		vGWLB = 0
	end if
	vMeasurement=Request("txtMeasurement")
	if Not vMeasurement="" then 
		vMCFT = ConvertAnyValue(CDbl(vMeasurement) * 35.314666721489, "Amount", 0)
	else
		vMeasurement=0
		vMCFT=0
	end if

'///////////////////////// vUnitQty
    vUnitQty=Request("lstUnitQty")
'/////////////////////////			

	vChargeRate=CheckBlank(Request("txtChargeRate"),0)
	vTotalWeightCharge = ConvertAnyValue(Request("txtTotalWeightCharge"),"Amount",0)
	if vWeightCP="P" then
		vTotalPrepaid = vTotalPrepaid + vTotalWeightCharge
	else
		vTotalCollect = vTotalCollect + vTotalWeightCharge
	end if

	vDeclaredValue=Request("txtDeclaredValue")
	if vDeclaredValue="" then vDeclaredValue=0
	vBy=Request("txtBy")
	vDate=Request("txtDate")
	if vDate="" then vData=date
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
		next
		NoItem=NoItem-1
	end if
	for i=0 to NoItem-1
		if aChargeCP(i)="P" then
			vTotalPrepaid = vTotalPrepaid + aChargeAmt(i)
		else
			vTotalCollect = vTotalCollect + aChargeAmt(i)
		end if
	next
	tIndex=NoItem
	vUnitQty=Request("lstUnitQty")
	
	vDeclaredValue=Request("txtDeclaredValue")
	if vDeclaredValue="" then vDeclaredValue=0
	vBy=Request("txtBy")
	vDate=Request("txtDate")
	if vDate="" then vData=date
	vPlace=Request("txtPlace")
	
END SUB
%>
<%
SUB FINAL_SCREEN_PREPARE

IF NOT TRIM(vMBOL) = "" THEN
	CALL CHECK_INVOICE_STATUS_MAWB(	vMBOL, elt_account_number )	
END IF

If Trim(vDesc3) <> "" Then
    If InStr(vDesc3,"SAID TO CONTAIN:") <= 0 And InStr(vDesc3,"STC:") <= 0 Then
        vDesc3="SAID TO CONTAIN:" & chr(13) & vDesc3
    End if
Else
	vDesc3="SAID TO CONTAIN:"
End If

Set rs=Nothing
Set rs1=Nothing
Set rs3=Nothing

END SUB
%>
<%
SUB GET_BOOKING_NUMBER
    SQL= "select booking_num from ocean_booking_number where elt_account_number = " _
        & elt_account_number & " and status='B' order by booking_num"
    rs.Open SQL, eltConn, adStatic, adLockReadOnly, adCmdText
    Set rs.activeConnection = Nothing
    ReDim aBookingNum(rs.RecordCount)

    bIndex=1
    aBookingNum(0)=""

    Do While Not rs.EOF
	    aBookingNum(bIndex)=rs("booking_num")
        bIndex=bIndex+1
	    rs.MoveNext
    Loop
	rs.Close
END SUB
%>
<%
SUB GET_CHARGE_ITEM_INFO
'get charge_item info
SQL= "select * from item_charge where elt_account_number = " & elt_account_number & " order by item_name"
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing

chIndex=0
Do While Not rs.EOF
	aItemName(chIndex)=rs("item_name")
	aItemNo(chIndex) = ConvertAnyValue(rs("item_no").value,"Long",0)
	aItemDesc(chIndex)=rs("item_desc")
	aChargeUnitPrice(chIndex)=rs("unit_price") '// Unit_price by ig 10/21/2006
    'aChargeItemName
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

SUB CHECK_INVOICE_STATUS_MAWB( tvMAWB, t_elt_account_number )
DIM invoiceNUM(100),ivIndex
If Not tvMAWB = "" then
		ivIndex = 0				
		SQL="select invoice_no from invoice where elt_account_number=" & t_elt_account_number _
		    & " and air_ocean <> 'A' and mawb_num=N'" & tvMAWB & "'"
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
			SQL="select * from invoice_queue where elt_account_number=" & t_elt_account_number _
			    & " and mawb_num=N'" & tvMAWB & "'" & " and invoiced = 'Y' "
			rs3.CursorLocation = adUseClient
			rs3.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
			Set rs3.activeConnection = Nothing
			if Not rs3.EOF then
				invoiceNUM(ivIndex) = "(Unknown)"
				ivIndex = ivIndex + 1										
			end if
			rs3.Close
		end if
				
		IVstrMsg = ""
		if ivIndex > 0 then
			for iii = 0 to ivIndex - 1
				IVstrMsg = IVstrMsg	& invoiceNUM(iii) & ","
			next
			IVstrMsg = MID(IVstrMsg,1,LEN(IVstrMsg)-1)
		end if
End if		
End Sub		
%>
<%
SUB CHECK_INVOICE_STATUS_HAWB( tvHAWB )
DIM invoiceNUM(100),ivIndex
if tvHAWB = "" Then Exit sub

		ivIndex = 0				
		SQL="select * from invoice where elt_account_number=" & elt_account_number _
		    & " and air_ocean <> 'A' and hawb_num=N'" & tvHAWB & "'"
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
			SQL= "select * from invoice_hawb where elt_account_number = " _
			    & elt_account_number & " and hawb_num=N'" & tvHAWB & "'"
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
				SQL="select * from invoice_queue where elt_account_number=" _
				    & elt_account_number & " and hawb_num=N'" & tvHAWB & "' and invoiced = 'Y' "
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
		
'response.write invoiceNUM(0)
		tmpIVstrMsg = ""
		if ivIndex > 0 then
			for iii = 0 to ivIndex - 1
				tmpIVstrMsg = tmpIVstrMsg	& invoiceNUM(iii) & ","
			next
			tmpIVstrMsg = MID(tmpIVstrMsg,1,LEN(tmpIVstrMsg)-1)
%>
<script type="text/jscript">
    //////////////////////////////////////////
    alert('The HBOL#:' + '<%=tvHAWB%>' + ' was already Invoiced as IV #:' + '<%= tmpIVstrMsg %>' + '.\nPlease check Invoice Information & HBOL information later.');
    //////////////////////////////////////////
</script>
<%
		end if
End Sub		
%>
<%
Function CHECK_EX_DATE ( vMBOL, ArrivalDept ) 
Dim tmpSQL

If Trim(vMAWB) = "" Then
	CHECK_EX_DATE = ArrivalDept
	Exit function
End If

If ( Not IsDate(ArrivalDept)) Or ( Trim(ArrivalDept) = "" ) Or ( ArrivalDept = "1/1/1900" )  Then
	tmpSQL="select departure_date as export_date from ocean_booking_number where elt_account_number=" _
	    & elt_account_number & " AND mbol_no=N'" & vMBOL & "'"
	rs3.CursorLocation = adUseClient
	rs3.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs3.activeConnection = Nothing
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

Sub GET_DEFAULT_FREIGHT_COST_FROM_DB
	vDefaultFreightCostNo=0    
    Dim rs
    Set rs=Server.CreateObject("ADODB.Recordset")  
	SQL= "select isnull(default_ocean_cost_item,-1) as default_ocean_cost_item from user_profile where elt_account_number = " & elt_account_number
	rs.Open SQL, eltConn, , , adCmdText	
	
	if not rs.eof  then 
	 if  cdbl(rs("default_ocean_cost_item"))<>-1 then 
		vDefaultFreightCostNo=rs("default_ocean_cost_item")
	 else 
	 vDefaultFreightCostNo=setDefaultOF
	   'response.Write("<script language='javascript'> setDefaultFreight() </script>")
	 end if 
	else 
	 vDefaultFreightCostNo=setDefaultOF
	    'response.Write("<script language='vbscript'> setDefaultFreight()</script>")
	end if 
	rs.Close	
	if cdbl(vDefaultFreightCostNo) <> 0 then 	
		SQL= "select account_expense, item_desc from item_cost where elt_account_number = " & elt_account_number& " and item_no ="&vDefaultFreightCostNo		
		rs.Open SQL, eltConn, , , adCmdText		
		if not rs.eof then 
			vDefaultAccountExpense=ConvertAnyValue(rs("account_expense"),"Integer",0)
			vDefaultFreightCostDesc=rs("item_desc")
		end if 
		rs.Close   
	end if 
    Set rs=Nothing 
End Sub 

function setDefaultOF
    Dim rs
    dim acct
    DIM nextAcctNo    
    Set rs1=Server.CreateObject("ADODB.Recordset") 
     
    SQL = "select  max(gl_account_number) as gl_account_number from  gl  where elt_account_number = " _
        & elt_account_number & "  and gl_account_type= 'Cost of Sales' and gl_master_type='EXPENSE'"
    rs1.Open SQL, eltConn, , , adCmdText	
    if not  rs1.eof  then 
        nextAcctNo=ConvertAnyValue(rs1("gl_account_number"),"Integer",0)
        nextAcctNo=nextAcctNo+1
    end if 
    rs1.close    
    Set rs1=nothing  
   
'    Set rs=Server.CreateObject("ADODB.Recordset")  
'    SQL = "select  top 1 * from  gl  where elt_account_number = " & elt_account_number _
'        & "  and gl_account_type= 'Cost of Sales' and gl_master_type='EXPENSE' and gl_account_desc='Default Ocean Freight'"
'    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
'    if not rs.eof  then 
'    else
'        rs.AddNew
'        rs("elt_account_number")=elt_account_number
'        rs("gl_account_number")=nextAcctNo
'        rs("gl_account_desc")="Default Ocean Freight"		
'        rs("gl_master_type")="EXPENSE"	
'        rs("gl_account_type")="Cost Of Sales"
'        rs("gl_account_status")="A"	
'        rs("gl_account_cdate")=Now	
'        rs("gl_last_modified")=Now	
'       rs.update
'   end if
'   rs.close
'   Set rs=nothing
    
    dim next_item_no
    next_item_no=1
    
    Set rs3=Server.CreateObject("ADODB.Recordset")  
    SQL = "select  max(item_no) as item_no from  item_cost  where elt_account_number = " & elt_account_number 
    rs3.Open SQL, eltConn, , , adCmdText	
    if not  rs3.eof  then 
        next_item_no=ConvertAnyValue(rs3("item_no"),"Integer",0)
        next_item_no=next_item_no+1
    end if 
    rs3.close
    
'    Set rs4=Server.CreateObject("ADODB.Recordset")  
'    SQL = "select  * from  item_cost  where elt_account_number = " & elt_account_number _
'        & "  and item_name= 'OF' and item_type='Ocean Freight' and item_desc='OCEAN FREIGHT'"
'    rs4.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
'    if rs4.eof=true  then       
'    rs4.AddNew
'	    rs4("elt_account_number")=elt_account_number
'	    rs4("item_no")=next_item_no
'	    rs4("item_name")="OF"
'	    rs4("item_type")="OCEAN Freight"	
'	    rs4("item_desc")="OCEAN FREIGHT"
'	    rs4("account_expense")=nextAcctNo	   	   
'	    rs4.update
'	 else
'	    next_item_no= rs4("item_no")
'    end if    
'    rs4.close
    
    Set rs2=Server.CreateObject("ADODB.Recordset")  
    SQL = "select * from user_profile where elt_account_number = " & elt_account_number
    rs2.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
    If Not rs2.EOF And Not rs2.BOF Then
        rs2("default_ocean_cost_item")=next_item_no
        rs2.Update
    End If
    rs2.close
    Set rs2=nothing   
    
    setDefaultOF=next_item_no
    
end function 

Sub GET_MB_COST_ITEM_FROM_DB 
    Dim rs
    Set rs=Server.CreateObject("ADODB.Recordset")
    if  Not vBookingNum="" then
        SQL= "select item_no,item_desc,cost_amount,lock_ap, rate from mb_cost_item where elt_account_number = " _
            & elt_account_number & " and mb_no=N'" & vBookingNum& "'" & "order by item_id"
        rs.Open SQL, eltConn, , , adCmdText
		if not rs.eof then 
	        vDefaultFreightCostNo =rs("item_no")
	        vDefaultFreightCostDesc =rs("item_desc")	       
	        vTotalRealCost =cDbl(rs("cost_amount"))
			vLock_ap =rs("lock_ap")	
			vRateRealCost=rs("rate")	
		end if 
        rs.Close
    end if 
    Set rs=Nothing 
End Sub 

function save_cost_item_and_bill_detail_trans(iType,import_export)
   '---getting agnet org account
	vAgentOrgAcct=0
	if vTotalHAWB=0 then	
		if vWeightCP="P" or vPrepaidOtherCharge="Y" then
			vAgentOrgAcct=vShipperAcct
		end if 	
		if vWeightCP="C" or vCollectOtherCharge="Y" then	
			vAgentOrgAcct=vConsigneeAcct
		end if 
	end if 
	
	vProcessDT=NOW
	if request("txtTotalRealCost")<>""then 
    	vTotalRealCost=cDbl(request("txtTotalRealCost"))
	else
		vTotalRealCost=0
	end if 
	
	if request("txtRateRealCost")<>"" AND request("txtRateRealCost")<>"N/A" then 
    	vRateRealCost=cDbl(request("txtRateRealCost"))
	else
		vRateRealCost=0
	end if 
		
	dim TotalErrors
	TotalErrors=0

	SQL= "delete from mb_cost_item where elt_account_number = " & elt_account_number & " and mb_no=N'" & vBookingNum &"'"
	eltConn.Execute SQL
	TotalErrors=TotalErrors+eltConn.Errors.Count
	
	if vTotalRealCost <> 0 then
		SQL= "insert into mb_cost_item (elt_account_number,mb_no,item_id,item_no,item_desc,ref_no,cost_amount,rate,lock_ap,Vendor_no)"
		SQL=SQL&"values("
		SQL=SQL&"'"&elt_account_number&"',"
		SQL=SQL&"N'"&vBookingNum&"',"
		SQL=SQL&"1,"
		SQL=SQL&"N'"&vDefaultFreightCostNo&"',"
		SQL=SQL&"N'"&vDefaultFreightCostDesc&"',"
		SQL=SQL&"'',"
		SQL=SQL&"'"&vTotalRealCost&"'," 
		SQL=SQL&"'"&vRateRealCost&"',"
		if vLock_ap <> "Y" then
			vLock_ap= "N"
		end if
		SQL=SQL&"'"&vLock_ap&"',"
		SQL=SQL&vAgentOrgAcct&")"		
	
		eltConn.Execute SQL, nRecords				
		TotalErrors=eltConn.Errors.Count
	end if	
	
	if vLock_ap <> "Y" then
		SQL= "delete from bill_detail where elt_account_number = " & elt_account_number & " and mb_no='" & vBookingNum &"'"
		eltConn.Execute SQL	
		TotalErrors=TotalErrors+eltConn.Errors.Count
		if  vTotalRealCost<>0 then
			SQL= "insert into bill_detail (elt_account_number,mb_no,item_id,bill_number,item_name,item_no,item_expense_acct,item_amt,tran_date,vendor_number,iType,import_export)"
			SQL=SQL&"values("
			SQL=SQL&"'"&elt_account_number&"',"
			SQL=SQL&"N'"&vBookingNum&"',"
			SQL=SQL&"'1',"
			SQL=SQL&"'0',"
			SQL=SQL&"N'"&vDefaultFreightCostDesc &"',"
			SQL=SQL&"N'"&vDefaultFreightCostNo &"',"				
			SQL=SQL&"N'"&vDefaultAccountExpense &"',"
			SQL=SQL&"N'"&vTotalRealCost &"'," ' Expense Account will be set at the AP posting 			
			SQL=SQL&"N'"&vProcessDT&"',"
			SQL=SQL&"N'"&vAgentOrgAcct&"',"
			SQL=SQL&"N'"&iType&"',"
			SQL=SQL&"N'"&import_export&"')"
			eltConn.Execute SQL
			TotalErrors=TotalErrors+eltConn.Errors.Count						
		end if		
	end if 
	
	IF TotalErrors=0 then 
		save_cost_item_and_bill_detail_trans=true
		
	else 
		save_cost_item_and_bill_detail_trans=false
	end if 

End function 

%>
<%
SUB MBOL_INVOICE_QUEUE( vBookingNum )		
DIM tHAWB

		'/////////////////////////////////
		vTotalHAWB=Request("hTotalHAWB")
		if vTotalHAWB="" then vTotalHAWB=0
		'/////////////////////////////////

		if vTotalHAWB=0 then

			if vWeightCP="P" or vPrepaidOtherCharge="Y" then
				SQL="select * from invoice_queue where elt_account_number=" _
				    & elt_account_number & " and agent_shipper='S' and mawb_num=N'" _
				    & vBookingNum & "' and bill_to_org_acct=" & vShipperAcct				
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
					rs("agent_name")=vConsigneeName
					rs("agent_org_acct")=vConsigneeAcct					
					rs("air_ocean")="O"
					rs("master_only")="Y"
					rs("invoiced")="N"				
					rs.Update
				end if
				rs.close
			end if
			
	'insert into invoice_queue table for agent
			if vWeightCP="C" or vCollectOtherCharge="Y" then
				SQL="select * from invoice_queue where elt_account_number=" _
				    & elt_account_number & " and agent_shipper='A' and mawb_num=N'" _
				    & vBookingNum & "' and bill_to_org_acct=" & vConsigneeAcct

				rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
				if rs.EOF then
					vQueueID = GET_QUEUE_ID() 
					rs.AddNew
					rs("elt_account_number")=elt_account_number
					rs("queue_id")=vQueueID
					rs("inqueue_date")=now
					rs("agent_shipper")="A"
					rs("mawb_num")=vBookingNum
					rs("bill_to")=vConsigneeName
					rs("bill_to_org_acct")=vConsigneeAcct
					rs("agent_name")=vConsigneeName
					rs("agent_org_acct")=vConsigneeAcct					
					rs("air_ocean")="O"
					rs("master_only")="Y"
					rs("invoiced")="N"
					rs.Update
				end if
				rs.close
			end if
		else

			for k=0 to vTotalHAWB-1
				if not Request("txtsHBOL" & k)="" then
					tHAWB=Request("txtsHBOL" & k)
					
					if CHECK_SHOULD_INVOICE_QUEUED(tHAWB )= true then 
						CALL HAWB_INVOICE_QUEUE	( tHAWB, vTotalHAWB )
					else 
						'response.Write("------------"&tHAWB)
					end if 		
					'CALL HAWB_INVOICE_QUEUE	( tHAWB, vTotalHAWB )					
				end if
		 	next
            
			SQL="select master_agent from invoice_queue where elt_account_number=" _
			    & elt_account_number & " and agent_shipper='A' and mawb_num=N'" _
			    & vBookingNum & "' and bill_to_org_acct=" & vConsigneeAcct
			rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
			if Not rs.EOF then
				rs("master_agent")="Y"
				rs.Update
			end if
			rs.close
			
		end if

END SUB
%>
<%
Sub HAWB_INVOICE_QUEUE( tmpHAWB, iiiCnt )
dim rs
Set rs = Server.CreateObject("ADODB.Recordset")
DIM tvQueueID,tvShipperAcct,tvShipperName,tvFFAgentAcct,tvFFAgentName,vWeightCP,vPrepaidOtherCharge,vCollectOtherCharge,tvMAWB

		SQL= "select Booking_num,Shipper_Acct_Num,agent_name,agent_no,shipper_name,weight_cp,prepaid_other_charge,collect_other_charge from hbol_master where isnull(is_invoice_queued,'Y') <> 'N' and elt_account_number = " _
		    & elt_account_number & " and HBOL_NUM=N'" & tmpHAWB & "'"
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
	
				SQL="select * from invoice_queue where elt_account_number=" & elt_account_number _
				    & " and agent_shipper='S' and hawb_num=N'" & tmpHAWB & "' and bill_to_org_acct=" & tvShipperAcct
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
				SQL="select * from invoice_queue where elt_account_number=" & elt_account_number _
				    & " and agent_shipper='A' and mawb_num=N'" & vBookingNum & "' and bill_to_org_acct=" & tvAgentAcct

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
set rs=nothing 			
		
End Sub
%>
<%
FUNCTION GET_QUEUE_ID

	SQL="select max(queue_id) as queue_id from invoice_queue where elt_account_number=" & elt_account_number
	rs1.Open SQL, eltConn, , , adCmdText
	If Not rs1.EOF And IsNull(rs1("queue_id"))=False Then
		vQueueID=ConvertAnyValue(rs1("queue_id"),"Long",0)+1
	Else
		vQueueID=1
	End If
	rs1.close
	GET_QUEUE_ID = vQueueID
END FUNCTION
%>
<%
Sub INVOICE_QUEUE_REFRESH( vBookingNum  )

DIM arr_queue_id(100),qu_index

		qu_index = 0				
		SQL="select queue_id from invoice_queue where elt_account_number=" _
		    & elt_account_number & " and mawb_num=N'" & vBookingNum & "' and invoiced = 'N' "

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
			SQL= "delete invoice_queue where elt_account_number=" & elt_account_number _
			    & " and mawb_num=N'" & vBookingNum & "' and invoiced = 'N' and queue_id=" & arr_queue_id(iii)
			eltConn.Execute SQL
		next

End Sub

%>
<!--  #include file="../include/recent_file.asp" -->
<body link="336699" vlink="336699" topmargin="0" onload=" initCollapsingRows();<% If setExpanded Then Response.write("toggleVisibility('nothing')") ELSE Response.write("expanded('toggleButton')")%>;">
    <!-- tooltip placeholder -->
    <div id="tooltipcontent">
    </div>
    <!-- placeholder ends -->
    <form method="post" name="form1">
    <input type="image" style="position: absolute; visibility: hidden" onclick="return false;" />
    <input type="hidden" id="hSONum" name="hSONum" value="<%=vSONum %>" />
    <input type="hidden" id="hPONum" name="hPONum" value="<%=vPONum %>" />
    <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
        <tr>
            <td width="58%" height="32" align="left" valign="middle" class="pageheader">
                NEW/Edit MASTER BILL OF LADING (MASTER B/L)
            </td>
            <td width="42%" align="right" valign="middle">
                <span class="bodyheader style4">FILE NO.</span>
                <input name="txtJobNum" type="text" class="lookup" size="22" value="Search Here"
                    onkeydown="javascript: if(event.keyCode == 13) { LookupFile(); }" onfocus="javascript: this.value = ''; this.style.color='#000000'; ">
                <img src="../images/icon_search.gif" name="B1" width="33" height="27" align="absmiddle"
                    style="cursor: hand" onclick="LookupFile()">
            </td>
        </tr>
    </table>
    <div class="selectarea">
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <span class="select">Select Booking No.
                        <% if mode_begin then %>
                    </span>
                    <div style="width: 21px; display: inline; vertical-align: middle;" onmouseover="showtip('Type in the Booking No. of a Booking you wish to save as a Master B/L, or a Booking number of a previously saved Master that you wish to edit.');"
                        onmouseout="hidetip()">
                        <span class="bodyheader">
                            <img src="../Images/button_info.gif" align="top" class="bodylistheader"></span></div>
                    <% end if %>
                </td>
                <td width="55%" rowspan="2" align="right" valign="bottom">
                    <% If vBookingNum <> "" Then %>
                    <div id="print">
                        <a href="javascript:;" onclick="SetCostItems(); return false;" tabindex="-1">Cost Items</a>
                        <img src="/ASP/Images/button_devider.gif" alt="" />
                        <a href="javascript:;" onclick="SetCreditNote(); return false;" tabindex="-1">Credit
                            Note</a>
                        <img src="/ASP/Images/button_devider.gif" alt="" />
                        <a href="javascript:EditClick('','<%=vBookingNum %>');" tabindex="-1">
                            <img src="/ASP/Images/icon_createhouse.gif" alt="Click here to create SED" width="25"
                                height="26" style="margin-right: 10px" />Create AES</a>
                        <img src="/ASP/Images/button_devider.gif" alt="" />
                        <a href="javascript:void(0);" id="NewPrintVeiw1" >
                            <img src="/ASP/Images/icon_printer.gif" width="40" height="27" align="absbottom"
                                alt="" />Master B/L Instruction</a></div>
                    <% End If %>
                </td>
            </tr>
            <tr>
                <td width="45%" valign="bottom">
                    <!-- //Start of Combobox// -->
                    <%  iMoonDefaultValue = vBookingNum %>
                    <%  iMoonComboBoxName =  "lstBookingNum" %>
                    <%  iMoonComboBoxWidth =  "170px" %>
                    <script type="text/jscript"> function <%=iMoonComboBoxName%>_OnChangePlus() { BookingChange(); } 
                     function <%=iMoonComboBoxName%>_OnAddNewPlus() { } 
                    </script>
                    <div id="<%=iMoonComboBoxName%>_Container" class="ComboBox" style="width: <%=iMoonComboBoxWidth%>;
                        position: ; top: ; left: ; z-index: ;">
                        <input name="<%=iMoonComboBoxName%>:Text" type="text" id="<%=iMoonComboBoxName%>_Text"
                            class="ComboBox" autocomplete="off" style="width: <%=iMoonComboBoxWidth%>; vertical-align: middle"
                            value="<%=iMoonDefaultValue%>" />
                        <div id="<%=iMoonComboBoxName%>_Div" style="display: none; position: absolute; top: 0;
                            left: -140px; width: 17px">
                            <img id="<%=iMoonComboBoxName%>_Button" src="/ig_common/Images/combobox_drop.gif"
                                border="0" />
                        </div>
                    </div>
                    <div id="<%=iMoonComboBoxName%>_NewDiv" style="display: none; position: absolute;
                        top: 0; left: 0; width: 17px">
                        <img id="<%=iMoonComboBoxName%>_AddNewButton" src="/ig_common/Images/combobox_addnew.gif"
                            border="0" />
                    </div>
                    <!-- /End of Combobox/ -->
                    <select name="lstBookingNum" id="lstBookingNum" listsize="20" class="ComboBox" style="width: 170px;
                        display: none" onchange="ComboBox_SimpleAttach(this, this.form['<%=iMoonComboBoxName%>_Text'])">
                        <% for i=0 to bIndex-1 %>
                        <option value="<%= aBookingNum(i) %>" <% if vBookingNum=aBookingNum(i) then response.write("selected") %>>
                            <%= aBookingNum(i) %>
                        </option>
                        <% next %>
                    </select>
                    <code><kbd><sup>
                        <input type="hidden" name="txtHBOL" readonly size="13" value="<%= vHBOL %>">
                    </sup></kbd></code>
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
                <input type="hidden" name="hBookingNum" value="<%= vBookingNum %>">
                <input type="hidden" name="hAgentName" value="<%= vAgentName %>">
                <input type="hidden" name="hDepartureDate" value="<%= vDepartureDate %>">
                <input type="hidden" name="hTotalHAWB" value="<%= seIndex %>">
                <input type="hidden" name="hNoItem" value="<%= tIndex %>">
                <table width="100%" border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                    <tr>
                        <td colspan="2" height="24" align="left" valign="middle" bgcolor="BFD0C9" class="bodyheader">
                            <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td width="26%">
                                        &nbsp;
                                    </td>
                                    <td width="49%" align="center" valign="middle">
                                        <img src="../images/button_save_medium.gif" width="46" height="18" name="bSave" onclick="SaveClick()"
                                            style="cursor: hand">
                                    </td>
                                    <td width="13%" align="right" valign="middle">
                                        <a target="_parent" href="/OceanExport/MAWB">
                                            <img src="/ASP/Images/button_new.gif" width="42" height="17" border="0" style="cursor: hand"></a>
                                    </td>
                                    <td width="12%" align="right" valign="middle">
                                        <img src="../images/button_delete_medium.gif" width="51" height="17" name="bDeleteMBOL"
                                            onclick="DeleteMBOL()" style="cursor: hand">
                                    </td>
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
                                    <td height="20" colspan="2" bgcolor="#f3f3f3">
                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="bodycopy" style="padding-left: 10px">
                                            <tr bgcolor="#E0EDE8">
                                                <td width="285" height="20">
                                                    <span class="style1">Master B/L No.</span>
                                                </td>
                                                <td width="265">
                                                    &nbsp;
                                                </td>
                                                <td width="229">
                                                    &nbsp;
                                                </td>
                                                <td width="225">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr bgcolor="#FFFFFF">
                                                <td height="24" valign="middle" bgcolor="#FFFFFF">
                                                    <input name="txtMBOL" id="txtMBOL" class="readonlybold" readonly="readonly" value='<%= vMBOL %>' size="28"  />
                                                    <input name="hMBOL" id="hMBOL"  type="hidden" value='<%= vMBOL %>' size="28"  />
                                                </td>
                                                <td valign="middle" bgcolor="#FFFFFF">
                                                </td>
                                                <td valign="middle" bgcolor="#FFFFFF">
                                                    &nbsp;
                                                </td>
                                                <td align="right" valign="middle" bgcolor="#FFFFFF">
                                                    <span class="bodyheader">
                                                        <img src="/ASP/Images/required.gif" align="absbottom">Required field&nbsp;&nbsp;&nbsp;</span>
                                                </td>
                                            </tr>
                                            <tr bgcolor="#FFFFFF">
                                                <td height="2" colspan="4" bgcolor="#6D8C80">
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td width="50%">
                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="bodycopy" style="padding-left: 10px">
                                                        <tr>
                                                            <td width="45%" height="20" bgcolor="#E0EDE8">
                                                                <strong>Exporter</strong>
                                                            </td>
                                                        </tr>
                                                        <tr align="left" valign="middle">
                                                            <td valign="top">
                                                                <!-- Start JPED -->
                                                                <input type="hidden" id="hShipperAcct" name="hShipperAcct" value="<%=vShipperAcct %>" />
                                                                <div id="lstShipperNameDiv">
                                                                </div>
                                                                <table cellpadding="0" cellspacing="0" border="0">
                                                                    <tr>
                                                                        <td>
                                                                            <input type="text" autocomplete="off" id="lstShipperName" name="lstShipperName" value="<%=vShipperName %>"
                                                                                class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                                border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Shipper','lstShipperNameChange',null,event)"
                                                                                onfocus="initializeJPEDField(this,event);" />
                                                                        </td>
                                                                        <td>
                                                                            <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstShipperName','Shipper','lstShipperNameChange',null,event)"
                                                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                                border-left: 0px solid #7F9DB9; cursor: hand;" />
                                                                        </td>
                                                                        <td>
                                                                             <input type='hidden' id='quickAdd_output'/>
                                                                            <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                                onclick="quickAddClient('hShipperAcct','lstShipperName','txtShipperInfo')" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                                <textarea id="txtShipperInfo" name="txtShipperInfo" class="monotextarea" cols=""
                                                                    rows="5" style="width: 300px"><%=vShipperInfo %></textarea>
                                                                <!-- End JPED -->
                                                            </td>
                                                        </tr>
                                                        <tr align="left" valign="middle" bgcolor="E0EDE8">
                                                            <td height="20" bgcolor="#f3f3f3">
                                                                <strong><span class="bodyheader">
                                                                    <img src="/ASP/Images/required.gif" align="absbottom"></span>Consigned to</strong>
                                                            </td>
                                                        </tr>
                                                        <tr align="left" valign="middle">
                                                            <td valign="top">
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
                                                                                onkeyup="organizationFill(this,'Consignee','lstConsigneeNameChange',null,event)" onfocus="initializeJPEDField(this,event);" />
                                                                        </td>
                                                                        <td>
                                                                            <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstConsigneeName','Consignee','lstConsigneeNameChange',null,event)"
                                                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                                border-left: 0px solid #7F9DB9; cursor: hand;" />
                                                                        </td>
                                                                        <td>
                                                                            <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                                onclick="quickAddClient('hConsigneeAcct','lstConsigneeName','txtConsigneeInfo')" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                                <textarea id="txtConsigneeInfo" name="txtConsigneeInfo" class="monotextarea" cols=""
                                                                    rows="5" style="width: 300px"><%=vConsigneeInfo %></textarea>
                                                                <!-- End JPED -->
                                                            </td>
                                                        </tr>
                                                        <tr align="left" valign="middle" bgcolor="E0EDE8">
                                                            <td height="20" bgcolor="#f3f3f3">
                                                                <strong>Notify Party/Intermediate Consignee</strong>
                                                            </td>
                                                        </tr>
                                                        <tr align="left" valign="middle">
                                                            <td valign="top">
                                                                <table width="100%" border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                                                    <tr>
                                                                        <td height="17">
                                                                            <input type="hidden" name="hNotify" value="<%= vNotifyName %>">
                                                                            <!-- Start JPED -->
                                                                            <input type="hidden" id="hNotifyAcct" name="hNotifyAcct" value="<%=vNotifyAcct %>" />
                                                                            <div id="lstNotifyNameDiv">
                                                                            </div>
                                                                            <table cellpadding="0" cellspacing="0" border="0">
                                                                                <tr>
                                                                                    <td>
                                                                                        <input type="text" autocomplete="off" id="lstNotifyName" name="lstNotifyName" value="<%= GetBusinessName(CheckBlank(vNotifyAcct,0)) %>"
                                                                                            class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                                            border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Notify','lstNotifyNameChange',null,event)"
                                                                                            onfocus="initializeJPEDField(this,event);" />
                                                                                    </td>
                                                                                    <td>
                                                                                        <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstNotifyName','Notify','lstNotifyNameChange',null,event)"
                                                                                            style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                                            border-left: 0px solid #7F9DB9; cursor: hand;" />
                                                                                    </td>
                                                                                    <td>
                                                                                        <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                                            onclick="quickAddClient('hNotifyAcct','lstNotifyName','txtBillToInfo')" />
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                            <textarea id="txtNotifyInfo" name="txtNotifyInfo" class="monotextarea" cols="" rows="5"
                                                                                style="width: 300px"><%=vNotifyInfo %></textarea>
                                                                            <!-- End JPED -->
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td width="50%" valign="top">
                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                                        <tr>
                                                            <td height="20" colspan="3" bgcolor="E0EDE8">
                                                                <strong>Export Reference</strong>
                                                            </td>
                                                        </tr>
                                                        <tr align="left" valign="middle">
                                                            <td colspan="3" valign="top" style="padding-bottom: 54px">
                                                                <textarea name="txtExportRef" cols="60" rows="3" class="multilinetextfield"><%= vExportRef %></textarea>
                                                            </td>
                                                        </tr>
                                                        <tr align="left" valign="middle" bgcolor="E0EDE8">
                                                            <td height="20" colspan="3" bgcolor="#f3f3f3">
                                                                <strong>Forwarding Agent</strong>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <textarea wrap="hard" name="txtAgentInfo" cols="60" rows="3" class="multilinetextfield"><%= vAgentInfo %></textarea>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td height="20" bgcolor="#f3f3f3">
                                                                <strong>Point (State) of Origin or FTZ Number</strong>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="padding-bottom: 16px">
                                                                <input name="txtOriginCountry" maxlength="32" class="shorttextfield" value="<%= vOriginCountry %>">
                                                            </td>
                                                        </tr>
                                                        <tr align="left" valign="middle" bgcolor="E0EDE8">
                                                            <td height="20" colspan="3" bgcolor="#f3f3f3">
                                                                <strong>Domestic Routing/Export Instructions</strong>
                                                            </td>
                                                        </tr>
                                                        <tr align="left" valign="middle">
                                                            <td colspan="3" valign="top">
                                                                <textarea wrap="hard" name="txtExportInstr" cols="60" rows="5" class="multilinetextfield"><%= vExportInstr %></textarea>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td width="50%">
                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="bodycopy" style="padding-left: 10px">
                                                        <tr align="left" valign="middle">
                                                            <td width="48%" height="20" bgcolor="#f3f3f3">
                                                                <strong>Pre-Carriage By </strong>
                                                            </td>
                                                            <td width="52%" bgcolor="#f3f3f3">
                                                                <strong>Place of Receipt By Pre-Carrier</strong>
                                                            </td>
                                                        </tr>
                                                        <tr align="left" valign="middle">
                                                            <td bgcolor="#FFFFFF">
                                                                <input name="txtPreCarriage" maxlength="32" class="shorttextfield" value="<%= vPreCarriage %>"
                                                                    size="32">
                                                            </td>
                                                            <td bgcolor="#FFFFFF">
                                                                <input name="txtPreReceiptPlace" maxlength="32" class="shorttextfield" value="<%= vPreReceiptPlace %>"
                                                                    size="32">
                                                            </td>
                                                        </tr>
                                                        <tr align="left" valign="middle">
                                                            <td height="20" bgcolor="#f3f3f3">
                                                                <strong>Exporting Carrier</strong>
                                                            </td>
                                                            <td bgcolor="#f3f3f3">
                                                                <strong>Port of Loading/Export</strong>
                                                            </td>
                                                        </tr>
                                                        <tr align="left" valign="middle">
                                                            <td>
                                                                <input name="txtExportCarrier" type="text" class="shorttextfield" maxlength="32"
                                                                    value="<%= vExportCarrier %>" size="32">
                                                            </td>
                                                            <td>
                                                                <input name="txtLoadingPort" type="text" class="shorttextfield" maxlength="64" value="<%= vLoadingPort %>"
                                                                    size="32">
                                                            </td>
                                                        </tr>
                                                        <tr align="left" valign="middle" bgcolor="E0EDE8">
                                                            <td height="20" valign="middle" bgcolor="#f3f3f3">
                                                                <strong>Foreign Port of Unloading</strong>
                                                                <br>
                                                            </td>
                                                            <td valign="middle" bgcolor="#f3f3f3">
                                                                <strong>Place of Delivery By On-Carrier</strong>
                                                            </td>
                                                        </tr>
                                                        <tr align="left" valign="middle">
                                                            <td>
                                                                <input name="txtUnloadingPort" type="text" maxlength="64" class="shorttextfield"
                                                                    value="<%= vUnloadingPort %>">
                                                            </td>
                                                            <td>
                                                                <input name="txtDeliveryPlace" class="shorttextfield" maxlength="32" value="<%= vDeliveryPlace %>">
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td width="50%" valign="top">
                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                                        <tr align="left" valign="middle">
                                                            <td height="40" colspan="3" bgcolor="#FFFFFF">
                                                                &nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr align="left" valign="middle">
                                                            <td height="20" colspan="3" bgcolor="#f3f3f3">
                                                                <strong>Loading Pier/Terminal</strong>
                                                            </td>
                                                        </tr>
                                                        <tr align="left" valign="middle">
                                                            <td width="15%">
                                                                <input name="txtLoadingPier" class="shorttextfield" maxlength="32" value="<%= vLoadingPier %>">
                                                            </td>
                                                            <td width="18%">
                                                                &nbsp;
                                                            </td>
                                                            <td width="22%">
                                                                &nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr align="left" valign="middle" bgcolor="E0EDE8">
                                                            <td height="20" valign="middle" bgcolor="#f3f3f3">
                                                                <strong>Type of Move</strong>
                                                            </td>
                                                            <td colspan="2" valign="middle" bgcolor="#f3f3f3">
                                                                <strong>Containerized</strong>
                                                            </td>
                                                        </tr>
                                                        <tr align="left" valign="middle">
                                                            <td>
                                                                <input name="lstMoveType" type="text" class="shorttextfield" maxlength="32" value="<%= vMoveType %>">
                                                            </td>
                                                            <td>
                                                                <input type="checkbox" name="cConYes" value="Y" onclick="ConYes()" <% if vConYes="Y" then response.write("checked") %>>
                                                                &nbsp; Yes &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                                <input type="checkbox" name="cConNo" value="Y" onclick="ConNo()" <% if not vConYes="Y" then response.write("checked") %>>
                                                                &nbsp; No
                                                            </td>
                                                            <td>
                                                                &nbsp;
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="collapsible"
                                            style="padding-left: 10px">
                                            <thead>
                                                <tr>
                                                    <th colspan="10" height="2" bgcolor="#6D8C80">
                                                    </th>
                                                </tr>
                                                <tr align="center" valign="middle" bgcolor="BFD0C9">
                                                    <th height="22" colspan="10">
                                                        <span class="style8">AVAILABLE HOUSE B/L NO. </span>&nbsp;
                                                        <img src="../Images/Expand.gif" name="toggleButton" width="10" height="7" border="0"
                                                            id="toggleButton" style="cursor: hand" onclick="toggleVisibility('toggleButton')">
                                                        <% if mode_begin then %>
                                                        <div style="width: 21px; display: inline; vertical-align: middle;" onmouseover="showtip('Clicking on the arrow will open up the area containing all the House Bills of Lading in the system that are not consolidated to a Master Bill of Lading. If you wish to add a House B/L to this Master B/L, find it and click Add on its line.  The voyage info will be pushed automatically to the House from the Master.');"
                                                            onmouseout="hidetip()">
                                                            <span class="bodyheader">
                                                                <img src="../Images/button_info.gif" align="top" class="bodylistheader"></span></div>
                                                        <% end if %>
                                                    </th>
                                                </tr>
                                                <tr>
                                                    <th colspan="10" height="1" bgcolor="#FFFFFF">
                                                    </th>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#f3f3f3">
                                                    <th height="20" bgcolor="#f3f3f3">
                                                        <strong>House B/L No. </strong>
                                                    </th>
                                                    <th bgcolor="#f3f3f3">
                                                        <strong>Exporter</strong>
                                                    </th>
                                                    <th>
                                                        <strong>Consignee</strong>
                                                    </th>
                                                    <th>
                                                        <strong>Pieces</strong>
                                                    </th>
                                                    <th>
                                                        <strong>Gross Weight (KG)</strong>
                                                    </th>
                                                    <th>
                                                        <strong>Measure (CBM)</strong>
                                                    </th>
                                                    <th>
                                                        &nbsp;
                                                    </th>
                                                    <th>
                                                        &nbsp;
                                                    </th>
                                                    <th>
                                                        &nbsp;
                                                    </th>
                                                    <th>
                                                        &nbsp;
                                                    </th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <input type="hidden" id="aHBOL">
                                                <% for i=0 to avIndex-1 %>
                                                <tr align="left" valign="middle" bgcolor="#FFFFFF">
                                                    <td height="20">
                                                        <input name="txtaHBOL<%= i %>" type="text" class="bodyheader aHBOL" id="aHBOL" value="<%= aHBOL(i) %>"
                                                            size="11">
                                                    </td>
                                                    <td>
                                                        <input name="txtaExporter<%= i %>" type="text" class="shorttextfield" value="<%= aExporter(i) %>"
                                                            size="45">
                                                    </td>
                                                    <td>
                                                        <input name="txtaConsignee<%= i %>" type="text" class="shorttextfield" value="<%= aConsignee(i) %>"
                                                            size="45">
                                                    </td>
                                                    <td>
                                                        <input name="txtaPieces<%= i %>" type="text" class="shorttextfield" value="<%= aPieces(i) %>"
                                                            size="6" style="behavior: url(../include/igNumDotChkLeft.htc)">
                                                    </td>
                                                    <td>
                                                        <input name="txtaGrossWeight<%= i %>" type="text" class="shorttextfield" value="<%= ConvertAnyValue(aGrossWeight(i),"Amount",0) %>"
                                                            size="8" style="behavior: url(../include/igNumDotChkLeft.htc)">
                                                    </td>
                                                    <td>
                                                        <input name="txtaMeasurement<%= i %>" type="text" class="shorttextfield" value="<%= ConvertAnyValue(aMeasurement(i),"Amount",0) %>"
                                                            size="8" style="behavior: url(../include/igNumDotChkLeft.htc)">
                                                    </td>
                                                    <td>
                                                        &nbsp;
                                                    </td>
                                                    <td>
                                                        &nbsp;
                                                    </td>
                                                    <td>
                                                        <input type="image" src="../images/button_add.gif" width="37" height="17" name="bAdd<%= i %>"
                                                            onclick="AddItem(<%= i %>); return false;" style="cursor: hand" />
                                                    </td>
                                                    <td>
                                                        <input type="image" src="../images/button_edit.gif" width="37" height="18" value="Edit"
                                                            onclick="EditMBOL('<%= aHBOL(i) %>'); return false;" style="cursor: hand">
                                                    </td>
                                                </tr>
                                                <% next %>
                                            </tbody>
                                        </table>
                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="bodycopy" style="padding-left: 10px">
                                            <tr>
                                                <td colspan="12" height="2" bgcolor="#6D8C80">
                                                </td>
                                            </tr>
                                            <tr align="center" valign="middle" bgcolor="BFD0C9">
                                                <td height="22" colspan="12">
                                                    <span class="style8">SELECTED HOUSE B/L NO.
                                                        <% if mode_begin then %>
                                                    </span>
                                                    <div style="width: 21px; display: inline; vertical-align: middle;" onmouseover="showtip('The House bills listed in this section are consolidated to this Master B/L.  You may click Remove to take them off of the consolidation.');"
                                                        onmouseout="hidetip()">
                                                        <span class="bodyheader">
                                                            <img src="../Images/button_info.gif" align="top" class="bodylistheader"></span></div>
                                                    <% end if %>
                                                    <span class="style8"></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="12" height="1" bgcolor="#FFFFFF">
                                                </td>
                                            </tr>
                                            <tr align="left" valign="middle" bgcolor="#f3f3f3">
                                                <td height="20">
                                                    <strong>House B/L No. </strong>
                                                </td>
                                                <td colspan="2">
                                                    <strong>Exporter</strong>
                                                </td>
                                                <td colspan="2">
                                                    <strong>Consignee</strong>
                                                </td>
                                                <td>
                                                    <strong>Pieces</strong>
                                                </td>
                                                <td>
                                                    &nbsp;
                                                </td>
                                                <td>
                                                    <strong>Gross Weight (KG)</strong>
                                                </td>
                                                <td colspan="2">
                                                    <strong>Measure (CBM)</strong>
                                                </td>
                                                <td>
                                                    &nbsp;
                                                </td>
                                                <td>
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <input type="hidden" id="dHBOL">
                                            <% for i=0 to seIndex-1 %>
                                            <tr align="left" valign="middle" bgcolor="#FFFFFF">
                                                <td height="20">
                                                    <input name="txtsHBOL<%= i %>" type="text" class="bodyheader dHBOL" id="dHBOL" value="<%= sHBOL(i) %>"
                                                        size="11">
                                                </td>
                                                <td colspan="2">
                                                    <input name="txtsExporter<%= i %>" type="text" class="shorttextfield" value="<%= sExporter(i) %>"
                                                        size="45">
                                                </td>
                                                <td colspan="2">
                                                    <input name="txtsConsignee<%= i %>" type="text" class="shorttextfield" value="<%= sConsignee(i) %>"
                                                        size="45">
                                                </td>
                                                <td>
                                                    <input name="txtsPieces<%= i %>" type="text" class="shorttextfield" value="<%= sPieces(i) %>"
                                                        size="6" style="behavior: url(../include/igNumDotChkLeft.htc)">
                                                </td>
                                                <td>
                                                    &nbsp;
                                                </td>
                                                <td>
                                                    <input name="txtsGrossWeight<%= i %>" type="text" class="shorttextfield" value="<%= ConvertAnyValue(sGrossWeight(i),"Amount",0) %>"
                                                        size="8" style="behavior: url(../include/igNumDotChkLeft.htc)">
                                                </td>
                                                <td colspan="2">
                                                    <input name="txtsMeasurement<%= i %>" type="text" class="shorttextfield" value="<%= ConvertAnyValue(sMeasurement(i),"Amount",0) %>"
                                                        size="8" style="behavior: url(../include/igNumDotChkLeft.htc)">
                                                </td>
                                                <td>
                                                    <input type="image" src="../images/button_edit.gif" width="37" height="18" onclick="EditMBOL('<%= sHBOL(i) %>'); return false;"
                                                        style="cursor: hand">
                                                </td>
                                                <td>
                                                    <input type="image" src="../images/button_remove.gif" width="55" height="17" onclick="DeleteItem(<%= i %>); return false;"
                                                        style="cursor: hand">
                                                </td>
                                            </tr>
                                            <% next %>
                                            <tr align="left" valign="middle" bgcolor="#FFFFFF">
                                                <td height="20">
                                                    &nbsp;
                                                </td>
                                                <td colspan="2">
                                                    &nbsp;
                                                </td>
                                                <td colspan="2" align="right" style="padding-right: 4px">
                                                    <span class="style5"><strong>TOTAL </strong></span>
                                                </td>
                                                <td>
                                                    <input name="txtTotalPieces" type="text" class="shorttextfield" value="<%= ConvertAnyValue(TotalPieces,"Long",0) %>"
                                                        size="6" onkeyup="checkDecimalTextMax(this,5);" style="behavior: url(../include/igNumDotChkLeft.htc)">
                                                </td>
                                                <td>
                                                    &nbsp;
                                                </td>
                                                <td>
                                                    <input name="txtTotalGrossWeight" type="text" class="shorttextfield" value="<%= FormatNumberPlus(ConvertAnyValue(TotalGrossWeight,"Amount",0),2) %>"
                                                        size="8" onkeyup="checkDecimalTextMax(this,5);" style="behavior: url(../include/igNumDotChkLeft.htc)">
                                                </td>
                                                <td colspan="2">
                                                    <input name="txtTotalMeasurement" type="text" class="shorttextfield" value="<%= FormatNumberPlus(ConvertAnyValue(TotalMeasurement,"Amount",0),2) %>"
                                                        size="8" onkeyup="checkDecimalTextMax(this,5);" style="behavior: url(../include/igNumDotChkLeft.htc)">
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr align="left" valign="middle">
                                                <td height="2" colspan="12" bgcolor="#6D8C80">
                                                </td>
                                            </tr>
                                            <tr align="left" valign="middle" bgcolor="BFD0C9">
                                                <td height="20" colspan="12" class="bodyheader">
                                                    <span class="style5">FREIGHT CHARGE</span><strong> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strong>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="12" height="1" bgcolor="FFFFFF">
                                                </td>
                                            </tr>
                                            <tr align="left" valign="middle" bgcolor="#f3f3f3">
                                                <td height="20">
                                                    <strong>C/P</strong>
                                                </td>
                                                <td>
                                                    <strong>No. of Pieces</strong>
                                                </td>
                                                <td>
                                                    <strong>Unit of Qty</strong>.
                                                </td>
                                                <td>
                                                    <strong>Gross Weight (KG)</strong>
                                                </td>
                                                <td>
                                                    <strong>Gross Weight (LB)</strong>
                                                </td>
                                                <td colspan="2">
                                                    <strong>Dimension (CBM)</strong>
                                                </td>
                                                <td>
                                                    <strong>Dimension(CFT)</strong>
                                                </td>
                                                <td>
                                                    <strong>Rate</strong>
                                                </td>
                                                <td colspan="3">
                                                    <strong>Total</strong>
                                                </td>
                                            </tr>
                                            <tr align="left" valign="middle">
                                                <td>
                                                    <select name="lstWeightCP" size="1" class="smallselect" onchange="WeightCPChange()">
                                                        <option value="C">C</option>
                                                        <option value="P" <% if vWeightCP="P" then response.write("selected") %>>P</option>
                                                    </select>
                                                </td>
                                                <td>
                                                    <input name="txtPieces" class="numberfield" onblur="CheckData()" value="<%= CheckBlank(vPieces,0) %>"
                                                        size="8" onkeyup="checkDecimalTextMax(this,7);" style="behavior: url(../include/igNumDotChkLeft.htc)">
                                                </td>
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
                                                    <input name="txtGrossWeight" class="shorttextfield" onblur="CheckData1()" value="<%=ConvertAnyValue(vGrossWeight,"Amount",0) %>"
                                                        size="15" style="behavior: url(../include/igNumDotChkLeft.htc)" onkeyup="checkDecimalTextMax(this,10);">
                                                </td>
                                                <td>
                                                    <input name="txtGWLB" class="shorttextfield" onblur="CheckData2()" value="<%=ConvertAnyValue(vGWLB,"Amount",0) %>"
                                                        size="15" style="behavior: url(../include/igNumDotChkLeft.htc)" onkeyup="checkDecimalTextMax(this,10);">
                                                    <input type="hidden" id='dimtext' name="dimtext" value="<%= vDimText %>">
                                                </td>
                                                <td colspan="2">
                                                    <input type="hidden" name="hDemDetail" value="<%= vDemDetail %>">
                                                    <input name="txtMeasurement" class="shorttextfield" onblur="CheckData3()" value="<%=ConvertAnyValue(vMeasurement,"Amount",0) %>"
                                                        size="7" onkeyup="checkDecimalTextMax(this,6);" style="behavior: url(../include/igNumDotChkLeft.htc)">
                                                    <image src="../images/measure.gif" height="16" align="absbottom" onclick="DimCalClick('CBM'); return false;"
                                                        style="cursor: hand">
                                                </td>
                                                <td>
                                                    <input class="numberfield readonly" name="txtMCFT" readonly="readonly" value="<%=ConvertAnyValue(vMCFT,"Amount",0) %>"
                                                        size="7" >
                                                <!--    <input type="image" src="../images/measure.gif" height="16" align="absbottom" onclick="DimCalClick('CFT'); return false;"
                                                        style="cursor: hand">-->
                                                </td>
                                                <td>
                                                    <input name="txtChargeRate" class="shorttextfield" value="<%=ConvertAnyValue(vChargeRate,"Amount",0) %>"
                                                        size="8" onkeyup="checkDecimalTextMax(this,6);" style="behavior: url(../include/igNumDotChkLeft.htc)">
                                                </td>
                                                <td colspan="3">
                                                    <input name="txtTotalWeightCharge" class="shorttextfield" onblur="TotalWeightCharge()"
                                                        value="<%=ConvertAnyValue(vTotalWeightCharge,"Amount",0) %>" size="12" onkeyup="checkDecimalTextMax(this,10);"
                                                        style="behavior: url(../include/igNumDotChkLeft.htc)">
                                                    <input type="image" src="../images/button_cal.gif" width="37" height="18" align="absbottom"
                                                        onclick="CalClick('cal'); return false;" style="cursor: hand; margin-left: 6px">
                                                </td>
                                            </tr>
                                            <tr align="left" valign="middle" style="visibility: hidden">
                                                <td>
                                                    &nbsp;
                                                </td>
                                                <td>
                                                    &nbsp;
                                                </td>
                                                <td>
                                                    &nbsp;
                                                </td>
                                                <td>
                                                    &nbsp;
                                                </td>
                                                <td>
                                                    &nbsp;
                                                </td>
                                                <td colspan="2">
                                                    &nbsp;
                                                </td>
                                                <td>
                                                    &nbsp;
                                                </td>
                                                <td>
                                                    <input name="txtRateRealCost" class="shorttextfield" value="<% if vRateRealCost="0" then response.Write("N/A")else response.Write(CheckBlank(vRateRealCost,0))end if  %>"
                                                        onkeyup="checkDecimalTextMax(this,6);" style="behavior: url(../include/igNumDotChkLeft.htc)"
                                                        size="8">
                                                </td>
                                                <td colspan="3">
                                                    <input name="txtTotalRealCost" class="shorttextfield" value="<%=FormatNumberPlus(ConvertAnyValue(vTotalRealCost,"Amount",0),2) %>"
                                                        size="12" onkeyup="checkDecimalTextMax(this,10);" style="behavior: url(../include/igNumDotChkLeft.htc)">
                                                    <input type="image" src="../images/button_cal.gif" width="37" height="18" align="absbottom"
                                                        name="bCalRealCost" id="bCalRealCost" onclick="bCalRealCostClick(); return false;"
                                                        style="cursor: hand; margin-left: 6px" />
                                                </td>
                                            </tr>
                                            <!-- -->
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="bodycopy" style="padding-left: 10px">
                                            <tr align="left" valign="middle" bgcolor="E0EDE8">
                                                <td height="21">
                                                    <strong>Marks and Numbers</strong>
                                                </td>
                                                <td>
                                                    <strong>Number of Packages</strong>
                                                </td>
                                                <td>
                                                    <strong>Description of Commodities</strong>
                                                </td>
                                                <td bgcolor="E0EDE8">
                                                    <strong>Gross Weight</strong> (KG) <strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Measurement</strong>
                                                    (CBM)
                                                </td>
                                            </tr>
                                            <tr align="left" valign="top">
                                                <td rowspan="6">
                                                    <textarea name="txtDesc1" cols="24" rows="17" wrap="hard" class="multilinetextfield"><%= vDesc1 %></textarea>
                                                </td>
                                                <td rowspan="6">
                                                    <textarea name="txtDesc2" cols="24" rows="17" wrap="hard" class="multilinetextfield"><%= vDesc2 %></textarea>
                                                </td>
                                                <td rowspan="6">
                                                    <textarea name="txtDesc3" cols="60" rows="17" wrap="hard" class="multilinetextfield"><%= vDesc3 %></textarea>
                                                </td>
                                                <td>
                                                    <textarea name="txtDesc4" cols="35" rows="9" wrap="hard" class="multilinetextfield"
                                                        readonly="readonly" style="font-size: 11px; font-family: monospace;"><%= vDesc4 %></textarea>
                                                </td>
                                            </tr>
                                            <tr align="left" valign="top">
                                                <td height="20" valign="middle" bgcolor="#FFFFFF" class="bodyheader">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr align="left" valign="top">
                                                <td>
                                                    <textarea name="txtDesc5" cols="35" rows="4" wrap="hard" class="multilinetextfield"><%= vDesc5 %></textarea>
                                                </td>
                                            </tr>
                                            <tr align="left" valign="top">
                                                <td height="20" valign="middle" bgcolor="#FFFFFF" class="bodyheader">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <% If seIndex = 0 And vBookingNum <> "" Then %>
                                                    <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                                        <tr>
                                                            <td>
                                                                <strong>ITN Number</strong>
                                                            </td>
                                                            <td style="width: 10px">
                                                            </td>
                                                            <td>
                                                                <input type="text" class="shorttextfield" name="txtAES" id="txtAES" value="<%=vAES %>"
                                                                    style="width: 150px" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <strong>SED Statement</strong>
                                                            </td>
                                                            <td style="width: 10px">
                                                            </td>
                                                            <td>
                                                                <input type="text" class="shorttextfield" name="txtSEDStatement" id="txtSEDStatement"
                                                                    value="<%=vSEDStmt %>" style="width: 150px" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <% End If %>
                                                </td>
                                            </tr>
                                            <tr align="left" valign="top">
                                                <td height="20" valign="middle" bgcolor="#FFFFFF" class="bodyheader">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td width="100%" align="left" valign="top">
                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="bodycopy" style="padding-left: 10px">
                                                        <tr align="left" valign="middle">
                                                            <td height="1" colspan="5" bgcolor="#6D8C80">
                                                            </td>
                                                        </tr>
                                                        <tr align="left" valign="middle" bgcolor="BFD0C9">
                                                            <td height="20" colspan="5" class="bodyheader">
                                                                <span class="style5">OTHER CHARGE </span>
                                                            </td>
                                                        </tr>
                                                        <tr align="left" valign="middle">
                                                            <td height="1" colspan="5" bgcolor="#FFFFFF">
                                                            </td>
                                                        </tr>
                                                        <tr align="left" valign="middle" bgcolor="#f3f3f3">
                                                            <td width="166" height="20">
                                                                <strong>C/P</strong>
                                                            </td>
                                                            <td width="358">
                                                                <strong>Charge Item</strong>
                                                            </td>
                                                            <td colspan="3">
                                                                <strong>Amount</strong>
                                                            </td>
                                                        </tr>
                                                        <input type="hidden" id="ChargeAmt" name="1">
                                                        <input type="hidden" id="CostAmt" name="2">
                                                        <input type="hidden" id="ChargeItem" name="3">
                                                        <input type="hidden" id="ChargeVendor" name="4">
                                                        <input type="hidden" id="ItemName" name="5">
                                                        <% for i=0 to tIndex-1 %>
                                                        <tr align="left" valign="middle" bgcolor="#FFFFFF">
                                                            <td height="20">
                                                                <input type="hidden" id="hItemName" name="hItemName<%= i %>" value="<%= aChargeItemName(i) %>">
                                                                <select name="lstOtherChargeCP<%= i %>" size="1" class="smallselect ItemName" style="width: 58px">
                                                                    <option <% if aChargeCP(i)="C" then response.write("selected") %>>C</option>
                                                                    <option <% if aChargeCP(i)="P" then response.write("selected") %>>P</option>
                                                                </select>
                                                            </td>
                                                            <td>
                                                                <select name="lstChargeItem<%= i %>" size="1" class="smallselect ChargeItem" id="ChargeItem"
                                                                    style="width: 250px" onchange="ItemChange('<%= i %>',this.selectedIndex)">
                                                                    <option value="0">Select One</option>
                                                                    <% for k=0 to chIndex-1 %>
                                                                    <option value="<%= aItemNo(k) & "-" & aChargeUnitPrice(k)  %>" <% if aChargeItem(i)=aItemNo(k) then response.write("selected") %>>
                                                                        <%= aChargeItemNameig(k) %>
                                                                    </option>
                                                                    <% next %>
                                                                </select>
                                                            </td>
                                                            <td>
                                                                <input name="txtChargeAmt<%= i %>" class="numberalign ChargeAmt<%= i %>" id="ChargeAmt"
                                                                    value="<%=FormatNumberPlus(ConvertAnyValue(aChargeAmt(i),"Amount",0),2) %>" size="26"
                                                                    onkeyup="checkDecimalTextMax(this,12);" style="behavior: url(../include/igNumDotChkLeft.htc)">
                                                            </td>
                                                            <td>
                                                                &nbsp;
                                                            </td>
                                                            <td width="90">
                                                                <input type="image" src="../images/button_delete.gif" width="50" height="17" onclick="DeleteItemOC(<%= i %>); return false;"
                                                                    style="cursor: hand">
                                                            </td>
                                                        </tr>
                                                        <% next %>
                                                        <tr align="left" valign="middle" bgcolor="#F3f3f3">
                                                            <td width="166" height="20">
                                                                &nbsp;
                                                            </td>
                                                            <td width="358">
                                                                &nbsp;
                                                            </td>
                                                            <td width="446">
                                                                &nbsp;
                                                            </td>
                                                            <td width="88">
                                                                &nbsp;
                                                            </td>
                                                            <td>
                                                                <input type="image" src="../images/button_add.gif" width="37" height="17" name="bAdd"
                                                                    onclick="AddItemOC(); return false;" style="cursor: hand">
                                                            </td>
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
                                                        <tr align="left" valign="middle" bgcolor="#FFFFFF">
                                                            <td height="20" colspan="5">
                                                                Carrier has a policy against payment, solicitation, or receipt of any rebate, directly
                                                                or indirectly. which would be unlawful under the United Stated Shipping Act. 1984
                                                                as amended.
                                                            </td>
                                                        </tr>
                                                        <tr align="left" valign="middle" bgcolor="#FFFFFF">
                                                            <td colspan="5" height="20">
                                                                DECLARED VALUE
                                                                <input name="txtDeclaredValue" class="shorttextfield" maxlength="9" onblur="CheckData()"
                                                                    value="<%= vDeclaredValue %>" size="16">
                                                                READ CLAUSE 29 HEREOF CONCERNING EXTRA FREIGHT AND CARRIER'S LIMITATIONS OF LIABILITY.
                                                            </td>
                                                        </tr>
                                                        <tr align="left" valign="middle">
                                                            <td height="1" colspan="5" bgcolor="ffffff">
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="50%" align="left" valign="top">
                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="bodycopy" style="padding-left: 10px">
                                            <tr align="center" valign="middle" bgcolor="E0EDE8">
                                                <td height="20" colspan="3" bgcolor="E0EDE8">
                                                    <strong>Freight Rates, Charges, Weights and/or Measurements</strong>
                                                </td>
                                            </tr>
                                            <tr align="left" valign="middle" bgcolor="E0EDE8">
                                                <td width="60%" height="20" bgcolor="#f3f3f3">
                                                    Subject to Correction
                                                </td>
                                                <td width="20%" bgcolor="#f3f3f3">
                                                    Prepaid
                                                </td>
                                                <td width="20%" bgcolor="#f3f3f3">
                                                    Collect
                                                </td>
                                            </tr>
                                            <tr align="left" valign="middle">
                                                <td>
                                                    <input name="txtOceanFreight" class="readonly" value="Ocean Freight" size="45" readonly="readonly">
                                                </td>
                                                <td>
                                                    <input name="txtPOceanFreight" class="readonlyright" value="<% If vWeightCP="P" Then Response.Write(vTotalWeightCharge) %>"
                                                        style="width: 70px" readonly="readonly">
                                                </td>
                                                <td>
                                                    <input name="txtCOceanFreight" class="readonlyright" value="<% if vWeightCP="C" Then Response.Write(vTotalWeightCharge) %>"
                                                        style="width: 70px" readonly="readonly">
                                                </td>
                                            </tr>
                                            <input type="hidden" id="POtherCharge" name="6">
                                            <input type="hidden" id="COtherCharge">
                                            <% for i=0 to 9 %>
                                            <tr align="left" valign="middle">
                                                <td>
                                                    <input name="txtOtherChargeDesc<%= i %>" class="readonly" value="<%= aChargeItemName(i) %>"
                                                        size="45" readonly>
                                                </td>
                                                <td>
                                                    <input name="txtPOtherCharge<%= i %>" class="readonlyright POtherCharge" id="POtherCharge" value="<% if aChargeCP(i)="P" Then Response.Write(aChargeAmt(i)) %>"
                                                        style="width: 70px" readonly="readonly">
                                                </td>
                                                <td>
                                                    <input name="txtCOtherCharge<%= i %>" class="readonlyright COtherCharge" id="COtherCharge" value="<% if aChargeCP(i)="C" Then Response.Write(aChargeAmt(i)) %>"
                                                        style="width: 70px" readonly="readonly">
                                                </td>
                                            </tr>
                                            <% next %>
                                            <tr>
                                                <td align="right" valign="middle">
                                                    <span class="style1">GRAND TOTAL </span>
                                                </td>
                                                <td align="left" valign="middle">
                                                    <strong>
                                                        <input name="txtTotalPrepaid" class="readonlyboldright" value="<%=FormatNumberPlus(ConvertAnyValue(vTotalPrepaid,"Amount",0),2) %>"
                                                            style="width: 70px" readonly="readonly">
                                                    </strong>
                                                </td>
                                                <td align="left" valign="middle">
                                                    <strong>
                                                        <input name="txtTotalCollect" class="readonlyboldright" value="<%=FormatNumberPlus(ConvertAnyValue(vTotalCollect,"Amount",0),2) %>"
                                                            style="width: 70px" readonly="readonly">
                                                    </strong>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    &nbsp;
                                                </td>
                                                <td align="left" valign="middle">
                                                    &nbsp;
                                                </td>
                                                <td align="left" valign="middle">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td width="50%" align="left" valign="top">
                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="bodycopy" style="padding-left: 10px">
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
                                                    shall be void.
                                                </td>
                                            </tr>
                                            <tr>
                                                <td height="20" align="left" valign="middle">
                                                    &nbsp;
                                                </td>
                                                <td align="left" valign="middle">
                                                    &nbsp;
                                                </td>
                                                <td align="left" valign="middle">
                                                    &nbsp;
                                                </td>
                                                <td align="left" valign="middle">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="10%" align="left" valign="middle">
                                                    At
                                                </td>
                                                <td width="40%" align="left" valign="middle">
                                                    <code><kbd><sup>
                                                        <input name="txtPlace" maxlength="32" class="shorttextfield" value="<%= vPlace %>"
                                                            size="37">
                                                    </sup></kbd></code>
                                                </td>
                                                <td width="10%" align="left" valign="middle">
                                                    &nbsp;
                                                </td>
                                                <td width="40%" align="left" valign="middle">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="left" valign="middle">
                                                    By
                                                </td>
                                                <td align="left" valign="middle">
                                                    <code><kbd><sup>
                                                        <input name="txtBy" maxlength="64" class="shorttextfield" value="<%= vBy %>" size="37">
                                                    </sup></kbd></code>
                                                </td>
                                                <td align="left" valign="middle">
                                                    &nbsp;
                                                </td>
                                                <td align="left" valign="middle">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td height="21" align="left" valign="middle">
                                                    Date
                                                </td>
                                                <td align="left" valign="middle">
                                                    <code><kbd><sup>
                                                        <input name="txtDate" class="shorttextfield" value="<%= vDate %>" size="37">
                                                    </sup></kbd></code>
                                                </td>
                                                <td align="left" valign="middle">
                                                    &nbsp;
                                                </td>
                                                <td align="left" valign="middle">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr bgcolor="E0EDE8">
                                                <td height="20" colspan="4" align="left" valign="middle">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2" align="left" valign="middle">
                                                    &nbsp;
                                                </td>
                                                <td colspan="2" align="left" valign="middle">
                                                    &nbsp;
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
                                                        <% For i=0 To SRIndex-1 %>
                                                        <option value="<%= aSRName(i)%>" <%
  	                    if vSalesPerson = aSRName(i) then response.write("selected") %>>
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
                    <tr>
                        <td colspan="2" height="1" bgcolor="6D8C80">
                        </td>
                    </tr>
                    <tr>
                        <td height="24" colspan="2" align="center" valign="middle" bgcolor="#BFD0C9">
                            <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td width="26%">
                                        &nbsp;
                                    </td>
                                    <td width="49%" align="center" valign="middle">
                                        <input type="image" src="../images/button_save_medium.gif" width="46" height="18"
                                            name="bSave" onclick="SaveClick(); return false;" style="cursor: hand">
                                    </td>
                                    <td width="13%" align="right" valign="middle">
                                        <a target="_parent" href="/OceanExport/MAWB">
                                            <img src="/ASP/Images/button_new.gif" width="42" height="17" border="0" style="cursor: hand"></a>
                                    </td>
                                    <td width="12%" align="right" valign="middle">
                                        <input type="image" src="../images/button_delete_medium.gif" width="51" height="17"
                                            name="bDeleteMBOL" onclick="DeleteMBOL(); return false;" style="cursor: hand">
                                    </td>
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
                <% If vBookingNum <> "" Then %>
                <div id="print">
                    <a href="javascript:;" onclick="SetCostItems(); return false;" tabindex="-1">Cost Items</a>
                    <img src="/ASP/Images/button_devider.gif" alt="" />
                    <a href="javascript:;" onclick="SetCreditNote(); return false;" tabindex="-1">Credit
                        Note</a>
                    <img src="/ASP/Images/button_devider.gif" alt="" />
                    <a href="javascript:EditClick('','<%=vBookingNum %>');" tabindex="-1">
                        <img src="/ASP/Images/icon_createhouse.gif" alt="Click here to create SED" width="25"
                            height="26" style="margin-right: 10px" />Create AES</a>
                    <img src="/ASP/Images/button_devider.gif" alt="" />
                    <a href="javascript:void(0);" id="NewPrintVeiw2" >
                        <img src="/ASP/Images/icon_printer.gif" width="40" height="27" align="absbottom"
                            alt="" />Master B/L Instruction</a></div>
                <% End If %>
            </td>
        </tr>
    </table>
    <br>
    </form>
</body>
<script language="javascript" type="text/javascript" src="/ASP/ajaxFunctions/ajax_ig_call_db.js">  </script>
<script type="text/javascript">

    function UnitQtyChange() {//converted from vbscript
        var  UnitQty = document.form1.lstUnitQty.value;
        var Pieces = document.form1.txtPieces.value;
        document.form1.txtDesc2.value = Pieces + " " + UnitQty;
    }

    function CalClick(arg) {
        var WeightCP = document.form1.lstWeightCP.value;
        var GWKG = CheckNullToZero(document.form1.txtGrossWeight.value);
        var GWLB = CheckNullToZero(document.form1.txtGWLB.value);
        var Pieces = CheckNullToZero(document.form1.txtPieces.value);
        var Rate = CheckNullToZero(document.form1.txtChargeRate.value);
        var MCBM = CheckNullToZero(document.form1.txtMeasurement.value);
        var MCFT = CheckNullToZero(document.form1.txtMCFT.value);
        var TotalDem = 0;

        if (MCBM != "") {
            if (MCBM > 0)
                TotalDem = MCBM;
        }
        var cw = FormatNumberPlus(TotalDem, 2);
        if (GWKG.trim() == "") {
            alert("Please enter a Gross Weight");
            return;
        }

        var GrossWeight = FormatNumberPlus(GWKG, 2) / 1000;
        if (cw < FormatNumberPlus(GrossWeight, 2))
            cw = GrossWeight;
        var tc = FormatNumberPlus(parseFloat(Rate) * cw, 2);
        if (document.form1.txtTotalWeightCharge.value.trim() != "") {
            //comment out following lines if u want to calculate always
            if (arg == "save")
                tc = document.form1.txtTotalWeightCharge.value;

            if (document.form1.txtChargeRate.value.trim() != "")
                document.form1.txtTotalWeightCharge.value = tc;

            if (WeightCP == "P") {
                document.form1.txtPOceanFreight.value = tc;
                document.form1.txtCOceanFreight.value = 0;
            }
            else {
                document.form1.txtCOceanFreight.value = tc;
                document.form1.txtPOceanFreight.value = 0;
            }
        }
        else if (document.form1.txtTotalWeightCharge.value.trim() == "") {
            document.form1.txtTotalWeightCharge.value = tc;
            if (WeightCP == "P") {
                document.form1.txtPOceanFreight.value = tc;
                document.form1.txtCOceanFreight.value = 0;
            }
            else {
                document.form1.txtCOceanFreight.value = tc;
                document.form1.txtPOceanFreight.value = 0;
            }
        }
        document.form1.txtMeasurement.value = Math.round(TotalDem * 100) / 100;


        var string1 = parseFloat(GWKG).toFixed(2) + " KG";
        var string2 = parseFloat(MCBM).toFixed(2) + " CBM";
        var string3 = parseFloat(GWLB).toFixed(2) + " LB";
        var string4 = parseFloat(MCFT).toFixed(2) + " CFT";

        string1 = Space(15 - string1.length) + string1.trim();
        string2 = Space(15 - string2.length) + string2.trim();
        string3 = Space(15 - string3.length) + string3.trim();
        string4 = Space(15 - string4.length) + string4.trim();

        vDesc4 = string1 + "  " + string2 + '\n';
        vDesc4 = vDesc4 + string3 + "  " + string4;

        document.form1.txtDesc4.value = vDesc4;

        UnitQtyChange();

    }
    if ("<%=Delete%>" == "yes" || "<%=Add%>" == "yes") {
        CalClick("cal");
    }

    function FormatNumberPlus(argStrVal, decim) {
        var returnVal;
        returnVal = 0;
        if (argStrVal != null && argStrVal != "undefined" && argStrVal != "") {
            
            if (IsNumeric(argStrVal) && !isNaN(argStrVal))
                returnVal = parseFloat(argStrVal).toFixed(decim);
        }
        return returnVal;
    }

    
function DimCalClick(Scale){
    var props = "scrollBars=no,resizable=yes,toolbar=no,menubar=no,location=no,directories=no,width=350,height=280"
    window.open ("dimcal.asp?S="+ Scale +"&P=" + document.form1.txtPieces.value, "Dimension_Calculation", props);
}


function CheckData(){
    var Pieces=document.form1.txtPieces.value;
    var GWKG=document.form1.txtGrossWeight.value; //'this is in KG
    var GWLB=document.form1.txtGWLB.value;
    var MCBM=document.form1.txtMeasurement.value; //'this is in CBM
    var MCFT=document.form1.txtMCFT.value;
    var DeclaredValue=document.form1.txtDeclaredValue.value;
   if (!Pieces=="" ){
	    if (!IsNumeric(Pieces) ){
		    alert( "Please enter a numeric value for PIECES!");
		    document.form1.txtPieces.value="";
	    }
    }
    if (!GWKG==""  ){
	    if(!IsNumeric(GWKG)){
		    alert( "Please enter a numeric value for GrossWeight/KG!");
		    document.form1.txtGrossWeight.value="";
	    }
    }
    if (!GWLB==""  ){
	    if (!IsNumeric(GWLB)){
		    alert( "Please enter a numeric value for GrossWeight/LB!");
		    document.form1.txtGWLB.value="";
	    }
    }
    if (!MCBM==""  ){
	    if (!IsNumeric(MCBM)){
		    alert( "Please enter a numeric value for Measurement/CBM!");
		    document.form1.txtMeasurement.value="";
	    }
    }
    if (!MCFT==""  ){
	    if (!IsNumeric(MCFT)){
		    alert( "Please enter a numeric value for Measurement/CFT!");
		    document.form1.txtMCFT.value="";
	    }
    }
    if (!DeclaredValue==""  ){
        if (!IsNumeric(DeclaredValue)) {
		    alert( "Please enter a numeric value for DeclaredValue!");
		    document.form1.txtDeclaredValue.value="";
	    }
    }
}

function CheckData1(){
    var GWKG=document.form1.txtGrossWeight.value;
    var tmpNum;
    if (GWKG!="" ){
	   if (!IsNumeric(GWKG) ){
		    alert( "Please enter a numeric value for GrossWeight/KG!");
		    document.form1.txtGrossWeight.value="";
		    return;
	    }
	    
	   var GWLB=GWKG*2.20462262185;
        
       if (document.form1.txtGWLB.value != "" ) 
		    tmpNum = Math.abs(GWLB - document.form1.txtGWLB.value);
	    else
		    document.form1.txtGWLB.value=FormatNumberPlus(GWLB,2)	

	    if ( tmpNum > 1 ) 
         	document.form1.txtGWLB.value=FormatNumberPlus(GWLB,2);
    }
}

function CheckData2(){
    var GWLB=document.form1.txtGWLB.value; 
    //'this is in LB
    if (GWLB!="" ){
	    if (!IsNumeric(GWLB)){
		    alert( "Please enter a numeric value for GrossWeight/LB!");
		    document.form1.txtGWLB.value="";
		    return;
	    }
	    GWKG=GWLB*0.4535924277;
	    tmpNum = Math.abs(GWKG - document.form1.txtGrossWeight.value);

	    if ( tmpNum > 1 ) 
          document.form1.txtGrossWeight.value=Math.round(GWKG * 100) / 100;
    }
}

function CheckData3(){
    var MCBM=document.form1.txtMeasurement.value; 
    //'this is in CBM
    if (MCBM!="" ){
	    if (!IsNumeric(MCBM)) {
		    alert( "Please enter a numeric value for Measurement/CBM!");
		    document.form1.txtMeasurement.value="";
		    return;
	    }
	    MCFT=MCBM*35.314666721;
	    document.form1.txtMCFT.value=Math.round(MCFT * 100) / 100;
    }
}

function CheckData4(){
    var MCFT=document.form1.txtMCFT.value; //'this is in CFT
    if (MCFT != "") {
        if (!IsNumeric(MCFT)) {
            alert("Please enter a numeric value for Measurement/CFT!");
            document.form1.txtMCFT.value = "";
            return;
        }
        MCBM = MCFT / 35.314666721;
        document.form1.txtMeasurement.value = Math.round(MCBM * 100) / 100;
    }
}


function WeightCPChange() {
    var sindex=document.form1.lstBookingNum.selecteIindex;
    var BookingNum=document.form1.lstBookingNum.item(sindex).text;
    document.form1.hBookingNum.value=BookingNum;
    var bInfo=document.form1.lstBookingNum.value;
    var pos=0;
    pos = bInfo.indexOf('\n');
    var DepartureDate="";
    if (pos>=0 ){
	    DepartureDate=bInfo.substring(0,pos);
	    bInfo = bInfo.substring(pos + 1, 200);
    }
    pos = bInfo.indexOf('\n');
	var LoadingPort="";
	if (pos >= 0) {
	    LoadingPort=bInfo.substring(0,pos);
	    bInfo = bInfo.substring(pos + 1, 200);
    }
    pos = bInfo.indexOf('\n');
	var unLoadingPort="";
	if (pos >= 0) {
	    unLoadingPort=bInfo.substring(0,pos);
	    bInfo = bInfo.substring(pos + 1, 200);
	}
    var ExportCarrier="";
    pos=bInfo.indexOf('\n');
    if (pos >= 0) {
	    ExportCarrier=bInfo.substring(0,pos);
	    bInfo = bInfo.substring(pos + 1, 200);
    }
    pos = bInfo.indexOf('\n');
	var Country="";
    var MBOLNum="";
   if (pos >= 0) {
        
	    //Country=Mid(bInfo,1,pos-1)
        Country=bInfo.substring(0,pos);
	   // MBOLNum=Mid(bInfo,pos+1,200)
        MBOLNum=bInfo.substring(pos,200);

   }

    var CP=document.form1.lstWeightCP.value;
    if (CP=="C") 
	    CP="COLLECT";
    else
	    CP="PREPAID";

    var Desc5="FREIGHT " + CP + '\n' + "LADEN ON BOARD:" + '\n' 
       + DepartureDate + '\n' + ExportCarrier  + '\n' + LoadingPort;
    document.form1.txtDesc5.value = Desc5;

    var WeightCharge=document.form1.txtTotalWeightCharge.value;
    var TotalCCharge;
    if ( WeightCharge!="" ){
	    if (!IsNumeric(WeightCharge)){
		    alert( "Please enter a numeric value!");
		    document.form1.txtTotalWeightCharge.value="";
        }
	    else{
		    if (document.form1.lstWeightCP.value=="P" ){
			    document.form1.txtPOceanFreight.value=WeightCharge;
			    document.form1.txtCOceanFreight.value="";
    			
			    var TotalPCharge=FormatNumberPlus(CheckBlank(WeightCharge,0),2);
		    }
		    else{
			    document.form1.txtCOceanFreight.value=WeightCharge;
			    document.form1.txtPOceanFreight.value="";
			    TotalCCharge=FormatNumberPlus(CheckBlank(WeightCharge,0),2);
		    }
		    for (var k=0; k < 10; k++){
			    var pc=$("input.POtherCharge").get(k).value;
			    if ( pc=!"" )
				    pc=FormatNumberPlus(CheckBlank(pc,0),2);
			    else
				    pc=0;
    			
			    TotalPCharge=TotalPCharge+pc;
			    var cc = $("input.COtherCharge").get(k).value;
			    if (cc!="" )
				    cc=FormatNumberPlus(CheckBlank(cc,0),2);
			    else
				    cc=0;

				TotalCCharge = TotalCCharge + cc;
		    }
		    document.form1.txtTotalPrepaid.value = TotalPCharge;
		    document.form1.txtTotalCollect.value = TotalCCharge;
	     }
    }

}
function ItemChange(k,sIndex){
     var ItemName;
    //var sIndex= $("select[name='lstChargeItem"+k+"']>option").selectedIndex;
    var ItemDesc = $("select[name='lstChargeItem" + k + "']>option").get(sIndex).text;

     var pos = ItemDesc.lastIndexOf("-");
    if (pos>=0 )
	    ItemDesc=ItemDesc.substring(pos+1,200);

    $("input[name=hItemName"+k+"]").get(0).value = ItemDesc.trim();
    ItemName = $("select.ChargeItem>option").get(sIndex).value;
    pos=ItemName.indexOf("-");

    var ItemUnitPrice;
   if (pos>=0 ){
	    ///////////////////////////////
	    // Unit_Price by ig 10/21/2006
	    ItemUnitPrice = GET_ITEM_UNIT_PRICE(ItemName);
    }

    if (sIndex > 0) 
        $("input.ChargeAmt"+k).get(0).value = parseFloat(ItemUnitPrice).toFixed(2); 
    else
        $("input[name=hItemName" + k + "]").get(0).value = "";
    $("input[name=hItemName" + k + "]").get(0).value = $("input[name=hItemName" + k+"]").get(0).value;
    
}



//////////////////////////////////
// Unit_Price by ig 10/21/2006
//////////////////////////////////
function GET_ITEM_UNIT_PRICE ( tmpBuf ){
    var ItemUnitPrice,pos;

    ItemUnitPrice=0;

    var pos=tmpBuf.indexOf("-");
    if (pos>0 )
	    ItemUnitPrice=tmpBuf.substring(pos+1,200);

   return ItemUnitPrice;
}
//////////////////////////////////

function TotalWeightCharge(){
    var WeightCharge = document.form1.txtTotalWeightCharge.value;
    var TotalCCharge;
     if ( WeightCharge!="" ){
	    if (!IsNumeric(WeightCharge)){
		    alert( "Please enter a numeric value!");
		    document.form1.txtTotalWeightCharge.value="";
        }
	    else{
		    if (document.form1.lstWeightCP.value=="P" ){
			    document.form1.txtPOceanFreight.value=WeightCharge;
			    document.form1.txtCOceanFreight.value="";
    			
			    var TotalPCharge=FormatNumberPlus(CheckBlank(WeightCharge,0),2);
    		}
		    else{
			    document.form1.txtCOceanFreight.value=WeightCharge;
			    document.form1.txtPOceanFreight.value="";
			    TotalCCharge=FormatNumberPlus(CheckBlank(WeightCharge,0),2);
		    }
		    for (var k=0; k < 10; k++){
			    var pc=$("input.POtherCharge").get(k).value;
			    if ( pc=!"" )
				    pc=FormatNumberPlus(CheckBlank(pc,0),2);
			    else
				    pc=0;
    			
			    TotalPCharge=TotalPCharge+pc;
			    var cc = $("input.COtherCharge").get(k).value;
			    if (cc!="" )
				    cc=FormatNumberPlus(CheckBlank(cc,0),2);
			    else
				    cc=0;

				TotalCCharge = TotalCCharge + cc;
		    }
            document.form1.txtTotalPrepaid.value = TotalPCharge;
            document.form1.txtTotalCollect.value = TotalCCharge;
        }
    }
}
</script>
<script type="text/vbscript">
Sub bCalRealCostClick()  'never used
	WeightCP=document.form1.lstWeightCP.Value
	GWKG=CheckNullToZero(document.form1.txtGrossWeight.Value)
	GWLB=CheckNullToZero(document.form1.txtGWLB.Value)
	Pieces=CheckNullToZero(document.form1.txtPieces.Value)
	Rate=CheckNullToZero(document.form1.txtRateRealCost.Value)
	
	MCBM=CheckNullToZero(document.form1.txtMeasurement.Value)
	MCFT=CheckNullToZero(document.form1.txtMCFT.Value)
	TotalDem=0
	
	if Not MCBM="" then
		if MCBM>0 then
			TotalDem=MCBM
		end if
	end if
	cw=FormatNumberPlus(CheckBlank(TotalDem,0),2)
	if TRIM(GWKG) = "" then
		msgbox "Please enter a Gross Weight"
		exit sub
	end if

	GrossWeight=FormatNumberPlus(CheckBlank(GWKG,0),2)/1000
	if cw < FormatNumberPlus(CheckBlank(GrossWeight,0),2) then cw = GrossWeight
	
	tc = Round(FormatNumberPlus(CheckBlank(Rate,0),2) * cw,2)
	document.form1.txtTotalRealCost.Value=tc		

End Sub


/////////////////////////////
Sub Lookup() ' Never used
/////////////////////////////
DIM bIndex, existBookNum, BookNum
 bIndex = "<%=bIndex%>"
	BookNum=UCASE(document.form1.txtSMAWB.value)

	if NOT TRIM(BookNum) = "" then
		existBookNum = false
		For i=0 to bIndex - 1
			if BookNum = UCASE(document.form1.lstBookingNum.item(i).text) then
				existBookNum = true
				exit for
			end if
		Next	
		
		if existBookNum Then
				document.form1.action="new_edit_mbol.asp?Edit=yes&BookingNum=" _
				    & encodeURIComponent(document.form1.txtSMAWB.value)  & "&WindowName=" & window.name
				document.form1.txtsMAWB.value = ""
				document.form1.method="POST"
				document.form1.target = window.name
				form1.submit()
		else
				msgbox "Document # " & document.form1.txtSMAWB.value & " does not exist."
		end if		
	END IF
End Sub
</script>
<script type="text/javascript">
function LookupFile(){
    var  existMJob,  mFile,last_Chr10_Index,fileno,BookNum;

    var bIndex = "<%=bIndex%>";
	var JobNo=document.form1.txtJobNum.value.toUpperCase();
	var fileno=document.form1.txtJobNum.value;
	if (JobNo.trim() != "" && fileno != "Search Here") {
		BookNum = search_booking(JobNo);
		if (BookNum != "" ){
				document.form1.action="new_edit_mbol.asp?Edit=yes&BookingNum=" 
				    + encodeURIComponent(BookNum)  + "&WindowName=" + window.name;
				document.form1.method="POST";
				document.form1.target ="_self";
				form1.submit();
		}
        else
			alert( "File # " + document.form1.txtJobNum.value + " does not exist.");
    }
	else
	    alert( "Please enter a File No!");
}

function SaveClick(){

    CalClick("save");

    if (document.form1.hConsigneeAcct.value == "" || document.form1.hConsigneeAcct.value == "0" )
	    alert( "Please select a consignee!");
    else if (document.form1.lstBookingNum.value=="" || document.form1.lstBookingNum.value=="Select One" )
	    alert( "Please select a Booking Number!");
	else{
        if (!CHECK_IV_STATUS( "<%=vMBOL%>" ) )
		    return;

        var OC=document.form1.hNoItem.value;
        for (var i=0; i<OC;i++) {
            var sindex= $("select.ChargeItem").get(i).selectedIndex;
	        var oItem=$("select.ChargeItem>option").get(sindex).value;
	        if (oItem !="" ){	
		        var pos=oItem.indexOf("-");
		        if (pos>=0 )
			        oItem=oItem.substring(0,pos);

		        var oAmt=$("input.ChargeAmt"+i).get(0).value;
		        var oCost="";
		        if (oAmt=="")
                    oAmt=0;
		        if (oCost=="") 
                    oCost=0;
		        if (!IsNumeric(oAmt) ){
			        alert( "Please enter a Numeric Value for CHARGE AMT!");
			        return;
                }
		       if (!IsNumeric(oCost) ){
			        alert(  "Please enter a Numeric Value for CHARGE COST!");
			        return;
                }
		        if ( oAmt!=0 && oItem==0 ){
			         alert( "Please select an item!");
			        return;
                }
		        if ( oAmt!=0 && !IsNumeric(oAmt)){
			         alert( "Please enter a Numeric Value for CHARGE AMT!");
			        return;
                }
	        }
        }

	    document.form1.target = "_self";
	    document.form1.action="new_edit_mbol.asp?Save=yes" + "&WindowName=" + window.name ;
	    document.form1.method="POST";
	    form1.submit();
    }
}
function AddItemOC(){
    var NoItem = parseInt(document.form1.hNoItem.value);
    if (NoItem >= 10)
        alert("Can't have more than 10 Charge Items!");
    else {
        document.form1.hNoItem.value = NoItem + 1;
        document.form1.action = "new_edit_mbol.asp?AddOC=yes" + "&tNo=" + "<%=TranNo%>" + "&WindowName=" + window.name;
        document.form1.method = "POST";
        document.form1.target = "_self";
        form1.submit();
    }
}

function DeleteItemOC(ItemNo){
	if (document.form1.hNoItem.value>0 &&  document.form1.hNoItem.value!=ItemNo ){
		
		if (confirm("Do you really want to delete this item? \r\nContinue?")) 
        {	
			document.form1.action="new_edit_mbol.asp?DeleteOC=yes&tNo=" + "<%=TranNo%>" + "&dItemNo=" +ItemNo + "&WindowName=" + window.name;
			document.form1.method="POST";
			document.form1.target="_self";
			form1.submit();
		}
	}
}
</script>
<script type="text/vbscript">


Function CheckBlank(arg1,arg2)
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
    CheckBlank = result
End Function

Sub NextClick() 'never used
    sIndex=document.form1.lstBookingNum.selectedindex
    if sIndex = 0 then
	    msgbox "Please select a Booking Number!"
	    exit sub
    end if
    BookingNum=document.form1.lstBookingNum.item(sindex).Text

    jPopUpPDF()
    document.form1.action="bol_instruction.asp?BookingNum=" & encodeURIComponent(BookingNum) & "&WindowName=" & window.name
    document.form1.method="POST"
    document.form1.target="popUpPDF"
    form1.submit()	
End Sub



</script>
<script type="text/javascript">
function adjust_screen_book(BookingNum){
    if(BookingNum !="" && BookingNum != undefined){
    var bInfo = get_mbol_booking_info(BookingNum);

    var pos = bInfo.indexOf('\n');
    var DepartureDate="";
    if (pos>=0 ){
	    DepartureDate=bInfo.substring(0,pos);
	    bInfo = bInfo.substring(pos + 1, 200);
    }
    pos = bInfo.indexOf('\n');
	var LoadingPort="";
	if (pos >= 0) {
	    LoadingPort=bInfo.substring(0,pos);
	    bInfo = bInfo.substring(pos + 1, 200);
    }
   pos = bInfo.indexOf('\n');
	var unLoadingPort="";
	if (pos >= 0) {
	    unLoadingPort=bInfo.substring(0,pos);
	    bInfo = bInfo.substring(pos + 1, 200);
	}
   var ExportCarrier="";
    pos=bInfo.indexOf('\n');
    if (pos >= 0) {
	    ExportCarrier=bInfo.substring(0,pos);
	    bInfo = bInfo.substring(pos + 1, 200);
    }
    pos = bInfo.indexOf('\n');
	var Country="";
	if (pos >= 0) {
	    Country=bInfo.substring(0,pos);
	    bInfo = bInfo.substring(pos + 1, 200);
    }
   pos = bInfo.indexOf('\n');
	var MBOLNum="";
	if (pos >= 0) {
	    MBOLNum=bInfo.substring(0,pos);
	    bInfo = bInfo.substring(pos + 1, 200);
    }
    pos = bInfo.indexOf('\n');
	var MoveType="";
	if (pos >= 0) {
	    MoveType=bInfo.substring(0,pos);
	    bInfo = bInfo.substring(pos + 1, 200);
    }
    pos = bInfo.indexOf('\n');
	var ReceiptPlace="";
	if (pos >= 0) {
	    ReceiptPlace=bInfo.substring(0,pos);
	    bInfo = bInfo.substring(pos + 1, 200);
    }

    pos = bInfo.indexOf('\n');
	var DeliveryPlace="";
    var FileNo="";
	if (pos >= 0) {
	    DeliveryPlace=bInfo.substring(0,pos);
        FileNo=bInfo.substring(pos+1,200)
	    bInfo = bInfo.substring(pos + 1, 200);
    }

   
    
    document.form1.txtLoadingPort.value=LoadingPort;
    document.form1.txtUnloadingPort.value=unLoadingPort;
    document.form1.txtExportCarrier.value=ExportCarrier;
    document.form1.txtDeliveryPlace.value=DeliveryPlace;
    document.form1.txtOriginCountry.value=Country;
    document.form1.hDepartureDate.value=DepartureDate;
    document.form1.txtMBOL.value=MBOLNum;
    document.form1.lstMoveType.value=MoveType;
    document.form1.txtPreReceiptPlace.value=ReceiptPlace;
    document.form1.txtDeliveryPlace.value=DeliveryPlace;
    
    //change by stanley on 6/18/2007//////
    var aExportRef=document.form1.txtExportRef.value;
    if (aExportRef =="")
        document.form1.txtExportRef.value=FileNo;

    var Desc5="LADEN ON BOARD:" + '\n' +DepartureDate+ '\n' + ExportCarrier + '\n' +LoadingPort;
    document.form1.txtDesc5.value = Desc5;
    }
}

function AddItem(p){
    var ItemNo=p;
    var HBOL=$("input.aHBOL").get(p).value;
    if (document.form1.hBookingNum.value == "")
        alert("Please select a booking number!");
    else {
        document.form1.action = "new_edit_mbol.asp?Add=yes&HBOL=" + encodeURIComponent(HBOL) + "&WindowName=" + window.name + "&ColoAcct=" + "<%=aColodeeAcct(p)%>";
        document.form1.method = "POST";
        document.form1.target = "_self";
        form1.submit();
    }
}

function DeleteItem(q) {
    var ItemNo = q;
    var HBOL = $("input.dHBOL").get(q).value;
    document.form1.action = "new_edit_mbol.asp?Delete=yes&HBOL=" + encodeURIComponent(HBOL) + "&WindowName=" + window.name + "&ColoAcct=" + "<%=sColodeeAcct(q)%>";
    document.form1.target = "_self";
    document.form1.method = "POST";
    form1.submit();
}

function BookingChange(){
    var sindex=document.form1.lstBookingNum.selectedIndex;
    var BookingNum=document.form1.lstBookingNum.item(sindex).text;
    document.form1.hBookingNum.Value=BookingNum;

    // by iMoon 3/2/2007
    // bInfo=document.form1.lstBookingNum.value
    BookingNum=document.form1.lstBookingNum.item(sindex).text;
    adjust_screen_book(BookingNum);

    document.form1.action = "new_edit_mbol.asp?BookingNum=" + encodeURIComponent(BookingNum) + "&WindowName=" + window.name;
    document.form1.method = "POST";
    document.form1.target = "_self";
    document.form1.submit();
}



function ConYes(){
    if (document.form1.cConYes.checked = true)
        document.form1.cConNo.checked = false;
    else
        document.form1.cConNo.checked = true;
}
function ConNo(){
    if (document.form1.cConNo.checked = true)
        document.form1.cConYes.checked = false;
    else
        document.form1.cConYes.checked = true;
}

<% if ChangeBookingNum = "yes" then %>
	adjust_screen_book (document.form1.hBookingNum.value);
<%end if%>



function DeleteMBOL(){
    var MBOL=document.form1.hMBOL.value;
    var sindex=document.form1.lstBookingNum.selectedIndex;
    var BookingNum=document.form1.lstBookingNum.item(sindex).text;

    if (MBOL=="" && BookingNum == "" )
	    alert( "The Master B/L No. is not assigned!");
    else{
	    
	    if (confirm("Do you really want to delete this Booking No.? \r\nContinue?")) {	
		    if(!CHECK_IV_STATUS( MBOL ))
			    return;

		    document.form1.action="new_edit_mbol.asp?DeleteMBOL=yes&MBOL=" + encodeURIComponent(MBOL) 
		        +"&BookingNum=" + encodeURIComponent(BookingNum) + "&WindowName=" + window.name ;
		    document.form1.method = "POST";
		    document.form1.target = "_Self";
		    form1.submit();
	    }
    }
}

function EditMBOL(HBOL){
    if (HBOL != "") {
        parent.window.location.href =
                "../../OceanExport/HBOL/"
                + encodeURIComponent(
                    "WindowName=<%=WindowName %>&HBOL="
                    + HBOL
                );

    }
       // window.location.href = encodeURI("new_edit_hbol.asp?WindowName=<%=WindowName %>&HBOL=" & HBOL)
}

function CHECK_IV_STATUS( tvMAWB ){
    if (tvMAWB == "" || tvMAWB == "0" ){
	    return true;
    }

    var IVstrMSG = "<%=IVstrMsg%>";

    if (IVstrMSG != ""){
        if (confirm("Invoice No. " + IVstrMSG + " for MBOL#:" + tvMAWB + " was processed already.\r\nDo you want to continue?")) 
		    return true;
	    else
		    return false;
    }

    return true;
}


function NewPrintVeiw(){
    var props,Booking,sindex,BookingNum;
    sindex = document.form1.lstBookingNum.selectedIndex;
    BookingNum = document.form1.lstBookingNum.item(sindex).text;
			//change by stanley on 6/19/2007
    if (BookingNum != ""  && BookingNum != "Select One" ){
        props = "scrollBars=no,resizable=yes,toolbar=no,menubar=no,location=no,directories=no,status=yes,width=880,height=650"
        window.open ("view_print.asp?WindowName=" + window.name + "&sType=booking&booking=" +encodeURIComponent(BookingNum), "popUpWindow", props);
    }
	else
        alert("Please, select Booking NO. to view PDF");
    
}

    function search_booking(jobNo) {
        if (window.ActiveXObject) {
            try {
                xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
            } catch (e) {
                try {
                    xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
                } catch (f) {
                    return true;
                }
            }
        } else if (window.XMLHttpRequest) {
            xmlHTTP = new XMLHttpRequest();
        } else { return true; }

        var url = "/ASP/ajaxFunctions/ajax_booking_search.asp" + "?j=" + encodeURIComponent(jobNo);

        try {
            xmlHTTP.open("get", url, false);
            xmlHTTP.send();
            var sourceCode = xmlHTTP.responseText;
            if (sourceCode) {
                if (sourceCode == 'no') {
                    return false;
                } else {
                    return sourceCode;
                }
            }
        } catch (e) { return false; }
    }

</script>

    <script>
        
        $(document).ready(function (){
           
            if(parent.PrepPDFPrintOptions==undefined)
            {    
             $("#NewPrintVeiw1").click(
                function () { 
                    if(confirm("You cannot print this document in a popup mode. Would you like to try in full page mode?"))
                    {
                         opener.top.location.href="/OceanExport/MBOL/"+window.location.href.split("?")[1];
                         window.close();
                    }
                    else
                    { 
                        window.close();
                    } 
                });
            }
        });

    </script>
   
<script language="JavaScript" type="text/javascript" src="../include/tooltips.js"></script>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
