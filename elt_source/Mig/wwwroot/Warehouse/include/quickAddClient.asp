<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% Option Explicit %>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/Header.asp" -->
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<%
Dim aStateCode(52),aStateName(52),aStateIndex
Dim aCountryCodeArry(),aCountryArry(),aConIndex
Dim SQL,rs,i,code_str,code_desc,code_type,AddressInfo,addPhoneFax

Dim vOrgNum,vTaxId,vDbaName,vClassCode,vAddress,vAddress2,vCity,vState,vCountry,vFirstName,vMiddleName,vLastName,vPhone,vFax,vCell,vEmail,vCountryName,vZip
Dim oldConsignee,oldShipper,oldAgent,oldCarrier,oldTrucker,oldWarehousing,oldCFS,oldBroker,oldGovt,oldSpecial,oldVendor,vAnotherAccount

'// Initializing /////////////////////////////
code_str = "business_city"
code_desc = ""
eltConn.CursorLocation = adUseClient
Set rs = Server.CreateObject("ADODB.Recordset")
AddressInfo = ""

'// Main Process /////////////////////////////
Call get_country
Call get_all_state

vOrgNum = checkBlank(Request.QueryString("orgNum").Item,0)

If checkBlank(Request.QueryString("mode").Item,"view") = "save" Then
    Call read_client_screen()
    Call save_client(vOrgNum)
Else
    Call load_client_info(vOrgNum,checkBlank(Request.QueryString("dir").Item,""))
End If

'// Sub Routines ////////////////////////////////////////////////////////////////////////////////////
'////////////////////////////////////////////////////////////////////////////////////////////////////

Sub get_country
    Dim iCnt
    SQL = "select count(*) as iCnt from country_code where elt_account_number = " & elt_account_number 

    rs.CursorLocation = adUseClient	
	rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
    Set rs.ActiveConnection = Nothing
    
    iCnt = 0
    if NOT rs.eof and NOT rs.bof then
	    iCnt = rs("iCnt")
    end if	
    rs.Close

    ReDim aCountryCodeArry(iCnt),aCountryArry(iCnt)
    SQL = "select country_code,country_name from country_code where elt_account_number = " & elt_account_number 

    Set rs = eltConn.Execute(SQL)
    aConIndex = 0

    Do While Not rs.EOF 
	    aCountryCodeArry(aConIndex) = rs("country_code")
	    aCountryArry(aConIndex) = rs("country_name")
	    aConIndex = aConIndex + 1
	    rs.MoveNext
    Loop	
    rs.Close
    
End Sub

Sub get_all_state

    aStateCode(0) = ""  
    aStateCode(1) = "AK"  
    aStateCode(2) = "AL"  
    aStateCode(3) = "AR"  
    aStateCode(4) = "AZ"  
    aStateCode(5) = "CA"  
    aStateCode(6) = "CO"  
    aStateCode(7) = "CT"  
    aStateCode(8) = "DC"  
    aStateCode(9) = "DE"  
    aStateCode(10) = "FL" 
    aStateCode(11) = "GA" 
    aStateCode(12) = "HI" 
    aStateCode(13) = "IA" 
    aStateCode(14) = "ID" 
    aStateCode(15) = "IL" 
    aStateCode(16) = "IN" 
    aStateCode(17) = "KS" 
    aStateCode(18) = "KY" 
    aStateCode(19) = "LA" 
    aStateCode(20) = "MA" 
    aStateCode(21) = "MD" 
    aStateCode(22) = "ME" 
    aStateCode(23) = "MI" 
    aStateCode(24) = "MN" 
    aStateCode(25) = "MO" 
    aStateCode(26) = "MS" 
    aStateCode(27) = "MT" 
    aStateCode(28) = "NC" 
    aStateCode(29) = "ND" 
    aStateCode(30) = "NE" 
    aStateCode(31) = "NH" 
    aStateCode(32) = "NJ" 
    aStateCode(33) = "NM" 
    aStateCode(34) = "NV" 
    aStateCode(35) = "NY" 
    aStateCode(36) = "OH" 
    aStateCode(37) = "OK" 
    aStateCode(38) = "OR" 
    aStateCode(39) = "PA" 
    aStateCode(40) = "RI" 
    aStateCode(41) = "SC" 
    aStateCode(42) = "SD" 
    aStateCode(43) = "TN" 
    aStateCode(44) = "TX" 
    aStateCode(45) = "UT" 
    aStateCode(46) = "VA" 
    aStateCode(47) = "VT" 
    aStateCode(48) = "WA" 
    aStateCode(49) = "WI" 
    aStateCode(50) = "WV" 
    aStateCode(51) = "WY" 

    aStateName(0) = ""             
    aStateName(1) = "Alaska"             
    aStateName(2) = "Alabama"            
    aStateName(3) = "Arkansas"           
    aStateName(4) = "Arizona"            
    aStateName(5) = "California"         
    aStateName(6) = "Colorado"           
    aStateName(7) = "Connecticut"        
    aStateName(8) = "DC"                 
    aStateName(9) = "Delaware"           
    aStateName(10) = "Florida"           
    aStateName(11) = "Georgia"           
    aStateName(12) = "Hawaii"            
    aStateName(13) = "Iowa"              
    aStateName(14) = "Idaho"             
    aStateName(15) = "Illinois"          
    aStateName(16) = "Indiana"           
    aStateName(17) = "Kansas"            
    aStateName(18) = "Kentucky"          
    aStateName(19) = "Louisiana"         
    aStateName(20) = "Massachusetts"     
    aStateName(21) = "Maryland"          
    aStateName(22) = "Maine"             
    aStateName(23) = "Michigan"          
    aStateName(24) = "Minnesota"         
    aStateName(25) = "Missouri"          
    aStateName(26) = "Mississippi"       
    aStateName(27) = "Montana"           
    aStateName(28) = "North Carolina"    
    aStateName(29) = "North Dakota"      
    aStateName(30) = "Nebraska"          
    aStateName(31) = "New Hampshire"     
    aStateName(32) = "New Jersey"        
    aStateName(33) = "New Mexico"        
    aStateName(34) = "Nevada"            
    aStateName(35) = "New York"          
    aStateName(36) = "Ohio"              
    aStateName(37) = "Oklahoma"          
    aStateName(38) = "Oregon"            
    aStateName(39) = "Pennsylvania"      
    aStateName(40) = "Rhode Island"      
    aStateName(41) = "South Carolina"    
    aStateName(42) = "South Dakota"      
    aStateName(43) = "Tennessee"         
    aStateName(44) = "Texas"             
    aStateName(45) = "Utah"              
    aStateName(46) = "Virginia"          
    aStateName(47) = "Vermont"           
    aStateName(48) = "Washington"        
    aStateName(49) = "Wisconsin"         
    aStateName(50) = "West Virginia"     
    aStateName(51) = "Wyoming"           
    aStateIndex = 52
    
