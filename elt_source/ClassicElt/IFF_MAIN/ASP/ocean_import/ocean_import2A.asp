<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <title>EDT Deconsolidation</title>
    <style type="text/css">
        body {
	        margin-left: 0px;
	        margin-right: 0px;
	        margin-bottom: 0px;
        }
    </style>

    <script type="text/javascript" language="javascript" src="../ajaxFunctions/ajax.js"></script>

    <script type="text/javascript" src="../include/JPED.js"></script>

    <script type="text/javascript" src="../Include/JPTableDOM.js"></script>

    <!--  #INCLUDE FILE="../include/connection.asp" -->
    <!--  #INCLUDE FILE="../include/header.asp" -->
    <!--  #INCLUDE FILE="../include/GOOFY_Util_fun.inc" -->
    <!--  #INCLUDE FILE="../include/Goofy_data_manager.inc" -->
    <!--  #INCLUDE FILE="../include/aspFunctions_import.inc" -->
    <%
    
    Dim i, vDataTable, vMAWB, vSec, vMode
    
    Call GET_ALL_PARAMETERS
    
    If vMode = "save" Then
        Call UPDATE_EDT_MAWB
        Call UPDATE_EDT_HAWB
        eltConn.Close() 
        Set eltConn = Nothing
        Response.Redirect("./ocean_import2.asp?edit=yes&MAWB=" & vMAWB & "&SEC=" & vSec)
    Else 
        Call GET_PORT_LIST
        Call GET_ALL_DATA
    End If
    
    Sub UPDATE_EDT_MAWB
        Dim SQL, rs
        Set rs = Server.CreateObject("ADODB.RecordSet")
        SQL = "SELECT * FROM import_mawb WHERE iType='O' AND mawb_num=N'" & vMAWB & "' AND sec=" & vSec _
            & " AND elt_account_number=" & elt_account_number
        
        rs.Open SQL,eltConn,adOpenStatic,adLockPessimistic,adCmdText
        If Not rs.EOF And Not rs.BOF Then
            rs("carrier") = Request.Form("lstCarrierName")
            rs("carrier_code") = Request.Form("hCarrierAcct")
            rs("agent_org_acct") = Request.Form("hFFAgentAcct")
            rs("export_agent_name") = Request.Form("lstFFAgent")
            rs("dep_code") = Request.Form("lstDepPort")
            rs("dep_port") = GetPortCity(Request.Form("lstDepPort"),elt_account_number)
            rs("arr_code") = Request.Form("lstArrPort")
            rs("arr_port") = GetPortCity(Request.Form("lstArrPort"),elt_account_number)
            rs("processed") = "Y"
            rs.Update()
        End If
        rs.Close()
        Set rs = Nothing
    End Sub
    
    Sub UPDATE_EDT_HAWB
        Dim SQL, rs
        Set rs = Server.CreateObject("ADODB.RecordSet")
        SQL = "SELECT * FROM import_hawb WHERE iType='O' AND mawb_num=N'" & vMAWB & "' AND sec=" & vSec _
            & " AND elt_account_number=" & elt_account_number
        
        rs.Open SQL,eltConn,adOpenStatic,adLockPessimistic,adCmdText
        Do While Not rs.EOF And Not rs.BOF
            rs("carrier_code") = Request.Form("hCarrierAcct")
            rs("agent_org_acct") = Request.Form("hFFAgentAcct")
            rs("dep_code") = Request.Form("lstDepPort")
            rs("dep_port") = GetPortCity(Request.Form("lstDepPort"),elt_account_number)
            rs("arr_code") = Request.Form("lstArrPort")
            rs("arr_port") = GetPortCity(Request.Form("lstArrPort"),elt_account_number)
            rs.Update()
            rs.MoveNext()
        Loop
        rs.Close()
        Set rs = Nothing
    End Sub
    
    Sub GET_ALL_PARAMETERS
        vMAWB = Request.QueryString("MAWB")
        vSec = Request.QueryString("SEC")
        vMode = checkBlank(Request.QueryString("mode"),"view")
    End Sub
    
    Sub GET_ALL_DATA
        Dim SQL, feData
        Set feData = new DataManager
        SQL = "SELECT * FROM import_mawb WHERE iType='O' AND agent_elt_acct<>0 AND processed='N' " _
            & "AND mawb_num=N'" & vMAWB & "' AND sec=" & vSec & " AND elt_account_number=" & elt_account_number
        feData.SetDataList(SQL)
        Set vDataTable = feData.GetDataList()(0)
    End Sub
    
    Function GetPortCity(vPortCode,vEltAcct)
        Dim result,sqlTxt,rsObj
        Set rsObj = Server.CreateObject("ADODB.Recordset")
        result = ""
        sqlTxt= "SELECT ISNULL(port_desc,port_city) AS port_name FROM port WHERE elt_account_number=" _
            & vEltAcct & " AND port_code LIKE N'" & vPortCode & "'"
	    rsObj.Open sqlTxt, eltConn, , , adCmdText
	    If Not rsObj.EOF And Not rsObj.BOF Then
	        result = rsObj("port_name").value
	    End If
	    GetPortCity = result
        rsObj.Close()
    End Function 
    
    %>

    <script type="text/jscript">
    
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
		    divObj.innerHTML = "";
        }
        function lstFFAgentChange(orgNum,orgName)
        {
            var hiddenObj = document.getElementById("hFFAgentAcct");
            var txtObj = document.getElementById("lstFFAgent");
            var divObj = document.getElementById("lstFFAgentDiv");

            hiddenObj.value = orgNum;
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
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
        
            xmlHTTP.open("GET",encodeURI(url),false); 
            xmlHTTP.send();
            
            return xmlHTTP.responseText; 
        }
        function btnSaveClick(){
            var oCarrierOrigin = document.getElementById("txtCarrierOrigin");
            var oCarrierNew = document.getElementById("hCarrierAcct");
            var oAgentOrigin = document.getElementById("txtAgentOrigin");
            var oAgentNew = document.getElementById("hFFAgentAcct");
            var oDepPortOrigin = document.getElementById("txtDepPortOrigin");
            var oDepPortNew =document.getElementById("lstDepPort");
            var oArrPortOrigin = document.getElementById("txtArrPortOrigin");
            var oArrPortNew =document.getElementById("lstArrPort");
            
            if(oCarrierOrigin.value != "" && oCarrierNew.value == ""){
                alert("Please, select a carrier to save.");
                return false;
            }
            if(oAgentOrigin.value != "" && oAgentNew.value == ""){
                alert("Please, select a agent to save.");
                return false;
            }
            if(oDepPortOrigin.value != "" && oDepPortNew.value == ""){
                alert("Please, select a departing port to save.");
                return false;
            }
            if(oArrPortOrigin.value != "" && oArrPortNew.value == ""){
                alert("Please, select a arriving port to save.");
                return false;
            }
            
            var oForm = document.getElementById("form1");
            oForm.action = "ocean_import2A.asp?mode=save&MAWB=<%=Server.URLEncode(vMAWB) %>&SEC=<%=vSec %>";
            oForm.target = "_self";
            oForm.method = "post";
            oForm.submit();
        }
    </script>

