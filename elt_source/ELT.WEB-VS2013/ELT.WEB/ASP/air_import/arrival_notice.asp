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
<!--  #INCLUDE FILE="../include/header.asp" -->
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_Util_Ver_2.inc" -->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
     <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
    <title>Air Import - Arrival Notice/Freight Invoice</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="../include/JPED.js"></script>
    <script type="text/javascript" src="../Include/JPTableDOM.js"></script>

    <script type="text/javascript"  type="text/javascript" src="/ASP/ajaxFunctions/ajax.js"></script>

    <!-- /Start of Combobox/ -->

    <script type="text/javascript">

        function showtip(){}
        function hidetip(){}
        
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
            divObj.style.height = "0px";
        }
        
        function lstConsigneeNameChange(orgNum,orgName)
        {
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
		    lstNotifyNameChange(orgNum,orgName);
		    document.getElementById("txtBrokerInfo").value = getDefaultBrokerInfo(orgNum);
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
            divObj.style.height = "0px";
        }
        
        function lstBrokerNameChange(orgNum,orgName)
        {
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
        
        var ComboBoxes =  new Array('lstMAWB');
        
        function validateSalesRep(){

             var txtSalesRep=document.getElementById("txtSalesRep");
             var salesRep=txtSalesRep.value;
             if(salesRep!=""){       
                return true;
             }else{
                //txtSalesRep.focus();
                return false;
            }
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

            var url="/ASP/ajaxFunctions/ajax_get_org_address_info.asp?type=B&org="+ orgNum;
        
            xmlHTTP.open("GET",url,false); 
            xmlHTTP.send(); 
            
            return xmlHTTP.responseText; 
        }
        

        function getDefaultBrokerInfo(orgNum)
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

            var url="/ASP/ajaxFunctions/ajax_get_org_address_info.asp?type=DB&org="+ orgNum;
        
            xmlHTTP.open("GET",url,false); 
            xmlHTTP.send(); 
            
            return xmlHTTP.responseText; 
        }
        
        function chkPrintInvoiceChange()
        {
            obj=document.getElementById("hDoInvoice");

            if(obj.value=="yes"){
                document.getElementById("hDoInvoice").value="no"
            }else{
                document.getElementById("hDoInvoice").value="yes"
            }
        }

        //ADDed by stanley Limit Fumction
        function checkLimit(obj, limit,limit2)
        {
            var num=obj.value;
            var tempArray = new Array();
            tempArray = num.split(".");
            if(num <= limit)
            {
                return true;
            }
            else
            {
                if(num > limit){
                    obj.value = num.substring(0,limit2);
                }
                else{
                    obj.value = parseFloat(obj.value).toFixed(2);
                }

            }
        }

        function docModified(arg){}

    </script>

    <!-- MJ 12/06/06 for remarks n description text maximum length -->

    <script type="text/javascript">
        function getParameterByName(name) {
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
            return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        }
function textLimit(field, maxlen) {
if (field.value.length > maxlen + 1)
alert('Your input has exceeded the maximum character!');
if (field.value.length > maxlen)
field.value = field.value.substring(0, maxlen);
}

window.onload = function () {
    if (getParameterByName("HAWB") != null && getParameterByName("HAWB") != "" && getParameterByName("HAWB") != undefined) {
        if (document.getElementById("txtHAWB").value == "") {
            
            document.getElementById("SearchType").value = "houseNo";
            selectSearchType();

            document.getElementById("txtFindByHAWB").value = getParameterByName("HAWB");

            GetHAWBList('HAWB');
        }
    }
    //FindByInvoiceNo('txtFindIV')
};

    </script>

    <script type="text/javascript" src="../Include/iMoonCombo.js"></script>

    <script type="text/javascript" src="/ASP/ajaxFunctions/ajax_ig_call_db.js">  </script>

    <script type="text/vbscript">



    </script>
        <script type="text/javascript">
           
            function CofirmDFA() {
                if (confrim("Check Default Ocean Freight Charge is set. \r\nDefault Ocean Freight Charge Item is not set in your Company Profile, would you like to set it before you move on?")) {
                    parent.window.location.href = "../../SiteAdmin/CompanyInformation/"
                + encodeURIComponent("DOF=Y");
                }
                //window.location =  "/ASP/SITE_ADMIN/co_config.asp?DOF=Y";
            }
    </script>
    <style type="text/css">