End Sub

Function gather_list_all(sType)

    Dim code,codeText
    Dim returnStr
    returnStr = "<option></option>\n"
    SQL = "select code,isnull(description,'') as description from all_code where elt_account_number = " & elt_account_number & " AND  type="& sType &" order by code"
    
    rs.CursorLocation = adUseClient	
	rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
    Set rs.ActiveConnection = Nothing

    returnStr = returnStr + "<option value='_edit' style='color:#cc6600; font-weight:bold'>Edit List...</option>\n"
    Do While Not rs.EOF and NOT rs.bof
	    code = Trim(rs("code").value)
	    codeText = mid(rs("description").value,1,10)
	    returnStr = returnStr + "<option value='" & code & "'>" & code & "</option>\n"
	    rs.MoveNext
    Loop
    
    rs.Close()
    gather_list_all = returnStr
    
End Function

Sub load_client_info(orgNum,vDirect)

    SQL = "select TOP 1 org_account_number, " _
        & "isnull(dba_name,'') as dba_name, " _
        & "isnull(org_account_number,0) as org_account_number, " _
        & "isnull(business_fed_taxid,'') as business_fed_taxid, " _
        & "RTRIM(isnull(class_code,'')) as class_code, " _
        & "isnull(business_address,'') as business_address, " _
        & "isnull(business_address2,'') as business_address2, " _
        & "isnull(business_city,'') as business_city, " _
        & "isnull(business_state,'') as business_state, " _
        & "isnull(business_zip,'') as business_zip, " _
        & "isnull(b_country_code,'') as b_country_code, " _
        & "isnull(business_phone,'') as business_phone, " _
        & "isnull(business_fax,'') as business_fax, " _
        & "isnull(owner_lname,'') as owner_lname, " _
        & "isnull(owner_fname,'') as owner_fname, " _
        & "isnull(owner_mname,'') as owner_mname, " _
        & "isnull(owner_phone,'') as owner_phone, " _
        & "isnull(owner_email,'') as owner_email, "_
        & "isnull(is_consignee,'') as is_consignee, "_
        & "isnull(is_shipper,'') as is_shipper, "_
        & "isnull(is_agent,'') as is_agent, "_
        & "isnull(is_carrier,'') as is_carrier, "_
        & "isnull(z_is_trucker,'') as z_is_trucker, "_
        & "isnull(z_is_warehousing,'') as z_is_warehousing, "_
        & "isnull(z_is_cfs,'') as z_is_cfs, "_
        & "isnull(z_is_broker,'') as z_is_broker, "_
        & "isnull(z_is_govt,'') as z_is_govt, "_
        & "isnull(z_is_special,'') as z_is_special, "_
        & "isnull(is_vendor,'') as is_vendor "_
        & " FROM organization where elt_account_number = " & elt_account_number
        
    If vDirect = "next" Then
        SQL = SQL & " AND dba_name < (SELECT dba_name from organization where elt_account_number=" _
            & elt_account_number & " and org_account_number='" & orgNum & "') order by dba_name desc"
    Elseif vDirect = "prev" Then
        SQL = SQL & " AND dba_name > (SELECT dba_name from organization where elt_account_number=" _
            & elt_account_number & " and org_account_number='" & orgNum & "') order by dba_name asc"
    Else
        SQL = SQL & " AND org_account_number=" & orgNum
    End IF
    
	rs.CursorLocation = adUseClient	
	rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
    Set rs.ActiveConnection = Nothing
    
    If Not rs.EOF and Not rs.BOF Then
    
        vAnotherAccount = elt_account_number
        vDbaName = rs("dba_name").value
        vOrgNum = rs("org_account_number").value
        vTaxId = rs("business_fed_taxid").value
        vClassCode = rs("class_code").value
        vAddress = rs("business_address").value
        vAddress2 = rs("business_address2").value
        vCity = rs("business_city").value
        vState = rs("business_state").value
        vZip = rs("business_zip").value
        vCountry = rs("b_country_code").value
        vFirstName = rs("owner_fname").value
        vMiddleName = rs("owner_mname").value
        vLastName = rs("owner_lname").value
        vPhone = rs("business_phone").value
        vFax = rs("business_fax").value
        vCell = rs("owner_phone").value
        vEmail = rs("owner_email").value
        oldConsignee = rs("is_consignee").value
        oldShipper = rs("is_shipper").value
        oldAgent = rs("is_agent").value
        oldCarrier = rs("is_carrier").value
        oldTrucker = rs("z_is_trucker").value
        oldWarehousing = rs("z_is_warehousing").value
        oldCFS = rs("z_is_cfs").value
        oldBroker = rs("z_is_broker").value
        oldGovt = rs("z_is_govt").value
        oldSpecial = rs("z_is_special").value
        oldVendor = rs("is_vendor").value
    Else
        vOrgNum = 0
    
    End If

    rs.Close()
    
