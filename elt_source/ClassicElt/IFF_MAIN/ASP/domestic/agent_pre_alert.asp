<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% Option Explicit %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Pre-Alert</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <!--  #INCLUDE FILE="../include/connection.asp" -->
    <!--  #INCLUDE FILE="../include/header.asp" -->
    <!--  #INCLUDE FILE="../include/GOOFY_data_manager.inc" -->
    <!--  #INCLUDE FILE="../include/GOOFY_Util_fun.inc" -->
    <!--  #INCLUDE FILE="../include/SaveBinaryFile.asp" -->
    <%
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
    
    Dim vYourName, vYourEmail, vBillType, vBillNum, vMode, vDBA
    Dim vMAWB, vHAWB, feData, SQL, i, j, aAllData, aOrgData, aHouseData
    
    vBillType = Request.QueryString("type")
    vBillNum = Request.QueryString("no")
    vMode = Request.QueryString("mode")
    vDBA = GetSQLResult("select dba_name from agent where elt_account_number=" & elt_account_number, "dba_name")
    vYourName = login_name
    vYourEmail = GetSQLResult("SELECT user_email FROM users WHERE userid=" & user_id & " AND elt_account_number=" & elt_account_number, Null)
    
    eltConn.BeginTrans()
    
    Set feData = new DataManager
    
    If vMode = "search" Then
    
        If vBillType = "house" Then
        
            SQL = "SELECT 'N' as isDirect,a.mawb_num,b.hawb_num,b.agent_no,b.agent_name,ISNULL(c.invoice_no,-1) as invoice_no,d.owner_email,d.edt,d.agent_elt_acct,MsgTxt,a.master_agent" _
                & " FROM mawb_master a LEFT OUTER JOIN hawb_master b ON (a.elt_account_number=b.elt_account_number AND a.mawb_num=b.mawb_num)" _
                & " LEFT OUTER JOIN invoice c ON (b.elt_account_number=c.elt_account_number AND b.mawb_num=c.mawb_num AND b.hawb_num=c.hawb_num AND c.air_ocean='A' AND c.import_export='E')" _
                & " LEFT OUTER JOIN organization d ON (b.elt_account_number=d.elt_account_number AND b.agent_no=d.org_account_number)" _
                & " LEFT OUTER JOIN greetMessage e ON (b.elt_account_number=e.AgentID AND MsgType='AE/Agent Pre-Alert')" _
                & " WHERE a.elt_account_number=" & elt_account_number & " AND a.mawb_num=(SELECT TOP 1 mawb_num FROM hawb_master" _
                & " WHERE elt_account_number=" & elt_account_number & " AND hawb_num=N'" & vBillNum & "') AND ISNULL(b.agent_no,0)<>0 ORDER BY b.agent_name, b.hawb_num"

        Elseif vBillType = "master" Then
        
            SQL = "SELECT 'N' as isDirect,a.mawb_num,b.hawb_num,b.agent_no,b.agent_name,ISNULL(c.invoice_no,-1) as invoice_no,d.owner_email,d.edt,d.agent_elt_acct,MsgTxt,a.master_agent" _
                & " FROM mawb_master a LEFT OUTER JOIN hawb_master b ON (a.elt_account_number=b.elt_account_number AND a.mawb_num=b.mawb_num)" _
                & " LEFT OUTER JOIN invoice c ON (b.elt_account_number=c.elt_account_number AND b.mawb_num=c.mawb_num AND b.hawb_num=c.hawb_num AND c.air_ocean='A' AND c.import_export='E')" _
                & " LEFT OUTER JOIN organization d ON (b.elt_account_number=d.elt_account_number AND b.agent_no=d.org_account_number)" _
                & " LEFT OUTER JOIN greetMessage e ON (b.elt_account_number=e.AgentID AND MsgType='AE/Agent Pre-Alert')" _
                & " WHERE a.elt_account_number=" & elt_account_number & " AND a.mawb_num='" & vBillNum & "' AND ISNULL(b.agent_no,0)<>0 ORDER BY b.agent_name, b.hawb_num"
            
            '// direct shipment 
            If Not IsDataExist(SQL) Then
                SQL = "SELECT 'Y' as isDirect,a.mawb_num,'' AS hawb_num,a.consignee_acct_num as agent_no,a.consignee_name as agent_name,ISNULL(c.invoice_no,-1) as invoice_no,d.owner_email,d.edt,d.agent_elt_acct,MsgTxt,a.master_agent" _
                    & " FROM mawb_master a LEFT OUTER JOIN invoice c ON (a.elt_account_number=c.elt_account_number AND a.mawb_num=c.mawb_num AND ISNULL(c.hawb_num,'')='' AND c.air_ocean='A' AND c.import_export='E')" _
                    & " LEFT OUTER JOIN organization d ON (a.elt_account_number=d.elt_account_number AND CAST(a.consignee_acct_num AS NVARCHAR)=CAST(d.org_account_number AS NVARCHAR))" _
                    & " LEFT OUTER JOIN greetMessage e ON (a.elt_account_number=e.AgentID AND MsgType='AE/Agent Pre-Alert')" _
                    & " WHERE a.elt_account_number=" & elt_account_number & " AND a.mawb_num='" & vBillNum & "' AND ISNULL(a.consignee_acct_num,0)<>0 ORDER BY a.consignee_name"
            End If
            
        Elseif vBillType = "file" Then
        
            SQL = "SELECT 'N' as isDirect,a.mawb_num,f.file#,b.hawb_num,b.agent_no,b.agent_name,ISNULL(c.invoice_no,-1) as invoice_no,d.owner_email,d.edt,d.agent_elt_acct,MsgTxt,a.master_agent" _
                & " FROM mawb_master a LEFT OUTER JOIN hawb_master b ON (a.elt_account_number=b.elt_account_number AND a.mawb_num=b.mawb_num)" _
                & " LEFT OUTER JOIN invoice c ON (b.elt_account_number=c.elt_account_number AND b.mawb_num=c.mawb_num AND b.hawb_num=c.hawb_num AND c.air_ocean='A' AND c.import_export='E')" _
                & " LEFT OUTER JOIN organization d ON (b.elt_account_number=d.elt_account_number AND CAST(b.consignee_acct_num AS NVARCHAR)=CAST(d.org_account_number AS NVARCHAR))" _
                & " LEFT OUTER JOIN greetMessage e ON (b.elt_account_number=e.AgentID AND MsgType='AE/Agent Pre-Alert')" _
                & " LEFT OUTER JOIN mawb_number f ON (b.elt_account_number=f.elt_account_number AND b.mawb_num=f.mawb_no)" _
                & " WHERE a.elt_account_number=" & elt_account_number & " AND f.file#='" & vBillNum & "' AND ISNULL(b.agent_no,0)<>0 ORDER BY agent_name, b.hawb_num"
        
            '// direct shipment 
            If Not IsDataExist(SQL) Then
                SQL = "SELECT 'Y' as isDirect,a.mawb_num,f.file#,'' AS hawb_num,a.consignee_acct_num as agent_no,a.consignee_name as agent_name,ISNULL(c.invoice_no,-1) as invoice_no,d.owner_email,d.edt,d.agent_elt_acct,MsgTxt,a.master_agent " _
                    & " FROM mawb_master a LEFT OUTER JOIN invoice c ON (a.elt_account_number=c.elt_account_number AND a.mawb_num=c.mawb_num AND ISNULL(c.hawb_num,'')='' AND c.air_ocean='A' AND c.import_export='E') " _
                    & " LEFT OUTER JOIN organization d ON (a.elt_account_number=d.elt_account_number AND CAST(a.consignee_acct_num AS NVARCHAR)=CAST(d.org_account_number AS NVARCHAR)) " _
                    & " LEFT OUTER JOIN greetMessage e ON (a.elt_account_number=e.AgentID AND MsgType='AE/Agent Pre-Alert') " _
                    & " LEFT OUTER JOIN mawb_number f ON (a.elt_account_number=f.elt_account_number AND a.mawb_num=f.mawb_no) " _
                    & " WHERE a.elt_account_number=" & elt_account_number & " AND f.file#='" & vBillNum & "' AND ISNULL(a.consignee_acct_num,0)<>0 ORDER BY a.consignee_name"
            End If
        Else

        End If
        
        '// Response.Write(SQL)
        feData.SetDataList(SQL)
        Set aAllData = feData.getDataList
        Set aOrgData = DataListGroupBy(aAllData,"agent_no")
        
    End If
    
    eltConn.CommitTrans()
    
    
    Function GetUserFileList(vOrgNum)
        Dim aUserFileList, i, SQL, rs
        Set aUserFileList = Server.CreateObject("System.Collections.ArrayList")
        
        If IsNull(vOrgNum) Then
            vOrgNum = "-1"
        End If
        
        SQL = "SELECT [file_name] FROM user_files WHERE elt_account_number=" _
            & elt_account_number & " AND org_no=" & vOrgNum & " AND file_checked='Y'"
        
        Set rs = Server.CreateObject("ADODB.RecordSet")
        rs.Open SQL, eltConn, adOpenForwardOnly,adLockReadOnly,adCmdText
        '// Set rs.activeConnection = Nothing
        
        Do While Not rs.EOF And Not rs.BOF
            aUserFileList.Add rs("file_name")
            rs.MoveNext
        Loop
        Set GetUserFileList = aUserFileList
    End Function
    
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
        Dim aValueList,newDataList,i,j
        
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
    
    '// EDT is enabled when an agent has an active EDT ELT account (from CP Profile) and has house bill (not direct shipment)
    '// Direct shipments will be alerted to consignee in a master airway bill
    '// Master is required when searched by house
    
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
	        var url = "agent_pre_alert.asp?mode=search&type=" + typeValue + "&no=" + argV;
            self.window.location.href = encodeURI(url);
        }

        function searchNumFill(obj,eType,changeFunction,vHeight){
            var qStr = obj.value;
            var keyCode = window.event.keyCode;
            var typeValue = document.getElementById("lstSearchType").value

            if(qStr != "" && keyCode != 229 && keyCode != 27 && typeValue != ""){
                var url = "/IFF_MAIN/asp/ajaxFunctions/ajax_get_bills.asp?mode=list&domestic=Y&export=" + eType + "&qStr=" 
                    + qStr + "&type=" + typeValue;
                FillOutJPED(obj,url,changeFunction,vHeight);
            }
        }
        
        function searchNumFillAll(objName,eType,changeFunction,vHeight){
            var obj = document.getElementById(objName);
            var typeValue = document.getElementById("lstSearchType").value;
            var url;
            
            if(typeValue != "")
            {
                url = "/IFF_MAIN/asp/ajaxFunctions/ajax_get_bills.asp?mode=list&domestic=Y&type=" 
                    + typeValue + "&export=" + eType;
                FillOutJPED(obj,url,changeFunction,vHeight);
            }
        }
        
        function ShowEmailHistory(){
            viewPop("../../ASPX/MISC/EmailHistory.aspx?title=Pre-Alert&ao=A&ie=E");
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
        
        function UploadFile(arg){
            try{
                var winArg = "dialogWidth:550px; dialogHeight:400px; help:0; status:0; scroll:1; center:1; Sunken;";
                var returnValue = showModalDialog("upload_file.asp?WindowName=FileUpload&OrgNo=" + arg, "FileUpload", winArg);
                var htmlStr = returnValue.length + " Attached File(s)";
            
                document.getElementById("aAttachedFiles" + arg).innerHTML = returnValue.length + " Attached File(s)";
            }catch(err){}
        }
        
        function chkOrgClick(arg,thisObj){
            var tableObj = document.getElementById("tblOrg" + arg)
            var checkVal = thisObj.checked;
            
            if(!checkVal){
                makeAllDiabled(tableObj);
            }
            
            else{
                makeAllEnabled(tableObj);
            }
        }
        <% If agent_status = "A" Or agent_status = "T" Then %>
        function SendClick(){
            if(ValidateForm()){
                var argS = "menubar=0,toolbar=0,height=200,width=450,hotkeys=0,scrollbars=1,resizable=1";
                var popUpWindow = window.open("loading.html", "MailSend", argS);
                setTimeout(SendClickFormSubmit,100);
            }
        }
        
        function SendClickFormSubmit(){
            document.form1.action = "agent_pre_alert_send.asp?WindowName=MailSend";
            document.form1.method = "POST";
            document.form1.encoding = "application/x-www-form-urlencoded";
            document.form1.target = "MailSend";
            document.form1.submit();
        }
        <% Else %>
        function SendClick(){
            alert("Premium subscription is needed for this feature.");
        }
        <% End If %>
        function ValidateForm(){

            if(document.getElementById("txtYourName").value == ""){
                alert("Please, enter your name.");
                return false;
            }
            if(document.getElementById("txtYourEmail").value == ""){
                alert("Please, enter your name.");
                return false;
            }
            var aOrgCheck = document.getElementsByName("chkOrg");
            var aEmailNames = document.getElementsByName("txtEmailName");
            var aEmailTos = document.getElementsByName("txtEmailTo");
            
            if(aOrgCheck.length == 0){
                alert("No recipients are selected.");
                return false;
            }
            
            for(var i=0; i<aEmailNames.length; i++){
                if(aOrgCheck[i].checked){
                    if(aEmailNames[i].value == ""){
                        alert("Please, enter reciepient's name.");
                        return false;
                    }
                    if(aEmailTos[i].value == ""){
                        alert("Please, enter reciepient's email address.");
                        return false;
                    }
                }
            }
            return true;
        }
        
    </script>

    <script type="text/jscript" src="../include/JPTableDOM.js"></script>

    <script type="text/javascript" src="../include/tooltips.js"></script>

    <script type="text/javascript" language="javascript" src="../ajaxFunctions/ajax.js"></script>

    <script type="text/javascript" src="../include/JPED.js"></script>

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
                    Agent Pre-Alert
                </td>
            </tr>
        </table>
    </div>
    <div class="selectarea" style="text-align: center">
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td style="height: 15px; width: 200px" valign="top" colspan="2">
                    <span class="select">Select AWB Type and No.</span></td>
            </tr>
            <tr>
                <td style="width: 130px">
                    <select id="lstSearchType" class="bodyheader" style="width: 120px" onchange="javascript:selectSearchType();">
                        <option value="house">House AWB No.</option>
                        <option value="master">Master AWB No.</option>
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
                                    border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="searchNumFill(this,'A','lstSearchNumChange',200);"
                                    onfocus="initializeJPEDField(this);" /></td>
                            <td>
                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="searchNumFillAll('lstSearchNum','A','lstSearchNumChange',200);"
                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                    border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                        </tr>
                    </table>
                    <!-- End JPED -->
                </td>
                <td align="right">
                    <span class="goto">
                        <img src="/iff_main/ASP/Images/icon_email_history.gif" align="absbottom" alt="" /><a
                            href="javascript:;" onclick="ShowEmailHistory()">View Email History</a></span>
                </td>
            </tr>
        </table>
    </div>
    <form id="form1" name="form1" accept-charset="UTF-8" action="">
        <table align="center" border="0" style="width: 95%; border: solid 1px #997132" cellpadding="0"
            cellspacing="0" class="border1px" width="95%">
            <tr>
                <td height="100%">
                    <table border="0" cellpadding="2" cellspacing="0" width="100%">
                        <tr>
                            <td align="center" bgcolor="#eec983" class="bodyheader" colspan="6" height="24" valign="middle">
                                <span class="pageheader">
                                    <img height="18" name="bSend" onclick="SendClick()" src="../images/button_send_email.gif"
                                        style="cursor: hand" width="101" alt="" /></span></td>
                        </tr>
                        <tr bgcolor="#997132">
                            <td align="left" class="bodyheader" colspan="6" height="1" valign="top">
                            </td>
                        </tr>
                        <tr align="center" bgcolor="#f0e7ef" valign="middle">
                            <td align="center" bgcolor="#eeeeee" class="bodyheader" colspan="6" height="24">
                                <br />
                                <table border="0" cellpadding="0" cellspacing="0" width="65%">
                                    <tr>
                                        <td align="left" valign="middle" width="50%">
                                        </td>
                                        <td align="right" class="bodyheader" height="28" width="50%">
                                            <img align="absBottom" src="/iff_main/ASP/Images/required.gif" />Required field</td>
                                    </tr>
                                </table>
                                <table sborder="0" bordercolor="#997132" cellpadding="2" cellspacing="0"
                                    class="border1px" width="65%">
                                    <tr align="left" valign="middle" bgcolor="#f3d9a8">
                                        <td align="left" class="bodycopy" valign="middle" width="1">
                                            &nbsp;</td>
                                        <td align="left" class="bodyheader" height="20" valign="middle"
                                            width="222">
                                            Your Name</td>
                                        <td align="left" class="bodycopy" valign="middle" width="408">
                                        </td>
                                        <td align="left" class="bodycopy" valign="middle" width="408">
                                        </td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="#ffffff">
                                        <td align="left" class="bodycopy" valign="middle">
                                            &nbsp;</td>
                                        <td align="left" class="bodycopy" colspan="3" valign="middle">
                                            <input class="shorttextfield" id="txtYourName" name="txtYourName" size="28" value="<%= vYourName %>" />
                                        </td>
                                    </tr>
                                    <tr align="left" bgcolor="#f3d9a8" valign="middle">
                                        <td align="left" class="bodycopy" height="20" valign="middle">
                                            &nbsp;</td>
                                        <td align="left" class="bodyheader" height="20" valign="middle">
                                            From</td>
                                        <td align="left" class="bodycopy" height="20" valign="middle">
                                            &nbsp;</td>
                                        <td align="left" class="bodycopy" valign="middle">
                                            &nbsp;</td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="#ffffff">
                                        <td align="left" class="bodycopy" valign="middle">
                                            &nbsp;</td>
                                        <td align="left" class="bodycopy" colspan="3" valign="middle">
                                            <input class="shorttextfield" id="txtYourEmail" name="txtYourEmail" size="45" type="text"
                                                value="<%= vYourEmail %>" /></td>
                                    </tr>
                                </table>
                                <br />
                            </td>
                        </tr>
                        <tr>
                            <td style="background-color: #eeeeee" class="bodycopy">
                                <% If Not IsEmpty(aOrgData) Then %>
                                <div style="height: 20px" class="bodyheader">
                                    <% If aOrgData.Count = 0 Then %>
                                    No Data Found.
                                    <% Else %>
                                    MAWB:
                                    <%=aOrgData(0)("mawb_num") %>
                                    <input type="hidden" id="hMAWB" name="hMAWB" value="<%=aOrgData(0)("mawb_num") %>" />
                                    <% End If %>
                                </div>
                                <!-------------------------------------- Sorted by Agent List Starts --------------------------------->
                                <% For i = 0 To aOrgData.Count-1 %>
                                <div style="border: solid 1px #cdcdcd; padding: 4px; background-color: #ffffff">
                                    <table class="bodycopy" cellpadding="0" cellspacing="0" border="0" style="width: 90%">
                                        <tr>
                                            <td valign="top" style="width: 35px">
                                                <input type="checkbox" id="chkOrg<%=i %>" name="chkOrg" onclick="chkOrgClick(<%=i %>,this)"
                                                    value="<%=aOrgData(i)("agent_no") %>" checked="checked" /></td>
                                            <td>
                                                <table id="tblOrg<%=i %>" class="bodycopy" cellpadding="0" cellspacing="0" border="0"
                                                    style="width: 100%">
                                                    <tr>
                                                        <td style="width: 160px" class="bodyheader">
                                                            AGENT</td>
                                                        <td>
                                                            <input type="text" class="shorttextfield" size="80" id="txtEmailName<%=i %>" name="txtEmailName"
                                                                value="<%=aOrgData(i)("agent_name") %>" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="bodyheader">
                                                            <img src="/iff_main/ASP/Images/required.gif" align="absbottom" alt="" />TO</td>
                                                        <td>
                                                            <input type="text" class="shorttextfield" size="80" id="txtEmailTo<%=i %>" name="txtEmailTo"
                                                                value="<%=aOrgData(i)("owner_email") %>" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="bodyheader">
                                                            CC</td>
                                                        <td>
                                                            <input type="text" class="shorttextfield" size="80" id="txtEmailCC<%=i %>" name="txtEmailCC"
                                                                value="" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="bodyheader">
                                                            SUBJECT</td>
                                                        <td>
                                                            <input type="text" class="shorttextfield" size="80" id="txtEmailSubject<%=i %>" name="txtEmailSubject"
                                                                value="Pre-Alert: <%=vDBA %> MAWB:<%=aOrgData(i)("mawb_num") %>" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="bodyheader" valign="top">
                                                            <input type="hidden" id="hMasterAgent<%=i %>" name="hMasterAgent" value="<%=aOrgData(i)("master_agent") %>" />
                                                        </td>
                                                        <td>
                                                            <% Set aHouseData = DataListGroupBy(DataListSelect(aAllData, "agent_no", aOrgData(i)("agent_no")),"hawb_num") %>
                                                            <ul style="display: inline; float: none;">
                                                                <li style="display: inline; float: left; list-style: none; width: 200px; overflow: hidden">
                                                                    <input type="checkbox" id="chkMasterPDF<%=i %>" name="chkMasterPDF<%=aOrgData(i)("agent_no") %>"
                                                                        value="<%=aOrgData(i)("agent_no") %>" checked="checked" />
                                                                    <a href="mawb_pdf.asp?MAWB=<%=aOrgData(i)("mawb_num") %>&Copy=CONSIGNEE">
                                                                        MAWB:
                                                                        <%=aOrgData(i)("mawb_num") %>
                                                                    </a>&nbsp;&nbsp;&nbsp;</li>
                                                                <% If aOrgData(i)("isDirect") <> "Y" Then %>
                                                                <!-- Consolidated houses where Agents are assigned to -->
                                                                <li style="display: inline; float: left; list-style: none; width: 200px; overflow: hidden">
                                                                    <input type="checkbox" id="chkManifestPDF<%=i %>" name="chkManifestPDF<%=aOrgData(i)("agent_no") %>"
                                                                        value="<%=aOrgData(i)("agent_no") %>" checked="checked" />
                                                                    <a href="manifest_pdf.asp?MAWB=<%=aOrgData(i)("mawb_num") %>&Agent=<%=aOrgData(i)("agent_no") %>&MasterAgentNo=<%=aOrgData(i)("master_agent") %>">
                                                                        Manifest:
                                                                        <%=aOrgData(i)("mawb_num") %>
                                                                    </a>&nbsp;&nbsp;&nbsp;</li>
                                                                <% For j = 0 To aHouseData.Count-1 %>
                                                                <li style="display: inline; float: left; list-style: none; width: 200px; overflow: hidden">
                                                                    <input type="checkbox" id="chkHousePDF<%=i %><%=j %>" name="chkHousePDF<%=aOrgData(i)("agent_no") %>"
                                                                        value="<%=aHouseData(j)("hawb_num") %>" checked="checked" />
                                                                    <a href="hawb_pdf.asp?HAWB=<%=aHouseData(j)("hawb_num") %>&Copy=CONSIGNEE">
                                                                        HAWB:
                                                                        <%=aHouseData(j)("hawb_num") %>
                                                                    </a>&nbsp;&nbsp;&nbsp;</li>
                                                                <% If aHouseData(j)("invoice_no") <> "-1" Then %>
                                                                <li style="display: inline; float: left; list-style: none; width: 200px; overflow: hidden">
                                                                    <input type="checkbox" id="chkInvoicePDF<%=i %><%=j %>" name="chkInvoicePDF<%=aOrgData(i)("agent_no") %>"
                                                                        value="<%=aHouseData(j)("invoice_no") %>" checked="checked" />
                                                                    <a href="../acct_tasks/invoice_pdf.asp?InvoiceNo=<%=aHouseData(j)("invoice_no") %>">
                                                                        INV:
                                                                        <%=aHouseData(j)("invoice_no") %>
                                                                    </a>&nbsp;&nbsp;&nbsp;</li>
                                                                <% End If %>
                                                                <% Next %>
                                                                <li style="display: inline; float: left; list-style: none; width: 200px; overflow: hidden">
                                                                    <input type="checkbox" id="chkStatementPDF<%=i %>" name="chkStatementPDF<%=aOrgData(i)("agent_no") %>"
                                                                        value="<%=aOrgData(i)("agent_no") %>" checked="checked" />
                                                                    <a href="../acct_tasks/agent_stmt.asp?MAWB=<%=aOrgData(i)("mawb_num") %>&AgentNo=<%=aOrgData(i)("agent_no") %>">
                                                                        STMT:
                                                                        <%=aOrgData(i)("mawb_num") %>
                                                                    </a></li>
                                                                <% Elseif aOrgData(i)("invoice_no") <> "-1" Then %>
                                                                <!-- Direct Master with a invoice created -->
                                                                <li style="display: inline; float: left; list-style: none; width: 200px; overflow: hidden">
                                                                    <input type="checkbox" id="chkInvoicePDF<%=i %>" name="chkInvoicePDF<%=aOrgData(i)("agent_no") %>"
                                                                        value="<%=aOrgData(j)("invoice_no") %>" checked="checked" />
                                                                    <a href="../acct_tasks/invoice_pdf.asp?InvoiceNo=<%=aOrgData(j)("invoice_no") %>">
                                                                        INV:
                                                                        <%=aHouseData(j)("invoice_no") %>
                                                                    </a>&nbsp;&nbsp;&nbsp;</li>
                                                                <% End If %>
                                                            </ul>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="height: 4px">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="bodyheader">
                                                            ATTACHMENT</td>
                                                        <td>
                                                            <a href="javascript:void(UploadFile('<%=aOrgData(i)("agent_no")%>'));" id="aAttachedFiles<%=aOrgData(i)("agent_no")%>">
                                                                <%=GetUserFileList(aOrgData(i)("agent_no")).Count %>
                                                                Attached File(s) </a>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="height: 4px">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="bodyheader" valign="top">
                                                            MESSAGE</td>
                                                        <td>
                                                            <textarea cols="100" rows="4" class="multilinetextfield" id="txtMessage<%=i %>" name="txtMessage"><%=aOrgData(i)("MsgTxt") %></textarea>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td valign="top" align="right">
                                                <% If checkBlank(aOrgData(i)("agent_elt_acct"),"0") = "0" Or checkBlank(aOrgData(i)("edt"),"N") = "N" Or aOrgData(i)("isDirect") = "Y" Then %>
                                                <% Else %>
                                                <table cellpadding="0" cellspacing="0" border="0" style="width: 100px" class="bodycopy">
                                                    <tr>
                                                        <td>
                                                            <input type="checkbox" id="chkOnlineAlert<%=i %>" name="chkOnlineAlert<%=aOrgData(i)("agent_no") %>"
                                                                value="Y" />
                                                        </td>
                                                        <td>
                                                            Online Alert
                                                        </td>
                                                    </tr>
                                                </table>
                                                <% End If %>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <br />
                                <% Next %>
                                <!-------------------------------------- Sorted by Agent List Ends --------------------------------->
                                <% End If %>
                            </td>
                        </tr>
                        <tr bgcolor="#997132">
                            <td align="left" class="bodyheader" colspan="6" height="1" valign="top">
                            </td>
                        </tr>
                        <tr>
                            <td align="center" bgcolor="#eec983" class="bodyheader" colspan="6" height="24" valign="middle">
                                <span class="pageheader">
                                    <img height="18" name="bSend" onclick="SendClick()" src="../images/button_send_email.gif"
                                        style="cursor: hand" width="101" alt="" /></span></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <br />
    </form>
</body>
<% Set feData = Nothing %>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
