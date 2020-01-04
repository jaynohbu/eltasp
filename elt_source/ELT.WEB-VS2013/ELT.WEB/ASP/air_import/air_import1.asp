<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>to be determined</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <!--  #INCLUDE FILE="../include/connection.asp" -->
    <style type="text/css">
        body
        {
            margin-left: 0px;
            margin-right: 0px;
            margin-bottom: 0px;
        }
    </style>
</head>
<!--  #INCLUDE FILE="../include/header.asp" -->
     <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
<!--  #include file="../include/recent_file.asp" -->
<%
    Dim rs,SQL
    Dim aArrivalDate(256),aMAWB(256),aSec(256),aOriginPort(256),aExportAgent(256),aSource(256)
    Dim aProcessed(256),aAgentELTAcct(256)
    Delete=Request.QueryString("Delete")
    vMAWB=Request.QueryString("MAWB")
    vSec=Request.QueryString("Sec")
    vAgentELTAcct=Request.QueryString("AgentELTAcct")
    '// iType=Request.QueryString("iType")
    iType="A"

    Set rs=Server.CreateObject("ADODB.Recordset")

    If Delete="yes" then
	    SQL="delete from import_mawb where elt_account_number=" & elt_account_number & " and iType=N'" & iType & "' and mawb_num=N'" & vMAWB & "' and agent_elt_acct=" & vAgentELTAcct & " and Sec=" & vSec
	    eltConn.Execute SQL
	    SQL="delete from import_hawb where elt_account_number=" & elt_account_number & " and iType=N'" & iType & "' and mawb_num=N'" & vMAWB & "' and agent_elt_acct=" & vAgentELTAcct & " and Sec=" & vSec
	    eltConn.Execute SQL
    End if
	SQL="select distinct a.* from import_mawb a, import_hawb b where a.elt_account_number=b.elt_account_number and a.elt_account_number=" & elt_account_number & " and a.mawb_num=b.mawb_num and a.iType=N'" & iType & "' and a.processed='N' and b.processed='N' order by a.eta,a.tran_dt"
	rs.Open SQL, eltConn, , , adCmdText
	tIndex=0
	Do While Not rs.EOF
		aArrivalDate(tIndex)=rs("eta")
		aMAWB(tIndex)=rs("mawb_num")
		aSec(tIndex)=rs("sec")
		aOriginPort(tIndex)=rs("dep_port")
		aExportAgent(tIndex)=rs("export_agent_name")
		aAgentELTAcct(tIndex)=rs("agent_elt_acct")
		sec=rs("sec")
		If sec>1 then
			aProcessed(tIndex)="P"
		Else
			aProcessed(tIndex)="N"
		End If
		rs.MoveNext
		tIndex=tIndex+1
	Loop
	rs.close
