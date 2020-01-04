<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<%
    Response.CacheControl = "no-cache"
    Response.AddHeader "Pragma", "no-cache"
    Response.Expires = -1
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Ocean Import - Arrival Notice/Freight Invoice </title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../include/JPED.js"></script>
    <script type="text/javascript" src="../Include/JPTableDOM.js"></script>
    <script type="text/javascript" language="javascript" src="/ASP/ajaxFunctions/ajax.js"></script>
    <style type="text/css">
        .style1
        {
            color: #cc6600;
            font-weight: bold;
        }
        .style2
        {
            color: #336699;
        }
        .style3
        {
            color: #cc6600;
        }
        .style4
        {
            color: #09609F;
        }
        .style5
        {
            color: #000000;
        }
        .style6
        {
            color: #663366;
        }
        .numberaligh
        {
            font-weight: bold;
            font-size: 9px;
            text-align: right;
            font-family: Verdana, Arial, Helvetica, sans-serif;
        }
        body
        {
            margin-left: 0px;
            margin-right: 0px;
            margin-bottom: 0px;
        }
        .style7
        {
            color: #CC3300;
            font-weight: bold;
        }
        .style7 a:hover
        {
            color: #CC3300;
        }
        .style8
        {
            color: #CC6600;
        }
    </style>
    <script type="text/javascript">

        var ComboBoxes = new Array('lstMAWB');
        var fcCursor;

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
            var divObj = document.getElementById("lstConsigneeNameDiv")

            hiddenObj.value = orgNum;
            infoObj.value = getOrganizationInfo(orgNum);
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
            divObj.style.height = "0px";
            lstNotifyNameChange(orgNum, orgName);
            document.getElementById("txtBrokerInfo").value = getDefaultBrokerInfo(orgNum);
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

        function lstBrokerNameChange(orgNum, orgName) {
            var hiddenObj = document.getElementById("hBrokerAcct");
            var infoObj = document.getElementById("txtBrokerInfo");
            var txtObj = document.getElementById("lstBrokerName");
            var divObj = document.getElementById("lstBrokerNameDiv")

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

            return xmlHTTP.responseText;
        }

        function getDefaultBrokerInfo(orgNum) {
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

            var url = "/ASP/ajaxFunctions/ajax_get_org_address_info.asp?type=DB&org=" + orgNum;

            xmlHTTP.open("GET", url, false);
            xmlHTTP.send();

            return xmlHTTP.responseText;
        }

        function show_tip() { }

        function chkPrintInvoiceChange() {
            obj = document.getElementById("hDoInvoice");
            if (obj.value == "yes") {
                document.getElementById("hDoInvoice").value = "no"
            } else {
                document.getElementById("hDoInvoice").value = "yes"
            }
        }

        function calculateTotalFc() {
            var chargeable = document.getElementById("txtChgWT").value;
            var CSRate = document.getElementById("txtCSRate").value;
            var TotalFC = document.getElementById("txtTotalFC").value;

            CSRate = parseFloat(CSRate);
            if ((CSRate * 0) != 0) {
                alert("Please enter a number for rate");
                document.getElementById("txtCSRate").value = "0";
                document.getElementById("txtTotalFC").value = "0";
                document.getElementById("txtCSRate").focus();
                return;
            }
            chargeable = parseFloat(chargeable);
            if ((chargeable * 0) != 0) {
                alert("Please enter a number for Chargeable Weight");
                document.getElementById("txtChgWT").value = "0";
                document.getElementById("txtTotalFC").value = "0";
                document.getElementById("txtChgWT").focus();
                return;
            }
            document.getElementById("txtTotalFC").value = chargeable * CSRate;
            document.getElementById("txtTotalFC").focus();
        }

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

        function processReqChange() {
            if (req.readyState == 4) {
                if (req.status == 200) {
                    var result = req.responseText

                }
                else {
                    alert("There was a problem retrieving the rate for the company specified :\n" + req.statusText);
                }
            }
        }

        function SyncFC(obj, index) {
            if (index == fcCursor) {
            }
            else {
            }
        }

        function setFCCursor(i) {
            fcCursor = i
        }

        function textLimit(field, maxlen) {
            if (field.value.length > maxlen) {
                field.value = field.value.substring(0, maxlen);
                alert('Your input has exceeded the maximum character!');
            }
        }

        window.onload = function () {
            if (getParameterByName("HBOL") != null && getParameterByName("HBOL") != "" && getParameterByName("HBOL") != undefined) {
                if (document.getElementById("txtHAWB").value == "") {

                    document.getElementById("SearchType").value = "houseNo";
                    selectSearchType();

                    document.getElementById("txtFindByHAWB").value = getParameterByName("HBOL");

                    GetHAWBList('HAWB');
                }
            }
            function getParameterByName(name) {
                name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
                var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
                return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
            }
            //FindByInvoiceNo('txtFindIV')
        };
    </script>
    <script type="text/jscript" src='../Include/iMoonCombo.js'></script>
    <script type="text/jscript" src="/ASP/ajaxFunctions/ajax_ig_call_db.js"></script>

    <script type="text/javascript">
        var dPortCode = "";
        var aPortCode = "";
        var PortCode = "";

        function doDepPortChange(obj) {
            dPortCode = obj.children[obj.options.selectedIndex].text;
            document.form1.hDepText.value = dPortCode;
        }
        function doArrPortChange(obj) {
            aPortCode = obj.children[obj.options.selectedIndex].text;
            document.form1.hArrText.value = aPortCode;
        }
    function CofirmDFA(){
        if (confrim("Check Default Ocean Freight Charge is set. \r\nDefault Ocean Freight Charge Item is not set in your Company Profile, would you like to set it before you move on?")) {
            parent.window.location.href = "../../SiteAdmin/CompanyInformation/"
                + encodeURIComponent("DOF=Y");
        }
            //window.location =  "/ASP/SITE_ADMIN/co_config.asp?DOF=Y";
    }
    </script>

</head>
<!--  #INCLUDE FILE="../include/header.asp" -->
     <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_Util_Ver_2.inc" -->
<%
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'Arrival Notice creates Invoice and Hawbs 
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
DIM aBrokerInfo(2), aBrokerAcct(2048),aBrokerName(2048)
DIM bIndex,vBrokerName

Public DeleteHAWB
Public vSavingCondition,vFCDescription
Public vDefaultOF_Revenue, vDefaultOF_Desc

Public FROM_EDIT,vSaveAsNew,CurrentHAWB,vCreateNew
Public df_item_no, df_item_name, df_item_desc,  FCItemIndex
Public  vSubMAWB,vVessel,vVoyageNo,vFileNo
Public AgentProfit,SaleTax,EntryNo,EntryDate
Public vProcessDT, vETD2, vETA2, vPCS, vUOM, vGrossWT, vChgWT, vScale1, vScale2, vDesc1, vDesc3, vRemarks
Public vContainerLocation, vDestination, vFreeDate, vGODate, tITNumber, vITNumber, tITDate 
Public vITDate, tITEntryPort, vITEntryPort, tCargoLocation, vCargoLocation
Public IsCollect
Public aOrigAmt(128)
Public vOFRate, vOFTotal
Public vPostBack

Public vDefault_SalesRep	
vDefault_SalesRep=session_user_lname	
Public totalOC
Public vAR
Public rs,SQL,rs1, rs2
Public vMAWB,vAgentName,vFileNum,vCarrier,vPieces,vAgentDebitNo,vAgentDebitAmt
Public vFLTNo,vETD,vETA,vGrossWeight,vChargeableWeight
Public vHAWB,vShipperInfo,vConsigneeInfo,vNotifyInfo
Public NoItem,aItemNo(1024),aItemName(1024),aChargeDesc(1024),aAmount(1024)
Public NoCostItem,aCostItemNo(1024),aCostItemName(1024),aCostDesc(1024),aRefNo(1024),aCost(1024),aRealCost(1024),igDefaultItem(1024),igDefaultCostItem(1024)
Public aAR(1024),aRevenue(1024),aExpense(1024)
Public aVendor(1024)
'/////////////////// added by iMoon for AP Lock Handle
Public  aAPLock(1024)
'///////////////////
Public flag
Public vDefaultOF
Public indexDOF
Public cusSellRate
Public vTotalOF
Public InvoiceExist
Public OFexistsAlready
Public vTotalOverWrite
Public vSalesPerson
Public aSRName(1000)
Public SRIndex, ItemIndex, CostItemIndex, ARIndex, aIndex, cIndex, sIndex, vIndex, nIndex, tIndex
Public cName, cAcct,  cAddress,  cCity,cState, cZip, cCountry, cPhone, cFax, IsAgent, IsShipper, IsConsignee, IsVendor, IsTrucker, cBrokerInfo, IsGOV, IsSpc
Public AddressInfo, Branch
Public vCustomerRef, vPreparedBy, vBrokerInfo, vAgentELTAcct
Public TranNo, PrintOK
Public iType, Edit, Save, AddItem, AddCostItem, DeleteItem, DeleteCost,vAgentOrgAcct, vSec, vOpenPageItemNo, tNo
Public aAgentName(1024),aAgentInfo(2),aAgentAcct(4096)
Public aShipperName(4096),aShipperInfo(2),aShipperAcct(4096)
Public aConsigneeName(4096),aConsigneeInfo(2),aConsigneeAcct(4096),aBrokerInfoForConsignee(4096)
Public aNotifyName(4096),aNotifyInfo(2),aNotifyAcct(4096)
Public aVendorName(4096),aVendorInfo(2),aVendorAcct(4096)

Dim aVendorArrayList

Public vConsigneeAcct, vNotifyAcct, vBrokerAcct, InvoiceNo,  vShipperAcct 
Public DefaultCostItem(1024),DefaultCostItemNo(1024),DefaultExpense(1024),DefaultCostItemDesc(1024),aCostItemDesc(1024)
Public aCostItemUnitPrice(1024) '// Unit_Price by ig 10/21/2006
Public AF, OF, GlType, AR, vTerm, vPickupDate, vDeliveryPlace
Public vShipperName, vConsigneeName, vNotifyName, ConsigneeExist, vSubMAWB2
Public DefaultItem(1024),DefaultItemNo(1024),DefaultRevenue(1024),DefaultItemDesc(1024),aItemDesc(1024)
Public aItemUnitPrice(1024) '// Unit_Price by ig 10/21/2006
Public DefaultAR(8),DefaultARName(8)
Public vTotalCost, vSubTotal, vTotalAmount
Public aOrigCost(128),OrigTotalCost
Public aMAWB
Public aMAWBInfo
Public isAddFC
Public vAuth

Public vNew, doInvoice
Public NewHAWB, Search
Public OriginalHAWB
'// by iMoon Dec-2-2006
Public vDesc2,vDesc4,vDesc5

'// by joon Dec-5-2006
Public vLock,vReadOnlyInvoice,vReadOnlyInvoice_d,vApLock,vArApLock,vArLock

eltConn.BeginTrans()

vUOM = GetSQLResult("SELECT uom_qty FROM user_profile WHERE elt_account_number=" & elt_account_number, "uom_qty")
vScale1 = GetSQLResult("SELECT uom FROM user_profile WHERE elt_account_number=" & elt_account_number, "uom")
vScale2 = vScale1

vArApLock = "Visible"  '// Hidden when locked
vReadOnlyInvoice = ""   '// readyonly when searched
vReadOnlyInvoice_d = ""
vApLock = false
vArLock = false

'--------------------------------------Main Procedure------------------------------------------------------'
Call ASSIGN_INITAL_VALUES_TO_VARIABLES
Call CHECK_DEFAULT_FREIGT_CHARGE_ACCOUNT
Call LOAD_LIST_BOXES_FROM_DB_TO_SCREEN
Call GET_REQUEST_QUERY_STRINGS  

		'// refresh handling by iMoon
		if Save="yes" and ( tNo <> TranNo ) then
			   call GET_REQUEST_FROM_SCREEN
			   Search="yes"
			   Save=""
		end if

if Edit="yes" then   
    Call GET_MAWB_FROM_DB  
    Call GET_HAWB_FROM_DB 
    '// by joon Dec-5-2006
    Call CHECK_INVOICE_LOCK
    Call KEEP_COST_AMOUNT_COUNT 
    FROM_EDIT="Y"
end if 

if NewHAWB="yes" then 
    vSec=1
    Call GET_MAWB_FROM_DB 
    Call KEEP_COST_AMOUNT_COUNT
end if 

if Search="yes" then  
    SQL = "SELECT * FROM import_hawb WHERE iType='O' AND CAST(invoice_no AS NVARCHAR)=N'" _
        & InvoiceNo & "' AND elt_account_number=" & elt_account_number
    If Not IsDataExist(SQL) Then
        eltConn.CommitTrans()
        eltConn.Close()
        Set eltConn = Nothing
        Response.Write("<script>alert('No result found'); window.location.href='./arrival_notice.asp';</script>")
        Response.End
    End If
    vReadOnlyInvoice = "readonly"
    vReadOnlyInvoice_d = "d_"
    FROM_EDIT="Y"
    if vSec="" then vSec="1"
    Call GET_MAWB_FROM_DB 
    Call GET_HAWB_FROM_DB 
    Call CHECK_INVOICE_LOCK
    Call KEEP_COST_AMOUNT_COUNT   
end if 

if AddItem="yes"  then
    Call GET_REQUEST_FROM_SCREEN 
    Call KEEP_COST_AMOUNT_COUNT
    Call CHECK_INVOICE_LOCK 
end if 

if AddCostItem="yes"  then
  Call GET_REQUEST_FROM_SCREEN
  Call KEEP_COST_AMOUNT_COUNT
  Call CHECK_INVOICE_LOCK
end if 

if DeleteItem="yes" then
   Call GET_REQUEST_FROM_SCREEN
   Call DELETE_CHARGE_ITEM_FROM_DB_AND_LIST	 
   Call KEEP_COST_AMOUNT_COUNT
   Call CHECK_INVOICE_LOCK
end if	

if DeleteCost="yes" then
   Call GET_REQUEST_FROM_SCREEN
   Call DELETE_COST_ITEM_FROM_DB_AND_LIST
   Call KEEP_COST_AMOUNT_COUNT
   Call CHECK_INVOICE_LOCK  
end if

if DeleteHAWB="yes" then 
Call GET_REQUEST_FROM_SCREEN

   if not InvoiceNo="" then 
        Call DELETE_ONE_INVOICE(InvoiceNo)
        Call DELETE_HAWB
        InvoiceNo=""
        vHAWB=""   
        Call RESET_HAWB
        Call GET_MAWB_FROM_DB 
   end if
end if 

if Save="yes" then 

    Call GET_REQUEST_FROM_SCREEN  
    CALL CALCULATE_TOTAL_CHARGE_AND_TOTAL_COST    
    SAVING_CONDITION=vSavingCondition   
  
    if tNo=TranNo then  
    
        if SAVING_CONDITION ="CREATE_NEW" then 
         
             if CREATE_AND_SAVE_NEW_INVOICE_INTO_DB = true then 
                Call SAVE_CHARGE_ITEMS_TO_INVOICE_CHARGE_ITEM_TABLE		
                Call SAVE_COST_ITEMS_TO_INVOICE_COST_ITEM_TABLE
                Call CREATE_NEW_HAWB_TO_DB	
                Call PERFORM_ACCOUNTING_TASKS 
                Call SAVE_BILL_DETAIL_TO_BILL_DETAIL_TABLE
                Call UPDATE_CARGO_TRACKING_TABLE_FOR_SHIPPING_REQUEST
                 else 
                response.Write("<script language='javascript'>alert('DB was busy. Please save again');</script>")
            end if 
                
        elseif SAVING_CONDITION = "OVER_WRITE_WITH_NEW_INVOICE" Then
        
            if CREATE_AND_SAVE_NEW_INVOICE_INTO_DB = true then 
				Call SAVE_CHARGE_ITEMS_TO_INVOICE_CHARGE_ITEM_TABLE		
				Call SAVE_COST_ITEMS_TO_INVOICE_COST_ITEM_TABLE
                'Call CREATE_NEW_HAWB_TO_DB
                Call SAVE_BILL_DETAIL_TO_BILL_DETAIL_TABLE 
                Call PERFORM_ACCOUNTING_TASKS 
                Call UPDATE_CARGO_TRACKING_TABLE_FOR_SHIPPING_REQUEST
                
                UPDATE_OLD_HAWB_TO_DB
            else 
                response.Write("<script language='javascript'>alert('DB was busy. Please save again');</script>")
            end if 
            
        elseif SAVING_CONDITION ="OVER_WRITE" then 
        
            Call UPDATE_AND_SAVE_THIS_INVOICE_IN_DB  
            Call SAVE_CHARGE_ITEMS_TO_INVOICE_CHARGE_ITEM_TABLE		
            Call SAVE_COST_ITEMS_TO_INVOICE_COST_ITEM_TABLE           
            Call UPDATE_OLD_HAWB_TO_DB            
            Call PERFORM_ACCOUNTING_TASKS
            Call SAVE_BILL_DETAIL_TO_BILL_DETAIL_TABLE 
            Call UPDATE_CARGO_TRACKING_TABLE_FOR_SHIPPING_REQUEST 
                                   
        elseif SAVING_CONDITION ="OVER_WRITE_WITH_NEW_HAWB_MAWB" then
        
            Call UPDATE_AND_SAVE_THIS_INVOICE_IN_DB 
            Call SAVE_CHARGE_ITEMS_TO_INVOICE_CHARGE_ITEM_TABLE		
            Call SAVE_COST_ITEMS_TO_INVOICE_COST_ITEM_TABLE            
            Call UPDATE_OLD_HAWB_TO_DB            
            Call PERFORM_ACCOUNTING_TASKS
            Call SAVE_BILL_DETAIL_TO_BILL_DETAIL_TABLE 
            Call UPDATE_CARGO_TRACKING_TABLE_FOR_SHIPPING_REQUEST 
                                    
            
        end if       
	end if	
    Call KEEP_COST_AMOUNT_COUNT
    FROM_EDIT="Y"
    Call CHECK_INVOICE_LOCK
end if

CALL CALCULATE_TOTAL_CHARGE_AND_TOTAL_COST
if IsCollect="Y" then 
 	vTotalAmount= cdbl(vOFTotal) + vTotalAmount
end if 
CALL SetPostBack

OriginalHAWB = SESSION("hawb")
CALL GET_PORT_LIST

'--------------------------------------End of Main Procedure--------------------------------------------'

eltConn.CommitTrans()

%>
<!--  #INCLUDE FILE="../include/aspFunctions_import.inc" -->
<%
sub DELETE_ONE_INVOICE( invoice_no )

    DIM tmpMawb,tmpHawb,i,maxInvoice,iCnt
    Set tmpHawb = Server.CreateObject("System.Collections.ArrayList")
    Set rs=Server.CreateObject("ADODB.Recordset")	

	SQL = "select mawb_num from invoice where elt_account_number =" & elt_account_number & " and invoice_no =" & invoice_no
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing

	if NOT rs.eof and NOT rs.bof then

'// gather invoice mawb information 
		tmpMawb = rs("mawb_num")
		rs.Close

		SQL = "select isnull(count(*),0) as icnt from invoice_queue where elt_account_number = " & elt_account_number & " and mawb_num =N'" & tmpMawb & "'"
		
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing
		if NOT rs.eof and NOT rs.bof then
			iCnt = clng(rs("icnt"))
		end if
		rs.Close
	else
		rs.Close
		tmpMawb = "no_mawb"
	end if

'// gather invoice hawb information 
		SQL = "select hawb_num from invoice_hawb where elt_account_number = " & elt_account_number & " and invoice_no =" & invoice_no
		
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing
		do while not rs.eof
			tmpHawb.add rs("hawb_num").value
			rs.MoveNext
		loop
		rs.Close

'// delete invoice
		SQL = "delete invoice where elt_account_number = " & elt_account_number & " and invoice_no =" & invoice_no
		
		eltConn.execute (SQL)

		SQL = "delete invoice_charge_item where elt_account_number = " & elt_account_number & " and invoice_no =" & invoice_no
		
		eltConn.execute (SQL)

		SQL = "delete invoice_cost_item where elt_account_number = " & elt_account_number & " and invoice_no =" & invoice_no
		
		eltConn.execute (SQL)

		SQL = "delete invoice_hawb where elt_account_number = " & elt_account_number & " and invoice_no =" & invoice_no
		
		eltConn.execute (SQL)

		SQL = "delete bill_detail where elt_account_number = " & elt_account_number & " and invoice_no =" & invoice_no
		
		eltConn.execute (SQL)

		SQL = "delete all_accounts_journal where elt_account_number = " & elt_account_number & " and tran_num =N'" & invoice_no & "'"
		
		eltConn.execute (SQL)

		SQL = "delete all_accounts_journal where elt_account_number = " & elt_account_number & " and customer_number in ( select customer_number from all_accounts_journal where elt_account_number =" & elt_account_number & " group by customer_number  having count(customer_number) = 1 ) and tran_type = 'INIT'"
		
		eltConn.execute (SQL)

		if iCnt > 1 then
			for i=0 To tmpHawb.count-1 
				SQL = "update invoice_queue set invoiced = 'N', outqueue_date=''  where elt_account_number = " & elt_account_number & " and hawb_num =N'" & tmpHawb(i) & "' and mawb_num=N'"& tmpMawb & "'"
				
				eltConn.execute (SQL)
			next
		else
			SQL = "update invoice_queue set invoiced = 'N', outqueue_date=''  where elt_account_number = " & elt_account_number & " and mawb_num=N'"& tmpMawb & "'"
			
			eltConn.execute (SQL)
		end if

		for i=0 To tmpHAWB.count-1 
			SQL = "update import_hawb set invoice_no = 0 where elt_account_number = " & elt_account_number & " and hawb_num =N'" & tmpHAWB(i) & "' and mawb_num=N'"& tmpMawb & "'"
			
			eltConn.execute (SQL)
		next

    Set hawb = nothing
    Set rs = nothing
end sub

Sub RESET_HAWB
    vSalesPerson=""
    vOFRate=0
    vOFTotal=0    
    vSubHAWB=""
    vHAWB=""
    vAgentOrgAcct=0
    vAgentELTAcct=0
    InvoiceNo=""
    vSec=1
    vShipperInfo=""
    vShipperName=""
    vShipperAcct=0
    vShipperName = ""
    vConsigneeName = ""
    vNotifyName = ""
    vConsigneeInfo=""
    vConsigneeAcct=0
    vNotifyInfo=""
    vNotifyName=""
    vNotifyAcct=0
    vPreparedBy=""
    vCustomerRef=""
    vPickupDate=""
	'-------------------
    vBrokerInfo=""
    vBrokerAcct=0
	vBrokerName=""
	'--------------------
    vDeliveryPlace=""
    vProcessDT=""	
    vETD2=""
    vETA2=""
    vContainerLocation=""
    vDestination=""
    vFreeDate=""
    vGODate=""
    vITNumber=""
    vITDate=""
    vITEntryPort=""
    vCargoLocation=""
    vPCS=""
    vUOM=""
    vGrossWT=""
    vChgWT=""
    vScale1=""
    vScale2=""
    vDesc1=""
    vDesc3=""
    vRemarks=""
    vTerm=""
    is_default_rate=""
    vSalesPerson=""
    IsCollect="Y"
    NoItem=4
    vVessel=""
    vETD=""
    vETA=""
    vCargoLocation=""
    vITNumber=""
    vITDate= ""
    vITEntryPort=""
    vDeliveryPlace=""
    vFreeDate=""
    vSubMAWB=""
    vHAWB=""  
    NoCostItem = 4
    
   for i=0 to 255
        aItemNo(i)=empty
        aItemName(i)=empty
        aChargeDesc(i)=empty
        aAmount(i)=empty
        aCostItemNo(i)=empty
	    aCostDesc(i)=empty
	    aRefNo(i)=empty
	    aRealCost(i)=empty
	    aVendor(i)=empty
		aAPLock(i)=empty				
  next 
   
