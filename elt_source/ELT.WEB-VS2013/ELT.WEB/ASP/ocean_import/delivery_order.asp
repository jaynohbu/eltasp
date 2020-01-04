<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/Header.asp" -->
<!--  #include file="../include/recent_file.asp" -->
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<!--  #INCLUDE FILE="../include/aspFunctions_import.inc" -->
<%
    Dim i,cargo_list
    
    Call GET_PORT_LIST()
    Call GET_CARGO_LIST()
    
    Sub GET_CARGO_LIST
        Dim rs,tempTable,SQL
        Set rs = Server.CreateObject("ADODB.Recordset")
        Set cargo_list = Server.CreateObject("System.Collections.ArrayList")
        
        Set tempTable = Server.CreateObject("System.Collections.HashTable")
        tempTable.Add "cargo_code", ""
        tempTable.Add "cargo_info", ""
        cargo_list.Add tempTable
        
        SQL= "select location,firm_code,phone,fax from freight_location where elt_account_number = " & elt_account_number & " order by location"
	    rs.CursorLocation = adUseClient
	    rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	    Set rs.activeConnection = Nothing
            
        Do While Not rs.EOF
            Set tempTable = Server.CreateObject("System.Collections.HashTable")
            tempTable.Add "cargo_code", rs("firm_code").value
            tempTable.Add "cargo_info", rs("firm_code").value & " - " & rs("location").value
            cargo_list.Add tempTable
	        rs.MoveNext
        Loop
        rs.Close
        Set rs=Nothing
    End Sub
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
     <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <title>Delivery Order</title>
    <style type="text/css">
        .style6 {color: #09609F}
        .style8 {color: #cc6600;
	        font-weight: bold;
        }
        body {
	        margin-left: 0px;
	        margin-right: 0px;
	        margin-bottom: 0px;
        }
        .style10 {color: #000000; font-weight: bold; }
        .style12 {color: #cc6600}
        .style13 {color: #000000}
        .style14 {color: #CC6600}
        .style15 {color: #00CCCC}
        .style16 {color: #999999}
        .style17 {color: #FF0000}
    </style>

    <script type="text/javascript" language="javascript" src="/ASP/ajaxFunctions/ajax.js"></script>

    <script type="text/javascript" language="javascript">

        var oInterval = ""; 
        var gross_weight="";
        var measure_value = "";

        function convertKG_LB(arg){
	        var scale,index;
	        
	        index = document.getElementsByName("lstScale1")[arg].selectedIndex;
	        scale = document.getElementsByName("lstScale1")[arg].options[index].value;
        	
	        if(gross_weight=="")
	        {
	            gross_weight = document.getElementsByName("txtGrossWt")[arg].value;
	        }
	        if(scale == "LB")
	        {
	            gross_weight = gross_weight * 2.2046226218488;
	        }
	        if(scale == "KG")
	        {
	            gross_weight = gross_weight / 2.2046226218488;
	        }
	        document.getElementsByName("txtGrossWt")[arg].value=gross_weight.toFixed(2);
        }

        function convertCBM_CFT(arg)
        {
	        var scale,index;
	        
	        index = document.getElementsByName("lstDimScale")[arg].selectedIndex;
	        scale = document.getElementsByName("lstDimScale")[arg].options[index].value;
	        measure = document.getElementsByName("txtDimension")[arg].value;
        	
        	if(measure_value=="")
        	{
        	    measure_value = document.getElementsByName("txtDimension")[arg].value;
        	}
	        if(scale == "CBM")
	        {
	            measure = measure / 35.314666721489;
	        }
	        if(scale == "CFT")
	        {
	            measure = measure * 35.314666721489;
	        }
	        document.getElementsByName("txtDimension")[arg].value=measure.toFixed(2);
        }
        
        function resetWeight(){
            gross_weight = "";
        }
        
        function resetMeasure(){
            measure_value = "";
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
    
        function selectSearchType()
        {
            var typeIndex = document.getElementById("lstSearchType").selectedIndex;
	        var typeValue = document.getElementById("lstSearchType").options[typeIndex].value;
	        
            if(typeValue == "none")
            {
                document.getElementById("txtFileName").style.visibility = "visible";
                document.getElementById("txtFileNameLabel").style.visibility = "visible";
                document.getElementById("txtMAWB").style.backgroundColor = "#ffffff";
                document.getElementById("txtMAWB").readOnly = false;
                document.getElementById("txtHAWB").style.backgroundColor = "#ffffff";
                document.getElementById("txtHAWB").readOnly = false;
            }
            else
            {
                document.getElementById("txtFileName").style.visibility = "hidden";
                document.getElementById("txtFileNameLabel").style.visibility = "hidden";
                document.getElementById("txtMAWB").style.backgroundColor = "#dddddd";
                document.getElementById("txtMAWB").readOnly = true;
                document.getElementById("txtHAWB").style.backgroundColor = "#dddddd";
                document.getElementById("txtHAWB").readOnly = true;
            }
            
            lstSearchNumChange(-1,'');
        }
		
        
        function displayScreen(req,field,tmpVal,tWidth,tMaxLength,url)
        {
            if (req.readyState == 4)
            {   
		        if (req.status == 200){
		            var xmlStr = req.responseText;
	                var parseXml;

	                if (window.DOMParser) {
	                    parseXml = function (xmlStr) {
	                        return (new window.DOMParser()).parseFromString(xmlStr, "text/xml");
	                    };
	                } else if (typeof window.ActiveXObject != "undefined" && new window.ActiveXObject("Microsoft.XMLDOM")) {
	                    parseXml = function (xmlStr) {
	                        var xmlDoc = new window.ActiveXObject("Microsoft.XMLDOM");
	                        xmlDoc.async = "false";
	                        xmlDoc.loadXML(xmlStr);
	                        return xmlDoc;
	                    };
	                } else {
	                    parseXml = function () { return null; }
	                }

	                var xml = parseXml(xmlStr);
	                var xmlObj = xml;

                    var mode = "";
                    if(xmlObj.getElementsByTagName("Search_Mode")[0] != null 
                        && xmlObj.getElementsByTagName("Search_Mode")[0].childNodes[0] != null){
                        mode = xmlObj.getElementsByTagName("Search_Mode")[0].childNodes[0].nodeValue;
                    }
                    
                    
                    setField("update_date","txtUpdateDate",xmlObj);
                    setField("ref_no_Our","txtRefNoOur",xmlObj);
                    setField("carrier_name","lstCarrierName",xmlObj);
                    setField("carrier_code","hCarrierCode",xmlObj);
                    setField("carrier_acct","hCarrierAcct",xmlObj);
                    setField("carrier_info","txtCarrierInfo",xmlObj);
                    setField("importer_name","lstImporterName",xmlObj);
                    setField("importer_acct","hImporterAcct",xmlObj);
                    setField("importer_info","txtImporterInfo",xmlObj);
                    setField("mawb_no","txtMAWB",xmlObj);
                    setField("hawb_no","txtHAWB",xmlObj);
                    setField("sec_num","hSecNum",xmlObj);

                    setField("sub_hawb_no","txtSubHAWB",xmlObj);
                    setField("entry_billing_no","txtEntryBilling",xmlObj);
                    setField("customer_ref_no","txtCustomerRef",xmlObj);
                    setField("eta","txtArrDate",xmlObj);
                    setField("etd","txtDepDate",xmlObj);
                    setField("free_date","txtFreeDate",xmlObj);

                    setSelectField("cargo_location","lstCargoLocation",xmlObj,4);
                    setSelectField("dep_port_code","lstDepPort",xmlObj);
                    setSelectField("arr_port_code","lstArrPort",xmlObj);
                    
                    setField("trucker_name","lstTruckerName",xmlObj);
                    setField("trucker_info","txtTruckerInfo",xmlObj);
                    setField("trucker_acct","hTruckerAcct",xmlObj);
                    setField("attention","txtAttention",xmlObj);
                    setField("consignee_acct","hConsigneeAcct",xmlObj);
                    setField("consignee_name","lstConsigneeName",xmlObj);
                    setField("consignee_info","txtConsigneeInfo",xmlObj);
                    
                    setField("delivery_ref_num","txtDeliveryRefNum",xmlObj);
                    
                    setField("pickup_acct","hPickupAcct",xmlObj);
                    setField("pickup_name","lstPickupName",xmlObj);
                    setField("pickup_info","txtPickupInfo",xmlObj);
                    
                    setField("route","txtRoute",xmlObj);
                    setField("handling","txtHandling",xmlObj);
                    setField("item_pieces","txtPieces",xmlObj);
                    setField("item_desc","txtDesc3",xmlObj);
                    
                    setSelectField("item_scale","lstScale1",xmlObj,1);
                    setField("item_gross_wt","txtGrossWt",xmlObj);
                    setSelectField("dimension_scale","lstDimScale",xmlObj,3);
                    setField("dimension","txtDimension",xmlObj);
                    
                    setField("inland_charge","txtInlandCharge",xmlObj);
                    setField("inland_charge_type","hInlandChargeType",xmlObj);
                    
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
                    setField("file_name","txtFileName",xmlObj);  

					// default values
					if(document.getElementById("txtEmployee").value == ""){
						document.getElementById("txtEmployee").value = "<%=GetUserFLName(user_id) %>";
					}

					if(document.getElementById("txtUpdateDate").value == ""){
						document.getElementById("txtUpdateDate").value = "<%=Date() %>";
					}
					
					// number format
					formatDouble("txtInlandCharge");
					formatDouble("txtGrossWt");
                }
		    }
        }

        function findSelectById(sName,hName)
        {
            oSelect = document.getElementById(sName);
            oHidden = document.getElementById(hName);
            
            oSelect.options.selectedIndex = 0;
            
            for(var i=0;i<oSelect.options.length;i++)
            {
                if(oSelect.options[i].value == oHidden.value)
                {
                    oSelect.options[i].selected = true;
                    break;
                }
            }
        }
        
        function formatDouble(fieldID){
            var tmpVal;
            try{
                if(document.getElementById(fieldID).value != ""){
                    tmpVal = parseFloat(document.getElementById(fieldID).value);
                    document.getElementById(fieldID).value = tmpVal.toFixed(2);
                }
            }catch(error){
                alert(error.message);
            }
        }

        function setField(xmlTag, htmlTag, xmlObj) {

            if ($("[name=" + htmlTag + "]")[0] != null && xmlObj.getElementsByTagName(xmlTag)[0] != null) {
                $("txtDesc3").value= xmlTag + ";" + xmlObj.getElementsByTagName(xmlTag)[0].textContent + "\r\n";
                document.getElementById(htmlTag).value = xmlObj.getElementsByTagName(xmlTag)[0].textContent;
            }
            else {
                if (document.getElementById(htmlTag) == null)
                    alert("error : " + htmlTag+" is null.");
                document.getElementById(htmlTag).value = "";
            }
           // document.write(test);
        }


        function setSelectField(xmlTag, htmlTag, xmlObj, compareLen) {
            var htmlObj = $("[name=" + htmlTag + "]");
            if (xmlObj.getElementsByTagName(xmlTag)[0] != null
                && xmlObj.getElementsByTagName(xmlTag)[0].childNodes[0] != null) {
                for (var i = 0; i < htmlObj.children(0).length; i++) {
                    if (htmlObj.children(0).get(i).value.substring(0, compareLen) == xmlObj.getElementsByTagName(xmlTag)[0].childNodes[0].nodeValue.substring(0, compareLen)) {
                        htmlObj.children(0).selectedIndex = i;
                    }
                }
            }
            else {
                htmlObj.selectedIndex = -1;
            }
        }
        
        function viewPDF(){
            var isDocBeingModified = document.getElementById("isDocBeingModified").value;
            var form = document.getElementById("form1");
            var noValue = document.getElementById("hSearchNum").value;
            var typeIndex = document.getElementById("lstSearchType").selectedIndex;
            var typeValue = document.getElementById("lstSearchType").options[typeIndex].value;
            var answer,question
            var isSaved = false;
            
            if(document.getElementById("lstSearchNum").value == ""){
                alert("Please, select billing number to view PDF");
		        return false;
            }
            
            if((isDocBeingModified > 0 && typeValue=="none") ||
                (isDocBeingModified > 0 && noValue != "" && noValue != "Select One"))
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
            
            form.action = "delivery_order_pdf.asp";
            form.method = "POST";
            form.target = "_self";
            form.submit();
        }
        
        function saveForm(){
            try{
                var querystring = "";
                var form = document.getElementById("form1");
                var noValue = document.getElementById("hSearchNum").value;
	            var typeIndex = document.getElementById("lstSearchType").selectedIndex;
	            var typeValue = document.getElementById("lstSearchType").options[typeIndex].value;
                var count = form.elements.length; 
                var url = "/ASP/ajaxFunctions/ajax_delivery_order.asp?mode=update&type=" + typeValue
                    + "&import=O&" + noValue;
                
                if(noValue == "" || noValue == null || noValue < 0)
                {
                    alert("Please, select AWB Type and No.");
                    return false;
                }

                if(document.getElementById("lstPickupName").value == "")
                {
                    alert("Please, select from 'Pickup From'");
                    return false;
                }
                
                if(document.getElementById("lstConsigneeName").value == "")
                {
                    alert("Please, select from 'Consignee'");
                    return false;
                }
                
                for(var i = 0; i < count; i++) {
                    if(form.elements[i].name != ""){
                        querystring += form.elements[i].name+"=";
                        if(i < count-1){ 
                            querystring += encodeURIComponent(form.elements[i].value) + "&";
                        }
                        else {
                            querystring += encodeURIComponent(form.elements[i].value); 
                        }
                    }
                }

                new ajax.xhr.Request('POST',querystring,encodeURI(url),afterUpdate,'','','','');
                document.getElementById("isDocBeingSubmitted").value = true;
            }catch(err){}
        }
        
        function afterUpdate(req,field,tmpVal,tWidth,tMaxLength,url){
            if (req.readyState == 4){
		        if (req.status == 200)
		        {
                    alert(req.responseText);
                    var searchType = document.getElementById("lstSearchType").value;
                    if(searchType == "none")
                    {
                        lstSearchNumChange("file=" + document.getElementById("txtFileName").value,document.getElementById("txtFileName").value);
                    }
                    else
                    {
                        lstSearchNumChange(document.getElementById("hSearchNum").value,document.getElementById("lstSearchNum").value);
                    }
		        }
		    }
        }
        
        function deleteThis(){
            var typeIndex = document.getElementById("lstSearchType").selectedIndex;
            var typeValue = document.getElementById("lstSearchType").options[typeIndex].value;
            var noValue = document.getElementById("hSearchNum").value;
            
            if(typeValue == "none" && noValue != "" && noValue != "Select One"){
                var answer = confirm("Please, click OK to delete this file.");
                if(!answer){
                    return false;
                }
                try{
                    var querystring = "";
                    var form = document.getElementById("form1");
                    
                    var url = "/ASP/ajaxFunctions/ajax_delivery_order.asp?mode=delete&type=" 
                        + typeValue + "&export=O&" + noValue;
                    
                    new ajax.xhr.Request('GET','',encodeURI(url),afterDelete,'','','','');
                    document.getElementById("isDocBeingSubmitted").value = true;
                }catch(err){}
            }
            else{
                alert("Please, select a anonymous file to delete.");
                return false;
            }
        }
        
        function afterDelete(req,field,tmpVal,tWidth,tMaxLength,url){
        
            if (req.readyState == 4){   
		        if (req.status == 200){
                    alert(req.responseText);
                    lstSearchNumChange(-1,'');
		        }
		    }
        }
        
		function chInlandChargeType_click(arg)
        {
            var inlandType = document.getElementById("hInlandChargeType");
            inlandType.value = arg;
        }
    </script>

    <script type="text/javascript" src="../include/JPED.js"></script>

    <script type="text/javascript">
        
        function searchNumFill(obj,iType,changeFunction,vHeight,event){
            var qStr = obj.value;
            var keyCode = event.keyCode;
            var url;
            var typeIndex = document.getElementById("lstSearchType").selectedIndex;
	        var typeValue = document.getElementById("lstSearchType").options[typeIndex].value;

            if(qStr != "" && keyCode != 229 && keyCode != 27){
                url = "/ASP/ajaxFunctions/ajax_delivery_order.asp?mode=list&import=" + iType 
                    + "&qStr=" + qStr + "&type=" + typeValue;
                
                FillOutJPED(obj,url,changeFunction,vHeight);
            }
        }
        
        function searchNumFillAll(objName,iType,changeFunction,vHeight){
            var obj = document.getElementById(objName);
            var typeIndex = document.getElementById("lstSearchType").selectedIndex;
	        var typeValue = document.getElementById("lstSearchType").options[typeIndex].value;
	        
            var url = "/ASP/ajaxFunctions/ajax_delivery_order.asp?mode=list&type=" + typeValue 
                + "&import=" + iType;

            FillOutJPED(obj,url,changeFunction,vHeight);
        }
        
// Start of list change effect //////////////////////////////////////////////////////////////////
        
        function lstConsigneeNameChange(orgNum,orgName){
            var hiddenObj = document.getElementById("hConsigneeAcct");
            var infoObj = document.getElementById("txtConsigneeInfo");
            var txtObj = document.getElementById("lstConsigneeName");
            var divObj = document.getElementById("lstConsigneeNameDiv");
    
            hiddenObj.value = orgNum;
            infoObj.value = getOrganizationInfo(orgNum,"B");
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
            divObj.style.height = "0px";
		    divObj.innerHTML = "";
		    docModified(1);
        }
        
        function lstCarrierNameChange(orgNum,orgName){
            var hiddenObj = document.getElementById("hCarrierAcct");
            var hiddenCodeObj = document.getElementById("hCarrierCode");
            var txtObj = document.getElementById("lstCarrierName");
            var divObj = document.getElementById("lstCarrierNameDiv");
            
            var temp = new Array();
            var tempStr = getOrganizationInfo(orgNum,"C")
            if(tempStr != null && tempStr != "")
            {
                temp = tempStr.split("-");
                hiddenCodeObj.value = temp[0];
            }
            
            hiddenObj.value = orgNum;
            
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
            divObj.style.height = "0px";
		    divObj.innerHTML = "";
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

        function lstSearchNumChange(argV,argL){
            var divObj = document.getElementById("lstSearchNumDiv");
            
            document.getElementById("isDocBeingSubmitted").value = false;
            document.getElementById("isDocBeingModified").value = 0;

	        var typeIndex = document.getElementById("lstSearchType").selectedIndex;
	        var typeValue = document.getElementById("lstSearchType").options[typeIndex].value;
	        
	        document.getElementById("lstSearchNum").value = argL;
            document.getElementById("hSearchNum").value = argV;
            
            var url = "/ASP/ajaxFunctions/ajax_delivery_order.asp?mode=view&type=" + typeValue
                + "&import=O&" + argV;
                
            new ajax.xhr.Request('GET','',encodeURI(url),displayScreen,'','','','');
            resetWeight();
            
            divObj.style.visibility = "hidden";
            divObj.style.position = "absolute";
            divObj.style.height = "0px";
		    divObj.innerHTML = "";
        }
        
        function lstPickupNameChange(orgNum,orgName){
            var hiddenObj = document.getElementById("hPickupAcct");
            var infoObj = document.getElementById("txtPickupInfo");
            var txtObj = document.getElementById("lstPickupName");
            var divObj = document.getElementById("lstPickupNameDiv");
    
            hiddenObj.value = orgNum;
            infoObj.value = getOrganizationInfo(orgNum,"B");
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
            divObj.style.height = "0px";
		    divObj.innerHTML = "";
		    docModified(1);
        }
        
        function lstImporterNameChange(orgNum,orgName){
            var hiddenObj = document.getElementById("hImporterAcct");
            var infoObj = document.getElementById("txtImporterInfo");
            var txtObj = document.getElementById("lstImporterName");
            var divObj = document.getElementById("lstImporterNameDiv");
    
            hiddenObj.value = orgNum;
            infoObj.value = getOrganizationInfo(orgNum,"B");
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
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
        
            xmlHTTP.open("GET",encodeURI(url),false); 
            xmlHTTP.send();
            
            return xmlHTTP.responseText; 
        }
 
// End of list change effect ///////////////////////////////////////////////////////////////////  
    </script>

</head>
<body onbeforeunload="navigateAway();" onLoad="selectSearchType(); ">
    <form id="form1" onKeyDown="docModified(1);">
        <input type="hidden" id="isDocBeingSubmitted" value="false" />
        <input type="hidden" id="isDocBeingModified" value="0" />
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td width="50%" align="left" valign="middle" class="pageheader">
                    Delivery order form</td>
                <td width="50%" align="right" valign="middle">&nbsp;</td>
            </tr>
        </table>
        <div class="selectarea">
            <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                    <td height="15" valign="top"><span class="select">Select AWB Type and No.</span></td>
                    <td width="36%" rowspan="2" align="right" valign="bottom"><div id="print"> <img src="/ASP/Images/icon_printer.gif" align="absbottom"><a href="javascript:;"
                            onclick="viewPDF(); return false;" style="cursor: hand;">Delivery Order Form</a> </div></td>
                </tr>
                <tr>
                    <td width="64%" valign="bottom"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td><span class="bodyheader">
                                    <select id="lstSearchType" style="width: 115px" class="bodyheader" onChange="selectSearchType();">
                                        <option value="house" selected="selected">HOUSE AWB No.</option>
                                        <option value="master">MASTER AWB No.</option>
                                        <!-- <option value="none">ANONYMOUS</option> -->
                                    </select>
                                </span></td>
                                <td>&nbsp;</td>
                                <td width="84%"><!-- Start JPED -->
                                                        <input type="hidden" id="hSearchNum" name="hSearchNum" />
                                                        <div id="lstSearchNumDiv">
                                                        </div>
                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                            <tr>
                                                                <td><input type="text" autocomplete="off" id="lstSearchNum" name="lstSearchNum" value=""
                                                                        class="shorttextfield" style="width: 200px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                        border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onKeyUp="docModified(-1); searchNumFill(this,'O','lstSearchNumChange',200,event);"
                                                                        onFocus="initializeJPEDField(this,event);" /></td>
                                                                <td>
                                                                    <img src="/ig_common/Images/combobox_drop.gif" alt="" onClick="searchNumFillAll('lstSearchNum','O','lstSearchNumChange',200,event);"
                                                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                        border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                            </tr>
                                                        </table>
                                                        <!-- End JPED --></td>
                            </tr>
                    </table></td>
                </tr>
            </table>
        </div>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#909EB0"
            bgcolor="#909EB0" class="border1px">
            <tr bordercolor="#909EB0" class="border1px">
                <td>
                    <input type="hidden" name="hIType" id="hIType" value="A" />
                    <input type="hidden" name="did" id="did" value="" />
                    <input type="hidden" name="hSecNum"  id="hSecNum" value="" />
                    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" bordrcolor="#909EB0"
                        bgcolor="#909EB0">
                        <tr bordercolor="#909EB0">
                            <td>
                                <table width="100%" border="0" cellpadding="2" cellspacing="0" bordercolor="#909EB0">
                                    <tr bgcolor="#CFD6DF">
                                        <td height="22" align="center" valign="middle" class="bodyheader">
                                            <table width="98%" border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td width="26%">&nbsp;
                                                        
                                                    </td>
                                                    <td width="48%" align="center" valign="middle">
                                                        <img src="../images/button_save_medium.gif" width="46" height="18" name="bSave" onClick="saveForm();"
                                                            style="cursor: hand" /></td>
                                                    <td width="13%" align="right" valign="middle">
                                                        <!-- <a href="/ASP/air_import/delivery_order.asp">
                                                            <img src="/ASP/Images/button_new.gif" border="0" style="cursor: hand"></a> -->
                                                            </td>
                                                    <td width="13%" align="right" valign="middle">
                                                        <!--<img src="../images/button_delete_medium.gif" style="cursor: hand" onClick="deleteThis();">--></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="9" bgcolor="#909EB0">
                                        </td>
                                    </tr>
                                    <tr align="center">
                                        <td valign="middle" bgcolor="#f3f3f3" class="bodycopy">
                                            <br>
                                            <br />
                                            <table class="bodycopy" width="86%" border="0" align="center" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td width="57%" height="28" align="left" valign="middle"><label id="txtFileNameLabel"> <strong><span class="bodyheader"><img src="/ASP/Images/required.gif" align="absmiddle"></span>File Name&nbsp;<span class="bodyheader style6 style12">
                                                    <input type="text" id="txtFileName" name="txtFileName" size="32" class="bodyheader"
                                                            value="" />
                                                    </span></strong></label></td>
                                                    <td width="43%" align="right" valign="middle"><span class="bodyheader"><img src="/ASP/Images/required.gif" align="absbottom">Required field</span></td>
                                                </tr>
                                            </table>
                                            <table width="86%" border="0" cellpadding="0" cellspacing="0" bordercolor="#909EB0"
                                                class="border1px">
                                                <tr align="left" valign="middle" bgcolor="#DFE1E6" class="bodycopy">
                                                    <td width="52%" colspan="3" valign="top" bgcolor="#f3f3f3">
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="border-right: #909EB0 solid 1px">
                                                            <tr>
                                                                <td width="2%" bgcolor="#DFE1E6">&nbsp;                                                                </td>
                                                                <td height="20" colspan="2" align="center" valign="middle" bgcolor="#DFE1E6" class="bodyheader style14">
                                                                    PICKUP FROM </td>
                                                            </tr>
                                                            <tr align="left" valign="middle" bgcolor="#909EB0" class="bodycopy">
                                                                <td height="1" colspan="3">                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#f3f3f3">&nbsp;                                                                    </td>
                                                                <td width="78%" height="18" bgcolor="#f3f3f3" class="bodyheader">
                                                                    <img src="/ASP/Images/required.gif" align="absbottom">Pickup From                                                                </td>
                                                                <td width="20%" bgcolor="#f3f3f3">&nbsp;                                                                    </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#FFFFFF">&nbsp;                                                                    </td>
                                                                <td colspan="2" bgcolor="#FFFFFF" class="bodycopy">
                                                                    <!-- Start JPED -->
                                                                    <input type="hidden" id="hPickupAcct" name="hPickupAcct" />
                                                                    <div id="lstPickupNameDiv">                                                                    </div>
                                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                                        <tr>
                                                                            <td>
                                                                                <input type="text" autocomplete="off" id="lstPickupName" name="lstPickupName" value=""
                                                                                    class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                                    border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onKeyUp="organizationFill(this,'CarrierWarehouse','lstPickupNameChange',null,event)"
                                                                                    onfocus="initializeJPEDField(this,event);" /></td>
                                                                            <td>
                                                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onClick="organizationFillAll('lstPickupName','CarrierWarehouse','lstPickupNameChange',null,event)"
                                                                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                                    border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                                            <td>
                                                                                <input type='hidden' id='quickAdd_output'/>
                                                                                <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                                    onclick="quickAddClient('hPickupAcct','lstPickupName','txtPickupInfo')" /></td>
                                                                        </tr>
                                                                    </table>
                                                                    <textarea id="txtPickupInfo" name="txtPickupInfo" class="monotextarea" cols="" rows="5"
                                                                        style="width: 300px"></textarea>
                                                                    <!-- End JPED -->                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="8" bgcolor="#FFFFFF">                                                                </td>
                                                                <td height="8" valign="top" bgcolor="#FFFFFF" class="bodycopy">                                                                </td>
                                                                <td height="8" valign="top" bgcolor="#FFFFFF">                                                                </td>
                                                            </tr>
                                                            <tr align="left" valign="middle" bgcolor="#909EB0" class="bodycopy">
                                                                <td height="1" colspan="3">                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td width="2%" bgcolor="#DFE1E6">&nbsp;                                                                </td>
                                                                <td height="20" colspan="2" align="center" valign="middle" bgcolor="#DFE1E6" class="bodyheader style14">
                                                                    DELIVERY TO                                                               </td>
                                                            </tr>
                                                            <tr align="left" valign="middle" bgcolor="#909EB0" class="bodycopy">
                                                                <td height="1" colspan="3">                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#f3f3f3">&nbsp;                                                                    </td>
                                                                <td height="18" bgcolor="#f3f3f3" class="bodyheader">
                                                                    <img src="/ASP/Images/required.gif" align="absbottom">Consignee                                                                </td>
                                                                <td bgcolor="#f3f3f3">&nbsp;                                                                    </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#FFFFFF">&nbsp;                                                                    </td>
                                                                <td colspan="2" bgcolor="#FFFFFF" class="bodycopy">
                                                                    <span class="style16">Attention To<br>
                                                                    </span>
                                                                    <input name="txtAttention" type="text" class="shorttextfield" style="width: 300px"
                                                                        value="" size="51" id="txtAttention" />
                                                                    <input type="hidden" id="hConsigneeAcct" name="hConsigneeAcct" /></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#FFFFFF">&nbsp;                                                                    </td>
                                                                <td colspan="2" bgcolor="#FFFFFF">
                                                                    <!-- Start JPED -->
                                                                    <input type="hidden" id="hConsigneeAcct" name="hConsigneeAcct" />
                                                                    <div id="lstConsigneeNameDiv">                                                                    </div>
                                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                                        <tr>
                                                                            <td>
                                                                                <input type="text" autocomplete="off" id="lstConsigneeName" name="lstConsigneeName"
                                                                                    value="" class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9;
                                                                                    border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;"
                                                                                    onkeyup="organizationFill(this,'Consignee','lstConsigneeNameChange',null,event)" onFocus="initializeJPEDField(this,event);" /></td>
                                                                            <td>
                                                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onClick="organizationFillAll('lstConsigneeName','Consignee','lstConsigneeNameChange',null,event)"
                                                                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                                    border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                                            <td>
                                                                                <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                                    onclick="quickAddClient('hConsigneeAcct','lstConsigneeName','txtConsigneeInfo')" /></td>
                                                                        </tr>
                                                                    </table>
                                                                    <textarea id="txtConsigneeInfo" name="txtConsigneeInfo" class="monotextarea" cols=""
                                                                        rows="5" style="width: 300px"></textarea>
                                                                    <!-- End JPED -->                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="8" colspan="3" bgcolor="#FFFFFF">                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="1" colspan="3" bgcolor="#909EB0">                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="2" colspan="3" bgcolor="#ffffff">                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="1" colspan="3" bgcolor="#909EB0">                                                                </td>
                                                            </tr>
                                                            
                                                            <tr>
                                                                <td height="8" bgcolor="#f3f3f3"></td>
                                                                <td height="18" colspan="2" bgcolor="#f3f3f3"><span class="bodyheader">Handling Info.</span></td>
                                                            </tr>
                                                            <tr>
                                                                <td height="8" bgcolor="#FFFFFF"></td>
                                                                <td colspan="2" bgcolor="#FFFFFF"><textarea name="txtHandling" wrap="hard" 
                                                                        cols="50" rows="3" style="width: 280px"
                                                                        class="multilinetextfield" id="txtHandling"></textarea></td>
                                                            </tr>
                                                            <tr>
                                                                <td height="8" bgcolor="#f3f3f3"></td>
                                                                <td height="18" colspan="2" bgcolor="#f3f3f3"><span class="bodylistheader">Route</span></td>
                                                            </tr>
                                                            <tr>
                                                                <td height="8" bgcolor="#FFFFFF"></td>
                                                                <td colspan="2" bgcolor="#FFFFFF"><textarea name="txtRoute" wrap="hard" id="txtRoute" cols="50" rows="5" style="width: 280px"
                                                                        class="multilinetextfield"></textarea></td>
                                                            </tr>
                                                            <tr>
                                                                <td height="8" bgcolor="#FFFFFF"></td>
                                                                <td height="87" colspan="2" bgcolor="#FFFFFF">&nbsp;</td>
                                                            </tr>
                                                        </table>                                                    </td>
                                                    <td width="48%" valign="top" bgcolor="#FFFFFF" class="bodycopy">
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                                            <tr>
                                                                <td width="2%" bgcolor="#DFE1E6">&nbsp;                                                                    </td>
                                                                <td height="20" align="center" valign="middle" bgcolor="#DFE1E6" class="bodyheader style14">&nbsp;                                                                    </td>
                                                                <td bgcolor="#DFE1E6">                                                                </td>
                                                            </tr>
                                                            <tr align="left" valign="middle" bgcolor="#909EB0" class="bodycopy">
                                                                <td height="1" colspan="3">                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#f3f3f3">&nbsp;                                                                    </td>
                                                                <td height="18" bgcolor="#f3f3f3">
                                                                    <span class="style10">Date</span></td>
                                                                <td bgcolor="#f3f3f3" class="bodyheader">
                                                                    Our Reference No.</td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#FFFFFF">&nbsp;                                                                    </td>
                                                                <td bgcolor="#FFFFFF">
                                                                    <input name="txtUpdateDate" id="txtUpdateDate" type="text" class="m_shorttextfield " value="<%=Date() %>"
                                                                        size="16" preset="shortdate" /></td>
                                                                <td bgcolor="#FFFFFF">
                                                                    <input name="txtRefNoOur"  type="text" class="m_shorttextfield" maxlength="32" 
                                                                        value="" style="width: 140px" id="txtRefNoOur" /></td>
                                                            </tr>
                                                            <tr>
                                                                <td height="2" colspan="3" bgcolor="#909EB0">                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#f3f3f3">&nbsp;                                                                    </td>
                                                                <td height="18" colspan="2" bgcolor="#f3f3f3" class="bodycopy">
                                                                    <span class="bodyheader">Local Delivery or Transfer by</span> (Delivery Order Issued
                                                                    To)</td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#FFFFFF">&nbsp;                                                                    </td>
                                                                <td colspan="2" bgcolor="#FFFFFF">
                                                                    <!-- Start JPED -->
                                                                    <input type="hidden" id="hTruckerAcct" name="hTruckerAcct" />
                                                                    <div id="lstTruckerNameDiv">                                                                    </div>
                                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                                        <tr>
                                                                            <td>
                                                                                <input type="text" autocomplete="off" id="lstTruckerName" name="lstTruckerName" value=""
                                                                                    class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                                    border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onKeyUp="organizationFill(this,'Trucker','lstTruckerNameChange',null,event)"
                                                                                    onfocus="initializeJPEDField(this,event);" /></td>
                                                                            <td>
                                                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onClick="organizationFillAll('lstTruckerName','Trucker','lstTruckerNameChange',null,event)"
                                                                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                                    border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                                            <td>
                                                                                <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                                    onclick="quickAddClient('hTruckerAcct','lstTruckerName')" /></td>
                                                                        </tr>
                                                                    </table>
                                                                    <textarea wrap="hard" id="txtTruckerInfo" name="txtTruckerInfo" class="multilinetextfield"
                                                                        cols="" rows="2" style="width: 300px"></textarea>
                                                                    <!-- End JPED -->                                                               </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#f3f3f3">&nbsp;                                                                    </td>
                                                                <td height="18" colspan="2" bgcolor="#f3f3f3">
                                                                    <span class="bodyheader">Local Delivery or Transfer Reference No. </span>                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#FFFFFF">&nbsp;                                                                    </td>
                                                                <td colspan="2" bgcolor="#FFFFFF">
                                                                    <input name="txtDeliveryRefNum" id="txtDeliveryRefNum" type="text" class="shorttextfieldBold"
                                                                        value="" style="width: 140px" />                                                                </td>
                                                            </tr>
															<tr>
                                                                <td height="8px" colspan="3"></td>
                                                            </tr>
                                                            <tr>
                                                                <td height="2" colspan="3" bgcolor="#909EB0">                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#f3f3f3">&nbsp;                                                                    </td>
                                                                <td height="18" bgcolor="#f3f3f3">
                                                                    <span class="style8">Master B/L No.</span></td>
                                                                <td bgcolor="#f3f3f3">
                                                                    <span class="style8">House B/L No.</span></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#FFFFFF">&nbsp;                                                                    </td>
                                                                <td bgcolor="#FFFFFF">
                                                                    <input name="txtMAWB" id="txtMAWB" type="text" class="shorttextfieldBold" value="" style="width: 140px" /></td>
                                                                <td bgcolor="#FFFFFF">
                                                                    <input name="txtHAWB" id="txtHAWB" type="text" class="shorttextfieldBold" value="" style="width: 140px" /></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#f3f3f3">&nbsp;                                                                    </td>
                                                                <td height="18" bgcolor="#f3f3f3">
                                                                    <span class="bodylistheader"><strong>Entry-B/L No.</strong></span></td>
                                                                <td bgcolor="#f3f3f3">
                                                                    <span class="bodylistheader"><strong>Sub B/L No.</strong></span></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#FFFFFF">&nbsp;                                                                    </td>
                                                                <td bgcolor="#FFFFFF">
                                                                    <span class="bodylistheader">
                                                                        <input name="txtEntryBilling" type="text" maxlength="32" 
                                                                        class="shorttextfield" value="" style="width: 140px" id="txtEntryBilling" />
                                                                    </span>                                                                </td>
                                                                <td bgcolor="#FFFFFF">
                                                                    <span class="bodylistheader">
                                                                        <input name="txtSubHAWB" type="text" maxlength="32" class="shorttextfield" 
                                                                        value="" style="width: 140px" id="txtSubHAWB" />
                                                                    </span>                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#f3f3f3">&nbsp;                                                                    </td>
                                                                <td height="18" bgcolor="#f3f3f3" class="bodyheader">
                                                                    Arrival Date</td>
                                                                <td bgcolor="#f3f3f3">
                                                                    <strong>Last Free Day</strong></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#FFFFFF">&nbsp;                                                                    </td>
                                                                <td bgcolor="#FFFFFF">
                                                                    <input name="txtArrDate" type="text" class="m_shorttextfield " value="" size="16"
                                                                        preset="shortdate" id="txtArrDate" />
                                                                    <input name="txtDepDate" id="txtDepDate" type="hidden" class="m_shorttextfield " value="" size="16"
                                                                        preset="shortdate" />                                                                </td>
                                                                <td bgcolor="#FFFFFF">
                                                                    <input name="txtFreeDate" type="text" class="m_shorttextfield " value="" size="16"
                                                                        preset="shortdate" id="txtFreeDate" /></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#f3f3f3">&nbsp;                                                                    </td>
                                                                <td height="18" bgcolor="#f3f3f3">
                                                                    <span class="bodylistheader">Origin Port </span>                                                                </td>
                                                                <td bgcolor="#f3f3f3">
                                                                    <span class="bodylistheader">Destination Port</span></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#FFFFFF">&nbsp;                                                                    </td>
                                                                <td bgcolor="#FFFFFF">
                                                                    <span class="bodylistheader">
                                                                        <input name="hDepPortCode" id="hDepPortCode" type="hidden" />
                                                                        <select id="lstDepPort" name="lstDepPort" class="smallselect" onChange="javascript:document.getElementById('hDepPortCode').value = this.value; ">
                                                                            <% For i=0 To port_list.Count-1 %>
                                                                            <option value="<%=port_list(i)("port_code") %>">
                                                                                <%=port_list(i)("port_desc") %>                                                                            </option>
                                                                            <% Next %>
                                                                        </select>
                                                                    </span>                                                                </td>
                                                                <td bgcolor="#FFFFFF">
                                                                    <span class="bodylistheader">
                                                                        <input name="hArrPortCode" id="hArrPortCode" type="hidden" />
                                                                        <select id="lstArrPort" name="lstArrPort" class="smallselect" onChange="javascript:document.getElementById('hArrPortCode').value = this.value; ">
                                                                            <% For i=0 To port_list.Count-1 %>
                                                                            <option value="<%=port_list(i)("port_code") %>">
                                                                                <%=port_list(i)("port_desc") %>                                                                            </option>
                                                                            <% Next %>
                                                                        </select>
                                                                    </span>                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#f3f3f3">&nbsp;                                                                    </td>
                                                                <td height="18" colspan="2" bgcolor="#f3f3f3" class="bodyheader">
                                                                    Carrier</td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#FFFFFF">&nbsp;                                                                    </td>
                                                                <td colspan="2" bgcolor="#FFFFFF">
                                                                    <!-- Start JPED -->
                                                                    <input type="hidden" id="hCarrierCode" name="hCarrierCode" />
                                                                    <input type="hidden" id="hCarrierAcct" name="hCarrierAcct" />
                                                                    <div id="lstCarrierNameDiv">                                                                    </div>
                                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                                        <tr>
                                                                            <td>
                                                                                <input type="text" autocomplete="off" id="lstCarrierName" name="lstCarrierName" value=""
                                                                                    class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                                    border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onKeyUp="organizationFill(this,'Carrier','lstCarrierNameChange',null,event)"
                                                                                    onfocus="initializeJPEDField(this,event);" /></td>
                                                                            <td>
                                                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onClick="organizationFillAll('lstCarrierName','Carrier','lstCarrierNameChange',null,event)"
                                                                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                                    border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                                            <td>
                                                                                <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                                    onclick="quickAddClient('hCarrierAcct','lstCarrierName','txtCarrierInfo')" /></td>
                                                                        </tr>
                                                                    </table>
                                                                    <input type="hidden" id="txtCarrierInfo" name="txtCarrierInfo" class="monotextarea"
                                                                        cols="" />
                                                                    <!-- End JPED -->                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#f3f3f3">&nbsp;                                                                    </td>
                                                                <td height="18" colspan="2" bgcolor="#f3f3f3" class="bodyheader">
                                                                    Cargo Location                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#FFFFFF">&nbsp;                                                                    </td>
                                                                <td colspan="2">
                                                                    <select id="lstCargoLocation" name="lstCargoLocation" class="smallselect">
                                                                        <% For i=0 To cargo_list.Count-1 %>
                                                                        <option value="<%=cargo_list(i)("cargo_code") %>">
                                                                            <%= cargo_list(i)("cargo_info")%>                                                                        </option>
                                                                        <% Next %>
                                                                    </select>                                                                </td>
                                                            </tr>
															<tr>
                                                                <td height="8px" colspan="3"></td>
                                                            </tr>
															<tr>
                                                                <td height="1" colspan="3" bgcolor="#909EB0">                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#f3f3f3">&nbsp;                                                                </td>
                                                                <td height="18" bgcolor="#f3f3f3" class="bodyheader">Importer</td>
                                                                <td bgcolor="#f3f3f3">&nbsp;                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#FFFFFF">&nbsp;                                                                </td>
                                                                <td colspan="2" bgcolor="#FFFFFF"><!-- Start JPED -->
                                                                    <input type="hidden" id="hImporterAcct" name="hImporterAcct" />
                                                                    <div id="lstImporterNameDiv">                                                                    </div>
                                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                                        <tr>
                                                                            <td>
                                                                                <input type="text" autocomplete="off" id="lstImporterName" name="lstImporterName"
                                                                                    value="" class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9;
                                                                                    border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;"
                                                                                    onkeyup="organizationFill(this,'Importer','lstImporterNameChange',null,event)" onFocus="initializeJPEDField(this,event);" /></td>
                                                                            <td>
                                                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onClick="organizationFillAll('lstImporterName','Cosignee','lstImporterNameChange',null,event)"
                                                                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                                    border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                                            <td>
                                                                                <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                                    onclick="quickAddClient('hImporterAcct','lstImporterName','txtImporterInfo')" /></td>
                                                                        </tr>
                                                                    </table>
                                                                    <textarea id="txtImporterInfo" name="txtImporterInfo" class="monotextarea" cols=""
                                                                        rows="5" style="width: 300px"></textarea>
                                                                    <!-- End JPED --></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#f3f3f3">&nbsp;                                                                </td>
                                                                <td height="18" bgcolor="#f3f3f3"><span class="bodyheader">Customer Reference No. </span></td>
                                                                <td bgcolor="#f3f3f3">&nbsp;                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#FFFFFF">&nbsp;                                                                </td>
                                                                <td colspan="2" bgcolor="#FFFFFF"><span class="bodylistheader">
                                                                    <input name="txtCustomerRef" type="text" maxlength="32" class="shorttextfield" 
                                                                        value="" style="width: 140px" id="txtCustomerRef" />
                                                                </span></td>
                                                            </tr>
															<tr>
                                                                <td height="8px" colspan="3"></td>
                                                            </tr>
                                                        </table>                                                    </td>
                                                </tr>
                                            </table>
                                            <table width="86%" border="0" cellpadding="2" cellspacing="0" bordercolor="#909EB0"
                                                class="border1px">
                                                <tr bgcolor="#DFE1E6">
                                                    <td width="1%" height="19">&nbsp;
                                                        
                                                    </td>
                                                    <td width="14%">
                                                        <strong>No. of Packages</strong></td>
                                                    <td>
                                                        <strong>Description of Articles, Special Marks &amp; Exceptions </strong>
                                                    </td>
                                                    <td width="19%">
                                                        <strong>Gross Weight</strong></td>
                                                    <td width="21%" class="bodyheader">
                                                        Dimension</td>
                                                </tr>
                                                <tr>
                                                    <td bgcolor="#FFFFFF">&nbsp;
                                                        
                                                    </td>
                                                    <td align="left" valign="top" bgcolor="#FFFFFF">
                                                        <textarea name="txtPieces" wrap="hard" cols="16" rows="7" 
                                                            class="multilinetextfield" id="txtPieces"></textarea></td>
                                                    <td valign="top" bgcolor="#FFFFFF">
                                                        <textarea name="txtDesc3" wrap="hard" cols="50" rows="7" class="multilinetextfield"
                                                            style="width: 350px" id="txtDesc3"></textarea></td>
                                                    <td align="left" valign="top" bgcolor="#FFFFFF">
                                                        <select id="lstScale1" name="lstScale1" class="smallselect" onChange="convertKG_LB(0)">
                                                            <option value="KG">KG</option>
                                                            <option value="LB">LB</option>
                                                        </select>
                                                        <input name="txtGrossWt" type="text" class="shorttextfield" 
                                                            style="behavior: url(../include/igNumDotChkLeft.htc)" onkeydown="resetWeight()"
                                                            value="" size="13" id="txtGrossWt" /></td>
                                                    <td align="left" valign="top" bgcolor="#FFFFFF">
                                                    <select id="lstDimScale" name="lstDimScale" class="smallselect" onChange="convertCBM_CFT(0)">
                                                        <option value="CBM">CBM</option>
                                                        <option value="CFT">CFT</option>
                                                    </select>
                                                    <input id="txtDimension" name="txtDimension" type="text" size="13" class="shorttextfield" style="behavior: url(../include/igNumDotChkLeft.htc)" onkeydown="resetMeasure()" /></td>
                                                </tr>
                                                <tr>
                                                    <td height="8" bgcolor="#FFFFFF">
                                                    </td>
                                                    <td height="8" align="left" valign="top" bgcolor="#FFFFFF">
                                                    </td>
                                                    <td height="8" valign="top" bgcolor="#FFFFFF">
                                                    </td>
                                                    <td height="8" align="left" valign="top" bgcolor="#FFFFFF">
                                                    </td>
                                                    <td align="left" valign="top" bgcolor="#FFFFFF">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td height="1" colspan="5" bgcolor="#909EB0">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td height="1" colspan="5" bgcolor="#ffffff">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td height="1" colspan="5" bgcolor="#909EB0">
                                                    </td>
                                                </tr>
                                                <tr bgcolor="#FFFFFF">
                                                    <td height="19">&nbsp;
                                                        
                                                    </td>
                                                    <td align="left" valign="top">&nbsp;
                                                        
                                                    </td>
                                                    <td align="right">
                                                        <span class="style8"><span class="bodyheader style13">INLAND FREIGHT </span>&nbsp;</span></td>
                                                    <td colspan="2" align="left" valign="top">
                                                        <input type="radio" name="chInlandChargeType" value="P" 
                                                            onClick="chInlandChargeType_click('P');" id="chInlandChargeType" />
                                                        PREPAID &nbsp;
                                                        <input type="radio" name="chInlandChargeType" value="C" onClick="chInlandChargeType_click('C');" />
                                                        COLLECT<input type="hidden" id="hInlandChargeType" name="hInlandChargeType" value="" /></td>
                                                </tr>
                                                <tr>
                                                    <td height="1" colspan="5" bgcolor="#909EB0">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td height="19" bgcolor="#DFE1E6">&nbsp;
                                                        
                                                    </td>
                                                    <td align="left" valign="top" bgcolor="#DFE1E6">&nbsp;
                                                        
                                                    </td>
                                                    <td width="45%" align="right" bgcolor="#DFE1E6">
                                                        <span class="style8"><span class="bodyheader style12">COD AMOUNT</span>&nbsp;&nbsp;</span></td>
                                                    <td colspan="2" align="left" valign="top" bgcolor="#DFE1E6">
                                                        <input type="text" class="bodyheader" name="txtInlandCharge" value="" 
                                                            style="behavior: url(../include/igNumDotChkLeft.htc)" id="txtInlandCharge" />
                                                        &nbsp;&nbsp;&nbsp;</td>
                                                </tr>
                                            </table>
                                            <br>
                                            <table width="86%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                    <td height="30" align="right" valign="middle">
                                                        <span class="bodyheader">PER</span>
                                                        <input name="txtEmployee"  id="txtEmployee" type="text" class="shorttextfield" value="<%=GetUserFLName(user_id) %>"
                                                            size="32" /></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr align="center">
                                        <td height="1" valign="middle" bgcolor="#909EB0" class="bodycopy">
                                        </td>
                                    </tr>
                                    <tr align="center">
                                        <td height="8" valign="middle" bgcolor="#CFD6DF" class="bodycopy">
                                            <table width="98%" border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td width="26%">&nbsp;
                                                        
                                                    </td>
                                                    <td width="48%" align="center" valign="middle">
                                                        <img src="../images/button_save_medium.gif" width="46" height="18" name="bSave" onClick="saveForm();"
                                                            style="cursor: hand" /></td>
                                                    <td width="13%" align="right" valign="middle">
                                                        <!--
                                                        <a href="/ASP/air_import/delivery_order.asp">
                                                            <img src="/ASP/Images/button_new.gif" border="0" style="cursor: hand"></a>
                                                        -->
                                                        </td>
                                                    <td width="13%" align="right" valign="middle">
                                                        <!--<img src="../images/button_delete_medium.gif" style="cursor: hand" onClick="deleteThis();">--></td>
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
                    <div id="print" class="bodycopy">
                        <img src="/ASP/Images/icon_printer.gif" align="absbottom"><b style="cursor: hand;"
                            class="bodycopy" onClick="viewPDF();">Delivery Order Form</b>
                    </div>
                </td>
            </tr>
        </table>
        <br>
    </form>
</body>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
