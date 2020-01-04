<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% Option Explicit %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Pre-Alert</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <!--  #INCLUDE FILE="../include/connection.asp" -->
    <!--  #INCLUDE FILE="../include/header.asp" -->
     <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
    <!--  #INCLUDE FILE="../include/GOOFY_data_manager.inc" -->
    <!--  #INCLUDE FILE="../include/GOOFY_Util_fun.inc" -->
    <!--  #INCLUDE FILE="../include/SaveBinaryFile.asp" -->
    <%
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"

    Dim vBillType, vBillNum, vMode, vDBA
    Dim feData, SQL, i, j, aAllData, vBookingNum, vTotalPcs, vLabelStart
    
    vBillType = Request.QueryString("type")
    vBillNum = Request.QueryString("no")
    vMode = Request.QueryString("mode")
    vTotalPcs = 0
    
    eltConn.BeginTrans()
    vDBA = GetSQLResult("select dba_name from agent where elt_account_number=" & elt_account_number, "dba_name")
    Set feData = new DataManager
    Set aAllData = Server.CreateObject("System.Collections.ArrayList")
    
    If vMode = "search" Then
        PerformDataSearch()
        feData.SetDataList(SQL)
        Set aAllData = feData.getDataList
        If aAllData.Count > 0 Then
            vBookingNum = aAllData(0)("booking_num")
        End If
    End If
    eltConn.CommitTrans()
    
    Sub PerformDataSearch
        If vBillType = "house" Then
            SQL = "select b.shipper_name,b.shipper_acct_num,b.consignee_name,b.consignee_acct_num,a.carrier_desc,a.origin_port_id,a.dest_port_id,a.dest_port_location,b.booking_num,b.mbol_num,b.hbol_num,b.pieces," _
                & "(select sum(pieces) FROM hbol_master WHERE elt_account_number=b.elt_account_number AND booking_num=b.booking_num) as total_pieces," _
                & "(select isnull(sum(pieces),0)+1 FROM hbol_master WHERE elt_account_number=b.elt_account_number AND booking_num=b.booking_num and hbol_num<b.hbol_num) as label_start," _
                & "1 as label_no,'N' as isDirect " _
                & "FROM ocean_booking_number a LEFT OUTER JOIN hbol_master b ON (a.elt_account_number=b.elt_account_number AND a.booking_num=b.booking_num) " _
                & "WHERE a.elt_account_number=" & elt_account_number & " AND b.booking_num=(SELECT booking_num FROM hbol_master " _
                & "WHERE elt_account_number=" & elt_account_number & " AND hbol_num=N'" & vBillNum & "') ORDER BY b.hbol_num"
        Elseif vBillType = "master" Then
            SQL = "select b.shipper_name,b.shipper_acct_num,b.consignee_name,b.consignee_acct_num,a.carrier_desc,a.origin_port_id,a.dest_port_id,a.dest_port_location,b.booking_num,b.mbol_num,b.hbol_num,b.pieces," _
                & "(select sum(pieces) FROM hbol_master WHERE elt_account_number=b.elt_account_number AND booking_num=b.booking_num) as total_pieces," _
                & "(select isnull(sum(pieces),0)+1 FROM hbol_master WHERE elt_account_number=b.elt_account_number AND booking_num=b.booking_num and hbol_num<b.hbol_num) as label_start," _
                & "1 as label_no,'N' as isDirect " _
                & "FROM ocean_booking_number a LEFT OUTER JOIN hbol_master b ON (a.elt_account_number=b.elt_account_number AND a.booking_num=b.booking_num) " _
                & "WHERE a.elt_account_number=" & elt_account_number & " AND b.booking_num=N'" & vBillNum & "' AND ISNULL(b.booking_num,'')<>'' ORDER BY b.hbol_num"
            '// direct shipment 
            If Not IsDataExist(SQL) Then
                SQL = "select b.shipper_name,b.shipper_acct_num,b.consignee_name,b.consignee_acct_num,a.carrier_desc,a.origin_port_id,a.dest_port_id,a.dest_port_location,b.booking_num,b.mbol_num,'' as hbol_num,b.pieces,b.pieces as total_pieces,1 as label_no,1 as label_start,'Y' as isDirect " _
                    & "FROM ocean_booking_number a LEFT OUTER JOIN mbol_master b ON (a.elt_account_number=b.elt_account_number AND a.booking_num=b.booking_num) " _
                    & "WHERE a.elt_account_number=" & elt_account_number & " AND a.booking_num=N'" & vBillNum & "'"
            End If
        Elseif vBillType = "file" Then
            SQL = "select b.shipper_name,b.shipper_acct_num,b.consignee_name,b.consignee_acct_num,a.carrier_desc,a.origin_port_id,a.dest_port_id,a.dest_port_location,b.booking_num,b.mbol_num,b.hbol_num,b.pieces," _
                & "(select sum(pieces) FROM hbol_master WHERE elt_account_number=b.elt_account_number AND booking_num=b.booking_num) as total_pieces," _
                & "(select isnull(sum(pieces),0)+1 FROM hbol_master WHERE elt_account_number=b.elt_account_number AND booking_num=b.booking_num and hbol_num<b.hbol_num) as label_start," _
                & "1 as label_no,'N' as isDirect " _
                & "FROM ocean_booking_number a LEFT OUTER JOIN hbol_master b ON (a.elt_account_number=b.elt_account_number AND a.booking_num=b.booking_num) " _
                & "WHERE a.elt_account_number=" & elt_account_number & " AND a.file_no=N'" & vBillNum & "' AND ISNULL(b.booking_num,'')<>'' ORDER BY b.hbol_num"
            '// direct shipment 
            If Not IsDataExist(SQL) Then
                SQL = "select b.shipper_name,b.shipper_acct_num,b.consignee_name,b.consignee_acct_num,a.carrier_desc,a.origin_port_id,a.dest_port_id,a.dest_port_location,b.booking_num,b.mbol_num,'' as hbol_num,b.pieces,b.pieces as total_pieces,1 as label_start,1 as label_no,1 as label_start,'Y' as isDirect " _
                    & "FROM ocean_booking_number a LEFT OUTER JOIN mbol_master b ON (a.elt_account_number=b.elt_account_number AND a.booking_num=b.booking_num) " _
                    & "WHERE a.elt_account_number=" & elt_account_number & " AND a.file_no=N'" & vBillNum & "'"
            End If
        Else
        End If
    End Sub
    
    Function DataListSelect(aDataList, vField, vValue)
        Dim newDataList, i
        Set newDataList = Server.CreateObject("System.Collections.ArrayList")
        
        For i = 0 To aDataList.Count-1
            If aDataList(i)(vField) = vValue Then
                newDataList.Add aDataList(i)
            End If
        Next
        Set DataListSelect = newDataList
    End Function
   
    Function DataListGroupBy(aDataList, vField)
        Dim aValueList,newDataList,i
        
        Set aValueList = Server.CreateObject("System.Collections.ArrayList")
        Set newDataList = Server.CreateObject("System.Collections.ArrayList")
        
        For i = 0 To aDataList.Count-1
            If Not aValueList.Contains(aDataList(i)(vField)) Then
                newDataList.Add aDataList(i)
                aValueList.Add aDataList(i)(vField)
            End If
        Next
        
        Set DataListGroupBy = newDataList
    End Function
    %>
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .style1 {color: #663366}
        body {
	        margin-left: 0px;
	        margin-right: 0px;
	        margin-bottom: 0px;
        }
        a:hover {
	        color: #CC3300;
        }
    </style>
  

    <script type="text/jscript">
    
        function selectSearchType()
        {
            // lstSearchNumChange(-1,'');
        }
        
        function lstSearchNumChange(argV,argL){
	        var typeValue = document.getElementById("lstSearchType").value
	        var url = "print_label.asp?mode=search&type=" + typeValue + "&no=" + argV;
            self.window.location.href = encodeURI(url);
        }

        function searchNumFill(obj,eType,changeFunction,vHeight){
            var qStr = obj.value;
            var keyCode = event.keyCode;
            var typeValue = document.getElementById("lstSearchType").value

            if(qStr != "" && keyCode != 229 && keyCode != 27 && typeValue != ""){
                var url = "/ASP/ajaxFunctions/ajax_get_bills.asp?mode=list&export=" + eType + "&qStr=" 
                    + qStr + "&type=" + typeValue;
                FillOutJPED(obj,url,changeFunction,vHeight);
            }
        }
        
        function searchNumFillAll(objName,eType,changeFunction,vHeight){
            var obj = document.getElementById(objName);
            var typeValue = document.getElementById("lstSearchType").value;
            
            if(typeValue != "")
            {
                var url = "/ASP/ajaxFunctions/ajax_get_bills.asp?mode=list&type=" 
                    + typeValue + "&export=" + eType;
                FillOutJPED(obj,url,changeFunction,vHeight);
            }
        }

        
        function LoadPage(){
            findSelect(document.getElementById("lstSearchType"),"<%=vBillType %>");
            document.getElementById("lstSearchNum").value = "<%=vBillNum %>";
            document.getElementById("hSearchNum").value = "<%=vBillNum %>";
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
        
        function chkShowTotalClick(thisObj){
            if(thisObj.checked){
                thisObj.value = "Y";
            }
            else{
                thisObj.value = "N";
            }
        }
        
        function PrintFormPDF(){
        
            var aChkHouse = document.getElementsByName("chkHouse");
	        var aPcsHouse = document.getElementsByName("txtHousePCS");
            var vTotalPCS = 0;
            var vCounter = 0;
            for(var i=0; i<aChkHouse.length; i++){
                if(aChkHouse[i].checked){
                    vCounter++;
                    vTotalPCS = vTotalPCS + aPcsHouse[i].value;
                }
            }
            if(vCounter == 0 || vTotalPCS == 0){
                alert("Please, select (a) item(s) to print.");
                return false;
            }
            else{
                document.form1.action = "print_label_pdf.asp?cType=all";
                document.form1.method = "POST";
                document.form1.target = "_self";
                form1.submit();
            }
        }
	
	    function PrintFormZebraOption(){
	    
	        var aChkHouse = document.getElementsByName("chkHouse");
	        var aPcsHouse = document.getElementsByName("txtHousePCS");
            var vTotalPCS = 0;
            var vCounter = 0;
            for(var i=0; i<aChkHouse.length; i++){
                if(aChkHouse[i].checked){
                    vCounter++;
                    vTotalPCS = vTotalPCS + aPcsHouse[i].value;
                }
            }
            if(vCounter == 0 || vTotalPCS == 0){
                alert("Please, select (a) item(s) to print.");
                return false;
            }
            else{
	            var vPrintPortWithOption, tmpArray, tmpCnt;
                var vShippingLabelPort = document.getElementById("hShippingLabelPort").value;
                var vShippingLabelQueue = document.getElementById("hShippingLabelQueue").value;
                
//	            vPrintPortWithOption = queryPort_for_zebra(vShippingLabelPort, vShippingLabelQueue, "N");
//	            if(vPrintPortWithOption == "-1"){
//	                return false;
//	            }

//	            var tmpArray = vPrintPortWithOption.split("^^^");
//	            var tmpCnt = tmpArray.length;
//	            if(tmpCnt == 4){
//	                actionRequestForZebra(tmpArray[0],tmpArray[1],tmpArray[2],tmpArray[3]);
//	            }

	            actionRequestForZebra();
	        }
	    }

        function chkHouseAll_clicked(thisObj){
	        var chkHouseList = document.getElementsByName("chkHouse");
	        
	        for(var i=0; i<chkHouseList.length; i++){
                chkHouseList[i].checked = thisObj.checked;
            }
	    }
	    
    </script>

    <script type="text/jscript" src="../include/JPTableDOM.js"></script>

    <script type="text/jscript" src="../include/tooltips.js"></script>

    <script type="text/jscript" src="/ASP/ajaxFunctions/ajax.js"></script>

    <script type="text/jscript" src="../include/JPED.js"></script>

    <script type="text/jscript" src="./print_label.js"></script>

    <!--  #INCLUDE FILE="../include/print_query_shared.asp" -->
</head>
<body style="margin: 0px 0px 0px 0px;" onload="LoadPage()">
    <!-- tooltip placeholder -->
    <div id="tooltipcontent">
    </div>
    <!-- placeholder ends -->
    <div style="text-align: center">
        <table style="width: 95%" border="0" cellpadding="2" cellspacing="0">
            <tr>
                <td valign="middle" class="pageheader">
                    Print Shipping Label
                </td>
            </tr>
        </table>
    </div>
    <div class="selectarea" style="text-align: center">
        <table width="95%" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <table width="95%" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td style="height: 15px; width: 200px" valign="top" colspan="3">
                                <span class="select">Select AWB Type and No.</span></td>
                        </tr>
                        <tr>
                            <td style="width: 130px">
                                <select id="lstSearchType" class="bodyheader" style="width: 120px" onchange="javascript:selectSearchType();">
                                    <option value="house">House B/L No.</option>
                                    <option value="master">Ocean Booking No.</option>
                                    <option value="file">File No.</option>
                                </select>
                            </td>
                            <td>
                                <!-- Start JPED -->
                                <input type="hidden" id="hSearchNum" name="hSearchNum" />
                                <div id="lstSearchNumDiv">
                                </div>
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td>
                                            <input type="text" autocomplete="off" id="lstSearchNum" name="lstSearchNum" value=""
                                                class="shorttextfield" style="width: 140px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="searchNumFill(this,'O','lstSearchNumChange',200,event);"
                                                onfocus="initializeJPEDField(this,event);" /></td>
                                        <td>
                                            <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="searchNumFillAll('lstSearchNum','O','lstSearchNumChange',200);"
                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                    </tr>
                                </table>
                                <!-- End JPED -->
                            </td>
                        </tr>
                    </table>
                </td>
                <td align="right">
                    <div id="print">
                        <img src="../images/icon_printer.gif" width="44" height="27" alt="" />
                        <a href="javascript:;" onclick="PrintFormZebraOption();return false;">Zebra Printer</a>
                        <img src="/ASP/Images/button_devider.gif" alt="" />
                        <a href="javascript:;" onclick="PrintFormPDF();return false;">Shipping Label </a>
                    </div>
                </td>
            </tr>
        </table>
    </div>
    <form id="form1" name="form1" accept-charset="UTF-8" action="">
        <input type="hidden" id="hShippingLabelPort" name="hShippingLabelPort" value="<%=shippinglabelPort%>" />
        <input type="hidden" id="hShippingLabelQueue" name="hShippingLabelQueue" value="<%=shippinglabelQueue%>" />
        <div style="text-align: center">
            <table style="width: 95%; border: solid 1px #6D8C80" cellpadding="5" cellspacing="0"
                class="bodycopy">
                <tr style="background-color: #BFD0C9">
                    <td class="bodyheader" colspan="10">
                        Booking Number:
                        <%=vBookingNum %>
                        <input type="hidden" id="hMAWB" name="hMAWB" value="<%=vBookingNum %>" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <table style="width: 100%" cellpadding="2" cellspacing="0" border="0" class="bodycopy">
                            <tr style="background-color: #E0EDE8; height: 20px" class="bodyheader">
                                <td>
                                    <input type="checkbox" id="chkHouseAll" onclick="chkHouseAll_clicked(this)" <% If vBillType="master" Or vBillType="file" Then Response.Write("checked=checked") %> />
                                </td>
                                <td>
                                    House B/L
                                </td>
                                <td>
                                    No. of Label per C/T
                                </td>
                                <td>
                                    No. of Pieces per House B/L
                                </td>
                                <td>
                                    From
                                </td>
                                <td>
                                    To
                                </td>
                                <td>
                                    Destination
                                </td>
                                <td>
                                    Shipper
                                </td>
                                <td>
                                    Consignee
                                </td>
                            </tr>
                            <% If aAllData.Count = 0 And vBookingNum <> "" Then %>
                            <tr>
                                <td colspan="9" class="bodyheader" style="text-align: center"">
                                    No Data Found</td>
                            </tr>
                            <% End If %>
                            <% For i=0 To aAllData.Count-1 %>
                            <tr id="trHouse<%=i %>">
                                <td>
                                    <input type="hidden" id="hCarrierDesc<%=i %>" name="hCarrierDesc" value="<%=aAllData(i)("carrier_desc") %>" />
                                    <input id="chkHouse<%=i %>" name="chkHouse" type="checkbox" value="<%=aAllData(i)("hbol_num") %>"
                                        <% If vBillType<>"house" Or (vBillType="house" And vBillNum=aAllData(i)("hbol_num")) Then Response.Write("checked=checked") %> /></td>
                                <td>
                                    <input id="txtHouse<%=i %>" name="txtHouse" type="text" size="20" class="d_shorttextfield"
                                        value="<%=aAllData(i)("hbol_num") %>" readonly="readonly" />
                                </td>
                                <td>
                                    <input id="txtLabelNo<%=i %>" name="txtLabelNo" type="text" size="12" class="shorttextfield"
                                        value="<%=aAllData(i)("label_no") %>" />
                                    <input type="hidden" id="hLabelStart<%=i %>" name="hLabelStart" value="<%=aAllData(i)("label_start") %>" />
                                </td>
                                <td>
                                    <input id="txtHousePCS<%=i %>" name="txtHousePCS" type="text" size="12" class="d_shorttextfield"
                                        value="<%=aAllData(i)("pieces") %>" readonly="readonly" />
                                </td>
                                <td>
                                    <input id="txtFrom<%=i %>" name="txtFrom" type="text" size="12" class="shorttextfield"
                                        value="<%=aAllData(i)("origin_port_id") %>" />
                                </td>
                                <td>
                                    <input id="txtTo<%=i %>" name="txtTo" type="text" size="12" class="shorttextfield"
                                        value="<%=aAllData(i)("dest_port_id") %>" />
                                </td>
                                <td>
                                    <input id="txtToDesc<%=i %>" name="txtToDesc" type="text" size="20" class="shorttextfield"
                                        value="<%=aAllData(i)("dest_port_location") %>" />
                                </td>
                                <td>
                                    <input id="txtShipper<%=i %>" name="txtShipper" type="text" size="20" class="d_shorttextfield"
                                        value="<%=aAllData(i)("shipper_name") %>" readonly="readonly" />
                                    <input id="hShipperAcct<%=i %>" name="hShipperAcct" type="hidden" size="20" class="shorttextfield"
                                        value="<%=aAllData(i)("shipper_acct_num") %>" />
                                </td>
                                <td>
                                    <input id="txtConsignee<%=i %>" name="txtConsignee" type="text" size="20" class="d_shorttextfield"
                                        value="<%=aAllData(i)("consignee_name") %>" readonly="readonly" />
                                    <input id="hConsigneeAcct<%=i %>" name="hConsigneeAcct" type="hidden" size="20" class="shorttextfield"
                                        value="<%=aAllData(i)("consignee_acct_num") %>" />
                                </td>
                            </tr>
                            <% vTotalPcs = vTotalPcs + CInt(checkBlank(aAllData(i)("pieces"),0)) %>
                            <% Next %>
                        </table>
                    </td>
                </tr>
                <tr style="background-color: #BFD0C9; height: 2px">
                    <td>
                    </td>
                </tr>
                <tr style="background-color: #BFD0C9">
                    <td class="bodyheader">
                        Total Pieces:
                        <%=vTotalPcs %>
                        <input type="hidden" id="hTotalPieces" name="hTotalPieces" value="<%=vTotalPcs %>" />&nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="checkbox" id="chkShowTotal" name="chkShowTotal" value="Y" onclick="javascript:chkShowTotalClick(this);"
                            checked="checked" />
                        Show Total No. of PCS on Label(s)
                    </td>
                </tr>
            </table>
        </div>
        <div class="selectarea" style="text-align: center">
            <table width="95%" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                    </td>
                    <td align="right">
                        <div id="print">
                            <img src="../images/icon_printer.gif" width="44" height="27" alt="" />
                            <a href="javascript:;" onclick="PrintFormZebraOption();return false;">Zebra Printer</a>
                            <img src="/ASP/Images/button_devider.gif" alt="" />
                            <a href="javascript:;" onclick="PrintFormPDF();return false;">Shipping Label </a>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
<% Set feData = Nothing %>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
