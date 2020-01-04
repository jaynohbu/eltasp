<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/Header.asp" -->
<%
    Dim vFileNo,vAgentName,vAgentNo,vIType,vMode,vMAWB

    vMode = Request.QueryString("MODE").Item
    
    If vMode = "save" Then
        vFileNo = Request.Form("hFileNo").Item
        vMAWB = Request.Form("hMAWB").Item
        vAgentName = Request.Form("lstAgentName").Item
        vAgentNo = Request.Form("hAgentAcct").Item
        vIType = Request.Form("hIType").Item
        
        eltConn.BeginTrans
        On Error Resume Next:
        Call update_agent_change
        If err.number Then
            Dim vErrorMesssage
            vErrorMesssage = "Unexpected Error Occurred. Please, contact us if this problem persists"
            vErrorMesssage = vErrorMesssage & "\n" _
                & "Error Number: " & err.number & "\n" _
                & "Application Source: " & err.Source & "\n" _
                & "Description: " & RemoveQuotations(err.Description) & " (" & Server.GetLastError().Line & ":" & Server.GetLastError().Column & ")"
            Response.Write("<script> alert('" & vErrorMesssage & "'); </script>")
            eltConn.RollbackTrans
        Else
            eltConn.CommitTrans
            '// eltConn.RollbackTrans
            Response.Write("<script> window.returnValue='true'; window.close(); </script>")
        End If
    Else
        vFileNo = Request.QueryString("FILE").Item
        vMAWB = Request.QueryString("MAWB").Item
        vAgentName = Request.QueryString("AGENTNAME").Item
        vAgentNo = Request.QueryString("AGENTNO").Item
        vIType = Request.QueryString("ITYPE").Item
    End If
    
    Sub update_agent_change

        Dim rs,SQL
        Set rs = Server.CreateObject("ADODB.Recordset")
        
        SQL = "DECLARE @elt_num INT" & chr(13) _
            & "DECLARE @file_num NVARCHAR(128)" & chr(13) _
            & "DECLARE @mawb_num NVARCHAR(128)" & chr(13) _
            & "DECLARE @agent_debit_no NVARCHAR(128)" & chr(13) _
            & "DECLARE @agent_name NVARCHAR(128)" & chr(13) _
            & "DECLARE @agent_num INT" & chr(13) _
            & "DECLARE @iType NVARCHAR(1)" & chr(13) _
            & "SET @elt_num=" & elt_account_number  & chr(13) _
            & "SET @file_num=N'" & vFileNo & "'"  & chr(13) _
            & "SET @mawb_num=N'" & vMAWB & "'" & chr(13) _
            & "SET @agent_name=N'" & vAgentName & "'" & chr(13) _
            & "SET @agent_num=" & vAgentNo & chr(13) _
            & "SET @iType=N'" & vIType & "'" & chr(13) _
            & "SET @agent_debit_no=(select agent_debit_no from import_mawb WHERE elt_account_number=@elt_num and file_no=@file_num and mawb_num=@mawb_num and iType=@iType)" & chr(13) _
            & "update import_mawb set export_agent_name=@agent_name, agent_org_acct=@agent_num WHERE elt_account_number=@elt_num and file_no=@file_num and mawb_num=@mawb_num and iType=@iType" & chr(13) _
            & "update import_hawb set agent_org_acct=@agent_num WHERE elt_account_number=@elt_num and iType=@iType and mawb_num=@mawb_num" & chr(13) _
            & "update mb_cost_item set vendor_no=@agent_num WHERE elt_account_number=@elt_num and mb_no=@mawb_num" & chr(13) _
            & "update bill_detail set vendor_number=@agent_num WHERE elt_account_number=@elt_num and mb_no=@mawb_num and iType=@iType and agent_debit_no=@agent_debit_no"
    
        eltConn.execute(SQL)
    End Sub
%>


<html xmlns="http://www.w3.org/1999/xhtml">
<head>
     <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
    <title>Change Air Import Agent</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" language="javascript" src="/ASP/ajaxFunctions/ajax.js"></script>

    <script type="text/javascript" src="../include/JPED.js"></script>

    <script type="text/jscript">
    
    function lstAgentNameChange(orgNum,orgName)
    {
        var hiddenObj = document.getElementById("hAgentAcct");
        var txtObj = document.getElementById("lstAgentName");
        var divObj = document.getElementById("lstAgentNameDiv")

        hiddenObj.value = orgNum;
        txtObj.value = orgName;
    }
    
    function saveChangeAgent(){
        if(document.getElementById("hAgentAcct").value != "" && document.getElementById("hAgentAcct").value != "0")
        {
            var formObj = document.getElementById("form1");
            formObj.action = "change_agent.asp?MODE=save&WindowName=ChangeImportAgent";
		    formObj.method = "POST";
		    formObj.target = window.name;
		    formObj.submit();
		}
    }
    
    </script>

</head>
<body style="margin: 5px">
<form id="form1" action="">

    <input type="hidden" id="hFileNo" name="hFileNo" value="<%=vFileNo %>" />
    <input type="hidden" id="hMAWB" name="hMAWB" value="<%=vMAWB %>" />
    <input type="hidden" id="hIType" name="hIType" value="<%=vIType %>" />
    
    <table cellspacing="0" cellpadding="0" border="0" width="100%">
        <tr>
            <td class="bodyheader">
                Reassign current agent: "<font style="color:Red"><%=vAgentName %></font>" to ...
            </td>
        </tr>
        <tr>
            <td style="height: 155px" valign="top">
                <!-- Start JPED -->
                <input type="hidden" id="hAgentAcct" name="hAgentAcct" />
                <div id="lstAgentNameDiv">
                </div>
                <table cellpadding="0" cellspacing="0" border="0">
                    <tr>
                        <td>
                            <input type="text" autocomplete="off" id="lstAgentName" name="lstAgentName" value=""
                                class="shorttextfield" style="width: 270px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Agent','lstAgentNameChange',130,event)"
                                onfocus="initializeJPEDField(this,'fixed');" /></td>
                        <td>
                            <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstAgentName','Agent','lstAgentNameChange',130,event)"
                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                    </tr>
                </table>

                <script type="text/javascript">
                    organizationFillAll('lstAgentName','Agent','lstAgentNameChange',130);
                </script>

                <!-- End JPED -->
            </td>
        </tr>
        <tr>
            <td align="right">
                <table cellspacing="0" cellpadding="0" border="0">
                    <tr>
                        <td>
                            <input type="image" src="../images/button_save_medium.gif" onclick="javascript:saveChangeAgent(); return false;" /></td>
                        <td style="width:15px"></td>
                        <td>
                            <input type="image" src="../images/button_close_window.gif" onclick="javascript:window.close(); return false;" /></td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    </form>
</body>
</html>
