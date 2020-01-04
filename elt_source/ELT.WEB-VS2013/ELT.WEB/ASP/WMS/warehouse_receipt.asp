<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>

<%
    Dim vOrg, vOrgN, reloadPage, noValue

    vOrgN = CheckBlank(Request.QueryString("o"), "")
    vOrg = CheckBlank(Request.QueryString("n"), "")
    If Not vOrg = ""  Then
        reloadPage = "Y"
    End if
	    	
%>

<!--  #INCLUDE VIRTUAL="/ASP/include/connection.asp" -->
<!--  #INCLUDE VIRTUAL="/ASP/include/Header.asp" -->
<!--  #include VIRTUAL="/ASP/include/recent_file.asp" -->
<!--  #INCLUDE VIRTUAL="/ASP/include/GOOFY_util_fun.inc" -->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
     <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
    <title>WAREHOUSE RECEIPT</title>
    <meta http-equiv="Content-Type" content="text/html; UTF-8" />
    <link href="/ASP/css/elt_css.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" language="javascript" src="/ASP/ajaxFunctions/ajax.js"></script>

    <script type="text/javascript" src="/ASP/include/JPED.js"></script>

    <script type="text/javascript" language="javascript">
        
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
        }

        function resetMeasure(arg)
        {
            measures[arg] = "";
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
                oInterval = window.setInterval("topSyncLater()",500);
            }
        }
        
        function topSyncLater()
        {
            window.clearInterval(oInterval);
            try{
                window.focus();
                var tabURL = parent.document.frames['topFrame'].window.document.getElementById("hCurrentPage").value;
                var topModlueObj = parent.document.frames['topFrame'].window.document.getElementById("lstTopModule");
                var pageURL = document.location.href;
                if(pageURL.toUpperCase().match(tabURL.toUpperCase())==null){
                    
                    parent.document.frames['topFrame'].location = "/ASP/tabs/tab_maker.asp?mode=back&page=" 
                        + pageURL + "&top=" + topModlueObj.options[topModlueObj.options.selectedIndex].text;
                }
            }catch (ex) {}
        }
        
        
        function displayScreen(req,field,tmpVal,tWidth,tMaxLength,url)
        {
            if (req.readyState == 4)
            {   
		        if (req.status == 200)
		        {
		            try{
		                var xmlObj = req.responseXML;
		                
                        setField("wr_num","txtWRNum",xmlObj);
                        setField("carrier_ref_no","txtCarrierRefNo",xmlObj);
                        setField("customer_ref_no","txtCustomerRefNo",xmlObj);
                        
                        setField("shipper_acct","hReceivedFromAcct",xmlObj);
                        setField("shipper_name","lstReceivedFromName",xmlObj);
                        setField("shipper_info","txtReceivedFromInfo",xmlObj);
                        
                        setField("customer_acct","hAccountOfAcct",xmlObj);
                        setField("customer_name","lstAccountOfName",xmlObj);
                        setField("customer_info","txtAccountOfInfo",xmlObj);
                        
                        setField("trucker_acct","hTruckerAcct",xmlObj);
                        setField("trucker_name","lstTruckerName",xmlObj);
                        setField("trucker_info","txtTruckerInfo",xmlObj);
                        
                        setField("created_date","txtUpdatedDate",xmlObj);
                        setField("received_date","txtReceivedDate",xmlObj);
                        setField("pickup_date","txtPickupDate",xmlObj);
                        setField("storage_date","txtStorageDate",xmlObj);
                        setField("PO_NO","txtPONO",xmlObj);
                        setField("shipper_contact","txtReceivedFromContact",xmlObj);
                        setField("customer_contact","txtAccountOfContact",xmlObj);
                        
                        setField("inland_amount","txtInlandCharge",xmlObj);
                        setCheck("inland_type","chkInlandChargeType",xmlObj);
                        setCheck("danger_good","chkDangerGood",xmlObj);
                        setField("handling_info","txtHandling",xmlObj);
                        
                        setField("item_piece_origin","txtItemPieces",xmlObj);
                        setField("item_desc","txtItemDesc",xmlObj);
                        setSelectField("item_weight_scale","lstWeightScale",xmlObj,1);
                        setField("item_weight","txtGrossWeight",xmlObj);
                        
                        setSelectField("item_dimension_scale","lstDimScale",xmlObj,3);
                        setField("item_dimension","txtDimension",xmlObj);
                        setField("item_remark","txtDamageException",xmlObj);
    					
                        // number format
				        formatDouble("txtInlandCharge");
				        formatDouble("txtGrossWeight");
				        
				        //lock quantity
				        if(getWRShipInfo(document.getElementById("txtWRNum").value) == "Lock"){
				            document.getElementById("txtItemPieces").disabled = true;
				            document.getElementById("lstAccountOfName").disabled = true;
                            document.getElementById("txtAccountOfInfo").disabled = true;
                            document.getElementById("imgAccountOfButton").disabled = true;
                            document.getElementById("imgAccountOfAddButton").disabled = true;
				        }
				        else{
				            document.getElementById("txtItemPieces").disabled = false;
				        }

                    }catch(error){
                        alert(error.description);
                        xmlObj = null;
                    }
                    xmlObj = null;
		        }
		        else{
		            document.write(req.responseText);
		        }
		    }
		}
		
		function getWRShipInfo(vWRNum){
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

            var url="/ASP/ajaxFunctions/ajax_warehouse_receipt.asp?mode=shipCheck&qstr=" + encodeURIComponent(vWRNum);

            xmlHTTP.open("GET",url,false); 
            xmlHTTP.send();
            
            return xmlHTTP.responseText; 
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
        
        function setSelectField(xmlTag,htmlTag,xmlObj,compareLen){
            var htmlObj = document.getElementById(htmlTag);
            if(xmlObj.getElementsByTagName(xmlTag)[0] != null 
                && xmlObj.getElementsByTagName(xmlTag)[0].childNodes[0] != null){
                for(var i=0;i<htmlObj.length;i++){
                    if(htmlObj.children.item(i).value.substring(0,compareLen) == xmlObj.getElementsByTagName(xmlTag)[0].childNodes[0].nodeValue.substring(0,compareLen)){
                        htmlObj.children.item(i).selected = true;
                    }
                }
            }
            else{
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
            
            for(var i=0;i<oSelect.children.length;i++)
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
            var isDocBeingSubmitted = document.getElementById("isDocBeingSubmitted").value;
            var form = document.getElementById("form1");
            var noValue = document.getElementById("txtWRNum").value;

            var answer,question
            var isSaved = false;
            
            if(noValue == "" || noValue == "Select One")
            {
                alert("Please, select billing number to view PDF");
		        return false;
            }
            
            if(isDocBeingModified > 0 && noValue != "" && isDocBeingSubmitted != "true")
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
                showPDFself();
            }
        }
        
        function showPDFself(){
            var form = document.getElementById("form1");
            document.getElementById("hAccountOfInfoPDF").value = document.getElementById("txtAccountOfInfo").value;
            form.action = "warehouse_receipt_pdf2.asp";
            form.method = "POST";
            form.target = "_self";
            form.submit();
        }
        
        function saveForm(){
        
           var Customer_no = document.getElementById("hAccountOfAcct").value;
           var Item_QTY =  document.getElementById("txtItemPieces").value;
            if( Customer_no == "" || Customer_no =="0")
            {
                alert("Please, Select a customer account");
                document.getElementById("lstAccountOfName").focus();
            }
            //check Item selection 
            else if(Item_QTY == "" || Item_QTY <=0 )
            {
                alert("Please, Select Items QTY");
                document.getElementById("txtItemPieces").focus();
            }
            else
            {
                
                try{
                    var querystring = "";
                    var form = document.getElementById("form1");
                    var noValue = document.getElementById("hSearchNum").value;

                    var count = form.elements.length; 
                
                    
                    var url = "/ASP/ajaxFunctions/ajax_warehouse_receipt.asp?mode=update&uid=" + encodeURIComponent(noValue);
                    
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
                    document.getElementById("isDocBeingSubmitted").value = "true";
                }catch(err)
                {}
           }
        }
        
        function afterUpdate(req,field,tmpVal,tWidth,tMaxLength,url){
            if (req.readyState == 4){
		        if (req.status == 200)
		        {
		            var xmlObj = req.responseXML;
		            
		            var error_code = xmlObj.getElementsByTagName("error_code")[0].childNodes[0].nodeValue;
		            
		            if(error_code == -1){
		                var wr_num = xmlObj.getElementsByTagName("wr_num")[0].childNodes[0].nodeValue;
		                alert("Warehouse receipt " + wr_num + " has been saved.");
		                setField("wr_num","lstSearchNum",xmlObj);
                        setField("wr_num","txtWRNum",xmlObj);
                        setField("uid","hSearchNum",xmlObj);
                    }
		            else{
		                if(error_code == 1){
		                    alert("Please, set a warehouse receipt number on prefix manager page.");
		                }
		                else if(error_code == 2){
		                    alert("Please, reset a warehouse receipt number on prefix manager page.");
		                }
		                else{
		                    alert("Unexpected error has occurred while updating.\nPlease, contact us for further instruction.");
		                }
		            }
		        }
		    }
        }
        
        function textLimit(field, maxlen) {
        if (field.value.length > maxlen + 1)
            alert('Your input has exceeded the maximum character!');
        if (field.value.length > maxlen)
            field.value = field.value.substring(0, maxlen);
        }
        
        
        
        function deleteThis(){
            var noValue = document.getElementById("hSearchNum").value;
            var WrNum =document.getElementById("txtWRNum").value;
            if(noValue != "" && noValue != "Select One")
            {
                if(getWRShipInfo(document.getElementById("txtWRNum").value) == "Lock"){
                    alert("This shipment (or part of the shipment) has been placed for warehouse-out.");
                    return false;
                }
                
                var answer = confirm("Please, click OK to delete this Warehouse Receipt ("+ WrNum +")");
                if(!answer){
                    return false;
                }
                try{
                    var querystring = "";
                    var form = document.getElementById("form1");
                    
                    var url = "/ASP/ajaxFunctions/ajax_warehouse_receipt.asp?mode=delete&uid=" + encodeURIComponent(noValue);
                    new ajax.xhr.Request('GET','',url,afterDelete,'','','','');
                    document.getElementById("isDocBeingSubmitted").value = true;
                }catch(err)
                {}
            }
            else
            {
                alert("Please, select a Warehouse Receipt to delete.");
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
        
        // Start of list change effect //////////////////////////////////////////////////////////////////
        
        function searchNumFill(obj,changeFunction,vHeight,event){
            var qStr = obj.value;
            var keyCode = event.keyCode;
            var url;

            if(qStr != "" && keyCode != 229 && keyCode != 27){
                url = "/ASP/ajaxFunctions/ajax_warehouse_receipt.asp?mode=list&qStr=" + qStr;
                FillOutJPED(obj,url,changeFunction,vHeight);
            }
        }
        
        function searchNumFillAll(objName,changeFunction,vHeight){
            var obj = document.getElementById(objName);
            
            url = "/ASP/ajaxFunctions/ajax_warehouse_receipt.asp?mode=list";
            FillOutJPED(obj,url,changeFunction,vHeight);
        }
        
        function lstSearchNumChange(argV,argL){
            var divObj = document.getElementById("lstSearchNumDiv");
            
            document.getElementById("isDocBeingSubmitted").value = false;
            document.getElementById("isDocBeingModified").value = 0;
	        document.getElementById("lstSearchNum").value = argL;
	        document.getElementById("hSearchNum").value = argV;
	        
            var url = "/ASP/ajaxFunctions/ajax_warehouse_receipt.asp?mode=view&uid=" + encodeURIComponent(argV);
            new ajax.xhr.Request('GET','',url,displayScreen,'','','','');
            
            divObj.style.visibility = "hidden";
            divObj.style.position = "absolute";
            divObj.style.height = "0px";
		    divObj.innerHTML = "";
        }

        function lstAccountOfChange(orgNum,orgName)
        {
            var hiddenObj = document.getElementById("hAccountOfAcct");
            var infoObj = document.getElementById("txtAccountOfInfo");
            var txtObj = document.getElementById("lstAccountOfName");
            var divObj = document.getElementById("lstAccountOfNameDiv")
    
            hiddenObj.value = orgNum;
            infoObj.value = getOrganizationInfo(orgNum,"B");
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
            divObj.style.height = "0px";
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
            divObj.style.height = "0px";
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
            divObj.style.height = "0px";
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

            var url="/ASP/ajaxFunctions/ajax_get_org_address_info.asp?type=" + infoFormat + "&org=" + orgNum;

            xmlHTTP.open("GET",url,false); 
            xmlHTTP.send();
            
            return xmlHTTP.responseText; 
        }
        
    // End of list change effect ///////////////////////////////////////////////////////////////////  
       
    </script>

    <style type="text/css">
<!--
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
.style15 {color: #999999}
-->
    </style>
</head>
<body onload="">
    <form id="form1" action="" onkeydown="javascript:docModified(1);">
        <input type="image" style="position:absolute; visibility:hidden" onclick="return false;" />
        <input type="hidden" id="isDocBeingSubmitted" value="false" />
        <input type="hidden" id="isDocBeingModified" value="0" />
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td width="50%" align="left" valign="middle" class="pageheader">
                    WareHOUSE RECEIPT
                </td>
                <td width="50%" align="right" valign="middle">
                    &nbsp;
                </td>
            </tr>
        </table>
        <div class="selectarea">
            <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        <span class="select">Select Warehouse Receipt No.</span></td>
                    <td width="55%" rowspan="2" align="right" valign="bottom">
                        <div id="print">
                            <img src="/ASP/Images/icon_printer.gif" align="absbottom">
                            <a href="javascript:;" onclick="viewPDF(); return false;" style="cursor: pointer;">Warehouse
                                Receipt </a>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="45%" valign="bottom">
                        <!-- Start JPED -->
                        <input type="hidden" id="hSearchNum" name="hSearchNum" />
                        <div id="lstSearchNumDiv">
                        </div>
                        <table cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td>
                                    <input type="text" autocomplete="off" id="lstSearchNum" name="lstSearchNum" value=""
                                        class="shorttextfield" style="width: 150px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                        border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="docModified(-1); searchNumFill(this,'lstSearchNumChange',200);"
                                        onfocus="initializeJPEDField(this,event);" /></td>
                                <td>
                                    <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="searchNumFillAll('lstSearchNum','lstSearchNumChange',200);"
                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                        border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                            </tr>
                        </table>
                        <!-- End JPED -->
                    </td>
                </tr>
            </table>
        </div>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#9e816e"
            bgcolor="ba9590" class="border1px">
            <tr bordercolor="ba9590" class="border1px">
                <td>
                    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#9e816e"
                        bgcolor="#9e816e">
                        <tr bordercolor="#9e816e">
                            <td>
                                <table width="100%" border="0" cellpadding="2" cellspacing="0" bordercolor="#9e816e">
                                    <tr bgcolor="#f4e9e0">
                                        <td height="22" align="center" valign="middle" bgcolor="#e5cfbf" class="bodyheader">
                                            <table width="98%" border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td width="26%">
                                                        &nbsp;
                                                    </td>
                                                    <td width="48%" align="center" valign="middle">
                                                        <img src="/ASP/images/button_save_medium.gif" width="46" height="18" name="bSave"
                                                            onclick="saveForm();" style="cursor: hand" /></td>
                                                    <td width="13%" align="right" valign="middle">
                                                        <a href="./warehouse_receipt.asp">
                                                            <img src="/ASP/Images/button_new.gif" border="0" style="cursor: hand"></a></td>
                                                    <td width="13%" align="right" valign="middle">
                                                        <img src="/ASP/images/button_delete_medium.gif" style="cursor: hand" onclick="deleteThis();">
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="9" bgcolor="#9e816e">
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
                                            <table border="0" cellspacing="0" cellpadding="0" style="width: 91%; height: 17px">
                                                <tr>
                                                    <td height="28" align="right">
                                                        <span class="bodyheader">&nbsp;<img src="/ASP/Images/required.gif" align="absbottom">Required
                                                            field</span></td>
                                                </tr>
                                            </table>
                                            <table width="92%" cellpadding="0" cellspacing="0" bordercolor="#9e816e" class="border1px">
                                                <tr align="left" valign="middle" bgcolor="#ffffff" class="bodycopy">
                                                    <td width="47%" height="19" colspan="2" valign="top" bgcolor="#f3f3f3">
                                                        <!-- starts pickup and deliver -->
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="border-right: #9e816e solid 1px;
                                                            padding-left: 6PX">
                                                            <tr>
                                                                <td height="20" colspan="2" align="center" valign="middle" bgcolor="#f4e9e0">
                                                                    <span class="bodyheader style6 style12 style9">RECEIVED FROM </span>
                                                                </td>
                                                            </tr>
                                                            <tr align="left" valign="middle" bgcolor="#9e816e" class="bodycopy">
                                                                <td height="1" colspan="2">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="8" colspan="2" bgcolor="#FFFFFF" class="bodycopy">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2" bgcolor="#FFFFFF" class="bodycopy">
                                                                    <!-- Start JPED -->
                                                                    <input type="hidden" id="hReceivedFromAcct" name="hReceivedFromAcct" />
                                                                    <div id="lstReceivedFromNameDiv">
                                                                    </div>
                                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                                        <tr>
                                                                            <td>
                                                                                <input type="text" autocomplete="off" id="lstReceivedFromName" name="lstReceivedFromName"
                                                                                    value="" class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9;
                                                                                    border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;"
                                                                                    onkeyup="organizationFill(this,'All','lstReceivedFromNameChange',null,event)" onfocus="initializeJPEDField(this,event);" /></td>
                                                                            <td>
                                                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstReceivedFromName','All','lstReceivedFromNameChange',null,event)"
                                                                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                                    border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                                            <td>
                                                                                <input type='hidden' id='quickAdd_output'/>
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
                                                                <td width="48%" bgcolor="#FFFFFF" class="bodycopy">
                                                                </td>
                                                                <td width="50%" height="8" bgcolor="#FFFFFF" class="bodycopy">
                                                                </td>
                                                            </tr>
                                                            <tr align="left" valign="middle" bgcolor="#9e816e" class="bodycopy">
                                                                <td height="1" colspan="2">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="20" colspan="2" align="center" valign="middle" bgcolor="#f4e9e0" class="bodyheader">
                                                                    <span class="style8">
                                                                        <img src="/ASP/Images/required.gif" align="absbottom">FOR ACCOUNT OF (CUSTOMER)
                                                                    </span>
                                                                </td>
                                                            </tr>
                                                            <tr align="left" valign="middle" bgcolor="#9e816e" class="bodycopy">
                                                                <td height="1" colspan="2">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2" bgcolor="#FFFFFF" class="bodycopy">
                                                                    <span class="style15">Contact</span><br />
                                                                    <input name="txtAccountOfContact" id="txtAccountOfContact" type="text" class="shorttextfield" value="" style="width: 300px;" /></td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2" bgcolor="#FFFFFF" class="bodycopy">
                                                                    <!-- Start JPED -->
                                                                    <input type="hidden" id="hAccountOfAcct" name="hAccountOfAcct" />
                                                                    <div id="lstAccountOfNameDiv">
                                                                    </div>
                                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                                        <tr>
                                                                            <td>
                                                                                <input type="text" autocomplete="off" id="lstAccountOfName" name="lstAccountOfName"
                                                                                    value="" class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9;
                                                                                    border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;"
                                                                                    onkeyup="organizationFill(this,'','lstAccountOfChange',null,event)" onfocus="initializeJPEDField(this,event);" /></td>
                                                                            <td>
                                                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstAccountOfName','','lstAccountOfChange',null,event)"
                                                                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                                    border-left: 0px solid #7F9DB9; cursor: hand;" id="imgAccountOfButton" /></td>
                                                                            <td>
                                                                                <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                                    onclick="quickAddClient('hAccountOfAcct','lstAccountOfName','txtAccountOfInfo')"
                                                                                    id="imgAccountOfAddButton" /></td>
                                                                        </tr>
                                                                    </table>
                                                                    <textarea wrap="hard" id="txtAccountOfInfo" name="txtAccountOfInfo" class="multilinetextfield"
                                                                        cols="" rows="5" style="width: 300px"></textarea>
                                                                    <!-- End JPED -->
                                                                    <input type="hidden" id="hAccountOfInfoPDF" name="hAccountOfInfoPDF" />
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#FFFFFF" class="bodycopy">
                                                                </td>
                                                                <td height="8" bgcolor="#FFFFFF" class="bodycopy">
                                                                    <input type="hidden" name="txtReceivedFromContact"  id="txtReceivedFromContact" class="shorttextfield" style="width: 300px;" />
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="1" colspan="2" bgcolor="#9e816e">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="2" colspan="2" bgcolor="#ffffff">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="1" colspan="2" bgcolor="#9e816e">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="18" bgcolor="#F3F3F3" class="bodyheader">
                                                                    Customer Reference No.
                                                                </td>
                                                                <td height="18" bgcolor="#F3F3F3" class="bodycopy">
                                                                    <span class="bodyheader">P.O. No. </span>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#FFFFFF" class="bodycopy" style="height: 18px">
                                                                    <span class="bodyheader"><span class="bodylistheader">
                                                                        <input name="txtCustomerRefNo" id="txtCustomerRefNo" type="text" class="shorttextfield"
                                                                            maxlength="64" value="" size="32" style="width: 140px" />
                                                                    </span></span>
                                                                </td>
                                                                <td bgcolor="#FFFFFF" class="bodycopy" style="height: 18px">
                                                                    <span class="bodylistheader">
                                                                        <input name="txtPONO" id="txtPONO" type="text" class="shorttextfield" maxlength="64"
                                                                            value="" size="32" style="width: 140px" />
                                                                    </span>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="18" bgcolor="#F3F3F3" class="bodycopy">
                                                                    <span class="bodyheader">Contained Hazardous Goods</span></td>
                                                                <td bgcolor="#F3F3F3" class="bodyheader style9">
                                                                    Received Date
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="22" valign="top" bgcolor="#FFFFFF" class="bodycopy">
                                                                    <input type="hidden" name="hDangerGood" value="N" id="hDangerGood" />
                                                                    <input type="radio" name="chkDangerGood" value="Y" id="chkDangerGoodY" onclick="javascript:document.getElementById('chkDangerGoodN').checked = !(this.checked);
                                                                                        document.getElementById('hDangerGood').value = this.value;" />
                                                                    Yes &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                                    <input type="radio" name="chkDangerGood" value="N" id="chkDangerGoodN" <% if checkBlank(noValue,"")="" then response.write("checked") %>
                                                                        onclick="javascript:document.getElementById('chkDangerGoodY').checked = !(this.checked);
                                                                                        document.getElementById('hDangerGood').value = this.value;" />
                                                                    No
                                                                </td>
                                                                <td valign="top" bgcolor="#FFFFFF" class="bodycopy">
                                                                    <span class="bodylistheader">
                                                                        <input name="txtReceivedDate" id="txtReceivedDate" type="text" class="m_shorttextfield date"
                                                                            value="<%=Date() %>" size="32" style="width: 140px" preset="shortdate" />
                                                                    </span>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                        <!-- ends pickup and deliver -->
                                                    </td>
                                                    <td width="53%" valign="top" bgcolor="#FFFFFF">
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                                            <tr>
                                                                <td bgcolor="#f4e9e0">
                                                                    &nbsp;
                                                                </td>
                                                                <td width="41%" height="20" bgcolor="#f4e9e0">
                                                                    <span class="style10">Created</span></td>
                                                                <td width="57%" bgcolor="#f4e9e0">
                                                                    <span class="bodyheader style12 style9">Warehouse Receipt No.</span>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#FFFFFF">
                                                                    &nbsp;
                                                                </td>
                                                                <td height="18" bgcolor="#FFFFFF">
                                                                    <input name="txtUpdatedDate" type="text" class="m_shorttextfield date" value="<%=Date() %>"
                                                                        size="11" preset="shortdate" id="txtUpdatedDate" /></td>
                                                                <td bgcolor="#FFFFFF">
                                                                    <span class="bodyheader">
                                                                        <input name="txtWRNum" id="txtWRNum" type="text" class="readonlybold" value="" size="20"
                                                                            readonly="readonly" />
                                                                    </span>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="2" colspan="3" bgcolor="#9e816e">
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
                                                                                    border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Trucker','lstTruckerNameChange',null,event)"
                                                                                    onfocus="initializeJPEDField(this,event);" /></td>
                                                                            <td>
                                                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstTruckerName','Trucker','lstTruckerNameChange',null,event)"
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
                                                                    <span class="bodyheader">Carrier Reference No. / Bill of Lading No.</span></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#FFFFFF">
                                                                    &nbsp;
                                                                </td>
                                                                <td bgcolor="#FFFFFF">
                                                                    <input name="txtCarrierRefNo" id="txtCarrierRefNo" type="text" maxlength="64" class="shorttextfieldBold"
                                                                        value="" style="width: 140px" />
                                                                </td>
                                                                <td bgcolor="#FFFFFF">
                                                                    &nbsp;
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="2" colspan="3" bgcolor="#9e816e">
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
                                                                                <span class="bodyheader">INLAND FREIGHT </span>
                                                                            </td>
                                                                            <td width="73%" bgcolor="#FFFFFF">
                                                                                <span class="bodyheader">
                                                                                    <input type="hidden" name="hInlandChargeType" id="hkInlandChargeType" />
                                                                                    <input type="checkbox" name="chkInlandChargeType" value="P" id="chkInlandChargeTypeP"
                                                                                        onclick="javascript:document.getElementById('chkInlandChargeTypeC').checked = !(this.checked);
                                                                                        document.getElementById('hInlandChargeType').value = this.value;" />
                                                                                    PREPAID
                                                                                    <input type="checkbox" name="chkInlandChargeType" value="C" id="chkInlandChargeTypeC"
                                                                                        onclick="javascript:document.getElementById('chkInlandChargeTypeP').checked = !(this.checked);
                                                                                        document.getElementById('hInlandChargeType').value = this.value;" style="margin-left: 14px" />
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
                                                                                    <input type="text" class="bodyheader" name="txtInlandCharge" value="" style="behavior: url(../include/igNumDotChkLeft.htc);
                                                                                        margin-left: 4px" id="txtInlandCharge" />
                                                                                </span>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="1" colspan="3" bgcolor="#9e816e">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="2" colspan="3" bgcolor="#ffffff">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="1" colspan="3" bgcolor="#9e816e">
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
                                                                    <textarea name="txtHandling" id="txtHandling" wrap="hard" cols="50" rows="6" class="multilinetextfield"
                                                                        style="width: 300px"></textarea></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                </td>
                                                                <td height="15">
                                                                </td>
                                                                <td>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#f3f3f3">
                                                                    &nbsp;
                                                                </td>
                                                                <td height="18" bgcolor="#f3f3f3">
                                                                    <span class="bodyheader">Available Pickup Date </span>
                                                                </td>
                                                                <td bgcolor="#f3f3f3">
                                                                    <span class="bodyheader">Storage Start Date </span>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#FFFFFF">
                                                                    &nbsp;
                                                                </td>
                                                                <td height="18" bgcolor="#FFFFFF">
                                                                    <span class="bodylistheader">
                                                                        <input name="txtPickupDate" id="txtPickupDate" type="text" class="m_shorttextfield date"
                                                                            value="" style="width: 140px" preset="shortdate" />
                                                                    </span>
                                                                </td>
                                                                <td>
                                                                    <span class="bodylistheader">
                                                                        <input name="txtStorageDate" id="txtStorageDate" type="text" class="m_shorttextfield date"
                                                                            value="" size="32" style="width: 140px" preset="shortdate" />
                                                                    </span>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                            <table width="92%" border="0" cellpadding="2" cellspacing="0" bordercolor="#9e816e"
                                                class="border1px" style="padding-left: 6PX">
                                                <tr bgcolor="#f4e9e0"">
                                                    <td width="5%" height="19" bgcolor="#f4e9e0">
                                                        <span class="bodyheader">
                                                            <img src="/ASP/Images/required.gif" align="absbottom">QTY</span></td>
                                                    <td width="32%" align="left">
                                                        <span class="bodyheader">Descriptions</span></td>
                                                    <td width="15%">
                                                        <span class="bodyheader">Gross Weight</span></td>
                                                    <td width="24%">
                                                        <span class="bodyheader">Dimension</span></td>
                                                    <td width="24%" align="left" class="bodycopy">
                                                        <span class="bodyheader">Damage &amp; Exceptions</span></td>
                                                </tr>
                                                <tr>
                                                    <td align="left" valign="top" bgcolor="#FFFFFF">
                                                        <input name="txtItemPieces" id="txtItemPieces" type="text" class="txtunitbox" value=""
                                                            size="6" style="behavior: url(../include/igNumDotChkLeft.htc)" 
                                                            alt="txtItemPieces" /></td>
                                                    <td valign="top" bgcolor="#FFFFFF">
                                                        <textarea name="txtItemDesc" id="txtItemDesc"  cols="50" rows="7" class="multilinetextfield"
                                                            style="width: 265px"></textarea></td>
                                                    <td align="left" valign="top" bgcolor="#FFFFFF">
                                                        <input name="txtGrossWeight" type="text" class="txtunitbox" 
                                                            style="behavior: url(../include/igNumDotChkLeft.htc)" onkeydown="resetWeight();"
                                                            value="" size="10" id="txtGrossWeight" />
                                                        <select name="lstWeightScale" class="smallselect" onchange="convertKG_LB(0)" 
                                                            id="lstWeightScale">
                                                            <option value="LB">LB</option>
                                                            <option value="KG">KG</option>
                                                        </select>
                                                    </td>
                                                    <td valign="top" bgcolor="#FFFFFF">
                                                        <table cellpadding="0" cellspacing="0" border="0" class="bodycopy">
                                                            <tr>
                                                                <td>
                                                                    <textarea id="txtDimension" name="txtDimension" rows="7" cols="22" class="multilinetextfield"></textarea></td>
                                                                <td width="2px">
                                                                </td>
                                                                <td style="vertical-align: top">
                                                                    <select id="lstDimScale" name="lstDimScale" class="smallselect" onchange="convertCBM_CFT(0);">
                                                                        <option value="IN">INCH</option>
                                                                        <option value="CM">CM</option>
                                                                    </select>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                    <td valign="top" bgcolor="#FFFFFF">
                                                        <textarea name="txtDamageException" rows="7" class="multilinetextfield" style="width: 190px"
                                                            type="text" value="" id="txtDamageException"></textarea></td>
                                                </tr>
                                            </table>
                                            <br />
                                        </td>
                                    </tr>
                                    <tr align="center">
                                        <td height="1" valign="middle" bgcolor="#9e816e" class="bodycopy">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="24" bgcolor="#e5cfbf">
                                            <table width="98%" border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td width="26%" valign="middle">
                                                        &nbsp;
                                                    </td>
                                                    <td width="48%" align="center" valign="middle">
                                                        <img src="/ASP/images/button_save_medium.gif" width="46" height="18" name="bSave"
                                                            onclick="saveForm();" style="cursor: hand" /></td>
                                                    <td width="13%" align="right" valign="middle">
                                                        <a href="/ASP/WMS/warehouse_receipt.asp" target="_self">
                                                            <img src="/ASP/Images/button_new.gif" width="42" height="17" border="0"
                                                                style="cursor: hand"></a></td>
                                                    <td width="13%" align="right" valign="middle">
                                                        <img src="/ASP/images/button_delete_medium.gif" style="cursor: hand" onclick="deleteThis();"></td>
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
                    <div id="print" style="margin-bottom: 16px">
                        <img src="/ASP/Images/icon_printer.gif" align="absbottom">
                        <a href="javascript:;" onclick="viewPDF(); return false;" style="cursor: hand;">Warehouse
                            Receipt </a>
                    </div>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
<script type="text/javascript">


            <%  If reloadPage="Y" then %> 
            
            lstSearchNumChange('<%=vOrg%>','<%=vOrgN%>');
            <% end if%>
//            var SearchNum = getParameterByName('o');
//            alert(SearchNum);
//            var lstSearchNum = getParameterByName('n');
//            if (SearchNum != null && SearchNum != undefined && lstSearchNum != null && lstSearchNum != undefined)
//                lstSearchNumChange(SearchNum, lstSearchNum);

</script>
<!-- #INCLUDE VIRTUAL="/ASP/include/StatusFooter.asp" -->
