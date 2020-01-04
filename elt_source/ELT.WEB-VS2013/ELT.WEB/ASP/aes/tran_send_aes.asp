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

    Dim headerTable,shipperTable,agentTable,userTable,ultConsigneeTable,intConsigneeTable,itemDataList,aes_id,vEDA
    
    Call GetParameters
	Call GetAESHeader
	Call GetAESItems
	Call GetShipperInfo
	Call GetAgentInfo
	Call GetUserInfo
	
	Set ultConsigneeTable = GetOrganizationTable(headerTable("consignee_acct"))
	Set intConsigneeTable = GetOrganizationTable(headerTable("inter_consignee_acct"))
	
	vEDA = GetAESDateFormat(headerTable("export_date"))
	
	Call UpdateSubmitDate
	
	eltConn.Close()
	Set eltConn = Nothing
	
	Sub GetParameters
	    aes_id = Request.QueryString("AESID")
	End Sub
	
	Sub GetShipperInfo
	    Dim SQL,dataTable,dataObj
	    
	    If checkBlank(headerTable("shipper_acct"),0) = 0 Then
	        SQL = "SELECT * FROM agent WHERE elt_account_number=" & elt_account_number
	        Set dataObj = new DataManager
            dataObj.SetDataList(SQL)
            Set shipperTable = dataObj.GetRowTable(0)
        Else
            Set shipperTable = GetOrganizationTable(headerTable("shipper_acct"))
        End If
	End Sub
	
'	Sub GetAgentInfo
'	    Dim SQL,dataTable,dataObj
'	    
'	    If checkBlank(headerTable("agent_acct"),0) = 0 Then
'	        SQL = "SELECT *,'' AS business_address2 FROM agent WHERE elt_account_number=" & elt_account_number
'	        Set dataObj = new DataManager
'            dataObj.SetDataList(SQL)
'            Set agentTable = dataObj.GetRowTable(0)
'        Else
'            Set agentTable = GetOrganizationTable(headerTable("agent_acct"))
'        End If
'    End Sub

	Sub GetAgentInfo
	    Dim SQL,dataTable,dataObj
	    
	    SQL = "SELECT *,'' AS business_address2 FROM agent WHERE elt_account_number=" & elt_account_number
        Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set agentTable = dataObj.GetRowTable(0)
    End Sub
	
	Sub GetUserInfo
	    Dim SQL,dataTable,dataObj
	    
	    SQL = "SELECT * FROM users WHERE elt_account_number=" & elt_account_number & " AND userid=" & user_id

	    Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set userTable = dataObj.GetRowTable(0)
	End Sub
	
	Function GetOrganizationTable(orgID)
	    Dim SQL,dataTable,dataObj
	    
	    SQL = "SELECT *,'' AS user_mname,b_country_code AS country_code FROM organization WHERE elt_account_number=" & elt_account_number _
	        & " AND org_account_number=" & checkBlank(orgID,"0")
	    
	    Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set GetOrganizationTable = dataObj.GetRowTable(0)
	End Function
	
	Sub GetAESHeader
	    Dim SQL,dataTable,dataObj
	    
	    SQL = "SELECT a.*,ISNULL(port_id,'') as port_id FROM aes_master a LEFT OUTER JOIN port b " _
	        & "ON (a.elt_account_number=b.elt_account_number AND a.export_port=b.port_code) " _
	        & " WHERE a.elt_account_number=" & elt_account_number & " AND a.auto_uid=" & aes_id
	    
	    Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set headerTable = dataObj.GetRowTable(0)
	End Sub
	
	Sub GetAESItems
        Dim SQL,dataTable,dataObj
	    
	    SQL = "SELECT * FROM aes_detail WHERE elt_account_number=" _
	        & elt_account_number & " AND aes_id=" & aes_id
	    
	    Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
	    Set itemDataList = dataObj.GetDataList()
	End Sub
	
	'// OTL .....
	Function GetAESDateFormat(inputStr)
	
	    Dim outputStr, vDayStr, vMonth, vYear
	    outputStr = ""
	    
	    vDayStr = Day(inputStr)
	    vMonth = Month(inputStr)
	    vYear = Mid(Year(inputStr),3,2)
	    
	    If Len(vDayStr) = 1 Then
	        vDayStr = "0" & vDayStr
	    End If
	    
	    If Len(vMonth) = 1 Then
	        vMonth = "0" & vMonth
	    End If
	    
	    outputStr = vMonth & "/" & vDayStr & "/" & vYear
	    
	    GetAESDateFormat = outputStr
	End Function 
	
	Sub UpdateSubmitDate
        SQL = "UPDATE aes_master SET tran_date=GETDATE() WHERE elt_account_number=" & elt_account_number _
            & " AND auto_uid=" & aes_id
        eltConn.execute(SQL)
	End Sub
	
	On Error Resume Next:
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
    <title>AES Submit</title>
    <base target="_self" />

    <script type="text/javascript">
        function submitAES(){
            document.getElementById("form1").submit();
        }
    </script>

