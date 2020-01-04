<%@  language="VBScript" %>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Create Invoices</title>
    <meta http-equiv="Content-Type" content="text/html; charset=windows-1252" />
    <link href="/ASP/css/elt_css.css" rel="stylesheet" type="text/css" />
    <link href="/ASP/css/elt_css.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .style1
        {
            color: #cc6600;
        }
        
        .gridViewTable
        {
            table-layout: fixed;
            border-collapse: collapse;
        }
        
        .gridViewTable td
        {
            padding: 1px 1px 1px 1px;
            text-overflow: ellipsis;
            overflow: hidden;
            white-space: nowrap;
        }
        .invoice-chart td
        {
            border:1px solid #89A979;  
            
        }
    </style>
    <script type="text/javascript">
        function GoToBillPop(sURL) {
            //showJPModal(sURL, "create_invoi.asp", 1000, 700, "PopWin")
            //parent.document.frames['topFrame'].changeTopModule("International");
            parent.window.location.href = sURL;

        }
    
    </script>
</head>
<!--  #INCLUDE FILE="../include/header.asp" -->
    <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
<!--  #include file="../include/recent_file.asp" -->
<%
    Dim aOrgAcct(1024),aOrgInfo(1024),aDisplayInfo(1024)
    Dim aHAWB(1024),aMAWB(1024),aShipper(1024),aAgent(1024),aMasterAgent(1024),aAO(1024),aIE(1024)
    Dim aHAWBLink(1024),aMAWBLink(1024),aQueueID(1024),aQueueDate(1024)
    Dim vHAWB,vMAWB,vOrgName,vOrgAcct
    Dim rs, SQL
    Set rs = Server.CreateObject("ADODB.Recordset")
    Delete=Request.QueryString("Delete")
    vQueueID=Request.QueryString("QueueID")
    
    If Delete="yes" Then
		SQL="delete from invoice_queue where elt_account_number = " & elt_account_number & " and queue_id=" & vQueueID
        '//SQL="update invoice_queue set invoiced = 'D' where elt_account_number = " & elt_account_number & " and queue_id=" & vQueueID
		eltConn.Execute SQL
    End If
    
    '// Get item from invoice queue
    tIndex=0
    
    '// 60 Days
    sql="select * from invoice_queue where elt_account_number=" & elt_account_number _
        & " and inqueue_Date > (getdate()-60) and invoiced='N' and isnull(mawb_num,'')<>'' " _
        & " order by inqueue_date desc,mawb_num,hawb_num"
        
    rs.CursorLocation = adUseClient
    rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
    Set rs.activeConnection = Nothing
    
    Do While Not rs.EOF And tIndex<1024
        aQueueDate(tIndex)=rs("inqueue_date")
	    aQueueID(tIndex)=rs("queue_id")
	    aHAWB(tIndex)=rs("hawb_num")
	    aMAWB(tIndex)=rs("mawb_num")
	    vHAWB=rs("HAWB_NUM")
	    vMAWB=rs("MAWB_NUM")
	    vAgentShipper=rs("agent_shipper")
	    vAirOcean=rs("air_ocean")
	    
	    If vAirOcean="A" Then
		    vAirOcean="AIR"
	    Elseif vAirOcean = "O" Then
		    vAirOcean="Ocean"
        Elseif vAirOcean = "D" Then
            vAirOcean = "Domestic"
	    End If
	    
	    aAO(tIndex)=vAirOcean
	    aShipper(tIndex)=rs("bill_to")
	    vOrgAcct=rs("bill_to_org_acct")
	    aAgent(tIndex)=rs("agent_name")
	    '// vAgentOrgAcct=rs("agent_org_acct")
	    vMasterAgent=rs("master_agent")
	    aMasterAgent(tIndex)=vMasterAgent
    	
	    If vAirOcean="AIR" Then
		    aHAWBLink(tIndex)= "../../AirExport/HAWB/"& Server.URLEncode("Edit=yes&HAWB=" & aHAWB(tIndex))
		    If aHAWB(tIndex)="CONSOLIDATION" Then
			    aHAWBLink(tIndex)=""			
		    End if 	
		    aMAWBLink(tIndex)="../../AirExport/MAWB/"&Server.URLEncode("Edit=yes&MAWB=" & aMAWB(tIndex))
	    Elseif vAirOcean="Ocean" Then
		    If aHAWB(tIndex)="CONSOLIDATION" Then
			    aHAWBLink(tIndex)=""
			    aHAWB(tIndex)="CONSOLIDATION"
		    End If	
		    aMAWBLink(tIndex)="../../OceanExport/MBOL/"&Server.URLEncode("Edit=yes&BookingNum=" & aMAWB(tIndex))
		    aHAWBLink(tIndex)="../../OceanExport/HBOL/"&Server.URLEncode("Edit=yes&hbol=" & aHAWB(tIndex))
	    Elseif vAirOcean = "Domestic" Then
	        If aHAWB(tIndex)="CONSOLIDATION" Then
			    aHAWBLink(tIndex)=""
			    aHAWB(tIndex)="CONSOLIDATION"
		    End If 
	        aHAWBLink(tIndex)="../../DomesticFreight/HouseAirBill/"&Server.URLEncode("mode=search&HAWB=" & aHAWB(tIndex))
		    aMAWBLink(tIndex)="../../DomesticFreight/MasterAirBill/"&Server.URLEncode("mode=search&MAWB=" & aMAWB(tIndex))
	    End If
	    aOrgInfo(tIndex) = "&QueueID=" & aQueueID(tIndex)
	    rs.MoveNext
	    tIndex=tIndex+1
    Loop

    Set rs=Nothing

