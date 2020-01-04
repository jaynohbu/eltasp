
<%  
	custom_Change_evt = ""

    Set orgList = Server.CreateObject("System.Collections.ArrayList")
    Set orgList = get_organization_list(elt_account_number,iMoonType)
    
    Function get_organization_list(elt_account_number,org_type)
        Dim returnList,tempTable,SQL,rs
        
        Set returnList = Server.CreateObject("System.Collections.ArrayList")
        Set tempTable = Server.CreateObject("System.Collections.HashTable")
        Set rs = Server.CreateObject("ADODB.Recordset")
        
        
        SQL = "SELECT org_account_number, " _
            & "CASE WHEN isnull(class_code,'') = '' THEN dba_name " _
            & "ELSE dba_name + '[' + RTRIM(LTRIM(isnull(class_code,''))) + ']' " _
            & "END as dba_name FROM organization where elt_account_number = " & elt_account_number    
            
        Select case org_type
            case "Shipper" 
                SQL = SQL & "AND is_shipper='Y' "
            case "Consignee" 
                SQL = SQL & "AND (is_consignee='Y' OR is_shipper='Y') "
            case "ConsigneeOrAgent"
                SQL = SQL & "AND (is_consignee='Y' OR is_shipper='Y' OR is_agent='Y') "
            case "Notify"
                SQL = SQL & "AND (is_consignee='Y' OR is_shipper='Y' OR is_agent='Y') "
            case "Carrier" 
                SQL = SQL & "AND is_carrier='Y' AND ISNULL(carrier_code,'') <> '' "
            case "Agent" 
                SQL = SQL & "AND is_agent='Y' "
            case "Trucker" 
                SQL = SQL & "AND z_is_trucker='Y' "
            case "Government"
                SQL = SQL & "AND z_is_govt='Y' "
            case "Broker"
                SQL = SQL & "AND z_is_broker='Y' "
            case "VendorAP"
				custom_Change_evt = "IVCustomer"
				set get_organization_list = get_organization_list_for_ap( elt_account_number )
				exit function
            case "VendorAQ"
				custom_Change_evt = "IVCustomer"
				set get_organization_list = get_organization_list_for_aq( elt_account_number )
				exit function
            case "IVCustomer"
				custom_Change_evt = "IVCustomer"
				set get_organization_list = get_organization_list_for_iv( elt_account_number )
				exit function
            case "CustomerAR"
				custom_Change_evt = "IVCustomer"
        End Select
            
        SQL = SQL & " and isnull(account_status,'A')<>'C' ORDER BY dba_name"
        eltConn.CursorLocation = adUseNone
	    rs.CursorLocation = adUseClient	
	    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
        Set rs.ActiveConnection = Nothing

        Do While Not rs.EOF and NOT rs.bof
            Set tempTable = Server.CreateObject("System.Collections.HashTable")
            tempTable.Add "acct", rs("org_account_number").value
            tempTable.Add "name", RemoveQuotations(rs("dba_name").value)
            returnList.Add tempTable
		    rs.MoveNext
	    Loop
        
        rs.Close
	    Set rs = Nothing
        Set get_organization_list = returnList
    End Function
	
	Function get_organization_list_for_ap( elt_account_number )
	
	Dim returnList,tempTable,SQL,rs 
	Set returnList = Server.CreateObject("System.Collections.ArrayList")
	Set tempTable = Server.CreateObject("System.Collections.HashTable")
	Set rs = Server.CreateObject("ADODB.Recordset")

	SQL = "SELECT org_account_number, " _
		& "CASE WHEN isnull(class_code,'') = '' THEN dba_name " _
		& "ELSE dba_name + '[' + RTRIM(LTRIM(isnull(class_code,''))) + ']' " _
		& "END as dba_name  FROM organization where elt_account_number = " & elt_account_number   
	SQL = SQL & " and (Is_Agent='Y' or Is_Vendor='Y' or z_is_special ='Y' or z_is_trucker='Y') ORDER BY dba_name"

	eltConn.CursorLocation = adUseNone
	rs.CursorLocation = adUseClient	
	rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
	Set rs.ActiveConnection = Nothing
	
	Do While Not rs.EOF and NOT rs.bof
		Set tempTable = Server.CreateObject("System.Collections.HashTable")
		tempTable.Add "acct", rs("org_account_number").value
		tempTable.Add "name", RemoveQuotations(rs("dba_name").value)
		returnList.Add tempTable
		rs.MoveNext
	Loop
	
	rs.Close
	Set rs = Nothing
	Set get_organization_list_for_ap = returnList
    End Function

	Function get_organization_list_for_aq( elt_account_number )
	
	Dim returnList,tempTable,SQL,rs 
	Set returnList = Server.CreateObject("System.Collections.ArrayList")
	Set tempTable = Server.CreateObject("System.Collections.HashTable")
	Set rs = Server.CreateObject("ADODB.Recordset")

	SQL = "SELECT org_account_number, " _
		& "CASE WHEN isnull(class_code,'') = '' THEN dba_name " _
		& "ELSE dba_name + '[' + RTRIM(LTRIM(isnull(class_code,''))) + ']' " _
		& "END as dba_name,isnull(bill_term,0) as bill_term  FROM organization where elt_account_number = " & elt_account_number   
	SQL = SQL & " and (Is_Agent='Y' or Is_Vendor='Y' or z_is_special ='Y' or z_is_trucker='Y') ORDER BY dba_name"

	eltConn.CursorLocation = adUseNone
	rs.CursorLocation = adUseClient	
	rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
	Set rs.ActiveConnection = Nothing

	Do While Not rs.EOF and NOT rs.bof
		Set tempTable = Server.CreateObject("System.Collections.HashTable")
		tempTable.Add "acct", rs("org_account_number").value
		tempTable.Add "name", RemoveQuotations(rs("dba_name").value)

		if cLng(rs("org_account_number").value) = cLng(VendorNo) then
			BillTerm=cint(rs("bill_term").value)
		end if

		returnList.Add tempTable
		rs.MoveNext
	Loop
	
	rs.Close
	Set rs = Nothing
	Set get_organization_list_for_aq = returnList
    End Function

	Function get_organization_list_for_iv( elt_account_number )
		
        Dim returnList,tempTable,SQL,rs,cZAttn,cTerm        
        Set returnList = Server.CreateObject("System.Collections.ArrayList")
        Set tempTable = Server.CreateObject("System.Collections.HashTable")
        Set rs = Server.CreateObject("ADODB.Recordset")

        SQL = "SELECT org_account_number, " _
            & "CASE WHEN isnull(class_code,'') = '' THEN dba_name " _
            & "ELSE dba_name + '[' + RTRIM(LTRIM(isnull(class_code,''))) + ']' " _
            & "END as dba_name,bill_term,isnull(z_attn_txt,'') as z_attn_txt  FROM organization where elt_account_number = " & elt_account_number   
                
        SQL = SQL & " ORDER BY dba_name"

		eltConn.CursorLocation = adUseNone
	    rs.CursorLocation = adUseClient	
	    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
        Set rs.ActiveConnection = Nothing

        Do While Not rs.EOF and NOT rs.bof
            Set tempTable = Server.CreateObject("System.Collections.HashTable")
            tempTable.Add "acct", rs("org_account_number").value
			tempTable.Add "name", RemoveQuotations(rs("dba_name").value)
			cTerm=rs("bill_term").value
			tempTable.Add "term", cTerm

			if NewInvoice = "yes" then
					if  cLng(vOrgAcct) = cLng(rs("org_account_number").value) then
						cZAttn = rs("z_attn_txt")
						if Trim(cZAttn) = "" or isnull(rs("z_attn_txt")) then
							cZAttn = "ATTN.: Accounts Payable"
						else
							cZAttn = "ATTN.:"& cZAttn
						end if
						if (cTerm = "" ) then cTerm = "0"
						vTerm = cTerm
						if inStr(vCustomerInfo,"ATTN.:") < 0 then
							vCustomerInfo = vCustomerInfo & chr(10) & cZAttn
						end if
					end if
			end if

            returnList.Add tempTable
		    rs.MoveNext
	    Loop
        
        rs.Close
	    Set rs = Nothing
        Set get_organization_list_for_iv = returnList
    End Function

	Function RemoveQuotations(arg)
        Dim temp
        If IsNull(arg) Or Trim(arg) = "" Then
            temp = ""
        Else
            temp = Replace(arg,chr(34)," ")
            temp = Replace(temp,"'","`")
        End If
        RemoveQuotations = temp
    End Function
    
    Function checkBlank(arg1,arg2)
        Dim result
        If IsNull(arg1) Then 
            result = arg2
        Else
		    If Trim(arg1)="" Then
			    result = arg2
		    Else
			    result = Trim(arg1)
		    End If
        End If    
        checkBlank = result
    End Function
    
    Function removeClassString(arg)
        Dim temp,pos
        pos = InStr(1,arg,"[")
        If checkBlank(pos,0) > 0 Then
            temp = Left(arg,pos-1)
        Else
            temp = arg
        End If
        removeClassString = temp
    End Function