End Sub 

Sub DELETE_HAWB
    Dim rs
    Set rs=Server.CreateObject("ADODB.Recordset")
	    dSQL= "delete from import_hawb where elt_account_number = " & elt_account_number & " and  iType='O' and mawb_num=N'" & vMAWB & "' and hawb_num=N'" & vHAWB & "' and sec=" & vSec
	    rs.Open dSQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
    Set rs=Nothing    
    Session("hawb")=""
    Session("InvoiceNo")=""
End Sub		

Function HAS_INVOICE(vMAWB,vHAWB)
    SQL=""
    Dim rs 
    Set rs=Server.CreateObject("ADODB.Recordset")
    SQL="select invoice_no from import_hawb where elt_account_number=" & elt_account_number & " and iType='O' and hawb_num=N'" & vHAWB & "' and mawb_num=N'" & vMAWB &"'"
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
    if Not rs.EOF then
       CheckIV=rs("invoice_no")
        HAS_INVOICE=true
    else
        'response.Write "---no invoice found---"
        CheckIV=""
        HAS_INVOICE=false
    end if 
    Set rs=Nothing 
End Function

Function IsPostBack
    Dim result
        if vPostBack = "true" then 
            result= true
        else           
           result= false
        end if  
    IsPostBack= result
End Function

Sub SetPostBack
    if vPostBack="" then vPostBack="true"
End Sub 

'// By Joon on Dec-05-2006 Checks if invoice is locked or not //////////////////////////////////
SUB CHECK_INVOICE_LOCK

    If Not IsNull(InvoiceNo) And Not Trim(InvoiceNo)="" Then
        Dim rs
        Set rs=Server.CreateObject("ADODB.Recordset") 
        SQL = "SELECT lock_ar,lock_ap FROM invoice WHERE elt_account_number=" & Trim(elt_account_number) _
            & " AND invoice_no=" &  Trim(InvoiceNo)
        
        rs.CursorLocation = adUseClient
        rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
        Set rs.activeConnection = Nothing
        
        If Not rs.EOF And Not rs.BOF then
            If rs("lock_ar").value="Y" Or rs("lock_ap").value="Y" Then
                vArApLock = "Hidden"
            End If
			
            If rs("lock_ar").value="Y" Then 
                vArLock = true
            End If
			
            If rs("lock_ap").value="Y" Then 
                vApLock = true
            End If
			
            rs.close
            Set rs=Nothing
           
        End If 
        
    End If
End SUB
'/////////////////////////////////////////////////////////////////////////////////////////////////

Sub KEEP_COST_AMOUNT_COUNT
    if(NoItem="")then NoItem="0"
    NoItem=cInt(NoItem)
    if(NoItem < 4) then NoItem=4 
    if(NoCostItem="") then NoCostItem="0"
    NoCostItem=cInt(NoCostItem)
    if(NoCostItem<4 ) then NoCostItem=4
End Sub 

Sub ASSIGN_INITAL_VALUES_TO_VARIABLES
    Dim rs
    vTotalAmount=0
    
    IsCollect="Y"
    vCreateNew="N"
    vSaveAsNew="N"
	vOFRate=0
	vOFTotal=0
    Set rs=Server.CreateObject("ADODB.Recordset")
  
    FCItemIndex=-1
    NoItem=4
    NoCostItem=4
    OFexistsAlready=false
    vNew=false
   
    TranNo=Session("OIANTranNo")
    if TranNo="" then
         Session("OIANTranNo")=0
         TranNo=0
    end if
    SQL= "select  user_lname, user_fname from users where elt_account_number = " & elt_account_number & " and login_name =N'" &login_name & "'"
    
    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
    if not rs.EOF then
       
        vPreparedBy= FixNull(rs("user_fname"))&" "&FixNull(rs("user_lname"))
    end if 
    rs.close
    Set rs=Nothing
 
    
End Sub 

Public Function FixNull(ByVal dbvalue) 
        If isnull(dbvalue) Then
            FixNull= ""
        Else
            
            FixNull= dbvalue
        End If
End Function

Sub LOAD_LIST_BOXES_FROM_DB_TO_SCREEN
    Call GET_SALES_PERSONS_FROM_USERS_TABLE
    Call GET_MAWB_LIST_FROM_DB
    Call GET_CHARGE_ITEM_LIST_FROM_DB
    Call GET_COST_ITEM_LIST_FROM_DB
    Call GET_ALL_ACCOUNT_RECEIVABLE
    Call get_vendor_list
End Sub 

Sub GET_REQUEST_QUERY_STRINGS
    DeleteHAWB=Request.QueryString("DeleteHAWB")
    vAuth=Request.QueryString("Auth")
    vCreateNew=Request.QueryString("CreateNew")
    
    if vCreateNew=Empty or vCreateNew="" then vCreateNew="N"
    
    NewHAWB=Request("NewHAWB")
    Search=Request("Search")
    doInvoice=Request("hDoInvoice")
   
    iType=Request.QueryString("iType")
    Edit=Request.QueryString("Edit")
    Save=Request.QueryString("Save")
    AddItem=Request.QueryString("AddItem")
    AddCostItem=Request.QueryString("AddCostItem")
    DeleteItem=Request.QueryString("Delete")
    DeleteCost=Request.QueryString("DeleteCost")
    
    vHAWB=Request.QueryString("HAWB")
    vMAWB=Request.QueryString("MAWB")
    '------------------------------for IsPostBack Only
    vPostBack=Request("hPostBack")  
    if IsPostBack = false then 
        Session("hawb")= vHAWB ' Session("hawb") will be set again when it looks up one in DB.
        Session("mawb")= vMAWB
    end if 
    '---------------------------------------------------
    
    
    vAgentOrgAcct=Request.QueryString("AgentOrgAcct")
    vSec=Request.QueryString("Sec")
    
    if vSec="" then vSec="1"
    Session("vSec")=vSec
    
   
    vOpenPageItemNo=Request.QueryString("ItemNo")
    if vOpenPageItemNo="" then vOpenPageItemNo=Request("hItemNo")

    vDepCode=Request.QueryString("DepCode")
    vArrCode=Request.QueryString("ArrCode")

    tNo=Request.QueryString("tNo")
    if tNO="" then
	    tNO=0
    else
	    tNo=cLng(tNo)
    end if
    PrintOK=Request.QueryString("Print")
    InvoiceNo=Request.QueryString("InvoiceNO")
    InvoiceNo=FixNull(InvoiceNo)
    
  
    isAddFC=request.QueryString("isAddFC")
    vTotalOF=Request.QueryString("TotalFC")
    if vTotalOF=""  then vTotalOF="0"
    '---------------------------------------------------(11/27/06)
    NoItem=request.QueryString("NoItem")  
	NoCostItem=request.QueryString("NoCostItem")
	
	if(NoItem="")then NoItem="0"
    NoItem=cInt(NoItem)
    if(NoItem < 4) then NoItem=4 
    if(NoCostItem="") then NoCostItem="0"
    NoCostItem=cInt(NoCostItem)
    if(NoCostItem<4 ) then NoCostItem=4   
    
    If (Edit = "yes" Or Search = "yes") And vMAWB <> "" Then
        Dim vEDTSec
        SQL = "SELECT max(sec) FROM import_hawb WHERE mawb_num=N'" & vMAWB _
            & "' AND hawb_num=N'" & vHAWB & "' AND agent_elt_acct<>0 AND elt_account_number=" _
            & elt_account_number & " AND processed='N'"

        vEDTSec = GetSQLResult(SQL, Null)
        If vEDTSec <> "" Then
            Response.Redirect("ocean_import2B.asp?HAWB=" & Server.URLEncode(vHAWB) & "&MAWB=" & Server.URLEncode(vMAWB) & "&SEC=" & vEDTSec)
        End If
    End If
End Sub 

Sub PERFORM_ACCOUNTING_TASKS 
    Dim rs
    Set rs=Server.CreateObject("ADODB.Recordset")
    
    SQL= "delete from all_accounts_journal where elt_account_number = " & elt_account_number & " and tran_type='ARN' and tran_num=" & InvoiceNo
    
    eltConn.Execute SQL
    
    '// insert to all_accounts_journal for A/R
    SQL= "select max(tran_seq_num) as SeqNo from all_accounts_journal where elt_account_number = " & elt_account_number
    
    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
    If Not rs.EOF And IsNull(rs("SeqNo"))=False Then
	    SeqNo = CLng(rs("SeqNo")) + 1
    Else
	    SeqNo=1
    End If
    rs.Close
    
    '// insert an init record in all_accounts_journal for the AR and for this customer if it is not exist
    SQL= "select * from all_accounts_journal where elt_account_number = " & elt_account_number & " and gl_account_number=" & vAR & " and tran_type='INIT' and customer_number=" & vConsigneeAcct
    
    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
    if rs.EOF then
	    rs.AddNew
	    rs("elt_account_number")=elt_account_number
	    rs("gl_account_number")=vAR
	    rs("gl_account_name")=GetGLDesc(vAR)
	    rs("tran_seq_num")=SeqNo
	    SeqNo=SeqNo+1
	    rs("tran_type")="INIT"
	    rs("tran_date")=Now
	    rs("air_ocean")="O"
	    rs("Customer_Number")=vConsigneeAcct
	    rs("Customer_Name")=vConsigneeName
	    rs("debit_amount")=0
	    rs("credit_amount")=0
	    rs("balance")=0
	    rs("previous_balance")=0
	    rs("gl_balance")=0
	    rs("gl_previous_balance")=0
	    rs.Update
    end if
    rs.Close

    '// insert transaction data to all_accounts_journal
    '// by iMoon 3/4/2007
		SQL= "select * from all_accounts_journal where elt_account_number = " & elt_account_number & " and tran_seq_num=" & SeqNo
		
		rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
		if rs.EOF then
			rs.AddNew
			rs("elt_account_number")=elt_account_number
			rs("gl_account_number")=vAR
			rs("gl_account_name")=GetGLDesc(vAR)
			rs("tran_seq_num")=SeqNo
			SeqNo=SeqNo+1
			rs("tran_type")="ARN"
			rs("tran_num")=InvoiceNo
			rs("tran_date")=vProcessDT
			rs("air_ocean")="O"
			rs("Customer_Number")=vConsigneeAcct
			rs("Customer_Name")=vConsigneeName
			rs("memo")=MID(vRemarks,1,256)
			rs("split")=GetGLDesc(aRevenue(0))
			if isnull(vTotalAmount) Or vTotalAmount="" Then vTotalAmount=0
			if IsCollect="Y" then 
				rs("debit_amount")=vTotalAmount+ vOFTotal
			else 
				rs("debit_amount")=vTotalAmount
			end if 
			rs("credit_amount")=0
			rs("balance")=cuBalance
			rs("previous_balance")=cuPBalance
			rs("gl_balance")=arBalance
			rs("gl_previous_balance")=arPBalance
			rs.Update
		End if
		rs.Close    

    aRevenue(NoItem)=vDefaultOF_Revenue
    aAmount(NoItem)=vOFTotal
    aItemNo(NoItem)=vDefaultOF
    lastIndex=NoItem

	DIM flag_c
	flag_c = true
	
        for i=0 to lastIndex
	    if NOT aRevenue(i) = "" then 

			if NOT vDefaultOF_Revenue = "" then
				if cLng(aItemNo(i))=  cLng(vDefaultOF) then 
					 if IsCollect <> "Y" then
						flag_c = false
					 end if
				end if
			end if
		
			if flag_c then			
				SQL= "select * from all_accounts_journal where elt_account_number = " & elt_account_number & " and tran_seq_num=" & SeqNo
				
				rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
				if rs.EOF then
					rs.AddNew
					rs("elt_account_number")=elt_account_number
					rs("gl_account_number")=aRevenue(i)
					rs("gl_account_name")=GetGLDesc(aRevenue(i))
					rs("tran_seq_num")=SeqNo
					SeqNo=SeqNo+1
					rs("tran_type")="ARN"
					rs("tran_num")=InvoiceNo
					rs("tran_date")=vProcessDT
					rs("air_ocean")="O"
					rs("Customer_Number")=vConsigneeAcct
					rs("Customer_Name")=vConsigneeName
					rs("split")=GetGLDesc(vAR)
					rs("debit_amount")=0
					rs("credit_amount")=-aAmount(i)
					rs("balance")=cuBalance
					rs("previous_balance")=cuPBalance
					rs("gl_balance")=rBalance
					rs("gl_previous_balance")=rPBalance
					rs.Update
				End if
	            rs.Close
	        end if 	        					
		   flag_c = true		
		 end if 
        next
    
    Set rs=Nothing
End Sub 
 
 
 Sub UPDATE_AND_SAVE_THIS_INVOICE_IN_DB	

	call update_customer_payment(InvoiceNo)
    
    Dim rs
    Set rs=Server.CreateObject("ADODB.Recordset")
    
    SQL= "select * from Invoice where elt_account_number = " & elt_account_number & " and invoice_no=" & InvoiceNo
    
    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
    If Not rs.EOF Then			

        Session("InvoiceNo") = InvoiceNo
        Session("OIANTranNo")=Clng(Session("OIANTranNo"))+1
        TranNo=Clng(Session("OIANTranNo"))
        rs("import_export")="I"
        rs("air_ocean")="O"
        rs("term_curr")=vTerm
        if not vProcessDT="" then
            rs("Invoice_Date")=vProcessDT
        end if

		rs("ref_no")=vCustomerRef  
		rs("ref_no_Our")=vFileNo 
        rs("Customer_Info")=vConsigneeInfo
        if not TotalPieces="" then rs("Total_Pieces")=TotalPieces
        if not TotalGrossWeight="" then rs("Total_Gross_Weight")=TotalGrossWeight
        rs("Remarks")=mid(vRemarks,1,256)
        rs("Description")=mid(vDesc3,1,256)
        rs("origin")=vDepPort
        rs("dest")=vArrPort
        rs("total_pieces")=vPCS
        rs("total_gross_weight")=vGrossWT
        rs("total_charge_weight")=vChgWT
        rs("Customer_Number")=vConsigneeAcct
        rs("Customer_Name")=vConsigneeName
        rs("shipper")=vShipperName
        rs("consignee")=vConsigneeName
        rs("Entry_No")=EntryNo
        rs("Entry_Date")=EntryDate
        rs("Carrier")=vVessel&"/"&vVoyage
        rs("Arrival_Dept")=vETA & "--" & vETD
        rs("MAWB_NUM")=vMAWB		
        rs("HAWB_NUM")=vHAWB	
        rs("SubTotal")=vSubTotal

        if not vSubTotal="" and not isnull(vSubTotal) then
            rs("SubTotal")=vSubTotal            
        else 
            rs("SubTotal")=0
        end if 
            
        if not SaleTax="" and not isnull(SaleTax) then
            rs("Sale_Tax")=SaleTax            
        else 
            rs("Sale_Tax")=0
        end if        
            
        rs("Agent_Profit")=AgentProfit
            
        if not AgentProfit="" and not isnull(AgentProfit) then
            rs("Agent_Profit")=AgentProfit            
        else 
            rs("Agent_Profit")=0
        end if
        
        rs("accounts_receivable")=vAR
    
        if not vTotalAmount="" and not isnull(vTotalAmount) then 
            if IsCollect="Y" then 
                rs("amount_charged")=vTotalAmount+ vOFTotal
            else 
                rs("amount_charged")=vTotalAmount
            end if 
        else 
            rs("amount_charged")=0
        end if 
		   
        if not vTotalCost="" and not isnull(vTotalCost)then 
            rs("total_cost")=vTotalCost
        else 
            rs("total_cost")=0
        end if 

        DIM tmpBal
        tmpBal = 0

        if not vTotalAmount="" and not isnull(vTotalAmount) then
            if IsCollect="Y" then 
                if not isnull(rs("amount_paid")) then
                    tmpBal = (vTotalAmount+vOFTotal) -cDbl(rs("amount_paid"))
                else
					rs("amount_paid") = 0
					tmpBal = vTotalAmount+vOFTotal	
                end if			  
            else 
                if not isnull(rs("amount_paid")) then
                    tmpBal = (vTotalAmount) -cDbl(rs("amount_paid"))				
                else
                    rs("amount_paid") = 0
                    tmpBal = vTotalAmount+vOFTotal				
                end if			  
            end if 
        Else 
            rs("amount_paid") = 0
            tmpBal = 0				 
        End If 

        If vTotalAmount>0 then
            if not isnull(rs("pay_status")) then
                if not rs("pay_status") = "P" then
					rs("pay_status")="A"				
				end if
			else
				rs("pay_status")="A"
			end if
			if ( tmpBal <> 0 ) then
				rs("pay_status")="A"
			end if
		End if
        
        rs("balance")= tmpBal
        
        if cDbl(rs("balance")) < 0 then rs("balance") = 0
        
        rs.Update  			
    End If
    rs.Close           

    Session("mawb")= vMAWB
    Session("hawb")= vHAWB
    Set rs=Nothing

    call update_customer_credit( vConsigneeAcct, vConsigneeName )
End Sub 

Function CREATE_AND_SAVE_NEW_INVOICE_INTO_DB 
    Dim rs
    CREATE_AND_SAVE_NEW_INVOICE_INTO_DB=false
    Set rs=Server.CreateObject("ADODB.Recordset")
    Call GET_NEXT_INVOICE_NO_FROM_USER_PROFILE 
    
    Session("InvoiceNo") = InvoiceNo	     
    do while InvoiceExist="Y"
	    SQL= "select * from Invoice where elt_account_number = " & elt_account_number & " and invoice_no=" & InvoiceNo
	    
	    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	    If rs.EOF=true Then
		    rs.AddNew
		    rs("elt_account_number")=elt_account_number
		    rs("Invoice_No")=InvoiceNo
		    rs("invoice_type")="I"
		    OrigTotalAmt=0
		    InvoiceExist="N"
		     '// Avoid data saving when back or refresh	
            Session("InvoiceNo") = InvoiceNo
            Session("OIANTranNo")=Clng(Session("OIANTranNo"))+1
            TranNo=Clng(Session("OIANTranNo"))
            rs("import_export")="I"
            rs("air_ocean")="O"
            rs("term_curr")=vTerm
            if not vProcessDT="" then
                rs("Invoice_Date")=vProcessDT
            end if
            
		    rs("ref_no")=vCustomerRef
		    rs("ref_no_Our")=vFileNo
            rs("Customer_Info")=vConsigneeInfo
            if not TotalPieces="" then rs("Total_Pieces")=TotalPieces
            if not TotalGrossWeight="" then rs("Total_Gross_Weight")=TotalGrossWeight
			rs("Remarks")=mid(vRemarks,1,256)
			rs("Description")=mid(vDesc3,1,256)
            rs("origin")=vDepPort
            rs("dest")=vArrPort
            rs("total_pieces")=vPCS
            rs("total_gross_weight")=vGrossWT
            rs("total_charge_weight")=vChgWT
            rs("Customer_Number")=vConsigneeAcct
            rs("Customer_Name")=vConsigneeName
            rs("shipper")=vShipperName
            rs("consignee")=vConsigneeName
            rs("Entry_No")=EntryNo
            rs("Entry_Date")=EntryDate
            rs("Carrier")=vVessel&"/"&vVoyageNo
            rs("Arrival_Dept")=vETA & "--" & vETD
            rs("MAWB_NUM")=vMAWB		
            rs("HAWB_NUM")=vHAWB	
            rs("SubTotal")=vSubTotal
            if not vSubTotal="" and not isnull(vSubTotal) then
                rs("SubTotal")=vSubTotal            
            else 
             rs("SubTotal")=0
            end if 
            
            if not SaleTax="" and not isnull(SaleTax) then
                rs("Sale_Tax")=SaleTax            
            else 
             rs("Sale_Tax")=0
            end if        
            
            rs("Agent_Profit")=AgentProfit
            
            if not AgentProfit="" and not isnull(AgentProfit) then
                rs("Agent_Profit")=AgentProfit            
            else 
             rs("Agent_Profit")=0
            end if
            
            rs("accounts_receivable")=vAR
            
            if not vTotalAmount="" and not isnull(vTotalAmount) then 

                 if IsCollect="Y" then 
                   rs("amount_charged")=vTotalAmount+ vOFTotal
                 else 
                   rs("amount_charged")=vTotalAmount
                 end if 
            else 
             rs("amount_charged")=0
            end if 
           
            if not vTotalCost="" and not isnull(vTotalCost)then 
                 rs("total_cost")=vTotalCost
            else 
                 rs("total_cost")=0
            end  if 
             if not vTotalAmount="" and not isnull(vTotalAmount)then
                if IsCollect="Y" then 
                    rs("balance")=vTotalAmount+ vOFTotal
                else 
                    rs("balance")=vTotalAmount
                end if 
             else 
                 rs("balance")=0
             end if 
			 
            if vTotalAmount>0 then
                rs("pay_status")="A"
            end if
			
			if 	cDbl(rs("balance")) < 0 then rs("balance") = 0
			
            rs.Update
            rs.Close	
            '---------------double check creation----------------------
            SQL= "select invoice_no from Invoice where elt_account_number = " & elt_account_number & " and invoice_no=" & InvoiceNo
			rs.CursorLocation = adUseClient
			rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
			Set rs.activeConnection = Nothing
	        If rs.EOF=true Then
	            CREATE_AND_SAVE_NEW_INVOICE_INTO_DB=false
	        else
	         CREATE_AND_SAVE_NEW_INVOICE_INTO_DB=true
	         Call UPDATE_NEXT_INVOICE_NO_IN_USER_PROFILE_TABLE	
	        end if 
	        rs.close
	        '------------------------------------------------------------	        
            			
	    else
		    rs.close
		    InvoiceNo=InvoiceNo+1
	    end if
    loop
    Set rs=Nothing

	call update_customer_credit( vConsigneeAcct, vConsigneeName )

End Function

Sub GET_NEXT_INVOICE_NO_FROM_USER_PROFILE
    Dim rs
    Set rs=Server.CreateObject("ADODB.Recordset")
    
    SQL= "select next_invoice_no from user_profile where elt_account_number = " & elt_account_number
    
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
    
    If Not rs.EOF And IsNull(rs("next_invoice_no"))=False Then
	    InvoiceNo=cLng(rs("next_invoice_no"))+1
	    rs.close
    Else
		InvoiceNo=10001
	  	rs.close
    End If
    InvoiceExist="Y"
    Set rs=Nothing
End Sub 

Sub UPDATE_NEXT_INVOICE_NO_IN_USER_PROFILE_TABLE
    Dim rs1
    Set rs1=Server.CreateObject("ADODB.Recordset")
    SQL= "select next_invoice_no from user_profile where elt_account_number=" & elt_account_number
    
    rs1.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
    If Not rs1.EOF Then
	    rs1("next_invoice_no")=InvoiceNo
	    rs1.Update
    end if
    rs1.Close 
    Set rs1=Nothing 
