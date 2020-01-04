<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/Header.asp" -->
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<%
    Dim vFileNo,vDebitNo,vNewMAWB,vIType,vMode,vOldMAWB

    vMode = Request.QueryString("MODE").Item
    
    If vMode = "save" Then
        vFileNo = Request.Form("hFileNo").Item
        vOldMAWB = Request.Form("hOldMAWB").Item
        vNewMAWB = Request.Form("txtNewMAWB").Item
        vDebitNo = Request.Form("hAgentDebitNo").Item
        vIType = Request.Form("hIType").Item
        
        eltConn.BeginTrans
        On Error Resume Next:
        If GetSQLResult("SELECT mawb_num from import_mawb WHERE mawb_num=N'" & vNewMAWB _
            & "' AND elt_account_number=" & elt_account_number,null) <> "" Then
            Response.Write("<script> alert('Master B/L number " & vNewMAWB & " exists already!'); </script> ")
        Else
            Call update_mawb_change
        End If
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
            Response.Write("<script> window.returnValue='" & vNewMAWB & "'; window.close(); </script>")
        End If
    Else
        vFileNo = Request.QueryString("FILE").Item
        vDebitNo = Request.QueryString("DEBITNO").Item
        vIType = Request.QueryString("ITYPE").Item
        vOldMAWB = Request.QueryString("MAWB").Item
    End If
    
    Sub update_mawb_change

        Dim rs,SQL
        Set rs = Server.CreateObject("ADODB.Recordset")
        
        SQL = "DECLARE @elt_num INT" & chr(13) _
            & "DECLARE @file_num NVARCHAR(128)" & chr(13) _
            & "DECLARE @old_mawb NVARCHAR(128)" & chr(13) _
            & "DECLARE @new_mawb NVARCHAR(128)" & chr(13) _
            & "DECLARE @iType NVARCHAR(1)" & chr(13) _
            & "DECLARE @agent_debit_no NVARCHAR(128)" & chr(13) _
            & "SET @elt_num=" & elt_account_number  & chr(13) _
            & "SET @file_num=N'" & vFileNo & "'"  & chr(13) _
            & "SET @old_mawb=N'" & vOldMAWB & "'" & chr(13) _
            & "SET @new_mawb=N'" & vNewMAWB & "'" & chr(13) _
            & "SET @iType=N'" & vIType & "'" & chr(13) _
            & "SET @agent_debit_no=N'" & vDebitNo & "'" & chr(13) _
            & "update invoice set mawb_num=@new_mawb from invoice a inner join import_hawb b on (a.elt_account_number=b.elt_account_number AND a.invoice_no=b.invoice_no AND a.air_ocean=b.iType AND a.import_export='I') WHERE b.elt_account_number=@elt_num and b.mawb_num=@old_mawb" & chr(13) _
            & "update import_mawb set mawb_num=@new_mawb where elt_account_number=@elt_num and file_no=@file_num AND mawb_num=@old_mawb AND iType=@iType" & chr(13) _
            & "update import_hawb set mawb_num=@new_mawb where elt_account_number=@elt_num and mawb_num=@old_mawb and iType=@iType" & chr(13) _
            & "update mb_cost_item set mb_no=@new_mawb where elt_account_number=@elt_num and mb_no=@old_mawb AND iType=@iType" & chr(13) _
            & "update bill_detail set mb_no=@new_mawb where elt_account_number=@elt_num and mb_no=@old_mawb and iType=@iType and agent_debit_no=@agent_debit_no" 

        eltConn.execute(SQL)
    End Sub
%>


<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Change Air Import Master B/L</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />

    <script type="text/jscript">
    
    function saveChangeMAWB(){
        if(document.getElementById("txtNewMAWB").value != "")
        {
            var formObj = document.getElementById("form1");
            formObj.action = "change_mawb.asp?MODE=save&WindowName=ChangeImportMAWB";
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
    <input type="hidden" id="hOldMAWB" name="hOldMAWB" value="<%=vOldMAWB %>" />
    <input type="hidden" id="hAgentDebitNo" name="hAgentDebitNo" value="<%=vDebitNo %>" />
    <input type="hidden" id="hIType" name="hIType" value="<%=vIType %>" />

    
    <table cellspacing="0" cellpadding="0" border="0" width="100%" class="bodyheader">
        <tr>
            <td>
                Reassign current Master B/L Number: <%=vOldMAWB %> to ...
            </td>
        </tr>
        <tr>
            <td valign="top">
                New Master B/L Number: <input type="text" class="shorttextfield" id="txtNewMAWB" name="txtNewMAWB" style="width:180px" />
            </td>
        </tr>
        <tr>
            <td align="right">
                <table cellspacing="0" cellpadding="0" border="0">
                    <tr>
                        <td>
                            <input type="image" src="../images/button_save_medium.gif" onclick="javascript:saveChangeMAWB(); return false;" /></td>
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
