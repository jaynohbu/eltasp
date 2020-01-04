<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../Include/Header.inc" -->
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
        
        Call update_ITN_number
        Set Session("AESMemory") = Nothing
    End If
    
    eltConn.close()
    Set eltConn = Nothing
    
    Sub update_ITN_number()
        Dim rs,SQL
        Set rs = Server.CreateObject("ADODB.Recordset")
        
        SQL = "UPDATE aes_master SET aes_itn='" & ITN & "',aes_status='" & STA _
            & "' WHERE elt_account_number=" & elt_account_number _
            & " AND auto_uid=" & Session("AESMemory") & " AND shipment_ref_no=N'" & SRN & "'"
        
        eltConn.execute(SQL)
        
    End Sub
    

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>AES Weblink Inquiry</title>
    <base target="_self" />

    <script type="text/jscript">
        function close_window(){
            opener.window.location.reload();
            window.close();
        }
    </script>

    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
</head>
<body style="margin: 0px 0px 0px 0px; background-color:#f0e7ef">
    <div style="text-align: center" class="bodycopy">
        <form id="form1" action="tran_set_itn_no.asp?mode=save" method="post">
            <br />
            <br />
            ITN number and AES status are saved.
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
                    <td colspan="2" style="height: 10px">
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align: center">
                        <input type="button" class="bodycopy" value="Close Window" onclick="javascript:close_window();" />
                    </td>
                </tr>
            </table>
        </form>
    </div>
</body>
</html>