End Sub 

Sub UPDATE_CARGO_TRACKING_TABLE_FOR_SHIPPING_REQUEST
    'update cargo tracking table for shipping request
    Dim rs
  
    Set rs=Server.CreateObject("ADODB.Recordset")
 
    SQL= "select consignee_import_acct,invoice_no,eta,cargo_location,it_number from cargo_tracking where import_agent_elt_acct = " & elt_account_number & " and hawb=N'" & vHAWB & "'"
    
    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
    Do While Not rs.EOF
	    if Not vConsigneeAcct="" And Not IsNull(vConsigneeAcct) then
		    rs("consignee_import_acct")=vConsigneeAcct
	    end if
	    rs("invoice_no")=InvoiceNo
	    rs("eta")=vETA
	    rs("cargo_location")=vCargoLocation
	    if Not vITNumber="" then
		    rs("it_number")=vITNumber
	    end if
	    rs.Update
	    rs.MoveNext
    Loop
    rs.Close
    Set rs=Nothing
  
End Sub 

Sub get_vendor_list()
    Dim tempTable,rs 
    Set rs=Server.CreateObject("ADODB.Recordset")
    Set aVendorArrayList = Server.CreateObject("System.Collections.ArrayList")
    Set tempTable = Server.CreateObject("System.Collections.HashTable")
    
    tempTable.Add "name", "Select One"
    tempTable.Add "acct", 0
    aVendorArrayList.Add tempTable
    
    SQL= "select org_account_number,DBA_NAME,is_vendor from organization where elt_account_number = " & elt_account_number _
        & " and (is_vendor = 'Y' or z_is_trucker = 'Y' or z_is_govt = 'Y' or z_is_special = 'Y' or z_is_broker='Y' or z_is_warehousing='Y') order by dba_name"
 	
 	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	
	Do While Not rs.EOF And Not rs.BOF
	    Set tempTable = Server.CreateObject("System.Collections.HashTable")
	    tempTable.Add "name", rs("DBA_NAME").value
	    tempTable.Add "acct", rs("org_account_number").value
	    aVendorArrayList.Add tempTable
	    rs.MoveNext()
	Loop
	rs.Close()
	
End Sub

Sub CREATE_NEW_HAWB_TO_DB
    Dim rs    
    Set rs=Server.CreateObject("ADODB.Recordset")   
    Call CALCULATE_OTHER_CHARGE_TOTAL     
   
    if ( Not vAgentOrgAcct="" And Not vSec="" And Not vMAWB="") Or (Not InvoiceNo="" And Not vAgentOrgAcct="") then

	    if Not vAgentOrgAcct="" And Not vSec="" then 
		    SQL= "select * from import_hawb where elt_account_number =" & elt_account_number & " and agent_org_acct=" & vAgentOrgAcct & " and hawb_num=N'" & vHAWB& "' and mawb_num=N'" & vMAWB & "' and sec=" & vSec
	    else
		    SQL= "select * from import_hawb where elt_account_number =" & elt_account_number & " and agent_org_acct=" & vAgentOrgAcct & " and invoice_no=" & InvoiceNo& " and mawb_num=N'" & vMAWB & "'"
	    end If
	    
	    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
    	
	    If rs.EOF Then
		    rs.AddNew
		    rs("elt_account_number")=elt_account_number
		    if Not vExportAgentELTAcct="" then
			    rs("agent_elt_acct")=vExportAgentELTAcct
		    end if
		    rs("agent_org_acct")=vAgentOrgAcct
		    rs("hawb_num")=vHAWB		    
		    rs("mawb_num")=vMAWB   		
		    rs("sec")=vSec           				
            rs("CreatedBy")=session_user_lname	
            rs("CreatedDate")=Now
            rs("SalesPerson")=vSalesPerson  
	        rs("invoice_no")=InvoiceNo
	        rs("process_dt")=vProcessDT
	        rs("iType")="O"
	        rs("processed")="Y"
	        rs("prepared_by")=vPreparedBy
	        rs("shipper_name")=vShipperName
	        rs("shipper_info")=vShipperInfo  
	        rs("shipper_acct")=vShipperAcct
	        rs("Sub_mawb2")=vSubMAWB2
	        rs("customer_ref")=vCustomerRef
	        rs("consignee_name")=vConsigneeName
	        rs("consignee_info")=vConsigneeInfo
	        rs("consignee_acct")=vConsigneeAcct
	        rs("delivery_place")=vDeliveryPlace
	        rs("destination")=vDestination
            rs("fc_rate")=vOFRate
            rs("fc_charge")=vOFTotal
            
            if IsCollect="N" then 
                rs("freight_collect")=0
            else
               rs("freight_collect")=vOFTotal
            end if 
              
            if IsCollect="" then IsCollect="N"        
	        rs("prepaid_collect")=IsCollect   

            rs("ModifiedBy")= session_user_lname
            rs("ModifiedDate")=Now
            rs("oc_collect")=totalOC 
	        if isDate(vPickupDate) then
		        rs("pickup_date") = vPickupDate			
	        else
		        rs("pickup_date") = null			
	        end if
	        if isDate(vProcessDT) then
		        rs("process_dt") = vProcessDT			
	        else
		        rs("process_dt") = date			
	        end if    	
	        rs("etd2")=vETD2
	        rs("eta2")=vETA2
	        rs("notify_name")=vNotifyName
	        rs("notify_info")=vNotifyInfo
	        rs("notify_acct")=vNotifyAcct
	        rs("broker_info")=vBrokerInfo
	        rs("broker_acct")=vBrokerAcct
			rs("broker_name")=vBrokerName
	        rs("container_location")=vContainerLocation
	        rs("free_date")=vFreeDate
	        rs("go_date")=vGODate
	        rs("it_number")=vITNumber
	        if IsDate(vITDate) then
		        rs("it_date")=vITDate
	        end if
	        rs("it_entry_port")=vITEntryPort
	        rs("cargo_location")=vCargoLocation
	        rs("flt_no")=vVessel
	        '// rs("vessel_name") = vVessel
            rs("Sub_mawb1")=vSubMAWB
            rs("etd")=vETD
            rs("eta")=vETA
	        rs("pieces")=vPCS
	        rs("uom")=vUOM
	        rs("gross_wt")=vGrossWT
	        rs("chg_wt")=vChgWT
	        rs("scale1")=vScale1
	        rs("scale2")=vScale2
            if IsCollect="N" then 
                rs("freight_collect")=0
            else
               rs("freight_collect")=vOFTotal
            end if  
	        rs("desc1")=mid(vDesc1,1,256)
	        rs("desc2")=mid(vDesc2,1,256)
	        rs("desc3")=mid(vDesc3,1,256)
	        rs("desc4")=mid(vDesc4,1,256)
	        rs("desc5")=mid(vDesc5,1,256)
	        rs("remarks")=mid(vRemarks,1,256)
	        rs("term")=vTerm
		    rs("dep_code")=vDepCode
		    rs("arr_code")=vArrCode    	
		    rs("dep_port")=vDepPort
		    rs("arr_port")=vArrPort    		

	        rs.update
	        rs.close
        end if
    end if

    Session("hawb")=vHAWB
    Session("mawb")= vMAWB
    Set rs=Nothing

End Sub 

Sub UPDATE_OLD_HAWB_TO_DB
    Dim rs  
    Set rs=Server.CreateObject("ADODB.Recordset")    
    Call CALCULATE_OTHER_CHARGE_TOTAL  
    if ( Not vAgentOrgAcct="" And Not vSec="" And Not vMAWB="") Or (Not InvoiceNo="" And Not vAgentOrgAcct="") then
        if vSavingCondition ="OVER_WRITE_WITH_NEW_HAWB_MAWB" then 
            SQL= "select * from import_hawb where iType='O' and elt_account_number =" & elt_account_number & " and invoice_no=" & InvoiceNo
        else 
	        if Not vAgentOrgAcct="" And Not vSec="" then	
		        SQL= "select * from import_hawb where iType='O' and elt_account_number =" & elt_account_number & " and agent_org_acct=" & vAgentOrgAcct & " and hawb_num=N'" & vHAWB& "' and mawb_num=N'" & vMAWB & "' and sec=" & vSec    	
	        else
		        SQL= "select * from import_hawb where iType='O' and elt_account_number =" & elt_account_number & " and agent_org_acct=" & vAgentOrgAcct & " and invoice_no=N" & InvoiceNo& " and mawb_num=N'" & vMAWB & "'"
	        end if
	    end if 
	    
	    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
    	
	    If Not rs.EOF Then
	        rs("elt_account_number")=elt_account_number
	    if Not vExportAgentELTAcct="" then
		    rs("agent_elt_acct")=vExportAgentELTAcct
	    end if
	    rs("agent_org_acct")=vAgentOrgAcct
	    rs("hawb_num")=vHAWB	    
	    rs("mawb_num")=vMAWB 	    
	    rs("sec")=vSec           				
        rs("CreatedBy")=session_user_lname	
        rs("CreatedDate")=Now
        rs("SalesPerson")=vSalesPerson  
	    rs("invoice_no")=InvoiceNo
	    rs("process_dt")=vProcessDT
	    rs("iType")="O"
	    rs("processed")="Y"
	    rs("prepared_by")=vPreparedBy
	    rs("shipper_name")=vShipperName
	    rs("shipper_info")=vShipperInfo
	  
	    rs("shipper_acct")=vShipperAcct
	    '// rs("Sub_mawb1")=vSubMAWB1
	    rs("Sub_mawb2")=vSubMAWB2
	    rs("customer_ref")=vCustomerRef
	    rs("consignee_name")=vConsigneeName
	    rs("consignee_info")=vConsigneeInfo
	    rs("consignee_acct")=vConsigneeAcct
	    rs("delivery_place")=vDeliveryPlace
	    rs("destination")=vDestination
        rs("fc_rate")=vOFRate
        rs("fc_charge")=vOFTotal
        if IsCollect="N" then 
           rs("freight_collect")=0
        else
           rs("freight_collect")=vOFTotal
        end if            
        if IsCollect="" then IsCollect="N"        
	    rs("prepaid_collect")=IsCollect   
	    rs("SalesPerson")=vSalesPerson	
        rs("ModifiedBy")= session_user_lname
        rs("ModifiedDate")=Now
        rs("oc_collect")=totalOC 
	    if isDate(vPickupDate) then
		    rs("pickup_date") = vPickupDate			
	    else
		    rs("pickup_date") = null			
	    end if
	    if isDate(vProcessDT) then
		    rs("process_dt") = vProcessDT			
	    else
		    rs("process_dt") = date			
	    end if    	
	    rs("etd2")=vETD2
	    rs("eta2")=vETA2
	    rs("notify_name")=vNotifyName
	    rs("notify_info")=vNotifyInfo
	    rs("notify_acct")=vNotifyAcct
	    rs("broker_info")=vBrokerInfo
	    rs("broker_acct")=vBrokerAcct
		rs("broker_name")=vBrokerName
	    rs("container_location")=vContainerLocation
	    rs("free_date")=vFreeDate
	    rs("go_date")=vGODate
	    rs("it_number")=vITNumber
	    if IsDate(vITDate) then
		    rs("it_date")=vITDate
	    end if
	    rs("it_entry_port")=vITEntryPort
	    rs("cargo_location")=vCargoLocation
        rs("flt_no") = vVessel
        '// rs("vessel_name") = vVessel
        rs("Sub_mawb1")=vSubMAWB
        rs("etd")=vETD
        rs("eta")=vETA
	    rs("pieces")=vPCS
	    rs("uom")=vUOM
	    rs("gross_wt")=vGrossWT
	    rs("chg_wt")=vChgWT
	    rs("scale1")=vScale1
	    rs("scale2")=vScale2
	    'rs("freight_collect")=vFreight
	    if IsCollect="N" then 
            rs("freight_collect")=0
        else
           rs("freight_collect")=vOFTotal
        end if  
	    rs("desc1")=mid(vDesc1,1,256)
	    rs("desc2")=mid(vDesc2,1,256)
	    rs("desc3")=mid(vDesc3,1,256)
	    rs("desc4")=mid(vDesc4,1,256)
	    rs("desc5")=mid(vDesc5,1,256)
	    rs("remarks")=mid(vRemarks,1,256)
	    rs("term")=vTerm
        rs("dep_code")=vDepCode
        rs("arr_code")=vArrCode    	
        rs("dep_port")=vDepPort
        rs("arr_port")=vArrPort    		
        
 	    Session("mawb")= vMAWB
        Session("hawb")= vHAWB
	    rs.update
	    rs.close
    end if
  end if
  Set rs=Nothing
End Sub 


Sub SAVE_BILL_DETAIL_TO_BILL_DETAIL_TABLE
	Dim rs 
	Set rs=Server.CreateObject("ADODB.Recordset")
	SQL= "delete from bill_detail where elt_account_number = " & elt_account_number & " and invoice_no=" & InvoiceNo 
	
	eltConn.Execute SQL
	item_id=1
	for i=1 to NoCostItem
		if aRealCost(i-1)<>0 then
			SQL= "select * from bill_Detail where elt_account_number=" & elt_account_number & " and invoice_no=" & InvoiceNo & " and item_id=" & item_id
			
			rs.Open SQL,eltConn,adOpenDynamic,adLockPessimistic,adCmdText
			rs.AddNew
			rs("elt_account_number")=elt_account_number
			rs("Invoice_No")=InvoiceNo
			rs("item_id")=item_id
			if isnull(aAPLock(i-1)) or aAPLock(i-1) = "" then
				rs("bill_number")= 0
			else
				rs("bill_number")= aAPLock(i-1)
			end if
			rs("vendor_number")=aVendor(i-1)
			rs("item_name")=aCostDesc(i-1)
			rs("item_no")=aCostItemNo(i-1)
			rs("item_amt")=aRealCost(i-1)
			rs("item_amt_origin")=aRealCost(i-1)
			rs("item_expense_acct")=aExpense(i-1)
			rs("tran_date")=vProcessDT
			rs("ref")=aRefNo(i-1)
			rs.Update
			rs.Close
			item_id=item_id+1
		end if
	next
	Set rs=Nothing 
End Sub 

Sub SAVE_COST_ITEMS_TO_INVOICE_COST_ITEM_TABLE
    Dim rs 
    Set rs=Server.CreateObject("ADODB.Recordset")
	SQL= "delete from invoice_cost_item where elt_account_number = " & elt_account_number & " and invoice_no=" & InvoiceNo
	
	eltConn.Execute SQL
	OrigTotalCost=0
	for i=1 to NoCostItem
		if Not aCostItemNo(i-1)="" And aRealCost(i-1)<>0 then
			SQL= "select * from invoice_cost_item where elt_account_number = " & elt_account_number & " and invoice_no=" & InvoiceNo & " and item_id=" & i
			
			rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
			If rs.EOF Then
				rs.AddNew
				rs("elt_account_number")=elt_account_number
				rs("Invoice_No")=InvoiceNo
				rs("item_id")=i
				aOrigCost(i-1)=0
				aOrigAmt(i-1)=0
			Else
				aOrigCost(i-1)=cdbl(rs("cost_amount"))
			end if
			OrigTotalCost=OrigTotalCost+aOrigCost(i-1)
			rs("item_no")=aCostItemNo(i-1)
			rs("item_desc")=aCostDesc(i-1)
			rs("ref_no")=aRefNo(i-1)
			rs("cost_amount")=aRealCost(i-1)
			rs("Vendor_no")=aVendor(i-1)
			rs.Update
			rs.Close
		end if
	next
    Set rs=Nothing 
End Sub 

Sub SAVE_CHARGE_ITEMS_TO_INVOICE_CHARGE_ITEM_TABLE	
    Dim rs 
    Set rs=Server.CreateObject("ADODB.Recordset")
	SQL= "delete from invoice_charge_item where elt_account_number = " & elt_account_number & " and invoice_no=" & InvoiceNo
	
	eltConn.Execute SQL
	OrigTotalCost=0
	dim item_id
	item_id=1
	if IsCollect="Y" then 
	    Call SAVE_FREIGHT_CHARGE(item_id)
	    item_id=2	
	end if 
	'--------------------------Include FREIGHT CHARGE------------------------
	for i=1 to NoItem 
		if Not aItemNo(i-1)="" And aAmount(i-1)<>0 then
			SQL= "select elt_account_number,Invoice_No,item_id,charge_amount,item_no,item_desc from invoice_charge_item where elt_account_number = " & elt_account_number & " and invoice_no=" & InvoiceNo & " and item_id=" & item_id
			
			rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
			If rs.EOF Then
				rs.AddNew
				rs("elt_account_number")=elt_account_number
				rs("Invoice_No")=InvoiceNo
				rs("item_id")=item_id
				aOrigAmt(i-1)=0
			Else
				aOrigAmt(i-1)=cdbl(rs("charge_amount"))
			end if
			rs("item_no")=aItemNo(i-1)
			rs("item_desc")=aChargeDesc(i-1)
			rs("charge_amount")=aAmount(i-1)
			rs.Update
			rs.Close
			item_id=item_id+1
		end if
	next
    Set rs=Nothing 
End Sub 

Sub SAVE_FREIGHT_CHARGE(i)

    Dim rs 
    Set rs=Server.CreateObject("ADODB.Recordset")   
	SQL= "select elt_account_number,Invoice_No,item_id,charge_amount,item_no,item_desc from invoice_charge_item where elt_account_number = " & elt_account_number & " and invoice_no=" & InvoiceNo & " and item_id=" & i
	
	rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	        If rs.EOF Then
				rs.AddNew
				rs("elt_account_number")=elt_account_number
				rs("Invoice_No")=InvoiceNo
				rs("item_id")=i
				aOrigAmt(i-1)=0
			Else
				aOrigAmt(i-1)=cdbl(rs("charge_amount"))
			end if
			rs("item_no")=vDefaultOF
			rs("item_desc")=vFCDescription
			if IsCollect="Y" then 
			    rs("charge_amount")=vOFTotal
			else 
			    rs("charge_amount")=0
			end if 
			rs.Update
			rs.Close		
    Set rs=Nothing 
    
End Sub 

Sub GET_REQUEST_FROM_SCREEN
    vArApLock =Request("hArApLock")
    vSavingCondition=Request("hSavingCondition")
    vFCDescription=Request("txtFCDescription")
    IsCollect=Request("hIsCollect")
    if IsCollect="" or IsCollect=Empty then  IsCollect="N"
    vPostBack=Request("hPostBack")   
     
    FROM_EDIT=Request("FROM_EDIT")
    vSaveAsNew=Request("hSaveAsNew")
    if vSaveAsNew="" then vSaveAsNew="N"

	vDepPort=Request("hDepText")
    vArrPort=Request("hArrText")
	vDepCode=Request("lstDepPort")
    vArrCode=Request("lstArrPort")

    vOFRate=Request("txtCSRate")
    if vOFRate<> "" then
        vOFRate=cLng(vOFRate)
    else 
         vOFRate=0
    end if 
    vOFTotal=Request("txtTotalFC")
    if vOFTotal <> "" then
        vOFTotal=cdbl(vOFTotal)
    else 
         vOFTotal=0
    end if 
    vSalesPerson=Request("lstSalesRP")    
    if vSalesPerson = "none" then
       Call GET_DEFAULT_SALES_PERSON_FROM_DB
    end if 
	vAgentOrgAcct=Request("hAgentOrgAcct")
	InvoiceNo=Request("txtInvoiceNo")	
	
'// Avoid data saving when back or refresh	
	if NOT tNo = TranNo then InvoiceNo = Session("InvoiceNo")
	InvoiceNo=FixNull(InvoiceNo)
	
	vAR=Request("lstAR")
	
	if vAR="" then vAR=0
	vTerm=Request("txtTerm")
	if Not IsNumeric(vTerm) then vTerm=0
	vSec=Request("hSec")
	if vSec ="" then vSec= Session("vSec")
	
	vFileNo=Request("txtRefNo")
	vProcessDT=Request("txtDate")
	if Not IsDate(vProcessDT) then vProcessDT=Date
	
	vMAWB=Request("txtMAWB")
	vHAWB=Request("txtHAWB")

	if vPreparedBy="" then vPreparedBy=Request("txtPreparedBy")
	vPCS=Request("txtPCS")
	if vPCS="" then vPCS=0
	vUOM=Request("lstUOM")
	vGrossWT=Request("txtGrossWT")
	if vGrossWT="" then vGrossWT=0
	vChgWT=Request("txtChgWT")
	if vChgWT="" then vChgWT=0
	vScale1=Request("lstScale1")
	vScale2=Request("lstScale2")

	vShipperName = Request.Form("lstShipperName")
	vShipperAcct = checkBlank(Request.Form("hShipperAcct"),0)
    vShipperInfo = Request("txtShipperInfo")
    
    vConsigneeInfo = Request("txtConsigneeInfo")
	vConsigneeName = Request("lstConsigneeName")
	vConsigneeAcct = checkBlank(Request("hConsigneeAcct"),0)
	
	vNotifyAcct = checkBlank(Request("hNotifyAcct"),0)
	vNotifyInfo = Request("txtNotifyInfo")
	vNotifyName = Request("lstNotifyName")

	vBrokerAcct = checkBlank(Request("hBrokerAcct"),0)
	vBrokerInfo=Request("txtBrokerInfo")
	vBrokerName = Request("lstBrokerName")
	
	vSubMAWB=Request("txtSubMAWB")
	vSubMAWB2=Request("txtSubMAWB2")
	vCustomerRef=Request("txtCustomerRef")
	
	vVessel=Request("txtVessel")
	vVoyageNo=Request("txtVoyageNo")	
	vPickupDate=Request("txtPickupDate")

	vETD=Request("txtETD")
	vETA=Request("txtETA")
	vDeliveryPlace=Request("txtDeliveryPlace")
	vDestination=Request("txtDestination")
	vETD2=Request("txtETD2")
	vETA2=Request("txtETA2")
	
	vCargoLocation=Request("txtCargoLocation")
	vContainerLocation=Request("txtContainerLocation")
	vFreeDate=Request("txtFreeDate")
	vGODate=Request("txtGODate")
	vITNumber=Request("txtITNumber")
	vITDate=Request("txtITDate")
	vITEntryPort=Request("txtITEntryPort")
	vDesc1=Request("txtDesc1")
	vDesc2=vPCS & vUOM
	vDesc3=Request("txtDesc3")
	if vScale1="KG" then
		vDesc4 = formatNumberPlus(vGrossWT , 2) & "KG" & chr(13) & formatNumberPlus(vGrossWT * 2.2046, 2) & "LB"
	else
		vDesc4 = formatNumberPlus(vGrossWT * 0.4536,2) & "KG" & chr(13) & formatNumberPlus(vGrossWT * 2.2046, 2) & "LB"
	end if
	if vScale2="CBM" then
		vDesc5=formatNumberPlus(vChgWT , 2) & "CBM" & chr(13) & formatNumberPlus(vChgWT * 35.31456, 2) & "CFT"
	else
		vDesc5=formatNumberPlus(vChgWT * 0.028317,2) & "CBM" & chr(13) & formatNumberPlus(vChgWT * 35.31456, 2) & "CFT"
	end if
	vRemarks=Request("txtRemarks")
	if TotalAmount="" then TotalAmount=0
	
	NoItem=Request("hNoItem")
	NoCostItem=Request("hNoCostItem")
	
	if NoItem="" then
		NoItem=0
	else
		NoItem=CInt(NoItem)
	end if
	if NoCostItem="" then
		NoCostItem=0
	else
		NoCostItem=CInt(NoCostItem)
	end if		
	Call GET_CHARGE_ITEMS_FROM_SCREEN
    Call GET_COST_ITEMS_FROM_SCREEN
