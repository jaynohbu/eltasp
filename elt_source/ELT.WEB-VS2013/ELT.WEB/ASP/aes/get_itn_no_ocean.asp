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
    Dim returnURL,sedno,sedTable
    
    Dim server_name
    server_name = LCase(Request.ServerVariables("SERVER_NAME"))
    returnURL = "http://" & server_name & "/ASP/aes/set_itn_no_ocean.asp"
    '// Remove this before publishing
    Dim server_port
    server_port = request.ServerVariables("SERVER_PORT")
    If server_port <> "80" Then
        returnURL = "http://" & server_name & ":" & server_port & "/ASP/aes/set_itn_no_ocean.asp"
    End If
    
    sedno = Request.QueryString("sedno")
    Session("SEDMemory") = sedno
    Set sedTable = GetSEDTable(sedno)
    
    Function  GetSEDTable(uid)
        Dim feData,SQL
        Set feData = new DataManager
        SQL = "SELECT * FROM ocean_sed_master WHERE elt_account_number=" & elt_account_number & " AND auto_uid=" & uid
        feData.SetDataList(SQL)
        
        Set GetSEDTable = feData.GetRowTable(0)
    End Function 
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
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
<body style="margin:0px 0px 0px 0px; background-color:#E0EDE8">
    <div style="text-align:center">
    <form id="form1" action="https://aesdirect.census.gov/weblink/weblink_status.cgi" method="post">
        <input type="hidden" name="wl_app_ident" value="wlelog01" />
        <input type="hidden" name="URL" value="<%=returnURL %>" />
        <br /><br />
        <table class="bodycopy" cellpadding="4" cellspacing="0" border="0" style="background-color:#eeeeee; border:solid 1px #aaaaaa">
            <tr>
                <td>USPPI ID</td>
                <td>
                    <input type="text" id="FID" name="FID" class="shorttextfield" value="<%=sedTable("USPPI_taxid") %>" maxlength="11" style="width:100px" />
                </td>
            </tr>
            <tr>
                <td>
                    Shipment Reference No.
                </td>
                <td>
                    <input type="text" id="SRN" name="SRN" class="shorttextfield" value="<%=sedTable("shipment_ref_no") %>" maxlength="17" style="width:140px" />
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
