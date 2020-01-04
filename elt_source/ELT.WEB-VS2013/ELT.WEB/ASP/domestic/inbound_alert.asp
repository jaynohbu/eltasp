<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% Option Explicit %>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/Header.asp" -->
<!--  #include file="../include/recent_file.asp" -->
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<!--  #INCLUDE VIRTUAL="/ASP/include/GOOFY_data_manager.inc" -->
<!--  #INCLUDE FILE="../include/aspFunctions_import.inc" -->
<%

'// ----------------------- Main -----------------------------------------------------------

    Dim i,vMode,vFileNo,aAirPrefix,aGroundPrefix,vMasterType,vPrefixType,dataTable,vMAWB
    
    Call GET_DOME_PORT_LIST()
    
    vMode = checkBlank(Request.QueryString.Item("mode"),"new")
    vMasterType = checkBlank(Request.QueryString.Item("mtype"),"DA")
    vFileNo = checkBlank(Request.QueryString.Item("file"),"")
    vMAWB = checkBlank(Request.Form.Item("txtMAWBNum"),"")

    Set dataTable = Server.CreateObject("System.Collections.HashTable")
    
    If vMasterType = "DA" Then
        vPrefixType = "DAJ"
    Else
        vPrefixType = "DTJ"
    End If
    
    Set aAirPrefix = GetAllPrefixes("DAJ")
    Set aGroundPrefix = GetAllPrefixes("DTJ")
    
    eltConn.BeginTrans

    main_sub()

    eltConn.CommitTrans
    
    Sub main_sub
        If vMode = "new" Then
            vFileNo = GetPrefixFileNumber(vPrefixType,elt_account_number,"")
        Elseif vMode = "save" Then
            If update_mawb_number() Then
                update_mawb_master()
                Set dataTable = get_mawb_info("",vMAWB)
            End If
        Elseif vMode = "search" Then
            Set dataTable = get_mawb_info(vFileNo,"")
        Elseif vMode = "edit" Then
            Set dataTable = get_mawb_info("",checkBlank(Request.QueryString.Item("MAWB"),""))
            vMasterType = dataTable("master_type")
        End If
    End Sub

