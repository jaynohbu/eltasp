<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/Header.asp" -->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Pickup Order Transfer</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" language="javascript" src="../ajaxFunctions/ajax.js"></script>

    <script type="text/javascript" src="../include/JPED.js"></script>

    <script type="text/jscript">
        function SaveExportType(){
            var vSearchType = document.getElementById("lstSearchType").value;
            var vSearchNum = document.getElementById("hSearchNum").value;
            if(vSearchType != ""){
                
                if((vSearchType == "air_master" || vSearchType == "ocean_master") && vSearchNum == ""){
                    alert("Please, select master AWB/BL number");
                }
                else{
                    var returnArray = new Array();
                    returnArray[0] = vSearchType;
                    returnArray[1] = vSearchNum;
                    window.returnValue = returnArray
                    window.close();
                }
            }
            else{
                alert("Please, select a bill type");
            }
        }
        
        function lstSearchNumChange(argV,argL){
            var divObj = document.getElementById("lstSearchNumDiv");
            
            document.getElementById("hSearchNum").value = argV;
            document.getElementById("lstSearchNum").value = argL;
            
            divObj.style.visibility = "hidden";
            divObj.style.position = "absolute";
		    divObj.innerHTML = "";
        }

        function selectSearchType(){
            var oSearchNumTbl = document.getElementById("tblSearchNum");
            var oSearchType = document.getElementById("lstSearchType");
            
            if(oSearchType.value == "air_master" || oSearchType.value == "ocean_master"){
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
                    var url = "/IFF_MAIN/ASP/ajaxFunctions/ajax2_mawb_header.asp?mode=list&mtype=IBN&qStr=" + qStr;
                    FillOutJPED(obj,url,changeFunction,vHeight);
                }
                if(oSearchType == "ocean_master"){
                    var url = "/IFF_MAIN/ASP/ajaxFunctions/ajax2_mawb_header.asp?mode=list&mtype=OBN&qStr=" + qStr;
                    FillOutJPED(obj,url,changeFunction,vHeight);
                }
            }

        }
        
        function searchNumFillAll(objName,eType,changeFunction,vHeight){
            var obj = document.getElementById(objName);
            var oSearchType = document.getElementById("lstSearchType").value;
            
            if(oSearchType == "air_master"){
                var url = "/IFF_MAIN/ASP/ajaxFunctions/ajax2_mawb_header.asp?mode=list&mtype=IBN";
                FillOutJPED(obj,url,changeFunction,vHeight);
            }
            
            if(oSearchType == "ocean_master"){
                var url = "/IFF_MAIN/ASP/ajaxFunctions/ajax2_mawb_header.asp?mode=list&mtype=OBN";
                FillOutJPED(obj,url,changeFunction,vHeight);
            }
        }
    </script>

</head>
<body style="margin: 5px">
    <form id="form1" action="">
        <table cellspacing="0" cellpadding="0" border="0" width="100%">
            <tr><td style="height:5px"></td></tr>
            <tr>
                <td class="bodyheader">
                    <div style="font-size:13px">Pickup Order Data Transfer</div>
                </td>
            </tr>
            <tr><td style="height:10px"></td></tr>
            <tr>
                <td>
                    <span class="select">Select Export Type</span>
                </td>
            </tr>
            <tr><td style="height:5px"></td></tr>
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
            <tr><td style="height:10px"></td></tr>
            <tr>
                <td>
                    <!-- Start JPED -->
                    <input type="hidden" id="hSearchNum" name="hSearchNum" />
                    <div id="lstSearchNumDiv">
                    </div>
                    <table cellpadding="0" cellspacing="0" border="0" id="tblSearchNum" style="visibility:hidden">
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
                <td style="height: 115px"></td>
            </tr>
            <tr>
                <td align="center">
                    <table cellspacing="0" cellpadding="0" border="0">
                        <tr>
                            <td>
                                <input type="image" src="../images/button_done.gif" onclick="javascript:SaveExportType(); return false;" /></td>
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