End Sub 

Sub CALCULATE_TOTAL_CHARGE_AND_TOTAL_COST
    vTotalAmount=0
    vTotalCost=0
    for i=0 to NoItem-1
        vTotalAmount=vTotalAmount+aAmount(i)
    next
    for i=0 to NoCostItem-1
        vTotalCost=vTotalCost+aRealCost(i)
    next    
End Sub 
	

Sub DELETE_CHARGE_ITEM_FROM_DB_AND_LIST
   dItemNo=Request.QueryString("rNo")
    for i=dItemNo to NoItem-1
	    aItemNo(i)=aItemNo(i+1)
	    aRevenue(i)=aRevenue(i+1)
	    aChargeDesc(i)=aChargeDesc(i+1)
	    aAmount(i)=aAmount(i+1)
    next
    NoItem=NoItem-1
End Sub 

Sub DELETE_COST_ITEM_FROM_DB_AND_LIST
    dItemNo=Request.QueryString("rNo")
    for i=dItemNo to NoCostItem-1
        aCostItemNo(i)=aCostItemNo(i+1)
        aExpense(i)=aExpense(i+1)
        aCostDesc(i)=aCostDesc(i+1)
        aRefNo(i)=aRefNo(i+1)
        aRealCost(i)=aRealCost(i+1)
        aVendor(i)=aVendor(i+1)
		aAPLock(i)=aAPLock(i+1)
    next
    NoCostItem=NoCostItem-1
End Sub 

Sub GET_COST_ITEMS_FROM_SCREEN
On Error Resume Next:
    for i=0 to NoCostItem-1
        item=Request("lstCostItem" & i)
        pos=0
        pos=instr(item,"-")
        if pos>0 then
	        aCostItemNo(i)=Cint(Mid(item,1,pos-1))
	        item=Mid(item,pos+1,200)
        end if
		
        pos=instr(item,"-")
        if pos>0 then
	        aExpense(i)=Mid(item,1,pos-1)
	        if aExpense(i)="" then aExpense(i)=0
	        aCostItemName(i)=Mid(item,pos+1,200)
        end if
        aCostDesc(i)=Request("txtCostDesc" & i)
        aRefNo(i)=Request("txtRefNo" & i)
        aRealCost(i)=Request("txtCost" & i)
        if aRealCost(i)="" then
	        aRealCost(i)=0
        else
	        aRealCost(i)=cdbl(aRealCost(i))
        end if
        aVendor(i)=CLng(Request("lstVendor" & i))
		aAPLock(i)=Request("txtAPLOCK" & i)		
    next

End Sub 

Sub GET_CHARGE_ITEMS_FROM_SCREEN
    for i=0 to NoItem-1
        item=Request("lstItem" & i)
        
        pos=0
        pos=instr(item,"-")
        if pos>0 then
	        aItemNo(i)=Cint(Mid(item,1,pos-1))
	        item=Mid(item,pos+1,200)
        end if
        pos=instr(item,"-")
        if pos>0 then
            aRevenue(i)=Mid(item,1,pos-1)
            if aRevenue(i)="" then aRevenue(i)="0"
            aRevenue(i)=CDbl(aRevenue(i))
	        aItemName(i)=Mid(item,pos+1,200)
	       
        end if
        aChargeDesc(i)=Request("txtChargeDesc" & i)
        aAmount(i)=Request("txtAmount" & i)
        if aAmount(i)="" then
	        aAmount(i)=0
        else
	        aAmount(i)=Cdbl(aAmount(i))
        end if
    next    
    		
End Sub 

Sub GET_CHARGE_ITEMS_FROM_DB
    NoItem=0	
    dim rs
    dim flag
    flag=false
    Set rs=Server.CreateObject("ADODB.Recordset")
    
    Set ALItemNo= Server.CreateObject("System.Collections.ArrayList")
    Set ALChargeDesc= Server.CreateObject("System.Collections.ArrayList")
    Set ALAmount= Server.CreateObject("System.Collections.ArrayList")
    
    if InvoiceNo <> ""  then
	    SQL= "select item_no,item_desc,charge_amount from invoice_charge_item where elt_account_number = " & elt_account_number & " and invoice_no=" & InvoiceNo & "order by item_id"			
		
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing
	    
	    Do While Not rs.EOF
	         if IsCollect="Y" then 
	            if rs("item_no") <> vDefaultOF then 
		            ALItemNo.Add rs("item_no").value
		            ALChargeDesc.Add rs("item_desc").value
		            ALAmount.Add cDbl(rs("charge_amount"))
		        else 
		           flag=true
		        end if 
		     else
		        ALItemNo.Add rs("item_no").value
	            ALChargeDesc.Add rs("item_desc").value
	            ALAmount.Add cDbl(rs("charge_amount"))
		     end if 
		    rs.MoveNext	    
	     Loop
	    
	     if flag <> true then
	        IsCollect="N"
	    end if 
	    
	    tIndex=0
	    vTotalAmount=0
	    vTotalCost=0
	    
	    For i=0 to ALItemNo.Count -1
		    aItemNo(tIndex)=ALItemNo(i)
		    aChargeDesc(tIndex)=ALChargeDesc(i)
		    aAmount(tIndex)=ALAmount(i)		  
		    tIndex=tIndex+1
	    next
	
	    rs.Close	  
    end if 

    NoItem=tIndex
    if NoItem < 4 then
	    NoItem = 4
    end if
    Set rs=Nothing 
    
End Sub 

Sub GET_COST_ITEMS_FROM_DB
    dim rs
    Set rs=Server.CreateObject("ADODB.Recordset")
    NoCostItem = 0
    if InvoiceNo <> "" then
        SQL= "select item_no,item_desc,ref_no,cost_amount,Vendor_no from invoice_cost_item where elt_account_number = " & elt_account_number & " and invoice_no=" & InvoiceNo & " order by item_id"
		
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing
	    ccIndex=0
    Do While Not rs.EOF
	    aCostItemNo(ccIndex)=rs("item_no")
	    aCostDesc(ccIndex)=rs("item_desc")
	    aRefNo(ccIndex)=rs("ref_no")
	    aRealCost(ccIndex)=cDbl(rs("cost_amount"))
	    aVendor(ccIndex)=CLng(rs("Vendor_no"))
	    rs.MoveNext
	    ccIndex=ccIndex+1
    Loop
    rs.Close
	
		'////////////////////////////////////////////	
		for j=0 to ccIndex - 1
		    SQL = "select bill_number from bill_detail where elt_account_number = "&elt_account_number&" and invoice_no=" & InvoiceNo &_
                " and vendor_number=" & aVendor(j) & _
                " and item_no='" & aCostItemNo(j) & "'" & _
                " and ( item_amt=" & aRealCost(j) & " or item_amt=" & -1 * Cdbl(aRealCost(j)) & ") and bill_number <> 0"
			
			rs.CursorLocation = adUseClient
			rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
			Set rs.activeConnection = Nothing
			if not rs.eof then
				aAPLock(j) = rs(0).value
			else
				aAPLock(j) = ""			
			end if
		rs.close()	
		next
		'////////////////////////////////////////////	
	
    NoCostItem=ccIndex
    vSubTotal=0
    vTotalCost=0
    for i=0 to NoItem-1
	    vSubTotal=vSubTotal+aAmount(i)
    next
    for i=0 to NoCostItem-1
	    vTotalCost=vTotalCost+aRealCost(i)
    next
    vTotalAmount=vSubTotal
    end if    
    if NoCostItem < 4 then
	    NoCostItem = 4
    end if
    Set rs=Nothing 
End Sub 

Sub GET_ALL_ACCOUNT_RECEIVABLE
'///////////////////////////////////////////////////// by iMoon Jan-20-2007 for multi-check#

    Dim rs 
    Set rs=Server.CreateObject("ADODB.Recordset")
    SQL= "select gl_account_type,gl_account_number,gl_account_desc from gl where elt_account_number = " & elt_account_number & " and (gl_account_type=N'"&CONST__ACCOUNT_RECEIVABLE&"' or gl_master_type=N'"&CONST__MASTER_EXPENSE_NAME&"' " & " or gl_master_type=N'"&CONST__MASTER_REVENUE_NAME&"' ) order by gl_account_number"
    
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
    
    Do While Not rs.EOF
	    GlType=rs("gl_account_type")
	    if GlType = CONST__ACCOUNT_RECEIVABLE then
		    DefaultAR(ARIndex)=CLng(rs("gl_account_number"))
		    DefaultARName(ARIndex)=rs("gl_account_desc")
		    ARIndex=ARIndex+1
	    end if
	    
	    rs.MoveNext
    Loop
    rs.Close
    Set rs=Nothing 
End Sub 

Sub GET_CHARGE_ITEM_LIST_FROM_DB
    Dim rs
    Set rs=Server.CreateObject("ADODB.Recordset")
    SQL= "select * from item_charge where elt_account_number = " & elt_account_number & " order by item_name"
    
    rs.Open SQL, eltConn, , , adCmdText
    ItemIndex=0
   
    Do While Not rs.EOF
    if rs("item_no")<> vDefaultOF then 
	    DefaultItemNo(ItemIndex)=rs("item_no")
	    if IsNull(DefaultItemNo(ItemIndex)) then DefaultItemNo(ItemIndex)=0
	    DefaultItem(ItemIndex)=rs("item_name")
	    DefaultItemDesc(ItemIndex)=rs("item_desc")
	    DefaultRevenue(ItemIndex)=rs("account_revenue")    	
	    aItemUnitPrice(ItemIndex)=rs("Unit_Price") '// Unit_Price by ig 10/21/2006
    	
	    if DefaultItem(ItemIndex)="AF" then
		    AF=DefaultItemNo(ItemIndex)
	    elseif DefaultItem(ItemIndex)="OF" then
		    OF=DefaultItemNo(ItemIndex)
	    end if
	    aItemDesc(DefaultItemNo(ItemIndex))=DefaultItemDesc(ItemIndex)
	    if ( len(DefaultItem(ItemIndex))) < 7 then
		    igDefaultItem(ItemIndex) = DefaultItem(ItemIndex) & " " & string(7-len(DefaultItem(ItemIndex)),"-") & " " & DefaultItemDesc(ItemIndex)
	    else
		    igDefaultItem(ItemIndex) = DefaultItem(ItemIndex)
	    end if
	    ItemIndex=ItemIndex+1
	 else	 
	     vDefaultOF_Revenue=rs("account_revenue")
	     vDefaultOF_Desc=rs("item_desc")
	 end if 
	    rs.MoveNext
    Loop
    rs.Close
    
Set rs=Nothing
Set rs1=Nothing 
End Sub 


Sub GET_COST_ITEM_LIST_FROM_DB
    Dim rs 
    Set rs=Server.CreateObject("ADODB.Recordset")
    SQL= "select item_no,item_name,item_desc,account_expense,Unit_Price from item_cost where elt_account_number = " & elt_account_number & " order by item_name"
    
    rs.CursorLocation = adUseClient
    rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
    Set rs.activeConnection = Nothing
    CostItemIndex=0
    '// gather item cost
    Do While Not rs.EOF
	    DefaultCostItemNo(CostItemIndex)=rs("item_no")
	    if IsNull(DefaultCostItemNo(CostItemIndex)) then DefaultCostItemNo(CostItemIndex)=0
	    DefaultCostItem(CostItemIndex)=rs("item_name")
	    DefaultCostItemDesc(CostItemIndex)=rs("item_desc")
	    DefaultExpense(CostItemIndex)=rs("account_expense")
	    if IsNull(DefaultExpense(CostItemIndex)) then DefaultExpense(CostItemIndex)=0
	    aCostItemDesc(CostItemIndex)=DefaultCostItemDesc(CostItemIndex)

	    aCostItemUnitPrice(CostItemIndex) = rs("Unit_Price") '// Unit_Price by ig 10/21/2006

	    if ( len(DefaultCostItem(CostItemIndex))) < 7 then
	    igDefaultCostItem(CostItemIndex) = DefaultCostItem(CostItemIndex) & " " & string(7-len(DefaultCostItem(CostItemIndex)),"-") & " " & DefaultCostItemDesc(CostItemIndex)
	    else
	    igDefaultCostItem(CostItemIndex) = DefaultCostItem(CostItemIndex)
	    end if
	    CostItemIndex=CostItemIndex+1
	    rs.MoveNext
    Loop
    rs.Close
    Set rs=Nothing 
End Sub 

Sub GET_FREIGHT_LOCATION
    Dim tmpStr,rsTmp,SqlTmp
    Set rsTmp=Server.CreateObject("ADODB.Recordset")
    If Trim(vCargoLocation) = "" Then
       Exit Sub
    End If
    If ( InStr(vCargoLocation,"-") > 0 ) then
	    vCargoLocation = vCargoLocation
    Else
	    tmpStr = vCargoLocation
	    SqlTmp= "select location,phone,fax from freight_location where elt_account_number = " & elt_account_number & " AND firm_code=N'" &tmpStr&"'"
        
		rsTmp.CursorLocation = adUseClient
		rsTmp.Open SqlTmp, eltConn, adOpenForwardOnly, , adCmdText
		Set rsTmp.activeConnection = Nothing

	    IF Not rsTmp.EOF Then
		    If IsNull(rsTmp("phone")) then
		    vCargoLocation = tmpStr & "-" & rsTmp("location") 
		    Else
		    vCargoLocation = tmpStr & "-" & rsTmp("location") & " (tel:"&rsTmp("phone")&")" & " (fax:"&rsTmp("fax")&")"
		    End if
	    Else
		    vCargoLocation = vCargoLocation
	    End If
	    rsTmp.Close
	    Set rsTmp = nothing
    End If
End Sub


Sub CHECK_DEFAULT_FREIGT_CHARGE_ACCOUNT
 Dim rsIfOF
' check if default ocean freight charage is in the database 
    SET rsIfOF=Server.CreateObject("ADODB.Recordset")	
	SQL= "select isnull(default_ocean_charge_item,-1) as default_ocean_charge_item from user_profile where elt_account_number = " & elt_account_number 
	
	rsIfOF.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	Dim  vCof
	vDefaultOF = ConvertAnyValue(rsIfOF("default_ocean_charge_item"),"Integer",0)
	
	 if not rsIfOF.eof and ( vDefaultOF <> -1 )then 
		
	else response.Write("<script type='text/javascript'> CofirmDFA(); </script>") 
	rsIfOF.close()  
    end if
End Sub




Sub CALCULATE_OTHER_CHARGE_TOTAL
    totalOC=0
    ItemNo=Request("hNoItem")
  
    for i=0 to ItemNo-1
       if not cInt(vDefaultOF) = aItemNo(i) then 
            totalOC=totalOC+aAmount(i)
       else vFC_from_Item =aAmount(i)
       end if 
    next	
End Sub

'---------------------------------------------------------------------------------------------------------------------------------------------
Sub GET_DEFAULT_SALES_PERSON_FROM_DB
    Dim rs 
    Set rs=Server.CreateObject("ADODB.Recordset")
    if isnull(vConsigneeAcct) or vConsigneeAcct = 0 then
        vSalesPerson ="" 
    else 
        SQL= "select SalesPerson from organization where elt_account_number = "& elt_account_number &" and org_account_number = "& vConsigneeAcct
        
        rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing
        if not rs.EOF then	
            vSalesPerson = rs("SalesPerson")
        else 
            vSalesPerson ="" 
        end if   
        rs.close
  end if 
  Set rs=Nothing 
End  Sub


Sub GET_SALES_PERSONS_FROM_USERS_TABLE
    Dim rs 
    Set rs=Server.CreateObject("ADODB.Recordset")

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
    Set rs=Nothing 
End  Sub 

Sub GET_MAWB_FROM_DB   
    Dim rs
    Set rs=Server.CreateObject("ADODB.Recordset")
    if Not vMAWB="" or Not InvoiceNo= "" then
        if Not vMAWB="" and Not vSec="" then
            SQL="select * from import_mawb where elt_account_number=" & elt_account_number & " and iType='O' and mawb_num=N'" & vMAWB & "' and sec=" & vSec
        elseif InvoiceNo <> "" and vHAWB="" then 
            SQL="select a.*, b.hawb_num as HAWB from import_mawb a,import_hawb b where a.elt_account_number=b.elt_account_number and a.elt_account_number=" & elt_account_number & " and a.mawb_num=b.mawb_num and  a.iType='O' and a.iType=b.iType and b.invoice_no=" & InvoiceNo & " and a.sec=b.sec"
        end if	
		
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing

        if Not rs.EOF then
            vMAWB=rs("mawb_num")
            vProcessDT=rs("process_dt")
            if IsNull(vProcessDT) or vProcessDT="" then 
                vProcessDT=Date
            else
                vProcessDT=FormatDateTime(vProcessDT,vbShortDate)
            end if
            vFileNo=rs("file_no")
           
            vDepPort=rs("dep_port")
            vArrPort=rs("arr_port")
            vDepCode=rs("dep_code")
            vArrCode=rs("arr_code")
           
            vVoyageNo=rs("voyage_no")
            '// vVessel=rs("flt_no")
            vVessel = rs("vessel_name")
            
            vSubMAWB=rs("Sub_mawb")
            vETD=rs("etd")
            vETA=rs("eta")
            vCargoLocation=rs("cargo_location")
            vITNumber=rs("it_number")
            vITDate=rs("it_date")
            vITEntryPort=rs("it_entry_port")
            vDeliveryPlace=rs("place_of_delivery")
            vFreeDate=rs("last_free_date")
            '---------------------------------------
            
            If Not IsNull(vITEntryPort) Then
				    vITEntryPort = replace(vITEntryPort,"Select One","") 
            End If
				
			On Error Resume Next:
            if InvoiceNo <> "" then
                vHAWB=rs("HAWB")
                Session("hawb")=vHAWB
            end if 
            Session("mawb")= vMAWB
        else 
            vMAWB=""
            Session("mawb")=vMAWB
            if  Search="yes" then InvoiceNo="" ' when search fails
        end if
         rs.close
    end if
   
    Set rs=Nothing
End Sub 

Sub GET_HAWB_FROM_DB   
    SQL=""
    Dim rs 
    Set rs=Server.CreateObject("ADODB.Recordset")
    Dim SQL_READY
    SQL_READY=false
    
    if InvoiceNo <> "" And vHAWB = "" then
	    SQL="select * from import_hawb where elt_account_number=" & elt_account_number & " and iType='O' and invoice_no=" & InvoiceNo
	    SQL_READY=true
    else
		if  vMAWB <> "" then
			SQL="select * from import_hawb where elt_account_number=" & elt_account_number & " and iType='O' and hawb_num=N'" & vHAWB & "' and mawb_num=N'" & vMAWB & "' and sec=" & vSec
			SQL_READY=true
		end if
	end if  
    
    if SQL_READY =true  then 
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing  
		if rs.EOF then  
			response.write "This A/N was deleted."
			response.end
		end if	
        if Not rs.EOF then
            IsCollect=rs("prepaid_collect")
            if IsCollect="" or IsCollect=Empty then  IsCollect="N" 
            if(isnull(rs("SalesPerson"))) then 
             vSalesPerson=""
            else 
             vSalesPerson=rs("SalesPerson")
            end if 
             
            vOFRate=rs("fc_rate")
            if IsNull(vOFRate) then
             vOFRate=0
            end if    
            vOFTotal=rs("fc_charge")
            if IsNull(vOFTotal) then 
                vOFTotal=0
            end if    
            vHAWB=rs("hawb_num")
            vAgentOrgAcct=rs("agent_org_acct")
            if vAgentOrgAcct="" then vAgentOrgAcct=0
            vAgentELTAcct=rs("agent_elt_acct")
            if vAgentELTAcct="" or IsNull(vAgentELTAcct) then
                vAgentELTAcct=0
            else
                vAgentELTAcct=cLng(vAgentELTAcct)
            end if
            InvoiceNo=rs("invoice_no")
           
            InvoiceNo=FixNull(InvoiceNo)
            
            vSec=rs("sec")
            vShipperInfo=rs("shipper_info")
           
            pos=0
            pos=instr(vShipperInfo,chr(13))
            if pos>0 then
                vShipperName=Mid(vShipperInfo,1,pos-1)
            end if
            vShipperAcct=rs("shipper_acct")
            if IsNull(vShipperAcct) then vShipperAcct=0			
            vShipperName = rs("shipper_name")
            vConsigneeName = rs("consignee_name")	
            vNotifyName = rs("notify_name")	
            vConsigneeInfo=rs("consignee_info")
			
			vDepPort = checkBlank( rs("dep_port"), vDepPort )
			vArrPort = checkBlank( rs("arr_port"), vArrPort )
			vDepCode = checkBlank( rs("dep_code"), vDepCode )
			vArrCode = checkBlank( rs("arr_code"), vArrCode )
		
            pos=0
            pos=instr(vConsigneeInfo,chr(13))
            if pos>0 then
                vConsigneeName=Mid(vConsigneeInfo,1,pos-1)
            end if
            vConsigneeAcct=rs("consignee_acct")
            if IsNull(vConsigneeAcct) then
                vConsigneeAcct=0
            elseif vConsigneeAcct="" then
                vConsigneeAcct=0
            else
                vConsigneeAcct=cLng(vConsigneeAcct)
            end if
            'auto create consignee
            if vConsigneeAcct=0 And vAgentELTAcct>0 then
                Set rs2=Server.CreateObject("ADODB.Recordset")
                SQL= "select dba_name,org_account_number from organization where elt_account_number=" & elt_account_number & " and dba_name=N'" & vConsigneeName & "'"
				
				rs2.CursorLocation = adUseClient
				rs2.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
				Set rs2.activeConnection = Nothing
                If Not rs2.EOF Then
	                ConsigneeExist="Y"
	                vConsigneeAcct=rs2("org_account_number")
                else
	                ConsigneeExist="N"
                end if
                rs2.Close
            end if
            vNotifyInfo=rs("notify_info")
            
            pos=0
            pos=instr(vNotifyInfo,chr(13))
            if pos>0 then
                vNotifyName=Mid(vNotifyInfo,1,pos-1)
            end if
            vNotifyAcct=rs("notify_acct")
            if IsNull(vNotifyAcct) then vNotifyAcct=0
            vPreparedBy=rs("prepared_by")
            vSubMAWB2=rs("Sub_mawb2")
            vCustomerRef=rs("customer_ref")
            vPickupDate=rs("pickup_date")
			'------------------------------------
            vBrokerInfo=rs("broker_info")
            vBrokerAcct=rs("broker_acct")
			vBrokerName=rs("broker_name")
			'--------------------------------
            if IsNull(vBrokerAcct) then vBrokerAcct=0
            vDeliveryPlace=rs("delivery_place")
            vProcessDT=rs("process_dt")			
            vETD2=rs("etd2")
            vETA2=rs("eta2")
            vContainerLocation=rs("container_location")
            vDestination=rs("destination")
            '// vFreeDate=rs("free_date")
            vGODate=rs("go_date")
            tITNumber=rs("it_number")
            if Not tITNumber="" and Not IsNull(tITNumber) then
                vITNumber=tITNumber
            end if
            tITDate=rs("it_date")
            if Not tITDate="" and Not IsNull(tITDate) then
                vITDate=tITDate
            end if
            tITEntryPort=rs("it_entry_port")
            if Not tITEntryPort="" and Not IsNull(tITEntryPort) then
                vITEntryPort=tITEntryPort
            end if
            tCargoLocation=rs("cargo_location")
            if Not tCargoLocation="" and Not IsNull(tCargoLocation) then
                vCargoLocation=tCargoLocation
            Else
                Call GET_FREIGHT_LOCATION
            End if
            vPCS=rs("pieces")
            vUOM=rs("uom")
            vGrossWT=rs("gross_wt")
            vChgWT=rs("chg_wt")
            vScale1=Trim(rs("scale1"))
            vScale2=Trim(rs("scale2"))
            vDesc1=rs("desc1")
            vDesc3=rs("desc3")
            vRemarks=rs("remarks")
            vTerm=rs("term")
            
            '--------------------------------- Override MBOL
            '//Modified by Joon on May-1-2007
            '//if rs("flt_no")<>empty then 
            '//     vVessel=rs("flt_no")
            '//end if 
            
            if rs("Sub_mawb1")<>empty then
                vSubMAWB=rs("Sub_mawb1")
            end if 
            if rs("etd")<>empty then
                vETD=rs("etd")
            end  if 
            if rs("eta")<>empty then
                vETA=rs("eta")
            end if 
            if rs("cargo_location")<>empty then
                vCargoLocation=rs("cargo_location")
            end if 
            if rs("it_number")<>empty then
                vITNumber=rs("it_number")
            end if 
            if rs("it_date")<>empty then
                vITDate=rs("it_date")
            end if 
            if rs("it_entry_port")<>empty then
                vITEntryPort=rs("it_entry_port")
            end if 
            if rs("delivery_place")<>empty then
                vDeliveryPlace=rs("delivery_place")
            end if 
            if rs("free_date") <>empty then
                vFreeDate=rs("free_date")   
            end if                 
            
            rs.close
       end if
       
       CALL GET_CHARGE_ITEMS_FROM_DB
       CALL GET_COST_ITEMS_FROM_DB 
      
       Session("hawb") = vHAWB
       Session("mawb") = vMAWB
    else
        vHAWB=""  
    end if 
    
     if NoItem < 4 then
    NoItem = 4     
    end if

    if NoCostItem < 4 then
    NoCostItem = 4
    end if
    
    Set rs=Nothing
    Set rs1=Nothing 