End Sub


Sub save_client(orgNum)

    '// SQL = "select elt_account_number,org_account_number,date_opened,last_update,account_status,dba_name,business_fed_taxid,class_code,business_address,business_address2,business_city, business_state,business_zip, b_country_code,business_country,business_phone,business_fax,owner_lname,owner_fname,owner_mname,owner_phone,owner_email from organization where elt_account_number = " & elt_account_number & " and org_account_number=" & orgNum	
    SQL = "SELECT * FROM organization WHERE elt_account_number=" & elt_account_number _
        & " and org_account_number=" & orgNum	

    rs.CursorLocation = adUseClient
	rs.Open SQL,eltConn,adOpenStatic,adLockPessimistic,adCmdText

    If rs.EOF Then
        rs.AddNew
        rs("elt_account_number") = elt_account_number	
        orgNum = available_org_number()
        rs("org_account_number")= orgNum
        rs("date_opened")=date	
		rs("last_update")=date	
    Else 
		rs("last_update")=date	
    End If

    rs("account_status") = "A"
    rs("dba_name") = vDbaName
    rs("business_fed_taxid")=vTaxId
    rs("class_code") = Trim(vClassCode)
    rs("business_address") = vAddress
    rs("business_address2") = vAddress2
    rs("business_city") = vCity
    rs("business_state") = vState
    rs("business_zip") = vZip
    rs("b_country_code") = vCountry
    rs("business_country") = vCountryName
    rs("owner_fname") = vFirstName
    rs("owner_mname") = vMiddleName
    rs("owner_lname") = vLastName
    rs("business_phone") = vPhone
    rs("business_fax") = vFax
    rs("owner_phone") = vCell
    rs("owner_email") = vEmail
			 
    rs("is_consignee") = oldConsignee
    rs("is_shipper") = oldShipper
    rs("is_agent") = oldAgent
    rs("is_carrier") = oldCarrier
    rs("z_is_trucker") = oldTrucker
    rs("z_is_warehousing") = oldWarehousing
    rs("z_is_cfs") = oldCFS
    rs("z_is_broker") = oldBroker
    rs("z_is_govt") = oldGovt
    rs("z_is_special") = oldSpecial
    rs("is_vendor") = oldVendor
	 
    If oldAgent = "Y" or oldCarrier = "Y" or oldTrucker = "Y" or oldWarehousing = "Y" or oldCFS = "Y" or oldBroker = "Y" then
        rs("is_vendor") = "Y"
    End If	 

    rs.Update
    rs.Close
    
    '// editible dropdown update
	addPhoneFax = Session("addPhoneFax")
	
	If vClassCode <> "" Then
        AddressInfo = vDbaName & "[" & vClassCode & "]"
    Else
        AddressInfo = vDbaName
    End If
	
    if addPhoneFax = "yes" then
		if Not Trim(vState)="" then
			AddressInfo=orgNum & "-" & AddressInfo & "^^^" & vAddress & "^^^" 
			If Not IsNull(vAddress2) And Trim(vAddress2)<>"" Then
				AddressInfo = AddressInfo & vAddress2 & "^^^" 
			End If
			AddressInfo = AddressInfo & vCity & "," & vState & " " & vZip & "," & vCountryName & "^^^" & "Tel:" & vPhone & " " & "Fax:" & vFax
		else
			AddressInfo=orgNum & "-" & AddressInfo & "^^^" & vAddress & "^^^" 
			If Not IsNull(vAddress2) And Trim(vAddress2)<>"" Then
				AddressInfo = AddressInfo & vAddress2 & "^^^" 
			End If
			AddressInfo = AddressInfo & vCity & "," & vCountryName & "^^^" & "Tel:" & vPhone & " " & "Fax:" & vFax
		end if
	else
		if Not Trim(vState)="" then
			AddressInfo=orgNum & "-" & AddressInfo & "^^^" & vAddress & "^^^" 
			If Not IsNull(vAddress2) And Trim(vAddress2)<>"" Then
				AddressInfo = AddressInfo & vAddress2 & "^^^" 
			End If
			AddressInfo = AddressInfo & "^^^" & vCity & "," & vState & " " & vZip & "," & vCountryName & "^^^" & vPhone
		else
			AddressInfo=orgNum & "-" & AddressInfo & "^^^" & vAddress & "^^^" 
			If Not IsNull(vAddress2) And Trim(vAddress2)<>"" Then
				AddressInfo = AddressInfo & vAddress2 & "^^^" 
			End If
			AddressInfo = AddressInfo & vCity & "," & vCountryName & "^^^" & vPhone
		end if
	end if