%>

<script type="text/javascript" language="javascript"> 
<% if custom_Change_evt = "IVCustomer" then %>
	function <%=iMoonComboBoxName%>_OnChangePlus(){IV_CustomerChange();} 
<% else %>
	function <%=iMoonComboBoxName%>_OnChangePlus(){<%=iMoonComboBoxName%>_Change();} 
<% end if %>
function <%=iMoonComboBoxName%>_OnAddNewPlus(oText,oSelect,oDiv) 
{    
    var orgNum = oSelect.value;

    var popAddClient = showModalDialog("../Include/quickAddClient.asp?orgNum=" + orgNum,"AddClient","dialogWidth:450px; dialogHeight:500px; help:0; status:1; scroll:0; center:1; Sunken;");
    if(popAddClient != undefined && popAddClient != "")
    {
        ajust_changed_list_new(popAddClient,oSelect,oDiv,oText);
		if ('<%=custom_Change_evt%>' != 'IVCustomer') {
	        <%=iMoonComboBoxName%>_Change(); 
		} else {
			IV_CustomerChange();
		}
    }
	return true;
}

function <%=iMoonComboBoxName%>_Change()
{
    
    var acctNumber = document.getElementById("<%=iMoonComboBoxName %>").value;
    var result = "";

    if (window.ActiveXObject) {
        try {
            xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
        } catch(error) {
            try {
                xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
            } catch(error) { return false; }
        }
    } else if (window.XMLHttpRequest) {
        xmlHTTP = new XMLHttpRequest();
    } else { return false; }

    try {
        var url="../ajaxFunctions/ajax_get_org_address_info.asp?type=B&org="+ acctNumber;
        if("<%=iMoonType %>" == "Carrier")
        {
            url="../ajaxFunctions/ajax_get_org_address_info.asp?type=C&org="+ acctNumber;
        }
        
        xmlHTTP.open("GET",url,false); 
        xmlHTTP.send(); 
		
        result = xmlHTTP.responseText;
        
    } catch(error) {}

	<% If iMoonType = "Carrier" Then %>
	var temp = new Array();
	temp = result.split("-");
	document.getElementById("hCarrierCode").value = temp[0];
        <% If iMoonRelatedArea <> "" Then %>
	    document.getElementById("<%=iMoonRelatedArea %>").value = result.substring(temp[0].length+1,result.length);
	    <% End If %>
	    <% If iMoonHiddenField <> "" Then %>
	    document.getElementById("<%=iMoonHiddenField %>").value = acctNumber;
	    <% End If %>
	<% Else %>
	    <% If iMoonTextArea <> "" Then  %>
        document.getElementById("<%=iMoonTextArea %>").value = result;
	    <% End If %>
	    <% If iMoonHiddenField <> "" Then %>
	    document.getElementById("<%=iMoonHiddenField %>").value = acctNumber;
	    <% End If %>
	    <% If iMoonRelatedArea <> "" Then %>
	    document.getElementById("<%=iMoonRelatedArea %>").value = result;
	    <% End If %>
	<% End If %>
	
	<% If iMoonType = "Consignee" Or iMoonType = "ConsigneeOrAgent" Then %>
	var temp = new Array();
	temp = result.split("\n");
    document.getElementById("hNotifyAcct").value = acctNumber;    
    <%=iMoonComboBoxName%>_findSelect(document.getElementById("lstNotifyName"),acctNumber);
    document.getElementById("lstNotifyName_Text").value = temp[0];
    if(document.getElementById("txtBrokerInfo") != null) {
        lstConsigneeNameChangeAdd();
    }
    <% End If %>
    
    <% If iMoonType = "Agent" Then %>
    
    if(document.getElementById("txtExportInstr") != null){
        document.getElementById("txtExportInstr").value = result;
    }
    <% End If %>
}

