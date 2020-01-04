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
    Dim i,employee_name
    employee_name = GetUserFLName(user_id)
    Call GET_PORT_LIST()
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <title>DOCK RECEIPT</title>

    <script type="text/javascript" language="javascript" src="../ajaxFunctions/ajax.js"></script>


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
                    
                    parent.document.frames['topFrame'].location = "/IFF_MAIN/ASP/tabs/tab_maker.asp?mode=back&page=" 
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
		                
                        if(xmlObj.getElementsByTagName("auto_uid")[0] != null 
                            && xmlObj.getElementsByTagName("auto_uid")[0].childNodes[0] != null)
                        {
                            
                            setField("dock_no","txtDRNum",xmlObj);
                            
                            setField("shipper_acct","hShipperAcct",xmlObj);
                            setField("shipper_name","lstShipperName",xmlObj);
                            setField("shipper_info","txtShipperInfo",xmlObj);
                            
                            setField("consignee_acct","hConsigneeAcct",xmlObj);
                            setField("consignee_name","lstConsigneeName",xmlObj);
                            setField("consignee_info","txtConsigneeInfo",xmlObj);
                            
                            setField("agent_acct","hAgentAcct",xmlObj);
                            setField("agent_name","lstAgentName",xmlObj);
                            setField("agent_info","txtAgentInfo",xmlObj);
                            
                            setField("notify_acct","hNotifyAcct",xmlObj);
                            setField("notify_name","lstNotifyName",xmlObj);
                            setField("notify_info","txtNotifyInfo",xmlObj);
                            
                            setField("trucker_acct","hTruckerAcct",xmlObj);
                            setField("trucker_name","lstTruckerName",xmlObj);
                            setField("trucker_info","txtTruckerInfo",xmlObj);
                            
                            setField("executed_date","txtUpdatedDate",xmlObj);
                            
                            setField("booking_no","txtBookingNum",xmlObj);
                            setField("house_no","txtHawbNum",xmlObj);
                            setField("master_no","txtMawbNum",xmlObj);
                            
                            setField("export_references","txtExportRef",xmlObj);
                            setField("origin_point","txtUsState",xmlObj);
                            setField("routing_instructions","txtExportInstr",xmlObj);
                            setField("pre_carrier","txtPreCarriage",xmlObj);
                            setField("pre_carrier_place","txtPreReceiptPlace",xmlObj);
                            setField("export_carrier","txtExportCarrier",xmlObj);
                            
                            setField("load_port","txtLoadingPort",xmlObj);
                            setField("load_port_terminal","txtLoadingTerminal",xmlObj);
                            setField("unload_port","txtUnloadingPort",xmlObj);
                            
                            setField("delivery_place","txtDeliveryPlace",xmlObj);
                            setField("move_type","txtMoveType",xmlObj);
                            setCheck("containerized","chkContainerized",xmlObj);
                            setField("containerized","hContainerized",xmlObj);
                            
                            setField("item_marks","txtDesc1",xmlObj);
                            setField("item_pieces","txtDesc2",xmlObj);
                            setField("item_desc","txtDesc3",xmlObj);
                            setField("item_weight","txtGrossWeight",xmlObj);
                            setField("item_measurement","txtMeasurement",xmlObj);
                            
                            setSelectField("item_weight_scale","lstWeightScale",xmlObj,1)
                            setSelectField("measurement_scale","lstMeasurementScale",xmlObj,2)
                            
                            setField("prepared_by","txtPrepareBy",xmlObj);
                        }
                        
                        // default values
                        
						if(document.getElementById("txtUpdatedDate").value == "")
						{
							document.getElementById("txtUpdatedDate").value = "<%=Date() %>";
						}
                        if(document.getElementById("txtPrepareBy").value == "")
                        {
                            document.getElementById("txtPrepareBy").value = "<%=employee_name %>";
                        }
                        if(document.getElementById("lstWeightScale").selectedIndex >= 0 && document.getElementById("lstMeasurementScale").selectedIndex < 0)
                        {
                            document.getElementById("lstMeasurementScale").selectedIndex = document.getElementById("lstWeightScale").selectedIndex;
                        }
                        
                        // number format
						formatDouble("txtGrossWeight");
						formatDouble("txtMeasurement");
						
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
            var noValue = document.getElementById("txtDRNum").value;

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
                showPDFself();
            }
        }
        
        function showPDFself(){
            var form = document.getElementById("form1");
            form.action = "doc_receipt_pdf.asp";
            form.method = "POST";
            form.target = "_self";
            form.submit();
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

                
                var url = "/IFF_MAIN/asp/ajaxFunctions/ajax_dock_receipt.asp?mode=update&uid=" + noValue;
                
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

        function setContainerizedValue(arg)
        {
            var obj = document.getElementById("hContainerized");
            obj.value = arg;
        }
        
        function deleteThis()
        {
            var typeIndex = document.getElementById("lstSearchType").selectedIndex;
            var typeValue = document.getElementById("lstSearchType").options[typeIndex].value;
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
                    
                    var url = "/IFF_MAIN/asp/ajaxFunctions/ajax_certificate_origin.asp?mode=delete&type=" + typeValue
                        + "&export=A&no=" + noValue;
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
        
        function setContainerizedValue(arg)
        {
            var obj = document.getElementById("hContainerized");
            obj.value = arg;
        }
    </script>

    <script type="text/javascript" src="../include/JPED.js"></script>

    <script type="text/javascript">
        
        function searchNumFill(obj,changeFunction,vHeight){
            var qStr = obj.value;
            var keyCode = window.event.keyCode;
            var url;

            if(qStr != "" && keyCode != 229 && keyCode != 27){
                url = "/IFF_MAIN/asp/ajaxFunctions/ajax_dock_receipt.asp?mode=list&qStr=" + qStr;
                FillOutJPED(obj,url,changeFunction,vHeight);
            }
        }
        
        function searchNumFillAll(objName,changeFunction,vHeight){
            var obj = document.getElementById(objName);
            
            url = "/IFF_MAIN/asp/ajaxFunctions/ajax_dock_receipt.asp?mode=list";
            FillOutJPED(obj,url,changeFunction,vHeight);
        }
        
        
        // Start of list change effect //////////////////////////////////////////////////////////////////
        
        function lstSearchNumChange(argV,argL){
            var divObj = document.getElementById("lstSearchNumDiv");

            document.getElementById("isDocBeingSubmitted").value = false;
            document.getElementById("isDocBeingModified").value = 0;
	        document.getElementById("lstSearchNum").value = argL;
	        document.getElementById("hSearchNum").value = argV;
	        
            var url = "/IFF_MAIN/asp/ajaxFunctions/ajax_dock_receipt.asp?mode=view&uid=" + argV;
            new ajax.xhr.Request('GET','',url,displayScreen,'','','','');
            
            divObj.style.visibility = "hidden";
            divObj.style.position = "absolute";
		    divObj.innerHTML = "";
        }
        
        function lstShipperNameChange(orgNum,orgName)
        {
            var hiddenObj = document.getElementById("hShipperAcct");
            var infoObj = document.getElementById("txtShipperInfo");
            var txtObj = document.getElementById("lstShipperName");
            var divObj = document.getElementById("lstShipperNameDiv")
    
            hiddenObj.value = orgNum;
            infoObj.value = getOrganizationInfo(orgNum,"B");
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
		    docModified(1);
        }
        
        function lstConsigneeNameChange(orgNum,orgName)
        {
            var hiddenObj = document.getElementById("hConsigneeAcct");
            var infoObj = document.getElementById("txtConsigneeInfo");
            var txtObj = document.getElementById("lstConsigneeName");
            var divObj = document.getElementById("lstConsigneeNameDiv")
    
            hiddenObj.value = orgNum;
            infoObj.value = getOrganizationInfo(orgNum,"B");
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
		    lstNotifyNameChange(orgNum,orgName);
		    docModified(1);
        }
        
        function lstAgentNameChange(orgNum,orgName)
        {
            var hiddenObj = document.getElementById("hAgentAcct");
            var infoObj = document.getElementById("txtAgentInfo");
            var txtObj = document.getElementById("lstAgentName");
            var divObj = document.getElementById("lstAgentNameDiv")
    
            hiddenObj.value = orgNum;
            infoObj.value = getOrganizationInfo(orgNum,"B");
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
		    docModified(1);
        }
        
        function lstNotifyNameChange(orgNum,orgName)
        {
            var hiddenObj = document.getElementById("hNotifyAcct");
            var infoObj = document.getElementById("txtNotifyInfo");
            var txtObj = document.getElementById("lstNotifyName");
            var divObj = document.getElementById("lstNotifyNameDiv")
    
            hiddenObj.value = orgNum;
            infoObj.value = getOrganizationInfo(orgNum,"B");
            txtObj.value = orgName;
            divObj.style.visibility = "hidden";
            divObj.style.position = "absolute";
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

            var url="../ajaxFunctions/ajax_get_org_address_info.asp?type=" + infoFormat + "&org=" + orgNum;
        
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
-->
    </style>
</head>
<body>
    <form id="form1" action="" onKeyDown="javascript:docModified(1);">
        <input type="hidden" id="isDocBeingSubmitted" value="false" />
        <input type="hidden" id="isDocBeingModified" value="0" />
        <input type="hidden" id="hContainerized" name="hContainerized" value="" />
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td width="50%" align="left" valign="middle" class="pageheader">
                    DOCK RECEIPT
                </td>
                <td width="50%" align="right" valign="middle">&nbsp;
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
                            <img src="/iff_main/ASP/Images/icon_printer.gif" align="absbottom">
                            <a href="javascript:;" onClick="viewPDF(); return false;" style="cursor: hand;">DOCK
                                RECEIPT</a></div>
                    </td>
                </tr>
            </table>
        </div>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="A0829C">
            <tr>
                <td>
                    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="A0829C"
                        bgcolor="#be99b9" class="border1px">
                        <tr>
                            <td>
                                <table width="100%" border="0" cellpadding="2" cellspacing="0">
                                    <tr bgcolor="#e8d9e6">
                                        <td height="22" align="center" valign="middle" bgcolor="#e8d9e6" class="bodyheader">
                                            <table width="98%" border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td width="26%" valign="middle">&nbsp;
                                                        
                                                    </td>
                                                    <td width="48%" align="center" valign="middle">
                                                        <img src="../images/button_save_medium.gif" width="46" height="18" name="bSave" onClick="saveForm();"
                                                            style="cursor: hand" /></td>
                                                    <td width="13%" align="right" valign="middle">
                                                        <a href="/iff_main/ASP/pre_shipment/dock_receipt.asp" target="_self">
                                                            <img src="/iff_main/ASP/Images/button_new.gif" width="42" height="17" border="0"
                                                                style="cursor: hand"></a></td>
                                                    <td width="13%" align="right" valign="middle">
                                                        <img src="../images/button_delete_medium.gif" alt="Delete House AWB No." name="bDeleteHAWB"
                                                            width="51" height="18" style="cursor: hand" onClick="deleteThis();"></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="9" bgcolor="#be99b9">
                                        </td>
                                    </tr>
                                    <tr align="center">
                                        <td height="8" valign="middle" bgcolor="#f3f3f3" class="bodycopy">
                                            <br>
                                            <br>
                                            <table class="bodycopy" width="82%" border="0" align="center" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td width="57%" height="28" align="left" valign="middle">
                                                        <label id="txtFileNameLabel">
                                                            <strong><span class="bodyheader">
                                                                <img src="/iff_main/ASP/Images/required.gif" align="absmiddle"></span>Dock Receipt
                                                                No.&nbsp;
                                                                <input type="text" class="d_shorttextfield" id="txtDRNum" name="txtDRNum" readonly="readonly" />
                                                            </strong>
                                                        </label>
                                                    </td>
                                                    <td width="43%" align="right" valign="middle">
                                                        <span class="bodyheader">
                                                            <img src="/iff_main/ASP/Images/required.gif" align="absbottom">Required field</span></td>
                                                </tr>
                                            </table>
                                            <table width="82%" border="0" cellpadding="2" cellspacing="0" bordercolor="#A0829C"
                                                class="border1px">
                                                <tr align="left" valign="middle" bgcolor="#f2ecf1" class="bodycopy">
                                                    <td height="19">&nbsp;
                                                        
                                                    </td>
                                                    <td colspan="2" bgcolor="#f2ecf1">
                                                        <b>Exporter</b></td>
                                                    <td width="23%" bgcolor="#f2ecf1" class="bodyheader">
                                                        Creation Date
                                                    </td>
                                                    <td>
                                                        <span class="style8">Booking No.</span></td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#ffffff" class="bodycopy">
                                                    <td>&nbsp;
                                                        </td>
                                                    <td colspan="2" rowspan="5" class="bodycopy">
                                                        <!-- Start JPED -->
                                                        <input type="hidden" id="hShipperAcct" name="hShipperAcct" />
                                                        <div id="lstShipperNameDiv">
                                                        </div>
                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                            <tr>
                                                                <td>
                                                                    <input type="text" autocomplete="off" id="lstShipperName" name="lstShipperName" value=""
                                                                        class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                        border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onKeyUp="organizationFill(this,'Shipper','lstShipperNameChange')"
                                                                        onfocus="initializeJPEDField(this);" /></td>
                                                                <td>
                                                                    <img src="/ig_common/Images/combobox_drop.gif" alt="" onClick="organizationFillAll('lstShipperName','Shipper','lstShipperNameChange')"
                                                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                        border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                                <td>
                                                                    <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                        onclick="quickAddClient('hShipperAcct','lstShipperName','txtShipperInfo')" /></td>
                                                            </tr>
                                                        </table>
                                                        <textarea id="txtShipperInfo" name="txtShipperInfo" class="multilinetextfield" cols=""
                                                            rows="5" style="width: 300px"></textarea>
                                                        <!-- End JPED -->
                                                    </td>
                                                    <td valign="top" class="bodycopy">
                                                        <input name="txtUpdatedDate" type="text" class="m_shorttextfield" value="" size="20"
                                                            preset="shortdate" /></td>
                                                    <td valign="top">
                                                        <input name="txtBookingNum" type="text" class="d_shorttextfield" value="" size="20"
                                                            readonly="readonly" /></td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#f2ecf1" class="bodycopy">
                                                    <td width="1%" height="19" bgcolor="#FFFFFF">&nbsp;
                                                        
                                                    </td>
                                                    <td height="19" bgcolor="#f2ecf1" class="bodycopy">
                                                        <span style="height: 12px"><strong><span class="style9" id="lbSearchMaster">Master B/L
                                                            No.</span></strong></span></td>
                                                    <td>
                                                        <strong><span class="style9">House AWB No.</span></strong></td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#f2ecf1" class="bodycopy">
                                                    <td height="19" bgcolor="#FFFFFF">&nbsp;
                                                        </td>
                                                    <td height="19" bgcolor="#FFFFFF" class="bodycopy">
                                                        <input name="txtMAWBNum" type="text" class="d_shorttextfield" value="" size="20"
                                                            readonly="readonly" /></td>
                                                    <td bgcolor="#FFFFFF">
                                                        <input name="txtHAWBNum" type="text" class="d_shorttextfield" value="" size="20"
                                                            readonly="readonly" /></td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#f2ecf1" class="bodycopy">
                                                    <td height="19" bgcolor="#FFFFFF">&nbsp;
                                                        </td>
                                                    <td height="19" colspan="2" bgcolor="#f2ecf1" class="bodycopy">
                                                        <strong>Export Reference</strong></td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                    <td>
                                                    </td>
                                                    <td colspan="2" valign="top">
                                                        <textarea wrap="hard" cols="50" rows="3" name="txtExportRef" class="multilinetextfield"
                                                            id="TEXTAREA1"></textarea></td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#f2ecf1" class="bodycopy">
                                                    <td height="19">&nbsp;
                                                        
                                                    </td>
                                                    <td colspan="2" class="bodycopy">
                                                        <span class="bodyheader"><b>Consigned to </b></span>
                                                    </td>
                                                    <td valign="middle">
                                                        <b>Forwarding Agent</b></td>
                                                    <td width="24%">&nbsp;
                                                        
                                                    </td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#ffffff" class="bodycopy">
                                                    <td height="19">&nbsp;
                                                        
                                                    </td>
                                                    <td colspan="2" class="bodycopy">
                                                        <!-- Start JPED -->
                                                        <input type="hidden" id="hConsigneeAcct" name="hConsigneeAcct" />
                                                        <div id="lstConsigneeNameDiv">
                                                        </div>
                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                            <tr>
                                                                <td>
                                                                    <input type="text" autocomplete="off" id="lstConsigneeName" name="lstConsigneeName"
                                                                        value="" class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9;
                                                                        border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;"
                                                                        onkeyup="organizationFill(this,'Consignee','lstConsigneeNameChange')" onFocus="initializeJPEDField(this);" /></td>
                                                                <td>
                                                                    <img src="/ig_common/Images/combobox_drop.gif" alt="" onClick="organizationFillAll('lstConsigneeName','Consignee','lstConsigneeNameChange')"
                                                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                        border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                                <td>
                                                                    <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                        onclick="quickAddClient('hConsigneeAcct','lstConsigneeName','txtConsigneeInfo')" /></td>
                                                            </tr>
                                                        </table>
                                                        <textarea id="txtConsigneeInfo" name="txtConsigneeInfo" class="multilinetextfield"
                                                            cols="" rows="5" style="width: 300px"></textarea>
                                                        <!-- End JPED -->
                                                    </td>
                                                    <td colspan="2" align="left" valign="top" bgcolor="#ffffff">
                                                        <!-- Start JPED -->
                                                        <input type="hidden" id="hAgentAcct" name="hAgentAcct" />
                                                        <div id="lstAgentNameDiv">
                                                        </div>
                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                            <tr>
                                                                <td>
                                                                    <input type="text" autocomplete="off" id="lstAgentName" name="lstAgentName" value=""
                                                                        class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                        border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onKeyUp="organizationFill(this,'Agent','lstAgentNameChange')"
                                                                        onfocus="initializeJPEDField(this);" /></td>
                                                                <td>
                                                                    <img src="/ig_common/Images/combobox_drop.gif" alt="" onClick="organizationFillAll('lstAgentName','Agent','lstAgentNameChange')"
                                                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                        border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                                <td>
                                                                    <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                        onclick="quickAddClient('hAgentAcct','lstAgentName','txtAgentInfo')" /></td>
                                                            </tr>
                                                        </table>
                                                        <textarea id="txtAgentInfo" name="txtAgentInfo" class="multilinetextfield" cols=""
                                                            rows="5" style="width: 300px"></textarea>
                                                        <!-- End JPED -->
                                                    </td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#f2ecf1" class="bodycopy">
                                                    <td height="19" bgcolor="#f2ecf1">&nbsp;
                                                        
                                                    </td>
                                                    <td colspan="2" class="bodycopy">
                                                        <b>Notify Party/Intermediate Consignee </b>
                                                    </td>
                                                    <td colspan="2" valign="middle">
                                                        <strong>Point (State) of Origin or FTZ Number</strong></td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#ffffff" class="bodycopy">
                                                    <td height="19">&nbsp;
                                                        
                                                    </td>
                                                    <td colspan="2" rowspan="3" class="bodycopy">
                                                        <!-- Start JPED -->
                                                        <input type="hidden" id="hNotifyAcct" name="hNotifyAcct" />
                                                        <div id="lstNotifyNameDiv">
                                                        </div>
                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                            <tr>
                                                                <td>
                                                                    <input type="text" autocomplete="off" id="lstNotifyName" name="lstNotifyName" value=""
                                                                        class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                        border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onKeyUp="organizationFill(this,'Notify','lstNotifyNameChange')"
                                                                        onfocus="initializeJPEDField(this);" /></td>
                                                                <td>
                                                                    <img src="/ig_common/Images/combobox_drop.gif" alt="" onClick="organizationFillAll('lstNotifyName','Notify','lstNotifyNameChange')"
                                                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                        border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                                <td>
                                                                    <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                        onclick="quickAddClient('hNotifyAcct','lstNotifyName','txtNotifyInfo')" /></td>
                                                            </tr>
                                                        </table>
                                                        <textarea id="txtNotifyInfo" name="txtNotifyInfo" class="multilinetextfield" cols=""
                                                            rows="5" style="width: 300px"></textarea>
                                                        <!-- End JPED -->
                                                    </td>
                                                    <td colspan="2" valign="middle" bgcolor="#ffffff">
                                                        <input type="text" name="txtUsState" class="shorttextfield" value="" />
                                                        <%=GetAgentCountry() %></td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#ffffff" class="bodycopy">
                                                    <td height="19">&nbsp;
                                                        
                                                    </td>
                                                    <td colspan="2" valign="middle" bgcolor="#f2ecf1">
                                                        <strong>Domestic Routing/Export Instructions</strong></td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#ffffff" class="bodycopy">
                                                    <td style="height: 118px">&nbsp;
                                                        
                                                    </td>
                                                    <td colspan="2" rowspan="1" valign="top" bgcolor="#ffffff">
                                                        <textarea wrap="hard" name="txtExportInstr" cols="50" rows="8" class="multilinetextfield"></textarea>
                                                    </td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#f2ecf1" class="bodycopy">
                                                    <td height="19">&nbsp;
                                                        
                                                    </td>
                                                    <td width="23%" bgcolor="#f2ecf1" class="bodyheader" height="19">
                                                        Pre-Carriage By</td>
                                                    <td width="29%" bgcolor="#f2ecf1" class="bodyheader" height="19">
                                                        Place of Receipt by Pre-Carrier</td>
                                                    <td width="29%" bgcolor="#f2ecf1" class="bodyheader" height="19" colspan="2">
                                                        Trucker Info</td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#ffffff" class="bodycopy">
                                                    <td height="19">&nbsp;
                                                        
                                                    </td>
                                                    <td class="bodycopy">
                                                        <input type="text" name="txtPreCarriage" class="shorttextfield" style="width: 150px"
                                                            value="" /></td>
                                                    <td class="bodycopy">
                                                        <input type="text" name="txtPreReceiptPlace" class="shorttextfield" style="width: 200px"
                                                            value="" /></td>
                                                    <td colspan="2">
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
                                                                        onclick="quickAddClient('hTruckerAcct','lstTruckerName','txtTruckerInfo')" /></td>
                                                            </tr>
                                                        </table>
                                                        <textarea id="txtTruckerInfo" name="txtTruckerInfo" class="multilinetextfield" cols=""
                                                            rows="2" style="width: 300px"></textarea>
                                                        <!-- End JPED -->
                                                    </td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#f2ecf1" class="bodycopy">
                                                    <td height="19">&nbsp;
                                                        
                                                    </td>
                                                    <td class="bodycopy">
                                                        <strong>Exporting Carrier</strong></td>
                                                    <td class="bodycopy">
                                                        <strong>Port of Loading/Export</strong></td>
                                                    <td valign="middle">
                                                        <strong>Loading Pier/Terminal</strong></td>
                                                    <td>&nbsp;
                                                        
                                                    </td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#ffffff" class="bodycopy">
                                                    <td height="19">&nbsp;
                                                        
                                                    </td>
                                                    <td class="bodycopy">
                                                        <input type="text" name="txtExportCarrier" class="shorttextfield" style="width: 150px"
                                                            value="" /></td>
                                                    <td class="bodycopy">
                                                        <input type="text" name="txtLoadingPort" class="shorttextfield" style="width: 200px"
                                                            value="" />
                                                    </td>
                                                    <td colspan="2" valign="middle">
                                                        <input type="text" name="txtLoadingTerminal" class="shorttextfield" style="width: 200px"
                                                            value="" /></td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#f2ecf1" class="bodycopy">
                                                    <td height="19" bgcolor="#f2ecf1">&nbsp;
                                                        
                                                    </td>
                                                    <td class="bodycopy">
                                                        <strong>Foreign Port of Unloading</strong></td>
                                                    <td bgcolor="#f2ecf1" class="bodycopy">
                                                        <strong>Place of Delivery By On-Carrier</strong></td>
                                                    <td valign="middle">
                                                        <strong>Type of Move</strong></td>
                                                    <td valign="middle">
                                                        <strong>CONTAINERIZED </strong>(Vessel Only)</td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#ffffff" class="bodycopy">
                                                    <td height="19">&nbsp;
                                                        
                                                    </td>
                                                    <td class="bodycopy">
                                                        <input type="text" name="txtUnloadingPort" class="shorttextfield" style="width: 150px"
                                                            value="" /></td>
                                                    <td class="bodycopy">
                                                        <input type="text" name="txtDeliveryPlace" class="shorttextfield" style="width: 200px"
                                                            value="" /></td>
                                                    <td colspan="1" valign="middle">
                                                        <input type="text" name="txtMoveType" style="width: 200px" class="shorttextfield"
                                                            value="" /></td>
                                                    <td>
                                                        <input type="radio" name="chkContainerized" onClick="setContainerizedValue('Y');"
                                                            value="Y" />Yes
                                                        <input type="radio" name="chkContainerized" onClick="setContainerizedValue('N');"
                                                            value="N" />No</td>
                                                </tr>
                                            </table>
                                            <table width="82%" border="0" cellpadding="0" cellspacing="0" bordercolor="#A0829C"
                                                class="border1px">
                                                <tr bgcolor="#f2ecf1">
                                                    <td width="1%" height="19">&nbsp;
                                                        
                                                    </td>
                                                    <td width="17%">
                                                        <strong>Marks and Numbers</strong></td>
                                                    <td width="12%">
                                                        <strong>No. of Packages</strong></td>
                                                    <td width="41%">
                                                        <strong>Description of Commodities in Schedule B detail</strong></td>
                                                    <td width="29%">
                                                        <strong>Gross Weight</strong></td>
                                                </tr>
                                                <tr>
                                                    <td bgcolor="#FFFFFF">&nbsp;
                                                        
                                                    </td>
                                                    <td rowspan="3" align="left" valign="top" bgcolor="#FFFFFF">
                                                        <textarea wrap="hard" name="txtDesc1" cols="24" rows="5" class="multilinetextfield"></textarea></td>
                                                    <td rowspan="3" bgcolor="#FFFFFF">
                                                        <textarea wrap="hard" name="txtDesc2" cols="16" rows="5" class="multilinetextfield"></textarea></td>
                                                    <td rowspan="3" bgcolor="#FFFFFF">
                                                        <textarea wrap="hard" name="txtDesc3" cols="50" rows="5" class="multilinetextfield"></textarea></td>
                                                    <td align="left" valign="top" bgcolor="#FFFFFF">
                                                        <select name="lstWeightScale" class="smallselect" onChange="convertKG_LB(0)">
                                                            <option value="KG">KG</option>
                                                            <option value="LB">LB</option>
                                                        </select>
                                                        <input type="text" name="txtGrossWeight" class="shorttextfield" 
                                                            value="" style="behavior: url(../include/igNumDotChkLeft.htc); width:80px" onkeydown="resetWeight(0);" /></td>
                                                </tr>
                                                <tr>
                                                    <td bgcolor="#FFFFFF">&nbsp;
                                                        
                                                    </td>
                                                    <td height="19" align="left" bgcolor="#f2ecf1">
                                                        <strong>Measurement</strong></td>
                                                </tr>
                                                <tr>
                                                    <td bgcolor="#FFFFFF">&nbsp;
                                                        
                                                    </td>
                                                    <td align="left" valign="top" bgcolor="#FFFFFF">
                                                        <select name="lstMeasurementScale" class="smallselect" onChange="convertCBM_CFT(0)">
                                                            <option value="CBM">CBM</option>
                                                            <option value="CFT">CFT</option>
                                                        </select>
                                                        <input type="text" name="txtMeasurement" class="shorttextfield"
                                                            value="" style="behavior: url(../include/igNumDotChkLeft.htc); width:80px" onkeydown="resetMeasure(0);" /></td>
                                                </tr>
                                                <tr>
                                                    <td bgcolor="#FFFFFF">&nbsp;
                                                        
                                                    </td>
                                                    <td align="left" valign="top" bgcolor="#FFFFFF">&nbsp;
                                                        
                                                    </td>
                                                    <td bgcolor="#FFFFFF">&nbsp;
                                                        
                                                    </td>
                                                    <td bgcolor="#FFFFFF">&nbsp;
                                                        
                                                    </td>
                                                    <td align="left" valign="top" bgcolor="#FFFFFF">&nbsp;
                                                        
                                                    </td>
                                                </tr>
                                            </table>
                                            <br>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td bgcolor="#f3f3f3" align="center">
                                <table width="86%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td height="30" align="right" valign="middle">
                                            <span class="bodyheader">Prepared By</span>
                                            <input name="txtPrepareBy" id="txtPrepareBy" type="text" class="shorttextfield" value="<%=GetUserFLName(user_id) %>"
                                                size="32" /></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <table width="95%" style="height: 24px" border="0" align="center" cellpadding="0"
            cellspacing="0">
            <tr id="bottom_menu" align="center">
                <td valign="top" bgcolor="#be99b9" style="height: 24px">
                    <img src="../images/spacer.gif" width="1" height="24" /></td>
                <td width="100%" align="center" valign="middle" bgcolor="#e8d9e6" style="height: 24px">
                    <table width="98%" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="26%" valign="middle">&nbsp;
                                
                            </td>
                            <td width="48%" align="center" valign="middle">
                                <img src="../images/button_save_medium.gif" width="46" height="18" name="bSave" onClick="saveForm();"
                                    style="cursor: hand" /></td>
                            <td width="13%" align="right" valign="middle">
                                <a href="/iff_main/ASP/pre_shipment/dock_receipt.asp" target="_self">
                                    <img src="/iff_main/ASP/Images/button_new.gif" width="42" height="17" border="0"
                                        style="cursor: hand"></a></td>
                            <td width="13%" align="right" valign="middle">
                                <img src="../images/button_delete_medium.gif" alt="Delete House AWB No." name="bDeleteHAWB"
                                    width="51" height="18" style="cursor: hand" onClick=""></td>
                        </tr>
                    </table>
                </td>
                <td valign="top" bgcolor="#be99b9" style="height: 24px">
                    <img src="../images/spacer.gif" width="1" height="24" /></td>
            </tr>
            <tr>
                <td height="1" colspan="2" align="left" valign="top" bgcolor="#be99b9">
                    <img src="../images/spacer.gif" width="250" height="1" /></td>
            </tr>
        </table>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td height="32" align="right" valign="bottom">
                    <div id="PrintBottom">
                        <img src="/iff_main/ASP/Images/icon_printer.gif" width="44" height="27" align="absbottom"><b
                            style="cursor: hand;" class="bodycopy" onClick="viewPDF();">DOCK RECEIPT </b>
                    </div>
                </td>
            </tr>
        </table>
        <br />
        
        <script type="text/javascript">
        function getFormObject(argObj){
    
        var form = argObj.parentElement;
        var newWindow;
        	        
            form.action = "../include/GOOFY_form_get.asp";
            form.method = "POST";
            window.open('', 'formTest');
            form.target = "formTest";
            form.submit();
        }
        </script>
        <input type=button value="form object" onClick="getFormObject(this)" />
    </form>
</body>
<!-- #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
