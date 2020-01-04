<!--  #INCLUDE FILE="../Include/transaction.txt" -->
<%
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../Include/connection.asp" -->
<!--  #INCLUDE FILE="../Include/GOOFY_data_manager.inc" -->
<!--  #INCLUDE FILE="../Include/GOOFY_Util_fun.inc" -->
<!--  #INCLUDE FILE="../Include/GOOFY_Util_Ver_2.inc" -->
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
	
    Dim returnURL,aes_id,vFID,vSRN,shipperAcct

    Dim server_name
    server_name = LCase(Request.ServerVariables("SERVER_NAME"))
    returnURL = "http://" & server_name & "/IFF_MAIN/ASP/aes/tran_set_itn_no.asp"
    '// Remove this before publishing
    Dim server_port
    server_port = request.ServerVariables("SERVER_PORT")
    If server_port <> "80" Then
        returnURL = "http://" & server_name & ":" & server_port & "/IFF_MAIN/ASP/aes/tran_set_itn_no.asp"
    End If
    
    aes_id = Request.QueryString("AESID")
    Session("AESMemory") = aes_id

	shipperAcct = checkBlank(GetSQLResult("SELECT shipper_acct FROM aes_master WHERE elt_account_number=" & elt_account_number & " AND auto_uid=" & aes_id, Null),"")
    
	If shipperAcct = elt_account_number Then
		vFID = GetSQLResult("SELECT business_fed_taxid FROM agent WHERE elt_account_number=" & elt_account_number, Null)
	Else
		vFID = GetSQLResult("SELECT business_fed_taxid FROM organization WHERE org_account_number=" & shipperAcct & " AND elt_account_number=" & elt_account_number, Null)
	End If
	
    vSRN = GetSQLResult("SELECT shipment_ref_no FROM aes_master WHERE elt_account_number=" & elt_account_number& " AND auto_uid=" & aes_id, Null)
    
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>AES Weblink Inquiry</title>
    <base target="_self" />
    <script type="text/jscript">
        function form_submit()
        {
            var formObj = document.getElementById("form1");
            var strFID = document.getElementById("FID").value;
            var strSRN = document.getElementById("SRN").value;
            
            if(strFID != "" && strSRN != ""){
                document.getElementById("FID").value = strFID.replace(/-/g,"");
                document.getElementById("SRN").value = strSRN.replace(/ /g,"");
                
                formObj.submit();
            }
            else
            {
                alert("USPPI ID and Shipment reference number are needed");
            }
        }
        
        function cancel_submit()
        {
            window.close();
        }
    </script>
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
</head>
<body style="margin:0px 0px 0px 0px; background-color:#f0e7ef">
    <div style="text-align:center">
    <form id="form1" action="https://aesdirect.census.gov/weblink/weblink_status.cgi" method="post">
        <input type="hidden" name="wl_app_ident" value="wlelog01" />
        <input type="hidden" name="URL" value="<%=returnURL %>" />
        <br /><br />
        <table class="bodycopy" cellpadding="4" cellspacing="0" border="0" style="background-color:#eeeeee; border:solid 1px #aaaaaa">
            <tr>
                <td>USPPI ID</td>
                <td>
                    <input type="text" id="FID" name="FID" class="shorttextfield" value="<%=vFID %>" maxlength="11" style="width:100px" />
                </td>
            </tr>
            <tr>
                <td>
                    Shipment Reference No.
                </td>
                <td>
                    <input type="text" id="SRN" name="SRN" class="shorttextfield" value="<%=vSRN %>" maxlength="17" style="width:140px" />
                </td>
            </tr>
            <tr><td colspan="2" style="height:10px"></td></tr>
            <tr>
                <td colspan="2">
                    <input type="button" class="bodycopy" value="Get AES Status & ITN Number" onclick="form_submit();" />
                    <input type="button" class="bodycopy" value="Cancel" onclick="cancel_submit();" />
                </td>
            </tr>
        </table>
    </form>
    </div>
</body>
</html>
