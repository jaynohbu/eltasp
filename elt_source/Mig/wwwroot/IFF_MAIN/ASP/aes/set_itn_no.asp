<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/header.asp" -->
<!--  #INCLUDE FILE="../include/GOOFY_data_manager.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_Util_fun.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_Util_Ver_2.inc" -->
<%
    Dim FID,SRN,STA,ITN,vMode,i
    Dim vHAWB,vMAWB
    
    vMode = checkBlank(Request.QueryString("mode"),"view")
    If vMode = "view" Then
        FID = Request.QueryString("FID")
        SRN = Request.QueryString("SRN")
        STA = Request.QueryString("STA")
        ITN = Request.QueryString("ITN")
        
        Call get_MAWB_HAWB
    Elseif vMode = "save" Then
        FID = Request.Form("formFID").Item
        SRN = Request.Form("formSRN").Item
        STA = Request.Form("formSTA").Item
        ITN = Request.Form("formITN").Item
        
        eltConn.BeginTrans()
        Call get_MAWB_HAWB
        Call update_ITN_number
        Set Session("SEDMemory") = Nothing
        eltConn.CommitTrans()
        eltConn.Close()
        Set eltConn = Nothing
        
        Response.Write("<script>alert('ITN number is inserted to HAWB.'); opener.window.location.href = opener.window.location.href; window.close();</script>")
        Response.End()
    End If
    
    Sub update_ITN_number()
        Dim rs,SQL
        Set rs = Server.CreateObject("ADODB.Recordset")
        
        SQL = "UPDATE hawb_master SET aes_xtn='" & ITN & "',sed_stmt='' WHERE elt_account_number=" _
            & elt_account_number & " AND hawb_num=N'" & vHAWB & "' AND mawb_num=N'" & vMAWB & "'"
        
        eltConn.execute(SQL)
        
        SQL = "UPDATE sed_master SET aes_itn='" & ITN & "',aes_status='" & STA _
            & "' WHERE elt_account_number=" & elt_account_number _
            & " AND auto_uid=" & Session("SEDMemory") & " AND shipment_ref_no=N'" & SRN & "'"
        
        eltConn.execute(SQL)
        
    End Sub
    
    Sub get_MAWB_HAWB
        Dim rs,SQL
        SQL = "SELECT HAWB_NUM,mawb_num FROM sed_master WHERE elt_account_number=" & elt_account_number _
            & " AND auto_uid=" & Session("SEDMemory") & " AND shipment_ref_no=N'" & SRN & "'"
        Set rs = Server.CreateObject("ADODB.Recordset")
        rs.CursorLocation = adUseClient
	    rs.Open SQL,eltConn,adOpenStatic,adLockPessimistic,adCmdText

        If Not rs.EOF And Not rs.BOF Then
            vMAWB = rs("mawb_num").value
            vHAWB = rs("HAWB_NUM").value
	    End If
        rs.Close
    End Sub

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>AES Weblink Inquiry</title>
    <base target="_self" />

    <script type="text/jscript">
    </script>

    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
</head>
<body style="margin: 0px 0px 0px 0px; background-color:#f0e7ef">
    <div style="text-align: center">
        <form id="form1" action="set_itn_no.asp?mode=save" method="post">
            <br />
            <br />
            <table class="bodycopy" cellpadding="4" cellspacing="0" border="0" style="background-color: #eeeeee;
                border: solid 1px #aaaaaa">
                <tr>
                    <td>
                        USPPI Tax ID
                    </td>
                    <td>
                        <input name="formFID" type="text" value="<%=FID %>" class="shorttextfield" style="width: 100px"
                            readonly="readonly" />
                    </td>
                </tr>
                <tr>
                    <td>
                        Shipment Reference No.</td>
                    <td>
                        <input name="formSRN" type="text" value="<%=SRN %>" class="shorttextfield" style="width: 150px"
                            readonly="readonly" /></td>
                </tr>
                <tr>
                    <td>
                        AES Status</td>
                    <td>
                        <input name="formSTA" type="text" value="<%=STA %>" class="shorttextfield" style="width: 200px"
                            readonly="readonly" /></td>
                </tr>
                <tr>
                    <td>
                        ITN Number</td>
                    <td>
                        <input name="formITN" type="text" value="<%=ITN %>" class="shorttextfield" style="width: 150px"
                            readonly="readonly" /></td>
                </tr>
                <tr>
                    <td>
                        MAWB No.</td>
                    <td>
                        <input type="text" value="<%=vMAWB %>" class="shorttextfield" readonly="readonly" /></td>
                </tr>
                <tr>
                    <td>
                        HAWB No.</td>
                    <td>
                        <input type="text" value="<%=vHAWB %>" class="shorttextfield" readonly="readonly" /></td>
                </tr>
                <tr>
                    <td colspan="2" style="height: 10px">
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align: center">
                        <input type="submit" class="bodycopy" value="Update ITN" <%  If ITN = "" Then Response.Write("disabled=disabled") %> />
                        <input type="button" class="bodycopy" value="Cancel" onclick="javascript:window.close();" />
                    </td>
                </tr>
            </table>
        </form>
    </div>
</body>
</html>