</head>
<body onload="submitAES()">
    <div>
    Uploading Export Data to AES Direct.
    </div>
    <div style="visibility:hidden">
        <form method="post" id="form1" action="https://ace.cbp.dhs.gov/aesd/ta/aes-direct/secured/createWeblinkFiling">
            <input name="wl_app_ident" value="wlelog01" />
            <input name="wl_app_name" value="eFreightForward" />
            <input name="wl_nologin_url" value="http://www.weblinktestapp.com/nologin.html" />
            <input name="wl_nosed_url" value="http://www.weblinktestapp.com/nosed.html" />
            <input name="EMAIL" value="<%=userTable("user_email") %>" />
            <input name="SRN" value="<%=headerTable("shipment_ref_no") %>" />
            <input name="BN" value="<%=headerTable("tran_ref_no") %>" />
            <input name="ST" value="<%=headerTable("origin_state") %>" />
            <input name="POE" value="<%=headerTable("port_id") %>" />
            <input name="COD" value="<%=headerTable("dest_country") %>" />
            <input name="POU" value="<%=headerTable("unloading_port") %>" />
            <input name="EDA" value="<%=vEDA %>" />
            <input name="MOT" value="<%=headerTable("tran_method") %>" />
            <input name="SCAC" value="<%=headerTable("carrier_id_code") %>" />
            <input name="VN" value="<%=headerTable("export_carrier") %>" />
            <input name="RCC" value="<%=headerTable("party_to_transaction") %>" />
            <input name="HAZ" value="<%=headerTable("hazardous_materials") %>" />
            <input name="RT" value="<%=headerTable("route_export_tran") %>" />
            <input name="IBN" value="<%=headerTable("in_bond_no") %>" />
            <input name="IBT" value="<%=headerTable("in_bond_type") %>" />
            <input name="FTZ" value="<%=headerTable("ftz") %>" />
            <p />
            <input name="AD0_1" value="<%=shipperTable("dba_name") %>" />
            <input name="AD0_2" value="<%=ReplaceAllButNumbers(shipperTable("business_fed_taxid")) %>" />
            <input name="AD0_3" value="E" />
            <input name="AD0_4" value="<%=shipperTable("business_address") %>" />
            <input name="AD0_5" value="" />
            <input name="AD0_6" value="<%=shipperTable("business_city") %>" />
            <input name="AD0_7" value="<%=shipperTable("business_state") %>" />
            <input name="AD0_8" value="<%=shipperTable("business_zip") %>" />
            <input name="AD0_9" value="<%=shipperTable("owner_fname") %>" />
            <input name="AD0_10" value="<%=shipperTable("owner_mname") %>" />
            <input name="AD0_11" value="<%=shipperTable("owner_lname") %>" />
            <input name="AD0_12" value="<%=ReplaceAllButNumbers(shipperTable("business_phone")) %>" />
            <p />
            <input name="AD3_2" value="E" />
            <input name="AD3_3" value="<%=agentTable("dba_name") %>"/>
            <input name="AD3_4" value="<%=ReplaceAllButNumbers(agentTable("business_fed_taxid")) %>" />
            <input name="AD3_5" value="<%=agentTable("owner_fname") %> <%=agentTable("owner_lname") %>" />
            <input name="AD3_7" value="<%=ReplaceAllButNumbers(agentTable("business_phone")) %>" />
            <input name="AD3_8" value="<%=agentTable("business_address") %>" />
            <input name="AD3_9" value="<%=agentTable("business_address2") %>" />
            <input name="AD3_10" value="<%=agentTable("business_city") %>" />
            <input name="AD3_11" value="<%=agentTable("business_state") %>" />
            <input name="AD3_12" value="<%=agentTable("country_code") %>" />
            <input name="AD3_13" value="<%=agentTable("business_zip") %>" />
            <% If checkBlank(headerTable("consignee_acct"),"0") <> "0" Then %>
            <p />
            <input name="AD1_3" value="<%=ultConsigneeTable("dba_name") %>" />
            <input name="AD1_8" value="<%=ultConsigneeTable("business_address") %>" />
            <input name="AD1_9" value="<%=ultConsigneeTable("business_address2") %>" />
            <input name="AD1_10" value="<%=ultConsigneeTable("business_city") %>" />
            <input name="AD1_11" value="<%=ultConsigneeTable("business_state") %>" />
            <input name="AD1_12" value="<%=ultConsigneeTable("country_code") %>" />
            <input name="AD1_13" value="<%=ultConsigneeTable("business_zip") %>" />
            <% End If %>
            <% If checkBlank(headerTable("inter_consignee_acct"),"0") <> "0" Then %>
            <p />
            <input name="AD4_3" value="<%=intConsigneeTable("dba_name") %>" />
            <input name="AD4_8" value="<%=intConsigneeTable("business_address") %>" />
            <input name="AD4_9" value="<%=intConsigneeTable("business_address2") %>" />
            <input name="AD4_10" value="<%=intConsigneeTable("business_city") %>" />
            <input name="AD4_11" value="<%=intConsigneeTable("business_state") %>" />
            <input name="AD4_12" value="<%=intConsigneeTable("country_code") %>" />
            <input name="AD4_13" value="<%=intConsigneeTable("business_zip") %>" />
            <% End If %>
            <p />
            <% For i=0 To itemDataList.Count-1 %>
            <input name="isLine<%=i+1 %>" value="Y" />
            <input name="IT<%=i+1 %>_1" value="<%=itemDataList(i)("export_code") %>" />
            <input name="IT<%=i+1 %>_2" value="<%=itemDataList(i)("item_value") %>" />
            <input name="IT<%=i+1 %>_3" value="<%=itemDataList(i)("unit1") %>" />
            <input name="IT<%=i+1 %>_4" value="<%=itemDataList(i)("b_qty1") %>" />
            <input name="IT<%=i+1 %>_5" value="<%=itemDataList(i)("unit2") %>" />
            <input name="IT<%=i+1 %>_6" value="<%=itemDataList(i)("b_qty2") %>" />
            <input name="IT<%=i+1 %>_7" value="<%=itemDataList(i)("gross_weight") %>" />
            <input name="IT<%=i+1 %>_8" value="<%=itemDataList(i)("license_type") %>" />
            <input name="IT<%=i+1 %>_9" value="<%=itemDataList(i)("license_number") %>" />
            <input name="IT<%=i+1 %>_12" value="<%=itemDataList(i)("item_desc") %>" />
            <input name="IT<%=i+1 %>_13" value="<%=ReplaceAllButNumbers(itemDataList(i)("b_number")) %>" />
            <% If checkBlank(itemDataList(i)("vin"),"") = "" Then %>
            <input name="IT<%=i+1 %>_15" value="N" />
            <% Else %>
            <input name="IT<%=i+1 %>_15" value="Y" />
            <input name="IT<%=i+1 %>_16" value="<%=itemDataList(i)("vin_type") %>" />
            <input name="IT<%=i+1 %>_17" value="<%=itemDataList(i)("vin") %>" />
            <input name="IT<%=i+1 %>_18" value="<%=itemDataList(i)("vc_title") %>" />
            <input name="IT<%=i+1 %>_19" value="<%=itemDataList(i)("vc_state") %>" />
            <% End If %>
            <input name="IT<%=i+1 %>_20" value="<%=itemDataList(i)("eccn") %>" />
            <input name="IT<%=i+1 %>_21" value="<%=itemDataList(i)("dfm") %>" />
            <p />
            <% Next %>
        </form>
    </div>
</body>
</html>