function <%=iMoonComboBoxName%>_findSelect(oSelect,selVal)
{
    oSelect.options.selectedIndex = 0;

    for(var i=0;i<oSelect.options.length;i++)
    {
        if(oSelect.options[i].value == selVal)
        {
            oSelect.options[i].selected = true;
            break;
        }
    }
}
        
</script>

<div id="<%=iMoonComboBoxName%>_Container" class="ComboBox" style="width: <%=iMoonComboBoxWidth%>; 
    position: ; top: ; left: ; z-index: ;">
    <input name="<%=iMoonComboBoxName%>:Text" type="text" id="<%=iMoonComboBoxName%>_Text"
        class="ComboBox" autocomplete="off" style="width: <%=iMoonComboBoxWidth%>; vertical-align: middle"
        value="<%=iMoonDefaultValue%>" />
    <div id="<%=iMoonComboBoxName%>_Div" style="display: none; position: absolute; top: 0;
        left: 0; width: 17px">
        <img id="<%=iMoonComboBoxName%>_Button" src="/ig_common/Images/combobox_drop.gif"
            border="0" /></div>
</div>
<div id="<%=iMoonComboBoxName%>_NewDiv" style="display: none; position: absolute;
    top: 0; left: 0; width: 17px">
    <img id="<%=iMoonComboBoxName%>_AddNewButton" src="/ig_common/Images/combobox_addnew.gif"
        border="0" /></div>