%>
<body link="336699" vlink="336699" topmargin="0" onload="self.focus()" id="dq">
    <!-- tooltip placeholder -->
    <div id="tooltipcontent">
    </div>
    <!-- placeholder ends -->
    <form name="form1">
    <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
        <tr>
            <td height="32" align="left" valign="middle" class="pageheader">
                New Deconsolidation
                <% if mode_begin then %>
                <div style="width: 21px; display: inline; vertical-align: middle" onmouseover="showtip('This screen is where Shipments from your partner overseas agents that are also FreightEasy members will show up when EDT is enabled.  If they do an Export Consolidation and specify you as the EDT recipient on the Pre-Alert, the Shipment data will automatically show here, ready for your Deconsolidation; without unnecessary re-entry.');"
                    onmouseout="hidetip()">
                    <img src="../Images/button_info.gif" align="top" class="bodylistheader"></div>
                <% end if %>
            </td>
        </tr>
    </table>
    <div class="selectarea">
    </div>
    <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#ba9590">
        <tr>
            <td>
                <table width="100%" border="0" cellpadding="2" cellspacing="1">
                    <tr bgcolor="edd3cf">
                        <td colspan="7" height="8" align="left" valign="top" class="bodyheader">
                        </td>
                    </tr>
                    <tr bgcolor="#efe1df">
                        <td width="20%" height="22" align="left" valign="middle" class="bodyheader">
                            Arrival Date
                        </td>
                        <td width="20%" align="left" valign="middle" class="bodyheader">
                            <% if iType="O" then response.write("Master B/L") else response.write("Master AWB") %>
                        </td>
                        <td width="20%" align="left" valign="middle" class="bodyheader">
                            Original Port
                        </td>
                        <td width="20%" align="left" valign="middle" class="bodyheader">
                            Agent
                        </td>
                        <td width="20%" align="left" valign="middle" class="bodyheader">
                            Source
                        </td>
                        <td colspan="2" align="left" valign="middle" class="bodyheader">
                            &nbsp;
                        </td>
                    </tr>
                    <% for i=0 to tIndex-1 %>
                    <tr bgcolor="#FFFFFF">
                        <td height="22" align="left" valign="middle" class="bodycopy">
                            <%= aArrivalDate(i) %>
                        </td>
                        <td align="left" valign="middle" class="bodycopy">
                            <% if iType="O" then response.write("MBOL") else response.write("MAWB") %>
                        </td>
                        <td align="left" valign="middle" class="bodycopy">
                            <%= aOriginPort(i) %>
                        </td>
                        <td align="left" valign="middle" class="bodycopy">
                            <%= aExportAgent(i) %>
                        </td>
                        <td align="left" valign="middle" class="bodycopy">
                            &nbsp;
                        </td>
                        <td width="58" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                            <img src="../images/button_edit.gif" width="37" height="18" name="B1" onclick="EditClick('<%= aMAWB(i) %>',<%= aSec(i) %>,<%= aAgentELTAcct(i) %>)"
                                style="cursor: hand">
                        </td>
                        <td width="54" align="left" valign="middle" class="bodycopy" style="cursor: hand">
                            <img src="../images/button_delete.gif" width="50" height="17" onclick="DeleteClick('<%= aMAWB(i) %>',<%= aSec(i) %>,<%= aAgentELTAcct(i) %>)"
                                style="cursor: hand">
                        </td>
                    </tr>
                    <% next %>
                    <tr bgcolor="edd3cf">
                        <td height="22" align="left" valign="middle" bgcolor="f3f3f3" class="bodycopy">
                            &nbsp;
                        </td>
                        <td bgcolor="f3f3f3">
                        </td>
                        <td bgcolor="f3f3f3">
                        </td>
                        <td bgcolor="f3f3f3">
                        </td>
                        <td bgcolor="f3f3f3">
                        </td>
                        <td colspan="2" align="left" valign="middle" bgcolor="f3f3f3" class="bodyheader">
                            <img src="../images/button_addnewmawb.gif" width="104" height="18" onclick="EditClick('',0,0)"
                                style="cursor: hand" alt="" />
                        </td>
                    </tr>
                    <tr align="center" bgcolor="edd3cf">
                        <td height="22" colspan="7" valign="middle" class="bodycopy">
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    </form>
</body>
<script type="text/javascript">
    function DeleteClick(MAWB,Sec,AgentELTAcct){
        if (confirm("Do you really want to delete MAWB " + MAWB + "? \r\nContinue?")){	
            document.form1.action="air_import1.asp?Delete=yes&MAWB="+ MAWB+ "&Sec=" + Sec +"&AgentELTAcct=" + AgentELTAcct + "&WindowName=" +window.name;
            document.form1.method="POST";
            Document.form1.target = "_self";
            form1.submit();
       }
    }
    
    function EditClick(MAWB,Sec,AgentELTAcct){
        var iType="<%= iType %>";
        document.form1.action="air_import2.asp?iType=" + iType + "&Edit=yes&MAWB="+ MAWB + "&Sec=" +Sec + "&AgentELTAcct=" + AgentELTAcct + "&WindowName="+window.name;
        document.form1.target = "_self";
        document.form1.method="POST";
        form1.submit();
    }
    
</script>
<!-- //for Tooltip// -->
<script language="JavaScript" type="text/javascript" src="../include/tooltips.js"></script>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