End Sub 

Sub GET_MAWB_LIST_FROM_DB
    Dim freight_loc
    Dim rs_mawb
    Dim vAvalue    
	Set aMAWB = Server.CreateObject("System.Collections.ArrayList")
    Set aMAWBInfo= Server.CreateObject("System.Collections.ArrayList")    
    SET rs_mawb = Server.CreateObject("ADODB.Recordset")    
	SQL = "SELECT a.mawb_num FROM import_mawb a where a.elt_account_number='"& elt_account_number & "' and iType ='O' order by mawb_num"    	
	
	rs_mawb.CursorLocation = adUseClient
	rs_mawb.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs_mawb.activeConnection = Nothing
    dim ma_no
    count=0
	Do While Not rs_mawb.eof And Not rs_mawb.bof
	    if not isnull(rs_mawb("mawb_num")) then                    
		    ma_no=rs_mawb("mawb_num")
		    aMAWB.Add ma_no	         
        end if 
		rs_mawb.MoveNext		
	Loop
	rs_mawb.Close
End Sub

%>
<!--  #include file="../include/arn_functions.inc" -->
<%
	if invoiceNo <> "" then
		call get_ar_payment	( invoiceNo )
	end if
%>
<script type="text/javascript">
    function selectSearchType() {

        var selectBox = document.getElementById('SearchType');
        var typearrival = document.getElementById('searcharrival');
        typearrival.style.display = (selectBox.value == 'arrivalNo') ? '' : 'none';
        var typehouse = document.getElementById('searchhouse');
        typehouse.style.display = (selectBox.value == 'houseNo') ? '' : 'none';
        var typemaster = document.getElementById('searchmaster');
        typemaster.style.display = (selectBox.value == 'masterNo') ? '' : 'none';
    }


function lstMAWBChange_ocean(mawb)   {

    var tmpInfo = get_arrival_mawb_info(mawb, "O");
    var obj = eval("(" + tmpInfo + ")"); 

	//var aVal=tmpInfo.split("^");
	//alert(aVal.length);
    document.getElementById("txtRefNo").value = obj[0].file_no;
    document.getElementById("txtVessel").value = obj[0].vessel_name;
    var it_entry_port = obj[0].it_entry_port.replace("Select One", "");
    document.getElementById("txtITEntryPort").value = it_entry_port;
    document.getElementById("txtITNumber").value = obj[0].it_number;
    document.getElementById("txtITDate").value = obj[0].it_date;
    document.getElementById("txtFreeDate").value = obj[0].last_free_date;
    document.getElementById("txtVoyageNo").value = obj[0].voyage_no;
    document.getElementById("txtSubMAWB").value = obj[0].sub_mawb;
    document.getElementById("txtCargoLocation").value = obj[0].cargo_location;
    document.getElementById("txtETD").value = obj[0].etd;
    document.getElementById("txtETA").value = obj[0].eta;
    //obj[0].dep_port = obj[0].dep_port.replace("Select One", "");

    document.getElementById("hDepText").value = obj[0].dep_port;
    document.getElementById("hArrText").value = obj[0].arr_port;
	document.getElementById("hAgentOrgAcct").value = obj[0].agent_org_acct;
	document.getElementById("hSec").value = obj[0].sec;

	setSelect("lstDepPort", obj[0].dep_code);
	setSelect("lstArrPort", obj[0].arr_code);

	var now = new Date();
	var day = now.getDate();
	var mon = now.getMonth()+1;
	if (day < 10)
	    day = "0" + day;
	if (mon < 10)
	    mon = "0" + mon;
	document.getElementById("txtDate").value =  mon + "/" + day + "/" + now.getFullYear(); 
}

    
if ("<%= Save %>"=="yes" ){
    var ItemNo=document.form1.hItemNo.value;
    if (ItemNo!="")
    	ItemNo=parseInt(ItemNo);
    else
	    ItemNo=0;

   var HAWBDesc=1;
    var HAWBPieces=1;
    var HAWBGrossWT=1;
    var HAWBChgWT=1;
    var HAWBFreight=1;
    var Shipper=document.form1.txtShipperInfo.value;
     var pos=0;
    pos= Shipper.indexOf("\n");
    if (pos>=0 ) 
        Shipper= Shipper.substring(0,pos) ;
    var Consignee=document.form1.txtConsigneeInfo.value;
    pos=0;
    pos=Consignee.indexOf("\n");
    if (pos>=0)  
        Consignee=Consignee.substring(0,pos);
    var Notify=document.form1.txtNotifyInfo.value;
    pos=0;
    pos=Notify.indexOf("\n");
    if (pos>=0 ) 
        Notify=Notify.substring(0,pos);

    var Pieces=document.form1.txtPCS.value;
    var Desc=document.form1.txtDesc3.value;
    var GrossWT=document.form1.txtGrossWT.value;
    var ChgWT=document.form1.txtChgWT.value;
    var OFTotal=document.form1.txtTotalFC.value;
     if (  self.opener !=null && ! self.opener.closed ){
	        self.opener.document.all("HAWBShipper").item(ItemNo).value=Shipper;
	        self.opener.document.all("HAWBConsignee").item(ItemNo).value=Consignee;
	        self.opener.document.all("HAWBNotify").item(ItemNo).value=Notify;
	        self.opener.document.all("HAWBPieces").item(ItemNo).value=Pieces;
	        self.opener.document.all("HAWBDesc").item(ItemNo).value=Desc;
	        self.opener.document.all("HAWBGrossWT").item(ItemNo).value=GrossWT;
	        self.opener.document.all("HAWBChgWT").item(ItemNo).value=ChgWT;
	        self.opener.document.all("HAWBFreightCollect").item(ItemNo).value=OFTotal;
      }
}

//////////////////////////////////
// Unit_Price by ig 10/21/2006
//////////////////////////////////
function GET_ITEM_UNIT_PRICE(tmpBuf) {
    var ItemUnitPrice, pos;

    ItemUnitPrice = 0;

    var pos = tmpBuf.indexOf("\n");
    if (pos > 0)
        ItemUnitPrice = tmpBuf.substring(pos + 1, 200);

    return ItemUnitPrice;

}

function SET_UNIT_PRICE( obj, val ){
    obj.value = parseFloat(val).toFixed(2); 
}
//////////////////////////////////
</script>
<script type="text/javascript">
function SaveClick(TranNo,PrintOK){
// by iMoon JAN-06-2007	
// modified by Joon on 10-12-2007 yes -> no requested by jonathan
	var apLock= "<%=vApLock %>";
    if (apLock=="true" && PrintOK=="yes" ){
        PrintClick2("no");
	    return false;
    }

    var lock="<%=vArApLock %>";
    if (lock != "Visible" && PrintOK=="yes" ){
        PrintClick2("no");
	    return false;
    }
    
    //if Trim(invoice_no) = "" then
	document.form1.hSaveAsNew.value="Y";
    //end if

    document.getElementById("hDoInvoice").value="no";

   if (document.form1.hConsigneeAcct.value == "" || document.form1.hConsigneeAcct.value == "0" ){
        alert( "Please select a Consignee!");
        return false;
    }
    var MAWB=document.form1.txtMAWB.value;
    var HAWB=document.form1.txtHAWB.value;


    if (MAWB=="" ){
        alert( "Please select a Master Bill of Lading!");
	    return false;
    }

    var PickupDate=document.form1.txtPickupDate.value;

    if (PickupDate!="" ){
        if (!IsDate(PickupDate) ){
            alert( "Please enter a correct Date for Pickup (MM/DD/YYYY)");
            return false;
        }
    }

    //'ITNo=document.form1.txtITNumber.Value
    //'if Not ITNo="" and Not IsNumeric(ITNo) then
    //'	MsgBox "Please enter a numeric value for IT Number"
    //'	Exit Sub
    //'end if
    var NoItem=document.form1.hNoItem.value;
    if (NoItem =="" ){ 
        NoItem=0;
        document.form1.hNoItem.value="0";
        
    }
    var NoCostItem=document.form1.hNoCostItem.value;
    if (NoCostItem =="" ){ 
        NoCostItem=0;
        document.form1.hNoCostItem.value="0";
    }

    for (var j=0 ; j<NoItem; j++){
	     var oAmt=$("input.ItemAmount").get(j).value;
	    if (oAmt=="" )
            oAmt=0;
	    var oItem=$("select.InvoiceItem").get(j).value;
	    if (!IsNumeric(oAmt) ){
            alert( "Please enter a Numeric Value for AMOUNT!");
            return false;
        }
	    if ( oAmt!=0 && oItem=="" ){
            alert( "Please select an Charge Item!");
            return false;
        }
   }
   for (var j=0 ; j<NoCostItem; j++){
	     var oCost = $("input.ItemCost").get(j).value;
        if (oCost=="" )
            oCost=0;
        var oItem = $("select.InvoiceCostItem").get(j).value;
        var oVendor = $("select.ItemVendor").get(j).value;
        if (!IsNumeric(oCost) ){
            alert( "Please enter a Numeric Value for COST!");
            return false;
        }
        if (oCost!=0 && oItem=="" ){
            alert( "Please select an Cost Item!");
            return false;
        }
        if (oVendor==0 && oCost!=0 ){
            alert("Please select a Vendor!");
            return false;
        }
    }

    alert("The form has been saved successfully")
	document.form1.action = encodeURI(
        "arrival_notice.asp?"
        +"NoItem="+NoItem
        +"&NoCostItem="+NoCostItem
        +"&iType=O&tNo=<%=TranNo%>&Save=yes&Print="+ PrintOK);
	document.form1.method="POST";
	document.form1.target="_self";
	form1.submit();
}

function SaveClick2(TranNo,PrintOK){
    var lock="<%=vArApLock %>";
    if (lock != "Visible" && PrintOK == "yes") {
	    PrintClick2("yes");
	    return false;
	}

    document.getElementById("hDoInvoice").value="yes";

    if (document.form1.hConsigneeAcct.value == "" || document.form1.hConsigneeAcct.value == "0") {
       alert("Please select a Consignee!");
	        return false;
	    }
    var MAWB=document.form1.txtMAWB.value;
    var HAWB=document.form1.txtHAWB.value;

    if (MAWB == "") {
	    alert("Please select a Master Bill of Lading!");
	    return false;
    }

    var PickupDate=document.form1.txtPickupDate.value;
    if (PickupDate != "") {
        if (!IsDate(PickupDate)) {
	            alert("Please enter a correct Date for Pickup (MM/DD/YYYY)");
	            return false;
	        }
	    }


    //'ITNo=document.form1.txtITNumber.Value
    //'if Not ITNo="" and Not IsNumeric(ITNo) then
    //'	MsgBox "Please enter a numeric value for IT Number"
    //'	Exit Sub
    //'end if
    var NoItem = document.form1.hNoItem.value;
    if (NoItem =="" ){ 
        NoItem=0;
        document.form1.hNoItem.value="0";
        
    }
    var NoCostItem = document.form1.hNoCostItem.value;
    if (NoCostItem =="" ){ 
        NoCostItem=0;
        document.form1.hNoCostItem.value="0";
    }

    for (var j = 0; j < NoItem; j++) {
	    var oAmt = $("input.ItemAmount").get(j).value;
	    if (oAmt == "")
	        oAmt = 0;
	    var oItem = $("select.InvoiceItem").get(j).value;
	    if (!IsNumeric(oAmt)) {
	        alert("Please enter a Numeric Value for AMOUNT!");
	        return false;
	    }
	    if (oAmt != 0 && oItem == "") {
	        alert("Please select an Charge Item!");
	        return false;
	    }
	}
    for (var j = 0; j < NoCostItem; j++) {
	    var oCost = $("input.ItemCost").get(j).value;
	    if (oCost == "")
	        oCost = 0;
	    var oItem = $("select.InvoiceCostItem").get(j).value;
	    var oVendor = $("select.ItemVendor").get(j).value;
	    if (!IsNumeric(oCost)) {
	        alert("Please enter a Numeric Value for COST!");
	        return false;
	    }
	    if (oCost != 0 && oItem == "") {
	        alert("Please select an Cost Item!");
	        return false;
	    }
	    if (oVendor == 0 && oCost != 0) {
	        alert("Please select a Vendor!");
	        return false;
	    }
	}

	document.form1.action=encodeURI("arrival_notice.asp?"
        +"NoItem="+NoItem
        +"&NoCostItem="+NoCostItem
        +"&iType=O&tNo=<%=TranNo%>&Save=yes&Print=" + PrintOK);
	document.form1.method="POST";
	document.form1.target="_self";
	form1.submit();
}

function SaveClick3(TranNo) {
    var lock = "<%=vArApLock %>";
    if (lock != "Visible" ){
        AuthClick();
        return false;
    }
    
    //if Trim(invoice_no) = "" then
	    document.form1.hSaveAsNew.value="Y";
    //end if

    document.getElementById("hDoInvoice").value="no";
    if( document.form1.hConsigneeAcct.value == ""|| document.form1.hConsigneeAcct.value == "0" ){
        alert( "Please select a Consignee!");
        return false;
    }
    var MAWB = document.form1.txtMAWB.value;
    var HAWB=document.form1.txtHAWB.value;

    if (MAWB == "") {
	        alert("Please select a Master Bill of Lading!");
	        return false;
	}
    var PickupDate = document.form1.txtPickupDate.value;

    if (PickupDate != "") {
	    if (!IsDate(PickupDate)) {
	        alert("Please enter a correct Date for Pickup (MM/DD/YYYY)");
	        return false;
	    }
	}

    //'ITNo=document.form1.txtITNumber.Value
    //'if Not ITNo="" and Not IsNumeric(ITNo) then
    //'	MsgBox "Please enter a numeric value for IT Number"
    //'	Exit Sub
    //'end if
    var NoItem = document.form1.hNoItem.value;
    if (NoItem =="" ){ 
        NoItem=0;
        document.form1.hNoItem.value="0";
    }
    var NoCostItem = document.form1.hNoCostItem.value;
    if (NoCostItem =="" ){ 
        NoCostItem=0;
        document.form1.hNoCostItem.value="0";
    }

    for (var j = 0; j < NoItem; j++) {
	    var oAmt = $("input.ItemAmount").get(j).value;
	    if (oAmt == "")
	        oAmt = 0;
	    var oItem = $("select.InvoiceItem").get(j).value;
	    if (!IsNumeric(oAmt)) {
	        alert("Please enter a Numeric Value for AMOUNT!");
	        return false;
	    }
	    if (oAmt != 0 && oItem == "") {
	        alert("Please select an Charge Item!");
	        return false;
	    }
	}
    for (var j = 0; j < NoCostItem; j++) {
	    var oCost = $("input.ItemCost").get(j).value;
	    if (oCost == "")
	        oCost = 0;
	    var oItem = $("select.InvoiceCostItem").get(j).value;
	    var oVendor = $("select.ItemVendor").get(j).value;
	    if (!IsNumeric(oCost)) {
	        alert("Please enter a Numeric Value for COST!");
	        return false;
	    }
	    if (oCost != 0 && oItem == "") {
	        alert("Please select an Cost Item!");
	        return false;
	    }
	    if (oVendor == 0 && oCost != 0) {
	        alert("Please select a Vendor!");
	        return false;
	    }
	}


	document.form1.action=encodeURI("arrival_notice.asp?"+"NoItem="
        +NoItem+"&NoCostItem="
        +NoCostItem+"&iType=O&tNo=<%=TranNo%>&Save=yes&Auth=yes");
	document.form1.method="POST";
	document.form1.target="_self";
	//msgbox document.form1.action
	form1.submit();
}

function AddItem(){
	var iType="<%= iType %>";
	var NoItem=parseInt(document.form1.hNoItem.value);
	document.form1.hNoItem.value=NoItem+1;
	document.form1.action=encodeURI("arrival_notice.asp?iType=O&tNo=<%=TranNo%>&AddItem=yes");
	document.form1.method="POST";
	document.form1.target="_self";
	form1.submit();
}
function AddCostItem() {
	var iType="<%= iType %>";
	document.form1.hNoCostItem.value = parseInt(document.form1.hNoCostItem.value) + 1;
	document.form1.action=encodeURI("arrival_notice.asp?iType=O&tNo=<%=TranNo%>&AddCostItem=yes");
	document.form1.method="POST";
	document.form1.target="_self";
	form1.submit();
}

function DeleteItem(rNo){
    var iType="<%= iType %>";
   if (confirm("Are you sure you want to delete this item? \r\nContinue?")){
	    document.form1.action=encodeURI("arrival_notice.asp?iType=O&tNo=<%=TranNo%>&Delete=yes&rNo="+ rNo);
	    document.form1.method="POST";
	    document.form1.target="_self";
	    form1.submit();
    }
}

function DeleteCostItem(rNo){
    var iType="O";
    if (confirm("Are you sure you want to delete this item? \r\nContinue?")){
	    document.form1.action=encodeURI("arrival_notice.asp?iType=O&tNo=<%=TranNo%>&DeleteCost=yes&rNo=" + rNo);
	    document.form1.method="POST";
	    document.form1.target="_self";
	    form1.submit();
    }
}

function ItemChange(rNo){
    var sIndex = $("select.InvoiceItem").get(rNo).selectedIndex;
    var itemInfo = $("select.InvoiceItem").get(rNo).value;
    if (sIndex==1 )
	    window.open (encodeURI("../acct_tasks/edit_ch_items.asp") ,"PopupWin", "<%=StrWindow %>");
    else{
	    var pos=0;
	    pos=itemInfo.indexOf("\n");
	    if( pos>=0 ){
		    var Desc=itemInfo.substring(pos+1,100);
		
		    // Unit_Price by ig 10/21/2006
		    var ItemUnitPrice= GET_ITEM_UNIT_PRICE ( Desc );

		   pos=Desc.indexOf("\n");
		    if (pos>=0 )
			    Desc=Desc.substring(0,pos ); 

		    $("input.ItemDesc").get(rNo).value=Desc.trim();
		
		    // Unit_Price by ig 10/21/2006
		    SET_UNIT_PRICE ( $("input.ItemAmount").get(rNo) , ItemUnitPrice );
	    }
    }
}

function ItemCostChange(rNo){
    var sIndex=$("select.InvoiceCostItem").get(rNo).selectedIndex;
    var itemInfo = $("select.InvoiceCostItem").get(rNo).value;
    if (sIndex==1 ) { // add new item
        window.open ("../acct_tasks/edit_co_items.asp" ,"PopupWin", "<%=StrWindow %>");
    }
    else{
	    var pos=itemInfo.indexOf("\n");
	    if (pos>=0 ){
		    var Desc=itemInfo.substring(pos+1,100);
		
		    // Unit_Price by ig 10/21/2006
		    var ItemUnitPrice = GET_ITEM_UNIT_PRICE ( Desc );
    		pos=Desc.indexOf("\n");
		   if (pos>=0 )
			    Desc=Desc.substring(0,pos ); 
		
		     $("input.ItemCostDesc").get(rNo).value=Desc.trim();
		
		    // Unit_Price by ig 10/21/2006
		    SET_UNIT_PRICE ( $("input.ItemCost").get(rNo) , ItemUnitPrice );
		
	    }
    }
}

function CostChange(ItemNo){
	var tCost= $("input.ItemCost").get(ItemNo).value;
	if ( tCost!="" ){
	    if (!IsNumeric(tCost)){
		    alert( "Please enter a numeric number!");
		    obj.value=0;
		    return false;
	    }
    }
	var NoItem=parseInt(document.form1.hNoCostItem.value);
	var TotalCost=0;
    for (var j=0 ; j< NoItem; j++){
	    var Cost=$("input.ItemCost").get(j).value;
	    if (Cost=="" )
		    Cost=0;
	    else
		    Cost=parseFloat(Cost);

	    TotalCost=TotalCost+Cost;
    }
	document.form1.txtTotalCost.value = parseFloat(TotalCost).toFixed(2);
}

function AmountChange(ItemNo){
	var NoItem=parseInt(document.form1.hNoItem.value);
	
	var tAmount=0;
	var FCAmount=document.form1.txtTotalFC.value;
		
	if (FCAmount=="" || IsNumeric(FCAmount)==false  ){ 
		document.form1.txtTotalFC.value=0;
		FCAmount="0";
    }
	else 
		FCAmount=parseFloat(FCAmount);

	if ( parseInt(NoItem)>0 ){
		if (ItemNo!=1000){ 
	
		    if (!IsNumeric(tAmount)) {
			    alert("Please enter a numeric number!");
			    $("input.ItemAmount").get(ItemNo).value=0;
			    return false;
		    }
		    tAmount=$("input.ItemAmount").get(ItemNo).value;
        }

		var TotalAmount=0;
		for (var j=0; j< NoItem; j++){
		    var Amount=$("input.ItemAmount").get(j).value;
		    if (Amount=="" )
			    Amount=0;
		    else
			    Amount=parseFloat(Amount);

		    TotalAmount=TotalAmount+Amount;
	    }
		var collect=document.form1.hIsCollect.value;
	    if (collect=="Y") 	
	        document.form1.txtTotalAmount.value=parseFloat(TotalAmount+FCAmount).toFixed(2);
	    else 
	        document.form1.txtTotalAmount.value=parseFloat(TotalAmount).toFixed(2); 
	
	}
}