End Sub

Sub read_client_screen()

    vDbaName = Request.Form.Item("txtDbaName")	
    vTaxId = Request.Form.Item("txtTaxId")
    vClassCode = Request.Form.Item("lstClass")
	vClassCode = trim(vClassCode)
    vAddress = Request.Form.Item("txtAddress")
    vAddress2 = Request.Form.Item("txtAddress2")
    vCity = Request.Form.Item("txtCity")	
    vState = Request.Form.Item("lstState")	
    vZip = Request.Form.Item("txtZip")	
    vCountry = Request.Form.Item("lstCountry")	
    vFirstName = Request.Form.Item("txtFirstName")	
    vMiddleName = Request.Form.Item("txtMiddleName")	
    vLastName = Request.Form.Item("txtvLastName")	
    vPhone = Request.Form.Item("txtPhone")	
    vFax = Request.Form.Item("txtFax")	
    vCell = Request.Form.Item("txtCell")	
    vEmail = Request.Form.Item("txtEmail")	

    oldConsignee = checkBlank(Request.Form.Item("chkConsignee"),"")	
    oldShipper = checkBlank(Request.Form.Item("chkShipper"),"")
    oldAgent = checkBlank(Request.Form.Item("chkAgent"),"")
    oldCarrier = checkBlank(Request.Form.Item("chkCarrier"),"")
    oldTrucker = checkBlank(Request.Form.Item("chkTrucker"),"")
    oldWarehousing = checkBlank(Request.Form.Item("chkWarehousing"),"")
    oldCFS = checkBlank(Request.Form.Item("chkCFS")	,"")
    oldBroker = checkBlank(Request.Form.Item("chkBroker"),"")
    oldGovt = checkBlank(Request.Form.Item("chkGovt"),"")
    oldSpecial = checkBlank(Request.Form.Item("chkSpecial"),"")
    oldVendor = checkBlank(Request.Form.Item("chkVendor"),"")

    vCountryName = ""
    For i=0 to aConIndex 
        If aCountryCodeArry(i) = vCountry then
            vCountryName = aCountryArry(i)
			Exit For
		End If	 
    Next

End Sub

Function available_org_number()

    Dim newOrgNum,rsMax
    
    Set rsMax = Server.CreateObject("ADODB.Recordset")
    SQL= "select max(org_account_number) as newOrgNum from organization where elt_account_number = " & elt_account_number
    
    rsMax.CursorLocation = adUseClient
	rsMax.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
    Set rsMax.ActiveConnection = Nothing

    If Not rsMax.EOF Then
        newOrgNum = CLng(rsMax("newOrgNum").value) + 1
    else
        newOrgNum=1 
    End If    
    rsMax.Close()

    available_org_number = newOrgNum
    Set rsMax = Nothing

End Function

%>
<html>
<head>
    <title>Client Quick Add</title>
    <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css">
    <style type="text/css">
