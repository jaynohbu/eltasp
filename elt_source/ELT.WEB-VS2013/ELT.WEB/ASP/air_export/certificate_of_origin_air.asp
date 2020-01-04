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
<%
    Dim employee_name,ff_name,ff_city,agent_country

    employee_name = GetUserFLName(user_id)
    ff_name = GetAgentName(elt_account_number)
    ff_city = GetAgentCity(elt_account_number)
    agent_country = GetSQLResult("SELECT b.country_name FROM agent a LEFT OUTER JOIN all_country_code b ON (ISNULL(a.country_code,'US')=b.country_code) WHERE a.elt_account_number=" & elt_account_number, Null) 
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <title>Certificate Of Origin</title>
    
    <script type="text/javascript" language="javascript" src="/ASP/ajaxFunctions/ajax.js"></script>

    <script type="text/vbscript" language="vbscript">
        Function vbMsg(isTxt,isCaption) 'never used
            testVal = MsgBox(isTxt,3,isCaption)
            vbMsg = testVal
        End Function    
    </script>

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
        
        function navigateAway(event) {

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
                document.getElementById("txtHAWBNum").className = "write";
                document.getElementById("txtHAWBNum").readOnly = false;
                document.getElementById("txtMAWBNum").className = "write";
                document.getElementById("txtMAWBNum").readOnly = false;
				document.getElementById("txtDocNum").className = "write";
                document.getElementById("txtDocNum").readOnly = false;                
            }
            else
            {
                document.getElementById("txtFileName").style.visibility = "hidden";
                document.getElementById("txtFileNameLabel").style.visibility = "hidden";
                document.getElementById("txtHAWBNum").className = "read";
                document.getElementById("txtHAWBNum").readOnly = true;
                document.getElementById("txtMAWBNum").className = "read";
                document.getElementById("txtMAWBNum").readOnly = true;
				document.getElementById("txtDocNum").className = "read";
                document.getElementById("txtDocNum").readOnly = true;
            }
            
            lstSearchNumChange(-1,'');
        }
        
        function lstSearchNumChange(argV,argL){

            var divObj = document.getElementById("lstSearchNumDiv");
            
            document.getElementById("isDocBeingSubmitted").value = false;
            document.getElementById("isDocBeingModified").value = 0;

	        var typeIndex = document.getElementById("lstSearchType").selectedIndex;
	        var typeValue = document.getElementById("lstSearchType").options[typeIndex].value;
	        
	        document.getElementById("lstSearchNum").value = argL;
            document.getElementById("hSearchNum").value = argV;
            
            var url = "/ASP/ajaxFunctions/ajax_certificate_origin.asp?mode=view&type=" 
                + encodeURIComponent(typeValue) + "&export=A&no=" + encodeURIComponent(argV);
            
            new ajax.xhr.Request('GET','',url,displayScreen,'','','','');
            resetWeight(0);
            resetMeasure(0);
            
            divObj.style.visibility = "hidden";
            divObj.style.position = "absolute";
            divObj.style.height = "0px";
		    divObj.innerHTML = "";
        }
        
        function displayScreen(req,field,tmpVal,tWidth,tMaxLength,url)
        {
            if (req.readyState == 4)
            {   
		        if (req.status == 200)
		        {
		            try{
		                var xmlObj = req.responseXML;
                        var mode = "";
                        if(xmlObj.getElementsByTagName("Search_Mode")[0] != null 
                            && xmlObj.getElementsByTagName("Search_Mode")[0].childNodes[0] != null)
                        {
                            mode = xmlObj.getElementsByTagName("Search_Mode")[0].childNodes[0].nodeValue;
                            setField("shipper_acct_num","hShipperAcct",xmlObj);
                            setField("shipper_name","lstShipperName",xmlObj);
                            setField("shipper_info","txtShipperInfo",xmlObj);
                            setField("consignee_acct_num","hConsigneeAcct",xmlObj);
                            setField("consignee_name","lstConsigneeName",xmlObj);
                            setField("consignee_info","txtConsigneeInfo",xmlObj);
                            setField("agent_acct_num","hAgentAcct",xmlObj);
                            setField("agent_name","lstAgentName",xmlObj);
                            setField("agent_info","txtAgentInfo",xmlObj);
                            setField("notify_acct_num","hNotifyAcct",xmlObj);
                            setField("notify_name","lstNotifyName",xmlObj);
                            setField("notify_info","txtNotifyInfo",xmlObj);
                            setField("ff_county_name","lstFFCounty",xmlObj);
                            setField("ff_county_acct","hFFCountyAcct",xmlObj); 
                            setField("updated_date","txtUpdatedDate",xmlObj);
                            setField("sworn_date","txtSwornDate",xmlObj);
                            setField("created_date","txtCreatedDate",xmlObj);
                            setField("doc_num","txtDocNum",xmlObj);
                            setField("hawb_num","txtHAWBNum",xmlObj);
                            setField("mawb_num","txtMAWBNum",xmlObj);
                            setField("export_ref","txtExportRef",xmlObj);
                            setField("origin_country","txtOriginCountry",xmlObj);
                            setField("export_instr","txtExportInstr",xmlObj);
                            setField("pre_carriage","txtPreCarriage",xmlObj);
                            setField("pre_receipt_place","txtPreReceiptPlace",xmlObj);
                            setField("export_carrier","txtExportCarrier",xmlObj);
                            setField("loading_port","txtLoadingPort",xmlObj);
                            setField("loading_terminal","txtLoadingTerminal",xmlObj);
                            setField("unloading_port","txtUnloadingPort",xmlObj);
                            setField("delivery_place","txtDeliveryPlace",xmlObj);
                            setField("move_type","txtMoveType",xmlObj);
                            setField("desc1","txtDesc1",xmlObj);
                            setField("desc2","txtDesc2",xmlObj);
                            setField("desc3","txtDesc3",xmlObj);
                            setField("gross_weight","txtGrossWeight",xmlObj);
                            setField("measurement","txtMeasurement",xmlObj);
                            setSelectField("weight_scale","lstWeightScale",xmlObj,1)
                            setSelectField("measurement_scale","lstMeasurementScale",xmlObj,2)
                            setField("us_state","txtUsState",xmlObj);
                            setField("ff_name","txtFFName",xmlObj);
                            setField("ff_city","txtFFCity",xmlObj);
                            setField("employee","txtPrepareBy",xmlObj);
                            setField("origin_state","txtOriginState",xmlObj);
                            setField("file_name","txtFileName",xmlObj);
                        }
                        
                        // default values
                        
						if(document.getElementById("txtUpdatedDate").value == "")
						{
							document.getElementById("txtUpdatedDate").value = "<%=Date() %>";
						}
                        if(document.getElementById("txtOriginCountry").value == "")
                        {
                            document.getElementById("txtOriginCountry").value = "<%=agent_country %>";
                        }
                        if(document.getElementById("txtSwornDate").value == "")
                        {
                            document.getElementById("txtSwornDate").value = "<%=Date() %>";
                        }
                        if(document.getElementById("txtCreatedDate").value == "")
                        {
                            document.getElementById("txtCreatedDate").value = "<%=Date() %>";
                        }
                        if(document.getElementById("txtFFName").value == "")
                        {
                            document.getElementById("txtFFName").value = "<%=ff_name %>";
                        }
                        if(document.getElementById("txtFFCity").value == "")
                        {
                            document.getElementById("txtFFCity").value = "<%=ff_city %>";
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
                        alert("displayScreen : "+error.description);
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
            var htmlObj = $("select#" + htmlTag+">option");

            if(xmlObj.getElementsByTagName(xmlTag)[0] != null && xmlObj.getElementsByTagName(xmlTag)[0].childNodes[0] != null)
            {
                for(var i=0;i<htmlObj.length;i++)
                {
                    if(htmlObj.get(i).value.substring(0,compareLen) == xmlObj.getElementsByTagName(xmlTag)[0].childNodes[0].nodeValue.substring(0,compareLen))
                    {
                        htmlObj.get(i).selected = true;
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
                alert("formatDouble : "+error.message);
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
            var form = document.getElementById("form1");
            var noValue = document.getElementById("lstSearchNum").value;
            var typeIndex = document.getElementById("lstSearchType").selectedIndex;
            var typeValue = document.getElementById("lstSearchType").options[typeIndex].value;
            var answer,question
            var isSaved = false;
            
            if(noValue == "" || noValue == "Select One")
            {
                alert("Please, select billing number to view PDF");
		        return ;
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
                    return ;
                }
            }
            else
            {
                showPDFself();
            }
        }
        
        function showPDFself(){
            var form = document.getElementById("form1");
            
            form.action = "certificate_origin_air_pdf.asp";
            form.method = "POST";
            form.target = "_self";
            form.submit();
        }
        
        function saveForm()
        {
            try{
                var querystring = "";
                var form = document.getElementById("form1");
                var noValue = document.getElementById("lstSearchNum").value;
	            var typeIndex = document.getElementById("lstSearchType").selectedIndex;
	            var typeValue = document.getElementById("lstSearchType").options[typeIndex].value;
                var count = form.elements.length; 

                
                var url = "/ASP/ajaxFunctions/ajax_certificate_origin.asp?mode=update&type=" 
                    + encodeURIComponent(typeValue) + "&export=A&no=" + encodeURIComponent(noValue);
                
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
                    alert("afterUpdate : "+req.responseText);
                    var searchType = document.getElementById("lstSearchType").value;
                    if(searchType == "none")
                    {
                        lstSearchNumChange(document.getElementById("txtFileName").value,document.getElementById("txtFileName").value);
                    }
                    else
                    {
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
                    
                    var url = "/ASP/ajaxFunctions/ajax_certificate_origin.asp?mode=delete&type=" 
                        + encodeURIComponent(typeValue) + "&export=A&no=" + encodeURIComponent(noValue);
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
                    alert("afterDelete : "+req.responseText);
                    lstSearchNumChange(-1,'');
		        }
		    }
        }
    </script>

    <script type="text/javascript" src="../include/JPED.js"></script>

    <script type="text/javascript">

        function searchNumFill(obj, eType, changeFunction, vHeight, event) {
            var qStr = obj.value;
            var keyCode = event.keyCode;
            var url;
            var typeIndex = document.getElementById("lstSearchType").selectedIndex;
	        var typeValue = document.getElementById("lstSearchType").options[typeIndex].value;
	        
            if(qStr != "" && keyCode != 229 && keyCode != 27){
                url = "/ASP/ajaxFunctions/ajax_certificate_origin.asp?mode=list&export=" 
                    + eType + "&qStr=" + qStr + "&type=" + typeValue;
                //document.write(url);
                FillOutJPED(obj,url,changeFunction,vHeight);
            }
        }
        
        function searchNumFillAll(objName,eType,changeFunction,vHeight){
            var obj = document.getElementById(objName);
            var typeIndex = document.getElementById("lstSearchType").selectedIndex;
	        var typeValue = document.getElementById("lstSearchType").options[typeIndex].value;
	        
            var url = "/ASP/ajaxFunctions/ajax_certificate_origin.asp?mode=list&type=" 
                + typeValue + "&export=" + eType;
           // document.write(url);
            FillOutJPED(obj,url,changeFunction,vHeight);
        }
        
// Start of list change effect //////////////////////////////////////////////////////////////////
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
		    docModified(1);
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
		    docModified(1);
        }
        
        function lstAgentNameChange(orgNum,orgName)
        {
            var hiddenObj = document.getElementById("hAgentAcct");
            var infoObj = document.getElementById("txtAgentInfo");
            var txtObj = document.getElementById("lstAgentName");
            var divObj = document.getElementById("lstAgentNameDiv")
    
            hiddenObj.value = orgNum;
            infoObj.value = getOrganizationInfo(orgNum);
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
            divObj.style.height = "0px";
		    docModified(1);
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
		    docModified(1);
        }
        
        function lstFFCountyChange(orgNum,orgName)
        {
            var hiddenObj = document.getElementById("hFFCountyAcct");
            var txtObj = document.getElementById("lstFFCounty");
            var divObj = document.getElementById("lstFFCountyDiv")
    
            hiddenObj.value = orgNum;
            txtObj.value = orgName;
            divObj.style.visibility = "hidden";
            divObj.style.position = "absolute";
            divObj.style.height = "0px";
		    docModified(1);
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
<body onbeforeunload="navigateAway(event);" onload="selectSearchType(); ">
    <form id="form1" action="" onkeydown="javascript:docModified(1);">
        <input type="image" style="position: absolute; visibility: hidden" onclick="return false;" />
        <input type="hidden" id="isDocBeingSubmitted" value="false" />
        <input type="hidden" id="isDocBeingModified" value="0" />
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td width="50%" align="left" valign="middle" class="pageheader">
                    Certificate of origin</td>
                <td width="50%" align="right" valign="middle">
                    &nbsp;</td>
            </tr>
        </table>
        <div class="selectarea">
            <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                    <td height="15" valign="top">
                        <span class="select">Select AWB Type and No.</span></td>
                    <td width="36%" rowspan="2" align="right" valign="bottom">
                        <div id="print">
                            <img src="/ASP/Images/icon_printer.gif" align="absbottom"><a href="javascript:viewPDF();"
                                style="cursor: hand;">Certificate Origin Form</a></div>
                    </td>
                </tr>
                <tr>
                    <td width="64%" valign="bottom">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td width="34%">
                                    <span class="bodyheader">
                                        <select id="lstSearchType" class="bodyheader" onchange="javascript:selectSearchType();">
                                            <option value="house" selected="selected">House AWB No.</option>
                                            <option value="master">Master AWB No. (Direct Shipment)</option>
                                            <option value="none">Anonymous</option>
                                        </select>
                                    </span>
                                </td>
                                <td width="66%">
                                    <!-- Start JPED -->
                                    <input type="hidden" id="hSearchNum" name="hSearchNum" />
                                    <div id="lstSearchNumDiv">
                                    </div>
                                    <table cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td>
                                                <input type="text" autocomplete="off" id="lstSearchNum" name="lstSearchNum" value=""
                                                    class="shorttextfield" style="width: 140px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                    border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="docModified(-1); searchNumFill(this,'A','lstSearchNumChange',200,event);"
                                                    onfocus="initializeJPEDField(this,event);" /></td>
                                            <td>
                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="searchNumFillAll('lstSearchNum','A','lstSearchNumChange',200);"
                                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                    border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                        </tr>
                                    </table>
                                    <!-- End JPED -->
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="A0829C">
            <tr>
                <td>
                    <input type="hidden" name="hCertID" value="" />
                    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="A0829C"
                        bgcolor="#be99b9" class="border1px">
                        <tr>
                            <td>
                                <table width="100%" border="0" cellpadding="2" cellspacing="0">
                                    <tr bgcolor="#e8d9e6">
                                        <td height="22" align="center" valign="middle" bgcolor="#e8d9e6" class="bodyheader">
                                            <table width="98%" border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td width="26%" valign="middle">
                                                        &nbsp;
                                                    </td>
                                                    <td width="48%" align="center" valign="middle">
                                                        <img src="../images/button_save_medium.gif" width="46" height="18" name="bSave" onclick="saveForm();"
                                                            style="cursor: hand" /></td>
                                                    <td width="13%" align="right" valign="middle">
                                                        <a href="/ASP/air_export/certificate_of_origin_air.asp" target="_self">
                                                            <img src="/ASP/Images/button_new.gif" width="42" height="17" border="0"
                                                                style="cursor: hand"></a></td>
                                                    <td width="13%" align="right" valign="middle">
                                                        <img src="../images/button_delete_medium.gif" alt="Delete House AWB No." name="bDeleteHAWB"
                                                            width="51" height="18" style="cursor: hand" onclick="deleteThis();"></td>
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
                                                                <img src="/ASP/Images/required.gif" align="absmiddle"></span>File Name&nbsp;
                                                            </strong>
                                                        </label>
                                                        <input type="text" name="txtFileName" id="txtFileName" class="bodyheader" value="" size="28" style="visibility: hidden" /></td>
                                                    <td width="43%" align="right" valign="middle">
                                                        <span class="bodyheader">
                                                            <img src="/ASP/Images/required.gif" align="absbottom">Required field</span></td>
                                                </tr>
                                            </table>
                                            <table width="82%" border="0" cellpadding="2" cellspacing="0" bordercolor="#A0829C"
                                                class="border1px">
                                                <tr align="left" valign="middle" bgcolor="#f2ecf1" class="bodycopy">
                                                    <td height="19">
                                                        &nbsp;
                                                    </td>
                                                    <td colspan="2" bgcolor="#f2ecf1" class="bodyheader">
                                                        Exporter</td>
                                                    <td width="23%" bgcolor="#f2ecf1" class="bodyheader">
                                                        Creation Date
                                                    </td>
                                                    <td>
                                                        <span class="style8">Document No.</span></td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#ffffff" class="bodycopy">
                                                    <td height="19">
                                                        &nbsp;
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
                                                                        border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Shipper','lstShipperNameChange',null,event)"
                                                                        onfocus="initializeJPEDField(this,event);" /></td>
                                                                <td>
                                                                    <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstShipperName','Shipper','lstShipperNameChange',null,event)"
                                                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                        border-left: 0px solid #7F9DB9; cursor: hand" /></td>
                                                                <td>
                                                                    <input type='hidden' id='quickAdd_output'/>
                                                                    <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                        onclick="quickAddClient('hShipperAcct','lstShipperName','txtShipperInfo')" /></td>
                                                            </tr>
                                                        </table>
                                                        <textarea id="txtShipperInfo" name="txtShipperInfo" class="multilinetextfield" cols=""
                                                            rows="5" style="width: 300px"></textarea>
                                                        <!-- End JPED -->
                                                    </td>
                                                    <td valign="top" class="bodycopy">
                                                        <input name="txtUpdatedDate" id="txtUpdatedDate" type="text" class="m_shorttextfield date" value="" size="20"
                                                            preset="shortdate" /></td>
                                                    <td valign="top">
                                                        <input name="txtDocNum" id="txtDocNum" type="text" class="m_shorttextfield" value="" size="20" /></td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#f2ecf1" class="bodycopy">
                                                    <td width="1%" height="19" bgcolor="#FFFFFF">
                                                        &nbsp;
                                                    </td>
                                                    <td height="19" bgcolor="#f2ecf1" class="bodycopy">
                                                        <span style="height: 12px"><strong><span class="style9" id="lbSearchMaster">Master B/L
                                                            No.</span></strong></span></td>
                                                    <td>
                                                        <strong><span class="style9">House AWB No.</span></strong></td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#f2ecf1" class="bodycopy">
                                                    <td height="19" bgcolor="#FFFFFF">
                                                        &nbsp;</td>
                                                    <td height="19" bgcolor="#FFFFFF" class="bodycopy">
                                                        <input id="txtMAWBNum" name="txtMAWBNum" type="text" class="m_shorttextfield" value="" size="20" /></td>
                                                    <td bgcolor="#FFFFFF">
                                                        <input name="txtHAWBNum" id="txtHAWBNum" type="text" class="m_shorttextfield" value="" size="20" /></td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#f2ecf1" class="bodycopy">
                                                    <td height="19" bgcolor="#FFFFFF">
                                                        &nbsp;</td>
                                                    <td height="19" colspan="2" bgcolor="#f2ecf1" class="bodycopy">
                                                        <strong>Export Reference</strong></td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                    <td>
                                                    </td>
                                                    <td colspan="2" valign="top">
                                                        <textarea wrap="hard" cols="50" rows="3" name="txtExportRef" id="txtExportRef"  class="multilinetextfield"
                                                            id="TEXTAREA1"></textarea></td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#f2ecf1" class="bodycopy">
                                                    <td height="19">
                                                        &nbsp;
                                                    </td>
                                                    <td colspan="2" class="bodycopy">
                                                        <span class="bodyheader"><b>Consigned to </b></span>
                                                    </td>
                                                    <td valign="middle">
                                                        <b>Forwarding Agent</b></td>
                                                    <td width="24%">
                                                        &nbsp;
                                                    </td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#ffffff" class="bodycopy">
                                                    <td height="19">
                                                        &nbsp;
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
                                                                        onkeyup="organizationFill(this,'Consignee','lstConsigneeNameChange',null,event)" onfocus="initializeJPEDField(this,event);" /></td>
                                                                <td>
                                                                    <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstConsigneeName','Consignee','lstConsigneeNameChange',null,event)"
                                                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                        border-left: 0px solid #7F9DB9; cursor: hand" /></td>
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
                                                                        border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Agent','lstAgentNameChange',null,event)"
                                                                        onfocus="initializeJPEDField(this,event);" /></td>
                                                                <td>
                                                                    <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstAgentName','Agent','lstAgentNameChange',null,event)"
                                                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                        border-left: 0px solid #7F9DB9; cursor: hand" /></td>
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
                                                    <td height="19" bgcolor="#f2ecf1">
                                                        &nbsp;
                                                    </td>
                                                    <td colspan="2" class="bodycopy">
                                                        <b>Notify Party/Intermediate Consignee </b>
                                                    </td>
                                                    <td colspan="2" valign="middle">
                                                        <strong>Point (State) of Origin or FTZ Number</strong></td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#ffffff" class="bodycopy">
                                                    <td height="19">
                                                        &nbsp;
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
                                                                        border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Notify','lstNotifyNameChange',null,event)"
                                                                        onfocus="initializeJPEDField(this,event);" /></td>
                                                                <td>
                                                                    <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstNotifyName','Notify','lstNotifyNameChange',null,event)"
                                                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                        border-left: 0px solid #7F9DB9; cursor: hand" /></td>
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
                                                        <input type="text" name="txtUsState" id="txtUsState" class="shorttextfield" maxlength="64" value="" />
                                                        <%=agent_country %>
                                                    </td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#ffffff" class="bodycopy">
                                                    <td height="19">
                                                        &nbsp;
                                                    </td>
                                                    <td colspan="2" valign="middle" bgcolor="#f2ecf1">
                                                        <strong>Domestic Routing/Export Instructions</strong></td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#ffffff" class="bodycopy">
                                                    <td height="19">
                                                        &nbsp;
                                                    </td>
                                                    <td colspan="2" rowspan="3" valign="top" bgcolor="#ffffff">
                                                        <textarea wrap="hard" name="txtExportInstr" id="txtExportInstr" cols="50" rows="8" class="multilinetextfield"></textarea></td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#f2ecf1" class="bodycopy">
                                                    <td height="19">
                                                        &nbsp;
                                                    </td>
                                                    <td width="23%" bgcolor="#f2ecf1" class="bodyheader">
                                                        Pre-Carriage By</td>
                                                    <td width="29%" height="19" bgcolor="#f2ecf1" class="bodyheader">
                                                        Place of Receipt by Pre-Carrier</td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#ffffff" class="bodycopy">
                                                    <td height="19">
                                                        &nbsp;
                                                    </td>
                                                    <td class="bodycopy">
                                                        <input type="text" name="txtPreCarriage" id="txtPreCarriage" class="shorttextfield" maxlength="32" style="width: 150px"
                                                            value="" /></td>
                                                    <td class="bodycopy">
                                                        <input type="text" name="txtPreReceiptPlace" id="txtPreReceiptPlace" class="shorttextfield" maxlength="32"
                                                            style="width: 200px" value="" /></td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#f2ecf1" class="bodycopy">
                                                    <td height="19">
                                                        &nbsp;
                                                    </td>
                                                    <td class="bodycopy">
                                                        <strong>Exporting Carrier</strong></td>
                                                    <td class="bodycopy">
                                                        <strong>Port of Loading/Export</strong></td>
                                                    <td valign="middle">
                                                        <strong>Loading Pier/Terminal</strong></td>
                                                    <td>
                                                        &nbsp;
                                                    </td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#ffffff" class="bodycopy">
                                                    <td height="19">
                                                        &nbsp;
                                                    </td>
                                                    <td class="bodycopy">
                                                        <input type="text" name="txtExportCarrier" id="txtExportCarrier" class="shorttextfield" maxlength="32"
                                                            style="width: 150px" value="" /></td>
                                                    <td class="bodycopy">
                                                        <input type="text" name="txtLoadingPort" id="txtLoadingPort" class="shorttextfield" maxlength="64" style="width: 200px"
                                                            value="" /></td>
                                                    <td colspan="2" valign="middle">
                                                        <input type="text" name="txtLoadingTerminal"  id="txtLoadingTerminal"  class="m_shorttextfield" preset="maxsize"
                                                            style="width: 267px" value="" /></td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#f2ecf1" class="bodycopy">
                                                    <td height="19" bgcolor="#f2ecf1">
                                                        &nbsp;
                                                    </td>
                                                    <td class="bodycopy">
                                                        <strong>Foreign Port of Unloading</strong></td>
                                                    <td bgcolor="#f2ecf1" class="bodycopy">
                                                        <strong>Place of Delivery By On-Carrier</strong></td>
                                                    <td valign="middle">
                                                        <strong>Type of Move</strong></td>
                                                    <td>
                                                        &nbsp;
                                                    </td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#ffffff" class="bodycopy">
                                                    <td height="19">
                                                        &nbsp;
                                                    </td>
                                                    <td class="bodycopy">
                                                        <input type="text" name="txtUnloadingPort" id="txtUnloadingPort" class="shorttextfield" maxlength="64"
                                                            style="width: 150px" value="" /></td>
                                                    <td class="bodycopy">
                                                        <input type="text" name="txtDeliveryPlace" id="txtDeliveryPlace" class="shorttextfield" maxlength="64"
                                                            style="width: 200px" value="" /></td>
                                                    <td colspan="2" valign="middle">
                                                        <input type="text" name="txtMoveType" id="txtMoveType" style="width: 267px" class="shorttextfield"
                                                            maxlength="32" value="" /></td>
                                                </tr>
                                            </table>
                                            <table width="82%" border="0" cellpadding="0" cellspacing="0" bordercolor="#A0829C"
                                                class="border1px">
                                                <tr bgcolor="#f2ecf1">
                                                    <td width="1%" height="19">
                                                        &nbsp;
                                                    </td>
                                                    <td width="17%">
                                                        <strong>Marks and Numbers</strong></td>
                                                    <td width="12%">
                                                        <strong>No. of Packages</strong></td>
                                                    <td width="41%">
                                                        <strong>Description of Commodities</strong></td>
                                                    <td width="29%">
                                                        <strong>Gross Weight</strong></td>
                                                </tr>
                                                <tr>
                                                    <td bgcolor="#FFFFFF">
                                                        &nbsp;
                                                    </td>
                                                    <td rowspan="3" align="left" valign="top" bgcolor="#FFFFFF">
                                                        <textarea wrap="hard" name="txtDesc1" id="txtDesc1" cols="24" rows="5" class="multilinetextfield"></textarea></td>
                                                    <td rowspan="3" bgcolor="#FFFFFF">
                                                        <textarea wrap="hard" name="txtDesc2" id="txtDesc2" cols="16" rows="5" class="multilinetextfield"></textarea></td>
                                                    <td rowspan="3" bgcolor="#FFFFFF">
                                                        <textarea wrap="hard" name="txtDesc3" id="txtDesc3" cols="50" rows="5" class="multilinetextfield"></textarea></td>
                                                    <td align="left" valign="top" bgcolor="#FFFFFF">
                                                        <select name="lstWeightScale" id="lstWeightScale" class="smallselect" onchange="convertKG_LB(0)">
                                                            <option value="KG">KG</option>
                                                            <option value="LB">LB</option>
                                                        </select>
                                                        <input type="text" name="txtGrossWeight" id="txtGrossWeight" class="shorttextfield" style="behavior: url(../include/igNumDotChkLeft.htc)"
                                                            value="" onkeypress="resetWeight(0);" /></td>
                                                </tr>
                                                <tr>
                                                    <td bgcolor="#FFFFFF">
                                                        &nbsp;
                                                    </td>
                                                    <td height="19" align="left" bgcolor="#f2ecf1">
                                                        <strong>Measurement</strong></td>
                                                </tr>
                                                <tr>
                                                    <td bgcolor="#FFFFFF">
                                                        &nbsp;
                                                    </td>
                                                    <td align="left" valign="top" bgcolor="#FFFFFF">
                                                        <select name="lstMeasurementScale" id="lstMeasurementScale" class="smallselect" onchange="convertCBM_CFT(0)">
                                                            <option value="CBM">CBM</option>
                                                            <option value="CFT">CFT</option>
                                                        </select>
                                                        <input type="text" name="txtMeasurement" id="txtMeasurement" class="shorttextfield" style=""
                                                            value="" onkeypress="resetMeasure(0);" /></td>
                                                </tr>
                                                <tr>
                                                    <td bgcolor="#FFFFFF">
                                                        &nbsp;
                                                    </td>
                                                    <td align="left" valign="top" bgcolor="#FFFFFF">
                                                        &nbsp;
                                                    </td>
                                                    <td bgcolor="#FFFFFF">
                                                        &nbsp;
                                                    </td>
                                                    <td bgcolor="#FFFFFF">
                                                        &nbsp;
                                                    </td>
                                                    <td align="left" valign="top" bgcolor="#FFFFFF">
                                                        &nbsp;
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
                            <td bgcolor="#f3f3f3">
                                <table width="82%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#A0829C"
                                    bgcolor="#FFFFFF" class="border1px">
                                    <tr>
                                        <td height="5" colspan="3" class="bodycopy">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td width="1%" class="bodycopy">
                                            &nbsp;
                                        </td>
                                        <td width="98%" class="statement">
                                            The undersigned
                                            <input id="txtFFName" name="txtFFName" value="" type="text" class="m_shorttextfield" preset="maxsize"
                                                size="56">
                                            (Owner or Agent), does hereby declare for the above named shipper, the goods as
                                            described above were shipped&nbsp; and consigned as indicated and are products of
                                            <input name="txtOriginCountry" id="txtOriginCountry" value="" type="text" class="shorttextfield" preset="maxsize"
                                                size="42">
                                            dated at
                                            <input name="txtFFCity" id="txtFFCity" value="" type="text" class="m_shorttextfield" preset="maxsize"
                                                size="32">
                                            on
                                            <input name="txtCreatedDate" id="txtCreatedDate" value="" type="text" class="m_shorttextfield date" preset="shortdate"
                                                size="32"></td>
                                        <td width="1%" class="bodycopy">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="8" colspan="3" class="bodycopy">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="bodycopy">
                                            &nbsp;
                                        </td>
                                        <td class="statement">
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                    <td width="52%" rowspan="2" class="bodycopy">
                                                        Sworn to before me this on
                                                        <input name="txtSwornDate" id="txtSwornDate" value="" type="text" class="m_shorttextfield date" preset="shortdate"
                                                            size="32">
                                                        <br>
                                                        <input name="txtPrepareBy" id="txtPrepareBy" type="text" value="" class="m_shorttextfield" preset="maxsize"
                                                            size="59"></td>
                                                    <td width="48%" height="20" align="left" valign="bottom">
                                                        <hr width="300" size="1">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left" valign="bottom" class="bodycopy">
                                                        Signature of Owner or Agent
                                                    </td>
                                                </tr>
                                            </table>
                                            <br>
                                        </td>
                                        <td class="bodycopy">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
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
                                        <td>
                                            &nbsp;
                                        </td>
                                        <td>
                                            <table cellpadding="0" cellspacing="0" border="0" class="bodycopy">
                                                <tr>
                                                    <td class="statement" width="26">
                                                        The
                                                    </td>
                                                    <td width="351">
                                                        <!-- Start JPED -->
                                                        <input type="hidden" id="hFFCountyAcct" name="hFFCountyAcct" />
                                                        <div id="lstFFCountyDiv">
                                                        </div>
                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                            <tr>
                                                                <td>
                                                                    <input type="text" autocomplete="off" id="lstFFCounty" name="lstFFCounty" value=""
                                                                        class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                        border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Government','lstFFCountyChange',100,event)"
                                                                        onfocus="initializeJPEDField(this,event);" /></td>
                                                                <td>
                                                                    <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstFFCounty','Government','lstFFCountyChange',100,event)"
                                                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                        border-left: 0px solid #7F9DB9; cursor: hand" /></td>
                                                                <td>
                                                                    <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                        onclick="quickAddClient('hFFCountyAcct','lstFFCounty')" /></td>
                                                            </tr>
                                                        </table>
                                                        <!-- End JPED -->
                                                    </td>
                                                    <td width="571" align="left" class="statement">
                                                        a recognized Chamber of Commerce under the laws
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="3">
                                                        of the State of
                                                        <input name="txtOriginState" id="txtOriginState" value="" type="text" class="m_shorttextfield" preset="maxsize"
                                                            size="42">
                                                        certifies in reliance on the exporter's representation and not on the basis of independent
                                                        verification, that to the best of its knowledge and belief, the products named in
                                                        this document originated in
                                                        <%=GetAgentCountry() %>
                                                        .
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td>
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
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
                                </table>
                                <br>
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
                            <td width="26%" valign="middle">
                                &nbsp;
                            </td>
                            <td width="48%" align="center" valign="middle">
                                <img src="../images/button_save_medium.gif" width="46" height="18" name="bSave" onclick="saveForm();"
                                    style="cursor: hand" /></td>
                            <td width="13%" align="right" valign="middle">
                                <a href="/ASP/air_export/certificate_of_origin_air.asp" target="_self">
                                    <img src="/ASP/Images/button_new.gif" width="42" height="17" border="0"
                                        style="cursor: hand"></a></td>
                            <td width="13%" align="right" valign="middle">
                                <img src="../images/button_delete_medium.gif" alt="Delete House AWB No." name="bDeleteHAWB"
                                    width="51" height="18" style="cursor: hand" onclick=""></td>
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
                    <div id="print">
                        <img src="/ASP/Images/icon_printer.gif" width="44" height="27" align="absbottom"><a
                            href="javascript:viewPDF();" style="cursor: hand;">Certificate Origin Form</a></div>
                </td>
            </tr>
        </table>
        <br />
    </form>
</body>
<!-- #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
