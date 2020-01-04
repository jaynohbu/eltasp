<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/GOOFY_data_manager.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_Util_fun.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_Util_Ver_2.inc" -->
<%	

    '// Copied from header.asp /////////////////////////////////////////////////////
    
    Dim elt_account_number,login_name,user_id,ClientOS,session_ip,session_IntIp
    Dim session_server_name,session_user_lname,redPage
	elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
	login_name = Request.Cookies("CurrentUserInfo")("login_name")
	user_id = Request.Cookies("CurrentUserInfo")("user_id")
	ClientOS = Request.Cookies("CurrentUserInfo")("ClientOS")
	session_ip = Request.Cookies("CurrentUserInfo")("IP")
	session_IntIp = Request.Cookies("CurrentUserInfo")("intIP")
	session_server_name = Request.Cookies("CurrentUserInfo")("Server_Name")
	session_user_lname = Request.Cookies("CurrentUserInfo")("lname")
	redPage = Request.Cookies("CurrentUserInfo")("ORIGINPAGE")
	
	'////////////////////////////////////////////////////////////////////////////////
	
    Dim FID,SRN,STA,ITN,vMode,i
    Dim vHAWB,vMAWB,vFileType,vMessage
    
    vMode = checkBlank(Request.QueryString("mode"),"view")
    If vMode = "view" Then
        FID = Request.QueryString("FID")
        SRN = Request.QueryString("SRN")
        STA = Request.QueryString("STA")
        ITN = Request.QueryString("ITN")
        
        Call get_shipment_info
        Call update_ITN_number
        Set Session("AESMemory") = Nothing
    End If
    
    eltConn.close()
    Set eltConn = Nothing
    
    Sub update_ITN_number()
        Dim rs,SQL
        Set rs = Server.CreateObject("ADODB.Recordset")

        If ITN = "" Then
            vMessage = "ITN number cannot be issued at this time. The shipemt cannot be found from AES Direct."
        Else
            vMessage = "ITN number and AES status are saved."
            
            If vFileType = "AE" Then
                If vHAWB <> "" And vMAWB <> "" Then
                    SQL = "UPDATE hawb_master SET aes_xtn='" & ITN & "',sed_stmt='' WHERE elt_account_number=" _
                        & elt_account_number & " AND hawb_num=N'" & vHAWB & "' AND mawb_num=N'" & vMAWB & "'"
                Elseif vHAWB = "" And vMAWB <> "" Then
                    SQL = "UPDATE mawb_master SET aes_xtn='" & ITN & "',sed_stmt='' WHERE elt_account_number=" _
                        & elt_account_number & " AND mawb_num=N'" & vMAWB & "'"
                End If
            End If
            
            If vFileType = "OE" Then
                If vHAWB <> "" And vMAWB <> "" Then
                    SQL = "UPDATE hbol_master SET aes_xtn='" & ITN & "',sed_stmt='' WHERE elt_account_number=" _
                        & elt_account_number & " AND hbol_num=N'" & vHAWB & "' AND booking_num=N'" & vMAWB & "'"
                Elseif vHAWB = "" And vMAWB <> "" Then
                    SQL = "UPDATE mbol_master SET aes_xtn='" & ITN & "',sed_stmt='' WHERE elt_account_number=" _
                        & elt_account_number & " AND booking_num=N'" & vMAWB & "'"
                End If
            End If
            
            eltConn.execute(SQL)
                
            SQL = "UPDATE aes_master SET aes_itn='" & ITN & "',aes_status='" & STA _
                & "' WHERE elt_account_number=" & elt_account_number _
                & " AND auto_uid=" & Session("AESMemory") & " AND shipment_ref_no=N'" & SRN & "'"
            
            eltConn.execute(SQL)
        End If
    End Sub
    
    Sub get_shipment_info
        Dim rs,SQL
        
        SQL = "SELECT file_type,house_num,master_num FROM aes_master WHERE elt_account_number=" & elt_account_number _
            & " AND auto_uid=" & checkBlank(Session("AESMemory"),-1) & " AND shipment_ref_no=N'" & SRN & "'"
        
        Set rs = Server.CreateObject("ADODB.Recordset")
        rs.CursorLocation = adUseClient
	    rs.Open SQL,eltConn,adOpenStatic,adLockPessimistic,adCmdText

        If Not rs.EOF And Not rs.BOF Then
            vFileType = checkBlank(rs("file_type").value, "")
            vMAWB = checkBlank(rs("master_num").value, "")
            vHAWB = checkBlank(rs("house_num").value, "")
	    End If
        rs.Close
    End Sub
    

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>AES Weblink Inquiry</title>
    <base target="_self" />

    <script type="text/jscript">
        function close_window(){
            opener.window.location.reload();
            alert(opener.window.location.href);
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
            <%=vMessage %>
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