function FindByInvoiceNo(txtBox){
	var iType="O";
	var InvoiceNo=document.getElementById(txtBox).value;
	if (InvoiceNo == "" || !IsNumeric(InvoiceNo)) {
        alert("Please enter a numeric value!");
        return false;
    }

	document.form1.action=encodeURI("arrival_notice.asp?iType=" 
        + "O"+ "&tNo=<%=TranNo%>&Search=yes&InvoiceNo=" + InvoiceNo);
	document.form1.method="POST";
	document.form1.target="_self";
	form1.submit();
}

function PrintClick(){
	var iType="O";
	var Sec = document.form1.hSec.value;
    var HAWB = document.form1.txtHAWB.value;
    var MAWB = document.form1.txtMAWB.value;
	var AgentOrgAcct = document.form1.hAgentOrgAcct.value;

	document.form1.action=encodeURI("arrival_notice_pdf.asp?iType=" 
        + iType + "&HAWB=" + HAWB+"&MAWB="+MAWB+ "&Sec=" + Sec +"&AgentOrgAcct="+ AgentOrgAcct+ "&invoice_no=<%=InvoiceNo%>"+"&doInvoice=<%=doInvoice %>");
	document.form1.method="POST";
	document.form1.target="_self";
	form1.submit();
}


function PrintClick2(doInvoice) {
    var iType="O";
    var Sec = document.form1.hSec.value;
    var HAWB = document.form1.txtHAWB.value;
    var MAWB = document.form1.txtMAWB.value;
  
    var AgentOrgAcct = document.form1.hAgentOrgAcct.value;
   
    document.form1.action=encodeURI("arrival_notice_pdf.asp?iType=" + iType
    + "&HAWB="+ HAWB+"&MAWB="+MAWB+ "&Sec=" + Sec + "&AgentOrgAcct="+ AgentOrgAcct+ "&invoice_no=<%=InvoiceNo%>&doInvoice="+doInvoice);
    document.form1.method="POST";
    document.form1.target="_self";
    form1.submit();
}

function AuthClick() {
    var iType="O";
    var Sec = document.form1.hSec.value;
    var HAWB = document.form1.txtHAWB.value;
    var AgentOrgAcct = document.form1.hAgentOrgAcct.value;

	document.form1.action=encodeURI("AuthorityMakeEntry_pdf.asp?iType=" + iType 
    + "&HAWB=" + HAWB+"&invoice_no=<%=InvoiceNo%>"+ "&Sec=" + Sec + "&AgentOrgAcct=" + AgentOrgAcct);
	document.form1.method="POST";
	document.form1.target="_self";
	form1.submit();
}


function PrePaidSelected(){
    document.form1.rdCollect.checked="";
    document.form1.rdPrepaid.checked=true;
    document.form1.hIsCollect.value="N";
	
}

function FCCollected(){
     document.form1.rdCollect.checked=true;
     document.form1.rdPrepaid.checked="";
     document.form1.hIsCollect.value="Y";
}

function eltMsgBox(Msg){
    return confrim (Msg);
}

function AddHAWB(){
     var MAWB, AgentOrgAcct;
    HAWB="<%=vHAWB %>";
    MAWB="<%=vMAWB %>";
    AgentOrgAcct="<%=vAgentOrgAcct %>";
    
	document.form1.action=encodeURI("arrival_notice.asp?iType=O&NewHAWB=yes&Sec=1&MAWB="+ MAWB +"&AgentOrgAcct="+ AgentOrgAcct);
	document.form1.target="_self";
	document.form1.method="POST";
	form1.submit();
}

function DeleteHAWB(){
    var InvoiceNo, HAWB, MAWB;
    InvoiceNo="<%=InvoiceNo%>";
    HAWB="<%=vHAWB %>";
    MAWB="<%=vMAWB %>";
	if (confirm("Are you sure you want to delete this Arrival Notice? \r\nContinue?")) {   
		document.form1.action=encodeURI("arrival_notice.asp?iType=O&DeleteHAWB=yes&MAWB="+ MAWB + "&HAWB="+ HAWB+"&InvoiceNo=" + InvoiceNo + "&tNo=<%=TranNo%>");
		document.form1.target="_self";
		document.form1.method="POST";
		form1.submit();
	}
}

</script>
<!--  #include file="../include/recent_file.asp" -->
<body link="336699" vlink="336699" topmargin="0">
    <div id="tooltipcontent">
    </div>
    <form name="form1" onkeydown="docModified('true');">
    <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
        <tr>
            <td width="35%" height="32" align="left" valign="middle" class="pageheader">
                Arrival Notice &amp; Freight Invoice
            </td>
            <td width="65%" align="right" valign="middle">
                <table border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td width="50%" height="27" align="right" valign="middle">
                            <img src="../Images/spacer.gif" width="1" height="27" align="absmiddle">
                            <select name="select" class="bodyheader" id="SearchType" onchange="selectSearchType();"
                                style="width: 140px">
                                <option value="arrivalNo" selected="selected">ARRIVAL NOTICE NO.</option>
                                <option value="houseNo">HOUSE B/L NO.</option>
                                <option value="masterNo">MASTER B/L NO.</option>
                            </select>
                        </td>
                        <td width="50%" align="right" valign="middle">
                            <div id="searcharrival">
                                <span class="bodyheader style4">
                                    <input name="txtFindIV"  id="txtFindIV" type="text" class="lookup" style="width: 120px" value="Arrival No. Here"
                                        onfocus="javascript: this.value=''; this.style.color='#000000'; " onkeypress="javascript: if(event.keyCode == 13) { FindByInvoiceNo('txtFindIV'); }">
                                    <img src="../images/icon_search.gif" name="B1" width="33" height="27" align="absmiddle"
                                        style="cursor: hand" onclick="FindByInvoiceNo('txtFindIV')"></span>
                            </div>
                            <div id="searchhouse" style="display: none">
                                <span class="bodyheader style4">
                                    <input name="txtFindByHAWB" id="txtFindByHAWB" type="text" class="lookup" style="width: 120px" value="House No. Here"
                                        onfocus="javascript: this.value=''; this.style.color='#000000'; " onkeypress="javascript: if(event.keyCode == 13) { GetHAWBList('HAWB'); }">
                                    <img src="../images/icon_search.gif" name="B1" width="33" height="27" align="absmiddle"
                                        style="cursor: hand" onclick="GetHAWBList('HAWB')"></span>
                            </div>
                            <div id="searchmaster" style="display: none">
                                <span class="bodyheader style4">
                                    <input name="txtFindByMAWB" id="txtFindByMAWB" type="text" class="lookup" style="width: 120px" value="Master No. Here"
                                        onfocus="javascript: this.value=''; this.style.color='#000000'; " onkeypress="javascript: if(event.keyCode == 13) { GetHAWBList('MAWB'); }">
                                    <img src="../images/icon_search.gif" name="B1" width="33" height="27" align="absmiddle"
                                        style="cursor: hand" onclick="GetHAWBList('MAWB')"></span>
                            </div>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <div class="selectarea">
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td width="37%" valign="bottom">
                </td>
                <td width="63%" align="right" valign="bottom">
                    <div id="div">
                        <div id="print">
                            <img src="/ASP/Images/icon_printer.gif" align="absbottom"><a href="javascript:;"
                                onclick="if(CheckIfANExist()==true) { SaveClick('<%= TranNo %>','yes') };return false;">Arrival
                                Notice</a><img src="/ASP/Images/button_devider.gif"><a href="javascript:;" onclick="if(CheckIfANExist()==true) {SaveClick2('<%= TranNo %>','yes')};return false;">Arrival
                                    Notice & Freight Invoice</a><img src="/ASP/Images/button_devider.gif"><a href="javascript:;"
                                        onclick="SaveClick3('<%= TranNo %>');return false;">Release Order</a></div>
                    </div>
                </td>
            </tr>
        </table>
    </div>
    <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#909EB0">
        <tr>
            <td>
                <input type="hidden" name="scrollPositionX" />
                <input type="hidden" name="scrollPositionY" />
                <input name="isDocBeingModified" id="isDocBeingModified" type="hidden">
                <input name="hArApLock" type="hidden" value="<%= vArApLock %>" />
                <input id="hSavingCondition" name="hSavingCondition" type="hidden" />
                <input name="hIsCollect" type="hidden" value="<%= IsCollect %>">
                <input name="hPostBack" type="hidden" value="<%= vPostBack %>">
                <input name="hSaveAsNew" type="hidden" value="<%= vSaveAsNew %>">
                <input name="FROM_EDIT" type="hidden" value="<%= FROM_EDIT %>">
                <input type="hidden" name="hAgentOrgAcct" id="hAgentOrgAcct" value="<%= vAgentOrgAcct %>">
                <input type="hidden" name="hSec" id="hSec" value="<%= vSec %>">
                <input type="hidden" name="hNoItem" value="<%= NoItem %>">
                <input type="hidden" name="hNoCostItem" value="<%= NoCostItem %>">
                <input type="hidden" name="hInvoiceNo" value="<%= InvoiceNo %>">
                <input type="hidden" name="hGrossWT" value="<%= vGrossWT %>">
                <input type="hidden" name="hItemNo" value="<%= vOpenPageItemNo %>">
                <table width="100%" border="0" cellpadding="2" cellspacing="1">
                    <tr bgcolor="CFD6DF">
                        <td width="78%" height="22" align="center" valign="middle" bgcolor="CFD6DF" class="bodyheader">
                            <table width="98%" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td width="26%" align="center">
                                        &nbsp;
                                    </td>
                                    <td width="48%" align="center">
                                        <img height="18" name="bSave" onclick="if(CheckIfANExist()==true) {SaveClick('<%= TranNo %>','no')} "
                                            src="../images/button_save_medium.gif" style="cursor: hand" width="46">
                                        <input type="hidden" name="hDoInvoice" id="hDoInvoice" value='yes' />
                                    </td>
                                    <td width="13%" align="right">
                                        <img style="cursor: hand" src="/ASP/Images/button_new.gif" width="42" height="17"
                                            onclick="AddHAWB()">
                                    </td>
                                    <td width="13%" align="right">
                                        <img style="cursor: hand; visibility: <%=vArApLock %>" src="/iff_main/Images/button_delete_medium.gif"
                                            onclick="DeleteHAWB()">
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr align="center" valign="middle" bgcolor="DFE1E6">
                        <td height="24" align="center" bgcolor="#F3F3F3" class="bodyheader">
                            <br>
                            <br>
                            <table width="90%" border="0" cellpadding="0" cellspacing="0" class="bodyheader">
                                <tr>
                                    <td height="28" align="right">
                                        <img src="/ASP/Images/required.gif" align="absbottom">Required field
                                    </td>
                                </tr>
                            </table>
                            <table width="90%" border="0" cellpadding="2" cellspacing="0" bordercolor="909EB0"
                                bgcolor="CFD6DF" class="border1px">
                                <tr align="left" valign="middle" bgcolor="DFE1E6">
                                    <td align="left" valign="middle">
                                        &nbsp;
                                    </td>
                                    <td height="20" align="left" valign="middle" bgcolor="DFE1E6">
                                        &nbsp;
                                    </td>
                                    <td>
                                        <strong><span class="style5">Arrival Notice No.</span>&nbsp;&nbsp;</strong>
                                    </td>
                                    <td>
                                        <strong>File No.&nbsp;&nbsp;</strong>
                                    </td>
                                </tr>
                                <tr align="left" valign="middle" bgcolor="#ffffff">
                                    <td align="left" valign="middle">
                                        &nbsp;
                                    </td>
                                    <td height="20" align="left" valign="middle">
                                        &nbsp;
                                    </td>
                                    <td>
                                        <strong>
                                            <input name="txtInvoiceNo" type="text" class="readonlybold" value="<%= InvoiceNo %>"
                                                size="24" readonly>
                                        </strong>
                                        <br>
                                        <br>
                                        <%if InvoiceNo<>"" then response.Write("<img src='/ASP/Images/icon_goto.gif'><span class='goto'><a href='javascript:void(goInvoice());'>Go to Invoice</a></span>") end if %>
                                    </td>
                                    <td valign="top" bgcolor="#ffffff">
                                        <strong>
                                            <input name="txtRefNo" id="txtRefNo" type="text" class="readonlybold" value="<%= vFileNo %>" size="24"
                                                readonly="true">
                                        </strong>
                                    </td>
                                </tr>
                                <tr>
                                    <td height="2" colspan="4" align="left" valign="middle" bgcolor="909EB0">
                                    </td>
                                </tr>
                                <tr bgcolor="#DFE1E6">
                                    <td align="left" valign="middle">
                                        &nbsp;
                                    </td>
                                    <td height="20" align="left" valign="middle" bgcolor="#DFE1E6">
                                        <b>Shipper</b>
                                    </td>
                                    <td width="24%" align="left" valign="middle" bgcolor="#DFE1E6">
                                        <strong class="bodyheader style3">
                                            <img src="/ASP/Images/required.gif" align="absbottom">Master B/L No.<span class="style8"><strong>
                                                <% if mode_begin then %>
                                            </strong></span></strong>
                                        <div style="width: 21px; display: inline; vertical-align: middle" onmouseover="showtip('This Field is to select previously entered Master B/L Numbers for the purpose of adding a new house to that Deconsolidation.  The relevant Master Bill data will be automatically populated here on the A/N.');"
                                            onmouseout="hidetip()">
                                            <img src="../Images/button_info.gif" align="middle" class="bodylistheader"></div>
                                        <% end if %>
                                    </td>
                                    <td align="left" valign="middle" bgcolor="DFE1E6">
                                        <span class="style3"><strong>House B/L No.</strong></span>
                                    </td>
                                </tr>
                                <tr bgcolor="#FFFFFF">
                                    <td width="1%" rowspan="3" align="left" valign="top">
                                        &nbsp;
                                    </td>
                                    <td width="50%" rowspan="3" align="left" valign="top">
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
                                        <textarea id="txtShipperInfo" name="txtShipperInfo" class="multilinetextfield" cols=""
                                            rows="5" style="width: 300px"><%=vShipperInfo %></textarea>
                                        <!-- End JPED -->
                                    </td>
                                    <td height="20" align="left" valign="top" bgcolor="#FFFFFF">
                                        <input name="txtMAWB" id="txtMAWB" type="hidden" class="d_shorttextfield" value="<%= vMAWB %>"
                                            size="24" readonly>
                                        <!-- //Start of Combobox// -->
                                        <%  iMoonDefaultValue = vMAWB %>
                                        <%  iMoonComboBoxName =  "lstMAWB" %>
                                        <%  iMoonComboBoxWidth =  "156px" %>
                                        <script language="javascript"> 
function <%=iMoonComboBoxName%>_OnChangePlus() 
{ 
    var slt=$("select.lstMAWB>option");
    var index=document.getElementById("lstMAWB").selectedIndex; 
    document.getElementById("txtMAWB").value=slt.get(index).text;
    lstMAWBChange_ocean(document.getElementById("txtMAWB").value); 
}
function lstMAWB_OnAddNewPlus(){};
                                        </script>
                                        <!-- start of MBOL Number mode change -->
                                        <% if vArApLock = "Visible" then %>
                                        <div id="<%=iMoonComboBoxName%>_Container" class="ComboBox" style="width: <%=iMoonComboBoxWidth%>;
                                            position: ; top: ; left: ; z-index: ;">
                                            <input name="<%=iMoonComboBoxName%>:Text" type="text" id="<%=iMoonComboBoxName%>_Text"
                                                class="ComboBox" autocomplete="off" style="width: <%=iMoonComboBoxWidth%>; vertical-align: middle"
                                                value="<%=iMoonDefaultValue%>" />
                                            <div id="<%=iMoonComboBoxName%>_Div" style="display: none; position: absolute; top: 0;
                                                left: -140; width: 17px">
                                                <img id="<%=iMoonComboBoxName%>_Button" src="/ig_common/Images/combobox_drop.gif"
                                                    border="0" />
                                            </div>
                                        </div>
                                        <div id="<%=iMoonComboBoxName%>_NewDiv" style="display: none; position: absolute;
                                            top: 0; left: 0; width: 17px">
                                            <img id="<%=iMoonComboBoxName%>_AddNewButton" src="/ig_common/Images/combobox_addnew.gif"
                                                border="0" />
                                        </div>
                                        <% else %>
                                        <div id="<%=iMoonComboBoxName%>_Container" class="ComboBox" style="width: <%=iMoonComboBoxWidth%>;
                                            position: ; top: ; left: ; z-index: ;">
                                            <input name="<%=iMoonComboBoxName%>:Text" type="text" id="<%=iMoonComboBoxName%>_Text"
                                                class="ComboBox" autocomplete="off" style="width: <%=iMoonComboBoxWidth%>; vertical-align: middle;
                                                background-color: #CCCCCC" value="<%=iMoonDefaultValue%>" readonly="true" /></div>
                                        <div id="<%=iMoonComboBoxName%>_NewDiv" style="display: none; position: absolute;
                                            top: 0; left: 0; width: 17px">
                                        </div>
                                        <% END IF %>
                                        <!-- start of MBOL Number mode change -->
                                        <select name="lstMAWB" id="lstMAWB" listsize="20" class="ComboBox lstMAWB" style="width: 160px;
                                            display: none" tabindex="3" onchange="ComboBox_SimpleAttach(this, this.form['<%=iMoonComboBoxName%>_Text'])">
                                            <option value=""></option>
                                            <% For i=0 To aMAWB.count-1%>
                                            <option value="<%= aMAWB(i) %>" <%if vMAWB= aMAWB(i) then response.write("selected")  %>>
                                                <%