<!--
.style1 {color: #CC6600}
.style7 {
	color: #CC3300;
	font-weight: bold;
}
.style7 a:hover {
	color: #CC3300;
}
.style2 {color: #336699}
.style3 {
	color: #000000;
	font-weight: bold;
}
.style4 {color: #000000}
.locked{visibility:hidden}
.style5 {color: #663366}
.style6 {
	color: #cc6600;
	font-weight: bold;
}
.numberalign {
	font-weight: bold;
	font-size: 9px;
	text-align: right;
	font-family: Verdana, Arial, Helvetica, sans-serif;
}
.numberalign1 {	font-weight: bold;
	font-size: 9px;
	text-align: right;
	font-family: Verdana, Arial, Helvetica, sans-serif;
}
-->
</style>
</head>

<%

DIM bIndex, vBrokerName

Public vSavingCondition, vFCDescription,vAuth
Public vDefaultAF_Revenue, vDefaultAF_Desc
Public  FROM_EDIT,vSaveAsNew,CurrentHAWB,vPostBack
Public  df_item_no,df_item_name,df_item_desc,FCItemIndex,is_default_rate

Public  vSubTotal,AgentProfit,SaleTax,EntryNo,EntryDate,InvoiceExist
Public  iType,Edit,Save,AddItem,AddCostItem,DeleteItem,DeleteCost,vForwarded, vAirline, vTotalCost
Public  vOpenPageItemNo,PrintOK

Public  vSalesPerson , vAFRate,vAFTotal,vAgentOrgAcct,InvoiceNo,tNo,  TranNo, vAR,vTerm,vSec,vFileNo,vProcessDT
Public  vMAWB,vHAWB,vPreparedBy,vPCS,vUOM, vGrossWT	,vNotifyName,vBrokerAcct,vBrokerInfo, vRemarks, TotalAmount,NoItem, NoCostItem,vTotalAmount
Public  vChgWT, vScale1,vScale2,vShipperAcct,vShipperInfo,pos,vShipperName,vSubHAWB,vCustomerRef,vConsigneeInfo,vConsigneeName,vConsigneeAcct
Public  vVessel,vPickupDate,vETD,vETA,vDeliveryPlace,vDestination,vETD2,vETA2,vNotifyAcct,vNotifyInfo
Public  vCargoLocation,vContainerLocation,vFreeDate,vGODate,vITNumber,vITDate,vITEntryPort,vDesc1,vDesc2,vDesc3,vDesc4,vDesc5


Public  IsCollect,totalOC,vFC_from_Item,vDefault_SalesRep,rs,SQL,rs1
Public  vAgentName,vFileNum,vCarrier,vPieces,vAgentDebitNo,vAgentDebitAmt,vCarrierCode
Public  vFLTNo,vGrossWeight,vChargeableWeight
Public  vHBExist


Public  DeleteHAWB
Public  aItemNo(1024),aItemName(1024),aChargeDesc(1024),aAmount(1024)
Public  aCostItemNo(1024),aCostItemName(1024),aCostDesc(1024),aRefNo(1024),aCost(1024),aRealCost(1024)
Public  aAR(1024),aRevenue(1024),aExpense(1024), aVendor(1024)

'/////////////////// added by iMoon for AP Lock Handle
Public  aAPLock(1024)
'///////////////////

Public  vDeleteAFfromDB,flag, aSRName(1000),SRIndex,vDefaultAF,indexDAF,cusSellRate,vTotalAF
Public  AFexistsAlready, vTotalOverWrite 
Public  aMAWB
Public  aMAWBInfo


Dim aVendorArrayList
Public  aIndex, cIndex, sIndex,vIndex, nIndex, ARIndex
Public  DefaultAR(8),DefaultARName(8)
Public  ItemIndex, AF, OF,  CostItemIndex
Public  DefaultItem(1024),DefaultItemNo(1024),DefaultRevenue(1024),DefaultItemDesc(1024),aItemDesc(1024),igDefaultItem(1024)
Public  aItemUnitPrice(1024) '// Unit_Price by ig 10/21/2006

Public  DefaultCostItem(1024),DefaultCostItemNo(1024),DefaultExpense(1024),DefaultCostItemDesc(1024),aCostItemDesc(1024),igDefaultCostItem(1024)
Public  aCostItemUnitPrice(1024) 
Public  vFreight, GlType
Public  Search, NewHAWB
Public  aOrigAmt(128)
Public  aOrigCost(128),OrigTotalCost	
Public  isAddFC, doInvoice, vCreateNew
Public  CheckIV,ConsigneeExist

'// by joon Dec-5-2006
Public vLock,vReadOnlyInvoice,vReadOnlyInvoice_d,vApLock,vArApLock,vArLock

'--------------------------------------Main Procedure------------------------------------------------------'

'// by joon Dec-5-2006
vArApLock = "Visible"  '// Hidden when locked
vReadOnlyInvoice = ""   '// readyonly when searched
vReadOnlyInvoice_d = ""
'// by moon Jan-6-2007
vApLock = false
vArLock = false


eltConn.BeginTrans

vUOM = GetSQLResult("SELECT uom_qty FROM user_profile WHERE elt_account_number=" & elt_account_number, "uom_qty")
vScale1 = GetSQLResult("SELECT uom FROM user_profile WHERE elt_account_number=" & elt_account_number, "uom")

Call ASSIGN_INITIAL_VALUES_TO_VARIABLES
Call CHECK_DEFAULT_FREIGT_CHARGE_ACCOUNT
Call LOAD_LIST_BOXES_FROM_DB_TO_SCREEN
Call GET_REQUEST_QUERY_STRINGS 

		'// refresh handling by iMoon
		if Save="yes" and ( tNo <> TranNo ) then
			   InvoiceNo=Request("txtInvoiceNo")
			   Search="yes"
			   Save=""
		end if

if Edit="yes" then 
'response.Write "Edit"
    FROM_EDIT="Y"
    Call GET_MAWB_FROM_DB 
    Call GET_HAWB_FROM_DB  'Get the Invoice #, yet there is no HB without an Invoice #
    '// by joon Dec-5-2006
    Call CHECK_INVOICE_LOCK
    
    Call KEEP_COST_AMOUNT_COUNT  
end if 

if NewHAWB="yes" then 
    vSec=1
    Call GET_MAWB_FROM_DB
    Call KEEP_COST_AMOUNT_COUNT  
end if 

if Search="yes" then
    SQL = "SELECT * FROM import_hawb WHERE iType='A' AND CAST(invoice_no AS NVARCHAR)=N'" _
        & InvoiceNo & "' AND elt_account_number=" & elt_account_number
    If Not IsDataExist(SQL) Then
        eltConn.CommitTrans()
        eltConn.Close()
        Set eltConn = Nothing
        Response.Write("<script>alert('No result found'); window.location.href='./arrival_notice.asp';</script>")
        Response.End
    End If
    FROM_EDIT="Y" 
 	vSec=1
	vReadOnlyInvoice = "readonly"
	vReadOnlyInvoice_d = "d_"
    '// by joon Dec-5-2006
    Call CHECK_INVOICE_LOCK
    Call GET_MAWB_FROM_DB 
    Call GET_HAWB_FROM_DB  
    Call KEEP_COST_AMOUNT_COUNT   
end if 

if AddItem="yes" then
     Call GET_REQUEST_FROM_SCREEN 
     Call KEEP_COST_AMOUNT_COUNT 
     Call CHECK_INVOICE_LOCK
end if 

if AddCostItem="yes" then
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
    CALCULATE_TOTAL_CHARGE_AND_TOTAL_COST  
    SAVING_CONDITION=vSavingCondition
     if tNo=TranNo then            
        if SAVING_CONDITION ="CREATE_NEW" then            	           
            if CREATE_AND_SAVE_NEW_INVOICE_INTO_DB = true then 
				Call SAVE_CHARGE_ITEMS_TO_INVOICE_CHARGE_ITEM_TABLE		
				Call SAVE_COST_ITEMS_TO_INVOICE_COST_ITEM_TABLE
                Call CREATE_NEW_HAWB_TO_DB
                Call SAVE_BILL_DETAIL_TO_BILL_DETAIL_TABLE 
                Call PERFORM_ACCOUNTING_TASKS 
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
            Call SAVE_BILL_DETAIL_TO_BILL_DETAIL_TABLE 
            Call PERFORM_ACCOUNTING_TASKS   	     				
            Call UPDATE_OLD_HAWB_TO_DB 
            Call UPDATE_CARGO_TRACKING_TABLE_FOR_SHIPPING_REQUEST

        elseif SAVING_CONDITION ="OVER_WRITE_WITH_NEW_HAWB_MAWB" then 
            Call UPDATE_AND_SAVE_THIS_INVOICE_IN_DB
            Call SAVE_CHARGE_ITEMS_TO_INVOICE_CHARGE_ITEM_TABLE		
            Call SAVE_COST_ITEMS_TO_INVOICE_COST_ITEM_TABLE 
            Call SAVE_BILL_DETAIL_TO_BILL_DETAIL_TABLE 
            Call PERFORM_ACCOUNTING_TASKS   	     				
            Call UPDATE_OLD_HAWB_TO_DB 
            Call UPDATE_CARGO_TRACKING_TABLE_FOR_SHIPPING_REQUEST
        end if 
	 end if	
	 
     Call KEEP_COST_AMOUNT_COUNT 
     FROM_EDIT="Y"
     Call CHECK_INVOICE_LOCK
end if	

Call SetPostBack

CALL CALCULATE_TOTAL_CHARGE_AND_TOTAL_COST

if IsCollect="Y" then 
    vTotalAmount=vTotalAmount+cdbl(vAFTotal)
end if 

'// by iMoon 2/8/2007
CALL GET_PORT_LIST


eltConn.CommitTrans

%>
<!--  #INCLUDE FILE="../include/aspFunctions_import.inc" -->
<%
'-------------------------------------------------------End of Main Process------------------------'
Sub GET_REQUEST_QUERY_STRINGS
    vAuth=Request.QueryString("Auth")
    vCreateNew=Request.QueryString("CreateNew")
    if vCreateNew=Empty or vCreateNew="" then vCreateNew="N"
    InvoiceNo=Request.QueryString("InvoiceNO")
    InvoiceNo=FixNull(InvoiceNo)    
    Session("InvoiceNo") = InvoiceNo
    vTotalAF=Request.QueryString("TotalFC")
    if vTotalAF=""  then vTotalAF="0"    
	isAddFC=request.QueryString("isAddFC")
	vTotalAF=Request.QueryString("TotalFC")	
    iType=Request.QueryString("iType")
    Edit=Request.QueryString("Edit")
    Save=Request.QueryString("Save")
    NewHAWB=Request.QueryString("NewHAWB")    
    Search=Request.QueryString("Search")    
    AddItem=Request.QueryString("AddItem")
    AddCostItem=Request.QueryString("AddCostItem")
    DeleteItem=Request.QueryString("Delete")
    DeleteHAWB=Request.QueryString("DeleteHAWB")
    
    DeleteCost=Request.QueryString("DeleteCost")
    vHAWB=Request.QueryString("HAWB")
    vMAWB=Request.QueryString("MAWB")   
    vPostBack=Request("hPostBack")  
       
    if IsPostBack = false then    
        Session("hawb")= vHAWB ' Session("hawb") will be set again when it looks up one in DB.
        Session("mawb")= vMAWB
    end if 
	
    vForwarded=Request.QueryString("forwarded")
  
	'if IsCollect="" then IsCollect ="N"
    vAgentOrgAcct=Request.QueryString("AgentOrgAcct")
    
    'response.Write"aaaaaaaaaaaaaa"&vAgentOrgAcct
    vSec=Request.QueryString("Sec")
    if vSec="" then vSec="1"
    Session("vSec")=vSec
    
    vOpenPageItemNo=Request.QueryString("ItemNo")    
    PrintOK=Request.QueryString("Print")
    tNo=Request.QueryString("tNo")
    
    if tNO="" then
	tNO=0
    else
	tNo=cLng(tNo)
    end if
    NoItem=request.QueryString("NoItem")
    if(NoItem="")then NoItem="0"
    NoItem=cInt(NoItem)
    if(NoItem < 4) then NoItem=4   
    NoCostItem=request.QueryString("NoCostItem")
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
            Response.Redirect("air_import2B.asp?HAWB=" & Server.URLEncode(vHAWB) & "&MAWB=" & Server.URLEncode(vMAWB) & "&SEC=" & vEDTSec)
        End If
    End If
    
End Sub 


Sub GET_REQUEST_FROM_SCREEN

    vArApLock =Request("hArApLock")
    'response.Write("---------------"&vArApLock)
    vDefaultAF=Request("hDefaultAF")
    vSavingCondition=Request("hSavingCondition")
    vFCDescription=Request("txtFCDescription")
    
    IsCollect=Request("hIsCollect")  
     
    if IsCollect="" or IsCollect=Empty then  IsCollect="N"
    vPostBack=Request("hPostBack")    
    vSaveAsNew=Request("hSaveAsNew")
    if vSaveAsNew="" then vSaveAsNew="N"

    doInvoice=Request("hDoInvoice")
    FROM_EDIT=Request("FROM_EDIT")
    is_default_rate=Request("hIs_default_rate")
    if(is_default_rate="") then is_default_rate="N"
	
     vSalesPerson=Request("lstSalesRP")
    if vSalesPerson = "none" then
       Call GET_DEFAULT_SALES_PERSON_FROM_DB
    end if 
	vAFRate=Request("txtCSRate")
	
	if vAFRate="" then
	 vAFRate=0
	else 
	 vAFRate=cdbl(vAFRate)
	end if 	
	 
	vAFTotal=Request("txtTotalFC")
	
	if vAFTotal=""  then 
	vAFTotal=0
	else 
	vAFTotal=cdbl(vAFTotal)
	end if 
	

	vAgentOrgAcct=Request("hAgentOrgAcct")
	InvoiceNo=Request("txtInvoiceNo")

'// Avoid data saving when back or refresh	
 
	if NOT tNo = TranNo then InvoiceNo = Session("InvoiceNo")
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
'//	vScale2=Request("lstScale2")

    vShipperName = Request.Form("lstShipperName")
	vShipperAcct = checkBlank(Request.Form("hShipperAcct"),0)
    vShipperInfo = Request("txtShipperInfo")
	
	vSubHAWB=Request("txtSubHAWB")
	vCustomerRef=Request("txtCustomerRef")

	vConsigneeInfo = Request("txtConsigneeInfo")
	vConsigneeName = Request("lstConsigneeName")
	vConsigneeAcct = checkBlank(Request("hConsigneeAcct"),0)

	vVessel=Request("txtVessel")
	vPickupDate=Request("txtPickupDate")

	vDepPort=Request("hDepText")
    vArrPort=Request("hArrText")
	vDepCode=Request("lstDepPort")
    vArrCode=Request("lstArrPort")

	vETD=Request("txtETD")
	vETA=Request("txtETA")
	vDeliveryPlace=Request("txtDeliveryPlace")
	vDestination=Request("txtDestination")
	vETD2=Request("txtETD2")
	vETA2=Request("txtETA2")

	vNotifyAcct = checkBlank(Request("hNotifyAcct"),0)
	vNotifyInfo = Request("txtNotifyInfo")
	vNotifyName = Request("lstNotifyName")

	vBrokerAcct = checkBlank(Request("hBrokerAcct"),0)
	vBrokerInfo=Request("txtBrokerInfo")
	vBrokerName = Request("lstBrokerName")
	
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
	if vScale1="K" then
		vDesc4=formatNumberPlus(vGrossWT,2) & "KG" & chr(13) & formatNumberPlus(vGrossWT*2.2046,2) & "LB"
	else
		vDesc4=formatNumberPlus(vGrossWT*0.4536,2) & "KG" & chr(13) & formatNumberPlus(vGrossWT,2) & "LB"
	end if
	if vScale1="K" then
		vDesc5=formatNumberPlus(vChgWT,2) & "KG" & chr(13) & formatNumberPlus(vChgWT*2.2046,2) & "LB"
	else
		vDesc5=formatNumberPlus(vChgWT*0.4536,2) & "KG" & chr(13) & formatNumberPlus(vChgWT,2) & "LB"
	end if
	vRemarks=Request("txtRemarks")
	if TotalAmount="" then TotalAmount=0

	NoItem=Request("hNoItem")
	NoCostItem=Request("hNoCostItem")
	
	vAirline=Request("hAirline")
	
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
	'TotalRevenue=0
	if vOpenPageItemNo="" then vOpenPageItemNo=Request("hItemNo")
	
	Call GET_CHARGE_ITEMS_FROM_SCREEN
    Call GET_COST_ITEMS_FROM_SCREEN
    if NoItem < 4  then
    	NoItem = 4     
    end if

    if NoCostItem < 4 then
    	NoCostItem = 4
    end if
End Sub 

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
    else
		rs.Close
		mawb = "no_mawb"
	end if

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

		SQL = "delete all_accounts_journal where elt_account_number = " & elt_account_number & " and customer_number in ( select customer_number from all_accounts_journal " & " where elt_account_number =" & elt_account_number & " group by customer_number  having count(customer_number) = 1 ) and tran_type = 'INIT'"
		
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
		
'//	end if
	Set hawb = nothing
	Set rs = nothing
end sub
'/////////////////////////////////////////////////////////////////////////////////////////////////

Sub DELETE_HAWB
    Dim rs
    Set rs=Server.CreateObject("ADODB.Recordset")
	    dSQL= "delete from import_hawb where elt_account_number = " & elt_account_number & " and  iType='A' and mawb_num=N'" & vMAWB & "' and hawb_num=N'" & vHAWB & "' and sec=" & vSec
	    rs.Open dSQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
    Set rs=Nothing    
    Session("hawb")=""
    Session("InvoiceNo")=""
End Sub		
		
Function HAS_INVOICE(vMAWB,vHAWB)
    SQL=""
    Dim rs 
    Set rs=Server.CreateObject("ADODB.Recordset")
    SQL="select invoice_no from import_hawb where elt_account_number=" & elt_account_number & " and iType='A' and hawb_num=N'" & vHAWB & "' and mawb_num=N'" & vMAWB &"'"
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
    if Not rs.EOF then
        CheckIV=rs("invoice_no")
        HAS_INVOICE=true
    else
        CheckIV=""
        HAS_INVOICE=false
    end if 
    Set rs=Nothing 
End Function
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
'            If rs("lock_ar").value="Y" Then
                vArApLock = "Hidden"
            End If
			
            If rs("lock_ar").value="Y" Then '// by Moon Jan-6-2007
                vArLock = true
            End If

            If rs("lock_ap").value="Y" Then '// by Moon Jan-6-2007
                vApLock = true
            End If
			
            rs.close
            Set rs=Nothing
        End If 
    End If
End SUB
'/////////////////////////////////////////////////////////////////////////////////////////////////


Sub UPDATE_OLD_HAWB_TO_DB
    SQL=""
    Dim rs 
    Set rs=Server.CreateObject("ADODB.Recordset")
    Call CALCULATE_OTHER_CHARGE_TOTAL
    
	if ( Not vAgentOrgAcct="" And Not vSec="" And Not vMAWB="") Or (Not InvoiceNo="" And Not vAgentOrgAcct="") then		

	    if vSavingCondition ="OVER_WRITE_WITH_NEW_HAWB_MAWB" then 
			    SQL= "select * from import_hawb where iType='A' and elt_account_number =" & elt_account_number & " and invoice_no=" & InvoiceNo
		else 
		    if Not vAgentOrgAcct="" And Not vSec="" then  '------from Not vHAWB=""(11/21/06)
			    SQL= "select * from import_hawb where iType='A' and elt_account_number =" & elt_account_number & " and agent_org_acct=" & vAgentOrgAcct & " and hawb_num=N'" & vHAWB& "' and mawb_num=N'" & vMAWB & "' and sec=" & vSec
		    else
			    SQL= "select * from import_hawb where iType='A' and elt_account_number =" & elt_account_number & " and agent_org_acct=" & vAgentOrgAcct & " and invoice_no=" & InvoiceNo& " and mawb_num=N'" & vMAWB & "'"
		    end if
		end if 
		
		
		rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	
		If Not rs.EOF OR Not rs.BOF Then
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
		    rs("is_default_rate")=is_default_rate		   
		    rs("invoice_no")=InvoiceNo
		    rs("process_dt")=vProcessDT
		    rs("iType")="A"    		
		    rs("processed")="Y"
		    rs("prepared_by")=vPreparedBy
		    rs("shipper_name")=vShipperName
		    rs("shipper_info")=vShipperInfo
		    rs("shipper_acct")=vShipperAcct
		    rs("igsub_hawb")=vSubHAWB
		    rs("customer_ref")=vCustomerRef
		    rs("consignee_name")=vConsigneeName
		    rs("consignee_info")=vConsigneeInfo
		    rs("consignee_acct")=vConsigneeAcct
		    'rs("vessel")=vVessel
		    rs("delivery_place")=vDeliveryPlace
		    rs("destination")=vDestination
    '// by ig
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
		    rs("etd2")= vETD2
		    rs("eta2")= vETA2
		    rs("notify_name")=vNotifyName
		    rs("notify_info")=vNotifyInfo
		    rs("notify_acct")=vNotifyAcct
			'----------------------------------------------
		    rs("broker_info")=vBrokerInfo
		    rs("broker_acct")=vBrokerAcct
			rs("broker_name")=vBrokerName
			'--------------------------------------
		    rs("container_location")=vContainerLocation
		    
		     '-----------------------------------------------
	        rs("flt_no")=vVessel			
	        rs("etd")=vETD
	        rs("eta")=vETA	
	        rs("free_date")=vFreeDate
	        rs("sub_mawb1")=vSubMAWB	
	        '---------------------------------------------------
		 
		    rs("go_date")=vGODate
		    rs("it_number")=vITNumber
		    if IsDate(vITDate) then
			    rs("it_date")=vITDate
		    end if
		    rs("it_entry_port")=vITEntryPort
		    rs("cargo_location")=vCargoLocation
		    rs("pieces")=vPCS
		    rs("uom")=vUOM
		    rs("gross_wt")=vGrossWT
		    rs("chg_wt")=vChgWT
		    rs("scale1")=vScale1
    '		rs("scale2")=vScale2
		    'rs("freight_collect")=vFreight
    		
		    rs("desc1")=mid(vDesc1,1,256)
		    rs("desc2")=mid(vDesc2,1,256)
		    rs("desc3")=mid(vDesc3,1,256)
		    rs("desc4")=mid(vDesc4,1,256)
		    rs("desc5")=mid(vDesc5,1,256)
		    rs("remarks")= mid(vRemarks,1,256) 
		    rs("term")=vTerm
		    rs("SalesPerson")=vSalesPerson	
	        rs("ModifiedBy")= session_user_lname
	        rs("ModifiedDate")=Now	
	        '-------------------------------------
    	    rs("fc_rate")=vAFRate
				
            rs("fc_charge")=vAFTotal 
             
            if IsCollect="N" then 
                rs("freight_collect")=0
            else
               rs("freight_collect")=vAFTotal
            end if      
                  
            if IsCollect="" then IsCollect="N"                     
		    rs("prepaid_collect")=IsCollect		
		    rs("oc_collect")=totalOC 
		    '-----------------------------------   		
			
'////////////////////////////////// by iMoon
		    rs("dep_code")=vDepCode
		    rs("arr_code")=vArrCode    	
		    rs("dep_port")=vDepPort
		    rs("arr_port")=vArrPort    		
'///////////////////////////////////////////
			
			
		    rs.update
		    rs.close
	    end if
	  end if 
    Session("mawb")= vMAWB
    Session("hawb")= vHAWB
	Set rs=Nothing 
End Sub 


Sub CREATE_NEW_HAWB_TO_DB

    Dim rs 
    Set rs=Server.CreateObject("ADODB.Recordset")
    Call CALCULATE_OTHER_CHARGE_TOTAL
      
	if ( Not vAgentOrgAcct="" And Not vSec="" And Not vMAWB="") Or (Not InvoiceNo="" And Not vAgentOrgAcct="") then		
		if Not vAgentOrgAcct="" And Not vSec="" then  '------from Not vHAWB=""(11/21/06)
			SQL= "select * from import_hawb where elt_account_number =" & elt_account_number & " and agent_org_acct=" & vAgentOrgAcct & " and hawb_num=N'" & vHAWB& "' and mawb_num=N'" & vMAWB & "' and sec=" & vSec
		else
			SQL= "select * from import_hawb where elt_account_number =" & elt_account_number & " and agent_org_acct=" & vAgentOrgAcct & " and invoice_no=" & InvoiceNo& " and mawb_num=N'" & vMAWB & "'"
		end if		
		
		rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText	
		If rs.EOF Then			
			rs.AddNew			
			rs("elt_account_number")=elt_account_number
			if Not vExportAgentELTAcct="" then
				rs("agent_elt_acct")=vExportAgentELTAcct
			end if
			rs("agent_org_acct")=vAgentOrgAcct
			rs("hawb_num")=vHAWB
			rs("sec")=vSec
			rs("CreatedBy")=session_user_lname	
            rs("CreatedDate")=Now
            rs("SalesPerson")=vSalesPerson
            rs("is_default_rate")=is_default_rate   
            rs("mawb_num")=vMAWB
            rs("invoice_no")=InvoiceNo
            rs("process_dt")=vProcessDT
            rs("iType")="A"
            rs("processed")="Y"
            rs("prepared_by")=vPreparedBy
            rs("shipper_name")=vShipperName
            rs("shipper_info")=vShipperInfo
            rs("shipper_acct")=vShipperAcct
            rs("igsub_hawb")=vSubHAWB
            rs("customer_ref")=vCustomerRef
            rs("consignee_name")=vConsigneeName
            rs("consignee_info")=vConsigneeInfo
            rs("consignee_acct")=vConsigneeAcct
            'rs("vessel")=vVessel
            rs("delivery_place")=vDeliveryPlace
            rs("destination")=vDestination
    '// by ig
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
    		
            rs("etd2")= vETD2
            rs("eta2")= vETA2
            rs("notify_name")=vNotifyName
            rs("notify_info")=vNotifyInfo
            rs("notify_acct")=vNotifyAcct
			'-------------------------------------
            rs("broker_info")=vBrokerInfo          
            rs("broker_acct")=vBrokerAcct
			rs("broker_name")=vBrokerName            
            '-----------------------------------------------
	        rs("flt_no")=vVessel			
	        rs("etd")=vETD
	        rs("eta")=vETA	
	        rs("free_date")=vFreeDate
	        rs("sub_mawb1")=vSubMAWB	
	        '---------------------------------------------------
            rs("container_location")=vContainerLocation
           
            rs("go_date")=vGODate
            rs("it_number")=vITNumber
            if IsDate(vITDate) then
	            rs("it_date")=vITDate
            end if
            rs("it_entry_port")=vITEntryPort
            rs("cargo_location")=vCargoLocation
            '------------------------------------------------
            
            rs("pieces")=vPCS
            rs("uom")=vUOM
            rs("gross_wt")=vGrossWT
            rs("chg_wt")=vChgWT
            rs("scale1")=vScale1
    '		rs("scale2")=vScale2
            'rs("freight_collect")=vFreight
    		
            rs("desc1")=mid(vDesc1,1,256)
            rs("desc2")=mid(vDesc2,1,256)
            rs("desc3")=mid(vDesc3,1,256)
            rs("desc4")=mid(vDesc4,1,256)
            rs("desc5")=mid(vDesc5,1,256)
            rs("remarks")= mid(vRemarks,1,256) 
            rs("term")=vTerm
            rs("SalesPerson")=vSalesPerson	
            rs("ModifiedBy")= session_user_lname
            rs("ModifiedDate")=Now	
    	    '-----------------------------------
            rs("fc_rate")=vAFRate
				

            rs("fc_charge")=vAFTotal    
               
            if IsCollect="N" then 
                rs("freight_collect")=0
            else
               rs("freight_collect")=vAFTotal
            end if                  
            if IsCollect="" then IsCollect="N"            
            rs("prepaid_collect")=IsCollect		
            rs("oc_collect")=totalOC   
            '-------------------------------------       	
			
'////////////////////////////////// by iMoon
		    rs("dep_code")=vDepCode
		    rs("arr_code")=vArrCode    	
		    rs("dep_port")=vDepPort
		    rs("arr_port")=vArrPort    		
'///////////////////////////////////////////
			
				
	        rs.update
	        rs.close		 
	    end if
	  end if 
	 Session("hawb")=vHAWB
	 Session("mawb")=vMAWB
    Set rs=Nothing 
      
End Sub 


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

Sub KEEP_COST_AMOUNT_COUNT
    if(NoItem="")then NoItem="0"
    NoItem=cInt(NoItem)
    if(NoItem < 4) then NoItem=4 
    if(NoCostItem="") then NoCostItem="0"
    NoCostItem=cInt(NoCostItem)
    if(NoCostItem<4 ) then NoCostItem=4
End Sub 

Sub ASSIGN_INITIAL_VALUES_TO_VARIABLES

    vReadOnlyInvoice = ""   '// readyonly when searched
    vReadOnlyInvoice_d = ""
    vCreateNew="N"
    vSaveAsNew="N"
    IsCollect="Y"
    FCItemIndex =-1
    NoItem=4
    NoCostItem=4
    flag=Request("Flag")
    vAFRate=0
    vAFTotal=0
    vDefault_SalesRep=session_user_lname	
   
    TranNo=Session("AIANTranNo")
    if TranNo="" then
	    Session("AIANTranNo")=0
	    TranNo=0
    end if
    
    CALL GET_PREPARER   
End Sub 

Sub GET_PREPARER
        dim rs
        SQL=""
        Set rs=Server.CreateObject("ADODB.Recordset")    
        SQL= "select  user_lname, user_fname from users where elt_account_number = " & elt_account_number & " and login_name =N'" &login_name&"'"
        
        rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
        if not rs.EOF then       
            vPreparedBy= FixNull(rs("user_fname"))&" "&FixNull(rs("user_lname"))       
        end if 
        rs.close 
        Set rs=Nothing 
End Sub 



Sub GET_MAWB_FROM_DB  
    Dim rs 
    Set rs=Server.CreateObject("ADODB.Recordset")
    SQL=""   
	if Not vMAWB="" or Not InvoiceNo="" then
	
		if vMAWB <> "" and  vSec <> "" then
			SQL="select * from import_mawb where elt_account_number=" & elt_account_number & " and iType='A' and mawb_num=N'" & vMAWB & "' and sec=" & vSec
		elseif InvoiceNo <> "" and  vHAWB = "" then 
			SQL="select a.*, b.hawb_num as HAWB from import_mawb a,import_hawb b where a.elt_account_number=b.elt_account_number and a.elt_account_number=" & elt_account_number & " and a.mawb_num=b.mawb_num and a.iType=b.iType and b.iType='A' and b.invoice_no=" & InvoiceNo & " and a.sec=b.sec"
		end if
		
        if SQL <> "" then 
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
			    	    
    			vAirline=rs("carrier_code") 
    			
    			'------------------------------------  
    			vVessel=rs("flt_no") 			
			    vETD=rs("etd")
			    vETA=rs("eta")			   
			    vCargoLocation=rs("cargo_location")
			    vITNumber=rs("it_number")
			    vITDate=rs("it_date")
			    vITEntryPort=rs("it_entry_port")
			    vDeliveryPlace=rs("place_of_delivery")
			    vFreeDate=rs("last_free_date")
			    vSubMAWB=rs("sub_mawb")	
			    '--------------------------------------
			    
			    If Not IsNull(vITEntryPort) Then
				    vITEntryPort = replace(vITEntryPort,"Select One","") 
				End If
			    
			    'vDestination=rs("fdstn")
			   	On Error Resume Next:	   
			    if InvoiceNo <> ""  then
			         vHAWB=rs("HAWB")
			          Session("hawb")=vHAWB			       	    
			    end if 
			    Session("mawb")=vMAWB
			else 
			    vMAWB=""
			    Session("mawb")=vMAWB
		        if  Search="yes" then InvoiceNo="" ' when search fails
		    end if
		    
		    rs.close
		 end if		      
	end if
    Set rs=Nothing 
End Sub

Public Function FixNull(ByVal dbvalue) 
        If isnull(dbvalue) Then
            FixNull= ""
        Else           
            FixNull= dbvalue
        End If
End Function

Sub GET_HAWB_FROM_DB

    SQL=""
    Dim rs 
    Set rs=Server.CreateObject("ADODB.Recordset")
    Dim SQL_READY
    SQL_READY=false
    
    if InvoiceNo <> "" And vHAWB = "" then
	    SQL="select * from import_hawb where elt_account_number=" & elt_account_number & " and iType='A' and invoice_no=" & InvoiceNo
	    SQL_READY=true
    else
		if  vMAWB <> "" then
			SQL="select * from import_hawb where elt_account_number=" & elt_account_number & " and iType='A' and hawb_num=N'" & vHAWB & "' and mawb_num=N'" & vMAWB & "' and sec=" & vSec
			SQL_READY=true
		end if
	end if

    if SQL_READY =true  then 
		rs.CursorLocation = adUseClient
		
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing

		if rs.EOF OR rs.BOF then  
			response.write "This A/N was deleted."
			response.end
		end if	
		
        if Not rs.EOF then
        if(isnull(rs("SalesPerson"))) then 
         vSalesPerson=""
        else 
         vSalesPerson=rs("SalesPerson")
        end if 
        vAFRate=rs("fc_rate")
         if IsNull(vAFRate) then 
            vAFRate=0
         end if	    
        vAFTotal=rs("fc_charge")
			
        if IsNull(vAFTotal) then
             vAFTotal=0
         end if
	    
        vSubHAWB=rs("igSub_HAWB") '//  used as Sub HAWB
        vHAWB=rs("hawb_num")
        vAgentOrgAcct=rs("agent_org_acct")
        if vAgentOrgAcct="" then vAgentOrgAcct=0
        
        vAgentELTAcct = ConvertAnyValue(rs("agent_elt_acct"), "Integer", 0)

        InvoiceNo=rs("invoice_no")
        InvoiceNo=FixNull(InvoiceNo)
        vSec=rs("sec")
        
        vShipperInfo = rs("shipper_info")
        vShipperAcct = ConvertAnyValue(rs("shipper_acct"),"Integer", 0) 
        If vShipperAcct <> 0 Then
            vShipperName = rs("shipper_name")
        End If
        
        vConsigneeInfo = rs("consignee_info")
        vConsigneeAcct = ConvertAnyValue(rs("consignee_acct"),"Integer",0)
        If vConsigneeAcct <> 0 Then
            vConsigneeName = rs("consignee_name")	
        End If    
        
'///////////////////////////////////////////////////////		

'/////////////////////////////////////////////////////// by iMoon 2/8/2007	
		vDepPort = checkBlank( rs("dep_port"), vDepPort )
		vArrPort = checkBlank( rs("arr_port"), vArrPort )
		vDepCode = checkBlank( rs("dep_code"), vDepCode )
		vArrCode = checkBlank( rs("arr_code"), vArrCode )


'auto create consignee

        if vConsigneeAcct = 0 And vAgentELTAcct <> 0 then
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
        vNotifyAcct = ConvertAnyValue(rs("notify_acct"), "Integer", 0)
        If vNotifyAcct <> 0 Then
            vNotifyName = rs("notify_name")
        End If

        vPreparedBy=rs("prepared_by")
        vCustomerRef=rs("customer_ref")
        vPickupDate=rs("pickup_date")
		'-----------------------------------
        vBrokerInfo=rs("broker_info")        
        vBrokerAcct=rs("broker_acct")
		vBrokerName=rs("broker_name")
		'-----------------------------------
        if IsNull(vBrokerAcct) then vBrokerAcct=0
        vDeliveryPlace=rs("delivery_place")
'// by ig 
        vProcessDT=rs("process_dt")			
        vETD2=rs("etd2")
        vETA2=rs("eta2")
        vContainerLocation=rs("container_location")
        vDestination=rs("destination")
        'vFreeDate=rs("free_date")
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
		    vITEntryPort = replace(vITEntryPort,"Select One","") 		
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
'	    vScale2=Trim(rs("scale2"))
        vDesc1=rs("desc1")
        vDesc3=rs("desc3")
        vRemarks=rs("remarks")
        vTerm=rs("term")
        is_default_rate=rs("is_default_rate")
	    
        if isnull(is_default_rate) or is_default_rate="" then
            is_default_rate="N"	  
        end if   
        if(isnull(rs("SalesPerson"))) then 
         vSalesPerson=""
        else 
         vSalesPerson=rs("SalesPerson")
         end if    
        vSalesPerson=rs("SalesPerson")	
	   	
        IsCollect=rs("prepaid_collect")
	    if IsCollect="" or IsCollect=Empty then IsCollect="N"
	    
        else
	        NoItem=4
	        tIndex=NoItem
        end if
         '------------------------------------  overwites things from MAWB
        if rs("flt_no")<> empty  then 
	         vVessel=rs("flt_no") 
	    end if 	
	    if rs("etd")<> empty  then 		
	        vETD=rs("etd")
	    end if 
	    if rs("eta")<> empty then 
	        vETA=rs("eta")	
	    end if 
	    	
	    if rs("cargo_location")<> empty  then 	   
	         vCargoLocation=rs("cargo_location")
	    end if 
	    
	    if rs("it_number")<> empty  then 
	        vITNumber=rs("it_number")
	    end if 
	    if rs("it_date")<> empty  then 
	        vITDate= rs("it_date")
	    end if 
	    
	    if rs("it_entry_port")<> empty  then 
	        vITEntryPort=rs("it_entry_port")
	    end if 
	    
	    if rs("delivery_place")<> empty  then 
	        vDeliveryPlace=rs("delivery_place")
	    end if 
	    if rs("free_date")<> empty then 
	        vFreeDate=rs("free_date")
	    end if 
	    
	    if rs("sub_mawb1")<> empty  then 
	        vSubMAWB=rs("sub_mawb1")
	    end if 	
	    '--------------------------------------
        rs.close   
             	
        Session("hawb")=vHAWB	
        Session("mawb")=vMAWB
        Call GET_CHARGE_ITEMS_FROM_DB
        GET_COST_ITEMS_FROM_DB
        
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
End Sub  

Sub RESET_HAWB
    vSalesPerson=""
    vAFRate=0
    vAFTotal=0    
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
	'----------------
    vBrokerInfo=""
    vBrokerAcct=0
	vBrokerName=""
	'-----------------
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
    is_default_rate=""	
    vSalesPerson=""
    vSalesPerson=""
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

Sub UPDATE_AND_SAVE_THIS_INVOICE_IN_DB

'/////////////////////////////////////////// by imoon 2/1/2007
	call update_customer_payment(InvoiceNo)
'///////////////////////////////////////////

    Dim rs 
    Set rs=Server.CreateObject("ADODB.Recordset")
    SQL= "select * from Invoice where elt_account_number = " & elt_account_number & " and invoice_no=" & InvoiceNo
    
    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	if Not rs.EOF then 
        OrigTotalAmt=cdbl(rs("amount_charged"))
	        '// Avoid data saving when back or refresh	
	        
        Session("InvoiceNo") = InvoiceNo
        Session("AIANTranNo")=Clng(Session("AIANTranNo"))+1
        TranNo=Clng(Session("AIANTranNo"))  
         	
        rs("import_export")="I"
        rs("air_ocean")="A"
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
        rs("Description")= mid(vDesc3,1,256)
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
        rs("Carrier")=vVessel
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
              rs("amount_charged")=vTotalAmount+ vAFTotal
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

        DIM tmpBal
        tmpBal = 0
        if not vTotalAmount="" and not isnull(vTotalAmount) then
           if IsCollect="Y" then 
              if not isnull(rs("amount_paid")) then
				tmpBal = (vTotalAmount+vAFTotal) -cDbl(rs("amount_paid"))
              else
				rs("amount_paid") = 0
				tmpBal = vTotalAmount+vAFTotal
			  end if			  
           else 
              if not isnull(rs("amount_paid")) then
			  	tmpBal = (vTotalAmount) -cDbl(rs("amount_paid"))
              else
				rs("amount_paid") = 0
				tmpBal = vTotalAmount+vAFTotal	
			  end if			  
           end if 
         else 
			 rs("amount_paid") = 0
			 tmpBal = 0
         end if 
         
        if vTotalAmount>0 then
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
        end if
		rs("balance")= tmpBal		
		if 	cDbl(rs("balance")) < 0 then 
			rs("balance") = 0			
		end if
		
        rs.Update    
     End if 
     rs.Close 

     Session("mawb")= vMAWB
     Session("hawb")= vHAWB
     Set rs=Nothing 
	 
'//////////////////////////// by iMoon 2/1/2007 //////////////////////
	call update_customer_credit( vConsigneeAcct, vConsigneeName )
'/////////////////////////////////////////////////////////////////////		
	 
 
End Sub  
'---------------------------------------------accounting section-------------------------------------------------------------'

Sub PERFORM_ACCOUNTING_TASKS
    Dim rs 
    Set rs=Server.CreateObject("ADODB.Recordset")

'delete all records from all_accounts_journal table with this InvoiceNo
		SQL= "delete from all_accounts_journal where elt_account_number = " & elt_account_number & " and tran_type='ARN' and tran_num=" & InvoiceNo
		
		eltConn.Execute SQL
' insert to all_accounts_journal for A/R
		SQL= "select max(tran_seq_num) as SeqNo from all_accounts_journal where elt_account_number = " & elt_account_number
		
		rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
		If Not rs.EOF And IsNull(rs("SeqNo"))=False Then
			SeqNo = CLng(rs("SeqNo")) + 1
		Else
			SeqNo=1
		End If
		rs.Close

' insert an init record in all_accounts_journal for the AR and for this customer if it is not exist
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
			rs("air_ocean")="A"
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
' insert transaction data to all_accounts_journal


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
			rs("air_ocean")="A"
			rs("Customer_Number")=vConsigneeAcct
			rs("Customer_Name")=vConsigneeName
			rs("memo")=mid(vRemarks,1,256)
			rs("split")=GetGLDesc(aRevenue(0))
			if isnull(vTotalAmount)or vTotalAmount="" then vTotalAmount=0
			
			if IsCollect="Y" then 
			  rs("debit_amount")=vTotalAmount+ vAFTotal
			else 
			  rs("debit_amount")=vTotalAmount
			end if 
			
			rs("credit_amount")=0
			rs("balance")=cuBalance
			rs("previous_balance")=cuPBalance
			rs("gl_balance")=arBalance
			rs("gl_previous_balance")=arPBalance
			rs.Update
		End If
			rs.Close		
'insert to all_accounts_journal for revenue accounts
'-------------------------12/11/06-----------FOR FREIGHT CHARGE ONLY--------------
        aRevenue(NoItem)=vDefaultAF_Revenue
        'aDesc(NoItem)=vDefaultAF_Desc
        aAmount(NoItem)=vAFTotal
        aItemNo(NoItem)=vDefaultAF
        lastIndex=NoItem

'---------------------------------------------------------------------------------------

		'//////////////////////////// by iMoon
		DIM flag_c
		flag_c = true
		'//////////////////////////// 

		for i=0 to lastIndex
		 if NOT aRevenue(i) = "" then 
'//////////////////////////// by iMoon
			if NOT vDefaultAF_Revenue = "" then
				if cLng(aItemNo(i))=  cLng(vDefaultAF) then 
					 if IsCollect <> "Y" then
						flag_c = false
					 end if
				end if
			end if
'//////////////////////////// 
			
			if flag_c then			
				SQL= "select * from all_accounts_journal where elt_account_number = " & elt_account_number & " and tran_seq_num=" & SeqNo
				
				rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
				if rs.EOF then
'				rs.Open "all_accounts_journal", eltConn, adOpenDynamic, adLockPessimistic, adCmdTable
					rs.AddNew
					rs("elt_account_number")=elt_account_number
					rs("gl_account_number")=aRevenue(i)
					rs("gl_account_name")=GetGLDesc(aRevenue(i))
					rs("tran_seq_num")=SeqNo
					SeqNo=SeqNo+1
					rs("tran_type")="ARN"
					rs("tran_num")=InvoiceNo
					rs("tran_date")=vProcessDT
					rs("air_ocean")="A"
					rs("Customer_Number")=vConsigneeAcct
					rs("Customer_Name")=vConsigneeName
					'rs("memo")=aDesc(i)
					rs("split")=GetGLDesc(vAR)
					rs("debit_amount")=0
					rs("credit_amount")=-aAmount(i)
					rs("balance")=cuBalance
					rs("previous_balance")=cuPBalance
					rs("gl_balance")=rBalance
					rs("gl_previous_balance")=rPBalance
					rs.Update
				End If
				rs.Close				
			end if	
'//////////////////////////// by iMoon			
				flag_c = true
'//////////////////////////// 				
		 end if 
	   next
    Set rs=Nothing 
End Sub 


Function CREATE_AND_SAVE_NEW_INVOICE_INTO_DB
    Dim rs 
    Set rs=Server.CreateObject("ADODB.Recordset")
    CREATE_AND_SAVE_NEW_INVOICE_INTO_DB=false'--------initial return value
    
	Call GET_NEXT_INVOICE_NO_FROM_USER_PROFILE
	'response.Write "--------new invoice: "& InvoiceNo
     'Session("InvoiceNo") = InvoiceNo	
     
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
			
			Session("InvoiceNo") = InvoiceNo
            Session("AIANTranNo")=Clng(Session("AIANTranNo"))+1
            TranNo=Clng(Session("AIANTranNo"))
            
            rs("import_export")="I"
            rs("air_ocean")="A"
            rs("term_curr")=vTerm
    		
            if not vProcessDT="" then
	            rs("Invoice_Date")=vProcessDT
            end if
    		
            rs("ref_no")=vCustomerRef
            rs("ref_no_Our")=vFileNo 
            rs("Customer_Info")=vConsigneeInfo
            if not TotalPieces="" then rs("Total_Pieces")=TotalPieces
            if not TotalGrossWeight="" then rs("Total_Gross_Weight")=TotalGrossWeight

    '////////////////////////////////////////////////////////////////////////////////// by iMoon NOV-13-2006
            rs("Remarks")=mid(vRemarks,1,256) 
            rs("Description")=mid(vDesc3,1,256) 
    '////////////////////////////////////////////////////////////////////////////////// end
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
            rs("Carrier")=vVessel
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
                  rs("amount_charged")=vTotalAmount+ vAFTotal
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
                  rs("balance")=vTotalAmount+ vAFTotal
                else 
                  rs("balance")=vTotalAmount
                end if 
             else 
                 rs("balance")=0
             end if 
            if vTotalAmount>0 then
	            rs("pay_status")="A"
            end if
            rs("amount_paid")=0			
			
			if 	cDbl(rs("balance")) < 0 then rs("balance") = 0			
			
            rs.Update
            rs.Close

            '--------------------------------double check ------creation------------
            SQL= "select invoice_no from Invoice where elt_account_number = " & elt_account_number & " and invoice_no=" & InvoiceNo
			
			rs.CursorLocation = adUseClient
			rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
			Set rs.activeConnection = Nothing
	        If rs.EOF=true Then
	            CREATE_AND_SAVE_NEW_INVOICE_INTO_DB=false
	        else
	           'response.Write("------------double checked")
	           Call UPDATE_NEXT_INVOICE_NO_IN_USER_PROFILE_TABLE	
	           CREATE_AND_SAVE_NEW_INVOICE_INTO_DB=true
	        end if 
	        rs.close
            '-------------------------------------------------------------------------	
		else
			rs.close
			InvoiceNo=InvoiceNo+1
		end if
	loop

    Set rs=Nothing 

'//////////////////////////// by iMoon 2/1/2007 /////////////////////////
	call update_customer_credit( vConsigneeAcct, vConsigneeName )
'////////////////////////////////////////////////////////////////////////		

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

Sub GET_ALL_ACCOUNT_RECEIVABLE

    Dim rs 
    Set rs=Server.CreateObject("ADODB.Recordset")
    SQL= "select gl_account_type,gl_account_number,gl_account_desc from gl where elt_account_number = " & elt_account_number & " and (gl_account_type=N'"&CONST__ACCOUNT_RECEIVABLE&"' or gl_master_type=N'"&CONST__MASTER_EXPENSE_NAME&"' " & " or gl_master_type=N'"&CONST__MASTER_REVENUE_NAME&"' ) order by gl_account_number"
    
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
    
    Do While Not rs.EOF
	    GlType=rs("gl_account_type")
	    '----------------------(11/21/06)
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
	'--------------------------------------------------
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
    'vAFTotal,vDefaultAF_Revenue, vDefaultAF_Desc

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
			rs("item_no")=vDefaultAF
			
			'response.Write "----"&vDefaultAF
			rs("item_desc")=vFCDescription
			if IsCollect="Y" then 
			    rs("charge_amount")=vAFTotal
			else 
			    rs("charge_amount")=0
			end if 
			rs.Update
			rs.Close		
    Set rs=Nothing 
    
    'response.Write "---------"&SQL
End Sub 

Sub SAVE_BILL_DETAIL_TO_BILL_DETAIL_TABLE
	Dim rs 
	Set rs=Server.CreateObject("ADODB.Recordset")
	SQL= "delete from bill_detail where elt_account_number=" & elt_account_number & " and invoice_no=" & InvoiceNo 
	
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

'-------------------------------------end of accounting section ----------------------------------------------'



Sub UPDATE_CARGO_TRACKING_TABLE_FOR_SHIPPING_REQUEST
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
    
    SQL= "select distinct org_account_number,DBA_NAME,is_vendor from organization where elt_account_number = " & elt_account_number _
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
        Tmp
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
End SUB

Sub CALCULATE_TOTAL_CHARGE_AND_TOTAL_COST
    vTotalAmount=0
    vTotalCost=0
    for i=0 to NoItem-1
	    vTotalAmount=vTotalAmount+aAmount(i)
    next
    for i=0 to NoCostItem-1
	    vTotalCost=vTotalCost+aRealCost(i)
    next   
    tIndex=NoItem
    Set rs=Nothing 
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

Sub GET_CHARGE_ITEMS_FROM_DB
    Dim rs 
    '-----------detecting AF---------
    Dim flag 
    flag =false
    Set rs=Server.CreateObject("ADODB.Recordset")
    Set ALItemNo= Server.CreateObject("System.Collections.ArrayList")
    Set ALChargeDesc= Server.CreateObject("System.Collections.ArrayList")
    Set ALAmount= Server.CreateObject("System.Collections.ArrayList")
    NoItem=0	
    if Not InvoiceNo="" then
	    SQL= "select item_no,item_desc,charge_amount from invoice_charge_item where elt_account_number = " & elt_account_number & " and invoice_no=" & InvoiceNo & "order by item_id"			
		
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing
	     Do While Not rs.EOF
	         if IsCollect="Y" then 
	            if rs("item_no") <> vDefaultAF then 
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
	    
	'---------------------------------------------------------------
    if NoItem < 4  then
	    NoItem = 4
    end if
    Set rs=Nothing
End Sub 

Sub GET_COST_ITEMS_FROM_DB

    Dim rs 
    Set rs=Server.CreateObject("ADODB.Recordset")

    NoCostItem=0
    if  Not InvoiceNo="" then
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
    end if 
	
'////////////////////////////////////////////	
		for j=0 to ccIndex - 1
		SQL = "select bill_number from bill_detail where elt_account_number = "&elt_account_number&" and invoice_no=" & InvoiceNo &_
			  " and vendor_number="&aVendor(j)&_
			  " and item_no=N'"&aCostItemNo(j)&"'"&_
			  " and ( item_amt="&aRealCost(j) & " or item_amt=" & -1*Cdbl(aRealCost(j)) & ") and bill_number <> 0"
				Set rs = eltConn.Execute(SQL)
		
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
    
    if NoCostItem = 0 then
	    NoCostItem = 4
    end if

    Set rs=Nothing 
End Sub 





Sub  GET_COST_ITEMS_FROM_SCREEN
'On Error Resume Next:
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
		   ' response.Write"aaaaaaaaaaaaaabbbbbbbb:"&aItemNo(i)&"<br>"
		    item=Mid(item,pos+1,200)
	    end if
	    pos=instr(item,"-")
	    if pos>0 then
		    aRevenue(i)=Mid(item,1,pos-1)
		    aItemName(i)=Mid(item,pos+1,200)
		    if aRevenue(i)="" then aRevenue(i)="0"
		    
		    aRevenue(i)=cdbl(aRevenue(i))
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


Sub CHECK_DEFAULT_FREIGT_CHARGE_ACCOUNT

 DIM rsIfAF
' check if default ocean freight charage is in the database 
    SET rsIfAF=Server.CreateObject("ADODB.Recordset")	
	SQL= "select isnull(default_air_charge_item,-1 ) as default_air_charge_item from user_profile where elt_account_number = " & elt_account_number 
	
	rsIfAF.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	dim  vCof
	vDefaultAF = ConvertAnyValue(rsIfAF("default_air_charge_item"),"Integer",0)
	
	if not rsIfAF.eof and ( vDefaultAF <> -1 )then 
		
	else response.Write("<script language='vbscript'> vConf = CofirmDFA() </script>") 
	rsIfAF.close()  
    end if

End Sub





Sub CALCULATE_OTHER_CHARGE_TOTAL
    totalOC=0
    ItemNo=Request("hNoItem")
    
    for i=0 to ItemNo-1
       if not cInt(vDefaultAF) = aItemNo(i) then 
            totalOC=totalOC+aAmount(i)
       else vFC_from_Item =aAmount(i)
       end if 
    next    
End Sub


SUB GET_DEFAULT_SALES_PERSON_FROM_DB
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
          else vSalesPerson ="" 
          end if   
      rs.close
  end if 
  Set rs=Nothing 
END SUB

Sub LOAD_LIST_BOXES_FROM_DB_TO_SCREEN
    Call GET_SALES_PERSONS_FROM_USERS_TABLE
    Call GET_MAWB_LIST_FROM_DB
    Call GET_CHARGE_ITEM_LIST_FROM_DB
    Call GET_COST_ITEM_LIST_FROM_DB
    Call GET_ALL_ACCOUNT_RECEIVABLE
    
Call get_vendor_list

End Sub 


SUB  GET_SALES_PERSONS_FROM_USERS_TABLE
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
END SUB 

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
	    if IsNull(rs("item_no")) then DefaultCostItemNo(CostItemIndex)=0
	    DefaultCostItem(CostItemIndex)=rs("item_name")
	    DefaultCostItemDesc(CostItemIndex)=rs("item_desc")
	    DefaultExpense(CostItemIndex)=rs("account_expense")
	    if IsNull(DefaultExpense(CostItemIndex)) then DefaultExpense(CostItemIndex)=0
	    
	    '// Modified by Joon on 10/15/2007 /////////////////////////////////////////////////
	    aCostItemDesc(CostItemIndex)=DefaultCostItemDesc(CostItemIndex)
        '///////////////////////////////////////////////////////////////////////////////////
        
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

Sub GET_CHARGE_ITEM_LIST_FROM_DB

    Dim rs 
    Set rs=Server.CreateObject("ADODB.Recordset")
    SQL= "select * from item_charge where elt_account_number = " & elt_account_number & " order by item_name"
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
    ItemIndex=0    
    Do While Not rs.EOF
        if rs("item_no") <> vDefaultAF then 
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
	         vDefaultAF_Revenue=rs("account_revenue")
	         vDefaultAF_Desc=rs("item_desc")
	    end if 
	    rs.MoveNext
    Loop
    rs.Close
    Set rs=Nothing     
End Sub 

Sub GET_MAWB_LIST_FROM_DB
    Dim freight_loc
    Dim rs_mawb
    Dim vAvalue    
	Set aMAWB = Server.CreateObject("System.Collections.ArrayList")
    Set aMAWBInfo= Server.CreateObject("System.Collections.ArrayList")    
    SET rs_mawb = Server.CreateObject("ADODB.Recordset")    
	SQL = "SELECT a.mawb_num FROM import_mawb a where a.elt_account_number='"& elt_account_number & "' and iType ='A' order by mawb_num"    	
	
	rs_mawb.CursorLocation = adUseClient
	rs_mawb.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs_mawb.activeConnection = Nothing
    dim ma_no
    count=0
	Do While Not rs_mawb.eof And Not rs_mawb.bof
	    if not isnull(rs_mawb("mawb_num")) then                    
            'vAvalue=rs_mawb("file_no")&"^"&rs_mawb("flt_no")&"^"&rs_mawb("cargo_location")&"^"&rs_mawb("etd")&"^"&rs_mawb("eta")&"^"&rs_mawb("dep_port")&"^"&rs_mawb("arr_port")&"^"&rs_mawb("dep_code")&"^"&rs_mawb("arr_code")&"^"&rs_mawb("agent_org_acct")&"^"&rs_mawb("sec")&"^"&rs_mawb("it_entry_port")&"^"&rs_mawb("it_number")&"^"&rs_mawb("it_date")&"^"&rs_mawb("last_free_date")&"^"&rs_mawb("carrier_code")                          
		    ma_no=rs_mawb("mawb_num")
		    aMAWB.Add ma_no	    
'            aMAWBInfo.Add vAvalue           
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
function selectSearchType(){

  var selectBox = document.getElementById('SearchType');
  var typearrival = document.getElementById('searcharrival');
	typearrival.style.display= (selectBox.value == 'arrivalNo') ? '' : 'none';
  var typehouse = document.getElementById('searchhouse');
	typehouse.style.display= (selectBox.value == 'houseNo') ? '' : 'none';
  var typemaster = document.getElementById('searchmaster');
	typemaster.style.display= (selectBox.value == 'masterNo') ? '' : 'none';
}
</script>

<!--  #include file="../include/recent_file.asp" -->
<body link="336699" vlink="336699" leftmargin="0" topmargin="0" id="en">
    <!-- tooltip placeholder -->
    <div id="tooltipcontent">
    </div>
    <!-- placeholder ends -->
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
                                <option value="houseNo">HOUSE AWB NO.</option>
                                <option value="masterNo">MASTER AWB NO.</option>
                            </select>
                        </td>
                        <td width="50%" align="right" valign="middle">
                            <div id="searcharrival">
                                <span class="bodyheader style4">
                                    <input name="txtFindIV" id="txtFindIV" type="text" class="lookup" style="width: 120px" value="Arrival No. Here"
                                        onfocus="javascript:this.value =''; this.style.color='#000000'; " onkeypress="javascript: if(event.keyCode == 13) { FindByInvoiceNo('txtFindIV'); }" />

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
                    <div id="print">
                        <img src="/ASP/Images/icon_printer.gif" align="absbottom"><a href="javascript:;"
                            onclick="if(CheckIfANExist()==true){SaveClick('<%= TranNo %>','yes')};return false;">Arrival
                            Notice</a><img src="/ASP/Images/button_devider.gif"><a href="javascript:;"
                                onclick="if(CheckIfANExist()==true){SaveClick2('<%= TranNo %>','yes')};return false;">Arrival
                                Notice & Freight Invoice</a><img src="/ASP/Images/button_devider.gif"><a
                                    href="javascript:;" onclick="SaveClick3('<%= TranNo %>');return false;">Authority
                                    to Make Entry</a></div>
                </td>
            </tr>
        </table>
    </div>
    <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#ba9590">
        <tr>
            <td>
                <form name="form1">
                    <input name="hIsCollect" type="hidden" value="<%= IsCollect %>" />
                    <input name="hArApLock" type="hidden" value="<%= vArApLock %>" />
                    <input name="hDefaultAF" type="hidden" value="<%= vDefaultAF %>" />
                    <input name="hHBExist" type="hidden" value="<%= vHBExist %>" />
                    <input id="hSavingCondition" name="hSavingCondition" type="hidden" />
                    <input name="hPostBack" type="hidden" value="<%= vPostBack %>" />
                    <input name="hSaveAsNew" type="hidden" value="<%= vSaveAsNew %>" />
                    <input type="hidden" name="hAgentOrgAcct" id="hAgentOrgAcct" value="<%= vAgentOrgAcct %>" />
                    <input name="FROM_EDIT" type="hidden" value="<%= FROM_EDIT %>" />
                    <input name="hIs_default_rate" type="hidden" value="<%= is_default_rate %>" />
                    <input type="hidden" name="hSec" id="hSec" value="<%= vSec %>" />
                    <input type="hidden" name="hNoItem" id="hNoItem" value="<%= NoItem %>" />
                    <input type="hidden" name="hNoCostItem" id="hNoCostItem" value="<%= NoCostItem %>" />
                    <input type="hidden" name="hInvoiceNo" id="hInvoiceNo" value="<%= InvoiceNo %>" />
                    <input type="hidden" name="hGrossWT" id="hGrossWT" value="<%= vGrossWT %>" />
                    <input type="hidden" name="hItemNo" id="hItemNo" value="<%= vOpenPageItemNo %>" />
                    <!-- start of scroll bar -->
                    <input type="hidden" name="scrollPositionX">
                    <input type="hidden" name="scrollPositionY">
                    <!-- end of scroll bar -->
                    <table width="100%" border="0" cellpadding="2" cellspacing="1">
                        <tr bgcolor="edd3cf">
                            <td width="10%" height="22" align="center" valign="middle" bgcolor="edd3cf" class="bodyheader">
                                <table width="98%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="26%">
                                            &nbsp;</td>
                                        <td width="48%" align="center">

                                            <img height="18" name="bSave" onclick="if(CheckIfANExist()==true){SaveClick('<%= TranNo %>','no')}"
                                                src="../images/button_save_medium.gif" style="cursor: hand" width="46" alt="" />

                                            <!--<input name="chkPrintInvoice" type="checkbox"  onClick="chkPrintInvoiceChange()" value='<%=doInvoice %>' checked/>-->
                                            <input type="hidden" name="hDoInvoice" id="hDoInvoice" value='yes' />
                                            <% 'end if	%>
                                        </td>
                                        <td width="13%" align="right">
                                            <img style="cursor: hand" src="/ASP/Images/button_new.gif" width="42" height="17"
                                                onclick='AddHAWB()'></td>
                                        <td width="13%" align="right">
                                            <img style="cursor: hand; visibility: <%=vArApLock %>" src="/iff_main/Images/button_delete_medium.gif"
                                                onclick="DeleteHAWB()"></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr align="center" valign="middle" bgcolor="efe1df">
                            <td height="24" align="center" bgcolor="#f3f3f3" class="bodyheader">
                                <br>
                                <table width="90%" border="0" cellpadding="0" cellspacing="0" class="bodyheader">
                                    <tr>
                                        <td height="28" align="right">
                                            <img src="/ASP/Images/required.gif" align="absbottom">Required field</td>
                                    </tr>
                                </table>
                                <table width="90%" border="0" cellpadding="2" cellspacing="0" bordercolor="ba9590"
                                    bgcolor="edd3cf" class="border1px">
                                    <tr align="left" valign="middle" bgcolor="efe1df">
                                        <td align="left" valign="middle">
                                            &nbsp;</td>
                                        <td height="20" align="left" valign="middle">
                                            &nbsp;</td>
                                        <td>
                                            <strong><span class="style4">Arrival Notice No.</span></strong></td>
                                        <td>
                                            <strong>File No. </strong>
                                        </td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="ffffff">
                                        <td align="left" valign="middle">
                                            &nbsp;</td>
                                        <td height="20" align="left" valign="middle">
                                            <strong>&nbsp;</strong></td>
                                        <td>
                                            <strong>
                                                <input name="txtInvoiceNo" id="txtInvoiceNo" type="text" class="readonlybold" value="<%= InvoiceNo %>"
                                                    size="24" readonly>
                                                <br>
                                                <br>
                                            </strong>
                                            <%if InvoiceNo<>"" And agent_status="A" then response.Write("<img src='/ASP/Images/icon_goto.gif'><span class='goto'><a href='javascript:goInvoice();'>Go to Invoice</a></span>") end if %>
                                        </td>
                                        <td valign="top">
                                            <input name="txtRefNo" id="txtRefNo" type="text" class="readonlybold" value="<%= vFileNo %>" readonly
                                                size="24"></td>
                                    </tr>
                                    <tr>
                                        <td height="1" colspan="4" align="left" valign="middle" bgcolor="ba9590">
                                        </td>
                                    </tr>
                                    <tr bgcolor="efe1df">
                                        <td align="left" valign="middle">
                                            &nbsp;</td>
                                        <td height="20" align="left" valign="middle">
                                            <b>Shipper</b></td>
                                        <td width="28%" align="left" valign="middle" bgcolor="efe1df">
                                            <span class="style1"><strong><span class="bodycopy">
                                                <img src="/ASP/Images/required.gif" align="middle"></span>Master AWB No.
                                                <% if mode_begin then %>
                                            </strong></span>
                                            <div style="width: 21px; display: inline; vertical-align: middle" onmouseover="showtip('This Field is to select previously entered MAWB Numbers for the purpose of adding a new house to that Deconsolidation.  The relevant Master Bill data will be automatically populated here on the A/N.');"
                                                onmouseout="hidetip()">
                                                <img src="../Images/button_info.gif" align="middle" class="bodylistheader"></div>
                                            <% end if %>
                                            <span class="style1"><strong></strong></span>
                                        </td>
                                        <td width="23%" align="left" valign="middle" bgcolor="efe1df">
                                            <span class="style1"><strong>House AWB No. </strong></span>
                                        </td>
                                    </tr>
                                    <tr bgcolor="#FFFFFF">
                                        <td width="1%" rowspan="3" align="left" valign="top">
                                            &nbsp;</td>
                                        <td width="48%" rowspan="3" align="left" valign="top">
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
                                                            onfocus="initializeJPEDField(this,event);" /></td>
                                                    <td>
                                                        <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstShipperName','Shipper','lstShipperNameChange')"
                                                            style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                            border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                    <td>
                                                        <input type='hidden' id='quickAdd_output'/>
                                                        <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                            onclick="quickAddClient('hShipperAcct','lstShipperName','txtShipperInfo')" /></td>
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
                                            <%  iMoonComboBoxWidth =  "160px" %>

                                            <script type="text/jscript"> 
function <%=iMoonComboBoxName%>_OnChangePlus() 
{ 
	var slt=$("select.lstMAWB>option");
  	var index=document.getElementById("lstMAWB").selectedIndex; 
  	document.getElementById("txtMAWB").value=slt.get(index).text;
	lstMAWBChange_air(document.getElementById("txtMAWB").value); 
}
function  lstMAWB_OnAddNewPlus(){}
                                            </script>

                                            <% if vArApLock = "Visible" then %>
                                            <div id="<%=iMoonComboBoxName%>_Container" class="ComboBox" style="width: <%=iMoonComboBoxWidth%>;
                                                position: ; top: ; left: ; z-index: ;">
                                                <input name="<%=iMoonComboBoxName%>_Text" type="text" id="<%=iMoonComboBoxName%>_Text"
                                                    class="ComboBox" autocomplete="off" style="width: <%=iMoonComboBoxWidth%>; vertical-align: middle"
                                                    value="<%=iMoonDefaultValue%>" />
                                                <div id="<%=iMoonComboBoxName%>_Div" style="display: none; position: absolute; top: 0;
                                                    left: -140px; width: 17px">
                                                    <img id="<%=iMoonComboBoxName%>_Button" src="/ig_common/Images/combobox_drop.gif"
                                                        border="0" /></div>
                                            </div>
                                            <div id="<%=iMoonComboBoxName%>_NewDiv" style="display: none; position: absolute;
                                                top: 0; left: 0; width: 17px">
                                                <img id="<%=iMoonComboBoxName%>_AddNewButton" src="/ig_common/Images/combobox_addnew.gif"
                                                    border="0" /></div>
                                            <% else %>
                                            <div id="<%=iMoonComboBoxName%>_Container" class="ComboBox" style="width: <%=iMoonComboBoxWidth%>;
                                                position: ; top: ; left: ; z-index: ;">
                                                <input id="<%=iMoonComboBoxName%>_Text" autocomplete="off" class="ComboBox" name="<%=iMoonComboBoxName%>:Text"
                                                    readonly="true" style="width: <%=iMoonComboBoxWidth%>; vertical-align: middle;
                                                    background-color: #CCCCCC" type="text" value="<%=iMoonDefaultValue%>" /></div>
                                            <div id="<%=iMoonComboBoxName%>_NewDiv" style="display: none; position: absolute;
                                                top: 0; left: 0; width: 17px">
                                            </div>
                                            <%end if  %>
                                            <select name="lstMAWB" id="lstMAWB" listsize="20" class="ComboBox lstMAWB" style="width: 160px;
                                                display: none" tabindex="3" >
                                                <option value=""></option>
                                                <% For i=0 To aMAWB.count-1%>
                                                <option value="<%= aMAWB(i) %>" <%if vMAWB= aMAWB(i) then response.write("selected")  %>><%
= aMAWB(i) %></option>
                                                <%  Next  %>
                                            </select>
                                            <!-- /End of Combobox/ -->
                                            <br>

                                            <script  type="text/javascript">
                                                document.getElementById('lstMAWB').addEventListener('click', function (e) {
                                                    e = e || window.event;
                                                    var target = e.target || e.srcElement;
                                                    var name = target.id || target.getAttribute('name');
                                                    //alert('the ' + name + ' element changed!');
                                                    ComboBox_SimpleAttach(document.getElementById('lstMAWB'), document.getElementById('<%=iMoonComboBoxName%>_Text'));

                                                }, false);


					function trim(sourceString) { return sourceString.replace(/(?:^\s+|\s+$)/ig, ""); }
					
					function goDeconsol() {
					    try {
					        // Tab move to International
//					        if (window.opener != null) {
//					            window.opener.parent.document.frames['topFrame'].changeTopModule("International");
//                            }
//					        else {
//					            parent.document.frames['topFrame'].changeTopModule("International");
//                            }	
//                            
					        var mawb = document.getElementById("lstMAWB_Text").value;
						    if (trim(mawb) == '') 
						    {
							    alert('Please select a MAWB No.');
							    return false;
						    }
							var sec = document.form1.hSec.value;
							//air_import2.asp?
						    var url = 'iType=A&Edit=yes&MAWB=' + mawb +'&Sec='+sec+'&AgentOrgAcct='+ document.form1.hAgentOrgAcct.value;
    // branch
						    var branch = '<%=headBranch%>';
						    if (branch != '') {
							    url += '&Branch=' + branch;
						    }

						    if(opener){
						        opener.parent.location.href = "../../AirImport/Deconsolidation/"+ encodeURI(url);
						    }else{
						        parent.location.href = "../../AirImport/Deconsolidation/" + encodeURI(url);
						    }
					    }
					    catch (f) {}
					}
					
					
					
					function goInvoice() {
					    try {
					        // Tab move to accounting
//					        if (window.opener != null) { 
//                                window.opener.parent.document.frames['topFrame'].changeTopModule("Accounting");}
//							else {parent.document.frames['topFrame'].changeTopModule("Accounting");}
							
							var invoice= document.getElementById("txtInvoiceNo").value;
							if (trim(invoice) == '') 
							{
							    return false;
							}
							
							var url = 'edit=yes&InvoiceNo=' +invoice;
							
							var branch = '<%=headBranch%>';
							if (branch != '') {
								url += '&Branch=' + branch;
							}

				            if (opener) {
				                opener.parent.location.href = "../../Accounting/AddInvoice/" + encodeURI(url);
				            } else {
				                parent.location.href = "../../Accounting/AddInvoice/" + encodeURI(url);
				            }

				
						}catch (err) {}
					}
                                            </script>

                                            <img src="/ASP/Images/icon_goto.gif" width="36" height="21" align="absbottom"><span
                                                class="goto"><a href="javascript:void(goDeconsol());">Go to Deconsolidation </a>
                                            </span>
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
                                        <td height="20" align="left" valign="middle" bgcolor="#efe1df">
                                            <strong>Sub AWB</strong></td>
                                        <td align="left" valign="middle" bgcolor="#efe1df">
                                            &nbsp;</td>
                                    </tr>
                                    <tr bgcolor="#F3f3f3">
                                        <td height="20" align="left" valign="top" bgcolor="#FFFFFF">
                                            <input name="txtSubHAWB" type="text" class="shorttextfield" maxlength="32" value="<%= vSubHAWB %>"
                                                size="30" id="txtSubHAWB"></td>
                                        <td align="left" valign="top" bgcolor="#FFFFFF">
                                            &nbsp;</td>
                                    </tr>
                                    <tr bgcolor="efe1df">
                                        <td align="left" valign="middle">
                                            &nbsp;</td>
                                        <td height="20" align="left" valign="middle">
                                            <strong><span class="bodycopy">
                                                <img src="/ASP/Images/required.gif" align="absbottom"></span>Consignee</strong></td>
                                        <td align="left" valign="middle" bgcolor="efe1df">
                                            <strong>Date</strong></td>
                                        <td align="left" valign="middle">
                                            <strong>Doc. Pickup Date</strong></td>
                                    </tr>
                                    <tr bgcolor="#F3f3f3">
                                        <td rowspan="4" align="left" valign="top" bgcolor="#FFFFFF">
                                            &nbsp;</td>
                                        <td rowspan="4" align="left" valign="top" bgcolor="#FFFFFF">
                                            <!-- Start JPED -->
                                            <input type="hidden" id="hConsigneeAcct" name="hConsigneeAcct" value="<%=vConsigneeAcct %>" />
                                            <div id="lstConsigneeNameDiv">
                                            </div>
                                            <table cellpadding="0" cellspacing="0" border="0" id="tblConsignee">
                                                <tr>
                                                    <td>
                                                        <input type="text" autocomplete="off" id="lstConsigneeName" name="lstConsigneeName"
                                                            value="<%=vConsigneeName %>" class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9;
                                                            border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;"
                                                            onkeyup="organizationFill(this,'Consignee','lstConsigneeNameChange',null,event)" onfocus="initializeJPEDField(this,event);" /></td>
                                                    <td>
                                                        <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstConsigneeName','Consignee','lstConsigneeNameChange',null,event)"
                                                            style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                            border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                    <td>
                                                        <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                            onclick="quickAddClient('hConsigneeAcct','lstConsigneeName','txtConsigneeInfo')" /></td>
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
                                        <td height="20" align="left" valign="top" bgcolor="#FFFFFF">
                                            <input name="txtDate" type="text" class="m_shorttextfield " 
                                                preset="shortdate" value="<%= vProcessDT %>"
                                                size="24" id="txtDate"></td>
                                        <td align="left" valign="top" bgcolor="#FFFFFF">
                                            <input name="txtPickupDate" type="text" class="m_shorttextfield " preset="shortdate"
                                                value="<%= vPickupDate %>" size="24" id="txtPickupDate"></td>
                                    </tr>
                                    <tr bgcolor="#F3f3f3">
                                        <td height="20" align="left" valign="top" bgcolor="#efe1df" class="bodyheader style2">
                                            <span class="style3">Customer Reference No. </span>
                                        </td>
                                        <td height="20" align="left" valign="middle" bgcolor="#efe1df">
                                            &nbsp;</td>
                                    </tr>
                                    <tr bgcolor="#F3f3f3">
                                        <td height="20" align="left" valign="top" bgcolor="#FFFFFF">
                                            <strong>
                                                <input name="txtCustomerRef" type="text" class="shorttextfield" 
                                                maxlength="64" value="<%= vCustomerRef %>"
                                                    size="30" id="txtCustomerRef">
                                            </strong>
                                        </td>
                                        <td align="left" valign="top" bgcolor="#FFFFFF">
                                            <input name="txtSubMAWB" type="hidden" class="d_shorttextfield" value="<%= vSubMAWB %>"
                                                size="29"></td>
                                    </tr>
                                    <tr bgcolor="#F3f3f3">
                                        <td height="20" align="left" valign="top" bgcolor="#FFFFFF">
                                            &nbsp;</td>
                                        <td align="left" valign="top" bgcolor="#FFFFFF">
                                            &nbsp;</td>
                                    </tr>
                                    <tr bgcolor="efe1df">
                                        <td align="left" valign="middle">
                                            &nbsp;</td>
                                        <td height="20" align="left" valign="middle">
                                            <strong>Notify Party</strong></td>
                                        <td align="left" valign="middle" bgcolor="efe1df">
                                            <strong>Flight No.</strong></td>
                                        <td align="left" valign="middle">
                                            &nbsp;</td>
                                    </tr>
                                    <tr bgcolor="#FFFFFF">
                                        <td rowspan="4" align="left" valign="top">
                                            &nbsp;</td>
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
                                                            onfocus="initializeJPEDField(this,event);" /></td>
                                                    <td>
                                                        <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstNotifyName','Notify','lstNotifyNameChange',null,event)"
                                                            style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                            border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                    <td>
                                                        <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                            onclick="quickAddClient('hNotifyAcct','lstNotifyName','txtNotifyInfo')" /></td>
                                                </tr>
                                            </table>
                                            <textarea id="txtNotifyInfo" name="txtNotifyInfo" class="multilinetextfield" cols=""
                                                rows="5" style="width: 300px"><%=vNotifyInfo %></textarea>
                                            <!-- End JPED -->
                                        </td>
                                        <td height="20" align="left" valign="top" bgcolor="#FFFFFF">
                                            <input name="txtVessel" id="txtVessel" type="text" class="shorttextfield" maxlength="32" value="<%= vVessel %>"
                                                size="30"></td>
                                        <td align="left" valign="top" bgcolor="#FFFFFF">
                                            &nbsp;</td>
                                    </tr>
                                    <tr bgcolor="#F3f3f3">
                                        <td height="20" align="left" valign="middle" bgcolor="#efe1df">
                                            <strong>Port of Loading</strong></td>
                                        <td align="left" valign="middle" bgcolor="#efe1df">
                                            <strong>ETD</strong></td>
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
                                            <input name="txtETD" type="text" class="m_shorttextfield " 
                                                preset="shortdate" value="<%= vETD %>"
                                                size="20" id="txtETD"></td>
                                    </tr>
                                    <tr bgcolor="#F3f3f3">
                                        <td height="20" align="left" valign="top" bgcolor="#FFFFFF">
                                            &nbsp;</td>
                                        <td align="left" valign="top" bgcolor="#FFFFFF">
                                            &nbsp;</td>
                                    </tr>
                                    <tr bgcolor="efe1df">
                                        <td align="left" valign="middle">
                                            &nbsp;</td>
                                        <td height="20" align="left" valign="middle">
                                            <strong>Broker</strong></td>
                                        <td align="left" valign="middle">
                                            <strong>Port of Discharge</strong></td>
                                        <td align="left" valign="middle">
                                            <strong>ETA</strong></td>
                                    </tr>
                                    <tr bgcolor="#F3f3f3">
                                        <td rowspan="5" align="left" valign="top" bgcolor="#FFFFFF">
                                            &nbsp;</td>
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
                                                            border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Broker','lstBrokerNameChange',50,event)"
                                                            onfocus="initializeJPEDField(this,event);" /></td>
                                                    <td>
                                                        <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstBrokerName','Broker','lstBrokerNameChange',null,event)"
                                                            style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                            border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                    <td>
                                                        <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                            onclick="quickAddClient('hBrokerAcct','lstBrokerName','txtBrokerInfo')" /></td>
                                                </tr>
                                            </table>
                                            <textarea id="txtBrokerInfo" name="txtBrokerInfo" class="multilinetextfield" cols=""
                                                rows="5" style="width: 300px"><%=vBrokerInfo %></textarea>
                                            <!-- End JPED -->
                                        </td>
                                        <td height="20" align="left" valign="top" bgcolor="#FFFFFF">
                                            <select name="lstArrPort"  id="lstArrPort" onchange="doArrPortChange(this)" class="smallselect" style="width: 160px">
                                                <% for i=0 to port_list.count-1 %>
                                                <option value='<%=port_list(i)("port_code")%>' <% 
														  if vArrCode=port_list(i)("port_code") then response.write(" selected")%>>
                                                    <%= port_list(i)("port_desc") %>
                                                </option>
                                                <% next %>
                                            </select>
                                        </td>
                                        <td align="left" valign="top" bgcolor="#FFFFFF">
                                            <input name="txtETA" type="text" class="m_shorttextfield " 
                                                preset="shortdate" value="<%= vETA %>"
                                                size="20" id="txtETA"></td>
                                    </tr>
                                    <tr bgcolor="#F3f3f3">
                                        <td height="20" align="left" valign="middle" bgcolor="#efe1df">
                                            <strong>Place of Delivery</strong></td>
                                        <td align="left" valign="middle" bgcolor="#efe1df">
                                            <strong>ETA</strong></td>
                                    </tr>
                                    <tr bgcolor="#F3f3f3">
                                        <td align="left" valign="top" bgcolor="#FFFFFF" style="height: 22px">
                                            <input name="txtDeliveryPlace" type="text" class="shorttextfield" maxlength="64"
                                                value="<%= vDeliveryPlace %>" size="30" id="txtDeliveryPlace"></td>
                                        <td align="left" valign="top" bgcolor="#FFFFFF" style="height: 22px">
                                            <input name="txtETD2" type="text" class="m_shorttextfield " 
                                                preset="shortdate" value="<%= vETD2 %>"
                                                size="20" id="txtETD2"></td>
                                    </tr>
                                    <tr bgcolor="#F3f3f3">
                                        <td height="20" align="left" valign="middle" bgcolor="#efe1df">
                                            <strong>Final Destination</strong></td>
                                        <td align="left" valign="middle" bgcolor="#efe1df">
                                            <strong>ETA</strong></td>
                                    </tr>
                                    <tr bgcolor="#F3f3f3">
                                        <td height="20" align="left" valign="top" bgcolor="#FFFFFF">
                                            <input name="txtDestination" type="text" class="shorttextfield" value="<%= vDestination %>"
                                                size="30" id="txtDestination"></td>
                                        <td align="left" valign="top" bgcolor="#FFFFFF">
                                            <input name="txtETA2" type="text" class="m_shorttextfield " 
                                                preset="shortdate" value="<%= vETA2 %>"
                                                size="20" id="txtETA2"></td>
                                    </tr>
                                    <tr bgcolor="efe1df">
                                        <td>
                                        </td>
                                        <td height="20" colspan="3" align="left" valign="middle">
                                            <strong>Freight Location</strong></td>
                                    </tr>
                                    <tr bgcolor="#FFFFFF">
                                        <td>
                                        </td>
                                        <td height="20" colspan="3" align="left" valign="middle">
                                            <input name="txtCargoLocation" type="text" class="shorttextfield" value="<%= vCargoLocation %>"
                                                size="147" id="txtCargoLocation"></td>
                                    </tr>
                                    <tr bgcolor="#F3f3f3">
                                        <td align="left" valign="middle" bgcolor="efe1df">
                                            &nbsp;</td>
                                        <td height="20" align="left" valign="middle" bgcolor="efe1df">
                                            <strong>Container Return Location </strong>
                                        </td>
                                        <td align="left" valign="middle" bgcolor="efe1df">
                                            <strong>Last Free Date</strong></td>
                                        <td align="left" valign="middle" bgcolor="efe1df">
                                            <strong>G.O. Date</strong></td>
                                    </tr>
                                    <tr bgcolor="#F3f3f3">
                                        <td align="left" valign="middle" bgcolor="#FFFFFF">
                                            &nbsp;</td>
                                        <td height="20" align="left" valign="middle" bgcolor="#FFFFFF">
                                            <input name="txtContainerLocation" type="text" class="shorttextfield" value="<%= vContainerLocation %>"
                                                size="60" id="txtContainerLocation"></td>
                                        <td align="left" valign="middle" bgcolor="#FFFFFF">
                                            <input name="txtFreeDate" type="text" class="m_shorttextfield " preset="shortdate"
                                                value="<%= vFreeDate %>" size="30" id="txtFreeDate"></td>
                                        <td align="left" valign="middle" bgcolor="#FFFFFF">
                                            <input name="txtGODate" type="text" class="m_shorttextfield " 
                                                preset="shortdate" value="<%= vGODate %>"
                                                size="20" id="txtGODate"></td>
                                    </tr>
                                    <tr bgcolor="efe1df">
                                        <td align="left" valign="middle">
                                            &nbsp;</td>
                                        <td height="20" align="left" valign="middle">
                                            <strong>I.T No.</strong></td>
                                        <td align="left" valign="middle">
                                            <strong>I.T Date</strong></td>
                                        <td align="left" valign="middle">
                                            <strong>I.T Entry Port</strong></td>
                                    </tr>
                                    <tr bgcolor="#FFFFFF">
                                        <td align="left" valign="middle">
                                            &nbsp;</td>
                                        <td height="20" align="left" valign="middle">
                                            <input name="txtITNumber" type="text" class="shorttextfield" value="<%= vITNumber %>"
                                                maxlength="64" size="60" id="txtITNumber"></td>
                                        <td align="left" valign="middle">
                                            <input name="txtITDate" type="text" class="m_shorttextfield " 
                                                preset="shortdate" value="<%= vITDate %>"
                                                size="30" id="txtITDate"></td>
                                        <td align="left" valign="middle">
                                            <input name="txtITEntryPort" type="text" class="shorttextfield" value="<%= vITEntryPort %>"
                                                size="30" id="txtITEntryPort"></td>
                                    </tr>
                                </table>
                                <table width="90%" border="0" cellpadding="2" cellspacing="0" bordercolor="ba9590"
                                    class="border1px">
                                    <tr>
                                        <td width="1%" height="20" bgcolor="edd3cf">
                                            &nbsp;</td>
                                        <td colspan="7" bgcolor="edd3cf">
                                            <span class="style1"><strong>PARTICULARS FURNISHED BY SHIPPER</strong></span></td>
                                    </tr>
                                    <tr>
                                        <td height="1" colspan="8" align="left" valign="middle" bgcolor="ba9590">
                                        </td>
                                    </tr>
                                    <tr class="bodycopy">
                                        <td height="23" bgcolor="efe1df">
                                            &nbsp;</td>
                                        <td width="17%" align="left" valign="middle" bgcolor="efe1df" class="bodycopy">
                                            <strong>Marks &amp; Numbers</strong></td>
                                        <td width="16%" align="left" valign="middle" bgcolor="efe1df" class="bodycopy">
                                            <strong>No. of CTN </strong>
                                        </td>
                                        <td width="8%" align="left" valign="middle" bgcolor="efe1df" class="bodycopy">
                                            <strong>Gross Wt</strong></td>
                                        <td width="17%" align="left" valign="middle" bgcolor="efe1df" class="bodycopy">
                                            <b>
                                                <% if iType="O" then response.write("Measure") else response.write("Charge Wt &nbsp;&nbsp;&nbsp;&nbsp;Scale") %>
                                            </b>
                                        </td>
                                        <td width="11%" align="left" valign="middle" bgcolor="efe1df" class="bodycopy">
                                            <strong>Fetch Defult Rate </strong>
                                        </td>
                                        <td width="13%" align="left" valign="middle" bgcolor="efe1df" class="bodycopy">
                                            <strong>Rate</strong></td>
                                        <td width="17%" align="left" valign="middle" bgcolor="efe1df" class="bodycopy">
                                            <span class="style6">Freight Charge</span></td>
                                    </tr>
                                    <tr align="left" valign="top" class="bodycopy">
                                        <td rowspan="3" bgcolor="#FFFFFF">
                                            &nbsp;
                                        </td>
                                        <td rowspan="3" valign="top" bgcolor="#FFFFFF">
                                            <textarea name="txtDesc1" cols="30" rows="5" class="multilinetextfield" 
                                                id="txtDesc1"><%= vDesc1 %></textarea></td>
                                        <td valign="middle" bgcolor="#FFFFFF">
                                            <input name="txtPCS" type="text" class="shorttextfield" value="<%= vPCS %>" size="10"
                                                style="behavior: url(../include/igNumDotChkLeft.htc)" id="txtPCS" />
                                            <select name="lstUOM" class="smallselect" id="lstUOM">
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
                                        <td valign="middle" bgcolor="#FFFFFF">
                                            <input name="txtGrossWT" id="txtGrossWT" type="text" class="shorttextfield" value="<%= vGrossWT %>"
                                                size="10" style="behavior: url(../include/igNumDotChkLeft.htc)" /></td>
                                        <td valign="middle" bgcolor="#FFFFFF">
                                            <input name="txtChgWT" id="txtChgWT" type="text" class="shorttextfield" value="<%= vChgWT %>" onblur="getCustomerSellingRate()"
                                                size="10" style="behavior: url(../include/igNumDotChkLeft.htc)" />
                                            <select name="lstScale1" id="lstScale1" class="smallselect lstScale1" onchange="scaleChange(this);  ">
                                                <option value="L" <% if vScale1="L" Or vScale1="LB" then response.write("selected") %>>LB</option>
                                                <option value="K" <% if vScale1="K" Or vScale1="KG" then response.write("selected") %>>KG</option>
                                            </select>
                                        </td>
                                        <td align="center" valign="middle" bgcolor="#FFFFFF">
                                            <img name="chkDfRate" id="chkDfRate" onclick="getCustomerSellingRate()" style="cursor: hand"
                                                onmouseup="src='../Images/icon_rate_on.gif'" src='../Images/icon_rate_on.gif'
                                                onmousedown="src='../Images/icon_rate_off.gif'" /></td>
                                        <td valign="middle" bgcolor="#FFFFFF">
                                            <input id="txtCSRate" name="txtCSRate" size="8" class="shorttextfield" type="text"
                                                value="<%=vAFRate%>" onblur="catchRatingInfo();" style="behavior: url(../include/igNumDotChkLeft.htc)">
                                            <img src="../Images/button_cal.gif" align="middle" onclick="calculateTotalFc();" /></td>
                                        <td valign="middle" bgcolor="#FFFFFF">
                                            <input size="10" onblur="AmountChange(1000)" id="txtTotalFC" name="txtTotalFC" class="bodyheader"
                                                value="<%=formatNumberPlus(vAFTotal,2)%>" type="text" style="behavior: url(../include/igNumDotChkLeft.htc)">
                                        </td>
                                    </tr>
                                    <tr align="left" valign="top" class="bodycopy">
                                        <td height="22" colspan="2" valign="top" bgcolor="#FFFFFF">
                                            &nbsp;</td>
                                        <td bgcolor="#FFFFFF" class="bodyheader">
                                            &nbsp;</td>
                                        <td height="23" colspan="2" valign="middle" class="bodyheader">
                                            Freight Charge Description
                                        </td>
                                        <td valign="middle" class="bodyheader">
                                            Payment</td>
                                    </tr>
                                    <tr align="left" valign="top" class="bodycopy">
                                        <td colspan="2" valign="top" bgcolor="#FFFFFF">
                                            &nbsp;</td>
                                        <td bgcolor="#FFFFFF">
                                            &nbsp;</td>
                                        <td colspan="2" valign="top" bgcolor="#FFFFFF">
                                            <input name="txtFCDescription" type="text" class="shorttextfield" id="txtFCDescription"
                                                value="<%if vFCDescription ="" then response.write vDefaultAF_Desc else response.write vFCDescription end if  %>"
                                                size="30" /></td>
                                        <td bgcolor="#FFFFFF">
                                            <input type="radio" name="rdPrepaid" <%if  IsCollect ="N" then response.write("checked='checked'") %>
                                                value="0" onclick="PrePaidSelected();AmountChange(1000) ">
                                            Prepaid
                                            <input type="radio" name="rdCollect" <%if IsCollect ="Y" then response.write("checked='checked'") %>
                                                value="1" onclick="FCCollected();AmountChange(1000)">
                                            Collect</td>
                                    </tr>
                                    <tr>
                                        <td b>
                                        </td>
                                        <td height="20" colspan="7">
                                            <strong>Description of Packages and Goods</strong> ( Maximum of 230 characters or
                                            5 lines please)</td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="ffffff">
                                        </td>
                                        <td height="20" colspan="7" bgcolor="ffffff">
                                            <textarea name="txtDesc3" id="txtDesc3" cols="65" rows="5" class="multilinetextfield"
                                                onkeyup="textLimit(this,230);" maxline="5"><%= vDesc3 %></textarea></td>
                                    </tr>
                                    <tr bgcolor="efe1df">
                                        <td>
                                        </td>
                                        <td height="20" colspan="7">
                                            <strong>Remark </strong>(Maximum of 220 characters or 2 lines please)
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="ffffff">
                                        </td>
                                        <td height="20" colspan="7" bgcolor="ffffff">
                                            <textarea name="txtRemarks" id="txtRemarks" cols="160" rows="2" class="multilinetextfield"
                                                onkeyup="textLimit(this,220);"><%= vRemarks %></textarea></td>
                                    </tr>
                                </table>
                                <table id="tblChargeCost" width="90%" border="0" cellpadding="2" cellspacing="0"
                                    bordercolor="ba9590" class="border1px">
                                    <tr align="left" bgcolor="efe1df" class="bodycopy">
                                        <td valign="middle" bgcolor="efe1df">
                                            &nbsp;</td>
                                        <td height="20" valign="middle" class="bodyheader">
                                            A/R</td>
                                        <td valign="middle">
                                            &nbsp;</td>
                                        <td valign="middle">
                                            &nbsp;</td>
                                        <td width="133" valign="middle">
                                            &nbsp;</td>
                                        <td width="107" valign="middle">
                                            &nbsp;</td>
                                        <td valign="middle" bgcolor="efe1df">
                                            &nbsp;</td>
                                        <td valign="middle" bgcolor="efe1df">
                                            &nbsp;</td>
                                    </tr>
                                    <tr align="left" bgcolor="ffffff" class="bodycopy">
                                        <td valign="middle" bgcolor="ffffff">
                                            &nbsp;</td>
                                        <td height="20" valign="middle" bgcolor="ffffff">
                                            <strong>
                                                <select name="lstAR" size="1" class="smallselect" style="width: 180" 
                                                id="lstAR">
                                                    <% for j=0 to ARIndex-1 %>
                                                    <option value="<%= DefaultAR(j) %>" <% if DefaultAR(j)=AR then response.write("selected") %>>
                                                        <%= DefaultARName(j) %>
                                                    </option>
                                                    <% next %>
                                                </select>
                                                &nbsp;&nbsp;<input name="txtTerm" type="hidden" class="shorttextfield" value="<%= vTerm %>"
                                                    size="4"></strong></td>
                                        <td valign="middle" bgcolor="ffffff" colspan="6">
                                            &nbsp;</td>
                                    </tr>
                                    <tr align="left" bgcolor="efe1df" class="bodycopy">
                                        <td width="17" valign="middle" bgcolor="efe1df">
                                            &nbsp;</td>
                                        <td width="234" height="20" valign="middle">
                                            <strong>Charge Item</strong></td>
                                        <td width="170" valign="middle">
                                            <strong>Description</strong></td>
                                        <td width="93" valign="middle">
                                            <strong>Amount</strong></td>
                                        <td colspan="2" valign="middle">
                                            &nbsp;</td>
                                        <td width="162" valign="middle" bgcolor="efe1df">
                                            &nbsp;</td>
                                        <td width="83" valign="middle" bgcolor="efe1df">
                                            &nbsp;
                                            <input type="hidden" id="InvoiceItem">
                                            <input type="hidden" id="ItemDesc">
                                            <input type="hidden" id="ItemAmount">
                                            <input type="hidden" id="InvoiceCostItem">
                                            <input type="hidden" id="ItemCost">
                                            <input type="hidden" id="ItemCostDesc">
                                            <input type="hidden" id="ItemVendor">
                                        </td>
                                    </tr>

                                    <%dim valueCheck %>
                                    <% for i=0 to NoItem-1 %>
                                    <tr id='chargeItemRow<%=i%>' bgcolor="#FFFFFF">
                                        <td bgcolor="#FFFFFF" class="bodycopy">
                                            &nbsp;</td>
                                        <td bgcolor="#FFFFFF" class="bodycopy">
                                            <select name="lstItem<%= i %>" size="1" <% 'if flag  and i=0 then response.Write("") end if%>
                                                class="smallselect InvoiceItem" id="InvoiceItem" style="width: 180" onchange="ItemChange(<%= i %>);ItemCostChange2(<%= i %>)">
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
                                        <td bgcolor="#FFFFFF" class="bodycopy">
                                            <input name="txtChargeDesc<%= i %>" type="text" class="shorttextfield ItemDesc" id="ItemDesc"
                                                value="<%= aChargeDesc(i) %>" size="24"></td>
                                        <td bgcolor="#FFFFFF" class="bodycopy">
                                            <input name="txtAmount<%= i %>" type="text" class="numberalign ItemAmount" id="ItemAmount" onchange="AmountChange(<%= i%>)"
                                                value="<%= formatNumberPlus(CheckBlank(aAmount(i),0),2) %>" size="11" style="behavior: url(../include/igNumDotChkLeft.htc)" /></td>
                                        <td bgcolor="#FFFFFF" class="bodycopy">
                                            &nbsp;</td>
                                        <td bgcolor="#FFFFFF" class="bodycopy">
                                            &nbsp;</td>
                                        <td bgcolor="#FFFFFF" class="bodycopy">
                                            <img src='../images/button_delete.gif' width='50' height='17' onclick="if(!checkLocked()){DeleteItem(<%= i %>)}"
<% 
	if i=0 and tIndex=1 then  
		'response.write("disabled")		
	'elseif i=0 and flag ="true" then response.write("disabled")
	else 
	if UserRight<5 then response.write("disabled") 
	end if	
%> style="cursor: hand"></td>
                                        <td bgcolor="#FFFFFF">
                                            &nbsp;</td>
                                    </tr>
                                    <% Response.Flush() %>
                                    <% next %>
                                    <tr>
                                        <td bgcolor="#FFFFFF" class="bodycopy">
                                            &nbsp;
                                        </td>
                                        <td bgcolor="#FFFFFF" class="bodycopy">
                                            <img src='../images/button_addcharge_item.gif' width='109' height='18' name='bAddItem'
                                                onclick='if(!checkLocked()){AddItem()}' style="cursor: hand" <%
	 'if UserRight<5 Or Not Branch="" then response.write("disabled") %>>
                                        </td>
                                        <td bgcolor="#FFFFFF" class="bodycopy">
                                            &nbsp;
                                        </td>
                                        <td colspan="3" bgcolor="#FFFFFF" class="bodycopy">
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
                                        <td bgcolor="#FFFFFF" class="bodycopy">
                                            &nbsp;
                                        </td>
                                        <td bgcolor="#FFFFFF">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="1" colspan="8" align="left" valign="middle" bgcolor="ba9590">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="1" colspan="8" align="left" valign="middle" bgcolor="#FFFFFF">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="20" bgcolor="efe1df" class="bodycopy">
                                            &nbsp;</td>
                                        <td bgcolor="efe1df" class="bodycopy">
                                            <strong>Cost Item</strong></td>
                                        <td bgcolor="efe1df" class="bodycopy">
                                            <strong>Description</strong></td>
                                        <td bgcolor="efe1df" class="bodycopy">
                                            <strong>Cost</strong></td>
                                        <td bgcolor="efe1df" class="bodycopy">
                                            <strong>Vendor</strong></td>
                                        <td bgcolor="efe1df" class="bodycopy">
                                            <strong>Ref No.</strong></td>
                                        <td bgcolor="efe1df" class="bodycopy">
                                            &nbsp;</td>
                                        <td bgcolor="efe1df">
                                            &nbsp;</td>
                                    </tr>
                                    <% for i=0 to NoCostItem-1 %>
                                    <% if aAPLock(i) = "" or aAPLock(i) = "0" then%>
                                    <tr>
                                        <td bgcolor="#FFFFFF">
                                            <input name="txtAPLOCK<%= i %>" type="hidden" value="<%= aAPLock(i) %>"></td>
                                        <td bgcolor="#FFFFFF">
                                            <select name="lstCostItem<%= i %>" size="1" class="smallselect InvoiceCostItem" id="InvoiceCostItem"
                                                style="width: 180" onchange="ItemCostChange(<%= i%>); CostChange2(<%= i %>)">
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
                                                value="<%= aCostDesc(i) %>" size="24"></td>
                                        <td bgcolor="#FFFFFF">
                                            <input name="txtCost<%= i %>" type="text" class="numberalign1 ItemCost" id="ItemCost" onchange="CostChange(this)"
                                                value="<%= formatNumberPlus(CheckBlank(aRealCost(i),0),2) %>" size="12" style="behavior: url(../include/igNumDotChkLeft.htc)" /></td>
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
                                                size="14"></td>
                                        <td bgcolor="#FFFFFF">
                                            <img src='../images/button_delete.gif' width='50' height='17' onclick="DeleteCostItem(<%= i %>)"
                                                style="cursor: hand"></td>
                                        <td bgcolor="#FFFFFF">
                                            &nbsp;</td>
                                    </tr>
                                    <% else %>
                                    <tr>
                                        <td bgcolor="#FFFFFF">
                                            <input name="txtAPLOCK<%= i %>" type="hidden" value="<%= aAPLock(i) %>"></td>
                                        <td bgcolor="#FFFFFF">
                                            <select name="lstCostItem<%= i %>" size="1" class="smallselect InvoiceCostItem" id="InvoiceCostItem"
                                                style="width: 180" onchange="ItemCostChange(<%= i %>)">
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
                                                value="<%= aCostDesc(i) %>" size="24" readonly="true"></td>
                                        <td bgcolor="#FFFFFF">
                                            <input name="txtCost<%= i %>" type="text" class="numberalign ItemCost" id="ItemCost" onchange="CostChange(this)"
                                                value="<%= formatNumberPlus(aRealCost(i),2) %>" size="12" readonly="true" style="behavior: url(../include/igNumDotChkLeft.htc)" /></td>
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
                                                size="14" readonly="true"></td>
                                        <td colspan="2" bgcolor="#FFFFFF">
                                            <span class="goto"><a href="javascrip:;" onclick="goLink('<%=aAPLock(i)%>'); return false;">
                                                Invoice billed</a></span></td>
                                    </tr>
                                    <% end if %>
                                    <% Response.Flush() %>
                                    <% next %>
                                    <tr>
                                        <td bgcolor="#FFFFFF">
                                            &nbsp;</td>
                                        <td bgcolor="#FFFFFF">
                                            <img src='../images/button_addcost_item.gif' width='94' height='18' name='bAddItem2'
                                                onclick='if(!checkLocked()){AddCostItem()}' style="cursor: hand" <% 
	 'if UserRight<5 Or Not Branch="" then response.write("disabled") %>></td>
                                        <td bgcolor="#FFFFFF">
                                            &nbsp;</td>
                                        <td bgcolor="#FFFFFF">
                                            &nbsp;</td>
                                        <td bgcolor="#FFFFFF">
                                            &nbsp;</td>
                                        <td bgcolor="#FFFFFF">
                                            &nbsp;</td>
                                        <td bgcolor="#FFFFFF">
                                            &nbsp;</td>
                                        <td bgcolor="#FFFFFF">
                                            &nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td height="1" colspan="8" align="left" valign="middle" bgcolor="ba9590">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="1" colspan="8" align="left" valign="middle" bgcolor="#FFFFFF">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="1" colspan="8" align="left" valign="middle" bgcolor="ba9590">
                                        </td>
                                    </tr>
                                    <tr bgcolor="#F3f3f3">
                                        <td height="20">
                                            &nbsp;</td>
                                        <td>
                                            &nbsp;</td>
                                        <td align="right" valign="middle">
                                            <span class="style1"><strong>TOTAL</strong></span></td>
                                        <td>
                                            <input name="txtTotalAmount" type="text" class="numberalign" value="<%= formatNumberPlus( vTotalAmount,2) %>"
                                                size="12" style="behavior: url(../include/igNumDotChkLeft.htc)" 
                                                id="txtTotalAmount" />
                                        </td>
                                        <td>
                                            <input name="txtTotalCost" type="text" class="numberalign" value="<%= formatNumberPlus(vTotalCost,2) %>"
                                                size="12" style="behavior: url(../include/igNumDotChkLeft.htc)" 
                                                id="txtTotalCost"></td>
                                        <td>
                                            &nbsp;</td>
                                        <td>
                                            &nbsp;</td>
                                        <td>
                                            &nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td height="1" colspan="8" align="left" valign="middle" bgcolor="ba9590">
                                        </td>
                                    </tr>
                                    <tr align="center" valign="middle" bgcolor="edd3cf">
                                        <td height="22" colspan="8">
                                            &nbsp;</td>
                                    </tr>
                                </table>
                                <table width="90%" height="32">
                                    <tr>
                                        <td width="51%" align="right" valign="middle" class="bodyheader">
                                            <strong>Prepared by </strong>
                                        </td>
                                        <td width="16%" align="right" valign="middle" class="bodyheader">
                                            <input name="txtPreparedBy" type="text" class="shorttextfield" value="<%= vPreparedBy %>"
                                                size="30" id="txtPreparedBy"></td>
                                        <td width="16%" align="right" valign="middle" class="bodyheader">
                                            Sales Person</td>
                                        <td width="17%" align="right" valign="middle" class="bodyheader">
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
                            <tr bgcolor="edd3cf">
                                <td width="10%" height="22" align="center" valign="middle" bgcolor="edd3cf" class="bodyheader">
                                    <table width="98%" border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td width="26%">
                                            </td>
                                            <td width="48%" align="center">
                                                <img height="18" name="bSave" onclick="if(CheckIfANExist()==true){SaveClick('<%= TranNo %>','no') }"
                                                    src="../images/button_save_medium.gif" style="cursor: hand" width="46" alt="" />
                                                &nbsp;</td>
                                            <td width="13%" align="right">
                                                <img style="cursor: hand" src="/ASP/Images/button_new.gif" width="42" height="17"
                                                    onclick="AddHAWB()"></td>
                                            <td width="13%" align="right">
                                                <img style="cursor: hand; visibility: <%=vArApLock %>" src="/iff_main/Images/button_delete_medium.gif"
                                                    onclick="DeleteHAWB()"></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                    </table>
                    <input type="hidden" name="Flag" id="Flag" value="<%=flag%>" />
                    <input type="hidden" name="hDepText" id="hDepText" value="<%=vDepPort%>" />
                    <input type="hidden" name="hArrText" id="hArrText" value="<%=vArrPort%>" />
                    <input type="hidden" name="hAirline" id="hAirline" value="<%=vAirline%>" />
                    <input type="hidden" name="test" id="test" />
                </form>
            </td>
        </tr>
    </table>
    <table width="95%" height="30" border="0" align="center" cellpadding="2" cellspacing="0">
        <tr>
            <td colspan="4" width="41%" height="32" align="right" valign="bottom">
                <div id="print">
                    <div id="div2">
                        <img src="/ASP/Images/icon_printer.gif" align="absbottom"><a href="javascript:;"
                            onclick="if(CheckIfANExist()==true){SaveClick('<%= TranNo %>','yes')};return false;">Arrival
                            Notice</a><img src="/ASP/Images/button_devider.gif"><a href="javascript:;"
                                onclick="if(CheckIfANExist()==true){SaveClick2('<%= TranNo %>','yes')};return false;">Arrival
                                Notice & Freight Invoice</a><img src="/ASP/Images/button_devider.gif"><a
                                    href="javascript:;" onclick="SaveClick3('<%= TranNo %>');return false;">Authority
                                    to Make Entry</a></div>
                </div>
            </td>
        </tr>
    </table>
    <br />
</body>
<script type="text/javascript">
var dPortCode ="";
var aPortCode ="";
var PortCode = "";
function doDepPortChange(obj) {
    dPortCode = obj.children[obj.options.selectedIndex].text;
    document.form1.hDepText.value = dPortCode;
}
function doArrPortChange(obj){
    aPortCode = obj.children[obj.options.selectedIndex].text;
    document.form1.hArrText.value = aPortCode;
}
function lstMAWBChange_air(mawb)   {
    var tmpInfo = get_arrival_mawb_info(mawb, "A");
    //alert(tmpInfo);
	var obj = eval("(" + tmpInfo + ")"); 
    //var aVal=tmpInfo.split("^");
	
	document.getElementById("txtRefNo").value = obj[0].file_no;
	document.getElementById("txtVessel").value = obj[0].flt_no;
	
	document.getElementById("txtCargoLocation").value = obj[0].cargo_location;
	document.getElementById("txtETD").value = obj[0].etd;
	document.getElementById("txtETA").value = obj[0].eta;

	document.getElementById("hDepText").value = obj[0].dep_port;
	document.getElementById("hArrText").value = obj[0].arr_port;

	document.getElementById("hAgentOrgAcct").value = obj[0].agent_org_acct;
	document.getElementById("hSec").value = obj[0].sec;

	var it_entry_port = obj[0].it_entry_port.replace("Select One", "");
	document.getElementsByName("txtITEntryPort").value = it_entry_port;
	document.getElementById("txtITNumber").value = obj[0].it_number;
	document.getElementById("txtITDate").value = obj[0].it_date;
	document.getElementById("txtFreeDate").value = obj[0].last_free_date;
	document.getElementsByName("hAirline").value = obj[0].carrier_code;
	//carrier_code
	setSelect("lstDepPort", obj[0].dep_code);
	setSelect("lstArrPort", obj[0].arr_code);
}

var ConsigneeExist="<%= ConsigneeExist %>";
if (ConsigneeExist=="N"){
	if (confirm("The CONSIGNEE doesn't exist. Would you like to create it? \r\nYes?")){	
	    createOrgProfile("<%= vHAWB %>");
	    window.close;
	}
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

    var Pieces = document.form1.txtPCS.value;
    var Desc = document.form1.txtDesc3.value;
    var GrossWT = document.form1.txtGrossWT.value;
    var ChgWT = document.form1.txtChgWT.value;
    var AFTotal = document.form1.txtTotalFC.value;
    
    if (  self.opener !=null && ! self.opener.closed ){
	    self.opener.document.all("HAWBShipper").item(ItemNo).value=Shipper;
	    self.opener.document.all("HAWBConsignee").item(ItemNo).value=Consignee;
	    self.opener.document.all("HAWBNotify").item(ItemNo).value=Notify;
	    self.opener.document.all("HAWBPieces").item(ItemNo).value=Pieces;
	    self.opener.document.all("HAWBDesc").item(ItemNo).value=Desc;
	    self.opener.document.all("HAWBGrossWT").item(ItemNo).value=GrossWT;
	    self.opener.document.all("HAWBChgWT").item(ItemNo).value=ChgWT;
	    self.opener.document.all("HAWBFreightCollect").item(ItemNo).value=AFTotal;
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

function SaveClick(tNo, pOK){

   var PrintOK = "<%=PrintOK %>";
   if(pOK)PrintOK =pOK;
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
    var MAWB="<%=vMAWB%>";

    var vSec="1";
    var iType="A";      
    
    if (document.form1.hConsigneeAcct.value == "" || document.form1.hConsigneeAcct.value == "0" ){
        alert( "Please select a Consignee!");
        return false;
    }
    MAWB=document.form1.txtMAWB.value;
    var HAWB=document.form1.txtHAWB.value;
    if (MAWB=="" ){
        alert( "Please select a Master Airway Bill!");
        return false;
    }
    var PickupDate=document.form1.txtPickupDate.value;
    if (PickupDate!="" ){
        if (!IsDate(PickupDate) ){
            alert( "Please enter a correct Date for Pickup (MM/DD/YYYY)");
            return false;
        }
    }

    var NoItem=document.form1.hNoItem.value;
    var NoCostItem=document.form1.hNoCostItem.value;
    
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

    document.getElementById("hDoInvoice").value = "no";
    iType = "A";
    document.form1.action = encodeURI("arrival_notice.asp?iType=A" + "&tNo=<%=TranNo %>&doInvoice=no&Save=yes&Print=" + PrintOK + "&WindowName=" + window.name);
    document.form1.method = "POST";
    document.form1.target = "_self";

    form1.submit();
}

function SaveClick2(TranNo,PrintOK){

    var lock="<%=vArApLock %>";
    if (PrintOK == "yes") {
	    PrintClick2("yes");
	    return false;
	}
    if (document.form1.hConsigneeAcct.value == "" || document.form1.hConsigneeAcct.value == "0") {
       alert("Please select a Consignee!");
	        return false;
	    }
    var MAWB=document.form1.txtMAWB.value;
    var HAWB=document.form1.txtHAWB.value;
    if (MAWB == "") {
        return false;
	}
    var PickupDate=document.form1.txtPickupDate.value;
    if (PickupDate != "") {
        if (!IsDate(PickupDate)) {
	            alert("Please enter a correct Date for Pickup (MM/DD/YYYY)");
	            return false;
	    }
	}

//    ITNo=document.form1.txtITNumber.Value
//    if Not ITNo="" and Not IsNumeric(ITNo) then
//	    MsgBox "Please enter a numeric value for IT Number"
//	    Exit Sub
//    end if
    var NoItem = document.form1.hNoItem.value;
	var NoCostItem = document.form1.hNoCostItem.value;
    //'---------------------------------------------------------------------------------------------------
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

	var iType = "A";
	document.getElementById("hDoInvoice").value = "yes";
	document.form1.action = encodeURI("arrival_notice.asp?iType=A" + "&tNo=<%=TranNo %>&doInvoice=yes&Save=yes&Print=" + PrintOK + "&WindowName=" + window.name);
	document.form1.method = "POST";
	document.form1.target = "_self";
	form1.submit();
console.log(document.form1.action );
	
}


function SaveClick3(TranNo) {

    var lock = "<%=vArApLock %>";
    if (lock != "Visible" )
        AuthClick();

    var MAWB="<%=vMAWB%>";
    var vSec="1";
    var iType="A"    ;        
    
    if( document.form1.hConsigneeAcct.value == ""|| document.form1.hConsigneeAcct.value == "0" ){
        alert( "Please select a Consignee!");
        return false;
    }
    MAWB = document.form1.txtMAWB.value;
	var HAWB = document.form1.txtHAWB.value;
    if (MAWB == "") {
	        alert("Please select a Master Airway Bill!");
	        return false;
	}
    var PickupDate = document.form1.txtPickupDate.value;
	if (PickupDate != "") {
	    if (!IsDate(PickupDate)) {
	        alert("Please enter a correct Date for Pickup (MM/DD/YYYY)");
	        return false;
	    }
	}

    var NoItem = document.form1.hNoItem.value;
	var NoCostItem = document.form1.hNoCostItem.value;

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
    document.getElementById("hDoInvoice").value="no";
    iType="A";
    document.form1.action=encodeURI("arrival_notice.asp?iType=A"+ "&tNo=<%=TranNo %>&doInvoice=no&Save=yes&Auth=yes&WindowName="+ window.name);
    document.form1.method="POST";
    document.form1.target="_self";
    form1.submit();

	  
}

</script>
<script type="text/vbscript">



Sub ConfirmVB(msg)  'never used
    Dim ans
    ans = eltConfirm(msg)
End Sub 





</script>
<script type="text/javascript">

function AddCostItem() {
    var iType = "A";
    document.form1.hNoCostItem.value = parseInt(document.form1.hNoCostItem.value) + 1;
    document.form1.action = encodeURI("arrival_notice.asp?iType=A" + "&tNo=" + "<%=TranNo%>" + "&AddCostItem=yes" + "&WindowName=" + window.name);
    document.form1.method = "POST";
    document.form1.target = "_self";
    form1.submit();
}


function DeleteCostItem(rNo){
    var iType="A";
    if (confirm("Are you sure you want to delete this item? \r\nContinue?")){
        document.form1.action = encodeURI("arrival_notice.asp?iType=A" + "&tNo=" + "<%=TranNo%>" + "&DeleteCost=yes&rNo=" + rNo + "&WindowName=" + window.name);
	    document.form1.method = "POST";
	    document.form1.target = "_self";
	    form1.submit();
	}
}

function AddItem() {
    var iType = "A";
    var NoItem = parseInt(document.form1.hNoItem.value);
    document.form1.hNoItem.value = NoItem + 1;
    document.form1.action = encodeURI("arrival_notice.asp?iType=A" + "&tNo=" + "<%=TranNo%>" + "&AddItem=yes" + "&WindowName=" + window.name);
    document.form1.method = "POST";
    document.form1.target = "_self";
    form1.submit();
}

function DeleteItem(rNo){
    var iType="A";
    if (confirm("Are you sure you want to delete this item? \r\nContinue?")){
	    document.form1.action=encodeURI("arrival_notice.asp?iType=A"+ "&tNo=" + "<%=TranNo%>" + "&Delete=yes&rNo=" + rNo+ "&WindowName=" + window.name)
	    document.form1.method = "POST";
	    document.form1.target = "_self";
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
    //	'msgbox itemInfo
	    pos=itemInfo.indexOf("\n");
	    if( pos>=0 ){
		    Desc=itemInfo.substring(pos+1,100);
		
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
function CostChange2(ItemNo){
	var tCost=$("input.ItemCost").get(ItemNo).value;
	if ( tCost!="" ){
	    if (!IsNumeric(tCost)){
		    alert( "Please enter a numeric number!");
		    $("input.ItemCost").get(ItemNo).value=0;
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
    document.form1.txtTotalCost.value=parseFloat(TotalCost).toFixed(2);
}
function ItemCostChange2(ItemNo){
	var tCost=$("input.ItemAmount").get(ItemNo).value;
	if ( tCost!="" ){
		if (!IsNumeric(tCost)){
		    alert( "Please enter a numeric number!");
			$("input.ItemAmount").get(ItemNo).value=0;
			return false;
	    }
	}
	var NoItem=parseInt(document.form1.hNoCostItem.value);
	var TotalCost=0;
	for (var j=0 ; j< NoItem; j++){
	    var Cost = $("input.ItemAmount").get(j).value;
		if (Cost == "")
		    Cost = 0;
		else
		    Cost = parseFloat(Cost);

		TotalCost = TotalCost + Cost;
	}
	document.form1.txtTotalAmount.value=parseFloat(TotalCost).toFixed(2);
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

function SET_UNIT_PRICE( obj, val ){
    obj.value = parseFloat(val).toFixed(2); 
}

function CostChange(obj){
    var tCost = obj.value;

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
    var iType="A";
    var InvoiceNo=document.getElementById(txtBox).value;
    if (InvoiceNo == "" || !IsNumeric(InvoiceNo)) {
        alert("Please enter a numeric value!");
        return false;
    }
    document.form1.action = encodeURI("arrival_notice.asp?iType=" + iType + "&tNo=" + "<%=TranNo%>" + "&Search=yes&InvoiceNo=" + InvoiceNo + "&WindowName=" + window.name);
    document.form1.method = "POST";
    document.form1.target = "_self";
    form1.submit();
}


function PrintClick(){
    var iType = "A";
    var Sec = document.form1.hSec.value;
    var HAWB = document.form1.txtHAWB.value;
    var MAWB = document.form1.txtMAWB.value;
    var AgentOrgAcct = document.form1.hAgentOrgAcct.value;
    document.form1.action = encodeURI("arrival_notice_pdf.asp?iType=" + iType + "&HAWB=" + HAWB + "&MAWB=" + MAWB + "&Sec=" + Sec + "&AgentOrgAcct=" + AgentOrgAcct + "&invoice_no=<%=InvoiceNo%>" + "&doInvoice=<%=doInvoice %>");
    document.form1.method = "POST";
    document.form1.target = "_self";

    form1.submit();
}
function PrintClick2(doInvoice) {
//alert(doInvoice);
    /////////////////////////////////////////////////
    var iType = "A";
    var Sec = document.form1.hSec.value;
    var HAWB = document.form1.txtHAWB.value;
    var MAWB = document.form1.txtMAWB.value;



    var AgentOrgAcct = document.form1.hAgentOrgAcct.value;

    document.form1.action = encodeURI("arrival_notice_pdf.asp?iType=" + iType + "&HAWB=" + HAWB + "&MAWB=" + MAWB + "&Sec=" + Sec + "&AgentOrgAcct=" + AgentOrgAcct + "&invoice_no=<%=InvoiceNo%>" + "&doInvoice=" + doInvoice);
    document.form1.method = "POST";
    document.form1.target = "_self";
    form1.submit();
}
/////////////////////////////////////////////////
function AuthClick() {
    /////////////////////////////////////////////////
    var iType = "A";
    var Sec = document.form1.hSec.value;
    var HAWB = document.form1.txtHAWB.value;
    var AgentOrgAcct = document.form1.hAgentOrgAcct.value;

    document.form1.action = encodeURI("AuthorityMakeEntry_pdf.asp?iType=" + iType + "&HAWB=" + HAWB + "&invoice_no=<%=InvoiceNo%>"+ "&Sec=" + Sec + "&AgentOrgAcct="+AgentOrgAcct + "&WindowName=" +window.name);
    document.form1.target = "_self";
    document.form1.method = "POST";
    form1.submit();
}
</script>
<script type="text/vbscript">


/////////////////////////////////////////////////
Sub MenuMouseOver()
/////////////////////////////////////////////////
document.form1.lstAR.style.visibility="hidden"
End Sub

/////////////////////////////////////////////////
Sub MenuMouseOut()
/////////////////////////////////////////////////
document.form1.lstAR.style.visibility="visible"
End Sub



</script>

<script type="text/javascript">

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

function DeleteHAWB(){
    var InvoiceNo, HAWB, MAWB;
    InvoiceNo="<%=InvoiceNo%>";
    HAWB="<%=vHAWB %>";
    MAWB="<%=vMAWB %>";

	if (confirm("Are you sure you want to delete this Arrival Notice? \r\nContinue?")) {   
		document.form1.action=encodeURI("arrival_notice.asp?DeleteHAWB=yes&iType=A&MAWB="+ MAWB + "&HAWB=" + HAWB +"&InvoiceNo=" + InvoiceNo);
		document.form1.target="_self";
		document.form1.method="POST";
		form1.submit();
	}
}

function AddHAWB(){
    var MAWB, AgentOrgAcct;
    HAWB="<%=vHAWB %>";
    MAWB="<%=vMAWB %>";
    AgentOrgAcct="<%=vAgentOrgAcct %>";
    
	document.form1.action=encodeURI("arrival_notice.asp?iType=A&NewHAWB=yes&Sec=1&MAWB="+ MAWB+"&AgentOrgAcct=" + AgentOrgAcct);
	document.form1.target="_self";
	document.form1.method="POST";
	form1.submit();
}


var dep;	
var arp;
var Unit;
var airline;
var cusAcc;
var wgt;

var IsprocessReqChanged=false;

function eltConfirm(msg)
{
    var answer;   
    
    answer = window.showModalDialog('save_confirm.asp',msg,'dialogHeight:160px;dialogWidth:340px;status:0;');
    
    return answer;
}

function alertAll()
{
	alert("from alert all:"+ dep+"--"+ arp+"--"+ Unit+"--"+ airline+"--"+ cusAcc + "--"+ wgt);	
}

function LoadNew(){

   var HAWB="<%=vHAWB %>";
   var MAWB="<%=vMAWB %>";
   var AgentOrgAcct="<%=vAgentOrgAcct %>";
    
	document.form1.action=encodeURI("arrival_notice.asp?iType=A&NewHAWB=yes&Sec=1&MAWB="+MAWB+"&AgentOrgAcct=<%=AgentOrgAcct %>");
	document.form1.target="_self";
	document.form1.method="POST";
	form1.submit();
	
}

//Added by Stanley on 10/22/2007
function checkDecimalTextMax(obj,limit)
    {
        if(obj.value.length >= limit){
            var temp = obj.value;
            var tempArray = new Array();
            tempArray = temp.split(".");
            temp = tempArray[0];
            if(temp.length >= limit){
                obj.value = temp.substring(0,limit);
            }
            else{
                obj.value = parseFloat(obj.value).toFixed(2);
            }
            return false;
        }
        else
        {
            return true;
        }
    }

function scaleChange(obj)
{
   if(obj.value=='K'){
         var tmpGross=parseFloat(document.getElementById('txtGrossWT').value)/2.20462262 
		 var tmpChargeable=parseFloat(document.getElementById('txtChgWT').value)/2.20462262 
		 
   		document.getElementById('txtGrossWT').value=Math.round(tmpGross*1000)/1000
		document.getElementById('txtChgWT').value=Math.round(tmpChargeable*1000)/1000
		
   }else{
        var tmpGross=parseFloat(document.getElementById('txtGrossWT').value)*2.20462262 
		var tmpChargeable=parseFloat(document.getElementById('txtChgWT').value)*2.20462262 
		
   		document.getElementById('txtGrossWT').value=Math.round(tmpGross*1000)/1000
		document.getElementById('txtChgWT').value=Math.round(tmpChargeable*1000)/1000
   }
   getCustomerSellingRate();
  
}

    function catchRatingInfo(){
        dep=document.getElementById("lstDepPort").value;
        arp=document.getElementById("lstArrPort").value;	
	    Unit=document.getElementById("lstScale1").value;
        airline=document.getElementById("hAirline").value;
    	
	    tmpStr = document.getElementById("lstConsigneeName").value;	 
        cusAcc = document.getElementById("hConsigneeAcct").value;	 
        elt_account_number = "<%=elt_account_number%>";
        wgt = document.form1.txtChgWT.value;   
    }

    function getCustomerSellingRate(){  
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


		if (req) {	
			catchRatingInfo();
			
			req.onreadystatechange = processReqChange(req);		
			req.open("GET",encodeURI("/ASP/ajaxFunctions/ajax_cus_rate.asp?cusAcc=" + cusAcc + "&Unit=" + Unit+ "&airline=" + airline + "&arp=" + arp + "&dep=" + dep + "&wgt=" + wgt), true);		
			req.send();		
		}
    }

function calculateTotalFc(){  

	var chargeable=document.getElementById("txtChgWT").value;
	var CSRate=document.getElementById("txtCSRate").value;
	var TotalFC=document.getElementById("txtTotalFC").value;	
	
	if(CSRate!=0){
	    try{
			CSRate=parseFloat(CSRate);
		}catch(e){}
	} 	
	if((CSRate*0)!=0){	
	  alert("Please Enter a number for rate");
	  document.getElementById("txtCSRate").value="0";
	  document.getElementById("txtTotalFC").value="0";
	  document.getElementById("txtCSRate").focus();
	  return;
	}	
	
	chargeable=parseFloat(chargeable);
					
	if((chargeable*0)!=0){
	  alert("Please Enter a number for Chargeable Weight");
	  document.getElementById("txtChgWT").value="0";
	  document.getElementById("txtTotalFC").value="0";
	  document.getElementById("txtChgWT").focus();
	 return;
	}	
	var tVal=chargeable * CSRate;
	tVal=Math.round(tVal*1000)/1000;
	document.getElementById("txtTotalFC").value=tVal.toFixed(2);
	document.getElementById("txtTotalFC").focus();	
}


function processReqChange(req){

	if (req.readyState == 4) {	
		
		if (req.status == 200) {	
					
			var result = req.responseText;
			//document.getElementById("txtBrokerInfo").value=result;
		    var numericVar=parseFloat(result);
		    
		    if(numericVar < 0 ){
		        if(confirm("Minimum charge will be applied.\n Would you like to proceed?")){
		            var tVal=numericVar*-1;
	                tVal=Math.round(tVal*100)/100;
	                document.getElementById("txtTotalFC").value=tVal.toFixed(2);
    	                      
		            document.getElementById("txtCSRate").value="0";
		            CSRate=parseFloat("0");
		        }
		        return;
		    }
			
		    document.getElementById("txtCSRate").focus();	
			CSRate=parseFloat(result);	
			if( document.getElementById("txtCSRate").value!=0){
			    document.getElementById("txtCSRate").value=CSRate;
				 calculateTotalFc();
			}
			document.getElementById("txtCSRate").value=CSRate;
			
			
			
			 
			
		} else {
			
			document.getElementById("txtCSRate").focus();
			CSRate=parseFloat("0");
			document.getElementById("txtCSRate").value=CSRate;
		}
		
	}

}
function checkLocked(){
    //return false;
    var lock= "<%=vArApLock %>";
    if(lock=="Hidden"){
        return true;
    }else{
        return false;
    }
}

function CheckIfANExist(){ 


     var HAWB=document.form1.txtHAWB.value;
     var MAWB=document.form1.txtMAWB.value;
      if(MAWB==""){
      alert("Please Select a Master Airway Bill Number2");
     }
     var OriginalHAWB='<%=Session("hawb")%>'
     var OriginalMAWB='<%=Session("mawb")%>'
     
     //alert("old HAWB:"+OriginalHAWB+"old MAWB:"+OriginalMAWB)     
   //  alert(" HAWB:"+HAWB+"MAWB:"+MAWB)
     
     var HAWB_MAWB_NOT_CHANGED=(HAWB==OriginalHAWB&&MAWB==OriginalMAWB)
    //alert(HAWB_MAWB_NOT_CHANGED);
     var vSec="1";	 
     var iType="A";	 
     var CurrentInvoice=document.form1.hInvoiceNo.value; 
    
     // added by joon on 4-30-2007
     if(CurrentInvoice == 0) {CurrentInvoice = "";}
     
	 if(CurrentInvoice!="" && HAWB_MAWB_NOT_CHANGED){
	    document.form1.hSavingCondition.value="OVER_WRITE"

	    return true
	 }
	 
	 if(CurrentInvoice=="" || !HAWB_MAWB_NOT_CHANGED)
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
            req.open("get",encodeURI("/ASP/ajaxFunctions/ajax_CheckIfANExist.asp?MAWB="+MAWB+"&HAWB="+HAWB+"&Sec="+vSec+"&iType="+iType+"&elt_account_number="+"<%=elt_account_number%>") ,false);
	        req.send(); 
	        var result =req.responseText.split("-");
	        		        
	        var exist=result[0];
	        var IV=result[1];

	        if(exist=="False"){
	           if(CurrentInvoice!=""){	           
	             var aFirm=eltMsgBox("The invoice for the MAWB&HAWB has been changed."
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
	                    document.form1.hSavingCondition.value="CREATE_NEW" ; 
	                    return true;
	                }else{
	                return false;
	                }
	          }	               
	        }
	        
	        else {    
	       
            // editt case by Joon 
	        //    if(CurrentInvoice==""){
	        //        document.form1.hSavingCondition.value="OVER_WRITE_WITH_NEW_INVOICE" ; 
	        //            return true;
	        //    }
	                    				  
                var aFirm=confirm("The invoice for the MAWB&HAWB combination already exists in the database."
                    + "\n Would you like to reload with the previous invoice?");			                      //alert('a');
                  
                if(aFirm){    

                    document.form1.action=encodeURI("arrival_notice.asp?iType=A&tNo=" + "<%=TranNo%>")
                    + "&Edit=yes&MAWB="+MAWB+
                    "&HAWB="+HAWB+
                    "&Sec="+vSec+
                    "&WindowName="+ window.name;	
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

function pause(millis) 
{
    date = new Date();
    var curDate = null;
    do { 
        curDate = new Date(); 
    } while(curDate-date < millis);
}



</script>

<script type="text/javascript">
function GetHAWBList(arg)
{
    var HAWB=document.getElementById('txtFindByHAWB').value
    var MAWB=document.getElementById('txtFindByMAWB').value
	var returnValue
	if(arg == "HAWB")
	{
	    if(HAWB != "" && HAWB != "House No. Here" )
	       {
	        returnValue = window.showModalDialog(encodeURI('../include/showHAWBs.asp?AE=A&HAWB='+HAWB),'','dialogHeight:200px;dialogWidth:400px;center:yes');
            }
            else
            {
                alert("Please enter a House No");
            }
    }
        
    else
    {
       if(HAWB != "" && HAWB != "Master No. Here" )
       {
            returnValue = window.showModalDialog(encodeURI('../include/showHAWBs.asp?AE=A&MAWB='+MAWB),'','dialogHeight:200px;dialogWidth:400px;center:yes');
       }
       else
       {
            alert("Please enter a Master No");
       }
     }   

        
    try{
        if(returnValue){
	        window.location.href=encodeURI("./arrival_notice.asp?iType=A&Edit=yes&" + returnValue);
	    }
	
	}catch(E){
	}
}
</script>

<% 
if PrintOK = "yes" then
	response.write "<script language='javascript'>PrintClick();</script>"
	response.end
end if

if vAuth = "yes" then
	response.write "<script language='javascript'>AuthClick();</script>"
end if

response.Write("<script language='javascript'>window.focus();</script>")

%>

<script language="JavaScript" type="text/javascript" src="../include/tooltips.js"></script>

<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>