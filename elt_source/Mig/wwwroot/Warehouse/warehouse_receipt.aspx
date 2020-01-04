<%@ Page Language="C#" AutoEventWireup="true" CodeFile="warehouse_receipt.aspx.cs"
    Inherits="warehouse_receipt" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>WAREHOUSE RECEIPT</title>
    <meta http-equiv="Content-Language" content="en-us" />
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <link href="/Warehouse/css/elt_css.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="/Warehouse/ajaxFunctions/ajax.js"></script>
    <script type="text/javascript" src="/Warehouse/include/JPED.js"></script>

    <script type="text/javascript">

        function fixProgressBar()
        {
	        if(parent.frames['dummyFrame'])
	        {
		        parent.frames['dummyFrame'].document.write("");
		        parent.frames['dummyFrame'].document.close();
	        }    
        }

        function saveScrollPosition() {
		        if (document.all.scrollPositionX) {
			        document.all.scrollPositionX.value = window.document.body.scrollLeft;
		        }
		        if (document.all.scrollPositionY) {
			        document.all.scrollPositionY.value = window.document.body.scrollTop;
		        }
        }

        function jPopUpNormal(){
            var argS = 'menubar=1,toolbar=1,height=600,width=900,hotkeys=0,scrollbars=1,resizable=1';
            popUpWindow = window.open('','popUpWindow', argS);
         }

        function jPopUpPDF(){
            var argS = 'menubar=1,toolbar=1,height=600,width=900,hotkeys=0,scrollbars=1,resizable=1';
            popUpPDF = window.open('','popUpPDF', argS);
            return popUpPDF;
        }

        
        var oInterval = ""; 
        var weights = new Array();
        var measures = new Array();

        weights[0] = "";
        measures[0] = "";
        		
        function convertKG_LB(arg)
        {
	        var scale;
	        var index;
	        var weight;
	        index = document.getElementsByName("lstWeightScale")[arg].selectedIndex;
	        scale = document.getElementsByName("lstWeightScale")[arg].options[index].value;
        	
	        if(weights[arg]=="")
	        {
	            weights[arg] = document.getElementsByName("txtGrossWeight")[arg].value;
	        }
	        if(scale == "LB")
	        {
	            weights[arg] = weights[arg] * 2.2046226218488;
	        }
	        if(scale == "KG")
	        {
	            weights[arg] = weights[arg] / 2.2046226218488;
	        }
	        document.getElementsByName("txtGrossWeight")[arg].value=weights[arg].toFixed(2);
        }

        function resetWeight(arg)
        {
            weights[arg] = "";
        }

        function convertCBM_CFT(arg)
        {
	        var scale;
	        var index;
	        var measure;
	        var measure_accurate;
	        index = document.getElementsByName("lstMeasurementScale")[arg].selectedIndex;
	        scale = document.getElementsByName("lstMeasurementScale")[arg].options[index].value;
	        measure = document.getElementsByName("txtMeasurement")[arg].value;
        	
	        if(scale == "CBM")
	        {
	            measure = measure / 35.314666721489;
	        }
	        if(scale == "CFT")
	        {
	            measure = measure * 35.314666721489;
	        }
	        document.getElementsByName("txtMeasurement")[arg].value=measure.toFixed(2);
        	
        }

        function resetMeasure(arg)
        {
            measures[arg] = "";
        }

        function checkNum() {
	        if((event.keyCode<48||event.keyCode>57)&&event.keyCode!=46)
	        {
		        event.returnValue=false;
	        }
        }

        function docModified(arg) {

            var isDocBeingModified = document.getElementById("isDocBeingModified");
            isDocBeingModified.value = parseInt(isDocBeingModified.value) + parseInt(arg);
        }
        
        function navigateAway() {

            var isDocBeingSubmitted = document.getElementById("isDocBeingSubmitted");
            var isDocBeingModified = document.getElementById("isDocBeingModified");
            
            msg = "----------------------------------------------------------\n";
            msg += "The form has not been saved.\n";
            msg += "All changes you have made will be lost\n";
            msg += "----------------------------------------------------------";

            
            
            if (isDocBeingSubmitted.value == "false" && isDocBeingModified.value > 0) 
            {
                event.returnValue = msg;
                // oInterval = window.setInterval("topSyncLater()",500);
            }
        }
        
        function chInlandChargeType_click(arg){
            var inlandType = document.getElementById("hInlandChargeType");
            if(arg=="C"){
                document.getElementsByName("chInlandChargeType")[0].checked = false;
                document.getElementsByName("chInlandChargeType")[1].checked = true;
            }
            else
            {
                document.getElementsByName("chInlandChargeType")[0].checked = true;
                document.getElementsByName("chInlandChargeType")[1].checked = false;
            }
            inlandType.value = arg;
        }
        
        function displayScreen(req,field,tmpVal,tWidth,tMaxLength,url)
        {
            if (req.readyState == 4)
            {   
		        if (req.status == 200)
		        {
		            try{
		                var xmlObj = req.responseXML;
		                
                        if(xmlObj.getElementsByTagName("auto_uid")[0] != null 
                            && xmlObj.getElementsByTagName("auto_uid")[0].childNodes[0] != null)
                        {
                            setField("Search_Num","txtPickupNumber",xmlObj);
                            setField("pickup_ref_num","txtPickupRefNum",xmlObj);
                            
                            // party initialize

                            setField("contact","txtContact",xmlObj);
                            setField("ModifiedDate","txtUpdateDate",xmlObj);
                            
                            setField("MAWB_NUM","txtMAWB",xmlObj);
                            setField("HAWB_NUM","txtHAWB",xmlObj);
                            setField("sub_hawb_no","txtSubHAWB",xmlObj);
                            
                            setField("entry_billing_no","txtEntryBilling",xmlObj);
                            setField("customer_ref_no","txtCustomerRef",xmlObj);
                            setField("ETA_DATE2","txtArrDate",xmlObj);
                            if(document.getElementById("txtArrDate").value == ""){
                                setField("ETA_DATE1","txtArrDate",xmlObj);
                            }
                            setField("ETD_DATE1","txtDepDate",xmlObj);
                            if(document.getElementById("txtDepDate").value == ""){
                                setField("ETD_DATE2","txtDepDate",xmlObj);
                            }
                            setField("free_date","txtFreeDate",xmlObj);
                            
                            setSelectField("Origin_Port_Location","lstDepPort",xmlObj,3);
                            setSelectField("Dest_Port_Location","lstArrPort",xmlObj,3);
                            setField("Origin_Port_Code","hDepPortCode",xmlObj);
                            setField("Dest_Port_Code","hArrPortCode",xmlObj);
                            
                            setField("trucker_name","lstTruckerName",xmlObj);
                            setField("trucker_acct","hTruckerAcct",xmlObj);
                            setField("trucker_info","txtTruckerInfo",xmlObj);
                            
                            setField("attention","txtAttention",xmlObj);
                            setField("route","txtRoute",xmlObj);
                            setField("Handling_Info","txtHandling",xmlObj);
                            setField("Total_Pieces","txtPieces",xmlObj);
                            setField("Desc2","txtDesc3",xmlObj);
                            setSelectField("Weight_Scale","lstScale1",xmlObj,1);
                            if(document.getElementById("lstScale1").selectedIndex == -1){
                                setSelectField("Weight_Scale_X","lstScale1",xmlObj,1);
                            }
                            setField("Total_Gross_Weight","txtGrossWt",xmlObj);
                            setField("inland_charge","txtInlandCharge",xmlObj);
                            setField("inland_charge_type","hInlandChargeType",xmlObj);
                            
                            // setSelectField("dimension_scale","lstDimScale",xmlObj,3);
                            setField("dimension","txtDimension",xmlObj);
                            
                            if(document.getElementById("hInlandChargeType").value == "P"){
                                document.getElementsByName("chInlandChargeType")[0].checked = true;
                            }
                            else if(document.getElementById("hInlandChargeType").value == "C"){
                                document.getElementsByName("chInlandChargeType")[1].checked = true;
                            }
                            else{
                                document.getElementsByName("chInlandChargeType")[0].checked = false;
                                document.getElementsByName("chInlandChargeType")[1].checked = false;
                            }
                            setField("employee","txtEmployee",xmlObj); 

                            // default values
					        if(document.getElementById("txtEmployee").value == ""){
						        document.getElementById("txtEmployee").value = "Joon Park";
					        }
					        if(document.getElementById("txtUpdateDate").value == ""){
						        document.getElementById("txtUpdateDate").value = "6/6/2007";
					        }
					        if(document.getElementById("lstScale1").options.selectedIndex < 0){
                                document.getElementById("lstScale1").options[0].selected = true;
                            }
        					
                            // number format
					        formatDouble("txtInlandCharge");
					        formatDouble("txtGrossWt");
                        }
                    }catch(error)
                    {
                        alert(error.description);
                        xmlObj = null;
                    }
                    xmlObj = null;
		        }
		    }
		}
		
		function setCheck(xmlTag,htmlTag,xmlObj)
		{
		    var htmlObj = document.getElementsByName(htmlTag);
		    
		    if(xmlObj.getElementsByTagName(xmlTag)[0] != null && xmlObj.getElementsByTagName(xmlTag)[0].childNodes[0] != null)
            {
                var selValue = xmlObj.getElementsByTagName(xmlTag)[0].childNodes[0].nodeValue;

                for(var i=0;i<htmlObj.length;i++)
                {
                    if(htmlObj[i].value == selValue)
                    {
                        htmlObj[i].checked = true;
                    }
                    else
                    {
                        htmlObj[i].checked = false;
                    }
                }
            }
            else
            {
                for(var i=0;i<htmlObj.length;i++)
                {
                    htmlObj[i].checked = false;
                }
            }
		}
		
		function setField(xmlTag,htmlTag,xmlObj)
        {
            if(xmlObj.getElementsByTagName(xmlTag)[0] != null && xmlObj.getElementsByTagName(xmlTag)[0].childNodes[0] != null)
            {
                document.getElementById(htmlTag).value = xmlObj.getElementsByTagName(xmlTag)[0].childNodes[0].nodeValue;
            }
            else
            {
                document.getElementById(htmlTag).value = "";
            }
        }
        
        function setSelectField(xmlTag,htmlTag,xmlObj,compareLen)
        {
            var htmlObj = document.getElementById(htmlTag);
            if(xmlObj.getElementsByTagName(xmlTag)[0] != null && xmlObj.getElementsByTagName(xmlTag)[0].childNodes[0] != null)
            {
                for(var i=0;i<htmlObj.options.length;i++)
                {
                    if(htmlObj.options(i).value.substring(0,compareLen) == xmlObj.getElementsByTagName(xmlTag)[0].childNodes[0].nodeValue.substring(0,compareLen))
                    {
                        htmlObj.options(i).selected = true;
                    }
                }
            }
            else
            {
                htmlObj.selectedIndex = -1;
            }
        }
        function formatDouble(fieldID)
        {
            var tmpVal;
            try{
                if(document.getElementById(fieldID).value != "")
                {
                    tmpVal = parseFloat(document.getElementById(fieldID).value);
                    document.getElementById(fieldID).value = tmpVal.toFixed(2);
                }
            }catch(error)
            {
                alert(error.message);
            }
        }
        
        function findSelect(oSelect,selVal)
        {
            oSelect.options.selectedIndex = 0;
            
            for(var i=0;i<oSelect.options.length;i++)
            {
                if(oSelect.options[i].value == selVal)
                {
                    oSelect.options[i].selected = true;
                    break;
                }
            }
        }
        function viewPDF()
        {
            var isDocBeingModified = document.getElementById("isDocBeingModified").value;
            var form = document.getElementById("form1");
            var noValue = document.getElementById("txtWRNum").value;

            var answer,question
            var isSaved = false;
            
            if(noValue == "" || noValue == "Select One")
            {
                alert("Please, select billing number to view PDF");
		        return false;
            }
            
            if(isDocBeingModified > 0 && noValue != "")
            {
                question = "The form has been modified. Do you want to save it before proceeding?";
                answer = confirm(question,"PDF Viewing");
                if (answer){
                    saveForm();
                    isDocBeingModified = 0;
                }
                else{
                    return false;
                }
            }
            else
            {
                showPDF();
            }
        }
        
        
        /*
        //  Pop page - form submit trick
        //  Opens two window with same variable close one before open another
        //  form target varies as the poped windows refers different target names
        //  Thnx to Joon ^_________________________________^
        */
        var windowCount = 0;
        function showPDF()
        {
            var form = document.getElementById("form1");
            var newWindow;
        	        
            form.action = "dock_receipt_pdf.asp";
            form.method = "POST";
            if(windowCount%2 == 0)
            {
                newWindow = window.open('', 'fooCopy', 'menubar=1,toolbar=1,height=600,width=900,hotkeys=0,scrollbars=1,resizable=1');
                newWindow = window.open('', 'foo', 'menubar=1,toolbar=1,height=600,width=900,hotkeys=0,scrollbars=1,resizable=1');
                newWindow.close();
                form.target = "fooCopy";  
            }
            else
            {
                newWindow = window.open('', 'foo', 'menubar=1,toolbar=1,height=600,width=900,hotkeys=0,scrollbars=1,resizable=1');
                newWindow = window.open('', 'fooCopy', 'menubar=1,toolbar=1,height=600,width=900,hotkeys=0,scrollbars=1,resizable=1');
                newWindow.close();
                form.target = "foo";

            }
            form.submit();    
            windowCount++;
        }
        
        function saveForm()
        {
            try{
                var querystring = "";
                var form = document.getElementById("form1");
                var noValue = document.getElementById("hSearchNum").value;

                var count = form.elements.length; 

                
                var url = "/Warehouse/ajaxFunctions/ajax_warehouse_receipt.asp?mode=update&uid=" + noValue;
                
                for(var i = 0; i < count; i++) {
                    if(form.elements[i].name != "")
                    {
                        querystring += form.elements[i].name+"=";
                        if(i < count-1)
                        { 
                            querystring += encodeURIComponent(form.elements[i].value)+"&";
                        }
                        else 
                        {
                            querystring += encodeURIComponent(form.elements[i].value); 
                        }
                    }
                }
                new ajax.xhr.Request('POST',querystring,url,afterUpdate,'','','','');
                document.getElementById("isDocBeingSubmitted").value = true;
            }catch(err)
            {}
        }
        
        function afterUpdate(req,field,tmpVal,tWidth,tMaxLength,url){
            if (req.readyState == 4){
		        if (req.status == 200)
		        {
		            var returnText = req.responseText;
		            if(returnText != null && returnText != "") 
		            {
		                alert(req.responseText);
                        lstSearchNumChange(document.getElementById("hSearchNum").value,document.getElementById("lstSearchNum").value);
		            }
		        }
		    }
        }
        
        function deleteThis()
        {
            var noValue = document.getElementById("hSearchNum").value;
            
            if(typeValue == "none" && noValue != "" && noValue != "Select One")
            {
                var answer = confirm("Please, click OK to delete this file.");
                if(!answer)
                {
                    return false;
                }
                try{
                    var querystring = "";
                    var form = document.getElementById("form1");
                    
                    var url = "/Warehouse/ajaxFunctions/ajax_warehouse_receipt.asp?mode=delete&no=" + noValue;
                    new ajax.xhr.Request('GET','',url,afterDelete,'','','','');
                    document.getElementById("isDocBeingSubmitted").value = true;
                }catch(err)
                {}
            }
            else
            {
                alert("Please, select a anonymous file to delete.");
                return false;
            }
        }
        
        function afterDelete(req,field,tmpVal,tWidth,tMaxLength,url)
        {
            if (req.readyState == 4)
            {   
		        if (req.status == 200)
		        {
                    alert(req.responseText);
                    lstSearchNumChange(-1,'');
		        }
		    }
        }
        
        function searchNumFill(obj,changeFunction,vHeight){
            var qStr = obj.value;
            var keyCode = window.event.keyCode;
            var url;

            if(qStr != "" && keyCode != 229 && keyCode != 27){
                url = "/Warehouse/ajaxFunctions/ajax_warehouse_receipt.asp?mode=list&qStr=" + qStr;
                FillOutJPED(obj,url,changeFunction,vHeight);
            }
        }
        
        function searchNumFillAll(objName,changeFunction,vHeight){
            var obj = document.getElementById(objName);
            
            url = "/Warehouse/ajaxFunctions/ajax_warehouse_receipt.asp?mode=list";
            FillOutJPED(obj,url,changeFunction,vHeight);
        }
        
        
        // Start of list change effect //////////////////////////////////////////////////////////////////
        
        function lstSearchNumChange(argV,argL){
            var divObj = document.getElementById("lstSearchNumDiv");

            document.getElementById("isDocBeingSubmitted").value = false;
            document.getElementById("isDocBeingModified").value = 0;
	        document.getElementById("lstSearchNum").value = argL;
	        document.getElementById("hSearchNum").value = argV;
	        
            var url = "/Warehouse/ajaxFunctions/ajax_warehouse_receipt.asp?mode=view&uid=" + argV;
            new ajax.xhr.Request('GET','',url,displayScreen,'','','','');
            
            divObj.style.visibility = "hidden";
            divObj.style.position = "absolute";
		    divObj.innerHTML = "";
        }

        function lstDeliveryToChange(orgNum,orgName)
        {
            var hiddenObj = document.getElementById("hDeliveryToAcct");
            var infoObj = document.getElementById("txtDeliveryToInfo");
            var txtObj = document.getElementById("lstDeliveryToName");
            var divObj = document.getElementById("lstDeliveryToNameDiv")
    
            hiddenObj.value = orgNum;
            infoObj.value = getOrganizationInfo(orgNum,"B");
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
		    docModified(1);
        }
        
        function lstReceivedFromNameChange(orgNum,orgName)
        {
            var hiddenObj = document.getElementById("hReceivedFromAcct");
            var infoObj = document.getElementById("txtReceivedFromInfo");
            var txtObj = document.getElementById("lstReceivedFromName");
            var divObj = document.getElementById("lstReceivedFromNameDiv")
    
            hiddenObj.value = orgNum;
            infoObj.value = getOrganizationInfo(orgNum,"B");
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
		    docModified(1);
        }
        
        function lstTruckerNameChange(orgNum,orgName){
            var hiddenObj = document.getElementById("hTruckerAcct");
            var txtObj = document.getElementById("lstTruckerName");
            var divObj = document.getElementById("lstTruckerNameDiv");
            var infoObj = document.getElementById("txtTruckerInfo");
    
            hiddenObj.value = orgNum;
            txtObj.value = orgName;
            infoObj.value = getOrganizationInfo(orgNum,"D");
            divObj.style.visibility = "hidden";
            divObj.style.position = "absolute";
		    divObj.innerHTML = "";
		    docModified(1);
        }
        
        function getOrganizationInfo(orgNum,infoFormat){
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

            var url="/Warehouse/ajaxFunctions/ajax_get_org_address_info.asp?type=" + infoFormat + "&org=" + orgNum;

            xmlHTTP.open("GET",url,false); 
            xmlHTTP.send();
            
            return xmlHTTP.responseText; 
        }
        
