<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/Header.asp" -->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Shipout Transfer</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" language="javascript" src="../ajaxFunctions/ajax.js"></script>

    <script type="text/javascript" src="../include/JPED.js"></script>

    <script type="text/jscript">
                    
        function ReturnValues(){
            var returnArray = new Array();
            
            if(document.getElementById("hSearchNum").value != "" 
                && document.getElementById("hSearchNum").value != "0"){

                returnArray[0] = document.getElementById("hMasterBillNo").value;
                returnArray[1] = document.getElementById("hHouseBillNo").value;
                returnArray[2] = document.getElementById("hFileNo").value;
                returnArray[3] = document.getElementById("hAirOcean").value;
                returnArray[4] = document.getElementById("hImportExport").value;
                window.returnValue = returnArray;
                window.close();
            }
            else{
                alert("Please, select a bill type and number.");
            }
        }
        
        function lstSearchNumChange(argV,argL){
        
            var divObj = document.getElementById("lstSearchNumDiv");
            var xmlObj = null;
            
            divObj.style.visibility = "hidden";
            divObj.style.position = "absolute";
		    divObj.innerHTML = "";
		    
		    document.getElementById("hSearchNum").value = argV;
		    document.getElementById("lstSearchNum").value = argL;
		    
		    var oSearchType = document.getElementById("lstSearchType").value;
		    
		    var url = "/IFF_MAIN/ASP/ajaxFunctions/ajax2_mawb_header.asp?mode=view&bill=" 
		        + argV + "&stype=" + oSearchType;

            new ajax.xhr.Request('GET','',url,loadSearchResult,'','','','');
		    
        }
        
        function loadSearchResult(req,field,tmpVal,tWidth,tMaxLength,url){  
            if (req.readyState == 4){   
                if (req.status == 200){
                    var xmlObj = req.responseXML;
                    var oSearchType = document.getElementById("lstSearchType").value;
                    try{
                        setField("master_num","hMasterBillNo",xmlObj);
                        setField("house_num","hHouseBillNo",xmlObj);
                        setField("file_num","hFileNo",xmlObj);
                        if(oSearchType == "air_master" || oSearchType == "air_house" || oSearchType == "domestic_house"){
                            document.getElementById("hAirOcean").value = "A";
                        }
                        else if(oSearchType == "ocean_master" || oSearchType == "ocean_house"){
                            document.getElementById("hAirOcean").value = "O";
                        }
                        document.getElementById("hImportExport").value = "E";
                    }catch(err){}
                }
            }
        }
                    
        function selectSearchType(){
            var oSearchNumTbl = document.getElementById("tblSearchNum");
            var oSearchType = document.getElementById("lstSearchType");
            
            if(oSearchType.value != ""){
                oSearchNumTbl.style.visibility = "visible";
            }
            else{
                oSearchNumTbl.style.visibility = "hidden";
            }
            document.getElementById("hSearchNum").value = "";
        }
        
        function searchNumFill(obj,eType,changeFunction,vHeight){
            var qStr = obj.value;
            var keyCode = window.event.keyCode;
            var oSearchType = document.getElementById("lstSearchType").value;

            if(qStr != "" && keyCode != 229 && keyCode != 27){
                if(oSearchType == "air_master"){
                    var url = "/IFF_MAIN/ASP/ajaxFunctions/ajax2_mawb_header.asp?mode=list&mtype=IBY-DIRECT&qStr=" + qStr;
                    FillOutJPED(obj,url,changeFunction,vHeight);
                }
                if(oSearchType == "ocean_master"){
                    var url = "/IFF_MAIN/ASP/ajaxFunctions/ajax2_mawb_header.asp?mode=list&mtype=OBY-DIRECT&qStr=" + qStr;
                    FillOutJPED(obj,url,changeFunction,vHeight);
                }
                if(oSearchType == "air_house"){
                    var url = "/IFF_MAIN/ASP/ajaxFunctions/ajax2_mawb_header.asp?mode=list&htype=AECON&qStr=" + qStr;
                    FillOutJPED(obj,url,changeFunction,vHeight);
                }
                if(oSearchType == "ocean_house"){
                    var url = "/IFF_MAIN/ASP/ajaxFunctions/ajax2_mawb_header.asp?mode=list&htype=OECON&qStr=" + qStr;
                    FillOutJPED(obj,url,changeFunction,vHeight);
                }
                if(oSearchType == "domestic_house"){
                    var url = "/IFF_MAIN/ASP/ajaxFunctions/ajax2_mawb_header.asp?mode=list&htype=DOCON&qStr=" + qStr;
                    FillOutJPED(obj,url,changeFunction,vHeight);
                }
            }
        }
        
        function searchNumFillAll(objName,eType,changeFunction,vHeight){
            var obj = document.getElementById(objName);
            var oSearchType = document.getElementById("lstSearchType").value;
            
            if(oSearchType == "air_master"){
                var url = "/IFF_MAIN/ASP/ajaxFunctions/ajax2_mawb_header.asp?mode=list&mtype=IBY-DIRECT";
                FillOutJPED(obj,url,changeFunction,vHeight);
            }
            if(oSearchType == "ocean_master"){
                var url = "/IFF_MAIN/ASP/ajaxFunctions/ajax2_mawb_header.asp?mode=list&mtype=OBY-DIRECT";
                FillOutJPED(obj,url,changeFunction,vHeight);
            }
            if(oSearchType == "air_house"){
                    var url = "/IFF_MAIN/ASP/ajaxFunctions/ajax2_mawb_header.asp?mode=list&htype=AECON&qStr=";
                    FillOutJPED(obj,url,changeFunction,vHeight);
            }
            if(oSearchType == "ocean_house"){
                    var url = "/IFF_MAIN/ASP/ajaxFunctions/ajax2_mawb_header.asp?mode=list&htype=OECON&qStr=";
                    FillOutJPED(obj,url,changeFunction,vHeight);
            }
            if(oSearchType == "domestic_house"){
                    var url = "/IFF_MAIN/ASP/ajaxFunctions/ajax2_mawb_header.asp?mode=list&htype=DOCON&qStr=";
                    FillOutJPED(obj,url,changeFunction,vHeight);
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
        
    </script>

</head>
<body style="margin: 5px">
    <form id="form1" action="">
        <table cellspacing="0" cellpadding="0" border="0" width="100%">
            <tr>
                <td style="height: 5px">
                </td>
            </tr>
            <tr>
                <td class="bodyheader">
                    <div style="font-size: 13px">
                        Set Bill Number</div>
                </td>
            </tr>
            <tr>
                <td style="height: 10px">
                </td>
            </tr>
            <tr>
                <td>
                    <span class="select">Select Export Type</span>
                </td>
            </tr>
            <tr>
                <td style="height: 5px">
                </td>
            </tr>
            <tr>
                <td valign="top">
                    <select id="lstSearchType" class="bodyheader" style="width: 150px" onchange="javascript:selectSearchType();">
                        <option value=""></option>
                        <option value="air_house">Air House AWB</option>
                        <option value="air_master">Air Master AWB</option>
                        <option value="ocean_house">Ocean House B/L</option>
                        <option value="ocean_master">Ocean Master B/L</option>
                        <option value="domestic_house">Domestic B/L</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td style="height: 10px">
                </td>
            </tr>
            <tr>
                <td>
                    <!-- Start JPED -->
                    <input type="hidden" id="hSearchNum" name="hSearchNum" />
                    <div id="lstSearchNumDiv">
                    </div>
                    <table cellpadding="0" cellspacing="0" border="0" id="tblSearchNum" style="visibility: hidden">
                        <tr>
                            <td>
                                <input type="text" autocomplete="off" id="lstSearchNum" name="lstSearchNum" value=""
                                    class="shorttextfield" style="width: 270px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                    border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="searchNumFill(this,'A','lstSearchNumChange',130);"
                                    onfocus="initializeJPEDField(this);" /></td>
                            <td>
                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="searchNumFillAll('lstSearchNum','A','lstSearchNumChange',130);"
                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                    border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                        </tr>
                    </table>
                    <!-- End JPED -->
                </td>
            </tr>
            <tr>
                <td style="height: 115px">
                    <input type="hidden" id="hMasterBillNo" />
                    <input type="hidden" id="hHouseBillNo" />
                    <input type="hidden" id="hFileNo" />
                    <input type="hidden" id="hAirOcean" />
                    <input type="hidden" id="hImportExport" />
                </td>
            </tr>
            <tr>
                <td align="center">
                    <table cellspacing="0" cellpadding="0" border="0">
                        <tr>
                            <td>
                                <input type="image" src="../images/button_done.gif" onclick="javascript:ReturnValues(); return false;" /></td>
                            <td style="width: 15px">
                            </td>
                            <td>
                                <input type="image" src="../images/button_closebooking.gif" onclick="javascript:window.close(); return false;" /></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
