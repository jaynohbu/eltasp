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
    Dim i
    Call GET_PORT_LIST()
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
    <title>Pickup Order Form</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        <!--
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
        .style15 {color: #999999}
        .style16
        {
            height: 18px;
        }
        .style17
        {
            font-family: Verdana, Arial, Helvetica, sans-serif;
            font-size: 9px;
            color: #000000;
            text-transform: none;
            height: 18px;
        }
        -->
    </style>

    <script type="text/javascript" language="javascript" src="/ASP/ajaxFunctions/ajax.js"></script>

    <script type="text/javascript">
    
        var oInterval = ""; 
        var gross_weight= "";
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
		
        function saveForm(){
            var querystring = "";
            var form = document.getElementById("form1");
            var noValue = document.getElementById("hSearchNum").value;
            var typeIndex = document.getElementById("lstSearchType").selectedIndex;
            var typeValue = document.getElementById("lstSearchType").options[typeIndex].value;
            var count = form.elements.length; 

            var url = "/ASP/ajaxFunctions/ajax_pickup_order.asp?mode=update&type=" + typeValue
                + "&no=" + encodeURIComponent(noValue);
            var Customer_num =document.getElementById("hPickupAcct").value;
            //Temp customer no from hidden customer item value
            var Temp_item_value=document.getElementById("txtPieces").value;
            //check Pickup selection 
            if(Customer_num == "" || Customer_num =="0")
            {
                alert("Please, select a Pickup From");
                document.getElementById("lstPickupName").focus();
            }
            //check Item selection 
            else if(Temp_item_value == "")
            {
                alert("Please, select No of Packages");
                document.getElementById("txtPieces").focus();
            }
            else
            {
                for(var i = 0; i < count; i++) {
                    if(form.elements[i].name != ""){
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
                document.getElementById("isDocBeingModified").value = 0;
            }
        }

        function afterUpdate(req,field,tmpVal,tWidth,tMaxLength,url){
            if (req.readyState == 4){
		        
		        if (req.status == 200)
		        {
		            var xmlObj = req.responseXML;
		            
		            var error_code = xmlObj.getElementsByTagName("error_code")[0].childNodes[0].nodeValue;
		            
		            if(error_code == 0){
		                var po_num = xmlObj.getElementsByTagName("po_num")[0].childNodes[0].nodeValue;
		                alert("Pickup Order " + po_num + " has been saved.");
		                setField("po_num","lstSearchNum",xmlObj);
                        setField("po_num","txtPickupNumber",xmlObj);
                        setField("uid","hSearchNum",xmlObj);
                        // CreateBill();
                    }
		            else{
		                if(error_code == 1){
		                    var po_num = xmlObj.getElementsByTagName("po_num")[0].childNodes[0].nodeValue;
		                    // alert("Please, set a pickup order number on prefix manager page.");
		                    alert("Pickup Order " + po_num + " has been saved.");
		                    setField("uid","lstSearchNum",xmlObj);
                            setField("po_num","txtPickupNumber",xmlObj);
                            setField("uid","hSearchNum",xmlObj);
                            // CreateBill();
		                }
		                else if(error_code == 2){
		                    alert("Please, reset a pickup order number on prefix manager page.");
		                }
		                else{
		                    alert("Unexpected error has occurred while updating.\nPlease, contact us for further instruction.");
		                }
		            }
		        }
		    }
        }

        function deleteThis()
        {
            var typeIndex = document.getElementById("lstSearchType").selectedIndex;
            var typeValue = document.getElementById("lstSearchType").options[typeIndex].value;
            var noValue = document.getElementById("hSearchNum").value;
            var PickNo = document.getElementById("txtPickupNumber").value;
            
            if(noValue > 0){
                var answer = confirm("Please, click OK to delete this Pickup Order (" + PickNo + ").");
                if(!answer){
                    return false;
                }
                try{
                    var querystring = "";
                    var form = document.getElementById("form1");
                    
                    var url = "/ASP/ajaxFunctions/ajax_pickup_order.asp?mode=delete&type=" 
                        + typeValue + "&no=" + encodeURIComponent(noValue);
                    
                    new ajax.xhr.Request('GET','',url,afterDelete,'','','','');
                    document.getElementById("isDocBeingSubmitted").value = true;
                }catch(err)
                {}
            }
            else{
                alert("Please, select a PickUp Order to delete.");
                return false;
            }
        }
        
        function afterDelete(req,field,tmpVal,tWidth,tMaxLength,url){
            if (req.readyState == 4){   
		        if (req.status == 200){
                    alert(req.responseText);
                    resetField();
		        }
		    }
        }
                
        function viewPDF(){
            var isDocBeingModified = document.getElementById("isDocBeingModified").value;
            var form = document.getElementById("form1");
            var noValue = document.getElementById("lstSearchNum").value;
            var typeIndex = document.getElementById("lstSearchType").selectedIndex;
            var typeValue = document.getElementById("lstSearchType").options[typeIndex].value;
            var answer,question
            var isSaved = false;
            
            if(noValue == "" || noValue == "Select One"){
                alert("Please, select billing number to view PDF");
		        return false;
            }
            
            if((isDocBeingModified > 0 && typeValue=="none") ||
                (isDocBeingModified > 0 && noValue != "" && noValue != "Select One")){
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
            else{
                showPDFself();
            }
        }
        
        function showPDFself(){
            var form = document.getElementById("form1");
            form.action = "pickup_order_pdf.asp";
            form.method = "POST";
            form.target = "_self";
            form.submit();
        }
        
        function displayScreen(req,field,tmpVal,tWidth,tMaxLength,url){
        
            if (req.readyState == 4){   
            
		        if (req.status == 200){

	                var xmlObj = req.responseXML;
	                
                    var mode = "";
                    if(xmlObj.getElementsByTagName("Search_Mode")[0] != null 
                        && xmlObj.getElementsByTagName("Search_Mode")[0].childNodes[0] != null){
                        mode = xmlObj.getElementsByTagName("Search_Mode")[0].childNodes[0].nodeValue;
                    }

                    setField("po_num","txtPickupNumber",xmlObj);
                    setField("pickup_ref_num","txtPickupRefNum",xmlObj);
                    setField("Shipper_account_number","hShipperAcct",xmlObj);
                    setField("Shipper_Info","txtShipperInfo",xmlObj);
                    setField("Shipper_Name","lstShipperName",xmlObj);
                    
                    setField("Pickup_account_number","hPickupAcct",xmlObj);
                    setField("Pickup_Name","lstPickupName",xmlObj);
                    setField("Pickup_Info","txtPickupInfo",xmlObj);
                    
                    setField("Carrier_account_number","hCarrierAcct",xmlObj);
                    setField("Carrier_Name","lstCarrierName",xmlObj);
                    setField("Carrier_Info","txtCarrierInfo",xmlObj);
                    setField("Carrier_Code","hCarrierCode",xmlObj);

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
                    setField("is_hazard","hDangerGoods",xmlObj);
                    
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
                    
                    if(document.getElementById("hDangerGoods").value == "Y"){
                        document.getElementsByName("chkDangerGoods")[0].checked = true;
                    }
                    else if(document.getElementById("hDangerGoods").value == "N"){
                        document.getElementsByName("chkDangerGoods")[1].checked = true;
                    }
                    else{
                        document.getElementsByName("chkDangerGoods")[0].checked = false;
                        document.getElementsByName("chkDangerGoods")[1].checked = false;
                    }
                    
                    setField("employee","txtEmployee",xmlObj); 

                    // default values
					if(document.getElementById("txtEmployee").value == ""){
						document.getElementById("txtEmployee").value = "<%=GetUserFLName(user_id) %>";
					}
					if(document.getElementById("txtUpdateDate").value == ""){
						document.getElementById("txtUpdateDate").value = "<%=Date() %>";
					}
					if(document.getElementById("lstScale1").options.selectedIndex < 0){
                        document.getElementById("lstScale1").options[0].selected = true;
                    }
					
                    // number format
					formatDouble("txtInlandCharge");
					formatDouble("txtGrossWt");
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
        
        function setField(xmlTag,htmlTag,xmlObj){
            if(xmlObj.getElementsByTagName(xmlTag)[0] != null 
                && xmlObj.getElementsByTagName(xmlTag)[0].childNodes[0] != null){
                document.getElementById(htmlTag).value = xmlObj.getElementsByTagName(xmlTag)[0].childNodes[0].nodeValue;
            }
            else{
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
		
		function docModified(arg) {
            var isDocBeingModified = document.getElementById("isDocBeingModified");
            isDocBeingModified.value = parseInt(isDocBeingModified.value) + parseInt(arg);
        }

        function navigateAway(event){
            var isDocBeingSubmitted = document.getElementById("isDocBeingSubmitted");
            var isDocBeingModified = document.getElementById("isDocBeingModified");
            
            msg = "----------------------------------------------------------\n";
            msg += "The form has not been saved.\n";
            msg += "All changes you have made will be lost\n";
            msg += "----------------------------------------------------------";
            
            if (isDocBeingSubmitted.value == "false" && isDocBeingModified.value > 0){
                event.returnValue = msg;
                oInterval = window.setInterval("topSyncLater()",500);
            }
        }
        
        function topSyncLater(){
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
        
        function chkDangerClick(arg){
        
            var dangerGood = document.getElementById("hDangerGoods");
            if(arg=="N"){
                document.getElementsByName("chkDangerGoods")[0].checked = false;
                document.getElementsByName("chkDangerGoods")[1].checked = true;
            }
            else
            {
                document.getElementsByName("chkDangerGoods")[0].checked = true;
                document.getElementsByName("chkDangerGoods")[1].checked = false;
            }
            dangerGood.value = arg;
        }
        
        function resetField(){
            var typeIndex = document.getElementById("lstSearchType").selectedIndex;
            var typeValue = document.getElementById("lstSearchType").options[typeIndex].value;
            
            if(typeValue == "none"){
                document.getElementById("lstSearchNum").value = "";
                selectSearchType();
            }
            else{
                lstSearchNumChange("","");
            }
        }
        
    </script>

    <script type="text/javascript" src="../include/JPED.js"></script>

    <script type="text/javascript">
        
        function searchNumFill(obj,changeFunction,vHeight){
            var qStr = obj.value;
          
            var url;

            if(qStr != "" ){
                url = "/ASP/ajaxFunctions/ajax_pickup_order.asp?mode=list&qStr=" + qStr;
                FillOutJPED(obj,url,changeFunction,vHeight);
            }
        }
        
        function searchNumFillAll(objName,changeFunction,vHeight){
            var obj = document.getElementById(objName);
            
            url = "/ASP/ajaxFunctions/ajax_pickup_order.asp?mode=list&qStr=";
            FillOutJPED(obj,url,changeFunction,vHeight);
        }
        
        function lstShipperNameChange(orgNum,orgName){
            var hiddenObj = document.getElementById("hShipperAcct");
            var infoObj = document.getElementById("txtShipperInfo");
            var txtObj = document.getElementById("lstShipperName");
            var divObj = document.getElementById("lstShipperNameDiv");
    
            hiddenObj.value = orgNum;
            infoObj.value = getOrganizationInfo(orgNum,"B");
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
            divObj.style.height = "0px";
		    divObj.innerHTML = "";
		    docModified(1);
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
        
        function lstCarrierNameChange(orgNum,orgName){
            var hiddenObj = document.getElementById("hCarrierAcct");
            var hiddenCodeObj = document.getElementById("hCarrierCode");
            var txtObj = document.getElementById("lstCarrierName");
            var divObj = document.getElementById("lstCarrierNameDiv");
            var infoObj = document.getElementById("txtCarrierInfo");
            
            var tempStr = getOrganizationInfo(orgNum,"C")
            if(tempStr != null && tempStr != ""){
                var tempPos = tempStr.indexOf("-")
                hiddenCodeObj.value = tempStr.substring(0,tempPos);
                infoObj.value = tempStr.substring(tempPos+1,tempStr.length);
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
	        
	        <% If GetPrefixFileNumber("PUO", elt_account_number,"") = "" Then %>
	        document.getElementById("lstSearchNum").value = argV;
	        <% Else %>
            document.getElementById("lstSearchNum").value = argL;
            <% End If %>
            document.getElementById("hSearchNum").value = argV;
            
            var url = "/ASP/ajaxFunctions/ajax_pickup_order.asp?mode=view&no=" + encodeURIComponent(argV);
            new ajax.xhr.Request('GET','',url,displayScreen,'','','','');
            
            divObj.style.visibility = "hidden";
            divObj.style.position = "absolute";
            divObj.style.height = "0px";
		    divObj.innerHTML = "";
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

            var url="/ASP/ajaxFunctions/ajax_get_org_address_info.asp?type=" + infoFormat + "&org=" + encodeURIComponent(orgNum);
        
            xmlHTTP.open("GET",url,false); 
            xmlHTTP.send();
            
            return xmlHTTP.responseText; 
        }
        
        function redirectToBill(resVal) {
            if(resVal){
                if(resVal[0] == "air_house"){
                    parent.window.location.href = "/AirExport/HAWB/"
                        + encodeURIComponent("DataTransfer=PO&PONum=" + document.getElementById("txtPickupNumber").value);
                }
                if(resVal[0] == "air_master"){
                    parent.window.location.href = "/AirExport/MAWB/"
                        + encodeURIComponent("fBook=yes&Edit=yes&MAWB=" + resVal[1] + "&DataTransfer=PO&PONum=" + document.getElementById("txtPickupNumber").value);
                }
                if(resVal[0] == "ocean_house"){
                    parent.window.location.href= "/OceanExport/HBOL/"
                        + encodeURIComponent("DataTransfer=PO&PONum=" + document.getElementById("txtPickupNumber").value);
                }
                if(resVal[0] == "ocean_master"){
                    parent.window.location.href = "/OceanExport/MBOL/"
                        + encodeURIComponent("ChangeBookingNum=yes&Edit=yes&BookingNum=" + resVal[1] + "&DataTransfer=PO&PONum=" + document.getElementById("txtPickupNumber").value);
                }
                if(resVal[0] == "domestic_house"){
                    parent.window.location.href= "/DomesticFreight/HouseAirBill/"
                        + encodeURIComponent("mode=transfer&PONum=" + document.getElementById("txtPickupNumber").value);
                }
            }
        }

        function CreateBill(){
            if(document.getElementById("txtPickupNumber").value == ""){
                alert("Please, select pickup order number to create bill");
                return ;
            }

            var vURL = "./pickup_order_transfer.asp?PONum=" + document.getElementById("txtPickupNumber").value;
            var resVal = showModalDialog(vURL, "Pickup Order Transfer","dialogWidth:310px; dialogHeight:300px; help:0; status:1; scroll:0; center:1; Sunken;");
            
            if(resVal){
                if(resVal[0] == "air_house"){
                    parent.window.location.href = "/AirExport/HAWB/"
                        + encodeURIComponent("DataTransfer=PO&PONum=" + document.getElementById("txtPickupNumber").value);
                }
                if(resVal[0] == "air_master"){
                    parent.window.location.href = "/AirExport/MAWB/"
                        + encodeURIComponent("fBook=yes&Edit=yes&MAWB=" + resVal[1] + "&DataTransfer=PO&PONum=" + document.getElementById("txtPickupNumber").value);
                }
                if(resVal[0] == "ocean_house"){
                    parent.window.location.href= "/OceanExport/HBOL/"
                        + encodeURIComponent("DataTransfer=PO&PONum=" + document.getElementById("txtPickupNumber").value);
                }
                if(resVal[0] == "ocean_master"){
                    parent.window.location.href = "/OceanExport/MBOL/"
                        + encodeURIComponent("ChangeBookingNum=yes&Edit=yes&BookingNum=" + resVal[1] + "&DataTransfer=PO&PONum=" + document.getElementById("txtPickupNumber").value);
                }
                if(resVal[0] == "domestic_house"){
                    parent.window.location.href= "/DomesticFreight/HouseAirBill/"
                        + encodeURIComponent("mode=transfer&PONum=" + document.getElementById("txtPickupNumber").value);
                }
            }
        }
    
        function bodyLoad(){
            <% If request.QueryString("mode") = "view" And request.QueryString("po") <> "" And request.QueryString("uid") <> "" Then %>
            lstSearchNumChange(<%=request.QueryString("uid") %>,"<%=request.QueryString("po") %>");
            <% Else %>
            lstSearchNumChange("","");
            <% End If %>
        }
        
    </script>

</head>
<body onbeforeunload="navigateAway(event);" onload="bodyLoad();">
    <form id="form1" action="" onkeydown="docModified(1);">
        <input type="image" style="position: absolute; visibility: hidden" onclick="return false;" />
        <input type="hidden" id="isDocBeingSubmitted" value="false" />
        <input type="hidden" id="isDocBeingModified" value="0" />
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td width="50%" align="left" valign="middle" class="pageheader">
                    Pickup Order</td>
                <td width="50%" align="right" valign="middle">
                </td>
            </tr>
        </table>
        <div class="selectarea">
            <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        <span class="select">Select Pickup Order No.</span></td>
                    <td width="55%" rowspan="2" align="right" valign="bottom">
                        <div id="print">
                            <a href="javascript:CreateBill();">
                                <img src="/ASP/Images/icon_createhouse.gif" alt="" width="25" height="26"
                                    style="margin-right: 10px" />Create Bill</a>
                            <img src="/ASP/Images/button_devider.gif" alt="" />
                            <a href="/IFF_MAIN/ASPX/WMS/PickupOrderManager.aspx">
                                <img src="/ASP/Images/icon_detailwindow.gif" alt="" style="margin-right: 10px" />Pickup
                                Order List</a>
                            <img src="/ASP/Images/button_devider.gif" alt="" />
                            <a href="javascript:;" onclick="viewPDF(); return false;" style="cursor: pointer;">
                                <img src="/ASP/Images/icon_printer.gif" alt="" />Pickup Order</a>
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
                    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" brdrcolor="#9e816e"
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
                                                        <img src="../images/button_save_medium.gif" width="46" height="18" name="bSave" onclick="saveForm();"
                                                            style="cursor: hand" /></td>
                                                    <td width="13%" align="right" valign="middle">
                                                        <a href="pickup_order.asp" tabindex="-1">
                                                            <img src="/ASP/Images/button_new.gif" border="0" style="cursor: pointer"></a></td>
                                                    <td width="13%" align="right" valign="middle">
                                                        <img src="../images/button_delete_medium.gif" style="cursor: pointer" onclick="deleteThis();">
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="9" bgcolor="#9e816e">
                                        </td>
                                    </tr>
                                    <tr align="center" bgcolor="#ffffff">
                                        <td valign="middle" class="bodycopy">
                                            <span class="bodyheader">
                                                <select id="lstSearchType" class="bodyheader" style="visibility: hidden">
                                                    <option value="po" selected="selected">Pickup Order Number</option>
                                                </select>
                                            </span>
                                            <br />
                                            <table border="0" cellspacing="0" cellpadding="0" style="width: 85%; height: 18px">
                                                <tr>
                                                    <td height="28" align="right">
                                                        <span class="bodyheader">&nbsp;<img src="/ASP/Images/required.gif" align="absbottom">Required
                                                            field</span></td>
                                                </tr>
                                            </table>
                                            <table width="86%" cellpadding="0" cellspacing="0" bordercolor="#9e816e" class="border1px">
                                                <tr align="left" valign="middle" class="bodycopy">
                                                    <td width="47%" height="19" colspan="2" valign="top">
                                                        <!-- starts pickup and deliver -->
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="border-right: #9e816e solid 1px">
                                                            <tr>
                                                                <td width="2%" bgcolor="#f4e9e0">
                                                                </td>
                                                                <td height="20" colspan="2" align="center" valign="middle" bgcolor="#f4e9e0">
                                                                    <span class="bodyheader style6 style12">
                                                                        <img src="/ASP/Images/required.gif" align="absbottom">PICKUP FROM </span>
                                                                </td>
                                                            </tr>
                                                            <tr align="left" valign="middle" bgcolor="#9e816e" class="bodycopy">
                                                                <td height="1" colspan="3">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    &nbsp;
                                                                </td>
                                                                <td colspan="2">
                                                                    <span class="bodycopy"><span class="style15">Contact</span><br />
                                                                        <input type="text" name="txtContact" id="txtContact" class="shorttextfield" style="width: 300px;" />
                                                                    </span>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    &nbsp;
                                                                </td>
                                                                <td colspan="2" class="bodycopy">
                                                                    <!-- Start JPED -->
                                                                    <input type="hidden" id="hPickupAcct" name="hPickupAcct" />
                                                                    <div id="lstPickupNameDiv">
                                                                    </div>
                                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                                        <tr>
                                                                            <td>
                                                                                <input type="text" autocomplete="off" id="lstPickupName" name="lstPickupName" value=""
                                                                                    class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                                    border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Pickup','lstPickupNameChange',null,event)"
                                                                                    onfocus="initializeJPEDField(this,event);" /></td>
                                                                            <td>
                                                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstPickupName','Pickup','lstPickupNameChange',null,event)"
                                                                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                                    border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                                            <td>
                                                                                <input type='hidden' id='quickAdd_output'/>
                                                                                <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                                    onclick="quickAddClient('hPickupAcct','lstPickupName','txtPickupInfo')" /></td>
                                                                        </tr>
                                                                    </table>
                                                                    <textarea wrap="hard" id="txtPickupInfo" name="txtPickupInfo" class="multilinetextfield"
                                                                        cols="" rows="5" style="width: 300px"></textarea>
                                                                    <!-- End JPED -->
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                </td>
                                                                <td width="48%" class="bodycopy">
                                                                </td>
                                                                <td width="50%" height="8" class="bodycopy">
                                                                </td>
                                                            </tr>
                                                            <tr align="left" valign="middle" bgcolor="#9e816e" class="bodycopy">
                                                                <td height="1" colspan="3">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#f4e9e0">
                                                                    &nbsp;
                                                                </td>
                                                                <td height="20" colspan="2" align="center" valign="middle" bgcolor="#f4e9e0" class="bodyheader">
                                                                    <span class="style8">DELIVERY TO</span></td>
                                                            </tr>
                                                            <tr align="left" valign="middle" bgcolor="#9e816e" class="bodycopy">
                                                                <td height="1" colspan="3">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    &nbsp;
                                                                </td>
                                                                <td colspan="2" class="bodycopy">
                                                                    <span class="style15">Attention To</span><br />
                                                                    <input name="txtAttention" type="text" class="shorttextfield" value="" 
                                                                        style="width: 300px;" id="txtAttention" /></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    &nbsp;
                                                                </td>
                                                                <td colspan="2" class="bodycopy">
                                                                    <!-- Start JPED -->
                                                                    <input type="hidden" id="hCarrierCode" name="hCarrierCode" />
                                                                    <input type="hidden" id="hCarrierAcct" name="hCarrierAcct" />
                                                                    <div id="lstCarrierNameDiv">
                                                                    </div>
                                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                                        <tr>
                                                                            <td>
                                                                                <input type="text" autocomplete="off" id="lstCarrierName" name="lstCarrierName" value=""
                                                                                    class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                                    border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'','lstCarrierNameChange',null,event)"
                                                                                    onfocus="initializeJPEDField(this,event);" /></td>
                                                                            <td>
                                                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstCarrierName','','lstCarrierNameChange',null,event)"
                                                                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                                    border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                                            <td>
                                                                                <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                                    onclick="quickAddClient('hCarrierAcct','lstCarrierName','txtCarrierInfo')" /></td>
                                                                        </tr>
                                                                    </table>
                                                                    <textarea wrap="hard" id="txtCarrierInfo" name="txtCarrierInfo" class="multilinetextfield"
                                                                        cols="" rows="5" style="width: 300px"></textarea>
                                                                    <!-- End JPED -->
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                </td>
                                                                <td class="bodycopy">
                                                                </td>
                                                                <td height="8" class="bodycopy">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="1" colspan="5" bgcolor="#9e816e">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="2" colspan="5">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="1" colspan="5" bgcolor="#9e816e">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    &nbsp;
                                                                </td>
                                                                <td height="20" colspan="2" align="center" class="bodyheader">
                                                                    IMPORT INFORMATION
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    &nbsp;
                                                                </td>
                                                                <td class="bodycopy">
                                                                    <span class="style8">Master AWB/BL No.</span></td>
                                                                <td class="bodycopy">
                                                                    <span class="bodyheader"><span class="style8">House AWB/BL No.</span></span></td>
                                                            </tr>
                                                            <tr>
                                                                <td class="style16">
                                                                    &nbsp;
                                                                </td>
                                                                <td class="style17">
                                                                    <input name="txtMAWB"  id="txtMAWB" type="text" maxlength="32" class="shorttextfield" value=""
                                                                        style="width: 140px" /></td>
                                                                <td class="style17">
                                                                    <input name="txtHAWB" id="txtHAWB" type="text" maxlength="32" class="shorttextfield" value=""
                                                                        style="width: 140px" /></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                </td>
                                                                <td height="18" class="bodycopy">
                                                                    <span class="bodylistheader"><strong>Entry-AWB/BL No.</strong></span></td>
                                                                <td height="8" class="bodycopy">
                                                                    <span class="bodylistheader"><strong>Sub AWB/BL No.</strong></span>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                </td>
                                                                <td class="bodycopy">
                                                                    <span class="bodylistheader">
                                                                        <input name="txtEntryBilling" id="txtEntryBilling" type="text" maxlength="32" class="shorttextfield" value=""
                                                                            style="width: 140px" />
                                                                    </span>
                                                                </td>
                                                                <td height="8" class="bodycopy">
                                                                    <span class="bodylistheader">
                                                                        <input name="txtSubHAWB" id="txtSubHAWB" type="text" maxlength="32" class="shorttextfield" value=""
                                                                            style="width: 140px" />
                                                                    </span>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                </td>
                                                                <td height="18" class="bodycopy">
                                                                    <span class="style8">Available Pickup Date</span></td>
                                                                <td height="8" class="bodycopy">
                                                                    <strong>Last Free Day</strong></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                </td>
                                                                <td class="bodycopy">
                                                                    <input name="txtArrDate" id="txtArrDate"  type="text" class="m_shorttextfield " value="" size="16"
                                                                        style="width: 140px" preset="shortdate" />
                                                                    <span style="width: 100px">
                                                                        <input name="txtDepDate" id="txtDepDate" type="hidden" class="m_shorttextfield " value="" size="13"
                                                                            preset="shortdate" />
                                                                    </span>
                                                                </td>
                                                                <td height="8" class="bodycopy">
                                                                    <input name="txtFreeDate" id="txtFreeDate" type="text" class="m_shorttextfield " value="" size="16"
                                                                        style="width: 140px" preset="shortdate" /></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                </td>
                                                                <td height="18" class="bodycopy" colspan="2">
                                                                    <span class="bodyheader">Origin Port </span>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                </td>
                                                                <td valign="top" class="bodycopy" colspan="2">
                                                                    <input type="hidden" id="hDepPortCode" name="hDepPortCode" value="" />
                                                                    <select id="lstDepPort" name="lstDepPort" class="smallselect" onchange="javascript:document.getElementById('hDepPortCode').value = this.value; ">
                                                                        <% For i=0 To port_list.Count-1 %>
                                                                        <option value="<%=port_list(i)("port_code") %>">
                                                                            <%=port_list(i)("port_desc") %>
                                                                        </option>
                                                                        <% Next %>
                                                                    </select>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                </td>
                                                                <td height="18" class="bodycopy" colspan="2">
                                                                    <span class="bodyheader">Destination Port </span>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                </td>
                                                                <td valign="top" class="bodycopy" colspan="2">
                                                                    <input type="hidden" id="hArrPortCode" name="hArrPortCode" value="" />
                                                                    <select id="lstArrPort" name="lstArrPort" class="smallselect" onchange="javascript:document.getElementById('hArrPortCode').value = this.value; ">
                                                                        <% For i=0 To port_list.Count-1 %>
                                                                        <option value="<%=port_list(i)("port_code") %>">
                                                                            <%=port_list(i)("port_desc") %>
                                                                        </option>
                                                                        <% Next %>
                                                                    </select>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="3" style="height: 10px">
                                                                </td>
                                                            </tr>
                                                        </table>
                                                        <!-- ends pickup and deliver -->
                                                    </td>
                                                    <td width="53%" valign="top">
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                                            <tr>
                                                                <td bgcolor="#f4e9e0">
                                                                    &nbsp;
                                                                </td>
                                                                <td width="41%" height="20" bgcolor="#f4e9e0">
                                                                    <span class="style10">Date</span></td>
                                                                <td width="57%" bgcolor="#f4e9e0">
                                                                    <span class="bodyheader style12">Pickup Order No.</span>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    &nbsp;
                                                                </td>
                                                                <td height="18">
                                                                    <input name="txtUpdateDate" id="txtUpdateDate" type="text" class="m_shorttextfield " value="<%=Date() %>"
                                                                        size="16" preset="shortdate" /></td>
                                                                <td>
                                                                    <span class="bodyheader">
                                                                        <input name="txtPickupNumber" id="txtPickupNumber" type="text" class="readonlybold" value="" size="20"
                                                                            readonly="readonly" />
                                                                    </span>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="2" colspan="3" bgcolor="#9e816e">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    &nbsp;
                                                                </td>
                                                                <td height="18" colspan="2">
                                                                    <span class="bodyheader"><strong>Local Delivery or Transfer By </strong></span>(Pickup
                                                                    Order Issued to)</td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    &nbsp;
                                                                </td>
                                                                <td height="18" colspan="2">
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
                                                                <td width="2%">
                                                                    &nbsp;
                                                                </td>
                                                                <td height="18" colspan="2">
                                                                    <span class="bodyheader">Local Delivery or Transfer Reference No.</span></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    &nbsp;
                                                                </td>
                                                                <td height="19">
                                                                    <input name="txtPickupRefNum" id="txtPickupRefNum" maxlength="32" type="text" class="shorttextfieldBold"
                                                                        value="" style="width: 140px" /></td>
                                                                <td>
                                                                    &nbsp;
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="2" colspan="3" bgcolor="#9e816e">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="20" colspan="3">
                                                                    <table width="100%" cellspacing="0" cellpadding="0" style="border-style: none; border-width: 2px;
                                                                        border: thick; border-color: #996600">
                                                                        <tr>
                                                                            <td width="2%">
                                                                                &nbsp;</td>
                                                                            <td width="25%" height="24">
                                                                                <span class="bodyheader">INLAND FREIGHT
                                                                                    <input type="hidden" id="hInlandChargeType" name="hInlandChargeType" value="" />
                                                                                </span>
                                                                            </td>
                                                                            <td width="73%">
                                                                                <span class="bodyheader">
                                                                                    <input type="checkbox" name="chInlandChargeType" value="P" onclick="chInlandChargeType_click('P');" />
                                                                                    PREPAID
                                                                                    <input type="checkbox" name="chInlandChargeType" value="C" onclick="chInlandChargeType_click('C');"
                                                                                        style="margin-left: 14px" />
                                                                                    COLLECT</span></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>
                                                                                &nbsp;</td>
                                                                            <td height="24">
                                                                                <span class="bodyheader style12">C.O.D. AMOUNT </span>
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
                                                                <td height="2" colspan="3">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="1" colspan="3" bgcolor="#9e816e">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    &nbsp;</td>
                                                                <td height="18">
                                                                    <span class="bodyheader">Handling Info.</span></td>
                                                                <td>
                                                                    &nbsp;</td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    &nbsp;</td>
                                                                <td height="18" colspan="2">
                                                                    <textarea name="txtHandling" wrap="hard" cols="50" rows="5" class="multilinetextfield"
                                                                        style="width: 300px" id="txtHandling"></textarea></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    &nbsp;</td>
                                                                <td height="18">
                                                                    <span class="bodylistheader">Route</span></td>
                                                                <td>
                                                                    &nbsp;</td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    &nbsp;</td>
                                                                <td height="18" colspan="2">
                                                                    <textarea name="txtRoute" wrap="hard" id="txtRoute" cols="50" rows="4" class="multilinetextfield"
                                                                        style="width: 300px"></textarea></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    &nbsp;
                                                                </td>
                                                                <td height="18" class="bodyheader">
                                                                    Shipped on Behalf of (Customer)
                                                                </td>
                                                                <td class="bodyheader">
                                                                    &nbsp;</td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    &nbsp;
                                                                </td>
                                                                <td height="18" colspan="2" class="bodyheader">
                                                                    <!-- Start JPED -->
                                                                    <input type="hidden" id="hShipperAcct" name="hShipperAcct" />
                                                                    <div id="lstShipperNameDiv">
                                                                    </div>
                                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                                        <tr>
                                                                            <td>
                                                                                <input type="text" autocomplete="off" id="lstShipperName" name="lstShipperName" value=""
                                                                                    class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                                    border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Shipper','lstShipperNameChange')"
                                                                                    onfocus="initializeJPEDField(this,event);" /></td>
                                                                            <td>
                                                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstShipperName','Shipper','lstShipperNameChange')"
                                                                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                                    border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                                            <td>
                                                                                <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                                    onclick="quickAddClient('hShipperAcct','lstShipperName','txtShipperInfo')" /></td>
                                                                        </tr>
                                                                    </table>
                                                                    <textarea wrap="hard" id="txtShipperInfo" name="txtShipperInfo" class="multilinetextfield"
                                                                        cols="" rows="5" style="width: 300px"></textarea>
                                                                    <!-- End JPED -->
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    &nbsp;
                                                                </td>
                                                                <td height="18" class="bodyheader">
                                                                    <span class="bodylistheader"><strong>Customer Reference No.</strong></span></td>
                                                                <td>
                                                                    <span class="bodyheader">Contained Hazardous Goods</span>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="height: 20px">
                                                                    &nbsp;
                                                                </td>
                                                                <td class="bodyheader" style="height: 20px">
                                                                    <span class="bodylistheader">
                                                                        <input name="txtCustomerRef" id="txtCustomerRef" type="text" maxlength="32" class="shorttextfield" value=""
                                                                            size="32" style="width: 140px" />
                                                                    </span>
                                                                </td>
                                                                <td style="height: 20px">
                                                                    <input type="hidden" name="hDangerGoods" id="hDangerGoods" value="" />
                                                                    <input type="checkbox" name="chkDangerGoods" value="Y" 
                                                                        onclick="chkDangerClick('Y')" />Yes
                                                                    <input type="checkbox" name="chkDangerGoods" value="N" style="margin-left: 17px"
                                                                        onclick="chkDangerClick('N')" />No</td>
                                                                        
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                            <table width="86%" border="0" cellpadding="2" cellspacing="0" bordercolor="#9e816e"
                                                class="border1px">
                                                <tr bgcolor="#f4e9e0">
                                                    <td width="1%" height="19">
                                                        &nbsp;
                                                    </td>
                                                    <td bgcolor="#f4e9e0">
                                                        <img src="/ASP/Images/required.gif" align="absbottom">
                                                        <strong>No. of Packages</strong></td>
                                                    <td width="45%">
                                                        <strong>Description of Articles, Special Marks &amp; Exceptions </strong>
                                                    </td>
                                                    <td>
                                                        <strong>Gross Weight</strong></td>
                                                    <td>
                                                        <strong>Dimension</strong></td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        &nbsp;
                                                    </td>
                                                    <td align="left" valign="top">
                                                        <textarea name="txtPieces" id="txtPieces" wrap="hard" cols="16" rows="7" class="multilinetextfield"></textarea></td>
                                                    <td valign="top">
                                                        <textarea name="txtDesc3" wrap="hard" cols="50" rows="7" class="multilinetextfield"
                                                            style="width: 350px" id="txtDesc3"></textarea></td>
                                                    <td align="left" valign="top">
                                                        <input name="txtGrossWt" type="text" class="shorttextfield" style="behavior: url(../include/igNumDotChkLeft.htc)"
                                                            value="" size="13" id="txtGrossWt" />
                                                        <select name="lstScale1" id="lstScale1" class="smallselect" onchange="convertKG_LB(0)" 
                                                            id="lstScale1">
                                                            <option value="KG">KG</option>
                                                            <option value="LB">LB</option>
                                                        </select>
                                                    </td>
                                                    <td valign="top">
                                                        <textarea id="txtDimension" name="txtDimension" rows="6" cols="30" class="multilinetextfield"></textarea>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td height="8">
                                                    </td>
                                                    <td height="8" align="left" valign="top">
                                                    </td>
                                                    <td height="8" valign="top">
                                                    </td>
                                                    <td height="8" align="left" valign="top">
                                                    </td>
                                                    <td>
                                                    </td>
                                                </tr>
                                            </table>
                                            <br />
                                            <table width="86%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                    <td height="30" align="right" valign="middle">
                                                        <span class="bodyheader">Issued by (PER)</span>
                                                        <input name="txtEmployee" type="text" class="shorttextfield" value="" size="32" 
                                                            id="txtEmployee" /></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr align="center">
                                        <td height="1" valign="middle" bgcolor="#9e816e" class="bodycopy">
                                        </td>
                                    </tr>
                                    <tr align="center">
                                        <td height="8" valign="middle" bgcolor="#e5cfbf" class="bodycopy">
                                            <table width="98%" border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td width="26%">
                                                        &nbsp;
                                                    </td>
                                                    <td width="48%" align="center" valign="middle">
                                                        <input type="image" src="../images/button_save_medium.gif" onclick="saveForm(); return false;"
                                                            width="46" height="18" name="bSave" style="cursor: pointer" /></td>
                                                    <td width="13%" align="right" valign="middle">
                                                        <a href="/ASP/air_import/delivery_order.asp">
                                                            <img src="/ASP/Images/button_new.gif" border="0" style="cursor: hand"></a></td>
                                                    <td width="13%" align="right" valign="middle">
                                                        <input type="image" src="../images/button_delete_medium.gif" onclick="deleteThis(); return false;"
                                                            style="cursor: pointer" /></td>
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
                    <div id="print">
                        <a href="javascript:;" onclick="viewPDF();" style="cursor: hand;">
                            <img src="/ASP/Images/icon_printer.gif" align="absbottom">Pickup Order
                            Form</a></div>
                </td>
            </tr>
        </table>
        <br>
    </form>
</body>
<!-- #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