%>
<body link="#336699" vlink="#336699" >
    <div id="tooltipcontent">
    </div>
    <form id="form1" name="form1" method="post" action="">
    <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
        <tr>
            <td align="left" valign="middle" class="pageheader">
                Invoice Queue
            </td>
        </tr>
    </table>
    
    <table width="95%" border="0" align="center" cellpadding="0" cellspacing="2" >
        <tr>
            <td align="right" valign="bottom">
                <div style="width: 21px; display: inline; vertical-align: middle" onmouseover="showtip('Invoice queue items can be stored for sixty days after being created.');"
                    onmouseout="hidetip()">
                    <img src="../Images/button_info.gif" align="absmiddle" class="bodylistheader" alt="" /></div>
            </td>
        </tr>
    </table>

    <table width="95%" border="0" align="center" cellpadding="0" cellspacing="2" class="gridViewTable invoice-chart">
                    
                        <tr align="center" valign="middle" style="background-color: #E7F0E2; height: 25px">
                            <td colspan="9" style="background-color: #D5E8CB">
                                <img src="../images/button_create_invoice.gif" width="143" height="18" name="B3"
                                    onclick="BlankInvoice()" style="cursor: hand" alt="" />
                            </td>
                        </tr>
                        <tr align="left" valign="middle" style="background-color: #E7F0E2; height: 22px"
                            class="bodyheader">
                            <td>
                                <span class="style1">HAWB </span>/ <span class="style1">House B/L</span>
                            </td>
                            <td class="bodyheader">
                                <span class="style1">MAWB</span> /<span class="style1"> Mster B/L</span>
                            </td>
                            <td>
                                Bill To
                            </td>
                            <td>
                                Agent
                            </td>
                            <td>
                                Master Agent
                            </td>
                            <td>
                                A/O
                            </td>
                            <td>
                                Queue Date
                            </td>
                            <td>
                                &nbsp;
                            </td>
                            <td>
                                &nbsp;
                            </td>

                        </tr>
                        <% for i=0 to tIndex-1 %>
                        <tr align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                            <td <%if aHAWB(i)="CONSOLIDATION" then response.Write("style='display:none'") end if %>>
                                <a href="javascript:" onclick="javascript:void(GoToBillPop('<%= aHAWBLink(i) %>')); return false;">
                                    <%= aHAWB(i) %>
                                </a>
                            </td>
                            <td <%if aHAWB(i)="CONSOLIDATION" then  response.Write("style='display='") else response.Write("style='display:none'") end if%>>
                                <%= aHAWB(i) %>
                            </td>
                            <td>
                                <a href="javascript:" onclick="javascript:void(GoToBillPop('<%= aMAWBLink(i) %>')); return false;">
                                    <%= aMAWB(i) %>
                                </a>
                            </td>
                            <td>
                                <%= aShipper(i) %>
                            </td>
                            <td>
                                <%= aAgent(i) %>
                            </td>
                            <td>
                                <%= aMasterAgent(i) %>
                            </td>
                            <td>
                                <%= aAO(i) %>
                            </td>
                            <td>
                                <%= aQueueDate(i) %>
                            </td>
                            <td>
                                <img src="../images/button_create.gif" width="52" height="17" name="B1" onclick="GoNew('<%= aOrgInfo(i) %>')"
                                    style="cursor: hand" alt="" />
                            </td>
                            <td>
                                <img src="../images/button_delete.gif" width="50" height="17" name="B2" onclick="DeleteClick('<%= aQueueID(i) %>')"
                                    style="cursor: hand" alt="" />
                            </td>
                        </tr>
                        <% next %>
                    </table>


    </form>
</body>
<script type="text/javascript">
    function GoNew(OrgInfo) {
        var url = "/Accounting/AddInvoice/new=yes" + OrgInfo + "&WindowName=" + window.name;
        window.top.location.href = url;
	//document.form1.action="edit_invoice.asp?new=yes" + OrgInfo + "&WindowName=" + window.name;
	//document.form1.method="POST";
	//document.form1.target="_self";
	form1.submit();
}
    
    function BlankInvoice() {
        var url = "/Accounting/AddInvoice/BlankInvoice=yes" + "&WindowName=" + window.name;
        window.top.location.href = url;
	//document.form1.action="edit_invoice.asp?BlankInvoice=yes"+"&WindowName=" + window.name;
	//document.form1.method = "POST";
	//document.form1.target="_self";
	form1.submit();
}
    
function DeleteClick(QueueID){
    if (confirm("Do you really want to delete this item from the queue?")) {
        document.form1.action = "create_invoi.asp?Delete=yes&QueueID=" + QueueID + "&WindowName=" + window.name;
        document.form1.method = "POST";
        document.form1.target = "_self";
        form1.submit();
    }
}
</script>
<script type="text/vbscript">

   
    
    Sub MenuMouseOver()
    End Sub
    
    Sub MenuMouseOut()
    End Sub

</script>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
<script language="JavaScript" type="text/javascript" src="../include/tooltips.js"></script>
</html>