</head>
<body>
    <form id="form1" action="">
        <div style="text-align: center">
            <table width="95%" border="0" cellpadding="2" cellspacing="0">
                <tr>
                    <td class="pageheader">
                        Electronic Data Transfer (EDT)
                    </td>
                </tr>
            </table>
            <br />
            <table width="95%" border="0" cellpadding="0" cellspacing="0" style="border: solid 1px #909EB0">
                <tr style="background-color: #CFD6DF">
                    <td align="center" valign="middle" class="bodyheader" style="height: 24px">
                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td align="center">
                                    <img height="18" style="cursor: hand" onclick="javascript:btnSaveClick();" src="../images/button_save_medium.gif"
                                        width="46" alt="" />
                                </td>
                            </tr>
                            <tr style="height: 1px; background-color: #909EB0">
                                <td>
                                </td>
                            </tr>
                            <tr>
                                <td style="background-color: #f3f3f3; text-align: center" class="bodyheader">
                                    <br />
                                    <br />
                                    <table width="75%" height="28" border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td align="right" valign="middle" class="bodyheader">
                                                <img src="/iff_main/ASP/Images/required.gif" align="absbottom" alt="" />Required
                                                field</td>
                                        </tr>
                                    </table>
                                    <table width="75%" border="0" cellpadding="2" cellspacing="0" style="border: solid 1px #909EB0">
                                        <tr style="background-color: #CFD6DF" class="bodyheader">
                                            <td style="width: 5px">
                                            </td>
                                            <td>
                                                <img src="/iff_main/ASP/Images/required.gif" align="absbottom" alt="" />Master B/L
                                                No.</td>
                                            <td>
                                                File No.</td>
                                            <td>
                                            </td>
                                            <td style="width: 5px">
                                            </td>
                                        </tr>
                                        <tr style="background-color: #ffffff; height: 30px">
                                            <td>
                                            </td>
                                            <td>
                                                <table cellpadding="0" cellspacing="0" border="0">
                                                    <tr>
                                                        <td>
                                                            <input name="txtMAWB" type="text" value="<%=vDataTable("mawb_num") %>" size="30"
                                                                class="d_shorttextfield" readonly="readonly" /></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td>
                                                <input name="txtFileNo" class="d_shorttextfield" size="20" value="<%=vDataTable("file_no") %>"
                                                    readonly="readonly" />
                                            </td>
                                            <td>
                                            </td>
                                            <td>
                                            </td>
                                        </tr>
                                        <tr style="height: 1px; background-color: #909EB0">
                                            <td colspan="5">
                                            </td>
                                        </tr>
                                        <tr style="background-color: #ffffff" class="bodyheader">
                                            <td>
                                            </td>
                                            <td colspan="2">
                                                Carrier</td>
                                            <td>
                                                <img src="/iff_main/ASP/Images/required.gif" align="absbottom" alt="" />Agent
                                            </td>
                                            <td>
                                            </td>
                                        </tr>
                                        <tr style="background-color: #ffffff" class="bodycopy">
                                            <td>
                                            </td>
                                            <td colspan="2">
                                                <input type="text" class="d_shorttextfield" id="txtCarrierOrigin" style="width: 300px"
                                                    readonly="readonly" value="<%=vDataTable("carrier") %>" /></td>
                                            <td>
                                                <input type="text" class="d_shorttextfield" id="txtAgentOrigin" style="width: 300px"
                                                    readonly="readonly" value="<%=vDataTable("export_agent_name") %>" /></td>
                                            <td>
                                            </td>
                                        </tr>
                                        <tr style="background-color: #ffffff">
                                            <td>
                                            </td>
                                            <td colspan="2">
                                                <!-- Start JPED -->
                                                <input type="hidden" id="hCarrierCode" name="hCarrierCode" value="" />
                                                <input type="hidden" id="hCarrierAcct" name="hCarrierAcct" value="" />
                                                <div id="lstCarrierNameDiv">
                                                </div>
                                                <table cellpadding="0" cellspacing="0" border="0">
                                                    <tr>
                                                        <td>
                                                            <input type="text" autocomplete="off" id="lstCarrierName" name="lstCarrierName" value=""
                                                                class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Carrier','lstCarrierNameChange')"
                                                                onfocus="initializeJPEDField(this);" /></td>
                                                        <td>
                                                            <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstCarrierName','Carrier','lstCarrierNameChange')"
                                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                        <td>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <!-- End JPED -->
                                            </td>
                                            <td>
                                                <!-- Start JPED -->
                                                <input type="hidden" id="hFFAgentAcct" name="hFFAgentAcct" value="" />
                                                <div id="lstFFAgentDiv">
                                                </div>
                                                <table cellpadding="0" cellspacing="0" border="0" id="tblAgent">
                                                    <tr>
                                                        <td>
                                                            <input type="text" autocomplete="off" id="lstFFAgent" name="lstFFAgent" value=""
                                                                class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Agent','lstFFAgentChange')"
                                                                onfocus="initializeJPEDField(this);" /></td>
                                                        <td>
                                                            <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstFFAgent','Agent','lstFFAgentChange')"
                                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                        <td>
                                                            <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                onclick="quickAddClient('hFFAgentAcct','lstFFAgent','hFFAgentInfo')" /></td>
                                                    </tr>
                                                </table>
                                                <!-- End JPED -->
                                            </td>
                                            <td>
                                            </td>
                                        </tr>
                                        <tr style="background-color: #ffffff" class="bodyheader">
                                            <td>
                                            </td>
                                            <td colspan="2">
                                                Port of Departure</td>
                                            <td>
                                                Port of Arrival
                                            </td>
                                            <td>
                                            </td>
                                        </tr>
                                        <tr style="background-color: #ffffff" class="bodycopy">
                                            <td>
                                            </td>
                                            <td colspan="2">
                                                <input type="text" class="d_shorttextfield" id="txtDepPortOrigin" size="3" value="<%=vDataTable("dep_code") %>" />
                                                <input type="text" class="d_shorttextfield" readonly="readonly" size="35" id="txtDepPortOriginDesc"
                                                    value="<%=GetPortCity(vDataTable("dep_code"),vDataTable("agent_elt_acct")) %>" /></td>
                                            <td>
                                                <input type="text" class="d_shorttextfield" id="txtArrPortOrigin" size="3" value="<%=vDataTable("arr_code") %>" />
                                                <input type="text" class="d_shorttextfield" readonly="readonly" size="35" id="txtArrPortOriginDesc"
                                                    value="<%=GetPortCity(vDataTable("arr_code"),vDataTable("agent_elt_acct")) %>" /></td>
                                            <td>
                                            </td>
                                        </tr>
                                        <tr style="background-color: #ffffff" class="bodycopy">
                                            <td>
                                            </td>
                                            <td colspan="2">
                                                <select name="lstDepPort" id="lstDepPort" class="smallselect" style="width: 250px">
                                                    <% for i=0 to port_list.count-1 %>
                                                    <option value="<%=port_list(i)("port_code")%>">
                                                        <%= port_list(i)("port_desc") %>
                                                    </option>
                                                    <% next %>
                                                </select>
                                            </td>
                                            <td>
                                                <select name="lstArrPort" id="lstArrPort" class="smallselect" style="width: 250px">
                                                    <% for i=0 to port_list.count-1 %>
                                                    <option value="<%=port_list(i)("port_code")%>">
                                                        <%= port_list(i)("port_desc") %>
                                                    </option>
                                                    <% next %>
                                                </select>
                                            </td>
                                            <td>
                                            </td>
                                        </tr>
                                        <tr style="height: 5px; background-color: #ffffff">
                                            <td colspan="5">
                                            </td>
                                        </tr>
                                    </table>
                                    <br />
                                    <br />
                                </td>
                            </tr>
                            <tr style="height: 1px; background-color: #909EB0">
                                <td>
                                </td>
                            </tr>
                            <tr>
                                <td align="center">
                                    <img height="18" style="cursor: hand" onclick="javascript:btnSaveClick();" src="../images/button_save_medium.gif"
                                        width="46" alt="" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
<% 
    eltConn.Close() 
    Set eltConn = Nothing
%>
</html>