= aMAWB(i) %>
                                            </option>
                                            <%  Next  %>
                                        </select>
                                        <!-- /End of Combobox/ -->
                                        <script type="text/javascript">
                                            function trim(sourceString) { return sourceString.replace(/(?:^\s+|\s+$)/ig, ""); }

                                            function goDeconsol() {
                                                try {
                                                    // Tab move to International
//                                                    if (window.opener != null) { window.opener.parent.document.frames['topFrame'].changeTopModule("International"); }
//                                                    else { parent.document.frames['topFrame'].changeTopModule("International"); }

                                                    var mawb = document.getElementById("lstMAWB_Text").value;
                                                    if (trim(mawb) == '') {
                                                        alert('Please select a Master B/L No.');

                                                    } else {
                                                        var sec = document.form1.hSec.value;
                                                        var url = 'iType=O&Edit=yes&MAWB=' + mawb + '&Sec=' + sec + '&AgentOrgAcct=' + document.form1.hAgentOrgAcct.value;

                                                        var branch = '<%=headBranch%>';
                                                        if (branch != '') {
                                                            url += '&Branch=' + branch;
                                                        }
                                                        if (opener) {
                                                            opener.parent.location.href = "../../OceanImport/Deconsolidation/" + encodeURI(url);
                                                        } else {
                                                            parent.location.href = "../../OceanImport/Deconsolidation/" + encodeURI(url);
                                                        }
                                                        //                                                    if (opener) {
                                                        //                                                        opener.location = encodeURI(url);
                                                        //                                                    } else {
                                                        //                                                        self.location = encodeURI(url);
                                                        //                                                    }
                                                    }
                                                } catch (f) { }
                                            }

                                            function trim(sourceString) { return sourceString.replace(/(?:^\s+|\s+$)/ig, ""); }
					
                                            function goInvoice() {
                                                try {
                                                    // Tab move to accounting
//                                                    if (window.opener != null) { window.opener.parent.document.frames['topFrame'].changeTopModule("Accounting"); }
//                                                    else { parent.document.frames['topFrame'].changeTopModule("Accounting"); }

                                                    var invoice = document.getElementById("txtInvoiceNo").value;
                                                    if (trim(invoice) != '') {
                                                       

                                                        var url = 'edit=yes&InvoiceNo=' + invoice;

                                                        var branch = '<%=headBranch%>';
                                                        if (branch != '') {
                                                            url += '&Branch=' + branch;
                                                        }
                                                        if (opener) {
                                                            opener.parent.location.href = "../../Accounting/AddInvoice/" + encodeURI(url);
                                                        } else {
                                                            parent.location.href = "../../Accounting/AddInvoice/" + encodeURI(url);
                                                        }

                                                    }
                                                } catch (f) { }

                                            }
                                        </script>
                                        <br>
                                        <span class="goto">
                                            <img src="/ASP/Images/icon_goto.gif" width="36" height="21" align="absbottom"><a
                                                href="javascript:void(goDeconsol());">Go to Deconsolidation</a></span>
                                    </td>
                                    <td align="left" valign="top" bgcolor="#FFFFFF">
                                        <% if vArApLock = "Visible" then 
                        response.Write(" <input class='bodyheader' name='txtHAWB' id='txtHAWB' size='30' type='text' value='"& vHAWB&"'/>")
                     else
                       response.Write(" <input class='readonlybold' name='txtHAWB' id='txtHAWB' readonly size='30' type='text' value='"& vHAWB&"'/>")
                     end if                   
                                        %>
                                    </td>
                                </tr>
                                <tr bgcolor="#F3f3f3">
                                    <td height="20" align="left" valign="middle" bgcolor="#f3f3f3">
                                        <strong>Sub B/L No.</strong>
                                    </td>
                                    <td align="left" valign="middle" bgcolor="#f3f3f3">
                                        <strong>AMS B/L No. </strong>
                                    </td>
                                </tr>
                                <tr bgcolor="#F3f3f3">
                                    <td height="20" align="left" valign="top" bgcolor="#FFFFFF">
                                        <input name="txtSubMAWB" id="txtSubMAWB" type="text" maxlength="32" class="shorttextfield" value="<%= vSubMAWB %>"
                                            size="24">
                                    </td>
                                    <td align="left" valign="top" bgcolor="#FFFFFF">
                                        <input name="txtSubMAWB2" id="txtSubMAWB2" type="text" maxlength="32" class="shorttextfield" value="<%= vSubMAWB2 %>"
                                            size="24">
                                    </td>
                                </tr>
                                <tr bgcolor="DFE1E6">
                                    <td align="left" valign="middle">
                                        &nbsp;
                                    </td>
                                    <td height="20" align="left" valign="middle">
                                        <strong>
                                            <img src="/ASP/Images/required.gif" align="absbottom">Consignee</strong>
                                    </td>
                                    <td align="left" valign="middle">
                                        <strong>Date</strong>
                                    </td>
                                    <td align="left" valign="middle" bgcolor="#DFE1E6">
                                        <strong>Doc. Pickup Date</strong>
                                    </td>
                                </tr>
                                <tr bgcolor="#F3f3f3">
                                    <td rowspan="4" align="left" valign="top" bgcolor="#FFFFFF">
                                        &nbsp;
                                    </td>
                                    <td rowspan="4" align="left" valign="top" bgcolor="#FFFFFF">
                                        <!-- Start JPED -->
                                        <input type="hidden" id="hConsigneeAcct" name="hConsigneeAcct" value="<%=vConsigneeAcct %>" />
                                        <div id="lstConsigneeNameDiv">
                                        </div>
                                        <table cellpadding="0" cellspacing="0" border="0" id="tblConsignee"><tr><td><input type="text" autocomplete="off" id="lstConsigneeName" name="lstConsigneeName" value="<%=vConsigneeName %>" class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Consignee','lstConsigneeNameChange',null,event)"  onfocus="initializeJPEDField(this,event);" /></td><td><img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstConsigneeName','Consignee','lstConsigneeNameChange',null,event)"
                                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                        border-left: 0px solid #7F9DB9; cursor: hand;" />
                                                </td>
                                                <td>
                                                    <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                        onclick="quickAddClient('hConsigneeAcct','lstConsigneeName','txtConsigneeInfo')" />
                                                </td>
                                            </tr>
                                        </table>
                                        <textarea id="txtConsigneeInfo" name="txtConsigneeInfo" class="multilinetextfield"
                                            cols="" rows="5" style="width: 300px"><%=vConsigneeInfo %></textarea>
                                        <!-- End JPED -->
                                        <% If vArLock Then %>
                                        <script type="text/jscript">
                                            makeAllReadOnly(document.getElementById("tblConsignee"));
                                            document.getElementById("lstConsigneeName").style.backgroundColor = "#cdcdcd";
                                        </script>
                                        <% End If %>
                                    </td>
                                    <td height="20" align="left" valign="middle" bgcolor="#FFFFFF">
                                        <input name="txtDate" type="text" class="m_shorttextfield " 
                                             value="<%= vProcessDT %>"
                                            size="24" id="txtDate">
                                    </td>
                                    <td align="left" valign="middle" bgcolor="#FFFFFF">
                                        <input name="txtPickupDate" type="text" class="m_shorttextfield " 
                                            value="<%= vPickupDate %>" size="24" id="txtPickupDate">
                                    </td>
                                </tr>
                                <tr bgcolor="#F3f3f3">
                                    <td height="20" align="left" valign="middle" bgcolor="#f3f3f3">
                                        <strong>Customer Reference No.</strong>
                                    </td>
                                    <td align="left" valign="middle" bgcolor="#f3f3f3">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr bgcolor="#F3f3f3">
                                    <td height="20" align="left" valign="top" bgcolor="#FFFFFF">
                                        <input name="txtCustomerRef" type="text" maxlength="64" class="shorttextfield" value="<%= vCustomerRef %>"
                                            size="24" id="txtCustomerRef">
                                    </td>
                                    <td align="left" valign="top" bgcolor="#FFFFFF">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr bgcolor="#F3f3f3">
                                    <td height="20" align="left" valign="top" bgcolor="#FFFFFF">
                                        &nbsp;
                                    </td>
                                    <td align="left" valign="top" bgcolor="#FFFFFF">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr bgcolor="DFE1E6">
                                    <td align="left" valign="middle">
                                        &nbsp;
                                    </td>
                                    <td height="20" align="left" valign="middle">
                                        <strong>Notify Party</strong>
                                    </td>
                                    <td align="left" valign="middle">
                                        <strong>Vessel Name</strong>
                                    </td>
                                    <td align="left" valign="middle">
                                        <strong>Voyage No.</strong>
                                    </td>
                                </tr>
                                <tr bgcolor="#FFFFFF">
                                    <td rowspan="4" align="left" valign="top">
                                        &nbsp;
                                    </td>
                                    <td rowspan="4" align="left" valign="top">
                                        <!-- Start JPED -->
                                        <input type="hidden" id="hNotifyAcct" name="hNotifyAcct" value="<%=vNotifyAcct %>" />
                                        <div id="lstNotifyNameDiv">
                                        </div>
                                        <table cellpadding="0" cellspacing="0" border="0">
                                            <tr>
                                                <td>
                                                    <input type="text" autocomplete="off" id="lstNotifyName" name="lstNotifyName" value="<%=vNotifyName %>"
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
                                                        onclick="quickAddClient('hNotifyAcct','lstNotifyName','txtNotifyInfo')" />
                                                </td>
                                            </tr>
                                        </table>
                                        <textarea id="txtNotifyInfo" name="txtNotifyInfo" class="multilinetextfield" cols=""
                                            rows="5" style="width: 300px"><%=vNotifyInfo %></textarea>
                                        <!-- End JPED -->
                                    </td>
                                    <td height="20" align="left" valign="middle" bgcolor="#FFFFFF">
                                        <input name="txtVessel" id="txtVessel" type="text" class="d_shorttextfield" value="<%= vVessel %>"
                                            size="30" readonly="true">
                                    </td>
                                    <td align="left" valign="middle" bgcolor="#FFFFFF">
                                        <input name="txtVoyageNo" id="txtVoyageNo" type="text" class="d_shorttextfield" value="<%= vVoyageNo %>"
                                            size="24" readonly="true">
                                    </td>
                                </tr>
                                <tr bgcolor="#F3f3f3">
                                    <td height="20" align="left" valign="middle" bgcolor="#f3f3f3">
                                        <strong>Port of Loading</strong>
                                    </td>
                                    <td width="25%" align="left" valign="middle" bgcolor="#f3f3f3">
                                        <strong>ETD</strong>
                                    </td>
                                </tr>
                                <tr bgcolor="#F3f3f3">
                                    <td height="20" align="left" valign="top" bgcolor="#FFFFFF">
                                        <span class="smallselect">
                                            <select name="lstDepPort" id="lstDepPort" onchange="doDepPortChange(this)" class="smallselect" style="width: 160px">
                                                <% for i=0 to port_list.count-1 %>
                                                <option value='<%=port_list(i)("port_code")%>' <% if vDepCode=port_list(i)("port_code") then response.write(" selected")%>>
                                                    <%= port_list(i)("port_desc") %>
                                                </option>
                                                <% next %>
                                            </select>
                                        </span>
                                    </td>
                                    <td align="left" valign="top" bgcolor="#FFFFFF">
                                        <input name="txtETD" id="txtETD" type="text" class="m_shorttextfield "  value="<%= vETD %>"
                                            size="24">
                                    </td>
                                </tr>
                                <tr bgcolor="#F3f3f3">
                                    <td height="20" align="left" valign="top" bgcolor="#FFFFFF">
                                        &nbsp;
                                    </td>
                                    <td align="left" valign="top" bgcolor="#FFFFFF">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr bgcolor="DFE1E6">
                                    <td align="left" valign="middle">
                                        &nbsp;
                                    </td>
                                    <td height="20" align="left" valign="middle">
                                        <strong>Broker</strong>
                                    </td>
                                    <td align="left" valign="middle" bgcolor="DFE1E6">
                                        <strong>Port of Discharge</strong>
                                    </td>
                                    <td align="left" valign="middle">
                                        <strong>ETA</strong>
                                    </td>
                                </tr>
                                <tr bgcolor="#F3f3f3">
                                    <td rowspan="5" align="left" valign="top" bgcolor="#FFFFFF">
                                        &nbsp;
                                    </td>
                                    <td align="left" rowspan="5" valign="top" bgcolor="#FFFFFF">
                                        <!-- Start JPED -->
                                        <input type="hidden" id="hBrokerAcct" name="hBrokerAcct" value="<%=vBrokerAcct %>" />
                                        <div id="lstBrokerNameDiv">
                                        </div>
                                        <table cellpadding="0" cellspacing="0" border="0">
                                            <tr>
                                                <td>
                                                    <input type="text" autocomplete="off" id="lstBrokerName" name="lstBrokerName" value="<%=vBrokerName %>"
                                                        class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                        border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Broker','lstBrokerNameChange',null,event)"
                                                        onfocus="initializeJPEDField(this,event);" />
                                                </td>
                                                <td>
                                                    <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstBrokerName','Broker','lstBrokerNameChange',null,event)"
                                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                        border-left: 0px solid #7F9DB9; cursor: hand;" />
                                                </td>
                                                <td>
                                                    <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                        onclick="quickAddClient('hBrokerAcct','lstBrokerName','txtBrokerInfo')" />
                                                </td>
                                            </tr>
                                        </table>
                                        <textarea id="txtBrokerInfo" name="txtBrokerInfo" class="multilinetextfield" cols=""
                                            rows="5" style="width: 300px"><%=vBrokerInfo %></textarea>
                                        <!-- End JPED -->
                                    </td>
                                    <td height="20" align="left" valign="middle" bgcolor="#FFFFFF">
                                        <select name="lstArrPort" id="lstArrPort" onchange="doArrPortChange(this)" class="smallselect" style="width: 160px">
                                            <% for i=0 to port_list.count-1 %>
                                            <option value='<%=port_list(i)("port_code")%>' <% 
 if vArrCode=port_list(i)("port_code") then response.write(" selected")%>>
                                                <%= port_list(i)("port_desc") %>
                                            </option>
                                            <% next %>
                                        </select>
                                    </td>
                                    <td align="left" valign="middle" bgcolor="#FFFFFF">
                                        <input name="txtETA" id="txtETA" type="text"  class="m_shorttextfield " value="<%= vETA %>"
                                            size="24">
                                    </td>
                                </tr>
                                <tr bgcolor="#F3f3f3">
                                    <td height="20" align="left" valign="middle" bgcolor="#f3f3f3">
                                        <strong>Place of Delivery</strong>
                                    </td>
                                    <td align="left" valign="middle" bgcolor="#f3f3f3">
                                        <strong>ETA</strong>
                                    </td>
                                </tr>
                                <tr bgcolor="#F3f3f3">
                                    <td height="20" align="left" valign="middle" bgcolor="#FFFFFF">
                                        <input name="txtDeliveryPlace" id="txtDeliveryPlace" type="text" maxlength="64" class="shorttextfield"
                                            value="<%= vDeliveryPlace %>" size="30">
                                    </td>
                                    <td align="left" valign="middle" bgcolor="#FFFFFF">
                                        <input name="txtETD2" id="txtETD2" type="text" class="m_shorttextfield "  value="<%= vETD2 %>"
                                            size="24">
                                    </td>
                                </tr>
                                <tr bgcolor="#F3f3f3">
                                    <td height="20" align="left" valign="middle" bgcolor="#f3f3f3">
                                        <strong>Final Destination</strong>
                                    </td>
                                    <td align="left" valign="middle" bgcolor="#f3f3f3">
                                        <strong>ETA</strong>
                                    </td>
                                </tr>
                                <tr bgcolor="#F3f3f3">
                                    <td height="20" align="left" valign="middle" bgcolor="#FFFFFF">
                                        <input name="txtDestination" id="txtDestination" type="text" class="shorttextfield" value="<%= vDestination %>"
                                            size="30">
                                    </td>
                                    <td align="left" valign="middle" bgcolor="#FFFFFF">
                                        <input name="txtETA2" id="txtETA2" type="text" class="m_shorttextfield "  value="<%= vETA2 %>"
                                            size="24">
                                    </td>
                                </tr>
                                <tr bgcolor="DFE1E6">
                                    <td>
                                    </td>
                                    <td height="20" colspan="3" align="left" valign="middle">
                                        <strong>Freight Location</strong>
                                    </td>
                                </tr>
                                <tr bgcolor="#FFFFFF">
                                    <td>
                                    </td>
                                    <td height="20" colspan="3" align="left" valign="middle">
                                        <input name="txtCargoLocation" id="txtCargoLocation" type="text" class="shorttextfield" value="<%= vCargoLocation %>"
                                            size="147">
                                    </td>
                                </tr>
                                <tr bgcolor="#F3f3f3">
                                    <td align="left" valign="middle" bgcolor="DFE1E6">
                                        &nbsp;
                                    </td>
                                    <td height="20" align="left" valign="middle" bgcolor="DFE1E6">
                                        <strong>Container Return Location </strong>
                                    </td>
                                    <td align="left" valign="middle" bgcolor="DFE1E6">
                                        <strong>Last Free Date</strong>
                                    </td>
                                    <td align="left" valign="middle" bgcolor="DFE1E6">
                                        <strong>G.O. DATE</strong>
                                    </td>
                                </tr>
                                <tr bgcolor="#F3f3f3">
                                    <td align="left" valign="middle" bgcolor="#FFFFFF">
                                        &nbsp;
                                    </td>
                                    <td height="20" align="left" valign="middle" bgcolor="#FFFFFF">
                                        <input name="txtContainerLocation" type="text" class="shorttextfield" value="<%= vContainerLocation %>"
                                            size="60" id="txtContainerLocation">
                                    </td>
                                    <td align="left" valign="middle" bgcolor="#FFFFFF">
                                        <input name="txtFreeDate" id="txtFreeDate" type="text" class="m_shorttextfield " 
                                            value="<%= vFreeDate %>" size="30">
                                    </td>
                                    <td align="left" valign="middle" bgcolor="#FFFFFF">
                                        <input name="txtGODate" type="text" class="m_shorttextfield " 
                                             value="<%= vGODate %>"
                                            size="24" id="txtGODate">
                                    </td>
                                </tr>
                                <tr bgcolor="DFE1E6">
                                    <td align="left" valign="middle">
                                        &nbsp;
                                    </td>
                                    <td height="20" align="left" valign="middle">
                                        <strong>I.T. No.</strong>
                                    </td>
                                    <td align="left" valign="middle">
                                        <strong>I.T. Date</strong>
                                    </td>
                                    <td align="left" valign="middle">
                                        <strong>I.T. Entry Port</strong>
                                    </td>
                                </tr>
                                <tr bgcolor="#FFFFFF">
                                    <td align="left" valign="middle">
                                        &nbsp;
                                    </td>
                                    <td height="20" align="left" valign="middle">
                                        <input name="txtITNumber" id="txtITNumber" type="text" class="shorttextfield" maxlength="64" value="<%= vITNumber %>"
                                            size="60">
                                    </td>
                                    <td align="left" valign="middle">
                                        <input name="txtITDate" id="txtITDate" type="text" class="m_shorttextfield "  value="<%= vITDate %>"
                                            size="30">
                                    </td>
                                    <td align="left" valign="middle">
                                        <input class="shorttextfield" name="txtITEntryPort" id="txtITEntryPort" type="text" value="<%= vITEntryPort %>"
                                            size="29">
                                    </td>
                                </tr>
                            </table>
                            <table width="90%" border="0" cellpadding="2" cellspacing="0" bordercolor="909EB0"
                                class="border1px">
                                <tr>
                                    <td height="20" bgcolor="CFD6DF">
                                        &nbsp;
                                    </td>
                                    <td colspan="6" bgcolor="CFD6DF">
                                        <span class="style1">PARTICULARS FURNISHED BY SHIPPER</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td height="1" colspan="7" align="left" valign="middle" bgcolor="909EB0">
                                    </td>
                                </tr>
                                <tr class="bodyheader">
                                    <td height="24" bgcolor="DFE1E6">
                                        &nbsp;
                                    </td>
                                    <td align="left" valign="middle" bgcolor="DFE1E6" class="bodycopy">
                                        Container No./ Seal No.<br>
                                        <strong>Marks &amp; Numbers</strong>
                                    </td>
                                    <td align="left" valign="middle" bgcolor="DFE1E6" class="bodycopy">
                                        No. of PKG
                                    </td>
                                    <td align="left" valign="middle" bgcolor="DFE1E6" class="bodycopy">
                                        Gross Wt &nbsp;&nbsp;&nbsp;&nbsp;Scale
                                    </td>
                                    <td align="left" valign="middle" bgcolor="DFE1E6" class="bodycopy">
                                        <% if iType="O" then response.write("<strong>Measure</strong>") else response.write("<strong>Measure &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Scale</strong>") %>
                                    </td>
                                    <td align="left" valign="middle" bgcolor="DFE1E6" class="bodycopy">
                                        Rate
                                    </td>
                                    <td align="left" valign="middle" bgcolor="DFE1E6" class="bodycopy">
                                        <span class="style3">Freight Charge</span>
                                        <br>
                                    </td>
                                </tr>
                                <tr>
                                    <td height="20" rowspan="4" bgcolor="#FFFFFF">
                                        &nbsp;
                                    </td>
                                    <td rowspan="4" align="left" valign="top" bgcolor="#FFFFFF" class="bodycopy">
                                        <textarea name="txtDesc1" cols="30" rows="5" class="multilinetextfield" 
                                            id="txtDesc1"><%= vDesc1 %></textarea>
                                    </td>
                                    <td align="left" valign="top" bgcolor="#FFFFFF" class="bodycopy" style="height: 24px">
                                        <input name="txtPCS" type="text" class="shorttextfield" value="<%= vPCS %>" size="10"
                                            style="behavior: url(../include/igNumDotChkLeft.htc)" id="txtPCS" />
                                        <select name="lstUOM" class="smallselect">
                                            <option <%if vUOM="PCS" then response.write("selected")%>>PCS</option>
                                            <option <%if vUOM="BOX" then response.write("selected")%>>BOX</option>
                                            <option <%if vUOM="PLT" then response.write("selected")%>>PLT</option>
                                            <option <%if vUOM="CTN" then response.write("selected")%>>CTN</option>
                                            <option <%if vUOM="SET" then response.write("selected")%>>SET</option>
                                            <option <%if vUOM="CRT" then response.write("selected")%>>CRT</option>
                                            <option <%if vUOM="SKD" then response.write("selected")%>>SKD</option>
                                            <option <%if vUOM="UNIT" then response.write("selected") %>>UNIT</option>
                                            <option <%if vUOM="PKGS" then response.write("selected") %>>PKGS</option>
                                            <option <%if vUOM="CNTR" then response.write("selected") %>>CNTR</option>
                                        </select>
                                    </td>
                                    <td align="left" valign="top" bgcolor="#FFFFFF" class="bodycopy" style="height: 24px">
                                        <input name="txtGrossWT" type="text" class="shorttextfield" value="<%= vGrossWT %>"
                                            size="10" style="behavior: url(../include/igNumDotChkLeft.htc)" 
                                            id="txtGrossWT" />
                                        <select name="lstScale1" class="smallselect">
                                            <option <% if vScale1="LB" Or vScale1="L" then response.write("selected") %>>LB</option>
                                            <option <% if vScale1="KG" Or vScale1="K" then response.write("selected") %>>KG</option>
                                        </select>
                                    </td>
                                    <td align="left" valign="top" bgcolor="#FFFFFF" class="bodycopy" style="height: 24px">
                                        <input name="txtChgWT" id="txtChgWT" type="text" class="shorttextfield" value="<%= vChgWT %>"
                                            size="10" style="behavior: url(../include/igNumDotChkLeft.htc)" />
                                        <select name="lstScale2" class="smallselect">
                                            <option <% if vScale2="LB" Or vScale2="L" or vScale2="CFT" then response.write("selected") %>>
                                                CFT</option>
                                            <option <% if vScale2="KG" Or vScale2="K" or vScale2="CBM" then response.write("selected") %>>
                                                CBM</option>
                                        </select>
                                    </td>
                                    <td align="left" valign="top" bgcolor="#FFFFFF" class="bodycopy" style="height: 24px">
                                        <input id="txtCSRate" name="txtCSRate" size="8" class="shorttextfield" type="text"
                                            value="<%=vOFRate%>" style="behavior: url(../include/igNumDotChkLeft.htc)" />
                                        <img src="../Images/button_cal.gif" name="imageField" align="top" onclick="calculateTotalFc();" />
                                    </td>
                                    <td align="left" valign="top" bgcolor="#FFFFFF" class="bodycopy" style="height: 24px">
                                        <input size="10" onblur="AmountChange(1000)" id="txtTotalFC" name="txtTotalFC" class="numberaligh"
                                            value="<%=formatNumberPlus(vOFTotal,2)%>" type="text" style="behavior: url(../include/igNumDotChkLeft.htc)" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3" align="left" valign="top" bgcolor="#FFFFFF" class="bodycopy">
                                    </td>
                                </tr>
                                <tr>
                                    <td height="20" align="left" valign="top" bgcolor="#FFFFFF" class="bodycopy">
                                        &nbsp;
                                    </td>
                                    <td bgcolor="#FFFFFF">
                                        &nbsp;
                                    </td>
                                    <td colspan="2" bgcolor="#f3f3f3">
                                        <span class="bodycopy"><strong>Freight Charge Description </strong></span>
                                    </td>
                                    <td bgcolor="#f3f3f3" class="bodyheader">
                                        Payment
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" valign="top" bgcolor="#FFFFFF" class="bodycopy">
                                        &nbsp;
                                    </td>
                                    <td bgcolor="#FFFFFF">
                                        &nbsp;
                                    </td>
                                    <td colspan="2" bgcolor="#FFFFFF">
                                        <span class="bodycopy">
                                            <input id="txtFCDescription" class="shorttextfield" name="txtFCDescription" size="30"
                                                value="<%if vFCDescription="" then response.write vDefaultOF_Desc else response.write vFCDescription end if%>" />
                                        </span>
                                    </td>
                                    <td bgcolor="#FFFFFF">
                                        <span class="bodycopy">
                                            <input type="radio" name="rdPrepaid" value="0" <%if IsCollect ="N" then response.write("checked='checked'") %>
                                                onclick="PrePaidSelected();AmountChange(1000)" id="rdPrepaid">
                                            Prepaid
                                            <input type="radio" name="rdCollect" value="1" <%if IsCollect ="Y" then response.write("checked='checked'") %>
                                                onclick="FCCollected();AmountChange(1000)" id="rdCollect" />
                                            Collect</span>
                                    </td>
                                </tr>
                                <tr bgcolor="#DFE1E6">
                                    <td>
                                    </td>
                                    <td height="20" colspan="6">
                                        <strong>Description of Packages and Goods </strong>( Maximum of 230 characters or
                                        5 lines please)
                                    </td>
                                </tr>
                                <tr>
                                    <td bgcolor="#FFFFFF">
                                    </td>
                                    <td height="20" colspan="6" align="left" valign="top" bgcolor="#FFFFFF">
                                        <textarea name="txtDesc3" cols="65" rows="5" class="multilinetextfield" 
                                            onkeyup="textLimit(this,230);" id="txtDesc3"><%= vDesc3 %></textarea>
                                    </td>
                                </tr>
                            </table>
                            <table width="90%" border="0" cellpadding="2" cellspacing="0" bordercolor="909EB0"
                                class="border1px">
                                <tr bgcolor="DFE1E6" class="bodycopy">
                                    <td bgcolor="DFE1E6">
                                        &nbsp;
                                    </td>
                                    <td height="20" colspan="7">
                                        <strong>Remark </strong>( Maximum of 220 characters or 2 lines please)
                                    </td>
                                </tr>
                                <tr bgcolor="ffffff" class="bodycopy">
                                    <td bgcolor="#FFFFFF">
                                        &nbsp;
                                    </td>
                                    <td height="20" colspan="7">
                                        <textarea name="txtRemarks" id="txtRemarks" cols="149" rows="2" class="bodycopy"
                                            onkeyup="textLimit(this,220);"><%= vRemarks %></textarea>
                                    </td>
                                </tr>
                                <tr bgcolor="DFE1E6" class="bodycopy">
                                    <td bgcolor="DFE1E6">
                                        &nbsp;
                                    </td>
                                    <td height="20">
                                        <strong>A/R</strong>
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
                                    <td bgcolor="DFE1E6">
                                        &nbsp;
                                    </td>
                                    <td bgcolor="DFE1E6">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr bgcolor="ffffff" class="bodycopy">
                                    <td bgcolor="ffffff">
                                        &nbsp;
                                    </td>
                                    <td height="20" bgcolor="ffffff">
                                        <strong>
                                            <select name="lstAR" size="1" class="smallselect" style="width: 140" 
                                            id="lstAR">
                                                <% Dim j 
                      for j=0 to ARIndex-1 %>
                                                <option value="<%= DefaultAR(j) %>" <% if DefaultAR(j)=AR then response.write("selected") %>>
                                                    <%= DefaultARName(j) %>
                                                </option>
                                                <% next %>
                                            </select>
                                            &nbsp;&nbsp;
                                            <input name="txtTerm" type="hidden" class="shorttextfield" value="<%= vTerm %>" size="4">
                                        </strong>
                                    </td>
                                    <td bgcolor="ffffff" colspan="6">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr bgcolor="DFE1E6" class="bodycopy">
                                    <td width="18" bgcolor="DFE1E6">
                                        &nbsp;
                                    </td>
                                    <td width="199" height="20">
                                        <span class="style3"><strong>Other Charge Item</strong></span>
                                    </td>
                                    <td width="146">
                                        <strong>Description</strong>
                                    </td>
                                    <td width="95">
                                        <strong>Amount</strong>
                                    </td>
                                    <td width="165">
                                        &nbsp;
                                    </td>
                                    <td width="110">
                                        &nbsp;
                                    </td>
                                    <td width="145" bgcolor="DFE1E6">
                                        &nbsp;
                                    </td>
                                    <td width="121" bgcolor="DFE1E6">
                                        &nbsp;
                                    </td>
                                </tr>
                                <input type="hidden" id="InvoiceItem">
                                <input type="hidden" id="ItemDesc">
                                <input type="hidden" id="ItemAmount">
                                <input type="hidden" id="InvoiceCostItem">
                                <input type="hidden" id="ItemCost">
                                <input type="hidden" id="ItemCostDesc">
                                <input type="hidden" id="ItemVendor">
                                <% for i=0 to NoItem-1 %>
                                <tr>
                                    <td bgcolor="#FFFFFF" class="bodycopy" style="height: 22px">
                                        &nbsp;
                                    </td>
                                    <td bgcolor="#FFFFFF" class="bodycopy" style="height: 22px">
                                        <select name="lstItem<%= i %>" size="1" class="smallselect InvoiceItem" id="InvoiceItem" style="width: 180"
                                            onchange="ItemChange(<%= i%>); AmountChange(<%= i %>)">
                                            <option>Select One</option>
                                            <option>Add New Item</option>
                                            <% for j=0 to ItemIndex-1 %>
                                            <option value="<%= DefaultItemNo(j) & "-" & DefaultRevenue(j) & "-" & DefaultItem(j) & chr(10) & DefaultItemDesc(j) & chr(10) & aItemUnitPrice(j)%>"
                                                <% if cInt(aItemNo(i))=DefaultItemNo(j) then response.write("selected") %>>
                                                <%= igDefaultItem(j) %>
                                            </option>
                                            <% next %>
                                        </select>
                                    </td>
                                    <td bgcolor="#FFFFFF" class="bodycopy" style="height: 22px">
                                        <input name="txtChargeDesc<%= i %>" type="text" class="shorttextfield ItemDesc" id="ItemDesc"
                                            value="<%= aChargeDesc(i) %>" size="24">
                                    </td>
                                    <td bgcolor="#FFFFFF" class="bodycopy" style="height: 22px">
                                        <input id="ItemAmount" class="numberaligh ItemAmount" name="txtAmount<%= i %>" onchange="AmountChange(<%= i%>); "
                                            size="12" type="text" value="<%= formatNumberPlus(CheckBlank(aAmount(i),0),2) %>"
                                            style="behavior: url(../include/igNumDotChkLeft.htc)" />
                                    </td>
                                    <td bgcolor="#FFFFFF" class="bodycopy" style="height: 22px">
                                        &nbsp;
                                    </td>
                                    <td bgcolor="#FFFFFF" class="bodycopy" style="height: 22px">
                                        &nbsp;
                                    </td>
                                    <td bgcolor="#FFFFFF" class="bodycopy" style="height: 22px">
                                        <img src='../images/button_delete.gif' width='50' height='17' onclick="if(!checkLocked()){DeleteItem(<%= i %>)}"
                                            <% 
	'if i=0 and tIndex=1 then  
		'response.write("disabled")		
	'elseif i=0 and flag ="true" then response.write("disabled")
	'else	
		if UserRight<5 then response.write("disabled") 
	'end if	