<!--
.normalinputbox {
	vertical-align: middle;
	height: 15px;
	width: 30px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
	margin-left: 3px;
	background-repeat: no-repeat;
	background-position: left center;
	padding-top: 0px;
	padding-right: 0px;
	padding-bottom: 0px;
	padding-left: 6px;
}
.redinputbox {
	vertical-align: middle;
	height: 15px;
	width: 30px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
	margin-left: 3px;
	background-image: url(/IFF_main/ASP/Images/bullet_quick.gif);
	background-repeat: no-repeat;
	background-position: left center;
	padding-top: 0px;
	padding-right: 0px;
	padding-bottom: 0px;
	padding-left: 6px;
}
-->
</style>

    <script language="javascript" type="text/javascript" src="../ajaxFunctions/otherFunctions.js"></script>

    <script type="text/javascript" language="javascript" src="../ajaxFunctions/ajax.js"></script>

    <script type="text/javascript">

    function editClass(oSelect) {

        if(oSelect.options.selectedIndex == 1)
        {
            var param =  'PostBack=false&type=class_code&default=';
            var retVal = showModalDialog("../Include/all_code_manage.asp?" +param,
                        "AllCode","dialogWidth:450px; dialogHeight:340px; help:0; status:0; scroll:0;center:1;Sunken;");					
            	
            if (retVal != '' && typeof(retVal) != 'undefined') 
            {
                var url = "/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=class_code"; 
	            new ajax.xhr.Request('GET','',url,reloadClass,'','','','');
            }
        }
    }
    
    function reloadClass(req,field,tmpVal,tWidth,tMaxLength,url)
    {
        if (req.readyState == 4)
        {   
            if (req.status == 200)
            {
                var oSelectDiv = document.getElementById("lstClassDiv");
                
                var tagStr = "<select id=\"lstClass\" name=\"lstClass\" onchange=\"editClass(this);\" class=\"bodycopy\" style=\"width:180px\" >"
                    + req.responseText + "</select>"
                oSelectDiv.innerHTML = tagStr;
            }
        }
    }
    function x_trim(sourceString) { return sourceString.replace(/(?:^\s+|\s+$)/ig, ""); }
    function setClassCode()
    {
        var oSelect = document.getElementById("lstClass");
        var classValue = "<%=vClassCode %>";
        classValue = x_trim(classValue);
        for(var i=0;i<oSelect.options.length;i++)
        {
            var tempStr = oSelect.options[i].value;
           
            if( tempStr == classValue )
            {
                oSelect.options[i].selected = true;
            }
            else
            {
                oSelect.options[i].selected = false;
            }
        }
    }
    
    function ResetClient() 
    {
        document.form1.action="quickAddClient.asp"
	    document.form1.method="POST";
	    document.form1.target = window.name;
	    document.form1.submit();
    }

    function lstStateChange(o)
    {
        var oCountry  = document.getElementById( "lstCountry" );		

	    if(o.value == "") 
	    {
		    oCountry.selectedIndex = 0;	
	    }
	    else
	    {
		    oCountry.value = 'US';
	    }
    }
    
    function saveClient()
    {
        var iOrg = document.getElementById("hOrgAcct").value;
        var iDBA = document.getElementById("txtDbaName").value;
            
        if(iDBA == null || iDBA == "")
        {
            alert("Please, enter dba name for this client");
            return false;
        }
        
        if(!check_org_data("U", iOrg,iDBA,""))
        {
		    return false;
	    }
	    
        var form = document.getElementById("form1");
        
        for(var i = 0; i < form.elements.length; i++)
        {
            if(form.elements[i].checked == true)
            {
                form.elements[i].value = "Y";
            }
        }
        
        form.action="quickAddClient.asp?mode=save&orgNum=<%=vOrgNum %>"
	    form.method="POST";
	    form.target = window.name;
	    form.submit();
    }
    
    function saveAsNewClient()
    {
        var iOrg = document.getElementById("hOrgAcct").value;
        var iDBA = document.getElementById("txtDbaName").value;
            
        if(iDBA == null || iDBA == "")
        {
            alert("Please, enter dba name for this client");
            return false;
        }
        
        if(!check_org_data("C", iOrg,iDBA,""))
        {
		    return false;
	    }
	    
        var form = document.getElementById("form1");
        
        for(var i = 0; i < form.elements.length; i++)
        {
            if(form.elements[i].checked == true)
            {
                form.elements[i].value = "Y";
            }
        }
        
        form.action="quickAddClient.asp?mode=save&orgNum=0"
	    form.method="POST";
	    form.target = window.name;
	    form.submit();
    }
    
    function sendReturnValue()
    {
        var addressInfo = "<%=AddressInfo %>";
        if(addressInfo != "")
        {
            window.returnValue = addressInfo;
        }
    }
    
    function PrevNext(strDirect) 
    {
        document.form1.action="quickAddClient.asp?dir=" + strDirect + "&orgNum=<%=vOrgNum %>";
	    document.form1.method="POST";
	    document.form1.target = window.name;
	    document.form1.submit();
    }
    
    function create_direct_xmlHTTP()
    {
	    if (window.ActiveXObject) {
	       try {
		    xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
	       } catch(e) {
			    try {
			     xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
			    } catch(e1) {
			     alert('Your browser does not support this method!\nPlease upgrade your browser.');				
			     return false;
			    }
	      }
	    } else if (window.XMLHttpRequest) {
		    xmlHTTP = new XMLHttpRequest();
	    } else {
			    alert('Your browser does not support this method!\nPlease upgrade your browser.');		
			    return false;
			    }
	    return xmlHTTP;
    }

    function check_org_data(cType,org,strDbaName,air_prefix)
    { 
	    var xmlHTTP = create_direct_xmlHTTP();
	    if(!xmlHTTP) { return false; }

	    var url = "/IFF_MAIN/asp/ajaxFunctions/ajax_chkdata_organization.asp" 
				    +"?t="+cType
				    +"&o="+org 
				    +"&s="+encodeURIComponent(strDbaName) 
				    +"&pre="+encodeURIComponent(air_prefix) ;

        xmlHTTP.open("get",url,false); 
        xmlHTTP.send(); 
        var sourceCode = xmlHTTP.responseText;
        if (sourceCode) {
		    if ( trim(sourceCode) == 'ok' ) {
			    return true;
		    } 
		    else {
				    switch(trim(sourceCode)) {
					    case 'error#0' :
								    alert('call type error!');
								    break;											
					    case 'error#1' :
								    alert('Invalid acct num for update!');
								    break;											
					    case 'error#2' :
								    alert('Invalid DBA name!');
								    break;											
					    case 'error#3' :
								    if(confirm('DBA Name [' + strDbaName + '] exists already.\nDo you want to save anyway?')) {
									    return true;
								    }
								    break;											
					    default		   :
								    var eStr = sourceCode.substring (0, sourceCode.indexOf(':'));
								    switch(eStr) {
									    case 'error#4' :
											    if(confirm('The Carrier Prefix (' 
												    + air_prefix 
												    + ') already being used by [' 
												    + sourceCode.substring (sourceCode.indexOf(':')+1) + '].' 
												    + '\nDo you want to save anyway?' )){ return true; }
											    break;											
									    case 'error#3' :
											    if(confirm('Please check the followings.\nThe DBA Name :\n=========================\n' 
											    + sourceCode.substring (sourceCode.indexOf(':')+1) + '' 
											    + '\n=========================\nexists already.\nDo you want to save anyway?' )){ return true; 	}
											    break;											
									    default		   :
										      alert(sourceCode);						  
										      break;
								    }			
						      break;
				    }			
				    return false;			
		    }
	    }
    }
    </script>

