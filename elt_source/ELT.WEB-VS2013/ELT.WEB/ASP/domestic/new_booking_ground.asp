<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% Option Explicit %>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/Header.asp" -->
<!--  #include file="../include/recent_file.asp" -->
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_Util_Ver_2.inc" -->
<!--  #INCLUDE VIRTUAL="/ASP/include/GOOFY_data_manager.inc" -->
<!--  #INCLUDE FILE="../include/aspFunctions_import.inc" -->
<%
    Dim i,mode,vFileNo,dataTable,aFilePrefix,vMAWB
  
    mode = checkBlank(Request.QueryString.Item("mode"),"new")
    Set dataTable = Server.CreateObject("System.Collections.HashTable")
    Call GET_DOME_PORT_LIST()
     
    Set aFilePrefix = GetAllPrefixes("DTJ")
     
    If mode = "edit" Then
        vMAWB = checkBlank(Request.QueryString.Item("MAWB"),"")
        vFileNo = checkBlank(Request.QueryString.Item("FileNo"),"")
        vMAWB = checkBlank(vMAWB,"")
        get_booking_info(vFileNo)
    Elseif mode = "new" Then
        vFileNo = GetPrefixFileNumber("DTJ",elt_account_number,"")
    Elseif mode = "save" Then
        vMAWB = checkBlank(Request.Form.Item("txtMAWBNum"),"")
       
        save_booking_info()
        
        get_booking_info(vFileNo)
    Elseif mode = "close" Then
        vMAWB = checkBlank(Request.Form.Item("txtMAWBNum"),"")
        close_booking()
    End If
    
    Sub get_booking_info(vFileNoCopy)
    
        Dim SQL,dataObj
        
        SQL = "SELECT TOP 1 * FROM mawb_number WHERE elt_account_number=" & elt_account_number _
        & " AND (file#='" & vFileNoCopy & "' OR mawb_no='" & vMAWB _
        & "') AND (is_dome='Y' or is_dome='') AND master_type='DG'"

        If Not IsDataExist(SQL) Then
            Response.Write("<script>alert('The number does not exist'); window.location.href='new_booking_ground.asp?mode=new'; </script>")
            Response.End()
        End If

        Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set dataTable = dataObj.GetRowTable(0)
        vFileNo = dataTable("File#")
    End Sub
    
    Sub save_booking_info()
        Dim SQL,dataObj,resVal,prefix_string,isExist,doNextFileNo,deleteSQL,rs
        Set dataObj = new DataManager
        
        doNextFileNo = False
        vFileNo = Request.Form.Item("txtFileNo")
        SQL = "SELECT * FROM mawb_number where mawb_no='" & Request.Form.Item("txtMAWBNum") _
            & "' AND elt_account_number=" & elt_account_number
        isExist = IsDataExist(SQL)
       
        prefix_string = checkBlank(Request.Form.Item("lstFILEPrefix"),"-")
        
        '// selected prefix was submitted
        If prefix_string <> "-" Then
            prefix_string = Mid(prefix_string,1,InStr(prefix_string,"-")-1)
            '// new booking
            If Not isExist Then
                If IsDataExist("SELECT * FROM mawb_number where file#='" &  vFileNo & "' AND elt_account_number=" & elt_account_number) Then
                    '// Response.Write("<script>alert('The file number was used already!'); window.history.back(-1);</script>")
                    '// Exit Function
                    deleteSQL = "DELETE FROM mawb_master WHERE elt_account_number=" & elt_account_number _
                        & " AND mawb_num IN (SELECT mawb_no FROM mawb_number WHERE file#='" & vFileNo _
                        & "' AND elt_account_number=" & elt_account_number & ")"
                    Set rs = Server.CreateObject("ADODB.Recordset")
                    Set rs = eltConn.execute(deleteSQL)
                    deleteSQL = "DELETE FROM mawb_number WHERE elt_account_number=" & elt_account_number & " AND file#='" & vFileNo & "'"
                    Set rs = Server.CreateObject("ADODB.Recordset")
                    Set rs = eltConn.execute(deleteSQL)
                '// file # not used
                Else
                End If
                vFileNo = GetPrefixFileNumber("DTJ",elt_account_number,prefix_string)
                dataTable.Add "used", "N"
                dataTable.Add "Status", "B"
                dataTable.Add "File#", vFileNo
                doNextFileNo = True
            '// existing booking
            Else
                If IsDataExist("SELECT * FROM mawb_number where file#='" & vFileNo & "' AND mawb_no='" & vMAWB & "'") Then
                    vFileNo = ""
                Else
                    Response.Write("<script>alert('The file number was assigned already!'); window.history.back(-1);</script>")
                    Response.End()
                End If
            End If
        '// prefix was disabled or no prefix
        Else
            '// new booking
            If Not isExist Then
                '// file # used
                If IsDataExist("SELECT * FROM mawb_number where file#='" &  vFileNo & "' AND elt_account_number=" & elt_account_number) Then
                    '// Response.Write("<script>alert('The file number was used already!'); window.history.back(-1);</script>")
                    '// Exit Function
                    deleteSQL = "DELETE FROM mawb_master WHERE elt_account_number=" & elt_account_number _
                        & " AND mawb_num IN (SELECT mawb_no FROM mawb_number WHERE file#='" & vFileNo _
                        & "' AND elt_account_number=" & elt_account_number & ")"
                    Set rs = Server.CreateObject("ADODB.Recordset")
                    Set rs = eltConn.execute(deleteSQL)
                    deleteSQL = "DELETE FROM mawb_number WHERE elt_account_number=" & elt_account_number & " AND file#='" & vFileNo &"'"
                    Set rs = Server.CreateObject("ADODB.Recordset")
                    Set rs = eltConn.execute(deleteSQL)
                '// file # not used
                Else
                End If
                dataTable.Add "used", "N"
                dataTable.Add "Status", "B"
                dataTable.Add "File#", vFileNo
            '// existing booking
            Else
                If IsDataExist("SELECT * FROM mawb_number where file#='" & vFileNo & "' AND mawb_no='" & vMAWB & "'") Then
                    vFileNo = ""
                Else
                    Response.Write("<script>alert('The file number was assigned already!'); window.history.back(-1);</script>")
                    Response.End()
                End If
            End If
        End If
        
        Dim origin_port,dest_port
        origin_port = Request.Form.Item("lstOriginPort")
        dest_port = Request.Form.Item("lstDestPort")
        
        dataTable.Add "elt_account_number", elt_account_number
        dataTable.Add "mawb_no", Request.Form.Item("txtMAWBNum")
        dataTable.Add "mawb_num", Request.Form.Item("txtMAWBNum")
        dataTable.Add "booking_date", Request.Form.Item("txtBookingDate")
        dataTable.Add "Origin_Port_ID", origin_port
        dataTable.Add "origin_port_aes_code", GetPortInfo(origin_port,"port_id")
        dataTable.Add "Origin_Port_Location", GetPortInfo(origin_port,"port_desc")
        dataTable.Add "Origin_Port_State", GetPortInfo(origin_port,"port_state")
        dataTable.Add "Origin_Port_Country", GetPortInfo(origin_port,"port_country")
        dataTable.Add "Dest_Port_ID", dest_port
        dataTable.Add "dest_port_aes_code", GetPortInfo(dest_port,"port_id")
        dataTable.Add "Dest_Port_Location", GetPortInfo(dest_port,"port_desc")
        dataTable.Add "Dest_Port_State", GetPortInfo(dest_port,"port_state")
        dataTable.Add "Dest_Port_Country", GetPortInfo(dest_port,"port_country")
        dataTable.Add "To", Request.Form.Item("txtTo")
        dataTable.Add "service_level_other", Request.Form.Item("txtServiceLevel")
        dataTable.Add "ETD_DATE1", Request.Form.Item("txtDeptDate1")
        dataTable.Add "ETA_DATE1", Request.Form.Item("txtArrivalDate1")
        dataTable.Add "Weight_Reserved", ConvertAnyValue(Request.Form.Item("txtWeightReserved"),"Double","0")
        dataTable.Add "pieces", ConvertAnyValue(Request.Form.Item("txtPieces"),"Long","0")
        dataTable.Add "airline_staff", Request.Form.Item("txtAirLineStaff")
        dataTable.Add "is_dome", "Y"
        dataTable.Add "master_type", "DG"
        dataTable.Add "By", Request.Form.Item("lstCarrierName")
        dataTable.Add "Carrier_Desc", Request.Form.Item("lstCarrierName")
        dataTable.Add "Carrier_Code", ""
        dataTable.Add "Carrier_ICC_MC" , GetCarrierInfo("ICC_MC", Request.Form.Item("hCarrierAcct"))
        dataTable.Add "Carrier_acct", Request.Form.Item("hCarrierAcct")
        
        dataObj.SetColumnKeys("mawb_number")
          'Response.write(SQL)
          'Response.End()
          On Error Resume Next
        Err.Clear
        If dataObj.UpdateDBRow(SQL, dataTable) And doNextFileNo Then
         
            Call SetNextPrefixFileNumber("DTJ",elt_account_number,prefix_string)
        End If
        If Err.Number <> 0 Then
            WScript.Echo "Error: " & Err.Number
            WScript.Echo "Error (Hex): " & Hex(Err.Number)
            WScript.Echo "Source: " &  Err.Source
            WScript.Echo "Description: " &  Err.Description
            Err.Clear
        End If
        On Error Goto 0

    End Sub
    
    Sub close_booking()
        Dim SQL,rs
        Set rs = Server.CreateObject("ADODB.RecordSet")
    	SQL= "SELECT * FROM mawb_number WHERE elt_account_number = " & elt_account_number _
    	    & " AND (is_dome='Y' OR is_dome='') AND master_type='DG' AND mawb_no='" _
    	    & Request.Form.Item("hSearchNum") & "'"
	    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	    if not rs.EOF then
		    rs("Status")="C"
	    end if
	    rs.Update
	    rs.close
    End Sub
    
    On Error Resume Next:
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
     <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
    <title>Ground Booking</title>
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        <!--
        .style1 {
	        color: #000000;
	        font-weight: bold;
        }
        body {
	        margin-left: 0px;
	        margin-right: 0px;
	        margin-bottom: 0px;
        }
        .style9 {color: #000000}
        .style10 {color: #517595}
        .style11 {color: #663366}
        .style12 {color: #c16b42}
        .style13 {color: #CC0000}
        -->
    </style>

    <script type="text/javascript" src="/ASP/ajaxFunctions/ajax.js"></script>

    <script type="text/javascript" src="../include/JPED.js"></script>

    <script type="text/javascript">
    
        function lstSearchNumChange(argV,argL){
        
            var divObj = document.getElementById("lstSearchNumDiv");

            divObj.style.visibility = "hidden";
            divObj.style.position = "absolute";
            divObj.style.height = "0px";
		    divObj.innerHTML = "";
		    if(argV != "0" && argV != ""){
		        document.form1.action = "new_booking_ground.asp?mode=edit&MAWB=" + encodeURIComponent(argV);
                document.form1.method = "POST";
                document.form1.target = "_self";
                document.form1.submit();
            }
        }
        
        function searchNumFill(obj,changeFunction,vHeight,event){
            var qStr = obj.value;
            var keyCode = event.keyCode;
 
            if(qStr != "" && keyCode != 229 && keyCode != 27){
                var url = "/ASP/ajaxFunctions/ajax2_mawb_header.asp?mode=list&mtype=DGB&qStr=" + qStr;
                FillOutJPED(obj,url,changeFunction,vHeight);
            }
        }
        
        function searchNumFillAll(objName,changeFunction,vHeight){
            var obj = document.getElementById(objName);
            var url = "/ASP/ajaxFunctions/ajax2_mawb_header.asp?mode=list&mtype=DGB";
            
            FillOutJPED(obj,url,changeFunction,vHeight);
        }
        
        function lookupFile(){
            var fileNo = document.getElementById("txtJobNum").value;
            if (fileNo != "" &&  fileNo != "Search Here")
	        {
                var url = "new_booking_ground.asp?mode=edit&fileNo=" + fileNo;
                window.location.href=url;
            }
            else
            {
                alert('Please enter a File No!');
            }
          }
        function loadValues(){
            <% If mode = "edit" Or mode = "save" Then %>
            document.getElementById("lstSearchNum").value = "<%=dataTable("mawb_no") %>";
            document.getElementById("hSearchNum").value = "<%=dataTable("mawb_no") %>";
            document.getElementById("txtMAWBNum").value = "<%=dataTable("mawb_no") %>";
            document.getElementById("txtBookingDate").value = "<%=dataTable("booking_date") %>";
            document.getElementById("txtFileNo").value = "<%=vFileNo %>";
            document.getElementById("txtFileNo").readOnly = true;
            document.getElementById("txtFileNo").style.backgroundColor = "#cccccc";
            document.getElementById("lstFILEPrefix").disabled = true;
            document.getElementById("lstFILEPrefix").style.backgroundColor = "#cccccc";
            document.getElementById("txtTo").value = "<%=dataTable("To") %>";
            document.getElementById("txtServiceLevel").value = "<%=dataTable("service_level_other") %>";
            lstCarrierNameChange(<%=checkBlank(dataTable("Carrier_acct"),0) %>,"<%=dataTable("Carrier_Desc") %>");
            document.getElementById("txtDeptDate1").value = "<%=dataTable("ETD_DATE1") %>";
            document.getElementById("txtArrivalDate1").value = "<%=dataTable("ETA_DATE1") %>";
            document.getElementById("txtWeightReserved").value = "<%=ConvertAnyValue(dataTable("Weight_Reserved"),"Long","") %>";
            document.getElementById("txtPieces").value = "<%=ConvertAnyValue(dataTable("pieces"),"Long","") %>";
            document.getElementById("txtAirLineStaff").value = "<%=dataTable("airline_staff") %>";
            document.getElementById("gotoSpan").style.visibility = "visible";
            <% Else %>
            document.getElementById("txtBookingDate").value = "<%=Date() %>";
            document.getElementById("txtFileNo").value = "<%=vFileNo %>";
            <% End If %>
        }
        
        
        function lstCarrierNameChange(orgNum,orgName){
            var hiddenObj = document.getElementById("hCarrierAcct");
            var txtObj = document.getElementById("lstCarrierName");
            var divObj = document.getElementById("lstCarrierNameDiv");
                    
            hiddenObj.value = orgNum;
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
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

            var url="/ASP/ajaxFunctions/ajax_get_org_address_info.asp?type=" + infoFormat + "&org=" + orgNum;
        
            xmlHTTP.open("GET",url,false); 
            xmlHTTP.send();
            
            return xmlHTTP.responseText; 
        }
        
        function goToMAWB(){
            var fileNo = encodeURIComponent(document.getElementById("txtFileNo").value);
            var mawbNo = encodeURIComponent(document.getElementById("hSearchNum").value);
            document.form1.action = "new_mawb_ground.asp?mode=edit&MAWB=" + mawbNo + "&FILE=" + fileNo;
            document.form1.method = "POST";
            document.form1.target = "_self";
            document.form1.submit();
        }
        
        function PrefixChange(thisObj){
            document.getElementById("txtFileNo").value = thisObj.value;
        }
        
        function bSaveClick(){
            var mawbNo = document.getElementById("txtMAWBNum").value;
            var deptDate = document.getElementById("txtDeptDate1").value;
            var arrDate = document.getElementById("txtArrivalDate1").value;
            
            if(document.getElementById("txtFileNo").value == ""){
                alert("Please, preset file numbers and prefixes in prefix manager.\nYou can also manual enter it in this page.");
                return false;
            }
            if(mawbNo == null || mawbNo == ""){
                alert("Please, enter a bill of lading or Pro number.");
                return false;
            }
            
            else if(deptDate == null || deptDate == ""){
                alert("Please, enter departure date.");
                return false;
            }
            
            else if(arrDate == null || arrDate == ""){
                alert("Please, enter arrival date.");
                return false;
            }
            
            document.form1.action = "new_booking_ground.asp?mode=save"
            document.form1.method = "POST";
            document.form1.target = "_self";
            document.form1.submit();
        }
        
        function bCloseClick(){
            var mawbNo = document.getElementById("hSearchNum").value;
            if(mawbNo == null || mawbNo == ""){
                alert("Please, select a bill of lading or Pro number.");
                return false;
            }
            else
            {
                var r=confirm("Do you really want to close Ground booking No. '"+ mawbNo +"' ? Continue?");
                if (r==true)
                {                    
            
                    document.form1.action = "new_booking_ground.asp?mode=close"
                    document.form1.method = "POST";
                    document.form1.target = "_self";
                    document.form1.submit();
                 }
             }
        }
    </script>

</head>
<body link="336699" vlink="336699" topmargin="0" onLoad="self.focus();  loadValues();">
    <div id="tooltipcontent"></div>
    <form name="form1" method="post" action="">
    <input type="image" style="visibility:hidden; position:absolute" onclick="return false;" />
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td width="50%" height="32" align="left" valign="middle" class="pageheader">
                    GROUND booking</td>
                <td width="50%" align="right" valign="middle">
                    <span class="bodyheader style11">FILE NO.</span><input name="txtJobNum" type="text"
                        class="lookup" size="22" value="Search Here" onClick="javascript: this.value=''; this.style.color='#000000'; "
                        onKeyPress="javascript: if(event.keyCode == 13) { lookupFile(); }"><img src="../images/icon_search.gif"
                            name="B1" width="33" height="27" align="absmiddle" onClick="lookupFile()" style="cursor: hand"></td>
            </tr>
        </table>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr style="height: 24px">
                <td><img src="/ASP/Images/required.gif" align="absbottom" alt="" /><span class="select">Select or type booking number</span></td>
            </tr>
            <tr>
                <td width="50%" align="left" valign="middle">
                    <!-- Start JPED -->
                                            <input type="hidden" id="hSearchNum" name="hSearchNum" />
                                            <div id="lstSearchNumDiv">
                                            </div>
                                            <table cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td>
                                                        <input type="text" autocomplete="off" id="lstSearchNum" name="lstSearchNum" value=""
                                                            class="shorttextfield" style="width: 150px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                            border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onKeyUp="searchNumFill(this,'lstSearchNumChange',200,event);"
                                                            onfocus="initializeJPEDField(this,event);" /></td>
                                                    <td>
                                                        <img src="/ig_common/Images/combobox_drop.gif" alt="" onClick="searchNumFillAll('lstSearchNum','lstSearchNumChange',200);"
                                                            style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                            border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                </tr>
                                            </table>
                                            <!-- End JPED -->
                </td>
            </tr>
        </table>
        <br />
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#997132"
            bgcolor="#997132" class="border1px">
            <tr>
                <td>
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr bgcolor="#F2DEBF">
                            <td height="24" align="center" valign="middle" bgcolor="#eec983" class="bodyheader">
                                <table width="98%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="26%" valign="middle">
                                            <img src="/ASP/Images/spacer.gif" width="70" height="5"><img src="/ASP/Images/spacer.gif"
                                                width="70" height="5">
                                        </td>
                                        <td width="48%" align="center" valign="middle">
                                            <img src="../images/button_save_medium.gif" width="46" height="18" name="bSave" onClick="bSaveClick()"
                                                style="cursor: hand" /></td>
                                        <td width="13%" align="right" valign="middle">
                                            <a href="/ASP/domestic/new_booking_ground.asp" target="_self">
                                                <img src="/ASP/Images/button_new.gif" width="42" height="17" border="0"
                                                    style="cursor: hand"></a></td>
                                        <td width="13%" align="right" valign="middle">
                                            <img src="../images/button_closebooking.gif" width="48" height="18" name="bClose"
                                                onClick="bCloseClick()" style="cursor: hand" />
                                            <div style="width: 21px; display: inline; vertical-align: text-bottom" onMouseOver="showtip('Clicking this will close the current bill or booking. Closing it means it will still be saved in the system, but not accessible through the dropdowns on the Operations screen.  Often old bills that are very rarely accessed are closed to help keep the dropdowns ?clean?.');"
                                                onMouseOut="hidetip()">
                                                <img src="../Images/button_info.gif" align="bottom" class="bodylistheader"></div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td height="1" colspan="9" bgcolor="#997132">
                            </td>
                        </tr>
                        <tr align="center">
                            <td valign="middle" bgcolor="f3f3f3" class="bodycopy">
                                <br>
                                <table width="70%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td height="28" align="right">
                                            <span class="bodyheader">
                                                <img src="/ASP/Images/required.gif" align="absbottom">Required field</span></td>
                                    </tr>
                                </table>
                                <table width="70%" border="0" cellpadding="2" cellspacing="0" bordercolor="#997132"
                                    class="border1px">
                                    <tr align="left" valign="middle" bgcolor="#F2DEBF" class="bodycopy">
                                        <td width="1%" height="20" bgcolor="#f3d9a8">
                                            &nbsp;
                                        </td>
                                        <td height="20" bgcolor="#f3d9a8" class="bodycopy">
                                            <img src="/ASP/Images/required.gif" align="absbottom"><strong><font color="c16b42">Bill
                                                of Lading/Pro No.</font></strong></td>
                                        <td width="24%" bgcolor="#f3d9a8">
                                            <span class="style1">Booking Date</span></td>
                                        <td width="22%" bgcolor="#f3d9a8">
                                            <span class="style1">File No.</span></td>
                                        <td width="23%" bgcolor="#f3d9a8">
                                            <select name="lstCarrier" size="1" class="bodycopy" style="width: 0px; height: 0px"
                                                tabindex="3">
                                            </select>
                                            <input type="checkbox" name="chkAll" value="Y" style="height: 0px">
                                            <img src="../images/button_go.gif" width="0" height="0" onClick="GoClick()" style="cursor: hand;"></td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="#ffffff" class="bodycopy">
                                        <td height="19">
                                            &nbsp;
                                        </td>
                                        <td valign="top" class="bodycopy">
                                            <input name="txtMAWBNum" id="txtMAWBNum" value="" class="shorttextfield" size="25" />
                                            <span class="goto" id="gotoSpan" style="visibility: hidden"><br />
                                                <img src="/ASP/Images/icon_goto.gif" width="36" height="21" align="absbottom"><b
                                                    onclick="goToMAWB();" style="cursor: hand">Go to Bill of Lading </b></span>
                                        </td>
                                        <td valign="top">
                                            <input name="txtBookingDate" type="text" class="m_shorttextfield date" id="txtBookingDate"
                                                value="" size="14" preset="shortdate" /></td>
                                        <td colspan="2" valign="top">
                                            <% If aFilePrefix.Count>0 Then %>
                                            <select name="lstFILEPrefix" size="1" class="bodyheader" style="width: 80px" onChange="PrefixChange(this);"
                                                tabindex="6" id="lstFILEPrefix">
                                                <% For i=0 To aFilePrefix.Count-1 %>
                                                <option value="<%=aFilePrefix(i)("prefix") %>-<%=aFilePrefix(i)("next_no") %>">
                                                    <%=aFilePrefix(i)("prefix") %>
                                                </option>
                                                <% Next %>
                                            </select>
                                            <input name="txtFileNo" id="txtFileNo" class='d_shorttextfield' style='width: 110px' tabindex="6"
                                                value="" size='20' readonly="readonly" />
                                            <% Else %>
                                                <input type="hidden" name="lstFILEPrefix" value="" />
                                                <input name="txtFileNo" id="txtFileNo" class='shorttextfield' style='width: 110px' tabindex="6"
                                                value="" size='20' />
                                            <% End If %>
                                        </td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                        <td height="2" colspan="5" bgcolor="#997132">
                                        </td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="#F3f3f3" class="bodycopy">
                                        <td height="18">
                                            &nbsp;
                                        </td>
                                        <td class="bodyheader">
                                            Origin</td>
                                        <td>
                                        </td>
                                        <td colspan="2">
                                            <span class="bodyheader">Destination</span></td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="#Ffffff">
                                            &nbsp;
                                        </td>
                                        <td colspan="2" bgcolor="#FFFFFF">
                                            <select name="lstOriginPort" size="1" class="shorttextfield" style="width: 230px"
                                                tabindex="7" id="lstOriginPort">
                                                <% For i=0 To port_list.Count-1 %>
                                                <option value="<%=port_list(i)("port_code") %>" <% if port_list(i)("port_code") = dataTable("Origin_Port_ID") Then Response.Write("selected") %>>
                                                    <%=port_list(i)("port_desc") %>
                                                </option>
                                                <% Next %>
                                            </select>
                                        </td>
                                        <td colspan="2" bgcolor="#FFFFFF">
                                            <select name="lstDestPort" size="1" class="smallselect" style="width: 230px" tabindex="14"
                                                onchange="javascript:document.getElementById('txtTo').value=this.value;" 
                                                id="lstDestPort">
                                                <% For i=0 To port_list.Count-1 %>
                                                <option value="<%=port_list(i)("port_code") %>" <% if port_list(i)("port_code") = dataTable("Dest_Port_ID") Then Response.Write("selected") %>>
                                                    <%=port_list(i)("port_desc") %>
                                                </option>
                                                <% Next %>
                                            </select>
                                        </td>
                                        <tr bgcolor="#F3f3f3" class="bodyheader">
                                            <td height="18">
                                                &nbsp;
                                            </td>
                                            <td width="30%" bgcolor="#F3f3f3">
                                                <span class="style9">To</span></td>
                                            <td>
                                                &nbsp;
                                            </td>
                                            <td>
                                                <span class="style12">Service Level </span>
                                            </td>
                                            <td width="23%">
                                                &nbsp;
                                            </td>
                                            <tr bgcolor="#Ffffff">
                                                <td>
                                                    &nbsp;
                                                </td>
                                                <td colspan="2">
                                                    <input name="txtTo"  id="txtTo" class="d_shorttextfield" tabindex="8" value="" size="24" style="width: 230px"
                                                        readonly="readonly" /></td>
                                                <td colspan="2">
                                                    <input name="txtServiceLevel" class="shorttextfield" maxlength="64" value="" 
                                                        size="51" id="txtServiceLevel"></td>
                                                <tr align="left" valign="middle" bgcolor="#F3f3f3" class="bodycopy">
                                                    <td>
                                                        &nbsp;
                                                    </td>
                                                    <td class="bodyheader">
                                                        <span class="style9">Carrier</span></td>
                                                    <td height="20" class="bodyheader">
                                                        &nbsp;
                                                    </td>
                                                    <td class="bodyheader">
                                                        <img src="/ASP/Images/required.gif" align="absbottom">Departure Date</td>
                                                    <td>
                                                        <span class="bodyheader">
                                                            <img src="/ASP/Images/required.gif" align="absbottom">Arrival Date</span></td>
                                                </tr>
                                    <tr align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                        <td>
                                            &nbsp;
                                        </td>
                                        <td colspan="2" class="bodycopy">
                                            <!-- Start JPED -->
                                            <input type="hidden" id="hCarrierAcct" name="hCarrierAcct" />
                                            <div id="lstCarrierNameDiv">
                                            </div>
                                            <table cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td>
                                                        <input type="text" autocomplete="off" id="lstCarrierName" name="lstCarrierName" value=""
                                                            class="shorttextfield" style="width: 265px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                            border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onKeyUp="organizationFill(this,'Carrier','lstCarrierNameChange',null,event)"
                                                            onfocus="initializeJPEDField(this,event);" /></td>
                                                    <td>
                                                        <img src="/ig_common/Images/combobox_drop.gif" alt="" onClick="organizationFillAll('lstCarrierName','Carrier','lstCarrierNameChange',null,event)"
                                                            style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                            border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                    <td>
                                                        <input type='hidden' id='quickAdd_output'/>
                                                        <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                            onclick="quickAddClient('hCarrierAcct','lstCarrierName')" /></td>
                                                </tr>
                                            </table>
                                            <!-- End JPED -->
                                        </td>
                                        <td>
                                            <input name="txtDeptDate1" id="txtDeptDate1" class="m_shorttextfield date" preset="shortdate" tabindex="16"
                                                value="" size="20"></td>
                                        <td>
                                            <input name="txtArrivalDate1" id="txtArrivalDate1" class="m_shorttextfield date" preset="shortdate" tabindex="17"
                                                value="" size="20"></td>
                                        <tr align="left" valign="middle" bgcolor="#f3f3f3" class="bodycopy">
                                            <td>
                                                &nbsp;
                                            </td>
                                            <td class="bodyheader">
                                                Weight Reserved (LB)
                                            </td>
                                            <td height="20" class="bodyheader">
                                                Pieces</td>
                                            <td colspan="2" class="bodyheader">
                                                Reservation Staff</td>
                                        </tr>
                                    <tr align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                        <td>
                                            &nbsp;
                                        </td>
                                        <td bgcolor="#FFFFFF" class="bodycopy">
                                            <input name="txtWeightReserved" class="m_shorttextfield" maxLength=7 
                                                tabindex="21" value="" size="24"
                                                style="behavior: url(../include/igNumChkRight.htc)" id="txtWeightReserved"></td>
                                        <td bgcolor="#FFFFFF">
                                            <input name="txtPieces" maxLength=6 class="m_shorttextfield" value="0" 
                                                size="20" style="behavior: url(../include/igNumChkRight.htc)" id="txtPieces" />
                                        <td colspan="2" bgcolor="#FFFFFF">
                                            <input name="txtAirLineStaff" type="text" class="shorttextfield" maxlength="64" 
                                                tabindex="23" value=""
                                                size="20" id="txtAirLineStaff"></td>
                                    </tr>
                                </table>
                                <br>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td height="1">
                </td>
            </tr>
            <tr>
                <td height="24" align="center" bgcolor="#eec983">
                    <table width="98%" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="26%" valign="middle">
                                <img src="/ASP/Images/spacer.gif" width="70" height="5"><img src="/ASP/Images/spacer.gif"
                                    width="70" height="5">
                            </td>
                            <td width="48%" align="center" valign="middle">
                                <img src="../images/button_save_medium.gif" width="46" height="18" name="bSave" onClick="bSaveClick()"
                                    style="cursor: hand" /></td>
                            <td width="13%" align="right" valign="middle">
                                <a href="/ASP/domestic/new_booking_ground.asp" target="_self">
                                    <img src="/ASP/Images/button_new.gif" width="42" height="17" border="0"
                                        style="cursor: hand"></a></td>
                            <td width="13%" align="right" valign="middle">
                                <img src="../images/button_closebooking.gif" width="48" height="18" name="bClose"
                                    onClick="bCloseClick()" style="cursor: hand" /></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <br />
    </form>
</body>
<script language="JavaScript" type="text/javascript" src="../include/tooltips.js"></script>
</html>