// End of list change effect ///////////////////////////////////////////////////////////////////  

    </script>

    <style type="text/css">

		.style6 {
			color: #09609F
		}
		.style8 {	
			color: #cc6600;
			font-weight: bold;
		}
		.style9 {
			color: #cc6600
		}
		body {
			margin-left: 0px;
			margin-right: 0px;
			margin-bottom: 0px;
		}
		.statement {	line-height: 15px;
		}
		.read, .write {
			background:#dddddd;
			border-top-width: 1px;
			border-right-width: 1px;
			border-bottom-width: 1px;
			border-left-width: 1px;
			border-top-style: solid;
			border-right-style: solid;
			border-bottom-style: solid;
			border-left-style: solid;
			border-top-color: #666666;
			border-right-color: #cccccc;
			border-bottom-color: #cccccc;
			border-left-color: #666666;
			height: 16px;
			font-family:Verdana, Arial, Helvetica, sans-serif;	
			font-size:9px;
		}
		.write {
			background:#ffffff;			
		}
        .style10 {color: #000000; font-weight: bold; }
        .style14 {color: #CC0000}
        .style15 {color: #999999}

    </style>
</head>

<body>

    <form id="form1" action="" onKeyDown="javascript:docModified(1);">
        <input type="hidden" id="isDocBeingSubmitted" value="false" />
        <input type="hidden" id="isDocBeingModified" value="0" />
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td width="50%" align="left" valign="middle" class="pageheader">
                    WHEREHOUSE RECEIPT
                </td>
                <td width="50%" align="right" valign="middle">
                    &nbsp;
                </td>
            </tr>
        </table>
        <div class="selectarea">
            <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                    <td valign="bottom">
                        <!-- Start JPED -->
                        <input type="hidden" id="hSearchNum" name="hSearchNum" />
                        <div id="lstSearchNumDiv">
                        </div>
                        <table cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td style="width: 150px">
                                </td>
                                <td>
                                    <input type="text" autocomplete="off" id="lstSearchNum" name="lstSearchNum" value=""
                                        class="shorttextfield" style="width: 150px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                        border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onKeyUp="docModified(-1); searchNumFill(this,'lstSearchNumChange',200);"
                                        onfocus="initializeJPEDField(this);" /></td>
                                <td>
                                    <img src="/ig_common/Images/combobox_drop.gif" alt="" onClick="searchNumFillAll('lstSearchNum','lstSearchNumChange',200);"
                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                        border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                            </tr>
                        </table>
                        <!-- End JPED -->
                    </td>
                    <td width="98%" align="right" valign="bottom">
                        <div id="print">
                            <img src="/Warehouse/images/icon_printer.gif" align="absbottom">
                            <a href="javascript:;" onClick="viewPDF(); return false;" style="cursor: hand;">WAREHOUSE
                                RECEIPT</a></div>
                    </td>
                </tr>
            </table>
        </div>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#5a737c"
            bgcolor="ba9590" class="border1px">
            <tr bordercolor="ba9590" class="border1px">
                <td>
                    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" brdrcolor="#5a737c"
                        bgcolor="#5a737c">
                        <tr bordercolor="#5a737c">
                            <td>
                                <table width="100%" border="0" cellpadding="2" cellspacing="0" bordercolor="#5a737c">
                                    <tr bgcolor="#c8e1ea">
                                        <td height="22" align="center" valign="middle" bgcolor="#b1d4e1" class="bodyheader">
                                            <table width="98%" border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td width="26%">
                                                        &nbsp;
                                                    </td>
                                                    <td width="48%" align="center" valign="middle">
                                                        <img src="/Warehouse/images/button_save_medium.gif" width="46" height="18" name="bSave" onClick="saveForm();"
                                                            style="cursor: hand" /></td>
                                                    <td width="13%" align="right" valign="middle">
                                                        <a href="./warehouse_receipt.asp">
                                                            <img src="/Warehouse/images/button_new.gif" border="0" style="cursor: hand"></a></td>
                                                    <td width="13%" align="right" valign="middle">
                                                        <img src="/Warehouse/images/button_delete_medium.gif" style="cursor: hand" onClick="deleteThis();">
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="9" bgcolor="#5a737c">
                                        </td>
                                    </tr>
                                    <tr align="center">
                                        <td valign="middle" bgcolor="#f3f3f3" class="bodycopy">
                                            <span class="bodyheader">
                                                <select id="lstSearchType" class="bodyheader" style="visibility: hidden">
                                                    <option value="po" selected="selected">Pickup Order Number</option>
                                                </select>
                                            </span>
                                            <br />
                                            <br />
                                            <table width="86%" cellpadding="0" cellspacing="0" bordercolor="#5a737c" class="border1px">
                                                <tr align="left" valign="middle" bgcolor="#ffffff" class="bodycopy">
                                                    <td width="47%" height="19" colspan="2" valign="top" bgcolor="#f3f3f3">
                                                        <!-- starts pickup and deliver -->
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="border-right: #5a737c solid 1px">
                                                            <tr>
                                                                <td width="2%" bgcolor="#c8e1ea">
                                                                </td>
                                                                <td height="20" colspan="2" align="center" valign="middle" bgcolor="#c8e1ea">
                                                                    <span class="bodyheader style6 style12 style9">PICKUP FROM </span>
                                                                </td>
                                                            </tr>
                                                            <tr align="left" valign="middle" bgcolor="#5a737c" class="bodycopy">
                                                                <td height="1" colspan="3">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#FFFFFF">
                                                                    &nbsp;
                                                                </td>
                                                                <td colspan="2" bgcolor="#FFFFFF" class="bodycopy">
                                                                    <span class="style15">Contact</span><br />
                                                                    <input type="text" name="txtContact" class="shorttextfield" style="width: 300px;" />
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#FFFFFF">
                                                                    &nbsp;
                                                                </td>
                                                                <td colspan="2" bgcolor="#FFFFFF" class="bodycopy">
                                                                    <!-- Start JPED -->
                                                                    <input type="hidden" id="hReceivedFromAcct" name="hReceivedFromAcct" />
                                                                    <div id="lstReceivedFromNameDiv">
                                                                    </div>
                                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                                        <tr>
                                                                            <td>
                                                                                <input type="text" autocomplete="off" id="lstReceivedFromName" name="lstReceivedFromName" value=""
                                                                                    class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                                    border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onKeyUp="organizationFill(this,'All','lstReceivedFromNameChange')"
                                                                                    onfocus="initializeJPEDField(this);" /></td>
                                                                            <td>
                                                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onClick="organizationFillAll('lstReceivedFromName','All','lstReceivedFromNameChange')"
                                                                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                                    border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                                            <td>
                                                                                <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                                    onclick="quickAddClient('hReceivedFromAcct','lstReceivedFromName','txtPickupInfo')" /></td>
                                                                        </tr>
                                                                    </table>
                                                                    <textarea wrap="hard" id="txtReceivedFromInfo" name="txtReceivedFromInfo" class="multilinetextfield"
                                                                        cols="" rows="5" style="width: 300px"></textarea>
                                                                    <!-- End JPED -->
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#FFFFFF">
                                                                </td>
                                                                <td width="48%" bgcolor="#FFFFFF" class="bodycopy">
                                                                </td>
                                                                <td width="50%" height="8" bgcolor="#FFFFFF" class="bodycopy">
                                                                </td>
                                                            </tr>
                                                            <tr align="left" valign="middle" bgcolor="#5a737c" class="bodycopy">
                                                                <td height="1" colspan="3">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#c8e1ea">
                                                                    &nbsp;
                                                                </td>
                                                                <td height="20" colspan="2" align="center" valign="middle" bgcolor="#c8e1ea" class="bodyheader">
                                                                    <span class="style8">DELIVERY TO</span></td>
                                                            </tr>
                                                            <tr align="left" valign="middle" bgcolor="#5a737c" class="bodycopy">
                                                                <td height="1" colspan="3">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#FFFFFF">
                                                                    &nbsp;
                                                                </td>
                                                                <td colspan="2" bgcolor="#FFFFFF" class="bodycopy">
                                                                    <span class="style15">Attention To</span><br />
                                                                    <input name="txtAttention" type="text" class="shorttextfield" value="" style="width: 300px;" /></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#FFFFFF">
                                                                    &nbsp;
                                                                </td>
                                                                <td colspan="2" bgcolor="#FFFFFF" class="bodycopy">
                                                                    <!-- Start JPED -->
                                                                    <input type="hidden" id="hDeliveryToAcct" name="hDeliveryToAcct" />
                                                                    <div id="lstDeliveryToNameDiv">
                                                                    </div>
                                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                                        <tr>
                                                                            <td>
                                                                                <input type="text" autocomplete="off" id="lstDeliveryToName" name="lstDeliveryToName" value=""
                                                                                    class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                                    border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onKeyUp="organizationFill(this,'','lstDeliveryToChange')"
                                                                                    onfocus="initializeJPEDField(this);" /></td>
                                                                            <td>
                                                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onClick="organizationFillAll('lstDeliveryToName','','lstDeliveryToChange')"
                                                                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                                    border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                                            <td>
                                                                                <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                                    onclick="quickAddClient('hDeliveryToAcct','lstDeliveryToName','txtDeliveryToInfo')" /></td>
                                                                        </tr>
                                                                    </table>
                                                                    <textarea wrap="hard" id="txtDeliveryToInfo" name="txtDeliveryToInfo" class="multilinetextfield"
                                                                        cols="" rows="5" style="width: 300px"></textarea>
                                                                    <!-- End JPED -->
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#FFFFFF">
                                                                </td>
                                                                <td bgcolor="#FFFFFF" class="bodycopy">
                                                                </td>
                                                                <td height="8" bgcolor="#FFFFFF" class="bodycopy">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="1" colspan="5" bgcolor="#5a737c">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="2" colspan="5" bgcolor="#ffffff">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="1" colspan="5" bgcolor="#5a737c">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#F3F3F3">
                                                                </td>
                                                                <td height="18" bgcolor="#F3F3F3" class="bodyheader">
                                                                    Customer Reference No.
                                                                </td>
                                                                <td height="8" bgcolor="#F3F3F3" class="bodycopy">
                                                                    &nbsp;</td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#FFFFFF">
                                                                </td>
                                                                <td bgcolor="#FFFFFF" class="bodycopy">
                                                                    <span class="bodyheader"><span class="bodylistheader">
                                                                        <input name="txtCustomerRef" type="text" class="shorttextfield" value="" size="32"
                                                                            style="width: 140px" />
                                                                    </span></span>
                                                                </td>
                                                                <td height="8" bgcolor="#FFFFFF" class="bodycopy">
                                                                    &nbsp;</td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#F3F3F3">
                                                                </td>
                                                                <td height="18" bgcolor="#F3F3F3" class="bodycopy">
                                                                    <span class="bodyheader">Contained Hazardous Goods</span></td>
                                                                <td bgcolor="#F3F3F3" class="bodyheader">
                                                                    Received Date
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#FFFFFF">
                                                                </td>
                                                                <td height="22" valign="top" bgcolor="#FFFFFF" class="bodycopy">
                                                                    <input type="checkbox" name="chkDangerGood" value="Y" id="chkDangerGoodY" />
                                                                    Yes
                                                                    <input type="checkbox" name="chkDangerGood" value="N" style="margin-left: 17px" id="chkDangerGoodN" />
                                                                    No
                                                                </td>
                                                                <td valign="top" bgcolor="#FFFFFF" class="bodycopy">
                                                                    <span class="bodylistheader">
                                                                        <input name="txtCustomerRef" type="text" class="shorttextfield" value="" size="32"
                                                                            style="width: 140px" />
                                                                    </span>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                        <!-- ends pickup and deliver -->
                                                    </td>
                                                    <td width="53%" valign="top" bgcolor="#FFFFFF">
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                                            <tr>
                                                                <td bgcolor="#c8e1ea">
                                                                    &nbsp;
                                                                </td>
                                                                <td width="41%" height="20" bgcolor="#c8e1ea">
                                                                    <span class="style10">Date</span></td>
                                                                <td width="57%" bgcolor="#c8e1ea">
                                                                    <span class="bodyheader style12">Warehouse Receipt No.</span>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#FFFFFF">
                                                                    &nbsp;
                                                                </td>
                                                                <td height="18" bgcolor="#FFFFFF">
                                                                    <input name="txtUpdateDate" type="text" class="m_shorttextfield" value="6/6/2007"
                                                                        size="16" preset="shortdate" /></td>
                                                                <td bgcolor="#FFFFFF">
                                                                    <span class="bodyheader">
                                                                        <input name="txtWRNum" id="txtWRNum" type="text" class="readonlybold" value="" size="20"
                                                                            readonly="readonly" />
                                                                    </span>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="2" colspan="3" bgcolor="#5a737c">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#F3F3F3">
                                                                    &nbsp;
                                                                </td>
                                                                <td height="18" colspan="2" bgcolor="#F3F3F3">
                                                                    <strong>Delivered by </strong>(Pickup Order Issued to)</td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#FFFFFF">
                                                                    &nbsp;
                                                                </td>
                                                                <td height="18" colspan="2" bgcolor="#FFFFFF">
                                                                    <!-- Start JPED -->
                                                                    <input type="hidden" id="hTruckerAcct" name="hTruckerAcct" />
                                                                    <div id="lstTruckerNameDiv">
                                                                    </div>
                                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                                        <tr>
                                                                            <td>
                                                                                <input type="text" autocomplete="off" id="lstTruckerName" name="lstTruckerName" value=""
                                                                                    class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                                    border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onKeyUp="organizationFill(this,'Trucker','lstTruckerNameChange')"
                                                                                    onfocus="initializeJPEDField(this);" /></td>
                                                                            <td>
                                                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onClick="organizationFillAll('lstTruckerName','Trucker','lstTruckerNameChange')"
                                                                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                                    border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                                            <td>
                                                                                <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                                    onclick="quickAddClient('hTruckerAcct','lstTruckerName')" /></td>
                                                                        </tr>
                                                                    </table>
                                                                    <textarea wrap="hard" id="txtTruckerInfo" name="txtTruckerInfo" class="multilinetextfield"
                                                                        cols="" rows="2" style="width: 300px"></textarea>
                                                                    <!-- End JPED -->
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td width="2%" bgcolor="#f3f3f3">
                                                                    &nbsp;
                                                                </td>
                                                                <td height="18" colspan="2" bgcolor="#f3f3f3">
                                                                    <span class="bodyheader">Local Delivery or Transfer Reference No.</span></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#FFFFFF">
                                                                    &nbsp;
                                                                </td>
                                                                <td bgcolor="#FFFFFF">
                                                                    <input name="txtPickupRefNum" id="txtPickupRefNum" type="text" class="shorttextfieldBold"
                                                                        value="" style="width: 140px" />
                                                                </td>
                                                                <td bgcolor="#FFFFFF">
                                                                    &nbsp;
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="2" colspan="3" bgcolor="#5a737c">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="20" colspan="3" bgcolor="#f3f3f3">
                                                                    <table width="100%" cellspacing="0" cellpadding="0" style="border-style: none; border-width: 2px;
                                                                        border: thick; border-color: #996600">
                                                                        <tr>
                                                                            <td width="2%" bgcolor="#FFFFFF">
                                                                                &nbsp;
                                                                            </td>
                                                                            <td width="25%" height="24" bgcolor="#FFFFFF">
                                                                                <span class="bodyheader">INLAND FREIGHT
                                                                                    <input type="hidden" id="hInlandChargeType" name="hInlandChargeType" value="" />
                                                                                </span>
                                                                            </td>
                                                                            <td width="73%" bgcolor="#FFFFFF">
                                                                                <span class="bodyheader">
                                                                                    <input type="checkbox" name="chInlandChargeType" value="P" onClick="chInlandChargeType_click('P');" />
                                                                                    PREPAID
                                                                                    <input type="checkbox" name="chInlandChargeType" value="C" onClick="chInlandChargeType_click('C');"
                                                                                        style="margin-left: 14px" />
                                                                                    COLLECT</span></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>
                                                                                &nbsp;
                                                                            </td>
                                                                            <td height="24">
                                                                                <span class="bodyheader style12 style9">C.O.D. AMOUNT </span>
                                                                            </td>
                                                                            <td>
                                                                                <span class="bodyheader style12">
                                                                                    <input type="text" class="bodyheader" name="txtInlandCharge" value="" onKeyPress="checkNum();"
                                                                                        style="margin-left: 4px" />
                                                                                </span>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="1" colspan="3" bgcolor="#5a737c">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="2" colspan="3" bgcolor="#ffffff">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="1" colspan="3" bgcolor="#5a737c">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#f3f3f3">
                                                                    &nbsp;
                                                                </td>
                                                                <td height="18" bgcolor="#f3f3f3">
                                                                    <span class="bodyheader">Handling Info.</span></td>
                                                                <td bgcolor="#f3f3f3">
                                                                    &nbsp;
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#FFFFFF">
                                                                    &nbsp;
                                                                </td>
                                                                <td height="18" colspan="2" bgcolor="#FFFFFF">
                                                                    <textarea name="txtHandling" wrap="hard" cols="50" rows="6" class="multilinetextfield"
                                                                        style="width: 300px"></textarea></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    &nbsp;</td>
                                                                <td height="37">
                                                                    &nbsp;</td>
                                                                <td>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#f3f3f3">
                                                                    &nbsp;</td>
                                                                <td height="18" bgcolor="#f3f3f3">
                                                                    <span class="bodyheader">Available Pick Up Date </span>
                                                                </td>
                                                                <td bgcolor="#f3f3f3">
                                                                    <span class="bodyheader">Storage Start Date </span>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#FFFFFF">
                                                                    &nbsp;</td>
                                                                <td height="18" bgcolor="#FFFFFF">
                                                                    <span class="bodylistheader">
                                                                        <input name="" type="text" class="shorttextfield" value="" size="32" style="width: 140px" />
                                                                    </span>
                                                                </td>
                                                                <td>
                                                                    <span class="bodylistheader">
                                                                        <input name="" type="text" class="shorttextfield" value="" size="32" style="width: 140px" />
                                                                    </span>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                            <table width="86%" border="0" cellpadding="2" cellspacing="0" bordercolor="#5a737c"
                                                class="border1px">
                                                <tr bgcolor="#c8e1ea">
                                                    <td width="0%" height="19">
                                                        &nbsp;
                                                    </td>
                                                    <td width="10%" bgcolor="#c8e1ea">
                                                        <strong>No. of PKGS</strong></td>
                                                    <td width="33%">
                                                        <strong>Description of Articles, Special Marks &amp; Exceptions </strong>
                                                    </td>
                                                    <td width="15%">
                                                        <strong>Gross Weight</strong></td>
                                                    <td width="19%">
                                                        <strong>Dimension</strong></td>
                                                    <td width="23%" class="bodyheader">
                                                        Damage &amp; Exceptions<span class="style14"> </span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td bgcolor="#FFFFFF">
                                                        &nbsp;
                                                    </td>
                                                    <td align="left" valign="top" bgcolor="#FFFFFF">
                                                        <input name="txtPieces" type="text" class="txtunitbox" value="" size="8"></td>
                                                    <td valign="top" bgcolor="#FFFFFF">
                                                        <textarea name="txtDesc3" wrap="hard" cols="30" rows="7" class="multilinetextfield"
                                                            style="width: 280px"></textarea></td>
                                                    <td align="left" valign="top" bgcolor="#FFFFFF">
                                                        <input name="txtGrossWt" type="text" class="txtunitbox" onKeyPress="checkNum(); resetWeight();"
                                                            value="" size="10" />
                                                        <select name="lstScale1" class="smallselect" onChange="convertKG_LB(0)">
                                                            <option value="KG">KG</option>
                                                            <option value="LB">LB</option>
                                                        </select>
                                                    </td>
                                                    <td valign="top" bgcolor="#FFFFFF">
                                                        <textarea id="txtDimension" name="txtDimension" rows="7" cols="24" class="multilinetextfield"></textarea>
                                                    </td>
                                                    <td valign="top" bgcolor="#FFFFFF">
                                                        <textarea id="txtDamageException" name="txtDamageException" rows="7" cols="30" class="multilinetextfield"></textarea></td>
                                                </tr>
                                                <tr>
                                                    <td bgcolor="#FFFFFF">
                                                    </td>
                                                    <td height="6" align="left" valign="top" bgcolor="#FFFFFF">
                                                    </td>
                                                    <td valign="top" bgcolor="#FFFFFF">
                                                    </td>
                                                    <td align="left" valign="top" bgcolor="#FFFFFF">
                                                    </td>
                                                    <td bgcolor="#FFFFFF">
                                                    </td>
                                                    <td bgcolor="#FFFFFF">
                                                    </td>
                                                </tr>
                                            </table>
                                            <br />
                                        </td>
                                    </tr>
                                    <tr align="center">
                                        <td height="1" valign="middle" bgcolor="#5a737c" class="bodycopy">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="24" bgcolor="#b1d4e1">
                                            <table width="98%" border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td width="26%" valign="middle">
                                                        &nbsp;
                                                    </td>
                                                    <td width="48%" align="center" valign="middle">
                                                        <img src="/Warehouse/images/button_save_medium.gif" width="46" height="18" name="bSave" onClick="saveForm();"
                                                            style="cursor: hand" /></td>
                                                    <td width="13%" align="right" valign="middle">
                                                        <a href="/Warehouse/pre_shipment/dock_receipt.asp" target="_self">
                                                            <img src="/Warehouse/images/button_new.gif" width="42" height="17" border="0"
                                                                style="cursor: hand"></a></td>
                                                    <td width="13%" align="right" valign="middle">
                                                        <img src="/Warehouse/images/button_delete_medium.gif" alt="Delete House AWB No." name="bDeleteHAWB"
                                                            width="51" height="18" style="cursor: hand" onClick=""></td>
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
        </table>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td height="32" align="right" valign="bottom">
                    <div id="PrintBottom">
                        <img src="/Warehouse/images/icon_printer.gif" width="44" height="27" align="absbottom"><b
                            style="cursor: hand;" class="bodycopy" onClick="viewPDF();">WAREHOUSE RECEIPT </b>
                    </div>
                </td>
            </tr>
        </table>
        <br />

        <script type="text/javascript">
        function getFormObject(argObj){
    
        var form = argObj.parentElement;
        var newWindow;
        	        
            form.action = "/Warehouse/include/GOOFY_form_get.asp";
            form.method = "POST";
            window.open('', 'formTest');
            form.target = "formTest";
            form.submit();
        }
        </script>

        <input type="button" value="form object" onClick="getFormObject(this)" />
    </form>
</body>
</html>