%> style="cursor: hand">
                                    </td>
                                    <td bgcolor="#FFFFFF" style="height: 22px">
                                        &nbsp;
                                    </td>
                                </tr>
                                <% Response.Flush() %>
                                <% next %>
                                <tr>
                                    <td bgcolor="#FFFFFF" class="bodycopy">
                                        &nbsp;
                                    </td>
                                    <td bgcolor="#FFFFFF" class="bodycopy">
                                        <img src='../images/button_addcharge_item.gif' width='109' height='18' name='bAddItem'
                                            onclick='if(!checkLocked()){AddItem()}' <%
	 if UserRight<5 Or Not Branch="" then response.write("disabled") %> style="cursor: hand">
                                    </td>
                                    <td bgcolor="#FFFFFF" class="bodycopy">
                                        &nbsp;
                                    </td>
                                    <td colspan="5" bgcolor="#FFFFFF" class="bodycopy">
                                        <%	
					if arPayMentNoIndex > 0 then
						response.write "<span class='style7'>"
						response.write "Payment received "
						for i=1 to 10
                                        %>
                                        <a href="javascrip:;" onclick="goLinkPay('<%=arPayMentNo(i)%>'); return false;">
                                            <%=arPayMentNo(i)%>
                                        </a>
                                        <%	
						next
						response.write "</strong></span>"						
						if arPayMentNoIndex > 10 then
							response.write "..."
						end if
					end if
                                        %>
                                    </td>
                                </tr>
                                <tr>
                                    <td height="1" colspan="8" align="left" valign="middle" bgcolor="909EB0">
                                    </td>
                                </tr>
                                <tr>
                                    <td height="20" bgcolor="DFE1E6" class="bodycopy">
                                        &nbsp;
                                    </td>
                                    <td bgcolor="DFE1E6" class="bodycopy">
                                        <span class="style3"><strong>Cost Item</strong></span>
                                    </td>
                                    <td bgcolor="DFE1E6" class="bodycopy">
                                        <strong>Description</strong>
                                    </td>
                                    <td bgcolor="DFE1E6" class="bodycopy">
                                        <strong>Cost</strong>
                                    </td>
                                    <td bgcolor="DFE1E6" class="bodycopy">
                                        <strong>Vendor</strong>
                                    </td>
                                    <td bgcolor="DFE1E6" class="bodycopy">
                                        <strong>Ref No</strong>
                                    </td>
                                    <td bgcolor="DFE1E6" class="bodycopy">
                                        &nbsp;
                                    </td>
                                    <td bgcolor="DFE1E6">
                                        &nbsp;
                                    </td>
                                </tr>
                                <% for i=0 to NoCostItem-1 %>
                                <% if aAPLock(i) = "" or aAPLock(i) = "0" then%>
                                <tr>
                                    <td bgcolor="#FFFFFF">
                                        <input name="txtAPLOCK<%= i %>" type="hidden" value="<%= aAPLock(i) %>">
                                    </td>
                                    <td bgcolor="#FFFFFF">
                                        <select name="lstCostItem<%= i %>" size="1" class="smallselect InvoiceCostItem" id="InvoiceCostItem"
                                            style="width: 180" onchange="ItemCostChange(<%= i %>); CostChange(<%= i %>)">
                                            <option>Select One</option>
                                            <option>Add New Item</option>
                                            <% for j=0 to CostItemIndex-1 %>
                                            <option value="<%= DefaultCostItemNo(j) & "-" & DefaultExpense(j) & "-" & DefaultCostItem(j) & chr(10) & DefaultCostItemDesc(j) & chr(10) & aCostItemUnitPrice(j) %>"
                                                <% if cInt(aCostItemNo(i))=DefaultCostItemNo(j) then response.write("selected") %>>
                                                <%= igDefaultCostItem(j) %>
                                            </option>
                                            <% next %>
                                        </select>
                                    </td>
                                    <td bgcolor="#FFFFFF">
                                        <input name="txtCostDesc<%= i %>" type="text" class="shorttextfield ItemCostDesc" id="ItemCostDesc"
                                            value="<%= aCostDesc(i) %>" size="24">
                                    </td>
                                    <td bgcolor="#FFFFFF">

                                        <input type="text" class="numberalign ItemCost" name="txtCost<%= i %>"  id="ItemCost" onchange="CostChange(<%= i %>)"
                                            value="<%= formatNumberPlus(CheckBlank(aRealCost(i),0),2) %>" size="12" style="behavior: url(../include/igNumDotChkLeft.htc)" />
                                    </td>
                                    <td bgcolor="#FFFFFF">
                                        <select name="lstVendor<%= i %>" size="1" class="smallselect ItemVendor" id="ItemVendor" style="width: 130">
                                            <% for k=0 to aVendorArrayList.Count-1 %>
                                            <option value="<%= aVendorArrayList(k)("acct") %>" <% if aVendor(i)=CLng(aVendorArrayList(k)("acct")) then response.write("selected") %>>
                                                <%= aVendorArrayList(k)("name") %>
                                            </option>
                                            <% next %>
                                        </select>
                                    </td>
                                    <td bgcolor="#FFFFFF">
                                        <input name="txtRefNo<%= i %>" type="text" class="shorttextfield" value="<%= aRefNo(i) %>"
                                            size="14">
                                    </td>
                                    <td bgcolor="#FFFFFF">
                                        <img src='../images/button_delete.gif' width='50' height='17' onclick="DeleteCostItem(<%= i %>)"
                                            style="cursor: hand">
                                    </td>
                                    <td bgcolor="#FFFFFF">
                                        &nbsp;
                                    </td>
                                </tr>
                                <% else %>
                                <tr>
                                    <td bgcolor="#FFFFFF">
                                        <input name="txtAPLOCK<%= i %>" type="hidden" value="<%= aAPLock(i) %>">
                                    </td>
                                    <td bgcolor="#FFFFFF">
                                        <select name="lstCostItem<%= i %>" size="1" class="smallselect InvoiceCostItem" id="InvoiceCostItem"
                                            style="width: 180" onchange="ItemCostChange(<%= i%>); CostChange(<%= i %>)">
                                            <% for j=0 to CostItemIndex-1 %>
                                            <% if cInt(aCostItemNo(i))=DefaultCostItemNo(j) then%>
                                            <option value="<%= DefaultCostItemNo(j) & "-" & DefaultExpense(j) & "-" & DefaultCostItem(j) & chr(10) & DefaultCostItemDesc(j) & chr(10) & aCostItemUnitPrice(j) %>"
                                                selected>
                                                <%= igDefaultCostItem(j) %>
                                            </option>
                                            <% end if %>
                                            <% next %>
                                        </select>
                                    </td>
                                    <td bgcolor="#FFFFFF">
                                        <input name="txtCostDesc<%= i %>" type="text" class="d_shorttextfield ItemCostDesc" id="ItemCostDesc"
                                            value="<%= aCostDesc(i) %>" size="24" readonly="true">
                                    </td>
                                    <td bgcolor="#FFFFFF">
                                        <input name="txtCost<%= i %>" type="text" class="numberalign ItemCost" id="ItemCost" onchange="CostChange(<%= i %>)"
                                            value="<%= formatNumberPlus(aRealCost(i),2) %>" size="12" readonly="true" style="behavior: url(../include/igNumDotChkLeft.htc)" />
                                    </td>
                                    <td bgcolor="#FFFFFF">
                                        <select name="lstVendor<%= i %>" size="1" class="smallselect ItemVendor" id="ItemVendor" style="width: 130">
                                            <% for k=0 to aVendorArrayList.Count-1 %>
                                            <% if aVendor(i)=CLng(aVendorArrayList(k)("acct")) then %>
                                            <option value="<%= aVendorArrayList(k)("acct") %>" selected>
                                                <%= aVendorArrayList(k)("name") %>
                                            </option>
                                            <% end if%>
                                            <% next %>
                                        </select>
                                    </td>
                                    <td bgcolor="#FFFFFF">
                                        <input name="txtRefNo<%= i %>" type="text" class="d_shorttextfield" value="<%= aRefNo(i) %>"
                                            size="14" readonly="true">
                                    </td>
                                    <td colspan="2" bgcolor="#FFFFFF">
                                        <span class="goto"><a href="javascrip:;" onclick="goLink('<%=aAPLock(i)%>'); return false;">
                                            Invoice billed</a></span>
                                    </td>
                                </tr>
                                <% end if %>
                                <% Response.Flush() %>
                                <% next %>
                                <tr>
                                    <td bgcolor="#FFFFFF">
                                        &nbsp;
                                    </td>
                                    <td bgcolor="#FFFFFF">
                                        <img src='../images/button_addcost_item.gif' width='94' height='18' name='bAddItem2'
                                            onclick='if(!checkLocked()){AddCostItem()}' <% 
	 if UserRight<5 Or Not Branch="" then response.write("disabled") %> style="cursor: hand">
                                    </td>
                                    <td bgcolor="#FFFFFF">
                                        &nbsp;
                                    </td>
                                    <td bgcolor="#FFFFFF">
                                        &nbsp;
                                    </td>
                                    <td bgcolor="#FFFFFF">
                                        &nbsp;
                                    </td>
                                    <td bgcolor="#FFFFFF">
                                        &nbsp;
                                    </td>
                                    <td bgcolor="#FFFFFF">
                                        &nbsp;
                                    </td>
                                    <td bgcolor="#FFFFFF">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td height="1" colspan="8" align="left" valign="middle" bgcolor="909EB0">
                                    </td>
                                </tr>
                                <tr>
                                    <td height="1" colspan="8" align="left" valign="middle" bgcolor="#FFFFFF">
                                    </td>
                                </tr>
                                <tr>
                                    <td height="1" colspan="8" align="left" valign="middle" bgcolor="909EB0">
                                    </td>
                                </tr>
                                <tr bgcolor="#F3f3f3">
                                    <td height="20">
                                        &nbsp;
                                    </td>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td align="right" valign="middle" bgcolor="#F3f3f3">
                                        <span class="style1">TOTAL</span>
                                    </td>
                                    <td>
                                        <input name="txtTotalAmount" type="text" class="numberaligh" value="<%= formatNumberPlus(vTotalAmount,2) %>"
                                            size="12" style="behavior: url(../include/igNumDotChkLeft.htc)" 
                                            id="txtTotalAmount" />
                                    </td>
                                    <td>
                                        <input name="txtTotalCost" type="text" class="numberaligh" value="<%= formatNumberPlus(vTotalCost,2) %>"
                                            size="12" style="behavior: url(../include/igNumDotChkLeft.htc)" 
                                            id="txtTotalCost" />
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
                                </tr>
                                <tr>
                                    <td height="1" colspan="8" align="left" valign="middle" bgcolor="909EB0">
                                    </td>
                                </tr>
                                <tr align="center" valign="middle" bgcolor="CFD6DF">
                                    <td height="22" colspan="8">
                                        &nbsp;
                                    </td>
                                </tr>
                            </table>
                            <table width="90%" height="32" cellpadding="0" cellspacing="0">
                                <tr class="bodyheader">
                                    <td width="47%" height="32" align="right" valign="middle">
                                        Prepared by&nbsp;&nbsp;
                                    </td>
                                    <td width="26%" height="32">
                                        <input name="txtPreparedBy" type="text" class="shorttextfield" value="<%= vPreparedBy %>"
                                            size="30" id="txtPreparedBy">
                                    </td>
                                    <td width="9%" height="32">
                                        <strong>Sales Person</strong>
                                    </td>
                                    <td width="18%" height="32" align="right" valign="middle">
                                        <select name="lstSalesRP" size="1" class="smallselect" style="width: 160px" 
                                            id="lstSalesRP">
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
                        <tr bgcolor="CFD6DF">
                            <td width="78%" height="24" align="center" valign="middle" bgcolor="CFD6DF" class="bodyheader">
                                <table width="98%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="26%" valign="middle">
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        </td>
                                        <td width="48%" align="center" valign="middle">
                                            <img height="18" name="bSave" onclick="if(CheckIfANExist()==true) {SaveClick('<%= TranNo %>','no')}"
                                                src="../images/button_save_medium.gif" style="cursor: hand" width="46">
                                        </td>
                                        <td width="13%" align="right" valign="middle">
                                            <img style="cursor: hand" onclick="AddHAWB()" src="/ASP/Images/button_new.gif" width="42"
                                                height="17">
                                        </td>
                                        <td width="13%" align="right" valign="middle">
                                            <img style="cursor: hand; visibility: <%=vArApLock %>" src="/iff_main/Images/button_delete_medium.gif"
                                                onclick="DeleteHAWB()">
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                </table>
            </td>
        </tr>
    </table>
    <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
        <tr>
            <td colspan="4" width="40%" height="32" align="right" valign="bottom">
                <div id="print">
                    <img src="/ASP/Images/icon_printer.gif"><a href="javascript:;" onclick="if(CheckIfANExist()==true) { SaveClick('<%= TranNo %>','yes') };return false;">Arrival
                        Notice</a><img src="/ASP/Images/button_devider.gif"><a href="javascript:;" onclick="if(CheckIfANExist()==true) {SaveClick2('<%= TranNo %>','yes')};return false;">Arrival
                            Notice & Freight Invoice</a><img src="/ASP/Images/button_devider.gif"><a href="javascript:;"
                                onclick="SaveClick3('<%= TranNo %>');return false;">Release Order</a></div>
            </td>
        </tr>
    </table>
    <br>
    <input type="hidden" name="hDepText" id="hDepText" value="<%=vDepPort%>" />
    <input type="hidden" name="hArrText" id="hArrText" value="<%=vArrPort%>" />
    </form>
</body>

<script type="text/vbscript">

Sub MenuMouseOver()
	document.form1.lstAR.style.visibility="hidden"
End Sub
Sub MenuMouseOut()
	document.form1.lstAR.style.visibility="visible"
End Sub
</script>
<script type="text/javascript">

function docModified(arg) {
    var isDocBeingModified = document.getElementById("isDocBeingModified");
    isDocBeingModified.value = arg;
}

function checkLocked(){
   return false;
   var lock= "<%=vArApLock %>";
   if(lock=="Hidden"){
        return true;
   }else{
        return false;
   }
}

function CheckIfANExist(){ 

     var HAWB=document.getElementById("txtHAWB").value;
     var MAWB=document.getElementById("txtMAWB").value;
     if(MAWB==""){
      alert("Please Select a Master Airway Bill Number");
     }
     var OriginalHAWB="<%=Session("hawb")%>" 
     var OriginalMAWB="<%=Session("mawb")%>"
     
     var HAWB_MAWB_NOT_CHANGED=(HAWB==OriginalHAWB&&MAWB==OriginalMAWB)
    
     var vSec="1";	 
     var iType="O";	 
     var CurrentInvoice=document.form1.hInvoiceNo.value; 
     
     // added by joon on 4-30-2007
     if(CurrentInvoice == 0) {CurrentInvoice = "";}
           
	 if(CurrentInvoice!=""&&HAWB_MAWB_NOT_CHANGED){
	    document.form1.hSavingCondition.value="OVER_WRITE"
	    return true
	 }
	 if(CurrentInvoice==""||!HAWB_MAWB_NOT_CHANGED)
	 {     
	        var req ="";
            if (window.ActiveXObject) {
                try {
                    req = new ActiveXObject("Msxml2.XMLHTTP");
                } catch(error) {
                    try {
                        req = new ActiveXObject("Microsoft.XMLHTTP");
                    } catch(error) { return ""; }
                }
            } 
            else if (window.XMLHttpRequest) {
                req = new XMLHttpRequest();
            } 
            else { return ""; }
            req.open("get",encodeURI("/ASP/ajaxFunctions/ajax_CheckIfANExist.asp?MAWB="+MAWB+"&HAWB="+HAWB+"&Sec="+vSec+"&iType="+iType+"&elt_account_number="+"<%=elt_account_number%>"),false);
	        req.send(); 
	        
	        var result =req.responseText.split("-");
	        var exist=result[0];
	        var IV=result[1];
	         
	        if(exist=="False"){
	        
               if(CurrentInvoice!=""){	           
                     var aFirm=eltMsgBox("The invoice for the MBOL&HBOL has been changed."
                     +"\n Would you like to create a new invoice?"
                     +"\n Pressing 'No' will overwrite the current invoice with new information");			                      
                  
                     if(aFirm==6){ 
                           document.form1.hSavingCondition.value="CREATE_NEW"; 
                           return true;     
                               
                     }else if(aFirm==7){
                           document.form1.hSavingCondition.value="OVER_WRITE_WITH_NEW_HAWB_MAWB";
                           return true; 
                           
                     }else{
                          return false;
                     }
    	             	
	           }else{
	                if(MAWB!=""){
	                    document.form1.hSavingCondition.value="CREATE_NEW"  
	                    return true;
	                }else{
	                    return false;
	                }
	          }	               
	        }
	        
	        else {    
	       
            // edt case by Joon 
	        //    if(CurrentInvoice==""){
	        //        document.form1.hSavingCondition.value="OVER_WRITE_WITH_NEW_INVOICE" ; 
	        //        return true;
	        //    }
	                    				  
                var aFirm=confirm("The invoice for the MAWB&HAWB combination alreay exists in the database."
                    + "\n Would you like to reload with the previous invoice?");			                      
                  
                if(aFirm){    
                  
                    document.form1.action=encodeURI("arrival_notice.asp?iType=O&tNo="+"<%=TranNo%>"+"&Edit=yes&MAWB="+MAWB+"&HAWB="+HAWB+"&Sec="+vSec+"&WindowName="+ window.name);	
                    document.form1.method="POST";
                    document.form1.target="_self";
                    document.form1.submit();	   
                 }
                 else{
	               return false;
	             }	           
            }  
     }	
	  return false;  
}


    function GetHAWBList(arg) {
        var HAWB = document.getElementById('txtFindByHAWB').value
        var MAWB = document.getElementById('txtFindByMAWB').value
        var returnValue

        if (arg == "HAWB") {
            if (HAWB != "" && HAWB != "House No. Here") {
                returnValue = window.showModalDialog(encodeURI('../include/showHAWBs.asp?AE=O&HAWB=' + HAWB), '', 'dialogHeight:200px;dialogWidth:400px;center:yes');
            }
            else {
                alert("Please enter a House No");
            }
        }

        else {
            if (HAWB != "" && HAWB != "Master No. Here") {
                returnValue = window.showModalDialog(encodeURI('../include/showHAWBs.asp?AE=O&MAWB=' + MAWB), '', 'dialogHeight:200px;dialogWidth:400px;center:yes');
            }
            else {
                alert("Please enter a Master No");
            }
        }
        try {
            if (returnValue) {
                window.location.href = encodeURI("./arrival_notice.asp?iType=O&Edit=yes&" + returnValue);
            }

        } catch (E) {
        }
    }
</script>
<% 

if PrintOK = "yes" then
	response.write "<script language='javascript'>PrintClick();</script>"
end if

if vAuth = "yes" then
	response.write "<script language='javascript'>AuthClick();</script>"
end if

if PrintOK <>"yes" then 
    response.Write("<script language='javascript'>window.focus();</script>")
end if 
%>
<!-- //for Tooltip// -->
<script language="JavaScript" type="text/javascript" src="../include/tooltips.js"></script>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