'// ---------------------- Subs -----------------------------------------------------------
    
    Function get_mawb_info(vFileNoCopy,vMAWB)
        Dim SQL,dataObj
        
        SQL = "SELECT TOP 1 * FROM mawb_number a FULL OUTER JOIN mawb_master b " _
            & "ON (a.mawb_no=b.mawb_num and a.elt_account_number=b.elt_account_number) " _
            & "FULL OUTER JOIN mawb_weight_charge c " _
            & "ON (a.mawb_no=c.mawb_num and a.elt_account_number=c.elt_account_number) " _
            & "WHERE a.is_inbound='Y' AND a.elt_account_number=" & elt_account_number
        If vFileNoCopy <> "" Then
            SQL = SQL & " AND ISNULL(a.file#,'') <> '' AND a.file# ='" & vFileNoCopy & "'"
        Else
            SQL = SQL & " AND ISNULL(a.mawb_no,'') <> '' AND a.mawb_no ='" & vMAWB & "'"
        End If
        
        If Not IsDataExist(SQL) Then
            Response.Write("<script>alert('The number does not exist'); window.location.href='inbound_alert.asp?mode=new'; </script>")
            Response.End()
        End If

        Set dataObj = new DataManager
        dataObj.SetDataList(SQL)

        Set get_mawb_info = dataObj.GetRowTable(0)
        
    End Function
    
    Function update_mawb_number
        Dim SQL,dataObj,prefix_string,returnVal,doNextFileNo,isExist,rs,deleteSQL
        Set dataObj = new DataManager
        
        returnVal = False
        doNextFileNo = False
        vFileNo = Request.Form.Item("txtFileNo")
        SQL = "SELECT * FROM mawb_number where mawb_no='" & Request.Form.Item("txtMAWBNum") _
            & "' AND elt_account_number=" & elt_account_number
        isExist = IsDataExist(SQL)
        
        prefix_string = checkBlank(Request.Form.Item("lstFILEPrefix"),"-")
        
        '// selected prefix was submitted
        If prefix_string <> "-" Then
            prefix_string = Mid(prefix_string,1,InStr(prefix_string,"-")-1)
            '// new master
            If Not isExist Then
                '// file # used
                If IsDataExist("SELECT * FROM mawb_number where is_inbound='Y' AND file#='" &  vFileNo & "' AND elt_account_number=" & elt_account_number) Then
                    '// Response.Write("<script>alert('The file number was used already!'); window.history.back(-1);</script>")
                    '// Exit Function
                    deleteSQL = "DELETE FROM mawb_master WHERE is_inbound='Y' AND elt_account_number=" & elt_account_number _
                        & " AND mawb_num IN (SELECT mawb_no FROM mawb_number WHERE file#='" & vFileNo _
                        & "' AND elt_account_number=" & elt_account_number & ")"
                    Set rs = Server.CreateObject("ADODB.Recordset")
                    Set rs = eltConn.execute(deleteSQL)
                    deleteSQL = "DELETE FROM mawb_number WHERE is_inbound='Y' AND elt_account_number=" & elt_account_number & " AND file#='" & vFileNo & "'"
                    Set rs = Server.CreateObject("ADODB.Recordset")
                    Set rs = eltConn.execute(deleteSQL)
                '// file # not used
                Else
                End If
                vFileNo = GetPrefixFileNumber("DTJ",elt_account_number,prefix_string)
                dataTable.Add "used", "Y"
                dataTable.Add "Status", "B"
                dataTable.Add "File#", vFileNo
                doNextFileNo = True
            '// existing master
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
            '// new master
            If Not isExist Then
                '// file # used
                If IsDataExist("SELECT * FROM mawb_number where is_inbound='Y' AND file#='" &  vFileNo & "' AND elt_account_number=" & elt_account_number) Then
                    '// Response.Write("<script>alert('The file number was used already!'); window.history.back(-1);</script>")
                    '// Exit Function
                    deleteSQL = "DELETE FROM mawb_master WHERE is_inbound='Y' AND elt_account_number=" & elt_account_number _
                        & " AND mawb_num IN (SELECT mawb_no FROM mawb_number WHERE file#='" & vFileNo _
                        & "' AND elt_account_number=" & elt_account_number & ")"
                    Set rs = Server.CreateObject("ADODB.Recordset")
                    Set rs = eltConn.execute(deleteSQL)
                    deleteSQL = "DELETE FROM mawb_number WHERE is_inbound='Y' AND elt_account_number=" & elt_account_number & " AND file#='" & vFileNo &"'"
                    Set rs = Server.CreateObject("ADODB.Recordset")
                    Set rs = eltConn.execute(deleteSQL)
                '// file # not used
                Else
                End If
                dataTable.Add "used", "Y"
                dataTable.Add "Status", "B"
                dataTable.Add "File#", vFileNo
            '// existing master
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
        dataTable.Add "mawb_no", UCase(Request.Form.Item("txtMAWBNum"))
        dataTable.Add "mawb_ num", UCase(Request.Form.Item("txtMAWBNum"))
        dataTable.Add "booking_date", Request.Form.Item("txtExecDate")
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
        dataTable.Add "By", Request.Form.Item("lstCarrier")
        dataTable.Add "Carrier_Desc", Request.Form.Item("lstCarrier")
        dataTable.Add "Carrier_Code", GetCarrierInfo("Carrier_Code", Request.Form.Item("hCarrierAcct"))
        dataTable.Add "Carrier_ICC_MC" , GetCarrierInfo("ICC_MC", Request.Form.Item("hCarrierAcct"))
        dataTable.Add "Carrier_acct", Request.Form.Item("hCarrierAcct")
        dataTable.Add "Flight#", Request.Form.Item("txtFlightNo")
        dataTable.Add "ETD_DATE1", Request.Form.Item("txtDepDate")
        dataTable.Add "ETA_DATE1", Request.Form.Item("txtArrDate")
        dataTable.Add "is_dome", "Y"
        dataTable.Add "master_type", vMasterType
        dataTable.Add "is_inbound", "Y"
        dataTable.Add "inbound_customer_acct", Request.Form.Item("hCustomerAcct")
        
        ffffff
        
        dataObj.SetColumnKeys("mawb_number")
        returnVal = dataObj.UpdateDBRow(SQL, dataTable)
        
        If returnVal And doNextFileNo Then
            Call SetNextPrefixFileNumber(vPrefixType,elt_account_number,prefix_string)
        End If
        
        update_mawb_number = returnVal
    End Function
    
    Function update_mawb_master
        Dim SQL,dataObj
        Set dataObj = new DataManager

        SQL = "SELECT * FROM mawb_master WHERE mawb_num='" & UCase(Request.Form.Item("txtMAWBNum")) _
            & "' AND elt_account_number=" & elt_account_number

        dataTable.Add "MAWB_NUM", UCase(Request.Form.Item("txtMAWBNum"))
        
        '// Dummy values
        dataTable.Add "Show_Weight_Charge_Shipper", "Y"
        dataTable.Add "Show_Weight_Charge_Consignee", "Y"
        dataTable.Add "Show_Prepaid_Other_Charge_Shipper", "Y"
        dataTable.Add "Show_Collect_Other_Charge_Shipper", "Y"
        dataTable.Add "Show_Prepaid_Other_Charge_Consignee", "Y"
        dataTable.Add "Show_Collect_Other_Charge_Consignee", "Y"
        dataTable.Add "show_weight_charge_shipper", "Y"
        dataTable.Add "show_weight_charge_consignee", "Y"
        dataTable.Add "show_prepaid_other_charge_shipper", "Y"
        dataTable.Add "show_collect_other_charge_shipper", "Y"
        dataTable.Add "show_prepaid_other_charge_consignee", "Y"
        dataTable.Add "show_collect_other_charge_consignee", "Y"
        
        '// dates
        dataTable.Add "Date_Last_Modified", date()
        dataTable.Add "Invoiced", "N"
        dataTable.Add "ModifiedBy", GetUserFLName(user_id)
        dataTable.Add "ModifiedDate", date()
        dataTable.Add "Date_Executed", Request.Form.Item("txtExecDate")
        
        dataObj.SetColumnKeys("mawb_master")
        Call dataObj.UpdateDBRow(SQL, dataTable)
        
        update_mawb_master = True
    End Function

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
     <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
    <title>Domestic Export</title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="/ASP/ajaxFunctions/ajax.js"></script>

    <script type="text/javascript" src="../include/JPED.js"></script>

    <script type="text/javascript">
    
        function lstCustomerChange(orgNum,orgName){
            var hiddenObj = document.getElementById("hCustomerAcct");
            var txtObj = document.getElementById("lstCustomer");
            var divObj = document.getElementById("lstCustomerDiv");

            hiddenObj.value = orgNum;
            txtObj.value = orgName;
            divObj.style.visibility = "hidden";
            divObj.style.position = "absolute";
            divObj.style.height = "0px";
        }

        function lstCarrierChange(orgNum,orgName){
            var hiddenObj = document.getElementById("hCarrierAcct");
            var txtObj = document.getElementById("lstCarrier");
            var divObj = document.getElementById("lstCarrierDiv");

            hiddenObj.value = orgNum;
            txtObj.value = orgName;
            divObj.style.visibility = "hidden";
            divObj.style.position = "absolute";
            divObj.style.height = "0px";
        }
        
        function PrefixChange(thisObj){
            document.getElementById("txtFileNo").value = thisObj.value;
        }
        
        function LoadFilePrefixes(mType){
            var selectObj = document.getElementById("lstPrefix");
            document.getElementById("txtFileNo").value = "";
            try{
            selectObj.options.length = 0;
            if(mType == "DA"){
            <% For i=0 To aAirPrefix.Count-1 %>
                selectObj.options[<%=i %>] = new Option("<%=aAirPrefix(i)("prefix") %>","<%=aAirPrefix(i)("prefix") %>-<%=aAirPrefix(i)("next_no") %>");
            <% Next %>
                
            <% If aAirPrefix.Count = 0 Then %>
                selectObj.disabled = true;
                document.getElementById("txtFileNo").readOnly = false;
            <% Else %>
                selectObj.disabled = false;
                document.getElementById("txtFileNo").value = selectObj.options[0].value;
            <% End If %>
            }
            if(mType == "DG"){
            <% For i=0 To aGroundPrefix.Count-1 %>
                selectObj.options[<%=i %>] = new Option("<%=aGroundPrefix(i)("prefix") %>","<%=aGroundPrefix(i)("prefix") %>-<%=aGroundPrefix(i)("next_no") %>");
            <% Next %>
                document.getElementById("txtFileNo").value = selectObj.options[0].value;
            <% If aGroundPrefix.Count = 0 Then %>
                selectObj.disabled = true;
                document.getElementById("txtFileNo").readOnly = false;
            <% Else %>
                selectObj.disabled = false;
                document.getElementById("txtFileNo").value = selectObj.options[0].value;
            <% End If %>
            }
            }catch(error){}
        }
        
        function LoadValues(){
        
            LoadFilePrefixes("<%=vMasterType %>");
            SetCheckByValue(document.getElementsByName("chkShipType"),"<%=vMasterType %>");
            document.getElementById("txtMAWBNum").value = "<%=MakeJavaString(dataTable("mawb_no")) %>";
            document.getElementById("txtExecDate").value = "<%=checkBlank(dataTable("booking_date"),Date()) %>";
            
            document.getElementById("txtDepDate").value = "<%=MakeJavaString(dataTable("ETD_DATE1")) %>";
            document.getElementById("txtArrDate").value = "<%=MakeJavaString(dataTable("ETA_DATE1")) %>";
            document.getElementById("txtFlightNo").value = "<%=MakeJavaString(dataTable("Flight#")) %>";
            lstCustomerChange(<%=checkBlank(dataTable("inbound_customer_acct"),0) %>,"<%=GetBusinessName(dataTable("inbound_customer_acct")) %>");
            lstCarrierChange(<%=checkBlank(dataTable("Carrier_acct"),0) %>,"<%=dataTable("Carrier_Desc") %>");
            
            <% If vMode = "search" Or vMode = "edit" Or vMode = "save" Then %>
            document.getElementById("txtMAWBNum").style.backgroundColor = "#cccccc";
            document.getElementsByName("chkShipType")[0].disabled = true;
            document.getElementsByName("chkShipType")[1].disabled = true;
            document.getElementById("txtExecDate").value = "<%=MakeJavaString(dataTable("booking_date")) %>";
            document.getElementById("lstPrefix").disabled = true;
            document.getElementById("lstPrefix").style.backgroundColor = "#cccccc";
            document.getElementById("lstPrefix").selectedIndex = -1;
            document.getElementById("txtFileNo").value = "<%=MakeJavaString(dataTable("File#")) %>";
            document.getElementById("txtFileNo").readOnly = true;
            document.getElementById("txtFileNo").style.backgroundColor = "#CCCCCC";
            document.getElementById("divGoToMAWB").style.visibility = "visible";
            document.getElementById("txtMAWBNum").readOnly = true;

            <% Else %>
            document.getElementById("divGoToMAWB").outerHTML = "";
            <% End If %>
        }
        
        function saveValues(){
            var mawbNo = document.getElementById("txtMAWBNum").value;
            var deptDate = document.getElementById("txtDepDate").value;
            var arrDate = document.getElementById("txtArrDate").value;
            var listObj = document.getElementsByName("chkShipType");
            if(mawbNo == null || mawbNo == "")
            {
                for(var i=0;i<listObj.length;i++)
                {
                    if(listObj[i].checked)
                    {
                        break;
                    }
                }
                if(listObj[i].value == "DA")
                {
                    alert("Please, Enter Master AWB No.");
                }
                else
                {
                    alert("Please, Enter Bill of Lading/Pro No.");
                
                }
                return false;
            }
            if(document.getElementById("txtFileNo").value == ""){
                alert("Please, preset file numbers and prefixes in prefix manager.\n You can also manual enter it in this page.");
                return false;
            }
            /*
            else if(deptDate == null || deptDate == ""){
                alert("Please, enter departure date.");
                return false;
            }
            
            else if(arrDate == null || arrDate == ""){
                alert("Please, enter arrival date.");
                return false;
            }
            */
            var listObj = document.getElementsByName("chkShipType");
            
            for(var i=0;i<listObj.length;i++){
                if(listObj[i].checked){
                    break;
                }
            }
            
            document.form1.action = "inbound_alert.asp?mode=save&mtype=" + listObj[i].value;
            document.form1.method = "POST";
            document.form1.target = "_self";
            document.form1.submit();
        }
        
        function bCloseClick()
        { 
        var mawb = document.getElementById("txtMAWBNum").value;
        var listObj = document.getElementsByName("chkShipType");
        if(mawb == "") 
        {
	         for(var i=0;i<listObj.length;i++)
                {
                    if(listObj[i].checked)
                    {
                        break;
                    }
                }
                if(listObj[i].value == "DA")
                {
                    alert("Please, Enter Master AWB No.");
                }
                else
                {
                    alert("Please, Enter Bill of Lading/Pro No.");
                }
                return false;
        }
        if(!confirm("Do you really want to close this Master Bill No. '" + mawb +"' ?")) {return false;}
	        if (close_mawb(mawb) ) {
		        alert("Master AWB No. : " + mawb + " was closed successfully.");
		        window.location = "inbound_alert.asp";
	        } else {
		        alert("Some error was occured when closing.");		
		        return false;
	        }
        }
        
        function close_mawb(mawb) {
              if (window.ActiveXObject) {
	               try {
		            xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
	               } catch(e) {
                        try {
                         xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
                        } catch(f) {
                         return true;
                        }
                  }
              } else if (window.XMLHttpRequest) {
                    xmlHTTP = new XMLHttpRequest();
              } else {return true;}

	        var url = "/ASP/ajaxFunctions/ajax_mawb_close.asp" 
				        +"?n="+mawb;
        	 
            try {    
                xmlHTTP.open("get",url,false); 
                xmlHTTP.send(); 
                var sourceCode = xmlHTTP.responseText;
	            if (sourceCode) {
                    // alert(sourceCode);					
			        if ( sourceCode == 'ok' ) {
				        return true;
			        } 
			        else {
					        switch(sourceCode) {
						        default :
							          break;
					        }			
					        return false;			
			        }
		        }
        		
            }   catch(e) { return false; }
        }
        
        function goToHAWB(){
            var mawbNo = document.getElementById("txtMAWBNum").value;
            window.location.href="new_edit_hawb.asp?mode=new&MAWB=" + mawbNo;
        }
        
        function RedirectURL(){
            
            <% If checkBlank(Request.QueryString.Item("move"),"N")="Y" Then %>
            window.location.href="new_edit_hawb.asp?mode=new&MAWB=<%=vMAWB %>";
            <% End If %>
        }
        
        function LookUpByFileNo(){
            var fileNo = document.getElementById("txtJobNum").value;
            if(fileNo != "" && fileNo != "Search Here"){
                document.form1.action = "inbound_alert.asp?mode=search&file=" + document.getElementById("txtJobNum").value;
                document.form1.method = "POST";
                document.form1.target = "_self";
                document.form1.submit();
            }
            else{
                alert("Please, enter a file name to search for.");
            }
        }
        
    </script>

    <script type="text/javascript">
    
        function SetSelectByValue(oSelect,selVal){
            oSelect.options.selectedIndex = -1;
            for(var i=0;i<oSelect.options.length;i++){
                var tmpText = oSelect.options[i].value;
                if(tmpText != "" && tmpText.match(selVal) != null){
                    oSelect.options[i].selected = true;
                    break;
                }
            }
        }
        
        function SetCheckByValue(oCheck,chkVal){
            for(var i=0;i<oCheck.length;i++){
                if(oCheck[i].value == chkVal){
                    oCheck[i].checked = true;
                }
                else{
                    oCheck[i].checked = false;
                }
            }
        }
        
        function lstSearchNumChange(argV,argL){
        
            var divObj = document.getElementById("lstSearchNumDiv");

            divObj.style.visibility = "hidden";
            divObj.style.position = "absolute";
            divObj.style.height = "0px";
		    divObj.innerHTML = "";
		    if(argV != "0" && argV != ""){
		        document.form1.action = "inbound_alert.asp?mode=edit&MAWB=" + encodeURIComponent(argV);
                document.form1.method = "POST";
                document.form1.target = "_self";
                document.form1.submit();
            }
        }
        
        function searchNumFill(obj,changeFunction,vHeight,event){
            var qStr = obj.value;
            var keyCode = event.keyCode;
 
            if(qStr != "" && keyCode != 229 && keyCode != 27){
                var url = "/ASP/ajaxFunctions/ajax2_mawb_header.asp?mode=list&mtype=DIB&qStr=" + qStr;
                FillOutJPED(obj,url,changeFunction,vHeight);
            }
        }
        
        function searchNumFillAll(objName,changeFunction,vHeight){
            var obj = document.getElementById(objName);
            var url = "/ASP/ajaxFunctions/ajax2_mawb_header.asp?mode=list&mtype=DIB";
            
            FillOutJPED(obj,url,changeFunction,vHeight);
        }
       
    </script>

    <style type="text/css">
        <!--
        body {
	            margin-left: 0px;
	            margin-right: 0px;
	            margin-bottom: 0px;
            }
        .style6 {color: #663366}
        .style14 {color: #c16b42}
        -->
    </style>
</head>
<body link="336699" vlink="336699" topmargin="0" onLoad="LoadValues(); RedirectURL();">
    <form id="form1" name="form1">
        <input type="image" style="width:0px; height:0px" onclick="return false;" />
        <input type="hidden" name="hFormName" value="InboundAlertForm" />
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td width="50%" height="32" align="left" valign="middle" class="pageheader">
                    inbound alert
                </td>
                <td width="50%" align="right" valign="middle">
                    <span class="bodyheader style11 style6">FILE NO.</span>
                    <input name="txtJobNum" id="txtJobNum" type="text" class="lookup" size="22" value="Search Here"
                        onClick="javascript: this.value=''; this.style.color='#000000'; " onKeyPress="javascript: if(event.keyCode == 13) { LookUpByFileNo(); }" />
                    <img src="../images/icon_search.gif" name="B1" width="33" height="27" align="absmiddle"
                        style="cursor: hand" onClick="LookUpByFileNo()"></td>
            </tr>
        </table>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td align="left" valign="middle">
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
        <div class="selectarea">
        </div>
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
                                            <img src="/ASP/Images/spacer.gif" width="70" height="5" /><img src="/ASP/Images/spacer.gif"
                                                width="70" height="5" />
                                        </td>
                                        <td width="48%" align="center" valign="middle">
                                            <img src="../images/button_save_medium.gif" name="bSave" width="46" height="18" id="bSave"
                                                style="cursor: hand" onClick="saveValues()" /></td>
                                        <td width="13%" align="right" valign="middle">
                                            <a href="/ASP/domestic/inbound_alert.asp?mode=new" target="_self">
                                                <img src="/ASP/Images/button_new.gif" width="42" height="17" border="0"
                                                    style="cursor: hand"></a>
                                        </td>
                                        <td width="13%" align="right" valign="middle">
                                            <img src="../images/button_closebooking.gif" width="48" height="18" name="bClose"
                                                onClick="bCloseClick()" style="cursor: hand" />
                                            <div style="width: 21px; display: inline; vertical-align: text-bottom" onMouseOver="showtip('Clicking this will close the current bill or booking. Closing it means it will still be saved in the system, but not accessible through the dropdowns on the Operations screen.  Often old bills that are very rarely accessed are closed to help keep the dropdowns &ldquo;clean&rdquo;.')"
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
                            <td valign="middle" bgcolor="f3f3f3" class="bodycopy" style="padding-top: 30px; padding-bottom: 20px">
                                <table width="660px" border="0" cellspacing="0" cellpadding="0">
                                    <tr class="bodyheader">
                                        <td height="22" colspan="2" align="left" valign="middle">
                                            Type of Shipment
                                        </td>
                                    </tr>
                                    <tr style="padding-bottom: 8px">
                                        <td width="12%" class="bodycopy">
                                            <input name="chkShipType" type="radio" value="DA" onClick="LoadFilePrefixes(this.value)" />
                                            Air</td>
                                        <td class="bodycopy" style="width: 76%">
                                            <input name="chkShipType" type="radio" value="DG" onClick="LoadFilePrefixes(this.value)" />
                                            Ground</td>
                                       <td height="28" align="right">
                                            <span class="bodyheader">
                                                <img src="/ASP/Images/required.gif" align="absbottom">Required field</span></td>
                                    </tr>
                                </table>
                                <table width="660px" border="0" cellpadding="0" cellspacing="0" bordercolor="#997132"
                                    bgcolor="#FFFFFF" class="border1px">
                                    <tr class="bodyheader">
                                        <td width="1%" align="left" valign="middle" bgcolor="#f3d9a8">
                                            &nbsp;
                                        </td>
                                        <td width="22%" height="20" align="left" valign="middle" bgcolor="#f3d9a8">
                                            <span class="style14"><img src="/ASP/Images/required.gif" align="absbottom">Master Bill No.</span>
                                        </td>
                                        <td width="27%" align="left" valign="middle" bgcolor="#f3d9a8">
                                            &nbsp;
                                        </td>
                                        <td width="18%" align="left" valign="middle" bgcolor="#f3d9a8">
                                            Date
                                        </td>
                                        <td width="32%" align="left" valign="middle" bgcolor="#f3d9a8">
                                            File No.
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" valign="top">
                                            &nbsp;
                                        </td>
                                        <td colspan="2" align="left" valign="top">
                                            <input name="txtMAWBNum" type="text" class="m_shorttextfield" id="txtMAWBNum" value=""
                                                size="24" style="width: 245px" />
                                            <div id="divGoToMAWB" class="goto">
                                                <a href="javascript:goToHAWB();">
                                                    <img src="/ASP/Images/icon_goto.gif" width="36" height="21" align="absbottom" alt="" />Go
                                                    to HAWB</a></div>
                                        </td>
                                        <td align="left" valign="top">
                                            <input class="m_shorttextfield date" type="text" name="txtExecDate" size="14" id="txtExecDate"
                                                preset="shortdate" /></td>
                                        <td align="left" valign="top">
                                            <select name="lstPrefix" size="1" class="bodycopy" style="width: 60px" onChange="PrefixChange(this);"
                                                id="lstPrefix">
                                            </select>
                                            <input name="txtFileNo" class="shorttextfield" style="width: 120px; margin-left: 8px" id="txtFileNo" />
                                        </td>
                                    </tr>
                                <tr>
                                    <td height="2" colspan="5" bgcolor="#997132">
                                    </td>
                                </tr>
                        <tr bgcolor="#f3f3f3" class="bodyheader">
                            <td align="left" valign="middle">
                                &nbsp;
                            </td>
                            <td height="18" align="left" valign="middle">
                                Customer</td>
                            <td align="left" valign="middle">
                                &nbsp;
                            </td>
                            <td align="left" valign="middle">
                                &nbsp;
                            </td>
                            <td align="left" valign="middle">
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td align="left" valign="top">
                                &nbsp;
                            </td>
                            <td colspan="2" align="left" valign="top">
                                <input type="hidden" id="hCustomerAcct" name="hCustomerAcct" />
                                <div id="lstCustomerDiv">
                                </div>
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td>
                                            <input type="text" autocomplete="off" id="lstCustomer" name="lstCustomer" value=""
                                                class="shorttextfield" style="width: 230px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onKeyUp="organizationFill(this,'Agent','lstCustomerChange',null,event)"
                                                onfocus="initializeJPEDField(this,event);" /></td>
                                        <td>
                                            <img src="/ig_common/Images/combobox_drop.gif" alt="" onClick="organizationFillAll('lstCustomer','Agent','lstCustomerChange',null,event)"
                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                        <td>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td align="left" valign="top">
                                &nbsp;
                            </td>
                            <td align="left" valign="top">
                                &nbsp;
                            </td>
                        </tr>
                        <tr class="bodyheader">
                            <td align="left" valign="middle" bgcolor="#f3f3f3">
                                &nbsp;
                            </td>
                            <td height="18" align="left" valign="middle" bgcolor="#f3f3f3">
                                Origin</td>
                            <td align="left" valign="middle" bgcolor="#f3f3f3">
                                &nbsp;
                            </td>
                            <td align="left" valign="middle" bgcolor="#f3f3f3">
                                Destination</td>
                            <td align="left" valign="middle" bgcolor="#f3f3f3">
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td align="left" valign="top">
                                &nbsp;
                            </td>
                            <td colspan="2" align="left" valign="top">
                                <select name="lstOriginPort" size="1" class="shorttextfield" style="width: 245px"
                                    tabindex="7" id="lstOriginPort">
                                    <% For i=0 To port_list.Count-1 %>
                                    <option value="<%=port_list(i)("port_code") %>" <% if port_list(i)("port_code") = dataTable("Origin_Port_ID") Then Response.Write("selected") %>>
                                        <%=port_list(i)("port_desc") %>
                                    </option>
                                    <% Next %>
                                </select>
                            </td>
                            <td colspan="2" align="left" valign="top">
                                <select name="lstDestPort" size="1" class="shorttextfield" style="width: 245px" tabindex="7"
                                    id="lstDestPort">
                                    <% For i=0 To port_list.Count-1 %>
                                    <option value="<%=port_list(i)("port_code") %>" <% if port_list(i)("port_code") = dataTable("Dest_Port_ID") Then Response.Write("selected") %>>
                                        <%=port_list(i)("port_desc") %>
                                    </option>
                                    <% Next %>
                                </select>
                            </td>
                        </tr>
                        <tr class="bodyheader">
                            <td align="left" valign="top">
                                &nbsp;
                            </td>
                            <td height="18" align="left" valign="middle" bgcolor="#f3f3f3">
                                Carrier</td>
                            <td align="left" valign="middle" bgcolor="#f3f3f3">
                                &nbsp;
                            </td>
                            <td align="left" valign="middle" bgcolor="#f3f3f3">
                                &nbsp;
                            </td>
                            <td align="left" valign="middle" bgcolor="#f3f3f3">
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td align="left" valign="top">
                                &nbsp;
                            </td>
                            <td colspan="2" align="left" valign="top">
                                <input type="hidden" id="hCarrierAcct" name="hCarrierAcct" />
                                <div id="lstCarrierDiv">
                                </div>
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td>
                                            <input type="text" autocomplete="off" id="lstCarrier" name="lstCarrier" value=""
                                                class="shorttextfield" style="width: 230px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onKeyUp="organizationFill(this,'Carrier','lstCarrierChange',null,event)"
                                                onfocus="initializeJPEDField(this,event);" /></td>
                                        <td>
                                            <img src="/ig_common/Images/combobox_drop.gif" alt="" onClick="organizationFillAll('lstCarrier','Carrier','lstCarrierChange',null,event)"
                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                        <td>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td align="left" valign="top">
                                &nbsp;
                            </td>
                            <td align="left" valign="top">
                                &nbsp;
                            </td>
                        </tr>
                        <tr class="bodyheader">
                            <td align="left" valign="middle" bgcolor="#f3f3f3">
                                &nbsp;
                            </td>
                            <td height="18" align="left" valign="middle" bgcolor="#f3f3f3">
                                Flight No.
                            </td>
                            <td align="left" valign="middle" bgcolor="#f3f3f3">
                                &nbsp;
                            </td>
                            <td align="left" valign="middle" bgcolor="#f3f3f3">
                                Departure Date
                            </td>
                            <td align="left" valign="middle" bgcolor="#f3f3f3">
                                Arrival Date
                            </td>
                        </tr>
                        <tr>
                            <td align="left" valign="top" style="height: 18px">
                                &nbsp;
                            </td>
                            <td align="left" valign="top" style="height: 18px">
                                <input name="txtFlightNo" class="shorttextfield" maxlength="8" value="" size="24" id="txtFlightNo"></td>
                            <td align="left" valign="top" style="height: 18px">
                                &nbsp;
                            </td>
                            <td align="left" valign="top" style="height: 18px">
                                <input class="m_shorttextfield date" type="text" name="txtDepDate" size="14" id="txtDepDate"
                                    preset="shortdate" /></td>
                            <td align="left" valign="top" style="height: 18px">
                                <input class="m_shorttextfield date" type="text" name="txtArrDate" size="14" id="txtArrDate"
                                    preset="shortdate" /></td>
                        </tr>
                    </table>
                </td>
                </tr> </table> </td>
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
                                <img src="/ASP/Images/spacer.gif" width="70" height="5" /><img src="/ASP/Images/spacer.gif"
                                    width="70" height="5" />
                            </td>
                            <td width="48%" align="center" valign="middle">
                                <img src="../images/button_save_medium.gif" name="bSave" width="46" height="18" id="bSave"
                                    style="cursor: hand" onClick="saveValues()" /></td>
                            <td width="13%" align="right" valign="middle">
                            </td>
                            <td width="13%" align="right" valign="middle">
                                &nbsp;
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