</head>
<body link="336699" vlink="336699" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"
    onload="javascript:window.name='ClientPopUp';" onUnload="sendReturnValue()">
    <input type="hidden" name="hOrgAcct" value="<%=vOrgNum %>" />
    <table width="92%" border="0" align="center" cellpadding="2" cellspacing="0">
        <tr>
            <td height="30" align="left" valign="middle" class="bodyheader" style="font-size: 14px">
                CLIENT QUICK ADD</td>
        </tr>
    </table>
    <table width="92%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#73beb6">
        <tr>
            <td>
                <form name="form1" method="post" action="">
                    <table width="100%" border="0" cellpadding="3" cellspacing="0" bordercolor="#73beb6"
                        class="border1px">
                        <tr bgcolor="D5E8CB">
                            <td height="8" colspan="6" align="center" valign="top" bgcolor="#ccebed" class="bodyheader">
                                <img src='../Images/left_arrow.gif' name="bNext" width="5" height="9" onClick="javascript:PrevNext('next');"
                                    style="cursor: hand">
                                &nbsp;&nbsp;&nbsp;&nbsp;
                                <img src='../Images/right_arrow.gif' name="bNext" width="5" height="9" onClick="javascript:PrevNext('prev');"
                                    style="cursor: hand">
                            </td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="#73beb6">
                            <td colspan="2" height="1" class="bodyheader">
                            </td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="f3f3f3">
                            <td height="22" align="right" bgcolor="f3f3f3" class="bodyheader">
                                Name(DBA)</td>
                            <td align="left">
                                <span class="bodyheader">
                                    <input name="txtDbaName" id="txtDbaName" class="shorttextfield" value="<%=vDbaName %>"
                                        size="64">
                                </span>
                            </td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="f3f3f3">
                            <td height="22" align="right" bgcolor="f3f3f3" class="bodyheader">
                                Address</td>
                            <td align="left">
                                <span class="bodyheader">
                                    <input name="txtAddress" class="shorttextfield" id="txtAddress" value="<%=vAddress %>"
                                        size="64">
                                </span>
                            </td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="f3f3f3">
                            <td height="22" align="right" bgcolor="f3f3f3" class="bodyheader">
                                Address 2</td>
                            <td align="left">
                                <span class="bodyheader">
                                    <input name="txtAddress2" class="shorttextfield" id="txtAddress2" value="<%=vAddress2 %>"
                                        size="64">
                                </span>
                            </td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="f3f3f3">
                            <td height="22" align="right" bgcolor="f3f3f3" class="bodyheader">
                                City</td>
                            <td align="left">
                                <span class="bodyheader">
                                    <input name="txtCity" class="shorttextfield" id="txtCity" value="<%=vCity %>" size="24">
                                </span>
                            </td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="f3f3f3">
                            <td height="22" align="right" bgcolor="f3f3f3" class="bodyheader">
                                State/Province</td>
                            <td align="left">
                                <select name="lstState" size="1" class="smallselect" style="width: 150px" onChange="javascript:lstStateChange(this)">
                                    <% for i=0 to aStateIndex-1 %>
                                    <option value="<%=aStateCode(i)%>" <%if astatecode(i) = vstate then response.write("selected") %>>
                                        <%= aStateName(i) %>
                                    </option>
                                    <% next %>
                                </select>
                            </td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="f3f3f3">
                            <td height="22" align="right" bgcolor="f3f3f3" class="bodyheader">
                                Zip/Postal</td>
                            <td align="left">
                                <input name="txtZip" class="shorttextfield" id="txtZip" value="<%=vZip %>" size="20"></td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="f3f3f3">
                            <td height="22" align="right" bgcolor="f3f3f3" class="bodyheader">
                                Country</td>
                            <td align="left">
                                <select name="lstCountry" size="1" class="smallselect" style="width: 150px">
                                    <option value='0'></option>
                                    <% for i=0 to aConIndex-1 %>
                                    <option value="<%=aCountryCodeArry(i)%>" <%if acountrycodearry(i) = vcountry then response.write("selected") %>>
                                        <%= aCountryArry(i) %>
                                    </option>
                                    <% next %>
                                </select>
                            </td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="f3f3f3">
                            <td height="22" align="right" bgcolor="f3f3f3" class="bodyheader">
                            </td>
                            <td align="left">
                                <span class="bodyheader">Primary Contact Info</span></td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="f3f3f3">
                            <td height="22" align="right" bgcolor="f3f3f3" class="bodyheader">
                                Name</td>
                            <td align="left">
                                <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                    <tr>
                                        <td class="bodycopy">
                                            First Name</td>
                                        <td class="bodycopy">
                                            M.I.</td>
                                        <td class="bodycopy">
                                            Last Name</td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <input name="txtFirstName" type="text" id="txtFirstName" class="m_shorttextfield"
                                                style="width: 85px;" value="<%=vFirstName %>" /></td>
                                        <td>
                                            <input name="txtMiddleName" type="text" id="txtMiddleName" class="m_shorttextfield"
                                                style="width: 30px;" value="<%=vMiddleName %>" /></td>
                                        <td>
                                            <input name="txtLastName" type="text" id="txtLastName" class="m_shorttextfield" style="width: 85px;"
                                                value="<%=vLastName %>" /></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="f3f3f3">
                            <td height="22" align="right" bgcolor="f3f3f3" class="bodyheader">
                                Phone</td>
                            <td align="left">
                                <input name="txtPhone" type="text" value="<%=vPhone %>" id="txtPhone" class="m_shorttextfield"
                                    style="width: 175px;" /></td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="f3f3f3">
                            <td height="22" align="right" bgcolor="f3f3f3" class="bodyheader">
                                Fax</td>
                            <td align="left">
                                <input name="txtFax" type="text" value="<%=vFax %>" id="txtFax" class="m_shorttextfield"
                                    style="width: 175px;" /></td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="f3f3f3">
                            <td height="22" align="right" bgcolor="f3f3f3" class="bodyheader">
                                Cell</td>
                            <td align="left">
                                <input name="txtCell" type="text" value="<%=vCell %>" id="txtCell" class="m_shorttextfield"
                                    style="width: 175px;" /></td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="f3f3f3">
                            <td width="7%" height="22" align="right" bgcolor="f3f3f3" class="bodyheader">
                                Email</td>
                            <td width="67%" align="left">
                                <input name="txtEmail" type="text" id="txtEmail" class="m_shorttextfield" value="<%=vEmail %>"
                                    style="width: 175px;" /></td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="f3f3f3">
                            <td height="22" align="right" bgcolor="f3f3f3" class="bodyheader">
                                Tax ID/USPPI</td>
                            <td align="left">
                                <span class="bodyheader">
                                    <input name="txtTaxId" class="shorttextfield" id="txtTaxId" value="<%=vTaxId %>"
                                        size="20" maxlength="16">
                                </span>
                            </td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="f3f3f3">
                            <td height="22" align="right" bgcolor="f3f3f3" class="bodyheader">
                                Class</td>
                            <td align="left">
                                <div id="lstClassDiv">
                                    <select id="lstClass" name="lstClass" onChange="editClass(this);" class="bodycopy" style="width: 180px">
                                        <%=gather_list_all(1) %>
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <script type="text/javascript">setClassCode();</script>
                        <tr align="center" bgcolor="D5E8CB">
                            <td height="20" colspan="6" valign="middle" bgcolor="#ccebed" class="bodycopy">
                                
                                <input type="button" class="bodycopy" id="Button1" style="width: 100px;" value="Update Client" onClick="javascript:saveClient();" />
                                <input type="button" class="bodycopy" id="Button2" style="width: 100px;" value="Save as New" onClick="javascript:saveAsNewClient();" /> 
                                <input type="button" class="bodycopy" id="Button3" style="width: 80px;" onClick="javascript:window.close();" value="Close" />
                                <input type="button" class="bodycopy" id="Button4" style="width: 80px;" onClick="javascript:ResetClient();" value="New Client" /></td>
                        </tr>
                    </table>
                    <div id="wAdd" style="display: block; position: absolute; top: 135px; left: 303px;
                        width: 128px; background-color: #FFFFFF; layer-background-color: #FFFFFF; border: 1px none #000000;
                        height: 20;">
                        <table width="128" border="0" cellpadding="1" cellspacing="0" bordercolor="#D4D0C8"
                            class="border1px">
                            <tr>
                                <td height="18" align="center" valign="middle" bgcolor="#ccebed" class="bodyheader">
                                    Business Type
                                </td>
                            </tr>
                            <tr>
                                <td height="1" align="left" valign="middle" bgcolor="#666666" class="bodycopy">
                                </td>
                            </tr>
                            <tr>
                                <td align="left" class="bodycopy" valign="middle">
                                    <input id="chkConsignee" type="checkbox" name="chkConsignee" <%if UCase(oldconsignee) = "Y" then response.write("checked") %> value="" /><label
                                        for="chkConsignee">Consignee</label></td>
                            </tr>
                            <tr>
                                <td align="left" class="bodycopy" valign="middle">
                                    <input id="chkShipper" type="checkbox" name="chkShipper" <%if UCase(oldshipper) = "Y" then response.write("checked") %> /><label
                                        for="chkShipper">Shipper</label></td>
                            </tr>
                            <tr>
                                <td align="left" class="bodycopy" valign="middle">
                                    <input id="chkAgent" type="checkbox" name="chkAgent" <%if UCase(oldagent) = "Y" then response.write("checked") %> /><label
                                        for="chkAgent">Agent</label></td>
                            </tr>
                            <tr>
                                <td align="left" class="bodycopy" style="height: 20px" valign="middle">
                                    <input id="chkCarrier" type="checkbox" name="chkCarrier" <%if UCase(oldcarrier) = "Y" then response.write("checked") %> disabled="disabled" /><label
                                        for="chkCarrier">Carrier</label></td>
                            </tr>
                            <tr>
                                <td align="left" class="bodycopy" style="height: 20px" valign="middle">
                                    <input id="chkTrucker" type="checkbox" name="chkTrucker" <%if UCase(oldtrucker) = "Y" then response.write("checked") %> /><label
                                        for="chkTrucker">Trucker</label></td>
                            </tr>
                            <tr>
                                <td align="left" class="bodycopy" style="height: 20px" valign="middle">
                                    <input id="chkWarehousing" type="checkbox" name="chkWarehousing" <%if UCase(oldwarehousing) = "Y" then response.write("checked") %> /><label
                                        for="chkWarehousing">Warehouse</label></td>
                            </tr>
                            <tr>
                                <td align="left" class="bodycopy" style="height: 20px" valign="middle">
                                    <input id="chkCFS" type="checkbox" name="chkCFS" <%if UCase(oldcfs) = "Y" then response.write("checked") %> /><label
                                        for="chkCFS">Terminal/CFS</label></td>
                            </tr>
                            <tr>
                                <td align="left" class="bodycopy" style="height: 20px" valign="middle">
                                    <input id="chkBroker" type="checkbox" name="chkBroker" <%if UCase(oldbroker) = "Y" then response.write("checked") %> /><label
                                        for="chkBroker">CHB</label></td>
                            </tr>
                            <tr>
                                <td align="left" class="bodycopy" style="height: 20px" valign="middle">
                                    <input id="chkGovt" type="checkbox" name="chkGovt" <%if UCase(oldgovt) = "Y" then response.write("checked") %> /><label
                                        for="chkGovt">Gov't</label></td>
                            </tr>
                            <tr>
                                <td align="left" class="bodycopy" style="height: 20px" valign="middle">
                                    <input id="chkVendor" type="checkbox" name="chkVendor" <%if UCase(oldvendor) = "Y" then response.write("checked") %> /><label
                                        for="chkVendor">Vendor</label></td>
                            </tr>
                            <tr>
                                <td align="left" class="bodycopy" style="height: 20px" valign="middle">
                                    <input id="chkSpecial" type="checkbox" name="chkSpecial" <%if UCase(oldspecial) = "Y" then response.write("checked") %> /><label
                                        for="chkSpecial">Other</label></td>
                            </tr>
                        </table>
                    </div>
                </form>
            </td>
        </tr>
    </table>
</body>
</html>
<%
    Set rs = Nothing
    Set eltConn = Nothing
%>
