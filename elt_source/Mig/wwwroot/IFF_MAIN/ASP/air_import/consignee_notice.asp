<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% Option Explicit %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>eARRIVAL NOTICE</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <!--  #INCLUDE FILE="../include/connection.asp" -->
    <!--  #INCLUDE FILE="../include/header.asp" -->
    <!--  #INCLUDE FILE="../include/GOOFY_data_manager.inc" -->
    <!--  #INCLUDE FILE="../include/GOOFY_Util_fun.inc" -->
    <!--  #INCLUDE FILE="../include/SaveBinaryFile.asp" -->
    <%
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
    
    Dim vYourName, vYourEmail, vBillType, vBillNum, vSec, vMode, vDBA
    Dim feData, SQL, i, j, aAllData, aOrgData, aHouseData
    
    Call GetParameters
    vYourName = login_name
    vYourEmail = GetSQLResult("SELECT user_email FROM users WHERE userid=" & user_id & " AND elt_account_number=" & elt_account_number, Null)
    
    eltConn.BeginTrans()
    
    Set feData = new DataManager
    
    If vMode = "search" Then
    
        If vBillType = "file" Then
            SQL = "SELECT a.sec,c.invoice_no,a.mawb_num,b.hawb_num,d.owner_email,e.MsgTxt,d.org_account_number as agent_no,d.dba_name as agent_name,b.pieces,b.gross_wt,b.freight_collect+b.oc_collect as col_amt,b.pickup_date " _
                & "FROM import_mawb a LEFT OUTER JOIN import_hawb b ON (a.elt_account_number=b.elt_account_number AND a.mawb_num=b.mawb_num AND a.sec=b.sec AND a.iType=b.iType) " _
                & "LEFT OUTER JOIN invoice c ON (a.elt_account_number=c.elt_account_number AND a.mawb_num=c.mawb_num AND b.hawb_num=c.hawb_num AND a.iType=c.air_ocean) " _
                & "LEFT OUTER JOIN organization d ON (a.elt_account_number=d.elt_account_number AND b.consignee_acct=d.org_account_number) " _
                & "LEFT OUTER JOIN greetMessage e ON (a.elt_account_number=e.AgentID AND e.MsgType='AI/eArrival Notice') " _
                & "WHERE a.elt_account_number=" & elt_account_number & " AND a.file_no=N'" & vBillNum & "' AND a.iType='A' AND ISNULL(b.mawb_num,'')<>'' AND c.import_export='I'"
        Elseif vBillType = "master" Then
            SQL = "SELECT a.sec,c.invoice_no,a.mawb_num,b.hawb_num,d.owner_email,e.MsgTxt,d.org_account_number as agent_no,d.dba_name as agent_name,b.pieces,b.gross_wt,b.freight_collect+b.oc_collect as col_amt,b.pickup_date " _
                & "FROM import_mawb a LEFT OUTER JOIN import_hawb b ON (a.elt_account_number=b.elt_account_number AND a.mawb_num=b.mawb_num AND a.sec=b.sec AND a.iType=b.iType) " _
                & "LEFT OUTER JOIN invoice c ON (a.elt_account_number=c.elt_account_number AND a.mawb_num=c.mawb_num AND b.hawb_num=c.hawb_num AND a.iType=c.air_ocean) " _
                & "LEFT OUTER JOIN organization d ON (a.elt_account_number=d.elt_account_number AND b.consignee_acct=d.org_account_number) " _
                & "LEFT OUTER JOIN greetMessage e ON (a.elt_account_number=e.AgentID AND e.MsgType='AI/eArrival Notice') " _
                & "WHERE a.elt_account_number=" & elt_account_number & " AND a.mawb_num=N'" & vBillNum & "' AND a.iType='A' AND ISNULL(b.mawb_num,'')<>'' AND c.import_export='I'"
        Else
            
        End If

        feData.SetDataList(SQL)
        Set aAllData = feData.getDataList
        Set aOrgData = DataListGroupBy(aAllData,"agent_no")
        
    End If
    
    eltConn.CommitTrans()

    Sub GetParameters
        vDBA = GetSQLResult("select dba_name from agent where elt_account_number=" & elt_account_number, "dba_name")
        vMode = Request.QueryString("mode")
        vBillNum = Request.QueryString("no")
        vBillType = Request.QueryString("type")
        
    End Sub
    
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
	        
	        var url = "consignee_notice.asp?mode=search&type=" + typeValue + "&no=" + argV;
            self.window.location.href = encodeURI(url);
        }
        
        function searchNumFill(obj,iType,changeFunction,vHeight){
            var qStr = obj.value;
            var keyCode = window.event.keyCode;
            var typeIndex = document.getElementById("lstSearchType").selectedIndex;
	        var typeValue = document.getElementById("lstSearchType").options[typeIndex].value;

            if(qStr != "" && keyCode != 229 && keyCode != 27){
                var url = "/IFF_MAIN/asp/ajaxFunctions/ajax_get_bills.asp?mode=list&import=" + iType + "&qStr=" 
                    + qStr + "&type=" + typeValue;
                
                FillOutJPED(obj,url,changeFunction,vHeight);
            }
        }
        
        function searchNumFillAll(objName,iType,changeFunction,vHeight){
            var obj = document.getElementById(objName);
            var typeIndex = document.getElementById("lstSearchType").selectedIndex;
	        var typeValue = document.getElementById("lstSearchType").options[typeIndex].value;
	        
            var url = "/IFF_MAIN/asp/ajaxFunctions/ajax_get_bills.asp?mode=list&import=" + iType + "&type=" + typeValue;

            FillOutJPED(obj,url,changeFunction,vHeight);
        }
        
        function ShowEmailHistory(){
            viewPop("../../ASPX/MISC/EmailHistory.aspx?title=EArrival Notice&ao=A&ie=I");
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

            document.form1.action = "consignee_notice_send.asp?WindowName=MailSend";
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
        
        function SyncCheck(thisObj,otherObjId){
            if(thisObj.checked){
                document.getElementById(otherObjId).checked = false;
            }
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
                    eARRIVAL NOTICE
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
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td>
                                <span class="bodyheader">
                                    <select id="lstSearchType" style="width: 115px" class="bodyheader" onchange="selectSearchType();">
                                        <option value="master">MASTER AWB No.</option>
                                        <option value="file">FILE No.</option>
                                        <!-- <option value="none">ANONYMOUS</option> -->
                                    </select>
                                </span>
                            </td>
                            <td>
                                &nbsp;</td>
                            <td width="84%">
                                <!-- Start JPED -->
                                <input type="hidden" id="hSearchNum" name="hSearchNum" />
                                <div id="lstSearchNumDiv">
                                </div>
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td>
                                            <input type="text" autocomplete="off" id="lstSearchNum" name="lstSearchNum" value=""
                                                class="shorttextfield" style="width: 200px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
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
                        </tr>
                    </table>
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
        <table align="center" bgcolor="#ba9590" border="0" bordercolor="#ba9590" cellpadding="0"
            cellspacing="0" class="border1px" width="95%">
            <tr>
                <td height="100%">
                    <table border="0" cellpadding="2" cellspacing="0" width="100%">
                        <tr>
                            <td align="center" bgcolor="#edd3cf" class="bodyheader" colspan="6" height="24" valign="middle">
                                <span class="pageheader">
                                    <img height="18" name="bSend" onclick="SendClick()" src="../images/button_send_email.gif"
                                        style="cursor: hand" width="101" /></span></td>
                        </tr>
                        <tr bgcolor="#ba9590">
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
                                <table bgcolor="#edd3cf" border="0" bordercolor="#ba9590" cellpadding="2" cellspacing="0"
                                    class="border1px" width="65%">
                                    <tr align="left" bgcolor="#F3f3f3" valign="middle">
                                        <td align="left" class="bodycopy" valign="middle" width="1">
                                            &nbsp;</td>
                                        <td align="left" class="bodyheader" height="20" valign="middle" width="222">
                                            Your Name</td>
                                        <td align="left" class="bodycopy" valign="middle" width="408">
                                        </td>
                                        <td align="left" class="bodycopy" valign="middle" width="408">
                                        </td>
                                    </tr>
                                    <tr align="left" bgcolor="#F3f3f3" valign="middle">
                                        <td align="left" bgcolor="#ffffff" class="bodycopy" valign="middle">
                                            &nbsp;</td>
                                        <td align="left" bgcolor="#ffffff" class="bodycopy" colspan="3" valign="middle">
                                            <input class="shorttextfield" id="txtYourName" name="txtYourName" size="28" value="<%= vYourName %>" />
                                        </td>
                                    </tr>
                                    <tr align="left" bgcolor="#F3f3f3" valign="middle">
                                        <td align="left" class="bodycopy" height="20" valign="middle">
                                            &nbsp;</td>
                                        <td align="left" class="bodyheader" height="20" valign="middle">
                                            From</td>
                                        <td align="left" class="bodycopy" height="20" valign="middle">
                                            &nbsp;</td>
                                        <td align="left" class="bodycopy" valign="middle">
                                            &nbsp;</td>
                                    </tr>
                                    <tr align="left" bgcolor="#f3f3f3" valign="middle">
                                        <td align="left" bgcolor="#ffffff" class="bodycopy" valign="middle">
                                            &nbsp;</td>
                                        <td align="left" bgcolor="#ffffff" class="bodycopy" colspan="3" valign="middle">
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
                                    <table class="bodycopy" cellpadding="0" cellspacing="0" border="0" style="width: 100%">
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
                                                                value="EArrival Notice: <%=vDBA %> MAWB: <%=aOrgData(i)("mawb_num") %>" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="bodyheader" valign="top">
                                                        </td>
                                                        <td>
                                                            <table class="bodycopy" cellpadding="2px" cellspacing="0" border="0" id="tblHouses">
                                                                <tr style="height: 20px">
                                                                    <td class="bodyheader">
                                                                        Master AWB No.
                                                                    </td>
                                                                </tr>
                                                                <tr style="height: 20px">
                                                                    <td>
                                                                        <a href="javascript:viewPop('air_import2.asp?iType=A&Edit=yes&Search=yes&MAWB=<%=aOrgData(i)("mawb_num")%>')">
                                                                            <%=aOrgData(i)("mawb_num")%>
                                                                        </a>
                                                                    </td>
                                                                </tr>
                                                                <tr class="bodyheader" style="background-color: #dddddd; height: 20px">
                                                                    <td style="width: 180px">
                                                                        House AWB No.
                                                                    </td>
                                                                    <td style="width: 180px">
                                                                        Arrival Notice
                                                                    </td>
                                                                    <td style="width: 180px">
                                                                        Arrival Notice & Freight Charge
                                                                    </td>
                                                                </tr>
                                                                <% Set aHouseData = DataListGroupBy(DataListSelect(aAllData, "agent_no", aOrgData(i)("agent_no")),"hawb_num") %>
                                                                <% For j = 0 To aHouseData.Count-1 %>
                                                                <tr style="height: 20px">
                                                                    <td>
                                                                        <a href="javascript:viewPop('arrival_notice.asp?iType=A&Edit=yes&HAWB=<%=aHouseData(j)("hawb_num")%>&MAWB=<%=aHouseData(j)("mawb_num")%>')">
                                                                            <% If aHouseData(j)("hawb_num") = "" Then %>
                                                                            BLANK
                                                                            <% Else %>
                                                                            <%=aHouseData(j)("hawb_num")%>
                                                                            <% End If %>
                                                                        </a>
                                                                    </td>
                                                                    <td>
                                                                        <input type="checkbox" name="chkAN" id="chkAN<%=j %>" onclick="SyncCheck(this,'chkANFC<%=j %>')" value="<%=aHouseData(j)("hawb_num")%>" />
                                                                        <a href="arrival_notice_pdf.asp?iType=A&MAWB=<%=aHouseData(j)("mawb_num")%>&HAWB=<%=aHouseData(j)("hawb_num")%>&SEC=<%=aHouseData(j)("sec") %>&doInvoice=no">
                                                                            <%=aHouseData(j)("invoice_no")%>
                                                                        </a>
                                                                    </td>
                                                                    <td>
                                                                        <input type="checkbox" name="chkANFC" id="chkANFC<%=j %>" onclick="SyncCheck(this,'chkAN<%=j %>')" value="<%=aHouseData(j)("hawb_num")%>" />
                                                                        <a href="arrival_notice_pdf.asp?iType=A&MAWB=<%=aHouseData(j)("mawb_num")%>&HAWB=<%=aHouseData(j)("hawb_num")%>&SEC=<%=aHouseData(j)("sec") %>&doInvoice=yes">
                                                                            <%=aHouseData(j)("invoice_no")%>
                                                                        </a>
                                                                    </td>
                                                                </tr>
                                                                <% Next %>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="height: 5px">
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
                                                        <td style="height: 10px">
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
                        <tr bgcolor="#ba9590">
                            <td align="left" class="bodyheader" colspan="6" height="1" valign="top">
                            </td>
                        </tr>
                        <tr bgcolor="#edd3cf">
                            <td align="center" bgcolor="#edd3cf" class="bodyheader" colspan="6" height="24" valign="middle">
                                <span class="pageheader">
                                    <img height="18" name="bSend" onclick="SendClick()" src="../images/button_send_email.gif"
                                        style="cursor: hand" width="101" /></span></td>
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