<select name="<%=iMoonComboBoxName %>" id="<%=iMoonComboBoxName %>" listsize="20" class="ComboBox"
    style="width: <%=iMoonComboBoxWidth%>; display: none" onchange="ComboBox_SimpleAttach(this, this.form['<%=iMoonComboBoxName%>_Text']); docModified(1);">
    <option value="">Select One</option>
    <% For i=0 To orgList.count-1 %>
    <option value="<%= orgList(i)("acct") %>" 
        <% If cLng(checkBlank(iMoonDefaultValueHidden,0)) = cLng(orgList(i)("acct")) Then 
        iMoonDefaultValue = removeClassString(orgList(i)("name"))
        Response.Write("selected")
        End If %>>
        <%= orgList(i)("name") %>
    </option>
    <% Next %>
</select>

<% If iMoonTextArea <> "" Then  %>
<br />
<textarea id="<%=iMoonTextArea %>" wrap="hard" name="<%=iMoonTextArea %>" style="width:<%=iMoonComboBoxWidth %>" rows="5"
    class="multilinetextfield"><%=iMoonDefaultValueInfo %></textarea>
<% End If %>

<% If iMoonType = "Carrier" Then %>
<input type="hidden" name="hCarrierCode" value="<%=iMoonDefaultValueHidden %>" />
<% End If %>

<% If iMoonHiddenField <> "" Then %>
<input type="hidden" name="<%=iMoonHiddenField %>" value="<%=iMoonDefaultValueHidden %>" />
<% End If %>

<% If iMoonType = "Notify" Then %>
<script type="text/javascript">
    document.getElementById("lstNotifyName_Text").value = "<%=iMoonDefaultValue %>";
</script>
<% End If %>

